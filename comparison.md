# Side by side comparison
## Mục đích
+ Checkstyle: Kiểm tra style - phong cách code, format - định dạng và convention - chuẩn
+ Sonarqube: Kiểm tra chất lượng toàn diện của code, bao gồm bug - lỗi, vulnerability - lỗ hỗng bảo mật, maintanability - khả năng bảo trì, coverage - độ bao phủ của bộ kiểm thử
## Phạm vi
+ Checkstyle: Kiểm tra từng file riêng biệt
+ Sonarqube: Kiểm tra toàn dự án như 1 thể thống nhất
## Tiêu chí
+ Checkstyle: Cách code được viết: naming convention, indentation, whitespaces, bracket placement, v.v...
+ Sonarqube: Cách code hoạt động là ưu tiên hàng đầu, cách code được viết là tiêu chí phụ: luồng dữ liệu, nguy cơ lỗi null pointer, leak tài nguyên, lỗi logic, phát hiện copy-paste, nợ kĩ thuật, v.v...
## Ngôn ngữ hỗ trợ
+ Checkstyle: Java
+ Sonarqube: Nhiều ngôn ngữ
## Cách dùng
+ Checkstyle: Chỉ cần 1 file cấu hình XML, dùng như 1 app CLI standalone, hoặc tích hợp vào IDE & build tool dưới dạng plugin
+ Sonarqube: Cần 1 server tập trung, dự án phải được cấu hình trên server
## Độ phức tạp
+ Checkstyle: Nhẹ và nhanh, trả về kết quả kiểm thử ngay lập tức
+ Sonarqube: Nặng và chậm, kết quả kiểm thử được lưu trữ lại
## Áp dụng thực tế
+ Checkstyle: Chạy mỗi lần build
+ Sonarqube: Chạy trong CICD pipeline hoặc mỗi pull request
## Chi phí
+ Checkstyle: Miễn phí và open-sourced
+ Sonarqube: Có bản miễn phí và bản trả phí nhiều tính năng hơn

# Giải thích kĩ hơn về Sonarqube
Khác với cách Checkstyle kiểm tra từng file riêng biệt (không xét quan hệ giữa các file src code khác nhau), Sonarqube phân tích toàn bộ dự án cùng 1 lúc.
Sonarqube có thể làm được như vậy nhờ kiến trúc Client - Server. Cụ thể hơn, Sonarscanner - client sẽ đọc nội dung của toàn bộ mọi file src code và gửi chúng cho server.
Server, sau khi đã thu thập đủ nội dung của tất cả các file src code, mới bắt đầu xử lí - break down src code để hiểu nó, biết src code gồm những thành phần nào và chúng tương tác với nhau như nào.
Từ đó, Sonarqube có thể thực thi các kiểm thử liên file phức tạp.

# Ưu điểm của Checkstyle
Dù không có các tính năng nâng cao như Sonarqube, Checkstyle vẫn có 1 vài ưu điểm rõ rệt: Miễn phí, nhẹ, nhanh và dễ sử dụng. Với thời gian chạy được tính bằng giây, trong thực tế, lập trình viên có thể chạy Checkstyle để đảm bảo code convention ở mọi lần build, và quản lí dự án có thể đặt Checkstyle ở những giai đoạn đầu trong CICD pipeline để loại bỏ sớm các bản code không tuân thủ theo quy tắc trước khi chúng đến được các giai đoạn tốn thời gian, tốn tài nguyên hơn.
