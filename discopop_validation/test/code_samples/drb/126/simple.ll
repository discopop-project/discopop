; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !7 {
entry:
  %retval = alloca i32, align 4
  %section_count = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %section_count, metadata !11, metadata !DIExpression()), !dbg !12
  store i32 0, i32* %section_count, align 4, !dbg !12
  call void @omp_set_dynamic(i32 0), !dbg !13
  call void @omp_set_num_threads(i32 1), !dbg !14
  %0 = load i32, i32* %section_count, align 4, !dbg !15
  %inc = add nsw i32 %0, 1, !dbg !15
  store i32 %inc, i32* %section_count, align 4, !dbg !15
  %1 = load i32, i32* %section_count, align 4, !dbg !18
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 %1), !dbg !19
  %2 = load i32, i32* %section_count, align 4, !dbg !20
  %inc1 = add nsw i32 %2, 1, !dbg !20
  store i32 %inc1, i32* %section_count, align 4, !dbg !20
  %3 = load i32, i32* %section_count, align 4, !dbg !22
  %call2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 %3), !dbg !23
  ret i32 0, !dbg !24
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local void @omp_set_dynamic(i32) #2

declare dso_local void @omp_set_num_threads(i32) #2

declare dso_local i32 @printf(i8*, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/126")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"Ubuntu clang version 11.1.0-6"}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 20, type: !8, scopeLine: 20, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "section_count", scope: !7, file: !1, line: 21, type: !10)
!12 = !DILocation(line: 21, column: 7, scope: !7)
!13 = !DILocation(line: 22, column: 3, scope: !7)
!14 = !DILocation(line: 24, column: 3, scope: !7)
!15 = !DILocation(line: 31, column: 20, scope: !16)
!16 = distinct !DILexicalBlock(scope: !17, file: !1, line: 30, column: 5)
!17 = distinct !DILexicalBlock(scope: !7, file: !1, line: 28, column: 3)
!18 = !DILocation(line: 32, column: 21, scope: !16)
!19 = !DILocation(line: 32, column: 7, scope: !16)
!20 = !DILocation(line: 36, column: 20, scope: !21)
!21 = distinct !DILexicalBlock(scope: !17, file: !1, line: 35, column: 5)
!22 = !DILocation(line: 37, column: 21, scope: !21)
!23 = !DILocation(line: 37, column: 7, scope: !21)
!24 = !DILocation(line: 40, column: 3, scope: !7)
