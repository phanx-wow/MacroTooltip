--[[--------------------------------------------------------------------
	MacroTooltip
	Adds tooltips to the Blizzard Macro UI.
	Copyright (c) 2014-2016 Phanx <addons@phanx.net>. All rights reserved.
	https://www.wowinterface.com/downloads/info22720-MacroTooltip.html
	https://www.curseforge.com/wow/addons/macrotooltip
	https://github.com/phanx-wow/MacroTooltip
----------------------------------------------------------------------]]

local function ShowMacroTooltip(macroID, tooltipOwner, ...)
	local name, _, body = GetMacroInfo(macroID) 
	if name and body then
		GameTooltip:SetOwner(tooltipOwner, "ANCHOR_NONE")
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint(...)
		GameTooltip:AddLine(name)
		for line in gmatch(body, "[^\n]+") do
			if strlen(line) > 0 then
				GameTooltip:AddLine(line, 1, 1, 1, true)
			end
		end
		GameTooltip:Show()
	end
end

local function SetupMacroButton(button, enterFunc)
	button:SetScript("OnEnter", enterFunc)
	button:SetScript("OnLeave", GameTooltip_Hide)
end


--------------------------------------------------------------------------------

local f = CreateFrame("Frame")
f.handlers = {}
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, name)
	if self.handlers[name] then
		self.handlers[name]()
		self.handlers[name] = nil
	end
end)

local function RegisterForAddon(name, setupFunc)
	if IsAddOnLoaded(name) then
		return setupFunc()
	else
		f.handlers[name] = setupFunc
	end
end

--------------------------------------------------------------------------------
-- Blizzard

RegisterForAddon("Blizzard_MacroUI", function()
	local function MacroButton_OnEnter(self)
		local macroID = MacroFrame.macroBase + self:GetID()
		ShowMacroTooltip(macroID, self, "TOPLEFT", MacroFrameInset, "TOPRIGHT", 10, -4)
	end

	for i = 1, max(MAX_ACCOUNT_MACROS, MAX_CHARACTER_MACROS) do
		SetupMacroButton(_G["MacroButton"..i], MacroButton_OnEnter)
	end

	MacroFrameTab1:SetText(GENERAL_LABEL)
	PanelTemplates_TabResize(MacroFrameTab1)

	MacroFrameTab2:SetText(UnitName("player"))
	PanelTemplates_TabResize(MacroFrameTab2)
end)

--------------------------------------------------------------------------------
-- MacroToolkit

RegisterForAddon("MacroToolkit", function()
	local MacroToolkitButton_OnEnter = function(self)
		local macroID = MacroToolkitFrame.macroBase + self:GetID()
		ShowMacroTooltip(macroID, self, "TOPLEFT", self:GetParent(), "TOPRIGHT", 10, -4)
	end

	hooksecurefunc(MacroToolkit, "ContainerOnLoad", function(self, this)
		local maxMacroButtons = this:GetName() == "MacroToolkitCButtonContainer" and MAX_CHARACTER_MACROS or max(MAX_ACCOUNT_MACROS, MAX_CHARACTER_MACROS)
		local bname = this:GetName() == "MacroToolkitCButtonContainer" and "MacroToolkitCButton" or "MacroToolkitButton"
		for i = 1, maxMacroButtons do
			local button = _G[bname..i]
			if button then
				SetupMacroButton(button, MacroToolkitButton_OnEnter)
			end
		end
	end)
end)
