-- 必须在文件最顶部添加网络消息标识（仅服务端注册，但两端都需要能读取到）
if SERVER then
	util.AddNetworkString("gs_finger_tool_sync")
end

TOOL.Category = "GS.Tools.Title"
TOOL.Name = "#tool.gs_finger_tool.name"

function TOOL:FingerEntity()
	return self:GetWeapon():GetNWEntity( 1 )
end

function TOOL:SetFingerEntity( ent )
	if ( IsValid( ent ) && ent:GetClass() == "prop_effect" ) then ent = ent.AttachedEntity end
	return self:GetWeapon():SetNWEntity( 1, ent )
end

local LastEntity = NULL
local LastEntityValid = false

-- 定义手指列表
local FingerNames = {
	"L_Finger0", "L_Finger1", "L_Finger2", "L_Finger3", "L_Finger4",
	"R_Finger0", "R_Finger1", "R_Finger2", "R_Finger3", "R_Finger4"
}

local ToeNames = {
	"BigToe", "LongToe", "MiddleToe", "RingToe", "PinkyToe"
}

-- 注册每个手指滑条的控制变量
for _, name in ipairs(FingerNames) do
	TOOL.ClientConVar[ name ] = "0"
end

for _, name in ipairs(ToeNames) do
	TOOL.ClientConVar[ name.."_L" ] = "0"
	TOOL.ClientConVar[ name.."_R" ] = "0"
end

TOOL.Information = {
	{ name = "left", stage = 0 },
	{ name = "right", stage = 0 }
}

-- 骨骼映射表
local FingerBones = {}
local ToeBones = {}

local function AddFinger(FingerName)
	if FingerName == "L_Finger0" or FingerName == "R_Finger0" then
		FingerBones[FingerName] = { 
			"ValveBiped.Bip01_"..FingerName.."1", 
			"ValveBiped.Bip01_"..FingerName.."2" 
		}
	else
		FingerBones[FingerName] = { 
			"ValveBiped.Bip01_"..FingerName, 
			"ValveBiped.Bip01_"..FingerName.."1", 
			"ValveBiped.Bip01_"..FingerName.."2" 
		}
	end
end

for _, name in ipairs(FingerNames) do
	AddFinger(name)
end

local function AddToe(ToeNames)
	ToeBones[ToeNames.."_L"] = { 
		ToeNames.."1_L", 
		ToeNames.."2_L" 
	}
	ToeBones[ToeNames.."_R"] = { 
		ToeNames.."1_R", 
		ToeNames.."2_R" 
	}
end

for _, name in ipairs(ToeNames) do
	AddToe(name)
end

function TOOL:LeftClick( tr )
	if not IsValid(tr.Entity) or tr.Entity:IsPlayer() then return false end
	self:SetFingerEntity(tr.Entity)
	return true
end

function TOOL:RightClick( tr )
	if not IsValid(tr.Entity) or tr.Entity:IsPlayer() then return false end
	self:SetFingerEntity(tr.Entity)
	return true
end

function TOOL:Think()
	if ( CLIENT ) then

		if ( self:FingerEntity() == LastEntity && IsValid( LastEntity ) == LastEntityValid ) then return end

		LastEntity = self:FingerEntity()
		LastEntityValid = IsValid( LastEntity )
		self:RebuildControlPanel( self:FingerEntity() )

		return
	end

	local ent = self:FingerEntity()
	if ( !IsValid( ent ) ) then return end

	for fingerName, bones in pairs(FingerBones) do
		local slideValue = GetConVar("gs_finger_tool_" .. fingerName):GetFloat()
		
		for _, boneName in ipairs(bones) do
			local boneIndex = ent:LookupBone(boneName)
			if boneIndex then
				if (string.find( boneName, "Finger0" )) then
					ent:ManipulateBoneAngles(boneIndex, Angle(0, -slideValue, 0))
				else
					ent:ManipulateBoneAngles(boneIndex, Angle(0, slideValue, 0))
				end
			end
		end
	end
	for toeName, bones in pairs(ToeBones) do
		local slideValue = GetConVar("gs_finger_tool_" .. toeName):GetFloat()
		
		for _, boneName in ipairs(bones) do
			local boneIndex = ent:LookupBone(boneName)
			if boneIndex then
				ent:ManipulateBoneAngles(boneIndex, Angle(0, slideValue, 0))
			end
		end
	end
end

-- 玩家收起工具枪或死掉时，清空选中的实体
function TOOL:Holster()
	if SERVER then
		self:SetFingerEntity(NULL)
	end
end

-----------------------------------------------------
-- 【UI 控制面板】
-----------------------------------------------------
function TOOL.BuildCPanel( CPanel )
	CPanel:AddControl( "Header", { Description = "右键选中一个布娃娃实体，随后拖动下方滑条即可实时改变手指造型。" } )
	
	-- 快捷按钮：重置当前选中的目标手指
	local resetBtn = CPanel:Button("重置手指角度")
	resetBtn.DoClick = function()
		-- 将所有手指滑条重置为 0
		for _, name in ipairs(FingerNames) do
			RunConsoleCommand("gs_finger_tool_" .. name, "0")
		end
	end

	CPanel:AddControl( "Label", { Text = "\n--- 左手手指旋转控制 ---" } )
	for _, name in ipairs(FingerNames) do
		if name == "R_Finger0" then
			CPanel:AddControl( "Label", { Text = "\n--- 右手手指旋转控制 ---" } )
		end

		CPanel:AddControl( "Slider", {
			Label = name,
			Command = "gs_finger_tool_" .. name,
			Type = "Float",
			Min = "-90",
			Max = "90"
		})
	end

	local resetBtn = CPanel:Button("重置脚趾角度")
	resetBtn.DoClick = function()
		for _, name in ipairs(ToeNames) do
			RunConsoleCommand("gs_finger_tool_" .. name.."_L", "0")
			RunConsoleCommand("gs_finger_tool_" .. name.."_R", "0")
		end
	end
	CPanel:AddControl( "Label", { Text = "\n--- 脚趾旋转控制 ---" } )
	for _, name in ipairs(ToeNames) do
		CPanel:AddControl( "Slider", {
			Label = name.."_L",
			Command = "gs_finger_tool_" .. name.."_L",
			Type = "Float",
			Min = "-30",
			Max = "45"
		})

		CPanel:AddControl( "Slider", {
			Label = name.."_R",
			Command = "gs_finger_tool_" .. name.."_R",
			Type = "Float",
			Min = "-30",
			Max = "45"
		})
	end
end
