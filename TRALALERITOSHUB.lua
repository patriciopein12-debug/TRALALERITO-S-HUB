local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")

local clickSound = Instance.new("Sound")
clickSound.Name = "BtnClickSound"
clickSound.SoundId = "rbxassetid://5952120301"
clickSound.Volume = 1
clickSound.Parent = SoundService

local blurEffect = Instance.new("BlurEffect")
blurEffect.Name = "HubBlur"
blurEffect.Size = 0
blurEffect.Parent = Lighting

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainHubGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = pGui

if not UserInputService.TouchEnabled then
        screenGui:Destroy()
        return
end

local function applyStyle(obj, radius)
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, radius or 12)
        corner.Parent = obj

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 2
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Transparency = 0.8
        stroke.Parent = obj
end

local introFrame = Instance.new("Frame")
introFrame.Size = UDim2.new(1, 0, 1, 0)
introFrame.BackgroundTransparency = 1
introFrame.ZIndex = 100
introFrame.Visible = false
introFrame.Parent = screenGui

local introImg = Instance.new("ImageLabel")
introImg.Size = UDim2.new(0.6, 0, 0.6, 0)
introImg.Position = UDim2.new(0.5, 0, 0.5, 0)
introImg.AnchorPoint = Vector2.new(0.5, 0.5)
introImg.BackgroundTransparency = 1
introImg.Image = "rbxassetid://136829429605675"
introImg.ImageTransparency = 1
introImg.ZIndex = 101
introImg.Parent = introFrame

local iAspect = Instance.new("UIAspectRatioConstraint")
iAspect.AspectRatio = 1
iAspect.Parent = introImg

local function squish(obj)
        clickSound:Play()
        local originalSize = obj:GetAttribute("OriginalSize")
        if not originalSize then
                originalSize = obj.Size
                obj:SetAttribute("OriginalSize", originalSize)
        end
        local down = TweenService:Create(obj, TweenInfo.new(0.05, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(originalSize.X.Scale * 0.8, originalSize.X.Offset * 0.8, originalSize.Y.Scale * 0.8, originalSize.Y.Offset * 0.8)})
        local up = TweenService:Create(obj, TweenInfo.new(0.1, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = originalSize})
        down:Play()
        down.Completed:Wait()
        up:Play()
end

local notifContainer = Instance.new("Frame")
notifContainer.Size = UDim2.new(0.3, 0, 0.5, 0)
notifContainer.Position = UDim2.new(0.02, 0, 0.98, 0)
notifContainer.AnchorPoint = Vector2.new(0, 1)
notifContainer.BackgroundTransparency = 1
notifContainer.Parent = screenGui

local notifLayout = Instance.new("UIListLayout")
notifLayout.Parent = notifContainer
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifLayout.Padding = UDim.new(0.02, 0)

local function sendNotification(msg, userId)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0.9, 0, 0.15, 0)
        frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        frame.BorderSizePixel = 0
        frame.Parent = notifContainer
        applyStyle(frame, 10)

        local img = Instance.new("ImageLabel")
        img.Size = UDim2.new(0.8, 0, 0.8, 0)
        img.Position = UDim2.new(0.05, 0, 0.1, 0)
        img.Image = Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        img.BackgroundTransparency = 1
        img.Parent = frame
        applyStyle(img, 100)

        local aspect = Instance.new("UIAspectRatioConstraint")
        aspect.AspectRatio = 1
        aspect.Parent = img

        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(0.7, 0, 0.8, 0)
        txt.Position = UDim2.new(0.28, 0, 0.1, 0)
        txt.Text = msg
        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
        txt.Font = Enum.Font.FredokaOne
        txt.TextScaled = true
        txt.BackgroundTransparency = 1
        txt.Parent = frame

        task.delay(5, function()
                local t = TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
                t:Play()
                t.Completed:Wait()
                frame:Destroy()
        end)
end

local openBtn = Instance.new("ImageButton")
openBtn.Size = UDim2.new(0, 60, 0, 60)
openBtn.Position = UDim2.new(1, -10, 0, -40)
openBtn.AnchorPoint = Vector2.new(1, 0)
openBtn.BackgroundTransparency = 1
openBtn.Image = "rbxassetid://72873827191190"
openBtn.Visible = false
openBtn.Parent = screenGui

local mainFrame = Instance.new("CanvasGroup")
mainFrame.Size = UDim2.new(0.8, 0, 0.6, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.GroupTransparency = 1
mainFrame.Visible = false
mainFrame.Parent = screenGui
applyStyle(mainFrame, 20)

local function toggleMenu()
        squish(openBtn)
        if not mainFrame.Visible then
                mainFrame.Visible = true
                TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()
                TweenService:Create(blurEffect, TweenInfo.new(0.4), {Size = 15}):Play()
        else
                local tFade = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {GroupTransparency = 1})
                TweenService:Create(blurEffect, TweenInfo.new(0.4), {Size = 0}):Play()

                tFade:Play()
                tFade.Completed:Wait()
                mainFrame.Visible = false
        end
end

openBtn.MouseButton1Click:Connect(toggleMenu)

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0.18, 0)
topBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
topBar.BorderSizePixel = 0
topBar.ZIndex = 10
topBar.Parent = mainFrame
applyStyle(topBar, 20)

local titleTxt = Instance.new("TextLabel")
titleTxt.Size = UDim2.new(0.5, 0, 0.6, 0)
titleTxt.Position = UDim2.new(0.15, 0, 0, 0)
titleTxt.Font = Enum.Font.FredokaOne
titleTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
titleTxt.TextScaled = true
titleTxt.TextXAlignment = Enum.TextXAlignment.Left
titleTxt.BackgroundTransparency = 1
titleTxt.ZIndex = 11
titleTxt.Parent = topBar

local infoTxt = Instance.new("TextLabel")
infoTxt.Size = UDim2.new(0.5, 0, 0.3, 0)
infoTxt.Position = UDim2.new(0.15, 0, 0.6, 0)
infoTxt.Font = Enum.Font.SourceSans
infoTxt.TextColor3 = Color3.fromRGB(200, 200, 200)
infoTxt.TextScaled = true
infoTxt.TextXAlignment = Enum.TextXAlignment.Left
infoTxt.BackgroundTransparency = 1
infoTxt.ZIndex = 11
infoTxt.Parent = topBar

local sideBar = Instance.new("Frame")
sideBar.Size = UDim2.new(0.12, 0, 1, 0)
sideBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
sideBar.BorderSizePixel = 0
sideBar.ZIndex = 10
sideBar.Parent = mainFrame
applyStyle(sideBar, 20)

local layout = Instance.new("UIListLayout")
layout.Parent = sideBar
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Padding = UDim.new(0.02, 0)

local pages = {}
local function createPage(name, isScrolling)
        local container = Instance.new("Frame")
        container.Name = name
        container.Size = UDim2.new(0.88, 0, 0.82, 0)
        container.Position = UDim2.new(0.12, 0, 0.18, 0)
        container.BackgroundTransparency = 1
        container.Visible = false
        container.ZIndex = 1
        container.Parent = mainFrame

        local pg
        if isScrolling then
                pg = Instance.new("ScrollingFrame")
                pg.Size = UDim2.new(1, 0, 1, 0)
                pg.AutomaticCanvasSize = Enum.AutomaticSize.Y
                pg.CanvasSize = UDim2.new(0, 0, 0, 0)
                pg.ScrollBarThickness = 4
                pg.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
                pg.BackgroundTransparency = 1
                pg.BorderSizePixel = 0
                pg.ZIndex = 2
                pg.Parent = container
        else
                pg = container
                pg.ZIndex = 2
        end

        pages[name] = container
        return pg
end

local homePg = createPage("Inicio", false)
local musicPg = createPage("Musica", true)
local playPg = createPage("Play", false)
local extraPg = createPage("Info", false)

local function showPage(name, title, info)
        for _, pg in pairs(pages) do pg.Visible = false end
        pages[name].Visible = true
        titleTxt.Text = title
        infoTxt.Text = info
end

local function createNavBtn(txt, target, title, info)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.85, 0, 0.15, 0)
        btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        btn.Text = txt
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.FredokaOne
        btn.TextScaled = true
        btn.BorderSizePixel = 0
        btn.ZIndex = 11
        btn.Parent = sideBar
        applyStyle(btn, 10)
        btn.MouseButton1Click:Connect(function()
                squish(btn)
                showPage(target, title, info)
        end)
end

createNavBtn("🏠", "Inicio", "I N I C I O", "PÁGINA PRINCIPAL")
createNavBtn("♫", "Musica", "M Ú S I C A", "TRACKS & VOL")
createNavBtn("▷", "Play", "P L A Y", "ESTADÍSTICAS")
createNavBtn("ⓘ", "Info", "I N F O", "ABOUT")

local userTxt = Instance.new("TextLabel")
userTxt.Text = "Hola, @" .. player.Name
userTxt.Size = UDim2.new(0.6, 0, 0.12, 0)
userTxt.Position = UDim2.new(0.05, 0, 0.05, 0)
userTxt.Font = Enum.Font.FredokaOne
userTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
userTxt.TextScaled = true
userTxt.TextXAlignment = Enum.TextXAlignment.Left
userTxt.BackgroundTransparency = 1
userTxt.ZIndex = 3
userTxt.Parent = homePg

local timeTxt = Instance.new("TextLabel")
timeTxt.Size = UDim2.new(0.4, 0, 0.08, 0)
timeTxt.Position = UDim2.new(0.05, 0, 0.2, 0)
timeTxt.Font = Enum.Font.SourceSansBold
timeTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
timeTxt.TextScaled = true
timeTxt.TextXAlignment = Enum.TextXAlignment.Left
timeTxt.BackgroundTransparency = 1
timeTxt.ZIndex = 3
timeTxt.Parent = homePg

local sessionTxt = Instance.new("TextLabel")
sessionTxt.Size = UDim2.new(0.4, 0, 0.08, 0)
sessionTxt.Position = UDim2.new(0.05, 0, 0.32, 0)
sessionTxt.Font = Enum.Font.SourceSansBold
sessionTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
sessionTxt.TextScaled = true
sessionTxt.TextXAlignment = Enum.TextXAlignment.Left
sessionTxt.BackgroundTransparency = 1
sessionTxt.ZIndex = 3
sessionTxt.Parent = homePg

local profileImg = Instance.new("ImageLabel")
profileImg.Size = UDim2.new(0.4, 0, 0.4, 0)
profileImg.Position = UDim2.new(0.55, 0, 0.05, 0)
profileImg.BackgroundTransparency = 1
profileImg.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
profileImg.ZIndex = 3
profileImg.Parent = homePg
applyStyle(profileImg, 100)

local pAspect = Instance.new("UIAspectRatioConstraint")
pAspect.AspectRatio = 1
pAspect.Parent = profileImg

local tralaleritoImg = Instance.new("ImageButton")
tralaleritoImg.Size = UDim2.new(0.5, 0, 0.5, 0)
tralaleritoImg.Position = UDim2.new(0.45, 0, 0.45, 0)
tralaleritoImg.BackgroundTransparency = 1
tralaleritoImg.Image = "rbxassetid://72873827191190"
tralaleritoImg.ZIndex = 3
tralaleritoImg.Parent = homePg

local tAspect = Instance.new("UIAspectRatioConstraint")
tAspect.AspectRatio = 1
tAspect.Parent = tralaleritoImg

tralaleritoImg.MouseButton1Click:Connect(function() squish(tralaleritoImg) end)

local musicList = Instance.new("UIListLayout")
musicList.Parent = musicPg
musicList.Padding = UDim.new(0.03, 0)
musicList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local currentSound = nil
local isLooping = false

local function createMusicBtn(name, id)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0.08, 0)
        btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        btn.Text = "Play: " .. name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.FredokaOne
        btn.TextScaled = true
        btn.BorderSizePixel = 0
        btn.ZIndex = 3
        btn.Parent = musicPg
        applyStyle(btn, 10)
        btn.MouseButton1Click:Connect(function()
                squish(btn)
                if currentSound then currentSound:Stop() currentSound:Destroy() end
                currentSound = Instance.new("Sound")
                currentSound.SoundId = "rbxassetid://" .. id
                currentSound.Volume = musicPg:GetAttribute("HubVol") or 0.5
                currentSound.Looped = isLooping
                currentSound.Parent = SoundService
                currentSound:Play()
        end)
end

createMusicBtn("hotel", "1839029458")
createMusicBtn("Chill", "15689459403")
createMusicBtn("Relaxed Scene", "1848354536")
createMusicBtn("2020", "76908132937245")
createMusicBtn("HELLO", "110788401793874")
createMusicBtn("NEET LOFI", "82023266189604")
createMusicBtn("Living Mice", "137193013430017")

local loopContainer = Instance.new("Frame")
loopContainer.Size = UDim2.new(0.9, 0, 0.1, 0)
loopContainer.BackgroundTransparency = 1
loopContainer.ZIndex = 3
loopContainer.Parent = musicPg

local loopTxt = Instance.new("TextLabel")
loopTxt.Size = UDim2.new(0.7, 0, 1, 0)
loopTxt.Text = "BUCLE MÚSICA"
loopTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
loopTxt.Font = Enum.Font.FredokaOne
loopTxt.TextScaled = true
loopTxt.BackgroundTransparency = 1
loopTxt.TextXAlignment = Enum.TextXAlignment.Left
loopTxt.ZIndex = 4
loopTxt.Parent = loopContainer

local loopBar = Instance.new("Frame")
loopBar.Size = UDim2.new(0.25, 0, 0.4, 0)
loopBar.Position = UDim2.new(0.75, 0, 0.5, 0)
loopBar.AnchorPoint = Vector2.new(0, 0.5)
loopBar.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
loopBar.ZIndex = 4
loopBar.Parent = loopContainer
applyStyle(loopBar, 100)

local loopHandle = Instance.new("TextButton")
loopHandle.Size = UDim2.new(0.5, 0, 1.5, 0)
loopHandle.Position = UDim2.new(0, 0, 0.5, 0)
loopHandle.AnchorPoint = Vector2.new(0, 0.5)
loopHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
loopHandle.Text = ""
loopHandle.ZIndex = 5
loopHandle.Parent = loopBar
applyStyle(loopHandle, 100)

loopHandle.MouseButton1Click:Connect(function()
        clickSound:Play()
        isLooping = not isLooping
        local targetPos = isLooping and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0, 0, 0.5, 0)
        local targetCol = isLooping and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(50, 0, 0)
        TweenService:Create(loopHandle, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(loopBar, TweenInfo.new(0.2), {BackgroundColor3 = targetCol}):Play()
        if currentSound then currentSound.Looped = isLooping end
end)

local function createSlider(label, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0.9, 0, 0.12, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 3
        container.Parent = musicPg
        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(1, 0, 0.4, 0)
        txt.Text = label
        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
        txt.Font = Enum.Font.FredokaOne
        txt.TextScaled = true
        txt.BackgroundTransparency = 1
        txt.ZIndex = 4
        txt.Parent = container
        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, 0, 0.2, 0)
        bar.Position = UDim2.new(0, 0, 0.6, 0)
        bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        bar.ZIndex = 4
        bar.Parent = container
        applyStyle(bar, 100)
        local handle = Instance.new("TextButton")
        handle.Size = UDim2.new(0.1, 0, 2.5, 0)
        handle.AnchorPoint = Vector2.new(0.5, 0.5)
        handle.Position = UDim2.new(0.5, 0, 0.5, 0)
        handle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        handle.BorderSizePixel = 0
        handle.Text = ""
        handle.ZIndex = 5
        handle.Parent = bar
        applyStyle(handle, 100)
        local dragging = false
        handle.MouseButton1Down:Connect(function() dragging = true end)
        UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
        RunService.RenderStepped:Connect(function()
                if dragging then
                        local mousePos = UserInputService:GetMouseLocation().X
                        local relativePos = math.clamp((mousePos - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                        handle.Position = UDim2.new(relativePos, 0, 0.5, 0)
                        callback(relativePos)
                end
        end)
end

musicPg:SetAttribute("HubVol", 0.5)
createSlider("VOL HUB", function(v)
        musicPg:SetAttribute("HubVol", v)
        if currentSound then currentSound.Volume = v end
end)

createSlider("VOL JUEGO", function(v)
        for _, s in pairs(game:GetDescendants()) do
                if s:IsA("Sound") and s ~= currentSound then s.Volume = v end
        end
end)

local infoLayout = Instance.new("UIListLayout")
infoLayout.Parent = extraPg
infoLayout.Padding = UDim.new(0.02, 0)
infoLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createInfoLine(t1, t2)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(0.9, 0, 0.1, 0)
        l.BackgroundTransparency = 1
        l.Font = Enum.Font.FredokaOne
        l.TextColor3 = Color3.fromRGB(255, 255, 255)
        l.TextScaled = true
        l.ZIndex = 3
        l.Text = t1 .. ": " .. (t2 or "")
        l.Parent = extraPg
end

createInfoLine("CREADOR", "Patricio")
createInfoLine("ASISTENTE", "Gemini AI")
createInfoLine("PROYECTO", "Tralalerito Hub")
createInfoLine("VERSION", "1.2.0")
createInfoLine("SHARK STYLE", "Nike Air Force 1")

local statsLayout = Instance.new("UIListLayout")
statsLayout.Parent = playPg
statsLayout.Padding = UDim.new(0.05, 0)
statsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createStat(label)
        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(0.9, 0, 0.1, 0)
        txt.Font = Enum.Font.FredokaOne
        txt.TextScaled = true
        txt.BackgroundTransparency = 1
        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
        txt.ZIndex = 3
        txt.Text = label .. ": 0"
        txt.Parent = playPg
        return txt
end

local distStat = createStat("Distancia")
local jumpStat = createStat("Saltos")
local touchStat = createStat("Toques")

local totalDist, totalJumps, totalTouches = 0, 0, 0
local lastPos = nil
local isJumping = false

local function connectChar(char)
        local hum = char:WaitForChild("Humanoid")
        lastPos = char.PrimaryPart.Position
        hum.StateChanged:Connect(function(_, newState)
                if newState == Enum.HumanoidStateType.Jumping and not isJumping then
                        isJumping = true
                        totalJumps = totalJumps + 1
                        jumpStat.Text = "Saltos: " .. totalJumps
                        task.wait(0.5)
                        isJumping = false
                end
        end)
end

if player.Character then connectChar(player.Character) end
player.CharacterAdded:Connect(connectChar)

UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                totalTouches = totalTouches + 1
                touchStat.Text = "Toques: " .. totalTouches
        end
end)

Players.PlayerAdded:Connect(function(p) sendNotification(p.Name .. " se unió", p.UserId) end)
Players.PlayerRemoving:Co