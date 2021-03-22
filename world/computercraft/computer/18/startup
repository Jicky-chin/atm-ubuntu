os.loadAPI("disk/helpers.lua")
channel = 2
id = "turbine3"
modem = peripheral.wrap("top")
turbine = peripheral.wrap("back")
modem.open(channel)
modem.transmit(channel,channel, "connected: " .. id);
while true do
os.sleep(1)
local active = turbine.getActive()
local energy = turbine.getEnergyStored()
local speed = turbine.getRotorSpeed()
local output = turbine.getEnergyProducedLastTick()
local device = "Device:" .. id
local active = "Active:" .. (active and "yes" or "no")
local energy = "Stored Power:" .. energy .. " RF"
local speed = "Speed:" .. speed .. " RPM"
local output = "Output:" .. output .. " RF/t"
modem.transmit(channel, channel, device .. "-" .. active .. "-" .. energy .. "-" .. speed .. "-" .. output)
end

