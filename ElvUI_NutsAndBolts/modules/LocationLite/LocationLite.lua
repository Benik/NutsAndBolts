local E, L, V, P, G = unpack(ElvUI);
local ENB = E:GetModule("NutsAndBolts");
local mod = E:NewModule('NB_LocationLite', 'AceTimer-3.0');
local LSM = LibStub("LibSharedMedia-3.0");

local format, pairs, tinsert = string.format, pairs, table.insert

local ToggleFrame = ToggleFrame
local GetZonePVPInfo = GetZonePVPInfo
local IsInInstance = IsInInstance
local C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit
local C_Map_GetPlayerMapPosition = C_Map.GetPlayerMapPosition
local GetRealZoneText, GetMinimapZoneText = GetRealZoneText, GetMinimapZoneText
local ChatEdit_ChooseBoxForSend, ChatEdit_ActivateChat = ChatEdit_ChooseBoxForSend, ChatEdit_ActivateChat
local GetSubZoneText = GetSubZoneText
local UIFrameFadeOut, UIFrameFadeIn = UIFrameFadeOut, UIFrameFadeIn
local IsShiftKeyDown = IsShiftKeyDown
local WorldMapFrame = _G['WorldMapFrame']
local UNKNOWN = UNKNOWN

-- GLOBALS: NB_LocationLitePanel, NB_XCoords, NB_YCoords

local COORDS_WIDTH = 30 -- Coord panels width
local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])

-- Hide in combat, after fade function ends
local function PanelOnFade()
	NB_LocationLitePanel:Hide()
end

local panels = {}

-- AutoColoring
local function AutoColoring()
	local pvpType = GetZonePVPInfo()
	local inInstance, _ = IsInInstance()
	
	if (pvpType == "sanctuary") then
		return 0.41, 0.8, 0.94
	elseif(pvpType == "arena") then
		return 1, 0.1, 0.1
	elseif(pvpType == "friendly") then
		return 0.1, 1, 0.1
	elseif(pvpType == "hostile") then
		return 1, 0.1, 0.1
	elseif(pvpType == "contested") then
		return 1, 0.7, 0.10
	elseif(pvpType == "combat" ) then
		return 1, 0.1, 0.1
	elseif inInstance then
		return 1, 0.1, 0.1
	else
		return 1, 1, 0
	end
end

local function CreateCoords()
	local db = E.db.NutsAndBolts.LocationLite
	local mapID = C_Map_GetBestMapForUnit("player")
	local mapPos = mapID and C_Map_GetPlayerMapPosition(mapID, "player")
	local x, y = 0, 0

	if mapPos then x, y = mapPos:GetXY() end

	local dig
	
	if db.doubleDigit then
		dig = 2
	else
		dig = 0
	end
	
	x = (mapPos and x) and E:Round(100 * x, dig) or 0
	y = (mapPos and y) and E:Round(100 * y, dig) or 0

	return x, y
end

-- clicking the location panel
local function OnClick(self, btn)
	local zoneText = GetRealZoneText() or UNKNOWN;
	if btn == "LeftButton" then	
		if IsShiftKeyDown() then
			local edit_box = ChatEdit_ChooseBoxForSend()
			local x, y = CreateCoords()
			local message
			local coords = x..", "..y
				if zoneText ~= GetSubZoneText() then
					message = format("%s: %s (%s)", zoneText, GetSubZoneText(), coords)
				else
					message = format("%s (%s)", zoneText, coords)
				end
			ChatEdit_ActivateChat(edit_box)
			edit_box:Insert(message) 
		else
			ToggleFrame(WorldMapFrame)
		end
	end
	if btn == "RightButton" then
		E:ToggleConfig()
	end
end

-- Location panel
local function CreateMainPanel()
	local db = E.db.NutsAndBolts.LocationLite

	local loc_panel = CreateFrame('Frame', 'NB_LocationLitePanel', E.UIParent)
	loc_panel:Width(db.width or 200)
	loc_panel:Height(db.height or 21)
	loc_panel:Point('TOP', E.UIParent, 'TOP', 0, -E.mult -22)
	loc_panel:SetFrameStrata('LOW')
	loc_panel:SetFrameLevel(2)
	loc_panel:EnableMouse(true)
	loc_panel:SetScript('OnMouseUp', OnClick)
	tinsert(panels, NB_LocationLitePanel)

	-- Location Text
	loc_panel.Text = loc_panel:CreateFontString(nil, "LOW")
	loc_panel.Text:Point("CENTER", 0, 0)
	loc_panel.Text:SetAllPoints()
	loc_panel.Text:SetJustifyH("CENTER")
	loc_panel.Text:SetJustifyV("MIDDLE")
	
	-- Hide in combat/Pet battle
	loc_panel:SetScript("OnEvent",function(self, event)
		if event == "PET_BATTLE_OPENING_START" then
			UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
			self.fadeInfo.finishedFunc = PanelOnFade
		elseif event == "PET_BATTLE_CLOSE" then
			UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
			self:Show()
		elseif db.combatHide then
			if event == "PLAYER_REGEN_DISABLED" then
				UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
				self.fadeInfo.finishedFunc = PanelOnFade
			elseif event == "PLAYER_REGEN_ENABLED" then
				UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
				self:Show()
			end
		end
	end)

	-- Mover
	E:CreateMover(NB_LocationLitePanel, "NB_LocationLiteMover", L["Location Lite"])
end

-- Coord panels
local function CreateCoordPanels()
	local db = E.db.NutsAndBolts.LocationLite

	-- X Coord panel
	local coordsX = CreateFrame('Frame', "NB_XCoords", NB_LocationLitePanel)
	coordsX:Width(COORDS_WIDTH)
	coordsX:Height(db.height or 21)
	coordsX.Text = coordsX:CreateFontString(nil, "LOW")
	coordsX.Text:SetAllPoints()
	coordsX.Text:SetJustifyH("CENTER")
	coordsX.Text:SetJustifyV("MIDDLE")
	tinsert(panels, NB_XCoords)

	-- Y Coord panel
	local coordsY = CreateFrame('Frame', "NB_YCoords", NB_LocationLitePanel)
	coordsY:Width(COORDS_WIDTH)
	coordsY:Height(db.height or 21)
	coordsY.Text = coordsY:CreateFontString(nil, "LOW")
	coordsY.Text:SetAllPoints()
	coordsY.Text:SetJustifyH("CENTER")
	coordsY.Text:SetJustifyV("MIDDLE")
	tinsert(panels, NB_YCoords)
	
	mod:ToggleCoordsColor()
end

-- all panels height
function mod:PanelsHeight()
	local db = E.db.NutsAndBolts.LocationLite

	if db.largeHeight then
		NB_LocationLitePanel:Height((db.height)+6)
	else
		NB_LocationLitePanel:Height(db.height)
	end
	
	NB_XCoords:Height(db.height)
	NB_YCoords:Height(db.height)
end

-- Fonts
function mod:CoordPanelFont()
	local db = E.db.NutsAndBolts.LocationLite

	for _, frame in pairs(panels) do
		frame.Text:SetFont(LSM:Fetch("font", db.font), db.fontSize, db.fontFlags)
	end	

end

-- Toggle transparency
function mod:ToggleTransparency()
	local db = E.db.NutsAndBolts.LocationLite
	
	for _, frame in pairs(panels) do
		frame:SetTemplate('NoBackdrop')
		if not db.noBackdrop then
			db.shadows = false
			db.asphyxiaStyle = false
		elseif db.transparency then
			frame:SetTemplate('Transparent')
		else
			frame:SetTemplate('Default', true)
		end
	end

end

-- Enable/Disable shadows
function mod:ToggleShadows()
	local db = E.db.NutsAndBolts.LocationLite
	
	for _, frame in pairs(panels) do
		if db.shadows then
			frame.shadow:Show()
		else
			frame.shadow:Hide()
		end
	end

	local SPACING
	
	if db.shadows then
		SPACING = 2
	elseif db.asphyxiaStyle then
		SPACING = -4
	else
		SPACING = 1
	end
	
	NB_XCoords:Point('RIGHT', NB_LocationLitePanel, 'LEFT', -SPACING, 0)
	NB_YCoords:Point('LEFT', NB_LocationLitePanel, 'RIGHT', SPACING, 0)
end

function mod:ToggleAsphyxiaStyle()
	local db = E.db.NutsAndBolts.LocationLite
	local SPACING
	
	if db.asphyxiaStyle then
		SPACING = -4
		NB_XCoords:SetFrameLevel(NB_LocationLitePanel:GetFrameLevel()-1)
		NB_YCoords:SetFrameLevel(NB_LocationLitePanel:GetFrameLevel()-1)
		NB_XCoords.Text:Point("CENTER", 0, 0)
		NB_YCoords.Text:Point("CENTER", 2, 0)
		db.largeHeight = true
		db.shadows = true
		db.transparency = false
	else
		SPACING = 1
		NB_XCoords.Text:Point("CENTER", 1, 0)
		NB_YCoords.Text:Point("CENTER", 1, 0)
	end

	self:ToggleShadows()
	self:PanelsHeight()
	self:ToggleTransparency()
	
	NB_XCoords:Point('RIGHT', NB_LocationLitePanel, 'LEFT', -SPACING, 0)
	NB_YCoords:Point('LEFT', NB_LocationLitePanel, 'RIGHT', SPACING, 0)
end

function mod:UpdateCoords()
	local x, y = CreateCoords()
	local xt,yt

	if (x == 0 or x == nil) and (y == 0 or y == nil) then
		NB_XCoords.Text:SetText("-")
		NB_YCoords.Text:SetText("-")
	else
		if x < 10 then
			xt = "0"..x
		else
			xt = x
		end
		
		if y < 10 then
			yt = "0"..y
		else
			yt = y
		end
		NB_XCoords.Text:SetText(x)
		NB_YCoords.Text:SetText(y)
	end
end

function mod:UpdateLocation()
	local db = E.db.NutsAndBolts.LocationLite
	local subZoneText = GetMinimapZoneText() or ""
	local zoneText = GetRealZoneText() or UNKNOWN;
	local displayLine
	
	-- zone and subzone
	if db.showBothZones then
		if (subZoneText ~= "") and (subZoneText ~= zoneText) then
			displayLine = zoneText .. ": " .. subZoneText
		else
			displayLine = subZoneText
		end
	else
		displayLine = subZoneText
	end
	
	NB_LocationLitePanel.Text:SetText(displayLine)
	
	if displayLine ~= "" then
		if db.customColor == 1 then
			NB_LocationLitePanel.Text:SetTextColor(AutoColoring())
		elseif db.customColor == 2 then
			NB_LocationLitePanel.Text:SetTextColor(classColor.r, classColor.g, classColor.b)
		else
			NB_LocationLitePanel.Text:SetTextColor(ENB:unpackColor(db.userColor))
		end
	end
	
	local fixedwidth = (db.width + 18)
	local autowidth = (NB_LocationLitePanel.Text:GetStringWidth() + 18)
	
	if db.autoResize then
		NB_LocationLitePanel:Width(autowidth)
		NB_LocationLitePanel.Text:Width(autowidth)
	else
		NB_LocationLitePanel:Width(fixedwidth)
		if db.truncateText then
			NB_LocationLitePanel.Text:Width(fixedwidth-18)
			NB_LocationLitePanel.Text:SetWordWrap(false)
		elseif autowidth > fixedwidth then
			NB_LocationLitePanel:Width(autowidth)
			NB_LocationLitePanel.Text:Width(autowidth)
		end
	end
end

function mod:LocationColor()
	local db = E.db.NutsAndBolts.LocationLite
	if db.customColor == 1 then
		NB_LocationLitePanel.Text:SetTextColor(AutoColoring())
	elseif db.customColor == 2 then
		NB_LocationLitePanel.Text:SetTextColor(classColor.r, classColor.g, classColor.b)
	else
		NB_LocationLitePanel.Text:SetTextColor(ENB:unpackColor(db.userColor))
	end
end

-- Coord panels width
function mod:ToggleCoordsDigit()
	local db = E.db.NutsAndBolts.LocationLite
	if db.doubleDigit then
		NB_XCoords:Width(COORDS_WIDTH*1.5)
		NB_YCoords:Width(COORDS_WIDTH*1.5)
	else
		NB_XCoords:Width(COORDS_WIDTH)
		NB_YCoords:Width(COORDS_WIDTH)
	end
end

function mod:ToggleCoordsColor()
	local db = E.db.NutsAndBolts.LocationLite
	if db.customCoordsColor == 1 then
		NB_XCoords.Text:SetTextColor(ENB:unpackColor(db.userColor))
		NB_YCoords.Text:SetTextColor(ENB:unpackColor(db.userColor))			
	elseif db.customCoordsColor == 2 then
		NB_XCoords.Text:SetTextColor(classColor.r, classColor.g, classColor.b)
		NB_YCoords.Text:SetTextColor(classColor.r, classColor.g, classColor.b)
	else
		NB_XCoords.Text:SetTextColor(ENB:unpackColor(db.userCoordsColor))
		NB_YCoords.Text:SetTextColor(ENB:unpackColor(db.userCoordsColor))
	end
end

function mod:ToggleBlizZoneText()
	local db = E.db.NutsAndBolts.LocationLite
	if db.hideDefaultZonetext then
		ZoneTextFrame:UnregisterAllEvents()
	else
		ZoneTextFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		ZoneTextFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
		ZoneTextFrame:RegisterEvent("ZONE_CHANGED")	
	end
end

function mod:ToggleBenikuiStyle()
	if not ENB.BU then return end
	local db = E.db.NutsAndBolts.LocationLite

	for _, frame in pairs(panels) do
		if frame and frame.style then
			if db.benikuiStyle then
				frame.style:Show()
			else
				frame.style:Hide()
			end
		end
	end
end

function mod:StyleAndShadows()
	for _, frame in pairs(panels) do
		if frame then
			frame:CreateShadow()
		end
	end

	if not ENB.BU then return end
	for _, frame in pairs(panels) do
		if frame then
			frame:Style('Outside')
		end
	end
end

-- Update changes
function mod:UpdateLayout()
	self:ToggleTransparency()
	self:ToggleShadows()
	self:ToggleCoordsDigit()
	self:ToggleCoordsColor()
	self:ToggleAsphyxiaStyle()
	self:ToggleBenikuiStyle()
end

function mod:TimerUpdate()
	self:ScheduleRepeatingTimer('UpdateCoords', E.db.NutsAndBolts.LocationLite.timer)
end

function mod:Initialize()
	CreateMainPanel()
	CreateCoordPanels()
	self:StyleAndShadows()
	self:UpdateLayout()
	self:CoordPanelFont()
	self:ToggleBlizZoneText()
	self:TimerUpdate()

	self:ScheduleRepeatingTimer('UpdateLocation', 0.5)

	NB_LocationLitePanel:RegisterEvent("PLAYER_REGEN_DISABLED")
	NB_LocationLitePanel:RegisterEvent("PLAYER_REGEN_ENABLED")
	NB_LocationLitePanel:RegisterEvent("PET_BATTLE_CLOSE")
	NB_LocationLitePanel:RegisterEvent("PET_BATTLE_OPENING_START")

	self.initialized = true
end

local function InitializeCallback()
	if E.db.NutsAndBolts.LocationLite.enable ~= true then return end
	mod:Initialize()
end

E:RegisterModule(mod:GetName(), InitializeCallback)
