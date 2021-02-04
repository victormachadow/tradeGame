local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

  -- Requires --
  local composer = require("composer")
  local rgb = require "_rgb"
  local globalData = require("globalData")
  local loadsave = require("loadsave")

   -- Vars --
  local sceneGroup = display.newGroup()
  local bkg
  local string 
  local scene = composer.newScene()

  local options = {   -- Effects when scene changes
    effect = "slideLeft",
    time = 500
}

dadosCache = { ["iduser"] = nil , ["email"] = "" , ["name"] = "" , ["pass"] = "" , ["token"] = "" , ["cached"] = 0 , ["dadosComp"] = 0 }
local decoded = loadsave.loadTable("cache.json", system.ResourceDirectory )

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------




-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
function exit()


if (decoded.cached == 0 ) then -- Não foi cacheado vai para cadastro/login

    globalData.id = nil
    globalData.email =""
    globalData.name  =""
    globalData.pass =""
    globalData.token =""
    globalData.dadosComp =""
  
    sceneGroup = nil
    composer.removeScene("mainTransition")
    composer.gotoScene("register", options )
  
  end
  
  if (decoded.cached == 1 ) then -- Cacheado vai para mainfloor
  
    --request to login/autentica
    sceneGroup = nil
    composer.removeScene("mainTransition")
    composer.gotoScene("mainFloor")
  
  end


end   

-- create()
function scene:create( event )

    local sceneGroup = self.view
    --display.setDefault( "background" , rgb.color( "darkgreen" ) )
    bkg = display.newRect( centerX , centerY , _W, _H )
    bkg:setFillColor( rgb.color( "darkgreen" ) )
    sceneGroup:insert(bkg)
    -- Code here runs when the scene is first created but has not yet appeared on screen
    string =  display.newText( "Trade game", centerX , centerY , native.systemFont, 82 )
    sceneGroup:insert(string)
    string.alpha = 0
    string:setTextColor( rgb.color( "white" ) )
    transition.fadeIn( string, { time=3000 , onComplete = exit } )

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

