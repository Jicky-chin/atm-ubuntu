function Split(s, delimiter)
result = {};
for match in (s..delimiter):gmatch("(.-)"..delimiter) do
table.insert(result, match);
end
return result;
end
id = "reactor2"
modem = peripheral.wrap("top")
reactor = peripheral.wrap("back")
modem.open(1)
modem.transmit(1,1, "connected: " .. id);
while true do
os.sleep(1)
modem.transmit(1,1,"device:" .. id .. "-active:yes" .. "-energy:10000-fuel:50000000");
end

