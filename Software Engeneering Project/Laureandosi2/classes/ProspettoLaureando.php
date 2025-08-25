<?php

require_once __DIR__."/../lib/fpdf184/fpdf.php";
require_once "Laureando.php";
require_once "LaureandoIngInformatica.php";
require_once "DatiConfigurazione.php";
require_once "globals.php";

class ProspettoLaureando
{
    public $laureando;
    public $laureandoInfo;
    public $cdl;

    public function __construct($matricola, $dataLaurea, $cdl)
    {
        $this->cdl = $cdl;
        $this->laureandoInfo = false;

        if($this->cdl == ING_INFORMATICA){
            $this->laureandoInfo = true;
            $this->laureando = new LaureandoIngInformatica($matricola, $this->cdl);
        }
        else {
            $this->laureando = new Laureando($matricola, $cdl);
        }
        $this->laureando->dataLaurea = $dataLaurea;

    }
    public function generaProspettoLaureando($pdf)
    {
        $pdf->AddPage();
        $pdf->SetFont('Arial', '', 16);

        //estrazione nome comune cdl
        $datiConfig = new DatiConfigurazione();
        $nomeComuneCorsoProspetto = $datiConfig->nomiComuniCdl[$this->cdl];

        //titolo
        $pdf->Cell(0,6,$nomeComuneCorsoProspetto, 0, 1, "C");
        $pdf->Cell(0,6,"CARRIERA E SIMULAZIONE DEL VOTO DI LAUREA", 0, 1, "C");
        $pdf->Ln(3);

        //Cella dati anagrafici
        $pdf->SetFontSize(9);
        $pdf->Rect($pdf->GetX(), $pdf->GetY(), $pdf->GetPageWidth() - 22, $this->laureandoInfo ? 33 : 27.5);
        $pdf->Cell(45, 5.5, "Matricola:", 0, 0);
        $pdf->Cell(0, 5.5, $this->laureando->matricola, 0, 1);
        $pdf->Cell(45, 5.5, "Nome:", 0, 0);
        $pdf->Cell(0, 5.5, $this->laureando->nome, 0, 1);
        $pdf->Cell(45, 5.5, "Cognome:", 0, 0);
        $pdf->Cell(0, 5.5, $this->laureando->cognome, 0, 1);
        $pdf->Cell(45, 5.5, "Email:", 0, 0);
        $pdf->Cell(0, 5.5, $this->laureando->email, 0, 1);
        $pdf->Cell(45, 5.5, "Data:", 0, 0);
        $pdf->Cell(0, 5.5, $this->laureando->dataLaurea, 0, 1);
            if ($this->laureandoInfo)
        {
            $pdf->Cell(45, 5.5, "Bonus:", 0, 0);
            $pdf->Cell(0, 5.5, $this->laureando->verificaBonus() ? "SI" : "NO", 0, 1);
        }
        $pdf->Ln(3);

        //Header tabella esami
        $pdf->Cell($pdf->GetPageWidth() - 22 - ($this->laureandoInfo ? 44 : 33), 5.5, "ESAME", 1, 0, "C");
        $pdf->Cell(11, 5.5, "CFU", 1, 0, "C");
        $pdf->Cell(11, 5.5, "VOT", 1, 0, "C");
        $pdf->Cell(11, 5.5, "MED", 1, 0, "C");
        if ($this->laureandoInfo)
            $pdf->Cell(11, 5.5, "INF", 1, 0, "C");
        $pdf->Ln();

        //tabella esami
        foreach ($this->laureando->esami as $esame)
        {
            $pdf->Cell($pdf->GetPageWidth() - 22 - ($this->laureandoInfo ? 44 : 33), 4.5, $esame->nome, 1, 0);
            $pdf->Cell(11, 4.5, $esame->cfu, 1, 0, "C");
            $pdf->Cell(11, 4.5, $esame->voto, 1, 0, "C");
            $pdf->Cell(11, 4.5, $esame->inMedia ? "X" : "", 1, 0, "C");
            if ($this->laureandoInfo)
                $pdf->Cell(11, 4.5, $esame->isInformatico ? "X" : "", 1, 0, "C");
            $pdf->Ln();
        }
        $pdf->Ln(3);

        //dati calcolo voto
        $pdf->Rect($pdf->GetX(), $pdf->GetY(), $pdf->GetPageWidth() - 22, $this->laureandoInfo ? 33 : 22);
        $pdf->Cell(80, 5.5, "Media Pesata (M):", 0, 0);
        $pdf->Cell(0, 5.5, round($this->laureando->calcolaMediaPesata(), 3), 0, 1);
        $pdf->Cell(80, 5.5, "Crediti che fanno media (CFU):", 0, 0);
        $pdf->Cell(0, 5.5, $this->laureando->calcolaCfuMedia(), 0, 1);
        $pdf->Cell(80, 5.5, "Crediti curriculari conseguiti:", 0, 0);
        $pdf->Cell(0, 5.5, $this->laureando->calcolaCfuCurriculari()."/".$datiConfig->getCfuCorso($this->cdl), 0, 1);
        if ($this->laureandoInfo)
        {
            $pdf->Cell(80, 5.5, "Voto di tesi (T):", 0, 0);
            $pdf->Cell(0, 5.5, 0, 0, 1);
        }
        $pdf->Cell(80, 5.5, "Formula calcolo voto di laurea:", 0, 0);
        $pdf->Cell(0, 5.5, $datiConfig->getFormulaVoto($this->cdl), 0, 1);
        if ($this->laureandoInfo)
        {
            $pdf->Cell(80, 5.5, "Media pesata esami INF:", 0, 0);
            $pdf->Cell(0, 5.5, round($this->laureando->calcolaMediaEsamiInformatici(), 3), 0, 1);
        }
    }

    public function generaPdfLaureando()
    {
        $pdf = new FPDF();
        $this->generaProspettoLaureando($pdf);
        if(!file_exists(__DIR__."/../data/Prospetti/$this->cdl"))
            mkdir(__DIR__."/../data/Prospetti/$this->cdl");
        $pdf->Output(__DIR__."/../data/Prospetti/$this->cdl/" . $this->laureando->matricola . "_prospetto.pdf", "F");
    }
}