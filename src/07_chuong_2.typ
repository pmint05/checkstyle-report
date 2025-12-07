#import "/template.typ": *

#[
  #set heading(numbering: "Chương 1.1")
  = Tổng quan về Checkstyle <chuong2>
]

== Giới thiệu chung về Checkstyle

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

== Kiến trúc của công cụ

Checkstyle hoạt động dựa trên bộ quy tắc cấu hình (thường ở dạng XML), tiêu biểu như Sun Code Conventions và Google Java Style.

Cấu trúc chính của Checkstyle:
- *File Set Checks:* Các module nhận tập hợp file đầu vào (.java) và kiểm tra phát hiện vi phạm (module quan trọng nhất: *TreeWalker*).  
- *Filters:* Lọc các sự kiện kiểm tra (audit events).  
- *Audit Listeners:* Báo cáo kết quả kiểm tra.

== Nguyên tắc hoạt động

1. Người dùng cung cấp mã nguồn và file cấu hình.  
2. Checkstyle phân tích mã nguồn thành cây cú pháp (AST).  
3. Mỗi *check* được gọi khi TreeWalker duyệt qua các node tương ứng.  
4. Khi phát hiện vi phạm, Checkstyle ghi lại lỗi.  
5. Cuối cùng công cụ xuất báo cáo cho lập trình viên hoặc đưa vào quy trình CI/CD.

#pagebreak()
