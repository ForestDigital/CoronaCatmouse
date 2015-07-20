local playerData = {}
	local filePath = system.pathForFile( "catmouse.sav", system.DocumentsDirectory )

	function playerData.init( )
		playerData.highestLevel = 1
		--playerData.leveltime = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
			--does not work with setter
		playerData.lvl1time = 0
		playerData.lvl2time = 0
		playerData.lvl3time = 0
		playerData.lvl4time = 0
		playerData.lvl5time = 0
		playerData.lvl6time = 0
		playerData.lvl7time = 0
		playerData.lvl8time = 0
		playerData.lvl9time = 0
		playerData.lvl10time = 0
	end


	function playerData.saveData()
		
		--local levelseq = table.concat( levelArray, "-" )

		file = io.open( filePath, "w" )
		
		for k,v in pairs( dataTable ) do
			file:write( k .. "=" .. v .. "," )
		end
		
		io.close( file )
	end

	function playerData.loadData()	
		local file = io.open( filePath, "r" )
		
		if file then

			-- Read file contents into a string
			local dataStr = file:read( "*a" )
			
			-- Break string into separate variables and construct new table from resulting data
			local datavars = str.split(dataStr, ",")
			
			dataTableNew = {}
			
			for i = 1, #datavars do
				-- split each name/value pair
				local onevalue = str.split(datavars[i], "=")
				dataTableNew[onevalue[1]] = onevalue[2]
			end
		
			io.close( file ) -- important!

			-- Note: all values arrive as strings; cast to numbers where numbers are expected
			dataTableNew["numValue"] = tonumber(dataTableNew["numValue"])
			dataTableNew["randomValue"] = tonumber(dataTableNew["randomValue"])	
		
		else
			playerData.init()
		end
	end

return playerData