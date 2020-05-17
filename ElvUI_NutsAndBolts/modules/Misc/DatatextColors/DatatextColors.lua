local E, L, V, P, G = unpack(ElvUI);
local ENB = E:GetModule("NutsAndBolts");
local DT = E:GetModule('DataTexts');
local mod = E:NewModule('NB_DataTextColors', 'AceEvent-3.0');

local classColor = E:ClassColor(E.myclass, true)

function mod:ColorFont()
	local db = E.db.NutsAndBolts.DataTextColors
	for panelName, panel in pairs(DT.RegisteredPanels) do
		for i = 1, panel.numPoints do
			if panel.dataPanels[i] then
				if db.customColor == 1 then
					panel.dataPanels[i].text:SetTextColor(classColor.r, classColor.g, classColor.b)
				elseif db.customColor == 2 then
					panel.dataPanels[i].text:SetTextColor(ENB:unpackColor(db.userColor))
				else
					panel.dataPanels[i].text:SetTextColor(ENB:unpackColor(E.db.general.valuecolor))
				end
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