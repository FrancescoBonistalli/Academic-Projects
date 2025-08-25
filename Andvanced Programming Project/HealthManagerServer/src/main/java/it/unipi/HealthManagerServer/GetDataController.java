/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package it.unipi.HealthManagerServer;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 *
 * @author parru
 */
@Controller
@RequestMapping(path="/HealthManager")
public class GetDataController {
    @Autowired
    UtenteRepository utenteRepository;
    
    @Autowired
    AttivitaRepository attivitaRepository;
    
    @Autowired
    SonnoRepository sonnoRepository;
    
    @Autowired
    PastoRepository pastoRepository;
    
    @GetMapping(path="/utente")
    public @ResponseBody Utente getUtenteByUsr(@RequestParam String usr){
        return utenteRepository.findByUsername(usr);
    }
    
    @GetMapping(path="/utenti/tutti")
    public @ResponseBody List<Utente> getUtentiTutti(){
        return utenteRepository.findAll();
    }
    
    @GetMapping(path="/attivita")
    public @ResponseBody List<Attivita> getAttivitaUtente(@RequestParam String usr){
        return attivitaRepository.findAllByUsername(usr);
    }
    
    @GetMapping(path="/sonno")
    public @ResponseBody List<Sonno> getSonnoUtente(@RequestParam String usr){
        return sonnoRepository.findAllByUsername(usr);
    }
    
    @GetMapping(path="/pasto")
    public @ResponseBody List<Pasto> getPastoUtente(@RequestParam String usr){
        return pastoRepository.findAllByUsername(usr);
    }
    
    
}
