Model_Table = Model_Table or {} -- don't touch

local Name = "skadi"

local NewModel = { -- add new tables inside here

	{
		name = "skadi",
		mdl = "models/skadi_headless.mdl",
		part = "headless",
		type = "ragdoll"
	},
	
	{
		name = "skadi",
		mdl = "models/skadi_head.mdl",
		part = "head",
		type = "ragdoll"
	},
}

table.insert(Model_Table,NewModel) -- don't touch

table.insert(RagHead,Name)