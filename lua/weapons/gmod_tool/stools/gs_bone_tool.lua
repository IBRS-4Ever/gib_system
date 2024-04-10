
TOOL.Category = "Poser"
TOOL.Name = "#tool.gs_bone_tool.name"
TOOL.ClientConVar[ "fingers" ] = 1
TOOL.ClientConVar[ "toes" ] = 1
TOOL.ClientConVar[ "gf2_toes" ] = 0

function TOOL:Click( tr )
	if CLIENT then return true end
	if ( IsValid( tr.Entity ) ) then
		Gib = tr.Entity
		for bonename = 0 , Gib:GetBoneCount() do 
			if GetConVar("gs_bone_tool_fingers"):GetBool() then
				if Gib:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger0' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,10-math.Rand(0,2),0))   
				elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger0' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,10-math.Rand(0,2),0))   
				elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger1' then
				   Gib:ManipulateBoneAngles(bonename,Angle(math.Rand(-5,5),-25-math.Rand(0,4),0))   
				elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger11' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,-35-math.Rand(0,4),0))    
				elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger12' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,-25-math.Rand(0,4),0))
				elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger2' then
				   Gib:ManipulateBoneAngles(bonename,Angle(math.Rand(-5,5),-26-math.Rand(0,4),0))   
				elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger21' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,-35-math.Rand(0,40),0))    
				elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger22' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,-25-math.Rand(0,40),0))  
				elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger3' then
				   Gib:ManipulateBoneAngles(bonename,Angle(math.Rand(-5,5),-25-math.Rand(0,4),0))   
				elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger31' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,-35-math.Rand(0,40),0))    
				elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger32' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,-25-math.Rand(0,40),0))
				elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger4' then
				   Gib:ManipulateBoneAngles(bonename,Angle(math.Rand(-5,5),-25-math.Rand(0,30),0))   
				elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger41' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,-20-math.Rand(0,20),0))    
				elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger42' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,-20-math.Rand(0,3),0))    
				elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger1' then
				   Gib:ManipulateBoneAngles(bonename,Angle(math.Rand(-5,5),-25-math.Rand(0,4),0))   
				elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger11' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,-35-math.Rand(0,4),0))    
				elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger12' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,-25-math.Rand(0,4),0))
				elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger2' then
				   Gib:ManipulateBoneAngles(bonename,Angle(math.Rand(-5,5),-27-math.Rand(0,4),0))   
				elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger21' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,-35-math.Rand(0,4),0))    
				elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger22' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,-25-math.Rand(0,4),0))  
				elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger3' then
				   Gib:ManipulateBoneAngles(bonename,Angle(math.Rand(-5,5),-25-math.Rand(0,4),0))   
				elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger31' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,-32-math.Rand(0,4),0))    
				elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger32' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,-20-math.Rand(0,40),0))
				elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger4' then
				   Gib:ManipulateBoneAngles(bonename,Angle(math.Rand(-5,5),-20-math.Rand(0,30),0))   
				elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger41' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,-25-math.Rand(0,20),0))    
				elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger42' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,-25-math.Rand(0,3),0))    
				end
					
				if string.find( Gib:GetModel():lower(), "ifrit" ) or string.find( Gib:GetModel():lower(), "skyfire" ) or string.find( Gib:GetModel():lower(), "schwarz_l4d2" ) or string.find( Gib:GetModel():lower(), "lapluma" ) or string.find( Gib:GetModel():lower(), "rym" ) then
					if Gib:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger01' then
						Gib:ManipulateBoneAngles(bonename,Angle(0,-20-math.Rand(0,2),0))    
					elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger02' then
						Gib:ManipulateBoneAngles(bonename,Angle(0,-25-math.Rand(0,3),0))    
					elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger01' then
						Gib:ManipulateBoneAngles(bonename,Angle(0,-20-math.Rand(0,3),0))    
					elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger02' then
						Gib:ManipulateBoneAngles(bonename,Angle(0,-25-math.Rand(0,3),0)) 
					end
				else
					if Gib:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger01' then
						Gib:ManipulateBoneAngles(bonename,Angle(0,20-math.Rand(0,2),0))    
					elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_L_Finger02' then
						Gib:ManipulateBoneAngles(bonename,Angle(0,25-math.Rand(0,3),0))   
					elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger01' then
						Gib:ManipulateBoneAngles(bonename,Angle(0,20-math.Rand(0,3),0))    
					elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_R_Finger02' then
						Gib:ManipulateBoneAngles(bonename,Angle(0,25-math.Rand(0,3),0)) 
					end
				end
			end
			
			if GetConVar("gs_bone_tool_toes"):GetBool() then
				local Toes_Bones = { 
					["ValveBiped.Bip01_L_Toe0"] = true,
					["ValveBiped.Bip01_R_Toe0"] = true
				}
				for bonename = 0 , Gib:GetBoneCount() do 
					if Toes_Bones[ Gib:GetBoneName(bonename) ] then
						Gib:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
					end
				end
			end
			if GetConVar("gs_bone_tool_gf2_toes"):GetBool() then
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
				for bonename = 0 , Gib:GetBoneCount() do 
					if GF2_Toes_Bones[ Gib:GetBoneName(bonename) ] then
						Gib:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
					end
				end
			end
		end
	end
	return true
end

function TOOL:LeftClick( tr )
	return self:Click( tr )
end

function TOOL:RightClick( tr )
	return self:Click( tr )
end

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.gs_bone_tool.desc" } )
	
	CPanel:AddControl( "CheckBox", { Label = "#tool.gs_bone_tool.fingers", Command = "gs_bone_tool_fingers" } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.gs_bone_tool.toes", Command = "gs_bone_tool_toes" } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.gs_bone_tool.gf2_toes", Command = "gs_bone_tool_gf2_toes" } )
end
