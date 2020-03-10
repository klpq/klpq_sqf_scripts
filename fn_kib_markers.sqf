//0 = [this] spawn KIB_fnc_kib_markers;


//1: _vehicle - техника, если ставите в инит техники, то прописывайте this
//2: "o_recon" - тип маркера (дефолт "o_unknown")
//3: "ColorRed" - цвет маркера (дефолт "ColorGrey")
//4: "racoon" - опциональная подпись маркера, если не нужна то оставляйте пустую строку ""
//5: 0.6 - прозрачность маркера от 0 до 1 (дефолт 0.5)
//6: опциональный параметр. Здесь в кавычках ставите вариаблнейм маркера который уже заранее поставлен в редакторе, все параметры выше будут перезаписаны


//https://community.bistudio.com/wiki/cfgMarkers //marker types
// o_motor_inf
// o_mech_inf
// o_armor
// o_recon
// o_air
// o_plane
// o_med
// o_hq

//https://community.bistudio.com/wiki/Arma_3_CfgMarkerColors //marker colors
// ColorRed	
// ColorBrown	
// ColorOrange	
// ColorYellow	
// ColorKhaki
// ColorGreen	
// ColorBlue
// ColorPink


params ["_vehicle",["_markertype","o_unknown"],["_markerColor","ColorGrey"],["_markeText",""],["_markerTransparency",0.5],["_placed",false]];

if (!isServer) exitWith {};


waitUntil {time > 1};

_s = str random 100;

_marker = if (typeName _placed == "STRING") then [{ _placed },{createMarker [_s, [0,0,0]]}];

if (typeName _placed != "STRING") then {
    _marker setMarkerType _markertype;
    _marker setMarkerColor _markerColor;
    _marker setMarkerText _markeText;
    _marker setMarkerAlpha _markerTransparency;
};

while{not isnull _vehicle} do {
        waitUntil{
            if (!alive _vehicle) exitWith { 
                if (typeName _placed == "STRING")then [{
                     true; 
                }, {
                _marker setMarkerColor "ColorBlack";
                _marker setMarkerAlpha 0.3;
                sleep 30;
                deletemarker _marker;  
                true; 
                }];               
            };            
            _marker setmarkerpos getpos _vehicle;
            sleep 1;            
            false;
        };                   
};
