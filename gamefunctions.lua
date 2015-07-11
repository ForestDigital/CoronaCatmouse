local jslib = require( "simplejoystick" )
local widget = require( "widget" )
local gameData = require( "gamedata" )
local composer = require "composer"


function createMap( currentMap )

	init()
	

	local physics = require( "physics" )
	physics.start()
	physics.setDrawMode( "normal" )
	physics.setScale( 50 )

	
	
	local increment = 240
	local total = currentMap[1]
	local width = currentMap[3]
	local row = 1
	local column = 1

	for i=4, total+4 do

		if currentMap[i] == 1 then --wall
			gameData.walls.num = gameData.walls.num + 1
			gameData.walls[gameData.walls.num] = display.newRect((column * increment), (row * increment), increment, increment)
			gameData.walls[gameData.walls.num]:setFillColor( 0, 255.0, 0 )
			physics.addBody( gameData.walls[gameData.walls.num], "static", { density=0.8, friction = 0.0} )
			gameData.walls[gameData.walls.num].gravityScale = 0
			gameData.walls[gameData.walls.num].isFixedRotation = true
			gameData.walls[gameData.walls.num].isWall = true
			gameData.map:insert( gameData.walls[gameData.walls.num] , true)
		elseif currentMap[i] == 3 then --hole
			gameData.holes.num = gameData.holes.num + 1
			gameData.holes[gameData.holes.num] = display.newCircle((column * increment), (row * increment), increment / 2)
			gameData.holes[gameData.holes.num]:setFillColor( 0, 0, 255 )
			physics.addBody(gameData.holes[gameData.holes.num], "static")
			gameData.map:insert(gameData.holes[gameData.holes.num] , true)
			gameData.holes[gameData.holes.num].isHole = true
			if currentMap[2] == 1 then
				gameData.holes[gameData.holes.num].exitX, gameData.holes[gameData.holes.num].exitY = ((column + 1) * increment), (row * increment)
			elseif currentMap[2] == 3 then
				gameData.holes[gameData.holes.num].exitX, gameData.holes[gameData.holes.num].exitY = ((column - 1) * increment), (row * increment)
			end
			print("hole " .. i .. "exit = " .. gameData.holes[gameData.holes.num].exitX .. "," .. gameData.holes[gameData.holes.num].exitY)

		elseif currentMap[i] == 4 then --player
			gameData.player.x, gameData.player.y = (column * increment), (row * increment)
			--gameData.player:setFillColor( 222.0/255.0, 184.0/255.0, 135.0/255.0 )
			physics.addBody( gameData.player, "dynamic", { density=0.8, friction = 0.0 } )
			gameData.player.gravityScale = 0
			gameData.player.isFixedRotation = true
		elseif currentMap[i] == 5 then --cats
			gameData.cats.num = gameData.cats.num+1
			gameData.cats[gameData.cats.num] = display.newImage("CatModel.png")
			gameData.cats[gameData.cats.num].x, gameData.cats[gameData.cats.num].y = (column * increment), (row * increment)
			physics.addBody( gameData.cats[gameData.cats.num], "dynamic", { density=0.8, friction = 0.0 } )
			gameData.cats[gameData.cats.num].gravityScale = 0
			gameData.cats[gameData.cats.num].isFixedRotation = true
			gameData.cats[gameData.cats.num].CurrentFace = true
			gameData.cats[gameData.cats.num].facedLeft = false
			gameData.cats[gameData.cats.num].direction = math.random(1,4) --The actual Cardinal Direction that the gameData.cats will be moving
			gameData.cats[gameData.cats.num].directionChoice = 1 --This is the timer that randomizes the cat's path
			gameData.cats[gameData.cats.num].distance = 1000
			gameData.cats[gameData.cats.num].isCat = true
		elseif currentMap[i] == 6 then --gameData.cheese
			gameData.cheese.x, gameData.cheese.y = (column * increment), (row * increment)
			physics.addBody( gameData.cheese, "dynamic", { density=0.8, friction = 0.7 } )
			gameData.cheese.gravityScale = 0
			gameData.cheese.isFixedRotation = true		
			gameData.cheese.isCheese = true
		else
			-- gameData.floors[i] = display.newRect((column * increment), (row * increment), increment, increment)
			-- gameData.floors[i]:setFillColor( 0,0,0 )
			-- gameData.map:insert(gameData.floors[i], true)
		end

		if (column % width == 0) then
			column = 1
			row = row+1
		else
			column = column +1
		end

	end


	--gameData.player:scale( 0.25, 0.25 )
	gameData.map:insert(gameData.player, true)
	for i=1, gameData.cats.num do
		gameData.map:insert(gameData.cats[i], true)
	end

	gameData.map:insert(gameData.cheese, true)

	gameData.map:scale( display.contentScaleX/3, display.contentScaleY/3)
	mouseCurrentFace = not gameData.player.facedLeft
	--originX,originy = display.contentWidth/2,display.contentHeight/3  --(540, 710)
end

function tunnelFinishedd( event )
	--timer.performWithDelay(1000, tunnelFinishedd)
	gameData.player.isBodyActive = true
	gameData.player.isVisible = true     --model?
	--gameData.player.facedLeft = false
end

function tunnelFinished( event )
	timer.performWithDelay(500, tunnelFinishedd)

end

function tunnel( event )
	gameData.player.isBodyActive = false
	gameData.player.isVisible = false
	randHole = math.random(1,gameData.holes.num)
    transition.to( gameData.player, {x= gameData.holes[randHole].exitX, y= gameData.holes[randHole].exitY, time = 2000, onComplete=tunnelFinished} )
end

function kill()
	physics.stop()
	gameData.player.isVisible = false
end


function onLocalCollision( self, event )
	-- if ( event.phase == "began" ) then
	-- 	tunnelegion = true
	-- elseif ( event.phase == "ended" ) then
	-- 	tunnelegion = false
	-- end	
	if(self == gameData.player) then
		if event.other.isHole then
			timer.performWithDelay( 100, tunnel )
		elseif event.other.isCheese then
			kill()
			composer.gotoScene( "postgame", "fade", 400 )
		
		elseif event.other.isCat then
			kill()
			composer.gotoScene("postgame", "fade", 400)
		end 

	elseif (self.isCat) then
		--if event.other.isWall then
		for i=1, gameData.cats.num do
			gameData.cats[i].direction = math.random(1,4)			
		end
	end
end



function distance(x1,x2)
	return math.floor(math.sqrt(((x2.x - x1.x)^2)+((x2.y - x1.y)^2)))
end	

function catAI( e )
	--catUpdateDistance()
	for i=1, gameData.cats.num do
		local dist = distance(gameData.cats[i],gameData.player)
		if (dist < 600) then
			catChase( gameData.cats[i] )
		else
			catWander( gameData.cats[i])

		--Cat Chase
		end
		--t.text = dist
	end
end



function catWander( currentCat )

	local catMovement = 5

	
	
		if  currentCat.directionChoice == 100 then
			currentCat.direction = math.random(1,4)
			currentCat.directionChoice = 0
		end
		currentCat.directionChoice = currentCat.directionChoice + 1

		currentCat.dx, currentCat.dy = 0,0

		if currentCat.direction == 3 then
			currentCat.x =currentCat.x - catMovement
			currentCat.facedLeft = true
		elseif currentCat.direction == 4 then
			currentCat.y = currentCat.y + catMovement
		elseif currentCat.direction == 1 then
			currentCat.x = currentCat.x + catMovement
			currentCat.facedLeft = false
		elseif currentCat.direction == 2 then
			currentCat.y = currentCat.y - catMovement
		end

		if not ( currentCat.CurrentFace == currentCat.facedLeft ) then
			currentCat:scale( -1, 1)
			currentCat.CurrentFace = currentCat.facedLeft
		end

	

	--catUpdateDistance()
end

function catChase( currentCat )

	

	

		local dy = 10
		local dx = 10

		if(gameData.player.x < currentCat.x)then
			dx = -10
		end
		if(gameData.player.y < currentCat.y)then
			dy = -10
		end

		currentCat.x = (currentCat.x + dx)

		currentCat.y = (currentCat.y + dy)

	

	--catUpdateDistance()
end


