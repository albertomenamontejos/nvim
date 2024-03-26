require("mason").setup()
require("mason-lspconfig").setup()

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Configure language servers
local lspconfig = require("lspconfig")

local servers = {
	{ "clangd" },
	{ "cmake" },
	{ "eslint" },
	{ "gopls" },
	{ "jdtls" },
	{ "intelephense", {
		cmd = { "env", "HOME=/tmp", "intelephense", "--stdio" },
	} },
	{ "svelte" },
	{ "tsserver" },
	{ "lemminx" },
	{ "lua_ls" },
	--	{ "unocss" },
	{ "volar" },
	{ "pyright" },
	{ "cssls" },
	{ "html" },
	{ "emmet_ls" },
}

for _, server in ipairs(servers) do
	local server_name = server[1]
	local server_config = {
		capabilities = capabilities,
	}
	if #server == 2 then
		for k, v in pairs(server[2]) do
			server_config[k] = v
		end
	end
	lspconfig[server_name].setup(server_config)
end

lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim", "require" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

lspconfig.html.setup({
	filetypes = {
		"html",
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
})

lspconfig.emmet_ls.setup({
	init_options = {
		html = {
			options = {
				-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
				["bem.enabled"] = true,
			},
		},
	},
})

lspconfig.jdtls.setup({
	filetypes = {"java", "jsp" }
})

-- Disable semantic highlight
local disable_semantic_highlight = function()
	local compl = vim.fn.getcompletion("@lsp", "highlight")
	for _, group in ipairs(compl) do
		vim.api.nvim_set_hl(0, group, {})
	end
end
vim.api.nvim_create_autocmd("ColorScheme", {
	desc = "Disable semantic highlights",
	callback = disable_semantic_highlight,
})
disable_semantic_highlight()

vim.keymap.set("n", "gA", function()
	require("fzf-lua").lsp_code_actions({
		previewer = false,
		winopts = { height = 0.33, width = 0.5 },
	})
end)

-- Key mappings
vim.keymap.set("n", "gp", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
		local opts = { buffer = ev.buf }

		vim.keymap.set("n", "gt", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
	end,
})

-- luasnip
local luasnip = require("luasnip")
vim.keymap.set({ "i", "s" }, "<C-L>", function()
	luasnip.jump(1)
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-K>", function()
	luasnip.jump(0)
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-J>", function()
	luasnip.jump(-1)
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-E>", function()
	if luasnip.choice_active() then
		luasnip.change_choice(1)
	end
end, { silent = true })

-- cmp for completion engine
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	}, {
		{ name = "buffer" },
	}),
	mapping = {
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
})

local ccc = require("ccc")
ccc.setup({
	opts = {},
	cmd = { "CccPick", "CccConvert", "CccHighlighterEnable", "CccHighlighterDisable", "CccHighlighterToggle" },
	keys = {
		{ "<leader>zp", "<cmd>CccPick<cr>", desc = "Pick" },
		{ "<leader>zc", "<cmd>CccConvert<cr>", desc = "Convert" },
		{ "<leader>zh", "<cmd>CccHighlighterToggle<cr>", desc = "Toggle Highlighter" },
	},
})
