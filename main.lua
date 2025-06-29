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
    Triangle = {}
    Triangle.x = 400
    Triangle.y = 300
    Triangle.size = 50
    Triangle.angle = 0 -- en radians
end

function DrawHouse(x, y)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", x + XofMap, y + YofMap, 400, 200)
    love.graphics.setColor(0, 0, 0)
    for i = 1, 5, 1 do
        love.graphics.rectangle("fill", x + (70 * i) - 45 + XofMap, y + 10 + YofMap, 60, 125)
    end
    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("fill", x + 165 + XofMap, y + 105 + YofMap, 50, 100)
end

function Within(SelfX, SelfY, x, y, w, h)
    return x > SelfX and x < (SelfX + w) and
        y > SelfY and y < (SelfY + h)
end

function WithinRectRect(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
        x2 < x1 + w1 and
        y1 < y2 + h2 and
        y2 < y1 + h1
end

function love.update()
    if YofMap < 0 then
        if love.keyboard.isDown("up") then
            YofMap = YofMap + 20 * Zoom / 20
            Triangle.angle = -math.pi / 2 -- Haut
        end
    end
    if YofMap > -2025 then
        if love.keyboard.isDown("down") then
            YofMap = YofMap - 20 * Zoom / 20
            Triangle.angle = math.pi / 2 -- Bas
        end
    end
    if XofMap > -1426 then
        if love.keyboard.isDown("right") then
            XofMap = XofMap - 20 * Zoom / 20
            Triangle.angle = 0 -- Droite
        end
    end
    if XofMap < 0 then
        if love.keyboard.isDown("left") then
            XofMap = XofMap + 20 * Zoom / 20
            Triangle.angle = math.pi -- Gauche
        end
    end
    if love.keyboard.isDown("-") then
        Zoom = Zoom - 0.2
    end
    if love.keyboard.isDown("=") then
        Zoom = Zoom + 0.2
    end
    -- Premier rect = triangle approximé autour de (Triangle.x, Triangle.y)
    local x1 = Triangle.x - 15
    local y1 = Triangle.y - 15
    local w1 = 30
    local h1 = 30

    -- Deuxième rect = ta porte
    local x2 = 717 + XofMap
    local y2 = 108 + YofMap
    local w2 = 48
    local h2 = 97
    if WithinRectRect(x1, y1, w1, h1, x2, y2, w2, h2) then
        print("Collision avec la porte !")
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        print("x:" .. x)
        print("y:" .. y)
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(Map, XofMap, YofMap, 0, Zoom)
    -- Calcule les 3 points du triangle orienté
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
    DrawHouse(1300, 400)
end

-- Debug
local love_errorhandler = love.errorhandler
function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end

--717,108
--766,107
--765,205
--717,206
