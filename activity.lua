script_name("Activity") 
script_authors({ 'Edward_Franklin', 'Thomas_Lawson' })
script_version("1.45") -- Final version
script_version_number(14535)
--------------------------------------------------------------------
require "lib.moonloader"
local inicfg = require 'inicfg'
local sampevents = require "lib.samp.events"
local encoding = require 'encoding'
encoding.default = 'CP1251'
local imgui = require 'imgui'
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
    weekOnline = 0
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
local dayName = {u8"�����������", u8"�������", u8"�����", u8"�������", u8"�������", u8"�������", u8"�����������"}
local nick = ""
local playerid = -1
local pgetips = {}
--------------------------------------------------------------------
function main()
    apply_custom_style()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
    autoupdate("https://raw.githubusercontent.com/the-redx/EvolveRP/master/update.json", '[Activity Helper]', "https://evolve-rp.su/viewtopic.php?f=21&t=151439")
    sampRegisterChatCommand('activitydebug', function()
      DEBUG_MODE = not DEBUG_MODE
      atext(("Debug mode %s"):format(DEBUG_MODE and "�������" or "��������"))
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
    if DEBUG_MODE == true then atext(("������� ����� �������. (������ �������: %s. ����� ������: %s)"):format(thisScript().version, thisScript().version_num)) end
    local day = os.date("%d.%m.%y")
    if pInfo.info.thisWeek == 0 then pInfo.info.thisWeek = os.date("%W") end
    if pInfo.info.day ~= day and tonumber(os.date("%H")) > 4 then
      local weeknum = dateToWeekNumber(pInfo.info.day)
      if weeknum == 0 then weeknum = 7 end
      pInfo.weeks[weeknum] = pInfo.info.dayOnline
      atext(string.format("������� ����� ����. ����� ����������� ��� (%s): %s", pInfo.info.day, secToTime(pInfo.info.dayOnline)))
      -----------------
      if tonumber(pInfo.info.thisWeek) ~= tonumber(os.date("%W")) then
        atext("�������� ����� ������. ����� ���������� ������: "..secToTime(pInfo.info.weekOnline))
        for key in pairs(pInfo) do
          for k in pairs(pInfo[key]) do
            pInfo[key][k] = 0
          end
        end
        debug_log("����� ������. �������� ��� ����������")
        pInfo.info.thisWeek = os.date("%W")
      end
      debug_log("����� ����. �������� ����. weekOnline = "..pInfo.info.weekOnline)
      pInfo.info.day = day
      pInfo.info.dayPM = 0
      pInfo.info.dayOnline = 0
      pInfo.info.dayAFK = 0
    end
    if os.time(os.date("!*t")) > pInfo.others.houseplata - (3600 * 24 * 3) and pInfo.others.houseplata > 0 then -- Unix Timestamp
      atext("��������! �� �������� ����� �������� ������� ���� �����. ������� ��������� ����")
    end
    if sampGetGamestate() == 3 then
      sampSendChat("/a")
      debug_log("Gamestate == 3, check alogin")
    end
    debug_log("Main end: dayWeek = "..pInfo.info.weekOnline.." | dayOnline = "..pInfo.info.dayOnline)
    --------------------=========----------------------
    while not sampIsLocalPlayerSpawned() do wait(0) end
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    sInfo.authTime = os.date("%d.%m.%y %H:%M:%S")
    sInfo.updateAFK = os.time()
    playerid = myid
    nick = sampGetPlayerNickname(myid)
    calculateOnline()
    while true do wait(0)
      if sampGetGamestate() ~= 3 and sInfo.isALogin == true then
        sInfo.isALogin = false
        debug_log("Lost connection. isALogin = false")
      end
      imgui.Process = mainwindow.v
    end
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
                atext('���������� ����������. ������� ���������� c '..thisScript().version..' �� '..updateversion)
                wait(250)
                if thisScript().filename == "activity.lua" then
                  os.rename('moonloader/activity.lua', 'moonloader/activity.luac')
                  path = path.."c"
                end
                downloadUrlToFile(updatelink, path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('��������� %d �� %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('�������� ���������� ���������.')
                      atext('���������� ���������!')
                      atext('��� ������: ������ ��� ���������� ������ �� ���� ������ �� ���������.')
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                          atext('���������� ������ ��������. �������� ���������� ������..')
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              print('v'..thisScript().version..': ���������� �� ���������.')
            end
          end
        else
          print('v'..thisScript().version..': �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� '..url)
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
    local ImVec4 = imgui.ImVec4
    local spacing = 165.0
    imgui.SetNextWindowSize(imgui.ImVec2(325, 300), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin('Activity Helper', mainwindow, imgui.WindowFlags.NoResize)
    ---------
    imgui.Text(u8"���:"); imgui.SameLine(spacing); imgui.Text(('%s[%d]'):format(nick, playerid))
    imgui.Text(u8"����������� � ALogin:"); imgui.SameLine(spacing); imgui.TextColoredRGB(string.format('%s', sInfo.isALogin == true and "{00bf80}�������������" or "{ec3737}�����������"))
    if sInfo.isALogin == true and sInfo.lvlAdmin > 0 then
      imgui.Text(u8"������� ����������:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(sInfo.lvlAdmin))
    end
    imgui.Text(u8"����� �����������:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(sInfo.authTime))
    imgui.Separator()
    imgui.Text(u8"�������� �� �������:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(secToTime(pInfo.info.dayOnline)))
    imgui.Text(u8"AFK �� �������:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(secToTime(pInfo.info.dayAFK)))
    imgui.Text(u8"������� �� �������:"); imgui.SameLine(spacing); imgui.Text(('%d'):format(pInfo.info.dayPM))
    imgui.Separator()
    imgui.Text(u8"�������� �� ������:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(secToTime(pInfo.info.weekOnline)))
    imgui.Text(u8"������� �� ������:"); imgui.SameLine(spacing); imgui.Text(('%d'):format(pInfo.info.weekPM))
    imgui.Separator()
    if imgui.Button(u8 '���������� �� ����', btn_size) then weekonline.v = not weekonline.v end
    if imgui.Button(u8 '���������� ���������', btn_size) then punishments.v = not punishments.v end
    if imgui.Button(u8 '������������� ������', btn_size) then
      atext("���������������...")
      showCursor(false)
      thisScript():reload()
    end
    if imgui.Button(u8 '�������� �� ������', btn_size) then
      atext("����� � ������������:")
      atext("VK - https://vk.com/the_redx | Discord - redx#0763")
    end
    imgui.End()
    ----------------------
    if weekonline.v then
      imgui.SetNextWindowSize(imgui.ImVec2(325, 300), imgui.Cond.FirstUseEver)
      imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.Begin(u8 '���������� �� ����', weekonline, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
      local daynumber = dateToWeekNumber(os.date("%d.%m.%y"))
      if daynumber == 0 then daynumber = 7 end
      for key, value in ipairs(pInfo.weeks) do
        local colour = ""
        if daynumber > 0 then
          if daynumber < key then colour = "ec3737"
          elseif daynumber == key then colour = "FFFFFF"
          else colour = "00BF80" end
        else
          if daynumber == 0 and key == 7 then colour = "FFFFFF"
          else colour = "00BF80" end
        end
        imgui.Text(dayName[key]); imgui.SameLine(spacing); imgui.TextColoredRGB(('{%s}%s'):format(colour,daynumber == key and secToTime(pInfo.info.dayOnline) or secToTime(value)))
      end
      imgui.End()
    end
    if punishments.v then
      imgui.SetNextWindowSize(imgui.ImVec2(325, 300), imgui.Cond.FirstUseEver)
      imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.Begin(u8 '���������� ���������', punishments, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
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
    if text:match("OffBan") or text:match("������� (.+) �������") or text:match("SBan") or text:match("IOffBan") then
      pInfo.punish.ban = pInfo.punish.ban + 1
    end
    if text:match("����� warn") or text:match("������� �������������� ��") then
      pInfo.punish.warn = pInfo.punish.warn + 1
    end
    if text:match("������ .+ �������") then
      pInfo.punish.kick = pInfo.punish.kick + 1
    end
    if text:match("�������� � ��������") or text:match("������� � prison") then
      pInfo.punish.prison = pInfo.punish.prison + 1
    end
    if text:match("������������ ��� ������") or text:match("OffMute") then
      pInfo.punish.mute = pInfo.punish.mute + 1
    end
    if text:match("������� IP") then
      pInfo.punish.banip = pInfo.punish.banip + 1
    end
    if text:match("����� ������� �� ������") then
      pInfo.punish.rmute = pInfo.punish.rmute + 1
    end
  end
  if text:match("�� �������� .+ � ������") then
  	pInfo.punish.jail = pInfo.punish.jail + 1
  end
  if text:match("�� ���������������� ��� ��������� .+ ������") then
    sInfo.lvlAdmin = tonumber(text:match("�� ���������������� ��� ��������� (.+) ������"))
    sInfo.isALogin = true
    sInfo.sessionStart = os.time()
  end
  if text:match("����� �� "..nick) then
    pInfo.info.dayPM = pInfo.info.dayPM + 1
    pInfo.info.weekPM = pInfo.info.weekPM + 1
  end
  if text:match("�������: %(/a%)dmin") and not sInfo.isAlogin then -- �������� �� ������� ��� ������������ �������� � ����
    sInfo.isALogin = true
    sInfo.sessionStart = os.time()
    return false
  end
  --[[if text:match("%[������ �� ����� ����%] .+%[.+%] ������ ������� ��� ��%: .+") then
    local playernick, playerid, nextname = text:match("%[������ �� ����� ����%] (.+)%[(.+)%] ������ ������� ��� ��%: (.+)")
    local string = string.format("[������ �� ����� ����] %s[%s] [lvl: %d] ������ ������� ��� ��: %s", playernick, playerid, sampGetPlayerScore(tonumber(playerid)), nextname)
    return {string, color}
  end]]
  if text:match("����� ������ �� �������� �����: $.+") then
    local balance = tonumber(text:match("����� ������ �� �������� �����%: $(.+)"))
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
    [20:31:41]  �������� �� �������� ����: $100
    [20:31:41]  ����� ������ �� �������� �����: $33600
    [20:31:41]  ����� ������ �� �����: $2185475
  if os.time(os.date("!*t")) > pInfo.others.houseplata - (3600 * 24 * 3) and pInfo.others.houseplata > 0 then -- Unix Timestamp
    atext("��������! �� �������� ����� �������� ������� ���� �����. ������� ��������� ����")
  end]]
  if text:match("����� online �� ������� ����") then
    sampAddChatMessage(string.format(" ����� online �� ������ - %s (��� ����� ���) | �������: %d", secToTime(pInfo.info.weekOnline), pInfo.info.weekPM), 0xCCCCCC)
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