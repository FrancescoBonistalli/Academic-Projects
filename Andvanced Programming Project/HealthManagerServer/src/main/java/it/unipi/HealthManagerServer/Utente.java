/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package it.unipi.HealthManagerServer;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.io.Serializable;

/**
 *
 * @author parru
 */
@Entity
@Table(name="utente", schema="641419")
public class Utente implements Serializable {
    @Id
    private String username;
    @Column(name="nome")
    private String nome;
    @Column(name="cognome")
    private String cognome;
    @Column(name="password")
    private String password;
    @Column(name="eta")
    private int eta;
    @Column(name="altezza")
    private int altezza;
    @Column(name="peso")
    private int peso;
    @Column(name="calorie_giornaliere")
    private int calorie_giornaliere;
    
    public Utente(){
        
    }

    public Utente(String username, String nome, String cognome, String password, int eta, int altezza, int peso, int calorie_giornaliere) {
        this.username = username;
        this.nome = nome;
        this.cognome = cognome;
        this.password = password;
        this.eta = eta;
        this.altezza = altezza;
        this.peso = peso;
        this.calorie_giornaliere = calorie_giornaliere;
    }

    public String getUsername() {
        return username;
    }

    public String getNome() {
        return nome;
    }

    public String getCognome() {
        return cognome;
    }

    public String getPassword() {
        return password;
    }

    public int getEta() {
        return eta;
    }

    public int getAltezza() {
        return altezza;
    }

    public int getPeso() {
        return peso;
    }

    public int getCalorie_giornaliere() {
        return calorie_giornaliere;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public void setCognome(String cognome) {
        this.cognome = cognome;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setEta(int eta) {
        this.eta = eta;
    }

    public void setAltezza(int altezza) {
        this.altezza = altezza;
    }

    public void setPeso(int peso) {
        this.peso = peso;
    }

    public void setCalorie_giornaliere(int calorie_giornaliere) {
        this.calorie_giornaliere = calorie_giornaliere;
    }
    

}
