
local files = file.Find("autorun/gibbing_system_module/*", "LUA")

if SERVER then
	for _, filename in ipairs(files) do
		AddCSLuaFile("autorun/gibbing_system_module/" ..filename)
		include("autorun/gibbing_system_module/" ..filename)
	end
else
	for _, filename in ipairs(files) do
		include("autorun/gibbing_system_module/" ..filename)
	end
end
