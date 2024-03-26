
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
				if Gib:GetBoneName(bonename)=='ValveBiped.Bip01_L_Toe0' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
				elseif Gib:GetBoneName(bonename)=='ValveBiped.Bip01_R_Toe0' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
				end
			end
			if GetConVar("gs_bone_tool_gf2_toes"):GetBool() then
				if Gib:GetBoneName(bonename)=='BigToe1_L' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
				elseif Gib:GetBoneName(bonename)=='BigToe2_L' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
				elseif Gib:GetBoneName(bonename)=='BigToe1_R' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
				elseif Gib:GetBoneName(bonename)=='BigToe2_R' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
				elseif Gib:GetBoneName(bonename)=='LongToe1_L' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
				elseif Gib:GetBoneName(bonename)=='LongToe2_L' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
				elseif Gib:GetBoneName(bonename)=='LongToe1_R' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
				elseif Gib:GetBoneName(bonename)=='LongToe2_R' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
				elseif Gib:GetBoneName(bonename)=='MiddleToe1_L' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
				elseif Gib:GetBoneName(bonename)=='MiddleToe2_L' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
				elseif Gib:GetBoneName(bonename)=='MiddleToe1_R' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
				elseif Gib:GetBoneName(bonename)=='MiddleToe2_R' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
				elseif Gib:GetBoneName(bonename)=='RingToe1_L' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
				elseif Gib:GetBoneName(bonename)=='RingToe2_L' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
				elseif Gib:GetBoneName(bonename)=='RingToe1_R' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
				elseif Gib:GetBoneName(bonename)=='RingToe2_R' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
				elseif Gib:GetBoneName(bonename)=='PinkyToe1_L' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
				elseif Gib:GetBoneName(bonename)=='PinkyToe2_L' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
				elseif Gib:GetBoneName(bonename)=='PinkyToe1_R' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
				elseif Gib:GetBoneName(bonename)=='PinkyToe2_R' then
				   Gib:ManipulateBoneAngles(bonename,Angle(0,math.Rand(-30, 45),0))
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
