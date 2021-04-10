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
      UTILS.Console.Primary(name .. " loaded")
    end
  end

  frame:SetScript("OnEvent", OnAddonLoad)

  return frame
end

function LoadConfig(global, default)
  if _G[global] == nil then
    _G[global] = default
    return default
  else
    return _G[global]
  end
end

-- /command arg1 arg2 arg3 ...
-- _ _ arg1 arg2 arg3 ...
function LoadCommand(command)
  return string.find(command, "%s?(%w+)%s?(.*)")
end
