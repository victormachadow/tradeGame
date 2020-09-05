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
local quad
local scrollProds
local cards = {}

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------


local function iconListener( event )
    local id = event.target.id
    --print(id)
 
    if ( event.phase == "moved" ) then
        local dx = math.abs( event.x - event.xStart ) 
        if ( dx > 5 ) then
            scrollProds:takeFocus( event ) 
        end
    elseif ( event.phase == "ended" ) then
       
    end
    return true
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
    sceneGroup:insert( bkg )

    quad = display.newRect( centerX , centerY , _W/2*1.7  , _H )
    quad:setFillColor( rgb.color( "white" ) )
    quad.alpha = 0.5
    sceneGroup:insert(quad) 

    
           scrollProds = widget.newScrollView
           {
               hideBackground = true,
               width = _W,
               height = _H,
               scrollWidth = _W,
               scrollHeight = 1000,
               horizontalScrollDisabled = true,
               --verticalScrollDisabled = true
               --listener = iconListener
           }
           --scrollProds.id ="sv"
           scrollProds.x = centerX
           scrollProds.y = centerY

           aux = _H/3.2 --150
           aux2 = 0
        for i = 1, 10 do
               cards[i] = display.newRect( centerX  , aux+aux2  , quad.width*0.9 , _H/3.2 )
               cards[i]:setFillColor( rgb.color( "white" ) )  
               --cards[i]:setFillColor( math.random(), math.random(), math.random() )
               cards[i].alpha = 0.7
               cards[i].id = i
               aux2 = _H/3.05
               aux = cards[i].y
               cards[i]:addEventListener( "touch", iconListener )
               scrollProds:insert( cards[i] )       
               		   
        end
           sceneGroup:insert( scrollProds )

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