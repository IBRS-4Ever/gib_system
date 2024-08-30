
AddCSLuaFile()

function GibFacePose(ent)
	if GetConVar( "gibsystem_death_express" ):GetBool() then
		local Exp = {}
		local num_expressions = ent:GetFlexNum() -- 获取模型的表情数量
		if Model == "platinum" then
			local flex = math.random(1,2)
			if flex == 1 then
				Exp = {
					["blink"] = math.Rand(0.5,1),
					["mouth disgust"] = 1,
					["brows sad"] = 1
				}
			else
				Exp = {
					["eye look up"] = 0.75,
					["mouth disgust"] = 1,
					["brows sad"] = 1,
					["eyes shock"] = math.Rand(0.25,0.5)
				}
			end
		elseif Model == "amiya" then
			Exp = {
				["blink"] = math.Rand(0.5,1),
				["e"] = 1,
				["pupil"] = math.Rand(0.5,1),
				["brows sad"] = 1
			}
		elseif Model == "skyfire" then
			Exp = {
				["blink"] = math.Rand(0.25,1),
				["mouth ah"] = math.Rand(0,1),
				["brows worry 2"] = 1
			}
		elseif Model == "skadi" then
			local flex = math.random(1,2)
			if flex == 1 then
				Exp = {
					["blink"] = math.Rand(0.5,1),
					["mouthdisgust"] = 1,
					["browssad"] = 1
				}
			else
				Exp = {
					["eyelookup"] = 0.75,
					["mouthsadopen"] = 1,
					["browssad"] = 1,
					["eyesshock"] = math.Rand(0.25,0.75)
				}
			end
		elseif Model == "skadi_alter" then
			Exp = { ["eyeslookup"] = 1 }
		elseif Model == "provence" then
			local flex = math.random(1,3)
			local Exp_Value = {}
			if flex == 1 then
				Exp = {
					["blink"] = math.Rand(0.5,1),
					["mouth corner lower"] = 1,
					["mouth n"] = 1,
					["mouth i"] = 1,
					["brow sad"] = 1
				}
			elseif flex == 2 then
				Exp = {
					["eye scale"] = 0.5,
					["eye up"] = 0.25,
					["mouth a 2"] = math.Rand(0.5,1),
					["mouth corner lower"] = 1,
					["brow sad"] = 1
				}
			else
				Exp = {
					["mouth a"] = math.Rand(0.3,0.7),
					["brow sad"] = 1,
					["blink"] = math.Rand(0.5,1),
					["mouth corner lower"] = 1,
					["eye up"] = 0.3
				}
			end
		elseif Model == "sora" then
			Exp = {
				["blink"] = math.Rand(0.5,1),
				["eye look up"] = math.Rand(0.5,1),
				["mouth sad"] = 1,
				["mouth aah"] = 1,
				["teeth up"] = 0.1,
				["teeth down"] = 0.1,
				["brows worry"] = 1
			}
		elseif Model == "rosmontis" then
			Exp = {
				["eyescryingop"] = 1,
				["mouthshockedop"] = 0.3,
				["eyebrowsshockedcl"] = 1
			}
		elseif Model == "schwarz" then
			Exp = { ["blink"] = 0.7 }
		elseif Model == "chen" then
			Exp = {
				["blink"] = math.Rand(0.5,1),
				["hmm"] = 1,
				["sad"] = 1
			}
		elseif Model == "lapluma" then
			Exp = {
				["blink left"] = math.Rand(0.5,1),
				["blink right"] = math.Rand(0.5,1),
				["mouth sad open"] = math.Rand(0.5,1),
				["brow worry"] = 1
			}
		elseif list.HasEntry( "GIBSYSTEM_GIRLS_FRONTLINE_2_MODELS", Model ) then
			Exp = {
				["eye_blink_left"] = math.Rand(0.5,1),
				["eye_blink_right"] = math.Rand(0.5,1),
				["brows_worry"] = math.Rand(0.5,1),
				["mouth_surprised"] = math.Rand(0.5,1),
				["eyes_look_up"] = math.Rand(0.5,1),
				["mouth_angry_teeth"] = math.Rand(0.25,0.5),
				["mouth_wide_open"] = math.Rand(0.1,0.3)
			}
		else
			Exp = { ["blink"] = math.Rand(0.5,1) }
		end
		for i = 0, num_expressions - 1 do
			local name = string.lower(ent:GetFlexName(i))
			if Exp[name] != nil then
				ent:SetFlexWeight(i, Exp[name])
			end
		end
	end
end
