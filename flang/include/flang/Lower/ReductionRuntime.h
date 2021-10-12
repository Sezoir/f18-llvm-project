//===-- Lower/ReductionRuntime.h -- lower reduction intrinsics --*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef FORTRAN_LOWER_REDUCTIONRUNTIME_H
#define FORTRAN_LOWER_REDUCTIONRUNTIME_H

#include "mlir/Dialect/StandardOps/IR/Ops.h"

namespace fir {
class ExtendedValue;
}

namespace Fortran::lower {
class FirOpBuilder;

/// Generate call to all runtime routine.
/// This calls the descriptor based runtime call implementation of the all
/// intrinsic.
void genAllDescriptor(Fortran::lower::FirOpBuilder &builder, mlir::Location loc,
                      mlir::Value resultBox, mlir::Value maskBox,
                      mlir::Value dim);

/// Generate call to any runtime routine.
/// This calls the descriptor based runtime call implementation of the any
/// intrinsic.
void genAnyDescriptor(Fortran::lower::FirOpBuilder &builder, mlir::Location loc,
                      mlir::Value resultBox, mlir::Value maskBox,
                      mlir::Value dim);

/// Generate call to all runtime routine. This version of all is specialized
/// for rank 1 mask arguments.
/// This calls the version that returns a scalar logical value.
mlir::Value genAll(Fortran::lower::FirOpBuilder &builder, mlir::Location loc,
                   mlir::Value maskBox, mlir::Value dim);

/// Generate call to any runtime routine. This version of any is specialized
/// for rank 1 mask arguments.
/// This calls the version that returns a scalar logical value.
mlir::Value genAny(Fortran::lower::FirOpBuilder &builder, mlir::Location loc,
                   mlir::Value maskBox, mlir::Value dim);

/// Generate call to Maxloc intrinsic runtime routine. This is the version
/// that does not take a dim argument.
void genMaxloc(Fortran::lower::FirOpBuilder &builder, mlir::Location loc,
               mlir::Value resultBox, mlir::Value arrayBox, mlir::Value maskBox,
               mlir::Value kind, mlir::Value back);

/// Generate call to Maxloc intrinsic runtime routine. This is the version
/// that takes a dim argument.
void genMaxlocDim(Fortran::lower::FirOpBuilder &builder, mlir::Location loc,
                  mlir::Value resultBox, mlir::Value arrayBox, mlir::Value dim,
                  mlir::Value maskBox, mlir::Value kind, mlir::Value back);

/// Generate call to Minloc intrinsic runtime routine. This is the version
/// that does not take a dim argument.
void genMinloc(Fortran::lower::FirOpBuilder &builder, mlir::Location loc,
               mlir::Value resultBox, mlir::Value arrayBox, mlir::Value maskBox,
               mlir::Value kind, mlir::Value back);

/// Generate call to Minloc intrinsic runtime routine. This is the version
/// that takes a dim argument.
void genMinlocDim(Fortran::lower::FirOpBuilder &builder, mlir::Location loc,
                  mlir::Value resultBox, mlir::Value arrayBox, mlir::Value dim,
                  mlir::Value maskBox, mlir::Value kind, mlir::Value back);

/// Generate call to Maxval intrinsic runtime routine. This is the version
/// that does not take a dim argument.
mlir::Value genMaxval(Fortran::lower::FirOpBuilder &builder, mlir::Location loc,
                      mlir::Value arrayBox, mlir::Value maskBox);

/// Generate call to Maxval intrinsic runtime routine. This is the version
/// that that handles 1 dimensional character arrays  with no DIM argument.
void genMaxvalChar(Fortran::lower::FirOpBuilder &builder, mlir::Location loc,
                   mlir::Value resultBox, mlir::Value arrayBox,
                   mlir::Value maskBox);

/// Generate call to Maxval intrinsic runtime routine. This is the version
/// that takes arrays of any rank with a dim argument specified.
void genMaxvalDim(Fortran::lower::FirOpBuilder &builder, mlir::Location loc,
                  mlir::Value resultBox, mlir::Value arrayBox, mlir::Value dim,
                  mlir::Value maskBox);

/// Generate call to Minval intrinsic runtime routine. This is the version
/// that does not take a dim argument.
mlir::Value genMinval(Fortran::lower::FirOpBuilder &builder, mlir::Location loc,
                      mlir::Value arrayBox, mlir::Value maskBox);

/// Generate call to Minval intrinsic runtime routine. This is the version
/// that that handles 1 dimensional character arrays with no DIM argument.
void genMinvalChar(Fortran::lower::FirOpBuilder &builder, mlir::Location loc,
                   mlir::Value resultBox, mlir::Value arrayBox,
                   mlir::Value maskBox);

/// Generate call to Minval intrinsic runtime routine. This is the version
/// that takes arrays of any rank with a dim argument specified.
void genMinvalDim(Fortran::lower::FirOpBuilder &builder, mlir::Location loc,
                  mlir::Value resultBox, mlir::Value arrayBox, mlir::Value dim,
                  mlir::Value maskBox);

/// Generate call to Product intrinsic runtime routine. This is the version
/// that does not take a dim argument.
mlir::Value genProduct(Fortran::lower::FirOpBuilder &builder,
                       mlir::Location loc, mlir::Value arrayBox,
                       mlir::Value maskBox, mlir::Value resultBox);

/// Generate call to Product intrinsic runtime routine. This is the version
/// that takes arrays of any rank with a dim argument specified.
void genProductDim(Fortran::lower::FirOpBuilder &builder, mlir::Location loc,
                   mlir::Value resultBox, mlir::Value arrayBox, mlir::Value dim,
                   mlir::Value maskBox);

/// Generate call to Sum intrinsic runtime routine. This is the version
/// that does not take a dim argument.
mlir::Value genSum(Fortran::lower::FirOpBuilder &builder, mlir::Location loc,
                   mlir::Value arrayBox, mlir::Value maskBox,
                   mlir::Value resultBox);

/// Generate call to Sum intrinsic runtime routine. This is the version
/// that takes arrays of any rank with a dim argument specified.
void genSumDim(Fortran::lower::FirOpBuilder &builder, mlir::Location loc,
               mlir::Value resultBox, mlir::Value arrayBox, mlir::Value dim,
               mlir::Value maskBox);

} // namespace Fortran::lower

#endif // FORTRAN_LOWER_REDUCTIONRUNTIME_H
