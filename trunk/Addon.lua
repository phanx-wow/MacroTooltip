--[[--------------------------------------------------------------------
	MacroTooltip
	Adds tooltips to the Blizzard Macro UI.
	Copyright (c) 2014 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info22720-MacroTooltip.html
	http://www.curse.com/addons/wow/macrotooltip
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