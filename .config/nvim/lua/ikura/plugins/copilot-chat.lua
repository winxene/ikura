local status_ok, copilot_chat = pcall(require, "CopilotChat")
if not status_ok then
  return
end

copilot_chat.setup({
  debug = true, -- Set to true to see the response from GitHub Copilot API
  -- The log file will be in ~/.local/state/nvim/CopilotChat.nvim.log
})