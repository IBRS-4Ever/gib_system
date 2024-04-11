
local DefaultNPCs = { 
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
	["npc_fastzombie"] = true
}

hook.Add( "CreateClientsideRagdoll", "fade_out_corpses", function( entity, ragdoll )
	if GetConVar( "gibsystem_enabled" ):GetBool() and GetConVar( "gibsystem_gibbing_npc" ):GetBool()  and !entity:IsPlayer() and IsValid(entity) and DefaultNPCs[entity:GetClass()] then
		
		timer.Simple( 0.01, function()
			if GetConVar( "developer" ):GetInt() > 0 then
				print("Found Clientside Ragdoll: "..tostring(entity))
			end
			-- PrintTable(ragdoll:GetSaveTable())
			ragdoll:SetSaveValue( "m_bFadingOut", true ) -- Set the magic internal variable that will cause the ragdoll to immediately start fading out
		end)
	end
end)
