
local gameData = { }
	
	--local gameData.player, gameData.holes, gameData.walls, gameData.cats, gameData.cheese, gameData.map = {}
	

	function init( )
		gameData.walls = {}
		gameData.walls.num = 0
		-- gameData.floors = {}

		gameData.holes = {}
		gameData.holes.num = 0

		gameData.player = {}
		gameData.player = display.newImage( "mousemodel.png")
		gameData.player.facedLeft = false

		gameData.cats = {} 

		gameData.cats.num = 0

		gameData.cheese = {}
		gameData.cheese = display.newImage("cheesemodel.png")

		gameData.map = display.newGroup( )

		
	end
	gameData.level = 1
return gameData