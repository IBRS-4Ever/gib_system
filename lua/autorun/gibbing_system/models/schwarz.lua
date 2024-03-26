Model_Table = Model_Table or {} -- don't touch

local Name = "schwarz"

local NewModel = { -- add new tables inside here

	{
		name = "schwarz",
		mdl = "models/schwarz_headless.mdl",
		part = "headless",
		type = "ragdoll"
	},
	
	{
		name = "schwarz",
		mdl = "models/schwarz_head.mdl",
		part = "head",
		type = "physics"
	},
}

table.insert(Model_Table,NewModel) -- don't touch
