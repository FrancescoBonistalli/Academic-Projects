/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/javafx/FXMLController.java to edit this template
 */
package it.unipi.HealthManagerClient;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.ResourceBundle;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javafx.concurrent.Task;



import javafx.scene.control.Button;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
/**
 * FXML Controller class
 *
 * @author parru
 */
public class Tab_attivitaController implements Initializable {


    @FXML
    private TableView<Attivita> TabellaAttivita;
    @FXML
    private Button TastoTabAttivitaToHome;
    
    private ObservableList<Attivita> ol; 
    
    private UtenteAttivo utenteAttivo = new UtenteAttivo();
    /**
     * Initializes the controller class.
     */
    @Override
    public void initialize(URL url, ResourceBundle rb) {
        // TODO
         
        TableColumn idCol = new TableColumn("ID");
        idCol.setCellValueFactory(new PropertyValueFactory<>("id_attivita"));

        TableColumn dataCol = new TableColumn("Data");
        dataCol.setCellValueFactory(new PropertyValueFactory<>("data"));

        TableColumn durataCol = new TableColumn("durata (h)");
        durataCol.setCellValueFactory(new PropertyValueFactory<>("durata"));

        TableColumn sforzoCol = new TableColumn("Sforzo");
        sforzoCol.setCellValueFactory(new PropertyValueFactory<>("sforzo"));

        TableColumn calorieCol = new TableColumn("cal");
        calorieCol.setCellValueFactory(new PropertyValueFactory<>("calorie_bruciate"));

        TableColumn sportCol = new TableColumn("Sport");
        sportCol.setCellValueFactory(new PropertyValueFactory<>("sport"));

        TabellaAttivita.getColumns().addAll(idCol, dataCol, durataCol, sforzoCol, calorieCol, sportCol);

        ol = FXCollections.observableArrayList(recuperaArrayAttivita());

        TabellaAttivita.setItems(ol);
    }    
    
    public Attivita[] recuperaArrayAttivita(){
        Attivita[] attivitaArrayFun = null;
        try{
            URL url = new URL("http://127.0.0.1:8080/HealthManager/attivita?usr="+ this.utenteAttivo.getUtenteAttivo());

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
                JsonArray attivitaArrayJson = elementoJson.getAsJsonArray();
                attivitaArrayFun = new Attivita[attivitaArrayJson.size()];
                for(int i = 0; i < attivitaArrayJson.size(); i++){
                    JsonObject o = attivitaArrayJson.get(i).getAsJsonObject();
                    attivitaArrayFun[i] = getAttivitaDaJson(o);
                }
                
                return attivitaArrayFun;
            }
            else {
                System.out.println("errore di connessione http");
            }
            
        }
        catch (Exception e){
            System.out.println("eccezione "+e+" catturata");
        }
        if(attivitaArrayFun != null)
            return attivitaArrayFun;
        else {
            System.out.println("Ritorno di array nullo");
            return null;
        }
    }
    
    private Attivita getAttivitaDaJson(JsonObject o) throws ParseException{
        Attivita a = new Attivita();
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date data = dateFormat.parse(o.get("data").getAsString());
        
        a.setId_attivita(Integer.valueOf(o.get("id_attivita").getAsString()));
        a.setData(data);
        a.setDurata(Integer.valueOf(o.get("durata").getAsString()));
        a.setSforzo(Integer.valueOf(o.get("sforzo").getAsString()));
        a.setCalorie_bruciate(Integer.valueOf(o.get("calorie_bruciate").getAsString()));
        a.setSport(o.get("sport").getAsString());
        a.setUsername(o.get("username").getAsString());
        
        return a;
    }
        
    @FXML
    public void removeAttivita(){
        Task removeAttivitaTask = new Task<Void>(){
            @Override public Void call(){
                try(Connection co = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/641419", "root", "root");
                        PreparedStatement ps = co.prepareStatement("DELETE FROM attivita WHERE id_attivita = ?");){
                    ps.setInt(1, TabellaAttivita.getSelectionModel().getSelectedItem().getId_attivita());
                    ps.executeUpdate();
                    ol.remove(TabellaAttivita.getSelectionModel().getSelectedItem());
                }
                catch(SQLException e){

                }
            return null;
            }
        };
        new Thread(removeAttivitaTask).start();
    }
    
    @FXML
    private void tabAttivitaToHome(ActionEvent event) throws IOException {
        App.setRoot("home");
    }

}
