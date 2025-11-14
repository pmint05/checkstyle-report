#import "template.typ": *

#show: project.with(
  title: "Công cụ kiểm thử\nCheckStyle",
  authors: (
    (name: "Hoàng Hữu Đức", id: "23020046"),
    (name: "Nguyễn Nho Dương", id: "23020034"),
    (name: "Lê Minh Tuấn", id: "23020149"),
    (name: "Phạm Minh Thông", id: "23020164"),
  ),
) 

// #include "src/05_bang_thuat_ngu.typ"

#counter(page).update(1)
#set page(numbering: "1")
#set heading(numbering: "1.1.", supplement: "Chương")

#include "src/06_chuong_1.typ"
#include "src/07_chuong_2.typ"
#include "src/08_chuong_3.typ"
#include "src/09_chuong_4.typ"
#bibliography("ref.bib", style: "elsevier-vancouver")
