local an, at = ...

local function CreatePlayerStyle(self)


-- Register template and spawn the Units
oUF:RegisterStyle(an..'Player', CreatePlayerStyle)
oUF:SetActiveStyle(an..'Player')
local playerFrame = oUF:Spawn('player', an..'PlayerFrame')
playerFrame:SetPoint('BOTTOM', 0, 250) 
