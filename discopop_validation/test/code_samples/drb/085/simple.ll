; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@sum0 = dso_local global i32 0, align 4, !dbg !0
@sum1 = dso_local global i32 0, align 4, !dbg !6
@.str = private unnamed_addr constant [17 x i8] c"sum=%d; sum1=%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [10 x i8] c"sum==sum1\00", align 1
@.str.2 = private unnamed_addr constant [9 x i8] c"simple.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

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
  %len = alloca i32, align 4
  %i = alloca i32, align 4
  %sum = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %len, metadata !26, metadata !DIExpression()), !dbg !27
  store i32 1000, i32* %len, align 4, !dbg !27
  call void @llvm.dbg.declare(metadata i32* %i, metadata !28, metadata !DIExpression()), !dbg !29
  call void @llvm.dbg.declare(metadata i32* %sum, metadata !30, metadata !DIExpression()), !dbg !31
  store i32 0, i32* %sum, align 4, !dbg !31
  store i32 0, i32* %i, align 4, !dbg !32
  br label %for.cond, !dbg !35

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !36
  %1 = load i32, i32* %len, align 4, !dbg !38
  %cmp = icmp slt i32 %0, %1, !dbg !39
  br i1 %cmp, label %for.body, label %for.end, !dbg !40

for.body:                                         ; preds = %for.cond
  %2 = load i32, i32* %i, align 4, !dbg !41
  call void @foo(i32 %2), !dbg !43
  br label %for.inc, !dbg !44

for.inc:                                          ; preds = %for.body
  %3 = load i32, i32* %i, align 4, !dbg !45
  %inc = add nsw i32 %3, 1, !dbg !45
  store i32 %inc, i32* %i, align 4, !dbg !45
  br label %for.cond, !dbg !46, !llvm.loop !47

for.end:                                          ; preds = %for.cond
  %4 = load i32, i32* %sum, align 4, !dbg !49
  %5 = load i32, i32* @sum0, align 4, !dbg !51
  %add = add nsw i32 %4, %5, !dbg !52
  store i32 %add, i32* %sum, align 4, !dbg !53
  store i32 0, i32* %i, align 4, !dbg !54
  br label %for.cond1, !dbg !56

for.cond1:                                        ; preds = %for.inc5, %for.end
  %6 = load i32, i32* %i, align 4, !dbg !57
  %7 = load i32, i32* %len, align 4, !dbg !59
  %cmp2 = icmp slt i32 %6, %7, !dbg !60
  br i1 %cmp2, label %for.body3, label %for.end7, !dbg !61

for.body3:                                        ; preds = %for.cond1
  %8 = load i32, i32* @sum1, align 4, !dbg !62
  %9 = load i32, i32* %i, align 4, !dbg !64
  %add4 = add nsw i32 %8, %9, !dbg !65
  store i32 %add4, i32* @sum1, align 4, !dbg !66
  br label %for.inc5, !dbg !67

for.inc5:                                         ; preds = %for.body3
  %10 = load i32, i32* %i, align 4, !dbg !68
  %inc6 = add nsw i32 %10, 1, !dbg !68
  store i32 %inc6, i32* %i, align 4, !dbg !68
  br label %for.cond1, !dbg !69, !llvm.loop !70

for.end7:                                         ; preds = %for.cond1
  %11 = load i32, i32* %sum, align 4, !dbg !72
  %12 = load i32, i32* @sum1, align 4, !dbg !73
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i64 0, i64 0), i32 %11, i32 %12), !dbg !74
  %13 = load i32, i32* %sum, align 4, !dbg !75
  %14 = load i32, i32* @sum1, align 4, !dbg !75
  %cmp8 = icmp eq i32 %13, %14, !dbg !75
  br i1 %cmp8, label %if.then, label %if.else, !dbg !78

if.then:                                          ; preds = %for.end7
  br label %if.end, !dbg !78

if.else:                                          ; preds = %for.end7
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.1, i64 0, i64 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.2, i64 0, i64 0), i32 84, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !75
  unreachable, !dbg !75

if.end:                                           ; preds = %if.then
  ret i32 0, !dbg !79
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
!llvm.module.flags = !{!9, !10, !11}
!llvm.ident = !{!12}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "sum0", scope: !2, file: !3, line: 54, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/085")
!4 = !{}
!5 = !{!0, !6}
!6 = !DIGlobalVariableExpression(var: !7, expr: !DIExpression())
!7 = distinct !DIGlobalVariable(name: "sum1", scope: !2, file: !3, line: 54, type: !8, isLocal: false, isDefinition: true)
!8 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!9 = !{i32 7, !"Dwarf Version", i32 4}
!10 = !{i32 2, !"Debug Info Version", i32 3}
!11 = !{i32 1, !"wchar_size", i32 4}
!12 = !{!"Ubuntu clang version 11.1.0-6"}
!13 = distinct !DISubprogram(name: "foo", scope: !3, file: !3, line: 57, type: !14, scopeLine: 58, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!14 = !DISubroutineType(types: !15)
!15 = !{null, !8}
!16 = !DILocalVariable(name: "i", arg: 1, scope: !13, file: !3, line: 57, type: !8)
!17 = !DILocation(line: 57, column: 15, scope: !13)
!18 = !DILocation(line: 59, column: 8, scope: !13)
!19 = !DILocation(line: 59, column: 13, scope: !13)
!20 = !DILocation(line: 59, column: 12, scope: !13)
!21 = !DILocation(line: 59, column: 7, scope: !13)
!22 = !DILocation(line: 60, column: 1, scope: !13)
!23 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 62, type: !24, scopeLine: 63, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!24 = !DISubroutineType(types: !25)
!25 = !{!8}
!26 = !DILocalVariable(name: "len", scope: !23, file: !3, line: 64, type: !8)
!27 = !DILocation(line: 64, column: 7, scope: !23)
!28 = !DILocalVariable(name: "i", scope: !23, file: !3, line: 65, type: !8)
!29 = !DILocation(line: 65, column: 7, scope: !23)
!30 = !DILocalVariable(name: "sum", scope: !23, file: !3, line: 65, type: !8)
!31 = !DILocation(line: 65, column: 10, scope: !23)
!32 = !DILocation(line: 69, column: 11, scope: !33)
!33 = distinct !DILexicalBlock(scope: !34, file: !3, line: 69, column: 5)
!34 = distinct !DILexicalBlock(scope: !23, file: !3, line: 67, column: 3)
!35 = !DILocation(line: 69, column: 10, scope: !33)
!36 = !DILocation(line: 69, column: 14, scope: !37)
!37 = distinct !DILexicalBlock(scope: !33, file: !3, line: 69, column: 5)
!38 = !DILocation(line: 69, column: 16, scope: !37)
!39 = !DILocation(line: 69, column: 15, scope: !37)
!40 = !DILocation(line: 69, column: 5, scope: !33)
!41 = !DILocation(line: 71, column: 13, scope: !42)
!42 = distinct !DILexicalBlock(scope: !37, file: !3, line: 70, column: 5)
!43 = !DILocation(line: 71, column: 8, scope: !42)
!44 = !DILocation(line: 72, column: 5, scope: !42)
!45 = !DILocation(line: 69, column: 21, scope: !37)
!46 = !DILocation(line: 69, column: 5, scope: !37)
!47 = distinct !{!47, !40, !48}
!48 = !DILocation(line: 72, column: 5, scope: !33)
!49 = !DILocation(line: 75, column: 12, scope: !50)
!50 = distinct !DILexicalBlock(scope: !34, file: !3, line: 74, column: 5)
!51 = !DILocation(line: 75, column: 16, scope: !50)
!52 = !DILocation(line: 75, column: 15, scope: !50)
!53 = !DILocation(line: 75, column: 10, scope: !50)
!54 = !DILocation(line: 79, column: 9, scope: !55)
!55 = distinct !DILexicalBlock(scope: !23, file: !3, line: 79, column: 3)
!56 = !DILocation(line: 79, column: 8, scope: !55)
!57 = !DILocation(line: 79, column: 12, scope: !58)
!58 = distinct !DILexicalBlock(scope: !55, file: !3, line: 79, column: 3)
!59 = !DILocation(line: 79, column: 14, scope: !58)
!60 = !DILocation(line: 79, column: 13, scope: !58)
!61 = !DILocation(line: 79, column: 3, scope: !55)
!62 = !DILocation(line: 81, column: 10, scope: !63)
!63 = distinct !DILexicalBlock(scope: !58, file: !3, line: 80, column: 3)
!64 = !DILocation(line: 81, column: 15, scope: !63)
!65 = !DILocation(line: 81, column: 14, scope: !63)
!66 = !DILocation(line: 81, column: 9, scope: !63)
!67 = !DILocation(line: 82, column: 3, scope: !63)
!68 = !DILocation(line: 79, column: 19, scope: !58)
!69 = !DILocation(line: 79, column: 3, scope: !58)
!70 = distinct !{!70, !61, !71}
!71 = !DILocation(line: 82, column: 3, scope: !55)
!72 = !DILocation(line: 83, column: 30, scope: !23)
!73 = !DILocation(line: 83, column: 34, scope: !23)
!74 = !DILocation(line: 83, column: 3, scope: !23)
!75 = !DILocation(line: 84, column: 3, scope: !76)
!76 = distinct !DILexicalBlock(scope: !77, file: !3, line: 84, column: 3)
!77 = distinct !DILexicalBlock(scope: !23, file: !3, line: 84, column: 3)
!78 = !DILocation(line: 84, column: 3, scope: !77)
!79 = !DILocation(line: 85, column: 3, scope: !23)
