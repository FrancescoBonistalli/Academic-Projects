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
@Table(name="pasto", schema="641419")
public class Pasto implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id_pasto;
    @Column(name="data")
    private Date data;
    @Column(name="tipo")
    private String tipo;
    @Column(name="calorie_ingerite")
    private int calorie_ingerite;
    
    @Column(name = "username")
    private String username;
    
    public Pasto(){
        
    }

    public Pasto(int id_pasto, Date data, String tipo, int calorie_ingerite, String pasti_utente_usr) {
        this.id_pasto = id_pasto;
        this.data = data;
        this.tipo = tipo;
        this.calorie_ingerite = calorie_ingerite;
        this.username = pasti_utente_usr;
    }

    public int getId_pasto() {
        return id_pasto;
    }

    public Date getData() {
        return data;
    }

    public String getTipo() {
        return tipo;
    }

    public int getCalorie_ingerite() {
        return calorie_ingerite;
    }

    public String getUsername() {
        return username;
    }

    public void setId_pasto(int id_pasto) {
        this.id_pasto = id_pasto;
    }

    public void setData(Date data) {
        this.data = data;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public void setCalorie_ingerite(int calorie_ingerite) {
        this.calorie_ingerite = calorie_ingerite;
    }

    public void setUsername(String pasti_utente_usr) {
        this.username = pasti_utente_usr;
    }
    
    
}
