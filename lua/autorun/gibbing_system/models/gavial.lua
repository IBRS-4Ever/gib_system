Model_Table = Model_Table or {} -- don't touch

local Name = "gavial"

local NewModel = { -- add new tables inside here

	{
		name = "gavial",
		mdl = "models/gib_system/gavial_headless.mdl",
		part = "headless",
		type = "ragdoll"
	},
	
	{
		name = "gavial",
		mdl = "models/gib_system/gavial_head.mdl",
		part = "head",
		type = "physics"
	},
}

table.insert(Model_Table,NewModel) -- don't touch