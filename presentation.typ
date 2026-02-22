#import "./theme/fcb.typ": *
#import "@preview/cades:0.3.1": qr-code

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()
// #codly(zebra-fill: none)
#codly(number-format: none) // #codly(number-format: it => [#it])
#codly(languages: codly-languages)

#let background = white 
#let foreground = navy
#let link-background = maroon // eastern
#let header-footer-foreground = maroon.lighten(50%)

#show strong: it => text(fill: link-background, it)


#let small-size = 0.7em
#let big-size = 1.3em

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
  = MLIR: Scaling Compiler Infrastructure for Domain Specific Computation @Latter21

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
      #h(1.5em) Slides: #link("TODO")[TODO]
    ] PhD Candidate

    // Milan, Italy -- #datetime.today().display("[day] [month repr:long] [year repr:full]")
    Milan, Italy -- 18 March 2026
  ][
    #move(dy: 10pt, dx: -50pt)[
      #qr-code("TODO", width: 4cm)
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
  = Little Builtin, Everything Customizable _[*Parsimony*]_

  - The system is based on a minimal number of fundamental concepts, leaving most of the intermediate representation fully *customizable*.

  - A handful of abstractions---types, operations and attributes---should be used to express _everything else_, allowing fewer and more consistent abstractions that are easy to *comprehend*, *extend*, and *adopt*.

  - A success criterion for customization is the possibility to express a diverse set of abstractions including *ML graphs*, ASTs, mathematical abstractions such as *polyhedral*, CFGs and instruction-level IRs such as *LLVM IR*, without hard-coding concepts.

]

#simple-slide[
  = SSA and Regions _[*Parsimony*]_

  *SSA* @Cytron91 makes dataflow analysis _simple_ and _sparse_. However, while many existing IRs use a flat, linearized CFG, representing higher level abstractions push introducing *nested regions*#footnote[
    A region is a single-entry, multi-exit CFG that can be nested inside an operation. It is a generalization of the concept of basic blocks and allows for more flexible control flow representation.
  ] as a first-class citizen.


]

#simple-slide[
  = Maintain Higher-Level Semantics  _[*Progressivity*]_


]

#simple-slide[
  = Declaration and Validation _[*Parsimony*|*Traceability*]_


]

#simple-slide[
  = Source Location Tracking _[*Traceability*]_


]

// #focus-slide[
//   In the absence of either empirically measured or theoretically justified performance issues, programmers should *avoid* making optimizations based *solely* on assumptions about potential performance gains.
// ]

// #centered-slide[
//   = Optimizing Compilers

//   #v(0.5em)

//   Compilers use information collected during analysis passes to guide transformations.

//   *Compiler optimizations* are such transformations (say _meaning-preserving mappings_) applied to the input code to improve certain aspects---such as performance, resource utilization, and power consumption---without altering its observable behavior.

//   In accordance with the literature, such compilers are referred to as *optimizing compilers*.
// ]



// #simple-slide[
//   ===== Machine Learning Framework are Just Optimizing Compilers
//   #move(dx: 3cm)[
//     #side-by-side(columns: (1fr, 3fr))[
//       // #figure(
//       //   image("images/ml-comp-cg.png", width: 170%),
//       //   numbering: none,
//       //   caption: [],
//       // )
//     ][
//       // #figure(
//       //   image("images/ml-comp.png", width: 70%),
//       //   numbering: none,
//       //   caption: [],
//       // )
//     ]
//   ]
// ]

// #simple-slide[
//   #codly(number-format: it => [#it])

//   = Peephole Optimizations in x86-64

//   #side-by-side(columns: (1fr, 1fr))[
//     #align(horizon)[#text(small-size)[

//         #codly(highlights: (
//           (line: 3, start: 0, fill: red),
//         ))
//         ```asm
//         ; x = x * 2, s.t. x: i32
//         mov     eax, dword ptr [rbp - 4]
//         imul    eax, 2
//         mov     dword ptr [rbp - 4], eax
//         ```

//         #align(center)[
//           The optimized version replaces the multiplication by 2 with a *more efficient* binary shift operation.
//         ]
//         #codly(highlights: (
//           (line: 3, start: 0, fill: green),
//         ))
//         ```asm
//         ; x = x << 1, s.t. x: i32
//         mov    eax, dword ptr [rbp - 4]
//         shl    eax
//         mov    dword ptr [rbp - 4], eax
//         ```
//     ]]][
//     #align(horizon)[#text(small-size)[
//         #codly(highlights: (
//           (line: 3, start: 0, fill: red),
//         ))
//         ```asm
//         ; x = x + 0, s.t. x: i32
//         mov     eax, dword ptr [rbp - 4]
//         add     eax, 0
//         mov     dword ptr [rbp - 4], eax
//         ```

//         #align(center)[
//           The optimized version removes the *unnecessary* addition operation.
//         ]

//         ```asm
//         mov     eax, dword ptr [rbp - 4]
//         mov     dword ptr [rbp - 4], eax
//         ```

//         #align(horizon)[#text(small-size)[
//           #align(center)[
//             #block(
//               fill: red.lighten(80%),
//               stroke: red,
//               inset: 5pt,
//               radius: 5pt,
//             )[The `mov` instructions are redundant and can be *pruned* as well!]
//           ]]]
//     ]]]

//   #codly(number-format: none)
// ]

// #simple-slide[
//   ===== Loop Nest Optimizations --- Loop Tiling

//   #v(1em)

//   #side-by-side(columns: (40%, 20%, 40%))[
//     #align(horizon)[#text(small-size)[
//         #codly(highlights: (
//           (line: 3, start: 24, end: 27, fill: red),
//         ))
//         ```cpp
//         for (int i=0; i<n; ++i) {
//           for (int j=0; j<m; ++j) {
//               c[i][j] = a[i] * b[j];
//           }
//         }
//         ```

//         #align(center)[
//           The vector `b` *may not* fit into a line of CPU cache, causing multiple cache misses during the inner loop.

//           It implies multiple *fetches* from the main memory, which is *slow*.
//         ]
//     ]]][
//     #move(dy: 10pt)[
//       // #figure(
//       //   image("images/loop-tiling-raw.png", width: 54%),
//       //   numbering: none,
//       //   caption: [],
//       // )

//       // #figure(
//       //   image("images/loop-tiling-2.png", width: 54%),
//       //         numbering: none,
//       //         caption: [#text(tiny-size)[#link(
//       //           "https://colfaxresearch.com/how-series/#ses-10",
//       //         )[A. Vladimirov, Session 10]]],
//       //       )
//     ]
//   ][
//       #move(dx: -50pt, dy: 50pt)[
//         #align(center)[
//           #text(tiny-size)[
//             The inner loop works on a *tile* of `b` that fits into the cache.

//             #codly(highlights: (
//               (line: 1, start: 26, end: 40, fill: green),
//               (line: 3, start: 26, end: 51, fill: green),
//               (line: 4, start: 23, end: 26, fill: red),
//             ))
//             ```cpp
//             for (int jj = 0; jj < m; jj += TILE_SIZE)
//                 for (int i = 0; i < n; ++i)
//                     for (int j = jj; j < MIN(jj + TILE_SIZE, m); ++j)
//                         c[i][j] = a[i] * b[j];
//             ```
//           ]]]

//       #move(dx: -50pt, dy: 50pt)[
//         #text(tiny-size)[
//           #align(center)[
//           #move(dy: -10pt)[
//               #block(
//                 fill: red.lighten(80%),
//                 stroke: red,
//                 inset: 5pt,
//                 radius: 5pt,
//               )[
//                 Careful readers may notice that, in this version, the values for the array `a` will be read `m / TILE_SIZE`!
//           ]]]
//           #codly(highlights: (
//             (line: 1, start: 26, end: 42, fill: green),
//             (line: 3, start: 22, end: 48, fill: green),
//           ))
//           ```cpp
//           for (int ii = 0; ii < n; ii += TILE_SIZE_I)
//             for (int jj = 0; jj < m; jj += TILE_SIZE_J)
//               for (int i = ii; i < MIN(n, ii + TILE_SIZE_I); i++)
//                 for (int j = jj; j < MIN(m, jj + TILE_SIZE_J); j++)
//                   c[i][j] = a[i] * b[j];
//           ```
//         ]]
//   ]
// ]

// #simple-slide[
//   = Tail Call/Recursion Optimization

//   #v(2em)

//   #side-by-side(columns: (3fr, 1fr))[
//     #align(horizon + center)[
//       Guy L. Steele, Jr. in 1977 observed that *tail-recursive procedure calls* can be optimized to avoid growing the call stack:

//       _In general, procedure calls may be usefully thought of as GOTO statements which also pass parameters, and can be uniformly coded as [machine code] JUMP instructions._
//     ]][
//     // #figure(
//     //   image("images/steele.jpg", width: 100%),
//     //   numbering: none,
//     //   caption: [],
//     // )
//   ]
// ]


// #simple-slide[
//   ====== From Recursion to Iteration

//   #side-by-side(columns: (3fr, 1fr))[
//       // #set math.cases(reverse: true)
//       // #set math.cases(gap: 1em)
//       $
//         bold(f)(x) = cases(
//           b(x_0) "if" x = x_0,
//           a(x, bold(f)(d(x))) "otherwise"
//         ) \
//         italic("s.t.") a, b, "and so on may denote any pieces of code."
//       $

//       #text(small-size)[
//         To transform recursive function $bold(f)$ into iterative form, we need to:

//         1. Identifies an increment $xor$ to the argument of $bold(f)$, _id est_, $x' = x xor y$ such that $x = italic("prev")(x')$, where $italic("prev")$ is based on the arguments of the recursive call. In this case, $italic("prev")(x) = d(x)$ and, if $d^(-1)$ exists, $x xor y = d^(-1)(x)$, can be plugged in for $y$.
//         2. Derives an incremental program $bold(f)'(x, r)$ that computes $bold(f)(x)$ using an accumulator $r$ of $bold(f)(italic("prev")(x))$.
//         3. Forms an iterative version that initializes using the base case of $bold(f)$ and iteratively applies $bold(f)'$ until reaching the desired argument.
//       ]
//   ][
//       #text(small-size)[
//         #align(horizon)[
//           $
//             & bold(f)(x) = { \
//             & #h(1cm) x_1 = x_0; r = b(x_0); \
//             & #h(1cm) bold("while") (x_1 != x) { \
//             & #h(2cm) x_1 = d^(-1)(x_1); \
//             & #h(2cm) r = a(x_1, r); \
//             & #h(1cm) } \
//             & #h(1cm) bold("return") r; \
//             & }
//           $
//         ]]

//       #align(horizon)[#text(tiny-size)[
//         #align(center)[
//           #block(
//             fill: green.lighten(80%),
//             stroke: green,
//             inset: 5pt,
//             radius: 5pt,
//           )[Note that, when $a$ is in the form $a(a_1(x), y)$ and $a$ is associative, we do not need $d^(-1)$ and $x_1$.]
//         ]]
//       ]
//   ]
// ]

// #centered-slide[
//   = Tail-recursive Factorial Function

//   #side-by-side(columns: (40%, 60%))[
//       #text(tiny-size)[
//         #codly(highlights: (
//           (line: 2, start: 9, end: 14, fill: green),
//           (line: 3, start: 16, end: 16, fill: blue),
//           (line: 3, start: 9, end: 14, fill: yellow),
//           (line: 5, start: 21, end: 25, fill: orange),
//           (line: 5, start: 12, end: 12, fill: teal),
//           (line: 5, start: 14, end: 14, fill: fuchsia),
//           (line: 5, start: 5, end: 10, fill: yellow),
//           (line: 2, start: 5, end: 8, fill: red),
//           (line: 2, start: 15, fill: red),
//           (line: 4, start: 5, end: 5, fill: red),
//           (line: 5, start: 16, end: 20, fill: red),
//           (line: 5, start: 26, fill: red),
//         ))
//         ```cpp
//         int fact(int n) {
//             if (n == 0) {
//                 return 1;
//             }
//             return n * fact(n - 1);
//         }
//         ```

//         The replacement of $n * ((n - 1) * (n - 2))$ by $(n * (n - 1)) * (n - 2)$ is valid due to the *associativity* of multiplication. In the general form:

//         $
//           & bold(f)(x) = { \
//           & #h(1cm) r = b(x_0); \
//           & #h(1cm) bold("while") (x != x_0) { \
//           & #h(2cm) r = a(r, a_1(x)); \
//           & #h(2cm) x = d(x); \
//           & #h(1cm) } \
//           & #h(1cm) bold("return") r; \
//           & }
//         $

//         #align(horizon)[#text(tiny-size)[
//             #align(center)[
//               #block(
//                 fill: red.lighten(80%),
//                 stroke: red,
//                 inset: 5pt,
//                 radius: 5pt,
//               )[Note that, (i) when dealing with IEEE754 numbers, multiplication is *not* strictly associative, and (ii) the latter _might be_ slower due to multiply bigger numbers.]
//             ]]
//         ]
//       ]
//   ][
//       #align(horizon)[#text(tiny-size)[
//         "```bash clang -O3 -S -emit-llvm fact.c -o -```" produces something like: \

//         #codly(highlights: (
//           (line: 3, start: 3, fill: green),
//           (line: 10, start: 3, fill: green),
//           (line: 4, start: 3, end: 13, fill: red),
//           (line: 11, start: 3, end: 12, fill: red),
//           (line: 13, start: 29, end: 29, fill: blue),
//           (line: 7, start: 44, end: 44, fill: blue),
//           (line: 4, start: 16, end: 28, fill: yellow),
//           (line: 11, start: 15, end: 27, fill: yellow),
//           (line: 12, start: 0, end: 7, fill: yellow),
//           (line: 14, start: 3, end: 5, fill: yellow),
//           (line: 8, start: 3, fill: orange),
//           (line: 6, start: 3, end: 8, fill: orange),
//           (line: 6, start: 22, end: 25, fill: orange),
//           (line: 7, start: 3, end: 10, fill: teal),
//           (line: 7, start: 24, end: 27, fill: teal),
//           (line: 9, start: 3, end: 6, fill: teal),
//           (line: 9, start: 10, end: 20, fill: fuchsia),
//           (line: 9, start: 22, end: 27, fill: orange),
//           (line: 9, start: 30, fill: teal),
//           (line: 13, start: 44, end: 47, fill: teal),
//           (line: 4, start: 31, end: 44, fill: maroon.lighten(80%)),
//           (line: 5, start: 0, fill: maroon.lighten(80%)),
//           (line: 6, start: 28, end: 35, fill: maroon.lighten(80%)),
//           (line: 7, start: 30, end: 37, fill: maroon.lighten(80%)),
//           (line: 11, start: 30, fill: maroon.lighten(80%)),
//           (line: 13, start: 50, end: 57, fill: maroon.lighten(80%)),
//         ))
//         ```
//         define i32 @fact(i32 %n)  {
//         entry:
//           %cmp3 = icmp eq i32 %n, 0
//           br i1 %cmp3, label %return, label %if.else
//         if.else:
//           %n.tr5 = phi i32 [ %sub, %if.else ], [ %n, %entry ]
//           %acc.tr4 = phi i32 [ %mul, %if.else ], [ 1, %entry ]
//           %sub = add nsw i32 %n.tr5, -1
//           %mul = mul nsw i32 %n.tr5, %acc.tr4
//           %cmp = icmp eq i32 %sub, 0
//           br i1 %cmp, label %return, label %if.else
//         return:
//           %acc.tr.lcssa = phi i32 [ 1, %entry ], [ %mul, %if.else ]
//           ret i32 %acc.tr.lcssa
//         }
//         ```

//         _The basic blocks related to loop vectorization (for performing SIMD operations) have been omitted for clarity_
//       ]]
//   ]
// ]


// #simple-slide[
//   ===== What About Fibonacci? To Hell With Multiple Recursions!

//   #side-by-side(columns: (40%, 60%))[
//       #align(horizon)[
//       #text(tiny-size)[
//         // #codly(highlights: (
//         //   (line: 2, start: 9, end: 14, fill: green),
//         //   (line: 3, start: 16, end: 16, fill: blue),
//         //   (line: 3, start: 9, end: 14, fill: yellow),
//         //   (line: 5, start: 12, end: 21, fill: maroon),
//         //   (line: 5, start: 5, end: 10, fill: yellow),
//         //   (line: 2, start: 5, end: 8, fill: red),
//         //   (line: 2, start: 15, fill: red),
//         //   (line: 4, start: 5, end: 5, fill: red),
//         //   (line: 5, start: 23, end: 23, fill: fuchsia),
//         //   (line: 5, start: 29, end: 33, fill: orange),
//         //   (line: 5, start: 25, end: 28, fill: red),
//         //   (line: 5, start: 34, fill: red),
//         // ))
//         #codly(highlights: (
//           (line: 5, start: 12, end: 21, fill: red),
//         ))
//         ```cpp
//         int fib(int n) {
//             if (n <= 1) {
//                 return n;
//             }
//             return fib(n - 1) + fib(n - 2);
//         }
//         ```

//         === The LLVM Optimized Version (but human readable)

//         #codly(highlights: (
//           (line: 7, start: 20, end: 29, fill: red),
//         ))
//         ```cpp
//         int fib(int n) {
//             if (n < 2) {
//                 return n;
//             }
//             int acc = 0;
//         loop: /* while (1) { */
//                 int call = fib(n - 1);
//                 acc = call + acc;
//                 if (n < 4) goto ret; /* return acc + (n - 2); */
//                 n = n - 2;
//                 goto loop; /* } */
//         ret:
//             return acc + (n - 2);
//         }
//         ```
//       ]
//       ]
//   ][
//     #text(tiny-size)[

//       #align(center)[
//         Note that, the following LLVM IR is a fixed-point representation of the `fib` function; observable by the output of "```bash opt -passes="default<O3>" -S fib-O3.ll -o -```"
//       ]


//       // #codly(highlights: (
//       //   (line: 6, start: 42, end: 43, fill: blue),
//       //   (line: 7, start: 51, end: 51, fill: blue),
//       //   (line: 15, start: 37, end: 37, fill: blue),
//       //   (line: 16, start: 27, end: 28, fill: blue),
//       //   (line: 15, start: 52, end: 55, fill: teal),
//       //   (line: 16, start: 43, end: 47, fill: orange),
//       //   (line: 3, start: 3, fill: green),
//       //   (line: 12, start: 3, fill: green),
//       //   (line: 4, start: 3, end: 13, fill: red),
//       //   (line: 13, start: 3, end: 12, fill: red),
//       //   (line: 4, start: 16, end: 28, fill: yellow),
//       //   (line: 13, start: 15, end: 27, fill: yellow),
//       //   (line: 14, start: 0, end: 7, fill: yellow),
//       //   (line: 18, start: 3, end: 5, fill: yellow),
//       //   (line: 6, start: 3, end: 8, fill: orange),
//       //   (line: 6, start: 22, end: 26, fill: orange),
//       //   (line: 8, start: 3, fill: maroon),
//       //   (line: 9, start: 3, fill: maroon),
//       //   (line: 10, start: 3, fill: orange),
//       //   (line: 11, start: 22, end: 26, fill: maroon),
//       //   (line: 7, start: 32, end: 35, fill: teal),
//       //   (line: 7, start: 3, end: 18, fill: teal),
//       //   (line: 11, start: 3, end: 6, fill: teal),
//       //   (line: 11, start: 29, fill: teal),
//       //   (line: 17, start: 25, end: 35, fill: fuchsia),
//       //   (line: 4, start: 31, end: 44, fill: maroon.lighten(80%)),
//       //   (line: 5, start: 0, fill: maroon.lighten(80%)),
//       //   (line: 6, start: 29, end: 35, fill: maroon.lighten(80%)),
//       //   (line: 7, start: 38, end: 44, fill: maroon.lighten(80%)),
//       //   (line: 13, start: 30, fill: maroon.lighten(80%)),
//       //   (line: 14, start: 73, end: 80, fill: maroon.lighten(80%)),
//       // ))
//       #codly(highlights: (
//         (line: 8, start: 3, fill: red),
//         (line: 9, start: 11, fill: red),
//       ))
//       ```llvm
//       define i32 @fib(i32 %n) {
//       entry:
//         %cmp6 = icmp slt i32 %n, 2
//         br i1 %cmp6, label %return, label %if.end
//       if.end:
//         %n.tr8 = phi i32 [ %sub1, %if.end ], [ %n, %entry ]
//         %accumulator.tr7 = phi i32 [ %add, %if.end ], [ 0, %entry ]
//         %sub = add nsw i32 %n.tr8, -1
//         %call = tail call i32 @fib(i32 %sub)
//         %sub1 = add nsw i32 %n.tr8, -2
//         %add = add nsw i32 %call, %accumulator.tr7
//         %cmp = icmp samesign ult i32 %n.tr8, 4
//         br i1 %cmp, label %return, label %if.end
//       return:
//         %accumulator.tr.lcssa = phi i32 [ 0, %entry ], [ %add, %if.end ]
//         %n.tr.lcssa = phi i32 [ %n, %entry ], [ %sub1, %if.end ]
//         %accumulator.ret.tr = add nsw i32 %n.tr.lcssa, %accumulator.tr.lcssa
//         ret i32 %accumulator.ret.tr
//       }
//       ```
//     ]
//   ]
// ]

// // #focus-slide[
// //   = So your compiler is unable to _incrementalize_ functions with multiple recursions?
// //   Apparently, yes.
// // ]


// #simple-slide[
//   = The Y. Annie Liu's Incrementalization

//   #align(horizon)[
//   #side-by-side(columns: (1fr, 3fr))[
//     // #figure(
//     //   image("images/liu.png", width: 100%),
//     //   numbering: none,
//     //   caption: [],
//     // )
//   ][
//     #text(small-size)[
//       In 1990, Liu _et al._ have done extensive research on *Incrementalization*.

//       Even in presence of *multiple recursions*, they proposed a _systematic_ approach (_static analysis_ and _semantic-preserving transformations_) to derive an incremental program following the three steps outlined earlier (cf. slide "_From Recursion to Iteration_").

//       But to derive the incremental program (the Step 2.), it builds upon earlier principles --- which, typically rely on user-provided knowledge or a theorem prover.
//     ]
//   ]]
// ]

// #simple-slide[#align(center)[
//   = Conclusions

//  The incrementalization of a program in presence of multiple recursions is *opaque*, and a procedure to automatically perform such transformation seems to be *missing* in the literature.

//   Last week I wrote an email to Liu asking for clarification, and *two* days ago I received a kind reply --- which confirms the above statements.

//   _We are trying to understand whether it is really possible to rely exclusively on static analysis steps to automatically perform the transformation in a “general” setting, at least for a class of functions._
// ]]

#focus-slide[
  = Thank You!
]

// #hidden-bibliography(
#text(small-size)[
  #bibliography("local.bib")
]
// )


// #simple-slide[
//   #side-by-side(columns: (2fr, 1fr))[
//     #align(horizon + center)[
//       === Compilers as Musical Compositions

//       #v(1em)

//       Compilers are frequently perceived as intricate musical compositions---like the unfinished _J. S. Bach’s Art of Fugue_---where mathematical precision and logical interplay guide each part.

//       Every module enters in perfect timing, weaving together a structure that only the keenest ears can fully grasp.
//     ]
//   ][
//     #figure(
//       image("images/opt-comp.png", width: 98%),
//       numbering: none,
//       caption: [#text(tiny-size)[Bacon _et al._, CSUR 1994 @Bacon94]],
//     )
//   ]
// ]
