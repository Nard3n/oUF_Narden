local an, at = ...

local function UpdateHealth(self, ...)
  local hmin, hmax = self:GetMinMaxValues()
  local hcur = self:GetValue()
  local hcurp = hcur/hmax or 0
  local doomHealth = self.__owner.doomHealth
  if hcurp == 0 then
    doomHealth:Hide()
    return
  else
    doomHealth:Show()
  end
  local ULx,ULy, LLx,LLy, URx,URy, LRx,LRy = 0,0, 0,1, hcurp,0, hcurp,1
  if doomHealth.orientation == "LEFT" then
    doomHealth:SetTexCoord(ULx,ULy, LLx,LLy, URx,URy, LRx,LRy)
  elseif doomHealth.orientation == "RIGHT" then
    doomHealth:SetTexCoord(URx,URy, LRx,LRy, ULx,ULy, LLx,LLy)
  end
  doomHealth:SetWidth(256*hcurp)
end

local function CreatePlayerStyle(self)
  self:SetSize(256, 64)
  
  local health = CreateFrame('StatusBar', nil, self)
  self.Health = health
  self.Health.PostUpdate = UpdateHealth
  
  local doomHealth = self:CreateTexture(nil, 'BACKGROUND', nil, -8)
  doomHealth:SetTexture(statusbar)
  doomHealth:SetSize(256,64)
  
end

oUF:RegisterStyle(an..'Player', CreatePlayerStyle)
oUF:SetActiveStyle(an..'Player')
local playerFrame = oUF:Spawn('player', an..'PlayerFrame')
playerFrame:SetPoint('BOTTOM', 0, 250) 
