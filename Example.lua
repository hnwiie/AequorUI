-- ╔══════════════════════════════════════════════════════════════╗
-- ║              AequorUI — Full Documented Example              ║
-- ╚══════════════════════════════════════════════════════════════╝

--[[
  MODULES returned after loading:
    AequorUI.GeneralUI       → creates the main window
    AequorUI.TabManager      → sidebar tabs
    AequorUI.ElementManager  → all UI elements
    AequorUI.ThemeManager    → themes, colors, transparency
    AequorUI.IconManager     → tab icons
    AequorUI.AddContainer    → plain hover-animated container

  ELEMENT API — every element returns a table, not a raw Frame:
    .Frame          → the actual Roblox Instance
    .Value          → current value (Toggle=bool, Slider=number, Dropdown=string, ColorPicker=Color3)
    :SetValue(v)    → set value programmatically, updates visual + fires all callbacks
    :OnChanged(fn)  → register an extra callback (can call multiple times)
    Button / Paragraph / Clipboard have no .Value or :SetValue()
]]


-- ══════════════════════════════════════════
--  LOAD
-- ══════════════════════════════════════════

local AequorUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/hnwiie/AequorUI/refs/heads/main/main.lua", true
))()


-- ══════════════════════════════════════════
--  MAIN WINDOW  —  GeneralUI:CreateMain()
-- ══════════════════════════════════════════

--[[
  GeneralUI:CreateMain(toggleKey, themeName)
    toggleKey → Enum.KeyCode — key to show/hide the window
    themeName → string       — starting theme:
                "Aqua" | "Violet" | "Smoke" | "Scarlet"
                "Lemon" | "Light" | "Rose"  | "Custom"
  Returns → ScreenGui

  NOTE: Define ThemeManager.Decorations BEFORE this call.
        Decorations are baked in during window creation.
]]

local screenGui = AequorUI.GeneralUI:CreateMain(Enum.KeyCode.L, "Aqua")
local mainFrame = screenGui:WaitForChild("MainFrame")
local divider   = mainFrame:WaitForChild("Divider")


-- ══════════════════════════════════════════
--  TABS  —  TabManager
-- ══════════════════════════════════════════

--[[
  TabManager:Init(mainFrame)
    Call once before creating tabs. Returns → myTabs object.

  myTabs properties:
    .SelectionBar → sliding bar that follows the active tab
    .BoundaryLine → vertical divider between sidebar and content

  myTabs:CreateTab(name, iconName, layoutOrder)
    name        → sidebar label
    iconName    → built-in keys: "Home" | "Settings" | "Search" | "Target"
                                 "Combat" | "Movement" | "Eyes" | "Human" | "Humans"
                  custom keys also work — see IconManager:AddCustomIcon()
    layoutOrder → position in sidebar (1 = top)
    Returns → tabButton, container
      tabButton:WaitForChild("Icon") → ImageLabel
      tabButton:WaitForChild("Glow") → glow frame behind active tab
      container → ScrollingFrame where elements go
]]

local myTabs = AequorUI.TabManager:Init(mainFrame)

local tab1, container1 = myTabs:CreateTab("Home",     "Home",     1)
local tab2, container2 = myTabs:CreateTab("Settings", "Settings", 2)
local tab3, container3 = myTabs:CreateTab("Store",    "Search",   3)
local tab4, container4 = myTabs:CreateTab("Profile",  "Human",    4)


-- ══════════════════════════════════════════
--  ELEMENTS  —  ElementManager
-- ══════════════════════════════════════════

-- ── PARAGRAPH ──────────────────────────────────────────────────────
--[[
  Read-only info box. Height auto-adjusts to text length.
  No callback, no config, no SetValue.

  ElementManager:CreateParagraph(container, title, description)
  Returns → { Frame }
]]

AequorUI.ElementManager:CreateParagraph(container1,
    "Script News",
    "Welcome to AequorUI. You can test all elements below."
)

AequorUI.ElementManager:CreateParagraph(container4,
    "Account Info",
    "Manage your profile settings from here."
)


-- ── CLIPBOARD ──────────────────────────────────────────────────────
--[[
  Copies a string to clipboard on click.
  Requires executor setclipboard() support.
  No callback, no config, no SetValue.

  ElementManager:CreateClipboard(container, title, description, textToCopy)
  Returns → { Frame }
]]

AequorUI.ElementManager:CreateClipboard(container1,
    "Discord Link",
    "Click to copy.",
    "https://discord.gg/aequor"
)

AequorUI.ElementManager:CreateClipboard(container3,
    "Discount Code",
    "Copy and use the code.",
    "AEQUOR2025"
)


-- ── BUTTON ─────────────────────────────────────────────────────────
--[[
  Clickable button. Fires callback() on click.

  ElementManager:CreateButton(container, title, description, callback)
  ElementManager:CreateButton(container, title, description, callback, config)

  config (optional):
    GlowColor → Color3 — glow on click        (default: theme SelectionColor)
    IconColor → Color3 — arrow ">" color      (default: white)

  Returns → { Frame, :OnChanged(fn) }
  No .Value or :SetValue() — use :OnChanged() for extra click listeners.
]]

-- default
AequorUI.ElementManager:CreateButton(container1,
    "Teleport",
    "Teleport to spawn.",
    function() print("Teleport!") end
)

-- custom glow
AequorUI.ElementManager:CreateButton(container1,
    "Kill Aura",
    "Affect everyone nearby.",
    function() print("Kill Aura!") end,
    { GlowColor = Color3.fromRGB(255, 60, 60), IconColor = Color3.fromRGB(255, 180, 180) }
)

AequorUI.ElementManager:CreateButton(container1,
    "Collect Coins",
    "Collect all coins on the map.",
    function() print("Coins!") end,
    { GlowColor = Color3.fromRGB(255, 210, 0), IconColor = Color3.fromRGB(255, 240, 150) }
)

-- :OnChanged() — register an extra listener after creation
local resetBtn = AequorUI.ElementManager:CreateButton(container2,
    "Reset Settings",
    "Reset all settings to default.",
    function() print("Reset!") end,
    { GlowColor = Color3.fromRGB(255, 80, 80), IconColor = Color3.fromRGB(255, 200, 200) }
)
resetBtn:OnChanged(function()
    print("Extra reset listener fired!")
end)

AequorUI.ElementManager:CreateButton(container3,
    "Buy Now",
    "Purchase the premium pack.",
    function() print("Buy!") end,
    { GlowColor = Color3.fromRGB(80, 220, 120), IconColor = Color3.fromRGB(180, 255, 200) }
)

AequorUI.ElementManager:CreateButton(container4,
    "Logout",
    "Sign out of your account.",
    function() print("Logout!") end,
    { GlowColor = Color3.fromRGB(200, 60, 60), IconColor = Color3.fromRGB(255, 180, 180) }
)


-- ── TOGGLE ─────────────────────────────────────────────────────────
--[[
  On/off switch. Fires callback(state) — state is true or false.

  ElementManager:CreateToggle(container, title, description, callback)
  ElementManager:CreateToggle(container, title, description, callback, config)

  config (optional):
    OnColor  → Color3 — background when ON   (default: green)
    OffColor → Color3 — background when OFF  (default: grey)
    DotColor → Color3 — the sliding dot      (default: white)

  Returns → { Frame, .Value, :SetValue(bool), :OnChanged(fn) }
]]

-- default
local aimbotToggle = AequorUI.ElementManager:CreateToggle(container1,
    "Aimbot",
    "Automatic target locking.",
    function(state) print("Aimbot:", state) end
)

aimbotToggle:SetValue(true)           -- turn on at startup (e.g. load saved config)
print("Aimbot:", aimbotToggle.Value)  -- read current value

aimbotToggle:OnChanged(function(state)
    print("Aimbot extra listener:", state)
end)

-- custom colors
AequorUI.ElementManager:CreateToggle(container1,
    "Speed Hack",
    "Custom colored toggle example.",
    function(state) print("Speed Hack:", state) end,
    {
        OnColor  = Color3.fromRGB(255, 100, 0),
        OffColor = Color3.fromRGB(60, 60, 60),
        DotColor = Color3.fromRGB(255, 255, 255),
    }
)

AequorUI.ElementManager:CreateToggle(container2,
    "Notifications",
    "Enable or disable notifications.",
    function(state) print("Notifications:", state) end
)


-- ── SLIDER ─────────────────────────────────────────────────────────
--[[
  Draggable slider, returns integer values. Fires callback(value).

  ElementManager:CreateSlider(container, title, description, min, max, default, callback)
  ElementManager:CreateSlider(container, title, description, min, max, default, callback, config)

  config (optional):
    TrackColor → Color3 — full track background  (default: dark grey)
    FillColor  → Color3 — filled portion color   (default: theme SelectionColor)
    DotColor   → Color3 — draggable handle       (default: white)

  Returns → { Frame, .Value, :SetValue(number), :OnChanged(fn) }
  :SetValue() clamps to [min, max].
]]

-- default
local speedSlider = AequorUI.ElementManager:CreateSlider(container1,
    "Walk Speed",
    "Adjust movement speed.",
    0, 100, 16,
    function(val)
        print("Walk Speed:", val)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = val
        end
    end
)

speedSlider:SetValue(32)               -- set programmatically
print("Speed:", speedSlider.Value)     -- read current value

-- custom colors
local jumpSlider = AequorUI.ElementManager:CreateSlider(container1,
    "Jump Power",
    "Adjust jump height.",
    0, 200, 50,
    function(val)
        print("Jump Power:", val)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = val
        end
    end,
    {
        TrackColor = Color3.fromRGB(40, 40, 40),
        FillColor  = Color3.fromRGB(255, 80, 80),
        DotColor   = Color3.fromRGB(50, 2, 200),
    }
)

jumpSlider:OnChanged(function(val)
    print("Jump Power extra listener:", val)
end)

AequorUI.ElementManager:CreateSlider(container2,
    "UI Scale",
    "Adjust interface size.",
    50, 150, 100,
    function(val) print("UI Scale:", val) end
)


-- ── DROPDOWN ───────────────────────────────────────────────────────
--[[
  Dropdown menu. Fires callback(selected) with the chosen string.
  Panel opens centered, closes on selection or outside click.

  ElementManager:CreateDropdown(container, title, description, options, default, callback)
  ElementManager:CreateDropdown(container, title, description, options, default, callback, config)

  config (optional):
    SelectionBarColor → Color3 — small bar beside active option
    GlowColor         → Color3 — glow on active option

  Returns → { Frame, .Value, :SetValue(string), :OnChanged(fn) }
  :SetValue() does nothing if the value is not in the options list.
]]

-- default
local weaponDrop = AequorUI.ElementManager:CreateDropdown(container1,
    "Weapon",
    "Select your weapon.",
    {"Sword", "Bow", "Staff", "Dagger", "Axe"},
    "Sword",
    function(sel) print("Weapon:", sel) end
)

weaponDrop:SetValue("Axe")             -- set programmatically
print("Weapon:", weaponDrop.Value)     -- read current value

-- custom colors
local elementDrop = AequorUI.ElementManager:CreateDropdown(container1,
    "Element",
    "Select your element.",
    {"Fire", "Water", "Earth", "Air", "Lightning"},
    "Fire",
    function(sel) print("Element:", sel) end,
    {
        SelectionBarColor = Color3.fromRGB(255, 50, 50),
        GlowColor         = Color3.fromRGB(255, 200, 0),
    }
)

elementDrop:OnChanged(function(sel)
    print("Element extra listener:", sel)
end)

-- live theme switcher using dropdown
AequorUI.ElementManager:CreateDropdown(container2,
    "Theme",
    "Switch the UI theme live.",
    {"Aqua", "Violet", "Smoke", "Scarlet", "Lemon", "Light", "Rose"},
    "Aqua",
    function(sel)
        AequorUI.ThemeManager:SetTheme(sel, mainFrame)
    end
)


-- ── COLOR PICKER ───────────────────────────────────────────────────
--[[
  Full HSV color picker. Opens on preview box click.
  Has Done and Cancel buttons.
  Callback fires only on Done. Cancel reverts to last confirmed color.
  No config — panel style follows the active theme automatically.

  ElementManager:CreateColorPicker(container, title, description, defaultColor, callback)
  Returns → { Frame, .Value, :SetValue(Color3), :OnChanged(fn) }
]]

local espColor = AequorUI.ElementManager:CreateColorPicker(container1,
    "ESP Color",
    "Select the ESP line color.",
    Color3.fromRGB(255, 100, 100),
    function(color) print("ESP Color:", color) end
)

espColor:SetValue(Color3.fromRGB(255, 100, 100))  -- load from saved config
print("Current ESP color:", espColor.Value)

espColor:OnChanged(function(color)
    print("ESP Color extra listener:", color)
end)


-- ── ADD CONTAINER ──────────────────────────────────────────────────
--[[
  A plain styled frame with title + description.
  Has a smooth hover animation (transparency shift + pointer cursor).
  Useful for custom rows or grouping content.
  Returns a raw Frame (not an API table) — parent children directly to it.

  AequorUI.AddContainer(container, title, description)  →  Frame
]]

local myRow = AequorUI.AddContainer(container1,
    "Custom Row",
    "Hover-animated container. Parent extra instances to it."
)
-- local lbl = Instance.new("TextLabel")
-- lbl.Parent = myRow


-- ══════════════════════════════════════════
--  THEME MANAGER
-- ══════════════════════════════════════════

-- ── SET THEME ──────────────────────────────────────────────────────
--[[
  ThemeManager:SetTheme(themeName, mainFrame)
  Applies a full theme to the whole UI.
]]

AequorUI.ThemeManager:SetTheme("Aqua", mainFrame)


-- ── CUSTOM THEME ───────────────────────────────────────────────────
--[[
  Add a key to ThemeManager.Themes, then call SetTheme() with that name.
  All fields are required.

  Fields:
    MainColor            → Color3  — window background
    SelectionColor       → Color3  — selection bar, strokes, slider fill, scrollbar
    GlowColor            → Color3  — glow behind active tab
    BoundaryColor        → Color3  — divider lines
    BoundaryTransparency → number  — divider transparency (0–1)
    Transparency         → number  — window transparency (0=opaque)
    GradientStart        → Color3  — top of background gradient
    GradientEnd          → Color3  — bottom of background gradient
    TextColor            → Color3  — titles
    DescTextColor        → Color3  — descriptions
    ClipboardIcon        → string  — rbxassetid for clipboard arrow icon
    CustomDecorations    → table   — {} for none, or ThemeManager.Decorations
]]

AequorUI.ThemeManager.Themes["Midnight"] = {
    MainColor            = Color3.fromRGB(15, 15, 30),
    SelectionColor       = Color3.fromRGB(120, 80, 255),
    GlowColor            = Color3.fromRGB(140, 100, 255),
    BoundaryColor        = Color3.fromRGB(255, 255, 255),
    BoundaryTransparency = 0.85,
    Transparency         = 0.2,
    GradientStart        = Color3.fromRGB(30, 25, 55),
    GradientEnd          = Color3.fromRGB(10, 10, 25),
    TextColor            = Color3.fromRGB(255, 255, 255),
    DescTextColor        = Color3.fromRGB(200, 200, 220),
    ClipboardIcon        = "rbxassetid://106330002535278",
    CustomDecorations    = {},
}
-- AequorUI.ThemeManager:SetTheme("Midnight", mainFrame)


-- ── DECORATIONS ────────────────────────────────────────────────────
--[[
  ImageLabels rendered on window edges. Must be defined BEFORE CreateMain().
  Built-ins: "LeftWing", "RightWing"

  Fields:
    AssetId      → string  — rbxassetid://
    Position     → UDim2   — relative to MainFrame
    Size         → UDim2
    Transparency → number  — 0=visible, 1=hidden
    Rotation     → number  — degrees
    ZIndex       → number  — negative = behind the window
    Color        → Color3  — image tint (optional)

  Assign to a custom theme:
    AequorUI.ThemeManager.Themes["Midnight"].CustomDecorations = AequorUI.ThemeManager.Decorations
]]

-- Example (define BEFORE CreateMain):
-- AequorUI.ThemeManager.Decorations["TopGlow"] = {
--     AssetId      = "rbxassetid://128923622323769",
--     Position     = UDim2.new(0.5, -75, 0, -40),
--     Size         = UDim2.new(0, 150, 0, 80),
--     Transparency = 0.5,
--     Rotation     = 180,
--     ZIndex       = -1,
--     Color        = Color3.fromRGB(100, 200, 255),
-- }


-- ── TRANSPARENCY ───────────────────────────────────────────────────
--[[
  ThemeManager:SetTransparency(value, mainFrame)
  0 = opaque, 0.3 = recommended default, 1 = invisible.
]]

AequorUI.ThemeManager:SetTransparency(0.3, mainFrame)


-- ── ACRYLIC ────────────────────────────────────────────────────────
--[[
  ThemeManager:SetAcrylic(enabled, screenGui)
  Toggles a frosted glass overlay behind the window.
]]

AequorUI.ThemeManager:SetAcrylic(false, screenGui)


-- ── SET COMPONENT COLOR ────────────────────────────────────────────
--[[
  ThemeManager:SetComponentColor(category, Color3, {objects})

  "Selection" → sliding tab bar        → { myTabs.SelectionBar }
  "Glow"      → active tab glow        → { tab1:WaitForChild("Glow"), ... }
  "Boundary"  → sidebar/header dividers → { myTabs.BoundaryLine, divider }
]]

AequorUI.ThemeManager:SetComponentColor("Selection", Color3.fromRGB(255, 255, 255), { myTabs.SelectionBar })
AequorUI.ThemeManager:SetComponentColor("Boundary",  Color3.fromRGB(255, 255, 255), { myTabs.BoundaryLine, divider })
AequorUI.ThemeManager:SetComponentColor("Glow",      Color3.fromRGB(255, 255, 255), {
    tab1:WaitForChild("Glow"),
    tab2:WaitForChild("Glow"),
    tab3:WaitForChild("Glow"),
    tab4:WaitForChild("Glow"),
})


-- ── SET COMPONENT TRANSPARENCY ─────────────────────────────────────
--[[
  ThemeManager:SetComponentTransparency(category, value, {objects})
  Currently only "Boundary" is supported. 0=visible, 1=invisible.
]]

AequorUI.ThemeManager:SetComponentTransparency("Boundary", 0.8, { myTabs.BoundaryLine, divider })


-- ── GET THEME ──────────────────────────────────────────────────────
--[[
  ThemeManager:GetTheme(name)  → returns full theme data table
  ThemeManager:GetTheme()      → returns currently active theme
]]

local current = AequorUI.ThemeManager:GetTheme()
print("Active SelectionColor:", current.SelectionColor)

local aqua = AequorUI.ThemeManager:GetTheme("Aqua")
print("Aqua GradientStart:", aqua.GradientStart)


-- ══════════════════════════════════════════
--  ICON MANAGER
-- ══════════════════════════════════════════

-- ── SET ICON COLOR ─────────────────────────────────────────────────
--[[
  Sets ImageColor3 on tab Icon ImageLabels.
  Also updates IconManager.DefaultIconColor for future icons.

  IconManager:SetIconColor(Color3, {icons})
]]

AequorUI.IconManager:SetIconColor(Color3.fromRGB(255, 255, 255), {
    tab1:WaitForChild("Icon"),
    tab2:WaitForChild("Icon"),
    tab3:WaitForChild("Icon"),
    tab4:WaitForChild("Icon"),
})


-- ── ADD CUSTOM ICON ────────────────────────────────────────────────
--[[
  Registers a custom icon name for use in CreateTab().

  IconManager:AddCustomIcon(name, assetId)

  Built-in names: "Home" | "Settings" | "Search" | "Target"
                  "Combat" | "Movement" | "Eyes" | "Human" | "Humans"
]]

AequorUI.IconManager:AddCustomIcon("Star",   "rbxassetid://111111111111")
AequorUI.IconManager:AddCustomIcon("Shield", "rbxassetid://222222222222")

-- local tab5, container5 = myTabs:CreateTab("Extra", "Star", 5)


-- ── GET ICON ───────────────────────────────────────────────────────
--[[
  IconManager:GetIcon(name)  → returns assetId string
  Checks custom icons first, then built-ins. Returns "" if not found.
]]

print("Home icon:",    AequorUI.IconManager:GetIcon("Home"))
print("Star icon:",    AequorUI.IconManager:GetIcon("Star"))
print("Missing:",      AequorUI.IconManager:GetIcon("DoesNotExist"))  -- ""


-- ── DEFAULT ICON COLOR ─────────────────────────────────────────────
--[[
  IconManager.DefaultIconColor → fallback color applied to new icons.
  Updated automatically by SetIconColor(), or set directly.
]]

-- AequorUI.IconManager.DefaultIconColor = Color3.fromRGB(200, 200, 200)


print("AequorUI loaded.")
