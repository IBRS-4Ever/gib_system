
include("autorun/gibbing_system/models.lua")

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
-- gibgroup["#gs.gibgroup.random"] = {gibsystem_gib_group = "random"}
gibgroup["#gs.gibgroup.headless"] = {gibsystem_gib_group = "headless"}
gibgroup["#gs.gibgroup.limbs"] = {gibsystem_gib_group = "limbs"}
--[[
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
]]--
gibgroup["#gs.gibgroup.legs_and_torso"] = {gibsystem_gib_group = "legs_&_torso"}

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
		pnl:AddControl( "CheckBox", { Label = "#GS.DeathExpress", Command = "gibsystem_death_express" } )
		pnl:AddControl( "ComboBox", { Label = "#GS.Ragdoll_Convulsion", Options = convulsionmode } )
		pnl:AddControl( "ComboBox", { Label = "#GS.GibsCollision", Options = collisiongroup } )
		pnl:AddControl( "CheckBox", { Label = "#GS.Deathcam", Command = "gibsystem_deathcam_enable" } )
		pnl:AddControl( "ComboBox", { Label = "#GS.Deathcam.Mode", Options = cammode } )
		pnl:AddControl( "ComboBox", { Label = "#GS.GibGroup", Options = gibgroup } )
		
		local Button = vgui.Create( "DButton", pnl ) // Create the button and parent it to the frame
		Button:SetText( "#GS.GibName" )					// Set the text on the button		
		Button:SetSize( 100, 25 )					// Set the size
		pnl:AddItem(Button)
		Button.DoClick = function()
			local frame = vgui.Create( "DFrame" )
			frame:SetSize( ScrW() / 1.2, ScrH() / 1.1 )
			frame:SetTitle( string.format( language.GetPhrase("#gs.choose_character"), language.GetPhrase("#gs.model."..GetConVar("gibsystem_gib_name"):GetString()) ) )
			frame:Center()

			frame:MakePopup()

			frame:SetDraggable( false )

			function frame:Paint( w, h )
				Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
			end

			local PropPanel = vgui.Create( "ContentContainer", frame )
			PropPanel:SetTriggerSpawnlistChange( false )
			PropPanel:Dock( FILL )

			local EntList = list.Get("GIBSYSTEM_CATEGORY_INFO")
			
			for _, Model in ipairs(GibModels) do
				if !list.HasEntry("GIBSYSTEM_CATEGORY_INFO",Model) then
					list.Set("GIBSYSTEM_CATEGORY_INFO", Model,{})
				end
			end
			
			-- Categorize them
			local Categories = {}
			for k, v in pairs(EntList) do
				local Category = v.Category or "#gs.category.uncategorized"
				local Tab = Categories[Category] or {}
				Tab[k] = v
				Categories[Category] = Tab
			end
			
			local DefaultHeader = vgui.Create( "ContentHeader", PropPanel )
			DefaultHeader:SetText( "#gs.category.default" )
			PropPanel:Add( DefaultHeader )
				
			local icon = vgui.Create( "ContentIcon", PropPanel )
			icon:SetMaterial( "gib_system/default.png" )
			icon:SetName( "#gs.model.default" )
			icon.DoClick = function()
				RunConsoleCommand( "gibsystem_gib_name", "random" )
			frame:Close()
			end
			PropPanel:Add( icon )

			for CategoryName, v in SortedPairs(Categories) do
			
				local Header = vgui.Create( "ContentHeader", PropPanel )
				Header:SetText( CategoryName )
				PropPanel:Add( Header )
				
				for name, ent in SortedPairsByMemberValue(v, "Name") do
					local icon = vgui.Create( "ContentIcon", PropPanel )
					icon:SetMaterial( "gib_system/" .. name .. ".png" )
					icon:SetName( "#gs.model." .. name )

					icon.DoClick = function()
						RunConsoleCommand( "gibsystem_gib_name", name )
					frame:Close()
					end
					PropPanel:Add( icon )
				end
			end
		end
		
		pnl:AddControl( "textbox", { Label = "#GS.HeadMess", Command = "gibsystem_head_mass" } )
		pnl:AddControl( "textbox", { Label = "#GS.BodyMess", Command = "gibsystem_body_mass" } )
		pnl:AddControl( "Slider", { Label = "#GS.GibsRemoveTimer", Type = "Integer", Command = "gibsystem_ragdoll_removetimer", Min = "-1", Max = "100" } )
		pnl:AddControl( "CheckBox", { Label = "#GS.Rope", Command = "gibsystem_rope" } )
		pnl:AddControl( "Slider", { Label = "#GS.Rope_Strength", Type = "Integer", Command = "gibsystem_rope_strength", Min = "0", Max = "5000" } )
		pnl:AddControl( "CheckBox", { Label = "#GS.BloodEffect", Command = "gibsystem_blood_effect" } )
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
		
		pnl:ClearControls()
		pnl:AddControl( "label", { Text = "#gs.addon.hint" } )
		pnl:AddControl( "label", { Text = "#gs.addon.required" } )
		
		local AppList = vgui.Create( "DListView", pnl )
		AppList:Dock( FILL )
		AppList:SetSize(100, 307) -- Size
		AppList:SetMultiSelect( false )
		AppList:AddColumn( "#gs.addon" ):SetWidth(200)
		AppList:AddColumn( "#gs.addon.ID" )

		AppList:AddLine( "#gs.Collection.GF2", "3256248084" )

		AppList.DoDoubleClick = function( lst, index, pnl )
			gui.OpenURL( WorkshopLink..pnl:GetColumnText( 2 ) )
		end
		
		pnl:AddItem(AppList)
		
		pnl:AddControl( "label", { Text = "" } )
		pnl:AddControl( "label", { Text = "#gs.addon.extension" } )
		
		local ExtAddons = {
			["#gs.addon.extension.gf2_combat"] = 3220684563,
			["#gs.addon.extension.gf2_outfit"] = 3221849153,
			["#gs.addon.extension.gf2_dorm"] = 3224747672,
			["#gs.addon.extension.snowbreak"] = 3257369456,
			["#gs.addon.extension.arknights"] = 3277264014,
			["#gs.addon.extension.honkai_impact_3rd"] = 3277267079,
			["#gs.addon.extension.extra_gibs"] = 3277262546
		}
		
		local AppListExt = vgui.Create( "DListView", pnl )
		AppListExt:Dock( FILL )
		AppListExt:SetSize(100, 307) -- Size
		AppListExt:SetMultiSelect( false )
		AppListExt:AddColumn( "#gs.addon" ):SetWidth(200)
		AppListExt:AddColumn( "#gs.addon.ID" )
		
		for k,v in pairs(ExtAddons) do
			-- print(v..", "..k)
			AppListExt:AddLine( k, v )
		end
		
		AppListExt.DoDoubleClick = function( lst, index, pnl )
			gui.OpenURL( WorkshopLink..pnl:GetColumnText( 2 ) )
		end
		
		pnl:AddItem(AppListExt)
		
	end)
end)