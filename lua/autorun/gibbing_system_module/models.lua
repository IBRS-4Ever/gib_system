
AddCSLuaFile()

CharacterList = CharacterList or {}

function GibSystem_LoadModels()
	local files, dir = file.Find("autorun/gibbing_system/*", "LUA")
	CharacterList = {}
	for _, folder in ipairs(dir or {}) do
		for _, CharacterList in ipairs(file.Find("autorun/gibbing_system/list/*", "LUA") or {}) do
			include("autorun/gibbing_system/list/" .. CharacterList)
			AddCSLuaFile("autorun/gibbing_system/list/" .. CharacterList)
			print( "[碎尸系统] 已加载模型列表 "..tostring(CharacterList:gsub("%.lua$", "")) )
		end
	end
	for _, filename in ipairs(files) do
		if string.find( filename, "disabled_" ) then print( "[碎尸系统] 已跳过未使用的模型 "..tostring(filename:gsub("%.lua$", ""):gsub("disabled_", "")) ) continue end
		AddCSLuaFile("autorun/gibbing_system/" .. filename)
		include("autorun/gibbing_system/" .. filename)
		table.insert(CharacterList, tostring(filename:gsub("%.lua$", "")))
	end
	return CharacterList
end

function CheckFedhoria()
	return file.Exists( "fedhoria/modules.lua", "LUA" )
end
