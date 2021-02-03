 ------ Screen resources --------
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight 

-- Initial components sizes developed based on 640x960 screen size
-- scaleX  = 1.7, scaleY = 2 for 1080x1920
scaleX = 1.7
scaleY = 2

 -- Requires --
 local composer = require("composer")
 local io = require "io"
 local json = require "json"
 local loadsave = require("loadsave")
 local rgb = require "_rgb"
 local globalData = require("globalData")
 local widget = require("widget")
 local reqs = require "requisitionTest"
 
 --local embeddableScrollview = require "plugin.embeddablescrollview"
 --local nanosvg = require( "plugin.nanosvg" )

 
  -- vars --
  local sceneGroup = display.newGroup()
  local bkg
  local scene = composer.newScene()
  local headerui
  local footer
  local menuBt
  local hideMenu
  local hideMenuOriginX = -200
  local hideMenuOriginY = 100
  local hideMenuX = 300
  local hideMenuY = _H-_H/10
  local menuActive = false
  local menuClicked = false
  local menuContainer
  local addProdBt
  -- menu buttons --
  local profileBt -- profile button 
  local myProdsBt -- myproduts button 
  local myPlaysBt -- myplays button 
  local aboutBt -- about button 
  local topProductsBt-- top products button
  local paymentMarkeBt -- payment/market button
  local profileText 
  local myProdsText 
  local myPlaysText 
  local aboutText 
  local topProductsText 
  local paymentMarketText
  local profileQuad 
  local prodsQuad 
  local playsQuad 
  local aboutQuad 
  local topQuad
  local payQuad 

  ----------x----------
  local advSearchBt
  local advSearchText
  local addProdText

  dadosCache = { ["iduser"] = nil , ["email"] = "" , ["name"] = "" , ["pass"] = "" , ["token"] = "" , ["cached"] = 0 , ["dadosComp"] = 0 }
  

  --[[

  Handle back-key android/ios

--handle back and volume keys local keyClass = require("keyhandler") function scene:create( event ) .. Runtime:addEventListener("key",keyClass.onKeyEvent) end

 add the event listener in scene:show()'s “did” phase and remove it in scene:hide()'s “will” phase.

  ]]
  
 

  local options = {   -- Effects when scene changes
    effect = "slideLeft",
    time = 500
}


 local params = {}
 
 local dados = {
 ["iduser"] ="",
 ["email"] ="",
 ["name"] ="",
 ["pass"] ="",
 ["paypal"] ="",
 }


 local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- Listeners --

local function gotoScene( id )
      
        if( id == "top" or  id == "toptext") then
            display.remove(sceneGroup)
            composer.removeScene("mainFloor")
            composer.gotoScene("topProducts", options )
        end     
end


local function touchListener( event )
 
    print( "Unique touch ID: " .. tostring(event.id) )
 
    if ( event.phase == "began" ) then
        --event.target.alpha = 0.5
        -- Set focus on object using unique touch ID
        display.getCurrentStage():setFocus( event.target, event.id )

        if ( event.target.id == 1 )then
            print("background clicked")
            if(menuActive)then -- hide hidepopup
                transition.to( menuContainer , { time= 500, alpha = 0 , x=hideMenuOriginX, y=hideMenuOriginY , onComplete = function()
                end } )
              end
        end

        if ( event.target.id == 2 )then
            print("menu clicked")
        end

        if( event.target.id == "profile" or  event.target.id == "profiletext") then
            profileText.alpha = 0.5
            profileQuad.alpha = 1
        end
        if( event.target.id == "prod" or  event.target.id == "prodtext") then
            myProdsText.alpha = 0.5
            prodsQuad.alpha = 1
        end
        if( event.target.id == "play" or  event.target.id == "playtext") then
            myPlaysText.alpha = 0.5
            playsQuad.alpha = 1
        end
        if( event.target.id == "top" or  event.target.id == "toptext") then
            topProductsText.alpha = 0.5
            topQuad.alpha = 1
            gotoScene(event.target.id)
        end
        if( event.target.id == "about" or  event.target.id == "aboutext") then
            aboutText.alpha = 0.5
            aboutQuad.alpha = 1
        end
        if( event.target.id == "pay" or  event.target.id == "paytext") then
            paymentMarketText.alpha = 0.5
            payQuad.alpha = 1
        end

 
    elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
        event.target.alpha = 1
        if( event.target.id == "profile" or "prod" or "play" or "top" or "about" or "pay" )then
        profileQuad.alpha = 0.3
        profileText.alpha = 1
        prodsQuad.alpha = 0.3
        myProdsText.alpha = 1
        playsQuad.alpha = 0.3
        myPlaysText.alpha = 1
        aboutQuad.alpha = 0.3
        aboutText.alpha = 1
        topQuad.alpha = 0.3
        topProductsText.alpha = 1
        payQuad.alpha = 0.3
        paymentMarketText.alpha = 1
        end
        -- Release focus on object
        display.getCurrentStage():setFocus( event.target, nil )
    end
    return true
end


local function menuListener( event )
 
    if ( event.phase == "began" ) then 
        if(menuActive)then -- hide hidepopup
          transition.to( menuContainer , { time= 500, alpha = 0 , x=hideMenuOriginX, y=hideMenuOriginY , onComplete = function()
          end } )
        end
        return true
    end
end


local function hideMenuListener( event )
 
    if ( event.phase == "began" ) then 
        if(menuActive)then -- hide hidepopup
          transition.to( menuContainer , { time= 500, alpha = 0 , x=hideMenuOriginX, y=hideMenuOriginY , onComplete = function()
          end } )
        end
        return true
    end
end



local function listenerMenuButton( event )
   print("clicked")

   if ( "began" == event.phase ) then
    --code
    event.target.alpha = 0.5
    transition.to( menuContainer , { time= 500, alpha = 0.9 , x=150, y=menuContainer.y , onComplete = function()
         menuActive = true-- active menu
         

    end } )
end

    if ( "ended" == event.phase ) then
        --code
    event.target.alpha = 1.0
    end

end

local function listenerAddProd( event )
    
 
    if ( "began" == event.phase ) then
     --code
     event.target.alpha = 0.5
     display.remove(sceneGroup)
     composer.removeScene("mainFloor")
     composer.gotoScene("addProd", options )
    
    end

     --[[
     if ( "ended" == event.phase ) then
         --code
     event.target.alpha = 1.0
     end
     --]]
 
 end

 local function listenerAdvSearch( event )
    
 
    if ( "began" == event.phase ) then
     --code
     event.target.alpha = 0.5
     display.remove(sceneGroup)
     composer.removeScene("mainFloor")
     composer.gotoScene("topProducts", options )
    
    end
 
     --[[
     if ( "ended" == event.phase ) then
         --code
     event.target.alpha = 1.0
     end
     --]]
 
 end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
    
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    --bkg = display.newRect( centerX , centerY , _W , _H )
    bkg = display.newImage( "pngs/green.jpg" )
    --bkg:setFillColor( rgb.color( "darkgreen" ) )
    bkg.id = 1
    --bkg:setReferencePoint( display.CenterReferencePoint )
    bkg.x = display.contentCenterX
    bkg.y = display.contentCenterY
    sceneGroup:insert( bkg )
    
    --sceneGroup:insert(bkg)
    headerui = display.newRect( centerX , 0  , _W , _H/3.2 )
    headerui:setFillColor( rgb.color( "black" ) )
    footer = display.newRect( 0 , _H  , _W*2 , 300 )
    footer:setFillColor( rgb.color( "white" ) )
    sceneGroup:insert(headerui)
    sceneGroup:insert(footer)
    -- menuContainer code --
    menuContainer = display.newContainer( hideMenuX , hideMenuY )
    menuContainer:translate( hideMenuOriginX , hideMenuOriginY ) -- center the container
    hideMenu = display.newRect( hideMenuOriginX , hideMenuOriginY , hideMenuX , hideMenuY )
    hideMenu.id = 2
    menuContainer:insert( hideMenu , true ) -- true keeps the same positions between container and your children
     
    local subY = 75
    local subX = 50
    local quadY = 70

    profileText = display.newText( "Meu perfil", hideMenuOriginX + hideMenuX/2 + subX , hideMenuOriginY-100 , native.systemFontBold , 22 )
    profileText:setFillColor( rgb.color( "black" ) )
    myProdsText = display.newText( "Minhas publicações", hideMenuOriginX + hideMenuX/2 + subX , profileText.y+subY , native.systemFontBold , 22 )
    myProdsText:setFillColor( rgb.color( "black" ) )
    myPlaysText =display.newText( "Minhas jogadas", hideMenuOriginX + hideMenuX/2 + subX , myProdsText.y+subY , native.systemFontBold , 22 )
    myPlaysText:setFillColor( rgb.color( "black" ) )
    topProductsText =display.newText( "Produtos mais vistos", hideMenuOriginX + hideMenuX/2 + subX , myPlaysText.y+subY , native.systemFontBold , 22 )
    topProductsText:setFillColor( rgb.color( "black" ) )
    aboutText = display.newText( "Instruções", hideMenuOriginX + hideMenuX/2 + subX , topProductsText.y+subY , native.systemFontBold , 22 )
    aboutText:setFillColor( rgb.color( "black" ) )
    paymentMarketText = display.newText( "Loja/Pagamento", hideMenuOriginX + hideMenuX/2 + subX , aboutText.y+subY , native.systemFontBold , 22 )
    paymentMarketText:setFillColor( rgb.color( "black" ) )

    profileQuad = display.newRect( hideMenuX/2-150 , profileText.y  , hideMenuX , quadY )
    profileQuad:setFillColor( rgb.color( "gray" ) )
    profileQuad.alpha = 0.3
    prodsQuad = display.newRect( hideMenuX/2-150 , myProdsText.y  , hideMenuX , quadY )
    prodsQuad:setFillColor( rgb.color( "gray" ) )
    prodsQuad.alpha = 0.3
    playsQuad = display.newRect( hideMenuX/2-150 , myPlaysText.y  , hideMenuX , quadY )
    playsQuad:setFillColor( rgb.color( "gray" ) )
    playsQuad.alpha = 0.3
    aboutQuad = display.newRect( hideMenuX/2-150 , aboutText.y  , hideMenuX , quadY )
    aboutQuad:setFillColor( rgb.color( "gray" ) )
    aboutQuad.alpha = 0.3
    topQuad = display.newRect( hideMenuX/2-150 , topProductsText.y  , hideMenuX , quadY )
    topQuad:setFillColor( rgb.color( "gray" ) )
    topQuad.alpha = 0.3
    payQuad = display.newRect( hideMenuX/2-150 , paymentMarketText.y  , hideMenuX , quadY )
    payQuad:setFillColor( rgb.color( "gray" ) )
    payQuad.alpha = 0.3

    profileQuad:addEventListener( "touch" , touchListener )
    profileQuad.id = "profile"
    profileText:addEventListener( "touch" , touchListener )
    profileText.id = "profiletext"
    prodsQuad:addEventListener( "touch" , touchListener )
    prodsQuad.id= "prod"
    myProdsText:addEventListener( "touch" , touchListener )
    myProdsText.id="prodtext"
    playsQuad:addEventListener( "touch" , touchListener )
    playsQuad.id="play"
    myPlaysText:addEventListener( "touch" , touchListener )
    myPlaysText.id="playtext"
    aboutQuad:addEventListener( "touch" , touchListener )
    aboutQuad.id = "about"
    aboutText:addEventListener( "touch" , touchListener )
    aboutText.id = "aboutext"
    topQuad:addEventListener( "touch" , touchListener )
    topQuad.id ="top"
    topProductsText:addEventListener( "touch" , touchListener )
    topProductsText.id = "toptext"
    payQuad:addEventListener( "touch" , touchListener )
    payQuad.id = "pay"
    paymentMarketText:addEventListener( "touch" , touchListener )
    paymentMarketText.id = "paytext"



    menuContainer:insert( profileQuad , false )
    menuContainer:insert( prodsQuad , false )
    menuContainer:insert( playsQuad , false )
    menuContainer:insert( aboutQuad , false )
    menuContainer:insert( topQuad , false )
    menuContainer:insert( payQuad , false )
    menuContainer:insert( profileText , false ) -- false keeps objects in your positions
    menuContainer:insert( myProdsText , false ) 
    menuContainer:insert( myPlaysText , false ) 
    menuContainer:insert( topProductsText , false ) 
    menuContainer:insert( aboutText , false )
    menuContainer:insert( paymentMarketText , false )
    sceneGroup:insert(menuContainer)

    ---------x---------
    

    menuBt = widget.newButton {
        
        defaultFile = "pngs/baseline_menu_white_48dp.png",
        id = "menu",
        onEvent = listenerMenuButton
    }
    menuBt.x = 50 
    menuBt.y = _H/9

    addProdBt = widget.newButton {
        width = 70,
        height = 70,
        defaultFile = "pngs/sharp_add_box_black_48dp.png",
        id = "addProd" ,
        onEvent = listenerAddProd
    }
    addProdBt.x = centerX - 150
    addProdBt.y = footer.y - 70
    addProdText = display.newText( "Publique um produto!", addProdBt.x , addProdBt.y - 50 , native.systemFontBold , 22 )
    addProdText:setFillColor( rgb.color( "black" ) )

    advSearchBt = widget.newButton {
        width = 70,
        height = 70,
        defaultFile = "pngs/baseline_search_black_48dp.png",
        id = "advSearch" ,
        onEvent = listenerAdvSearch
    }

    advSearchBt.x = centerX + 150
    advSearchBt.y = footer.y - 70
    advSearchText = display.newText( "Pesquisa avançada", advSearchBt.x , advSearchBt.y - 50 , native.systemFontBold , 22 )
    advSearchText:setFillColor( rgb.color( "black" ) )

    sceneGroup:insert( menuBt )
    sceneGroup:insert( addProdBt )
    sceneGroup:insert( advSearchBt )
    sceneGroup:insert( addProdText )
    sceneGroup:insert( advSearchText )
    bkg:addEventListener( "touch" , touchListener )
    hideMenu:addEventListener( "touch" , touchListener )-----

    reqs.makeReq()

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
