
DefaultNPCs = { 
	["npc_alyx"] = true,
	["npc_barney"] = true,
	["npc_breen"] = true,
	["npc_citizen"] = true,
	["npc_combine_s"] = true,
	["npc_eli"] = true,
	["npc_fisherman"] = true,
	["npc_gman"] = true,
	["npc_kleiner"] = true,
	["npc_magnusson"] = true,
	["npc_metropolice"] = true,
	["npc_monk"] = true,
	["npc_mossman"] = true,
	["npc_poisonzombie"] = true,
	["npc_zombie"] = true,
	["npc_zombine"] = true,
	["npc_fastzombie"] = true,
	["npc_human_scientist"] = true,
	["npc_human_security"] = true,
	["npc_human_commander"] = true,
	["npc_human_grenadier"] = true,
	["npc_human_grunt"] = true,
	["npc_human_medic"] = true,
	["npc_zombie_grunt"] = true,
	["npc_zombie_hev"] = true,
	["npc_zombie_scientist"] = true,
	["npc_zombie_security"] = true,
}

function GibSystem_GetDefaultNPCs()
	return DefaultNPCs
end

function GibSystem_AddDefaultNPCs(class)
	if DefaultNPCs[class] then
		DefaultNPCs[class] = nil
	else
		DefaultNPCs[class] = true
	end
end
