local E, L, V, P, G = unpack(ElvUI);
local ENB = E:GetModule("NutsAndBolts");
local DT = E:GetModule('DataTexts');
local mod = E:NewModule('NB_DataTextColors', 'AceEvent-3.0');

local classColor = E:ClassColor(E.myclass, true)

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
					-- default to classColor if options broke
					r, g, b = classColor.r, classColor.g, classColor.b
				end
				panel.dataPanels[i].text:SetTextColor(r, g, b)
			end
		end
        if panelName and panel then
            DT:UpdatePanelInfo(panelName, panel)
        end
	end
end

function mod:Initialize()
	mod.initialized = true
	E:Delay(3, mod.ColorFont)
	hooksecurefunc(DT, 'LoadDataTexts', mod.ColorFont)
	hooksecurefunc(DT, 'UpdatePanelAttributes', mod.ColorFont)
end

local function InitializeCallback()
	if E.db.NutsAndBolts.DataTextColors.enable ~= true then return end
	mod:Initialize()
end

E:RegisterModule(mod:GetName(), InitializeCallback)