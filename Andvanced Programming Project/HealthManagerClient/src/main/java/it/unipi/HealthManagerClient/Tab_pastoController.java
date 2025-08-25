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
public class Tab_pastoController implements Initializable {
    private UtenteAttivo utenteAttivo = new UtenteAttivo();

    @FXML
    private TableView<Pasto> TabellaPasto;
    private ObservableList<Pasto> ol;
    @FXML
    private Button TastoTabPastoToHome;
    /**
     * Initializes the controller class.
     */
    @Override
    public void initialize(URL url, ResourceBundle rb) {
        // TODO
           
        TableColumn idCol = new TableColumn("ID");
        idCol.setCellValueFactory(new PropertyValueFactory<>("id_pasto"));

        TableColumn dataCol = new TableColumn("Data");
        dataCol.setCellValueFactory(new PropertyValueFactory<>("data"));

        TableColumn tipoCol = new TableColumn("Tipo");
        tipoCol.setCellValueFactory(new PropertyValueFactory<>("tipo"));

        TableColumn calCol = new TableColumn("Cal");
        calCol.setCellValueFactory(new PropertyValueFactory<>("calorie_ingerite"));

        TabellaPasto.getColumns().addAll(idCol, dataCol, tipoCol, calCol);

        ol = FXCollections.observableArrayList(recuperaArrayPasto());

        TabellaPasto.setItems(ol);
    }    
    
    public Pasto[] recuperaArrayPasto(){
        Pasto[] pastoArrayFun = null;
        try{
            URL url = new URL("http://127.0.0.1:8080/HealthManager/pasto?usr="+ this.utenteAttivo.getUtenteAttivo());

            HttpURLConnection connessioneHttp = (HttpURLConnection) url.openConnection();
            connessioneHttp.setRequestMethod("GET");

            int responseCode = connessioneHttp.getResponseCode();

            if (responseCode == HttpURLConnection.HTTP_OK) {
                System.out.println("Connessione http riuscita per pasto");
                BufferedReader in = new BufferedReader(new InputStreamReader(connessioneHttp.getInputStream()));

                String inputLine;
                StringBuffer content = new StringBuffer();

                while ((inputLine = in.readLine()) != null) {
                    content.append(inputLine);
                }
                in.close();
                
                Gson gson = new Gson(); 
                JsonElement elementoJson = gson.fromJson(content.toString(), JsonElement.class);
                JsonArray pastoArrayJson = elementoJson.getAsJsonArray();
                pastoArrayFun = new Pasto[pastoArrayJson.size()];
                for(int i = 0; i < pastoArrayJson.size(); i++){
                    JsonObject o = pastoArrayJson.get(i).getAsJsonObject();
                    pastoArrayFun[i] = getPastoDaJson(o);
                }
                return pastoArrayFun;
            }
            else {
                System.out.println("errore di connessione http");
            }
            
        }
        catch (Exception e){
            System.out.println("eccezione "+e+" catturata");
        }
        if(pastoArrayFun != null)
            return pastoArrayFun;
        else {
            System.out.println("Ritorno di array nullo");
            return null;
        }
    }
    
    private Pasto getPastoDaJson(JsonObject o) throws ParseException{
        Pasto p = new Pasto();
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date data = dateFormat.parse(o.get("data").getAsString());
        
        p.setId_pasto(Integer.valueOf(o.get("id_pasto").getAsString()));
        p.setData(data);
        p.setTipo(o.get("tipo").getAsString());
        p.setCalorie_ingerite(Integer.valueOf(o.get("calorie_ingerite").getAsString()));
        p.setUsername(o.get("username").getAsString());
        
        return p;
    }  
    
    @FXML
    public void removePasto(){
        Task removePastoTask = new Task<Void>(){
            @Override public Void call(){
                try(Connection co = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/641419", "root", "root");
                        PreparedStatement ps = co.prepareStatement("DELETE FROM pasto WHERE id_pasto = ?");){
                    ps.setInt(1, TabellaPasto.getSelectionModel().getSelectedItem().getId_pasto());
                    ps.executeUpdate();
                    ol.remove(TabellaPasto.getSelectionModel().getSelectedItem());
                }
                catch(SQLException e){

                }

                return null;
            }
        };
        new Thread(removePastoTask).start();
    }
    
    @FXML
    private void tabPastoToHome(ActionEvent event) throws IOException {
        App.setRoot("home");
    }

}
