
AddCSLuaFile()

include("autorun/gibbing_system/convars.lua")
include("autorun/gibbing_system/tables.lua")
include("autorun/gibbing_system/defaultnpcs.lua")
include("autorun/gibbing_system/models.lua")
include("autorun/gibbing_system/expressions.lua")
include("autorun/gibbing_system/finger_rotation.lua")
include("autorun/gibbing_system/death_anims.lua")

Model_Path = "autorun/gibbing_system/models/"

local GmodLanguage = string.lower(GetConVar("gmod_language"):GetString())
local Fedhoria = false 

function LocalizedText(lang,text)
	if GmodLanguage == lang then
		MsgN(text)
	end
end

local function GibSystem_Initialize()
	local files, folders = file.Find(Model_Path.."*","LUA")
	for k, v in pairs(files) do
		if SERVER then
			include(Model_Path..v)
			AddCSLuaFile(Model_Path..v)
		elseif CLIENT then
			include(Model_Path..v)
		end
	end
end

GibSystem_Initialize()

LocalizedText("zh-cn","[碎尸系统] 正在加载文件...")
LocalizedText("en","[Gibbing System] Loading Files...")

if file.Exists( "fedhoria/modules.lua", "LUA" ) then
	include("fedhoria/modules.lua")
	Fedhoria = true
	LocalizedText("zh-cn","[碎尸系统] 已检测到 Fedhoria 并已加载。")
	LocalizedText("en","[Gibbing System] Fedhoria detected and loaded.")
else
	LocalizedText("zh-cn","[碎尸系统] 未发现 Fedhoria。")
	LocalizedText("en","[Gibbing System] Can't find Fedhoria.")
	Fedhoria = false
end

for _, Model in ipairs(GibModels) do
	LocalizedText("zh-cn","[碎尸系统] 已加载文件 "..Model)
	LocalizedText("en","[Gibbing System] Loaded file "..Model)
	util.PrecacheModel("models/gib_system/"..Model.."_headless.mdl")
	util.PrecacheModel("models/gib_system/"..Model.."_head.mdl")
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
		end
	end
	if file.Exists( "models/gib_system/"..Model.."_half_left.mdl", "GAME" ) and file.Exists( "models/gib_system/"..Model.."_half_right.mdl", "GAME" ) then
		table.insert(LeftAndRight, Model)
		util.PrecacheModel("models/gib_system/"..Model.."_half_left.mdl")
		util.PrecacheModel("models/gib_system/"..Model.."_half_right.mdl")
	end
end

LocalizedText("zh-cn","[碎尸系统] 已加载 "..table.Count(GibModels).." 个模型。")
LocalizedText("en","[Gibbing System] Loaded "..table.Count(GibModels).." Model(s). ")

LocalizedText("zh-cn","[碎尸系统] 加载完成。\n")
LocalizedText("en","[Gibbing System] Loading Complete.\n")

local function RemoveTimers()
    for _, timerid in ipairs(timers) do
        timer.Remove(timerid)
    end
end

DamageForce = Vector(0,0,0)
DamagePosition = Vector(0,0,0)

hook.Add("EntityTakeDamage", "gibsystem", function(ent, dmginfo)
	if !(dmginfo:GetDamage() >= ent:Health()) then return end
	DamageForce = dmginfo:GetDamageForce()
	DamagePosition = dmginfo:GetDamagePosition()
	if (Fedhoria) then
		last_dmgpos[ent] = dmginfo:GetDamagePosition()
	end
end)

hook.Add( "ScaleNPCDamage", "GSDamageInfoNPC", function( npc, hitgroup, dmginfo )
	if !(dmginfo:GetDamage() >= npc:Health()) then return end
	DamageForce = dmginfo:GetDamageForce()
	DamagePosition = dmginfo:GetDamagePosition()
	if (Fedhoria) then
		last_dmgpos[npc] = dmginfo:GetDamagePosition()
	end
end )

hook.Add( "ScaleNPCDamage", "GSDamageInfoPlayer", function( plr, hitgroup, dmginfo )
	if !(dmginfo:GetDamage() >= plr:Health()) then return end
	DamageForce = dmginfo:GetDamageForce()
	DamagePosition = dmginfo:GetDamagePosition()
	if (Fedhoria) then
		last_dmgpos[plr] = dmginfo:GetDamagePosition()
	end
end )

hook.Add("OnNPCKilled", "SpawnGibs", function(npc, attacker, dmg)

	if GetConVar( "gibsystem_enabled" ):GetBool() and GetConVar( "gibsystem_gibbing_npc" ):GetBool() and DefaultNPCs[npc:GetClass()] then
			
		SafeRemoveEntity(npc)
		npc:EmitSound( "Gib_System.Headshot_Fleshy" )
		if GetConVar( "gibsystem_experiment" ):GetBool() and GetConVar( "gibsystem_deathanimation" ):GetBool() then
			CreateDeathAnimationGib(npc)
		else
			CreateGibs(npc)
		end
	end
end)

hook.Add("PlayerDeath", "SpawnGibs", function(player, attacker, dmg)
	if GetConVar( "gibsystem_enabled" ):GetBool() and GetConVar( "gibsystem_gibbing_player" ):GetBool() then
		SafeRemoveEntity(player:GetRagdollEntity())
		player:EmitSound( "Gib_System.Headshot_Fleshy" )
		if GetConVar( "gibsystem_experiment" ):GetBool() and GetConVar( "gibsystem_deathanimation" ):GetBool() then
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

function BloodEffect(ent,Type,AttachmentPoint,BonusTime)
	if GetConVar( "gibsystem_blood_effect" ):GetBool() then
		local AP = ent:LookupAttachment( AttachmentPoint )
		if BonusTime == nil then
			BonusTime = 0
		end
		if Type == 2 and AP != nil then
			local timerDuration = GetConVar( "gibsystem_blood_time_body" ):GetInt()-BonusTime -- 定时器持续时间（秒）
			local timerInterval = 1 -- 定时器间隔时间（秒）
			local timerCount = timerDuration / timerInterval -- 重复次数
			local timerBodyName = "BloodImpactTimer".. ent:EntIndex()
			
			if timerDuration > 0 then
				timer.Create(timerBodyName, timerInterval, timerCount, function()
					ParticleEffectAttach( "blood_advisor_pierce_spray", 4, ent, AP )
				end)
				table.insert(timers, timerBodyName)
			end
		else
			-- print(ent:GetModel().." has no attachment named "..AP.."!")
			local timerDuration = GetConVar( "gibsystem_blood_time" ):GetInt()-BonusTime -- 定时器持续时间（秒）
			local timerInterval = 0.1 -- 定时器间隔时间（秒）
			local timerCount = timerDuration / timerInterval -- 重复次数
			local timerBodyName = "BloodImpactTimer".. ent:EntIndex()
			
			if timerDuration > 0 then
				if AttachmentPoint != nil then
					timer.Create(timerBodyName, timerInterval, timerCount, function()
						local boneIndex = ent:LookupBone( AttachmentPoint )
						local bonePos = ent:GetBonePosition(boneIndex or 0)
						local effectData = EffectData()
						
						effectData:SetOrigin(bonePos)
						effectData:SetMagnitude(1)
						effectData:SetScale(1)
						effectData:SetRadius(1)
						util.Effect("BloodImpact", effectData)
					end)
					table.insert(timers, timerBodyName)
				end
			end
		end
	end
end

function RandomBodyGroup(ent)
	if GetConVar( "gibsystem_random_bodygroup" ):GetBool() then
		local BodygroupBlacklist = { "tail", "ears", "horns", "horn left", "horn right", "fox ears" }
		local num_bodygroups = ent:GetNumBodyGroups()
		for i = 0, num_bodygroups - 1 do
			local bodygroup_name = ent:GetBodygroupName(i)
			if !table.HasValue( BodygroupBlacklist,string.lower(bodygroup_name) ) then
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
	elseif GetConVar( "gibsystem_ragdoll_convulsion" ):GetInt() == 2 and Fedhoria then
		timer.Simple(0, function()
		if !IsValid(ent) then return end	
			fedhoria.StartModule(ent, "stumble_legs", phys_bone, lpos)
			last_dmgpos[ent] = nil		
		end)
	end
end

function CreateGibs(ent)
	if Fedhoria then
		local dmgpos = last_dmgpos[ent]
		local phys_bone, lpos

		if dmgpos then
			phys_bone = ent:GetClosestPhysBone(dmgpos)
			if phys_bone then
				local phys = ent:GetPhysicsObjectNum(phys_bone)
				
				lpos = phys:WorldToLocal(dmgpos)
			end
		end
	end

	function SpawnGib(Type, mdl, AttachmentType, AttachmentPoint, Bodypart, FacePose, FingerPose, convulsion)
		local Gib = ents.Create("prop_"..tostring(Type))
		
		if !file.Exists( mdl, "GAME" ) then
			LocalizedText("zh-cn","[碎尸系统] 模型 "..mdl.." 不存在。")
			LocalizedText("en","[Gibbing System] Model "..mdl.." does not exist.")
			return
		end
		
		Gib:SetModel( mdl )
		
		if Bodypart == "head" and Type != "ragdoll" then
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
		--Gib:SetOwner( ent )
		Gib:SetName("Gib"..Bodypart.."Index"..Gib:EntIndex())
		Gib:Activate()
		
		if FacePose then
			GibFacePose(Gib)
		end
		
		if AttachmentType != nil then
			BloodEffect(Gib,AttachmentType,AttachmentPoint)
		end
		
		if convulsion then
			GibConvulsion(Gib)
		end
		
		FingerRotation(Gib)
		RandomBodyGroup(Gib)
		RandomSkin(Gib)
		
		if Bodypart == "head" then
				
			for i = 0, Gib:GetPhysicsObjectCount() - 1 do
				local phys = Gib:GetPhysicsObjectNum( i )
				
				if GetConVar("gibsystem_head_mass"):GetInt() > 0 then
					phys:SetMass( GetConVar("gibsystem_head_mass"):GetInt() / Gib:GetPhysicsObjectCount() )
				end
				
				if ent:IsPlayer() then
					-- phys:ApplyForceCenter( phys:GetMass() * ent:GetVelocity() * 39.37 * engine.TickInterval() )
					phys:ApplyForceCenter( (DamageForce / Gib:GetPhysicsObjectCount()) + phys:GetMass() * ent:GetVelocity() * 39.37 * engine.TickInterval() )
				else
					phys:ApplyForceCenter( (DamageForce / Gib:GetPhysicsObjectCount()) + (phys:GetMass() * ent:GetMoveVelocity() * 39.37 * engine.TickInterval()) )
					-- phys:ApplyForceOffset( DamageForce / Gib:GetPhysicsObjectCount(), DamagePosition )
				end
			end

			head = Entity(Gib:EntIndex())

		elseif Bodypart == "body" then

			for i = 0, Gib:GetPhysicsObjectCount() - 1 do
				local phys = Gib:GetPhysicsObjectNum( i )
				local Bone_name = Gib:GetBoneName(Gib:TranslatePhysBoneToBone( i ))
				if ( IsValid( phys ) && ent:LookupBone(Bone_name) != null ) then
					local pos, ang = ent:GetBonePosition( ent:LookupBone(Bone_name) )
					if ( pos ) then phys:SetPos( pos ) end
					if ( ang ) then phys:SetAngles( ang ) end
				end

				if GetConVar("gibsystem_body_mass"):GetInt() > 0 then
					phys:SetMass( GetConVar("gibsystem_body_mass"):GetInt() / Gib:GetPhysicsObjectCount() )
				end

				if DamageForce and DamagePosition then
					if ent:IsPlayer() then
						-- phys:ApplyForceCenter( phys:GetMass() * ent:GetVelocity() * 39.37 * engine.TickInterval() )
						phys:ApplyForceCenter( (DamageForce / Gib:GetPhysicsObjectCount()) + phys:GetMass() * ent:GetVelocity() * 39.37 * engine.TickInterval() )
					else
						-- phys:ApplyForceOffset( DamageForce / Gib:GetPhysicsObjectCount(), DamagePosition )
						phys:ApplyForceCenter( (DamageForce / Gib:GetPhysicsObjectCount()) + (phys:GetMass() * ent:GetMoveVelocity() * 39.37 * engine.TickInterval()) )
					end
				else
					phys:ApplyForceOffset( Vector(0,0,0), Vector(0,0,0) )
				end
			end
			
			body = Entity(Gib:EntIndex())

		end
		
		--[[
		
		local dmgpos = last_dmgpos[ent]
		local phys_bone, lpos

		if dmgpos then
			phys_bone = Gib:GetClosestPhysBone(dmgpos)
			if phys_bone then
				local phys = Gib:GetPhysicsObjectNum(phys_bone)
				print(Gib:GetBoneName(Gib:TranslatePhysBoneToBone(phys_bone)))
				lpos = phys:WorldToLocal(dmgpos)
			end
		end

		if GetConVar( "gibsystem_ragdoll_convulsion" ):GetInt() == 1 then
			Gib:Input( "StartRagdollBoogie", Gib, Gib, "" )
		elseif GetConVar( "gibsystem_ragdoll_convulsion" ):GetInt() == 2 then
			timer.Simple(0, function()
			if !IsValid(Gib) then return end	
				fedhoria.StartModule(Gib, "stumble_legs", phys_bone, lpos)
				last_dmgpos[ent] = nil		
			end)
		end

		]]--

		if GetConVar( "gibsystem_ragdoll_removetimer" ):GetInt() > 0 then
			timer.Create( "RemoveTimer"..Gib:EntIndex(), GetConVar( "gibsystem_ragdoll_removetimer" ):GetInt(), 1, function()
				if IsValid( Gib ) then
					Gib:Remove()
				end
				timer.Remove( "RemoveTimer"..Gib:EntIndex() )
				timer.Remove( "BloodImpactTimer"..Gib:EntIndex() )
			end)
		end
		
		Gib:CallOnRemove("RemoveGibTimer",function(Gib) timer.Remove( "BloodImpactTimer"..Gib:EntIndex() ) end)

		table.insert(GibsCreated,Gib)
		
	end
	
	local Conditions = { "headless", "limbs", "no_legs", "no_arms", "no_right_leg_left_arm", "no_left_leg_right_arm", "no_left_leg", "no_right_leg", "no_left_arm", "no_right_arm", "no_right", "no_left", "no_right_no_arm", "no_left_no_arm", "no_right_no_leg", "no_left_no_leg", "upper_and_lower", "left_and_right" }
	
	if table.HasValue( Conditions, GetConVar("gibsystem_gib_group"):GetString() ) then
		ConditionGib = GetConVar("gibsystem_gib_group"):GetString()
	else
		ConditionGib = Conditions[math.random( #Conditions )]
	end
	
	local Materials = ent:GetMaterials()
		
	if table.HasValue( GibModels, GetConVar("gibsystem_gib_name"):GetString() ) then
		Model = GetConVar("gibsystem_gib_name"):GetString()
	elseif string.find(ent:GetModel(), "klukai_astral_luminous") then
		Model = "klukai_astral_luminous"
	elseif GetConVar("gibsystem_gib_base_on_model"):GetBool() then
		Model = GibModels[math.random( #GibModels )]
		for i = 1, table.Count(Materials) do
			if Model_Link_Materials[Materials[i]] then
				Model = Model_Link_Materials[Materials[i]]
				break
			end
		end
	else
		Model = GibModels[math.random( #GibModels )]
	end
	
	if ConditionGib == "headless" then
		
		SpawnGib("ragdoll", "models/gib_system/"..Model.."_headless.mdl", 2, "forward", "body", false, true, true)
		
		CreateRope(head, body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..Model.." | 碎尸组合：无头")
		LocalizedText("en","[Gibbing System] Selected Model: "..Model.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "limbs" then
		
		if !table.HasValue( Limbs, Model ) then
			Model = Limbs[math.random( #Limbs )]
		end

		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/torso.mdl", 2, "forward", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..Model.." | 碎尸组合：碎块")
		LocalizedText("en","[Gibbing System] Selected Model: "..Model.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_legs" then
		
		if !table.HasValue( CompletedModels, Model ) then
			Model = CompletedModels[math.random( #CompletedModels )]
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/no_limb/no_legs.mdl", 2, "forward", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..Model.." | 碎尸组合：无双腿")
		LocalizedText("en","[Gibbing System] Selected Model: "..Model.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_arms" then
		
		if !table.HasValue( CompletedModels, Model ) then
			Model = CompletedModels[math.random( #CompletedModels )]
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/no_limb/no_arms.mdl", 2, "forward", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..Model.." | 碎尸组合：无双手")
		LocalizedText("en","[Gibbing System] Selected Model: "..Model.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_right_leg_left_arm" then
		
		if !table.HasValue( CompletedModels, Model ) then
			Model = CompletedModels[math.random( #CompletedModels )]
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/no_limb/no_right_leg_left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..Model.." | 碎尸组合：无右腿左手")
		LocalizedText("en","[Gibbing System] Selected Model: "..Model.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_left_leg_right_arm" then
	
		if !table.HasValue( CompletedModels, Model ) then
			Model = CompletedModels[math.random( #CompletedModels )]
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/no_limb/no_left_leg_right_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..Model.." | 碎尸组合：无左腿右手")
		LocalizedText("en","[Gibbing System] Selected Model: "..Model.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_left_leg" then
		
		if !table.HasValue( CompletedModels, Model ) then
			Model = CompletedModels[math.random( #CompletedModels )]
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/no_limb/no_left_leg.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..Model.." | 碎尸组合：无左腿")
		LocalizedText("en","[Gibbing System] Selected Model: "..Model.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_right_leg" then
		
		if !table.HasValue( CompletedModels, Model ) then
			Model = CompletedModels[math.random( #CompletedModels )]
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/no_limb/no_right_leg.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..Model.." | 碎尸组合：无右腿")
		LocalizedText("en","[Gibbing System] Selected Model: "..Model.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_left_arm" then
	
		if !table.HasValue( CompletedModels, Model ) then
			Model = CompletedModels[math.random( #CompletedModels )]
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/no_limb/no_left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..Model.." | 碎尸组合：无左手")
		LocalizedText("en","[Gibbing System] Selected Model: "..Model.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_right_arm" then
	
		if !table.HasValue( CompletedModels, Model ) then
			Model = CompletedModels[math.random( #CompletedModels )]
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/no_limb/no_right_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..Model.." | 碎尸组合：无右手")
		LocalizedText("en","[Gibbing System] Selected Model: "..Model.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_right" then
	
		if !table.HasValue( CompletedModels, Model ) then
			Model = CompletedModels[math.random( #CompletedModels )]
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/no_limb/no_right.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..Model.." | 碎尸组合：无右半")
		LocalizedText("en","[Gibbing System] Selected Model: "..Model.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_left" then
	
		if !table.HasValue( CompletedModels, Model ) then
			Model = CompletedModels[math.random( #CompletedModels )]
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/no_limb/no_left.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..Model.." | 碎尸组合：无左半")
		LocalizedText("en","[Gibbing System] Selected Model: "..Model.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_right_no_arm" then
	
		if !table.HasValue( CompletedModels, Model ) then
			Model = CompletedModels[math.random( #CompletedModels )]
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/no_limb/no_right_no_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..Model.." | 碎尸组合：无右半无手臂")
		LocalizedText("en","[Gibbing System] Selected Model: "..Model.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_left_no_arm" then
	
		if !table.HasValue( CompletedModels, Model ) then
			Model = CompletedModels[math.random( #CompletedModels )]
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/no_limb/no_left_no_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..Model.." | 碎尸组合：无左半无手臂")
		LocalizedText("en","[Gibbing System] Selected Model: "..Model.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_right_no_leg" then
	
		if !table.HasValue( CompletedModels, Model ) then
			Model = CompletedModels[math.random( #CompletedModels )]
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/no_limb/no_right_no_leg.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..Model.." | 碎尸组合：无右半无腿")
		LocalizedText("en","[Gibbing System] Selected Model: "..Model.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_left_no_leg" then
	
		if !table.HasValue( CompletedModels, Model ) then
			Model = CompletedModels[math.random( #CompletedModels )]
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/no_limb/no_left_no_leg.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..Model.." | 碎尸组合：无左半无腿")
		LocalizedText("en","[Gibbing System] Selected Model: "..Model.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "upper_and_lower" then
		
		if !table.HasValue( UpperAndLower, Model ) then
			Model = UpperAndLower[math.random( #UpperAndLower )]
		end
		
		SpawnGib("ragdoll", "models/gib_system/"..Model.."_torso.mdl", 1, "ValveBiped.Bip01_Spine1", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/"..Model.."_legs.mdl", 1, "ValveBiped.Bip01_Spine1", "body", false, true, true)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..Model.." | 碎尸组合：上/下半身")
		LocalizedText("en","[Gibbing System] Selected Model: "..Model.." | Gib Group : "..ConditionGib)
		
	elseif ConditionGib == "left_and_right" then
		
		if !table.HasValue( LeftAndRight, Model ) then
			Model = LeftAndRight[math.random( #LeftAndRight )]
		end
		
		SpawnGib("ragdoll", "models/gib_system/"..Model.."_half_left.mdl", 2, "forward", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/"..Model.."_half_right.mdl", 2, "forward", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..Model.." | 碎尸组合：左右半身")
		LocalizedText("en","[Gibbing System] Selected Model: "..Model.." | Gib Group : "..ConditionGib)
	end
	
	if !list.HasEntry("GIBSYSTEM_RAGDOLL_HEADS",Model) then
		SpawnGib("physics", "models/gib_system/"..Model.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
	else
		SpawnGib("ragdoll", "models/gib_system/"..Model.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
	end
	
	-- DamageForce = Vector(0,0,0)
	-- DamagePosition = Vector(0,0,0)
end

local function CleanGibs()
	for k,v in pairs(timers) do
		timer.Remove(v)
	end
	for k,v in pairs(GibsCreated) do
		if IsValid(v) then
			SafeRemoveEntity(v)
		end
	end
end

concommand.Add("CleanGibs", CleanGibs)
