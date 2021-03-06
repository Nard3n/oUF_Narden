--[[

# Element: ArtifactPower

Handles visibility and updating the artifact power bar.

### Widget

`ArtifactPower` - A status bar to represent the artifact power bar.

### Options

  - `.onAlpha` - alpha value of the widget when it is mouse enabled and hovered.
  - `.offAlpha` - alpha value of the widget when it is mouse enabled and not hovered.

### Notes

`OnEnter` and `OnLeave` handlers to display a tooltip will be set on the widget if it is mouse enabled.

### Examples

```lua
-- Position and size
local ArtifactPower = CreateFrame("StatusBar", nil, self)
ArtifactPower:SetSize(200, 5)
ArtifactPower:SetPoint("TOP", self, "BOTTOM")

-- Enable the tooltip
ArtifactPower:EnableMouse(true)

-- Register with oUF
self.ArtifactPower = ArtifactPower
```

### Callbacks

#### `:PreUpdate(event)`

Called before the element has been updated.

**Arguments**

  1. `self`- the ArtifactPower element.
  2. `event` - the event that triggered the update.

#### `:PostUpdate(event, show)`

Called after the element has been updated.

**Arguments**

  1. `self`- the ArtifactPower element.
  2. `event`- the event that triggered the update.
  3. `show`- true if the element is shown, false else.

### Hooks

#### `Override(self, ...)`

Used to completely override the internal update function. Removing the table key entry will make the element fall-back to its internal function again.

**Arguments**

  1. `self` - the parent of the ArtifactPower widget.
  2. `...` - the event that triggered the update and the unit that the event was fired for.

#### `OnEnter(self)`

The OnEnter script handler when the element is mouse enabled.

**Arguments**

  1. `self` - the ArtifactPower element.

#### `OnLeave(self)`

The OnLeave script handler when the element is mouse enabled.

**Arguments**

  1. `self` - the ArtifactPower element.
--]]

local _, ns = ...
local oUF = ns.oUF or oUF

local function ShowTooltip(element)
	element:SetAlpha(element.onAlpha)
	GameTooltip:SetOwner(element)
	GameTooltip:SetText(element.name, HIGHLIGHT_FONT_COLOR:GetRGB())
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(ARTIFACT_POWER_TOOLTIP_TITLE:format(element.totalPower, element.power, element.powerForNextTrait), nil, nil, nil, true)
	GameTooltip:AddLine(ARTIFACT_POWER_TOOLTIP_BODY:format(element.numTraitsLearnable), nil, nil, nil, true)
	GameTooltip:Show()
end

local function HideTooltip(element)
	element:SetAlpha(element.offAlpha)
	GameTooltip_Hide()
end

local function Update(self, event, unit)
	if (unit and unit ~= self.unit) then return end

	local element = self.ArtifactPower
	if (element.PreUpdate) then element:PreUpdate(event) end

	local show = HasArtifactEquipped() and not UnitHasVehicleUI("player")
	if (show) then
		local _, _, name, _, totalPower, traitsLearned = C_ArtifactUI.GetEquippedArtifactInfo()
		local numTraitsLearnable, power, powerForNextTrait = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(traitsLearned, totalPower);

		element:SetMinMaxValues(0, powerForNextTrait)
		element:SetValue(power)

		element.name = name
		element.power = power
		element.powerForNextTrait = powerForNextTrait
		element.totalPower = totalPower
		element.numTraitsLearnable = numTraitsLearnable
		element.traitsLearned = traitsLearned

		element:Show()
	else
		element.name = nil
		element.power = nil
		element.powerForNextTrait = nil
		element.totalPower = nil
		element.numTraitsLearnable = nil
		element.traitsLearned = nil

		element:Hide()
	end

	if (element.PostUpdate) then
		return element:PostUpdate(event, show)
	end
end

local function Path(self, ...)
	return (self.ArtifactPower.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.unit)
end

local function Enable(self, unit)
	local element = self.ArtifactPower
	if (not element or unit ~= "player") then return end

	element.__owner = self
	element.ForceUpdate = ForceUpdate

	if (not element:GetStatusBarTexture()) then
		element:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
		element:SetStatusBarColor(.901, .8, .601)
	end

	if (element:IsMouseEnabled()) then
		element.onAlpha = element.onAlpha or 1
		element.offAlpha = element.offAlpha or 1
		element:SetAlpha(element.offAlpha)
		if (not element:GetScript("OnEnter")) then
			element:SetScript("OnEnter", element.OnEnter or ShowTooltip)
		end
		if (not element:GetScript("OnLeave")) then
			element:SetScript("OnLeave", element.OnLeave or HideTooltip)
		end
	end

	self:RegisterEvent("ARTIFACT_XP_UPDATE", Path, true)
	self:RegisterEvent("UNIT_INVENTORY_CHANGED", Path)

	return true
end

local function Disable(self)
	local element = self.ArtifactPower
	if (not element) then return end

	self:UnregisterEvent("ARTIFACT_XP_UPDATE", Path)
	self:UnregisterEvent("UNIT_INVENTORY_CHANGED", Path)
	element:Hide()
end

oUF:AddElement("ArtifactPower", Path, Enable, Disable)
