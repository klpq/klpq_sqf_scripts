
rallySystem = {
       
        // klpq_respawn_ticketsPool = 2;      

        // klpq_respawn_rallyTimeout = 300;

        getGrpStr = {               
                _grp = groupId (group player);
                _grp = [_grp, "BLUFOR ", ""] call CBA_fnc_replace;
                _grp = [_grp, "OPFOR ", ""] call CBA_fnc_replace;
                _grp = [_grp, "GUER ", ""] call CBA_fnc_replace;
                _grp;
        };
        createRallyTimeout = {
                params ["_varSuffix"];
                missionNamespace setVariable ["rallyTimeout_"+_varSuffix, CBA_missionTime];                
        };
        klpq_fnc_revivePlayers_rallyPoint = {
                params [["_pos", []]];

                private _revivePlayers = allPlayers select {name _x in murshun_respawnArray && group _x == group player};

                {
                        if (count _pos == 0) then {
                        private _markerName = [_x] call klpq_spectator_fnc_getMarkerName;

                        [[_markerName], "klpq_spectator_fnc_reviveAtMarker", _x] call BIS_fnc_MP;
                        } else {
                        [[_pos], "klpq_spectator_fnc_reviveAtPosition", _x] call BIS_fnc_MP;
                        };
                } forEach _revivePlayers;

                {
                        [[_x], "murshun_spectator_removeFromSpectators_fnc", false] call BIS_fnc_MP;
                } forEach murshun_respawnArray;
        };

        klpq_rally_getRespawnTickets = {
                missionNamespace getVariable "klpq_tickets_"+(call getGrpStr);
        };
        klpq_rally_setRespawnTickets = {
                missionNamespace setVariable ["klpq_tickets_"+(call getGrpStr), klpq_respawn_ticketsPool];
                publicVariable ("klpq_tickets_"+(call getGrpStr));
        };       
        klpq_rally_reduceRespawnTickets = {      
               
                _reducedTickets = (call klpq_rally_getRespawnTickets) - 1;
                missionNamespace setVariable [
                        (call getGrpStr)+"_Tickets", 
                        if(_reducedTickets <0 )then [{0}, { _reducedTickets }]
                        ];

                publicVariable ("klpq_tickets_"+(call getGrpStr));
                
        };




        klpq_rally_reduceRespawnTickets = {      
               
                _reducedTickets = (call klpq_rally_getRespawnTickets) - 1;
                missionNamespace setVariable [
                        "klpq_tickets_"+(call getGrpStr), 
                        if(_reducedTickets <0 )then [{0}, { _reducedTickets }]
                        ];

                publicVariable ("klpq_tickets_"+(call getGrpStr));
                
        };


        klpq_rally_changeRespawnTickets = {
                params [["_num",0]];
                _newNum = 2;
                _newNum = _newNum - (_num * -1);
                {                
                        if(([_x, "klpq_tickets_"] call CBA_fnc_find) >= 0)then{
                                _currentVal = missionNamespace getVariable _x;
                                _newNum = _currentVal - (_num * -1);
                                missionNamespace setVariable [_x, _newNum];
                                publicVariable _x;                                                             
                        };
                }forEach allVariables missionnamespace;
                systemChat format["Respawn tickets changed for all groups by: %1", _num];  
        };





        //ACE MENU                     
        _action = ["klpq_support", "Support Menu", "", {}, {(leader group player == player)&& !((name player) in murshun_respawnArray)}] call ace_interact_menu_fnc_createAction; 
        [player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;
            
            
            
            if (leader group player == leader player) then [{
                //respawn handler
                private _tickets = call klpq_rally_getRespawnTickets;
                if (isNil "_tickets") then
                {
                      call klpq_rally_setRespawnTickets;
                        
                };
                _modifierFunc = {
                        //sometimes ticket counter is not working
                        params ["_target", "_player", "_params", "_actionData"];
                        _actionData set [1, format["Respawn team mebmers: %1 tickets left",  (call klpq_rally_getRespawnTickets)]];
                };
                _actFnc = {  
                        
                       if((call klpq_rally_getRespawnTickets) <=0)then [{
                               hintSilent "You dont have any respawn tickets left";
                       },{                               
                               call klpq_rally_reduceRespawnTickets;

                               if ( [getMarkerPos [(call getGrpStr+"Marker"), true], "", {_accumulator + (str _x)}] call CBA_fnc_inject == "000") then [{
                                       [] call klpq_fnc_revivePlayers_rallyPoint;
                                       systemChat "player respawned on base";
                               }, {
                                       [getMarkerPos (call getGrpStr+"Marker")] call klpq_fnc_revivePlayers_rallyPoint;
                                       systemChat "player respawned on rally";
                               }];
                       }];  
                };
                //sometimes ticket counter is not working
                _action = ["respawnTeam",format["Respawn team mebmers: %1 tickets left",  (call klpq_rally_getRespawnTickets)], "",_actFnc, {true},{},[],"",0,[false, true, false, false, false],_modifierFunc] call ace_interact_menu_fnc_createAction;                                
                [player, 1, ["ACE_SelfActions", "klpq_support"], _action] call ace_interact_menu_fnc_addActionToObject;



                //rallypoint handler
                _action = ["respawnRally","Place Rallypoint", "",{
                        //systemChat "rally";                      
                        if ([getMarkerPos [(call getGrpStr+"Marker"), true], "", {_accumulator + (str _x)}] call CBA_fnc_inject == "000") then [{
                                        _s = (call getGrpStr+"Marker");
                                        _marker =createMarker [_s, player call CBA_fnc_getPos];
                                        _marker setMarkerType "hd_flag";
                                        
                                        switch (call getGrpStr) do {
                                                case "FT Alpha": {_marker setMarkerColor "ColorRed"};
                                                case "FT Bravo": {_marker setMarkerColor "ColorBlue"};
                                                case "FT Charlie": {_marker setMarkerColor "ColorGreen"};
                                                case "FT Delta": {_marker setMarkerColor "ColorRed"};
                                                case "SL": { _marker setMarkerColor "ColorYellow"};
                                                case "Crew": {_marker setMarkerColor "ColorPink" };
                                                case "Pilots": {_marker setMarkerColor "ColorPink"};
                                                default { hintSilent "cocu" };
                                        };
                                        _marker setMarkerText (call getGrpStr + " rally");
                                        _marker setMarkerAlpha 0.4;
                                        (call getGrpStr) call createRallyTimeout;
                                        }, {                                              
                                              if (CBA_missionTime -  (missionNamespace getVariable "rallyTimeout_"+(call getGrpStr)) > klpq_respawn_rallyTimeout) then [{
                                                      (call getGrpStr+"Marker") setMarkerPos (player call CBA_fnc_getPos);
                                              }, {
                                                        hintSilent format["Rally placement cooldown %1",  [(klpq_respawn_rallyTimeout -(CBA_missionTime -  (missionNamespace getVariable "rallyTimeout_"+(call getGrpStr)))),"M:SS"] call CBA_fnc_formatElapsedTime];                                                                                                          
                                                        
                                              }];
                                              
                                                
                                        }];     
                       
                        }, {!((name player) in murshun_respawnArray)}] call ace_interact_menu_fnc_createAction;                                
                [player, 1, ["ACE_SelfActions", "klpq_support"], _action] call ace_interact_menu_fnc_addActionToObject;

            }, {}];  
};

