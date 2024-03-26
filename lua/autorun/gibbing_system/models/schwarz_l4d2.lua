Model_Table = Model_Table or {} -- don't touch

local Name = "schwarz_l4d2"

local NewModel = { -- add new tables inside here

	{
		name = "schwarz_l4d2",
		mdl = "models/schwarz_l4d2_headless.mdl",
		part = "headless",
		type = "ragdoll"
	},
	
	{
		name = "schwarz_l4d2",
		mdl = "models/schwarz_l4d2_head.mdl",
		part = "head",
		type = "physics"
	},
}

table.insert(Model_Table,NewModel) -- don't touch
