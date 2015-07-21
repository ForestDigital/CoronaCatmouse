---------------------------------------------------------------------------------
--
-- scene1.lua
--
---------------------------------------------------------------------------------
local jslib = require( "simplejoystick" )
local composer = require( "composer" )
local scene = composer.newScene()

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local CMlogo, CMstart, CMhighscores, text1, menuMouse, menuCat

local js

function createDisplay()

	local backpanel = display.newImageRect("backpanel.png", display.contentWidth+100, 2*(display.contentHeight/3) + 20)
	backpanel.x, backpanel.y = display.contentCenterX, display.contentHeight/2 - 100

	local panel = display.newImageRect( "GamePanel.png",display.contentWidth,(display.contentHeight/3)*0.9 )
	panel.x, panel.y = display.contentWidth/2,((display.contentHeight/3)*2.60)

	local toppanel = display.newImageRect("toppanel.png", display.contentWidth,100)
	toppanel.x, toppanel.y = display.contentCenterX,33

	js = jslib.new( display.contentWidth/20, display.contentWidth/11 )
	js.x = panel.x + panel.x*0.7
	js.y = panel.y + panel.y*0.025

	js:activate()
end

function firstAnimation()
	menuMouse = display.newImage("mousemodel.png")
	menuMouse.x, menuMouse.y = -100, display.contentCenterY
	menuMouse:scale(-.5,.5)
	menuCat = display.newImage("CatModel.png")
	menuCat.x, menuCat.y = -300, display.contentCenterY
	menuCat:scale(-.5,.5)
	transition.to(menuMouse, {x=display.contentWidth+300,y=display.contentCenterY, time=5000})
	transition.to(menuCat,{x=display.contentWidth+100,y=display.contentCenterY, time=5000,
					onComplete=secondAnimation})
end

function secondAnimation( )
	menuMouse.x = display.contentWidth + 100
	menuMouse.y = display.contentCenterY
	menuMouse:scale(-1,1)
	menuCat.x = display.contentWidth + 300
	menuCat.y = display.contentCenterY
	menuCat:scale(-1,1)
	transition.to(menuMouse, {x=-300,y=display.contentCenterY, time=5000})
	transition.to(menuCat,{x=-100,y=display.contentCenterY, time=5000,
								onComplete=thirdAnimaton})
end

function thirdAnimaton( )
	menuMouse.x = -100
	menuMouse.y = display.contentCenterY
	menuMouse:scale(-1,1)

	menuCat.x = -300
	menuCat.y = display.contentCenterY
	menuCat:scale(-1,1)

	transition.to(menuMouse,{x=display.contentCenterX +100, y=display.contentCenterY, time=3000})
	transition.to(menuCat, {x=display.contentCenterX -100,y=display.contentCenterY,time = 3000 })

	timer.performWithDelay(8000, function( )
		 transition.to(menuMouse, {x=display.contentWidth+300,y=display.contentCenterY, time=3000})
		transition.to(menuCat,{x=display.contentWidth+100,y=display.contentCenterY, time=3000,
					onComplete=secondAnimation})
	end, 1)

end

local function onSceneTouch( self, event )
	if event.phase == "began" then

		if self == CMstart then
			transition.cancel(menuMouse)
			transition.cancel(menuCat)
			menuMouse:removeSelf()
			menuCat:removeSelf()

			composer.gotoScene( "selectlevel", "fade", 800  )
		
			return true
		elseif self == CMhighscores then
			composer.gotoScene( "highscoresmenu", "fade", 800 )
			return true
		end


	end
end


-- Called when the scene's view does not exist:
function scene:create( event )
	local sceneGroup = self.view


	
	CMlogo = display.newImageRect( "CMlogo.png", display.contentWidth/2, 60 )
	CMlogo.x = display.contentCenterX
	CMlogo.y = display.contentCenterY/3

	CMstart = display.newImageRect( "start.png", display.contentWidth/4 - 25, 40 )
	CMstart.x = display.contentWidth/2 - display.contentWidth/5
	CMstart.y = display.contentCenterY+100

	CMhighscores = display.newImageRect( "highscores.png", display.contentWidth/3 + 20, 40 )
	CMhighscores.x = display.contentCenterX + display.contentCenterX/4
	CMhighscores.y = display.contentCenterY+100
	
	sceneGroup:insert( CMlogo )
	sceneGroup:insert( CMstart )
	sceneGroup:insert( CMhighscores )
	
	CMstart.touch = onSceneTouch
	CMhighscores.touch = onSceneTouch
	
		
		firstAnimation()
		createDisplay()
	
	
end

function scene:show( event )
	
	local phase = event.phase
	if "will" == phase then
		composer.removeScene( "rungame" )
		composer.removeScene( "highscoresmenu" )
		composer.removeScene( "postgame" )
	end
	
	if "did" == phase then
				CMstart:addEventListener( "touch", CMstart )
				CMhighscores:addEventListener("touch", CMhighscores)
				composer.removeScene( "rungame" )
				composer.removeScene( "highscoresmenu" )
				composer.removeScene( "postgame" )

	
	end
	
end

function scene:hide( event )
	
	local phase = event.phase
	
	if "will" == phase then
	
	
	
	end
	
end

function scene:destroy( event )
	CMlogo:removeSelf()
	CMstart:removeSelf()
	CMhighscores:removeSelf()
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene