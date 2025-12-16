-- Fuzzy Finder
return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    {
      '<leader>f',
      function()
        require('fzf-lua').files()
      end,
      desc = '[F]iles',
    },
    {
      '<leader>/',
      function()
        require('fzf-lua').live_grep()
      end,
      desc = '[/] Live Grep',
    },
    {
      '<leader><space>',
      function()
        require('fzf-lua').buffers { sort_mru = true, sort_lastused = true }
      end,
      desc = '[ ] Buffers',
    },
  },
  cmd = { 'FzfLua' },
  opts = {},
}
