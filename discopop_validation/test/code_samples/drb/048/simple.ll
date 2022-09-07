; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@a = dso_local global [100 x i32] zeroinitializer, align 16, !dbg !0

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo(i32* %a, i32 %n, i32 %g) #0 !dbg !14 {
entry:
  %a.addr = alloca i32*, align 8
  %n.addr = alloca i32, align 4
  %g.addr = alloca i32, align 4
  %i = alloca i32, align 4
  store i32* %a, i32** %a.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %a.addr, metadata !18, metadata !DIExpression()), !dbg !19
  store i32 %n, i32* %n.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %n.addr, metadata !20, metadata !DIExpression()), !dbg !21
  store i32 %g, i32* %g.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %g.addr, metadata !22, metadata !DIExpression()), !dbg !23
  call void @llvm.dbg.declare(metadata i32* %i, metadata !24, metadata !DIExpression()), !dbg !25
  store i32 0, i32* %i, align 4, !dbg !26
  br label %for.cond, !dbg !28

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !29
  %1 = load i32, i32* %n.addr, align 4, !dbg !31
  %cmp = icmp slt i32 %0, %1, !dbg !32
  br i1 %cmp, label %for.body, label %for.end, !dbg !33

for.body:                                         ; preds = %for.cond
  %2 = load i32*, i32** %a.addr, align 8, !dbg !34
  %3 = load i32, i32* %i, align 4, !dbg !36
  %idxprom = sext i32 %3 to i64, !dbg !34
  %arrayidx = getelementptr inbounds i32, i32* %2, i64 %idxprom, !dbg !34
  %4 = load i32, i32* %arrayidx, align 4, !dbg !34
  %5 = load i32, i32* %g.addr, align 4, !dbg !37
  %add = add nsw i32 %4, %5, !dbg !38
  %6 = load i32*, i32** %a.addr, align 8, !dbg !39
  %7 = load i32, i32* %i, align 4, !dbg !40
  %idxprom1 = sext i32 %7 to i64, !dbg !39
  %arrayidx2 = getelementptr inbounds i32, i32* %6, i64 %idxprom1, !dbg !39
  store i32 %add, i32* %arrayidx2, align 4, !dbg !41
  br label %for.inc, !dbg !42

for.inc:                                          ; preds = %for.body
  %8 = load i32, i32* %i, align 4, !dbg !43
  %inc = add nsw i32 %8, 1, !dbg !43
  store i32 %inc, i32* %i, align 4, !dbg !43
  br label %for.cond, !dbg !44, !llvm.loop !45

for.end:                                          ; preds = %for.cond
  ret void, !dbg !47
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !48 {
entry:
  %retval = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @foo(i32* getelementptr inbounds ([100 x i32], [100 x i32]* @a, i64 0, i64 0), i32 100, i32 7), !dbg !51
  ret i32 0, !dbg !52
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!10, !11, !12}
!llvm.ident = !{!13}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 61, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/048")
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
!14 = distinct !DISubprogram(name: "foo", scope: !3, file: !3, line: 51, type: !15, scopeLine: 52, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!15 = !DISubroutineType(types: !16)
!16 = !{null, !17, !7, !7}
!17 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!18 = !DILocalVariable(name: "a", arg: 1, scope: !14, file: !3, line: 51, type: !17)
!19 = !DILocation(line: 51, column: 16, scope: !14)
!20 = !DILocalVariable(name: "n", arg: 2, scope: !14, file: !3, line: 51, type: !7)
!21 = !DILocation(line: 51, column: 23, scope: !14)
!22 = !DILocalVariable(name: "g", arg: 3, scope: !14, file: !3, line: 51, type: !7)
!23 = !DILocation(line: 51, column: 30, scope: !14)
!24 = !DILocalVariable(name: "i", scope: !14, file: !3, line: 53, type: !7)
!25 = !DILocation(line: 53, column: 7, scope: !14)
!26 = !DILocation(line: 55, column: 9, scope: !27)
!27 = distinct !DILexicalBlock(scope: !14, file: !3, line: 55, column: 3)
!28 = !DILocation(line: 55, column: 8, scope: !27)
!29 = !DILocation(line: 55, column: 12, scope: !30)
!30 = distinct !DILexicalBlock(scope: !27, file: !3, line: 55, column: 3)
!31 = !DILocation(line: 55, column: 14, scope: !30)
!32 = !DILocation(line: 55, column: 13, scope: !30)
!33 = !DILocation(line: 55, column: 3, scope: !27)
!34 = !DILocation(line: 57, column: 12, scope: !35)
!35 = distinct !DILexicalBlock(scope: !30, file: !3, line: 56, column: 3)
!36 = !DILocation(line: 57, column: 14, scope: !35)
!37 = !DILocation(line: 57, column: 17, scope: !35)
!38 = !DILocation(line: 57, column: 16, scope: !35)
!39 = !DILocation(line: 57, column: 5, scope: !35)
!40 = !DILocation(line: 57, column: 7, scope: !35)
!41 = !DILocation(line: 57, column: 10, scope: !35)
!42 = !DILocation(line: 58, column: 3, scope: !35)
!43 = !DILocation(line: 55, column: 17, scope: !30)
!44 = !DILocation(line: 55, column: 3, scope: !30)
!45 = distinct !{!45, !33, !46}
!46 = !DILocation(line: 58, column: 3, scope: !27)
!47 = !DILocation(line: 59, column: 1, scope: !14)
!48 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 62, type: !49, scopeLine: 63, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!49 = !DISubroutineType(types: !50)
!50 = !{!7}
!51 = !DILocation(line: 64, column: 3, scope: !48)
!52 = !DILocation(line: 65, column: 3, scope: !48)
