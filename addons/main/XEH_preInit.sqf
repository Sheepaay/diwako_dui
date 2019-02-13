ADDON = false;

#include "\a3\ui_f\hpp\defineDIKCodes.inc"
#define CBA_SETTINGS_CAT localize "STR_dui_mod"

diwako_dui_toggled_off = false;
diwako_dui_inFeatureCamera = false;

private _curCat = localize "STR_dui_cat_general";

private _availableFonts = [
    "PuristaBold",
    "PuristaLight",
    "PuristaMedium",
    "PuristaSemibold",
    "RobotoCondensed",
    "RobotoCondensedBold",
    "RobotoCondensedLight",
    "EtelkaMonospacePro",
    // "EtelkaMonospaceProBold",
    // "EtelkaNarrowMediumPro",
    "LCD14"
    // "TahomaB"
];

[
    "diwako_dui_font"
    ,"LIST"
    ,[localize "STR_dui_font", localize "STR_dui_font_desc"]
    ,[CBA_SETTINGS_CAT, _curCat]
    ,[
        _availableFonts,
        _availableFonts,
        4
    ]
    ,false
    ,{
        diwako_dui_setCompass = true;
        for "_i" from 0 to (count diwako_dui_namebox_lists) do {
            ctrlDelete ctrlParentControlsGroup (diwako_dui_namebox_lists deleteAt 0);
        };
    }
] call CBA_Settings_fnc_init;

#include "include\getIconStyles.sqf"
[
    "diwako_dui_icon_style"
    ,"LIST"
    ,[localize "STR_dui_icon", localize "STR_dui_icon_desc"]
    ,[CBA_SETTINGS_CAT, _curCat]
    ,[
        _iconIdent,
        _iconNames,
        0
    ]
    ,false
] call CBA_Settings_fnc_init;

#include "include\getColorStyles.sqf"
[
    "diwako_dui_colors"
    ,"LIST"
    ,[localize "STR_dui_color", localize "STR_dui_color_desc"]
    ,[CBA_SETTINGS_CAT, _curCat]
    ,[
        _colorIdent,
        _colorNames,
        0
    ]
    ,false
] call CBA_Settings_fnc_init;

if (isClass(configfile >> "CfgPatches" >> "ace_interact_menu")) then {
    [
        "diwako_dui_ace_hide_interaction"
        ,"CHECKBOX"
        ,[localize "STR_dui_ace_hide_interaction", localize "STR_dui_ace_hide_interaction_desc"]
        ,[CBA_SETTINGS_CAT, _curCat]
        ,true
        ,false
    ] call CBA_Settings_fnc_init;
} else {
    diwako_dui_ace_hide_interaction = false;
};

// keybind to toggle whole UI
[CBA_SETTINGS_CAT, "diwako_dui_button_toggle_ui", localize "STR_dui_key_toggle", {
    diwako_dui_toggled_off = !diwako_dui_toggled_off;
    ["diwako_dui_hudToggled", [diwako_dui_toggled_off]] call CBA_fnc_localEvent;
    true
},
{false},
[DIK_MULTIPLY, [false, true, false]], false] call CBA_fnc_addKeybind;

ADDON = true;
