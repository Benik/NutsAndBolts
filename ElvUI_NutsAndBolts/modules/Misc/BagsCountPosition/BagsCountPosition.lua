local E, L, V, P, G = unpack(ElvUI);
local ENB = E:GetModule("NutsAndBolts");
local B = E:GetModule('Bags')
local mod = E:NewModule('NB_BagsCountPosition', 'AceHook-3.0');

local pairs, ipairs = pairs, ipairs
local GetContainerNumSlots = GetContainerNumSlots

function mod:UpdateCountPosition()
	if E.private.bags.enable ~= true then return; end
	local db = E.db.NutsAndBolts.BagsCountPosition

	local y = 0
	local x = 0
	if db.countPosition == 'TOPLEFT' then
		y = -2
		x = 2
	elseif db.countPosition == 'TOP' or db.countPosition == 'TOPRIGHT' then
		y = -2
	elseif db.countPosition == 'BOTTOMLEFT' then 
		y = 2
		x = 2
	elseif db.countPosition == 'BOTTOM' or db.countPosition == 'BOTTOMRIGHT' then
		y = 2
	elseif db.countPosition == 'LEFT' then
		x = 2
	end

	for _, bagFrame in pairs(B.BagFrames) do
		for _, bagID in ipairs(bagFrame.BagIDs) do
			for slotID = 1, GetContainerNumSlots(bagID) do
				local slot = bagFrame.Bags[bagID][slotID]
				if slot and slot.Count then
					slot.Count:ClearAllPoints()
					slot.Count:Point(E.db.NutsAndBolts.BagsCountPosition.countPosition, x, y);
				end
			end
		end
		if bagFrame.UpdateAllSlots then
			bagFrame:UpdateAllSlots()
		end
	end
end

function mod:Initialize()
	self:UpdateCountPosition()
	hooksecurefunc(B, 'UpdateItemDisplay', mod.UpdateCountPosition)

	self.initialized = true
end

local function InitializeCallback()
	if E.db.NutsAndBolts.BagsCountPosition.enable ~= true then return end
	mod:Initialize()
end

E:RegisterModule(mod:GetName(), InitializeCallback)