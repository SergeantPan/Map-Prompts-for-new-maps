// Before we even start, do this:
// Press CTRL + H and Replace all occurrences of MapPrompts_Custom and MPCS with your own names
// Give each one a different name, otherwise conflicts will occur

	local AlphaVal = 0 // Spawn Message
	local AlphaVal2 = 0 // Spot Message

	local Addline1 = 0
	local Addline2 = 0
	local Addline3 = 0
	local Addline4 = 0
	local Addline5 = 0
	local Addline6 = 0

	local FixedSpotMessage = ""
	local MPCSSpotMessage2 = ""

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

	local UniqueMPCSMessage = table.Random(MPCSMessage)

// This picks a random name from the table, then sticks to it

local MPCSExtraMessage = {
'"Custom Prompt 1"',
'"Custom Prompt 2"',
'"Custom Prompt 3"',
'"Custom Prompt 4"'
}

// This is an extra message
// We can use these for unique locations
// You'll want to have separate tables for each location, unless you want messages to be shared

	local UniqueMPCSSpotMessage = table.Random(MPCSExtraMessage)
//	 		^^						    	^^
// If you want, you can rename these
// This is how the random text is handled, you should leave it alone for the most part
// It's almost the same as above, except this is for custom locations
// Do note that MPCSExtraMessage must be the same as the table above
// MapPrompts_Custom1 can be anything, however it must be continued below
// With multiple tables, you can just copy/paste the first one, but make sure to add in a special pre/suffix
// I.e. A number, or word at the beginning/end of each table
// MPCSExtraMessage1, MPCSExtraMessage2, MPCSExtraMessage3 etc.

	MapPrompts_CustomFakeClockHr = 20 // 0-23 This is the 24hr clock
	MapPrompts_CustomFakeClockHrAlternate = 8 // 0 - 11 This is the 12hr clock

// Although you may not use the 12hr style, we still need to apply it
// However, FakeClockHrAlternate cannot go above 12
// If FakeClockHr goes above 12, then Alternate restarts at 0
// Like this:
// FakeClockHr          = 10 11 12 13 14 15 16 17 18
// FakeClockHrAlternate = 10 11 0  1  2  3  4  5  6

	MapPrompts_CustomFakeClockMin = 35 // 0 -  59 Minutes
	MapPrompts_CustomFakeClockSec = 42 // 0 -  59 Seconds

// These are the time values for the 'Fake Clock'
// You can (and should) edit the number values
// They will dictate the time at which the spawn/location prompt time starts at
// The clock will not save over restarts or map changes
// Use StormFox 2 for that

	Suffix = ""

// Do not touch suffix, he is a gentle boi

// Below is the heart and soul of the FakeClock mechanic
// I suggest not touching anything here
// Only alter the MapPrompts_Custom portion of the function and timer

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

if GetConVar("MapPromptsUniqueMapNames"):GetBool() and GetConVar("MapPromptsCustomMapName"):GetString() == "" then
	MPCSMessage2 = "Custom Location"
elseif GetConVar("MapPromptsCustomMapName"):GetString() != "" then
	MPCSMessage2 = GetConVar("MapPromptsCustomMapName"):GetString()
else
	MPCSMessage2 = "CustLoc"
end

// Here we edit the "Location" portion of the message
// "Custom Location" is the full length name
// E.g: "City 17 - Train Station"
// CustLoc is the shortened version
// E.g: "C17 - TS" or "C17-01"
// Or whatever you feel like
// The middle one handles player-chosen names
// Dont touch it

if GetConVar("MapPromptsCustomMissionName"):GetString() != "" then
	MPCSCustomLocation = GetConVar("MapPromptsCustomMissionName"):GetString()
	MPCSCustomLocation2 = GetConVar("MapPromptsCustomMissionName"):GetString()
else
	MPCSCustomLocation = UniqueMPCSSpotMessage
	MPCSCustomLocation2 = UniqueMPCSSpotMessage2
end

// This handles the player-chosen vs preset location
// MPCSCustomLocation can be whatever, so long as its continued below
// UniqueMPCSSpotMessage must be the same as above (the table.Random() portion)

if GetConVar("MapPromptsCustomMissionName"):GetString() != "" then
	Message = GetConVar("MapPromptsCustomMissionName"):GetString()
else
	Message = UniqueMGCT1Message
end

// This is the mission name
// The prompt at the top
// Same deal as the others

if GetConVar("MapPromptsUseCustomFont"):GetInt() == 1 then
	PlayerFont = "PlayerCustomFont"
else
	PlayerFont = "MapPromptsCustom"
end

// This is the font
// You dont need to do anything to this
// It handles itself

// Do not touch anything below until the next message

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

if IsValid(StormFox2) then
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
elseif GetConVar("MapPromptsTimeStampStyle"):GetInt() == 3 and IsValid(SF2TimeStamp) then
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
	local ZPos = math.Round(tostring(ply:GetPos().z), 0) + 5
//											^^
// This means the prompt wont look for the players position on the ground
// But rather slightly above it
// This means that areas that arent flat will still trigger the prompt

if ScrollingTitles == true then
	FinalMessage = string.Left(Message, Addline1)
	FinalMessage2 = string.Left(MPCSMessage2, Addline2)
	FinalPlayerTitle = string.Left(PlayerTitle, Addline3)
	FinalTimestamp = string.Left(Timestamp, Addline4)
	FinalSpotMessage = string.Left(FixedSpotMessage, Addline5)
	FinalSpotMessage2 = string.Left(MPCSSpotMessage2, Addline6)
else
	FinalMessage = Message
	FinalMessage2 = MPCSMessage2
	FinalPlayerTitle = PlayerTitle
	FinalTimestamp = Timestamp
	FinalSpotMessage = FixedSpotMessage
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
	Addline1 = math.Clamp(Addline1 + 8 * FrameTime(), 0, #Message)
	Addline2 = math.Clamp(Addline2 + 8 * FrameTime(), 0, #MPCSMessage2)
else
	Addline1 = math.Clamp(Addline1 - 8 * FrameTime(), 0, #Message)
	Addline2 = math.Clamp(Addline2 - 8 * FrameTime(), 0, #MPCSMessage2)
end

if SpotScrollTitleStart == true then
	Addline5 = math.Clamp(Addline5 + 8 * FrameTime(), 0, #FixedSpotMessage)
	Addline6 = math.Clamp(Addline6 + 8 * FrameTime(), 0, #MPCSSpotMessage2)
else
	Addline5 = math.Clamp(Addline5 - 8 * FrameTime(), 0, #FixedSpotMessage)
	Addline6 = math.Clamp(Addline6 - 8 * FrameTime(), 0, #MPCSSpotMessage2)
end

	LineTotalsSpawn = math.Round(Addline1 + Addline2 + Addline3 + Addline4, 0)
	AllWordsSpawn = math.Round(#MPCSMessage2 + #PlayerTitle + #Timestamp + #Message, 0)
	LineTotalsSpot = math.Round(Addline3 + Addline4 + Addline5 + Addline6, 0)
	AllWordsSpot = math.Round(#MPCSSpotMessage2 + #PlayerTitle + #Timestamp + #FixedSpotMessage, 0)

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
	draw.DrawText( FinalMessage, "MapPromptsCustom", ScrW() * Width, ScrH() * (Height + (0.03 * CustomAdd1)), Alpha, Alignment )
end
if GetConVar("MapPromptsEnableMapName"):GetBool() then
	draw.DrawText( FinalMessage2, "MapPromptsCustom", ScrW() * Width, ScrH() * (Height + (0.03 * CustomAdd2)), Alpha, Alignment )
end
if GetConVar("MapPromptsEnablePlayerName"):GetBool() then
	draw.DrawText( FinalPlayerTitle, "MapPromptsCustom", ScrW() * Width, ScrH() * (Height + (0.03 * CustomAdd3)), Alpha, Alignment )
end
if GetConVar("MapPromptsEnableTimeStamp"):GetBool() then
	draw.DrawText( FinalTimestamp, "MapPromptsCustom", ScrW() * Width, ScrH() * (Height + (0.03 * CustomAdd4)), Alpha, Alignment )
end

// Until now, if everything went smoothly you wont have to do anything
// Thats the easy part

// Now the fun part

local MapPrompts_CustomSpotX1 = math.Clamp(XPos, -3000, -2800)
local MapPrompts_CustomSpotY1 = math.Clamp(YPos, -1535, -1415)
local MapPrompts_CustomSpotZ1 = math.Clamp(ZPos, -144, -27)

local MapPrompts_CustomSpotX2 = math.Clamp(XPos, -3000, -2800)
local MapPrompts_CustomSpotY2 = math.Clamp(YPos, -1535, -1415)
local MapPrompts_CustomSpotZ2 = math.Clamp(ZPos, -144, -27)

local MapPrompts_CustomSpotX3 = math.Clamp(XPos, -3000, -2800)
local MapPrompts_CustomSpotY3 = math.Clamp(YPos, -1535, -1415)
local MapPrompts_CustomSpotZ3 = math.Clamp(ZPos, -144, -27)

// ^^ These are map coordinates ^^
// These are unique to each map, and determine the triggers for custom location prompts
// X and Y are the generic player location in the world
// Z is a bit more tricky, because it's the position of the player on the ground
// Lets explain how you can do this yourself:

// When you are ingame, and at a location you wish to have a custom prompt
// Use MarkPosition1 and MarkPosition2 to mark opposing corners
// Note that these coordinates are based on what you are looking at
// Think of it as a line coming out of your eyes
// Once both corners are marked, use CreatePosition
// Something like this should appear in the console:

// local CustomSpotX1 = math.Clamp(-3264, 1472)
// local CustomSpotY1 = math.Clamp(-1215, 1408)
// local CustomSpotZ1 = math.Clamp(-11136, -11007)

// This is our custom location
// Simply paste it above and replace CustomSpot with your own prefix
// There, the custom location has been created

local MapPrompts_CustomSpot = (XPos == MapPrompts_CustomSpotX1 and YPos == MapPrompts_CustomSpotY1 nd ZPos == MapPrompts_CustomSpotZ1) or (XPos == MapPrompts_CustomSpotX2 and YPos == MapPrompts_CustomSpotY2 and ZPos == MapPrompts_CustomSpotZ2)

// This table contains ALL the custom locations
// This is how the code triggers the fade in/out mechanic
// You must ALWAYS put the custom coordinates here:
// (XPos == MapPrompts_CustomSpotX1 and YPos == MapPrompts_CustomSpotY1 nd ZPos == MapPrompts_CustomSpotZ1)

local MapPrompts_CustomSpot1 = (XPos == MapPrompts_CustomSpotX1 and YPos == MapPrompts_CustomSpotY1 and ZPos == MapPrompts_CustomSpotZ1)

// This is for making specific locations
// This is how we trigger unique messages
// Each unique location must have a separate line
// Unless you want multiple locations to trigger the same message

if !ply:Alive() or PromptsEnabled == false then
	SpotTitleStart = false
	SpotScrollTitleStart = false
	AlphaVal2 = 0
	end

if MegaCityOne1Spot1 then
	FixedSpotMessage = MPCSCustomLocation
	MPCSSpotMessage2 = MPCSMessage2
end

// Remember MPCSCustomLocation from the start of the file?
// This is where that comes in handy
// So long as a player-chosen location is not in use, it will use a name from said table
// The first part is the title portion, inside the quotation marks
// The second half is the unique location name, unless unique map names are disabled
// In which case it changes to the second variant

// Unless you want it to only be a specific text
// In which case replace MPCSCustomLocation with "Custom Text Here"

// FixedSpotMessage = "Custom Text Here"

// You can also replace MPCSMessage2 with a custom name
// This will alter the second line of text on the prompt
// I recommend this if you want to have unique location names

// MPCSSpotMessage2 = "Custom Location Here"

// The rest of this you are free to ignore
// And that's it!
// You've added Map Prompts support for a completely new map!
// You've also saved me the hassle of having to do it myself, so thanks!

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
	draw.DrawText( FixedSpotMessage, "MapPromptsCustom", ScrW() * Width, ScrH() * (Height + (0.03 * CustomAdd1)), Alpha2, Alignment )
end
if GetConVar("MapPromptsEnableMapName"):GetBool() then
	draw.DrawText( MPCSMessage2, "MapPromptsCustom", ScrW() * Width, ScrH() * (Height + (0.03 * CustomAdd2)), Alpha2, Alignment )
end
if GetConVar("MapPromptsEnablePlayerName"):GetBool() then
	draw.DrawText( PlayerTitle, "MapPromptsCustom", ScrW() * Width, ScrH() * (Height + (0.03 * CustomAdd3)), Alpha2, Alignment )
end
if GetConVar("MapPromptsEnableTimeStamp"):GetBool() then
	draw.DrawText( Timestamp, "MapPromptsCustom", ScrW() * Width, ScrH() * (Height + (0.03 * CustomAdd4)), Alpha2, Alignment )
end

end)
end
