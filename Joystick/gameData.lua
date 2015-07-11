
local gameData = { }


	gameData.walls = {}
	gameData.floors = {}

	gameData.holes = {}
	gameData.holes.num = 0

	gameData.player = display.newImage( "mouseModel.png")
	gameData.player.facedLeft = false

	gameData.cats = {} 

	gameData.cats.num = 0

	gameData.cheese = display.newImage("cheeseModel.png")

	gameData.map = display.newGroup( )


return gameData