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

local CMlogo, text1, text2, text3, memTimer

local js

function createDisplay()
	local panel = display.newImageRect( "GamePanel.png",display.contentWidth,display.contentHeight/3 )
	panel.x, panel.y = display.contentWidth/2,((display.contentHeight/3)*2.80)

	js = jslib.new( display.contentWidth/16, display.contentWidth/8 )
	js.x = panel.x
	js.y = panel.y

	js:activate()
end

createDisplay()

local function onSceneTouch( self, event )
	if event.phase == "began" then
		
		composer.gotoScene( "mainmenu", "fade", 800  )
		
		return true
	end
end


-- Called when the scene's view does not exist:
function scene:create( event )
	local sceneGroup = self.view	
	
	text1 = display.newText( "YOUR HIGHSCORES ARE BLEE BLAR BLAR!!!!!", 0, 0, native.systemFontBold, 46 )
	text1:setFillColor( 255 )
	text1.x, text1.y = display.contentWidth * 0.5, 50
	text1.touch = onSceneTouch
	sceneGroup:insert( text1 )	
	
end

function scene:show( event )
	
	local phase = event.phase
	if "will" == phase then
		composer.removeScene( "mainmenu" )
	end
	
	if "did" == phase then
				text1:addEventListener( "touch", text1 )
				composer.removeScene( "mainmenu" )

	
	end
	
end

function scene:hide( event )
	
	local phase = event.phase
	
	if "will" == phase then
	
	
	
	end
	
end

function scene:destroy( event )
	
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene