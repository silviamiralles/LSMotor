package Controller;

import Model.ModelExample;
import Model.Settings;

import java.sql.*;
import java.util.ArrayList;

public class ControllerExample {

    private Connection remoteConnection;
    private Connection localConnection;

    public boolean startRemoteConnection(){
        try{
            System.out.println("COMPLETED\n");
            Class.forName("com.mysql.cj.jdbc.Driver");
            remoteConnection = DriverManager.getConnection("jdbc:mysql://puigpedros.salleurl.edu/?user=" + Settings.REMOTEUSER + "&password=" + Settings.REMOTEPASSWORD + "&serverTimezone=UTC");
            System.out.println("Conectem a la BBDD local...");
            localConnection = DriverManager.getConnection("jdbc:mysql://localhost/?user=" + Settings.LOCALUSER + "&password=" + Settings.LOCALPASSWORD + "&serverTimezone=UTC");
            System.out.println("COMPLETED\n");
            return true;
        }catch(Exception e){
            e.printStackTrace();
            return false;
        }
    }

    public void loadRemoteInfo(ArrayList<ModelExample> modelsExamples) throws SQLException {
        ResultSet rs;
        Statement stmt;

        System.out.println("Reading remote info");

        stmt = remoteConnection.createStatement();
        stmt.executeQuery("USE F1 ");

        stmt = remoteConnection.createStatement();
        rs = stmt.executeQuery("SELECT * FROM status");
        ModelExample modelExample;
        while (rs.next()) {
            modelExample = new ModelExample();
            modelExample.setId_movie(rs.getInt("statusId"));
            modelExample.setTitle(rs.getString("status"));

            /*modelExample.setId_director(rs.getInt("id_director"));
            modelExample.setYear(rs.getInt("year"));
            modelExample.setDuration(rs.getInt("duration"));
            modelExample.setCountry(rs.getString("country"));
            modelExample.setMovie_facebook_likes(rs.getInt("movie_facebook_likes"));
            modelExample.setImdb_score(rs.getDouble("imdb_score"));
            modelExample.setGross(rs.getLong("gross"));
            modelExample.setBudget(rs.getLong("budget"));
            modelsExamples.add(modelExample);*/
        }

        rs.close();
        stmt.close();

        //TODO: Modify for the tables in F1 database
    }


    public void omplirTaules() throws SQLException {
        Statement smtLocal=localConnection.createStatement();
        Statement smtRemote = remoteConnection.createStatement();
        Connection conn = smtLocal.getConnection();
        ResultSet aux2;
        ResultSet rs;
        smtLocal.execute("USE F1");
        System.out.println("INSERTEM INFORMACIO\n");
        aux2=smtRemote.executeQuery("USE F1;");


        aux2=smtRemote.executeQuery("SELECT * FROM races;");
        while (aux2.next()){
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO races(raceId,year,round,circuitId,name,date,time,url)"+" VALUES(?,?,?,?,?,?,?,?);");
            pstmt.setInt(1,aux2.getInt("raceId"));
            pstmt.setInt(2,aux2.getInt("year"));
            pstmt.setInt(3,aux2.getInt("round"));
            pstmt.setInt(4,aux2.getInt("circuitId"));
            pstmt.setString(5,aux2.getString("name"));
            pstmt.setDate(6,aux2.getDate("date"));
            pstmt.setTime(7,aux2.getTime("time"));
            pstmt.setString(8,aux2.getString("url"));
            pstmt.executeUpdate();
            pstmt.close();
        }
        System.out.println("OMPLINT RACES...OK");



        aux2=smtRemote.executeQuery("SELECT * FROM seasons;");
        while (aux2.next()){
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO seasons(year,url)"+" VALUES(?,?);");
            pstmt.setInt(1,aux2.getInt("year"));
            pstmt.setString(2,aux2.getString("url"));
            pstmt.executeUpdate();
            pstmt.close();
        }
        System.out.println("OMPLINT SEASONS...OK");


        aux2=smtRemote.executeQuery("SELECT * FROM circuits;");
        while (aux2.next()){
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO circuits(circuitId,circuitRef,name,location,country,lat,lng,alt,url)"+" VALUES(?,?,?,?,?,?,?,?,?);");
            pstmt.setInt(1,aux2.getInt("circuitId"));
            pstmt.setString(2,aux2.getString("circuitRef"));
            pstmt.setString(3,aux2.getString("name"));
            pstmt.setString(4,aux2.getString("location"));
            pstmt.setString(5,aux2.getString("country"));
            pstmt.setFloat(6,aux2.getFloat("lat"));
            pstmt.setFloat(7,aux2.getFloat("lng"));
            pstmt.setInt(8,aux2.getInt("alt"));

            pstmt.setString(9,aux2.getString("url"));
            pstmt.executeUpdate();
            pstmt.close();
        }
        System.out.println("OMPLINT CIRCUITS...OK");



        aux2=smtRemote.executeQuery("SELECT * FROM results;");
        while (aux2.next()){
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO results(resultId,raceId,driverId,constructorId,number,grid,position,positionText,positionOrder,points,laps,time,milliseconds,fastestLap,rank,fastestLapTime,fastestLapSpeed,statusId)"+" VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);");
            pstmt.setInt(1,aux2.getInt("resultId"));
            pstmt.setInt(2,aux2.getInt("raceId"));
            pstmt.setInt(3,aux2.getInt("driverId"));
            pstmt.setInt(4,aux2.getInt("constructorId"));
            pstmt.setInt(5,aux2.getInt("number"));
            pstmt.setInt(6,aux2.getInt("grid"));
            pstmt.setInt(7,aux2.getInt("position"));
            pstmt.setString(8,aux2.getString("positionText"));
            pstmt.setInt(9,aux2.getInt("positionOrder"));
            pstmt.setFloat(10,aux2.getFloat("points"));
            pstmt.setInt(11,aux2.getInt("laps"));
            pstmt.setString(12,aux2.getString("time"));
            pstmt.setInt(13,aux2.getInt("milliseconds"));
            pstmt.setInt(14,aux2.getInt("fastestLap"));
            pstmt.setInt(15,aux2.getInt("rank"));
            pstmt.setString(16,aux2.getString("fastestLapTime"));
            pstmt.setString(17,aux2.getString("fastestLapSpeed"));
            pstmt.setInt(18,aux2.getInt("statusId"));
            pstmt.executeUpdate();
            pstmt.close();
        }
        System.out.println("OMPLINT RESULTS...OK");


        aux2=smtRemote.executeQuery("SELECT * FROM status;");
        while (aux2.next()){
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO status(StatusId,status)"+" VALUES(?,?);");
            pstmt.setInt(1,aux2.getInt("StatusId"));
            pstmt.setString(2,aux2.getString("status"));
            pstmt.execute();
        }
        System.out.println("OMPLINT STATUS...OK");


        aux2=smtRemote.executeQuery("SELECT * FROM constructors;");
        while (aux2.next()){
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO constructors(constructorId,constructorRef,name, nationality,url)"+" VALUES(?,?,?,?,?);");
            pstmt.setInt(1,aux2.getInt("constructorId"));
            pstmt.setString(2,aux2.getString("constructorRef"));
            pstmt.setString(3,aux2.getString("name"));
            pstmt.setString(4,aux2.getString("nationality"));
            pstmt.setString(5,aux2.getString("url"));
            pstmt.executeUpdate();
            pstmt.close();
        }
        System.out.println("OMPLINT CONSTRUCTORS...OK");

        aux2=smtRemote.executeQuery("SELECT * FROM drivers;");
        while (aux2.next()){
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO drivers(driverId,driverRef,number,code,forename,surname,dob, nationality,url)"+" VALUES(?,?,?,?,?,?,?,?,?);");
            pstmt.setInt(1,aux2.getInt("driverId"));
            pstmt.setString(2,aux2.getString("driverRef"));
            pstmt.setInt(3,aux2.getInt("number"));
            pstmt.setString(4,aux2.getString("code"));
            pstmt.setString(5,aux2.getString("forename"));
            pstmt.setString(6,aux2.getString("surname"));
            pstmt.setDate(7,aux2.getDate("dob"));
            pstmt.setString(8,aux2.getString("nationality"));
            pstmt.setString(9,aux2.getString("url"));
            try {
                pstmt.execute();

            } catch (SQLException ex) {
                System.out.println("Problema al Recuperar les dades --> " + ex.getErrorCode()+" "+ ex.getMessage());
                System.out.println(aux2.getInt("driverId")+ aux2.getString("driverRef")+aux2.getInt("number")+
                        aux2.getString("code")+aux2.getString("forename")+aux2.getString("surname")+aux2.getDate("dob")+
                        aux2.getString("nationality")+ aux2.getString("url"));
            }
        }
        System.out.println("OMPLINT DRIVERS...OK");

        aux2=smtRemote.executeQuery("SELECT * FROM constructorResults;");
        while (aux2.next()){
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO constructorResults(constructorResultsId,raceId,constructorId,points,status)"+" VALUES(?,?,?,?,?);");
            pstmt.setInt(1,aux2.getInt("constructorResultsId"));
            pstmt.setInt(2,aux2.getInt("raceId"));
            pstmt.setInt(3,aux2.getInt("constructorId"));
            pstmt.setFloat(4,aux2.getFloat("points"));
            pstmt.setString(5,aux2.getString("status"));
            pstmt.executeUpdate();
            pstmt.close();
        }
        System.out.println("OMPLINT CONSTRUCTORRESULTS...OK");


        aux2=smtRemote.executeQuery("SELECT * FROM qualifying;");
        while (aux2.next()){
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO qualifying(qualifyId,raceId,driverId,constructorId,number,position,q1,q2,q3)"+" VALUES(?,?,?,?,?,?,?,?,?);");
            pstmt.setInt(1,aux2.getInt("qualifyId"));
            pstmt.setInt(2,aux2.getInt("raceId"));
            pstmt.setInt(3,aux2.getInt("driverId"));
            pstmt.setInt(4,aux2.getInt("constructorId"));
            pstmt.setInt(5,aux2.getInt("number"));
            pstmt.setInt(6,aux2.getInt("position"));
            pstmt.setString(7,aux2.getString("q1"));
            pstmt.setString(8,aux2.getString("q2"));
            pstmt.setString(9,aux2.getString("q3"));
            pstmt.executeUpdate();
            pstmt.close();
        }
        System.out.println("OMPLINT QUALIFYING...OK");

        aux2=smtRemote.executeQuery("SELECT * FROM driverStandings;");
        while (aux2.next()){
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO driverStandings(driverStandingsId,raceId,driverId,points,position,positionText,wins)"+" VALUES(?,?,?,?,?,?,?);");
            pstmt.setInt(1,aux2.getInt("driverStandingsId"));
            pstmt.setInt(2,aux2.getInt("raceId"));
            pstmt.setInt(3,aux2.getInt("driverId"));
            pstmt.setFloat(4,aux2.getFloat("points"));
            pstmt.setInt(5,aux2.getInt("position"));
            pstmt.setString(6,aux2.getString("positionText"));
            pstmt.setInt(7,aux2.getInt("wins"));
            pstmt.executeUpdate();
            pstmt.close();
        }
        System.out.println("OMPLINT DRIVERSTANDINGS...OK");

        aux2=smtRemote.executeQuery("SELECT * FROM constructorStandings;");
        while (aux2.next()){
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO constructorStandings(constructorStandingsId,raceId,constructorId,points,position,positionText,wins)"+" VALUES(?,?,?,?,?,?,?);");
            pstmt.setInt(1,aux2.getInt("constructorStandingsId"));
            pstmt.setInt(2,aux2.getInt("raceId"));
            pstmt.setInt(3,aux2.getInt("constructorId"));
            pstmt.setFloat(4,aux2.getFloat("points"));
            pstmt.setInt(5,aux2.getInt("position"));
            pstmt.setString(6,aux2.getString("positionText"));
            pstmt.setInt(7,aux2.getInt("wins"));
            pstmt.executeUpdate();
            pstmt.close();
        }
        System.out.println("OMPLINT CONSTRUCTORSTANDINGS...OK");




        aux2=smtRemote.executeQuery("SELECT * FROM lapTimes;");
        while (aux2.next()){
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO lapTimes(raceId,driverId,lap,position,time,milliseconds)"+" VALUES(?,?,?,?,?,?);");
            pstmt.setInt(1,aux2.getInt("raceId"));
            pstmt.setInt(2,aux2.getInt("driverId"));
            pstmt.setInt(3,aux2.getInt("lap"));
            pstmt.setInt(4,aux2.getInt("position"));
            pstmt.setString(5,aux2.getString("time"));
            pstmt.setInt(6,aux2.getInt("milliseconds"));
            pstmt.executeUpdate();
            pstmt.close();
        }
        System.out.println("OMPLINT LAPTIMES...OK");

        aux2=smtRemote.executeQuery("SELECT * FROM pitStops;");
        while (aux2.next()){
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO pitStops(raceId,driverId,stop,lap,time,duration,milliseconds)"+" VALUES(?,?,?,?,?,?,?);");
            pstmt.setInt(1,aux2.getInt("raceId"));
            pstmt.setInt(2,aux2.getInt("driverId"));
            pstmt.setInt(3,aux2.getInt("stop"));
            pstmt.setInt(4,aux2.getInt("lap"));
            pstmt.setTime(5,aux2.getTime("time"));
            pstmt.setString(6,aux2.getString("duration"));
            pstmt.setInt(7,aux2.getInt("milliseconds"));
            pstmt.executeUpdate();
            pstmt.close();
        }
        System.out.println("OMPLINT PITSTOPS...OK");



    }
    /*
    public void crearTaulesOLAP() throws SQLException {
        Statement smtLocal = localConnection.createStatement();
        System.out.println("Creem BBDD OLAP local....");
        smtLocal.execute("DROP DATABASE IF EXISTS  F1_OLAP");
        smtLocal.execute("CREATE DATABASE F1_OLAP");
        System.out.println("COMPLETED\n");
        smtLocal.execute("USE F1_OLAP");
        String races = "CREATE TABLE RACES " +
                "(year INTEGER DEFAULT 0, " +
                "StatusId INTEGER not NULL  DEFAULT 0, " +
                "raceId INTEGER not NULL DEFAULT 0, " +
                "circuitId INTEGER not NULL DEFAULT 0, " +
                "url VARCHAR(255), " +
                "circuitRef VARCHAR(255), " +
                "name VARCHAR(255), " +
                "location VARCHAR(255), " +
                "country VARCHAR(255), " +
                "lat FLOAT, " +
                "lng FLOAT, " +
                "alt INTEGER DEFAULT 0, " +
                "round INTEGER not NULL DEFAULT 0, " +
                "date DATE, " +
                "time TIME, " +
                "status VARCHAR(255), " +
                "driverId INTEGER NOT NULL DEFAULT 0, " +
                "qualifyId INTEGER not NULL DEFAULT 0, " +
                "constructorId INTEGER NOT NULL DEFAULT 0, " +
                "driverStandingsId INTEGER not NULL DEFAULT 0, " +
                "resultId INTEGER not NULL DEFAULT 0, " +
                "lap INTEGER NOT NULL DEFAULT 0, " +
                "stop INTEGER NOT NULL DEFAULT 0, " +
                "milliseconds INTEGER DEFAULT 0, " +
                "duration VARCHAR(255), " +
                "number INTEGER DEFAULT 0, " +
                "position INTEGER DEFAULT 0, " +
                "q1 VARCHAR(255), " +
                "q2 VARCHAR(255), " +
                "q3 VARCHAR(255), " +
                "grid INTEGER DEFAULT 0, " +
                "positionText VARCHAR(255), " +
                "positionOrder INT DEFAULT 0, " +
                "points FLOAT, " +
                "laps INTEGER DEFAULT 0, " +
                "fastestlap INTEGER DEFAULT 0, " +
                "rank INTEGER NOT NULL DEFAULT 0, " +
                "fastestLapTime VARCHAR(255), " +
                "fastestLapSpeed VARCHAR(255));";

        smtLocal.executeUpdate(races);
        System.out.println("CREANT TAULES...(RACES)\n");

        smtLocal.execute("DROP TABLE IF EXISTS DRIVERS");
        String drivers = "CREATE TABLE DRIVERS " +
                "(driverId INTEGER not NULL DEFAULT 0, " +
                "qualifyId INTEGER not NULL DEFAULT 0, " +
                "resultId INTEGER not NULL DEFAULT 0, " +
                "statusId INTEGER not NULL DEFAULT 0, " +
                "circuitId INTEGER not NULL DEFAULT 0, " +
                "lap INTEGER not NULL DEFAULT 0, " +
                "stop INTEGER not NULL DEFAULT 0, " +
                "year INTEGER not NULL DEFAULT 0, " +
                "raceId INTEGER NOT NULL DEFAULT 0, " +
                "driverStandingsId INTEGER not NULL DEFAULT 0, " +
                "driverRef VARCHAR(255), " +
                "number INTEGER, " +
                "code VARCHAR(255), " +
                "forename VARCHAR(255), " +
                "surname VARCHAR(255), " +
                "dob DATE , " +
                "nationality VARCHAR(255), " +
                "url VARCHAR(255), " +
                "points FLOAT, " +
                "position INTEGER NOT NULL DEFAULT 0, " +
                "positionText VARCHAR(255), " +
                "wins INTEGER NOT NULL DEFAULT 0, " +
                "PRIMARY KEY (driverStandingsId,driverId));";

        smtLocal.executeUpdate(drivers);
        System.out.println("CREANT TAULES...(DRIVERS)\n");



        String constructors = "CREATE TABLE CONSTRUCTORS" +
                "(constructorId  INTEGER NOT NULL DEFAULT 0, " +
                "driverId INTEGER not NULL DEFAULT 0, " +
                "qualifyId INTEGER not NULL DEFAULT 0, " +
                "resultId INTEGER not NULL DEFAULT 0, " +
                "constructorRef VARCHAR(255), " +
                "constructorResultsId INTEGER not NULL DEFAULT 0, " +
                "constructorStandingsId INTEGER not NULL DEFAULT 0, " +
                "raceId INTEGER NOT NULL DEFAULT 0," +
                "StatusId INTEGER not NULL DEFAULT 0, " +
                "circuitId INTEGER not NULL DEFAULT 0, " +
                "lap INTEGER not NULL DEFAULT 0, " +
                "stop INTEGER not NULL DEFAULT 0, " +
                "year INTEGER not NULL DEFAULT 0, " +
                "name VARCHAR(255), " +
                "nationality VARCHAR(255), " +
                "url VARCHAR(255), " +
                "points FLOAT, " +
                "status VARCHAR(255), " +
                "position INTEGER NOT NULL DEFAULT 0, " +
                "positionText VARCHAR(255), " +
                "wins INTEGER NOT NULL DEFAULT 0, " +
                "PRIMARY KEY (constructorId,constructorResultsId,constructorStandingsId))";


        smtLocal.executeUpdate(constructors);
        System.out.println("CREANT TAULES...(CONSTRUCTORS)\n");
    }*/
/*
    public void omplirTaulesOLAP() throws SQLException {
        Statement smtLocal = localConnection.createStatement();
        Statement smtRemote = remoteConnection.createStatement();
        Connection conn = smtLocal.getConnection();
        ResultSet aux2;
        ResultSet rs;

        System.out.println("INSERTEM INFORMACIO\n");
        smtRemote.execute("USE F1");
        smtLocal.execute("USE F1_OLAP");
        aux2 = smtRemote.executeQuery("SELECT * FROM seasons;");
        while (aux2.next()){
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO RACES(year)"+" VALUES(?);");
            pstmt.setInt(1,aux2.getInt("year"));
            pstmt.execute();
        }
    }*/
}