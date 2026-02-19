# MLIR: Scaling Compiler Infrastructure for Domain Specific Computation

A presentation on the MLIR (Multi-Level Intermediate Representation). In particular, on the paper [MLIR: Scaling Compiler Infrastructure for Domain Specific Computation](https://doi.org/10.1109/CGO51591.2021.9370308) by Lattner et al. (2021), published in the proceedings of the IEEE/ACM International Symposium on Code Generation and Optimization (CGO).

<details>
    <summary>Abstract</summary>
    This work presents MLIR, a novel approach to building reusable and extensible compiler infrastructure. MLIR addresses software fragmentation, compilation for heterogeneous hardware, significantly reducing the cost of building domain specific compilers, and connecting existing compilers together. MLIR facilitates the design and implementation of code generators, translators and optimizers at different levels of abstraction and across application domains, hardware targets and execution environments. The contribution of this work includes (1) discussion of MLIR as a research artifact, built for extension and evolution, while identifying the challenges and opportunities posed by this novel design, semantics, optimization specification, system, and engineering. (2) evaluation of MLIR as a generalized infrastructure that reduces the cost of building compilers-describing diverse use-cases to show research and educational opportunities for future programming languages, compilers, execution environments, and computer architecture. The paper also presents the rationale for MLIR, its original design principles, structures and semantics.
</details>

## Rationale

The [MLIR](https://mlir.llvm.org/) is developed as part of the [LLVM](https://llvm.org/) project. The motivation is to address the challenges of software fragmentation, compilation for heterogeneous hardware, and the high cost of building domain specific compilers. Through its [dialects](https://mlir.llvm.org/docs/Dialects/), MLIR aims to provide a reusable and extensible compiler infrastructure that can facilitate the design and implementation of code generators, translators, and optimizers at different levels of abstraction and across application domains, hardware targets, and execution environments. 

## References

- MLIR: https://mlir.llvm.org/
- LLVM: https://llvm.org/
- Publications related to MLIR: https://mlir.llvm.org/pubs/
- MLIR codebase inside the [llvm-project](https://github.com/llvm/llvm-project) monorepo: https://github.com/llvm/llvm-project/tree/main/mlir

## Contact

If you have any questions, suggestions, or feedback, do not hesitate to [contact me](https://federicobruzzone.github.io/).
