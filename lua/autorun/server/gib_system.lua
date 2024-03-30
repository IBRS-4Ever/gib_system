
AddCSLuaFile()

Model_Path = "autorun/gibbing_system/models/"
Model_Table = {}

Expressions_Table = {}

local GmodLanguage = string.lower(GetConVar("gmod_language"):GetString())

function LocalizedText(lang,text)
	local DefaultLang = "en-us"
	if GmodLanguage == lang then
		MsgN(text)
	end
end

function GSLanguageChanged()
	GmodLanguage = string.lower(GetConVar("gmod_language"):GetString())
end
cvars.AddChangeCallback( "gmod_language", GSLanguageChanged, "GSLanguageChanged" )

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
hook.Add("InitPostEntity","GibSystem_Initialize",GibSystem_Initialize)

-- PrintTable(Model_Table)

LocalizedText("zh-cn","[碎尸系统] 正在加载文件...")
LocalizedText("en","[Gibbing System] Loading Files...")

if file.Exists( "fedhoria/modules.lua", "LUA" ) then
	include("fedhoria/modules.lua")
	LocalizedText("zh-cn","[碎尸系统] 已检测到 Fedhoria 并已加载。")
	LocalizedText("en","[Gibbing System] Fedhoria detected and loaded.")
else
	LocalizedText("zh-cn","[碎尸系统] 未发现 Fedhoria。")
	LocalizedText("en","[Gibbing System] Can't find Fedhoria.")
end

concommand.Add( "GibsystemReload", function( ply, cmd, args )
	Model_Table = {}
	GibSystem_Initialize()
end )

local GibModels = {}

local files, _ = file.Find("autorun/gibbing_system/models/*.lua", "LUA")

for _, filename in ipairs(files) do
	AddCSLuaFile("autorun/gibbing_system/models/" .. filename)
	include("autorun/gibbing_system/models/" .. filename)
	LocalizedText("zh-cn","[碎尸系统] 已加载文件 "..filename:gsub("%.lua$", ""))
	LocalizedText("en","[Gibbing System] Loaded file "..filename:gsub("%.lua$", ""))
	util.PrecacheModel("models/gib_system/"..filename:gsub("%.lua$", "").."_headless.mdl")
	util.PrecacheModel("models/gib_system/"..filename:gsub("%.lua$", "").."_head.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/left_leg.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/right_leg.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/left_arm.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/right_arm.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/torso.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_legs.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_arms.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_right_leg_left_arm.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_left_leg_right_arm.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_left_leg.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_right_leg.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_left_arm.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_arms.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_right_arm.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_right.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_left.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_right_no_arm.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_left_no_arm.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_right_no_leg.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_left_no_leg.mdl")
	util.PrecacheModel("models/gib_system/"..filename:gsub("%.lua$", "").."_legs.mdl")
	util.PrecacheModel("models/gib_system/"..filename:gsub("%.lua$", "").."_torso.mdl")
	table.insert(GibModels, tostring(filename:gsub("%.lua$", "")))
end

LocalizedText("zh-cn","[碎尸系统] 加载完成。\n")
LocalizedText("en","[Gibbing System] Loading Complete.\n")

CreateConVar( "gibsystem_enabled", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable Gib System.")
CreateConVar( "gibsystem_gibbing_player", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable Gib System for Players.")
CreateConVar( "gibsystem_gibbing_npc", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable Gib System for NPCs.")
CreateConVar( "gibsystem_random_finger_rotating", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable random finger rotating.")
CreateConVar( "gibsystem_random_toe_rotating", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable random toe rotating.")
CreateConVar( "gibsystem_random_gf2_toe_rotating", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable random toe(GF2) rotating.")
CreateConVar( "gibsystem_ragdoll_convulsion", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable ragdoll convulsion.")
CreateConVar( "gibsystem_ragdoll_collisiongroup", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Set ragdoll Collision Group.")
CreateConVar( "gibsystem_ragdoll_removetimer", 10 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Set ragdoll remove timer.")
CreateConVar( "gibsystem_deathcam_enable", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable Deathcam.")
CreateConVar( "gibsystem_deathcam_mode", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Deathcam Mode, 0 = Head, 1 = Body.")
CreateConVar( "gibsystem_blood_effect", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable Blood Effect.")
CreateConVar( "gibsystem_blood_time", 5 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Set Blood Effect's Time.")
CreateConVar( "gibsystem_blood_time_body", 30 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Set Blood Effect's Time.")
CreateConVar( "gibsystem_death_express", 1 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable Death Express.")
CreateConVar( "gibsystem_random_bodygroup", 1 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable Random Bodygroup.")
CreateConVar( "gibsystem_random_skin", 1 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable Random Skin.")
CreateConVar( "gibsystem_rope", 1 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable Rope.")
CreateConVar( "gibsystem_rope_strength", 1000 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Rope Strength.")
CreateConVar( "gibsystem_gib_allnpcs", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Gib Manhack/Headcrabs/Antlions.")
CreateConVar( "gibsystem_body_mass", 10 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Body Mass.")
CreateConVar( "gibsystem_head_mass", 20 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Head Mass.")
CreateConVar( "gibsystem_gib_group", "default" , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Set Gib Group.")
CreateConVar( "gibsystem_gib_name", "default" , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Set Gib Name.")
CreateConVar( "gibsystem_experiment", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable Experimental Features.")
CreateConVar( "gibsystem_deathanimation", 1 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable death animations.")

local last_dmgpos = {}
local timers = {}
local GibsCreated = {}

local RagHead = { "platinum", "skadi" }
local UnfinishedModels = { "ifrit", "centaureissi" }
local CompletedModels = { "provence", "sora", "vigna", "platinum", "chen" }
local GibModelGroup = { "provence", "sora", "vigna", "platinum", "chen", "ifrit", "centaureissi" }
local LegsAndTorso = { "chen", "platinum", "ifrit", "provence", "skadi", "sora", "vigna", "lapluma", "angelina", "amiya", "centaureissi" }

local PhysicsBones = {
	"ValveBiped.Bip01_Pelvis",
	"ValveBiped.Bip01_L_Thigh",
	"ValveBiped.Bip01_R_Thigh",
	"ValveBiped.Bip01_L_Calf",
	"ValveBiped.Bip01_R_Calf",
	"ValveBiped.Bip01_L_Foot",
	"ValveBiped.Bip01_R_Foot",
	"ValveBiped.Bip01_Spine",
	"ValveBiped.Bip01_Spine1",
	"ValveBiped.Bip01_Spine2",
	"ValveBiped.Bip01_Spine4",
	"ValveBiped.Bip01_L_UpperArm",
	"ValveBiped.Bip01_R_UpperArm",
	"ValveBiped.Bip01_L_Forearm",
	"ValveBiped.Bip01_R_Forearm",
	"ValveBiped.Bip01_L_Hand",
	"ValveBiped.Bip01_R_Hand",
	"ValveBiped.Bip01_Head1"
}

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

local anims_table = {
	"DIE_Simple_01",
	"DIE_Simple_02",
	"DIE_Simple_03",
	"DIE_Simple_04",
	"DIE_Simple_05",
	"DIE_Simple_06",
	"DIE_Simple_07",
	"DIE_Simple_08",
	"DIE_Simple_09",
	"DIE_Simple_10",
	"DIE_Simple_11",
	"DIE_Simple_12",
	"DIE_Simple_13",
	"DIE_Simple_14",
	"DIE_Simple_15",
	"DIE_Simple_16",
	"DIE_Simple_17",
	"DIE_Simple_18",
	"DIE_Simple_19",
	"DIE_Simple_20",
	"DIE_Simple_21",
	"DIE_Headshot_FFront_01",
	"DIE_Headshot_FFront_02",
	"DIE_Headshot_FFront_03",
	"DIE_Headshot_FFront_04",
	"DIE_Headshot_FFront_05",
	"DIE_FBack_01",
	"DIE_FBack_02",
	"DIE_FBack_03",
	"DIE_FBack_04",
	"DIE_FBack_05",
	"DIE_FBack_06",
	"DIE_Headshot_FBack_01",
	"DIE_Headshot_FBack_02",
	"DIE_Headshot_FBack_03",
	"DIE_Shotgun_FBack_01",
	"DIE_Shotgun_FBack_02",
	"DIE_Shotgun_FFront_01",
	"DIE_Shotgun_FFront_02",
	"DIE_Shotgun_FFront_03",
	"DIE_Shotgun_FFront_04",
	"DIE_Shotgun_FFront_05",
	"DIE_Shotgun_FFront_06",
	"DIE_Shotgun_FFront_07",
	"DIE_Shotgun_FFront_08",
	"DIE_Shotgun_FFront_09",
	"DIE_Shotgun_FLeft_01",
	"DIE_Shotgun_FLeft_02",
	"DIE_Shotgun_FLeft_03",
	"DIE_Shotgun_FFront_01",
	"DAZE_01",
	"SHOTFOOT_01",
	"SHOTFOOT_02",
	"SHOTFOOT_03",
	"SHOVE_Backward_01",
	"SHOVE_Backward_02",
	"SHOVE_Backward_03",
	"SHOVE_Backward_04",
	"SHOVE_Backward_05",
	"SHOVE_Backward_06",
	"SHOVE_Forward_01",
	"SHOVE_Leftward_01",
	"SHOVE_Rightward_01",
	"SHOTHAND_01",
	"SHOTHAND_02",
	"SHOTHAND_03"
}
			
local function RemoveTimers()
    for _, timerid in ipairs(timers) do
        timer.Remove(timerid)
    end
end

local DamageForce = nil
local DamagePosition = nil

hook.Add("EntityTakeDamage", "gibsystem", function(ent, dmginfo)
	if GetConVar( "gibsystem_enabled" ):GetBool() then

		if ent:IsPlayer() then
			DamageForce = dmginfo:GetDamageForce()
			DamagePosition = dmginfo:GetDamagePosition()
		else
			DamageForce = dmginfo:GetDamageForce()
			DamagePosition = dmginfo:GetDamagePosition()
		end
		if (!ent:IsNPC() or dmginfo:GetDamage() < ent:Health()) then return end

		last_dmgpos[ent] = dmginfo:GetDamagePosition()
	end
end)

local anims = nil

hook.Add("OnNPCKilled", "SpawnGibs", function(npc, attacker, dmg)
/*
	local model = Model_Table[math.random(1,#Model_Table)]
	local name = model.name
	MsgN(name)
	
	for _,vtbl in pairs(Model_Table) do
		local model = vtbl[math.random(1,#vtbl)]
			local name = model.name
			MsgN(name)
		for k,v in pairs(vtbl) do
			
			local tbl2 = v[k]
			
			if v ~= nil and v.mdl ~= nil then
				MsgN(v.mdl.." Part: "..v.part)
			end
		end
	end
*/

	if GetConVar( "gibsystem_enabled" ):GetBool() and GetConVar( "gibsystem_gibbing_npc" ):GetBool() then
		if !GetConVar( "gibsystem_gib_allnpcs" ):GetBool() and table.HasValue( BlackListedNPC, npc:GetClass() ) then return end
		if (npc:GetClass() == "npc_bullseye" or npc:GetClass() == "npc_portal_turret_floor") then return end
			
		SafeRemoveEntity(npc)
		npc:EmitSound( "Gib_System.Headshot_Fleshy" )
		if !GetConVar( "gibsystem_experiment" ):GetBool() or !GetConVar( "gibsystem_deathanimation" ):GetBool() then
			CreateGibs(npc)
		else
			
			local anim = anims_table[math.random(1,#anims_table)]
			
			if table.HasValue( GibModels, GetConVar("gibsystem_gib_name"):GetString() ) then
				Model = GetConVar("gibsystem_gib_name"):GetString()
			else
				Model = GibModels[math.random(1, #GibModels)]
			end
			
			local head = nil
			local HeadPos = npc:LookupBone("ValveBiped.Bip01_Head1") or npc:LookupBone("ValveBiped.HC_Body_Bone") or 0
			
			if !table.HasValue(RagHead,Model) then
				head = ents.Create("prop_physics")
				head:SetPos( npc:GetBonePosition(HeadPos) ) 
			else
				head = ents.Create("prop_ragdoll")
				head:SetPos( npc:GetPos() ) 
			end
			
			head:SetAngles( npc:GetAngles() )
			head:SetCollisionGroup(GetConVar( "gibsystem_ragdoll_collisiongroup" ):GetInt())
			head:SetModel("models/gib_system/"..Model.."_head.mdl")
			head:Spawn()
			head:SetOwner( npc )
			head:Activate()
			GibFacePose(head)
			RandomBodyGroup(head)
			table.insert(GibsCreated,head)
			
			for i = 0, head:GetPhysicsObjectCount() - 1 do
				local phys = head:GetPhysicsObjectNum( i )
				
				if GetConVar("gibsystem_head_mass"):GetInt() > 0 then
					phys:SetMass( GetConVar("gibsystem_head_mass"):GetInt()/head:GetPhysicsObjectCount() )
				end
				
				-- phys:ApplyForceCenter( velocity )
				if DamageForce and DamagePosition then
					phys:ApplyForceOffset(DamageForce / (4+head:GetPhysicsObjectCount()), DamagePosition)
				else
					phys:ApplyForceOffset(Vector(0,0,0), Vector(0,0,0))
				end
			end
			
			local DM = ents.Create("prop_dynamic")
		
			DM:SetModel( "models/gib_system/"..Model.."_headless.mdl" )
			DM:SetPos( npc:GetPos() )
			DM:SetAngles( npc:GetAngles() )
			DM:SetCollisionGroup(GetConVar( "gibsystem_ragdoll_collisiongroup" ):GetInt())
			DM:Spawn()
			DM:SetOwner( npc )
			DM:SetName( "DM" )
			DM:ResetSequence( DM:LookupSequence( anim ) )
			print("Sequence Is: "..anim)
			DM:ResetSequenceInfo()
			DM:SetCycle(1) -- Was 0, Set to 1 to make ragdoll looks good.
			RandomBodyGroup(DM)
			BloodEffect(DM,"1","ValveBiped.Bip01_Head1")
			
			--[[
			local DM = ents.Create("prop_gs_deathanim")
			DM.model = "models/gib_system/"..Model.."_headless.mdl"
			DM:SetPos( npc:GetPos() )
			DM:SetAngles( npc:GetAngles() )
			-- DM:SetCollisionGroup(GetConVar( "gibsystem_ragdoll_collisiongroup" ):GetInt())
			-- DM:SetOwner( npc )
			-- DM:SetName( "DM" )
			DM.anim = anim
			DM:Spawn()
			print("Sequence Is: "..anim)
			DM:ResetSequenceInfo()
			DM:SetCycle(1) -- Was 0, Set to 1 to make ragdoll looks good.
			RandomBodyGroup(DM)
			BloodEffect(DM,"1","ValveBiped.Bip01_Head1")
			]]--
			-- print( DM:GetSequenceMovement( DM:LookupSequence( anim ) ) )
			
			--[[
			local timerDuration = DM:SequenceDuration()
			local timerInterval = 0.1 -- 定时器间隔时间（秒）
			local timerCount = timerDuration / timerInterval -- 重复次数
			local timerBodyName = "DMMoveTimer".. DM:EntIndex()
			local value, vector, angle = DM:GetSequenceMovement( DM:LookupSequence( anim ) )
			local speed = DM:GetSequenceGroundSpeed( DM:LookupSequence( anim ) )
			table.insert(timers, timerBodyName)
			timer.Create(timerBodyName, timerInterval, timerCount, function()
				DM:SetPos( DM:GetPos()- (vector/timerDuration) )
			end)
			]]--
			
			timer.Simple(DM:SequenceDuration(), function()
				local ent = DM

				local ragdoll = ents.Create( "prop_ragdoll" )
				ragdoll:SetModel( ent:GetModel() )
				ragdoll:SetPos( ent:GetPos() )
				ragdoll:SetAngles( ent:GetAngles() )
				ragdoll:SetCollisionGroup(GetConVar( "gibsystem_ragdoll_collisiongroup" ):GetInt())
				ragdoll:SetSkin( ent:GetSkin() )
				ragdoll:SetFlexScale( ent:GetFlexScale() )
				for i = 0, ent:GetNumBodyGroups() - 1 do ragdoll:SetBodygroup( i, ent:GetBodygroup( i ) ) end
				for i = 0, ent:GetFlexNum() - 1 do ragdoll:SetFlexWeight( i, ent:GetFlexWeight( i ) ) end
				for i = 0, ent:GetBoneCount() do
					ragdoll:ManipulateBoneScale( i, ent:GetManipulateBoneScale( i ) )
					ragdoll:ManipulateBoneAngles( i, ent:GetManipulateBoneAngles( i ) )
					ragdoll:ManipulateBonePosition( i, ent:GetManipulateBonePosition( i ) )
					ragdoll:ManipulateBoneJiggle( i, ent:GetManipulateBoneJiggle( i ) ) -- Even though we don't know what this does, I am still putting this here.
				end

				ragdoll:Spawn()
				ragdoll:Activate()
				
				for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
					local bone = ragdoll:GetPhysicsObjectNum( i )
					if ( IsValid( bone ) ) then
						local pos, ang = ent:GetBonePosition( ragdoll:TranslatePhysBoneToBone( i ) )
						if ( pos ) then bone:SetPos( pos ) end
						if ( ang ) then bone:SetAngles( ang ) end

						-- bone:ApplyForceOffset( DamageForce / ragdoll:GetPhysicsObjectCount(), DamagePosition )
					end
				end
				
				FingerRotation(ragdoll)
				BloodEffect(ragdoll,"1","ValveBiped.Bip01_Head1",-DM:SequenceDuration())
				table.insert(GibsCreated,ragdoll)
				SafeRemoveEntity(DM)
				ragdoll:CallOnRemove("RemoveHeadTimer",function(ragdoll) timer.Remove( "BloodImpactTimer"..ragdoll:EntIndex() ) end)
			end)
			DM:CallOnRemove("RemoveHeadTimer",function(DM) timer.Remove( "BloodImpactTimer"..DM:EntIndex() ) end)
			
		end
	end
end)

hook.Add("PlayerDeath", "SpawnGibs", function(player, attacker, dmg)
	if GetConVar( "gibsystem_enabled" ):GetBool() and GetConVar( "gibsystem_gibbing_player" ):GetBool() then
		player:EmitSound( "Gib_System.Headshot_Fleshy" )
		if !GetConVar( "gibsystem_experiment" ):GetBool() or !GetConVar( "gibsystem_deathanimation" ):GetBool() then
			CreateGibs(player)
		else
			local anim = anims_table[math.random(1,#anims_table)]

			if table.HasValue( GibModels, GetConVar("gibsystem_gib_name"):GetString() ) then
				Model = GetConVar("gibsystem_gib_name"):GetString()
			else
				Model = GibModels[math.random(1, #GibModels)]
			end
			
			local head = nil
			local HeadPos = player:LookupBone("ValveBiped.Bip01_Head1")
			
			if !table.HasValue(RagHead,Model) then
				head = ents.Create("prop_physics")
				head:SetPos( player:GetBonePosition(HeadPos) ) 
			else
				head = ents.Create("prop_ragdoll")
				head:SetPos( player:GetPos() ) 
			end
			
			head:SetAngles( player:GetAngles() )
			head:SetCollisionGroup(GetConVar( "gibsystem_ragdoll_collisiongroup" ):GetInt())
			head:SetModel("models/gib_system/"..Model.."_head.mdl")
			head:Spawn()
			-- head:SetOwner( player )
			-- Gib:SetName(tostring(ent).."sGibIndex"..Gib:EntIndex())
			head:SetName("headIndex"..head:EntIndex())
			head:Activate()
			GibFacePose(head)
			RandomBodyGroup(head)
			table.insert(GibsCreated,head)
			
			for i = 0, head:GetPhysicsObjectCount() - 1 do
				local phys = head:GetPhysicsObjectNum( i )
				
				if GetConVar("gibsystem_head_mass"):GetInt() > 0 then
					phys:SetMass( GetConVar("gibsystem_head_mass"):GetInt()/head:GetPhysicsObjectCount() )
				end
				
				-- phys:ApplyForceCenter( velocity )
				if DamageForce and DamagePosition then
					phys:ApplyForceOffset(DamageForce / (4+head:GetPhysicsObjectCount()), DamagePosition)
				else
					phys:ApplyForceOffset(Vector(0,0,0), Vector(0,0,0))
				end
			end
			
			local DM = ents.Create("prop_dynamic")
		
			DM:SetModel( "models/gib_system/"..Model.."_headless.mdl" )
			DM:SetPos( player:GetPos() )
			DM:SetAngles( player:GetAngles() )
			DM:Spawn()
			DM:SetOwner( player )
			DM:ResetSequence( DM:LookupSequence( anim ) )
			print("Sequence Is: "..anim)
			DM:ResetSequenceInfo()
			DM:SetCycle(1) -- Was 0, Set to 1 to make ragdoll looks good.
			
			RandomBodyGroup(DM)
			
			BloodEffect(DM,1,"ValveBiped.Bip01_Head1")
			
			player:Spectate(5)
			player:SetObserverMode(OBS_MODE_CHASE)
			
			if GetConVar( "gibsystem_deathcam_mode" ):GetInt() == 0 then
				player:SpectateEntity(head)
			elseif GetConVar( "gibsystem_deathcam_mode" ):GetInt() == 1 then
				player:SpectateEntity(DM)
			end
			
			timer.Simple(DM:SequenceDuration(), function()
			local ent = DM

			local ragdoll = ents.Create( "prop_ragdoll" )
			ragdoll:SetModel( ent:GetModel() )
			ragdoll:SetPos( ent:GetPos() )
			ragdoll:SetAngles( ent:GetAngles() )
			ragdoll:SetCollisionGroup(GetConVar( "gibsystem_ragdoll_collisiongroup" ):GetInt())
			ragdoll:SetSkin( ent:GetSkin() )
			ragdoll:SetFlexScale( ent:GetFlexScale() )
			for i = 0, ent:GetNumBodyGroups() - 1 do ragdoll:SetBodygroup( i, ent:GetBodygroup( i ) ) end
			for i = 0, ent:GetFlexNum() - 1 do ragdoll:SetFlexWeight( i, ent:GetFlexWeight( i ) ) end
			for i = 0, ent:GetBoneCount() do
				ragdoll:ManipulateBoneScale( i, ent:GetManipulateBoneScale( i ) )
				ragdoll:ManipulateBoneAngles( i, ent:GetManipulateBoneAngles( i ) )
				ragdoll:ManipulateBonePosition( i, ent:GetManipulateBonePosition( i ) )
				ragdoll:ManipulateBoneJiggle( i, ent:GetManipulateBoneJiggle( i ) ) -- Even though we don't know what this does, I am still putting this here.
			end

			ragdoll:Spawn()
			ragdoll:Activate()
			
			for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
				local bone = ragdoll:GetPhysicsObjectNum( i )
				if ( IsValid( bone ) ) then
					local pos, ang = ent:GetBonePosition( ragdoll:TranslatePhysBoneToBone( i ) )
					if ( pos ) then bone:SetPos( pos ) end
					if ( ang ) then bone:SetAngles( ang ) end

					-- bone:ApplyForceOffset( DamageForce / ragdoll:GetPhysicsObjectCount(), DamagePosition )
				end
			end
			
			if GetConVar( "gibsystem_deathcam_mode" ):GetInt() == 0 then
				player:SpectateEntity(head)
			elseif GetConVar( "gibsystem_deathcam_mode" ):GetInt() == 1 then
				player:SpectateEntity(ragdoll)
			end
			
			FingerRotation(ragdoll)
			BloodEffect(ragdoll,1,"ValveBiped.Bip01_Head1",-DM:SequenceDuration())
			table.insert(GibsCreated,ragdoll)
			SafeRemoveEntity(DM)
			
			ragdoll:CallOnRemove("RemoveHeadTimer",function(ragdoll) timer.Remove( "BloodImpactTimer"..ragdoll:EntIndex() ) end)
			end)
		DM:CallOnRemove("RemoveHeadTimer",function(DM) timer.Remove( "BloodImpactTimer"..DM:EntIndex() ) end)
		
		end
		
		SafeRemoveEntity(player:GetRagdollEntity())
		if GetConVar( "gibsystem_deathcam_enable" ):GetBool() and (!GetConVar( "gibsystem_experiment" ):GetBool() or !GetConVar( "gibsystem_deathanimation" ):GetBool()) then		
			player:Spectate(5)
			player:SetObserverMode(OBS_MODE_CHASE)
			if GetConVar( "gibsystem_deathcam_mode" ):GetInt() == 0 then
				player:SpectateEntity(head)
			elseif GetConVar( "gibsystem_deathcam_mode" ):GetInt() == 1 then
				player:SpectateEntity(body)
			else
				player:SpectateEntity(body)
			end
		end
	end
end)

function CreateRope(gib1,gib2,gib1phys,gib2phys,vec1,vec2)
	if GetConVar( "gibsystem_rope" ):GetBool() then
		if IsValid(gib1) and IsValid(gib2) then
			local constraint = constraint.Rope(gib1, gib2, gib1:TranslateBoneToPhysBone( gib1:LookupBone( "ValveBiped.Bip01_Head1" ) ), gib2:TranslateBoneToPhysBone( gib2:LookupBone( "ValveBiped.Bip01_Spine4" or "ValveBiped.Bip01_Spine2" or "ValveBiped.Bip01_Spine1" ) ), Vector(0,0,-3), Vector(5,0,0), 10, 0, GetConVar( "gibsystem_rope_strength" ):GetInt(), 2, "cable/redlaser", false)
		else
			LocalizedText("zh-cn","[碎尸系统] 无效实体索引。无法创建绳索。")
			LocalizedText("en","[Gibbing System] Invaild Index. Can't create rope.")
		end
	end
end

function GibFacePose(ent)
	if GetConVar( "gibsystem_death_express" ):GetBool() then
		local mdl = ent:GetModel()
		local num_expressions = ent:GetFlexNum() -- 获取模型的表情数量
		if mdl == "models/gib_system/platinum_head.mdl" then
			local flex = math.random(1,2)
			for i = 0, num_expressions - 1 do
				local name = ent:GetFlexName(i) -- 获取表情的名称
				if flex == 1 then
					if name == "blink" then
						ent:SetFlexWeight(i, 1) -- 将blink表情的权重设置为1
					elseif name == "mouthdisgust" then
						ent:SetFlexWeight(i, 1)
					elseif name == "browssad" then
						ent:SetFlexWeight(i, 1)
					end
				elseif flex == 2 then
					if name == "eyelookup" then
						ent:SetFlexWeight(i, 0.75) -- 将blink表情的权重设置为1
					elseif name == "mouthdisgust" then
						ent:SetFlexWeight(i, 1)
					elseif name == "browssad" then
						ent:SetFlexWeight(i, 1)
					elseif name == "eyesshock" then
						ent:SetFlexWeight(i, math.Rand(0.25,0.75))
					end
				end
			end
		elseif mdl == "models/gib_system/skadi_head.mdl" then
			local flex = math.random(1,2)
			for i = 0, num_expressions - 1 do
				local name = string.lower(ent:GetFlexName(i)) -- 获取表情的名称
				if flex == 1 then
					if name == "blink" then
						ent:SetFlexWeight(i, 1) -- 将blink表情的权重设置为1
					elseif name == "mouthdisgust" then
						ent:SetFlexWeight(i, 1)
					elseif name == "browssad" then
						ent:SetFlexWeight(i, 1)
					end
				elseif flex == 2 then
				
					if name == "eyelookup" then
						ent:SetFlexWeight(i, 0.75) -- 将blink表情的权重设置为1
					elseif name == "mouthsadopen" then
						ent:SetFlexWeight(i, 1)
					elseif name == "browssad" then
						ent:SetFlexWeight(i, 1)
					elseif name == "eyesshocked" then
						ent:SetFlexWeight(i, math.Rand(0.25,0.75))
					end
				end
			end
		elseif mdl == "models/gib_system/skadi_alter_head.mdl" then
			for i = 0, num_expressions - 1 do
				local name = string.lower(ent:GetFlexName(i)) -- 获取表情的名称
				if name == "eyeslookup" then
					ent:SetFlexWeight(i, 1)
				end
			end
		elseif mdl == "models/gib_system/provence_head.mdl" then
			local flex = math.random(1,3)
			for i = 0, num_expressions - 1 do
				local name = string.lower(ent:GetFlexName(i)) -- 获取表情的名称
				if flex == 1 then
					if name == "blink" then
						ent:SetFlexWeight(i, 1)
					elseif name == "mouth corner lower" then
						ent:SetFlexWeight(i, 1)
					elseif name == "mouth corner upper" then
						ent:SetFlexWeight(i, -1)
					elseif name == "mouth smile" then
						ent:SetFlexWeight(i, -1)
					elseif name == "brow sadl" then
						ent:SetFlexWeight(i, 1)
					elseif name == "brow sadr" then
						ent:SetFlexWeight(i, 1)
					end
				elseif flex == 2 then
					if name == "eye scalel" then
						ent:SetFlexWeight(i, 0.5)
					elseif name == "eye scaler" then
						ent:SetFlexWeight(i, 0.5)
					elseif name == "eye upl" then
						ent:SetFlexWeight(i, 0.25)
					elseif name == "eye upr" then
						ent:SetFlexWeight(i, 0.25)
					elseif name == "mouth o" then
						ent:SetFlexWeight(i, 1)
					end
				elseif flex == 3 then
					if name == "mouth a" then
						ent:SetFlexWeight(i, 0.3)
					elseif name == "brow sadr" then
						ent:SetFlexWeight(i, 1)
					elseif name == "brow sadl" then
						ent:SetFlexWeight(i, 1)
					elseif name == "blink" then
						ent:SetFlexWeight(i, 0.6)
					elseif name == "mouth corner lower" then
						ent:SetFlexWeight(i, 1)
					elseif name == "eye upl" then
						ent:SetFlexWeight(i, 0.3)
					elseif name == "eye upr" then
						ent:SetFlexWeight(i, 0.3)
					end
				end
			end
		elseif mdl == "models/gib_system/sora_head.mdl" then
			for i = 0, num_expressions - 1 do
				local name = string.lower(ent:GetFlexName(i)) -- 获取表情的名称
				if name == "blink" then
					ent:SetFlexWeight(i, 1) -- 将blink表情的权重设置为1
				elseif name == "mouth sad" then
					ent:SetFlexWeight(i, 1)
				elseif name == "mouth aah" then
					ent:SetFlexWeight(i, 1)
				elseif name == "teeth up" then
					ent:SetFlexWeight(i, 0.1)
				elseif name == "teeth down" then
					ent:SetFlexWeight(i, 0.1)
				end
			end
		elseif mdl == "models/gib_system/rosmontis_head.mdl" then
			for i = 0, num_expressions - 1 do
				local name = string.lower(ent:GetFlexName(i))
				if name == "eyescryingop" then
					ent:SetFlexWeight(i, 1)
				elseif name == "mouthshockedop" then
					ent:SetFlexWeight(i, 0.3)
				elseif name == "eyebrowsshockedcl" then
					ent:SetFlexWeight(i, 1)
				end
			end
		elseif mdl == "models/gib_system/schwarz_head.mdl" then
			for i = 0, num_expressions - 1 do
				local name = string.lower(ent:GetFlexName(i)) -- 获取表情的名称
				if name == "blink" then
					ent:SetFlexWeight(i, 0.7) -- 将blink表情的权重设置为1
				end
			end
		elseif mdl == "models/gib_system/chen_head.mdl" then
			for i = 0, num_expressions - 1 do
				local name = string.lower(ent:GetFlexName(i))
				if name == "blink" then
					ent:SetFlexWeight(i, math.Rand(0,1))
				elseif name == "hmm" then
					ent:SetFlexWeight(i, 1)
				elseif name == "sad" then
					ent:SetFlexWeight(i, 1)
				end
			end
		elseif mdl == "models/gib_system/lapluma_head.mdl" then
			for i = 0, num_expressions - 1 do
				local name = string.lower(ent:GetFlexName(i))
				if name == "right_inner_raiser" then
					ent:SetFlexWeight(i, 1)
				elseif name == "left_inner_raiser" then
					ent:SetFlexWeight(i, 1)
				elseif name == "right_upper_raiser" then
					ent:SetFlexWeight(i, 1)
				elseif name == "left_upper_raiser" then
					ent:SetFlexWeight(i, 1)
				elseif name == "right_part" then
					ent:SetFlexWeight(i, 1)
				elseif name == "left_part" then
					ent:SetFlexWeight(i, 1)
				elseif name == "right_corner_puller" then
					ent:SetFlexWeight(i, 1)
				elseif name == "left_corner_puller" then
					ent:SetFlexWeight(i, 1)
				elseif name == "right_corner_depressor" then
					ent:SetFlexWeight(i, 1)
				elseif name == "left_corner_depressor" then
					ent:SetFlexWeight(i, 1)
				end
			end
		else
			local num_expressions = ent:GetFlexNum() -- 获取模型的表情数量
			for i = 0, num_expressions - 1 do
				local name = ent:GetFlexName(i) -- 获取表情的名称
				if name == "blink" then
					ent:SetFlexWeight(i, 1) -- 将blink表情的权重设置为1
				end
			end
		end
	end
end

function BloodEffect(ent,Type,AttachmentPoint,BonusTime)
	if GetConVar( "gibsystem_blood_effect" ):GetBool() then
		local AP = ent:LookupAttachment( "forward" )
		if BonusTime == nil then
			BonusTime = 0
		end
		if Type == 1 then
			-- 在 5 秒内重复播放 BloodImpact 粒子效果
			local timerDuration = GetConVar( "gibsystem_blood_time" ):GetInt()+BonusTime -- 定时器持续时间（秒）
			local timerInterval = 0.1 -- 定时器间隔时间（秒）
			local timerCount = timerDuration / timerInterval -- 重复次数
			local timerBodyName = "BloodImpactTimer".. ent:EntIndex()
			
			table.insert(timers, timerBodyName)
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
			end
		elseif Type == 2 and AP != nil then
			local ParticleBody = { "blood_advisor_pierce_spray", "blood_advisor_pierce_spray_b", "blood_advisor_pierce_spray_c" }
			local ParticleBodyIndex = ParticleBody[math.random(1, #ParticleBody)]
			local timerDuration = GetConVar( "gibsystem_blood_time_body" ):GetInt()+BonusTime -- 定时器持续时间（秒）
			local timerInterval = 1 -- 定时器间隔时间（秒）
			local timerCount = timerDuration / timerInterval -- 重复次数
			local timerBodyName = "BloodImpactTimer".. ent:EntIndex()
			
			table.insert(timers, timerBodyName)
			timer.Create(timerBodyName, timerInterval, timerCount, function()
				ParticleEffectAttach( ParticleBodyIndex, 4, ent, AP )
			end)
		else
			local timerDuration = GetConVar( "gibsystem_blood_time" ):GetInt()+BonusTime -- 定时器持续时间（秒）
			local timerInterval = 0.1 -- 定时器间隔时间（秒）
			local timerCount = timerDuration / timerInterval -- 重复次数
			local timerBodyName = "BloodImpactTimer".. ent:EntIndex()
			
			table.insert(timers, timerBodyName)
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
			end
		end
	end
end

function FingerRotation(ent)
	if GetConVar( "gibsystem_random_finger_rotating" ):GetBool() then
		for bonename = 0 , ent:GetBoneCount() do 
				
			if ent:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger1' then
				ent:ManipulateBoneAngles(bonename,Angle(math.Rand(-5,5),-25-math.Rand(0,4),0))   
			elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger11' then
				ent:ManipulateBoneAngles(bonename,Angle(0,-35-math.Rand(0,4),0))    
			elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger12' then
				ent:ManipulateBoneAngles(bonename,Angle(0,-25-math.Rand(0,4),0))
			elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger2' then
				ent:ManipulateBoneAngles(bonename,Angle(math.Rand(-5,5),-26-math.Rand(0,4),0))   
			elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger21' then
				ent:ManipulateBoneAngles(bonename,Angle(0,-35-math.Rand(0,40),0))    
			elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger22' then
				ent:ManipulateBoneAngles(bonename,Angle(0,-25-math.Rand(0,40),0))  
			elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger3' then
				ent:ManipulateBoneAngles(bonename,Angle(math.Rand(-5,5),-25-math.Rand(0,4),0))   
			elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger31' then
				ent:ManipulateBoneAngles(bonename,Angle(0,-35-math.Rand(0,40),0))    
			elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger32' then
				ent:ManipulateBoneAngles(bonename,Angle(0,-25-math.Rand(0,40),0))
			elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger4' then
				ent:ManipulateBoneAngles(bonename,Angle(math.Rand(-5,5),-25-math.Rand(0,30),0))   
			elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger41' then
				ent:ManipulateBoneAngles(bonename,Angle(0,-20-math.Rand(0,20),0))    
			elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger42' then
				ent:ManipulateBoneAngles(bonename,Angle(0,-20-math.Rand(0,3),0))    
			elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger1' then
				ent:ManipulateBoneAngles(bonename,Angle(math.Rand(-5,5),-25-math.Rand(0,4),0))   
			elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger11' then
				ent:ManipulateBoneAngles(bonename,Angle(0,-35-math.Rand(0,4),0))    
			elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger12' then
				ent:ManipulateBoneAngles(bonename,Angle(0,-25-math.Rand(0,4),0))
			elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger2' then
				ent:ManipulateBoneAngles(bonename,Angle(math.Rand(-5,5),-27-math.Rand(0,4),0))   
			elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger21' then
				ent:ManipulateBoneAngles(bonename,Angle(0,-35-math.Rand(0,4),0))    
			elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger22' then
				ent:ManipulateBoneAngles(bonename,Angle(0,-25-math.Rand(0,4),0))  
			elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger3' then
				ent:ManipulateBoneAngles(bonename,Angle(math.Rand(-5,5),-25-math.Rand(0,4),0))   
			elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger31' then
				ent:ManipulateBoneAngles(bonename,Angle(0,-32-math.Rand(0,4),0))    
			elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger32' then
				ent:ManipulateBoneAngles(bonename,Angle(0,-20-math.Rand(0,40),0))
			elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger4' then
				ent:ManipulateBoneAngles(bonename,Angle(math.Rand(-5,5),-20-math.Rand(0,30),0))   
			elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger41' then
				ent:ManipulateBoneAngles(bonename,Angle(0,-25-math.Rand(0,20),0))    
			elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger42' then
				ent:ManipulateBoneAngles(bonename,Angle(0,-25-math.Rand(0,3),0)) 
			elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger0' then
				ent:ManipulateBoneAngles(bonename,Angle(0,10-math.Rand(0,2),0)) 
			elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger0' then
				ent:ManipulateBoneAngles(bonename,Angle(0,10-math.Rand(0,2),0)) 
			end

			if string.find( ent:GetModel():lower(), "ifrit" ) or string.find( ent:GetModel():lower(), "skyfire" ) or string.find( ent:GetModel():lower(), "schwarz_l4d2" ) or string.find( ent:GetModel():lower(), "lapluma" ) or string.find( ent:GetModel():lower(), "rym" ) or string.find( ent:GetModel():lower(), "gavial" ) or string.find( ent:GetModel():lower(), "kiana_sos" ) then
				if ent:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger01' then
			ent:ManipulateBoneAngles(bonename,Angle(0,-20-math.Rand(0,2),0))    
				elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger02' then
			ent:ManipulateBoneAngles(bonename,Angle(0,-25-math.Rand(0,3),0))    
				elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger01' then
			ent:ManipulateBoneAngles(bonename,Angle(0,-20-math.Rand(0,3),0))    
				elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger02' then
			ent:ManipulateBoneAngles(bonename,Angle(0,-25-math.Rand(0,3),0)) 
				end
			else
				if ent:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger01' then
			ent:ManipulateBoneAngles(bonename,Angle(0,20-math.Rand(0,2),0))    
				elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger02' then
			ent:ManipulateBoneAngles(bonename,Angle(0,25-math.Rand(0,3),0))   
				elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger01' then
			ent:ManipulateBoneAngles(bonename,Angle(0,20-math.Rand(0,3),0))    
				elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger02' then
			ent:ManipulateBoneAngles(bonename,Angle(0,25-math.Rand(0,3),0)) 
				end
			end
		end
	end

	if GetConVar("gibsystem_random_toe_rotating"):GetBool() then
		for bonename = 0 , ent:GetBoneCount() do 
			if ent:GetBoneName(bonename)=='ValveBiped.Bip01_L_Toe0' then
				ent:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
			elseif ent:GetBoneName(bonename)=='ValveBiped.Bip01_R_Toe0' then
				ent:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))	
			end
		end
	end

	if GetConVar("gibsystem_random_gf2_toe_rotating"):GetBool() then
		for bonename = 0 , ent:GetBoneCount() do 
			if ent:GetBoneName(bonename)=='BigToe1_L' then
				ent:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
			elseif ent:GetBoneName(bonename)=='BigToe2_L' then
				ent:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
			elseif ent:GetBoneName(bonename)=='BigToe1_R' then
				ent:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
			elseif ent:GetBoneName(bonename)=='BigToe2_R' then
				ent:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
			elseif ent:GetBoneName(bonename)=='LongToe1_L' then
				ent:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
			elseif ent:GetBoneName(bonename)=='LongToe2_L' then
				ent:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
			elseif ent:GetBoneName(bonename)=='LongToe1_R' then
				ent:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
			elseif ent:GetBoneName(bonename)=='LongToe2_R' then
				ent:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
			elseif ent:GetBoneName(bonename)=='MiddleToe1_L' then
				ent:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
			elseif ent:GetBoneName(bonename)=='MiddleToe2_L' then
				ent:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
			elseif ent:GetBoneName(bonename)=='MiddleToe1_R' then
				ent:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
			elseif ent:GetBoneName(bonename)=='MiddleToe2_R' then
				ent:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
			elseif ent:GetBoneName(bonename)=='RingToe1_L' then
				ent:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
			elseif ent:GetBoneName(bonename)=='RingToe2_L' then
				ent:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
			elseif ent:GetBoneName(bonename)=='RingToe1_R' then
				ent:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
			elseif ent:GetBoneName(bonename)=='RingToe2_R' then
				ent:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
			elseif ent:GetBoneName(bonename)=='PinkyToe1_L' then
				ent:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
			elseif ent:GetBoneName(bonename)=='PinkyToe2_L' then
				ent:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
			elseif ent:GetBoneName(bonename)=='PinkyToe1_R' then
				ent:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
			elseif ent:GetBoneName(bonename)=='PinkyToe2_R' then
				ent:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
			end
		end
	end
end
	
function RandomBodyGroup(ent)
	if GetConVar( "gibsystem_random_bodygroup" ):GetBool() then
		local BodygroupBlacklist = { "tail", "ears", "horns", "horn left", "horn right" }
		local num_bodygroups = ent:GetNumBodyGroups() -- 获取模型的bodygroup数量
			
		for i = 0, num_bodygroups - 1 do
			local bodygroup_name = ent:GetBodygroupName(i) -- 获取当前循环的bodygroup名称
				
			if !table.HasValue( BodygroupBlacklist,string.lower(bodygroup_name) ) then
				local num_choices = ent:GetBodygroupCount(i) -- 获取当前bodygroup下的可以选择的模型数量
					
				if num_choices > 1 then
					local choice = math.random(0, num_choices - 1) -- 随机选择一种模型
						
					ent:SetBodygroup(i, choice) -- 设置新的bodygroup值
				end
			end
		end
	end
end

function GibConvulsion(ent)
	if GetConVar( "gibsystem_ragdoll_convulsion" ):GetInt() == 1 then
		ent:Input( "StartRagdollBoogie", ent, ent, "" )
	elseif GetConVar( "gibsystem_ragdoll_convulsion" ):GetInt() == 2 then
		timer.Simple(0, function()
		if !IsValid(ent) then return end	
			fedhoria.StartModule(ent, "stumble_legs", phys_bone, lpos)
			last_dmgpos[ent] = nil		
		end)
	end
end

function CreateGibs(ent)
	local dmgpos = last_dmgpos[ent]
	local phys_bone, lpos

	if dmgpos then
		phys_bone = ent:GetClosestPhysBone(dmgpos)
		if phys_bone then
			local phys = ent:GetPhysicsObjectNum(phys_bone)
			
			lpos = phys:WorldToLocal(dmgpos)
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
		local RagHead = { "models/gib_system/platinum_head.mdl", "models/gib_system/skadi_head.mdl" }
		
		if Bodypart == "head" and !table.HasValue(RagHead,mdl) then
			local HeadPos = ent:LookupBone("ValveBiped.Bip01_Head1")
			
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
		Gib:SetOwner( ent )
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
		
		if Bodypart == "head" then
			local velocity = nil
			local phys = Gib:GetPhysicsObject()
				
			if Gib.Owner:IsPlayer() then
				velocity = Gib.Owner:GetVelocity() * GetConVar( "phys_pushscale" ):GetInt()
				
				if table.HasValue(RagHead,mdl) then
					velocity = Gib.Owner:GetVelocity() * GetConVar( "phys_pushscale" ):GetInt() * GetConVar( "phys_pushscale" ):GetInt()
				else
					velocity = Gib.Owner:GetVelocity() * GetConVar( "phys_pushscale" ):GetInt() * 50 * GetConVar( "phys_pushscale" ):GetInt()
				end
					
			elseif Gib.Owner:IsNPC() then
				velocity = VectorRand() * 50 * GetConVar( "phys_pushscale" ):GetInt() + ent:GetMoveVelocity() + ent:GetGroundSpeedVelocity()
			end
				
			for i = 0, Gib:GetPhysicsObjectCount() - 1 do
				local phys = Gib:GetPhysicsObjectNum( i )
				
				if GetConVar("gibsystem_head_mass"):GetInt() > 0 then
					phys:SetMass( GetConVar("gibsystem_head_mass"):GetInt() )
				end
					
				phys:ApplyForceCenter( velocity )
			end

			head = Entity(Gib:EntIndex())
			
		elseif Bodypart == "body" then

			local velocity = nil
			
			if Gib.Owner:IsPlayer() then
				velocity = Gib.Owner:GetVelocity() * GetConVar( "phys_pushscale" ):GetInt() * 5
					
			elseif Gib.Owner:IsNPC() then
				-- velocity = velocity + VectorRand() * 1000 * GetConVar( "phys_pushscale" ):GetInt()
				if dmgpos != nil then
					velocity = dmgpos * GetConVar( "phys_pushscale" ):GetInt()
				else
					velocity = VectorRand() * 1000 * GetConVar( "phys_pushscale" ):GetInt() + ent:GetMoveVelocity() + ent:GetGroundSpeedVelocity()
				end
					
			end
				
			for i = 0, Gib:GetPhysicsObjectCount() - 1 do
				local phys = Gib:GetPhysicsObjectNum( i )
					
				if GetConVar("gibsystem_body_mass"):GetInt() > 0 then
					phys:SetMass( GetConVar("gibsystem_body_mass"):GetInt() )
				end
				phys:ApplyForceCenter( velocity )
			end
			--[[
			for i = 0, Gib:GetPhysicsObjectCount() - 1 do
				local bone = Gib:GetPhysicsObjectNum( i )
				if ( IsValid( bone ) ) then
					local pos, ang = ent:GetBonePosition( Gib:TranslatePhysBoneToBone( i ) )
					if ( pos ) then bone:SetPos( pos ) end
					if ( ang ) then bone:SetAngles( ang ) end

					bone:ApplyForceOffset( DamageForce / Gib:GetPhysicsObjectCount(), DamagePosition )
					
					if GetConVar("gibsystem_body_mass"):GetInt() > 0 then
						bone:SetMass( GetConVar("gibsystem_body_mass"):GetInt() / Gib:GetPhysicsObjectCount() )
					end
				end
			end
			]]--
			
			body = Entity(Gib:EntIndex())
		end
		
		if GetConVar( "gibsystem_random_skin" ):GetBool() then
			local num_skins = Gib:SkinCount()
			local choice = math.random(0, num_skins - 1)
			
			Gib:SetSkin(choice)
		end
		
		if GetConVar( "gibsystem_ragdoll_removetimer" ):GetInt() > -1 then
			timer.Create( "RemoveTimerHead"..Gib:EntIndex(), GetConVar( "gibsystem_ragdoll_removetimer" ):GetInt(), 1, function()
				if IsValid( Gib ) then
					Gib:Remove()
				end
			end)
		end
		
		table.insert(GibsCreated,Gib)
		Gib:CallOnRemove("RemoveHeadTimer",function(Gib) timer.Remove( "BloodImpactTimer"..Gib:EntIndex() ) end)
		
		if !Gib.Owner:IsPlayer() then return end
		
		cleanup.Add( Gib.Owner, "props", body )
		undo.Create( "Gib" )
		undo.AddEntity( body )
		undo.AddEntity( head )
		undo.SetPlayer( Gib.Owner )
		undo.Finish()
	end
	
	if table.HasValue( GibModelGroup, GetConVar("gibsystem_gib_name"):GetString() ) then
		GibModel = GetConVar("gibsystem_gib_name"):GetString()
	else
		GibModel = GibModelGroup[math.random(1, #GibModelGroup)]
	end
	
	local Conditions = { "headless", "limbs", "no_legs", "no_arms", "no_right_leg_left_arm", "no_left_leg_right_arm", "no_left_leg", "no_right_leg", "no_left_arm", "no_right_arm", "no_right", "no_left", "no_right_no_arm", "no_left_no_arm", "no_right_no_leg", "no_left_no_leg", "legs_&_torso" }
	
	if table.HasValue( Conditions, GetConVar("gibsystem_gib_group"):GetString() ) then
		ConditionGib = GetConVar("gibsystem_gib_group"):GetString()
	else
		ConditionGib = Conditions[math.random(1, #Conditions)]
	end
	
	if table.HasValue( UnfinishedModels, GibModel ) then
		GibModel2 = CompletedModels[math.random(1, #CompletedModels)]
	else
		GibModel2 = GibModel
	end
		
	if table.HasValue( GibModels, GetConVar("gibsystem_gib_name"):GetString() ) then
		Model = GetConVar("gibsystem_gib_name"):GetString()
	else
		Model = GibModels[math.random(1,#GibModels)]
	end
	
	if ConditionGib == "headless" then
	
		if !table.HasValue(RagHead,Model) then
			SpawnGib("physics", "models/gib_system/"..Model.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		else
			SpawnGib("ragdoll", "models/gib_system/"..Model.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		end
		
		SpawnGib("ragdoll", "models/gib_system/"..Model.."_headless.mdl", 1, "ValveBiped.Bip01_Neck1", "body", false, true, true)
		
		CreateRope(head, body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..Model.." | 碎尸组合：无头")
		LocalizedText("en","[Gibbing System] Selected Model: "..Model.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "limbs" then
	
		if !table.HasValue(RagHead,GibModel) then
			SpawnGib("physics", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		else
			SpawnGib("ragdoll", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/torso.mdl", 1, "ValveBiped.bip01_pelvis", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibModel.." | 碎尸组合：碎块")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibModel.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_legs" then
	
		if !table.HasValue(RagHead,GibModel) then
			SpawnGib("physics", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		else
			SpawnGib("ragdoll", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel2.."/no_limb/no_legs.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibModel.." | 碎尸组合：无双腿")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibModel.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_arms" then
	
		if !table.HasValue(RagHead,GibModel) then
			SpawnGib("physics", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		else
			SpawnGib("ragdoll", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel2.."/no_limb/no_arms.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibModel.." | 碎尸组合：无双手")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibModel.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_right_leg_left_arm" then
	
		if !table.HasValue(RagHead,GibModel) then
			SpawnGib("physics", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		else
			SpawnGib("ragdoll", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel2.."/no_limb/no_right_leg_left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibModel.." | 碎尸组合：无右腿左手")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibModel.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_left_leg_right_arm" then
	
		if !table.HasValue(RagHead,GibModel) then
			SpawnGib("physics", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		else
			SpawnGib("ragdoll", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel2.."/no_limb/no_left_leg_right_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibModel.." | 碎尸组合：无左腿右手")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibModel.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_left_leg" then
	
		if !table.HasValue(RagHead,GibModel) then
			SpawnGib("physics", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		else
			SpawnGib("ragdoll", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel2.."/no_limb/no_left_leg.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibModel.." | 碎尸组合：无左腿")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibModel.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_right_leg" then
	
		if !table.HasValue(RagHead,GibModel) then
			SpawnGib("physics", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		else
			SpawnGib("ragdoll", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel2.."/no_limb/no_right_leg.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibModel.." | 碎尸组合：无右腿")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibModel.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_left_arm" then
	
		if !table.HasValue(RagHead,GibModel) then
			SpawnGib("physics", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		else
			SpawnGib("ragdoll", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel2.."/no_limb/no_left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibModel.." | 碎尸组合：无左手")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibModel.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_right_arm" then
	
		if !table.HasValue(RagHead,GibModel) then
			SpawnGib("physics", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		else
			SpawnGib("ragdoll", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel2.."/no_limb/no_right_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibModel.." | 碎尸组合：无右手")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibModel.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_right" then
	
		if !table.HasValue(RagHead,GibModel) then
			SpawnGib("physics", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		else
			SpawnGib("ragdoll", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel2.."/no_limb/no_right.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibModel.." | 碎尸组合：无右半")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibModel.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_left" then
	
		if !table.HasValue(RagHead,GibModel) then
			SpawnGib("physics", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		else
			SpawnGib("ragdoll", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel2.."/no_limb/no_left.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibModel.." | 碎尸组合：无左半")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibModel.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_right_no_arm" then
	
		if !table.HasValue(RagHead,GibModel) then
			SpawnGib("physics", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		else
			SpawnGib("ragdoll", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel2.."/no_limb/no_right_no_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibModel.." | 碎尸组合：无右半无手臂")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibModel.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_left_no_arm" then
	
		if !table.HasValue(RagHead,GibModel) then
			SpawnGib("physics", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		else
			SpawnGib("ragdoll", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel2.."/no_limb/no_left_no_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibModel.." | 碎尸组合：无左半无手臂")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibModel.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_right_no_leg" then
	
		if !table.HasValue(RagHead,GibModel) then
			SpawnGib("physics", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		else
			SpawnGib("ragdoll", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel2.."/no_limb/no_right_no_leg.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibModel.." | 碎尸组合：无右半无腿")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibModel.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "no_left_no_leg" then
	
		if !table.HasValue(RagHead,GibModel) then
			SpawnGib("physics", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		else
			SpawnGib("ragdoll", "models/gib_system/"..GibModel.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..GibModel2.."/no_limb/no_left_no_leg.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..GibModel.." | 碎尸组合：无左半无腿")
		LocalizedText("en","[Gibbing System] Selected Model: "..GibModel.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "legs_&_torso" then

		if table.HasValue( LegsAndTorso, GetConVar("gibsystem_gib_name"):GetString() ) then
			LegsGib = GetConVar("gibsystem_gib_name"):GetString()
		else
			LegsGib = LegsAndTorso[math.random(1, #LegsAndTorso)]
		end

		if !table.HasValue(RagHead,LegsGib) then
			SpawnGib("physics", "models/gib_system/"..LegsGib.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		else
			SpawnGib("ragdoll", "models/gib_system/"..LegsGib.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		end
		
		SpawnGib("ragdoll", "models/gib_system/"..LegsGib.."_torso.mdl", 1, "ValveBiped.Bip01_Spine1", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/"..LegsGib.."_legs.mdl", 1, "ValveBiped.Bip01_Spine1", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..LegsGib.." | 碎尸组合：上/下半身")
		LocalizedText("en","[Gibbing System] Selected Model: "..LegsGib.." | Gib Group : "..ConditionGib)
	
		--CreateRope(torso_full, legs, 0, 0, Vector(0,0,0), Vector(0,0,0))
	end
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
