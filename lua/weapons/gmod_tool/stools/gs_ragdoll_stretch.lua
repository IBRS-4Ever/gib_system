
TOOL.Category = "GS.Title"
TOOL.Name = "#tool.gs_ragdoll_stretch.name"

TOOL.Information = {
	{ name = "left" },
}

local PhysBones = {
	--["ValveBiped.Bip01_Pelvis"] 	= true,
	--["ValveBiped.Bip01_Spine1"] 	= true,
	--["ValveBiped.Bip01_Spine2"] 	= true,
	--["ValveBiped.Bip01_Spine4"] 	= true,
	["ValveBiped.Bip01_Head1"] 	= true,
	--["ValveBiped.Bip01_R_Thigh"] 	= true,
	["ValveBiped.Bip01_R_Calf"] 	= true,
	--["ValveBiped.Bip01_R_Foot"] 	= true,
	--["ValveBiped.Bip01_L_Thigh"] 	= true,
	["ValveBiped.Bip01_L_Calf"] 	= true,
	--["ValveBiped.Bip01_L_Foot"] 	= true,
	--["ValveBiped.Bip01_R_UpperArm"] = true,
	["ValveBiped.Bip01_R_Forearm"] 	= true,
	--["ValveBiped.Bip01_R_Hand"] 	= true,
	--["ValveBiped.Bip01_L_UpperArm"] = true,
	["ValveBiped.Bip01_L_Forearm"] 	= true,
	--["ValveBiped.Bip01_L_Hand"] 	= true
}

function BallSocket(ent,bone)
	local pos = ent:GetBonePosition(ent:LookupBone(bone))
	local physobj1 = ent:TranslateBoneToPhysBone(ent:LookupBone(bone))
	local parentbone = ent:GetBoneParent(ent:LookupBone(bone))
	local physobj2 = ent:TranslateBoneToPhysBone(parentbone)
	if !ent:GetPhysicsObjectNum(physobj1):IsValid() or !ent:GetPhysicsObjectNum(physobj2):IsValid() then return end
	local Constraint = constraint.Ballsocket(ent,ent,physobj2,physobj1,Vector(0,0,0))
	constraint.AddConstraintTable(ent,Constraint)
	return Constraint
end

function TOOL:Click( tr )
	if CLIENT then return true end
	if ( IsValid( tr.Entity ) ) then
		Gib = tr.Entity
		for i = 0, Gib:GetPhysicsObjectCount() - 1 do
			local phys = Gib:GetPhysicsObjectNum( i )
			local Bone_name = Gib:GetBoneName(Gib:TranslatePhysBoneToBone( i ))
			if PhysBones[Bone_name] then
				local Phys = Gib:TranslateBoneToPhysBone(Gib:LookupBone(Bone_name))
				if !Gib:GetPhysicsObjectNum(Phys):IsValid() then continue end
				if !Gib:GetPhysicsObjectNum(Gib:TranslateBoneToPhysBone(Gib:GetBoneParent(Gib:LookupBone(Bone_name)))):IsValid() then continue end
				print(Phys,Bone_name,Gib:GetBoneName(Gib:GetBoneParent(Gib:LookupBone(Bone_name))),Gib:GetPhysicsObjectNum(Gib:TranslateBoneToPhysBone(Gib:GetBoneParent(Gib:LookupBone(Bone_name)))):IsValid())
				Gib:RemoveInternalConstraint(Phys)
				BallSocket(Gib,Bone_name)
			end
		end
		
	end
	return true
end

function TOOL:LeftClick( tr )
	return self:Click( tr )
end
