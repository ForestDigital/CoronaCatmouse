local jslib = require( "simplejoystick" )
local widget = require( "widget" )
local gameData = require( "gamedata" )
local gameFunctions = require ( "gamefunctions" )
local level = require ( "levels" )
local composer = require( "composer" )
local scene = composer.newScene()

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

--createDisplay()


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

local updateMap = function( event )
	local actuX,actuy = gameData.player:localToContent( 0, 0 )
	
	local transX = display.contentWidth/2 - actuX
	local transY = display.contentHeight/3 - actuy

	gameData.map.x = gameData.map.x + transX
	gameData.map.y = gameData.map.y + transY
end

function removeGame( )
	timer.cancel( updMap ); updMap = nil;
		timer.cancel( updMouse ); updMouse = nil;
		-- timer.cancel( updFrame ); updFrame = nil;
		timer.cancel( updCatAI ); updCatAI = nil;

		for i=1, gameData.walls.num do
			gameData.walls[i]:removeSelf(); gameData.walls[i] = nil;			
		end

		for i=1, gameData.cats.num do
			gameData.cats[i]:removeSelf(); --gameData.cats[i] = nil;			
		end

		for i=1, gameData.holes.num do
			gameData.holes[i]:removeSelf(); gameData.holes[i] = nil;			
		end

		gameData.walls = nil;
		gameData.floors = nil;
		gameData.holes = nil;

		gameData.player.facedLeft = false
		gameData.player:removeSelf(); gameData.player = nil;

		--gameData.cats = nil;
		--gameData.level = 2

		gameData.cheese:removeSelf(); gameData.cheese = nil;

		display.remove(gameData.map); gameData.map = nil;
end


---------------------------------------------------------------------------------

function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.


end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
		composer.removeScene("mainmenu")
		composer.removeScene("postgame")
		composer.removeScene("selectlevel")
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		--init()
		composer.removeScene("mainmenu")
		composer.removeScene("postgame")
		composer.removeScene("selectlevel")
		createMap(level[gameData.level])

		for i=1,gameData.cats.num do
		gameData.cats[i].collision = onLocalCollision
		gameData.cats[i]:addEventListener( "collision" )
		end
		gameData.player.collision = onLocalCollision
		gameData.player:addEventListener( "collision" )

		updMap = timer.performWithDelay( 20, updateMap, -1 )
		updMouse = timer.performWithDelay( 10, controlmouse , -1 )
		updCatAI = timer.performWithDelay( 10, catAI, -1)

		createDisplay()
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)




	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end


function scene:destroy( event )
	local sceneGroup = self.view
	
	
	removeGame()
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
















