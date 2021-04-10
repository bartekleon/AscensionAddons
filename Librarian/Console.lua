if UTILS == nil then
  UTILS = _G["UTILS"]
end

local COLOR_PRIMARY = "ff0d6efd"
local COLOR_ERROR = "ffdc3545"
local COLOR_WARNING = "ffffc107"
local COLOR_INFO = "ff0dcaf0"
local COLOR_SUCCESS = "ff198754"
local COLOR_DEBUG = "ff6c757d"

UTILS.Console = {
  COLOR_PRIMARY = COLOR_PRIMARY,
  COLOR_ERROR = COLOR_ERROR,
  COLOR_WARNING = COLOR_WARNING,
  COLOR_INFO = COLOR_INFO,
  COLOR_SUCCESS = COLOR_SUCCESS,
  COLOR_DEBUG = COLOR_DEBUG,
}

local function empty(text)
  if text == nil then
    return ""
  else
    return text
  end
end

function UTILS.Console.ColorText(color, text, text2)
  return "|c" .. color .. text .. "|r" .. empty(text2)
end

function UTILS.Console.Print(color, text, text2)
  print(UTILS.Console.ColorText(color, text, text2))
end

function UTILS.Console.Primary(text, text2)
  UTILS.Console.Print(COLOR_PRIMARY, text, text2)
end
function UTILS.Console.Error(text, text2)
  UTILS.Console.Print(COLOR_ERROR, text, text2)
end
function UTILS.Console.Warning(text, text2)
  UTILS.Console.Print(COLOR_WARNING, text, text2)
end
function UTILS.Console.Info(text, text2)
  UTILS.Console.Print(COLOR_INFO, text, text2)
end
function UTILS.Console.Success(text, text2)
  UTILS.Console.Print(COLOR_SUCCESS, text, text2)
end
function UTILS.Console.Debug(text)
  UTILS.Console.Print(COLOR_DEBUG, text, text2)
end
