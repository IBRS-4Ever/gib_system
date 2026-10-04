
AddCSLuaFile()

local Category = "#GS.Title"
local GibModels = GibSystem_LoadModels()
local ModelTable = {}
for k, v in ipairs(GibModels) do
	ModelTable[k] = "models/gib_system/"..v.."_headless.mdl"
end

local NPC = { 	Name = "#GS.HeadlessCitizen", 
			Class = "npc_citizen",
			KeyValues = { citizentype = 4 },
			Model = ModelTable,
			Weapons = { "weapon_ar2" , "weapon_smg1", "weapon_shotgun" },
			Category = Category	}

list.Set( "NPC", "gibsystem_headless_npc", NPC )

local NPC = { 	Name = "#GS.HeadlessCitizen_Hostile", 
			Class = "npc_citizen",
			KeyValues = { citizentype = 4, Hostile = 1 },
			Model = ModelTable,
			Weapons = { "weapon_ar2" , "weapon_smg1", "weapon_shotgun" },
			Category = Category	}

list.Set( "NPC", "gibsystem_headless_npc_hostile", NPC )
