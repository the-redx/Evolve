script_name("Togphone") 
script_authors({ 'Edward_Franklin' })
script_version("1.0")

require 'lib.moonloader'
isTogphone = false

function main()
  while not isSampAvailable() or not sampIsLocalPlayerSpawned() do wait(100) end
  while true do wait(0)
    if sampGetGamestate() ~= 3 and isTogphone then
      isTogphone = false
    end
    if not isTogphone and sampIsLocalPlayerSpawned() then
      isTogphone = true
      lua_thread.create(function()
        wait(2000)
        sampSendChat('/togphone')
      end)
    end
  end
end