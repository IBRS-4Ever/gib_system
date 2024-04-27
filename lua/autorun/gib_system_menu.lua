
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
		pnl:AddControl( "CheckBox", { Label = "#GS.DeathAnimation", Command = "gibsystem_deathanimation" } )
	end)
	spawnmenu.AddToolMenuOption("Options", "GIBBING SYSTEM Settings", "Gibbing System Addons", "#GS.Addons","","",function(pnl)
		local WorkshopLink = "https://steamcommunity.com/sharedfiles/filedetails/?id="
		local WorkshopID = ""
		local X = 200 
		
		pnl:ClearControls()
		
		pnl:AddControl( "label", { Text = "#gs.model.gf2.groza" } )
		local Button = vgui.Create( "DButton", pnl ) // Create the button and parent it to the frame
		local WorkshopID = 3047654683
		if steamworks.IsSubscribed( WorkshopID ) then
			Button:SetText( "#GS.ADDON.INSTALLED" )					// Set the text on the button
			Button:SetEnabled( false )
		else
			Button:SetText( "#GS.ADDON.INSTALL" )					// Set the text on the button
			Button:SetEnabled( true )
		end
		Button:SetPos( X, 22 )					// Set the position on the frame
		Button:SetSize( 100, 25 )					// Set the size
		Button.DoClick = function()
			gui.OpenURL( WorkshopLink..WorkshopID ) 
		end
		pnl:AddControl( "label", { Text = "" } )
		
		pnl:AddControl( "label", { Text = "#gs.model.gf2.centaureissi" } )
		local Button = vgui.Create( "DButton", pnl ) // Create the button and parent it to the frame
		local WorkshopID = 3146928471
		if steamworks.IsSubscribed( WorkshopID ) then
			Button:SetText( "#GS.ADDON.INSTALLED" )					// Set the text on the button
			Button:SetEnabled( false )
		else
			Button:SetText( "#GS.ADDON.INSTALL" )					// Set the text on the button
			Button:SetEnabled( true )
		end
		Button:SetPos( X, 68 )					// Set the position on the frame
		Button:SetSize( 100, 25 )					// Set the size
		Button.DoClick = function()
			gui.OpenURL( WorkshopLink..WorkshopID ) 
		end
		pnl:AddControl( "label", { Text = "" } )
		
		pnl:AddControl( "label", { Text = "#gs.model.gf2.cheeta" } )
		local Button = vgui.Create( "DButton", pnl ) // Create the button and parent it to the frame
		local WorkshopID = 3037079098
		if steamworks.IsSubscribed( WorkshopID ) then
			Button:SetText( "#GS.ADDON.INSTALLED" )					// Set the text on the button
			Button:SetEnabled( false )
		else
			Button:SetText( "#GS.ADDON.INSTALL" )					// Set the text on the button
			Button:SetEnabled( true )
		end
		Button:SetPos( X, 114 )					// Set the position on the frame
		Button:SetSize( 100, 25 )					// Set the size
		Button.DoClick = function()
			gui.OpenURL( WorkshopLink..WorkshopID ) 
		end
		pnl:AddControl( "label", { Text = "" } )
		
		pnl:AddControl( "label", { Text = "#gs.model.gf2.colphne" } )
		local Button = vgui.Create( "DButton", pnl ) // Create the button and parent it to the frame
		local WorkshopID = 3033157638
		if steamworks.IsSubscribed( WorkshopID ) then
			Button:SetText( "#GS.ADDON.INSTALLED" )					// Set the text on the button
			Button:SetEnabled( false )
		else
			Button:SetText( "#GS.ADDON.INSTALL" )					// Set the text on the button
			Button:SetEnabled( true )
		end
		Button:SetPos( X, 160 )					// Set the position on the frame
		Button:SetSize( 100, 25 )					// Set the size
		Button.DoClick = function()
			gui.OpenURL( WorkshopLink..WorkshopID ) 
		end
		pnl:AddControl( "label", { Text = "" } )
		
		pnl:AddControl( "label", { Text = "#gs.model.gf2.daiyan" } )
		local Button = vgui.Create( "DButton", pnl ) // Create the button and parent it to the frame
		local WorkshopID = 3133391818
		if steamworks.IsSubscribed( WorkshopID ) then
			Button:SetText( "#GS.ADDON.INSTALLED" )					// Set the text on the button
			Button:SetEnabled( false )
		else
			Button:SetText( "#GS.ADDON.INSTALL" )					// Set the text on the button
			Button:SetEnabled( true )
		end
		Button:SetPos( X, 206 )					// Set the position on the frame
		Button:SetSize( 100, 25 )					// Set the size
		Button.DoClick = function()
			gui.OpenURL( WorkshopLink..WorkshopID ) 
		end
		pnl:AddControl( "label", { Text = "" } )
		
		pnl:AddControl( "label", { Text = "#gs.model.gf2.nagant" } )
		local Button = vgui.Create( "DButton", pnl ) // Create the button and parent it to the frame
		local WorkshopID = 3045162669
		if steamworks.IsSubscribed( WorkshopID ) then
			Button:SetText( "#GS.ADDON.INSTALLED" )					// Set the text on the button
			Button:SetEnabled( false )
		else
			Button:SetText( "#GS.ADDON.INSTALL" )					// Set the text on the button
			Button:SetEnabled( true )
		end
		Button:SetPos( X, 252 )					// Set the position on the frame
		Button:SetSize( 100, 25 )					// Set the size
		Button.DoClick = function()
			gui.OpenURL( WorkshopLink..WorkshopID ) 
		end
		pnl:AddControl( "label", { Text = "" } )
		
		pnl:AddControl( "label", { Text = "#gs.model.gf2.sharkry" } )
		local Button = vgui.Create( "DButton", pnl ) // Create the button and parent it to the frame
		local WorkshopID = 3029152157
		if steamworks.IsSubscribed( WorkshopID ) then
			Button:SetText( "#GS.ADDON.INSTALLED" )					// Set the text on the button
			Button:SetEnabled( false )
		else
			Button:SetText( "#GS.ADDON.INSTALL" )					// Set the text on the button
			Button:SetEnabled( true )
		end
		Button:SetPos( X, 298 )					// Set the position on the frame
		Button:SetSize( 100, 25 )					// Set the size
		Button.DoClick = function()
			gui.OpenURL( WorkshopLink..WorkshopID ) 
		end
		pnl:AddControl( "label", { Text = "" } )
		
		pnl:AddControl( "label", { Text = "#gs.model.gf2.vepley" } )
		local Button = vgui.Create( "DButton", pnl ) // Create the button and parent it to the frame
		local WorkshopID = 3026550750
		if steamworks.IsSubscribed( WorkshopID ) then
			Button:SetText( "#GS.ADDON.INSTALLED" )					// Set the text on the button
			Button:SetEnabled( false )
		else
			Button:SetText( "#GS.ADDON.INSTALL" )					// Set the text on the button
			Button:SetEnabled( true )
		end
		Button:SetPos( X, 344 )					// Set the position on the frame
		Button:SetSize( 100, 25 )					// Set the size
		Button.DoClick = function()
			gui.OpenURL( WorkshopLink..WorkshopID ) 
		end
		pnl:AddControl( "label", { Text = "" } )
		
		pnl:AddControl( "label", { Text = "#gs.model.gf2.lenna" } )
		local Button = vgui.Create( "DButton", pnl ) // Create the button and parent it to the frame
		local WorkshopID = 3167885628
		if steamworks.IsSubscribed( WorkshopID ) then
			Button:SetText( "#GS.ADDON.INSTALLED" )					// Set the text on the button
			Button:SetEnabled( false )
		else
			Button:SetText( "#GS.ADDON.INSTALL" )					// Set the text on the button
			Button:SetEnabled( true )
		end
		Button:SetPos( X, 390 )					// Set the position on the frame
		Button:SetSize( 100, 25 )					// Set the size
		Button.DoClick = function()
			gui.OpenURL( WorkshopLink..WorkshopID ) 
		end
		pnl:AddControl( "label", { Text = "" } )
		
		pnl:AddControl( "label", { Text = "#gs.model.gf2.charolic" } )
		local Button = vgui.Create( "DButton", pnl ) // Create the button and parent it to the frame
		local WorkshopID = 3036390025
		if steamworks.IsSubscribed( WorkshopID ) then
			Button:SetText( "#GS.ADDON.INSTALLED" )					// Set the text on the button
			Button:SetEnabled( false )
		else
			Button:SetText( "#GS.ADDON.INSTALL" )					// Set the text on the button
			Button:SetEnabled( true )
		end
		Button:SetPos( X, 436 )					// Set the position on the frame
		Button:SetSize( 100, 25 )					// Set the size
		Button.DoClick = function()
			gui.OpenURL( WorkshopLink..WorkshopID ) 
		end
		pnl:AddControl( "label", { Text = "" } )
		
		pnl:AddControl( "label", { Text = "#gs.model.gf2.jiangyu" } )
		local Button = vgui.Create( "DButton", pnl ) // Create the button and parent it to the frame
		local WorkshopID = 3131048843
		if steamworks.IsSubscribed( WorkshopID ) then
			Button:SetText( "#GS.ADDON.INSTALLED" )					// Set the text on the button
			Button:SetEnabled( false )
		else
			Button:SetText( "#GS.ADDON.INSTALL" )					// Set the text on the button
			Button:SetEnabled( true )
		end
		Button:SetPos( X, 482 )					// Set the position on the frame
		Button:SetSize( 100, 25 )					// Set the size
		Button.DoClick = function()
			gui.OpenURL( WorkshopLink..WorkshopID ) 
		end
		pnl:AddControl( "label", { Text = "" } )
		
		pnl:AddControl( "label", { Text = "#gs.model.gf2.tololo" } )
		local Button = vgui.Create( "DButton", pnl ) // Create the button and parent it to the frame
		local WorkshopID = 3039937937
		if steamworks.IsSubscribed( WorkshopID ) then
			Button:SetText( "#GS.ADDON.INSTALLED" )					// Set the text on the button
			Button:SetEnabled( false )
		else
			Button:SetText( "#GS.ADDON.INSTALL" )					// Set the text on the button
			Button:SetEnabled( true )
		end
		Button:SetPos( X, 528 )					// Set the position on the frame
		Button:SetSize( 100, 25 )					// Set the size
		Button.DoClick = function()
			gui.OpenURL( WorkshopLink..WorkshopID ) 
		end
		pnl:AddControl( "label", { Text = "" } )
		
		pnl:AddControl( "label", { Text = "#gs.model.gf2.nemesis" } )
		local Button = vgui.Create( "DButton", pnl ) // Create the button and parent it to the frame
		local WorkshopID = 3043985506
		if steamworks.IsSubscribed( WorkshopID ) then
			Button:SetText( "#GS.ADDON.INSTALLED" )					// Set the text on the button
			Button:SetEnabled( false )
		else
			Button:SetText( "#GS.ADDON.INSTALL" )					// Set the text on the button
			Button:SetEnabled( true )
		end
		Button:SetPos( X, 574 )					// Set the position on the frame
		Button:SetSize( 100, 25 )					// Set the size
		Button.DoClick = function()
			gui.OpenURL( WorkshopLink..WorkshopID ) 
		end
		pnl:AddControl( "label", { Text = "" } )
		
		pnl:AddControl( "label", { Text = "#gs.model.gf2.peritya" } )
		local Button = vgui.Create( "DButton", pnl ) // Create the button and parent it to the frame
		local WorkshopID = 3038490564
		if steamworks.IsSubscribed( WorkshopID ) then
			Button:SetText( "#GS.ADDON.INSTALLED" )					// Set the text on the button
			Button:SetEnabled( false )
		else
			Button:SetText( "#GS.ADDON.INSTALL" )					// Set the text on the button
			Button:SetEnabled( true )
		end
		Button:SetPos( X, 620 )					// Set the position on the frame
		Button:SetSize( 100, 25 )					// Set the size
		Button.DoClick = function()
			gui.OpenURL( WorkshopLink..WorkshopID ) 
		end
		pnl:AddControl( "label", { Text = "" } )
		
		pnl:AddControl( "label", { Text = "#gs.model.gf2.sabrina" } )
		local Button = vgui.Create( "DButton", pnl ) // Create the button and parent it to the frame
		local WorkshopID = 3042014691
		if steamworks.IsSubscribed( WorkshopID ) then
			Button:SetText( "#GS.ADDON.INSTALLED" )					// Set the text on the button
			Button:SetEnabled( false )
		else
			Button:SetText( "#GS.ADDON.INSTALL" )					// Set the text on the button
			Button:SetEnabled( true )
		end
		Button:SetPos( X, 666 )					// Set the position on the frame
		Button:SetSize( 100, 25 )					// Set the size
		Button.DoClick = function()
			gui.OpenURL( WorkshopLink..WorkshopID ) 
		end
		pnl:AddControl( "label", { Text = "" } )
		
		pnl:AddControl( "label", { Text = "#gs.model.gf2.gf2.qiongjiu" } )
		local Button = vgui.Create( "DButton", pnl ) // Create the button and parent it to the frame
		local WorkshopID = 3035525647
		if steamworks.IsSubscribed( WorkshopID ) then
			Button:SetText( "#GS.ADDON.INSTALLED" )					// Set the text on the button
			Button:SetEnabled( false )
		else
			Button:SetText( "#GS.ADDON.INSTALL" )					// Set the text on the button
			Button:SetEnabled( true )
		end
		Button:SetPos( X, 712 )					// Set the position on the frame
		Button:SetSize( 100, 25 )					// Set the size
		Button.DoClick = function()
			gui.OpenURL( WorkshopLink..WorkshopID ) 
		end
		
		pnl:AddControl( "label", { Text = "" } )
		pnl:AddControl( "label", { Text = "#gs.addon.additional" } )
		pnl:AddControl( "label", { Text = "" } )
		pnl:AddControl( "label", { Text = "#gs.addon.additional.gf2_combat" } )
		
		local Button = vgui.Create( "DButton", pnl ) // Create the button and parent it to the frame
		local WorkshopID = 3220684563
		if steamworks.IsSubscribed( WorkshopID ) then
			Button:SetText( "#GS.ADDON.INSTALLED" )					// Set the text on the button
			Button:SetEnabled( false )
		else
			Button:SetText( "#GS.ADDON.INSTALL" )					// Set the text on the button
			Button:SetEnabled( true )
		end
		Button:SetPos( X, 806 )					// Set the position on the frame
		Button:SetSize( 100, 25 )					// Set the size
		Button.DoClick = function()
			gui.OpenURL( WorkshopLink..WorkshopID ) 
		end
		
		pnl:AddControl( "label", { Text = "" } )
		pnl:AddControl( "label", { Text = "#gs.addon.additional.gf2_outfit" } )
		local Button = vgui.Create( "DButton", pnl ) // Create the button and parent it to the frame
		local WorkshopID = 3221849153
		if steamworks.IsSubscribed( WorkshopID ) then
			Button:SetText( "#GS.ADDON.INSTALLED" )					// Set the text on the button
			Button:SetEnabled( false )
		else
			Button:SetText( "#GS.ADDON.INSTALL" )					// Set the text on the button
			Button:SetEnabled( true )
		end
		Button:SetPos( X, 852 )					// Set the position on the frame
		Button:SetSize( 100, 25 )					// Set the size
		Button.DoClick = function()
			gui.OpenURL( WorkshopLink..WorkshopID ) 
		end
		
		pnl:AddControl( "label", { Text = "" } )
		pnl:AddControl( "label", { Text = "#gs.addon.additional.gf2_dorm" } )
		local Button = vgui.Create( "DButton", pnl ) // Create the button and parent it to the frame
		local WorkshopID = 3224747672
		if steamworks.IsSubscribed( WorkshopID ) then
			Button:SetText( "#GS.ADDON.INSTALLED" )					// Set the text on the button
			Button:SetEnabled( false )
		else
			Button:SetText( "#GS.ADDON.INSTALL" )					// Set the text on the button
			Button:SetEnabled( true )
		end
		Button:SetPos( X, 898 )					// Set the position on the frame
		Button:SetSize( 100, 25 )					// Set the size
		Button.DoClick = function()
			gui.OpenURL( WorkshopLink..WorkshopID ) 
		end
	end)
end)