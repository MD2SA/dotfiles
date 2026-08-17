-- Keep only your personal input overrides here. Uncommented settings below
-- replace Omarchy's defaults.
-- Migrated from input.conf (Omarchy Quattro)

-- Keyboard layout: Portuguese
-- CapsLock is Escape (vim-style)
hl.config({
  input = {
    kb_layout = "pt",
    kb_options = "ctrl:nocaps",
    repeat_delay = 600,
    numlock_by_default = true,

    touchpad = {
      natural_scroll = true,
      scroll_factor = 0.8,
    },
  },
})

-- Scroll nicely in the terminal (default handles Alacritty/kitty/foot/ghostty)
-- These are already set in the default input.lua, no need to duplicate.
