
include("autorun/gibbing_system/models.lua")

local Category = "#GS.Title"
local RndModel = GibModels[math.random(1, #GibModels)]

hook.Add( "OnEntityCreated", "RandomModel", function()
	RndModel = GibModels[math.random(1, #GibModels)]
	local NPC = { 	Name = "Headless Citizens", 
				Class = "npc_citizen",
				KeyValues = { citizentype = 4 },
				Model = "models/gib_system/"..RndModel.."_headless.mdl",
				Weapons = { "weapon_ar2" , "weapon_smg1", "weapon_shotgun" },
				Category = Category	}

	list.Set( "NPC", "gs_headless_npc", NPC )
end )


