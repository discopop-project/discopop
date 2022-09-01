; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [6 x i8] c"a=%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo() #0 !dbg !7 {
entry:
  %a = alloca i32, align 4
  call void @llvm.dbg.declare(metadata i32* %a, metadata !10, metadata !DIExpression()), !dbg !12
  store i32 0, i32* %a, align 4, !dbg !12
  %0 = load i32, i32* %a, align 4, !dbg !13
  %inc = add nsw i32 %0, 1, !dbg !13
  store i32 %inc, i32* %a, align 4, !dbg !13
  %1 = load i32, i32* %a, align 4, !dbg !16
  %inc1 = add nsw i32 %1, 1, !dbg !16
  store i32 %inc1, i32* %a, align 4, !dbg !16
  %2 = load i32, i32* %a, align 4, !dbg !18
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str, i64 0, i64 0), i32 %2), !dbg !19
  ret void, !dbg !20
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @printf(i8*, ...) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !21 {
entry:
  %retval = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @foo(), !dbg !24
  ret i32 0, !dbg !25
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/173")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"Ubuntu clang version 11.1.0-6"}
!7 = distinct !DISubprogram(name: "foo", scope: !1, file: !1, line: 21, type: !8, scopeLine: 21, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{null}
!10 = !DILocalVariable(name: "a", scope: !7, file: !1, line: 22, type: !11)
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !DILocation(line: 22, column: 7, scope: !7)
!13 = !DILocation(line: 30, column: 8, scope: !14)
!14 = distinct !DILexicalBlock(scope: !15, file: !1, line: 28, column: 5)
!15 = distinct !DILexicalBlock(scope: !7, file: !1, line: 26, column: 3)
!16 = !DILocation(line: 36, column: 8, scope: !17)
!17 = distinct !DILexicalBlock(scope: !15, file: !1, line: 34, column: 5)
!18 = !DILocation(line: 40, column: 20, scope: !7)
!19 = !DILocation(line: 40, column: 3, scope: !7)
!20 = !DILocation(line: 41, column: 1, scope: !7)
!21 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 43, type: !22, scopeLine: 43, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!22 = !DISubroutineType(types: !23)
!23 = !{!11}
!24 = !DILocation(line: 44, column: 3, scope: !21)
!25 = !DILocation(line: 46, column: 3, scope: !21)
