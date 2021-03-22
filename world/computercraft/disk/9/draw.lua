function reset(m, defaults)
if defaults ~= nil then
m.setTextColor(defaults.text)
m.setBackgroundColor(defaults.bg)
else
m.setTextColor(colors.white)
m.setBackgroundColor(colors.black)
end
end
function drawBoxWithText(m, x, y, text, bg, fg, xPadding, yPadding, defaults)
m.setCursorPos(x, y)
m.setBackgroundColor(bg)
m.setTextColor(fg)
for i = 0, yPadding - 1 do
m.setCursorPos(x, y + i)
m.write(string.rep(" ", string.len(text) + (xPadding * 2)))
end
m.setCursorPos(x, y + yPadding)
m.write(string.rep(" ", xPadding) .. text .. string.rep(" ", xPadding))
for j = 0, yPadding - 1 do
m.setCursorPos(x, y + j + yPadding + 1)
m.write(string.rep(" ", string.len(text) + (xPadding * 2)))
end
reset(m, defaults)
end
function drawBox(x, y, w, h, bg, defaults)
m.setBackgroundColor(bg)
for i = 0, h - 1 do
m.setCursorPos(x, y + i)
m.write(string.rep(" ", w))
end
reset(m, defaults)
end
function drawText(m, x, y, text, bg, color, defaults)
m.setCursorPos(x, y)
m.setBackgroundColor(bg)
m.setTextColor(color)
m.write(text)
reset(m, defaults)
end
Button = {
m = nil,
x = nil,
y = nil,
text = nil,
bg = nil,
fg = nil,
xp = nil,
yp = nil,
id = nil,
w = nil,
h = nil,
action = nil
}
function Button(m, x, y, text, bg, fg, xPadding, yPadding, defaults, id, action)
local button = {
m = m,
x = x,
y = y,
text = text,
bg = bg,
fg = fg,
xp = xPadding,
yp = yPadding,
id = id,
w = string.len(text) + (xPadding * 2),
h = 1 + (yPadding * 2),
action = action
}
function button.isWithinBounds(_x, _y)
if(_x >= button.x and _x <= button.x + button.w) and (_y >= button.y and _y <= button.y + button.h) then
print(button.id .. " at " .. button.x .. ", " .. button.y .. " has been clicked")
return true
else
return false
end
end
drawBoxWithText(button.m, button.x, button.y, button.text, button.bg, button.fg, button.xp, button.yp, defaults)
return button
end

