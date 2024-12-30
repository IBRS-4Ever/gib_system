
TOOL.Category = "GS.Title"
TOOL.Name = "#tool.bone_copy.name"
TOOL.ClientConVar[ "bones" ] = 1
TOOL.ClientConVar[ "phys" ] = 0

TOOL.RequiresTraceHit = true

TOOL.Information = {
	{ name = "left" },
	{ name = "right" }
}

local Bones = {}
local Phys = {}

function TOOL:LeftClick( trace )

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	local ent = trace.Entity
	if ( CLIENT ) then return true end
	
	if GetConVar("bone_copy_bones"):GetBool() then
		for bonename = 0 , ent:GetBoneCount() do 
			if Bones[ent:GetBoneName(bonename)] != nil then
				ent:ManipulateBoneAngles(bonename,Bones[ent:GetBoneName(bonename)])
			end
		end
	end

	if GetConVar("bone_copy_phys"):GetBool() then
		for i = 0, ent:GetPhysicsObjectCount() - 1 do
			local phys = ent:GetPhysicsObjectNum( i )
			local Bone_name = ent:GetBoneName(ent:TranslatePhysBoneToBone( i ))
			if Phys[Bone_name] != nil then
				local PhyInfo = Phys[Bone_name]
				phys:SetPos( Phys[Bone_name].Position )
				phys:SetAngles( Phys[Bone_name].Angle )
				phys:EnableCollisions(false)
				phys:EnableMotion(false)
				phys:Wake()
			end
		end
	end

	return true

end

function TOOL:RightClick( trace )

	local ent = trace.Entity
	if ( IsValid( ent ) && ent:GetClass() == "prop_effect" ) then ent = ent.AttachedEntity end

	if ( CLIENT ) then return false end
	
	table.Empty(Bones)
	table.Empty(Phys)
	
	for i = 0, ent:GetBoneCount() do
		local Bone = ent:GetBoneName(i)
		local Angle = ent:GetManipulateBoneAngles(i)
		Bones[Bone] = Angle
	end
	
	for i = 0, ent:GetPhysicsObjectCount() - 1 do
		local phys = ent:GetPhysicsObjectNum( i )
		local Bone_name = ent:GetBoneName(ent:TranslatePhysBoneToBone( i ))
		if IsValid( phys ) then
			local pos, ang = ent:GetBonePosition( ent:LookupBone(Bone_name) )
			Phys[Bone_name] = { Position = pos, Angle = ang }
		end
	end

	return true
	
end

function TOOL.BuildCPanel( CPanel )
	CPanel:AddControl( "Header", { Description = "#tool.bone_copy.desc" } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.bone_copy.bones", Command = "bone_copy_bones" } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.bone_copy.phys", Command = "bone_copy_phys" } )
end

if ( SERVER ) then return end
