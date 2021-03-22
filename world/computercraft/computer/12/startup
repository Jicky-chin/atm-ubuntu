function Split(s, delimiter)
result = {};
for match in (s..delimiter):gmatch("(.-)"..delimiter) do
table.insert(result, match);
end
return result;
end
id = "enderTurbine1"
modem = peripheral.wrap("top")
turbine = peripheral.wrap("back")
modem.open(1)
modem.transmit(1,1, "connected: " .. id);
while true do
os.sleep(1)
local active = turbine.getActive()
local energy = turbine.getEnergyStored()
local speed = turbine.getRotorSpeed()
local output = turbine.getEnergyProducedLastTick()
local device = "device:" .. id
local active = "active:" .. (active and "yes" or "no")
local energy = "energy:" .. energy
local speed = "speed:" .. speed
local output = "output:" .. output
modem.transmit(1, 1, device .. "-" .. active .. "-" .. energy .. "-" .. speed .. "-" .. output)
end

