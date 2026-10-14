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
hl.unbind("SUPER + H")
hl.unbind("SUPER + J")
hl.unbind("SUPER + L")

-- Unbind default SUPER+SHIFT+H/L/K/J swap (replaced with vim-style below)
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
hl.unbind("SUPER + SHIFT + C")
hl.unbind("SUPER + SHIFT + D")
hl.unbind("SUPER + SHIFT + E")
hl.unbind("SUPER + SHIFT + W")
hl.unbind("SUPER + SHIFT + S")

-- ============================================================
-- Application bindings
-- ============================================================

o.bind("SUPER + ALT + RETURN", "Tmux", "uwsm-app -- xdg-terminal-exec --dir=\"$(omarchy-cmd-terminal-cwd)\" tmux new")
o.bind("SUPER + SHIFT + S", "Screenshot", "omarchy-capture-screenshot")
o.bind("SUPER + SHIFT + C", "Calendar", "omarchy-shell shell toggle omarchy.clock")

-- Notifications
o.bind("SUPER + N", "Dismiss notification", "qs ipc --path /usr/share/omarchy/shell call notifications dismissOne")
o.bind("SUPER + SHIFT + N", "Dismiss all notifications", "qs ipc --path /usr/share/omarchy/shell call notifications dismissAll")

-- Web apps
o.bind("SUPER + SHIFT + W", "WhatsApp", "omarchy-launch-webapp https://web.whatsapp.com")
o.bind("SUPER + SHIFT + D", "Discord", "omarchy-launch-webapp https://discord.com/channels/@me")
o.bind("SUPER + SHIFT + E", "Excalidraw", "omarchy-launch-webapp https://excalidraw.com")

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
