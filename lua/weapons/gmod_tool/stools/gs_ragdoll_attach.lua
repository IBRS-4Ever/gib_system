
TOOL.Category = "GS.Title"
TOOL.Name = "#tool.gs_ragdoll_attach.name"

TOOL.Information = {
	{ name = "left" },
	{ name = "right" }
}

local Ragdolls = {}

local Phys = {}

local PhysBones = {
	["ValveBiped.Bip01_Pelvis"] 	= true,
	["ValveBiped.Bip01_Spine1"] 	= true,
	["ValveBiped.Bip01_Spine2"] 	= true,
	["ValveBiped.Bip01_Spine4"] 	= true,
	["ValveBiped.Bip01_Head1"] 	= true,
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
	maxangular = 800,
	maxangulardamp = 400,
	maxspeed = 800,
	maxspeeddamp = 600,
	teleportdistance = 0
}

local function RagdollThink(ragdoll)
	if !IsValid(ragdoll.target) or !IsValid(ragdoll) then return end
	if ragdoll.target == ragdoll then return end

	table.Empty(Phys)

	for i = 0, ragdoll.target:GetBoneCount() - 1 do
		local Bone_name = ragdoll.target:GetBoneName(i)
		local pos, ang = ragdoll.target:GetBonePosition(i)
		if PhysBones[Bone_name] then
			Phys[Bone_name] = { Position = pos, Angle = ang }
		end
	end
	for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
		local phys = ragdoll:GetPhysicsObjectNum( i )
		local Bone_name = ragdoll:GetBoneName(ragdoll:TranslatePhysBoneToBone( i ))
		if Phys[Bone_name] then
			local PhyInfo = Phys[Bone_name]
			--phys:EnableGravity( false )
			CSC.pos = Phys[Bone_name].Position
			CSC.angle = Phys[Bone_name].Angle

			phys:Wake()
			phys:ComputeShadowControl(CSC)

		end
	end
end

function TOOL:LeftClick( tr )
	
	if ( IsValid( tr.Entity ) && tr.Entity:IsPlayer() ) then return false end
	ragdoll.target = tr.Entity
	if ( CLIENT ) then return true end
	
	hook.Add( "Tick", "GibSystem_RagdollAttach_Think", function() 
		for k, Rag in pairs(Ragdolls) do
			RagdollThink(Rag)
		end
	end)
	
	ragdoll.target:SetNoDraw(true)

	return true

end

function TOOL:RightClick( tr )
	
	local ent = tr.Entity
	if ( IsValid( ent ) && ent:IsRagdoll() ) then ragdoll = ent end
	if !ragdoll then return end
	if ( CLIENT ) then return false end
	
	table.Empty(Phys)

	ragdoll:SetCollisionGroup(11)
	ragdoll.Next = CurTime() + 0.1

	table.insert(Ragdolls,ragdoll)
	
	return true

end
