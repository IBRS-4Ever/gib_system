
AddCSLuaFile()

function GibSystem_LoadModels()
	local files, _ = file.Find("autorun/gibbing_system/*.lua", "LUA")
	local GibModels = {}
	for _, filename in ipairs(files) do
		if string.find( filename, "disabled_" ) then print( "[碎尸系统] 已跳过未使用的模型 "..tostring(filename:gsub("%.lua$", ""):gsub("disabled_", "")) ) continue end
		AddCSLuaFile("autorun/gibbing_system/" .. filename)
		include("autorun/gibbing_system/" .. filename)
		table.insert(GibModels, tostring(filename:gsub("%.lua$", "")))
	end
	return GibModels
end

function CheckFedhoria()
	return file.Exists( "fedhoria/modules.lua", "LUA" )
end
