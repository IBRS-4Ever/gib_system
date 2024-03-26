Model_Table = Model_Table or {} -- don't touch

local Name = "gummy"

local NewModel = { -- add new tables inside here

	{
		name = "gummy",
		mdl = "models/gib_system/gummy_headless.mdl",
		part = "headless",
		type = "ragdoll"
	},
	
	{
		name = "gummy",
		mdl = "models/gib_system/gummy_head.mdl",
		part = "head",
		type = "physics"
	},
}

table.insert(Model_Table,NewModel) -- don't touch