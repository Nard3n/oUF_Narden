local addonName, addon = ...

-- > ColorZ
oUF.colors.power['MANA'] = {0.37, 0.6, 1}
oUF.colors.power['RAGE']  = {0.9,  0.3,  0.23}
oUF.colors.power['FOCUS']  = {1, 0.81,  0.27}
oUF.colors.power['RUNIC_POWER']  = {0, 0.81, 1}
oUF.colors.power['AMMOSLOT'] = {0.78,1, 0.78}
oUF.colors.power['FUEL'] = {0.9,  0.3,  0.23}
oUF.colors.power['POWER_TYPE_STEAM'] = {0.55, 0.57, 0.61}
oUF.colors.power['POWER_TYPE_PYRITE'] = {0.60, 0.09, 0.17}	
oUF.colors.power['POWER_TYPE_HEAT'] = {0.55,0.57,0.61}
oUF.colors.power['POWER_TYPE_OOZE'] = {0.76,1,0}
oUF.colors.power['POWER_TYPE_BLOOD_POWER'] = {0.7,0,1}

--> Short Names
utf8sub = function(string, index)
    local bytes = string:len()
    if (bytes <= index) then
        return string
    else
        local length, currentIndex = 0, 1

        while currentIndex <= bytes do
            length = length + 1
            local char = string:byte(currentIndex)

            if (char > 240) then
                currentIndex = currentIndex + 4
            elseif (char > 225) then
                currentIndex = currentIndex + 3
            elseif (char > 192) then
                currentIndex = currentIndex + 2
            else
                currentIndex = currentIndex + 1
            end

            if (length == index) then
                break
            end
        end

        if (length == index and currentIndex <= bytes) then
            return string:sub(1, currentIndex - 1)
        else
            return string
        end
    end
end

local ShortValue = function(val)
	if(val >= 1e6) then
		return format("%.2fm", val * 0.000001)
	elseif(val >= 1e4) then
		return format("%.1fk", val * 0.001)
	else
		return val
	end
end

-- > Unit Status
local function Status(unit)
	if(not UnitIsConnected(unit)) then
		return 'Off'
	elseif(UnitIsGhost(unit)) then
		return 'Ghost'
	elseif(UnitIsDead(unit)) then
		return 'Dead'
	end
end
oUF.Tags.Methods['narden:status'] = Status
oUF.Tags.Events['narden:status'] = 'UNIT_HEALTH PLAYER_UPDATE_RESTING UNIT_CONNECTION'

oUF.Tags.Events['narden:name'] = 'UNIT_NAME_UPDATE UNIT_HEALTH UNIT_CONNECTION'
oUF.Tags.Methods['narden:name'] = function(unit)
	local status = Status(unit)
		if status then 
			return status
		end
	
	local name = UnitName(unit)
		return utf8sub(name, 4)
end
	
oUF.Tags.Events['narden:health'] = 'UNIT_MAXHEALTH'
oUF.Tags.Methods['narden:health'] = function(unit)
	local max = UnitHealthMax(unit)
	if(UnitHealth(unit) == max) then
		return max
	end
end

oUF.Tags.Events['narden:deficit'] = 'UNIT_HEALTH UNIT_MAXHEALTH'
oUF.Tags.Methods['narden:deficit'] = function(unit)
	if (Status(unit)) then return end
	
	local cur, max = UnitHealth(unit), UnitHealthMax(unit)
	if(cur ~= max) then
		return ('|cffff8080-%s|r'):format(ShortValue(max-cur))
	end
end

oUF.Tags.Events['narden:percent'] = 'UNIT_HEALTH UNIT_MAXHEALTH'
oUF.Tags.Methods['narden:percent'] = function(unit)
	if(Status(unit)) then return end
	
	return('%d|cff0090ff%%|r'):format(UnitHealth(unit)/UnitHealthMax(unit)*100)
end


oUF.Tags.Events['narden:thealth'] = 'UNIT_HEALTH'
oUF.Tags.Methods['narden:thealth'] = function(unit)
	if(Status(unit)) then return end
	
	if(UnitCanAttack('player', unit)) then
		return('%s (%s)'):format(ShortValue(UnitHealth(unit)), _TAGS['narden:percent'](unit))
	else
		local maxHealth = _TAGS['narden:health'](unit)
		if(maxHealth) then
			return ShortValue(maxHealth)
		else
			return ('%s |cff0090ff/|r %s'):format(ShortValue(UnitHealth(unit)), ShortValue(UnitHealthMax(unit)))
		end
	end
end
