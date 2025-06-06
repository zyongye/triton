#include "TritonAMDGPUTransforms/Passes.h"
#include "mlir/Pass/PassManager.h"
#include "triton/Dialect/TritonGPU/IR/Dialect.h"
#include "triton/Dialect/TritonGPU/Transforms/Utility.h"

namespace tt = mlir::triton;
namespace ttg = mlir::triton::gpu;

namespace mlir {

#define GEN_PASS_DEF_TRITONAMDGPUHOISTLAYOUTCONVERSIONS
#include "TritonAMDGPUTransforms/Passes.h.inc"

namespace {

// Hoist convert_layout out of the loop if the src is defined out of the loop.
// This is a heuristic driven by optimizing fused attention kernels, in which
// we want to load Q tensor and keep it in register, instead of loading it
// (neither from global or shared memory) at every iteration of the loop.
static void hoistCvtDotOpOutOfLoop(ttg::ConvertLayoutOp cvtOp) {
  // Check the dst of cvt has dotOperand layout
  RankedTensorType rtType = dyn_cast<RankedTensorType>(cvtOp.getType());
  if (!rtType)
    return;
  Attribute encoding = rtType.getEncoding();
  if (!encoding)
    return;
  if (!isa<ttg::DotOperandEncodingAttr>(encoding))
    return;
  // Check the src of cvt is defined out of the loop
  auto srcDefOp = cvtOp.getSrc().getDefiningOp();
  if (srcDefOp) {
    scf::ForOp parentForOp = cvtOp->getParentOfType<scf::ForOp>();
    if (parentForOp && !parentForOp->isAncestor(srcDefOp)) {
      cvtOp->moveAfter(srcDefOp);
    }
  }
}

} // anonymous namespace

struct TritonAMDGPUHoistLayoutConversionsPass
    : public impl::TritonAMDGPUHoistLayoutConversionsBase<
          TritonAMDGPUHoistLayoutConversionsPass> {

  void runOnOperation() override {
    tt::FuncOp funcOp = getOperation();

    SmallVector<ttg::ConvertLayoutOp> cvtOps;
    funcOp.walk([&](ttg::ConvertLayoutOp cvtOp) { cvtOps.push_back(cvtOp); });

    for (auto cvtOp : cvtOps)
      hoistCvtDotOpOutOfLoop(cvtOp);
  }
};

} // namespace mlir
