_bombRun_fnc = {
    params ["_marker", "_dir"];

    _class = "B_Plane_CAS_01_Cluster_F";
    _type = 3;

    _dummy = "LaserTargetCBase" createVehicle getMarkerPos _marker;
    _dummy enableSimulation false; _dummy hideObject true;
    _dummy setVariable ["vehicle", _class];
    _dummy setVariable ["type", _type];
    _dummy setDir _dir;

    [_dummy, nil, true] call BIS_fnc_moduleCAS;

    [_dummy] spawn {
        sleep 10;
        deleteVehicle (_this select 0);
    };
    
};
