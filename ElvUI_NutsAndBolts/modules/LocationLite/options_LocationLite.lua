local E, L, V, P, G = unpack(ElvUI);
local ENB = E:GetModule("NutsAndBolts");
local mod = E:GetModule('NB_LocationLite');

local format = string.format
local SHOW, COLOR, CLASS_COLORS, CUSTOM, COLOR_PICKER = SHOW, COLOR, CLASS_COLORS, CUSTOM, COLOR_PICKER

-- GLOBALS: AceGUIWidgetLSMlists

-- Defaults
P["NutsAndBolts"]["LocationLite"] = {
-- Options
	['enable'] = false,
	['showBothZones'] = true,
	['combatHide'] = false,
	['doubleDigit'] = true,
	['timer'] = 0.5,
	['hideDefaultZonetext'] = true,
-- Layout
	['asphyxiaStyle'] = false,
	['shadows'] = false,
	['transparency'] = true,
	['noBackdrop'] = true,
	['largeHeight'] = false,
	['width'] = 200,
	['height'] = 21,
	['autoResize'] = true,
	['userColor'] = { r = 1, g = 1, b = 1 },
	['customColor'] = 1,
	['userCoordsColor'] = { r = 1, g = 1, b = 1 },
	['customCoordsColor'] = 3,
	['truncateText'] = false,
-- Fonts
	['font'] = E.db.general.font,
	['fontSize'] = 12,
	['fontFlags'] = "NONE",
}

local function ConfigTable()
	E.Options.args.NutsAndBolts.args.LocationLite = {
		order = 10,
		type = 'group',
		name = L["Location Lite"],
		childGroups = "tab",
		args = {
			desc = {
				order = 1,
				type = "description",
				name = L["LocationLite adds a movable player location panel"],
			},
			spacer1 = {
				order = 2,
				type = "description",
				name = "\n",
			},
			enable = {
				order = 3,
				name = ENABLE,
				type = 'toggle',
				get = function(info) return E.db.NutsAndBolts["LocationLite"][ info[#info] ] end,
				set = function(info, value) E.db.NutsAndBolts["LocationLite"][ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,					
			},
			spacer2 = {
				order = 4,
				type = "description",
				name = "\n",
			},
			general = {
				order = 5,
				type = "group",
				name = L["General"],
				disabled = function() return not E.db.NutsAndBolts.LocationLite.enable end,
				args = {
					combatHide = {
						order = 1,
						name = L["Combat Hide"],
						desc = L["Show/Hide all panels when in combat"],
						type = 'toggle',
						get = function(info) return E.db.NutsAndBolts["LocationLite"][ info[#info] ] end,
						set = function(info, value) E.db.NutsAndBolts["LocationLite"][ info[#info] ] = value; end,					
					},
					timer = {
						order = 2,
						name = L["Update Timer"],
						desc = L["Adjust coords updates (in seconds) to avoid cpu load. Bigger number = less cpu load. Requires reloadUI."],
						type = "range",
						min = 0.05, max = 1, step = 0.05,
						get = function(info) return E.db.NutsAndBolts["LocationLite"][ info[#info] ] end,
						set = function(info, value) E.db.NutsAndBolts["LocationLite"][ info[#info] ] = value; mod:TimerUpdate(); E:StaticPopup_Show("PRIVATE_RL"); end,					
					},
					show = {
						order = 3,
						type = "group",
						name = SHOW,
						guiInline = true,
						args = {
							showBothZones = {
								order = 1,
								name = L["Zone and Subzone"],
								desc = L["Displays the main zone and the subzone in the location panel"],
								type = 'toggle',
								width = "full",	
								get = function(info) return E.db.NutsAndBolts["LocationLite"][ info[#info] ] end,
								set = function(info, value) E.db.NutsAndBolts["LocationLite"][ info[#info] ] = value; end,					
							},
							hideDefaultZonetext = {
								order = 2,
								name = L["Hide Blizzard Zone Text"],
								type = 'toggle',
								get = function(info) return E.db.NutsAndBolts["LocationLite"][ info[#info] ] end,
								set = function(info, value) E.db.NutsAndBolts["LocationLite"][ info[#info] ] = value; mod:ToggleBlizZoneText() end,					
							},
						},
					},
				},
			},
			layout = {
				order = 6,
				type = "group",
				name = L["Layout"],
				disabled = function() return not E.db.NutsAndBolts.LocationLite.enable end,
				args = {
					transparency = {
						order = 1,
						name = L["Transparent"],
						desc = L["Enable/Disable transparent layout."],
						type = 'toggle',
						disabled = function() return not E.db.NutsAndBolts.LocationLite.noBackdrop or E.db.NutsAndBolts.LocationLite.asphyxiaStyle end,
						get = function(info) return E.db.NutsAndBolts["LocationLite"][ info[#info] ] end,
						set = function(info, value) E.db.NutsAndBolts["LocationLite"][ info[#info] ] = value; mod:LiteTransparent(); end,	
					},
					noBackdrop = {
						order = 2,
						name = L["Backdrop"],
						desc = L["Hides all panels background so you can place them on ElvUI's top or bottom panel."],
						type = 'toggle',
						get = function(info) return E.db.NutsAndBolts["LocationLite"][ info[#info] ] end,
						set = function(info, value) E.db.NutsAndBolts["LocationLite"][ info[#info] ] = value; mod:LocLiteUpdate(); end,
					},
					shadows = {
						order = 3,
						name = L["Shadows"],
						desc = L["Enable/Disable layout with shadows."],
						type = 'toggle',
						disabled = function() return not E.db.NutsAndBolts.LocationLite.noBackdrop end,
						get = function(info) return E.db.NutsAndBolts["LocationLite"][ info[#info] ] end,
						set = function(info, value) E.db.NutsAndBolts["LocationLite"][ info[#info] ] = value; mod:LiteShadow(); end,					
					},
					asphyxiaStyle = {
						order = 4,
						name = L["AsphyxiaUI Style"],
						type = 'toggle',
						disabled = function() return not E.db.NutsAndBolts.LocationLite.noBackdrop end,
						get = function(info) return E.db.NutsAndBolts["LocationLite"][ info[#info] ] end,
						set = function(info, value) E.db.NutsAndBolts["LocationLite"][ info[#info] ] = value; mod:LiteAsphyxia(); end,					
					},
					panels = {
						order = 5,
						type = "group",
						name = L["Size"],
						guiInline = true,
						args = {
							height = {
								order = 2,
								type = "range",
								name = L["All Panels Height"],
								desc = L["Adjust All Panels Height."],
								min = 15, max = 32, step = 1,
								get = function(info) return E.db.NutsAndBolts["LocationLite"][ info[#info] ] end,
								set = function(info, value) E.db.NutsAndBolts["LocationLite"][ info[#info] ] = value; mod:LiteDTHeight() end,
							},		
						},
					},
					font = {
						order = 6,
						type = "group",
						name = L["Fonts"],
						guiInline = true,
						get = function(info) return E.db.NutsAndBolts["LocationLite"][ info[#info] ] end,
						set = function(info, value) E.db.NutsAndBolts["LocationLite"][ info[#info] ] = value; mod:CoordPanelFont(); end,
						args = {
							font = {
								type = "select", dialogControl = 'LSM30_Font',
								order = 1,
								name = L["Font"],
								desc = L["Choose font for the Location and Coords panels."],
								values = AceGUIWidgetLSMlists.font,	
							},
							fontSize = {
								order = 2,
								name = L["Font Size"],
								desc = L["Set the font size."],
								type = "range",
								min = 6, max = 22, step = 1,
							},
							fontFlags = {
								order = 3,
								name = L["Font Outline"],
								type = 'select',
								values = {
									['NONE'] = L['None'],
									['OUTLINE'] = 'OUTLINE',
									['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
									['THICKOUTLINE'] = 'THICKOUTLINE',
								},
							},
						},
					},
				},
			},
			locationPanel = {
				order = 7,
				type = "group",
				name = L["Location Panel"],
				disabled = function() return not E.db.NutsAndBolts.LocationLite.enable end,
				args = {
					largeHeight = {
						order = 1,
						name = L["Larger Location Panel"],
						desc = L["Adds 6 pixels at the Main Location Panel height."],
						type = 'toggle',
						disabled = function() return not E.db.NutsAndBolts.LocationLite.noBackdrop end,
						get = function(info) return E.db.NutsAndBolts["LocationLite"][ info[#info] ] end,
						set = function(info, value) E.db.NutsAndBolts["LocationLite"][ info[#info] ] = value; mod:LiteDTHeight() end,	
					},
					spacer = {
						order = 2,
						type = 'header',
						name = '',
					},
					autoResize = {
						order = 3,
						type = "toggle",
						name = L["Auto width"],
						desc = L["Auto resized Location Panel."],
						get = function(info) return E.db.NutsAndBolts["LocationLite"][ info[#info] ] end,
						set = function(info, value) E.db.NutsAndBolts["LocationLite"][ info[#info] ] = value; end,--E.db.loclite.truncateText = false; end,
					},	
					width = {
						order = 4,
						type = "range",
						name = L["Width"],
						desc = L["Adjust the Location Panel Width."],
						min = 100, max = 300, step = 1,
						disabled = function() return E.db.NutsAndBolts.LocationLite.autoResize end,
						get = function(info) return E.db.NutsAndBolts["LocationLite"][ info[#info] ] end,
						set = function(info, value) E.db.NutsAndBolts["LocationLite"][ info[#info] ] = value; end,
					},
					truncateText = {
						order = 5,
						type = "toggle",
						name = L["Truncate text"],
						desc = L["Truncates the text rather than auto enlarge the location panel when the text is bigger than the panel."],
						disabled = function() return E.db.NutsAndBolts.LocationLite.autoResize end,
						get = function(info) return E.db.NutsAndBolts["LocationLite"][ info[#info] ] end,
						set = function(info, value) E.db.NutsAndBolts["LocationLite"][ info[#info] ] = value; end,
					},
					spacer2 = {
						order = 6,
						type = 'header',
						name = '',
					},
					customColor = {
						order = 7,
						type = "select",
						name = COLOR,
						values = {
							[1] = L["Auto Colorize"],
							[2] = CLASS_COLORS,
							[3] = CUSTOM,
						},
						get = function(info) return E.db.NutsAndBolts["LocationLite"][ info[#info] ] end,
						set = function(info, value) E.db.NutsAndBolts["LocationLite"][ info[#info] ] = value; end,
					},
					userColor = {
						order = 8,
						type = "color",
						name = COLOR_PICKER,
						disabled = function() return E.db.NutsAndBolts.LocationLite.customColor == 1 or E.db.NutsAndBolts.LocationLite.customColor == 2 end,
						get = function(info)
							local t = E.db.NutsAndBolts["LocationLite"][ info[#info] ]
							return t.r, t.g, t.b, t.a
							end,
						set = function(info, r, g, b)
							local t = E.db.NutsAndBolts["LocationLite"][ info[#info] ]
							t.r, t.g, t.b = r, g, b
							mod:LiteCoordsColor()
						end,
					},

				},
			},
			coords = {
				order = 8,
				type = "group",
				name = L["Coordinates"],
				disabled = function() return not E.db.NutsAndBolts.LocationLite.enable end,
				args = {
					doubleDigit = {
						order = 1,
						name = L["Detailed Coords"],
						desc = L["Adds 2 digits in the coords"],
						type = 'toggle',
						get = function(info) return E.db.NutsAndBolts["LocationLite"][ info[#info] ] end,
						set = function(info, value) E.db.NutsAndBolts["LocationLite"][ info[#info] ] = value; mod:LiteCoordsDig() end,					
					},
					spacer = {
						order = 2,
						type = 'header',
						name = '',
					},
					customCoordsColor = {
						order = 3,
						type = "select",
						name = COLOR,
						values = {
							[1] = L["Use Custom Location Color"],
							[2] = CLASS_COLORS,
							[3] = CUSTOM,
						},
						get = function(info) return E.db.NutsAndBolts["LocationLite"][ info[#info] ] end,
						set = function(info, value) E.db.NutsAndBolts["LocationLite"][ info[#info] ] = value; mod:LiteCoordsColor() end,
					},
					userCoordsColor = {
						order = 4,
						type = "color",
						name = COLOR_PICKER,
						disabled = function() return E.db.NutsAndBolts.LocationLite.customCoordsColor == 1 or E.db.NutsAndBolts.LocationLite.customCoordsColor == 2 end,
						get = function(info)
							local t = E.db.NutsAndBolts["LocationLite"][ info[#info] ]
							return t.r, t.g, t.b, t.a
							end,
						set = function(info, r, g, b)
							local t = E.db.NutsAndBolts["LocationLite"][ info[#info] ]
							t.r, t.g, t.b = r, g, b
							mod:LiteCoordsColor() 
						end,
					},
				},
			},
		},
	}
end
ENB.Config["LocationLite"] = ConfigTable
