--
local l = "Load from "
local s = "Save to "
--
local DEFAULT_BANK = {set1 = {}, set2 = {}, set3 = {}, set4 = {}, set5 = {}}
local DEFAULT_NAMES = {set1 = "build1", set2 = "build2", set3 = "build3", set4 = "build4", set5 = "build5"}
--

local Bank = {}
local config = {}
local frames = {set1 = {}, set2 = {}, set3 = {}, set4 = {}, set5 = {}}

function BuildBankSave(st)
  local t = {}

  for i = 1, 19 do
    local item = GetInventoryItemLink("player", i)
    if item == nil then
      item = "not found"
    end
    table.insert(t, item)
  end
  Bank[st] = t
  _G.BuildBank = Bank
  print(config[st] .. " saved")
end

function BuildBankLoad(st)
  local not_found = {}
  for i = 1, 19 do
    local current = GetInventoryItemLink("player", i)
    local equip = Bank[st][i]
    if equip ~= "not found" and equip ~= current then
      if GetItemCount(equip, false, false) > 0 then
        EquipItemByName(equip, i)
      else
        table.insert(not_found, equip)
      end
    end
  end
  if #not_found == 0 then
    print("Build loaded successfully")
  else
    for i = 1, #not_found do
      print(not_found[i] .. " not equipped. Reason: Item not found in the backpack")
    end
    print(#not_found .. " items not loaded")
  end
end

local function UpdateFrames(set_name, value)
  frames[set_name][1]:SetText(l .. value)
  frames[set_name][2]:SetText(s .. value)
end

local function Commands(msg, editbox)
  local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")

  if (cmd ~= nil) and (args ~= nil) and (frames[cmd] ~= nil) then
    UpdateFrames(cmd, args)
    config[cmd] = args
    _G.BuildBankCC = config
  else
    print("Syntax: /buildbank (set1-5) newName");
    print("Syntax: /bb (set1-5) newName");
  end
end

SLASH_BUILDBANK1 = '/buildbank'
SLASH_BUILDBANK2 = '/bb'
SlashCmdList["BUILDBANK"] = Commands

local function Init()
  BuildBank = LoadConfig(BuildBankCC, DEFAULT_BANK)
  config = LoadConfig(BuildBankCC, DEFAULT_NAMES)

  frames.set1 = { BuildBankLoad1Frame, BuildBankSave1Frame }
  frames.set2 = { BuildBankLoad2Frame, BuildBankSave2Frame }
  frames.set3 = { BuildBankLoad3Frame, BuildBankSave3Frame }
  frames.set4 = { BuildBankLoad4Frame, BuildBankSave4Frame }
  frames.set5 = { BuildBankLoad5Frame, BuildBankSave5Frame }

  for i = 1, 5 do
    local set_name = "set" .. i
    print(set_name)

    UpdateFrames(set_name, config[set_name])
  end
end

function BuildBankWelcome(self)
  BBFrame = Librarian(BuildBankFrame, "BuildBank", Init)

  BBFrame:Show()
end
