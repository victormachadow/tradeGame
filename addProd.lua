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
local slideActive = false
local icons = {}
local labels = {}

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function touchListener( event ) -- Generic multilistener function
 
    --print( "Unique touch ID: " .. tostring(event.id) )
 
 if ( event.phase == "began" ) then
        
        --event.target.alpha = 0.5
        -- Set focus on object using unique touch ID
        display.getCurrentStage():setFocus( event.target, event.id )
 
        if( event.target.id == "bkg" )then
         if(slideActive)then
         display.remove(typeField)
         typeField = nil
         display.remove(confirmButton)
         confirmButton = nil
         slideActive = false
         end
        end
    if ( event.target.id == "c")then
        if(slideActive)then
            display.remove(typeField)
            typeField = nil
            display.remove(confirmButton)
            confirmButton = nil
            slideActive = false
            typeButton:setLabel("Tipo")
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
          typeField:takeFocus( event ) 
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
        typeField = widget.newScrollView
        {
            hideBackground = true,
            width = typeButton.width,
            height = _H/2.4,
            scrollWidth = typeButton.width,
            scrollHeight = _H/2.4,
			horizontalScrollDisabled = true,
            --verticalScrollDisabled = true
            --listener = iconListener
        }
        typeField.id ="sv"
        typeField.x = centerX
        typeField.y = typeButton.y + typeField.height/2 + typeButton.height/2
        --sceneGroup:insert( typeField ) 
        
        aux = _H/32 --30
        aux2 = 0
        for i = 1, 27 do
               icons[i] = display.newRect( centerX-125  , aux+aux2  , typeButton.width , _H/19.2 )
               --icons[i]:setFillColor( math.random(), math.random(), math.random() )
               icons[i]:setFillColor( rgb.color( "white" ) )
               labels[i]=display.newText( i , icons[i].x , icons[i].y , native.systemFon, 20 )
               labels[i]:setFillColor( rgb.color( "black" ) )
               typeField:insert( icons[i] ) 
               typeField:insert(labels[i])
               icons[i].alpha = 1.0
               icons[i].id = i
               aux2 = _H/17.4 --60
               aux = icons[i].y
               icons[i]:addEventListener( "touch", slideListener )
                
               		   
        end
        sceneGroup:insert( typeField )
        confirmButton = widget.newButton(   -- customized settings 
     {
         label = "Confirma",
         onEvent = touchListener , -- listenerSkip
         id = "c",
         emboss = false,
         font = native.systemFontBold ,
         fontSize = 25 ,
         -- Properties for a rounded rectangle button
         shape = "rect",
         width = typeButton.width*0.8,
         height = _H/18,
         fillColor = { default= { rgb.color( "black" ) } , over = { rgb.color( "gray" ) } },
         labelColor = { default= { rgb.color( "white" ) } , over = { rgb.color( "white" ) } }
         
     }
 )
        confirmButton.x = centerX
        confirmButton.y = typeField.y + typeField.height/2 + confirmButton.height/2
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

    typeButton = widget.newButton(   -- customized settings 
    {
        label = "Selecione o tipo",
        onEvent = showSlide,
        emboss = false,
        font = native.systemFont ,
        fontSize = 20 ,
        -- Properties for a rounded rectangle button
        shape = "rect",
        width = quad.width*0.7,
        height = _H/16,
        fillColor = { default= { rgb.color( "white" ) } , over = { rgb.color( "gray" ) } },
        labelColor = { default= { rgb.color( "black" ) } , over = { rgb.color( "gray" ) } }
        
    }
)
typeButton.x = centerX
typeButton.y =  headerui.y + _H/4,8
sceneGroup:insert(typeButton)

titleBox = native.newTextBox( centerX, typeButton.y + _H/6.6 , quad.width*0.7, _H/9.6 )
titleBox.text = "Digite o titulo do produto , no maximo 20 caracteres"
titleBox.isEditable = true
titleBox.size = 28
sceneGroup:insert(titleBox)

describBox = native.newTextBox( centerX, titleBox.y + _H/4.8 , quad.width*0.7, _H/4.8 )
describBox.text = "Decreva seu produto , no maximo 100 caracteres"
describBox.isEditable = true
describBox.size = 28
sceneGroup:insert(describBox)


--titleBox:addEventListener( "userInput", textListener )
   


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