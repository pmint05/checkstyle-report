#let trang_bia(title, authors) = {
  rect(
    stroke: 5pt,
    inset: 7pt,
    rect(
      width: 100%,
      height: 100%,
      inset: 15pt,
      stroke: 1.7pt,
      [
        #align(center)[
          #text(12pt, strong("ĐẠI HỌC QUỐC GIA HÀ NỘI"))

          #text(12pt, strong("TRƯỜNG ĐẠI HỌC CÔNG NGHỆ"))
        ]
        #v(0.6cm)
        #align(center)[
          #image("/images/UET.png", width: 25%)
        ]
        #v(0.7cm)

        #align(center)[
          #set par(leading: 2em)
          #grid(
            inset: 5pt,
            columns: 2,
            ..authors
              .map(author => (
                [
                  #align(left)[
                    #text(12pt, strong(author.name))
                  ]
                ],
                [
                  #align(right)[
                    #text(12pt, (author.id))
                  ]
                ],
              ))
              .flatten(),
          )
        ]

        #v(.8cm)

        #align(center)[
          #set par(justify: false)
          #text(18pt, upper(strong(title)))
        ]

        #v(1.2cm)

        #align(center)[
          #set par(justify: false)
          #text(14pt, upper(strong("BÁO CÁO BÀI TẬP LỚN")))
        ]
        #align(center)[
          #set par(justify: false)
          #text(13pt, (strong("Bộ môn: Kiểm thử và đảm bảo chất lượng phần mềm")))
        ]


        #v(1fr)

        #align(center)[
          #text(12pt, strong("HÀ NỘI - 2025"))
        ]
      ],
    ),
  )
}
