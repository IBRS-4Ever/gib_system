
AddCSLuaFile()

include("autorun/gibbing_system/defaultnpcs.lua")
include("autorun/gibbing_system/convars.lua")

hook.Add( "CreateClientsideRagdoll", "fade_out_corpses", function( entity, ragdoll )
	if GetConVar( "gibsystem_enabled" ):GetBool() and GetConVar( "gibsystem_gibbing_npc" ):GetBool() and !(entity:IsPlayer()) and DefaultNPCs[entity:GetClass()] then
		timer.Simple( 0.01, function()
			if !IsValid(ragdoll) then return end
			ragdoll:SetSaveValue( "m_bFadingOut", true ) -- 设置内部变量来让布娃娃立即消失
		end)
	end
end)
