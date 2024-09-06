hs.application.enableSpotlightForNameSearches(true)

windowPositions = {
  maximized = hs.layout.maximized,
  centered = {x=0.15, y=0.15, w=0.7, h=0.7},
  centerHalf = {x = 0.25, y = 0, w = 0.5, h = 1},
  centerThird = {x = 0.33, y = 0, w = 0.33, h = 1},

  leftHalf = hs.layout.left50,
  leftThird = {x = 0, y = 0, w = 0.33, h = 1},
  leftTwoThirds = {x = 0, y = 0, w = 0.66, h = 1},

  rightHalf = hs.layout.right50,
  rightThird = {x = 0.66, y = 0, w = 0.34, h = 1},
  rightTwoThirds = {x = 0.33, y = 0, w = 0.67, h = 1},

  upper50 = {x=0, y=0, w=1, h=0.5},
  upper50Left50 = {x=0, y=0, w=0.5, h=0.5},
  upper50Right50 = {x=0.5, y=0, w=0.5, h=0.5},

  lower50 = {x=0, y=0.5, w=1, h=0.5},
  lower50Left50 = {x=0, y=0.5, w=0.5, h=0.5},
  lower50Right50 = {x=0.5, y=0.5, w=0.5, h=0.5},
}

function moveCurrentWindowToNextScreen()
  local win = hs.window.focusedWindow()
  win:moveToScreen(win:screen():next())
  snap(win)
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
  local str_menu_item = {"Tab", "Move Tab to New Window"}
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

function fn(func, args)
  return function() func(args) end
end

function launch(app)
  return fn(hs.application.launchOrFocus, app)
end

lastWindowPosition = {}

windowRotationOrder = {
  "leftThird",
  "leftTwoThirds",
  "rightTwoThirds",
  "rightThird",
  "upper50",
  "lower50",
  "upper50Left50",
  "upper50Right50",
  "lower50Right50",
  "lower50Left50",
}

function focusToLeftWindow()
  local win = hs.window.focusedWindow()
  local screen = win:screen()
  local nextWindow = win:windowsToWest(nil, true, true)[1]
  if nextWindow == nil then
    nextWindow = screen:toWest():current()
  end
  nextWindow:focus()
end

function focusToRightWindow()
  local win = hs.window.focusedWindow()
  local screen = win:screen()
  local nextWindow = win:windowsToEast(nil, true, true)
  if nextWindow == nil then
    nextWindow = screen:toEast():current()
  else
    nextWindow = nextWindow[1]
  end

  nextWindow:focus()
end

function newRotate()
  -- still trying to figure out how to do this
  k = hs.hotkey.modal.new()
  function k:entered() hs.alert'Entered rotate mode' end
  function k:exited()  hs.alert'Exited rotate mode'  end
  k:enter()
  k:bind('', 'escape', function() k:exit() end)
  k:bind('', 'h', 'entered h', function() setWindowTo("leftHalf") end)
end

function rotateWindowPosition()
  local win = hs.window.focusedWindow()
  local lastPosition = lastWindowPosition[win:id()]

  if lastPosition == nil then
    lastPosition = "leftThird"
    lastWindowPosition[win:id()] = lastPosition
    setWindowTo(lastPosition)()
    return
  end

  local nextPositionIndex = hs.fnutils.indexOf(windowRotationOrder, lastPosition)
  if nextPositionIndex == nil or nextPositionIndex > #windowRotationOrder then
    nextPositionIndex = 1
  else
    nextPositionIndex = nextPositionIndex + 1
  end

  local nextPosition = windowRotationOrder[nextPositionIndex]

  lastWindowPosition[win:id()] = nextPosition
  setWindowTo(nextPosition)()
end

function setWindowTo(position)
  return function()
    hs.window.focusedWindow():moveToUnit(windowPositions[position], 0)
    lastWindowPosition[hs.window.focusedWindow():id()] = position
  end
end

function darkModeStatus()
   -- return the status of Dark Mode
   local _, darkModeState = hs.osascript.javascript(
      'Application("System Events").appearancePreferences.darkMode()'
   )
   return darkModeState
end

function setDarkMode(state)
   -- Function for setting Dark Mode on/off.
   -- Argument should be either 'true' or 'false'.
   return hs.osascript.javascript(
      string.format(
         "Application('System Events').appearancePreferences.darkMode.set(%s)", state
   ))
end

function toggleDarkMode()
   -- Toggle Dark Mode status
   if darkModeStatus() then
      setDarkMode(false)
   else
      setDarkMode(true)
   end
end


actionHotKeys = {
  ['a']=launch("IntelliJ IDEA"),
  ['c']=switchToNonIncognitoChrome,
  ['e']=launchEmacs,
  ['g']=incognitoChrome,
  ['r']=rotateWindowPosition,
  ['s']=fn(chromeActiveTabWithName, "Slack"),
  ['t']=launch("iterm"),
  ['x']=clearNotifications,
  ['z']=focusToLeftWindow,
  ['b']=focusToRightWindow,
  ['1']=setWindowTo("leftHalf"),
  ['2']=setWindowTo("rightHalf"),
  ['3']=setWindowTo("maximized"),
  ['4']=moveCurrentWindowToNextScreen,
  ['5']=moveChromeTabToNewWindow,
  ['`']=toggleDarkMode,
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
