; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@sum0 = dso_local global i32 0, align 4, !dbg !0
@sum1 = dso_local global i32 0, align 4, !dbg !6
@.str = private unnamed_addr constant [17 x i8] c"sum=%d; sum1=%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !13 {
entry:
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %sum = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !16, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.declare(metadata i32* %sum, metadata !18, metadata !DIExpression()), !dbg !19
  store i32 0, i32* %sum, align 4, !dbg !19
  store i32 1, i32* %i, align 4, !dbg !20
  br label %for.cond, !dbg !23

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !24
  %cmp = icmp sle i32 %0, 1000, !dbg !26
  br i1 %cmp, label %for.body, label %for.end, !dbg !27

for.body:                                         ; preds = %for.cond
  %1 = load i32, i32* @sum0, align 4, !dbg !28
  %2 = load i32, i32* %i, align 4, !dbg !30
  %add = add nsw i32 %1, %2, !dbg !31
  store i32 %add, i32* @sum0, align 4, !dbg !32
  br label %for.inc, !dbg !33

for.inc:                                          ; preds = %for.body
  %3 = load i32, i32* %i, align 4, !dbg !34
  %inc = add nsw i32 %3, 1, !dbg !34
  store i32 %inc, i32* %i, align 4, !dbg !34
  br label %for.cond, !dbg !35, !llvm.loop !36

for.end:                                          ; preds = %for.cond
  %4 = load i32, i32* %sum, align 4, !dbg !38
  %5 = load i32, i32* @sum0, align 4, !dbg !40
  %add1 = add nsw i32 %4, %5, !dbg !41
  store i32 %add1, i32* %sum, align 4, !dbg !42
  store i32 1, i32* %i, align 4, !dbg !43
  br label %for.cond2, !dbg !45

for.cond2:                                        ; preds = %for.inc6, %for.end
  %6 = load i32, i32* %i, align 4, !dbg !46
  %cmp3 = icmp sle i32 %6, 1000, !dbg !48
  br i1 %cmp3, label %for.body4, label %for.end8, !dbg !49

for.body4:                                        ; preds = %for.cond2
  %7 = load i32, i32* @sum1, align 4, !dbg !50
  %8 = load i32, i32* %i, align 4, !dbg !52
  %add5 = add nsw i32 %7, %8, !dbg !53
  store i32 %add5, i32* @sum1, align 4, !dbg !54
  br label %for.inc6, !dbg !55

for.inc6:                                         ; preds = %for.body4
  %9 = load i32, i32* %i, align 4, !dbg !56
  %inc7 = add nsw i32 %9, 1, !dbg !56
  store i32 %inc7, i32* %i, align 4, !dbg !56
  br label %for.cond2, !dbg !57, !llvm.loop !58

for.end8:                                         ; preds = %for.cond2
  %10 = load i32, i32* %sum, align 4, !dbg !60
  %11 = load i32, i32* @sum1, align 4, !dbg !61
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i64 0, i64 0), i32 %10, i32 %11), !dbg !62
  ret i32 0, !dbg !63
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @printf(i8*, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!9, !10, !11}
!llvm.ident = !{!12}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "sum0", scope: !2, file: !3, line: 57, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/092")
!4 = !{}
!5 = !{!0, !6}
!6 = !DIGlobalVariableExpression(var: !7, expr: !DIExpression())
!7 = distinct !DIGlobalVariable(name: "sum1", scope: !2, file: !3, line: 57, type: !8, isLocal: false, isDefinition: true)
!8 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!9 = !{i32 7, !"Dwarf Version", i32 4}
!10 = !{i32 2, !"Debug Info Version", i32 3}
!11 = !{i32 1, !"wchar_size", i32 4}
!12 = !{!"Ubuntu clang version 11.1.0-6"}
!13 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 60, type: !14, scopeLine: 61, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!14 = !DISubroutineType(types: !15)
!15 = !{!8}
!16 = !DILocalVariable(name: "i", scope: !13, file: !3, line: 62, type: !8)
!17 = !DILocation(line: 62, column: 7, scope: !13)
!18 = !DILocalVariable(name: "sum", scope: !13, file: !3, line: 62, type: !8)
!19 = !DILocation(line: 62, column: 10, scope: !13)
!20 = !DILocation(line: 66, column: 11, scope: !21)
!21 = distinct !DILexicalBlock(scope: !22, file: !3, line: 66, column: 5)
!22 = distinct !DILexicalBlock(scope: !13, file: !3, line: 64, column: 3)
!23 = !DILocation(line: 66, column: 10, scope: !21)
!24 = !DILocation(line: 66, column: 14, scope: !25)
!25 = distinct !DILexicalBlock(scope: !21, file: !3, line: 66, column: 5)
!26 = !DILocation(line: 66, column: 15, scope: !25)
!27 = !DILocation(line: 66, column: 5, scope: !21)
!28 = !DILocation(line: 68, column: 12, scope: !29)
!29 = distinct !DILexicalBlock(scope: !25, file: !3, line: 67, column: 5)
!30 = !DILocation(line: 68, column: 17, scope: !29)
!31 = !DILocation(line: 68, column: 16, scope: !29)
!32 = !DILocation(line: 68, column: 11, scope: !29)
!33 = !DILocation(line: 69, column: 5, scope: !29)
!34 = !DILocation(line: 66, column: 23, scope: !25)
!35 = !DILocation(line: 66, column: 5, scope: !25)
!36 = distinct !{!36, !27, !37}
!37 = !DILocation(line: 69, column: 5, scope: !21)
!38 = !DILocation(line: 72, column: 12, scope: !39)
!39 = distinct !DILexicalBlock(scope: !22, file: !3, line: 71, column: 5)
!40 = !DILocation(line: 72, column: 16, scope: !39)
!41 = !DILocation(line: 72, column: 15, scope: !39)
!42 = !DILocation(line: 72, column: 10, scope: !39)
!43 = !DILocation(line: 76, column: 9, scope: !44)
!44 = distinct !DILexicalBlock(scope: !13, file: !3, line: 76, column: 3)
!45 = !DILocation(line: 76, column: 8, scope: !44)
!46 = !DILocation(line: 76, column: 12, scope: !47)
!47 = distinct !DILexicalBlock(scope: !44, file: !3, line: 76, column: 3)
!48 = !DILocation(line: 76, column: 13, scope: !47)
!49 = !DILocation(line: 76, column: 3, scope: !44)
!50 = !DILocation(line: 78, column: 10, scope: !51)
!51 = distinct !DILexicalBlock(scope: !47, file: !3, line: 77, column: 3)
!52 = !DILocation(line: 78, column: 15, scope: !51)
!53 = !DILocation(line: 78, column: 14, scope: !51)
!54 = !DILocation(line: 78, column: 9, scope: !51)
!55 = !DILocation(line: 79, column: 3, scope: !51)
!56 = !DILocation(line: 76, column: 21, scope: !47)
!57 = !DILocation(line: 76, column: 3, scope: !47)
!58 = distinct !{!58, !49, !59}
!59 = !DILocation(line: 79, column: 3, scope: !44)
!60 = !DILocation(line: 80, column: 30, scope: !13)
!61 = !DILocation(line: 80, column: 34, scope: !13)
!62 = !DILocation(line: 80, column: 3, scope: !13)
!63 = !DILocation(line: 82, column: 3, scope: !13)
