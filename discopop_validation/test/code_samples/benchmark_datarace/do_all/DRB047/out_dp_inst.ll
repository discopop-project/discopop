; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@a = common dso_local global [100 x i8] zeroinitializer, align 16, !dbg !0
@.str = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"a\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !14 {
entry:
  call void @__dp_func_entry(i32 16440, i32 1)
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !18, metadata !DIExpression()), !dbg !19
  %0 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16442, i64 %0, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !20
  br label %for.cond, !dbg !22

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16442, i32 0)
  %1 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16442, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %2 = load i32, i32* %i, align 4, !dbg !23
  %cmp = icmp slt i32 %2, 100, !dbg !25
  br i1 %cmp, label %for.body, label %for.end, !dbg !26

for.body:                                         ; preds = %for.cond
  %3 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16443, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %4 = load i32, i32* %i, align 4, !dbg !27
  %idxprom = sext i32 %4 to i64, !dbg !28
  %arrayidx = getelementptr inbounds [100 x i8], [100 x i8]* @a, i64 0, i64 %idxprom, !dbg !28
  %5 = ptrtoint i8* %arrayidx to i64
  call void @__dp_read(i32 16443, i64 %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %6 = load i8, i8* %arrayidx, align 1, !dbg !28
  %conv = sext i8 %6 to i32, !dbg !28
  %add = add nsw i32 %conv, 1, !dbg !29
  %conv1 = trunc i32 %add to i8, !dbg !28
  %7 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16443, i64 %7, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %8 = load i32, i32* %i, align 4, !dbg !30
  %idxprom2 = sext i32 %8 to i64, !dbg !31
  %arrayidx3 = getelementptr inbounds [100 x i8], [100 x i8]* @a, i64 0, i64 %idxprom2, !dbg !31
  %9 = ptrtoint i8* %arrayidx3 to i64
  call void @__dp_write(i32 16443, i64 %9, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i8 %conv1, i8* %arrayidx3, align 1, !dbg !32
  br label %for.inc, !dbg !31

for.inc:                                          ; preds = %for.body
  %10 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16442, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %11 = load i32, i32* %i, align 4, !dbg !33
  %inc = add nsw i32 %11, 1, !dbg !33
  %12 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16442, i64 %12, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !33
  br label %for.cond, !dbg !34, !llvm.loop !35

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16444, i32 0)
  call void @__dp_finalize(i32 16444), !dbg !37
  ret i32 0, !dbg !37
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

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!10}
!llvm.module.flags = !{!11, !12, !13}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 53, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 8.0.1-9 (tags/RELEASE_801/final)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, nameTableKind: None)
!3 = !DIFile(filename: "DRB047-doallchar-orig-no.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/benchmark_datarace/do_all/DRB047")
!4 = !{}
!5 = !{!0}
!6 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 800, elements: !8)
!7 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!8 = !{!9}
!9 = !DISubrange(count: 100)
!10 = !{!"clang version 8.0.1-9 (tags/RELEASE_801/final)"}
!11 = !{i32 2, !"Dwarf Version", i32 4}
!12 = !{i32 2, !"Debug Info Version", i32 3}
!13 = !{i32 1, !"wchar_size", i32 4}
!14 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 54, type: !15, scopeLine: 55, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!15 = !DISubroutineType(types: !16)
!16 = !{!17}
!17 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!18 = !DILocalVariable(name: "i", scope: !14, file: !3, line: 56, type: !17)
!19 = !DILocation(line: 56, column: 7, scope: !14)
!20 = !DILocation(line: 58, column: 9, scope: !21)
!21 = distinct !DILexicalBlock(scope: !14, file: !3, line: 58, column: 3)
!22 = !DILocation(line: 58, column: 8, scope: !21)
!23 = !DILocation(line: 58, column: 12, scope: !24)
!24 = distinct !DILexicalBlock(scope: !21, file: !3, line: 58, column: 3)
!25 = !DILocation(line: 58, column: 13, scope: !24)
!26 = !DILocation(line: 58, column: 3, scope: !21)
!27 = !DILocation(line: 59, column: 12, scope: !24)
!28 = !DILocation(line: 59, column: 10, scope: !24)
!29 = !DILocation(line: 59, column: 14, scope: !24)
!30 = !DILocation(line: 59, column: 7, scope: !24)
!31 = !DILocation(line: 59, column: 5, scope: !24)
!32 = !DILocation(line: 59, column: 9, scope: !24)
!33 = !DILocation(line: 58, column: 19, scope: !24)
!34 = !DILocation(line: 58, column: 3, scope: !24)
!35 = distinct !{!35, !26, !36}
!36 = !DILocation(line: 59, column: 15, scope: !21)
!37 = !DILocation(line: 60, column: 3, scope: !14)
