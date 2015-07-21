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

local CMlogo, CMstart, CMhighscores, text1

local js

function createDisplay()
	local panel = display.newImageRect( "GamePanel.png",display.contentWidth,(display.contentHeight/3)*0.9 )
	panel.x, panel.y = display.contentWidth/2,((display.contentHeight/3)*2.60)

	local toppanel = display.newImageRect("toppanel.png", display.contentWidth,100)
	toppanel.x, toppanel.y = display.contentCenterX,33

	js = jslib.new( display.contentWidth/20, display.contentWidth/11 )
	js.x = panel.x + panel.x*0.7
	js.y = panel.y + panel.y*0.025

	js:activate()
end

createDisplay()

local function onSceneTouch( self, event )
	if event.phase == "began" then

		if self == CMstart then
		
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


	
	CMlogo = display.newImage( "CMlogo.png" )
	CMlogo.x = display.contentCenterX
	CMlogo.y = display.contentCenterY/2

	CMstart = display.newImage( "start.png" )
	CMstart.x = display.contentCenterX/2
	CMstart.y = display.contentCenterY

	CMhighscores = display.newImage( "highscores.png" )
	CMhighscores.x = display.contentCenterX + display.contentCenterX/3
	CMhighscores.y = display.contentCenterY
	
	sceneGroup:insert( CMlogo )
	sceneGroup:insert( CMstart )
	sceneGroup:insert( CMhighscores )
	
	CMstart.touch = onSceneTouch
	CMhighscores.touch = onSceneTouch
	
	text1 = display.newText( "menu", 0, 0, native.systemFontBold, 24 )
	text1:setFillColor( 255 )
	text1.x, text1.y = display.contentWidth * 0.5, 50
	sceneGroup:insert( text1 )
	
		
	
	
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