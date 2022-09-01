; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@sum0 = dso_local global i32 0, align 4, !dbg !0
@sum1 = dso_local global i32 0, align 4, !dbg !6
@.str.1 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"sum\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.4 = private unnamed_addr constant [5 x i8] c"sum0\00", align 1
@.str.5 = private unnamed_addr constant [5 x i8] c"sum1\00", align 1
@.str = private unnamed_addr constant [17 x i8] c"sum=%d; sum1=%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !13 {
entry:
  call void @__dp_func_entry(i32 16444, i32 1)
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %sum = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16444, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !16, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.declare(metadata i32* %sum, metadata !18, metadata !DIExpression()), !dbg !19
  %1 = ptrtoint i32* %sum to i64
  call void @__dp_write(i32 16446, i64 %1, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %sum, align 4, !dbg !19
  %2 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16450, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 1, i32* %i, align 4, !dbg !20
  br label %for.cond, !dbg !23

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16450, i32 0)
  %3 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16450, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %4 = load i32, i32* %i, align 4, !dbg !24
  %cmp = icmp sle i32 %4, 1000, !dbg !26
  br i1 %cmp, label %for.body, label %for.end, !dbg !27

for.body:                                         ; preds = %for.cond
  %5 = ptrtoint i32* @sum0 to i64
  call void @__dp_read(i32 16452, i64 %5, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.4, i32 0, i32 0))
  %6 = load i32, i32* @sum0, align 4, !dbg !28
  %7 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16452, i64 %7, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %8 = load i32, i32* %i, align 4, !dbg !30
  %add = add nsw i32 %6, %8, !dbg !31
  %9 = ptrtoint i32* @sum0 to i64
  call void @__dp_write(i32 16452, i64 %9, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.4, i32 0, i32 0))
  store i32 %add, i32* @sum0, align 4, !dbg !32
  br label %for.inc, !dbg !33

for.inc:                                          ; preds = %for.body
  %10 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16450, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %11 = load i32, i32* %i, align 4, !dbg !34
  %inc = add nsw i32 %11, 1, !dbg !34
  %12 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16450, i64 %12, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !34
  br label %for.cond, !dbg !35, !llvm.loop !36

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16456, i32 0)
  %13 = ptrtoint i32* %sum to i64
  call void @__dp_read(i32 16456, i64 %13, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  %14 = load i32, i32* %sum, align 4, !dbg !38
  %15 = ptrtoint i32* @sum0 to i64
  call void @__dp_read(i32 16456, i64 %15, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.4, i32 0, i32 0))
  %16 = load i32, i32* @sum0, align 4, !dbg !40
  %add1 = add nsw i32 %14, %16, !dbg !41
  %17 = ptrtoint i32* %sum to i64
  call void @__dp_write(i32 16456, i64 %17, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  store i32 %add1, i32* %sum, align 4, !dbg !42
  %18 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16460, i64 %18, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 1, i32* %i, align 4, !dbg !43
  br label %for.cond2, !dbg !45

for.cond2:                                        ; preds = %for.inc6, %for.end
  call void @__dp_loop_entry(i32 16460, i32 1)
  %19 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16460, i64 %19, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %20 = load i32, i32* %i, align 4, !dbg !46
  %cmp3 = icmp sle i32 %20, 1000, !dbg !48
  br i1 %cmp3, label %for.body4, label %for.end8, !dbg !49

for.body4:                                        ; preds = %for.cond2
  %21 = ptrtoint i32* @sum1 to i64
  call void @__dp_read(i32 16462, i64 %21, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.5, i32 0, i32 0))
  %22 = load i32, i32* @sum1, align 4, !dbg !50
  %23 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16462, i64 %23, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %24 = load i32, i32* %i, align 4, !dbg !52
  %add5 = add nsw i32 %22, %24, !dbg !53
  %25 = ptrtoint i32* @sum1 to i64
  call void @__dp_write(i32 16462, i64 %25, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.5, i32 0, i32 0))
  store i32 %add5, i32* @sum1, align 4, !dbg !54
  br label %for.inc6, !dbg !55

for.inc6:                                         ; preds = %for.body4
  %26 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16460, i64 %26, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %27 = load i32, i32* %i, align 4, !dbg !56
  %inc7 = add nsw i32 %27, 1, !dbg !56
  %28 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16460, i64 %28, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 %inc7, i32* %i, align 4, !dbg !56
  br label %for.cond2, !dbg !57, !llvm.loop !58

for.end8:                                         ; preds = %for.cond2
  call void @__dp_loop_exit(i32 16464, i32 1)
  %29 = ptrtoint i32* %sum to i64
  call void @__dp_read(i32 16464, i64 %29, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  %30 = load i32, i32* %sum, align 4, !dbg !60
  %31 = ptrtoint i32* @sum1 to i64
  call void @__dp_read(i32 16464, i64 %31, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.5, i32 0, i32 0))
  %32 = load i32, i32* @sum1, align 4, !dbg !61
  call void @__dp_call(i32 16464), !dbg !62
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i64 0, i64 0), i32 %30, i32 %32), !dbg !62
  call void @__dp_finalize(i32 16466), !dbg !63
  ret i32 0, !dbg !63
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_loop_exit(i32, i32)

declare void @__dp_call(i32)

declare dso_local i32 @printf(i8*, ...) #2

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!9}
!llvm.module.flags = !{!10, !11, !12}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "sum0", scope: !2, file: !3, line: 57, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/092")
!4 = !{}
!5 = !{!0, !6}
!6 = !DIGlobalVariableExpression(var: !7, expr: !DIExpression())
!7 = distinct !DIGlobalVariable(name: "sum1", scope: !2, file: !3, line: 57, type: !8, isLocal: false, isDefinition: true)
!8 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!9 = !{!"Ubuntu clang version 11.1.0-6"}
!10 = !{i32 7, !"Dwarf Version", i32 4}
!11 = !{i32 2, !"Debug Info Version", i32 3}
!12 = !{i32 1, !"wchar_size", i32 4}
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
