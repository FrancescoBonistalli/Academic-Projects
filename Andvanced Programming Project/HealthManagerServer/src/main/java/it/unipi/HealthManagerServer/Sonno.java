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
@Table(name="sonno", schema="641419")
public class Sonno implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id_sonno;
    @Column(name="data")
    private Date data;
    @Column(name="durata")
    private int durata;
    @Column(name="qualita")
    private int qualita;
    
    @Column(name = "username")
    private String username;
    
    public Sonno(){
        
    }

    public Sonno(int id_sonno, Date data, int durata, int qualita, String sonno_utente_usr) {
        this.id_sonno = id_sonno;
        this.data = data;
        this.durata = durata;
        this.qualita = qualita;
        this.username = sonno_utente_usr;
    }

    public int getId_sonno() {
        return id_sonno;
    }

    public Date getData() {
        return data;
    }

    public int getDurata() {
        return durata;
    }

    public int getQualita() {
        return qualita;
    }

    public String getUsername() {
        return username;
    }

    public void setId_sonno(int id_sonno) {
        this.id_sonno = id_sonno;
    }

    public void setData(Date data) {
        this.data = data;
    }

    public void setDurata(int durata) {
        this.durata = durata;
    }

    public void setQualita(int qualita) {
        this.qualita = qualita;
    }

    public void setUsername(String sonno_utente_usr) {
        this.username = sonno_utente_usr;
    }
    
    
}
