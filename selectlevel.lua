---------------------------------------------------------------------------------
--
-- scene1.lua
--
---------------------------------------------------------------------------------
local jslib = require( "simplejoystick" )
local composer = require( "composer" )
local gameData = require( "gamedata" )
local scene = composer.newScene()
local playerData = require( "playerdata" )

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
local Imglvl = { }
local ImgLocked = { }

local js

function createDisplay()
	local panel = display.newImageRect( "GamePanel.png",display.contentWidth,(display.contentHeight/3)*0.9 )
	panel.x, panel.y = display.contentWidth/2,((display.contentHeight/3)*2.60)

	js = jslib.new( display.contentWidth/20, display.contentWidth/11 )
	js.x = panel.x + panel.x*0.7
	js.y = panel.y + panel.y*0.025

	js:activate()
end

createDisplay()

local function onSceneTouch( self, event )
	if event.phase == "began" then
		for i=1, 10 do
			if self == Imglvl[i] then
				gameData.level = i
				composer.gotoScene( "rungame", "fade", 800 )
				return true	
			end
		end
	end
end

local function lockLevel( )
	return true-- body
end


-- Called when the scene's view does not exist:
function scene:create( event )
	local sceneGroup = self.view
	local xVals = {1, 2, 3, 4, 5, 1, 2, 3, 4, 5}
	local yVals = {4, 4, 4, 4, 4, 2, 2, 2, 2, 2}

	for i=1, 10 do
		Imglvl[i] = display.newImage( "level"..i..".png" )
		Imglvl[i].x = (display.contentWidth/6) * xVals[i]
		Imglvl[i].y = display.contentCenterY/yVals[i]
		sceneGroup:insert( Imglvl[i] )
		Imglvl[i].touch = onSceneTouch

		if playerData.highestLevel < i then
			ImgLocked[i] = display.newImage("levelover.png")
			ImgLocked[i].x = (display.contentWidth/6) * xVals[i]
			ImgLocked[i].y = display.contentCenterY/yVals[i]
			sceneGroup:insert( ImgLocked[i] )
			ImgLocked[i].touch = lockLevel
		end

	end
	
end

function scene:show( event )
	
	local phase = event.phase
	if "will" == phase then
		composer.removeScene( "mainmenu" )
		composer.removeScene( "postgame" )
	end
	
	if "did" == phase then
				for i=1, 10 do
					Imglvl[i]:addEventListener( "touch", Imglvl[i])
				end
				for i=playerData.highestLevel + 1, 10 do
					ImgLocked[i]:addEventListener( "touch", ImgLocked[i])
				end
				composer.removeScene( "mainmenu" )
				composer.removeScene( "postgame" )

	
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