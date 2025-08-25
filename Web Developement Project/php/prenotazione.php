<?php 

require_once "DbParam.php";

$url_back = "../index.php";

if ($_SERVER["REQUEST_METHOD"] == "POST"){
                    
    $connection = mysqli_connect(DBHOST, DBUSER, DBPW, DBNOME);

    if(mysqli_connect_errno()){
        echo ("<script>alert('Connessione non riuscita: ".mysqli_connect_error()."'); 
                    window.history.back();
                </script>");
        exit;
    }
    else{
        //controllo login effettuato
        session_start();
        if(!$_SESSION['login_ok']){
            echo ("<script>alert('".$_SESSION['mail']."Effettua il login prima di richiedere una prenotazione'); 
                    window.history.back();
                </script>");
            exit;
        }
        
        //recupero dati
        $nome_stanza = $_POST['nome_stanza'];
        $prezzo_notte = $_POST['prezzo_notte'];
        $data_check_in = $_POST['data-check-in'];
        $data_check_out = $_POST['data-check-out'];
        
        //controllo dati
        if($data_check_in == null || $data_check_out == null){
            echo ("<script>alert('Una o più date mancanti, riprovare'); 
                    window.history.back();
                </script>");
            exit;
        }

        if($data_check_out <= $data_check_in){
            echo ("<script>alert('La data del check-out deve essere successiva a quella del check-in.'); 
                    window.history.back();
                </script>");
            exit;
        }

        date_default_timezone_set(date_default_timezone_get());
        $data_odierna = date('Y-m-d');
        
        if($data_check_in < $data_odierna){
            echo ("<script>alert('La data del check-in non può essere passata, inserire nuovamente le date'); 
                        window.history.back();
                  </script>");
            exit;
        }

        $data_check_in_class = new DateTime($data_check_in);
        $data_check_out_class = new DateTime($data_check_out);
        $numero_giorni = date_diff($data_check_in_class, $data_check_out_class);
        if($numero_giorni->d > 14){
            echo ("<script>alert('Il soggiorno non può superare i 14 giorni, inserire nuovamente le date'); 
                    window.history.back();
                </script>");
            exit;
        }

        //query per cercare prenotazioni con date che si sovrappongono a quelle richieste
        $query_disponibilita_stanza = "SELECT *
                                       FROM bonistalli_641419.Prenotazioni
                                       WHERE Stanza = '$nome_stanza' AND
                                                        (
                                                            ('$data_check_in' < Data_fine AND '$data_check_in' > Data_inizio) 
                                                            OR 
                                                            ('$data_check_out' > Data_inizio AND '$data_check_out' < Data_fine)
                                                                                                )";

        $result_prenotazioni_sovrapposte = mysqli_query($connection, $query_disponibilita_stanza);

        if($result_prenotazioni_sovrapposte){
            if(mysqli_num_rows($result_prenotazioni_sovrapposte) == 0){
                
                //date disponibili
                $nome_utente = $_SESSION['nome'];
                $cognome_utente = $_SESSION['cognome'];
                $mail = $_SESSION['mail'];
                
                $prezzo_notte_int = intval($prezzo_notte);

                $giorni = $numero_giorni->d;

                $prezzo_preotazione_stanza = $giorni * $prezzo_notte_int;


                $query_numero_prenotazioni = "SELECT MAX(Numero) as 'Max_num'
                                              FROM bonistalli_641419.Prenotazioni";
                $numero_attuale_result = mysqli_query($connection, $query_numero_prenotazioni);
                $numero_attuale_array = mysqli_fetch_assoc($numero_attuale_result);
                $numero_attuale = $numero_attuale_array['Max_num'];
                $numero_attuale_intero = intval($numero_attuale);
                $numero_attuale_intero++;
                
                
                $query_prenotazione_stanza = "INSERT INTO bonistalli_641419.Prenotazioni
                                              VALUES ($numero_attuale_intero,
                                                      '$nome_utente',
                                                      '$cognome_utente',
                                                      '$nome_stanza',
                                                      '$data_check_in',
                                                      '$data_check_out',
                                                      $prezzo_preotazione_stanza,
                                                      '$mail')";

                if(mysqli_query($connection, $query_prenotazione_stanza)){
                    echo "Prenotazione salvata con successo";

                    //------------------------------------------------------
                    //Invio mail di conferma, funzione non vista a lezione trovata nel manuale php
                    $to = $mail;
                    $subject = "Conferma prenotazione";
                    $message = "Gentile Signore/a ".$nome_utente." ".$cognome_utente.",\r\n".
                                "La sua prenotazione presso l'Hotel Montefoscoli per la ".$nome_stanza." è confermata. \r\n
                                La avvisiamo che al momento del check-in che avverrà in data ".$data_check_in." dovrà pagare la somma di ".
                                $prezzo_preotazione_stanza."€";
                    
                    mail($to, $subject, $message);
                    //------------------------------------------------------

                    //preparazione parametri per la schermata di conferma
                    $_SESSION['conferma_param'] = array("numero" => $numero_attuale_intero, 
                                                        "nome" => $nome_utente, 
                                                        "cognome" => $cognome_utente,
                                                        "stanza"=> $nome_stanza,
                                                        "inizio" => $data_check_in,
                                                        "fine" => $data_check_out,
                                                        "prezzo" => $prezzo_preotazione_stanza,
                                                        "mail" => $mail); 
                    mysqli_close($connection);
                    //reindirizzamento alla schermata di conferma
                    $url_prenotazione_ok = "prenotazione_effettuata.php";
                    header("Location: ".$url_prenotazione_ok);
                }
                else{
                    echo ("<script>alert('Prenotazione non salvata, riprovare'); 
                                window.history.back();
                            </script>");
                    exit;
                }
            }
            else{
                echo ("<script>alert('Date non disponibili, riprovare'); 
                        window.history.back();
                        </script>");
                    exit;
            }
        }
        else{
            echo ("<script>alert('Errore nell'elaborazione della prenotazione, riprovare'); 
                    window.history.back();
                    </script>");
            exit;
        }
        echo ("<script>alert('Errore nella connessione al database".mysqli_errno($connection).", riprovare'); 
                    window.history.back();
                </script>");
        exit;
        
    }
}
else{
    echo ("<script>alert('Metodo richiesta non corretto, riprovare'); 
                window.history.back();
            </script>");
    exit;
}

?>