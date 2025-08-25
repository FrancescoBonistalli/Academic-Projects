/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/javafx/FXMLController.java to edit this template
 */
package it.unipi.HealthManagerClient;

import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.time.ZoneId;
import java.util.Date;
import java.util.ResourceBundle;
import javafx.concurrent.Task;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;

import javafx.scene.control.Button;
import javafx.scene.control.DatePicker;
import javafx.scene.control.Slider;
import javafx.scene.control.TextField;
import javafx.scene.text.Text;
/**
 * FXML Controller class
 *
 * @author parru
 */
public class Nuovo_attivitaController implements Initializable {
    private UtenteAttivo utenteAttivo = new UtenteAttivo();

    @FXML
    private Text TitoloNuovoAttivita;
    @FXML
    private DatePicker DataNuovoAttivita;
    @FXML
    private Slider SliderDurataNuovaAttivita;
    @FXML
    private Slider SliderSforzoNuovaAttivita;
    @FXML
    private Button TastoNuovoAttivita;
    @FXML
    private Slider SliderCalNuovaAttivita;
    @FXML
    private TextField TestoSportNuovoAttivita;
    @FXML
    private Button TastoNuovoAttivitaIndietro;
    @FXML
    private Text TestoErrAttivita;
    /**
     * Initializes the controller class.
     */
    @Override
    public void initialize(URL url, ResourceBundle rb) {
        // TODO
    }    
    
    @FXML
    private void insNuovoAttivita(ActionEvent event) {
        
        if(controlloInput()){
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date dataNuovo1 = Date.from(DataNuovoAttivita.getValue().atStartOfDay(ZoneId.systemDefault()).toInstant()); //trovato su stackOverflow
            int durataNuovo = (int) SliderDurataNuovaAttivita.getValue();
            int sforzoNuovo = (int) SliderSforzoNuovaAttivita.getValue();
            int calNuovo = (int) SliderCalNuovaAttivita.getValue();
            String sportNuovo = TestoSportNuovoAttivita.getText();
            String userNuovo = utenteAttivo.getUtenteAttivo();
            
            String dataNuovo = dateFormat.format(dataNuovo1);
            
            Task insNuovoAttivitaTask = new Task<Void>(){
                @Override public Void call(){
                    try{
                        URL url = new URL("http://127.0.0.1:8080/HealthManager/nuovoAttivita");
                            HttpURLConnection connessioneHttp = (HttpURLConnection) url.openConnection();
                            connessioneHttp.setRequestMethod("POST");

                            connessioneHttp.setRequestProperty("Content-Type", "application/json; utf-8");
                            connessioneHttp.setDoOutput(true); 

                            String jsonAttivita = "{"
                                    + "\"data\":\"" + dataNuovo + "\","
                                    + "\"durata\":" + durataNuovo + ","
                                    + "\"sforzo\":" + sforzoNuovo + ","
                                    + "\"calorie_bruciate\":" + calNuovo + ","
                                    + "\"sport\":\"" + sportNuovo + "\"," 
                                    + "\"username\":\"" + userNuovo + "\"}";

                            try (OutputStream os = connessioneHttp.getOutputStream()){
                                byte[] input = jsonAttivita.getBytes("utf-8");
                                os.write(input, 0, input.length);
                            }
                            catch (Exception e){
                                System.out.println(e);
                            }

                            int responseCode = connessioneHttp.getResponseCode();
                            if (responseCode == HttpURLConnection.HTTP_OK) {
                                System.out.println("Connessione post attivita riuscita.");                
                            }
                            else {
                                System.out.println("Errore nella richiesta post attivita.");
                            }
                            App.setRoot("home");
                    }
                    catch (Exception e){
                        System.out.println(e);
                    }

                    return null;
                }
            };
            new Thread(insNuovoAttivitaTask).start();
        }
        else{
            if(!TestoErrAttivita.isVisible()){
                TestoErrAttivita.setVisible(true);
            }
        }
    }
    
    private boolean controlloInput(){
        boolean inputOk = true;
        if(DataNuovoAttivita.getValue() == null){
            inputOk = false;
        }
        if(TestoSportNuovoAttivita.getText() == null || TestoSportNuovoAttivita.getText().trim().isEmpty()){
            inputOk = false;
        }
        return inputOk;
    }

    @FXML
    private void nuovaAttivitaToHome(ActionEvent event) throws IOException {
        App.setRoot("home");
    }

}
