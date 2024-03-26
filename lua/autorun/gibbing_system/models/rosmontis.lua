Model_Table = Model_Table or {} -- don't touch

local Name = "rosmontis"

local NewModel = { -- add new tables inside here

	{
		name = "rosmontis",
		mdl = "models/rosmontis_headless.mdl",
		part = "headless",
		type = "ragdoll"
	},
	
	{
		name = "rosmontis",
		mdl = "models/rosmontis_head.mdl",
		part = "head",
		type = "physics"
	},
}

table.insert(Model_Table,NewModel) -- don't touch
