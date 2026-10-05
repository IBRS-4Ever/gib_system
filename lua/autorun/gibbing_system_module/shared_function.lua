
-- 全局列表
CharacterList = {}
Expressions_Table = {}
Model_Link_Materials = {}
GIRLS_FRONTLINE_2_MODELS = {}
SkinReplace_Table = {}
BlackListedModels = {}

if !file.Exists("gib_system/blacklist.txt", "DATA") then
	file.Write("gib_system/blacklist.txt", util.TableToJSON(BlackListedModels) )
else
	BlackListedModels = util.JSONToTable( file.Read("gib_system/blacklist.txt", "DATA") )
end

function GibSystem_GetBlacklist()
	return BlackListedModels
end

function GibSystem_AddBlacklist(character)
	if BlackListedModels[character] then
		print(language.FormatPhrase("GS.ConsoleMSG.RemoveFromBlacklist", language.GetPhrase("gs.model."..character) ) )
		BlackListedModels[character] = nil
	else
		print(language.FormatPhrase("GS.ConsoleMSG.AddedToBlacklist", language.GetPhrase("gs.model."..character) ) )
		BlackListedModels[character] = true
	end
	file.Write("gib_system/blacklist.txt", util.TableToJSON(BlackListedModels) )
end

function GibSystem_FacePose(ent)
	if GetConVar( "gibsystem_death_express" ):GetBool() then
		local num_expressions = ent:GetFlexNum() 												// 获取模型的表情数量
		local ModelExpressions = Expressions_Table[ent.Model] 									// 获取表情列表中该模型的表情值。
		local Expressions = {}
		
		if ModelExpressions then 																// 如果 ModelExpressions 表中有该模型的表情值，则从表中读取。
			Expressions = ModelExpressions[math.random( #ModelExpressions )]
		elseif GIRLS_FRONTLINE_2_MODELS[ent.Model] then 										// 如果是少前2的模型，则套用以下值。
			Expressions = {
				["eye_blink_left"] = {0.5,1},
				["eye_blink_right"] = {0.5,1},
				["brows_worry"] = {0.5,1},
				["mouth_surprised"] = {0.5,1},
				["eyes_look_up"] = {0.5,1},
				["mouth_angry_teeth"] = {0.25,0.5},
				["mouth_teeth_angry"] = {0.25,0.5},
				["mouth_wide_open"] = {0.1,0.3}
			}
		else
			Expressions = { ["blink"] = math.Rand(0.5,1) }
		end
		
		for i = 0, num_expressions - 1 do
			local name = string.lower(ent:GetFlexName(i))
			if Expressions[name] != nil then
				if !istable(Expressions[name]) then
					ent:SetFlexWeight(i, Expressions[name])
				else
					ent:SetFlexWeight(i, math.Rand(Expressions[name][1],Expressions[name][2]))
				end
			end
		end
	end
end

function GibSystem_LoadModels()
	local files, dir = file.Find("autorun/gibbing_system/*", "LUA")
	CharacterList = {}
	for _, folder in ipairs(dir or {}) do
		for _, CharacterList in ipairs(file.Find("autorun/gibbing_system/list/*", "LUA") or {}) do
			include("autorun/gibbing_system/list/" .. CharacterList)
			AddCSLuaFile("autorun/gibbing_system/list/" .. CharacterList)
			print( "[碎尸系统] 已加载模型列表 "..tostring(CharacterList:gsub("%.lua$", "")) )
		end
	end
	for _, filename in ipairs(files) do
		if string.find( filename, "disabled_" ) then print( "[碎尸系统] 已跳过未使用的模型 "..tostring(filename:gsub("%.lua$", ""):gsub("disabled_", "")) ) continue end
		AddCSLuaFile("autorun/gibbing_system/" .. filename)
		include("autorun/gibbing_system/" .. filename)
		table.insert(CharacterList, tostring(filename:gsub("%.lua$", "")))
	end
	return CharacterList
end

function CheckFedhoria()
	return file.Exists( "fedhoria/modules.lua", "LUA" )
end
