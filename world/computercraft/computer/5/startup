function Split(s, delimiter)
result = {};
for match in (s..delimiter):gmatch("(.-)"..delimiter) do
table.insert(result, match);
end
return result;
end
id = "enderReactor1"
modem = peripheral.wrap("top")
reactor = peripheral.wrap("back")
modem.open(1)
modem.transmit(1,1, "connected: " .. id);
while true do
os.sleep(1)
local active = reactor.getActive()
local energy = 0
local fuel = reactor.getFuelAmount()
local device = "device:" .. id
local active = "active:" .. (active and "yes" or "no")
local energy = "energy:" .. energy
local fuel = "fuel:" .. fuel
modem.transmit(1, 1, device .. "-" .. active .. "-" .. energy .. "-" .. fuel)
end

