/*****************************************************************
 * LAST TIME EDITED: 14/05/2020
 *
 *
 ****************************************************************/

import Controller.ControllerExample;
import Model.ModelExample;

import java.sql.SQLException;
import java.util.ArrayList;

public class Main {
    public static void main(String[] args) {
        ControllerExample mysqlController = new ControllerExample();
        ArrayList<ModelExample> modelExamples = new ArrayList<>();

        System.out.println("Connecting to  remote Database...");
        if (!mysqlController.startRemoteConnection()) System.exit(1);


        try {
            mysqlController.omplirTaules();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
