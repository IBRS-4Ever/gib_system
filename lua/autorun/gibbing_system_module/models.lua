
AddCSLuaFile()

GibModels = {}

function GibSystem_LoadModels()
	files, _ = file.Find("autorun/gibbing_system/*.lua", "LUA")
	table.Empty(GibModels)
	for _, filename in ipairs(files) do
		AddCSLuaFile("autorun/gibbing_system/" .. filename)
		include("autorun/gibbing_system/" .. filename)
		table.insert(GibModels, tostring(filename:gsub("%.lua$", "")))
	end
end

function CheckFedhoria()
	return file.Exists( "fedhoria/modules.lua", "LUA" )
end
