function Librarian(frame, name, Init)
  if frame == nil then
    frame = CreateFrame('FRAME')
  end
  
  frame:RegisterEvent("ADDON_LOADED")

  local initialised = false
  local function OnAddonLoad(self, event)
    if initialised == false then
      if Init ~= nil then
        Init(frame, event)
      end
      initialised = true
      print(name .. " loaded")
    end
  end

  frame:SetScript("OnEvent", OnAddonLoad)

  return frame
end

function LoadConfig(global, default)
  if global == nil then
    return default
  else
    return global
  end
end
