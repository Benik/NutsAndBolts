local E, L, V, P, G = unpack(ElvUI);
local ENB = E:GetModule("NutsAndBolts");
local B = E:GetModule('Bags')
local mod = E:GetModule('NB_BagsCountPosition');

-- Defaults
P["NutsAndBolts"]["BagsCountPosition"] = {
	['enable'] = true,
	['countPosition'] = 'BOTTOMRIGHT',
}

local positionValues = {
	TOPLEFT = 'TOPLEFT',
	LEFT = 'LEFT',
	BOTTOMLEFT = 'BOTTOMLEFT',
	RIGHT = 'RIGHT',
	TOPRIGHT = 'TOPRIGHT',
	BOTTOMRIGHT = 'BOTTOMRIGHT',
	CENTER = 'CENTER',
	TOP = 'TOP',
	BOTTOM = 'BOTTOM',
}

local function ConfigTable()
	E.Options.args.NutsAndBolts.args.misc.args.BagsCountPosition = {
		order = 20,
		type = 'group',
		name = L['Bags Count Position'],
		childGroups = 'tab',
		args = {
			name = {
				order = 1,
				type = 'description',
				fontSize = 'medium',
				name = L["This module can move the Bag Item Count Position"],
			},
			spacer1 = {
				order = 2,
				type = "description",
				name = "\n",
			},
			enable = {
				order = 3,
				type = 'toggle',
				name = ENABLE,
				get = function(info) return E.db.NutsAndBolts["BagsCountPosition"][ info[#info] ] end,
				set = function(info, value) E.db.NutsAndBolts["BagsCountPosition"][ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
			},
			bag = {
				order = 4,
				type = 'group',
				name = OPTIONS,
				disabled = function() return not E.db.NutsAndBolts.BagsCountPosition.enable or not mod.initialized end,
				args = {
					countPosition = {
						order = 1,
						type = 'select',
						name = L["Position"],
						values = positionValues,
						get = function(info) return E.db.NutsAndBolts["BagsCountPosition"][ info[#info] ] end,
						set = function(info, value) E.db.NutsAndBolts["BagsCountPosition"][ info[#info] ] = value; B:UpdateItemDisplay(); end,
					},
				},
			},
		},
	}
end
ENB.Config["BagsCountPosition"] = ConfigTable