/*0 = [this, "o_recon","ColorRed","racoon",0.6] spawn KIB_fnc_kib_markers;


1: _entity - vehicle/unit/object to which you want attach your marker, use `this` for init menu
2: "o_recon" - marker icon  (default "o_unknown")
3: "ColorRed" - marker color (default "ColorGrey")
4: "racoon" - optional marker text, leave empty if you dont need it  ""
5: 0.6 - marker transparency from 0 to 1 (default 0.5)
6: optional param. Here you can attach already existing marker it will override all previously set options.


https://community.bistudio.com/wiki/cfgMarkers //marker types
o_motor_inf
o_mech_inf
o_armor
o_recon
o_air
o_plane
o_med
o_hq

https://community.bistudio.com/wiki/Arma_3_CfgMarkerColors //marker colors
ColorRed	
ColorBrown	
ColorOrange	
ColorYellow	
ColorKhaki
ColorGreen	
ColorBlue
ColorPink

0 = [this, "b_inf","ColorYellow","SL",0.6] spawn KIB_fnc_kib_markers;
*/
params ["_entity",["_markertype","o_unknown"],["_markerColor","ColorGrey"],["_markeText",""],["_markerTransparency",0.5],["_placed",false]];

if (!isServer) exitWith {};


waitUntil {time > 2};
_s = str random 100;
_marker = if (typeName _placed == "STRING") then [{ _placed },{createMarker [_s, [0,0,0]]}];

if (typeName _placed != "STRING") then {
    _marker setMarkerType _markertype;
    _marker setMarkerColor _markerColor;
    _marker setMarkerText _markeText;    
    _marker setMarkerAlpha _markerTransparency;
};


while{not isnull _entity} do {
        _exit = false;
        waitUntil{
            _pos = _entity call CBA_fnc_getPos; 
            if ([_pos, "", {_accumulator + (str _x)}] call CBA_fnc_inject == "000" && typeName _entity == "GROUP") then { 
                if (time < 60) then {
                    _marker setMarkerAlpha 0;
                };
                waitUntil{                    
                    if ([_entity call CBA_fnc_getPos, "", {_accumulator + (str _x)}] call CBA_fnc_inject != "000") exitWith {
                         _marker setMarkerAlpha _markerTransparency;
                         true;
                         };
                    sleep 40;                    
                    false;
                };                            
            };  
            if (typeName _entity == "OBJECT") then {
               if (!alive _entity) exitWith { 
                if (typeName _placed == "STRING")then [{
                        true; 
                    }, {
                        _marker setMarkerColor "ColorBlack";
                        _marker setMarkerAlpha 0.3;
                        sleep 40;                        
                        deletemarker _marker;  
                        _exit = true;
                        true; 
                    }];               
                };
            };                           
            _marker setmarkerpos _pos;          
            if (typeName _entity == "GROUP") then [{sleep klpq_marker_update_rate_inf}, {sleep klpq_marker_update_rate_vehicle}];
            if (_exit) exitWith {_exit};      
            false;
        };      

       

        if (_exit) exitWith {_exit};              
};



