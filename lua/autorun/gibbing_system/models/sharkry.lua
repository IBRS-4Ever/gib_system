Model_Table = Model_Table or {} -- don't touch

local Name = "sharkry"

local NewModel = { -- add new tables inside here

	{
		name = "sharkry",
		mdl = "models/gib_system/sharkry_headless.mdl",
		part = "headless",
		type = "ragdoll"
	},
	
	{
		name = "sharkry",
		mdl = "models/gib_system/sharkry_head.mdl",
		part = "head",
		type = "physics"
	},
}

table.insert(Model_Table,NewModel) -- don't touch