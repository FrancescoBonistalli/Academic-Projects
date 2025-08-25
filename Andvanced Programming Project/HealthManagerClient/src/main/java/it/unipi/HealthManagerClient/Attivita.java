/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package it.unipi.HealthManagerClient;

import java.util.Date;

/**
 *
 * @author parru
 */
public class Attivita {
    private int id_attivita;
    private Date data;
    private int durata;
    private int sforzo;
    private int calorie_bruciate;
    private String sport;
    private String username;

    public Attivita(){
        
    }
    
    public Attivita(int id_attivita, Date data, int durata, int sforzo, int calorie_bruciate, String sport, String username) {
        this.id_attivita = id_attivita;
        this.data = data;
        this.durata = durata;
        this.sforzo = sforzo;
        this.calorie_bruciate = calorie_bruciate;
        this.sport = sport;
        this.username = username;
    }
    
    @Override
    public String toString() {
        return "Attivita{" +
                "id_attivita='" + id_attivita + '\'' +
                ", data=" + data +
                ", durata=" + durata +
                ", sforzo=" + sforzo +
                ", calorie_bruciate=" + calorie_bruciate +
                ", sport='" + sport + '\'' +
                '}';
    }
    
    public int getId_attivita() {
        return id_attivita;
    }

    public Date getData() {
        return data;
    }

    public int getDurata() {
        return durata;
    }

    public int getSforzo() {
        return sforzo;
    }

    public int getCalorie_bruciate() {
        return calorie_bruciate;
    }

    public String getSport() {
        return sport;
    }

    public String getUsername() {
        return username;
    }

    public void setId_attivita(int id_attivita) {
        this.id_attivita = id_attivita;
    }

    public void setData(Date data) {
        this.data = data;
    }

    public void setDurata(int durata) {
        this.durata = durata;
    }

    public void setSforzo(int sforzo) {
        this.sforzo = sforzo;
    }

    public void setCalorie_bruciate(int calorie_bruciate) {
        this.calorie_bruciate = calorie_bruciate;
    }

    public void setSport(String sport) {
        this.sport = sport;
    }

    public void setUsername(String username) {
        this.username = username;
    }
    
    
    
}
