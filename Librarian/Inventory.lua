if UTILS == nil then
  UTILS = _G["UTILS"]
end

UTILS.Inventory = {
  bank_opened = false
}

function UTILS.Inventory.GetBankNumSlots(id)
  if id == NUM_BAG_SLOTS then
    return GetContainerNumSlots(BANK_CONTAINER)
  else
    return GetContainerNumSlots(NUM_BAG_SLOTS + id)
  end
end

function UTILS.Inventory.PutItemInTheBag(id)
  if id == 19 then
    PutItemInBackpack()
  else 
    PutItemInBag(id)
  end
end

local BankFrame = CreateFrame("FRAME")

BankFrame:RegisterEvent("BANKFRAME_OPENED")
BankFrame:RegisterEvent("BANKFRAME_CLOSED")
BankFrame:SetScript("OnEvent", function(self, event)
  if event == "BANKFRAME_OPENED" then
    UTILS.Inventory.bank_opened = true
  elseif event == "BANKFRAME_CLOSED" then
    UTILS.Inventory.bank_opened = false
  end
end)