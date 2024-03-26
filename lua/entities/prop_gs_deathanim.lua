
AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Spawnable = true
ENT.AutomaticFrameAdvance = true

ENT.PrintName = "Animation Test"
-- ENT.Category = "My Entity Category"

function ENT:Initialize()
	if ( SERVER ) then -- Only set this stuff on the server, it is networked to clients automatically
		self:SetModel( self.model ) -- Set the model
		self:PhysicsInit( SOLID_VPHYSICS ) -- Initialize physics
	end
end

function ENT:Think()
	if ( SERVER ) then -- Only set this stuff on the server
		self:NextThink( CurTime() ) -- Set the next think for the serverside hook to be the next frame/tick
		self:ResetSequence( self.anim )
		return true -- Return true to let the game know we want to apply the self:NextThink() call
	end
end