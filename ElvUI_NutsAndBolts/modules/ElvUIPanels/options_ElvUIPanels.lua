local E, L, V, P, G = unpack(ElvUI);
local ENB = E:GetModule("NutsAndBolts");
local mod = E:GetModule('NB_ElvUIPanels');

-- Defaults
P["NutsAndBolts"]["ElvUIPanels"] = {
	['enable'] = false,
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
			name = {
				order = 1,
				type = 'description',
				name = L["This module can alter ElvUI Top and Bottom Panels Transparency and Height"],
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
				get = function(info) return E.db.NutsAndBolts["ElvUIPanels"][ info[#info] ] end,
				set = function(info, value) E.db.NutsAndBolts["ElvUIPanels"][ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
			},
			spacer2 = {
				order = 4,
				type = "description",
				name = "\n",
			},
			panels = {
				order = 5,
				type = 'group',
				name = L['Panels'],
				disabled = function() return not E.db.NutsAndBolts.ElvUIPanels.enable or not mod.initialized end,
				args = {
					top = {
						order = 5,
						type = 'group',
						guiInline = true,
						name = L['Top Panel'],
						get = function(info) return E.db.NutsAndBolts.ElvUIPanels.top[ info[#info] ] end,
						set = function(info, value) E.db.NutsAndBolts.ElvUIPanels.top[ info[#info] ] = value; mod:TopPanelLayout() end,
						args = {
							transparency = {
								order = 1,
								type = 'toggle',
								name = L['Panel Transparency'],
							},
							shadows = {
								order = 2,
								type = 'toggle',
								name = L['Shadows'],
							},
							style = {
								order = 3,
								type = 'toggle',
								name = L['BenikUI Style'],
								hidden = function() return not ENB.BU end,
								disabled = function() return (ENB.BU and not E.db.benikui.general.benikuiStyle) end,
							},
							spacer = {
								order = 4,
								type = "header",
								name = "",
							},
							height = {
								order = 5,
								type = "range",
								name = L["Height"],
								min = 6, max = 600, step = 1,
							},
						},
					},
					bottom = {
						order = 6,
						type = 'group',
						guiInline = true,
						name = L['Bottom Panel'],
						get = function(info) return E.db.NutsAndBolts.ElvUIPanels.bottom[ info[#info] ] end,
						set = function(info, value) E.db.NutsAndBolts.ElvUIPanels.bottom[ info[#info] ] = value; mod:BottomPanelLayout() end,
						args = {
							transparency = {
								order = 1,
								type = 'toggle',
								name = L['Panel Transparency'],
							},
							shadows = {
								order = 2,
								type = 'toggle',
								name = L['Shadows'],
							},
							style = {
								order = 3,
								type = 'toggle',
								name = L['BenikUI Style'],
								hidden = function() return not ENB.BU end,
								disabled = function() return (ENB.BU and not E.db.benikui.general.benikuiStyle) end,
							},
							spacer = {
								order = 4,
								type = "header",
								name = "",
							},
							height = {
								order = 5,
								type = "range",
								name = L["Height"],
								min = 6, max = 600, step = 1,
							},
						},
					},
				},
			},
		},
	}
end
ENB.Config["ElvUIPanels"] = ConfigTable