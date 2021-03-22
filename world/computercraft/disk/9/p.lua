os.loadAPI("disk/helpers.lua")
os.loadAPI("disk/draw.lua")
channel = 2
monitor = peripheral.wrap("right")
monitor.clear()
monitor.setTextScale(0.5)
modem = peripheral.wrap("top")
modem.open(channel)
local reactorExists = false
local clickedButtons = {}
local connections = {}
local buttonList = {}
local fuelRods = {}
local devices = {}
local def = {
text = colors.white,
bg = colors.black
}
while true do
monitor.setCursorPos(40, 10)
buttonList = {}
if reactorExists then
for i = 0, 9 do
local spacing = 4
local xPadding = 4
local yPadding = 3
local w = xPadding * 2 + 2
local x = (i * (spacing + w)) + spacing
local y = 30
local rodValue = tonumber(fuelRods[i + 1]) < 10 and "0" or "" .. fuelRods[i + 1]
draw.drawBoxWithText(monitor, x, y, rodValue, colors.gray, colors.white, xPadding, yPadding, def)
end
for i = 0, 9 do
local spacing = 4
local xPadding = 2
local yPadding = 1
local x = (i * (spacing + 10) + spacing)
local y = 37
local id = "decreaseButtonTopRow" .. (i+1)
local function buttonClickHandler ()
print("decrease button " .. id .. " click handler")
clickedButtons[id] = true
end
local color = clickedButtons[id] ~= nil and colors.blue or colors.red
buttonList[id] = draw.Button(monitor, x, y, string.char(25), color, colors.white, xPadding, yPadding, def, id, buttonClickHandler)
end
for i = 0, 9 do
local spacing = 4
local xPadding = 2
local yPadding = 1
local x = (i * (spacing + 10) + (spacing + 5))
local y = 37
local id = "increaseButtonTopRow" .. (i+1)
local function buttonClickHandler ()
print("increase button " .. id .. " click handler")
clickedButtons[id] = true
end
local color = clickedButtons[id] ~= nil and colors.blue or colors.green
buttonList[id] = draw.Button(monitor, x, y, string.char(24), color, colors.white, xPadding, yPadding, def, id, buttonClickHandler)
end
for i = 0, 9 do
local spacing = 4
local xPadding = 4
local yPadding = 3
local w = xPadding * 2 + 2
local x = (i * (spacing + w)) + spacing
local y = 42
local rodValue = tonumber(fuelRods[i + 11]) < 10 and "0" or "" .. fuelRods[i + 11]
draw.drawBoxWithText(monitor, x, y, fuelRods[i + 11], colors.gray, colors.white, xPadding, yPadding, def)
end
for i = 0, 9 do
local spacing = 4
local xPadding = 2
local yPadding = 1
local x = (i * (spacing + 10) + spacing)
local y = 49
local id = "decreaseButtonBottomRow" .. (i+1)
local function buttonClickHandler ()
print("decrease button " .. id .. " click handler")
clickedButtons[id] = true
end
local color = clickedButtons[id] ~= nil and colors.blue or colors.red
buttonList[id] = draw.Button(monitor, x, y, string.char(25), color, colors.white, xPadding, yPadding, def, id, buttonClickHandler)
end
for i = 0, 9 do
local spacing = 4
local xPadding = 2
local yPadding = 1
local x = (i * (spacing + 10) + (spacing + 5))
local y = 49
local id = "increaseButtonBottomRow" .. (i+1)
local function buttonClickHandler ()
print("increase button " .. id .. " click handler")
clickedButtons[id] = true
end
local color = clickedButtons[id] ~= nil and colors.blue or colors.green
buttonList[id] = draw.Button(monitor, x, y, string.char(24), color, colors.white, xPadding, yPadding, def, id, buttonClickHandler)
end
end
event, side, eventProp3, eventProp4, eventProp5, eventProp6 = os.pullEvent()
if event == 'monitor_touch' then
local mouseX = eventProp3
local mouseY = eventProp4
print("mouse click on " .. "("..mouseX..","..mouseY..")")
for k, v in pairs(buttonList) do
if v.isWithinBounds(mouseX, mouseY) then
v.action()
break
end
end
elseif event == 'modem_message' then
local senderChannel = eventProp3
local senderID = eventProp4
local message = eventProp5
local distance = eventProp6
if string.find(message, "connected") then
print("message received, connection: ", message)
local id = helpers.split(message, "connected: ")[1]
if connections[id] ~= nil then
else
connections[id] = id
end
else
local statisticsContent = helpers.split(message, "-")
local device = statisticsContent[1]
local time = os.time()
local formattedTime = textutils.formatTime(time, false)
local lastPos = 0
local counter = 1
local column = 1
devices[device] = {}
for i, stat in ipairs(statisticsContent) do
if i > 1 then 
name = helpers.split(stat, ":")[1]
value = helpers.split(stat, ":")[2]
devices[device][name] = value
end
end
if connections[device] == nil then
print("new device detected: ", device)
connections[device] = device
end
monitor.clear()
for deviceId, v in pairs(devices) do
local statCounter = 1
local statCount = helpers.tablelength(v)
if counter == 4 then
lastPos = 0
counter = 1
column = 2
end
pos = lastPos + 2
monitor.setCursorPos(2 + ((column - 1) * 32), pos)
monitor.write(deviceId)
for statName, stat in pairs(v) do
print(statName)
if statName ~= "rodValues" then
monitor.setCursorPos(3 + ((column - 1) * 32), pos + statCounter)
monitor.write(statName .. ": " .. stat)
statCounter = statCounter + 1
else
statCounter = statCounter -1
end
end
monitor.setCursorPos(3 + ((column - 1) * 32), pos + statCounter)
monitor.write("Last Update: " .. formattedTime)
statCounter = statCounter + 1
lastPos = pos + statCount
counter = counter + 1
end
if(string.find(string.lower(message), "reactor")) then
reactorExists = true
rodValues = helpers.split(devices[device]['rodValues'], ",")
for i, v in ipairs(rodValues) do
fuelRods[i] = v
end
end
end
end
end

