script_name("Repeat")
script_author('Edward_Franklin')
script_version("1.0")

----------------------

require 'lib.moonloader'
require 'lib.sampfuncs'
local sampev = require 'lib.samp.events'

local nick = ""
local pid = nil
local active = false

function main()
  if not isSampfuncsLoaded() or not isSampLoaded() then return end
  while not isSampAvailable() do wait(0) end
	sampRegisterChatCommand("repeat", function(param)
		if active == true then
			active = false
			sampAddChatMessage('������� ��������', -1)
			return
		end
    if #param == 0 then
			sampAddChatMessage("�������: /repeat [id ������]", -1)
			sampAddChatMessage("����� ��������� �������, ������� ������� ��� ���", 0xAFAFAF)
      return
		end
		param = tonumber(param)
		if param == nil or not sampIsPlayerConnected(param) then
			sampAddChatMessage('����� �� ������!', 0xCCCCCC)
			return
		end
		active = true
		pid = param
		nick = sampGetPlayerNickname(param)
		sampAddChatMessage(('������� �������� � %s[%d]'):format(nick, param), -1)
   end)
   while true do wait(0) end
end

function sampev.onServerMessage(color, text)
	 if active and text:find("^%- " .. nick ..": .+$") then
    lua_thread.create(function()
			wait(0)
			local message = text:match("^%- " .. nick ..": (.+)$")
      sampSendChat(("/r [����-����������]: \"%s\""):format(message))
    end)
  end
end

function sampev.onPlayerQuit(playerid, reason)
	if active == true and playerid == pid then
		active = false
		sampAddChatMessage('����� ����� �� ����. ������� ��������', -1)
  end
end

function sampev.onSendCommand(command)
	--if command == '/warehouse' then return false end
end