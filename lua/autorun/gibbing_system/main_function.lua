
AddCSLuaFile()

local GmodLanguage = string.lower(GetConVar("gmod_language"):GetString())

function LocalizedText(lang,text)
	local DefaultLang = "en-us"
	if GmodLanguage == lang then
		MsgN(text)
	end
end

function GSLanguageChanged()
	GmodLanguage = string.lower(GetConVar("gmod_language"):GetString())
end
cvars.AddChangeCallback( "gmod_language", GSLanguageChanged, "GSLanguageChanged" )

Model_Path = "autorun/gibbing_system/models/"
Model_Table = {}

Expressions_Table = {}

GibModels = {}

files, _ = file.Find("autorun/gibbing_system/models/*.lua", "LUA")

LocalizedText("zh-cn","[碎尸系统] 正在加载文件...")
LocalizedText("en","[Gibbing System] Loading Files...")

if file.Exists( "fedhoria/modules.lua", "LUA" ) then
	include("fedhoria/modules.lua")
	LocalizedText("zh-cn","[碎尸系统] 已检测到 Fedhoria 并已加载。")
	LocalizedText("en","[Gibbing System] Fedhoria detected and loaded.")
else
	LocalizedText("zh-cn","[碎尸系统] 未发现 Fedhoria。")
	LocalizedText("en","[Gibbing System] Can't find Fedhoria.")
end

for _, filename in ipairs(files) do
	AddCSLuaFile("autorun/gibbing_system/models/" .. filename)
	include("autorun/gibbing_system/models/" .. filename)
	LocalizedText("zh-cn","[碎尸系统] 已加载文件 "..filename:gsub("%.lua$", ""))
	LocalizedText("en","[Gibbing System] Loaded file "..filename:gsub("%.lua$", ""))
	util.PrecacheModel("models/gib_system/"..filename:gsub("%.lua$", "").."_headless.mdl")
	util.PrecacheModel("models/gib_system/"..filename:gsub("%.lua$", "").."_head.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/left_leg.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/right_leg.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/left_arm.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/right_arm.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/torso.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_legs.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_arms.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_right_leg_left_arm.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_left_leg_right_arm.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_left_leg.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_right_leg.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_left_arm.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_arms.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_right_arm.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_right.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_left.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_right_no_arm.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_left_no_arm.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_right_no_leg.mdl")
	util.PrecacheModel("models/gib_system/limbs/"..filename:gsub("%.lua$", "").."/no_limb/no_left_no_leg.mdl")
	util.PrecacheModel("models/gib_system/"..filename:gsub("%.lua$", "").."_legs.mdl")
	util.PrecacheModel("models/gib_system/"..filename:gsub("%.lua$", "").."_torso.mdl")
	table.insert(GibModels, tostring(filename:gsub("%.lua$", "")))
end

LocalizedText("zh-cn","[碎尸系统] 加载完成。\n")
LocalizedText("en","[Gibbing System] Loading Complete.\n")
