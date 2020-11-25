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
local savePhotoBt
numPlays = 0

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

local photoFiles = {
	"photos/Arch01.jpg",
	"photos/Biloxi05.jpg",
	"photos/Butterfly01.jpg",
	"photos/DSC6722.jpg",
	"photos/DSC_7743.jpg",
	"photos/ElCap.jpg",
	"photos/FlaKeysSunset.jpg",
	"photos/MaimiSkyline.jpg",
	"photos/MtRanier8x10.jpg",
	"photos/Tulip.jpg",
	"photos/WhiteTiger.jpg",
	"photos/Yosemite Valley.jpg"
}

 ------ Send photo module -------
local url = "http://10.0.3.248:8080/tradeGame_api/upload.php"
local method = "PUT"
local params = {
   timeout = 60,
   progress = true,
   bodyType = "binary"
}

 -- will generate a random name to each photo
local id = 1
local actualN = 1
local filename = tostring(id).."_"..tostring(actualN)..".jpg"
local baseDir = system.TemporaryDirectory
local contentType = "image/jpg"  --another option is "text/plain"
local headers = {}
headers.filename = filename
params.headers = headers
local img


local photo		-- holds the photo object
local PHOTO_FUNCTION = media.PhotoLibrary 		-- or media.SavedPhotosAlbum

----------x---------

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

function getfilename()

    name =tostring(id).."_"..tostring(actualN)..".jpg" 
    --name =tostring(1).."_"..tostring(1)..".jpg"
    print(name)
   filename = name
    end


local function fitImage( displayObject, fitWidth, fitHeight, enlarge )
	--
	-- first determine which edge is out of bounds
    --
  if (  displayObject ~= nil  )then

	local scaleFactor = fitHeight / displayObject.height 
	local newWidth = displayObject.width * scaleFactor
	if newWidth > fitWidth then
		scaleFactor = fitWidth / displayObject.width 
	end
	if not enlarge and scaleFactor > 1 then
		return
	end
    displayObject:scale( scaleFactor, scaleFactor )
  end
end

------- Send photo listeners --------

local function uploadListener( event )
    if ( event.isError ) then
       print( "Network Error." )
 
 
    else
       if ( event.phase == "began" ) then
          print( "Upload started" )
       elseif ( event.phase == "progress" ) then
          print( "Uploading... bytes transferred ", event.bytesTransferred )
       elseif ( event.phase == "ended" ) then
          print( "Upload ended..." )
          print( "Status:", event.status )
          print( "Response:", event.response )
          --show recently photo uploaded
           if( img ~=nil )then
           display.remove(img)
           img = nil 
           end
           --[[
          timer.performWithDelay( 2000 , function()
          
           img = display.newImage( filename , system.TemporaryDirectory ,  centerX , centerY )
           --display.save( img, filename [, baseDir] )
           --display.save( img , { filename=filename, baseDir=system.TemporaryDirectory } )
           media.save( img , system.TemporaryDirectory )
 
           fitImage( img , _H/3.2 , _H/4.8 , false )
           
           actualN = actualN + 1
           
           getfilename()
           
           print("filename now is:"..filename)
           
           
          end , 1 )
          --]]
       end
    end
 end
 
 
 local sessionComplete = function(event)
     photo = event.target
     
     --network.upload( url , method, uploadListener, params, filename, baseDir , contentType )
     
     if photo then
 
         if photo.width > photo.height then
             photo:rotate( -90 )			-- rotate for landscape
             print( "Rotated" )
         end
         
         -- Scale image to fit content scaled screen
         local xScale = _W / photo.contentWidth
         local yScale = _H / photo.contentHeight
         local scale = math.max( xScale, yScale ) * .75
         photo:scale( scale, scale )
         photo.x = centerX
         photo.y = centerY
         print( "photo w,h = " .. photo.width .. "," .. photo.height, xScale, yScale, scale )
         --print(photo.baseDir)
         --network.upload( url , method, uploadListener, params, filename, baseDir , contentType )
 
     else
         print("No Image Selected")
         if( img ~=nil )then
            display.remove(img)
            img = nil 
         end

           timer.performWithDelay( 2000 , function()
          
           img = display.newImage( filename , system.TemporaryDirectory ,  centerX , centerY )
            --display.save( img, filename [, baseDir] )
            --display.save( img , { filename=filename, baseDir=system.TemporaryDirectory } )
            media.save( img , system.TemporaryDirectory )
  
            fitImage( img , _H/3.2 , _H/4.8 , false )
            
            actualN = actualN + 1
            
            getfilename()
            
            print("filename now is:"..filename)

            savePhotoBt = widget.newButton(  -- customized settings 
            {
                label = "Salvar foto",
                --onEvent = savePhoto,
                emboss = false,
                font = native.systemFontBold ,
                fontSize = 20 ,
                -- Properties for a rounded rectangle button
                shape = "rect",
                width = _W/4.2,
                height = _H/12,
                fillColor = { default= { rgb.color( "black" ) } , over = { rgb.color( "gray" ) } },
                labelColor = { default= { rgb.color( "white" ) } , over = { rgb.color( "white" ) } }
                
            }
        )
           savePhotoBt.x = centerX
           savePhotoBt.y = centerY + _H/4.8 + _H/10
           
            
           end , 1 )
 
     end
 end

 ----------------x---------------


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

    local function listenerMenuButton( event )
        print("clicked")
     
        if ( "began" == event.phase ) then
         
         event.target.alpha = 0.5
       
     end
     
         if ( "ended" == event.phase ) then
             --code
         event.target.alpha = 1.0
         -- Delay some to allow the display to refresh before calling the Photo Picker
	     timer.performWithDelay( 100, function() media.selectPhoto( { listener = sessionComplete, mediaSource = PHOTO_FUNCTION , destination = { baseDir = baseDir, filename = filename } } ) 
	        end )
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
    quad = display.newRect( centerX , centerY , _W  , _H*0.9 )
    quad:setFillColor( rgb.color( "white" ) )
    quad.alpha = 0.5
    sceneGroup:insert(quad)
    headerui = display.newRect( centerX , 0  , _W , _H/3.2 )
    headerui:setFillColor( rgb.color( "black" ) )
    sceneGroup:insert( headerui )
    headerTagText = display.newText( "Adicionar foto", centerX , headerui.height/3 , native.systemFontBold, 25 )
    headerTagText:setFillColor( rgb.color( "white" ) )
    sceneGroup:insert(headerTagText)

     camBt = widget.newButton {
        
        defaultFile = "pngs/baseline_camera_alt_black_96dp.png",
        id = "cam",
        onEvent = listenerMenuButton
    }
    camBt.x = centerX
    camBt.y = centerY
    sceneGroup:insert(camBt)

      -- Esquema em cascatinha --
      --[[
    quadPhoto1 = display.newRect( 0 , headerui.height/1.3 , _W/4 , _W/4 )
    quadPhoto1.x = quadPhoto1.width/2
    quadPhoto2 = display.newRect( quadPhoto1.x + quadPhoto1.width + 3 , headerui.height/1.3 , _W/4 , _W/4 )
    quadPhoto3 = display.newRect( quadPhoto2.x + quadPhoto2.width + 3 , headerui.height/1.3 , _W/4 , _W/4 )
    quadPhoto4 = display.newRect( quadPhoto3.x + quadPhoto3.width + 3 , headerui.height/1.3 , _W/4 , _W/4 )

    quadPhoto5 = display.newRect( quadPhoto1.x , quadPhoto4.y+quadPhoto4.height+3 , _W/4 , _W/4 )
    quadPhoto6 = display.newRect( quadPhoto5.x + quadPhoto5.width + 3 , quadPhoto5.y , _W/4 , _W/4 )
    quadPhoto7 = display.newRect( quadPhoto6.x + quadPhoto6.width + 3 , quadPhoto5.y , _W/4 , _W/4 )
    quadPhoto8 = display.newRect( quadPhoto7.x + quadPhoto7.width + 3 , quadPhoto5.y , _W/4 , _W/4 )

    quadPhoto9  =  display.newRect( quadPhoto1.x , quadPhoto8.y+quadPhoto8.height+3 , _W/4 , _W/4 )
    quadPhoto10 = display.newRect( quadPhoto9.x + quadPhoto9.width + 3 , quadPhoto9.y , _W/4 , _W/4 )
    quadPhoto11 = display.newRect( quadPhoto10.x + quadPhoto10.width + 3 , quadPhoto9.y , _W/4 , _W/4 )
    quadPhoto12 = display.newRect( quadPhoto11.x + quadPhoto11.width + 3 , quadPhoto9.y , _W/4 , _W/4 )

    -- Thumbs --
    --display.newImage( "image.jpg" , system.TemporaryDirectory ,  centerX , centerY )
    --display.newImageRect("IMAGE.png", 20, 20 )
    
    quadPhotoThumb1 = display.newImageRect( photoFiles[1] , _W/4 , _W/4 )
    quadPhotoThumb1.x = quadPhoto1.x
    quadPhotoThumb1.y = quadPhoto1.y
    
    quadPhotoThumb2 = display.newImageRect( photoFiles[2] , _W/4 , _W/4 )
    quadPhotoThumb2.x = quadPhoto2.x
    quadPhotoThumb2.y = quadPhoto2.y

    quadPhotoThumb3 = display.newImageRect( photoFiles[3],  _W/4 , _W/4 )
    quadPhotoThumb3.x = quadPhoto3.x
    quadPhotoThumb3.y = quadPhoto3.y 

    quadPhotoThumb4 = display.newImageRect( photoFiles[4], _W/4 , _W/4  )
    quadPhotoThumb4.x = quadPhoto4.x
    quadPhotoThumb4.y = quadPhoto4.y

    quadPhotoThumb5 = display.newImageRect( photoFiles[5] , _W/4 , _W/4  )
    quadPhotoThumb5.x = quadPhoto5.x
    quadPhotoThumb5.y = quadPhoto5.y

    quadPhotoThumb6 = display.newImageRect( photoFiles[6] , _W/4 , _W/4 )
    quadPhotoThumb6.x = quadPhoto6.x
    quadPhotoThumb6.y = quadPhoto6.y

    quadPhotoThumb7 = display.newImageRect( photoFiles[7] , _W/4 , _W/4  )
    quadPhotoThumb7.x = quadPhoto7.x
    quadPhotoThumb7.y = quadPhoto7.y

    quadPhotoThumb8 = display.newImageRect( photoFiles[8] , _W/4 , _W/4 )
    quadPhotoThumb8.x = quadPhoto8.x
    quadPhotoThumb8.y = quadPhoto8.y

    quadPhotoThumb9  = display.newImageRect( photoFiles[9] ,  _W/4 , _W/4 )
    quadPhotoThumb9.x = quadPhoto9.x
    quadPhotoThumb9.y = quadPhoto9.y
    
    quadPhotoThumb10 = display.newImageRect( photoFiles[10] , _W/4 , _W/4 )
    quadPhotoThumb10.x = quadPhoto10.x
    quadPhotoThumb10.y = quadPhoto10.y

    
    quadPhotoThumb11 = display.newImageRect( photoFiles[11] , _W/4 , _W/4 )
    quadPhotoThumb11.x = quadPhoto11.x
    quadPhotoThumb11.y = quadPhoto11.y
    
    quadPhotoThumb12 = display.newImageRect( photoFiles[12] , _W/4 , _W/4 )
    quadPhotoThumb12.x = quadPhoto12.x
    quadPhotoThumb12.y = quadPhoto12.y
  --]]

nextButton = widget.newButton(  -- customized settings 
     {
         label = "Avançar",
         --onEvent = listenerNext,
         emboss = false,
         font = native.systemFontBold ,
         fontSize = 25 ,
         -- Properties for a rounded rectangle button
         shape = "rect",
         width = _W/4.2,
         height = _H/12,
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