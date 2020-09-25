local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

local composer = require( "composer" )
local rgb = require "_rgb"
local globalData = require("globalData")
local widget = require("widget")
local composer = require( "composer" )

-- vars --
local scene = composer.newScene()
local sceneGroup = display.newGroup()
local bkg
local typeButton
local titleBox
local describBox
local slideActive = false
local icons = {}
local labels = {}

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function listenerNext( event )
  
    if ( "ended" == event.phase ) then
        --code
        if(globalData.devUi)then
            display.remove(sceneGroup)
            composer.removeScene("addProd")
            composer.gotoScene("addProd2", options )

        end
    end
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

       if type(decodedStats) == "table" then -- after page downloaded
          --print("decoded response: "..decodedStats )
          -- after register sucesfull response then goes to photos scene
            --display.remove(sceneGroup)
            --composer.removeScene("addProd2")
            --composer.gotoScene("addPhoto", options )
       
       end
  
             
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    bkg = display.newImage( "pngs/green.jpg" )
    --bkg:setReferencePoint( display.CenterReferencePoint )
    bkg.x = display.contentCenterX
    bkg.y = display.contentCenterY
    bkg.id = "bkg"
    sceneGroup:insert( bkg )
    quad = display.newRect( centerX , centerY , _W/1.2  , _H*0.9 )
    quad:setFillColor( rgb.color( "white" ) )
    quad.alpha = 0.5
    sceneGroup:insert(quad)
    headerui = display.newRect( centerX , 0  , _W , _H/3.2 )
    headerui:setFillColor( rgb.color( "black" ) )
    sceneGroup:insert( headerui )
    headerTagText = display.newText( "Registrar um produto", centerX , headerui.height/3 , native.systemFontBold, 25 )
    headerTagText:setFillColor( rgb.color( "white" ) )
    sceneGroup:insert(headerTagText)


nextButton = widget.newButton(   -- customized settings 
     {
         label = "Avançar",
         --onEvent = listenerNext,
         emboss = false,
         font = native.systemFontBold ,
         fontSize = 25 ,
         -- Properties for a rounded rectangle button
         shape = "rect",
         width = 150,
         height = 80,
         fillColor = { default= { rgb.color( "black" ) } , over = { rgb.color( "gray" ) } },
         labelColor = { default= { rgb.color( "white" ) } , over = { rgb.color( "white" ) } }
         
     }
 )

 
 nextButton.x = centerX + (quad.width/2 - 80)
 nextButton.y = centerY + (quad.height/2 - 55)
 sceneGroup:insert(nextButton)
   


end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen

    end
end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene