
TOOL.Category = "GS.Title"
TOOL.Name = "#tool.gs_ragdoll_attach.name"

TOOL.Information = {
	{ name = "left" },
	{ name = "right" }
}

local Ragdolls = {}

local Phys = {}

local function RagdollThink(ragdoll)
	if !IsValid(ragdoll.target) or !IsValid(ragdoll) then return end
	if ragdoll.target == ragdoll then return end

	table.Empty(Phys)

	for i = 0, ragdoll.target:GetBoneCount() - 1 do
		local Bone_name = ragdoll.target:GetBoneName(i)
		local pos, ang = ragdoll.target:GetBonePosition(i)
		Phys[Bone_name] = { Position = pos, Angle = ang }
	end
	for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
		local phys = ragdoll:GetPhysicsObjectNum( i )
		local Bone_name = ragdoll:GetBoneName(ragdoll:TranslatePhysBoneToBone( i ))
		if Phys[Bone_name] then
			local PhyInfo = Phys[Bone_name]
			phys:SetPos( Phys[Bone_name].Position )
			phys:SetAngles( Phys[Bone_name].Angle )
			--phys:EnableGravity( false )
			phys:Wake()
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
