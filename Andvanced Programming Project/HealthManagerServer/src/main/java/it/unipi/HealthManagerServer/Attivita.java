/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package it.unipi.HealthManagerServer;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.io.Serializable;
import java.util.Date;

/**
 *
 * @author parru
 */
@Entity
@Table(name="attivita", schema="641419")
public class Attivita implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id_attivita;
    @Column(name="data")
    private Date data;
    @Column(name="durata")
    private int durata;
    @Column(name="sforzo")
    private int sforzo;
    @Column(name="calorie_bruciate")
    private int calorie_bruciate;
    @Column(name="sport")
    private String sport;
    
    @Column(name = "username")
    private String username;
    
    public Attivita(){
        
    }

    public Attivita(int id_attivita, Date data, int durata, int sforzo, int calorie_bruciate, String sport, String attivita_utente_usr) {
        this.id_attivita = id_attivita;
        this.data = data;
        this.durata = durata;
        this.sforzo = sforzo;
        this.calorie_bruciate = calorie_bruciate;
        this.sport = sport;
        this.username = attivita_utente_usr;
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

    public void setUsername(String attivita_utente_usr) {
        this.username = attivita_utente_usr;
    }
    

}
