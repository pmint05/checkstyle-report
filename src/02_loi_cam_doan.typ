#{
  show heading: none
  heading(numbering: none)[Lời cam đoan]
}
#align(center, text(16pt, strong("LỜI CAM ĐOAN")))

#v(1em)

#[
  Chúng em xin cam đoan: Báo cáo này là kết quả của công việc nghiên cứu và thực hiện của nhóm. Những gì chúng em viết ra hoàn toàn trung thực, chính xác và không có sự sao chép từ các tài liệu, không sử dụng kết quả của người khác mà không trích dẫn cụ thể. Các dữ liệu, kết quả thực nghiệm, và phân tích được trình bày trong báo cáo đều là chính xác và thực tế, không được làm giả hoặc bao gồm bất kỳ thông tin sai lệch nào. Các tài liệu tham khảo được liệt kê đầy đủ và chính xác trong phần "tài liệu tham khảo" của báo cáo. Nếu vi phạm những điều trên, chúng em xin hoàn toàn chịu trách nhiệm về những hậu quả pháp lý liên quan theo quy định của Trường Đại học Công nghệ - ĐHQGHN.
]

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
