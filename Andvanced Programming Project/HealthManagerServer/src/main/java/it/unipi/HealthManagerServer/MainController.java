/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package it.unipi.HealthManagerServer;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 *
 * @author parru
 */
//controllore contenente solo la risposta per il controllo dello stato della connessione
@Controller
@RequestMapping(path="/HealthManager")
public class MainController {
    public MainController(){
        
    }
    
    @GetMapping(path="/stato")
    public @ResponseBody String stato(){
        return "server correttamente online";
    }
    
}
