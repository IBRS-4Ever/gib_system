Model_Table = Model_Table or {} -- don't touch

local Name = "vigna"

local NewModel = { -- add new tables inside here

	{
		name = "vigna",
		mdl = "models/vigna_headless.mdl",
		part = "headless",
		type = "ragdoll"
	},
	
	{
		name = "vigna",
		mdl = "models/vigna_head.mdl",
		part = "head",
		type = "physics"
	},
}

table.insert(Model_Table,NewModel) -- don't touch
