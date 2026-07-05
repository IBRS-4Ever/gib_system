
AddCSLuaFile()

local function ReplaceSkin(ent)
	if not IsValid(ent) or ent:GetModel() == "" then return end

	local materials = ent:GetMaterials()
	if not materials or #materials == 0 then return end

	-- 遍历实体身上的每一个材质通道
	for k, matPath in ipairs(materials) do
		-- 1. 使用 Gmod 内置函数提取出路径中的文件名（例如：models/gfl2/skin -> skin）
		local fileName = string.GetFileFromFilename(matPath)
		
		-- 2. 全部转为小写，防止开发者大小写录入不一致
		local lowerFileName = string.lower(fileName)

		-- 3. 在配置表中直接查找这个文件名
		local targetMaterial = SkinReplace_Table[lowerFileName]

		-- 4. 如果匹配成功，执行替换
		if targetMaterial then
			local subMatIndex = k - 1
			ent:SetSubMaterial(subMatIndex, "models/gfl2_shared/"..targetMaterial)
		end
	end
end

hook.Add("OnEntityCreated", "GFL2_SkinReplacer", function(ent)
	if !GetConVar("gibsystem_gfl2_skin_replacement"):GetBool() then return end
	timer.Simple(0, function()
		if IsValid(ent) then
			ReplaceSkin(ent)
		end
	end)
end)
