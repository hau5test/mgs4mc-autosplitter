/*****************************
Autospliter for Metal Gear Solid 4 Master Collection on PC
Original work by https://github.com/hau5test
With help from https://github.com/zexk and SnakeSwiss.
******************************/
/**
* via https://github.com/zexk/bbtracker/blob/master/docs/mgs4_research.md
*/
/*
linkvarbuf mapping:
0x0000 	uint32 	completed-playthrough count
0x0004 	uint16 	title-initialization field; domain unknown
0x0006 	uint16 	difficulty
0x0034 	char[7] 	stage code
0x0054 	uint32 	scenario progress
0x0158 	uint16 	continues
0x0168 	uint32 	total play time
0x016e 	uint16 	alert phases
0x0178 	uint16 	kills
0x017a 	uint16 	special-item use, zero/nonzero
0x0180 	uint16 	CQC uses; shared by BEAR and ASSASSIN
0x0182 	uint16 	headshots
0x0184 	uint16 	knife kills
0x0186 	uint16 	knife knockouts
0x0188 	uint16 	prone side rolls
0x018a 	uint16 	forward rolls
0x018c 	uint16 	Combat Highs
0x018e 	uint16 	weapon pickups
0x0190 	uint16 	item pickups
0x0192 	uint16 	hold-ups
0x0194 	uint16 	body searches
0x0196 	uint16 	praises
0x0198 	uint16 	items donated
0x019a 	uint16 	Syringe uses
0x019c 	uint16 	Scanning Plug uses
0x019e 	uint16 	Playboy pages turned
0x01a0 	uint16 	Emotion Magazine pages turned
0x01a8 	uint32 	crouch time
0x01ac 	uint32 	crawl time
0x01b4 	uint32 	wall-press time
0x01b8, 0x01bc 	uint32 	box/drum timer components
0x01c0, 0x01c4 	uint32 	Drebin points copies
0x01d4 	uint16[95] 	weapon states, IDs 0..94
0x0350 	uint16[68] 	separate inventory-related array
0x0526 	uint16[99] 	item states, IDs 0..98
0x0ae0 	uint16 	recovery items used
0x5a34 	uint16 	flashbacks viewed; target 273
*/

/*
Sig Scans provided by SnΔke_Swiss:
48 8B 15 ?? ?? ?? ?? 48 63 82 60 01 00 00 49
-> mgs4.exe + 41792
*/

/*
mapNames:
init        //boot up sequence
title       //main menu
mg_setu    //loading screen
title_m     //tv channels

s00a00l 	Prologue Cemetery
s00a10l 	Ending Cemetery
s01a00l, s01a05l 	Middle East - Infiltration
s01a10l 	Red Zone
s01a20l 	Militia Safehouse
s01a30l 	Urban Ruins
s01a40l 	Advent Palace
s01a50l, s01a55l 	Crescent Meridian
s01a57l 	Millennium Park
s01a60l 	Liquid's Encampment
s02a10l 	Cove Valley Village
s02a20l, s02a25l 	Power Station
s02a30l 	Confinement Facility
s02a40l 	Vista Mansion
s02a50l 	Research Lab
s02a60l 	Mountain Trail / Riverside
s02a70l 	Vamp Ambush
s02a73l, s02a75l, s02a78l 	Stryker Escape
s02a80l 	High Woodlands Highway
s02a85l 	Marketplace Entrance
s02a90l 	Marketplace
s02a95l 	Marketplace Plaza
s03a00l 	Eastern Europe Station
s03a10l, s03a15l 	Midtown: Resistance Tail
s03a16l 	Midtown: Canals
s03a20l 	Midtown: Plaza
s03a25l 	Midtown: North Sector
s03a30l 	Church Courtyard
s03a35l, s03a40l, s03a60l 	Motorcycle Chase
s03a50l 	Raging Raven Ambush
s03a65l, s03a70l 	Echo's Beacon
s03a90l 	Volta River
s04a05l 	Metal Gear Solid Flashback
s04a10l 	Snowfield / Heliport / Tank Hangar
s04a20l 	Nuclear Warhead Storage Building
s04a30l 	Snowfield / Communications Tower
s04a40l 	Blast Furnace / Casting Facility
s04a50l 	Underground Base
s04a60l 	Underground Supply Tunnel
s04a65l 	REX Escape
s04a68l 	Port Area
s04a70l 	Port Area: REX vs. RAY
s04a75l 	Outer Haven Arrival
s05a10l 	Ship Bow
s05a20l 	Command Center / Missile Hangar
s05a30l 	Microwave Corridor
s05a40l 	GW
s05a45l 	Liquid Ocelot: Prelude
s05a50l 	Liquid Ocelot
s05a55l 	Liquid Ocelot: Aftermath
s10a10l 	Nomad Mission Briefing
s10a20l 	Nomad: South America Briefing
s10a30l 	Nomad: Eastern Europe Briefing
s10a40l 	Nomad: Shadow Moses Briefing
s20a00l 	USS Missouri
s20a10l 	USS Missouri vs. Outer Haven
s20a20l 	Campbell's Room
s30a00l 	Wedding
s30a10l 	Hospital

*/

state("mgs4") {
    // temporary for testing
    uint GameTime: 0x1C28B28, 0x0168;
    string7 MapName: 0x1C28B28, 0x34;
    uint scenarioProgress: 0x1C28B28, 0x54;
    uint difficulty: 0x1C28B28, 0x6; //LE = 20, NN = 30, SN = 35, BBH = 40, TBE = 50
    /*
    */
}

startup {

/*
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
*/
    //This allows is to look through a bitmask in order to get split information
    vars.bitCheck = new Func<int, int, bool>((int val, int b) => (val & (1 << b)) != 0);
    
    vars.difficultyName = "";

    settings.Add("splits", true, "Split Points");
    settings.CurrentDefaultParent = "act1";
    settings.Add("act1", true, "Act 1", "splits");
      settings.Add("0_1", false, "End of TV Channels");
      settings.Add("1_2", false, "Middle East - Infiltration - Area 1");
      settings.Add("6_7", false, "Middle East - Infiltration - Area 2");
      settings.Add("7_8", false, "Middle East - Infiltration - Area 3");
      settings.Add("14_17", false, "Act 1 Briefing Done");
      settings.Add("17_18", false, "Middle East - Red Zone NW Sector");
      settings.Add("s01a10l_s01a20l", false, "Middle East - Red Zone");
      settings.Add("19_22", false, "Middle East - Militia Safe House");
      settings.Add("s01a20l_s01a30l", false, "Met Drebin");
      settings.Add("29_30", false, "Middle East - Downtown - Ruins");
      settings.Add("s01a30l_s01a40l", false, "Middle East - Downtown");
      settings.Add("31_32", false, "Middle East - Advent Palace - Entry");
      settings.Add("36_37", false, "Met Rat Patrol");
      settings.Add("37_38", false, "Middle East - Advent Palace - End of Frog Attack");
      settings.Add("s01a40l_s01a50l", false, "Middle East - Advent Palace End");
      settings.Add("s01a50l_s01a55l", false, "Middle East - Crescent Meridian - Area 1");
      settings.Add("s01a55l_s01a57l", false, "Middle East - Crescent Meridian - Cutscene");
      settings.Add("45_46", false, "Middle East - Millenium Park");
      settings.Add("s01a60l_mg_setu", false, "End of Act 1");

    settings.CurrentDefaultParent = "act2";
    settings.Add("act2", true, "Act 2", "splits");
      settings.Add("57_61", false, "Act 2 Briefing Done");
      settings.Add("61_62", false, "South America - Cove Valley Village - Segment 1");
      settings.Add("s02a10l_s02a20l", false, "South America - Cove Valley Village");
      settings.Add("s02a20l_s02a25l", false, "South America - Power Station - Area 1");
      settings.Add("s02a25l_s02a20l", false, "South America - Met  Drebin");
      settings.Add("s02a20l_s02a30l", false, "South America - Power Station - Area 2");
      settings.Add("s02a30l_s02a40l", false, "South America - Confinement Facility");
      settings.Add("s02a40l_s02a50l", false, "South America - Vista Mansion");
      settings.Add("80_81", false, "Naomi Cutscenes");
      settings.Add("81_82", false, "Frog Encounter Done");
      settings.Add("83_84", false, "Laughing Octopus - Beast Phase Done");
      settings.Add("85_88", false, "Laughing Octopus - Beauty Phase Done");
      settings.Add("s02a60l_s02a70l", false, "South America - Mountain Trail Riverside");
      settings.Add("s02a75l_s02a78l", false, "South America - Drebin Ride 1");
      settings.Add("s02a78l_s02a80l", false, "South America - Drebin Ride 2");
      settings.Add("s02a80l_s02a85l", false, "South America - Drebin Ride 3");
      settings.Add("s02a90l_s02a95l", false, "South America - Marketplace");
      settings.Add("s02a95l_mg_setu", false, "End of Act 2");

    settings.CurrentDefaultParent = "act3";
    settings.Add("act3", true, "Act 3", "splits");
      settings.Add("s03a00l_s03a10l", false, "Act 3 Briefing Done");
      settings.Add("s03a10l_s03a20l", false, "Resistence Member - Area 1");
      settings.Add("s03a20l_s03a25l", false, "Resistence Member - Area 2");
      settings.Add("s03a25l_s03a30l", false, "Resistence Member - Area 3");
      settings.Add("s03a30l_s03a35l", false, "Big Mama Cutscenes");
      settings.Add("s03a35l_s03a40l", false, "Bike Chase - Area 1");
      settings.Add("s03a40l_s03a50l", false, "Bike Chase - Area 2");
      settings.Add("s03a60l_s03a65l", false, "Bike Chase - Area 3");
      settings.Add("138_139", false, "Bike Chase - Cutscenes");
      settings.Add("139_140", false, "Raging Raven - Beast Form Done");
      settings.Add("141_144", false, "Raging Raven - Beauty Form Done");
      settings.Add("s03a90l_mg_setu", false, "End of Act 3");

    settings.CurrentDefaultParent = "act4";
    settings.Add("act4", true, "Act 4", "splits");
      settings.Add("176_177", false, "Act 4 Briefing Done");
      settings.Add("s04a10l_s04a20l", false, "Shadow Moses - Helipad/Tank Hangar/Snowfield 1");
      settings.Add("179_180", false, "Shadow Moses - Reached Hal's Labratory");
      settings.Add("s04a20l_s04a30l", false, "Shadow Moses - Buke Building");
      settings.Add("194_195", false, "Shadow Moses - Reached Crying Wolf");
      settings.Add("195_196", false, "Crying Wolf - Beast Form Done");
      settings.Add("197_200", false, "Crying Wolf - Beauty Form Done");
      settings.Add("s04a30l_s04a40l", false, "Shadow Moses - Snowfield");
      settings.Add("s04a40l_s04a50l", false, "Shadow Moses - Blast Furnace");
      settings.Add("210_211", false, "Shadow Moses - Underground Base");
      settings.Add("211_212", false, "Made Vamp Human Again");
      settings.Add("s04a60l_s04a65l", false, "Survived Gecko Rush");
      settings.Add("s04a65l_s04a68l", false, "Escaoe Shadow Moses");
      settings.Add("s04a70l_s04a75l", false, "Metal Gear Ray Defeated");
      settings.Add("s04a75l_mg_setu", false, "End of Act 4");

    settings.CurrentDefaultParent = "act5";
    settings.Add("act5", true, "Act 5", "splits");
      settings.Add("229_231", false, "Act 5 Briefing Done");
      settings.Add("s05a10l_s05a20l", false, "Outer Haven - Ship Bow");
      settings.Add("232_233", false, "Outer Haven - Command Center");
      settings.Add("233_234", false, "Guard Rush");
      settings.Add("235_236", false, "Screaming Mantis - Beast Form Done");
      settings.Add("237_240", false, "Screaming Mantis - Beauty Form Done");
      settings.Add("244_245", false, "Outer Haven - Missile Hangar Cutscenes");
      settings.Add("246_247", false, "Outer Haven - Hallway 1");
      settings.Add("s05a20l_s05a30l", false, "Outer Haven - Hallway 2");
      settings.Add("s05a30l_s05a40l", false, "Outer Haven - Microwave Hallway");
      settings.Add("258_259", false, "Cutscenes");
      settings.Add("s05a50l_s05a55l", false, "Liquid Ocelot");
      settings.Add("290_291", true, "Final Split (always active)");

    print("Startup complete");
}

init {
    /*
    // find linkVarBuf starting point
    IntPtr linkvarbuf = vars.Helper.ScanRel(3, "48 8B 15 ?? ?? ?? ?? 48 63 82 60 01 00 00 49");

    // based off the linkvarbuf root plus offset, we can make further variables to be used for splitting logic
    vars.Helper["Map"] = vars.Helper.MakeString(0x1C28B28 + 0x34);
    vars.Helper["IGT"] = vars.Helper.Make<uint>(0x1C28B28 + 0x168);
    print("init done");
    */
}

update {
    /*
    vars.Helper.Update();
	vars.Helper.MapPointers();
    print(GameTime.current);
    */
}

gameTime
{
	return TimeSpan.FromMilliseconds(current.GameTime * 1000 / 60);
}

start {
if(current.MapName != "title" && old.MapName == "title") return true;
}

split {
    if (current.scenarioProgress != old.scenarioProgress) {
        print(old.scenarioProgress + "_" + current.scenarioProgress);
        if(settings.ContainsKey(old.scenarioProgress + "_" + current.scenarioProgress)) return true;
    } else if (current.MapName != old.MapName) {
        print(old.MapName + "_" + current.MapName);
    } 

}

reset {
if(current.MapName == "title") return true;
}

onReset
{
    
  return true;
}