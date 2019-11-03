-- Licensed under MIT License
-- Copyright (c) 2019 redx
-- https://github.com/the-redx/Evolve
-- Version 1.0-beta

script_name("Punish log")
script_author('Edward_Franklin')
script_version("1.0-beta")
script_version_number(1.0)
--------------------------------------------------------------------
require 'lib.moonloader'
require 'lib.sampfuncs'
------------------------
local sampev = require 'lib.samp.events'
local encoding = require 'encoding'
------------------
encoding.default = 'CP1251'
local u8 = encoding.UTF8
local myid = -1
--------------------------------------------------------------------
-- Variables
fractions = {'Vagos Gang', 'Grove Gang', 'Rifa Gang', 'Ballas Gang', 'Aztecas Gang', 'LCN', 'Russian Mafia', 'Yakuza'}
fractions_ex = {'Warlocks MC', 'Pagans MC', 'Mongols MC'}
--------------------------------------------------------------------

function main()
  if not isSampfuncsLoaded() or not isSampLoaded() then return end
  while not isSampAvailable() do wait(100) end
  if not doesDirectoryExist("moonloader\\config") then createDirectory("moonloader\\config") end
  while not sampIsLocalPlayerSpawned() do wait(0) end
  local _, id = sampGetPlayerIdByCharHandle(playerPed)
  myid = id
  while true do wait(0) end
end

function sampev.onServerMessage(color, text)
  -- chatID fix. Удаляет все ID возле ника игрока
  local finds = {1, 1}
   while true do
    local space_match = text:find("%w+_%w+ %[%d+%]", finds[1])
    local match = text:find("%w+_%w+%[%d+%]", finds[2])
    if space_match ~= nil and space_match > finds[1] then
      local name, surname, playerid = text:match("(%w+)_(%w+) %[(%d+)%]")
      local nick = name.."_"..surname
      finds[1] = space_match
      playerid = tonumber(playerid)
      if playerid ~= nil and (sampIsPlayerConnected(playerid) or playerid == myid) then
        if sampGetPlayerNickname(playerid) == nick then
          text = text:gsub(" %["..playerid.."%]", "")
        end
      end
    elseif match ~= nil and match > finds[2] then
      local name, surname, playerid = text:match("(%w+)_(%w+)%[(%d+)%]")
      local nick = name.."_"..surname
      finds[2] = match
      playerid = tonumber(playerid)
      if playerid ~= nil and (sampIsPlayerConnected(playerid) or playerid == myid) then
        if sampGetPlayerNickname(playerid) == nick then
          text = text:gsub("%["..playerid.."%]", "")
        end
      end
    else break end
  end
  --[18.10.2019 | 15:13:29] Администратор: Laymont_Breezy выдал warn Putiy_Ingrosso[Grove Gang/7]. Причина: cheat
  --[18.10.2019 | 15:43:18] Администратор: Mihail_Klimov выдал warn Mark_Moss[Ballas Gang/7]. Причина: SpeedHack
  
  -- Администратор: Luis_Guerra забанил Rik_Walker[Grove Gang/7] [3 Предупреждения]. Причина: extra ws
  if text:find("^ Администратор%: .- забанил .-%[.-%/%d+%] %[3 Предупреждения%]%. Причина%: .+") and color == -10270806 then
    local from, kto, frac, rank, _ = text:match("Администратор%: (.-) забанил (.-)%[(.-)%/(%d+)%] %[3 Предупреждения%]%. Причина%: (.+)")
    print(('Чувачок %s отлетел от %s. Фракция: %s Ранг: %s'):format(kto, from, frac, rank))
    if (tonumber(rank) >= 7 and table.contains(fractions, frac)) or (tonumber(rank) >= 6 and table.contains(fractions_ex, frac)) then
      logFile(text)
    end
  end

  -- Администратор: Sam_Teller выдал warn Pyps_Hatez[Aztecas Gang/7]. Причина: aim 
  if text:find("^ Администратор%: .- выдал warn .-%[.-%/%d+%]%. Причина%: .+") and color == -10270806 then
    local from, kto, frac, rank, _ = text:match("Администратор%: (.-) выдал warn (.-)%[(.-)%/(%d+)%]%. Причина%: (.+)")
    print(('Чувачок %s отлетел от %s. Фракция: %s Ранг: %s'):format(kto, from, frac, rank))
    if (tonumber(rank) >= 7 and table.contains(fractions, frac)) or (tonumber(rank) >= 6 and table.contains(fractions_ex, frac)) then
      logFile(text)
    end
  end
end

function logFile(text)
  local file = io.open('moonloader/config/punishlog.txt', 'a+')
  local dates = '['..os.date('%d.%m.%Y')..' | '..os.date('%H:%M:%S')..']'
  file:write(dates.." "..text.."\n")
  file:close()
end

function table.contains(object, value)
  for k, v in pairs(object) do
    if v == value then
      return true
    end
  end
  return false
end