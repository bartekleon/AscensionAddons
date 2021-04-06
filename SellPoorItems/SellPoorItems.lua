local function EventHandler(self, event)
  if event == "MERCHANT_SHOW" then
    for bag = 0, 4 do
      local caslots = GetContainerNumSlots(bag)
      if caslots ~= nil then
        for slot = 1, caslots do
          local item = GetContainerItemLink(bag, slot)
          if item and GetItemInfo(item)[3] == 0 then
            UseContainerItem(bag, slot)
          end
        end
      end
    end
  end
end

local function Init(frame, event)
  frame:RegisterEvent("MERCHANT_SHOW")
  frame:SetScript("OnEvent", EventHandler)
end

Librarian(nil, "SellPoorItems", Init)
