
AddCSLuaFile()
include("autorun/gibbing_system_module/models.lua")
GibSystem_LoadModels()

local GibModels = GibModels

local Category = "#GS.Title"

hook.Add( "OnEntityCreated", "GibSystem_NPCRandomModel", function()
	local RndModel = GibModels[math.random( #GibModels )]
	local NPC = { 	Name = "#GS.HeadlessCitizen", 
				Class = "npc_citizen",
				KeyValues = { citizentype = 4 },
				Model = "models/gib_system/"..RndModel.."_headless.mdl",
				Weapons = { "weapon_ar2" , "weapon_smg1", "weapon_shotgun" },
				Category = Category	}

	list.Set( "NPC", "gibsystem_headless_npc", NPC )
end )