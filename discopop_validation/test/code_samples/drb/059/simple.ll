; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [5 x i8] c"x=%d\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo() #0 !dbg !7 {
entry:
  %i = alloca i32, align 4
  %x = alloca i32, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !10, metadata !DIExpression()), !dbg !12
  call void @llvm.dbg.declare(metadata i32* %x, metadata !13, metadata !DIExpression()), !dbg !14
  store i32 0, i32* %i, align 4, !dbg !15
  br label %for.cond, !dbg !17

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !18
  %cmp = icmp slt i32 %0, 100, !dbg !20
  br i1 %cmp, label %for.body, label %for.end, !dbg !21

for.body:                                         ; preds = %for.cond
  %1 = load i32, i32* %i, align 4, !dbg !22
  store i32 %1, i32* %x, align 4, !dbg !23
  br label %for.inc, !dbg !24

for.inc:                                          ; preds = %for.body
  %2 = load i32, i32* %i, align 4, !dbg !25
  %inc = add nsw i32 %2, 1, !dbg !25
  store i32 %inc, i32* %i, align 4, !dbg !25
  br label %for.cond, !dbg !26, !llvm.loop !27

for.end:                                          ; preds = %for.cond
  %3 = load i32, i32* %x, align 4, !dbg !29
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i64 0, i64 0), i32 %3), !dbg !30
  ret void, !dbg !31
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @printf(i8*, ...) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !32 {
entry:
  %retval = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @foo(), !dbg !35
  ret i32 0, !dbg !36
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/059")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"Ubuntu clang version 11.1.0-6"}
!7 = distinct !DISubprogram(name: "foo", scope: !1, file: !1, line: 56, type: !8, scopeLine: 57, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{null}
!10 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 58, type: !11)
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !DILocation(line: 58, column: 7, scope: !7)
!13 = !DILocalVariable(name: "x", scope: !7, file: !1, line: 58, type: !11)
!14 = !DILocation(line: 58, column: 9, scope: !7)
!15 = !DILocation(line: 60, column: 9, scope: !16)
!16 = distinct !DILexicalBlock(scope: !7, file: !1, line: 60, column: 3)
!17 = !DILocation(line: 60, column: 8, scope: !16)
!18 = !DILocation(line: 60, column: 12, scope: !19)
!19 = distinct !DILexicalBlock(scope: !16, file: !1, line: 60, column: 3)
!20 = !DILocation(line: 60, column: 13, scope: !19)
!21 = !DILocation(line: 60, column: 3, scope: !16)
!22 = !DILocation(line: 61, column: 7, scope: !19)
!23 = !DILocation(line: 61, column: 6, scope: !19)
!24 = !DILocation(line: 61, column: 5, scope: !19)
!25 = !DILocation(line: 60, column: 19, scope: !19)
!26 = !DILocation(line: 60, column: 3, scope: !19)
!27 = distinct !{!27, !21, !28}
!28 = !DILocation(line: 61, column: 7, scope: !16)
!29 = !DILocation(line: 62, column: 17, scope: !7)
!30 = !DILocation(line: 62, column: 3, scope: !7)
!31 = !DILocation(line: 63, column: 1, scope: !7)
!32 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 65, type: !33, scopeLine: 66, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!33 = !DISubroutineType(types: !34)
!34 = !{!11}
!35 = !DILocation(line: 67, column: 3, scope: !32)
!36 = !DILocation(line: 68, column: 3, scope: !32)
