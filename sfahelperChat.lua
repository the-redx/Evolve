script_name("SFA Helper CHAT") 
script_authors({ 'Edward_Franklin' })
script_version("0.2")
DEBUG_MODE = true
GIT_DIRECTORY = "dev"
--[[
* a - альфа
* b - бета
* rc - выпуск-кандидат
* r - для распространения
]]
--------------------------------------------------------------------
require "lib.moonloader"
--require "luairc"
local luairc, _ = pcall(require, 'luairc')
--local sampevents = require "lib.samp.events"
local encoding = require 'encoding'
local imgui = require 'imgui'
encoding.default = 'CP1251'
local u8 = encoding.UTF8
--------------------------------------------------------------------
local chatwindow = imgui.ImBool(false)
imgui.ToggleButton = require('imgui_addons').ToggleButton
local screenx, screeny = getScreenResolution()
----------
local ircInfo = {
  active = false,
  connected = false,
  channel = "#sfahelperchat01",
  server = "ipo.esper.net",
  -- ipo.esper.net, eu.irc.esper.net  
}
local permissionsInfo = {}
local pInfo = {
  group = "Main",
  autoconnect = false,
  IRCLatency = 1500,
  color = "FF0000",
  prefix = " | "
}
local sInfo = {
  role = "",
  nick = "",
  playerid = -1
}
local data = {
  imgui = {
    groupselect = imgui.ImInt(0)
  }
}
IRCLogs = {}
--------------------------------------------------------------------
function main()
  apply_custom_style()
  if not isSampfuncsLoaded() or not isSampLoaded() then return end
  while not isSampAvailable() do wait(100) end
  loadFiles()
  ---------
  autoupdate("https://raw.githubusercontent.com/the-redx/Evolve/"..GIT_DIRECTORY.."/update.json")
  sampRegisterChatCommand("k", ircsend)
  sampRegisterChatCommand("kpm", ircquery)
  sampRegisterChatCommand("irc_raw", ircraw)
  sampRegisterChatCommand('kinvite', cmd_kinvite)
  sampRegisterChatCommand('kuninvite', cmd_kuninvite)
  sampRegisterChatCommand('kgiverole', cmd_kgiverole)
  sampRegisterChatCommand('kmembers', cmd_kmembers)
  sampRegisterChatCommand('shchat', function() chatwindow.v = not chatwindow.v end)
  sampRegisterChatCommand('shcmds', function()
    local str = ""
    str = str.."{FFFFFF} /k [текст]{CCCCCC} - Отправить сообщение в канале;\n"
    str = str.."{FFFFFF} /kpm [playerid/nick]{CCCCCC} - Отправить личное сообщение;\n"
    str = str.."{FFFFFF} /kinvite [playerid/nick]{CCCCCC} - Пригласить игрока в канал;\n"
    str = str.."{FFFFFF} /kuninvite [playerid/nick]{CCCCCC} - Удалить игрока из канала;\n"
    str = str.."{FFFFFF} /kgiverole [playerid/nick] [role]{CCCCCC} - Установить игроку роль в канале;\n"
    str = str.."{FFFFFF} /kmembers{CCCCCC} - Просмотра игроков, состоящих в текущем канале;\n"
    str = str.."{FFFFFF} /shchat{CCCCCC} - Настройки чата;\n"
    sampShowDialog(6325785, "{954F4F}SFA-Helper CHAT | {FFFFFF}Список команд", str, "Закрыть", "", DIALOG_STYLE_MSGBOX)
  end)
  --------------------=========----------------------
  if doesFileExist("moonloader/SFAHelper/chat_config.json") then
    local fa = io.open("moonloader/SFAHelper/chat_config.json", 'a+')
    if fa then
      local config_k = decodeJson(fa:read('*a'))
      if config_k ~= nil then 
        debug_log("Starting additionArray. From = 'moonloader/SFAHelper/chat_config.json', TO = pInfo")
        pInfo = additionArray(config_k, pInfo) 
      end    
    end
    fa:close()
  end
  saveData(pInfo, "moonloader/SFAHelper/chat_config.json")
  ---------
  while not sampIsLocalPlayerSpawned() do wait(0) end
  local _, myid = sampGetPlayerIdByCharHandle(playerPed)
  sInfo.playerid = myid
  sInfo.nick = sampGetPlayerNickname(myid)
  ------
  if luairc then
    s = irc.new{ nick = sInfo.nick.."_sh01" }
    local thread1 = lua_thread.create(secondThread, false)
  end
  while true do wait(0)
    if chatwindow.v then imgui.Process = true
    else imgui.Process = false end
  end
end

------------------------ CMD ------------------------
function ircsend(param)
  if ircInfo.connected == false then atext('Вы не подключены к серверу!') return end
  if #param == 0 then
    atext('Введите: /k [текст]')
    return
  end
  ktext(("%s[%d]: %s"):format(sInfo.nick, sInfo.playerid, param))
  sendstr = AnsiToUtf8(pInfo.group.."|"..param)
  s:sendChat(ircInfo.channel, sendstr)
end

function ircquery(param)
  if ircInfo.connected == false then atext('Вы не подключены к серверу!') return end
  if #param == 0 then
    atext('Введите: /kpm [playerid/nick] [текст]')
    return
  end
  local args = string.split(param, " ", 2)
  local pid = tonumber(args[1])
  if sInfo.playerid == pid then atext('Вы не можете отправить личное сообщение самому себе!') return end
  if pid ~= nil then
    if sampIsPlayerConnected(pid) then args[1] = sampGetPlayerNickname(pid)
    else pid = nil end
  else
    pid = sampGetPlayerIdByNickname(args[1])
    if pid == false then pid = nil end
  end
  -----
  local color = string.format("0x%s", pInfo.color)
  sampAddChatMessage(("PM -> %s%s{FFFFFF}: %s"):format(tostring(args[1]), pid ~= nil and "["..pid.."]" or "", tostring(args[2])), color)
  sendstr = AnsiToUtf8(string.format("PRIVMSG %s :%s", tostring(args[1]).."_sh01", tostring(args[2])))
  s:send(sendstr)
end

function ircraw(param)
  if sInfo.nick ~= "Edward_Franklin" and sInfo.nick ~= "Eduardo_Carmone" and sInfo.nick ~= "Jonathan_Belin" then return end
  if ircInfo.connected == false then atext('Вы не подключены к серверу!') return end
  if #param == 0 then
    atext('Введите: /irc_raw [текст]')
    return
  end
  sampAddChatMessage("[IRC] [RAW SEND]: "..param, 0xffff00)
  sendstr = AnsiToUtf8(param)
  s:send("%s", sendstr)
end

function kinvite(arg)
  if ircInfo.connected == false then atext('Вы не подключены к серверу!') return end

end

function kuninvite(arg)
  if ircInfo.connected == false then atext('Вы не подключены к серверу!') return end

end

function kgiverole(arg)
  if ircInfo.connected == false then atext('Вы не подключены к серверу!') return end

end

function kmembers(arg)
  if ircInfo.connected == false then atext('Вы не подключены к серверу!') return end
  local str = "Ник\tРоль\tСтатус\n"
  for i = 1, #permissionsInfo do
    if permissionsInfo[i].group == pInfo.group then
      str = str..string.format("%s\t%s\t%s\n", permissionsInfo[i].nick, permissionsInfo[i].role, "{ae433d}Оффлайн")
    end
  end
  sampShowDialog(1895685, "SFA-Helper CHAT", str, "Закрыть", "", DIALOG_STYLE_TABLIST_HEADERS)
end

------------------------ FUNCTIONS ------------------------
function secondThread()
  while true do wait(0)
    if ircInfo.active == true and ircInfo.connected == false then
      atext("Init soket...")
      local sleep = require "socket".sleep
      s:hook("OnChat", function(user, channel, message)
        if channel:find("_sh01") then
          local nickname = user.nick:match("(.+)_sh01")
          if nickname == "" or nickname == nil then return end
          local color = string.format("0x%s", pInfo.color)
          local pid = sampGetPlayerIdByNickname(nickname)
          sampAddChatMessage(("PM <- %s%s{FFFFFF}: %s"):format(nickname, pid == false and "" or "["..pid.."]", u8:decode(message)), color)
          return
        end
        if channel ~= ircInfo.channel then return end
        local nickname = user.nick:match("(.+)_sh01")
        local group, mess = message:match("(.+)|(.+)")
        if nickname == "" or nickname == nil then return end
        if pInfo.group ~= group then return end
        local pid = sampGetPlayerIdByNickname(nickname)
        ktext(("%s%s: %s"):format(nickname, pid == false and "" or "["..pid.."]", u8:decode(mess)))
        addOneOffSound(0.0, 0.0, 0.0, 1054)
      end)
      s:hook("OnRaw", function(line)
        --[[if string.find(line, "VERSION") ~= nil then
          sampAddChatMessage("REQUEST VERSION! ZONDS!!! ALARM!!!1", 0xff0000)
          s:sendChat(Channel, string.format("SAMPIrcClient: 0.4.1 SAMP, Moonloader: 0.%d", getMoonloaderVersion()))
          addOneOffSound(0.0, 0.0, 0.0, 1054)
        end--]]
        if DEBUG_MODE then
          msgStrs = Utf8ToAnsi("[IRC] RAW: "..line)
          print(msgStrs)
        end
      end)
      atext("Connecting to server...")
      s:connect(ircInfo.server)
      s:send("NICK %s", sInfo.nick.."_sh01")
      wait(2500)
      atext("Вы подключились к каналу: "..pInfo.group)
      ktext("Используйте команду /k для взаимодействия с чатом. Просмотреть список команд: /shcmds")
      s:join(ircInfo.channel)
      ircInfo.connected = true
      loadPermissions('https://docs.google.com/spreadsheets/d/1qmpQvUCoWEBYfI3VqFT3_08708iLaSKPfa-A6QaHw_Y/export?format=tsv&id=1qmpQvUCoWEBYfI3VqFT3_08708iLaSKPfa-A6QaHw_Y&gid=1131272175')
    end
    --[[if pInfo.autoconnect == true then
      ircInfo.active = true
    end]]
    if ircInfo.active == false and ircInfo.connected == true then
      s:disconnect()
      atext('Отключено от сервера')
      ircInfo.connected = false
    end
    wait(pInfo.IRCLatency)
    if ircInfo.connected == true then s:think() end
  end
end

function loadFiles()
  lua_thread.create(function()
    if not luairc then
      print('Загружаем необходимые библиотеки...')
      local files = {'.travis.yml', 'asyncoperations.lua', 'handlers.lua', 'luairc.lua', 'set.lua', 'util.lua'}
      for k, v in pairs(files) do
        local dlstatus = require('moonloader').download_status
        sampev_download_status = 'proccess'
        downloadUrlToFile('https://raw.githubusercontent.com/the-redx/Evolve/master/lib/'..v, 'moonloader/lib/'..v, function(id, status, p1, p2)
          if status == dlstatus.STATUS_DOWNLOADINGDATA then
            sampev_download_status = 'proccess'
            print(string.format('Загружено %d килобайт из %d килобайт.', p1, p2))
          elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
            sampev_download_status = 'succ'
          elseif status == 64 then
            sampev_download_status = 'failed'
          end
        end)
        while sampev_download_status == 'proccess' do wait(0) end
        if sampev_download_status == 'failed' then
          print('Не удалось загрузить необходимые библиотеки')
          thisScript():unload()
        else
          print(v..' был загружен')
        end
      end
      print('Загрузка окончена')
      thisScript():reload()
    end
  end)
end

function loadPermissions(table_url)
  lua_thread.create(function()
    local dlstatus = require('moonloader').download_status
    local tsv = getWorkingDirectory() .. '\\SFAHelper\\'..thisScript().name..'-permissions.tsv'
    if doesFileExist(tsv) then os.remove(tsv) end
    downloadUrlToFile(table_url, tsv,
      function(id, status, p1, p2)
        if status == dlstatus.STATUSEX_ENDDOWNLOAD then
          if doesFileExist(tsv) then
            local f = io.open(tsv, 'r')
            if f then
              f:close()
              local startline = false
              local groupfind = ""
              permissionsInfo = {}
              for line in io.lines(tsv) do
                if startline == true then
                  local args = string.split(line, "\t")
                  if args[1] ~= nil and args[2] ~= nil and args[3] ~= nil then
                    if args[3] == sInfo.nick then
                      if pInfo.group == u8:decode(args[2]) then
                        groupfind = nil
                        sInfo.role = u8:decode(args[1])
                      end
                      if args[2] == "Main" and groupfind ~= nil then
                        groupfind = u8:decode(args[1])
                      end
                    end
                    permissionsInfo[#permissionsInfo + 1] = { nick = args[3], group = u8:decode(args[2]), role = u8:decode(args[1]), status = false }
                  end
                end
                if line:match("^Users") then startline = true end
              end
              if groupfind ~= nil then 
                pInfo.group = "Main"
                sInfo.role = groupfind
              end
              os.remove(tsv)
            end
          else print('v'..thisScript().version..': Не могу загрузить права пользователей') end
          complete = true
        end
      end
    )
    while complete ~= true do wait(100) end
  end)
end

function autoupdate(json_url)
  lua_thread.create(function()
  local dlstatus = require('moonloader').download_status
  local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
  if doesFileExist(json) then os.remove(json) end
  downloadUrlToFile(json_url, json,
    function(id, status, p1, p2)
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        if doesFileExist(json) then
          local f = io.open(json, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            updatelink = info.sfahelperchat.url
            updateversion = info.sfahelperchat.version
            f:close()
            os.remove(json)
            if updateversion > thisScript().version then
              lua_thread.create(function()
                local dlstatus = require('moonloader').download_status
                local color = -1
                local path = thisScript().path
                atext('Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion)
                wait(250)
                downloadUrlToFile(updatelink, path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('Загружено %d из %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      debug_log('Загрузка обновления завершена.')
                      atext('Обновление завершено')
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                          atext('Обновление прошло неудачно. Запускаю устаревшую версию..')
                        update = false
                      end
                    end
                  end
                )
                end, 'SFA-Helper CHAT'
            )
            else
              update = false
              print('v'..thisScript().version..': Обновление не требуется.')
            end
          end
        else
          print('v'..thisScript().version..': Не могу проверить обновление.')
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
  end)
end



------------------------ HOOKS ------------------------
function imgui.OnDrawFrame()
  if chatwindow.v then
    imgui.SetNextWindowPos(imgui.ImVec2(screenx / 2, screeny / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(375, 250), imgui.Cond.FirstUseEver)
		imgui.Begin(u8'SFAHelper | Настройки клиента', chatwindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoResize)
    local target = imgui.ImBool(ircInfo.active)
    local autoconnect = imgui.ImBool(pInfo.autoconnect)
    local preparedgroups = ""
    local count = 0
    local preparedtable = {}
    for i = 1, #permissionsInfo do
      if permissionsInfo[i].nick == sInfo.nick then
        if pInfo.group == permissionsInfo[i].group then data.imgui.groupselect.v = count end
        preparedgroups = preparedgroups..u8:encode(permissionsInfo[i].group).."\0"
        count = count + 1
        preparedtable[#preparedtable + 1] = { group = permissionsInfo[i].group, role = permissionsInfo[i].role }
      end
    end
    preparedgroups = preparedgroups.."\0"
    imgui.PushItemWidth(100)
    if imgui.ToggleButton(u8 'connect##1', target) then
      ircInfo.active = target.v
    end
    imgui.SameLine(); imgui.Text(u8 'Подключиться к серверу') 
    if imgui.ToggleButton(u8 'autoconnect##1', autoconnect) then
      pInfo.autoconnect = autoconnect.v
      saveData(pInfo, "moonloader/SFAHelper/chat_config.json")
    end
    imgui.SameLine(); imgui.Text(u8 'Автоматическое подключение к серверу при входе')
    imgui.Separator()
    imgui.Text(u8'Основная информация')
    if ircInfo.active == true then
      imgui.Text(u8'Ваш текущий канал: '..u8:encode(pInfo.group))
      imgui.Text(u8'Ваша текущая роль: '..u8:encode(sInfo.role))
      if imgui.Combo(u8 'Сменить канал', data.imgui.groupselect, preparedgroups) then
        atext(('Вы успешно изменили канал %s -> %s'):format(pInfo.group, preparedtable[data.imgui.groupselect.v + 1].group))
        pInfo.group = preparedtable[data.imgui.groupselect.v + 1].group
        sInfo.role = preparedtable[data.imgui.groupselect.v + 1].role
      end
      imgui.NewLine()
      imgui.Text(u8'Список каналов, в которых вы состоите:')
      for i = 1, #permissionsInfo do
        if permissionsInfo[i].nick == sInfo.nick then
          imgui.Text(u8 "Канал: "..u8:encode(permissionsInfo[i].group)); imgui.SameLine(); imgui.Text(u8 "Роль: "..u8:encode(permissionsInfo[i].role))
        end
      end
    else imgui.Text(u8'Для отображения настроек необходимо подключится к серверу') end
    imgui.End()
  end
end



------------------------ SECONDARY FUNCTIONS ------------------------
function checkIntable(t, key)
  for k, v in pairs(t) do
      if v == key then return true end
  end
  return false
end

function ARGBtoRGB(color)
    local a = bit.band(bit.rshift(color, 24), 0xFF)
    local r = bit.band(bit.rshift(color, 16), 0xFF)
    local g = bit.band(bit.rshift(color, 8), 0xFF)
    local b = bit.band(color, 0xFF)
    local rgb = b
    rgb = bit.bor(rgb, bit.lshift(g, 8))
    rgb = bit.bor(rgb, bit.lshift(r, 16))
    return rgb
end

function secToTime(sec)
  local hour, minute, second = sec / 3600, math.floor(sec / 60), sec % 60
  return string.format("%02d:%02d:%02d", math.floor(hour) ,  minute - (math.floor(hour) * 60), second)
end

function string.split(inputstr, sep, limit)
  if limit == nil then limit = 0 end
  if sep == nil then sep = "%s" end
  local t={} ; i=1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    if i >= limit and limit > 0 then
      if t[i] == nil then
        t[i] = ""..str
      else
        t[i] = t[i]..sep..str
      end
    else
      t[i] = str
      i = i + 1
    end
  end
  return t
end

function atext(text)
  text = tostring(text)
  sampAddChatMessage(" CHAT | {FFFFFF}"..text, 0x954F4F)
end

function ktext(text)
  text = tostring(text)
  local color = string.format("0x%s", pInfo.color)
  sampAddChatMessage((" %s%s{FFFFFF}%s"):format(pInfo.group, pInfo.prefix, text), color)
end

function debug_log(text)
  if tonumber(text) == 1 then 
    local file = io.open('moonloader/SFAHelper/debug.txt', 'w+')
    file:close()
    file = nil
  else 
    local file = io.open('moonloader/SFAHelper/debug.txt', 'a')
	  file:write(('[%s || %s] (sfahelperChat) %s\n'):format(os.date('%H:%M:%S'), os.date('%d.%m.%Y'), text))
    file:close()
    file = nil
  end
end

-- Максимальная глубина вхождения = 4 (table.one.two.three)
function additionArray(table, to)
  if table == nil then return to end
  for k, v in pairs(table) do
    if type(v) == "table" then
      if to[k] == nil then to[k] = {} end
      for k1, v1 in pairs(v) do
        if type(v1) == "table" then
          if to[k][k1] == nil then to[k][k1] = {} end
        else to[k][k1] = v1 end
      end
    else to[k] = v end
  end
  return to
end

function saveData(table, path)
  if path == 'moonloader/SFAHelper/config.json' and table.info.weekOnline < 0 then return end
	if doesFileExist(path) then os.remove(path) end
    local sfa = io.open(path, "w")
    if sfa then
        sfa:write(encodeJson(table))
        sfa:close()
    end
end

function imgui.CentrText(text)
  local width = imgui.GetWindowWidth()
  local calc = imgui.CalcTextSize(text)
  imgui.SetCursorPosX( width / 2 - calc.x / 2 )
  imgui.Text(text)
end

function imgui.TextColoredRGB(text)
  local style = imgui.GetStyle()
  local colors = style.Colors
  local ImVec4 = imgui.ImVec4

  local explode_argb = function(argb)
    local a = bit.band(bit.rshift(argb, 24), 0xFF)
    local r = bit.band(bit.rshift(argb, 16), 0xFF)
    local g = bit.band(bit.rshift(argb, 8), 0xFF)
    local b = bit.band(argb, 0xFF)
    return a, r, g, b
  end

  local getcolor = function(color)
      if color:sub(1, 6):upper() == 'SSSSSS' then
          local r, g, b = colors[1].x, colors[1].y, colors[1].z
          local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
          return ImVec4(r, g, b, a / 255)
      end
      local color = type(color) == 'string' and tonumber(color, 16) or color
      if type(color) ~= 'number' then return end
      local r, g, b, a = explode_argb(color)
      return imgui.ImColor(r, g, b, a):GetVec4()
  end

  local render_text = function(text_)
      for w in text_:gmatch('[^\r\n]+') do
          local text, colors_, m = {}, {}, 1
          w = w:gsub('{(......)}', '{%1FF}')
          while w:find('{........}') do
              local n, k = w:find('{........}')
              local color = getcolor(w:sub(n + 1, k - 1))
              if color then
                  text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                  colors_[#colors_ + 1] = color
                  m = n
              end
              w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
          end
          if text[0] then
              for i = 0, #text do
                  imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
                  imgui.SameLine(nil, 0)
              end
              imgui.NewLine()
          else imgui.Text(u8(w)) end
      end
  end
  render_text(text)
end

function imgui.TextQuestion(text)
  imgui.TextDisabled('(?)')
  if imgui.IsItemHovered() then
      imgui.BeginTooltip()
      imgui.PushTextWrapPos(450)
      imgui.TextUnformatted(text)
      imgui.PopTextWrapPos()
      imgui.EndTooltip()
  end
end

local ansi_decode={
  [128]='\208\130',[129]='\208\131',[130]='\226\128\154',[131]='\209\147',[132]='\226\128\158',[133]='\226\128\166',
  [134]='\226\128\160',[135]='\226\128\161',[136]='\226\130\172',[137]='\226\128\176',[138]='\208\137',[139]='\226\128\185',
  [140]='\208\138',[141]='\208\140',[142]='\208\139',[143]='\208\143',[144]='\209\146',[145]='\226\128\152',
  [146]='\226\128\153',[147]='\226\128\156',[148]='\226\128\157',[149]='\226\128\162',[150]='\226\128\147',[151]='\226\128\148',
  [152]='\194\152',[153]='\226\132\162',[154]='\209\153',[155]='\226\128\186',[156]='\209\154',[157]='\209\156',
  [158]='\209\155',[159]='\209\159',[160]='\194\160',[161]='\209\142',[162]='\209\158',[163]='\208\136',
  [164]='\194\164',[165]='\210\144',[166]='\194\166',[167]='\194\167',[168]='\208\129',[169]='\194\169',
  [170]='\208\132',[171]='\194\171',[172]='\194\172',[173]='\194\173',[174]='\194\174',[175]='\208\135',
  [176]='\194\176',[177]='\194\177',[178]='\208\134',[179]='\209\150',[180]='\210\145',[181]='\194\181',
  [182]='\194\182',[183]='\194\183',[184]='\209\145',[185]='\226\132\150',[186]='\209\148',[187]='\194\187',
  [188]='\209\152',[189]='\208\133',[190]='\209\149',[191]='\209\151'
}
local utf8_decode={
  [128]={[147]='\150',[148]='\151',[152]='\145',[153]='\146',[154]='\130',[156]='\147',[157]='\148',[158]='\132',[160]='\134',[161]='\135',[162]='\149',[166]='\133',[176]='\137',[185]='\139',[186]='\155'},
  [130]={[172]='\136'},
  [132]={[150]='\185',[162]='\153'},
  [194]={[152]='\152',[160]='\160',[164]='\164',[166]='\166',[167]='\167',[169]='\169',[171]='\171',[172]='\172',[173]='\173',[174]='\174',[176]='\176',[177]='\177',[181]='\181',[182]='\182',[183]='\183',[187]='\187'},
  [208]={[129]='\168',[130]='\128',[131]='\129',[132]='\170',[133]='\189',[134]='\178',[135]='\175',[136]='\163',[137]='\138',[138]='\140',[139]='\142',[140]='\141',[143]='\143',[144]='\192',[145]='\193',[146]='\194',[147]='\195',[148]='\196',
  [149]='\197',[150]='\198',[151]='\199',[152]='\200',[153]='\201',[154]='\202',[155]='\203',[156]='\204',[157]='\205',[158]='\206',[159]='\207',[160]='\208',[161]='\209',[162]='\210',[163]='\211',[164]='\212',[165]='\213',[166]='\214',
  [167]='\215',[168]='\216',[169]='\217',[170]='\218',[171]='\219',[172]='\220',[173]='\221',[174]='\222',[175]='\223',[176]='\224',[177]='\225',[178]='\226',[179]='\227',[180]='\228',[181]='\229',[182]='\230',[183]='\231',[184]='\232',
  [185]='\233',[186]='\234',[187]='\235',[188]='\236',[189]='\237',[190]='\238',[191]='\239'},
  [209]={[128]='\240',[129]='\241',[130]='\242',[131]='\243',[132]='\244',[133]='\245',[134]='\246',[135]='\247',[136]='\248',[137]='\249',[138]='\250',[139]='\251',[140]='\252',[141]='\253',[142]='\254',[143]='\255',[144]='\161',[145]='\184',
  [146]='\144',[147]='\131',[148]='\186',[149]='\190',[150]='\179',[151]='\191',[152]='\188',[153]='\154',[154]='\156',[155]='\158',[156]='\157',[158]='\162',[159]='\159'},[210]={[144]='\165',[145]='\180'}
}

local nmdc = {
  [36] = '$',
  [124] = '|',
}

function sampGetPlayerIdByNickname(nick)
  if sInfo.nick == nick then return sInfo.playerid end
  for id = 0, 1000 do if sampIsPlayerConnected(id) and nick == sampGetPlayerNickname(id) then return id end end
  return false
end

function AnsiToUtf8(s)
  local r, b = ''
  for i = 1, s and s:len() or 0 do
    b = s:byte(i)
    if b < 128 then
      r = r..string.char(b)
    else
      if b > 239 then
        r = r..'\209'..string.char(b - 112)
      elseif b > 191 then
        r = r..'\208'..string.char(b - 48)
      elseif ansi_decode[b] then
        r = r..ansi_decode[b]
      else
        r = r..'_'
      end
    end
  end
  return r
end
function Utf8ToAnsi(s)
  local a, j, r, b = 0, 0, ''
  for i = 1, s and s:len() or 0 do
    b = s:byte(i)
    if b < 128 then
      if nmdc[b] then
        r = r..nmdc[b]
      else
        r = r..string.char(b)
      end
    elseif a == 2 then
      a, j = a - 1, b
    elseif a == 1 then
      if (utf8_decode[j] or {})[b] then
        a, r = a - 1, r..utf8_decode[j][b]
      end
    elseif b == 226 then
      a = 2
    elseif b == 194 or b == 208 or b == 209 or b == 210 then
      j, a = b, 1
    else
      r = r..'_'
    end
  end
  return r
end

function apply_custom_style()
  imgui.SwitchContext()
  local style = imgui.GetStyle()
  local colors = style.Colors
  local clr = imgui.Col
  local ImVec4 = imgui.ImVec4
  local ImVec2 = imgui.ImVec2

  style.WindowPadding = ImVec2(10, 10)
  style.FramePadding = ImVec2(4, 4)
  style.ItemSpacing = imgui.ImVec2(8.0, 5.0)
  style.ItemInnerSpacing = ImVec2(8, 6)
  style.ScrollbarSize = 13.0
  style.ScrollbarRounding = 0
  style.IndentSpacing = 25.0

  colors[clr.Text] = ImVec4(1.00, 1.00, 1.00, 1.00)
  colors[clr.TextDisabled] = ImVec4(0.60, 0.60, 0.60, 1.00)
  colors[clr.WindowBg] = ImVec4(0.11, 0.10, 0.11, 1.00)
  colors[clr.ChildWindowBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
  colors[clr.PopupBg] = ImVec4(0.11, 0.10, 0.11, 1.00)
  colors[clr.Border] = ImVec4(0.86, 0.86, 0.86, 1.00)
  colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
  colors[clr.FrameBg] = ImVec4(0.21, 0.20, 0.21, 0.60)
  colors[clr.FrameBgHovered] = ImVec4(0.68, 0.25, 0.25, 0.75)
  colors[clr.FrameBgActive] = ImVec4(0.68, 0.25, 0.25, 1.00)
  colors[clr.TitleBg] = ImVec4(0.68, 0.25, 0.25, 1.00)
  colors[clr.TitleBgCollapsed] = ImVec4(0.68, 0.25, 0.25, 1.00)
  colors[clr.TitleBgActive] = ImVec4(0.68, 0.25, 0.25, 1.00)
  colors[clr.MenuBarBg] = ImVec4(0.68, 0.25, 0.25, 1.00)
  colors[clr.ScrollbarBg] = ImVec4(0.56, 0.56, 0.58, 0.00)
  colors[clr.ScrollbarGrab] = ImVec4(0.56, 0.56, 0.58, 0.44)
  colors[clr.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 0.74)
  colors[clr.ScrollbarGrabActive] = ImVec4(0.68, 0.25, 0.25, 1.00)
  colors[clr.ComboBg] = ImVec4(0.15, 0.14, 0.15, 1.00)
  colors[clr.CheckMark] = ImVec4(0.68, 0.25, 0.25, 1.00)
  colors[clr.SliderGrab] = ImVec4(0.68, 0.25, 0.25, 1.00)
  colors[clr.SliderGrabActive] = ImVec4(0.68, 0.25, 0.25, 1.00)
  colors[clr.Button] = ImVec4(0.68, 0.25, 0.25, 1.00)
  colors[clr.ButtonHovered] = ImVec4(0.68, 0.25, 0.25, 0.75)
  colors[clr.ButtonActive] = ImVec4(0.68, 0.25, 0.25, 1.00)
  colors[clr.Header] = ImVec4(0.68, 0.25, 0.25, 1.00)
  colors[clr.HeaderHovered] = ImVec4(0.68, 0.25, 0.25, 0.75)
  colors[clr.HeaderActive] = ImVec4(0.68, 0.25, 0.25, 1.00)
  colors[clr.ResizeGrip] = ImVec4(1.00, 1.00, 1.00, 0.30)
  colors[clr.ResizeGripHovered] = ImVec4(1.00, 1.00, 1.00, 0.60)
  colors[clr.ResizeGripActive] = ImVec4(1.00, 1.00, 1.00, 0.90)
  colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
  colors[clr.CloseButtonHovered] = ImVec4(0.06, 0.05, 0.07, 1.00)
  colors[clr.CloseButtonActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
  colors[clr.PlotLines] = ImVec4(0.00, 0.00, 0.00, 0.00)
  colors[clr.PlotLinesHovered] = ImVec4(0.00, 0.00, 0.00, 0.00)
  colors[clr.PlotHistogram] = ImVec4(0.00, 0.00, 0.00, 0.00)
  colors[clr.PlotHistogramHovered] = ImVec4(0.00, 0.00, 0.00, 0.00)
  colors[clr.TextSelectedBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
  colors[clr.ModalWindowDarkening] = ImVec4(0.00, 0.00, 0.00, 0.00)
end
