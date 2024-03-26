Model_Table = Model_Table or {} -- don't touch

local Name = "centaureissi"

local NewModel = { -- add new tables inside here

	{
		name = "centaureissi",
		mdl = "models/gib_system/centaureissi_headless.mdl",
		part = "headless",
		type = "ragdoll"
	},
	
	{
		name = "centaureissi",
		mdl = "models/gib_system/centaureissi_head.mdl",
		part = "head",
		type = "physics"
	},
}

table.insert(Model_Table,NewModel) -- don't touch