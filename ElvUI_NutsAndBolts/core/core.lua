local E, L, V, P, G = unpack(ElvUI);
local EP = LibStub("LibElvUIPlugin-1.0")
local ENB = E:NewModule("NutsAndBolts", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0");
local addon, ns = ...
 
ENB.version = GetAddOnMetadata("ElvUI_NutsAndBolts", "Version")
ENB.Title = format('|cff00c0fa%s|r', "ElvUI Nuts & Bolts")

P["NutsAndBolts"] = {}
V["NutsAndBolts"] = {}

ENB.Config = {}
ENB.RegisteredModules = {}

function ENB:AddOptions()
	for _, func in pairs(ENB.Config) do
		func()
	end
end

function ENB:Initialize()

	EP:RegisterPlugin(addon, self.AddOptions)
	print('ENB Loaded')
end

local function InitializeCallback()
	ENB:Initialize()
end

E:RegisterModule(ENB:GetName(), InitializeCallback)