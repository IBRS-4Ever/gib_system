
AddCSLuaFile()

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
	"DIE_Simple_22",
	"shove_backward_01",
	"shove_backward_02",
	"shove_backward_03",
	"shove_backward_04",
	"shove_backward_05",
	"shove_backward_06",
	"shove_backward_07",
	"shove_backward_08",
	"shove_backward_09",
	"shove_backward_10",
	"shove_forward_01",
	"shove_leftward_01",
	"shove_rightward_01",
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
	"DAZE_01",
	"SHOTFOOT_01",
	"SHOTFOOT_02",
	"SHOTFOOT_03",
	"SHOTHAND_01",
	"SHOTHAND_02",
	"SHOTHAND_03",
	"FIRE_01",
	"FIRE_02",
	"FIRE_03",
	"FIRE_04"
}

local Ragdolls = {}

local PhysBones = {
	["ValveBiped.Bip01_Pelvis"] 	= true,
	["ValveBiped.Bip01_Spine1"] 	= true,
	["ValveBiped.Bip01_Spine2"] 	= true,
	["ValveBiped.Bip01_Spine4"] 	= true,
	["ValveBiped.Bip01_R_Thigh"] 	= true,
	["ValveBiped.Bip01_R_Calf"] 	= true,
	["ValveBiped.Bip01_R_Foot"] 	= true,
	--["ValveBiped.Bip01_R_Toe0"] 	= true,
	["ValveBiped.Bip01_L_Thigh"] 	= true,
	["ValveBiped.Bip01_L_Calf"] 	= true,
	["ValveBiped.Bip01_L_Foot"] 	= true,
	--["ValveBiped.Bip01_L_Toe0"] 	= true,
	["ValveBiped.Bip01_R_Clavicle"] = true,
	["ValveBiped.Bip01_R_UpperArm"] = true,
	["ValveBiped.Bip01_R_Forearm"] 	= true,
	["ValveBiped.Bip01_R_Hand"] 	= true,
	["ValveBiped.Bip01_L_Clavicle"] = true,
	["ValveBiped.Bip01_L_UpperArm"] = true,
	["ValveBiped.Bip01_L_Forearm"] 	= true,
	["ValveBiped.Bip01_L_Hand"] 	= true
}

local CSC = {		
	secondstoarrive = 0.01,
	pos = Vector(0, 0, 0),
	angle = Angle(0, 0, 0),
	maxangular = 400,
	maxangulardamp = 200,
	maxspeed = 400,
	maxspeeddamp = 300,
	teleportdistance = 0
}

function GibSystem_DeathAnimation_Think(ragdoll)
	if !IsValid(ragdoll.DM) or !IsValid(ragdoll) then return end
	local Phys = {}
	local AnmPos = ragdoll.DM:GetPos()
	local RagPos = ragdoll.DM:GetBonePosition(0)

	if RagPos and ragdoll.DM:GetModel() != "models/enhanced_death_animation/model_anim_modify.mdl" then
		RagPos.z = AnmPos.z
		ragdoll.DM:SetPos( RagPos )
	end
--[[ 
	if IsValid(ragdoll.Bullseye) then ragdoll.Bullseye:SetPos(ragdoll:GetBonePosition(ragdoll:LookupBone("ValveBiped.Bip01_Spine2"))) end
	for id, ent in pairs( ents.FindInSphere( AnmPos, 256 ) ) do
		if !IsValid(ragdoll.Bullseye) then return end
		if !IsValid(ent) or !ent:IsNPC() then continue end
		ragdoll.Bullseye:AddEntityRelationship(ent,D_HT,99)
		ent:AddEntityRelationship(ragdoll.Bullseye,D_HT,99)
		print(ragdoll.Bullseye:Health())
	end
 ]]
	for i = 0, ragdoll.DM:GetBoneCount() - 1 do
		local Bone_name = ragdoll.DM:GetBoneName(i)
		local pos, ang = ragdoll.DM:GetBonePosition(i)
		if PhysBones[Bone_name] then
			Phys[Bone_name] = { Position = pos, Angle = ang }
		end
	end

	for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
		local phys = ragdoll:GetPhysicsObjectNum( i )
		local Bone_name = ragdoll:GetBoneName(ragdoll:TranslatePhysBoneToBone( i ))
		
		if Phys[Bone_name] then
			CSC.pos = Phys[Bone_name].Position
			CSC.angle = Phys[Bone_name].Angle

			phys:Wake()
			phys:ComputeShadowControl(CSC)
		end
	end
end

function RagdollTimer(Ragdoll)
	timer.Simple(Ragdoll.DM:SequenceDuration(Ragdoll.DM:LookupSequence(Ragdoll.DM.Anim)), function()
		if IsValid(Ragdoll.DM) then
			if IsValid(Ragdoll.Bullseye) then SafeRemoveEntity(Ragdoll.Bullseye) end
			SafeRemoveEntity(Ragdoll.DM)
			if !Ragdoll.IsConvulsing then
				GibConvulsion(Ragdoll)
				Ragdoll.IsConvulsing = true
			end
		end
		table.RemoveByValue(GibsCreated,Ragdoll.DM)
	end)
end

function CreateDeathAnimationGib(ent)

	GibGetModel(ent)
		
	local head = nil
	local HeadPos = ent:LookupBone("ValveBiped.Bip01_Head1") or ent:LookupBone("ValveBiped.HC_Body_Bone") or ent:LookupBone("ValveBiped.Headcrab_Cube1") or 0
		
	if (util.IsValidRagdoll( "models/gib_system/"..GibCharacter.."_head.mdl" )) then
		head = ents.Create("prop_ragdoll")
		head:SetPos( ent:GetPos() ) 
		head.UsesRealisticBlood = true
	elseif (util.IsValidProp( "models/gib_system/"..GibCharacter.."_head.mdl" )) then
		head = ents.Create("prop_physics")
		head:SetPos( ent:GetBonePosition(HeadPos) ) 
	end

	head:SetAngles( ent:GetAngles() )
	head:SetCollisionGroup(GetConVar( "gibsystem_ragdoll_collisiongroup" ):GetInt())
	head:SetModel("models/gib_system/"..GibCharacter.."_head.mdl")
	head:Spawn()
	head:SetName("headIndex"..head:EntIndex())
	head:Activate()
	head.BodyPart = "head"
	head.isgib = true
	head.GibHealth = GetConVar("gibsystem_head_health"):GetInt()
	head.Model = GibCharacter
	BloodEffect(head,1,"ValveBiped.Bip01_Head1")
	GibFacePose(head)
	RandomBodyGroup(head)
	RandomSkin(head)
	table.insert(GibsCreated,head)
	
	for i = 0, head:GetPhysicsObjectCount() - 1 do
		local phys = head:GetPhysicsObjectNum( i )
		
		if GetConVar("gibsystem_head_mass"):GetBool() then phys:SetMass( GetConVar("gibsystem_head_mass"):GetInt()/head:GetPhysicsObjectCount() ) end
		if EntDamageInfo[ent] then
			if ent:IsPlayer() then phys:ApplyForceCenter( (EntDamageInfo[ent].Force / head:GetPhysicsObjectCount()) + phys:GetMass() * ent:GetVelocity() * 39.37 * engine.TickInterval() ) end
			if ent:IsNPC() then phys:ApplyForceCenter( (EntDamageInfo[ent].Force / head:GetPhysicsObjectCount()) + (phys:GetMass() * ent:GetMoveVelocity() * 39.37 * engine.TickInterval()) ) end
		else
			phys:ApplyForceCenter( (phys:GetMass() * ent:GetVelocity() * 39.37 * engine.TickInterval()) )
		end
	end
		
	local DM = ents.Create("prop_dynamic")
	if GetConVar("gibsystem_deathanimation_name"):GetString() == "random" then
		anim = anims_table[math.random(1,#anims_table)]
	else
		anim = GetConVar("gibsystem_deathanimation_name"):GetString()
	end
	if GetConVar("gibsystem_deathanimation_alt"):GetBool() then
		DM:SetModel( "models/enhanced_death_animation/model_anim_modify.mdl" )
		if GetConVar("gibsystem_deathanimation_name"):GetString() == "random" then
			if EntDamageInfo[ent] and (bit.band(EntDamageInfo[ent].Type, bit.bor(DMG_BLAST)) == DMG_BLAST) then
				print("Is Explo")
				DM.Anim = "deathexplosion_0"..math.random(1,8)
			else
				DM.Anim = DM:GetSequenceName(math.random(0,DM:GetSequenceCount()-1))
			end
		else
			DM.Anim = anim
		end
	else
		DM:SetModel( "models/gib_system/"..GibCharacter.."_headless.mdl" )
		DM.Anim = anim
		RandomBodyGroup(DM)
		RandomSkin(DM)
	end
	DM:SetPos( ent:GetPos() )
	DM:SetAngles( ent:GetAngles() )
	DM:Spawn()
	DM:Fire("SetAnimation", DM.Anim)
	--DM:SetBodygroup(0,1)
	DM:SetNoDraw( true )
	DM:SetCollisionGroup(1)
	LocalizedText("zh-cn","[碎尸系统] 角色："..GibCharacter.." 动作："..DM.Anim)
	LocalizedText("en","[Gibbing System] Character: "..GibCharacter.." Sequence: "..DM.Anim)
	table.insert(GibsCreated,DM)
	
	local ragdoll = ents.Create( "prop_ragdoll" )
	if GetConVar("gibsystem_deathanimation_alt"):GetBool() then
		ragdoll:SetModel( "models/gib_system/"..GibCharacter.."_headless.mdl" )
	else
		ragdoll:SetModel( DM:GetModel() )
	end
	--ragdoll:SetModel( "models/gib_system/"..GibCharacter.."_legs.mdl" )
	ragdoll:SetPos( DM:GetPos() )
	ragdoll:SetAngles( DM:GetAngles() )
	ragdoll:SetCollisionGroup(GetConVar( "gibsystem_ragdoll_collisiongroup" ):GetInt())
	ragdoll:SetSkin( DM:GetSkin() )
	ragdoll.isgib = true
	ragdoll.GibHealth = GetConVar("gibsystem_body_health"):GetInt()
	ragdoll.RagHealth = ragdoll.GibHealth / 2
	ragdoll.Next = CurTime() + 0.1
	ragdoll.DM = DM
	ragdoll:Spawn()
	ragdoll:Activate()
	ragdoll.Model = GibCharacter
	ragdoll.UsesRealisticBlood = true
	--[[ 
	local Bullseye = ents.Create( "npc_bullseye" )
	Bullseye:SetModel( "models/editor/cube_small.mdl" )
	Bullseye:SetModelScale(2.2)
	Bullseye:SetHullType ( HULL_HUMAN )
	--Bullseye:SetHullSizeNormal()
	Bullseye:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	--Bullseye:SetNoDraw(true)
	Bullseye:SetHealth(ragdoll.RagHealth)
	Bullseye:SetPos(ragdoll:GetBonePosition(ragdoll:LookupBone("ValveBiped.Bip01_Spine2")))
	Bullseye:Spawn()
	Bullseye:Activate()
	ragdoll.Bullseye = Bullseye
 ]]
	if GetConVar("gibsystem_deathanimation_alt"):GetBool() then
		RandomBodyGroup(ragdoll)
		RandomSkin(ragdoll) 
	else
		for i = 0, DM:GetNumBodyGroups() - 1 do ragdoll:SetBodygroup( i, DM:GetBodygroup( i ) ) end
		for i = 0, DM:GetFlexNum() - 1 do ragdoll:SetFlexWeight( i, DM:GetFlexWeight( i ) ) end
		for i = 0, DM:GetBoneCount() do
			ragdoll:ManipulateBoneScale( i, DM:GetManipulateBoneScale( i ) )
			ragdoll:ManipulateBoneAngles( i, DM:GetManipulateBoneAngles( i ) )
			ragdoll:ManipulateBonePosition( i, DM:GetManipulateBonePosition( i ) )
		end
	end

	if ent:LookupAttachment('eyes') > 0 then
		local eye_height = ent:GetAttachment(ent:LookupAttachment('eyes')).Pos.z
		local npc_origin = ent:GetPos().z
		ragdoll.BodyHeight = math.abs(eye_height-npc_origin)
		if ragdoll.BodyHeight then
			local scale = ragdoll.BodyHeight/67.01953125
			ragdoll.DM:SetModelScale(scale, 0)
		end
	end

	BloodEffect(ragdoll,2,"forward")
	FingerRotation(ragdoll)
	table.insert(GibsCreated,ragdoll)
	CreateRope(head, ragdoll)
	table.insert(Ragdolls, ragdoll)
	RagdollTimer(ragdoll)
	BodyPee(ragdoll)

	if ent:IsPlayer() then
		net.Start("GibSystem_StartDeathCam")
			net.WriteInt(head:EntIndex(), 32)
			net.WriteInt(ragdoll:EntIndex(), 32)
		net.Broadcast()
	end

	if GetConVar( "gibsystem_ragdoll_removetimer" ):GetBool() then
		timer.Simple( GetConVar( "gibsystem_ragdoll_removetimer" ):GetInt(), function()
			if IsValid( head ) then head:Remove() end
			if IsValid( ragdoll ) then ragdoll:Remove() end
			if IsValid( DM ) then DM:Remove() end
			--if IsValid( Bullseye ) then Bullseye:Remove() end
			table.RemoveByValue(GibsCreated,head)
			table.RemoveByValue(GibsCreated,ragdoll)
			table.RemoveByValue(GibsCreated,DM)
		end)
	end
end

hook.Add( "EntityTakeDamage", "GibSystem_DeathAnimation_Ragdoll_DMG_Check", function( target, dmginfo )
	for k, Rag in pairs(Ragdolls) do
		if target == Rag and dmginfo:GetAttacker() != head and dmginfo:GetAttacker() != Rag then
			Rag.RagHealth = math.Clamp(Rag.RagHealth - dmginfo:GetDamage(), 0, Rag.RagHealth)
			if Rag.RagHealth <= 0 then
				SafeRemoveEntity(Rag.DM)
				table.RemoveByValue(GibsCreated,Rag.DM)
				if !Rag.IsConvulsing then
					GibConvulsion(Rag)
					Rag.IsConvulsing = true
				end
				return
			end
		end
	end
end)

hook.Add( "Tick", "GibSystem_DeathAnimation_Think", function() 
	if not Ragdolls then return end
	for k, Rag in pairs(Ragdolls) do
		GibSystem_DeathAnimation_Think(Rag)
	end
end)