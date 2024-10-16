local wezterm = require 'wezterm'

function tf_workspace_name(dir)
  for i=0,2 do
    local dots = ""
    for dot_add=1,i do
      dots = dots .. "../"
    end
    local test_file_path = dir .. "/" .. dots .. ".terraform/environment"
    local f = io.open(test_file_path, "r")
    if f ~= nil then
      local env_name = f:read("*all")
      return env_name
    end
  end
end

wezterm.on("update-status", function(window, pane)
  local RIGHT_ARROW = utf8.char(0xe0b1)
  local user_vars = pane:get_user_vars()
  local cells = {}

  -- TF workspace
  local workspace_name = tf_workspace_name(pane:get_current_working_dir().file_path)
  if workspace_name then
    table.insert(cells, {Foreground = {Color = "white"}})
    table.insert(cells, {Background = {Color = "#7b42bc"}})
    table.insert(cells, {Text = " " .. workspace_name .. " "})
  end

  -- GOVUK_ENV
  local govuk_env = user_vars.govuk_env
  if govuk_env ~= nil then
    table.insert(cells, {Foreground = {Color = "black"}})
    table.insert(cells, {Background = {Color = "#ff9900"}})
    table.insert(cells, {Text = " " .. govuk_env .. " "})
  end

  window:set_right_status(wezterm.format(cells))
end)

local config = {}

config.use_fancy_tab_bar = false

return config
