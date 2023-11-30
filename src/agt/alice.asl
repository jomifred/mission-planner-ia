{ include("mav_link.asl") }

battery_power(1000). // should be perceived, here it is a beliefs just to illustrate

!start.

+!start
   <- .print("Loading mission...");
      mp.load_mission_plan(1,"plan2.waypoints",Plan); // produce the plan from a mission planner file
      .add_plan(Plan); // add the plan in plan library
      !mission(1); // executes the plan
      .print("** mission accomplished **");
      .stopMAS;
   .

+current_action(Mission,Cmd,Args) <- .print("I am executing ",Cmd," with ", Args).

+mission_required_energy(Mission,ME)
    : battery_power(E) & E >= ME
   <- .print("mission still requires ",ME," of energy, I have ",E," -- OK to continue!").
+mission_required_energy(Mission,ME)
    : battery_power(E) & E < ME
   <- .print("mission being aborted by lack of energy!");
      .drop_intention(mission(Mission)).