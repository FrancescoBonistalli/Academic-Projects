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
public class Sonno {
    private int id_sonno;
    private Date data;
    private int durata;
    private int qualita;
    private String username;
    
    public Sonno(){
        
    }

    public Sonno(int id_sonno, Date data, int durata, int qualita, String username) {
        this.id_sonno = id_sonno;
        this.data = data;
        this.durata = durata;
        this.qualita = qualita;
        this.username = username;
    }
    
    @Override
    public String toString() {
        return "{" +
                "id_sonno='" + id_sonno + '\'' +
                ", data=" + data +
                ", durata=" + durata +
                ", qualita=" + qualita +
                ", username=" + username +
                 '\'' +
                '}';
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

    public void setUsername(String username) {
        this.username = username;
    }
    
    
}
