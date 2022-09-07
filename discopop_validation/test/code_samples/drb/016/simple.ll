; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@a = dso_local global [100 x i32] zeroinitializer, align 16, !dbg !0
@.str = private unnamed_addr constant [5 x i8] c"x=%d\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !14 {
entry:
  %retval = alloca i32, align 4
  %len = alloca i32, align 4
  %i = alloca i32, align 4
  %x = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %len, metadata !17, metadata !DIExpression()), !dbg !18
  store i32 100, i32* %len, align 4, !dbg !18
  call void @llvm.dbg.declare(metadata i32* %i, metadata !19, metadata !DIExpression()), !dbg !20
  call void @llvm.dbg.declare(metadata i32* %x, metadata !21, metadata !DIExpression()), !dbg !22
  store i32 10, i32* %x, align 4, !dbg !22
  store i32 0, i32* %i, align 4, !dbg !23
  br label %for.cond, !dbg !25

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !26
  %1 = load i32, i32* %len, align 4, !dbg !28
  %cmp = icmp slt i32 %0, %1, !dbg !29
  br i1 %cmp, label %for.body, label %for.end, !dbg !30

for.body:                                         ; preds = %for.cond
  %2 = load i32, i32* %x, align 4, !dbg !31
  %3 = load i32, i32* %i, align 4, !dbg !33
  %idxprom = sext i32 %3 to i64, !dbg !34
  %arrayidx = getelementptr inbounds [100 x i32], [100 x i32]* @a, i64 0, i64 %idxprom, !dbg !34
  store i32 %2, i32* %arrayidx, align 4, !dbg !35
  %4 = load i32, i32* %i, align 4, !dbg !36
  store i32 %4, i32* %x, align 4, !dbg !37
  br label %for.inc, !dbg !38

for.inc:                                          ; preds = %for.body
  %5 = load i32, i32* %i, align 4, !dbg !39
  %inc = add nsw i32 %5, 1, !dbg !39
  store i32 %inc, i32* %i, align 4, !dbg !39
  br label %for.cond, !dbg !40, !llvm.loop !41

for.end:                                          ; preds = %for.cond
  %6 = load i32, i32* %x, align 4, !dbg !43
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i64 0, i64 0), i32 %6), !dbg !44
  ret i32 0, !dbg !45
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @printf(i8*, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!10, !11, !12}
!llvm.ident = !{!13}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 63, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/016")
!4 = !{}
!5 = !{!0}
!6 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 3200, elements: !8)
!7 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!8 = !{!9}
!9 = !DISubrange(count: 100)
!10 = !{i32 7, !"Dwarf Version", i32 4}
!11 = !{i32 2, !"Debug Info Version", i32 3}
!12 = !{i32 1, !"wchar_size", i32 4}
!13 = !{!"Ubuntu clang version 11.1.0-6"}
!14 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 65, type: !15, scopeLine: 66, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!15 = !DISubroutineType(types: !16)
!16 = !{!7}
!17 = !DILocalVariable(name: "len", scope: !14, file: !3, line: 67, type: !7)
!18 = !DILocation(line: 67, column: 7, scope: !14)
!19 = !DILocalVariable(name: "i", scope: !14, file: !3, line: 68, type: !7)
!20 = !DILocation(line: 68, column: 7, scope: !14)
!21 = !DILocalVariable(name: "x", scope: !14, file: !3, line: 68, type: !7)
!22 = !DILocation(line: 68, column: 9, scope: !14)
!23 = !DILocation(line: 71, column: 9, scope: !24)
!24 = distinct !DILexicalBlock(scope: !14, file: !3, line: 71, column: 3)
!25 = !DILocation(line: 71, column: 8, scope: !24)
!26 = !DILocation(line: 71, column: 12, scope: !27)
!27 = distinct !DILexicalBlock(scope: !24, file: !3, line: 71, column: 3)
!28 = !DILocation(line: 71, column: 14, scope: !27)
!29 = !DILocation(line: 71, column: 13, scope: !27)
!30 = !DILocation(line: 71, column: 3, scope: !24)
!31 = !DILocation(line: 73, column: 12, scope: !32)
!32 = distinct !DILexicalBlock(scope: !27, file: !3, line: 72, column: 3)
!33 = !DILocation(line: 73, column: 7, scope: !32)
!34 = !DILocation(line: 73, column: 5, scope: !32)
!35 = !DILocation(line: 73, column: 10, scope: !32)
!36 = !DILocation(line: 74, column: 7, scope: !32)
!37 = !DILocation(line: 74, column: 6, scope: !32)
!38 = !DILocation(line: 75, column: 3, scope: !32)
!39 = !DILocation(line: 71, column: 19, scope: !27)
!40 = !DILocation(line: 71, column: 3, scope: !27)
!41 = distinct !{!41, !30, !42}
!42 = !DILocation(line: 75, column: 3, scope: !24)
!43 = !DILocation(line: 76, column: 17, scope: !14)
!44 = !DILocation(line: 76, column: 3, scope: !14)
!45 = !DILocation(line: 77, column: 3, scope: !14)
