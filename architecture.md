# Tổng quan
## Cây cấu hình
+ Từ phần demo biết được để chạy app cần 1 file config XML
+ File config XML này được parse thành 1 cấu trúc dạng cây
+ Mỗi nút, hay module, được biểu diễn bằng 1 object `Configuration`, bao gồm các thuộc tính dưới dạng key-value và các nút con
<img width="1600" height="1200" alt="image" src="https://github.com/user-attachments/assets/a04cd830-c12c-45c9-84c8-5f8e0f56b9eb" />

## ModuleLoader
+ Tạo các object của các lớp quan trọng tại runtime từ tên của lớp đó
+ Sơ qua về các luật tạo object (fully qualified class name, class name, class name bỏ hậu tố `Check`)
+ Trong app, ModuleLoader để tạo các object từ thuộc tính `name` của các object `Configuration` đã nói ở trên
<img width="1600" height="1200" alt="image" src="https://github.com/user-attachments/assets/8eb9722f-777a-42cb-bd1a-0cb28f0fd086" />

## AbstractAutomaticBean
+ Lớp cha của phần lớn các lớp quan trọng
+ Cho phép tùy biến thêm luồng khởi tạo của `ModuleLoader`, VD: tự động tạo các lớp liên quan dựa trên cây cấu hình
```
 ModuleLoader      
     │             
     │             
┌────▼──────┐      
│           │      
└────┬──────┘      
     │             
     ▼             
 contextualize()   
     │             
     │             
     ▼             
 configure()       
     │             
     │             
     ▼             
 finishLocalSetup()
     │             
     │             
     ▼             
 setupChild()
```
+ Kết quả: Tùy biến được behavior của app bằng 1 file config XML

## Luồng tổng quan
+ Xác định các file cần kiểm tra
+ Tạo cây cấu hình từ file config XML
+ Tạo các object cần thiết từ cây cấu hình, Checkstyle yêu cầu module gốc là `Checker`
+ Chạy `Checker.process()`, `Checker` bao gồm các `FileSetCheck` tương ứng với các tiêu chí cần kiểm thử, việc kiểm thử bắt đầu bằng `FileSetCheck.process()`
```
                       tao cay cau hinh                                            
                              │                                                    
                              │                                                    
                              ▼                                                    
                       xac dinh file kiem thu                                      
                              │                                                    
                              │                                                    
                              ▼                                                    
                       Checker.process                                             
                              │                                                    
          ┌───────────────────┴───────────┬──────────────────────────────────┐     
          ▼                               ▼                                  ▼     
FileSetCheck.process            FileSetCheck.process           FileSetCheck.process
```
