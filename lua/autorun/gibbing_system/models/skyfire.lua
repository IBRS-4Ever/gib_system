Model_Table = Model_Table or {} -- don't touch

local Name = "skyfire"

local NewModel = { -- add new tables inside here

	{
		name = "skyfire",
		mdl = "models/skyfire_headless.mdl",
		part = "headless",
		type = "ragdoll"
	},
	
	{
		name = "skyfire",
		mdl = "models/skyfire_head.mdl",
		part = "head",
		type = "physics"
	},
}

table.insert(Model_Table,NewModel) -- don't touch
