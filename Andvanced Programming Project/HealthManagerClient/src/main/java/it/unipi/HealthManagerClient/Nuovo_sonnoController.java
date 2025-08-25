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
import javafx.scene.layout.AnchorPane;
import javafx.scene.text.Text;
/**
 * FXML Controller class
 *
 * @author parru
 */
public class Nuovo_sonnoController implements Initializable {
    private UtenteAttivo utenteAttivo = new UtenteAttivo();

    @FXML
    private AnchorPane NuovoSonnoPane;
    @FXML
    private Text TitoloNuovoSonno;
    @FXML
    private Text TestoErrSonno;
    @FXML
    private DatePicker DataNuovoSonno;
    @FXML
    private Slider SliderDurataNuovoSonno;
    @FXML
    private Slider SliderQualitaNuovoSonno;
    @FXML
    private Button TastoNuovoSonno;
    @FXML
    private Button TastoNuovoSonnoIndietro;
    /**
     * Initializes the controller class.
     */
    @Override
    public void initialize(URL url, ResourceBundle rb) {
        // TODO
    }    
    
    @FXML
    private void insNuovoSonno(ActionEvent event) throws IOException {
        if(controlloInput()){
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date dataNuovo1 = Date.from(DataNuovoSonno.getValue().atStartOfDay(ZoneId.systemDefault()).toInstant()); //trovato su stackOverflow
            int durataNuovo = (int) SliderDurataNuovoSonno.getValue();
            int qualitaNuovo = (int) SliderQualitaNuovoSonno.getValue();
            String userNuovo = utenteAttivo.getUtenteAttivo();
            
            String dataNuovo = dateFormat.format(dataNuovo1);
            
            Task insNuovoSonnoTask = new Task<Void>(){
                @Override public Void call(){
                    try{
                        URL url = new URL("http://127.0.0.1:8080/HealthManager/nuovoSonno");
                            HttpURLConnection connessioneHttp = (HttpURLConnection) url.openConnection();
                            connessioneHttp.setRequestMethod("POST");

                            connessioneHttp.setRequestProperty("Content-Type", "application/json; utf-8");
                            connessioneHttp.setDoOutput(true);

                            Sonno sonnoNuovo = new Sonno();                  

                            String jsonSonno = "{"
                                    + "\"data\":\"" + dataNuovo + "\","
                                    + "\"durata\":" + durataNuovo + ","
                                    + "\"qualita\":" + qualitaNuovo + ","
                                    + "\"username\":\"" + userNuovo + "\"}"; 

                            try (OutputStream os = connessioneHttp.getOutputStream()){
                                byte[] input = jsonSonno.getBytes("utf-8");
                                os.write(input, 0, input.length);
                            }
                            catch (Exception e){
                                System.out.println(e);
                            }

                            int responseCode = connessioneHttp.getResponseCode();
                            if (responseCode == HttpURLConnection.HTTP_OK) {
                                System.out.println("Connessione post sonno riuscita.");                
                            }
                            else {
                                System.out.println("Errore nella richiesta post sonno.");
                            }
                            App.setRoot("home");
                    }
                    catch (Exception e){
                        System.out.println(e);
                    }

                    return null;
                }
            };
            new Thread(insNuovoSonnoTask).start();
        }
        else{
            if(!TestoErrSonno.isVisible()){
                TestoErrSonno.setVisible(true);
            }
        }
    }
    
    private boolean controlloInput(){
        boolean inputOk = true;
        if(DataNuovoSonno.getValue() == null){
            inputOk = false;
        }
        return inputOk;
    }

    @FXML
    private void nuovoSonnoToHome(ActionEvent event) throws IOException {
        App.setRoot("home");
    }

}
