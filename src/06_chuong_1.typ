#import "/template.typ" : *

#[
  #set heading(numbering: "Chương 1.1")
  = Giới thiệu <chuong1>
]
== Bối cảnh và lý do chọn đề tài

Trong thời đại phát triển nhanh chóng của công nghệ thông tin, chất lượng phần mềm là một yếu tố quyết định đến sự thành công của các dự án phát triển. Tuy nhiên, việc duy trì tiêu chuẩn mã hóa và đảm bảo mã nguồn tuân thủ các quy tắc thiết lập là một thách thức lớn, đặc biệt khi các đội phát triển có nhiều thành viên với các thói quen lập trình khác nhau.

=== Bối cảnh:

Ngôn ngữ lập trình Java là một trong những ngôn ngữ phổ biến nhất hiện nay, được sử dụng rộng rãi trong phát triển các ứng dụng doanh nghiệp, hệ thống Backend, và các dự án mã nguồn mở quy mô lớn. Tuy nhiên, Java cũng là ngôn ngữ có tính linh hoạt cao, cho phép các lập trình viên viết code theo nhiều cách khác nhau. Điều này dẫn đến:

- Mã nguồn thiếu tính nhất quán trong định dạng và cấu trúc.
- Khó khăn trong việc code review và bảo trì.
- Rủi ro cao trong việc phát sinh các lỗi tiềm ẩn liên quan đến định dạng và quy ước đặt tên.
- Tăng chi phí bảo trì và cập nhật phần mềm.

Để giải quyết những vấn đề trên, các công cụ phân tích mã tĩnh (static code analysis tools) như Checkstyle, SpotBugs, PMD, v.v. đã được phát triển. Trong đó, *Checkstyle* là một công cụ chuyên biệt dành riêng cho ngôn ngữ Java, giúp lập trình viên tự động hóa quá trình kiểm tra và thực thi các tiêu chuẩn mã hóa.

=== Lý do chọn đề tài:

Nhóm chọn Checkstyle làm chủ đề của báo cáo vì những lý do sau:

1. Checkstyle là công cụ thiết yếu trong quy trình kiểm thử phần mềm, giúp phát hiện các vi phạm về tiêu chuẩn mã hóa từ sớm, trước khi code được merge vào nhánh chính.

2. Công cụ này được sử dụng rộng rãi trong các dự án mã nguồn mở lớn như Apache, Eclipse, Maven, v.v. Việc hiểu rõ cách sử dụng Checkstyle sẽ giúp ích rất nhiều cho các lập trình viên trong quá trình phát triển chuyên nghiệp.

3. Checkstyle không chỉ giúp duy trì tính nhất quán của code, mà còn góp phần nâng cao chất lượng tổng thể của phần mềm, giảm thiểu lỗi tiềm ẩn, và cải thiện khả năng bảo trì.

4. Checkstyle có thể được tích hợp dễ dàng vào các hệ thống CI/CD như Jenkins, GitLab CI, GitHub Actions, v.v. để tự động kiểm tra mã nguồn trong mỗi lần commit hoặc pull request.

5. Checkstyle cho phép người dùng tùy chỉnh các quy tắc kiểm thử thông qua file cấu hình XML, phù hợp với quy chuẩn khác nhau của từng tổ chức hay dự án.

== Mục tiêu nghiên cứu

Trong báo cáo này, nhóm sẽ tìm hiểu về công cụ Checkstyle và cách ứng dụng vào thực tiễn.

1. Tìm hiểu chi tiết về công cụ Checkstyle, bao gồm kiến trúc, nguyên tắc hoạt động, và các tính năng chính.
2. Học cách cấu hình và sử dụng Checkstyle để kiểm tra mã nguồn Java.
3. Áp dụng Checkstyle vào phân tích một dự án Java thực tế và đưa ra các đề xuất khắc phục.
4. Rút ra những bài học và kinh nghiệm hữu ích về việc đảm bảo chất lượng phần mềm thông qua static code analysis.

== Phương pháp nghiên cứu

Để thực hiện đề tài này, nhóm đã áp dụng các phương pháp nghiên cứu sau:

- Nghiên cứu tài liệu: Tìm hiểu từ các tài liệu chính thức của Checkstyle, các bài viết công bố khoa học, và các blog về công cụ này.
- Phân tích thực nghiệm: Cài đặt và sử dụng Checkstyle trên một dự án Java thực tế (MegaBasterd) để kiểm tra mã nguồn và phân tích kết quả.
- So sánh và đánh giá: So sánh các bộ quy tắc khác nhau (Google Checks, Sun Checks), so sánh giữa Checkstyle và các công cụ phân tích mã tĩnh khác như PMD, SpotBugs để đưa ra nhận xét và đánh giá.

== Kiến thức liên quan

- Static Code Analysis (Phân tích mã tĩnh): Một kỹ thuật kiểm tra mã nguồn mà không cần chạy chương trình.
- Code Convention (Quy ước mã hóa): Các quy tắc thống nhất về cách trình bày code, định dạng, đặt tên, v.v.
- CI/CD (Continuous Integration/Continuous Deployment): Quy trình tự động hóa phát triển, kiểm thử, và triển khai phần mềm.
- AST (Abstract Syntax Tree): Cấu trúc dữ liệu biểu diễn cấu trúc cú pháp của mã nguồn dưới dạng cây.

== Cấu trúc của báo cáo
Phần còn lại của báo cáo này được trình bày như sau:
- @chuong2: Tổng quan về Checkstyle
- @chuong3: Áp dụng Checkstyle phân tích dự án thực tế
- @chuong4: Kết luận
#pagebreak()
