local _, smb = ...

-- The Icon menu's custom icon picker: a scrolling grid of the game's macro icon list. Not Blizzard's own popup or
-- IconDataProviderMixin: those share their state with the macro window.

local COLUMNS, ROWS, CELL, ICON_SIZE = 10, 6, 40, 36

local picker, icons

-- An icon as SetTexture takes it: a file ID, or a bare texture name in Interface\Icons.
function smb.iconTexture(icon)
    return type(icon) == "number" and icon or "Interface\\Icons\\" .. icon
end

-- The macro window's list: spells, then items, each icon once. Read when first needed: it is thousands long.
local function iconList()
    if icons then return icons end
    local spells, items = {}, {}
    GetLooseMacroIcons(spells)
    GetMacroIcons(spells)
    GetLooseMacroItemIcons(items)
    GetMacroItemIcons(items)
    icons = {}
    local seen = {}
    for _, list in ipairs({spells, items}) do
        for _, entry in ipairs(list) do
            local icon = tonumber(entry) or entry -- the game gives file IDs, and now and then a name
            if icon ~= "" and not seen[icon] then
                seen[icon] = true
                icons[#icons + 1] = icon
            end
        end
    end
    return icons
end

-- Shows the icons from the slider's row down, marking the current one.
local function update()
    local first = math.floor(picker.slider:GetValue()) * COLUMNS
    for i, button in ipairs(picker.buttons) do
        local icon = iconList()[first + i]
        button.value = icon
        button:SetShown(icon ~= nil)
        if icon then
            button.icon:SetTexture(smb.iconTexture(icon))
            button.selected:SetShown(icon == picker.current)
        end
    end
end

local function buildPicker()
    local frame = CreateFrame("Frame", "MacroroniIconPicker", UIParent, "BackdropTemplate")
    frame:SetSize(COLUMNS * CELL + 64, ROWS * CELL + 96)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")
    frame:SetToplevel(true)
    frame:EnableMouse(true)
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = {left = 11, right = 12, top = 12, bottom = 11},
    })
    tinsert(UISpecialFrames, frame:GetName()) -- Escape closes it

    local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    title:SetPoint("TOP", 0, -20)
    title:SetText("Choose An Icon")

    frame.buttons = {}
    for i = 1, COLUMNS * ROWS do
        local button = CreateFrame("Button", nil, frame)
        button:SetSize(ICON_SIZE, ICON_SIZE)
        button:SetPoint("TOPLEFT", 20 + (i - 1) % COLUMNS * CELL, -44 - math.floor((i - 1) / COLUMNS) * CELL)
        button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
        button.icon = button:CreateTexture(nil, "ARTWORK")
        button.icon:SetAllPoints()
        button.selected = button:CreateTexture(nil, "OVERLAY")
        button.selected:SetTexture("Interface\\Buttons\\CheckButtonHilight")
        button.selected:SetBlendMode("ADD")
        button.selected:SetAllPoints()
        button:SetScript("OnClick", function(self)
            local onPick = frame.onPick
            frame:Hide()
            onPick(self.value)
        end)
        frame.buttons[i] = button
    end

    local slider = CreateFrame("Slider", nil, frame)
    slider:SetOrientation("VERTICAL")
    slider:SetWidth(16)
    slider:SetPoint("TOPRIGHT", -20, -44)
    slider:SetPoint("BOTTOMRIGHT", -20, 52)
    slider:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
    slider:SetValueStep(1)
    slider:SetObeyStepOnDrag(true)
    slider:SetScript("OnValueChanged", update)
    frame.slider = slider

    frame:EnableMouseWheel(true)
    frame:SetScript("OnMouseWheel", function(_, delta) slider:SetValue(slider:GetValue() - delta) end)

    local cancel = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    cancel:SetSize(110, 22)
    cancel:SetPoint("BOTTOM", 0, 18)
    cancel:SetText(CANCEL)
    cancel:SetScript("OnClick", function() frame:Hide() end)
    return frame
end

-- Opens the picker on its first row, marking current (optional). onPick(icon) gets the icon clicked, a file ID or
-- a bare texture name; Cancel or Escape just closes it.
function smb.showIconPicker(current, onPick)
    picker = picker or buildPicker()
    picker.current, picker.onPick = current, onPick
    picker.slider:SetMinMaxValues(0, math.max(0, math.ceil(#iconList() / COLUMNS) - ROWS))
    picker.slider:SetValue(0)
    update()
    picker:Show()
end
