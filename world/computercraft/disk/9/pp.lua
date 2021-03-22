os.loadAPI("disk/helpers.lua")
os.loadAPI("disk/draw.lua")
local channel = 2
local reactorChannel = 3
local monitor = peripheral.wrap("right")
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
monitor.clear()
monitor.setTextScale(0.5)
modem = peripheral.wrap("top")
modem.open(channel)
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
local xPadding = 4
local w = xPadding * 2 + 2
local x = (i * (spacing + w)) + spacing
local y = 31
local rod = "  Rod " .. ((i + 1) < 10 and "0" or "") .. i + 1
draw.drawText(monitor, x, y, rod, colors.gray, colors.white, def)
end
for i = 0, 9 do
local spacing = 4
local xPadding = 2
local yPadding = 1
local x = (i * (spacing + 10) + spacing)
local y = 37
local rod = (i+1)
local id = "decreaseButtonTopRow" .. rod
local function buttonClickHandler ()
print("decrease button " .. id .. " click handler")
clickedButtons[id] = 1
modem.transmit(channel, channel, "lowerRod:" .. rod)
end
local color = colors.blue
if clickedButtons[id] ~= nil then
if clickedButtons[id] < 6 then
color = colors.gray
clickedButtons[id] = clickedButtons[id] + 1
else
clickedButtons[id] = nil
end
end
buttonList[id] = draw.Button(monitor, x, y, string.char(25), color, colors.white, xPadding, yPadding, def, id, buttonClickHandler)
end
for i = 0, 9 do
local spacing = 4
local xPadding = 2
local yPadding = 1
local x = (i * (spacing + 10) + (spacing + 5))
local y = 37
local rod = (i+1)
local id = "increaseButtonTopRow" .. rod
local function buttonClickHandler ()
print("increase button " .. id .. " click handler")
clickedButtons[id] = 1
modem.transmit(channel, channel, "raiseRod:" .. rod)
end
local color = colors.red
if clickedButtons[id] ~= nil then
if clickedButtons[id] < 6 then
color = colors.gray
clickedButtons[id] = clickedButtons[id] + 1
else
clickedButtons[id] = nil
end
end
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
local xPadding = 4
local w = xPadding * 2 + 2
local x = (i * (spacing + w)) + spacing
local y = 43
local rod = "  Rod " .. tostring(i + 11)
draw.drawText(monitor, x, y, rod, colors.gray, colors.white, def)
end
for i = 0, 9 do
local spacing = 4
local xPadding = 2
local yPadding = 1
local x = (i * (spacing + 10) + spacing)
local y = 49
local rod = (i+11)
local id = "decreaseButtonBottomRow" .. rod
local function buttonClickHandler ()
print("decrease button " .. id .. " click handler")
clickedButtons[id] = 1
modem.transmit(channel, channel, "lowerRod:" .. rod)
end
local color = colors.blue
if clickedButtons[id] ~= nil then
if clickedButtons[id] < 6 then
color = colors.gray
clickedButtons[id] = clickedButtons[id] + 1
else
clickedButtons[id] = nil
end
end
buttonList[id] = draw.Button(monitor, x, y, string.char(25), color, colors.white, xPadding, yPadding, def, id, buttonClickHandler)
end
for i = 0, 9 do
local spacing = 4
local xPadding = 2
local yPadding = 1
local x = (i * (spacing + 10) + (spacing + 5))
local y = 49
local rod = (i+11)
local id = "increaseButtonBottomRow" .. rod
local function buttonClickHandler ()
print("increase button " .. id .. " click handler")
clickedButtons[id] = 1
modem.transmit(channel, channel, "raiseRod:" .. rod)
end
local color = colors.red
if clickedButtons[id] ~= nil then
if clickedButtons[id] < 6 then
color = colors.gray
clickedButtons[id] = clickedButtons[id] + 1
else
clickedButtons[id] = nil
end
end
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
local isReactorMessage = string.find(string.lower(message), "reactor")
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
for deviceId, deviceObject in pairs(devices) do
local statCounter = 1
local statCount = helpers.tablelength(deviceObject)
local reactorDevice = string.find(string.lower(deviceId), "reactor")
local columnWidth = 37
if counter == 4 then
lastPos = 0
column = 2
end
if counter == 7 then
lastPos = 0
column = 3
end
pos = lastPos + 2
monitor.setCursorPos(2 + ((column - 1) * columnWidth), pos)
monitor.write(deviceId)
for statName, stat in pairs(deviceObject) do
if statName ~= "rodValues" then
monitor.setCursorPos(3 + ((column - 1) * columnWidth), pos + statCounter)
isNumber = tonumber(helpers.split(stat, " ")[1]) ~= nil
isWarning = false
isDanger = false
statUnit = helpers.split(stat, " ")[2] ~= nil and helpers.split(stat, " ")[2] or ""
if(isNumber) then
stat = helpers.round(tonumber(helpers.split(stat, " ")[1]))
if statName == "Stored Power" and stat == 0 then isDanger = true end
end
if isDanger then monitor.setBackgroundColor(colors.red); isDanger = false end
monitor.write(statName .. ": " .. stat .. " " .. statUnit)
monitor.setBackgroundColor(def.bg)
statCounter = statCounter + 1
end
end
monitor.setCursorPos(3 + ((column - 1) * columnWidth), pos + statCounter)
monitor.write("Last Update: " .. formattedTime)
lastPos = pos + statCount + 1 - (reactorDevice and 1 or 0)
counter = counter + 1
end
if isReactorMessage then
reactorExists = true
rodValues = helpers.split(devices[device]['rodValues'], ",")
for i, v in ipairs(rodValues) do
fuelRods[i] = v
end
end
end
end
end

