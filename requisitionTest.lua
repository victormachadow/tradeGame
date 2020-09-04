local composer = require( "composer" )
local json = require "json"
--local mainFloor = require "mainFloor"
local headers = {}
headers["Content-Type"] = "application/x-www-form-urlencoded"
headers["Accept-Language"] = "en-US"
local params = {} 

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
        DownloadedString = decodedStats.String
         if( decodedStats.id=="1")then
        print("Dado baixado da api testeCon.php = ", DownloadedString)
         end
         if( decodedStats.id=="2")then
            print("Dado baixado da api testeCon2.php = ", DownloadedString)
        end
        
       end
end


 function makeReq()
 
   network.request("http://127.0.0.1:8080/tradeGame_api/getJsons.php", "GET",  genericNetworkListener )
   network.request( "http://127.0.0.1:8080/tradeGame_api/testeCon3.php", "POST", genericNetworkListener, params )

 
 end

 return { doSomething = doSomething, makeReq = makeReq }

