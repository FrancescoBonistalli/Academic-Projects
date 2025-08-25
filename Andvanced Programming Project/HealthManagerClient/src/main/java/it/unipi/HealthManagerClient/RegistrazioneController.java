/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/javafx/FXMLController.java to edit this template
 */
package it.unipi.HealthManagerClient;

import com.google.gson.Gson;
import com.google.gson.JsonElement;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ResourceBundle;
import javafx.concurrent.Task;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;

import javafx.scene.control.Button;
import javafx.scene.control.Slider;
import javafx.scene.control.TextField;
import javafx.scene.text.Text;
/**
 * FXML Controller class
 *
 * @author parru
 */
public class RegistrazioneController implements Initializable {


    @FXML
    private Text TitoloRegistrazione;
    @FXML
    private TextField CampoNome;
    @FXML
    private TextField CampoCognome;
    @FXML
    private TextField CampoUsername;
    @FXML
    private TextField CampoPassword;
    @FXML
    private Slider SliderAltezza;
    @FXML
    private Slider SliderPeso;
    @FXML
    private Slider SliderEta;
    @FXML
    private Slider SliderCal;
    @FXML
    private Button TastoRegToLogin;
    @FXML
    private Button TastoRegistraUtente;
    @FXML
    private Text TestoUsrNegato;
    @FXML
    private Text TestoMissInput;
    /**
     * Initializes the controller class.
     */
    @Override
    public void initialize(URL url, ResourceBundle rb) {
        // TODO
    }    
    
    @FXML
    private void regToLogin(ActionEvent event) throws IOException {
        App.setRoot("login");
    }

    @FXML
    private void registraUtente(ActionEvent event) {
        if(controlloInput()){
            if(userDisponibile()){
                String usernameNuovo = CampoUsername.getText();
                String nomeNuovo = CampoNome.getText();
                String cognomeNuovo = CampoCognome.getText();
                String passwordNuovo = CampoPassword.getText();
                int etaNuovo = (int) SliderEta.getValue();
                int altezzaNuovo = (int) SliderAltezza.getValue();
                int pesoNuovo = (int) SliderPeso.getValue();
                int calNuovo = (int) SliderCal.getValue();
                
                Task registraUtenteTask = new Task<Void>(){
                    @Override public Void call(){
                        try{
                            URL url = new URL("http://127.0.0.1:8080/HealthManager/nuovoUtente");
                            HttpURLConnection connessioneHttp = (HttpURLConnection) url.openConnection();
                            connessioneHttp.setRequestMethod("POST");

                            connessioneHttp.setRequestProperty("Content-Type", "application/json; utf-8");
                            connessioneHttp.setDoOutput(true); 

                            Utente userNuovo = new Utente(usernameNuovo, nomeNuovo, cognomeNuovo, passwordNuovo, etaNuovo, altezzaNuovo, pesoNuovo, calNuovo);

                            Gson gson = new Gson();
                            try{
                                String jsonUtente = gson.toJson(userNuovo);
                                try (OutputStream os = connessioneHttp.getOutputStream()) {
                                   byte[] input = jsonUtente.getBytes("utf-8");
                                   os.write(input, 0, input.length);
                                }
                                catch(Exception e ){
                                    System.out.println(e);
                                }
                            }
                            catch(Exception e){
                                System.out.println("problema di conversione a jsonUtente");
                                System.out.println(e);
                            }

                            int responseCode = connessioneHttp.getResponseCode();
                            if (responseCode == HttpURLConnection.HTTP_OK) {
                                System.out.println("Connessione post user riuscita.");                
                            }
                            else {
                                System.out.println("Errore nella richiesta post user.");
                            }
                            App.setRoot("login");
                        }
                        catch (Exception e){

                        }

                        return null;
                    }
                };
                new Thread(registraUtenteTask).start();
            }
            else{
                if(TestoUsrNegato.isVisible()){
                    System.out.println("tasto presente");
                }
                else{
                    TestoUsrNegato.setVisible(true);
                }
            }
        }
        else{
            if(TestoMissInput.isVisible()){
                System.out.println("Scritta già presente");;
            }
            else{
                TestoMissInput.setVisible(true);
            }
        }
    }
    
    private boolean controlloInput(){
        boolean inputPresenti = true;
        if(CampoNome.getText() == null || CampoNome.getText().trim().isEmpty()){
           inputPresenti = false;
        }
        if(CampoCognome.getText() == null || CampoCognome.getText().trim().isEmpty()){
           inputPresenti = false;
        }
        if(CampoUsername.getText() == null || CampoUsername.getText().trim().isEmpty()){
           inputPresenti = false;
        }
        if(CampoPassword.getText() == null || CampoPassword.getText().trim().isEmpty()){
           inputPresenti = false;
        }
        return inputPresenti;
    }
    
    private boolean userDisponibile(){
        try{
            URL url = new URL("http://127.0.0.1:8080/HealthManager/utente?usr=" + CampoUsername.getText()); 
            HttpURLConnection connessioneHttp = (HttpURLConnection) url.openConnection();
            connessioneHttp.setRequestMethod("GET");
            int responseCode = connessioneHttp.getResponseCode();
            
            if (responseCode == HttpURLConnection.HTTP_OK) {
                BufferedReader in = new BufferedReader(new InputStreamReader(connessioneHttp.getInputStream()));

                String inputLine;
                StringBuffer content = new StringBuffer();
                
                while ((inputLine = in.readLine()) != null) {
                    content.append(inputLine);
                }
                in.close();
                Gson gson = new Gson(); 
                JsonElement elementoJson = gson.fromJson(content.toString(), JsonElement.class); 
                if(elementoJson == null){
                    System.out.println("username disponibile");
                    return true;
                }
            }
        }
        catch(Exception e){
            System.out.println(e);
        }
        System.out.println("username NON disponibile");
        return false;
    }
}
