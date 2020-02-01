local E, L, V, P, G = unpack(ElvUI);
local ENB = E:GetModule("NutsAndBolts");
local mod = E:GetModule('NB_DataBarColors');

local COMBAT_XP_GAIN, REPUTATION, ENABLE, COLOR, DEFAULT = COMBAT_XP_GAIN, REPUTATION, ENABLE, COLOR, DEFAULT
local TUTORIAL_TITLE26, FACTION_STANDING_LABEL1, FACTION_STANDING_LABEL2 = TUTORIAL_TITLE26, FACTION_STANDING_LABEL1, FACTION_STANDING_LABEL2
local FACTION_STANDING_LABEL3, FACTION_STANDING_LABEL4, FACTION_STANDING_LABEL5 = FACTION_STANDING_LABEL3, FACTION_STANDING_LABEL4, FACTION_STANDING_LABEL5

-- Defaults
P["NutsAndBolts"]["DataBarColors"] = {
	['enable'] = false,
	['experience'] = {
		['color'] = {
			['default'] = true,
			['xp'] = { r = 0, g = 0.4, b = 1, a = .8 },
			['rested'] = { r = 1, g = 0, b = 1, a = .2 },
		},
	},
	['reputation'] = {
		['color'] = {
			['default'] = true,
			['friendly'] = {r = 0, g = .6, b = .1, a = .8 },
			['neutral'] = {r = .9, g = .7, b = 0, a = .8 },
			['unfriendly'] = {r = .75, g = .27, b = 0, a = .8 },
			['hated'] = {r = 1, g = 0, b = 0, a = .8 },
		},
	},
	['azerite'] = {
		['color'] = {
			['default'] = true,
			['af'] = {r = .901, g = .8, b = .601, a = .8 },
		},
	},
	['honor'] = {
		['color'] = {
			['default'] = true,
			['hn'] = {r = .941, g = .447, b = .254, a = .8 },
		},
	},
}

local function ConfigTable()
	E.Options.args.NutsAndBolts.args.DataBarColors = {
		order = 20,
		type = 'group',
		name = L['DataBar Colors'],
		childGroups = 'tab',
		args = {
			header1 = {
				order = 1,
				type = 'description',
				fontSize = 'medium',
				name = "\n"..L["This module can alter ElvUI Databar statusbars to any color"],
			},
			header2 = {
				order = 2,
				type = "header",
				name = "",
			},
			enable = {
				order = 3,
				type = 'toggle',
				name = ENABLE,
				get = function(info) return E.db.NutsAndBolts["DataBarColors"][ info[#info] ] end,
				set = function(info, value) E.db.NutsAndBolts["DataBarColors"][ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
			},
			spacer1 = {
				order = 4,
				type = "description",
				name = "\n",
			},
			experience = {
				order = 5,
				type = 'group',
				name = L['XP Bar'],
				disabled = function() return not E.db.NutsAndBolts.DataBarColors.enable or not mod.initialized end,
				args = {
					color = {
						order = 1,
						type = 'group',
						name = COLOR,
						guiInline = true,
						args = {
							default = {
								order = 1,
								type = 'toggle',
								name = DEFAULT,
								get = function(info) return E.db.NutsAndBolts.DataBarColors.experience.color.default end,
								set = function(info, value) E.db.NutsAndBolts.DataBarColors.experience.color.default = value; mod:ChangeXPcolor(); end,
							},
							spacer = {
								order = 2,
								type = "header",
								name = "",
							},
							xp = {
								order = 3,
								type = 'color',
								hasAlpha = true,
								name = COMBAT_XP_GAIN,
								disabled = function() return E.db.NutsAndBolts.DataBarColors.experience.color.default end,
								get = function(info)
									local t = E.db.NutsAndBolts.DataBarColors.experience.color.xp
									local d = P.NutsAndBolts.DataBarColors.experience.color.xp
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.NutsAndBolts.DataBarColors[ info[#info] ] = {}
									local t = E.db.NutsAndBolts.DataBarColors.experience.color.xp
									t.r, t.g, t.b, t.a = r, g, b, a
									mod:ChangeXPcolor()
								end,
							},
							rested = {
								order = 4,
								type = 'color',
								hasAlpha = true,
								name = TUTORIAL_TITLE26,
								disabled = function() return E.db.NutsAndBolts.DataBarColors.experience.color.default end,
								get = function(info)
									local t = E.db.NutsAndBolts.DataBarColors.experience.color.rested
									local d = P.NutsAndBolts.DataBarColors.experience.color.rested
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.NutsAndBolts.DataBarColors[ info[#info] ] = {}
									local t = E.db.NutsAndBolts.DataBarColors.experience.color.rested
									t.r, t.g, t.b, t.a = r, g, b, a
									mod:ChangeXPcolor()
								end,
							},
						},
					},
					elvuiOption = {
						order = 2,
						type = "execute",
						name = L["ElvUI"].." "..XPBAR_LABEL,
						func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "databars", "experience") end,
					},
				},
			},
			azerite = {
				order = 6,
				type = 'group',
				name = L['Azerite Bar'],
				disabled = function() return not E.db.NutsAndBolts.DataBarColors.enable or not mod.initialized end,
				args = {
					color = {
						order = 1,
						type = 'group',
						name = COLOR,
						guiInline = true,
						args = {
							default = {
								order = 1,
								type = 'toggle',
								name = DEFAULT,
								width = 'full',
								get = function(info) return E.db.NutsAndBolts.DataBarColors.azerite.color.default end,
								set = function(info, value) E.db.NutsAndBolts.DataBarColors.azerite.color.default = value; mod:ChangeAzeriteColor(); end,
							},
							spacer = {
								order = 2,
								type = "header",
								name = "",
							},
							af = {
								order = 3,
								type = 'color',
								hasAlpha = true,
								name = L['Azerite Bar'],
								disabled = function() return E.db.NutsAndBolts.DataBarColors.azerite.color.default end,
								get = function(info)
									local t = E.db.NutsAndBolts.DataBarColors.azerite.color.af
									local d = P.NutsAndBolts.DataBarColors.azerite.color.af
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.NutsAndBolts.DataBarColors[ info[#info] ] = {}
									local t = E.db.NutsAndBolts.DataBarColors.azerite.color.af
									t.r, t.g, t.b, t.a = r, g, b, a
									mod:ChangeAzeriteColor()
								end,
							},
						},
					},
					elvuiOption = {
						order = 2,
						type = "execute",
						name = L["ElvUI"].." "..L["Azerite Bar"],
						func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "databars", "azerite") end,
					},
				},
			},
			reputation = {
				order = 7,
				type = 'group',
				name = REPUTATION,
				disabled = function() return not E.db.NutsAndBolts.DataBarColors.enable or not mod.initialized end,
				args = {
					color = {
						order = 1,
						type = 'group',
						name = COLOR,
						guiInline = true,
						args = {
							default = {
								order = 1,
								type = 'toggle',
								name = DEFAULT,
								width = 'full',
								get = function(info) return E.db.NutsAndBolts.DataBarColors.reputation.color.default end,
								set = function(info, value) E.db.NutsAndBolts.DataBarColors.reputation.color.default = value; mod:ChangeRepColor(); end,
							},
							spacer = {
								order = 2,
								type = "header",
								name = "",
							},
							friendly = {
								order = 3,
								type = 'color',
								hasAlpha = true,
								name = FACTION_STANDING_LABEL5.."+",
								disabled = function() return E.db.NutsAndBolts.DataBarColors.reputation.color.default end,
								get = function(info)
									local t = E.db.NutsAndBolts.DataBarColors.reputation.color.friendly
									local d = P.NutsAndBolts.DataBarColors.reputation.color.friendly
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.NutsAndBolts.DataBarColors[ info[#info] ] = {}
									local t = E.db.NutsAndBolts.DataBarColors.reputation.color.friendly
									t.r, t.g, t.b, t.a = r, g, b, a
									mod:ChangeRepColor()
								end,
							},
							neutral = {
								order = 4,
								type = 'color',
								hasAlpha = true,
								name = FACTION_STANDING_LABEL4,
								disabled = function() return E.db.NutsAndBolts.DataBarColors.reputation.color.default end,
								get = function(info)
									local t = E.db.NutsAndBolts.DataBarColors.reputation.color.neutral
									local d = P.NutsAndBolts.DataBarColors.reputation.color.neutral
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.NutsAndBolts.DataBarColors[ info[#info] ] = {}
									local t = E.db.NutsAndBolts.DataBarColors.reputation.color.neutral
									t.r, t.g, t.b, t.a = r, g, b, a
									mod:ChangeRepColor()
								end,
							},
							unfriendly = {
								order = 5,
								type = 'color',
								hasAlpha = true,
								name = FACTION_STANDING_LABEL3,
								disabled = function() return E.db.NutsAndBolts.DataBarColors.reputation.color.default end,
								get = function(info)
									local t = E.db.NutsAndBolts.DataBarColors.reputation.color.unfriendly
									local d = P.NutsAndBolts.DataBarColors.reputation.color.unfriendly
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.NutsAndBolts.DataBarColors[ info[#info] ] = {}
									local t = E.db.NutsAndBolts.DataBarColors.reputation.color.unfriendly
									t.r, t.g, t.b, t.a = r, g, b, a
									mod:ChangeRepColor()
								end,
							},
							hated = {
								order = 6,
								type = 'color',
								hasAlpha = true,
								name = FACTION_STANDING_LABEL2.."/"..FACTION_STANDING_LABEL1,
								disabled = function() return E.db.NutsAndBolts.DataBarColors.reputation.color.default end,
								get = function(info)
									local t = E.db.NutsAndBolts.DataBarColors.reputation.color.hated
									local d = P.NutsAndBolts.DataBarColors.reputation.color.hated
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.NutsAndBolts.DataBarColors[ info[#info] ] = {}
									local t = E.db.NutsAndBolts.DataBarColors.reputation.color.hated
									t.r, t.g, t.b, t.a = r, g, b, a
									mod:ChangeRepColor()
								end,
							},
						},
					},
					elvuiOption = {
						order = 2,
						type = "execute",
						name = L["ElvUI"].." "..REPUTATION,
						func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "databars", "reputation") end,
					},
				},
			},
			honor = {
				order = 8,
				type = 'group',
				name = HONOR,
				disabled = function() return not E.db.NutsAndBolts.DataBarColors.enable or not mod.initialized end,
				args = {
					color = {
						order = 1,
						type = 'group',
						name = COLOR,
						guiInline = true,
						args = {
							default = {
								order = 1,
								type = 'toggle',
								name = DEFAULT,
								width = 'full',
								get = function(info) return E.db.NutsAndBolts.DataBarColors.honor.color.default end,
								set = function(info, value) E.db.NutsAndBolts.DataBarColors.honor.color.default = value; mod:ChangeHonorColor(); end,
							},
							spacer = {
								order = 2,
								type = "header",
								name = "",
							},
							hn = {
								order = 3,
								type = 'color',
								hasAlpha = true,
								name = HONOR,
								disabled = function() return E.db.NutsAndBolts.DataBarColors.honor.color.default end,
								get = function(info)
									local t = E.db.NutsAndBolts.DataBarColors.honor.color.hn
									local d = P.NutsAndBolts.DataBarColors.honor.color.hn
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.NutsAndBolts.DataBarColors[ info[#info] ] = {}
									local t = E.db.NutsAndBolts.DataBarColors.honor.color.hn
									t.r, t.g, t.b, t.a = r, g, b, a
									mod:ChangeHonorColor()
								end,
							},
						},
					},
					elvuiOption = {
						order = 2,
						type = "execute",
						name = L["ElvUI"].." "..HONOR,
						func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "databars", "honor") end,
					},
				},
			},
		},
	}
end
ENB.Config["DataBarColors"] = ConfigTable