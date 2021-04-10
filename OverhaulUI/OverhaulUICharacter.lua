local l = "Load from "
local s = "Save to "

BUILDBANK = {
	DEFAULT_BANK = {set1 = {}, set2 = {}, set3 = {}, set4 = {}, set5 = {}, set6 = {}, set7 = {}},
	DEFAULT_NAMES = {set1 = "build1", set2 = "build2", set3 = "build3", set4 = "build4", set5 = "build5", set6 = "build6", set7 = "build7"},
	Bank = {},
	Names = {},
	GLOBAL_BANK = "BuildBank",
	GLOBAL_NAMES = "BuildBankNames"
}

function OverhaulUI_SetResistances()
	for i = 1, NUM_RESISTANCE_TYPES, 1 do
		local resistanceLevel
		local label = _G["OverhaulUIMagicResFrame"..i.."Label"];
		local text = _G["OverhaulUIMagicResFrame"..i.."StatText"];
		local frame = _G["OverhaulUIMagicResFrame"..i];
		local base, resistance, positive, negative = UnitResistance("player", frame:GetID());
		local petBonus = ComputePetBonus( "PET_BONUS_RES", resistance );
		label:SetText(_G["RESISTANCE"..(frame:GetID()).."_NAME"])

		local resistanceName = _G["RESISTANCE"..(frame:GetID()).."_NAME"];
		frame.tooltip = format(PAPERDOLLFRAME_TOOLTIP_FORMAT, resistanceName).." "..resistance;

		-- resistances can now be negative. Show Red if negative, Green if positive, white otherwise
		if( abs(negative) > positive ) then
			text:SetText(RED_FONT_COLOR_CODE..resistance..FONT_COLOR_CODE_CLOSE);
		elseif( abs(negative) == positive ) then
			text:SetText(resistance);
		else
			text:SetText(GREEN_FONT_COLOR_CODE..resistance..FONT_COLOR_CODE_CLOSE);
		end

		if ( positive ~= 0 or negative ~= 0 ) then
			-- Otherwise build up the formula
			frame.tooltip = frame.tooltip.. " ( "..HIGHLIGHT_FONT_COLOR_CODE..base;
			if( positive > 0 ) then
				frame.tooltip = frame.tooltip..GREEN_FONT_COLOR_CODE.." +"..positive;
			end
			if( negative < 0 ) then
				frame.tooltip = frame.tooltip.." "..RED_FONT_COLOR_CODE..negative;
			end
			frame.tooltip = frame.tooltip..FONT_COLOR_CODE_CLOSE.." )";
		end
		local unitLevel = UnitLevel("player");
		unitLevel = max(unitLevel, 20);
		local magicResistanceNumber = resistance/unitLevel;
		if ( magicResistanceNumber > 5 ) then
			resistanceLevel = RESISTANCE_EXCELLENT;
		elseif ( magicResistanceNumber > 3.75 ) then
			resistanceLevel = RESISTANCE_VERYGOOD;
		elseif ( magicResistanceNumber > 2.5 ) then
			resistanceLevel = RESISTANCE_GOOD;
		elseif ( magicResistanceNumber > 1.25 ) then
			resistanceLevel = RESISTANCE_FAIR;
		elseif ( magicResistanceNumber > 0 ) then
			resistanceLevel = RESISTANCE_POOR;
		else
			resistanceLevel = RESISTANCE_NONE;
		end
		frame.tooltipSubtext = format(RESISTANCE_TOOLTIP_SUBTEXT, _G["RESISTANCE_TYPE"..frame:GetID()], unitLevel, resistanceLevel);
		
		if( petBonus > 0 ) then
			frame.tooltipSubtext = frame.tooltipSubtext .. "\n" .. format(PET_BONUS_TOOLTIP_RESISTANCE, petBonus);
		end
	end
end

function OverhaulUI_ReplaceInventoryStats()
	if _G["CharFrameNewPart"] ~= nil then
		local pvp = CharFrameNewPart.Frame1.TextFrame1.tooltip
		local pve = CharFrameNewPart.Frame1.TextFrame2.tooltip
		local ilvl = CharFrameNewPart.Frame0_sec.TextFrame1.tooltip
	
		_G["OverhaulUIEquipmentPVPLevelLabel"]:SetText("PvP power")
		_G["OverhaulUIEquipmentPVPLevelStatText"]:SetText(string.match(pvp, '%d+/%d+'))
		_G["OverhaulUIEquipmentPVPLevel"].tooltip = pvp
		_G["OverhaulUIEquipmentPVPLevel"].tooltipSubtext = CharFrameNewPart.Frame1.TextFrame1.tooltip2
		
		_G["OverhaulUIEquipmentPVELevelLabel"]:SetText("PvE power")
		_G["OverhaulUIEquipmentPVELevelStatText"]:SetText(string.match(pve, '%d+/%d+'))
		_G["OverhaulUIEquipmentPVELevel"].tooltip = pve
		_G["OverhaulUIEquipmentPVELevel"].tooltipSubtext = CharFrameNewPart.Frame1.TextFrame2.tooltip2

		_G["OverhaulUIEquipmentLevelLabel"]:SetText("Item Level")
		_G["OverhaulUIEquipmentLevelStatText"]:SetText(string.match(ilvl, '%d+'))
		_G["OverhaulUIEquipmentLevel"].tooltip = ilvl
	end
end

function OverhaulUI_ReplaceREFrames()
	if _G["CharFrameNewPart_Enchants"] ~= nil then
		_G["CharFrameNewPartFrame0"]:Hide()
		_G["CharFrameNewPartFrame1"]:Hide()
		_G["CharFrameNewPartFrame0_sec"]:Hide()
		_G["CharFrameNewPartFrame2"]:Hide()
		_G["CharFrameNewPartBackMainButton"]:Hide()

		_G["CharFrameNewPart_Enchants"]:Show()
		CharFrameNewPart_Enchants.Back.MainButton:Hide()
	end
end

function OverhaulUI_UpdateStats(self)
	for i = 1, 5 do -- set basic stats: str, agi, vit, int, spi
  	PaperDollFrame_SetStat(_G["AllStatsFrameStat" .. i], i)
	end

  PaperDollFrame_SetDamage(AllStatsFrameStatMeleeDamage)
  AllStatsFrameStatMeleeDamage:SetScript("OnEnter", CharacterDamageFrame_OnEnter)
  PaperDollFrame_SetAttackSpeed(AllStatsFrameStatMeleeSpeed)
  PaperDollFrame_SetAttackPower(AllStatsFrameStatMeleePower)
  PaperDollFrame_SetRating(AllStatsFrameStatMeleeHit, CR_HIT_MELEE)
  PaperDollFrame_SetMeleeCritChance(AllStatsFrameStatMeleeCrit)
  PaperDollFrame_SetExpertise(AllStatsFrameStatMeleeExpert)

  PaperDollFrame_SetRangedDamage(AllStatsFrameStatRangeDamage)
  AllStatsFrameStatRangeDamage:SetScript("OnEnter", CharacterRangedDamageFrame_OnEnter)
  PaperDollFrame_SetRangedAttackSpeed(AllStatsFrameStatRangeSpeed)
  PaperDollFrame_SetRangedAttackPower(AllStatsFrameStatRangePower)
  PaperDollFrame_SetRating(AllStatsFrameStatRangeHit, CR_HIT_RANGED)
  PaperDollFrame_SetRangedCritChance(AllStatsFrameStatRangeCrit)

  PaperDollFrame_SetSpellBonusDamage(AllStatsFrameStatSpellDamage)
  AllStatsFrameStatSpellDamage:SetScript("OnEnter", CharacterSpellBonusDamage_OnEnter)
  PaperDollFrame_SetSpellBonusHealing(AllStatsFrameStatSpellHeal)
  PaperDollFrame_SetRating(AllStatsFrameStatSpellHit, CR_HIT_SPELL)
  PaperDollFrame_SetSpellCritChance(AllStatsFrameStatSpellCrit)
  AllStatsFrameStatSpellCrit:SetScript("OnEnter", CharacterSpellCritChance_OnEnter)
  PaperDollFrame_SetSpellHaste(AllStatsFrameStatSpellHaste)
  PaperDollFrame_SetManaRegen(AllStatsFrameStatSpellRegen)

  PaperDollFrame_SetArmor(AllStatsFrameStatArmor)
  PaperDollFrame_SetDefense(AllStatsFrameStatDefense)
  PaperDollFrame_SetDodge(AllStatsFrameStatDodge)
  PaperDollFrame_SetParry(AllStatsFrameStatParry)
  PaperDollFrame_SetBlock(AllStatsFrameStatBlock)
  PaperDollFrame_SetResilience(AllStatsFrameStatResil)

	OverhaulUI_SetResistances()

	OverhaulUI_ReplaceInventoryStats()
	OverhaulUI_ReplaceREFrames()
end

function OverhaulUICharacter_OnLoad (self)
  CharacterAttributesFrame:Hide()
	CharacterResistanceFrame:Hide()
  OverhaulUICharacter:Show()
  CharacterModelFrame:SetHeight(300)
  PaperDollFrame_UpdateStats = OverhaulUI_UpdateStats
end

function BuildBankSave(id)
  local t = {}

	for i = 1, 19 do
    local item = GetInventoryItemLink("player", i)
		if item == nil then
      item = "not found"
    end
    table.insert(t, item)
  end

  BUILDBANK.Bank[id] = t
  _G[BUILDBANK.GLOBAL_BANK] = BUILDBANK.Bank

	UTILS.Console.Success(BUILDBANK.Names[id] .. " saved")
end

function EquipItemFromBank(item, invslot)
	if UTILS.Inventory.bank_opened then
		for bank_tab = 0, NUM_BANKBAGSLOTS do
			for slot = 1, UTILS.Inventory.GetBankNumSlots(bank_tab) do
				if item == GetContainerItemLink(bank_tab, slot) then
					PickupContainerItem(bank_tab, slot)
					PickupInventoryItem(invslot)
				end
			end
		end
	end
end

function BuildBankLoad(st)
	if BUILDBANK.Bank[st] == nil then
		UTILS.Console.Warning("Items not equipped. Reason: Set does not exist")
		return 
	end

	ClearCursor()

  local not_found = {}

  for i = 1, 19 do
    local current = GetInventoryItemLink("player", i)
    local equip = BUILDBANK.Bank[st][i]
    if equip ~= "not found" and equip ~= current then
			if GetItemCount(equip, false, false) > 0 then -- if in bag
        EquipItemByName(equip, i)
			elseif GetItemCount(equip, true, false) > 0 then -- if in bank
				if UTILS.Inventory.bank_opened then
        	EquipItemFromBank(equip, i)
				else
					table.insert(equip, "Item is in the bank")
				end
      else
        table.insert(equip, "Item not found in the backpack or bank")
      end
    end
  end
  if #not_found == 0 then
    UTILS.Console.Success("Build loaded successfully")
  else
    for item, reason in not_found do
			UTILS.Console.Warning(item .. " not equipped. Reason: " .. reason)
    end
    UTILS.Console.Error(#not_found .. " items not loaded")
  end
end

function BuildBankUnequipAll()
	for i = 1, 19 do
		for j = 19, 23 do
			if GetInventoryItemLink("player", i) == nil then
				break
			end
			PickupInventoryItem(i)
			UTILS.Inventory.PutItemInTheBag(j)
		end
	end
end

function BUILDBANK:UpdateFrames(id, value)
	_G["BuildBankLoad" .. id .. "Frame"]:SetText(l .. value)
	_G["BuildBankSave" .. id .. "Frame"]:SetText(s .. value)
end

function BUILDBANK:BuildBankCommands(msg, editbox)
  local _, _, id, value = LoadCommand(msg)

	id = tonumber(id)

  if (id ~= nil) and (value ~= nil) then
		if id >= 1 and id <= 7 then
			BUILDBANK:UpdateFrames(id, value)
			BUILDBANK.Names["set" .. id] = value
			_G[BUILDBANK.GLOBAL_NAMES] = BUILDBANK.Names
			return
		end
  end

	UTILS.Console.Info("Syntax: /buildbank (1-7) newName");
	UTILS.Console.Info("Syntax: /bb (1-7) newName");
end

SLASH_BUILDBANK1 = '/buildbank'
SLASH_BUILDBANK2 = '/bb'
SlashCmdList["BUILDBANK"] = BUILDBANK.BuildBankCommands

function BUILDBANK:BuildBank_OnLoad()
	UTILS.Console.Primary("BuildBank loaded")
  BUILDBANK.BuildBank = LoadConfig(BUILDBANK.GLOBAL_BANK, BUILDBANK.DEFAULT_BANK)
  BUILDBANK.Names = LoadConfig(BUILDBANK.GLOBAL_NAMES, BUILDBANK.DEFAULT_NAMES)

  for i = 1, 7 do
		local id = tostring(i)
    BUILDBANK:UpdateFrames(id, BUILDBANK.Names["set" .. id])
  end
end
