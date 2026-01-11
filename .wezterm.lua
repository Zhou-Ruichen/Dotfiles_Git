-- ~/.wezterm.lua (合并后的稳定版)
local wezterm = require("wezterm")
local act = wezterm.action

-- 允许兼容 stable 和 nightly 版本
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

------------------------------------------------------------
-- 1. 平台检测
------------------------------------------------------------
local is_mac     = wezterm.target_triple:find("darwin")  ~= nil
local is_windows = wezterm.target_triple:find("windows") ~= nil
local is_linux   = (not is_mac) and (not is_windows)

------------------------------------------------------------
-- 2. 默认 Shell 设置
------------------------------------------------------------
local default_prog = {}
if is_mac then
  default_prog = {"/bin/zsh", "-l"}
elseif is_windows then
  -- 如果你想用 PowerShell Core，保持 pwsh.exe；如果想用 CMD，改 cmd.exe
  default_prog = {"pwsh.exe"}
else
  default_prog = {"/bin/bash", "-l"}
end

------------------------------------------------------------
-- 3. 外观与字体
------------------------------------------------------------
config.font = wezterm.font_with_fallback({
  "JetBrainsMono Nerd Font",
  "Menlo",
  "Consolas",
  "DejaVu Sans Mono",
})
config.font_size = 13.0
config.line_height = 1.2
config.color_scheme = "Tokyo Night"

config.window_background_opacity = 0.95
config.text_background_opacity = 1.0
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.window_padding = { left = 6, right = 6, top = 6, bottom = 6 }

config.default_cursor_style = "BlinkingBlock"
config.inactive_pane_hsb = { saturation = 1.0, brightness = 0.80 }

------------------------------------------------------------
-- 4. 标签栏 (Tabs)
------------------------------------------------------------
config.use_fancy_tab_bar = true
config.enable_tab_bar = false  -- 你之前的设置是隐藏 tab bar
config.hide_tab_bar_if_only_one_tab = true

------------------------------------------------------------
-- 5. 行为设置
------------------------------------------------------------
config.scrollback_lines = 10000
config.audible_bell = "Disabled"
config.default_prog = default_prog
config.default_cwd = wezterm.home_dir
config.status_update_interval = 1000 -- 状态栏刷新频率

------------------------------------------------------------
-- 6. SSH Domains (已去重)
------------------------------------------------------------
config.ssh_domains = {
  {
    name = "zerotier",
    remote_address = "192.168.192.1:55905",
    username = "ruichen",
    multiplexing = "WezTerm",
  },
  {
    name = "tailscale",
    remote_address = "100.100.1.1:55905",
    username = "ruichen",
    multiplexing = "WezTerm",
  },
  {
    name = "Precision-Tower",
    remote_address = "117.68.10.96:43431",
    username = "ruichen",
    multiplexing = "WezTerm",
  },
}

------------------------------------------------------------
-- 7. 快捷键 (Keys)
------------------------------------------------------------
config.keys = {
  -- 标签页操作
  { key="t", mods=is_mac and "CMD" or "CTRL|SHIFT", action=act.SpawnTab("CurrentPaneDomain") },
  { key="w", mods=is_mac and "CMD" or "CTRL|SHIFT", action=act.CloseCurrentTab({ confirm=true }) },
  { key="Tab", mods="CTRL|SHIFT", action=act.ActivateTabRelative(1) },
  { key="Tab", mods="CTRL",       action=act.ActivateTabRelative(-1) },

  -- 分屏操作
  { key="d", mods=is_mac and "CMD" or "CTRL|SHIFT", action=act.SplitHorizontal({ domain="CurrentPaneDomain" }) },
  { key="D", mods=is_mac and "CMD" or "CTRL|SHIFT", action=act.SplitVertical({ domain="CurrentPaneDomain" }) },

  -- 窗口焦点移动
  { key="LeftArrow",  mods=is_mac and "CMD|ALT" or "CTRL|ALT", action=act.ActivatePaneDirection("Left") },
  { key="RightArrow", mods=is_mac and "CMD|ALT" or "CTRL|ALT", action=act.ActivatePaneDirection("Right") },
  { key="UpArrow",    mods=is_mac and "CMD|ALT" or "CTRL|ALT", action=act.ActivatePaneDirection("Up") },
  { key="DownArrow",  mods=is_mac and "CMD|ALT" or "CTRL|ALT", action=act.ActivatePaneDirection("Down") },

  -- 其他功能
  { key="f", mods=is_mac and "CMD" or "CTRL|SHIFT", action=act.ToggleFullScreen },
  { key="p", mods=is_mac and "CMD|SHIFT" or "CTRL|SHIFT", action=act.ActivateCommandPalette },
  { key="l", mods=is_mac and "CMD|SHIFT" or "CTRL|SHIFT", action=act.ShowLauncher },
}

------------------------------------------------------------
-- 8. 鼠标绑定
------------------------------------------------------------
config.mouse_bindings = {
  { event = { Up = { streak = 1, button = "Left" } },  mods = "NONE", action = act.CompleteSelection("ClipboardAndPrimarySelection") },
  { event = { Up = { streak = 1, button = "Right" } }, mods = "NONE", action = act.PasteFrom("Clipboard") },
}

------------------------------------------------------------
-- 9. 颜色 (保留配置以备后用)
------------------------------------------------------------
config.colors = config.colors or {}
config.colors.tab_bar = {
  active_tab   = { bg_color = "#565f89", fg_color = "#c0caf5" },
  inactive_tab = { bg_color = "#1e1e2e", fg_color = "#a9b1d6" },
  new_tab      = { bg_color = "#1e1e2e", fg_color = "#a9b1d6" },
}

------------------------------------------------------------
-- 10. 事件处理 (状态栏与标题)
------------------------------------------------------------
wezterm.on("format-tab-title", function(tab, tabs, panes, config_, hover, max_width)
  local pane = tab.active_pane
  local title = pane.title

  if pane.current_working_dir and pane.current_working_dir.path then
    -- [修复] 不使用 wezterm.basename，改用 Lua 原生匹配获取文件夹名
    local path = pane.current_working_dir.path
    -- 匹配路径最后一部分 (兼容 / 和 \)
    local basename = string.match(path, "([^/\\]+)$")
    if basename then
      title = basename
    end
  end

  local inactive = ""
  if not tab.is_active then
    inactive = " ⚫ "
  end
  return { { Text = string.format("%s%s: %s", inactive, tab.tab_index + 1, title) } }
end)

wezterm.on("update-right-status", function(window, pane)
  local time = wezterm.strftime("%Y-%m-%d %H:%M:%S")
  window:set_right_status(wezterm.format({
    { Text = " " },
    { Text = time },
    { Text = " " },
  }))
end)

return config
