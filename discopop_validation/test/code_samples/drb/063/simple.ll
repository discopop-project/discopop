; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@n = dso_local global i32 100, align 4, !dbg !0
@m = dso_local global i32 100, align 4, !dbg !6
@b = dso_local global [100 x [100 x double]] zeroinitializer, align 16, !dbg !9

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo() #0 !dbg !19 {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !22, metadata !DIExpression()), !dbg !23
  call void @llvm.dbg.declare(metadata i32* %j, metadata !24, metadata !DIExpression()), !dbg !25
  store i32 0, i32* %i, align 4, !dbg !26
  br label %for.cond, !dbg !28

for.cond:                                         ; preds = %for.inc10, %entry
  %0 = load i32, i32* %i, align 4, !dbg !29
  %1 = load i32, i32* @n, align 4, !dbg !31
  %cmp = icmp slt i32 %0, %1, !dbg !32
  br i1 %cmp, label %for.body, label %for.end12, !dbg !33

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %j, align 4, !dbg !34
  br label %for.cond1, !dbg !36

for.cond1:                                        ; preds = %for.inc, %for.body
  %2 = load i32, i32* %j, align 4, !dbg !37
  %3 = load i32, i32* @m, align 4, !dbg !39
  %sub = sub nsw i32 %3, 1, !dbg !40
  %cmp2 = icmp slt i32 %2, %sub, !dbg !41
  br i1 %cmp2, label %for.body3, label %for.end, !dbg !42

for.body3:                                        ; preds = %for.cond1
  %4 = load i32, i32* %i, align 4, !dbg !43
  %idxprom = sext i32 %4 to i64, !dbg !44
  %arrayidx = getelementptr inbounds [100 x [100 x double]], [100 x [100 x double]]* @b, i64 0, i64 %idxprom, !dbg !44
  %5 = load i32, i32* %j, align 4, !dbg !45
  %add = add nsw i32 %5, 1, !dbg !46
  %idxprom4 = sext i32 %add to i64, !dbg !44
  %arrayidx5 = getelementptr inbounds [100 x double], [100 x double]* %arrayidx, i64 0, i64 %idxprom4, !dbg !44
  %6 = load double, double* %arrayidx5, align 8, !dbg !44
  %7 = load i32, i32* %i, align 4, !dbg !47
  %idxprom6 = sext i32 %7 to i64, !dbg !48
  %arrayidx7 = getelementptr inbounds [100 x [100 x double]], [100 x [100 x double]]* @b, i64 0, i64 %idxprom6, !dbg !48
  %8 = load i32, i32* %j, align 4, !dbg !49
  %idxprom8 = sext i32 %8 to i64, !dbg !48
  %arrayidx9 = getelementptr inbounds [100 x double], [100 x double]* %arrayidx7, i64 0, i64 %idxprom8, !dbg !48
  store double %6, double* %arrayidx9, align 8, !dbg !50
  br label %for.inc, !dbg !48

for.inc:                                          ; preds = %for.body3
  %9 = load i32, i32* %j, align 4, !dbg !51
  %inc = add nsw i32 %9, 1, !dbg !51
  store i32 %inc, i32* %j, align 4, !dbg !51
  br label %for.cond1, !dbg !52, !llvm.loop !53

for.end:                                          ; preds = %for.cond1
  br label %for.inc10, !dbg !54

for.inc10:                                        ; preds = %for.end
  %10 = load i32, i32* %i, align 4, !dbg !55
  %inc11 = add nsw i32 %10, 1, !dbg !55
  store i32 %inc11, i32* %i, align 4, !dbg !55
  br label %for.cond, !dbg !56, !llvm.loop !57

for.end12:                                        ; preds = %for.cond
  ret void, !dbg !59
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !60 {
entry:
  %retval = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @foo(), !dbg !63
  ret i32 0, !dbg !64
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!15, !16, !17}
!llvm.ident = !{!18}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "n", scope: !2, file: !3, line: 51, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/063")
!4 = !{}
!5 = !{!0, !6, !9}
!6 = !DIGlobalVariableExpression(var: !7, expr: !DIExpression())
!7 = distinct !DIGlobalVariable(name: "m", scope: !2, file: !3, line: 51, type: !8, isLocal: false, isDefinition: true)
!8 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!9 = !DIGlobalVariableExpression(var: !10, expr: !DIExpression())
!10 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !3, line: 52, type: !11, isLocal: false, isDefinition: true)
!11 = !DICompositeType(tag: DW_TAG_array_type, baseType: !12, size: 640000, elements: !13)
!12 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!13 = !{!14, !14}
!14 = !DISubrange(count: 100)
!15 = !{i32 7, !"Dwarf Version", i32 4}
!16 = !{i32 2, !"Debug Info Version", i32 3}
!17 = !{i32 1, !"wchar_size", i32 4}
!18 = !{!"Ubuntu clang version 11.1.0-6"}
!19 = distinct !DISubprogram(name: "foo", scope: !3, file: !3, line: 54, type: !20, scopeLine: 55, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!20 = !DISubroutineType(types: !21)
!21 = !{null}
!22 = !DILocalVariable(name: "i", scope: !19, file: !3, line: 56, type: !8)
!23 = !DILocation(line: 56, column: 7, scope: !19)
!24 = !DILocalVariable(name: "j", scope: !19, file: !3, line: 56, type: !8)
!25 = !DILocation(line: 56, column: 9, scope: !19)
!26 = !DILocation(line: 58, column: 9, scope: !27)
!27 = distinct !DILexicalBlock(scope: !19, file: !3, line: 58, column: 3)
!28 = !DILocation(line: 58, column: 8, scope: !27)
!29 = !DILocation(line: 58, column: 12, scope: !30)
!30 = distinct !DILexicalBlock(scope: !27, file: !3, line: 58, column: 3)
!31 = !DILocation(line: 58, column: 14, scope: !30)
!32 = !DILocation(line: 58, column: 13, scope: !30)
!33 = !DILocation(line: 58, column: 3, scope: !27)
!34 = !DILocation(line: 59, column: 11, scope: !35)
!35 = distinct !DILexicalBlock(scope: !30, file: !3, line: 59, column: 5)
!36 = !DILocation(line: 59, column: 10, scope: !35)
!37 = !DILocation(line: 59, column: 14, scope: !38)
!38 = distinct !DILexicalBlock(scope: !35, file: !3, line: 59, column: 5)
!39 = !DILocation(line: 59, column: 16, scope: !38)
!40 = !DILocation(line: 59, column: 17, scope: !38)
!41 = !DILocation(line: 59, column: 15, scope: !38)
!42 = !DILocation(line: 59, column: 5, scope: !35)
!43 = !DILocation(line: 60, column: 17, scope: !38)
!44 = !DILocation(line: 60, column: 15, scope: !38)
!45 = !DILocation(line: 60, column: 20, scope: !38)
!46 = !DILocation(line: 60, column: 21, scope: !38)
!47 = !DILocation(line: 60, column: 9, scope: !38)
!48 = !DILocation(line: 60, column: 7, scope: !38)
!49 = !DILocation(line: 60, column: 12, scope: !38)
!50 = !DILocation(line: 60, column: 14, scope: !38)
!51 = !DILocation(line: 59, column: 21, scope: !38)
!52 = !DILocation(line: 59, column: 5, scope: !38)
!53 = distinct !{!53, !42, !54}
!54 = !DILocation(line: 60, column: 23, scope: !35)
!55 = !DILocation(line: 58, column: 17, scope: !30)
!56 = !DILocation(line: 58, column: 3, scope: !30)
!57 = distinct !{!57, !33, !58}
!58 = !DILocation(line: 60, column: 23, scope: !27)
!59 = !DILocation(line: 61, column: 1, scope: !19)
!60 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 63, type: !61, scopeLine: 64, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!61 = !DISubroutineType(types: !62)
!62 = !{!8}
!63 = !DILocation(line: 65, column: 3, scope: !60)
!64 = !DILocation(line: 66, column: 3, scope: !60)
