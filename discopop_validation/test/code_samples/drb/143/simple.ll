; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [8 x i8] c"x = %d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !7 {
entry:
  %retval = alloca i32, align 4
  %x = alloca i32, align 4
  %y = alloca i32, align 4
  %thrd = alloca i32, align 4
  %tmp = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %x, metadata !11, metadata !DIExpression()), !dbg !12
  store i32 0, i32* %x, align 4, !dbg !12
  call void @llvm.dbg.declare(metadata i32* %y, metadata !13, metadata !DIExpression()), !dbg !14
  call void @llvm.dbg.declare(metadata i32* %thrd, metadata !15, metadata !DIExpression()), !dbg !17
  %call = call i32 @omp_get_thread_num(), !dbg !18
  store i32 %call, i32* %thrd, align 4, !dbg !17
  %0 = load i32, i32* %thrd, align 4, !dbg !19
  %cmp = icmp eq i32 %0, 0, !dbg !21
  br i1 %cmp, label %if.then, label %if.else, !dbg !22

if.then:                                          ; preds = %entry
  store i32 10, i32* %x, align 4, !dbg !23
  store i32 1, i32* %y, align 4, !dbg !26
  br label %if.end5, !dbg !27

if.else:                                          ; preds = %entry
  call void @llvm.dbg.declare(metadata i32* %tmp, metadata !28, metadata !DIExpression()), !dbg !30
  store i32 0, i32* %tmp, align 4, !dbg !30
  br label %while.cond, !dbg !31

while.cond:                                       ; preds = %while.body, %if.else
  %1 = load i32, i32* %tmp, align 4, !dbg !32
  %cmp1 = icmp eq i32 %1, 0, !dbg !33
  br i1 %cmp1, label %while.body, label %while.end, !dbg !31

while.body:                                       ; preds = %while.cond
  %2 = load i32, i32* %y, align 4, !dbg !34
  store i32 %2, i32* %tmp, align 4, !dbg !36
  br label %while.cond, !dbg !31, !llvm.loop !37

while.end:                                        ; preds = %while.cond
  %3 = load i32, i32* %x, align 4, !dbg !39
  %cmp2 = icmp ne i32 %3, 10, !dbg !42
  br i1 %cmp2, label %if.then3, label %if.end, !dbg !43

if.then3:                                         ; preds = %while.end
  %4 = load i32, i32* %x, align 4, !dbg !44
  %call4 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0), i32 %4), !dbg !45
  br label %if.end, !dbg !45

if.end:                                           ; preds = %if.then3, %while.end
  br label %if.end5

if.end5:                                          ; preds = %if.end, %if.then
  ret i32 0, !dbg !46
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @omp_get_thread_num() #2

declare dso_local i32 @printf(i8*, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/143")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"Ubuntu clang version 11.1.0-6"}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 18, type: !8, scopeLine: 18, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "x", scope: !7, file: !1, line: 20, type: !10)
!12 = !DILocation(line: 20, column: 7, scope: !7)
!13 = !DILocalVariable(name: "y", scope: !7, file: !1, line: 20, type: !10)
!14 = !DILocation(line: 20, column: 14, scope: !7)
!15 = !DILocalVariable(name: "thrd", scope: !16, file: !1, line: 24, type: !10)
!16 = distinct !DILexicalBlock(scope: !7, file: !1, line: 23, column: 3)
!17 = !DILocation(line: 24, column: 7, scope: !16)
!18 = !DILocation(line: 24, column: 14, scope: !16)
!19 = !DILocation(line: 25, column: 7, scope: !20)
!20 = distinct !DILexicalBlock(scope: !16, file: !1, line: 25, column: 7)
!21 = !DILocation(line: 25, column: 12, scope: !20)
!22 = !DILocation(line: 25, column: 7, scope: !16)
!23 = !DILocation(line: 27, column: 9, scope: !24)
!24 = distinct !DILexicalBlock(scope: !25, file: !1, line: 27, column: 5)
!25 = distinct !DILexicalBlock(scope: !20, file: !1, line: 25, column: 18)
!26 = !DILocation(line: 32, column: 7, scope: !25)
!27 = !DILocation(line: 33, column: 3, scope: !25)
!28 = !DILocalVariable(name: "tmp", scope: !29, file: !1, line: 34, type: !10)
!29 = distinct !DILexicalBlock(scope: !20, file: !1, line: 33, column: 10)
!30 = !DILocation(line: 34, column: 11, scope: !29)
!31 = !DILocation(line: 35, column: 7, scope: !29)
!32 = !DILocation(line: 35, column: 14, scope: !29)
!33 = !DILocation(line: 35, column: 18, scope: !29)
!34 = !DILocation(line: 37, column: 13, scope: !35)
!35 = distinct !DILexicalBlock(scope: !29, file: !1, line: 35, column: 24)
!36 = !DILocation(line: 37, column: 11, scope: !35)
!37 = distinct !{!37, !31, !38}
!38 = !DILocation(line: 38, column: 7, scope: !29)
!39 = !DILocation(line: 40, column: 11, scope: !40)
!40 = distinct !DILexicalBlock(scope: !41, file: !1, line: 40, column: 11)
!41 = distinct !DILexicalBlock(scope: !29, file: !1, line: 40, column: 5)
!42 = !DILocation(line: 40, column: 12, scope: !40)
!43 = !DILocation(line: 40, column: 11, scope: !41)
!44 = !DILocation(line: 40, column: 37, scope: !40)
!45 = !DILocation(line: 40, column: 18, scope: !40)
!46 = !DILocation(line: 43, column: 3, scope: !7)
