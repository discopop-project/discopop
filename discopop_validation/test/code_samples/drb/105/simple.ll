; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@input = dso_local global i32 30, align 4, !dbg !0
@.str = private unnamed_addr constant [12 x i8] c"Fib(%d)=%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [15 x i8] c"result==832040\00", align 1
@.str.2 = private unnamed_addr constant [9 x i8] c"simple.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @fib(i32 %n) #0 !dbg !11 {
entry:
  %retval = alloca i32, align 4
  %n.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  store i32 %n, i32* %n.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %n.addr, metadata !15, metadata !DIExpression()), !dbg !16
  %0 = load i32, i32* %n.addr, align 4, !dbg !17
  %cmp = icmp ult i32 %0, 2, !dbg !19
  br i1 %cmp, label %if.then, label %if.else, !dbg !20

if.then:                                          ; preds = %entry
  %1 = load i32, i32* %n.addr, align 4, !dbg !21
  store i32 %1, i32* %retval, align 4, !dbg !22
  br label %return, !dbg !22

if.else:                                          ; preds = %entry
  call void @llvm.dbg.declare(metadata i32* %i, metadata !23, metadata !DIExpression()), !dbg !25
  call void @llvm.dbg.declare(metadata i32* %j, metadata !26, metadata !DIExpression()), !dbg !27
  %2 = load i32, i32* %n.addr, align 4, !dbg !28
  %sub = sub i32 %2, 1, !dbg !29
  %call = call i32 @fib(i32 %sub), !dbg !30
  store i32 %call, i32* %i, align 4, !dbg !31
  %3 = load i32, i32* %n.addr, align 4, !dbg !32
  %sub1 = sub i32 %3, 2, !dbg !33
  %call2 = call i32 @fib(i32 %sub1), !dbg !34
  store i32 %call2, i32* %j, align 4, !dbg !35
  %4 = load i32, i32* %i, align 4, !dbg !36
  %5 = load i32, i32* %j, align 4, !dbg !37
  %add = add nsw i32 %4, %5, !dbg !38
  store i32 %add, i32* %retval, align 4, !dbg !39
  br label %return, !dbg !39

return:                                           ; preds = %if.else, %if.then
  %6 = load i32, i32* %retval, align 4, !dbg !40
  ret i32 %6, !dbg !40
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !41 {
entry:
  %retval = alloca i32, align 4
  %result = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %result, metadata !44, metadata !DIExpression()), !dbg !45
  store i32 0, i32* %result, align 4, !dbg !45
  %0 = load i32, i32* @input, align 4, !dbg !46
  %call = call i32 @fib(i32 %0), !dbg !49
  store i32 %call, i32* %result, align 4, !dbg !50
  %1 = load i32, i32* @input, align 4, !dbg !51
  %2 = load i32, i32* %result, align 4, !dbg !52
  %call1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i64 0, i64 0), i32 %1, i32 %2), !dbg !53
  %3 = load i32, i32* %result, align 4, !dbg !54
  %cmp = icmp eq i32 %3, 832040, !dbg !54
  br i1 %cmp, label %if.then, label %if.else, !dbg !57

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !57

if.else:                                          ; preds = %entry
  call void @__assert_fail(i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.1, i64 0, i64 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.2, i64 0, i64 0), i32 79, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !54
  unreachable, !dbg !54

if.end:                                           ; preds = %if.then
  ret i32 0, !dbg !58
}

declare dso_local i32 @printf(i8*, ...) #2

; Function Attrs: noreturn nounwind
declare dso_local void @__assert_fail(i8*, i8*, i32, i8*) #3

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!7, !8, !9}
!llvm.ident = !{!10}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "input", scope: !2, file: !3, line: 52, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/105")
!4 = !{}
!5 = !{!0}
!6 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!7 = !{i32 7, !"Dwarf Version", i32 4}
!8 = !{i32 2, !"Debug Info Version", i32 3}
!9 = !{i32 1, !"wchar_size", i32 4}
!10 = !{!"Ubuntu clang version 11.1.0-6"}
!11 = distinct !DISubprogram(name: "fib", scope: !3, file: !3, line: 53, type: !12, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!12 = !DISubroutineType(types: !13)
!13 = !{!14, !6}
!14 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!15 = !DILocalVariable(name: "n", arg: 1, scope: !11, file: !3, line: 53, type: !6)
!16 = !DILocation(line: 53, column: 22, scope: !11)
!17 = !DILocation(line: 55, column: 7, scope: !18)
!18 = distinct !DILexicalBlock(scope: !11, file: !3, line: 55, column: 7)
!19 = !DILocation(line: 55, column: 8, scope: !18)
!20 = !DILocation(line: 55, column: 7, scope: !11)
!21 = !DILocation(line: 56, column: 12, scope: !18)
!22 = !DILocation(line: 56, column: 5, scope: !18)
!23 = !DILocalVariable(name: "i", scope: !24, file: !3, line: 59, type: !14)
!24 = distinct !DILexicalBlock(scope: !18, file: !3, line: 58, column: 3)
!25 = !DILocation(line: 59, column: 9, scope: !24)
!26 = !DILocalVariable(name: "j", scope: !24, file: !3, line: 59, type: !14)
!27 = !DILocation(line: 59, column: 12, scope: !24)
!28 = !DILocation(line: 61, column: 11, scope: !24)
!29 = !DILocation(line: 61, column: 12, scope: !24)
!30 = !DILocation(line: 61, column: 7, scope: !24)
!31 = !DILocation(line: 61, column: 6, scope: !24)
!32 = !DILocation(line: 63, column: 11, scope: !24)
!33 = !DILocation(line: 63, column: 12, scope: !24)
!34 = !DILocation(line: 63, column: 7, scope: !24)
!35 = !DILocation(line: 63, column: 6, scope: !24)
!36 = !DILocation(line: 65, column: 12, scope: !24)
!37 = !DILocation(line: 65, column: 14, scope: !24)
!38 = !DILocation(line: 65, column: 13, scope: !24)
!39 = !DILocation(line: 65, column: 5, scope: !24)
!40 = !DILocation(line: 67, column: 1, scope: !11)
!41 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 68, type: !42, scopeLine: 69, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!42 = !DISubroutineType(types: !43)
!43 = !{!14}
!44 = !DILocalVariable(name: "result", scope: !41, file: !3, line: 70, type: !14)
!45 = !DILocation(line: 70, column: 7, scope: !41)
!46 = !DILocation(line: 75, column: 20, scope: !47)
!47 = distinct !DILexicalBlock(scope: !48, file: !3, line: 74, column: 5)
!48 = distinct !DILexicalBlock(scope: !41, file: !3, line: 72, column: 3)
!49 = !DILocation(line: 75, column: 16, scope: !47)
!50 = !DILocation(line: 75, column: 14, scope: !47)
!51 = !DILocation(line: 78, column: 27, scope: !41)
!52 = !DILocation(line: 78, column: 34, scope: !41)
!53 = !DILocation(line: 78, column: 3, scope: !41)
!54 = !DILocation(line: 79, column: 3, scope: !55)
!55 = distinct !DILexicalBlock(scope: !56, file: !3, line: 79, column: 3)
!56 = distinct !DILexicalBlock(scope: !41, file: !3, line: 79, column: 3)
!57 = !DILocation(line: 79, column: 3, scope: !56)
!58 = !DILocation(line: 80, column: 3, scope: !41)
