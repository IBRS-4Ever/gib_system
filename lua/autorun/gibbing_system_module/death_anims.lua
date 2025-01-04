
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
	"shove_backward_10",
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
	"SHOTHAND_03",
	"FIRE_01",
	"FIRE_02",
	"FIRE_03",
	"FIRE_04"
}

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

function GibSystem_DeathAnimation_Think(ragdoll,DM)
	if !IsValid(DM) or !IsValid(ragdoll) then return end

	local AnmPos = DM:GetPos()
	local RagPos = ragdoll:GetBonePosition(0)
	
	if (RagPos) and (GetConVar("gibsystem_deathanimation_movement"):GetBool()) then
		RagPos.z = AnmPos.z
		DM:SetPos( RagPos )
	end

	for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
		local phys = ragdoll:GetPhysicsObjectNum( i )
		local Bone_name = ragdoll:GetBoneName(ragdoll:TranslatePhysBoneToBone( i ))
		if PhysBones[Bone_name] then
			local pos, ang = DM:GetBonePosition( DM:LookupBone(Bone_name) )
			if ( pos ) then phys:SetPos( pos ) end
			if ( ang ) then phys:SetAngles( ang ) end
		end
	end
end

function CreateDeathAnimationGib(ent)
	if GetConVar("gibsystem_deathanimation_name"):GetString() == "random" then
		anim = anims_table[math.random(1,#anims_table)]
	else
		anim = GetConVar("gibsystem_deathanimation_name"):GetString()
	end
	
	GibGetModel(ent)
		
	local head = nil
	local HeadPos = ent:LookupBone("ValveBiped.Bip01_Head1") or ent:LookupBone("ValveBiped.HC_Body_Bone") or ent:LookupBone("ValveBiped.Headcrab_Cube1") or 0
		
	if (util.IsValidRagdoll( "models/gib_system/"..Model.."_head.mdl" )) then
		head = ents.Create("prop_ragdoll")
		head:SetPos( ent:GetPos() ) 
	elseif (util.IsValidProp( "models/gib_system/"..Model.."_head.mdl" )) then
		head = ents.Create("prop_physics")
		head:SetPos( ent:GetBonePosition(HeadPos) ) 
	end

	head:SetAngles( ent:GetAngles() )
	head:SetCollisionGroup(GetConVar( "gibsystem_ragdoll_collisiongroup" ):GetInt())
	head:SetModel("models/gib_system/"..Model.."_head.mdl")
	head:Spawn()
	head:SetName("headIndex"..head:EntIndex())
	head:Activate()
	BloodEffect(head,1,"ValveBiped.Bip01_Head1")
	GibFacePose(head)
	RandomBodyGroup(head)
	RandomSkin(head)
	table.insert(GibsCreated,head)
	
	for i = 0, head:GetPhysicsObjectCount() - 1 do
		local phys = head:GetPhysicsObjectNum( i )
		
		if GetConVar("gibsystem_head_mass"):GetBool() then phys:SetMass( GetConVar("gibsystem_head_mass"):GetInt()/head:GetPhysicsObjectCount() ) end
		if EntDamageForce[ent] then
			if ent:IsPlayer() then phys:ApplyForceCenter( (EntDamageForce[ent] / head:GetPhysicsObjectCount()) + phys:GetMass() * ent:GetVelocity() * 39.37 * engine.TickInterval() ) end
			if ent:IsNPC() then phys:ApplyForceCenter( (EntDamageForce[ent] / head:GetPhysicsObjectCount()) + (phys:GetMass() * ent:GetMoveVelocity() * 39.37 * engine.TickInterval()) ) end
		else
			phys:ApplyForceCenter( (phys:GetMass() * ent:GetVelocity() * 39.37 * engine.TickInterval()) )
		end
	end
		
	local DM = ents.Create("prop_dynamic")
	DM:SetModel( "models/gib_system/"..Model.."_headless.mdl" )
	DM:SetPos( ent:GetPos() )
	DM:SetAngles( ent:GetAngles() )
	DM:Spawn()
	DM:Fire("SetAnimation", anim)
	DM:SetNoDraw(!GetConVar("gibsystem_deathanimation_hide_ragdoll"):GetBool())
	DM:SetCollisionGroup(1)
	LocalizedText("zh-cn","[碎尸系统] 动作："..anim)
	LocalizedText("en","[Gibbing System] Sequence Is: "..anim)
	print()
	RandomBodyGroup(DM)
	RandomSkin(DM)
	table.insert(GibsCreated,DM)
	
	local ragdoll = ents.Create( "prop_ragdoll" )
	ragdoll:SetModel( DM:GetModel() )
	-- ragdoll:SetModel( "models/gib_system/"..Model.."_legs.mdl" )
	ragdoll:SetPos( DM:GetPos() )
	ragdoll:SetAngles( DM:GetAngles() )
	ragdoll:SetCollisionGroup(GetConVar( "gibsystem_ragdoll_collisiongroup" ):GetInt())
	ragdoll:SetSkin( DM:GetSkin() )
	ragdoll.RagHealth = GetConVar("gibsystem_deathanimation_body_health"):GetInt()
	for i = 0, DM:GetNumBodyGroups() - 1 do ragdoll:SetBodygroup( i, DM:GetBodygroup( i ) ) end
	for i = 0, DM:GetFlexNum() - 1 do ragdoll:SetFlexWeight( i, DM:GetFlexWeight( i ) ) end
	for i = 0, DM:GetBoneCount() do
		ragdoll:ManipulateBoneScale( i, DM:GetManipulateBoneScale( i ) )
		ragdoll:ManipulateBoneAngles( i, DM:GetManipulateBoneAngles( i ) )
		ragdoll:ManipulateBonePosition( i, DM:GetManipulateBonePosition( i ) )
	end
	ragdoll:Spawn()
	ragdoll:Activate()
	ragdoll:SetNoDraw(GetConVar("gibsystem_deathanimation_hide_ragdoll"):GetBool())
	ragdoll.Model = Model
	
	for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
		local bone = ragdoll:GetPhysicsObjectNum( i )
		if ( IsValid( bone ) ) then 
			local PhysToBone = ragdoll:TranslatePhysBoneToBone( i )
			if PhysBones[ragdoll:GetBoneName(PhysToBone)] then
				bone:EnableCollisions(false)
			end
		end
	end

	BloodEffect(ragdoll,2,"forward")
	FingerRotation(ragdoll)
	table.insert(GibsCreated,ragdoll)
	CreateRope(head, ragdoll)

	if ent:IsPlayer() then
		ent:Spectate(5)
		ent:SetObserverMode(OBS_MODE_CHASE)
		if GetConVar( "gibsystem_deathcam_mode" ):GetInt() == 0 then
			ent:SpectateEntity(head)
		elseif GetConVar( "gibsystem_deathcam_mode" ):GetInt() == 1 then
			ent:SpectateEntity(ragdoll)
		end
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
		end)
	end

	local RagdollIndex = ragdoll:EntIndex()
	hook.Add( "EntityTakeDamage", "GibSystem_DeathAnimation_Ragdoll_DMG_Check"..RagdollIndex, function( target, dmginfo )
		if target == ragdoll and dmginfo:GetAttacker() != head then

			local effect = EffectData() -- Create effect data
			effect:SetOrigin( dmginfo:GetDamagePosition() ) -- Set origin where collision point is
			util.Effect( "BloodImpact", effect ) -- Spawn small sparky effect

			ragdoll.RagHealth = ragdoll.RagHealth - dmginfo:GetDamage()
			if dmginfo:GetDamage() > ragdoll.RagHealth then
				SafeRemoveEntity(DM)
				ragdoll:SetNoDraw(false)
				for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
					local bone = ragdoll:GetPhysicsObjectNum( i )
					bone:EnableCollisions(true)
				end
				hook.Remove( "EntityTakeDamage", "GibSystem_DeathAnimation_Ragdoll_DMG_Check"..RagdollIndex )
				return
			end
		end
	end)
	--[[
	timer.Create( "GibSystem_DeathAnimation_Think_Timer"..RagdollIndex, FrameTime(), 0, function() 
		if !IsValid(DM) or !IsValid(ragdoll) then return end
		GibSystem_DeathAnimation_Think(ragdoll,DM)
	end)
	]]--

	hook.Add( "Tick", "GibSystem_DeathAnimation_Think"..RagdollIndex, function() 
		if !IsValid(DM) or !IsValid(ragdoll) then 
			hook.Remove( "Tick", "GibSystem_DeathAnimation_Think"..RagdollIndex )
			return
		end
		GibSystem_DeathAnimation_Think(ragdoll,DM)
	end)
	

	timer.Simple(DM:SequenceDuration(DM:LookupSequence( anim )), function()
		if IsValid(DM) then
			SafeRemoveEntity(DM)
		end
		if IsValid(ragdoll) then
			ragdoll:SetNoDraw(false)
			if GetConVar( "gibsystem_ragdoll_convulsion" ):GetInt() == 2 and CheckFedhoria() then
				timer.Simple(1, function()
				if !IsValid(ragdoll) then return end	
					fedhoria.StartModule(ragdoll, "stumble_legs", phys_bone, lpos)
				end)
			end
			for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
				local bone = ragdoll:GetPhysicsObjectNum( i )
				if ( IsValid( bone ) ) then 
					local PhysToBone = ragdoll:TranslatePhysBoneToBone( i )
					if PhysBones[ragdoll:GetBoneName(PhysToBone)] then
						bone:EnableCollisions(true)
					end
				end
			end
		end
	end)
end
