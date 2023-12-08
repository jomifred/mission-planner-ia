{ include("mav_link.asl") }

battery_power(1000). // should be perceived, here it is a beliefs just to illustrate

!mission(0).         // initial default mission
+!mission(0) <- .print("wandering...."); .wait(1000); !mission(0).

+!new_mission(Id,Mission)
   <-  .drop_intention( mission(Old) );               // drop my current mission
       .print("Dropped mission ",Old);
       mp.create_plan_for_mission(Id,Mission,Plan);   // the jason plan for the mission
      .print("Mission as Jason plan: ",Plan);
      .add_plan(Plan); // add the plan in plan library
      !mission(Id); // executes the plan
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