#import "/template.typ": *

#[
  #set heading(numbering: "Chương 1.1")
  = So sánh <chuong4>
]

== Đánh giá

Để thấy rõ hơn vị trí và vai trò của Checkstyle trong quy trình phát triển phần mềm, cần đặt công cụ này trong mối tương quan với các giải pháp phân tích mã nguồn phổ biến khác. Trong đó, SonarQube là một đại diện tiêu biểu nhờ khả năng phân tích chất lượng mã nguồn một cách toàn diện ở cấp độ dự án. Phần đánh giá dưới đây sẽ tập trung so sánh Checkstyle và SonarQube dựa trên các tiêu chí như mục đích sử dụng, phạm vi kiểm tra, cách thức triển khai và hiệu quả áp dụng trong thực tế, từ đó làm rõ ưu điểm, hạn chế cũng như bối cảnh phù hợp của từng công cụ.

#show figure: set block(breakable: true)

#figure(
  table(
    columns: 3,
    table.header[*Tiêu chí*][*Checkstyle*][*SonarQube*],
    align: (left, left, left),
    [Mục đích], [Chủ yếu kiểm tra phong cách và quy ước mã nguồn.], [Kiểm tra chất lượng toàn diện của code, bao gồm lỗi, lỗ hổng bảo mật, khả năng bảo trì, độ bao phủ của bộ kiểm thử.],
    [Phạm vi], [Kiểm tra từng file riêng biệt.], [Kiểm tra toàn dự án như một thể thống nhất.],
    [Đối tượng], [Cách code được viết: naming convention, indentation, whitespaces, bracket placement, ...], [Tập trung vào hành vi và chất lượng thực thi của mã nguồn; phong cách viết mã không phải trọng tâm chính.],
    [Ngôn ngữ hỗ trợ], [Java], [Nhiều ngôn ngữ],
    [Cách dùng], [Chỉ cần một file cấu hình XML, dùng như app CLI standalone, hoặc tích hợp vào IDE & build tool dưới dạng plugin.], [Cần server tập trung, dự án phải được cấu hình trên server.],
    [Độ phức tạp], [Nhẹ và nhanh, trả về kết quả kiểm thử ngay lập tức.], [Triển khai phức tạp hơn, yêu cầu hạ tầng server và thời gian phân tích dài hơn.],
    [Áp dụng thực tế], [Chạy mỗi lần build], [Chạy trong CI/CD pipeline hoặc mỗi pull request],
    [Chi phí], [Miễn phí và mã nguồn mở], [Có bản miễn phí và bản trả phí nhiều tính năng hơn]
  ),
  caption: [So sánh Checkstyle và SonarQube]
) <compare-existed-system>

Từ bảng so sánh trên, có thể thấy SonarQube là một công cụ mạnh mẽ hơn so với Checkstyle nhờ khả năng kiểm tra toàn diện của mình. Sở dĩ SonarQube có thể phân tích toàn bộ dự án là nhờ kiến trúc Client-Server. Cụ thể hơn, SonarScanner đóng vai trò client sẽ đọc nội dung của toàn bộ các file mã nguồn và gửi chúng cho server. Server, sau khi thu thập đầy đủ dữ liệu, sẽ tiến hành xử lý và phân tích toàn bộ mã nguồn nhằm hiểu rõ cấu trúc, thành phần và mối quan hệ giữa chúng. Từ đó, SonarQube có thể thực thi các kiểm thử liên file phức tạp.

Dù không có các tính năng nâng cao như SonarQube, Checkstyle vẫn có một vài ưu điểm rõ rệt: Miễn phí, nhẹ, nhanh và dễ sử dụng. Với thời gian chạy được tính bằng giây, trong thực tế, lập trình viên có thể chạy Checkstyle để đảm bảo code convention ở mọi lần build, và quản lí dự án có thể đặt Checkstyle ở những giai đoạn đầu trong CI/CD pipeline để loại bỏ sớm các bản code không tuân thủ theo quy tắc trước khi chúng đến được các giai đoạn tốn thời gian, tốn tài nguyên hơn. Vì vậy, Checkstyle vẫn có giá trị rất lớn trong quy trình phát triển phần mềm hiện nay.

== Kết luận

Tóm lại, Checkstyle là một công cụ phân tích mã tĩnh hiệu quả, tập trung vào việc đảm bảo mã nguồn Java tuân thủ các quy ước và tiêu chuẩn mã hóa đã được định nghĩa. Với cơ chế hoạt động đơn giản, cấu hình linh hoạt thông qua tệp XML và thời gian chạy nhanh, Checkstyle giúp lập trình viên phát hiện sớm các vi phạm về phong cách code ngay trong quá trình phát triển.

Nhờ đặc tính nhẹ, dễ tích hợp và là một dự án mã nguồn mở miễn phí, Checkstyle đặc biệt phù hợp để sử dụng thường xuyên trong quá trình build hoặc ở các giai đoạn đầu của CI/CD pipeline nhằm loại bỏ sớm các đoạn mã không tuân thủ quy tắc. Điều này góp phần nâng cao tính nhất quán, khả năng đọc hiểu và khả năng bảo trì của mã nguồn. Mặc dù không hướng tới việc phân tích logic hay hành vi thực thi của chương trình, Checkstyle vẫn giữ vai trò quan trọng trong quy trình phát triển phần mềm hiện đại như một công cụ kiểm soát chất lượng mã nguồn ở mức cơ bản nhưng thiết yếu.

#pagebreak()
