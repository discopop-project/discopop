; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@sum0 = dso_local global i32 0, align 4, !dbg !0
@sum1 = dso_local global i32 0, align 4, !dbg !6
@.str.3 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"len\00", align 1
@.str.5 = private unnamed_addr constant [4 x i8] c"sum\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.7 = private unnamed_addr constant [5 x i8] c"sum0\00", align 1
@.str.8 = private unnamed_addr constant [5 x i8] c"sum1\00", align 1
@.str = private unnamed_addr constant [17 x i8] c"sum=%d; sum1=%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [10 x i8] c"sum==sum1\00", align 1
@.str.2 = private unnamed_addr constant [9 x i8] c"simple.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !13 {
entry:
  call void @__dp_func_entry(i32 16442, i32 1)
  %retval = alloca i32, align 4
  %len = alloca i32, align 4
  %i = alloca i32, align 4
  %sum = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16442, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %len, metadata !16, metadata !DIExpression()), !dbg !17
  %1 = ptrtoint i32* %len to i64
  call void @__dp_write(i32 16444, i64 %1, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  store i32 1000, i32* %len, align 4, !dbg !17
  call void @llvm.dbg.declare(metadata i32* %i, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32* %sum, metadata !20, metadata !DIExpression()), !dbg !21
  %2 = ptrtoint i32* %sum to i64
  call void @__dp_write(i32 16445, i64 %2, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i32 0, i32 0))
  store i32 0, i32* %sum, align 4, !dbg !21
  %3 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16449, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !22
  br label %for.cond, !dbg !25

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16449, i32 0)
  %4 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16449, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %5 = load i32, i32* %i, align 4, !dbg !26
  %6 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16449, i64 %6, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  %7 = load i32, i32* %len, align 4, !dbg !28
  %cmp = icmp slt i32 %5, %7, !dbg !29
  br i1 %cmp, label %for.body, label %for.end, !dbg !30

for.body:                                         ; preds = %for.cond
  %8 = ptrtoint i32* @sum0 to i64
  call void @__dp_read(i32 16451, i64 %8, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.7, i32 0, i32 0))
  %9 = load i32, i32* @sum0, align 4, !dbg !31
  %10 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16451, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %11 = load i32, i32* %i, align 4, !dbg !33
  %add = add nsw i32 %9, %11, !dbg !34
  %12 = ptrtoint i32* @sum0 to i64
  call void @__dp_write(i32 16451, i64 %12, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.7, i32 0, i32 0))
  store i32 %add, i32* @sum0, align 4, !dbg !35
  br label %for.inc, !dbg !36

for.inc:                                          ; preds = %for.body
  %13 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16449, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %14 = load i32, i32* %i, align 4, !dbg !37
  %inc = add nsw i32 %14, 1, !dbg !37
  %15 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16449, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !37
  br label %for.cond, !dbg !38, !llvm.loop !39

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16455, i32 0)
  %16 = ptrtoint i32* %sum to i64
  call void @__dp_read(i32 16455, i64 %16, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i32 0, i32 0))
  %17 = load i32, i32* %sum, align 4, !dbg !41
  %18 = ptrtoint i32* @sum0 to i64
  call void @__dp_read(i32 16455, i64 %18, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.7, i32 0, i32 0))
  %19 = load i32, i32* @sum0, align 4, !dbg !43
  %add1 = add nsw i32 %17, %19, !dbg !44
  %20 = ptrtoint i32* %sum to i64
  call void @__dp_write(i32 16455, i64 %20, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i32 0, i32 0))
  store i32 %add1, i32* %sum, align 4, !dbg !45
  %21 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16459, i64 %21, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !46
  br label %for.cond2, !dbg !48

for.cond2:                                        ; preds = %for.inc6, %for.end
  call void @__dp_loop_entry(i32 16459, i32 1)
  %22 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16459, i64 %22, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %23 = load i32, i32* %i, align 4, !dbg !49
  %24 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16459, i64 %24, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  %25 = load i32, i32* %len, align 4, !dbg !51
  %cmp3 = icmp slt i32 %23, %25, !dbg !52
  br i1 %cmp3, label %for.body4, label %for.end8, !dbg !53

for.body4:                                        ; preds = %for.cond2
  %26 = ptrtoint i32* @sum1 to i64
  call void @__dp_read(i32 16461, i64 %26, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.8, i32 0, i32 0))
  %27 = load i32, i32* @sum1, align 4, !dbg !54
  %28 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16461, i64 %28, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %29 = load i32, i32* %i, align 4, !dbg !56
  %add5 = add nsw i32 %27, %29, !dbg !57
  %30 = ptrtoint i32* @sum1 to i64
  call void @__dp_write(i32 16461, i64 %30, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.8, i32 0, i32 0))
  store i32 %add5, i32* @sum1, align 4, !dbg !58
  br label %for.inc6, !dbg !59

for.inc6:                                         ; preds = %for.body4
  %31 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16459, i64 %31, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %32 = load i32, i32* %i, align 4, !dbg !60
  %inc7 = add nsw i32 %32, 1, !dbg !60
  %33 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16459, i64 %33, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 %inc7, i32* %i, align 4, !dbg !60
  br label %for.cond2, !dbg !61, !llvm.loop !62

for.end8:                                         ; preds = %for.cond2
  call void @__dp_loop_exit(i32 16463, i32 1)
  %34 = ptrtoint i32* %sum to i64
  call void @__dp_read(i32 16463, i64 %34, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i32 0, i32 0))
  %35 = load i32, i32* %sum, align 4, !dbg !64
  %36 = ptrtoint i32* @sum1 to i64
  call void @__dp_read(i32 16463, i64 %36, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.8, i32 0, i32 0))
  %37 = load i32, i32* @sum1, align 4, !dbg !65
  call void @__dp_call(i32 16463), !dbg !66
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i64 0, i64 0), i32 %35, i32 %37), !dbg !66
  %38 = ptrtoint i32* %sum to i64
  call void @__dp_read(i32 16464, i64 %38, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i32 0, i32 0))
  %39 = load i32, i32* %sum, align 4, !dbg !67
  %40 = ptrtoint i32* @sum1 to i64
  call void @__dp_read(i32 16464, i64 %40, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.8, i32 0, i32 0))
  %41 = load i32, i32* @sum1, align 4, !dbg !67
  %cmp9 = icmp eq i32 %39, %41, !dbg !67
  br i1 %cmp9, label %if.then, label %if.else, !dbg !70

if.then:                                          ; preds = %for.end8
  br label %if.end, !dbg !70

if.else:                                          ; preds = %for.end8
  call void @__dp_finalize(i32 16464), !dbg !67
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.1, i64 0, i64 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.2, i64 0, i64 0), i32 80, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !67
  unreachable, !dbg !67

if.end:                                           ; preds = %if.then
  call void @__dp_finalize(i32 16465), !dbg !71
  ret i32 0, !dbg !71
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

; Function Attrs: noreturn nounwind
declare dso_local void @__assert_fail(i8*, i8*, i32, i8*) #3

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!9}
!llvm.module.flags = !{!10, !11, !12}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "sum0", scope: !2, file: !3, line: 55, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/091")
!4 = !{}
!5 = !{!0, !6}
!6 = !DIGlobalVariableExpression(var: !7, expr: !DIExpression())
!7 = distinct !DIGlobalVariable(name: "sum1", scope: !2, file: !3, line: 55, type: !8, isLocal: false, isDefinition: true)
!8 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!9 = !{!"Ubuntu clang version 11.1.0-6"}
!10 = !{i32 7, !"Dwarf Version", i32 4}
!11 = !{i32 2, !"Debug Info Version", i32 3}
!12 = !{i32 1, !"wchar_size", i32 4}
!13 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 58, type: !14, scopeLine: 59, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!14 = !DISubroutineType(types: !15)
!15 = !{!8}
!16 = !DILocalVariable(name: "len", scope: !13, file: !3, line: 60, type: !8)
!17 = !DILocation(line: 60, column: 7, scope: !13)
!18 = !DILocalVariable(name: "i", scope: !13, file: !3, line: 61, type: !8)
!19 = !DILocation(line: 61, column: 7, scope: !13)
!20 = !DILocalVariable(name: "sum", scope: !13, file: !3, line: 61, type: !8)
!21 = !DILocation(line: 61, column: 10, scope: !13)
!22 = !DILocation(line: 65, column: 11, scope: !23)
!23 = distinct !DILexicalBlock(scope: !24, file: !3, line: 65, column: 5)
!24 = distinct !DILexicalBlock(scope: !13, file: !3, line: 63, column: 3)
!25 = !DILocation(line: 65, column: 10, scope: !23)
!26 = !DILocation(line: 65, column: 14, scope: !27)
!27 = distinct !DILexicalBlock(scope: !23, file: !3, line: 65, column: 5)
!28 = !DILocation(line: 65, column: 16, scope: !27)
!29 = !DILocation(line: 65, column: 15, scope: !27)
!30 = !DILocation(line: 65, column: 5, scope: !23)
!31 = !DILocation(line: 67, column: 12, scope: !32)
!32 = distinct !DILexicalBlock(scope: !27, file: !3, line: 66, column: 5)
!33 = !DILocation(line: 67, column: 17, scope: !32)
!34 = !DILocation(line: 67, column: 16, scope: !32)
!35 = !DILocation(line: 67, column: 11, scope: !32)
!36 = !DILocation(line: 68, column: 5, scope: !32)
!37 = !DILocation(line: 65, column: 21, scope: !27)
!38 = !DILocation(line: 65, column: 5, scope: !27)
!39 = distinct !{!39, !30, !40}
!40 = !DILocation(line: 68, column: 5, scope: !23)
!41 = !DILocation(line: 71, column: 12, scope: !42)
!42 = distinct !DILexicalBlock(scope: !24, file: !3, line: 70, column: 5)
!43 = !DILocation(line: 71, column: 16, scope: !42)
!44 = !DILocation(line: 71, column: 15, scope: !42)
!45 = !DILocation(line: 71, column: 10, scope: !42)
!46 = !DILocation(line: 75, column: 9, scope: !47)
!47 = distinct !DILexicalBlock(scope: !13, file: !3, line: 75, column: 3)
!48 = !DILocation(line: 75, column: 8, scope: !47)
!49 = !DILocation(line: 75, column: 12, scope: !50)
!50 = distinct !DILexicalBlock(scope: !47, file: !3, line: 75, column: 3)
!51 = !DILocation(line: 75, column: 14, scope: !50)
!52 = !DILocation(line: 75, column: 13, scope: !50)
!53 = !DILocation(line: 75, column: 3, scope: !47)
!54 = !DILocation(line: 77, column: 10, scope: !55)
!55 = distinct !DILexicalBlock(scope: !50, file: !3, line: 76, column: 3)
!56 = !DILocation(line: 77, column: 15, scope: !55)
!57 = !DILocation(line: 77, column: 14, scope: !55)
!58 = !DILocation(line: 77, column: 9, scope: !55)
!59 = !DILocation(line: 78, column: 3, scope: !55)
!60 = !DILocation(line: 75, column: 19, scope: !50)
!61 = !DILocation(line: 75, column: 3, scope: !50)
!62 = distinct !{!62, !53, !63}
!63 = !DILocation(line: 78, column: 3, scope: !47)
!64 = !DILocation(line: 79, column: 30, scope: !13)
!65 = !DILocation(line: 79, column: 34, scope: !13)
!66 = !DILocation(line: 79, column: 3, scope: !13)
!67 = !DILocation(line: 80, column: 3, scope: !68)
!68 = distinct !DILexicalBlock(scope: !69, file: !3, line: 80, column: 3)
!69 = distinct !DILexicalBlock(scope: !13, file: !3, line: 80, column: 3)
!70 = !DILocation(line: 80, column: 3, scope: !69)
!71 = !DILocation(line: 81, column: 3, scope: !13)
