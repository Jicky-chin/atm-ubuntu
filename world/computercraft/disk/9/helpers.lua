function split(s, delimiter)
result = {};
for match in (s..delimiter):gmatch("(.-)"..delimiter) do
table.insert(result, match);
end
return result;
end
function tablelength(T)
local count = 0
for _ in pairs(T) do count = count + 1 end
return count
end
function round(num, numDecimalPlaces)
local mult = 10^(numDecimalPlaces or 0)
return math.floor(num * mult + 0.5) / mult
end
function removebyKey(tab, val)
for i, v in ipairs (tab) do
if (v.id == val) then
tab[i] = nil
end
end
end

