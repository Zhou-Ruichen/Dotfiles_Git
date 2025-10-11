-- ~/.wezterm.lua (最终版)
local wezterm = require("wezterm")
local act = wezterm.action

------------------------------------------------------------
-- Platform-aware defaults
------------------------------------------------------------
local is_mac     = wezterm.target_triple:find("darwin")   ~= nil
local is_windows = wezterm.target_triple:find("windows")  ~= nil
local is_linux   = (not is_mac) and (not is_windows)

-- Default shell per platform
local default_prog = {}
if is_mac then
  default_prog = {"/bin/zsh", "-l"}
elseif is_windows then
  -- 您可以根据偏好在 "pwsh.exe" 和 "wsl.exe" 之间切换
  default_prog = {"pwsh.exe"}
else -- linux
  default_prog = {"/bin/bash", "-l"}
end

------------------------------------------------------------
-- Main Configuration Table
------------------------------------------------------------
local M = {
  font = wezterm.font_with_fallback({
    "JetBrainsMono Nerd Font", "Menlo", "Consolas", "DejaVu Sans Mono",
  }),
  font_size = 13.0,
  line_height = 1.2,
  color_scheme = "Tokyo Night",
  hide_tab_bar_if_only_one_tab = true,
  window_background_opacity = 0.95,
  text_background_opacity = 1.0,
  window_decorations = "RESIZE",
  window_close_confirmation = "NeverPrompt",
  inactive_pane_hsb = { saturation = 1.0, brightness = 0.80 },
  window_padding = { left = 6, right = 6, top = 6, bottom = 6 },
  scrollback_lines = 10000,
  audible_bell = "Disabled",
  default_prog = default_prog,
  default_cwd = wezterm.home_dir,

  -- --- [新增] 状态栏 ---
  -- 启用状态栏并设置更新频率（毫秒）
  status_update_interval = 1000,

  ssh_domains = {
    {
      name = "zerotier",
      remote_address = "192.168.192.1:55905",
      username = "ruichen",
      multiplexing = "WezTerm",
      -- [新增] 精确指定远程服务器启动的命令
      -- 这会告诉 wezterm-server 明确地以 "login" 模式启动 zsh
      remote_prog = {"wezterm-server", "start", "--", "zsh", "-l"},
    },
    {
      name = "tailscale",
      remote_address = "100.100.1.1:55905",
      username = "ruichen",
      multiplexing = "WezTerm",
      -- 如果 tailscale 也有同样问题，也请加上下面这行
      -- remote_prog = {"wezterm-server", "start", "--", "zsh", "-l"},
    },
    -- 您之前配置的 Precision-Tower 服务器也可能需要加上
    {
      name = "Precision-Tower",
      remote_address = "117.68.10.96:43431",
      username = "ruichen",
      multiplexing = "WezTerm",
      -- 加上这一行以防万一
      remote_prog = {"wezterm-server", "start", "--", "zsh", "-l"},
    }
  },

  keys = {
    {key="t", mods=is_mac and "CMD" or "CTRL|SHIFT", action=act.SpawnTab("CurrentPaneDomain")},
    {key="w", mods=is_mac and "CMD" or "CTRL|SHIFT", action=act.CloseCurrentTab({confirm=true})},
    {key="Tab", mods="CTRL|SHIFT", action=act.ActivateTabRelative(1)},
    {key="Tab", mods="CTRL",        action=act.ActivateTabRelative(-1)},
    {key="d", mods=is_mac and "CMD" or "CTRL|SHIFT", action=act.SplitHorizontal({domain="CurrentPaneDomain"})},
    {key="D", mods=is_mac and "CMD" or "CTRL|SHIFT", action=act.SplitVertical({domain="CurrentPaneDomain"})},
    {key="LeftArrow",  mods=is_mac and "CMD|ALT" or "CTRL|ALT", action=act.ActivatePaneDirection("Left")},
    {key="RightArrow", mods=is_mac and "CMD|ALT" or "CTRL|ALT", action=act.ActivatePaneDirection("Right")},
    {key="UpArrow",    mods=is_mac and "CMD|ALT" or "CTRL|ALT", action=act.ActivatePaneDirection("Up")},
    {key="DownArrow",  mods=is_mac and "CMD|ALT" or "CTRL|ALT", action=act.ActivatePaneDirection("Down")},
    {key="LeftArrow",  mods=(is_mac and "CMD|ALT|SHIFT" or "CTRL|ALT|SHIFT"), action=act.AdjustPaneSize({"Left",  3})},
    {key="RightArrow", mods=(is_mac and "CMD|ALT|SHIFT" or "CTRL|ALT|SHIFT"), action=act.AdjustPaneSize({"Right", 3})},
    {key="UpArrow",    mods=(is_mac and "CMD|ALT|SHIFT" or "CTRL|ALT|SHIFT"), action=act.AdjustPaneSize({"Up",    2})},
    {key="DownArrow",  mods=(is_mac and "CMD|ALT|SHIFT" or "CTRL|ALT|SHIFT"), action=act.AdjustPaneSize({"Down",  2})},
    {key="f", mods=is_mac and "CMD" or "CTRL|SHIFT", action="ToggleFullScreen"},
    {key="p", mods=is_mac and "CMD|SHIFT" or "CTRL|SHIFT", action=act.ActivateCommandPalette},
    {key="l", mods=is_mac and "CMD|SHIFT" or "CTRL|SHIFT", action=act.ShowLauncher},
  },

  use_fancy_tab_bar = true,
  enable_tab_bar = false,

  mouse_bindings = {
    {
      event = { Up = { streak = 1, button = "Left" } },
      mods = "NONE",
      action = act.CompleteSelection("ClipboardAndPrimarySelection"),
    },
    {
      event = { Up = { streak = 1, button = "Right" } },
      mods = "NONE",
      action = act.PasteFrom("Clipboard"),
    },
  },

  colors = {
    tab_bar = {
      active_tab = { bg_color = "#565f89", fg_color = "#c0caf5" },
      inactive_tab = { bg_color = "#1e1e2e", fg_color = "#a9b1d6" },
      new_tab = { bg_color = "#1e1e2e", fg_color = "#a9b1d6" },
    },
  },

  default_cursor_style = "BlinkingBlock",
}

------------------------------------------------------------
-- Event Handlers (Functions)
------------------------------------------------------------

-- 智能标签页标题 (显示当前路径)
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane
  local title = pane.title
  if pane.current_working_dir and pane.current_working_dir.path then
    title = wezterm.basename(pane.current_working_dir.path)
  end
  local inactive = ""
  if not tab.is_active then
    inactive = " ⚫ "
  end
  return { { Text = string.format("%s%s: %s", inactive, tab.tab_index + 1, title) } }
end)

-- --- [新增] 状态栏 (极简安全版) ---
wezterm.on("update-right-status", function(window, pane)
  -- 这个版本只显示当前时间，用于测试状态栏本身能否显示
  local time = wezterm.strftime("%Y-%m-%d %H:%M:%S")

  window:set_right_status(wezterm.format({
    {Text = " "},
    {Text = time},
    {Text = " "},
  }))
end)

return M
