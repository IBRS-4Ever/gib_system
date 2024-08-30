
AddCSLuaFile()

function FingerRotation(ent)
	if GetConVar( "gibsystem_random_finger_rotating" ):GetBool() then
		local Fingers = {
			["ValveBiped.Bip01_L_Finger1"] = Angle(math.Rand(-5,5),-25-math.Rand(0,4),0),
			["ValveBiped.Bip01_L_Finger11"] = Angle(0,-35-math.Rand(0,4),0),
			["ValveBiped.Bip01_L_Finger12"] = Angle(0,-25-math.Rand(0,4),0),
			["ValveBiped.Bip01_L_Finger2"] = Angle(math.Rand(-5,5),-26-math.Rand(0,4),0),
			["ValveBiped.Bip01_L_Finger21"] = Angle(0,-35-math.Rand(0,40),0),
			["ValveBiped.Bip01_L_Finger22"] = Angle(0,-25-math.Rand(0,40),0),
			["ValveBiped.Bip01_L_Finger3"] = Angle(math.Rand(-5,5),-25-math.Rand(0,4),0),
			["ValveBiped.Bip01_L_Finger31"] = Angle(0,-35-math.Rand(0,40),0),
			["ValveBiped.Bip01_L_Finger32"] = Angle(0,-25-math.Rand(0,40),0),
			["ValveBiped.Bip01_L_Finger4"] = Angle(math.Rand(-5,5),-25-math.Rand(0,30),0),
			["ValveBiped.Bip01_L_Finger41"] = Angle(0,-20-math.Rand(0,20),0),
			["ValveBiped.Bip01_L_Finger42"] = Angle(0,-20-math.Rand(0,3),0),
			["ValveBiped.Bip01_L_Finger0"] = Angle(0,10-math.Rand(0,2),0),
			["ValveBiped.Bip01_L_Finger01"] = Angle(0,20-math.Rand(0,2),0),
			["ValveBiped.Bip01_L_Finger02"] = Angle(0,25-math.Rand(0,3),0),
			["ValveBiped.Bip01_R_Finger1"] = Angle(math.Rand(-5,5),-25-math.Rand(0,4),0),
			["ValveBiped.Bip01_R_Finger11"] = Angle(0,-35-math.Rand(0,4),0),
			["ValveBiped.Bip01_R_Finger12"] = Angle(0,-25-math.Rand(0,4),0),
			["ValveBiped.Bip01_R_Finger2"] = Angle(math.Rand(-5,5),-27-math.Rand(0,4),0),
			["ValveBiped.Bip01_R_Finger21"] = Angle(0,-35-math.Rand(0,4),0),
			["ValveBiped.Bip01_R_Finger22"] = Angle(0,-25-math.Rand(0,4),0),
			["ValveBiped.Bip01_R_Finger3"] = Angle(math.Rand(-5,5),-25-math.Rand(0,4),0),
			["ValveBiped.Bip01_R_Finger31"] = Angle(0,-32-math.Rand(0,4),0),
			["ValveBiped.Bip01_R_Finger32"] = Angle(0,-20-math.Rand(0,40),0),
			["ValveBiped.Bip01_R_Finger4"] = Angle(math.Rand(-5,5),-25-math.Rand(0,30),0),
			["ValveBiped.Bip01_R_Finger41"] = Angle(0,-25-math.Rand(0,20),0),
			["ValveBiped.Bip01_R_Finger42"] = Angle(0,-25-math.Rand(0,3),0),
			["ValveBiped.Bip01_R_Finger0"] = Angle(0,10-math.Rand(0,2),0),
			["ValveBiped.Bip01_R_Finger01"] = Angle(0,20-math.Rand(0,2),0),
			["ValveBiped.Bip01_R_Finger02"] = Angle(0,25-math.Rand(0,3),0)
		}
		for bonename = 0 , ent:GetBoneCount() do 
			if Fingers[ent:GetBoneName(bonename)] != nil then
				ent:ManipulateBoneAngles(bonename,Fingers[ent:GetBoneName(bonename)])
			end
		end
	end

	if GetConVar("gibsystem_random_toe_rotating"):GetBool() then
		local Toes_Bones = { 
			["ValveBiped.Bip01_L_Toe0"] = true,
			["ValveBiped.Bip01_R_Toe0"] = true
		}
		for bonename = 0 , ent:GetBoneCount() do 
			if Toes_Bones[ ent:GetBoneName(bonename) ] then
				ent:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
			end
		end
	end

	if GetConVar("gibsystem_random_gf2_toe_rotating"):GetBool() then
		local GF2_Toes_Bones = { 
			["BigToe1_L"] = true,
			["BigToe2_L"] = true,
			["BigToe1_R"] = true,
			["BigToe2_R"] = true,
			["LongToe1_L"] = true,
			["LongToe2_L"] = true,
			["LongToe1_R"] = true,
			["LongToe2_R"] = true,
			["MiddleToe1_L"] = true,
			["MiddleToe2_L"] = true,
			["MiddleToe1_R"] = true,
			["MiddleToe2_R"] = true,
			["RingToe1_L"] = true,
			["RingToe2_L"] = true,
			["RingToe1_R"] = true,
			["RingToe2_R"] = true,
			["PinkyToe1_L"] = true,
			["PinkyToe2_L"] = true,
			["PinkyToe1_R"] = true,
			["PinkyToe2_R"] = true
		}
		for bonename = 0 , ent:GetBoneCount() do 
			if GF2_Toes_Bones[ ent:GetBoneName(bonename) ] then
				ent:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
			end
		end
	end
end
	