local M = {}

--- Полное копирование таблицы включая подтаблицы
function M.deepcopy(object, mt)
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
function M.copy(object, mt)
  mt = mt or false
  local newt = {}
  for k, v in pairs(object) do
     newt[k] = v
  end
  return mt and setmetatable(newt, getmetatable(object)) or newt
end

--- Поиск по значению в таблице, true / false
function M.contains(object, value)
  for k, v in pairs(object) do
     if v == value then
        return true
     end
  end
  return false
end

--- "Склеивает" все указанные таблицы
function M.merge(...)
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

function M.assocMerge(...)
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
function M.map(object, func) -- lume
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
function M.transform(object, func)
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
function M.invert(object) -- lume
  local newTable = {}
  for k, v in pairs(object) do
     newTable[v] = k
  end
  return newTable
end

--- Возвращает все ключи таблицы в виде массива
function M.keys(object) -- lume
  local newTable = {}
  local i = 0
  for k in pairs(object) do
     i = i + 1
     newTable[i] = k
  end
  return newTable
end

--- Получить индекс по первому найденому значению
function M.getIndexOf(object, value)
  for k, v in pairs(object) do
     if v == value then
        return k
     end
  end
  return nil
end

--- Удалить ячейку по значению
function M.removeByValue(object, value)
  local getIndexOf = table.getIndexOf(object, value)
  if getIndexOf then
     object[getIndexOf] = nil
  end
  return getIndexOf
end

return M
