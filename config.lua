 --[[

 Resolutions:
 
 Obs: Ao baixar resolução não perde qualidade
  logo adaptar a escala as resoluções

 640x960 - initial scale
 320x480 
 1080x1920 -s5
 1125x2436

 zoomStretch
 adaptive

Code1:

application =
{
    content =
    {
        width = 640,
        height =  960,
        scale = "zoomStretch",
        fps = 60,
    },
}


Code2: -- The best

local aspectRatio = display.pixelHeight/display.pixelWidth

 application = 
 
 {
 
     content = 
 
     { 
 
         width = 640 * (aspectRatio>1.5 and 1 or 1.5/aspectRatio),
 
         height = 960 * (aspectRatio<1.5 and 1 or aspectRatio/1.5),
 
         scale = "letterbox",
 
         imageSuffix =
 
         {
 
             ["@2x"] = 1.5,
 
             ["@4x"] = 3.0
 
         },
 
     },
 
 }

  Code3:

  application =
{
    content =
    {
        scale = "adaptive",
    }
}

  Code4:

  application =
{
    content =
    {
        scale = "adaptive",
        imageSuffix =
        {
            ["@2x"] = 2.0,
            ["@3x"] = 3.0,
        },
    }
}

Code5: -- The best

local aspectRatio = display.pixelHeight / display.pixelWidth
application = {
   content = {
      width = aspectRatio > 1.5 and 640 or math.ceil( 960 / aspectRatio ),
      height = aspectRatio < 1.5 and 960 or math.ceil( 640 * aspectRatio ),
      scale = "letterBox",
      fps = 30,

      imageSuffix = {
         ["@2x"] = 1.3,
      },
   },
}

Code6:

application = 
{
    content = 
    { 
        width = 640,
        height = 960,
        scale = "letterbox",
        xAlign = "center",
        yAlign = "center",
        imageSuffix =
        {
            ["@2"] = 1.8,
            ["@4"] = 3.6,
        },
    },
}


 ]]

 -- begin

 local aspectRatio = display.pixelHeight / display.pixelWidth
 application = {
    content = {
       width = aspectRatio > 1.5 and 640 or math.ceil( 960 / aspectRatio ),
       height = aspectRatio < 1.5 and 960 or math.ceil( 640 * aspectRatio ),
       scale = "letterBox",
       fps = 30,
 
       imageSuffix = {
          ["@2x"] = 1.3,
       },
    },
 }


 

 