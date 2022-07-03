// Before we even start, do this:
// Press CTRL + H and replace all occurrences of MapPrompts_Custom and MPCS with your own names
// Give each one a different name, otherwise conflicts will occur

	local AlphaVal = 0
	local AlphaVal2 = 0

	local Addline1 = 0
	local Addline2 = 0
	local Addline3 = 0
	local Addline4 = 0
	local Addline5 = 0
	local Addline6 = 0

	local FixedSpotMessage = ""
	local FixedSpotMessage2 = ""

	local PlayerRespawn = ""

	local Delay = GetConVar("MapPromptsIntroDelay"):GetInt()
	local Delay2 = GetConVar("MapPromptsLocationDelay"):GetInt()
	local Delay3 = GetConVar("MapPromptsIntroDelay"):GetInt()
	local Delay4 = GetConVar("MapPromptsLocationDelay"):GetInt()

// ^ Dont touch this stuff ^

local MPCSMessage = {
'"Custom Prompt 1"',
'"Custom Prompt 2"',
'"Custom Prompt 3"',
'"Custom Prompt 4"'
}

// This is the spawn message
// This is the line of text that appears at the top when the player spawns in
// If you want to keep the "" on the outside of the text, only edit the text inside the quotation marks
// If you want to remove them then replace '"Custom Prompt"' with "Custom Prompt"

	local MPCSSpawnMessage = table.Random(MPCSMessage)

// This picks a random name from the table, then sticks to it
// You shouldn't have to edit this at all

	local MPCSChapterTitle = '"Custom Chapter"'

// This is the custom chapter title
// Basically only used for campaign maps
// You can remove this if you wish

local MPCSExtraMessage = {
'"Custom Prompt 1"',
'"Custom Prompt 2"',
'"Custom Prompt 3"',
'"Custom Prompt 4"'
}

// This is an extra message
// We can use these for unique locations
// You'll want to have separate tables for each location, unless you want messages to be shared

	local MPCSExtraSpotMessage = table.Random(MPCSExtraMessage)

// This is the same as above, you really shouldn't have to edit this

	MapPrompts_CustomFakeClockHr = 20 // 0-23 This is the 24hr clock
	MapPrompts_CustomFakeClockHrAlternate = 8 // 0 - 11 This is the 12hr clock

// Although you may not use the 12hr style, we still need to apply it
// However, FakeClockHrAlternate cannot go above 12
// If FakeClockHr goes above 12, then Alternate restarts at 0
// Like this:
// FakeClockHr          = 10 11 12 13 14 15 16 17 18
// FakeClockHrAlternate = 10 11  0  1  2  3  4  5  6

	MapPrompts_CustomFakeClockMin = 35 // 0 -  59 Minutes
	MapPrompts_CustomFakeClockSec = 42 // 0 -  59 Seconds

// These are the time values for the 'Fake Clock'
// You can (and should) edit the number values
// This will dictate the time at which the FakeClock will start at
// It will keep ticking so long as the player is playing
// The clock will not save over restarts or map changes
// Use StormFox 2 for that

	Suffix = ""

// Do not touch suffix, he is a gentle boi

// Below is the heart and soul of the FakeClock mechanic
// I suggest not touching anything here

local function MapPrompts_Custom_FakeClock()
	if MapPrompts_CustomFakeClockSec < 59 then
	MapPrompts_CustomFakeClockSec = MapPrompts_CustomFakeClockSec + 1

	elseif MapPrompts_CustomFakeClockSec == 59 then
	MapPrompts_CustomFakeClockSec = 00
	MapPrompts_CustomFakeClockMin = MapPrompts_CustomFakeClockMin + 1
	end

	if MapPrompts_CustomFakeClockMin == 60 then
	MapPrompts_CustomFakeClockMin = 00
	MapPrompts_CustomFakeClockHr = MapPrompts_CustomFakeClockHr + 1
	MapPrompts_CustomFakeClockHrAlternate = MapPrompts_CustomFakeClockHrAlternate + 1
	end

	if MapPrompts_CustomFakeClockHr == 24 then
	MapPrompts_CustomFakeClockHr = 00
	end

	if MapPrompts_CustomFakeClockHrAlternate == 12 then
	MapPrompts_CustomFakeClockHrAlternate = 00
	end
end
	timer.Create( "MapPrompts_CustomClock", 1, 0, MapPrompts_Custom_FakeClock )

if game.GetMap() == "YourChosenMap" and GetConVar("MapPromptsEnabled"):GetBool() then
// 					^^
// This is the custom map you want to support
// If the player is playing on said map, this file will trigger
// Replace YourChosenMap with the name of the map you're playing on
// E.g: gm_construct, gm_flatgrass, gm_bigcity
// I.e, the name you see on the map selection screen

MapPromptsSupport = "YourChosenMap"

// We add support, meaning the fallback system will not trigger

hook.Add("HUDPaint", "CustomIdentifier", function(ply)

// Replace CustomIdentifier with a name of your choosing
// So far, I've been using the map names as identifiers
// Reduces the likelyhood of conflicts

if GetConVar("MapPromptsCustomMissionName"):GetString() != "" then
	MPCSMessage = GetConVar("MapPromptsCustomMissionName"):GetString()
	MPCSSpotMessage = GetConVar("MapPromptsCustomMissionName"):GetString()
// From here
elseif GetConVar("MapPromptsCustomMissionName"):GetString() == "" and GetConVar("MapPromptsCampaignTitles"):GetBool() then
	MPCSMessage = MPCSChapterTitle
	MPCSSpotMessage = MPCSChapterTitle
// To here
else
	MPCSMessage = MPCSSpawnMessage
	MPCSSpotMessage = FixedSpotMessage
end

// If you removed the ChapterTitle then remove the marked portion

if GetConVar("MapPromptsCustomMapName"):GetString() != "" then
	MPCSMessage2 = GetConVar("MapPromptsCustomMapName"):GetString()
	MPCSSpotMessage2 = GetConVar("MapPromptsCustomMapName"):GetString()
elseif GetConVar("MapPromptsCustomMapName"):GetString() == "" and !GetConVar("MapPromptsUniqueMapNames"):GetBool() then
	MPCSMessage2 = "ShortLoc"
	MPCSSpotMessage2 = "ShortLoc"
else
	MPCSMessage2 = "Long Location"
	MPCSSpotMessage2 = FixedSpotMessage2
end

// This, however we do
// ShortLoc is the shortened name, active when "Unique map names" is disabled
// Long location is the title used when the player spawns in
// It will not change whatsoever, unless you intend it to
// However most of the time its not really a necessity

// This is basically the "Hard part" complete
// The functions below are not important
// They are merely for formatting and general function of the script
// Jump down until you see the message "Stop here"

if GetConVar("MapPromptsUseCustomFont"):GetInt() == 1 then
	PlayerFont = "PlayerCustomFont"
else
	PlayerFont = "MapPromptsCustom"
end

	local ScrollingTitles = GetConVar("MapPromptsExperimentalScrolling"):GetBool()

	local FadeSpeed = 80 * GetConVar("MapPromptsTextFadeSpeed"):GetInt()

	local Alignment = GetConVar("MapPromptsTextAlignment"):GetInt()

	local Width = GetConVar("MapPromptsTextXPos"):GetFloat()
	local Height = GetConVar("MapPromptsTextYPos"):GetFloat()

	local CustomAdd1 = GetConVar("MapPromptsMissionNameOffset"):GetInt()
	local CustomAdd2 = GetConVar("MapPromptsMapNameOffset"):GetInt()
	local CustomAdd3 = GetConVar("MapPromptsPlayerNameOffset"):GetInt()
	local CustomAdd4 = GetConVar("MapPromptsTimeStampOffset"):GetInt()

	local FirstRespawn = GetConVar("MapPromptsFirstSpawn"):GetBool()
	local AlwaysSpawnMessage = GetConVar("MapPromptsAlwaysOnSpawn"):GetBool()

	local PromptsEnabled = GetConVar("MapPromptsCustomLocationPrompts"):GetBool()

if ConVarExists("sf_enable_mapsupport") then
	SF2TimeStamp = StormFox2.Time.TimeToString(nil, StormFox2.Setting.GetCache("12h_display"))
end

	local ConstantAreaTrigger = GetConVar("MapPromptsLocationPersistence"):GetBool()

	local ply = LocalPlayer()

if GetConVar("MapPromptsPlayerName"):GetString() == "" then
	PlayerTitle = ply:Nick()
else
	PlayerTitle = GetConVar("MapPromptsPlayerName"):GetString()
end

if MapPrompts_CustomFakeClockSec < 10 then
	FakeClockDebug3 = ":0"
else
	FakeClockDebug3 = ":"
end

if MapPrompts_CustomFakeClockMin < 10 then
	FakeClockDebug2 = ":0"
else
	FakeClockDebug2 = ":"
end

if (MapPrompts_CustomFakeClockHr < 10 and !GetConVar("MapPromptsTimeStamp12h"):GetBool()) or (MapPrompts_CustomFakeClockHrAlternate < 10 and GetConVar("MapPromptsTimeStamp12h"):GetBool()) then
	FakeClockDebug1 = "0"
else
	FakeClockDebug1 = ""
end

if GetConVar("MapPromptsTimeStamp12h"):GetBool() then
	MapPrompts_CustomFakeClockHrVisual = MapPrompts_CustomFakeClockHrAlternate
	Hour = "%I"
else
	MapPrompts_CustomFakeClockHrVisual = MapPrompts_CustomFakeClockHr
	Hour = "%H"
end

if GetConVar("MapPromptsTimeStamp12h"):GetBool() and MapPrompts_CustomFakeClockHr < 12 then
	Suffix = " AM"
elseif GetConVar("MapPromptsTimeStamp12h"):GetBool() and MapPrompts_CustomFakeClockHr >= 12 then
	Suffix = " PM"
end
if GetConVar("MapPromptsTimeStamp12h"):GetBool() and GetConVar("MapPromptsTimeStampStyle"):GetInt() == 1  then
	Suffix = " %p"
end
if !GetConVar("MapPromptsTimeStamp12h"):GetBool() or GetConVar("MapPromptsTimeStampStyle"):GetInt() == 3 then
	Suffix = ""
end

if GetConVar("MapPromptsTimeStampStyle"):GetInt() == 1 then
	Timestamp = os.date( Hour .. ":%M:%S" .. Suffix )
elseif GetConVar("MapPromptsTimeStampStyle"):GetInt() == 2 then
	Timestamp = FakeClockDebug1 .. MapPrompts_CustomFakeClockHrVisual .. FakeClockDebug2 .. MapPrompts_CustomFakeClockMin .. FakeClockDebug3 .. MapPrompts_CustomFakeClockSec .. Suffix
elseif GetConVar("MapPromptsTimeStampStyle"):GetInt() == 3 and ConVarExists("sf_enable_mapsupport") then
	Timestamp = SF2TimeStamp
else
	Timestamp = os.date( Hour .. ":%M:%S" .. Suffix )
end

if ScrollingTitles == true then
	Alpha = Color( GetConVar("FontColorR"):GetInt(), GetConVar("FontColorG"):GetInt(), GetConVar("FontColorB"):GetInt(), BetaVal )
	Alpha2 = Color( GetConVar("FontColorR"):GetInt(), GetConVar("FontColorG"):GetInt(), GetConVar("FontColorB"):GetInt(), BetaVal2 )
else
	Alpha = Color( GetConVar("FontColorR"):GetInt(), GetConVar("FontColorG"):GetInt(), GetConVar("FontColorB"):GetInt(), math.Clamp(AlphaVal, 0, 255) )
	Alpha2 = Color( GetConVar("FontColorR"):GetInt(), GetConVar("FontColorG"):GetInt(), GetConVar("FontColorB"):GetInt(), math.Clamp(AlphaVal2, 0, 255) )
end

	local XPos = math.Round(tostring(ply:GetPos().x), 0)
	local YPos = math.Round(tostring(ply:GetPos().y), 0)
	local ZPos = math.Round(tostring(ply:GetPos().z), 0) + 3

if ScrollingTitles == true then
	FinalMessage = string.Left(MPCSMessage, Addline1)
	FinalMessage2 = string.Left(MPCSMessage2, Addline2)
	FinalPlayerTitle = string.Left(PlayerTitle, Addline3)
	FinalTimestamp = string.Left(Timestamp, Addline4)
	FinalSpotMessage = string.Left(MPCSSpotMessage, Addline5)
	FinalSpotMessage2 = string.Left(MPCSSpotMessage2, Addline6)
else
	FinalMessage = MPCSMessage
	FinalMessage2 = MPCSMessage2
	FinalPlayerTitle = PlayerTitle
	FinalTimestamp = Timestamp
	FinalSpotMessage = MPCSSpotMessage
	FinalSpotMessage2 = MPCSSpotMessage2
end

if ScrollingTitles == true then
if SpawnScrollTitleStart == true or SpotScrollTitleStart == true then
	Addline3 = math.Clamp(Addline3 + 8 * FrameTime(), 0, #PlayerTitle)
	Addline4 = math.Clamp(Addline4 + 8 * FrameTime(), 0, #Timestamp)
else
	Addline3 = math.Clamp(Addline3 - 8 * FrameTime(), 0, #PlayerTitle)
	Addline4 = math.Clamp(Addline4 - 8 * FrameTime(), 0, #Timestamp)
end

if SpawnScrollTitleStart == true then
	Addline1 = math.Clamp(Addline1 + 8 * FrameTime(), 0, #MPCSMessage)
	Addline2 = math.Clamp(Addline2 + 8 * FrameTime(), 0, #MPCSMessage2)
else
	Addline1 = math.Clamp(Addline1 - 8 * FrameTime(), 0, #MPCSMessage)
	Addline2 = math.Clamp(Addline2 - 8 * FrameTime(), 0, #MPCSMessage2)
end

if SpotScrollTitleStart == true then
	Addline5 = math.Clamp(Addline5 + 8 * FrameTime(), 0, #MPCSSpotMessage)
	Addline6 = math.Clamp(Addline6 + 8 * FrameTime(), 0, #MPCSSpotMessage2)
else
	Addline5 = math.Clamp(Addline5 - 8 * FrameTime(), 0, #MPCSSpotMessage)
	Addline6 = math.Clamp(Addline6 - 8 * FrameTime(), 0, #MPCSSpotMessage2)
end

	LineTotalsSpawn = math.Round(Addline1 + Addline2 + Addline3 + Addline4, 0)
	AllWordsSpawn = math.Round(#MPCSMessage2 + #PlayerTitle + #Timestamp + #MPCSMessage, 0)
	LineTotalsSpot = math.Round(Addline3 + Addline4 + Addline5 + Addline6, 0)
	AllWordsSpot = math.Round(#MPCSSpotMessage2 + #PlayerTitle + #Timestamp + #MPCSSpotMessage, 0)

if SpawnScrollTitleStart == true then
if LineTotalsSpawn > 0 then
	BetaVal = 255
else
	BetaVal = 0
end
end

if SpotScrollTitleStart == true then
if LineTotalsSpot > 0 then
	BetaVal2 = 255
else
	BetaVal2 = 0
end
end
end

if !ply:Alive() then
	SpawnTitleStart = false
	PlayerRespawn = false
	AlphaVal = 0
	Delay = GetConVar("MapPromptsIntroDelay"):GetInt()
	Delay3 = GetConVar("MapPromptsIntroDelay"):GetInt()
end

if ply:Alive() and AlwaysSpawnMessage then
	PlayerRespawn = true
end

if ply:Alive() and PlayerRespawn == "" and FirstRespawn then
	PlayerRespawn = true
end

if ply:Alive() and PlayerRespawn == true then
	SpawnTitleStart = true
	SpawnScrollTitleStart = true
	PlayerRespawn = false
end

if SpawnTitleStart == true and AlphaVal == 255 then
	Delay = math.Clamp(Delay - FrameTime() * 2, 0, GetConVar("MapPromptsIntroDelay"):GetInt())
end

if SpawnScrollTitleStart == true and LineTotalsSpawn == AllWordsSpawn then
	Delay3 = math.Clamp(Delay3 - FrameTime() * 2, 0, GetConVar("MapPromptsIntroDelay"):GetInt())
end

if SpawnTitleStart == true and Delay == 0 then
	SpawnTitleStart = false
end
	if SpawnScrollTitleStart == true and Delay3 == 0 then
	SpawnScrollTitleStart = false
end

if SpawnTitleStart == true then
	AlphaVal = math.Clamp(AlphaVal + FadeSpeed * FrameTime(), 0, 255)
else
	AlphaVal = math.Clamp(AlphaVal - FadeSpeed * FrameTime(), 0, 255)
end

if GetConVar("MapPromptsEnableMissionName"):GetBool() then
	draw.DrawText( FinalMessage, PlayerFont, ScrW() * Width, ScrH() * (Height + (0.03 * CustomAdd1)), Alpha, Alignment )
end
if GetConVar("MapPromptsEnableMapName"):GetBool() then
	draw.DrawText( FinalMessage2, PlayerFont, ScrW() * Width, ScrH() * (Height + (0.03 * CustomAdd2)), Alpha, Alignment )
end
if GetConVar("MapPromptsEnablePlayerName"):GetBool() then
	draw.DrawText( FinalPlayerTitle, PlayerFont, ScrW() * Width, ScrH() * (Height + (0.03 * CustomAdd3)), Alpha, Alignment )
end
if GetConVar("MapPromptsEnableTimeStamp"):GetBool() then
	draw.DrawText( FinalTimestamp, PlayerFont, ScrW() * Width, ScrH() * (Height + (0.03 * CustomAdd4)), Alpha, Alignment )
end

// Stop here
// Now we get to the fun part
// The custom location prompts

local MPCSSpotX1 = math.Clamp(XPos, 3444, 3776)
local MPCSSpotY1 = math.Clamp(YPos, 2624, 3072)
local MPCSSpotZ1 = math.Clamp(ZPos, -64, 74)

local MPCSSpotX2 = math.Clamp(XPos, 320, 400)
local MPCSSpotY2 = math.Clamp(YPos, 15, 50)
local MPCSSpotZ2 = math.Clamp(ZPos, -64, -32)

local MPCSSpotX3 = math.Clamp(XPos, -580, -350)
local MPCSSpotY3 = math.Clamp(YPos, -100, 220)
local MPCSSpotZ3 = math.Clamp(ZPos, -100, -5)

// These are examples of custom locations
// You get these from using the 'MarkPosition' and 'CreatePosition' commands
// They are automatically formatted, so you only have to copy/paste them here
// And then edit the "CustomSpot" name to fit MPCS

local MapPrompts_CustomSpot1 = (XPos == MPCSSpotX1 and YPos == MPCSSpotY1 and ZPos == MPCSSpotZ1)

local MapPrompts_CustomSpot2 = (XPos == MPCSSpotX2 and YPos == MPCSSpotY2 and ZPos == MPCSSpotZ2)

local MapPrompts_CustomSpot3 = (XPos == MPCSSpotX3 and YPos == MPCSSpotY3 and ZPos == MPCSSpotZ3)

// These are the custom locations
// Each one has unique coordinates, for creating specific prompts
// Though you can have multiple spots trigger the same message, as youll see below
// Use the above examples to add in more locations

local MapPrompts_CustomSpot = MapPrompts_CustomSpot1 or MapPrompts_CustomSpot2 or MapPrompts_CustomSpot3

// This line must contain ALL of the tables above
// This is for starting the fade in effect of the text
// I.e. When you reach any of the custom spots, the text will begin to appear

if !ply:Alive() or PromptsEnabled == false then
	SpotTitleStart = false
	SpotScrollTitleStart = false
	AlphaVal2 = 0
	end

if MapPrompts_CustomSpot1 then
	FixedSpotMessage = MPCSExtraSpotMessage
	FixedSpotMessage2 = "Custom Location"
end

// This spot will create a name from MPCSExtraMessage table
// And the location will use a specific name

if MapPrompts_CustomSpot2 or MapPrompts_CustomSpot3 then
	FixedSpotMessage = MPCSMessage
	FixedSpotMessage2 = MPCSMessage2
end

// The above set uses two specific spots, and will trigger the title and location on the spawn message
// Rather than using custom ones
// Do note that FixedSpotMessage and FixedSpotMessage2 must always be defined
// Otherwise the code throws an error
// If you dont want the message to change from the previous location, simply use the same line
// In this case, replace MPCSMessage with MPCSExtraSpotMessage
// And the second and third locations will display the same name
// Or replace MPCSMessage2 with "Custom Location"

// And thats about it
// The rest of this code performs the text fade in/out
// So theres no reason to touch it
// And so we're done
// Good job, you've now created a custom Map Prompts extension pack
// (So long as nothing went wrong)

if MapPrompts_CustomSpot and AlphaVal == 0 then
	SpotTitleStart = true
end
if MapPrompts_CustomSpot and LineTotalsSpot == 0 then
	SpotScrollTitleStart = true
end

if !MapPrompts_CustomSpot and AlphaVal2 == 255 then
	Delay2 = math.Clamp(Delay2 - FrameTime() * 2, 0, GetConVar("MapPromptsLocationDelay"):GetInt())
elseif !MapPrompts_CustomSpot and AlphaVal2 == 0 then
	Delay2 = GetConVar("MapPromptsLocationDelay"):GetInt()
end

if !MapPrompts_CustomSpot and LineTotalsSpot == AllWordsSpot and !SpawnScrollTitleStart then
	Delay4 = math.Clamp(Delay4 - FrameTime() * 2, 0, GetConVar("MapPromptsLocationDelay"):GetInt())
elseif !MapPrompts_CustomSpot and LineTotalsSpot == 0 then
	Delay4 = GetConVar("MapPromptsLocationDelay"):GetInt()
end

if MapPrompts_CustomSpot and ConstantAreaTrigger then
	Delay2 = GetConVar("MapPromptsLocationDelay"):GetInt()
	Delay4 = GetConVar("MapPromptsLocationDelay"):GetInt()
end
if MapPrompts_CustomSpot and !ConstantAreaTrigger and AlphaVal2 == 255 then
	Delay2 = math.Clamp(Delay2 - RealFrameTime() * 2, 0, GetConVar("MapPromptsLocationDelay"):GetInt())
end
if MapPrompts_CustomSpot and !ConstantAreaTrigger and LineTotalsSpot == AllWordsSpot then
	Delay4 = math.Clamp(Delay4 - RealFrameTime() * 2, 0, GetConVar("MapPromptsLocationDelay"):GetInt())
end

if SpotTitleStart == true and Delay2 == 0 then
	SpotTitleStart = false
end
if SpotScrollTitleStart == true and Delay4 == 0 then
	SpotScrollTitleStart = false
end

if SpotTitleStart == true then
	AlphaVal2 = math.Clamp(AlphaVal2 + FadeSpeed * FrameTime(), 0, 255)
else
	AlphaVal2 = math.Clamp(AlphaVal2 - FadeSpeed * FrameTime(), 0, 255)
end

if GetConVar("MapPromptsEnableMissionName"):GetBool() then
	draw.DrawText( FinalSpotMessage, PlayerFont, ScrW() * Width, ScrH() * (Height + (0.03 * CustomAdd1)), Alpha2, Alignment )
end
if GetConVar("MapPromptsEnableMapName"):GetBool() then
	draw.DrawText( FinalSpotMessage2, PlayerFont, ScrW() * Width, ScrH() * (Height + (0.03 * CustomAdd2)), Alpha2, Alignment )
end
if GetConVar("MapPromptsEnablePlayerName"):GetBool() then
	draw.DrawText( FinalPlayerTitle, PlayerFont, ScrW() * Width, ScrH() * (Height + (0.03 * CustomAdd3)), Alpha2, Alignment )
end
if GetConVar("MapPromptsEnableTimeStamp"):GetBool() then
	draw.DrawText( FinalTimestamp, PlayerFont, ScrW() * Width, ScrH() * (Height + (0.03 * CustomAdd4)), Alpha2, Alignment )
end

end)
end
