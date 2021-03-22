os.loadAPI("disk/helpers.lua")
monitor = peripheral.wrap("right")
monitor.clear()
monitor.setTextScale(0.5)
modem = peripheral.wrap("top")
modem.open(1)
connections = {}
reports = {}
function updateMonitor()
print("update monitor")
local time = os.time()
local formattedTime = textutils.formatTime(time, false)
monitor.clear()
monitor.setCursorPos(1,1)
lastPos = 0
counter = 1
for k, v in pairs(reports) do
print("write to monitor for " .. k)
if string.find(string.lower(v.id), "reactor") then
pos = lastPos + 2
monitor.setCursorPos(2, pos)
monitor.write(v.id)
monitor.setCursorPos(3, pos + 1)
monitor.write("Active: " .. (v.active and "yes" or "no"))
monitor.setCursorPos(3, pos + 2)
monitor.write("Fuel: " .. helpers.round(tonumber(v.fuel), 0) .. " mB")
monitor.setCursorPos(3, pos + 3)
monitor.write("Stored Power: " .. helpers.round(tonumber(v.energy), 0) .. " RF")
monitor.setCursorPos(3, pos + 4)
monitor.write("Last Update: " .. formattedTime)
lastPos = pos + 4
elseif string.find(string.lower(v.id), "turbine") then
pos = lastPos + 2
monitor.setCursorPos(2, pos)
monitor.write(v.id)
monitor.setCursorPos(3, pos + 1)
monitor.write("Active: " .. (v.active and "yes" or "no"))
monitor.setCursorPos(3, pos + 2)
monitor.write("Speed: " .. helpers.round(tonumber(v.speed), 0) .. " RPM")
monitor.setCursorPos(3, pos + 3)
monitor.write("Last Output: " .. helpers.round(tonumber(v.output), 0) .. " RF/t")
monitor.setCursorPos(3, pos + 4)
monitor.write("Stored Power: " .. helpers.round(tonumber(v.energy), 0) .. " RF")
monitor.setCursorPos(3, pos + 5)
monitor.write("Last Update: " .. formattedTime)
lastPos = pos + 5
end
counter = counter + 1
end
end
while true do
event, modemSide, senderChannel, senderID, message, distance = os.pullEvent("modem_message")
if string.find(message, "connected") then
print("message received, connection: ", message)
id = helpers.split(message, "connected: ")[1]
if connections[id] ~= nil then
else
connections[id] = id
end
updateMonitor()
else
print("message received, report: ", message)
if string.find(string.lower(message), "reactor") then
device = helpers.split(message, "-")[1]
active = helpers.split(message, "-")[2]
energy = helpers.split(message, "-")[3]
fuel = helpers.split(message, "-")[4]
id = helpers.split(device, ":")[2]
activeValue = helpers.split(active, ":")[2]
energyValue = helpers.split(energy, ":")[2]
fuelValue = helpers.split(fuel, ":")[2]
if connections[id] == nil then
print("new device detected: ", id)
connections[id] = id
end
if reports[device] ~= nil then
reports[device].id = id
reports[device].active = activeValue
reports[device].energy = energyValue
reports[device].fuel = fuelValue
else
reports[device] = {
id = id,
active = activeValue,
energy = energyValue,
fuel = fuelValue
}
end
elseif string.find(string.lower(message), "turbine") then
device = helpers.split(message, "-")[1]
active = helpers.split(message, "-")[2]
energy = helpers.split(message, "-")[3]
speed = helpers.split(message, "-")[4]
output = helpers.split(message, "-")[5]
id = helpers.split(device, ":")[2]
activeValue = helpers.split(active, ":")[2]
energyValue = helpers.split(energy, ":")[2]
speedValue = helpers.split(speed, ":")[2]
outputValue = helpers.split(output, ":")[2]
if connections[id] == nil then
print("new device detected: ", id)
connections[id] = id
end
if reports[device] ~= nil then
reports[device].id = id
reports[device].active = activeValue
reports[device].energy = energyValue
reports[device].speed = speedValue
reports[device].output = outputValue
else
reports[device] = {
id = id,
active = activeValue,
energy = energyValue,
speed = speedValue,
output = outputValue
}
end
end
updateMonitor()
end
end

