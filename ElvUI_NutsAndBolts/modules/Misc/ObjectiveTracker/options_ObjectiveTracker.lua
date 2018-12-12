local E, L, V, P, G = unpack(ElvUI);
local ENB = E:GetModule("NutsAndBolts");
local mod = E:GetModule('NB_ObjectiveTracker');

-- Defaults
P["NutsAndBolts"]["ObjectiveTracker"] = {
	['enable'] = false,
	['allInstances'] = true,
	['mythic'] = true,
	['achievement'] = true,
}

local function ConfigTable()
	E.Options.args.NutsAndBolts.args.misc.args.ObjectiveTracker = {
		order = 30,
		type = 'group',
		name = L['Objective Tracker'],
		childGroups = 'tab',
		args = {
			name = {
				order = 1,
				type = 'description',
				fontSize = 'medium',
				name = L["This module can toggle Objective Tracker when in an instance"],
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
				get = function(info) return E.db.NutsAndBolts["ObjectiveTracker"][ info[#info] ] end,
				set = function(info, value) E.db.NutsAndBolts["ObjectiveTracker"][ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
			},
			options = {
				order = 4,
				type = 'group',
				name = OPTIONS,
				disabled = function() return not E.db.NutsAndBolts.ObjectiveTracker.enable or not mod.initialized end,
				get = function(info) return E.db.NutsAndBolts["ObjectiveTracker"][ info[#info] ] end,
				set = function(info, value) E.db.NutsAndBolts["ObjectiveTracker"][ info[#info] ] = value; mod:UpdateLocation(); end,
				args = {
					allInstances = {
						order = 3,
						type = 'toggle',
						name = L["Hide when in an instance"],
						width = "full",
					},
					mythic = {
						order = 4,
						type = 'toggle',
						name = L["Don't hide on Mythic+"],
						width = "full",
						disabled = function() return not E.db.NutsAndBolts.ObjectiveTracker.allInstances end,
					},
					achievement = {
						order = 5,
						type = 'toggle',
						name = L["Don't hide when an achievement is tracked"],
						width = "full",
						disabled = function() return not E.db.NutsAndBolts.ObjectiveTracker.allInstances end,
					},
				},
			},
		},
	}
end
ENB.Config["ObjectiveTracker"] = ConfigTable
