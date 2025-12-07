#import "/template.typ": *

#[
  #set heading(numbering: "Chương 1.1")
  = Tổng quan về Checkstyle <chuong2>
]

== Giới thiệu chung về Checkstyle

== Luồng hoạt động

_Vẽ lại flow trong README_

== Kiến trúc

== Thuật toán

=== Biểu diễn mã nguồn

Trước khi kiểm tra, thư viện sẽ biểu diễn mã nguồn dưới dạng Abstract Syntax Tree - cây biểu diễn cú pháp trừu tượng.

#figure(
  image("../images/ast-01.png", width:50%),
  caption: "Ví dụ "
)

Một nút trên cây được biểu diễn bởi object `DetailAST` trong mã nguồn, với các thông tin:
- Thông tin về dòng lệnh:
  - getType(): Returns token type (e.g., CLASS_DEF, METHOD_DEF)
  - getText(): The actual text/identifier of the node
  - getLineNo() / getColumnNo(): Source location for error reporting
- Thông tin về các nút liền kề:
  - `getFirstChild()`: Nút con trực tiếp đầu tiên.
  - `getLastChild()`: Nút con trực tiếp cuối cùng.
  - `getChildCount()`: Số con trực tiếp.
  - `getChildCount(type)`: Số con trực tiếp có `getType()` trùng với `type`.
  - `hasChildren()`: Kiểm tra nút hiện tại có con trực tiếp không.
  - `getNextSibling()`:
  - `getPreviousSibling()`:
  - `getParent()`: Cha trực tiếp của nút hiện tại.
- Các phương thức hỗ trợ:


_Cách JavaParser chuyển mã nguồn sang AST?_ 

Ví dụ, một mã nguồn Java đơn giản

```
public class MyClass {
  public int field;
}
```

khi biểu diễn dưới dạng AST sẽ có dạng như sau:

```
(Vẽ lại cây bằng hình ảnh chứ không sử dụng các kí tự như này)
COMPILATION_UNIT
├── CLASS_DEF "MyClass"
│   ├── MODIFIERS
│   │   └── LITERAL_PUBLIC
│   ├── LITERAL_CLASS
│   ├── IDENT "MyClass"
│   ├── OBJBLOCK
│   │   └── VARIABLE_DEF "field"
│   │       ├── MODIFIERS
│   │       │   └── LITERAL_PRIVATE
│   │       ├── TYPE
│   │       │   └── LITERAL_INT
│   │       └── IDENT "field"
```

=== Kiểm tra mã nguồn

Phần lõi của thuật toán được cài đặt ở object `TreeWalker`. Cụ thể, object này sẽ thực hiện các việc chính sau:
- Chuyển mã nguồn Java sang dạng cây cú pháp
- Duyệt cây 

#pagebreak()
