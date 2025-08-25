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
public class Nuovo_pastoController implements Initializable {
    private UtenteAttivo utenteAttivo = new UtenteAttivo();

    @FXML
    private Text TitoloNuovoPasto;
    @FXML
    private DatePicker DataNuovoPasto;
    @FXML
    private Button TastoNuovoPasto;
    @FXML
    private Slider SliderCalNuovoPasto;
    @FXML
    private TextField TestoTipoNuovoPasto;
    @FXML
    private Button TastoNuovoPastoIndietro;
    @FXML
    private Text TestoErrPasto;
    /**
     * Initializes the controller class.
     */
    @Override
    public void initialize(URL url, ResourceBundle rb) {
        // TODO
    }    
    
    @FXML
    private void insNuovoPasto(ActionEvent event) {
        if(controlloInput()){
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date dataNuovo1 = Date.from(DataNuovoPasto.getValue().atStartOfDay(ZoneId.systemDefault()).toInstant()); //trovato su stackOverflow
            String tipoNuovo = TestoTipoNuovoPasto.getText();
            int calNuovo = (int) SliderCalNuovoPasto.getValue();
            String userNuovo = utenteAttivo.getUtenteAttivo();
            
            String dataNuovo = dateFormat.format(dataNuovo1);
            Task insNuovoPastoTask = new Task<Void>(){
                @Override public Void call(){
                    try{
                        URL url = new URL("http://127.0.0.1:8080/HealthManager/nuovoPasto");
                            HttpURLConnection connessioneHttp = (HttpURLConnection) url.openConnection();
                            connessioneHttp.setRequestMethod("POST");

                            connessioneHttp.setRequestProperty("Content-Type", "application/json; utf-8");
                            connessioneHttp.setDoOutput(true); 

                            String jsonPasto = "{"
                                    + "\"data\":\"" + dataNuovo + "\","
                                    + "\"tipo\":\"" + tipoNuovo + "\","
                                    + "\"calorie_ingerite\":" + calNuovo + ","
                                    + "\"username\":\"" + userNuovo + "\"}";

                            try (OutputStream os = connessioneHttp.getOutputStream()){
                                byte[] input = jsonPasto.getBytes("utf-8");
                                os.write(input, 0, input.length);
                            }
                            catch (Exception e){
                                System.out.println(e);
                            }

                            int responseCode = connessioneHttp.getResponseCode();
                            if (responseCode == HttpURLConnection.HTTP_OK) {
                                System.out.println("Connessione post pasto riuscita.");                
                            }
                            else {
                                System.out.println("Errore nella richiesta post pasto.");
                            }
                            App.setRoot("home");
                    }
                    catch (Exception e){
                        System.out.println(e);
                    }

                    return null;
                }
            };
            new Thread(insNuovoPastoTask).start();
        }
        else{
            if(!TestoErrPasto.isVisible()){
                TestoErrPasto.setVisible(true);
            }
        }
    }
    
    private boolean controlloInput(){
        boolean inputOk = true;
        if(DataNuovoPasto.getValue() == null){
            inputOk = false;
        }
        if(TestoTipoNuovoPasto.getText() == null || TestoTipoNuovoPasto.getText().trim().isEmpty()){
            inputOk = false;
        }
        return inputOk;
    }

    @FXML
    private void nuovoPastoToHome(ActionEvent event) throws IOException {
        App.setRoot("home");
    }

}
