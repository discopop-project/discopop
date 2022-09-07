; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@tp = dso_local global i32 0, align 4, !dbg !0
@var = dso_local global i32 0, align 4, !dbg !6
@.str.1 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.2 = private unnamed_addr constant [3 x i8] c"tp\00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c"var\00", align 1
@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !13 {
entry:
  call void @__dp_func_entry(i32 16409, i32 1)
  %retval = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16409, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  %1 = ptrtoint i32* @tp to i64
  call void @__dp_write(i32 16414, i64 %1, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.2, i32 0, i32 0))
  store i32 1, i32* @tp, align 4, !dbg !16
  %2 = ptrtoint i32* @tp to i64
  call void @__dp_read(i32 16418, i64 %2, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.2, i32 0, i32 0))
  %3 = load i32, i32* @tp, align 4, !dbg !19
  %4 = ptrtoint i32* @var to i64
  call void @__dp_write(i32 16418, i64 %4, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  store i32 %3, i32* @var, align 4, !dbg !20
  %5 = ptrtoint i32* @tp to i64
  call void @__dp_write(i32 16420, i64 %5, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.2, i32 0, i32 0))
  store i32 2, i32* @tp, align 4, !dbg !21
  %6 = ptrtoint i32* @var to i64
  call void @__dp_read(i32 16423, i64 %6, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  %7 = load i32, i32* @var, align 4, !dbg !22
  %cmp = icmp eq i32 %7, 2, !dbg !24
  br i1 %cmp, label %if.then, label %if.end, !dbg !25

if.then:                                          ; preds = %entry
  %8 = ptrtoint i32* @var to i64
  call void @__dp_read(i32 16423, i64 %8, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  %9 = load i32, i32* @var, align 4, !dbg !26
  call void @__dp_call(i32 16423), !dbg !27
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 %9), !dbg !27
  br label %if.end, !dbg !27

if.end:                                           ; preds = %if.then, %entry
  call void @__dp_finalize(i32 16424), !dbg !28
  ret i32 0, !dbg !28
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_call(i32)

declare dso_local i32 @printf(i8*, ...) #1

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!9}
!llvm.module.flags = !{!10, !11, !12}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "tp", scope: !2, file: !3, line: 21, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/127")
!4 = !{}
!5 = !{!0, !6}
!6 = !DIGlobalVariableExpression(var: !7, expr: !DIExpression())
!7 = distinct !DIGlobalVariable(name: "var", scope: !2, file: !3, line: 23, type: !8, isLocal: false, isDefinition: true)
!8 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!9 = !{!"Ubuntu clang version 11.1.0-6"}
!10 = !{i32 7, !"Dwarf Version", i32 4}
!11 = !{i32 2, !"Debug Info Version", i32 3}
!12 = !{i32 1, !"wchar_size", i32 4}
!13 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 25, type: !14, scopeLine: 25, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!14 = !DISubroutineType(types: !15)
!15 = !{!8}
!16 = !DILocation(line: 30, column: 10, scope: !17)
!17 = distinct !DILexicalBlock(scope: !18, file: !3, line: 29, column: 5)
!18 = distinct !DILexicalBlock(scope: !13, file: !3, line: 27, column: 3)
!19 = !DILocation(line: 34, column: 13, scope: !17)
!20 = !DILocation(line: 34, column: 11, scope: !17)
!21 = !DILocation(line: 36, column: 7, scope: !18)
!22 = !DILocation(line: 39, column: 6, scope: !23)
!23 = distinct !DILexicalBlock(scope: !13, file: !3, line: 39, column: 6)
!24 = !DILocation(line: 39, column: 9, scope: !23)
!25 = !DILocation(line: 39, column: 6, scope: !13)
!26 = !DILocation(line: 39, column: 28, scope: !23)
!27 = !DILocation(line: 39, column: 14, scope: !23)
!28 = !DILocation(line: 40, column: 3, scope: !13)
