-- Resolve dynamic picker options when a shortcut is pressed, not at startup.
local function picker(name, options)
  return function()
    local opts = type(options) == "function" and options() or options
    require("telescope.builtin")[name](opts or {})
  end
end

local function project_options()
  return { cwd = require("config.project").root() }
end

local function directory_options()
  local path = vim.api.nvim_buf_get_name(0)
  local cwd = path ~= "" and vim.bo.buftype == "" and vim.fs.dirname(path) or vim.fn.getcwd()
  return { cwd = cwd }
end

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = "Telescope",
    keys = {
      -- File and project navigation, following Doom's leader layout.
      { "<leader>ff", picker("find_files", directory_options), desc = "Find file" },
      { "<leader>.", picker("find_files", directory_options), desc = "Find file" },
      { "<leader>fr", picker("lsp_references", { jump_type = "never" }), desc = "Search symbol references" },
      { "<leader>pf", picker("find_files", project_options), desc = "Find file in project" },
      { "<leader><space>", picker("find_files", project_options), desc = "Find file in project" },
      { "<leader>bb", picker("buffers"), desc = "Switch buffer" },
      { "<leader>,", picker("buffers"), desc = "Switch buffer" },
      { "<leader>'", picker("resume"), desc = "Resume last search" },
      { "<leader>:", picker("commands"), desc = "Run command" },
      -- Search the current buffer or the project through Telescope.
      { "<leader>ss", picker("current_buffer_fuzzy_find"), desc = "Search current buffer" },
      { "<leader>sb", picker("current_buffer_fuzzy_find"), desc = "Search current buffer" },
      {
        "<leader>sS",
        picker("current_buffer_fuzzy_find", function()
          return { default_text = vim.fn.expand("<cword>") }
        end),
        desc = "Search buffer for symbol at cursor",
      },
      { "<leader>sp", picker("live_grep", project_options), desc = "Search project" },
      { "<leader>/", picker("live_grep", project_options), desc = "Search project" },
      { "<leader>sd", picker("live_grep", directory_options), desc = "Search current directory" },
      { "<leader>*", picker("grep_string", project_options), desc = "Search project for symbol at cursor" },
      { "<leader>si", picker("lsp_document_symbols"), desc = "Jump to buffer symbol" },
      { "<leader>cj", picker("lsp_dynamic_workspace_symbols"), desc = "Jump to workspace symbol" },
      { "<leader>sj", picker("jumplist"), desc = "Jump list" },
      { "<leader>sr", picker("marks"), desc = "Jump to mark" },
      -- Diagnostic pickers work for both LSP and standalone linters.
      {
        "<leader>cx",
        picker("diagnostics", { severity_limit = vim.diagnostic.severity.WARN, sort_by = "severity" }),
        desc = "List errors and warnings",
      },
      {
        "<leader>cX",
        picker("diagnostics", { bufnr = 0, severity_limit = vim.diagnostic.severity.WARN, sort_by = "severity" }),
        desc = "List buffer errors and warnings",
      },
      { "<leader>gg", picker("git_status"), desc = "Git status" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "%.git/" },
        },
        pickers = {
          find_files = { hidden = true },
          live_grep = {
            additional_args = function()
              return { "--hidden", "-g", "!.git" }
            end,
          },
        },
      })
      require("telescope").load_extension("fzf")
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    keys = {
      { "<leader>op", "<cmd>Neotree toggle<CR>", desc = "Toggle project sidebar" },
      { "<leader>oP", "<cmd>Neotree reveal<CR>", desc = "Find current file in sidebar" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      close_if_last_window = true,
      filesystem = {
        follow_current_file = { enabled = true },
        filtered_items = { hide_dotfiles = false },
      },
    },
  },
}
