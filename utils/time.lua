local M = {}

--- Определяет день недели по дате. Начинает с Воскресенья (0)
function M.dateToWeekNumber(date)
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
function M.dateToWeek(date)
  local days = {"Воскресенье", "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота"}
  return days[time.dateToWeekNumber(date) + 1]
end

--- Превращает кол-во секунд во время - HH:mm:ss
function M.secToTime(sec)
  local hour, minute, second = sec / 3600, math.floor(sec / 60), sec % 60
  return string.format("%02d:%02d:%02d", math.floor(hour) ,  minute - (math.floor(hour) * 60), second)
end

--- Адаптированная версия под разное кол-во секунд
function M.secToTimeFixed(sec)
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

return M
