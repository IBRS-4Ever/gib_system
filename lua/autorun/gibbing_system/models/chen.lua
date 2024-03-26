Model_Table = Model_Table or {} -- don't touch

local Name = "chen"

local NewModel = { -- add new tables inside here

	{
		name = "chen",
		mdl = "models/chen_headless.mdl",
		part = "headless",
		type = "ragdoll"
	},
	
	{
		name = "chen",
		mdl = "models/chen_head.mdl",
		part = "head",
		type = "physics"
	},
}

table.insert(Model_Table,NewModel) -- don't touch