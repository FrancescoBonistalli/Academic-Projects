/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/javafx/FXMLController.java to edit this template
 */
package it.unipi.HealthManagerClient;

import java.io.IOException;
import java.net.URL;
import java.util.ResourceBundle;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;

import javafx.scene.control.Button;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.VBox;
import javafx.scene.text.Text;
/**
 * FXML Controller class
 *
 * @author parru
 */
public class HomeController implements Initializable {

    @FXML
    private Text TestoStatoSalute;
    @FXML
    private VBox SonnoBox;
    @FXML
    private Button TastoAddSonno;
    @FXML
    private VBox AttivitaBox;
    @FXML
    private Button TastoAddAttivita;
    @FXML
    private VBox PastiBox;
    @FXML
    private Button TastoAddPasto;
    @FXML
    private Button TastoHomeToLogin;
    
    private UtenteAttivo utenteAttivo = new UtenteAttivo();
    /**
     * Initializes the controller class.
     */
    @Override
    public void initialize(URL url, ResourceBundle rb) {
        // TODO
    }    
    
    @FXML
    private void goToNuovoSonno(ActionEvent event) throws IOException {
        App.setRoot("nuovo_sonno");
    }

    @FXML
    private void goToSonnoTab(MouseEvent event) throws IOException {
        App.setRoot("tab_sonno");
    }

    @FXML
    private void goToNuovoAttivita(ActionEvent event) throws IOException {
        App.setRoot("nuovo_attivita");
    }

    @FXML
    private void goToAttivitaTab(MouseEvent event) throws IOException {
        App.setRoot("tab_attivita");
    }

    @FXML
    private void goToNuovoPasto(ActionEvent event) throws IOException {
        App.setRoot("nuovo_pasto");
    }

    @FXML
    private void goToPastiTab(MouseEvent event) throws IOException {
        App.setRoot("tab_pasto");
    }

    @FXML
    private void homeToLogin(ActionEvent event) throws IOException {
        this.utenteAttivo.resetUtenteAttivo();
        App.setRoot("login");
    }

}
