; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [15 x i8] c"numThreads=%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !7 {
entry:
  %retval = alloca i32, align 4
  %numThreads = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %numThreads, metadata !11, metadata !DIExpression()), !dbg !12
  store i32 0, i32* %numThreads, align 4, !dbg !12
  %call = call i32 @omp_get_thread_num(), !dbg !13
  %cmp = icmp eq i32 %call, 0, !dbg !16
  br i1 %cmp, label %if.then, label %if.else, !dbg !17

if.then:                                          ; preds = %entry
  %call1 = call i32 @omp_get_num_threads(), !dbg !18
  store i32 %call1, i32* %numThreads, align 4, !dbg !20
  br label %if.end, !dbg !21

if.else:                                          ; preds = %entry
  %0 = load i32, i32* %numThreads, align 4, !dbg !22
  %call2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str, i64 0, i64 0), i32 %0), !dbg !24
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  ret i32 0, !dbg !25
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @omp_get_thread_num() #2

declare dso_local i32 @omp_get_num_threads() #2

declare dso_local i32 @printf(i8*, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/075")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"Ubuntu clang version 11.1.0-6"}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 54, type: !8, scopeLine: 55, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "numThreads", scope: !7, file: !1, line: 56, type: !10)
!12 = !DILocation(line: 56, column: 7, scope: !7)
!13 = !DILocation(line: 59, column: 10, scope: !14)
!14 = distinct !DILexicalBlock(scope: !15, file: !1, line: 59, column: 10)
!15 = distinct !DILexicalBlock(scope: !7, file: !1, line: 58, column: 3)
!16 = !DILocation(line: 59, column: 30, scope: !14)
!17 = !DILocation(line: 59, column: 10, scope: !15)
!18 = !DILocation(line: 60, column: 20, scope: !19)
!19 = distinct !DILexicalBlock(scope: !14, file: !1, line: 59, column: 36)
!20 = !DILocation(line: 60, column: 18, scope: !19)
!21 = !DILocation(line: 61, column: 5, scope: !19)
!22 = !DILocation(line: 64, column: 33, scope: !23)
!23 = distinct !DILexicalBlock(scope: !14, file: !1, line: 63, column: 5)
!24 = !DILocation(line: 64, column: 7, scope: !23)
!25 = !DILocation(line: 67, column: 3, scope: !7)
