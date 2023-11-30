package mp;

import jason.JasonException;
import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.InternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.*;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.HashMap;
import java.util.Map;

public class load_mission_plan extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem transitionSystem, Unifier unifier, Term[] terms) throws Exception {
        try (var in = new BufferedReader(new FileReader( ((StringTerm)terms[1]).getString()))) {
            var plan = new StringBuilder();
            var info = new StringBuilder("["); var v = "";
            var line = in.readLine();
            while (line != null) {
                var fields = line.split("\t");
                line = in.readLine();
                if (fields.length < 4) // ignore line
                    continue;
                var cmdId = Integer.parseInt(fields[3]);

                var args = new ListTermImpl();
                for (int i=4; i< fields.length; i++)
                    args.add( new NumberTermImpl(fields[i]));

                //System.out.println(fields[0]+": "+cmdId+"("+args+")");

                plan.append(" !check_energy("+terms[0]+","+cmdId+", "+args+"); ");
                plan.append(" !exec_mav_link("+terms[0]+","+cmdId+", "+args+"); \n");
                info.append(v+"cmd("+cmdId+", "+args+")"); v = ",";
            }
            plan.append(" .");
            info.append("]");
            plan.insert(0, "+!mission("+terms[0]+") <- ?mission_required_energy("+info+",RE); +mission_required_energy("+terms[0]+",RE); \n");
            //System.out.println("plan = "+plan);

            return unifier.unifies(terms[2],ASSyntax.parsePlan(plan.toString()));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return true;
    }
}
