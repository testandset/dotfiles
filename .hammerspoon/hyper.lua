-- Set up a hyper key
hyper = false
hyperTime = nil

frameCache = {}
hs.application.enableSpotlightForNameSearches = true

function toggleWindowMaximized()
  local win = hs.window.focusedWindow()
  if frameCache[win:id()] then
    frameCache[win:id()] = nil
    local gridSize = hs.grid.getGrid()
    snap(win, hs.geometry({1, 1, gridSize.w / 2.0, gridSize.h / 2.0}))
  else
    frameCache[win:id()] = win:frame()
    win:maximize()
  end
end

function moveCurrentWindowToNextScreen()
  local win = hs.window.focusedWindow()
  win:moveToScreen(win:screen():next())
  snap(win)
end

function moveCurrentWindowToLeftHalf()
  local gridSize = hs.grid.getGrid()
  snap(hs.window.focusedWindow(), hs.geometry({0, 0, gridSize.w / 2.0, gridSize.h}))
end

function moveCurrentWindowToRightHalf()
  local gridSize = hs.grid.getGrid()
  snap(hs.window.focusedWindow(), hs.geometry({gridSize.w / 2.0, 0, gridSize.w / 2.0, gridSize.h}))
end

function snap(win, cell)
  hs.grid.set(win, cell or hs.grid.get(win))
end

function incognitoChrome()
  hs.application.launchOrFocus("Google Chrome")
  local chrome = hs.appfinder.appFromName("Google Chrome")
  local incognitoWindow = chrome:findWindow('Incognito')
  if incognitoWindow == nil then
    local str_menu_item = {"File", "New Incognito Window"}
    chrome:selectMenuItem(str_menu_item)
  else
    incognitoWindow:focus()
  end
end

function chromeActiveTabWithName(name)
  local app = hs.appfinder.appFromName("Google Chrome")
  local tabs = hs.tabs.tabWindows(app)
  local windows = app:allWindows()
  for key, value in ipairs(tabs) do
    print(value:title())
  end
  hs.osascript.javascript([[
    // below is javascript code
    var chrome = Application('Google Chrome');
    chrome.activate();
    var wins = chrome.windows;

    // loop tabs to find a web page with a title of <name>
    function main() {
      for (var i = 0; i < wins.length; i++) {
        var win = wins.at(i);
        var tabs = win.tabs;
        for (var j = 0; j < tabs.length; j++) {
          var tab = tabs.at(j);
          if (tab.title().indexOf(']] .. name .. [[') > -1) {
              win.activeTabIndex = j + 1;
              return;
            }
          }
        }
     }
      main();
      // end of javascript
      ]])
end

down = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
  local character = event:getCharacters()
  local keyCode = event:getKeyCode()

  -- Set up ; as the hyper key
  if character == ";" then
    hyper = true
    if hyperTime == nil then
      hyperTime = hs.timer.absoluteTime()
    end
    return true
  end

  -- Max uses emacs binding so use them
  -- Use h, j, k, l as arrow keys
  -- if character == 'h' and hyper then
  --   hs.eventtap.keyStroke(nil, "left", 0)
  --   hyperTime = nil
  --   return true
  -- end

  -- if character == 'j' and hyper then
  --   hs.eventtap.keyStroke(nil, "down", 0)
  --   hyperTime = nil
  --   return true
  -- end
  -- if character == 'k' and hyper then
  --   hs.eventtap.keyStroke(nil, "up", 0)
  --   hyperTime = nil
  --   return true
  -- end

  -- if character == 'l' and hyper then
  --   hs.eventtap.keyStroke(nil, "right", 0)
  --   hyperTime = nil
  --   return true
  -- end

  -- Quick switch to applications
  if character == 't' and hyper then
    hs.application.launchOrFocus("iTerm")
    hyperTime = nil
    return true
  end

  if character == 'a' and hyper then
    hs.application.launchOrFocus("IntelliJ IDEA CE")
    hyperTime = nil
    return true
  end

  if character == 'c' and hyper then
    hs.application.launchOrFocus("Google Chrome")
    hyperTime = nil
    return true
  end

  if character == 'g' and hyper then
    incognitoChrome()
    hyperTime = nil
    return true
  end

  if character == 's' and hyper then
    chromeActiveTabWithName("Slack")
    hyperTime = nil
    return true
  end

  if character == 'e' and hyper then
    for key, value in ipairs(hs.application.runningApplications()) do
      local app = value
      if app:name() == 'Emacs' then
        value:activate()
      end
    end
    -- hs.application.launchOrFocus("Emacs.app")
    hyperTime = nil
    return true
  end

  -- Window management
  if character == '3' and hyper then
    toggleWindowMaximized()
    hypterTime = nil
    return true
  end

  if character == '1' and hyper then
    moveCurrentWindowToLeftHalf()
    hypterTime = nil
    return true
  end

  if character == '2' and hyper then
    moveCurrentWindowToRightHalf()
    hypterTime = nil
    return true
  end

  if character == '4' and hyper then
    moveCurrentWindowToNextScreen()
    hypterTime = nil
    return true
  end

end)
down:start()

up = hs.eventtap.new({hs.eventtap.event.types.keyUp}, function(event)
    local character = event:getCharacters()
    if character == ";" and hyper then
      local currentTime = hs.timer.absoluteTime()
      -- print(currentTime, hyperTime)
      if hyperTime ~= nil and (currentTime - hyperTime) / 1000000 < 250 then
        down:stop()
        hs.eventtap.keyStrokes(";")
        down:start()
      end
      hyper = false
      hyperTime = nil
    end
end)
up:start()
