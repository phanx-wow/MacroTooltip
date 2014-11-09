--[[--------------------------------------------------------------------
	MacroTooltip
	Adds tooltips to the Blizzard Macro UI.
	http://www.wowinterface.com/downloads/info22720-MacroTooltip.html
	http://www.curse.com/addons/wow/macrotooltip

	Copyright (c) 2014 Phanx <addons@phanx.net>. All rights reserved.
	Please DO NOT upload this addon to other websites, or post modified
	versions of it. However, you are welcome to include a copy of it
	WITHOUT CHANGES in compilations posted on Curse and/or WoWInterface.
	You are also welcome to use any/all of its code in your own addon, as
	long as you do not use my name or the name of this addon ANYWHERE in
	your addon, including its name, outside of an optional attribution.
----------------------------------------------------------------------]]

local function ShowMacroTooltip(self)
	local name, _, body = GetMacroInfo(MacroFrame.macroBase + self:GetID())
	if name and body then
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("TOPLEFT", MacroFrameInset, "TOPRIGHT", 10, -4)
		GameTooltip:AddLine(name)
		for line in gmatch(body, "[^\n]+") do
			if strlen(line) > 0 then
				GameTooltip:AddLine(line, 1, 1, 1, true)
			end
		end
		GameTooltip:Show()
	end
end

for i = 1, max(MAX_ACCOUNT_MACROS, MAX_CHARACTER_MACROS) do
	local button = _G["MacroButton"..i]
	button:SetScript("OnEnter", ShowMacroTooltip)
	button:SetScript("OnLeave", GameTooltip_Hide)
end

MacroFrameTab1:SetText(GENERAL_LABEL)
PanelTemplates_TabResize(MacroFrameTab1)

MacroFrameTab2:SetText(UnitName("player"))
PanelTemplates_TabResize(MacroFrameTab2)