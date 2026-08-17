-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- Migrated from bindings.conf (Omarchy Quattro)

-- ============================================================
-- Unbind defaults that conflict with custom bindings below
-- ============================================================

-- Unbind SUPER+K (was: Keybindings help in new default)
hl.unbind("SUPER + K")

-- Unbind default SUPER+H/L/K/J focus (replaced with vim-style below)
hl.unbind("SUPER + LEFT")
hl.unbind("SUPER + RIGHT")
hl.unbind("SUPER + UP")
hl.unbind("SUPER + DOWN")
hl.unbind("SUPER + H")
hl.unbind("SUPER + J")
hl.unbind("SUPER + L")

-- Unbind default SUPER+SHIFT+H/L/K/J swap (replaced with vim-style below)
hl.unbind("SUPER + SHIFT + LEFT")
hl.unbind("SUPER + SHIFT + RIGHT")
hl.unbind("SUPER + SHIFT + UP")
hl.unbind("SUPER + SHIFT + DOWN")
hl.unbind("SUPER + SHIFT + H")
hl.unbind("SUPER + SHIFT + J")
hl.unbind("SUPER + SHIFT + K")
hl.unbind("SUPER + SHIFT + L")

-- Unbind default resize keys (replaced with minus/plus below)
hl.unbind("SUPER + code:20")
hl.unbind("SUPER + code:21")
hl.unbind("SUPER + SHIFT + code:20")
hl.unbind("SUPER + SHIFT + code:21")
hl.unbind("SUPER + ALT + code:20")
hl.unbind("SUPER + ALT + code:21")
hl.unbind("SUPER + SHIFT + ALT + code:20")
hl.unbind("SUPER + SHIFT + ALT + code:21")
hl.unbind("SUPER + CTRL + code:20")
hl.unbind("SUPER + CTRL + code:21")
hl.unbind("SUPER + CTRL + SHIFT + code:20")
hl.unbind("SUPER + CTRL + SHIFT + code:21")

-- Unbind preinstalled app defaults (kept as webapps below)
hl.unbind("SUPER + SHIFT + D")
hl.unbind("SUPER + SHIFT + E")
hl.unbind("SUPER + SHIFT + W")

-- ============================================================
-- Application bindings
-- ============================================================

o.bind("SUPER + ALT + RETURN", "Tmux", "uwsm-app -- xdg-terminal-exec --dir=\"$(omarchy-cmd-terminal-cwd)\" tmux new")
o.bind("SUPER + SHIFT + F", "File manager", "uwsm-app -- nautilus --new-window")
o.bind("SUPER + ALT + SHIFT + F", "File manager (cwd)", "uwsm-app -- nautilus --new-window \"$(omarchy-cmd-terminal-cwd)\"")
o.bind("SUPER + SHIFT + O", "Obsidian", { launch = "obsidian", focus = "^obsidian$" })

-- Web apps
o.bind("SUPER + SHIFT + W", "WhatsApp", { webapp = "https://web.whatsapp.com/" })
o.bind("SUPER + SHIFT + D", "Discord", { webapp = "https://discord.com/channels/@me" })
o.bind("SUPER + SHIFT + E", "Excalidraw", { webapp = "https://excalidraw.com/" })

-- ============================================================
-- Window resize (SUPER + minus/plus)
-- ============================================================

o.bind("SUPER + minus", "Expand window right", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
o.bind("SUPER + plus", "Expand window left", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))
o.bind("SUPER + ALT + minus", "Expand window down", hl.dsp.window.resize({ x = 0, y = -100, relative = true }))
o.bind("SUPER + ALT + plus", "Expand window up", hl.dsp.window.resize({ x = 0, y = 100, relative = true }))

-- ============================================================
-- Toggle split
-- ============================================================

o.bind("SUPER + R", "Toggle split", hl.dsp.layout("togglesplit"))

-- ============================================================
-- Vim-style focus navigation (SUPER + H/L/K/J)
-- ============================================================

o.bind("SUPER + H", "Move focus left", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + L", "Move focus right", hl.dsp.focus({ direction = "r" }))
o.bind("SUPER + K", "Move focus up", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + J", "Move focus down", hl.dsp.focus({ direction = "d" }))

-- ============================================================
-- Vim-style window swap (SUPER + SHIFT + H/L/K/J)
-- ============================================================

o.bind("SUPER + SHIFT + H", "Swap window left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + L", "Swap window right", hl.dsp.window.swap({ direction = "r" }))
o.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap({ direction = "d" }))
