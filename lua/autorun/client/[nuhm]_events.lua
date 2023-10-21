-- Define a table of DEFCON levels and associated sound paths
local defconLevels = {
   { level = 1, sound = "notifications/ping.ogg" },
   { level = 2, sound = "notifications/ping.ogg" },
   { level = 3, sound = "notifications/ping.ogg" },
   { level = 4, sound = "notifications/ping.ogg" },
   { level = 5, sound = "notifications/ping.ogg" },
}

local defconLevel = 0 -- Initialize the DEFCON level
local defconUIVisible = false
local fontCreated = false
local defconPopupVisible = false
local defconPopupStartTime = 0
local defconPopupDuration = 10 -- The duration of the popup in seconds
local defconPopupDelay = 5     -- Delay before the popup starts to fade in seconds
local defconPopupAlpha = 255   -- Initial alpha value (fully visible)
local defconPopupAlphaTranslucent = 200

local function CreateDefconFont()
   if not fontCreated then
      surface.CreateFont("defconFont", {
         font = "DermaDefault", -- The font family
         size = 18,             -- The point size (adjust as needed)
         weight = 700,          -- Font weight (400 for normal, 700 for bold)
         antialias = true,      -- Enable antialiasing
         shadow = false,        -- Enable text shadow
         additive = false,      -- Enable additive rendering
         outline = false,       -- Enable text outline
      })
      surface.CreateFont("defconFontLarge", {
         font = "DermaDefault", -- The font family
         size = 25,             -- The point size (adjust as needed)
         weight = 600,          -- Font weight (400 for normal, 700 for bold)
         antialias = true,      -- Enable antialiasing
         shadow = false,        -- Enable text shadow
         additive = false,      -- Enable additive rendering
         outline = false,       -- Enable text outline
      })
      fontCreated = true
   end
end

CreateDefconFont()

local function DrawDefconUI()
   if defconLevel > 0 then
      surface.SetFont("defconFont")

      local defconStaticTitle = "- D E F C O N -"
      local defconStaticLevel = "Level " .. defconLevel

      local ScrW, ScrH = ScrW(), ScrH()

      local boxW, boxH = ScrW * .075, ScrH * .05

      local posX = ScrW - 15 - boxW
      local posY = 15

      surface.SetDrawColor(0, 0, 0, 200) -- Set color (R, G, B, Alpha)
      surface.DrawRect(posX, posY, boxW, boxH)

      local defconStaticLevelColor = Color(255, 255, 255, 255)
      if defconLevel == 1 then
         defconStaticLevelColor = Color(255, 255, 255, 255) -- White color for DEFCON 1
      elseif defconLevel == 2 then
         defconStaticLevelColor = Color(255, 0, 0, 255)     -- Red color for DEFCON 2
      elseif defconLevel == 3 then
         defconStaticLevelColor = Color(255, 255, 0, 255)   -- Yellow color for DEFCON 3
      elseif defconLevel == 4 then
         defconStaticLevelColor = Color(0, 128, 0, 255)     -- Green color for DEFCON 4
      elseif defconLevel == 5 then
         defconStaticLevelColor = Color(0, 0, 255, 255)     -- Blue color for DEFCON 5
      end

      surface.SetDrawColor(defconStaticLevelColor)
      surface.DrawOutlinedRect(posX, posY, boxW, boxH)
      surface.SetTextColor(255, 255, 255, 255) -- Set color (R, G, B, Alpha)

      -- Calculate the position to center the text within the box
      local defconStaticTitleWidth, defconStaticTitleHeight = surface.GetTextSize(defconStaticTitle)
      local defconStaticLevelWidth, defconStaticLevelHeight = surface.GetTextSize(defconStaticLevel)

      local defconStaticTitleX = posX + (boxW - defconStaticTitleWidth) / 2
      local defconStaticTitleY = posY + (boxH / 2) - defconStaticTitleHeight

      local defconStaticLevelX = posX + (boxW - defconStaticLevelWidth) / 2
      local defconStaticLevelY = posY + (boxH / 2)

      surface.SetTextPos(defconStaticTitleX, defconStaticTitleY)
      surface.DrawText(defconStaticTitle)

      surface.SetTextColor(defconStaticLevelColor)
      surface.SetTextPos(defconStaticLevelX, defconStaticLevelY)
      surface.DrawText(defconStaticLevel)
   end
end

local function DrawDefconPopup()
   if defconPopupVisible and defconPopupAlpha > 0 then
      local currentTime = CurTime()

      -- Check if the delay has passed before fading
      if currentTime - defconPopupStartTime > defconPopupDelay then
         -- Gradually decrease the alpha value to fade out
         defconPopupAlpha = math.max(0, defconPopupAlpha - 2)                       -- Adjust the step as needed
         defconPopupAlphaTranslucent = math.max(0, defconPopupAlphaTranslucent - 2) -- Adjust the step as needed
      end

      -- Restoring initial values when the popup is no longer visible
      if defconPopupAlpha < 1 then
         defconPopupVisible = false
         defconPopupStartTime = currentTime
         defconPopupAlpha = 255
         defconPopupAlphaTranslucent = 200
      end

      surface.SetFont("defconFontLarge")

      local defconPopupTitle = "- D E F C O N -"
      local defconPopupLevel = "Level " .. defconLevel
      local defconPopupMessage = "null"

      local defconPopupColor = Color(255, 255, 255, defconPopupAlpha)
      if defconLevel == 1 then
         defconPopupMessage = "Evacuate, Evacuate, Evacuate!"
         defconPopupColor = Color(255, 255, 255, defconPopupAlpha)
      elseif defconLevel == 2 then
         defconPopupMessage = "Lockdown Essential Areas!"
         defconPopupColor = Color(255, 0, 0, defconPopupAlpha)
      elseif defconLevel == 3 then
         defconPopupMessage = "Man Battlestations!"
         defconPopupColor = Color(255, 255, 0, defconPopupAlpha)
      elseif defconLevel == 4 then
         defconPopupMessage = "Be on Alert!"
         defconPopupColor = Color(0, 128, 0, defconPopupAlpha)
      elseif defconLevel == 5 then
         defconPopupMessage = "Normal Duties"
         defconPopupColor = Color(0, 0, 255, defconPopupAlpha)
      end

      local ScrW, ScrH = ScrW(), ScrH()

      -- Calculate the position and dimensions for the popup box
      local popupWidth = ScrW * 0.2
      local popupHeight = ScrH * 0.1
      local posX = ScrW / 2 - popupWidth / 2
      local posY = ScrH / 8

      -- Draw the background box
      surface.SetDrawColor(0, 0, 0, defconPopupAlphaTranslucent)
      surface.DrawRect(posX, posY, popupWidth, popupHeight)

      -- Draw the border of the box
      surface.SetDrawColor(defconPopupColor)
      surface.DrawOutlinedRect(posX, posY, popupWidth, popupHeight)

      -- Calculate the center position for text
      local centerTextX = posX + popupWidth / 2

      -- Calculate text positions within the box
      local textY = posY + 10

      -- Draw the title, centered horizontally
      surface.SetTextColor(255, 255, 255, defconPopupAlpha)
      local textWidth, textHeight = surface.GetTextSize(defconPopupTitle)
      local textX = centerTextX - textWidth / 2
      surface.SetTextPos(textX, textY)
      surface.DrawText(defconPopupTitle)

      -- Update Y position for the level
      textY = textY + textHeight + 5

      -- Draw the level, centered horizontally
      surface.SetTextColor(defconPopupColor)
      textWidth, textHeight = surface.GetTextSize(defconPopupLevel)
      textX = centerTextX - textWidth / 2
      surface.SetTextPos(textX, textY)
      surface.DrawText(defconPopupLevel)

      -- Update Y position for the message
      textY = textY + textHeight + 5

      -- Draw the message, centered horizontally
      surface.SetTextColor(255, 255, 255, defconPopupAlpha)
      textWidth, textHeight = surface.GetTextSize(defconPopupMessage)
      textX = centerTextX - textWidth / 2
      surface.SetTextPos(textX, textY)
      surface.DrawText(defconPopupMessage)

      -- Check if it's time to hide the popup
      if CurTime() - defconPopupStartTime >= defconPopupDuration then
         defconPopupVisible = false
      end
   end
end

-- Hook to continuously draw the DEFCON UI
hook.Add("HUDPaint", "DrawDefconUI", function()
   if defconUIVisible then
      DrawDefconUI()
      DrawDefconPopup()
   end
end)

local function ToggleDefconUI()
   defconUIVisible = not defconUIVisible
end

concommand.Add("toggledefconui", ToggleDefconUI)

local function ClearDefcon()
   defconLevel = 0
   defconUIVisible = false
end

concommand.Add("cleardefcon", ClearDefcon)

-- Loop through the DEFCON levels and register chat commands
for _, defcon in pairs(defconLevels) do
   concommand.Add("defcon" .. defcon.level, function()
      -- Play the sound effect for the current DEFCON level
      surface.PlaySound(defcon.sound)

      -- Set the DEFCON level to the current level
      defconLevel = defcon.level

      defconUIVisible = true
      defconPopupVisible = true
      defconPopupStartTime = CurTime()
   end)
end
