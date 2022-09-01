; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [8 x i8] c"sum=%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @f1(i32* %q) #0 !dbg !7 {
entry:
  %q.addr = alloca i32*, align 8
  store i32* %q, i32** %q.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %q.addr, metadata !12, metadata !DIExpression()), !dbg !13
  %0 = load i32*, i32** %q.addr, align 8, !dbg !14
  store i32 1, i32* %0, align 4, !dbg !15
  ret void, !dbg !16
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !17 {
entry:
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %sum = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !20, metadata !DIExpression()), !dbg !21
  store i32 0, i32* %i, align 4, !dbg !21
  call void @llvm.dbg.declare(metadata i32* %sum, metadata !22, metadata !DIExpression()), !dbg !23
  store i32 0, i32* %sum, align 4, !dbg !23
  call void @f1(i32* %i), !dbg !24
  %0 = load i32, i32* %i, align 4, !dbg !26
  %1 = load i32, i32* %sum, align 4, !dbg !27
  %add = add nsw i32 %1, %0, !dbg !27
  store i32 %add, i32* %sum, align 4, !dbg !27
  %2 = load i32, i32* %sum, align 4, !dbg !28
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0), i32 %2), !dbg !29
  ret i32 0, !dbg !30
}

declare dso_local i32 @printf(i8*, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/076")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"Ubuntu clang version 11.1.0-6"}
!7 = distinct !DISubprogram(name: "f1", scope: !1, file: !1, line: 57, type: !8, scopeLine: 58, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{null, !10}
!10 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 64)
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !DILocalVariable(name: "q", arg: 1, scope: !7, file: !1, line: 57, type: !10)
!13 = !DILocation(line: 57, column: 14, scope: !7)
!14 = !DILocation(line: 59, column: 4, scope: !7)
!15 = !DILocation(line: 59, column: 6, scope: !7)
!16 = !DILocation(line: 60, column: 1, scope: !7)
!17 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 62, type: !18, scopeLine: 63, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!18 = !DISubroutineType(types: !19)
!19 = !{!11}
!20 = !DILocalVariable(name: "i", scope: !17, file: !1, line: 64, type: !11)
!21 = !DILocation(line: 64, column: 7, scope: !17)
!22 = !DILocalVariable(name: "sum", scope: !17, file: !1, line: 64, type: !11)
!23 = !DILocation(line: 64, column: 12, scope: !17)
!24 = !DILocation(line: 67, column: 6, scope: !25)
!25 = distinct !DILexicalBlock(scope: !17, file: !1, line: 66, column: 3)
!26 = !DILocation(line: 68, column: 13, scope: !25)
!27 = !DILocation(line: 68, column: 10, scope: !25)
!28 = !DILocation(line: 71, column: 22, scope: !17)
!29 = !DILocation(line: 71, column: 3, scope: !17)
!30 = !DILocation(line: 72, column: 3, scope: !17)
