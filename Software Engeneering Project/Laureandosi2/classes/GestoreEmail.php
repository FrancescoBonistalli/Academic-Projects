<?php
use PHPMailer\PHPMailer\Exception;
use PHPMailer\PHPMailer\PHPMailer;

require_once __DIR__."/../lib/PHPMailer/src/Exception.php";
require_once __DIR__."/../lib/PHPMailer/src/PHPMailer.php";
require_once __DIR__."/../lib/PHPMailer/src/SMTP.php";
class GestoreEmail
{
    public $email;
    public $laureando;
    public $cdl;
    public $allegatoEmail;

    public function __construct($matricola, $cdl)
    {
        $this->cdl = $cdl;
        if($cdl == ING_INFORMATICA){
            $this->laureando = new LaureandoIngInformatica($matricola, $this->cdl);
        }
        else {
            $this->laureando = new Laureando($matricola, $this->cdl);
        }
        $this->allegatoEmail = __DIR__."/../data/Prospetti/$cdl/".$matricola ."_prospetto.pdf";
    }
    public function generaEmail()
    {
        $datiConfig = new DatiConfigurazione();

        $this->email = new PHPMailer();
        $this->email->IsSMTP();
        $this->email->Host = "mixer.unipi.it";
        $this->email->SMTPSecure = "tls";
        $this->email->SMTPAuth = false;
        $this->email->Port = 25;

        $this->email->From='no-reply-laureandosi@ing.unipi.it';
        $this->email->addAddress($this->laureando->email);
        $this->email->Subject = "Appello di laurea in ".$datiConfig->nomiComuniCdl[$this->cdl]."- indicatori per voto di laurea";
        $this->email->addCustomHeader('Content-Type', 'text/plain; windows-1252');
        $this->email->Body = mb_convert_encoding($datiConfig->messaggiEmail[$this->cdl], 'Windows-1252', 'UTF-8');
        $this->email->AddAttachment($this->allegatoEmail);

    }

    public function inviaEmail()
    {
        $this->generaEmail();
        if (!$this->email->send()){
            return false;
        }
        $this->email->SmtpClose();
        unset($this->email);
        return true;
    }
}