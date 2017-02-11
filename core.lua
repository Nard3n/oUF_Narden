local addonName, addon = ...
BuffFrame:Hide()

HAL_A = 'Interface\\AddOns\\oUF_Narden\\media\\HalA'
HAL_J = 'Interface\\AddOns\\oUF_Narden\\media\\HalJ'
HAL_K = 'Interface\\AddOns\\oUF_Narden\\media\\HalK'

local widthBig = 250
local widthSmall = 70
local heightBig = 50
local heightSmall = 25

local font = 'Fonts\\ARIALN.ttf'
local fontsize = 14
local fontoutline = 'OUTLINE'

oUF.colors.power['MANA'] = {0.37, 0.6, 1}

local function Shared(self)
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	self:RegisterForClicks'AnyDown'
	
	self:SetBackdrop({
		bgFile = 'Interface\\ChatFrame\\ChatFrameBackground', 
		insets = {top = -1, left = -1, bottom = -1, right = -1}, 
		})
	self:SetBackdropColor(0, 0, 0)
end

local function Name(self)
	
end

local function Health(self)
	self.Health = CreateFrame('StatusBar', nil, self)
	self.Health:SetPoint('TOP', self)
	self.Health:SetPoint('LEFT', self)
	self.Health:SetPoint('RIGHT', self)
	self.Health:SetPoint('BOTTOM', self, 0, 2)
	self.Health:SetStatusBarTexture(HAL_K)
	--self.Health:SetHeight(heightSmall-2)
	
	self.Health.frequentUpdates = true
	self.Health.Smooth = true
	self.Health.colorClass = true
	self.Health.colorReaction = true
	self.Health.colorHealth = true
	
	self.Health.bg = self.Health:CreateTexture(nil, 'BORDER')
	self.Health.bg:SetAllPoints(self.Health)
	self.Health.bg:SetTexture('Interface\\ChatFrame\\ChatFrameBackground')
	self.Health.bg.multiplier = 0.3	
end

local function Power(self)
	self.Power = CreateFrame('StatusBar', nil, self)
	self.Power:SetPoint('TOPRIGHT', self.Health, 'BOTTOMRIGHT', 0, -1)
	self.Power:SetPoint('TOPLEFT', self.Health, 'BOTTOMLEFT', 0, -1)
	self.Power:SetStatusBarTexture(HAL_K)
	self.Power:SetHeight(1)
	
	self.Power.frequentUpdates = true
	self.Power.altPowerColor = true
	self.Power.colorTapping = true
	self.Power.colorDisconnected = true
	self.Power.colorClass = false
	self.Power.colorReaction = false
	self.Power.colorPower = true
	
	self.Power.bg = self.Power:CreateTexture(nil, 'BORDER')
	self.Power.bg:SetAllPoints(self.Power)
	self.Power.bg:SetTexture('Interface\\ChatFrame\\ChatFrameBackground')
	self.Power.bg.multiplier = 0.3
end

local function noHide(self)
	self:SetVertexColor(0, 0, 0)
end

local function PostCreateAuraIcon(self, button, icons, index, debuff)
    button.cd:SetReverse()
    button.count:ClearAllPoints()
    button.count:SetPoint("TOPLEFT", 1, 3)    -- Stack text on top
    button.count:SetJustifyH("CENTER")
    button.count:SetFont(font, fontsize, "OUTLINE")
    button.count:SetTextColor(.8, .8, .8)   -- Color for stack text
    button:SetBackdrop({bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=], insets = {top = -1, bottom = -1, left = -1, right = -1}})
    button:SetBackdropColor(0, 0, 0)
    button.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    button.icon:SetDrawLayer('ARTWORK')
    button.overlay:SetTexture()
  
    button.overlay.Hide = noHide
    
    if(not debuff) then     -- Cancel buffs on right click
        button:SetScript("OnMouseUp", function(self, button)
            if(button=="RightButton") then
                CancelUnitBuff("player", index)
            end
        end)
    end
end

local function CreateStyle(self, unit)
	if (unit=='player') then
		Shared(self)
		Health(self)
		Power(self)
		self:SetSize(widthBig, heightSmall)
		
		local buffs = CreateFrame('Frame', nil, self)
			buffs:SetPoint('TOPRIGHT', Minimap, 'TOPRIGHT', -50, 0)
			buffs.initialAnchor = 'TOPRIGHT'
			buffs['growth-y'] = 'DOWN'
			buffs['growth-x'] = 'LEFT'
			buffs:SetHeight(150)
			buffs:SetWidth(475)
			buffs.num = 51
			buffs.spacing = 3
			buffs.size = 40
			self.Buffs = buffs
	end

	if (unit=='target') then
		Shared(self)
		Health(self)
		Power(self)
		
		self.Info = self.Health:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmallLeft')
		self.Info:SetFont(font, fontsize, fontoutline)
		self.Info:SetPoint('LEFT', self.Health, 2, 0)
		self:Tag(self.Info, '[name]')
				
		self:SetSize(widthBig, heightSmall)
	end
end


oUF:RegisterStyle('Narden', CreateStyle)
oUF:SetActiveStyle('Narden')

oUF:Spawn('player', 'oUF_Player'):SetPoint('CENTER', UIParent, 'CENTER', 0, -150)
oUF:Spawn('target', 'oUF_Target'):SetPoint('BOTTOM', oUF_Player, 'TOP', 0, 20)

