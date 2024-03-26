
local convulsionmode = {}
convulsionmode["#gs.convulsionmode.none"] = {gibsystem_ragdoll_convulsion = "0"}
convulsionmode["#gs.convulsionmode.default"] = {gibsystem_ragdoll_convulsion = "1"}
convulsionmode["#gs.convulsionmode.fedhoria"] = {gibsystem_ragdoll_convulsion = "2"}

local collisiongroup = {}
collisiongroup["#gs.collisiongroup.only_world"] = {gibsystem_ragdoll_collisiongroup = "1"}
collisiongroup["#gs.collisiongroup.other_gibs"] = {gibsystem_ragdoll_collisiongroup = "11"}
collisiongroup["#gs.collisiongroup.except_players"] = {gibsystem_ragdoll_collisiongroup = "15"}
collisiongroup["#gs.collisiongroup.everything"] = {gibsystem_ragdoll_collisiongroup = "0"}

local cammode = {}
cammode["#gs.cammode.head"] = {gibsystem_deathcam_mode = "0"}
cammode["#gs.cammode.body"] = {gibsystem_deathcam_mode = "1"}
//cammode["#gs.cammode.legs"] = {gibsystem_deathcam_mode = "2"}

local gibgroup = {}
gibgroup["#gs.gibgroup.random"] = {gibsystem_gib_group = "default"}
gibgroup["#gs.gibgroup.headless"] = {gibsystem_gib_group = "headless"}
gibgroup["#gs.gibgroup.limbs"] = {gibsystem_gib_group = "limbs"}
gibgroup["#gs.gibgroup.no_legs"] = {gibsystem_gib_group = "no_legs"}
gibgroup["#gs.gibgroup.no_arms"] = {gibsystem_gib_group = "no_arms"}
gibgroup["#gs.gibgroup.no_right_leg_left_arm"] = {gibsystem_gib_group = "no_right_leg_left_arm"}
gibgroup["#gs.gibgroup.no_left_leg_right_arm"] = {gibsystem_gib_group = "no_left_leg_right_arm"}
gibgroup["#gs.gibgroup.no_left_leg"] = {gibsystem_gib_group = "no_left_leg"}
gibgroup["#gs.gibgroup.no_right_leg"] = {gibsystem_gib_group = "no_right_leg"}
gibgroup["#gs.gibgroup.no_left_arm"] = {gibsystem_gib_group = "no_left_arm"}
gibgroup["#gs.gibgroup.no_right_arm"] = {gibsystem_gib_group = "no_right_arm"}
gibgroup["#gs.gibgroup.no_right"] = {gibsystem_gib_group = "no_right"}
gibgroup["#gs.gibgroup.no_left"] = {gibsystem_gib_group = "no_left"}
gibgroup["#gs.gibgroup.no_right_no_arm"] = {gibsystem_gib_group = "no_right_no_arm"}
gibgroup["#gs.gibgroup.no_left_no_arm"] = {gibsystem_gib_group = "no_left_no_arm"}
gibgroup["#gs.gibgroup.no_right_no_leg"] = {gibsystem_gib_group = "no_right_no_leg"}
gibgroup["#gs.gibgroup.no_left_no_leg"] = {gibsystem_gib_group = "no_left_no_leg"}
gibgroup["#gs.gibgroup.legs_and_torso"] = {gibsystem_gib_group = "legs_&_torso"}

local gibname = {}
gibname["#gs.gibname.default"] = {gibsystem_gib_name = "default"}

local files, _ = file.Find("autorun/gibbing_system/models/*.lua", "LUA")
for _, filename in ipairs(files) do
	gibname["#gs.model."..tostring(filename:gsub("%.lua$", ""))] = {gibsystem_gib_name = tostring(filename:gsub("%.lua$", ""))}
end

hook.Add("AddToolMenuTabs", "GIBBING_SYSTEM_ADDMENU", function()
	spawnmenu.AddToolCategory("Options", "GIBBING SYSTEM Settings", "#GS.Title")
end)

hook.Add("PopulateToolMenu","GIBBING_SYSTEM_MENU",function()
	spawnmenu.AddToolMenuOption("Options", "GIBBING SYSTEM Settings", "Gibbing System", "#GS.Settings","","",function(pnl)
		pnl:ClearControls()
		pnl:AddControl( "ComboBox", { MenuButton = 1, Folder = "gib_system" } )
		pnl:AddControl( "CheckBox", { Label = "#GS.Enable", Command = "gibsystem_enabled" } )
		pnl:AddControl( "CheckBox", { Label = "#GS.Gib_Players", Command = "gibsystem_gibbing_player" } )
		pnl:AddControl( "CheckBox", { Label = "#GS.Gib_NPCs", Command = "gibsystem_gibbing_npc" } )
		pnl:AddControl( "CheckBox", { Label = "#GS.Gib_All", Command = "gibsystem_gib_allnpcs" } )
		pnl:AddControl( "CheckBox", { Label = "#GS.Random.Finger_Rotating", Command = "gibsystem_random_finger_rotating" } )
		pnl:AddControl( "CheckBox", { Label = "#GS.Random.Toe_Rotating", Command = "gibsystem_random_toe_rotating" } )
		pnl:AddControl( "CheckBox", { Label = "#GS.Random.GF2_Toe_Rotating", Command = "gibsystem_random_gf2_toe_rotating" } )
		pnl:AddControl( "CheckBox", { Label = "#GS.Random.Bodygroup", Command = "gibsystem_random_bodygroup" } )
		pnl:AddControl( "CheckBox", { Label = "#GS.Random.Skin", Command = "gibsystem_random_skin" } )
		pnl:AddControl( "CheckBox", { Label = "#GS.BloodEffect", Command = "gibsystem_blood_effect" } )
		pnl:AddControl( "CheckBox", { Label = "#GS.DeathExpress", Command = "gibsystem_death_express" } )
		pnl:AddControl( "ComboBox", { Label = "#GS.Ragdoll_Convulsion", Options = convulsionmode } )
		pnl:AddControl( "ComboBox", { Label = "#GS.GibsCollision", Options = collisiongroup } )
		pnl:AddControl( "CheckBox", { Label = "#GS.Deathcam", Command = "gibsystem_deathcam_enable" } )
		pnl:AddControl( "ComboBox", { Label = "#GS.Deathcam.Mode", Options = cammode } )
		pnl:AddControl( "ComboBox", { Label = "#GS.GibGroup", Options = gibgroup } )
		pnl:AddControl( "ComboBox", { Label = "#GS.GibName", Options = gibname } )
		pnl:AddControl( "textbox", { Label = "#GS.HeadMess", Command = "gibsystem_head_mass" } )
		pnl:AddControl( "textbox", { Label = "#GS.BodyMess", Command = "gibsystem_body_mass" } )
		pnl:AddControl( "Slider", { Label = "#GS.GibsRemoveTimer", Type = "Integer", Command = "gibsystem_ragdoll_removetimer", Min = "-1", Max = "100" } )
		pnl:AddControl( "CheckBox", { Label = "#GS.Rope", Command = "gibsystem_rope" } )
		pnl:AddControl( "Slider", { Label = "#GS.Rope_Strength", Type = "Integer", Command = "gibsystem_rope_strength", Min = "0", Max = "5000" } )
		pnl:AddControl( "Slider", { Label = "#GS.BloodEffectLength", Type = "Integer", Command = "gibsystem_blood_time", Min = "0", Max = "100" } )
		pnl:AddControl( "Slider", { Label = "#GS.BodyBloodEffectLength", Type = "Integer", Command = "gibsystem_blood_time_body", Min = "0", Max = "100" } )
		pnl:AddControl( "Button", { Label = "#GS.Cleanup_Gibs", Command = "CleanGibs" } )
	end)
	
	spawnmenu.AddToolMenuOption("Options", "GIBBING SYSTEM Settings", "Gibbing System EXP", "#GS.Experiments","","",function(pnl)
		pnl:ClearControls()
		pnl:AddControl( "CheckBox", { Label = "#GS.ExperimentsEnabled", Command = "gibsystem_experiment" } )
	end)
end)
