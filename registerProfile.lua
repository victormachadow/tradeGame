

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
-- profile fields
local userNameField -- name
local completeNameField
local cpfField
local phoneNumberField
local phoneNumberField2 -- optional
local genderFieldH -- radio button
 -- x --
local genderFieldM -- radio button
local genderText
local genderHText
local genderMText
local quad
local skipButton
local nextButton
local accIcon
local headerTagText
local header
dadosCache = { ["iduser"] = nil , ["email"] = "" , ["name"] = "" , ["pass"] = "" , ["token"] = "" , ["cached"] = 0 , ["dadosComp"] = 0 }

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
            composer.gotoScene("registerLocation", options )

        end
    end
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
    bkg = display.newImage( "pngs/green.jpg" )
    --bkg:setReferencePoint( display.CenterReferencePoint )
    bkg.x = display.contentCenterX
    bkg.y = display.contentCenterY
    sceneGroup:insert( bkg )

    quad = display.newRect( centerX , centerY , 450  , _H-100 -_H/10 )
    quad:setFillColor( rgb.color( "white" ) )
    quad.alpha = 0.5
    sceneGroup:insert(quad)
    header = display.newRect( quad.x , centerY-quad.height/2*scaleY  , quad.width , 60*scaleY )
    header:setFillColor( rgb.color( "black" ) )
    sceneGroup:insert(header)
    accIcon = display.newImage( "pngs/sharp_account_circle_black_48dp_96.png" )
    accIcon:translate( centerX , header.y + accIcon.height )
    sceneGroup:insert(accIcon)
    headerTagText = display.newText( "Complete seu perfil", centerX , header.y , native.systemFontBold, 25 )
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

local d = 35*scaleY -- Vertical distance between textfields
userNameField = native.newTextField( centerX , accIcon.y+accIcon.height , quad.width - 100 , 50 )
userNameField.text = "Nome"
--userNameField:addEventListener( "userInput", passListener )
--userNameField.hasBackground = false
sceneGroup:insert(userNameField)
completeNameField = native.newTextField( centerX , userNameField.y+userNameField.height + d , quad.width - 100 , 50 )
completeNameField.text = "Seu nome completo"
--userNameField:addEventListener( "userInput", passListener )
--userNameField.hasBackground = false
sceneGroup:insert(completeNameField)
cpfField = native.newTextField( centerX , completeNameField.y+completeNameField.height + d , quad.width - 100 , 50 )
cpfField.text = "Cpf ou Cnpj"
--userNameField:addEventListener( "userInput", passListener )
--userNameField.hasBackground = false
sceneGroup:insert(cpfField)

phoneNumberField = native.newTextField( centerX , cpfField.y+cpfField.height + d , quad.width - 100 , 50 )
phoneNumberField.text = "Numero telefone 1"
--userNameField:addEventListener( "userInput", passListener )
--userNameField.hasBackground = false
sceneGroup:insert(phoneNumberField)

phoneNumberField2 = native.newTextField( centerX , phoneNumberField.y+phoneNumberField.height + d , quad.width - 100 , 50 )
phoneNumberField2.text = "Numero telefone 2"
--userNameField:addEventListener( "userInput", passListener )
--userNameField.hasBackground = false
sceneGroup:insert(phoneNumberField2)
genderText = display.newText( "Sexo :", centerX-180 , phoneNumberField2.y+phoneNumberField2.height + d , native.systemFont, 25 )
genderText:setFillColor( rgb.color( "black" ) )
sceneGroup:insert(genderText)

genderFieldH = widget.newSwitch(
    {
        style = "radio",
        id = "masc",
        initialSwitchState = false,
        onPress = onSwitchPress
    }
)
genderFieldH.x = genderText.x + genderText.width
genderFieldH.y = phoneNumberField2.y+phoneNumberField2.height + d
genderHText = display.newText( "Masculino", genderFieldH.x + 80 , phoneNumberField2.y+phoneNumberField2.height + d , native.systemFont, 25 )
genderHText:setFillColor( rgb.color( "black" ) )
sceneGroup:insert(genderFieldH)
sceneGroup:insert(genderHText)

genderFieldM = widget.newSwitch(
    {
        style = "radio",
        id = "fem",
        initialSwitchState = false,
        onPress = onSwitchPress
    }
)
genderFieldM.x = genderHText.x + genderHText.width/2 + 30
genderFieldM.y = phoneNumberField2.y+phoneNumberField2.height + d
genderMText = display.newText( "Feminino", genderFieldM.x + 80 , phoneNumberField2.y+phoneNumberField2.height + d , native.systemFont, 25 )
genderMText:setFillColor( rgb.color( "black" ) )
sceneGroup:insert(genderFieldM)
sceneGroup:insert(genderMText)


for i=sceneGroup.numChildren,1, -1 do -- Resize components size by screen scale
        
    print("Largura :"..sceneGroup[i].width)
    print("Altura :"..sceneGroup[i].height)
    --print(sceneGroup[i])

    sceneGroup[i].width = sceneGroup[i].width*scaleX
    sceneGroup[i].height = sceneGroup[i].height*scaleY

    end

     --[[
     completeNameField
     cpfField
     emailPaypalField
     phoneNumberField
     phoneNumberField2 -- optional
     cepField --optional
     adressField
     numberField
     complementField
     stateField
     cityField
    -- Code here runs when the scene is first created but has not yet appeared on screen
    --]]
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