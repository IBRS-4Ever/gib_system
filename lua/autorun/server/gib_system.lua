
AddCSLuaFile()

include("autorun/gibbing_system/defaultnpcs.lua")
include("autorun/gibbing_system/gf2_models.lua")
include("autorun/gibbing_system/models.lua")

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

local files, _ = file.Find("autorun/gibbing_system/models/*.lua", "LUA")

local LegsAndTorso = {}
local Limbs = {}
local RagHead = { "platinum", "skadi" }

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
		table.insert(LegsAndTorso, Model)
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
	end
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
CreateConVar( "gibsystem_body_mass", 10 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Body Mass.")
CreateConVar( "gibsystem_head_mass", 20 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Head Mass.")
CreateConVar( "gibsystem_gib_group", "default" , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Set Gib Group.")
CreateConVar( "gibsystem_gib_name", "default" , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Set Gib Name.")
CreateConVar( "gibsystem_experiment", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable Experimental Features.")
CreateConVar( "gibsystem_deathanimation", 1 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Enable death animations.")
CreateConVar( "gibsystem_deathanimation_name", "default" , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "[Gib System] Set death animation.")

local last_dmgpos = {}
local timers = {}
local GibsCreated = {}

local UnfinishedModels = { "ifrit", "centaureissi" }
local CompletedModels = { "provence", "sora", "vigna", "platinum", "chen" }
local GibModelGroup = { "provence", "sora", "vigna", "platinum", "chen", "ifrit", "centaureissi" }

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

local DamageForce = Vector(0,0,0)
local DamagePosition = Vector(0,0,0)

--[[
hook.Add( "ScaleNPCDamage", "GSDamageInfoNPC", function( npc, hitgroup, dmginfo )
	DamageForce = dmginfo:GetDamageForce()
	DamagePosition = dmginfo:GetDamagePosition()
	last_dmgpos[npc] = dmginfo:GetDamagePosition()
	
end )

hook.Add( "ScaleNPCDamage", "GSDamageInfoPlayer", function( plr, hitgroup, dmginfo )
	DamageForce = dmginfo:GetDamageForce()
	DamagePosition = dmginfo:GetDamagePosition()
	last_dmgpos[plr] = dmginfo:GetDamagePosition()
	print(DamageForce)
end )
]]--

hook.Add("EntityTakeDamage", "gibsystem", function(ent, dmginfo)
	DamageForce = dmginfo:GetDamageForce()
	DamagePosition = dmginfo:GetDamagePosition()
	last_dmgpos[ent] = dmginfo:GetDamagePosition()
end)

local anims = nil

hook.Add("OnNPCKilled", "SpawnGibs", function(npc, attacker, dmg)
--[[
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
]]--

	if GetConVar( "gibsystem_enabled" ):GetBool() and GetConVar( "gibsystem_gibbing_npc" ):GetBool() and DefaultNPCs[npc:GetClass()] then
			
		SafeRemoveEntity(npc)
		npc:EmitSound( "Gib_System.Headshot_Fleshy" )
		if !GetConVar( "gibsystem_experiment" ):GetBool() or !GetConVar( "gibsystem_deathanimation" ):GetBool() then
			CreateGibs(npc)
		else
			
			if GetConVar("gibsystem_deathanimation_name"):GetString() == "default" then
				anim = anims_table[math.random(1,#anims_table)]
			else
				anim = GetConVar("gibsystem_deathanimation_name"):GetString()
			end
			
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
			RandomSkin(head)
			-- BloodEffect(head,"1","ValveBiped.Bip01_Neck1")
			table.insert(GibsCreated,head)
			
			for i = 0, head:GetPhysicsObjectCount() - 1 do
				local phys = head:GetPhysicsObjectNum( i )
				
				if GetConVar("gibsystem_head_mass"):GetInt() > 0 then
					phys:SetMass( GetConVar("gibsystem_head_mass"):GetInt()/head:GetPhysicsObjectCount() )
				end
				
				-- phys:ApplyForceCenter( velocity )
				if DamageForce and DamagePosition then
					phys:ApplyForceOffset( (DamageForce / head:GetPhysicsObjectCount()) + Vector(0,0,2500), DamagePosition)
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
			RandomSkin(DM)
			BloodEffect(DM,2,"forward")
			-- BloodEffect(DM,"1","ValveBiped.Bip01_Head1")
			
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
				BloodEffect(ragdoll,2,"forward")
				-- BloodEffect(ragdoll,"1","ValveBiped.Bip01_Head1")
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
			if GetConVar("gibsystem_deathanimation_name"):GetString() == "default" then
				anim = anims_table[math.random(1,#anims_table)]
			else
				anim = GetConVar("gibsystem_deathanimation_name"):GetString()
			end

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
			RandomSkin(head)
			-- BloodEffect(head,"1","ValveBiped.Bip01_Neck1")
			table.insert(GibsCreated,head)
			
			for i = 0, head:GetPhysicsObjectCount() - 1 do
				local phys = head:GetPhysicsObjectNum( i )
				
				if GetConVar("gibsystem_head_mass"):GetInt() > 0 then
					phys:SetMass( GetConVar("gibsystem_head_mass"):GetInt()/head:GetPhysicsObjectCount() )
				end
				
				-- phys:ApplyForceCenter( velocity )
				if DamageForce and DamagePosition then
					phys:ApplyForceOffset( (DamageForce / head:GetPhysicsObjectCount()) + Vector(0,0,2500), DamagePosition)
				else
					phys:ApplyForceOffset(Vector(0,0,0), Vector(0,0,0))
				end
			end
			
			local DM = ents.Create("prop_dynamic")
		
			DM:SetModel( "models/gib_system/"..Model.."_headless.mdl" )
			DM:SetPos( player:GetPos() )
			DM:SetAngles( player:GetAngles() )
			DM:Spawn()
			--DM:SetOwner( player )
			DM:ResetSequence( DM:LookupSequence( anim ) )
			print("Sequence Is: "..anim)
			DM:ResetSequenceInfo()
			DM:SetCycle(1) -- Was 0, Set to 1 to make ragdoll looks good.
			
			RandomBodyGroup(DM)
			RandomSkin(DM)
			
			BloodEffect(DM,2,"forward")
			
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
			BloodEffect(ragdoll,2,"forward",DM:SequenceDuration())
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
		local Exp = {}
		local num_expressions = ent:GetFlexNum() -- 获取模型的表情数量
		if Model == "platinum" then
			local flex = math.random(1,2)
			if flex == 1 then
				Exp = {
					["blink"] = math.Rand(0.5,1),
					["mouthdisgust"] = 1,
					["browssad"] = 1
				}
			else
				Exp = {
					["eyelookup"] = 0.75,
					["mouthdisgust"] = 1,
					["browssad"] = 1,
					["eyesshock"] = math.Rand(0,0.5)
				}
			end
			
		elseif Model == "skadi" then
			local flex = math.random(1,2)
			if flex == 1 then
				Exp = {
					["blink"] = math.Rand(0.5,1),
					["mouthdisgust"] = 1,
					["browssad"] = 1
				}
			else
				Exp = {
					["eyelookup"] = 0.75,
					["mouthsadopen"] = 1,
					["browssad"] = 1,
					["eyesshock"] = math.Rand(0.25,0.75)
				}
			end
		elseif Model == "skadi_alter" then
			Exp = { ["eyeslookup"] = 1 }
		elseif Model == "provence" then
			local flex = math.random(1,3)
			local Exp_Value = {}
			if flex == 1 then
				Exp = {
					["blink"] = math.Rand(0.5,1),
					["mouth corner lower"] = 1,
					["mouth corner upper"] = -1,
					["mouth smile"] = -1,
					["brow sadl"] = 1,
					["brow sadr"] = 1
				}
			elseif flex == 2 then
				Exp = {
					["eye scalel"] = 0.5,
					["eye scaler"] = 0.5,
					["eye upl"] = 0.25,
					["eye upr"] = 0.25,
					["mouth o"] = 1
				}
			else
				Exp = {
					["mouth a"] = math.Rand(0.3,0.7),
					["brow sadr"] = 1,
					["brow sadl"] = 1,
					["blink"] = math.Rand(0.5,1),
					["mouth corner lower"] = 1,
					["eye upl"] = 0.3,
					["eye upr"] = 0.3
				}
			end
		elseif Model == "sora" then
			Exp = {
				["blink"] = math.Rand(0.5,1),
				["mouth sad"] = 1,
				["mouth aah"] = 1,
				["teeth up"] = 0.1,
				["teeth down"] = 0.1
			}
		elseif Model == "rosmontis" then
			Exp = {
				["eyescryingop"] = 1,
				["mouthshockedop"] = 0.3,
				["eyebrowsshockedcl"] = 1
			}
		elseif Model == "schwarz" then
			Exp = { ["blink"] = 0.7 }
		elseif Model == "chen" then
			Exp = {
				["blink"] = math.Rand(0.5,1),
				["hmm"] = 1,
				["sad"] = 1
			}
		elseif Model == "lapluma" then
			Exp = {
				["right_inner_raiser"] = 1,
				["left_inner_raiser"] = 1,
				["right_upper_raiser"] = 1,
				["left_upper_raiser"] = 1,
				["right_part"] = 1,
				["left_part"] = 1,
				["right_corner_puller"] = 1,
				["left_corner_puller"] = 1,
				["right_corner_depressor"] = 1,
				["left_corner_depressor"] = 1
			}
		elseif GF2Models[Model] then
			Exp = {
				["eye_blink_left"] = math.Rand(0.5,1),
				["eye_blink_right"] = math.Rand(0.5,1),
				["brows_worry"] = math.Rand(0.5,1),
				["mouth_surprised"] = math.Rand(0.5,1),
				["eyes_look_up"] = math.Rand(0.5,1),
				["mouth_angry_teeth"] = math.Rand(0.25,0.5),
				["mouth_wide_open"] = math.Rand(0.1,0.3)
			}
		else
			Exp = { ["blink"] = math.Rand(0.5,1) }
		end
		-- print(Model,GF2Models[Model])
		-- PrintTable(GF2Models)
		for i = 0, num_expressions - 1 do
			local name = string.lower(ent:GetFlexName(i))
			if Exp[name] != nil then
				ent:SetFlexWeight(i, Exp[name])
			end
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
			
			table.insert(timers, timerBodyName)
			timer.Create(timerBodyName, timerInterval, timerCount, function()
				ParticleEffectAttach( "blood_advisor_pierce_spray", 4, ent, AP )
			end)
		else
			-- print(ent:GetModel().." has no attachment named "..AP.."!")
			local timerDuration = GetConVar( "gibsystem_blood_time" ):GetInt()-BonusTime -- 定时器持续时间（秒）
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
		local Fingers = {
			["ValveBiped.Bip01_L_Finger1"] = Angle(math.Rand(-5,5),-25-math.Rand(0,4),0),
			["ValveBiped.Bip01_L_Finger11"] = Angle(0,-35-math.Rand(0,4),0),
			["ValveBiped.Bip01_L_Finger12"] = Angle(0,-25-math.Rand(0,4),0),
			["ValveBiped.Bip01_L_Finger2"] = Angle(math.Rand(-5,5),-26-math.Rand(0,4),0),
			["ValveBiped.Bip01_L_Finger21"] = Angle(0,-35-math.Rand(0,40),0),
			["ValveBiped.Bip01_L_Finger22"] = Angle(0,-25-math.Rand(0,40),0),
			["ValveBiped.Bip01_L_Finger3"] = Angle(math.Rand(-5,5),-25-math.Rand(0,4),0),
			["ValveBiped.Bip01_L_Finger31"] = Angle(0,-35-math.Rand(0,40),0),
			["ValveBiped.Bip01_L_Finger32"] = Angle(0,-25-math.Rand(0,40),0),
			["ValveBiped.Bip01_L_Finger4"] = Angle(math.Rand(-5,5),-25-math.Rand(0,30),0),
			["ValveBiped.Bip01_L_Finger41"] = Angle(0,-20-math.Rand(0,20),0),
			["ValveBiped.Bip01_L_Finger42"] = Angle(0,-20-math.Rand(0,3),0),
			["ValveBiped.Bip01_L_Finger0"] = Angle(0,10-math.Rand(0,2),0),
			["ValveBiped.Bip01_L_Finger01"] = Angle(0,20-math.Rand(0,2),0),
			["ValveBiped.Bip01_L_Finger02"] = Angle(0,25-math.Rand(0,3),0),
			["ValveBiped.Bip01_R_Finger1"] = Angle(math.Rand(-5,5),-25-math.Rand(0,4),0),
			["ValveBiped.Bip01_R_Finger11"] = Angle(0,-35-math.Rand(0,4),0),
			["ValveBiped.Bip01_R_Finger12"] = Angle(0,-25-math.Rand(0,4),0),
			["ValveBiped.Bip01_R_Finger2"] = Angle(math.Rand(-5,5),-27-math.Rand(0,4),0),
			["ValveBiped.Bip01_R_Finger21"] = Angle(0,-35-math.Rand(0,4),0),
			["ValveBiped.Bip01_R_Finger22"] = Angle(0,-25-math.Rand(0,4),0),
			["ValveBiped.Bip01_R_Finger3"] = Angle(math.Rand(-5,5),-25-math.Rand(0,4),0),
			["ValveBiped.Bip01_R_Finger31"] = Angle(0,-32-math.Rand(0,4),0),
			["ValveBiped.Bip01_R_Finger32"] = Angle(0,-20-math.Rand(0,40),0),
			["ValveBiped.Bip01_R_Finger4"] = Angle(math.Rand(-5,5),-25-math.Rand(0,30),0),
			["ValveBiped.Bip01_R_Finger41"] = Angle(0,-25-math.Rand(0,20),0),
			["ValveBiped.Bip01_R_Finger42"] = Angle(0,-25-math.Rand(0,3),0),
			["ValveBiped.Bip01_R_Finger0"] = Angle(0,10-math.Rand(0,2),0),
			["ValveBiped.Bip01_R_Finger01"] = Angle(0,20-math.Rand(0,2),0),
			["ValveBiped.Bip01_R_Finger02"] = Angle(0,25-math.Rand(0,3),0)
		}
		for bonename = 0 , ent:GetBoneCount() do 
			if Fingers[ent:GetBoneName(bonename)] != nil then
				ent:ManipulateBoneAngles(bonename,Fingers[ent:GetBoneName(bonename)])
			end
		end
	end

	if GetConVar("gibsystem_random_toe_rotating"):GetBool() then
		local Toes_Bones = { 
			["ValveBiped.Bip01_L_Toe0"] = true,
			["ValveBiped.Bip01_R_Toe0"] = true
		}
		for bonename = 0 , ent:GetBoneCount() do 
			if Toes_Bones[ ent:GetBoneName(bonename) ] then
				ent:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
			end
		end
	end

	if GetConVar("gibsystem_random_gf2_toe_rotating"):GetBool() then
		local GF2_Toes_Bones = { 
			["BigToe1_L"] = true,
			["BigToe2_L"] = true,
			["BigToe1_R"] = true,
			["BigToe2_R"] = true,
			["LongToe1_L"] = true,
			["LongToe2_L"] = true,
			["LongToe1_R"] = true,
			["LongToe2_R"] = true,
			["MiddleToe1_L"] = true,
			["MiddleToe2_L"] = true,
			["MiddleToe1_R"] = true,
			["MiddleToe2_R"] = true,
			["RingToe1_L"] = true,
			["RingToe2_L"] = true,
			["RingToe1_R"] = true,
			["RingToe2_R"] = true,
			["PinkyToe1_L"] = true,
			["PinkyToe2_L"] = true,
			["PinkyToe1_R"] = true,
			["PinkyToe2_R"] = true
		}
		for bonename = 0 , ent:GetBoneCount() do 
			if GF2_Toes_Bones[ ent:GetBoneName(bonename) ] then
				ent:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
			end
		end
	end
end
	
function RandomBodyGroup(ent)
	if GetConVar( "gibsystem_random_bodygroup" ):GetBool() then
		local BodygroupBlacklist = { "tail", "ears", "horns", "horn left", "horn right" }
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
					
				phys:ApplyForceOffset( (DamageForce / Gib:GetPhysicsObjectCount()) + Vector(0,0,2500), DamagePosition)
				-- phys:ApplyForceOffset( DamageForce / Gib:GetPhysicsObjectCount(), DamagePosition )
			end

			head = Entity(Gib:EntIndex())

		elseif Bodypart == "body" then

			for i = 0, Gib:GetPhysicsObjectCount() - 1 do
				local phys = Gib:GetPhysicsObjectNum( i )
					
				if GetConVar("gibsystem_body_mass"):GetInt() > 0 then
					phys:SetMass( GetConVar("gibsystem_body_mass"):GetInt() / Gib:GetPhysicsObjectCount() )
				end
				phys:ApplyForceOffset( DamageForce / Gib:GetPhysicsObjectCount(), DamagePosition )
			end
			
			body = Entity(Gib:EntIndex())

		end
		
		if GetConVar( "gibsystem_ragdoll_removetimer" ):GetInt() > -1 then
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
	
	local Conditions = { "headless", "limbs", "no_legs", "no_arms", "no_right_leg_left_arm", "no_left_leg_right_arm", "no_left_leg", "no_right_leg", "no_left_arm", "no_right_arm", "no_right", "no_left", "no_right_no_arm", "no_left_no_arm", "no_right_no_leg", "no_left_no_leg", "legs_&_torso", "halves" }
	
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
		
		SpawnGib("ragdoll", "models/gib_system/"..Model.."_headless.mdl", 2, "forward", "body", false, true, true)
		
		CreateRope(head, body)
		
		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..Model.." | 碎尸组合：无头")
		LocalizedText("en","[Gibbing System] Selected Model: "..Model.." | Gib Group : "..ConditionGib)
	
	elseif ConditionGib == "limbs" then
		
		if table.HasValue( Limbs, GetConVar("gibsystem_gib_name"):GetString() ) then
			Model = GetConVar("gibsystem_gib_name"):GetString()
		else
			Model = Limbs[math.random(1, #Limbs)]
		end

		if !table.HasValue(RagHead,Model) then
			SpawnGib("physics", "models/gib_system/"..Model.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		else
			SpawnGib("ragdoll", "models/gib_system/"..Model.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		end
		
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/left_leg.mdl", 1, "ValveBiped.Bip01_L_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/right_leg.mdl", 1, "ValveBiped.Bip01_R_Thigh", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/left_arm.mdl", 1, "ValveBiped.Bip01_L_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/right_arm.mdl", 1, "ValveBiped.Bip01_R_UpperArm", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/limbs/"..Model.."/torso.mdl", 1, "ValveBiped.bip01_pelvis", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..Model.." | 碎尸组合：碎块")
		LocalizedText("en","[Gibbing System] Selected Model: "..Model.." | Gib Group : "..ConditionGib)
	
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
			Model = GetConVar("gibsystem_gib_name"):GetString()
		else
			Model = LegsAndTorso[math.random(1, #LegsAndTorso)]
		end
		
		if !table.HasValue(RagHead,Model) then
			SpawnGib("physics", "models/gib_system/"..Model.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		else
			SpawnGib("ragdoll", "models/gib_system/"..Model.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		end
		
		SpawnGib("ragdoll", "models/gib_system/"..Model.."_torso.mdl", 1, "ValveBiped.Bip01_Spine1", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/"..Model.."_legs.mdl", 1, "ValveBiped.Bip01_Spine1", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..Model.." | 碎尸组合：上/下半身")
		LocalizedText("en","[Gibbing System] Selected Model: "..Model.." | Gib Group : "..ConditionGib)
		
	elseif ConditionGib == "halves" then

		if !table.HasValue(RagHead,Model) then
			SpawnGib("physics", "models/gib_system/"..Model.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		else
			SpawnGib("ragdoll", "models/gib_system/"..Model.."_head.mdl", 1, "ValveBiped.Bip01_Head1", "head", true, false, false)
		end
		
		SpawnGib("ragdoll", "models/gib_system/"..Model.."_half_left.mdl", 2, "forward", "body", false, true, true)
		SpawnGib("ragdoll", "models/gib_system/"..Model.."_half_right.mdl", 2, "forward", "body", false, true, true)

		LocalizedText("zh-cn","[碎尸系统] 已选中模型："..Model.." | 碎尸组合：左右半身")
		LocalizedText("en","[Gibbing System] Selected Model: "..Model.." | Gib Group : "..ConditionGib)
	end
	-- DamageForce = nil
	-- DamagePosition = nil
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
