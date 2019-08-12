-- This file is a SFA-Helper project
-- Licensed under MIT License
-- Copyright (c) 2019 redx
-- https://github.com/the-redx/Evolve
-- Version 1.4-preview1

script_name("SFA-Helper")
script_authors({ 'Edward_Franklin' })
script_version("1.4011")
SCRIPT_ASSEMBLY = "1.4-preview1"
-- betaN, previewN
DEBUG_MODE = true
--------------------------------------------------------------------
require 'lib.moonloader'
local sf = require 'lib.sampfuncs'
------------------------
local lsampev, sampevents = pcall(require, 'lib.samp.events')
                            assert(lsampev, 'Library \'lib.samp.events\' not found')
local lencoding, encoding = pcall(require, 'encoding')
                            assert(lencoding, 'Library \'encoding\' not found')
local lkey, key           = pcall(require, 'vkeys')
                            assert(lkey, 'Library \'vkeys\' not found')
local lmem, memory        = pcall(require, 'memory')
                            assert(lmem, 'Library \'memory\' not found')
local lrkeys, rkeys       = pcall(require, 'rkeys')
                            assert(lrkeys, 'Library \'rkeys\' not found')
local lbitex, bitex       = pcall(require, 'bitex')
                            assert(lbitex, 'Library \'bitex\' not found')
local lrequests, requests = pcall(require, 'requests')
                            assert(lrequests, 'Library \'requests\' not found')
local limgui, imgui       = pcall(require, 'imgui')
                            assert(limgui, 'Library \'imgui\' not found')
local limadd, imadd       = pcall(require, 'imgui_addons')
                            assert(limadd, 'Library \'imgui_addons\' not found')
local lcopas, copas       = pcall(require, 'copas')
local lhttp, http         = pcall(require, 'copas.http')

--local json = require "cjson"
--local util = require "cjson.util"
--local raknet = require "lib.samp.raknet"
------------------
encoding.default = 'CP1251'
local u8 = encoding.UTF8
dlstatus = require('moonloader').download_status
imgui.ToggleButton = require('imgui_addons').ToggleButton
imgui.HotKey = require('imgui_addons').HotKey
--------------------------------------------------------------------
-- Логгирование
logger = {
  usecolor = true,
  outfile = 'moonloader/SFAHelper/debug.txt',
  level = DEBUG_MODE and "trace" or "info",
  modes = {
    { name = "trace", color = "6A5ACD", },
    { name = "debug", color = "ADD8E6", },
    { name = "info",  color = "90ee90", },
    { name = "warn",  color = "FF7F00", },
    { name = "error", color = "8b0000", },
    { name = "fatal", color = "FF00FF", },
  }
}

window = {
  ['main'] = imgui.ImBool(false),
  ['target'] = imgui.ImBool(false),
  ['shpora'] = imgui.ImBool(false),
  ['members'] = imgui.ImBool(false),
  ['addtable'] = imgui.ImBool(false),
  ['hud'] = imgui.ImBool(false),
  ['punishlog'] = imgui.ImBool(false),
  ['binder'] = imgui.ImBool(false),
  ['abp'] = imgui.ImBool(false)
}
screenx, screeny = getScreenResolution()
govtext = {
  {'Реклама призыва','[Army SF]: Уважаемые жители штата, в {time} объявлен призыв в San-Fierro Army!','[Army SF]: Требования: 3 года проживания в штате, не иметь проблем с законом не состоять в ЧС.','[Army SF]: Призывной пункт: Больница города San Fierro. Навигатор Л-2. Спасибо за внимание.'},
  {'Начало призыва','[Army SF]: Уважаемые жители штата Evolve, призыв в San-Fierro Army начался!','[Army SF]: Требования: 3 года проживания в штате, не иметь проблем с законом не состоять в ЧС.','[Army SF]: Призывной пункт - Больница города San Fierro. Навигатор Л-2. Спасибо за внимание.'},
  {'Продолжение призыва','[Army SF]: Уважаемые жители штата, в данный момент, в больнице SF проходит призыв в Army SF.','[Army SF]: Требования: 3 года проживания в штате, не иметь проблем с законом не состоять в ЧС.','[Army SF]: Призывной пункт - Больница города San Fierro. Навигатор Л-2. Спасибо за внимание.'},
  {'Конец призыва','[Army SF]: Уважаемые жители штата, призыв в армию города San-Fierro окончен!','[Army SF]: Следующий призыв San-Fierro Army назначен в {time}.','[Army SF]: Берегите себя и свою семью, с уважением - руководство армии.'},
  {'Пиар контрактов','[Army SF]: Уважаемые жители и гости штата Evolve. Прошу минуту внимания.','[Army SF]: На официальном портале армии "Авианосец" открыт прием заявлений на контрактную службу.','[Army SF]: Ждём Вас в рядах нашей армии. С уважением, руководство армии "Авианосец".'}
}
-- Главная таблица с настройками
pInfo = {
  info = {
    day = os.date("%d.%m.%y"),
    dayOnline = 0,
    dayAFK = 0,
    thisWeek = 0,
    dayPM = 0,
    weekPM = 0,
    weekOnline = 0,
    weekWorkOnline = 0,
    dayWorkOnline = 0
  },
  settings = {
    rank = 0,
    hud = true,
    hudX = screenx / 1.5,
    hudY = screeny - 250,
    chatconsole = false,
    target = true,
    autobp = false,
    autobpguns = {2,2,0,2,2,1,0},
    autodoklad = false,
    group = 0,
    clist = nil,
    sex = nil,
    membersdate = false,
    tag = nil,
    rpweapons = 0,
    autologin = false,
    password = ""
  },
  func = {},
  gov = govtext,
  weeks = {0,0,0,0,0,0,0},
  counter = {0,0,0,0,0,0,0,0,0,0,0,0}
}
-- Таблица для хранения клавиш, биндера
config_keys = {
  punaccept = {v = {key.VK_Y}},
  pundeny = {v = {key.VK_N}},
  targetplayer = {v = {key.VK_R}},
  weaponkey = {v = {key.VK_Z}},
  binder = {
    { text = {""}, v = {}, time = 0 },
  },
  cmd_binder = {
    { cmd = "pass", wait = 1100, text = { "Здравия желаю! Я {myrankname}, {myfullname}. Предъявите ваши документы." } },
    { cmd = "uinv", wait = 1100, text = { "/uninvite {param} {param2}" } },
    { cmd = "gr", wait = 1100, text = { "/giverank {param} {param2}" } },
    { cmd = "inv", wait = 1100, text = { "/invite {param}" } },
    { cmd = "cl", wait = 1100, text = { "/clist {param}" } },
    { cmd = "rpmask", wait = 1100, text = { "/me достал маску из кармана и надел на лицо", "/clist 32", "/do На лице маска, на форме нет опознавательных знаков. Личность не опознать" } }
  }
}

-- Для /checkbl, /checkrank
tempFiles = {
  blacklist = {},
  ranks = {},
  blacklistTime = 0,
  ranksTime = 0
}
-- Хлам для imgui
data = {
  imgui = {
    menu = 1,
    shpora = -1,
    hudpos = false,
    shporatext = {},
    punishtext = {},
    lecturetext = {},
    selectshpora = {},
    setgovtextarea = {},
    bind = 1,
    selectlecture = {string = ""},
    lecturetime = imgui.ImInt(3),
    mw = imgui.ImBool(false),
    player = imgui.ImInt(-1),
    govka = imgui.ImBuffer(256),
    setgov = imgui.ImBuffer(256),
    setgovint = imgui.ImInt(0),
    vigtype = imgui.ImBuffer(256),
    reason = imgui.ImBuffer(256),
    shporareason = imgui.ImBuffer(256),
    narkolvo = imgui.ImInt(0),
    grang = imgui.ImInt(0),
    invrang = imgui.ImInt(1),
    posradius = imgui.ImInt(15),
    rpweap = imgui.ImInt(-1),
    rpsex = imgui.ImInt(-1)
  },
  test = {
    googlesender = imgui.ImInt(0),
    nick = imgui.ImBuffer(256),
    param1 = imgui.ImBuffer(256),
    param2 = imgui.ImBuffer(256),
    reason = imgui.ImBuffer(256),
  },
  filename = "",
  departament = {},
  punishlog = {},
  players = {},
  members = {}
}
-- Таблица для хранения постов
postInfo = {
  { name = "КПП", coordX = -1530.65, coordY = 480.05, coordZ = 7.19, radius = 16.0 },
  { name = "Трап", coordX = -1334.59, coordY = 477.46, coordZ = 9.06, radius = 11.0 },
  { name = "Балкон", coordX = -1367.36, coordY = 517.50, coordZ = 11.20, radius = 10.0 },
  { name = "Склад 1", coordX = -1299.44, coordY = 498.90, coordZ = 11.20, radius = 12.0 },
  { name = "Склад 2", coordX = -1410.75, coordY = 502.03, coordZ = 11.20, radius = 14.0 }
}
post = {
  interval = 180,
  lastpost = 0,
  next = 0,
  active = false,
  string = "",
  select = imgui.ImInt(0)
}
-- Сессионные настройки
sInfo = {
  updateAFK = 0,
  fraction = "no",
  nick = "",
  playerid = -1,
  flood = 0,
  weapon = 0,
  isSupport = false,
  authTime = 0,
  isWorking = false,
  blPermissions = false
}
-- /members 2
membersInfo = {
  online = 0,
  work = 0,
  nowork = 0,
  mode = 0,
  imgui = imgui.ImBuffer(256),
  players = {}
}
-- Клавиши действия
punkeyActive = 0
punkey = {
  { nick = nil, time = nil, reason = nil },
  { nick = nil, time = nil, rank = nil },
  { text = nil, time = nil }
}
-- Настройки таргета
targetMenu = {
  playerid = nil,
  show = false,
  coordX = 135,
  time = nil,
  cursor = nil
}
-- Для биндера
tEditData = {}
sInputEdit = imgui.ImBuffer(256)
sCmdEdit = {}
bIsEnterEdit = imgui.ImBool(false)
tLastKeys = {}
------------------------------------------------
contractId = nil
playersAddCounter = 1
giveDMG = nil
playerMarker = nil
playerMarkerId = nil
playerRadar = nil
selectedContext = nil
giveDMGTime = nil
giveDMGSkin = nil
targetID = nil
contractRank = nil
autoBP = 1
autoBPCounter = 0
asyncQueue = false
searchlight = nil
spectate_list = {}
lectureStatus = 0
complete = false
updatesInfo = {
  version = DEBUG_MODE and SCRIPT_ASSEMBLY.." (тестовая)" or thisScript().version,
  type = "Релиз", -- Плановое обновление, Промежуточное обновление, Внеплановое обновление, Фикс
  date = "13.08.2019",
  list = {
    '{FF5233}-{CCCCCC} Теперь все настройки/бинды привязаны к нику. Шпоры и лекции остались общими;',
    --'{FF5233}-{CCCCCC} Чтобы переносить настройки между профилями создана специальная система экспорта настроек в {FFFFFF]Настройках;',
    '{FF5233}-{CCCCCC} Изменена команда {FFFFFF}/abp{CCCCCC}, теперь можно изменять список оружия, который нужно взять;',
    '{FF5233}-{CCCCCC} Добавлены отыгровки для женского пола. При входе в игру скрипт сам определит пол, но при необходимости его можно изменить в {FFFFFF}Настройках;',
    '{FF5233}-{CCCCCC} Изменена система обновлений;',
    '{FF5233}-{CCCCCC} В настройках добавлен автологин в игру;',
    '{FF5233}-{CCCCCC} Изменен клавишный биндер. Теперь не нужно создавать новый бинд для добавления нескольких строк',
    '  Все старые бинды автоматически приведены к новому виду, но назначать несколько биндов на одну клавишу по прежнему можно;',
    '{FF5233}-{CCCCCC} Добавлены новые тэги для биндера:',
    '  {FFFFFF}{date}{cccccc} - Текущая дата в формате DD.MM.YYYY;',
    '  {FFFFFF}{weaponid}{cccccc} - ID оружия в руках;',
    '  {FFFFFF}{weaponname}{cccccc} - Название оружия в руках;',
    '  {FFFFFF}{ammo}{cccccc} - Количество патронов в оружие;',
    --[['{FF5233}-{CCCCCC} Добавлены два новых видов тэга в биндерах:',
    '  1. {FFFFFF}$cmd{param}{CCCCCC} - Позволяет вызвать внутренную команду скрипта из биндера. Вместо {ffffff}cmd{cccccc} подставляется команда, {ffffff}param{cccccc} - агрументы функции.',
    '    Пример бинда: {ffffff}"$vig{{pFullNameByID} строгий нарушение устава}"{cccccc} при вызове выведет: {ffffff}"Nick_Name получает строгий выговор за нарушение устава"{cccccc}',
    '    Или: {ffffff}"$screen()"{cccccc} при вызове заскринит экран. При вызове данный тэг автоматически удаляется из бинда, т.е. при в чат тэг не напишет;',
    '  2. {ffffff}#cmd{param}{cccccc} - Позволяет форматировать аргумент указанной функцией.',
    '    Пример бинда: {ffffff}"#upper{pFullNameByID}"{ccccc} при вызове выведет ник из параметра в верхнем регистре;',
    '    Список всех новых тэгов можно найти в теме скрипта на форуме. Там же можно будет найти несколько уже готовых биндов, для лучшего понимания принципа работы;',]]
    "\nОстальное:",
    "{FF5233}-{CCCCCC} Исправлен баг с крашем скрипта при использовании таргет тэгов в биндере;",
    "{FF5233}-{CCCCCC} Изменена система логгирования для быстрого нахождения ошибок в работе скрипта;"
  }
}
adminsList = {}
zoness = {}
counterNames = {"Принято игроков", "Уволено игроков", "Повышего игроков", "Проведено лекций (/lecture)", "Проведено на посту (/post)", "Проведено на КПП (/post)", "Выдано нарядов (Меню)", "Запрошено локаций (/loc | Меню)", "Запрошено ЧСов", "Поставок на LVa", "Поставок на LSa", "Убито в порту"}
rankings = {[0] = "Нет", "Рядовой", "Ефрейтор", "Мл.Сержант", "Сержант", "Ст.Сержант", "Старшина", "Прапорщик", "Мл.Лейтенант", "Лейтенант", "Ст.Лейтенант", "Капитан", "Майор", "Подполковник", "Полковник", "Генерал"}
dayName = {"Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"}
--------------------------------------------------------------------

function main()
    apply_custom_style()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
    if not doesDirectoryExist("moonloader\\SFAHelper") then createDirectory("moonloader\\SFAHelper") end
    -- Иницилизируем логгер
    loggerInit()
    --------------------=========----------------------
    -- Подгружаем необходимые функции, останавливая основной поток до конца выполнения
    local mstime = os.clock()
    loadFiles()
    while complete ~= true do wait(0) end
    logger.debug(("Проверка библиотек | Время: %.3fs"):format(os.clock() - mstime))
    complete = false
    ------
    filesystem.path('moonloader/SFAHelper/accounts/'..sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(playerPed))))
    local isDefined = doesDirectoryExist('moonloader\\SFAHelper\\accounts')
    filesystem.init(filesystem.path())
    if not isDefined then
      -- Переносим файлы из версии < 1.4
      filesystem.movefiles(filesystem.path(), 'moonloader/SFAHelper', { "config.json", "keys.json", "posts.json", "punishlog.json" })
    end
    while complete ~= true do wait(0) end
    logger.debug(("Иницилизация настроек | Время: %.3fs"):format(os.clock() - mstime))
    complete = false
    ------
    autoupdate("https://raw.githubusercontent.com/the-redx/Evolve/master/update.json")
    while complete ~= true do wait(0) end
    logger.debug(("Проверка обновлений | Время: %.3fs"):format(os.clock() - mstime))
    complete = false
    ------
    loadPermissions("https://docs.google.com/spreadsheets/d/1qmpQvUCoWEBYfI3VqFT3_08708iLaSKPfa-A6QaHw_Y/export?format=tsv&id=1qmpQvUCoWEBYfI3VqFT3_08708iLaSKPfa-A6QaHw_Y&gid=1568566199") -- remove
    while complete ~= true do wait(0) end
    logger.debug(("Загрузка прав доступа | Время: %.3fs"):format(os.clock() - mstime))
    complete = false
    --------------------=========----------------------
    ----- Загружаем конфиги
    local configjson = filesystem.load('config.json')
    if configjson ~= nil then
      configjson = filesystem.performOld('config.json', configjson)
      logger.trace("Start additionArray to 'pInfo'")
      pInfo = additionArray(configjson, pInfo)
    end 
    filesystem.save(pInfo, 'config.json')
    ----------
    local keysjson = filesystem.load('keys.json')
    if keysjson ~= nil then
      keysjson = filesystem.performOld('keys.json', keysjson)
      logger.trace("Start additionArray to 'config_keys'")
      config_keys = additionArray(keysjson, config_keys) 
    end 
    filesystem.save(config_keys, 'keys.json')
    ----------
    local postsjson = filesystem.load('posts.json')
    if postsjson ~= nil then
      postsjson = filesystem.performOld('posts.json', postsjson)
      logger.trace("Start additionArray to 'pInfo'")
      postInfo = additionArray(postsjson, postInfo) 
    end
    filesystem.save(postInfo, 'posts.json')
    logger.debug(("Локальные данные загружены | Время: %.3fs"):format(os.clock() - mstime))
    --------------------=========----------------------
    sampRegisterChatCommand('stime', cmd_stime)
    sampRegisterChatCommand('sweather', cmd_sweather)
    sampRegisterChatCommand('loc', cmd_loc)
    sampRegisterChatCommand('ev', cmd_ev)
    sampRegisterChatCommand('sfaupdates', cmd_sfaupdates)
    sampRegisterChatCommand('shupd', cmd_sfaupdates)
    sampRegisterChatCommand('blag', cmd_blag)
    sampRegisterChatCommand('cn', cmd_cn)
    sampRegisterChatCommand('stats', cmd_stats)
    sampRegisterChatCommand('watch', cmd_watch)
    sampRegisterChatCommand('r', cmd_r)
    sampRegisterChatCommand('f', cmd_r)
    sampRegisterChatCommand('checkrank', cmd_checkrank)
    sampRegisterChatCommand('checkbl', cmd_checkbl)
    sampRegisterChatCommand('cchat', cmd_cchat)
    sampRegisterChatCommand('members', cmd_members)
    sampRegisterChatCommand('lecture', cmd_lecture)
    sampRegisterChatCommand('lec', cmd_lecture)
    sampRegisterChatCommand('reconnect', cmd_reconnect)
    sampRegisterChatCommand('createpost', cmd_createpost)
    sampRegisterChatCommand('addbl', cmd_addbl)
    sampRegisterChatCommand('vig', cmd_vig)
    sampRegisterChatCommand('adm', cmd_adm)
    sampRegisterChatCommand('match', cmd_match)
    sampRegisterChatCommand('contract', cmd_contract)
    sampRegisterChatCommand('rpweap', cmd_rpweap)
    sampRegisterChatCommand('punishlog', cmd_punishlog)
    sampRegisterChatCommand('sfahelper', function() 
      funcc('cmd_sfahelper', 1)
      window['main'].v = not window['main'].v
    end)
    sampRegisterChatCommand('sh', function()
      funcc('cmd_sh', 1)
      window['main'].v = not window['main'].v
    end)
    ----- Команды, для которых было лень создавать функции
    sampRegisterChatCommand('addtable', function()
      if sInfo.fraction ~= "SFA" or pInfo.settings.rank < 12 then
        atext('Команда доступна со звания Майор и выше')
        return
      end
      funcc('cmd_addtable', 1)
      data.test.googlesender.v = 0
      data.test.nick.v = ""
      data.test.param1.v = ""
      data.test.param2.v = ""
      data.test.reason.v = ""
      window['addtable'].v = not window['addtable'].v
    end)
    sampRegisterChatCommand('abp', function()
      window['abp'].v = not window['abp'].v
    end)
    sampRegisterChatCommand('shud', function()
      funcc('cmd_shud', 1)
      window['hud'].v = not window['hud'].v
      pInfo.settings.hud = not pInfo.settings.hud
      atext(("Худ %s"):format(pInfo.settings.hud and "включен" or "выключен"))      
    end)
    sampRegisterChatCommand('toggletarget', function()
      funcc('cmd_toggletarget', 1)
      pInfo.settings.target = not pInfo.settings.target
      atext(("Target Bar %s"):format(pInfo.settings.target and "включен" or "выключен"))
    end)
    -- Загрузка командного биндера
    registerFastCmd()
    logger.debug(("Команды загружены | Время: %.3fs"):format(os.clock() - mstime))
    --------------------=========----------------------
    punacceptbind = rkeys.registerHotKey(config_keys.punaccept.v, true, punaccept)
    -- Клавишный биндер
    for k, v in ipairs(config_keys.binder) do
      rkeys.registerHotKey(v.v, true, onHotKey)
      if v.time == nil then v.time = 0 end
    end
    logger.debug(("Бинды загружены | Время: %.3fs"):format(os.clock() - mstime))
    --------------------=========----------------------
    atext('SFA-Helper успешно загружен (/sh)')
    if DEBUG_MODE then
      atext('Вы используете тестовую версию - '..SCRIPT_ASSEMBLY)
    end
    local day = os.date("%d.%m.%y")
    if pInfo.info.thisWeek == 0 then pInfo.info.thisWeek = os.date("%W") end
    -- Начался новый день
    if pInfo.info.day ~= day and tonumber(os.date("%H")) > 4 and pInfo.info.dayOnline > 0 then
      local weeknum = dateToWeekNumber(pInfo.info.day)
      if weeknum == 0 then weeknum = 7 end
      pInfo.weeks[weeknum] = pInfo.info.dayOnline
      atext(string.format("Начался новый день. Итоги предыдущего дня (%s): %s", pInfo.info.day, secToTime(pInfo.info.dayOnline)))
      -----------------
      -- Началась новая идея
      if tonumber(pInfo.info.thisWeek) ~= tonumber(os.date("%W")) then
        atext("Началась новая неделя. Итоги предыдущей недели: "..secToTime(pInfo.info.weekOnline))
        logger.info("Началась новая неделя. Итоги предыдущей: "..secToTime(pInfo.info.weekOnline).."")
        -- Очищаем все счётчики, кроме настроек
        for key in pairs(pInfo) do
          if key ~= "settings" and key ~= "gov" and key ~= "func" then
            for k in pairs(pInfo[key]) do
              pInfo[key][k] = 0
            end
          end
        end
        pInfo.info.thisWeek = os.date("%W")
      end
      logger.info("Начался новый день. Итоги предыдущего: "..secToTime(pInfo.info.dayOnline).."")
      pInfo.info.day = day
      pInfo.info.dayPM = 0
      pInfo.info.dayAFK = 0
      pInfo.info.dayOnline = 0
      pInfo.info.dayWorkOnline = 0
    end
    logger.debug(("Онлайн успешно обновлен | Время: %.3fs"):format(os.clock() - mstime))
    while not sampIsLocalPlayerSpawned() do wait(0) end
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    sInfo.authTime = os.date("%d.%m.%y %H:%M:%S")
    sInfo.updateAFK = os.time()
    sInfo.playerid = myid
    sInfo.nick = sampGetPlayerNickname(myid)
    sInfo.weapon = getCurrentCharWeapon(PLAYER_PED)
    -- Сбор данных о фракции и ранге
    cmd_stats("checkout")
    secoundTimer()
    changeWeapons()
    loadAdmins()
    if pInfo.settings.hud == true then window['hud'].v = true end
    logger.trace(("Конец Main функции. | (weekOnline = %d | dayOnline = %d | Время: %.3fs)"):format(pInfo.info.weekOnline, pInfo.info.dayOnline, os.clock() - mstime))
    --------------------=========----------------------
    while true do wait(0)
      -- Если игрок вылетел, заканчиваем рабочий день
      if sampGetGamestate() ~= 3 and sInfo.isWorking == true then
        sInfo.isWorking = false
        logger.warn("Связь с сервером разорвана")
      end
      -- Определяем самостоятельные окна, и окна для которых нужка мышка
      if window['target'].v or window['main'].v or window['hud'].v or window['addtable'].v or window['shpora'].v or window['members'].v or window['punishlog'].v or window['binder'].v or window['abp'].v then imgui.Process = true
      else imgui.Process = false end
      if window['main'].v or window['addtable'].v or window['shpora'].v or window['members'].v or window['punishlog'].v or window['binder'].v or window['abp'].v then imgui.ShowCursor = true
      else imgui.ShowCursor = false end
      -----------
      -- Перемещение худа
      if data.imgui.hudpos then
        window['hud'].v = true
        sampToggleCursor(true)
        local curX, curY = getCursorPos()
        pInfo.settings.hudX = curX
        pInfo.settings.hudY = curY
      end
      -- Сохраняем новые координаты худа
      if isKeyJustPressed(key.VK_LBUTTON) and data.imgui.hudpos then
        funcc('changeposhud', 1)
        data.imgui.hudpos = false
        if not pInfo.settings.hud then window['hud'].v = false end
        sampToggleCursor(false)
        window['main'].v = true
        filesystem.save(pInfo, 'config.json')
      end
      ------------------
      -- Таргет меню
      local result, target = getCharPlayerIsTargeting(playerHandle)
      if result then result, player = sampGetPlayerIdByCharHandle(target) end
      if result and isKeyJustPressed(key.VK_MENU) and targetMenu.playerid ~= player then
        funcc('set_target', 1)
        targetPlayer(player)
        targetID = player
      end
      ------------------
      -- Обновляем некоторые переменные
      local cx, cy, cz = getCharCoordinates(PLAYER_PED)
      local zcode = getNameOfZone(cx, cy, cz)
      playerZone = getZones(zcode)
      sInfo.armour = getCharArmour(PLAYER_PED)
      sInfo.health = getCharHealth(PLAYER_PED)
      sInfo.interior = getActiveInterior()
      -- Определение города
      local citiesList = {'Los-Santos', 'San-Fierro', 'Las-Venturas'}
      local city = getCityPlayerIsIn(PLAYER_HANDLE)
      if city > 0 then playerCity = citiesList[city] else playerCity = "Нет сигнала" end
    end
end

------------------------ CMD ------------------------
-- Обработка рации для автотэга
-- Да, да, можно было через sendchat. Я хотел тут ещё кое что реализовать, поэтому так.
function cmd_r(args)
  if #args == 0 then
    sampAddChatMessage('Введите: /r [текст]', -1)
    return
  end
  if pInfo.settings.tag ~= nil then
    funcc('settings.tag', 1)
    sampSendChat('/r '..pInfo.settings.tag..' '..args)
  else
    sampSendChat('/r '..args)
  end
end

function cmd_match(args)
  -- https://blast.hk/wiki/lua:processlineofsight
  if #args == 0 then
    if playerMarker ~= nil then
      removeBlip(playerMarker)
      removeBlip(playerRadar)
      playerMarker = nil
      playerRadar = nil
      playerMarkerId = nil
      atext('Маркер успешно убран')
      return
    end
    atext('Введите: /match [id]')
    return
  end
  local id = tonumber(args)
  if id == nil then atext('Игрок оффлайн!') return end
  if not sampIsPlayerConnected(id) then atext('Игрок оффлайн!') return end
  local result, ped = sampGetCharHandleBySampPlayerId(id)
  if not result then atext('Игрок должен быть в зоне прорисовки') return end   
  if playerMarker ~= nil then
    removeBlip(playerMarker)
    removeBlip(playerRadar)
    playerMarkerId = nil
  end
  funcc('cmd_match', 1)
  playerMarkerId = id
  playerMarker = addBlipForChar(ped)
  --changeBlipColour(playerMarker, 0xFF0000FF)
  local px, py, pz = getCharCoordinates(ped)
  playerRadar = addSpriteBlipForContactPoint(px, py, pz, 14)
  atext(('Маркер установлен на игрока %s[%d]'):format(sampGetPlayerNickname(id), id))
  atext('Чтобы убрать маркер, введите команду /match ещё раз')
end

-- Добавление в ЧС
function cmd_addbl(args)
  if sInfo.blPermissions == false then atext('Для работы с данной командой необходима привязка!') return end
  if #args == 0 then
    atext('Введите: /addbl [playerid/nick] [степень (1-4)] [доказательства] [причина]')
    atext('Для вноса игрока в ЧС без доказательств, введите \'-\' в соответствующее поле')
    return
  end
  local argSt = string.split(args, " ", 4)
  if argSt[1] == nil then atext('Неверный ID игрока!') return end
  if argSt[3] == nil or argSt[4] == nil then atext("Неверные параметры!") return end
  local pid = tonumber(argSt[1])
  local type = tonumber(argSt[2])
  if type == nil or type < 1 or type > 4 then atext('Неверные параметры!') return end
  if sInfo.playerid == pid or sInfo.nick == argSt[1] then atext('Вы не можете внести себя в ЧС!') return end
  funcc('cmd_addbl', 1)
  if pid ~= nil then
    if sampIsPlayerConnected(pid) then
      argSt[1] = sampGetPlayerNickname(pid)
    end
  end
  if argSt[3] == "-" then argSt[3] = "Будут внесены позже" end
  atext(("Внос в ЧС: [Ник: %s] [Степень: %s] [Док-ва: %s] [Причина: %s]"):format(argSt[1], type, argSt[3], argSt[4]))
  sendGoogleMessage("blacklist", argSt[1], argSt[3], type, argSt[4], os.time())
end

-- Очистка чата
function cmd_cchat()
  funcc('cmd_cchat', 1)
  memory.fill(sampGetChatInfoPtr() + 306, 0x0, 25200)
  memory.write(sampGetChatInfoPtr() + 306, 25562, 4, 0x0)
  memory.write(sampGetChatInfoPtr() + 0x63DA, 1, 1)
end

-- Лекции:
-- lectureStatus == 0 | Лекция не запущена
-- lectureStatus > 0 | Лекция идёт
-- lectureStatus < 0 | Лекция приостановлена
function cmd_lecture(args)
  if args == "pause" or args == "1" then
    if lectureStatus == 0 then atext('Лекция не запущена') return end
    lectureStatus = lectureStatus * -1
    if lectureStatus > 0 then atext('Лекция возобновлена')
    else atext('Лекция приостановлена. Для возобновления введите: (/lec)ture pause') end
  elseif args == "stop" or args == "0" then
    if lectureStatus == 0 then atext('Лекция не запущена') return end
    lectureStatus = 0
    atext('Вывод лекции прекращен')
  elseif #args == 0 or args == "start" then
    if #data.imgui.lecturetext == 0 then atext('Файл лекции не загружен! Загрузите его в (/sh - Функции - Лекции)') return end
    if data.imgui.lecturetime.v == 0 then atext('Время не может быть равно 0!') return end
    if lectureStatus ~= 0 then atext('Лекция уже запущена/на паузе') return end
    atext('Вывод лекции начался. Для паузы/отмены введите: (/lec)ture pause или (/lec)ture stop')
    lectureStatus = 1
    funcc('cmd_lecture', 1)
    lua_thread.create(function()
      while true do wait(1)
        if lectureStatus == 0 then break end
        if lectureStatus >= 1 then
          if string.match(data.imgui.lecturetext[lectureStatus], "^/r .+") then
            -- /r обрабатываем через свою функцию для автотэга
            local bind = string.match(data.imgui.lecturetext[lectureStatus], "^/r (.+)")
            local textTag = tags(bind)
            if textTag:len() > 0 then
              cmd_r(textTag)
            end
          else
            local textTag = tags(data.imgui.lecturetext[lectureStatus])
            if textTag:len() > 0 then
              cmd_r(textTag)
            end
          end
          lectureStatus = lectureStatus + 1
        end
        if lectureStatus > #data.imgui.lecturetext then
          wait(50)
          lectureStatus = 0
          addcounter(4, 1)
          atext('Вывод лекции завершен')
          break 
        end
        wait(tonumber(data.imgui.lecturetime.v) * 1000)
      end
      return
    end)
  else atext('Неверный параметр! Доступные значения: (/lec)ture, (/lec)ture pause, (/lec)ture stop') end
end

-- Выдать выговор
function cmd_vig(arg)
  if #arg == 0 then
    atext('Введите: /vig [playerid] [тип выговора (строгий/обычный)] [причина]')
    return
  end
  local args = string.split(arg, " ", 3)
  if args[2] == nil or args[3] == nil then
    atext('Введите: /vig [playerid] [тип выговора (строгий/обычный)] [причина]')
    return
  end
  local pid = tonumber(args[1])
  if pid == nil then atext('Неверный ID игрока!') return end
  if sInfo.playerid == pid then atext('Вы не можете принять самого себя!') return end
  if not sampIsPlayerConnected(pid) then atext('Игрок оффлайн!') return end
  funcc('cmd_vig', 1)
  fileLog(pid, 'Выговор', args[2], _, args[3])
  cmd_r(('%s получает "%s" выговор за %s'):format(sampGetPlayerNickname(pid):gsub("_", " "), args[2], args[3]))
  timeScreen()
end

-- Контракт
function cmd_contract(arg)
  if pInfo.settings.rank < 14 then atext('Данная функция доступна Полковнику и выше') return end
  if #arg == 0 then
    atext('Введите: /contract [playerid] [ранг]')
    return
  end
  local args = string.split(arg, " ")
  local pid = tonumber(args[1])
  local rank = tonumber(args[2])
  if pid == nil then atext('Неверный ID игрока!') return end
  if rank == nil then atext('Неверные параметры!') return end
  if sInfo.playerid == pid then atext('Вы не можете принять самого себя!') return end
  if not sampIsPlayerConnected(pid) then atext('Игрок оффлайн!') return end
  funcc('cmd_contract', 1)
  sampSendChat('/invite '..pid)
  -- Выдача ранга происходит после строчки об инвайте в чате
  contractId = pid
  contractRank = rank
end

-- Благодарности
function cmd_blag(arg)
  if #arg == 0 then
    atext('Введите: /blag [ид] [фракция] [тип]')
    atext('Тип: 1 - помощь на призыве, 2 - за участие на тренировке, 3 - за транспортировку')
    return
  end
  local args = string.split(arg, " ", 3)
  args[3] = tonumber(args[3])
  if args[1] == nil or args[2] == nil or args[3] == nil then
    atext('Введите: /blag [ид] [фракция] [тип]')
    atext('Тип: 1 - помощь на призыве, 2 - за участие на тренировке, 3 - за транспортировку')
    return   
  end
  local pid = tonumber(args[1])
  if pid == nil then atext('Игрок не найден!') return end
  if not sampIsPlayerConnected(pid) then atext('Игрок оффлайн!') return end
  local blags = {"помощь на призыве", "участие в тренировке", "транспортировку"}
  if args[3] < 1 or args[3] > #blags then atext('Неверный тип!') return end
  funcc('cmd_blag', 1)
  sampSendChat(("/d %s, выражаю благодарность %s за %s"):format(args[2], string.gsub(sampGetPlayerNickname(pid), "_", " "), blags[args[3]]))
end

-- Считываем фракцию и ранг
function cmd_stats(args)
  lua_thread.create(function()
    sampSendChat('/stats')
    while not sampIsDialogActive() do wait(0) end
    proverkk = sampGetDialogText()
    local frakc = proverkk:match('.+Организация%:%s+(.+)%s+Ранг')
    local rang = proverkk:match('.+Ранг%:%s+(.+)%s+Работа')
    local sex = proverkk:match('.+Пол%:%s+(.+)')
    sInfo.fraction = tostring(frakc)
    if pInfo.settings.sex == nil then
      if sex == "Мужчина" then pInfo.settings.sex = 1
      elseif sex == "Женщина" then pInfo.settings.sex = 0
      else pInfo.settings.sex = 1 end
    end
    if sInfo.fraction == "nil" then sInfo.fraction = "no" end
    logger.info(('Фракция определена: %s'):format(sInfo.fraction))
    logger.info(('Пол определен: %s'):format(pInfo.settings.sex == 1 and "Мужской" or "Женский"))
    for i = 1, #rankings do
      if rankings[i] == rang then
        pInfo.settings.rank = i
        logger.info(('Ранг определен: %s[%d]'):format(rang, pInfo.settings.rank))
        break
      end
      if rang == "Нет" then
        logger.warn('Ранга нет в статистике')
        break
      end
      if i == #rankings then
        logger.warn(('Ранг не определен. Берем старый ранг: %s[%d]'):format(rankings[pInfo.settings.rank], pInfo.settings.rank))
      end
    end
    if args == "checkout" then sampCloseCurrentDialogWithButton(1) end
    return
  end)
end

-- Создаем пост для автодокладов
function cmd_createpost(args)
  if #args == 0 then
    atext('Введите: /createpost [название поста]')
    return
  end
  local cx, cy, cz = getCharCoordinates(PLAYER_PED)
  for i = 1, #postInfo do
    local pi = postInfo[i]
    if args == pi.name then
      atext('Данное имя поста уже занято!')
      return
    end
    if cx >= pi.coordX - (pi.radius+15) and cx <= pi.coordX + (pi.radius+15) and cy >= pi.coordY - (pi.radius+15) and cy <= pi.coordY + (pi.radius+15) and cz >= pi.coordZ - (pi.radius+15) and cz <= pi.coordZ + (pi.radius+15) then
      atext(("Пост не может быть создан, т.к. он граничит с постом '%s'"):format(pi.name))
      return
    end
  end
  funcc('cmd_createpost', 1)
  logger.info("Создан новый пост '"..args.."'")
  postInfo[#postInfo+1] = { name = args, coordX = cx, coordY = cy, coordZ = cz, radius = 15.0 }
  post.string = "" -- Обновляем меню
  filesystem.save(postInfo, 'posts.json')
  atext(("Пост '%s' успешно создан. Для настройки перейдите в меню (/sh - Функции - Автодоклад с постов)"):format(args))
end

-- Меню слежки
function cmd_watch(args)
  if #args == 0 then
    atext('Введите: /watch [add/remove] [id] или /watch list')
    return
  end
  args = string.split(args, " ")
  if args[1] == "list" then
    local str = "{FFFFFF}Ник\t{FFFFFF}Текущий клист\n"
    for i = 1, #spectate_list do
      if spectate_list[i] ~= nil then
        str = str..string.format("%s[%d]\t%s\n", spectate_list[i].nick, spectate_list[i].id, getcolorname(spectate_list[i].clist))
      end  
    end
    sampShowDialog(6121145, "{954F4F}SFA-Helper | {FFFFFF}Список слежки", str, "Закрыть", "", DIALOG_STYLE_TABLIST_HEADERS)
  elseif args[1] == "add" then
    if args[2] == nil then atext('Неверный ID игрока!') return end
    pid = tonumber(args[2])
    if pid == nil or sInfo.playerid == args[2] then atext('Неверный ID игрока!') return end
    if not sampIsPlayerConnected(pid) then atext('Игрок оффлайн') return end
    funcc('cmd_watch_add', 1)
    local color = string.format("%06X", ARGBtoRGB(sampGetPlayerColor(pid)))
    spectate_list[#spectate_list+1] = { id = pid, nick = sampGetPlayerNickname(pid), clist = color }
    atext(string.format('Игрок %s[%d] успешно добавлен в панель слежки. Текущий цвет: %s', sampGetPlayerNickname(pid), pid, getcolorname(color)))
  elseif args[1] == "remove" then
    if args[2] == nil then atext('Неверный ID игрока!') return end
    pid = tonumber(args[2])
    if pid == nil or sInfo.playerid == args[2] then atext('Неверный ID игрока!') return end
    if not sampIsPlayerConnected(pid) then atext('Игрок оффлайн') return end
    for i = 1, #spectate_list do
      if spectate_list[i] ~= nil and pid == spectate_list[i].id then
        spectate_list[i] = nil
        atext('Игрок '..sampGetPlayerNickname(pid)..'['..pid..'] успешно убран из панели слежки!')
        return
      end
    end
    atext('Игрок не найден в панеле слежки!')
  else atext('Неизвестный параметр') end
end

-- Проверка повышки из гугл таблиц
function cmd_checkrank(arg)
  if sInfo.fraction ~= "SFA" then atext('Команда доступна только игрокам из SFA') end
  if sInfo.isWorking == false or pInfo.settings.rank < 12 then atext('Команда доступна с 12 ранга') return end
  if #arg == 0 then
    atext('Введите: /checkrank [id / nick]')
    return
  end
  local id = tonumber(arg)
  if id ~= nil then
    if sampIsPlayerConnected(id) then arg = sampGetPlayerNickname(id)
    else atext('Игрок оффлайн!') return end
  end
  if tempFiles.ranksTime >= os.time() - 180 then
    -- Ищем из конца для получения последнего повышения
    for i = #tempFiles.ranks, 1, -1 do
      local line = tempFiles.ranks[i]
      if line.nick == arg or line.nick == string.gsub(arg, "_", " ") then
        funcc('cmd_checkrank', 1)
        atext('Последнее повышение игрока '..line.nick..':')
        if line.rank1 ~= nil and line.rank2 ~= nil and line.date ~= nil then
          atext(("С %s на %s ранг | Дата: %s"):format(line.rank1, line.rank2, line.date))
        end
        if line.executor ~= nil and line.reason ~= nil then 
          atext(("Повысил: %s | Причина: %s"):format(line.executor, u8:decode(line.reason)))
        end
        return
      end  
    end
    atext('Игрок не найден в логе повышений!')
    return
  end
  -- Файл не загружен, или прошло более 3-х минут с момента прошлого обновления
  local updatelink = 'https://docs.google.com/spreadsheets/d/1F8uOhtVSMJIvsiJcyOINZOEAh0cc3PK1_m3oPrLlatw/export?format=tsv&id=1F8uOhtVSMJIvsiJcyOINZOEAh0cc3PK1_m3oPrLlatw&gid=0'
  local downloadpath = getWorkingDirectory() .. '\\SFAHelper\\checkrank.tsv'
  sampAddChatMessage('Загрузка данных...', 0xFFFF00)
  logger.trace("Отправляем асинхронку. Очередь: "..tostring(asyncQueue))
  asyncQueue = true
  httpRequest(updatelink, nil, function(response, code, headers, status)
    if response then
      -- Регулярка для парсинга строчек, т.к. в запросе все приходит в 1 строчке
      for line in response:gmatch('[^\r\n]+') do
        -- Ichigo_Kurasaki	1	2	21.03.2019	Jonathan Belin	Повышение.
        -- .tsv файлы представляют данные, которые отделяются табом
        local arr = string.split(line, "\t")
        tempFiles.ranks[#tempFiles.ranks + 1] = { nick = arr[1], rank1 = arr[2], rank2 = arr[3], date = arr[4], executor = arr[5], reason = arr[6] }
      end
      logger.trace("Обработка ответа успешно завершена")
      asyncQueue = false
      -- Обновляем время, возвращаемся в функцию
      tempFiles.ranksTime = os.time()
      cmd_checkrank(arg)
    else
      logger.trace("Ответ был получен с ошибкой")
      asyncQueue = false
    end
  end)
end

-- Проверка ЧС из гугл таблиц
function cmd_checkbl(arg)
  if sInfo.fraction ~= "SFA" then atext('Команда доступна только игрокам из SFA') end
  if sInfo.isWorking == false then atext('Необходимо начать рабочий день!') return end
  if #arg == 0 then
    atext('Введите: /checkbl [id / nick]')
    return
  end
  local id = tonumber(arg)
  if id ~= nil then
    if sampIsPlayerConnected(id) then arg = sampGetPlayerNickname(id)
    else atext('Игрок оффлайн!') return end
  end
  if tempFiles.blacklistTime >= os.time() - 180 then
    -- Ищем из конца для получения последней записи
    for i = #tempFiles.blacklist, 1, -1 do
      local line = tempFiles.blacklist[i]
      if line.nick == arg or line.nick == string.gsub(arg, "_", " ") then
        funcc('cmd_checkbl', 1)
        local blacklistStepen = { "1 степень", "2 степень", "3 степень", "4 степень", "Не уволен", "Оплатил" }
        atext('Игрок '..line.nick..' найден в Черном Списке!')
        if line.executor ~= nil and line.date ~= nil then 
          atext(("Внёс: %s | Дата: %s"):format(line.executor, line.date))
        end
        if line.reason ~= nil and line.stepen ~= nil then
          atext(("Степень: %s | Причина: %s"):format(blacklistStepen[line.stepen], u8:decode(line.reason)))
        end
        addcounter(9, 1)
        return
      end  
    end
    atext('Игрок не найден в Черном Списке!')
    return
  end
  -- Файл не загружен, или прошло более 3-х минут с момента прошлого обновления
  local updatelink = 'https://docs.google.com/spreadsheets/d/1yBkOkDHGgaYqZDW9hY-qG5C5Zr8S3VmEEoFFByazGZ0/export?format=tsv&id=1yBkOkDHGgaYqZDW9hY-qG5C5Zr8S3VmEEoFFByazGZ0&gid=0'
  local downloadpath = getWorkingDirectory() .. '\\SFAHelper\\blacklist.tsv'
  sampAddChatMessage('Загрузка данных...', 0xFFFF00)
  logger.trace("Отправляем асинхронку. Очередь: "..tostring(asyncQueue))
  asyncQueue = true
  httpRequest(updatelink, nil, function(response, code, headers, status)
    if response then
      -- Регулярка для парсинга строчек, т.к. в запросе все приходит в 1 строчке
      for line in response:gmatch('[^\r\n]+') do
        -- Jayden Ray	Vladimit_Rodionov	Потеря формы , ТК	22.07.2017	http://imgur.com/a/q2w6J  3
        -- .tsv файлы представляют данные, которые отделяются табом
        local arr = string.split(line, "\t")
        local step = arr[6]
        if arr[6] ~= nil and arr[7] ~= nil then step = arr[7] end
        tempFiles.blacklist[#tempFiles.blacklist + 1] = { nick = arr[2], stepen = tonumber(step), date = arr[4], executor = arr[1], reason = arr[3] }
      end
      logger.trace("Обработка ответа успешно завершена")
      asyncQueue = false
      -- Обновляем время, возвращаемся в функцию
      tempFiles.blacklistTime = os.time()
      cmd_checkbl(arg)
    else
      logger.trace("Ответ был получен с ошибкой")
      asyncQueue = false
    end
  end)
end

-- Запрос эвакуации
function cmd_ev(arg)
  if sInfo.isWorking == false then atext('Необходимо начать рабочий день!') return end
  if #arg == 0 then
    atext("Введите: /ev [0-1] [кол-во мест]")
    return
  end
  local args = string.split(arg, " ", 2)
  args[1] = tonumber(args[1])
  args[2] = tonumber(args[2])
  if args[2] == nil or args[2] < 1 then
    atext('Неверное количество мест!')
    return
  end
  local selectPos = 0
  local kvx = ""
  local X, Y
  local KV = {"А","Б","В","Г","Д","Ж","З","И","К","Л","М","Н","О","П","Р","С","Т","У","Ф","Х","Ц","Ч","Ш","Я"}
  if args[1] == 0 then
    X, Y, _ = getCharCoordinates(playerPed)
  elseif args[1] == 1 then
    result, X, Y, _ = getTargetBlipCoordinatesFixed()
    if not result then atext('Установите метку на карте') return end
  else
    atext('Доступные значения: 0 - Текущее местоположение, 1 - По метке.')
    return
  end
  funcc('cmd_ev', 1)
  X = math.ceil((X + 3000) / 250)
  Y = math.ceil((Y * - 1 + 3000) / 250)
  Y = KV[Y]
  kvx = (Y.."-"..X)   
  cmd_r('Запрашиваю эвакуацию! Сектор: '..kvx..", Количество мест: "..args[2])
end

function cmd_sweather(arg)
  if #arg == 0 then
    atext('Введите: /sweather [погода 0-45]')
    return
  end    
  local weather = tonumber(arg)
  funcc('cmd_sweather', 1)
  if weather ~= nil and weather >= 0 and weather <= 45 then
    forceWeatherNow(weather)
    atext('Погода изменена на: '..weather)
  else
    atext('Значение погоды должно быть в диапазоне от 0 до 45.')
  end
end

function cmd_stime(arg)
  if #arg == 0 then
    atext('Введите: /stime [время 0-23 | -1 стандартный]')
    return
  end
  logger.trace(arg)
  local hour = tonumber(arg)
  logger.trace(hour)
  if hour ~= nil and hour >= 0 and hour <= 23 then
    time = hour
    patch_samp_time_set(true)
    if time then
      setTimeOfDay(time, 0)
      atext('Время изменено на: '..time)
    end
    funcc('cmd_stime', 1)
  else
    atext('Значение времени должно быть в диапазоне от 0 до 23.')
    patch_samp_time_set(false)
    time = nil
  end
end

function cmd_punishlog(nick)
  if #nick == 0 then
    atext('Введите: /punishlog [id / nick]')
    return
  end
  local pid = tonumber(nick)
  if pid ~= nil and (sampIsPlayerConnected(pid) or sInfo.playerid == pid) then nick = sampGetPlayerNickname(pid) end
  nick = rusUpper(nick)
  if doesFileExist(filesystem.path()..'/punishlog.json') then
    lua_thread.create(function()
      local punishjson = filesystem.load('punishlog.json')
      if punishjson ~= nil then
        funcc('cmd_punishlog', 1)
        data.punishlog = {}
        local count = 0
        for i = 1, #punishjson do
          local text = rusUpper(punishjson[i].text)
          if text:match(nick) or text:match(nick:gsub("_", " ")) or text:match(nick:gsub(".+_", "")) then
            table.insert(data.punishlog, punishjson[i])
            count = count + 1
          end
        end
        if count > 0 then
          window['punishlog'].v = true
          atext('Всего: '..count..' вхождений')
          return
        else
          atext('Ничего не найдено!')
        end
      else atext('Произошла ошибка') end
    end)     
  else
    atext('Ничего не найдено!')
    local fa = io.open(filesystem.path().."/punishlog.json", "w")
    fa:write("[]")
    fa:close()
  end
end

function cmd_rpweap(arg)
  if #arg == 0 then
    atext('Введите: /rpweap [тип]')
    atext('Типы: 0 - Выключить, 1 - Только по нажатию клавиши, 2 - Только при смене оружия, 3 - При смене и по клавише')
    return
  end
  arg = tonumber(arg)
  if arg == nil then atext('Неверное значение!') return end
  if arg > 3 or arg < 0 then atext('Значение может быть от 0 до 3') return end
  funcc('cmd_rpweap', 1)
  pInfo.settings.rpweapons = arg
  if arg == 0 then atext('РП отыгровки при смене оружия выключены')
  elseif arg == 1 then atext('РП отыгровки активны только при нажатии на клавишу')
  elseif arg == 2 then atext('РП отыгровки активны только при смене оружия')
  elseif arg == 3 then atext('РП отыгровки активны при смене оружия или нажатии на клавишу') end
end

-- Запрос местоположения
function cmd_loc(args)
  if sInfo.isWorking == false then atext('Необходимо начать рабочий день!') return end
  args = string.split(args, " ")
  if #args ~= 2 then
    atext('Введите: /loc [id/nick] [секунды]')
    return
  end
  local name = args[1]
  local rnick = tonumber(name)
  if rnick ~= nil then
    if rnick == sInfo.playerid or name == sInfo.nick then atext('Белин: Нельзя запрашивать у самого себя, дурачёк') return end
    if sampIsPlayerConnected(rnick) then name = sampGetPlayerNickname(rnick)
    else atext('Игрок оффлайн') return end
  end
  funcc('cmd_loc', 1)
  fileLog(name, 'Местоположение', _, args[2], _)
  cmd_r(string.gsub(name, "_", " ")..', ваше местоположение? На ответ '..args[2]..' секунд.')
  addcounter(8, 1)
end

-- Копируем ники
function cmd_cn(args)
  if #args == 0 then atext("Введите: /cn [id] [0 - RP nick, 1 - NonRP nick]") return end
  args = string.split(args, " ")
  if #args == 1 then
    cmd_cn(args[1].." 0")
  elseif #args == 2 then
    local getID = tonumber(args[1])
    if getID == nil then atext("Неверный ID игрока!") return end
    if not sampIsPlayerConnected(getID) then atext("Игрок оффлайн!") return end 
    getID = sampGetPlayerNickname(getID)
    if tonumber(args[2]) == 1 then
      atext("Ник \""..getID.."\" успешно скопирован в буфер обмена. Для вставки используйте CTRL + V")
    else
      getID = string.gsub(getID, "_", " ")
      atext("РП Ник \""..getID.."\" успешно скопирован в буфер обмена. Для вставки используйте CTRL + V")
    end
    funcc('cmd_cn', 1)
    setClipboardText(getID)
  else
    atext("Введите: /cn [id] [0 - RP nick, 1 - NonRP nick]")
    return
  end 
end

-- Раньше работала, после удаления хоста не работает
function cmd_adm()
  sampAddChatMessage(' Админы Online:', 0xFFFF00)
  funcc('cmd_adm', 1)
  for i = 0, 1000 do
    if sampIsPlayerConnected(i) then
      for j = 1, #adminsList do
        if adminsList[j].nick == sampGetPlayerNickname(i) then
          sampAddChatMessage((" %s | ID: %d | Level: %d"):format(adminsList[j].nick, i, adminsList[j].level), 0xF5DEB3)
          break
        end
      end
    end
  end
end

-- Реконнект
function cmd_reconnect(args)
  if #args == 0 then
    atext('Введите: /reconnect [секунды]')
    return
  end
  args = tonumber(args)
  if args == nil or args < 1 then
    atext('Неверный параметр!')
    return
  end
  funcc('cmd_reconnect', 1)
	lua_thread.create(function()
		sampSetGamestate(5)
		sampDisconnectWithReason()
		wait(args * 1000) 
    sampSetGamestate(1)
    return
	end)
end

-- Мемберс
function cmd_members(args)
  if args == "1" then
    membersInfo.mode = 1
    funcc('cmd_members_1', 1)
  elseif args == "2" then
    membersInfo.players = {}
    membersInfo.work = 0
    membersInfo.imgui = imgui.ImBuffer(256)
    membersInfo.nowork = 0
    membersInfo.mode = 2
    window['members'].v = true
    funcc('cmd_members_2', 1)
  else
    funcc('cmd_members_none', 1)
    membersInfo.mode = 0
  end
  sampSendChat('/members')
end

function cmd_sfaupdates()
  local str = "{FFFFFF}Тип: {FF5233}"..updatesInfo.type.."\n{FFFFFF}Версия скрипта: {FF5233}"..updatesInfo.version.."\n{FFFFFF}Дата выхода: {FF5233}"..updatesInfo.date.."{FFFFFF}\n\n"
  for i = 1, #updatesInfo.list do
    str = str.."{cccccc}"..updatesInfo.list[i].."\n"
  end
  funcc('cmd_sfaupdates', 1)
  sampShowDialog(61315125, "{954F4F}SFA-Helper | {FFFFFF}Список обновлений", str, "Закрыть", "", DIALOG_STYLE_MSGBOX)
end


------------------------ FUNCTIONS ------------------------
function changeWeapons()
  lua_thread.create(function()
    while true do wait(0)
      local weapon = getCurrentCharWeapon(PLAYER_PED)
      if pInfo.settings.autobp == true and autoBP > 1 and sInfo.flood < os.clock() - 1 and (pInfo.settings.rpweapons == 2 or pInfo.settings.rpweapons == 3) then
        sInfo.flood = os.clock() + 3
      end
      if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
        if isKeyJustPressed(config_keys.weaponkey.v[1]) and (pInfo.settings.rpweapons == 1 or pInfo.settings.rpweapons == 3)
        or (pInfo.settings.rpweapons == 2 or pInfo.settings.rpweapons == 3) and weapon ~= sInfo.weapon then
          if sInfo.flood <= os.clock() - 1.1 then
            local setsex = pInfo.settings.sex == 1 and "" or "а"
            local weaponrp = {
              [0] = "спрятал"..setsex.." оружие",
              [1] = "достал"..setsex.." с кармана кастет и надел"..setsex.." его на правую руку",
              [3] = "быстрым движением руки снял"..setsex.." с поясного держателя дубинку",
              [4] = "незаметным движением руки достал"..setsex.." с под ремня нож",
              [9] = "взял бензопилу в руки и завел"..setsex.." её",
              [16] = "достал"..setsex.." гранату с сумки и выдернул"..setsex.." с неё чеку",
              [17] = "надел"..setsex.." противогаз, затем достал"..setsex.." с сумки слезоточивую гранату",
              [18] = "достал"..setsex.." с сумки коктейль молотова и поддож"..(pInfo.settings.sex == 1 and "ег" or "гла").." тряпку",
              [22] = "достал"..setsex.." с кобуры пистолет марки \"ТТ - 9\" и проготовил"..setsex.." его к стрельбе",
              [23] = "достал"..setsex.." с крепления электрошокер и нажал"..setsex.." на кнопку \"On\"",
              [24] = "достал"..setsex.." с кобуры пистолет марки \"Desert Eagle\" и перезарядил"..setsex.." его",
              [25] = "достал"..setsex.." с чехла на спине помповый дробовик и зарядил"..setsex.." его",
              [26] = "достал"..setsex.." с чехла обрез и зарядил"..setsex.." его",
              [27] = "достал"..setsex.." с чехла скорострельный дробовик и вставил"..setsex.." в него патроны",
              [28] = "снял"..setsex.." с крепления \"Micro Uz\" и перезарядил"..setsex.." его",
              [29] = "cнял"..setsex.." с плеча пистолет-пулемет \"MP-5\" и перезарядил"..setsex.." его",
              [30] = "снял"..setsex.." с плеча автомат \"Калашникова\" и передернул"..setsex.." затвор",
              [31] = "снял"..setsex.." с плеча карабин \"M4A1\" и передернул"..setsex.." затвор",
              [33] = "снял"..setsex.." с плеча полу-автоматическую винтовку и перезарядил"..setsex.." её",
              [34] = "достал"..setsex.." с кейса снайперскую винтовку затем вставил"..setsex.." магазин и перезарядил"..setsex.." её",
            }
            local rpot = weaponrp[weapon]
            if rpot ~= nil then
              sampSendChat('/me '..rpot)
            end
          end
        end
      end
      sInfo.weapon = weapon
    end
  end)
end

function secoundTimer()
  lua_thread.create(function()
    local updatecount = 0
    while true do
      -- Маркер
      if playerMarker ~= nil then
        if doesBlipExist(playerMarker) and doesBlipExist(playerRadar) then
          local result, ped = sampGetCharHandleBySampPlayerId(playerMarkerId)
          if result then
            local sx, sy, sz = getCharCoordinates(ped)
            local result2 = setBlipCoordinates(playerRadar, sx, sy, sz)
          end
        else
          atext('Игрок покинул зону прорисовки. Маркер отключен')   
          removeBlip(playerMarker)
          removeBlip(playerRadar)
          playerMarker = nil
          playerRadar = nil
        end
      end
      -- Счётчики онлайна
      if sInfo.isWorking == true then
        pInfo.info.weekWorkOnline = pInfo.info.weekWorkOnline + 1
        pInfo.info.dayWorkOnline = pInfo.info.dayWorkOnline + 1
      end
      pInfo.info.dayOnline = pInfo.info.dayOnline + 1
      pInfo.info.weekOnline = pInfo.info.weekOnline + 1
      pInfo.info.dayAFK = pInfo.info.dayAFK + (os.time() - sInfo.updateAFK - 1)
      if updatecount >= 10 then filesystem.save(pInfo, 'config.json') updatecount = 0 end
      updatecount = updatecount + 1
      sInfo.updateAFK = os.time()
      ----------==============----------
      -- Автдоклады
      if post.active == true and sInfo.isWorking == true then
        local cx, cy, cz = getCharCoordinates(PLAYER_PED)
        for i = 1, #postInfo do
          local pi = postInfo[i]
          if cx >= pi.coordX - pi.radius and cx <= pi.coordX + pi.radius and cy >= pi.coordY - pi.radius and cy <= pi.coordY + pi.radius and cz >= pi.coordZ - pi.radius and cz <= pi.coordZ + pi.radius then
            if pi.name == "КПП" then addcounter(6, 1)
            else addcounter(5, 1) end
            if post.lastpost ~= i then
              punkeyActive = 3
              punkey[3].text = ("Заступил%s на пост: «%s»."):format(pInfo.settings.sex == 1 and "" or "а", pi.name)
              punkey[3].time = os.time()
              atext(("Нажмите {139904}\"%s\"{FFFFFF} для оповещения об заступлении на пост '%s'"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + "), pi.name))
              post.lastpost = i
            end
            if post.next >= post.interval then
              local count = 1
              for i = 0, 1001 do
                if sampIsPlayerConnected(i) then
                  if sampGetFraktionBySkin(i) == "Army" then
                    local result, ped = sampGetCharHandleBySampPlayerId(i)
                    if result then
                      local px, py, pz = getCharCoordinates(ped)
                      if px >= pi.coordX - pi.radius and px <= pi.coordX + pi.radius and py >= pi.coordY - pi.radius and py <= pi.coordY + pi.radius and pz >= pi.coordZ - pi.radius and pz <= pi.coordZ + pi.radius then
                        count = count + 1
                      end
                    end
                  end
                end
              end
              cmd_r(("Пост: «%s». Количество бойцов: %d. Состояние: code 1"):format(pi.name, count))
              post.next = 0
            end
            post.next = post.next + 1
            break
          elseif post.lastpost == i then
            punkeyActive = 3
            punkey[3].text = ('Покинул%s пост: «%s».'):format(pInfo.settings.sex == 1 and "" or "а", pi.name)
            punkey[3].time = os.time()
            atext(("Нажмите {139904}\"%s\"{FFFFFF} чтобы оповестить об уходе с поста '%s'"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + "), pi.name))
            post.lastpost = 0
          end
        end      
      end
      wait(1000)  
    end
    return
  end)
end

-- Вызов таргет меню
function targetPlayer(id)
  if pInfo.settings.target ~= true then return end
  id = tonumber(id)
  if id == nil or not sampIsPlayerConnected(id) then atext('Target Error: Игрок не найден!') return end 
  window['target'].v = true
  targetMenu = {
    playerid = id,
    time = os.time(),
    show = true,
    cursor = false,
    coordX = pInfo.settings.hudX+160,
    coordY = pInfo.settings.hudY+85
  }
  -- 320x170
  -- Вызов меню вниз, если места не хватает, вызываем вверх.
  targetMenu.slide = "bottom"
  if screeny < pInfo.settings.hudY + 85 + 95 + 25 then targetMenu.slide = "top" end
  lua_thread.create(function()
    while true do
      wait(150)
      if targetMenu.playerid ~= id then return end -- Убиваем старые циклы
      if targetMenu.time < os.time() - 5 then -- Убиваем циклы, которые неактивны более 5 секунд
        targetMenu.show = false
        -- Задержка для анимации
        wait(500)
        window['target'].v = false
        targetMenu.playerid = nil
        targetMenu.time = nil
        return
      end
    end
    return
  end)
end

-- Действия
function punaccept()
  if sInfo.isWorking == false then return end
  if punkeyActive == 0 then return
  elseif punkeyActive == 1 then
    if punkey[1].nick then
      if punkey[1].time > os.time() - 1 then atext("Не флуди!") return end
      if punkey[1].time > os.time() - 15 then
        funcc('punkey_uninvite', 1)
        cmd_r('Боец '..string.gsub(punkey[1].nick, "_", " ")..' уволен из армии. Причина: '..punkey[1].reason)
      end
      punkey[1].nick, punkey[1].reason, punkey[1].time = nil, nil, nil
    end
  elseif punkeyActive == 2 then
    if punkey[2].nick then
      if punkey[2].time > os.time() - 1 then atext("Не флуди!") return end
      if punkey[2].time > os.time() - 15 then
        funcc('punkey_giverank', 1)
        sampSendChat(('/me достал'..(pInfo.settings.sex == 1 and "" or "а")..' %s %sа, и передал их человеку напротив'):format(punkey[2].rank > 6 and "погоны" or "лычки", rankings[punkey[2].rank]))
      end
      punkey[2].nick, punkey[2].rank, punkey[2].time = nil, nil, nil
    end
  elseif punkeyActive == 3 then
    if punkey[3].text ~= nil then
      if punkey[3].time > os.time() - 1 then atext("Не флуди!") return end
      if punkey[3].time > os.time() - 15 then
        funcc('punkey_autopostavki', 1)
        cmd_r(punkey[3].text)
        --------
        if punkey[3].text:match("Состояние %- 300%/300") then
          punkeyActive = 3
          punkey[3].text = ("На связи борт - %d. Завершил"..(pInfo.settings.sex == 1 and "" or "а").." поставки на ГС Army LV, беру курс на часть."):format(sInfo.playerid)
          punkey[3].time = os.time()
          atext(("Нажмите {139904}\"%s\"{FFFFFF} для оповещения в рацию об окончании поставок"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + ")))
          return
        end
      end
      punkey[3].text, punkey[3].time = nil, nil
    end
  end
  punkeyActive = 0
end

function clearparams()
  data.imgui.mw = imgui.ImBool(false)
  data.imgui.player = imgui.ImInt(-1)
  data.imgui.vigtype = imgui.ImBuffer(256)
  data.imgui.reason = imgui.ImBuffer(256)
  data.imgui.narkolvo = imgui.ImInt(0)
  data.imgui.govka = imgui.ImBuffer(256)
  data.imgui.grang = imgui.ImInt(0)
  data.imgui.invrang = imgui.ImInt(1)
end

-- Загружаем админов из файла
function loadAdmins()
  local file = io.open("moonloader/SFAHelper/admins.txt", "a+")
  local count = 0
  adminsList = {}
  for line in file:lines() do
    local n, l = line:match("(.+)=(.+)")
    if n ~= nil and tonumber(l) ~= nil then
      adminsList[#adminsList + 1] = { nick = n, level = tonumber(l) }
      count = count + 1
    end
  end
  file:close()
  logger.info("Загружено "..count.." админов")
end

-- Загружаем необходимые файлы
function loadFiles()
  lua_thread.create(function()
    --- Загрузка библиотек
    if not lcopas or not lhttp then
      funcc('loadfiles_copas', 1)
      atext('Необходимые для работы библиотеки не были найдены. Скачиваем...')
      local direct = {'copas'}
      local files = {'copas.lua', "copas/ftp.lua", 'copas/http.lua', 'copas/limit.lua', 'copas/smtp.lua', 'requests.lua'}
      for k, v in pairs(direct) do if not doesDirectoryExist("moonloader/lib/"..v) then createDirectory("moonloader/lib/"..v) end end
      for k, v in pairs(files) do
        copas_download_status = 'proccess'
        downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/'..v, 'moonloader/lib/'..v, function(id, status, p1, p2)
          if status == dlstatus.STATUS_DOWNLOADINGDATA then
            copas_download_status = 'proccess'
            print(string.format('Загружено %d килобайт из %d килобайт.', p1, p2))
          elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
            copas_download_status = 'succ'
          elseif status == 64 then
            copas_download_status = 'failed'
          end
        end)
        while copas_download_status == 'proccess' do wait(0) end
        if copas_download_status == 'failed' then
          atext('Не удалось загрузить библиотеку \'copas\'')
          thisScript():unload()
        else
          print(v..' был загружен')
        end
      end
      atext('Все необходимые библиотеки были загружены')
      reloadScripts()
    end
    if not doesDirectoryExist("moonloader\\SFAHelper\\lectures") then
      createDirectory("moonloader\\SFAHelper\\lectures")
      local file = io.open('moonloader/SFAHelper/lectures/firstlecture.txt', "w+")
      file:write("Обычное сообщение\n/s Сообщение с криком\n/b Сообщение в b чат\n/rb Сообщение в рацию\n/w Сообщение шепотом")
      file:flush()
      file:close()
      file = nil
    end
    if not doesDirectoryExist("moonloader\\SFAHelper\\shpora") then
      createDirectory("moonloader\\SFAHelper\\shpora")
      local file = io.open('moonloader/SFAHelper/shpora/Первая шпора.txt', "w+")
      file:write("Добавить свои шпаргалки вы можете в папке 'moonloader/SFAHelper/shpora'")
      file:flush()
      file:close()
      file = nil
    end
    complete = true
    return
  end)
end

-- Старая загрузка полномочий
function loadPermissions(table_url)
  local nick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(playerPed)))
  logger.trace("Проверяем права доступа. Очередь: "..tostring(asyncQueue))
  asyncQueue = true
  httpRequest(table_url, nil, function(response, code, headers, status)
    if response then
      for line in response:gmatch('[^\r\n]+') do
        if line:match("^blacklist\t"..nick.."$") then
          sInfo.blPermissions = true
        end
      end
      logger.trace("Права пользователей успешно загружены")
      complete = true
      asyncQueue = false
      return
    else
      logger.trace("Права пользователей не загружены")
      complete = true
      asyncQueue = false
      return
    end
  end)
end

function pushradioLog(text)
  local result = {}
  if text:match("^ .- %w+_%w+: .+") then
    local rank, name, surname, radio = text:match("^ (.-) (%w+)_(%w+): (.+)")
    radio = radio:gsub('%[.-%]', '')
    radio = radio:gsub(':', '')
    result.rank = rank
    result.from = name.."_"..surname
    result.text = radio
  else return end
  result.time = os.date('%d.%m.%Y')..' '..os.date('%H:%M:%S')
  ------- Сохранение --------
  local punishjson = filesystem.load('punishlog.json')
  if punishjson == nil then
    local fa = io.open(filesystem.path().."/punishlog.json", "w")
    fa:write("[]")
    fa:close()
    pushradioLog(text)
    return
  end
  table.insert(punishjson, result)
  filesystem.save(punishjson, "punishlog.json")
end

-- Отправляем статистику на хосте (отключено)
function sendStats(url)
  local requests = require 'requests'
  local response = requests.get(url)
  local info = decodeJson(response.text)
  if info ~= nil then
    if info.success == true then
      if type(info.permissions) == "table" then
        sInfo.blPermissions = info.permissions.blacklist
      else logger.warn("Ошибка извлечения полномочий: "..info.permissions) end
      if type(info.admins) == "table" then
        for k, v in ipairs(info.admins) do
          adminsList[#adminsList + 1] = { nick = v.nick, level = v.level }
        end
      else logger.warn("Ошибка извлечения списка админов: "..info.admins) end
    else
      logger.warn("Ошибка сервера: "..info.error)
    end
    logger.trace("Время выполнения запроса сервером: "..info.response.."s")
  else logger.warn("Ответ от сервера некорректный: "..tostring(response.text)) end
  complete = true
  asyncQueue = false
end

-- Автообновление
function autoupdate(json_url)
  logger.debug("Проверяем наличие обновлений. Очередь: "..tostring(asyncQueue))
  asyncQueue = true
  httpRequest(json_url, nil, function(response, code, headers, status)
    if response then
      local info = decodeJson(response)
      if DEBUG_MODE then
        updatelink = info.sfahelpertest.url
        updateversion = info.sfahelpertest.version
        updateversiontext = info.sfahelpertest.versiontext
      else
        updatelink = info.sfahelpernew.url
        updateversion = info.sfahelpernew.version
        updateversiontext = info.sfahelpernew.versiontext     
      end
      logger.debug('Версия на сервере: '..tostring(updateversion))
      if updateversion > thisScript().version then
        lua_thread.create(function()
          atext('Обнаружено обновление. Пытаюсь обновиться c '..SCRIPT_ASSEMBLY..' на '..updateversiontext)
          logger.info("Обнаружено обновление. Версия: "..updateversiontext)
          wait(250)
          local dlstatus = require('moonloader').download_status
          downloadUrlToFile(updatelink, thisScript().path,
            function(id, status, p1, p2)
              if status == dlstatus.STATUS_DOWNLOADINGDATA then
                print(string.format('Загружено %d из %d.', p1, p2))
              elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
                logger.info('Загрузка обновления успешно завершена')
                atext('Обновление завершено. Просмотреть список изменений: /shupd')
                goupdatestatus = true
                lua_thread.create(function() wait(500) thisScript():reload() end)
              end
              if status == dlstatus.STATUSEX_ENDDOWNLOAD then
                if goupdatestatus == nil then
                  logger.warn('Обновление прошло неудачно')
                  atext('Обновление прошло неудачно. Запускаю устаревшую версию..')
                  complete = true
                end
              end
            end
          )
          return
        end)
      else logger.info("Доступных обновлений нет") complete = true end
      asyncQueue = false 
    else
      logger.warn("Ответ был получен с ошибкой")
      asyncQueue = false
      atext('Не удалось проверить обновления')
      complete = true      
    end
  end)
end


------------------------ HOOKS ------------------------
function sampevents.onSendCommand(command)
  local str = replaceIds(command)
  sInfo.flood = os.clock()
  if str ~= command then
    return { str }
  end
end

function sampevents.onSendChat(message)
  local str = replaceIds(message)
  sInfo.flood = os.clock()
  if str ~= message then
    return { str }
  end
end

-- @id, #id
function replaceIds(string)
  while true do
    if string:find("@%d+") then
      local id = string:match("@(%d+)")
      if id ~= nil and sampIsPlayerConnected(id) then
        string = string:gsub("@"..id, sampGetPlayerNickname(id))
      else
        string = string:gsub("@"..id, id)
      end
    else break end
  end
  -------------
  while true do
    if string:find("#%d+") then
      local id = string:match("#(%d+)")
      if id ~= nil and sampIsPlayerConnected(id) then
        string = string:gsub("#"..id, sampGetPlayerNickname(id):gsub('_', ' '))
      else
        string = string:gsub("#"..id, id)
      end
    else break end
  end
  return string
end

-- Хук на смену ника игроков
function sampevents.onSetPlayerColor(player, color)
  color = ("%06X"):format(bit.rshift(color, 8))
  for i = 1, #spectate_list do
    if spectate_list[i] ~= nil then
      if player == spectate_list[i].id  and spectate_list[i].clist ~= color then
        atext(string.format('Игрок %s[%d] сменил цвет ника с %s на %s', spectate_list[i].nick, spectate_list[i].id, getcolorname(spectate_list[i].clist), getcolorname(color)))
        spectate_list[i].clist = color
        return
      end
    end
  end
end

-- Хук на выход игрока из игры
function sampevents.onPlayerQuit(playerid, reason)
  if playerid == targetID then
    targetID = nil
  end
  if playerid == playerMarkerId then
    playerMarkerId = nil
  end
  for i = 1, #spectate_list do
    if spectate_list[i] ~= nil then
      if playerid == spectate_list[i].id then
        atext(string.format('Игрок %s[%d] вышел из игры. Последний клист: %s', spectate_list[i].nick, playerid, getcolorname(spectate_list[i].clist)))
        spectate_list[i] = nil
        return
      end
    end
  end
end

-- Авто-БП
function sampevents.onShowDialog(dialogid, style, title, button1, button2, text)
  if pInfo.settings.autobp == true and dialogid == 5225 then
    if pInfo.settings.autobpguns == nil then pInfo.settings.autobpguns = {2,2,0,2,2,1,0} end
    lua_thread.create(function()
      for i = autoBP, #pInfo.settings.autobpguns do
        if pInfo.settings.autobpguns[i] > autoBPCounter then
          wait(250)
          autoBPCounter = autoBPCounter + 1
          sampSendDialogResponse(5225, 1, i - 1, "")
          break
        else
          autoBP = i + 1
          autoBPCounter = 0
        end
      end
      if autoBP == #pInfo.settings.autobpguns + 1 then
        autoBP = 1
        autoBPCounter = 0
        sampCloseCurrentDialogWithButton(0)
        if pInfo.settings.rpweapons > 0 then
          wait(250)
          sampSendChat('/me взял'..(pInfo.settings.sex == 1 and "" or "а")..' комплекты оружия и боеприпасов из склада')
        end
      end
    end)
  end
  if dialogid == 1 and #tostring(pInfo.settings.password) >= 6 and pInfo.settings.autologin then
    sampSendDialogResponse(dialogid, 1, _, tostring(pInfo.settings.password))
    return false
  end
end

function sampevents.onSendGiveDamage(playerId, damage, weapon, bodypart)
  giveDMG = playerId
  giveDMGTime = os.time()
  giveDMGSkin = sampGetFraktionBySkin(playerId)
end

function sampevents.onPlayerDeath(playerid)
  if giveDMG == playerid and giveDMGSkin ~= nil and giveDMGTime >= os.time() - 1 then
    -- Счётчик убийств в порту
    if isCharInArea2d(PLAYER_PED, 2720.00 + 150, -2448.29 + 150, 2720.00 - 150, -2448.29 - 150, false) then
      if giveDMGSkin ~= "FBI" and giveDMGSkin ~= "Police" and giveDMGSkin ~= "Army" then
        addcounter(12, 1)
        return
      end
    end
    -----------------
    -- Смена кода при убийстве на посту
    if post.active == true and sInfo.isWorking == true and post.lastpost > 0 then
      if giveDMGSkin ~= "FBI" and giveDMGSkin ~= "Police" and giveDMGSkin ~= "Army" then
        local pi = postInfo[post.lastpost]
        local count = 1
        for i = 0, 1001 do
          if sampIsPlayerConnected(i) then
            if sampGetFraktionBySkin(i) == "Army" then
              local rx, ry, rz = getCharCoordinates(ped)
              local distance = distBetweenCoords(rx, ry, rz, pi.coordX, pi.coordY, pi.coordZ)
              if distance <= pi.radius then count = count + 1 end
            end
          end
        end
        punkeyActive = 3
        punkey[3].text = ("Пост: «%s». Количество бойцов: %d. Состояние: code 3"):format(pi.name, count)
        punkey[3].time = os.time()
        atext(("Нажмите {139904}\"%s\"{FFFFFF} для оповещения об отражении атаки"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + ")))
      end
    end
    dtext('OnPlayerDeath('..playerid..')')
    giveDMG, giveDMGTime, giveDMGSkin = nil, nil, nil
  end
end

-- Авто-клист
function sampevents.onSetSpawnInfo(team, skin, unk, position, rotation, weapons, ammo)
  lua_thread.create(function()
    wait(1100)
    if pInfo.settings.clist ~= nil and sInfo.isWorking == true then
      sampSendChat('/clist '..pInfo.settings.clist)
      funcc('autoclist', 1)
    end
    return
  end)
end

-- Очень большой хук на всякий хлам
function sampevents.onServerMessage(color, text)
  if pInfo.settings.chatconsole then sampfuncsLog(tostring(text)) end
  local date = os.date("%d.%m.%y %H:%M:%S")
  local file = io.open('moonloader/SFAHelper/chatlog.txt', 'a+')
  file:write(('[%s] %s\n'):format(date, tostring(text)))
  file:close()
  file = nil
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
      if playerid ~= nil and (sampIsPlayerConnected(playerid) or playerid == sInfo.playerid) then
        if sampGetPlayerNickname(playerid) == nick then
          text = text:gsub(" %["..playerid.."%]", "")
        end
      end
    elseif match ~= nil and match > finds[2] then
      local name, surname, playerid = text:match("(%w+)_(%w+)%[(%d+)%]")
      local nick = name.."_"..surname
      finds[2] = match
      playerid = tonumber(playerid)
      if playerid ~= nil and (sampIsPlayerConnected(playerid) or playerid == sInfo.playerid) then
        if sampGetPlayerNickname(playerid) == nick then
          text = text:gsub("%["..playerid.."%]", "")
        end
      end
    else break end
  end
  ------------------------
  -- /members
  if sInfo.fraction == "SFA" or sInfo.fraction == "LVA" then
    if text:match("^ Члены организации Он%-лайн:$") then
      data.members = {}
      membersInfo.work = 0
      membersInfo.nowork = 0
      if membersInfo.mode >= 2 then return false end
    end
    if text:match("^ Всего: %d+ человек$") then
      membersInfo.online = tonumber(text:match("^ Всего: (%d+) человек$"))
      if membersInfo.mode >= 2 then membersInfo.mode = 0 return false end
      membersInfo.mode = 0
    end
    if text:match("") and color == -1 and membersInfo.mode >= 2 then return false end
    -----------------
    if text:match("^ ID: %d+ | .+%[%d+%] %- {.+}.+{FFFFFF} | {FFFFFF}%[AFK%]%: .+ секунд$") then
      local id, _, rank, status, afk = text:match("^ ID: (%d+) | (.+)%[(%d+)%] %- (.+){FFFFFF} | {FFFFFF}%[AFK%]%: (.+) секунд$")
      id = tonumber(id)
      rank = tonumber(rank)
      if status == "{008000}На работе" then 
        status = true
        membersInfo.work = membersInfo.work + 1
      else 
        status = false
        membersInfo.nowork = membersInfo.nowork + 1
      end
      data.members[#data.members + 1] = { pid = id, prank = rank }
      if id == sInfo.playerid then
        pInfo.settings.rank = rank
        sInfo.isWorking = status
      end
      -- colormembers
      if membersInfo.mode == 1 then
        streamed, _ = sampGetCharHandleBySampPlayerId(id)
        -- Убираем даты инвайта
        if pInfo.settings.membersdate == true then
          text = ("ID: %d | %s: %s[%d] - %s{FFFFFF} | [AFK]: %s секунд"):format(id, sampGetPlayerNickname(id), rankings[rank], rank, status and "{008000}На работе" or "{ae433d}Выходной", afk)
        end
        if id == sInfo.playerid then sampAddChatMessage(text, sampGetPlayerColor(id))
        else sampAddChatMessage(string.format("%s - %s", text, streamed and "{00BF80}in stream" or "{ec3737}not in stream"), sampGetPlayerColor(id)) end
        return false
      elseif membersInfo.mode == 2 then
        membersInfo.players[#membersInfo.players + 1] = { mid = id, mrank = rank, mstatus = status, mafk = afk }
        return false
      end
    elseif text:match("^ ID: %d+ | .+%[%d+%] %- {.+}.+{FFFFFF}$") then
      local id, _, rank, status = text:match("^ ID: (%d+) | (.+)%[(%d+)%] %- (.+){FFFFFF}$")
      id = tonumber(id)
      rank = tonumber(rank)
      if status == "{008000}На работе" then 
        status = true
        membersInfo.work = membersInfo.work + 1
      else 
        status = false
        membersInfo.nowork = membersInfo.nowork + 1
      end
      data.members[#data.members + 1] = { pid = id, prank = rank }
      if id == sInfo.playerid then
        pInfo.settings.rank = rank
        sInfo.isWorking = status
      end
      if membersInfo.mode == 1 then
        streamed, _ = sampGetCharHandleBySampPlayerId(id)
        if pInfo.settings.membersdate == true then
          text = ("ID: %d | %s: %s[%d] - %s{FFFFFF}"):format(id, sampGetPlayerNickname(id), rankings[rank], rank, status and "{008000}На работе" or "{ae433d}Выходной")
        end
        if id == sInfo.playerid then sampAddChatMessage(text, sampGetPlayerColor(id))
        else sampAddChatMessage(string.format("%s - %s", text, streamed and "{00BF80}in stream" or "{ec3737}not in stream"), sampGetPlayerColor(id)) end
        return false
      elseif membersInfo.mode == 2 then
        membersInfo.players[#membersInfo.players + 1] = { mid = id, mrank = rank, mstatus = status }
        return false
      end
    end
  end
  -- Отслеживаем начало рабочего дня
  if text:match("Рабочий день начат") and color == 1687547391 then
    if sInfo.fraction == "SFA" or sInfo.fraction == "LVA" then sInfo.isWorking = true end
    if pInfo.settings.clist ~= nil then
      lua_thread.create(function() wait(250) sampSendChat('/clist '..pInfo.settings.clist) end)
    end
    logger.info('Рабочий день начат')
  end
  -- Отслеживаем конец рабочего дня
  if text:match("Рабочий день окончен") and color == 1687547391 then
    sInfo.isWorking = false
    logger.info('Рабочий день окончен')
  end
  -- /giverank
  if text:match("Вы назначили .+ .+%[%d+%]") and color == -1697828097 then
    local pNick, _, pRank = text:match("Вы назначили (.+) (.+)%[(%d+)%]")
    addcounter(3, 1)
    lua_thread.create(function()
      wait(100)
      fileLog(pNick, 'Ранг', _, pRank, _)
      if sInfo.isWorking and pInfo.settings.rank >= 12 and tonumber(pRank) > 1 then
        punkeyActive = 2
        punkey[2].nick = pNick
        punkey[2].time = os.time()
        punkey[2].rank = tonumber(pRank)
        atext(("Нажмите {139904}\"%s\"{FFFFFF} для РП отыгровки повышения"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + ")))
      end
      return
    end)
  end
  -- /invite
  if text:match(".+ передал%(%- а%) форму .+") and color == -1029514582 then
    local kto, kogo = text:match("(.+) передал%(%- а%) форму (.+)")
    if kto == sInfo.nick then
      -- Если это контрактник, повышаем
      if sampGetPlayerNickname(contractId) == kogo then
        lua_thread.create(function()
          wait(250)
          sampSendChat(("/giverank %s %s"):format(contractId, contractRank))
          contractId = nil
          contractRank = nil
          return
        end)
        fileLog(kogo, 'Инвайт', _, 1, _)
      else fileLog(kogo, 'Инвайт', _, 1, _) end  
      addcounter(1, 1)
    elseif kogo == sInfo.nick then
      -- Если вас приняли, начинаем рабочий день
      pInfo.settings.rank = 1
      sInfo.isWorking = true
      logger.debug('Вас приняли. Ранг = 1')
    end  
  end
  if text:match("Доставьте материалы на Зону 51") and color == -86 then -- Загрузился на корабле, лечу в лва
    if pInfo.settings.autodoklad == true then
      punkeyActive = 3
      punkey[3].text = ("На связи борт - %d. Загрузил"..(pInfo.settings.sex == 1 and "ся" or "ась").." на сухогрузе. Беру курс на ГС Army LV."):format(sInfo.playerid)
      punkey[3].time = os.time()
      atext(("Нажмите {139904}\"%s\"{FFFFFF} для оповещения в рацию"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + ")))
    end
  end
  if text:match("На складе Зоны 51 %d+/300000 материалов") and color == -65366 then -- Разгрузился на лва
    addcounter(10, 1)
    if pInfo.settings.autodoklad == true then
      local materials = tonumber(text:match("На складе Зоны 51 (%d+)/300000 материалов"))
      punkeyActive = 3
      punkey[3].text = ("На связи борт - %d. Разгрузил"..(pInfo.settings.sex == 1 and "ся" or "ась").." на ГС Army LV. Состояние - %d/300"):format(sInfo.playerid, math.floor((materials / 1000) + 0.5))
      punkey[3].time = os.time()
      atext(("Нажмите {139904}\"%s\"{FFFFFF} для оповещения в рацию"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + ")))
    end
  end
  if text:match("Отправляйтесь на корабль для загрузки материалов") then
    if pInfo.settings.autodoklad == true then
      if color == -1697828182 then -- Сел в вертолет на ЛВа
        punkeyActive = 3
        punkey[3].text = ("На связи борт - %d. Начал"..(pInfo.settings.sex == 1 and "" or "а").." поставку боеприпасов на ГС Army LV."):format(sInfo.playerid)
        punkey[3].time = os.time()
        atext(("Нажмите {139904}\"%s\"{FFFFFF} для оповещения об начале поставок"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + ")))
      elseif color == -86 then -- Сел в вертолет на ЛСа
        if isCharInArea2d(PLAYER_PED, 2720.00 + 150, -2448.29 + 150, 2720.00 - 150, -2448.29 - 150, false) then
          punkeyActive = 3
          punkey[3].text = "10-15"
          punkey[3].time = os.time()
          atext(("Нажмите {139904}\"%s\"{FFFFFF} для оповещения об начале поставок"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + ")))         
        end
      end
    end
  end
  --[[if text:match("Доставьте материалы в LSA") and color == -86 then -- Загрузился на корабле, лечу в лса
    if pInfo.settings.autodoklad == true then
      --cmd_r("загрузился на корабле, лечу на лса")
    end
  end]]
  if text:match("На складе LSA %d+/200000 материалов") and color == -86 then -- Разгрузился на лса
    addcounter(11, 1)
    if pInfo.settings.autodoklad == true then
      local materials = tonumber(text:match("На складе LSA (%d+)/300000 материалов"))
      punkeyActive = 3
      punkey[3].text = "10-16"
      punkey[3].time = os.time()
      atext(("Нажмите {139904}\"%s\"{FFFFFF} для оповещения в рацию об окончании поставок"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + ")))
    end
  end
  -- /uninvite
  if text:match("Вы выгнали .+ из организации. Причина: .+") and color == 1806958506 then
    local pNick, pReason = text:match("Вы выгнали (.+) из организации. Причина: (.+)")
    if sInfo.isWorking and pInfo.settings.rank >= 13 then
      addcounter(2, 1)
      lua_thread.create(function()
        wait(1250)
        sampSendChat("/me достал"..(pInfo.settings.sex == 1 and "" or "а").." КПК, после чего зашел в базу данных военнослужащих")
        wait(1250)
        sampSendChat("/me отметил"..(pInfo.settings.sex == 1 and "" or "а").." личное дело "..string.gsub(pNick, "_", " ").." как «Уволен»")
        wait(100)
        fileLog(pNick, 'Увал', _, _, pReason)
        punkeyActive = 1
        punkey[1].nick = pNick
        punkey[1].time = os.time()
        punkey[1].reason = pReason
        atext(("Нажмите {139904}\"%s\"{FFFFFF} оповещения в рацию об увольнении"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + ")))
        return 
      end)
    end
  end
  -- /pm
  if text:match('^ Ответ от .+ к .+:') then
    local mynick, egonick = text:match('^ Ответ от (.+) к (.+):')
    if mynick == sInfo.nick then
      pInfo.info.dayPM = pInfo.info.dayPM + 1
      pInfo.info.weekPM = pInfo.info.weekPM + 1
    end
    if sInfo.isSupport == false then sInfo.isSupport = true end
  end
  -- Саппортский /sduty
  if text:match('Рабочий день начат') and color == -1 then
    sInfo.isSupport = true
    funcc('supports', 1)
  end
  if text:match('Рабочий день окончен') and color == -1 then sInfo.isSupport = false end
  ---------
  if text:match(".+ выгнал вас из организации. Причина: .+") then
    pInfo.settings.rank = 0
    sInfo.isWorking = false
    logger.debug('Вас уволили. Ранг обнулился')
  end
  if text:match(".+ назначил Вас .+%[.+%]") then
    if sInfo.isWorking == true then
      pInfo.settings.rank = tonumber(select(3, text:match("(.+) назначил Вас (.+)%[(.+)%]$")))
      logger.debug('Вас повысили. Ранг: '..pInfo.settings.rank)
    end
  end
  -- Рация фракции
  if color == -1920073984 then
    if sInfo.isWorking == false and (sInfo.fraction == "SFA" or sInfo.fraction == "LVA") then
      sInfo.isWorking = true
      logger.info("Проверка прошла успешно, рабочий день начат.")
    end
    lua_thread.create(function()
      local tt = rusLower(text)
      if tt:match("наряд") or tt:match('местоположение') or tt:match('понижен') or tt:match('уволен') or tt:match('комиссован') or tt:match('занесён') or tt:match('выговор') or tt:match('предупреждение') then
        pushradioLog(text)
      end
    end)
  end
  -- Рацияя департамента
  if color == -8224086 then
    if sInfo.isWorking == false and (sInfo.fraction == "SFA" or sInfo.fraction == "LVA") then
      sInfo.isWorking = true
      logger.info("Проверка прошла успешно, рабочий день начат.")
    end
    if text:match("^ %[.+%] .+ %w+_%w+:") then
      local frac, rank, name, surname = text:match("^ %[(.+)%] (.+) (%w+)_(%w+):")
      data.players[#data.players + 1] = { nick = tostring(name.."_"..surname), rank = tostring(rank), fraction = tostring(frac) }
    end
    table.insert(data.departament, text)
  end
  -- Пасспорт
  if color == -169954390 then
    if text:match("Имя: .+") then
      local name = text:match("Имя: (.+)")
      playersAddCounter = #data.players + 1
      data.players[playersAddCounter] = { nick = name }
    end
    if text:match("Фракция: .+  Должность: .+") then
      local frac, rk = text:match("Фракция: (.+)  Должность: (.+)")
      data.players[playersAddCounter] = { nick = data.players[playersAddCounter].nick, rank = rk, fraction = frac }
    end
  end
end

function onScriptTerminate(scr, quit)
  logger.trace('Скрипт '..scr.name..' завершен с кодом: '..tostring(quit))
  if scr == script.this then
    logger.debug('Завершение скрипта...')
  end
end

-- Imgui
function imgui.OnDrawFrame()
  if window['main'].v then
    local btn_size = imgui.ImVec2(-0.1, 0)
    local ImVec4 = imgui.ImVec4
    spacing = 185.0
    ----------------------
    imgui.SetNextWindowSize(imgui.ImVec2(600, 300), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowPos(imgui.ImVec2(screenx / 2, screeny / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin(u8'SFA-Helper | Главное меню', window['main'], imgui.WindowFlags.MenuBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
    ----------------------
    -- Формируем меню
    if imgui.BeginMenuBar(u8 'sfahelper') then
      if imgui.BeginMenu(u8 'Основное') then
        if imgui.MenuItem(u8 'Главная') then data.imgui.menu = 1 end
        if imgui.MenuItem(u8 'Онлайн по дням') then data.imgui.menu = 2 end
        if imgui.MenuItem(u8 'Статистика действий') then data.imgui.menu = 3 end
        imgui.EndMenu()
      end
      if imgui.BeginMenu(u8'Функции') then
        if imgui.MenuItem(u8 'Автодоклад с постов') then clearparams(); data.imgui.menu = 22 end
        if imgui.MenuItem(u8 'Лекции') then clearparams(); data.imgui.selectlecture.string = ""; data.imgui.menu = 24 end
        if imgui.MenuItem(u8 'Запросить местоположение') then clearparams(); data.imgui.menu = 11 end
        if imgui.MenuItem(u8 'Панель слежки') then clearparams(); data.imgui.menu = 23 end
        imgui.EndMenu()
      end
      if imgui.BeginMenu(u8 'Действие с игроком') then
        if pInfo.settings.rank >= 12 then
          if imgui.MenuItem(u8 'Повысить / понизить') then clearparams(); data.imgui.menu = 8 end
          if pInfo.settings.rank >= 13 then
            if imgui.MenuItem(u8 'Уволить игрока') then clearparams(); data.imgui.menu = 10 end
            if pInfo.settings.rank >= 14 then
              if imgui.MenuItem(u8 'Принять игрока') then clearparams(); data.imgui.menu = 9 end
            end
          end
        end
        if imgui.MenuItem(u8 'Вызвать в рубку') then clearparams(); data.imgui.menu = 5 end
        if imgui.MenuItem(u8 'Выдать выговор') then clearparams(); data.imgui.menu = 6 end
        if imgui.MenuItem(u8 'Выдать наряд') then clearparams(); data.imgui.menu = 7 end
        imgui.EndMenu()
      end
      if imgui.BeginMenu(u8 'Говки') then
        if imgui.MenuItem(u8 'Занять гос. волну') then data.imgui.menu = 12 end
        if pInfo.settings.rank >= 14 or sInfo.nick == "Eduardo_Carmone" then
          if imgui.MenuItem(u8 'Отправить гос. волну') then data.imgui.menu = 25 end
        end
        if imgui.MenuItem(u8 'Лог департамента') then data.imgui.menu = 13 end
        imgui.EndMenu()
      end
      if imgui.MenuItem(u8 'Шпора') then data.imgui.shpora = -1; window['shpora'].v = true end
      if imgui.BeginMenu(u8 'Настройки') then
        if imgui.MenuItem(u8 'Основные настройки') then data.imgui.menu = 17 end
        if imgui.MenuItem(u8 'Настройки клавиш') then data.imgui.menu = 18 end
        if imgui.MenuItem(u8 'Биндер') then window['binder'].v = true end
        if imgui.MenuItem(u8 'Команды') then data.imgui.menu = 19 end
        if imgui.MenuItem(u8 'Перезагрузить скрипт') then data.imgui.menu = 20 end
        imgui.EndMenu()
      end
      imgui.EndMenuBar()
    end
    --------================-------
    if data.imgui.menu == 1 then
      imgui.PushItemWidth(100)
      imgui.Text(u8"Ник:"); imgui.SameLine(spacing); imgui.Text(('%s[%d]'):format(sInfo.nick, sInfo.playerid))
      imgui.Text(u8"Рабочий день:"); imgui.SameLine(spacing); imgui.TextColoredRGB(string.format('%s', sInfo.isWorking == true and "{00bf80}Начат" or "{ec3737}Окончен"))
      if sInfo.isWorking == true and pInfo.settings.rank > 0 then
        imgui.Text(u8"Звание:"); imgui.SameLine(spacing); imgui.Text(('%s[%d]'):format(u8:encode(rankings[pInfo.settings.rank]), pInfo.settings.rank))
      end
      imgui.Text(u8"Время авторизации:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(sInfo.authTime))
      imgui.Separator()
      imgui.Text(u8"Отыграно за сегодня:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(secToTime(pInfo.info.dayOnline)))
      imgui.Text(u8"Из них на работе:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(secToTime(pInfo.info.dayWorkOnline)))
      imgui.Text(u8"AFK за сегодня:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(secToTime(pInfo.info.dayAFK)))
      imgui.Separator()
      imgui.Text(u8"Отыграно за неделю:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(secToTime(pInfo.info.weekOnline)))
      imgui.Text(u8"Из них на работе:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(secToTime(pInfo.info.weekWorkOnline)))
      if sInfo.isSupport == true then
        imgui.Separator()
        imgui.Text(u8"Ответов за день"); imgui.SameLine(spacing); imgui.Text(('%s'):format(pInfo.info.dayPM))
        imgui.Text(u8"Ответов за неделю"); imgui.SameLine(spacing); imgui.Text(('%s'):format(pInfo.info.weekPM))
      end
    elseif data.imgui.menu == 2 then
      imgui.PushItemWidth(100)
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
        imgui.Text(u8:encode(dayName[key]))
        imgui.SameLine(spacing)
        imgui.TextColoredRGB(('{%s}%s'):format(colour, daynumber == key and secToTime(pInfo.info.dayOnline) or secToTime(value)))
      end
    elseif data.imgui.menu == 3 then
      imgui.PushItemWidth(100)
      for i = 1, #pInfo.counter do
        local count = pInfo.counter[i]
        if i == 5 or i == 6 then count = secToTime(count) end
        imgui.Text(('%s'):format(u8:encode(counterNames[i])))
        imgui.SameLine(225.0)
        imgui.Text(('%s'):format(count))
      end
    elseif data.imgui.menu == 5 then
      imgui.PushItemWidth(100)
      imgui.InputInt(u8 'Введите ID', data.imgui.player, 0)
      imgui.InputInt(u8 'Количество минут', data.imgui.narkolvo, 0)
      imgui.PopItemWidth()
      imgui.SameLine(200)
      imgui.NewLine()
      if sampIsPlayerConnected(data.imgui.player.v) then
        imgui.Text(u8 ('Вывод: %s, подойдите в рубку. У вас %s минут'):format(sampGetPlayerNickname(data.imgui.player.v):gsub('_', ' '), data.imgui.narkolvo.v))
      else
        imgui.Text(u8 ("Игрок с ID %s не подключен к серверу"):format(data.imgui.player.v))
      end
      if imgui.Button(u8 'Вызвать игрока', imgui.ImVec2(-0.1, 20)) then
        if sampIsPlayerConnected(data.imgui.player.v) then
          funcc('imgui_rubka', 1)
          cmd_r(("%s, подойдите в рубку. У вас %s минут"):format(sampGetPlayerNickname(data.imgui.player.v):gsub("_", " "), data.imgui.narkolvo.v))
        end
      end
    elseif data.imgui.menu == 6 then
      imgui.PushItemWidth(100)
      imgui.InputInt(u8 'Введите ID', data.imgui.player, 0)
      imgui.InputText(u8 'Тип выговора', data.imgui.vigtype)
      imgui.InputText(u8 'Причина выговора', data.imgui.reason)
      imgui.PopItemWidth()
      imgui.SameLine(200)
      imgui.NewLine()
      if sampIsPlayerConnected(data.imgui.player.v) then
        imgui.Text(u8 ('Вывод: %s получает %s выговор за %s'):format(sampGetPlayerNickname(data.imgui.player.v):gsub('_', ' '), (data.imgui.vigtype.v), (data.imgui.reason.v)))
      else
        imgui.Text(u8 ("Игрок с ID %s не подключен к серверу"):format(data.imgui.player.v))
      end
      if imgui.Button(u8 'Выдать выговор', imgui.ImVec2(-0.1, 20)) then
        if sampIsPlayerConnected(data.imgui.player.v) then
          funcc('imgui_vig', 1)
          fileLog(data.imgui.player.v, 'Выговор', u8:decode(data.imgui.vigtype.v), _, u8:decode(data.imgui.reason.v))
          cmd_r(('%s получает "%s" выговор за %s'):format(sampGetPlayerNickname(data.imgui.player.v):gsub("_", " "), u8:decode(data.imgui.vigtype.v), u8:decode(data.imgui.reason.v)))
          timeScreen()
        else atext('Игрок оффлайн!') end
      end
    elseif data.imgui.menu == 7 then
      imgui.PushItemWidth(100)
      imgui.InputInt(u8 'Введите ID', data.imgui.player, 0)
      imgui.InputInt(u8 'Кол-во кругов', data.imgui.narkolvo, 0)
      imgui.InputText(u8 'Причина наряда', data.imgui.reason)
      imgui.PopItemWidth()
      imgui.SameLine(200)
      imgui.NewLine()
      if sampIsPlayerConnected(data.imgui.player.v) then
          imgui.Text(u8 ('Вывод: %s получает наряд %s кругов за %s'):format(sampGetPlayerNickname(data.imgui.player.v):gsub('_', ' '), data.imgui.narkolvo.v, (data.imgui.reason.v)))
      else
          imgui.Text(u8 ("Игрок с ID %s не подключен к серверу"):format(data.imgui.player.v))
      end
      if imgui.Button(u8 'Выдать наряд', imgui.ImVec2(-0.1, 20)) then
        if sampIsPlayerConnected(data.imgui.player.v) then
          addcounter(7, 1)
          funcc('imgui_naryad', 1)
          fileLog(data.imgui.player.v, 'Наряд', _, data.imgui.narkolvo.v, u8:decode(data.imgui.reason.v))
          cmd_r(('%s получает наряд %s кругов за %s'):format(sampGetPlayerNickname(data.imgui.player.v):gsub("_", " "), data.imgui.narkolvo.v, u8:decode(data.imgui.reason.v)))
          timeScreen()
        else atext('Игрок оффлайн!') end
      end
    elseif data.imgui.menu == 8 then
      imgui.PushItemWidth(100)
      imgui.InputInt(u8 'Введите ID', data.imgui.player, 0)
      imgui.InputInt(u8 'Введите новый ранг', data.imgui.grang, 0)
      imgui.PopItemWidth()
      imgui.SameLine(200)
      imgui.NewLine()
      if sampIsPlayerConnected(data.imgui.player.v) then
        imgui.Text(u8 ('Вы собираетесь повысить игрока %s на %s ранг'):format(sampGetPlayerNickname(data.imgui.player.v):gsub('_', ' '), data.imgui.grang.v))
      else
        imgui.Text(u8 ("Игрок с ID %s не подключен к серверу"):format(data.imgui.player.v))
      end
      if imgui.Button(u8 'Изменить ранг', imgui.ImVec2(-0.1, 20)) then
        if sampIsPlayerConnected(data.imgui.player.v) then
          funcc('imgui_giverank', 1)
          fileLog(data.imgui.player.v, 'Ранг', _, data.imgui.grang.v, _)
          sampSendChat(('/giverank %s %s'):format(data.imgui.player.v, data.imgui.grang.v))
          timeScreen()
        else atext('Игрок оффлайн!') end
      end
    elseif data.imgui.menu == 9 then
      imgui.PushItemWidth(100)
      imgui.InputInt(u8 'Введите ID', data.imgui.player, 0)
      imgui.PopItemWidth()
      imgui.SameLine(200)
      imgui.NewLine()
      if sampIsPlayerConnected(data.imgui.player.v) then
        imgui.Text(u8 ('Вы собираетесь принять игрока %s'):format(sampGetPlayerNickname(data.imgui.player.v):gsub('_', ' ')))
      else
        imgui.Text(u8 ("Игрок с ID %s не подключен к серверу"):format(data.imgui.player.v))
      end
      if imgui.Button(u8 'Принять игрока', imgui.ImVec2(-0.1, 20)) then
        if sampIsPlayerConnected(data.imgui.player.v) then
          funcc('imgui_invite', 1)
          fileLog(data.imgui.player.v, 'Инвайт', _, 1, _)
          sampSendChat('/invite '..data.imgui.player.v)
        else atext('Игрок оффлайн!') end
      end
    elseif data.imgui.menu == 10 then
      imgui.PushItemWidth(100)
      imgui.InputInt(u8 'Введите ID', data.imgui.player, 0)
      imgui.InputText(u8 'Причина увольнения', data.imgui.reason)
      imgui.PopItemWidth()
      imgui.SameLine(200)
      imgui.NewLine()
      if sampIsPlayerConnected(data.imgui.player.v) then
        imgui.Text(u8 ('Вы собираетесь уволить игрока %s по причине %s'):format(sampGetPlayerNickname(data.imgui.player.v):gsub('_', ' '), data.imgui.reason.v))
      else
        imgui.Text(u8 ("Игрок с ID %s не подключен к серверу"):format(data.imgui.player.v))
      end
      if imgui.Button(u8 'Уволить игрока', imgui.ImVec2(-0.1, 20)) then
        if sampIsPlayerConnected(data.imgui.player.v) then
          funcc('imgui_uninvite', 1)
          fileLog(data.imgui.player.v, 'Увал', _, _, u8:decode(data.imgui.reason.v))
          sampSendChat(("/uninvite %s %s"):format(data.imgui.player.v, u8:decode(data.imgui.reason.v)))
          timeScreen()
        else atext('Игрок оффлайн!') end
      end
    elseif data.imgui.menu == 11 then
      imgui.PushItemWidth(100)
      imgui.InputInt(u8 'Введите ID', data.imgui.player, 0)
      imgui.InputInt(u8 'Время на ответ', data.imgui.invrang, 0)
      imgui.PopItemWidth()
      imgui.SameLine(200)
      imgui.NewLine()
      if sampIsPlayerConnected(data.imgui.player.v) then
        imgui.Text(u8 ('Вывод: %s, ваше местоположение. На ответ %s секунд'):format(sampGetPlayerNickname(data.imgui.player.v):gsub('_', ' '), (data.imgui.invrang.v)))
      else
        imgui.Text(u8 ("Игрок с ID %s не подключен к серверу"):format(data.imgui.player.v))
      end
      if imgui.Button(u8 'Запросить местоположение', imgui.ImVec2(-0.1, 20)) then
        if sampIsPlayerConnected(data.imgui.player.v) then
          funcc('imgui_loc', 1)
          fileLog(data.imgui.player.v, 'Местоположение', _, u8:decode(data.imgui.invrang.v), _)
          cmd_loc(("%s %s"):format(data.imgui.player.v, u8:decode(data.imgui.invrang.v)))
          --timeScreen()
        else atext('Игрок оффлайн!') end
      end
    elseif data.imgui.menu == 12 then
      imgui.PushItemWidth(100)
      imgui.InputText(u8 'Введите время говки в формате **:**, **:** и т.д.', data.imgui.govka)
      imgui.Separator()
      imgui.Text(u8('/d OG, Занимаю волну гос новостей на %s. Возражения на п.%d'):format(data.imgui.govka.v, sInfo.playerid))
      imgui.Text(u8("/d OG, Напоминаю, волна гос новостей на %s за SFA."):format(data.imgui.govka.v))
      if imgui.Button(u8 'Занять гос. волну', imgui.ImVec2(200, 20)) then
        funcc('imgui_senddep', 1)
        sampSendChat(('/d OG, Занимаю волну гос новостей на %s. Возражения на п.%d'):format(u8:decode(data.imgui.govka.v), sInfo.playerid))
      end
      imgui.SameLine()
      if imgui.Button(u8 'Напомнить о занятой гос. волне', imgui.ImVec2(200, 20)) then
        funcc('imgui_senddep_napom', 1)
        sampSendChat(('/d OG, Напоминаю, волна гос новостей на %s за SFA.'):format(u8:decode(data.imgui.govka.v)))
      end
    elseif data.imgui.menu == 13 then
      imgui.PushItemWidth(100)
      imgui.InputText(u8 'Поиск по тексту', data.imgui.reason)
      imgui.Separator()
      imgui.Text(u8'Отображение 20 последних записей от новых до старых')
      imgui.NewLine()
      local count = 0
      -- Вывод лога департамента
      for i = #data.departament, 1, -1 do
        if i < 1 then break end
        if count >= 20 then break end
        -- Фильтруем по поиску
        if string.find(rusUpper(data.departament[i]), rusUpper(u8:decode(data.imgui.reason.v))) ~= nil or u8:decode(data.imgui.reason.v) == "" then
          imgui.Text(u8(data.departament[i]))
          count = count + 1
        end
      end
    elseif data.imgui.menu == 17 then
      imgui.PushItemWidth(100)
      local membersdate = imgui.ImBool(pInfo.settings.membersdate)
      local autologin = imgui.ImBool(pInfo.settings.autologin)
      local target = imgui.ImBool(pInfo.settings.target)
      local chatconsole = imgui.ImBool(pInfo.settings.chatconsole)
      local doklad = imgui.ImBool(pInfo.settings.autodoklad)
      local hud = imgui.ImBool(pInfo.settings.hud)
      local tagbuffer = imgui.ImBuffer(tostring(pInfo.settings.tag), 256)
      local clistbuffer = imgui.ImBuffer(tostring(pInfo.settings.clist), 256)
      local passbuffer = imgui.ImBuffer(tostring(pInfo.settings.password), 256)
      ----------
      imgui.Text(u8'Введите ваш Тег')
      if imgui.InputText('##tag', tagbuffer) then
        pInfo.settings.tag = u8:decode(tagbuffer.v)
      end
      imgui.SameLine()
      if imgui.Button(u8'Удалить тег') then
        pInfo.settings.tag = nil
      end
      if pInfo.settings.tag ~= nil then
        imgui.Text(u8'Текущий тег: '..u8(pInfo.settings.tag))
      end
      imgui.Spacing()
      imgui.Text(u8'Введите ваш клист')
      if imgui.InputText('##clist', clistbuffer) then
        pInfo.settings.clist = u8:decode(clistbuffer.v)
      end
      imgui.SameLine()
      if imgui.Button(u8'Удалить клист') then
        pInfo.settings.clist = nil
      end
      if pInfo.settings.clist ~= nil then
        imgui.Text(u8'Текущая настройка: /clist '..u8(pInfo.settings.clist))
      end
      -----
      if pInfo.settings.autologin then
        imgui.Spacing()
        imgui.Text(u8'Введите пароль для автологина')
        if imgui.InputText('##pass', passbuffer, imgui.InputTextFlags.Password) then
          pInfo.settings.password = u8:decode(passbuffer.v)
        end   
      end
      imgui.Spacing()
      imgui.Separator()
      imgui.Spacing()
      ------------
      if imgui.ToggleButton(u8 'autologin##1', autologin) then
        pInfo.settings.autologin = autologin.v;
        filesystem.save(pInfo, 'config.json')   
      end
      imgui.SameLine(); imgui.Text(u8 'Автологин в игру')
      ------------
      if imgui.ToggleButton(u8 'autodoklad##1', doklad) then
        pInfo.settings.autodoklad = doklad.v;
        filesystem.save(pInfo, 'config.json')
      end
      imgui.SameLine(); imgui.Text(u8 'Включить автодоклад поставок')
      ------------
      if imgui.ToggleButton(u8 'hud##1', hud) then
        pInfo.settings.hud = hud.v
        window['hud'].v = hud.v
        filesystem.save(pInfo, 'config.json')
      end
      imgui.SameLine(); imgui.Text(u8 'Включить худ')
      ------------
      if imgui.ToggleButton(u8 'dateinmembers##1', membersdate) then
        pInfo.settings.membersdate = membersdate.v;
        filesystem.save(pInfo, 'config.json')
      end
      imgui.SameLine(); imgui.Text(u8 'Убрать дату инвайта в /members 1')
      ------------
      if imgui.ToggleButton(u8 'target##1', target) then
        pInfo.settings.target = target.v;
        filesystem.save(pInfo, 'config.json')
      end
      imgui.SameLine(); imgui.Text(u8 'Включить Target Bar')
      ------------
      if imgui.ToggleButton(u8 'chatconsole##1', chatconsole) then
        pInfo.settings.chatconsole = chatconsole.v;
        filesystem.save(pInfo, 'config.json')
      end
      imgui.SameLine(); imgui.Text(u8 'Отображение чата в консоле SAMPFUNCS')
      ------------
      imgui.Text(u8'РП отыгровка оружия')
      if data.imgui.rpweap.v == -1 then data.imgui.rpweap.v = pInfo.settings.rpweapons end
      imgui.Combo(u8'##rpweap', data.imgui.rpweap, u8"Выключено\0По клавише\0По оружию\0Все вместе\0\0")
      if pInfo.settings.rpweapons ~= data.imgui.rpweap.v then
        pInfo.settings.rpweapons = data.imgui.rpweap.v
        atext('Настройки изменены!')
      end
      ------------
      imgui.Spacing()
      imgui.Text(u8'Пол игрока при РП отыгровках')
      if data.imgui.rpsex.v == -1 then
        if pInfo.settings.sex ~= 1 and pInfo.settings.sex ~= 0 then pInfo.settings.sex = 1 end
        data.imgui.rpsex.v = pInfo.settings.sex
      end
      imgui.Combo(u8'##rpsex', data.imgui.rpsex, u8"Женский\0Мужской\0\0")
      if pInfo.settings.sex ~= data.imgui.rpsex.v then
        pInfo.settings.sex = data.imgui.rpsex.v
        atext('Настройки изменены!')
      end
      ------------
      imgui.Spacing()
      imgui.Separator()
      imgui.Spacing()
      if imgui.Button(u8 'Местоположение худа') then data.imgui.hudpos = true; window['main'].v = false end
      imgui.SameLine();
      if imgui.Button(u8'Обновить список админов') then
        funcc('updateadm', 1)
        atext('Запрос отправлен. Ожидание ответа от сервера...')
        logger.info('Отправен запрос на обновление админов')
        local ip, port = sampGetCurrentServerAddress()
        httpRequest('http://opentest3.000webhostapp.com/api.php?act=getadmins&server='..ip..':'..port, nil, function(response, code, headers, status)
          if response then
            logger.trace("Ответ получен. Код: "..code..", Статус: "..status)
            local info = decodeJson(response)
            if info.success == true then
              local output = ""
              local count = 0
              for key, value in ipairs(info.answer) do
                output = output..string.format("%s=%s\n", value.nick, value.level)
                count = count + 1
              end
              local file = io.open("moonloader/SFAHelper/admins.txt", "w+")
              file:write(output)
              file:close()
              atext('Список админов успешно обновлен! Загружено '..count..' админов')
              loadAdmins()
            else
              logger.warn(string.format("Ошибка сервера: ", info.error == nil and "Подробности не были получены" or info.error))
              atext(string.format('Ошибка сервера: ', info.error == nil and "Подробности не были получены" or info.error))
            end
          else
            logger.warn("Ответ не получен. Код: "..code..", Статус: "..status)
            atext('При обработке запроса произошла ошибка. Попробуйте позже')
          end
        end)
      end
    elseif data.imgui.menu == 18 then
      imgui.PushItemWidth(100)
      if imgui.HotKey('##punaccept', config_keys.punaccept, tLastKeys, 100) then
        rkeys.changeHotKey(punacceptbind, config_keys.punaccept.v)
        filesystem.save(config_keys, 'keys.json')
      end
      imgui.SameLine(); imgui.Text(u8 'Клавиша принятия действия')
      imgui.Separator()
      if imgui.HotKey('##targetplayer', config_keys.targetplayer, tLastKeys, 100) then
        rkeys.changeHotKey(targetplayerbind, config_keys.targetplayer.v)
        filesystem.save(config_keys, 'keys.json')
      end
      imgui.SameLine(); imgui.Text(u8 'Клавиша взаимодействия с Target Menu')
      -----------
      if imgui.HotKey('##rpweap', config_keys.weaponkey, tLastKeys, 100) then
        filesystem.save(config_keys, 'keys.json')
      end
      imgui.SameLine(); imgui.Text(u8 'Клавиша РП отыгровки оружия')

    elseif data.imgui.menu == 19 then
      imgui.TextColoredRGB("/sfahelper{CCCCCC} - Открывает главное меню скрипта")
      imgui.TextColoredRGB("/members [0-2]{CCCCCC} - Просмотреть мемберс")
      imgui.TextColoredRGB("/cn [playerid] [0-1]{CCCCCC} - Скопировать ник. 0 - RP ник, 1 - NonRP ник")
      imgui.TextColoredRGB("/shupd{CCCCCC} - Просмотреть измененения в последнем обновлении")
      imgui.TextColoredRGB("/ev [0-1] [кол-во мест]{CCCCCC} - Запросить эвакуацию. 0 - текущий квадрат, 1- по метке")
      imgui.TextColoredRGB("/loc [id/nick] [секунды]{CCCCCC} - Запросить местоположение бойца")
      imgui.TextColoredRGB("/watch [add/remove/list] [id игрока]{CCCCCC} - Панель слежки за цветом ника игрока")
      imgui.TextColoredRGB("/checkrank [id/nick]{CCCCCC} - Проверка последнего повышения игрока. Доступно с 12+ ранга")
      imgui.TextColoredRGB("/checkbl [id/nick]{CCCCCC} - Проверка игрока на ЧС. Доступно DIS, NETC а также 12+ рангам")
      imgui.TextColoredRGB("/cchat{CCCCCC} - Очищает чат")
      imgui.TextColoredRGB("/toggletarget{CCCCCC} - Включает/Отключает таргет меню в правой стороне экрана")
      imgui.TextColoredRGB("(/lec)ture (pause/stop){CCCCCC} - Выводит подготовленную лекцию в чат")
      imgui.TextColoredRGB("/createpost [название поста]{CCCCCC} - Создает пост, для автодокладов")
      imgui.TextColoredRGB("/addbl{CCCCCC} - Добавляет игрока в Черный Список")
      imgui.TextColoredRGB("/addtable{CCCCCC} - Вызывает меню для добавления игрока в таблицу")
      imgui.TextColoredRGB("/vig [playerid] [тип выговора] [причина]{CCCCCC} - Выдает игроку выговор")
      imgui.TextColoredRGB("/contract [playerid] [ранг]{CCCCCC} - Принимает игрока во фракцию на указанный ранг")
      imgui.TextColoredRGB("/reconnect{CCCCCC} - Переподключение к серверу")
      imgui.TextColoredRGB("/blag [ид] [фракция] [тип]{CCCCCC} - Выразить игроку благодарность в департамент")
      imgui.TextColoredRGB("/abp{CCCCCC} - Включить/Выключить автомитическое взятие БП")
      imgui.TextColoredRGB("/shud{CCCCCC} - Включить/Выключить худ")
      imgui.TextColoredRGB("/match [id/nick]{CCCCCC} - Отображает местонахождение игрока на радаре")
      imgui.TextColoredRGB("/sweather [погода 0 - 45]{CCCCCC} - Изменяет погоду на указанную")
      imgui.TextColoredRGB("/stime [время 0 - 23]{CCCCCC} - Изменяет время на указанное")
      imgui.TextColoredRGB("/rpweap [тип 0 - 3]{CCCCCC} - Изменяет тип РП отыгровки оружия")
      imgui.TextColoredRGB("/punishlog [id /nick]{CCCCCC} - Просмотр наказаний игрока")
    elseif data.imgui.menu == 20 then
      atext("Перезагружаемся...")
      showCursor(false)
      thisScript():reload()
    elseif data.imgui.menu == 22 then
      if post.string == "" then
        -- Загружаем все посты
        post.select = imgui.ImInt(0)
        post.string = u8"Не выбрано\0"
        for i = 1, #postInfo do
          post.string = post.string..u8:encode(postInfo[i].name).."\0"
        end
        post.string = post.string.."\0"
        data.imgui.posradius = imgui.ImInt(15)
      end
      local togglepost = imgui.ImBool(post.active)
      local interval = imgui.ImInt(post.interval)
      if imgui.ToggleButton(u8 'post##1', togglepost) then
        funcc('enable_autodoklad', 1)
        post.active = togglepost.v;
      end
      imgui.SameLine(); imgui.Text(u8 'Включать автодоклад')
      if imgui.InputInt(u8 'Интервал между докладами (в секундах)', interval) then
        if interval.v < 60 then interval.v = 60 end
        if interval.v > 3600 then interval.v = 3600 end
        post.interval = interval.v
      end
      imgui.Separator()
      imgui.Text(u8 'Изменение постов')
      imgui.Combo(u8 'Выберите пост для изменения', post.select, post.string)
      imgui.NewLine()
      if post.select.v > 0 then
        imgui.Text(u8("Координаты поста: %f %f %f"):format(postInfo[post.select.v].coordX, postInfo[post.select.v].coordY, postInfo[post.select.v].coordZ))
        imgui.InputInt(u8("Радиус поста: %f"):format(postInfo[post.select.v].radius), data.imgui.posradius, 0)
        if imgui.Button(u8 'Изменить пост') then
          if data.imgui.posradius.v ~= tonumber(postInfo[post.select.v].radius) then
            atext('Пост успешно изменен!')
            postInfo[post.select.v].radius = data.imgui.posradius.v
            filesystem.save(postInfo, 'posts.json')
          end
        end
        if imgui.Button(u8 'Удалить пост') then
          table.remove(postInfo, post.select.v)
          post.string = ""
          atext('Пост успешно удален!')
          filesystem.save(postInfo, 'posts.json') 
        end
      end
    elseif data.imgui.menu == 23 then
      imgui.InputInt(u8 'Введите ID игрока', data.imgui.player, 0)
      if imgui.Button(u8 'Отправить') then
        local found = false
        if sampIsPlayerConnected(data.imgui.player.v) then
          if data.imgui.player.v ~= sInfo.playerid then
            for i = 1, #spectate_list do
              if spectate_list[i] ~= nil then
                if data.imgui.player.v == spectate_list[i].id then
                  atext(('Игрок %s[%d] успешно убран из панели слежки'):format(spectate_list[i].nick, spectate_list[i].id))
                  spectate_list[i] = nil
                  found = true
                end
              end
            end
            if found == false then
              funcc('imgui_watch_add', 1)
              local color = string.format("%06X", ARGBtoRGB(sampGetPlayerColor(data.imgui.player.v)))
              spectate_list[#spectate_list+1] = { id = data.imgui.player.v, nick = sampGetPlayerNickname(data.imgui.player.v), clist = color }
              atext(string.format('Игрок %s[%d] успешно добавлен в панель слежки. Текущий цвет: %s', spectate_list[#spectate_list].nick, spectate_list[#spectate_list].id, getcolorname(color)))
            end
          else atext('Вы ввели свой ID') end
        else atext('Игрок оффлайн!') end
      end
      imgui.SameLine(200)
      imgui.NewLine()
      if sampIsPlayerConnected(data.imgui.player.v) then
        local found = false
        if data.imgui.player.v ~= sInfo.playerid then
          for i = 1, #spectate_list do
            if spectate_list[i] ~= nil then
              if data.imgui.player.v == spectate_list[i].id then
                imgui.Text(u8("Удалить %s[%d] из списка слежки"):format(spectate_list[i].nick, spectate_list[i].id))
                found = true
              end
            end
          end
          if found == false then
            imgui.Text(u8("Добавить %s[%d] в список слежки"):format(sampGetPlayerNickname(data.imgui.player.v), data.imgui.player.v))
          end
        else imgui.Text(u8'Вы ввели свой ID!') end
      else imgui.Text(u8 ("Игрок с ID %s не подключен к серверу"):format(data.imgui.player.v)) end
      imgui.Separator()
      imgui.BeginChild('##1', imgui.ImVec2(400, 200))
      local count = 0
      for i = 1, #spectate_list do
        if spectate_list[i] ~= nil then
          if sampIsPlayerConnected(spectate_list[i].id) then
            local color = ("%06X"):format(bit.band(sampGetPlayerColor(spectate_list[i].id), 0xFFFFFF))
            local result, ped = sampGetCharHandleBySampPlayerId(spectate_list[i].id)
            if doesCharExist(ped) then
              local mx, my, mz = getCharCoordinates(PLAYER_PED)
              local cx, cy, xz = getCharCoordinates(ped)
              local distance = ("%0.2f"):format(getDistanceBetweenCoords3d(mx, my, mz,cx, cy, xz))
              local forma = "Нет"
              if sampGetFraktionBySkin(spectate_list[i].id) == "Army" then
                local skin = getCharModel(ped)
                if skin == 252 then forma = "Голый"
                else forma = "Да" end
              end
              imgui.TextColoredRGB(("{%s}%s [%s]{ffffff} | Форма: %s | Расстояние: %s"):format(color, spectate_list[i].nick, spectate_list[i].id, forma, distance))
            else
              imgui.TextColoredRGB(("{%s}%s [%s]{FFFFFF} | Не в зоне стрима"):format(color, spectate_list[i].nick, spectate_list[i].id))
            end
            count = count + 1
          end
        end
      end
      if count == 0 then imgui.Text(u8 'Никого в списке слежки нет!') end
      imgui.EndChild()
    elseif data.imgui.menu == 24 then
      if data.imgui.selectlecture.string == "" then
        -- Загружаем список лекций и помещаем в таблицу
        local handle, name = findFirstFile("moonloader/SFAHelper/lectures/*.txt")
        if name == nil then
          name = "firstlecture.txt"
          local file = io.open('moonloader/SFAHelper/lectures/firstlecture.txt', "w+")
          file:write("Обычное сообщение\n/s Сообщение с криком\n/b Сообщение в b чат\n/rb Сообщение в рацию\n/w Сообщение шепотом")
          file:flush()
          file:close()
          file = nil
        end
        data.imgui.selectlecture.int = imgui.ImInt(0)
        data.imgui.selectlecture.string = u8 "Не выбрано\0"
        table.insert(data.imgui.selectlecture, name)
        data.imgui.selectlecture.string = data.imgui.selectlecture.string..u8:encode(name).."\0"
        while true do
          name = findNextFile(handle)
          if name == nil then break end
          table.insert(data.imgui.selectlecture, name)
          data.imgui.selectlecture.string = data.imgui.selectlecture.string..u8:encode(name).."\0"
        end
        findClose(handle)
        data.imgui.selectlecture.string = data.imgui.selectlecture.string.."\0"
      end
      imgui.Combo(u8'Выберите файл лекции', data.imgui.selectlecture.int, data.imgui.selectlecture.string)
      if imgui.Button(u8 'Загрузить лекцию') then
        if data.imgui.selectlecture.int.v > 0 then
          local file = io.open('moonloader/SFAHelper/lectures/'..data.imgui.selectlecture[data.imgui.selectlecture.int.v], "r+")
          if file == nil then atext('Файл не найден!')
          else
            data.imgui.lecturetext = {} 
            for line in io.lines('moonloader/SFAHelper/lectures/'..data.imgui.selectlecture[data.imgui.selectlecture.int.v]) do
              table.insert(data.imgui.lecturetext, line)
            end
            if #data.imgui.lecturetext > 0 then
              atext('Файл лекции успешно загружен! Для начала лекции используйте - (/lec)ture')
            else atext('Файл лекции пуст!') end
          end
          file:close()
          file = nil
        else atext('Выберите файл лекции!') end
      end
      imgui.InputInt(u8 'Выберите задержку (секунды)', data.imgui.lecturetime, 0)
      imgui.Separator()
      imgui.Text(u8 'Содержимое файла лекции:')
      imgui.NewLine()
      if #data.imgui.lecturetext == 0 then imgui.Text(u8 'Файл не загружен!') end
      for i = 1, #data.imgui.lecturetext do
        imgui.Text(u8:encode(data.imgui.lecturetext[i]))
      end
    elseif data.imgui.menu == 25 then
      imgui.PushItemWidth(200)
      local text = u8"Не выбрано\0"
      for key, value in ipairs(pInfo.gov) do
        text = text..u8:encode(value[1]).."\0"
      end
      text = text.."\0"
      imgui.Combo(u8'Выберите шаблон объявления', data.imgui.setgovint, text)
      if imgui.Button(u8'Добавить') then
        data.imgui.setgovtextarea = { imgui.ImBuffer(512), imgui.ImBuffer(512), imgui.ImBuffer(512) }
        data.imgui.menu = 27
      end
      imgui.SameLine()
      if imgui.Button(u8'Редактировать') then
        if data.imgui.setgovint.v > 0 then
          data.imgui.setgovtextarea = {}
          for i = 2, #pInfo.gov[data.imgui.setgovint.v] do
            data.imgui.setgovtextarea[i - 1] = imgui.ImBuffer(512)
            data.imgui.setgovtextarea[i - 1].v = u8:encode(pInfo.gov[data.imgui.setgovint.v][i])
          end
          data.imgui.menu = 26
        else atext('Выберите необходимый шаблон!') end
      end
      imgui.SameLine()
      if imgui.Button(u8'Удалить') then
        if data.imgui.setgovint.v > 0 then
          table.remove(pInfo.gov, data.imgui.setgovint.v)
          data.imgui.setgovint.v = 0
          atext('Шаблон успешно удален!')
          filesystem.save(pInfo, 'config.json')
        else atext('Выберите необходимый шаблон!') end
      end
      imgui.NewLine()
      imgui.InputText(u8 'Введите время в формате **:**', data.imgui.setgov)
      imgui.Separator()
      imgui.NewLine()
      imgui.Text(u8'Предварительный просмотр:')
      ------
      if data.imgui.setgovint.v > 0 then
        for i = 2, #pInfo.gov[data.imgui.setgovint.v] do
          local gov = pInfo.gov[data.imgui.setgovint.v][i]
          gov = gov:gsub("{time}", u8:decode(data.imgui.setgov.v))
          imgui.Text(u8:encode(("/gov %s"):format(gov)))
        end
      else imgui.Text(u8'Нет данных для отображения') end
      ------
      imgui.NewLine()
      imgui.Separator()
      if imgui.Button(u8'Объявить') then
        if data.imgui.setgovint.v > 0 then 
          funcc('imgui_sendgov', 1)
          lua_thread.create(function()
            for i = 2, #pInfo.gov[data.imgui.setgovint.v] do
              local gov = pInfo.gov[data.imgui.setgovint.v][i]
              gov = gov:gsub("{time}", u8:decode(data.imgui.setgov.v))
              sampSendChat(("/gov %s"):format(gov))
              --sampAddChatMessage("/gov "..gov, -1)
              wait(5000)
            end
            return
          end)
        else atext('Выберите нужныш шаблон для объявления!') end
      end
    elseif data.imgui.menu == 26 then
      imgui.PushItemWidth(500)
      if imgui.Button(u8'Добавить строку') then
        data.imgui.setgovtextarea[#data.imgui.setgovtextarea + 1] = imgui.ImBuffer(128)
      end
      imgui.NewLine()
      ------
      for i = 1, #data.imgui.setgovtextarea do
        imgui.InputText('#'..i, data.imgui.setgovtextarea[i])
      end
      ------
      imgui.NewLine()
      imgui.Separator()
      if imgui.Button(u8'Изменить') then
        funcc('imgui_changegov', 1)
        local tit = pInfo.gov[data.imgui.setgovint.v][1]
        pInfo.gov[data.imgui.setgovint.v] = {}
        table.insert(pInfo.gov[data.imgui.setgovint.v], tit)
        for i = 1, #data.imgui.setgovtextarea do
          local govline = data.imgui.setgovtextarea[i].v
          if govline ~= nil and govline ~= "" then
            table.insert(pInfo.gov[data.imgui.setgovint.v], u8:decode(govline))
          end
        end
        data.imgui.setgov.v = ""
        data.imgui.menu = 25
        atext('Шаблон успешно изменен!')
        filesystem.save(pInfo, 'config.json')
      end
      imgui.SameLine()
      if imgui.Button(u8'Отмена') then
        data.imgui.setgov.v = ""
        data.imgui.menu = 25
      end
    elseif data.imgui.menu == 27 then
      imgui.PushItemWidth(500)
      if imgui.Button(u8'Добавить строку') then
        data.imgui.setgovtextarea[#data.imgui.setgovtextarea + 1] = imgui.ImBuffer(128)
      end
      imgui.NewLine()
      imgui.InputText(u8 'Введите название шаблона', data.imgui.setgov)
      ------
      for i = 1, #data.imgui.setgovtextarea do
        imgui.InputText('#'..i, data.imgui.setgovtextarea[i])
      end
      ------
      imgui.NewLine()
      imgui.Separator()
      if imgui.Button(u8'Создать') then
        funcc('imgui_creategov', 1)
        local len = #pInfo.gov + 1
        if data.imgui.setgov.v ~= nil and data.imgui.setgov.v ~= "" then
          pInfo.gov[len] = {}
          table.insert(pInfo.gov[len], u8:decode(data.imgui.setgov.v))
          for i = 1, #data.imgui.setgovtextarea do
            local govline = data.imgui.setgovtextarea[i].v
            if govline ~= nil and govline ~= "" then
              table.insert(pInfo.gov[len], u8:decode(govline))
            end
          end
          data.imgui.setgovint.v = len
          data.imgui.menu = 25
          data.imgui.setgov.v = ""
          atext('Шаблон успешно создан!')
          filesystem.save(pInfo, 'config.json')
        else atext('Неверное название шаблона!') end 
      end
      imgui.SameLine()
      if imgui.Button(u8'Отмена') then
        data.imgui.setgov.v = ""
        data.imgui.menu = 25
      end        
    end
    imgui.End()
  end
  --------================---------
  -- Таргет бар
  if window['target'].v then
    if pInfo.settings.hud then
      -- Анимация движения таргета
      if targetMenu.show == true then
        if targetMenu.slide == "top" then
          targetMenu.coordY = targetMenu.coordY - 25
          if targetMenu.coordY < pInfo.settings.hudY+85-140 then targetMenu.coordY = pInfo.settings.hudY+85-140 end
        elseif targetMenu.slide == "bottom" then
          targetMenu.coordY = targetMenu.coordY + 25
          if targetMenu.coordY > pInfo.settings.hudY+85+140 then targetMenu.coordY = pInfo.settings.hudY+85+140 end
        elseif targetMenu.slide == "left" then
          targetMenu.coordX = targetMenu.coordX - 25
          if targetMenu.coordX < pInfo.settings.hudX+160-320-25 then targetMenu.coordX = pInfo.settings.hudX+160-320-25 end
        elseif targetMenu.slide == "right" then
          targetMenu.coordX = targetMenu.coordX + 25
          if targetMenu.coordX > pInfo.settings.hudX+160+320+25 then targetMenu.coordX = pInfo.settings.hudX+160+320+25 end
        end
      else
        if targetMenu.slide == "top" then
          targetMenu.coordY = targetMenu.coordY + 25
          if targetMenu.coordY > pInfo.settings.hudY+85 then targetMenu.coordY = pInfo.settings.hudY+85 end
        elseif targetMenu.slide == "bottom" then
          targetMenu.coordY = targetMenu.coordY - 25
          if targetMenu.coordY < pInfo.settings.hudY+85 then targetMenu.coordY = pInfo.settings.hudY+85 end
        elseif targetMenu.slide == "left" then
          targetMenu.coordX = targetMenu.coordX + 25
          if targetMenu.coordX > pInfo.settings.hudX+160 then targetMenu.coordX = pInfo.settings.hudX+160 end
        elseif targetMenu.slide == "right" then
          targetMenu.coordX = targetMenu.coordX - 25
          if targetMenu.coordX < pInfo.settings.hudX+160 then targetMenu.coordX = pInfo.settings.hudX+160 end
        end
      end
      imgui.SetNextWindowSize(imgui.ImVec2(320, 95), imgui.Cond.Always)
      imgui.SetNextWindowPos(imgui.ImVec2(targetMenu.coordX, targetMenu.coordY), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
      imgui.Begin(u8'SFAHelper | Таргет меню', _, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoBringToFrontOnFocus + imgui.WindowFlags.NoResize)
      imgui.Text(u8:encode(("Ник: %s[%d]"):format(sampGetPlayerNickname(targetMenu.playerid), targetMenu.playerid)))
      local com = false
      -- Если в скине армейца, чекаем на то, есть ли он в мемберсе
      if sampGetFraktionBySkin(targetMenu.playerid) == "Army" then
        for i = 1, #data.members do
          if data.members[i].pid == targetMenu.playerid then
            imgui.Text(u8:encode(("Фракция: %s | Звание: %s[%d]"):format(sInfo.fraction, rankings[data.members[i].prank], data.members[i].prank)))
            com = true
            break
          end
        end
      end
      ------
      if com == false then
        -- Игрока нет в мемберсе, чекаем, был ли он в /showpass или /d
        for i = 1, #data.players do
          if data.players[i].nick == sampGetPlayerNickname(targetMenu.playerid) then
            imgui.Text(u8:encode(("Фракция: %s | Звание: %s"):format(data.players[i].fraction, data.players[i].rank)))
            com = true
            break
          end
        end
        -- Игрока нигде не было, устаанвливаем фракцию в зависимости от скина
        if com == false then
          imgui.Text(u8:encode(("Фракция: %s"):format(sampGetFraktionBySkin(targetMenu.playerid))))
        end
      end
      local arm = tostring(sampGetPlayerArmor(targetMenu.playerid))
      local health = tostring(sampGetPlayerHealth(targetMenu.playerid))
      local ping = tostring(sampGetPlayerPing(targetMenu.playerid))
      imgui.Text(u8:encode(('Здоровье: %s | Броня: %s | Пинг: %s'):format(health, arm, ping)))
      imgui.TextColoredRGB(("Цвет ника: %s"):format(getcolorname(string.format("%06X", ARGBtoRGB(sampGetPlayerColor(player))))))
      imgui.End()
    end
  end
  --------================---------
  -- /members 2
  if window['members'].v then
		imgui.SetNextWindowPos(imgui.ImVec2(screenx / 2, screeny / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(600, 540), imgui.Cond.FirstUseEver)
		imgui.Begin(u8'SFAHelper | Members Bar', window['members'], imgui.WindowFlags.NoCollapse)
    -----
    if membersInfo.mode == 0 and #membersInfo.players > 0 then
      imgui.Text(u8:encode(('Онлайн фракции: %d | На работе: %d | Выходной: %d'):format(membersInfo.online, membersInfo.work, membersInfo.nowork)))
      imgui.InputText(u8 'Поиск по нику/ID', membersInfo.imgui)
      imgui.Columns(6)
      imgui.Separator()
      imgui.SetColumnWidth(-1, 55); imgui.Text('ID'); imgui.NextColumn()
      imgui.SetColumnWidth(-1, 175); imgui.Text('Nickname'); imgui.NextColumn()
      imgui.SetColumnWidth(-1, 125); imgui.Text('Rank'); imgui.NextColumn()
      imgui.SetColumnWidth(-1, 75); imgui.Text('Status'); imgui.NextColumn()
      imgui.SetColumnWidth(-1, 85); imgui.Text('AFK'); imgui.NextColumn()
      imgui.SetColumnWidth(-1, 60); imgui.Text('Dist'); imgui.NextColumn()
      imgui.Separator()
      for i = 1, #membersInfo.players do
        if membersInfo.players[i] ~= nil then
          if sampIsPlayerConnected(membersInfo.players[i].mid) or membersInfo.players[i].mid == sInfo.playerid then
            if string.find(string.upper(sampGetPlayerNickname(membersInfo.players[i].mid)), string.upper(u8:decode(membersInfo.imgui.v))) ~= nil or string.find(membersInfo.players[i].mid, membersInfo.imgui.v) ~= nil or u8:decode(membersInfo.imgui.v) == "" then
              drawMembersPlayer(membersInfo.players[i])
            end
          end
        end
      end
      imgui.Columns(1)
    else imgui.Text(u8 'Формирование списка...') end
    -----
    if imgui.BeginPopupContextItem('ContextMenu', 1) then
      imgui.PushItemWidth(150)
      if selectedContext ~= nil then
        imgui.Text(u8:encode(("Игрок: %s[%d]"):format(sampGetPlayerNickname(selectedContext), selectedContext)))
      else
        imgui.Text(u8 "Игрок: Не выбрано")
      end
      if imgui.Button(u8'Местоположение', imgui.ImVec2(-0.1, 20)) then
        funcc('imgui_loc_context', 1)
        cmd_loc(selectedContext.." 30")
      end
      if imgui.Button(u8'Скопировать ник', imgui.ImVec2(-0.1, 20)) then
        funcc('imgui_cn_context', 1)
        cmd_cn(selectedContext.." 1")
      end
      if imgui.Button(u8'Скопировать РП ник', imgui.ImVec2(-0.1, 20)) then
        funcc('imgui_cn_context', 1)
        cmd_cn(selectedContext.." 0")
      end
      if imgui.Button(u8'Установить маркер', imgui.ImVec2(-0.1, 20)) then
        funcc('imgui_match_context', 1)
        cmd_match(""..selectedContext)
      end
      if imgui.Button(u8'Проверить повышку', imgui.ImVec2(-0.1, 20)) then
        funcc('imgui_checkrank_context', 1)
        cmd_checkrank(""..selectedContext)
      end
      if imgui.Button(u8'Проверить ЧС', imgui.ImVec2(-0.1, 20)) then
        funcc('imgui_checkbl_context', 1)
        cmd_checkbl(""..selectedContext)
      end
      if imgui.Button(u8'Закрыть', imgui.ImVec2(-0.1, 20)) then
        imgui.CloseCurrentPopup()
      end
      imgui.EndPopup()
    end
		imgui.Separator()
		imgui.End()
  end
  --------================---------
  -- Эта ужассссссс
  if window['addtable'].v then
    imgui.SetNextWindowSize(imgui.ImVec2(350, 200), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin(u8'SFAHelper | Добавить данные в таблицу', window['addtable'], imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize)
    ----------
    imgui.Combo(u8'Выберите тип данных', data.test.googlesender, u8"Не выбрано\0Повышение\0Увольнение\0Контракт\0Выговор\0\0")
    imgui.Separator()
    if data.test.googlesender.v > 0 then
      imgui.InputText(u8 'Введите ID/ник игрока', data.test.nick)
    end
    if data.test.googlesender.v == 1 then
      imgui.InputText(u8 'С какого ранга', data.test.param1)
      imgui.InputText(u8 'На какой ранг', data.test.param2)
      imgui.InputText(u8 'Причина', data.test.reason)
    elseif data.test.googlesender.v == 2 then
      imgui.InputText(u8 'Причина', data.test.reason)
    elseif data.test.googlesender.v == 3 then
      imgui.InputText(u8 'Тип КС (1,2)', data.test.param2)
      imgui.InputText(u8 'Взвод', data.test.reason)
    elseif data.test.googlesender.v == 4 then
      imgui.InputText(u8 'Тип выговора (1 - обычный, 2 - строгий)', data.test.param2)
      imgui.InputText(u8 'Причина', data.test.reason)
      imgui.InputText(u8 'Приговор', data.test.param1)
    end
    if data.test.googlesender.v > 0 then
      if imgui.Button(u8'Отправить') then
        local nickname = u8:decode(data.test.nick.v)
        local param1 = u8:decode(data.test.param1.v)
        local param2 = u8:decode(data.test.param2.v)
        local reason = u8:decode(data.test.reason.v)
        local pid = tonumber(nickname)
        if sInfo.playerid ~= pid and sInfo.nick ~= nickname then
          if pid ~= nil then
            if sampIsPlayerConnected(pid) then nickname = sampGetPlayerNickname(pid) end
          end
          if tonumber(nickname) == nil then
            if data.test.googlesender.v == 1 then
              if nickname ~= "" and param1 ~= "" and param2 ~= "" and reason ~= "" then
                if tonumber(param1) ~= nil and tonumber(param1) >= 1 and tonumber(param1) < 15 and tonumber(param2) ~= nil and tonumber(param2) >= 1 and tonumber(param2) < 15 then
                  atext(("Повышение: [Ник: %s] [С ранга: %s] [На ранг: %s] [Причина: %s]"):format(nickname, param1, param2, reason))
                  sendGoogleMessage("giverank", nickname, param1, param2, reason, os.time())
                  funcc('imgui_sendgoogle_giverank', 1)
                else atext('Неверные параметры ранга!') end
              else atext('Все поля должны быть заполнены!') end
            elseif data.test.googlesender.v == 2 then
              if nickname ~= "" and reason ~= "" and nickname ~= nil and reason ~= nil then
                atext(("Увольнение: [Ник: %s] [Причина: %s]"):format(nickname, reason))
                sendGoogleMessage("uninvite", nickname, _, _, reason, os.time())
                funcc('imgui_sendgoogle_uninvite', 1)
              else atext('Все поля должны быть заполнены!') end
            elseif data.test.googlesender.v == 3 then
              if nickname ~= "" and nickname ~= nil and reason ~= nil and reason ~= "" and param2 ~= "" and param2 ~= nil then
                if tonumber(param2) ~= nil and (tonumber(param2) == 1 or tonumber(param2) == 2) then
                  atext(("Контракт: [Ник: %s] [Тип КС: %s] [Взвод: %s]"):format(nickname, param2, reason))
                  sendGoogleMessage("contract", nickname, _, param2, reason, os.time())
                  funcc('imgui_sendgoogle_contract', 1)
                else atext('Неверный тип КС') end
              else atext('Все поля должны быть заполнены!') end
            elseif data.test.googlesender.v == 4 then
              if nickname ~= "" and param1 ~= "" and param2 ~= "" and param2 ~= nil and reason ~= "" and nickname ~= nil and param1 ~= nil and reason ~= nil then
                if tonumber(param2) ~= nil and (tonumber(param2) == 1 or tonumber(param2) == 2) then
                  atext(("Выговор: [Ник: %s] [Тип: %s] [Приговор: %s] [Причина: %s]"):format(nickname, param2, param1, reason))
                  sendGoogleMessage("reprimand", nickname, param1, param2, reason, os.time())
                  funcc('imgui_sendgoogle_reprimand', 1)
                else atext('Неверный тип выговора') end
              else atext('Все поля должны быть заполнены!') end
            end
          else atext('Неверный ID игрока!') end
        else atext('Вы не можете внести себя в таблицу!') end
      end
    end
    imgui.End()
  end
  --------================---------
  if window['abp'].v then
    imgui.SetNextWindowSize(imgui.ImVec2(100, 150), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin(u8'SFA-Helper | Авто-БП', window['abp'], imgui.WindowFlags.AlwaysAutoResize)
    -------
    --funcc('cmd_abp', 1)
    local autobp = imgui.ImBool(pInfo.settings.autobp)
    if pInfo.settings.autobpguns == nil then pInfo.settings.autobpguns = {2,2,0,2,2,1,0} end
    if imgui.ToggleButton(u8 'autobp##1', autobp) then
      pInfo.settings.autobp = autobp.v
      filesystem.save(pInfo, 'config.json')
    end
    imgui.SameLine(); imgui.Text(u8 'Включить автоматическое взятие БП')
    imgui.Spacing(); imgui.Separator(); imgui.Spacing()
    -------
    local autolist = {"Desert Eagle", "Shotgun", "MP5", "M4A1", "Rifle", "Броня", "Спец оружие"}
    for i = 1, #pInfo.settings.autobpguns do
      if pInfo.settings.autobpguns[i] == nil then pInfo.settings.autobpguns[i] = 0 end
      local interval = imgui.ImInt(pInfo.settings.autobpguns[i])
      imgui.Text(u8:encode(autolist[i]))
      imgui.SameLine()
      imgui.SetCursorPosX(120)
      imgui.PushItemWidth(125)
      if imgui.InputInt('##counter'..i, interval, 1) then
        if interval.v < 0 then interval.v = 0 end
        if interval.v > 2 then interval.v = 2 end
        pInfo.settings.autobpguns[i] = interval.v
        filesystem.save(pInfo, 'config.json')
      end
      imgui.PopItemWidth()
    end
    imgui.End()
  end
  --------================---------
  if window['shpora'].v then
    if data.imgui.shpora ~= 0 then
      if data.imgui.shpora < 0 then
        -- Первая загрузка шпоры, ищём файлы в директории, записываем в таблицу
        -- findFirstFile имеет баг, если ни одного файла не будет найдено, произойдет краш скрипта.
        data.imgui.selectshpora = {}
        data.imgui.shpora = data.imgui.shpora * -1
        local handle, name = findFirstFile("moonloader/SFAHelper/shpora/*.txt")
        if name ~= nil then
          table.insert(data.imgui.selectshpora, name)
          while true do
            name = findNextFile(handle)
            if name == nil then break end
            table.insert(data.imgui.selectshpora, name)
          end
          findClose(handle)
        end
      end
      -- Изменился пункт меню, загружаем шпору из уже загруженного списка файлов
      data.filename = 'moonloader/SFAHelper/shpora/'..data.imgui.selectshpora[data.imgui.shpora]
      ----------
      data.imgui.shporatext = {}
      for line in io.lines(data.filename) do
        table.insert(data.imgui.shporatext, line)
      end
      data.imgui.shpora = 0
      data.imgui.shporareason.v = ""
    end
    imgui.SetNextWindowSize(imgui.ImVec2(screenx-400, screeny-250), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin(u8'SFA-Helper | Шпаргалка', window['shpora'], imgui.WindowFlags.MenuBar + imgui.WindowFlags.HorizontalScrollbar)
    if imgui.BeginMenuBar(u8 'sfahelper') then
      for i = 1, #data.imgui.selectshpora do
        -- Выводим назваия файлов в пункты меню, удаляем .txt из названия
        if imgui.MenuItem(u8:encode(data.imgui.selectshpora[i]:match("(.+)%.txt"))) then data.imgui.shpora = i end
      end
      imgui.EndMenuBar()
    end
    ---------
    imgui.PushItemWidth(100)
    imgui.InputText(u8 'Поиск по тексту', data.imgui.shporareason)
    imgui.Separator()
    imgui.NewLine()
    -- Выводим шпаргалку
    for k, v in pairs(data.imgui.shporatext) do
      -- Фильтрация по поиску
      if u8:decode(data.imgui.shporareason.v) == "" or string.find(rusUpper(v), rusUpper(u8:decode(data.imgui.shporareason.v))) ~= nil then
        imgui.Text(u8(v))
      end
    end
    imgui.End()
  end
  if window['binder'].v then
    imgui.LockPlayer = true
    imgui.DisableInput = false
    imgui.SetNextWindowSize(imgui.ImVec2(screenx / 1.5, 625), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowPos(imgui.ImVec2(screenx / 2, screeny / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin(u8'SFA-Helper | Биндер', window['binder'], imgui.WindowFlags.MenuBar + imgui.WindowFlags.HorizontalScrollbar)
    imgui.PushItemWidth(500)
    ----------------------
    if imgui.BeginMenuBar(u8 'binder') then
      if imgui.MenuItem(u8 'Клавишный биндер') then data.imgui.bind = 1 end
      if imgui.MenuItem(u8 'Командный биндер') then data.imgui.bind = 2 end
      if imgui.MenuItem(u8 'Сохранить изменения') then
        funcc('imgui_binder_save', 1)
        if data.imgui.bind == 1 then
          local replacedValues = {}
          for k, v in ipairs(config_keys.binder) do
            local newValues = {}
            if v.v ~= 0 then -- edit
              for i = 1, #v.text do
                if v.text[i] ~= "" and v.text[i] ~= nil then
                  newValues[#newValues + 1] = v.text[i]
                end
              end
            end
            if #newValues > 0 then
              replacedValues[#replacedValues + 1] = { v = v.v, time = v.time and v.time or 1100, text = newValues }
            end
          end
          tEditData = {}
          config_keys.binder = replacedValues
        end
        if data.imgui.bind == 2 then
          local replacedValues = {}
          for k, v in ipairs(config_keys.cmd_binder) do
            if sampIsChatCommandDefined(v.cmd) then sampUnregisterChatCommand(v.cmd) end
            local newValues = {}
            if v.cmd ~= "" then
              for i = 1, #v.text do
                if v.text[i] ~= "" and v.text ~= nil then
                  newValues[#newValues + 1] = v.text[i]
                end
              end
            end
            if #newValues > 0 then
              replacedValues[#replacedValues + 1] = { cmd = v.cmd, wait = v.wait and v.wait or 1100, text = newValues }
            end
          end
          sCmdEdit = {}
          config_keys.cmd_binder = replacedValues
          registerFastCmd()
        end
        atext('Биндер успешно изменен!')
        filesystem.save(config_keys, 'keys.json')
      end
      imgui.EndMenuBar()
    end
    ----------------------
    local str = ""
    str = str.."{mynick} - Ваш ник\n"
    str = str.."{myfullname} - Ваш РП ник\n"
    str = str.."{myname} - Ваше имя\n"
    str = str.."{mysurname} - Ваша фамилия\n"
    str = str.."{myid} - Ваш ID\n"
    str = str.."{myhp} - Ваше здоровье\n"
    str = str.."{myarm} - Ваша броня\n"
    str = str.."{myrank} - Ваш ранг (числовой)\n"
    str = str.."{myrankname} - Ваше звание (текст)\n-------------------------\n"
    str = str.."{kvadrat} - Ваш текущий квадрат\n"
    str = str.."{tag} - Ваш тэг\n"
    str = str.."{frac} - Ваша фракция\n"
    str = str.."{city} - Текущий город\n"
    str = str.."{zone} - Текущая локация\n"
    str = str.."{time} - Текущее время\n"
    str = str.."{date} - Текущая дата в формате DD.MM.YYYY\n"
    str = str.."{weaponid} - ID оружия в руках\n"
    str = str.."{weaponname} - Название оружия в руках\n"
    str = str.."{ammo} - Количество патронов в оружие\n-------------------------\n"
    str = str.."Последний игрок, выделенный через таргет:\n"
    str = str.."{tID} - ID игрока\n"
    str = str.."{tnick} - Ник игрока\n"
    str = str.."{tfullname} - РП ник игрока\n"
    str = str.."{tname} - Имя игрока\n"
    str = str.."{tsurname} - Фамилия игрока\n-------------------------\n"
    str = str.."Игрок, выбранный через \"/match\":\n"
    str = str.."{mID} - ID игрока\n"
    str = str.."{mnick} - Иик игрока\n"
    str = str.."{mfullname} - РП ник игрока\n"
    str = str.."{mname} - Имя игрока\n"
    str = str.."{msurname} - Фамилия игрока\n"
    ----------------------
    if data.imgui.bind == 1 then
      imgui.Text(u8'После изменения названия команды необходимо нажать "Сохранить изменения", иначе команда не зарегистрируется в системе.')
      imgui.Text(u8'Вы можете придумать любую команду на свой вкус и для ваших потребностей с помощью специальных "вставок".')
      imgui.Text(u8'Чтобы удалить строку, просто оставьте её пустой и нажмите "Сохранить изменения". Система сама удалить все лишнее.')
      imgui.Spacing(); imgui.Separator(); imgui.Spacing()
      imgui.Columns(2)
      -------------------
      for k, v in ipairs(config_keys.binder) do
        if tEditData[k] == nil then
          tEditData[k] = {}
          tEditData[k].text = {}
          tEditData[k].isEnter = {}
        end
        local btimeb = imgui.ImInt(v.time)
        if imgui.HotKey("##HK" .. k, v, tLastKeys, 75) then
          if not rkeys.isHotKeyDefined(v.v) then
            if rkeys.isHotKeyDefined(tLastKeys.v) then
              rkeys.unRegisterHotKey(tLastKeys.v)
            end
            rkeys.registerHotKey(v.v, true, onHotKey)
          end
          filesystem.save(config_keys, 'keys.json')
        end
        imgui.SameLine(100)
        imgui.Text(u8'Задержка')
        imgui.SameLine()
        imgui.PushItemWidth(50)
        if imgui.InputInt(u8'##time'..k, btimeb, 0) then v.time = btimeb.v end
        imgui.PopItemWidth()
        imgui.SameLine()
        if imgui.Button(u8'Добавить строку##addstr'..k) then
          v.text[#v.text + 1] = ""
        end
        --------
        for i = 1, #v.text do
          if v.text[i] ~= nil then
            if tEditData[k].text[i] == nil then
              tEditData[k].text[i] = imgui.ImBuffer(256)
              local sText = v.text[i]:gsub("%[enter%]$", "")
              tEditData[k].text[i].v = u8:encode(sText)
              tEditData[k].isEnter[i] = imgui.ImBool(false)
              tEditData[k].isEnter[i].v = string.match(v.text[i], "(.)%[enter%]$") ~= nil
            end
            imgui.PushItemWidth(imgui.GetWindowSize().x - 390)
            if imgui.InputText("##Edit"..k..i, tEditData[k].text[i]) then
              v.text[i] = u8:decode(tEditData[k].text[i].v .. (tEditData[k].isEnter[i].v and "[enter]" or ""))
              tEditData[k].text[i] = nil
            end
            imgui.SameLine()
            if imgui.Checkbox(u8("Ввод").."##editCH"..k..i, tEditData[k].isEnter[i]) then
              v.text[i] = u8:decode(tEditData[k].text[i].v .. (tEditData[k].isEnter[i].v and "[enter]" or ""))
            end
            imgui.PopItemWidth()
          end
        end
        imgui.NewLine()
      end
      if imgui.Button(u8"Добавить бинд") then
        config_keys.binder[#config_keys.binder + 1] = {text = {""}, v = {}, time = 0}
      end
      imgui.NextColumn()
      imgui.SetColumnOffset(-1, imgui.GetWindowSize().x - 300)
      imgui.Text(u8:encode("Список специальных вставок:\n"..str))
      imgui.NextColumn()

    elseif data.imgui.bind == 2 then
      str = [[{param} - Первый аргумент в команде
{pNickByID} - Ник по ID в параметре
{pFullNameByID} - РП ник по ID в параметре
{pNameByID} - Имя по ID в параметре
{pSurnameByID} - Фамилия по ID в параметре
{param2} - Второй аргумент
{param3} - Третий аргумент
-------------------------]].."\n"..str
      imgui.Text(u8'После изменения названия команды необходимо нажать "Сохранить изменения", иначе команда не зарегистрируется в системе.')
      imgui.Text(u8'Вы можете придумать любую команду на свой вкус и для ваших потребностей с помощью специальных "вставок".')
      imgui.Text(u8'Чтобы удалить команду или строку, просто оставьте её пустой и нажмите "Сохранить изменения". Система сама удалить все лишнее.')
      imgui.Spacing(); imgui.Separator(); imgui.Spacing()
      imgui.Columns(2)
      -------------------
      for k, v in ipairs(config_keys.cmd_binder) do
        local btimeb = imgui.ImInt(1100) 
        if v.wait ~= nil then btimeb.v = v.wait end
        imgui.PushItemWidth(100)
        if sCmdEdit[k] == nil then
          sCmdEdit[k] = {}
          sCmdEdit[k].cmd = imgui.ImBuffer(256)
          sCmdEdit[k].cmd.v = v.cmd
          sCmdEdit[k].text = {}
          sCmdEdit[k].delete = {}
        end
        if imgui.InputText("##CMD" .. k, sCmdEdit[k].cmd) then
          sCmdEdit[k].cmd.v = sCmdEdit[k].cmd.v:gsub("/", "")
          if sampIsChatCommandDefined(v.cmd) then sampUnregisterChatCommand(v.cmd) end
          v.cmd = sCmdEdit[k].cmd.v
        end
        imgui.SameLine(125)
        imgui.Text(u8'Задержка')
        imgui.SameLine()
        imgui.PushItemWidth(50)
        if imgui.InputInt(u8'##wait'..k, btimeb, 0) then v.wait = btimeb.v end
        imgui.PopItemWidth()
        imgui.SameLine()
        if imgui.Button(u8'Добавить строку##addstr'..k) then
          v.text[#v.text + 1] = ""
        end
        for i = 1, #v.text do
          if v.text[i] ~= nil then
            if sCmdEdit[k].text[i] == nil then
              sCmdEdit[k].text[i] = imgui.ImBuffer(256)
              sCmdEdit[k].text[i].v = u8:encode(v.text[i])
            end
            imgui.PushItemWidth(imgui.GetWindowSize().x - 320)
            if imgui.InputText("##Edit"..k..i, sCmdEdit[k].text[i]) then
              v.text[i] = u8:decode(sCmdEdit[k].text[i].v)
            end
            imgui.PopItemWidth()
          end
        end
        imgui.NewLine()
      end
      if imgui.Button(u8"Добавить команду") then
        config_keys.cmd_binder[#config_keys.cmd_binder + 1] = { cmd = "", text = { "" } }
      end
      imgui.NextColumn()
      imgui.SetColumnOffset(-1, imgui.GetWindowSize().x - 300)
      imgui.Text(u8:encode("Список специальных вставок:\n"..str))
      imgui.NextColumn()
    end
    imgui.End()     
  end
  if window['punishlog'].v then
    imgui.SetNextWindowSize(imgui.ImVec2(750, 400), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowPos(imgui.ImVec2(screenx / 2, screeny / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin(u8'SFA-Helper | Лог наказаний', window['punishlog'], imgui.WindowFlags.HorizontalScrollbar)
    for i = #data.punishlog, 1, -1 do
      imgui.Text(u8:encode(("%s | Выдал: %s (%s)"):format(data.punishlog[i].time, data.punishlog[i].from, data.punishlog[i].rank)))
      imgui.Text(u8:encode("Текст: "..data.punishlog[i].text))
      imgui.NewLine()
    end
    imgui.End() 
  end
  if window['hud'].v then
    local myping = sampGetPlayerPing(sInfo.playerid)
    local myweapon = getCurrentCharWeapon(PLAYER_PED)
    local myweaponammo = getAmmoInCharWeapon(PLAYER_PED, myweapon)
    local myweaponname = getweaponname(myweapon)
    imgui.SetNextWindowPos(imgui.ImVec2(pInfo.settings.hudX, pInfo.settings.hudY), imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(320, 170), imgui.Cond.FirstUseEver)
    imgui.Begin('SFA-Helper', window['hud'], imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoMove)
    -- Центрируем надпись
    imgui.SetCursorPosX((300 - imgui.CalcTextSize(u8('SFA-Helper')).x) / 2)
    imgui.Text('SFA-Helper')
    imgui.Separator()
    imgui.Text(u8:encode(("Ник: %s[%d] | Пинг: %d"):format(sInfo.nick, sInfo.playerid, myping)))
    imgui.Text(u8:encode(("Оружие: %s [%d]"):format(myweaponname, myweaponammo)))
    if isCharInAnyCar(playerPed) then
      local vHandle = storeCarCharIsInNoSave(playerPed)
      local result, vID = sampGetVehicleIdByCarHandle(vHandle)
      local vHP = getCarHealth(vHandle)
      local carspeed = getCarSpeed(vHandle)
      local speed = math.floor(carspeed) * 2
      local vehName = getGxtText(getNameOfVehicleModel(getCarModel(vHandle)))
      imgui.Text(u8:encode(("Авто: %s[%d] | ХП: %s | Скорость: %s"):format(vehName, vID, vHP, speed)))
    else
      imgui.Text(u8'Авто: Нет')
    end
    imgui.Text(u8:encode(('Локация: %s | %s'):format(playerZone, sInfo.interior > 0 and "Интерьер: "..sInfo.interior or "Квадрат: "..kvadrat())))
    imgui.Text(u8'Текущее время: '..os.date('%H:%M:%S'))
    if pInfo.settings.target == true then
      imgui.TextColoredRGB('Таргет-бар: {228B22}Включен')
    else
      imgui.TextColoredRGB('Таргет-бар: Выключен')
    end
    if post.active == true then
      imgui.TextColoredRGB('Автодоклад: {228B22}Включен')
    end
    imgui.End()
    if imgui.IsMouseClicked(0) and data.imgui.hudpos then
      data.imgui.hudpos = false
      sampToggleCursor(false)
      window['main'].v = true
      if not pInfo.settings.hud then window['hud'].v = false end
      filesystem.save(pInfo, 'config.json')
    end
  end
end



------------------------ SECONDARY FUNCTIONS ------------------------
-- Клавишный биндер
function onHotKey(id, keys)
  lua_thread.create(function()
    local sKeys = tostring(table.concat(keys, " "))
    for k, v in pairs(config_keys.binder) do
      if sKeys == tostring(table.concat(v.v, " ")) then
        funcc('sendkeybinder', 1)
        for i = 1, #v.text do
          if tostring(v.text[i]):len() > 0 then
            -- Если найдена строчка с биндером, отправляем в чат
            local bIsEnter = string.match(v.text[i], "(.)%[enter%]$") ~= nil
            if bIsEnter then
              local textTag = tags(v.text[i]:gsub("%[enter%]$", ""), nil)
              if textTag:len() > 0 then
                sampSendChat(textTag)
              end
            else
              -- Строчка не найдена, просто помещаем текст в input.
              local textTag = tags(v.text[i], nil)
              if textTag:len() > 0 then
                sampSetChatInputText(textTag)
                sampSetChatInputEnabled(true)
              end
            end
            wait(v.time)
          end
        end
      end
    end
  end)
end

function drawMembersPlayer(table)
	-- ID  Nick  Rank  Status  AFK  Dist
	local nickname = sampGetPlayerNickname(table.mid)
	local color = sampGetPlayerColor(table.mid)
	local r, g, b = bitex.bextract(color, 16, 8), bitex.bextract(color, 8, 8), bitex.bextract(color, 0, 8)
	local imgui_RGBA = imgui.ImVec4(r / 255.0, g / 255.0, b / 255.0, 1)
	local _, ped = sampGetCharHandleBySampPlayerId(table.mid)
	local distance = "Нет"
	if doesCharExist(ped) then
	  local mx, my, mz = getCharCoordinates(PLAYER_PED)
	  local cx, cy, xz = getCharCoordinates(ped)
	  distance = ("%0.2f"):format(getDistanceBetweenCoords3d(mx, my, mz,cx, cy, xz))
	end
	imgui.Text(tostring(table.mid)); imgui.NextColumn()
  imgui.TextColored(imgui_RGBA, nickname)
  if imgui.IsItemClicked(1) then
    selectedContext = table.mid
    imgui.OpenPopup("ContextMenu")
  end
  imgui.NextColumn()
	imgui.Text(u8:encode(("%s[%d]"):format(rankings[table.mrank], table.mrank))); imgui.NextColumn()
	imgui.Text(u8:encode(table.mstatus and "На работе" or "Выходной")); imgui.NextColumn()
	imgui.Text(u8:encode(table.mafk ~= nil and table.mafk.." секунд" or "")); imgui.NextColumn()
	imgui.Text(u8:encode(distance)); imgui.NextColumn()
end

function sendGoogleMessage(type, name, param1, param2, reason, time)
  local mynick = sInfo.nick
  local date = os.date("*t", time)
  date = ("%d.%d.%d %d:%d:%d"):format(date.day, date.month, date.year, date.hour, date.min, date.sec)
  -- Формируем ссылки
  local url = "?executor="..mynick
  if type == "giverank" then
    url = url..("&type=%s&who=%s&param1=%s&param2=%s&reason=%s&date=%s"):format(type, name, encodeURI(u8:encode(param1)), encodeURI(u8:encode(param2)), encodeURI(u8:encode(reason)), date)
  elseif type == "uninvite" then
    url = url..("&type=%s&who=%s&reason=%s&param1=1&param2=1&date=%s"):format(type, name, encodeURI(u8:encode(reason)), date)
  elseif type == "contract" then
    local date1 = os.date("*t", time)
    local date2 = os.date("*t", time+(604800*tonumber(param2)))
    date = ("%d.%d.%d - %d.%d.%d"):format(date1.day, date1.month, date1.year, date2.day, date2.month, date2.year)
    if tonumber(param2) == 2 then param1 = 4
    else param1 = 3 end
    url = url..("&type=%s&who=%s&param1=%s&date=%s&reason=%s&param2=1"):format(type, name, encodeURI(u8:encode(param1)), date, encodeURI(u8:encode(reason)))
  elseif type == "reprimand" then
    local date1 = os.date("*t", time)
    local date2 = os.date("*t", time+(604800*tonumber(param2)))
    date = ("%d.%d.%d - %d.%d.%d"):format(date1.day, date1.month, date1.year, date2.day, date2.month, date2.year)
    url = url..("&type=%s&who=%s&reason=%s&date=%s&param1=%s&param2=1"):format(type, name, encodeURI(u8:encode(reason)), date, encodeURI(u8:encode(param1)))
  elseif type == "blacklist" then
    url = url..("&type=%s&who=%s&reason=%s&date=%s&param1=%s&param2=%s"):format(type, name, encodeURI(u8:encode(reason)), date, encodeURI(u8:encode(param1)), encodeURI(u8:encode(param2)))
  else return end
  logger.trace("Исходящий запрос к Google Script")
  local complete = false
  lua_thread.create(function()
    local dlstatus = require('moonloader').download_status
    local downloadpath = getWorkingDirectory() .. '\\SFAHelper\\urlRequests.json'
    wait(50)
    -- Google Script отклоняет запросы через requests.
    downloadUrlToFile("https://script.google.com/macros/s/AKfycbzTl1YbtWus6nvrHP3RNAO72QfxIJC17AFNF1BlEidr_XKoMjc/exec"..url, downloadpath, function(id, status, p1, p2) -- remove
      if status == dlstatus.STATUS_ENDDOWNLOADDATA then
        logger.trace("Скачан файл '"..downloadpath.."'")
        complete = true
      end
    end)
    while complete ~= true do wait(50) end
    logger.trace("Обработка ответа...")
    local file = io.open("moonloader/SFAHelper/urlRequests.json", "r+")
    if file == nil then logger.trace("Ответ не был получен") return end
    local cfg = file:read('*a')
    if cfg ~= nil then 
      logger.trace("Входящий запрос от Google Script. Содержимое: "..cfg)
    else logger.trace("Входящий запрос от Google Script. Содержимое: Неверный формат объекта") end
    file:close()
    wait(50)
    logger.trace("Удаляем файл '"..downloadpath.."'")
    os.remove(downloadpath)
    return
  end)
end

function downloadFile(link, filename)
  lua_thread.create(function()
    local dlstatus = require('moonloader').download_status
    wait(250)
    logger.trace("Скачиваем файл '"..filename.."'")
    downloadUrlToFile(link, filename)
    return
  end)
end

-- Регистрируем командный биндер
function registerFastCmd()
  for key, value in pairs(config_keys.cmd_binder) do
    if value.cmd and #value.text > 0 then
      if not sampIsChatCommandDefined(value.cmd) then
        sampRegisterChatCommand(value.cmd, function(pam)
          lua_thread.create(function()
            -- Делаем невозможным выполнение команды без установленного тэгами кол-ва параметров
            for i = 1, #value.text do
              if value.text[i] ~= nil and #value.text[i] > 0 then
                local text = value.text[i]
                local params = 0
                if text:find("{param}") or text:find("{pNickByID}") or text:find("{pFullNameByID}") or text:find("{pNameByID}") or text:find("{pSurnameByID}") then params = params + 1 end
                if text:find("{param2}") then params = params + 1 end
                if text:find("{param3}") then params = params + 1 end
                if params > 0 then
                  local args = string.split(pam, " ", params)
                  if #args < params then
                    atext(('Введите: /%s %s %s %s'):format(value.cmd, params > 0 and "[param]" or "", params > 1 and "[param2]" or "", params > 2 and "[param3]" or ""))
                    return
                  end
                end
                funcc('sendcmdbinder', 1)
                local textTag = tags(text, pam)
                if textTag:len() > 0 then
                  sampSendChat(textTag)
                end
                if value.wait then wait(value.wait)
                else wait(1100) end
              end
            end
          end)
        end)
      else
        logger.info("Команда-бинд \""..value.cmd.."\" уже существует. Перезапись невозможна")
      end     
    end
  end
end

-- Счётчик действий
function addcounter(id, count)
  id = tonumber(id)
  count = tonumber(count)
  if id == nil or count == nil then return end
  if pInfo.counter[id] == nil then
    pInfo.counter[id] = count
  else
    pInfo.counter[id] = pInfo.counter[id] + count
  end
end

function dtext(text)
  if DEBUG_MODE == false then return end
  text = tostring(text)
  sampAddChatMessage("DEBUG: "..text, 0xFFFF00)
end

function atext(text)
  text = tostring(text)
  sampAddChatMessage(" SFA-Helper | {FFFFFF}"..text, 0x954F4F)
end

-- Отключаем срабатывание хоткея при открытом чате/диалоге/консоле.
function rkeys.onHotKey(id, keys)
  if sampIsChatInputActive() or sampIsDialogActive() or isSampfuncsConsoleActive() then
      return false
  end
end

function timeScreen() 
  lua_thread.create(function()
    wait(2000)
    sampSendChat("/time")
    wait(300)
    screen()
    return
  end)
end

-- Определение названия цвета по HEX коду
function getcolorname(color)
  local colorlist = {
    { name = "Выключен", color = "FFFFFE"}, -- 0
    { name = "Зелёный", color = "089401"}, -- 1
    { name = "Светло зелёный", color = "56FB4E"}, -- 2
    { name = "Ярко зелёный", color = "49E789"}, -- 3
    { name = "Бирюзовый", color = "2A9170"}, -- 4
    { name = "Жёлто-зеленый", color = "9ED201"}, -- 5
    { name = "Тёмно-зеленый", color = "279B1E"}, -- 6
    { name = "Сыро-зелёный", color = "51964D"}, -- 7
    { name = "Красный", color = "FF0606"}, -- 8
    { name = "Ярко-красный", color = "FF6600"}, -- 9
    { name = "Оранжевый", color = "F45000"}, -- 10
    { name = "Коричневый", color = "BE8A01"}, -- 11
    { name = "Тёмно-красный", color = "B30000"}, -- 12
    { name = "Серо-красный", color = "954F4F"}, -- 13
    { name = "Жёлто-оранжевый", color = "E7961D"}, -- 14
    { name = "Малиновый", color = "E6284E"}, -- 15
    { name = "Розовый", color = "FF9DB6"}, -- 16
    { name = "Синий", color = "110CE7"}, -- 17
    { name = "Голубой", color = "0CD7E7"}, -- 18
    { name = "Синяя сталь", color = "139BEC"}, -- 19
    { name = "Сине-зелёный", color = "2C9197"}, -- 20
    { name = "Тёмно-синий", color = "114D71"}, -- 21
    { name = "Фиолетовый", color = "8813E7"}, -- 22
    { name = "Индиго", color = "B313E7"}, -- 23
    { name = "Серо-синий", color = "758C9D"}, -- 24
    { name = "Жёлтый", color = "FFDE24"}, -- 25
    { name = "Кукурузный", color = "FFEE8A"}, -- 26
    { name = "Золотой", color = "DDB201"}, -- 27
    { name = "Старое золото", color = "DDA701"}, -- 28
    { name = "Оливковый", color = "B0B000"}, -- 29
    { name = "Серый", color = "868484"}, -- 30
    { name = "Серебро", color = "B8B6B6"}, -- 31
    { name = "Чёрный", color = "333333"}, -- 32
    { name = "Белый", color = "FAFAFA"}, -- 33
  }
  for i = 1, #colorlist do
    if color == colorlist[i].color then
      local cid = i - 1 -- Цвета начинаются с 0, а массив с 1
      return string.format('{'..color..'}'..colorlist[i].name..'['..cid..']{FFFFFF}')
    end
  end
  return string.format('{%s}[|||]{FFFFFF}', color)
end


function patch_samp_time_set(enable)
  if enable and default == nil then
    default = readMemory(sampGetBase() + 0x9C0A0, 4, true)
    writeMemory(sampGetBase() + 0x9C0A0, 4, 0x000008C2, true)
  elseif enable == false and default ~= nil then
    writeMemory(sampGetBase() + 0x9C0A0, 4, default, true)
    default = nil
  end
end

-- Тэги для биндера
function tags(args, param)
  if param ~= nil then
    if args:match("{param3}") then
      param = string.split(param, " ", 3)
    elseif args:match("{param2}") then
      param = string.split(param, " ", 2)
    end
    args = args:gsub("{param}", tostring(type(param) == "table" and param[1] or param))
    args = args:gsub("{param2}", tostring(param[2]))
    args = args:gsub("{param3}", tostring(param[3]))
    args = args:gsub("{pNickByID}", tostring(sampGetPlayerNickname(type(param) == "table" and param[1] or param)))
    args = args:gsub("{pFullNameByID}", tostring(sampGetPlayerNickname(type(param) == "table" and param[1] or param):gsub("_", " ")))
    args = args:gsub("{pNameByID}", tostring(sampGetPlayerNickname(type(param) == "table" and param[1] or param):gsub("_.*", "")))
    args = args:gsub("{pSurnameByID}", tostring(sampGetPlayerNickname(type(param) == "table" and param[1] or param):gsub(".*_", "")))
  end
  ----------
  args = args:gsub("{mynick}", tostring(sInfo.nick))
  args = args:gsub("{myfullname}", tostring(sInfo.nick:gsub("_", " ")))
	args = args:gsub("{myname}", tostring(sInfo.nick:gsub("_.*", "")))
	args = args:gsub("{mysurname}", tostring(sInfo.nick:gsub(".*_", "")))
	args = args:gsub("{myid}", tostring(sInfo.playerid))
	args = args:gsub("{myhp}", tostring(getCharHealth(PLAYER_PED)))
  args = args:gsub("{myrank}", tostring(pInfo.settings.rank))
  args = args:gsub("{myrankname}", tostring(rankings[pInfo.settings.rank]))
  args = args:gsub("{myarm}", tostring(getCharArmour(PLAYER_PED)))
  ----------
  args = args:gsub("{kvadrat}", tostring(kvadrat()))
  args = args:gsub("{tag}", tostring(pInfo.settings.tag))
  args = args:gsub("{frac}", tostring(sInfo.fraction))
  args = args:gsub("{city}", tostring(playerCity))
  args = args:gsub("{zone}", tostring(playerZone))
  args = args:gsub("{time}", string.format(os.date('%H:%M:%S')))
  ----------
  -- Update 1.39
  args = args:gsub("{date}", string.format(os.date('%d.%m.%Y')))
  args = args:gsub("{weaponid}", tostring(getCurrentCharWeapon(PLAYER_PED)))
  args = args:gsub("{weaponname}", tostring(getweaponname(getCurrentCharWeapon(PLAYER_PED))))
  args = args:gsub("{ammo}", tostring(getAmmoInCharWeapon(PLAYER_PED, getCurrentCharWeapon(PLAYER_PED))))
  ----------
  if targetID ~= nil and sampIsPlayerConnected(targetID) then
    args = args:gsub("{tID}", tostring(targetID))
		args = args:gsub("{tfullname}", tostring(sampGetPlayerNickname(targetID):gsub("_", " ")))
		args = args:gsub("{tname}", tostring(sampGetPlayerNickname(targetID):gsub("_.*", "")))
		args = args:gsub("{tsurname}", tostring(sampGetPlayerNickname(targetID):gsub(".*_", "")))
		args = args:gsub("{tnick}", tostring(sampGetPlayerNickname(targetID)))
  end
  if playerMarkerId ~= nil and sampIsPlayerConnected(playerMarkerId) then
    args = args:gsub("{mID}", tostring(playerMarkerId))
		args = args:gsub("{mfullname}", tostring(sampGetPlayerNickname(playerMarkerId):gsub("_", " ")))
		args = args:gsub("{mname}", tostring(sampGetPlayerNickname(playerMarkerId):gsub("_.*", "")))
		args = args:gsub("{msurname}", tostring(sampGetPlayerNickname(playerMarkerId):gsub(".*_", "")))
		args = args:gsub("{mnick}", tostring(sampGetPlayerNickname(playerMarkerId)))    
  end
  ----------
  --[[local patt = 0
  while true do
    local found = args:find('$.-{.-}', patt)
    if found then
      local functions = {
        ["screen"] = screen,
        ['timeScreen'] = timeScreen,
        ['target'] = targetPlayer,
        ['loc'] = cmd_loc,
        ['punishlog'] = cmd_punishlog,
        ['stime'] = cmd_stime,
        ['sweather'] = cmd_sweather,
        ['ev'] = cmd_ev,
        ['checkbl'] = cmd_checkbl,
        ['checkrank'] = cmd_checkrank,
        ['watch'] = cmd_watch,
        ['blag'] = cmd_blag,
        ['contract'] = cmd_contract,
        ['vig'] = cmd_vig,
        ['lecture'] = cmd_lecture,
        ['addbl'] = cmd_addbl,
        ['match'] = cmd_match,
      }
      local cmd, arg = args:match('$(.-){(.-)}', patt)
      for k, v in pairs(functions) do
        if cmd == k then
          v(arg)
        end
      end
      patt = found + 1
    else break end
  end
  -----
  patt = 0
  while true do
    local found = args:find('#.-{.-}', patt)
    if found then
      local functions = {
        ["upper"] = rusUpper,
        ['lower'] = rusLower,
        ['getFracById'] = sampGetFraktionBySkin,
        ['secToTime'] = _secToTime
      }
      local cmd, arg = args:match('#(.-){(.-)}', patt)
      for k, v in pairs(functions) do
        if cmd == k then
          args = args:gsub('#'..cmd..'{'..arg..'}', v(arg), 1)
        end
      end
      patt = found + 1
    else break end
  end
  args = args:gsub("$.-{.-}", '')]]
  --[[
    #upper{string}
    #lower{string}
    #getFrac{playerid}
    #secToTime{sec}
    ------
    $screen{}
    $timeScreen{}
    $target{id}
    $loc{id/nick, secounds}
    $punishlog{id, nick}
    $stime{0-23}
    $sweather{0-45}
    $ev{0-1, mesta}
    $checkbl{id/nick}
    $checkrank{id/nick}
    $watch{add/remove/list, id}
    $blag{id, frac, type}
    $contract{playerid, rank}
    $vig{playerid, type, reason}
    $lecture{start/pause/stop}
    $addbl{playerid/nick, stepen, dok-va, reason}
    $match{playerid/''}
  ]]
	return args
end

function getZones(zone)
  local names = {
    ["SUNMA"] = "Bayside Marina",
    ["SUNNN"] = "Bayside",
    ["BATTP"] = "Battery Point",
    ["PARA"] = "Paradiso",
    ["CIVI"] = "Santa Flora",
    ["BAYV"] = "Palisades",
    ["CITYS"] = "City Hall",
    ["OCEAF"] = "Ocean Flats",
    ["OCEAF"] = "Ocean Flats",
    ["OCEAF"] = "Ocean Flats",
    ["SILLY"] = "Foster Valley",
    ["SILLY"] = "Foster Valley",
    ["HASH"] = "Hashbury",
    ["JUNIHO"] = "Juniper Hollow",
    ["ESPN"] = "Esplanade North",
    ["ESPN"] = "Esplanade North",
    ["ESPN"] = "Esplanade North",
    ["FINA"] = "Financial",
    ["CALT"] = "Calton Heights",
    ["SFDWT"] = "Downtown",
    ["SFDWT"] = "Downtown",
    ["SFDWT"] = "Downtown",
    ["SFDWT"] = "Downtown",
    ["JUNIHI"] = "Juniper Hill",
    ["CHINA"] = "Chinatown",
    ["SFDWT"] = "Downtown",
    ["THEA"] = "King's",
    ["THEA"] = "King's",
    ["THEA"] = "King's",
    ["GARC"] = "Garcia",
    ["DOH"] = "Doherty",
    ["DOH"] = "Doherty",
    ["SFDWT"] = "Downtown",
    ["SFAIR"] = "Easter Bay Airport",
    ["EASB"] = "Easter Basin",
    ["EASB"] = "Easter Basin",
    ["ESPE"] = "Esplanade East",
    ["ESPE"] = "Esplanade East",
    ["ESPE"] = "Esplanade East",
    ["ANGPI"] = "Angel Pine",
    ["SHACA"] = "Shady Cabin",
    ["BACKO"] = "Back o Beyond",
    ["LEAFY"] = "Leafy Hollow",
    ["FLINTR"] = "Flint Range",
    ["HAUL"] = "Fallen Tree",
    ["FARM"] = "The Farm",
    ["ELQUE"] = "El Quebrados",
    ["ALDEA"] = "Aldea Malvada",
    ["DAM"] = "The Sherman Dam",
    ["BARRA"] = "Las Barrancas",
    ["CARSO"] = "Fort Carson",
    ["QUARY"] = "Hunter Quarry",
    ["OCTAN"] = "Octane Springs",
    ["PALMS"] = "Green Palms",
    ["TOM"] = "Regular Tom",
    ["BRUJA"] = "Las Brujas",
    ["MEAD"] = "Verdant Meadows",
    ["PAYAS"] = "Las Payasadas",
    ["ARCO"] = "Arco del Oeste",
    ["SFAIR"] = "Easter Bay Airport",
    ["HANKY"] = "Hankypanky Point",
    ["PALO"] = "Palomino Creek",
    ["NROCK"] = "North Rock",
    ["MONT"] = "Montgomery",
    ["MONT"] = "Montgomery",
    ["HBARNS"] = "Hampton Barns",
    ["FERN"] = "Fern Ridge",
    ["DILLI"] = "Dillimore",
    ["TOPFA"] = "Hilltop Farm",
    ["BLUEB"] = "Blueberry",
    ["BLUEB"] = "Blueberry",
    ["PANOP"] = "The Panopticon",
    ["FRED"] = "Frederick Bridge",
    ["MAKO"] = "The Mako Span",
    ["BLUAC"] = "Blueberry Acres",
    ["MART"] = "Martin Bridge",
    ["FALLO"] = "Fallow Bridge",
    ["CREEK"] = "Shady Creeks",
    ["CREEK"] = "Shady Creeks",
    ["WESTP"] = "Queens",
    ["WESTP"] = "Queens",
    ["WESTP"] = "Queens",
    ["LA"] = "Los Santos",
    ["VE"] = "Las Venturas",
    ["BONE"] = "Bone County",
    ["ROBAD"] = "Tierra Robada",
    ["GANTB"] = "Gant Bridge",
    ["GANTB"] = "Gant Bridge",
    ["SF"] = "San Fierro",
    ["ROBAD"] = "Tierra Robada",
    ["RED"] = "Red County",
    ["FLINTC"] = "Flint County",
    ["EBAY"] = "Easter Bay Chemicals",
    ["EBAY"] = "Easter Bay Chemicals",
    ["SFAIR"] = "Easter Bay Airport",
    ["SILLY"] = "Foster Valley",
    ["SILLY"] = "Foster Valley",
    ["SFAIR"] = "Easter Bay Airport",
    ["SFAIR"] = "Easter Bay Airport",
    ["WHET"] = "Whetstone",
    ["LAIR"] = "Los Santos International",
    ["LAIR"] = "Los Santos International",
    ["BLUF"] = "Verdant Bluffs",
    ["ELCO"] = "El Corona",
    ["LIND"] = "Willowfield",
    ["LIND"] = "Willowfield",
    ["LIND"] = "Willowfield",
    ["LIND"] = "Willowfield",
    ["LDOC"] = "Ocean Docks",
    ["LDOC"] = "Ocean Docks",
    ["MAR"] = "Marina",
    ["VERO"] = "Verona Beach",
    ["VERO"] = "Verona Beach",
    ["BLUF"] = "Verdant Bluffs",
    ["BLUF"] = "Verdant Bluffs",
    ["ELCO"] = "El Corona",
    ["VERO"] = "Verona Beach",
    ["MAR"] = "Marina",
    ["MAR"] = "Marina",
    ["VERO"] = "Verona Beach",
    ["VERO"] = "Verona Beach",
    ["CONF"] = "Conference Center",
    ["CONF"] = "Conference Center",
    ["COM"] = "Commerce",
    ["COM"] = "Commerce",
    ["COM"] = "Commerce",
    ["COM"] = "Commerce",
    ["PER1"] = "Pershing Square",
    ["COM"] = "Commerce",
    ["LMEX"] = "Little Mexico",
    ["LMEX"] = "Little Mexico",
    ["COM"] = "Commerce",
    ["IWD"] = "Idlewood",
    ["IWD"] = "Idlewood",
    ["IWD"] = "Idlewood",
    ["IWD"] = "Idlewood",
    ["IWD"] = "Idlewood",
    ["GLN"] = "Glen Park",
    ["GLN"] = "Glen Park",
    ["JEF"] = "Jefferson",
    ["JEF"] = "Jefferson",
    ["JEF"] = "Jefferson",
    ["JEF"] = "Jefferson",
    ["JEF"] = "Jefferson",
    ["CHC"] = "Las Colinas",
    ["CHC"] = "Las Colinas",
    ["CHC"] = "Las Colinas",
    ["CHC"] = "Las Colinas",
    ["IWD"] = "Idlewood",
    ["GAN"] = "Ganton",
    ["GAN"] = "Ganton",
    ["LIND"] = "Willowfield",
    ["EBE"] = "East Beach",
    ["EBE"] = "East Beach",
    ["EBE"] = "East Beach",
    ["ELS"] = "East Los Santos",
    ["ELS"] = "East Los Santos",
    ["JEF"] = "Jefferson",
    ["ELS"] = "East Los Santos",
    ["ELS"] = "East Los Santos",
    ["ELS"] = "East Los Santos",
    ["ELS"] = "East Los Santos",
    ["ELS"] = "East Los Santos",
    ["LFL"] = "Los Flores",
    ["LFL"] = "Los Flores",
    ["EBE"] = "East Beach",
    ["CHC"] = "Las Colinas",
    ["CHC"] = "Las Colinas",
    ["CHC"] = "Las Colinas",
    ["LDT"] = "Downtown Los Santos",
    ["LDT"] = "Downtown Los Santos",
    ["LDT"] = "Downtown Los Santos",
    ["LDT"] = "Downtown Los Santos",
    ["LDT"] = "Downtown Los Santos",
    ["MULINT"] = "Mulholland Intersection",
    ["MUL"] = "Mulholland",
    ["MUL"] = "Mulholland",
    ["MUL"] = "Mulholland",
    ["MKT"] = "Market",
    ["VIN"] = "Vinewood",
    ["MKT"] = "Market",
    ["LDT"] = "Downtown Los Santos",
    ["LDT"] = "Downtown Los Santos",
    ["LDT"] = "Downtown Los Santos",
    ["SUN"] = "Temple",
    ["SUN"] = "Temple",
    ["SUN"] = "Temple",
    ["MUL"] = "Mulholland",
    ["MUL"] = "Mulholland",
    ["MUL"] = "Mulholland",
    ["VIN"] = "Vinewood",
    ["SUN"] = "Temple",
    ["SUN"] = "Temple",
    ["SUN"] = "Temple",
    ["MUL"] = "Mulholland",
    ["MUL"] = "Mulholland",
    ["MUL"] = "Mulholland",
    ["MUL"] = "Mulholland",
    ["MUL"] = "Mulholland",
    ["MUL"] = "Mulholland",
    ["MUL"] = "Mulholland",
    ["SMB"] = "Santa Maria Beach",
    ["SMB"] = "Santa Maria Beach",
    ["ROD"] = "Rodeo",
    ["ROD"] = "Rodeo",
    ["ROD"] = "Rodeo",
    ["ROD"] = "Rodeo",
    ["ROD"] = "Rodeo",
    ["ROD"] = "Rodeo",
    ["ROD"] = "Rodeo",
    ["ROD"] = "Rodeo",
    ["ROD"] = "Rodeo",
    ["ROD"] = "Rodeo",
    ["VIN"] = "Vinewood",
    ["RIH"] = "Richman",
    ["RIH"] = "Richman",
    ["ROD"] = "Rodeo",
    ["ROD"] = "Rodeo",
    ["RIH"] = "Richman",
    ["RIH"] = "Richman",
    ["RIH"] = "Richman",
    ["RIH"] = "Richman",
    ["RIH"] = "Richman",
    ["RIH"] = "Richman",
    ["RIH"] = "Richman",
    ["RIH"] = "Richman",
    ["STRIP"] = "The Strip",
    ["STRIP"] = "The Strip",
    ["DRAG"] = "The Four Dragons Casino",
    ["PINK"] = "The Pink Swan",
    ["HIGH"] = "The High Roller",
    ["PIRA"] = "Pirates in Men's Pants",
    ["VISA"] = "The Visage",
    ["VISA"] = "The Visage",
    ["JTS"] = "Julius Thruway South",
    ["JTW"] = "Julius Thruway West",
    ["JTS"] = "Julius Thruway South",
    ["RSE"] = "Rockshore East",
    ["LOT"] = "Come-A-Lot",
    ["CAM"] = "The Camel's Toe",
    ["ROY"] = "Royal Casino",
    ["CALI"] = "Caligula's Palace",
    ["CALI"] = "Caligula's Palace",
    ["PILL"] = "Pilgrim",
    ["STAR"] = "Starfish Casino",
    ["STRIP"] = "The Strip",
    ["STRIP"] = "The Strip",
    ["ISLE"] = "The Emerald Isle",
    ["OVS"] = "Old Venturas Strip",
    ["KACC"] = "K.A.C.C. Military Fuels",
    ["CREE"] = "Creek",
    ["SRY"] = "Sobell Rail Yards",
    ["LST"] = "Linden Station",
    ["JTE"] = "Julius Thruway East",
    ["LDS"] = "Linden Side",
    ["JTE"] = "Julius Thruway East",
    ["JTN"] = "Julius Thruway North",
    ["JTE"] = "Julius Thruway East",
    ["JTE"] = "Julius Thruway East",
    ["JTN"] = "Julius Thruway North",
    ["JTN"] = "Julius Thruway North",
    ["JTN"] = "Julius Thruway North",
    ["JTN"] = "Julius Thruway North",
    ["JTW"] = "Julius Thruway West",
    ["JTN"] = "Julius Thruway North",
    ["HGP"] = "Harry Gold Parkway",
    ["REDE"] = "Redsands East",
    ["REDE"] = "Redsands East",
    ["REDE"] = "Redsands East",
    ["JTN"] = "Julius Thruway North",
    ["REDW"] = "Redsands West",
    ["REDW"] = "Redsands West",
    ["REDW"] = "Redsands West",
    ["REDW"] = "Redsands West",
    ["VAIR"] = "Las Venturas Airport",
    ["VAIR"] = "Las Venturas Airport",
    ["VAIR"] = "Las Venturas Airport",
    ["LVA"] = "LVA Freight Depot",
    ["BINT"] = "Blackfield Intersection",
    ["BINT"] = "Blackfield Intersection",
    ["BINT"] = "Blackfield Intersection",
    ["BINT"] = "Blackfield Intersection",
    ["LVA"] = "LVA Freight Depot",
    ["LVA"] = "LVA Freight Depot",
    ["LVA"] = "LVA Freight Depot",
    ["LVA"] = "LVA Freight Depot",
    ["GGC"] = "Greenglass College",
    ["GGC"] = "Greenglass College",
    ["BFLD"] = "Blackfield",
    ["BFLD"] = "Blackfield",
    ["ROCE"] = "Roca Escalante",
    ["ROCE"] = "Roca Escalante",
    ["LDM"] = "Last Dime Motel",
    ["RSW"] = "Rockshore West",
    ["RSW"] = "Rockshore West",
    ["RIE"] = "Randolph Industrial Estate",
    ["BFC"] = "Blackfield Chapel",
    ["BFC"] = "Blackfield Chapel",
    ["JTN"] = "Julius Thruway North",
    ["PINT"] = "Pilson Intersection",
    ["WWE"] = "Whitewood Estates",
    ["PRP"] = "Prickle Pine",
    ["PRP"] = "Prickle Pine",
    ["PRP"] = "Prickle Pine",
    ["SPIN"] = "Spinybed",
    ["PRP"] = "Prickle Pine",
    ["PILL"] = "Pilgrim",
    ["SASO"] = "San Andreas Sound",
    ["FISH"] = "Fisher's Lagoon",
    ["GARV"] = "Garver Bridge",
    ["GARV"] = "Garver Bridge",
    ["GARV"] = "Garver Bridge",
    ["KINC"] = "Kincaid Bridge",
    ["KINC"] = "Kincaid Bridge",
    ["KINC"] = "Kincaid Bridge",
    ["LSINL"] = "Los Santos Inlet",
    ["SHERR"] = "Sherman Reservoir",
    ["FLINW"] = "Flint Water",
    ["ETUNN"] = "Easter Tunnel",
    ["BYTUN"] = "Bayside Tunnel",
    ["BIGE"] = "'The Big Ear'",
    ["PROBE"] = "Lil' Probe Inn",
    ["VALLE"] = "Valle Ocultado",
    ["GLN"] = "Glen Park",
    ["LDOC"] = "Ocean Docks",
    ["LINDEN"] = "Linden Station",
    ["UNITY"] = "Unity Station",
    ["VIN"] = "Vinewood",
    ["MARKST"] = "Market Station",
    ["CRANB"] = "Cranberry Station",
    ["YELLOW"] = "Yellow Bell Station",
    ["SANB"] = "San Fierro Bay",
    ["SANB"] = "San Fierro Bay",
    ["ELCA"] = "El Castillo del Diablo",
    ["ELCA"] = "El Castillo del Diablo",
    ["ELCA"] = "El Castillo del Diablo",
    ["REST"] = "Restricted Area",
    ["MONINT"] = "Montgomery Intersection",
    ["MONINT"] = "Montgomery Intersection",
    ["ROBINT"] = "Robada Intersection",
    ["FLINTI"] = "Flint Intersection",
    ["SFAIR"] = "Easter Bay Airport",
    ["SFAIR"] = "Easter Bay Airport",
    ["SFAIR"] = "Easter Bay Airport",
    ["MKT"] = "Market",
    ["MKT"] = "Market",
    ["CUNTC"] = "Avispa Country Club",
    ["CUNTC"] = "Avispa Country Club",
    ["HILLP"] = "Missionary Hill",
    ["MTCHI"] = "Mount Chiliad",
    ["MTCHI"] = "Mount Chiliad",
    ["MTCHI"] = "Mount Chiliad",
    ["MTCHI"] = "Mount Chiliad",
    ["YBELL"] = "Yellow Bell Golf Course",
    ["YBELL"] = "Yellow Bell Golf Course",
    ["VAIR"] = "Las Venturas Airport",
    ["LDOC"] = "Ocean Docks",
    ["LAIR"] = "Los Santos International",
    ["LDOC"] = "Ocean Docks",
    ["LAIR"] = "Los Santos International",
    ["LAIR"] = "Los Santos International",
    ["LAIR"] = "Los Santos International",
    ["STAR"] = "Starfish Casino",
    ["BEACO"] = "Beacon Hill",
    ["CUNTC"] = "Avispa Country Club",
    ["CUNTC"] = "Avispa Country Club",
    ["GARC"] = "Garcia",
    ["CUNTC"] = "Avispa Country Club",
    ["CUNTC"] = "Avispa Country Club",
    ["PLS"] = "Playa del Seville",
    ["LDOC"] = "Ocean Docks",
    ["STAR"] = "Starfish Casino",
    ["RING"] = "The Clown's Pocket",
    ["LDOC"] = "Ocean Docks",
    ["LIND"] = "Willowfield",
    ["LIND"] = "Willowfield",
    ["WWE"] = "Whitewood Estates",
    ["LDT"] = "Downtown Los Santos"
  }
  if names[zone] == nil then return "Не определено" end
  return names[zone]
end

function getweaponname(weapon)
  local names = {
  [0] = "Fist",
  [1] = "Brass Knuckles",
  [2] = "Golf Club",
  [3] = "Nightstick",
  [4] = "Knife",
  [5] = "Baseball Bat",
  [6] = "Shovel",
  [7] = "Pool Cue",
  [8] = "Katana",
  [9] = "Chainsaw",
  [10] = "Purple Dildo",
  [11] = "Dildo",
  [12] = "Vibrator",
  [13] = "Silver Vibrator",
  [14] = "Flowers",
  [15] = "Cane",
  [16] = "Grenade",
  [17] = "Tear Gas",
  [18] = "Molotov Cocktail",
  [22] = "9mm",
  [23] = "Silenced 9mm",
  [24] = "Desert Eagle",
  [25] = "Shotgun",
  [26] = "Sawnoff Shotgun",
  [27] = "Combat Shotgun",
  [28] = "Micro SMG/Uzi",
  [29] = "MP5",
  [30] = "AK-47",
  [31] = "M4",
  [32] = "Tec-9",
  [33] = "Country Rifle",
  [34] = "Sniper Rifle",
  [35] = "RPG",
  [36] = "HS Rocket",
  [37] = "Flamethrower",
  [38] = "Minigun",
  [39] = "Satchel Charge",
  [40] = "Detonator",
  [41] = "Spraycan",
  [42] = "Fire Extinguisher",
  [43] = "Camera",
  [44] = "Night Vis Goggles",
  [45] = "Thermal Goggles",
  [46] = "Parachute" }
  return names[weapon]
end

function kvadrat()
  local KV = {"А","Б","В","Г","Д","Ж","З","И","К","Л","М","Н","О","П","Р","С","Т","У","Ф","Х","Ц","Ч","Ш","Я"}
  local X, Y, Z = getCharCoordinates(playerPed)
  X = math.ceil((X + 3000) / 250)
  Y = math.ceil((Y * - 1 + 3000) / 250)
  -- Fix #7469 (27/7/19)
  if X <= 0 or Y < 1 or Y > #KV then return "Нет" end
  Y = KV[Y]
  local KVX = (Y.."-"..X)
  return KVX
end

function sampGetFraktionBySkin(id)
  local t = 'Гражданский'
  id = tonumber(id)
  if id ~= nil and sampIsPlayerConnected(id) then
    local result, ped = sampGetCharHandleBySampPlayerId(id)
    if result then
      local skin = getCharModel(ped)
      if skin == 102 or skin == 103 or skin == 104 or skin == 195 or skin == 21 then t = 'Ballas Gang' end
      if skin == 105 or skin == 106 or skin == 107 or skin == 269 or skin == 270 or skin == 271 or skin == 86 or skin == 149 or skin == 297 then t = 'Grove Gang' end
      if skin == 108 or skin == 109 or skin == 110 or skin == 190 or skin == 47 then t = 'Vagos Gang' end
      if skin == 114 or skin == 115 or skin == 116 or skin == 48 or skin == 44 or skin == 41 or skin == 292 then t = 'Aztec Gang' end
      if skin == 173 or skin == 174 or skin == 175 or skin == 193 or skin == 226 or skin == 30 or skin == 119 then t = 'Rifa Gang' end
      if skin == 73 or skin == 191 or skin == 252 or skin == 287 or skin == 61 or skin == 179 or skin == 255 then t = 'Army' end
      if skin == 57 or skin == 98 or skin == 147 or skin == 150 or skin == 187 or skin == 216 then t = 'Mayor' end
      if skin == 59 or skin == 172 or skin == 189 or skin == 240 then t = 'Instructors' end
      if skin == 201 or skin == 247 or skin == 248 or skin == 254 or skin == 248 or skin == 298 then t = 'Bikers' end
      if skin == 272 or skin == 112 or skin == 125 or skin == 214 or skin == 111  or skin == 126 then t = 'Russian Mafia' end
      if skin == 113 or skin == 124 or skin == 214 or skin == 223 then t = 'La Cosa Nostra' end
      if skin == 120 or skin == 123 or skin == 169 or skin == 186 then t = 'Yakuza' end
      if skin == 211 or skin == 217 or skin == 250 or skin == 261 then t = 'News' end
      if skin == 70 or skin == 219 or skin == 274 or skin == 275 or skin == 276 or skin == 70 then t = 'Medic' end
      if skin == 286 or skin == 141 or skin == 163 or skin == 164 or skin == 165 or skin == 166 then t = 'FBI' end
      if skin == 280 or skin == 265 or skin == 266 or skin == 267 or skin == 281 or skin == 282 or skin == 288 or skin == 284 or skin == 285 or skin == 304 or skin == 305 or skin == 306 or skin == 307 or skin == 309 or skin == 283 or skin == 303 then t = 'Police' end
    end
  end
  return t
end

function funcc(type, add)
  if pInfo.func[type] == nil then pInfo.func[type] = 0 end
  pInfo.func[type] = pInfo.func[type] + add
end

function loggerInit()
  local levels = {}
  local round = function(x, increment)
    increment = increment or 1
    x = x / increment
    return (x > 0 and math.floor(x + .5) or math.ceil(x - .5)) * increment
  end
  local _tostring = tostring
  local tostring = function(...)
    local t = {}
    for i = 1, select('#', ...) do
      local x = select(i, ...)
      if type(x) == "number" then
        x = round(x, .01)
      end
      t[#t + 1] = _tostring(x)
    end
    return table.concat(t, " ")
  end
  ----------------------
  for i, v in ipairs(logger.modes) do
    levels[v.name] = i
  end
  ----------------------
  -- Перезагружаем файл логгера
  if logger.outfile then
    local file = io.open('moonloader/SFAHelper/debug.txt', 'w')
    local dates = '['..os.date('%d.%m.%Y')..' | '..os.date('%H:%M:%S')..']'
    local text = dates..' ================================================================\n'
    text = text..dates..'   SFA-Helper version '..SCRIPT_ASSEMBLY..' for SA-MP 0.3.7 loaded.\n'
    text = text..dates..'   Developers: Edward_Franklin, Thomas_Lawson\n'..dates..'   Copyright (c) 2019, redx\n'
    text = text..dates..' ================================================================\n'
    file:write(text)
    file:close()
  end
  ----------------------
  for i, x in ipairs(logger.modes) do
    logger[x.name] = function(...)
      local msg = tostring(...)
      local info = debug.getinfo(2, "Sl")
      local lineinfo = thisScript().name .. ":" .. info.currentline
      if i >= levels[logger.level] then
        -- Output to console
        sampfuncsLog(("[ML] %s(%s) {FFFFFF}%s:{CCCCCC} %s"):format(logger.usecolor and "{"..x.color.."}" or "", x.name, lineinfo, msg))
      end
      -- Output to log file
      if logger.outfile then
        local fp = io.open(logger.outfile, "a")
        local str = string.format("[%s | %s] (%s) %s: %s\n", os.date('%d.%m.%Y'), os.date('%H:%M:%S'), x.name, lineinfo, msg)
        fp:write(str)
        fp:close()
      end
    end
  end
end

filesystem = {
  param = {
    path = ""
  }
}
filesystem.path = function(path)
  if path == nil or #path == 0 then
    return filesystem.param.path
  else
    filesystem.param.path = path
  end
end
filesystem.init = function(path)
  logger.debug('Иницилизируем настройки. Директория: '..path)
  -----
  local dirs = string.split(path, "/")
  local mkdirs = ""
  for i = 1, #dirs do
    if not doesDirectoryExist(mkdirs..dirs[i]) then
      createDirectory(mkdirs..dirs[i])
    end
    mkdirs = mkdirs..dirs[i]..'/'
  end
  -----
  if not doesFileExist(path.."/config.json") then
    local fa = io.open(path.."/config.json", "w")
    fa:write(encodeJson(pInfo))
    fa:close()
  end
  if not doesFileExist(path.."/keys.json") then
    local fa = io.open(path.."/keys.json", "w")
    fa:write(encodeJson(config_keys))
    fa:close()
  end
  if not doesFileExist(path.."/posts.json") then
    local fa = io.open(path.."/posts.json", "w")
    fa:write(encodeJson(postInfo))
    fa:close()
  end
  if not doesFileExist(path.."/punishlog.json") then
    local fa = io.open(path.."/punishlog.json", "w")
    fa:write("[]")
    fa:close()
  end
  complete = true
end
filesystem.load = function(file)
  if not doesFileExist(filesystem.param.path.."/"..file) then return nil end
  local fa = io.open(filesystem.param.path.."/"..file, 'r')
  if not fa then return nil end
  local cfgjson = decodeJson(fa:read('*a'))
  if cfgjson == nil then fa:close(); return nil end
  return cfgjson
end
filesystem.save = function(table, file)
  if file == 'config.json' and table.info.weekOnline < 0 then return end
  local sfa = io.open(filesystem.param.path.."/"..file, "w")
  if sfa then
    sfa:write(encodeJson(table))
    sfa:close()
  end
end
filesystem.movefiles = function(to, from, files)
  for i = 1, #files do
    if doesFileExist(from..'/'..files[i]) then
      local mfile = io.open(from..'/'..files[i], 'r')
      if mfile then
        logger.trace('Copying file from: '..from..'/'..files[i])
        local filetext = mfile:read('*a')
        if filetext ~= nil then
          local tfile = io.open(to..'/'..files[i], 'w')
          if tfile then
            logger.trace('Copying file to: '..to..'/'..files[i])
            tfile:write(filetext)
            tfile:close()
          end
        end
        mfile:close()
      end
    end
  end
end
filesystem.performOld = function(filename, tab)
  if filename == 'config.json' then
    if #tab.gov == 0 or tab.gov == nil then
      tab.gov = govtext
    end
  elseif filename == 'keys.json' then
    if tab.binder ~= nil then
      local replaced = false
      for i = 1, #tab.binder do
        if type(tab.binder[i].text) == "string" then
          local text = tab.binder[i].text
          tab.binder[i].text = { text }
          replaced = true
        end
      end
      if replaced then
        logger.trace('replaced is true (binder)')
        local newBinder = {}
        local replacedBinder = {}
        for i = 1, #tab.binder do
          local sKeys = tostring(table.concat(tab.binder[i].v, " "))
          if newBinder[sKeys] == nil then
            replacedBinder[#replacedBinder + 1] = tab.binder[i]
            newBinder[sKeys] = #replacedBinder
          else
            for j = 1, #tab.binder[i].text do
              replacedBinder[newBinder[sKeys]].text[#replacedBinder[newBinder[sKeys]].text + 1] = tab.binder[i].text[j]
            end
          end
        end
        tab.binder = replacedBinder
      end
    end
    if tab.cmd_binder ~= nil then
      local replaced = false
      for i = 1, #tab.cmd_binder do
        if type(tab.cmd_binder[i].text) == "string" then
          local text = tab.cmd_binder[i].text
          tab.cmd_binder[i].text = { text }
          tab.cmd_binder[i].wait = 1100
          replaced = true
        end
      end
      if replaced then
        logger.trace('replaced is true (cmd_binder)')
        funcc('upd37', 1)
        table.insert(tab.cmd_binder, { cmd = "uinv", wait = 1100, text = { "/uninvite {param} {param2}" } })
        table.insert(tab.cmd_binder, { cmd = "gr", wait = 1100, text = { "/giverank {param} {param2}" } })
        table.insert(tab.cmd_binder, { cmd = "inv", wait = 1100, text = { "/invite {param}" } })
        table.insert(tab.cmd_binder, { cmd = "cl", wait = 1100, text = { "/clist {param}" } })
        table.insert(tab.cmd_binder, { cmd = "rpmask", wait = 1100, text = { "/me достал маску из кармана и надел на лицо", "/clist 32", "/do На лице маска, на форме нет опознавательных знаков. Личность не опознать" } })
      end
    end
  end
  return tab
end
--------------------------------[ IMGUI ]--------------------------------
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

function apply_custom_style()
  imgui.SwitchContext()
  local style = imgui.GetStyle()
  local colors = style.Colors
  local clr = imgui.Col
  local ImVec4 = imgui.ImVec4
  local ImVec2 = imgui.ImVec2

  style.WindowPadding = imgui.ImVec2(10, 10)
  style.FramePadding = imgui.ImVec2(4, 4)
  style.WindowRounding = 0
  style.ChildWindowRounding = 0
  style.ItemSpacing = imgui.ImVec2(8.0, 5.0)
  style.ItemInnerSpacing = imgui.ImVec2(8, 6)
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
  colors[clr.CloseButton] = ImVec4(0.56, 0.56, 0.58, 0.75)
  colors[clr.CloseButtonHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
  colors[clr.CloseButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
  colors[clr.PlotLines] = ImVec4(0.00, 0.00, 0.00, 0.00)
  colors[clr.PlotLinesHovered] = ImVec4(0.00, 0.00, 0.00, 0.00)
  colors[clr.PlotHistogram] = ImVec4(0.00, 0.00, 0.00, 0.00)
  colors[clr.PlotHistogramHovered] = ImVec4(0.00, 0.00, 0.00, 0.00)
  colors[clr.TextSelectedBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
  colors[clr.ModalWindowDarkening] = ImVec4(0.00, 0.00, 0.00, 0.00)
end



--------------------------------[ DO NOT TOUCH ]--------------------------------
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

local russian_characters = {
  [168] = 'Ё', [184] = 'ё', [192] = 'А', [193] = 'Б', [194] = 'В', [195] = 'Г', [196] = 'Д', [197] = 'Е', [198] = 'Ж', [199] = 'З', [200] = 'И', [201] = 'Й', [202] = 'К', [203] = 'Л', [204] = 'М', [205] = 'Н', [206] = 'О', [207] = 'П', [208] = 'Р', [209] = 'С', [210] = 'Т', [211] = 'У', [212] = 'Ф', [213] = 'Х', [214] = 'Ц', [215] = 'Ч', [216] = 'Ш', [217] = 'Щ', [218] = 'Ъ', [219] = 'Ы', [220] = 'Ь', [221] = 'Э', [222] = 'Ю', [223] = 'Я', [224] = 'а', [225] = 'б', [226] = 'в', [227] = 'г', [228] = 'д', [229] = 'е', [230] = 'ж', [231] = 'з', [232] = 'и', [233] = 'й', [234] = 'к', [235] = 'л', [236] = 'м', [237] = 'н', [238] = 'о', [239] = 'п', [240] = 'р', [241] = 'с', [242] = 'т', [243] = 'у', [244] = 'ф', [245] = 'х', [246] = 'ц', [247] = 'ч', [248] = 'ш', [249] = 'щ', [250] = 'ъ', [251] = 'ы', [252] = 'ь', [253] = 'э', [254] = 'ю', [255] = 'я',
}

-- string.lower для русских букв
function rusLower(s)
  local strlen = s:len()
  if strlen == 0 then return s end
  s = s:lower()
  local output = ''
  for i = 1, strlen do
    local ch = s:byte(i)
    if ch >= 192 and ch <= 223 then -- upper russian characters
      output = output .. russian_characters[ch+32]
    elseif ch == 168 then -- Ё
      output = output .. russian_characters[184]
    else
      output = output .. string.char(ch)
    end
  end
  return output
end

-- string.upper для русских букв
function rusUpper(s)
  local strlen = s:len()
  if strlen == 0 then return s end
  s = s:upper()
  local output = ''
  for i = 1, strlen do
    local ch = s:byte(i)
    if ch >= 224 and ch <= 255 then -- lower russian characters
      output = output .. russian_characters[ch-32]
    elseif ch == 184 then -- ё
      output = output .. russian_characters[168]
    else
      output = output .. string.char(ch)
    end
  end
  return output
end

-- Дополняет таблицу 'to' таблицей 'table'.
-- Максимальная глубина вхождения = 5 (table.one.two.three.four)
function additionArray(table, to)
  if table == nil then return to end
  for k, v in pairs(table) do
    if type(v) == "table" then
      if to[k] == nil then to[k] = {} end
      for k1, v1 in pairs(v) do
        if type(v1) == "table" then
          if to[k][k1] == nil then to[k][k1] = {} end
          for k2, v2 in pairs(v1) do
            if type(v2) == "table" then
              if to[k][k1][k2] == nil then to[k][k1][k2] = {} end  
              for k3, v3 in pairs(v2) do
                if type(v3) == "table" then
                  if to[k][k1][k2][k3] == nil then to[k][k1][k2][k3] = {} end
                else to[k][k1][k2][k3] = v3 end
              end
            else to[k][k1][k2] = v2 end
          end
        else to[k][k1] = v1 end
      end
    else to[k] = v end
  end
  return to
end

function distBetweenCoords(cx, cy, cz, px, py, pz)
  return tonumber(("%0.2f"):format(getDistanceBetweenCoords3d(cx, cy, cz, px, py, pz)))
end

function screen() memory.setuint8(sampGetBase() + 0x119CBC, 1) end

function encodeURI(str)
  if (str) then
    str = string.gsub (str, "\n", "\r\n")
    str = string.gsub (str, "([^%w ])",
      function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
   end
   return str
end

-- Доработана. Добавил максимальное кол-во делений
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

-- Определяет день недели по дате.
-- Начинает с Воскресенья (0)
function dateToWeekNumber(date)
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

function _secToTime(sec)
  sec = tonumber(sec)
  if sec == nil then return end
  local result = ""
  local hour, minute, second = sec / 3600, math.floor(sec / 60), sec % 60
  hour = math.floor(hour)
  minute = minute - (math.floor(hour) * 60)
  if hour > 0 then result = string.format("%02d", hour) end
  if minute > 0 and hour == 0 then result = string.format("%02d", minute)
  elseif minute > 0 and hour > 0 then result = result..string.format(":%02d", minute) end
  if result ~= "" then result = result..string.format(":%02d", second)
  else result = string.format("%d секунд", second) end
  return result
end

function getTargetBlipCoordinatesFixed()
  local bool, x, y, z = getTargetBlipCoordinates(); if not bool then return false end
  requestCollision(x, y); loadScene(x, y, z)
  local bool, x, y, z = getTargetBlipCoordinates()
  return bool, x, y, z
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

function submenus_show(menu, caption, select_button, close_button, back_button)
  select_button, close_button, back_button = select_button or 'Select', close_button or 'Close', back_button or 'Back'
  prev_menus = {}
  function display(menu, id, caption)
    lua_thread.create(function()
      local string_list = {}
      for i, v in ipairs(menu) do
        table.insert(string_list, type(v.submenu) == 'table' and v.title .. '  >>' or v.title)
      end
      sampShowDialog(id, caption, table.concat(string_list, '\n'), select_button, (#prev_menus > 0) and back_button or close_button, sf.DIALOG_STYLE_LIST)
      repeat wait(0)
        local result, button, list = sampHasDialogRespond(id)
        if result then
          if button == 1 and list ~= -1 then
            local item = menu[list + 1]
            if type(item.submenu) == 'table' then -- submenu
              table.insert(prev_menus, {menu = menu, caption = caption})
              if type(item.onclick) == 'function' then
                item.onclick(menu, list + 1, item.submenu)
              end
              return display(item.submenu, id + 1, item.submenu.title and item.submenu.title or item.title)
            elseif type(item.onclick) == 'function' then
              local result = item.onclick(menu, list + 1)
              if not result then return result end
              return display(menu, id, caption)
            end
          else -- if button == 0
            if #prev_menus > 0 then
              local prev_menu = prev_menus[#prev_menus]
              prev_menus[#prev_menus] = nil
              return display(prev_menu.menu, id - 1, prev_menu.caption)
            end
            return false
          end
        end
      until result
    end)
  end
  return display(menu, 31337, caption or menu.title)
end