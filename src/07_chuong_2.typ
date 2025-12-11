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

Để kiểm tra mã nguồn, hầu hết các tiêu chí lựa chọn sử dụng cây cú pháp (Abstract Syntax Tree) được dựng trực tiếp từ mã nguồn Java gốc. Một nút trên cây cú pháp được biểu diễn bằng lớp `DetailAST`, với cấu trúc như sau:
- `getType()`: Loại của nút, ví dụ `CLASS_DEF` thể hiện định nghĩa của một class, hay `METHOD_DEF` thể hiện định nghĩa của một phương thức. Chi tiết về các loại được thể hiện trong lớp `TokenTypes`)
- `getText()`: Tên hoặc ký hiệu liên quan tới node.
- `getLineNo() / getColumnNo()`: Trả ra số dòng và vị trí trong dòng (đánh số từ 0), phục vụ cho việc tìm lỗi.
- Các thông tin liên quan đến cha/con trực tiếp của đỉnh hiện tại.

=== TreeWalker

Đầu tiên, lớp này tiến hành chuyển mã nguồn Java sang dạng cây sử dụng lớp `JavaParser`, trong đó sử dụng mã nguồn của ANTLR, một công cụ mã nguồn mở dùng để phân tích cú pháp.

Sau khi có được cấu trúc cây, tiến hành duyệt cây theo phương pháp DFS khử đệ quy. Khi bắt đầu thăm một nút, ta gọi hàm `visitToken()` của tất cả các check được định nghĩa một cách tuần tự để kiểm tra các điều kiện. Bên cạnh những điều kiện có thể kiểm tra trực tiếp, còn có những điều kiện cần phải biết hết thông tin của cây con để kiểm tra kết quả (ví dụ như độ dài phương thức, hay độ phủ của các biến), nên sau khi thăm toàn bộ cây con gốc $u$, ta cần phải gọi hàm `leaveToken()` của tất cả các check để đảm bảo tất cả điều kiện đã được kiểm tra.

Cuối cùng, các vi phạm được tổng hợp và gửi lại cho Checker, thành phần chịu trách nhiệm thu thập và xuất kết quả đầu ra.

=== Các loại kiểm tra khác

Ngoài ra, một số loại kiểm tra có thể không cần dùng đến cây cấu trúc mà có thể kiểm tra trực tiếp trên mã nguồn gốc (ví dụ như kiểm tra độ dài của phương thức, hay của file...). Các lớp thể hiện các tiêu chí kiểm tra như vậy được kế thừa từ lớp `AbstractFileSetCheck` (trừ lớp `TreeWalker`).

#pagebreak()
