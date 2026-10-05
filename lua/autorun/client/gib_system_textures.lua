
local Skins = {}
local WetSkins = {}

local function GFL2CreateSkinTexture(name,texture,normal,exponent,wet)
	CreateMaterial( "models/gfl2_shared/"..name, "VertexLitGeneric", {
		["$basetexture"] = "models/"..texture,
		["$bumpmap"] = "models/"..normal,
		
		["$lightwarptexture"] = "models/gfl2_shared/toon_skin",
		
		["$phong"] = 1,
		["$halflambert"] = 1,
		["$phongboost"] = 1,
		["$phongalbedotint"] = 1,
		["$phongalbedoboost"] = 12,
		["$phongexponenttexture"] = "models/"..exponent,
		["$phongfresnelranges"] = "[2 3 4]",
		
		["$rimlight"] = 1,
		["$rimlightexponent"] = 1,
		["$rimlightboost"] = 1,

		["$color2"] = "[1.50 1.50 1.50]"
	} )
	Skins[#Skins + 1] = "!models/gfl2_shared/"..name
	if wet then
		WetSkins[#WetSkins + 1] = "!models/gfl2_shared/"..name
	end
end

function GibSystem_GetSkinList()
	return Skins
end

function GibSystem_GetWetSkinList()
	return WetSkins
end

function GibSystem_AddSkinList(Texture)
	Skins[#Skins + 1] = Texture
end

GFL2CreateSkinTexture( "b_body_nemesis", "gfl2_nemesis/nemesis_dorm_body_d", "gfl2_shared/b_body_n", "gfl2_shared/b_body_e", true )
GFL2CreateSkinTexture( "a_body_nemesis", "gfl2_nemesis_gnosis/nemesis_gnosis_dorm_body2_d", "gfl2_shared/a_body_n", "gfl2_shared/a_body_e" )
GFL2CreateSkinTexture( "b_body_sabrina", "gfl2_sabrina/sabrina_berry_zabaione_body_d", "gfl2_shared/b_body_n", "gfl2_shared/b_body_e", true )
GFL2CreateSkinTexture( "a_body_agent", "gfl2_agent/agent_body_skin_d", "gfl2_shared/a_body_n", "gfl2_shared/a_body_e" )
GFL2CreateSkinTexture( "b_body_zhaohui", "gfl2_zhaohui/zhaohui_dorm_body2_d", "gfl2_shared/b_body_n", "gfl2_shared/b_body_e", true )
GFL2CreateSkinTexture( "b_body_harpsy", "gfl2_harpsy/harpsy_dorm_body2_d", "gfl2_shared/b_body_n", "gfl2_shared/b_body_e", true )
GFL2CreateSkinTexture( "b_body_lainie", "gfl2_lainie/lainie_dorm_body2_d", "gfl2_shared/b_body_n", "gfl2_shared/b_body_e", true )
GFL2CreateSkinTexture( "b_body_sextans", "gfl2_sextans/sextans_dorm_body2_d", "gfl2_shared/b_body_n", "gfl2_shared/b_body_e", true )
