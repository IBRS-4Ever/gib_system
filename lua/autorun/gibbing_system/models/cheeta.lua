Model_Table = Model_Table or {} -- don't touch

local Name = "cheeta"

local NewModel = { -- add new tables inside here

	{
		name = "cheeta",
		mdl = "models/gib_system/cheeta_headless.mdl",
		part = "headless",
		type = "ragdoll"
	},
	
	{
		name = "cheeta",
		mdl = "models/gib_system/cheeta_head.mdl",
		part = "head",
		type = "physics"
	},
}

table.insert(Model_Table,NewModel) -- don't touch