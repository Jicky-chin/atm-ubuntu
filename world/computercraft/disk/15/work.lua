m = peripheral.wrap("back")
m.setCursorPos(1,1)
m.setTextScale(5)

on = true

while true do 
m.clear()

    if on then 
        m.setCursorPos(1,1)
        m.write("pabota"..string.char(209))                
        sleep(1)
    else 
        m.clear()
        sleep(0.5)
    end
end
