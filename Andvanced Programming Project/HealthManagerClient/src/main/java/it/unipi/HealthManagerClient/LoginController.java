/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/javafx/FXMLController.java to edit this template
 */
package it.unipi.HealthManagerClient;

import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import javafx.concurrent.Task;
import javafx.fxml.FXML;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.scene.layout.VBox;
import javafx.scene.text.Text;

/**
 * FXML Controller class
 *
 * @author parru
 */
public class LoginController {
   @FXML
   private TextField usr; 
   @FXML
   private PasswordField pwd; 
   @FXML
   private Text TitoloLogin;
   @FXML
   private Text TestoLoginNegato;
   @FXML
   private Text TestoLoginPwNegato;
   @FXML
   private VBox vboxLogin;
   
   private boolean loginOk = false;
   
   private UtenteAttivo utenteAttivo = new UtenteAttivo();

   @FXML
   private void doLogin() throws IOException, InterruptedException {
       String username = usr.getText();
       String password = pwd.getText();
       
       credenzialiValide(username, password);
       Thread.sleep(100);
       if(loginOk){
           utenteAttivo.setUtenteAttivo(username);
           App.setRoot("home");
       }

   }
   
   private void credenzialiValide(String usr, String pwd){
       Task credenzialiValideTask = new Task<Void>(){
            @Override public Void call(){
                try{
                    URL url = new URL("http://127.0.0.1:8080/HealthManager/utente?usr=" + usr);
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

                        //aggiungo l'avviso di utente non registrato nel caso la risposta del server sia una stringa vuota
                        if(content.length() == 0){
                            TestoLoginNegato.setVisible(true);
                        }
                        else{
                            Gson gson = new Gson(); 
                            JsonElement elementoJson = gson.fromJson(content.toString(), JsonElement.class); 
                            JsonObject utenteObject = elementoJson.getAsJsonObject();

                            //recupero la password per confrontarla con quella passata in input
                            String passwordDB = utenteObject.get("password").getAsString();

                            if(pwd.equals(passwordDB)){
                                loginOk = true;
                            }
                            //altrimenti avviso per password errata
                            else {
                                TestoLoginPwNegato.setVisible(true);
                            }   
                        }
                    }
                }
                catch (Exception e){

                }

                return null;
            }
        };
        new Thread(credenzialiValideTask).start();
   }
   
   @FXML
   private void switchToReg() throws IOException {
       App.setRoot("registrazione");
   }
}
