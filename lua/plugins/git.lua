return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = false,
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Git change")
        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Previous Git change")
        -- Doom's direct Git actions; gh keeps the extended hunk tools together.
        map("n", "<leader>gs", gs.stage_hunk, "Stage/unstage change")
        map("n", "<leader>gr", gs.reset_hunk, "Reset change")
        map("n", "<leader>gB", gs.blame, "Git blame")
        map("n", "<leader>g]", function() gs.nav_hunk("next") end, "Next Git change")
        map("n", "<leader>g[", function() gs.nav_hunk("prev") end, "Previous Git change")
        map("x", "<leader>gs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage selected lines")
        map("x", "<leader>gr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset selected lines")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview change")
        map("n", "<leader>ghs", gs.stage_hunk, "Stage/unstage change")
        map("n", "<leader>ghr", gs.reset_hunk, "Reset change")
        map("n", "<leader>ghb", gs.blame_line, "Blame line")
        map("n", "<leader>ghd", require("config.git").toggle_diff, "Toggle Git diff")
        map("x", "<leader>ghs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage selected lines")
        map("x", "<leader>ghr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset selected lines")
      end,
    },
  },
}
