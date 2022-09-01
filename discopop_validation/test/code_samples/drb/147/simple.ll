; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@var = dso_local global i32 0, align 4, !dbg !0
@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !11 {
entry:
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !14, metadata !DIExpression()), !dbg !16
  store i32 0, i32* %i, align 4, !dbg !16
  br label %for.cond, !dbg !17

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !18
  %cmp = icmp slt i32 %0, 100, !dbg !20
  br i1 %cmp, label %for.body, label %for.end, !dbg !21

for.body:                                         ; preds = %for.cond
  %1 = load i32, i32* @var, align 4, !dbg !22
  %inc = add nsw i32 %1, 1, !dbg !22
  store i32 %inc, i32* @var, align 4, !dbg !22
  %2 = load i32, i32* @var, align 4, !dbg !24
  %sub = sub nsw i32 %2, 2, !dbg !24
  store i32 %sub, i32* @var, align 4, !dbg !24
  br label %for.inc, !dbg !25

for.inc:                                          ; preds = %for.body
  %3 = load i32, i32* %i, align 4, !dbg !26
  %inc1 = add nsw i32 %3, 1, !dbg !26
  store i32 %inc1, i32* %i, align 4, !dbg !26
  br label %for.cond, !dbg !27, !llvm.loop !28

for.end:                                          ; preds = %for.cond
  %4 = load i32, i32* @var, align 4, !dbg !30
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 %4), !dbg !31
  ret i32 0, !dbg !32
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @printf(i8*, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!7, !8, !9}
!llvm.ident = !{!10}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "var", scope: !2, file: !3, line: 21, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/147")
!4 = !{}
!5 = !{!0}
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !{i32 7, !"Dwarf Version", i32 4}
!8 = !{i32 2, !"Debug Info Version", i32 3}
!9 = !{i32 1, !"wchar_size", i32 4}
!10 = !{!"Ubuntu clang version 11.1.0-6"}
!11 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 23, type: !12, scopeLine: 23, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!12 = !DISubroutineType(types: !13)
!13 = !{!6}
!14 = !DILocalVariable(name: "i", scope: !15, file: !3, line: 27, type: !6)
!15 = distinct !DILexicalBlock(scope: !11, file: !3, line: 27, column: 3)
!16 = !DILocation(line: 27, column: 11, scope: !15)
!17 = !DILocation(line: 27, column: 7, scope: !15)
!18 = !DILocation(line: 27, column: 16, scope: !19)
!19 = distinct !DILexicalBlock(scope: !15, file: !3, line: 27, column: 3)
!20 = !DILocation(line: 27, column: 17, scope: !19)
!21 = !DILocation(line: 27, column: 3, scope: !15)
!22 = !DILocation(line: 29, column: 8, scope: !23)
!23 = distinct !DILexicalBlock(scope: !19, file: !3, line: 27, column: 25)
!24 = !DILocation(line: 32, column: 9, scope: !23)
!25 = !DILocation(line: 33, column: 3, scope: !23)
!26 = !DILocation(line: 27, column: 22, scope: !19)
!27 = !DILocation(line: 27, column: 3, scope: !19)
!28 = distinct !{!28, !21, !29}
!29 = !DILocation(line: 33, column: 3, scope: !15)
!30 = !DILocation(line: 35, column: 17, scope: !11)
!31 = !DILocation(line: 35, column: 3, scope: !11)
!32 = !DILocation(line: 36, column: 3, scope: !11)
