require "string"

function checkBluetoothResult(rc, stderr, stderr)
  if rc ~= 0 then
    print(string.format("Unexpected result executing `blueutil`: rc=%d stderr=%s stdout=%s", rc, stderr, stdout))
  end
end

function bluetooth(power)
  print("Setting bluetooth to " .. power)
  local t = hs.task.new("/usr/local/bin/blueutil", checkBluetoothResult, {"--power", power})
  t:start()
end

function connect(id)
  print("Attempting to connect to " .. id)
  local t = hs.task.new("/usr/local/bin/blueutil", checkBluetoothResult, {"--connect", id})
end

function f(event)
  if event == hs.caffeinate.watcher.systemWillSleep or
    event == hs.caffeinate.watcher.screensDidSleep then
    bluetooth("off")
  elseif event == hs.caffeinate.watcher.screensDidWake then
    bluetooth("on")
    -- connect to bluetooth if its there
    connect("28-11-a5-dd-a0-ac") -- Headphones
    connect("e0-eb-40-5c-80-dd") -- Magic mouse
    connect("80-4a-14-6c-d9-dc") -- Keyboard
  end
end

watcher = hs.caffeinate.watcher.new(f)
watcher:start()
