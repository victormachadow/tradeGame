 -- This scene fires the app and verifies if mainTransition go to register or mainfloor  --

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

print(_W)
print(_H)

  -- Requires --
  local composer = require("composer")
  local loadsave = require("loadsave")
  local globalData = require("globalData")
  dadosCache = { ["iduser"] = nil , ["email"] = "" , ["name"] = "" , ["pass"] = ""  }
  
  local decoded = loadsave.loadTable("cache.json")
  print(decoded)
  if(decoded == nil )then
    loadsave.saveTable(dadosCache, "cache.json")
  end
 
  globalData.devUi = true
  composer.gotoScene("mainTransition")