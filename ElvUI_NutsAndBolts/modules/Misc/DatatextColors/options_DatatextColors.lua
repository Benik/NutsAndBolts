local E, L, V, P, G = unpack(ElvUI);
local ENB = E:GetModule("NutsAndBolts");
local mod = E:GetModule('NB_DataTextColors');

-- Defaults
P["NutsAndBolts"]["DataTextColors"] = {
	['enable'] = true,
	['userColor'] = { r = 1, g = 1, b = 1 },
	['customColor'] = 1,
}

local function ConfigTable()
	local description = ""

	if ENB.DT then
		description = L["It looks like ElvUI_DatatextColors addon is loaded. It is strongly suggested to disable it, by clicking the button below.\n|cff00c0faNOTE:|r The standalone ElvUI_DatatextColors addon is not gonna be available anymore on Tukui.org."]
	end

	E.Options.args.NutsAndBolts.args.misc.args.DataTextColors = {
		order = 10,
		type = 'group',
		name = L['DataText Color'],
		childGroups = 'tab',
		args = {
			name = {
				order = 1,
				type = 'description',
				fontSize = 'medium',
				name = L["This module can alter all ElvUI DataText text color"],
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
				get = function(info) return E.db.NutsAndBolts["DataTextColors"][ info[#info] ] end,
				set = function(info, value) E.db.NutsAndBolts["DataTextColors"][ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
			},
			toggleButton = {
				order = 4,
				type = "execute",
				name = DISABLE.." ".."ElvUI_DTColors\n",
				hidden = function() return not ENB.DT end,
				func = function() StaticPopup_Show("ElvUI_DTColors") end,
			},
			dtcolor = {
				order = 5,
				type = 'group',
				name = OPTIONS,
				disabled = function() return not E.db.NutsAndBolts.DataTextColors.enable or not mod.initialized end,
				args = {
					customColor = {
						order = 1,
						type = "select",
						name = COLOR,
						values = {
							[1] = CLASS_COLORS,
							[2] = CUSTOM,
							[3] = L["Value Color"],
							[4] = L['Covenant Color'],
						},
						get = function(info) return E.db.NutsAndBolts["DataTextColors"][ info[#info] ] end,
						set = function(info, value) E.db.NutsAndBolts["DataTextColors"][ info[#info] ] = value; mod:ColorFont(); end,
					},
					userColor = {
						order = 2,
						type = "color",
						name = COLOR_PICKER,
						disabled = function() return E.db.NutsAndBolts.DataTextColors.customColor ~= 2 end,
						get = function(info)
							local t = E.db.NutsAndBolts["DataTextColors"][ info[#info] ]
							return t.r, t.g, t.b, t.a
							end,
						set = function(info, r, g, b)
							local t = E.db.NutsAndBolts["DataTextColors"][ info[#info] ]
							t.r, t.g, t.b = r, g, b
							mod:ColorFont();
						end,
					},
					spacer = {
						order = 3,
						type = "header",
						name = "",
					},
					elvuiOption = {
						order = 4,
						type = "execute",
						name = L["ElvUI"].." "..L["Datatexts"],
						func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "datatexts", "generalGroup") end,
					},
				},
			},
		},
	}

	E.Options.args.datatexts.args.general.args.nbShortcut = {
		order = 30,
		type = "execute",
		width = "double",
		name = L["Change Datatext text Color"],
		func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "NutsAndBolts", "misc", "DataTextColors") end,
	}
end
ENB.Config["DataTextColors"] = ConfigTable

StaticPopupDialogs["ElvUI_DTColors"] = {
	text = L["Are you sure you want to disable ElvUI_DTColors?"],
	button1 = YES,
	button2 = NO,
	OnAccept = function() 
		DisableAddOn("ElvUI_DTColors");ReloadUI()
	end,
	OnCancel = E.noop,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
	preferredIndex = 3,
}