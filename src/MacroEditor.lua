local _, smb = ...

-- The Edit Macro window: a text box holding a macro's text, which Save stores in place of the text its settings
-- make (see smb.setCustomBody). Not Blizzard's macro window: Macroroni rewrites the macros it made, so edits made
-- there don't last.

local WIDTH, HEIGHT = 420, 300

local editor

-- Shows the length against WoW's limit, red when over, and greys Save out while the text can't be saved.
local function updateCount()
    local length = #editor.editBox:GetText()
    local over = length > smb.MAX_MACRO_BODY
    editor.count:SetText(length .. " / " .. smb.MAX_MACRO_BODY)
    if over then
        editor.count:SetTextColor(1, 0.1, 0.1)
    else
        editor.count:SetTextColor(1, 0.82, 0)
    end
    editor.save:SetEnabled(not over)
end

local function buildEditor()
    local frame = CreateFrame("Frame", "MacroroniMacroEditor", UIParent, "BackdropTemplate")
    frame:SetSize(WIDTH, HEIGHT)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")
    frame:SetToplevel(true)
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = {left = 11, right = 12, top = 12, bottom = 11},
    })
    tinsert(UISpecialFrames, frame:GetName()) -- Escape closes it

    frame.title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    frame.title:SetPoint("TOP", 0, -20)

    -- the text box's dark backing, sized to the scroll area
    local box = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    box:SetPoint("TOPLEFT", 20, -42)
    box:SetPoint("BOTTOMRIGHT", -20, 74)
    box:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = {left = 4, right = 4, top = 4, bottom = 4},
    })
    box:SetBackdropColor(0, 0, 0, 0.8)

    local scroll = CreateFrame("ScrollFrame", "MacroroniMacroEditorScroll", box, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 8, -8)
    scroll:SetPoint("BOTTOMRIGHT", -28, 8)

    local editBox = CreateFrame("EditBox", nil, scroll)
    editBox:SetMultiLine(true)
    editBox:SetAutoFocus(false)
    editBox:SetFontObject(ChatFontNormal)
    editBox:SetWidth(WIDTH - 76)
    editBox:SetScript("OnTextChanged", updateCount)
    editBox:SetScript("OnEscapePressed", function() frame:Hide() end)
    editBox:SetScript("OnCursorChanged", function(self, _, y, _, height)
        -- keeps the line being typed in view (ScrollingEdit_OnCursorChanged, without its frame globals)
        local offset, shown = scroll:GetVerticalScroll(), scroll:GetHeight()
        y = -y
        if y < offset then
            scroll:SetVerticalScroll(y)
        elseif y + height > offset + shown then
            scroll:SetVerticalScroll(y + height - shown)
        end
    end)
    scroll:SetScrollChild(editBox)
    -- a click anywhere in the box puts the cursor in the text
    box:EnableMouse(true)
    box:SetScript("OnMouseDown", function() editBox:SetFocus() end)
    frame.editBox = editBox

    frame.count = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    frame.count:SetPoint("TOPRIGHT", box, "BOTTOMRIGHT", -4, -4)

    local hint = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    hint:SetPoint("TOPLEFT", box, "BOTTOMLEFT", 4, -4)
    hint:SetText("Options don't change an edited macro.")

    local function button(label, width)
        local b = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        b:SetSize(width, 22)
        b:SetText(label)
        return b
    end
    frame.save = button(SAVE, 90)
    frame.save:SetPoint("BOTTOMRIGHT", frame, "BOTTOM", -50, 20)
    frame.save:SetScript("OnClick", function()
        if frame.onSave(editBox:GetText()) then frame:Hide() end
    end)
    local cancel = button(CANCEL, 90)
    cancel:SetPoint("LEFT", frame.save, "RIGHT", 6, 0)
    cancel:SetScript("OnClick", function() frame:Hide() end)
    -- fills the box with the text the macro's settings make, to start over; Save still stores it
    local automatic = button("Automatic Text", 110)
    automatic:SetPoint("LEFT", cancel, "RIGHT", 6, 0)
    automatic:SetScript("OnClick", function()
        editBox:SetText(frame.automatic)
        editBox:SetFocus()
    end)

    frame:SetScript("OnHide", function() editBox:ClearFocus() end)
    return frame
end

-- Opens the editor on a macro's text. automatic is the text its settings make, for the Automatic Text button.
-- onSave(text) gets the text on Save and returns whether it was saved, which closes the editor; Cancel or
-- Escape just closes it.
function smb.showMacroEditor(name, text, automatic, onSave)
    editor = editor or buildEditor()
    editor.title:SetText("Edit Macro: " .. name)
    editor.automatic, editor.onSave = automatic, onSave
    editor.editBox:SetText(text)
    editor.editBox:SetCursorPosition(0)
    updateCount()
    editor:Show()
    editor.editBox:SetFocus()
end
