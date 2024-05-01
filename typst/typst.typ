// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text( size: 0.92em )
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = [
  #line(start: (25%,0%), end: (75%,0%))
]

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

// Some quarto-specific definitions.

#show raw.where(block: true): block.with(
    fill: luma(230), 
    width: 100%, 
    inset: 8pt, 
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.amount
  }
  return block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == "string" {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == "content" {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

#show figure: it => {
  if type(it.kind) != "string" {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let old_title = old_title_block.body.body.children.at(2)

  // TODO use custom separator if available
  let new_title = if empty(old_title) {
    [#kind #it.counter.display()]
  } else {
    [#kind #it.counter.display(): #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block, 
    block_with_new_content(
      old_title_block.body, 
      old_title_block.body.body.children.at(0) +
      old_title_block.body.body.children.at(1) +
      new_title))

  block_with_new_content(old_callout,
    new_title_block +
    old_callout.body.children.at(1))
}

#show ref: it => locate(loc => {
  let target = query(it.target, loc).first()
  if it.at("supplement", default: none) == none {
    it
    return
  }

  let sup = it.supplement.text.matches(regex("^45127368-afa1-446a-820f-fc64c546b2c5%(.*)")).at(0, default: none)
  if sup != none {
    let parent_id = sup.captures.first()
    let parent_figure = query(label(parent_id), loc).first()
    let parent_location = parent_figure.location()

    let counters = numbering(
      parent_figure.at("numbering"), 
      ..parent_figure.at("counter").at(parent_location))
      
    let subcounter = numbering(
      target.at("numbering"),
      ..target.at("counter").at(target.location()))
    
    // NOTE there's a nonbreaking space in the block below
    link(target.location(), [#parent_figure.at("supplement") #counters#subcounter])
  } else {
    it
  }
})

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color, 
        width: 100%, 
        inset: 8pt)[#text(icon_color, weight: 900)[#icon] #title]) +
      block(
        inset: 1pt, 
        width: 100%, 
        block(fill: white, width: 100%, inset: 8pt, body)))
}



#let article(
  title: none,
  authors: none,
  date: none,
  abstract: none,
  cols: 1,
  margin: (x: 1.25in, y: 1.25in),
  paper: "us-letter",
  lang: "en",
  region: "US",
  font: (),
  fontsize: 11pt,
  sectionnumbering: none,
  toc: false,
  toc_title: none,
  toc_depth: none,
  doc,
) = {
  set page(
    paper: paper,
    margin: margin,
    numbering: "1",
  )
  set par(justify: true)
  set text(lang: lang,
           region: region,
           font: font,
           size: fontsize)
  set heading(numbering: sectionnumbering)

  if title != none {
    align(center)[#block(inset: 2em)[
      #text(weight: "bold", size: 1.5em)[#title]
    ]]
  }

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

  if date != none {
    align(center)[#block(inset: 1em)[
      #date
    ]]
  }

  if abstract != none {
    block(inset: 2em)[
    #text(weight: "semibold")[Abstract] #h(1em) #abstract
    ]
  }

  if toc {
    let title = if toc_title == none {
      auto
    } else {
      toc_title
    }
    block(above: 0em, below: 2em)[
    #outline(
      title: toc_title,
      depth: toc_depth
    );
    ]
  }

  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }
}
#show: doc => article(
  title: [TECHNICKÁ SPRÁVA],
  toc_title: [Table of contents],
  toc_depth: 3,
  cols: 1,
  doc,
)


= Posúdenie stavu materiálu jednotlivých tlakových častí kotla K5 v teplárni východ, Bratislava.
<posúdenie-stavu-materiálu-jednotlivých-tlakových-častí-kotla-k5-v-teplárni-východ-bratislava.>
= Príloha 4 - Informatívny pevnostný výpočet hrúbok stien tlakových častí kotla K5.
<príloha-4---informatívny-pevnostný-výpočet-hrúbok-stien-tlakových-častí-kotla-k5.>
#text(10pt)[
#align(center+bottom)[
#table(
  columns: 5,
  align: left,
  rows: (auto, 15pt),
  [*Riešiteľ:*], [*Meno, priezvisko, titul*], [*Funkcia*], [*Dátum*], [*Podpis*],
  [], [Milan Baláž, Ing. PhD.],[výskumný pracovník], [30.04.2024],[],
  [], [], [], [],[],
  [], [], [], [],[],
  [], [], [], [],[],
  [], [], [], [],[],
  [*Preveril:*], [Peter Pastier, Ing.], [vedúci odd. materiálov a laborátorií], [30.04.2024],[],
  [*Schválil:*], [Peter Brziak, Ing. PhD.], [riaditeľ odd. materiálov a laborátorií], [30.04.2024],[],
)
]
]
#strong[Upozornenie:] Výsledky platia len pre objednaný predmet a rozsah.

#pagebreak()
= Vstupné údaje
<vstupné-údaje>
#block[
#figure([
#block[
#figure(
align(center)[#table(
  columns: 6,
  align: (col, row) => (auto,auto,auto,auto,auto,auto,).at(col),
  inset: 6pt,
  [], [od], [t\_nom], [p\_op], [temp\_op], [material],
  [membranova-stena],
  [57],
  [5],
  [10],
  [315],
  [12022],
  [strop-ohniska],
  [57],
  [5],
  [10],
  [315],
  [12022],
  [strop-medzitahu],
  [57],
  [5],
  [10],
  [305],
  [12022],
  [zadna-stena-2-tah],
  [57],
  [5],
  [10],
  [260],
  [12022],
  [p-l-stena-2-tah],
  [57],
  [5],
  [10],
  [260],
  [12022],
  [vystupny-prehrievac],
  [57],
  [5],
  [10],
  [525],
  [15128],
  [salavy-prehrievac],
  [57],
  [5],
  [10],
  [480],
  [15128],
  [mreza],
  [57],
  [5],
  [10],
  [325],
  [12022],
)]
)

]
], caption: figure.caption(
position: top, 
[
Vstupné údaje
]), 
kind: "quarto-float-tbl", 
supplement: "Table", 
numbering: "1", 
)
<tbl-inputs>


]



