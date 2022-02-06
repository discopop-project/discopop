; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"retval\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16388, i32 1)
  %retval = alloca i32, align 4
  %x = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %x, metadata !11, metadata !DIExpression()), !dbg !12
  %0 = ptrtoint i32* %x to i64
  call void @__dp_write(i32 16388, i64 %0, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i32 3, i32* %x, align 4, !dbg !12
  call void @llvm.dbg.declare(metadata i32* %i, metadata !13, metadata !DIExpression()), !dbg !15
  %1 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16389, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !15
  br label %for.cond, !dbg !16

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16389, i32 0)
  %2 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16389, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %3 = load i32, i32* %i, align 4, !dbg !17
  %cmp = icmp slt i32 %3, 100000, !dbg !19
  br i1 %cmp, label %for.body, label %for.end, !dbg !20

for.body:                                         ; preds = %for.cond
  %4 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16390, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %5 = load i32, i32* %i, align 4, !dbg !21
  %6 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16390, i64 %6, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %7 = load i32, i32* %x, align 4, !dbg !23
  %add = add nsw i32 %7, %5, !dbg !23
  %8 = ptrtoint i32* %x to i64
  call void @__dp_write(i32 16390, i64 %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i32 %add, i32* %x, align 4, !dbg !23
  br label %for.inc, !dbg !24

for.inc:                                          ; preds = %for.body
  %9 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16389, i64 %9, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %10 = load i32, i32* %i, align 4, !dbg !25
  %inc = add nsw i32 %10, 1, !dbg !25
  %11 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16389, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !25
  br label %for.cond, !dbg !26, !llvm.loop !27

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16393, i32 0)
  %12 = ptrtoint i32* %retval to i64
  call void @__dp_read(i32 16393, i64 %12, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  %13 = load i32, i32* %retval, align 4, !dbg !29
  call void @__dp_finalize(i32 16393), !dbg !29
  ret i32 %13, !dbg !29
}

declare void @__dp_func_entry(i32, i32)

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_write(i32, i64, i8*)

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_loop_exit(i32, i32)

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!3}
!llvm.module.flags = !{!4, !5, !6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 8.0.1-9 (tags/RELEASE_801/final)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/simple_reduction/simple")
!2 = !{}
!3 = !{!"clang version 8.0.1-9 (tags/RELEASE_801/final)"}
!4 = !{i32 2, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
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
