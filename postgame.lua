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

local CMnext, CMmenu, text1

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

		if self == CMnext then
			
			composer.gotoScene( "rungame", "fade", 800  )
		
			return true
		elseif self == CMmenu then
			composer.gotoScene( "mainmenu", "fade", 800 )
			return true
		end


	end
end


-- Called when the scene's view does not exist:
function scene:create( event )
	local sceneGroup = self.view


	
	CMlogo = display.newText( "GAME OVER!!!", 0, 0, native.systemFontBold, 32 )
	CMlogo.x = display.contentCenterX
	CMlogo.y = display.contentCenterY/2

	CMnext = display.newText( "Next Level", 0, 0, native.systemFontBold, 32 )
	CMnext.x = display.contentCenterX/2
	CMnext.y = display.contentCenterY

	CMmenu = display.newText( "Back to Menu", 0, 0, native.systemFontBold, 32 )
	CMmenu.x = display.contentCenterX + display.contentCenterX/3
	CMmenu.y = display.contentCenterY
	
	sceneGroup:insert( CMlogo )
	sceneGroup:insert( CMnext )
	sceneGroup:insert( CMmenu )
	
	CMnext.touch = onSceneTouch
	CMmenu.touch = onSceneTouch
	
	text1 = display.newText( "menu", 0, 0, native.systemFontBold, 24 )
	text1:setFillColor( 255 )
	text1.x, text1.y = display.contentWidth * 0.5, 50
	sceneGroup:insert( text1 )
	
		
	
	
end

function scene:show( event )
	
	local phase = event.phase
	if "will" == phase then
		composer.removeScene( "rungame" )
	end
	
	if "did" == phase then
				CMnext:addEventListener( "touch", CMnext )
				CMmenu:addEventListener("touch", CMmenu)
				composer.removeScene( "rungame" )

	
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