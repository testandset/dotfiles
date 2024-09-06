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
-- require("bluetooth_sleep")

-- Get around paste blockers with cmd+alt+v
hs.hotkey.bind({"cmd", "shift"}, "V", function()
    hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end)

-- Mute on sleep or lock
-- TODO: Move to separate file
sleepWatcher = hs.caffeinate.watcher.new(function(state)
  if state == hs.caffeinate.watcher.systemDidWake or state == hs.caffeinate.watcher.screensDidWake then
    device = hs.audiodevice.defaultOutputDevice()

    if device then
      device:setMuted(false)
    end
  end

  if state == hs.caffeinate.watcher.screensDidLock or state == hs.caffeinate.watcher.screensDidSleep then
    device = hs.audiodevice.defaultOutputDevice()

    if device then
      device:setMuted(true)
    end
  end
end)

sleepWatcher:start()


-- other interesting things
-- https://github.com/dbalatero/dotfiles/blob/master/hammerspoon/ocr-paste.lua
