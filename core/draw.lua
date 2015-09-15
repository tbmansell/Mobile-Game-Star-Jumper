local storyboard = require("storyboard")
local TextCandy  = require("text_candy.lib_text_candy")
local anim       = require("core.animations")

-- Aliases:
local math_round  = math.round
local math_random = math.random
local play        = realPlayer
local new_image   = display.newImage


TextCandy.AddCharsetFromBMF("gamefont_aqua",   "text_candy/ingamefont_aqua.fnt",   32)
TextCandy.AddCharsetFromBMF("gamefont_blue",   "text_candy/ingamefont_blue.fnt",   32)
TextCandy.AddCharsetFromBMF("gamefont_green",  "text_candy/ingamefont_green.fnt",  32)
TextCandy.AddCharsetFromBMF("gamefont_pink",   "text_candy/ingamefont_pink.fnt",   32)
TextCandy.AddCharsetFromBMF("gamefont_purple", "text_candy/ingamefont_purple.fnt", 32)
TextCandy.AddCharsetFromBMF("gamefont_red",    "text_candy/ingamefont_red.fnt",    32)
TextCandy.AddCharsetFromBMF("gamefont_white",  "text_candy/ingamefont_white.fnt",  32)
TextCandy.AddCharsetFromBMF("gamefont_grey",   "text_candy/ingamefont_grey.fnt",   32)
TextCandy.AddCharsetFromBMF("gamefont_yellow", "text_candy/ingamefont_yellow.fnt", 32)
TextCandy.AddCharsetFromBMF("gamefont_black",  "text_candy/ingamefont_black.fnt",  32)


-- handles text generation using text candy
function newText(group, text, x, y, scale, color, align, wrapWidth)
    local font = TextCandy.CreateText({
        fontName    = "gamefont_"..color,
        x           = x,
        y           = y,
        text        = text,
        textFlow    = align,
        fontSize    = size,
        originX     = align,
        originY     = "CENTER",
        wrapWidth   = wrapWidth or nil,
        lineSpacing = 0,
        showOrigin  = false,
        parentGroup = group,
    })

    if scale ~= 1 then
        font:scale(scale,scale)
    end

    return font
end


-- handles image generation, using base folder and optional scaling and alpha
function newImage(group, image, x, y, scale, alpha)
    local image = new_image(group, "images/"..image..".png", x, y)

    if scale then image:scale(scale, scale) end
    if alpha then image.alpha = alpha end

    return image
end


-- Creates an area that size of the screen that captures touch/tap events
function newBlocker(group, alpha, r,g,b, onclick, touchEvent)
    -- default to blocking all tap and touch events
    if onclick == nil then 
        onclick = function() return true end
    end

    local rect = display.newRect(group, centerX, centerY, 1200, 1000)
    rect.alpha = alpha or 0.5
    rect:setFillColor(r or 0, g or 0, b or 0)
    rect:addEventListener("tap", onclick)

    if touchEvent == "block" then
        rect:addEventListener("touch", function() return true end)
    elseif touchEvent ~= "ignore" then
        rect:addEventListener("touch", onclick)
    end

    return rect
end


-- Creates an image button that shows it's depression, makes a sound and triggers an function
function newButton(group, x, y, image, callback, clickSound, size)
    local btn        = newImage(group, "buttons/button-"..image.."-up",   x, y)
    local btnOverlay = newImage(group, "buttons/button-"..image.."-down", x, y, nil, 0)

    --[[if labelParams then
        newText(group, labelParams.text, x+100, y+30, labelParams.size, labelParams.color, "CENTER")
    end]]
    if size then
        btn:scale(size, size)
        btnOverlay:scale(size, size)
    end

    btn:addEventListener("tap", function(event)
        if not clickSound or clicksound ~= "no" then
            play(clickSound or sounds.sceneEnter)
        end
        btn.alpha, btnOverlay.alpha = 0, 1
        after(150, function()
            callback()
            btn.alpha, btnOverlay.alpha = 1, 0
        end)
        return true
    end)

    return btn, btnOverlay
end


-- Displays the common menu hud
function newMenuHud(group, spineStore, tapCubeCallback, tapScoreCallback)
    local game       = state.data.gameSelected    
    local playerName = characterData[state.data.playerModel].name
    local bgr        = newImage(group, "hud/menu-hud", centerX, 562)
    local cube       = spineStore:showHoloCube(70, 615, 0.65)
    local playerIcon = newImage(group, "hud/player-head-"..playerName, 885, 580, 0.85, 0.30)
    local labelCubes = newText(group, state.data.holocubes, 70,  590, 0.7, "white",  "CENTER")
    local labelScore = newText(group, state.data.score,     880, 590, 0.7, "yellow", "CENTER")

    -- block touch events
    bgr:addEventListener("touch", function() return true end)

    if tapCubeCallback then
        cube.tap = tapCubeCallback
        cube.image:addEventListener("tap", cube)
    end

    if tapScoreCallback then
        playerIcon.tap = tapScoreCallback
        playerIcon:addEventListener("tap", playerIcon)
    end

    group:insert(cube.image)
    labelCubes:toFront()
    labelScore:toFront()

    -- return items that need to be referenced and removed afterward
    return labelCubes, labelScore, playerIcon
end


-- Displays the locked popup with info relelvent to the item that was locked
function newLockedPopup(sceneGroup, id, type, title, description)
    local group = display.newGroup()

    local exitHandler = function()
        group:removeSelf()
        return true
    end

    local buyHandler = function()
        group:removeSelf()
        storyboard:gotoScene("scenes.inapp-purchases")
        return true
    end

    local buymode = "both"
    local planet  = state.data.planetSelected or 1
    local blocker = newBlocker(group, 0.8, 0,0,0, exitHandler, "block")
    local popup   = newImage(group, "locking/popup", centerX, centerY)

    popup:addEventListener("tap", function() return true end)

    if type == "planet" then
        newImage(group, "select-game/race-zone-green", 170, 265)

        local other = id-1
        local zones = 5 - state:numberZonesCompleted(other, gameTypeStory)
        description = "complete "..zones.." zones in "..planetData[other].name.." to unlock"
        planet      = id

    elseif type == "game" then
        newImage(group, "select-game/tab-"..gameTypeData[id].icon, 170, 265, 0.35)

    elseif type == "character" then
        newImage(group, "select-player/head-"..characterData[id].name.."-selected", 170, 265, 0.8)
        
        buymode = characterData[id].buyMode
        local charPlanet = characterData[id].planet
        local planetName = planetData[charPlanet].name

        if buymode == "storeOnly" then
            description = characterData[id].lockText
        elseif not state:planetUnlocked(charPlanet) then
            description = "unlock and complete "..planetName.." to unlock"
        else
            local zones = planetData[charPlanet].normalZones - state:numberZonesCompleted(charPlanet, gameTypeStory)
            description = "complete "..zones.." zones in "..planetName.." to unlock"
        end
    elseif type == "gear" then
        newImage(group, "collectables/gear-"..gearNames[gearSlots[id]].."-"..id, 170, 265, 0.5)

        local zones = gearUnlocks[id].unlockAfter - state:totalStoryZonesCompleted()
        buymode     = gearUnlocks[id].buyMode
        description = "complete "..zones.." zones to unlock"
    end

    newText(group, title,       370, 160, 0.8, "red",   "CENTER")
    newText(group, description, 370, 260, 0.5, "white", "CENTER", 550)

    if buymode == "storeOnly" or buymode == "both" then
        newImage(group, "locking/buy-to-unlock", 170, 410)
        newText(group, "purchase in store", 370, 400, 0.5, "white", "CENTER")

        if buymode == "both" then
            newText(group, "or", 170, 400, 0.8, "red")
        end
    end

    state.inappPurchaseType = "planet"
    if type == "gear" then state.inappPurchaseType = "gear" end

    newImage(group, "locking/popup-advert"..planet, 700, 300)
    newButton(group, 370, 455, "close", exitHandler)
    newButton(group, 700, 455, "buy",   buyHandler)
end


-- Randomly modifies an images RGB and alpha values
function randomizeImage(image, doAlpha, alphaMin)
    local r, g, b = math_random(), math_random(), math_random()

    if image.setFillColor ~= nil then
        image:setFillColor(r,g,b)
    end

    if doAlpha then
        local alpha = math_random()
        local min   = alphaMin or 0

        if alpha < min then alpha = min end
        image.alpha = alpha
    end
end


-- Resets and images RGB values
function restoreImage(image)
    if image.setFillColor ~= nil then
        image:setFillColor(1,1,1)
    end
    image.alpha = 1
end


-- Loads the mid-sceen scene
function loadSceneTransition(time)
    globalSceneTransitionGroup.alpha = 0
    local bgr = display.newRect(globalSceneTransitionGroup, centerX, centerY, contentWidth+200, contentHeight+200)
    bgr:setFillColor(0,0,0)

    newImage(globalSceneTransitionGroup, "scene-transition", centerX, centerY)

    globalSceneTransitionGroup:toFront()
    transition.to(globalSceneTransitionGroup, {alpha=1, time=time or 1000})
end


-- Clear the mid-screen scene
function clearSceneTransition(time)
    if time then
        transition.to(globalSceneTransitionGroup, {alpha=0, time=time, onComplete=function()
            globalSceneTransitionGroup:removeSelf()
            globalSceneTransitionGroup = display.newGroup()
        end})
    else
        globalSceneTransitionGroup:removeSelf()
        globalSceneTransitionGroup = display.newGroup()
    end
end


-- Used for debugging performance stats over all over display objects
-- requires globalFPS be incremented in enterFrame handler
function displayPerformance()
    local data = "mem usage: "..math_round(collectgarbage("count")/1024).." mb|texture mem: "..math_round(system.getInfo("textureMemoryUsed") / 1024/1024).." mb|fps: "..globalFPS
    globalFPS = 0

    if globalPerformanceLabel == nil then
        globalPerformanceLabel = newText(nil, data, 50, 110, 0.4, "white", "LEFT", 1000)
    else
        globalPerformanceLabel:setText(data)
    end
    globalPerformanceLabel:toFront()
end


function capitalise(s)
    return string.upper(string.sub(s,1,1))..string.sub(s,2)
end

