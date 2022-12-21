state("The Lightbringer")
{
    bool isLoading : "UnityPlayer.dll", 0x01A05330, 0x170;
    //float finalbossHP : "UnityPlayer.dll", 0x01948480, 0x88, 0x108, 0x1A8, 0x0, 0x168, 0x2C;
    float finalbossHP : "mono-2.0-bdwgc.dll", 0x00497E28, 0x20, 0xFA0, 0x20, 0x2C;
}

init
{
    vars.oldActualScene = "";
}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.LoadSceneManager = true;

    // Settings
    settings.Add("main_menu_reset", true, "Reset on Main Menu");
    settings.Add("exit_game_reset", true, "Reset on Game Exit/Crash");
}

update
{
    current.SceneName = vars.Helper.Scenes.Active.Name;

    if (current.SceneName == null && old.SceneName != null) {
        vars.oldActualScene = old.SceneName;
    }
}

start
{
    return current.SceneName == null && old.SceneName == "MainMenu_";
}

split
{
    if (current.SceneName != old.SceneName && 
        current.SceneName != "MainMenu_" && 
        current.SceneName != null && 
        current.SceneName != vars.oldActualScene && 
        vars.oldActualScene != "" && 
        vars.oldActualScene != "MainMenu_") {
        return true;
    }

    if (current.finalbossHP <= 0 && old.finalbossHP > 0 && current.finalbossHP != null) {
        return true;
    }
}

isLoading 
{
    return current.isLoading;
}

reset
{
    if (current.SceneName == "MainMenu_") {
        return settings["main_menu_reset"];
    }
}

exit
{
    if (settings["exit_game_reset"]) {
        vars.Helper.Timer.Reset();
    }
}