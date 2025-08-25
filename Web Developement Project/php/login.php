<?php 

require_once "DbParam.php";

$url_back = "../index.php";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $mail = $_POST['mail'];
    $pw = $_POST['password'];
    $nome = $_POST['name'];
    $cognome = $_POST['surname'];

    //controllo inserimento campi obbligatori
    if(!isset($mail)){
        echo ("<script>alert('Mail non inserita'); 
                    window.history.back();
                </script>");
        exit;
    }
    
    if(!isset($pw)){
        echo ("<script>alert('Password non inserita'); 
                    window.history.back();
                </script>");
        exit;
    }

    //controllo formattazione input
    if(!preg_match("/^(.+)@([^\.].*)\.([a-z]{2,})$/", $mail)){
        echo ("<script>alert('Formato mail non valido'); 
                    window.history.back();
                </script>");
        exit;
    }


    //connessione al database
    $connection = mysqli_connect(DBHOST, DBUSER, DBPW, DBNOME);

    //controllo errore di connessione
    if(mysqli_connect_errno()){
        echo ("<script>alert('Connessione non riuscita: ".mysqli_connect_error()."'); 
                    window.history.back();
                </script>");
        exit;
    }
    else{

        //gestione registrazione
        if(isset($_POST['registra'])){

            //controllo presenza e formato degli input obbligatori per la registrazione
            if(!isset($nome)){
                echo ("<script>alert('Nome non inserito'); 
                        window.history.back();
                    </script>");
                exit;
            }
            if(!isset($cognome)){
                echo ("<script>alert('Cognome non inserito'); 
                        window.history.back();
                    </script>");
                exit;
            }
            if(!preg_match("/^[a-zA-Z]+(\s[a-zA-Z]+)*$/", $nome)){
                echo ("<script>alert('Formato nome non valido'); 
                        window.history.back();
                    </script>");
                exit;
            }
            if(!preg_match("/^[a-zA-Z]+(\s[a-zA-Z]+)*$/", $cognome)){
                echo ("<script>alert('Formato cognome non valido'); 
                        window.history.back();
                    </script>");
                exit;
            }
            if(!preg_match("/^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/", $pw)){
                echo ("<script>alert('Password non valida. Assicurati che sia lunga almeno 8 caratteri e che contenga: 1 maiuscola, 1 numero, 1 carattere speciale.'); 
                            window.history.back();
                        </script>");
                exit;
            }

            //dialogo con il database con sanitificazione degli input tramite prepared statement
            $query_utenti_prova = "SELECT Mail 
                            FROM bonistalli_641419.Utenti
                            WHERE Mail = ?";

            if($statement_mail = mysqli_prepare($connection, $query_utenti_prova)){
                mysqli_stmt_bind_param($statement_mail, 's', $mail);
                mysqli_stmt_execute($statement_mail);
            }
            else{
                echo ("<script>alert('Errore nell'inserimento della mail'); 
                        window.history.back();
                    </script>");
                mysqli_stmt_free_result($statement_mail);
                mysqli_close($connection);
                exit;
            }

            //gestione utente già registrato
            if(mysqli_stmt_fetch($statement_mail)){
                echo ("<script>alert('Utente già registrato'); 
                        window.history.back();
                    </script>");
                mysqli_close($connection);
                exit;
            }

            //gestione registrazione sul database
            $hash_pw = password_hash($pw, PASSWORD_BCRYPT);
            
            $query_nuovo_utente = "INSERT INTO bonistalli_641419.Utenti
                                    VALUES (?,?,?,?)";
            
            mysqli_stmt_free_result($statement_mail);

            if($statement_nuovo_utente = mysqli_prepare($connection, $query_nuovo_utente)){
                mysqli_stmt_bind_param($statement_nuovo_utente, "ssss", $mail, $hash_pw, $nome, $cognome);
                if(mysqli_stmt_execute($statement_nuovo_utente)){

                    mysqli_close($connection);
                    echo ("<script>alert('Registrazione avvenuto con successo'); 
                                window.history.back();
                            </script>");
                    exit;
                }
                else {
                    mysqli_close($connection);
                    echo ("<script>alert('Registrazione fallita'); 
                                window.history.back();
                            </script>");
                    exit;
                }
            }
            else{
                mysqli_close($connection);
                echo ("<script>alert('Errore in fase di accesso al database: '".mysqli_error($connection)."); 
                            window.history.back();
                        </script>");
                exit;
            }
            
        }
        //gestione login
        else if(isset($_POST['login'])){

            //gestione dialogo con il database
            $query_login_prova = "SELECT Password
                            FROM bonistalli_641419.Utenti
                            WHERE Mail = ?";

            if($statement_pw = mysqli_prepare($connection, $query_login_prova)){
                mysqli_stmt_bind_param($statement_pw, 's', $mail);
                mysqli_stmt_execute($statement_pw);
                
                mysqli_stmt_bind_result($statement_pw, $hash_pw);

                //controllo se utente registrato
                if(mysqli_stmt_fetch($statement_pw)){
                    if(password_verify($pw, $hash_pw)){
                        
                        //login effettuato e recupero degli altri parametri dell'utente
                        mysqli_stmt_free_result($statement_pw);
                        $query_recupero_dati_personali = "SELECT Nome, Cognome
                                                            FROM Utenti
                                                            WHERE Mail = '$mail'";
                        
                        $result_dati_personali = mysqli_query($connection, $query_recupero_dati_personali);
                        $vettore_dati_personali = mysqli_fetch_assoc($result_dati_personali);

                        //avvio sessione e settaggio dei parametri dell'utente che ha effettuato il login
                        session_start();
                        $_SESSION['mail'] = $mail;
                        $_SESSION['nome'] = $vettore_dati_personali['Nome'];
                        $_SESSION['cognome'] = $vettore_dati_personali['Cognome'];
                        $_SESSION['login_ok'] = true;

                        echo ("<script>
                                alert('Login effettuato correttamente, può ora effettuare prenotazioni'); 
                                window.history.back();
                            </script>");
                        exit;
                    }
                    else{ 
                        echo ("<script>alert('Password errata, riprovare'); 
                                window.history.back();
                            </script>");
                        exit;
                    }
                }
                else{
                    echo ("<script>alert('Utente non registrato, registrati al sito prima di effettuare il login'); 
                                window.history.back();
                            </script>");
                    exit;
                }
            }
            else{
                mysqli_close($connection);
                echo ("<script>alert('Errore nell'inserimento della password: ".mysqli_error($connection)."'); 
                            window.history.back();
                    </script>");
                exit;
            }    

        }
        mysqli_close($connection);
        echo ("<script>alert('Errore nel tipo di richiesta effettuata, riprovare'); 
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
