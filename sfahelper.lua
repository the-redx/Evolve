-- This file is a SFA-Helper project
-- Licensed under MIT License
-- Copyright (c) 2019 redx
-- https://github.com/the-redx/Evolve
-- Version 1.41-release1

script_name("SFA-Helper")
script_authors({ 'Edward_Franklin' })
script_version("1.4131")
SCRIPT_ASSEMBLY = "1.41-release1"
DEBUG_MODE = true
--------------------------------------------------------------------
require 'lib.moonloader'
require 'lib.sampfuncs'
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
local llfs, lfs           = pcall(require,  'lfs')
local lbass, bass         = pcall(require, 'bass')
local lffi, ffi           = pcall(require, 'ffi')
local lpie, pie           = pcall(require, 'imgui_piemenu')
--local raknet = require "lib.samp.raknet"
------------------
encoding.default = 'CP1251'
local u8 = encoding.UTF8
dlstatus = require('moonloader').download_status
imgui.ToggleButton = imadd.ToggleButton
imgui.HotKey = imadd.HotKey
--------------------------------------------------------------------
-- ������������
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
  ['main'] = { bool = imgui.ImBool(false), cursor = true, draw = true },
  ['target'] = { bool = imgui.ImBool(false), cursor = false, draw = true },
  ['shpora'] = { bool = imgui.ImBool(false), cursor = true, draw = true },
  ['members'] = { bool = imgui.ImBool(false), cursor = true, draw = true } ,
  ['addtable'] = { bool = imgui.ImBool(false), cursor = true, draw = true },
  ['hud'] = { bool = imgui.ImBool(false), cursor = false, draw = true },
  ['binder'] = { bool = imgui.ImBool(false), cursor = false, draw = false }
}
screenx, screeny = getScreenResolution()
reloadScriptsParam = false
govtext = {
  {'������� �������','[Army SF]: ��������� ������ �����, � {time} �������� ������ � San-Fierro Army!','[Army SF]: ����������: 3 ���� ���������� � �����, �� ����� ������� � ������� �� �������� � ��.','[Army SF]: ��������� �����: �������� ������ San Fierro. ��������� �-2. ������� �� ��������.'},
  {'������ �������','[Army SF]: ��������� ������ ����� Evolve, ������ � San-Fierro Army �������!','[Army SF]: ����������: 3 ���� ���������� � �����, �� ����� ������� � ������� �� �������� � ��.','[Army SF]: ��������� ����� - �������� ������ San Fierro. ��������� �-2. ������� �� ��������.'},
  {'����������� �������','[Army SF]: ��������� ������ �����, � ������ ������, � �������� SF �������� ������ � Army SF.','[Army SF]: ����������: 3 ���� ���������� � �����, �� ����� ������� � ������� �� �������� � ��.','[Army SF]: ��������� ����� - �������� ������ San Fierro. ��������� �-2. ������� �� ��������.'},
  {'����� �������','[Army SF]: ��������� ������ �����, ������ � ����� ������ San-Fierro �������!','[Army SF]: ��������� ������ San-Fierro Army �������� � {time}.','[Army SF]: �������� ���� � ���� �����, � ��������� - ����������� �����.'},
  {'���� ����������','[Army SF]: ��������� ������ � ����� ����� Evolve. ����� ������ ��������.','[Army SF]: �� ����������� ������� ����� "���������" ������ ����� ��������� �� ����������� ������.','[Army SF]: ��� ��� � ����� ����� �����. � ���������, ����������� ����� "���������".'}
}
-- ������� ������� � �����������
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
    watchhud = true,
    watchX = 20,
    watchY = (screeny / 2) + 10,
    hudY = screeny - 250,
    hudset = {false, true, true, true, true, true, false, true, true, true, false},
    hudopacity = 1.0,
    hudrounding = 0.0,
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
  ranknames = {'�������', '��������', '��.�������', '�������', '��.�������', '��������', '���������', '��.���������', '���������', '��.���������', '�������', '�����', '������������', '���������', '�������'},
  func = {},
  gov = govtext,
  weeks = {0,0,0,0,0,0,0},
  counter = {0,0,0,0,0,0,0,0,0,0,0,0}
}
-- �����������
localInfo = {
  autopost = {
    title = "����-��������",
    load = {'�������� ���������', "�� ����� ���� - {id}. ���������� �� ���������. ���� ���� �� �� Army LV.", "�� ����� ���� - {id}. ����������� �� ���������. ���� ���� �� �� Army LV."},
    unload = {'��������� ���������', "�� ����� ���� - {id}. ����������� �� �� Army LV. ��������� - {sklad}/300", "�� ����� ���� - {id}. ������������ �� �� Army LV. ��������� - {sklad}/300"},
    start = {'����� ��������', "�� ����� ���� - {id}. ����� �������� ����������� �� �� Army LV.", "�� ����� ���� - {id}. ������ �������� ����������� �� �� Army LV."},
    ends = {'�������� ��������', "�� ����� ���� - {id}. �������� �������� �� �� Army LV, ���� ���� �� �����.", "�� ����� ���� - {id}. ��������� �������� �� �� Army LV, ���� ���� �� �����."},
    startp = {'����� �������� � �����', "10-15", "10-15"},
    endp = {'�������� �������� � �����', "10-16", "10-16"}
  },
  post = {
    title = "����-������",
    ends = {"������� ����", "������� ����: �{post}�.", "�������� ����: �{post}�." },
    start = {"�������� �� ����", "�������� �� ����: �{post}�.", "��������� �� ����: �{post}�."},
    doklad = {"������", "����: �{post}�. ���������� ������: {count}. ���������: code 1", "����: �{post}�. ���������� ������: {count}. ���������: code 1"}
  },
  punaccept = {
    title = "�������� � ��������",
    vig = {"������ �������", "{id} �������� {type} ������� �� {reason}", "{id} �������� {type} ������� �� {reason}"},
    blag = {"�������� �������������", "/d {frac}, ������� ������������� {id} �� {reason}", "/d {frac}, ������� ������������� {id} �� {reason}"},
    loc = {"��������� ��������������", '{nick}, ���� ��������������? �� ����� {sec} ������.', '{nick}, ���� ��������������? �� ����� {sec} ������.'},
    rubka = {"������� � �����", "{id}, ��������� � �����. � ��� {min} �����", "{id}, ��������� � �����. � ��� {min} �����"},
    naryad = {"������ �����", '{id} �������� ����� {count} ������ �� {reason}', '{id} �������� ����� {count} ������ �� {reason}'}
  },
  autobp = {
    title = "����-��",
    abp = {'��������� ������ ������','/me ���� ��������� ������ � ����������� �� ������', '/me ����� ��������� ������ � ����������� �� ������'}
  },
  rpguns = {
    title = "�� ��������� ������",
    ["0"] = {"������� ������", "/me ������� ������", "/me �������� ������"},
    ["1"] = {"������", "/me ������ � ������� ������ � ����� ��� �� ������ ����", "/me ������� � ������� ������ � ������ ��� �� ������ ����"},
    ["3"] = {"�������", "/me ������� ��������� ���� ���� � �������� ��������� �������", "/me ������� ��������� ���� ����� � �������� ��������� �������"},
    ["4"] = {"���", "/me ���������� ��������� ���� ������ � ��� ����� ���", "/me ���������� ��������� ���� ������� � ��� ����� ���"},
    ["9"] = {"���������", "/me ���� ��������� � ���� � ����� �", "/me ����� ��������� � ���� � ������ �"},
    ["16"] = {"�������", "/me ������ ������� � ����� � �������� � �� ����", "/me ������� ������� � ����� � ��������� � �� ����"},
    ["17"] = {"������� �������", "/me ����� ����������, ����� ������ � ����� ������������ �������", "/me ������ ����������, ����� ������� � ����� ������������ �������"},
    ["18"] = {"�������� ��������", "/me ������ � ����� �������� �������� � ����� ������", "/me ������� � ����� �������� �������� � ��������� ������"},
    ["22"] = {"Colt 9mm", "/me ������ � ������ �������� ����� �� - 9 � ���������� ��� � ��������", "/me ������� � ������ �������� ����� �� - 9 � ����������� ��� � ��������"},
    ["23"] = {"Silenced 9mm", "/me ������ � ��������� ������������ � ����� �� ������ \"On\"", "/me ������� � ��������� ������������ � ������ �� ������ \"On\""},
    ["24"] = {'Desert Eagle', "/me ������ � ������ �������� ����� \"Desert Eagle\" � ����������� ���", "/me ������� � ������ �������� ����� \"Desert Eagle\" � ������������ ���"},
    ["25"] = {'Shotgun', "/me ������ � ����� �� ����� �������� �������� � ������� ���", "/me ������ � ����� �� ����� �������� �������� � ������� ���"},
    ["26"] = {'Sawnoff Shotgun', "/me ������ � ����� ����� � ������� ���", "/me ������� � ����� ����� � �������� ���"},
    ["27"] = {'Combat Shotgun', "/me ������ � ����� �������������� �������� � ������� � ���� �������", "/me ������� � ����� �������������� �������� � �������� � ���� �������"},
    ["28"] = {'Micro Uzi', "/me ���� � ��������� \"Micro Uz\" � ����������� ���", "/me ����� � ��������� \"Micro Uz\" � ������������ ���"},
    ["29"] = {'MP5', "/me c��� � ����� ��������-������� \"MP-5\" � ����������� ���", "/me c���� � ����� ��������-������� \"MP-5\" � ������������ ���"},
    ["30"] = {'��-47', "/me ���� � ����� ������� \"�����������\" � ���������� ������", "/me ����� � ����� ������� \"�����������\" � ����������� ������"},
    ["31"] = {'M4A1', "/me ���� � ����� ������� \"M4A1\" � ���������� ������", "/me ����� � ����� ������� \"M4A1\" � ����������� ������"},
    ["33"] = {'Rifle', "/me ���� � ����� ����-�������������� �������� � ����������� �", "/me ����� � ����� ����-�������������� �������� � ������������ �"},
    ["34"] = {'Sniper Rifle', "/me ������ � ����� ����������� �������� ����� ������� ������� � ����������� �", "/me ������� � ����� ����������� �������� ����� �������� ������� � ������������ �"},
    ["46"] = {'Parachute', '/me ������� ������� �� �����', '/me �������� ������� �� �����'}
  },
  rp = {
    title = "�� ���������",
    uninvite = {"��������� ����������", "/me ������ ���, ����� ���� ������� ������ ���� {nick} ��� �������", "/me ������� ���, ����� ���� �������� ������ ���� {nick} ��� �������"},
    giverank = {"��������� ���������", '/me ������ {type} {rankname}�, � ������� �� �������� ��������', '/me ������� {type} {rankname}�, � �������� �� �������� ��������'},
    uninviter = {"��������� ���������� (/r)", '���� {nick} ������ �� �����. �������: {reason}', '���� {nick} ������ �� �����. �������: {reason}'},
  },
  others = {
    title = "���������",
    dep = {"������ ��� �����", '/d OG, ������� ����� ��� �������� �� {time}. ���������� �� �.{id}', '/d OG, ������� ����� ��� �������� �� {time}. ���������� �� �.{id}'},
    dept = {"��������� � ��� �����", "/d OG, ���������, ����� ��� �������� �� {time} �� SFA.", "/d OG, ���������, ����� ��� �������� �� {time} �� SFA."},
    mon = {"���������� (SFA)", '��������� ������ ����� LV - {sklad} ����', '��������� ������ ����� LV - {sklad} ����'},
    monl = {"���������� (LVA)", '����������: LSPD - {lspd} | SFPD - {sfpd} | LVPD - {lvpd} | SFa - {sfa} | FBI - {fbi}', '����������: LSPD - {lspd} | SFPD - {sfpd} | LVPD - {lvpd} | SFa - {sfa} | FBI - {fbi}'},
    ev = {"��������� ���������", '���������� ���������! ������: {kv}, ���������� ����: {mesta}', '���������� ���������! ������: {kv}, ���������� ����: {mesta}'}
  }
}
-- ������� ��� �������� ������, �������
config_keys = {
  punaccept = {v = {key.VK_Y}},
  pundeny = {v = {key.VK_N}},
  targetplayer = {v = {key.VK_R}},
  weaponkey = {v = {key.VK_Z}},
  binder = {
    { text = {"������, ���![noenter]"}, v = {18,89}, time = 1100 },
  },
  cmd_binder = {
    { cmd = "pass", wait = 1100, text = { "������� �����! � {myrankname}, {myfullname}. ���������� ���� ���������." } },
    { cmd = "uinv", wait = 1100, text = { "/uninvite {param} {param2}" } },
    { cmd = "gr", wait = 1100, text = { "/giverank {param} {param2}" } },
    { cmd = "inv", wait = 1100, text = { "/invite {param}" } },
    { cmd = "cl", wait = 1100, text = { "/clist {param}" } },
    { cmd = "rpmask", wait = 1100, text = { "/me ������ ����� �� ������� � ����� �� ����", "/clist 32", "/do �� ���� �����, �� ����� ��� ��������������� ������. �������� �� ��������" } }
  }
}

-- ��� /checkbl, /checkrank
tempFiles = {
  blacklist = {},
  ranks = {},
  vig = {},
  blacklistTime = 0,
  ranksTime = 0,
  vigTime = 0
}
pieMenu = {
  active = 0
}
-- ���� ��� imgui
data = {
  imgui = {
    menu = 1,
    hudpos = false,
    watchpos = false,
    bind = 1,
    lecturetext = {},
    hudpoint = { x = 0, y = 0 },
    lecturetime = imgui.ImInt(3),
  },
  functions = {
    checkbox = {},
    search = imgui.ImBuffer(256),
    frac = imgui.ImBuffer(256),
    radius = imgui.ImInt(15),
    vig = imgui.ImBuffer(256),
    playerid = imgui.ImInt(-1),
    time = imgui.ImInt(1),
    kolvo = imgui.ImInt(1),
    rank = imgui.ImInt(1),
    export = {}
  },
  gov = {
    textarea = {}
  },
  lecture = {
    string = "",
    list = {},
    text = {},
    time = imgui.ImInt(1100)
  },
  shpora = {
    edit = -1,
    loaded = 0,
    page = 0,
    select = {},
    inputbuffer = imgui.ImBuffer(10000),
    search = imgui.ImBuffer(256),
    text = ""
  },
  addtable = {
    nick = imgui.ImBuffer(256),
    param1 = imgui.ImBuffer(256),
    param2 = imgui.ImBuffer(256),
    reason = imgui.ImBuffer(256),
  },
  combo = {
    export = imgui.ImInt(0),
    functions = imgui.ImInt(0),
    gov = imgui.ImInt(0),
    lecture = imgui.ImInt(0),
    post = imgui.ImInt(0),
    addtable = imgui.ImInt(0),
    rpsex = imgui.ImInt(-1),
    rpweap = imgui.ImInt(-1)
  },
  filename = "",
  departament = {},
  punishlog = {},
  players = {},
  members = {}
}
-- ������� ��� �������� ������
postInfo = {
  { name = "���", coordX = -1530.65, coordY = 480.05, coordZ = 7.19, radius = 16.0 },
  { name = "����", coordX = -1334.59, coordY = 477.46, coordZ = 9.06, radius = 11.0 },
  { name = "������", coordX = -1367.36, coordY = 517.50, coordZ = 11.20, radius = 10.0 },
  { name = "����� 1", coordX = -1299.44, coordY = 498.90, coordZ = 11.20, radius = 12.0 },
  { name = "����� 2", coordX = -1410.75, coordY = 502.03, coordZ = 11.20, radius = 14.0 }
}
post = {
  interval = 180,
  lastpost = 0,
  next = 0,
  active = false,
}
-- ���������� ���������
sInfo = {
  updateAFK = 0,
  fraction = "no",
  tazer = false,
  server = "",
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
monitoring = {nil, nil, nil, nil, nil, nil}
-- ������� ��������
punkeyActive = 0
punkey = {
  { nick = nil, time = nil, reason = nil },
  { nick = nil, time = nil, rank = nil },
  { text = nil, time = nil }
}
-- ��������� �������
targetMenu = {
  playerid = nil,
  show = false,
  coordX = 135,
  time = nil,
  cursor = nil
}
-- ��� �������
tEditData = { id = 0, cmd = '', buffer = '', wait = 1100 }
tEditKeys = { id = 0, v = {}, buffer = '', wait = 1100 }
tLastKeys = {}
------------------------------------------------
radioStream = nil
watchFont = renderCreateFont("Arial", 9, 5)
watchList = {}
selectRadio = { id = 1, title = "���� �����", volume = 0.6, url = "", stream = 0 }
changeText = { id = 0, sex = 0, values = {} }
contractId = nil
playersAddCounter = 1
giveDMG = nil
playerMarker = nil
hudSizeY = 190
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
  version = SCRIPT_ASSEMBLY .. (DEBUG_MODE and " (��������)" or ""),
  type = "�������� ����������", -- �������� ����������, ������������� ����������, ����������� ����������, ����
  date = "22.09.2019",
  list = {
    {'��������� �����, ������� �������� ���� ��� ������������ ����. ��������� ��������� ������������, ���� ����������� �������� ���� �����;',
    '��������� ����� - ������� {FF5233}/shradio{FFFFFF}, ���� {FF5233}/sh - �������� - �����;'},
    {'��������� ������� ������������ ������. ������ ����� �������������� ��� ���� ������� � ������ (������ Evolve Rp);'},
    {'��������� ����������� ���������� ��� ���� ��� ��������� /  ������� / ������ � {FF5233}/sh - ��������� - ��������� ���������;'},
    {'������ ����� �������� ��� ��� ���� ����������� � {FF5233}/sh - ��������� - ��������� ����;'},
    {'�������� ������� ������ �� ������� {FF5233}/sh - ������� - ������ ������ && /watch.{FFFFFF} ������ ����� �������� ������� �� ����� � ������� �� ���� ��� ����;'},
    {'�������� ������� ����. ������ ��������� / �������� / ������� ����� ����� ����� � ����.', '��������� ������� ��� �������� �������� ����� - {FF5233}/shnote;'},
    {'������� ������. ���� ��������� � ����� �������� ��� ������� ��� � ����� ������� ��� ��� ���� �������������;', '\n{FF5233}���������'},
    {'������ ����� � ���������� \'������ ����\';'},
    {'������� ������ � ��������� ������ ��������� � ������ �������;'},
    {'�������� ������ ������ � �������� �������;'},
    {'������ ������ ������������ � ��������� Evolve Bot, ��� ��������� ��������� � ������� ����� ���������� �����;'}
  }
}
adminsList = {}
zoness = {}
tCarsName = {"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
"Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BFInjection", "Hunter",
"Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo",
"RCBandit", "Romero","Packer", "Monster", "Admiral", "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed",
"Yankee", "Caddy", "Solair", "Berkley'sRCVan", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RCBaron", "RCRaider", "Glendale", "Oceanic", "Sanchez", "Sparrow",
"Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage",
"Dozer", "Maverick", "NewsChopper", "Rancher", "FBIRancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "BlistaCompact", "PoliceMaverick",
"Boxvillde", "Benson", "Mesa", "RCGoblin", "HotringRacerA", "HotringRacerB", "BloodringBanger", "Rancher", "SuperGT", "Elegant", "Journey", "Bike",
"MountainBike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "hydra", "FCR-900", "NRG-500", "HPV1000",
"CementTruck", "TowTruck", "Fortune", "Cadrona", "FBITruck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight",
"Streak", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada",
"Yosemite", "Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RCTiger", "Flash", "Tahoma", "Savanna", "Bandito",
"FreightFlat", "StreakCarriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "NewsVan",
"Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club", "FreightBox", "Trailer", "Andromada", "Dodo", "RCCam", "Launch", "PoliceCar", "PoliceCar",
"PoliceCar", "PoliceRanger", "Picador", "S.W.A.T", "Alpha", "Phoenix", "GlendaleShit", "SadlerShit", "Luggage A", "Luggage B", "Stairs", "Boxville", "Tiller",
"UtilityTrailer"}
counterNames = {"������� �������", "������� �������", "�������� �������", "��������� ������ (/lecture)", "��������� �� �����", "��������� �� ���", "������ ������� (����)", "��������� ������� (/loc | ����)", "��������� ����", "�������� �� LVa", "�������� �� LSa"}
rankings = { ["SFA"] = true, ["LVA"] = true, ["LSPD"] = true, ["SFPD"] = true, ["LVPD"] = true, ["Instructors"] = true, ["FBI"] = true, ["Medic"] = true, ["Mayor"] = true }
dayName = {"�����������", "�������", "�����", "�������", "�������", "�������", "�����������"}
--------------------------------------------------------------------

function main()
    apply_custom_style()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
    if not doesDirectoryExist("moonloader\\SFAHelper") then createDirectory("moonloader\\SFAHelper") end
    -- ������������� ������
    loggerInit()
    --------------------=========----------------------
    -- ���������� ����������� �������, ������������ �������� ����� �� ����� ����������
    local mstime = os.clock()
    loadFiles()
    while complete ~= true do wait(0) end
    logger.debug(("�������� ��������� | �����: %.3fs"):format(os.clock() - mstime))
    complete = false
    ------
    filesystem.path('moonloader/SFAHelper/accounts/'..sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(playerPed))))
    local isDefined = doesDirectoryExist('moonloader\\SFAHelper\\accounts')
    filesystem.init(filesystem.path())
    if not isDefined then
      -- ��������� ����� �� ������ < 1.4
      filesystem.movefiles(filesystem.path(), 'moonloader/SFAHelper', { "config.json", "keys.json", "posts.json", "punishlog.json" })
    end
    while complete ~= true do wait(0) end
    logger.debug(("������������ �������� | �����: %.3fs"):format(os.clock() - mstime))
    complete = false
    ------
    autoupdate("https://raw.githubusercontent.com/the-redx/Evolve/master/update.json")
    while complete ~= true do wait(0) end
    logger.debug(("�������� ���������� | �����: %.3fs"):format(os.clock() - mstime))
    complete = false
    ------
    loadPermissions("https://docs.google.com/spreadsheets/d/1qmpQvUCoWEBYfI3VqFT3_08708iLaSKPfa-A6QaHw_Y/export?format=tsv&id=1qmpQvUCoWEBYfI3VqFT3_08708iLaSKPfa-A6QaHw_Y&gid=1568566199") -- remove
    while complete ~= true do wait(0) end
    logger.debug(("�������� ���� ������� | �����: %.3fs"):format(os.clock() - mstime))
    complete = false
    --------------------=========----------------------
    ----- ��������� �������
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
    local localjson = filesystem.load('local.json')
    if localjson ~= nil then
      localjson = filesystem.performOld('local.json', localjson)
      logger.trace("Start additionArray to 'localInfo'")
      localInfo = additionArray(localjson, localInfo) 
    end 
    filesystem.save(localInfo, 'local.json')
    ----------
    local postsjson = filesystem.load('posts.json')
    if postsjson ~= nil then
      postsjson = filesystem.performOld('posts.json', postsjson)
      logger.trace("Start additionArray to 'postInfo'")
      postInfo = additionArray(postsjson, postInfo) 
    end
    filesystem.save(postInfo, 'posts.json')
    logger.debug(("��������� ������ ��������� | �����: %.3fs"):format(os.clock() - mstime))
    --------------------=========----------------------
    sampRegisterChatCommand('mon', cmd_mon)
    sampRegisterChatCommand('stime', cmd_stime)
    sampRegisterChatCommand('sweather', cmd_sweather)
    sampRegisterChatCommand('loc', cmd_loc)
    sampRegisterChatCommand('ev', cmd_ev)
    sampRegisterChatCommand('shupd', cmd_sfaupdates)
    sampRegisterChatCommand('blag', cmd_blag)
    sampRegisterChatCommand('cn', cmd_cn)
    sampRegisterChatCommand('stats', cmd_stats)
    -- sampRegisterChatCommand('importscript', function()
    --   scripttext = import('moonloader/SFAHelper/updater.lua')
    -- end)
    -- sampRegisterChatCommand('checkscript', function()
    --   print(tostring(scripttext.mes()))
    -- end)
    sampRegisterChatCommand('watch', cmd_watch)
    sampRegisterChatCommand('r', cmd_r)
    sampRegisterChatCommand('f', cmd_r)
    sampRegisterChatCommand('checkrank', cmd_checkrank)
    sampRegisterChatCommand('checkbl', cmd_checkbl)
    sampRegisterChatCommand('checkvig', cmd_checkvig)
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
    sampRegisterChatCommand('shnote', function()
      window['shpora'].bool.v = not window['shpora'].bool.v
    end)
    sampRegisterChatCommand('shradio', function()
      window['main'].bool.v = not window['main'].bool.v
      data.imgui.menu = 3
    end)
    sampRegisterChatCommand('sfahelper', function() 
      funcc('cmd_sfahelper', 1)
      window['main'].bool.v = not window['main'].bool.v
    end)
    sampRegisterChatCommand('sh', function()
      funcc('cmd_sh', 1)
      window['main'].bool.v = not window['main'].bool.v
    end)
    ----- �������, ��� ������� ���� ���� ��������� �������
    sampRegisterChatCommand('addtable', function()
      if sInfo.fraction ~= "SFA" or pInfo.settings.rank < 12 then
        atext('������� �������� �� ������ ����� � ����')
        return
      end
      if sInfo.server ~= "185.169.134.67:7777" then dtext('������ ������� �� �������� ��� ������ �������') return end
      funcc('cmd_addtable', 1)
      data.combo.addtable.v = 0
      data.addtable.nick.v = ""
      data.addtable.param1.v = ""
      data.addtable.param2.v = ""
      data.addtable.reason.v = ""
      window['addtable'].bool.v = not window['addtable'].bool.v
    end)
    sampRegisterChatCommand('abp', function()
      window['main'].bool.v = true
      data.imgui.menu = 32
    end)
    sampRegisterChatCommand('shud', function()
      funcc('cmd_shud', 1)
      window['hud'].bool.v = not window['hud'].bool.v
      pInfo.settings.hud = not pInfo.settings.hud
      atext(("��� %s"):format(pInfo.settings.hud and "�������" or "��������"))      
    end)
    sampRegisterChatCommand('starget', function()
      funcc('cmd_starget', 1)
      pInfo.settings.target = not pInfo.settings.target
      atext(("Target Bar %s"):format(pInfo.settings.target and "�������" or "��������"))
    end)
    -- �������� ���������� �������
    registerFastCmd()
    logger.debug(("������� ��������� | �����: %.3fs"):format(os.clock() - mstime))
    --------------------=========----------------------
    punacceptbind = rkeys.registerHotKey(config_keys.punaccept.v, true, punaccept)
    -- ��������� ������
    for k, v in ipairs(config_keys.binder) do
      rkeys.registerHotKey(v.v, true, onHotKey)
      if v.time == nil then v.time = 0 end
    end
    logger.debug(("����� ��������� | �����: %.3fs"):format(os.clock() - mstime))
    --------------------=========----------------------
    atext('SFA-Helper ������� �������� (/sh)')
    if DEBUG_MODE then
      atext('�� ����������� �������� ������ - '..SCRIPT_ASSEMBLY)
    end
    local day = os.date("%d.%m.%y")
    if pInfo.info.thisWeek == 0 then pInfo.info.thisWeek = os.date("%W") end
    -- ������� ����� ����
    if pInfo.info.day ~= day and tonumber(os.date("%H")) > 4 and pInfo.info.dayOnline > 0 then
      local weeknum = dateToWeekNumber(pInfo.info.day)
      if weeknum == 0 then weeknum = 7 end
      pInfo.weeks[weeknum] = pInfo.info.dayOnline
      atext(string.format("������� ����� ����. ����� ����������� ��� (%s): %s", pInfo.info.day, secToTime(pInfo.info.dayOnline)))
      -----------------
      -- �������� ����� ����
      if tonumber(pInfo.info.thisWeek) ~= tonumber(os.date("%W")) then
        atext("�������� ����� ������. ����� ���������� ������: "..secToTime(pInfo.info.weekOnline))
        logger.info("�������� ����� ������. ����� ����������: "..secToTime(pInfo.info.weekOnline).."")
        -- ������� ��� ��������, ����� ��������
        for key in pairs(pInfo) do
          if key ~= "settings" and key ~= "gov" and key ~= "func" and key ~= 'ranknames' then
            for k in pairs(pInfo[key]) do
              pInfo[key][k] = 0
            end
          end
        end
        pInfo.info.thisWeek = os.date("%W")
      end
      logger.info("������� ����� ����. ����� �����������: "..secToTime(pInfo.info.dayOnline).."")
      pInfo.info.day = day
      pInfo.info.dayPM = 0
      pInfo.info.dayAFK = 0
      pInfo.info.dayOnline = 0
      pInfo.info.dayWorkOnline = 0
    end
    logger.debug(("������ ������� �������� | �����: %.3fs"):format(os.clock() - mstime))
    while not sampIsLocalPlayerSpawned() do wait(0) end
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    local serverip, serverport = sampGetCurrentServerAddress()
    sInfo.updateAFK = os.time()
    sInfo.authTime = os.date("%d.%m.%y %H:%M:%S")
    sInfo.playerid = myid
    sInfo.nick = sampGetPlayerNickname(myid)
    sInfo.server = serverip..":"..serverport
    sInfo.weapon = getCurrentCharWeapon(PLAYER_PED)
    -- ���� ������ � ������� � �����
    cmd_stats("checkout")
    secoundTimer()
    changeWeapons()
    loadAdmins()
    if pInfo.settings.hud == true then window['hud'].bool.v = true end
    logger.trace(("����� Main �������. | (weekOnline = %d | dayOnline = %d | �����: %.3fs)"):format(pInfo.info.weekOnline, pInfo.info.dayOnline, os.clock() - mstime))
    --------------------=========----------------------
    while true do wait(0)
      -- ���� ����� �������, ����������� ������� ����
      if sampGetGamestate() ~= 3 and sInfo.isWorking == true then
        sInfo.isWorking = false
        logger.warn("����� � �������� ���������")
      end
      -- ���������� ��������������� ����, � ���� ��� ������� ����� �����
      local skip = {false, false}
      for key, val in pairs(window) do
        if val.bool.v and val.draw and skip[1] == false then
          imgui.Process = true
          skip[1] = true
        end
        if val.bool.v and val.cursor and skip[2] == false then
          imgui.ShowCursor = true
          skip[2] = true
        end
      end
      if skip[1] == false then imgui.Process = false end
      if skip[2] == false then imgui.ShowCursor = false end
      -----------
      -- Watch-list
      if pInfo.settings.watchhud and #spectate_list > 0 then
        local checkerheight = renderGetFontDrawHeight(watchFont)
        local count = 0
        renderFontDrawText(watchFont, "{00ff00}������ ������ ["..#watchList.."]:\n", pInfo.settings.watchX, pInfo.settings.watchY, -1)
        watchList = {}
        for k, v in ipairs(spectate_list) do
          if v ~= nil and sampIsPlayerConnected(v.id) then
            local string = ""
            local color = ("%06X"):format(bit.band(sampGetPlayerColor(v.id), 0xFFFFFF))
            local result, ped = sampGetCharHandleBySampPlayerId(v.id)
            if doesCharExist(ped) then
              local mx, my, mz = getCharCoordinates(PLAYER_PED)
              local cx, cy, xz = getCharCoordinates(ped)
              local distance = ("%0.2f"):format(getDistanceBetweenCoords3d(mx, my, mz,cx, cy, xz))
              local forma = "���"
              if sampGetFraktionBySkin(v.id) == "Army" then
                local skin = getCharModel(ped)
                if skin == 252 then forma = "�����"
                else forma = "��" end
              end
              string = ("{%s}%s [%s]{ffffff} - {00BF80}�����: %s{FFFFFF} - {00BF80}Dist: %s"):format(color, v.nick, v.id, forma, distance)
            else
              string = ("{%s}%s [%s]{FFFFFF} - {ec3737}No stream"):format(color, v.nick, v.id)
            end
            count = count + 1
            renderFontDrawText(watchFont, string, pInfo.settings.watchX, pInfo.settings.watchY + (count * checkerheight), -1)
            watchList[#watchList + 1] = string
          end
        end
      end
      -- ����������� watch-list'�
      if data.imgui.watchpos then
        window['hud'].bool.v = true
        sampToggleCursor(true)
        local curX, curY = getCursorPos()
        pInfo.settings.watchX = curX
        pInfo.settings.watchY = curY
      end
      -- ����������� ����
      if data.imgui.hudpos then
        window['hud'].bool.v = true
        sampToggleCursor(true)
        local curX, curY = getCursorPos()
        pInfo.settings.hudX = curX
        pInfo.settings.hudY = curY
      end
      if window['main'].bool.v and (data.imgui.menu == 21 or data.imgui.menu == 22) then
        window['binder'].bool.v = true
      else
        window['binder'].bool.v = false
      end
      -- ��������� ����� ���������� watch-list'�
      if isKeyJustPressed(key.VK_LBUTTON) and data.imgui.watchpos then
        funcc('changeposwatchpos', 1)
        data.imgui.watchpos = false
        if not pInfo.settings.hud then window['hud'].bool.v = false end
        sampToggleCursor(false)
        window['main'].bool.v = true
        filesystem.save(pInfo, 'config.json')
      end
      -- ��������� ����� ���������� ����
      if isKeyJustPressed(key.VK_LBUTTON) and data.imgui.hudpos then
        funcc('changeposhud', 1)
        data.imgui.hudpos = false
        sampToggleCursor(false)
        window['main'].bool.v = true
        filesystem.save(pInfo, 'config.json')
      end
      if selectRadio.stream == 1 and renderStream then
        renderFontDrawText(renderStream, ("%s - %s"):format(selectRadio.streamTitle and selectRadio.streamTitle or "", selectRadio.streamUrl and selectRadio.streamUrl or ""), 150, screeny-20, -1)
      end
      ------------------
      -- ������ ����
      local result, target = getCharPlayerIsTargeting(playerHandle)
      if result then result, player = sampGetPlayerIdByCharHandle(target) end
      if result and isKeyJustPressed(key.VK_MENU) and targetMenu.playerid ~= player then
        funcc('set_target', 1)
        targetPlayer(player)
        targetID = player
      end
      ------------------
      -- ��������� ��������� ����������
      local cx, cy, cz = getCharCoordinates(PLAYER_PED)
      local zcode = getNameOfZone(cx, cy, cz)
      playerZone = getZones(zcode)
      sInfo.armour = getCharArmour(PLAYER_PED)
      sInfo.health = getCharHealth(PLAYER_PED)
      sInfo.interior = getActiveInterior()
      -- ����������� ������
      local citiesList = {'Los-Santos', 'San-Fierro', 'Las-Venturas'}
      local city = getCityPlayerIsIn(PLAYER_HANDLE)
      if city > 0 then playerCity = citiesList[city] else playerCity = "��� �������" end
    end
end

------------------------ CMD ------------------------
-- ��������� ����� ��� ��������
-- ��, ��, ����� ���� ����� sendchat. � ����� ��� ��� ��� ��� �����������, ������� ���.
function cmd_r(args)
  if #args == 0 then
    sampAddChatMessage('�������: /r [�����]', -1)
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
      dtext('������ ������� �����')
      return
    end
    dtext('�������: /match [id]')
    return
  end
  local id = tonumber(args)
  if id == nil then dtext('����� �������!') return end
  if not sampIsPlayerConnected(id) then dtext('����� �������!') return end
  local result, ped = sampGetCharHandleBySampPlayerId(id)
  if not result then dtext('����� ������ ���� � ���� ����������') return end   
  if playerMarker ~= nil then
    removeBlip(playerMarker)
    removeBlip(playerRadar)
    playerMarkerId = nil
  end
  funcc('cmd_match', 1)
  playerMarkerId = id
  playerMarker = addBlipForChar(ped)
  local px, py, pz = getCharCoordinates(ped)
  playerRadar = addSpriteBlipForContactPoint(px, py, pz, 14)
  atext(('������ ���������� �� ������ %s[%d]'):format(sampGetPlayerNickname(id), id))
  atext('����� ������ ������, ������� ������� /match ��� ���')
end

-- ���������� � ��
function cmd_addbl(args)
  if sInfo.blPermissions == false then dtext('��� ������ � ������ �������� ���������� ��������!') return end
  if sInfo.server ~= "185.169.134.67:7777" then dtext('������ ������� �� �������� ��� ������ �������') return end
  if #args == 0 then
    dtext('�������: /addbl [playerid/nick] [������� (1-4)] [��������������] [�������]')
    dtext('��� ����� ������ � �� ��� �������������, ������� \'-\' � ��������������� ����')
    return
  end
  local argSt = string.split(args, " ", 4)
  if argSt[1] == nil then dtext('�������� ID ������!') return end
  if argSt[3] == nil or argSt[4] == nil then dtext("�������� ���������!") return end
  local pid = tonumber(argSt[1])
  local type = tonumber(argSt[2])
  if type == nil or type < 1 or type > 4 then dtext('�������� ���������!') return end
  if sInfo.playerid == pid or sInfo.nick == argSt[1] then dtext('�� �� ������ ������ ���� � ��!') return end
  funcc('cmd_addbl', 1)
  if pid ~= nil then
    if sampIsPlayerConnected(pid) then
      argSt[1] = sampGetPlayerNickname(pid)
    end
  end
  if argSt[3] == "-" then argSt[3] = "����� ������� �����" end
  atext(("���� � ��: [���: %s] [�������: %s] [���-��: %s] [�������: %s]"):format(argSt[1], type, argSt[3], argSt[4]))
  sendGoogleMessage("blacklist", argSt[1], argSt[3], type, argSt[4], os.time())
end

-- ������� ����
function cmd_cchat()
  funcc('cmd_cchat', 1)
  memory.fill(sampGetChatInfoPtr() + 306, 0x0, 25200)
  memory.write(sampGetChatInfoPtr() + 306, 25562, 4, 0x0)
  memory.write(sampGetChatInfoPtr() + 0x63DA, 1, 1)
end

-- ������:
-- lectureStatus == 0 | ������ �� ��������
-- lectureStatus > 0 | ������ ���
-- lectureStatus < 0 | ������ ��������������
function cmd_lecture(args)
  if args == "pause" or args == "1" then
    if lectureStatus == 0 then dtext('������ �� ��������') return end
    lectureStatus = lectureStatus * -1
    if lectureStatus > 0 then dtext('������ ������������')
    else dtext('������ ��������������. ��� ������������� �������: (/lec)ture pause') end
  elseif args == "stop" or args == "0" then
    if lectureStatus == 0 then dtext('������ �� ��������') return end
    lectureStatus = 0
    dtext('����� ������ ���������')
  elseif #args == 0 or args == "start" then
    if #data.lecture.text == 0 then dtext('���� ������ �� ��������! ��������� ��� � (/sh - ������� - ������)') return end
    if data.lecture.time.v == 0 then dtext('����� �� ����� ���� ����� 0!') return end
    if lectureStatus ~= 0 then dtext('������ ��� ��������/�� �����') return end
    atext('����� ������ �������. ��� �����/������ �������: (/lec)ture pause ��� (/lec)ture stop')
    lectureStatus = 1
    funcc('cmd_lecture', 1)
    lua_thread.create(function()
      while true do wait(1)
        if lectureStatus == 0 then break end
        if lectureStatus >= 1 then
          if string.match(data.lecture.text[lectureStatus], "^/r .+") then
            -- /r ������������ ����� ���� ������� ��� ��������
            local bind = string.match(data.lecture.text[lectureStatus], "^/r (.+)")
            local textTag = tags(bind)
            if textTag:len() > 0 then
              cmd_r(textTag)
            end
          else
            local textTag = tags(data.lecture.text[lectureStatus])
            if textTag:len() > 0 then
              sampSendChat(textTag)
            end
          end
          lectureStatus = lectureStatus + 1
        end
        if lectureStatus > #data.lecture.text then
          wait(150)
          lectureStatus = 0
          addcounter(4, 1)
          dtext('����� ������ ��������')
          break 
        end
        wait(tonumber(data.lecture.time.v))
      end
      return
    end)
  else dtext('�������� ��������! ��������� ��������: (/lec)ture, (/lec)ture pause, (/lec)ture stop') end
end

-- ������ �������
function cmd_vig(arg)
  if #arg == 0 then
    dtext('�������: /vig [playerid] [��� �������� (�������/�������)] [�������]')
    return
  end
  local args = string.split(arg, " ", 3)
  if args[2] == nil or args[3] == nil then
    dtext('�������: /vig [playerid] [��� �������� (�������/�������)] [�������]')
    return
  end
  local pid = tonumber(args[1])
  if pid == nil then dtext('�������� ID ������!') return end
  if sInfo.playerid == pid then dtext('�� �� ������ ������� ������ ����!') return end
  if not sampIsPlayerConnected(pid) then dtext('����� �������!') return end
  funcc('cmd_vig', 1)
  cmd_r(localVars("punaccept", "vig", {
    ["id"] = sampGetPlayerNickname(pid):gsub("_", " "),
    ["type"] = args[2],
    ["reason"] = args[3]
  }))
end

-- ��������
function cmd_contract(arg)
  if pInfo.settings.rank < 14 then dtext('������ ������� �������� ���������� � ����') return end
  if #arg == 0 then
    dtext('�������: /contract [playerid] [����]')
    return
  end
  local args = string.split(arg, " ")
  local pid = tonumber(args[1])
  local rank = tonumber(args[2])
  if pid == nil then dtext('�������� ID ������!') return end
  if rank == nil then dtext('�������� ���������!') return end
  if sInfo.playerid == pid then dtext('�� �� ������ ������� ������ ����!') return end
  if not sampIsPlayerConnected(pid) then dtext('����� �������!') return end
  funcc('cmd_contract', 1)
  sampSendChat('/invite '..pid)
  -- ������ ����� ���������� ����� ������� �� ������� � ����
  contractId = pid
  contractRank = rank
end

-- �������������
function cmd_blag(arg)
  if #arg == 0 then
    dtext('�������: /blag [��] [�������] [���]')
    dtext('���: 1 - ������ �� �������, 2 - �� ������� �� ����������, 3 - �� ���������������')
    return
  end
  local args = string.split(arg, " ", 3)
  args[3] = tonumber(args[3])
  if args[1] == nil or args[2] == nil or args[3] == nil then
    dtext('�������: /blag [��] [�������] [���]')
    dtext('���: 1 - ������ �� �������, 2 - �� ������� �� ����������, 3 - �� ���������������')
    return   
  end
  local pid = tonumber(args[1])
  if pid == nil then dtext('����� �� ������!') return end
  if not sampIsPlayerConnected(pid) then dtext('����� �������!') return end
  local blags = {"������ �� �������", "������� � ����������", "���������������"}
  if args[3] < 1 or args[3] > #blags then dtext('�������� ���!') return end
  funcc('cmd_blag', 1)
  sampSendChat(localVars("punaccept", "blag", {
    ["frac"] = args[2],
    ["id"] = string.gsub(sampGetPlayerNickname(pid), "_", " "),
    ["reason"] = blags[args[3]]
  }))
end

-- ��������� ������� � ����
function cmd_stats(args)
  lua_thread.create(function()
    sampSendChat('/stats')
    while not sampIsDialogActive() do wait(0) end
    proverkk = sampGetDialogText()
    local frakc = proverkk:match('.+�����������%:%s+(.+)%s+����')
    local rang = proverkk:match('.+����%:%s+(.+)%s+������')
    local sex = proverkk:match('.+���%:%s+(.+)')
    sInfo.fraction = tostring(frakc)
    if pInfo.settings.sex == nil then
      if sex == "�������" then pInfo.settings.sex = 1
      elseif sex == "�������" then pInfo.settings.sex = 0
      else pInfo.settings.sex = 1 end
    end
    if sInfo.fraction == "nil" then sInfo.fraction = "no" end
    logger.info(('������� ����������: %s'):format(sInfo.fraction))
    logger.info(('��� ���������: %s'):format(pInfo.settings.sex == 1 and "�������" or "�������"))
    if rankings[sInfo.fraction] ~= nil then
      for i = 1, #pInfo.ranknames do
        if pInfo.ranknames[i] == rang then
          pInfo.settings.rank = i
          logger.info(('���� ���������: %s[%d]'):format(rang, pInfo.settings.rank))
          break
        end
        if rang == "���" then
          logger.warn('����� ��� � ����������')
          break
        end
        if i == #pInfo.ranknames then
          logger.warn('���� �� ���������')
        end
      end
    else
      logger.warn('������ ������� �� �������������� ��������. ��������� ������� ����� ���� ����������')
      sInfo.fraction = "no"
      pInfo.settings.rank = 0
    end
    if args == "checkout" then sampCloseCurrentDialogWithButton(1) end
    return
  end)
end

-- ������� ���� ��� ������������
function cmd_createpost(args)
  if #args == 0 then
    dtext('�������: /createpost [�������� �����]')
    return
  end
  local cx, cy, cz = getCharCoordinates(PLAYER_PED)
  for i = 1, #postInfo do
    local pi = postInfo[i]
    if args == pi.name then
      dtext('������ ��� ����� ��� ������!')
      return
    end
    if cx >= pi.coordX - (pi.radius+15) and cx <= pi.coordX + (pi.radius+15) and cy >= pi.coordY - (pi.radius+15) and cy <= pi.coordY + (pi.radius+15) and cz >= pi.coordZ - (pi.radius+15) and cz <= pi.coordZ + (pi.radius+15) then
      dtext(("���� �� ����� ���� ������, �.�. �� �������� � ������ '%s'"):format(pi.name))
      return
    end
  end
  funcc('cmd_createpost', 1)
  logger.info("������ ����� ���� '"..args.."'")
  postInfo[#postInfo+1] = { name = args, coordX = cx, coordY = cy, coordZ = cz, radius = 15.0 }
  filesystem.save(postInfo, 'posts.json')
  atext(("���� '%s' ������� ������. ��� ��������� ��������� � ���� (/sh - ������� - ���������� � ������)"):format(args))
end

-- ���� ������
function cmd_watch(args)
  if #args == 0 then
    dtext('�������: /watch [add/remove] [id] ��� /watch list')
    return
  end
  args = string.split(args, " ")
  if args[1] == "list" then
    local str = "{FFFFFF}���\t{FFFFFF}������� �����\n"
    for i = 1, #spectate_list do
      if spectate_list[i] ~= nil then
        str = str..string.format("%s[%d]\t%s\n", spectate_list[i].nick, spectate_list[i].id, getcolorname(spectate_list[i].clist))
      end  
    end
    sampShowDialog(6121145, "{954F4F}SFA-Helper | {FFFFFF}������ ������", str, "�������", "", DIALOG_STYLE_TABLIST_HEADERS)
  elseif args[1] == "add" then
    if args[2] == nil then dtext('�������� ID ������!') return end
    pid = tonumber(args[2])
    if pid == nil or sInfo.playerid == args[2] then dtext('�������� ID ������!') return end
    if not sampIsPlayerConnected(pid) then dtext('����� �������') return end
    funcc('cmd_watch_add', 1)
    local color = string.format("%06X", ARGBtoRGB(sampGetPlayerColor(pid)))
    table.insert(spectate_list, { id = pid, nick = sampGetPlayerNickname(pid), clist = color })
    dtext(string.format('����� %s[%d] ������� �������� � ������ ������. ������� ����: %s', sampGetPlayerNickname(pid), pid, getcolorname(color)))
  elseif args[1] == "remove" then
    if args[2] == nil then dtext('�������� ID ������!') return end
    pid = tonumber(args[2])
    if pid == nil or sInfo.playerid == args[2] then dtext('�������� ID ������!') return end
    if not sampIsPlayerConnected(pid) then dtext('����� �������') return end
    for i = 1, #spectate_list do
      if spectate_list[i] ~= nil and pid == spectate_list[i].id then
        table.remove(spectate_list, i)
        dtext('����� '..sampGetPlayerNickname(pid)..'['..pid..'] ������� ����� �� ������ ������!')
        return
      end
    end
    dtext('����� �� ������ � ������ ������!')
  else dtext('����������� ��������') end
end

-- �������� ������� �� ���� ������
function cmd_checkrank(arg)
  if sInfo.fraction ~= "SFA" then dtext('������� �������� ������ ������� �� SFA') return end
  if sInfo.isWorking == false then dtext('���������� ������ ������� ����!') return end
  if sInfo.server ~= "185.169.134.67:7777" then dtext('������ ������� �� �������� ��� ������ �������') return end
  if #arg == 0 then
    dtext('�������: /checkrank [id / nick]')
    return
  end
  local id = tonumber(arg)
  if id ~= nil then
    if sampIsPlayerConnected(id) then arg = sampGetPlayerNickname(id)
    else dtext('����� �������!') return end
  end
  if tempFiles.ranksTime >= os.time() - 180 then
    -- ���� �� ����� ��� ��������� ���������� ���������
    for i = #tempFiles.ranks, 1, -1 do
      local line = tempFiles.ranks[i]
      if line.nick == arg or line.nick == string.gsub(arg, "_", " ") then
        funcc('cmd_checkrank', 1)
        dtext('��������� ��������� ������ '..line.nick..':')
        if line.rank1 ~= nil and line.rank2 ~= nil and line.date ~= nil then
          dtext(("� %s �� %s ���� | ����: %s"):format(line.rank1, line.rank2, line.date))
        end
        if line.executor ~= nil and line.reason ~= nil then 
          dtext(("�������: %s | �������: %s"):format(line.executor, u8:decode(line.reason)))
        end
        return
      end  
    end
    dtext('����� �� ������ � ���� ���������!')
    return
  end
  -- ���� �� ��������, ��� ������ ����� 3-� ����� � ������� �������� ����������
  local updatelink = 'https://docs.google.com/spreadsheets/d/1F8uOhtVSMJIvsiJcyOINZOEAh0cc3PK1_m3oPrLlatw/export?format=tsv&id=1F8uOhtVSMJIvsiJcyOINZOEAh0cc3PK1_m3oPrLlatw&gid=0'
  local downloadpath = getWorkingDirectory() .. '\\SFAHelper\\checkrank.tsv'
  sampAddChatMessage('�������� ������...', 0xFFFF00)
  logger.trace("���������� ����������. �������: "..tostring(asyncQueue))
  asyncQueue = true
  httpRequest(updatelink, nil, function(response, code, headers, status)
    if response then
      tempFiles.ranks = {}
      -- ��������� ��� �������� �������, �.�. � ������� ��� �������� � 1 �������
      for line in response:gmatch('[^\r\n]+') do
        -- Ichigo_Kurasaki	1	2	21.03.2019	Jonathan Belin	���������.
        -- .tsv ����� ������������ ������, ������� ���������� �����
        local arr = string.split(line, "\t")
        tempFiles.ranks[#tempFiles.ranks + 1] = { nick = arr[1], rank1 = arr[2], rank2 = arr[3], date = arr[4], executor = arr[5], reason = arr[6] }
      end
      logger.trace("��������� ������ ������� ���������")
      asyncQueue = false
      -- ��������� �����, ������������ � �������
      tempFiles.ranksTime = os.time()
      cmd_checkrank(arg)
    else
      logger.trace("����� ��� ������� � �������")
      asyncQueue = false
    end
  end)
end

-- �������� �� �� ���� ������
function cmd_checkbl(arg)
  if sInfo.fraction ~= "SFA" then dtext('������� �������� ������ ������� �� SFA') return end
  if sInfo.isWorking == false then dtext('���������� ������ ������� ����!') return end
  if sInfo.server ~= "185.169.134.67:7777" then dtext('������ ������� �� �������� ��� ������ �������') return end
  if #arg == 0 then
    dtext('�������: /checkbl [id / nick]')
    return
  end
  local id = tonumber(arg)
  if id ~= nil then
    if sampIsPlayerConnected(id) then arg = sampGetPlayerNickname(id)
    else dtext('����� �������!') return end
  end
  if tempFiles.blacklistTime >= os.time() - 180 then
    -- ���� �� ����� ��� ��������� ��������� ������
    for i = #tempFiles.blacklist, 1, -1 do
      local line = tempFiles.blacklist[i]
      if line.nick == arg or line.nick == string.gsub(arg, "_", " ") then
        funcc('cmd_checkbl', 1)
        local blacklistStepen = { "1 �������", "2 �������", "3 �������", "4 �������", "�� ������", "�������" }
        dtext('����� '..line.nick..' ������ � ������ ������!')
        if line.executor ~= nil and line.date ~= nil then 
          dtext(("���: %s | ����: %s"):format(line.executor, line.date))
        end
        if line.reason ~= nil and line.stepen ~= nil then
          dtext(("�������: %s | �������: %s"):format(blacklistStepen[line.stepen], u8:decode(line.reason)))
        end
        addcounter(9, 1)
        return
      end  
    end
    atext('����� �� ������ � ������ ������!')
    return
  end
  -- ���� �� ��������, ��� ������ ����� 3-� ����� � ������� �������� ����������
  local updatelink = 'https://docs.google.com/spreadsheets/d/1yBkOkDHGgaYqZDW9hY-qG5C5Zr8S3VmEEoFFByazGZ0/export?format=tsv&id=1yBkOkDHGgaYqZDW9hY-qG5C5Zr8S3VmEEoFFByazGZ0&gid=0'
  local downloadpath = getWorkingDirectory() .. '\\SFAHelper\\blacklist.tsv'
  sampAddChatMessage('�������� ������...', 0xFFFF00)
  logger.trace("���������� ����������. �������: "..tostring(asyncQueue))
  asyncQueue = true
  httpRequest(updatelink, nil, function(response, code, headers, status)
    if response then
      -- ��������� ��� �������� �������, �.�. � ������� ��� �������� � 1 �������
      for line in response:gmatch('[^\r\n]+') do
        -- Bernhard_Rogge 	Petr_Byturin	�������	09.09.2019	2
        -- .tsv ����� ������������ ������, ������� ���������� �����
        local arr = string.split(line, "\t")
        local step = arr[5]
        if arr[5] ~= nil then step = arr[5] end
        tempFiles.blacklist[#tempFiles.blacklist + 1] = { nick = arr[2], stepen = tonumber(step), date = arr[4], executor = arr[1], reason = arr[3] }
      end
      logger.trace("��������� ������ ������� ���������")
      asyncQueue = false
      -- ��������� �����, ������������ � �������
      tempFiles.blacklistTime = os.time()
      cmd_checkbl(arg)
    else
      logger.trace("����� ��� ������� � �������")
      asyncQueue = false
    end
  end)
end

-- �������� ������� �� ���� ������
function cmd_checkvig(arg)
  if sInfo.fraction ~= "SFA" then dtext('������� �������� ������ ������� �� SFA') return end
  if sInfo.isWorking == false then dtext('���������� ������ ������� ����!') return end
  if sInfo.server ~= "185.169.134.67:7777" then dtext('������ ������� �� �������� ��� ������ �������') return end
  if #arg == 0 then
    dtext('�������: /checkvig [id / nick]')
    return
  end
  local id = tonumber(arg)
  if id ~= nil then
    if sampIsPlayerConnected(id) then arg = sampGetPlayerNickname(id)
    else dtext('����� �������!') return end
  end
  if tempFiles.vigTime >= os.time() - 180 then
    local count = 0
    for i = 1, #tempFiles.vig do
      local line = tempFiles.vig[i]
      -- tempFiles.vig[#tempFiles.vig + 1] = { executor = arr[1], nick = arr[2], reason = arr[3], date = arr[4], action = arr[5] }
      if line.nick == arg or line.nick == string.gsub(arg, "_", " ") then
        if count == 0 then
          dtext('�������� ������ '..line.nick..':')
        end
        if line.executor ~= nil and line.reason ~= nil then
          dtext(("%d. �����: %s | �������: %s"):format(count + 1, line.executor, u8:decode(line.reason)))
        end
        if line.date ~= nil and line.action ~= nil then 
          dtext(("    ����: %s | �������: %s"):format(line.date, u8:decode(line.action)))
        end
        count = count + 1
      end
    end
    if count == 0 then
      dtext('����� �� ������ � ���� ���������!')
    end
    funcc('cmd_checkvig', 1)
    return
  end
  -- ���� �� ��������, ��� ������ ����� 3-� ����� � ������� �������� ����������
  local updatelink = 'https://docs.google.com/spreadsheets/d/1F8uOhtVSMJIvsiJcyOINZOEAh0cc3PK1_m3oPrLlatw/export?format=tsv&id=1F8uOhtVSMJIvsiJcyOINZOEAh0cc3PK1_m3oPrLlatw&gid=1483322935'
  local downloadpath = getWorkingDirectory() .. '\\SFAHelper\\checkvig.tsv'
  sampAddChatMessage('�������� ������...', 0xFFFF00)
  logger.trace("���������� ����������. �������: "..tostring(asyncQueue))
  asyncQueue = true
  httpRequest(updatelink, nil, function(response, code, headers, status)
    if response then
      tempFiles.vig = {}
      for line in response:gmatch('[^\r\n]+') do
        -- Warc_Awerio	Denis_Unbrokens	������ ��� �������/������������ ���������	03.08.2019 - 13.08.2019	������� ��������� 
        local arr = string.split(line, "\t")
        tempFiles.vig[#tempFiles.vig + 1] = { executor = arr[1], nick = arr[2], reason = arr[3], date = arr[4], action = arr[5] }
      end
      logger.trace("��������� ������ ������� ���������")
      asyncQueue = false
      -- ��������� �����, ������������ � �������
      tempFiles.vigTime = os.time()
      cmd_checkvig(arg)
    else
      logger.trace("����� ��� ������� � �������")
      asyncQueue = false
    end
  end)
end

-- ������ ���������
function cmd_ev(arg)
  if #arg == 0 then
    dtext("�������: /ev [0-1] [���-�� ����]")
    return
  end
  local args = string.split(arg, " ", 2)
  args[1] = tonumber(args[1])
  args[2] = tonumber(args[2])
  if args[2] == nil or args[2] < 1 then
    dtext('�������� ���������� ����!')
    return
  end
  local selectPos = 0
  local kvx = ""
  local X, Y
  local KV = {"�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�"}
  if args[1] == 0 then
    X, Y, _ = getCharCoordinates(playerPed)
  elseif args[1] == 1 then
    result, X, Y, _ = getTargetBlipCoordinatesFixed()
    if not result then dtext('���������� ����� �� �����') return end
  else
    dtext('��������� ��������: 0 - ������� ��������������, 1 - �� �����.')
    return
  end
  funcc('cmd_ev', 1)
  X = math.ceil((X + 3000) / 250)
  Y = math.ceil((Y * - 1 + 3000) / 250)
  Y = KV[Y]
  kvx = (Y.."-"..X)
  cmd_r(localVars("others", "ev", {
    ['kv'] = kvx,
    ['mesta'] = args[2]
  }))
end

function cmd_sweather(arg)
  if #arg == 0 then
    dtext('�������: /sweather [������ 0-45]')
    return
  end    
  local weather = tonumber(arg)
  funcc('cmd_sweather', 1)
  if weather ~= nil and weather >= 0 and weather <= 45 then
    forceWeatherNow(weather)
    atext('������ �������� ��: '..weather)
  else
    dtext('�������� ������ ������ ���� � ��������� �� 0 �� 45.')
  end
end

function cmd_mon(arg)
  if arg == "1" and sInfo.fraction ~= "SFA" and sInfo.fraction ~= "LVA" then dtext('������ � ����� �������� ������ SFA/LVA! ����� ������� ������ � ��������� ��� ������� /mon ��� ����������') return end
  if isCharInArea3d(PLAYER_PED, -1325-5, 492-5, 28-3, -1325+5, 492+5, 28+3, false) then
    if monitoring[4] == nil then dtext('�� ������� �������� ��������� ������!') return end
    ----------
    if arg == "1" then
      cmd_r(localVars('others', 'mon', { ['sklad'] = math.floor(monitoring[4] / 1000) }))
    else
      atext('����������: LVA - '..monitoring[4])
    end
  elseif isCharInArea3d(PLAYER_PED, 219-200, 1822-200, 7-30, 219+200, 1822+200, 7+30, false) then
    if monitoring[1] == nil or monitoring[2] == nil or monitoring[3] == nil or monitoring[4] == nil or monitoring[5] == nil or monitoring[6] == nil then
      dtext('�� ������� �������� ��������� ������!')
      return
    end
    ----------
    if arg == "1" then
      cmd_r(localVars('others', 'mon', {
        ['lspd'] = math.floor(monitoring[1] / 1000),
        ['sfpd'] = math.floor(monitoring[2] / 1000),
        ['lvpd'] = math.floor(monitoring[3] / 1000),
        ['sfa'] = math.floor(monitoring[4] / 1000),
        ['fbi'] = math.floor(monitoring[6] / 1000),
      }))
    else
      atext(('����������: LSPD - %d | SFPD - %d | LVPD - %d | SFA - %d | LSP - %d | FBI - %d'):format(math.floor(monitoring[1] / 1000), math.floor(monitoring[2] / 1000), math.floor(monitoring[3] / 1000), math.floor(monitoring[4] / 1000), math.floor(monitoring[5] / 1000), math.floor(monitoring[6] / 1000)))
    end
  else
    dtext('�� ������ ���������� � �����/�� ���������� LVA!')
    return
  end
end

function cmd_stime(arg)
  if #arg == 0 then
    dtext('�������: /stime [����� 0-23 | -1 �����������]')
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
      atext('����� �������� ��: '..time)
    end
    funcc('cmd_stime', 1)
  else
    dtext('�������� ������� ������ ���� � ��������� �� 0 �� 23.')
    patch_samp_time_set(false)
    time = nil
  end
end

function cmd_punishlog(nick)
  if #nick == 0 then
    dtext('�������: /punishlog [id / nick]')
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
          window['main'].bool.v = true
          data.imgui.menu = 41
          atext('�����: '..count..' ���������')
          return
        else
          atext('������ �� �������!')
        end
      else dtext('��������� ������') end
    end)     
  else
    dtext('������ �� �������!')
    local fa = io.open(filesystem.path().."/punishlog.json", "w")
    fa:write("[]")
    fa:close()
  end
end

function cmd_rpweap(arg)
  if #arg == 0 then
    dtext('�������: /rpweap [���]')
    dtext('����: 0 - ���������, 1 - ������ �� ������� �������, 2 - ������ ��� ����� ������, 3 - ��� ����� � �� �������')
    return
  end
  arg = tonumber(arg)
  if arg == nil then dtext('�������� ��������!') return end
  if arg > 3 or arg < 0 then dtext('�������� ����� ���� �� 0 �� 3') return end
  funcc('cmd_rpweap', 1)
  pInfo.settings.rpweapons = arg
  if arg == 0 then atext('�� ��������� ��� ����� ������ ���������')
  elseif arg == 1 then atext('�� ��������� ������� ������ ��� ������� �� �������')
  elseif arg == 2 then atext('�� ��������� ������� ������ ��� ����� ������')
  elseif arg == 3 then atext('�� ��������� ������� ��� ����� ������ ��� ������� �� �������') end
end

-- ������ ��������������
function cmd_loc(args)
  args = string.split(args, " ")
  if #args ~= 2 then
    dtext('�������: /loc [id/nick] [�������]')
    return
  end
  local name = args[1]
  local rnick = tonumber(name)
  if rnick ~= nil then
    if rnick == sInfo.playerid or name == sInfo.nick then dtext('�����: ������ ����������� � ������ ����, �������') return end
    if sampIsPlayerConnected(rnick) then name = sampGetPlayerNickname(rnick)
    else dtext('����� �������') return end
  end
  funcc('cmd_loc', 1)
  cmd_r(localVars("punaccept", "loc", {
    ['nick'] = string.gsub(name, "_", " "),
    ['sec'] = args[2]
  }))
  addcounter(8, 1)
end

-- �������� ����
function cmd_cn(args)
  if #args == 0 then dtext("�������: /cn [id] [0 - RP nick, 1 - NonRP nick]") return end
  args = string.split(args, " ")
  if #args == 1 then
    cmd_cn(args[1].." 0")
  elseif #args == 2 then
    local getID = tonumber(args[1])
    if getID == nil then dtext("�������� ID ������!") return end
    if not sampIsPlayerConnected(getID) then dtext("����� �������!") return end 
    getID = sampGetPlayerNickname(getID)
    if tonumber(args[2]) == 1 then
      dtext("��� \""..getID.."\" ���������� � ����� ������")
    else
      getID = string.gsub(getID, "_", " ")
      dtext("�� ��� \""..getID.."\" ���������� � ����� ������")
    end
    funcc('cmd_cn', 1)
    setClipboardText(getID)
  else
    dtext("�������: /cn [id] [0 - RP nick, 1 - NonRP nick]")
    return
  end 
end

-- ������ ��������, ����� �������� ����� �� ��������
function cmd_adm()
  if sInfo.nick == "FAlfals" or sInfo.nick == "Chase_Yanetto" or sInfo.nick == "Sayz_Armstrong" then return end
  sampAddChatMessage(' ������ Online:', 0xFFFF00)
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

-- ���������
function cmd_reconnect(args)
  if #args == 0 then
    dtext('�������: /reconnect [�������]')
    return
  end
  args = tonumber(args)
  if args == nil or args < 1 then
    dtext('�������� ��������!')
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

-- �������
function cmd_members(args)
  if args == "1" and isGosFraction(sInfo.fraction) then
    membersInfo.mode = 1
    funcc('cmd_members_1', 1)
  elseif args == "2" and isGosFraction(sInfo.fraction) then
    membersInfo.players = {}
    membersInfo.work = 0
    membersInfo.imgui = imgui.ImBuffer(256)
    membersInfo.nowork = 0
    membersInfo.mode = 2
    window['members'].bool.v = true
    funcc('cmd_members_2', 1)
  else
    funcc('cmd_members_none', 1)
    membersInfo.mode = 0
  end
  sampSendChat('/members')
end

function cmd_sfaupdates()
  local str = "{FFFFFF}���: {FF5233}"..updatesInfo.type.."\n{FFFFFF}������ �������: {FF5233}"..updatesInfo.version.."\n{FFFFFF}���� ������: {FF5233}"..updatesInfo.date.."{FFFFFF}\n\n"
  for i = 1, #updatesInfo.list do
    str = str.."{FF5233}-{FFFFFF}"
    for j = 1, #updatesInfo.list[i] do
      str = string.format("%s %s%s\n", str, j > 1 and " " or "", updatesInfo.list[i][j])
    end
  end
  funcc('cmd_sfaupdates', 1)
  sampShowDialog(61315125, "{954F4F}SFA-Helper | {FFFFFF}������ ����������", str, "�������", "", DIALOG_STYLE_MSGBOX)
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
            sampSendChat(localVars('rpguns', tostring(weapon), {}))
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
      -- ������
      if playerMarker ~= nil then
        if doesBlipExist(playerMarker) and doesBlipExist(playerRadar) then
          local result, ped = sampGetCharHandleBySampPlayerId(playerMarkerId)
          if result then
            local sx, sy, sz = getCharCoordinates(ped)
            local result2 = setBlipCoordinates(playerRadar, sx, sy, sz)
          end
        else
          atext('����� ������� ���� ����������. ������ ��������')   
          removeBlip(playerMarker)
          removeBlip(playerRadar)
          playerMarker = nil
          playerRadar = nil
        end
      end
      -- �������� �������
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
      -- ����������
      if post.active == true and sInfo.isWorking == true then
        local cx, cy, cz = getCharCoordinates(PLAYER_PED)
        for i = 1, #postInfo do
          local pi = postInfo[i]
          if cx >= pi.coordX - pi.radius and cx <= pi.coordX + pi.radius and cy >= pi.coordY - pi.radius and cy <= pi.coordY + pi.radius and cz >= pi.coordZ - pi.radius and cz <= pi.coordZ + pi.radius then
            if pi.name == "���" then addcounter(6, 1)
            else addcounter(5, 1) end
            if post.lastpost ~= i then
              punkeyActive = 3
              punkey[3].text = localVars("post", "start", { ['post'] = pi.name })
              punkey[3].time = os.time()
              dtext(("������� {139904}%s{FFFFFF} ��� ���������� �� ����������� �� ���� '%s'"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + "), pi.name))
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
              cmd_r(localVars("post", "doklad", {
                ['post'] = pi.name,
                ['count'] = count
              }))
              post.next = 0
            end
            post.next = post.next + 1
            break
          elseif post.lastpost == i then
            punkeyActive = 3
            punkey[3].text = localVars("post", "ends", { ['post'] = pi.name })
            punkey[3].time = os.time()
            dtext(("������� {139904}%s{FFFFFF} ��� ���������� �� ����� � ����� '%s'"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + "), pi.name))
            post.lastpost = 0
          end
        end      
      end
      wait(1000)  
    end
    return
  end)
end

-- imgui.ImVec2(320, 190)
-- 320x115
-- ����� ������ ����
function targetPlayer(id)
  if pInfo.settings.target ~= true then return end
  id = tonumber(id)
  if id == nil or not sampIsPlayerConnected(id) then dtext('Target Error: ����� �� ������!') return end 
  window['target'].bool.v = true
  targetMenu = {
    playerid = id,
    time = os.time(),
    show = true,
    cursor = false,
    coordX = pInfo.settings.hudX + 160,
    coordY = pInfo.settings.hudY + (data.imgui.hudpoint.y / 2)
  }
  -- hudpoint
  -- ����� ���� ����, ���� ����� �� �������, �������� �����.
  targetMenu.slide = "bottom"
  if screeny < pInfo.settings.hudY + data.imgui.hudpoint.y + 10 + 115 then targetMenu.slide = "top" end
  lua_thread.create(function()
    while true do
      wait(150)
      if targetMenu.playerid ~= id then return end -- ������� ������ �����
      if targetMenu.time < os.time() - 5 then -- ������� �����, ������� ��������� ����� 5 ������
        targetMenu.show = false
        -- �������� ��� ��������
        wait(500)
        window['target'].bool.v = false
        targetMenu.playerid = nil
        targetMenu.time = nil
        return
      end
    end
    return
  end)
end

-- ��������
function punaccept()
  if sInfo.isWorking == false then return end
  if punkeyActive == 0 then return
  elseif punkeyActive == 1 then
    if punkey[1].nick then
      if punkey[1].time > os.time() - 1 then dtext("�� �����!") return end
      if punkey[1].time > os.time() - 15 then
        funcc('punkey_uninvite', 1)
        cmd_r(localVars('rp', 'uninviter', {
          ['nick'] = string.gsub(punkey[1].nick, "_", " "),
          ['reason'] = punkey[1].reason
        }))
      end
      punkey[1].nick, punkey[1].reason, punkey[1].time = nil, nil, nil
    end
  elseif punkeyActive == 2 then
    if punkey[2].nick then
      if punkey[2].time > os.time() - 1 then dtext("�� �����!") return end
      if punkey[2].time > os.time() - 15 then
        funcc('punkey_giverank', 1)
        sampSendChat(localVars("rp", "giverank", {
          ['type'] = punkey[2].rank > 6 and "������" or "�����",
          ['rankname'] = pInfo.ranknames[punkey[2].rank]
        }))
      end
      punkey[2].nick, punkey[2].rank, punkey[2].time = nil, nil, nil
    end
  elseif punkeyActive == 3 then
    if punkey[3].text ~= nil then
      if punkey[3].time > os.time() - 1 then dtext("�� �����!") return end
      if punkey[3].time > os.time() - 15 then
        funcc('punkey_autopostavki', 1)
        cmd_r(punkey[3].text)
        --------
        if punkey[3].text:match("��������� %- 300%/300") then
          punkeyActive = 3
          punkey[3].text = localVars("autopost", "ends", { ['id'] = sInfo.playerid })
          punkey[3].time = os.time()
          dtext(("������� {139904}%s{FFFFFF} ��� ���������� � ����� �� ��������� ��������"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + ")))
          return
        end
      end
      punkey[3].text, punkey[3].time = nil, nil
    end
  end
  punkeyActive = 0
end

-- ��������� ������� �� �����
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
  logger.info("��������� "..count.." �������")
end

-- ��������� ����������� �����
function loadFiles()
  lua_thread.create(function()
    local files = {}
    local direct = {}
    ----------
    if not lpie then files[#files + 1] = 'imgui_piemenu.lua' end
    if not lbass then files[#files + 1] = 'bass.lua' end
    if not lcopas or not lhttp then
      direct[#direct + 1] = 'copas'
      files[#files + 1] = 'copas.lua'
      files[#files + 1] = "copas/ftp.lua"
      files[#files + 1] = 'copas/http.lua'
      files[#files + 1] = 'copas/limit.lua'
      files[#files + 1] = 'copas/smtp.lua'
      files[#files + 1] = 'requests.lua'
    end
    ----------------------------
    --- �������� ���������
    ----------------------------
    if #files > 0 or #direct > 0 then
      dtext('������������� ����������� ����������...')
      for k, v in pairs(direct) do if not doesDirectoryExist("moonloader/lib/"..v) then createDirectory("moonloader/lib/"..v) end end
      for k, v in pairs(files) do
        copas_download_status = 'proccess'
        downloadUrlToFile('https://raw.githubusercontent.com/the-redx/Evolve/master/lib/'..v, 'moonloader/lib/'..v, function(id, status, p1, p2)
          if status == dlstatus.STATUS_DOWNLOADINGDATA then
            copas_download_status = 'proccess'
            print(string.format('��������� %d �������� �� %d ��������.', p1, p2))
          elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
            copas_download_status = 'succ'
          elseif status == 64 then
            copas_download_status = 'failed'
          end
        end)
        while copas_download_status == 'proccess' do wait(0) end
        if copas_download_status == 'failed' then
          dtext('�� ������� ��������� ���������� '..v)
          reloadScriptsParam = true
          thisScript():unload()
          return
        else
          print(v..' ��� ��������')
        end
      end
      reloadScriptsParam = true    
    end
    ------------------------
    if not doesDirectoryExist("moonloader\\SFAHelper\\lectures") then
      createDirectory("moonloader\\SFAHelper\\lectures")
      local file = io.open('moonloader/SFAHelper/lectures/firstlecture.txt', "w+")
      file:write("������� ���������\n/s ��������� � ������\n/b ��������� � b ���\n/rb ��������� � �����\n/w ��������� �������")
      file:flush()
      file:close()
      file = nil
    end
    if not doesDirectoryExist("moonloader\\SFAHelper\\shpora") then
      createDirectory("moonloader\\SFAHelper\\shpora")
      local file = io.open('moonloader/SFAHelper/shpora/������ �����.txt', "w+")
      file:write("�������� ���� ��������� �� ������ � ����� 'moonloader/SFAHelper/shpora'")
      file:flush()
      file:close()
      file = nil
    end
    if reloadScriptsParam then
      dtext('��� ����������� ���������� ���� ���������')
      reloadScripts()
      return
    end
    complete = true
    return
  end)
end

-- ������ �������� ����������
function loadPermissions(table_url)
  local nick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(playerPed)))
  logger.trace("��������� ����� �������. �������: "..tostring(asyncQueue))
  asyncQueue = true
  httpRequest(table_url, nil, function(response, code, headers, status)
    if response then
      for line in response:gmatch('[^\r\n]+') do
        if line:match("^blacklist\t"..nick.."$") then
          sInfo.blPermissions = true
        end
      end
      logger.trace("����� ������������� ������� ���������")
      complete = true
      asyncQueue = false
      return
    else
      logger.trace("����� ������������� �� ���������")
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
  ------- ���������� --------
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

-- ��������������
function autoupdate(json_url)
  logger.debug("��������� ������� ����������. �������: "..tostring(asyncQueue))
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
      logger.debug('������ �� �������: '..tostring(updateversion))
      if updateversion > thisScript().version then
        lua_thread.create(function()
          atext('���������� ����������. ������� ���������� c "'..SCRIPT_ASSEMBLY..'" �� "'..updateversiontext..'"')
          logger.info("���������� ����������. ������: "..updateversiontext)
          wait(250)
          local dlstatus = require('moonloader').download_status
          downloadUrlToFile(updatelink, thisScript().path,
            function(id, status, p1, p2)
              if status == dlstatus.STATUS_DOWNLOADINGDATA then
                print(string.format('��������� %d �� %d.', p1, p2))
              elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
                logger.info('�������� ���������� ������� ���������')
                atext('���������� ���������. ����������� ������ ���������: /shupd')
                goupdatestatus = true
                lua_thread.create(function()
                  wait(500)
                  reloadScriptsParam = true
                  thisScript():reload()
                end)
              end
              if status == dlstatus.STATUSEX_ENDDOWNLOAD then
                if goupdatestatus == nil then
                  logger.warn('���������� ������ ��������')
                  atext('���������� ������ ��������. �������� ���������� ������..')
                  complete = true
                end
              end
            end
          )
          return
        end)
      else logger.info("��������� ���������� ���") complete = true end
      asyncQueue = false 
    else
      logger.warn("����� ��� ������� � �������")
      asyncQueue = false
      atext('�� ������� ��������� ����������')
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

-- ��� �� ����� ���� �������
function sampevents.onSetPlayerColor(player, color)
  color = ("%06X"):format(bit.rshift(color, 8))
  for i = 1, #spectate_list do
    if spectate_list[i] ~= nil then
      if player == spectate_list[i].id  and spectate_list[i].clist ~= color then
        atext(string.format('����� %s[%d] ������ ���� ���� � %s �� %s', spectate_list[i].nick, spectate_list[i].id, getcolorname(spectate_list[i].clist), getcolorname(color)))
        spectate_list[i].clist = color
        return
      end
    end
  end
end

-- ��� �� ����� ������ �� ����
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
        dtext(string.format('����� %s[%d] ����� �� ����. ��������� �����: %s', spectate_list[i].nick, playerid, getcolorname(spectate_list[i].clist)))
        table.remove(spectate_list, i)
        break
      end
    end
  end
end

-- ����-��
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
          sampSendChat(localVars("autobp", "abp", {}))
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

--[[function sampevents.onPlayerDeath(playerid)
  if giveDMG == playerid and giveDMGSkin ~= nil and giveDMGTime >= os.time() - 1 then
    -----------------
    -- ����� ���� ��� �������� �� �����
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
        punkey[3].text = ("����: �%s�. ���������� ������: %d. ���������: code 3"):format(pi.name, count)
        punkey[3].time = os.time()
        atext(("������� {139904}\"%s\"{FFFFFF} ��� ���������� �� ��������� �����"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + ")))
      end
    end
    giveDMG, giveDMGTime, giveDMGSkin = nil, nil, nil
  end
end]]

-- ����-�����
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

function sampevents.onSendClientJoin(version, mod, nick)
  lua_thread.create(function()
    while not sampIsLocalPlayerSpawned() do wait(0) end
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    local serverip, serverport = sampGetCurrentServerAddress()
    sInfo.authTime = os.date("%d.%m.%y %H:%M:%S")
    sInfo.playerid = myid
    sInfo.nick = nick
    sInfo.server = serverip..":"..serverport
    logger.debug(("NICK: %s | ID: %d | SERVER: %s"):format(sInfo.nick, sInfo.playerid, sInfo.server))    
  end)
end

-- ����� ������� ��� �� ������ ����
function sampevents.onServerMessage(color, text)
  if pInfo.settings.chatconsole then sampfuncsLog(tostring(text)) end
  local date = os.date("%d.%m.%y %H:%M:%S")
  local file = io.open('moonloader/SFAHelper/chatlog.txt', 'a+')
  file:write(('[%s] %s\n'):format(date, tostring(text)))
  file:close()
  file = nil
  -- chatID fix. ������� ��� ID ����� ���� ������
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
  if isGosFraction(sInfo.fraction) then
    if text:match("^ ����� ����������� ��%-����:$") then
      data.members = {}
      membersInfo.work = 0
      membersInfo.nowork = 0
      if membersInfo.mode >= 2 then return false end
    end
    if text:match("^ �����: %d+ �������$") then
      membersInfo.online = tonumber(text:match("^ �����: (%d+) �������$"))
      if membersInfo.mode >= 2 then membersInfo.mode = 0 return false end
      membersInfo.mode = 0
    end
    if text:match("") and color == -1 and membersInfo.mode >= 2 then return false end
    -----------------
    if text:match("^ ID: %d+ | .- | .-%: .-%[%d+%] %- {.+}.+{FFFFFF} | {FFFFFF}%[AFK%]%: .+ ������$") then
      local id, date, nick, rankname, rank, status, afk = text:match("^ ID: (%d+) | (.-) | (.-)%: (.-)%[(%d+)%] %- (.+){FFFFFF} | {FFFFFF}%[AFK%]%: (.+) ������$")
      id = tonumber(id)
      rank = tonumber(rank)
      if pInfo.ranknames[rank] ~= rankname then
        pInfo.ranknames[rank] = rankname
      end
      if status == "{008000}�� ������" then 
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
        -- ������� ���� �������
        if pInfo.settings.membersdate == true then
          text = ("ID: %d | %s: %s[%d] - %s{FFFFFF} | [AFK]: %s ������"):format(id, sampGetPlayerNickname(id), pInfo.ranknames[rank], rank, status and "{008000}�� ������" or "{ae433d}��������", afk)
        end
        if id == sInfo.playerid then sampAddChatMessage(text, sampGetPlayerColor(id))
        else sampAddChatMessage(string.format("%s - %s", text, streamed and "{00BF80}in stream" or "{ec3737}not in stream"), sampGetPlayerColor(id)) end
        return false
      elseif membersInfo.mode == 2 then
        membersInfo.players[#membersInfo.players + 1] = { mid = id, mrank = rank, mstatus = status, mafk = afk }
        return false
      end
    elseif text:match("^ ID: %d+ | .+%[%d+%] %- {.+}.+{FFFFFF}$") then
      local id, date, nick, rankname, rank, status = text:match("^ ID: (%d+) | (.-) | (.-)%: (.-)%[(%d+)%] %- (.+){FFFFFF}$")
      id = tonumber(id)
      rank = tonumber(rank)
      if pInfo.ranknames[rank] ~= rankname then
        pInfo.ranknames[rank] = rankname
      end
      if status == "{008000}�� ������" then 
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
          text = ("ID: %d | %s: %s[%d] - %s{FFFFFF}"):format(id, sampGetPlayerNickname(id), pInfo.ranknames[rank], rank, status and "{008000}�� ������" or "{ae433d}��������")
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
  -- ����������� ������ �������� ���
  if text:match("������� ���� �����") and color == 1687547391 then
    sInfo.isWorking = true
    if pInfo.settings.clist ~= nil then
      lua_thread.create(function() wait(250) sampSendChat('/clist '..pInfo.settings.clist) end)
    end
    logger.info('������� ���� �����')
  end
  -- ����������� ����� �������� ���
  if text:match("������� ���� �������") and color == 1687547391 then
    sInfo.isWorking = false
    logger.info('������� ���� �������')
  end
  -- /giverank
  if text:match("�� ��������� .+ .+%[%d+%]") and color == -1697828097 then
    local pNick, _, pRank = text:match("�� ��������� (.+) (.+)%[(%d+)%]")
    addcounter(3, 1)
    lua_thread.create(function()
      wait(100)
      if sInfo.isWorking and tonumber(pRank) > 1 then
        punkeyActive = 2
        punkey[2].nick = pNick
        punkey[2].time = os.time()
        punkey[2].rank = tonumber(pRank)
        dtext(("������� {139904}%s{FFFFFF} ��� �� ��������� ���������"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + ")))
      end
      return
    end)
  end
  -- /invite
  if text:match(".+ �������%(%- �%) ����� .+") and color == -1029514582 then
    local kto, kogo = text:match("(.+) �������%(%- �%) ����� (.+)")
    if kto == sInfo.nick then
      -- ���� ��� �����������, ��������
      if sampGetPlayerNickname(contractId) == kogo then
        lua_thread.create(function()
          wait(250)
          sampSendChat(("/giverank %s %s"):format(contractId, contractRank))
          contractId = nil
          contractRank = nil
          return
        end)
      end
      addcounter(1, 1)
    elseif kogo == sInfo.nick then
      sInfo.isWorking = true
      logger.debug('��� �������. ��������� ���� � �������')
      cmd_stats("checkout")
    end  
  end
  if text:match("��������� ��������� �� ���� 51") and color == -86 then -- ���������� �� �������, ���� � ���
    if pInfo.settings.autodoklad == true then
      punkeyActive = 3
      punkey[3].text = localVars("autopost", "load", { ['id'] = sInfo.playerid })
      punkey[3].time = os.time()
      dtext(("������� {139904}%s{FFFFFF} ��� ���������� � �����"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + ")))
    end
  end
  if text:match("�� ������ ���� 51 %d+/300000 ����������") and color == -65366 then -- ����������� �� ���
    addcounter(10, 1)
    if pInfo.settings.autodoklad == true then
      local materials = tonumber(text:match("�� ������ ���� 51 (%d+)/300000 ����������"))
      punkeyActive = 3
      punkey[3].text = localVars("autopost", "unload", { ['id'] = sInfo.playerid, ['sklad'] = math.floor((materials / 1000) + 0.5) })
      punkey[3].time = os.time()
      dtext(("������� {139904}%s{FFFFFF} ��� ���������� � �����"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + ")))
    end
  end
  if text:match("������������� �� ������� ��� �������� ����������") then
    if pInfo.settings.autodoklad == true then
      if color == -1697828182 then -- ��� � �������� �� ���
        punkeyActive = 3
        punkey[3].text = localVars("autopost", "start", { ['id'] = sInfo.playerid })
        punkey[3].time = os.time()
        dtext(("������� {139904}%s{FFFFFF} ��� ���������� �� ������ ��������"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + ")))
      elseif color == -86 then -- ��� � �������� �� ���
        if isCharInArea2d(PLAYER_PED, 2720.00 + 150, -2448.29 + 150, 2720.00 - 150, -2448.29 - 150, false) then
          punkeyActive = 3
          punkey[3].text = localVars("autopost", "startp")
          punkey[3].time = os.time()
          dtext(("������� {139904}%s{FFFFFF} ��� ���������� �� ������ ��������"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + ")))         
        end
      end
    end
  end
  --[[if text:match("��������� ��������� � LSA") and color == -86 then -- ���������� �� �������, ���� � ���
    if pInfo.settings.autodoklad == true then
      --cmd_r("���������� �� �������, ���� �� ���")
    end
  end]]
  if text:match("�� ������ LSA %d+/200000 ����������") and color == -86 then -- ����������� �� ���
    addcounter(11, 1)
    if pInfo.settings.autodoklad == true then
      local materials = tonumber(text:match("�� ������ LSA (%d+)/300000 ����������"))
      punkeyActive = 3
      punkey[3].text = localVars("autopost", "endp")
      punkey[3].time = os.time()
      dtext(("������� {139904}%s{FFFFFF} ��� ���������� � ����� �� ��������� ��������"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + ")))
    end
  end
  -- /uninvite
  if text:match("�� ������� .+ �� �����������. �������: .+") and color == 1806958506 then
    local pNick, pReason = text:match("�� ������� (.+) �� �����������. �������: (.+)")
    if sInfo.isWorking then
      addcounter(2, 1)
      lua_thread.create(function()
        wait(1250)
        sampSendChat(localVars("rp", "uninvite", { ['nick'] = string.gsub(pNick, "_", " ") }))
        wait(100)
        punkeyActive = 1
        punkey[1].nick = pNick
        punkey[1].time = os.time()
        punkey[1].reason = pReason
        dtext(("������� {139904}%s{FFFFFF} ���������� � ����� �� ����������"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + ")))
        return 
      end)
    end
  end
  -- /pm
  if text:match('^ ����� �� .+ � .+:') then
    local mynick, egonick = text:match('^ ����� �� (.+) � (.+):')
    if mynick == sInfo.nick then
      pInfo.info.dayPM = pInfo.info.dayPM + 1
      pInfo.info.weekPM = pInfo.info.weekPM + 1
    end
    if sInfo.isSupport == false then sInfo.isSupport = true end
  end
  -- ����������� /sduty
  if text:match('������� ���� �����') and color == -1 then
    sInfo.isSupport = true
    funcc('supports', 1)
  end
  if text:match('������� ���� �������') and color == -1 then sInfo.isSupport = false end
  ---------
  if text:match("�� �������� ���� �� ���������") then
    sInfo.tazer = true
  end
  if text:match("�� �������� ���� �� �������") then
    sInfo.tazer = false
  end
  if text:match(".+ ������ ��� �� �����������. �������: .+") then
    pInfo.settings.rank = 0
    sInfo.isWorking = false
    logger.debug('��� �������. ���� ���������')
  end
  if text:match(".+ �������� ��� .+%[.+%]") then
    if sInfo.isWorking == true then
      pInfo.settings.rank = tonumber(select(3, text:match("(.+) �������� ��� (.+)%[(.+)%]$")))
      logger.debug('��� ��������. ����: '..pInfo.settings.rank)
    end
  end
  -- ����� �������
  if color == -1920073984 then
    if sInfo.isWorking == false then
      sInfo.isWorking = true
      logger.info("�������� ������ �������, ������� ���� �����.")
    end
    if text:match("Eduardo_Carmone") and text:match("!getVersion") then
      sampSendChat("/rb "..SCRIPT_ASSEMBLY)
    end
    lua_thread.create(function()
      local tt = rusLower(text)
      if tt:match("�����") or tt:match('��������������') or tt:match('�������') or tt:match('������') or tt:match('����������') or tt:match('������') or tt:match('�������') or tt:match('��������������') then
        pushradioLog(text)
      end
    end)
  end
  -- ������ ������������
  if color == -8224086 then
    if sInfo.isWorking == false then
      sInfo.isWorking = true
      logger.info("�������� ������ �������, ������� ���� �����.")
    end
    if text:match("^ %[.+%] .+ %w+_%w+:") then
      local frac, rank, name, surname = text:match("^ %[(.+)%] (.+) (%w+)_(%w+):")
      data.players[#data.players + 1] = { nick = tostring(name.."_"..surname), rank = tostring(rank), fraction = tostring(frac) }
    end
    table.insert(data.departament, text)
  end
  -- ��������
  if color == -169954390 then
    if text:match("���: .+") then
      local name = text:match("���: (.+)")
      playersAddCounter = #data.players + 1
      data.players[playersAddCounter] = { nick = name }
    end
    if text:match("�������: .+  ���������: .+") then
      local frac, rk = text:match("�������: (.+)  ���������: (.+)")
      data.players[playersAddCounter] = { nick = data.players[playersAddCounter].nick, rank = rk, fraction = frac }
    end
  end
end

function onScriptTerminate(scr, quitGame)
  if scr == script.this then
    if radioStream ~= nil then bass.BASS_StreamFree(radioStream) end
    if not quitGame and reloadScriptsParam == false then
      showCursor(false)
      logger.fatal(string.format('���������� �������. �������: ', quitGame == true and "����� �� ����" or "�������������� ���������� / ����"))
      logger.fatal("��� ������������ ������ ����������� Ctrl + R, ���� ����������� � ����")
    end
  end
end

function sampevents.onCreate3DText(id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text)
  if color == -65281 then
    local newtext = text:gsub('{33AA33}', '')
    newtext = newtext:gsub('{FFFFFF}', '')    
    if isCharInArea3d(PLAYER_PED, -1325-15, 492-15, 28-3, -1325+15, 492+15, 28+3, false) then
      local mon = newtext:match('����� ����� LV%: (%d+)')
      if mon ~= nil then
        monitoring[4] = tonumber(mon)
      end
    end
    if isCharInArea3d(PLAYER_PED, 219-200, 1822-200, 7-30, 219+200, 1822+200, 7+30, false) then
      local pols, posf, polv, sfa, lsp, fbi = newtext:match('����� ������� LS%: (%d+)\n����� ������� SF%: (%d+)\n����� ������� LV%: (%d+)\n����� ����� SF%: (%d+)\n����� ����� LS%: (%d+)\n����� FBI%: (%d+)')
      if pols ~= nil and posf ~= nil and polv ~= nil and sfa ~= nil and lsp ~= nil and fbi ~= nil then
        monitoring[1] = tonumber(pols)
        monitoring[2] = tonumber(posf)
        monitoring[3] = tonumber(polv)
        monitoring[4] = tonumber(sfa)
        monitoring[5] = tonumber(lsp)
        monitoring[6] = tonumber(fbi)
      end
    end
  end
  -- logger.trace(string.format("ID: %d | Color: %d | posx: %f | posy: %f | posz: %f | Text: %s", id, color, position.x, position.y, position.z, text))
end

function clearparams()
  data.functions.checkbox = {}
  data.functions.search.v = ""
  data.functions.playerid.v = -1
  data.functions.radius.v = 15
  data.functions.vig.v = ""
  data.functions.frac.v = ""
  data.functions.time.v = 1
  data.functions.kolvo.v = 1
  data.functions.rank.v = 1
end

imgui_windows = {}
function imgui.OnDrawFrame()
  if window['main'].bool.v then
    imgui.SetNextWindowSize(imgui.ImVec2(700, 400), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowPos(imgui.ImVec2(screenx / 2, screeny / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin(u8'SFA-Helper | ������� ����', window['main'].bool, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.MenuBar + imgui.WindowFlags.NoResize)
    if imgui.BeginMenuBar(u8 'sfahelper') then
      if imgui.BeginMenu(u8 '��������') then
        if imgui.MenuItem(u8 '������� ����') then data.imgui.menu = 1 end
        if imgui.MenuItem(u8 '������ ��������') then data.imgui.menu = 2 end
        if imgui.MenuItem(u8 '�����') then data.imgui.menu = 3 end
        if imgui.MenuItem(u8 '��������� �������') then data.imgui.menu = 4 end
        imgui.EndMenu()
      end
      if imgui.BeginMenu(u8'�������') then
        if imgui.MenuItem(u8 '������') then clearparams(); data.lecture.string = ""; data.imgui.menu = 11 end -- + ������
        if imgui.MenuItem(u8 '���������� � ������') then clearparams(); data.imgui.menu = 12 end -- + ��������
        if imgui.MenuItem(u8 '������ ���.�����') then clearparams(); data.imgui.menu = 13 end
        if imgui.MenuItem(u8 '��� ������������') then clearparams(); data.imgui.menu = 14 end
        if pInfo.settings.rank >= 14 or sInfo.nick == "Eduardo_Carmone" then
          if imgui.MenuItem(u8 '��������� ���. �����') then clearparams(); data.imgui.menu = 15 end
        end
        if imgui.MenuItem(u8 '������ ������') then clearparams(); data.imgui.menu = 16 end
        imgui.EndMenu()
      end
      if imgui.MenuItem(u8 '�������� � �������') then clearparams(); data.imgui.menu = 20 end
      if imgui.MenuItem(u8 '������') then window['binder'].bool.v = true; data.imgui.menu = 21 end
      if imgui.MenuItem(u8 '�����') then window['shpora'].bool.v = true end
      if imgui.BeginMenu(u8 '���������') then
        if imgui.MenuItem(u8 '�������� ���������') then data.imgui.menu = 31 end
        if imgui.MenuItem(u8 '����-��') then data.imgui.menu = 32 end
        if imgui.MenuItem(u8 '��������� ���������') then data.imgui.menu = 33 end
        if imgui.MenuItem(u8 '��������� ����') then clearparams(); data.imgui.menu = 36 end
        if imgui.MenuItem(u8 '������� ��������') then clearparams(); data.imgui.menu = 35 end
        if imgui.MenuItem(u8 '������������� ������') then data.imgui.menu = 34 end
        imgui.EndMenu()
      end
      imgui.EndMenuBar()
    end
    imgui_windows.main(data.imgui.menu)
    imgui.End()
  end
  if window['members'].bool.v then
    imgui.SetNextWindowPos(imgui.ImVec2(screenx / 2, screeny / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(600, 590), imgui.Cond.FirstUseEver)
    imgui.Begin(u8'SFA-Helper | Members Bar', window['members'].bool, imgui.WindowFlags.NoCollapse)
    -----
    imgui_windows.members()
    -----
		imgui.End()
  end
  if window['shpora'].bool.v then
    if data.shpora.loaded == 0 then
      data.shpora.select = {}
      for file in lfs.dir(getWorkingDirectory()..'\\SFAHelper\\shpora') do
        if file ~= "." and file ~= ".." then
          local attr = lfs.attributes(getWorkingDirectory()..'\\SFAHelper\\shpora\\'..file)
          if attr.mode == "file" then 
            table.insert(data.shpora.select, file)
          end
        end
      end
      data.shpora.page = 1
      data.shpora.loaded = 1
    end
    if data.shpora.loaded == 1 then
      if #data.shpora.select == 0 then
        data.shpora.text = {}
        data.shpora.edit = 0
      else
        -- ��������� ����� ����, ��������� ����� �� ��� ������������ ������ ������
        data.filename = 'moonloader/SFAHelper/shpora/'..data.shpora.select[data.shpora.page]
        ----------
        data.shpora.text = {}
        for line in io.lines(data.filename) do
          table.insert(data.shpora.text, line)
        end
      end
      data.shpora.search.v = ""
      data.shpora.loaded = 2
    end
    imgui.SetNextWindowSize(imgui.ImVec2(screenx-400, screeny-250), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin(u8'SFA-Helper | ���������', window['shpora'].bool, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.MenuBar + imgui.WindowFlags.HorizontalScrollbar)
    if imgui.BeginMenuBar(u8 'sfahelper') then
      for i = 1, #data.shpora.select do
        -- ������� ������� ������ � ������ ����, ������� .txt �� ��������
        local text = data.shpora.select[i]:gsub(".txt", "")
        if imgui.MenuItem(u8:encode(text)) then
          data.shpora.page = i
          data.shpora.loaded = 1
        end
      end
      imgui.EndMenuBar()
    end
    ---------
    if data.shpora.edit < 0 and #data.shpora.select > 0 then
      if imgui.Button(u8'����� �����', imgui.ImVec2(120, 30)) then
        data.shpora.edit = 0
        data.shpora.search.v = ""
        data.shpora.inputbuffer.v = ""
      end
      imgui.SameLine()
      if imgui.Button(u8'�������� �����', imgui.ImVec2(120, 30)) then
        data.shpora.edit = data.shpora.page
        local text = data.shpora.select[data.shpora.page]:gsub(".txt", "")
        data.shpora.search.v = u8:encode(text)
        local ttext  = ""
        for k, v in pairs(data.shpora.text) do
          ttext = ttext .. v .. "\n"
        end
        data.shpora.inputbuffer.v = u8:encode(ttext)
      end
      imgui.SameLine()
      if imgui.Button(u8'������� �����', imgui.ImVec2(120, 30)) then
        os.remove(data.filename)
        data.shpora.loaded = 0
        dtext("����� \""..data.filename.."\" ������� �������!")
      end
      imgui.Spacing()
      ---------
      imgui.PushItemWidth(250)
      imgui.Text(u8'����� �� ������')
      imgui.InputText('##inptext', data.shpora.search)
      imgui.PopItemWidth()
      imgui.Separator()
      imgui.Spacing()
      for k, v in pairs(data.shpora.text) do
        if u8:decode(data.shpora.search.v) == "" or string.find(rusUpper(v), rusUpper(u8:decode(data.shpora.search.v))) ~= nil then
          imgui.Text(u8(v))
        end
      end
    else
      imgui.PushItemWidth(250)
      imgui.Text(u8'������� �������� �����')
      imgui.InputText('##inptext', data.shpora.search)
      imgui.PopItemWidth()
      if imgui.Button(u8'���������', imgui.ImVec2(120, 30)) then
        if #data.shpora.search.v ~= 0 and #data.shpora.inputbuffer.v ~= 0 then
          if data.shpora.edit == 0 then
            local file = io.open('moonloader\\SFAHelper\\shpora\\'..u8:decode(data.shpora.search.v)..'.txt', "a+")
            file:write(u8:decode(data.shpora.inputbuffer.v))
            file:close()
            dtext('����� ������� �������!')
          elseif data.shpora.edit > 0 then
            local file = io.open(data.filename, "w+")
            file:write(u8:decode(data.shpora.inputbuffer.v))
            file:close()
            local rename = os.rename(data.filename, 'moonloader\\SFAHelper\\shpora\\'..u8:decode(data.shpora.search.v)..'.txt')
            if rename then
              dtext('����� ������� ��������!')
            else
              dtext('������ ��� ��������� �����')
            end
          end
          data.shpora.search.v = ""
          data.shpora.loaded = 0
          data.shpora.edit = -1
        else dtext('��� ���� ������ ���� ���������!') end
      end
      imgui.SameLine()
      if imgui.Button(u8'������', imgui.ImVec2(120, 30)) then
        if #data.shpora.select > 0 then
          data.shpora.edit = -1
          data.shpora.search.v = ""
        else dtext('��� ���������� ������� ���� �� ���� �����!') end
      end
      imgui.Separator()
      imgui.Spacing()
      imgui.InputTextMultiline('##intextmulti', data.shpora.inputbuffer, imgui.ImVec2(-1, -1))
    end
    imgui.End()
  end
  if window['binder'].bool.v then
    imgui.SetNextWindowSize(imgui.ImVec2(200, 300), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowPos(imgui.ImVec2(screenx - 200, (screeny / 2) - 150), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin('##binderhelper', window['binder'].bool, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoTitleBar)
    -----
    imgui_windows.binder()
    -----
    imgui.End()
  end
  if window['addtable'].bool.v then
    imgui.SetNextWindowSize(imgui.ImVec2(350, 200), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin(u8'SFA-Helper | �������� ������ � �������', window['addtable'].bool, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize)
    imgui_windows.addtable()
    imgui.End()
  end
  if window['hud'].bool.v then
    imgui.SetNextWindowPos(imgui.ImVec2(pInfo.settings.hudX, pInfo.settings.hudY), imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(320, 190), imgui.Cond.FirstUseEver)
    imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.06, 0.05, 0.07, pInfo.settings.hudopacity))
    imgui.PushStyleVar(imgui.StyleVar.WindowRounding, pInfo.settings.hudrounding)
    imgui.Begin('notitle', window['hud'].bool, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoMove)
    imgui.SetWindowSize('notitle', imgui.ImVec2(320, 0))
    imgui_windows.hud()
    --[[imgui_windows.pie()
    if imgui.IsMouseClicked(2) then
      imgui.OpenPopup('PieMenu')
      if window['target'].bool.v == true then pieMenu.active = 2
      else pieMenu.active = 1 end
    end
    if imgui.IsPopupOpen('PieMenu') then
      sampToggleCursor(true)
    elseif pieMenu.active > 0 then
      sampToggleCursor(false)
      pieMenu.active = 0
    end]]
    imgui.End()
    imgui.PopStyleVar()
    imgui.PopStyleColor()
    if imgui.IsMouseClicked(0) and data.imgui.hudpos then
      data.imgui.hudpos = false
      sampToggleCursor(false)
      window['main'].bool.v = true
      if not pInfo.settings.hud then window['hud'].bool.v = false end
      filesystem.save(pInfo, 'config.json')
    end
  end
  if window['target'].bool.v and pInfo.settings.hud then
    -- �������� �������� �������
    if targetMenu.show == true then
      if targetMenu.slide == "top" then
        targetMenu.coordY = targetMenu.coordY - 25
        if targetMenu.coordY < pInfo.settings.hudY-10-57.5 then targetMenu.coordY = pInfo.settings.hudY-10-57.5 end
      elseif targetMenu.slide == "bottom" then
        targetMenu.coordY = targetMenu.coordY + 25
        if targetMenu.coordY > pInfo.settings.hudY+10+57.5+data.imgui.hudpoint.y then targetMenu.coordY = pInfo.settings.hudY+10+57.5+data.imgui.hudpoint.y end
      end
    else
      if targetMenu.slide == "top" then
        targetMenu.coordY = targetMenu.coordY + 25
        if targetMenu.coordY > (data.imgui.hudpoint.y / 2) + pInfo.settings.hudY then targetMenu.coordY = (data.imgui.hudpoint.y / 2) + pInfo.settings.hudY end
      elseif targetMenu.slide == "bottom" then
        targetMenu.coordY = targetMenu.coordY - 25
        if targetMenu.coordY < pInfo.settings.hudY + (data.imgui.hudpoint.y / 2) then targetMenu.coordY = pInfo.settings.hudY + (data.imgui.hudpoint.y / 2) end
      end
    end
    imgui.SetNextWindowSize(imgui.ImVec2(320, 115), imgui.Cond.Always)
    imgui.SetNextWindowPos(imgui.ImVec2(targetMenu.coordX, targetMenu.coordY), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
    imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.06, 0.05, 0.07, pInfo.settings.hudopacity))
    imgui.PushStyleVar(imgui.StyleVar.WindowRounding, pInfo.settings.hudrounding)
    imgui.Begin(u8'SFA-Helper | ������ ����', _, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoBringToFrontOnFocus + imgui.WindowFlags.NoResize)
    imgui_windows.target()
    imgui.End()
    imgui.PopStyleVar()
    imgui.PopStyleColor()
  end
end

imgui_windows.main = function(menu)
  if menu == 1 then
    imgui.SetCursorPosX(20.0)
    imgui.BeginChild('##1', imgui.ImVec2(imgui.GetWindowWidth() - 40, 300), true)
    imgui.Text(u8"���:"); imgui.SameLine(225.0); imgui.Text(('%s[%d]'):format(sInfo.nick, sInfo.playerid))
    imgui.Text(u8"������� ����:"); imgui.SameLine(225.0); imgui.TextColoredRGB(string.format('%s', sInfo.isWorking == true and "{00bf80}�����" or "{ec3737}�������"))
    if sInfo.isWorking == true and pInfo.settings.rank > 0 then
      imgui.Text(u8"������:"); imgui.SameLine(225.0); imgui.Text(('%s[%d]'):format(u8:encode(pInfo.ranknames[pInfo.settings.rank]), pInfo.settings.rank))
    end
    imgui.Text(u8"����� �����������:"); imgui.SameLine(225.0); imgui.Text(('%s'):format(sInfo.authTime))
    imgui.Separator()
    imgui.Text(u8"�������� �� �������:"); imgui.SameLine(225.0); imgui.Text(('%s'):format(secToTime(pInfo.info.dayOnline)))
    imgui.Text(u8"�� ��� �� ������:"); imgui.SameLine(225.0); imgui.Text(('%s'):format(secToTime(pInfo.info.dayWorkOnline)))
    imgui.Text(u8"AFK �� �������:"); imgui.SameLine(225.0); imgui.Text(('%s'):format(secToTime(pInfo.info.dayAFK)))
    imgui.Separator()
    imgui.Text(u8"�������� �� ������:"); imgui.SameLine(225.0); imgui.Text(('%s'):format(secToTime(pInfo.info.weekOnline)))
    imgui.Text(u8"�� ��� �� ������:"); imgui.SameLine(225.0); imgui.Text(('%s'):format(secToTime(pInfo.info.weekWorkOnline)))
    if sInfo.isSupport == true then
      imgui.Separator()
      imgui.Text(u8"������� �� ����"); imgui.SameLine(225.0); imgui.Text(('%s'):format(pInfo.info.dayPM))
      imgui.Text(u8"������� �� ������"); imgui.SameLine(225.0); imgui.Text(('%s'):format(pInfo.info.weekPM))
    end
    imgui.EndChild()
  elseif menu == 2 then
    imgui.Columns(2, _, false)
    imgui.SetColumnWidth(-1, imgui.GetWindowWidth() / 2)
    imgui.BeginChild('##1', imgui.ImVec2((imgui.GetWindowWidth() / 2) - 30, 300), true)
    local daynumber = dateToWeekNumber(os.date("%d.%m.%y"))
    if daynumber == 0 then daynumber = 7 end
    local mediumtime = {}
    for key, value in ipairs(pInfo.weeks) do
      local colour = ""
      if daynumber > 0 then
        if daynumber < key then 
          colour = "ec3737"
          table.insert(mediumtime, value)
        elseif daynumber == key then
          colour = "FFFFFF"
          table.insert(mediumtime, pInfo.info.dayOnline)
        else colour = "00BF80" end
      else
        if daynumber == 0 and key == 7 then colour = "FFFFFF"
        else colour = "00BF80" end
      end
      imgui.Text(u8:encode(dayName[key]))
      imgui.SameLine(185.0)
      imgui.TextColoredRGB(('{%s}%s'):format(colour, daynumber == key and secToTime(pInfo.info.dayOnline) or secToTime(value)))
    end
    local counter = 0
    for i = 1, #mediumtime do
      counter = counter + mediumtime[i]
    end
    counter = math.floor(counter / #mediumtime)
    imgui.Spacing()
    imgui.Text(u8'������� ������ � ����')
    imgui.SameLine(185.0)
    imgui.Text(secToTime(counter))
    imgui.EndChild()
    imgui.NextColumn()
    ---------------------
    imgui.BeginChild('##2', imgui.ImVec2((imgui.GetWindowWidth() / 2) - 30, 300), true)
    for i = 1, #pInfo.counter do
      if counterNames[i] ~= nil then
        local count = pInfo.counter[i]
        if i == 5 or i == 6 then count = secToTime(count) end
        imgui.Text(('%s'):format(u8:encode(counterNames[i])))
        imgui.SameLine(225.0)
        imgui.Text(('%s'):format(count))
      end
    end
    imgui.EndChild()
    imgui.NextColumn()
    imgui.Columns(1)
  elseif menu == 3 then
    local radiolist = {
      { text = "���� �����", url = "" },
      { text = "Radio Record", url = "http://air.radiorecord.ru:805/rr_320" },
      { text = "Evolve FM", url = "http://185.58.204.232:8000/evolve.ogg" },
      { text = "������ ����", url = "http://ep128.hostingradio.ru:8030/ep128" },
      { text = "���-FM [UA]", url = "http://www.hitfm.ua/HitFM.m3u" },
      { text = "KISS FM [UA]", url = "http://www.kissfm.ua/KissFM.m3u" },
      { text = "����� ������� [UA]", url = "http://melodia.ipfm.net/RadioMelodia" },
      { text = "������� �����", url = "https://rusradio.hostingradio.ru/rusradio128.mp3" },
      { text = "����� Energy", url = "http://ic2.101.ru:8000/v1_1" },
      { text = "����� FM", url = "http://retroserver.streamr.ru:8043/retro128" },
      { text = "SOUNDPARK DEEP", url = "http://185.220.35.56:8000/128" },
      { text = "���������", url = "http://ic2.101.ru:8000/v3_1" },
      { text = "Russian Mix - Radio Record", url = "http://air.radiorecord.ru:805/rus_128" },
      { text = "DFM", url = "https://dfm.hostingradio.ru/dfm128.mp3" },
      { text = "����� �����", url = "http://icecast.newradio.cdnvideo.ru/newradio3" },
      { text = "���� FM [UA]", url = "http://icecastdc.luxnet.ua/lux_mp3" },
      { text = "����� ����� [BY]", url = "http://live.novoeradio.by:8000/novoeradio-aac" },
      { text = "����� NS [KZ]", url = "http://89.219.35.26:8000/radions" },
      { text = "Radio Jan [AM]", url = "http://s7.voscast.com:10258" }
    }
    imgui.Columns(2, _, false)
    imgui.PushStyleColor(imgui.Col.ChildWindowBg, imgui.ImVec4(0.06, 0.05, 0.07, 1.00))
    imgui.SetColumnWidth(-1, 160.0)
    imgui.BeginChild('##1', imgui.ImVec2(160, -1), imgui.WindowFlags.AlwaysAutoResize)
    for k, v in ipairs(radiolist) do
      if imgui.Selectable(u8:encode(v.text), selectRadio.id == k and true or false) then
        selectRadio.id = k
        selectRadio.title = v.text
        selectRadio.url = v.url
      end
    end
    imgui.EndChild()
    imgui.NextColumn()
    imgui.BeginChild('##2', imgui.ImVec2(imgui.GetWindowWidth() - 150, -1))
    local volume = imgui.ImFloat(selectRadio.volume)
    local inptext = imgui.ImBuffer(tostring(selectRadio.url), 256)
    imgui.Text(u8:encode('����� - '..selectRadio.title))
    imgui.Spacing()
    if selectRadio.id == 1 then
      imgui.Text(u8'������� ������ ������ �� �����')
      if imgui.InputText('##inputtext', inptext) then
        selectRadio.url = inptext.v
      end
      imgui.Spacing()
    end
    imgui.Text(u8'���������')
    if imgui.SliderFloat('##sliderfloat', volume, 0.0, 1.0, "%.1f", 1) then
      selectRadio.volume = volume.v
      if bass ~= nil and radioStream ~= nil then
        bass.BASS_ChannelSetAttribute(radioStream, BASS_ATTRIB_VOL, selectRadio.volume)
      end
    end
    imgui.Spacing()
    if selectRadio.stream == 1 then
      if imgui.Button(u8'���������') then
        if radioStream ~= nil and bass ~= nil then
          bass.BASS_StreamFree(radioStream)
          selectRadio.stream = 0
          renderStream = nil
          radioStream = nil
        end
      end
    elseif selectRadio.stream == 0 then
      if imgui.Button(u8'��������') then
        if bass ~= nil then
          radioStream = bass.BASS_StreamCreateURL(selectRadio.url, 0, bassFlagsOrOperation({BASS_STREAM_BLOCK, BASS_STREAM_STATUS, BASS_STREAM_AUTOFREE}), nil, nil)
          bass.BASS_ChannelPlay(radioStream, true)
          if radioStream ~= nil then
            if tonumber(bass.BASS_ErrorGetCode()) ~= 0 then
              dtext('���������� �������� ����')
            end
            bass.BASS_ChannelSetAttribute(radioStream, BASS_ATTRIB_VOL, selectRadio.volume)
            renderStream = renderCreateFont("Arial", 9, 5)
            selectRadio.stream = 1
            lua_thread.create(function()
              while true do
                if selectRadio.stream ~= 1 then break end
                local tag_meta = bass.BASS_ChannelGetTags(radioStream, BASS_TAG_META) -- StreamTitle='xxx';StreamUrl='xxx';
                selectRadio.streamTitle = ""
                selectRadio.streamUrl = selectRadio.title
                if tag_meta ~= nil then
                  tag_meta = u8:decode(ffi.string(tag_meta))
                  local streamTitle = tag_meta:match("StreamTitle='(.-)'")
                  local streamUrl = tag_meta:match("StreamUrl='(.-)'")
                  if streamTitle ~= nil then
                    selectRadio.streamTitle = streamTitle
                  end
                  if streamUrl ~= nil then
                    selectRadio.streamUrl = streamUrl
                  end
                end
                wait(10000)
              end
            end)
          else dtext('�� ������� ������������ � �����������') end
        end
      end
    end
    imgui.EndChild()
    imgui.NextColumn()
    imgui.PopStyleColor()
    imgui.Columns(1)
  elseif menu == 4 then
    local spacing = 225.0
    imgui.TextColoredRGB('{FFFFFF}/sh'); imgui.SameLine(spacing); imgui.Text(u8'������� ������� ���� �������')
    imgui.TextColoredRGB('{FFFFFF}/shupd'); imgui.SameLine(spacing); imgui.Text(u8'����������� ��������� ����������')
    imgui.TextColoredRGB('{FFFFFF}/abp'); imgui.SameLine(spacing); imgui.Text(u8'������� ���� ����-��')
    imgui.TextColoredRGB('{FFFFFF}/shud'); imgui.SameLine(spacing); imgui.Text(u8'��������/��������� ���')
    imgui.TextColoredRGB('{FFFFFF}/starget'); imgui.SameLine(spacing); imgui.Text(u8'�������/��������� ������ ����')
    imgui.TextColoredRGB('{FFFFFF}/rpweap [���]'); imgui.SameLine(spacing); imgui.Text(u8'�������� ��� �� ��������� ������')
    imgui.TextColoredRGB('{FFFFFF}/punishlog [id/nick]'); imgui.SameLine(spacing); imgui.Text(u8'�������� ��������� ������')
    imgui.TextColoredRGB('{FFFFFF}/members [0-2]'); imgui.SameLine(spacing); imgui.Text(u8'����������� �������')
    imgui.TextColoredRGB('{FFFFFF}/mon [0-1 (�����������)]'); imgui.SameLine(spacing); imgui.TextColoredRGB('��������� ��������� ������ � ����� {954F4F}(�������� SFA/LVA)')
    imgui.TextColoredRGB('{FFFFFF}/cn [id] [0-1]'); imgui.SameLine(spacing); imgui.Text(u8'����������� ���. 0 - RP ���, 1 - NonRP ���')
    imgui.TextColoredRGB('{FFFFFF}/ev [0-1] [�����]'); imgui.SameLine(spacing); imgui.Text(u8'��������� ���������. 0 - ������� �������, 1 - �� �����')
    imgui.TextColoredRGB('{FFFFFF}/loc [id/nick] [�������]'); imgui.SameLine(spacing); imgui.Text(u8'��������� �������������� �����')
    imgui.TextColoredRGB('{FFFFFF}/watch [add/remove/list] [id]'); imgui.SameLine(spacing); imgui.Text(u8'������ ������ �� ������ ���� ������')
    imgui.TextColoredRGB('{FFFFFF}/checkrank [id/nick]'); imgui.SameLine(spacing); imgui.TextColoredRGB('����������� ��������� ��������� ������. {954F4F}(�������� SFA)')
    imgui.TextColoredRGB('{FFFFFF}/checkbl [id/nick]'); imgui.SameLine(spacing); imgui.TextColoredRGB('��������� ������ � ������ ������. {954F4F}(�������� SFA)')
    imgui.TextColoredRGB('{FFFFFF}/checkvig [id/nick]'); imgui.SameLine(spacing); imgui.TextColoredRGB('����������� �������� ������. {954F4F}(�������� SFA)')
    imgui.TextColoredRGB('{FFFFFF}/cchat'); imgui.SameLine(spacing); imgui.Text(u8'�������� ���')
    imgui.TextColoredRGB('{FFFFFF}/adm'); imgui.SameLine(spacing); imgui.Text(u8'������������ ������� /admins')
    imgui.TextColoredRGB('{FFFFFF}(/lec)ture [start/pause/stop]'); imgui.SameLine(spacing); imgui.Text(u8'������� �������������� ������ � ���')
    imgui.TextColoredRGB('{FFFFFF}/createpost [��������]'); imgui.SameLine(spacing); imgui.Text(u8'������� ����, ��� ������������')
    imgui.TextColoredRGB('{FFFFFF}/addbl'); imgui.SameLine(spacing); imgui.TextColoredRGB('�������� ������ � ������ ������ {954F4F}(�������� �� ��������)')
    imgui.TextColoredRGB('{FFFFFF}/addtable'); imgui.SameLine(spacing); imgui.TextColoredRGB('�������� ������ � ������� {954F4F}(�������� SFA 12+)')
    imgui.TextColoredRGB('{FFFFFF}/vig [id] [���] [�������]'); imgui.SameLine(spacing); imgui.Text(u8'������ ������ �������')
    imgui.TextColoredRGB('{FFFFFF}/reconnect [�������]'); imgui.SameLine(spacing); imgui.Text(u8'��������������� � �������')
    imgui.TextColoredRGB('{FFFFFF}/blag [id] [�������] [���]'); imgui.SameLine(spacing); imgui.Text(u8'�������� ������ ������������� � �����������')
    imgui.TextColoredRGB('{FFFFFF}/match [id/nick]'); imgui.SameLine(spacing); imgui.Text(u8'����������� ��������������� ������ �� ������')
    imgui.TextColoredRGB('{FFFFFF}/sweather [������ 0 - 45]'); imgui.SameLine(spacing); imgui.Text(u8'�������� ������ �� ���������')
    imgui.TextColoredRGB('{FFFFFF}/stime [����� 0 - 23]'); imgui.SameLine(spacing); imgui.Text(u8'�������� ����� �� ���������')
    imgui.TextColoredRGB('{FFFFFF}/shradio'); imgui.SameLine(spacing); imgui.Text(u8'������� ���� �����')
  elseif menu == 11 then
    imgui.PushItemWidth(150)
    if data.lecture.string == "" then
      -- ��������� ������ ������ � �������� � �������
      data.combo.lecture.v = 0
      data.lecture.list = {}
      data.lecture.string = u8"�� �������\0"
      for file in lfs.dir(getWorkingDirectory()..'\\SFAHelper\\lectures') do
        if file ~= "." and file ~= ".." then
          local attr = lfs.attributes(getWorkingDirectory()..'\\SFAHelper\\lectures\\'..file)
          if attr.mode == "file" then 
            table.insert(data.lecture.list, file)
            data.lecture.string = data.lecture.string..u8:encode(file)..'\0'
          end
        end
      end
      if #data.lecture.list == 0 then
        name = "firstlecture.txt"
        local file = io.open('moonloader/SFAHelper/lectures/firstlecture.txt', "w+")
        file:write("������� ���������\n/s ��������� � ������\n/b ��������� � b ���\n/rb ��������� � �����\n/w ��������� �������")
        file:flush()
        file:close()
        file = nil
      end
      data.lecture.string = data.lecture.string.."\0"
    end
    imgui.Columns(2, _, false)
    imgui.SetColumnWidth(-1, 200)
    imgui.Text(u8'�������� ���� ������')
    imgui.Combo("##lec", data.combo.lecture, data.lecture.string)
    if imgui.Button(u8 '��������� ������') then
      if data.combo.lecture.v > 0 then
        local file = io.open('moonloader/SFAHelper/lectures/'..data.lecture.list[data.combo.lecture.v], "r+")
        if file == nil then atext('���� �� ������!')
        else
          data.lecture.text = {} 
          for line in io.lines('moonloader/SFAHelper/lectures/'..data.lecture.list[data.combo.lecture.v]) do
            table.insert(data.lecture.text, line)
          end
          if #data.lecture.text > 0 then
            atext('���� ������ ������� ��������! ��� ������� ������� - (/lec)ture, ���� �������������� ����')
          else atext('���� ������ ����!') end
        end
        file:close()
        file = nil
      else atext('�������� ���� ������!') end
    end
    imgui.NextColumn()
    imgui.PushItemWidth(200)
    imgui.Text(u8'�������� �������� (� �������������)')
    imgui.InputInt('##inputlec', data.lecture.time)
    if lectureStatus == 0 then
      if imgui.Button(u8'��������� ������') then
        if #data.lecture.text == 0 then dtext('���� ������ �� ��������!') return end
        if data.lecture.time.v == 0 then dtext('����� �� ����� ���� ����� 0!') return end
        if lectureStatus ~= 0 then dtext('������ ��� ��������/�� �����') return end
        local ltext = data.lecture.text
        local ltime = data.lecture.time.v
        atext('����� ������ �������')
        lectureStatus = 1
        lua_thread.create(function()
          while true do
            if lectureStatus == 0 then break end
            if lectureStatus >= 1 then
              if string.match(ltext[lectureStatus], "^/r .+") then
                local bind = string.match(ltext[lectureStatus], "^/r (.+)")
                local textTag = tags(bind)
                if textTag:len() > 0 then
                  cmd_r(textTag)
                end
              else
                local textTag = tags(ltext[lectureStatus])
                if textTag:len() > 0 then
                  sampSendChat(textTag)
                end
              end
              lectureStatus = lectureStatus + 1
            end
            if lectureStatus > #ltext then
              wait(150)
              lectureStatus = 0
              addcounter(4, 1)
              dtext('����� ������ ��������')
              break 
            end
            wait(tonumber(ltime))
          end
        end)
      end
    else
      if imgui.Button(u8:encode(string.format("%s", lectureStatus > 0 and "�����" or "�����������"))) then
        if lectureStatus == 0 then dtext('������ �� ��������') return end
        lectureStatus = lectureStatus * -1
        if lectureStatus > 0 then dtext('������ ������������')
        else dtext('������ ��������������') end
      end
      imgui.SameLine()
      if imgui.Button(u8'����') then
        if lectureStatus == 0 then dtext('������ �� ��������') return end
        lectureStatus = 0
        dtext('����� ������ ���������')
      end
    end
    imgui.NextColumn()
    imgui.Columns(1)
    imgui.Separator()
    imgui.Text(u8 '���������� ����� ������:')
    imgui.Spacing()
    if #data.lecture.text == 0 then imgui.Text(u8 '���� �� ��������/����!') end
    for i = 1, #data.lecture.text do
      imgui.Text(u8:encode(data.lecture.text[i]))
    end
  elseif menu == 12 then
    imgui.PushItemWidth(200)
    local togglepost = imgui.ImBool(post.active)
    local interval = imgui.ImInt(post.interval)
    if imgui.ToggleButton(u8 'post##1', togglepost) then
      funcc('enable_autodoklad', 1)
      post.active = togglepost.v;
    end
    imgui.SameLine(); imgui.Text(u8 '�������� ����������')
    if imgui.InputInt(u8 '�������� ����� ��������� (� ��������)', interval) then
      if interval.v < 60 then interval.v = 60 end
      if interval.v > 3600 then interval.v = 3600 end
      post.interval = interval.v
    end
    imgui.Separator()
    imgui.Text(u8 '��������� ������')
    local pstr = ""
    for i = 1, #postInfo do
      pstr = pstr..postInfo[i].name.."\0"
    end
    imgui.Combo(u8 '�������� ���� ��� ���������', data.combo.post, u8:encode("�� �������\0"..pstr.."\0"))
    imgui.NewLine()
    if data.combo.post.v > 0 then
      imgui.Text(u8("���������� �����: %f %f %f"):format(postInfo[data.combo.post.v].coordX, postInfo[data.combo.post.v].coordY, postInfo[data.combo.post.v].coordZ))
      imgui.InputInt(u8("������ �����: %f"):format(postInfo[data.combo.post.v].radius), data.functions.radius, 0)
      if imgui.Button(u8 '�������� ����') then
        if data.functions.radius.v ~= tonumber(postInfo[data.combo.post.v].radius) then
          atext('���� ������� �������!')
          postInfo[data.combo.post.v].radius = data.functions.radius.v
          filesystem.save(postInfo, 'posts.json')
        end
      end
      if imgui.Button(u8 '������� ����') then
        table.remove(postInfo, data.combo.post.v)
        atext('���� ������� ������!')
        filesystem.save(postInfo, 'posts.json') 
      end
    end
  elseif menu == 13 then
    imgui.PushItemWidth(200)
    imgui.Text(u8'������� ����� ����� � ������� **:**, **:** � �.�.')
    imgui.InputText('##inputtext', data.functions.search)
    imgui.Separator()
    imgui.Text(u8:encode(localVars('others', 'dep', {
      ['time'] = data.functions.search.v,
      ['id'] = sInfo.playerid
    })))
    imgui.Text(u8:encode(localVars('others', 'dept', {
      ['time'] = data.functions.search.v
    })))
    if imgui.Button(u8 '������ ���. �����', imgui.ImVec2(200, 20)) then
      funcc('imgui_senddep', 1)
      sampSendChat(localVars('others', 'dep', {
        ['time'] = u8:decode(data.functions.search.v),
        ['id'] = sInfo.playerid
      }))
    end
    imgui.SameLine()
    if imgui.Button(u8 '��������� � ������� ���. �����', imgui.ImVec2(200, 20)) then
      funcc('imgui_senddep_napom', 1)
      sampSendChat(localVars('others', 'dept', {
        ['time'] = u8:decode(data.functions.search.v)
      }))
    end
  elseif menu == 14 then
    imgui.PushItemWidth(200)
    imgui.InputText(u8 '����� �� ������', data.functions.search)
    imgui.Separator()
    imgui.Text(u8'����������� 20 ��������� ������� �� ����� �� ������')
    imgui.NewLine()
    local count = 0
    -- ����� ���� ������������
    for i = #data.departament, 1, -1 do
      if i < 1 then break end
      if count >= 20 then break end
      -- ��������� �� ������
      if string.find(rusUpper(data.departament[i]), rusUpper(u8:decode(data.functions.search.v))) ~= nil or u8:decode(data.functions.search.v) == "" then
        imgui.Text(u8(data.departament[i]))
        count = count + 1
      end
    end
  elseif menu == 15 then
    imgui.PushItemWidth(200)
    local text = ""
    for key, value in ipairs(pInfo.gov) do
      text = text..value[1].."\0"
    end
    imgui.Text(u8'�������� ������ ����������')
    imgui.Combo('##govcombo', data.combo.gov, u8:encode("�� �������\0"..text.."\0"))
    if imgui.Button(u8'��������') then
      data.gov.textarea = { imgui.ImBuffer(512), imgui.ImBuffer(512), imgui.ImBuffer(512) }
      data.imgui.menu = 42
    end
    imgui.SameLine()
    if imgui.Button(u8'�������������') then
      if data.combo.gov.v > 0 then
        data.gov.textarea = {}
        for i = 2, #pInfo.gov[data.combo.gov.v] do
          data.gov.textarea[i - 1] = imgui.ImBuffer(512)
          data.gov.textarea[i - 1].v = u8:encode(pInfo.gov[data.combo.gov.v][i])
        end
        data.imgui.menu = 43
      else atext('�������� ����������� ������!') end
    end
    imgui.SameLine()
    if imgui.Button(u8'�������') then
      if data.combo.gov.v > 0 then
        table.remove(pInfo.gov, data.combo.gov.v)
        sampAddChatMessage(tostring(#pInfo.gov), -1)
        data.combo.gov.v = 0
        atext('������ ������� ������!')
        filesystem.save(pInfo, 'config.json')
      else atext('�������� ����������� ������!') end
    end
    imgui.Spacing()
    imgui.Text(u8'������� ����� � ������� **:**')
    imgui.InputText('##govinput', data.functions.search)
    imgui.Separator()
    imgui.Text(u8'��������������� ��������:')
    ------
    if data.combo.gov.v > 0 then
      for i = 2, #pInfo.gov[data.combo.gov.v] do
        local gov = pInfo.gov[data.combo.gov.v][i]
        gov = gov:gsub("{time}", u8:decode(data.functions.search.v))
        imgui.Text(u8:encode(("/gov %s"):format(gov)))
      end
    else imgui.Text(u8'��� ������ ��� �����������') end
    ------
    if imgui.Button(u8'��������') then
      if data.combo.gov.v > 0 then 
        funcc('imgui_sendgov', 1)
        lua_thread.create(function()
          for i = 2, #pInfo.gov[data.combo.gov.v] do
            local gov = pInfo.gov[data.combo.gov.v][i]
            gov = gov:gsub("{time}", u8:decode(data.functions.search.v))
            sampSendChat(("/gov %s"):format(gov))
            --sampAddChatMessage("/gov "..gov, -1)
            wait(5000)
          end
          return
        end)
      else atext('�������� ������ ������ ��� ����������!') end
    end
  elseif data.imgui.menu == 43 then
    imgui.PushItemWidth(500)
    if imgui.Button(u8'�������� ������') then
      data.gov.textarea[#data.gov.textarea + 1] = imgui.ImBuffer(128)
    end
    imgui.NewLine()
    ------
    for i = 1, #data.gov.textarea do
      imgui.InputText('#'..i, data.gov.textarea[i])
    end
    ------
    imgui.NewLine()
    imgui.Separator()
    if imgui.Button(u8'��������') then
      funcc('imgui_changegov', 1)
      local tit = pInfo.gov[data.combo.gov.v][1]
      pInfo.gov[data.combo.gov.v] = {}
      table.insert(pInfo.gov[data.combo.gov.v], tit)
      for i = 1, #data.gov.textarea do
        local govline = data.gov.textarea[i].v
        if govline ~= nil and govline ~= "" then
          table.insert(pInfo.gov[data.combo.gov.v], u8:decode(govline))
        end
      end
      data.functions.search.v = ""
      data.imgui.menu = 15
      atext('������ ������� �������!')
      filesystem.save(pInfo, 'config.json')
    end
    imgui.SameLine()
    if imgui.Button(u8'������') then
      data.functions.search.v = ""
      data.imgui.menu = 15
    end
  elseif data.imgui.menu == 42 then
    imgui.PushItemWidth(500)
    if imgui.Button(u8'�������� ������') then
      data.gov.textarea[#data.gov.textarea + 1] = imgui.ImBuffer(128)
    end
    imgui.NewLine()
    imgui.InputText(u8 '������� �������� �������', data.functions.search)
    ------
    for i = 1, #data.gov.textarea do
      imgui.InputText('#'..i, data.gov.textarea[i])
    end
    ------
    imgui.NewLine()
    imgui.Separator()
    if imgui.Button(u8'�������') then
      funcc('imgui_creategov', 1)
      local len = #pInfo.gov + 1
      if data.functions.search.v ~= nil and data.functions.search.v ~= "" then
        pInfo.gov[len] = {}
        table.insert(pInfo.gov[len], u8:decode(data.functions.search.v))
        for i = 1, #data.gov.textarea do
          local govline = data.gov.textarea[i].v
          if govline ~= nil and govline ~= "" then
            table.insert(pInfo.gov[len], u8:decode(govline))
          end
        end
        data.combo.gov.v = len
        data.imgui.menu = 15
        data.functions.search.v = ""
        atext('������ ������� ������!')
        filesystem.save(pInfo, 'config.json')
      else atext('�������� �������� �������!') end 
    end
    imgui.SameLine()
    if imgui.Button(u8'������') then
      data.functions.search.v = ""
      data.imgui.menu = 15
    end
  elseif menu == 16 then
    imgui.Columns(2, _, false)
    imgui.SetColumnWidth(-1, 350)
    imgui.PushItemWidth(200)
    imgui.Text(u8'������� ID ������')
    imgui.InputInt('##inputtext', data.functions.playerid, 0)
    imgui.SameLine()
    if imgui.Button(u8 '���������') then
      local found = false
      if sampIsPlayerConnected(data.functions.playerid.v) then
        if data.functions.playerid.v ~= sInfo.playerid then
          for i = 1, #spectate_list do
            if spectate_list[i] ~= nil then
              if data.functions.playerid.v == spectate_list[i].id then
                dtext(('����� %s[%d] ������� ����� �� ������ ������'):format(spectate_list[i].nick, spectate_list[i].id))
                table.remove(spectate_list, i)
                found = true
              end
            end
          end
          if found == false then
            funcc('imgui_watch_add', 1)
            local color = string.format("%06X", ARGBtoRGB(sampGetPlayerColor(data.functions.playerid.v)))
            table.insert(spectate_list, { id = data.functions.playerid.v, nick = sampGetPlayerNickname(data.functions.playerid.v), clist = color })
            dtext(string.format('����� %s[%d] ������� �������� � ������ ������. ������� ����: %s', spectate_list[#spectate_list].nick, spectate_list[#spectate_list].id, getcolorname(color)))
          end
        else dtext('�� ����� ���� ID') end
      else dtext('����� �������!') end
    end
    imgui.NextColumn()
    if imgui.Button(u8:encode(pInfo.settings.watchhud and '��������� ���' or '�������� ���'), imgui.ImVec2(120, 30)) then
      if pInfo.settings.watchhud then
        dtext('Watch-hud ������� ��������')
      else
        dtext('Watch-hud ������� �������. ��� ��� ����������� ����� �������� ���� �� ������ ������ � ������ ������!')
      end
      pInfo.settings.watchhud = not pInfo.settings.watchhud
    end
    imgui.SameLine()
    if imgui.Button(u8'����������� ���', imgui.ImVec2(120, 30)) then
      if pInfo.settings.watchhud and #watchList > 0 then
        data.imgui.watchpos = true
        window['main'].bool.v = false
      else dtext('��� ����������� ����� �������� ��� � �������� ���� �� 1 ��������') end
    end
    imgui.NextColumn()
    imgui.Columns(1)
    imgui.Spacing()
    if sampIsPlayerConnected(data.functions.playerid.v) then
      local found = false
      if data.functions.playerid.v ~= sInfo.playerid then
        for i = 1, #spectate_list do
          if spectate_list[i] ~= nil then
            if data.functions.playerid.v == spectate_list[i].id then
              imgui.Text(u8("������� %s[%d] �� ������ ������"):format(spectate_list[i].nick, spectate_list[i].id))
              found = true
            end
          end
        end
        if found == false then
          imgui.Text(u8("�������� %s[%d] � ������ ������"):format(sampGetPlayerNickname(data.functions.playerid.v), data.functions.playerid.v))
        end
      else imgui.Text(u8'�� ����� ���� ID!') end
    else imgui.Text(u8 ("����� � ID %s �� ��������� � �������"):format(data.functions.playerid.v)) end
    imgui.Separator()
    imgui.SetCursorPosX(20.0)
    imgui.BeginChild('##1', imgui.ImVec2(-1, -1), true)
    for i = 1, #watchList do
      imgui.TextColoredRGB(watchList[i])
    end
    if #watchList == 0 then imgui.Text(u8 '������ � ������ ������ ���!') end
    imgui.EndChild()
  elseif menu == 20 then
    imgui.PushItemWidth(200)
    imgui.Text(u8'�������� ��������')
    local functions = '������� � �����\0������ �����\0�������� �������������\0��������� ��������������\0������ �������\0'
    if pInfo.settings.rank >= 12 then functions = functions .. "��������/��������\0" end
    if pInfo.settings.rank >= 13 then functions = functions .. "�������\0" end
    if pInfo.settings.rank >= 14 then functions = functions .. "�������\0" end
    imgui.Combo('##combof', data.combo.functions, u8:encode('�� �������\0'..functions..'\0'))
    imgui.Separator()
    ------------
    if data.combo.functions.v == 1 then -- ������� � �����
      imgui.Text(u8'������� ID')
      imgui.InputInt('##player', data.functions.playerid, 0)
      imgui.Text(u8'���������� �����')
      imgui.InputInt('##minutes', data.functions.time)
      imgui.Spacing()
      if sampIsPlayerConnected(data.functions.playerid.v) then
        imgui.Text(u8 ('�����: %s, ��������� � �����. � ��� %s �����'):format(sampGetPlayerNickname(data.functions.playerid.v):gsub('_', ' '), data.functions.time.v))
      else
        imgui.Text(u8 ("����� � ID %s �� ��������� � �������"):format(data.functions.playerid.v))
      end
      if imgui.Button(u8 '������� ������', imgui.ImVec2(-0.1, 30)) then
        if sampIsPlayerConnected(data.functions.playerid.v) then
          funcc('imgui_rubka', 1)
          cmd_r(localVars("punaccept", "rubka", {
            ['id'] = sampGetPlayerNickname(data.functions.playerid.v):gsub("_", " "),
            ['min'] = data.functions.time.v
          }))
        end
      end
    elseif data.combo.functions.v == 2 then -- ������ �����
      imgui.Text(u8'������� ID')
      imgui.InputInt('##player', data.functions.playerid, 0)
      imgui.Text(u8'���������� ������')
      imgui.InputInt('##krugi', data.functions.kolvo)
      imgui.Text(u8'������� ������')
      imgui.InputText('##reason', data.functions.search)
      imgui.Spacing()
      if sampIsPlayerConnected(data.functions.playerid.v) then
        imgui.Text(u8 ('�����: %s �������� ����� %s ������ �� %s'):format(sampGetPlayerNickname(data.functions.playerid.v):gsub('_', ' '), data.functions.kolvo.v, (data.functions.search.v)))
      else
        imgui.Text(u8 ("����� � ID %s �� ��������� � �������"):format(data.functions.playerid.v))
      end
      if imgui.Button(u8 '������ �����', imgui.ImVec2(-0.1, 30)) then
        if sampIsPlayerConnected(data.functions.playerid.v) then
          addcounter(7, 1)
          funcc('imgui_naryad', 1)
          cmd_r(localVars("punaccept", "naryad", {
            ['id'] = sampGetPlayerNickname(data.functions.playerid.v):gsub("_", " "),
            ['count'] = data.functions.kolvo.v,
            ['reason'] = u8:decode(data.functions.search.v)
          }))
        else atext('����� �������!') end
      end
    elseif data.combo.functions.v == 3 then -- �������� �������������
      imgui.Text(u8'������� ID')
      imgui.InputInt('##player', data.functions.playerid, 0)
      imgui.Text(u8'������� �������')
      imgui.InputText('##frac', data.functions.frac)
      imgui.Text(u8'������� �������������')
      imgui.InputText('##reason', data.functions.search)
      imgui.Spacing()
      if sampIsPlayerConnected(data.functions.playerid.v) then
        imgui.Text(u8:encode('�����: '..localVars("punaccept", "blag", {
          ['frac'] = data.functions.frac.v,
          ['id'] = sampGetPlayerNickname(data.functions.playerid.v):gsub("_", " "),
          ['reason'] = data.functions.search.v
        })))
      else
        imgui.Text(u8 ("����� � ID %s �� ��������� � �������"):format(data.functions.playerid.v))
      end
      if imgui.Button(u8 '�������� �������������', imgui.ImVec2(-0.1, 30)) then
        if sampIsPlayerConnected(data.functions.playerid.v) then
          addcounter(7, 1)
          funcc('imgui_blag', 1)
          cmd_r(localVars("punaccept", "blag", {
            ['frac'] = u8:encode(data.functions.frac.v),
            ['id'] = sampGetPlayerNickname(data.functions.playerid.v):gsub("_", " "),
            ['reason'] = u8:decode(data.functions.search.v)
          }))
        else atext('����� �������!') end
      end
    elseif data.combo.functions.v == 4 then -- ��������� ��������������
      imgui.Text(u8'������� ID')
      imgui.InputInt('##player', data.functions.playerid, 0)
      imgui.Text(u8'���������� ������')
      imgui.InputInt('##minutes', data.functions.time)
      imgui.Spacing()
      if sampIsPlayerConnected(data.functions.playerid.v) then
        imgui.Text(u8 ('�����: %s, ���� ��������������. �� ����� %s ������'):format(sampGetPlayerNickname(data.functions.playerid.v):gsub('_', ' '), (data.functions.time.v)))
      else
        imgui.Text(u8 ("����� � ID %s �� ��������� � �������"):format(data.functions.playerid.v))
      end
      if imgui.Button(u8 '��������� ��������������', imgui.ImVec2(-0.1, 30)) then
        if sampIsPlayerConnected(data.functions.playerid.v) then
          funcc('imgui_loc', 1)
          local name = sampGetPlayerNickname(data.functions.playerid.v)
          cmd_r(localVars("punaccept", "loc", {
            ['nick'] = name:gsub('_', ' '),
            ['sec'] = u8:decode(data.functions.time.v)
          }))
        else atext('����� �������!') end
      end
    elseif data.combo.functions.v == 5 then -- ������ �������
      imgui.Text(u8'������� ID')
      imgui.InputInt('##player', data.functions.playerid, 0)
      imgui.Text(u8'��� ��������')
      imgui.InputText('##vig', data.functions.vig)
      imgui.Text(u8'������� ��������')
      imgui.InputText('##reason', data.functions.search)
      imgui.Spacing()
      if sampIsPlayerConnected(data.functions.playerid.v) then
        imgui.Text(u8 ('�����: %s �������� %s ������� �� %s'):format(sampGetPlayerNickname(data.functions.playerid.v):gsub('_', ' '), (data.functions.vig.v), (data.functions.search.v)))
      else
        imgui.Text(u8 ("����� � ID %s �� ��������� � �������"):format(data.functions.playerid.v))
      end
      if imgui.Button(u8 '������ �������', imgui.ImVec2(-0.1, 30)) then
        if sampIsPlayerConnected(data.functions.playerid.v) then
          funcc('imgui_vig', 1)
          cmd_r(localVars("punaccept", "vig", {
            ['id'] = sampGetPlayerNickname(data.functions.playerid.v):gsub("_", " "),
            ['type'] = u8:decode(data.functions.vig.v),
            ['reason'] = u8:decode(data.functions.search.v)
          }))
        else atext('����� �������!') end
      end
    elseif data.combo.functions.v == 6 then -- ��������/��������
      imgui.Text(u8'������� ID')
      imgui.InputInt('##player', data.functions.playerid, 0)
      imgui.Text(u8'������� ����')
      imgui.InputInt('##minutes', data.functions.rank)
      imgui.Spacing()
      if sampIsPlayerConnected(data.functions.playerid.v) then
        imgui.Text(u8 ('�� ����������� �������� ������ %s �� %s ����'):format(sampGetPlayerNickname(data.functions.playerid.v):gsub('_', ' '), data.functions.rank.v))
      else
        imgui.Text(u8 ("����� � ID %s �� ��������� � �������"):format(data.functions.playerid.v))
      end
      if imgui.Button(u8 '�������� ����', imgui.ImVec2(-0.1, 30)) then
        if sampIsPlayerConnected(data.functions.playerid.v) then
          funcc('imgui_giverank', 1)
          sampSendChat(('/giverank %s %s'):format(data.functions.playerid.v, data.functions.rank.v))
        else atext('����� �������!') end
      end
    elseif data.combo.functions.v == 7 then -- �������
      imgui.Text(u8'������� ID')
      imgui.InputInt('##player', data.functions.playerid, 0)
      imgui.Text(u8'������� ����������')
      imgui.InputText('##reason', data.functions.search)
      imgui.Spacing()
      if sampIsPlayerConnected(data.functions.playerid.v) then
        imgui.Text(u8 ('�� ����������� ������� ������ %s �� ������� %s'):format(sampGetPlayerNickname(data.functions.playerid.v):gsub('_', ' '), data.functions.search.v))
      else
        imgui.Text(u8 ("����� � ID %s �� ��������� � �������"):format(data.functions.playerid.v))
      end
      if imgui.Button(u8 '������� ������', imgui.ImVec2(-0.1, 30)) then
        if sampIsPlayerConnected(data.functions.playerid.v) then
          funcc('imgui_uninvite', 1)
          sampSendChat(("/uninvite %s %s"):format(data.functions.playerid.v, u8:decode(data.functions.search.v)))
        else atext('����� �������!') end
      end
    elseif data.combo.functions.v == 8 then -- �������
      imgui.Text(u8'������� ID')
      imgui.InputInt('##player', data.functions.playerid, 0)
      imgui.Text(u8'������� ����')
      imgui.InputInt('##minutes', data.functions.rank)
      imgui.Spacing()
      if sampIsPlayerConnected(data.functions.playerid.v) then
        imgui.Text(u8 ('�� ����������� ������� ������ %s �� %s ����'):format(sampGetPlayerNickname(data.functions.playerid.v):gsub('_', ' '), data.functions.rank.v))
      else
        imgui.Text(u8 ("����� � ID %s �� ��������� � �������"):format(data.functions.playerid.v))
      end
      if imgui.Button(u8 '������� ������', imgui.ImVec2(-0.1, 30)) then
        if sampIsPlayerConnected(data.functions.playerid.v) then
          funcc('imgui_invite', 1)
          if data.functions.rank.v > 1 then
            contractId = data.functions.playerid.v
            contractRank = data.functions.rank.v
          end
          sampSendChat('/invite '..data.functions.playerid.v)
        else atext('����� �������!') end
      end
    end
  elseif menu == 21 then
    imgui.Columns(2, _, false)
    imgui.PushStyleColor(imgui.Col.ChildWindowBg, imgui.ImVec4(0.06, 0.05, 0.07, 1.00))
    imgui.SetColumnWidth(-1, 160.0)
    if imgui.Button(u8'��������� ������', imgui.ImVec2(140, 30)) then
      data.imgui.menu = 22
    end
    imgui.Spacing()
    imgui.BeginChild('##1', imgui.ImVec2(160, -1), imgui.WindowFlags.AlwaysAutoResize)
    if imgui.Selectable(u8'�������� ����', tEditKeys.id == 0 and true or false) then
      tEditKeys = { id = 0, v = {}, buffer = '', wait = 1100 }
    end
    for k, v in ipairs(config_keys.binder) do
      if imgui.Selectable(u8'�������: '..table.concat(rkeys.getKeysName(v.v), " + "), tEditKeys.id == k and true or false) then
        local buff = ""
        for i = 1, #v.text do
          buff = buff .. v.text[i] .. '\n'
        end
        tEditKeys = { id = k, v = v.v, buffer = buff, wait = v.time }
      end
    end
    imgui.EndChild()
    imgui.NextColumn()
    imgui.BeginChild('##2', imgui.ImVec2(imgui.GetWindowWidth() - 150, -1))
    local inputint = imgui.ImInt(tEditKeys.wait)
    local inputbuffer = imgui.ImBuffer(tostring(u8:encode(tEditKeys.buffer)), 1028)
    imgui.PushItemWidth(100.0)
    imgui.Text(u8'�������:')
    imgui.SameLine()
    if imgui.HotKey("##HK", tEditKeys, tLastKeys, 75) then
      if not rkeys.isHotKeyDefined(tEditKeys.v) then
        if rkeys.isHotKeyDefined(tLastKeys.v) then
          rkeys.unRegisterHotKey(tLastKeys.v)
        end
        rkeys.registerHotKey(tEditKeys.v, true, onHotKey)
      end
      filesystem.save(config_keys, 'keys.json')
    end
    imgui.Spacing()
    imgui.Text(u8'�������� (� ��)')
    imgui.SameLine()
    if imgui.InputInt('##inint', inputint, 0) then
      tEditKeys.wait = inputint.v
    end
    imgui.Spacing()
    imgui.PopItemWidth()
    if imgui.InputTextMultiline('##intextmulti', inputbuffer, imgui.ImVec2(imgui.GetWindowWidth(), 190)) then
      tEditKeys.buffer = u8:decode(inputbuffer.v)
    end
    if imgui.Button(u8'���������', imgui.ImVec2(120, 30)) then
      if tEditKeys.wait > 0 and #tEditKeys.v > 0 and tEditKeys.buffer ~= "" then
        local buffer = {}
        for line in tEditKeys.buffer:gmatch('[^\r\n]+') do
          table.insert(buffer, line)
        end
        if tEditKeys.id > 0 then
          config_keys.binder[tEditKeys.id].time = tEditKeys.wait
          config_keys.binder[tEditKeys.id].text = buffer
          config_keys.binder[tEditKeys.id].v = tEditKeys.v
          dtext('������ ������� ���������')
        else
          table.insert(config_keys.binder, { v = tEditKeys.v, time = tEditKeys.wait and tEditKeys.wait or 1100, text = buffer })
          dtext('������� ������� �������')
        end
        filesystem.save(config_keys, 'keys.json')
      else dtext('��� ���� ������ ���� ���������!') end
    end
    imgui.SameLine()
    if imgui.Button(u8'�������', imgui.ImVec2(120, 30)) then
      if tEditKeys.id > 0 then
        local replacedValues = {}
        for k, v in ipairs(config_keys.binder) do
          if k ~= tEditKeys.id then
            replacedValues[#replacedValues + 1] = v
          end
        end
        config_keys.binder = replacedValues
        filesystem.save(config_keys, 'keys.json')
        dtext('������� ������� �������!')
        tEditKeys = { id = 0, v = {}, buffer = '', wait = 1100 }
      else dtext('����� ������� �� ����������!') end
    end
    ------------
    imgui.EndChild()
    imgui.PopStyleColor()
    imgui.Columns(1)
  elseif menu == 22 then
    imgui.Columns(2, _, false)
    imgui.PushStyleColor(imgui.Col.ChildWindowBg, imgui.ImVec4(0.06, 0.05, 0.07, 1.00))
    imgui.SetColumnWidth(-1, 160.0)
    if imgui.Button(u8'��������� ������', imgui.ImVec2(140, 30)) then
      data.imgui.menu = 21
    end
    imgui.BeginChild('##1', imgui.ImVec2(160, -1), imgui.WindowFlags.AlwaysAutoResize)
    if imgui.Selectable(u8'�������� �������', tEditData.id == 0 and true or false) then
      tEditData = { id = 0, cmd = '', buffer = '', wait = 1100 }
    end
    for k, v in ipairs(config_keys.cmd_binder) do
      if imgui.Selectable(u8'�������: /'..v.cmd, tEditData.id == k and true or false) then
        local buff = ""
        for i = 1, #v.text do
          buff = buff .. v.text[i] .. '\n'
        end
        tEditData = { id = k, cmd = v.cmd, buffer = buff, wait = v.wait }
      end
    end
    imgui.EndChild()
    imgui.NextColumn()
    imgui.BeginChild('##2', imgui.ImVec2(imgui.GetWindowWidth() - 150, -1))
    local inputvalue = imgui.ImBuffer(tostring(tEditData.cmd), 128)
    local inputint = imgui.ImInt(tEditData.wait)
    local inputbuffer = imgui.ImBuffer(tostring(u8:encode(tEditData.buffer)), 1028)
    imgui.PushItemWidth(100.0)
    imgui.Text(u8'�������: /')
    imgui.SameLine()
    if imgui.InputText('##intext', inputvalue) then
      tEditData.cmd = inputvalue.v
    end
    imgui.Spacing()
    imgui.Text(u8'�������� (� ��)')
    imgui.SameLine()
    if imgui.InputInt('##inint', inputint, 0) then
      tEditData.wait = inputint.v
    end
    imgui.Spacing()
    imgui.PopItemWidth()
    if imgui.InputTextMultiline('##intextmulti', inputbuffer, imgui.ImVec2(imgui.GetWindowWidth(), 190)) then
      tEditData.buffer = u8:decode(inputbuffer.v)
    end
    if imgui.Button(u8'���������', imgui.ImVec2(120, 30)) then
      if tEditData.wait > 0 and tEditData.cmd ~= "" and tEditData.buffer ~= "" then
        local buffer = {}
        for line in tEditData.buffer:gmatch('[^\r\n]+') do
          table.insert(buffer, line)
        end
        if tEditData.id > 0 then
          config_keys.cmd_binder[tEditData.id].wait = tEditData.wait
          config_keys.cmd_binder[tEditData.id].cmd = tEditData.cmd
          config_keys.cmd_binder[tEditData.id].text = buffer
          dtext('������ ������� ���������')
        else
          table.insert(config_keys.cmd_binder, { wait = tEditData.wait, cmd = tEditData.cmd, text = buffer })
          dtext('������� ������� �������')
        end
        for k, v in ipairs(config_keys.cmd_binder) do
          if sampIsChatCommandDefined(v.cmd) then sampUnregisterChatCommand(v.cmd) end
        end
        registerFastCmd()
        filesystem.save(config_keys, 'keys.json')
      else dtext('��� ���� ������ ���� ���������!') end
    end
    imgui.SameLine()
    if imgui.Button(u8'�������', imgui.ImVec2(120, 30)) then
      if tEditData.id > 0 then
        local replacedValues = {}
        for k, v in ipairs(config_keys.cmd_binder) do
          if sampIsChatCommandDefined(v.cmd) then sampUnregisterChatCommand(v.cmd) end
          if k ~= tEditData.id then
            replacedValues[#replacedValues + 1] = v
          end
        end
        config_keys.cmd_binder = replacedValues
        registerFastCmd()
        filesystem.save(config_keys, 'keys.json')
        dtext('������� ������� �������!')
        tEditData = { id = 0, cmd = '', buffer = '', wait = 1100 }
      else dtext('����� ������� �� ����������!') end
    end
    imgui.EndChild()
    imgui.PopStyleColor()
    imgui.Columns(1)   
  elseif menu == 31 then
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
    imgui.PushStyleColor(imgui.Col.ChildWindowBg, imgui.ImVec4(0.06, 0.05, 0.07, 1.00))
    imgui.Columns(2, _, false)
    imgui.SetColumnWidth(-1, (imgui.GetWindowWidth() / 2) + 40.0)
    imgui.BeginChild('##1', imgui.ImVec2(380, 180), imgui.WindowFlags.AlwaysAutoResize)
    imgui.Text(u8:encode(string.format('������� ��� ��� %s', pInfo.settings.tag ~= nil and "(�������: "..pInfo.settings.tag..")" or "")))
    if imgui.InputText('##tag', tagbuffer) then
      pInfo.settings.tag = u8:decode(tagbuffer.v)
    end
    imgui.SameLine()
    if imgui.Button(u8'������� ���') then
      pInfo.settings.tag = nil
    end
    imgui.Spacing()
    imgui.Text(u8:encode(string.format('������� ��� ����� %s', pInfo.settings.clist ~= nil and "(�������: /clist "..pInfo.settings.clist..")" or "")))
    if imgui.InputText('##clist', clistbuffer) then
      pInfo.settings.clist = u8:decode(clistbuffer.v)
    end
    imgui.SameLine()
    if imgui.Button(u8'������� �����') then
      pInfo.settings.clist = nil
    end
    -----
    if pInfo.settings.autologin then
      imgui.Spacing()
      imgui.Text(u8'������� ������ ��� ����������')
      if imgui.InputText('##pass', passbuffer, imgui.InputTextFlags.Password) then
        pInfo.settings.password = u8:decode(passbuffer.v)
      end   
    end
    imgui.EndChild()
    imgui.NextColumn()
    imgui.BeginChild('##2', imgui.ImVec2(300, 150))
    imgui.Text(u8'�� ��������� ������')
    if data.combo.rpweap.v == -1 then data.combo.rpweap.v = pInfo.settings.rpweapons end
    imgui.Combo(u8'##rpweap', data.combo.rpweap, u8"���������\0�� �������\0�� ������\0��� ������\0\0")
    if pInfo.settings.rpweapons ~= data.combo.rpweap.v then
      pInfo.settings.rpweapons = data.combo.rpweap.v
      atext('��������� ��������!')
    end
    ------------
    imgui.Spacing()
    imgui.Text(u8'��� ������ ��� �� ����������')
    if data.combo.rpsex.v == -1 then
      if pInfo.settings.sex ~= 1 and pInfo.settings.sex ~= 0 then pInfo.settings.sex = 1 end
      data.combo.rpsex.v = pInfo.settings.sex
    end
    imgui.Combo(u8'##rpsex', data.combo.rpsex, u8"�������\0�������\0\0")
    if pInfo.settings.sex ~= data.combo.rpsex.v then
      pInfo.settings.sex = data.combo.rpsex.v
      atext('��������� ��������!')
    end
    imgui.EndChild()
    imgui.Columns(1)
    imgui.Spacing()
    imgui.Separator()
    imgui.Spacing()
    ------------
    if imgui.ToggleButton(u8 'autologin##1', autologin) then
      pInfo.settings.autologin = autologin.v;
      filesystem.save(pInfo, 'config.json')   
    end
    imgui.SameLine(); imgui.Text(u8 '��������� � ����')
    ------------
    if imgui.ToggleButton(u8 'autodoklad##1', doklad) then
      pInfo.settings.autodoklad = doklad.v;
      filesystem.save(pInfo, 'config.json')
    end
    imgui.SameLine(); imgui.Text(u8 '�������� ���������� ��������')
    ------------
    if imgui.ToggleButton(u8 'hud##1', hud) then
      pInfo.settings.hud = hud.v
      window['hud'].bool.v = hud.v
      filesystem.save(pInfo, 'config.json')
    end
    imgui.SameLine(); imgui.Text(u8 '�������� ���')
    ------------
    if imgui.ToggleButton(u8 'dateinmembers##1', membersdate) then
      pInfo.settings.membersdate = membersdate.v;
      filesystem.save(pInfo, 'config.json')
    end
    imgui.SameLine(); imgui.Text(u8 '������ ���� ������� � /members 1')
    ------------
    if imgui.ToggleButton(u8 'target##1', target) then
      pInfo.settings.target = target.v;
      filesystem.save(pInfo, 'config.json')
    end
    imgui.SameLine(); imgui.Text(u8 '�������� Target Bar')
    ------------
    if imgui.ToggleButton(u8 'chatconsole##1', chatconsole) then
      pInfo.settings.chatconsole = chatconsole.v;
      filesystem.save(pInfo, 'config.json')
    end
    imgui.SameLine(); imgui.Text(u8 '����������� ���� � ������� SAMPFUNCS')
    ------------
    imgui.Spacing()
    imgui.Separator()
    imgui.Spacing()
    if imgui.HotKey('##punaccept', config_keys.punaccept, tLastKeys, 100) then
      rkeys.changeHotKey(punacceptbind, config_keys.punaccept.v)
      filesystem.save(config_keys, 'keys.json')
    end
    imgui.SameLine(); imgui.Text(u8 '������� �������� ��������')
    if imgui.HotKey('##targetplayer', config_keys.targetplayer, tLastKeys, 100) then
      rkeys.changeHotKey(targetplayerbind, config_keys.targetplayer.v)
      filesystem.save(config_keys, 'keys.json')
    end
    imgui.SameLine(); imgui.Text(u8 '������� �������������� � Target Menu')
    -----------
    if imgui.HotKey('##rpweap', config_keys.weaponkey, tLastKeys, 100) then
      filesystem.save(config_keys, 'keys.json')
    end
    imgui.SameLine(); imgui.Text(u8 '������� �� ��������� ������')
    imgui.Spacing()
    imgui.Separator()
    imgui.Spacing()
    if imgui.Button(u8 '�������������� ����') then data.imgui.hudpos = true; window['main'].bool.v = false end
    imgui.SameLine()
    if imgui.Button(u8'�������� ������ �������') then
      funcc('updateadm', 1)
      atext('������ ���������. �������� ������ �� �������...')
      logger.info('�������� ������ �� ���������� �������')
      local ip, port = sampGetCurrentServerAddress()
      httpRequest('http://opentest3.000webhostapp.com/api.php?act=getadmins&server='..ip..':'..port, nil, function(response, code, headers, status)
        if response then
          logger.trace("����� �������. ���: "..code..", ������: "..status)
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
            atext('������ ������� ������� ��������! ��������� '..count..' �������')
            loadAdmins()
          else
            logger.warn(string.format("������ �������: ", info.error == nil and "����������� �� ���� ��������" or info.error))
            atext(string.format('������ �������: ', info.error == nil and "����������� �� ���� ��������" or info.error))
          end
        else
          logger.warn("����� �� �������. ���: "..code..", ������: "..status)
          atext('��� ��������� ������� ��������� ������. ���������� �����')
        end
      end)
    end
    imgui.SameLine()
    if imgui.Button(u8'��������� ���������') then
      filesystem.save(pInfo, 'config.json')
      atext('��������� ������� ���������!')
    end
    imgui.PopStyleColor()
  elseif menu == 32 then
    local autobp = imgui.ImBool(pInfo.settings.autobp)
    if pInfo.settings.autobpguns == nil then pInfo.settings.autobpguns = {2,2,0,2,2,1,0} end
    if imgui.ToggleButton(u8 'autobp##1', autobp) then
      pInfo.settings.autobp = autobp.v
      filesystem.save(pInfo, 'config.json')
    end
    imgui.SameLine(); imgui.Text(u8 '�������� �������������� ������ ��')
    imgui.Spacing(); imgui.Separator(); imgui.Spacing()
    -------
    local autolist = {"Desert Eagle", "Shotgun", "MP5", "M4A1", "Rifle", "�����", "���� ������"}
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
  elseif menu == 33 then
    imgui.Columns(2, _, false)
    imgui.PushStyleColor(imgui.Col.ChildWindowBg, imgui.ImVec4(0.06, 0.05, 0.07, 1.00))
    imgui.SetColumnWidth(-1, 160.0)
    if changeText.sex == 1 then
      if imgui.Button(u8'������� ���������', imgui.ImVec2(140, 30)) then
        changeText.sex = 2
      end
    else
      if imgui.Button(u8'������� ���������', imgui.ImVec2(140, 30)) then
        changeText.sex = 1
      end
    end
    imgui.Spacing()
    imgui.BeginChild('##1', imgui.ImVec2(160, -1), imgui.WindowFlags.AlwaysAutoResize)
    if imgui.Selectable(u8'�������� ������', changeText.id == 0 and true or false) then
      local sexs = changeText.sex
      if sexs == 0 then sexs = pInfo.settings.sex end
      changeText = { id = 0, sex = sexs, values = {}, buffer = {} }
    end
    for k, v in pairs(localInfo) do
      if imgui.Selectable(u8:encode(v.title), changeText.id == k and true or false) then
        local sexs = changeText.sex
        if sexs == 0 then sexs = pInfo.settings.sex end
        changeText = { id = k, sex = sexs, values = v, buffer = {} }
      end
    end
    imgui.EndChild()
    imgui.NextColumn()
    imgui.BeginChild('##2', imgui.ImVec2(imgui.GetWindowWidth() - 150, -1))
    imgui.PushItemWidth(imgui.GetWindowWidth())
    for k, v in pairs(changeText.values) do
      if k ~= "title" then
        if changeText.buffer[k] == nil then changeText.buffer[k] = imgui.ImBuffer(tostring(u8:encode(v[changeText.sex + 1])), 256) end
        imgui.Text(u8:encode(v[1]))
        if imgui.InputText('##intext'..k, changeText.buffer[k], 0) then
          v[changeText.sex + 1] = u8:decode(changeText.buffer[k].v)
        end
      end
    end
    imgui.PopItemWidth()
    if changeText.id ~= 0 then
      if imgui.Button(u8'���������', imgui.ImVec2(120, 30)) then
        localInfo[changeText.id] = changeText.values
        filesystem.save(localInfo, 'local.json')
        atext('������ ���������')
      end
    end
    ------------
    imgui.EndChild()
    imgui.PopStyleColor()
    imgui.Columns(1)
  elseif menu == 34 then
    atext("���������������...")
    showCursor(false)
    reloadScriptsParam = true
    thisScript():reload()
  elseif menu == 35 then
    imgui.PushItemWidth(175)
    if #data.functions.checkbox == 0 then
      for i = 1, 5 do
        data.functions.checkbox[i] = imgui.ImBool(false)
      end
    end
    if #data.functions.export == 0 then
      for file in lfs.dir(getWorkingDirectory()..'\\SFAHelper\\accounts') do
        if file ~= "." and file ~= ".." and file ~= sInfo.nick then
          local attr = lfs.attributes(getWorkingDirectory()..'\\SFAHelper\\accounts\\'..file)
          if attr.mode == "directory" then 
            table.insert(data.functions.export, file)
          end
        end
      end
    end
    local strlist = ""
    for i = 1, #data.functions.export do
      strlist = strlist..data.functions.export[i]..'\0'
    end
    imgui.Combo('##exportcombo', data.combo.export, u8:encode('�������� �������\0'..strlist..'\0'))
    imgui.Separator()
    if data.combo.export.v > 0 then
      imgui.Text(u8'�������� ���������, ������� ������ ��������������:')
      imgui.Text(u8:encode(data.functions.export[data.combo.export.v]..' -> '..sInfo.nick))
      imgui.Checkbox(u8 '���������', data.functions.checkbox[1])
      imgui.Checkbox(u8 '�����', data.functions.checkbox[2])
      imgui.Checkbox(u8 '������', data.functions.checkbox[3])
      imgui.Checkbox(u8 '���������', data.functions.checkbox[4])
      if imgui.Button(u8'��������������', imgui.ImVec2(120, 30)) then
        lua_thread.create(function()
          dtext('�������� ������� ��������...')
          local count = 0
          if data.functions.checkbox[1].v then
            logger.debug('������������ ��������� ')
            local file = io.open("moonloader/SFAHelper/accounts/"..data.functions.export[data.combo.export.v].."/config.json", "r+")
            if file ~= nil then
              local cfg = decodeJson(file:read('*a'))
              if cfg ~= nil then
                pInfo.settings = cfg.settings
                count = count + 1
                filesystem.save(pInfo, 'config.json')
              else logger.debug('������� �� ������. ���� ���������/����� ������ �����������') end
              file:close()
            else logger.debug('������� �� ������. ���� �� ������!') end          
          end
          if data.functions.checkbox[2].v then
            logger.debug('������������ �����')
            local file = io.open("moonloader/SFAHelper/accounts/"..data.functions.export[data.combo.export.v].."/posts.json", "r+")
            if file ~= nil then
              local cfg = decodeJson(file:read('*a'))
              if cfg ~= nil then
                postInfo = cfg
                count = count + 1
                filesystem.save(postInfo, 'posts.json')
              else logger.debug('������� ������ �� ������. ���� ���������/����� ������ �����������') end
              file:close()
            else logger.debug('������� ������ �� ������. ���� �� ������!') end          
          end
          if data.functions.checkbox[3].v then
            logger.debug('������������ �����')
            local file = io.open("moonloader/SFAHelper/accounts/"..data.functions.export[data.combo.export.v].."/keys.json", "r+")
            if file ~= nil then
              local cfg = decodeJson(file:read('*a'))
              if cfg ~= nil then
                config_keys = cfg
                count = count + 1
                filesystem.save(config_keys, 'keys.json')
              else logger.debug('������� ������ �� ������. ���� ���������/����� ������ �����������') end
              file:close()
            else logger.debug('������� ������ �� ������. ���� �� ������!') end          
          end
          if data.functions.checkbox[4].v then
            logger.debug('������������ ���������')
            local file = io.open("moonloader/SFAHelper/accounts/"..data.functions.export[data.combo.export.v].."/local.json", "r+")
            if file ~= nil then
              local cfg = decodeJson(file:read('*a'))
              if cfg ~= nil then
                localInfo = cfg
                count = count + 1
                filesystem.save(localInfo, 'local.json')
              else logger.debug('������� ��������� �� ������. ���� ���������/����� ������ �����������') end
              file:close()
            else logger.debug('������� ��������� �� ������. ���� �� ������!') end          
          end
          dtext("������� ��������. ��������� "..count.." ���������. ���������������...")
          showCursor(false)
          reloadScriptsParam = true
          thisScript():reload()
        end)
      end
    end
  elseif menu == 36 then
    local menuText = {"FPS", "������", "����������", "�������", '�����', "������ ������-����", '�����', "�����", "����", "�������", "��������, �����"}
    local opacity = imgui.ImFloat(pInfo.settings.hudopacity)
    local rounding = imgui.ImFloat(pInfo.settings.hudrounding)
    imgui.Text(u8'������������ ����/�������')
    if imgui.SliderFloat('##sliderfloat', opacity, 0.0, 1.0, "%.3f", 0.5) then
      pInfo.settings.hudopacity = opacity.v
    end
    -------
    imgui.Spacing()
    imgui.Text(u8'���������� ������ ����/�������')
    if imgui.SliderFloat('##floatrounding', rounding, 0.0, 15.0, "%.2f", 0.5) then
      pInfo.settings.hudrounding = rounding.v
    end
    for i = 1, #pInfo.settings.hudset do
      if data.functions.checkbox[i] == nil then
        data.functions.checkbox[i] = imgui.ImBool(pInfo.settings.hudset[i])
      end
      imgui.Checkbox(u8:encode(menuText[i]), data.functions.checkbox[i])
      if data.functions.checkbox[i].v ~= pInfo.settings.hudset[i] then
        pInfo.settings.hudset[i] = data.functions.checkbox[i].v
        filesystem.save(pInfo, 'config.json')
      end
    end
    -- FPS, ������, ����������, �������, �����, ������ ������-����, �����, �����, 9 = ping, 10 = �������, 11 - ��������, �����
    -- pInfo.settings.hudset = {false, true, true, true, true, true, false, true}
  elseif menu == 41 then
    for i = #data.punishlog, 1, -1 do
      imgui.Text(u8:encode(("%s | �����: %s (%s)"):format(data.punishlog[i].time, data.punishlog[i].from, data.punishlog[i].rank)))
      imgui.Text(u8:encode("�����: "..data.punishlog[i].text))
      imgui.NewLine()
    end
  end
end

imgui_windows.addtable = function()
  imgui.Combo(u8'�������� ��� ������', data.combo.addtable, u8"�� �������\0���������\0����������\0��������\0�������\0\0")
  imgui.Separator()
  if data.combo.addtable.v > 0 then
    imgui.InputText(u8 '������� ID/��� ������', data.addtable.nick)
  end
  if data.combo.addtable.v == 1 then
    imgui.InputText(u8 '� ������ �����', data.addtable.param1)
    imgui.InputText(u8 '�� ����� ����', data.addtable.param2)
    imgui.InputText(u8 '�������', data.addtable.reason)
  elseif data.combo.addtable.v == 2 then
    imgui.InputText(u8 '�������', data.addtable.reason)
  elseif data.combo.addtable.v == 3 then
    imgui.InputText(u8 '��� �� (1,2)', data.addtable.param2)
    imgui.InputText(u8 '�����', data.addtable.reason)
  elseif data.combo.addtable.v == 4 then
    imgui.InputText(u8 '��� �������� (1 - �������, 2 - �������)', data.addtable.param2)
    imgui.InputText(u8 '�������', data.addtable.reason)
    imgui.InputText(u8 '��������', data.addtable.param1)
  end
  if data.combo.addtable.v > 0 then
    if imgui.Button(u8'���������') then
      local nickname = u8:decode(data.addtable.nick.v)
      local param1 = u8:decode(data.addtable.param1.v)
      local param2 = u8:decode(data.addtable.param2.v)
      local reason = u8:decode(data.addtable.reason.v)
      local pid = tonumber(nickname)
      if sInfo.playerid ~= pid and sInfo.nick ~= nickname then
        if pid ~= nil then
          if sampIsPlayerConnected(pid) then nickname = sampGetPlayerNickname(pid) end
        end
        if tonumber(nickname) == nil then
          if data.combo.addtable.v == 1 then
            if nickname ~= "" and param1 ~= "" and param2 ~= "" and reason ~= "" then
              if tonumber(param1) ~= nil and tonumber(param1) >= 1 and tonumber(param1) < 15 and tonumber(param2) ~= nil and tonumber(param2) >= 1 and tonumber(param2) < 15 then
                atext(("���������: [���: %s] [� �����: %s] [�� ����: %s] [�������: %s]"):format(nickname, param1, param2, reason))
                sendGoogleMessage("giverank", nickname, param1, param2, reason, os.time())
                funcc('imgui_sendgoogle_giverank', 1)
              else atext('�������� ��������� �����!') end
            else atext('��� ���� ������ ���� ���������!') end

          elseif data.combo.addtable.v == 2 then
            if nickname ~= "" and reason ~= "" and nickname ~= nil and reason ~= nil then
              atext(("����������: [���: %s] [�������: %s]"):format(nickname, reason))
              sendGoogleMessage("uninvite", nickname, _, _, reason, os.time())
              funcc('imgui_sendgoogle_uninvite', 1)
            else atext('��� ���� ������ ���� ���������!') end

          elseif data.combo.addtable.v == 3 then
            if nickname ~= "" and nickname ~= nil and reason ~= nil and reason ~= "" and param2 ~= "" and param2 ~= nil then
              if tonumber(param2) ~= nil and (tonumber(param2) == 1 or tonumber(param2) == 2) then
                atext(("��������: [���: %s] [��� ��: %s] [�����: %s]"):format(nickname, param2, reason))
                sendGoogleMessage("contract", nickname, _, param2, reason, os.time())
                funcc('imgui_sendgoogle_contract', 1)
              else atext('�������� ��� ��') end
            else atext('��� ���� ������ ���� ���������!') end

          elseif data.combo.addtable.v == 4 then
            if nickname ~= "" and param1 ~= "" and param2 ~= "" and param2 ~= nil and reason ~= "" and nickname ~= nil and param1 ~= nil and reason ~= nil then
              if tonumber(param2) ~= nil and (tonumber(param2) == 1 or tonumber(param2) == 2) then
                atext(("�������: [���: %s] [���: %s] [��������: %s] [�������: %s]"):format(nickname, param2, param1, reason))
                sendGoogleMessage("reprimand", nickname, param1, param2, reason, os.time())
                funcc('imgui_sendgoogle_reprimand', 1)
              else atext('�������� ��� ��������') end
            else atext('��� ���� ������ ���� ���������!') end
          end
        else atext('�������� ID ������!') end
      else atext('�� �� ������ ������ ���� � �������!') end
    end
  end
end
imgui_windows.binder = function()
  local str = "{mynick} - ��� ���\n{myfullname} - ��� �� ���\n{myname} - ���� ���\n{mysurname} - ���� �������\n{myid} - ��� ID\n"
  str = str.."{myhp} - ���� ��������\n{myarm} - ���� �����\n{myrank} - ��� ���� (��������)\n{myrankname} - ���� ������ (�����)\n"
  str = str.."{kvadrat} - ��� ������� �������\n{tag} - ��� ���\n{frac} - ���� �������\n{city} - ������� �����\n{zone} - ������� �������\n{time} - ������� �����\n"
  str = str.."{date} - ������� ���� � ������� DD.MM.YYYY\n{weaponid} - ID ������ � �����\n{weaponname} - �������� ������ � �����\n{ammo} - ���������� �������� � ������\n"
  str = str.."��������� �����, ���������� ����� ������:\n{tID} - ID ������\n{tnick} - ��� ������\n"
  str = str.."{tfullname} - �� ��� ������\n{tname} - ��� ������\n{tsurname} - ������� ������\n"
  str = str.."�����, ��������� ����� \"/match\":\n{mID} - ID ������\n{mnick} - ��� ������\n{mfullname} - �� ��� ������\n{mname} - ��� ������\n{msurname} - ������� ������\n"
  if data.imgui.menu == 21 then
    local dstr = "[noenter] - �� ���������� ��������� � ���\n\n"
    str = dstr..str
    imgui.Text(u8:encode(str)) 
  elseif data.imgui.menu == 22 then
    local dstr = "{param} - ������ �������� � �������\n{pNickByID} - ��� �� ID � ���������\n{pFullNameByID} - �� ��� �� ID � ���������\n{pNameByID} - ��� �� ID � ���������\n"
    dstr = dstr .. "{pSurnameByID} - ������� �� ID � ���������\n{param2} - ������ ��������\n{param3} - ������ ��������\n"
    str = dstr..str
    imgui.Text(u8:encode(str))
  end
end
imgui_windows.members = function()
  if membersInfo.mode == 0 and #membersInfo.players > 0 then
    imgui.Text(u8:encode(('������ �������: %d | �� ������: %d | ��������: %d'):format(membersInfo.online, membersInfo.work, membersInfo.nowork)))
    imgui.InputText(u8 '����� �� ����/ID', membersInfo.imgui)
    imgui.Columns(6)
    imgui.Separator()
    imgui.SetColumnWidth(-1, 55); imgui.Text('ID'); imgui.NextColumn()
    imgui.SetColumnWidth(-1, 175); imgui.Text('Nickname'); imgui.NextColumn()
    imgui.SetColumnWidth(-1, 125); imgui.Text('Rank'); imgui.NextColumn()
    imgui.SetColumnWidth(-1, 80); imgui.Text('Status'); imgui.NextColumn()
    imgui.SetColumnWidth(-1, 90); imgui.Text('AFK'); imgui.NextColumn()
    imgui.SetColumnWidth(-1, 65); imgui.Text('Dist'); imgui.NextColumn()
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
  else imgui.Text(u8 '������������ ������...') end
  -----
  if imgui.BeginPopupContextItem('ContextMenu', 1) then
    imgui.PushItemWidth(150)
    if selectedContext ~= nil then
      imgui.Text(u8:encode(("�����: %s[%d]"):format(sampGetPlayerNickname(selectedContext), selectedContext)))
    else
      imgui.Text(u8 "�����: �� �������")
    end
    if imgui.Button(u8'��������������', imgui.ImVec2(-0.1, 20)) then
      funcc('imgui_loc_context', 1)
      cmd_loc(selectedContext.." 30")
    end
    if imgui.Button(u8'����������� ���', imgui.ImVec2(-0.1, 20)) then
      funcc('imgui_cn_context', 1)
      cmd_cn(selectedContext.." 1")
    end
    if imgui.Button(u8'����������� �� ���', imgui.ImVec2(-0.1, 20)) then
      funcc('imgui_cn_context', 1)
      cmd_cn(selectedContext.." 0")
    end
    if imgui.Button(u8'���������� ������', imgui.ImVec2(-0.1, 20)) then
      funcc('imgui_match_context', 1)
      cmd_match(""..selectedContext)
    end
    if imgui.Button(u8'��������� �������', imgui.ImVec2(-0.1, 20)) then
      funcc('imgui_checkrank_context', 1)
      cmd_checkrank(""..selectedContext)
    end
    if imgui.Button(u8'��������� ��', imgui.ImVec2(-0.1, 20)) then
      funcc('imgui_checkbl_context', 1)
      cmd_checkbl(""..selectedContext)
    end
    if imgui.Button(u8'��������� ��������', imgui.ImVec2(-0.1, 20)) then
      funcc('imgui_checkvig_context', 1)
      cmd_checkvig(""..selectedContext)
    end
    if imgui.Button(u8'�������', imgui.ImVec2(-0.1, 20)) then
      imgui.CloseCurrentPopup()
    end
    imgui.EndPopup()
  end
  imgui.Separator()
end

imgui_windows.pie = function()
  if pie.BeginPiePopup('PieMenu', 1) then
    if pie.PieMenuItem(u8'��������\n������\n�������') then end
    if pie.PieMenuItem(u8'�������\n������������\n�����') then end
    if pie.PieMenuItem(u8'�����\n�����', false) then end
    if pie.BeginPieMenu(u8'�������') then
      if pie.BeginPieMenu(u8'����') then
        if pie.PieMenuItem(u8'�����') then end
        if pie.PieMenuItem(u8'�����') then end
        pie.EndPieMenu()
      end
      if pie.PieMenuItem(u8'������') then end
      if pie.PieMenuItem(u8'��������') then end
     pie.EndPieMenu()
    end
    pie.EndPiePopup()
  end
end
imgui_windows.hud = function()
  if pInfo.settings.hudset[8] then
    local titlename = u8:encode(string.format('%s-Helper', sInfo.fraction ~= "no" and sInfo.fraction or "SFA"))
    imgui.SetCursorPosX((300 - imgui.CalcTextSize(titlename).x) / 2)
    imgui.Text(titlename)
    imgui.Separator()
  end
  local myping = sampGetPlayerPing(sInfo.playerid)
  imgui.Text(u8:encode(("���: %s[%d]%s%s"):format(sInfo.nick, sInfo.playerid,
    pInfo.settings.hudset[9] and " | Ping: "..myping or "",
    pInfo.settings.hudset[1] and " | FPS: "..math.floor(imgui.GetIO().Framerate) or ""
  )))
  if pInfo.settings.hudset[11] then
    imgui.Text(u8:encode("��������: "..sInfo.health.." | �����: "..sInfo.armour))
  end
  if pInfo.settings.hudset[2] then
    local myweapon = getCurrentCharWeapon(PLAYER_PED)
    local myweaponammo = getAmmoInCharWeapon(PLAYER_PED, myweapon)
    local myweaponname = getweaponname(myweapon)
    imgui.Text(u8:encode(("������: %s [%d]"):format(myweaponname, myweaponammo)))
  end
  if isCharInAnyCar(playerPed) and pInfo.settings.hudset[3] then
    local vHandle = storeCarCharIsInNoSave(playerPed)
    local _, vID = sampGetVehicleIdByCarHandle(vHandle)
    local vHP = getCarHealth(vHandle)
    local speed = math.floor(getCarSpeed(vHandle)) * 2
    local vehName = tCarsName[getCarModel(vHandle) - 399]
    imgui.Text(u8:encode(("����: %s[%d] | ��: %s | ��������: %s"):format(vehName, vID, vHP, speed)))
  elseif pInfo.settings.hudset[3] then
    imgui.Text(u8'����: ���')
  end
  if pInfo.settings.hudset[4] or pInfo.settings.hudset[10] then
    imgui.Text(u8:encode(('%s%s'):format(
      pInfo.settings.hudset[4] and "�������: "..playerZone.." | " or "",
      pInfo.settings.hudset[10] and (sInfo.interior > 0 and "��������: "..sInfo.interior or "�������: "..kvadrat()) or ""
    )))
  end
  if pInfo.settings.hudset[5] then
    imgui.Text(u8'������� �����: '..os.date('%H:%M:%S'))
  end
  if sInfo.tazer and pInfo.settings.hudset[7] then
    imgui.TextColoredRGB('�����: {228B22}�������')
  elseif pInfo.settings.hudset[7] then
    imgui.Text(u8'�����: ��������')
  end
  data.imgui.hudpoint = { x = imgui.GetWindowSize().x, y = imgui.GetWindowSize().y }
  if pInfo.settings.target == true and pInfo.settings.hudset[6] then
    --imgui.Text('Hudpoint | X:'..data.imgui.hudpoint.x..' | Y: '..data.imgui.hudpoint.y)
    imgui.TextColoredRGB('������-���: {228B22}�������')
  elseif pInfo.settings.hudset[6] then
    imgui.Text(u8'������-���: ��������')
  end
end
imgui_windows.target = function()
  imgui.Text(u8:encode(("���: %s[%d]"):format(sampGetPlayerNickname(targetMenu.playerid), targetMenu.playerid)))
  local com = false
  for i = 1, #data.members do
    if data.members[i].pid == targetMenu.playerid then
      imgui.Text(u8:encode(("�������: %s | ������: %s[%d]"):format(sInfo.fraction, pInfo.ranknames[data.members[i].prank], data.members[i].prank)))
      com = true
      break
    end
  end
  if com == false then
    for i = 1, #data.players do
      if data.players[i].nick == sampGetPlayerNickname(targetMenu.playerid) then
        imgui.Text(u8:encode(("�������: %s | ������: %s"):format(data.players[i].fraction, data.players[i].rank)))
        com = true
        break
      end
    end
    if com == false then
      imgui.Text(u8:encode(("�������: %s"):format(sampGetFraktionBySkin(targetMenu.playerid))))
    end
  end
  local arm = tostring(sampGetPlayerArmor(targetMenu.playerid))
  local health = tostring(sampGetPlayerHealth(targetMenu.playerid))
  local ping = tostring(sampGetPlayerPing(targetMenu.playerid))
  imgui.Text(u8:encode(('��������: %s | �����: %s | ����: %s'):format(health, arm, ping)))
  imgui.TextColoredRGB(("���� ����: %s"):format(getcolorname(string.format("%06X", ARGBtoRGB(sampGetPlayerColor(player))))))
end 

------------------------ SECONDARY FUNCTIONS ------------------------
-- ��������� ������
function onHotKey(id, keys)
  lua_thread.create(function()
    local sKeys = tostring(table.concat(keys, " "))
    for k, v in pairs(config_keys.binder) do
      if sKeys == tostring(table.concat(v.v, " ")) then
        funcc('sendkeybinder', 1)
        for i = 1, #v.text do
          if tostring(v.text[i]):len() > 0 then
            -- ���� ������� ������� � ��������, ���������� � ���
            if v.text[i]:find("(.+)%[noenter%]$") then
              -- ������� �� �������, ������ ������� �����.
              local textTag = tags(v.text[i]:gsub("%[noenter%]$", ""), nil)
              if textTag:len() > 0 then
                sampSetChatInputText(textTag)
                sampSetChatInputEnabled(true)
              end
            else
              local textTag = tags(v.text[i]:gsub("%[enter%]$", ""), nil)
              if textTag:len() > 0 then
                sampSendChat(textTag)
              end
            end
            wait(v.time)
          end
        end
      end
    end
  end)
end

function localVars(category, subcategory, args)
  local cat = localInfo[category]
  if cat ~= nil then
    cat = cat[subcategory]
    if cat ~= nil then
      local pos = pInfo.settings.sex == 1 and 2 or 3
      local text = cat[pos]
      if text ~= nil then
        for k, v in pairs(args) do
          text = text:gsub('{'..k..'}', v)
        end
        return text
      end
    end
  end
  return false
end

-- younick, docs, stepen', reason, time
function sendGoogleMessage(type, name, param1, param2, reason, time)
  local mynick = sInfo.nick
  local date = os.date("*t", time)
  date = ("%d.%d.%d %d:%d:%d"):format(date.day, date.month, date.year, date.hour, date.min, date.sec)
  -- ��������� ������
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
  logger.trace("��������� ������ � Google Script")
  local complete = false
  lua_thread.create(function()
    local dlstatus = require('moonloader').download_status
    local downloadpath = getWorkingDirectory() .. '\\SFAHelper\\urlRequests.json'
    wait(50)
    -- Google Script ��������� ������� ����� requests.
    downloadUrlToFile("https://script.google.com/macros/s/AKfycbzTl1YbtWus6nvrHP3RNAO72QfxIJC17AFNF1BlEidr_XKoMjc/exec"..url, downloadpath, function(id, status, p1, p2) -- remove
      if status == dlstatus.STATUS_ENDDOWNLOADDATA then
        logger.trace("������ ���� '"..downloadpath.."'")
        complete = true
      end
    end)
    while complete ~= true do wait(50) end
    logger.trace("��������� ������...")
    local file = io.open("moonloader/SFAHelper/urlRequests.json", "r+")
    if file == nil then logger.trace("����� �� ��� �������") return end
    local cfg = file:read('*a')
    if cfg ~= nil then 
      logger.trace("�������� ������ �� Google Script. ����������: "..cfg)
    else logger.trace("�������� ������ �� Google Script. ����������: �������� ������ �������") end
    file:close()
    wait(50)
    logger.trace("������� ���� '"..downloadpath.."'")
    os.remove(downloadpath)
    return
  end)
end

function downloadFile(link, filename)
  lua_thread.create(function()
    local dlstatus = require('moonloader').download_status
    wait(250)
    logger.trace("��������� ���� '"..filename.."'")
    downloadUrlToFile(link, filename)
    return
  end)
end

-- ������������ ��������� ������
function registerFastCmd()
  for key, value in pairs(config_keys.cmd_binder) do
    if value.cmd and #value.text > 0 then
      if not sampIsChatCommandDefined(value.cmd) then
        sampRegisterChatCommand(value.cmd, function(pam)
          lua_thread.create(function()
            -- ������ ����������� ���������� ������� ��� �������������� ������ ���-�� ����������
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
                    atext(('�������: /%s %s %s %s'):format(value.cmd, params > 0 and "[param]" or "", params > 1 and "[param2]" or "", params > 2 and "[param3]" or ""))
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
        logger.info("�������-���� \""..value.cmd.."\" ��� ����������. ���������� ����������")
      end     
    end
  end
end

-- ������� ��������
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
  text = tostring(text)
  sampAddChatMessage(" � {FFFFFF}"..text, 0x954F4F)
end

function atext(text)
  text = tostring(text)
  sampAddChatMessage(" �SFA-Helper� {FFFFFF}"..text, 0x954F4F)
  -- sampAddChatMessage(" �SFA-Helper� {FFFFFF}����2", 0x0A3241)
  -- sampAddChatMessage(" �SFA-Helper� {FFFFFF}����1", 0x4285F4)
  -- sampAddChatMessage(" �SFA-Helper� {FFFFFF}����2", 0x00A1F1)
  -- sampAddChatMessage(" �SFA-Helper� {FFFFFF}����3", 0x34A853)
  -- sampAddChatMessage(" �SFA-Helper� {FFFFFF}����4", 0x7C8800)
  -- sampAddChatMessage(" �SFA-Helper� {FFFFFF}����6", 0xFFBB00)
  -- sampAddChatMessage(" �SFA-Helper� {FFFFFF}����7", 0xEA4335)
  -- sampAddChatMessage(" �SFA-Helper� {FFFFFF}����7", 0xED0538)
  -- sampAddChatMessage(" �SFA-Helper� {FFFFFF}"..text, 0x448C54)
  -- sampAddChatMessage(" �SFA-Helper� {FFFFFF}"..text, 0x48A0EF)
  -- sampAddChatMessage(" �SFA-Helper� {FFFFFF}"..text, 0x47B13C)
  -- sampAddChatMessage(" �SFA-Helper� {FFFFFF}"..text, 0x01BDA6)
  -- sampAddChatMessage(" �SFA-Helper� {FFFFFF}"..text, 0x1C68C9)
  -- sampAddChatMessage(" �SFA-Helper� {FFFFFF}"..text, 0x588D89)
  -- sampAddChatMessage(" �SFA-Helper� {FFFFFF}"..text, 0x58B6FB)
  -- sampAddChatMessage(" �SFA-Helper� {FFFFFF}"..text, 0xC61A41)
  -- sampAddChatMessage(" �SFA-Helper� {FFFFFF}"..text, 0x2D8DC4)
  -- sampAddChatMessage(" �SFA-Helper� {FFFFFF}"..text, 0x94BC2D)
end

-- ��������� ������������ ������ ��� �������� ����/�������/�������.
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

-- ����������� �������� ����� �� HEX ����
function getcolorname(color)
  local colorlist = {
    { name = "��������", color = "FFFFFE"}, -- 0
    { name = "������", color = "089401"}, -- 1
    { name = "������ ������", color = "56FB4E"}, -- 2
    { name = "���� ������", color = "49E789"}, -- 3
    { name = "���������", color = "2A9170"}, -- 4
    { name = "Ƹ���-�������", color = "9ED201"}, -- 5
    { name = "Ҹ���-�������", color = "279B1E"}, -- 6
    { name = "����-������", color = "51964D"}, -- 7
    { name = "�������", color = "FF0606"}, -- 8
    { name = "����-�������", color = "FF6600"}, -- 9
    { name = "���������", color = "F45000"}, -- 10
    { name = "����������", color = "BE8A01"}, -- 11
    { name = "Ҹ���-�������", color = "B30000"}, -- 12
    { name = "����-�������", color = "954F4F"}, -- 13
    { name = "Ƹ���-���������", color = "E7961D"}, -- 14
    { name = "���������", color = "E6284E"}, -- 15
    { name = "�������", color = "FF9DB6"}, -- 16
    { name = "�����", color = "110CE7"}, -- 17
    { name = "�������", color = "0CD7E7"}, -- 18
    { name = "����� �����", color = "139BEC"}, -- 19
    { name = "����-������", color = "2C9197"}, -- 20
    { name = "Ҹ���-�����", color = "114D71"}, -- 21
    { name = "����������", color = "8813E7"}, -- 22
    { name = "������", color = "B313E7"}, -- 23
    { name = "����-�����", color = "758C9D"}, -- 24
    { name = "Ƹ����", color = "FFDE24"}, -- 25
    { name = "����������", color = "FFEE8A"}, -- 26
    { name = "�������", color = "DDB201"}, -- 27
    { name = "������ ������", color = "DDA701"}, -- 28
    { name = "���������", color = "B0B000"}, -- 29
    { name = "�����", color = "868484"}, -- 30
    { name = "�������", color = "B8B6B6"}, -- 31
    { name = "׸����", color = "333333"}, -- 32
    { name = "�����", color = "FAFAFA"}, -- 33
  }
  for i = 1, #colorlist do
    if color == colorlist[i].color then
      local cid = i - 1 -- ����� ���������� � 0, � ������ � 1
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

-- ���� ��� �������
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
  args = args:gsub("{myrankname}", tostring(pInfo.ranknames[pInfo.settings.rank]))
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
  if names[zone] == nil then return "�� ����������" end
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
  local KV = {"�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�"}
  local X, Y, Z = getCharCoordinates(playerPed)
  X = math.ceil((X + 3000) / 250)
  Y = math.ceil((Y * - 1 + 3000) / 250)
  -- Fix #7469 (27/7/19)
  if X <= 0 or Y < 1 or Y > #KV then return "���" end
  Y = KV[Y]
  local KVX = (Y.."-"..X)
  return KVX
end

function sampGetFraktionBySkin(id)
  local t = '�����������'
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
  -- ������������� ���� �������
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
  logger.debug('������������� ���������. ����������: '..path)
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
  if not doesFileExist(path.."/local.json") then
    local fa = io.open(path.."/local.json", "w")
    fa:write(encodeJson(localInfo))
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
        else
          for j = 1, #tab.binder[i].text do
            if type(tab.binder[i].text[j]) == "string" and tab.binder[i].text[j]:find("%[enter%]$") then
              tab.binder[i].text[j] = tab.binder[i].text[j]:gsub("%[enter%]$", "")
              logger.trace('replaced!')
            end
          end
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
        table.insert(tab.cmd_binder, { cmd = "rpmask", wait = 1100, text = { "/me ������ ����� �� ������� � ����� �� ����", "/clist 32", "/do �� ���� �����, �� ����� ��� ��������������� ������. �������� �� ��������" } })
      end
    end
  end
  return tab
end

--------------------------------[ DO NOT TOUCH ]--------------------------------
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

  style.WindowPadding = ImVec2(15, 15)
  style.WindowRounding = 0.0
  style.FramePadding = ImVec2(5, 5)
  style.FrameRounding = 4.0
  style.ItemSpacing = ImVec2(12, 8)
  style.WindowTitleAlign = ImVec2(0.5, 0.5)
  style.ItemInnerSpacing = ImVec2(8, 6)
  style.IndentSpacing = 25.0
  style.ScrollbarSize = 15.0
  style.ScrollbarRounding = 9.0
  style.GrabMinSize = 5.0
  style.GrabRounding = 3.0

  colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
  colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
  colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
  colors[clr.ChildWindowBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
  colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
  colors[clr.Border] = ImVec4(0.80, 0.80, 0.83, 0.88)
  colors[clr.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00)
  colors[clr.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
  colors[clr.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
  colors[clr.TitleBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.TitleBgCollapsed] = ImVec4(1.00, 0.98, 0.95, 0.75)
  colors[clr.TitleBgActive] = ImVec4(0.07, 0.07, 0.09, 1.00)
  colors[clr.MenuBarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.ScrollbarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
  colors[clr.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
  colors[clr.ScrollbarGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
  colors[clr.ComboBg] = ImVec4(0.19, 0.18, 0.21, 1.00)
  colors[clr.CheckMark] = ImVec4(0.80, 0.80, 0.83, 0.31)
  colors[clr.SliderGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
  colors[clr.SliderGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
  colors[clr.Button] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.ButtonHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
  colors[clr.ButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
  colors[clr.Header] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.HeaderHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
  colors[clr.HeaderActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
  colors[clr.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 0.00)
  colors[clr.ResizeGripHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
  colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
  colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
  colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
  colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
  colors[clr.PlotLines] = ImVec4(0.40, 0.39, 0.38, 0.63)
  colors[clr.PlotLinesHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
  colors[clr.PlotHistogram] = ImVec4(0.40, 0.39, 0.38, 0.63)
  colors[clr.PlotHistogramHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
  colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
  colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end

function isGosFraction(fracname)
  local fracs = {"SFA", "LVA", "LSPD", "SFPD", "LVPD", "Instructors", "FBI", "Medic", "Mayor"}
  for i = 1, #fracs do
    if fracname == fracs[i] then
      return true
    end
  end
  return false
end

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

function bassFlagsOrOperation(flags)
  local result = 0
  for i, v in pairs(flags) do
    result = bit.bor(result, v)
  end
  return result
end

local russian_characters = {
  [168] = '�', [184] = '�', [192] = '�', [193] = '�', [194] = '�', [195] = '�', [196] = '�', [197] = '�', [198] = '�', [199] = '�', [200] = '�', [201] = '�', [202] = '�', [203] = '�', [204] = '�', [205] = '�', [206] = '�', [207] = '�', [208] = '�', [209] = '�', [210] = '�', [211] = '�', [212] = '�', [213] = '�', [214] = '�', [215] = '�', [216] = '�', [217] = '�', [218] = '�', [219] = '�', [220] = '�', [221] = '�', [222] = '�', [223] = '�', [224] = '�', [225] = '�', [226] = '�', [227] = '�', [228] = '�', [229] = '�', [230] = '�', [231] = '�', [232] = '�', [233] = '�', [234] = '�', [235] = '�', [236] = '�', [237] = '�', [238] = '�', [239] = '�', [240] = '�', [241] = '�', [242] = '�', [243] = '�', [244] = '�', [245] = '�', [246] = '�', [247] = '�', [248] = '�', [249] = '�', [250] = '�', [251] = '�', [252] = '�', [253] = '�', [254] = '�', [255] = '�',
}

-- string.lower ��� ������� ����
function rusLower(s)
  local strlen = s:len()
  if strlen == 0 then return s end
  s = s:lower()
  local output = ''
  for i = 1, strlen do
    local ch = s:byte(i)
    if ch >= 192 and ch <= 223 then -- upper russian characters
      output = output .. russian_characters[ch+32]
    elseif ch == 168 then -- �
      output = output .. russian_characters[184]
    else
      output = output .. string.char(ch)
    end
  end
  return output
end

-- string.upper ��� ������� ����
function rusUpper(s)
  local strlen = s:len()
  if strlen == 0 then return s end
  s = s:upper()
  local output = ''
  for i = 1, strlen do
    local ch = s:byte(i)
    if ch >= 224 and ch <= 255 then -- lower russian characters
      output = output .. russian_characters[ch-32]
    elseif ch == 184 then -- �
      output = output .. russian_characters[168]
    else
      output = output .. string.char(ch)
    end
  end
  return output
end

-- ��������� ������� 'to' �������� 'table'.
-- ������������ ������� ��������� = 5 (table.one.two.three.four)
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

-- ����������. ������� ������������ ���-�� �������
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

function drawMembersPlayer(table)
	-- ID  Nick  Rank  Status  AFK  Dist
	local nickname = sampGetPlayerNickname(table.mid)
	local color = sampGetPlayerColor(table.mid)
	local r, g, b = bitex.bextract(color, 16, 8), bitex.bextract(color, 8, 8), bitex.bextract(color, 0, 8)
	local imgui_RGBA = imgui.ImVec4(r / 255.0, g / 255.0, b / 255.0, 1)
	local _, ped = sampGetCharHandleBySampPlayerId(table.mid)
	local distance = "���"
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
	imgui.Text(u8:encode(("%s[%d]"):format(pInfo.ranknames[table.mrank], table.mrank))); imgui.NextColumn()
	imgui.Text(u8:encode(table.mstatus and "�� ������" or "��������")); imgui.NextColumn()
	imgui.Text(u8:encode(table.mafk ~= nil and table.mafk.." ������" or "")); imgui.NextColumn()
	imgui.Text(u8:encode(distance)); imgui.NextColumn()
end

-- ���������� ���� ������ �� ����.
-- �������� � ����������� (0)
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
  else result = string.format("%d ������", second) end
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
