-- ╔═══════════════════════════════════════════════════════════════╗
-- ║                   AequorUI — Example.lua                      ║
-- ║         Complete API reference — every feature explained      ║
-- ╚═══════════════════════════════════════════════════════════════╝

--[[
    MODULES AVAILABLE AFTER LOADING:
    ┌─────────────────┬──────────────────────────────────────────────┐
    │ GeneralUI       │ Creates the main window                      │
    │ TabManager      │ Creates and manages sidebar tabs             │
    │ ElementManager  │ Creates all UI elements                      │
    │ ThemeManager    │ Controls colors, themes, decorations         │
    │ IconManager     │ Controls tab icons                           │
    │ AddContainer    │ Creates a styled hover-animated container     │
    └─────────────────┴──────────────────────────────────────────────┘
]]

local AequorUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/hnwiie/UI/refs/heads/main/main.lua", true
))()

local Players     = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer


-- ════════════════════════════════════════════════════════════════
--  SECTION 1 — MAIN WINDOW  (GeneralUI)
-- ════════════════════════════════════════════════════════════════

--[[
    GeneralUI:CreateMain(toggleKey, themeName)

    toggleKey  → Enum.KeyCode  — the key that shows/hides the UI window
    themeName  → string        — the starting theme to apply
                                 built-in themes:
                                   "Aqua"    — teal/cyan
                                   "Violet"  — purple
                                   "Smoke"   — dark grey
                                   "Scarlet" — deep red
                                   "Lemon"   — yellow-gold
                                   "Light"   — white/light grey
                                   "Rose"    — pink
                                   "Custom"  — base for custom themes

    Returns → ScreenGui
]]

local screenGui = AequorUI.GeneralUI:CreateMain(Enum.KeyCode.RightBracket, "Aqua")
local mainFrame = screenGui:WaitForChild("MainFrame")
local divider   = mainFrame:WaitForChild("Divider")


-- ════════════════════════════════════════════════════════════════
--  SECTION 2 — TABS  (TabManager)
-- ════════════════════════════════════════════════════════════════

--[[
    TabManager:Init(mainFrame)
    Must be called once before creating any tabs.
    Returns → myTabs (tab controller object)

    myTabs properties you can use later:
      myTabs.SelectionBar  → the small bar that slides to the active tab
      myTabs.BoundaryLine  → the vertical divider line between sidebar and content
]]

local myTabs = AequorUI.TabManager:Init(mainFrame)

--[[
    myTabs:CreateTab(name, iconName, layoutOrder)

    name        → string  — label text shown in the sidebar
    iconName    → string  — icon key. built-in keys:
                              "Home"     "Settings"  "Search"
                              "Target"   "Combat"    "Movement"
                              "Eyes"     "Human"     "Humans"
                            (you can also use custom icon keys, see Section 5b)
    layoutOrder → number  — position in the sidebar. 1 = top, 2 = second, etc.

    Returns → tabButton, container
      tabButton  → the clickable TextButton in the sidebar
                   children: tabButton:WaitForChild("Icon") → ImageLabel
                              tabButton:WaitForChild("Glow") → Frame
      container  → ScrollingFrame where you add your elements
]]

local tab1, container1 = myTabs:CreateTab("Home",     "Home",     1)
local tab2, container2 = myTabs:CreateTab("Combat",   "Combat",   2)
local tab3, container3 = myTabs:CreateTab("Settings", "Settings", 3)
local tab4, container4 = myTabs:CreateTab("Profile",  "Human",    4)


-- ════════════════════════════════════════════════════════════════
--  SECTION 3 — ELEMENTS  (ElementManager)
-- ════════════════════════════════════════════════════════════════

-- ─── 3a. PARAGRAPH ──────────────────────────────────────────────────────────
--[[
    A read-only display box with a title and a description.
    Height adjusts automatically based on description length.
    No callback. No config options.

    ElementManager:CreateParagraph(container, title, description)

    Returns → Frame
]]

AequorUI.ElementManager:CreateParagraph(container1,
    "Welcome to AequorUI",
    "This is a paragraph element. Use it for announcements, patch notes, " ..
    "or any long-form text. The frame height adjusts automatically."
)


-- ─── 3b. CLIPBOARD ──────────────────────────────────────────────────────────
--[[
    A clickable button that copies a string to the user's clipboard.
    Requires the executor to support setclipboard().
    No config options.

    ElementManager:CreateClipboard(container, title, description, textToCopy)

    Returns → TextButton
]]

AequorUI.ElementManager:CreateClipboard(container1,
    "Discord Invite",
    "Click to copy the Discord server link to your clipboard.",
    "https://discord.gg/example"
)


-- ─── 3c. TOGGLE ─────────────────────────────────────────────────────────────
--[[
    An on/off switch. Fires callback(state) where state is true or false.

    ElementManager:CreateToggle(container, title, description, callback)
    ElementManager:CreateToggle(container, title, description, callback, config)

    config (optional table):
      OnColor  → Color3 — toggle background color when ON  (default: green)
      OffColor → Color3 — toggle background color when OFF (default: grey)
      DotColor → Color3 — the sliding dot color            (default: white)

    Returns → Frame
]]

-- Default style:
AequorUI.ElementManager:CreateToggle(container1,
    "Aimbot",
    "Enables automatic target tracking.",
    function(state)
        print("Aimbot:", state)
    end
)

-- Custom colors:
AequorUI.ElementManager:CreateToggle(container1,
    "ESP",
    "Shows player outlines through walls.",
    function(state)
        print("ESP:", state)
    end,
    {
        OnColor  = Color3.fromRGB(255, 80, 0),
        OffColor = Color3.fromRGB(40, 40, 40),
        DotColor = Color3.fromRGB(255, 255, 255),
    }
)


-- ─── 3d. SLIDER ─────────────────────────────────────────────────────────────
--[[
    A draggable slider that returns integer values. Fires callback(value).

    ElementManager:CreateSlider(container, title, description, min, max, default, callback)
    ElementManager:CreateSlider(container, title, description, min, max, default, callback, config)

    min     → number — minimum value
    max     → number — maximum value
    default → number — starting value (clamped between min and max)

    config (optional table):
      TrackColor → Color3 — the full background track color   (default: dark grey)
      FillColor  → Color3 — the filled/active portion color   (default: theme SelectionColor)
      DotColor   → Color3 — the draggable handle dot color    (default: white)

    Returns → Frame
]]

-- Default style:
AequorUI.ElementManager:CreateSlider(container1,
    "Walk Speed",
    "Adjusts the character's walk speed.",
    0, 500, 16,
    function(value)
        print("WalkSpeed:", value)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = value end
    end
)

-- Custom colors:
AequorUI.ElementManager:CreateSlider(container1,
    "Jump Power",
    "Adjusts the character's jump height.",
    0, 500, 50,
    function(value)
        print("JumpPower:", value)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.JumpPower = value end
    end,
    {
        TrackColor = Color3.fromRGB(30, 30, 30),
        FillColor  = Color3.fromRGB(255, 60, 60),
        DotColor   = Color3.fromRGB(255, 255, 255),
    }
)


-- ─── 3e. DROPDOWN ───────────────────────────────────────────────────────────
--[[
    A clickable dropdown menu. Fires callback(selected) with the chosen string.
    The dropdown panel opens centered on the button and closes on selection
    or when clicking outside.

    ElementManager:CreateDropdown(container, title, description, options, default, callback)
    ElementManager:CreateDropdown(container, title, description, options, default, callback, config)

    options → table of strings — the selectable options
    default → string           — the initially selected option

    config (optional table):
      SelectionBarColor → Color3 — the small vertical bar beside the active option
                                   (default: theme SelectionColor)
      GlowColor         → Color3 — the glow highlight on the active option
                                   (default: white)

    Returns → Frame
]]

-- Default style:
AequorUI.ElementManager:CreateDropdown(container1,
    "Theme",
    "Switch the UI theme.",
    {"Aqua", "Violet", "Smoke", "Scarlet", "Lemon", "Light", "Rose"},
    "Aqua",
    function(selected)
        print("Theme:", selected)
        AequorUI.ThemeManager:SetTheme(selected, mainFrame)
    end
)

-- Custom colors:
AequorUI.ElementManager:CreateDropdown(container1,
    "Weapon",
    "Select your active weapon.",
    {"Sword", "Bow", "Staff", "Dagger", "Axe"},
    "Sword",
    function(selected)
        print("Weapon:", selected)
    end,
    {
        SelectionBarColor = Color3.fromRGB(255, 50, 50),
        GlowColor         = Color3.fromRGB(255, 200, 0),
    }
)


-- ─── 3f. COLOR PICKER ───────────────────────────────────────────────────────
--[[
    A full HSV color picker panel. Opens when the preview box is clicked.
    Has Done and Cancel buttons.
    Callback fires only when Done is pressed. Cancel reverts to the last confirmed color.

    ElementManager:CreateColorPicker(container, title, description, defaultColor, callback)

    defaultColor → Color3    — the starting color shown in the preview box
    callback     → function(Color3) — receives the chosen color on Done

    Returns → Frame
    No config options — the panel style follows the active theme automatically.
]]

AequorUI.ElementManager:CreateColorPicker(container1,
    "ESP Color",
    "Choose the color for player ESP boxes.",
    Color3.fromRGB(255, 0, 0),
    function(color)
        print("ESP Color:", color)
    end
)

AequorUI.ElementManager:CreateColorPicker(container1,
    "Chams Color",
    "Choose the color for player chams.",
    Color3.fromRGB(0, 150, 255),
    function(color)
        print("Chams Color:", color)
    end
)


-- ─── 3g. ADD CONTAINER ──────────────────────────────────────────────────────
--[[
    A plain styled frame with a title and a description.
    Has a built-in smooth hover animation (transparency shift + cursor change).
    Useful for info rows, custom sections, or as a base to parent extra children.

    AequorUI.AddContainer(container, title, description)

    Returns → Frame  (you can add children to it if needed)
]]

local myRow = AequorUI.AddContainer(container1,
    "Custom Row",
    "This is a plain hover-animated container. You can parent extra instances to it."
)

-- Example: adding something inside the returned frame
-- local label = Instance.new("TextLabel")
-- label.Parent = myRow


-- ════════════════════════════════════════════════════════════════
--  SECTION 4 — THEME MANAGER  (ThemeManager)
-- ════════════════════════════════════════════════════════════════

-- ─── 4a. SET BUILT-IN THEME ─────────────────────────────────────────────────
--[[
    Applies a full theme to the entire UI including all registered elements.
    Built-in themes:
      "Aqua"    "Violet"  "Smoke"   "Scarlet"
      "Lemon"   "Light"   "Rose"    "Custom"

    ThemeManager:SetTheme(themeName, mainFrame)
]]

AequorUI.ThemeManager:SetTheme("Aqua", mainFrame)


-- ─── 4b. CREATE A CUSTOM THEME ──────────────────────────────────────────────
--[[
    Add a new entry to ThemeManager.Themes with your own colors.
    All fields below are required.

    Theme properties:
      MainColor            → Color3  — main background color of the window
      SelectionColor       → Color3  — color of the selection bar, element strokes,
                                       scrollbar, and dropdown selection bar
      GlowColor            → Color3  — glow highlight color behind the active tab
      BoundaryColor        → Color3  — color of the sidebar + header divider lines
      BoundaryTransparency → number  — transparency of divider lines (0–1)
      Transparency         → number  — window background transparency (0 = opaque, 1 = invisible)
      GradientStart        → Color3  — lighter color at the top of the background gradient
      GradientEnd          → Color3  — darker color at the bottom of the background gradient
      TextColor            → Color3  — color of titles and tab labels
      DescTextColor        → Color3  — color of description text inside elements
      ClipboardIcon        → string  — rbxassetid for the arrow icon in clipboard elements
      CustomDecorations    → table   — decorations table (use {} for none,
                                       or ThemeManager.Decorations to include all)
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

-- Apply your custom theme:
AequorUI.ThemeManager:SetTheme("Midnight", mainFrame)


-- ─── 4c. DECORATIONS ────────────────────────────────────────────────────────
--[[
    Decorations are ImageLabels rendered on the edges of the main window.
    They are defined in ThemeManager.Decorations and created automatically
    when GeneralUI:CreateMain() is called.

    Built-in decorations: "LeftWing", "RightWing"

    Each decoration supports these fields:
      AssetId      → string  — rbxassetid:// of the image to display
      Position     → UDim2   — position relative to MainFrame
      Size         → UDim2   — size of the image
      Transparency → number  — image transparency (0 = visible, 1 = hidden)
      Rotation     → number  — rotation in degrees
      ZIndex       → number  — render order (negative values go behind the window)
      Color        → Color3  — tint color applied to the image (optional)

    Note: Decorations must be set BEFORE calling GeneralUI:CreateMain()
          because they are instantiated during window creation.
]]

-- Modify an existing decoration:
AequorUI.ThemeManager.Decorations["LeftWing"] = {
    AssetId      = "rbxassetid://128923622323769",
    Position     = UDim2.new(0, -120, 0.5, -60),
    Size         = UDim2.new(0, 120, 0, 120),
    Transparency = 0.3,
    Rotation     = 0,
    ZIndex       = -1,
    Color        = Color3.fromRGB(180, 140, 255),
}

-- Add a completely new decoration:
AequorUI.ThemeManager.Decorations["TopGlow"] = {
    AssetId      = "rbxassetid://128923622323769",
    Position     = UDim2.new(0.5, -75, 0, -40),
    Size         = UDim2.new(0, 150, 0, 80),
    Transparency = 0.5,
    Rotation     = 180,
    ZIndex       = -1,
    Color        = Color3.fromRGB(100, 200, 255),
}

-- Include all decorations in your custom theme:
AequorUI.ThemeManager.Themes["Midnight"].CustomDecorations = AequorUI.ThemeManager.Decorations


-- ─── 4d. SET TRANSPARENCY ───────────────────────────────────────────────────
--[[
    Controls the main window background transparency.
      0   = fully opaque
      0.3 = recommended default
      1   = fully invisible (avoid)

    ThemeManager:SetTransparency(value, mainFrame)
]]

AequorUI.ThemeManager:SetTransparency(0.3, mainFrame)


-- ─── 4e. SET ACRYLIC ────────────────────────────────────────────────────────
--[[
    Toggles an acrylic/frosted glass overlay behind the window.
      true  = overlay ON
      false = overlay OFF

    ThemeManager:SetAcrylic(enabled, screenGui)
]]

AequorUI.ThemeManager:SetAcrylic(false, screenGui)


-- ─── 4f. SET COMPONENT COLOR ────────────────────────────────────────────────
--[[
    Changes the color of a specific group of UI components.

    ThemeManager:SetComponentColor(category, Color3, {objects})

    Categories:
    ┌─────────────┬──────────────────────────────────────────────────────────┐
    │ "Selection" │ The small bar that slides next to the active tab.        │
    │             │ Also used as the default color for element strokes,      │
    │             │ slider fills, and scrollbars.                            │
    │             │ Pass: { myTabs.SelectionBar }                            │
    ├─────────────┼──────────────────────────────────────────────────────────┤
    │ "Glow"      │ The soft highlight frame that appears behind the active  │
    │             │ tab button.                                              │
    │             │ Pass: { tab1:WaitForChild("Glow"), tab2:... }            │
    ├─────────────┼──────────────────────────────────────────────────────────┤
    │ "Boundary"  │ The vertical line separating the sidebar from content,  │
    │             │ and the horizontal line below the drag handle.           │
    │             │ Pass: { myTabs.BoundaryLine, divider }                  │
    └─────────────┴──────────────────────────────────────────────────────────┘
]]

AequorUI.ThemeManager:SetComponentColor(
    "Selection",
    Color3.fromRGB(100, 200, 255),
    { myTabs.SelectionBar }
)

AequorUI.ThemeManager:SetComponentColor(
    "Glow",
    Color3.fromRGB(80, 220, 255),
    {
        tab1:WaitForChild("Glow"),
        tab2:WaitForChild("Glow"),
        tab3:WaitForChild("Glow"),
        tab4:WaitForChild("Glow"),
    }
)

AequorUI.ThemeManager:SetComponentColor(
    "Boundary",
    Color3.fromRGB(255, 255, 255),
    { myTabs.BoundaryLine, divider }
)


-- ─── 4g. SET COMPONENT TRANSPARENCY ────────────────────────────────────────
--[[
    Changes the transparency of a specific group of UI components.

    ThemeManager:SetComponentTransparency(category, value, {objects})
      value → 0 = fully visible, 1 = fully invisible

    Currently supported category: "Boundary"
]]

AequorUI.ThemeManager:SetComponentTransparency(
    "Boundary",
    0.8,
    { myTabs.BoundaryLine, divider }
)


-- ─── 4h. GET THEME ──────────────────────────────────────────────────────────
--[[
    Returns the full theme data table for the given theme name.
    Useful for reading colors to apply manually elsewhere.

    ThemeManager:GetTheme(themeName)  → table
    If name is nil, returns the currently active theme.
]]

local currentTheme = AequorUI.ThemeManager:GetTheme()
print("Main color:", currentTheme.MainColor)
print("Selection color:", currentTheme.SelectionColor)

local aquaTheme = AequorUI.ThemeManager:GetTheme("Aqua")
print("Aqua gradient start:", aquaTheme.GradientStart)


-- ════════════════════════════════════════════════════════════════
--  SECTION 5 — ICON MANAGER  (IconManager)
-- ════════════════════════════════════════════════════════════════

-- ─── 5a. SET ICON COLOR ─────────────────────────────────────────────────────
--[[
    Changes the ImageColor3 of a list of Icon ImageLabels.
    Also updates IconManager.DefaultIconColor, which is applied to
    new icons created after this call.

    IconManager:SetIconColor(Color3, {iconObjects})

    Pass the Icon child of each tab button.
    You get it via: tabButton:WaitForChild("Icon")
]]

AequorUI.IconManager:SetIconColor(
    Color3.fromRGB(255, 255, 255),
    {
        tab1:WaitForChild("Icon"),
        tab2:WaitForChild("Icon"),
        tab3:WaitForChild("Icon"),
        tab4:WaitForChild("Icon"),
    }
)


-- ─── 5b. ADD CUSTOM ICON ────────────────────────────────────────────────────
--[[
    Registers a custom icon so it can be referenced by name in CreateTab().

    IconManager:AddCustomIcon(name, assetId)
      name    → string — the key you'll pass as iconName in CreateTab()
      assetId → string — full "rbxassetid://..." string

    Built-in icon keys for reference:
      "Home"      "Settings"  "Search"   "Target"
      "Combat"    "Movement"  "Eyes"     "Human"   "Humans"
]]

AequorUI.IconManager:AddCustomIcon("Star",   "rbxassetid://111111111111")
AequorUI.IconManager:AddCustomIcon("Shield", "rbxassetid://222222222222")

-- Use your custom icon in a tab:
-- local tab5, container5 = myTabs:CreateTab("Extra", "Star", 5)


-- ─── 5c. GET ICON ───────────────────────────────────────────────────────────
--[[
    Returns the assetId string for a given icon name.
    Checks CustomIcons first, then falls back to the built-in Library.
    Returns "" if the icon is not found.

    IconManager:GetIcon(name) → string
]]

print("Star icon:",    AequorUI.IconManager:GetIcon("Star"))
print("Home icon:",    AequorUI.IconManager:GetIcon("Home"))
print("Missing icon:", AequorUI.IconManager:GetIcon("DoesNotExist"))  -- prints ""


-- ─── 5d. DEFAULT ICON COLOR ─────────────────────────────────────────────────
--[[
    IconManager.DefaultIconColor stores the color applied to icons by default.
    It is updated automatically when you call SetIconColor().
    You can also set it directly if needed.
]]

AequorUI.IconManager.DefaultIconColor = Color3.fromRGB(200, 200, 200)


-- ════════════════════════════════════════════════════════════════
--  SECTION 6 — FULL SETUP EXAMPLE
-- ════════════════════════════════════════════════════════════════
-- Below is a minimal but complete real-world usage example
-- showing the recommended setup order.

--[[

local AequorUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/hnwiie/UI/refs/heads/main/main.lua", true
))()

-- 1. Create window
local screenGui = AequorUI.GeneralUI:CreateMain(Enum.KeyCode.RightBracket, "Aqua")
local mainFrame = screenGui:WaitForChild("MainFrame")
local divider   = mainFrame:WaitForChild("Divider")

-- 2. Create tabs
local myTabs = AequorUI.TabManager:Init(mainFrame)
local tab1, container1 = myTabs:CreateTab("Home",   "Home",   1)
local tab2, container2 = myTabs:CreateTab("Combat", "Combat", 2)

-- 3. Add elements
AequorUI.ElementManager:CreateToggle(container1, "Aimbot", "Enable aimbot.", function(state)
    print("Aimbot:", state)
end)

AequorUI.ElementManager:CreateSlider(container1, "FOV", "Set FOV size.", 1, 360, 90, function(val)
    print("FOV:", val)
end)

-- 4. Apply theme and component colors
AequorUI.ThemeManager:SetTheme("Aqua", mainFrame)
AequorUI.ThemeManager:SetTransparency(0.3, mainFrame)
AequorUI.ThemeManager:SetAcrylic(false, screenGui)

AequorUI.ThemeManager:SetComponentColor("Selection", Color3.fromRGB(100, 200, 255), { myTabs.SelectionBar })
AequorUI.ThemeManager:SetComponentColor("Boundary",  Color3.fromRGB(255, 255, 255), { myTabs.BoundaryLine, divider })
AequorUI.ThemeManager:SetComponentColor("Glow",      Color3.fromRGB(80, 220, 255),  { tab1:WaitForChild("Glow"), tab2:WaitForChild("Glow") })
AequorUI.ThemeManager:SetComponentTransparency("Boundary", 0.8, { myTabs.BoundaryLine, divider })

-- 5. Set icon colors
AequorUI.IconManager:SetIconColor(Color3.fromRGB(255, 255, 255), {
    tab1:WaitForChild("Icon"),
    tab2:WaitForChild("Icon"),
})

]]

print("AequorUI Example.lua loaded successfully!")
