local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

--config.window_decorations = "TITLE | RESIZE | INTEGRATED_BUTTONS"
config.enable_wayland = true
config.color_scheme = 'Snazzy'
config.font_size = 10
config.font = wezterm.font 'FiraCode Nerd Font'
config.font = wezterm.font_with_fallback {
 'Hack Nerd Font',
 'Lilex Nerd',
 'Font Awesome 6 Free'
}
config.keys = {
    {key="E", mods="CTRL",
     action=wezterm.action{QuickSelectArgs={
       patterns={
          "https?://\\S+"
       },
       action = wezterm.action_callback(function(window, pane)
          local url = window:get_selection_text_for_pane(pane)
          local sanitized_url = url:gsub("[¬\"]", "") --
--          local sanitized_url = url:gsub("¬", "") --
          wezterm.log_info("url: " .. url)
          wezterm.log_info("opening: " .. sanitized_url)
          wezterm.open_with(sanitized_url, 'firefox')
       end)
     }}
   },
}
config.default_prog = { 'nu', '-l' }
return config
