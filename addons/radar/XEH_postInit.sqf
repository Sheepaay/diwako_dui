#include "script_component.hpp"
if (is3DEN || !hasInterface) exitWith {};

diwako_dui_uiPixels = DUI_128PX;

diwako_dui_a3UiScale = linearConversion [0.55,0.7,getResolution # 5,1,0.85,false];
diwako_dui_windowHeightMod = linearConversion [1080,1440,getResolution # 1,1,0.75,false];
diwako_dui_bearing_size_calc = diwako_dui_dir_size * diwako_dui_a3UiScale * diwako_dui_hudScaling * diwako_dui_windowHeightMod;
diwako_dui_vehicleNamespace = [] call CBA_fnc_createNamespace;

if !(isNil "ace_nightvision") then {
   "ace_nightvision_display" cutFadeOut 0;
};

"diwako_dui_compass" cutFadeOut 0;
"diwako_dui_namebox" cutFadeOut 0;

// start the loop
[] call FUNC(cacheLoop);

private _labelAdd = localize "STR_dui_buddy_action";
private _labelRemove = localize "STR_dui_buddy_action_remove";
private _range = 10;
if (isNil "ace_interact_menu_fnc_createAction") then {
    [[_labelAdd, {
        [player, cursorObject] call FUNC(pairBuddies);
    }, [], -5000, false, true, "", format ["cursorObject distance2d player <= %1 && {cursorObject in (units group player) && {(player getVariable [""diwako_dui_buddy"", objNull]) != cursorObject}}", _range]]] call CBA_fnc_addPlayerAction;

    [[_labelRemove, {
        [player, cursorObject, false] call FUNC(pairBuddies);
    }, [], -5000, false, true, "", format ["cursorObject distance2d player <= %1 && {cursorObject in (units group player) && {(player getVariable [""diwako_dui_buddy"", objNull]) == cursorObject}}", _range]]] call CBA_fnc_addPlayerAction;
} else {
    private _action = ["diwako_dui_buddy_action", _labelAdd, "", {
        [ace_player, _target] call FUNC(pairBuddies);
    },{_target in (units group ace_player) && {(ace_player getVariable ["diwako_dui_buddy", objNull]) != _target}},{},[], [0,0,0], _range] call ace_interact_menu_fnc_createAction;

    ["CAManBase", 0, ["ACE_MainActions"], _action, true] call ace_interact_menu_fnc_addActionToClass;

    private _action = ["diwako_dui_buddy_action", _labelRemove, "", {
        [ace_player, _target, false] call FUNC(pairBuddies);
    },{_target in (units group ace_player) && {(ace_player getVariable ["diwako_dui_buddy", objNull]) == _target}},{},[], [0,0,0], _range] call ace_interact_menu_fnc_createAction;

    ["CAManBase", 0, ["ACE_MainActions"], _action, true] call ace_interact_menu_fnc_addActionToClass;
};

// player remote controls another unit or changes avatar
// mainly used for the change in avatar / switch unit part as displays will be closed
["unit", {
    params ["_newPlayerUnit", "_oldPlayerUnit"];
    diwako_dui_setCompass = true;
    diwako_dui_setNamelist = true;
    for "_i" from 0 to (count diwako_dui_namebox_lists) do {
        ctrlDelete ctrlParentControlsGroup (diwako_dui_namebox_lists deleteAt 0);
    };
}, true] call CBA_fnc_addPlayerEventHandler;

["diwako_dui_hudToggled", {
    params ["_toggledOff"];
    if (_toggledOff) then {
        // set position and size for namelist and compassa gain
        diwako_dui_setCompass = true;
        diwako_dui_setNamelist = true;
        for "_i" from 0 to (count diwako_dui_namebox_lists) do {
            ctrlDelete ctrlParentControlsGroup (diwako_dui_namebox_lists deleteAt 0);
        };
    };
}] call CBA_fnc_addEventHandler;
