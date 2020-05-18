-- Set up a hyper key

hs.application.enableSpotlightForNameSearches(true)

frameCache = {}
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

function switchToNonIncognitoChrome()
  hs.application.launchOrFocus("Google Chrome")
  local chrome = hs.appfinder.appFromName("Google Chrome")
  local nonIncognitoWindow = chrome:findWindow('^[Incognito]')
  if nonIncognitoWindow ~= nil then
    nonIncognitoWindow:focus()
  end
end

function chromeActiveTabWithName(name)
  -- local app = hs.appfinder.appFromName("Google Chrome")
  -- local tabs = hs.tabs.tabWindows(app)
  -- local windows = app:allWindows()
  -- for key, value in ipairs(tabs) do
  --   print(value:title())
  -- end
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

local actionHotKeys = {
  ['a']=launch("IntelliJ IDEA CE"),
  ['c']=switchToNonIncognitoChrome,
  ['e']=launchEmacs,
  ['g']=incognitoChrome,
  ['s']=fn(chromeActiveTabWithName, "Slack"),
  ['t']=launch("iterm"),
  ['1']=moveCurrentWindowToLeftHalf,
  ['2']=moveCurrentWindowToRightHalf,
  ['3']=toggleWindowMaximized,
  ['4']=moveCurrentWindowToNextScreen,
}

-- Hyper key set-up
HYPER_KEY = ';'
hyper = false
hyperTime = nil
down = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
  local character = event:getCharacters()
  local keyCode = event:getKeyCode()

  if character == HYPER_KEY then
    hyper = true
    if hyperTime == nil then
      hyperTime = hs.timer.absoluteTime()
    end
    return true
  end

  if actionHotKeys[character] ~= nil and hyper then
    actionHotKeys[character]()
    hyperTime = nil
    return true
  end

end)
down:start()

up = hs.eventtap.new({hs.eventtap.event.types.keyUp}, function(event)
    local character = event:getCharacters()
    if character == HYPER_KEY and hyper then
      local currentTime = hs.timer.absoluteTime()
      if hyperTime ~= nil and (currentTime - hyperTime) / 1000000 < 250 then
        down:stop()
        hs.eventtap.keyStrokes(HYPER_KEY)
        down:start()
      end
      hyper = false
      hyperTime = nil
    end
end)
up:start()
