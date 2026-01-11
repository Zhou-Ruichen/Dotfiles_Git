local wezterm = require 'wezterm'

-- 自定义隐身灰色 (你可以改这里：#AAAAAA 更淡，#666666 更深)
-- 建议尝试 #888888，在白色背景上像铅笔水印
local STEALTH_COLOR = '#888888'

-- 1) 先加载同目录下的主配置（继承快捷键/默认程序等）
local ok, config = pcall(dofile, wezterm.config_dir .. "/.wezterm.lua")
if not ok then
  config = {}
end


-- 2) 覆盖：背景透明 + 窗口外观
config.window_background_opacity = 0.0
config.window_decorations = "RESIZE"
config.enable_tab_bar = false

-- mac 专用字段：只在 mac 上设置，更稳
if wezterm.target_triple:find("darwin") then
  config.macos_window_background_blur = 0
end

-- 3) 覆盖：隐身配色（把所有 ANSI 都压成灰）
config.colors = config.colors or {}
config.colors.foreground = STEALTH_COLOR
config.colors.background = '#FFFFFF'
config.colors.cursor_bg = STEALTH_COLOR
config.colors.cursor_fg = '#FFFFFF'
config.colors.cursor_border = STEALTH_COLOR
config.colors.selection_bg = '#E0E0E0'
config.colors.selection_fg = '#555555'
config.colors.ansi = {
  STEALTH_COLOR, STEALTH_COLOR, STEALTH_COLOR, STEALTH_COLOR,
  STEALTH_COLOR, STEALTH_COLOR, STEALTH_COLOR, STEALTH_COLOR,
}
config.colors.brights = {
  STEALTH_COLOR, STEALTH_COLOR, STEALTH_COLOR, STEALTH_COLOR,
  STEALTH_COLOR, STEALTH_COLOR, STEALTH_COLOR, STEALTH_COLOR,
}

-- 4) 你的窗口大小偏好（仍然保留）
config.font_size = 14.0
config.initial_cols = 80
config.initial_rows = 20

return config
