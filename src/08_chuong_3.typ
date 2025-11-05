#import "/template.typ": *
#import "@preview/algo:0.3.4": algo, code, comment, d, i

#let code-figure(code, lang: "typst", _label: none, caption: none) = {
  let code-style(content) = {
    set par(justify: false)
    set text(
      size: 13pt,
      font: "JetBrains Mono",
    )
    grid(
      columns: (100%, 100%),
      column-gutter: -100%,
      block(
        radius: 1em,
        fill: luma(246),
        width: 100%,
        inset: 1em,
        content,
      ),
    )
  }

  [
    #figure(
      box(
        align(left)[
          #code-style(
            raw(code, lang: lang, block: true),
          )
          #v(0.5cm)
        ],
      ),
      caption: caption,
    )
    #if (_label != none) { label(_label) }
  ]
}

#[
  #set heading(numbering: "Chương 1.1")
  = Áp dụng Checkstyle phân tích dự án thực tế <chuong3>
]

== Lựa chọn dự án và thiết lập môi trường phân tích

=== Lựa chọn dự án

// [TODO: Giới thiệu sơ lược về dự án, tại sao chọn?]

https://github.com/tonikelope/megabasterd/

=== Thiết lập môi trường

Có 3 cách để tích hợp Checkstyle vào quy trình phát triển phần mềm, dự án:
- Sử dụng Checkstyle thông qua command line.
- Tích hợp Checkstyle vào IDE (Eclipse, IntelliJ IDEA).
- Tích hợp Checkstyle vào hệ thống build tự động (Maven, Gradle).
Trong khuôn khổ báo cáo này, nhóm sẽ sử dụng cách thứ nhất -- Chạy Checkstyle thông qua command line để thực hiện phân tích mã nguồn dự án Megabasterd.

Công cụ và phiên bản được  sử dụng:
- JDK: 25.0.1
- Checkstyle: 12.1.1
- IDE: IntelliJ IDEA Ultimate 2024.3
Các bước cài đặt Checkstyle:
+ Truy cập trang #link("https://github.com/checkstyle/checkstyle/releases")[Github Release của Checkstyle].
+ Tải về file JAR phiên bản mới nhất (tại thời điểm viết báo cáo là 12.1.1).
+ Đặt file JAR vào một thư mục cố định trên máy tính, ví dụ: `C:\checkstyle\checkstyle-12.1.1-all.jar`.

== Cấu hình và thực thi kiểm thử
=== Cấu hình quy tắc kiểm thử

Trên trang Github chính thức của Checkstyle có cung cấp sẵn 2 bộ quy tắc kiểm thử phổ biến là #link("https://raw.githubusercontent.com/checkstyle/checkstyle/refs/heads/master/src/main/resources/google_checks.xml")[Google Checks] và #link("https://raw.githubusercontent.com/checkstyle/checkstyle/refs/heads/master/src/main/resources/sun_checks.xml")[Sun Checks].

// https://raw.githubusercontent.com/checkstyle/checkstyle/refs/heads/master/src/main/resources/sun_checks.xml
// https://raw.githubusercontent.com/checkstyle/checkstyle/refs/heads/master/src/main/resources/google_checks.xml
// https://raw.githubusercontent.com/checkstyle/checkstyle/refs/heads/master/config/checkstyle-checks.xml


#[
  #set par(justify: false, leading: 0.4em)
  #figure(
    [
      #set text(size: 11pt)
      #table(
        columns: (25%, 1fr, 1fr),
        align: (left, left + horizon, left + horizon),
        table.header([*Tiêu chí*], [*Google Checks*], [*Sun Checks*]),
        [Mục tiêu thiết kế],
        [Kế thừa có sửa đổi từ Google Java Style Guide, tập trung và tính nhất quán giữa các dự án lớn và code review dễ dàng, có nhiều quy tắc hiện đại và chi tiết hơn],
        [Tuân thủ code conventions cổ điển của Sun Microsystems (Oracle), nghiêm ngặt hơn trong việc kiểm tra cú pháp và đề cao tính dễ đọc, phù hợp cho các doanh nghiệp truyền thống],

        [Mức độ nghiêm trọng của các vi phạm (Severity)],
        [Warning, phù hợp trong giai đoạn phát triển dần],
        [Error, vi phạm có thể khiến build thất bại],

        [Các quy tắc tổng quát],
        [
          -- Độ dài dòng: 100 ký tự.\
          -- Thụt lề: 2 dấu cách (không sử dụng tab).\
          -- Bắt buộc có `{}` kể cả với khối lệnh đơn.\
          -- `{` phải đặt ở cuối dòng khai báo.\
        ],
        [
          -- Độ dài dòng: 80 ký tự.\
          -- Thụt lề: Sử dụng dấu cách, không có yêu cầu về độ dài.\
          -- Có thể bỏ `{}` với khối lệnh đơn.\
          -- `{` phải đặt ở dòng mới.\
        ],

        [
          Quy ước đặt tên
        ],
        [
          Dùng nhiều regex phức tạp hơn, chia rõ cho package, class, method, parameter, variable, generic type
        ],
        [
          Có quy tắc đặt tên tổng quát hơn, ít chi tiết hơn, cho phép mở rộng hơn
        ],

        [
          JavaDoc
        ],
        [
          Không bắt buộc JavaDoc cho tất cả method\
        ],
        [
          Yêu cầu JavaDoc cho public method và class\
        ],
      ),
    ],
    caption: "So sánh giữa Google Checks và Sun Checks",
  )
]

Từ bảng so sánh trên, có thể thấy _Google Checks_ linh hoạt, hiện đại và phù hợp với các dự án mã nguồn mở hơn, trong khi _Sun Checks_ nghiêm ngặt và phù hợp với các doanh nghiệp truyền thống hơn.


Bên cạnh 2 bộ quy tắc có sẵn, người dùng có thể tự định nghĩa các quy tắc riêng thông qua file XML cấu hình. Cú pháp của file cấu hình XML được mô tả chi tiết trong #link("https://checkstyle.org/config.html")[tài liệu chính thức của Checkstyle].

Một file cấu hình XML bao gồm các `module` (quy tắc kiểm thử) được tổ chức theo cấu trúc cây, trong đó mỗi `module` có thể chứa các `property` (thuộc tính) để tùy chỉnh hành vi của quy tắc đó, và có thể lồng các `module` con bên trong để tạo thành các nhóm quy tắc phức tạp hơn. 

Mỗi `module` được phân biệt với nhau bằng trường `name` hoặc `property` có `name` là `id`. 

Các `property` thường có 2 trường chính là `name` (tên thuộc tính) và `value` (giá trị thuộc tính).

#let example = read("/code/config.example.xml")

#figure(
  box(
    align(left)[
      #grid(
        columns: (100%, 100%),
        column-gutter: -100%,
        block(
          radius: 1em,
          fill: luma(246),
          width: 100%,
          inset: 1em,
        )[
          #set text(size: 10pt, font: "JetBrains Mono")
          #raw(example, lang: "xml", block: true)

        ],
      )
      #v(0.5cm)
    ],
  ),
  caption: "Ví dụ về file cấu hình Checkstyle XML",
) <fig:config-xml-example>

Do dự án Megabasterd là một dự án mã nguồn mở, nhóm quyết định sử dụng bộ quy tắc _Google Checks_ để phân tích mã nguồn dự án này.

=== Thực thi kiểm thử
Sau khi tải file cấu hình `google_checks.xml` và clone dự án Megabasterd về máy, tiến hành chạy Checkstyle thông qua command line bằng lệnh:

#code-figure(
  "java -jar C:\checkstyle\checkstyle-12.1.1-all.jar \ \n-c C:\checkstyle\google_checks.xml \ \n-f xml \ \n-o C:\checkstyle\checkstyle-result.xml \ \nD:\CODE\Java\megabasterd\src",
  _label: "hello",
  caption: "Lệnh chạy Checkstyle qua command line",
)


Trong đó:
- `-c`: Chỉ định file cấu hình quy tắc kiểm thử.
- `-f xml`: Chỉ định định dạng đầu ra là XML.
- `-o`: Chỉ định file đầu ra để lưu kết quả kiểm thử.

Bên cạnh những tham số trên, Checkstyle CLI còn hỗ trợ nhiều tham số khác để tùy chỉnh quá trình kiểm thử, chi tiết xem tại #link("https://checkstyle.org/cmdline.html")[tài liệu chính thức của Checkstyle].

Người dùng cũng có thể chạy Checkstyle trên một file cụ thể thay vì toàn bộ thư mục, bằng cách thay thế đường dẫn thư mục `D:\CODE\Java\megabasterd\src` trong lệnh trên bằng đường dẫn file cần kiểm tra, ví dụ:

`D:\CODE\Java\megabasterd\src\...\AboutDialog.java`.

== Kết quả kiểm thử

Sau khi chạy, Checkstyle sẽ phân tích toàn bộ file có đuôi `.java`, `.properties` và `.xml` (do cấu hình `fileExtensions` của `google_checks`) trong thư mục `src` của dự án Megabasterd, và ghi kết quả kiểm thử vào file `checkstyle-result.xml` (#link("https://raw.githubusercontent.com/pmint05/checkstyle-report/refs/heads/main/out/checkstyle-result-full.xml")[nội dung file]).
Dưới đây là một phần của file kết quả sau khi thực thi kiểm thử:

#let result = read("/out/checkstyle-result.xml")

#figure(
  box(
    align(left)[
      #grid(
        columns: (100%, 100%),
        column-gutter: -100%,
        block(
          radius: 1em,
          fill: luma(246),
          width: 100%,
          inset: 1em,
        )[
          #set text(size: 10pt, font: "JetBrains Mono")
          #raw(result, lang: "xml", block: true)

        ],
      )
      #v(0.5cm)
    ],
  ),
  caption: "Kết quả phân tích mã nguồn dự án Megabasterd",
) <fig:checkstyle-xml-result>

== Phân tích kết quả

Sau khi phân tích file `checkstyle-result.xml`, có thể thấy hầu hết các lỗi vi phạm thuộc dạng _Indentation_ (thụt lề) vì dự án Megabasterd sử dụng 4 space cho mỗi cấp thụt lề, trong khi _Google Checks_ yêu cầu 2 space. Ngoài ra còn có một số lỗi khác như:
- _LineLength_: Độ dài dòng vượt quá 100 ký tự.
- _WhitespaceArround_: Thiếu khoảng trắng xung quanh các toán tử.
- _AvoidStarImport_: Sử dụng `import` dạng `.*`.
- _EmptyCatchBlock_: Khối `catch` trống.
- _SummaryJavadoc_: Thiếu JavaDoc tóm tắt cho class hoặc method
- Các lỗi tên biến, tên phương thức không tuân thủ quy ước đặt tên của Google.



#pagebreak()
