
AddCSLuaFile()

local function ReplaceSkin(ent,IsPlayer)
	if !GetConVar("gibsystem_gfl2_skin_replacement"):GetBool() then return end
	if not IsValid(ent) or ent:GetModel() == "" then return end
	if (IsPlayer and !ent:IsPlayer()) then return end

	local materials = ent:GetMaterials()
	if not materials or #materials == 0 then return end

	for k, matPath in ipairs(materials) do
		local Texture = SkinReplace_Table[string.lower(string.GetFileFromFilename(matPath))]
		if Texture then
			if istable(Texture) then
				if Texture["IsLua"] then
					local subMatIndex = k - 1
					ent:SetSubMaterial(subMatIndex, "!models/gfl2_shared/"..Texture["Texture"])
				end
			else
				local subMatIndex = k - 1
				ent:SetSubMaterial(subMatIndex, "models/gfl2_shared/"..Texture)
			end
		else
			local subMatIndex = k - 1
			ent:SetSubMaterial(subMatIndex, nil)
		end
	end
end

hook.Add("OnEntityCreated", "GFL2_SkinReplacer", function(ent)
	timer.Simple(0, function()
		ReplaceSkin(ent)
	end)
end)

hook.Add("PlayerSetModel", "GFL2_SkinReplacer_player", function(ent)
	timer.Simple(0, function()
		ReplaceSkin(ent,true)
	end)
end)

