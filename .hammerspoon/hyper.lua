hs.application.enableSpotlightForNameSearches(true)

frameCache = {}

function clearFromFrameCache(win)
  win = win or hs.window.focusedWindow()
  if frameCache[win:id()] then
    frameCache[win:id()] = nil
  end
end

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
  clearFromFrameCache(win)
  win:moveToScreen(win:screen():next())
  snap(win)
end

function moveCurrentWindowToLeftHalf()
  local gridSize = hs.grid.getGrid()
  local win = hs.window.focusedWindow()
  clearFromFrameCache(win)
  snap(win, hs.geometry({0, 0, gridSize.w / 2.0, gridSize.h}))
end

function moveCurrentWindowToRightHalf()
  local gridSize = hs.grid.getGrid()
  local win = hs.window.focusedWindow()
  clearFromFrameCache(win)
  snap(win, hs.geometry({gridSize.w / 2.0, 0, gridSize.w / 2.0, gridSize.h}))
end

function launchEmacs()
  for key, value in ipairs(hs.application.runningApplications()) do
    local app = value
    if app:name() == 'Emacs' then
      value:activate()
    end
  end
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

function moveChromeTabToNewWindow()
  local chrome = hs.appfinder.appFromName("Google Chrome")
  local str_menu_item = {"Tab", "Move tab to new window"}
  chrome:selectMenuItem(str_menu_item)
end

function switchToNonIncognitoChrome()
  -- hs.application.launchOrFocus("Google Chrome")
  local chrome = hs.appfinder.appFromName("Google Chrome")
  local incognitoWindow = chrome:findWindow('Incognito')

  for key, value in ipairs(chrome:allWindows()) do
    if value ~= incognitoWindow then
      value:focus()
      return true
    end
  end
end


function chromeActiveTabWithName(name)
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

function actionNotification()
  hs.osascript.applescript([[
    tell application "System Events"
      tell process "NotificationCenter"
        click button 1 of window 1
      end tell
    end tell
    ]])
end

function fn(func, args)
  return function() func(args) end
end

function launch(app)
  return fn(hs.application.launchOrFocus, app)
end

actionHotKeys = {
  ['a']=launch("IntelliJ IDEA"),
  ['c']=switchToNonIncognitoChrome,
  ['e']=launchEmacs,
  ['g']=incognitoChrome,
  ['r']=actionNotification,
  ['s']=fn(chromeActiveTabWithName, "Slack"),
  ['t']=launch("iterm"),
  ['1']=moveCurrentWindowToLeftHalf,
  ['2']=moveCurrentWindowToRightHalf,
  ['3']=toggleWindowMaximized,
  ['4']=moveCurrentWindowToNextScreen,
  ['5']=moveChromeTabToNewWindow,
}

-- Hyper key set-up
HYPER_KEY = ';'
isHyperActivated = false
hyperTime = nil
down = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
  local character = event:getCharacters()
  local withModKey = event:getFlags()['ctrl']

  if character == HYPER_KEY and not(withModKey) then
    isHyperActivated = true
    if hyperTime == nil then
      hyperTime = hs.timer.absoluteTime()
    end
    return true
  end

  if actionHotKeys[character] ~= nil and isHyperActivated then
    actionHotKeys[character]()
    hyperTime = nil
    return true
  end

end)
down:start()

up = hs.eventtap.new({hs.eventtap.event.types.keyUp}, function(event)
    local character = event:getCharacters()
    if character == HYPER_KEY and isHyperActivated then
      local currentTime = hs.timer.absoluteTime()
      if hyperTime ~= nil and (currentTime - hyperTime) / 1000000 < 250 then
        down:stop()
        hs.eventtap.keyStrokes(HYPER_KEY)
        down:start()
      end
      isHyperActivated = false
      hyperTime = nil
    end
end)
up:start()
