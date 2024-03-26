Model_Table = Model_Table or {} -- don't touch

local Name = "provence"

local NewModel = { -- add new tables inside here

	{
		name = "provence",
		mdl = "models/provence_headless.mdl",
		part = "headless",
		type = "ragdoll"
	},
	
	{
		name = "provence",
		mdl = "models/provence_head.mdl",
		part = "head",
		type = "physics"
	},
}

table.insert(Model_Table,NewModel) -- don't touch
