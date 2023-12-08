// agent that simulates the "base"

{ include("mav_link.asl") }

!start.

+!start
   <- .wait(3000);
      .print("Loading mission...");
      mp.load_mission_plan(1,"plan2.waypoints",M); // produce a list of mission steps
      .print("Mission as data: ", M);
      .send(alice, achieve, new_mission(1,M));     // ask alice to change her mission
   .

