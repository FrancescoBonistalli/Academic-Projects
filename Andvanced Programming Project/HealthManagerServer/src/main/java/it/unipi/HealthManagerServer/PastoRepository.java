/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package it.unipi.HealthManagerServer;

import java.util.List;
import org.springframework.data.repository.CrudRepository;

/**
 *
 * @author parru
 */
public interface PastoRepository extends CrudRepository<Pasto, Integer> {
    List<Pasto> findAllByUsername(String username);
}
