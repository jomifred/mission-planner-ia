package mp;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.ASSyntax;
import jason.asSyntax.ListTerm;
import jason.asSyntax.Literal;
import jason.asSyntax.Term;

public class create_plan_for_mission extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem transitionSystem, Unifier unifier, Term[] terms) throws Exception {
        var plan = new StringBuilder();
        var info = (ListTerm)terms[1];
        for (var c: info) {
            var cmd = (Literal)c;
            var cmdId = cmd.getTerm(0);
            var args  = cmd.getTerm(1);
            plan.append(" !check_energy("+terms[0]+","+cmdId+", "+args+"); ");
            plan.append(" !exec_mav_link("+terms[0]+","+cmdId+", "+args+"); \n");
        }
        plan.append(" .");
        plan.insert(0, "+!mission("+terms[0]+") <- ?mission_required_energy("+info+",RE); +mission_required_energy("+terms[0]+",RE); \n");
        //System.out.println("plan = "+plan);

        return unifier.unifies(terms[2],ASSyntax.parsePlan(plan.toString()));
    }
}
