local devicons_setup, devicons = pcall(require, "nvim-web-devicons")
if not devicons_setup then
  return
end

devicons.setup({
  default = true, 
})