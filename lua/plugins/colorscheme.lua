return {

  -- catppuccin
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    opts = {
      lsp_styles = {
        underlines = {
          errors = { 'undercurl' },
          hints = { 'undercurl' },
          warnings = { 'undercurl' },
          information = { 'undercurl' },
        },
      },
      auto_integrations = true,
    },
  },

  -- tokyonight
  {
    'folke/tokyonight.nvim',
    priority = 1000,
  },
}
