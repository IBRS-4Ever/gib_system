Model_Table = Model_Table or {} -- don't touch

local Name = "amiya"

local NewModel = { -- add new tables inside here

	{
		name = "amiya",
		mdl = "models/amiya_headless.mdl",
		part = "headless",
		type = "ragdoll"
	},
	
	{
		name = "amiya",
		mdl = "models/amiya_head.mdl",
		part = "head",
		type = "physics"
	},
}

table.insert(Model_Table,NewModel) -- don't touch