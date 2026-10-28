local severity = vim.diagnostic.severity

vim.diagnostic.config({
  severity_sort = true,
  signs = {
    priority = 20,
    text = {
      [severity.ERROR] = "",
      [severity.WARN] = "",
      [severity.INFO] = "",
      [severity.HINT] = "󰌵",
    },
  },
})
