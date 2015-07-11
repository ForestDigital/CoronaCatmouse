local jslib = require( "simpleJoystick" )
local widget = require( "widget" )
local gameData = require( "gameData" )
local gameFunctions = require ( "gameFunctions" )



local js

function createDisplay()
	local panel = display.newImageRect( "GamePanel.png",display.contentWidth,display.contentHeight/3 )
	panel.x, panel.y = display.contentWidth/2,((display.contentHeight/3)*2.80)

	js = jslib.new( display.contentWidth/16, display.contentWidth/8 )
	js.x = panel.x
	js.y = panel.y
end

createDisplay()

createMap()


function controlmouse( e )
	local movement = 10
	movement = movement + (1*js.getDistance())	

	if js:getDirection() == 3 then
		gameData.player.x =gameData.player.x - movement
		gameData.player.facedLeft = true
		elseif js:getDirection() == 4 then
			gameData.player.y = gameData.player.y + movement
			elseif js:getDirection() == 1 then
				gameData.player.x = gameData.player.x + movement
				gameData.player.facedLeft = false
				elseif js:getDirection() == 2 then
					gameData.player.y = gameData.player.y - movement
	end		
	if not ( mouseCurrentFace == gameData.player.facedLeft ) then
		gameData.player:scale( -1, 1)
		mouseCurrentFace = gameData.player.facedLeft
	end

	return true --model
end


for i=1,gameData.cats.num do
gameData.cats[i].collision = onLocalCollision
gameData.cats[i]:addEventListener( "collision" )
end
gameData.player.collision = onLocalCollision
gameData.player:addEventListener( "collision" )


local updateMap = function( event )
	local actuX,actuy = gameData.player:localToContent( 0, 0 )
	
	local transX = display.contentWidth/2 - actuX
	local transY = display.contentHeight/3 - actuy

	gameData.map.x = gameData.map.x + transX
	gameData.map.y = gameData.map.y + transY
end


js:activate()
timer.performWithDelay( 20, updateMap, -1 )
timer.performWithDelay( 10, controlmouse , -1 )
timer.performWithDelay( 10, enterFrame, -1 )
timer.performWithDelay( 10, catAI, -1)