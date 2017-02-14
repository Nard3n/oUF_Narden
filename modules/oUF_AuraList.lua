local addonName, addon = ...

HideRaidDebuffs = {
	[206151] = true, -- Keystone Challengerdings
	[57724] = true, -- Sated
	[57723] = true, -- Exhaustion
	[80354] = true, -- Temporal Displacement
	[41425] = true, -- Hypothermia
	[95809] = true, -- Insanity
	[36032] = true, -- Arcane Blast
	[26013] = true, -- Deserter
	[95223] = true, -- Recently Mass Resurrected
	[97821] = true, -- Void-Touched (death knight resurrect)
	[36893] = true, -- Transporter Malfunction
	[36895] = true, -- Transporter Malfunction
	[36897] = true, -- Transporter Malfunction
	[36899] = true, -- Transporter Malfunction
	[36900] = true, -- Soul Split: Evil!
	[36901] = true, -- Soul Split: Good
	[25163] = true, -- Disgusting Oozeling Aura
	[85178] = true, -- Shrink (Deviate Fish)
	[8064] = true, -- Sleepy (Deviate Fish)
	[8067] = true, -- Party Time! (Deviate Fish)
	[24755] = true, -- Tricked or Treated (Hallow's End)
	[42966] = true, -- Upset Tummy (Hallow's End)
	[89798] = true, -- Master Adventurer Award (Maloriak kill title)
	[6788] = true, -- Weakened Soul
	[92331] = true, -- Blind Spot (Jar of Ancient Remedies)
	[71041] = true, -- Dungeon Deserter
	[26218] = true, -- Mistletoe
	[117870] = true, -- Touch of the Titans
	[173658] = true, -- Delvar Ironfist defeated
	[173659] = true, -- Talonpriest Ishaal defeated
	[173661] = true, -- Vivianne defeated
	[173679] = true, -- Leorajh defeated
	[173649] = true, -- Tormmok defeated
	[173660] = true, -- Aeda Brightdawn defeated
	[173657] = true, -- Defender Illona defeated
}

TargetBuff = {
	[13750] = true, -- Adrenaline Rush
	[23335] = true, -- Alliance Flag
	[90355] = true, -- Ancient Hysteria
	[48707] = true, -- Anti-Magic Shell
	[31850] = true, -- Ardent Defender
	[31821] = true, -- Aura Mastery
	[31884] = true, -- Avenging Wrath
	[46924] = true, -- Bladestorm
	[2825] = true, -- Bloodlust
	[51753] = true, -- Camouflage
	[31224] = true, -- Cloak of Shadows
	[74001] = true, -- Combat Readiness
	[19263] = true, -- Deterrence
	[122783] = true, -- Diffuse Magic
	[47585] = true, -- Dispersion
	[498] = true, -- Divine Protection
	[642] = true, -- Divine Shield
	[5277] = true, -- Evasion
	[110959] = true, -- Greater Invisibility
	[86659] = true, -- Guardian of Ancient Kings
	[47788] = true, -- Guardian Spirit
	[1022] = true, -- Hand of Protection
	[32182] = true, -- Heroism
	[105809] = true, -- Holy Avenger
	[23333] = true, -- Horde Flag
	[11426] = true, -- Ice Barrier
	[45438] = true, -- Ice Block
	[48792] = true, -- Icebound Fortitude
	[66] = true, -- Invisibility
	[12975] = true, -- Last Stand
	[1463] = true, -- Mana Shield
	[103958] = true, -- Metamorphosis
	[33206] = true, -- Pain Suppression
	[10060] = true, -- Power Infusion
	[17] = true, -- Power Word: Shield
	[15473] = true, -- Shadowform
	[871] = true, -- Shield Wall
	[23920] = true, -- Spell Reflection
	[2983] = true, -- Sprint
	[80353] = true, -- Time Warp
	[122470] = true, -- Touch of Karma
	[115176] = true, -- Zen Meditation
}

TargetDebuff = {
	-- Stuns
	[408] = true, -- Kidney Shot
	[1833] = true, -- Cheap Shot
	[5211] = true, -- Mighty Bash
	[853] = true, -- Hammer of Justice
	[105593] = true, -- Fist of Justice
	[119381] = true, -- Leg Sweep

	-- Silence
	[47476] = true, -- Strangulate
	[15487] = true, -- Silence

	-- Taunt
	[355] = true, -- Taunt
	[21008] = true, -- Mocking Blow
	[62124] = true, -- Reckoning
	[49576] = true, -- Death Grip
	[56222] = true, -- Dark Command
	[6795] = true, -- Growl
	[2649] = true, -- Growl (pet)
	[116189] = true, -- Provoke

	-- Crowd control
	[118] = true, -- Polymorph (sheep)
	[61305] = true, -- Polymorph (black cat)
	[28272] = true, -- Polymorph (pig)
	[61721] = true, -- Polymorph (rabbit)
	[28271] = true, -- Polymorph (turtle)
	[61780] = true, -- Polymorph (turkey)
	[2094] = true, -- Blind
	[6770] = true, -- Sap
	[20066] = true, -- Repentance
	[9484] = true, -- Shackle Undead
	[339] = true, -- Entangling Roots
	[710] = true, -- Banish
	[19386] = true, -- Wyvern Sting
	[51514] = true, -- Hex
	[5782] = true, -- Fear
	[1499] = true, -- Freezing Trap (1?)
	[3355] = true, -- Freezing Trap (2?)
	[6358] = true, -- Seduction
	[10326] = true, -- Turn Evil
	[33786] = true, -- Cyclone
	[115078] = true, -- Paralysis
}


indicatorList = {
	DRUID = {
		{774, 'BOTTOMRIGHT', {1, 0.2, 1}}, -- Rejuvenation
		{155777, 'RIGHT', {0.4, 0.9, 0.4}}, -- Rejuvenation (Germination)
		{33763, 'BOTTOM', {0.5, 1, 0.5}}, -- Lifebloom
		{48438, 'BOTTOMLEFT', {0.7, 1, 0}}, -- Wild Growth
	},
	MONK = {
		{119611, 'BOTTOMRIGHT', {0, 1, 0}}, -- Renewing Mist
		{124682, 'BOTTOMLEFT', {0.15, 0.98, 0.64}}, -- Enveloping Mist
		{116849, 'TOPLEFT', {1, 1, 0}}, -- Life Cocoon
		{115175, 'BOTTOMLEFT', {0.7, 0.8, 1}}, -- Soothing Mist
	},
	PALADIN = {
		{53563, 'BOTTOMRIGHT', {0, 1, 0}}, -- Beacon of Light
		{156910, 'BOTTOMRIGHT', {0, 1, 0}}, -- Beacon of Faith
		{200025, 'BOTTOMRIGHT', {0, 1, 0}}, -- Beacon of Virtue
	},
	PRIEST = {
	--holy
		{47788, 'TOPLEFT', {0, 1,0 }}, -- Guardian Spirit
		{41635, 'TOPRIGHT', {1, 0.6, 0.6}}, -- Prayer of Mending
		{139, 'BOTTOMLEFT', {0, 1, 0}}, -- Renew
		
	--disc
		{194384, 'TOPLEFT', {1, 0, 0}}, -- Atonement
		{17, 'TOPRIGHT', {1, 1, 0}}, -- Power Word: Shield     
		{33206, 'BOTTOMRIGHT', {.5, .5, .5}}, --Painsup
		{81782, 'BOTTOMLEFT', {.8, .7, 0}},	-- Barrier
		{152118, 'RIGHT', {.6, .6, 0}}, -- CoW
	},
	SHAMAN = {
		{61295, 'TOPLEFT', {0.7, 0.3, 0.7}}, -- Riptide
		{204288, 'BOTTOMRIGHT', {0.7, 0.4, 0}}, -- Earth Shield (PvP Only)
	},
	WARLOCK = {
		{20707, 'BOTTOMRIGHT', {0.7, 0, 1}, true}, -- Soulstone
	},
	ALL = {
		{23333, 'TOPLEFT', {1, 0, 0}, true}, -- Warsong flag, Horde
		{23335, 'TOPLEFT', {0, 0, 1}, true}, -- Warsong flag, Alliance
		{34976, 'TOPLEFT', {1, 0, 1}, true}, -- Netherstorm Flag
	},
}

local space = 2
offsets = {
	TOPLEFT = {
		icon = {space, -space},
		count = {'TOP', icon, 'BOTTOM', 0, 0},
	},

	TOPRIGHT = {
		icon = {-space, -space},
		count = {'TOP', icon, 'BOTTOM', 0, 0},
	},

	BOTTOMLEFT = {
		icon = {space, space},
		count = {'LEFT', icon, 'RIGHT', 1, 0},
	},

	BOTTOMRIGHT = {
		icon = {-space, space},
		count = {'RIGHT', icon, 'LEFT', -1, 0},
	},

	LEFT = {
		icon = {space, 0},
		count = {'LEFT', icon, 'RIGHT', 1, 0},
	},

	RIGHT = {
		icon = {-space, 0},
		count = {'RIGHT', icon, 'LEFT', -1, 0},
	},

	TOP = {
		icon = {0, -space},
		count = {'CENTER', icon, 0, 0},
	},

	BOTTOM = {
		icon = {0, space},
		count = {'CENTER', icon, 0, 0},
	},
}