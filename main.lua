local jslib = require( "simplejoystick" )
local playerData = require( "playerdata" )

local composer = require "composer"

playerData.loadData()
composer.gotoScene( "mainmenu", "fade", 400 )


