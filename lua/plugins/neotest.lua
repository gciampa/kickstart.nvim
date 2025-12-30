-- Test runner (LazyVim style keybindings)
return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'olimorris/neotest-rspec',
  },
  keys = {
    { '<leader>tt', function() require('neotest').run.run(vim.fn.expand('%')) end, desc = 'Run file' },
    { '<leader>tT', function() require('neotest').run.run(vim.fn.getcwd()) end, desc = 'Run all test files' },
    { '<leader>tr', function() require('neotest').run.run() end, desc = 'Run nearest' },
    { '<leader>tl', function() require('neotest').run.run_last() end, desc = 'Run last' },
    { '<leader>ts', function() require('neotest').summary.toggle() end, desc = 'Toggle summary' },
    { '<leader>to', function() require('neotest').output.open({ enter = true }) end, desc = 'Show output' },
    { '<leader>tO', function() require('neotest').output_panel.toggle() end, desc = 'Toggle output panel' },
    { '<leader>tS', function() require('neotest').run.stop() end, desc = 'Stop' },
    { '<leader>tw', function() require('neotest').watch.toggle(vim.fn.expand('%')) end, desc = 'Toggle watch' },
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-rspec',
      },
      status = { virtual_text = true },
      output = { open_on_run = true },
    }
  end,
}
