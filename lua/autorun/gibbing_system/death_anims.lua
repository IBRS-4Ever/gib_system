
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

function CreateDeathAnimationGib(ent)
	if GetConVar("gibsystem_deathanimation_name"):GetString() == "random" then
		anim = anims_table[math.random(1,#anims_table)]
	else
		anim = GetConVar("gibsystem_deathanimation_name"):GetString()
	end
	
	local Materials = ent:GetMaterials()
	
	if table.HasValue( GibModels, GetConVar("gibsystem_gib_name"):GetString() ) then
		Model = GetConVar("gibsystem_gib_name"):GetString()
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
		
	local head = nil
	local HeadPos = ent:LookupBone("ValveBiped.Bip01_Head1")
		
	if !list.HasEntry("GIBSYSTEM_RAGDOLL_HEADS",Model) then
		head = ents.Create("prop_physics")
		head:SetPos( ent:GetBonePosition(HeadPos) ) 
	else
		head = ents.Create("prop_ragdoll")
		head:SetPos( ent:GetPos() ) 
	end
		
	head:SetAngles( ent:GetAngles() )
	head:SetCollisionGroup(GetConVar( "gibsystem_ragdoll_collisiongroup" ):GetInt())
	head:SetModel("models/gib_system/"..Model.."_head.mdl")
	head:Spawn()
	head:SetName("headIndex"..head:EntIndex())
	head:Activate()
	GibFacePose(head)
	RandomBodyGroup(head)
	RandomSkin(head)
	table.insert(GibsCreated,head)
	
	if GetConVar( "gibsystem_ragdoll_removetimer" ):GetInt() > 0 then
		timer.Create( "RemoveTimer"..head:EntIndex(), GetConVar( "gibsystem_ragdoll_removetimer" ):GetInt(), 1, function()
			if IsValid( head ) then
				head:Remove()
			end
			timer.Remove( "RemoveTimer"..head:EntIndex() )
			timer.Remove( "BloodImpactTimer"..head:EntIndex() )
		end)
	end
	
	head:CallOnRemove("RemoveGibTimer",function() timer.Remove( "BloodImpactTimer"..head:EntIndex() ) end)

	for i = 0, head:GetPhysicsObjectCount() - 1 do
		local phys = head:GetPhysicsObjectNum( i )
		
		if GetConVar("gibsystem_head_mass"):GetInt() > 0 then
			phys:SetMass( GetConVar("gibsystem_head_mass"):GetInt()/head:GetPhysicsObjectCount() )
		end
		
		if ent:IsPlayer() then
			phys:ApplyForceCenter( (DamageForce / head:GetPhysicsObjectCount()) + phys:GetMass() * ent:GetVelocity() * 39.37 * engine.TickInterval() )
		else
			phys:ApplyForceCenter( (DamageForce / head:GetPhysicsObjectCount()) + (phys:GetMass() * ent:GetMoveVelocity() * 39.37 * engine.TickInterval()) )
		end
	end
		
	local DM = ents.Create("prop_dynamic")
	
	DM:SetModel( "models/gib_system/"..Model.."_headless.mdl" )
	DM:SetPos( ent:GetPos() )
	DM:SetAngles( ent:GetAngles() )
	DM:Spawn()
	--DM:SetOwner( ent )
	DM:ResetSequence( DM:LookupSequence( anim ) )
	print("Sequence Is: "..anim)
	DM:ResetSequenceInfo()
	DM:SetCycle(1) -- Was 0, Set to 1 to make ragdoll looks good.
		
	RandomBodyGroup(DM)
	RandomSkin(DM)
		
	BloodEffect(DM,2,"forward")
	
	if ent:IsPlayer() then
		ent:Spectate(5)
		ent:SetObserverMode(OBS_MODE_CHASE)
		if GetConVar( "gibsystem_deathcam_mode" ):GetInt() == 0 then
			ent:SpectateEntity(head)
		elseif GetConVar( "gibsystem_deathcam_mode" ):GetInt() == 1 then
			ent:SpectateEntity(DM)
		end
	end
	
	timer.Simple(DM:SequenceDuration(), function()

		local ragdoll = ents.Create( "prop_ragdoll" )
		ragdoll:SetModel( DM:GetModel() )
		ragdoll:SetPos( DM:GetPos() )
		ragdoll:SetAngles( DM:GetAngles() )
		ragdoll:SetCollisionGroup(GetConVar( "gibsystem_ragdoll_collisiongroup" ):GetInt())
		ragdoll:SetSkin( DM:GetSkin() )
		ragdoll:SetFlexScale( DM:GetFlexScale() )
		for i = 0, DM:GetNumBodyGroups() - 1 do ragdoll:SetBodygroup( i, DM:GetBodygroup( i ) ) end
		for i = 0, DM:GetFlexNum() - 1 do ragdoll:SetFlexWeight( i, DM:GetFlexWeight( i ) ) end
		for i = 0, DM:GetBoneCount() do
			ragdoll:ManipulateBoneScale( i, DM:GetManipulateBoneScale( i ) )
			ragdoll:ManipulateBoneAngles( i, DM:GetManipulateBoneAngles( i ) )
			ragdoll:ManipulateBonePosition( i, DM:GetManipulateBonePosition( i ) )
			ragdoll:ManipulateBoneJiggle( i, DM:GetManipulateBoneJiggle( i ) ) -- Even though we don't know what this does, I am still putting this here.
		end

		ragdoll:Spawn()
		ragdoll:Activate()
		
		for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
			local bone = ragdoll:GetPhysicsObjectNum( i )
			if ( IsValid( bone ) ) then
				local pos, ang = DM:GetBonePosition( ragdoll:TranslatePhysBoneToBone( i ) )
				if ( pos ) then bone:SetPos( pos ) end
				if ( ang ) then bone:SetAngles( ang ) end

			-- bone:ApplyForceOffset( DamageForce / ragdoll:GetPhysicsObjectCount(), DamagePosition )
			end
			-- bone:ApplyForceCenter( bone:GetMass() * DM:GetSequenceVelocity( DM:LookupSequence(anim), 0 ) * 39.37 * engine.TickInterval() )
			-- print(DM:GetSequenceVelocity( DM:LookupSequence(anim), 0 ))
		end
		
		
		if ent:IsPlayer() then
			if !ent:Alive() then
				ent:Spectate(5)
				ent:SetObserverMode(OBS_MODE_CHASE)

				if GetConVar( "gibsystem_deathcam_mode" ):GetInt() == 0 then
					ent:SpectateEntity(head)
				elseif GetConVar( "gibsystem_deathcam_mode" ):GetInt() == 1 then
					ent:SpectateEntity(ragdoll)
				end
			end
		end
	
		FingerRotation(ragdoll)
		BloodEffect(ragdoll,2,"forward",DM:SequenceDuration())
		table.insert(GibsCreated,ragdoll)
		SafeRemoveEntity(DM)
		
		if GetConVar( "gibsystem_ragdoll_removetimer" ):GetInt() > 0 then
			timer.Create( "RemoveTimer"..ragdoll:EntIndex(), GetConVar( "gibsystem_ragdoll_removetimer" ):GetInt(), 1, function()
				if IsValid( ragdoll ) then
					ragdoll:Remove()
				end
				timer.Remove( "RemoveTimer"..ragdoll:EntIndex() )
				timer.Remove( "BloodImpactTimer"..ragdoll:EntIndex() )
			end)
		end
		
		ragdoll:CallOnRemove("RemoveGibTimer",function() timer.Remove( "BloodImpactTimer"..ragdoll:EntIndex() ) end)

	end)
	DM:CallOnRemove("RemoveHeadTimer",function(DM) timer.Remove( "BloodImpactTimer"..DM:EntIndex() ) end)
end
