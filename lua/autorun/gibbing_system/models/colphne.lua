Model_Table = Model_Table or {} -- don't touch

local Name = "colphne"

local NewModel = { -- add new tables inside here

	{
		name = "colphne",
		mdl = "models/gib_system/colphne_headless.mdl",
		part = "headless",
		type = "ragdoll"
	},
	
	{
		name = "colphne",
		mdl = "models/gib_system/colphne_head.mdl",
		part = "head",
		type = "physics"
	},
}

table.insert(Model_Table,NewModel) -- don't touch