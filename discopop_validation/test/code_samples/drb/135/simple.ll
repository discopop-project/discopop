; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !7 {
entry:
  %retval = alloca i32, align 4
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %c = alloca i32, align 4
  %d = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %a, metadata !11, metadata !DIExpression()), !dbg !12
  call void @llvm.dbg.declare(metadata i32* %b, metadata !13, metadata !DIExpression()), !dbg !14
  call void @llvm.dbg.declare(metadata i32* %c, metadata !15, metadata !DIExpression()), !dbg !16
  call void @llvm.dbg.declare(metadata i32* %d, metadata !17, metadata !DIExpression()), !dbg !18
  store i32 1, i32* %c, align 4, !dbg !19
  store i32 2, i32* %a, align 4, !dbg !21
  store i32 3, i32* %b, align 4, !dbg !22
  %0 = load i32, i32* %a, align 4, !dbg !23
  %1 = load i32, i32* %c, align 4, !dbg !24
  %add = add nsw i32 %1, %0, !dbg !24
  store i32 %add, i32* %c, align 4, !dbg !24
  %2 = load i32, i32* %b, align 4, !dbg !25
  %3 = load i32, i32* %c, align 4, !dbg !26
  %add1 = add nsw i32 %3, %2, !dbg !26
  store i32 %add1, i32* %c, align 4, !dbg !26
  %4 = load i32, i32* %c, align 4, !dbg !27
  store i32 %4, i32* %d, align 4, !dbg !28
  %5 = load i32, i32* %d, align 4, !dbg !29
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 %5), !dbg !30
  ret i32 0, !dbg !31
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
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/135")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"Ubuntu clang version 11.1.0-6"}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 20, type: !8, scopeLine: 20, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "a", scope: !7, file: !1, line: 21, type: !10)
!12 = !DILocation(line: 21, column: 7, scope: !7)
!13 = !DILocalVariable(name: "b", scope: !7, file: !1, line: 21, type: !10)
!14 = !DILocation(line: 21, column: 10, scope: !7)
!15 = !DILocalVariable(name: "c", scope: !7, file: !1, line: 21, type: !10)
!16 = !DILocation(line: 21, column: 13, scope: !7)
!17 = !DILocalVariable(name: "d", scope: !7, file: !1, line: 21, type: !10)
!18 = !DILocation(line: 21, column: 16, scope: !7)
!19 = !DILocation(line: 27, column: 9, scope: !20)
!20 = distinct !DILexicalBlock(scope: !7, file: !1, line: 25, column: 3)
!21 = !DILocation(line: 29, column: 9, scope: !20)
!22 = !DILocation(line: 31, column: 9, scope: !20)
!23 = !DILocation(line: 33, column: 12, scope: !20)
!24 = !DILocation(line: 33, column: 9, scope: !20)
!25 = !DILocation(line: 35, column: 12, scope: !20)
!26 = !DILocation(line: 35, column: 9, scope: !20)
!27 = !DILocation(line: 37, column: 11, scope: !20)
!28 = !DILocation(line: 37, column: 9, scope: !20)
!29 = !DILocation(line: 40, column: 17, scope: !7)
!30 = !DILocation(line: 40, column: 3, scope: !7)
!31 = !DILocation(line: 41, column: 3, scope: !7)
