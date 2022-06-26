// Before we even start, do this:
// Press CTRL + H and Replace all occurrences of MapPrompts_Custom and MPCS with your own names
// Give each one a different name, otherwise conflicts will occur

	local AlphaVal = 0 // Spawn Message
	local AlphaVal2 = 0 // Spot Message

	local Message = "" // Custom Message)
	local FixedSpotMessage = ""

	local PlayerRespawn = ""
// ^ Dont touch this stuff ^

if GetConVar("MapPromptsUniqueMapNames"):GetBool() then // The Map
	MPCSMessage2 = "MapPrompts_Custom"
else
	MPCSMessage2 = "Gm_MapPrompts_Custom"
end

// This is what determines the second line of text, aka the Location
// The first prompt is for when unique locations are enabled
// You can name it as you wish, though a good style is to keep it relevant to the map e.g: "City 17 - Trainstation"
// The second prompt is the "simplified" name
// E.g; Gm_Construct. The first prompt is "Construct", the second prompt is simply "Gm_Construct"

	local Delay = GetConVar("MapPromptsIntroDelay"):GetInt()
	local Delay2 = GetConVar("MapPromptsLocationDelay"):GetInt()
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

if GetConVar("MapPromptsCampaignTitles"):GetBool() then
	MPCSFixedMessage = '"Custom Fixed Title"'
	else
	MPCSFixedMessage = table.Random(MPCSMessage)
end

// This is how we handle the text randomization
// If campaign titles are enabled, then the message will change to Custom Fixed Title
// Otherwise, it will use one of the many prompts in MPCSMessage

local MPCSExtraMessage = {
'"Custom Prompt 1"',
'"Custom Prompt 2"',
'"Custom Prompt 3"',
'"Custom Prompt 4"'
}

// This is an extra message
// We can use these for unique locations
// You'll want to have separate tables for each location, unless you want messages to be shared

if GetConVar("MapPromptsCampaignTitles"):GetBool() then
	MapPrompts_Custom1Message1 = '"Map Title"'
	else
	MapPrompts_Custom1Message1 = table.Random(MPCSExtraMessage)
end
//	  ^^						    			^^
// If you want, you can rename these
// This is how the random text is handled, you should leave it alone for the most part
// It's almost the same as above, except this is for custom locations
// Do note that MPCSExtraMessage must be the same as the table above
// MapPrompts_Custom1 can be anything, however it must be continued below

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
// They will dictate the time at which the spawn/location prompt time starts at
// The clock will not save over restarts or map changes
// Use StormFox 2 for that

	Suffix = ""

// Do not touch suffix, he is a gentle boi

// Below is the heart and soul of the FakeClock mechanic
// I suggest not touching anything here
// Only alter the MapPrompts_Custom portion of the function and timer

local function MapPrompts_Custom_FakeClock() // This is the fake clock

	if MapPrompts_CustomFakeClockSec < 59 then        // It is very messy, but it works
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

	if GetConVar("MapPromptsTimeStamp12h"):GetBool() and MapPrompts_CustomFakeClockHr >= 12 then
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


// Do not touch anything below until the next message

	local FadeSpeed = 80 * GetConVar("MapPromptsTextFadeSpeed"):GetInt()
	local AlwaysSpawnMessage = GetConVar("MapPromptsAlwaysOnSpawn"):GetBool()

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
	local SF2TimeStamp = StormFox2.Time.TimeToString(nil, StormFox2.Setting.GetCache("12h_display"))
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
	if MapPrompts_CustomFakeClockHr < 10 then
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
	elseif GetConVar("MapPromptsTimeStamp12h"):GetBool() and GetConVar("MapPromptsTimeStampStyle"):GetInt() == 1  then
	Suffix = " %p"
	else
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

	local Alpha = Color( 255, 255, 255, math.Clamp(AlphaVal, 0, 255) )
	local Alpha2 = Color( 255, 255, 255, math.Clamp(AlphaVal2, 0, 255) )

	local XPos = math.Round(tostring(ply:GetPos().x), 0)
	local YPos = math.Round(tostring(ply:GetPos().y), 0)
	local ZPos = math.Round(tostring(ply:GetPos().z), 0)

if Message == "" then
Message = FixedMessage
end

if !ply:Alive() then
	SpawnTitleStart = false
	PlayerRespawn = false
	AlphaVal = 0
	Delay = GetConVar("MapPromptsIntroDelay"):GetInt()
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

	if SpawnTitleStart == true and Delay == 0 then
	SpawnTitleStart = false
	end

	if SpawnTitleStart == true then
	AlphaVal = math.Clamp(AlphaVal + FadeSpeed * FrameTime(), 0, 255)
	else
	AlphaVal = math.Clamp(AlphaVal - FadeSpeed * FrameTime(), 0, 255)
	end

if GetConVar("MapPromptsEnableMissionName"):GetBool() then
	draw.DrawText( Message, "MapPromptsCustom", ScrW() * Width, ScrH() * (Height + (0.03 * CustomAdd1)), Alpha, Alignment )
end

// STOP!!!

if GetConVar("MapPromptsEnableMapName"):GetBool() then
	draw.DrawText( MPCSMessage2, "MapPromptsCustom", ScrW() * Width, ScrH() * (Height + (0.03 * CustomAdd2)), Alpha, Alignment )
end

// MPCSMessage2
// Search for that at the top of the file
// This should be the very first name we modified
// If it's incorrect, the addon will throw errors

if GetConVar("MapPromptsEnablePlayerName"):GetBool() then
	draw.DrawText( PlayerTitle, "MapPromptsCustom", ScrW() * Width, ScrH() * (Height + (0.03 * CustomAdd3)), Alpha, Alignment )
end
if GetConVar("MapPromptsEnableTimeStamp"):GetBool() then
	draw.DrawText( Timestamp, "MapPromptsCustom", ScrW() * Width, ScrH() * (Height + (0.03 * CustomAdd4)), Alpha, Alignment )
end

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
// Go to one corner of the area (noclipping into walls is acceptable, and even reasonable)
// Use the console command 'MarkPosition'
// Something like this should appear in the console:

// Your X: 346
// Your Y: 357
// Your Z: 50

// Now do this again for the opposite corner

// Your X: 172
// Your Y: 865
// Your Z: 45

// Now we have our box. Now to make it a functional area in the code

// If we are using positive values (as above) then the finished line should look like this

// local MapPrompts_CustomSpotX1 = math.Clamp(XPos, 172, 346)
// local MapPrompts_CustomSpotY1 = math.Clamp(YPos, 357, 865)
// local MapPrompts_CustomSpotZ1 = math.Clamp(ZPos, 45, 50)

// However, if we are dealing with negatives, then we have to reverse the positions

// local MapPrompts_CustomSpotX1 = math.Clamp(XPos, -346, -172)
// local MapPrompts_CustomSpotY1 = math.Clamp(YPos, -865, -357)
// local MapPrompts_CustomSpotZ1 = math.Clamp(ZPos, -50, -45)

// If the coordinates are negative, then the number FURTHEST from 0 must be first
// -50 > -45
// The one closest to 0 will be second
// Also, I suggest putting some leeway to the values
// The system can be a bit finnicky, so I suggest making the X and Y coordinates ~10-15 bigger than they are

// Again, using the last examples:

// local MapPrompts_CustomSpotX1 = math.Clamp(XPos, 165, 375)
// local MapPrompts_CustomSpotY1 = math.Clamp(YPos, 325, 895)
// local MapPrompts_CustomSpotZ1 = math.Clamp(ZPos, 25, 80)

// The Z value has a lot more leniency, because of funky LUA mechanics
// With negatives it gets a bit tricky
// But basically, "Bigger" number becomes bigger, smaller number becomes smaller

// local MapPrompts_CustomSpotX1 = math.Clamp(XPos, -380, -125)
// local MapPrompts_CustomSpotY1 = math.Clamp(YPos, -900, -300)
// local MapPrompts_CustomSpotZ1 = math.Clamp(ZPos, -90, -25)

// There, we have our map coordinates

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
	AlphaVal2 = 0
	end

// ^ Ignore ^

if MapPrompts_CustomSpot1 then
	FixedSpotMessage = MapPrompts_Custom1Message1
if GetConVar("MapPromptsUniqueMapNames"):GetBool() then
	MPCSMessage2 = "Unique Title"
	else
	MPCSMessage2 = "Simple Title"
end
end

// Remember MapPrompts_Custom1Message1 from the start of the file?
// This is where that comes in handy
// When we enter our new custom location, the text prompt will be chosen from that specific table
// The first part is the title portion, inside the quotation marks
// The second half is the unique location name, unless unique map names are disabled
// In which case it changes to the second variant

// Unless you want it to only be a specific text
// In which case replace MapPrompts_Custom1Message1 with "Custom Text Here"

// FixedSpotMessage = "Custom Text Here"

// The rest of this you are free to ignore
// And that's it!
// You've added Map Prompts support for a completely new map!
// You've also saved me the hassle of having to do it myself, so thanks!

if MapPrompts_CustomSpot and AlphaVal == 0 then
	SpotTitleStart = true
end

if !MapPrompts_CustomSpot and AlphaVal2 == 255 then
	Delay2 = math.Clamp(Delay2 - FrameTime() * 2, 0, GetConVar("MapPromptsLocationDelay"):GetInt())
elseif !MapPrompts_CustomSpot and AlphaVal2 == 0 then
	Delay2 = GetConVar("MapPromptsLocationDelay"):GetInt()
end

if MapPrompts_CustomSpot and ConstantAreaTrigger then
	Delay2 = GetConVar("MapPromptsLocationDelay"):GetInt()
end
if MapPrompts_CustomSpot and !ConstantAreaTrigger and AlphaVal2 == 255 then
	Delay2 = math.Clamp(Delay2 - RealFrameTime() * 2, 0, GetConVar("MapPromptsLocationDelay"):GetInt())
end
if SpotTitleStart == true and Delay2 == 0 then
	SpotTitleStart = false
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
