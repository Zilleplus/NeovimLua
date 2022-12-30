local lsp = require('lsp-zero')

lsp.ensure_installed({
  'clangd',
  'sumneko_lua',
  'pyls'
})

lsp.preset('recommended')

-- no icons
lsp.set_preferences({
  suggest_lsp_servers = false,
  set_lsp_keymaps = false,
  sign_icons = {
    error = 'E',
    warn = 'W',
    hint = 'H',
    info = 'I'
  }
})

local set_lsp_keymaps = function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
  vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>cf', function() vim.lsp.buf.format { async = true } end, opts)
end
lsp.on_attach(set_lsp_keymaps)

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Insert }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ["<Tab>"] = cmp.mapping.select_next_item(cmp_select),
  ["<S-Tab>"] = cmp.mapping.select_prev_item(cmp_select),
})

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

-- clangd has language specific stuff, so we use a custom steup
local clangd = lsp.build_options('clangd', {}) -- disable the normal setup

lsp.configure('pylsp', {
  force_setup = true,
  settings = {
    pylsp = {
      plugins = {
        dmypy = { enabled = true },
        --pylint = { enabled = true },
        -- flake8 = { enabled = false },
        -- pycodestyle = { enabled = false },
        -- pyflakes = { enabled = false },
      }
    }
  }
})

lsp.setup() --needs to be called after mappings have been modified


vim.diagnostic.config({ -- needs to be called after lsp.config()
  virtual_text = true,
})

-- vim.lsp.set_log_level("debug") -- enable me if you're in trouble

-- manual setup of pylsp
--require('lspconfig').pylsp.setup{
--  on_attach=set_lsp_keymaps,
--  settings = {
--    pylsp = {
--      plugins = {
--        -- Somehow  the mypy plugin doesn't get activated,
--        -- I have no idea why.
--        dmypy = { enabled = true },
--        -- pylint = { enabled = true },
--        -- flake8 = { enabled = false },
--        -- pycodestyle = { enabled = false },
--        -- pyflakes = { enabled = false },
--      }
--    }
--  }
--}

require("clangd_extensions").setup { -- needs to be called after lsp.config()

  server = {
    -- options to pass to nvim-lspconfig
    -- i.e. the arguments to require("lspconfig").clangd.setup({})
    filetypes = { "c", "cpp", "h", "hpp" },
    -- on_attach = set_keymaps
    on_attach = set_lsp_keymaps
  },
  extensions = {
    -- defaults:
    -- Automatically set inlay hints (type hints)
    autoSetHints = false, -- it's already provided by the lps-inlayhints plugin
    -- These apply to the default ClangdSetInlayHints command
    inlay_hints = {
      -- Only show inlay hints for the current line
      only_current_line = false,
      -- Event which triggers a refersh of the inlay hints.
      -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
      -- not that this may cause  higher CPU usage.
      -- This option is only respected when only_current_line and
      -- autoSetHints both are true.
      only_current_line_autocmd = "CursorHold",
      -- whether to show parameter hints with the inlay hints or not
      show_parameter_hints = true,
      -- prefix for parameter hints
      parameter_hints_prefix = "<- ",
      -- prefix for all the other hints (type, chaining)
      other_hints_prefix = "=> ",
      -- whether to align to the length of the longest line in the file
      max_len_align = false,
      -- padding from the left if max_len_align is true
      max_len_align_padding = 1,
      -- whether to align to the extreme right or not
      right_align = false,
      -- padding from the right if right_align is true
      right_align_padding = 7,
      -- The color of the hints
      highlight = "Comment",
      -- The highlight group priority for extmark
      priority = 100,
    },
    ast = {
      -- These are unicode, should be available in any font
      role_icons = {
        type = "T",
        declaration = "D",
        expression = "E",
        statement = ";",
        specifier = "S",
        ["template argument"] = "T",
      },
      kind_icons = {
        Compound = "c",
        Recovery = "r",
        TranslationUnit = "u",
        PackExpansion = "p",
        TemplateTypeParm = "t",
        TemplateTemplateParm = "t",
        TemplateParamObject = "t",
      },
      --[[ These require codicons (https://github.com/microsoft/vscode-codicons)
            role_icons = {
                type = "",
                declaration = "",
                expression = "",
                specifier = "",
                statement = "",
                ["template argument"] = "",
            },

            kind_icons = {
                Compound = "",
                Recovery = "",
                TranslationUnit = "",
                PackExpansion = "",
                TemplateTypeParm = "",
                TemplateTemplateParm = "",
                TemplateParamObject = "",
            }, ]]

      highlights = {
        detail = "Comment",
      },
    },
    memory_usage = {
      border = "none",
    },
    symbol_info = {
      border = "none",
    },
  },
}
