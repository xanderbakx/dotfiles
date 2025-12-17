-- Hammerspoon config
-- Auto-switch aerospace config when displays change

local function switchAerospaceConfig()
    hs.notify.new({title="Aerospace", informativeText="Switching config for displays..."}):send()
    hs.execute("~/dotfiles/aerospace/aerospace-switch.sh", true)
end

-- Watch for screen configuration changes
screenWatcher = hs.screen.watcher.new(function()
    -- Small delay to let displays fully initialize
    hs.timer.doAfter(2, switchAerospaceConfig)
end)
screenWatcher:start()

-- Also run on Hammerspoon startup
switchAerospaceConfig()

-- Reload config shortcut (Cmd+Ctrl+Alt+R)
hs.hotkey.bind({"cmd", "ctrl", "alt"}, "R", function()
    hs.reload()
end)

hs.notify.new({title="Hammerspoon", informativeText="Config loaded"}):send()
