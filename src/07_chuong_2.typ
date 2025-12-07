#import "/template.typ": *

#[
  #set heading(numbering: "Chương 1.1")
  = Tổng quan về Checkstyle <chuong2>
]

== Giới thiệu chung

*Checkstyle* là một công cụ phân tích mã tĩnh mã nguồn mở, được phát triển và thiết kế chuyên biệt cho ngôn ngữ Java. Công cụ này giúp lập trình viên viết mã Java tuân thủ tiêu chuẩn mã hóa trong phát triển phần mềm.

Checkstyle có thể hoạt động trên nhiều nền tảng như Windows, macOS, Linux/Unix.  
Ngôn ngữ phát triển chính: Java.

*Mục đích sử dụng:*
- *Thực thi tiêu chuẩn code:* Giúp lập trình viên viết mã Java tuân thủ theo các bộ quy tắc, ví dụ như Google Java Style hoặc Sun Code Conventions.  
- *Tự động hóa kiểm tra style:* Giảm bớt công việc kiểm tra thủ công, tránh lỗi do con người.  
- *Cải thiện chất lượng code:* Tăng tính nhất quán, dễ đọc, dễ bảo trì và tái sử dụng.  
- *Phát hiện sớm lỗi:* Báo cáo vi phạm về định dạng, cấu trúc và thiết kế ngay trong quá trình phát triển hoặc build.

*Tính năng hỗ trợ:*
- *Tích hợp CI/CD:* Tạo báo cáo vi phạm chi tiết, tích hợp cùng Jenkins, Maven, Gradle,…  
- *Tiêu chuẩn & quy tắc mã hóa:* Kiểm tra dựa trên quy ước được cấu hình trước; hỗ trợ quy tắc tùy chỉnh.  
- *Hỗ trợ plugin:* Tích hợp với Eclipse, IntelliJ IDEA, NetBeans; kiểm tra ngay khi lập trình viên viết code.

== Kiến trúc

=== Tổng quan

Overview, vẽ flow

=== Cây cấu hình

Một cấu hình (Configuration) của Checkstyle quy định những module nào sẽ được sử dụng và áp dụng lên các tệp mã nguồn Java. Các module này được tổ chức theo dạng cây, trong đó gốc của cây luôn là module Checker. Dưới Checker là các nhóm module chính:
- File Set Checks: Các module sử dụng để kiểm tra các vi phạm từ các file đầu vào.
- Filters: các module dùng để lọc các sự kiện kiểm tra (audit events), từ đó quyết định các yêu cầu có được chấp nhận hay bị loại bỏ.
- Audit Listeners: các module nhận và báo cáo các sự kiện sau khi đã được kiểm duyệt.

Khi sử dụng Checkstyle để tiến hành kiểm thử, người dùng cần chỉ định một tập tin XML, trong đó các phần tử thể hiện cấu trúc cây module của cấu hình, các module được bật, và các thuộc tính được thiết lập cho từng module.

Một ví dụ:
```
<module name="Checker">
  <module name="JavadocPackage"/>
  <module name="TreeWalker">
    <property name="tabWidth" value="4"/>
    <module name="AvoidStarImport"/>
    <module name="ConstantName"/>
    ...
  </module>
</module>
```

Một module trong file cấu hình XML được biểu diễn bằng thẻ `<module>` cùng trường `name`. Ở ví dụ trên, ...

Với mỗi module, Checkstyle sẽ load các class được chỉ định trong trường `name` của các thẻ `<module>`, theo các nguyên tắc sau:
- Load trực tiếp một class theo tên đầy đủ của nó (ví dụ `com.puppycrawl.tools.checkstyle.TreeWalker`), sử dụng khi ta cần tích hợp các module bên thứ ba.
- Load một class được Checkstyle quy định sẵn (ví dụ, khi ta muốn load class `com.puppycrawl.tools.checkstyle.checks.AvoidStarImport`, ta chỉ cần chỉ định trường `name` là `AvoidStarImport`, khi đó công cụ sẽ tự động tìm class theo các package `com.puppycrawl.tools.checkstyle`, `com.puppycrawl.tools.checkstyle.filters`, `com.puppycrawl.tools.checkstyle.checks` và các subpackage khác của các package này trong Checkstyle distribution)
- Áp dụng các quy tắc trên cho tên module sau khi thêm hậu tố "Check" (ví dụ tải lớp `com.puppycrawl.tools.checkstyle.checks.ConstantNameCheck` cho phần tử `<module name="ConstantName"/>`

Để điều chỉnh các hành vi của một module, ta có thể dùng thẻ `<properties>` với các trường `name` và `value`. Ví dụ, trong đoạn code trên, ta quy định độ rộng của một kí tự tab là 4 cho module `TreeWalker` cùng tất cả các module con của nó.

=== Cây cú pháp

Phần lớn các module sử dụng để kiểm tra là module con của module `TreeWalker`. Module này thực hiện việc chuyển các file mã nguồn Java thành một cây cú pháp (Abstract Syntax Tree), sau đó 

Một nút trên cây cú pháp được biểu diễn bằng lớp `DetailAST`, với cấu trúc như sau:
- abcbacb



== Luồng hoạt động

// Checkstyle hoạt động dựa trên bộ quy tắc cấu hình (thường ở dạng XML), tiêu biểu như Sun Code Conventions và Google Java Style.

// Cấu trúc chính của Checkstyle:
// - *File Set Checks:* Các module nhận tập hợp file đầu vào (.java) và kiểm tra phát hiện vi phạm (module quan trọng nhất: *TreeWalker*).  
// - *Filters:* Lọc các sự kiện kiểm tra (audit events).  
// - *Audit Listeners:* Báo cáo kết quả kiểm tra.

// == Nguyên tắc hoạt động

// 1. Người dùng cung cấp mã nguồn và file cấu hình.  
// 2. Checkstyle phân tích mã nguồn thành cây cú pháp (AST).  
// 3. Mỗi *check* được gọi khi TreeWalker duyệt qua các node tương ứng.  
// 4. Khi phát hiện vi phạm, Checkstyle ghi lại lỗi.  
// 5. Cuối cùng công cụ xuất báo cáo cho lập trình viên hoặc đưa vào quy trình CI/CD.

#pagebreak()
