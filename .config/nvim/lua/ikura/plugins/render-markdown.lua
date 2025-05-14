local setup, render_markdown = pcall(require, "render-markdown")
if not setup then
  return
end

render_markdown.setup({
  completions = { lsp = { enabled = true } },
)
