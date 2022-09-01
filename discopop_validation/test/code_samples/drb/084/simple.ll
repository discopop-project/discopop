; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@sum0 = dso_local global i32 0, align 4, !dbg !0
@sum1 = dso_local global i32 0, align 4, !dbg !6
@.str = private unnamed_addr constant [17 x i8] c"sum=%d; sum1=%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo(i32 %i) #0 !dbg !13 {
entry:
  %i.addr = alloca i32, align 4
  store i32 %i, i32* %i.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %i.addr, metadata !16, metadata !DIExpression()), !dbg !17
  %0 = load i32, i32* @sum0, align 4, !dbg !18
  %1 = load i32, i32* %i.addr, align 4, !dbg !19
  %add = add nsw i32 %0, %1, !dbg !20
  store i32 %add, i32* @sum0, align 4, !dbg !21
  ret void, !dbg !22
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !23 {
entry:
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %sum = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !26, metadata !DIExpression()), !dbg !27
  call void @llvm.dbg.declare(metadata i32* %sum, metadata !28, metadata !DIExpression()), !dbg !29
  store i32 0, i32* %sum, align 4, !dbg !29
  store i32 1, i32* %i, align 4, !dbg !30
  br label %for.cond, !dbg !33

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !34
  %cmp = icmp sle i32 %0, 1000, !dbg !36
  br i1 %cmp, label %for.body, label %for.end, !dbg !37

for.body:                                         ; preds = %for.cond
  %1 = load i32, i32* %i, align 4, !dbg !38
  call void @foo(i32 %1), !dbg !40
  br label %for.inc, !dbg !41

for.inc:                                          ; preds = %for.body
  %2 = load i32, i32* %i, align 4, !dbg !42
  %inc = add nsw i32 %2, 1, !dbg !42
  store i32 %inc, i32* %i, align 4, !dbg !42
  br label %for.cond, !dbg !43, !llvm.loop !44

for.end:                                          ; preds = %for.cond
  %3 = load i32, i32* %sum, align 4, !dbg !46
  %4 = load i32, i32* @sum0, align 4, !dbg !48
  %add = add nsw i32 %3, %4, !dbg !49
  store i32 %add, i32* %sum, align 4, !dbg !50
  store i32 1, i32* %i, align 4, !dbg !51
  br label %for.cond1, !dbg !53

for.cond1:                                        ; preds = %for.inc5, %for.end
  %5 = load i32, i32* %i, align 4, !dbg !54
  %cmp2 = icmp sle i32 %5, 1000, !dbg !56
  br i1 %cmp2, label %for.body3, label %for.end7, !dbg !57

for.body3:                                        ; preds = %for.cond1
  %6 = load i32, i32* @sum1, align 4, !dbg !58
  %7 = load i32, i32* %i, align 4, !dbg !60
  %add4 = add nsw i32 %6, %7, !dbg !61
  store i32 %add4, i32* @sum1, align 4, !dbg !62
  br label %for.inc5, !dbg !63

for.inc5:                                         ; preds = %for.body3
  %8 = load i32, i32* %i, align 4, !dbg !64
  %inc6 = add nsw i32 %8, 1, !dbg !64
  store i32 %inc6, i32* %i, align 4, !dbg !64
  br label %for.cond1, !dbg !65, !llvm.loop !66

for.end7:                                         ; preds = %for.cond1
  %9 = load i32, i32* %sum, align 4, !dbg !68
  %10 = load i32, i32* @sum1, align 4, !dbg !69
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i64 0, i64 0), i32 %9, i32 %10), !dbg !70
  ret i32 0, !dbg !71
}

declare dso_local i32 @printf(i8*, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!9, !10, !11}
!llvm.ident = !{!12}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "sum0", scope: !2, file: !3, line: 56, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/084")
!4 = !{}
!5 = !{!0, !6}
!6 = !DIGlobalVariableExpression(var: !7, expr: !DIExpression())
!7 = distinct !DIGlobalVariable(name: "sum1", scope: !2, file: !3, line: 56, type: !8, isLocal: false, isDefinition: true)
!8 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!9 = !{i32 7, !"Dwarf Version", i32 4}
!10 = !{i32 2, !"Debug Info Version", i32 3}
!11 = !{i32 1, !"wchar_size", i32 4}
!12 = !{!"Ubuntu clang version 11.1.0-6"}
!13 = distinct !DISubprogram(name: "foo", scope: !3, file: !3, line: 59, type: !14, scopeLine: 60, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!14 = !DISubroutineType(types: !15)
!15 = !{null, !8}
!16 = !DILocalVariable(name: "i", arg: 1, scope: !13, file: !3, line: 59, type: !8)
!17 = !DILocation(line: 59, column: 15, scope: !13)
!18 = !DILocation(line: 61, column: 8, scope: !13)
!19 = !DILocation(line: 61, column: 13, scope: !13)
!20 = !DILocation(line: 61, column: 12, scope: !13)
!21 = !DILocation(line: 61, column: 7, scope: !13)
!22 = !DILocation(line: 62, column: 1, scope: !13)
!23 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 64, type: !24, scopeLine: 65, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!24 = !DISubroutineType(types: !25)
!25 = !{!8}
!26 = !DILocalVariable(name: "i", scope: !23, file: !3, line: 66, type: !8)
!27 = !DILocation(line: 66, column: 7, scope: !23)
!28 = !DILocalVariable(name: "sum", scope: !23, file: !3, line: 66, type: !8)
!29 = !DILocation(line: 66, column: 10, scope: !23)
!30 = !DILocation(line: 70, column: 11, scope: !31)
!31 = distinct !DILexicalBlock(scope: !32, file: !3, line: 70, column: 5)
!32 = distinct !DILexicalBlock(scope: !23, file: !3, line: 68, column: 3)
!33 = !DILocation(line: 70, column: 10, scope: !31)
!34 = !DILocation(line: 70, column: 14, scope: !35)
!35 = distinct !DILexicalBlock(scope: !31, file: !3, line: 70, column: 5)
!36 = !DILocation(line: 70, column: 15, scope: !35)
!37 = !DILocation(line: 70, column: 5, scope: !31)
!38 = !DILocation(line: 72, column: 13, scope: !39)
!39 = distinct !DILexicalBlock(scope: !35, file: !3, line: 71, column: 5)
!40 = !DILocation(line: 72, column: 8, scope: !39)
!41 = !DILocation(line: 73, column: 5, scope: !39)
!42 = !DILocation(line: 70, column: 23, scope: !35)
!43 = !DILocation(line: 70, column: 5, scope: !35)
!44 = distinct !{!44, !37, !45}
!45 = !DILocation(line: 73, column: 5, scope: !31)
!46 = !DILocation(line: 76, column: 12, scope: !47)
!47 = distinct !DILexicalBlock(scope: !32, file: !3, line: 75, column: 5)
!48 = !DILocation(line: 76, column: 16, scope: !47)
!49 = !DILocation(line: 76, column: 15, scope: !47)
!50 = !DILocation(line: 76, column: 10, scope: !47)
!51 = !DILocation(line: 80, column: 9, scope: !52)
!52 = distinct !DILexicalBlock(scope: !23, file: !3, line: 80, column: 3)
!53 = !DILocation(line: 80, column: 8, scope: !52)
!54 = !DILocation(line: 80, column: 12, scope: !55)
!55 = distinct !DILexicalBlock(scope: !52, file: !3, line: 80, column: 3)
!56 = !DILocation(line: 80, column: 13, scope: !55)
!57 = !DILocation(line: 80, column: 3, scope: !52)
!58 = !DILocation(line: 82, column: 10, scope: !59)
!59 = distinct !DILexicalBlock(scope: !55, file: !3, line: 81, column: 3)
!60 = !DILocation(line: 82, column: 15, scope: !59)
!61 = !DILocation(line: 82, column: 14, scope: !59)
!62 = !DILocation(line: 82, column: 9, scope: !59)
!63 = !DILocation(line: 83, column: 3, scope: !59)
!64 = !DILocation(line: 80, column: 21, scope: !55)
!65 = !DILocation(line: 80, column: 3, scope: !55)
!66 = distinct !{!66, !57, !67}
!67 = !DILocation(line: 83, column: 3, scope: !52)
!68 = !DILocation(line: 84, column: 30, scope: !23)
!69 = !DILocation(line: 84, column: 34, scope: !23)
!70 = !DILocation(line: 84, column: 3, scope: !23)
!71 = !DILocation(line: 86, column: 3, scope: !23)
