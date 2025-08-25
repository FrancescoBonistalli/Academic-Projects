/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package it.unipi.HealthManagerClient;

/**
 *
 * @author parru
 */
public class UtenteAttivo {
    static String username;
    
    public String getUtenteAttivo(){
        return this.username;
    }
    public void setUtenteAttivo(String s){
        this.username = s;
    }
    public void resetUtenteAttivo(){
        this.username = null;
    }
}
