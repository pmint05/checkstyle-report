#{
  show heading: none
  heading(numbering: none)[Lời cam đoan]
}
#align(center, text(16pt, strong("LỜI CAM ĐOAN")))

#v(1em)

#lorem(100)

#v(0.5em)

#let td = datetime.today()

#align(right, [
  #rect(
    stroke: none,
    inset: 2em,
    [
      #align(center, [
        Hà Nội, ngày #td.day() tháng #td.month() năm #td.year()
        \ \
        Sinh viên
        \ \ \ \ \
        Hoàng Hữu Đức       ])
    ],
  )

])

#pagebreak()
