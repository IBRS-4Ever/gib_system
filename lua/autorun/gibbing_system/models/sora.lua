Model_Table = Model_Table or {} -- don't touch

local Name = "sora"

local NewModel = { -- add new tables inside here

	{
		name = "sora",
		mdl = "models/sora_headless.mdl",
		part = "headless",
		type = "ragdoll"
	},
	
	{
		name = "sora",
		mdl = "models/sora_head.mdl",
		part = "head",
		type = "physics"
	},
}

table.insert(Model_Table,NewModel) -- don't touch
