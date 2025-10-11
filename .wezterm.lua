-- ~/.wezterm.lua
local wezterm = require("wezterm")
local act = wezterm.action

------------------------------------------------------------
-- Platform-aware defaults
------------------------------------------------------------
local is_mac     = wezterm.target_triple:find("darwin")    ~= nil
local is_windows = wezterm.target_triple:find("windows")   ~= nil
local is_linux   = (not is_mac) and (not is_windows)

-- Default shell per platform
local default_prog = {}
if is_mac then
  default_prog = {"/bin/zsh", "-l"}
elseif is_windows then
  -- 优先 PowerShell 7（如果没装，也会回退到 Windows PowerShell）
  -- 需要的话可改为 { "wsl.exe" } 以默认进入 WSL
  default_prog = {"pwsh.exe"}
else -- linux
  default_prog = {"/bin/bash", "-l"}
end

------------------------------------------------------------
-- Appearance
------------------------------------------------------------
local M = {
  -- 之前的配置都保留在这里...
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
  adjust_window_size_when_changing_font_size = false,
  window_close_confirmation = "NeverPrompt",
  inactive_pane_hsb = { saturation = 1.0, brightness = 0.80 },
  window_padding = { left = 6, right = 6, top = 6, bottom = 6 },
  scrollback_lines = 10000,
  audible_bell = "Disabled",
  default_prog = default_prog,
  default_cwd = wezterm.home_dir,
  ssh_domains = {
    {
      name = "linux-server",
      remote_address = "your.server.ip",
      username = "amelia",
      multiplexing = "WezTerm",
    },
  },
  keys = {
    -- ... 您所有的快捷键配置都保持不变
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

  ----------------------------------------------------------
  --  【新增优化】
  ----------------------------------------------------------
  
  -- 1. "Fancy" 标签栏
  -- 将标签栏与标题栏合为一体，需要将 use_fancy_tab_bar 设为 true
  -- 同时将 enable_tab_bar 设为 false，以移除旧的独立标签栏
  use_fancy_tab_bar = true,
  enable_tab_bar = false,

  -- 2. 鼠标交互优化：选中即复制，右键粘贴
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
  ----------------------------------------------------------
  -- 1. 自定义 Fancy Tab Bar 的颜色 (修正版)
  colors = {
    tab_bar = {
      -- 活动标签页的样式
      active_tab = {
        bg_color = "#565f89",
        fg_color = "#c0caf5",
        -- 你还可以在这里添加其他样式，比如斜体、粗体等
        -- intensity = "Bold",
        -- underline = "None",
        -- italic = false,
        -- strikethrough = false,
      },

      -- 非活动标签页的样式
      inactive_tab = {
        bg_color = "#1e1e2e",
        fg_color = "#a9b1d6",
      },

      -- 新建标签页按钮的样式
      new_tab = {
        bg_color = "#1e1e2e",
        fg_color = "#a9b1d6",
      },
    },
  },
  -- 2. 自定义光标样式
  -- 可选值: "Block", "BlinkingBlock", "SteadyBlock", "Underline", 
  -- "BlinkingUnderline", "SteadyUnderline", "Bar", "BlinkingBar", "SteadyBar"
  default_cursor_style = "BlinkingBlock",
}

-- 3. 智能标签页标题 (显示当前路径)
-- 这段代码需要放在 M 表格的外面
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane
  local title = pane.title
  
  -- 尝试获取更精确的当前路径
  if pane.current_working_dir and pane.current_working_dir.path then
    -- 只保留路径的最后一部分
    title = wezterm.basename(pane.current_working_dir.path)
  end

  -- 如果标签页因为不活动而变暗，在标题前加一个图标
  local inactive = ""
  if not tab.is_active then
    inactive = " ⚫ "
  end

  return {
    { Text = string.format("%s%s: %s", inactive, tab.tab_index + 1, title) },
  }
end)
return M
