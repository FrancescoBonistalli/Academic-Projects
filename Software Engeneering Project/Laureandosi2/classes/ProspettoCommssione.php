<?php
require_once "DatiConfigurazione.php";

class ProspettoCommssione
{
    public $prospettiLaureando;
    public $cdl;

    public function aggiungiProspetto($prospettoLaureando)
    {
            $this->prospettiLaureando[] = $prospettoLaureando;
            $this->cdl = $prospettoLaureando->laureando->cdl;
    }

    public function generaProspettoCommissione($pdf){
        $pdf->AddPage();
        $font = "Arial";
        $pdf->SetFont($font, "", 13);
        $pdf->Cell(0, 6, $this->cdl, 0, 1, "C");
        $pdf->Cell(0, 6, "LISTA LAUREANDI", 0, 1, "C");
        $pdf->Ln(3);

        $pdf->SetFontSize(11);
        $pdf->Cell(($pdf->GetPageWidth() - 22) / 4, 7, "COGNOME", 1, 0, "C");
        $pdf->Cell(($pdf->GetPageWidth() - 22) / 4, 7, "NOME", 1, 0, "C");
        $pdf->Cell(($pdf->GetPageWidth() - 22) / 4, 7, "CDL", 1, 0, "C");
        $pdf->Cell(($pdf->GetPageWidth() - 22) / 4, 7, "VOTO LAUREA", 1, 1, "C");

        $pdf->SetFontSize(10);
        foreach ($this->prospettiLaureando as $prospetto){
            $pdf->Cell(($pdf->GetPageWidth() - 22) / 4, 6, $prospetto->laureando->cognome, 1, 0, "C");
            $pdf->Cell(($pdf->GetPageWidth() - 22) / 4, 6, $prospetto->laureando->nome, 1, 0, "C");
            $pdf->Cell(($pdf->GetPageWidth() - 22) / 4, 6, "", 1, 0, "C");
            $pdf->Cell(($pdf->GetPageWidth() - 22) / 4, 6, "/110", 1, 1, "C");
        }

        foreach ($this->prospettiLaureando as $prospetto){
            $prospetto->generaProspettoLaureando($pdf);
            $this->inserisciTabellaVoti($pdf, $prospetto->laureando);
        }
    }

    public function inserisciTabellaVoti($pdf, $laureando)
    {
        $datiConfig = new DatiConfigurazione();
        $pdf->Ln(3);
        $pdf->SetFontSize(9);
        $pdf->Cell(($pdf->GetPageWidth() - 22), 5.5, "SIMULAZIONE DI VOTO DI LAUREA", 1, 1, "C");
        $formulaVoto = $datiConfig->getFormulaVoto($this->cdl);
        $formulaVoto = str_replace('CFU', "A", $formulaVoto);
        $formulaVoto = str_replace(["M", 'T', 'A', 'C'], ['$M', '$T', '$A', '$C'], $formulaVoto);

        $param = $datiConfig->getInfoParametro($this->cdl);
        $nCell = (int)(($param["max"] - $param["min"]) / $param["step"] + 1);

        $M = $laureando->calcolaMediaPesata();
        $A = $datiConfig->getCfuCorso($this->cdl);
        $C = 0;
        $T = 0;

        if($nCell <= 10)
        {
            $pdf->Cell(($pdf->GetPageWidth() - 22) / 2, 5.5, $param["param"] == "T" ? "VOTO TESI" : "VOTO COMMISSIONE", 1, 0, "C");
            $pdf->Cell(($pdf->GetPageWidth() - 22) / 2, 5.5, "VOTO DI LAUREA", 1, 1, "C");
            for ($i = $param["min"]; $i <= $param["max"]; $i += $param["step"]) {
                if($param["param"] == "T")
                    $T = $i;
                else
                    $C = $i;
//                $voto = 0;
                eval("\$voto = $formulaVoto;");

                $pdf->Cell(($pdf->GetPageWidth() - 22) / 2, 5.5, $i, 1, 0, "C");
                $pdf->Cell(($pdf->GetPageWidth() - 22) / 2, 5.5, round($voto, 3), 1, 1, "C");
            }
        }
        else    //tabella simulazione voto a due colonne
        {
            $pdf->Cell(($pdf->GetPageWidth() - 22) / 4, 5.5, $param["param"] == "T" ? "VOTO TESI" : "VOTO COMMISSIONE", 1, 0, "C");
            $pdf->Cell(($pdf->GetPageWidth() - 22) / 4, 5.5, "VOTO DI LAUREA", 1, 0, "C");
            $pdf->Cell(($pdf->GetPageWidth() - 22) / 4, 5.5, $param["param"] == "T" ? "VOTO TESI" : "VOTO COMMISSIONE", 1, 0, "C");
            $pdf->Cell(($pdf->GetPageWidth() - 22) / 4, 5.5, "VOTO DI LAUREA", 1, 1, "C");
            $even = 0;
            for ($i = 0; $i < $nCell; $i++) {
                if($even == 0)
                    $val = $param["min"] + $param["step"] * round($i / 2);
                else
                    $val = $param["min"] + $param["step"] * (ceil($nCell / 2) + ($i - 1) / 2);
                if($param["param"] == "T")
                    $T = $val;
                else
                    $C = $val;
//                $voto = 0;
                eval("\$voto = $formulaVoto;");

                $pdf->Cell(($pdf->GetPageWidth() - 22) / 4, 5.5, $val, 1, 0, "C");
                $pdf->Cell(($pdf->GetPageWidth() - 22) / 4, 5.5, round($voto, 3), 1, $even || ($i == $nCell - 1), "C");
                $even = $even == 0 ? 1 : 0;
            }
        }
        $pdf->Ln(3);
        $pdf->MultiCell(0, 4, "VOTO DI LAUREA FINALE: " . $datiConfig->getNotaFinale($this->cdl));
    }

    public function generaPdfCommissione()
    {
        $pdf = new FPDF();
        $this->generaProspettoCommissione($pdf);
        if(!file_exists(__DIR__."/../data/Prospetti/$this->cdl"))
            mkdir(__DIR__."/../data/Prospetti/$this->cdl");
        $pdf->Output(__DIR__."/../data/Prospetti/$this->cdl/prospetto_commissione.pdf", "F");
    }
}