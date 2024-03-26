
--[[
hook.Add("PopulatePropMenu", "Gib System Category", function()
	
	local contents = {}

	table.insert( contents, {
		type = "ValveBiped.Bip01_Head1er",
		text = "#GS.Category.ValveBiped.Bip01_Head1"
	} )
	
	local ValveBiped.Bip01_Head1, _ = file.Find("models/gib_system/*_ValveBiped.Bip01_Head1.mdl", "GAME")

	for _, gibmodel in ipairs(ValveBiped.Bip01_Head1) do
		table.insert( contents, {
			type = "model",
			model = "models/gib_system/"..gibmodel
			--tall = 128
		} )
	end
	
	table.insert( contents, {
		type = "ValveBiped.Bip01_Head1er",
		text = "#GS.Category.ValveBiped.Bip01_Head1less"
	} )
	
	local ValveBiped.Bip01_Head1less, _ = file.Find("models/gib_system/*_ValveBiped.Bip01_Head1less.mdl", "GAME")

	for _, gibmodel in ipairs(ValveBiped.Bip01_Head1less) do
		table.insert( contents, {
			type = "model",
			model = "models/gib_system/"..gibmodel
		} )
	end
	
	table.insert( contents, {
		type = "ValveBiped.Bip01_Head1er",
		text = "#GS.Category.Torso"
	} )
	
	local torso, _ = file.Find("models/gib_system/*_torso.mdl", "GAME")

	for _, gibmodel in ipairs(torso) do
		table.insert( contents, {
			type = "model",
			model = "models/gib_system/"..gibmodel
		} )
	end
	
	table.insert( contents, {
		type = "ValveBiped.Bip01_Head1er",
		text = "#GS.Category.Legs"
	} )
	
	local legs, _ = file.Find("models/gib_system/*_legs.mdl", "GAME")

	for _, gibmodel in ipairs(legs) do
		table.insert( contents, {
			type = "model",
			model = "models/gib_system/"..gibmodel
		} )
	end
	
	table.insert( contents, {
		type = "ValveBiped.Bip01_Head1er",
		text = "#GS.Category.Limbs"
	} )
	
	local limbs, _ = file.Find("models/gib_system/limbs/*/*.mdl", "GAME")

	for _, gibmodel in ipairs(limbs) do
		table.insert( contents, {
			type = "model",
			model = "models/gib_system/limbs/"..gibmodel
		} )
	end
	
	spawnmenu.AddPropCategory( "GS_C", "Gib System", contents, "icon16/box.png" )
end )

]]--