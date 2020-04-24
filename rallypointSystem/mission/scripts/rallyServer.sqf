


waitUntil {time > 2};

if (!isServer) exitWith {};



["bepis activated!"] remoteExec ["systemchat", -2, true]; 

[rallySystem] remoteExec ["call", -2, true];
 
 
klpq_rally_changeRespawnTickets = {
        params [["_num",0]];
        _newNum = 2;
        _newNum = _newNum - (_num * -1);
        {                
                if(([_x, "klpq_tickets_"] call CBA_fnc_find) >= 0)then{
                        _currentVal = missionNamespace getVariable _x;
                        _newNum = _currentVal - (_num * -1);
                        if (_newNum < 0) then {
                            _newNum = 0;
                        };
                        missionNamespace setVariable [_x, _newNum];
                        publicVariable _x;                                                             
                };
        }forEach allVariables missionnamespace;
        systemChat format["Respawn tickets changed for all groups by: %1", _num];  
};





