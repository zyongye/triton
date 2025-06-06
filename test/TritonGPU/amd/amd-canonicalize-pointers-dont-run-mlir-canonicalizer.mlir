// NOTE: Assertions have been autogenerated by mlir/utils/generate-test-checks.py

// RUN: triton-opt %s -allow-unregistered-dialect -split-input-file -tritonamdgpu-canonicalize-pointers -verify-diagnostics | FileCheck %s

module attributes {"ttg.num-warps" = 4 : i32} {
  tt.func @ifOpTwoYields(%arg0: !tt.ptr<f32>, %arg1: tensor<1024xf32>, %arg2: i1) -> (tensor<1024xf32>, tensor<1024xf32>) {
    %c1024_i32 = arith.constant 1024 : i32
    %0 = tt.get_program_id x : i32
    %1 = arith.muli %0, %c1024_i32 : i32
    %2 = tt.make_range {end = 1024 : i32, start = 0 : i32} : tensor<1024xi32>
    %3 = tt.splat %1 : i32 -> tensor<1024xi32>
    %4 = arith.addi %3, %2 : tensor<1024xi32>
    %5 = tt.splat %arg0 : !tt.ptr<f32> -> tensor<1024x!tt.ptr<f32>>
    %6:2 = scf.if %arg2 -> (tensor<1024x!tt.ptr<f32>>, tensor<1024x!tt.ptr<f32>>) {
      %8 = tt.addptr %5, %4 : tensor<1024x!tt.ptr<f32>>, tensor<1024xi32>
      scf.yield %8, %8 : tensor<1024x!tt.ptr<f32>>, tensor<1024x!tt.ptr<f32>>
    } else {
      %8 = tt.addptr %5, %3 : tensor<1024x!tt.ptr<f32>>, tensor<1024xi32>
      scf.yield %8, %8 : tensor<1024x!tt.ptr<f32>>, tensor<1024x!tt.ptr<f32>>
    }
    %7 = tt.load %6#0 : tensor<1024x!tt.ptr<f32>>
    %8 = tt.load %6#1 : tensor<1024x!tt.ptr<f32>>
    tt.return %7, %8 : tensor<1024xf32>, tensor<1024xf32>
  }
}

// CHECK-LABEL:   tt.func @ifOpTwoYields(
// CHECK-SAME:                           %[[VAL_0:.*]]: !tt.ptr<f32>,
// CHECK-SAME:                           %[[VAL_1:.*]]: tensor<1024xf32>,
// CHECK-SAME:                           %[[VAL_2:.*]]: i1) -> (tensor<1024xf32>, tensor<1024xf32>) {
// CHECK-DAG:       %[[VAL_3:.*]] = arith.constant 0 : i64
// CHECK-DAG:       %[[VAL_4:.*]] = arith.constant 1024 : i32
// CHECK:           %[[VAL_5:.*]] = tt.get_program_id x : i32
// CHECK:           %[[VAL_6:.*]] = arith.muli %[[VAL_5]], %[[VAL_4]] : i32
// CHECK:           %[[VAL_7:.*]] = tt.make_range {end = 1024 : i32, start = 0 : i32} : tensor<1024xi32>
// CHECK:           %[[VAL_8:.*]] = tt.splat %[[VAL_6]] : i32 -> tensor<1024xi32>
// CHECK:           %[[VAL_9:.*]] = arith.addi %[[VAL_8]], %[[VAL_7]] : tensor<1024xi32>
// CHECK:           %[[VAL_10:.*]] = tt.splat %[[VAL_3]] : i64 -> tensor<1024xi64>
// CHECK:           %[[VAL_11:.*]]:4 = scf.if %[[VAL_2]] -> (!tt.ptr<f32>, tensor<1024xi64>, !tt.ptr<f32>, tensor<1024xi64>) {
// CHECK-DAG:         %[[VAL_12:.*]] = arith.constant dense<0> : tensor<1024xi32>
// CHECK-DAG:         %[[VAL_13:.*]] = arith.constant 0 : i32
// CHECK:             %[[VAL_14:.*]] = arith.addi %[[VAL_6]], %[[VAL_13]] : i32
// CHECK:             %[[VAL_15:.*]] = arith.addi %[[VAL_12]], %[[VAL_7]] : tensor<1024xi32>
// CHECK:             %[[VAL_16:.*]] = tt.addptr %[[VAL_0]], %[[VAL_14]] : !tt.ptr<f32>, i32
// CHECK:             %[[VAL_17:.*]] = arith.extsi %[[VAL_15]] : tensor<1024xi32> to tensor<1024xi64>
// CHECK:             %[[VAL_18:.*]] = arith.addi %[[VAL_17]], %[[VAL_10]] : tensor<1024xi64>
// CHECK:             scf.yield %[[VAL_16]], %[[VAL_18]], %[[VAL_16]], %[[VAL_18]] : !tt.ptr<f32>, tensor<1024xi64>, !tt.ptr<f32>, tensor<1024xi64>
// CHECK:           } else {
// CHECK:             %[[VAL_19:.*]] = tt.addptr %[[VAL_0]], %[[VAL_6]] : !tt.ptr<f32>, i32
// CHECK:             scf.yield %[[VAL_19]], %[[VAL_10]], %[[VAL_19]], %[[VAL_10]] : !tt.ptr<f32>, tensor<1024xi64>, !tt.ptr<f32>, tensor<1024xi64>
// CHECK:           }
// CHECK:           %[[VAL_20:.*]] = arith.trunci %[[VAL_21:.*]]#1 : tensor<1024xi64> to tensor<1024xi32>
// CHECK:           %[[VAL_22:.*]] = tt.splat %[[VAL_21]]#0 : !tt.ptr<f32> -> tensor<1024x!tt.ptr<f32>>
// CHECK:           %[[VAL_23:.*]] = tt.addptr %[[VAL_22]], %[[VAL_20]] : tensor<1024x!tt.ptr<f32>>, tensor<1024xi32>
// CHECK:           %[[VAL_24:.*]] = tt.load %[[VAL_23]] : tensor<1024x!tt.ptr<f32>>
// CHECK:           %[[VAL_25:.*]] = arith.trunci %[[VAL_21]]#3 : tensor<1024xi64> to tensor<1024xi32>
// CHECK:           %[[VAL_26:.*]] = tt.splat %[[VAL_21]]#2 : !tt.ptr<f32> -> tensor<1024x!tt.ptr<f32>>
// CHECK:           %[[VAL_27:.*]] = tt.addptr %[[VAL_26]], %[[VAL_25]] : tensor<1024x!tt.ptr<f32>>, tensor<1024xi32>
// CHECK:           %[[VAL_28:.*]] = tt.load %[[VAL_27]] : tensor<1024x!tt.ptr<f32>>
// CHECK:           tt.return %[[VAL_24]], %[[VAL_28]] : tensor<1024xf32>, tensor<1024xf32>
// CHECK:         }

// -----

module attributes {"ttg.num-warps" = 4 : i32} {
  tt.func @ifOpTwoYieldsAndNonPtr(%arg0: !tt.ptr<f32>, %arg1: tensor<1024xf32>, %arg2: i1) -> (tensor<1024xf32>, tensor<1024xf32>, i32) {
    %c1024_i32 = arith.constant 1024 : i32
    %0 = tt.get_program_id x : i32
    %1 = arith.muli %0, %c1024_i32 : i32
    %2 = tt.make_range {end = 1024 : i32, start = 0 : i32} : tensor<1024xi32>
    %3 = tt.splat %1 : i32 -> tensor<1024xi32>
    %4 = arith.addi %3, %2 : tensor<1024xi32>
    %5 = tt.splat %arg0 : !tt.ptr<f32> -> tensor<1024x!tt.ptr<f32>>
    %6:3 = scf.if %arg2 -> (tensor<1024x!tt.ptr<f32>>, tensor<1024x!tt.ptr<f32>>, i32) {
      %8 = tt.addptr %5, %4 : tensor<1024x!tt.ptr<f32>>, tensor<1024xi32>
      scf.yield %8, %8, %0 : tensor<1024x!tt.ptr<f32>>, tensor<1024x!tt.ptr<f32>>, i32
    } else {
      %8 = tt.addptr %5, %3 : tensor<1024x!tt.ptr<f32>>, tensor<1024xi32>
      scf.yield %8, %8, %0 : tensor<1024x!tt.ptr<f32>>, tensor<1024x!tt.ptr<f32>>, i32
    }
    %7 = tt.load %6#0 : tensor<1024x!tt.ptr<f32>>
    %8 = tt.load %6#1 : tensor<1024x!tt.ptr<f32>>
    tt.return %7, %8, %6#2 : tensor<1024xf32>, tensor<1024xf32>, i32
  }
}

// CHECK-LABEL:   tt.func @ifOpTwoYieldsAndNonPtr(
// CHECK-SAME:                                    %[[VAL_0:.*]]: !tt.ptr<f32>,
// CHECK-SAME:                                    %[[VAL_1:.*]]: tensor<1024xf32>,
// CHECK-SAME:                                    %[[VAL_2:.*]]: i1) -> (tensor<1024xf32>, tensor<1024xf32>, i32) {
// CHECK-DAG:       %[[VAL_3:.*]] = arith.constant 0 : i64
// CHECK-DAG:       %[[VAL_4:.*]] = arith.constant 1024 : i32
// CHECK:           %[[VAL_5:.*]] = tt.get_program_id x : i32
// CHECK:           %[[VAL_6:.*]] = arith.muli %[[VAL_5]], %[[VAL_4]] : i32
// CHECK:           %[[VAL_7:.*]] = tt.make_range {end = 1024 : i32, start = 0 : i32} : tensor<1024xi32>
// CHECK:           %[[VAL_8:.*]] = tt.splat %[[VAL_6]] : i32 -> tensor<1024xi32>
// CHECK:           %[[VAL_9:.*]] = arith.addi %[[VAL_8]], %[[VAL_7]] : tensor<1024xi32>
// CHECK:           %[[VAL_10:.*]] = tt.splat %[[VAL_3]] : i64 -> tensor<1024xi64>
// CHECK:           %[[VAL_11:.*]]:5 = scf.if %[[VAL_2]] -> (!tt.ptr<f32>, tensor<1024xi64>, !tt.ptr<f32>, tensor<1024xi64>, i32) {
// CHECK-DAG:         %[[VAL_12:.*]] = arith.constant dense<0> : tensor<1024xi32>
// CHECK-DAG:         %[[VAL_13:.*]] = arith.constant 0 : i32
// CHECK:             %[[VAL_14:.*]] = arith.addi %[[VAL_6]], %[[VAL_13]] : i32
// CHECK:             %[[VAL_15:.*]] = arith.addi %[[VAL_12]], %[[VAL_7]] : tensor<1024xi32>
// CHECK:             %[[VAL_16:.*]] = tt.addptr %[[VAL_0]], %[[VAL_14]] : !tt.ptr<f32>, i32
// CHECK:             %[[VAL_17:.*]] = arith.extsi %[[VAL_15]] : tensor<1024xi32> to tensor<1024xi64>
// CHECK:             %[[VAL_18:.*]] = arith.addi %[[VAL_17]], %[[VAL_10]] : tensor<1024xi64>
// CHECK:             scf.yield %[[VAL_16]], %[[VAL_18]], %[[VAL_16]], %[[VAL_18]], %[[VAL_5]] : !tt.ptr<f32>, tensor<1024xi64>, !tt.ptr<f32>, tensor<1024xi64>, i32
// CHECK:           } else {
// CHECK:             %[[VAL_19:.*]] = tt.addptr %[[VAL_0]], %[[VAL_6]] : !tt.ptr<f32>, i32
// CHECK:             scf.yield %[[VAL_19]], %[[VAL_10]], %[[VAL_19]], %[[VAL_10]], %[[VAL_5]] : !tt.ptr<f32>, tensor<1024xi64>, !tt.ptr<f32>, tensor<1024xi64>, i32
// CHECK:           }
// CHECK:           %[[VAL_20:.*]] = arith.trunci %[[VAL_21:.*]]#1 : tensor<1024xi64> to tensor<1024xi32>
// CHECK:           %[[VAL_22:.*]] = tt.splat %[[VAL_21]]#0 : !tt.ptr<f32> -> tensor<1024x!tt.ptr<f32>>
// CHECK:           %[[VAL_23:.*]] = tt.addptr %[[VAL_22]], %[[VAL_20]] : tensor<1024x!tt.ptr<f32>>, tensor<1024xi32>
// CHECK:           %[[VAL_24:.*]] = tt.load %[[VAL_23]] : tensor<1024x!tt.ptr<f32>>
// CHECK:           %[[VAL_25:.*]] = arith.trunci %[[VAL_21]]#3 : tensor<1024xi64> to tensor<1024xi32>
// CHECK:           %[[VAL_26:.*]] = tt.splat %[[VAL_21]]#2 : !tt.ptr<f32> -> tensor<1024x!tt.ptr<f32>>
// CHECK:           %[[VAL_27:.*]] = tt.addptr %[[VAL_26]], %[[VAL_25]] : tensor<1024x!tt.ptr<f32>>, tensor<1024xi32>
// CHECK:           %[[VAL_28:.*]] = tt.load %[[VAL_27]] : tensor<1024x!tt.ptr<f32>>
// CHECK:           tt.return %[[VAL_24]], %[[VAL_28]], %[[VAL_21]]#4 : tensor<1024xf32>, tensor<1024xf32>, i32
// CHECK:         }


// -----

module attributes {"ttg.num-warps" = 4 : i32} {
  tt.func @ifOpTwoYieldsAndNonPtrReordered(%arg0: !tt.ptr<f32>, %arg1: tensor<1024xf32>, %arg2: i1) -> (tensor<1024xf32>, tensor<1024xf32>, i32) {
    %c1024_i32 = arith.constant 1024 : i32
    %0 = tt.get_program_id x : i32
    %1 = arith.muli %0, %c1024_i32 : i32
    %2 = tt.make_range {end = 1024 : i32, start = 0 : i32} : tensor<1024xi32>
    %3 = tt.splat %1 : i32 -> tensor<1024xi32>
    %4 = arith.addi %3, %2 : tensor<1024xi32>
    %5 = tt.splat %arg0 : !tt.ptr<f32> -> tensor<1024x!tt.ptr<f32>>
    %6:3 = scf.if %arg2 -> (tensor<1024x!tt.ptr<f32>>, i32, tensor<1024x!tt.ptr<f32>>) {
      %8 = tt.addptr %5, %4 : tensor<1024x!tt.ptr<f32>>, tensor<1024xi32>
      scf.yield %8, %0, %8 : tensor<1024x!tt.ptr<f32>>, i32, tensor<1024x!tt.ptr<f32>>
    } else {
      %8 = tt.addptr %5, %3 : tensor<1024x!tt.ptr<f32>>, tensor<1024xi32>
      scf.yield %8, %0, %8 : tensor<1024x!tt.ptr<f32>>, i32, tensor<1024x!tt.ptr<f32>>
    }
    %7 = tt.load %6#0 : tensor<1024x!tt.ptr<f32>>
    %8 = tt.load %6#2 : tensor<1024x!tt.ptr<f32>>
    tt.return %7, %8, %6#1 : tensor<1024xf32>, tensor<1024xf32>, i32
  }
}

// CHECK-LABEL:   tt.func @ifOpTwoYieldsAndNonPtrReordered(
// CHECK-SAME:                                             %[[VAL_0:.*]]: !tt.ptr<f32>,
// CHECK-SAME:                                             %[[VAL_1:.*]]: tensor<1024xf32>,
// CHECK-SAME:                                             %[[VAL_2:.*]]: i1) -> (tensor<1024xf32>, tensor<1024xf32>, i32) {
// CHECK-DAG:       %[[VAL_3:.*]] = arith.constant 0 : i64
// CHECK-DAG:       %[[VAL_4:.*]] = arith.constant 1024 : i32
// CHECK:           %[[VAL_5:.*]] = tt.get_program_id x : i32
// CHECK:           %[[VAL_6:.*]] = arith.muli %[[VAL_5]], %[[VAL_4]] : i32
// CHECK:           %[[VAL_7:.*]] = tt.make_range {end = 1024 : i32, start = 0 : i32} : tensor<1024xi32>
// CHECK:           %[[VAL_8:.*]] = tt.splat %[[VAL_6]] : i32 -> tensor<1024xi32>
// CHECK:           %[[VAL_9:.*]] = arith.addi %[[VAL_8]], %[[VAL_7]] : tensor<1024xi32>
// CHECK:           %[[VAL_10:.*]] = tt.splat %[[VAL_3]] : i64 -> tensor<1024xi64>
// CHECK:           %[[VAL_11:.*]]:5 = scf.if %[[VAL_2]] -> (!tt.ptr<f32>, tensor<1024xi64>, i32, !tt.ptr<f32>, tensor<1024xi64>) {
// CHECK-DAG:         %[[VAL_12:.*]] = arith.constant dense<0> : tensor<1024xi32>
// CHECK-DAG:         %[[VAL_13:.*]] = arith.constant 0 : i32
// CHECK:             %[[VAL_14:.*]] = arith.addi %[[VAL_6]], %[[VAL_13]] : i32
// CHECK:             %[[VAL_15:.*]] = arith.addi %[[VAL_12]], %[[VAL_7]] : tensor<1024xi32>
// CHECK:             %[[VAL_16:.*]] = tt.addptr %[[VAL_0]], %[[VAL_14]] : !tt.ptr<f32>, i32
// CHECK:             %[[VAL_17:.*]] = arith.extsi %[[VAL_15]] : tensor<1024xi32> to tensor<1024xi64>
// CHECK:             %[[VAL_18:.*]] = arith.addi %[[VAL_17]], %[[VAL_10]] : tensor<1024xi64>
// CHECK:             scf.yield %[[VAL_16]], %[[VAL_18]], %[[VAL_5]], %[[VAL_16]], %[[VAL_18]] : !tt.ptr<f32>, tensor<1024xi64>, i32, !tt.ptr<f32>, tensor<1024xi64>
// CHECK:           } else {
// CHECK:             %[[VAL_19:.*]] = tt.addptr %[[VAL_0]], %[[VAL_6]] : !tt.ptr<f32>, i32
// CHECK:             scf.yield %[[VAL_19]], %[[VAL_10]], %[[VAL_5]], %[[VAL_19]], %[[VAL_10]] : !tt.ptr<f32>, tensor<1024xi64>, i32, !tt.ptr<f32>, tensor<1024xi64>
// CHECK:           }
// CHECK:           %[[VAL_20:.*]] = arith.trunci %[[VAL_21:.*]]#1 : tensor<1024xi64> to tensor<1024xi32>
// CHECK:           %[[VAL_22:.*]] = tt.splat %[[VAL_21]]#0 : !tt.ptr<f32> -> tensor<1024x!tt.ptr<f32>>
// CHECK:           %[[VAL_23:.*]] = tt.addptr %[[VAL_22]], %[[VAL_20]] : tensor<1024x!tt.ptr<f32>>, tensor<1024xi32>
// CHECK:           %[[VAL_24:.*]] = tt.load %[[VAL_23]] : tensor<1024x!tt.ptr<f32>>
// CHECK:           %[[VAL_25:.*]] = arith.trunci %[[VAL_21]]#4 : tensor<1024xi64> to tensor<1024xi32>
// CHECK:           %[[VAL_26:.*]] = tt.splat %[[VAL_21]]#3 : !tt.ptr<f32> -> tensor<1024x!tt.ptr<f32>>
// CHECK:           %[[VAL_27:.*]] = tt.addptr %[[VAL_26]], %[[VAL_25]] : tensor<1024x!tt.ptr<f32>>, tensor<1024xi32>
// CHECK:           %[[VAL_28:.*]] = tt.load %[[VAL_27]] : tensor<1024x!tt.ptr<f32>>
// CHECK:           tt.return %[[VAL_24]], %[[VAL_28]], %[[VAL_21]]#2 : tensor<1024xf32>, tensor<1024xf32>, i32
// CHECK:         }
