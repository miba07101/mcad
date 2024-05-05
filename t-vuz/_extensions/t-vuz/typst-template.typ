
// This is an example typst template (based on the default template that ships
// with Quarto). It defines a typst function named 'article' which provides
// various customization options. This function is called from the
// 'typst-show.typ' file (which maps Pandoc metadata function arguments)
//
// If you are creating or packaging a custom typst template you will likely
// want to replace this file and 'typst-show.typ' entirely. You can find
// documentation on creating typst templates and some examples here:
//   - https://typst.app/docs/tutorial/making-a-template/
//   - https://github.com/typst/templates

#import "@preview/tablex:0.0.8": tablex, rowspanx, colspanx

#let article(
  title: none,
  authors: none,
  preveril: none,
  date: none,
  abstract: none,
  cols: 1,
  margin: (x: 2.5cm, y: 3.5cm),
  paper: "a4",
  lang: "es",
  region: "SK",
  font: "Arial",
  fontsize: 12pt,
  sectionnumbering: "1.1",
  toc: false,
  doc,
) = {
  set page(
      paper: paper,
      margin: margin,
      numbering: "1",
      header: locate(
        loc => if [#loc.page()] == [1] {
        place(horizon + left,
        image("./_extensions/t-vuz/images/logo-vuz-ts.png", height: 90%),
        )
        place(horizon + right)[List:
        #counter(page).display(
            "1/1",
            both: true,
            )]




        // box(
        //     image("logo-vuz-ts.png", height: 90%)
        //    )
        // h(1fr)
        // counter(page).display(
        //     "1/1",
        //     both: true,
        //     )
        }
        else {
        [Z.č.: 222/2003/ME]
        h(1fr)
        [List: ]
        counter(page).display(
            "1/1",
            both: true,
            )
        line(length: 100%, stroke: (thickness: 1pt))
        }

  ),
    footer: locate(
        loc => if [#loc.page()] != [1] {
        line(length: 100%, stroke: (thickness: 1pt))
        align(center)[© VÚZ]
        }
        )
      )
      set par(justify: true)
      set text(
          lang: lang,
          region: region,
          font: font,
          size: fontsize)
      set heading(numbering: sectionnumbering)

      align(center)[#block(inset: 2em)[
#upper(text(weight: "medium", size: 2.5em)[technická správa])

#text(weight: "bold", size: 1.5em)[#title]
      ]]

        align(center)[#block(inset: 2em)[
          #grid(
              columns: 2,
              column-gutter: 1em,
              text(weight: "bold")[Objednávateľ:],
              align(left)[#text()[
              Zákazník\
              Adresa\
              meno
              ]

              ]
              )
        ]]

    block(inset: 2em)[
    #text(weight: "bold")[Evidenčné č. zákazky:] #h(0.5em) 222/2003/ME
    ]

    block(inset: 2em)[
    #text(weight: "bold")[Bratislava, #date]
    ]

    block(inset: 2em)[
    #text(weight: "bold")[Číslo a dátum objednávky:] #h(0.5em) #date
    ]


    // block(inset: 2em)[
    // #text(weight: "bold",
    //   ..authors.map(author => [#author.name])
    //   )
    // ]

// let pok = authors.map(author => [#author.name])
align(center+bottom)[
#tablex(
  columns: 5,
  rows: 18pt,
  /* --- header --- */
 rowspanx(6)[*Riešiteľ:*], [*Meno, Priezvisko, titul*], [*Funkcia*], [*Dátum*], [*Podpis*],
  /* -------------- */
  ..authors.map(author => [#author.name]), [výskumný pracovník], [30.05.2024], [],
  [], [], [], [], [],
  [], [], [], [], [],
  [], [], [], [], [],
  [], [*Preveril:*], [#preveril], [výskumný pracovník], [30.05.2024], [],
  [*Schválil:*], [Milan Baláž, Ing., PhD.], [výskumný pracovník], [30.05.2024], [],
)
]





        pagebreak()


  if authors != none {
    let count = authors.len()
    let ncols = calc.min(count, 3)
    grid(
      columns: (1fr,) * ncols,
      row-gutter: 1.5em,
      ..authors.map(author =>
          align(center)[
            #author.name \
            #author.affiliation \
            #author.email
          ]
      )
    )
  }


  if abstract != none {
    block(inset: 2em)[
    #text(weight: "semibold")[Abstract] #h(1em) #abstract
    ]
  }

  if toc {
    block(above: 0em, below: 2em)[
    #outline(
      title: auto,
      depth: none
    );
    ]
  }

  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }


}


