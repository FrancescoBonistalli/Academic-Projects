<?php

require_once ("GestioneCarrieraStudente.php");
require_once ("InterfacciaGrafica.php");
require_once ("DatiConfigurazione.php");
require_once ("Laureando.php");
require_once ("globals.php");

const FALLITO = "fallito";
const OK = "eseguito correttamente";
class Test
{
    private $anagraficheTest;
    private $carriereTest;

    private $anagraficheExpected;
    private $carriereExpected;
    private $matricoleTest = [
                              "123456",
                              "234567",
                              "345678",
                              "456789",
                              "567890"];
    public $messaggioTest;

    public function __construct(){
        $this->resetMessaggio();

        $gCS = new GestioneCarrieraStudente();
        foreach ($this->matricoleTest as $matricolaTest){
            $this->anagraficheTest[$matricolaTest] = $gCS->getAnagraficaTest($matricolaTest);
        }
        foreach ($this->matricoleTest as $matricolaTest){
            $this->carriereTest[$matricolaTest] = $gCS->getCarrieraTest($matricolaTest);
        }
        foreach ($this->matricoleTest as $matricolaTest){
            $json = file_get_contents(__DIR__.'/../data/AnagraficheTest/'.$matricolaTest.'_anagrafica_expected.json');
            $anagraficaArray = json_decode($json, true);
            $this->anagraficheExpected[$matricolaTest] = $anagraficaArray;
        }

        foreach ($this->matricoleTest as $matricolaTest){
            $json = file_get_contents(__DIR__.'/../data/EsamiTest/'.$matricolaTest.'_esami_expected.json');
            $esameArray = json_decode($json, true);
            $this->carriereExpected[$matricolaTest] = $esameArray;
        }
    }

    private function resetMessaggio()
    {
        $this->messaggioTest["nome"] = "nome default";
        $this->messaggioTest["errore"] = "nessun errore";
        $this->messaggioTest["esito"] = OK;
    }

    public function testAnagrafica()
    {
        $this->resetMessaggio();
        $this->messaggioTest["nome"] = "Test dell'anagrafica";

        foreach ($this->matricoleTest as $matricolaTest){
            if($this->anagraficheTest[$matricolaTest]["nome"] != $this->anagraficheExpected[$matricolaTest]["nome"]){
                $this->messaggioTest["errore"] = "nome di ".$matricolaTest." non corretto nell'anagrafica";
                $this->messaggioTest["esito"] = FALLITO;
                return;
            }
            if($this->anagraficheTest[$matricolaTest]["cognome"] != $this->anagraficheExpected[$matricolaTest]["cognome"]){
                $this->messaggioTest["errore"] = "cognome di ".$matricolaTest." non corretto nell'anagrafica";
                $this->messaggioTest["esito"] = FALLITO;
                return;
            }

            $dataTest = str_replace("/", "-", $this->carriereTest[$matricolaTest][0]["INIZIO_CARRIERA"]);
            if($dataTest != $this->anagraficheExpected[$matricolaTest]["dataIscrizione"]){
                $this->messaggioTest["errore"] = "data iscrizione di ".$matricolaTest." non corretta nell'anagrafica";
                $this->messaggioTest["esito"] = FALLITO;
                return;
            }
        }
    }

    public function testCarriere()
    {
        $this->resetMessaggio();
        $this->messaggioTest["nome"] = "Test delle carriere";

        foreach ($this->matricoleTest as $matricolaTest){
            $laureando = new Laureando($matricolaTest, $this->carriereTest[$matricolaTest][0]["CORSO"], true);
            foreach ($this->carriereExpected[$matricolaTest] as $esameCarriera=>$value){
                if($laureando->esami[$esameCarriera]->voto != $value["VOTO"] && ($laureando->esami[$esameCarriera]->voto > 30 && $value["VOTO"] != "30  e lode")){
                    $this->messaggioTest["esito"] = FALLITO;
                    $this->messaggioTest["errore"] = "test matricola ".$matricolaTest." sul voto di ".$esameCarriera." atteso ".$laureando->esami[$esameCarriera]->voto." ottenuto ".$value["VOTO"];
                }
                if($laureando->esami[$esameCarriera]->cfu != $value["PESO"]){
                    $this->messaggioTest["esito"] = FALLITO;
                    $this->messaggioTest["errore"] = "test matricola ".$matricolaTest." sui cfu di ".$esameCarriera." atteso ".$laureando->esami[$esameCarriera]->cfu." ottenuto ".$value["VOTO"];
                }
            }
        }

    }

    public function testBonus()
    {
        $this->resetMessaggio();
        $this->messaggioTest["nome"] = "Test della verifica del bonus informatico";

        $laureandoTest1 = new LaureandoIngInformatica(123456, ING_INFORMATICA, true);
        $dataTreAnni1 = "29-07-2019";
        $dataQuattroAnni1 = "29-08-2020";
        //test 3 anni
        $laureandoTest1->dataLaurea = $dataTreAnni1;
        if(!$laureandoTest1->verificaBonus()){
            $this->messaggioTest["errore"] = "bonus non trovato per laurea dopo 3 anni esatti";
            $this->messaggioTest["esito"] = FALLITO;
            return;
        }
        //test 4 anni
        $laureandoTest1->dataLaurea = $dataQuattroAnni1;
        if($laureandoTest1->verificaBonus()){
            $this->messaggioTest["errore"] = "bonus rilevato quando non atteso a 4 anni dall'iscrizione";
            $this->messaggioTest["esito"] = FALLITO;
            return;
        }

        $laureandoTest2 = new LaureandoIngInformatica(345678, ING_INFORMATICA, true);
        $dataTreAnni2 = "29-11-2022";    //data 3 anni e 4 mesi dopo
        $dataQuattroAnni2 = "29-07-2024";    //data 5 anni dopo
        //test 3 anni e 4 mesi
        $laureandoTest2->dataLaurea = $dataTreAnni2;
        if(!$laureandoTest2->verificaBonus()){
            $testOk = false;
            $this->messaggioTest["errore"] = "bonus non trovato per laurea dopo 3 anni e 4 mesi";
            $this->messaggioTest["esito"] = FALLITO;
            return;
        }
        //test 5 anni
        $laureandoTest2->dataLaurea = $dataQuattroAnni2;
        if($laureandoTest2->verificaBonus()){
            $testOk = false;
            $this->messaggioTest["errore"] = "bonus rilevato quando non atteso a 5 anni dall'iscrizione";
            $this->messaggioTest["esito"] = FALLITO;
            return;
        }


    }

    public function testNumeriCarriera()
    {
        $this->resetMessaggio();
        $this->messaggioTest["nome"] = "Test valori numerici vari";

        $valoriAttesi["123456"] = [
            "cdl" => ING_INFORMATICA,
            "media" => 23.655,
            "cfuMedia" => 174,
            "cfuCurriculari" => 177,
            "mediaInfo" => 23.667,
        ];
        $valoriAttesi["234567"] = [
            "cdl" => "INGEGNERIA ELETTRONICA (WIE-LM)",
            "media" => 24.559,
            "cfuMedia" => 102,
            "cfuCurriculari" => 102,
            "mediaInfo" => null,
        ];
        $valoriAttesi["345678"] = [
            "cdl" => "INGEGNERIA INFORMATICA (IFO-L)",
            "media" => 25.564,
            "cfuMedia" => 165,
            "cfuCurriculari" => 177,
            "mediaInfo" => 25.75,
        ];
        $valoriAttesi["456789"] = [
            "cdl" => "INGEGNERIA DELLE TELECOMUNICAZIONI (WIT-LM)",
            "media" => 32.625,
            "cfuMedia" => 96,
            "cfuCurriculari" => 96,
            "mediaInfo" => null,
        ];
        $valoriAttesi["567890"] = [
            "cdl" => "CYBERSECURITY (WCY-LM)",
            "media" => 24.882,
            "cfuMedia" => 102,
            "cfuCurriculari" => 120,
            "mediaInfo" => null,
        ];

        foreach ($this->matricoleTest as $matricola){
            $cdlTest = $valoriAttesi[$matricola]["cdl"];
            if($cdlTest ==  ING_INFORMATICA){
                $laureandoTest = new LaureandoIngInformatica($matricola, $cdlTest, true);

                //setting date per bonus eventuali
                $dataIscrizioneObj = new DateTime();
                $dataIscrizioneObj->setTimestamp($laureandoTest->dataIscrizione);

                if($matricola == "345678"){
                    $dataIscrizioneObj->add(new DateInterval('P3Y'));
                    $laureandoTest->dataLaurea = $dataIscrizioneObj->format('d-m-Y');
                }
                else {
                    $dataIscrizioneObj->add(new DateInterval('P4Y'));
                    $laureandoTest->dataLaurea = $dataIscrizioneObj->format('d-m-Y');
                }

            }
            else {
                $laureandoTest = new Laureando($matricola, $cdlTest, true);
            }

            //controllo media
            $media = round($laureandoTest->calcolaMediaPesata(), 3);

            if( $valoriAttesi[$matricola]["media"] != $media ){
                $this->messaggioTest["errore"] = "errore nella media di ".$matricola.": atteso ".$valoriAttesi[$matricola]["media"]." ricevuto: ".$media;
                $this->messaggioTest["esito"] = FALLITO;
                return;
            }

            //controllo cfu in media
            if($valoriAttesi[$matricola]["cfuMedia"] != $laureandoTest->calcolaCfuMedia()){
                $this->messaggioTest["errore"] = "errore nei cfu in media di ".$matricola.": atteso ".$valoriAttesi[$matricola]["cfuMedia"]." ricevuto: ".$laureandoTest->calcolaCfuMedia();
                $this->messaggioTest["esito"] = FALLITO;
                return;
            }

            //controllo cfu curriculari
            if($valoriAttesi[$matricola]["cfuCurriculari"] != $laureandoTest->calcolaCfuCurriculari()){
                $this->messaggioTest["errore"] = "errore nei cfu curriculari di ".$matricola.": atteso ".$valoriAttesi[$matricola]["cfuCurriculari"]." ricevuto: ".$laureandoTest->calcolaCfuCurriculari();
                $this->messaggioTest["esito"] = FALLITO;
                return;
            }

            //controllo media informatica
            if($cdlTest == ING_INFORMATICA){
                $mediaInfo = round($laureandoTest->calcolaMediaEsamiInformatici(), 3);
                if($valoriAttesi[$matricola]["mediaInfo"] != $mediaInfo){
                    $this->messaggioTest["errore"] = "errore nella media informatica di ".$matricola.": atteso ".$valoriAttesi[$matricola]["mediaInfo"]." ricevuto: ".$mediaInfo;
                    $this->messaggioTest["esito"] = FALLITO;
                    return;
                }
            }
        }

    }

}