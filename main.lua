-- ╔══════════════════════════════════════════╗
-- ║         AequorUI  —  main.lua            ║
-- ║   Loader · Düşük seviye executor uyumlu  ║
-- ╚══════════════════════════════════════════╝

local BASE_URL = "https://raw.githubusercontent.com/hnwiie/scripts/refs/heads/main/"
local TweenService = game:GetService("TweenService")

-- ── Ham kaynak kodunu çek (BOM temizle) ───────────────────────────────────
local function Fetch(name)
    local src = game:HttpGet(BASE_URL .. name .. ".lua", true)
    src = src:gsub("^\xEF\xBB\xBF", "")  -- UTF-8 BOM temizle
    return src
end

-- ── Kaynak kodu çalıştır, return değerini al ─────────────────────────────
local function Exec(src, name)
    local fn, err = loadstring(src)
    if not fn then
        error("[AequorUI] Parse hatası (" .. name .. "): " .. tostring(err))
    end
    local ok, result = pcall(fn)
    if not ok then
        error("[AequorUI] Çalıştırma hatası (" .. name .. "): " .. tostring(result))
    end
    return result
end

-- ─────────────────────────────────────────────────────────────────────────
-- ADIM 1: Bağımsız modülleri yükle (script.Parent yok, sorunsuz çalışır)
-- ─────────────────────────────────────────────────────────────────────────
local ThemeManager = Exec(Fetch("ThemeManager"), "ThemeManager")
local IconManager  = Exec(Fetch("IconManager"),  "IconManager")

-- _G'ye koy → bağımlı modüller buradan alacak
_G.AequorUI = _G.AequorUI or {}
_G.AequorUI.ThemeManager = ThemeManager
_G.AequorUI.IconManager  = IconManager

-- ─────────────────────────────────────────────────────────────────────────
-- ADIM 2: Bağımlı modüllerin içindeki require(script...) satırlarını patch'le
-- ─────────────────────────────────────────────────────────────────────────
local function PatchAndLoad(name)
    local src = Fetch(name)

    -- require(script.Parent:WaitForChild("ThemeManager"))
    --   → _G.AequorUI.ThemeManager
    src = src:gsub(
        'require%s*%(%s*script%.Parent%s*:%s*WaitForChild%s*%(%s*"ThemeManager"%s*%)%s*%)',
        '_G.AequorUI.ThemeManager'
    )

    -- require(script.Parent:WaitForChild("IconManager"))
    --   → _G.AequorUI.IconManager
    src = src:gsub(
        'require%s*%(%s*script%.Parent%s*:%s*WaitForChild%s*%(%s*"IconManager"%s*%)%s*%)',
        '_G.AequorUI.IconManager'
    )

    return Exec(src, name)
end

local GeneralUI      = PatchAndLoad("GeneralUI")
local TabManager     = PatchAndLoad("TabManager")
local ElementManager = PatchAndLoad("ElementManager")

-- _G'yi de güncelle (ileride işe yarayabilir)
_G.AequorUI.GeneralUI      = GeneralUI
_G.AequorUI.TabManager     = TabManager
_G.AequorUI.ElementManager = ElementManager

-- ─────────────────────────────────────────────────────────────────────────
-- ADIM 3: AddContainer helper (LocalScript'ten gelen, kütüphanenin parçası)
-- ─────────────────────────────────────────────────────────────────────────
local function AddContainer(container, titleText, descText)
    local theme = ThemeManager:GetTheme()

    local itemFrame = Instance.new("Frame")
    itemFrame.Name = "ItemModule"
    itemFrame.Size = UDim2.new(1, 0, 0, 48)
    itemFrame.BackgroundColor3 = theme.MainColor
    itemFrame.BackgroundTransparency = 0.5
    itemFrame.BorderSizePixel = 0
    itemFrame.ClipsDescendants = true
    itemFrame.Active = true
    itemFrame.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = itemFrame

    local stroke = Instance.new("UIStroke")
    stroke.Transparency = 0.85
    stroke.Color = theme.SelectionColor
    stroke.Thickness = 0.8
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = itemFrame

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft  = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)
    padding.Parent = itemFrame

    local title = Instance.new("TextLabel")
    title.Name           = "Title"
    title.Size           = UDim2.new(1, 0, 0, 20)
    title.Position       = UDim2.new(0, 0, 0, 7)
    title.BackgroundTransparency = 1
    title.Text           = titleText
    title.TextColor3     = Color3.fromRGB(255, 255, 255)
    title.Font           = Enum.Font.GothamMedium
    title.TextSize       = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextTruncate   = Enum.TextTruncate.AtEnd
    title.ZIndex         = 2
    title.Parent         = itemFrame

    local desc = Instance.new("TextLabel")
    desc.Name             = "Description"
    desc.Size             = UDim2.new(1, 0, 0, 14)
    desc.Position         = UDim2.new(0, 0, 0, 25)
    desc.BackgroundTransparency = 1
    desc.Text             = descText
    desc.TextColor3       = Color3.fromRGB(230, 240, 245)
    desc.TextTransparency = 0.4
    desc.Font             = Enum.Font.Gotham
    desc.TextSize         = 11
    desc.TextXAlignment   = Enum.TextXAlignment.Left
    desc.TextTruncate     = Enum.TextTruncate.AtEnd
    desc.ZIndex           = 2
    desc.Parent           = itemFrame

    ThemeManager:RegisterContainer(itemFrame, stroke)

    itemFrame.MouseEnter:Connect(function()
        game:GetService("Players").LocalPlayer:GetMouse().Icon = "rbxasset://SystemCursors/PointingHand"
        TweenService:Create(itemFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart), { BackgroundTransparency = 0.4 }):Play()
        TweenService:Create(stroke,    TweenInfo.new(0.25, Enum.EasingStyle.Quart), { Transparency = 0.7 }):Play()
    end)

    itemFrame.MouseLeave:Connect(function()
        game:GetService("Players").LocalPlayer:GetMouse().Icon = ""
        TweenService:Create(itemFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart), { BackgroundTransparency = 0.5 }):Play()
        TweenService:Create(stroke,    TweenInfo.new(0.25, Enum.EasingStyle.Quart), { Transparency = 0.85 }):Play()
    end)

    return itemFrame
end

-- ─────────────────────────────────────────────────────────────────────────
-- ADIM 4: Kullanıcıya API'yi döndür
-- ─────────────────────────────────────────────────────────────────────────
return {
    ThemeManager   = ThemeManager,
    IconManager    = IconManager,
    GeneralUI      = GeneralUI,
    TabManager     = TabManager,
    ElementManager = ElementManager,
    AddContainer   = AddContainer,
}
