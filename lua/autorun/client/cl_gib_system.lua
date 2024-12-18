
AddCSLuaFile()

include("autorun/gibbing_system_module/defaultnpcs.lua")
include("autorun/gibbing_system_module/convars.lua")

local CVAR_GibSystem_cam_enable		= CreateClientConVar("GibSystem_cam", "0", 0, 1)				--（0/1）是否启用第一人称死亡视角
local CVAR_GibSystem_cam_hair		= CreateClientConVar("GibSystem_hair", "0", 0, 1)			--（0/1）是否在第一人称死亡时隐藏头部
local CVAR_GibSystem_cam_z_axis		= CreateClientConVar("GibSystem_camz", "75", 0, 200)			--（NUM）第三人称死亡视角的高度

local Gib = nil
local set0 = 0 	--这俩存在的意义是为了让ScaleBone只需运行一次，而不是每时每刻都运行
local set1 = 0 	--这俩存在的意义是为了让ScaleBone只需运行一次，而不是每时每刻都运行

hook.Add( "CreateClientsideRagdoll", "GibSystem_FadeOutCorpses", function( entity, ragdoll )
	if GetConVar( "gibsystem_enabled" ):GetBool() and GetConVar( "gibsystem_gibbing_npc" ):GetBool() and !(entity:IsPlayer()) and DefaultNPCs[entity:GetClass()] then
		timer.Simple( 0.01, function()
			if !IsValid(ragdoll) then return end
			ragdoll:SetSaveValue( "m_bFadingOut", true ) 		// 设置内部变量来让布娃娃立即消失
		end)
	end
end)

net.Receive("GibSystem_StartDeathCam", function()
	local head = net.ReadInt(32)
	local body = net.ReadInt(32)
	set0 = 0
	set1 = 0

	timer.Simple(0, function()
		if GetConVar("gibsystem_deathcam_mode"):GetBool() then
			Gib = Entity(body)
		else
			Gib = Entity(head)
		end
		if not Gib or not IsValid(Gib) then return end
		if Gib:LookupAttachment('eyes') > 0 then
			Gib.att 		= Gib:GetAttachment(Gib:LookupAttachment('eyes'))
			Gib.ang_smooth_last 	= Gib.att.Ang
		end
	end)
end)

net.Receive("GibSystem_PlayerSpawn", function()
	if net.ReadBool() then
		Gib = nil
	end
end)

hook.Add("CalcView", "GibSystem_FirstDeathCam", function(ply, pos_ply, ang_ply)

	if not IsValid(Gib) or GetViewEntity() != LocalPlayer() then return end
	if CVAR_GibSystem_cam_z_axis:GetInt() == 0 then return end

	------------------------------------
	--复活时显示头发
	if CVAR_GibSystem_cam_hair:GetBool() then
		if LocalPlayer():Alive() and not gui.IsConsoleVisible() then
			if set1 <= 120 and Gib:LookupBone("ValveBiped.Bip01_Head1") then
				ScaleBone_1(Gib:LookupBone("ValveBiped.Bip01_Head1"))
				set1 = set1 + 1
			end
		end
	end

	if LocalPlayer():Alive() then return end

	local view = {}
	if CVAR_GibSystem_cam_enable:GetBool() then

		------------------------------------
		--开关死亡时隐藏头发
		if CVAR_GibSystem_cam_hair:GetBool() and !GetConVar("gibsystem_deathcam_mode"):GetBool() then
			if set0 == 0 and Gib:LookupBone("ValveBiped.Bip01_Head1") then
				ScaleBone_0(Gib:LookupBone("ValveBiped.Bip01_Head1"))
				set0 = 1
			end
		end

		------------------------------------
		--将DeathCam放到头上
		if Gib:LookupAttachment('eyes') > 0 and Gib.ang_smooth_last then
			local pos_rag = Gib:GetAttachment(Gib:LookupAttachment('eyes')).Pos
			local ang_rag = Gib:GetAttachment(Gib:LookupAttachment('eyes')).Ang

			view.origin = pos_rag
			if GetConVar("gibsystem_deathcam_mode"):GetBool() then
				view.angles = ang_rag + Angle(90,0,0)
			else
				view.angles = ang_rag
			end
		else
			------------------------------------
			--正常的第三人称死亡视角
			local rd = util.TraceLine(
				{start=Gib:GetPos(),
				endpos=Gib:GetPos()-ang_ply:Forward()*106,
				filter={Gib,LocalPlayer()}
			})
			view.origin = Gib:GetPos()-ang_ply:Forward()*(CVAR_GibSystem_cam_z_axis:GetInt()*rd.Fraction)
			view.angles = ang_ply
		end

	else
		------------------------------------
		--正常的第三人称死亡视角
		local rd = util.TraceLine(
			{start=Gib:GetPos(),
			endpos=Gib:GetPos()-ang_ply:Forward()*106,
			filter={Gib,LocalPlayer()}
		})
		view.origin = Gib:GetPos()-ang_ply:Forward()*(CVAR_GibSystem_cam_z_axis:GetInt()*rd.Fraction)
		view.angles = ang_ply
	end

	return view
end)