/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/UnitTests/JUnit5TestClass.java to edit this template
 */
package it.unipi.HealthManagerClient;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import javafx.stage.Stage;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 *
 * @author parru
 */
public class AppTest {
    
    public AppTest() {
    }

    @org.junit.jupiter.api.BeforeAll
    public static void setUpClass() throws Exception {
    }

    @org.junit.jupiter.api.AfterAll
    public static void tearDownClass() throws Exception {
    }

    @org.junit.jupiter.api.BeforeEach
    public void setUp() throws Exception {
    }

    @org.junit.jupiter.api.AfterEach
    public void tearDown() throws Exception {
    }
    
    @Test
    public void testConnessioneDB(){
        try{
            Connection co = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/641419", "root", "root");
        }
        catch (SQLException e){
            fail("Test di connessione al database fallito");
        }
    }
    
//    @BeforeAll
//    public static void setUpClass() {
//    }
//    
//    @AfterAll
//    public static void tearDownClass() {
//    }
//    
//    @BeforeEach
//    public void setUp() {
//    }
//    
//    @AfterEach
//    public void tearDown() {
//    }

    /**
     * Test of start method, of class App.
     */
    @org.junit.jupiter.api.Test
    public void testStart() throws Exception {
        System.out.println("start");
        Stage stage = null;
        App instance = new App();
        instance.start(stage);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of setRoot method, of class App.
     */
    @org.junit.jupiter.api.Test
    public void testSetRoot() throws Exception {
        System.out.println("setRoot");
        String fxml = "";
        App.setRoot(fxml);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of main method, of class App.
     */
    @org.junit.jupiter.api.Test
    public void testMain() {
        System.out.println("main");
        String[] args = null;
        App.main(args);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }
    
}
