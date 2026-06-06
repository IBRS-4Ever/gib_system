
AddCSLuaFile()

function GibFacePose(ent)
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
		else 																					// 如果以上都不满足，则只调整 blink 的值。
			Expressions = { ["blink"] = math.Rand(0.5,1) }
		end
		
		for i = 0, num_expressions - 1 do
			local name = string.lower(ent:GetFlexName(i)) 										// 将表情名称的字符串变为小写。
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
