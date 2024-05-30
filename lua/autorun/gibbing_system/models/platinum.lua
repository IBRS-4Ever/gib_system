Model_Table = Model_Table or {} -- don't touch

local Name = "platinum"

local NewModel = { -- add new tables inside here

	{
		name = "platinum",
		mdl = "models/platinum_headless.mdl",
		part = "headless",
		type = "ragdoll"
	},
	
	{
		name = "platinum",
		mdl = "models/platinum_head.mdl",
		part = "head",
		type = "ragdoll"
	},
}

table.insert(Model_Table,NewModel) -- don't touch

table.insert(RagHead,Name)