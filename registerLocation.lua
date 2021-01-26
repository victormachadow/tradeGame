

 ------ Screen resources --------
 local centerX = display.contentCenterX
 local centerY = display.contentCenterY
 local _W = display.contentWidth
 local _H = display.contentHeight
 
 -- Initial components sizes developed based on 640x960 screen size
 -- scaleX  = 1.7, scaleY = 2 for 1080x1920
 -- scaleX = 1.17 , scaleY = 2.53    for 1125x2436 iphoneX
 scaleX = 1
 scaleY = 1
 
 local composer = require( "composer" )
 local rgb = require "_rgb"
 local globalData = require("globalData")
 local widget = require("widget")
 local composer = require( "composer" )
 local loadsave = require("loadsave")
 --decoded = loadsave.loadTable("cache.json")
 
 -- vars --
 local scene = composer.newScene()
 local sceneGroup = display.newGroup()
 local bkg

--location fields
 local cepField --optional
 local adressField
 local numberField
 local complementField
 local stateField -- state list
 local cityField -- optional
 local quad
 local skipButton
 local nextButton
 local confirmButton
 local localIcon
 local headerTagText
 local header
 local icons = {}
local labels = {}
local slideActive = false
local arrowUp
local arrowDown
local previousClicked
local atualClicked
dadosCache = { ["iduser"] = nil , ["email"] = "" , ["name"] = "" , ["pass"] = "", ["token"] = ""  }
 
 local options = {   -- Effects when scene changes
 effect = "slideRight",
 time = 500
 }
 
 
 
 -- -----------------------------------------------------------------------------------
 -- Code outside of the scene event functions below will only be executed ONCE unless
 -- the scene is removed entirely (not recycled) via "composer.removeScene()"
 -- -----------------------------------------------------------------------------------
 
 local function iconListener( event )
    local id = event.target.id
    --print(id)
 
    if ( event.phase == "moved" ) then
       
        --stateField:takeFocus( event )
        print("eventx :"..event.x)
        print("eventxStart :"..event.xStart)
        local dx = math.abs( event.y - event.yStart ) 
        if ( dx > 5 ) then
        display.getCurrentStage():setFocus( event.target, event.id )
        stateField:takeFocus( event ) 
        end
        
    elseif ( event.phase == "ended" ) then
        display.getCurrentStage():setFocus( nil )
        
    end
    return true
end

 
 local function listenerNext( event )
  
     if ( "ended" == event.phase ) then
         --code
         if(globalData.devUi)then
             display.remove(sceneGroup)
             composer.removeScene("registerLocation")
             composer.gotoScene("registerPayment", options )
 
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

       if type(decodedStats) == "table" then 
          
       
       end
  
             
end

local function registerMore()



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
          if ( dx > 5 ) then
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
            height = 400,
            scrollWidth = stateButton.width,
            scrollHeight = 2000,
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
               icons[i] = display.newRect( stateField.x - 200  , aux+aux2  , stateButton.width , _H/19.2 )
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

 
  
 -- -----------------------------------------------------------------------------------
 -- Scene event functions
 -- -----------------------------------------------------------------------------------
 
 -- create()
 function scene:create( event )
  
 --[[ A way to adjust the components sizes to 1080x1920 screen or whatever W x H screen is:
  * getting the scaleX and scaleY by scaleX = _W/640 and scaleY = _H/960 , that is the original components size 
  * multiplies the x , y component's sizes to scaleX and scaleY respectively 
   -- NOT WORKS WELL --
 
 --]]
 
     local sceneGroup = self.view
 
     --bkg = display.newImage( "pngs/green.jpg" )
     --sceneGroup:insert(bkg)
     system.activate( "multitouch" )
     bkg = display.newImage( "pngs/green.jpg" )
     --bkg:setReferencePoint( display.CenterReferencePoint )
     bkg.x = display.contentCenterX
     bkg.y = display.contentCenterY
     bkg.id = "bkg"
     bkg:addEventListener( "touch", touchListener )
     sceneGroup:insert( bkg )
 
     quad = display.newRect( centerX , centerY , _W/1.4  , _H-100 -_H/10 )
     quad:setFillColor( rgb.color( "white" ) )
     quad.alpha = 0.5
     sceneGroup:insert(quad)
     header = display.newRect( quad.x , centerY-quad.height/2 , quad.width , 60*scaleY )
     header:setFillColor( rgb.color( "black" ) )
     sceneGroup:insert(header)
     accIcon = display.newImage( "pngs/sharp_account_circle_black_48dp_96.png" )
     accIcon:translate( centerX , header.y + accIcon.height )
     sceneGroup:insert(accIcon)
     
     headerTagText = display.newText( "Localização", centerX , header.y , native.systemFontBold, 25 )
     headerTagText:setFillColor( rgb.color( "white" ) )
     sceneGroup:insert(headerTagText)
 
     skipButton = widget.newButton(   -- customized settings 
     {
         label = "Pular",
         onEvent =  listenerNext, -- listenerSkip
         emboss = false,
         font = native.systemFontBold ,
         fontSize = 25 ,
         -- Properties for a rounded rectangle button
         shape = "rect",
         width = 150,
         height = 80,
         fillColor = { default= { rgb.color( "white" ) } , over = { rgb.color( "gray" ) } },
         labelColor = { default= { rgb.color( "black" ) } , over = { rgb.color( "white" ) } }
         
     }
 )
   skipButton.x = centerX - (quad.width/2 - 80)
   skipButton.y = centerY + (quad.height/2 - 55)
   sceneGroup:insert(skipButton)
   nextButton = widget.newButton(   -- customized settings 
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

 --[[
 local cepField --optional
 local adressField
 local numberField
 local complementField
 local stateField -- state list
 local cityField
 --]]
 
 local d = 35*scaleY -- Vertical distance between textfields
 cepField = native.newTextField( centerX , accIcon.y+accIcon.height , quad.width - 100 , 50 )
 cepField.text = "Cep"
 --userNameField:addEventListener( "userInput", passListener )
 --userNameField.hasBackground = false
 sceneGroup:insert(cepField)

 adressField = native.newTextField( centerX , cepField.y+cepField.height + d , quad.width - 100 , 50 )
 adressField.text = "Endereço"
 --userNameField:addEventListener( "userInput", passListener )
 --userNameField.hasBackground = false
 sceneGroup:insert(adressField)

 numberField = native.newTextField( centerX , adressField.y+adressField.height + d , quad.width - 100 , 50 )
 numberField.text = "Numero"
 --userNameField:addEventListener( "userInput", passListener )
 --userNameField.hasBackground = false
 sceneGroup:insert(numberField)
 complementField = native.newTextField( centerX , numberField.y+numberField.height + d , quad.width - 100 , 50 )
 complementField.text = "Complemento"
 --userNameField:addEventListener( "userInput", passListener )
 --userNameField.hasBackground = false
 sceneGroup:insert(complementField)

 cityField = native.newTextField( centerX , complementField.y+complementField.height + d , quad.width - 100 , 50 )
 cityField.text = "Cidade"
 --userNameField:addEventListener( "userInput", passListener )
 --userNameField.hasBackground = false
 sceneGroup:insert(cityField)

  stateButton = widget.newButton(   -- customized settings 
     {
         label = "Selecione seu estado",
         onEvent = showSlide,
         emboss = false,
         font = native.systemFont ,
         fontSize = 20 ,
         -- Properties for a rounded rectangle button
         shape = "rect",
         width = complementField.width - 100,
         height = 50,
         fillColor = { default= { rgb.color( "white" ) } , over = { rgb.color( "gray" ) } },
         labelColor = { default= { rgb.color( "black" ) } , over = { rgb.color( "gray" ) } }
         
     }
 )
 stateButton.x = centerX
 stateButton.y =  cityField.y + d*2
 sceneGroup:insert(stateButton)


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