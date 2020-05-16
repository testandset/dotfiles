hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

-- Settings
hs.autoLaunch(true)
hs.automaticallyCheckForUpdates(true)
hs.consoleOnTop(true)
hs.dockIcon(false)
hs.menuIcon(false)
hs.uploadCrashData(false)

require("hyper")
require("ctrl-to-esc")
require("wifi-watcher")
require("cherry")

-- Get around paste blockers with cmd+alt+v
hs.hotkey.bind({"cmd", "shift"}, "V", function()
    hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end)

