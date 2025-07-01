-- Debug
if arg[2] == "debug" then
    lldebugger = require("lldebugger")
    lldebugger.start()
end

function love.load()
    XofMap = -750
    YofMap = -400
    Zoom = 13
    Map = love.graphics.newImage("Map for Courrez!!!.png")
    WoodStick = love.graphics.newImage("Wood-Stick.png")
    Pioche = love.graphics.newImage("Pioche.png")
    Rock = love.graphics.newImage("Rock.png")
    House1 = love.graphics.newImage("House 1.png")
    House2 = love.graphics.newImage("House 2.png")
    House3 = love.graphics.newImage("House 3.png")
    House4 = love.graphics.newImage("House 4.png")
    House5 = love.graphics.newImage("House 5.png")
    Triangle = {}
    Triangle.x = 400
    Triangle.y = 300
    Triangle.size = 50
    Triangle.angle = 0 -- en radians
    CurrentScreen = "Island"
    Speed = 20
    StickAngle = 0
    StickSwinging = false
    Weapon = "Wood"
    WeaponsUnlocked = 1
    Money = 0
    BreakerButton = false
    AutoClick = 0
    TimerAutoClick = 2
    BuySoustraction = 1
    HouseLevel = 0
end

function DrawHouse(x, y, text)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", x + XofMap, y + YofMap, 400, 200)
    love.graphics.setColor(0, 0, 0)
    for i = 1, 5, 1 do
        love.graphics.rectangle("fill", x + (70 * i) - 45 + XofMap, y + 10 + YofMap, 60, 125)
    end
    love.graphics.setColor(0, 0, 1, 0.7)
    love.graphics.rectangle("fill", x + 165 + XofMap, y + 105 + YofMap, 50, 100)
    love.graphics.setFont(love.graphics.newFont(75))
    love.graphics.setColor(1, 0, 0)
    love.graphics.print(text, x + 30 + XofMap, y + 20 + YofMap)
end

function Within(SelfX, SelfY, x, y, w, h)
    return x > SelfX and x < (SelfX + w) and y > SelfY and y < (SelfY + h)
end

function WithinRectRect(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

function WithinCircle(cx, cy, radius, px, py)
    local dx = px - cx
    local dy = py - cy
    local distanceSquared = dx * dx + dy * dy
    return distanceSquared <= radius * radius
end

function Hit()
    if not StickSwinging then
        StickSwinging = true
        StickAngle = 0
    end
end

function DrawRock()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(Rock, 1500 + XofMap, 1700 + YofMap, 0, 0.3)
end

function love.update(dt)
    if CurrentScreen == "Island" then
        TimerAutoClick = TimerAutoClick - dt
        if TimerAutoClick <= 0 then
            TimerAutoClick = 2
            Money = Money + AutoClick
        end
    end
    if Money >= 20 and Money < 60 then
        WeaponsUnlocked = 2
    end
    if StickSwinging then
        if Weapon == "Wood" then
            StickAngle = StickAngle + 8 * dt
        elseif Weapon == "Pioche" then
            StickAngle = StickAngle + 13 * dt
        end
        if StickAngle >= 2 * math.pi then
            StickAngle = 0
            StickSwinging = false
            if XofMap <= -1153 and YofMap <= -1362 and YofMap >= -1778 and XofMap >= -1361 then
                Money = Money + 1
            end
        end
    end
    --Vérification si le player dans un bouton
    local BreakerX = 1350 + XofMap
    local BreakerY = 1700 + YofMap
    local BreakerWidth = 300
    local BreakerHeight = 100
    local House1X = 710 + XofMap
    local House1Y = 1310 + YofMap
    local House1Width = 300
    local House1Height = 100
    local House2X = 1110 + XofMap
    local House2Y = 1310 + YofMap
    local House3X = 1210 + XofMap
    local House3Y = 1310 + YofMap
    local House4X = 1310 + XofMap
    local House4Y = 1310 + YofMap
    local House5X = 1410 + XofMap
    local House5Y = 1310 + YofMap
    if Within(BreakerX, BreakerY, Triangle.x, Triangle.y, BreakerWidth, BreakerHeight) and BreakerButton then
        AutoClick = AutoClick + 1
        Money = Money - 30
        BreakerButton = false
    end
    if Within(House1X, House1Y, Triangle.x, Triangle.y, House1Width, House1Height) and HouseLevel == 0 and Money >= 0 then --pas 0:50
        HouseLevel = 1
        Money = Money - 50
    end
    if WithinCircle(House2X, House2Y, 50, Triangle.x, Triangle.y) and HouseLevel == 1 and Money >= -10000 then --pas 0:100
        HouseLevel = 2
        Money = Money - 100
    end
    if WithinCircle(House3X, House3Y, 50, Triangle.x, Triangle.y) and HouseLevel == 2 and Money >= -10000 then --pas 0:200
        HouseLevel = 3
        Money = Money - 200
    end
    if WithinCircle(House4X, House4Y, 50, Triangle.x, Triangle.y) and HouseLevel == 3 and Money >= -10000 then --pas 0:500
        HouseLevel = 4
        Money = Money - 500
    end
    if WithinCircle(House5X, House5Y, 50, Triangle.x, Triangle.y) and HouseLevel == 4 and Money >= -10000 then --pas 0:1000
        HouseLevel = 5
        Money = Money - 1000
    end
    if CurrentScreen == "Island" then
        if YofMap < 0 then
            if love.keyboard.isDown("up") then
                YofMap = YofMap + Speed * Zoom / Speed
                Triangle.angle = -math.pi / 2
            end
        end
        if YofMap > -2025 then
            if love.keyboard.isDown("down") then
                YofMap = YofMap - Speed * Zoom / Speed
                Triangle.angle = math.pi / 2
            end
        end
        if XofMap > -1426 then
            if love.keyboard.isDown("right") then
                XofMap = XofMap - Speed * Zoom / Speed
                Triangle.angle = 0
            end
        end
        if XofMap < 0 then
            if love.keyboard.isDown("left") then
                XofMap = XofMap + Speed * Zoom / Speed
                Triangle.angle = math.pi
            end
        end
        if love.keyboard.isDown("space") then
            Hit()
        end
        if love.keyboard.isDown("-") then
            Zoom = Zoom - 0.2
        end
        if love.keyboard.isDown("=") then
            Zoom = Zoom + 0.2
        end
    end
end

function love.mousepressed(x, y, button)
    print("x:" .. x)
    print("y:" .. y)
    if button == 1 then
        if Within(250, 100, x, y, 200, 200) and CurrentScreen == "Armerie" then
            Weapon = "Wood"
        elseif Within(500, 100, x, y, 200, 200) and WeaponsUnlocked >= 2 and CurrentScreen == "Armerie" then
            Weapon = "Pioche"
            if BuySoustraction < 2 then
                Money = Money - 20
                BuySoustraction = 2
            end
        elseif Within(200, 500, x, y, 600, 300) and CurrentScreen == "Armerie" then
            CurrentScreen = "Island"
            YofMap = -335
            Triangle.angle = math.pi / 2
        end
    end
end

function love.draw()
    if CurrentScreen == "Island" then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(Map, XofMap, YofMap, 0, Zoom)
        if AutoClick == 0 then
            BreakerButton = true
            love.graphics.setColor(0, 1, 0, 0.4)
            love.graphics.rectangle("fill", 1350 + XofMap, 1700 + YofMap, 370, 100)
            love.graphics.setColor(0, 1, 0)
            love.graphics.setFont(love.graphics.newFont(60))
            love.graphics.print("Breaker:30$", 1360 + XofMap, 1710 + YofMap)
        end
        if HouseLevel == 0 then
            love.graphics.setColor(0, 1, 0, 0.4)
            love.graphics.rectangle("fill", 700 + XofMap, 1300 + YofMap, 350, 100)
            love.graphics.setColor(0, 1, 0)
            love.graphics.setFont(love.graphics.newFont(60))
            love.graphics.print("House:50$", 710 + XofMap, 1310 + YofMap)
        end
        if HouseLevel == 1 then
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(House1, 575 + XofMap, 1000 + YofMap, 0, 0.45)
            love.graphics.setColor(0, 1, 0, 0.4)
            love.graphics.circle("fill", 1100 + XofMap, 1300 + YofMap, 50)
            love.graphics.setColor(1, 0, 0)
            love.graphics.setFont(love.graphics.newFont(37))
            love.graphics.print("100$", 1050 + XofMap, 1280 + YofMap)
        end
        if HouseLevel == 2 then
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(House2, 200 + XofMap, 600 + YofMap, 0, 1)
            love.graphics.setColor(0, 1, 0, 0.4)
            love.graphics.circle("fill", 1200 + XofMap, 1300 + YofMap, 50)
            love.graphics.setColor(1, 0, 0)
            love.graphics.setFont(love.graphics.newFont(37))
            love.graphics.print("200$", 1150 + XofMap, 1280 + YofMap)
        end
        if HouseLevel == 3 then
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(House3, 700 + XofMap, 600 + YofMap, 0, 0.75)
            love.graphics.setColor(0, 1, 0, 0.4)
            love.graphics.circle("fill", 1300 + XofMap, 1300 + YofMap, 50)
            love.graphics.setColor(1, 0, 0)
            love.graphics.setFont(love.graphics.newFont(37))
            love.graphics.print("500$", 1250 + XofMap, 1280 + YofMap)
        end
        if HouseLevel == 4 then
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(House4, 700 + XofMap, 600 + YofMap, 0, 1)
            love.graphics.setColor(0, 1, 0, 0.4)
            love.graphics.circle("fill", 1400 + XofMap, 1300 + YofMap, 50)
            love.graphics.setColor(1, 0, 0)
            love.graphics.setFont(love.graphics.newFont(37))
            love.graphics.print("1000$", 1350 + XofMap, 1280 + YofMap)
        end
        if HouseLevel == 5 then
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(House5, 700 + XofMap, 600 + YofMap, 0, 1)
        end
        -- Triangle
        local s = Triangle.size
        local x = Triangle.x
        local y = Triangle.y
        local a = Triangle.angle
        local p1x = x + math.cos(a) * s
        local p1y = y + math.sin(a) * s
        local p2x = x + math.cos(a + 2 * math.pi / 3) * s * 0.6
        local p2y = y + math.sin(a + 2 * math.pi / 3) * s * 0.6
        local p3x = x + math.cos(a + 4 * math.pi / 3) * s * 0.6
        local p3y = y + math.sin(a + 4 * math.pi / 3) * s * 0.6

        love.graphics.setColor(1, 1, 0)
        love.graphics.polygon("fill", p1x, p1y, p2x, p2y, p3x, p3y)

        -- Bâton pivotant autour du triangle
        if Weapon == "Wood" then
            local swingRadius = 60
            local swingX = Triangle.x + math.cos(StickAngle + Triangle.angle) * swingRadius
            local swingY = Triangle.y + math.sin(StickAngle + Triangle.angle) * swingRadius

            local ox = WoodStick:getWidth() / 2
            local oy = WoodStick:getHeight() / 2

            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(WoodStick, swingX, swingY, StickAngle + Triangle.angle + 1, 0.5, 0.25, ox, oy)

            -- Pivot debug
        elseif Weapon == "Pioche" then
            local swingRadius = 60
            local swingX = Triangle.x + math.cos(StickAngle + Triangle.angle) * swingRadius
            local swingY = Triangle.y + math.sin(StickAngle + Triangle.angle) * swingRadius

            local ox = Pioche:getWidth() / 2
            local oy = Pioche:getHeight() / 2

            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(Pioche, swingX, swingY, StickAngle + Triangle.angle + 1, 0.25, 0.16, ox, oy)

            -- Pivot debug
            love.graphics.setColor(1, 0, 0)
            love.graphics.circle("fill", Triangle.x, Triangle.y, 5)
        end

        DrawHouse(1300, 400, "Weapons")

        local x1 = Triangle.x - 15
        local y1 = Triangle.y - 15
        local w1 = 30
        local h1 = 30

        local x2 = 1465 + XofMap
        local y2 = 505 + YofMap
        local w2 = 48
        local h2 = 97

        local xHouse1 = Triangle.x - 15
        local yHouse1 = Triangle.y - 15
        local wHouse1 = 30
        local hHouse1 = 30

        local xHouse2 = 1465 + XofMap
        local yHouse2 = 505 + YofMap
        local wHouse2 = 48
        local hHouse2 = 97
        if WithinRectRect(x1, y1, w1, h1, x2, y2, w2, h2) then
            love.graphics.setBackgroundColor(1, 1, 1)
            CurrentScreen = "Armerie"
        end
        if WithinRectRect(xHouse1, yHouse1, wHouse1, hHouse1, xHouse2, yHouse2, wHouse2, hHouse2) then
            love.graphics.setBackgroundColor(1, 1, 1)
            CurrentScreen = "House"
        end
        DrawRock()
    elseif CurrentScreen == "Armerie" then
        for i = 1, 6, 1 do
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle("fill", 250 * i, 100, 200, 200)
        end
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(WoodStick, 110, 75, 0, 0.5, 0.25)
        love.graphics.draw(Pioche, 475, 125, 0, 0.25, 0.16)
        love.graphics.setColor(1, 0, 0, 0.7)
        love.graphics.rectangle("fill", 200, 500, 600, 300)
        love.graphics.setColor(1, 0, 0)
        love.graphics.setFont(love.graphics.newFont(200))
        love.graphics.print("Close", 210, 520)
    end
    love.graphics.setColor(0, 1, 0)
    love.graphics.setFont(love.graphics.newFont(125))
    love.graphics.print("Money:" .. Money)
end

local love_errorhandler = love.errorhandler
function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end
