Model_Table = Model_Table or {} -- don't touch

local Name = "rita_bikini"

local NewModel = { -- add new tables inside here

	{
		name = Name,
		mdl = "models/gib_system/"..Name.."_headless.mdl",
		part = "headless",
		type = "ragdoll"
	},
	
	{
		name = Name,
		mdl = "models/gib_system/"..Name.."_head.mdl",
		part = "head",
		type = "physics"
	},
}

table.insert(Model_Table,NewModel) -- don't touch