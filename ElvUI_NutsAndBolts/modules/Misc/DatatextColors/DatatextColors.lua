local E, L, V, P, G = unpack(ElvUI);
local ENB = E:GetModule("NutsAndBolts");
local DT = E:GetModule('DataTexts');
local mod = E:NewModule('NB_DataTextColors', 'AceEvent-3.0');

local C_Covenants_GetCovenantData = C_Covenants.GetCovenantData
local C_Covenants_GetActiveCovenantID = C_Covenants.GetActiveCovenantID

local classColor = E:ClassColor(E.myclass, true)

local function getCovenantColor()
	local covenantData = C_Covenants_GetCovenantData(C_Covenants_GetActiveCovenantID())
	local kit = covenantData and covenantData.textureKit or nil
	local r, g, b

	if kit then
		if kit == "Kyrian" then
			r, g, b = 0.1647, 0.6353, 1.0
		elseif kit == "Venthyr" then
			r, g, b = 0.8941, 0.0510, 0.0549
		elseif kit == "NightFae" then
			r, g, b = 0.5020, 0.7098, 0.9922
		elseif kit == "Necrolord" then
			r, g, b = 0.0902, 0.7843, 0.3922
		end
	else
		r, g, b = 1, 1, 1 -- fall back to white
	end

	return r, g, b
end

function mod:ColorFont()
	local db = E.db.NutsAndBolts.DataTextColors
	local r, g, b
	for panelName, panel in pairs(DT.RegisteredPanels) do
		for i = 1, panel.numPoints do
			if panel.dataPanels[i] then
				if db.customColor == 1 then
					r, g, b = classColor.r, classColor.g, classColor.b
				elseif db.customColor == 2 then
					r, g, b = ENB:unpackColor(db.userColor)
				elseif db.customColor == 3 then
					r, g, b = ENB:unpackColor(E.db.general.valuecolor)
				else
					r, g, b = getCovenantColor()
				end
				panel.dataPanels[i].text:SetTextColor(r, g, b)
			end
		end
		DT:UpdatePanelInfo(panelName, panel)
	end
end

function mod:PLAYER_ENTERING_WORLD()
	self:ColorFont()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function mod:Initialize()
	self:RegisterEvent('PLAYER_ENTERING_WORLD')
	self.initialized = true
	hooksecurefunc(DT, 'LoadDataTexts', mod.ColorFont)
end

local function InitializeCallback()
	if E.db.NutsAndBolts.DataTextColors.enable ~= true then return end
	mod:Initialize()
end

E:RegisterModule(mod:GetName(), InitializeCallback)