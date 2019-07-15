script_name("Activity") 
script_authors({ 'Edward_Franklin', 'Thomas_Lawson' })
script_version("1.5") -- Final version
script_version_number(14536)
--------------------------------------------------------------------
require "lib.moonloader"
local inicfg              = require 'inicfg'
local sampevents          = require "lib.samp.events"
local encoding            = require 'encoding'
encoding.default          = 'CP1251'
local imgui               = require 'imgui'
local lrequests, requests = pcall(require, 'requests')
local lcopas, copas       = pcall(require, 'copas')
local lhttp, http         = pcall(require, 'copas.http')
local lcrypto, crypto     = pcall(require, 'crypto_lua')
local u8 = encoding.UTF8
--------------------------------------------------------------------
local mainwindow = imgui.ImBool(false)
local weekonline = imgui.ImBool(false)
local punishments = imgui.ImBool(false)
local screenx, screeny = getScreenResolution()
local pInfo = inicfg.load({
  info = {
    day = "01.01.2019",
    dayOnline = 0,
    dayAFK = 0,
    dayPM = 0,
    weekPM = 0,
    thisWeek = 0,
    weekOnline = 0,
    admLvl = 0
  },
  weeks = {0,0,0,0,0,0,0},
  punish = {
  	ban = 0,
  	warn = 0,
  	kick = 0,
  	prison = 0,
  	mute = 0,
  	banip = 0,
  	rmute = 0,
  	jail = 0
  },
  others = {
    houseplata = 0
  }
}, "activity-checker")
local sInfo = {
  updateAFK = 0,
  authTime = 0,
  lvlAdmin = 0,
  isALogin = false
}
local DEBUG_MODE = false
local dayName = {u8"Понедельник", u8"Вторник", u8"Среда", u8"Четверг", u8"Пятница", u8"Суббота", u8"Воскресенье"}
local nick = ""
local playerid = -1
local pgetips = {}
--------------------------------------------------------------------
function main()
    apply_custom_style()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
    autoupdate("https://raw.githubusercontent.com/WhackerH/EvolveRP/master/update.json", '[Activity Helper]', "https://evolve-rp.su/viewtopic.php?f=21&t=151439")
    sampRegisterChatCommand('activitydebug', function()
      DEBUG_MODE = not DEBUG_MODE
      atext(("Debug mode %s"):format(DEBUG_MODE and "включен" or "отключен"))
    end)
    sampRegisterChatCommand('activity', function() mainwindow.v = not mainwindow.v end)
    --[[sampRegisterChatCommand('blacklist_start', function()
      local ips = {"93.85.137.241", "92.63.110.250", "194.1.237.67", "81.162.233.192", "194.28.172.176", "46.167.79.56", "82.202.167.203"}
      lua_thread.create(function()
        local count = #ips
        for i = count, 1, -1 do
          sampSendChat("/pgetip "..ips[i])
          wait(1150)
        end
      end)
    end)]]
    --------------------=========----------------------
    if not doesDirectoryExist("moonloader\\config") then
      createDirectory("moonloader\\config")
    end
    debug_log("Main function: dayOnline = "..pInfo.info.dayOnline)
    if DEBUG_MODE == true then atext(("Включен режим отладки. (Версия скрипта: %s. Номер сборки: %s)"):format(thisScript().version, thisScript().version_num)) end
    local day = os.date("%d.%m.%y")
    if pInfo.info.thisWeek == 0 then pInfo.info.thisWeek = os.date("%W") end
    if pInfo.info.day ~= day and tonumber(os.date("%H")) > 4 then
      local weeknum = dateToWeekNumber(pInfo.info.day)
      if weeknum == 0 then weeknum = 7 end
      pInfo.weeks[weeknum] = pInfo.info.dayOnline
      atext(string.format("Начался новый день. Итоги предыдущего дня (%s): %s", pInfo.info.day, secToTime(pInfo.info.dayOnline)))
      -----------------
      if tonumber(pInfo.info.thisWeek) ~= tonumber(os.date("%W")) then
        atext("Началась новая неделя. Итоги предыдущей недели: "..secToTime(pInfo.info.weekOnline))
        for key in pairs(pInfo) do
          for k in pairs(pInfo[key]) do
            pInfo[key][k] = 0
          end
        end
        debug_log("Новая неделя. Обнуляем все переменные")
        pInfo.info.thisWeek = os.date("%W")
      end
      debug_log("Новый день. Обнуляем день. weekOnline = "..pInfo.info.weekOnline)
      pInfo.info.day = day
      pInfo.info.dayPM = 0
      pInfo.info.dayOnline = 0
      pInfo.info.dayAFK = 0
    end
    if os.time(os.date("!*t")) > pInfo.others.houseplata - (3600 * 24 * 3) and pInfo.others.houseplata > 0 then -- Unix Timestamp
      atext("Внимание! На домашнем счёту осталось слишком мало денег. Успейте пополнить счёт")
    end
    if sampGetGamestate() == 3 then
      sampSendChat("/a")
      sendStat(false)
      debug_log("Gamestate == 3, check alogin")
    end
    debug_log("Main end: dayWeek = "..pInfo.info.weekOnline.." | dayOnline = "..pInfo.info.dayOnline)
    --------------------=========----------------------
    while not sampIsLocalPlayerSpawned() do wait(0) end
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    sInfo.authTime = os.date("%d.%m.%y %H:%M:%S")
    sInfo.updateAFK = os.time()
    playerid = myid
    nick = sampGetPlayerNickname(myid)
    calculateOnline()
    sendOnline()
    while true do wait(0)
      if sampGetGamestate() ~= 3 and sInfo.isALogin == true then
        sInfo.isALogin = false
        debug_log("Lost connection. isALogin = false")
      end
      imgui.Process = mainwindow.v
    end
end

function sendOnline()
  lua_thread.create(function()
    while true do wait(900000)
      sendStat(false)
    end
  end)
end

function calculateOnline()
  lua_thread.create(function()
    local updatecount = 0
    while true do wait(1000)
      if sInfo.isALogin == true then
        pInfo.info.dayOnline = pInfo.info.dayOnline + 1
        pInfo.info.weekOnline = pInfo.info.weekOnline + 1
        pInfo.info.dayAFK = pInfo.info.dayAFK + (os.time() - sInfo.updateAFK - 1)
        if updatecount >= 10 then saveconfig() updatecount = 0 end
        updatecount = updatecount + 1
      end
      sInfo.updateAFK = os.time()
    end  
  end)
end

function sendStat(bool)
  lua_thread.create(function()
    while not sInfo.isALogin do wait(0) end
    local zaprosTable = {
      {
        jsonrpc = '2.0',
        id = os.time(),
        method = 'set.Online',
        params = {
          nick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))),
          hash = string.lower(crypto.md5(os.time()..'activity-@-helper'..sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))))),
          level = pInfo.info.admLvl,
          dayOnline = pInfo.info.dayOnline,
          dayPM = pInfo.info.dayPM,
          dayAFK = pInfo.info.dayAFK,
          weekOnline = pInfo.info.weekOnline,
          weekPM = pInfo.info.weekPM
        }
      },
      {
        jsonrpc = '2.0',
        id = os.time(),
        method = 'set.Punish',
        params = {
          nick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))),
          hash = string.lower(crypto.md5(os.time()..'activity-@-helper'..sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))))),
          ban = pInfo.punish.ban,
          warn = pInfo.punish.warn,
          kick = pInfo.punish.kick,
          prison = pInfo.punish.prison,
          mute = pInfo.punish.mute,
          banip = pInfo.punish.banip,
          rmute = pInfo.punish.rmute,
          jail = pInfo.punish.jail
        }
      },
      {
        jsonrpc = '2.0',
        id = os.time(),
        method = 'set.Weeks',
        params = {
          nick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))),
          hash = string.lower(crypto.md5(os.time()..'activity-@-helper'..sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))))),
          [1] = pInfo.weeks[1],
          [2] = pInfo.weeks[2],
          [3] = pInfo.weeks[3],
          [4] = pInfo.weeks[4],
          [5] = pInfo.weeks[5],
          [6] = pInfo.weeks[6],
          [7] = pInfo.weeks[7]
        }
      }
    }
    if bool then zaprosTable[1].params.alogin = true end
    --url = ("https://redx-dev.web.app/api.html?dayAFK=%s&dayOnline=%s&dayPM=%s&level=%s&nick=%s&weekOnline=%s&weekPM=%s"):format(pInfo.info.dayAFK, pInfo.info.dayOnline, pInfo.info.dayPM, pInfo.info.admLvl, sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))), pInfo.info.weekOnline,pInfo.info.weekPM)
    httpRequest("https://redx-dev.web.app/api?data="..encodeJson(zaprosTable), nil, function(response) end)
    --downloadUrlToFile(url, os.getenv('TEMP') .. '\\activity')
    --print("https://redx-dev.web.app/api?data="..encodeJson(zaprosTable))
  end)
end

function httpRequest(request, body, handler) -- copas.http
  -- start polling task
  if not copas.running then
      copas.running = true
      lua_thread.create(function()
          wait(0)
          while not copas.finished() do
              local ok, err = copas.step(0)
              if ok == nil then error(err) end
              wait(0)
          end
          copas.running = false
      end)
  end
  -- do request
  if handler then
      return copas.addthread(function(r, b, h)
          copas.setErrorHandler(function(err) h(nil, err) end)
          h(http.request(r, b))
      end, request, body, handler)
  else
      local results
      local thread = copas.addthread(function(r, b)
          copas.setErrorHandler(function(err) results = {nil, err} end)
          results = table.pack(http.request(r, b))
      end, request, body)
      while coroutine.status(thread) ~= 'dead' do wait(0) end
      return table.unpack(results)
  end
end

function char_to_hex(str)
  return string.format("%%%02X", string.byte(str))
end

function url_encode(str)
  local str = string.gsub(str, "\\", "\\")
  local str = string.gsub(str, "([^%w])", char_to_hex)
  return str
end

function http_build_query(query)
  local buff=""
  for k, v in pairs(query) do
    buff = buff.. string.format("%s=%s&", k, url_encode(v))
  end
  local buff = string.reverse(string.gsub(string.reverse(buff), "&", "", 1))
  return buff
end

function autoupdate(json_url, prefix, url)
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
            updatelink = info.activity.url
            updateversion = info.activity.version
            f:close()
            os.remove(json)
            if updateversion > thisScript().version then
              lua_thread.create(function()
                local dlstatus = require('moonloader').download_status
                local color = -1
                local path = thisScript().path
                atext('Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion)
                wait(250)
                if thisScript().filename == "activity.lua" then
                  os.rename('moonloader/activity.lua', 'moonloader/activity.luac')
                  path = path.."c"
                end
                downloadUrlToFile(updatelink, path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('Загружено %d из %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('Загрузка обновления завершена.')
                      atext('Обновление завершено!')
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
                end, prefix
              )
            else
              update = false
              print('v'..thisScript().version..': Обновление не требуется.')
            end
          end
        else
          print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
  end)
end

function saveconfig()
  debug_log("Update information: weekOnline = "..pInfo.info.weekOnline.." | dayOnline = "..pInfo.info.dayOnline)
  if pInfo.info.dayOnline > 0 and pInfo.info.weekOnline > 0 then
    inicfg.save(pInfo, "activity-checker");
  end
end

function apply_custom_style()
  imgui.SwitchContext()
  local style = imgui.GetStyle()
  local colors = style.Colors
  local clr = imgui.Col
  local ImVec4 = imgui.ImVec4

  style.WindowRounding = 2.0
  style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
  style.ChildWindowRounding = 2.0
  style.FrameRounding = 2.0
  style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
  style.ScrollbarSize = 13.0
  style.ScrollbarRounding = 0
  style.GrabMinSize = 8.0
  style.GrabRounding = 1.0

  colors[clr.FrameBg]                = ImVec4(0.48, 0.16, 0.16, 0.54)
  colors[clr.FrameBgHovered]         = ImVec4(0.98, 0.26, 0.26, 0.40)
  colors[clr.FrameBgActive]          = ImVec4(0.98, 0.26, 0.26, 0.67)
  colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
  colors[clr.TitleBgActive]          = ImVec4(0.48, 0.16, 0.16, 1.00)
  colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
  colors[clr.CheckMark]              = ImVec4(0.98, 0.26, 0.26, 1.00)
  colors[clr.SliderGrab]             = ImVec4(0.88, 0.26, 0.24, 1.00)
  colors[clr.SliderGrabActive]       = ImVec4(0.98, 0.26, 0.26, 1.00)
  colors[clr.Button]                 = ImVec4(0.98, 0.26, 0.26, 0.40)
  colors[clr.ButtonHovered]          = ImVec4(0.98, 0.26, 0.26, 1.00)
  colors[clr.ButtonActive]           = ImVec4(0.98, 0.06, 0.06, 1.00)
  colors[clr.Header]                 = ImVec4(0.98, 0.26, 0.26, 0.31)
  colors[clr.HeaderHovered]          = ImVec4(0.98, 0.26, 0.26, 0.80)
  colors[clr.HeaderActive]           = ImVec4(0.98, 0.26, 0.26, 1.00)
  colors[clr.Separator]              = colors[clr.Border]
  colors[clr.SeparatorHovered]       = ImVec4(0.75, 0.10, 0.10, 0.78)
  colors[clr.SeparatorActive]        = ImVec4(0.75, 0.10, 0.10, 1.00)
  colors[clr.ResizeGrip]             = ImVec4(0.98, 0.26, 0.26, 0.25)
  colors[clr.ResizeGripHovered]      = ImVec4(0.98, 0.26, 0.26, 0.67)
  colors[clr.ResizeGripActive]       = ImVec4(0.98, 0.26, 0.26, 0.95)
  colors[clr.TextSelectedBg]         = ImVec4(0.98, 0.26, 0.26, 0.35)
  colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
  colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
  colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
  colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
  colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
  colors[clr.ComboBg]                = colors[clr.PopupBg]
  colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
  colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
  colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
  colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
  colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
  colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
  colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
  colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
  colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
  colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
  colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
  colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
  colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
  colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
  colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end
function imgui.OnDrawFrame()
  if mainwindow.v then
    imgui.ShowCursor = true
    local btn_size = imgui.ImVec2(-0.1, 0)
    local spacing = 165.0
    imgui.SetNextWindowSize(imgui.ImVec2(325, 300), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin('Activity Helper', mainwindow, imgui.WindowFlags.NoResize)
    ---------
    imgui.Text(u8"Ник:"); imgui.SameLine(spacing); imgui.Text(('%s [%s]'):format(nick, playerid))
    imgui.Text(u8"Авторизация в ALogin:"); imgui.SameLine(spacing); imgui.TextColored(getAloginColor(), ("%s"):format(u8(sInfo.isALogin and  "Авторизирован" or "Отсутствует")))
    if sInfo.isALogin == true and pInfo.info.admLvl > 0 then
      imgui.Text(u8"Уровень модератора:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(pInfo.info.admLvl))
    end
    imgui.Text(u8"Время авторизации:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(sInfo.authTime))
    imgui.Separator()
    imgui.Text(u8"Отыграно за сегодня:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(secToTime(pInfo.info.dayOnline)))
    imgui.Text(u8"AFK за сегодня:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(secToTime(pInfo.info.dayAFK)))
    imgui.Text(u8"Ответов за сегодня:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(pInfo.info.dayPM))
    imgui.Separator()
    imgui.Text(u8"Отыграно за неделю:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(secToTime(pInfo.info.weekOnline)))
    imgui.Text(u8"Ответов за неделю:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(pInfo.info.weekPM))
    imgui.Separator()
    if imgui.Button(u8 'Статистика по дням', btn_size) then weekonline.v = not weekonline.v end
    if imgui.Button(u8 'Статистика наказаний', btn_size) then punishments.v = not punishments.v end
    if imgui.Button(u8 'Перезагрузить скрипт', btn_size) then
      atext("Перезагружаемся...")
      showCursor(false)
      thisScript():reload()
    end
    if imgui.Button(u8 'Сообщить об ошибке', btn_size) then
      atext("Связь с разрабочиком:")
      atext("VK - https://vk.com/the_redx | Discord - redx#0763")
    end
    imgui.End()
    ----------------------
    if weekonline.v then
      imgui.SetNextWindowSize(imgui.ImVec2(325, 300), imgui.Cond.FirstUseEver)
      imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.Begin(u8 'Статистика по дням', weekonline, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
      local daynumber = dateToWeekNumber(os.date("%d.%m.%y"))
      if daynumber == 0 then daynumber = 7 end
      for key, value in ipairs(pInfo.weeks) do
        imgui.Text(dayName[key]); imgui.SameLine(spacing); imgui.TextColored(getDayColor(key, daynumber), ('%s'):format(daynumber == key and secToTime(pInfo.info.dayOnline) or secToTime(value)))
      end
      imgui.End()
    end
    if punishments.v then
      imgui.SetNextWindowSize(imgui.ImVec2(325, 300), imgui.Cond.FirstUseEver)
      imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.Begin(u8 'Статистика наказаний', punishments, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
      local i = 1
      for key, value in pairs(pInfo.punish) do
        imgui.Text(('%s'):format(key)); imgui.SameLine(spacing); imgui.Text(('%s'):format(value))
        i = i + 1
      end
      imgui.End()
    end
  end
end

------------------------ HOOKS ------------------------
function sampevents.onServerMessage(color, text)
  if text:match(nick) then
    if text:match("OffBan") or text:match("забанил (.+) Причина") or text:match("SBan") or text:match("IOffBan") then
      pInfo.punish.ban = pInfo.punish.ban + 1
    end
    if text:match("выдал warn") or text:match("получил предупреждение до") then
      pInfo.punish.warn = pInfo.punish.warn + 1
    end
    if text:match("кикнул .+ Причина") then
      pInfo.punish.kick = pInfo.punish.kick + 1
    end
    if text:match("поместил в ДеМорган") or text:match("посажен в prison") then
      pInfo.punish.prison = pInfo.punish.prison + 1
    end
    if text:match("заблокировал чат игрока") or text:match("OffMute") then
      pInfo.punish.mute = pInfo.punish.mute + 1
    end
    if text:match("забанил IP") then
      pInfo.punish.banip = pInfo.punish.banip + 1
    end
    if text:match("выдал затычку на репорт") then
      pInfo.punish.rmute = pInfo.punish.rmute + 1
    end
  end
  if text:match("Вы посадили .+ в тюрьму") then
  	pInfo.punish.jail = pInfo.punish.jail + 1
  end
  if text:match("Вы авторизировались как модератор .+ уровня") then
    pInfo.info.admLvl = tonumber(text:match("Вы авторизировались как модератор (.+) уровня"))
    sInfo.isALogin = true
    sInfo.sessionStart = os.time()
    sendStat(true)
    saveconfig()
  end
  if text:match("Ответ от "..nick) then
    pInfo.info.dayPM = pInfo.info.dayPM + 1
    pInfo.info.weekPM = pInfo.info.weekPM + 1
  end
  if text:match("Введите: %(/a%)dmin") and not sInfo.isAlogin then -- Проверка на админку при перезагрузке скрипита в игре
    sInfo.isALogin = true
    sInfo.sessionStart = os.time()
    return false
  end
  --[[if text:match("%[Заявка на смену ника%] .+%[.+%] просит сменить ник на%: .+") then
    local playernick, playerid, nextname = text:match("%[Заявка на смену ника%] (.+)%[(.+)%] просит сменить ник на%: (.+)")
    local string = string.format("[Заявка на смену ника] %s[%s] [lvl: %d] просит сменить ник на: %s", playernick, playerid, sampGetPlayerScore(tonumber(playerid)), nextname)
    return {string, color}
  end]]
  if text:match("Новый баланс на домашнем счету: $.+") then
    local balance = tonumber(text:match("Новый баланс на домашнем счету%: $(.+)"))
    atext("balance = "..balance)
  end
  if text:match("Nik %[.+%]  R%-IP %[.+%]  L%-IP %[.+%]  IP %[(.+)%]") and color == -10270806 then
    local nick, rip, ip = text:match("Nik %[(.+)%]  R%-IP %[(.+)%]  L%-IP %[.+%]  IP %[(.+)%]")
    if not checkIntable(pgetips, rip) then pgetips[#pgetips+1] = rip end
    if not checkIntable(pgetips, ip) then pgetips[#pgetips+1] = ip end
  end
  if text:match('^ Nik %[.+%]   R%-IP %[.+%]   L%-IP %[.+%]   IP %[.+%]$') then
    local nick, rip, ip = text:match('^ Nik %[(.+)%]   R%-IP %[(.+)%]   L%-IP %[.+%]   IP %[(.+)%]$')
    if not checkIntable(pgetips, rip) then pgetips[#pgetips+1] = rip end
    if not checkIntable(pgetips, ip) then pgetips[#pgetips+1] = ip end
  end
  --[[
    [20:31:41]  Положили на домашний счет: $100
    [20:31:41]  Новый баланс на домашнем счету: $33600
    [20:31:41]  Новый баланс на счету: $2185475
  if os.time(os.date("!*t")) > pInfo.others.houseplata - (3600 * 24 * 3) and pInfo.others.houseplata > 0 then -- Unix Timestamp
    atext("Внимание! На домашнем счёту осталось слишком мало денег. Успейте пополнить счёт")
  end]]
  if text:match("Время online за текущий день") then
    --sampAddChatMessage(("%06X"):format(bit.rshift(color, 8)), -1)
    sampAddChatMessage(string.format(" Время online за неделю - %s (Без учета АФК) | Ответов: %d", secToTime(pInfo.info.weekOnline), pInfo.info.weekPM), 0xBFC0C2)
    --sendStat()
  end
end

------------------------ SECONDARY FUNCTIONS ------------------------
function checkIntable(t, key)
  for k, v in pairs(t) do
      if v == key then return true end
  end
  return false
end

function dateToWeekNumber(date) -- Start on Sunday(0)
  local wsplit = string.split(date, ".")
  local day = tonumber(wsplit[1])
  local month = tonumber(wsplit[2])
  local year = tonumber(wsplit[3])
  local a = math.floor((14 - month) / 12)
  local y = year - a
  local m = month + 12 * a - 2
  return math.floor((day + y + math.floor(y / 4) - math.floor(y / 100) + math.floor(y / 400) + (31 * m) / 12) % 7)
end

function secToTime(sec)
  local hour, minute, second = sec / 3600, math.floor(sec / 60), sec % 60
  return string.format("%02d:%02d:%02d", math.floor(hour) ,  minute - (math.floor(hour) * 60), second)
end

function string.split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={} ; i=1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    t[i] = str
    i = i + 1
  end
  return t
end

function atext(text)
  sampAddChatMessage(" Activity Helper | {FFFFFF}"..text, 0x954F4F)
end

function debug_log(text)
  if DEBUG_MODE == false then return end
  if not doesFileExist('moonloader/config/activity_debug.txt') then 
      local file = io.open('moonloader/config/activity_debug.txt', 'w')
      file:close()
  end
	local file = io.open('moonloader/config/activity_debug.txt', 'a')
	file:write(('[%s || %s] %s\n'):format(os.date('%H:%M:%S'), os.date('%d.%m.%Y'), text))
	file:close()
	file = nil
end
function getAloginColor()
  if sInfo.isALogin then
    return imgui.ImVec4(0, 191/255, 128/255, 1)
  else
    return imgui.ImVec4(236/255, 55/255, 55/255, 1)
  end
end

function getDayColor(key, daynumber)
  if daynumber > 0 then
    if daynumber < key then return imgui.ImVec4(236/255, 55/255, 55/255, 1)
    elseif daynumber == key then return imgui.ImVec4(1, 1, 1, 1)
    else return imgui.ImVec4(0, 191/255, 128/255, 1) end
  else
    if daynumber == 0 and key == 7 then return imgui.ImVec4(1, 1, 1, 1)
    else return imgui.ImVec4(0, 191/255, 128/255, 1) end
  end
end
