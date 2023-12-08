// list of possible MAVLINK commands
// update from https://mavlink.io/en/messages/common.html#mav_commands
mav_link_cmd(16,"MAV_CMD_NAV_WAYPOINT").
mav_link_cmd(20,"MAV_CMD_NAV_RETURN_TO_LAUNCH").
mav_link_cmd(22,"MAV_CMD_NAV_TAKEOFF").

required_energy("MAV_CMD_NAV_WAYPOINT",Args,X) :-
   X = 100.
required_energy("MAV_CMD_NAV_RETURN_TO_LAUNCH",Args,X) :-
   X = 300.
required_energy("MAV_CMD_NAV_TAKEOFF",Args,X) :-
   X = 10.

mission_required_energy([],0).
mission_required_energy([cmd(Cmd,Args)|T],X) :-
   mav_link_cmd(Cmd,CmdName) &
   required_energy(CmdName,Args,CE) &
   mission_required_energy(T,TE) &
   X = CE + TE.


+!exec_mav_link(MissionId,Cmd,Args)
    : mav_link_cmd(Cmd,CmdName)
   <- //.print("executing ", Name, " with ",Args);
      -+current_action(MissionId,CmdName,Args);
      .wait(2000);
      // TODO: implement the real execution of the command
   .

+!check_energy(MissionId,Cmd,Args)
    : mav_link_cmd(Cmd,CmdName) &
      required_energy(CmdName,Args,E) &
      mission_required_energy(MissionId,RE)
   <- //.print("test the use of ",E," for ",CmdName);
      -+mission_required_energy(MissionId,RE-E).


