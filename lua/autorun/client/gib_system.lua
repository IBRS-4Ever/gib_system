
local BlackListedNPC = { 
	"npc_headcrab",
	"npc_headcrab_black",
	"npc_headcrab_fast",
	"npc_headcrab_poison",
	"npc_manhack",
	"npc_rollermine",
	"npc_sniper",
	"npc_clawscanner",
	"npc_cscanner",
	"npc_turret_floor",
	"npc_antlion",
	"npc_antlion_grub",
	"npc_antlion_worker",
	"npc_antlionguard",
	"npc_pigeon",
	"npc_seagull",
	"npc_crow",
	"npc_barnacle",
	"npc_strider",
	"npc_hunter",
	"npc_zombie_torso"
}

hook.Add( "CreateClientsideRagdoll", "fade_out_corpses", function( entity, ragdoll )
	if GetConVar( "gibsystem_enabled" ):GetInt() > 0 and GetConVar( "gibsystem_gibbing_npc" ):GetInt() > 0 and !entity:IsPlayer() and IsValid(entity) then
		if entity:GetClass() == "prop_dynamic" then return end

		if GetConVar( "gibsystem_gib_allnpcs" ):GetInt() == 0 and table.HasValue( BlackListedNPC, entity:GetClass() ) then return end
		
		timer.Simple( 0.01, function()
			if GetConVar( "developer" ):GetInt() > 0 then
				print("Found Clientside Ragdoll: "..tostring(entity))
			end
			-- PrintTable(ragdoll:GetSaveTable())
			ragdoll:SetSaveValue( "m_bFadingOut", true ) -- Set the magic internal variable that will cause the ragdoll to immediately start fading out
		end)
	end
end)
