
AddCSLuaFile()

GibModels = {}

files, _ = file.Find("autorun/gibbing_system/models/*.lua", "LUA")

for _, filename in ipairs(files) do
	AddCSLuaFile("autorun/gibbing_system/models/" .. filename)
	include("autorun/gibbing_system/models/" .. filename)
	table.insert(GibModels, tostring(filename:gsub("%.lua$", "")))
end
