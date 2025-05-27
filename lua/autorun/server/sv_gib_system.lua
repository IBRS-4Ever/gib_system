
AddCSLuaFile()

include("autorun/gibbing_system_module/convars.lua")
include("autorun/gibbing_system_module/defaultnpcs.lua")
include("autorun/gibbing_system_module/models.lua")
include("autorun/gibbing_system_module/expressions.lua")
include("autorun/gibbing_system_module/finger_rotation.lua")
include("autorun/gibbing_system_module/death_anims.lua")

util.AddNetworkString("GibSystem_StartDeathCam")
util.AddNetworkString("GibSystem_PlayerSpawn")
util.AddNetworkString("GibSystem_CleanGibs_Notification")

-- 全局列表
Expressions_Table = {}
Model_Link_Materials = {}
GIRLS_FRONTLINE_2_MODELS = {}
local UpperAndLower = {}
local Limbs = {}
local LeftAndRight = {}
local CompletedModels = {}
local BlackListedModels = {}
if !file.Exists("gib_system/blacklist.txt", "DATA") then
	file.Write("gib_system/blacklist.txt", util.TableToJSON(BlackListedModels) )
else
	BlackListedModels = util.JSONToTable( file.Read("gib_system/blacklist.txt", "DATA") )
end
local Characters = {}
local timers = {}
GibsCreated = {}

local GibModels

file.CreateDir("gib_system")

function LocalizedText(lang,text)
	if string.lower(GetConVar("gmod_language"):GetString()) == lang then
		MsgN(text)
	end
end

local function GibSystem_Initialize()
	GibModels = GibSystem_LoadModels()
	local Model_Path = "autorun/gibbing_system/"
	local files, folders = file.Find(Model_Path.."*","LUA")
	for k, v in pairs(files) do
		if SERVER then
			include(Model_Path..v)
			AddCSLuaFile(Model_Path..v)
		elseif CLIENT then
			include(Model_Path..v)
		end
	end
		
	LocalizedText("zh-cn","[碎尸系统] 正在加载文件...")
	LocalizedText("en","[Gibbing System] Loading Files...")

	if CheckFedhoria() then
		include("fedhoria/modules.lua")
		LocalizedText("zh-cn","[碎尸系统] 已检测到 Fedhoria 并已加载。")
		LocalizedText("en","[Gibbing System] Fedhoria detected and loaded.")
	else
		LocalizedText("zh-cn","[碎尸系统] 未发现 Fedhoria。")
		LocalizedText("en","[Gibbing System] Can't find Fedhoria.")
	end

	table.Empty(UpperAndLower)
	table.Empty(Limbs)
	table.Empty(CompletedModels)
	table.Empty(LeftAndRight)
	Characters = table.Copy(GibModels)
	for k, black in pairs(table.GetKeys(BlackListedModels)) do
		for i = #Characters, 1, -1 do
			if Characters[i] == black then
				table.remove(Characters, i)
				continue 
			end
		end
	end
	for _, Model in ipairs(GibModels) do
		LocalizedText("zh-cn","[碎尸系统] 已加载文件 "..Model)
		LocalizedText("en","[Gibbing System] Loaded file "..Model)
		util.PrecacheModel("models/gib_system/"..Model.."_headless.mdl")
		util.PrecacheModel("models/gib_system/"..Model.."_head.mdl")
		if file.Exists( "models/gib_system/"..Model.."_legs.mdl", "GAME" ) and file.Exists( "models/gib_system/"..Model.."_torso.mdl", "GAME" ) then
			table.insert(UpperAndLower, Model)
			util.PrecacheModel("models/gib_system/"..Model.."_legs.mdl")
			util.PrecacheModel("models/gib_system/"..Model.."_torso.mdl")
		end
		if file.Exists( "models/gib_system/limbs/"..Model.."/left_leg.mdl", "GAME" ) and file.Exists( "models/gib_system/limbs/"..Model.."/right_leg.mdl", "GAME" ) and file.Exists( "models/gib_system/limbs/"..Model.."/left_arm.mdl", "GAME" ) and file.Exists( "models/gib_system/limbs/"..Model.."/right_arm.mdl", "GAME" ) and file.Exists( "models/gib_system/limbs/"..Model.."/torso.mdl", "GAME" ) then
			table.insert(Limbs, Model)
			util.PrecacheModel("models/gib_system/limbs/"..Model.."/left_leg.mdl")
			util.PrecacheModel("models/gib_system/limbs/"..Model.."/right_leg.mdl")
			util.PrecacheModel("models/gib_system/limbs/"..Model.."/left_arm.mdl")
			util.PrecacheModel("models/gib_system/limbs/"..Model.."/right_arm.mdl")
			util.PrecacheModel("models/gib_system/limbs/"..Model.."/torso.mdl")
			if file.Exists( "models/gib_system/limbs/"..Model.."/no_limb/no_right_leg.mdl", "GAME" ) then
				table.insert(CompletedModels, Model)
				util.PrecacheModel("models/gib_system/limbs/"..Model.."/no_limb/no_legs.mdl")
				util.PrecacheModel("models/gib_system/limbs/"..Model.."/no_limb/no_arms.mdl")
				util.PrecacheModel("models/gib_system/limbs/"..Model.."/no_limb/no_right_leg_left_arm.mdl")
				util.PrecacheModel("models/gib_system/limbs/"..Model.."/no_limb/no_left_leg_right_arm.mdl")
				util.PrecacheModel("models/gib_system/limbs/"..Model.."/no_limb/no_left_leg.mdl")
				util.PrecacheModel("models/gib_system/limbs/"..Model.."/no_limb/no_right_leg.mdl")
				util.PrecacheModel("models/gib_system/limbs/"..Model.."/no_limb/no_left_arm.mdl")
				util.PrecacheModel("models/gib_system/limbs/"..Model.."/no_limb/no_arms.mdl")
				util.PrecacheModel("models/gib_system/limbs/"..Model.."/no_limb/no_right_arm.mdl")
				util.PrecacheModel("models/gib_system/limbs/"..Model.."/no_limb/no_right.mdl")
				util.PrecacheModel("models/gib_system/limbs/"..Model.."/no_limb/no_left.mdl")
				util.PrecacheModel("models/gib_system/limbs/"..Model.."/no_limb/no_right_no_arm.mdl")
				util.PrecacheModel("models/gib_system/limbs/"..Model.."/no_limb/no_left_no_arm.mdl")
				util.PrecacheModel("models/gib_system/limbs/"..Model.."/no_limb/no_right_no_leg.mdl")
				util.PrecacheModel("models/gib_system/limbs/"..Model.."/no_limb/no_left_no_leg.mdl")
			end
		end
		if file.Exists( "models/gib_system/"..Model.."_half_left.mdl", "GAME" ) and file.Exists( "models/gib_system/"..Model.."_half_right.mdl", "GAME" ) then
			table.insert(LeftAndRight, Model)
			util.PrecacheModel("models/gib_system/"..Model.."_half_left.mdl")
			util.PrecacheModel("models/gib_system/"..Model.."_half_right.mdl")
		end
	end

	LocalizedText("zh-cn","[碎尸系统] 已加载 "..table.Count(GibModels).." 个文件。"..table.Count(GibModels) - table.Count(Characters).." 个在黑名单中。")
	LocalizedText("en","[Gibbing System] Loaded "..table.Count(GibModels).." File(s). "..table.Count(GibModels) - table.Count(Characters).." in blacklist.")

	LocalizedText("zh-cn","[碎尸系统] 加载完成。\n")
	LocalizedText("en","[Gibbing System] Loading Complete.\n")
end

GibSystem_Initialize()

concommand.Add( "GibSystem_ReloadModels", function() 
	GibSystem_Initialize()
end)

local function RemoveTimers()
    for _, timerid in ipairs(timers) do
        timer.Remove(timerid)
    end
end

EntDamageInfo = {}

hook.Add( "ScaleNPCDamage", "GibSystem_DamageInfo_NPC", function( npc, hitgroup, dmginfo )
	if (dmginfo:GetDamage() < npc:Health()) then return end
	EntDamageInfo[npc] = { Force = dmginfo:GetDamageForce(), Position = dmginfo:GetDamagePosition(), Type = dmginfo:GetDamageType(), HitGroup = hitgroup }
end )

hook.Add( "ScalePlayerDamage", "GibSystem_DamageInfo_Player", function( plr, hitgroup, dmginfo )
	if (dmginfo:GetDamage() < plr:Health()) then return end
	EntDamageInfo[plr] = { Force = dmginfo:GetDamageForce(), Position = dmginfo:GetDamagePosition(), Type = dmginfo:GetDamageType(), HitGroup = hitgroup }
end )

hook.Add("OnNPCKilled", "GibSystem_SpawnGibs_NPC", function(npc, attacker, dmg)
	if GetConVar( "gibsystem_enabled" ):GetBool() and GetConVar( "gibsystem_gibbing_npc" ):GetBool() and (DefaultNPCs[npc:GetClass()] or npc.IsGF2SNPC) then
		npc:EmitSound( "Gib_System.Headshot_Fleshy" )
		SafeRemoveEntity(npc)
		if npc.IsGF2SNPC then
			function npc:CreateDeathCorpse()
				timer.Remove("GF2_HealTimer_"..npc:EntIndex())
				timer.Remove("VJ_GF2_SWEP_Acid_Timer"..npc:EntIndex())
			end
		end
		if GetConVar( "gibsystem_deathanimation" ):GetBool() then
			CreateDeathAnimationGib(npc)
		else
			CreateGibs(npc)
		end
	end
end)

hook.Add("PlayerDeath", "GibSystem_SpawnGibs_Player", function(player, attacker, dmg)
	if GetConVar( "gibsystem_enabled" ):GetBool() and GetConVar( "gibsystem_gibbing_player" ):GetBool() then
		SafeRemoveEntity(player:GetRagdollEntity())
		player:EmitSound( "Gib_System.Headshot_Fleshy" )
		if GetConVar( "gibsystem_deathanimation" ):GetBool() then
			CreateDeathAnimationGib(player)
		else
			CreateGibs(player)
		end
		player:Spectate(5)
		player:SetObserverMode(OBS_MODE_CHASE)
		if GetConVar( "gibsystem_deathcam_mode" ):GetInt() == 0 then
			player:SpectateEntity(head)
		elseif GetConVar( "gibsystem_deathcam_mode" ):GetInt() == 1 then
			player:SpectateEntity(body)
		end
	end
end)

hook.Add("PlayerSpawn", "GibSystem_PlayerSpawn_D", function(ply)
	net.Start("GibSystem_PlayerSpawn")
		net.WriteBool(true)
	net.Broadcast()
end)

function CreateRope(gib1,gib2,gib1phys,gib2phys,vec1,vec2)
	if GetConVar( "gibsystem_rope" ):GetBool() then
		if IsValid(gib1) and IsValid(gib2) then
			local constraint = constraint.Rope(gib1, gib2, gib1:TranslateBoneToPhysBone( gib1:LookupBone( gib2phys or "ValveBiped.Bip01_Head1" ) ), gib2:TranslateBoneToPhysBone( gib2:LookupBone( gib2phys or "ValveBiped.Bip01_Spine4" or "ValveBiped.Bip01_Spine2" or "ValveBiped.Bip01_Spine1" ) ), Vector(0,0,-3), Vector(5,0,0), 5, 0, GetConVar( "gibsystem_rope_strength" ):GetInt(), 1, "gibs/intestines_beam", false)
		else
			LocalizedText("zh-cn","[碎尸系统] 无效实体索引。无法创建绳索。")
			LocalizedText("en","[Gibbing System] Invaild Entity Index. Can't create rope.")
		end
	end
end

concommand.Add("gibsystem_blacklist_add", function(ply, cmd, arg)
	local Character = tostring(table.concat(arg, " "))
	if !BlackListedModels[Character] then
		BlackListedModels[Character] = true
		file.Write("gib_system/blacklist.txt", util.TableToJSON(BlackListedModels) )
		LocalizedText("zh-cn","[碎尸系统] 将 "..Character.." 加入黑名单。")
		LocalizedText("en","[Gibbing System] Added "..Character.." to blacklist.")
	else
		BlackListedModels[Character] = nil
		file.Write("gib_system/blacklist.txt", util.TableToJSON(BlackListedModels) )
		LocalizedText("zh-cn","[碎尸系统] 将 "..Character.." 移出黑名单。")
		LocalizedText("en","[Gibbing System] Removed "..Character.." from blacklist.")
	end
end)

concommand.Add("gibsystem_blacklist_clear", function(ply, cmd, arg)
	BlackListedModels = {}
	file.Write("gib_system/blacklist.txt", util.TableToJSON(BlackListedModels) )
	LocalizedText("zh-cn","[碎尸系统] 已清除黑名单。")
	LocalizedText("en","[Gibbing System] Cleared blacklist.")
	RunConsoleCommand( "GibSystem_ReloadModels" )
end)

function BloodEffect(ent,Type,AttachmentPoint)
	if !GetConVar( "gibsystem_blood_effect" ):GetBool() then return end
	local AP = ent:LookupAttachment( AttachmentPoint )

	if Type == 2 and AP != nil then
		local timerDuration = GetConVar( "gibsystem_blood_time_body" ):GetInt() 			// 定时器持续时间（秒）
		local timerInterval = 1 															// 定时器间隔时间（秒）
		local timerCount = timerDuration / timerInterval 									// 重复次数
		local timerBodyName = "BloodImpactTimer".. ent:EntIndex()
			
		if timerDuration > 0 then
			timer.Create(timerBodyName, timerInterval, timerCount, function()
				if !ent:IsValid() then timer.Remove(timerBodyName) return end
				ParticleEffectAttach( "blood_advisor_pierce_spray", 4, ent, AP )
			end)
		end
	else
		local timerDuration = GetConVar( "gibsystem_blood_time" ):GetInt() 				// 定时器持续时间（秒）
		local timerInterval = 0.1 														// 定时器间隔时间（秒）
		local timerCount = timerDuration / timerInterval 								// 重复次数
		local timerBodyName = "BloodImpactTimer".. ent:EntIndex()
			
		if timerDuration > 0 then
			if AttachmentPoint != nil then
				timer.Create(timerBodyName, timerInterval, timerCount, function()
					if !ent:IsValid() then timer.Remove(timerBodyName) return end
					local boneIndex = ent:LookupBone( AttachmentPoint )
					local bonePos = ent:GetBonePosition(boneIndex or 0)
					local effectData = EffectData()
						
					effectData:SetOrigin(bonePos)
					effectData:SetMagnitude(1)
					effectData:SetScale(1)
					effectData:SetRadius(1)
					util.Effect("BloodImpact", effectData)
				end)
			end
		end
	end
end

function BodyPee(ent)
	if !GetConVar( "gibsystem_pee" ):GetBool() then return end
	local timerDuration = GetConVar( "gibsystem_pee_time" ):GetInt() 					// 定时器持续时间（秒）
	local timerInterval = 1 															// 定时器间隔时间（秒）
	local timerCount = timerDuration / timerInterval 									// 重复次数
	local timerBodyName = "PeeTimer".. ent:EntIndex()
		
	if timerDuration > 0 then
		timer.Create(timerBodyName, timerInterval, timerCount, function()
			if !ent:IsValid() then timer.Remove(timerBodyName) return end
			ParticleEffectAttach( "blood_advisor_shrapnel_spray_2", 4, ent, 0 )
		end)
	end
end

function RandomBodyGroup(ent)
	if GetConVar( "gibsystem_random_bodygroup" ):GetBool() then
		local BodygroupBlacklist = { ["tail"] = true, ["ears"] = true, ["horns"] = true, ["horn left"] = true, ["horn right"] = true, ["fox ears"] = true }
		local num_bodygroups = ent:GetNumBodyGroups()
		for i = 0, num_bodygroups - 1 do
			local bodygroup_name = ent:GetBodygroupName(i)
			if !BodygroupBlacklist[string.lower(bodygroup_name)] then
				local num_choices = ent:GetBodygroupCount(i)
				if num_choices > 1 then
					local choice = math.random(0, num_choices - 1)
					ent:SetBodygroup(i, choice)
				end
			end
		end
	end
end

function RandomSkin(ent)
	if GetConVar( "gibsystem_random_skin" ):GetBool() then
		local num_skins = ent:SkinCount()
		local choice = math.random(0, num_skins - 1)
		ent:SetSkin(choice)
	end
end

function GibConvulsion(ent)
	if GetConVar( "gibsystem_ragdoll_convulsion" ):GetInt() == 1 then
		ent:Input( "StartRagdollBoogie", ent, ent, "" )
	elseif GetConVar( "gibsystem_ragdoll_convulsion" ):GetInt() == 2 and CheckFedhoria() then
		timer.Simple(0, function()
			if !IsValid(ent) then return end	
			fedhoria.StartModule(ent, "stumble_legs", phys_bone, lpos)
		end)
	end
end

function GibGetModel(ent)
	local Materials = ent:GetMaterials()
	
	if table.HasValue( GibModels, GetConVar("gibsystem_gib_name"):GetString() ) then
		GibCharacter = GetConVar("gibsystem_gib_name"):GetString()
	elseif GetConVar("gibsystem_gib_base_on_model"):GetBool() then
		GibCharacter = Characters[math.random( #Characters )]
		for i = 1, table.Count(Materials) do
			if Model_Link_Materials[Materials[i]] then
				GibCharacter = Model_Link_Materials[Materials[i]]
				break
			end
		end
	else
		GibCharacter = Characters[math.random( #Characters )]
	end
end

function CreateGibs(ent)

	function SpawnGib(mdl, AttachmentType, AttachmentPoint, Bodypart, convulsion)
		local Gib
		
		if (util.IsValidRagdoll( mdl )) then Gib = ents.Create("prop_ragdoll") end
		if (util.IsValidProp( mdl )) then Gib = ents.Create("prop_physics") end

		if !file.Exists( mdl, "GAME" ) then
			LocalizedText("zh-cn","[碎尸系统] 模型 "..mdl.." 不存在。")
			LocalizedText("en","[Gibbing System] Model "..mdl.." does not exist.")
			return
		end
		
		Gib:SetModel( mdl )
		Gib.BodyPart = Bodypart
		Gib.Model = GibCharacter

		if Gib.BodyPart == "head" and !util.IsValidRagdoll( mdl ) then
			local HeadPos = ent:LookupBone("ValveBiped.Bip01_Head1") or ent:LookupBone("ValveBiped.HC_Body_Bone") or ent:LookupBone("ValveBiped.Headcrab_Cube1") or false

			if HeadPos then
				Gib:SetPos( ent:GetBonePosition(HeadPos) ) 
			else
				Gib:SetPos( ent:GetPos() )
			end
		else
			Gib:SetPos( ent:GetPos() )
		end
		Gib:SetAngles( ent:GetAngles() )
		Gib:SetCollisionGroup(GetConVar( "gibsystem_ragdoll_collisiongroup" ):GetInt())
		Gib:Spawn()
		Gib:SetName("Gib"..Gib.BodyPart.."Index"..Gib:EntIndex())
		Gib:Activate()

		BloodEffect(Gib,AttachmentType,AttachmentPoint)
		GibFacePose(Gib)
		FingerRotation(Gib)
		RandomBodyGroup(Gib)
		RandomSkin(Gib)

		for i = 0, Gib:GetPhysicsObjectCount() - 1 do
			local phys = Gib:GetPhysicsObjectNum( i )
			local Bone_name = Gib:GetBoneName(Gib:TranslatePhysBoneToBone( i ))
			if ( IsValid( phys ) && ent:LookupBone(Bone_name) != null ) then
				local pos, ang = ent:GetBonePosition( ent:LookupBone(Bone_name) )
				if ( pos ) then phys:SetPos( pos ) end
				if ( ang ) then phys:SetAngles( ang ) end
			end

			if Gib.BodyPart == "head" then
				if GetConVar("gibsystem_head_mass"):GetBool() then phys:SetMass( GetConVar("gibsystem_head_mass"):GetInt() / Gib:GetPhysicsObjectCount() ) end
			else
				if GetConVar("gibsystem_body_mass"):GetBool() then phys:SetMass( GetConVar("gibsystem_body_mass"):GetInt() / Gib:GetPhysicsObjectCount() ) end
			end

			if EntDamageInfo[ent] then
				if ent:IsPlayer() then phys:ApplyForceCenter( (EntDamageInfo[ent].Force / Gib:GetPhysicsObjectCount()) + phys:GetMass() * ent:GetVelocity() * 39.37 * engine.TickInterval() ) end
				if ent:IsNPC() then phys:ApplyForceCenter( (EntDamageInfo[ent].Force / Gib:GetPhysicsObjectCount()) + (phys:GetMass() * ent:GetMoveVelocity() * 39.37 * engine.TickInterval()) )end
			else
				phys:ApplyForceCenter( (phys:GetMass() * ent:GetVelocity() * 39.37 * engine.TickInterval()) )
			end
		end

		local function PhysCallback( ent, data ) -- Function that will be called whenever collision happends
			if !GetConVar("gibsystem_blood_decal"):GetBool() then return end
			local velSpeed = data.Speed
			if velSpeed > 150 then
				local myPos = data.PhysObject:GetPos()
				Gib:SetLocalPos(myPos + Gib:GetUp() * 4) -- Because the entity is too close to the ground
				local tr = util.TraceLine({
					start = myPos,
					endpos = myPos - (data.HitNormal * -30),
					filter = Gib
				})
				EmitSound( "physics/flesh/flesh_squishy_impact_hard4.wav", myPos )
				util.Decal( "Blood", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
				local effect = EffectData() -- Create effect data
				effect:SetOrigin( data.HitPos ) -- Set origin where collision point is
				effect:SetFlags(3)
				effect:SetColor(0)
				effect:SetScale(6)
				util.Effect( "bloodspray", effect ) -- Spawn small sparky effect
			end
		end
		Gib:AddCallback( "PhysicsCollide", PhysCallback ) -- Add Callback

		if Gib.BodyPart == "head" then head = Entity(Gib:EntIndex()) end
		if Gib.BodyPart == "body" then body = Entity(Gib:EntIndex()) end

		if EntDamageInfo[ent] then
			phys_bone = Gib:GetClosestPhysBone(EntDamageInfo[ent].Position)
			if phys_bone then
				local phys = Gib:GetPhysicsObjectNum(phys_bone)
				
				lpos = phys:WorldToLocal(EntDamageInfo[ent].Position)
			end
		end

		if convulsion then GibConvulsion(Gib) end

		if GetConVar( "gibsystem_ragdoll_removetimer" ):GetBool() then
			timer.Simple( GetConVar( "gibsystem_ragdoll_removetimer" ):GetInt(), function()
				if IsValid( Gib ) then Gib:Remove() end
			end)
		end
		table.insert(GibsCreated,Gib)
		return Gib
	end
	
	local Conditions = { "headless", "limbs", "no_legs", "no_arms", "no_right_leg_left_arm", "no_left_leg_right_arm", "no_left_leg", "no_right_leg", "no_left_arm", "no_right_arm", "no_right", "no_left", "no_right_no_arm", "no_left_no_arm", "no_right_no_leg", "no_left_no_leg", "upper_and_lower", "left_and_right" }
	
	if table.HasValue( Conditions, GetConVar("gibsystem_gib_group"):GetString() ) then
		ConditionGib = GetConVar("gibsystem_gib_group"):GetString()
	else
		ConditionGib = Conditions[math.random( #Conditions )]
	end
	
	GibGetModel(ent)

	if ConditionGib == "headless" then

		local Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		local Body = SpawnGib("models/gib_system/"..GibCharacter.."_headless.mdl", 2, "forward", "body", true)
		
		CreateRope(Head, Body)
		BodyPee(Body)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无头")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "limbs" then
		
		if !table.HasValue( Limbs, GibCharacter ) then
			GibCharacter = Limbs[math.random( #Limbs )]
		end

		local Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false)
		local Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/torso.mdl", 2, "forward", "body", true)

		CreateRope(Head, Body)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：碎块")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_legs" then
		
		if !table.HasValue( CompletedModels, GibCharacter ) then
			GibCharacter = CompletedModels[math.random( #CompletedModels )]
		end

		local Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false)
		local Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/no_limb/no_legs.mdl", 2, "forward", "body", true)

		CreateRope(Head, Body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无双腿")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_arms" then
		
		if !table.HasValue( CompletedModels, GibCharacter ) then
			GibCharacter = CompletedModels[math.random( #CompletedModels )]
		end

		local Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false)
		local Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/no_limb/no_arms.mdl", 2, "forward", "body", true)

		CreateRope(Head, Body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无双手")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_right_leg_left_arm" then
		
		if !table.HasValue( CompletedModels, GibCharacter ) then
			GibCharacter = CompletedModels[math.random( #CompletedModels )]
		end

		local Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false)
		local Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/no_limb/no_right_leg_left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", true)

		CreateRope(Head, Body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无右腿左手")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_left_leg_right_arm" then
	
		if !table.HasValue( CompletedModels, GibCharacter ) then
			GibCharacter = CompletedModels[math.random( #CompletedModels )]
		end

		local Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false)
		local Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/no_limb/no_left_leg_right_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", true)

		CreateRope(Head, Body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无左腿右手")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_left_leg" then
		
		if !table.HasValue( CompletedModels, GibCharacter ) then
			GibCharacter = CompletedModels[math.random( #CompletedModels )]
		end

		local Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false)
		local Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/no_limb/no_left_leg.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", true)

		CreateRope(Head, Body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无左腿")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_right_leg" then
		
		if !table.HasValue( CompletedModels, GibCharacter ) then
			GibCharacter = CompletedModels[math.random( #CompletedModels )]
		end

		local Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false)
		local Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/no_limb/no_right_leg.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", true)

		CreateRope(Head, Body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无右腿")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_left_arm" then
	
		if !table.HasValue( CompletedModels, GibCharacter ) then
			GibCharacter = CompletedModels[math.random( #CompletedModels )]
		end

		local Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false)
		local Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/no_limb/no_left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", true)

		CreateRope(Head, Body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无左手")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_right_arm" then
	
		if !table.HasValue( CompletedModels, GibCharacter ) then
			GibCharacter = CompletedModels[math.random( #CompletedModels )]
		end

		local Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false)
		local Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/no_limb/no_right_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", true)

		CreateRope(Head, Body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无右手")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_right" then
	
		if !table.HasValue( CompletedModels, GibCharacter ) then
			GibCharacter = CompletedModels[math.random( #CompletedModels )]
		end

		local Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false)
		local Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/no_limb/no_right.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", true)

		CreateRope(Head, Body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无右半")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_left" then
	
		if !table.HasValue( CompletedModels, GibCharacter ) then
			GibCharacter = CompletedModels[math.random( #CompletedModels )]
		end

		local Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false)
		local Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/no_limb/no_left.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", true)

		CreateRope(Head, Body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无左半")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_right_no_arm" then
	
		if !table.HasValue( CompletedModels, GibCharacter ) then
			GibCharacter = CompletedModels[math.random( #CompletedModels )]
		end

		local Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false)
		local Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/no_limb/no_right_no_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", true)

		CreateRope(Head, Body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无右半无手臂")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_left_no_arm" then
	
		if !table.HasValue( CompletedModels, GibCharacter ) then
			GibCharacter = CompletedModels[math.random( #CompletedModels )]
		end

		local Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false)
		local Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/no_limb/no_left_no_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", true)

		CreateRope(Head, Body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无左半无手臂")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_right_no_leg" then
	
		if !table.HasValue( CompletedModels, GibCharacter ) then
			GibCharacter = CompletedModels[math.random( #CompletedModels )]
		end

		local Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false)
		local Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/no_limb/no_right_no_leg.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", true)

		CreateRope(Head, Body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无右半无腿")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_left_no_leg" then
	
		if !table.HasValue( CompletedModels, GibCharacter ) then
			GibCharacter = CompletedModels[math.random( #CompletedModels )]
		end

		local Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false)
		local Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/no_limb/no_left_no_leg.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", true)

		CreateRope(Head, Body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无左半无腿")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "upper_and_lower" then
		
		if !table.HasValue( UpperAndLower, GibCharacter ) then
			GibCharacter = UpperAndLower[math.random( #UpperAndLower )]
		end

		local Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		local Lower = SpawnGib("models/gib_system/"..GibCharacter.."_legs.mdl", 1, "ValveBiped.Bip01_Spine1", "body", true)
		local Upper = SpawnGib("models/gib_system/"..GibCharacter.."_torso.mdl", 1, "ValveBiped.Bip01_Spine1", "body", true)
		
		CreateRope(Head, Upper)
		--CreateRope(Lower, Upper)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：上/下半身")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
		
	elseif ConditionGib == "left_and_right" then
		
		if !table.HasValue( LeftAndRight, GibCharacter ) then
			GibCharacter = LeftAndRight[math.random( #LeftAndRight )]
		end
		
		local Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		local Left = SpawnGib("models/gib_system/"..GibCharacter.."_half_left.mdl", 2, "forward", "body", true)
		local Right = SpawnGib("models/gib_system/"..GibCharacter.."_half_right.mdl", 2, "forward", "body", true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：左右半身")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	end
	EntDamageInfo[ent] = nil 

	if ent:IsPlayer() then
		net.Start("GibSystem_StartDeathCam")
			net.WriteInt(head:EntIndex(), 32)
			net.WriteInt(body:EntIndex(), 32)
		net.Broadcast()
	end
end

local function CleanGibs()
	local Count = table.Count(GibsCreated) or 0
	net.Start("GibSystem_CleanGibs_Notification")
		net.WriteInt(Count, 32)
	net.Broadcast()

	for k,v in pairs(timers) do
		timer.Remove(v)
	end
	for k,v in pairs(GibsCreated) do
		if IsValid(v) then
			SafeRemoveEntity(v)
			GibsCreated[k] = nil
		end
	end
	table.Empty(GibsCreated)
	table.Empty(timers)
end
concommand.Add("GibSystem_CleanGibs", CleanGibs)
