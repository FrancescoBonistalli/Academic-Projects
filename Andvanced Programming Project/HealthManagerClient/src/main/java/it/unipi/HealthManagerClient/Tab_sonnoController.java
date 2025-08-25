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
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.ResourceBundle;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.concurrent.Task;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;

/**
 * FXML Controller class
 *
 * @author parru
 */
public class Tab_sonnoController implements Initializable {
    private UtenteAttivo utenteAttivo = new UtenteAttivo();
    
    @FXML 
    private TableView<Sonno> TabellaSonno;
    private ObservableList<Sonno> ol;
    @FXML
    private Button TastoTabSonnoToHome;

    /**
     * Initializes the controller class.
     */
    @Override
    public void initialize(URL url, ResourceBundle rb) {
        // TODO
         
        TableColumn idCol = new TableColumn("ID");
        idCol.setCellValueFactory(new PropertyValueFactory<>("id_sonno"));

        TableColumn dataCol = new TableColumn("Data");
        dataCol.setCellValueFactory(new PropertyValueFactory<>("data"));

        TableColumn durataCol = new TableColumn("durata (h)");
        durataCol.setCellValueFactory(new PropertyValueFactory<>("durata"));

        TableColumn qualitaCol = new TableColumn("Qualità");
        qualitaCol.setCellValueFactory(new PropertyValueFactory<>("qualita"));

        TabellaSonno.getColumns().addAll(idCol, dataCol, durataCol, qualitaCol);

        ol = FXCollections.observableArrayList(recuperaArraySonno());

        TabellaSonno.setItems(ol);
    }    
    
    public Sonno[] recuperaArraySonno(){
        Sonno[] sonnoArrayFun = null;
        try{
            URL url = new URL("http://127.0.0.1:8080/HealthManager/sonno?usr="+ this.utenteAttivo.getUtenteAttivo());

            HttpURLConnection connessioneHttp = (HttpURLConnection) url.openConnection();
            connessioneHttp.setRequestMethod("GET");

            int responseCode = connessioneHttp.getResponseCode();

            if (responseCode == HttpURLConnection.HTTP_OK) {
                System.out.println("Connessione http riuscita per sonno");
                BufferedReader in = new BufferedReader(new InputStreamReader(connessioneHttp.getInputStream()));

                String inputLine;
                StringBuffer content = new StringBuffer();

                while ((inputLine = in.readLine()) != null) {
                    content.append(inputLine);
                }
                in.close();
                
                Gson gson = new Gson(); 
                JsonElement elementoJson = gson.fromJson(content.toString(), JsonElement.class);
                JsonArray sonnoArrayJson = elementoJson.getAsJsonArray();
                sonnoArrayFun = new Sonno[sonnoArrayJson.size()];
                for(int i = 0; i < sonnoArrayJson.size(); i++){
                    JsonObject o = sonnoArrayJson.get(i).getAsJsonObject();
                    sonnoArrayFun[i] = getSonnoDaJson(o);
                }
                
                return sonnoArrayFun;
            }
            else {
                System.out.println("errore di connessione http");
            }
            
        }
        catch (Exception e){
            System.out.println("eccezione "+e+" catturata");
        }
        if(sonnoArrayFun != null)
            return sonnoArrayFun;
        else {
            System.out.println("Ritorno di array nullo");
            return null;
        }
    }
    
    private Sonno getSonnoDaJson(JsonObject o) throws ParseException{
        Sonno s = new Sonno();
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date data = dateFormat.parse(o.get("data").getAsString());
        
        s.setId_sonno(Integer.valueOf(o.get("id_sonno").getAsString()));
        s.setData(data);
        s.setDurata(Integer.valueOf(o.get("durata").getAsString()));
        s.setQualita(Integer.valueOf(o.get("qualita").getAsString()));
        s.setUsername(o.get("username").getAsString());
        
        return s;
    }
    
        @FXML
    public void removeSonno(){
        Task removeSonnoTask = new Task<Void>(){
            @Override public Void call(){ 
                try(Connection co = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/641419", "root", "root");
                        PreparedStatement ps = co.prepareStatement("DELETE FROM sonno WHERE id_sonno = ?");){
                    ps.setInt(1, TabellaSonno.getSelectionModel().getSelectedItem().getId_sonno());
                    ps.executeUpdate();
                    ol.remove(TabellaSonno.getSelectionModel().getSelectedItem());
                }
                catch (SQLException e){

                }
                return null;
            }
        };
        new Thread(removeSonnoTask).start();
    }
    
    @FXML
    private void tabSonnoToHome(ActionEvent event) throws IOException {
        App.setRoot("home");
    }
}
