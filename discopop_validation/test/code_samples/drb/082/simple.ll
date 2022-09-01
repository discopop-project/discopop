; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@foo.q = internal global i32 0, align 4, !dbg !0

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo() #0 !dbg !2 {
entry:
  %0 = load i32, i32* @foo.q, align 4, !dbg !14
  %add = add nsw i32 %0, 1, !dbg !14
  store i32 %add, i32* @foo.q, align 4, !dbg !14
  ret void, !dbg !15
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !16 {
entry:
  %retval = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @foo(), !dbg !19
  ret i32 0, !dbg !21
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!6}
!llvm.module.flags = !{!10, !11, !12}
!llvm.ident = !{!13}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "q", scope: !2, file: !3, line: 56, type: !9, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "foo", scope: !3, file: !3, line: 54, type: !4, scopeLine: 55, spFlags: DISPFlagDefinition, unit: !6, retainedNodes: !7)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/082")
!4 = !DISubroutineType(types: !5)
!5 = !{null}
!6 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !7, globals: !8, splitDebugInlining: false, nameTableKind: None)
!7 = !{}
!8 = !{!0}
!9 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!10 = !{i32 7, !"Dwarf Version", i32 4}
!11 = !{i32 2, !"Debug Info Version", i32 3}
!12 = !{i32 1, !"wchar_size", i32 4}
!13 = !{!"Ubuntu clang version 11.1.0-6"}
!14 = !DILocation(line: 57, column: 5, scope: !2)
!15 = !DILocation(line: 58, column: 1, scope: !2)
!16 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 60, type: !17, scopeLine: 61, spFlags: DISPFlagDefinition, unit: !6, retainedNodes: !7)
!17 = !DISubroutineType(types: !18)
!18 = !{!9}
!19 = !DILocation(line: 64, column: 6, scope: !20)
!20 = distinct !DILexicalBlock(scope: !16, file: !3, line: 63, column: 3)
!21 = !DILocation(line: 66, column: 3, scope: !16)
