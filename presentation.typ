#import "./theme/fcb.typ": *
#import "@preview/cades:0.3.1": qr-code

#set raw(syntaxes: "syntaxes/mlir.sublime-syntax")
#set raw(syntaxes: "syntaxes/tablegen.sublime-syntax")

#import "codly-1.3.1/codly.typ": *
#import "@preview/codly-languages:0.1.10": *
#show: codly-init.with()
// #codly(zebra-fill: none)
#codly(number-format: none) // #codly(number-format: it => [#it])
#codly(languages: codly-languages)

#let background = white
#let foreground = navy
#let link-background = maroon // eastern
#let header-footer-foreground = maroon.lighten(50%)

#show strong: it => text(fill: link-background, it)


#let small-size = 0.5em
#let big-size = 1.5em

#show: fcb-theme.with(
  aspect-ratio: "16-9", // "4-3"
  header: [#align(
    center,
  )[#box(image("images/MLIR.png", height: 1.5em), baseline: 25%) _MLIR: Scaling Compiler Infrastructure for Domain Specific Computation_ #box(image("images/LLVM.png", height: 1.5em), baseline: 25%)]],
  footer: [Federico Bruzzone -- University of Milan #box(image("images/logo-lab-faded.pdf", height: 1em), baseline: 25%)],
  background: background,
  foreground: foreground,
  link-background: link-background,
  header-footer-foreground: header-footer-foreground,
)



// #set text(font: "Fira Mono")
// #show raw: it => block(
//   inset: 8pt,
//   text(fill: foreground, font: "Fira Mono", it),
//   radius: 5pt,
//   fill: rgb("#1d2433"),
// )

#title-slide[
  = MLIR: Scaling Compiler Infrastructure for Domain Specific Computation

  #side-by-side(columns: (1fr, 5fr, 1fr))[
    #move(dy: -30pt, dx: 50pt)[
      #grid(
        move(dx: 60pt, dy: 150pt)[
          #figure(
            image("images/logo-lab-faded.pdf", width: 50%),
              numbering: none,
              caption: [],
          )
        ],
        figure(
          image("images/minerva-new.pdf", width: 100%),
          numbering: none,
          caption: [],
        )
      )

    ]
  ][
    Federico Bruzzone, #footnote[
      ADAPT Lab -- University of Milan, \
      #h(1.5em) Website: #link("https://federicobruzzone.github.io/")[federicobruzzone.github.io], \
      #h(1.5em) Github: #link("https://github.com/FedericoBruzzone")[github.com/FedericoBruzzone], \
      #h(1.5em) Email: #link("mailto:federico.bruzzone@unimi.it")[federico.bruzzone\@unimi.it] \
      #h(1.5em) Slides: #link("https://federicobruzzone.github.io/activities/presentations/MLIR.pdf")[federicobruzzone.github.io/activities/presentations/MLIR.pdf]
    ] PhD Candidate

    // Milan, Italy -- #datetime.today().display("[day] [month repr:long] [year repr:full]")
    Milan, Italy -- 18 March 2026

    #text(small-size)[Supervised by Prof. Walter Cazzola]
  ][
    #move(dy: 10pt, dx: -50pt)[
      #qr-code("https://federicobruzzone.github.io/activities/presentations/MLIR.pdf", width: 4cm, color: foreground)
    ]
  ]
]


#centered-slide[
  = MLIR: Multi-Level Intermediate Representation

  #side-by-side(columns: (3fr, 1fr))[
    Part of the LLVM project, the MLIR is a novel approach to building *reusable*, *modular*, and *extensible* compiler infrastructure.

    MLIR aims to address software fragmentation, improve compilation for heterogeneous hardware, significantly reduce the cost of building *domain specific compilers*, and aid in connecting existing compilers together.
  ][
    #move(dx: 0pt, dy: -50pt)[
      #grid(
        move(dx: 60pt, dy: 250pt)[
          #figure(
            image("images/LLVM.png", width: 50%),
              numbering: none,
              caption: [],
          )
        ],
        figure(
          image("images/MLIR.png", width: 100%),
          numbering: none,
          caption: [],
        )
      )

    ]
  ]
]

#simple-slide[
  = Why another compiler infrastructure?

  Although the _one size fits all_ approach of traditional compilers (e.g., LLVM @Lattner04 and JVM @Lindholm13) has been successful for general-purpose programming, it has shown limitations in the context of domain-specific applications.

  Many problems are better modeled at a *higher-* or *lower-level abstraction* --- e.g., source-level static analysis of C++/Rust is difficult on LLVM IR.

  Hence, many languages and frameworks developed their own intermediate representations (IRs) to leverage the *semantic information* of their domain --- including TensorFlow's XLA HLO, PyTorch's Glow, Rust's MIR, Swift's SIL, Clang's CIL, and so on.
]

#focus-slide[#text(big-size)[
  While domain-specific IRs are well-understood, their _high engineering costs_ often lead to compromised infrastructure quality. This results in _suboptimal compilers_ plagued by bugs, latency, and a poor debugging experience @Latter21.
]]

#simple-slide[
  = MLIR to the rescue

  MLIR directly addresses these issues by making it *cheap* to design and *introduce* new abstraction layers.

  It achieves this by:
  - standardizing the Static Single Assignment (SSA)-based IR data structures,
  - providing a declarative system for defining IR _dialects_, and
  - providing a wide range of common infrastructure including documentation, parsing and printing logic, location tracking, multithreaded compilation support, pass management.
]

#simple-slide[
  = Design Principles

  - *Parsimony*: Apply _Occam's razor_ to builtin semantics, concepts, and programming interface. Specify invariants once, but verify correctness throughout $==>$ _extensibility_.

  - *Traceability*: Retain rather than recover information. Declare rules and properties to enable transformation, rather than step wise imperative specification $==>$ _composability_.

  - *Progressivity*: Premature lowering is the root of all evil. Beyond representation layers, allow multiple transformation paths that lower individual regions on demand $==>$ _reusability_.
]

#simple-slide[
  = Little Builtin, Everything Customizable #h(1fr) #text(small-size)[\[*Parsimony*\]]

  - The system is based on a minimal number of fundamental concepts, leaving most of the intermediate representation fully *customizable*.

  - A handful of abstractions---types, operations and attributes---should be used to express _everything else_, allowing fewer and more consistent abstractions that are easy to *comprehend*, *extend*, and *adopt*.

  - A success criterion for customization is the possibility to express a diverse set of abstractions including *ML graphs*, ASTs, mathematical abstractions such as *polyhedral*, CFGs and instruction-level IRs such as *LLVM IR*, without hard-coding concepts.

]

#simple-slide[
  = SSA and Regions #h(1fr) #text(small-size)[\[*Parsimony*\]]

  - *SSA* @Cytron91 makes dataflow analysis _simple_ and _sparse_. However, while many existing IRs use this flat, linearized CFG, representing higher level abstractions push introducing *nested regions*#footnote[
    A region is a single-entry, multi-exit CFG that can be nested inside an operation. It is a generalization of the concept of basic blocks and allows for more flexible control flow representation.
  ] as a first-class citizen --- e.g., structured control flow, concurrency constructs, and closures.

  - The (LLVM) normalization/canonicalization process is sacrificed due to the presence of multiple ways to represent the same semantics.

  - The frontend is responsible for choosing the level of abstraction for the IR.

]

#centered-slide[
  = The Canonical Loop Structure

  _Pre-header_, _header_, _latch_, and _body_ is a prototypical loop structure.

  #text(small-size)[
  #side-by-side(columns: (1fr, 1fr))[
    #codly(highlights: (
      // (line: 3, start: 0, fill: red),
    ))
    ```llvm
    ; for (int i = 0; i < n; ++i) { ... }
    entry:
      br label %header
    header:
      %i = phi i32 [ 0, %entry ], [ %inc, %latch ]
      %cmp = icmp slt i32 %i, %n
      br i1 %cmp, label %body, label %multi-exit
    latch:
      %inc = add i32 %i, 1
      br label %header
    body:
      ; loop body
      br label %latch
    multi-exit:
      ; code after the loop
    ```
  ][
   #codly(highlights: (
      // (line: 3, start: 0, fill: red),
    ))
    ```mlir
    // A simple loop from 0 to 10 with a step of 1
    scf.for %i = %c0 to %c10 step %c1 {
      // Loop body goes here
      // %i is the induction variable
      "some.operation"(%i) : (index) -> ()
    }
    ```

    #codly(highlights: (
      // (line: 3, start: 0, fill: red),
    ))
    ```mlir
    // An affine loop: optimized for polyhedral compilation
    affine.for %i = 0 to 10 {
        %val = affine.load %buffer[%i] : memref<10xf32>
        // ... operations ...
    }
    ```
  ]
  ]
]

#simple-slide[
  = Maintain Higher-Level Semantics  #h(1fr) #text(small-size)[\[*Progressivity*\]]

  - Attempts to *recover* abstract semantics once lowered are fragile and often *fail* to capture the full semantics.

  - The system should maintain the structure of computations and *progressively lower* to the hardware abstraction.

  - Removing structured control flow --- i.e. lowering to a CFG --- essentially means no further transformations will be performed that exploits the structure.

  - Previous compilers have been introducing multiple fixed levels of abstraction in their pipeline causing *phase ordering* issues.
]

#simple-slide[
  = Declaration and Validation #h(1fr) #text(small-size)[\[*Parsimony* & *Traceability*\]]

  - Defining representation modifiers should be as simple as introducing new abstractions.

  - Common transformations should be implementable as *rewrite rules* expressed declaratively.

  - Although rewriting systems are well-studied, the MLIR's extensibility opens up new challenges.

  - While verification, testing, and translation validation @Pnueli98 are useful a more robust approach to combining all these techniques for *extensible* and *modular* IRs.
]

#simple-slide[
  = Source Location Tracking #h(1fr) #text(small-size)[\[*Traceability*\]]

  - *Lack-of-transparency* in complex compilation systems is ubiquitous. This is particularly problematic when compiling safety-critical and sensitive applications (cf. `WYSINWYX` by Balakrishnan et al. @Balakrishnan10).

  - Thus, the *provenance* of an operation --- including its original location and applied transformations --- should be easily traceable within MLIR.

  - One indirect goal of accurately propagating high-level information to the lower levels is to help support *secure* and *traceable* compilation.
]

#centered-slide[
  = Intermediate Representation Design

  #side-by-side(columns: (1fr, 2fr))[
    #text(size: 0.8em)[
     MLIR has a _generic_ textual representation that supports MLIR’s extensibility and fully reflects the in-memory representation, which is paramount for *traceability*, manual IR *validation* and *testing*. Extensibility comes with the burden of verbosity, which can be compensated by the custom syntax that MLIR supports.
    ]
  ][
    #text(size: 0.38em)[
    $C_(i+j) <- C_(i+j) + (A_i * B_j)$
    #codly(highlights: (
      // (line: 3, start: 0, fill: red),
    ))
    ```mlir
    // Attribute aliases can be forward-declared.
    #map1 = (d0, d1) -> (d0 + d1)
    #map3 = ()[s0] -> (s0)

    // Ops may have regions attached.
    "affine.for"(%arg0) ({
    // Regions consist of a CFG of blocks with arguments.
    ^bb0(%arg4: index):
      // Block are lists of operations.
      "affine.for"(%arg0) ({
      ^bb0(%arg5: index):
        // Ops use and define typed values, which obey SSA.
        %0 = "affine.load"(%arg1, %arg4) {map = (d0) -> (d0)} : (memref<?xf32>, index) -> f32
        %1 = "affine.load"(%arg2, %arg5) {map = (d0) -> (d0)} : (memref<?xf32>, index) -> f32
        %2 = "std.mulf"(%0, %1) : (f32, f32) -> f32
        %3 = "affine.load"(%arg3, %arg4, %arg5) {map = #map1} : (memref<?xf32>, index, index) -> f32
        %4 = "std.addf"(%3, %2) : (f32, f32) -> f32
        "affine.store"(%4, %arg3, %arg4, %arg5) {map = #map1} : (f32, memref<?xf32>, index, index) -> ()
        // Blocks end with a terminator Op.
        "affine.terminator"() : () -> ()
      // Ops have a list of attributes.
      }) {lower_bound = () -> (0), step = 1 : index, upper_bound = #map3} : (index) -> ()
      "affine.terminator"() : () -> ()
    }) {lower_bound = () -> (0), step = 1 : index, upper_bound = #map3} : (index) -> ()
    ```
    // #figure(
    //   image("images/f1.png", width: 60%),
    //   numbering: none,
    //   caption: [],
    // )<f1>
  ]
  ]
]

#simple-slide[
  = IR: _Operations_ #h(1fr) #text(small-size)[\[*Parsimony*\]]

  #side-by-side(columns: (1fr, 2fr))[
    #text(size: 0.8em)[
      The unit of semantics in MLIR is an *operation* (Op): _instruction_, _function_ and _module_ are modeled as Ops.

      MLIR does not have a fixed set of Ops, but allows user-defined extensions.

      The infrastructure provides a declarative syntax for defining Ops based on the well-known *TableGen*.#footnote[https://llvm.org/docs/TableGen/]
    ]
  ][
    #text(size: small-size)[
    #codly(highlights: (
      // (line: 3, start: 0, fill: red),
    ))
    ```tablegen
    // An Op is a TableGen definition that inherits the "Op" class parameterized with the Op name
    def LeakyReluOp: Op<"leaky_relu",
        // and a list of traits used for verification and optimization.
        [NoSideEffect, SameOperandsAndResultType]> {
      // The body of the definition contains named fields for a one-line
      // documentation summary for the Op.
      let summary = "Leaky Relu operator";
      // The Op can also a full-text description that can be used to generate
      // documentation for the dialect.
      let description = [{
        Element-wise Leaky ReLU operator x -> x >= 0 ? x : (alpha * x) }];
      // Op can have a list of named arguments, which include typed operands and attributes.
      let arguments = (ins AnyTensor:$input, F32Attr:$alpha);
      // And a list of named and typed outputs.
      let results = (outs AnyTensor:$output);
    }
    ```
  ]
  ]
]

#simple-slide[
  = IR: _Operations_ (cont.) #h(1fr) #text(small-size)[\[*Parsimony*\]]

  #side-by-side(columns: (2fr, 3fr))[
    #text(size: 0.8em)[
      Ops have a *unique* opcode: the operation and its dialect.

      Ops take and produce zero or more SSA _operands_ and _results_.

      Values represent runtime data and are fully typed to ensure compile-time knowledge.

      Ops may also have _Attributes_, _Regions_, _Successor Blocks_, and _Location_ Information.
    ]
  ][
    #text(size: 0.35em)[
    #codly(highlights: (
      (line: 6, start: 0, end: 12, fill: yellow),
      (line: 10, start: 3, end: 14, fill: yellow),
      (line: 13, start: 10, end: 22, fill: yellow),
      (line: 14, start: 10, end: 22, fill: yellow),
      (line: 15, start: 10, end: 19, fill: yellow),
      (line: 16, start: 10, end: 22, fill: yellow),
      (line: 17, start: 10, end: 19, fill: yellow),
      (line: 18, start: 5, end: 18, fill: yellow),
      (line: 20, start: 5, end: 23, fill: yellow),
      (line: 23, start: 3, end: 21, fill: yellow),
    ))
    ```mlir
    // Attribute aliases can be forward-declared.
    #map1 = (d0, d1) -> (d0 + d1)
    #map3 = ()[s0] -> (s0)

    // Ops may have regions attached.
    "affine.for"(%arg0) ({
    // Regions consist of a CFG of blocks with arguments.
    ^bb0(%arg4: index):
      // Block are lists of operations.
      "affine.for"(%arg0) ({
      ^bb0(%arg5: index):
        // Ops use and define typed values, which obey SSA.
        %0 = "affine.load"(%arg1, %arg4) {map = (d0) -> (d0)} : (memref<?xf32>, index) -> f32
        %1 = "affine.load"(%arg2, %arg5) {map = (d0) -> (d0)} : (memref<?xf32>, index) -> f32
        %2 = "std.mulf"(%0, %1) : (f32, f32) -> f32
        %3 = "affine.load"(%arg3, %arg4, %arg5) {map = #map1} : (memref<?xf32>, index, index) -> f32
        %4 = "std.addf"(%3, %2) : (f32, f32) -> f32
        "affine.store"(%4, %arg3, %arg4, %arg5) {map = #map1} : (f32, memref<?xf32>, index, index) -> ()
        // Blocks end with a terminator Op.
        "affine.terminator"() : () -> ()
      // Ops have a list of attributes.
      }) {lower_bound = () -> (0), step = 1 : index, upper_bound = #map3} : (index) -> ()
      "affine.terminator"() : () -> ()
    }) {lower_bound = () -> (0), step = 1 : index, upper_bound = #map3} : (index) -> ()
    ```
  ]
  ]
]


#simple-slide[
  = IR: _Attributes_ #h(1fr) #text(small-size)[\[*Parsimony*\]]

  #side-by-side(columns: (2fr, 3fr))[
    #text(size: 0.8em)[
      MLIR *attributes* contain compile-time information about Ops.

      Attributes are typed (e.g., integer, string), and each Op instance has an open key-value dictionary from string names to attribute values.

      Attributes derive their meaning either from the *Op semantics* or from the *dialect* they are associated with.

      As with opcodes, there is no fixed set of attributes.
    ]
  ][
    #text(size: 0.33em)[
    #codly(highlights: (
      // Operations
      (line: 6, start: 0, end: 12, fill: yellow),
      (line: 10, start: 3, end: 14, fill: yellow),
      (line: 13, start: 10, end: 22, fill: yellow),
      (line: 14, start: 10, end: 22, fill: yellow),
      (line: 15, start: 10, end: 19, fill: yellow),
      (line: 16, start: 10, end: 22, fill: yellow),
      (line: 17, start: 10, end: 19, fill: yellow),
      (line: 18, start: 5, end: 18, fill: yellow),
      (line: 20, start: 5, end: 23, fill: yellow),
      (line: 23, start: 3, end: 21, fill: yellow),
      // Attributes
      (line: 2, start: 0, fill: green),
      (line: 3, start: 0, fill: green),
      (line: 13, start: 39, end: 56, fill: green),
      (line: 14, start: 39, end: 56, fill: green),
      (line: 16, start: 46, end: 56, fill: green),
      (line: 18, start: 46, end: 56, fill: green),
      (line: 22, start: 7, end: 68, fill: green),
      (line: 24, start: 5, end: 66, fill: green),
    ))
    ```mlir
    // Attribute aliases can be forward-declared.
    #map1 = (d0, d1) -> (d0 + d1)
    #map3 = ()[s0] -> (s0)

    // Ops may have regions attached.
    "affine.for"(%arg0) ({
    // Regions consist of a CFG of blocks with arguments.
    ^bb0(%arg4: index):
      // Block are lists of operations.
      "affine.for"(%arg0) ({
      ^bb0(%arg5: index):
        // Ops use and define typed values, which obey SSA.
        %0 = "affine.load"(%arg1, %arg4) {map = (d0) -> (d0)} : (memref<?xf32>, index) -> f32
        %1 = "affine.load"(%arg2, %arg5) {map = (d0) -> (d0)} : (memref<?xf32>, index) -> f32
        %2 = "std.mulf"(%0, %a1) : (f32, f32) -> f32
        %3 = "affine.load"(%arg3, %arg4, %arg5) {map = #map1} : (memref<?xf32>, index, index) -> f32
        %4 = "std.addf"(%3, %2) : (f32, f32) -> f32
        "affine.store"(%4, %arg3, %arg4, %arg5) {map = #map1} : (f32, memref<?xf32>, index, index) -> ()
        // Blocks end with a terminator Op.
        "affine.terminator"() : () -> ()
      // Ops have a list of attributes.
      }) {lower_bound = () -> (0), step = 1 : index, upper_bound = #map3} : (index) -> ()
      "affine.terminator"() : () -> ()
    }) {lower_bound = () -> (0), step = 1 : index, upper_bound = #map3} : (index) -> ()
    ```
  ]
  ]
]

#simple-slide[
  = IR: _Location Information_  #h(1fr) #text(small-size)[\[*Traceability*\]]

  #side-by-side(columns: (2fr, 3fr))[
    #text(size: 0.9em)[
      MLIR provides a compact representation for *location information*, and encourages the processing and propagation of this information throughout the system, following the *traceability* principle.

      It can be used to keep the
      source program stack trace that produced an Op, to generate
      debug information.
    ]
  ][
    #text(size: 0.32em)[
    #codly(highlights: (
      // Operations
      (line: 6, start: 0, end: 12, fill: yellow),
      (line: 10, start: 3, end: 14, fill: yellow),
      (line: 13, start: 10, end: 22, fill: yellow),
      (line: 14, start: 10, end: 22, fill: yellow),
      (line: 15, start: 10, end: 19, fill: yellow),
      (line: 16, start: 10, end: 22, fill: yellow),
      (line: 17, start: 10, end: 19, fill: yellow),
      (line: 18, start: 5, end: 18, fill: yellow),
      (line: 20, start: 5, end: 23, fill: yellow),
      (line: 23, start: 3, end: 21, fill: yellow),
      // Attributes
      (line: 2, start: 0, fill: green),
      (line: 3, start: 0, fill: green),
      (line: 13, start: 39, end: 56, fill: green),
      (line: 14, start: 39, end: 56, fill: green),
      (line: 16, start: 46, end: 56, fill: green),
      (line: 18, start: 46, end: 56, fill: green),
      (line: 22, start: 7, end: 68, fill: green),
      (line: 24, start: 5, end: 66, fill: green),
      // Location Information
      (line: 13, start: 91, fill: blue),
      (line: 14, start: 91, fill: blue),
      (line: 15, start: 50, fill: blue),
      (line: 16, start: 98, fill: blue),
      (line: 17, start: 49, fill: blue),
      (line: 18, start: 102, fill: blue),
      (line: 22, start: 87, fill: blue),
      (line: 24, start: 85, fill: blue),

    ))
    ```mlir
    // Attribute aliases can be forward-declared.
    #map1 = (d0, d1) -> (d0 + d1)
    #map3 = ()[s0] -> (s0)

    // Ops may have regions attached.
    "affine.for"(%arg0) ({
    // Regions consist of a CFG of blocks with arguments.
    ^bb0(%arg4: index):
      // Block are lists of operations.
      "affine.for"(%arg0) ({
      ^bb0(%arg5: index):
        // Ops use and define typed values, which obey SSA.
        %0 = "affine.load"(%arg1, %arg4) {map = (d0) -> (d0)} : (memref<?xf32>, index) -> f32 loc("kernel.c":10:12)
        %1 = "affine.load"(%arg2, %arg5) {map = (d0) -> (d0)} : (memref<?xf32>, index) -> f32 loc("kernel.c":11:12)
        %2 = "std.mulf"(%0, %a1) : (f32, f32) -> f32 loc(fused["kernel.c":12:15, "params.h":5:2])
        %3 = "affine.load"(%arg3, %arg4, %arg5) {map = #map1} : (memref<?xf32>, index, index) -> f32 loc("kernel.c":13:8)
        %4 = "std.addf"(%3, %2) : (f32, f32) -> f32 loc("kernel.c":13:14)
        "affine.store"(%4, %arg3, %arg4, %arg5) {map = #map1} : (f32, memref<?xf32>, index, index) -> () loc("kernel.c":13:5)
        // Blocks end with a terminator Op.
        "affine.terminator"() : () -> ()
      // Ops have a list of attributes.
      }) {lower_bound = () -> (0), step = 1 : index, upper_bound = #map3} : (index) -> () loc("kernel.c":9:5)
      "affine.terminator"() : () -> ()
    }) {lower_bound = () -> (0), step = 1 : index, upper_bound = #map3} : (index) -> () loc("kernel.c":8:3)
    ```
  ]
  ]
]

#simple-slide[
  = IR: _Regions and Blocks_ #h(1fr) #text(small-size)[\[*Progressivity*\]]

  #side-by-side(columns: (2fr, 3fr))[
    #text(size: 0.8em)[
      An instance of an Op may have a list of attached *regions*.

      A region contains a list of *blocks*, each of which contains a list of Ops.

      As with _attributes_, the semantics of a region are defined by the operation they are attached to.
      However the blocks inside the region form a CFG through the use of *terminator* operations that specify the successor blocks.
    ]
  ][
    #text(size: 0.32em)[
      #codly(
        highlighted-lines: (
          (6, orange.lighten(50%)),
          (7, orange.lighten(70%)),
          (8, orange.lighten(70%)),
          (9, orange.lighten(90%)),
          (10, orange.lighten(90%)),
          (11, orange.lighten(90%)),
          (12, orange.lighten(90%)),
          (13, orange.lighten(90%)),
          (14, orange.lighten(90%)),
          (15, orange.lighten(90%)),
          (16, orange.lighten(90%)),
          (17, orange.lighten(90%)),
          (18, orange.lighten(90%)),
          (19, orange.lighten(90%)),
          (20, orange.lighten(90%)),
          (21, orange.lighten(90%)),
          (22, orange.lighten(90%)),
          (23, orange.lighten(90%)),
          (24, orange.lighten(50%)),
        ),
        highlights: (
          // Operations
          (line: 6, start: 0, end: 12, fill: yellow),
          (line: 10, start: 3, end: 14, fill: yellow),
          (line: 13, start: 10, end: 22, fill: yellow),
          (line: 14, start: 10, end: 22, fill: yellow),
          (line: 15, start: 10, end: 19, fill: yellow),
          (line: 16, start: 10, end: 22, fill: yellow),
          (line: 17, start: 10, end: 19, fill: yellow),
          (line: 18, start: 5, end: 18, fill: yellow),
          (line: 20, start: 5, end: 23, fill: yellow),
          (line: 23, start: 3, end: 21, fill: yellow),
          // Attributes
          (line: 2, start: 0, fill: green),
          (line: 3, start: 0, fill: green),
          (line: 13, start: 39, end: 56, fill: green),
          (line: 14, start: 39, end: 56, fill: green),
          (line: 16, start: 46, end: 56, fill: green),
          (line: 18, start: 46, end: 56, fill: green),
          (line: 22, start: 7, end: 68, fill: green),
          (line: 24, start: 5, end: 66, fill: green),
          // Location Information
          (line: 13, start: 91, fill: blue),
          (line: 14, start: 91, fill: blue),
          (line: 15, start: 50, fill: blue),
          (line: 16, start: 98, fill: blue),
          (line: 17, start: 49, fill: blue),
          (line: 18, start: 102, fill: blue),
          (line: 22, start: 87, fill: blue),
          (line: 24, start: 85, fill: blue),
        ),
      )
      ```mlir
      // Attribute aliases can be forward-declared.
      #map1 = (d0, d1) -> (d0 + d1)
      #map3 = ()[s0] -> (s0)

      // Ops may have regions attached.
      "affine.for"(%arg0) ({
      // Regions consist of a CFG of blocks with arguments.
      ^bb0(%arg4: index):
        // Block are lists of operations.
        "affine.for"(%arg0) ({
        ^bb0(%arg5: index):
          // Ops use and define typed values, which obey SSA.
          %0 = "affine.load"(%arg1, %arg4) {map = (d0) -> (d0)} : (memref<?xf32>, index) -> f32 loc("kernel.c":10:12)
          %1 = "affine.load"(%arg2, %arg5) {map = (d0) -> (d0)} : (memref<?xf32>, index) -> f32 loc("kernel.c":11:12)
          %2 = "std.mulf"(%0, %a1) : (f32, f32) -> f32 loc(fused["kernel.c":12:15, "params.h":5:2])
          %3 = "affine.load"(%arg3, %arg4, %arg5) {map = #map1} : (memref<?xf32>, index, index) -> f32 loc("kernel.c":13:8)
          %4 = "std.addf"(%3, %2) : (f32, f32) -> f32 loc("kernel.c":13:14)
          "affine.store"(%4, %arg3, %arg4, %arg5) {map = #map1} : (f32, memref<?xf32>, index, index) -> () loc("kernel.c":13:5)
          // Blocks end with a terminator Op.
          "affine.terminator"() : () -> ()
        // Ops have a list of attributes.
        }) {lower_bound = () -> (0), step = 1 : index, upper_bound = #map3} : (index) -> () loc("kernel.c":9:5)
        "affine.terminator"() : () -> ()
      }) {lower_bound = () -> (0), step = 1 : index, upper_bound = #map3} : (index) -> () loc("kernel.c":8:3)
      ```
  ]
  ]
]

#simple-slide[
  = IR: _Regions and Blocks_ (Cont.) #h(1fr) #text(small-size)[\[*Progressivity*\]]

  #side-by-side(columns: (2fr, 3fr))[
    #text(size: 0.8em)[
      Regions and block allows *nesting* mechanisms that can be used to represent _structured control flow_ etc.

      #block(
        fill: maroon.lighten(90%),
        inset: 8pt,
        radius: 4pt,
        [Instead of using $phi$ nodes, MLIR uses a *functional* form of SSA @Appel98 --- terminators pass values into _block arguments_ defined by the successor block.]
      )


      For the more attentive readers, there is a strong correlation with the *Sea of Nodes* IR @Click93 @Click95.
    ]
  ][
    #text(size: 0.32em)[
      #codly(
        highlighted-lines: (
          (6, orange.lighten(70%)),
          (7, orange.lighten(80%)),
          (8, orange.lighten(80%)),
          (9, orange.lighten(90%)),

          (10, purple.lighten(50%)),
          (11, purple.lighten(70%)),
          (12, purple.lighten(90%)),
          (13, purple.lighten(90%)),
          (14, purple.lighten(90%)),
          (15, purple.lighten(90%)),
          (16, purple.lighten(90%)),
          (17, purple.lighten(90%)),
          (18, purple.lighten(90%)),
          (19, purple.lighten(90%)),
          (20, purple.lighten(90%)),
          (21, purple.lighten(90%)),
          (22, purple.lighten(50%)),

          (23, orange.lighten(90%)),
          (24, orange.lighten(70%)),
        ),
        highlights: (
          // Operations
          (line: 6, start: 0, end: 12, fill: yellow),
          (line: 10, start: 3, end: 14, fill: yellow),
          (line: 13, start: 10, end: 22, fill: yellow),
          (line: 14, start: 10, end: 22, fill: yellow),
          (line: 15, start: 10, end: 19, fill: yellow),
          (line: 16, start: 10, end: 22, fill: yellow),
          (line: 17, start: 10, end: 19, fill: yellow),
          (line: 18, start: 5, end: 18, fill: yellow),
          (line: 20, start: 5, end: 23, fill: yellow),
          (line: 23, start: 3, end: 21, fill: yellow),
          // Attributes
          (line: 2, start: 0, fill: green),
          (line: 3, start: 0, fill: green),
          (line: 13, start: 39, end: 56, fill: green),
          (line: 14, start: 39, end: 56, fill: green),
          (line: 16, start: 46, end: 56, fill: green),
          (line: 18, start: 46, end: 56, fill: green),
          (line: 22, start: 7, end: 68, fill: green),
          (line: 24, start: 5, end: 66, fill: green),
          // Location Information
          (line: 13, start: 91, fill: blue),
          (line: 14, start: 91, fill: blue),
          (line: 15, start: 50, fill: blue),
          (line: 16, start: 98, fill: blue),
          (line: 17, start: 49, fill: blue),
          (line: 18, start: 102, fill: blue),
          (line: 22, start: 87, fill: blue),
          (line: 24, start: 85, fill: blue),
        ),
      )
      ```mlir
      // Attribute aliases can be forward-declared.
      #map1 = (d0, d1) -> (d0 + d1)
      #map3 = ()[s0] -> (s0)

      // Ops may have regions attached.
      "affine.for"(%arg0) ({
      // Regions consist of a CFG of blocks with arguments.
      ^bb0(%arg4: index):
        // Block are lists of operations.
        "affine.for"(%arg0) ({
        ^bb0(%arg5: index):
          // Ops use and define typed values, which obey SSA.
          %0 = "affine.load"(%arg1, %arg4) {map = (d0) -> (d0)} : (memref<?xf32>, index) -> f32 loc("kernel.c":10:12)
          %1 = "affine.load"(%arg2, %arg5) {map = (d0) -> (d0)} : (memref<?xf32>, index) -> f32 loc("kernel.c":11:12)
          %2 = "std.mulf"(%0, %a1) : (f32, f32) -> f32 loc(fused["kernel.c":12:15, "params.h":5:2])
          %3 = "affine.load"(%arg3, %arg4, %arg5) {map = #map1} : (memref<?xf32>, index, index) -> f32 loc("kernel.c":13:8)
          %4 = "std.addf"(%3, %2) : (f32, f32) -> f32 loc("kernel.c":13:14)
          "affine.store"(%4, %arg3, %arg4, %arg5) {map = #map1} : (f32, memref<?xf32>, index, index) -> () loc("kernel.c":13:5)
          // Blocks end with a terminator Op.
          "affine.terminator"() : () -> ()
        // Ops have a list of attributes.
        }) {lower_bound = () -> (0), step = 1 : index, upper_bound = #map3} : (index) -> () loc("kernel.c":9:5)
        "affine.terminator"() : () -> ()
      }) {lower_bound = () -> (0), step = 1 : index, upper_bound = #map3} : (index) -> () loc("kernel.c":8:3)
      ```
  ]
  ]
]

#simple-slide[
  = IR: _Value Dominance and Visibility_ #h(1fr) #text(small-size)[\[*Progressivity*\]]


 #side-by-side(columns: (2fr, 3fr))[
   #text(size: 0.8em)[
     Ops can only use values that are in scope, i.e. *visible* according to SSA dominance, nesting, and semantic restrictions imposed by enclosing operations.

     Region-based visibility is defined based on simple nesting of regions.

     MLIR also allows operations to be defined as _isolated from above_, indicating that the operation is a scope barrier --- e.g., `std.func` Op.
   ]
 ][
   #text(size: 0.32em)[
     #codly(
       highlighted-lines: (
         (6, orange.lighten(70%)),
         (7, orange.lighten(80%)),
         (8, orange.lighten(80%)),
         (9, orange.lighten(90%)),

         (10, purple.lighten(70%)),
         (11, purple.lighten(80%)),
         (12, purple.lighten(90%)),
         (13, purple.lighten(90%)),
         (14, purple.lighten(90%)),
         (15, purple.lighten(90%)),
         (16, purple.lighten(90%)),
         (17, purple.lighten(90%)),
         (18, purple.lighten(90%)),
         (19, purple.lighten(90%)),
         (20, purple.lighten(90%)),
         (21, purple.lighten(90%)),
         (22, purple.lighten(70%)),

         (23, orange.lighten(90%)),
         (24, orange.lighten(70%)),
       ),
       highlights: (
         // Operations
         (line: 6, start: 0, end: 12, fill: yellow),
         (line: 10, start: 3, end: 14, fill: yellow),
         (line: 13, start: 10, end: 22, fill: yellow),
         (line: 14, start: 10, end: 22, fill: yellow),
         (line: 15, start: 10, end: 19, fill: yellow),
         (line: 16, start: 10, end: 22, fill: yellow),
         (line: 17, start: 10, end: 19, fill: yellow),
         (line: 18, start: 5, end: 18, fill: yellow),
         (line: 20, start: 5, end: 23, fill: yellow),
         (line: 23, start: 3, end: 21, fill: yellow),
         // Attributes
         (line: 2, start: 0, fill: green),
         (line: 3, start: 0, fill: green),
         (line: 13, start: 39, end: 56, fill: green),
         (line: 14, start: 39, end: 56, fill: green),
         (line: 16, start: 46, end: 56, fill: green),
         (line: 18, start: 46, end: 56, fill: green),
         (line: 22, start: 7, end: 68, fill: green),
         (line: 24, start: 5, end: 66, fill: green),
         // Location Information
         (line: 13, start: 91, fill: blue),
         (line: 14, start: 91, fill: blue),
         (line: 15, start: 50, fill: blue),
         (line: 16, start: 98, fill: blue),
         (line: 17, start: 49, fill: blue),
         (line: 18, start: 102, fill: blue),
         (line: 22, start: 87, fill: blue),
         (line: 24, start: 85, fill: blue),
       ),
     )
     ```mlir
     // Attribute aliases can be forward-declared.
     #map1 = (d0, d1) -> (d0 + d1)
     #map3 = ()[s0] -> (s0)

     // Ops may have regions attached.
     "affine.for"(%arg0) ({
     // Regions consist of a CFG of blocks with arguments.
     ^bb0(%arg4: index):
       // Block are lists of operations.
       "affine.for"(%arg0) ({
       ^bb0(%arg5: index):
         // Ops use and define typed values, which obey SSA.
         %0 = "affine.load"(%arg1, %arg4) {map = (d0) -> (d0)} : (memref<?xf32>, index) -> f32 loc("kernel.c":10:12)
         %1 = "affine.load"(%arg2, %arg5) {map = (d0) -> (d0)} : (memref<?xf32>, index) -> f32 loc("kernel.c":11:12)
         %2 = "std.mulf"(%0, %a1) : (f32, f32) -> f32 loc(fused["kernel.c":12:15, "params.h":5:2])
         %3 = "affine.load"(%arg3, %arg4, %arg5) {map = #map1} : (memref<?xf32>, index, index) -> f32 loc("kernel.c":13:8)
         %4 = "std.addf"(%3, %2) : (f32, f32) -> f32 loc("kernel.c":13:14)
         "affine.store"(%4, %arg3, %arg4, %arg5) {map = #map1} : (f32, memref<?xf32>, index, index) -> () loc("kernel.c":13:5)
         // Blocks end with a terminator Op.
         "affine.terminator"() : () -> ()
       // Ops have a list of attributes.
       }) {lower_bound = () -> (0), step = 1 : index, upper_bound = #map3} : (index) -> () loc("kernel.c":9:5)
       "affine.terminator"() : () -> ()
     }) {lower_bound = () -> (0), step = 1 : index, upper_bound = #map3} : (index) -> () loc("kernel.c":8:3)
     ```
 ]
 ]
]

#simple-slide[
  = IR: _Symbols and Symbol Tables_ #h(1fr) #text(small-size)[\[*Traceability*\]]


 #side-by-side(columns: (2fr, 3fr))[
   #text(size: 0.8em)[
     Ops can have a *symbol table* attached: a standardized way of associating _names_ to _IR objects_ (*symbols*) --- e.g., global variables, functions or named modules.

     The IR does not prescribe *what* symbols are used for, leaving it up to the Op definition.

     Without this mechanism, it would have been *impossible* to define recursive function.
   ]
 ][
   #text(size: 0.28em)[
     #codly(
       highlighted-lines: (
         (1, red.lighten(70%)),

         (2, maroon.lighten(70%)),
         (3, maroon.lighten(90%)),
         (4, maroon.lighten(90%)),
         (5, maroon.lighten(90%)),
         (6, maroon.lighten(90%)),
         (7, maroon.lighten(90%)),

         (8, orange.lighten(70%)),
         (9, orange.lighten(80%)),
         (10, orange.lighten(80%)),
         (11, orange.lighten(90%)),

         (12, purple.lighten(70%)),
         (13, purple.lighten(80%)),
         (14, purple.lighten(90%)),
         (15, purple.lighten(90%)),
         (16, purple.lighten(90%)),
         (17, purple.lighten(90%)),
         (18, purple.lighten(90%)),
         (19, purple.lighten(90%)),
         (20, purple.lighten(90%)),
         (21, purple.lighten(90%)),
         (22, purple.lighten(90%)),
         (23, purple.lighten(90%)),
         (24, purple.lighten(70%)),

         (25, orange.lighten(90%)),
         (26, orange.lighten(70%)),

         (27, maroon.lighten(90%)),
         (28, maroon.lighten(70%)),

         (29, red.lighten(70%)),
       ),
       highlights: (
         // Operations
         (line: 1, start: 0, end: 6, fill: yellow),
         (line: 2, start: 3, end: 11, fill: yellow),
         (line: 8, start: 5, end: 16, fill: yellow),
         (line: 12, start: 7, end: 18, fill: yellow),
         (line: 15, start: 14, end: 26, fill: yellow),
         (line: 16, start: 14, end: 26, fill: yellow),
         (line: 17, start: 14, end: 23, fill: yellow),
         (line: 18, start: 14, end: 26, fill: yellow),
         (line: 19, start: 14, end: 23, fill: yellow),
         (line: 20, start: 9, end: 22, fill: yellow),
         (line: 22, start: 9, end: 27, fill: yellow),
         (line: 25, start: 7, end: 25, fill: yellow),
         // Attributes
         (line: 4, start: 5, fill: green),
         (line: 5, start: 5, fill: green),
         (line: 15, start: 43, end: 60, fill: green),
         (line: 16, start: 43, end: 60, fill: green),
         (line: 18, start: 50, end: 60, fill: green),
         (line: 20, start: 50, end: 60, fill: green),
         (line: 24, start: 11, end: 72, fill: green),
         (line: 26, start: 9, end: 70, fill: green),
         // Location Information
         (line: 15, start: 95, fill: blue),
         (line: 16, start: 95, fill: blue),
         (line: 17, start: 54, fill: blue),
         (line: 18, start: 102, fill: blue),
         (line: 19, start: 53, fill: blue),
         (line: 20, start: 106, fill: blue),
         (line: 24, start: 91, fill: blue),
         (line: 26, start: 89, fill: blue),
         // Symbols
         (line: 1, start: 8, end: 21, fill: navy),
         (line: 2, start: 13, end: 27, fill: navy),
       ),
     )
     ```mlir
     module @kernel_module {
       func.func @compute_kernel(%arg0: index, %arg1: memref<?xf32>, %arg2: memref<?xf32>, %arg3: memref<?xf32>) {
         // Attribute aliases can be forward-declared.
         #map1 = (d0, d1) -> (d0 + d1)
         #map3 = ()[s0] -> (s0)

         // Ops may have regions attached.
         "affine.for"(%arg0) ({
         // Regions consist of a CFG of blocks with arguments.
         ^bb0(%arg4: index):
           // Block are lists of operations.
           "affine.for"(%arg0) ({
           ^bb0(%arg5: index):
             // Ops use and define typed values, which obey SSA.
             %0 = "affine.load"(%arg1, %arg4) {map = (d0) -> (d0)} : (memref<?xf32>, index) -> f32 loc("kernel.c":10:12)
             %1 = "affine.load"(%arg2, %arg5) {map = (d0) -> (d0)} : (memref<?xf32>, index) -> f32 loc("kernel.c":11:12)
             %2 = "std.mulf"(%0, %a1) : (f32, f32) -> f32 loc(fused["kernel.c":12:15, "params.h":5:2])
             %3 = "affine.load"(%arg3, %arg4, %arg5) {map = #map1} : (memref<?xf32>, index, index) -> f32 loc("kernel.c":13:8)
             %4 = "std.addf"(%3, %2) : (f32, f32) -> f32 loc("kernel.c":13:14)
             "affine.store"(%4, %arg3, %arg4, %arg5) {map = #map1} : (f32, memref<?xf32>, index, index) -> () loc("kernel.c":13:5)
             // Blocks end with a terminator Op.
             "affine.terminator"() : () -> ()
           // Ops have a list of attributes.
           }) {lower_bound = () -> (0), step = 1 : index, upper_bound = #map3} : (index) -> () loc("kernel.c":9:5)
           "affine.terminator"() : () -> ()
         }) {lower_bound = () -> (0), step = 1 : index, upper_bound = #map3} : (index) -> () loc("kernel.c":8:3)
         return
       }
     }
     ```
 ]
 ]
]

#simple-slide[
  = IR: _Dialects_ #h(1fr) #text(small-size)[\[*Progressivity*\]]

 #side-by-side(columns: (2fr, 3fr))[
   #text(size: 0.8em)[
     MLIR manages extensibility using *Dialects*, which provide a logical grouping of Ops, attributes and types under a unique namespace.

     Dialects themselves do not introduce any new semantics but serve as a logical grouping mechanism that provides common Op functionality (e.g., constant folding).

     This separation is conceptual and is akin to designing a set of *modular* libraries.
   ]
 ][
   #text(size: 0.25em)[
     #codly(
       highlighted-lines: (
         (1, red.lighten(70%)),

         (2, maroon.lighten(70%)),
         (3, maroon.lighten(90%)),
         (4, maroon.lighten(90%)),
         (5, maroon.lighten(90%)),
         (6, maroon.lighten(90%)),
         (7, maroon.lighten(90%)),

         (8, orange.lighten(70%)),
         (9, orange.lighten(80%)),
         (10, orange.lighten(80%)),
         (11, orange.lighten(90%)),

         (12, purple.lighten(70%)),
         (13, purple.lighten(80%)),
         (14, purple.lighten(90%)),
         (15, purple.lighten(90%)),
         (16, purple.lighten(90%)),
         (17, purple.lighten(90%)),
         (18, purple.lighten(90%)),
         (19, purple.lighten(90%)),
         (20, purple.lighten(90%)),
         (21, purple.lighten(90%)),
         (22, purple.lighten(90%)),
         (23, purple.lighten(90%)),
         (24, purple.lighten(70%)),

         (25, orange.lighten(90%)),
         (26, orange.lighten(70%)),

         (27, maroon.lighten(90%)),
         (28, maroon.lighten(70%)),

         (29, red.lighten(70%)),
       ),
       highlights: (
         // Operations
         (line: 1, start: 0, end: 6, fill: yellow),
         (line: 2, start: 3, end: 11, fill: yellow),
         (line: 8, start: 5, end: 16, fill: yellow),
         (line: 12, start: 7, end: 18, fill: yellow),
         (line: 15, start: 14, end: 26, fill: yellow),
         (line: 16, start: 14, end: 26, fill: yellow),
         (line: 17, start: 14, end: 23, fill: yellow),
         (line: 18, start: 14, end: 26, fill: yellow),
         (line: 19, start: 14, end: 23, fill: yellow),
         (line: 20, start: 9, end: 22, fill: yellow),
         (line: 22, start: 9, end: 27, fill: yellow),
         (line: 25, start: 7, end: 25, fill: yellow),
         // Attributes
         (line: 4, start: 5, fill: green),
         (line: 5, start: 5, fill: green),
         (line: 15, start: 43, end: 60, fill: green),
         (line: 16, start: 43, end: 60, fill: green),
         (line: 18, start: 50, end: 60, fill: green),
         (line: 20, start: 50, end: 60, fill: green),
         (line: 24, start: 11, end: 72, fill: green),
         (line: 26, start: 9, end: 70, fill: green),
         // Location Information
         (line: 15, start: 95, fill: blue),
         (line: 16, start: 95, fill: blue),
         (line: 17, start: 54, fill: blue),
         (line: 18, start: 102, fill: blue),
         (line: 19, start: 53, fill: blue),
         (line: 20, start: 106, fill: blue),
         (line: 24, start: 91, fill: blue),
         (line: 26, start: 89, fill: blue),
         // Symbols
         (line: 1, start: 8, end: 21, fill: navy),
         (line: 2, start: 13, end: 27, fill: navy),
         // Dialects
         (line: 2, start: 3, end: 6, fill: olive),
         (line: 8, start: 6, end: 11, fill: olive),
         (line: 12, start: 8, end: 13, fill: olive),
         (line: 15, start: 15, end: 20, fill: olive),
         (line: 16, start: 15, end: 20, fill: olive),
         (line: 17, start: 15, end: 17, fill: olive),
         (line: 18, start: 15, end: 20, fill: olive),
         (line: 19, start: 15, end: 17, fill: olive),
         (line: 20, start: 10, end: 15, fill: olive),
         (line: 22, start: 10, end: 15, fill: olive),
         (line: 25, start: 8, end: 13, fill: olive),
       ),
     )
     ```mlir
     module @kernel_module {
       func.func @compute_kernel(%arg0: index, %arg1: memref<?xf32>, %arg2: memref<?xf32>, %arg3: memref<?xf32>) {
         // Attribute aliases can be forward-declared.
         #map1 = (d0, d1) -> (d0 + d1)
         #map3 = ()[s0] -> (s0)

         // Ops may have regions attached.
         "affine.for"(%arg0) ({
         // Regions consist of a CFG of blocks with arguments.
         ^bb0(%arg4: index):
           // Block are lists of operations.
           "affine.for"(%arg0) ({
           ^bb0(%arg5: index):
             // Ops use and define typed values, which obey SSA.
             %0 = "affine.load"(%arg1, %arg4) {map = (d0) -> (d0)} : (memref<?xf32>, index) -> f32 loc("kernel.c":10:12)
             %1 = "affine.load"(%arg2, %arg5) {map = (d0) -> (d0)} : (memref<?xf32>, index) -> f32 loc("kernel.c":11:12)
             %2 = "std.mulf"(%0, %a1) : (f32, f32) -> f32 loc(fused["kernel.c":12:15, "params.h":5:2])
             %3 = "affine.load"(%arg3, %arg4, %arg5) {map = #map1} : (memref<?xf32>, index, index) -> f32 loc("kernel.c":13:8)
             %4 = "std.addf"(%3, %2) : (f32, f32) -> f32 loc("kernel.c":13:14)
             "affine.store"(%4, %arg3, %arg4, %arg5) {map = #map1} : (f32, memref<?xf32>, index, index) -> () loc("kernel.c":13:5)
             // Blocks end with a terminator Op.
             "affine.terminator"() : () -> ()
           // Ops have a list of attributes.
           }) {lower_bound = () -> (0), step = 1 : index, upper_bound = #map3} : (index) -> () loc("kernel.c":9:5)
           "affine.terminator"() : () -> ()
         }) {lower_bound = () -> (0), step = 1 : index, upper_bound = #map3} : (index) -> () loc("kernel.c":8:3)
         return
       }
     }
     ```
 ]
 ]
]

#focus-slide[#text(big-size)[
  Ops from different dialects can _coexist_ at any level of the IR at any time, they can use types defined in different dialects, etc. 

  Intermixing of dialects allows for greater _reuse_, _extensibility_ and provides _flexibility_ that otherwise would require developers to resort to all kinds of non-composable workarounds.
]]

#simple-slide[
  = IR: _Type System_ #h(1fr) #text(small-size)[\[*Parsimony*\]]

 #side-by-side(columns: (2fr, 3fr))[
   #text(size: 0.8em)[
     Every value in MLIR has a *type*, which is specified in the Op that produces the value or in the block that defines the value as an argument --- types encode compile-time information.

     While the type system in MLIR is user-extensible, it enforces *strict* type equality checking and does *not* provide type conversion rules.

     From the *type theory* point of view, MLIR does not support dependent types (but it can be encoded).
   ]
 ][
   #text(size: 0.24em)[
     #codly(
       highlighted-lines: (
         (1, red.lighten(70%)),

         (2, maroon.lighten(70%)),
         (3, maroon.lighten(90%)),
         (4, maroon.lighten(90%)),
         (5, maroon.lighten(90%)),
         (6, maroon.lighten(90%)),
         (7, maroon.lighten(90%)),

         (8, orange.lighten(70%)),
         (9, orange.lighten(80%)),
         (10, orange.lighten(80%)),
         (11, orange.lighten(90%)),

         (12, purple.lighten(70%)),
         (13, purple.lighten(80%)),
         (14, purple.lighten(90%)),
         (15, purple.lighten(90%)),
         (16, purple.lighten(90%)),
         (17, purple.lighten(90%)),
         (18, purple.lighten(90%)),
         (19, purple.lighten(90%)),
         (20, purple.lighten(90%)),
         (21, purple.lighten(90%)),
         (22, purple.lighten(90%)),
         (23, purple.lighten(90%)),
         (24, purple.lighten(70%)),

         (25, orange.lighten(90%)),
         (26, orange.lighten(70%)),

         (27, maroon.lighten(90%)),
         (28, maroon.lighten(70%)),

         (29, red.lighten(70%)),
       ),
       highlights: (
         // Operations
         (line: 1, start: 0, end: 6, fill: yellow),
         (line: 2, start: 3, end: 11, fill: yellow),
         (line: 8, start: 5, end: 16, fill: yellow),
         (line: 12, start: 7, end: 18, fill: yellow),
         (line: 15, start: 14, end: 26, fill: yellow),
         (line: 16, start: 14, end: 26, fill: yellow),
         (line: 17, start: 14, end: 23, fill: yellow),
         (line: 18, start: 14, end: 26, fill: yellow),
         (line: 19, start: 14, end: 23, fill: yellow),
         (line: 20, start: 9, end: 22, fill: yellow),
         (line: 22, start: 9, end: 27, fill: yellow),
         (line: 25, start: 7, end: 25, fill: yellow),
         // Attributes
         (line: 4, start: 5, fill: green),
         (line: 5, start: 5, fill: green),
         (line: 15, start: 43, end: 60, fill: green),
         (line: 16, start: 43, end: 60, fill: green),
         (line: 18, start: 50, end: 60, fill: green),
         (line: 20, start: 50, end: 60, fill: green),
         (line: 24, start: 11, end: 72, fill: green),
         (line: 26, start: 9, end: 70, fill: green),
         // Location Information
         (line: 15, start: 95, fill: blue),
         (line: 16, start: 95, fill: blue),
         (line: 17, start: 54, fill: blue),
         (line: 18, start: 102, fill: blue),
         (line: 19, start: 53, fill: blue),
         (line: 20, start: 106, fill: blue),
         (line: 24, start: 91, fill: blue),
         (line: 26, start: 89, fill: blue),
         // Symbols
         (line: 1, start: 8, end: 21, fill: navy),
         (line: 2, start: 13, end: 27, fill: navy),
         // Dialects
         (line: 2, start: 3, end: 6, fill: olive),
         (line: 8, start: 6, end: 11, fill: olive),
         (line: 12, start: 8, end: 13, fill: olive),
         (line: 15, start: 15, end: 20, fill: olive),
         (line: 16, start: 15, end: 20, fill: olive),
         (line: 17, start: 15, end: 17, fill: olive),
         (line: 18, start: 15, end: 20, fill: olive),
         (line: 19, start: 15, end: 17, fill: olive),
         (line: 20, start: 10, end: 15, fill: olive),
         (line: 22, start: 10, end: 15, fill: olive),
         (line: 25, start: 8, end: 13, fill: olive),
         // Type System
         (line: 2, start: 36, end: 40, fill: fuchsia),
         (line: 2, start: 50, end: 62, fill: fuchsia),
         (line: 2, start: 72, end: 84, fill: fuchsia),
         (line: 2, start: 94, end: 106, fill: fuchsia),
         (line: 10, start: 17, end: 21, fill: fuchsia),
         (line: 13, start: 19, end: 23, fill: fuchsia),
         (line: 15, start: 65, end: 93, fill: fuchsia),
         (line: 16, start: 65, end: 93, fill: fuchsia),
         (line: 17, start: 36, end: 52, fill: fuchsia),
         (line: 18, start: 65, end: 100, fill: fuchsia),
         (line: 19, start: 35, end: 51, fill: fuchsia),
         (line: 20, start: 65, end: 104, fill: fuchsia),
         (line: 22, start: 33, end: 40, fill: fuchsia),
         (line: 24, start: 77, end: 89, fill: fuchsia),
         (line: 25, start: 31, end: 40, fill: fuchsia),
         (line: 26, start: 75, end: 87, fill: fuchsia),
       ),
     )
     ```mlir
     module @kernel_module {
       func.func @compute_kernel(%arg0: index, %arg1: memref<?xf32>, %arg2: memref<?xf32>, %arg3: memref<?xf32>) {
         // Attribute aliases can be forward-declared.
         #map1 = (d0, d1) -> (d0 + d1)
         #map3 = ()[s0] -> (s0)

         // Ops may have regions attached.
         "affine.for"(%arg0) ({
         // Regions consist of a CFG of blocks with arguments.
         ^bb0(%arg4: index):
           // Block are lists of operations.
           "affine.for"(%arg0) ({
           ^bb0(%arg5: index):
             // Ops use and define typed values, which obey SSA.
             %0 = "affine.load"(%arg1, %arg4) {map = (d0) -> (d0)} : (memref<?xf32>, index) -> f32 loc("kernel.c":10:12)
             %1 = "affine.load"(%arg2, %arg5) {map = (d0) -> (d0)} : (memref<?xf32>, index) -> f32 loc("kernel.c":11:12)
             %2 = "std.mulf"(%0, %a1) : (f32, f32) -> f32 loc(fused["kernel.c":12:15, "params.h":5:2])
             %3 = "affine.load"(%arg3, %arg4, %arg5) {map = #map1} : (memref<?xf32>, index, index) -> f32 loc("kernel.c":13:8)
             %4 = "std.addf"(%3, %2) : (f32, f32) -> f32 loc("kernel.c":13:14)
             "affine.store"(%4, %arg3, %arg4, %arg5) {map = #map1} : (f32, memref<?xf32>, index, index) -> () loc("kernel.c":13:5)
             // Blocks end with a terminator Op.
             "affine.terminator"() : () -> ()
           // Ops have a list of attributes.
           }) {lower_bound = () -> (0), step = 1 : index, upper_bound = #map3} : (index) -> () loc("kernel.c":9:5)
           "affine.terminator"() : () -> ()
         }) {lower_bound = () -> (0), step = 1 : index, upper_bound = #map3} : (index) -> () loc("kernel.c":8:3)
         return
       }
     }
     ```
 ]
 ]
]

#simple-slide[
  = IR: _Functions and Modules_ #h(1fr) #text(small-size)[\[*Parsimony*\]]

 #side-by-side(columns: (2fr, 3fr))[
   #text(size: 0.75em)[
     Similarly to conventional IRs, MLIR is usually structured into *functions* and *modules*.

     However, these are *not* separate concepts in MLIR: they are implemented as Ops in the `builtin` and `func` dialect.

     A *module* is an Op with a single region containing a single block and does not transfer the control flow.

     A *function* is an Op with a single region that may contain zero (in case of declaration) or more blocks.
   ]
 ][
   #text(size: 0.24em)[
     #codly(
       highlighted-lines: (
         (1, red.lighten(20%)),

         (2, maroon.lighten(30%)),
         (3, maroon.lighten(90%)),
         (4, maroon.lighten(90%)),
         (5, maroon.lighten(90%)),
         (6, maroon.lighten(90%)),
         (7, maroon.lighten(90%)),

         (8, orange.lighten(70%)),
         (9, orange.lighten(80%)),
         (10, orange.lighten(80%)),
         (11, orange.lighten(90%)),

         (12, purple.lighten(70%)),
         (13, purple.lighten(80%)),
         (14, purple.lighten(90%)),
         (15, purple.lighten(90%)),
         (16, purple.lighten(90%)),
         (17, purple.lighten(90%)),
         (18, purple.lighten(90%)),
         (19, purple.lighten(90%)),
         (20, purple.lighten(90%)),
         (21, purple.lighten(90%)),
         (22, purple.lighten(90%)),
         (23, purple.lighten(90%)),
         (24, purple.lighten(70%)),

         (25, orange.lighten(90%)),
         (26, orange.lighten(70%)),

         (27, maroon.lighten(90%)),
         (28, maroon.lighten(30%)),

         (29, red.lighten(20%)),
       ),
       highlights: (
         // Operations
         (line: 1, start: 0, end: 6, fill: yellow),
         (line: 2, start: 3, end: 11, fill: yellow),
         (line: 8, start: 5, end: 16, fill: yellow),
         (line: 12, start: 7, end: 18, fill: yellow),
         (line: 15, start: 14, end: 26, fill: yellow),
         (line: 16, start: 14, end: 26, fill: yellow),
         (line: 17, start: 14, end: 23, fill: yellow),
         (line: 18, start: 14, end: 26, fill: yellow),
         (line: 19, start: 14, end: 23, fill: yellow),
         (line: 20, start: 9, end: 22, fill: yellow),
         (line: 22, start: 9, end: 27, fill: yellow),
         (line: 25, start: 7, end: 25, fill: yellow),
         // Attributes
         (line: 4, start: 5, fill: green),
         (line: 5, start: 5, fill: green),
         (line: 15, start: 43, end: 60, fill: green),
         (line: 16, start: 43, end: 60, fill: green),
         (line: 18, start: 50, end: 60, fill: green),
         (line: 20, start: 50, end: 60, fill: green),
         (line: 24, start: 11, end: 72, fill: green),
         (line: 26, start: 9, end: 70, fill: green),
         // Location Information
         (line: 15, start: 95, fill: blue),
         (line: 16, start: 95, fill: blue),
         (line: 17, start: 54, fill: blue),
         (line: 18, start: 102, fill: blue),
         (line: 19, start: 53, fill: blue),
         (line: 20, start: 106, fill: blue),
         (line: 24, start: 91, fill: blue),
         (line: 26, start: 89, fill: blue),
         // Symbols
         (line: 1, start: 8, end: 21, fill: navy),
         (line: 2, start: 13, end: 27, fill: navy),
         // Dialects
         (line: 2, start: 3, end: 6, fill: olive),
         (line: 8, start: 6, end: 11, fill: olive),
         (line: 12, start: 8, end: 13, fill: olive),
         (line: 15, start: 15, end: 20, fill: olive),
         (line: 16, start: 15, end: 20, fill: olive),
         (line: 17, start: 15, end: 17, fill: olive),
         (line: 18, start: 15, end: 20, fill: olive),
         (line: 19, start: 15, end: 17, fill: olive),
         (line: 20, start: 10, end: 15, fill: olive),
         (line: 22, start: 10, end: 15, fill: olive),
         (line: 25, start: 8, end: 13, fill: olive),
         // Type System
         (line: 2, start: 36, end: 40, fill: fuchsia),
         (line: 2, start: 50, end: 62, fill: fuchsia),
         (line: 2, start: 72, end: 84, fill: fuchsia),
         (line: 2, start: 94, end: 106, fill: fuchsia),
         (line: 10, start: 17, end: 21, fill: fuchsia),
         (line: 13, start: 19, end: 23, fill: fuchsia),
         (line: 15, start: 65, end: 93, fill: fuchsia),
         (line: 16, start: 65, end: 93, fill: fuchsia),
         (line: 17, start: 36, end: 52, fill: fuchsia),
         (line: 18, start: 65, end: 100, fill: fuchsia),
         (line: 19, start: 35, end: 51, fill: fuchsia),
         (line: 20, start: 65, end: 104, fill: fuchsia),
         (line: 22, start: 33, end: 40, fill: fuchsia),
         (line: 24, start: 77, end: 89, fill: fuchsia),
         (line: 25, start: 31, end: 40, fill: fuchsia),
         (line: 26, start: 75, end: 87, fill: fuchsia),
       ),
     )
     ```mlir
     module @kernel_module {
       func.func @compute_kernel(%arg0: index, %arg1: memref<?xf32>, %arg2: memref<?xf32>, %arg3: memref<?xf32>) {
         // Attribute aliases can be forward-declared.
         #map1 = (d0, d1) -> (d0 + d1)
         #map3 = ()[s0] -> (s0)

         // Ops may have regions attached.
         "affine.for"(%arg0) ({
         // Regions consist of a CFG of blocks with arguments.
         ^bb0(%arg4: index):
           // Block are lists of operations.
           "affine.for"(%arg0) ({
           ^bb0(%arg5: index):
             // Ops use and define typed values, which obey SSA.
             %0 = "affine.load"(%arg1, %arg4) {map = (d0) -> (d0)} : (memref<?xf32>, index) -> f32 loc("kernel.c":10:12)
             %1 = "affine.load"(%arg2, %arg5) {map = (d0) -> (d0)} : (memref<?xf32>, index) -> f32 loc("kernel.c":11:12)
             %2 = "std.mulf"(%0, %a1) : (f32, f32) -> f32 loc(fused["kernel.c":12:15, "params.h":5:2])
             %3 = "affine.load"(%arg3, %arg4, %arg5) {map = #map1} : (memref<?xf32>, index, index) -> f32 loc("kernel.c":13:8)
             %4 = "std.addf"(%3, %2) : (f32, f32) -> f32 loc("kernel.c":13:14)
             "affine.store"(%4, %arg3, %arg4, %arg5) {map = #map1} : (f32, memref<?xf32>, index, index) -> () loc("kernel.c":13:5)
             // Blocks end with a terminator Op.
             "affine.terminator"() : () -> ()
           // Ops have a list of attributes.
           }) {lower_bound = () -> (0), step = 1 : index, upper_bound = #map3} : (index) -> () loc("kernel.c":9:5)
           "affine.terminator"() : () -> ()
         }) {lower_bound = () -> (0), step = 1 : index, upper_bound = #map3} : (index) -> () loc("kernel.c":8:3)
         return
       }
     }
     ```
 ]
 ]
]

#centered-slide[
  = But, a custom syntax?

 #side-by-side(columns: (1fr, 1fr))[
   #align(center)[Before]
   #text(size: 0.26em)[
     #codly(
       highlighted-lines: (
         (1, red.lighten(70%)),

         (2, maroon.lighten(70%)),
         (3, maroon.lighten(90%)),
         (4, maroon.lighten(90%)),
         (5, maroon.lighten(90%)),
         (6, maroon.lighten(90%)),
         (7, maroon.lighten(90%)),

         (8, orange.lighten(70%)),
         (9, orange.lighten(80%)),
         (10, orange.lighten(80%)),
         (11, orange.lighten(90%)),

         (12, purple.lighten(70%)),
         (13, purple.lighten(80%)),
         (14, purple.lighten(90%)),
         (15, purple.lighten(90%)),
         (16, purple.lighten(90%)),
         (17, purple.lighten(90%)),
         (18, purple.lighten(90%)),
         (19, purple.lighten(90%)),
         (20, purple.lighten(90%)),
         (21, purple.lighten(90%)),
         (22, purple.lighten(90%)),
         (23, purple.lighten(90%)),
         (24, purple.lighten(70%)),

         (25, orange.lighten(90%)),
         (26, orange.lighten(70%)),

         (27, maroon.lighten(90%)),
         (28, maroon.lighten(70%)),

         (29, red.lighten(70%)),
       ),
     )
     ```mlir
     module @kernel_module {
       func.func @compute_kernel(%arg0: index, %arg1: memref<?xf32>, %arg2: memref<?xf32>, %arg3: memref<?xf32>) {
         // Attribute aliases can be forward-declared.
         #map1 = (d0, d1) -> (d0 + d1)
         #map3 = ()[s0] -> (s0)

         // Ops may have regions attached.
         "affine.for"(%arg0) ({
         // Regions consist of a CFG of blocks with arguments.
         ^bb0(%arg4: index):
           // Block are lists of operations.
           "affine.for"(%arg0) ({
           ^bb0(%arg5: index):
             // Ops use and define typed values, which obey SSA.
             %0 = "affine.load"(%arg1, %arg4) {map = (d0) -> (d0)} : (memref<?xf32>, index) -> f32 loc("kernel.c":10:12)
             %1 = "affine.load"(%arg2, %arg5) {map = (d0) -> (d0)} : (memref<?xf32>, index) -> f32 loc("kernel.c":11:12)
             %2 = "std.mulf"(%0, %a1) : (f32, f32) -> f32 loc(fused["kernel.c":12:15, "params.h":5:2])
             %3 = "affine.load"(%arg3, %arg4, %arg5) {map = #map1} : (memref<?xf32>, index, index) -> f32 loc("kernel.c":13:8)
             %4 = "std.addf"(%3, %2) : (f32, f32) -> f32 loc("kernel.c":13:14)
             "affine.store"(%4, %arg3, %arg4, %arg5) {map = #map1} : (f32, memref<?xf32>, index, index) -> () loc("kernel.c":13:5)
             // Blocks end with a terminator Op.
             "affine.terminator"() : () -> ()
           // Ops have a list of attributes.
           }) {lower_bound = () -> (0), step = 1 : index, upper_bound = #map3} : (index) -> () loc("kernel.c":9:5)
           "affine.terminator"() : () -> ()
         }) {lower_bound = () -> (0), step = 1 : index, upper_bound = #map3} : (index) -> () loc("kernel.c":8:3)
         return
       }
     }
     ```
 ]
 ][
  #align(center)[After]
  #text(size: 0.26em)[
     #codly(
       highlighted-lines: (
         (1, red.lighten(70%)),

         (2, maroon.lighten(70%)),
         (3, maroon.lighten(90%)),
         (4, maroon.lighten(90%)),
         (5, maroon.lighten(90%)),
         (6, maroon.lighten(90%)),
         (7, maroon.lighten(90%)),

         (8, orange.lighten(70%)),
         (9, orange.lighten(90%)),
         (10, orange.lighten(90%)),
         (11, orange.lighten(90%)),

         (12, purple.lighten(70%)),
         (13, purple.lighten(90%)),
         (14, purple.lighten(90%)),
         (15, purple.lighten(90%)),
         (16, purple.lighten(90%)),
         (17, purple.lighten(90%)),
         (18, purple.lighten(90%)),
         (19, purple.lighten(90%)),
         (20, purple.lighten(90%)),
         (21, purple.lighten(90%)),
         (22, purple.lighten(90%)),
         (23, purple.lighten(90%)),
         (24, purple.lighten(70%)),

         (25, orange.lighten(90%)),
         (26, orange.lighten(70%)),

         (27, maroon.lighten(90%)),
         (28, maroon.lighten(70%)),

         (29, red.lighten(70%)),
       ),
    )
    ```mlir
    module @kernel_module {
      func.func @compute_kernel(%N: index, %A: memref<?xf32>, %B: memref<?xf32>, %C: memref<?xf32>) {




        // Outer loop: iterates from 0 to %N
        affine.for %i = 0 to %N {


          // Inner loop: iterates from 0 to %N
          affine.for %j = 0 to %N {
            
            // Load values from input memrefs using affine identifiers
            %val_a = affine.load %A[%i] : memref<?xf32>
            %val_b = affine.load %B[%j] : memref<?xf32>
            // Floating point multiplication using the Arith dialect
            %prod = arith.mulf %val_a, %val_b : f32
            // Accessing memory with a compound affine expression [%i + %j]
            %val_c = affine.load %C[%i + %j] : memref<?xf32>
            %sum = arith.addf %val_c, %prod : f32
            // Store the final computed value back into the destination memref
            affine.store %sum, %C[%i + %j] : memref<?xf32>
          }

        }
        return
      }
    }
    ```
 ]
 ]
]

#simple-slide[
  = Putting it all together

  #text(size: 0.6em)[
    #codly()
    ```mlir
    module @kernel_module {
        func.func @compute_kernel(%N: index, %A: memref<?xf32>, %B: memref<?xf32>, %C: memref<?xf32>) {
            affine.for %i = 0 to %N {
                affine.for %j = 0 to %N {
                    %val_a = affine.load %A[%i] : memref<?xf32>
                    %val_b = affine.load %B[%j] : memref<?xf32>
                    %prod = arith.mulf %val_a, %val_b : f32
                    %val_c = affine.load %C[%i + %j] : memref<?xf32>
                    %sum = arith.addf %val_c, %prod : f32
                    affine.store %sum, %C[%i + %j] : memref<?xf32>
                }
            }
            return
        }
    }
    ```
 ]
]


#centered-slide[
  = The `mlir-showcase` Repository

  #align(center)[
    #link("https://github.com/FedericoBruzzone/mlir-showcase")[github.com/FedericoBruzzone/mlir-showcase]

    #qr-code("https://github.com/FedericoBruzzone/mlir-showcase", width: 8cm)
  ]
]

#simple-slide[
  == IREE: Intermediate Representation Execution Environment 

  #side-by-side(columns: (2fr, 4fr))[
    #align(horizon + center)[
    *IREE* @Liu22#footnote[
      #link("https://github.com/iree-org/iree")[https://github.com/iree-org/iree]
    ]  is an MLIR-based end-to-end compiler and runtime that lowers ML models to a unified IR that scales to meet the needs of the _datacenter_ and _mobile/edge_ deployments.
  ]
  ][
   #move(dy: 20pt, dx: 100pt)[
   #scale(120%)[
   #figure(
    image("images/iree_architecture.svg", width: 45%),
      numbering: none,
      caption: [],
    )
    ]
  ]
  ]
]

#simple-slide[#align(horizon)[
  = Export the TensorFlow Model

  #side-by-side(columns: (3fr, 2fr))[
    #text(0.5em)[
    ```python
    import os
    import tensorflow as tf
    # Load the pre-trained MobileNetV2 model with ImageNet weights
    model = tf.keras.applications.MobileNetV2(weights="imagenet")
    # Export the model as a TF SavedModel (temporary, with default signatures)
    model.export("mobilenet_v2_saved_model")
    # Reload the exported SavedModel
    loaded_model = tf.saved_model.load("mobilenet_v2_saved_model")
    # Create a concrete function with a fixed batch size input signature
    @tf.function(input_signature=[tf.TensorSpec([1, 224, 224, 3], tf.float32)])
    def serve(input): 
      return loaded_model.signatures["serve"](input)
    # Re-save the model with the fixed input signature
    tf.saved_model.save(
      loaded_model, "mobilenet_v2_saved_model", signatures={"serve": serve})
    ``` 
    ]
  ][
    #text(0.32em)[
    #codly(zebra-fill: none)
    ```
    ├── mobilenet_v2_saved_model/             # Exported TF SavedModel directory
    │   ├── saved_model.pb                    #   Graph definition + signatures 
    │   ├── fingerprint.pb                    #   Model integrity hash 
    │   ├── assets/                           #   Extra assets 
    │   └── variables/                        #   Model weights
    │       ├── variables.data-00000-of-00001 # Actual weight values (binary)
    │       └── variables.index               # Index/lookup for the weight shards
    ```
    #codly(zebra-fill: luma(240))
  ]



  #text(0.7em)[We expect the model to have a *single* signature named `serve` that takes a single input tensor and produces a single output tensor.]

  #text(0.32em)[
    ```bash
    python signatures.py
    ```
    #codly(zebra-fill: none) 
    ```
    Signatures found: ['serve']
    ```
    #codly(zebra-fill: luma(240))

    ] 

  ]
]]

#simple-slide[
  = Import the Model into MLIR

  #side-by-side(columns: (1fr, 2fr))[
    #align(horizon + center)[
    #text(0.5em)[
    Convert the TensorFlow SavedModel into MLIR 
    ```bash
    iree-import-tf \
      mobilenet_v2_saved_model \
      --tf-import-type=savedmodel_v1 \
      --tf-savedmodel-exported-names=serve \
      -o mobilenet_v2.mlirbc    
    ```

    From MLIR bitcode to a human-readable MLIR file
    ```bash
    iree-ir-tool \
      copy mobilenet_v2.mlirbc \ 
      -o mobilenet_v2_readable.mlir
    ```

    Compile to a VM FlatBuffer
    ```bash
    iree-compile \
      mobilenet_v2.mlirbc \
      --iree-hal-target-backends=llvm-cpu \
      -o mobilenet_v2.vmfb
    ```
    ]
  ]
  ][
    #text(0.25em)[
    ```mlir
    module {
      ml_program.global public @"vars.block_10_depthwise/kernel_1"(dense<"..."> : tensor<3x3x384x1xf32>) : tensor<3x3x384x1xf32>
      ...
      ml_program.global public @"vars.block_10_project_BN/gamma_1"(dense<[1.99929357, ..., 1.9186883]> : tensor<96xf32>) : tensor<96xf32>
      ml_program.global public @"vars.block_11_project_BN/beta_1"(dense<[-0.00110509305, ..., 8.97456601E-4]> : tensor<96xf32>) : tensor<96xf32>
      ...
      func.func @session_initializer() { return }
      func.func @serve(%arg0: tensor<1x224x224x3xf32>) -> tensor<1x1000xf32> {
        %cst = stablehlo.constant dense<0.000000e+00> : tensor<f32>
        %cst_0 = stablehlo.constant dense<6.000000e+00> : tensor<f32>
        ...
        %vars.block_10_depthwise2Fkernel_1 = ml_program.global_load @"vars.block_10_depthwise/kernel_1" : tensor<3x3x384x1xf32>
        %vars.block_10_depthwise_BN2Fmoving_variance_1 = ml_program.global_load @"vars.block_10_depthwise_BN/moving_variance_1" : tensor<384xf32>
        ...
        %vars.bn_Conv12Fgamma_1 = ml_program.global_load @"vars.bn_Conv1/gamma_1" : tensor<32xf32>
        %vars.bn_Conv12Fbeta_1 = ml_program.global_load @"vars.bn_Conv1/beta_1" : tensor<32xf32>
        ...
        %vars.predictions2Fbias_1 = ml_program.global_load @"vars.predictions/bias_1" : tensor<1000xf32>
        %vars.predictions2Fkernel_1 = ml_program.global_load @"vars.predictions/kernel_1" : tensor<1280x1000xf32>
        ...
        %0 = stablehlo.add %vars.block_10_depthwise_BN2Fmoving_variance_1, %cst_3 : tensor<384xf32>
        %1 = stablehlo.rsqrt %0 : tensor<384xf32>
        %2 = stablehlo.multiply %1, %vars.block_10_depthwise_BN2Fgamma_1 : tensor<384xf32>
        %3 = stablehlo.multiply %vars.block_10_depthwise_BN2Fmoving_mean_1, %2 : tensor<384xf32>
        %4 = stablehlo.subtract %vars.block_10_depthwise_BN2Fbeta_1, %3 : tensor<384xf32>
        %5 = stablehlo.add %vars.block_10_expand_BN2Fmoving_variance_1, %cst_3 : tensor<384xf32>
        %6 = stablehlo.rsqrt %5 : tensor<384xf32>
        %7 = stablehlo.multiply %6, %vars.block_10_expand_BN2Fgamma_1 : tensor<384xf32>
        %8 = stablehlo.multiply %vars.block_10_expand_BN2Fmoving_mean_1, %7 : tensor<384xf32>
        %9 = stablehlo.subtract %vars.block_10_expand_BN2Fbeta_1, %8 : tensor<384xf32>
        ...
        %596 = stablehlo.reduce(%595 init: %cst_1) applies stablehlo.add across dimensions = [1] : (tensor<1x1000xf32>, tensor<f32>) -> tensor<1xf32>
        %597 = stablehlo.reshape %596 : (tensor<1xf32>) -> tensor<1x1xf32>
        %598 = stablehlo.broadcast_in_dim %597, dims = [0, 1] : (tensor<1x1xf32>) -> tensor<1x1000xf32>
        %599 = stablehlo.divide %595, %598 : tensor<1x1000xf32>
        return %599 : tensor<1x1000xf32>
      }
    }
    ```
    ]
  ]
]

#simple-slide[
  = Generate an Input Tensor and Inference with IREE

  #side-by-side(columns: (3fr, 2fr))[
   #text(0.5em)[
   ```python
   img = Image.open(image_path).convert("RGB")
   img = img.resize((224, 224), Image.BILINEAR)
   input_data = np.array(img, dtype=np.float32)     # shape: (224, 224, 3)
   input_data = input_data / 127.5 - 1.0            # scale to [-1, 1]
   input_data = np.expand_dims(input_data, axis=0)  # shape: (1, 224, 224, 3)
   np.save("input.npy", input_data)
   ```
   ]
   #grid(columns: (45%, 10%, 45%))[
   #figure(
    image("images/dog.jpg", width: 85%),
      numbering: none,
      caption: [],
   )
   ][
     #align(horizon)[$=>$]
   ][
     `     input.npy`

    #text(0.28em)[
    #codly(zebra-fill: none)
     ```
     äãc¿ÒÑQ¿ÞÝ]¿ÞÝ]¿ÒÑQ¿ÜÛ[¿Ø×W¿ÐÏO¿Ø×W¿ÚÙY¿ÆÅE¿Ø×W¿ÜÛ
     [¿ÈÇG¿ÞÝ]¿ÚÙY¿ÄÃC¿ÚÙY¿ÖÕU¿ÌËK¿ÖÕU¿äãc¿ÖÕU¿äãc¿ôós¿ðï
     o¿öõu¿úùy¿üû{¿öõu¿úùy¿ø÷w¿ø÷w¿îím¿ÒÑQ¿îím¿âáa¿º¹9¿æåe¿â
     áa¿¼»;¿èçg¿îím¿ÒÑQ¿ôós¿ø÷w¿òñq¿ø÷w¿üû{¿üû{¿úùy¿ø÷w¿üû{¿üû
     {¿öõu¿úùy¿ø÷w¿úùy¿úùy¿úùy¿úùy¿úùy¿ø÷w¿úùy¿üû{¿öõu¿ôós¿úùy¿
     öõu¿úùy¿úùy¿ø÷w¿úùy¿üû{¿ø÷w¿ôós¿úùy¿öõu¿üû{¿üû{¿ø÷w¿úùy¿üû{
     ¿öõu¿úùy¿úùy¿öõu¿öõu¿ø÷w¿öõu¿öõu¿úùy¿ø÷w¿öõu¿úùy¿ø÷w¿ø÷w¿ú
     ùy¿ø÷w¿ø÷w¿úùy¿úùy¿ôós¿ðïo¿ôós¿òñq¿èçg¿îím¿ðïo¿ìëk¿ôós¿òñq¿
     òñq¿ðïo¿úùy¿úùy¿ôós¿ø÷w¿úùy¿öõu¿ø÷w¿öõu¿òñq¿îím¿ðïo¿ìëk¿îím
     ¿ìëk¿îím¿ìëk¿îím¿êéi¿êéi¿îím¿ìëk¿ìëk¿ðïo¿ðïo¿öõu¿öõu¿ôós¿öõu¿
     úùy¿ø÷w¿ðïo¿ø÷w¿öõu¿ÚÙY¿ìëk¿ôós¿ðïo¿úùy¿öõu¿öõu¿úùy¿öõu¿ôós¿ø÷
     ```
    #codly(zebra-fill: luma(240))
   ]
   ]
  ][
    #text(0.32em)[
    From the command line, we can now run the model with the generated input:
    ```bash
    iree-run-module \
      --module=mobilenet_v2.vmfb \
      --function=serve \
      --input=@input.npy
    ```

    #codly(zebra-fill: none)
    ```
    EXEC @serve
    result[0]: hal.buffer_view
    1x1000xf32=[0.000165652 0.000151373 1.42592E-05 5.92925E-05 6.70149E-05 0.000341131 0.000198785 0.000122406 0.00149087 4.39386E-05 3.3403E-05 5.3721E-05 5.35976E-05 1.82398E-05 9.94686E-05 9.30952E-05 6.3427E-05 0.000141799 3.17409E-05 3.06959E-05 6.87135E-05 0.000216699 6.09083E-05 7.07725E-05 2.60562E-05 0.000153595 0.000109031 0.000178287 5.53506E-05 0.000147815 0.000209688 0.000162711 0.000243295 1.71809E-05 0.000100425 1.57999E-05 0.000125091 0.000178397 6.25113E-05 7.59963E-05 9.62788E-05 3.86099E-05 0.00012561 3.23711E-05 4.97341E-05 6.13783E-05 0.000138996 6.39329E-05 4.45096E-05 6.67697E-05 9.46544E-05 3.5926E-05 0.000204062 0.000292093 0.000488473 9.58151E-05 8.47943E-05 0.000123163 9.52857E-05 6.79532E-05 0.000132884 0.000117373 4.67249E-05 2.62787E-05 6.68047E-05 6.79969E-05 4.83555E-05 4.88604E-05 4.05947E-05 4.22143E-05 0.000371253 6.22883E-05 0.000116463 4.35457E-05 0.000192234 8.1999E-05 3.30845E-05 3.31993E-05 5.05881E-05 8.58546E-05 0.00010195 0.000208427 0.000207405 0.000130688 0.00011813 0.000120608 0.000313725 2.05671E-05 1.96285E-05 0.000157798 5.57028E-05 0.000126693 3.22056E-05 8.02654E-05 5.05778E-05 7.28497E-05 5.03175E-05 5.17303E-05 3.78772E-05 6.13501E-05 0.000115919 3.76777E-05 4.29638E-05 1.85399E-05 0.00484446 2.68151E-05 0.000148926 4.33687E-05 0.000137578 5.64227E-05 0.000435291 2.82973E-05 0.000133121 0.000222104 0.000252791 0.00011586 9.6491E-05 8.42967E-05 3.2464E-05 4.53697E-05 7.99469E-05 3.44823E-05 0.000181173 7.79511E-05 3.11126E-05 2.99579E-05 2.87822E-05 4.67909E-05 4.98542E-05 6.87359E-05 3.60754E-05 4.29585E-05 0.000123788 3.78884E-05 9.59466E-05 8.39355E-05 4.71987E-05 5.8172E-05 4.268E-05 4.00027E-05 3.32925E-05 8.46946E-05 9.10055E-05 4.89413E-05 7.85801E-05 4.35644E-05 3.85596E-05 7.80505E-05 0.000174066 0.000159893 0.000121992 0.000767081 0.00228256 0.000558238 0.000662587 1.34811E-05 3.92131E-05 0.0026327 9.529E-05 7.68284E-05 3.47142E-05 5.47353E-06 7.5111E-06 8.991E-06 3.45787E-05 1.31357E-05 1.15983E-05 4.08218E-06 1.22294E-05 6.40326E-05 5.27259E-05 4.69403E-05 9.65662E-06 8.58458E-05 0.000155262 3.94623E-05 1.61538E-05 1.289E-05 2.22543E-05 0.000125113 6.12213E-05 6.69415E-06 2.30811E-05 4.93018E-05 3.2618E-05 0.000193106 ... 0.000102141]
    ```
    #codly(zebra-fill: luma(240))
    ]
  ]
]

#simple-slide[
  = How to Interpret the Output? Let's Post-process it!

  #side-by-side(columns: (3fr, 2fr))[
  #text(0.35em)[
  ```python
  # 1. Load ImageNet class names.
  categories = load_imagenet_classes(os.path.join(SCRIPT_DIR, "imagenet_classes.txt"))
  # 2. Configure the IREE runtime (CPU via the local-task driver).
  config = ireert.Config(driver_name="local-task")
  # 3. Load the compiled module (.vmfb).
  ctx = ireert.SystemContext(config=config)
  with open(args.model, "rb") as f:
    vm_module = ireert.VmModule.copy_buffer(ctx.instance, f.read())
  ctx.add_vm_module(vm_module)
  # 4. Preprocess the input image.
  input_data = preprocess_image(args.image)
  # 5. Invoke the "serve" function (synchronous).
  serve = ctx.modules.module["serve"]
  output = serve(input_data)
  # 6. Convert logits to probabilities via softmax.
  logits = np.asarray(output).flatten()
  probabilities = softmax(logits)
  # 7. Print results: top-N predictions with class names.
  print(f"\nOutput shape: {list(np.asarray(output).shape)}")
  top_k = min(args.top, len(probabilities))
  top_indices = np.argsort(probabilities)[::-1][:top_k]
  print(f"\nTop-{top_k} predictions:")
  print(f"{'Rank':<6} {'Class':<30} {'Probability':>12}")
  print("-" * 50)
  for rank, idx in enumerate(top_indices, start=1):
    print(f"{rank:<6} {categories[idx]:<30} {probabilities[idx]:>11.4%}")
  ```
  ]][
    #text(0.32em)[
    `imagenet_classes.txt`:

    #codly(zebra-fill: none)
    ```
    tench
    goldfish
    great white shark
    ...
    Samoyed
    ...
    bolete
    ear
    toilet tissue

    ```
    #codly(zebra-fill: luma(240))

    #v(2em)
    The final output of the post-processing script should look like this:

    ```
    Loaded image: dog.jpg  (original size: 1546×1213)
    Running inference...
  
    Output shape: [1, 1000]
  
    Top-5 predictions:
    Rank   Class                           Probability
    --------------------------------------------------
    1      Samoyed                            0.1990%
    2      Arctic fox                         0.1081%
    3      Pomeranian                         0.1070%
    4      keeshond                           0.1015%
    5      Persian cat                        0.1009%
    ```
    ]
  ]
]

#title-slide[

  #side-by-side(columns: (1fr, 6fr, 1fr))[
    #move(dy: -30pt, dx: 50pt)[
      #grid(
        move(dx: 60pt, dy: 150pt)[
          #figure(
            image("images/logo-lab-faded.pdf", width: 50%),
              numbering: none,
              caption: [],
          )
        ],
        figure(
          image("images/minerva-new.pdf", width: 100%),
          numbering: none,
          caption: [],
        )
      )

    ]
  ][
    #h(1.5em)

    = Thank You!

    *#text(fill: foreground)[Federico Bruzzone,  PhD Candidate]*

    #text(0.8em)[
    ADAPT Lab -- University of Milan \
    #h(1.5em) Website: #link("https://federicobruzzone.github.io/")[federicobruzzone.github.io] \
    #h(1.5em) Github: #link("https://github.com/FedericoBruzzone")[github.com/FedericoBruzzone] \
    #h(1.5em) Email: #link("mailto:federico.bruzzone@unimi.it")[federico.bruzzone\@unimi.it] \
    #h(1.5em) Slides: #link("https://federicobruzzone.github.io/activities/presentations/MLIR.pdf")[federicobruzzone.github.io/activities/presentations/MLIR.pdf]
    ]
  ][
    #move(dy: 10pt, dx: -50pt)[
      #qr-code("https://federicobruzzone.github.io/activities/presentations/MLIR.pdf", width: 4cm)
    ]
  ]
]

// #hidden-bibliography(
#text(small-size)[
  #bibliography("local.bib")
]
// )
