local E, L, V, P, G = unpack(ElvUI);
local ENB = E:GetModule("NutsAndBolts");
local DT = E:GetModule('DataTexts');
local mod = E:NewModule('NB_DataTextColors', 'AceEvent-3.0');

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])

function mod:ColorFont()
	local db = E.db.NutsAndBolts.DataTextColors
	for panelName, panel in pairs(DT.RegisteredPanels) do
		for i = 1, panel.numPoints do
			local pointIndex = DT.PointLocation[i]
			if db.customColor == 1 then
				panel.dataPanels[pointIndex].text:SetTextColor(classColor.r, classColor.g, classColor.b)
			elseif db.customColor == 2 then
				panel.dataPanels[pointIndex].text:SetTextColor(ENB:unpackColor(db.userColor))
			else
				panel.dataPanels[pointIndex].text:SetTextColor(ENB:unpackColor(E.db.general.valuecolor))
			end
		end
	end
end

function mod:PLAYER_ENTERING_WORLD()
	self:ColorFont()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function mod:Initialize()
	self:RegisterEvent('PLAYER_ENTERING_WORLD')
	self.initialized = true
end

local function InitializeCallback()
	if E.db.NutsAndBolts.DataTextColors.enable ~= true then return end
	mod:Initialize()
end

E:RegisterModule(mod:GetName(), InitializeCallback)