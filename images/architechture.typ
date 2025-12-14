#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import fletcher.shapes: ellipse

= Kiến trúc hệ thống và luồng hoạt động



== Kiến trúc

#align(top)[
  === Cây cấu hình
]

#let config = read("../code/config.example.xml")
#grid(
  columns: (40%, auto),
  gutter: 24pt,
  [
    #figure(
      [#image("../images/config_tree.svg", width: 100%) #v(8pt)],
      caption: "Cấu trúc cây của file cấu hình",
    )
  ],
  [
    #set text(size: 14pt)
    #figure(
      [#raw(config, lang: "xml", block: true) #v(8pt)],
      caption: "config.example.xml",
    )
  ],
)



// #figure(
//   diagram(
//     node-stroke: 1pt + luma(100),
//     node-inset: 8pt,
//     node((.5, 0), [config.xml]),
//     node((0, 1), [header]),
//     node((1, 1), [module]),
//     node((1.8, 1), [name], inset: 12pt, shape: ellipse, extrude: (-3, 0)),

//     node((0.25, 2), [property]),
//     node((1.75, 2), [module]),
//     node((1.6, 3), [property]),
//     node((2.3, 3), [...]),

//     node((-0.25, 3), [name], inset: 12pt, shape: ellipse, extrude: (-3, 0)),
//     node((2.6, 2), [name], inset: 12pt, shape: ellipse, extrude: (-3, 0)),
//     node((0.75, 3), [value], inset: 12pt, shape: ellipse, extrude: (-3, 0)),


//     edge((.5, 0), (0, 1)),
//     edge((.5, 0), (1, 1)),
//     edge((1, 1), (1.8, 1)),

//     edge((1, 1), (0.25, 2)),
//     edge((1, 1), (1.75, 2)),
//     edge((0.25, 2), (-0.25, 3)),
//     edge((0.25, 2), (0.75, 3)),
//     edge((1.75, 2), (2.6, 2)),
//     edge((1.75, 2), (1.6, 3)),
//     edge((1.75, 2), (2.3, 3)),
//   ),
// )
#align(top)[
  === Mô hình thiết kết
]

#align(center)[
  #box(stroke: 1pt, inset: 10pt)[
    #stack(
      dir: ltr,
      spacing: 20pt,
      box(stroke: 1pt, inset: 10pt)[
        Pipe & Filter
      ],
      "+",
      box(stroke: 1pt, inset: 10pt)[
        Event-Driven
      ],
    )
  ]
]
#v(12pt)

#figure(
  image("../images/pipenfilter.svg", width: 60%),
  caption: "Mô hình Pipe & Filter",
)

#figure(
  image("../images/eventdriven.svg", width: 60%),
  caption: "Mô hình Event-Driven",
)

#align(top)[
  === Các thành phần chính
]
- *Checker*\
  Điều phối, quản lý vòng đời kiểm thử


- *FileSetCheck và TreeWalker*\
  Phân tích cú pháp, duyệt cây AST.

- *Check*\
  Các quy tắc kiểm tra cụ thể (VD: Độ dài dòng, Tên biến).

- *Filters*\
  Loại bỏ file không cần thiết và lọc bỏ các thông báo lỗi không mong muốn

- *AuditListener*\
  Ghi nhận và báo cáo kết quả.

== Checkstyle hiểu code Java như nào?

- Checkstyle không đọc code từng dòng như con người.

#figure(
  image("../images/ast_parser.svg", width: 50%),
  caption: "Quy trình chuyển đổi mã nguồn thành AST",
)

- `DetailAST`
  - Đại diện cho các thành phần cú pháp (lớp, phương thức, biểu thức, v.v.)
  - Chứa: Loại token, số dòng, số cột, liên kết cha-con.
- Cơ chế Visit - Leave: Duyệt cây theo chiều sâu (DFS) để kiểm tra ngữ cảnh.

#pagebreak()

#grid(
  columns: (32%, 5%, auto),
  gutter: 20pt,
  [
    #figure(
      ```java
      public class Demo {
        private int age;
      }
      ```,
      caption: "class Demo",
    )
  ],
  [
    $->$
  ],
  [
    #figure(
      image("../images/demo_ast.svg"),
      caption: "Cây AST tương ứng",
    )
  ],
)


== Luồng hoạt động

#image("../images/flowchart.svg")
