
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

local function CheckFile(path)
	if (file.Exists( path, "GAME" )) then
		util.PrecacheModel( path )
		return true
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
		Characters[Model] = {}
		Characters[Model][#Characters[Model] + 1] = "headless"
		LocalizedText("zh-cn","[碎尸系统] 已加载文件 "..Model)
		LocalizedText("en","[Gibbing System] Loaded file "..Model)
		util.PrecacheModel("models/gib_system/"..Model.."_headless.mdl")
		util.PrecacheModel("models/gib_system/"..Model.."_head.mdl")
		if CheckFile( "models/gib_system/"..Model.."_legs.mdl" ) and CheckFile( "models/gib_system/"..Model.."_torso.mdl" ) then
			Characters[Model][#Characters[Model] + 1] = "upper_and_lower"
		end
		if CheckFile( "models/gib_system/limbs/"..Model.."/left_leg.mdl" ) and CheckFile( "models/gib_system/limbs/"..Model.."/right_leg.mdl" ) and CheckFile( "models/gib_system/limbs/"..Model.."/left_arm.mdl" ) and CheckFile( "models/gib_system/limbs/"..Model.."/right_arm.mdl" ) and CheckFile( "models/gib_system/limbs/"..Model.."/torso.mdl" ) then
			Characters[Model][#Characters[Model] + 1] = "limbs"
			if CheckFile( "models/gib_system/limbs/"..Model.."/no_limb/no_legs.mdl" ) then
				Characters[Model][#Characters[Model] + 1] = "no_legs"
			end
			if CheckFile( "models/gib_system/limbs/"..Model.."/no_limb/no_arms.mdl" ) then
				Characters[Model][#Characters[Model] + 1] = "no_arms"
			end
			if CheckFile( "models/gib_system/limbs/"..Model.."/no_limb/no_right_leg_left_arm.mdl" ) then
				Characters[Model][#Characters[Model] + 1] = "no_right_leg_left_arm"
			end
			if CheckFile( "models/gib_system/limbs/"..Model.."/no_limb/no_left_leg_right_arm.mdl" ) then
				Characters[Model][#Characters[Model] + 1] = "no_left_leg_right_arm"
			end
			if CheckFile( "models/gib_system/limbs/"..Model.."/no_limb/no_left_leg.mdl" ) then
				Characters[Model][#Characters[Model] + 1] = "no_left_leg"
			end
			if CheckFile( "models/gib_system/limbs/"..Model.."/no_limb/no_left_arm.mdl" ) then
				Characters[Model][#Characters[Model] + 1] = "no_left_arm"
			end
			if CheckFile( "models/gib_system/limbs/"..Model.."/no_limb/no_right_no_arm.mdl" ) then
				Characters[Model][#Characters[Model] + 1] = "no_right_no_arm"
			end
			if CheckFile( "models/gib_system/limbs/"..Model.."/no_limb/no_right_arm.mdl" ) then
				Characters[Model][#Characters[Model] + 1] = "no_right_arm"
			end
			if CheckFile( "models/gib_system/limbs/"..Model.."/no_limb/no_right.mdl" ) then
				Characters[Model][#Characters[Model] + 1] = "no_right"
			end
			if CheckFile( "models/gib_system/limbs/"..Model.."/no_limb/no_left.mdl" ) then
				Characters[Model][#Characters[Model] + 1] = "no_left"
			end
			if CheckFile( "models/gib_system/limbs/"..Model.."/no_limb/no_left_no_arm.mdl" ) then
				Characters[Model][#Characters[Model] + 1] = "no_left_no_arm"
			end
			if CheckFile( "models/gib_system/limbs/"..Model.."/no_limb/no_right_no_leg.mdl" ) then
				Characters[Model][#Characters[Model] + 1] = "no_right_no_leg"
			end
			if CheckFile( "models/gib_system/limbs/"..Model.."/no_limb/no_left_no_leg.mdl" ) then
				Characters[Model][#Characters[Model] + 1] = "no_left_no_leg"
			end
		end

		if CheckFile( "models/gib_system/"..Model.."_half_left.mdl" ) and CheckFile( "models/gib_system/"..Model.."_half_right.mdl" ) then
			Characters[Model][#Characters[Model] + 1] = "left_and_right"
		end
	end
	PrintTable(Characters)

	LocalizedText("zh-cn","[碎尸系统] 已加载 "..table.Count(GibModels).." 个文件。"..table.Count(GibModels) - table.Count(Characters).." 个在黑名单中。")
	LocalizedText("en","[Gibbing System] Loaded "..table.Count(GibModels).." File(s). "..table.Count(GibModels) - table.Count(Characters).." in blacklist.")

	LocalizedText("zh-cn","[碎尸系统] 加载完成。\n")
	LocalizedText("en","[Gibbing System] Loading Complete.\n")
end

GibSystem_Initialize()

concommand.Add( "GibSystem_ReloadModels", function() 
	table.Empty(Model_Link_Materials)
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
	EntDamageInfo[npc] = { Force = dmginfo:GetDamageForce(), Position = dmginfo:GetDamagePosition(), Type = dmginfo:GetDamageType(), DmgInfoTbl = dmginfo, HitGroup = hitgroup }
end )

hook.Add( "ScalePlayerDamage", "GibSystem_DamageInfo_Player", function( plr, hitgroup, dmginfo )
	if (dmginfo:GetDamage() < plr:Health()) then return end
	EntDamageInfo[plr] = { Force = dmginfo:GetDamageForce(), Position = dmginfo:GetDamagePosition(), Type = dmginfo:GetDamageType(), HitGroup = hitgroup }
end )

hook.Add("OnNPCKilled", "GibSystem_SpawnGibs_NPC", function(npc, attacker, dmg)
	if GetConVar( "gibsystem_enabled" ):GetBool() and GetConVar( "gibsystem_gibbing_npc" ):GetBool() and (DefaultNPCs[npc:GetClass()] or npc.IsGF2SNPC) then
		npc:EmitSound( "Gib_System.Headshot_Fleshy" )
		npc.GibSystem_ShouldSpawnGib = true
		if npc.IsGF2SNPC then
			function npc:CreateDeathCorpse()
				timer.Remove("GF2_HealTimer_"..npc:EntIndex())
				timer.Remove("VJ_GF2_SWEP_Acid_Timer"..npc:EntIndex())
			end
		end
		if ( GetConVar("gibsystem_deathanimation"):GetBool() and math.random(1,100) <= GetConVar("gibsystem_deathanimation"):GetInt() ) then
			CreateDeathAnimationGib(npc)
		else
			CreateGibs(npc)
		end
		SafeRemoveEntity(npc)
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
	end
end)

hook.Add("PlayerSpawn", "GibSystem_PlayerSpawn_D", function(ply)
	net.Start("GibSystem_PlayerSpawn")
		net.WriteBool(true)
	net.Broadcast()
end)

hook.Add("CreateEntityRagdoll", "GibSystem_RemoveServerSideRagdoll", function(owner, ragdoll)
	if !GetConVar( "gibsystem_enabled" ):GetBool() then return end
	if owner.GibSystem_ShouldSpawnGib then
		SafeRemoveEntity(ragdoll)
	end
end)

function GibSystem_CreateGibParts(ent,mdl,force)
	local gib
	if util.IsValidRagdoll(mdl) then
		gib = ents.Create("prop_ragdoll")
	else
		gib = ents.Create("prop_physics")
	end
	
	gib:SetModel(mdl)
	gib:SetPos(ent:GetPos())
	gib:SetAngles(ent:GetAngles())
	gib:Spawn()
	gib:SetCollisionGroup(GetConVar( "gibsystem_ragdoll_collisiongroup" ):GetInt())
	FingerRotation(gib)

	for i = 0, ent:GetNumBodyGroups() - 1 do
		gib:SetBodygroup(gib:FindBodygroupByName(ent:GetBodygroupName(i)),ent:GetBodygroup(i))
	end

	if util.IsValidRagdoll(mdl) then
		for i = 0, gib:GetPhysicsObjectCount() - 1 do
			local phys = gib:GetPhysicsObjectNum( i )
			local Bone_name = gib:GetBoneName(gib:TranslatePhysBoneToBone( i ))
			if ( IsValid( phys ) && ent:LookupBone(Bone_name) != null ) then
				local pos, ang = ent:GetBonePosition( ent:LookupBone(Bone_name) )
				if ( pos ) then phys:SetPos( pos ) end
				if ( ang ) then phys:SetAngles( ang ) end
			end
			phys:ApplyForceCenter( ((force / gib:GetPhysicsObjectCount()) or Vector(0,0,0)) + phys:GetMass() * ent:GetVelocity() * 39.37 * engine.TickInterval() )
		end
	else
		local phys = gib:GetPhysicsObject()
		if phys:IsValid() then
			phys:ApplyForceCenter( force or Vector(0,0,0) )
			phys:Wake()
		end
	end
	gib.isgib = true
	table.insert(GibsCreated,gib)

	timer.Simple(GetConVar("gibsystem_gib_removetimer"):GetInt(),function()
		if IsValid(gib) then SafeRemoveEntity(gib) end
		table.RemoveByValue(GibsCreated,gib)
	end)

end

hook.Add("EntityTakeDamage", "GibSystem_GibTakeDamage", function(target, dmg)
	if target.isgib then
		local effect = EffectData() -- Create effect data
		effect:SetOrigin( dmg:GetDamagePosition() ) -- Set origin where collision point is
		effect:SetFlags(3)
		effect:SetColor(0)
		effect:SetScale(6)
		util.Effect( "bloodspray", effect ) -- Spawn small sparky effect
		if !GetConVar("gibsystem_gib_headless"):GetBool() then return end
		if target.GibHealth == nil then return end
		if target.IsGibbed then return end
		if dmg:IsDamageType(DMG_CRUSH) and dmg:GetDamage() < 50 then return end
		target.GibHealth = math.Clamp(target.GibHealth - dmg:GetDamage(), 0, target.GibHealth)
		if target.GibHealth <= 0 then
			if target.BodyPart == "head" then
				GibSystem_CreateGibParts(target,"models/vj_base/gibs/human/brain.mdl",dmg:GetDamageForce())
				GibSystem_CreateGibParts(target,"models/vj_base/gibs/human/eye.mdl",dmg:GetDamageForce())
				GibSystem_CreateGibParts(target,"models/vj_base/gibs/human/eye.mdl",dmg:GetDamageForce())
				GibSystem_CreateGibParts(target,"models/vj_base/gibs/human/gib_small1.mdl",dmg:GetDamageForce())
				GibSystem_CreateGibParts(target,"models/vj_base/gibs/human/gib_small2.mdl",dmg:GetDamageForce())
				GibSystem_CreateGibParts(target,"models/vj_base/gibs/human/gib_small3.mdl",dmg:GetDamageForce())
			else
				if string.find(target:GetModel(),"headless") then
					if table.HasValue( Characters[GibGetModel(target)], "limbs" ) then
						GibSystem_CreateGibParts(target,"models/gib_system/limbs/"..target.Model.."/left_leg.mdl",dmg:GetDamageForce())
						GibSystem_CreateGibParts(target,"models/gib_system/limbs/"..target.Model.."/right_leg.mdl",dmg:GetDamageForce())
						GibSystem_CreateGibParts(target,"models/gib_system/limbs/"..target.Model.."/left_arm.mdl",dmg:GetDamageForce())
						GibSystem_CreateGibParts(target,"models/gib_system/limbs/"..target.Model.."/right_arm.mdl",dmg:GetDamageForce())
						GibSystem_CreateGibParts(target,"models/gib_system/limbs/"..target.Model.."/torso.mdl",dmg:GetDamageForce())
					else
						GibSystem_CreateGibParts(target,"models/vj_base/gibs/human/heart.mdl",dmg:GetDamageForce())
						GibSystem_CreateGibParts(target,"models/vj_base/gibs/human/liver.mdl",dmg:GetDamageForce())
						GibSystem_CreateGibParts(target,"models/vj_base/gibs/human/lung.mdl",dmg:GetDamageForce())
						GibSystem_CreateGibParts(target,"models/vj_base/gibs/human/gib1.mdl",dmg:GetDamageForce())
						GibSystem_CreateGibParts(target,"models/vj_base/gibs/human/gib2.mdl",dmg:GetDamageForce())
						GibSystem_CreateGibParts(target,"models/vj_base/gibs/human/gib3.mdl",dmg:GetDamageForce())
						GibSystem_CreateGibParts(target,"models/vj_base/gibs/human/gib4.mdl",dmg:GetDamageForce())
						GibSystem_CreateGibParts(target,"models/vj_base/gibs/human/gib5.mdl",dmg:GetDamageForce())
						GibSystem_CreateGibParts(target,"models/vj_base/gibs/human/gib6.mdl",dmg:GetDamageForce())
						GibSystem_CreateGibParts(target,"models/vj_base/gibs/human/gib7.mdl",dmg:GetDamageForce())
					end
				else
					return
				end
			end
			target:EmitSound("Watermelon.BulletImpact")
			target.IsGibbed = true
			SafeRemoveEntity(target)
		end
	elseif target:IsPlayer() then
		--print("is player")
		if GetConVar("gibsystem_experimental_features"):GetBool() then
			if dmg:IsExplosionDamage() then
				--print("is explode")
				--print(GibGetModel(target))
				if table.HasValue( Characters[GibGetModel(target)], "limbs" ) then
					--print("has arm")
					local RightArm = ents.Create("prop_ragdoll")
					RightArm:SetModel("models/gib_system/limbs/"..GibGetModel(target).."/right_arm.mdl")
					RightArm:SetPos(target:GetPos())
					RightArm:SetAngles(target:GetAngles())
					RightArm:Spawn()
					RightArm:SetCollisionGroup(GetConVar( "gibsystem_ragdoll_collisiongroup" ):GetInt())
					RightArm:Input( "StartRagdollBoogie", RightArm, RightArm, "9999" )
					//RightArm:SetOwner(target)
					FingerRotation(RightArm)

					for i = 0, target:GetNumBodyGroups() - 1 do
						RightArm:SetBodygroup(RightArm:FindBodygroupByName(target:GetBodygroupName(i)),target:GetBodygroup(i))
					end

					for i = 0, RightArm:GetPhysicsObjectCount() - 1 do
						local phys = RightArm:GetPhysicsObjectNum( i )
						local Bone_name = RightArm:GetBoneName(RightArm:TranslatePhysBoneToBone( i ))
						if ( IsValid( phys ) && target:LookupBone(Bone_name) != null ) then
							local pos, ang = target:GetBonePosition( target:LookupBone(Bone_name) )
							if ( pos ) then phys:SetPos( pos ) end
							if ( ang ) then phys:SetAngles( ang ) end
						end
						phys:ApplyForceCenter( ((dmg:GetDamageForce() / RightArm:GetPhysicsObjectCount()) or Vector(0,0,0)) + phys:GetMass() * target:GetVelocity() * 39.37 * engine.TickInterval() )
					end

					RightArm.isgib = true
					table.insert(GibsCreated,RightArm)

					local Weapon = target:GetActiveWeapon()
					local WeaponModel
					--print(Weapon)
					if IsValid(Weapon) then
						WeaponModel = Weapon:GetWeaponWorldModel()
						local RHand = RightArm:LookupBone("ValveBiped.Bip01_R_Hand")
						--print(WeaponModel)
						local Wep = ents.Create("prop_physics")
						Wep:SetModel(WeaponModel)
						Wep:SetPos(RightArm:GetPos())
						Wep:SetAngles(RightArm:GetAngles())
						Wep:FollowBone(RightArm,RightArm:LookupBone("ValveBiped.Bip01_R_Hand"))
						Wep:PhysicsInit(SOLID_VPHYSICS)
						Wep:SetMoveType(MOVETYPE_VPHYSICS)
						Wep:SetSolid(SOLID_VPHYSICS)
						Wep:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
						Wep:SetOwner(RightArm)
						Wep:Spawn()
						Wep:Activate()
						--print(Wep)
						timer.Create( "Wep"..Wep:EntIndex().."Timer", 0.1, 0, function()
							if IsValid(Wep) then
								local Muzzle = Wep:GetAttachment(Wep:LookupAttachment("muzzle"))
								Wep:FireBullets({
									Attacker = Wep.Owner,
									Inflictor = self,
									Num = 1,
									Src = Muzzle.Pos,
									Dir = Muzzle.Ang:Forward(),
									Spread = 0.1,
									Tracer = 1,
									Force = 1,
									Damage = 8,
									AmmoType = "AR2"
								})
								local phys = RightArm:GetPhysicsObjectNum( RightArm:TranslateBoneToPhysBone( RightArm:LookupBone("ValveBiped.Bip01_R_Hand")) )
								phys:ApplyForceCenter( Muzzle.Ang:Forward() * 100 + phys:GetMass() * Vector( 0, 0, -9.80665 ) * 39.37 * engine.TickInterval() )
							end
						end)
					end

					if GetConVar( "gibsystem_ragdoll_removetimer" ):GetBool() then
						timer.Simple(GetConVar("gibsystem_ragdoll_removetimer"):GetInt(),function()
							if IsValid(RightArm) then SafeRemoveEntity(RightArm) end
							table.RemoveByValue(GibsCreated,RightArm)
						end)
					end
				end
			elseif dmg:IsFallDamage() then
				if table.HasValue( Characters[GibGetModel(target)], "limbs" ) then
					GibSystem_CreateGibParts(target,"models/gib_system/limbs/"..GibGetModel(target).."/left_leg.mdl",dmg:GetDamageForce())
					GibSystem_CreateGibParts(target,"models/gib_system/limbs/"..GibGetModel(target).."/right_leg.mdl",dmg:GetDamageForce())
					target:AddFlags(FL_DUCKING)
				end
			end
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
	--[[ local Attachment = ent:GetAttachment(ent:LookupAttachment( "forward" ))
	local pos = Attachment.Pos
	local normal = pos:GetNormalized()
	print(pos,normal)
	
	-- Generic bleed effect:
	ent:RealisticBlood_DropletEffect( pos, normal, true )

	-- Exit wound:
	ent:RealisticBlood_ExitWound( pos, -normal, 10 )

	-- Wound that scaled with damage and stuff:
	local effectdata = EffectData()
	effectdata:SetStart( pos )
	effectdata:SetNormal( normal )
	effectdata:SetRadius( 2 )
	effectdata:SetMagnitude( 10 )
	effectdata:SetFlags( 1 )
	RealisticBlood_DoEffect("realisticblood_dynamicwound", effectdata, ent)

	-- Blood stream:
	ent:RealisticBlood_BloodStream( pos, normal )

	ent:RealisticBlood_Soak( pos, normal )

	-- Blood pool (only works for ragdolls):d
	ent:RealisticBlood_BloodPool( pos, 10 ) ]]
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
	return GibCharacter
end

function CreateGibs(ent)

	function SpawnGib(mdl, AttachmentType, AttachmentPoint, Bodypart, convulsion)
		local Gib
		
		if (util.IsValidRagdoll( mdl )) then Gib = ents.Create("prop_ragdoll") Gib.UsesRealisticBlood = true end
		if (util.IsValidProp( mdl )) then Gib = ents.Create("prop_physics") end

		if !file.Exists( mdl, "GAME" ) then
			LocalizedText("zh-cn","[碎尸系统] 模型 "..mdl.." 不存在。")
			LocalizedText("en","[Gibbing System] Model "..mdl.." does not exist.")
			return
		end
		Gib.isgib = true
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
		Gib.Owner = ent
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

		if Gib.BodyPart == "head" then Gib.GibHealth = GetConVar("gibsystem_head_health"):GetInt() end
		if Gib.BodyPart == "body" then Gib.GibHealth = GetConVar("gibsystem_body_health"):GetInt() end

		if EntDamageInfo[ent] and CheckFedhoria() then
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
				table.RemoveByValue(GibsCreated,Gib)
			end)
		end
		table.insert(GibsCreated,Gib)
		return Gib
	end
	
	local Char = Characters[GibGetModel(ent)]
	local ConditionGib = Char[math.random( #Char )]

	if table.HasValue( Char, GetConVar("gibsystem_gib_group"):GetString() ) then
		ConditionGib = GetConVar("gibsystem_gib_group"):GetString()
	end

	local Head
	local Body

	if ConditionGib == "headless" then

		Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		Body = SpawnGib("models/gib_system/"..GibCharacter.."_headless.mdl", 2, "forward", "body", true)
		
		CreateRope(Head, Body)
		BodyPee(Body)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无头")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "limbs" then
		
		Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false)
		Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/torso.mdl", 2, "forward", "body", true)

		CreateRope(Head, Body)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：碎块")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_legs" then
		
		Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false)
		Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/no_limb/no_legs.mdl", 2, "forward", "body", true)

		CreateRope(Head, Body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无双腿")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_arms" then
		
		Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false)
		Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/no_limb/no_arms.mdl", 2, "forward", "body", true)

		CreateRope(Head, Body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无双手")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_right_leg_left_arm" then
		
		Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false)
		Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/no_limb/no_right_leg_left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", true)

		CreateRope(Head, Body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无右腿左手")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_left_leg_right_arm" then
	
		Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false)
		Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/no_limb/no_left_leg_right_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", true)

		CreateRope(Head, Body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无左腿右手")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_left_leg" then
		
		Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false)
		Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/no_limb/no_left_leg.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", true)

		CreateRope(Head, Body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无左腿")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_right_leg" then
		
		Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false)
		Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/no_limb/no_right_leg.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", true)

		CreateRope(Head, Body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无右腿")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_left_arm" then
	
		Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false)
		Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/no_limb/no_left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", true)

		CreateRope(Head, Body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无左手")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_right_arm" then
	
		Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false)
		Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/no_limb/no_right_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", true)

		CreateRope(Head, Body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无右手")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_right" then
	
		Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false)
		Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/no_limb/no_right.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", true)

		CreateRope(Head, Body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无右半")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_left" then
	
		Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false)
		Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/no_limb/no_left.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", true)

		CreateRope(Head, Body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无左半")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_right_no_arm" then
	
		Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false)
		Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/no_limb/no_right_no_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", true)

		CreateRope(Head, Body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无右半无手臂")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_left_no_arm" then
	
		Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false)
		Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/no_limb/no_left_no_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", true)

		CreateRope(Head, Body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无左半无手臂")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_right_no_leg" then
	
		Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false)
		Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/no_limb/no_right_no_leg.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", true)

		CreateRope(Head, Body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无右半无腿")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_left_no_leg" then
	
		Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false)
		SpawnGib("models/gib_system/limbs/"..GibCharacter.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false)
		Body = SpawnGib("models/gib_system/limbs/"..GibCharacter.."/no_limb/no_left_no_leg.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", true)

		CreateRope(Head, Body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：无左半无腿")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "upper_and_lower" then
		
		Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		local Lower = SpawnGib("models/gib_system/"..GibCharacter.."_legs.mdl", 1, "ValveBiped.Bip01_Spine1", "body", true)
		Body = SpawnGib("models/gib_system/"..GibCharacter.."_torso.mdl", 1, "ValveBiped.Bip01_Spine1", "body", true)
		
		CreateRope(Head, Upper)
		--CreateRope(Lower, Upper)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：上/下半身")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
		
	elseif ConditionGib == "left_and_right" then
		
		Head = SpawnGib("models/gib_system/"..GibCharacter.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", false)
		local Left = SpawnGib("models/gib_system/"..GibCharacter.."_half_left.mdl", 2, "forward", "body", true)
		Body = SpawnGib("models/gib_system/"..GibCharacter.."_half_right.mdl", 2, "forward", "body", true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibCharacter.." | 碎尸组合：左右半身")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibCharacter.." | Gib Group : "..ConditionGib)
	end
	EntDamageInfo[ent] = nil 

	if ent:IsPlayer() then
		net.Start("GibSystem_StartDeathCam")
			net.WriteInt(Head:EntIndex(), 32)
			net.WriteInt(Body:EntIndex(), 32)
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
