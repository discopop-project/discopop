; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo() #0 !dbg !7 {
entry:
  %q = alloca i32, align 4
  call void @llvm.dbg.declare(metadata i32* %q, metadata !10, metadata !DIExpression()), !dbg !12
  store i32 0, i32* %q, align 4, !dbg !12
  %0 = load i32, i32* %q, align 4, !dbg !13
  %add = add nsw i32 %0, 1, !dbg !13
  store i32 %add, i32* %q, align 4, !dbg !13
  ret void, !dbg !14
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !15 {
entry:
  %retval = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @foo(), !dbg !18
  ret i32 0, !dbg !20
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/083")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"Ubuntu clang version 11.1.0-6"}
!7 = distinct !DISubprogram(name: "foo", scope: !1, file: !1, line: 53, type: !8, scopeLine: 54, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{null}
!10 = !DILocalVariable(name: "q", scope: !7, file: !1, line: 55, type: !11)
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !DILocation(line: 55, column: 7, scope: !7)
!13 = !DILocation(line: 56, column: 5, scope: !7)
!14 = !DILocation(line: 57, column: 1, scope: !7)
!15 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 59, type: !16, scopeLine: 60, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!16 = !DISubroutineType(types: !17)
!17 = !{!11}
!18 = !DILocation(line: 63, column: 6, scope: !19)
!19 = distinct !DILexicalBlock(scope: !15, file: !1, line: 62, column: 3)
!20 = !DILocation(line: 65, column: 3, scope: !15)
