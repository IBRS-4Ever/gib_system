Model_Table = Model_Table or {} -- don't touch

local Name = "ifrit"

local NewModel = { -- add new tables inside here

	{
		name = "ifrit",
		mdl = "models/ifrit_headless.mdl",
		part = "headless",
		type = "ragdoll"
	},
	
	{
		name = "ifrit",
		mdl = "models/ifrit_head.mdl",
		part = "head",
		type = "ragdoll"
	},
}

table.insert(Model_Table,NewModel) -- don't touch
