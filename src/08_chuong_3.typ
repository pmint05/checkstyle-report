#import "/template.typ": *
#import "@preview/algo:0.3.4": algo, code, comment, d, i

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
Trong khuôn khổ báo cáo này, nhóm sẽ sử dụng cách thứ hai -- tích hợp Checkstyle vào IDE để thực hiện phân tích mã nguồn dự án Megabasterd.

Công cụ và phiên bản được  sử dụng:
- IDE: IntelliJ IDEA Ultimate 2024.3
- SDK: OpenJDK 23.0.1
- Plugin: Checkstyle-IDEA 5.114.0
Các bước cài đặt Checkstyle-IDEA trên IntelliJ:
1. Mở IntelliJ IDEA, vào `File` $->$ `Settings` (hoặc `Preferences` trên macOS) $->$ `Plugins`.
#figure(
  image("/images/setup-step-1.png", width: 90%),
  caption: "Cài đặt plugin Checkstyle-IDEA trên IntelliJ IDEA",
)
2. Trong tab `Marketplace`, tìm kiếm "Checkstyle-IDEA", chọn plugin và nhấn `Install`.
#figure(
  image("/images/setup-step-2.png", width: 90%),
  caption: "Cài đặt plugin Checkstyle-IDEA trên IntelliJ IDEA",
)
3. Sau khi cài đặt xong, ấn "Restart IDE" để khởi động lại IntelliJ IDEA và hoàn tất quá trình cài đặt.
#figure(
  image("/images/setup-step-3.png", width: 90%),
  caption: "Cài đặt plugin Checkstyle-IDEA trên IntelliJ IDEA",
)

== Cấu hình và thực thi kiểm thử
=== Cấu hình quy tắc kiểm thử

Trước khi tiến hành kiểm thử, cần cấu hình Checkstyle-IDEA để sử dụng quy tắc kiểm thử phù hợp với dự án. Checkstyle cung cấp sẵn 2 bộ quy tắc: #link("https://raw.githubusercontent.com/checkstyle/checkstyle/refs/heads/master/src/main/resources/google_checks.xml")[Google Checks] và #link("https://raw.githubusercontent.com/checkstyle/checkstyle/refs/heads/master/src/main/resources/sun_checks.xml")[Sun Checks].

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


Bên cạnh 2 bộ quy tắc có sẵn, Checkstyle cũng cho phép người dùng tự định nghĩa các quy tắc riêng thông qua file XML cấu hình. Cú pháp của file cấu hình XML được mô tả chi tiết trong #link("https://checkstyle.org/config.html")[tài liệu chính thức của Checkstyle].

Một file cấu hình XML cơ bản gồm có:
// [TODO: Mô tả chi tiết cách cấu hình bằng file XML]


Do dự án Megabasterd là một dự án mã nguồn mở, nhóm quyết định sử dụng bộ quy tắc _Google Checks_ để phân tích mã nguồn dự án này.

Để cấu hình Checkstyle-IDEA sử dụng bộ quy tắc _Google Checks_, thực hiện các bước sau:
1. Mở IntelliJ IDEA, vào `File` $->$ `Settings` (hoặc `Preferences` trên macOS) $->$ `Tools` $->$ `Checkstyle`.
#figure(
  image("/images/config-step-1.png", width: 90%),
  caption: "Cấu hình Checkstyle-IDEA trên IntelliJ IDEA",
)
2. Tích chọn `Google Checks` $->$ ấn `Apply` $->$ `OK` để lưu cấu hình.
#figure(
  image("/images/config-step-2.png", width: 90%),
  caption: "Cấu hình Checkstyle-IDEA trên IntelliJ IDEA",
)

=== Thực thi kiểm thử
Checkstyle hỗ trợ tính năng real-time scan, do đó sau khi cấu hình xong, Checkstyle sẽ tự động phân tích mã nguồn của file đang đang mở trong IDE và hiển thị các vi phạm trong cửa sổ `Problems` của IntelliJ IDEA.

#figure(
  image("/images/real-time-scan.png", width: 90%),
  caption: "Checkstyle real-time scan trên IntelliJ IDEA",
)


== Kết quả kiểm thử
== Phân tích kết quả

#pagebreak()
