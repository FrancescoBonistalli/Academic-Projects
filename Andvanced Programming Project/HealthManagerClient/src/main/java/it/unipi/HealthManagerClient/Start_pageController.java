/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/javafx/FXMLController.java to edit this template
 */
package it.unipi.HealthManagerClient;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ResourceBundle;
import javafx.concurrent.Task;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;

/**
 * FXML Controller class
 *
 * @author parru
 */
public class Start_pageController implements Initializable {
    
    private boolean statoServerOk = false;
    
    @FXML
    private Button TastoInizia;

    /**
     * Initializes the controller class.
     */
    @Override
    public void initialize(URL url, ResourceBundle rb) {
        // TODO
    }    
    
    private void controlloStatoServer(){
        Task controlloStatoServerTask = new Task<Void>(){
            @Override public Void call(){
                try{
                    URL url = new URL("http://127.0.0.1:8080/HealthManager/stato");
                    HttpURLConnection connessioneHttp = (HttpURLConnection) url.openConnection();
                    connessioneHttp.setRequestMethod("GET");

                    // Effettua la richiesta
                    int responseCode = connessioneHttp.getResponseCode();

                    // Controlla la risposta del server
                    if (responseCode == HttpURLConnection.HTTP_OK) { // 200 OK
                        // Leggi la risposta dal server
                        BufferedReader in = new BufferedReader(new InputStreamReader(connessioneHttp.getInputStream()));
                        String inputLine;
                        StringBuilder response = new StringBuilder();

                        while ((inputLine = in.readLine()) != null) {
                            response.append(inputLine);
                        }
                        in.close();

                        statoServerOk = true;

                        // Mostra il risultato
                        System.out.println("Connessione riuscita. Risposta del server: " + response.toString());

                    } else {
                        System.out.println("Connessione fallita. Codice di risposta: " + responseCode);
                    }

                    //disconnetto la connessione 
                    connessioneHttp.disconnect();
                }
                catch (Exception e){

                }

                return null;
            }
        };
        new Thread(controlloStatoServerTask).start();
    }
    
    private void comandoCaricaDati(){
        Task comandoCaricaDatiTask = new Task<Void>(){
            @Override public Void call(){
                try {
                    URL url = new URL("http://127.0.0.1:8080/HealthManager/caricaDati");
                    HttpURLConnection connessioneHttp = (HttpURLConnection) url.openConnection();
                    connessioneHttp.setRequestMethod("POST");

                    //sfrutto un metodo della classe URLConnection (superclasse di HttpURLConnection)
                    connessioneHttp.setDoOutput(true);

                    // Ottieni la risposta dal server
                    int responseCode = connessioneHttp.getResponseCode();
                    if (responseCode == HttpURLConnection.HTTP_OK) {
                        System.out.println("Richiesta di caricamento dati inviata con successo!");
                    } else {
                        System.out.println("Errore nell'invio della richiesta di caricamento dati. Codice risposta: " + responseCode);
                    }
                } catch (Exception e) {

                }

                return null;
            }
        };
        new Thread(comandoCaricaDatiTask).start();
    }
    
    @FXML
    private void caricaDati() throws IOException, InterruptedException {
        controlloStatoServer();
        Thread.sleep(100);  //devo mettere in pausa per un attimo l'esecuzione per permetter al task di settare la variabile booleana del prossimo if
        if(statoServerOk){
            comandoCaricaDati();
            App.setRoot("login");
        }
        else{
            System.out.println("Richiesta di caricamento dati non inviata al server: ci sono problemi di connessione!!!");
        }
    }
    
}
