local E, L, V, P, G = unpack(ElvUI);
local EP = LibStub("LibElvUIPlugin-1.0")
local ENB = E:NewModule("NutsAndBolts", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0");
local addon, ns = ...
 
ENB.Version = GetAddOnMetadata("ElvUI_NutsAndBolts", "Version")
ENB.Title = format('|cff00c0fa%s|r|cffffff00%s|r|cff00c0fa%s|r', "Nuts", "&", "Bolts")
ENB.Config = {}

P["NutsAndBolts"] = {}
V["NutsAndBolts"] = {}

function ENB:cOption(name)
	local color = '|cff00c0fa%s|r'
	return (color):format(name)
end

function ENB:unpackColor(color)
	return color.r, color.g, color.b, color.a
end

function ENB:IsAddOnEnabled(addon) -- Credit: Azilroka
	return GetAddOnEnableState(E.myname, addon) == 2
end

-- Check other addons
ENB.LL = ENB:IsAddOnEnabled('ElvUI_LocLite')
ENB.LP = ENB:IsAddOnEnabled('ElvUI_LocPlus')
ENB.BU = ENB:IsAddOnEnabled('ElvUI_BenikUI')
ENB.DT = ENB:IsAddOnEnabled('ElvUI_DTColors')

-- Options
function ENB:ConfigTable()
	E.Options.args.NutsAndBolts = {
		order = 400,
		type = "group",
		name = ENB.Title,
		childGroups = "tab",
		args = {
			header1 = {
				order = 1,
				type = "header",
				name = format(L["%s version %s by Benik"], ENB.Title, ENB:cOption(ENB.Version)),
			},		
			logo = {
				order = 2,
				type = "description",
				name = "",
				image = function() return 'Interface\\AddOns\\ElvUI_NutsAndBolts\\media\\textures\\nutsandbolts_logo.tga', 256, 64 end,
			},
			header2 = {
				order = 3,
				type = "header",
				name = format(L["%s is a collection of my plugins in Tukui.org / Twitch"], ENB.Title),
			},
			spacer1 = {
				order = 4,
				type = "description",
				name = "\n",
			},
			info = {
				order = 200,
				type = "group",
				name = L["Information / Help"],
				args = {
					description2 = {
						order = 1,
						type = "description",
						name = L["Please use the following links if you need help or wish to know more about this AddOn."].."\n",
					},
					addonpage = {
						order = 2,
						type = "input",
						width = "full",
						name = L["AddOn Description"],
						get = function() return "https://www.tukui.org/addons.php?id=9" end,
						set = function() return "https://www.tukui.org/addons.php?id=9" end,
					},
					tickets = {
						order = 3,
						type = "input",
						width = "full",
						name = L["Report Bugs or Request more Nuts & Bolts"],
						get = function() return "https://git.tukui.org/Benik/ElvUI_NutsAndBolts/issues" end,
						set = function() return "https://git.tukui.org/Benik/ElvUI_NutsAndBolts/issues" end,
					},
				},
			},
			misc = {
				order = 100,
				type = "group",
				name = MISCELLANEOUS,
				childGroups = 'tab',
				args = {
					header1 = {
						order = 1,
						type = "header",
						name = "",
					},
				},
			},
		},
	}

	for _, func in pairs(ENB.Config) do
		func()
	end
end

function ENB:Initialize()
	EP:RegisterPlugin(addon, ENB.ConfigTable)
end

local function InitializeCallback()
	ENB:Initialize()
end

E:RegisterModule(ENB:GetName(), InitializeCallback)