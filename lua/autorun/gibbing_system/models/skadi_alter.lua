Model_Table = Model_Table or {} -- don't touch

local Name = "skadi_alter"

local NewModel = { -- add new tables inside here

	{
		name = "skadi_alter",
		mdl = "models/skadi_alter_headless.mdl",
		part = "headless",
		type = "ragdoll"
	},
	
	{
		name = "skadi_alter",
		mdl = "models/skadi_alter_head.mdl",
		part = "head",
		type = "physics"
	},
}

table.insert(Model_Table,NewModel) -- don't touch
