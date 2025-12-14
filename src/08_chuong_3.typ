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

#show figure: set block(breakable: true)

#[
  #set heading(numbering: "Chương 1.1")
  = Áp dụng Checkstyle phân tích dự án thực tế <chuong3>
]

== Lựa chọn dự án và thiết lập môi trường phân tích

=== Lựa chọn dự án

MegaBasterd là một trình quản lý tải xuống mã nguồn mở được viết bằng ngôn ngữ Java. Nó được thiết kế để đơn giản hóa quá trình tải xuống các tệp lớn từ dịch vụ lưu trữ đám mây Mega.nz.

Các tính năng chính của MegaBasterd bao gồm:
- Hỗ trợ tải xuống hàng loạt từ Mega.nz với tốc độ cao.
- Cung cấp một giao diện dễ sử dụng để quản lý các lần tải xuống.

Dự án có sẵn trên GitHub tại: https://github.com/tonikelope/megabasterd/

Lí do lựa chọn dự án MegaBasterd:
- Dự án mã nguồn mở, được viết bằng Java, phù hợp để phân tích bằng Checkstyle.
- Quy mô vừa phải, có đủ số lượng file và dòng code để phân tích.
- Được đóng góp bởi nhiều contributor với thói quen code khác nhau, giúp kiểm thử hiệu quả hơn.

=== Thiết lập môi trường

Có 3 cách để tích hợp Checkstyle vào quy trình phát triển phần mềm, dự án:
- Sử dụng Checkstyle thông qua command line.
- Tích hợp Checkstyle vào IDE (Eclipse, IntelliJ IDEA).
- Tích hợp Checkstyle vào hệ thống build tự động (Maven, Gradle).
Trong khuôn khổ báo cáo này, nhóm sẽ sử dụng cách thứ nhất -- Chạy Checkstyle thông qua command line để thực hiện phân tích mã nguồn dự án MegaBasterd.

Công cụ và phiên bản được  sử dụng:
- JDK: 25.0.1
- Checkstyle: 12.1.1
- IDE: IntelliJ IDEA Ultimate 2024.3
Các bước cài đặt Checkstyle:
+ Truy cập trang #link("https://github.com/checkstyle/checkstyle/releases")[Github Release của Checkstyle].
+ Tải về file JAR phiên bản mới nhất (tại thời điểm viết báo cáo là 12.1.1).
+ Đặt file JAR vào một thư mục cố định trên máy tính, ví dụ: `C:\checkstyle\checkstyle-12.1.1-all.jar`.

== Thực thi kiểm thử

Do dự án MegaBasterd là một dự án mã nguồn mở, được đóng góp bởi nhiều contributor với thói quen code khác nhau, nên nhóm quyết định sử dụng bộ quy tắc _Google Checks_ có sẵn như một tiêu chuẩn để phân tích mã nguồn dự án này.

Sau khi tải file cấu hình #link("https://raw.githubusercontent.com/checkstyle/checkstyle/refs/heads/master/src/main/resources/google_checks.xml")[`google_checks.xml`] và clone mã nguồn dự án MegaBasterd về máy, tiến hành chạy Checkstyle thông qua command line bằng lệnh:

#code-figure(
  "java -jar C:\checkstyle\checkstyle-12.1.1-all.jar \ \n-c C:\checkstyle\google_checks.xml \ \n-f xml \ \n-o C:\checkstyle\checkstyle-result.xml \ \nD:\CODE\Java\megabasterd\src",
  _label: "hello",
  caption: "Lệnh chạy Checkstyle qua command line",
)


Trong đó:
- `-c`: Chỉ định file cấu hình quy tắc kiểm thử.
- `-f xml`: Chỉ định định dạng đầu ra là XML.
- `-o`: Chỉ định file đầu ra để lưu kết quả kiểm thử.

Bên cạnh những tham số trên, Checkstyle CLI còn hỗ trợ nhiều tham số khác để tùy chỉnh quá trình kiểm thử, được mô tả chi tiết trong #link("https://checkstyle.org/cmdline.html")[tài liệu chính thức của Checkstyle].

Người dùng cũng có thể chạy Checkstyle trên một file cụ thể hoặc nhiều file cùng lúc thay vì toàn bộ thư mục, bằng cách thay thế đường dẫn thư mục `D:\CODE\Java\megabasterd\src` trong lệnh trên bằng đường dẫn file cần kiểm tra, ví dụ:

`D:\CODE\Java\megabasterd\src\...\AboutDialog.java`.

== Kết quả kiểm thử

Sau khi chạy, Checkstyle sẽ phân tích toàn bộ file có đuôi `.java`, `.properties` và `.xml` (do cấu hình `fileExtensions` của `google_checks`) trong thư mục `src` của dự án MegaBasterd, và ghi kết quả kiểm thử vào file #link("https://raw.githubusercontent.com/pmint05/checkstyle-report/refs/heads/main/out/checkstyle-result-full.xml")[`checkstyle-result.xml`].
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
  caption: "Kết quả phân tích mã nguồn dự án MegaBasterd",
) <fig:checkstyle-xml-result>

== Phân tích kết quả

Sau khi phân tích file `checkstyle-result.xml`, ta thấy rằng hầu hết các lỗi vi phạm thuộc dạng _Indentation_ (thụt lề) vì dự án MegaBasterd sử dụng 4 space cho mỗi cấp thụt lề, trong khi _Google Checks_ yêu cầu 2 space. Ngoài ra còn có một số lỗi khác như:
- _LineLength_: Độ dài dòng vượt quá 100 ký tự.
- _WhitespaceArround_: Thiếu khoảng trắng xung quanh các toán tử.
- _AvoidStarImport_: Sử dụng `import` dạng `.*`.
- _EmptyCatchBlock_: Khối `catch` trống.
- _SummaryJavadoc_: Thiếu JavaDoc tóm tắt cho class hoặc method
- Các lỗi tên biến, tên phương thức không tuân thủ quy ước đặt tên của Google.

Để tổng quát hơn, ta phân tích kèm với Plugin Checkstyle-IDEA trên IntelliJ IDEA:
#figure(
  image("/images/error-summary.png", width: 48%),
  caption: "Tổng quan các lỗi vi phạm trong dự án MegaBasterd",
)

Có thể thấy, trong dự án MegaBasterd có tổng cộng 23170 vi phạm trong 61/61 file mã nguồn. Trong đó, lỗi phổ biến nhất vẫn là _Indentation_ (17526 vi phạm trong 61/61 file), theo sau là _Linelength_ (2253 vi phạm trong 47/61 file) và _MemberName_ (685 vi phạm trong 35/61 file),...

Điều này cho thấy dự án MegaBasterd không sử dụng Code Convention của Google, dẫn đến việc vi phạm nhiều quy tắc kiểm thử của Google Checks.

== Đề xuất khắc phục

Để giảm thiểu các lỗi vi phạm được phát hiện bởi Checkstyle, có thể chỉnh sửa file cấu hình `google_checks.xml` để bỏ qua một số quy tắc không phù hợp với dự án, ví dụ như _Indentation_ hoặc _LineLength_ và giữ lại những quy tắc quan trọng. Hoặc ta có thể format lại mã nguồn dự án để tuân thủ các quy tắc của Google Checks.

Có 2 cách để format lại mã nguồn dự án:
- Sử dụng tính năng Reformat Code có sẵn trong IntelliJ IDEA kèm với file cấu hình #link("https://google.github.io/styleguide/intellij-java-google-style.xml")[Google Java Style].
- Sử dụng plugin #link("https://plugins.jetbrains.com/plugin/8527")[google-java-format] để tự động format mã nguồn theo chuẩn Google.

Nhóm sẽ thử áp dụng cách thứ nhất để format lại mã nguồn dự án MegaBasterd và chạy lại Checkstyle để kiểm tra kết quả.

#[
  #set enum(indent: 1em)
  #set par(justify: false)
  1. Tải file cấu hình #link("https://google.github.io/styleguide/intellij-java-google-style.xml")[intellij-java-google-style.xml].
  2. Trong IntelliJ IDEA, vào `File` $->$ `Settings` $->$ `Editor` $->$ `Code Style` $->$ `Java`.
  3. Nhấn vào biểu tượng bánh răng và chọn `Import Scheme` $->$ `IntelliJ IDEA code style XML`.
  #align(center)[
    #image("/images/config-GJS.png", width: 45%)

  ]
  4. Chọn file cấu hình đã tải về và nhấn `OK`.
  5. Mở dự án MegaBasterd và sử dụng tính năng Reformat Code để tự động định dạng lại mã nguồn theo chuẩn Google.
]

Sau khi format lại mã nguồn và chạy lại Checkstyle, thu được #link("https://raw.githubusercontent.com/pmint05/checkstyle-report/refs/heads/main/out/checkstyle-result-recheck.xml")[file kết quả]. Sử dụng Plugin Checkstyle-IDEA để tổng quan hóa kết quả:
#align(center)[
  #figure(
    image("/images/error-sumary-recheck.png", width: 48%),
    caption: "Tổng quan các lỗi vi phạm sau khi reformat mã nguồn",
  )
]

Có thể thấy số lượng vi phạm đã giảm đáng kể từ 23170 xuống còn 3640 vi phạm, trong đó lỗi _Indentation_ đã không còn xuất hiện nữa. Thay vào đó là các lỗi như _MemberName_ (685 vi phạm), _LocalVariableName_ (678 vi phạm), _MethodName_ (454 vi phạm),...

Kiểm tra nhanh file `APIException.java` vi phạm lỗi _MemberName_:
```java
...
public abstract class APIException extends Exception {

  protected Integer _code;
...
```
Tên biến `_code` không tuân thủ quy ước đặt tên của Google (sử dụng dấu gạch dưới ở đầu tên biến), có thể ý đồ của tác giả là để biểu thị đây là biến protected. Để khắc phục lỗi này, có thể đổi tên biến thành `code`. Hoặc sử dụng `annotation` báo cho Checkstyle bỏ qua kiểm tra:

```java
...
public abstract class APIException extends Exception {

  @SuppressWarnings("MemberName")
  protected Integer _code;
...
```

\

Tuy nhiên, phương án reformat code tự động có một số hạn chế. Nó không thể khắc phục tất cả các lỗi vi phạm, đặc biệt là những lỗi liên quan đến logic hoặc thiết kế của ứng dụng. Quá trình này có thể làm thay đổi ý đồ ban đầu của tác giả, dẫn đến các lỗi tiềm ẩn khác trong mã nguồn.

Ngoài ra, cần phải kiểm tra kỹ lưỡng sau khi reformat để đảm bảo không có lỗi mới phát sinh và mã nguồn vẫn hoạt động đúng như dự kiến. Đối với các dự án có quy mô lớn, phương án này cũng tốn kém về thời gian và công sức để thực hiện và xác minh.

Do đó, nhóm sẽ thử áp dụng phương án còn lại, nhưng thay vì sửa file cấu hình `google_checks.xml` gốc, nhóm sẽ tạo một file cấu hình mới dựa trên `google_checks.xml` và loại bỏ, chỉnh sửa các quy tắc không phù hợp với dự án MegaBasterd.

File cấu hình mà nhóm đã viết (#link("https://raw.githubusercontent.com/pmint05/checkstyle-report/refs/heads/main/out/custom_checks.xml")[`custom_checks.xml`]) có những thay đổi chính sau:
- Thụt lề 4 spaces cho mỗi cấp.
- Giới hạn độ dài dòng tăng lên 120 ký tự và bỏ qua kiểm tra độ dài dòng cho package, import, và các URL.
- Cho phép đặt tên biến, phương thức theo kiểu `camelCase` hoặc `snake_case`. 
- Cho phép sử dụng dấu gạch dưới ở đầu tên biến, phương thức để biểu thị phạm vi truy cập `protected` hoặc `private`.
- Giới hạn phạm vi loại file được kiểm tra chỉ còn các file `.java`.

Sử dụng file cấu hình tùy chỉnh này để chạy lại Checkstyle trên mã nguồn dự án MegaBasterd, thu được #link("https://raw.githubusercontent.com/pmint05/checkstyle-report/refs/heads/main/out/checkstyle-result-custom_checks.xml")[file kết quả]. Dưới đây là tổng quan các lỗi vi phạm:

#align(center)[
  #figure(
    image("/images/error-summary-custom_checks.png", width: 48%),
    caption: "Tổng quan các lỗi vi phạm sau khi áp dụng file cấu hình tùy chỉnh",
  )
]

So với kết quả ban đầu, số lượng vi phạm đã giảm đều ở tất cả các tiêu chí. Tổng số vi phạm chỉ còn 2247 vi phạm, trong đó lỗi _Indentation_ gần như không còn, _MemberName_ và _LocalVariableName_ đã giảm sâu.
Tuy nhiên, lỗi _LineLength_ và _MemberName_ vẫn còn tương đối nhiều, qua kiểm tra mã nguồn cho thấy, các vi phạm này chủ yếu là do dự án sử dụng thư viện các hàm liên quan đến _Crypto_ có tên phương thức được đặt theo định dạng `snake_case`, và các hàm thường nối tiếp nhau khá dài, do đó khó để tuân thủ quy tắc đặt tên.

Qua quá trình áp dụng Checkstyle để phân tích dự án MegaBasterd, nhóm đã thấy rõ tầm quan trọng và hiệu quả của công cụ này trong việc đảm bảo chất lượng mã nguồn. Bằng cách sử dụng các bộ quy tắc tiêu chuẩn hoặc tùy chỉnh, có thể phát hiện và theo dõi các vi phạm về phong cách code một cách tự động và hiệu quả. Nhóm nhận thấy Checkstyle không chỉ giúp xác định các vấn đề về định dạng và quy ước đặt tên, mà còn khuyến khích các đội phát triển duy trì tính nhất quán trong codebase. Mặc dù không phải tất cả các vi phạm đều cần sửa chữa ngay lập tức, nhưng việc có một cơ chế kiểm tra tự động giúp giảm bớt công sức code review thủ công và nâng cao hiệu suất trong quá trình phát triển.


#pagebreak()
