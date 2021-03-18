local E, L, V, P, G = unpack(ElvUI);
local ENB = E:GetModule("NutsAndBolts");
local mod = E:NewModule('NB_ElvUIPanels');

local function Panel_OnShow(self)
	self:SetFrameLevel(0)
end

local function Style_OnShow(self)
	self:SetFrameLevel(1)
end

function mod:TopPanelLayout()
	local db = E.db.NutsAndBolts.ElvUIPanels.top
	local panel = _G['ElvUI_TopPanel']

	if db.transparency then
		panel:SetTemplate('Transparent')
	else
		panel:SetTemplate('Default')
	end

	if db.shadows then
		panel.shadow:Show()
	else
		panel.shadow:Hide()
	end

	panel:Height(db.height or 22)

	if not ENB.BU then return end
	if E.db.benikui.general.benikuiStyle then
		if db.style then
			panel.style:Show()
		else
			panel.style:Hide()
		end
	end
end

function mod:BottomPanelLayout()
	local db = E.db.NutsAndBolts.ElvUIPanels.bottom
	local panel = _G['ElvUI_BottomPanel']

	if db.transparency then
		panel:SetTemplate('Transparent')
	else
		panel:SetTemplate('Default')
	end

	if db.shadows then
		panel.shadow:Show()
	else
		panel.shadow:Hide()
	end

	panel:Height(db.height or 22)

	if not ENB.BU then return end
	if E.db.benikui.general.benikuiStyle then
		if db.style then
			panel.style:Show()
		else
			panel.style:Hide()
		end
	end
end

function mod:ShadowAndStylePanels()
	local top = _G['ElvUI_TopPanel']
	local bottom = _G['ElvUI_BottomPanel']

	top:CreateShadow()
	top:SetScript('OnShow', Panel_OnShow)
	Panel_OnShow(top)

	bottom:CreateShadow()
	bottom:SetScript('OnShow', Panel_OnShow)
	Panel_OnShow(bottom)	

	if not ENB.BU then return end
	top:BuiStyle('Under')
	if top.style then
		top.style:SetScript('OnShow', Style_OnShow)
		top.style:SetFrameLevel(1)
	end

	bottom:BuiStyle('Inside')
	if bottom.style then
		bottom.style:SetScript('OnShow', Style_OnShow)
		bottom.style:SetFrameLevel(1)
	end
end

function mod:Initialize()
	self:ShadowAndStylePanels()
	self:TopPanelLayout()
	self:BottomPanelLayout()

	self.initialized = true
end

local function InitializeCallback()
	if E.db.NutsAndBolts.ElvUIPanels.enable ~= true then return end
	mod:Initialize()
end

E:RegisterModule(mod:GetName(), InitializeCallback)