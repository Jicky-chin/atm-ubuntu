os.loadAPI("disk/helpers.lua")
terminalChannel = 2
selfChannel = 3
id = "reactor1"
modem = peripheral.wrap("top")
reactor = peripheral.wrap("back")
modem.open(terminalChannel)
modem.transmit(terminalChannel, terminalChannel, "connected: " .. id);
while true do
local active = reactor.getActive()
local energy = 0
local fuel = reactor.getFuelAmount()
local temp = reactor.getFuelTemperature()
local case = reactor.getCasingTemperature()
local rodsCount = reactor.getNumberOfControlRods()
local rodValues = {}
local deviceText = "Device:" .. id
local activeText = "Active:" .. (active and "yes" or "no")
local energyText = "Stored Power:" .. energy .. " RF"
local fuelText = "Fuel:" .. fuel .. " mB"
local tempText = "Fuel Temperature:" .. temp .. " C"
local caseTempText = "Case Temperature:" .. case .. " C"
local rodsCountText = "Rods:" .. rodsCount
local rodValuesText = "rodValues:"
for i = 1, rodsCount do
rodValues[i] = reactor.getControlRodLevel(i-1)
rodValuesText = rodValuesText .. rodValues[i] .. (tonumber(i) < rodsCount and "," or "")
end
modem.transmit(terminalChannel, terminalChannel, deviceText .. "-" .. activeText .. "-" .. fuelText .. "-" .. tempText .. "-" .. caseTempText .. "-" .. rodsCountText .. "-" .. rodValuesText)
event, side, senderChannel, senderID, message, distance = os.pullEvent("modem_message")
if string.find(message, "raiseRod") then
local rod = tonumber(helpers.split(message, ':')[2]) - 1
local current = reactor.getControlRodLevel(rod)
local new = current - 1
if new == -1 then new = 0 end
print("setting rod: " .. (rod) .. " to " .. new)
reactor.setControlRodLevel(new, rod)
print("now " .. rod .. " is at " .. reactor.getControlRodLevel(rod))
elseif string.find(message, "lowerRod") then
local rod = tonumber(helpers.split(message, ':')[2]) - 1
local current = reactor.getControlRodLevel(rod)
local new = current + 1
if new > 100 then new = 100 end
reactor.setControlRodLevel(new, rod)
end
end

