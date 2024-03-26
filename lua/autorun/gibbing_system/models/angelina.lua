Model_Table = Model_Table or {} -- don't touch

local Name = "angelina"

local NewModel = { -- add new tables inside here

	{
		name = "angelina",
		mdl = "models/angelina_headless.mdl",
		part = "headless",
		type = "ragdoll"
	},
	
	{
		name = "angelina",
		mdl = "models/angelina_head.mdl",
		part = "head",
		type = "physics"
	},
}

table.insert(Model_Table,NewModel) -- don't touch
