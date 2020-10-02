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
local stateButton
local amountField
local slideActive = false
local icons = {}
local labels = {}
numPlays = 0

local options = {   -- Effects when scene changes
effect = "slideLeft",
time = 500
}

local customParams2 = {
    type = "" ,
    title ="" ,
    describ = "",
    state = "",
    city  = "" ,
    value = "" ,
    price = "" ,
    time  = ""
}

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function listenerNext( event )
  
    if ( "ended" == event.phase ) then
        --code
        if(globalData.devUi)then
            display.remove(sceneGroup)
            composer.removeScene("addProd2")
            composer.gotoScene("manageImage", options )

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

local function listenerConfirm( event )
  
    if ( "ended" == event.phase ) then
        if(slideActive)then
            display.remove(stateField)
            stateField = nil
            display.remove(confirmButton)
            confirmButton = nil
            slideActive = false
            stateButton:setLabel( "Estado" )
            end   
    end
end

local function touchListener( event ) -- Generic multilistener function
 
    --print( "Unique touch ID: " .. tostring(event.id) )
 
    if ( event.phase == "began" ) then
        
        --event.target.alpha = 0.5
        -- Set focus on object using unique touch ID
        display.getCurrentStage():setFocus( event.target, event.id )
 
        if( event.target.id == "bkg" )then
         if(slideActive)then
         display.remove(stateField)
         stateField = nil
         display.remove(confirmButton)
         confirmButton = nil
         slideActive = false
         end
        end
    elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
        
        
        -- Release focus on object

        display.getCurrentStage():setFocus( event.target, nil )
    end
    return true
end


local function slideListener(event) --Generic multilistener function for object list
    
    if ( event.phase == "began" ) then
      if(previousClicked == nil )then 
    
        previousClicked = icons[event.target.id]
        atualClicked = icons[event.target.id]
        atualClicked.alpha = 0.5
        print("previousID :"..previousClicked.id)
        print("atualID :"..atualClicked.id)
        previousClicked = atualClicked
      
      elseif(previousClicked ~= nil )then
       previousClicked.alpha = 1
       atualClicked = icons[event.target.id]
       atualClicked.alpha = 0.5
       print("previousID :"..previousClicked.id)
       print("atualID :"..atualClicked.id)
       previousClicked = atualClicked
       --previousClicked = icons[event.target.id] -- set the atual object clicked to previousClicked always that this fired  
      end
    
    elseif ( event.phase == "moved" ) then
         print("moved")
        --if(event.target.id=="sv")then
         print("scroll moved")
          local dx = math.abs( event.y - event.yStart ) 
          if ( dx > 10 ) then
          display.getCurrentStage():setFocus( event.target, event.id )
          stateField:takeFocus( event ) 
          end
       -- end
       

    elseif ( event.phase == "ended" or event.phase=="cancelled") then
     print(event.target.id)
     
     
    end
    
    return true
 end


local function showSlide( event )
     
    if ( "ended" == event.phase ) then
     if(slideActive == false)then
        --code
        slideActive = true
        stateField = widget.newScrollView
        {
            hideBackground = true,
            width = stateButton.width,
            height = _H/2.4,
            scrollWidth = stateButton.width,
            scrollHeight =  _H,
			horizontalScrollDisabled = true,
            --verticalScrollDisabled = true
            --listener = iconListener
        }
        stateField.id ="sv"
        stateField.x = centerX
        stateField.y = stateButton.y + stateField.height/2 + stateButton.height/2 
        --sceneGroup:insert( stateField ) 
        
        aux = _H/32 --30
        aux2 = 0
        for i = 1, 27 do
               icons[i] = display.newRect( centerX-125  , aux+aux2  , stateButton.width , _H/19.2 )
               --icons[i]:setFillColor( math.random(), math.random(), math.random() )
               icons[i]:setFillColor( rgb.color( "white" ) )
               labels[i]=display.newText( i , icons[i].x , icons[i].y , native.systemFon, 20 )
               labels[i]:setFillColor( rgb.color( "black" ) )
               stateField:insert( icons[i] ) 
               stateField:insert(labels[i])
               icons[i].alpha = 1.0
               icons[i].id = i
               aux2 = _H/17.4 --60
               aux = icons[i].y
               icons[i]:addEventListener( "touch", slideListener )
                
               		   
        end
        sceneGroup:insert( stateField )
        confirmButton = widget.newButton(   -- customized settings 
     {
         label = "Confirma",
         onEvent =  listenerConfirm, -- listenerSkip
         emboss = false,
         id = "c",
         font = native.systemFontBold ,
         fontSize = 25 ,
         -- Properties for a rounded rectangle button
         shape = "rect",
         width = stateButton.width,
         height = _H/18,
         fillColor = { default= { rgb.color( "black" ) } , over = { rgb.color( "gray" ) } },
         labelColor = { default= { rgb.color( "white" ) } , over = { rgb.color( "white" ) } }
         
     }
 )
        confirmButton.x = centerX
        confirmButton.y = stateButton.y 
        sceneGroup:insert( confirmButton )
    end --slideActive end if
        
         
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
    bkg:addEventListener( "touch", touchListener )
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

    stateButton = widget.newButton(   -- customized settings 
     {
         label = "Selecione seu estado",
         onEvent = showSlide,
         emboss = false,
         font = native.systemFont ,
         fontSize = 30 ,
         -- Properties for a rounded rectangle button
         shape = "rect",
         width = quad.width * 0.7 ,
         height = 50,
         fillColor = { default= { rgb.color( "white" ) } , over = { rgb.color( "gray" ) } },
         labelColor = { default= { rgb.color( "black" ) } , over = { rgb.color( "gray" ) } }
         
     }
 )
 stateButton.x = centerX
 stateButton.y =  headerui.y + _H/5
 sceneGroup:insert(stateButton)

 cityField = native.newTextField( centerX ,  stateButton.y + _H/10 , quad.width * 0.5 , _H/19 )
 cityField.text = "Cidade"
 sceneGroup:insert( cityField )

 amountField = native.newTextField( centerX ,  cityField.y + _H/10 , quad.width * 0.7 , _H/19 )
 amountField.text = "Preencha o valor total que queira arrecadar no produto"
 sceneGroup:insert( amountField)

 priceField = native.newTextField( centerX , amountField.y + _H/10 , quad.width * 0.7 , _H/19 )
 priceField.text = "Preencha o preço da jogada"
 sceneGroup:insert(priceField)

numPlaysText = display.newText( "Numero de jogadas :".." "..20000, centerX ,  priceField.y + _H/10 , native.systemFont, 30 )
numPlaysText:setFillColor( rgb.color( "black" ) )
sceneGroup:insert(numPlaysText)

timeField = native.newTextField( centerX , numPlaysText.y + _H/10 , quad.width * 0.7 , _H/19 )
timeField.text = "Tempo de duração do sorteio/jogo"
sceneGroup:insert(timeField)

nextButton = widget.newButton(  -- customized settings 
     {
         label = "Avançar",
         onEvent = listenerNext,
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