
AddCSLuaFile()

include("autorun/gibbing_system/defaultnpcs.lua")
include("autorun/gibbing_system/convars.lua")

hook.Add( "CreateClientsideRagdoll", "fade_out_corpses", function( entity, ragdoll )
	if GetConVar( "gibsystem_enabled" ):GetBool() and GetConVar( "gibsystem_gibbing_npc" ):GetBool() and !(entity:IsPlayer()) and DefaultNPCs[entity:GetClass()] then
		timer.Simple( 0.01, function()
			if !IsValid(entity) then return end
			if GetConVar( "developer" ):GetInt() > 0 then
				print("Found Clientside Ragdoll: "..tostring(entity))
			end
			ragdoll:SetSaveValue( "m_bFadingOut", true ) -- Set the magic internal variable that will cause the ragdoll to immediately start fading out
		end)
	end
end)
