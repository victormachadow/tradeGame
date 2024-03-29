 ------ Screen resources --------
 local centerX = display.contentCenterX
 local centerY = display.contentCenterY
 local _W = display.contentWidth
 local _H = display.contentHeight
 
 -- Initial components sizes developed based on 640x960 screen size
 -- scaleX  = 1.7, scaleY = 2 for 1080x1920
 scaleX = 1.7
 scaleY = 2
 
 local composer = require( "composer" )
 local rgb = require "_rgb"
 local json = require "json"
 local globalData = require("globalData")
 local widget = require("widget")
 local loadsave = require("loadsave")
 --decoded = loadsave.loadTable("cache.json")
 
  -- vars --
 
 local scene = composer.newScene()
 local sceneGroup = display.newGroup()
 local bkg 
 local scene = composer.newScene()
 local stCadastre
 local stEmail
 local stPass
 local emailField
 local passField
 local logaBt
 local faceBookText
 local facebookButton
 local quad
 dadosCache = { ["iduser"] = nil , ["email"] = "" , ["name"] = "" , ["pass"] = "" , ["token"] = "" , ["cached"] = 0 , ["dadosComp"] = 0 }
 local saveCache
 
 local params = {}
 local dataSend = { ["email"] ="" , ["pass"] ="" }
 local headers = {}
   -- token , depois muda isso..
  
 local options = {   -- Effects when scene changes
 effect = "slideRight",
 time = 500
 }
 -- -----------------------------------------------------------------------------------
 -- Code outside of the scene event functions below will only be executed ONCE unless
 -- the scene is removed entirely (not recycled) via "composer.removeScene()"
 -- -----------------------------------------------------------------------------------
 
 -- Listeners --
 
 local function atualizaCache() -- ESTA FUNCIONANDO
 
     dadosCache["iduser"] = globalData.id
     dadosCache["email"] = globalData.email
     dadosCache["name"] = globalData.name
     dadosCache["pass"] = globalData.pass
     dadosCache["token"] = globalData.token
     dadosCache["cached"] = globalData.cached
     dadosCache["dadosComp"] = globalData.dadosComp
     if ( loadsave.saveTable( dadosCache, "cache.json") ) then
    
         display.remove(sceneGroup)
         composer.removeScene("register")
         composer.gotoScene("registerProfile", options )
 
     
     else
 
         print("nao")
 
     end
 end
 
 local function genericNetworkListenerID( event )
     
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
           
         -- salva o id em cache
        
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
           print(decodedStats)
         -- Se cadastro com sucesso , pegar o id para salvar em cache
        
        end
   
              
 end
 
 local function loginListener( event )
 
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
            if(decodedStats["return"] == 0 )then
             print( "Esse email já existe" )
 
            end
            if(decodedStats["return"] == 1 )then
            print( "Id eh: "..decodedStats["id"])
            print( "Token eh: "..decodedStats["token"])
            globalData.id = decodedStats["id"]
            globalData.token = decodedStats["token"]
            globalData.cached = 1
            atualizaCache()
         -- Se cadastro com sucesso , pegar o id para salvar em cache
 
         --[[
         headers2 = {}
         headers2["Content-Type"] = "application/json"
         headers2["X-API-Key"] = decodedStats["token"]
         params2 = {}
         data2 = {["teste"] ="teste"}
         params2.headers = headers2
         params2.body = json.encode(data2)
         
         network.request("http://10.0.3.248:8080/tradeGame_api/tests/validToken.php", "POST",  genericNetworkListener , params2 )
         --]]
 
            end
        end
 
 end   
 
 
 local function emailListener( event )
 
     if( event.target.text =="Insira seu email" )then
         event.target.text ="" 
     end
 
     if ( event.phase == "began" ) then
         -- User begins editing "defaultField"
 
     elseif ( event.phase == "ended" or event.phase == "submitted" ) then
         -- Output resulting text from "defaultField"
         print( event.target.text )
         
         if( event.target.text =="" ) then
             event.target.text = "Insira seu email"
         else
         dataSend["email"] = event.target.text
         end
  
     elseif ( event.phase == "editing" ) then
         print( event.newCharacters )
         print( event.oldText )
         print( event.startPosition )
         print( event.text )
     end
 end
 
 local function passListener( event )
 
     if( event.target.text =="Senha minimo 6 digitos" )then
         event.target.text ="" 
     end
     if ( event.phase == "began" ) then
         -- User begins editing "defaultField"
         event.target.text =""
  
     elseif ( event.phase == "ended" or event.phase == "submitted" ) then
         -- Output resulting text from "defaultField"
         print( event.target.text )
         if( event.target.text =="" ) then
             event.target.text = "Insira sua senha"
         else
         dataSend["pass"] = event.target.text
         end
  
     elseif ( event.phase == "editing" ) then
         print( event.newCharacters )
         print( event.oldText )
         print( event.startPosition )
         print( event.text )
     end
 end
 
 local function login( event )
  
     if ( "ended" == event.phase ) then
         --code
         if(globalData.devUi)then
             display.remove(sceneGroup)
             composer.removeScene("register")
             composer.gotoScene("registerProfile", options )
 
         end
         
         headers["Content-Type"] = "application/json"
         headers["X-API-Key"] = "13b6ac91a2"
         dataSend["email"] = emailField.text
         dataSend["pass"]  = passField.text
         globalData.email = dataSend["email"]
         globalData.pass = dataSend["pass"]
         params.headers = headers
         params.body = json.encode(dataSend)
        network.request("http://10.0.3.248:8080/tradeGame_api/login.php", "POST",  loginListener , params )
 
 
     end
 end
 
 
 
 -- -----------------------------------------------------------------------------------
 -- Scene event functions
 -- -----------------------------------------------------------------------------------
 
 -- create()
 function scene:create( event )
     print(globalData.token)
     local sceneGroup = self.view
     -- Code here runs when the scene is first created but has not yet appeared on screen
     --bkg = display.newRect( centerX , centerY , _W, _H )
     bkg = display.newImage( "pngs/green.jpg" )
     --bkg:setReferencePoint( display.CenterReferencePoint )
     bkg.x = display.contentCenterX
     bkg.y = display.contentCenterY
     sceneGroup:insert( bkg )
     --bkg:setFillColor( rgb.color( "darkgreen" ) )
 
     quad = display.newRect( centerX , centerY-150 , 450 , 600 )
     quad:setFillColor( rgb.color( "white" ) )
     quad.alpha = 0.5
     lockIcon = display.newImage( "pngs/sharp_lock_black_48dp_96.png" )
     lockIcon:translate( centerX , centerY-220 )
     sceneGroup:insert(bkg)
     sceneGroup:insert(quad)
     sceneGroup:insert(lockIcon)
     emailField = native.newTextField( centerX, centerY-120 , 300 , 50 )
     emailField.text = "Insira seu email"
     emailField:addEventListener( "userInput", emailListener )
     --emailField.hasBackground = false
     sceneGroup:insert(emailField)
     
     passField = native.newTextField( centerX, centerY-50 , 300 , 50 )
     passField.text = "Senha minimo 6 digitos"
     passField:addEventListener( "userInput", passListener )
     --passField.hasBackground = false
     sceneGroup:insert(passField)
 
     --stEmail = display.newText( "Insira o email abaixo", centerX , emailField.y - 55 , native.systemFont, 22 )
     --stPass = display.newText( "Insira a senha abaixo", centerX , passField.y - 55 , native.systemFont, 22 )
     stCadastre = display.newText( "Login", centerX , lockIcon.y - 120 ,  native.systemFont, 52 )
     stCadastre:setFillColor( rgb.color( "black" ) )
     sceneGroup:insert(stCadastre)
   
     logaBt =  widget.newButton(   -- customized settings 
     {
         label = "Entrar",
         onEvent = login,
         emboss = false,
         font = native.systemFontBold ,
         fontSize = 25 ,
         -- Properties for a rounded rectangle button
         shape = "rect",
         width = 200,
         height = 80,
         fillColor = { default= { rgb.color( "black" ) } , over = { rgb.color( "gray" ) } },
         labelColor = { default= { rgb.color( "white" ) } , over = { rgb.color( "white" ) } }
         
     }
 )
 logaBt.x = centerX 
 logaBt.y = passField.y + (passField.height + 30 )
 sceneGroup:insert(logaBt)
 
 
 
 
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