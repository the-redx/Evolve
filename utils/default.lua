-- © 2019-2021 Illia Illiashenko (illiashenko.dev). All rights reserved.
-- https://github.com/the-redx/Evolve

function dtext(text)
  text = tostring(text)
  sampAddChatMessage(" » {FFFFFF}"..text, 0x954F4F)
end

function atext(text)
  text = tostring(text)
  sampAddChatMessage(" «SFA-Helper» {FFFFFF}"..text, 0x954F4F)
end

function argbToRgba(argb)
  local a, r, g, b = explode_argb(argb)
  return join_argb(r, g, b, a)
end

function explodeArgb(argb)
  local a = bit.band(bit.rshift(argb, 24), 0xFF)
  local r = bit.band(bit.rshift(argb, 16), 0xFF)
  local g = bit.band(bit.rshift(argb, 8), 0xFF)
  local b = bit.band(argb, 0xFF)
  return a, r, g, b
end

function joinArgb(a, r, g, b)
  local argb = b
  argb = bit.bor(argb, bit.lshift(g, 8))
  argb = bit.bor(argb, bit.lshift(r, 16))
  argb = bit.bor(argb, bit.lshift(a, 24))
  return argb
end

function argbToRgb(color)
  local a = bit.band(bit.rshift(color, 24), 0xFF)
  local r = bit.band(bit.rshift(color, 16), 0xFF)
  local g = bit.band(bit.rshift(color, 8), 0xFF)
  local b = bit.band(color, 0xFF)
  local rgb = b
  rgb = bit.bor(rgb, bit.lshift(g, 8))
  rgb = bit.bor(rgb, bit.lshift(r, 16))
  return rgb
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

--- Определяет расстояние между двумя точками
function distBetweenCoords(cx, cy, cz, px, py, pz)
  return tonumber(("%0.2f"):format(getDistanceBetweenCoords3d(cx, cy, cz, px, py, pz)))
end

--- Делает скриншот игры
function screen() memory.setuint8(sampGetBase() + 0x119CBC, 1) end

--- Кодирует текст для передачи в URI
function encodeURI(str)
  if (str) then
    str = string.gsub (str, "\n", "\r\n")
    str = string.gsub (str, "([^%w ])",
      function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
   end
   return str
end

function getZoneByCode(zone)
  local names = {
    ["SUNMA"] = "Bayside Marina",
    ["SUNNN"] = "Bayside",
    ["BATTP"] = "Battery Point",
    ["PARA"] = "Paradiso",
    ["CIVI"] = "Santa Flora",
    ["BAYV"] = "Palisades",
    ["CITYS"] = "City Hall",
    ["OCEAF"] = "Ocean Flats",
    ["HASH"] = "Hashbury",
    ["JUNIHO"] = "Juniper Hollow",
    ["ESPN"] = "Esplanade North",
    ["FINA"] = "Financial",
    ["CALT"] = "Calton Heights",
    ["SFDWT"] = "Downtown",
    ["JUNIHI"] = "Juniper Hill",
    ["CHINA"] = "Chinatown",
    ["THEA"] = "King's",
    ["GARC"] = "Garcia",
    ["DOH"] = "Doherty",
    ["SFAIR"] = "Easter Bay Airport",
    ["EASB"] = "Easter Basin",
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
    ["HANKY"] = "Hankypanky Point",
    ["PALO"] = "Palomino Creek",
    ["NROCK"] = "North Rock",
    ["MONT"] = "Montgomery",
    ["HBARNS"] = "Hampton Barns",
    ["FERN"] = "Fern Ridge",
    ["DILLI"] = "Dillimore",
    ["TOPFA"] = "Hilltop Farm",
    ["BLUEB"] = "Blueberry",
    ["PANOP"] = "The Panopticon",
    ["FRED"] = "Frederick Bridge",
    ["MAKO"] = "The Mako Span",
    ["BLUAC"] = "Blueberry Acres",
    ["MART"] = "Martin Bridge",
    ["FALLO"] = "Fallow Bridge",
    ["CREEK"] = "Shady Creeks",
    ["WESTP"] = "Queens",
    ["LA"] = "Los Santos",
    ["VE"] = "Las Venturas",
    ["BONE"] = "Bone County",
    ["ROBAD"] = "Tierra Robada",
    ["GANTB"] = "Gant Bridge",
    ["SF"] = "San Fierro",
    ["RED"] = "Red County",
    ["FLINTC"] = "Flint County",
    ["EBAY"] = "Easter Bay Chemicals",
    ["SILLY"] = "Foster Valley",
    ["WHET"] = "Whetstone",
    ["LAIR"] = "Los Santos International",
    ["BLUF"] = "Verdant Bluffs",
    ["ELCO"] = "El Corona",
    ["LIND"] = "Willowfield",
    ["MAR"] = "Marina",
    ["VERO"] = "Verona Beach",
    ["CONF"] = "Conference Center",
    ["COM"] = "Commerce",
    ["PER1"] = "Pershing Square",
    ["LMEX"] = "Little Mexico",
    ["IWD"] = "Idlewood",
    ["GLN"] = "Glen Park",
    ["JEF"] = "Jefferson",
    ["CHC"] = "Las Colinas",
    ["GAN"] = "Ganton",
    ["EBE"] = "East Beach",
    ["ELS"] = "East Los Santos",
    ["JEF"] = "Jefferson",
    ["LFL"] = "Los Flores",
    ["LDT"] = "Downtown Los Santos",
    ["MULINT"] = "Mulholland Intersection",
    ["MUL"] = "Mulholland",
    ["MKT"] = "Market",
    ["VIN"] = "Vinewood",
    ["SUN"] = "Temple",
    ["SMB"] = "Santa Maria Beach",
    ["ROD"] = "Rodeo",
    ["RIH"] = "Richman",
    ["STRIP"] = "The Strip",
    ["DRAG"] = "The Four Dragons Casino",
    ["PINK"] = "The Pink Swan",
    ["HIGH"] = "The High Roller",
    ["PIRA"] = "Pirates in Men's Pants",
    ["VISA"] = "The Visage",
    ["JTS"] = "Julius Thruway South",
    ["JTW"] = "Julius Thruway West",
    ["RSE"] = "Rockshore East",
    ["LOT"] = "Come-A-Lot",
    ["CAM"] = "The Camel's Toe",
    ["ROY"] = "Royal Casino",
    ["CALI"] = "Caligula's Palace",
    ["PILL"] = "Pilgrim",
    ["STAR"] = "Starfish Casino",
    ["ISLE"] = "The Emerald Isle",
    ["OVS"] = "Old Venturas Strip",
    ["KACC"] = "K.A.C.C. Military Fuels",
    ["CREE"] = "Creek",
    ["SRY"] = "Sobell Rail Yards",
    ["LST"] = "Linden Station",
    ["JTE"] = "Julius Thruway East",
    ["LDS"] = "Linden Side",
    ["JTN"] = "Julius Thruway North",
    ["HGP"] = "Harry Gold Parkway",
    ["REDE"] = "Redsands East",
    ["VAIR"] = "Las Venturas Airport",
    ["LVA"] = "LVA Freight Depot",
    ["BINT"] = "Blackfield Intersection",
    ["GGC"] = "Greenglass College",
    ["BFLD"] = "Blackfield",
    ["ROCE"] = "Roca Escalante",
    ["LDM"] = "Last Dime Motel",
    ["RSW"] = "Rockshore West",
    ["RIE"] = "Randolph Industrial Estate",
    ["BFC"] = "Blackfield Chapel",
    ["PINT"] = "Pilson Intersection",
    ["WWE"] = "Whitewood Estates",
    ["PRP"] = "Prickle Pine",
    ["SPIN"] = "Spinybed",
    ["SASO"] = "San Andreas Sound",
    ["FISH"] = "Fisher's Lagoon",
    ["GARV"] = "Garver Bridge",
    ["KINC"] = "Kincaid Bridge",
    ["LSINL"] = "Los Santos Inlet",
    ["SHERR"] = "Sherman Reservoir",
    ["FLINW"] = "Flint Water",
    ["ETUNN"] = "Easter Tunnel",
    ["BYTUN"] = "Bayside Tunnel",
    ["BIGE"] = "'The Big Ear'",
    ["PROBE"] = "Lil' Probe Inn",
    ["VALLE"] = "Valle Ocultado",
    ["LINDEN"] = "Linden Station",
    ["UNITY"] = "Unity Station",
    ["MARKST"] = "Market Station",
    ["CRANB"] = "Cranberry Station",
    ["YELLOW"] = "Yellow Bell Station",
    ["SANB"] = "San Fierro Bay",
    ["ELCA"] = "El Castillo del Diablo",
    ["REST"] = "Restricted Area",
    ["MONINT"] = "Montgomery Intersection",
    ["ROBINT"] = "Robada Intersection",
    ["FLINTI"] = "Flint Intersection",
    ["SFAIR"] = "Easter Bay Airport",
    ["MKT"] = "Market",
    ["CUNTC"] = "Avispa Country Club",
    ["HILLP"] = "Missionary Hill",
    ["MTCHI"] = "Mount Chiliad",
    ["YBELL"] = "Yellow Bell Golf Course",
    ["VAIR"] = "Las Venturas Airport",
    ["LDOC"] = "Ocean Docks",
    ["STAR"] = "Starfish Casino",
    ["BEACO"] = "Beacon Hill",
    ["GARC"] = "Garcia",
    ["PLS"] = "Playa del Seville",
    ["STAR"] = "Starfish Casino",
    ["RING"] = "The Clown's Pocket",
    ["LIND"] = "Willowfield",
    ["WWE"] = "Whitewood Estates",
    ["LDT"] = "Downtown Los Santos"
  }
  if names[zone] == nil then return "Не определено" end
  return names[zone]
end

function sampGetPlayerIdByNickname(nick)
  local _, myid = sampGetPlayerIdByCharHandle(playerPed)
  if tostring(nick) == sampGetPlayerNickname(myid) then return myid end
  for i = 0, 1000 do if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == tostring(nick) then return i end end
end

function getWeaponName(weapon)
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

--- Определяет номер квадрата по букве
function getSectorNumber(param)
  local KV = {"А","Б","В","Г","Д","Ж","З","И","К","Л","М","Н","О","П","Р","С","Т","У","Ф","Х","Ц","Ч","Ш","Я"}
  return table.getIndexOf(KV, rusUpper(param))
end

-- Определяем квадрат по координатам
function getSectorByCoorditates()
  local KV = {"А","Б","В","Г","Д","Ж","З","И","К","Л","М","Н","О","П","Р","С","Т","У","Ф","Х","Ц","Ч","Ш","Я"}
  local X, Y, Z = getCharCoordinates(playerPed)
  X = math.ceil((X + 3000) / 250)
  Y = math.ceil((Y * - 1 + 3000) / 250)
  -- Fix #7469 (27/7/19)
  if X <= 0 or Y < 1 or Y > #KV then return "Нет" end
  Y = KV[Y]
  return (Y.."-"..X)
end

--- Определяем фракцию по скину
function sampGetFractionBySkin(id)
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

--- Определяет день недели по дате. Начинает с Воскресенья (0)
function time.dateToWeekNumber(date)
  local wsplit = string.split(date, ".")
  local day = tonumber(wsplit[1])
  local month = tonumber(wsplit[2])
  local year = tonumber(wsplit[3])
  local a = math.floor((14 - month) / 12)
  local y = year - a
  local m = month + 12 * a - 2
  return math.floor((day + y + math.floor(y / 4) - math.floor(y / 100) + math.floor(y / 400) + (31 * m) / 12) % 7)
end

--- Определяет день недели по дате.
function time.dateToWeek(date)
  local days = {"Воскресенье", "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота"}
  return days[time.dateToWeekNumber(date) + 1]
end

--- Превращает кол-во секунд во время - HH:mm:ss
function time.secToTime(sec)
  local hour, minute, second = sec / 3600, math.floor(sec / 60), sec % 60
  return string.format("%02d:%02d:%02d", math.floor(hour) ,  minute - (math.floor(hour) * 60), second)
end

--- Адаптированная версия под разное кол-во секунд
function time.secToTimeFixed(sec)
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

--- Возвращает координаты точки, помеченой на карте (с пофикшеной Z координатой)
function getTargetBlipCoordinatesFixed()
  local bool, x, y, z = getTargetBlipCoordinates(); if not bool then return false end
  requestCollision(x, y); loadScene(x, y, z)
  local bool, x, y, z = getTargetBlipCoordinates()
  return bool, x, y, z
end

--- Генерирует асинхронный запрос
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

local russian_characters = {
  [168] = 'Ё', [184] = 'ё', [192] = 'А', [193] = 'Б', [194] = 'В', [195] = 'Г', [196] = 'Д', [197] = 'Е', [198] = 'Ж', [199] = 'З', [200] = 'И', [201] = 'Й', [202] = 'К', [203] = 'Л', [204] = 'М', [205] = 'Н', [206] = 'О', [207] = 'П', [208] = 'Р', [209] = 'С', [210] = 'Т', [211] = 'У', [212] = 'Ф', [213] = 'Х', [214] = 'Ц', [215] = 'Ч', [216] = 'Ш', [217] = 'Щ', [218] = 'Ъ', [219] = 'Ы', [220] = 'Ь', [221] = 'Э', [222] = 'Ю', [223] = 'Я', [224] = 'а', [225] = 'б', [226] = 'в', [227] = 'г', [228] = 'д', [229] = 'е', [230] = 'ж', [231] = 'з', [232] = 'и', [233] = 'й', [234] = 'к', [235] = 'л', [236] = 'м', [237] = 'н', [238] = 'о', [239] = 'п', [240] = 'р', [241] = 'с', [242] = 'т', [243] = 'у', [244] = 'ф', [245] = 'х', [246] = 'ц', [247] = 'ч', [248] = 'ш', [249] = 'щ', [250] = 'ъ', [251] = 'ы', [252] = 'ь', [253] = 'э', [254] = 'ю', [255] = 'я',
}

--- string.lower для русских букв
function string.rusLower(s)
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

--- string.upper для русских букв
function string.rusUpper(s)
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

--- Функция @FYP, делит строку по паттерну.
function string.split(str, delim, plain)
  local tokens, pos, plain = {}, 1, not (plain == false) --[[ delimiter is plain text by default ]]
  repeat
      local npos, epos = string.find(str, delim, pos, plain)
      table.insert(tokens, string.sub(str, pos, npos and npos - 1))
      pos = epos and epos + 1
  until not pos
  return tokens
end

--- Обрезает с начала и конца указанный символ, если символ не указан - обрезает все пробельные символы
function string.trim(str, chars) -- lume
  if not chars then
     return str:match("^[%s]*(.-)[%s]*$")
  end
  local chars = chars:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
  return str:match("^[" .. chars .. "]*(.-)[" .. chars .. "]*$")
end

--- Проверяет находится ли подстрока в строке
function string.contains(str, substr)
  return string.find(str, substr, 1, true) ~= nil
end

--- Функция обратного поиска
function string.rfind(str, pattern, offset, plain)
  local pos, lnpos, lepos, plain = offset and offset - 1 or 0, offset or 1, -1, not (plain == false)
  repeat
     local npos, epos = string.find(str, pattern, pos, plain)
     pos = epos and epos + 1
     if pos then
        lnpos, lepos = npos, epos
     end
  until not pos
  return lnpos, lepos
end

--- Полное копирование таблицы включая подтаблицы
function table.deepcopy(object, mt)
  local lookup_table = {}
  mt = mt or false
  local function _copy(object)
        if type(object) ~= "table" then
           return object
        elseif lookup_table[object] then
           return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
           new_table[_copy(index)] = _copy(value)
        end
        return mt and setmetatable(new_table, getmetatable(object)) or new_table
  end
  return _copy(object)
end

--- Поверхностно копирует массив (только указанный уровень). Параметр mt отвечает вернуть ли метатаблицу или нет.
function table.copy(object, mt)
  mt = mt or false
  local newt = {}
  for k, v in pairs(object) do
     newt[k] = v
  end
  return mt and setmetatable(newt, getmetatable(object)) or newt
end

--- Поиск по значению в таблице, true / false
function table.contains(object, value)
  for k, v in pairs(object) do
     if v == value then
        return true
     end
  end
  return false
end

--- "Склеивает" все указанные таблицы
function table.merge(...)
  local len = select('#', ...)
  assert(len > 1, "impossible to merge less than two tables")
  local newTable = {}
  for i = 1, len do
     local t = select(i, ...)
     for k, v in pairs(t) do
        table.insert(newTable, v)
     end
  end
  return newTable
end

function table.assocMerge(...)
  local len = select('#', ...)
  assert(len > 1, "impossible to merge less than two tables")
  local newTable = {}
  for i = 1, len do
     local t = select(i, ...)
     for k, v in pairs(t) do
        newTable[k] = v
     end
  end
  return newTable
end

--- Тоже самое что и table.transform, но не заменит оригинал таблицы и вернет копию.
function table.map(object, func) -- lume
  local newTable = {}
  for k, v in pairs(object) do
     if type(v) == "table" then
        newTable[k] = table.map(v, func)
     else
        newTable[k] = func(v)
     end
  end
  return newTable
end

--- Применит func(valute) к каждому элементы таблицы и заменит изначальные данные результатом выполнения функции
function table.transform(object, func)
  for k, v in pairs(object) do
     if type(v) == "table" then
        object[k] = table.transform(v, func)
     else
        object[k] = func(v)
     end
  end
  return object
end

--- Меняет ключ и значение местами
function table.invert(object) -- lume
  local newTable = {}
  for k, v in pairs(object) do
     newTable[v] = k
  end
  return newTable
end

--- Возвращает все ключи таблицы в виде массива
function table.keys(object) -- lume
  local newTable = {}
  local i = 0
  for k in pairs(object) do
     i = i + 1
     newTable[i] = k
  end
  return newTable
end

--- Получить индекс по первому найденому значению
function table.getIndexOf(object, value)
  for k, v in pairs(object) do
     if v == value then
        return k
     end
  end
  return nil
end

--- Удалить ячейку по значению
function table.removeByValue(object, value)
  local getIndexOf = table.getIndexOf(object, value)
  if getIndexOf then
     object[getIndexOf] = nil
  end
  return getIndexOf
end
