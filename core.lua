local addonName, addon = ...
local playerClass = select(2, UnitClass('player'))

HAL_A = 'Interface\\AddOns\\oUF_Narden\\media\\HalA'
HAL_J = 'Interface\\AddOns\\oUF_Narden\\media\\HalJ'
HAL_K = 'Interface\\AddOns\\oUF_Narden\\media\\HalK'
GLOW_T = 'Interface\\AddOns\\oUF_Narden\\media\\glowTex'
INDICATOR = 'Interface\\AddOns\\oUF_Narden\\media\\borderIndicator'
HIGHLIGHT = 'Interface\\AddOns\\oUF_Narden\\media\\statusbar_highlight'

local widthBig = 250
local widthSmall = 90
local heightBig = 50
local heightSmall = 25

local font = 'Fonts\\ARIALN.ttf'
local fontsize = 14
local fontoutline = 'OUTLINE'

createBD = function(parent, anchor, r, g, b, a)
		local frame = CreateFrame('Frame', nil, parent)
		frame:SetFrameStrata('BACKGROUND')
		frame:SetPoint('TOPLEFT', anchor, 'TOPLEFT', -1, 1)
		frame:SetPoint('BOTTOMRIGHT', anchor, 'BOTTOMRIGHT', 1, -1)
		frame:SetBackdrop({
			edgeFile = 'Interface\\Buttons\\WHITE8x8', edgeSize = 1,
			bgFile = 'Interface\\ChatFrame\\ChatFrameBackground',})
		frame:SetBackdropColor(r, g, b, a)
		frame:SetBackdropBorderColor(0, 0, 0)
			
	return frame
end

-- > Kill Blizz group Frame
local frameHider = CreateFrame('Frame')
	frameHider:Hide()

	InterfaceOptionsFrameCategoriesButton11:SetScale(0.00001)
	InterfaceOptionsFrameCategoriesButton11:SetAlpha(0)

	CompactRaidFrameManager:SetParent(frameHider)
	CompactUnitFrameProfiles:UnregisterAllEvents()

for i = 1, MAX_PARTY_MEMBERS do
	local name = 'PartyMemberFrame'..i
	local frame = _G[name]

	frame:SetParent(frameHider)

	_G[name..'HealthBar']:UnregisterAllEvents()
	_G[name..'ManaBar']:UnregisterAllEvents()

	local pet = name..'PetFrame'
	local petframe = _G[pet]

	petframe:SetParent(frameHider)

	_G[pet]:UnregisterAllEvents()
end


--[[UNIT STYLES]]
local function Name(self)
	local name = self.Health:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmallLeft')
		name:SetFont(font, fontsize, fontoutline)
		if (self.unit=='party') or (self.unit=='raid') then
			name:SetPoint('BOTTOM', 0, 1)
			self:Tag(name, '[narden:name]')
		elseif (self.unit=='target') or (self.unit == 'focus') then			
			name:SetPoint('BOTTOM')
			name:SetPoint('TOP')
			name:SetPoint('LEFT', self.Health, 'LEFT', 2, 0)
			name:SetPoint('RIGHT', self.HealthValue, 'LEFT')
			self:Tag(name, '[name]')
		else
			name:SetPoint('LEFT', 2, 1)
			name:SetPoint('RIGHT', -2, 1)
			name:SetPoint('BOTTOM')
			name:SetPoint('TOP')
			self:Tag(name, '[name]')
		end	
end

local function PostUpdateHealth(Health, unit, cur, max)
	if(UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit)) then
		Health:SetValue(0)
	end
	
end
		
local function HealthString(self)
	local HealthValue = self.Health:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmallLeft')
	HealthValue:SetFont(font, fontsize, fontoutline)
	HealthValue:SetPoint('RIGHT', self.Health, 'RIGHT', -2, 0)
	self:Tag(HealthValue, '[narden:status][narden:thealth]')
	
	self.HealthValue = HealthValue
end

local function PostCastStop(cb, unit)
	if cb.Text then cb.Text:SetText("") end
end

local function PostCastStopUpdate(self, event, unit)
	if(unit ~= self.unit) then return end
	return PostCastStop(self.Castbar, unit)
end

local function PostCastStart(self, unit)
	if unit ~= 'player' and self.interrupt and UnitCanAttack('player', unit) then
		self.Text:SetTextColor(1, 0, 0)
	else 
		self.Text:SetTextColor(1, 1, 1)
	end
end

local function CreateCastbar(self)
	local cb = CreateFrame('StatusBar', nil, self)
	cb:SetStatusBarTexture('Interface\\Buttons\\WHITE8x8', 'BACKDROP')
	cb:SetStatusBarColor(0, 0, 0, 0)
	cb:SetHeight(heightSmall)
	cb:SetAllPoints(self)
	
	cb.Time = cb:CreateFontString(nil, 'OVERLAY')
	cb.Time:SetFont(font, fontsize, fontoutline)
	cb.Time:SetTextColor(.4, .7, .9)
	if (self.unit == 'player') then
		cb.Time:SetPoint('RIGHT', self, 'RIGHT', -2, 0)
	else
		cb.Time:SetPoint('BOTTOMRIGHT', cb, 'TOPRIGHT', -3, -3)
	end
	
	cb.Text = cb:CreateFontString(nil, 'OVERLAY')
	cb.Text:SetFont(font, fontsize, fontoutline)
	if (self.unit == 'player') then 
		cb.Text:SetPoint('LEFT', self, 'LEFT', 2, 0)
	else 
		cb.Text:SetPoint('BOTTOM', self, 'TOP',  0, -3)
	end
	
	cb.Spark = cb:CreateTexture(nil, 'OVERLAY')
	cb.Spark:SetColorTexture(1, 1, 1)
	cb.Spark:SetSize(2, heightSmall)
	
	cb.Icon = cb:CreateTexture(nil, 'ARTWORK')
	if (self.unit == 'player') or (self.unit == 'boss') or (self.unit == 'arena') then 
		cb.Icon:SetPoint('LEFT', cb, 'RIGHT', 3, 0)
	else
		cb.Icon:SetPoint('RIGHT', cb, 'LEFT', -3, 0)
	end
	cb.Icon:SetTexCoord(.1, .9, .1, .9)
	cb.Icon:SetSize(25, 25)
		
	cb.PostCastStart = PostCastStart
	cb.PostCastStopUpdate = PostCastStopUpdate
	cb.PostCastStop = PostCastStop
	cb.IBackdrop = createBD(cb, cb.Icon)
	self.Castbar = cb
end

--[[Aura Section]]
local function CreateAuraTimer(self, elapsed)
	if (self.expiration) then
		if(self.expiration < 60) then
			self.remaining:SetFormattedText('%d', self.expiration)
		else
			self.remaining:SetText()
		end
	self.expiration = self.expiration - elapsed
	end
end

local function PostCreateIcon(Auras, button)
	local c = button.count
	c:ClearAllPoints()
	c:SetPoint('TOPRIGHT', 1, 0)
	c:SetFontObject(nil)
	c:SetFont(font, 13, 'THINOUTLINE')
	c:SetTextColor(1, 1, 1)
	
	button.cd:SetHideCountdownNumbers(true)
	button.cd.noOCC = true
	button.cd:SetReverse(true)
	
	button.icon:SetTexCoord(.1, .9, .1, .9)
	createBD(button, button)

	button.overlay:SetTexture(nil)
	
	button.glow = CreateFrame('Frame', nil, button)
	button.glow:SetPoint('TOPLEFT', button, 'TOPLEFT', -1, 1)
	button.glow:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', 1, -1)
	button.glow:SetFrameLevel(button:GetFrameLevel())
	button.glow:SetBackdrop({bgFile = 'Interface\\ChatFrame\\ChatFrameBackground', edgeFile = 'Interface\\Buttons\\WHITE8x8', edgeSize = 1,
		insets = {left = 1,right = 1,top = 1,bottom = 1,},
		})
		
	local remaining = button:CreateFontString(nil, 'OVERLAY')
	remaining:SetFont(font, fontsize, fontoutline)
	remaining:SetPoint('BOTTOM')
	button.remaining = remaining
	button:HookScript('OnUpdate', CreateAuraTimer)
		
end

local function PostUpdateGapIcon(Auras, unit, icon, visibleBuffs)
		if(Auras.currentGap) then
			Auras.currentGap:Show()
		end
		
		icon:Hide()
		Auras.currentGap = icon 
	end
	
local function PostUpdateIcon(_, unit, icon, index, _, filter)
	local _, _, _, _, _, duration, expiration = UnitAura(unit, index, icon.filter)
	if(duration and duration > 0) then
		icon.expiration = expiration - GetTime()
	else
		icon.expiration = math.huge
	end

	local r,g,b = icon.overlay:GetVertexColor()
		if icon.isDebuff and UnitIsFriend("player", unit) then
			icon.glow:SetBackdropBorderColor(r, g, b, 1)
		else 
			icon.glow:SetBackdropBorderColor(0, 0, 0, 0)
		end	
		

	--if unit ~= 'target' then 
	--	icon:EnableMouse(false)
	--end
	--if unit == 'player'and icon.isDebuff then
		icon:EnableMouse(true)
	--end
end
	
local function CreateAura(self, num, size, width, horiz, vert)
		local Auras = CreateFrame("Frame", nil, self)
		Auras:SetSize(width, 4*size)
		Auras["growth-x"] = horiz
		Auras["growth-y"] = vert
		Auras.num = num
		Auras.size = size
		Auras.spacing = 3
		Auras.showDebuffType = true
		Auras.showStealableBuffs = true

		Auras.PostUpdateIcon = PostUpdateIcon 	
		Auras.PostUpdateGapIcon = PostUpdateGapIcon
		Auras.PostCreateIcon = PostCreateIcon 
		
	return Auras	
end

-- > Healprediction 
local function Healcomm(self)
	local myBar = CreateFrame('StatusBar', nil, self.Health)
	myBar:SetStatusBarTexture(HAL_K)
	myBar:SetStatusBarColor(35/255, 197/255, 45/255, .8)
	myBar:SetPoint('TOP')
	myBar:SetPoint('BOTTOM')
	myBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
	myBar:SetWidth(self:GetWidth())
	myBar:SetFrameLevel(self.Health:GetFrameLevel())
	
	local otherBar = CreateFrame('StatusBar', nil, self.Health)
	otherBar:SetStatusBarTexture(HAL_K)
	otherBar:SetStatusBarColor(35/255, 197/255, 45/255, .8)
	otherBar:SetPoint('TOP')
	otherBar:SetPoint('BOTTOM')
	otherBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
	otherBar:SetWidth(self:GetWidth())
	otherBar:SetFrameLevel(self.Health:GetFrameLevel())
	
	local absorbBar = CreateFrame('StatusBar', nil, self.Health)
	absorbBar:SetStatusBarTexture(HAL_K)
	absorbBar:SetStatusBarColor(0, .5, 1, .8)
	absorbBar:SetPoint('TOP')
	absorbBar:SetPoint('BOTTOM')
	absorbBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
	absorbBar:SetWidth(self:GetWidth())
	absorbBar:SetFrameLevel(self.Health:GetFrameLevel())
			
	self.HealPrediction = {
		myBar = myBar, 
		otherBar = otherBar, 
		absorbBar = absorbBar, 
		maxOverflow = 1, 
		frequentUpdates = true, 
	}
end

local function AuraIcon(self, icon)
    if (icon.cd) then
        icon.cd:SetReverse(true)
        icon.cd:SetDrawEdge(true)
        icon.cd:SetAllPoints(icon.icon)
        icon.cd:SetHideCountdownNumbers(true)
    end
end

local function CreateIndicators(self, unit)

    self.AuraWatch = CreateFrame('Frame', nil, self)

    local Auras = {}
    Auras.icons = {}
    Auras.customIcons = true
    Auras.presentAlpha = 1
    Auras.missingAlpha = 0
    Auras.PostCreateIcon = AuraIcon

    local buffs = {}

    if (indicatorList['ALL']) then
        for key, value in pairs(indicatorList['ALL']) do
            tinsert(buffs, value)
        end
    end

    if (indicatorList[playerClass]) then
        for key, value in pairs(indicatorList[playerClass]) do
            tinsert(buffs, value)
        end
    end

    if (buffs) then
        for key, spell in pairs(buffs) do

            local icon = CreateFrame('Frame', nil, self.AuraWatch)
            icon:SetWidth(9)
            icon:SetHeight(9)
            icon:SetPoint(spell[2], self.Health, unpack(offsets[spell[2]].icon))

            icon.spellID = spell[1]
            icon.anyUnit = spell[4]
            icon.hideCount = spell[5]

            local cd = CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
            cd:SetAllPoints(icon)
            icon.cd = cd

                -- Indicator

            local tex = icon:CreateTexture(nil, 'OVERLAY')
            tex:SetAllPoints(icon)
            tex:SetTexture(INDICATOR)
            icon.icon = tex

                -- Color Overlay

            if (spell[3]) then
                icon.icon:SetVertexColor(unpack(spell[3]))
            else
                icon.icon:SetVertexColor(0.8, 0.8, 0.8)
            end

            if (not icon.hideCount) then
                local count = icon:CreateFontString(nil, 'OVERLAY')
                count:SetShadowColor(0, 0, 0)
                count:SetShadowOffset(1, -1)
                count:SetPoint(unpack(offsets[spell[2]].count))
                count:SetFont(font, fontsize)
                icon.count = count
            end

             Auras.icons[spell[1]] = icon
        end
    end
    self.AuraWatch = Auras
end

local function TargetAuraFilter(_, unit, icon, _,_,_,_,_,_,_,caster,_,_,spellID)
	local playerUnits = {player = true, pet = true, vehicle = true,}
	
	if(icon.isDebuff and not UnitIsFriend("player", unit) and not playerUnits[icon.owner] and icon.owner ~= unit and not TargetDebuff[spellID])
			or(not icon.isDebuff and UnitIsPlayer(unit) and not UnitIsFriend("player", unit) and not TargetBuff[spellID]) then
		return false
	end
		return true	
end

local function RaidDebuffFilter(_, _, _, _, _, _, _, _, _, _, caster, _, _, spellID)
	local debuffs = HideRaidDebuffs
	if (debuffs[spellID]) then 
		return false
	end
	return true
end

local function UpdateLFD(self, event)
	local lfdrole = self.LFDRole
	local role = UnitGroupRolesAssigned(self.unit)

	if role == "DAMAGER" then
		lfdrole:SetTextColor(1, .1, .1, 1)
		lfdrole:SetText("")
	elseif role == "TANK" then
		lfdrole:SetTextColor(1, 0, 0, 1)
		lfdrole:SetText("<")
	elseif role == "HEALER" then
		lfdrole:SetTextColor(0, 1, 0, 1)
		lfdrole:SetText("+")
	else
		lfdrole:SetTextColor(0, 0, 0, 0)
	end
end

-- > Debuffhighlight
local function Debuffhighlight(self)
	local dbh = self.Health:CreateTexture(nil, 'OVERLAY')
	dbh:SetAllPoints(self.Health)
	dbh:SetTexture(HIGHLIGHT)
	dbh:SetBlendMode('ADD')
	dbh:SetVertexColor(0, 0, 0, 0)
	self.DebuffHighlightAlpha = 1 
	self.DebuffHighlightFilter = true
	
	self.DebuffHighlight = dbh
end


--[[LAYOUT]]
local function CreateStyle(self, unit)
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	self:RegisterForClicks'AnyDown'
	
	local bd = CreateFrame('Frame', nil, self)
	bd:SetAllPoints(self)
	bd:SetBackdrop({
		bgFile = 'Interface\\ChatFrame\\ChatFrameBackground', 
		insets = {top = -1, left = -1, bottom = -1, right = -1}, 
		})
	bd:SetBackdropColor(0, 0, 0)
	self.bd = bd
	
	self.Health = CreateFrame('StatusBar', nil, self)
	self.Health:SetPoint('TOP', self)
	self.Health:SetPoint('LEFT', self)
	self.Health:SetPoint('RIGHT', self)
	self.Health:SetPoint('BOTTOM', self, 0, 2)
	self.Health:SetStatusBarTexture(HAL_K)
	
	self.Health.frequentUpdates = true
	self.Health.Smooth = true
	self.Health.colorClass = true
	self.Health.colorReaction = true
	self.Health.colorHealth = true
	
	self.Health.bg = self.Health:CreateTexture(nil, 'BORDER')
	self.Health.bg:SetAllPoints(self.Health)
	self.Health.bg:SetTexture('Interface\\ChatFrame\\ChatFrameBackground')
	self.Health.bg.multiplier = 0.3	
	self.Health.PostUpdate = PostUpdateHealth

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
	
	local ri = self.Health:CreateTexture(nil, 'OVERLAY')
	ri:SetSize(15, 15)
	ri:SetPoint('CENTER')
	self.RaidIcon = ri
		
	if (unit=='player') then
		self:SetSize(widthBig, heightSmall)
		CreateCastbar(self)
		Debuffhighlight(self)
		Healcomm(self)
			
		local Threat = CreateFrame('Frame', nil, self)
		self.Threat = Threat
		Threat.Override = UpdateThreat
		
		local altp = CreateFrame('StatusBar', nil, self)
		altp:SetStatusBarTexture(HAL_K)
		altp:SetHeight(1)
		altp:SetWidth(widthBig)
		createBD(altp, altp)
		altp:SetPoint('TOP', self, 'BOTTOM', 0, -1)
		self.AltPowerBar = altp
		
		local Exp = CreateFrame('StatusBar', nil, self)
		Exp:SetStatusBarTexture(HAL_K)
		Exp:SetSize(200, 5)
		
		local Rested = CreateFrame('StatusBar', nil, Exp)
		Rested:SetStatusBarTexture(HAL_K)
		Rested:SetAllPoints(Exp)
		createBD(Exp, Rested, 0, 0, 0, .7)
		self.Experience = Exp
		self.Experience.Rested = Rested
		
		local ap = CreateFrame('StatusBar', nil, self)
		ap:SetStatusBarTexture(HAL_K)
		ap:SetStatusBarColor(.901, .8, .601)
		ap:SetSize(200, 5)
		ap:EnableMouse(true)
		createBD(ap, ap, 0, 0, 0, .7)
		self.ArtifactPower = ap
		
		local rep = CreateFrame('StatusBar', nil, self)
		rep:SetStatusBarTexture(HAL_K)
		rep:SetSize(200, 5)
		rep.colorStanding = true
		createBD(rep, rep, 0, 0, 0, .7)
		self.Reputation = rep
		
		if UnitLevel('player') == MAX_PLAYER_LEVEL then
			ap:SetPoint('TOP', Minimap, 'BOTTOM', 0, -1)
			rep:SetPoint('TOP', self.ArtifactPower, 'BOTTOM', 0, -1)
		else
			Exp:SetPoint('TOP', Minimap, 'BOTTOM', 0, -1)
			rep:SetPoint('TOP', self.Experience, 'BOTTOM', 0, -1)
			if GetWatchedFactionInfo() then
				ap:SetPoint('TOP', self.Reputation, 'BOTTOM', 0, -1)
			else
				ap:SetPoint('TOP', self.Experience, 'BOTTOM', 0, -1)
			end			
		end
		
		local Buffs = CreateAura(self, 30, 40, 3*widthBig, 'LEFT', 'DOWN')
			Buffs:SetPoint('TOPRIGHT', Minimap, 'TOPLEFT', -5, 0)
			Buffs.initialAnchor = 'TOPRIGHT'
			self.Buffs = Buffs
		
		local Debuffs = CreateAura(self, 5, 40, 3*widthBig, 'LEFT', 'DOWN')
			Debuffs:SetPoint('RIGHT', self, 'LEFT', -5, 0)
			Debuffs.initialAnchor = 'RIGHT'
			self.Debuffs = Debuffs		

	end

	if (unit=='target') then
		self:SetSize(widthBig, heightSmall)
		HealthString(self)
		Name(self)
		CreateCastbar(self)
		Healcomm(self)
		
		local Auras = CreateAura(self, 30, 25, widthBig, 'RIGHT', 'DOWN')
		Auras:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 11)
		Auras.initialAnchor = 'BOTTOMLEFT'
		Auras.CustomFilter = TargetAuraFilter
		self.Auras = Auras
	end
	
	if(unit=='focus') then
		self:SetSize(widthBig, heightSmall)
		HealthString(self)
		Name(self)
		CreateCastbar(self)
		
	end
	
	if(unit=='targettarget') then
		self:SetSize(widthBig/2, heightSmall)
		Name(self)
		
	end
	
	if(unit=='pet') then
		self:SetSize(widthBig/2, heightSmall)
		Name(self)
		
	end
	
	if(unit=='boss') then
		self:SetSize(widthBig, heightSmall)
		Name(self)
		CreateCastbar(self)
		
	end
	
	if (unit=='arena') then
		self:SetSize(widthBig, heightSmall)
		Name(self)
		CreateCastbar(self)
	end
	
	if(unit=='party') or (unit=='raid') then
		self:SetSize(widthSmall, heightBig)
		Name(self)
		Healcomm(self)
		CreateIndicators(self, self)
		Debuffhighlight(self)
		
  local Threat = self:CreateTexture(nil, 'OVERLAY')
   Threat:SetSize(16, 16)
   Threat:SetPoint('TOPRIGHT', self)
   
   -- Register it with oUF
   self.Threat = Threat
   
		local lfd = self.Health:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmallLeft')
		lfd:SetFont(font, fontsize, fontoutline)
		lfd:SetPoint('BOTTOMLEFT', self.Health, 'BOTTOMLEFT', 14, 1)
		lfd.Override = UpdateLFD
		self.LFDRole = lfd
		
		local Debuffs = CreateAura(self, 2, 22, 50, 'RIGHT', 'UP')
		Debuffs:SetPoint('TOP', self, 'TOP', 0, 2)
		Debuffs.initialAnchor = 'TOPLEFT'
		Debuffs.CustomFilter = RaidDebuffFilter
		self.Debuffs = Debuffs
		
		local range = {
			insideAlpha = 1, 
			outsideAlpha = .5, 
		}
		self.Range = range 
	end
end

oUF:RegisterStyle('Narden', CreateStyle)
oUF:Factory(function(self)
	self:SetActiveStyle('Narden')
	self:Spawn('player'):SetPoint('BOTTOM', UIParent, 'BOTTOM', 0, 450)
	self:Spawn('target'):SetPoint('BOTTOMLEFT', oUF_NardenPlayer, 'TOPRIGHT', 150, 150)
	self:Spawn('focus'):SetPoint('BOTTOMRIGHT', oUF_NardenPlayer, 'TOPLEFT', -150, 150)
	self:Spawn('targettarget'):SetPoint('TOPLEFT', oUF_NardenTarget, 'BOTTOMLEFT', 0, -3)
	self:Spawn('pet'):SetPoint('LEFT', oUF_NardenPlayer, 'RIGHT', 5, 0)
	
	self:SpawnHeader('Party', nil, 'custom [@raid6, exists] hide;  [@raid2, exists] show; show', 
		'showParty', true, 
		'showPlayer', true, 
		'showSolo', false, 
		'yoffset', -2, 
		'maxColumns', 5, 
		'unitsperColumn', 1, 
		'columnSpacing', 5, 
		'columnAnchorPoint', "LEFT",
		'oUF-initialConfigFunction', ([[
			self:SetHeight(%d)
			self:SetWidth(%d)
		]]):format(heightBig, widthSmall)
	):SetPoint('TOP', oUF_NardenPlayer, 'BOTTOM', 0, -43)
	
	self:SpawnHeader('RaidSmall', nil, 'custom [@raid26, exists] hide;[@raid6, exists] show; hide', 
		'showParty', false,
		'showRaid', true,
		'showSolo', false, 
		'xoffset', 5,
		'yOffset', -5,
		'point', 'LEFT', 
		'groupFilter', '1,2,3,4,5',
		'groupingOrder', '1,2,3,4,5',
		'groupBy', 'GROUP',
		'maxColumns', 5,
		'unitsPerColumn', 5,
		'columnSpacing', 5,
		'columnAnchorPoint', 'TOP',
		'oUF-initialConfigFunction', ([[
				self:SetHeight(%d)
				self:SetWidth(%d)
		]]):format(heightBig, widthSmall)
	):SetPoint('TOP', oUF_NardenPlayer, 'BOTTOM', 0, -43)
	
	self:SpawnHeader('RaidBig', nil, 'custom [@raid26, exists] show; hide', 
		'showParty', false,
		'showRaid', true,
		'showSolo', false, 
		'xoffset', 5,
		'yOffset', -5,
		'point', 'TOP', 
		'groupFilter', '1,2,3,4,5,6,7,8',
		'groupingOrder', '1,2,3,4,5,6,7,8',
		'groupBy', 'GROUP',
		'maxColumns', 8,
		'unitsPerColumn', 5,
		'columnSpacing', 5,
		'columnAnchorPoint', 'LEFT',
		'oUF-initialConfigFunction', ([[
				self:SetHeight(%d)
				self:SetWidth(%d)
		]]):format(heightBig, widthSmall)
	):SetPoint('TOP', oUF_NardenPlayer, 'BOTTOM', 300, -43)
	
	for index = 1, MAX_BOSS_FRAMES do
		local boss = self:Spawn('boss' .. index)
		--local arena = self:Spawn('arena' .. index)
		
		if(index == 1) then
			boss:SetPoint('LEFT', UIParent, 'LEFT', 100, 150)
			--arena:SetPoint('BOTTOMRIGHT', oUF_NardenPlayer, 'TOPLEFT', -150, 150)
		else
			boss:SetPoint('TOP', _G['oUF_NardenBoss' .. index - 1], 'BOTTOM', 0, -15)
			--arena:SetPoint('BOTTOM', _G['oUF_NardenArena' .. index -1), 'TOP', 0, 15)
		end
	end
end)
