local E, L, V, P, G = unpack(ElvUI);
local ENB = E:GetModule("NutsAndBolts");
local mod = E:GetModule('NB_ElvUIPanels');

-- Defaults
P["NutsAndBolts"]["ElvUIPanels"] = {
	['enable'] = true,
	['top'] = {
		['style'] = false,
		['transparency'] = true,
		['shadows'] = false,
		['height'] = 22,
	},
	['bottom'] = {
		['style'] = false,
		['transparency'] = true,
		['shadows'] = false,
		['height'] = 22,
	},
}

local function ConfigTable()
	E.Options.args.NutsAndBolts.args.ElvUIPanels = {
		order = 30,
		type = 'group',
		name = L['ElvUI Panels'],
		childGroups = 'tab',
		args = {
			header1 = {
				order = 1,
				type = 'description',
				fontSize = 'medium',
				name = "\n"..L["This module can alter ElvUI Top and Bottom Panels Transparency and Height"],
			},
			header2 = {
				order = 3,
				type = "header",
				name = "",
			},
			enable = {
				order = 3,
				type = 'toggle',
				name = ENABLE,
				get = function(info) return E.db.NutsAndBolts["ElvUIPanels"][ info[#info] ] end,
				set = function(info, value) E.db.NutsAndBolts["ElvUIPanels"][ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
			},
			spacer2 = {
				order = 4,
				type = "description",
				name = "\n",
			},
			top = {
				order = 5,
				type = 'group',
				name = L['Top Panel'],
				get = function(info) return E.db.NutsAndBolts.ElvUIPanels.top[ info[#info] ] end,
				set = function(info, value) E.db.NutsAndBolts.ElvUIPanels.top[ info[#info] ] = value; mod:TopPanelLayout() end,
				disabled = function() return not E.db.NutsAndBolts.ElvUIPanels.enable or not mod.initialized end,
				args = {
					show = {
						order = 1,
						type = 'toggle',
						name = SHOW,
						desc = L["Display a panel across the top of the screen. This is for cosmetic only."],
						get = function(info) return E.db.general.topPanel end,
						set = function(info, value) E.db.general.topPanel = value; E:GetModule('Layout'):TopPanelVisibility() end
					},
					spacer = {
						order = 2,
						type = "header",
						name = "",
					},
					transparency = {
						order = 3,
						type = 'toggle',
						name = L['Panel Transparency'],
					},
					shadows = {
						order = 4,
						type = 'toggle',
						name = L['Shadows'],
					},
					style = {
						order = 5,
						type = 'toggle',
						name = L['BenikUI Style'],
						hidden = function() return not ENB.BU end,
						disabled = function() return (ENB.BU and not E.db.benikui.general.benikuiStyle) end,
					},
					spacer2 = {
						order = 6,
						type = "header",
						name = "",
					},
					height = {
						order = 7,
						type = "range",
						name = L["Height"],
						min = 6, max = 600, step = 1,
					},
				},
			},
			bottom = {
				order = 6,
				type = 'group',
				name = L['Bottom Panel'],
				get = function(info) return E.db.NutsAndBolts.ElvUIPanels.bottom[ info[#info] ] end,
				set = function(info, value) E.db.NutsAndBolts.ElvUIPanels.bottom[ info[#info] ] = value; mod:BottomPanelLayout() end,
				disabled = function() return not E.db.NutsAndBolts.ElvUIPanels.enable or not mod.initialized end,
				args = {
					show = {
						order = 1,
						type = 'toggle',
						name = SHOW,
						desc = L["Display a panel across the bottom of the screen. This is for cosmetic only."],
						get = function(info) return E.db.general.bottomPanel end,
						set = function(info, value) E.db.general.bottomPanel = value; E:GetModule('Layout'):BottomPanelVisibility() end
					},
					spacer = {
						order = 2,
						type = "header",
						name = "",
					},
					transparency = {
						order = 3,
						type = 'toggle',
						name = L['Panel Transparency'],
					},
					shadows = {
						order = 4,
						type = 'toggle',
						name = L['Shadows'],
					},
					style = {
						order = 5,
						type = 'toggle',
						name = L['BenikUI Style'],
						hidden = function() return not ENB.BU end,
						disabled = function() return (ENB.BU and not E.db.benikui.general.benikuiStyle) end,
					},
					spacer2 = {
						order = 6,
						type = "header",
						name = "",
					},
					height = {
						order = 7,
						type = "range",
						name = L["Height"],
						min = 6, max = 600, step = 1,
					},
				},
			},
		},
	}
end
ENB.Config["ElvUIPanels"] = ConfigTable