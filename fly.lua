script_name("It's a fly, bro") 
script_authors({ 'Edward_Franklin' })
----------------------------
require 'lib.moonloader'
require 'lib.sampfuncs'
local key = require 'vkeys'
----------------------------
flyInfo = {
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
mainx = 0.0
mainy = 0.0
mainz = 0.0
mainw = 0.0
----------------------------
function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
    sampAddChatMessage("no errors", 0xFFFF00)
    while not sampIsLocalPlayerSpawned() do wait(0) end
    requestAnimation("SWIM")
    requestAnimation("PARACHUTE")
    while true do wait(0)
      --[[if isKeyJustPressed(key.VK_Z) then
        if flyInfo.active == true then
          if isCharInAnyCar(playerPed) then
            setCarProofs(storeCarCharIsInNoSave(playerPed), false, false, false, false, false)
            setCharCanBeKnockedOffBike(playerPed, false)
          end
          setCharProofs(playerPed, false, false, false, false, false)
          clearCharTasks(playerPed)
          flyInfo.active = false
          sampAddChatMessage("deactivated", 0xFFFF00)
        else
          if isCharInAnyCar(playerPed) then
            setCarProofs(storeCarCharIsInNoSave(playerPed), true, true, true, true, true)
            setCharCanBeKnockedOffBike(playerPed, true)
            setCanBurstCarTires(storeCarCharIsInNoSave(playerPed), false)
          end
          setCharProofs(playerPed, true, true, true, true, true)
          flyInfo.active = true
          sampAddChatMessage("activated", 0xFFFF00)
        end
        font = renderCreateFont("Arial", 10, 5)    
      end
      if flyInfo.active then
        fly()
      end]]
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
  --if airbrake then return end

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
  --local qqx, qqy, qqz, qqw = Quaternion_SetEuler(90, 90, 90)
  --setCharQuaternion(playerPed, qqx, qqy, qqz, qqw)

  ----- TEMP
  renderFontDrawText(font, ("X: %f | Y: %f | Z: %f | Speed: %f"):format(coordsX, coordsY, coordsZ, speed), 55, 350, -1)
  renderFontDrawText(font, ("qx: %f | qy: %f | qz: %f | qw: %f"):format(qx, qy, qz, qw), 55, 370, -1)

  ----- Устанавливаем скорость персонажа
  local zAngle = getHeadingFromVector2d(posX - cx, posY - cy)
  setCharHeading(playerPed, zAngle)
  setCharVelocity(playerPed, coordsX, coordsY, coordsZ)
  --[[
    Кватрернион
    Повороты влево/вправо
    -------
    Fly Car
    Взлёт
  ]]
end

function getCoordinatesInFrontOfChar(angle)
  local atX, atY, _ = getCharCoordinates(playerPed)
  atX = atX + math.sin(math.rad(-angle))
  atY = atY + math.cos(math.rad(-angle))
  return atX, atY
end

-- https://github.com/topameng/CsToLua/blob/master/tolua/Assets/Lua/Quaternion.lua
function Quaternion_SetEuler(x, y, z)
  local halfDegToRad = 0.5 * (math.pi / 180)
	local quat = { x = 0, y = 0, z = 0, w = 0 }
  --------
	x = x * halfDegToRad
  y = y * halfDegToRad
  z = z * halfDegToRad
  --------
  quat.w = math.cos(y) * math.cos(x) * math.cos(z) + math.sin(y) * math.sin(x) * math.sin(z)
  quat.x = math.cos(y) * math.sin(x) * math.cos(z) + math.sin(y) * math.cos(x) * math.sin(z)
  quat.y = math.sin(y) * math.cos(x) * math.cos(z) - math.cos(y) * math.sin(x) * math.sin(z)
  quat.z = math.cos(y) * math.cos(x) * math.sin(z) - math.sin(y) * math.sin(x) * math.cos(z)
	return quat
end
