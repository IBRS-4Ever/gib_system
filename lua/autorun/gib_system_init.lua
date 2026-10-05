
local files = file.Find("autorun/gibbing_system_module/*", "LUA")

if SERVER then
	util.AddNetworkString("GibSystem_StartDeathCam")
	util.AddNetworkString("GibSystem_PlayerSpawn")
	util.AddNetworkString("GibSystem_CleanGibs_Notification")

	for _, filename in ipairs(files) do
		AddCSLuaFile("autorun/gibbing_system_module/" ..filename)
		include("autorun/gibbing_system_module/" ..filename)
	end
else
	for _, filename in ipairs(files) do
		include("autorun/gibbing_system_module/" ..filename)
	end
end
