
include("autorun/gibbing_system_module/models.lua")

local ConVarsDefault = {
	gibsystem_enabled = "1",
	gibsystem_gibbing_player = "1",
	gibsystem_gibbing_npc = "1",
	gibsystem_gib_base_on_model = "1",
	gibsystem_random_finger_rotating = "1",
	gibsystem_random_toe_rotating = "1",
	gibsystem_random_gf2_toe_rotating = "0",
	gibsystem_random_bodygroup = "1",
	gibsystem_random_skin = "0",
	gibsystem_death_express = "1",
	gibsystem_ragdoll_convulsion = "0",
	gibsystem_ragdoll_collisiongroup = "11",
	gibsystem_deathcam_enable = "1",
	gibsystem_deathcam_mode = "1",
	gibsystem_gib_group = "headless",
	gibsystem_model_category = "1",
	gibsystem_gib_name = "random",
	gibsystem_head_mass = "0",
	gibsystem_body_mass = "0",
	gibsystem_ragdoll_removetimer = "15",
	gibsystem_rope = "0",
	gibsystem_rope_strength = "1000",
	gibsystem_blood_effect = "0",
	gibsystem_blood_decal = "1",
	gibsystem_blood_time = "5",
	gibsystem_blood_time_body = "15",
	gibsystem_deathanimation = "0",
	gibsystem_deathanimation_name = "random",
	gibsystem_pee = "0",
	gibsystem_pee_time = "10",
}

local convulsionmode = {}
convulsionmode["#gs.convulsionmode.none"] = {gibsystem_ragdoll_convulsion = "0"}
convulsionmode["#gs.convulsionmode.default"] = {gibsystem_ragdoll_convulsion = "1"}
if CheckFedhoria() then
	convulsionmode["#gs.convulsionmode.fedhoria"] = {gibsystem_ragdoll_convulsion = "2"}
else
	convulsionmode["#gs.convulsionmode.fedhoria_not_installed"] = {gibsystem_ragdoll_convulsion = "2"}
end

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
gibgroup["#gs.gibgroup.random"] = {gibsystem_gib_group = "random"}
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
gibgroup["#gs.gibgroup.upper_and_lower"] = {gibsystem_gib_group = "upper_and_lower"}
gibgroup["#gs.gibgroup.left_and_right"] = {gibsystem_gib_group = "left_and_right"}

hook.Add("AddToolMenuTabs", "GIBBING_SYSTEM_ADDMENU", function()
	spawnmenu.AddToolCategory("Options", "GIBBING SYSTEM Settings", "#GS.Title")
end)

hook.Add("PopulateToolMenu","GIBBING_SYSTEM_MENU",function()
	spawnmenu.AddToolMenuOption("Options", "GIBBING SYSTEM Settings", "Gibbing System", "#GS.Settings","","",function(pnl)
		if game.SinglePlayer() or LocalPlayer():IsAdmin() then
			pnl:ClearControls()
			pnl:AddControl( "ComboBox", { MenuButton = 1, Folder = "gib_system", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )
			pnl:CheckBox("#GS.Enable", "gibsystem_enabled")
			pnl:CheckBox("#GS.Gib_Players", "gibsystem_gibbing_player")
			pnl:CheckBox("#GS.Gib_NPCs", "gibsystem_gibbing_npc")
			pnl:CheckBox("#GS.Gib_Base_On_Model", "gibsystem_gib_base_on_model")
			pnl:CheckBox("#GS.Random.Finger_Rotating", "gibsystem_random_finger_rotating")
			pnl:CheckBox("#GS.Random.Toe_Rotating", "gibsystem_random_toe_rotating")
			pnl:CheckBox("#GS.Random.GF2_Toe_Rotating", "gibsystem_random_gf2_toe_rotating")
			pnl:CheckBox("#GS.Random.Bodygroup", "gibsystem_random_bodygroup")
			pnl:CheckBox("#GS.Random.Skin", "gibsystem_random_skin")
			pnl:CheckBox("#GS.DeathExpress", "gibsystem_death_express")
			pnl:AddControl( "ComboBox", { Label = "#GS.Ragdoll_Convulsion", Options = convulsionmode } )
			pnl:AddControl( "ComboBox", { Label = "#GS.GibsCollision", Options = collisiongroup } )
			pnl:AddControl( "ComboBox", { Label = "#GS.Deathcam.Mode", Options = cammode } )
			pnl:CheckBox("#GS.Deathcam.FirstPerson", "GibSystem_cam")
			pnl:CheckBox("#GS.Deathcam.FirstPerson_HideHair", "GibSystem_hair")
			pnl:AddControl( "ComboBox", { Label = "#GS.GibGroup", Options = gibgroup } )
			pnl:CheckBox("#GS.CategorizeModels", "gibsystem_model_category")
				
			local Button = vgui.Create( "DButton", pnl ) 	// 创建按钮，附加到面板上
			Button:SetText( "#GS.GibName" )					// 设置按钮文本
			Button:SetSize( 100, 25 )						// 设置按钮大小
			pnl:AddItem(Button)
			Button.DoClick = function()
				
				local GibModels = GibSystem_LoadModels()
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
					
				// 将模型分类
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
				icon:SetMaterial( "gib_system/random.png" )
				icon:SetName( "#gs.model.random" )
				icon.DoClick = function()
					RunConsoleCommand( "gibsystem_gib_name", "random" )
				frame:Close()
				end
				PropPanel:Add( icon )

				if GetConVar("gibsystem_model_category"):GetBool() then
					for CategoryName, v in SortedPairs(Categories) do
					
						local Header = vgui.Create( "ContentHeader", PropPanel )
						Header:SetText( CategoryName )
						PropPanel:Add( Header )
							
						for name, ent in SortedPairs(v) do
							local icon = vgui.Create( "ContentIcon", PropPanel )
							icon:SetMaterial( "gib_system/" .. name .. ".png" ) 
							icon:SetName( "#gs.model." .. name )

							icon.DoClick = function()
								RunConsoleCommand( "gibsystem_gib_name", name )
								frame:Close()
							end
							icon.DoRightClick = function()
								RunConsoleCommand( "gibsystem_blacklist_add", name )
							end

							PropPanel:Add( icon )
						end
					end
				else
					for _, Character in ipairs(GibModels) do

						local icon = vgui.Create( "ContentIcon", PropPanel )
						icon:SetMaterial( "gib_system/" .. Character .. ".png" ) 
						icon:SetName( "#gs.model." .. Character )

						icon.DoClick = function()
							RunConsoleCommand( "gibsystem_gib_name", Character )
							frame:Close()
						end
						icon.DoRightClick = function()
							RunConsoleCommand( "gibsystem_blacklist_add", Character )
						end
						PropPanel:Add( icon )
					end
				end
				local NoteFrame = vgui.Create( "Panel", frame )
				NoteFrame:SetHeight( 75 )
				NoteFrame:Dock( BOTTOM )
				NoteFrame:DockMargin( 0, 5, 0, 0 )
				function NoteFrame:Paint( w, h )
					draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0) )
				end
		
				local Note = vgui.Create( "DLabel", NoteFrame )
				Note:Dock( FILL )
				Note:SetHeight( 35 )
				Note:SetContentAlignment( 5 )
				Note:SetTextColor( color_white )
				Note:SetFont( "DermaLarge" )
				Note:SetText( "#gs.character_selector.blacklist_help" )
			end
				
			pnl:TextEntry("#GS.HeadMess", "gibsystem_head_mass")
			pnl:TextEntry("#GS.BodyMess", "gibsystem_body_mass")
			pnl:NumSlider("#GS.GibsRemoveTimer", "gibsystem_ragdoll_removetimer", 0, 100, 0)
			pnl:CheckBox("#GS.Rope", "gibsystem_rope")
			pnl:NumSlider("#GS.Rope_Strength", "gibsystem_rope_strength", 0, 5000, 0)
			pnl:CheckBox("#GS.BloodDecal", "gibsystem_blood_decal")
			pnl:CheckBox("#GS.BloodEffect", "gibsystem_blood_effect")
			pnl:NumSlider("#GS.BloodEffectLength", "gibsystem_blood_time", 0, 100, 0)
			pnl:NumSlider("#GS.BodyBloodEffectLength", "gibsystem_blood_time_body", 0, 100, 0)
			pnl:CheckBox("#GS.Pee", "gibsystem_pee")
			pnl:NumSlider("#GS.PeeLength", "gibsystem_pee_time", 0, 20, 0)
			
			pnl:CheckBox("#GS.DeathAnimation", "gibsystem_deathanimation")
			pnl:CheckBox("#GS.DeathAnimation_Alt", "gibsystem_deathanimation_alt")
			pnl:Help("#GS.DeathAnimation_Alt.Desc")
			pnl:TextEntry("#GS.DeathAnimation_BodyHealth", "gibsystem_deathanimation_body_health")
			pnl:Button("#GS.Cleanup_Gibs", "GibSystem_CleanGibs")
			pnl:Button("#GS.Reload_Models", "GibSystem_ReloadModels")
		end
	end)

	spawnmenu.AddToolMenuOption("Options", "GIBBING SYSTEM Settings", "Gibbing System Addons", "#GS.Addons","","",function(pnl)
		
		local WorkshopLink = "https://steamcommunity.com/sharedfiles/filedetails/?id="
		
		pnl:ClearControls()
		pnl:AddControl( "label", { Text = "#gs.addon.hint" } )
		pnl:AddControl( "label", { Text = "#gs.addon.required" } )
		
		local AppList = vgui.Create( "DListView", pnl )
		AppList:Dock( FILL )
		AppList:SetSize(100, 307) // 大小
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
			["#gs.addon.extension.extra_gibs"] = 3277262546,
			["#gs.addon.extension.honkai_star_rail"] = 3343204403,
			["#gs.addon.extension.vrc"] = 3343971543,
			["#gs.addon.extension.punishing_gray_raven"] = 3366315415
		}
		
		local AppListExt = vgui.Create( "DListView", pnl )
		AppListExt:Dock( FILL )
		AppListExt:SetSize(100, 307) // 大小
		AppListExt:SetMultiSelect( false )
		AppListExt:AddColumn( "#gs.addon" ):SetWidth(200)
		AppListExt:AddColumn( "#gs.addon.ID" )
		
		for k,v in pairs(ExtAddons) do
			AppListExt:AddLine( k, v )
		end
		
		AppListExt.DoDoubleClick = function( lst, index, pnl )
			gui.OpenURL( WorkshopLink..pnl:GetColumnText( 2 ) )
		end
		
		pnl:AddItem(AppListExt)
		
		pnl:AddControl( "label", { Text = "#gs.OpenURL_GitHub.Title" } )
		local GitHub = vgui.Create( "DButton", pnl ) 			// 创建按钮，附加到面板上
		GitHub:SetText( "#GS.OpenURL_GitHub" )					// 设置按钮文本		
		GitHub:SetSize( 100, 25 )								// 设置按钮大小
		pnl:AddItem(GitHub)
		GitHub.DoClick = function()
			gui.OpenURL( "https://github.com/IBRS-4Ever/gib_system" )
		end
	end)
end)
