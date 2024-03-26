Model_Table = Model_Table or {} -- don't touch

local Name = "daiyan"

local NewModel = { -- add new tables inside here

	{
		name = "daiyan",
		mdl = "models/gib_system/daiyan_headless.mdl",
		part = "headless",
		type = "ragdoll"
	},
	
	{
		name = "daiyan",
		mdl = "models/gib_system/daiyan_head.mdl",
		part = "head",
		type = "physics"
	},
}

table.insert(Model_Table,NewModel) -- don't touch