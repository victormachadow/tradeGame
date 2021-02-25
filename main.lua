 -- This scene fires the app and verifies if mainTransition go to register or mainfloor  --

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

print(_W)
print(_H)

  -- Requires --
  local composer = require("composer")
  local json = require "json"
  local loadsave = require("loadsave")
  local globalData = require("globalData")
  dadosCache = { ["iduser"] = nil , ["email"] = "" , ["name"] = "" , ["pass"] = "" , ["token"] = "" , ["cached"] = 0 , ["dadosComp"] = 0 }
  
  
  local decoded = loadsave.loadTable("cache.json", system.ResourceDirectory )
  
  if(decoded == nil )then
    print("é nil")
    loadsave.saveTable(dadosCache, "cache.json")
  end


  local function genericNetworkListener( event )
    
    local response = event.response --this is the json file returned from the echo php call
    print("downloadListener(event) has bee executed")
    print("event.response == ", response)


  local decodedStats = json.decode(response)
    if
        ((response == "Connection failure" and type(decodedStats) ~= "table") or response == "Connection failure" or
            response == "Timed out" or
            event.isError or
            type(decodedStats) ~= "table")
    then
    end

       if type(decodedStats) == "table" then
             
       print(decodedStats) 
       
        
       end
       globalData.token = response
       --add token in cash
       composer.gotoScene("mainTransition")
end

timer.performWithDelay( 1000,function()
  composer.gotoScene("mainTransition")
end , 1 )

 


--network.request("http://localhost:8080/tradeGame_api/getToken.php", "GET",  genericNetworkListener )
globalData.devUi = false
--composer.gotoScene("mainTransition")