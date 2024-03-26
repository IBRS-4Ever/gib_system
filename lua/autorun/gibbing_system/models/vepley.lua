Model_Table = Model_Table or {} -- don't touch

local Name = "vepley"

local NewModel = { -- add new tables inside here

	{
		name = "vepley",
		mdl = "models/gib_system/vepley_headless.mdl",
		part = "headless",
		type = "ragdoll"
	},
	
	{
		name = "vepley",
		mdl = "models/gib_system/vepley_head.mdl",
		part = "head",
		type = "physics"
	},
}

table.insert(Model_Table,NewModel) -- don't touch