
TOOL.Category = "GS.Title"
TOOL.Name = "#tool.gs_ragdoll_stretch.name"

TOOL.ClientConVar[ "head" ] = 1
TOOL.ClientConVar[ "left_thigh" ] = 0
TOOL.ClientConVar[ "left_leg" ] = 1
TOOL.ClientConVar[ "left_foot" ] = 0
TOOL.ClientConVar[ "right_thigh" ] = 0
TOOL.ClientConVar[ "right_leg" ] = 1
TOOL.ClientConVar[ "right_foot" ] = 0
TOOL.ClientConVar[ "left_upperarm" ] = 0
TOOL.ClientConVar[ "left_arm" ] = 1
TOOL.ClientConVar[ "left_hand" ] = 0
TOOL.ClientConVar[ "right_upperarm" ] = 0
TOOL.ClientConVar[ "right_arm" ] = 1
TOOL.ClientConVar[ "right_hand" ] = 0

TOOL.Information = {
	{ name = "left" },
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
		
	local PhysB = {
		["ValveBiped.Bip01_Head1"] 	= GetConVar("gs_ragdoll_stretch_head"):GetBool(),
		["ValveBiped.Bip01_L_Thigh"] 	= GetConVar("gs_ragdoll_stretch_left_thigh"):GetBool(),
		["ValveBiped.Bip01_L_Calf"] 	= GetConVar("gs_ragdoll_stretch_left_leg"):GetBool(),
		["ValveBiped.Bip01_L_Foot"] 	= GetConVar("gs_ragdoll_stretch_left_foot"):GetBool(),
		["ValveBiped.Bip01_R_Thigh"] 	= GetConVar("gs_ragdoll_stretch_right_thigh"):GetBool(),
		["ValveBiped.Bip01_R_Calf"] 	= GetConVar("gs_ragdoll_stretch_right_leg"):GetBool(),
		["ValveBiped.Bip01_R_Foot"] 	= GetConVar("gs_ragdoll_stretch_right_foot"):GetBool(),
		["ValveBiped.Bip01_L_UpperArm"] = GetConVar("gs_ragdoll_stretch_left_upperarm"):GetBool(),
		["ValveBiped.Bip01_L_Forearm"] 	= GetConVar("gs_ragdoll_stretch_left_arm"):GetBool(),
		["ValveBiped.Bip01_L_Hand"] 	= GetConVar("gs_ragdoll_stretch_left_hand"):GetBool(),
		["ValveBiped.Bip01_R_UpperArm"] = GetConVar("gs_ragdoll_stretch_right_upperarm"):GetBool(),
		["ValveBiped.Bip01_R_Forearm"] 	= GetConVar("gs_ragdoll_stretch_right_arm"):GetBool(),
		["ValveBiped.Bip01_R_Hand"] 	= GetConVar("gs_ragdoll_stretch_right_hand"):GetBool(),
		
	}

	if CLIENT then return true end
	if ( IsValid( tr.Entity ) ) then
		Gib = tr.Entity
		for i = 0, Gib:GetPhysicsObjectCount() - 1 do
			local phys = Gib:GetPhysicsObjectNum( i )
			local Bone_name = Gib:GetBoneName(Gib:TranslatePhysBoneToBone( i ))
			if PhysB[Bone_name] then
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

function TOOL.BuildCPanel( CPanel )
	CPanel:AddControl( "CheckBox", { Label = "#tool.gs_ragdoll_stretch.head", Command = "gs_ragdoll_stretch_head" } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.gs_ragdoll_stretch.left_thigh", Command = "gs_ragdoll_stretch_left_thigh" } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.gs_ragdoll_stretch.left_leg", Command = "gs_ragdoll_stretch_left_leg" } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.gs_ragdoll_stretch.left_foot", Command = "gs_ragdoll_stretch_left_foot" } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.gs_ragdoll_stretch.right_thigh", Command = "gs_ragdoll_stretch_right_thigh" } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.gs_ragdoll_stretch.right_leg", Command = "gs_ragdoll_stretch_right_leg" } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.gs_ragdoll_stretch.right_foot", Command = "gs_ragdoll_stretch_right_foot" } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.gs_ragdoll_stretch.left_upperarm", Command = "gs_ragdoll_stretch_left_upperarm" } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.gs_ragdoll_stretch.left_arm", Command = "gs_ragdoll_stretch_left_arm" } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.gs_ragdoll_stretch.left_hand", Command = "gs_ragdoll_stretch_left_hand" } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.gs_ragdoll_stretch.right_upperarm", Command = "gs_ragdoll_stretch_right_upperarm" } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.gs_ragdoll_stretch.right_arm", Command = "gs_ragdoll_stretch_right_arm" } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.gs_ragdoll_stretch.right_hand", Command = "gs_ragdoll_stretch_right_hand" } )
end
