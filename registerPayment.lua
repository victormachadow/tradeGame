

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
 
 -- vars --
 local scene = composer.newScene()
 local sceneGroup = display.newGroup()
 local bkg
 
  -- payment fields --

 local quad
 local skipButton
 local nextButton
 local paymentButton
 local receivementButton
 local accIcon
 local headerTagText
 local topText
 local header
 local headerTop
 
 
 local options = {   -- Effects when scene changes
 effect = "slideRight",
 time = 500
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
             composer.removeScene("registerProfile")
             composer.gotoScene("mainFloor", options )
 
         end
     end
 end
 
  
 -- -----------------------------------------------------------------------------------
 -- Scene event functions
 -- -----------------------------------------------------------------------------------
 
 -- create()
 function scene:create( event )
  

     local sceneGroup = self.view
 
     --bkg = display.newImage( "pngs/green.jpg" )
     --sceneGroup:insert(bkg)
     bkg = display.newImage( "pngs/green.jpg" )
     --bkg:setReferencePoint( display.CenterReferencePoint )
     bkg.x = display.contentCenterX
     bkg.y = display.contentCenterY
     sceneGroup:insert( bkg )
     referenceQuadY = 0
     headerTop = display.newRect( centerX , 0 , _W , _H/6.2 )
     headerTop:setFillColor( rgb.color( "black" ) )
     topText = display.newText( "Utima etapa..", centerX , headerTop.y+headerTop.height/3.4 , native.systemFont, 30 )
     sceneGroup:insert( headerTop )
     sceneGroup:insert( topText )
     quad = display.newRect( centerX , centerY-referenceQuadY , _W/2*1.8  , _H/2+50 )
     quad:setFillColor( rgb.color( "white" ) )
     quad.alpha = 0.5
     sceneGroup:insert(quad)
     header = display.newRect( quad.x , centerY-quad.height/2*scaleY - referenceQuadY , quad.width , 70*scaleY )
     header:setFillColor( rgb.color( "black" ) )
     sceneGroup:insert(header)
     accIcon = display.newImage( "pngs/sharp_payment_black_48dp_96.png" )
     accIcon:translate( centerX , header.y + accIcon.height*1.3 )
     sceneGroup:insert(accIcon)
     headerTagText = display.newText( "Dados bancários", centerX , header.y , native.systemFont, 30 )
     headerTagText:setFillColor( rgb.color( "white" ) )
     sceneGroup:insert(headerTagText)

     paymentButton =  widget.newButton(   -- customized settings 
     {
         label = "Adicionar forma de pagamento",
         --onEvent =  listenerNext, -- listenerSkip
         emboss = false,
         id = "pay",
         font = native.systemFontBold,
         fontSize = 25 ,
         -- Properties for a rounded rectangle button
         shape = "rect",
         width = _W/2*1.6,
         height = 80,
         fillColor = { default= { rgb.color( "white" ) } , over = { rgb.color( "gray" ) } },
         labelColor = { default= { rgb.color( "black" ) } , over = { rgb.color( "white" ) } }
         
     }
 )

 paymentButton.x = centerX
 paymentButton.y = accIcon.y+accIcon.height*1.2
 sceneGroup:insert(paymentButton)
 receivementButton = widget.newButton(   -- customized settings 
 {
     label = "Adicionar conta de recebimento",
     --onEvent =  listenerNext, -- listenerSkip
     emboss = false,
     id = "rec",
     font = native.systemFontBold,
     fontSize = 25 ,
     -- Properties for a rounded rectangle button
     shape = "rect",
     width = _W/2*1.6,
     height = 80,
     fillColor = { default= { rgb.color( "white" ) } , over = { rgb.color( "gray" ) } },
     labelColor = { default= { rgb.color( "black" ) } , over = { rgb.color( "white" ) } }
     
 }
)
 receivementButton.x = centerX
 receivementButton.y = paymentButton.y+paymentButton.height+35
 sceneGroup:insert(receivementButton)


     --receivementButton = 
 
     skipButton = widget.newButton(   -- customized settings 
     {
         label = "Pular",
         onEvent =  listenerNext, -- listenerSkip
         emboss = false,
         font = native.systemFontBold,
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
 skipButton.y = centerY + (quad.height/2 - 55) - referenceQuadY
 sceneGroup:insert(skipButton)
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
 nextButton.y = centerY + (quad.height/2 - 55) - referenceQuadY
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