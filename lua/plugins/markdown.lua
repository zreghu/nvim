local function markdown_paths(bufnr)
  local file = vim.api.nvim_buf_get_name(bufnr or 0)
  if file == "" then
    vim.notify("Save the Markdown file before building a PDF", vim.log.levels.WARN)
    return
  end

  local source_dir = vim.fs.dirname(file)
  local makefile = vim.fs.find({ "GNUmakefile", "Makefile", "makefile" }, {
    path = source_dir,
    upward = true,
    type = "file",
  })[1]
  local build_dir = makefile and vim.fs.dirname(makefile) or source_dir
  local pdf = vim.fs.joinpath(build_dir, vim.fn.fnamemodify(file, ":t:r") .. ".pdf")
  return file, build_dir, pdf, makefile ~= nil
end

local function build_pdf(bufnr)
  local file, build_dir, pdf, has_makefile = markdown_paths(bufnr)
  if not file then
    return
  end

  local command
  if has_makefile then
    command = { "make" }
  else
    command = { "pandoc", file, "--output", pdf }
  end

  vim.system(command, { cwd = build_dir, text = true }, function(result)
    vim.schedule(function()
      if result.code == 0 then
        if vim.uv.fs_stat(pdf) then
          vim.notify("Built " .. pdf)
        else
          vim.notify("Build finished, but expected PDF was not found: " .. pdf, vim.log.levels.WARN)
        end
      else
        local detail = (result.stderr ~= "" and result.stderr) or result.stdout or ""
        vim.notify("PDF build failed (exit " .. result.code .. "): " .. detail, vim.log.levels.ERROR)
      end
    end)
  end)
end

local function view_pdf()
  local _, _, pdf = markdown_paths()
  if not pdf then
    return
  end
  if not vim.uv.fs_stat(pdf) then
    vim.notify("PDF not found. Build it with <Space> m c first: " .. pdf, vim.log.levels.WARN)
    return
  end
  vim.system({ "xdg-open", pdf })
end

local group = vim.api.nvim_create_augroup("user-markdown-pdf", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  group = group,
  pattern = { "*.md", "*.markdown" },
  callback = function(event)
    if vim.bo[event.buf].filetype == "markdown" then
      build_pdf(event.buf)
    end
  end,
})

return {
  {
    "stevearc/conform.nvim",
    keys = {
      {
        "<leader>mf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        ft = "markdown",
        desc = "Format Markdown",
      },
      {
        "<leader>mc",
        function()
          if vim.bo.modified then
            vim.cmd.write()
          else
            build_pdf()
          end
        end,
        ft = "markdown",
        desc = "Build Markdown PDF",
      },
      {
        "<leader>mv",
        view_pdf,
        ft = "markdown",
        desc = "View Markdown PDF",
      },
    },
  },
}
