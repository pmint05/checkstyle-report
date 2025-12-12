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

Kiến trúc của Checkstyle được thiết kế dựa trên sự kết hợp giữa mẫu thiết kế _Pipe and Filter_ và cơ chế _Event-Driven_. Hệ thống mang tính module hóa cao, cho phép mở rộng linh hoạt thông qua việc cấu hình thay vì phải biên dịch lại mã nguồn. Dưới đây là các thành phần cốt lõi tạo nên bộ khung của Checkstyle.

=== Cây cấu hình

Một cấu hình (Configuration) của Checkstyle quy định những module nào sẽ được sử dụng và áp dụng lên các tệp mã nguồn Java. Các module này được tổ chức theo dạng cây, trong đó gốc của cây luôn là module Checker. Dưới Checker là các nhóm module chính:
- File Set Checks: Các module sử dụng để kiểm tra các vi phạm từ các file đầu vào.
- Filters: các module dùng để lọc các sự kiện kiểm tra (audit events), từ đó quyết định các yêu cầu có được chấp nhận hay bị loại bỏ.
- Audit Listeners: các module nhận và báo cáo các sự kiện sau khi đã được kiểm duyệt.

Khi sử dụng Checkstyle để tiến hành kiểm thử, người dùng cần chỉ định một tập tin XML, trong đó các phần tử thể hiện cấu trúc cây module của cấu hình, các module được bật, và các thuộc tính được thiết lập cho từng module.

Một ví dụ:

#let example-config = "<module name=\"Checker\">
  <module name=\"JavadocPackage\"/>
  <module name=\"TreeWalker\">
    <property name=\"tabWidth\" value=\"4\"/>
    <module name=\"AvoidStarImport\"/>
    <module name=\"ConstantName\"/>
    ...
  </module>
</module>
"
#figure(
  [
    #set text(size: 10pt, font: "JetBrains Mono")
    #raw(
      example-config,
      lang: "xml",
      block: true,
    )
    #v(0.5cm)
  ],
  caption: "Ví dụ về cấu hình Checkstyle",
)

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

=== Checker - Thành phần điều phối trung tâm

`Checker` như là "container" trong hệ thống phân cấp xử lý. Đây là thành phần chịu trách nhiệm quản lý vòng đời của quá trình kiểm tra và duy trì danh sách các module con.

-   _Vai trò:_ Nhận yêu cầu kiểm tra, thiết lập môi trường và điều phối dòng dữ liệu tệp tin đến các bộ xử lý thích hợp. Nó không trực tiếp phân tích cú pháp mã nguồn mà ủy quyền cho các module con.
-   _Input:_ Danh sách các file mã nguồn và đối tượng cấu hình.
-   _Output:_ Các `AuditEvent` được đẩy tới các Listener.

=== FileSetCheck và TreeWalker

`FileSetCheck` là một giao diện trừu tượng đại diện cho bất kỳ module nào có khả năng xử lý một tập hợp các tệp tin. Trong bối cảnh kiểm tra mã nguồn Java, hiện thực quan trọng nhất của giao diện này là `TreeWalker`.

-   _TreeWalker:_ Là "trái tim" của quá trình phân tích cú pháp. Nó chịu trách nhiệm chuyển đổi nội dung văn bản thô thành cấu trúc dữ liệu có thể truy vấn được (AST). `TreeWalker` đóng vai trò là container chứa các quy tắc kiểm tra (`Check`).
-   _Input:_ Đối tượng `FileText` (đại diện cho nội dung tệp tin và bản đồ dòng/cột).
-   _Output:_ Cấu trúc cây `DetailAST` cung cấp cho các `Check` và các sự kiện vi phạm phát sinh trong quá trình duyệt cây.

=== Check

Đây là đơn vị logic nhỏ nhất và cụ thể nhất trong kiến trúc. Mỗi `Check` đại diện cho một quy tắc coding convention cụ thể (Ví dụ: `MethodLengthCheck` để kiểm tra độ dài hàm, `AvoidStarImport` để cấm import `*`).

-   _Vai trò:_ Thực hiện logic nghiệp vụ để xác định xem một đoạn mã có vi phạm quy chuẩn hay không. Các `Check` hoạt động thụ động, chỉ được kích hoạt khi `TreeWalker` duyệt đến một nút AST mà nó đã đăng ký quan tâm.
-   _Input:_ Nút hiện tại của cây `DetailAST` đang được duyệt.
-   _Output:_ Các vi phạm (nếu có) được đóng gói và gửi ngược lại `TreeWalker` để xử lý.

=== Filter

`Filter` đóng vai trò như các chốt kiểm soát (gatekeeper) trong luồng sự kiện.

-   _Vai trò:_ Quyết định xem một `AuditEvent` có nên được chuyển tới `AuditListener` hay không. Thành phần này cho phép người dùng bỏ qua các lỗi tại các tệp nhất định hoặc các dòng mã cụ thể (ví dụ: `SuppressionFilter` dùng để bỏ qua các cảnh báo).
-   _Input:_ `AuditEvent`.
-   _Output:_ `boolean` (chấp nhận hoặc từ chối sự kiện).

=== AuditListener

`AuditListener` chịu trách nhiệm lắng nghe kết quả từ quá trình kiểm tra.

-   _Vai trò:_ Chuyển đổi các sự kiện nội bộ của hệ thống thành định dạng đầu ra mà người dùng có thể đọc được. Ví dụ: `XMLLogger` xuất ra file XML cho các hệ thống CI/CD, `DefaultLogger` xuất ra Console.
-   _Input:_ Đối tượng `AuditEvent` (chứa thông tin về tệp, dòng, cột, và thông báo lỗi).
-   _Output:_ Báo cáo kết quả cuối cùng (Report).

== Nguyên tắc hoạt động

=== Tổng quan luồng hoạt động


Quá trình vận hành của Checkstyle có thể được khái quát hóa như một dây chuyền sản xuất (pipeline) xử lý dữ liệu tuần tự, bắt đầu từ việc khởi tạo môi trường thực thi dựa trên cấu hình người dùng và kết thúc bằng việc xuất báo cáo vi phạm. Trọng tâm của luồng xử lý này là sự phối hợp giữa thành phần điều phối trung tâm `Checker` và các thành phần phân tích chuyên biệt.

#figure(
  [
    #image("../images/flowchart.svg", width: 45%)
  ],
  caption: "Luồng hoạt động của Checkstyle",
)

Khi ứng dụng được khởi chạy, Checkstyle trước tiên sẽ xây dựng một hệ thống phân cấp các module (Module Hierarchy) thông qua cơ chế Reflection, biến các định nghĩa trong tệp cấu hình XML thành các đối tượng Java sống. Sau khi hệ thống đã sẵn sàng, `Checker` sẽ tiếp nhận danh sách các tệp mã nguồn cần kiểm tra. Tại đây, luồng dữ liệu được chia tách: các tệp tin lần lượt được đưa qua các Filters để loại bỏ những tệp không cần thiết, sau đó được chuyển tiếp đến các `FileSetChecks`.

Trong các bộ kiểm tra này, quá trình phân tích được chia làm hai nhánh chính: phân tích dựa trên văn bản thô (Raw Text Analysis) và phân tích dựa trên cây cú pháp trừu tượng (AST Analysis) thông qua `TreeWalker`. Các vi phạm (Violations) phát hiện được trong quá trình này sẽ được đóng gói thành các sự kiện và gửi ngược lại cho hệ thống lắng nghe (`AuditListeners`) để định dạng và ghi ra kết quả cuối cùng. Toàn bộ quy trình này đảm bảo tính toàn vẹn của dữ liệu và khả năng mở rộng, cho phép nhiều loại kiểm tra diễn ra song song hoặc tuần tự mà không gây xung đột trạng thái.

=== Chi tiết quá trình thực thi

Để hiểu rõ cơ chế vận hành, quá trình thực thi được phân rã thành các giai đoạn liên kết chặt chẽ dưới đây, đi sâu vào cách thức các thành phần cốt lõi xử lý dữ liệu.

+ _Khởi tạo và Xây dựng cấu trúc module_

  Mọi hoạt động của Checkstyle đều bắt đầu từ `ConfigurationLoader`. Thành phần này chịu trách nhiệm phân tích tệp cấu hình (file `.xml`) và chuyển đổi nó thành một cây đối tượng `Configuration`. Thay vì khởi tạo cứng các lớp, Checkstyle sử dụng mẫu thiết kế Factory kết hợp với Reflection. `PackageObjectFactory` sẽ nhận tên lớp (ví dụ: `"TreeWalker"`, `"AvoidStarImport"`) từ cấu hình, tìm kiếm trong classpath và khởi tạo các đối tượng tương ứng.

  Cấu trúc đối tượng được tạo ra phản ánh đúng cấu trúc phân cấp trong tệp XML: `Checker` nằm ở đỉnh, chứa các `FileSetCheck` (như `TreeWalker`) và `AuditListener`. Trong giai đoạn này, các phương thức setter của từng module được gọi tự động để nạp các thuộc tính (properties) tùy chỉnh của người dùng (như độ dài thụt dòng, quy tắc đặt tên) vào trong ngữ cảnh thực thi của từng đối tượng kiểm tra (Check).

+ _Điều phối kiểm tra mã nguồn_

  Sau khi khởi tạo, quyền điều khiển thuộc về `Checker`. Thành phần này không trực tiếp phân tích mã nguồn mà đóng vai trò là nhạc trưởng điều phối. `Checker` duy trì một danh sách các `FileSetCheck` và các `Filter`.

  Với mỗi tệp tin đầu vào, `Checker` trước tiên chuẩn bị một đối tượng `FileText`. Đối tượng này không chỉ chứa nội dung văn bản thuần túy mà còn xây dựng một bản đồ ánh xạ (mapping) giữa chỉ số ký tự và tọa độ dòng/cột. Điều này rất quan trọng để khi phát hiện lỗi, hệ thống có thể chỉ ra chính xác vị trí dòng và cột cho người dùng. Sau đó, `Checker` gọi phương thức `process()` của từng `FileSetCheck` đã đăng ký, chuyển giao đối tượng `FileText` để xử lý tiếp. Cơ chế này tách biệt hoàn toàn việc quản lý danh sách tệp khỏi logic kiểm tra cụ thể.

+ _Phân tích cú pháp và Duyệt cây_

  Đây là giai đoạn phức tạp và quan trọng nhất, nơi phần lớn các quy tắc (Checks) được thực thi. `TreeWalker`, một implemetation của `FileSetCheck`, chịu trách nhiệm chuyển đổi văn bản thô thành cấu trúc ngữ nghĩa để phân tích.

  Đầu tiên, `TreeWalker` sử dụng lớp `JavaParser` (được xây dựng dựa trên ANTLR) để phân tích `FileText`. Quá trình này bao gồm việc Tokenizer (Lexer) chia văn bản thành các token, sau đó Parser sắp xếp chúng thành một AST. Các nút trong cây này là một implementation của interface `DetailAST`, chứa thông tin về loại token, vị trí dòng/cột, và các liên kết đến nút cha, nút con đầu tiên (first child) và nút anh em kế tiếp (next sibling).

  Sau khi có được cấu trúc cây, `TreeWalker` tiến hành duyệt cây theo phương pháp DFS (Depth-First Search) khử đệ quy hoặc đệ quy tùy, đảm bảo mọi nút đều được ghé thăm. Tại mỗi nút của cây (tương ứng với một cấu trúc ngữ pháp như `METHOD_DEF`, `VARIABLE_DEF`), `TreeWalker` đóng vai trò như một bộ phát sự kiện (Event Dispatcher):

  1.  Nó kiểm tra xem loại token hiện tại có nằm trong danh sách quan tâm của bất kỳ `Check` nào không. Các `Check` khi khởi tạo phải đăng ký các token mình muốn xử lý thông qua hàm `getDefaultTokens()` hoặc `getRequiredTokens()`.
  2.  Nếu có, hàm `visitToken()` của các `Check` tương ứng sẽ được gọi tuần tự. Tại đây, các `Check` thực hiện logic kiểm tra cục bộ. Ví dụ, `MethodNameCheck` sẽ kiểm tra xem tên phương thức tại nút hiện tại có khớp với biểu thức chính quy (Regex) đã cấu hình hay không.
  3.  Đối với các điều kiện phức tạp cần thông tin tổng hợp từ cây con (như tính độ phức tạp Cyclomatic hay kiểm tra độ dài phương thức), logic kiểm tra thường chỉ thu thập dữ liệu tại `visitToken()`.
  4.  Sau khi toàn bộ cây con của nút hiện tại đã được duyệt xong, `TreeWalker` gọi hàm `leaveToken()`. Đây là thời điểm các `Check` tổng hợp dữ liệu thu được từ cây con để đưa ra quyết định cuối cùng.

  Cơ chế "Visit - Leave" này cho phép Checkstyle thực hiện phân tích ngữ cảnh (Context-aware analysis) mà không cần phải duyệt lại cây nhiều lần cho mỗi quy tắc, tối ưu hóa hiệu năng đáng kể.

+ _Thu thập và Xử lý vi phạm_

  Trong quá trình thực thi `visitToken` hoặc `leaveToken`, nếu một `Check` phát hiện vi phạm, nó sẽ không in trực tiếp ra màn hình. Thay vào đó, nó gọi phương thức `log()`. Phương thức này tạo ra một đối tượng `AuditEvent` chứa thông tin về tệp, vị trí, thông điệp lỗi và mức độ nghiêm trọng.

  Sự kiện này được đẩy ngược lên `TreeWalker`, sau đó chuyển tiếp về `Checker`. Tại đây, `Checker` sử dụng một danh sách các `Filter` để quyết định xem sự kiện này có nên được chấp nhận hay không (ví dụ: `SuppressionFilter` có thể loại bỏ lỗi dựa trên chú thích `@SuppressWarnings`).

  Nếu sự kiện vượt qua các bộ lọc, `Checker` sẽ gửi nó đến tất cả các `AuditListener` đã đăng ký. Các Listener này (như `DefaultLogger`, `XMLLogger`) chịu trách nhiệm định dạng dữ liệu sự kiện thành văn bản hoặc XML và ghi ra luồng đầu ra (OutputStream) hoặc tệp kết quả. Việc tách biệt khâu phát hiện lỗi (Detection) và khâu báo cáo (Reporting) tuân thủ nguyên lý Single Responsibility, cho phép Checkstyle dễ dàng tích hợp với các hệ thống CI/CD hoặc IDE khác nhau mà không cần sửa đổi logic cốt lõi.

#pagebreak()
