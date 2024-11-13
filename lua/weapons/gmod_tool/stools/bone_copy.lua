
TOOL.Category = "GS.Title"
TOOL.Name = "#tool.bone_copy.name"

TOOL.RequiresTraceHit = true

TOOL.Information = {
	{ name = "left" },
	{ name = "right" }
}

local Bones = {}

function TOOL:LeftClick( trace )

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	local ent = trace.Entity
	if ( CLIENT ) then return true end
	
	for bonename = 0 , ent:GetBoneCount() do 
		if Bones[ent:GetBoneName(bonename)] != nil then
			ent:ManipulateBoneAngles(bonename,Bones[ent:GetBoneName(bonename)])
		end
	end
		
	return true

end

function TOOL:RightClick( trace )

	local ent = trace.Entity
	if ( IsValid( ent ) && ent:GetClass() == "prop_effect" ) then ent = ent.AttachedEntity end

	if ( CLIENT ) then return false end
	
	table.Empty(Bones)
	
	for i = 0, ent:GetBoneCount() do
		local Bone = ent:GetBoneName(i)
		local Angle = ent:GetManipulateBoneAngles(i)
		Bones[Bone] = Angle
	end
	
	return true
	
end

if ( SERVER ) then return end
