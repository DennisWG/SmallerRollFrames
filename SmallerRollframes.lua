--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License

	Last Modified:
        06.09.2014 (DWG): Initial release
]]

function GroupLootFrame_OpenNewFrame(id, rollTime)
	local frame;
	for i=1, NUM_GROUP_LOOT_FRAMES do
		frame = getglobal("SmallGroupLootFrame"..i);
		if ( not frame:IsVisible() ) then
			frame.rollID = id;
			frame.rollTime = rollTime;
			getglobal("GroupLootFrame"..i.."Timer"):SetMinMaxValues(0, rollTime);
			frame:Show();
			return;
		end
	end
end

function SmallGroupLootFrame_OnShow()
	local texture, name, count, quality, bindOnPickUp = GetLootRollItemInfo(this.rollID);
	
	getglobal("SmallGroupLootFrame"..this:GetID().."IconFrameIcon"):SetTexture(texture);
	if string.len(name) > 27 then
		name = string.sub(name, 0, 27).."...";
	end
	
	getglobal("SmallGroupLootFrame"..this:GetID().."TimerName"):SetText(name);
	local color = ITEM_QUALITY_COLORS[quality];
	if not bindOnPickUp then
		getglobal("SmallGroupLootFrame"..this:GetID().."IconFrameBoP"):Hide();
	else
		getglobal("SmallGroupLootFrame"..this:GetID().."IconFrameBoP"):Show();
	end
	
	getglobal("SmallGroupLootFrame"..this:GetID().."IconFrameSlotTexture"):SetVertexColor(color.r, color.g, color.b);
	getglobal("SmallGroupLootFrame"..this:GetID().."Timer"):SetStatusBarColor(color.r - 0.2, color.g - 0.2, color.b - 0.2);
	getglobal("SmallGroupLootFrame"..this:GetID().."TimerBackground"):SetVertexColor(color.r - 0.2, color.g - 0.2, color.b - 0.2);
	getglobal("SmallGroupLootFrame"..this:GetID().."TimerName"):SetVertexColor(color.r, color.g, color.b);
	
	getglobal("SmallGroupLootFrame"..this:GetID().."Timer"):SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
                                            tile = true, tileSize = 16, edgeSize = 16});
	getglobal("SmallGroupLootFrame"..this:GetID().."Timer"):SetBackdropColor(0,0,0,1);
end


function SmallGroupLootFrame_OnEvent()
	if ( event == "CANCEL_LOOT_ROLL" ) then
		if ( arg1 == this.rollID ) then
			this:Hide();
		end
	end
end

function SmallGroupLootFrame_OnUpdate()
	if ( this:IsVisible() ) then
		local left = GetLootRollTimeLeft(this:GetParent().rollID);
		local min, max = this:GetMinMaxValues();
		if ( (left < min) or (left > max) ) then
			left = min;
		end
		this:SetValue(left);
	end
end