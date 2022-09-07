; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [11 x i8] c"Sum is %d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !7 {
entry:
  %retval = alloca i32, align 4
  %a = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %a, metadata !11, metadata !DIExpression()), !dbg !12
  call void @llvm.dbg.declare(metadata i32* %i, metadata !13, metadata !DIExpression()), !dbg !14
  store i32 0, i32* %a, align 4, !dbg !15
  store i32 0, i32* %i, align 4, !dbg !17
  br label %for.cond, !dbg !19

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !20
  %cmp = icmp slt i32 %0, 10, !dbg !22
  br i1 %cmp, label %for.body, label %for.end, !dbg !23

for.body:                                         ; preds = %for.cond
  %1 = load i32, i32* %a, align 4, !dbg !24
  %2 = load i32, i32* %i, align 4, !dbg !26
  %add = add nsw i32 %1, %2, !dbg !27
  store i32 %add, i32* %a, align 4, !dbg !28
  br label %for.inc, !dbg !29

for.inc:                                          ; preds = %for.body
  %3 = load i32, i32* %i, align 4, !dbg !30
  %inc = add nsw i32 %3, 1, !dbg !30
  store i32 %inc, i32* %i, align 4, !dbg !30
  br label %for.cond, !dbg !31, !llvm.loop !32

for.end:                                          ; preds = %for.cond
  %4 = load i32, i32* %a, align 4, !dbg !34
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i32 %4), !dbg !35
  ret i32 0, !dbg !36
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @printf(i8*, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/140")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"Ubuntu clang version 11.1.0-6"}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 19, type: !8, scopeLine: 19, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "a", scope: !7, file: !1, line: 20, type: !10)
!12 = !DILocation(line: 20, column: 7, scope: !7)
!13 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 20, type: !10)
!14 = !DILocation(line: 20, column: 10, scope: !7)
!15 = !DILocation(line: 25, column: 7, scope: !16)
!16 = distinct !DILexicalBlock(scope: !7, file: !1, line: 23, column: 3)
!17 = !DILocation(line: 28, column: 11, scope: !18)
!18 = distinct !DILexicalBlock(scope: !16, file: !1, line: 28, column: 5)
!19 = !DILocation(line: 28, column: 10, scope: !18)
!20 = !DILocation(line: 28, column: 15, scope: !21)
!21 = distinct !DILexicalBlock(scope: !18, file: !1, line: 28, column: 5)
!22 = !DILocation(line: 28, column: 16, scope: !21)
!23 = !DILocation(line: 28, column: 5, scope: !18)
!24 = !DILocation(line: 29, column: 11, scope: !25)
!25 = distinct !DILexicalBlock(scope: !21, file: !1, line: 28, column: 25)
!26 = !DILocation(line: 29, column: 15, scope: !25)
!27 = !DILocation(line: 29, column: 13, scope: !25)
!28 = !DILocation(line: 29, column: 9, scope: !25)
!29 = !DILocation(line: 30, column: 5, scope: !25)
!30 = !DILocation(line: 28, column: 22, scope: !21)
!31 = !DILocation(line: 28, column: 5, scope: !21)
!32 = distinct !{!32, !23, !33}
!33 = !DILocation(line: 30, column: 5, scope: !18)
!34 = !DILocation(line: 33, column: 27, scope: !16)
!35 = !DILocation(line: 33, column: 5, scope: !16)
!36 = !DILocation(line: 36, column: 3, scope: !7)
