#show: body => t-vuz(
$if(report-type)$
  report-type: "$report-type$",
$endif$
$if(title)$
  title: "$title$",
  $if(subtitle)$
    subtitle: "$subtitle$",
  $endif$
$endif$
$if(objednavatel)$
  objednavatel: (
    meno: "$objednavatel.meno$",
    adresa: (
      ulica: "$objednavatel.adresa.ulica$",
      mesto: "$objednavatel.adresa.mesto$",
      zip: "$objednavatel.adresa.zip$",
    ),
  ),
$endif$
$if(riesitel)$
  riesitel: (
    meno: "$riesitel.meno$",
    funkcia: "$riesitel.funkcia$",
    datum: "$riesitel.datum$",
  ),
$endif$
$if(riesitel2)$
  riesitel2: (
    meno: "$riesitel2.meno$",
    funkcia: "$riesitel2.funkcia$",
    datum: "$riesitel2.datum$",
  ),
$endif$
$if(riesitel3)$
  riesitel3: (
    meno: "$riesitel3.meno$",
    funkcia: "$riesitel3.funkcia$",
    datum: "$riesitel3.datum$",
  ),
$endif$
$if(riesitel4)$
  riesitel4: (
    meno: "$riesitel4.meno$",
    funkcia: "$riesitel4.funkcia$",
    datum: "$riesitel4.datum$",
  ),
$endif$
$if(riesitel5)$
  riesitel5: (
    meno: "$riesitel5.meno$",
    funkcia: "$riesitel5.funkcia$",
    datum: "$riesitel5.datum$",
  ),
$endif$
$if(preveril)$
  preveril: (
    meno: "$preveril.meno$",
    funkcia: "$preveril.funkcia$",
    datum: "$preveril.datum$",
  ),
$endif$
$if(schvalil)$
  schvalil: (
    meno: "$schvalil.meno$",
    funkcia: "$schvalil.funkcia$",
    datum: "$schvalil.datum$",
  ),
$endif$
$if(zakazka)$
  zakazka: (
    cislo: "$zakazka.cislo$",
  ),
$endif$
$if(objednavka)$
  objednavka: (
    cislo: "$objednavka.cislo$",
    datum: "$objednavka.datum$",
  ),
$endif$
$if(lang)$
  lang: "$lang$",
$endif$
$if(region)$
  region: "$region$",
$endif$
$if(margin)$
  margin: ($for(margin/pairs)$$margin.key$: $margin.value$,$endfor$),
$endif$
$if(papersize)$
  paper: "$papersize$",
$endif$
$if(mainfont)$
  font: ("$mainfont$",),
$endif$
$if(fontsize)$
  fontsize: $fontsize$,
$endif$
$if(section-numbering)$
  sectionnumbering: "$section-numbering$",
$endif$
$if(toc)$
  toc: $toc$,
$endif$
  body,
)
