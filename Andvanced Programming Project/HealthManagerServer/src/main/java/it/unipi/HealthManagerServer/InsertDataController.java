/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package it.unipi.HealthManagerServer;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 *
 * @author parru
 */
@Controller
@RequestMapping(path="/HealthManager")
public class InsertDataController {
    @Autowired
    private UtenteRepository utenteRepository;

    @Autowired
    private AttivitaRepository attivitaRepository;
   
    @Autowired
    private PastoRepository pastoRepository;

    @Autowired
    private SonnoRepository sonnoRepository;
    
    final private String posizioneFiles = "src/main/resources/filePopolamento/"; 
    
    public InsertDataController(){
        
    }
    
    @PostMapping(path = "/nuovoUtente")
    public @ResponseBody String nuovoUtente(@RequestBody Utente u){
        utenteRepository.save(u);
        return "utente inserito";
    }
    
    @PostMapping(path = "/nuovoSonno")
    public @ResponseBody String nuovoSonno(@RequestBody Sonno s){
        sonnoRepository.save(s);
        return "Sonno inserito";
    }
    
    @PostMapping(path = "/nuovoAttivita")
    public @ResponseBody String nuovoAttivita(@RequestBody Attivita a){
        attivitaRepository.save(a);
        return "Attività inserita";
    }
    
    @PostMapping(path = "/nuovoPasto")
    public @ResponseBody String nuovoPasto(@RequestBody Pasto p){
        pastoRepository.save(p);
        return "Pasto inserito";
    }
    
    @PostMapping(path = "/caricaDati")
    public @ResponseBody String caricaDati(){
        List<Utente> listaUtenti = utenteCsvToList(posizioneFiles + "utenti.csv");
        utenteRepository.saveAll(listaUtenti);
        
        List<Attivita> listaAttivita = attivitaCsvToList(posizioneFiles + "attivita.csv");
        attivitaRepository.saveAll(listaAttivita);
        
        List<Pasto> listapasti = pastoCsvToList(posizioneFiles + "pasti.csv");
        pastoRepository.saveAll(listapasti);
        
        List<Sonno> listaSonni = sonnoCsvToList(posizioneFiles + "sonno.csv");
        sonnoRepository.saveAll(listaSonni);
        

        return "ok";
    }
    
    //funzione creata con ChatGpt
    public static List<Utente> utenteCsvToList(String filePath) {
      List<Utente> utenti = new ArrayList<>();
      try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
          String line;
          while ((line = br.readLine()) != null) {
              // Split della riga in base alla virgola
              String[] fields = line.split(",");

              // Creazione di un oggetto Utente con i dati della riga
              if (fields.length == 8) {  // Assicurarsi che ci siano 8 campi
                  Utente nuovoUtente = new Utente(
                      fields[0], // username
                      fields[1], // nome
                      fields[2], // cognome
                      fields[3], // password
                      Integer.valueOf(fields[4]), // eta
                      Integer.valueOf(fields[5]), // altezza
                      Integer.valueOf(fields[6]), // peso
                      Integer.valueOf(fields[7])  // calorie_giornaliere
                  );
                  utenti.add(nuovoUtente);  // Aggiungi l'utente alla lista
              }
          }
      } catch (IOException e) {
          e.printStackTrace();
      }
      return utenti;
    }
    
    public static List<Attivita> attivitaCsvToList(String filePath) {
      List<Attivita> attivitaLista = new ArrayList<>();
      //preparo un dateformat per fare successivamente la conversione da stringa
      SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
      
      try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
          String line;
          while ((line = br.readLine()) != null) {
              String[] fields = line.split(",");
              
              if (fields.length == 7) {
                  try{
                    Attivita nuovaAttivita = new Attivita();
                    //non uso il costruttore perché non accetta null come valore dell'id, l'id verrà poi generato dal db
                    nuovaAttivita.setData(dateFormat.parse(fields[1]));
                    nuovaAttivita.setDurata(Integer.valueOf(fields[2]));
                    nuovaAttivita.setSforzo(Integer.valueOf(fields[3]));
                    nuovaAttivita.setCalorie_bruciate(Integer.valueOf(fields[4]));
                    nuovaAttivita.setSport(fields[5]);
                    nuovaAttivita.setUsername(fields[6]);
                    
                    attivitaLista.add(nuovaAttivita);                     
                  }
                  catch (ParseException e) {
                    System.err.println("Errore nel formato della data: " + fields[1]); 
                  }
              }
          }
      } catch (IOException e) {
          e.printStackTrace();
      }
      return attivitaLista;
  }
    
    public static List<Pasto> pastoCsvToList(String filePath) {
      List<Pasto> pastoLista = new ArrayList<>();
      SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
      
      try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
          String line;
          while ((line = br.readLine()) != null) {
              String[] fields = line.split(",");
              
              if (fields.length == 5) {
                  try{
                    Pasto nuovoPasto = new Pasto();
                    nuovoPasto.setData(dateFormat.parse(fields[1]));
                    nuovoPasto.setTipo(fields[2]);
                    nuovoPasto.setCalorie_ingerite(Integer.valueOf(fields[3]));
                    nuovoPasto.setUsername(fields[4]);
                    
                    pastoLista.add(nuovoPasto);                    
                  }
                  catch (ParseException e) {
                    System.err.println("Errore nel formato della data: " + fields[1]); 
                  }
              }
          }
      } catch (IOException e) {
          e.printStackTrace();
      }
      return pastoLista;
  }
    
    public static List<Sonno> sonnoCsvToList(String filePath) {
      List<Sonno> sonnoLista = new ArrayList<>();
      SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
      
      try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
          String line;
          while ((line = br.readLine()) != null) {
              String[] fields = line.split(",");
              
              if (fields.length == 5) {
                  try{
                    Sonno nuovoSonno = new Sonno();
                    nuovoSonno.setData(dateFormat.parse(fields[1]));
                    nuovoSonno.setDurata(Integer.valueOf(fields[2]));
                    nuovoSonno.setQualita(Integer.valueOf(fields[3]));
                    nuovoSonno.setUsername(fields[4]);
                    
                    sonnoLista.add(nuovoSonno);                   
                  }
                  catch (ParseException e) {
                    System.err.println("Errore nel formato della data: " + fields[1]); 
                  }
              }
          }
      } catch (IOException e) {
          e.printStackTrace();
      }
      return sonnoLista;
  }
    
}
