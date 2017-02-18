local addonName, addon = ...

local function CreatePlayerStyle(self, unit)
	self:SetSize(widthBig, heightSmall)
	createHealthBar(self)
	createPowerBar(self)
end

oUF:RegisterStyle('oUF_NardenPlayer', CreatePlayerStyle)
oUF:SetActiveStyle('oUF_NardenPlayer')
oUF:Spawn('player', 'oUF_NardenPlayer'):SetPoint(unpack(L.C.playerPoint))