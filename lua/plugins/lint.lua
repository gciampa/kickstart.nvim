return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      -- Custom slim-lint linter (not built into nvim-lint)
      lint.linters.slim_lint = {
        cmd = 'slim-lint',
        stdin = false,
        args = { '--reporter', 'json' },
        stream = 'stdout',
        ignore_exitcode = true,
        parser = function(output, bufnr)
          if output == '' then
            return {}
          end
          local ok, decoded = pcall(vim.json.decode, output)
          if not ok then
            return {}
          end
          local diagnostics = {}
          for _, file in ipairs(decoded.files or {}) do
            for _, offense in ipairs(file.offenses or {}) do
              table.insert(diagnostics, {
                lnum = (offense.location and offense.location.line or 1) - 1,
                col = 0,
                message = offense.message,
                severity = offense.severity == 'error' and vim.diagnostic.severity.ERROR or vim.diagnostic.severity.WARN,
                source = 'slim-lint',
              })
            end
          end
          return diagnostics
        end,
      }

      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        slim = { 'slim_lint' },
        eruby = { 'erb_lint' },
      }

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['json'] = nil
      -- lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['text'] = nil

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          -- Only run the linter in buffers that you can modify in order to
          -- avoid superfluous noise, notably within the handy LSP pop-ups that
          -- describe the hovered symbol using Markdown.
          if vim.bo.modifiable then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
