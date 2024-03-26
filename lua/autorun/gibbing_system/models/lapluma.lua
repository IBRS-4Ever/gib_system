Model_Table = Model_Table or {} -- don't touch

local Name = "lapluma"

local Expressions = {

	["right_inner_raiser"] = 1,
	["left_inner_raiser"] = 1,
	["right_upper_raiser"] = 1,
	["left_upper_raiser"] = 1,
	["right_part"] = 1,
	["left_part"] = 1,
	["right_corner_puller"] = 1,
	["left_corner_puller"] = 1,
	["right_corner_depressor"] = 1,
	["left_corner_depressor"] = 1,
}

-- table.insert(Expressions_Table,Expressions) -- don't touch

local NewModel = { -- add new tables inside here

	{
		name = "lapluma",
		mdl = "models/lapluma_headless.mdl",
		part = "headless",
		type = "ragdoll"
	},
	
	{
		name = "lapluma",
		mdl = "models/lapluma_head.mdl",
		part = "head",
		type = "physics"
	},
}

table.insert(Model_Table,NewModel) -- don't touch