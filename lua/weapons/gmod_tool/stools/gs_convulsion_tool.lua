
TOOL.Category = "GS.Title"
TOOL.Name = "#tool.gs_convulsion_tool.name"
TOOL.ClientConVar[ "fedhoria" ] = 0

TOOL.Information = {
	{ name = "left" }
}

function TOOL:Click( tr )
	if CLIENT then return true end
	local ent = tr.Entity
	local pos = tr.HitPos
	if ( IsValid( ent ) ) then
		if GetConVar("gs_convulsion_tool_fedhoria"):GetBool() then
			local phys_bone = ent:GetClosestPhysBone(pos)
			if phys_bone then
				local phys = ent:GetPhysicsObjectNum(phys_bone)
						
				lpos = phys:WorldToLocal(pos)
			end
			if file.Exists( "fedhoria/modules.lua", "LUA" ) then
				timer.Simple(0, function()
					fedhoria.StartModule(ent, "stumble_legs", phys_bone, lpos)
				end)
			end
		else
			ent:Input( "StartRagdollBoogie", ent, ent, "" )
		end
	end
	return true
end

function TOOL:LeftClick( tr )
	return self:Click( tr )
end

function TOOL:RightClick( tr )

end

function TOOL.BuildCPanel( CPanel )
	CPanel:AddControl( "CheckBox", { Label = "#tool.gs_convulsion_tool.fedhoria", Command = "gs_convulsion_tool_fedhoria" } )
end
