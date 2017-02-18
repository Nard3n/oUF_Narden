local addonName, addon = ...
local playerClass = select(2, UnitClass('player'))

F.C = {}

local BACKDROP = 'Interface\\ChatFrame\\ChatFrameBackground'
local EDGE = 'Interface\\Buttons\\WHITE8x8'

local function createBD(parent, anchor, r, g, b, a)
	local frame = CreateFrame('Frame', nil, parent)
		frame:SetFrameStrata('BACKGROUND')
		frame:SetPoint('TOPLEFT', anchor, 'TOPLEFT', -1, 1)
		frame:SetPoint('BOTTOMRIGHT', anchor, 'BOTTOMRIGHT', 1, -1)
		frame:SetBackdrop({
			edgeFile = EDGE, edgeSize = 1, 
			bgFile = BACKDROP, 
		})
		frame:SetBackdropColor(r, g, b, a)
		frame:SetBackdropBorderColor(0, 0, 0)
	
	return frame
end

local function createUnit(self)
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	self:RegisterForClicks'AnyDown'
	createBD(self, self)
end
F.C.createUnit = createUnit

local function PostUpdateHealth(Health, unit, cur, max)
	if(UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit)) then
		Health:SetValue(0)
	end
end

local function createHealthBar(self)
	local healthBar = CreateFrame('StatusBar', nil, self)
	healthBar:SetStatusBarTexture(HAL_K)
	healthBar:SetPoint('TOP')
	healthBar:SetPoint('LEFT')
	healthBar:SetPoint('RIGHT')
	healthBar:SetPoint('BOTTOM', self, 0, heightPower + 1)
	
	healthBar.frequentUpdates = true
	healthBar.Smooth = true
	healthBar.colorClass = true
	healthBar.colorReaction = true
	healthBar.colorHealth =true 
	
	local healthBarBG = healthBar:CreateTexture(nil, 'BORDER')
	healthBarBG:SetAllPoints(healthBar)
	healthBarBG:SetTexture(BACKDROP)
	healthBar.multiplier = 0.3
	
	healthBar.PostUpdate = PostUpdateHealth
	self.Health = healthBar
end
F.C.createHealthBar = createHealthBar

local function createPowerBar(self)
	local powerBar = CreateFrame('StatusBar', nil, self)
	powerBar:SetStatusBarTexture(HAL_K)
	powerBar:SetPoint('TOPRIGHT', self.Health, 'BOTTOMRIGHT', 0, -1)
	powerBar:SetPoint('TOPLEFT', self.Health, 'BOTTOMLEFT', 0, -1)
	powerBar:SetHeight(heightPower)
	
	powerBar.frequentUpdates = true 
	powerBar.altPowerColor = true
	powerBar.colorTapping = true
	powerBar.colorDisconnected = true
	powerBar.colorClass = false
	powerBar.colorReaction = false
	powerBar.colorPower = true
	
	local powerBarBG = powerBar:CreateTexture(nil, 'BORDER')
	powerBarBG:SetAllPoints(powerBar)
	powerBarBG:SetTexture(BACKDROP)
	powerBarBG.multiplier = 0.3
	
	self.Power = powerBar
end
F.C.createPowerBar = createPowerBar