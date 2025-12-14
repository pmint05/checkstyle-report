#import "/template.typ": *

#[
  #set heading(numbering: "Chương 1.1")
  = Tổng quan về Checkstyle <chuong2>
]

== Giới thiệu chung

*Checkstyle* là một công cụ phân tích mã nguồn tĩnh, được phát triển và thiết kế chuyên biệt cho ngôn ngữ Java. Công cụ này hỗ trợ lập trình viên Java tuân thủ các tiêu chuẩn mã nguồn nhất định, góp phần nâng cao chất lượng và tính chuyên nghiệp của dự án. Checkstyle có khả năng hoạt động trên nhiều nền tảng như Windows, macOS và Linux/Unix, đồng thời được phát triển hoàn toàn bằng ngôn ngữ Java.

Mục đích chính của Checkstyle là kiểm tra mã nguồn phù hợp với các bộ quy tắc một cách tự động, từ đó giảm thiểu công sức kiểm tra thủ công và hạn chế các lỗi do con người gây ra. Thông qua việc đảm bảo tính nhất quán trong mã nguồn, Checkstyle giúp cải thiện khả năng đọc, bảo trì và tái sử dụng code, đồng thời phát hiện sớm các vi phạm liên quan đến định dạng, cấu trúc và thiết kế ngay trong quá trình phát triển dự án.

Bên cạnh đó, Checkstyle còn hỗ trợ nhiều tính năng hữu ích như tích hợp vào quy trình CI/CD để tạo báo cáo vi phạm chi tiết và kết hợp với các công cụ như Jenkins, Maven hay Gradle. Công cụ cho phép kiểm tra mã nguồn dựa trên các quy tắc được cấu hình sẵn (Google Java Style hoặc Sun Code Conventions) hoặc các quy tắc tùy chỉnh theo nhu cầu của dự án. Ngoài ra, Checkstyle có thể được tích hợp dưới dạng plugin trong các IDE phổ biến như Eclipse, IntelliJ IDEA và NetBeans, giúp lập trình viên phát hiện vi phạm ngay trong quá trình lập trình.

Như vậy, nhờ tính tiện dụng, khả năng tích hợp linh hoạt và việc được phát triển dưới dạng dự án mã nguồn mở, Checkstyle được xem là một lựa chọn khá tốt và phù hợp cho nhiều dự án phần mềm Java hiện nay.

// *Checkstyle* là một công cụ phân tích mã tĩnh mã nguồn mở, được phát triển và thiết kế chuyên biệt cho ngôn ngữ Java. Công cụ này giúp lập trình viên viết mã Java tuân thủ tiêu chuẩn mã hóa trong phát triển phần mềm.

// Checkstyle có thể hoạt động trên nhiều nền tảng như Windows, macOS, Linux/Unix.
// Ngôn ngữ phát triển chính: Java.

// *Mục đích sử dụng:*
// - *Thực thi tiêu chuẩn code:* Giúp lập trình viên viết mã Java tuân thủ theo các bộ quy tắc, ví dụ như Google Java Style hoặc Sun Code Conventions.
// - *Tự động hóa kiểm tra style:* Giảm bớt công việc kiểm tra thủ công, tránh lỗi do con người.
// - *Cải thiện chất lượng code:* Tăng tính nhất quán, dễ đọc, dễ bảo trì và tái sử dụng.
// - *Phát hiện sớm lỗi:* Báo cáo vi phạm về định dạng, cấu trúc và thiết kế ngay trong quá trình phát triển hoặc build.

// *Tính năng hỗ trợ:*
// - *Tích hợp CI/CD:* Tạo báo cáo vi phạm chi tiết, tích hợp cùng Jenkins, Maven, Gradle,…
// - *Tiêu chuẩn & quy tắc mã hóa:* Kiểm tra dựa trên quy ước được cấu hình trước; hỗ trợ quy tắc tùy chỉnh.
// - *Hỗ trợ plugin:* Tích hợp với Eclipse, IntelliJ IDEA, NetBeans; kiểm tra ngay khi lập trình viên viết code.

== Kiến trúc

Kiến trúc của Checkstyle được thiết kế dựa trên sự kết hợp giữa mẫu thiết kế _Pipe and Filter_ và cơ chế _Event-Driven_.


#figure(
  image("../images/pipenfilter.svg", width: 75%),
  caption: "Mô hình Pipe & Filter",
)

#figure(
  image("../images/eventdriven.svg", width: 75%),
  caption: "Mô hình Event-Driven",
)

Hệ thống mang tính module hóa cao, cho phép mở rộng linh hoạt thông qua việc cấu hình thay vì phải biên dịch lại mã nguồn. Dưới đây là các thành phần cốt lõi tạo nên bộ khung của Checkstyle:


=== Cây cấu hình

Một cấu hình (Configuration) của Checkstyle quy định những module nào sẽ được sử dụng và áp dụng lên các tệp mã nguồn Java. Các module này được tổ chức theo dạng cây, trong đó gốc của cây luôn là module Checker. Dưới Checker là các nhóm module chính:
- File Set Checks: Các module sử dụng để kiểm tra các vi phạm từ các file đầu vào.
- Filters: Các module dùng để lọc các sự kiện kiểm tra (audit events), từ đó quyết định các yêu cầu có được chấp nhận hay bị loại bỏ.
- Audit Listeners: Các module nhận và báo cáo các sự kiện sau khi đã được kiểm duyệt.

Khi sử dụng Checkstyle để tiến hành kiểm thử, người dùng cần chỉ định một tập tin XML, trong đó các phần tử thể hiện cấu trúc cây module của cấu hình, các module được bật, và các thuộc tính được thiết lập cho từng module.

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

Một module trong file cấu hình XML được biểu diễn bằng thẻ `<module>` cùng trường `name`. Với mỗi module, Checkstyle sẽ load các class được chỉ định trong trường `name` của các thẻ `<module>`, theo các nguyên tắc sau:
- Load trực tiếp một class theo tên đầy đủ của nó (ví dụ `com.puppycrawl.tools.checkstyle.TreeWalker`), sử dụng khi ta cần tích hợp các module bên thứ ba.
- Load một class được Checkstyle quy định sẵn (ví dụ, khi ta muốn load class `com.puppycrawl.tools.checkstyle.checks.AvoidStarImport`, ta chỉ cần chỉ định trường `name` là `AvoidStarImport`, khi đó công cụ sẽ tự động tìm class theo các package `com.puppycrawl.tools.checkstyle`, `com.puppycrawl.tools.checkstyle.filters`, `com.puppycrawl.tools.checkstyle.checks` và các subpackage khác của các package này trong Checkstyle distribution)
- Áp dụng các quy tắc trên cho tên module sau khi thêm hậu tố "Check" (ví dụ tải lớp `com.puppycrawl.tools.checkstyle.checks.ConstantNameCheck` cho phần tử `<module name="ConstantName"/>`

Để điều chỉnh các hành vi của một module, ta có thể dùng thẻ `<properties>` với các trường `name` và `value`. Ví dụ, trong đoạn code trên, ta quy định độ rộng của một kí tự tab là 4 cho module `TreeWalker` cùng tất cả các module con của nó.

=== Cây cú pháp

Để kiểm tra mã nguồn, hầu hết các tiêu chí lựa chọn sử dụng cây cú pháp (AST - Abstract Syntax Tree) được dựng trực tiếp từ mã nguồn Java gốc.  Một nút trên cây cú pháp được biểu diễn bằng lớp `DetailAST`, tương ứng với một thành phần cú pháp cụ thể trong mã nguồn Java, ví dụ như class, method, biến, biểu thức... Cấu trúc của một nút trên cây có dạng:
- `getType()`: Loại của nút, ví dụ `CLASS_DEF` thể hiện định nghĩa của một class, hay `METHOD_DEF` thể hiện định nghĩa của một phương thức. Chi tiết về các loại được thể hiện trong lớp `TokenTypes`.
- `getText()`: Tên hoặc ký hiệu liên quan tới node.
- `getLineNo() / getColumnNo()`: Trả ra số dòng và vị trí trong dòng (đánh số từ 0), phục vụ cho việc tìm lỗi.
- Thông tin quan hệ cây: liên kết tới nút cha, nút con và các nút anh em trực tiếp.

Để làm việc với AST, công cụ cung cấp một cài đặt của interface `FileSetCheck` là `TreeWalker`. Lớp này đóng vai trò:
- Nhận vào một đối tượng `FileText`, đại diện cho nội dung văn bản thô của tệp nguồn.
- Phân tích cú pháp và chuyển mã nguồn thành cây `DetailAST`.
- Duyệt toàn bộ AST và phát sinh các sự kiện tương ứng với từng loại token dựa trên các `Check`.

Thay vì mỗi điều kiện kiểm tra phải tự duyệt cây cú pháp, Checkstyle hỗ trợ cơ chế lọc và phân phối sự kiện thông qua lớp `Check`. Cụ thể:
- Mỗi `Check` đăng ký các loại token mà nó quan tâm.
- Khi `TreeWalker` duyệt đến một `DetailAST` có type phù hợp, nó sẽ gọi các phương thức tương ứng của `Check`.
- Tại đây, `Check` sử dụng thông tin từ `DetailAST` để kiểm tra vi phạm và báo lỗi nếu cần.

=== Checker

`Checker` là thành phần chịu trách nhiệm quản lý vòng đời của quá trình kiểm tra và duy trì danh sách các module con. Cụ thể, thành phần này đóng vai trò nhận vào mã nguồn yêu cầu kiểm tra, thiết lập môi trường và điều phối dòng dữ liệu tệp tin đến các bộ xử lý thích hợp. Nó không trực tiếp phân tích cú pháp mã nguồn mà ủy quyền cho các module con.

=== FileSetCheck

Bên cạnh các kiểm tra dựa trên cây cú pháp, Checkstyle còn hỗ trợ các dạng kiểm tra không phụ thuộc vào cấu trúc cú pháp của mã nguồn. Các kiểm tra này được xây dựng dựa trên interface `FileSetCheck`, cho phép xử lý trực tiếp nội dung của tệp nguồn mà không cần thông qua cây DetailAST.

Đối với nhóm kiểm tra này, đầu vào chủ yếu là đối tượng `FileText`, đại diện cho toàn bộ nội dung văn bản của một tệp cùng với thông tin dòng và cột. Thay vì phân tích cú pháp, FileSetCheck làm việc trực tiếp trên văn bản thô của tệp, thông qua việc duyệt theo dòng hoặc toàn bộ nội dung để phát hiện các vi phạm dựa trên biểu thức chính quy, định dạng (ví dụ như số dòng), hoặc các quy ước ở mức tệp (ví dụ như `HeaderCheck` yêu cầu file phải có header, hay `FileLengthCheck` giới hạn số dòng của một file).

=== Filter Systems

`Filter` đóng vai trò như các chốt kiểm soát trong luồng sự kiện. Thành phần này sẽ quyết định xem một sự kiện lỗi `AuditEvent` có nên được chuyển tới `AuditListener` để thông báo ra ngoài hay không, từ đó cho phép người dùng bỏ qua một vài lỗi nhất định (ví dụ: `SuppressionFilter` dùng để bỏ qua các cảnh báo).
Checkstyle áp dụng chiến lược lọc hai lớp (Two-layer Filtering) can thiệp vào cả đầu vào và đầu ra của quy trình. Điều này đảm bảo tính hiệu quả về hiệu năng và sự linh hoạt trong quản lý kết quả.

- _Before Execution File Filter (Bộ lọc tệp trước thực thi)_

  Đây là chốt chặn đầu tiên trong luồng xử lý, hoạt động ngay sau khi `Checker` nhận danh sách tệp nhưng trước khi chuyển giao cho `FileSetCheck` hay `TreeWalker`. Thành phần này đóng vai trò tối ưu hóa hiệu năng bằng cách loại bỏ các tệp không phù hợp khỏi quy trình phân tích cú pháp tốn kém. Thành phần này thường được dùng để loại bỏ các tệp mã nguồn được sinh tự động (generated code), các thư mục tài nguyên, hoặc các tệp không phải Java dựa trên tên hoặc đường dẫn.
- _Audit Filter (Bộ lọc sự kiện)_

  Thành phần này hoạt động ở cuối quy trình logic, đóng vai trò như các chốt kiểm soát đối với luồng thông tin đầu ra bằng cách quyết định xem một sự kiện vi phạm (`AuditEvent`) đã được các `Check` phát hiện có nên được chuyển tới `AuditListener` để báo cáo hay không. Thành phần này cho phép người dùng cấu hình các ngoại lệ logic, ví dụ: bỏ qua lỗi dựa trên chú thích `@SuppressWarnings` trong mã nguồn (nhờ `SuppressionFilter`) hoặc lọc lỗi theo mức độ nghiêm trọng (Severity).

=== AuditListener

`AuditListener` chịu trách nhiệm lắng nghe kết quả từ quá trình kiểm tra. Từ một các tượng `AuditEvent` chứa thông tin về vị trí và nội dung của lỗi, thành phần này chuyển chúng của hệ thống thành định dạng đầu ra mà người dùng có thể đọc được. Ví dụ: `XMLLogger` xuất ra file XML cho các hệ thống CI/CD, `DefaultLogger` xuất ra Console.

== Nguyên tắc hoạt động

=== Tổng quan luồng hoạt động

Quá trình vận hành của Checkstyle có thể được khái quát hóa như một pipeline xử lý dữ liệu tuần tự, bắt đầu từ việc khởi tạo môi trường thực thi dựa trên cấu hình người dùng và kết thúc bằng việc xuất báo cáo vi phạm. Trọng tâm của luồng xử lý này là sự phối hợp giữa thành phần điều phối trung tâm `Checker` và các thành phần phân tích chuyên biệt.

#figure(
  [
    #image("../images/flowchart.svg", width: 36%)
  ],
  caption: "Luồng hoạt động của Checkstyle",
)

Khi ứng dụng được khởi chạy, Checkstyle trước tiên sẽ xây dựng một hệ thống phân cấp các module (Module Hierarchy) thông qua cơ chế Reflection, biến các định nghĩa trong tệp cấu hình XML thành các đối tượng Java. Sau khi hệ thống đã sẵn sàng, `Checker` sẽ tiếp nhận danh sách các tệp mã nguồn cần kiểm tra. Tại đây, luồng dữ liệu được chia tách: các tệp tin lần lượt được đưa qua các Filters để loại bỏ những tệp không cần thiết, sau đó được chuyển tiếp đến các `FileSetChecks`.

Trong các bộ kiểm tra này, quá trình phân tích được chia làm hai nhánh chính: phân tích dựa trên văn bản thô và phân tích dựa trên cây cú pháp trừu tượng thông qua `TreeWalker`. Các vi phạm phát hiện được trong quá trình này sẽ được đóng gói thành các sự kiện và gửi ngược lại cho hệ thống lắng nghe (`AuditListeners`) để định dạng và ghi ra kết quả cuối cùng.

=== Chi tiết quá trình thực thi

Quá trình thực thi được chia thành các giai đoạn sau đây:

+ _Khởi tạo và Xây dựng cấu trúc module_

  Mọi hoạt động của Checkstyle đều bắt đầu từ `ConfigurationLoader`. Thành phần này chịu trách nhiệm phân tích tệp cấu hình (file `.xml`) và chuyển đổi nó thành một cây đối tượng `Configuration`. Thay vì khởi tạo cứng các lớp, Checkstyle sử dụng mẫu thiết kế Factory kết hợp với Reflection. `PackageObjectFactory` sẽ nhận tên lớp (ví dụ: `"TreeWalker"`, `"AvoidStarImport"`) từ cấu hình, tìm kiếm trong classpath và khởi tạo các đối tượng tương ứng.

  Cấu trúc đối tượng được tạo ra phản ánh đúng cấu trúc phân cấp trong tệp XML: `Checker` nằm ở đỉnh, chứa các `FileSetCheck` (như `TreeWalker`) và `AuditListener`. Trong giai đoạn này, các phương thức setter của từng module được gọi tự động để nạp các thuộc tính (properties) tùy chỉnh của người dùng (như độ dài thụt dòng, quy tắc đặt tên) vào trong ngữ cảnh thực thi của từng đối tượng kiểm tra (Check).

+ _Sàng lọc và điều phối kiểm tra mã nguồn_

  Sau khi khởi tạo, quyền điều khiển thuộc về `Checker`. Thành phần này không trực tiếp phân tích mã nguồn mà đóng vai trò điều phối. `Checker` duy trì một danh sách các `FileSetCheck` và các `Filter`.

  Trước khi tiến hành kiểm tra mã nguồn, `Checker` thực hiện một bước tối ưu hóa quan trọng đầu tiên là lọc tệp trước thực thi (Before Execution File Filtering). Với mỗi đường dẫn tệp tin trong danh sách đầu vào, `Checker` sẽ đưa nó qua một chuỗi các `BeforeExecutionFileFilter`. Tại đây, các nguyên tắc loại trừ được áp dụng dựa trên tên tệp hoặc đường dẫn (ví dụ: bỏ qua các tệp trong thư mục `target`, tệp cấu hình không phải Java, hoặc mã nguồn được sinh tự động). Nếu một tệp vi phạm một trong các nguyên tắc đã quy định, nó sẽ bị loại bỏ ngay lập tức khỏi luồng xử lý.

  Sau khi lọc, với mỗi tệp đầu vào, `Checker` xử lý tiếp bằng cách khởi tạo đối tượng `FileText`. Đối tượng này không chỉ chứa nội dung văn bản thuần túy mà còn xây dựng một ánh xạ từ vị trí kí tự trong file đến dòng/cột tương ứng của nó trong mã nguồn gốc, giúp người dùng dễ dàng xác định vị trí lỗi. Sau đó, `Checker` gọi phương thức `process()` của từng `FileSetCheck` đã đăng ký, chuyển giao đối tượng `FileText` để xử lý tiếp. Cơ chế này tách biệt hoàn toàn việc quản lý danh sách tệp khỏi logic kiểm tra cụ thể.

+ _Phân tích cú pháp và Duyệt cây_

  Đây là giai đoạn phức tạp và quan trọng nhất, nơi phần lớn các quy tắc (Checks) được thực thi. `TreeWalker` chịu trách nhiệm chuyển đổi văn bản thô thành cấu trúc ngữ nghĩa để phân tích.

  Đầu tiên, `TreeWalker` sử dụng lớp `JavaParser` (được xây dựng dựa trên ANTLR) để phân tích `FileText`. Quá trình này bao gồm việc Tokenizer (Lexer) chia văn bản thành các token, sau đó Parser sắp xếp chúng thành một AST.

  Sau khi có được cấu trúc cây, `TreeWalker` tiến hành duyệt cây theo phương pháp DFS (Depth-First Search) khử đệ quy. Tại mỗi nút của cây (tương ứng với một cấu trúc ngữ pháp như `METHOD_DEF`, `VARIABLE_DEF`), `TreeWalker` đóng vai trò như một bộ phát sự kiện (Event Dispatcher):

  1. Nó kiểm tra xem loại token hiện tại có nằm trong danh sách quan tâm của bất kỳ `Check` nào không. Các `Check` khi khởi tạo phải đăng ký các token mình muốn xử lý thông qua hàm `getDefaultTokens()` hoặc `getRequiredTokens()`.
  2. Nếu có, hàm `visitToken()` của các `Check` tương ứng sẽ được gọi tuần tự. Tại đây, các `Check` thực hiện logic kiểm tra cục bộ. Ví dụ, `MethodNameCheck` sẽ kiểm tra xem tên phương thức tại nút hiện tại có khớp với biểu thức chính quy (Regex) đã cấu hình hay không. Các Check có thể duy trì trạng thái nội bộ để phân tích các quy tắc cần thông tin tổng hợp từ nhiều node (ví dụ trong `CyclomaticComplexityCheck` hoặc `MethodLengthCheck`, yêu cầu phải lưu các thông tin để có thể tổng hợp vì nó còn phụ thuộc vào thông tin của các nút con).
  3. Sau khi toàn bộ cây con của nút hiện tại đã được duyệt xong, `TreeWalker` gọi hàm `leaveToken()`. Đây là thời điểm các `Check` tổng hợp dữ liệu thu được từ cây con để đưa ra quyết định cuối cùng.

  Cơ chế này giúp Checkstyle phân tích mã nguồn mà không cần phải duyệt lại cây nhiều lần cho mỗi quy tắc, cũng như không cần phải duyệt lại toàn bộ quy tắc với mỗi nút của cây, từ đó giúp tối ưu hoá hiệu năng đáng kể.

+ _Thu thập và Xử lý vi phạm_

  Trong quá trình thực thi `visitToken` hoặc `leaveToken`, nếu một `Check` phát hiện vi phạm, nó sẽ không in trực tiếp ra màn hình. Thay vào đó, nó gọi phương thức `log()`. Phương thức này tạo ra một đối tượng `AuditEvent` chứa thông tin về tệp, vị trí, thông điệp lỗi và mức độ nghiêm trọng.

  Sự kiện này được đẩy ngược lên `TreeWalker`, sau đó chuyển tiếp về `Checker`. Tại đây, `Checker` sử dụng một danh sách các `Filter` để quyết định xem sự kiện này có nên được chấp nhận hay không (ví dụ: `SuppressionFilter` có thể loại bỏ lỗi dựa trên chú thích `@SuppressWarnings`).

  Nếu sự kiện vượt qua các bộ lọc, `Checker` sẽ gửi nó đến tất cả các `AuditListener` đã đăng ký. Các Listener này (như `DefaultLogger`, `XMLLogger`) chịu trách nhiệm định dạng dữ liệu sự kiện thành văn bản hoặc XML và ghi ra luồng đầu ra (OutputStream) hoặc tệp kết quả.

  Việc tách biệt khâu phát hiện lỗi và khâu báo cáo tuân thủ nguyên lý _Single Responsibility_. Nhờ kiến trúc này, Checkstyle có thể thay đổi hoặc mở rộng cơ chế báo cáo để tích hợp với CI/CD hoặc IDE mà không cần sửa đổi logic kiểm tra cốt lõi.

#pagebreak()
