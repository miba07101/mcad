// imports
#import "@preview/tablex:0.0.8": tablex, rowspanx, colspanx

#let t-vuz(
  report-type: none,
  title: none,
  subtitle: none,
  objednavatel: none,
  riesitel: none,
  riesitel1: none,
  riesitel2: none,
  riesitel3: none,
  riesitel4: none,
  riesitel5: none,
  preveril: none,
  schvalil: none,
  zakazka: none,
  objednavka: none,
  paper: "a4",
  cols: 1,
  margin: (x: 2.5cm, y: 3.5cm),
  lang: "sk",
  region: "SK",
  font: "Times New Roman",
  fontsize: 12pt,
  sectionnumbering: "1.1",
  toc: false,
  body,
) = {
  set page(
      paper: paper,
      margin: margin,
      header: locate(
        loc => if [#loc.page()] == [1] {
          place(horizon + left,
            image("./_extensions/t-vuz/images/logo-vuz-ts.png", height: 90%),
          )
          place(horizon + right)[List: #counter(page).display("1/1", both: true)]
          }
        else {
          [Z.č.: #zakazka.cislo]
          h(1fr)
          [List: #counter(page).display("1/1", both: true)]
          line(length: 100%, stroke: (thickness: 1pt))
        }
      ),
      footer: locate(
          loc => if [#loc.page()] != [1] {
            line(length: 100%, stroke: (thickness: 1pt))
            align(center)[© VÚZ]
          }
      ),
  )
  set par(justify: true)
  set text(
      lang: lang,
      region: region,
      font: font,
      size: fontsize)
  set heading(numbering: sectionnumbering)

// Text titulnej strany
  // typ-spravy
  align(center)[#block(inset: 3em)[
    #upper(text(weight: "bold", size: 2em)[#report-type])
  ]]
  // titulka
  align(center)[#block()[
    #text(weight: "bold", size: 1.5em)[#title]
  ]]
  // podnazov
  if subtitle != none {
    align(center)[
    #text(weight: "semibold", size: 1.25em)[#subtitle]
    ]
  }

  // objednavatel
  pad( left: 4em, top: 5em,
    grid(
      columns: (2),
      column-gutter: 0.5em,
      text(weight: "bold")[Objednávateľ:],
      align(left)[#text()[
        *#objednavatel.meno*
        #linebreak()
        #objednavatel.adresa.ulica
        #linebreak()
        #objednavatel.adresa.zip #objednavatel.adresa.mesto
      ]]
    )
  )

  // evidencne cislo zakazky
  pad( left: 4em, top: 2em,
    grid(
      columns: (2),
      column-gutter: 0.5em,
      text(weight: "bold")[Evidenčné č. zákazky:],
      align(left)[#text()[
        #zakazka.cislo
      ]]
    )
  )

  // bratislava dna
  pad( left: 4em, top: 1em,
      text(weight: "bold")[Bratislava, #schvalil.datum],
  )

  // cislo a datum objednavky
  pad( left: 1em, top: 2em,
    grid(
      columns: (2),
      column-gutter: 0.5em,
      text(weight: "bold")[Číslo a dátum objednávky:],
      align(left)[#text()[
        Objednávka č.  #objednavka.cislo zo dňa #objednavka.datum
      ]]
    )
  )

  // tabulka riesitelov
  align(center + bottom)[
  #table(
    columns: (1fr, auto, auto, 1fr, 1fr),
    rows: 18pt,
    align: left,
    // align:(col, row) =>
    // if (row == 0 and col in (0, 1, 2, 3, 4)) or (row in (6, 7) and col == 0) or (col == 3) {
    //   center
    // } else {
    //   left
    // },
    // fill: (col, row) =>
    // if (row == 0 and col in (0, 1, 2, 3, 4)) or (row in (6, 7) and col == 0) {
    //   luma(200)
    // } else {
    //   white
    // },

    /* --- header --- */
   [*Riešiteľ:*], [*Meno, Priezvisko, titul*], [*Funkcia*], [*Dátum*], [*Podpis*],
    /* -------------- */
    [], if riesitel != none {[#riesitel.meno]} else {[]}, if riesitel != none {[#riesitel.funkcia]} else {[]}, if riesitel != none {[#riesitel.datum]} else {[]}, [],
    [], if riesitel2 != none {[#riesitel2.meno]} else {[]}, if riesitel2 != none {[#riesitel2.funkcia]} else {[]}, if riesitel2 != none {[#riesitel2.datum]} else {[]}, [],
    [], if riesitel3 != none {[#riesitel3.meno]} else {[]}, if riesitel3 != none {[#riesitel3.funkcia]} else {[]}, if riesitel3 != none {[#riesitel3.datum]} else {[]}, [],
    [], if riesitel4 != none {[#riesitel4.meno]} else {[]}, if riesitel4 != none {[#riesitel4.funkcia]} else {[]}, if riesitel4 != none {[#riesitel4.datum]} else {[]}, [],
    [], if riesitel5 != none {[#riesitel5.meno]} else {[]}, if riesitel5 != none {[#riesitel5.funkcia]} else {[]}, if riesitel5 != none {[#riesitel5.datum]} else {[]}, [],
    [*Preveril:*], if preveril != none {[#preveril.meno]} else {[]}, if preveril != none {[#preveril.funkcia]} else {[]}, if preveril != none {[#preveril.datum]} else {[]}, [],
    [*Schválil:*], if schvalil != none {[#schvalil.meno]} else {[]}, if schvalil != none {[#schvalil.funkcia]} else {[]}, if schvalil != none {[#schvalil.datum]} else {[]}, [],
  )
  ]

  // upozornenie
  pad( left: 1em, top: 0.5em,
    text()[Upozornenie: Výsledky platia len pre objednaný predmet a rozsah.],
  )

  pagebreak()

  set text(
      lang: lang,
      region: region,
      font: font,
      size: fontsize)

  // Druha strana
  // Obsah
  if toc {
    block(above: 0em, below: 2em)[
    #outline(
      title: pad(bottom: 1em)[#text(size: 1.2em)[Obsah]],
      depth: 3,
      indent: auto,
    );
    ]
    pagebreak()
  }


  // Zvysne strany
  // to je uz to co pisem v qmd dokumente
  body

}


