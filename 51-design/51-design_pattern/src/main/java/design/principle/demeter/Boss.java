package design.principle.demeter;


/**
 * 3-8 迪米特法则讲解
 */
public class Boss {

    public void commandCheckNumber(TeamLeader teamLeader){
        teamLeader.checkNumberOfCourses();
    }

}
