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
public class Pasto {
    private int id_pasto;
    private Date data;
    private String tipo;
    private int calorie_ingerite;
    private String username;
    
    public Pasto(){
        
    }

    public Pasto(int id_pasto, Date data, String tipo, int calorie_ingerite, String username) {
        this.id_pasto = id_pasto;
        this.data = data;
        this.tipo = tipo;
        this.calorie_ingerite = calorie_ingerite;
        this.username = username;
    }
    
    @Override
    public String toString() {
        return "Attivita{" +
                "id_attivita='" + id_pasto + '\'' +
                ", data=" + data +
                ", tipo=" + tipo +
                ", cal=" + calorie_ingerite +
                ", user=" + username +
                 '\'' +
                '}';
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

    public void setUsername(String username) {
        this.username = username;
    }
    
    
}
