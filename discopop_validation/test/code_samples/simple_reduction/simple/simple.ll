; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !7 {
entry:
  %retval = alloca i32, align 4
  %x = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %x, metadata !11, metadata !DIExpression()), !dbg !12
  store i32 3, i32* %x, align 4, !dbg !12
  call void @llvm.dbg.declare(metadata i32* %i, metadata !13, metadata !DIExpression()), !dbg !15
  store i32 0, i32* %i, align 4, !dbg !15
  br label %for.cond, !dbg !16

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !17
  %cmp = icmp slt i32 %0, 100000, !dbg !19
  br i1 %cmp, label %for.body, label %for.end, !dbg !20

for.body:                                         ; preds = %for.cond
  call void @incr_loop_counter(i32 1)
  %1 = load i32, i32* %i, align 4, !dbg !21
  call void @add_instr_rec(i32 5, i64 1, i32 0)
  %2 = load i32, i32* %x, align 4, !dbg !23
  %add = add nsw i32 %2, %1, !dbg !23
  call void @add_instr_rec(i32 5, i64 1, i32 1)
  store i32 %add, i32* %x, align 4, !dbg !23
  br label %for.inc, !dbg !24

for.inc:                                          ; preds = %for.body
  %3 = load i32, i32* %i, align 4, !dbg !25
  %inc = add nsw i32 %3, 1, !dbg !25
  store i32 %inc, i32* %i, align 4, !dbg !25
  br label %for.cond, !dbg !26, !llvm.loop !27

for.end:                                          ; preds = %for.cond
  %4 = load i32, i32* %retval, align 4, !dbg !29
  call void @loop_counter_output(), !dbg !29
  ret i32 %4, !dbg !29
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @add_instr_rec(i32, i64, i32)

declare void @add_ptr_instr_rec(i32, i64, i32, i64)

declare void @incr_loop_counter(i32)

declare void @loop_counter_output()

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 8.0.1-9 (tags/RELEASE_801/final)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/simple_reduction/simple")
!2 = !{}
!3 = !{i32 2, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"clang version 8.0.1-9 (tags/RELEASE_801/final)"}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 3, type: !8, scopeLine: 3, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "x", scope: !7, file: !1, line: 4, type: !10)
!12 = !DILocation(line: 4, column: 9, scope: !7)
!13 = !DILocalVariable(name: "i", scope: !14, file: !1, line: 5, type: !10)
!14 = distinct !DILexicalBlock(scope: !7, file: !1, line: 5, column: 5)
!15 = !DILocation(line: 5, column: 13, scope: !14)
!16 = !DILocation(line: 5, column: 9, scope: !14)
!17 = !DILocation(line: 5, column: 18, scope: !18)
!18 = distinct !DILexicalBlock(scope: !14, file: !1, line: 5, column: 5)
!19 = !DILocation(line: 5, column: 20, scope: !18)
!20 = !DILocation(line: 5, column: 5, scope: !14)
!21 = !DILocation(line: 6, column: 14, scope: !22)
!22 = distinct !DILexicalBlock(scope: !18, file: !1, line: 5, column: 34)
!23 = !DILocation(line: 6, column: 11, scope: !22)
!24 = !DILocation(line: 7, column: 5, scope: !22)
!25 = !DILocation(line: 5, column: 31, scope: !18)
!26 = !DILocation(line: 5, column: 5, scope: !18)
!27 = distinct !{!27, !20, !28}
!28 = !DILocation(line: 7, column: 5, scope: !14)
!29 = !DILocation(line: 9, column: 1, scope: !7)
