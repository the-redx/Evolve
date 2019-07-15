script_name('Admin Tools')
script_version('1.9999999991')
script_author('Thomas_Lawson, Edward_Franklin')
script_description('Admin Tools for Evolve RP')
script_properties('work-in-pause')
require 'lib.moonloader'
require 'lib.sampfuncs'
local lweapons, weapons     = pcall(require, 'game.weapons')
                              assert(lweapons, 'not found lib game.weapons')
local lsampev, sampev       = pcall(require, 'lib.samp.events')
                              assert(lsampev, 'not found lib lib.samp.events')
local lencoding, encoding   = pcall(require, 'encoding')
                              assert(lencoding, 'not found lib encoding')
local lkey, key             = pcall(require, 'vkeys')
                              assert(lkey, 'not found lib vkeys')
local lMatrix3X3, Matrix3X3 = pcall(require, 'matrix3x3')
                              assert(lMatrix3X3, 'not found lib matrix3x3')
local lVector3D, Vector3D   = pcall(require, 'vector3d')
                              assert(lVector3D, 'not found lib vector3d')
local lffi, ffi             = pcall(require, 'ffi')
                              assert(lffi, 'not found lib ffi')
local lrequests, requests   = pcall(require, 'requests')
                              assert(lrequests, 'not found lib requests')
local lmem, mem             = pcall(require, 'memory')
                              assert(lmem, 'not found lib memory')
local lwm, wm               = pcall(require, 'lib.windows.message')
                              assert(lwm, 'not found lib lib.windows.message')
local limgui, imgui         = pcall(require, 'imgui')
                              assert(limgui, 'not found lib imgui')
local limadd, imadd         = pcall(require, 'imgui_addons')
                              assert(limadd, 'not found lib imgui_addons')
local lrkeys, rkeys         = pcall(require, 'rkeys')
                              assert(lrkeys, 'not found lib rkeys')
local lcopas, copas         = pcall(require, 'copas')
local lhttp, http           = pcall(require, 'copas.http')
local lcrypto, crypto       = pcall(require, 'crypto_lua')
local d3dx9_43              = ffi.load('d3dx9_43.dll')
local getBonePosition       = ffi.cast("int (__thiscall*)(void*, float*, int, bool)", 0x5E4280)
local dlstatus              = require('moonloader').download_status
local screenx, screeny      = getScreenResolution()
encoding.default            = 'CP1251'
local mainwindow            = imgui.ImBool(false)
local settingwindows        = imgui.ImBool(false)
local tpwindow              = imgui.ImBool(false)
local recon                 = imgui.ImBool(false)
local cmdwindow             = imgui.ImBool(false)
local mpwindow              = imgui.ImBool(false)
local bMainWindow           = imgui.ImBool(false)
local sInputEdit            = imgui.ImBuffer(256)
local bIsEnterEdit          = imgui.ImBool(false)
local leadwindow            = imgui.ImBool(false)
local arul                  = imgui.ImBool(false)
local mpend                 = imgui.ImBool(false)
local tunwindow             = imgui.ImBool(false)
local tpname                = imgui.ImBuffer(256)
local tpcoords              = imgui.ImInt3(0, 0, 0)
local newtpname             = imgui.ImBuffer(256)
local mpname                = imgui.ImBuffer(256)
local mpsponsors            = imgui.ImBuffer(256)
local mpwinner              = imgui.ImBuffer(256)
local mcolorb               = imgui.ImInt(0)
local pcolorb               = imgui.ImInt(0)
local bindname              = imgui.ImBuffer(256)
local bindtext              = imgui.ImBuffer(1024)
local prcheck = {pr = 0, prt = {}}
local wrecon = {}
local punishignor = {}
local adminslist = {}
local nop = 0x90
local countstart = false
local killlistmode = 0
local cursorenb = false
local u8 = encoding.UTF8
local airspeed = nil
local reid = -1
local cwid = nil
local check = false
local admins = {}
local nametagCoords = {}
local tpcount = 0
local tprep = false
local swork = true
local nametag = true
local skoktp = 0
local tkilllist = {}
local checkf = {}
local ips = {}
local ips2 = {}
local temp_checker = {}
local temp_checker_online = {}
local leader_checker_online = {}
local rnick = nil
local notification_connect = nil
local notification_disconnect = nil
local hfps = 0
local smsids = {}
local PlayersNickname = {}
local bcheckb  = false
local bnick = nil
local bancheck = false
local reconstate = false
local leaders = {
    ['LSPD'] = '-',
    ['FBI'] = '-',
    ['SFA'] = '-',
    ['LCN'] = '-',
    ['Yakuza'] = '-',
    ['Mayor'] = '-',
    ['SFN'] = '-',
    ['SFPD'] = '-',
    ['Instructors'] = '-',
    ['Ballas'] = '-',
    ['Vagos'] = '-',
    ['RM'] = '-',
    ['Grove'] = '-',
    ['LSN'] = '-',
    ['Aztec'] = '-',
    ['Rifa'] = '-',
    ['LVA'] = '-',
    ['LVN'] = '-',
    ['LVPD'] = '-',
    ['Medic'] = '-',
    ['Mongols MC'] = '-',
    ['Warlocks MC'] = '-',
    ['Pagans MC'] = '-'
}
local leaders1 = {
    ['LSPD'] = '110CE7',
    ['FBI'] = '333333',
    ['SFA'] = '51964D',
    ['LCN'] = 'DDA701',
    ['Yakuza'] = 'FF0000',
    ['Mayor'] = '114D71',
    ['SFN'] = '56FB4E',
    ['SFPD'] = '110CE7',
    ['Instructors'] = '139BEC',
    ['Ballas'] = 'B313E7',
    ['Vagos'] = 'FFDE24',
    ['RM'] = 'B4B5B7',
    ['Grove'] = '009F00',
    ['LSN'] = '758C9D',
    ['Aztec'] = '01FCFF',
    ['Rifa'] = '2A9170',
    ['LVA'] = '51964D',
    ['LVN'] = 'E6284E',
    ['LVPD'] = '110CE7',
    ['Medic'] = '483D8B',
    ['Mongols MC'] = '333333',
    ['Warlocks MC'] = 'F45000',
    ['Pagans MC'] = '2C9197'
}
local config_keys = {
    banipkey = {v = {190}},
    warningkey = {v = {key.VK_Z}},
    reportkey = {v = {key.VK_X}},
    saveposkey = {v = {key.VK_M}},
    goposkey = {v = {key.VK_J}},
    cwarningkey = {v = {key.VK_R}},
    punaccept = {v = {key.VK_Y}},
    pundeny = {v = {key.VK_N}},
    whkey = {v = {16,71}},
    skeletwhkey = {v = {16, 72}},
    airbrkkey = {v = key.VK_RSHIFT}
}
local tplist = {}
local config_colors = {
    admchat = {r = 255, g = 255, b = 0, color = 16776960},
    supchat = {r = 0, g = 255, b = 153, color = 65433},
    smschat = {r = 255, g = 255, b = 0, color = 16776960},
    repchat = {r = 217, g = 119, b = 0, color = 14251776},
    anschat = {r = 140, g = 255, b = 155, color = 9240475},
    askchat = {r = 233, g = 165, b = 40, color = 15312168},
    jbchat = {r = 217, g = 119, b = 0, color = 14251776},
    tracemiss = {r = 0, g = 0, b = 255, color = -16776961},
    tracehit = {r = 255, g = 0, b = 0, color = -65536}
}
local tEditData = {
	id = -1,
	inputActive = false
}
local quitReason = {
    'Выход',
    'Кик/Бан',
    'Тайм-аут'
}
local otletel = {
    grove = {},
    ballas = {},
    rifa = {},
    vagos = {},
    aztec = {}
}
local recon = {
    {
        name = 'Change',
        onclick = function() atext("change") end
    },
    {
        name = "Check »",
        onclick = {
            {
                name = 'Check-GM',
                onclick = function() atext("check-gm") end
            },
            {
                name = 'Check-GM2',
                onclick = function() atext("check-gm2") end
            },
            {
                name = 'Check-GMCar',
                onclick = function() atext("check-gmcar") end
            },
            {
                name = 'ResetShot',
                onclick = function() atext("resetshot") end
            }
        }
    },
    {
        name = 'Drop »',
        onclick = {
            {
                name = 'Mute',
                onclick = function() atext("mute") end
            },
            {
                name = "Slap",
                onclick = function() atext("Slap") end
            },
            {
                name = "Prison",
                onclick = function() atext("prison") end
            },
            {
                name = 'Freeze',
                onclick = function() atext("freeze") end
            },
            {
                name = 'UnFreeze',
                onclick = function() atext("unfreeze") end
            }
        }
    },
    {
        name = "Kick »",
        onclick = {
            {
                name = "SKick",
                onclick = function() atext("skick") end
            },
            {
                name = 'Kick',
                onclick = function() atext("kick") end
            }
        }
    },
    {
        name = "Warn",
        onclick = function() atext("warn") end
    },
    {
        name = "Ban »",
        onclick = {
            {
                name = 'Ban',
                onclick = function() atext("ban") end
            },
            {
                name = "SBan",
                onclick = function() atext("sban") end
            },
            {
                name = 'IBan',
                onclick = function() atext("iban") end
            }
        }
    },
    {
        name = "Refresh",
        onclick = function() atext("refresh") end
    },
    {
        name = 'Exit',
        onclick = function() atext("exit") end
    }
}

local frakrang = {
    Mayor = {
        rang_5 = 15,
        inv = 6
    },
    FBI = {
        rang_6 = 18,
        rang_7 = 18,
        rang_8 = 20,
        rang_9 = 25,
        inv = 15
    },
    PD = {
        rang_11 = 6,
        rang_12 = 7,
        rang_13 = 9,
        inv = 6
    },
    Army = {
        rang_12 = 12,
        rang_13 = 12,
        rang_14 = 12,
        inv = 3
    },
    MOH = {
        rang_7 = 7,
        rang_8 = 10,
        rang_9 = 12,
        inv = 3
    },
    Autoschool = {
        rang_7 = 7,
        rang_8 = 9,
        rang_9 = 12,
        inv = 6
    },
    News = {
        rang_7 = 7,
        rang_8 = 8,
        rang_9 = 10,
        inv = 4
    },
    Gangs = {
        rang_7 = 5,
        rang_8 = 8,
        rang_9 = 9,
        inv = 3
    },
    Mafia = {
        rang_7 = 9,
        rang_8 = 10,
        rang_9 = 12,
        inv = 7
    },
    Bikers = {
        rang_5 = 6,
        rang_6 = 7,
        rang_7 = 10,
        rang_8 = 11,
        inv = 4
    }
}
local tBindList = {
    [1] = {
        text = "",
        v = {},
        name = 'Бинд1'
    },
    [2] = {
        text = "",
        v = {},
        name = 'Бинд2'
    },
    [3] = {
        text = "",
        v = {},
        name = 'Бинд3'
    }
}
local punkey = {
    warn = {
        id = nil,
        day = nil,
        reason = nil,
        admin = nil
    },
    ban = {
        id = nil,
        reason = nil,
        admin = nil
    },
    prison = {
        id = nil,
        day = nil,
        reason = nil,
        admin = nil
    },
    re = {
        id = nil,
        admin = nil
    },
    sban = {
        id = nil,
        reason = nil,
        admin = nil 
    },
    auninvite = {
        id = nil,
        reason = nil,
        admin = nil
    },
    pspawn = {
        id = nil,
        nick = nil
    }
}
local flyInfo = {
    active = false,
    fly_active = false,
    update = os.clock(),
    ----------
    speed_none = 3.0,
    speed_accelerate = 16.0,
    speed_decelerate = 0.0,
    ----------
    currentSpeed = 0.0,
    rotationSpeed = 0.0,
    upSpeed = 0.0,
    ----------
    strafe_none = 0,
    strafe_left = 1,
    strafe_right = 2,
    strafe_up = 3,
    ----------
    keySpeedState = 0,
    keyStrafeState = 0,
    lastKeyStrafeState = 0,
    lastKeySpeedState = 0,
}
local tkills = {}
local BulletSync = {lastId = 0, maxLines = 15}
for i = 1, BulletSync.maxLines do
	BulletSync[i] = {enable = true, o = {x, y, z}, t = {x, y, z}, time = 0, tType = 0}
end
local savecoords = {x = 0, y = 0, z = 0}
local traceid = -1
local players = {}
local admins_online = {}
local players_online = {}
local funcsStatus = {ClickWarp = false, Inv = false, AirBrk = false}
local tLastKeys = {}
local tCarsName = {"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
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
local tCarsTypeName = {"Автомобиль", "Мотоицикл", "Вертолёт", "Самолёт", "Прицеп", "Лодка", "Другое", "Поезд", "Велосипед"}
local tCarsSpeed = {43, 40, 51, 30, 36, 45, 30, 41, 27, 43, 36, 61, 46, 30, 29, 53, 42, 30, 32, 41, 40, 42, 38, 27, 37,
54, 48, 45, 43, 55, 51, 36, 26, 30, 46, 0, 41, 43, 39, 46, 37, 21, 38, 35, 30, 45, 60, 35, 30, 52, 0, 53, 43, 16, 33, 43,
29, 26, 43, 37, 48, 43, 30, 29, 14, 13, 40, 39, 40, 34, 43, 30, 34, 29, 41, 48, 69, 51, 32, 38, 51, 20, 43, 34, 18, 27,
17, 47, 40, 38, 43, 41, 39, 49, 59, 49, 45, 48, 29, 34, 39, 8, 58, 59, 48, 38, 49, 46, 29, 21, 27, 40, 36, 45, 33, 39, 43,
43, 45, 75, 75, 43, 48, 41, 36, 44, 43, 41, 48, 41, 16, 19, 30, 46, 46, 43, 47, -1, -1, 27, 41, 56, 45, 41, 41, 40, 41,
39, 37, 42, 40, 43, 33, 64, 39, 43, 30, 30, 43, 49, 46, 42, 49, 39, 24, 45, 44, 49, 40, -1, -1, 25, 22, 30, 30, 43, 43, 75,
36, 43, 42, 42, 37, 23, 0, 42, 38, 45, 29, 45, 0, 0, 75, 52, 17, 32, 48, 48, 48, 44, 41, 30, 47, 47, 40, 41, 0, 0, 0, 29, 0, 0
}
local tCarsType = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1,
3, 1, 1, 1, 1, 6, 1, 1, 1, 1, 5, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 6, 3, 2, 8, 5, 1, 6, 6, 6, 1,
1, 1, 1, 1, 4, 2, 2, 2, 7, 7, 1, 1, 2, 3, 1, 7, 6, 6, 1, 1, 4, 1, 1, 1, 1, 9, 1, 1, 6, 1,
1, 3, 3, 1, 1, 1, 1, 6, 1, 1, 1, 3, 1, 1, 1, 7, 1, 1, 1, 1, 1, 1, 1, 9, 9, 4, 4, 4, 1, 1, 1,
1, 1, 4, 4, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 8, 8, 7, 1, 1, 1, 1, 1, 1, 1,
1, 3, 1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 8, 8, 7, 1, 1, 1, 1, 1, 4,
1, 1, 1, 2, 1, 1, 5, 1, 2, 1, 1, 1, 7, 5, 4, 4, 7, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5, 5, 5, 1, 5, 5
}
function saveData(table, path)
	if doesFileExist(path) then os.remove(path) end
    local sfa = io.open(path, "w")
    if sfa then
        sfa:write(encodeJson(table))
        sfa:close()
    end
end
function argb_to_rgba(argb)
    local a, r, g, b = explode_argb(argb)
    return join_argb(r, g, b, a)
end

function explode_argb(argb)
    local a = bit.band(bit.rshift(argb, 24), 0xFF)
    local r = bit.band(bit.rshift(argb, 16), 0xFF)
    local g = bit.band(bit.rshift(argb, 8), 0xFF)
    local b = bit.band(argb, 0xFF)
    return a, r, g, b
end

function join_argb(a, r, g, b)
    local argb = b
    argb = bit.bor(argb, bit.lshift(g, 8))
    argb = bit.bor(argb, bit.lshift(r, 16))
    argb = bit.bor(argb, bit.lshift(a, 24))
    return argb
end

function ARGBtoRGB(color) return bit32 or require'bit'.band(color, 0xFFFFFF) end
local data = {
    imgui = {
        menu = 1,
        cheat = 1,
        checker = 1,
        admcheckpos = false,
        reconpos = false
    }
}
local cfg = {
    admchecker = {
        enable = true,
        posx = screenx/2,
        posy = screeny/2,
    },
    playerChecker = {
        enable = true,
        posx = screenx/2,
        posy = screeny/2,
    },
    leadersChecker = {
        enable = true,
        posx = screenx/2,
        posy = screeny/2,
        cvetnick = true
    },
	tempChecker = {
		enable = true,
		posx = screenx/2,
        posy = screeny/2,
        wadd = true,
	},
    cheat = {
        airbrkspeed = 0.5,
        autogm = true
    },
    crecon = {
        posx = screenx/2,
        posy = screeny/2,
        enable = false
    },
	timers = {
		sbivtimer = 30,
		csbivtimer = 60,
        cbugtimer = 60,
        mnarkotimer = 7,
        mcbugtimer = 3
    },
    joinquit = {
        joinposx = 3,
        joinposy = screeny-45,
        quitposx = 3,
        quitposy = screeny-30,
        enable = true
    },
    killlist = {
        posx = screenx/2,
        posy = screeny/2,
        startenable = true
    },
    other = {
		passb = false,
		apassb = false,
        password = "",
        adminpass = "",
        reconw = true,
        checksize = 9,
        checkfont = 'Arial',
        whfont = "Verdana",
        whsize = 8,
        hudfont = "Times New Roman",
        killfont = "Times New Roman",
        killsize = 10,
        hudsize = 10,
        fracstat = true,
        chatconsole = false,
        admlvl = 0,
        autoupdate = true,
        delay = 1200,
        skeletwh = true,
        socrpm = false
    }
}
local fraklist = {
    POLICE = {
        [1] = 'Кадет',
        [2] = 'Офицер',
        [3] = 'Мл.Сержант',
        [4] = 'Сержант',
        [5] = 'Прапорщик',
        [6] = 'Ст.Прапорщик',
        [7] = 'Мл.Лейтенант',
        [8] = 'Лейтенант',
        [9] = 'Ст.Лейтенант',
        [10] = 'Капитан',
        [11] = 'Майор',
        [12] = 'Подполковник',
        [13] = 'Полковник',
        [14] = 'Шериф'
    },
    FBI = {
        [1] = 'Стажёр',
        [2] = 'Дежурный',
        [3] = 'Мл.Агент',
        [4] = 'Агент DEA',
        [5] = 'Агент CID',
        [6] = 'Глава DEA',
        [7] = 'Глава CID',
        [8] = 'Инспектор FBI',
        [9] = 'Зам.Директора FBI',
        [10] = 'Директор FBI'
    },
    ARMY = {
        [1] = 'Рядовой',
        [2] = 'Ефрейтор',
        [3] = 'Мл.Сержант',
        [4] = 'Сержант',
        [5] = 'Ст.Сержант',
        [6] = 'Старшина',
        [7] = 'Прапорщик',
        [8] = 'Мл.Лейтенант',
        [9] = 'Лейтенант',
        [10] = 'Ст.Лейтенант',
        [11] = 'Капитан',
        [12] = 'Майор',
        [13] = 'Подполковник',
        [14] = 'Полковник',
        [15] = 'Генерал'
    },
    LCN = {
        [1] = 'Новицио',
        [2] = 'Ассосиато',
        [3] = 'Сомбаттенте',
        [4] = 'Солдато',
        [5] = 'Боец',
        [6] = 'Сотто-Капо',
        [7] = 'Капо',
        [8] = 'Младший Босс',
        [9] = 'Консильери',
        [10] = 'Дон'
    },
    YAKUZA = {
        [1] = 'Вакасю',
        [2] = 'Сятей',
        [3] = 'Кедай',
        [4] = 'Фуку-Комбуте',
        [5] = 'Вагакасира',
        [6] = 'Со-Хомбуте',
        [7] = 'Камбу',
        [8] = 'Сайко-Комон',
        [9] = 'Оядзи',
        [10] = 'Кумите'
    },
    MAYOR = {
        [1] = 'Секретарь',
        [2] = 'Охранник',
        [3] = 'Адвокат',
        [4] = 'Начальник охраны',
        [5] = 'Зам. Мэра',
        [6] = 'Мэр'
    },
    NEWS = {
        [1] = 'Стажер',
        [2] = 'Звукооператор',
        [3] = 'Звукорежиссер',
        [4] = 'Репортер',
        [5] = 'Ведущий',
        [6] = 'Редактор',
        [7] = 'Гл.Редактор',
        [8] = 'Тех.Директор',
        [9] = 'Програмный директор',
        [10] = 'Ген.Директор'
    },
    SFPD = {
        [1] = 'Кадет',
        [2] = 'Офицер',
        [3] = 'Мл.Сержант',
        [4] = 'Сержант',
        [5] = 'Прапорщик',
        [6] = 'Ст.Прапорщик',
        [7] = 'Мл.Лейтенант',
        [8] = 'Лейтенант',
        [9] = 'Ст.Лейтенант',
        [10] = 'Капитан',
        [11] = 'Майор',
        [12] = 'Подполковник',
        [13] = 'Полковник',
        [14] = 'Шериф'
    },
    INS = {
        [1] = 'Стажёр',
        [2] = 'Консультант',
        [3] = 'Экзаменатор',
        [4] = 'Мл.Инструктор',
        [5] = 'Инструктор',
        [6] = 'Координатор',
        [7] = 'Мл.Менеджер',
        [8] = 'Ст.Менеджер',
        [9] = 'Директор',
        [10] = 'Управляющий'
    },
    BALLAS = {
        [1] = 'Блайд',
        [2] = 'Младший Нига',
        [3] = 'Крэкер',
        [4] = 'Гун брo',
        [5] = 'Ап Бро',
        [6] = 'Гангстер',
        [7] = 'Федерал Блок',
        [8] = 'Фолкс',
        [9] = 'Райч Нига',
        [10] = 'Биг Вилли'
    },
    VAGOS = {
        [1] = 'Новатто',
        [2] = 'Ординарио',
        [3] = 'Локал',
        [4] = 'Верификадо',
        [5] = 'Бандито',
        [6] = 'V.E.G',
        [7] = 'Ассесино',
        [8] = 'Лидер V.E.G',
        [9] = 'Падрино',
        [10] = 'Падре'
    },
    RM = {
        [1] = 'Шнырь',
        [2] = 'Фраер',
        [3] = 'Бык',
        [4] = 'Барыга',
        [5] = 'Блатной',
        [6] = 'Свояк',
        [7] = 'Браток',
        [8] = 'Вор',
        [9] = 'Вор в законе',
        [10] = 'Авторитер'
    },
    GROVE = {
        [1] = 'Плейа',
        [2] = 'Хастла',
        [3] = 'Килла',
        [4] = 'Йонг',
        [5] = 'Гангста',
        [6] = 'О.Г.',
        [7] = 'Мобста',
        [8] = 'Де Кинг',
        [9] = 'Легенд',
        [10] = 'Мэд Дог'
    },
    AZTEC = {
        [1] = 'Перро',
        [2] = 'Тирадор',
        [3] = 'Геттор',
        [4] = 'Лас Герас',
        [5] = 'Мирандо',
        [6] = 'Сабио',
        [7] = 'Инвасор',
        [8] = 'Тесореро',
        [9] = 'Нестро',
        [10] = 'Падре'
    },
    RIFA = {
        [1] = 'Новато',
        [2] = 'Ладрон',
        [3] = 'Амиго',
        [4] = 'Мачо',
        [5] = 'Джуниор',
        [6] = 'Эрмано',
        [7] = 'Бандидо',
        [8] = 'Ауторидад',
        [9] = 'Аджунто',
        [10] = 'Падре'
    },
    MEDIC = {
        [1] = 'Интерн',
        [2] = 'Санитар',
        [3] = 'Мед.Брат',
        [4] = 'Спасатель',
        [5] = 'Нарколог',
        [6] = 'Доктор',
        [7] = 'Психолог',
        [8] = 'Хирург',
        [9] = 'Зам.Глав.Врача',
        [10] = 'Глав.Врач'
    },
    BIKERS = {
        [1] = 'Support', 
        [2] = 'Hang around',
        [3] = 'Prospect',
        [4] = 'Member',
        [5] = 'Road captain',
        [6] = 'Sergeant-at-arms',
        [7] = 'Treasurer',
        [8] = 'Вице президент',
        [9] = 'Президент'
    }
}
local ID = {
    Fist = 0,
    Knuckles = 1,
    Golf = 2,
    Stick = 3,
    Knife = 4,
    Bat = 5,
    Shovel = 6,
    Cue = 7,
    Katana = 8,
    Chainsaw = 9,
    Dildo1 = 10,
    Dildo2 = 11,
    Dildo3 = 12,
    Dildo4 = 13,
    Flowers = 14,
    Cane = 15,
    Grenade = 16,
    Gas = 17,
    Molotov = 18,
    Pistol = 22,
    Slicend = 23,
    Deagle = 24,
    Shotgun = 25,
    Sawnoff = 26,
    Combat = 27,
    Uzi = 28,
    MP5 = 29,
    Ak47 = 30,
    M4 = 31,
    Tec9 = 32,
    Rifle = 33,
    Sniper = 34,
    RPG = 35,
    Launcher = 36,
    Flame = 37,
    Minigun = 38,
    Satchel = 39,
    Detonator = 40,
    Spray = 41,
    Extinguisher = 42,
    Camera = 43,
    Goggles1 = 44,
    Goggles2 = 45,
    Parachute = 46,
    Fake = 47,
    Huy2 = 48,
    Vehicle = 49,
    Helicopter = 50,
    Explosion = 51,
    Huy = 52,
    Drown = 53,
    Collision = 54,
    Connect = 200,
    Disconnect = 201,
    Suicide = 255
}
local RenderGun = {
    [ID.Fist] = 37,
    [ID.Knuckles] = 66,
    [ID.Golf] = 62,
    [ID.Stick] = 40,
    [ID.Knife] = 67,
    [ID.Bat] = 63,
    [ID.Shovel] = 38,
    [ID.Cue] = 34,
    [ID.Katana] = 33,
    [ID.Chainsaw] = 49,
    [ID.Dildo1] = 69,
	[ID.Dildo2] = 69,
	[ID.Dildo3] = 69,
    [ID.Dildo4] = 69,
    [ID.Flowers] = 36,
    [ID.Cane] = 35,
    [ID.Grenade] = 64,
    [ID.Gas] = 68,
    [ID.Molotov] = 39,
    [ID.Pistol] = 54,
    [ID.Slicend] = 50,
    [ID.Deagle] = 51,
    [ID.Shotgun] = 61,
    [ID.Sawnoff] = 48,
    [ID.Combat] = 43,
    [ID.Uzi] = 73,
    [ID.MP5] = 56,
    [ID.Ak47] = 72,
    [ID.M4] = 53,
    [ID.Tec9] = 55,
    [ID.Rifle] = 46,
    [ID.Sniper] = 65,
    [ID.RPG] = 52,
    [ID.Launcher] = 41,
    [ID.Flame] = 42,
    [ID.Minigun] = 70,
    [ID.Satchel] = 60,
    [ID.Detonator] = 59,
    [ID.Spray] = 47,
    [ID.Extinguisher] = 44,
    [ID.Camera] = 74,
    [ID.Goggles1] = 45,
    [ID.Goggles2] = 45,
    [ID.Parachute] = 74,
    [ID.Fake] = 74,
    [ID.Huy2] = 74,
    [ID.Vehicle] = 77,
    [ID.Helicopter] = 82,
    [ID.Explosion] = 81,
    [ID.Huy] = 74,
    [ID.Drown] = 74,
    [ID.Collision] = 75,
    [ID.Connect] = 78,
    [ID.Disconnect] = 78,
    [ID.Suicide] = 74
}

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

function d3dxfont_create(name, height, charset)
    charset = charset or 1
    local d3ddev = ffi.cast('void*', getD3DDevicePtr())
    local pfont = ffi.new('ID3DXFont*[1]', {nil})
    if tonumber(d3dx9_43.D3DXCreateFontA(d3ddev, height, 0, 600, 1, false, charset, 0, 4, 0, name, pfont)) < 0 then
        return nil
    end
    return pfont[0]
end

function d3dxfont_draw(font, text, rect, color, format)
    local prect = ffi.new('RECT[1]', {{rect[1], rect[2], rect[3], rect[4]}})
    return font.vtbl.DrawTextA(font, nil, text, -1, prect, format, color)
end
function onD3DDeviceLost()
    if fonts_loaded then
        font_gtaweapon3.vtbl.OnLostDevice(font_gtaweapon3)
    end
end

function onD3DDeviceReset()
    if fonts_loaded then
        font_gtaweapon3.vtbl.OnResetDevice(font_gtaweapon3)
    end
end
function atext(text)
    sampAddChatMessage(string.format(' Admin Tools | {ffffff}%s', text), 0x66FF00)
end
function apply_custom_style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2

    style.WindowPadding = ImVec2(15, 15)
    style.WindowRounding = 5.0
    --style.FramePadding = ImVec2(5, 5)
    style.FrameRounding = 4.0
    --[[style.ItemSpacing = ImVec2(12, 8)
    style.ItemInnerSpacing = ImVec2(8, 6)]]
    style.IndentSpacing = 25.0
    style.ScrollbarSize = 15.0
    style.ScrollbarRounding = 9.0
    style.GrabMinSize = 5.0
    style.GrabRounding = 3.0

    colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
    colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
    colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.ChildWindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
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
function transform2d(x, y, z)
    local view = require("ffi").cast("float *", 0xB6FA2C)
    local sx, sy = getScreenResolution()
    local nx, ny, nz

    nx = view[0] * x + view[4] * y + view[8] * z + view[12] * 1
    ny = view[1] * x + view[5] * y + view[9] * z + view[13] * 1
    nz = view[2] * x + view[6] * y + view[10] * z + view[14] * 1

    return nx * sx / nz, ny * sy / nz, nz
end
function calcScreenCoors(fX,fY,fZ)
	local dwM = 0xB6FA2C

	local m_11 = mem.getfloat(dwM + 0*4)
	local m_12 = mem.getfloat(dwM + 1*4)
	local m_13 = mem.getfloat(dwM + 2*4)
	local m_21 = mem.getfloat(dwM + 4*4)
	local m_22 = mem.getfloat(dwM + 5*4)
	local m_23 = mem.getfloat(dwM + 6*4)
	local m_31 = mem.getfloat(dwM + 8*4)
	local m_32 = mem.getfloat(dwM + 9*4)
	local m_33 = mem.getfloat(dwM + 10*4)
	local m_41 = mem.getfloat(dwM + 12*4)
	local m_42 = mem.getfloat(dwM + 13*4)
	local m_43 = mem.getfloat(dwM + 14*4)

	local dwLenX = mem.read(0xC17044, 4)
	local dwLenY = mem.read(0xC17048, 4)

	frX = fZ * m_31 + fY * m_21 + fX * m_11 + m_41
	frY = fZ * m_32 + fY * m_22 + fX * m_12 + m_42
	frZ = fZ * m_33 + fY * m_23 + fX * m_13 + m_43

	fRecip = 1.0/frZ
	frX = frX * (fRecip * dwLenX)
	frY = frY * (fRecip * dwLenY)

    --[[if(frX<=dwLenX and frY<=dwLenY and frZ>1)then
        return frX, frY, frZ
	else
		return -1, -1, -1
    end]]
    return frX, frY, frZ
end
ffi.cdef[[
bool DwmEnableComposition(int uCompositionAction);
]]
ffi.cdef [[
typedef struct stRECT
{
    int left, top, right, bottom;
} RECT;

typedef struct stID3DXFont
{
    struct ID3DXFont_vtbl* vtbl;
} ID3DXFont;

struct ID3DXFont_vtbl
{
        void* QueryInterface; // STDMETHOD(QueryInterface)(THIS_ REFIID iid, LPVOID *ppv) PURE;
    void* AddRef; // STDMETHOD_(ULONG, AddRef)(THIS) PURE;
    uint32_t (__stdcall * Release)(ID3DXFont* font); // STDMETHOD_(ULONG, Release)(THIS) PURE;

    // ID3DXFont
    void* GetDevice; // STDMETHOD(GetDevice)(THIS_ LPDIRECT3DDEVICE9 *ppDevice) PURE;
    void* GetDescA; // STDMETHOD(GetDescA)(THIS_ D3DXFONT_DESCA *pDesc) PURE;
    void* GetDescW; // STDMETHOD(GetDescW)(THIS_ D3DXFONT_DESCW *pDesc) PURE;
    void* GetTextMetricsA; // STDMETHOD_(BOOL, GetTextMetricsA)(THIS_ TEXTMETRICA *pTextMetrics) PURE;
    void* GetTextMetricsW; // STDMETHOD_(BOOL, GetTextMetricsW)(THIS_ TEXTMETRICW *pTextMetrics) PURE;

    void* GetDC; // STDMETHOD_(HDC, GetDC)(THIS) PURE;
    void* GetGlyphData; // STDMETHOD(GetGlyphData)(THIS_ UINT Glyph, LPDIRECT3DTEXTURE9 *ppTexture, RECT *pBlackBox, POINT *pCellInc) PURE;

    void* PreloadCharacters; // STDMETHOD(PreloadCharacters)(THIS_ UINT First, UINT Last) PURE;
    void* PreloadGlyphs; // STDMETHOD(PreloadGlyphs)(THIS_ UINT First, UINT Last) PURE;
    void* PreloadTextA; // STDMETHOD(PreloadTextA)(THIS_ LPCSTR pString, INT Count) PURE;
    void* PreloadTextW; // STDMETHOD(PreloadTextW)(THIS_ LPCWSTR pString, INT Count) PURE;

    int (__stdcall * DrawTextA)(ID3DXFont* font, void* pSprite, const char* pString, int Count, RECT* pRect, uint32_t Format, uint32_t Color); // STDMETHOD_(INT, DrawTextA)(THIS_ LPD3DXSPRITE pSprite, LPCSTR pString, INT Count, LPRECT pRect, DWORD Format, D3DCOLOR Color) PURE;
    void* DrawTextW; // STDMETHOD_(INT, DrawTextW)(THIS_ LPD3DXSPRITE pSprite, LPCWSTR pString, INT Count, LPRECT pRect, DWORD Format, D3DCOLOR Color) PURE;

    void (__stdcall * OnLostDevice)(ID3DXFont* font); // STDMETHOD(OnLostDevice)(THIS) PURE;
    void (__stdcall * OnResetDevice)(ID3DXFont* font); // STDMETHOD(OnResetDevice)(THIS) PURE;
};

uint32_t D3DXCreateFontA(void* pDevice, int Height, uint32_t Width, uint32_t Weight, uint32_t MipLevels, bool Italic, uint32_t CharSet, uint32_t OutputPrecision, uint32_t Quality, uint32_t PitchAndFamily, const char* pFaceName, ID3DXFont** ppFont);
]]
ffi.cdef[[
    typedef unsigned short WORD;

    typedef struct _SYSTEMTIME {
        WORD wYear;
        WORD wMonth;
        WORD wDayOfWeek;
        WORD wDay;
        WORD wHour;
        WORD wMinute;
        WORD wSecond;
        WORD wMilliseconds;
    } SYSTEMTIME, *PSYSTEMTIME;

    void GetSystemTime(
        PSYSTEMTIME lpSystemTime
    );

    void GetLocalTime(
        PSYSTEMTIME lpSystemTime
    );
]]

ffi.cdef[[
struct stKillEntry
{
char                    szKiller[25];
char                    szVictim[25];
uint32_t                clKillerColor; // D3DCOLOR
uint32_t                clVictimColor; // D3DCOLOR
uint8_t                 byteType;
} __attribute__ ((packed));

struct stKillInfo
{
int                     iEnabled;
struct stKillEntry      killEntry[5];
int                     iLongestNickLength;
int                     iOffsetX;
int                     iOffsetY;
void                  *pD3DFont; // ID3DXFont
void                  *pWeaponFont1; // ID3DXFont
void                *pWeaponFont2; // ID3DXFont
void                    *pSprite;
void                    *pD3DDevice;
int                     iAuxFontInited;
void                 *pAuxFont1; // ID3DXFont
void                 *pAuxFont2; // ID3DXFont
} __attribute__ ((packed));
]]

function isKillstatActive()
    local stKillInfo = ffi.cast('struct stKillInfo*', sampGetKillInfoPtr())
    return stKillInfo.iEnabled == 1
end

function systemTime()
    local time = ffi.new("SYSTEMTIME")
    ffi.C.GetSystemTime(time)
    return time
end

function localTime()
    local time = ffi.new("SYSTEMTIME")
    ffi.C.GetLocalTime(time)
    return time
end
function rainbow(speed, alpha)
	local r = math.sin(os.clock() * speed)
	local g = math.sin(os.clock() * speed + 2)
	local b = math.sin(os.clock() * speed + 4)
	return r,g,b,alpha
end
function sampGetStreamedPlayers()
	local t = {}
	for i = 0, sampGetMaxPlayerId(false) do
		if sampIsPlayerConnected(i) then
			local result, sped = sampGetCharHandleBySampPlayerId(i)
			if result then
				if doesCharExist(sped) then
					table.insert(t, i)
                end
			end
		end
    end
	return t
end
function registerFastAnswer()
    if cfg.other.socrpm then
        for line in io.lines('moonloader/config/Admin Tools/fa.txt') do
            local cmd, text = line:match('(.+) = (.+)')
            if cmd and text then
                if sampIsChatCommandDefined(cmd) then sampUnregisterChatCommand(cmd) end
                sampRegisterChatCommand(cmd, function(pam)
                    cID = tonumber(pam)
                    if cID ~= nil then
                        sampSendChat('/pm '..cID..' '..text, -1)
                    else
                        if pam ~= nil then
                            sampSendChat('/'..cmd..' '..pam, -1)
                        end
                    end
                end)
            end
        end
    end
end
local russian_characters = {
    [168] = 'Ё', [184] = 'ё', [192] = 'А', [193] = 'Б', [194] = 'В', [195] = 'Г', [196] = 'Д', [197] = 'Е', [198] = 'Ж', [199] = 'З', [200] = 'И', [201] = 'Й', [202] = 'К', [203] = 'Л', [204] = 'М', [205] = 'Н', [206] = 'О', [207] = 'П', [208] = 'Р', [209] = 'С', [210] = 'Т', [211] = 'У', [212] = 'Ф', [213] = 'Х', [214] = 'Ц', [215] = 'Ч', [216] = 'Ш', [217] = 'Щ', [218] = 'Ъ', [219] = 'Ы', [220] = 'Ь', [221] = 'Э', [222] = 'Ю', [223] = 'Я', [224] = 'а', [225] = 'б', [226] = 'в', [227] = 'г', [228] = 'д', [229] = 'е', [230] = 'ж', [231] = 'з', [232] = 'и', [233] = 'й', [234] = 'к', [235] = 'л', [236] = 'м', [237] = 'н', [238] = 'о', [239] = 'п', [240] = 'р', [241] = 'с', [242] = 'т', [243] = 'у', [244] = 'ф', [245] = 'х', [246] = 'ц', [247] = 'ч', [248] = 'ш', [249] = 'щ', [250] = 'ъ', [251] = 'ы', [252] = 'ь', [253] = 'э', [254] = 'ю', [255] = 'я',
}
function string.rlower(s)
    s = s:lower()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:lower()
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 192 and ch <= 223 then
            output = output .. russian_characters[ch + 32]
        elseif ch == 168 then
            output = output .. russian_characters[184]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end
function string.rupper(s)
    s = s:upper()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:upper()
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 224 and ch <= 255 then
            output = output .. russian_characters[ch - 32]
        elseif ch == 184 then
            output = output .. russian_characters[168]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end
function autoupdate(json_url, url)
    httpRequest(json_url, nil, function(response, code, headers, status)
        if response then
            local info = decodeJson(response)
            updatelink = info.admintools.url --testat если не исходник
            updateversion = info.admintools.version
            if updateversion > thisScript().version then
                lua_thread.create(function()
                    local dlstatus = require('moonloader').download_status
                    atext(("Обнаружено обновление. Пытаюсь обновиться с %s на %s"):format(thisScript().version, updateversion))
                    downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23) 
                        if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                            print(("Загружено %d из %d."):format(p13, p23))
                        elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                            print("Загрузка обновления завершена.")
                            atext("Обновление завершено!")
                            goupdatestatus = true
                            thisScript():reload()
                        end
                        if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                            if not goupdatestatus then
                                atext("Обновление прошло неудачно. Запускаю устаревшую версию.")
                            end
                        end
                    end)
                end)
            else
                print(("v%s: Обновление не требуется"):format(thisScript().version))
            end
        else
            print(("v%s: Не могу проверить обновление. Смиритесь или проверьте самостоятельно на %s"):format(thisScript().version, url))
        end
    end)
end
function split(str, delim, plain)
    local lines, pos, plain = {}, 1, not (plain == false)
    repeat
        local npos, epos = string.find(str, delim, pos, plain)
        table.insert(lines, string.sub(str, pos, npos and npos - 1))
        pos = epos and epos + 1
    until not pos
    return lines
end
function text_notify_connect(msg, color)
    if not msg then return end
    local displayDuration = math.max(#msg * 0.065, 3)
    notification_connect = {
        color = bit.band(color or 0xEEEEEE, 0xFFFFFF),
        lines = split(msg, '\n'),
        duration = displayDuration,
        tick = localClock()
    }
end
function text_notify_disconnect(msg, color)
    if not msg then return end
    local displayDuration = math.max(#msg * 0.065, 3)
    notification_disconnect = {
        color = bit.band(color or 0xEEEEEE, 0xFFFFFF),
        lines = split(msg, '\n'),
        duration = displayDuration,
        tick = localClock()
    }
end
function enableKillList(enabled)
    setStructElement(sampGetKillInfoPtr(), 0x0, 4, enabled and 1 or 0)
end
function genCode(skey)
    skey = basexx.from_base32(skey)
    value = math.floor(os.time() / 30)
    value = string.char(
    0, 0, 0, 0,
    band(value, 0xFF000000) / 0x1000000,
    band(value, 0xFF0000) / 0x10000,
    band(value, 0xFF00) / 0x100,
    band(value, 0xFF))
    local hash = sha1.hmac_binary(skey, value)
    local offset = band(hash:sub(-1):byte(1, 1), 0xF)
    local function bytesToInt(a,b,c,d)
      return a*0x1000000 + b*0x10000 + c*0x100 + d
    end
    hash = bytesToInt(hash:byte(offset + 1, offset + 4))
    hash = band(hash, 0x7FFFFFFF) % 1000000
    return ('%06d'):format(hash)
end
function libs()
    if not lcopas or not lhttp or not lcrypto then
        atext('Начата загрузка недостающих библиотек')
        atext('По окончанию загрузки скрипт будет перезагружен')
        if not lcopas or not lhttp then
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
                    print('Не удалось загрузить copas')
                    thisScript():unload()
                else
                    print(v..' был загружен')
                end
            end
        end
        if not lcrypto then
            crypto_download_status = 'proccess'
            downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/crypto_lua.dll', 'moonloader/lib/crypto_lua.dll', function(id, status, p1, p2)
                if status == dlstatus.STATUS_DOWNLOADINGDATA then
                    crypto_download_status = 'proccess'
                    print(string.format('Загружено %d килобайт из %d килобайт.', p1, p2))
                elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    crypto_download_status = 'succ'
                elseif status == 64 then
                    crypto_download_status = 'failed'
                end
            end)
            while crypto_download_status == 'proccess' do wait(0) end
            if crypto_download_status == 'failed' then
                print('Не удалось загрузить crypto_lua.dll')
                thisScript():unload()
            else
                print('crypto_lua.dll был загружен')
            end
        end
        atext('Все необходимые библиотеки были загружены')
        reloadScripts()
    end
end
function infRun(bool)
    if bool then
        mem.setint8(0xB7CEE4, 1)
    else
        mem.setint8(0xB7CEE4, 0)
    end
end
function memstart()
    local samp = getModuleHandle('samp.dll')
    --постоянный худ
	mem.fill(samp + 0x9D31A, nop, 12, true)
    mem.fill(samp + 0x9D329, nop, 12, true)
    --фастконннект
    mem.fill(sampGetBase() + 0x2D3C45, 0, 2, true)
    --фикс прыжка
    mem.fill(0x00531155, 0x90, 5, true)
    --бесконечный бег
    infRun(true)
    --отключение F1
    mem.setuint8(samp + 0x67450, 0xC3, true)
    --Антикрашер
    local ressamp1, samp1 = loadDynamicLibrary('samp.dll')
    if ressamp1 then
        samp1 = samp1+0x5CF2C
        writeMemory(samp1, 4, 0x90909090, 1)
        samp1 = samp1 + 4
        writeMemory(samp1, 1, 0x90, 1)
        samp1 = samp1 + 9
        writeMemory(samp1, 4, 0x90909090, 1)
        samp1 = samp1 + 4
        writeMemory(samp1, 1, 0x90, 1)
    end
    --ФПС анлок
    local ressamp2, samp2 = loadDynamicLibrary('samp.dll')
    if ressamp2 then
        samp2 = samp2 + 0x9D9D0
        writeMemory(samp2, 4, 0x5051FF15, 1)
    end
end
function main()
    if lcopas and lhttp then
        httpRequest("https://raw.githubusercontent.com/WhackerH/EvolveRP/master/apr.txt", nil, function(response, code, headers, status)
            if response then
                for line in response:gmatch('[^\r\n]+') do
                    table.insert(prcheck.prt, line)
                end
            else
                prcheck.pr = 3
            end
        end)
    end
    local directors = {'moonloader/Admin Tools', 'moonloader/Admin Tools/hblist', 'moonloader/config', 'moonloader/config/Admin Tools', 'moonloader/Admin Tools/Check Banned', 'moonloader/Admin Tools/Rules'}
    local files = {'moonloader/Admin Tools/chatlog_all.txt', 'moonloader/config/Admin Tools/fa.txt', 'moonloader/Admin Tools/punishjb.txt', 'moonloader/Admin Tools/punishlogs.txt', 'moonloader/Admin Tools/Check Banned/players.txt'}
	for k, v in pairs(directors) do
		if not doesDirectoryExist(v) then createDirectory(v) end
	end
    for k, v in pairs(files) do
        if not doesFileExist(v) then 
            local file = io.open(v, 'w')
            file:close()
        end
    end
    if not doesFileExist('moonloader/config/Admin Tools/config.json') then
        io.open('moonloader/config/Admin Tools/config.json', 'w'):close()
        local scx, scy = convertGameScreenCoordsToWindowScreenCoords(552.33337402344, 435)
        local tcx, tcy = convertGameScreenCoordsToWindowScreenCoords(490.33334350586, 435)
        local ascx, ascy = convertGameScreenCoordsToWindowScreenCoords(3, 272)
        local kscx, kscy = convertGameScreenCoordsToWindowScreenCoords(536, 110)
        local lscx, lscy = convertGameScreenCoordsToWindowScreenCoords(416.33334350586, 435)
        cfg.playerChecker.posx = scx
        cfg.playerChecker.posy = screeny-15
        cfg.tempChecker.posx = tcx
        cfg.tempChecker.posy = screeny-15
        cfg.admchecker.posx = ascx
        cfg.admchecker.posy = ascy
        cfg.killlist.posx = kscx
        cfg.killlist.posy = kscy
        cfg.leadersChecker.posx = lscx
        cfg.leadersChecker.posy = screeny-15
    else
        local file = io.open('moonloader/config/Admin Tools/config.json', 'r')
        if file then
            cfg = decodeJson(file:read('*a'))
            if cfg.other.autoupdate == nil then cfg.other.autoupdate = true end
            if cfg.killlist == nil then cfg.killlist = {
                posx = screenx/2,
                posy = screeny/2,
                startenable = true
            } end
            if cfg.other.delay == nil then cfg.other.delay = 1200 end
            if cfg.other.killfont == nil then cfg.other.killfont = "Times New Roman" end
            if cfg.other.killsize == nil then cfg.other.killsize = 10 end
            if cfg.other.skeletwh == nil then cfg.other.skeletwh = true end
            if cfg.leadersChecker == nil then cfg.leadersChecker = {
                enable = true,
                posx = screenx/2,
                posy = screeny/2,
                cvetnick = true
            } end
            if cfg.leadersChecker.cvetnick == nil then cfg.leadersChecker.cvetnick = true end
            if cfg.timers.mnarkotimer == nil then cfg.timers.mnarkotimer = 7 end
            if cfg.timers.mcbugtimer == nil then cfg.timers.mcbugtimer = 3 end
            if cfg.other.socrpm == nil then cfg.other.socrpm = false end
            file:close()
        end
    end
    saveData(cfg, 'moonloader/config/Admin Tools/config.json')
    if not doesFileExist("moonloader/config/Admin Tools/tplist.json") then
        io.open('moonloader/config/Admin Tools/tplist.json', 'w'):close()
    else
        local file = io.open('moonloader/config/Admin Tools/tplist.json', 'r')
        if file then
            tplist = decodeJson(file:read('*a'))
        end
    end
    saveData(tplist, "moonloader/config/Admin Tools/tplist.json")
    if not doesFileExist("moonloader/config/Admin Tools/fraklist.json") then
        io.open('moonloader/config/Admin Tools/fraklist.json', 'w'):close()
    else
        local file = io.open('moonloader/config/Admin Tools/fraklist.json', 'r')
        if file then
            fraklist = decodeJson(file:read('*a'))
        end
    end
    saveData(fraklist, "moonloader/config/Admin Tools/fraklist.json")
    if not doesFileExist('moonloader/config/Admin Tools/punishignor.txt') then
        local file = io.open('moonloader/config/Admin Tools/punishignor.txt', 'w')
        file:write('1\n!\ndmg')
        file:close()
    end
    for line in io.lines('moonloader/config/Admin Tools/punishignor.txt') do table.insert(punishignor, line) end
    repeat wait(0) until isSampAvailable()
    libs()
    if cfg.killlist.startenable then killlistmode = 1 end
    if prcheck.pr == 3 then
        atext("Не удалось проверить привязку. Проверьте соединение с интернетом")
        thisScript():unload()
    else
        while #prcheck.prt == 0 do wait(0) end
        if checkIntable(prcheck.prt, sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))) then
            atext("Для вызова меню введите команду \"{66FF00}/at{ffffff}\"")
            memstart()
            local DWMAPI = ffi.load('dwmapi')
            DWMAPI.DwmEnableComposition(1)
        else
            atext("Привязка не обнаружена. Для получения привязки отпишите {66FF00}Thomas_Lawson{ffffff} в ВК {66FF00}vk.com/tlwsn")
            thisScript():unload()
        end
    end
    for k, v in pairs({'ghetto.txt', 'mafia.txt', 'bikers.txt'}) do
        if not doesFileExist("moonloader/Admin Tools/Rules/"..v) then
            httpRequest("https://raw.githubusercontent.com/WhackerH/EvolveRP/master/at_rules/"..v, nil, function(response, code, headers, status)
                if response then rultext = response
                else io.open("moonloader/Admin Tools/Rules/"..v, 'w'):close() rulesready = true
                end
            end)
            while not rultext do wait(0) end
            local file = io.open("moonloader/Admin Tools/Rules/"..v, 'w')
            file:write(rultext)
            file:close()
            rultext = nil
        end
    end
    if #tostring(cfg.other.adminpass) >=6 and cfg.other.apassb then autoal() end
    if cfg.other.autoupdate then autoupdate("https://raw.githubusercontent.com/WhackerH/EvolveRP/master/update.json", "https://evolve-rp.su/viewtopic.php?f=21&t=151439") end
    lua_thread.create(wh)
    registerFastAnswer()
    httpRequest("https://raw.githubusercontent.com/WhackerH/EvolveRP/master/admins.txt", nil, function(response, code, headers, status) 
        if response then
            for line in response:gmatch('[^\r\n]+') do
                table.insert(adminslist, line)
            end
            print("Список админов был успешно загружен")
            print(("Список админов:\n%s"):format(table.concat(adminslist, '\n')))
        else
            print("Не удалось загрузить список админов")
        end
    end)
    sampRegisterChatCommand("gpc", function()
        local cx, cy = getCursorPos()
        atext(renderGetFontDrawHeight(checkfont))
        atext(("X: %s | Y: %s"):format(cx, cy))
        setClipboardText(("%s, %s"):format(cx, cy))
    end)
    sampRegisterChatCommand("oncapt", oncapt)
    sampRegisterChatCommand("vkv", vkv)
    sampRegisterChatCommand("ranks", ranks)
    sampRegisterChatCommand("atp", function() tpwindow.v = not tpwindow.v end)
    sampRegisterChatCommand("arules", function() arul.v = not arul.v end)
    sampRegisterChatCommand('mnarko', mnarko)
    sampRegisterChatCommand('mcbug', mcbug)
    sampRegisterChatCommand('checkb', checkB)
    sampRegisterChatCommand('aunv', aunv)
    sampRegisterChatCommand('gip', gip)
    sampRegisterChatCommand('ml', ml)
    sampRegisterChatCommand('veh',veh)
    sampRegisterChatCommand('vehs', vehs)
    sampRegisterChatCommand('hblist', hblist)
    sampRegisterChatCommand('getlvl', getlvl)
    sampRegisterChatCommand('punish', punish)
    sampRegisterChatCommand('arecon', arecon)
    sampRegisterChatCommand('guns', function() sampShowDialog(3435, '{ffffff}ID Оружий', '{ffffff}ID\t{ffffff}Название\n1\tКастет\n2\tКлюшка для гольфа\n3\tПолицейская дубинка\n4\tНож\n5\tБита\n6\tЛопата\n7\tКий\n8\tКатана\n9\tБензопила\n10\tДилдо\n11\tДилдо\n12\tВибратор\n13\tВибратор\n14\tЦветы\n15\tТрость\n16\tГраната\n17\tДымовая граната\n18\tКоктейль Молотова\n22\t9mm пистолет\n23\tSDPistol\n24\tDesert Eagle\n25\tShotgun\n26\tОбрез\n27\tCombat Shotgun\n28\tUZI\n29\tMP5\n30\tAK-47\n31\tM4\n32\tTec-9\n33\tCountry Rifle\n34\tSniper Rifle\n35\tRPG\n36\tHS Rocket\n37\tОгнемёт\n38\tМиниган\n39\tSatchel Charge\n40\tДетонатор\n41\tSpraycan\n42\tОгнетушитель\n43\tФотоаппарат\n44\tNight Vis Goggles\n45\tThermal Goggles\n46\tParachute', 'x', _, 5) end)
    sampRegisterChatCommand('tg', function() sampSendChat('/togphone') end)
    sampRegisterChatCommand('blog', blog)
    sampRegisterChatCommand('masstp', masstp)
    sampRegisterChatCommand('masshb', masshb)
    sampRegisterChatCommand('givehb', givehb)
	sampRegisterChatCommand('addtemp', addtemp)
    sampRegisterChatCommand('deltemp', deltemp)
    sampRegisterChatCommand('deltempall', function() temp_checker = {} temp_checker_online = {} atext('Временный чекер очищен') end)
    sampRegisterChatCommand('cip', cip)
    sampRegisterChatCommand('cip2', cip2)
    sampRegisterChatCommand('al', function() sampSendChat('/alogin') end)
    sampRegisterChatCommand('at_reload', function() showCursor(false); nameTagOn(); thisScript():reload() end)
    sampRegisterChatCommand('checkrangs', checkrangs)
    sampRegisterChatCommand('spiar', function() sampSendChat('/o Есть вопросы по игре? Задайте их нашим саппортам - /ask') end)
    sampRegisterChatCommand('fonl', fonl)
    sampRegisterChatCommand('kills', kills)
    sampRegisterChatCommand('cbug', cbug)
    sampRegisterChatCommand('sbiv', sbiv)
    sampRegisterChatCommand('csbiv', csbiv)
	sampRegisterChatCommand('cheat', cheat)
    sampRegisterChatCommand('gs', gs)
    sampRegisterChatCommand('ags', ags)
    sampRegisterChatCommand('wlog', wl)
    sampRegisterChatCommand('gun', gun)
    sampRegisterChatCommand('ban', ban)
    sampRegisterChatCommand('warn', warn)
    sampRegisterChatCommand('at', function() mainwindow.v = not mainwindow.v end)
    sampRegisterChatCommand('addadm', addadm)
    sampRegisterChatCommand('tr', tr)
    sampRegisterChatCommand('addplayer', addplayer)
    sampRegisterChatCommand('delplayer', delplayer)
    sampRegisterChatCommand('deladm', deladm)
    initializeRender()
    apply_custom_style()
    admchecker()
    if not doesFileExist("moonloader/config/Admin Tools/keys.json") then
        io.open("moonloader/config/Admin Tools/keys.json", "w"):close()
    else
        local fa = io.open("moonloader/config/Admin Tools/keys.json", 'r')
        if fa then
            config_keys = decodeJson(fa:read('*a'))
			if config_keys == nil then
				config_keys = {
                    banipkey = {v = {190}},
                    warningkey = {v = {key.VK_Z}},
                    reportkey = {v = {key.VK_X}},
                    saveposkey = {v = {key.VK_M}},
                    goposkey = {v = {key.VK_J}},
                    cwarningkey = {v = {key.VK_R}},
                    punaccept = {v = {key.VK_Y}},
                    pundeny = {v = {key.VK_N}},
                    whkey = {v = {16,71}},
                    skeletwhkey = {v = {16, 72}},
                    airbrkkey = {v = key.VK_RSHIFT},
                }
			end
            if config_keys.cwarningkey == nil then config_keys.cwarningkey = {v = {key.VK_R}} end
            if config_keys.punaccept == nil then config_keys.punaccept = {v = {key.VK_Y}} end
            if config_keys.pundeny == nil then config_keys.pundeny = {v = {key.VK_N}} end
            if config_keys.whkey == nil then config_keys.whkey = {v = {16,71}} end
            if config_keys.skeletwhkey == nil then config_keys.skeletwhkey = {v = {16, 72}} end
            if config_keys.airbrkkey == nil then config_keys.airbrkkey = {v = key.VK_RSHIFT} end
        end
    end
    saveData(config_keys, "moonloader/config/Admin Tools/keys.json")
	if not doesFileExist("moonloader/config/Admin Tools/binder.json") then
		io.open("moonloader/config/Admin Tools/binder.json", "w"):close()
	else
		local fb = io.open("moonloader/config/Admin Tools/binder.json", "r")
		if fb then
			tBindList = decodeJson(fb:read('*a'))
            if tBindList == nil then
                tBindList = {
                    [1] = {
                        text = "",
                        v = {},
                        name = 'Бинд1'
                    },
                    [2] = {
                        text = "",
                        v = {},
                        name = 'Бинд2'
                    },
                    [3] = {
                        text = "",
                        v = {},
                        name = 'Бинд3'
                    }
                }
			end
		end
    end
    saveData(tBindList, "moonloader/config/Admin Tools/binder.json")
    if not doesFileExist("moonloader/config/Admin Tools/rangset.json") then
        local fr = io.open("moonloader/config/Admin Tools/rangset.json", "w")
        fr:write(encodeJson(frakrang))
        fr:close()
    else
        local fr = io.open("moonloader/config/Admin Tools/rangset.json", 'r')
        if fr then
            frakrang = decodeJson(fr:read('*a'))
        end
    end
    if not doesFileExist("moonloader/config/Admin Tools/colors.json") then
        io.open("moonloader/config/Admin Tools/colors.json", 'w'):close()
    else
        local fc = io.open("moonloader/config/Admin Tools/colors.json", "r")
        if fc then
            config_colors = decodeJson(fc:read('*a'))
            if config_colors == nil then
                config_colors = {
                    admchat = {r = 255, g = 255, b = 0, color = 16776960},
                    supchat = {r = 0, g = 255, b = 153, color = 65433},
                    smschat = {r = 255, g = 255, b = 0, color = 16776960},
                    repchat = {r = 217, g = 119, b = 0, color = 14251776},
                    anschat = {r = 140, g = 255, b = 155, color = 9240475},
                    askchat = {r = 233, g = 165, b = 40, color = 15312168},
                    jbchat = {r = 217, g = 119, b = 0, color = 14251776},
                    tracemiss = {r = 0, g = 0, b = 255, color = -16776961},
                    tracehit = {r = 255, g = 0, b = 0, color = -65536}
                }
            end
            if config_colors.tracemiss == nil then config_colors.tracemiss = {r = 0, g = 0, b = 255, color = -16776961} end
            if config_colors.tracehit == nil then config_colors.tracehit = {r = 255, g = 0, b = 0, color = -65536} end
            if type(config_colors.admchat.color) == 'string' then config_colors.admchat.color = ARGBtoRGB(join_argb(255, config_colors.admchat.r, config_colors.admchat.g, config_colors.admchat.b)) end
            if type(config_colors.supchat.color) == 'string' then config_colors.supchat.color = ARGBtoRGB(join_argb(255, config_colors.supchat.r, config_colors.supchat.g, config_colors.supchat.b)) end
            if type(config_colors.smschat.color) == 'string' then config_colors.smschat.color = ARGBtoRGB(join_argb(255, config_colors.smschat.r, config_colors.smschat.g, config_colors.smschat.b)) end
            if type(config_colors.repchat.color) == 'string' then config_colors.repchat.color = ARGBtoRGB(join_argb(255, config_colors.repchat.r, config_colors.repchat.g, config_colors.repchat.b)) end
            if type(config_colors.anschat.color) == 'string' then config_colors.anschat.color = ARGBtoRGB(join_argb(255, config_colors.anschat.r, config_colors.anschat.g, config_colors.anschat.b)) end
            if type(config_colors.askchat.color) == 'string' then config_colors.askchat.color = ARGBtoRGB(join_argb(255, config_colors.askchat.r, config_colors.askchat.g, config_colors.askchat.b)) end
            if type(config_colors.jbchat.color) == 'string' then config_colors.jbchat.color = ARGBtoRGB(join_argb(255, config_colors.jbchat.r, config_colors.jbchat.g, config_colors.jbchat.b)) end
        end
    end
    bulletTypes = {
        [0] = config_colors.tracemiss.color,
        [1] = config_colors.tracehit.color,
        [2] = config_colors.tracemiss.color,
        [3] = config_colors.tracemiss.color,
        [4] = config_colors.tracemiss.color
    }
    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
    ar, ag, ab = imgui.ImColor(config_colors.admchat.r, config_colors.admchat.g, config_colors.admchat.b):GetFloat4()
    acolor = imgui.ImFloat3(ar, ag, ab)
    sr, sg, sb = imgui.ImColor(config_colors.supchat.r, config_colors.supchat.g, config_colors.supchat.b):GetFloat4()
    scolor = imgui.ImFloat3(sr, sg, sb)
    smsr, smsg, smsb = imgui.ImColor(config_colors.smschat.r, config_colors.smschat.g, config_colors.smschat.b):GetFloat4()
    smscolor = imgui.ImFloat3(smsr, smsg, smsb)
    jbr, jbg, jbb = imgui.ImColor(config_colors.jbchat.r, config_colors.jbchat.g, config_colors.jbchat.b):GetFloat4()
    jbcolor = imgui.ImFloat3(jbr, jbg, jbb)
    askr, askg, askb = imgui.ImColor(config_colors.askchat.r, config_colors.askchat.g, config_colors.askchat.b):GetFloat4()
    askcolor = imgui.ImFloat3(askr, askg, askb)
    repr, repg, repb = imgui.ImColor(config_colors.repchat.r, config_colors.repchat.g, config_colors.repchat.b):GetFloat4()
    repcolor = imgui.ImFloat3(repr, repg, repb)
    ansr, ansg, ansb = imgui.ImColor(config_colors.anschat.r, config_colors.anschat.g, config_colors.anschat.b):GetFloat4()
    anscolor = imgui.ImFloat3(ansr, ansg, ansb)
    trhitr, trhitg, trhitb = imgui.ImColor(config_colors.tracehit.r, config_colors.tracehit.g, config_colors.tracehit.b):GetFloat4()
    trhitcolor = imgui.ImFloat3(trhitr, trhitg, trhitb)
    trmissr, trmissg, trmissb = imgui.ImColor(config_colors.tracemiss.r, config_colors.tracemiss.g, config_colors.tracemiss.b):GetFloat4()
    trmisscolor = imgui.ImFloat3(trmissr, trmissg, trmissb)
	for k, v in pairs(tBindList) do
        rkeys.registerHotKey(v.v, true, onHotKey)
        if v.time ~= nil then v.time = nil end
        if v.name == nil then v.name = "Бинд"..k end
        v.text = v.text:gsub("%[enter%]", ""):gsub("{noenter}", "{noe}")
    end
    reportbind = rkeys.registerHotKey(config_keys.reportkey.v, true, reportk)
    warningbind = rkeys.registerHotKey(config_keys.warningkey.v, true, warningk)
    banipbind = rkeys.registerHotKey(config_keys.banipkey.v, true, banipk)
    saveposbind = rkeys.registerHotKey(config_keys.saveposkey.v, true, saveposk)
    goposbind = rkeys.registerHotKey(config_keys.goposkey.v, true, goposk)
    cwarningbind = rkeys.registerHotKey(config_keys.cwarningkey.v, true, cwarningk)
    punacceptbind = rkeys.registerHotKey(config_keys.punaccept.v, true, punaccept)
    pundenybind = rkeys.registerHotKey(config_keys.pundeny.v, true, pundeny)
    whbind = rkeys.registerHotKey(config_keys.whkey.v, true, whkey)
    skeletwhbind = rkeys.registerHotKey(config_keys.skeletwhkey.v, true, skeletwh)
	addEventHandler("onWindowMessage", function (msg, wparam, lparam)
        if msg == wm.WM_KEYDOWN or msg == wm.WM_SYSKEYDOWN then
            if tEditData.id > -1 then
                if wparam == key.VK_ESCAPE then
                    tEditData.id = -1
                    consumeWindowMessage(true, true)
                end
            end
            if wparam == key.VK_ESCAPE then
                if mainwindow.v then mainwindow.v = false consumeWindowMessage(true, true) end
                if tpwindow.v then tpwindow.v = false consumeWindowMessage(true, true) end
            end
        end
    end)
    if cfg.cheat.autogm then
        funcsStatus.Inv = true
    end
	--[[for k, v in ipairs(admins) do
		local id = sampGetPlayerIdByNickname(v['nick'])
		if id ~= nil then
			table.insert(admins_online, {nick = v['nick'], id = id, color = v['color'], text = v['text']})
		end
    end
    for k, v in ipairs(players) do
		local id = sampGetPlayerIdByNickname(v['nick'])
		if id ~= nil then
			table.insert(players_online, {nick = v['nick'], id = id, color = v['color'], text = v['text']})
		end
    end
    for k, v in pairs(leaders) do
        local id = sampGetPlayerIdByNickname(leaders[k])
        if id ~= nil then
            table.insert(leader_checker_online, {nick = leaders[k], id = id, frak = k})
        end
    end]]
    zapolncheck()
    lua_thread.create(upd_locals)
    lua_thread.create(clickF)
    lua_thread.create(renders)
    lua_thread.create(main_funcs)
    lua_thread.create(check_keys_fast)
    lua_thread.create(warningsKey)
    lua_thread.create(admchat)
    lua_thread.create(whon)
    requestAnimation("SWIM")
    requestAnimation("PARACHUTE")
    while true do wait(0)
        if swork then 
            if killlistmode == 1 or killlistmode == 2 then
                if isKillstatActive() then
                    enableKillList(false)
                end
            elseif killlistmode == 0 then 
                if not isKillstatActive() then
                    enableKillList(true) 
                end
            end 
        end
        local result, x, y, z = getTargetBlipCoordinatesFixed()
        if result and swork then
            setCharCoordinates(PLAYER_PED, x, y, z)
            removeWaypoint()
        end
        for k, v in ipairs(wrecon) do
            if os.clock() > v["time"] then
                table.remove(wrecon, k)
            end
        end
        --[[if sampGetGamestate() ~= 3 then
            lua_thread.create(function()
                while sampGetGamestate() ~= 3 do wait(0) end
                zapolncheck()
            end)
        end]]
        --if swork and sampGetGamestate() == 2 then nameTagOff() end
        if wasKeyPressed(key.VK_F12) then swork = not swork 
            if not swork then
                nameTagOn()
                if killlistmode == 1 then enableKillList(true) end
                infRun(false)
            else
                nameTagOff()
                if killlistmode == 1 then enableKillList(false) end
                infRun(true)
            end
        end
        if wasKeyPressed(key.VK_F9) then
            if killlistmode == 0 then
                enableKillList(false)
                killlistmode = 1
            elseif killlistmode == 1 then
                killlistmode = 2
            elseif killlistmode == 2 then
                enableKillList(true)
                killlistmode = 0
            end
        end
        if #tkills > 50 then
            table.remove(tkills, 1)
        end
        local oTime = os.time()
        if not isPauseMenuActive() then
			for i = 1, BulletSync.maxLines do
                if BulletSync[i].enable == true and BulletSync[i].time >= oTime then
					--[[local sx, sy, sz = calcScreenCoors(BulletSync[i].o.x, BulletSync[i].o.y, BulletSync[i].o.z)
                    local fx, fy, fz = calcScreenCoors(BulletSync[i].t.x, BulletSync[i].t.y, BulletSync[i].t.z)]]
                    local sx, sy, sz = transform2d(BulletSync[i].o.x, BulletSync[i].o.y, BulletSync[i].o.z)
                    local fx, fy, fz = transform2d(BulletSync[i].t.x, BulletSync[i].t.y, BulletSync[i].t.z)
                    if sz > 0 and fz > 0 then
						renderDrawLine(sx, sy, fx, fy, 1, bulletTypes[BulletSync[i].tType])
                        renderDrawPolygon(fx, fy-1, 3, 3, 4.0, 10, bulletTypes[BulletSync[i].tType])
					end
				end
			end
        end
        if data.imgui.reconpos then
            recon.v = true
            sampToggleCursor(true)
            local curX, curY = getCursorPos()
            cfg.crecon.posx = curX
            cfg.crecon.posy = curY
        end
        if data.imgui.admcheckpos then
            sampToggleCursor(true)
            local curX, curY = getCursorPos()
            cfg.admchecker.posx = curX
            cfg.admchecker.posy = curY
        end
        if data.imgui.playercheckpos then
            sampToggleCursor(true)
            local curX, curY = getCursorPos()
            cfg.playerChecker.posx = curX
            cfg.playerChecker.posy = curY
        end
		if data.imgui.tempcheckpos then
            sampToggleCursor(true)
            local curX, curY = getCursorPos()
            cfg.tempChecker.posx = curX
            cfg.tempChecker.posy = curY
        end
        if data.imgui.joinpos then
            sampToggleCursor(true)
            local curX, curY = getCursorPos()
            cfg.joinquit.joinposx = curX
            cfg.joinquit.joinposy = curY
        end
        if data.imgui.quitpos then
            sampToggleCursor(true)
            local curX, curY = getCursorPos()
            cfg.joinquit.quitposx = curX
            cfg.joinquit.quitposy = curY
        end
        if data.imgui.killlist then
            sampToggleCursor(true)
            local curX, curY = getCursorPos()
            cfg.killlist.posx = curX
            cfg.killlist.posy = curY
        end
        if data.imgui.leadercheckerpos then
            sampToggleCursor(true)
            local curX, curY = getCursorPos()
            cfg.leadersChecker.posx = curX
            cfg.leadersChecker.posy = curY
        end
        if isKeyJustPressed(key.VK_LBUTTON) and (data.imgui.admcheckpos or data.imgui.playercheckpos or data.imgui.reconpos or data.imgui.tempcheckpos or data.imgui.joinpos or data.imgui.quitpos or data.imgui.killlist or data.imgui.leadercheckerpos) then
            data.imgui.admcheckpos = false
            data.imgui.playercheckpos = false
            if data.imgui.reconpos then recon.v = false end
            data.imgui.reconpos = false
            data.imgui.tempcheckpos = false
            data.imgui.joinpos = false
            data.imgui.quitpos = false
            data.imgui.killlist = false
            data.imgui.leadercheckerpos = false
            sampToggleCursor(false)
            mainwindow.v = true
            saveData(cfg, 'moonloader/config/Admin Tools/config.json')
        end
        imgui.Process = mainwindow.v or recon.v or arul.v or tpwindow.v
    end
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
function imgui.TeleportButton(text, coordx, coordy, coordz, interior)
    if imgui.MenuItem(u8('  '..text)) then
        setCharCoordinates(PLAYER_PED, coordx, coordy, coordz)
        setCharInterior(PLAYER_PED, interior)
        setInteriorVisible(interior)
        sampSendInteriorChange(interior)
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
            else imgui.TextWrapped(u8(w)) end
        end
    end

    render_text(text)
end
function rkeys.onHotKey(id, keys)
    if sampIsChatInputActive() or sampIsDialogActive() or isSampfuncsConsoleActive() or isPauseMenuActive() then
        return false
    end
end
function imgui.OnDrawFrame()
    imgui.ShowCursor = mainwindow.v or arul.v
    local btn_size = imgui.ImVec2(-0.1, 0)
    local ir, ig, ib, ia = rainbow(1, 1)
    if tpwindow.v then
        imgui.ShowCursor = true
        imgui.SetNextWindowPos(imgui.ImVec2(screenx/2+400, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(500, 300), imgui.Cond.FirstUseEver)
        imgui.Begin(u8 'Admin Tools | Телепорты', tpwindow)
        if imgui.CollapsingHeader(u8 'Общественные места') then
            imgui.TeleportButton('Автовокзал ЛС', 1154.2769775391, -1756.1109619141, 13.634266853333, 0)
            imgui.TeleportButton('Автовокзал СФ', -1985.5826416016, 137.61878967285, 27.6875, 0)
            imgui.TeleportButton('Автовокзал ЛВ', 2838.7587890625, 1291.5477294922, 11.390625, 0)
            imgui.TeleportButton('Пейнтбол', 2586.6628417969, 2788.6235351563, 10.8203125, 0)
            imgui.TeleportButton('Бейсджамп', 1577.3891601563, -1331.9245605469, 16.484375, 0)
            imgui.TeleportButton('Центр регистрации семей', 2356.6359863281, 2377.3544921875, 10.8203125, 0)
            imgui.TeleportButton('Казино 4 дракона', 2030.9317626953, 1009.9556274414, 10.8203125, 0)
            imgui.TeleportButton('Казино калигула', 2177.9311523438, 1676.1583251953, 10.8203125, 0)
            imgui.TeleportButton('Наркопритон', 2196.3066, -1682.1842, 14.0373, 0)
        end
        if imgui.CollapsingHeader(u8 'Гос. фракции') then
            imgui.TeleportButton('LSPD', 1544.1212158203, -1675.3117675781, 13.557789802551, 0)
            imgui.TeleportButton('SFPD', -1606.0246582031, 719.93884277344, 12.054424285889, 0)
            imgui.TeleportButton('LVPD', 2333.9365234375, 2455.9772949219, 14.96875, 0)
            imgui.TeleportButton('FBI', -2444.9887695313, 502.21490478516, 30.094774246216, 0)
            imgui.TeleportButton('Армия СФ', -1335.8016357422, 471.39276123047, 7.1875, 0)
            imgui.TeleportButton('Армия ЛВ', 209.3503112793, 1916.1086425781, 17.640625, 0)
            imgui.TeleportButton('Мэрия', 1478.6057128906, -1738.2475585938, 13.546875, 0)
            imgui.TeleportButton('Автошкола', -2032.9953613281, -84.548896789551, 35.82837677002, 0)
            imgui.TeleportButton('Медики ЛС', 1188.4862, -1323.5518, 13.5668, 0)
            imgui.TeleportButton('Медики СФ', -2662.4634, 628.8812, 14.4531, 0)
            imgui.TeleportButton('Медики ЛВ', 1608.7927, 1827.4063, 10.8203, 0)
            imgui.TeleportButton('Медики ФК', -315.7561, 1060.4156, 19.7422, 0)
        end
        if imgui.CollapsingHeader(u8 'Гетто') then
            imgui.TeleportButton('Rifa', 2184.4729003906, -1807.0772705078, 13.372615814209, 0)
            imgui.TeleportButton('Grove', 2492.5004882813, -1675.2270507813, 13.335947036743, 0)
            imgui.TeleportButton('Vagos', 2780.037109375, -1616.1085205078, 10.921875, 0)
            imgui.TeleportButton('Ballas', 2645.5832519531, -2009.6373291016, 13.5546875, 0)
            imgui.TeleportButton('Aztec', 1679.7568359375, -2112.7685546875, 13.546875, 0)
        end
        if imgui.CollapsingHeader(u8 'Мафии') then
            imgui.TeleportButton('RM', 948.29113769531, 1732.6284179688, 8.8515625, 0)
            imgui.TeleportButton('Yakuza', 1462.0941162109, 2773.9204101563, 10.8203125, 0)
            imgui.TeleportButton('LCN', 1448.5999755859, 752.29913330078, 11.0234375)
        end
        if imgui.CollapsingHeader(u8 'Новости') then
            imgui.TeleportButton('Los Santos News', 1658.7456054688, -1694.8518066406, 15.609375, 0)
            imgui.TeleportButton('San Fierro News', -2047.3449707031, 462.86468505859, 35.171875, 0)
            imgui.TeleportButton('Las Venturas News', 2647.6062011719, 1182.9040527344, 10.8203125, 0)
        end
        if imgui.CollapsingHeader(u8 'Байкеры') then
            imgui.TeleportButton('Warlocks MC', 657.96783447266, 1724.9599609375, 6.9921875, 0)
            imgui.TeleportButton('Pagans MC', -236.41778564453, 2602.8095703125, 62.703125, 0)
            imgui.TeleportButton('Mongols MC', 682.31365966797, -478.36148071289, 16.3359375, 0)
        end
        if imgui.CollapsingHeader(u8 'Работы') then
            imgui.TeleportButton('Такси 5+ скилла', 2460.7641601563, 1339.7041015625, 10.8203125, 0)
            imgui.TeleportButton('Грузчики', 2191.8410644531, -2255.1296386719, 13.533205986023, 0)
            imgui.TeleportButton('Стоянка хотдогов', -2462.2663574219, 717.34100341797, 35.009593963623, 0)
            imgui.TeleportButton('Стоянка механиков в ЛС', -87.400039672852, -1183.9016113281, 1.8439817428589, 0)
            imgui.TeleportButton('Стоянка механиков в СФ', -1915.9177246094, 286.88238525391, 41.046875, 0)
            imgui.TeleportButton('Стоянка механиков в ЛВ', 2131.244140625, 954.09143066406, 10.8203125, 0)
            imgui.TeleportButton('Склад продуктов', -495.78558349609, -486.47967529297, 25.517845153809, 0)
            imgui.TeleportButton('Дальнобойщики', 2382.5662, 2752.3003, 10.8203, 0)
        end
        if imgui.CollapsingHeader(u8 'Интерьеры') then
            imgui.TeleportButton('24/7 1', -25.884498,-185.868988,1003.546875, 17)
            imgui.TeleportButton('24/7 2', 6.091179,-29.271898,1003.549438, 10)
            imgui.TeleportButton('24/7 3', -30.946699,-89.609596,1003.546875, 18)
            imgui.TeleportButton('24/7 4', -25.132598,-139.066986,1003.546875, 16)
            imgui.TeleportButton('24/7 5', -27.312299,-29.277599,1003.557250, 4)
            imgui.TeleportButton('24/7 6', -26.691598,-55.714897,1003.546875, 6)
            imgui.TeleportButton('Airport ticket desk', -1827.147338,7.207417,1061.143554, 14)
            imgui.TeleportButton('Airport baggage reclaim', -1861.936889,54.908092,1061.143554, 14)
            imgui.TeleportButton('Shamal', 1.808619,32.384357,1199.593750, 1)
            imgui.TeleportButton('Andromada', 315.745086,984.969299,1958.919067, 9)
            imgui.TeleportButton('Ammunation 1', 286.148986,-40.644397,1001.515625, 1)
            imgui.TeleportButton('Ammunation 2', 286.800994,-82.547599,1001.515625, 4)
            imgui.TeleportButton('Ammunation 3', 296.919982,-108.071998,1001.515625, 6)
            imgui.TeleportButton('Ammunation 4', 314.820983,-141.431991,999.601562, 7)
            imgui.TeleportButton('Ammunation 5', 316.524993,-167.706985,999.593750, 6)
            imgui.TeleportButton('Ammunation booths', 302.292877,-143.139099,1004.062500, 7)
            imgui.TeleportButton('Ammunation range', 298.507934,-141.647048,1004.054748, 7)
            imgui.TeleportButton('Blastin fools hallway', 1038.531372,0.111030,1001.284484, 3)
            imgui.TeleportButton('Budget inn motel room', 444.646911,508.239044,1001.419494, 12)
            imgui.TeleportButton('Jefferson motel', 2215.454833,-1147.475585,1025.796875, 15)
            imgui.TeleportButton('Off track betting shop', 833.269775,10.588416,1004.179687, 3)
            imgui.TeleportButton('Sex shop', -103.559165,-24.225606,1000.718750, 3)
            imgui.TeleportButton('Meat factory', 963.418762,2108.292480,1011.030273, 1)
            imgui.TeleportButton("Zero's RC shop", -2240.468505,137.060440,1035.414062, 6)
            imgui.TeleportButton('Dillimore gas station', 663.836242,-575.605407,16.343263, 0)
            imgui.TeleportButton("Catigula's basement", 2169.461181,1618.798339,999.976562, 1)
            imgui.TeleportButton("FDC Janitors room", 1889.953369,1017.438293,31.882812, 10)
            imgui.TeleportButton("Woozie's office", -2159.122802,641.517517,1052.381713, 1)
            imgui.TeleportButton("Binco", 207.737991,-109.019996,1005.132812, 15)
            imgui.TeleportButton("Didier sachs", 204.332992,-166.694992,1000.523437, 14)
            imgui.TeleportButton("Prolaps", 207.054992,-138.804992,1003.507812, 3)
            imgui.TeleportButton("Suburban", 203.777999,-48.492397,1001.804687, 1)
            imgui.TeleportButton("Victim", 226.293991,-7.431529,1002.210937, 5)
            imgui.TeleportButton("Zip", 161.391006,-93.159156,1001.804687, 18)
            imgui.TeleportButton("Club", 493.390991,-22.722799,1000.679687, 17)
            imgui.TeleportButton("Bar", 501.980987,-69.150199,998.757812, 11)
            imgui.TeleportButton("Lil' probe inn", -227.027999,1401.229980,27.765625, 18)
            imgui.TeleportButton("Jay's diner", 457.304748,-88.428497,999.554687, 4)
            imgui.TeleportButton("Gant bridge diner", 454.973937,-110.104995,1000.077209, 5)
            imgui.TeleportButton("Secret valley diner", 435.271331,-80.958938,999.554687, 6)
            imgui.TeleportButton("World of coq", 452.489990,-18.179698,1001.132812, 1)
            imgui.TeleportButton("Welcome pump", 681.557861,-455.680053,-25.609874, 1)
            imgui.TeleportButton("Burger shot", 375.962463,-65.816848,1001.507812, 10)
            imgui.TeleportButton("Cluckin' bell", 369.579528,-4.487294,1001.858886, 9)
            imgui.TeleportButton("Well stacked pizza", 373.825653,-117.270904,1001.499511, 5)
            imgui.TeleportButton("Rusty browns donuts", 381.169189,-188.803024,1000.632812, 17)
            imgui.TeleportButton("Denise room", 244.411987,305.032989,999.148437, 1)
            imgui.TeleportButton("Katie room", 271.884979,306.631988,999.148437, 2)
            imgui.TeleportButton("Helena room", 291.282989,310.031982,999.148437, 3)
            imgui.TeleportButton("Michelle room", 302.180999,300.722991,999.14843, 4)
            imgui.TeleportButton("Barbara room", 322.197998,302.497985,999.14843, 5)
            imgui.TeleportButton("Millie room", 346.870025,309.259033,999.155700, 6)
            imgui.TeleportButton("Sherman dam", -959.564392,1848.576782,9.000000, 17)
            imgui.TeleportButton("Planning dept.", 384.808624,173.804992,1008.382812, 3)
            imgui.TeleportButton("Area 51", 223.431976,1872.400268,13.734375, 0)
            imgui.TeleportButton("LS gym", 772.111999,-3.898649,1000.728820, 5)
            imgui.TeleportButton("SF gym", 774.213989,-48.924297,1000.585937, 6)
            imgui.TeleportButton("LV gym", 773.579956,-77.096694,1000.655029, 7)
            imgui.TeleportButton("B Dup's house", 1527.229980,-11.574499,1002.097106, 3)
            imgui.TeleportButton("B Dup's crack pad", 1523.509887,-47.821197,1002.130981, 2)
            imgui.TeleportButton("Cj's house", 2496.049804,-1695.238159,1014.742187, 3)
            imgui.TeleportButton("Madd Doggs mansion", 1267.663208,-781.323242,1091.906250, 5)
            imgui.TeleportButton("Og Loc's house", 513.882507,-11.269994,1001.565307, 3)
            imgui.TeleportButton("Ryders house", 2454.717041,-1700.871582,1013.515197, 2)
            imgui.TeleportButton("Sweet's house", 2527.654052,-1679.388305,1015.498596, 1)
            imgui.TeleportButton("Crack factory", 2543.462646,-1308.379882,1026.728393, 2)
            imgui.TeleportButton("Big spread ranch", 1212.019897,-28.663099,1000.953125	, 3)
            imgui.TeleportButton("Fanny batters", 761.412963,1440.191650,1102.703125, 6)
            imgui.TeleportButton("Strip club", 1204.809936,-11.586799,1000.921875, 2)
            imgui.TeleportButton("Strip club private room", 1204.809936,13.897239,1000.921875, 2)
            imgui.TeleportButton("Unnamed brothel", 942.171997,-16.542755,1000.929687, 3)
            imgui.TeleportButton("Tiger skin brothel", 964.106994,-53.205497,1001.124572, 3)
            imgui.TeleportButton("Pleasure domes", -2640.762939,1406.682006,906.460937, 3)
            imgui.TeleportButton("Liberty city outside", -729.276000,503.086944,1371.971801, 1)
            imgui.TeleportButton("Liberty city inside", -794.806396,497.738037,1376.195312, 1)
            imgui.TeleportButton("Gang house", 2350.339843,-1181.649902,1027.976562, 5)
            imgui.TeleportButton("Colonel Furhberger's", 2807.619873,-1171.899902,1025.570312, 8)
            imgui.TeleportButton("Crack den", 318.564971,1118.209960,1083.882812, 5)
            imgui.TeleportButton("Warehouse 1", 1412.639892,-1.787510,1000.924377, 1)
            imgui.TeleportButton("Warehouse 2", 1302.519897,-1.787510,1001.028259, 18)
            imgui.TeleportButton("Sweets garage", 2522.000000,-1673.383911,14.866223, 0)
            imgui.TeleportButton("Lil' probe inn toilet", -221.059051,1408.984008,27.773437, 18)
            imgui.TeleportButton("Unused safe house", 2324.419921,-1145.568359,1050.710083, 12)
            imgui.TeleportButton("RC Battlefield", -975.975708,1060.983032,1345.671875, 10)
            imgui.TeleportButton("Barber 1", 411.625976,-21.433298,1001.804687, 2)
            imgui.TeleportButton("Barber 2", 418.652984,-82.639793,1001.804687, 3)
            imgui.TeleportButton("Barber 3", 412.021972,-52.649898,1001.898437, 12)
            imgui.TeleportButton("Tatoo parlour 1", -204.439987,-26.453998,1002.273437, 16)
            imgui.TeleportButton("Tatoo parlour 2", -204.439987,-8.469599,1002.273437, 17)
            imgui.TeleportButton("Tatoo parlour 3", -204.439987,-43.652496,1002.273437, 3)
            imgui.TeleportButton("LS police HQ", 246.783996,63.900199,1003.640625, 6)
            imgui.TeleportButton("SF police HQ", 246.375991,109.245994,1003.218750, 10)
            imgui.TeleportButton("LV police HQ", 288.745971,169.350997,1007.171875, 3)
            imgui.TeleportButton("Car school", -2029.798339,-106.675910,1035.171875, 3)
            imgui.TeleportButton("8-Track", -1398.065307,-217.028900,1051.115844, 7)
            imgui.TeleportButton("Bloodbowl", -1398.103515,937.631164,1036.479125, 15)
            imgui.TeleportButton("Dirt track", -1444.645507,-664.526000,1053.572998, 4)
            imgui.TeleportButton("Kickstart", -1465.268676,1557.868286,1052.531250, 14)
            imgui.TeleportButton("Vice stadium", -1401.829956,107.051300,1032.273437, 1)
            imgui.TeleportButton("SF Garage", -1790.378295,1436.949829,7.187500, 0)
            imgui.TeleportButton("LS Garage", 1643.839843,-1514.819580,13.566620, 0)
            imgui.TeleportButton("SF Bomb shop", -1685.636474,1035.476196,45.210937, 0)
            imgui.TeleportButton("Blueberry warehouse", 76.632553,-301.156829,1.578125, 0)
            imgui.TeleportButton("LV Warehouse 1", 1059.895996,2081.685791,10.820312, 0)
            imgui.TeleportButton("LV Warehouse 2 (hidden part)", 1059.180175,2148.938720,10.820312, 0)
            imgui.TeleportButton("Catigula's hidden room", 2131.507812,1600.818481,1008.359375, 1)
            imgui.TeleportButton("Bank", 2315.952880,-1.618174,26.742187, 0)
            imgui.TeleportButton("Bank (behind desk)", 2319.714843,-14.838361,26.749565, 0)
            imgui.TeleportButton("LS Atruim", 1710.433715,-1669.379272,20.225049, 18)
            imgui.TeleportButton("Bike School", 1494.325195,1304.942871,1093.289062, 3)
        end
        if imgui.CollapsingHeader(u8 'Сохраненные места') then
            for k, v in ipairs(tplist) do
                imgui.TeleportButton(v['text']..'##'..k, v['coords'][1], v['coords'][2], v['coords'][3], 0)
                if imgui.BeginPopupContextItem("##menu"..k) then
                    if imgui.Button(u8 'Удалить##'..k) then
                        table.remove(tplist, k)
                        saveData(tplist, "moonloader/config/Admin Tools/tplist.json")
                    end
                    if imgui.Button(u8 'Переименовать##'..k) then imgui.OpenPopup("##rename"..k) end
                    --imgui.SetNextWindowSize(imgui.ImVec2(300, 100))
                    if imgui.BeginPopupModal('##rename'..k, _, imgui.WindowFlags.AlwaysAutoResize) then
                        imgui.InputText(u8 'Введите новое название', newtpname)
                        if imgui.Button(u8 'Изменить##'..k) then
                            v['text'] = u8:decode(newtpname.v)
                            newtpname.v = ''
                            saveData(tplist, "moonloader/config/Admin Tools/tplist.json")
                            imgui.CloseCurrentPopup()
                        end
                        imgui.SameLine()
                        if imgui.Button(u8 'Отмена##'..k) then
                            imgui.CloseCurrentPopup()
                        end
                        imgui.EndPopup()
                    end
                    imgui.EndPopup()
                end
            end
            imgui.Separator()
            imgui.PushItemWidth(100)
            imgui.InputText(u8 'Название телепорта', tpname)
            imgui.PopItemWidth()
            imgui.PushItemWidth(150)
            imgui.InputInt3(u8 'Координаты телепорта', tpcoords, 0)
            imgui.SameLine()
            if imgui.Button(u8 'Текущие координаты') then
                local myx, myy, myz = getCharCoordinates(PLAYER_PED)
                tpcoords.v[1] = myx
                tpcoords.v[2] = myy
                tpcoords.v[3] = myz
            end
            imgui.PopItemWidth()
            if imgui.Button(u8 'Добавить##tp') then 
                tplist[#tplist + 1] = {text = u8:decode(tpname.v), coords = {tpcoords.v[1], tpcoords.v[2], tpcoords.v[3]}} 
                tpname.v = ''
                tpcoords.v[1], tpcoords.v[2], tpcoords.v[3] = 0,0,0
                saveData(tplist, "moonloader/config/Admin Tools/tplist.json")  end
        end
        imgui.End()
    end
    if recon.v then
		local style = imgui.GetStyle()
		local colors = style.Colors
		local clr = imgui.Col
		local ImVec4 = imgui.ImVec4
		imgui.LockPlayer = false
        local imvsize = imgui.GetWindowSize()
        local spacing, height = 140.0, 162.0
        local imkx, imky = convertGameScreenCoordsToWindowScreenCoords(530, 199)
        imgui.PushStyleColor(imgui.Col.Separator, imgui.ImVec4(ir, ig, ib, ia))
		--imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(1, 0, 0, 1))
        imgui.SetNextWindowPos(imgui.ImVec2(cfg.crecon.posx, cfg.crecon.posy), imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(260, 285), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'Слежка за игроком', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar)
        imgui.CentrText(('%s'):format(imtextnick))
        imgui.CentrText(('ID: %s'):format(reid))
        if reafk then
            imgui.SameLine()
            imgui.TextColored(ImVec4(255, 0, 0, 1),'AFK')
        end
        imgui.Separator()
        imgui.PushStyleVar(imgui.StyleVar.ItemSpacing, imgui.ImVec2(1.0, 2.5))
        imgui.TextColored(ImVec4(0, 255, 0, 1), u8"Level:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtextlvl))
        imgui.TextColored(ImVec4(0, 255, 0, 1), u8"Warns:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtextwarn))
        imgui.TextColored(ImVec4(255, 0, 0, 1), u8"Armour:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtextarm))
        imgui.TextColored(ImVec4(255, 0, 0, 1), u8"Health:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtexthp))
        imgui.TextColored(ImVec4(0, 49, 245, 1), u8"Car HP:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtextcarhp))
        imgui.TextColored(ImVec4(0, 49, 245, 1), u8"Speed:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtextspeed))
        imgui.TextColored(ImVec4(255, 255, 0, 1), u8"Ping:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtextping))
        imgui.TextColored(ImVec4(255, 255, 0, 1), u8"Ammo:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtextammo))
        imgui.TextColored(ImVec4(225, 0, 255, 1), u8"Shot:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtextshot))
        imgui.TextColored(ImVec4(225, 0, 255, 1), u8"Time Shot:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtexttimeshot))
        imgui.TextColored(ImVec4(0, 255, 0, 1), u8"AFK Time:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtextafktime))
        imgui.TextColored(ImVec4(0, 255, 0, 1), u8"Engine:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtextengine))
        imgui.TextColored(ImVec4(0, 255, 0, 1), u8"Pro Sport:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtextprosport))
        imgui.PopStyleVar()
        imgui.End()
        --[[imgui.SetNextWindowSize(imgui.ImVec2(100, 300), imgui.Cond.FirstUseEver)
        imgui.Begin(u8 'Слежка1', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar)
        [if imgui.Button("Change", btn_size) then imgui.OpenPopup("##change_recon") end
        if imgui.BeginPopupModal('##change_recon', _, imgui.WindowFlags.AlwaysAutoResize) then
            --imgui.InputInt(u8 'Введите ID игрока')
            if imgui.Button(u8 "Отправить##change") then sampSendChat("/re") imgui.CloseCurrentPopup() end
            imgui.SameLine()
            if imgui.Button(u8 "Отмена##change") then imgui.CloseCurrentPopup() end
            imgui.EndPopup()
        end
        if imgui.Button("Check »", btn_size) then imgui.OpenPopup("##check_recon") end
        imgui.SetNextWindowSize(imgui.ImVec2(125, 140))
        if imgui.BeginPopup('##check_recon', _, imgui.WindowFlags.AlwaysAutoResize) then
            if imgui.Button("Check-GM", btn_size) then atext("check-gm") end
            if imgui.Button("Check-GM2", btn_size) then atext("check-gm2") end
            if imgui.Button("Check-GMCar", btn_size) then atext("check-gmcar") end
            if imgui.Button("ResetShot", btn_size) then atext("resetshot") end
            imgui.EndPopup()
        end
        for k, v in pairs(menu) do
        end
        imgui.End()]]
        imgui.PopStyleColor()
        if imgui.IsMouseClicked(0) and data.imgui.reconpos then
            data.imgui.reconpos = false
            recon.v = false
            sampToggleCursor(false)
            mainwindow.v = true
            saveData(cfg, 'moonloader/config/Admin Tools/config.json')
        end
    end
    if arul.v then
        imgui.SetNextWindowSize(imgui.ImVec2(500, 500), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(u8'Admin Tools | Правила', arul)
        if imgui.CollapsingHeader(u8 'Правила гетто', btn_size) then
            for line in io.lines('moonloader/Admin Tools/Rules/ghetto.txt') do
                imgui.TextColoredRGB(line)
            end
        end
        if imgui.CollapsingHeader(u8 'Правила мафий', btn_size) then
            for line in io.lines('moonloader/Admin Tools/Rules/mafia.txt') do
                imgui.TextColoredRGB(line)
            end
        end
        if imgui.CollapsingHeader(u8 'Правила байкеров', btn_size) then
            for line in io.lines('moonloader/Admin Tools/Rules/bikers.txt') do
                imgui.TextColoredRGB(line)
            end
        end
        imgui.End()
    end
    if mainwindow.v then
        imgui.LockPlayer = false
        local btn_size = imgui.ImVec2(-0.1, 0)
        imgui.SetNextWindowSize(imgui.ImVec2(300, 300), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin('Admin Tools', mainwindow, imgui.WindowFlags.NoResize)
        if imgui.Button(u8 'Настройки', btn_size) then settingwindows.v = not settingwindows.v end
        if imgui.Button(u8 'Телепорты', btn_size) then tpwindow.v = not tpwindow.v end
        if imgui.Button(u8 'Команды скрипта', btn_size) then cmdwindow.v = not cmdwindow.v end
        if imgui.Button(u8 'Мероприятие', btn_size) then imgui.OpenPopup('##1') mpwindow.v = not mpwindow.v end
        if imgui.Button(u8 'Лидеры', btn_size) then leadwindow.v = not leadwindow.v end
        if imgui.Button(u8 'Биндер', btn_size) then bMainWindow.v = not bMainWindow.v end
        --if imgui.Button(u8 'Тюнинг авто', btn_size) then tunwindow.v = not tunwindow.v end
        imgui.End()
        if leadwindow.v then
            imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(500, 300), imgui.Cond.FirstUseEver)
            imgui.Begin(u8 'Admin Tools | Лидеры', leadwindow)
            for k,v in pairs(leaders) do
                local leadbuff = imgui.ImBuffer(leaders[k], 256)
                imgui.Text(u8(k))
                imgui.SameLine(200)
                imgui.PushItemWidth(270)
                if imgui.InputText(u8 '##Ник лидера'..k, leadbuff) then
                    if #leadbuff.v > 0 then
                        leaders[k] = leadbuff.v
                        local id = sampGetPlayerIdByNickname(leadbuff.v)
                        if id ~= nil then
                            table.insert(leader_checker_online, {nick = leadbuff.v, id = id, frak = k})
                        end
                    else
                        leaders[k] = '-'
                    end
                    saveData(leaders, 'moonloader/config/Admin Tools/leaders.json')
                    leader_checker_online = {}
                    for k, v in pairs(leaders) do
                        local id = sampGetPlayerIdByNickname(leaders[k])
                        if id ~= nil then
                            table.insert(leader_checker_online, {nick = leaders[k], id = id, frak = k})
                        end
                    end
                end
            end
            imgui.End()
        end
        if tunwindow.v then
            imgui.SetNextWindowPos(imgui.ImVec2(screenx/2+350, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(300, 300), imgui.Cond.FirstUseEver)
            imgui.Begin(u8 'Admin Tools | Тюнинг авто', tunwindow)
            if isCharInAnyCar(PLAYER_PED) then
                local carh = storeCarCharIsInNoSave(PLAYER_PED)
                if getDriverOfCar(carh) == PLAYER_PED then
                    imgui.PushItemWidth(100)
                    if imgui.InputInt(u8 'Цвет 1', mcolorb) then changeCarColour(carh, mcolorb.v, pcolorb.v) chcar = true end
                    if imgui.InputInt(u8 'Цвет 2', pcolorb) then changeCarColour(carh, mcolorb.v, pcolorb.v) chcar = true end
                    imgui.PopItemWidth()
                else
                    imgui.TextWrapped(u8 'Вы должны находиться за рулем автомобиля')
                end
            else
                imgui.TextWrapped(u8 'Вы должны находиться в автомобиле')
            end
            imgui.End()
        end
        if mpwindow.v then
            imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(500, 300), imgui.Cond.FirstUseEver)
            imgui.Begin(u8 'Admin Tools | Мероприятие', mpwindow, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
            imgui.Checkbox(u8 'Конец МП', mpend)
            imgui.Separator()
            if not mpend.v then
                imgui.InputText(u8 'Название мероприятия', mpname)
                imgui.InputText(u8 'Спонсоры мероприятия', mpsponsors)
                imgui.Text(u8'Вывод:')
                imgui.Separator()
                imgui.TextWrapped((u8'Желающие на МП "%s" + в SMS. Сразу из машин выходите'):format(mpname.v))
            else
                imgui.InputText(u8 'Победитель мероприятия', mpwinner)
                imgui.InputText(u8 'Спонсоры мероприятия', mpsponsors)
                imgui.Text(u8'Вывод:')
                imgui.Separator()
                imgui.TextWrapped((u8'Победитель МП "%s" - %s'):format(mpname.v, mpwinner.v))
                imgui.TextWrapped((u8'Спонсоры: %s'):format(mpsponsors.v))
            end
            if imgui.Button(u8 'Объявить в /o') then
                lua_thread.create(function()
                    if mpend.v then
                        sampSendChat(('/o Победитель МП "%s" - %s'):format(u8:decode(mpname.v), u8:decode(mpwinner.v)))
                        wait(cfg.other.delay)
                        sampSendChat(('/o Спонсоры: %s'):format(u8:decode(mpsponsors.v)))
                    else
                        sampSendChat((('/o Желающие на МП "%s" + в SMS. Сразу из машин выходите'):format(u8:decode(mpname.v))))
                    end
                end)
            end
            imgui.SameLine()
            if imgui.Button(u8 'Очистить поля') then
                mpname.v = ''
                mpwinner.v = ''
                mpsponsors.v = ''
            end
            imgui.End()
        end
        if cmdwindow.v then
            imgui.SetNextWindowSize(imgui.ImVec2(500, 500), imgui.Cond.FirstUseEver)
            imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.Begin(u8'Admin Tools | Команды', cmdwindow)
            if imgui.CollapsingHeader('/at_reload', btn_size) then
                imgui.TextWrapped(u8 'Описание: Перезагрузить скрипт')
                imgui.TextWrapped(u8 'Использование: /at_reload')
            end
            if imgui.CollapsingHeader('/al', btn_size) then
                imgui.TextWrapped(u8 'Описание: Сокращение команды /alogin')
                imgui.TextWrapped(u8 'Использование: /al')
            end
            if imgui.CollapsingHeader('/arecon', btn_size) then
                imgui.TextWrapped(u8 'Описание: Переподключиться к серверу')
                imgui.TextWrapped(u8 'Использование: /arecon')
            end
            if imgui.CollapsingHeader('/tg', btn_size) then
                imgui.TextWrapped(u8 'Описание: Сокращение команды /togphone')
                imgui.TextWrapped(u8 'Использование: /tg')
            end
            if imgui.CollapsingHeader('/spiar', btn_size) then
                imgui.TextWrapped(u8 'Описание: Написать пиар /ask в /o чат')
                imgui.TextWrapped(u8 'Использование: /spiar')
            end
            if imgui.CollapsingHeader('/getlvl', btn_size) then
                imgui.TextWrapped(u8 'Описание: Узнать всех игроков с определенным уровнем на сервере')
                imgui.TextWrapped(u8 'Использование: /getlvl [уровень]')
            end
            if imgui.CollapsingHeader('/cip', btn_size) then
                imgui.TextWrapped(u8 'Описание: Сравнить IP адреса')
                imgui.TextWrapped(u8 'Использование: /cip')
            end
            if imgui.CollapsingHeader('/cip2', btn_size) then
                imgui.TextWrapped(u8 'Описание: Альтернатива /cip')
                imgui.TextWrapped(u8 'Использование: /cip2')
            end
            if imgui.CollapsingHeader('/fonl', btn_size) then
                imgui.TextWrapped(u8 'Описание: Узнать кол-во людей онлайн во фракции')
                imgui.TextWrapped(u8 'Использование: /fonl [id фракции]')
            end
            if imgui.CollapsingHeader('/checkrangs', btn_size) then
                imgui.TextWrapped(u8 'Описание: Проверить фракцию на несовпадения LVL - Ранг')
                imgui.TextWrapped(u8 'Использование: /checkrangs [id фракции]')
            end
            if imgui.CollapsingHeader('/gs', btn_size) then
                imgui.TextWrapped(u8 'Описание: Сокращение команды /getstats.\nВ реконе можно ид не указывать, сразу проверит статистику игрока, за которым слежка')
                imgui.TextWrapped(u8 'Использование: /gs [id]')
            end
            if imgui.CollapsingHeader('/ags', btn_size) then
                imgui.TextWrapped(u8 'Описание: Сокращение команды /agetstats')
                imgui.TextWrapped(u8 'Использование: /ags [id/nick]')
            end
            if imgui.CollapsingHeader('/sbiv', btn_size) then
                imgui.TextWrapped(u8 ('Описание: Посадить игрока на %s минут в деморган по причине "Сбив анимации".\nЕсли у вас 1 лвл админки пишет в /a с просьбой посадить'):format(cfg.timers.sbivtimer))
                imgui.TextWrapped(u8 'Использование: /sbiv [id]')
            end
            if imgui.CollapsingHeader('/csbiv', btn_size) then
                imgui.TextWrapped(u8 ('Описание: Посадить игрока на %s минут в деморган по причине "Сбив анимации".\nЕсли у вас 1 лвл админки пишет в /a с просьбой посадить'):format(cfg.timers.csbivtimer))
                imgui.TextWrapped(u8 'Использование: /csbiv [id]')
            end
            if imgui.CollapsingHeader('/cbug', btn_size) then
                imgui.TextWrapped(u8 ('Описание: Посадить игрока на %s минут в деморган по причине "+с вне гетто".\nЕсли у вас 1 лвл админки пишет в /a с просьбой посадить'):format(cfg.timers.cbugtimer))
                imgui.TextWrapped(u8 'Использование: /cbug [id]')
            end
            if imgui.CollapsingHeader('/mnarko', btn_size) then
                imgui.TextWrapped(u8 ('Описание: Добавить игрока в ЧС мафий на %s дней по причине "Наркотики в мафии"'):format(cfg.timers.mnarkotimer))
                imgui.TextWrapped(u8 'Использование: /mnarko [id]')
            end
            if imgui.CollapsingHeader('/mcbug', btn_size) then
                imgui.TextWrapped(u8 ('Описание: Добавить игрока в ЧС мафий на %s дня по причине "+С на стреле"'):format(cfg.timers.mcbugtimer))
                imgui.TextWrapped(u8 'Использование: /mcbug [id]')
            end
			if imgui.CollapsingHeader('/cheat', btn_size) then
                imgui.TextWrapped(u8 'Описание: Забанить(1-2 уровни) / заварнить(3+ уровни) по причине "cheat"')
                imgui.TextWrapped(u8 'Использование: /cheat [id]')
            end
            if imgui.CollapsingHeader('/kills', btn_size) then
                imgui.TextWrapped(u8 'Описание: Узнать 50 последний убийств из килл-листа')
                imgui.TextWrapped(u8 'Использование: /kills')
            end
            if imgui.CollapsingHeader('/guns', btn_size) then
                imgui.TextWrapped(u8 'Описание: Открыть диалог с ID оружий')
                imgui.TextWrapped(u8 'Использование: /guns')
            end
            if imgui.CollapsingHeader('/vehs', btn_size) then
                imgui.TextWrapped(u8 'Описание: Открыть диалог с ID машин / узнать ID машины по ее названию')
                imgui.TextWrapped(u8 'Использование: /vehs [название]')
            end
            if imgui.CollapsingHeader('/wlog', btn_size) then
                imgui.TextWrapped(u8 'Описание: Сокращение команды /warnlog')
                imgui.TextWrapped(u8 'Использование: /wlog [id/nick]')
            end
            if imgui.CollapsingHeader('/blog', btn_size) then
                imgui.TextWrapped(u8 'Описание: Сокращение команды /banlog')
                imgui.TextWrapped(u8 'Использование: /blog [id/nick]')
            end
            if imgui.CollapsingHeader('/tr', btn_size) then
                imgui.TextWrapped(u8 'Описание: Переключить трейсера на определенного игрока')
                imgui.TextWrapped(u8 'Использование: /tr [id/-1]')
            end
            if imgui.CollapsingHeader('/ml', btn_size) then
                imgui.TextWrapped(u8 'Описание: Выдать лидерку игроку')
                imgui.TextWrapped(u8 'Использование: /ml [id] [id фракции(не обязательно)]')
            end
            if imgui.CollapsingHeader('/addadm', btn_size) then
                imgui.TextWrapped(u8 'Описание: Добавить игрока в чекер админов')
                imgui.TextWrapped(u8 'Использование: /addadm [id/nick]')
            end
            if imgui.CollapsingHeader('/addplayer', btn_size) then
                imgui.TextWrapped(u8 'Описание: Добавить игрока в чекер игроков')
                imgui.TextWrapped(u8 'Использование: /addplayer [id/nick]')
            end
			if imgui.CollapsingHeader('/addtemp', btn_size) then
                imgui.TextWrapped(u8 'Описание: Добавить игрока в временный чекер')
                imgui.TextWrapped(u8 'Использование: /addtemp [id/nick]')
            end
            if imgui.CollapsingHeader('/deladm', btn_size) then
                imgui.TextWrapped(u8 'Описание: Удалить игрока из чекера админов')
                imgui.TextWrapped(u8 'Использование: /deladm [id/nick]')
            end
            if imgui.CollapsingHeader('/delplayer', btn_size) then
                imgui.TextWrapped(u8 'Описание: Удалить игрока из чекера игроков')
                imgui.TextWrapped(u8 'Использование: /delplayer [id/nick]')
            end
			if imgui.CollapsingHeader('/deltemp', btn_size) then
                imgui.TextWrapped(u8 'Описание: Удалить игрока из временного чекера')
                imgui.TextWrapped(u8 'Использование: /deltemp [id/nick]')
            end
            if imgui.CollapsingHeader('/deltempall', btn_size) then
                imgui.TextWrapped(u8 'Описание: Удалить всех игроков из временного чекера')
                imgui.TextWrapped(u8 'Использование: /deltempall')
            end
            if imgui.CollapsingHeader('/masstp', btn_size) then
                imgui.TextWrapped(u8 'Описание: Начать / окончить телепортацию по СМС')
                imgui.TextWrapped(u8 'Использование: /masstp')
            end
            if imgui.CollapsingHeader('/masshb', btn_size) then
                imgui.TextWrapped(u8 'Описание: Выдать комплект объектов игрокам в зоне стрима')
                imgui.TextWrapped(u8 'Использование: /masshb [имя комплекта]')
            end
            if imgui.CollapsingHeader('/hblist', btn_size) then
                imgui.TextWrapped(u8 'Описание: Узнать список комплектов с объевтами (Комплекты находятся по пути moonloader/Admin Tools/hblist)')
                imgui.TextWrapped(u8 'Использование: /hblist')
            end
            if imgui.CollapsingHeader('/givehb', btn_size) then
                imgui.TextWrapped(u8 'Описание: Выдать комлпект объектов игроку')
                imgui.TextWrapped(u8 'Использование: /givehb [id] [имя комплекта]')
            end
            if imgui.CollapsingHeader('/punish', btn_size) then
                imgui.TextWrapped(u8 'Описание: Выдать наказания по жалобам из списка, заготовленым прогаммой Стронга')
                imgui.TextWrapped(u8 'Использование: /punish')
            end
            if imgui.CollapsingHeader('/gip', btn_size) then
                imgui.TextWrapped(u8 'Описание: Сокращение команды /getip (если игрок онлайн) /agetip (если игрок оффлайн) ')
                imgui.TextWrapped(u8 'Использование: /gip [id/nick]')
            end
            if imgui.CollapsingHeader('/aunv', btn_size) then
                imgui.TextWrapped(u8 'Описание: Сокращение команды /auninvite')
                imgui.TextWrapped(u8 'Использование: /aunv [id] [причина]')
            end
            if imgui.CollapsingHeader('/checkb', btn_size) then
                imgui.TextWrapped(u8 'Описание: Проверить аккаунты из файла на блокировку (Файл находится по пути moonloader/Admin Tools/Check Banned/players.txt)')
                imgui.TextWrapped(u8 'Использование: /checkb')
            end
            if imgui.CollapsingHeader('/arules', btn_size) then
                imgui.TextWrapped(u8 'Описание: Посмотреть правила каптов / стрел прямо в игре')
                imgui.TextWrapped(u8 'Использование: /arules')
            end
            if imgui.CollapsingHeader('/atp', btn_size) then
                imgui.TextWrapped(u8 'Описание: Открыть меню телепорта')
                imgui.TextWrapped(u8 'Использование: /atp')
            end
            if imgui.CollapsingHeader('/ranks', btn_size) then
                imgui.TextWrapped(u8 'Описание: Узнать ранги во фракции')
                imgui.TextWrapped(u8 'Использование: /ranks [фракция]')
            end
            if imgui.CollapsingHeader('/oncapt', btn_size) then
                imgui.TextWrapped(u8 'Описание: Начать / остановить запись отлетевших в гетто')
                imgui.TextWrapped(u8 'Использование: /oncapt')
            end
            imgui.End()
        end
        if settingwindows.v then
            if not reconstate then
                imgui.LockPlayer = true
            else
                imgui.LockPlayer = false
            end
            imgui.SetNextWindowPos(imgui.ImVec2(screenx / 2, screeny / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(15,6))
            imgui.Begin(u8 'Admin Tools | Настройки', settingwindows, imgui.WindowFlags.NoResize)
            imgui.BeginChild('##set', imgui.ImVec2(200, 400), true)
            if imgui.Selectable(u8 'Настройка клавиш', data.imgui.menu == 1 ) then data.imgui.menu = 1 end
            if imgui.Selectable(u8 'Настройка читов', data.imgui.menu == 2) then data.imgui.menu = 2 end
            if data.imgui.menu == 2 then
                if imgui.Selectable(u8 '  AirBrake', data.imgui.cheat == 1) then data.imgui.cheat = 1 end
                if imgui.Selectable(u8 '  GodMode', data.imgui.cheat == 2) then data.imgui.cheat = 2 end
                if imgui.Selectable(u8 '  WallHack', data.imgui.cheat == 3) then data.imgui.cheat = 3 end
            end
            if imgui.Selectable(u8 'Настройка чекеров', data.imgui.menu == 3) then data.imgui.menu = 3 end
            if data.imgui.menu == 3 then
                if imgui.Selectable(u8 '  Чекер админов', data.imgui.checker == 1) then data.imgui.checker = 1 end
                if imgui.Selectable(u8 '  Чекер игроков', data.imgui.checker == 2) then data.imgui.checker = 2 end
                if imgui.Selectable(u8 '  Временный чекер', data.imgui.checker == 3) then data.imgui.checker = 3 end
                if imgui.Selectable(u8 '  Чекер лидеров', data.imgui.checker == 4) then data.imgui.checker = 4 end
            end
            if imgui.Selectable(u8 'Настройка выдачи наказаний', data.imgui.menu == 4) then data.imgui.menu = 4 end
            if imgui.Selectable(u8 'Настройка цветов', data.imgui.menu == 6) then data.imgui.menu = 6 end
			if imgui.Selectable(u8 'Остальные настройки', data.imgui.menu == 5) then data.imgui.menu = 5 end
            imgui.EndChild()
            imgui.SameLine()
            imgui.BeginChild('##set1', imgui.ImVec2(840, 400), true)
            if data.imgui.menu == 1 then
                if imadd.HotKey('##warningkey', config_keys.warningkey, tLastKeys, 100) then
                    rkeys.changeHotKey(warningbind, config_keys.warningkey.v)
					saveData(config_keys, "moonloader/config/Admin Tools/keys.json")
                end
                imgui.SameLine(); imgui.Text(u8 'Клавиша перехода по серверным варнингам')
				if imadd.HotKey('##warningkey1', config_keys.cwarningkey, tLastKeys, 100) then
                    rkeys.changeHotKey(cwarningbind, config_keys.cwarningkey.v)
					saveData(config_keys, "moonloader/config/Admin Tools/keys.json")
                end
                imgui.SameLine(); imgui.Text(u8 'Клавиша перехода по клиентским варнингам')
                if imadd.HotKey('##reportkey', config_keys.reportkey, tLastKeys, 100) then
                    rkeys.changeHotKey(reportbind, config_keys.reportkey.v)
					saveData(config_keys, "moonloader/config/Admin Tools/keys.json")
                end
                imgui.SameLine(); imgui.Text(u8 'Клавиша перехода по репорту')
                if imadd.HotKey('##banipkey', config_keys.banipkey, tLastKeys, 100) then
                    rkeys.changeHotKey(banipbind, config_keys.banipkey.v)
					saveData(config_keys, "moonloader/config/Admin Tools/keys.json")
                end
                imgui.SameLine(); imgui.Text(u8 'Клавиша бана IP адреса')
                if imadd.HotKey('##saveposkey', config_keys.saveposkey, tLastKeys, 100) then
                    rkeys.changeHotKey(saveposbind, config_keys.saveposkey.v)
					saveData(config_keys, "moonloader/config/Admin Tools/keys.json")
                end
                imgui.SameLine(); imgui.Text(u8 'Клавиша сохранения координат')
                if imadd.HotKey('##goposkey', config_keys.goposkey, tLastKeys, 100) then
                    rkeys.changeHotKey(goposbind, config_keys.goposkey.v)
					saveData(config_keys, "moonloader/config/Admin Tools/keys.json")
                end
                imgui.SameLine(); imgui.Text(u8 'Клавиша телепорта на сохраненные координаты')
            elseif data.imgui.menu == 2 then
                if data.imgui.cheat == 1 then
					local airfloat = imgui.ImFloat(cfg.cheat.airbrkspeed)
                    imgui.CentrText(u8 'AirBrake')
                    imgui.Separator()
                    if imgui.SliderFloat(u8 'Начальная скорость', airfloat, 0.05, 10, '%0.2f') then cfg.cheat.airbrkspeed = airfloat.v saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
                    imgui.TextWrapped(u8 'Начальная скорость - это та скорость, которая будет всегда при включении AirBrake. Саму скорость можно изменить во время полета клавишами пробел(увеличить скорость) или левый шифт(уменьшить скокрость)')
                elseif data.imgui.cheat == 2 then
                    local godModeB = imgui.ImBool(cfg.cheat.autogm)
                    imgui.CentrText(u8 'GodMode')
                    imgui.Separator()
                    if imadd.ToggleButton(u8 'Включить гмм##11', godModeB) then cfg.cheat.autogm = godModeB.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 'Автоматически включать ГМ при входе в игру')
                elseif data.imgui.cheat == 3 then
                    local whfontb = imgui.ImBuffer(tostring(cfg.other.whfont), 256)
                    local whsizeb = imgui.ImInt(cfg.other.whsize)
                    local skeletwhb = imgui.ImBool(cfg.other.skeletwh)
                    imgui.CentrText(u8 'WallHack')
                    imgui.Separator()
                    if imadd.ToggleButton(u8 'ВХ по скелетам', skeletwhb) then cfg.other.skeletwh = skeletwhb.v saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 'ВХ по скелетам')
                    if imadd.HotKey('##whkey', config_keys.whkey, tLastKeys, 100) then
                        rkeys.changeHotKey(whbind, config_keys.whkey.v)
                        saveData(config_keys, "moonloader/config/Admin Tools/keys.json")
                    end
                    imgui.SameLine(); imgui.Text(u8 'Включить / выключить ВХ')
                    if imadd.HotKey('##whskeletkey', config_keys.skeletwhkey, tLastKeys, 100) then
                        rkeys.changeHotKey(skeletwhbind, config_keys.skeletwhkey.v)
                        saveData(config_keys, "moonloader/config/Admin Tools/keys.json")
                    end
                    imgui.SameLine(); imgui.Text(u8 'Включить / выключить ВХ по скелетам')
                    if imgui.InputText(u8 'Шрифт##wh', whfontb) then cfg.other.whfont = whfontb.v whfont = renderCreateFont(cfg.other.whfont, cfg.other.whsize, 4) saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
                    if imgui.InputInt(u8 'Размер шрифта##wh', whsizeb, 0) then cfg.other.whsize = whsizeb.v whfont = renderCreateFont(cfg.other.whfont, cfg.other.whsize, 4) saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
                end
            elseif data.imgui.menu == 3 then
                local checksizeb = imgui.ImInt(cfg.other.checksize)
                local checkfontb = imgui.ImBuffer(tostring(cfg.other.checkfont), 256)
                if data.imgui.checker == 1 then
                    local admCheckerB = imgui.ImBool(cfg.admchecker.enable)
                    imgui.CentrText(u8 'Чекер админов')
                    imgui.Separator()
                    if imadd.ToggleButton(u8 'Включить чекер##1', admCheckerB) then cfg.admchecker.enable = admCheckerB.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 'Включить чекер')
                    if cfg.admchecker.enable then
                        imgui.Text(u8 'Местоположение чекера')
                        imgui.SameLine()
                        if imgui.Button(u8 'Изменить##1') then data.imgui.admcheckpos = true; mainwindow.v = false end
                    end
                elseif data.imgui.checker == 2 then
                    local playerCheckerB = imgui.ImBool(cfg.playerChecker.enable)
                    imgui.CentrText(u8 'Чекер игроков')
                    imgui.Separator()
                    if imadd.ToggleButton(u8 'Включить чекер##2', playerCheckerB) then cfg.playerChecker.enable = playerCheckerB.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 'Включить чекер')
                    if cfg.playerChecker.enable then
                        imgui.Text(u8 'Местоположение чекера')
                        imgui.SameLine()
                        if imgui.Button(u8 'Изменить##2') then data.imgui.playercheckpos = true; mainwindow.v = false end
                    end
                elseif data.imgui.checker == 3 then
					local tempChetckerB = imgui.ImBool(cfg.tempChecker.enable)
					imgui.CentrText(u8 'Временный чекер')
					imgui.Separator()
					if imadd.ToggleButton(u8 'Включить чекер##3', tempChetckerB) then cfg.tempChecker.enable = tempChetckerB.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 'Включить чекер')
					if cfg.tempChecker.enable then
						local tempWarningB = imgui.ImBool(cfg.tempChecker.wadd)
                        imgui.Text(u8 'Местоположение чекера')
                        imgui.SameLine()
                        if imgui.Button(u8 'Изменить##3') then data.imgui.tempcheckpos = true; mainwindow.v = false end
						if imadd.ToggleButton(u8 'Добавлять в черер игроков по варнингу', tempWarningB) then cfg.tempChecker.wadd = tempWarningB.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 'Добавлять в черер игроков по варнингу')
                    end
                elseif data.imgui.checker == 4 then
                    local leaderCheckerB = imgui.ImBool(cfg.leadersChecker.enable)
                    local colornickb = imgui.ImBool(cfg.leadersChecker.cvetnick)
                    imgui.CentrText(u8 'Чекер лидеров')
                    imgui.Separator()
                    if imadd.ToggleButton(u8 'Включить чекер##4', leaderCheckerB) then cfg.leadersChecker.enable = leaderCheckerB.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 'Включить чекер')
                    if cfg.leadersChecker.enable then
                        imgui.Text(u8 'Местоположение чекера')
                        imgui.SameLine()
                        if imgui.Button(u8 'Изменить##2') then data.imgui.leadercheckerpos = true; mainwindow.v = false end
                        if imadd.ToggleButton(u8 'Цвет ника', colornickb) then cfg.leadersChecker.cvetnick = colornickb.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 'Цвет ника в цвет фракции')
                    end
                end
                imgui.Separator()
                if imgui.InputText(u8 'Шрифт', checkfontb) then cfg.other.checkfont = checkfontb.v checkfont = renderCreateFont(cfg.other.checkfont, cfg.other.checksize, 4) saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
                if imgui.InputInt(u8 'Размер шрифта', checksizeb, 0) then cfg.other.checksize = checksizeb.v; checkfont = renderCreateFont(cfg.other.checkfont, cfg.other.checksize, 4) saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
            elseif data.imgui.menu == 4 then
				local sbivb = imgui.ImInt(cfg.timers.sbivtimer)
				local csbivb = imgui.ImInt(cfg.timers.csbivtimer)
                local cbugb = imgui.ImInt(cfg.timers.cbugtimer)
                local mnarkob = imgui.ImInt(cfg.timers.mnarkotimer)
                local mcbugb = imgui.ImInt(cfg.timers.mcbugtimer)
                local fracstatb = imgui.ImBool(cfg.other.fracstat)
				imgui.CentrText(u8 'Настройка выдачи наказаний')
                imgui.Separator()
                if imadd.HotKey('##punaccept', config_keys.punaccept, tLastKeys, 100) then
                    rkeys.changeHotKey(punacceptbind, config_keys.punaccept.v)
					saveData(config_keys, "moonloader/config/Admin Tools/keys.json")
                end
                imgui.SameLine(); imgui.Text(u8 'Клавиша выдачи наказания по просьбе в /a')
                if imadd.HotKey('##pundeny', config_keys.pundeny, tLastKeys, 100) then
                    rkeys.changeHotKey(pundenybind, config_keys.pundeny.v)
					saveData(config_keys, "moonloader/config/Admin Tools/keys.json")
                end
                imgui.SameLine(); imgui.Text(u8 'Клавиша отмены выдачи наказания по просьбе в /a')
				if imgui.InputInt(u8 'Таймер сбива (/sbiv)', sbivb, 0) then cfg.timers.sbivtimer = sbivb.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
				if imgui.InputInt(u8 'Таймер клео сбива (/csbiv)', csbivb, 0) then cfg.timers.csbivtimer = csbivb.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
                if imgui.InputInt(u8 'Таймер +C вне гетто (/cbug)', cbugb, 0) then cfg.timers.cbugtimer = cbugb.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
                if imgui.InputInt(u8 'Таймер наркотиков в мафии(дни) (/mnarko)', mnarkob, 0) then cfg.timers.mnarkotimer = mnarkob.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
                if imgui.InputInt(u8 'Таймер +C на стреле(дни) (/mcbug)', mcbugb, 0) then cfg.timers.mcbugtimer = mcbugb.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
                if imgui.Checkbox(u8 'Проверка статистики при warn / ban', fracstatb) then cfg.other.fracstat = fracstatb.v saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
                imgui.TextWrapped(u8 ('Игнор проверки статистики будет происходить, если причина бана равна: %s'):format(table.concat(punishignor, ', ')))
                imgui.TextWrapped(u8 'Настроить список игнора можно по пути moonloader/config/Admin Tools/punishingor.txt')
                if imgui.Button(u8 'Обновисть список игнора') then punishignor = {} for line in io.lines('moonloader/config/Admin Tools/punishignor.txt') do table.insert(punishignor, line) end end
			elseif data.imgui.menu == 5 then
				local creconB = imgui.ImBool(cfg.crecon.enable)
				local ipassb = imgui.ImBool(cfg.other.passb)
				local iapassb = imgui.ImBool(cfg.other.apassb)
                local reconwb = imgui.ImBool(cfg.other.reconw)
                local conschat = imgui.ImBool(cfg.other.chatconsole)
                local joinquitb = imgui.ImBool(cfg.joinquit.enable)
                local autoupdateb = imgui.ImBool(cfg.other.autoupdate)
                local killlistb = imgui.ImBool(cfg.killlist.startenable)
                local socrmpb = imgui.ImBool(cfg.other.socrpm)
				local ipass = imgui.ImBuffer(tostring(cfg.other.password), 256)
                local iapass = imgui.ImBuffer(tostring(cfg.other.adminpass), 256)
                local hudfontb = imgui.ImBuffer(tostring(cfg.other.hudfont), 256)
                local killfontb = imgui.ImBuffer(tostring(cfg.other.killfont), 256)
                local killsizeb = imgui.ImInt(cfg.other.killsize)
                local hudsizeb = imgui.ImInt(cfg.other.hudsize)
                local delayb = imgui.ImInt(cfg.other.delay)
				imgui.CentrText(u8 'Остальное')
                imgui.Separator()
				if imadd.ToggleButton(u8 'reconw##1', reconwb) then cfg.other.reconw = reconwb.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 'Варнинги на клео реконнект')
                if imadd.ToggleButton(u8 'Включить замененный рекон##1', creconB) then cfg.crecon.enable = creconB.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 'Включить замененный рекон')
				if imadd.ToggleButton(u8 'Автологин##11', ipassb) then cfg.other.passb = ipassb.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 'Автологин')
                if imadd.ToggleButton(u8 'Автоалогин##11', iapassb) then cfg.other.apassb = iapassb.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 'Автоалогин')
                if imadd.ToggleButton(u8 'Чатлог в консоли##11', conschat) then cfg.other.chatconsole = conschat.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 'Чатлог в консоли')
                if imadd.ToggleButton(u8 'joinquit##11', joinquitb) then cfg.joinquit.enable = joinquitb.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 'Лог подключившися/отключивашися игроков')
                if imadd.ToggleButton(u8 'autoupd##11', autoupdateb) then cfg.other.autoupdate = autoupdateb.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 'Автообновление скрипта')
                if imadd.ToggleButton(u8 'killlist##11', killlistb) then cfg.killlist.startenable = killlistb.v end; imgui.SameLine(); imgui.Text(u8 'Замененный кил-лист при входе в игру')
                if imadd.ToggleButton(u8 'socrpm', socrmpb) then cfg.other.socrpm = socrmpb.v
                    if cfg.other.socrpm then
                        registerFastAnswer()
                    else
                        for line in io.lines('moonloader/config/Admin Tools/fa.txt') do
                            local cmd, text = line:match('(.+) = (.+)')
                            if cmd and text then
                                if sampIsChatCommandDefined(cmd) then sampUnregisterChatCommand(cmd) end
                            end
                        end
                    end
                    saveData(cfg, 'moonloader/config/Admin Tools/config.json') 
                end
                imgui.SameLine(); imgui.Text(u8 'Сокращеные команды на ответы (заполнять в файл moonloader/config/Admin Tools/fa.txt команда = текст)')
                if imgui.InputInt(u8 'Настройка задержки', delayb, 0) then cfg.other.delay = delayb.v saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
                if imgui.Button(u8 'Проверка задержки') then 
                    lua_thread.create(function()
                        for i = 1, 7 do
                            sampSendChat(("/do Тест задержки: %s [%s/7]"):format(cfg.other.delay, i))
                            wait(cfg.other.delay)
                        end
                    end)
                end
                if imgui.InputText(u8 'Шрифт кил-листа##hud', killfontb) then cfg.other.killfont = killfontb.v killfont = renderCreateFont(cfg.other.killfont, cfg.other.killsize, 4) saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
                if imgui.InputInt(u8 'Размер шрифта кил-листа##hud', killsizeb, 0) then 
                    lua_thread.create(function()
                        cfg.other.killsize = killsizeb.v 
                        killfont = renderCreateFont(cfg.other.killfont, cfg.other.killsize, 4)
                        if fonts_loaded then
                            fonts_loaded = false
                            font_gtaweapon3.vtbl.Release(font_gtaweapon3)
                        end 
                        while renderGetFontDrawHeight(killfont) == 0 do wait(0) end
                        font_gtaweapon3 = d3dxfont_create('gtaweapon3', cfg.other.killsize*1.35, 4)
                        fonts_loaded = true
                        saveData(cfg, 'moonloader/config/Admin Tools/config.json')
                    end)
                end
                if imgui.Button(u8 'Изменить местоположения кил-листа') then data.imgui.killlist = true mainwindow.v = false end
                if creconB.v then
                    imgui.SameLine()
                    if imgui.Button(u8 'Изменить местоположение рекона##3') then data.imgui.reconpos = true; mainwindow.v = false end
                end
                if joinquitb.v then 
                    if imgui.Button(u8'Изменить местоположения подключившихся##1') then data.imgui.joinpos = true; mainwindow.v = false end
                    imgui.SameLine()
                    if imgui.Button(u8'Изменить местоположения отключившихся##1') then data.imgui.quitpos = true; mainwindow.v = false end
                end
				if ipassb.v then
					if imgui.InputText(u8 'Введите ваш пароль', ipass, imgui.InputTextFlags.Password) then cfg.other.password = u8:decode(ipass.v) saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
					if imgui.Button(u8 'Узнать пароль##1') then atext('Ваш пароль: {66FF00}'..cfg.other.password) end
				end
				if iapassb.v then
					if imgui.InputText(u8 'Введите ваш админский пароль', iapass, imgui.InputTextFlags.Password) then cfg.other.adminpass = u8:decode(iapass.v) saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
					if imgui.Button(u8 'Узнать пароль##2') then atext('Ваш админский пароль: {66FF00}'..cfg.other.adminpass) end
                end
                if imgui.InputText(u8 'Шрифт нижней панели##hud', hudfontb) then cfg.other.hudfont = hudfontb.v hudfont = renderCreateFont(cfg.other.hudfont, cfg.other.hudsize, 4) saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
                if imgui.InputInt(u8 'Размер шрифта нижней панели##hud', hudsizeb, 0) then 
                    cfg.other.hudsize = hudsizeb.v 
                    hudfont = renderCreateFont(cfg.other.hudfont, cfg.other.hudsize, 4)
                    saveData(cfg, 'moonloader/config/Admin Tools/config.json') 
                end
            elseif data.imgui.menu == 6 then
                imgui.CentrText(u8 'Настройка цветов')
                imgui.Separator()
                if imgui.ColorEdit3(u8 'Админ чат', acolor) then
                    config_colors.admchat.r, config_colors.admchat.g, config_colors.admchat.b = acolor.v[1] * 255, acolor.v[2] * 255, acolor.v[3] * 255
                    config_colors.admchat.color = ARGBtoRGB(join_argb(255, acolor.v[1] * 255, acolor.v[2] * 255, acolor.v[3] * 255))
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
                imgui.SameLine(650)
                if imgui.Button(u8 'Пример строки##1') then sampAddChatMessage(" <ADM-CHAT> Thomas_Lawson [0]: Test", join_argb(255, config_colors.admchat.r, config_colors.admchat.g, config_colors.admchat.b)) end
                if imgui.ColorEdit3(u8 'Саппорт чат', scolor) then
                    config_colors.supchat.r, config_colors.supchat.g, config_colors.supchat.b = scolor.v[1] * 255, scolor.v[2] * 255, scolor.v[3] * 255
                    config_colors.supchat.color = ARGBtoRGB(join_argb(255, scolor.v[1] * 255, scolor.v[2] * 255, scolor.v[3] * 255))
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
                imgui.SameLine(650)
                if imgui.Button(u8 'Пример строки##2') then sampAddChatMessage(" <SUPPORT-CHAT> Thomas_Lawson [0]: Test", join_argb(255, config_colors.supchat.r, config_colors.supchat.g, config_colors.supchat.b)) end
                if imgui.ColorEdit3(u8 'SMS', smscolor) then
                    config_colors.smschat.r, config_colors.smschat.g, config_colors.smschat.b = smscolor.v[1] * 255, smscolor.v[2] * 255, smscolor.v[3] * 255
                    config_colors.smschat.color = ARGBtoRGB(join_argb(255, smscolor.v[1] * 255, smscolor.v[2] * 255, smscolor.v[3] * 255))
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
                imgui.SameLine(650)
                if imgui.Button(u8 'Пример строки##3') then sampAddChatMessage(" SMS: Test. Отправитель: Thomas_Lawson[0]", join_argb(255, config_colors.smschat.r, config_colors.smschat.g, config_colors.smschat.b)) end
                if imgui.ColorEdit3(u8 'Жалоба', jbcolor) then
                    config_colors.jbchat.r, config_colors.jbchat.g, config_colors.jbchat.b = jbcolor.v[1] * 255, jbcolor.v[2] * 255, jbcolor.v[3] * 255
                    config_colors.jbchat.color = ARGBtoRGB(join_argb(255, jbcolor.v[1] * 255, jbcolor.v[2] * 255, jbcolor.v[3] * 255))
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
                imgui.SameLine(650)
                if imgui.Button(u8 'Пример строки##4') then sampAddChatMessage(" Жалоба от Thomas_Lawson[0] на Thomas_Lawson[0]: Test", join_argb(255, config_colors.jbchat.r, config_colors.jbchat.g, config_colors.jbchat.b)) end
                if imgui.ColorEdit3(u8 'Репорт', repcolor) then
                    config_colors.repchat.r, config_colors.repchat.g, config_colors.repchat.b = repcolor.v[1] * 255, repcolor.v[2] * 255, repcolor.v[3] * 255
                    config_colors.repchat.color =ARGBtoRGB(join_argb(255, repcolor.v[1] * 255, repcolor.v[2] * 255, repcolor.v[3] * 255))
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
                imgui.SameLine(650)
                if imgui.Button(u8 'Пример строки##5') then sampAddChatMessage(" Репорт от Thomas_Lawson[0]: Test", join_argb(255, config_colors.repchat.r, config_colors.repchat.g, config_colors.repchat.b)) end
                if imgui.ColorEdit3(u8 'Вопрос', askcolor) then
                    config_colors.askchat.r, config_colors.askchat.g, config_colors.askchat.b = askcolor.v[1] * 255, askcolor.v[2] * 255, askcolor.v[3] * 255
                    config_colors.askchat.color = ARGBtoRGB(join_argb(255, askcolor.v[1] * 255, askcolor.v[2] * 255, askcolor.v[3] * 255))
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
                imgui.SameLine(650)
                if imgui.Button(u8 'Пример строки##6') then sampAddChatMessage(" ->Вопрос Thomas_Lawson[0]: Test", join_argb(255, config_colors.askchat.r, config_colors.askchat.g, config_colors.askchat.b)) end
                if imgui.ColorEdit3(u8 'Ответ', anscolor) then
                    config_colors.anschat.r, config_colors.anschat.g, config_colors.anschat.b = anscolor.v[1] * 255, anscolor.v[2] * 255, anscolor.v[3] * 255
                    config_colors.anschat.color = ARGBtoRGB(join_argb(255, anscolor.v[1] * 255, anscolor.v[2] * 255, anscolor.v[3] * 255))
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
                imgui.SameLine(650)
                if imgui.Button(u8 'Пример строки##7') then sampAddChatMessage(" Ответ от Thomas_Lawson[0] к Thomas_Lawson[0]: Test", join_argb(255, config_colors.anschat.r, config_colors.anschat.g, config_colors.anschat.b)) end
                if imgui.ColorEdit3(u8 'Попадание в игрока (Трейсера)', trhitcolor) then
                    config_colors.tracehit.r, config_colors.tracehit.g, config_colors.tracehit.b = trhitcolor.v[1] * 255, trhitcolor.v[2] * 255, trhitcolor.v[3] * 255
                    config_colors.tracehit.color = join_argb(255, trhitcolor.v[1] * 255, trhitcolor.v[2] * 255, trhitcolor.v[3] * 255)
                    bulletTypes = {
                        [0] = config_colors.tracemiss.color,
                        [1] = config_colors.tracehit.color,
                        [2] = config_colors.tracemiss.color,
                        [3] = config_colors.tracemiss.color,
                        [4] = config_colors.tracemiss.color
                    }
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
                if imgui.ColorEdit3(u8 'Промах (Трейсера)', trmisscolor) then
                    config_colors.tracemiss.r, config_colors.tracemiss.g, config_colors.tracemiss.b = trmisscolor.v[1] * 255, trmisscolor.v[2] * 255, trmisscolor.v[3] * 255
                    config_colors.tracemiss.color = join_argb(255, trmisscolor.v[1] * 255, trmisscolor.v[2] * 255, trmisscolor.v[3] * 255)
                    bulletTypes = {
                        [0] = config_colors.tracemiss.color,
                        [1] = config_colors.tracehit.color,
                        [2] = config_colors.tracemiss.color,
                        [3] = config_colors.tracemiss.color,
                        [4] = config_colors.tracemiss.color
                    }
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
                if imgui.Button(u8 'Сбросить цвета') then
                    config_colors = {
                        admchat = {r = 255, g = 255, b = 0, color = 16776960},
                        supchat = {r = 0, g = 255, b = 153, color = 65433},
                        smschat = {r = 255, g = 255, b = 0, color = 16776960},
                        repchat = {r = 217, g = 119, b = 0, color = 14251776},
                        anschat = {r = 140, g = 255, b = 155, color = 9240475},
                        askchat = {r = 233, g = 165, b = 40, color = 15312168},
                        jbchat = {r = 217, g = 119, b = 0, color = 14251776},
                        tracemiss = {r = 0, g = 0, b = 255, color = -16776961},
                        tracehit = {r = 255, g = 0, b = 0, color = -65536}
                    }
                    ar, ag, ab = imgui.ImColor(config_colors.admchat.r, config_colors.admchat.g, config_colors.admchat.b):GetFloat4()
                    acolor = imgui.ImFloat3(ar, ag, ab)
                    sr, sg, sb = imgui.ImColor(config_colors.supchat.r, config_colors.supchat.g, config_colors.supchat.b):GetFloat4()
                    scolor = imgui.ImFloat3(sr, sg, sb)
                    smsr, smsg, smsb = imgui.ImColor(config_colors.smschat.r, config_colors.smschat.g, config_colors.smschat.b):GetFloat4()
                    smscolor = imgui.ImFloat3(smsr, smsg, smsb)
                    jbr, jbg, jbb = imgui.ImColor(config_colors.jbchat.r, config_colors.jbchat.g, config_colors.jbchat.b):GetFloat4()
                    jbcolor = imgui.ImFloat3(jbr, jbg, jbb)
                    askr, askg, askb = imgui.ImColor(config_colors.askchat.r, config_colors.askchat.g, config_colors.askchat.b):GetFloat4()
                    askcolor = imgui.ImFloat3(askr, askg, askb)
                    repr, repg, repb = imgui.ImColor(config_colors.repchat.r, config_colors.repchat.g, config_colors.repchat.b):GetFloat4()
                    repcolor = imgui.ImFloat3(repr, repg, repb)
                    ansr, ansg, ansb = imgui.ImColor(config_colors.anschat.r, config_colors.anschat.g, config_colors.anschat.b):GetFloat4()
                    anscolor = imgui.ImFloat3(ansr, ansg, ansb)
                    trhitr, trhitg, trhitb = imgui.ImColor(config_colors.tracehit.r, config_colors.tracehit.g, config_colors.tracehit.b):GetFloat4()
                    trhitcolor = imgui.ImFloat3(trhitr, trhitg, trhitb)
                    trmissr, trmissg, trmissb = imgui.ImColor(config_colors.tracemiss.r, config_colors.tracemiss.g, config_colors.tracemiss.b):GetFloat4()
                    trmisscolor = imgui.ImFloat3(trmissr, trmissg, trmissb)
                    bulletTypes = {
                        [0] = config_colors.tracemiss.color,
                        [1] = config_colors.tracehit.color,
                        [2] = config_colors.tracemiss.color,
                        [3] = config_colors.tracemiss.color,
                        [4] = config_colors.tracemiss.color
                    }
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
            end
            --imgui.ShowStyleEditor()
            imgui.EndChild()
            imgui.End()
        end
		if bMainWindow.v then
			imgui.LockPlayer = true
			imgui.ShowCursor = true
			imgui.DisableInput = false
			local iScreenWidth, iScreenHeight = getScreenResolution()
			imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(1000, 530), imgui.Cond.FirstUseEver)
			imgui.Begin(u8("Admin Tools | Биндер##main"), bMainWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			imgui.BeginChild("##bindlist", imgui.ImVec2(995, 442))
            for k, v in ipairs(tBindList) do
                if imadd.HotKey("##HK" .. k, v, tLastKeys, 100) then
                    if not rkeys.isHotKeyDefined(v.v) then
                        if rkeys.isHotKeyDefined(tLastKeys.v) then
                            rkeys.unRegisterHotKey(tLastKeys.v)
                        end
                        rkeys.registerHotKey(v.v, true, onHotKey)
                    end
                    saveData(tBindList, "moonloader/config/Admin Tools/binder.json")
                end
                imgui.SameLine()
                imgui.CentrText(u8(v.name))
                imgui.SameLine(850)
                imgui.SetCursorPosX(imgui.GetWindowWidth() - 150 - (imgui.GetStyle().ItemSpacing.x)*2)
                if imgui.Button(u8 'Редактировать бинд##'..k) then imgui.OpenPopup(u8 "Редактирование биндера##editbind"..k) 
                    bindname.v = u8(v.name) 
                    bindtext.v = u8(v.text)
                end
                if imgui.BeginPopupModal(u8 'Редактирование биндера##editbind'..k, _, imgui.WindowFlags.NoResize) then
                    imgui.Text(u8 "Введите название биндера:")
                    imgui.InputText("##Введите название биндера", bindname)
                    imgui.Text(u8 "Введите текст биндера:")
                    imgui.InputTextMultiline("##Введите текст биндера", bindtext, imgui.ImVec2(500, 200))
                    imgui.Separator()
                    if imgui.Button(u8 'Ключи', imgui.ImVec2(90, 25)) then imgui.OpenPopup('##bindkey') end
                    if imgui.BeginPopup('##bindkey') then
                        imgui.Text(u8 'Используйте ключи биндера для более удобного использования биндера')
                        imgui.Separator()
                        imgui.Text(u8 '{f6} - Отправить сообщение в чат через эмуляцию чата (использовать в самом начале)')
                        imgui.Text(u8 '{noe} - Оставить сообщение в полле ввода а не отправлять его в чат (использовать в самом начале)')
                        imgui.Text(u8 '{wait:sek} - Задержка между строками, где sek - кол-во миллисекунд. Пример: {wait:2000} - задержка 2 секунды. (использовать отдельно на новой строчке)')
                        imgui.Text(u8 '{screen} - Сделать скриншот экрана (использовать отдельно на новой строчке)')
                        imgui.EndPopup()
                    end
                    imgui.SameLine()
                    imgui.SetCursorPosX((imgui.GetWindowWidth() - 90 - imgui.GetStyle().ItemSpacing.x))
                    if imgui.Button(u8 "Удалить бинд##"..k, imgui.ImVec2(90, 25)) then
                        table.remove(tBindList, k)
                        saveData(tBindList, "moonloader/config/Admin Tools/binder.json")
                        imgui.CloseCurrentPopup()
                    end
                    imgui.SameLine()
                    imgui.SetCursorPosX((imgui.GetWindowWidth() - 180 + imgui.GetStyle().ItemSpacing.x) / 2)
                    if imgui.Button(u8 "Сохранить##"..k, imgui.ImVec2(90, 25)) then
                        v.name = u8:decode(bindname.v)
                        v.text = u8:decode(bindtext.v)
                        bindname.v = ''
                        bindtext.v = ''
                        saveData(tBindList, "moonloader/config/Admin Tools/binder.json")
                        imgui.CloseCurrentPopup()
                    end
                    imgui.SameLine()
                    if imgui.Button(u8 "Закрыть##"..k, imgui.ImVec2(90, 25)) then imgui.CloseCurrentPopup() end
                    imgui.EndPopup()
                end
            end
            imgui.EndChild()
            imgui.Separator()
            if imgui.Button(u8"Добавить клавишу") then
                tBindList[#tBindList + 1] = {text = "", v = {}, time = 0, name = "Бинд"..#tBindList + 1}
                saveData(tBindList, "moonloader/config/Admin Tools/binder.json")
            end
		imgui.End()
		end
    end
end
function onHotKey(id, keys)
    lua_thread.create(function()
        local sKeys = tostring(table.concat(keys, " "))
        for k, v in pairs(tBindList) do
            if sKeys == tostring(table.concat(v.v, " ")) then
                local tostr = tostring(v.text)
                if tostr:len() > 0 then
                    for line in tostr:gmatch('[^\r\n]+') do
                        if line:match("^{wait%:%d+}$") then
                            wait(line:match("^%{wait%:(%d+)}$"))
                        elseif line:match("^{screen}$") then
                            screen()
                        else
                            local bIsEnter = string.match(line, "^{noe}(.+)") ~= nil
                            local bIsF6 = string.match(line, "^{f6}(.+)") ~= nil
                            if not bIsEnter then
                                if bIsF6 then
                                    sampProcessChatInput(line:gsub("{f6}", ""))
                                else
                                    sampSendChat(line)
                                end
                            else
                                sampSetChatInputText(line:gsub("{noe}", ""))
                                sampSetChatInputEnabled(true)
                            end
                        end
                    end
                end
            end
        end
    end)
end
function getFrak(frak)
    if frak == nil then return nil
    else
        if frak:match('.+ Gang') then frak = frak:match('(.+) Gang') end
        if frak == 'Russian Mafia' then frak = 'RM' end
        if frak:match(".+ MC") then frak = frak:match("(.+) MC") end
        return frak
    end
end
function isHex(str)
    local str = tostring(str):upper()
    if #str ~= 6 then return false end
    for i = 1, #str do
        if str:byte(i) < 48 or str:byte(i) > 70 or (str:byte(i) < 65 and str:byte(i) > 57) then
            return false
        end
    end
    return true
end
function getRank(frak, rang)
    local trangs = {}
    if frak == 'Mayor' then
        trangs = {
            ['Секретарь'] = 1,
            ['Охранник'] = 2,
            ['Адвокат'] = 3,
            ['Начальник охраны'] = 4,
            ['Зам. Мэра'] = 5,
            ['Мэр'] = 6
        }
    end
    if frak == 'LSPD' or frak == 'SFPD' or frak == 'LVPD' then
        trangs = {
            ['Кадет'] = 1,
            ['Офицер'] = 2,
            ['Мл.Сержант'] = 3,
            ['Сержант'] = 4,
            ['Прапорщик'] = 5,
            ['Ст.Прапорщик'] = 6,
            ['Мл.Лейтенант'] = 7,
            ['Лейтенант'] = 8,
            ['Ст.Лейтенант'] = 9,
            ['Капитан'] = 10,
            ['Майор'] = 11,
            ['Подполковник'] = 12,
            ['Полковник'] = 13,
            ['Шериф'] = 14,
        }
    end
    if frak == 'LS News' or frak == 'SF News' or frak == 'LV News' then
        trangs = {
            ['Стажер'] = 1,
            ['Звукооператор'] = 2,
            ['Звукорежиссер'] = 3,
            ['Репортер'] = 4,
            ['Ведущий'] = 5,
            ['Редактор'] = 6,
            ['Гл.Редактор'] = 7,
            ['Тех.Директор'] = 8,
            ['Программный директор'] = 9,
            ['Ген.Директор'] = 10,
        }
    end
    if frak == 'LVA' or frak == 'SFA' then
        trangs = {
            ['Рядовой'] = 1,
            ['Ефрейтор'] = 2,
            ['Мл.Сержант'] = 3,
            ['Сержант'] = 4,
            ['Ст.Сержант'] = 5,
            ['Старшина'] = 6,
            ['Прапорщик'] = 7,
            ['Мл.Лейтенант'] = 8,
            ['Лейтенант'] = 9,
            ['Ст.Лейтенант'] = 10,
            ['Капитан'] = 11,
            ['Майор'] = 12,
            ['Подполковник'] = 13,
            ['Полковник'] = 14,
            ['Генерал'] = 15
        }
    end
    if frak == 'FBI' then
        trangs = {
            ['Стажёр'] = 1,
            ['Дежурный'] = 2,
            ['Мл.Агент'] = 3,
            ['Агент DEA'] = 4,
            ['Агент CID'] = 5,
            ['Глава DEA'] = 6,
            ['Глава CID'] = 7,
            ['Инспектор FBI'] = 8,
            ['Зам.Директора FBI'] = 9,
            ['Директор FBI'] = 10,
        }
    end
    if frak == 'Hospital' then
        trangs = {
            ['Интерн'] = 1,
            ['Санитар'] = 2,
            ['Мед.Брат'] = 3,
            ['Спасатель'] = 4,
            ['Нарколог'] = 5,
            ['Доктор'] = 6,
            ['Психолог'] = 7,
            ['Хирург'] = 8,
            ['Зам.Глав.Врача'] = 9,
            ['Глав.Врач'] = 10,
        }
    end
    if frak == 'Aztecas Gang' then
        trangs = {
            ['Перро'] = 1,
            ['Тирадор'] = 2,
            ['Геттор'] = 3,
            ['Лас Геррас'] = 4,
            ['Мирандо'] = 5,
            ['Сабио'] = 6,
            ['Инвасор'] = 7,
            ['Тесореро'] = 8,
            ['Нестро'] = 9,
            ['Падре'] = 10,
        }
    end
    if frak == 'Ballas Gang' then
        trangs = {
            ['Блайд'] = 1,
            ['Младший Нига'] = 2,
            ['Крэкер'] = 3,
            ['Гун брo'] = 4,
            ['Ап Бро'] = 5,
            ['Гангстер'] = 6,
            ['Федерал Блок'] = 7,
            ['Фолкс'] = 8,
            ['Райч Нига'] = 9,
            ['Биг Вилли'] = 10,
        }
    end
    if frak == 'Grove Gang' then
        trangs = {
            ['Плейа'] = 1,
            ['Хастла'] = 2,
            ['Килла'] = 3,
            ['Йонг'] = 4,
            ['Гангста'] = 5,
            ['О.Г.'] = 6,
            ['Мобста'] = 7,
            ['Де Кинг'] = 8,
            ['Легенд'] = 9,
            ['Мэд Дог'] = 10,
        }
    end
    if frak == 'Rifa Gang' then
        trangs = {
            ['Новато'] = 1,
            ['Ладрон'] = 2,
            ['Амиго'] = 3,
            ['Мачо'] = 4,
            ['Джуниор'] = 5,
            ['Эрмано'] = 6,
            ['Бандидо'] = 7,
            ['Ауторидад'] = 8,
            ['Аджунто'] = 9,
            ['Падре'] = 10,
        }
    end
    if frak == 'Vagos Gang' then
        trangs = {
            ['Новатто'] = 1,
            ['Ординарио'] = 2,
            ['Локал'] = 3,
            ['Верификадо'] = 4,
            ['Бандито'] = 5,
            ['V.E.G'] = 6,
            ['Ассесино'] = 7,
            ['Лидер V.E.G'] = 8,
            ['Падрино'] = 9,
            ['Падре'] = 10,
        }
    end
    if frak == 'LCN' then
        trangs = {
            ['Новицио'] = 1,
            ['Ассосиато'] = 2,
            ['Сомбаттенте'] = 3,
            ['Солдато'] = 4,
            ['Боец'] = 5,
            ['Сотто-Капо'] = 6,
            ['Капо'] = 7,
            ['Младший Босс'] = 8,
            ['Консильери'] = 9,
            ['Дон'] = 10,
        }
    end
    if frak == 'Russian Mafia' then
        trangs = {
            ['Шнырь'] = 1,
            ['Фраер'] = 2,
            ['Бык'] = 3,
            ['Барыга'] = 4,
            ['Блатной'] = 5,
            ['Свояк'] = 6,
            ['Браток'] = 7,
            ['Вор'] = 8,
            ['Вор в законе'] = 9,
            ['Авторитет'] = 10,
        }
    end
    if frak == 'Yakuza' then
        trangs = {
            ['Вакасю'] = 1,
            ['Сятей'] = 2,
            ['Кедай'] = 3,
            ['Фуку-Комбуте'] = 4,
            ['Вагакасира'] = 5,
            ['Со-Хомбуте'] = 6,
            ['Камбу'] = 7,
            ['Cайко-Комон'] = 8,
            ['Оядзи'] = 9,
            ['Кумите'] = 10,
        }
    end
    if frak == 'Driving School' then
        trangs = {
            ['Стажёр'] = 1,
            ['Консультант'] = 2,
            ['Экзаменатор'] = 3,
            ['Мл.Инструктор'] = 4,
            ['Инструктор'] = 5,
            ['Координатор'] = 6,
            ['Мл.Менеджер'] = 7,
            ['Ст.Менеджер'] = 8,
            ['Директор'] = 9,
            ['Управляющий'] = 10,
        }
    end
    if frak == 'Mongols' or frak == 'Pagans MC' or frak == 'Warlocks MC' then
        trangs = {
            ['Support'] = 1,
            ['Hang around'] = 2,
            ['Prospect'] = 3,
            ['Member'] = 4,
            ['Road captain'] = 5,
            ['Sergeant-at-arms'] = 6,
            ['Treasurer'] = 7,
            ['Вице президент'] = 8,
            ['Президент'] = 9,
        }
    end
    return trangs[rang]
end
function fps_correction()
	return representIntAsFloat(readMemory(0xB7CB5C, 4, false))
end
function initializeRender()
    font = renderCreateFont("Tahoma", 10, FCR_BOLD + FCR_BORDER)
    font2 = renderCreateFont("Arial", 8, FCR_ITALICS + FCR_BORDER)
    deathfont = renderCreateFont('Arial', 10, 5)
    nizfont = renderCreateFont('Arial', 10, 0)
    gunfont = renderCreateFont(getGameDirectory()..'\\gtaweap3.ttf', cfg.other.hudsize, 4)
    whfont = renderCreateFont(cfg.other.whfont, cfg.other.whsize, 4)
    whhpfont = renderCreateFont("Verdana", 8, 4)
	checkfont = renderCreateFont(cfg.other.checkfont, cfg.other.checksize, 4)
    hudfont = renderCreateFont(cfg.other.hudfont, cfg.other.hudsize, 4)
    killfont = renderCreateFont(cfg.other.killfont, cfg.other.killsize, 4)
    lua_thread.create(function()
        while renderGetFontDrawHeight(killfont) == 0 do wait(0) end
        font_gtaweapon3 = d3dxfont_create('gtaweapon3', cfg.other.killsize*1.35, 4)
        fonts_loaded = true
    end)
end
function rotateCarAroundUpAxis(car, vec)
    local mat = Matrix3X3(getVehicleRotationMatrix(car))
    local rotAxis = Vector3D(mat.up:get())
    vec:normalize()
    rotAxis:normalize()
    local theta = math.acos(rotAxis:dotProduct(vec))
    if theta ~= 0 then
        rotAxis:crossProduct(vec)
        rotAxis:normalize()
        rotAxis:zeroNearZero()
        mat = mat:rotate(rotAxis, -theta)
    end
    setVehicleRotationMatrix(car, mat:get())
end
function readFloatArray(ptr, idx)
    return representIntAsFloat(readMemory(ptr + idx * 4, 4, false))
end
function writeFloatArray(ptr, idx, value)
    writeMemory(ptr + idx * 4, 4, representFloatAsInt(value), false)
end
function getVehicleRotationMatrix(car)
    local entityPtr = getCarPointer(car)
    if entityPtr ~= 0 then
        local mat = readMemory(entityPtr + 0x14, 4, false)
        if mat ~= 0 then
            local rx, ry, rz, fx, fy, fz, ux, uy, uz
            rx = readFloatArray(mat, 0)
            ry = readFloatArray(mat, 1)
            rz = readFloatArray(mat, 2)

            fx = readFloatArray(mat, 4)
            fy = readFloatArray(mat, 5)
            fz = readFloatArray(mat, 6)

            ux = readFloatArray(mat, 8)
            uy = readFloatArray(mat, 9)
            uz = readFloatArray(mat, 10)
            return rx, ry, rz, fx, fy, fz, ux, uy, uz
        end
    end
end
function setVehicleRotationMatrix(car, rx, ry, rz, fx, fy, fz, ux, uy, uz)
    local entityPtr = getCarPointer(car)
    if entityPtr ~= 0 then
        local mat = readMemory(entityPtr + 0x14, 4, false)
        if mat ~= 0 then
            writeFloatArray(mat, 0, rx)
            writeFloatArray(mat, 1, ry)
            writeFloatArray(mat, 2, rz)

            writeFloatArray(mat, 4, fx)
            writeFloatArray(mat, 5, fy)
            writeFloatArray(mat, 6, fz)

            writeFloatArray(mat, 8, ux)
            writeFloatArray(mat, 9, uy)
            writeFloatArray(mat, 10, uz)
        end
    end
end
function displayVehicleName(x, y, gxt)
    x, y = convertWindowScreenCoordsToGameScreenCoords(x, y)
    useRenderCommands(true)
    setTextWrapx(640.0)
    setTextProportional(true)
    setTextJustify(false)
    setTextScale(0.33, 0.8)
    setTextDropshadow(0, 0, 0, 0, 0)
    setTextColour(255, 255, 255, 230)
    setTextEdge(1, 0, 0, 0, 100)
    setTextFont(1)
    displayText(x, y, gxt)
end
function createPointMarker(x, y, z)
    pointMarker = createUser3dMarker(x, y, z + 0.3, 4)
end
function removePointMarker()
    if pointMarker then
        removeUser3dMarker(pointMarker)
        pointMarker = nil
    end
end
function getCarFreeSeat(car)
    if doesCharExist(getDriverOfCar(car)) then
        local maxPassengers = getMaximumNumberOfPassengers(car)
        for i = 0, maxPassengers do
            if isCarPassengerSeatFree(car, i) then
                return i + 1
            end
        end
        return nil
    else
        return 0
    end
end
function jumpIntoCar(car)
    local seat = getCarFreeSeat(car)
    if not seat then return false end                     
    if seat == 0 then warpCharIntoCar(playerPed, car)         
    else warpCharIntoCarAsPassenger(playerPed, car, seat - 1) 
    end
    restoreCameraJumpcut()
    return true
end
function teleportPlayer(x, y, z)
    if isCharInAnyCar(playerPed) then
        setCharCoordinates(playerPed, x, y, z)
    end
    setCharCoordinatesDontResetAnim(playerPed, x, y, z)
end
function setCharCoordinatesDontResetAnim(char, x, y, z)
    if doesCharExist(char) then
        local ptr = getCharPointer(char)
        setEntityCoordinates(ptr, x, y, z)
    end
end
function setEntityCoordinates(entityPtr, x, y, z)
    if entityPtr ~= 0 then
        local matrixPtr = readMemory(entityPtr + 0x14, 4, false)
        if matrixPtr ~= 0 then
            local posPtr = matrixPtr + 0x30
            writeMemory(posPtr + 0, 4, representFloatAsInt(x), false)
            writeMemory(posPtr + 4, 4, representFloatAsInt(y), false)
            writeMemory(posPtr + 8, 4, representFloatAsInt(z), false)
        end
    end
end
function showCursorF(toggle)
    if toggle then
        sampSetCursorMode(CMODE_LOCKCAM)
    else
        sampToggleCursor(false)
    end
    funcsStatus.ClickWarp = toggle
end
function clickF()
    while true do
        if not imgui.Process then
            while isPauseMenuActive() do
                if funcsStatus.ClickWarp then
                    showCursorF(false)
                end
                wait(100)
            end
            if isKeyDown(key.VK_MBUTTON) then
                funcsStatus.ClickWarp = not funcsStatus.ClickWarp
                showCursorF(funcsStatus.ClickWarp)
                while isKeyDown(key.VK_MBUTTON) do wait(80) end
            end
            if funcsStatus.ClickWarp then
                local mode = sampGetCursorMode()
                if mode == 0 then
                    showCursorF(true)
                end
                local sx, sy = getCursorPos()
                local sw, sh = getScreenResolution()
                if sx >= 0 and sy >= 0 and sx < sw and sy < sh then
                    local posX, posY, posZ = convertScreenCoordsToWorld3D(sx, sy, 700.0)
                    local camX, camY, camZ = getActiveCameraCoordinates()
                    local result, colpoint = processLineOfSight(camX, camY, camZ, posX, posY, posZ, true, true, false, true, false, false, false)
                    if result and colpoint.entity ~= 0 then
                        local normal = colpoint.normal
                        local pos = Vector3D(colpoint.pos[1], colpoint.pos[2], colpoint.pos[3]) - (Vector3D(normal[1], normal[2], normal[3]) * 0.1)
                        local zOffset = 300
                        if normal[3] >= 0.5 then zOffset = 1 end
                            local result, colpoint2 = processLineOfSight(pos.x, pos.y, pos.z + zOffset, pos.x, pos.y, pos.z - 0.3,
                                true, true, false, true, false, false, false)
                            if result then
                                pos = Vector3D(colpoint2.pos[1], colpoint2.pos[2], colpoint2.pos[3] + 1)
                                local curX, curY, curZ  = getCharCoordinates(playerPed)
                                local dist              = getDistanceBetweenCoords3d(curX, curY, curZ, pos.x, pos.y, pos.z)
                                local hoffs             = renderGetFontDrawHeight(font)
                                sy = sy - 2
                                sx = sx - 2
                                if colpoint.entityType ~= 2 then renderFontDrawText(font, string.format("%0.2fm", dist), sx, sy - hoffs, 0xEEEEEEEE) end
                                local tpIntoCar = nil
                                if colpoint.entityType == 2 then
                                    local car = getVehiclePointerHandle(colpoint.entity)
                                    if doesVehicleExist(car) and (not isCharInAnyCar(playerPed) or storeCarCharIsInNoSave(playerPed) ~= car) then
                                        local carx, cary, carz = getCarCoordinates(car)
                                        local scarx, scary = convert3DCoordsToScreen(carx, cary, carz)
                                        renderFontDrawText(font,'TP: '..tCarsName[getCarModel(car)-399],scarx, scary,-1)
                                        --displayVehicleName(sx, sy - hoffs * 2, getNameOfVehicleModel(getCarModel(car)))
                                        local color = 0xAAFFFFFF
                                        tpIntoCar = car
                                        color = 0xFFFFFFFF
                                    end
                                    removePointMarker()
                                end
                                if colpoint.entityType ~= 2 then createPointMarker(pos.x, pos.y, pos.z) end
                                if isKeyDown(key.VK_LBUTTON) then
                                    if tpIntoCar then
                                        if not jumpIntoCar(tpIntoCar) then
                                            teleportPlayer(pos.x, pos.y, pos.z)
                                        end
                                    else
                                        if isCharInAnyCar(playerPed) then
                                            local norm = Vector3D(colpoint.normal[1], colpoint.normal[2], 0)
                                            local norm2 = Vector3D(colpoint2.normal[1], colpoint2.normal[2], colpoint2.normal[3])
                                            rotateCarAroundUpAxis(storeCarCharIsInNoSave(playerPed), norm2)
                                            pos = pos - norm * 1.8
                                            pos.z = pos.z - 0.8
                                        end
                                        teleportPlayer(pos.x, pos.y, pos.z)
                                    end
                                    removePointMarker()
                                    while isKeyDown(key.VK_LBUTTON) do wait(0) end
                                    showCursorF(false)
                                end
                            end
                        end
                    end
                end
            end
        wait(0)
        removePointMarker()
    end
end
function onScriptTerminate(scr, quit)
    if scr == script.this then
        if killlistmode == 1 then enableKillList(true) end
        nameTag = true
        if not quit then nameTagOn() infRun(false) end
        showCursor(false)
        removePointMarker()
        if fonts_loaded then
            font_gtaweapon3.vtbl.Release(font_gtaweapon3)
        end
    end
end
frakcolor = {
    ['Зоны 51:'] = '{51964D}Зоны 51{ffffff}:',
    ['армии Авианосца:'] = '{51964D}армии Авианосца{ffffff}:',
    ['FBI'] = '{313131}FBI{ffffff}',
    ['LSPD'] = '{110CE7}LSPD{ffffff}',
    ['SFPD'] = '{110CE7}SFPD{ffffff}',
    ['LVPD'] = '{110CE7}LVPD{ffffff}',
    ['мафии Якудза'] = '{FF0000}мафии Якудза{ffffff}',
    ['мафии LCN'] = '{DDA701}мафии LCN{ffffff}',
    ['Русской Мафии'] = '{B4B5B7}Русской Мафии{ffffff}',
    ['Ballas'] = '{B313E7}Ballas{ffffff}',
    ['Vagos'] = '{DBD604}Vagos{ffffff}',
    ['Groove'] = '{009F00}Grove{ffffff}',
    ['Aztecas'] = '{01FCFF}Aztecas{ffffff}',
    ['Rifa'] = '{2A9170}Rifa{ffffff}',
    ['Warlocks MC'] = '{F45000}Warlocks MC{ffffff}',
    ['Mongols MC'] = '{333333}Mongols MC{ffffff}',
    ['Pagans MC'] = '{2C9197}Pagans MC{ffffff}'
}
function sampev.onSpectatePlayer(id, type)
    reid = id
    traceid = id
end

function sampev.onTogglePlayerSpectating(state)
    if state then
        dx, dy, dz = getCharCoordinates(PLAYER_PED)
    end
    if not state then
        lua_thread.create(function()
            while not sampIsLocalPlayerSpawned() do wait(0) end
            requestCollision(dx, dy); loadScene(dx, dy, dz)
            reid = -1
            traceid = -1
        end)
    end
end
function sampev.onUnoccupiedSync(id, data)
    if data.roll.x >= 10000.0 or data.roll.y >= 10000.0 or data.roll.z >= 10000.0 or data.roll.x <= -10000.0 or data.roll.y <= -10000.0 or data.roll.z <= -10000.0 then
        cwid = id
        local pcol = ("%06X"):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF))
        sampAddChatMessage(("<Warning>{ffffff} Игрок {%s}%s [%s]{ffffff} возможно использует крашер"):format(pcol, sampGetPlayerNickname(id), id), 0xFF2424)
        return false
	end
end
function sampev.onTrailerSync(playerId, data)
	if isCharInAnyCar(PLAYER_PED) then
		local veh = storeCarCharIsInNoSave(PLAYER_PED)
		local _, v = sampGetVehicleIdByCarHandle(veh) 
        if data.trailerId == v then
            cwid = playerId
            local pcol = ("%06X"):format(bit.band(sampGetPlayerColor(playerId), 0xFFFFFF))
            sampAddChatMessage(("<Warning>{ffffff} Игрок {%s}%s [%s]{ffffff} возможно использует крашер"):format(pcol, sampGetPlayerNickname(playerId), playerId), 0xFF2424)
			return false
		end
	end
end
function sampev.onServerMessage(color, text)
    local mynick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
    if text:match('^ Вы авторизировались как модератор %d+ уровня$') then cfg.other.admlvl = tonumber(text:match('^ Вы авторизировались как модератор (%d+) уровня$')) saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
    punishlog(text)
    otletfunc(text, color)
    if cfg.other.admlvl > 1 and color == -10270806 then
        if punkey.re.id or punkey.warn.id or punkey.ban.id or punkey.prison.id then
            if text:find(sampGetPlayerNickname(punkey.warn.id)) or text:find(sampGetPlayerNickname(punkey.ban.id)) or text:find(sampGetPlayerNickname(punkey.prison.id)) then
                if not text:find(mynick) then
                    atext('Команду выполнил другой администратор')
                    punkey = {
                        warn = {
                            id = nil,
                            day = nil,
                            reason = nil,
                            admin = nil
                        },
                        ban = {
                            id = nil,
                            reason = nil,
                            admin = nil
                        },
                        prison = {
                            id = nil,
                            day = nil,
                            reason = nil,
                            admin = nil
                        },
                        re = {
                            id = nil,
                            admin = nil
                        },
                        sban = {
                            id = nil,
                            reason = nil,
                            admin = nil 
                        },
                        auninvite = {
                            id = nil,
                            reason = nil,
                            admin = nil
                        },
                        pspawn = {
                            id = nil,
                            nick = nil
                        }
                    }
                end
            end
        end
    end
    if text:match("^ Администратор %S+ добавил %d+ материалов на склад фракции .+. Текущее состояние склада: %d+$") and color == -65366 then
        local nick, mati, banda = text:match("^ Администратор (%S+) добавил (%d+) материалов на склад фракции (.+). Текущее состояние склада: %d+$")
        if nick == sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
            if banda == 'Grove' or banda == 'Rifa' or banda == 'Ballas' or banda == 'Vagos' or banda == 'Aztec' then
                if not doesFileExist("moonloader/Admin Tools/setmatlog.txt") then
                    local time = localTime()
                    local file = io.open("moonloader/Admin Tools/setmatlog.txt", "w")
                    file:write(("\n[size=85][list][*] [color=#00BFFF]Игровой ник[/color]: %s\n"):format(nick))
                    file:write(("[*] [color=#00BFFF]Наименование банды[/color]: %s\n"):format(banda))
                    file:write(("[*] [color=#00BFFF]Количество выданных материалов[/color]: %s\n"):format(mati))
                    file:write(("[*] [color=#00BFFF]Дата и время[/color]: %s / %s[/list][/size]\n"):format(("%s:%s"):format(time.wHour, time.wMinute), os.date('%d.%m.%Y')))
                    file:close()
                else
                    local time = localTime()
                    local file = io.open("moonloader/Admin Tools/setmatlog.txt", "a")
                    file:write(("\n[size=85][list][*] [color=#00BFFF]Игровой ник[/color]: %s\n"):format(nick))
                    file:write(("[*] [color=#00BFFF]Наименование банды[/color]: %s\n"):format(banda))
                    file:write(("[*] [color=#00BFFF]Количество выданных материалов[/color]: %s\n"):format(mati))
                    file:write(("[*] [color=#00BFFF]Дата и время[/color]: %s / %s[/list][/size]\n"):format(("%s:%s"):format(time.wHour, time.wMinute), os.date('%d.%m.%Y')))
                    file:close()
                end
            end
        end
        --[[atext(("Ник: %s | Банда: %s | Кол-во материалов: %s"):format(nick, banda, mati))
        atext(color)]]
    end
    if bancheck and text:find("Игрок не найден") then 
        atext(("Игрок %s не заблокирован"):format(bnick)) 
        if not doesFileExist('moonloader/Admin Tools/Check Banned/result.txt') then
            local file = io.open("moonloader/Admin Tools/Check Banned/result.txt", 'w')
            file:write(bnick.."\n")
            file:close()
        else
            local file = io.open('moonloader/Admin Tools/Check Banned/result.txt', 'a')
            file:write(bnick.."\n")
            file:close()
        end
        bancheck = false 
        return false 
    end
    if cfg.other.chatconsole then sampfuncsLog(text) end
    if doesFileExist('moonloader/Admin Tools/chatlog_all.txt') then
        local time = localTime()
		local file = io.open('moonloader/Admin Tools/chatlog_all.txt', 'a')
		file:write(('[%s || %s] %s\n'):format(os.date('%d.%m.%Y'), ("%s:%s:%s.%s"):format(time.wHour, time.wMinute, time.wSecond, time.wMilliseconds), text))
		file:close()
    else
        local time = localTime()
        local file = io.open('moonloader/Admin Tools/chatlog_all.txt', 'w')
		file:write(('[%s || %s] %s\n'):format(os.date('%d.%m.%Y'), ("%s:%s:%s.%s"):format(time.wHour, time.wMinute, time.wSecond, time.wMilliseconds), text))
        file:close()
    end
    if text:match('^ Ответ от .+%[%d+%] к .+%[%d+%]:') then
        local _, myid = sampGetPlayerIdByCharHandle(playerPed)
        for i = 0, 1000 do
            if sampIsPlayerConnected(i) or i == myid then
                local nick = sampGetPlayerNickname(i):gsub('%p', '%%%1')
                local a = text:gsub('{.+}', '')
                if a:find(nick) and not a:find(nick..'%['..i..'%]') and not a:find('%['..i..'%] '..nick) and not a:find(nick..' %['..i..'%]') then
                    if nick:find("%[") then
                        if nick:find("%]") then
                            text = text:gsub(sampGetPlayerNickname(i), ('%s [%s]'):format(sampGetPlayerNickname(i), i))
                        end
                    else
                        text = text:gsub(sampGetPlayerNickname(i), ('%s [%s]'):format(sampGetPlayerNickname(i), i))
                    end
                end
            end
        end
        return {argb_to_rgba(join_argb(255, config_colors.anschat.r, config_colors.anschat.g, config_colors.anschat.b)), text} 
    end
    if text:match('^ <ADM%-CHAT> .+: .+') then
        local _, myid = sampGetPlayerIdByCharHandle(playerPed)
        for i = 0, 1000 do
            if sampIsPlayerConnected(i) or i == myid then
                local nick = sampGetPlayerNickname(i):gsub('%p', '%%%1')
                local a = text:gsub('{.+}', '')
                if a:find(nick) and not a:find(nick..'%['..i..'%]') and not a:find('%['..i..'%] '..nick) and not a:find(nick..' %['..i..'%]') then
                    if nick:find("%[") then
                        if nick:find("%]") then
                            text = text:gsub(sampGetPlayerNickname(i), ('%s [%s]'):format(sampGetPlayerNickname(i), i))
                        end
                    else
                        text = text:gsub(sampGetPlayerNickname(i), ('%s [%s]'):format(sampGetPlayerNickname(i), i))
                    end
                end
            end
        end
        return {argb_to_rgba(join_argb(255, config_colors.admchat.r, config_colors.admchat.g, config_colors.admchat.b)), text}  
    end
    if text:match('^ <SUPPORT%-CHAT> .+: .+') then
        local _, myid = sampGetPlayerIdByCharHandle(playerPed)
        for i = 0, 1000 do
            if sampIsPlayerConnected(i) or i == myid then
                local nick = sampGetPlayerNickname(i):gsub('%p', '%%%1')
                local a = text:gsub('{.+}', '')
                if a:find(nick) and not a:find(nick..'%['..i..'%]') and not a:find('%['..i..'%] '..nick) and not a:find(nick..' %['..i..'%]') then
                    if nick:find("%[") then
                        if nick:find("%]") then
                            text = text:gsub(sampGetPlayerNickname(i), ('%s [%s]'):format(sampGetPlayerNickname(i), i))
                        end
                    else
                        text = text:gsub(sampGetPlayerNickname(i), ('%s [%s]'):format(sampGetPlayerNickname(i), i))
                    end
                end
            end
        end
        return {argb_to_rgba(join_argb(255, config_colors.supchat.r, config_colors.supchat.g, config_colors.supchat.b)), text} 
    end
    if masstpon and text:match('^ SMS: .+ Отправитель: .+%[%d+%]$') then
        local smsid = text:match('^ SMS: .+ Отправитель: .+%[(%d+)%]$')
        if not checkIntable(smsids, smsid) then
            table.insert(smsids, smsid)
        end
        return false
    end
    if text:match('^ SMS:') then
        local _, myid = sampGetPlayerIdByCharHandle(playerPed)
        for i = 0, 1000 do
            if sampIsPlayerConnected(i) or i == myid then
                local nick = sampGetPlayerNickname(i):gsub('%p', '%%%1')
                local a = text:gsub('{.+}', '')
                if a:find(nick) and not a:find(nick..'%['..i..'%]') and not a:find('%['..i..'%] '..nick) and not a:find(nick..' %['..i..'%]') then
                    if nick:find("%[") then
                        if nick:find("%]") then
                            text = text:gsub(sampGetPlayerNickname(i), ('%s [%s]'):format(sampGetPlayerNickname(i), i))
                        end
                    else
                        text = text:gsub(sampGetPlayerNickname(i), ('%s [%s]'):format(sampGetPlayerNickname(i), i))
                    end
                end
            end
        end
        return {argb_to_rgba(join_argb(255, config_colors.smschat.r, config_colors.smschat.g, config_colors.smschat.b)), text} 
    end
    if text:match('^ %->Вопрос .+') then
        local _, myid = sampGetPlayerIdByCharHandle(playerPed)
        for i = 0, 1000 do
            if sampIsPlayerConnected(i) or i == myid then
                local nick = sampGetPlayerNickname(i):gsub('%p', '%%%1')
                local a = text:gsub('{.+}', '')
                if a:find(nick) and not a:find(nick..'%['..i..'%]') and not a:find('%['..i..'%] '..nick) and not a:find(nick..' %['..i..'%]') then
                    if nick:find("%[") then
                        if nick:find("%]") then
                            text = text:gsub(sampGetPlayerNickname(i), ('%s [%s]'):format(sampGetPlayerNickname(i), i))
                        end
                    else
                        text = text:gsub(sampGetPlayerNickname(i), ('%s [%s]'):format(sampGetPlayerNickname(i), i))
                    end
                end
            end
        end
        return {argb_to_rgba(join_argb(255, config_colors.askchat.r, config_colors.askchat.g, config_colors.askchat.b)), text}  
    end
    if text:match('^ На складе .+ %d+/%d+') and color == -1 then
        local mfrak, mati, ogran = text:match('^ На складе (.+) (%d+)/(%d+)')
        local text = text:gsub(mfrak, frakcolor[mfrak])
        return {color, text}
    end
    if checkfraks then
        if text:match('^ ID: %d+ |.+') then
            local cid, cday, cmonth, cyear, cnick, crang = text:match('^ ID%: (%d+) | %d+%:%d+ (%d+)%.(%d+)%.(%d+) | (.+)%: .+%[(%d+)%]')
            local lvl = sampGetPlayerScore(cid)
            if lvl ~= 0 then
                local crang = tonumber(crang)
                if check_frak == 1 or check_frak == 10 or check_frak == 21 then
                    if lvl < frakrang.PD.inv and lvl ~= 0 then
                        table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                    end
                    if crang == 11 then
                        if lvl < frakrang.PD.rang_11 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 12 then
                        if lvl < frakrang.PD.rang_12 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 13 then
                        if lvl < frakrang.PD.rang_13 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                elseif check_frak == 2 then
                    if lvl < frakrang.FBI.inv and lvl ~= 0 then
                        table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                    end
                    if crang == 6 then
                        if lvl < frakrang.FBI.rang_6 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 7 then
                        if lvl < frakrang.FBI.rang_7 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 8 then
                        if lvl < frakrang.FBI.rang_8 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 9 then
                        if lvl < frakrang.FBI.rang_9 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                elseif check_frak == 3 or check_frak == 19 then
                    if lvl < frakrang.Army.inv and lvl ~= 0 then
                        table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                    end
                    if crang == 12 then
                        if lvl < frakrang.Army.rang_12 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 13 then
                        if lvl < frakrang.Army.rang_13 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 14 then
                        if lvl < frakrang.Army.rang_14 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                elseif check_frak == 5 or check_frak == 6 or check_frak == 14 then
                    if lvl < frakrang.Mafia.inv and lvl ~= 0 then
                        table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                    end
                    if crang == 7 then
                        if lvl < frakrang.Mafia.rang_7 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 8 then
                        if lvl < frakrang.Mafia.rang_8 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 9 then
                        if lvl < frakrang.Mafia.rang_9 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 7 or crang == 8 or crang == 9 then
                        local dayInvite = os.time({ day = cday, month = cmonth, year = cyear })
                        local today = os.time({day = os.date('%d'), month = os.date('%m'), year = os.date('%Y')})
                        if today - dayInvite < 4 then
                            table.insert(checkf, string.format("Nick: %s [%s] | LVL: %s | Rang: %s — находится во фракции менее 4-ех дней. Дата принятия: %s.%s.%s", cnick, cid, lvl, crang, cday,cmonth,cyear))
                        end
                    end
                elseif check_frak == 11 then
                    if lvl < frakrang.Autoschool.inv and lvl ~= 0 then
                        table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                    end
                    if crang == 7 then
                        if lvl < frakrang.Autoschool.rang_7 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 8 then
                        if lvl < frakrang.Autoschool.rang_8 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 9 then
                        if lvl < frakrang.Autoschool.rang_9 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                elseif check_frak == 12 or check_frak == 13 or check_frak == 15 or check_frak == 17 or check_frak == 18 then
                    if lvl < frakrang.Gangs.inv and lvl ~= 0 then
                        table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                    end
                    if crang == 7 then
                        if lvl < frakrang.Gangs.rang_7 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 8 then
                        if lvl < frakrang.Gangs.rang_8 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 9 then
                        if lvl < frakrang.Gangs.rang_9 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                elseif check_frak == 22 then
                    if lvl < frakrang.MOH.inv and lvl ~= 0 then
                        table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                    end
                    if crang == 7 then
                        if lvl < frakrang.MOH.rang_7 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 8 then
                        if lvl < frakrang.MOH.rang_8 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 9 then
                        if lvl < frakrang.MOH.rang_9 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                elseif check_frak == 24 or check_frak == 26 or check_frak == 29 then
                    if lvl < frakrang.Bikers.inv and lvl ~= 0 then
                        table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                    end
                    if crang == 5 then
                        if lvl < frakrang.Bikers.rang_5 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 6 then
                        if lvl < frakrang.Bikers.rang_6 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 7 then
                        if lvl < frakrang.Bikers.rang_7 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 8 then
                        if lvl < frakrang.Bikers.rang_8 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                elseif check_frak == 9 or check_frak == 16 or check_frak == 20 then
                    if lvl < frakrang.News.inv and lvl ~= 0 then
                        table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                    end
                    if crang == 7 then
                        if lvl < frakrang.News.rang_7 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 8 then
                        if lvl < frakrang.News.rang_8 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 9 then
                        if lvl < frakrang.News.rang_9 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                end
            end
            return false
        end
        if text:match('Всего: %d+ человек') then
            checkfraksdone = true
            return false
        end
        if text:find('Члены организации Он%-лайн%:') then return false end
        if text == ' ' and color == -1 then return false end
    end
    if fonlcheck then
        if text:match('^ ID: %d+ |.+') then
            return false
        end
        if text:match('Всего: %d+ человек') then
            fonlnum = text:match('Всего: (%d+) человек')
            fonldone = true
            return false
        end
        if text:find('Члены организации Он%-лайн%:') then return false end
        if text == ' ' and color == -1 then return false end
    end
    if text:match("^ Жалоба от .+%[%d+%] на .+%[%d+%]%: .+") then
        local _, myid = sampGetPlayerIdByCharHandle(playerPed)
        for i = 0, 1000 do
            if sampIsPlayerConnected(i) or i == myid then
                local nick = sampGetPlayerNickname(i):gsub('%p', '%%%1')
                local a = text:gsub('{.+}', '')
                if a:find(nick) and not a:find(nick..'%['..i..'%]') and not a:find('%['..i..'%] '..nick) and not a:find(nick..' %['..i..'%]') then
                    if nick:find("%[") then
                        if nick:find("%]") then
                            text = text:gsub(sampGetPlayerNickname(i), ('%s [%s]'):format(sampGetPlayerNickname(i), i))
                        end
                    else
                        text = text:gsub(sampGetPlayerNickname(i), ('%s [%s]'):format(sampGetPlayerNickname(i), i))
                    end
                end
            end
        end
        reportid = text:match("Жалоба от .+%[%d+%] на .+%[(%d+)%]%: .+")
        return {argb_to_rgba(join_argb(255, config_colors.jbchat.r, config_colors.jbchat.g, config_colors.jbchat.b)), text} 
    end
    if text:match("Nik %[.+%]  R%-IP %[.+%]  L%-IP %[.+%]  IP %[(.+)%]") and color == -10270806 then
        local nick, rip, ip = text:match("Nik %[(.+)%]  R%-IP %[(.+)%]  L%-IP %[.+%]  IP %[(.+)%]")
        ips2 = {{query = rip}, {query = ip}}
        ips = {rip, ip}
		rnick = nick
		bip = ip
    end
	if text:match('^ Nik %[.+%]   R%-IP %[.+%]   L%-IP %[.+%]   IP %[.+%]$') then
		local nick, rip, ip = text:match('^ Nik %[(.+)%]   R%-IP %[(.+)%]   L%-IP %[.+%]   IP %[(.+)%]$')
        ips2 = {{query = rip}, {query = ip}}
        ips = {rip, ip}
		rnick = nick
	end
    if text:match('<Warning> .+%[%d+%]%: .+') and color == -16763905 then
        local cnick, ccwid = text:match('<Warning> (.+)%[(%d+)%]%: .+')
		wid = ccwid
        if cfg.tempChecker.wadd then
            local result, key = checkInTableChecker(temp_checker, cnick)
            if not result then
                table.insert(temp_checker, {{nick = cnick, color = 'ffffff', text = ''}})
                zapolncheck()
            end
		end
    end
    if text:match('^ Репорт от .+%[%d+%]%:') then
        reportid = text:match('Репорт от .+%[(%d+)%]%:')
        local _, myid = sampGetPlayerIdByCharHandle(playerPed)
        for i = 0, 1000 do
            if sampIsPlayerConnected(i) or i == myid then
                local nick = sampGetPlayerNickname(i):gsub('%p', '%%%1')
                local a = text:gsub('{.+}', '')
                if a:find(nick) and not a:find(nick..'%['..i..'%]') and not a:find('%['..i..'%] '..nick) and not a:find(nick..' %['..i..'%]') then
                    if nick:find("%[") then
                        if nick:find("%]") then
                            text = text:gsub(sampGetPlayerNickname(i), ('%s [%s]'):format(sampGetPlayerNickname(i), i))
                        end
                    else
                        text = text:gsub(sampGetPlayerNickname(i), ('%s [%s]'):format(sampGetPlayerNickname(i), i))
                    end
                end
            end
        end
        return {argb_to_rgba(join_argb(255, config_colors.repchat.r, config_colors.repchat.g, config_colors.repchat.b)), text} 
    end
    if text:match('^ Жалоба от%: .+%[%d+%]%:') then
        reportid = text:match('Жалоба от%: .+%[(%d+)%]%:')
        local _, myid = sampGetPlayerIdByCharHandle(playerPed)
        for i = 0, 1000 do
            if sampIsPlayerConnected(i) or i == myid then
                local nick = sampGetPlayerNickname(i):gsub('%p', '%%%1')
                local a = text:gsub('{.+}', '')
                if a:find(nick) and not a:find(nick..'%['..i..'%]') and not a:find('%['..i..'%] '..nick) and not a:find(nick..' %['..i..'%]') then
                    if nick:find("%[") then
                        if nick:find("%]") then
                            text = text:gsub(sampGetPlayerNickname(i), ('%s [%s]'):format(sampGetPlayerNickname(i), i))
                        end
                    else
                        text = text:gsub(sampGetPlayerNickname(i), ('%s [%s]'):format(sampGetPlayerNickname(i), i))
                    end
                end
            end
        end
        return {argb_to_rgba(join_argb(255, config_colors.jbchat.r, config_colors.jbchat.g, config_colors.jbchat.b)), text} 
    end
	local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    for i = 0, 1000 do
        if sampIsPlayerConnected(i) or i == myid then
            local nick = sampGetPlayerNickname(i):gsub('%p', '%%%1')
            local a = text:gsub('{.+}', '')
            if a:find(nick) and not a:find(nick..'%['..i..'%]') and not a:find('%['..i..'%] '..nick) and not a:find(nick..' %['..i..'%]') then
                if nick:find("%[") then
                    if nick:find("%]") then
                        text = text:gsub(sampGetPlayerNickname(i), ('%s [%s]'):format(sampGetPlayerNickname(i), i))
                    end
                else
                    text = text:gsub(sampGetPlayerNickname(i), ('%s [%s]'):format(sampGetPlayerNickname(i), i))
                end
            end
        end
    end
    return { color, text }
end
function sampev.onTextDrawSetString(id, text)
    if id == 2173 then
        imtextlvl, imtextwarn, imtextarm, imtexthp, imtextcarhp, imtextspeed, imtextping, imtextammo, imtextshot, imtexttimeshot, imtextafktime, imtextengine, imtextprosport = text:match('~n~(.+)~n~(.+)~n~(.+)~n~(.+)~n~(.+)~n~(.+)~n~(.+)~n~(.+)~n~(.+)~n~(.+)~n~(.+)~n~(.+)~n~(.+)')
    end
    if id == 2174 then
        if text:match('~w~.+') then
            imtextnick = text:match('~w~(.+)~n~ID:')
            reafk = true
        else
            imtextnick = text:match('(.+)~n~ID:')
            reafk = false
        end
        reid = text:match('.+~n~ID%: (%d+)')
        --traceid = tonumber(reid)
    end
end
function sampev.onShowTextDraw(id, textdraw)
    if id == 2173 then reconstate = true end
    --[[if id == 2174 then --nick
        lua_thread.create(function()
            while sampTextdrawGetString(id) == '' do wait(0) end
            if reid ~= sampTextdrawGetString(id):match('.+~n~ID%: (%d+)') then
                reid = sampTextdrawGetString(id):match('.+~n~ID%: (%d+)')
                traceid = tonumber(reid)
            end
            if cfg.crecon.enable then
                recon.v = true
                sampTextdrawDelete(id)
                return false 
            end
        end)
    end]]
    if cfg.crecon.enable then
        if id == 2174 then recon.v = true return false end
        if id == 2173 then return false end
        if id == 2172 then return false end
        if id == 2168 then return false end
        if id == 2169 then return false end
    end
end
function sampev.onTextDrawHide(id)
    if id == 2173 then reconstate = false end
    if cfg.crecon.enable then if id == 2173 then recon.v = false end end
end
function sampev.onPlayerQuit(id, reason)
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    local color = ("%06X"):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF))
    text_notify_disconnect('{ff0000}Отключился: {ffffff}'..sampGetPlayerNickname(id)..' ['..id..']')
    if reason == 2 or reason == 1 then table.insert(wrecon, {nick = sampGetPlayerNickname(id), time = os.time()}) end
	for i, v in ipairs(admins_online) do
		if tonumber(v["id"]) == id then
			table.remove(admins_online, i)
			break
		end
    end
    for i, v in ipairs(players_online) do
		if tonumber(v["id"]) == id then
			table.remove(players_online, i)
			break
		end
    end
	for i, v in ipairs(temp_checker_online) do
		if tonumber(v["id"]) == id then
			table.remove(temp_checker_online, i)
			break
		end
    end
    for i, v in ipairs(leader_checker_online) do
        if tonumber(v['id']) == id then
            table.remove(leader_checker_online, i)
            break
        end
    end
end
function sampev.onPlayerDeathNotification(killerId, killedId, reason)
    if killerId ~= nil and reason ~= nil and killedId ~= nil then
        local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        if (sampIsPlayerConnected(killerId) or killerId == myid) and (sampIsPlayerConnected(killedId) or killedId == myid) then
            local killercolor   = ("%06X"):format(bit.band(sampGetPlayerColor(killerId), 0xFFFFFF))
            local killedcolor   = ("%06X"):format(bit.band(sampGetPlayerColor(killedId), 0xFFFFFF))
            local killerNick    = sampGetPlayerNickname(killerId)
            local killedNick    = sampGetPlayerNickname(killedId)
            table.insert(tkills, ("{%s}%s [%s]\t{%s}%s [%s]\t%s"):format(killercolor, killerNick, killerId, killedcolor, killedNick, killedId, sampGetDeathReason(reason)))
            table.insert(tkilllist, {killer = ('{%s}%s [%s]'):format(killercolor, killerNick, killerId), killed = ('{%s} %s [%s]'):format(killedcolor, killedNick, killedId), reason = reason})
        end
    end
    if #tkilllist > 5 then table.remove(tkilllist, 1) end
end
function sampev.onTogglePlayerControllable(bool)
    if swork then return false end
end
function sampev.onBulletSync(playerid, data)
	if tonumber(playerid) == tonumber(traceid) then
		if data.target.x == -1 or data.target.y == -1 or data.target.z == -1 then
			return true
		end
		BulletSync.lastId = BulletSync.lastId + 1
		if BulletSync.lastId < 1 or BulletSync.lastId > BulletSync.maxLines then
			BulletSync.lastId = 1
		end
		local id = BulletSync.lastId
		BulletSync[id].enable = true
		BulletSync[id].tType = data.targetType
		BulletSync[id].time = os.time() + 15
		BulletSync[id].o.x, BulletSync[id].o.y, BulletSync[id].o.z = data.origin.x, data.origin.y, data.origin.z
		BulletSync[id].t.x, BulletSync[id].t.y, BulletSync[id].t.z = data.target.x, data.target.y, data.target.z
	end
end
function sampev.onPlayerJoin(id, clist, isNPC, nick)
    text_notify_connect(('{00ff00}Подключился: {ffffff}%s [%s]'):format(nick, id))
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	for i, v in ipairs(wrecon) do
		if v["nick"] == nick then
			if (os.time() - v["time"]) < 5 and (os.time() - v["time"]) > 0 then
				if cfg.other.reconw then
					atext(('Игрок {66FF00}%s [%s] {ffffff}возможно клео реконнект. Время перехода: %s секунд'):format(nick, id, os.time() - v["time"]))
				end
			end
			table.remove(wrecon, i)
		end
	end
	for i, v in ipairs(admins) do
		if nick == v['nick'] then
			table.insert(admins_online, {nick = nick, id = id, color = v['color'], text = v['text']})
			break
		end
    end
    for i, v in ipairs(players) do
		if nick == v['nick'] then
			table.insert(players_online, {nick = nick, id = id, color = v['color'], text = v['text']})
			break
		end
	end
	for i, v in ipairs(temp_checker) do
		if nick == v['nick'] then
			table.insert(temp_checker_online, {nick = nick, id = id, color = v['color'], text = v['text']})
			break
		end
    end
    for i, v in pairs(leaders) do
        if nick == leaders[i] then
            table.insert(leader_checker_online, {nick = nick, id = id, frak = i})
            break
        end
    end
end
function onD3DPresent()
    local sw, sh = getScreenResolution()
    if #tkilllist ~= 0 and fonts_loaded and not isPauseMenuActive() and swork then
        if killlistmode == 1 then
            local killsy = cfg.killlist.posy + cfg.other.killsize/4
            for k, v in ipairs(tkilllist) do
                d3dxfont_draw(font_gtaweapon3, 'G', {cfg.killlist.posx ,killsy, sw, sh}, 0xFF000000, 0x10)
                d3dxfont_draw(font_gtaweapon3, string.char(RenderGun[v['reason']]), {cfg.killlist.posx ,killsy, sw, sh}, 0xFFFFFFFF, 0x10)
                killsy = killsy + renderGetFontDrawHeight(killfont)
            end
        end
    end
end
function upd_locals()
    while true do wait(100)
        hfps = math.floor(mem.getfloat(0xB7CB50, 4, false))
    end
end
function renders()
    while true do wait(0)
        if swork and not isPauseMenuActive() then
            local admrenderPosY = cfg.admchecker.posy
            local playerRenderPosY = cfg.playerChecker.posy
            local tempRenderPosY = cfg.tempChecker.posy
            local leadersRenderPosy = cfg.leadersChecker.posy
            local hposx, hposy, hposz = getCharCoordinates(PLAYER_PED)
            local hposint = getActiveInterior()
            local hpos = ("%0.2f %0.2f %0.2f"):format(hposx, hposy, hposz)
            local hsx, hsy = getScreenResolution()
            local checkerheight = renderGetFontDrawHeight(checkfont)
            local hudheight = renderGetFontDrawHeight(hudfont)
            local killheight = renderGetFontDrawHeight(killfont)
            screenx, screeny = getScreenResolution()
            if killlistmode == 1 then
                local killsy = cfg.killlist.posy
                for k, v in ipairs(tkilllist) do
                    local killlenght = renderGetFontDrawTextLength(killfont,v['killer'])
                    local gunlenght = renderGetFontDrawTextLength(gunfont, v['reason'])
                    local deathlenght = renderGetFontDrawTextLength(killfont,v['killed'])
                    renderFontDrawText(killfont, v['killer'], cfg.killlist.posx-killlenght-3, killsy, -1)
                    renderFontDrawText(killfont, v['killed'], cfg.killlist.posx+cfg.other.killsize*1.35 ,killsy, -1)
                    killsy = killsy + killheight
                end
            end
            if cfg.joinquit.enable then
                if notification_connect then
                    if localClock() - notification_connect.tick <= notification_connect.duration then
                        local alpha = 255 * math.min(1, notification_connect.duration - (localClock() - notification_connect.tick))
                        local color = bit.bor(notification_connect.color, bit.lshift(alpha, 24))
                        for k = #notification_connect.lines, 1, -1 do
                            local text = notification_connect.lines[k]
                            if #text > 0 then
                                renderFontDrawText(hudfont, text, cfg.joinquit.joinposx, cfg.joinquit.joinposy, color)
                            end
                        end
                    else
                        notification_connect = nil
                    end
                end
                if notification_disconnect then
                    if localClock() - notification_disconnect.tick <= notification_disconnect.duration then
                        local alpha = 255 * math.min(1, notification_disconnect.duration - (localClock() - notification_disconnect.tick))
                        local color = bit.bor(notification_disconnect.color, bit.lshift(alpha, 24))
                        for k = #notification_disconnect.lines, 1, -1 do
                            local text = notification_disconnect.lines[k]
                            if #text > 0 then
                                renderFontDrawText(hudfont, text, cfg.joinquit.quitposx, cfg.joinquit.quitposy, color)
                            end
                        end
                    else
                        notification_disconnect = nil
                    end
                end
            end
            renderFontDrawText(hudfont, ('%s %s %s %s [%s %s] [FPS: %s]'):format(os.date("[%H:%M:%S]"), funcsStatus.Inv and '{00FF00}[Inv]{ffffff}' or '[Inv]', funcsStatus.AirBrk and '{00FF00}[AirBrk]{ffffff}' or '[AirBrk]', flyInfo.active and '{00FF00}[Fly]{ffffff}' or '[Fly]', hpos, hposint, hfps), 0, screeny-hudheight, -1)
            if cfg.admchecker.enable then
                renderFontDrawText(checkfont, "{00ff00}Админы онлайн ["..#admins_online.."]:", cfg.admchecker.posx, admrenderPosY-#admins_online*checkerheight, -1)
                for k, v in ipairs(admins_online) do
                    renderFontDrawText(checkfont,string.format('{%s}%s [%s] %s{5aa0aa} %s',v['color'], v["nick"], sampGetPlayerIdByNickname(v["nick"]), doesCharExist(select(2, sampGetCharHandleBySampPlayerId(v["id"]))) and '{5aa0aa}(Р)' or '', v['text']) , cfg.admchecker.posx, (admrenderPosY - k*checkerheight)+checkerheight, -1)
                end
            end
            if cfg.playerChecker.enable then
                renderFontDrawText(checkfont, "{FFFF00}Игроки онлайн ["..#players_online.."]:", cfg.playerChecker.posx, playerRenderPosY-#players_online*checkerheight, -1)
                for k, v in ipairs(players_online) do
                    renderFontDrawText(checkfont,string.format('{%s}%s [%s] %s{5aa0aa} %s',v['color'], v["nick"], sampGetPlayerIdByNickname(v["nick"]), doesCharExist(select(2, sampGetCharHandleBySampPlayerId(v["id"]))) and '{5aa0aa}(Р)' or '', v['text']) , cfg.playerChecker.posx, (playerRenderPosY - k*checkerheight)+checkerheight, -1)
                end
            end
            if cfg.tempChecker.enable then
                renderFontDrawText(checkfont, "{ff0000}Temp Чекер ["..#temp_checker_online.."]:", cfg.tempChecker.posx, tempRenderPosY-#temp_checker_online*checkerheight, -1)
                for k, v in ipairs(temp_checker_online) do
                    renderFontDrawText(checkfont,string.format('{%s}%s [%s] %s{5aa0aa} %s',v['color'], v["nick"], sampGetPlayerIdByNickname(v["nick"]), doesCharExist(select(2, sampGetCharHandleBySampPlayerId(v["id"]))) and '{5aa0aa}(Р)' or '', v['text']) , cfg.tempChecker.posx, (tempRenderPosY - k*checkerheight)+checkerheight, -1)
                end
            end
            if cfg.leadersChecker.enable then
                renderFontDrawText(checkfont, "{D76E00}Лидеры онлайн ["..#leader_checker_online.."]:", cfg.leadersChecker.posx, leadersRenderPosy-#leader_checker_online*checkerheight, -1)
                for k, v in ipairs(leader_checker_online) do
                    if cfg.leadersChecker.cvetnick then
                        renderFontDrawText(checkfont,string.format('{%s}%s [%s] %s{5aa0aa} {%s}%s',leaders1[v['frak']], v["nick"], sampGetPlayerIdByNickname(v["nick"]), doesCharExist(select(2, sampGetCharHandleBySampPlayerId(v["id"]))) and '{5aa0aa}(Р)' or '', leaders1[v['frak']], v['frak']) , cfg.leadersChecker.posx, (leadersRenderPosy - k*checkerheight)+checkerheight, -1)
                    else
                        renderFontDrawText(checkfont,string.format('%s [%s] %s{5aa0aa} {%s}%s',v["nick"], sampGetPlayerIdByNickname(v["nick"]), doesCharExist(select(2, sampGetCharHandleBySampPlayerId(v["id"]))) and '{5aa0aa}(Р)' or '', leaders1[v['frak']], v['frak']) , cfg.leadersChecker.posx, (leadersRenderPosy - k*checkerheight)+checkerheight, -1)
                    end
                end
            end
        end
    end
end
function sampGetPlayerIdByNickname(nick)
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    if tostring(nick) == sampGetPlayerNickname(myid) then return myid end
    for i = 0, 1000 do if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == tostring(nick) then return i end end
end

function check_keystrokes()
    while true do wait(0)
        if swork then
            if not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
                if isKeyJustPressed(key.VK_F3) then
                    setCharHealth(PLAYER_PED, 0)
                end
                if isKeyJustPressed(key.VK_INSERT) then
                    funcsStatus.Inv = not funcsStatus.Inv
                end
                if isKeyJustPressed(config_keys.airbrkkey.v) then
                    airspeed = cfg.cheat.airbrkspeed
                    funcsStatus.AirBrk = not funcsStatus.AirBrk
                    if funcsStatus.AirBrk then
                        if not reconstate then
                            local posX, posY, posZ = getCharCoordinates(playerPed)
                            airBrkCoords = {posX, posY, posZ, 0.0, 0.0, getCharHeading(playerPed)}
                        end
                    end
                end
            end
        end
    end
end
function main_funcs()
    while true do wait(0)
        if swork then
            if funcsStatus.Inv then
                if isCharInAnyCar(playerPed) then
                    setCarProofs(storeCarCharIsInNoSave(playerPed), true, true, true, true, true)
                    setCharCanBeKnockedOffBike(playerPed, true)
                    setCanBurstCarTires(storeCarCharIsInNoSave(playerPed), false)
                end
                setCharProofs(playerPed, true, true, true, true, true)
            else
                if isCharInAnyCar(playerPed) then
                    setCarProofs(storeCarCharIsInNoSave(playerPed), false, false, false, false, false)
                    setCharCanBeKnockedOffBike(playerPed, false)
                end
                setCharProofs(playerPed, false, false, false, false, false)
            end

            local time = os.clock() * 1000
            if funcsStatus.AirBrk then
                if not reconstate then
                    if isCharInAnyCar(playerPed) then heading = getCarHeading(storeCarCharIsInNoSave(playerPed))
                    else heading = getCharHeading(playerPed) end
                    local camCoordX, camCoordY, camCoordZ = getActiveCameraCoordinates()
                    local targetCamX, targetCamY, targetCamZ = getActiveCameraPointAt()
                    local angle = getHeadingFromVector2d(targetCamX - camCoordX, targetCamY - camCoordY)
                    if isCharInAnyCar(playerPed) then difference = 0.79 else difference = 1.0 end
                    setCharCoordinates(playerPed, airBrkCoords[1], airBrkCoords[2], airBrkCoords[3] - difference)
                    if not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
                        if isKeyDown(key.VK_W) then
                            airBrkCoords[1] = airBrkCoords[1] + airspeed * math.sin(-math.rad(angle))
                            airBrkCoords[2] = airBrkCoords[2] + airspeed * math.cos(-math.rad(angle))
                            if not isCharInAnyCar(playerPed) then setCharHeading(playerPed, angle)
                            else setCarHeading(storeCarCharIsInNoSave(playerPed), angle) end
                        elseif isKeyDown(key.VK_S) then
                            airBrkCoords[1] = airBrkCoords[1] - airspeed * math.sin(-math.rad(heading))
                            airBrkCoords[2] = airBrkCoords[2] - airspeed * math.cos(-math.rad(heading))
                        end
                        if isKeyDown(key.VK_A) then
                            airBrkCoords[1] = airBrkCoords[1] - airspeed * math.sin(-math.rad(heading - 90))
                            airBrkCoords[2] = airBrkCoords[2] - airspeed * math.cos(-math.rad(heading - 90))
                        elseif isKeyDown(key.VK_D) then
                            airBrkCoords[1] = airBrkCoords[1] - airspeed * math.sin(-math.rad(heading + 90))
                            airBrkCoords[2] = airBrkCoords[2] - airspeed * math.cos(-math.rad(heading + 90))
                        end
                        if isKeyDown(key.VK_UP) then airBrkCoords[3] = airBrkCoords[3] + airspeed / 2.0 end
                        if isKeyDown(key.VK_DOWN) and airBrkCoords[3] > -95.0 then airBrkCoords[3] = airBrkCoords[3] - airspeed / 2.0 end
                        if isKeyDown(key.VK_LSHIFT) and not isKeyDown(key.VK_RSHIFT) and airspeed > 0.06 then airspeed = airspeed - 0.050; printStringNow('Speed: '..airspeed, 1000) end
                        if isKeyDown(key.VK_SPACE) then airspeed = airspeed + 0.050; printStringNow('Speed: '..airspeed, 1000) end
                    end
                end
            end
        end
    end
end
function check_keys_fast()
    while true do wait(0)
        if swork then
            local isInVeh = isCharInAnyCar(playerPed)
            local veh = nil
            if isInVeh then veh = storeCarCharIsInNoSave(playerPed) end
            if not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
                if wasKeyPressed(190) then
                    if flyInfo.active == true then
                        clearCharTasks(playerPed)
                        flyInfo.active = false
                    else
                        flyInfo.active = true
                    end
                end
                if flyInfo.active then
                    fly()
                end
                if isKeyJustPressed(key.VK_F3) then
                    setCharHealth(PLAYER_PED, 0)
                end
                if isKeyJustPressed(key.VK_INSERT) then
                    funcsStatus.Inv = not funcsStatus.Inv
                end
                if isKeyJustPressed(config_keys.airbrkkey.v) then
                    airspeed = cfg.cheat.airbrkspeed
                    funcsStatus.AirBrk = not funcsStatus.AirBrk
                    if funcsStatus.AirBrk then
                        local posX, posY, posZ = getCharCoordinates(playerPed)
                        airBrkCoords = {posX, posY, posZ, 0.0, 0.0, getCharHeading(playerPed)}
                    end
                end
                if isKeyJustPressed(key.VK_B) then 
                    if isCharInAnyCar(playerPed) then
                        local cVecX, cVecY, cVecZ = getCarSpeedVector(storeCarCharIsInNoSave(playerPed))
                        if cVecZ < 7.0 then applyForceToCar(storeCarCharIsInNoSave(playerPed), 0.0, 0.0, 0.3, 0.0, 0.0, 0.0) end
                    else
                        local pVecX, pVecY, pVecZ = getCharVelocity(playerPed)
                        if pVecZ < 7.0 then setCharVelocity(playerPed, 0.0, 0.0, 10.0) end
                    end
                end
                if isKeyJustPressed(key.VK_BACK) and isCharInAnyCar(playerPed) then
                    local cVecX, cVecY, cVecZ = getCarSpeedVector(storeCarCharIsInNoSave(playerPed))
                    applyForceToCar(storeCarCharIsInNoSave(playerPed), -cVecX / 25, -cVecY / 25, -cVecZ / 25, 0.0, 0.0, 0.0)
                    local x, y, z, w = getVehicleQuaternion(storeCarCharIsInNoSave(playerPed))
                    local matrix = {convertQuaternionToMatrix(w, x, y, z)}
                    matrix[1] = -matrix[1]
                    matrix[2] = -matrix[2]
                    matrix[4] = -matrix[4]
                    matrix[5] = -matrix[5]
                    matrix[7] = -matrix[7]
                    matrix[8] = -matrix[8]
                    local w, x, y, z = convertMatrixToQuaternion(matrix[1], matrix[2], matrix[3], matrix[4], matrix[5], matrix[6], matrix[7], matrix[8], matrix[9])
                    setVehicleQuaternion(storeCarCharIsInNoSave(playerPed), x, y, z, w)
                end
                if isKeyJustPressed(key.VK_N) and isCharInAnyCar(playerPed) then 
                    local posX, posY, posZ = getCarCoordinates(storeCarCharIsInNoSave(playerPed))
                    warpCharFromCarToCoord(playerPed, posX, posY, posZ)
                end
                if isKeyJustPressed(key.VK_F3) then 
                    if not isCharInAnyCar(playerPed) then
                        setCharHealth(playerPed, 0.0)
                    else
                        setCarHealth(storeCarCharIsInNoSave(playerPed), 0.0)
                    end
                end
                if isKeyDown(key.VK_DELETE) then 
                    if veh ~= nil then
                        local heading = getCarHeading(veh)
                        heading = heading + 2 * fps_correction()
                        if heading > 360 then heading = heading - 360 end
                        setCarHeading(veh, heading)
                    end
                end
                if isKeyDown(key.VK_LMENU) and isCharInAnyCar(playerPed) then 
                    if getCarSpeed(storeCarCharIsInNoSave(playerPed)) * 2.01 <= 200 then
                        local cVecX, cVecY, cVecZ = getCarSpeedVector(storeCarCharIsInNoSave(playerPed))
                        local heading = getCarHeading(storeCarCharIsInNoSave(playerPed))
                        local turbo = fps_correction() / 85
                        local xforce, yforce, zforce = turbo, turbo, turbo
                        local Sin, Cos = math.sin(-math.rad(heading)), math.cos(-math.rad(heading))
                        if cVecX > -0.01 and cVecX < 0.01 then xforce = 0.0 end
                        if cVecY > -0.01 and cVecY < 0.01 then yforce = 0.0 end
                        if cVecZ < 0 then zforce = -zforce end
                        if cVecZ > -2 and cVecZ < 15 then zforce = 0.0 end
                        if Sin > 0 and cVecX < 0 then xforce = -xforce end
                        if Sin < 0 and cVecX > 0 then xforce = -xforce end
                        if Cos > 0 and cVecY < 0 then yforce = -yforce end
                        if Cos < 0 and cVecY > 0 then yforce = -yforce end
                        applyForceToCar(storeCarCharIsInNoSave(playerPed), xforce * Sin, yforce * Cos, zforce / 2, 0.0, 0.0, 0.0)
                    end
                end
            end
        end
    end
end
function onReceiveRpc(id, bs) 
    if id == 91 and swork and isKeyDown(key.VK_LMENU) then 
        return false 
    end
end
function tr(pam)
    local idd = tonumber(pam)
    if idd ~= nil then
        if idd == -1 then
            atext('Трейсера отключены')
            traceid = -1
        else
            if sampIsPlayerConnected(idd) then
                if idd == traceid then
                    atext(('Трейсера для {66FF00}%s [%s]{ffffff} отключены'):format(sampGetPlayerNickname(idd), idd))
                    traceid = -1
                else
                    atext(('Трейсера переключены на {66ff00}%s [%s]'):format(sampGetPlayerNickname(idd), idd))
                    traceid = idd
                end
            else
                atext('Игрок оффлайн')
            end
        end
    else
        atext('Введите: /tr [id/-1]')
    end
end
function wh()
    while not sampIsLocalPlayerSpawned() do wait(0) end
    nameTagOff()
    while true do wait(0)
        if swork then
            if not nameTag then
                if not isPauseMenuActive() then
                    nametagCoords = {}
                    for wi = 0, sampGetMaxPlayerId(true) do
                        if sampIsPlayerConnected(wi) then
                            local result, cped = sampGetCharHandleBySampPlayerId(wi)
                            if result then
                                if doesCharExist(cped) and isCharOnScreen(cped) then
                                    local wcolor = ("%06X"):format(bit.band(sampGetPlayerColor(wi), 0xFFFFFF))
                                    local cpos1X, cpos1Y, cpos1Z = getBodyPartCoordinates(6, cped)
                                    local wcpedx, wcpedy, wcpedz = getCharCoordinates(cped)
                                    local wnick = sampGetPlayerNickname(wi)
                                    local wheadposx, wheadposy = convert3DCoordsToScreen(cpos1X, cpos1Y, cpos1Z)
                                    local wcposx, wcposy = convert3DCoordsToScreen(wcpedx, wcpedy, wcpedz)
                                    local wisAfk = sampIsPlayerPaused(wi)
                                    local wcpedHealth = sampGetPlayerHealth(wi)
                                    local hp2 = wcpedHealth
                                    local wcpedArmor = sampGetPlayerArmor(wi)
                                    local wcpedlvl = sampGetPlayerScore(wi)
                                    local whhight = renderGetFontDrawHeight(whfont)
                                    local whhphight = renderGetFontDrawHeight(whhpfont)
                                    local whlenght = renderGetFontDrawTextLength(whfont,string.format('{%s}%s [%s]', wcolor, wnick, wi))
                                    local lvllenght = renderGetFontDrawTextLength(whfont, 'LVL: '..wcpedlvl)
                                    local hplenght = renderGetFontDrawTextLength(whfont, ('%s'):format(wcpedHealth))
                                    local color = sampGetPlayerColor(wi)
                                    local aa, rr, gg, bb = explode_argb(color)
                                    local color = join_argb(255, rr, gg, bb)
                                    local wposy = wheadposy - 40
                                    local wposx = wheadposx - 60
                                    --[[if wheadposy - (wcposy - 200) > 119 then
                                        wposy = wheadposy - 40
                                        wposx = wheadposx - 60
                                    else
                                        wposy = wcposy - 200
                                        wposx = wcposx
                                    end
                                    print(sampGetPlayerNickname(wi), wheadposy-wcposy, wheadposy, wcposy, wposy, wheadposy - (wcposy - 200))]]
                                    for _, v in ipairs(nametagCoords) do
                                        if v["pos_y"] > wposy-whhight*2.33 and v["pos_y"] < wposy+whhight*2.33 and v["pos_x"] > wposx-whlenght and v["pos_x"] < wposx+whlenght then
                                            wposy = v["pos_y"] - whhight*2.33
                                        end
                                    end
                                    nametagCoords[#nametagCoords+1] = {
                                        pos_y = wposy,
                                        pos_x = wposx
                                    }
                                    renderFontDrawText(whfont, string.format('{%s}%s [%s] %s', wcolor, wnick, wi, wisAfk and '{cccccc}[AFK]' or ''), wposx, wposy, -1)
                                    if wcpedHealth > 100 then wcpedHealth = 100 end
                                    if wcpedArmor > 100 then wcpedArmor = 100 end
                                    renderDrawBoxWithBorder(wposx+1, wposy+whhight*1.33, math.floor(100 / 2) + 2, whhight/3+1, 0x80000000, 1, 0xFF000000)
                                    renderDrawBox(wposx+2, wposy+whhight*1.33, math.floor(wcpedHealth / 2) , whhight/3, 0xAACC0000)
                                    renderFontDrawText(whfont, ('%s'):format(hp2), wposx+60, wposy+whhight, 0xFFFF0000)
                                    renderFontDrawText(whfont, 'LVL: '..wcpedlvl, wposx+70+hplenght, wposy+whhight, -1)
                                    if wcpedArmor ~= 0 then
                                        renderDrawBoxWithBorder(wposx+1, wposy+whhight*2.33, math.floor(100 / 2) + 2, whhight/3+1, 0x80000000, 1, 0xFF000000)
                                        renderDrawBox(wposx+2, wposy+whhight*2.33, math.floor(wcpedArmor / 2) , whhight/3, 0xAAAAAAAA)
                                        renderFontDrawText(whfont, ('%s'):format(wcpedArmor), wposx+60, wposy+whhight*2, -1)
                                    end
                                    if cfg.other.skeletwh then
                                        local t = {3, 4, 5, 51, 52, 41, 42, 31, 32, 33, 21, 22, 23, 2}
                                        for v = 1, #t do
                                            pos1X, pos1Y, pos1Z = getBodyPartCoordinates(t[v], cped)
                                            pos2X, pos2Y, pos2Z = getBodyPartCoordinates(t[v] + 1, cped)
                                            pos1, pos2 = convert3DCoordsToScreen(pos1X, pos1Y, pos1Z)
                                            pos3, pos4 = convert3DCoordsToScreen(pos2X, pos2Y, pos2Z)
                                            renderDrawLine(pos1, pos2, pos3, pos4, 1, color)
                                        end
                                        for v = 4, 5 do
                                            pos2X, pos2Y, pos2Z = getBodyPartCoordinates(v * 10 + 1, cped)
                                            pos3, pos4 = convert3DCoordsToScreen(pos2X, pos2Y, pos2Z)
                                            renderDrawLine(pos1, pos2, pos3, pos4, 1, color)
                                        end
                                        local t = {53, 43, 24, 34, 6}
                                        for v = 1, #t do
                                            posX, posY, posZ = getBodyPartCoordinates(t[v], cped)
                                            pos1, pos2 = convert3DCoordsToScreen(posX, posY, posZ)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
function nameTagOn()
    nameTag = true
    local pStSet = sampGetServerSettingsPtr();
    NTdist = mem.getfloat(pStSet + 39)
    NTwalls = mem.getint8(pStSet + 47)
    NTshow = mem.getint8(pStSet + 56)
    mem.setfloat(pStSet + 39, 36.0)
    mem.setint8(pStSet + 47, 1)
    mem.setint8(pStSet + 56, 1)
end
function whon1()
    local pStSet = sampGetServerSettingsPtr();
    NTdist = mem.getfloat(pStSet + 39)
    NTwalls = mem.getint8(pStSet + 47)
    NTshow = mem.getint8(pStSet + 56)
    mem.setfloat(pStSet + 39, 36.0)
    mem.setint8(pStSet + 47, 1)
    mem.setint8(pStSet + 56, 1)
end
function sampGetDeathReason(id)
	local names = {
		[0] = 'Кулак',
		[1] = 'Кастет',
		[2] = 'Клюшка для гольфа',
		[3] = 'Полицейская дубинка',
		[4] = 'Нож',
		[5] = 'Бита',
		[6] = 'Лопата',
		[7] = 'Кий',
		[8] = 'Катана',
		[9] = 'Бензопила',
		[10] = 'Фиолетовый дилдо',
		[11] = 'Короткий вибратор',
		[12] = 'Длинный вибратор',
		[13] = 'Белый дилдо',
		[14] = 'Цветы',
		[15] = 'Трость',
		[16] = 'Граната',
		[17] = 'Cлезоточивый газ',
		[18] = 'Слезоточивый газ',
		[22] = 'Пистолет',
		[23] = 'Пистолет с глушителем',
		[24] = 'Дигл',
		[25] = 'Шотган',
		[26] = 'Обрез',
		[27] = 'Боевой дробовик',
		[28] = 'Узи',
		[29] = 'МП5',
		[30] = 'АК47',
		[31] = 'М4',
		[32] = 'Tec 9',
		[33] = 'Винтовка',
		[34] = 'Снайперская винтовка',
		[35] = 'РПГ',
		[36] = 'РПГ с самонаводкой',
		[37] = 'Огнемет',
		[38] = 'Миниган',
		[39] = 'Сумка для зарядки',
		[40] = 'Детонатор',
		[41] = 'Балончик с краской',
		[42] = 'Огнетушитель',
		[43] = 'Фотоопарат',
		[44] = 'Очки ночного виденья',
		[45] = 'Тепловизор',
		[46] = 'Парашют',
		[47] = 'Фейк пистолет',
		[49] = 'Транспорт',
		[50] = 'Винты вертолета',
		[51] = 'Взрыв',
		[53] = 'Утонул',
		[54] = 'От падения',
		[255] = 'Суицид'
	}
	return names[id]
end
function nameTagOff()
    nameTag = false
	local pStSet = sampGetServerSettingsPtr();
	mem.setfloat(pStSet + 39, NTdist)
	mem.setint8(pStSet + 47, NTwalls)
	mem.setint8(pStSet + 56, NTshow)
end
function whoff()
    local pStSet = sampGetServerSettingsPtr();
	mem.setfloat(pStSet + 39, NTdist)
	mem.setint8(pStSet + 47, NTwalls)
    mem.setint8(pStSet + 56, NTshow)
end
function getBodyPartCoordinates(id, handle)
    local pedptr = getCharPointer(handle)
    local vec = ffi.new("float[3]")
    getBonePosition(ffi.cast("void*", pedptr), vec, id, true)
    return vec[0], vec[1], vec[2]
end
function warningsKey()
    while true do wait(0)
        local wtext, wprefix, wcolor, wpcolor = sampGetChatString(99)
        if wcolor == 4294967295 and wtext:match('%[SWarning%]%:{.+}  Игрок  .+ %[%d+%] - .+') and not wtext:find('ExtraWS') then
            cwid = wtext:match('%[SWarning%]%:{.+}  Игрок  .+ %[(%d+)%] - .+')
        end
        if wtext:match('%[SWarning%]%:{.+}  Игрок  .+ %[%d+%] - .+') and wcolor == 4294967295 and wtext:find('ExtraWS') then
            cwid = wtext:match('%[SWarning%]%:{.+}  Игрок  .+ %[(%d+)%] - .+')
        end
        if wcolor == 4294911012 and wtext:match('<Warning> {.+}.+%[%d+%]% .+') and not wtext:match("<Warning> {.+}.+%[%d+%] возможно попал сквозь текстуру в {.+}.+%[%d+%] из .+ %(model: %d+%)") then
            cwid = wtext:match('<Warning> {.+}.+%[(%d+)%]% .+')
        end
        if wtext:match("<Warning> {.+}.+%[%d+%] возможно попал сквозь текстуру в {.+}.+%[%d+%] из .+ %(model: %d+%)") then
            cwid = wtext:match("<Warning> {.+}.+%[(%d+)%] возможно попал сквозь текстуру в {.+}.+%[%d+%] из .+ %(model: %d+%)")
        end
        if wtext:match('^<Warning> {.+}.+%[%d+%] {FFFFFF}.+') then
            cwid = wtext:match('^<Warning> {.+}.+%[(%d+)%] {FFFFFF}.+')
        end
        if wtext:match('^Warning:{.+} .+%[%d+%] .+') and not wtext:match('^Warning:{.+} .+%[%d+%] возможно попал сквозь текстуру в{.+} .+%[%d+%] из: .+ %(texture: %d+%)') then
            cwid = wtext:match('^Warning:{.+} .+%[(%d+)%] .+')
        end
        if wtext:match('^Warning:{.+} .+%[%d+%] возможно попал сквозь текстуру в{.+} .+%[%d+%] из: .+ %(texture: %d+%)') then
            cwid = wtext:match('^Warning:{.+} .+%[(%d+)%] возможно попал сквозь текстуру в{.+} .+%[%d+%] из: .+ %(texture: %d+%)')
        end
        if wtext:match('%[mkrn wrn%]:%{%S+%} .+%[%d+%] .+') and not wtext:match('%[mkrn wrn%]:%{.+%} .+%[%d+%] возможно дамажит%/стреляет из сайлента в игрока%{.+%} .+%[%d+%] из .+') and not wtext:match('%[mkrn wrn%]:%{.+%} .+%[%d+%] попал сквозь текстуру в%{.+%} .+%[%d+%] из: .+, texture: %d+ %[.+%]') then
            cwid = wtext:match('%[mkrn wrn%]:%{%S+%} .+%[(%d+)%] .+')
        end
        if wtext:match('%[mkrn wrn%]:%{.+%} .+%[%d+%] возможно дамажит%/стреляет из сайлента в игрока%{.+%} .+%[%d+%] из .+') then
            cwid = wtext:match('%[mkrn wrn%]%:%{.+%} .+%[(%d+)%] возможно дамажит/стреляет из сайлента в игрока%{.+%} .+%[%d+%] из .+')
        end
        if wtext:match('%[mkrn wrn%]:%{.+%} .+%[%d+%] попал сквозь текстуру в%{.+%} .+%[%d+%] из: .+, texture: %d+ %[.+%]') then
            cwid = wtext:match('%[mkrn wrn%]%:%{.+%} .+%[(%d+)%] попал сквозь текстуру в%{.+%} .+%[%d+%] из: .+, texture: %d+ %[.+%]')
        end
    end
end
function gun(pam)
    lua_thread.create(function()
        local id, pt = pam:match('(%d+) (%d+)')
        if id and pt then
            requestModel(getWeapontypeModel(id))
            while not isModelAvailable(getWeapontypeModel(id)) do wait(0) end
            giveWeaponToChar(PLAYER_PED, id, pt)
        end
    end)
end
function sampev.onSendClientJoin(version, mod, nick)
    zapolncheck()
end
function sampev.onShowDialog(id, style, title, button1, button2, text)
    if id == 0 then
        if bancheck then
            if title == bnick then
                for line in text:gmatch('[^\r\n]+') do
                    if not line:find("Дата") then
                        local adm, reason, data1, data2 = line:match("(%S+)\t(.+)\t(.+)\t(.+)")
                        atext(("Игрок %s заблокирован до %s. Причина: %s"):format(bnick, data2, reason))
                        sampSendDialogResponse(id, 1, 1, nil)
                        bancheck = false
                        return false
                    end
                end
            end
        end
        if warnst then
			if title == 'Статистика персонажа' then
            wbfrak = text:match('.+Организация%:%s+(.+)%s+Ранг')
            wbrang = text:match('.+Ранг%:%s+(.+)%s+Работа')
				wbstyle = 1
                sampSendDialogResponse(id, 1, 1, nil)
                checkstatdone = true
                return false
			elseif title == '{FFFFFF}Статистика | {ae433d}Администрирование' then
				wbfrak = text:match('.+Организация\t(.+)\nДолжность')
				wbrang = text:match('.+Должность\t.+%[(.+)%]\nРабота')
				wbstyle = 2
				sampSendDialogResponse(id, 1, 1, nil)
				checkstatdone = true
				return false
			end
        end
    end
    if id == 1 and #tostring(cfg.other.password) >=6  and cfg.other.passb then
        sampSendDialogResponse(id, 1, _, tostring(cfg.other.password))
        return false
    end
    if id == 1227 and #tostring(cfg.other.adminpass) >=6 and cfg.other.apassb then
        sampSendDialogResponse(id, 1, _, tostring(cfg.other.adminpass))
        return false
    end
end
function warn(pam)
    lua_thread.create(function()
        local id, days, reason = pam:match('(%d+) (%d+) (.+)')
        if id and days and reason then
            if sampIsPlayerConnected(id) then
                if sampGetPlayerScore(id) < 3 then
                    sampSendChat(string.format("/warn %s %s %s", id, days, reason))
                else
                    if cfg.other.fracstat then
                        warnst = true
                        local wnick = sampGetPlayerNickname(id)
                        sampSendChat('/getstats '..id)
                        local wtime = os.clock() + 10
                        while not checkstatdone or wtime < os.clock() do wait(0) end
                        wait(cfg.other.delay)
                        if sampIsPlayerConnected(id) then
                            if sampGetPlayerNickname(id) ~= nil then
                                if sampGetPlayerNickname(id) == wnick then
                                    if wbstyle == 1 then
                                        if getRank(wbfrak, wbrang) ~= nil and getFrak(wbfrak) ~= nil then
                                            sampSendChat(string.format('/warn %s %s %s [%s/%s]', id, days, reason, getFrak(wbfrak), getRank(wbfrak, wbrang)))
                                        else
                                            sampSendChat(string.format('/warn %s %s %s', id, days, reason))
                                        end
                                    elseif wbstyle == 2 then
                                        if getFrak(wbfrak) ~= nil and wbfrak ~= 'Нет' then
                                            sampSendChat(string.format('/warn %s %s %s [%s/%s]', id, days, reason, getFrak(wbfrak), wbrang))
                                        else
                                            sampSendChat(string.format('/warn %s %s %s', id, days, reason))
                                        end
                                    end
                                else
                                    atext('Игрок '..wnick..' вышел из игры')
                                end
                            else
                                atext('Игрок '..wnick..' вышел из игры')
                            end
                        else
                            atext('Игрок '..wnick..' вышел из игры')
                        end
                    else
                        sampSendChat(string.format('/warn %s %s %s', id, days, reason))
                    end
                    checkstatdone = false
                    warnst = false
                    wbfrak = nil
                    wbrang = nil
                    wnick = nil
                    wtime = nil
                end
            else
                atext("Игрок оффлайн")
            end
        else
            atext('Введите: /warn [id] [дни] [причина]')
        end
    end)
end
function ban(pam)
    lua_thread.create(function()
        local id, reason = pam:match('(%d+) (.+)')
        if id and reason then
            if sampIsPlayerConnected(id) then
                if sampGetPlayerScore(id) < 3 then
                    sampSendChat(string.format('/ban %s %s', id, reason))
                else
                    if cfg.other.fracstat then
                        if not checkIntable(punishignor, reason) then
                            local wnick = sampGetPlayerNickname(id)
                            warnst = true
                            sampSendChat('/getstats '..id)
                            local wtime = os.clock() + 10
                            while not checkstatdone or wtime < os.clock() do wait(0) end
                            wait(cfg.other.delay)
                            if sampIsPlayerConnected(id) then
                                if sampGetPlayerNickname(id)~= nil then
                                    if sampGetPlayerNickname(id) == wnick then
                                        if wbstyle == 1 then
                                            if getRank(wbfrak, wbrang) ~= nil and getFrak(wbfrak) ~= nil then
                                                sampSendChat(string.format('/ban %s %s [%s/%s]', id, reason, getFrak(wbfrak), getRank(wbfrak, wbrang)))
                                            else
                                                sampSendChat(string.format('/ban %s %s', id, reason))
                                            end
                                        elseif wbstyle == 2 then
                                            if getFrak(wbfrak) ~= nil and wbfrak ~= 'Нет' then
                                                sampSendChat(string.format('/ban %s %s [%s/%s]', id, reason, getFrak(wbfrak), wbrang))
                                            else
                                                sampSendChat(string.format('/ban %s %s', id, reason))
                                            end
                                        end
                                    else
                                        atext('Игрок '..wnick..' вышел из игры')
                                    end
                                else
                                    atext('Игрок '..wnick..' вышел из игры')
                                end
                            else
                                atext('Игрок '..wnick..' вышел из игры')
                            end
                        else
                            sampSendChat(string.format('/ban %s %s', id, reason))
                        end
                        wnick = nil
                        checkstatdone = false
                        wbfrak = nil
                        wbrang = nil
                        warnst = false
                        wtime = nil
                    else
                        sampSendChat(string.format('/ban %s %s', id, reason))
                    end
                end
            else
                atext("Игрок оффлайн")
            end
        else
            atext('Введите: /ban [id] [причина]')
        end
    end)
end
function wl(pam)
    local id = tonumber(pam)
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if #pam ~= 0 then
        if id ~= nil then
            if sampIsPlayerConnected(id) or id == myid then
                sampSendChat('/warnlog '..sampGetPlayerNickname(id))
            else
                sampSendChat('/warnlog ' ..id)
            end
        else
            sampSendChat('/warnlog '..pam)
        end
    else
        atext('Введите: /wlog [id/nick]')
    end
end
function gs(pam)
    local id = tonumber(pam)
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if id ~= nil then
        if sampIsPlayerConnected(id) or id == myid then
            sampSendChat(("/getstats %s"):format(id))
        else
            atext("Игрок оффлайн")
        end
    else
        if reid ~= -1 then
            sampSendChat(("/getstats %s"):format(reid))
        else
            atext("Введите /gs [id]")
        end
    end
end
function sbiv(pam)
    local id = tonumber(pam)
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if id ~= nil then
        if sampIsPlayerConnected(id) or id == myid then
            if cfg.other.admlvl < 2 then
                sampSendChat(("/a /prison %s %s Сбив анимации"):format(id, cfg.timers.sbivtimer))
            else
                sampSendChat(("/prison %s %s Сбив анимации"):format(id, cfg.timers.sbivtimer))
            end
        else
            atext('Игрок оффлайн')
        end
    else
        atext("Введите: /sbiv [id]")
    end
end
function csbiv(pam)
    local id = tonumber(pam)
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if id ~= nil then
        if sampIsPlayerConnected(id) or id == myid then
            if cfg.other.admlvl < 2 then
                sampSendChat(("/a /prison %s %s Сбив анимации"):format(id, cfg.timers.csbivtimer))
            else
                sampSendChat(("/prison %s %s Сбив анимации"):format(id, cfg.timers.csbivtimer))
            end
        else
            atext('Игрок оффлайн')
        end
    else
        atext("Введите: /csbiv [id]")
    end
end
function cbug(pam)
    local id = tonumber(pam)
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if id ~= nil then
        if sampIsPlayerConnected(id) or id == myid then
            if cfg.other.admlvl < 2 then
                sampSendChat(("/a /prison %s %s +C вне гетто"):format(id, cfg.timers.cbugtimer))
            else
                sampSendChat(("/prison %s %s +C вне гетто"):format(id, cfg.timers.cbugtimer))
            end
        else
            atext('Игрок оффлайн')
        end
    else
        atext("Введите: /cbug [id]")
    end
end
function kills()
    sampShowDialog(21321, '{ffffff}Последние убийства', '{ffffff}Убийца\t{ffffff}Жертва\t{ffffff}Оружие\n'..table.concat(tkills, '\n'), 'x', _, 5)
end
function reportk()
    if reportid ~= nil then
        sampSendChat('/re '..reportid)
    end
end
function warningk()
	if wid ~= nil then
		sampSendChat('/re '..wid)
	end
end
function cwarningk()
	if cwid ~= nil then
		sampSendChat('/re '..cwid)
	end
end
function banipk()
	if bip ~= nil then
		sampSendChat('/banip '..bip)
	end
end
function saveposk()
    savecoords.x, savecoords.y, savecoords.z = getCharCoordinates(PLAYER_PED)
    atext('Текущие координаты сохранены. Для телепортирования нажмите {66FF00}'..table.concat(rkeys.getKeysName(config_keys.goposkey.v)))
    cango = true
end
function goposk()
    if cango then
        setCharCoordinates(PLAYER_PED, savecoords.x, savecoords.y, savecoords.z)
    end
end
function fonl(pam)
    lua_thread.create(function()
        local num = tonumber(pam)
        if num ~= nil then
            if num > 0 and num <= 29 then
                fonlcheck = true
                sampSendChat('/amembers '..num)
                while not fonldone do wait(0) end
                atext('Во фракции №{66FF00}'..num..' {ffffff}онлайн {66FF00}'..fonlnum..' {ffffff}человека')
                fonlcheck = false
                fonldone = false
                fonlnum = nil
            else
                atext('Значение не должно быть меньше 1 и больше 29!')
            end
        else
            atext('Введите: /fonl [id фракции]')
        end
    end)
end
function checkrangs(pam)
    lua_thread.create(function()
        local num = tonumber(pam)
        if num ~= nil then
            if num > 0 and num <= 29 then
                check_frak = num
                checkfraks = true
                sampSendChat('/amembers '..num)
                while not checkfraksdone do wait(0) end
                if #checkf == 0 then
                    atext('Во фракции №{66FF00}'..check_frak..'{ffffff} все нормально с рангами.')
                else
                    sampAddChatMessage(' ', -1)
                    for k, v in pairs(checkf) do
                        sampAddChatMessage(' '..v, -1)
                    end
                    sampAddChatMessage(' ', -1)
                    atext('Фракция №{66FF00}'..check_frak)
                end
                checkfraks = false
                checkfraksdone = false
                check_frak = nil
                checkf = {}
            else
                atext('Значение не должно быть меньше 1 и больше 29!')
            end
        else
            atext('Введите: /checkrangs [id фракции]')
        end
    end)
end
function ags(pam)
    local id = tonumber(pam)
    if #pam ~= 0 then
        if id ~= nil then
            if sampIsPlayerConnected(id) then
                sampSendChat('/agetstats '..sampGetPlayerNickname(id))
            else
                sampSendChat('/agetstats ' ..id)
            end
        else
            sampSendChat('/agetstats '..pam)
        end
    else
        atext('Введите: /ags [id/nick]')
    end
end
function cheat(pam)
	lua_thread.create(function()
		local id = tonumber(pam)
		if id ~= nil then
			if sampIsPlayerConnected(id) then
				local lvl = sampGetPlayerScore(id)
				if lvl < 3 then
					sampSendChat(string.format('/ban %s cheat', id))
				else
					warnst = true
					local wnick = sampGetPlayerNickname(id)
					sampSendChat('/getstats '..id)
					local wtime = os.clock() + 10
                    while not checkstatdone or wtime < os.clock() do wait(0) end
                    wait(cfg.other.delay)
                    if sampIsPlayerConnected(id) then
                        if sampGetPlayerNickname(id) ~= nil then
                            if sampGetPlayerNickname(id) == wnick then
                                if wbstyle == 1 then
                                    if getRank(wbfrak, wbrang) ~= nil and getFrak(wbfrak) ~= nil then
                                        sampSendChat(string.format('/warn %s 21 cheat [%s/%s]', id, getFrak(wbfrak), getRank(wbfrak, wbrang)))
                                    else
                                        sampSendChat(string.format('/warn %s 21 cheat', id))
                                    end
                                elseif wbstyle == 2 then
                                    if getFrak(wbfrak) ~= nil and wbfrak ~= 'Нет' then
                                        sampSendChat(string.format('/warn %s 21 cheat [%s/%s]', id, getFrak(wbfrak), wbrang))
                                    else
                                        sampSendChat(string.format('/warn %s 21 cheat', id))
                                    end
                                end
                            else
                                atext('Игрок '..wnick..' вышел из игры')
                            end
                        else
                            atext('Игрок '..wnick..' вышел из игры')
                        end
                    else
                        atext('Игрок '..wnick..' вышел из игры')
                    end
					checkstatdone = false
					warnst = false
					wbfrak = nil
					wbrang = nil
                    wnick = nil
                    wtime = nil
				end
			else
				atext('Игрок оффлайн')
			end
		else
			atext('Введите: /cheat [id]')
		end
	end)
end
function getTargetBlipCoordinatesFixed()
    local bool, x, y, z = getTargetBlipCoordinates(); if not bool then return false end
    requestCollision(x, y); loadScene(x, y, z)
    local bool, x, y, z = getTargetBlipCoordinates()
    return bool, x, y, z
end
function distance_cord(lat1, lon1, lat2, lon2)
	if lat1 == nil or lon1 == nil or lat2 == nil or lon2 == nil or lat1 == "" or lon1 == "" or lat2 == "" or lon2 == "" then
		return 0
	end
	local dlat = math.rad(lat2 - lat1)
	local dlon = math.rad(lon2 - lon1)
	local sin_dlat = math.sin(dlat / 2)
	local sin_dlon = math.sin(dlon / 2)
	local a =
		sin_dlat * sin_dlat + math.cos(math.rad(lat1)) * math.cos(
			math.rad(lat2)
		) * sin_dlon * sin_dlon
	local c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
	local d = 6378 * c
	return d
end
function cip2(pam)
    local rdata = {}
	if #ips2 == 2 then
		local jsonips = encodeJson(ips2)
		atext('Идет проверка IP адресов. Ожидайте..')
        httpRequest("http://ip-api.com/batch?fields=25305&lang=ru", { data = jsonips }, function(response, code, headers, status)
            if response then
                local rdata = decodeJson(u8:decode(response))
                if rdata[1]["status"] == "success" and rdata[2]["status"] == "success" then
                    local distances2 = distance_cord(rdata[1]["lat"], rdata[1]["lon"], rdata[2]["lat"], rdata[2]["lon"])
                    if tonumber(pam) == nil then
                        sampAddChatMessage((' Страна: {66FF00}%s{ffffff} | Город: {66FF00}%s{ffffff} | ISP: {66FF00}%s [R-IP: %s]'):format(rdata[1]["country"], rdata[1]["city"], rdata[1]["isp"], rdata[1]["query"]), -1)
                        sampAddChatMessage((' Страна: {66FF00}%s{ffffff} | Город:{66FF00} %s{ffffff} | ISP: {66FF00}%s [IP: %s]'):format(rdata[2]["country"], rdata[2]["city"], rdata[2]["isp"], rdata[2]["query"]), -1)
                        sampAddChatMessage((' Расстояние: {66FF00}%s {ffffff}км. | Ник: {66FF00}%s'):format(math.floor(distances2), rnick), -1)
                    else
                        sampSendChat(('/a Страна: %s | Город: %s | ISP: %s [R-IP: %s]'):format(rdata[1]["country"], rdata[1]["city"], rdata[1]["isp"], rdata[1]["query"]), -1)
                        wait(cfg.other.delay)
                        sampSendChat(('/a Страна: %s | Город: %s | ISP: %s [IP: %s]'):format(rdata[2]["country"], rdata[2]["city"], rdata[2]["isp"], rdata[2]["query"]), -1)
                        wait(cfg.other.delay)
                        sampSendChat(('/a Расстояние: %s км. | Ник: %s'):format(math.floor(distances2), rnick), -1)
                    end
                end
            else
                atext('Произошла ошибка проверки IP адресов')
            end
		end)
	else
		atext('Не найдено IP адресов для сравнения')
    end
    local rdata = {}
end
function cip(pam)
    local rdata = {}
    if #ips == 2 then
        atext('Идет проверка IP адресов. Ожидайте..')
        local site = "http://a0314415.xsph.ru/?ip1="..ips[1].."&ip2="..ips[2]
        httpRequest(site, _, function(response, code, headers, status)
            if response then
                local rdata = decodeJson(response)
                if rdata.ipone.success and rdata.iptwo.success then
                    local distances2 = distance_cord(rdata.ipone.latitude, rdata.ipone.longitude,rdata.iptwo.latitude, rdata.iptwo.longitude)
                    if tonumber(pam) == nil then
                        sampAddChatMessage((' Страна: {66FF00}%s{ffffff} | Город: {66FF00}%s{ffffff} | ISP: {66FF00}%s [R-IP: %s]'):format(u8:decode(rdata.ipone.country), u8:decode(rdata.ipone.city), u8:decode(rdata.ipone.isp), u8:decode(rdata.ipone.ip)), -1)
                        sampAddChatMessage((' Страна: {66FF00}%s{ffffff} | Город:{66FF00} %s{ffffff} | ISP: {66FF00}%s [IP: %s]'):format(u8:decode(rdata.iptwo.country), u8:decode(rdata.iptwo.city), u8:decode(rdata.iptwo.isp), u8:decode(rdata.iptwo.ip)), -1)
                        sampAddChatMessage((' Расстояние: {66FF00}%s {ffffff}км. | Ник: {66FF00}%s %s'):format(math.floor(distances2), rnick, sampGetPlayerIdByNickname(rnick) and '['..sampGetPlayerIdByNickname(rnick)..']' or ''), -1)
                    else
                        sampSendChat(('/a Страна: %s | Город: %s | ISP: %s [R-IP: %s]'):format(u8:decode(rdata.ipone.country), u8:decode(rdata.ipone.city), u8:decode(rdata.ipone.isp), u8:decode(rdata.ipone.ip)))
                        wait(cfg.other.delay)
                        sampSendChat(('/a Страна: %s | Город: %s | ISP: %s [IP: %s]'):format(u8:decode(rdata.iptwo.country), u8:decode(rdata.iptwo.city), u8:decode(rdata.iptwo.isp), u8:decode(rdata.iptwo.ip)))
                        wait(cfg.other.delay)
                        sampSendChat(('/a Расстояние: %s км. | Ник: %s %s'):format(math.floor(distances2), rnick, sampGetPlayerIdByNickname(rnick) and '['..sampGetPlayerIdByNickname(rnick)..']' or ''))
                    end
                else
                    atext('Произошла ошибка проверки IP адресов')
                end
            else
                atext('Произошла ошибка проверки IP адресов')
            end
        end)
    else
        atext('Не найдено IP адресов для сравнения')
    end
    local rdata = {}
end
function givehb(pam)
    lua_thread.create(function()
        local _, myid = sampGetPlayerIdByCharHandle(playerPed)
        local id, pack = pam:match('(%d+)%s+(.+)')
        if id and pack then
            if sampIsPlayerConnected(id) or tonumber(id) == myid then
                if doesFileExist('moonloader/Admin Tools/hblist/'..pack..'.txt') then
                    atext('Начата выдача объектов игроку {66FF00}'..sampGetPlayerNickname(id)..' ['..id..']')
                    for line in io.lines('moonloader/Admin Tools/hblist/'..pack..'.txt') do
                        sampSendChat('/hbject '..id..' '..line)
                        wait(cfg.other.delay)
                    end
                    atext('Выдача окончена')
                else
                    atext('Не обнаружено комплекта "'..pack..'"')
                end
            else
                atext('Игрок оффлайн')
            end
        else
            atext('Введите: /givehb [id] [имя комлекта]')
        end
    end)
end
function masshb(pam)
    lua_thread.create(function()
        local strp = sampGetStreamedPlayers()
        if #pam ~= 0 then
            if doesFileExist('moonloader/Admin Tools/hblist/'..pam..'.txt') then
                atext('Массовая выдача объектов начата')
                for k, v in pairs(strp) do
                    if sampIsPlayerConnected(v) then
                        atext('Начата выдача объектов игроку '..sampGetPlayerNickname(v)..' ['..v..']')
                        for line in io.lines('moonloader/Admin Tools/hblist/'..pam..'.txt') do
                            sampSendChat('/hbject '..v..' '..line)
                            wait(cfg.other.delay)
                        end
                        atext('Выдача объектов игроку '..sampGetPlayerNickname(v)..' ['..v..'] окончена')
                        wait(cfg.other.delay)
                    end
                end
                atext('Массовая выдача объектов окончена')
            else
                atext('Не обнаружено комплекта "'..pam..'"')
            end
        else
            atext('Введите: /masshb [имя комлекта]')
        end
    end)
end
function checkIntable(t, key)
    for k, v in pairs(t) do
        if v == key then return true end
    end
    return false
end
function masstp()
    lua_thread.create(function()
        masstpon = not masstpon
        smsids = {}
        atext(masstpon and 'Телепортация начата' or 'Телепортация окончена. Всего телепортировано: {66FF00}'..skoktp..'{ffffff} игроков')
        skoktp = 0
        if not masstpon then 
            wait(cfg.other.delay)
            sampSendChat('/togphone')
        else
            lua_thread.create(function()
                while true do wait(cfg.other.delay)
                    if not masstpon then return end
                    if #smsids > 0 then
                        sampSendChat('/gethere '..table.remove(smsids, 1))
                        skoktp = skoktp + 1
                    end    
                end
            end)
            while true do wait(0)
                if masstpon then
                    local smsx, smsy = convertGameScreenCoordsToWindowScreenCoords(242, 366)
                    renderFontDrawText(hudfont, 'Телепортация игроков. Осталось: {66FF00}'..#smsids..'\n{ffffff}Всего телепортировано: {66FF00}'..skoktp, smsx, smsy, -1)
                else return end
            end
        end    
    end)
end
function blog(pam)
    local id = tonumber(pam)
    if #pam ~= 0 then
        if id ~= nil then
            if sampIsPlayerConnected(id) then
                sampSendChat('/banlog '..sampGetPlayerNickname(id))
            else
                sampSendChat('/banlog ' ..id)
            end
        else
            sampSendChat('/banlog '..pam)
        end
    else
        atext('Введите: /blog [id/nick]')
    end
end
function arecon()
    lua_thread.create(function()
        local ip, port = sampGetCurrentServerAddress()
        sampDisconnectWithReason(quit)
        wait(200)
        sampConnectToServer(ip, port)
    end)
end
function pwarn(pam)
        local id, days, reason = pam:match('(%d+) (%d+) (.+)')
        if id and days and reason then
            if sampIsPlayerConnected(id) then
                if sampGetPlayerScore(id) < 3 then
                    sampSendChat(string.format("/warn %s %s %s", id, days, reason))
                else
                    if cfg.other.fracstat then
                        warnst = true
                        local wnick = sampGetPlayerNickname(id)
                        sampSendChat('/getstats '..id)
                        local wtime = os.clock() + 10
                        while not checkstatdone or wtime < os.clock() do wait(0) end
                        wait(cfg.other.delay)
                        if sampIsPlayerConnected(id) then
                            if sampGetPlayerNickname(id) ~= nil then
                                if sampGetPlayerNickname(id) == wnick then
                                    if wbstyle == 1 then
                                        if getRank(wbfrak, wbrang) ~= nil and getFrak(wbfrak) ~= nil then
                                            sampSendChat(string.format('/warn %s %s %s [%s/%s]', id, days, reason, getFrak(wbfrak), getRank(wbfrak, wbrang)))
                                        else
                                            sampSendChat(string.format('/warn %s %s %s', id, days, reason))
                                        end
                                    elseif wbstyle == 2 then
                                        if getFrak(wbfrak) ~= nil and wbfrak ~= 'Нет' then
                                            sampSendChat(string.format('/warn %s %s %s [%s/%s]', id, days, reason, getFrak(wbfrak), wbrang))
                                        else
                                            sampSendChat(string.format('/warn %s %s %s', id, days, reason))
                                        end
                                    end
                                else
                                    atext('Игрок '..wnick..' вышел из игры')
                                end
                            else
                                atext('Игрок '..wnick..' вышел из игры')
                            end
                        else
                            atext('Игрок '..wnick..' вышел из игры')
                        end
                    else
                        sampSendChat(string.format('/warn %s %s %s', id, days, reason))
                    end
                    checkstatdone = false
                    warnst = false
                    wbfrak = nil
                    wbrang = nil
                    wnick = nil
                    wtime = nil
                end
            else
                atext("Игрок оффлайн")
            end
        else
            atext('Введите: /warn [id] [дни] [причина]')
        end
end
function pban(pam)
        local id, reason = pam:match('(%d+) (.+)')
        if id and reason then
            if sampIsPlayerConnected(id) then
                if sampGetPlayerScore(id) < 3 then
                    sampSendChat(string.format('/ban %s %s', id, reason))
                else
                    if cfg.other.fracstat then
                        if not checkIntable(punishignor, reason) then
                            local wnick = sampGetPlayerNickname(id)
                            warnst = true
                            sampSendChat('/getstats '..id)
                            local wtime = os.clock() + 10
                            while not checkstatdone or wtime < os.clock() do wait(0) end
                            wait(cfg.other.delay)
                            if sampIsPlayerConnected(id) then
                                if sampGetPlayerNickname(id)~= nil then
                                    if sampGetPlayerNickname(id) == wnick then
                                        if wbstyle == 1 then
                                            if getRank(wbfrak, wbrang) ~= nil and getFrak(wbfrak) ~= nil then
                                                sampSendChat(string.format('/ban %s %s [%s/%s]', id, reason, getFrak(wbfrak), getRank(wbfrak, wbrang)))
                                            else
                                                sampSendChat(string.format('/ban %s %s', id, reason))
                                            end
                                        elseif wbstyle == 2 then
                                            if getFrak(wbfrak) ~= nil and wbfrak ~= 'Нет' then
                                                sampSendChat(string.format('/ban %s %s [%s/%s]', id, reason, getFrak(wbfrak), wbrang))
                                            else
                                                sampSendChat(string.format('/ban %s %s', id, reason))
                                            end
                                        end
                                    else
                                        atext('Игрок '..wnick..' вышел из игры')
                                    end
                                else
                                    atext('Игрок '..wnick..' вышел из игры')
                                end
                            else
                                atext('Игрок '..wnick..' вышел из игры')
                            end
                        else
                            sampSendChat(string.format('/ban %s %s', id, reason))
                        end
                        wnick = nil
                        checkstatdone = false
                        wbfrak = nil
                        wbrang = nil
                        warnst = false
                        wtime = nil
                    else
                        sampSendChat(string.format('/ban %s %s', id, reason))
                    end
                end
            else
                atext("Игрок оффлайн")
            end
        else
            atext('Введите: /ban [id] [причина]')
        end
end

function punish()
    lua_thread.create(function()
        if doesFileExist(os.getenv('TEMP')..'\\Punishment.txt') then
            atext('Выдача наказаний по жалобам начата')
            for line in io.lines(os.getenv('TEMP')..'\\Punishment.txt') do
                local type, nick, hour, reason = line:match("(.+) Ник: (.+) Количество %S+: (%d*) Причина: (.+)")
                if nick:match(".+%s$") then nick = nick:match("(.+)%s$") end
                local nick = nick:gsub(" ", '_')
                if sampGetPlayerIdByNickname(nick) ~= nil then
                    if type == "[W]" then pwarn(("%s %s %s"):format(sampGetPlayerIdByNickname(nick), hour, reason))
                    elseif type == "[B]" then pban(("%s %s"):format(sampGetPlayerIdByNickname(nick), reason))
                    elseif type == '[M]' then sampSendChat(('/mute %s %s %s'):format(sampGetPlayerIdByNickname(nick), hour, reason))
                    elseif type == '[P]' then sampSendChat(("/prison %s %s %s"):format(sampGetPlayerIdByNickname(nick), hour, reason))
                    elseif type == '[IB]' then sampSendChat(("/iban %s %s"):format(sampGetPlayerIdByNickname(nick), reason))
                    end
                else
                    if type == '[W]' then sampSendChat(("/offwarn %s %s %s"):format(nick, hour, reason))
                    elseif type == '[B]' then sampSendChat(("/offban %s %s"):format(nick, reason))
                    elseif type == '[M]' then sampSendChat(("/offmute %s %s %s"):format(nick, reason:gsub(" ", '_'), hour))
                    elseif type == '[P]' then sampSendChat(("/offprison %s %s %s"):format(nick, reason:gsub(" ", '_'), hour))
                    elseif type == '[IB]' then sampSendChat(("/ioffban %s %s"):format(nick, reason))
                    end
                end
                wait(cfg.other.delay)
            end
            atext('Выдача наказаний по жалобам окончена')
            local pfile = io.open('moonloader/Admin Tools/punishjb.txt', 'a')
            pfile:write('\n')
            pfile:write(os.date()..'\n')
            for line in io.lines(os.getenv('TEMP')..'\\Punishment.txt') do
                pfile:write(line..'\n')
            end
            pfile:close()
            local ppfile = io.open(os.getenv('TEMP')..'\\Punishment.txt', 'w')
            ppfile:close()
        end
    end)
end

function punishlog(text)
    local triggers = {'OffBan', "забанил (.+) Причина", 'SBan', 'IOffBan', 'выдал warn', "получил предупреждение до", "кикнул .+ Причина", "поместил в ДеМорган", "посажен в prison", "заблокировал чат игрока", "OffMute", "забанил IP", "выдал затычку на репорт", "Вы посадили .+ в тюрьму"}
    local mynick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
    if text:find(mynick) then
        for k, v in pairs(triggers) do
            if text:match(v) then
                local time = localTime()
                local file = io.open('moonloader/Admin Tools/punishlogs.txt', 'a')
                file:write(('[%s || %s] %s\n'):format(os.date('%d.%m.%Y'), ("%s:%s:%s.%s"):format(time.wHour, time.wMinute, time.wSecond, time.wMilliseconds), text))
                file:close()
            end
        end
    end
end

function getlvl(pam)
    lua_thread.create(function()
        local t = {}
        local cid = tonumber(pam)
        if cid ~= nil then
            for i = 0, 999 do
                if sampIsPlayerConnected(i) then
                    if sampGetPlayerScore(i) == cid then
                        table.insert(t, ('%s [%s]'):format(sampGetPlayerNickname(i), i))
                    end
                end
            end
            sampShowDialog(2131, '{ffffff}Игроки с уровнем: {66FF00}'..cid, table.concat(t, '\n'), '»', 'x', 2)
            while sampIsDialogActive(2131) do wait(0) end
            local result, button, list, input = sampHasDialogRespond(2131)
            if result and button ==  1 then
                local text = sampGetListboxItemText(list)
                local id = text:match("(%S+) %[(%d+)%]")
                sampSendChat(("/re %s"):format(id))
            end
        else
            atext('Введите: /getlvl [уровень]')
        end
    end)
end
function hblist()
    local lfs = require 'lfs'
    local hlist = {}
    for line in lfs.dir('moonloader/Admin Tools/hblist') do
        if line:match('.+.txt') then
            table.insert(hlist, line)
        end
    end
    sampShowDialog(3213,'Список объектов',table.concat(hlist, "\n"),'x',_,2)
end
function admchecker()
    if not doesFileExist('moonloader/config/Admin Tools/adminlist.txt') then io.open('moonloader/config/Admin Tools/adminlist.txt', 'w'):close() end
    if not doesFileExist('moonloader/config/Admin Tools/playerlist.txt') then io.open('moonloader/config/Admin Tools/playerlist.txt', 'w'):close() end
    if not doesFileExist('moonloader/config/Admin Tools/admchecker.json') then
        local file = io.open('moonloader/config/Admin Tools/admchecker.json', 'w')
        file:close()
    else
        local f = io.open('moonloader/config/Admin Tools/admchecker.json', 'r')
        if f then
            admins = decodeJson(f:read('*a'))
            f:close()
        end
    end
    for line in io.lines('moonloader/config/Admin Tools/adminlist.txt') do
        table.insert(admins, {
            nick = line,
            color = 'ffffff',
            text = ''
        })
    end
    if not doesFileExist('moonloader/config/Admin Tools/playerchecker.json') then
        local file = io.open('moonloader/config/Admin Tools/playerchecker.json', 'w')
        file:close()
    else
        local f = io.open('moonloader/config/Admin Tools/playerchecker.json', 'r')
        if f then
            players = decodeJson(f:read('*a'))
            f:close()
        end
    end
    for line in io.lines('moonloader/config/Admin Tools/playerlist.txt') do
        table.insert(players, {
            nick = line,
            color = 'ffffff',
            text = ''
        })
    end
    if not doesFileExist('moonloader/config/Admin Tools/leaders.json') then
        local file = io.open('moonloader/config/Admin Tools/leaders.json', 'w')
        file:close()
    else
        local file = io.open('moonloader/config/Admin Tools/leaders.json', 'r')
        if file then
            local info = file:read("*a")
            if not info:match('Mongols MC') then info = info:gsub("Mongols", "Mongols MC") end
            if not info:match('Pagans MC') then info = info:gsub("Pagans", "Pagans MC") end
            if not info:match('Warlocks MC') then info = info:gsub("Warlocks", "Warlocks MC") end
            leaders = decodeJson(info)
            file:close()
        end
    end
    saveData(leaders, 'moonloader/config/Admin Tools/leaders.json')
    saveData(admins, 'moonloader/config/Admin Tools/admchecker.json')
    saveData(players, 'moonloader/config/Admin Tools/playerchecker.json')
    io.open('moonloader/config/Admin Tools/adminlist.txt', 'w'):close()
    io.open('moonloader/config/Admin Tools/playerlist.txt', 'w'):close()
end

function addplayer(pam)
    if pam:match("^%s*(%d+)%s*(%S*)%s*(.*)") then
        local id, color, text = pam:match("(%d+)%s*(%S*)%s*(.*)")
        if not isHex(color) then 
            text = color..' '..text
            color = 'FFFFFF'
        end
        if sampIsPlayerConnected(id) then
            local nick = sampGetPlayerNickname(id)
            local result, key = checkInTableChecker(players, nick)
            if result then
                players[key] = {
                    nick = nick,
                    color = color,
                    text = text
                }
                atext("Информация обновлена")
            else
                table.insert(players,{nick = nick, color = color, text = text})
                atext(("Игрок {66FF00}%s [%s]{ffffff} добавлен в чекер игроков"):format(nick, id))
            end
        else
            local result, key = checkInTableChecker(players, id)
            if result then
                if #text > 0 then
                    players[key] = {
                        nick = nick,
                        color = color,
                        text = text
                    }
                else
                    players[key] = {
                        nick = nick,
                        color = color
                    }
                end
                atext("Информация обновлена")
            else
                table.insert(players,{nick = id, color = color, text = text})
                atext(("Игрок {66FF00}%s{ffffff} добавлен в чекер игроков"):format(id))
            end
        end
    elseif pam:match("^%s*(%S+)%s*(%S*)%s*(.*)") then
        local nick, color, text = pam:match("(%S+)%s*(%S*)%s*(.*)")
        local id = sampGetPlayerIdByNickname(nick)
        if not isHex(color) then 
            text = color..' '..text
            color = 'FFFFFF'
        end
        if id ~= nil then
            local result, key = checkInTableChecker(players, nick)
            if result then
                if #text > 0 then
                    players[key] = {
                        nick = nick,
                        color = color,
                        text = text
                    }
                else
                    players[key] = {
                        nick = nick,
                        color = color
                    }
                end
                atext("Информация обновлена")
            else
                table.insert(players,{nick = nick, color = color, text = text})
                atext(("Игрок {66FF00}%s [%s]{ffffff} добавлен в чекер игроков"):format(nick, id))
            end
        else
            local result, key = checkInTableChecker(players, nick)
            if result then
                players[key] = {
                    nick = nick,
                    color = color,
                    text = text
                }
                atext("Информация обновлена")
            else
                table.insert(players,{nick = nick, color = color, text = text})
                atext(("Игрок {66FF00}%s{ffffff} добавлен в чекер игроков"):format(nick))
            end
        end
    else
        atext('Введите: /addplayer [id/nick] [color(Пример: ffffff)/-1] [примечание]')
    end
    zapolncheck()
    saveData(players, 'moonloader/config/Admin Tools/playerchecker.json')
end
function addadm(pam)
    if pam:match("^%s*(%d+)%s*(%S*)%s*(.*)") then
        local id, color, text = pam:match("(%d+)%s*(%S*)%s*(.*)")
        if not isHex(color) then 
            text = color..' '..text
            color = 'FFFFFF'
        end
        if sampIsPlayerConnected(id) then
            local nick = sampGetPlayerNickname(id)
            local result, key = checkInTableChecker(admins, nick)
            if result then
                if #text > 0 then
                    admins[key] = {
                        nick = nick,
                        color = color,
                        text = text
                    }
                else
                    admins[key] = {
                        nick = nick,
                        color = color
                    }
                end
                atext("Информация обновлена")
            else
                table.insert(admins,{nick = nick, color = color, text = text})
                atext(("Игрок {66FF00}%s [%s]{ffffff} добавлен в чекер админов"):format(nick, id))
            end
        else
            local result, key = checkInTableChecker(admins, id)
            if result then
                if #text > 0 then
                    admins[key] = {
                        nick = id,
                        color = color,
                        text = text
                    }
                else
                    admins[key] = {
                        nick = id,
                        color = color
                    }
                end
                atext("Информация обновлена")
            else
                table.insert(admins,{nick = id, color = color, text = text})
                atext(("Игрок {66FF00}%s{ffffff} добавлен в чекер админов"):format(id))
            end
        end
    elseif pam:match("^%s*(%S+)%s*(%S*)%s*(.*)") then
        local nick, color, text = pam:match("(%S+)%s*(%S*)%s*(.*)")
        if not isHex(color) then 
            text = color..' '..text
            color = 'FFFFFF'
        end
        local id = sampGetPlayerIdByNickname(nick)
        if id ~= nil then
            local result, key = checkInTableChecker(admins, nick)
            if result then
                admins[key] = {
                    nick = nick,
                    color = color,
                    text = text
                }
                atext("Информация обновлена")
            else
                table.insert(admins,{nick = nick, color = color, text = text})
                atext(("Игрок {66FF00}%s [%s]{ffffff} добавлен в чекер админов"):format(nick, id))
            end
        else
            local result, key = checkInTableChecker(admins, nick)
            if result then
                admins[key] = {
                    nick = nick,
                    color = color,
                    text = text
                }
                atext("Информация обновлена")
            else
                table.insert(admins,{nick = nick, color = color, text = text})
                atext(("Игрок {66FF00}%s{ffffff} добавлен в чекер админов"):format(nick))
            end
        end
    else
        atext('Введите: /addadm [id/nick] [color(Пример: ffffff)/-1] [примечание]')
    end
    zapolncheck()
    saveData(admins, 'moonloader/config/Admin Tools/admchecker.json')
end
function deladm(pam)
    if pam:match("^(%d+)") then
        local id = pam:match("^(%d+)")
        if sampIsPlayerConnected(id) or tonumber(id) == select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) then
            local nick = sampGetPlayerNickname(id)
            local result, key = checkInTableChecker(admins, nick)
            if result then
                table.remove(admins, key)
                atext(("Игрок {66FF00}%s [%s]{ffffff} удален из чекера админов"):format(nick, id))
            else
                atext(("Игрок {66FF00}%s [%s]{ffffff} не найден в чекере админов"):format(nick, id))
            end
        else
            local result, key = checkInTableChecker(admins, id)
            if result then
                table.remove(admins, key)
                atext(("Игрок {66FF00}%s{ffffff} удален из чекера админов"):format(id))
            else
                atext(("Игрок {66FF00}%s{ffffff} не найден в чекере админов"):format(id))
            end
        end
    elseif pam:match("^(%S+)") then
        local nick = pam:match("^(%S+)")
        local id = sampGetPlayerIdByNickname(nick)
        if id ~= nil then
            local result, key = checkInTableChecker(admins, nick)
            if result then
                table.remove(admins, key)
                atext(("Игрок {66FF00}%s [%s]{ffffff} удален из чекера админов"):format(nick, id))
            else
                atext(("Игрок {66FF00}%s [%s]{ffffff} не найден в чекере админов"):format(nick, id))
            end
        else
            local result, key = checkInTableChecker(admins, nick)
            if result then
                table.remove(admins, key)
                atext(("Игрок {66FF00}%s{ffffff} удален из чекера админов"):format(nick))
            else
                atext(("Игрок {66FF00}%s{ffffff} не найден в чекере админов"):format(nick))
            end
        end
    else
        atext('Введите: /deladm [id/nick]')
    end
    zapolncheck()
    saveData(admins, 'moonloader/config/Admin Tools/admchecker.json')
end
function delplayer(pam)
    if pam:match("^(%d+)") then
        local id = pam:match("^(%d+)")
        if sampIsPlayerConnected(id) or tonumber(id) == select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) then
            local nick = sampGetPlayerNickname(id)
            local result, key = checkInTableChecker(players, nick)
            if result then
                table.remove(players, key)
                atext(("Игрок {66FF00}%s [%s]{ffffff} удален из чекера игроков"):format(nick, id))
            else
                atext(("Игрок {66FF00}%s [%s]{ffffff} не найден в чекере игроков"):format(nick, id))
            end
        else
            local result, key = checkInTableChecker(players, id)
            if result then
                table.remove(players, key)
                atext(("Игрок {66FF00}%s{ffffff} удален из чекера игроков"):format(id))
            else
                atext(("Игрок {66FF00}%s{ffffff} не найден в чекере игроков"):format(id))
            end
        end
    elseif pam:match("^(%S+)") then
        local nick = pam:match("^(%S+)")
        local id = sampGetPlayerIdByNickname(nick)
        if id ~= nil then
            local result, key = checkInTableChecker(players, nick)
            if result then
                table.remove(players, key)
                atext(("Игрок {66FF00}%s [%s]{ffffff} удален из чекера игроков"):format(nick, id))
            else
                atext(("Игрок {66FF00}%s [%s]{ffffff} не найден в чекере игроков"):format(nick, id))
            end
        else
            local result, key = checkInTableChecker(players, nick)
            if result then
                table.remove(players, key)
                atext(("Игрок {66FF00}%s{ffffff} удален из чекера игроков"):format(nick))
            else
                atext(("Игрок {66FF00}%s{ffffff} не найден в чекере игроков"):format(nick))
            end
        end
    else
        atext('Введите: /delplayer [id/nick]')
    end
    zapolncheck()
    saveData(players, 'moonloader/config/Admin Tools/playerchecker.json')
end
function addtemp(pam)
    if pam:match("^%s*(%d+)%s*(%S*)%s*(.*)") then
        local id, color, text = pam:match("(%d+)%s*(%S*)%s*(.*)")
        if not isHex(color) then 
            text = color..' '..text
            color = 'FFFFFF'
        end
        if sampIsPlayerConnected(id) then
            local nick = sampGetPlayerNickname(id)
            local result, key = checkInTableChecker(temp_checker, nick)
            if result then
                if #text > 0 then
                    temp_checker[key] = {
                        nick = nick,
                        color = color,
                        text = text
                    }
                else
                    temp_checker[key] = {
                        nick = nick,
                        color = color
                    }
                end
                atext("Информация обновлена")
            else
                table.insert(temp_checker,{nick = nick, color = color, text = text})
                atext(("Игрок {66FF00}%s [%s]{ffffff} добавлен в временный чекер"):format(nick, id))
            end
        else
            local result, key = checkInTableChecker(temp_checker, id)
            if result then
                if #text > 0 then
                    temp_checker[key] = {
                        nick = id,
                        color = color,
                        text = text
                    }
                else
                    temp_checker[key] = {
                        nick = nick,
                        color = color
                    }
                end
                atext("Информация обновлена")
            else
                table.insert(temp_checker,{nick = id, color = color, text = text})
                atext(("Игрок {66FF00}%s{ffffff} добавлен в временный чекер"):format(id))
            end
        end
    elseif pam:match("^%s*(%S+)%s*(%S*)%s*(.*)") then
        local nick, color, text = pam:match("(%S+)%s*(%S*)%s*(.*)")
        local id = sampGetPlayerIdByNickname(nick)
        if not isHex(color) then 
            text = color..' '..text
            color = 'FFFFFF'
        end
        if id ~= nil then
            local result, key = checkInTableChecker(temp_checker, nick)
            if result then
                if #text > 0 then
                    temp_checker[key] = {
                        nick = nick,
                        color = color,
                        text = text
                    }
                else
                    temp_checker[key] = {
                        nick = nick,
                        color = color
                    }
                end
                atext("Информация обновлена")
            else
                table.insert(temp_checker,{nick = nick, color = color, text = text})
                atext(("Игрок {66FF00}%s [%s]{ffffff} добавлен в временный чекер"):format(nick, id))
            end
        else
            local result, key = checkInTableChecker(temp_checker, nick)
            if result then
                if #text > 0 then
                    temp_checker[key] = {
                        nick = nick,
                        color = color,
                        text = text
                    }
                else
                    temp_checker[key] = {
                        nick = nick,
                        color = color
                    }
                end
                atext("Информация обновлена")
            else
                table.insert(temp_checker,{nick = nick, color = color, text = text})
                atext(("Игрок {66FF00}%s{ffffff} добавлен в временный чекер"):format(nick))
            end
        end
    else
        atext('Введите: /addtemp [id/nick] [color(Пример: ffffff)/-1] [примечание]')
    end
    zapolncheck()
end
function deltemp(pam)
    if pam:match("^(%d+)") then
        local id = pam:match("^(%d+)")
        if sampIsPlayerConnected(id) or tonumber(id) == select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) then
            local nick = sampGetPlayerNickname(id)
            local result, key = checkInTableChecker(temp_checker, nick)
            if result then
                table.remove(temp_checker, key)
                atext(("Игрок {66FF00}%s [%s]{ffffff} удален из временного чекера"):format(nick, id))
            else
                atext(("Игрок {66FF00}%s [%s]{ffffff} не найден в временном чекере"):format(nick, id))
            end
        else
            local result, key = checkInTableChecker(temp_checker, id)
            if result then
                table.remove(temp_checker, key)
                atext(("Игрок {66FF00}%s{ffffff} удален из временного чекера"):format(id))
            else
                atext(("Игрок {66FF00}%s{ffffff} не найден в временном чекере"):format(id))
            end
        end
    elseif pam:match("^(%S+)") then
        local nick = pam:match("^(%S+)")
        local id = sampGetPlayerIdByNickname(nick)
        if id ~= nil then
            local result, key = checkInTableChecker(temp_checker, nick)
            if result then
                table.remove(temp_checker, key)
                atext(("Игрок {66FF00}%s [%s]{ffffff} удален из временного чекера"):format(nick, id))
            else
                atext(("Игрок {66FF00}%s [%s]{ffffff} не найден в временном чекере"):format(nick, id))
            end
        else
            local result, key = checkInTableChecker(temp_checker, nick)
            if result then
                table.remove(temp_checker, key)
                atext(("Игрок {66FF00}%s{ffffff} удален из временного чекера"):format(nick))
            else
                atext(("Игрок {66FF00}%s{ffffff} не найден в временном чекере"):format(nick))
            end
        end
    else
        atext('Введите: /deltemp [id/nick]')
    end
    zapolncheck()
end
function admchat()
    while true do wait(0)
        local wtext, wprefix, wcolor, wpcolor = sampGetChatString(99)
        local mynick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
        local w1color = ("%06X"):format(bit.band(wcolor, 0xFFFFFF))
        if string.rlower(w1color) == string.match(bit.tohex(config_colors.admchat.color), '00(.+)') and wtext:match('^ <ADM%-CHAT> .+ %[%d+%]: .+') then
            local nick, id, text = wtext:match('^ <ADM%-CHAT> (.+) %[(%d+)%]: (.+)')
            if cfg.other.admlvl > 1 and nick ~= mynick then
                if text:match('^re %d+') or text:match('^/re %d+') then
                    if sampIsPlayerConnected(tonumber(text:match('re (%d+)'))) then
                        if not checkIntable(adminslist, sampGetPlayerNickname(tonumber(text:match('re (%d+)')))) then
                            punkey.re.id = text:match('re (%d+)')
                            punkey.re.nick = nick
                            atext(('Администратор %s [%s] просит зайти в слежку за игроком %s [%s]'):format(nick, id, sampGetPlayerNickname(punkey.re.id), punkey.re.id))
                            atext(("Нажмите {66FF00}%s{FFFFFF} для подтверждения или {66FF00}%s{ffffff} для отмены"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + "), table.concat(rkeys.getKeysName(config_keys.pundeny.v), " + ")))
                        end
                    end
                end
                if text:match('^warn %d+ %d+ .+') or text:match('^/warn %d+ %d+ .+') then
                    if sampIsPlayerConnected(tonumber(text:match('warn (%d+) %d+ .+'))) then
                        if not checkIntable(adminslist, sampGetPlayerNickname(tonumber(text:match('warn (%d+) %d+ .+')))) then
                            punkey.warn.id, punkey.warn.day, punkey.warn.reason = text:match('warn (%d+) (%d+) (.+)')
                            punkey.warn.admin = nick
                            atext(("Администратор %s [%s] хочет заварнить игрока %s [%s] по причине: %s"):format(nick, id, sampGetPlayerNickname(punkey.warn.id), punkey.warn.id, punkey.warn.reason))
                            atext(("Нажмите {66FF00}%s{FFFFFF} для подтверждения или {66FF00}%s{ffffff} для отмены"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + "), table.concat(rkeys.getKeysName(config_keys.pundeny.v), " + ")))
                        end
                    end
                end
                if text:match('^ban %d+ .+') or text:match('^/ban %d+ .+') then
                    if sampIsPlayerConnected(tonumber(text:match('ban (%d+) .+'))) then
                        if not checkIntable(adminslist, sampGetPlayerNickname(tonumber(text:match('ban (%d+) .+')))) then
                            punkey.ban.id, punkey.ban.reason = text:match('ban (%d+) (.+)')
                            punkey.ban.admin = nick
                            atext(("Администратор %s [%s] хочет забанить игрока %s [%s] по причине: %s"):format(nick, id, sampGetPlayerNickname(punkey.ban.id), punkey.ban.id, punkey.ban.reason))
                            atext(("Нажмите {66FF00}%s{FFFFFF} для подтверждения или {66FF00}%s{ffffff} для отмены"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + "), table.concat(rkeys.getKeysName(config_keys.pundeny.v), " + ")))
                        end
                    end
                end
                if text:match('^prison %d+ %d+ .+') or text:match('^/prison %d+ %d+ .+') then
                    if sampIsPlayerConnected(tonumber(text:match('prison (%d+) %d+ .+'))) then
                        if not checkIntable(adminslist, sampGetPlayerNickname(tonumber(text:match('prison (%d+) %d+ .+')))) then
                            punkey.prison.id, punkey.prison.day, punkey.prison.reason = text:match('prison (%d+) (%d+) (.+)')
                            punkey.prison.admin = nick
                            atext(("Администратор %s [%s] хочет посадить в присон игрока %s [%s] по причине: %s"):format(nick, id, sampGetPlayerNickname(punkey.prison.id), punkey.prison.id, punkey.prison.reason))
                            atext(("Нажмите {66FF00}%s{FFFFFF} для подтверждения или {66FF00}%s{ffffff} для отмены"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + "), table.concat(rkeys.getKeysName(config_keys.pundeny.v), " + ")))
                        end
                    end
                end
                if text:match('^pspawn %d+') or text:match('^/pspawn %d+') then
                    if sampIsPlayerConnected(tonumber(text:match('pspawn (%d+)'))) then
                        punkey.pspawn.id = text:match('pspawn (%d+)')
                        punkey.pspawn.admin = nick
                        atext(("Администратор %s [%s] хочет заспавнить игрока %s [%s]"):format(nick, id, sampGetPlayerNickname(punkey.pspawn.id), punkey.pspawn.id))
                        atext(("Нажмите {66FF00}%s{FFFFFF} для подтверждения или {66FF00}%s{ffffff} для отмены"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + "), table.concat(rkeys.getKeysName(config_keys.pundeny.v), " + ")))
                    end
                end
                if cfg.other.admlvl >= 4 then
                    if text:match('^auninvite %d+ .+') or text:match('^/auninvite %d+ .+') then
                        if sampIsPlayerConnected(tonumber(text:match('auninvite (%d+) .+'))) then
                            punkey.auninvite.id, punkey.auninvite.reason = text:match('auninvite (%d+) (.+)')
                            punkey.auninvite.admin = nick
                            atext(("Администратор %s [%s] хочет уволить игрока %s [%s] по причине: %s"):format(nick, id, sampGetPlayerNickname(punkey.auninvite.id), punkey.auninvite.id, punkey.auninvite.reason))
                            atext(("Нажмите {66FF00}%s{FFFFFF} для подтверждения или {66FF00}%s{ffffff} для отмены"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + "), table.concat(rkeys.getKeysName(config_keys.pundeny.v), " + ")))
                        end
                    end
                    if text:match('^sban %d+ .+') or text:match('^/sban %d+ .+') then
                        if sampIsPlayerConnected(tonumber(text:match('sban (%d+) .+'))) then
                            if not checkIntable(adminslist, sampGetPlayerNickname(tonumber(text:match('sban (%d+) .+')))) then
                                punkey.sban.id, punkey.sban.reason = text:match('sban (%d+) (.+)')
                                punkey.sban.admin = nick
                                atext(("Администратор %s [%s] хочет тихо забанить игрока %s [%s] по причине: %s"):format(nick, id, sampGetPlayerNickname(punkey.sban.id), punkey.sban.id, punkey.sban.reason))
                                atext(("Нажмите {66FF00}%s{FFFFFF} для подтверждения или {66FF00}%s{ffffff} для отмены"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + "), table.concat(rkeys.getKeysName(config_keys.pundeny.v), " + ")))
                            end
                        end
                    end
                end
            end
        end
    end
end
function punaccept()
    if punkey.pspawn.id then
        sampSendChat(("/pspawn %s"):format(punkey.pspawn.id))
        punkey.pspawn.id, punkey.pspawn.nick = nil, nil
    end
    if punkey.re.id then
        sampSendChat(('/re %s'):format(punkey.re.id))
        punkey.re.id, punkey.re.nick = nil, nil
    end
    if punkey.prison.id then
        local admnick, admfam = punkey.prison.admin:match('(.+)_(.+)')
        sampSendChat(('/prison %s %s %s • %s.%s'):format(punkey.prison.id, punkey.prison.day, punkey.prison.reason, admnick:sub(1,1), admfam))
        punkey.prison.id, punkey.prison.day, punkey.prison.reason, punkey.prison.admin = nil, nil, nil, nil
    end
    if punkey.warn.id then
        local admnick, admfam = punkey.warn.admin:match('(.+)_(.+)')
        warn(('%s %s %s • %s.%s'):format(punkey.warn.id, punkey.warn.day, punkey.warn.reason, admnick:sub(1,1), admfam))
        punkey.warn.id, punkey.warn.day, punkey.warn.reason, punkey.warn.admin = nil, nil, nil, nil
    end
    if punkey.ban.id then
        local admnick, admfam = punkey.ban.admin:match('(.+)_(.+)')
        ban(('%s %s • %s.%s'):format(punkey.ban.id, punkey.ban.reason, admnick:sub(1,1), admfam))
        punkey.ban.id, punkey.ban.reason, punkey.ban.admin = nil, nil, nil
    end
    if punkey.sban.id then
        local admnick, admfam = punkey.sban.admin:match('(.+)_(.+)')
        sampSendChat(('/sban %s %s • %s.%s'):format(punkey.sban.id, punkey.sban.reason, admnick:sub(1,1), admfam))
        punkey.sban.id, punkey.sban.reason, punkey.sban.admin = nil, nil, nil
    end
    if punkey.auninvite.id then
        local admnick, admfam = punkey.auninvite.admin:match('(.+)_(.+)')
        sampSendChat(('/auninvite %s %s • %s.%s'):format(punkey.auninvite.id, punkey.auninvite.reason, admnick:sub(1,1), admfam))
        punkey.auninvite.id, punkey.auninvite.reason, punkey.auninvite.admin = nil, nil, nil
    end
end
function pundeny()
    if punkey.re.id or punkey.warn.id or punkey.ban.id or punkey.prison.id or punkey.auninvite.id or punkey.sban.id then
        punkey = {
            warn = {
                id = nil,
                day = nil,
                reason = nil,
                admin = nil
            },
            ban = {
                id = nil,
                reason = nil,
                admin = nil
            },
            prison = {
                id = nil,
                day = nil,
                reason = nil,
                admin = nil
            },
            re = {
                id = nil,
                admin = nil
            },
            sban = {
                id = nil,
                reason = nil,
                admin = nil 
            },
            auninvite = {
                id = nil,
                reason = nil,
                admin = nil
            },
            pspawn = {
                id = nil,
                nick = nil
            }
        }
        atext('Выдача наказаний отменена')
    end
end
function whon()
    while true do wait(0)
        if sampGetGamestate() ~= 3 then
            while not sampIsLocalPlayerSpawned() do wait(0) end
            nameTagOff()
        end
    end
end
function whkey()
    if nameTag then nameTagOff() else nameTagOn() end
end
function skeletwh()
    cfg.other.skeletwh = not cfg.other.skeletwh
    saveData(cfg, 'moonloader/config/Admin Tools/config.json')
end

function vehs(pam)
    local vtext = ''
    if #pam == 0 then 
        for k, v in pairs(tCarsName) do
            vtext = ("%s%s\t%s\n"):format(vtext, 399+k, v)
        end
        sampShowDialog(323211,"{FFFFFF}ID Машин","{ffffff}ID\t{fffffF}Название\n"..vtext,'x',_,5)
        atext("Введите: /vehs [название]")
    else
        for k, v in pairs(tCarsName) do
            if string.rlower(v):find(string.rlower(pam)) then
                atext(("[%s] %s"):format(399+k, v))
            end
        end
    end
end
function veh(pam)
    if pam:match("^(%d+) (%d+) (%d+)") then
        local id, color1, color2 = pam:match("^(%d+) (%d+) (%d+)")
        sampSendChat(('/veh %s %s %s'):format(id, color1, color2))
    elseif pam:match("^(%S+) (%d+) (%d+)") then
        local name, color1, color2 = pam:match("^(%S+) (%d+) (%d+)")
        for k, v in pairs(tCarsName) do
            if string.rlower(v):find(string.rlower(name)) then
                local id = 399+k
                sampSendChat(("/veh %s %s %s"):format(id, color1, color2))
                break
            end
        end
    elseif pam:match("^(%d+)") then
        local id = pam:match("^(%d+)")
        sampSendChat(('/veh %s 1 1'):format(id))
    elseif pam:match("^(%S+)") then
        local name = pam:match("^(%S+)")
        for k, v in pairs(tCarsName) do
            if string.rlower(v):find(string.rlower(name)) then
                local id = 399+k
                sampSendChat(('/veh %s 1 1'):format(id))
                break
            end
        end
    elseif #pam == 0 or not pam:match("^(%d+) (%d+) (%d+)") or not pam:match("^(%S+) (%d+) (%d+)") or not pam:match("^(%d+)") or not pam:match("^(%S+)") then
        atext("Введите: /veh [id/название] [цвет1(не обязательно)] [цвет2(не обязательно)]")
    end
end
function ml(pam)
    if pam:match("^(%d+) (%d+)") then
        local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        local id, frak = pam:match("^(%d+) (%d+)")
        if sampIsPlayerConnected(id) or tonumber(id) == myid then
            sampSendChat(('/makeleader %s %s'):format(id, frak))
        else
            atext('Игрок оффлайн')
        end
    elseif pam:match("^(%d+)") then
        local id = pam:match("^(%d+)")
        local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        if sampIsPlayerConnected(id) or tonumber(id) == myid then
            lua_thread.create(function()
                sampShowDialog(23145,("{ffffff}Выдача лидерки игроку: {66FF00}%s [%s]"):format(sampGetPlayerNickname(tonumber(id)), id),'LSPD\nFBI\nSFA\nLCN\nYakuza\nMayor\nSFN\nSFPD\nInstructors\nBallas\nVagos\nRM\nGrove\nLSN\nAztec\nRifa\nLVA\nLVN\nLVPD\nHospital\nMongols\nWarlocks\nPagans','»','x',2)
                while sampIsDialogActive(23145) do wait(0) end
                local result, button, list, text = sampHasDialogRespond(23145)
                if result then
                    if button == 1 then
                        if list == 0 then
                            sampSendChat(("/makeleader %s 1"):format(id))
                        elseif list == 1 then
                            sampSendChat(("/makeleader %s 2"):format(id))
                        elseif list == 2 then
                            sampSendChat(("/makeleader %s 3"):format(id))
                        elseif list == 3 then
                            sampSendChat(("/makeleader %s 5"):format(id))
                        elseif list == 4 then
                            sampSendChat(("/makeleader %s 6"):format(id))
                        elseif list == 5 then
                            sampSendChat(("/makeleader %s 7"):format(id))
                        elseif list == 6 then
                            sampSendChat(("/makeleader %s 9"):format(id))
                        elseif list == 7 then
                            sampSendChat(("/makeleader %s 10"):format(id))
                        elseif list == 8 then
                            sampSendChat(("/makeleader %s 11"):format(id))
                        elseif list == 9 then
                            sampSendChat(("/makeleader %s 12"):format(id))
                        elseif list == 10 then
                            sampSendChat(("/makeleader %s 13"):format(id))
                        elseif list == 11 then
                            sampSendChat(("/makeleader %s 14"):format(id))
                        elseif list == 12 then 
                            sampSendChat(("/makeleader %s 15"):format(id))
                        elseif list == 13 then
                            sampSendChat(("/makeleader %s 16"):format(id))
                        elseif list == 14 then
                            sampSendChat(("/makeleader %s 17"):format(id))
                        elseif list == 15 then
                            sampSendChat(("/makeleader %s 18"):format(id))
                        elseif list == 16 then
                            sampSendChat(("/makeleader %s 19"):format(id))
                        elseif list == 17 then
                            sampSendChat(("/makeleader %s 20"):format(id))
                        elseif list == 18 then
                            sampSendChat(("/makeleader %s 21"):format(id))
                        elseif list == 19 then
                            sampSendChat(("/makeleader %s 22"):format(id))
                        elseif list == 20 then
                            sampSendChat(("/makeleader %s 24"):format(id))
                        elseif list == 21 then
                            sampSendChat(("/makeleader %s 26"):format(id))
                        elseif list == 22 then
                            sampSendChat(("/makeleader %s 29"):format(id))
                        end
                    end
                end
            end)
        else
            atext('Игрок оффлайн')
        end
    elseif #pam == 0 or not pam:match("^(%d+) (%d+)") or not pam:match("^(%d+)") then
        atext('Введите: /ml [id] [id фракции(не обязательно)]')
    end
end
function gip(pam)
    local id = tonumber(pam)
    if #pam ~= 0 then
        if id ~= nil then
            if sampIsPlayerConnected(id) or id == select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) then
                sampSendChat('/getip '..sampGetPlayerNickname(id))
            else
                sampSendChat('/agetip ' ..id)
            end
        else
            local gid = sampGetPlayerIdByNickname(pam)
            if gid ~= nil then
                sampSendChat('/getip '..gid)
            else
                sampSendChat('/agetip '..pam)
            end
        end
    else
        atext('Введите: /gip [id/nick]')
    end
end

function aunv(pam)
    local id, reason = pam:match("(%d+) (.+)")
    if id and reason then
        if sampIsPlayerConnected(tonumber(id)) or tonumber(id) == select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) then
            sampSendChat(("/auninvite %s %s"):format(id, reason))
            print('уволил')
        else
            atext("Игрок оффлайн")
        end
    else
        atext("Введите: /aunv [id] [причина]")
    end
end

function checkB()
    if cfg.other.admlvl >=3 then
        lcheckb = lua_thread.create(function()
            bcheckb = not bcheckb
            if bcheckb then
                atext("Проверка начата")
                for line in io.lines('moonloader/Admin Tools/Check Banned/players.txt') do
                    for v in line:gmatch("%S+$") do
                        if v ~= '[IP:' and not v:match("%d+.%d+.%d+.%d+%]") and v ~= '[R_IP:' then
                            if #v >= 3 then
                                bnick = v
                                bancheck = true
                                sampSendChat(("/banlog %s"):format(bnick))
                                while bancheck do wait(0) end
                                wait(cfg.other.delay)
                                break
                            end
                        end
                    end
                end
                atext("Проверка окончена")
                bnick = nil
                bancheck = false
                bcheckb = false
            else
                atext("Проверка окончена")
                lcheckb:terminate()
                bnick = nil
                bancheck = false
            end
        end)
    else
        atext('Команда доступна с 3 лвл администрирования')
    end
end
function autoal()
    lua_thread.create(function()
        while not sampIsLocalPlayerSpawned() do wait(0) end
        sampSendChat('/alogin')
    end)
end
function zapolncheck()
    admins_online = {}
    players_online = {}
    leader_checker_online = {}
    temp_checker_online = {}
    for k, v in ipairs(admins) do
		local id = sampGetPlayerIdByNickname(v['nick'])
		if id ~= nil then
			table.insert(admins_online, {nick = v['nick'], id = id, color = v['color'], text = v['text']})
		end
    end
    for k, v in ipairs(players) do
		local id = sampGetPlayerIdByNickname(v['nick'])
		if id ~= nil then
			table.insert(players_online, {nick = v['nick'], id = id, color = v['color'], text = v['text']})
		end
    end
    for k, v in pairs(leaders) do
        local id = sampGetPlayerIdByNickname(leaders[k])
        if id ~= nil then
            table.insert(leader_checker_online, {nick = leaders[k], id = id, frak = k})
        end
    end
    for k, v in ipairs(temp_checker) do
        local id = sampGetPlayerIdByNickname(v['nick'])
		if id ~= nil then
			table.insert(temp_checker_online, {nick = v['nick'], id = id, color = v['color'], text = v['text']})
		end
    end
end

function checkInTableChecker(table, nick)
    for k, v in ipairs(table) do
        if table[k]['nick'] == nick then return true, k end
    end
    return false, -1
end
function mnarko(pam)
    local id = tonumber(pam)
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if id ~= nil then
        if sampIsPlayerConnected(id) or id == myid then
            sampSendChat(("/addabl %s %s 4 Наркотики в мафии"):format(id, cfg.timers.mnarkotimer))
        else
            atext('Игрок оффлайн')
        end
    else
        atext("Введите: /mnarko [id]")
    end
end
function mcbug(pam)
    local id = tonumber(pam)
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if id ~= nil then
        if sampIsPlayerConnected(id) or id == myid then
            sampSendChat(("/addabl %s %s 4 +C на стреле"):format(id, cfg.timers.mcbugtimer))
        else
            atext('Игрок оффлайн')
        end
    else
        atext("Введите: /mcbug [id]")
    end
end

function ranks(pam)
    lua_thread.create(function()
        local t = {}
        for k, v in pairs(fraklist) do
            table.insert(t, k)
        end
        if #pam ~= 0 then
            if checkIntable(t, string.rupper(pam)) then
                for k,v in pairs(fraklist[string.rupper(pam)]) do
                    atext(("[%s] %s"):format(k, v))
                end
            else
                sampShowDialog(33121, '{66FF00}Список фракций:', "{ffffff}"..table.concat(t, '\n'), 'x', _, 2)
                while sampIsDialogActive(33121) do wait(0) end
                local result, button, list, input = sampHasDialogRespond(33121)
                if result and button ==  1 then
                    local text = sampGetListboxItemText(list)
                    for k,v in pairs(fraklist[text]) do
                        atext(("[%s] %s"):format(k, v))
                    end
                end
            end
        else
            atext("Введите: /ranks [фракция]")
        end
    end)
end

function vkv(pam)
    local id = tonumber(pam)
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if id ~= nil then
        if sampIsPlayerConnected(id) or id == myid then
            if cfg.other.admlvl < 2 then
                sampSendChat(("/a /prison %s 30 Война вне квадрата"):format(id--[[, cfg.timers.sbivtimer]]))
            else
                sampSendChat(("/prison %s 30 Война вне квадрата"):format(id--[[, cfg.timers.sbivtimer]]))
            end
        else
            atext('Игрок оффлайн')
        end
    else
        atext("Введите: /vkv [id]")
    end
end
function oncapt()
    lua_thread.create(function()
        text = ("{ffffff}Банда\tКол-во отлетевших\nGrove\t%s\nBallas\t%s\nRifa\t%s\nVagos\t%s\nAztec\t%s\n \nЗапустить счетчик\nОстановить счетчик\nСбросить счетчик"):format(#otletel.grove, #otletel.ballas, #otletel.rifa, #otletel.vagos, #otletel.aztec)
        sampShowDialog(2134, ("Отлетевшие | Состояние: %s"):format(countstart and 'Включен' or 'Выключен'), text, '»', 'x', 5)
        while sampIsDialogActive(2134) do wait(0) end
        local result, button, list, input = sampHasDialogRespond(2134)
        if result and button ==  1 then
            if list == 0 then
                otext = ''
                for k, v in pairs(otletel.grove) do otext = otext..v.."\n" end
                sampShowDialog(2135,"Отлетевшие: Grove",otext,'x',_,2)
            elseif list == 1 then
                otext = ''
                for k, v in pairs(otletel.ballas) do otext = otext..v.."\n" end
                sampShowDialog(2135,"Отлетевшие: Ballas",otext,'x',_,2)
            elseif list == 2 then
                otext = ''
                for k, v in pairs(otletel.rifa) do otext = otext..v.."\n" end
                sampShowDialog(2135,"Отлетевшие: Rifa",otext,'x',_,2)
            elseif list == 3 then
                otext = ''
                for k, v in pairs(otletel.vagos) do otext = otext..v.."\n" end
                sampShowDialog(2135,"Отлетевшие: Vagos",otext,'x',_,2)
            elseif list == 4 then
                otext = ''
                for k, v in pairs(otletel.aztec) do otext = otext..v.."\n" end
                sampShowDialog(2135,"Отлетевшие: Aztec",otext,'x',_,2)
            elseif list == 6 then
                countstart = true
                atext("Запись отлетевших включена.")
            elseif list == 7 then
                countstart = false
                atext("Запись отлетевших отключена.")
            elseif list == 8 then
                atext("Список отлетевших обнулен.")
                otletel = {
                    grove = {},
                    ballas = {},
                    rifa = {},
                    vagos = {},
                    aztec = {}
                }
            end
        end
    end)
end
function otletfunc(text, color)
    if countstart then
        if color == -10270806 then
            if string.rlower(text):find("grove") then
                table.insert(otletel.grove, text)
            elseif string.rlower(text):find("ballas") then
                table.insert(otletel.ballas, text)
            elseif string.rlower(text):find("rifa") then
                table.insert(otletel.rifa, text)
            elseif string.rlower(text):find("aztec") then
                table.insert(otletel.aztec, text)
            elseif string.rlower(text):find("vagos") then
                table.insert(otletel.vagos, text)
            end
        end
    end
end

function fly()
    local posX, posY, posZ = getCharCoordinates(playerPed)
    local angle = getCharHeading(playerPed)
    local cx, cy, cz = getActiveCameraCoordinates()
    local groundZ = getGroundZFor3dCoord(posX, posY, posZ)
    local speed = getCharSpeed(playerPed)
    local vecX, vecY, vecZ = getCharVelocity(playerPed)
    local boostX, boostY, boostZ = 0.0, 0.0, 0.0
    local rotation, upstream = 0.0, 0.0
  
    ----- Ограничение на Fly
    if reconstate then return end
    if funcsStatus.AirBrk then return end
    if isCharInAnyCar(PLAYER_PED) then return end
    --[[if not sampIsLocalPlayerSpawned() then return end
    if reid ~= -1 then return end
    if getActiveInterior() ~= 0 then return end]]

  
    ----- Стоим на земле
    if groundZ + 1.2 > posZ and groundZ - 1.2 < posZ then
        if flyInfo.fly_active == true then
            flyInfo.fly_active = false
            clearCharTasks(playerPed)
        end
        return
    end
  
    ----- Узнаем новое состояние
    if isKeyDown(key.VK_W) then
        flyInfo.keySpeedState = flyInfo.speed_accelerate
    elseif isKeyDown(key.VK_S) then
        flyInfo.keySpeedState = flyInfo.speed_decelerate
    else
        flyInfo.keySpeedState = flyInfo.speed_none
    end
    if isKeyDown(key.VK_A) then
        flyInfo.keyStrafeState = flyInfo.strafe_left
        rotation = 6.0
    elseif isKeyDown(key.VK_D) then
        flyInfo.keyStrafeState = flyInfo.strafe_right
        rotation = 6.0
    elseif isKeyDown(key.VK_SPACE) then
        flyInfo.keyStrafeState = flyInfo.strafe_up
        upstream = 50.0
    else
        flyInfo.keyStrafeState = flyInfo.strafe_none
    end
  
    ----- Начальная анимация
    if flyInfo.fly_active == false then
        flyInfo.fly_active = true
        flyInfo.lastKeyStrafeState = flyInfo.strafe_none
        if posZ - cz > 0 then
            boostZ = flyInfo.speed_none + 10.0
        else
            boostZ = (flyInfo.speed_none + 10.0) * -1
        end
        taskPlayAnimNonInterruptable(playerPed, "Swim_Tread", "SWIM", 4.0, 1, 0, 0, 0, -1)
    end
  
    ----- Изменяем анимацию в зависимости от скорости
    if flyInfo.keyStrafeState ~= flyInfo.lastKeyStrafeState or flyInfo.keySpeedState ~= flyInfo.lastKeySpeedState then
        flyInfo.lastKeyStrafeState = flyInfo.keyStrafeState
        flyInfo.lastKeySpeedState = flyInfo.keySpeedState
        if flyInfo.keySpeedState == flyInfo.speed_none then
            taskPlayAnimNonInterruptable(playerPed, "Swim_Breast", "SWIM", 4.0, 1, 0, 0, 0, -1)
        elseif flyInfo.keySpeedState == flyInfo.speed_accelerate then
            taskPlayAnimNonInterruptable(playerPed, "SWIM_crawl", "SWIM", 4.0, 1, 0, 0, 0, -1)
        elseif flyInfo.keySpeedState == flyInfo.speed_decelerate then
            if speed > 15.0 then
                taskPlayAnimNonInterruptable(playerPed, "FALL_skyDive", "PARACHUTE", 4.0, 1, 0, 0, 0, -1)
            else
                taskPlayAnimNonInterruptable(playerPed, "Swim_Tread", "SWIM", 4.0, 1, 0, 0, 0, -1)
            end
        end
    end
  
    ------ Ускорение / Замедление
    local time = tonumber(string.format("%.2f", os.clock()))
    if flyInfo.update < time - 0.01 then
        local chSpeed = flyInfo.keySpeedState - flyInfo.currentSpeed
        local chRotation = rotation - flyInfo.rotationSpeed
        local chUp = upstream - flyInfo.upSpeed
        flyInfo.rotationSpeed = flyInfo.rotationSpeed + (chRotation / 50)
        flyInfo.upSpeed = flyInfo.upSpeed + (chUp / 50)
        flyInfo.currentSpeed = flyInfo.currentSpeed + (chSpeed / 50)
        flyInfo.update = time
    end
  
    local coordsX = (posX - cx) * (boostX + flyInfo.currentSpeed)
    local coordsY = (posY - cy) * (boostY + flyInfo.currentSpeed)
    local coordsZ = ((posZ - cz) * (boostZ + flyInfo.currentSpeed)) + 0.3
  
    ----- Вычисляем скорость персонажа и кватернион вращения персонажа
    local qx, qy, qz, qw = getCharQuaternion(playerPed)
    if flyInfo.keyStrafeState == flyInfo.strafe_left then
        local ang = angle + 90
        if ang >= 360.0 then ang = ang - 360.0 end
        local atX = math.sin(math.rad(-ang))
        local atY = math.cos(math.rad(-ang))
        if (coordsX > 0 and atX > 0) or (coordsX < 0 and atX < 0) then
            coordsX = coordsX + (atX * flyInfo.rotationSpeed)
        elseif (coordsX > 0 and atX < 0) or (coordsX < 0 and atX > 0) then
            coordsX = (coordsX - (atX * flyInfo.rotationSpeed)) * -1
        end 
        if (coordsY > 0 and atY > 0) or (coordsY < 0 and atY < 0) then
            coordsY = coordsY + (atY * flyInfo.rotationSpeed)
        elseif (coordsY > 0 and atY < 0) or (coordsY < 0 and atY > 0) then
            coordsY = (coordsY - (atY * flyInfo.rotationSpeed)) * -1
        end
    elseif flyInfo.keyStrafeState == flyInfo.strafe_right then
        local ang = angle - 90
        if ang >= 360.0 then ang = ang - 360.0 end
        local atX = math.sin(math.rad(-ang))
        local atY = math.cos(math.rad(-ang))
        if (coordsX > 0 and atX > 0) or (coordsX < 0 and atX < 0) then
            coordsX = coordsX + (atX * flyInfo.rotationSpeed)
        elseif (coordsX > 0 and atX < 0) or (coordsX < 0 and atX > 0) then
            coordsX = (coordsX - (atX * flyInfo.rotationSpeed)) * -1
        end 
        if (coordsY > 0 and atY > 0) or (coordsY < 0 and atY < 0) then
            coordsY = coordsY + (atY * flyInfo.rotationSpeed)
        elseif (coordsY > 0 and atY < 0) or (coordsY < 0 and atY > 0) then
                coordsY = (coordsY - (atY * flyInfo.rotationSpeed)) * -1
        end  
    end
    if flyInfo.keyStrafeState == flyInfo.strafe_up then
        coordsZ = flyInfo.upSpeed
    end
    if flyInfo.keySpeedState ~= flyInfo.speed_decelerate then
        if coordsZ > 1.0 then coordsZ = coordsZ * 1.5
        else coordsZ = coordsZ / 2 end
    end
    --setCharQuaternion(playerPed, qqx, qqy, qqz, qqw)
  
    ----- Устанавливаем скорость персонажа
    local zAngle = getHeadingFromVector2d(posX - cx, posY - cy)
    setCharHeading(playerPed, zAngle)
    setCharVelocity(playerPed, coordsX, coordsY, coordsZ)
end
  
function getCoordinatesInFrontOfChar(angle)
    local atX, atY, _ = getCharCoordinates(playerPed)
    atX = atX + math.sin(math.rad(-angle))
    atY = atY + math.cos(math.rad(-angle))
    return atX, atY
end

function checkGangZones() 
    ffi.cdef [[ 
        struct stGangzone 
        { 
        float fPosition[4]; 
        uint32_t dwColor; 
        uint32_t dwAltColor; 
        }; 
        
        struct stGangzonePool 
        { 
        struct stGangzone *pGangzone[1024]; 
        int iIsListed[1024]; 
        }; 
    ]] 
    local gz_pool = ffi.cast('struct stGangzonePool*', sampGetGangzonePoolPtr()) 
    if gz_pool.iIsListed[123] ~= 0 and gz_pool.pGangzone[123] ~= nil then 
    local gz_pos = gz_pool.pGangzone[123].fPosition 
    local gz_color = gz_pool.pGangzone[123].dwColor 
    local gz_alt_color = gz_pool.pGangzone[123].dwAltColor 
    print(gz_pos[0], gz_pos[1], gz_pos[2], gz_pos[3], gz_color, gz_alt_color) 
    end 
end

--[[function sampev.onGangZoneDestroy(id)
    atext(id)
end

    149 - карьер
]]