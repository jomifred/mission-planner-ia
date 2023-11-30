This project illustrate how to load a plan produced by _Mission Planner_.

* the list of all used commands should be updated in file `src/agt/mav_link.asl`, see the  [list of all commands](https://mavlink.io/en/messages/common.html#mav_commands).

* It must be implemented the procedure to properly send the commands to the drone, it can be done in file `src/agt/mav_link.asl`, see plan `exec_mav_link`.

* the agent has a belief `current_action(MissionId,Cmd,Args)` that is updated every time a next step of the mission is executed.

* the agent has a belief `mission_required_energy(Mission,ME)` that is updated every time a next step of the mission is executed. This belief can be used to decide whether to continue to be committed to the mission or not. Agent alice simulates the battery to illustrate that.