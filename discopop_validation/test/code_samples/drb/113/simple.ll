; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@a = dso_local global [100 x [100 x i32]] zeroinitializer, align 16, !dbg !0
@b = dso_local global [100 x [100 x i32]] zeroinitializer, align 16, !dbg !6

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !16 {
entry:
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !19, metadata !DIExpression()), !dbg !20
  call void @llvm.dbg.declare(metadata i32* %j, metadata !21, metadata !DIExpression()), !dbg !22
  store i32 0, i32* %i, align 4, !dbg !23
  br label %for.cond, !dbg !25

for.cond:                                         ; preds = %for.inc10, %entry
  %0 = load i32, i32* %i, align 4, !dbg !26
  %cmp = icmp slt i32 %0, 100, !dbg !28
  br i1 %cmp, label %for.body, label %for.end12, !dbg !29

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %j, align 4, !dbg !30
  br label %for.cond1, !dbg !32

for.cond1:                                        ; preds = %for.inc, %for.body
  %1 = load i32, i32* %j, align 4, !dbg !33
  %cmp2 = icmp slt i32 %1, 100, !dbg !35
  br i1 %cmp2, label %for.body3, label %for.end, !dbg !36

for.body3:                                        ; preds = %for.cond1
  %2 = load i32, i32* %i, align 4, !dbg !37
  %idxprom = sext i32 %2 to i64, !dbg !38
  %arrayidx = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* @a, i64 0, i64 %idxprom, !dbg !38
  %3 = load i32, i32* %j, align 4, !dbg !39
  %idxprom4 = sext i32 %3 to i64, !dbg !38
  %arrayidx5 = getelementptr inbounds [100 x i32], [100 x i32]* %arrayidx, i64 0, i64 %idxprom4, !dbg !38
  %4 = load i32, i32* %arrayidx5, align 4, !dbg !38
  %add = add nsw i32 %4, 1, !dbg !40
  %5 = load i32, i32* %i, align 4, !dbg !41
  %idxprom6 = sext i32 %5 to i64, !dbg !42
  %arrayidx7 = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* @a, i64 0, i64 %idxprom6, !dbg !42
  %6 = load i32, i32* %j, align 4, !dbg !43
  %idxprom8 = sext i32 %6 to i64, !dbg !42
  %arrayidx9 = getelementptr inbounds [100 x i32], [100 x i32]* %arrayidx7, i64 0, i64 %idxprom8, !dbg !42
  store i32 %add, i32* %arrayidx9, align 4, !dbg !44
  br label %for.inc, !dbg !42

for.inc:                                          ; preds = %for.body3
  %7 = load i32, i32* %j, align 4, !dbg !45
  %inc = add nsw i32 %7, 1, !dbg !45
  store i32 %inc, i32* %j, align 4, !dbg !45
  br label %for.cond1, !dbg !46, !llvm.loop !47

for.end:                                          ; preds = %for.cond1
  br label %for.inc10, !dbg !48

for.inc10:                                        ; preds = %for.end
  %8 = load i32, i32* %i, align 4, !dbg !49
  %inc11 = add nsw i32 %8, 1, !dbg !49
  store i32 %inc11, i32* %i, align 4, !dbg !49
  br label %for.cond, !dbg !50, !llvm.loop !51

for.end12:                                        ; preds = %for.cond
  store i32 0, i32* %i, align 4, !dbg !53
  br label %for.cond13, !dbg !55

for.cond13:                                       ; preds = %for.inc31, %for.end12
  %9 = load i32, i32* %i, align 4, !dbg !56
  %cmp14 = icmp slt i32 %9, 100, !dbg !58
  br i1 %cmp14, label %for.body15, label %for.end33, !dbg !59

for.body15:                                       ; preds = %for.cond13
  store i32 0, i32* %j, align 4, !dbg !60
  br label %for.cond16, !dbg !62

for.cond16:                                       ; preds = %for.inc28, %for.body15
  %10 = load i32, i32* %j, align 4, !dbg !63
  %cmp17 = icmp slt i32 %10, 100, !dbg !65
  br i1 %cmp17, label %for.body18, label %for.end30, !dbg !66

for.body18:                                       ; preds = %for.cond16
  %11 = load i32, i32* %i, align 4, !dbg !67
  %idxprom19 = sext i32 %11 to i64, !dbg !68
  %arrayidx20 = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* @b, i64 0, i64 %idxprom19, !dbg !68
  %12 = load i32, i32* %j, align 4, !dbg !69
  %idxprom21 = sext i32 %12 to i64, !dbg !68
  %arrayidx22 = getelementptr inbounds [100 x i32], [100 x i32]* %arrayidx20, i64 0, i64 %idxprom21, !dbg !68
  %13 = load i32, i32* %arrayidx22, align 4, !dbg !68
  %add23 = add nsw i32 %13, 1, !dbg !70
  %14 = load i32, i32* %i, align 4, !dbg !71
  %idxprom24 = sext i32 %14 to i64, !dbg !72
  %arrayidx25 = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* @b, i64 0, i64 %idxprom24, !dbg !72
  %15 = load i32, i32* %j, align 4, !dbg !73
  %idxprom26 = sext i32 %15 to i64, !dbg !72
  %arrayidx27 = getelementptr inbounds [100 x i32], [100 x i32]* %arrayidx25, i64 0, i64 %idxprom26, !dbg !72
  store i32 %add23, i32* %arrayidx27, align 4, !dbg !74
  br label %for.inc28, !dbg !72

for.inc28:                                        ; preds = %for.body18
  %16 = load i32, i32* %j, align 4, !dbg !75
  %inc29 = add nsw i32 %16, 1, !dbg !75
  store i32 %inc29, i32* %j, align 4, !dbg !75
  br label %for.cond16, !dbg !76, !llvm.loop !77

for.end30:                                        ; preds = %for.cond16
  br label %for.inc31, !dbg !78

for.inc31:                                        ; preds = %for.end30
  %17 = load i32, i32* %i, align 4, !dbg !79
  %inc32 = add nsw i32 %17, 1, !dbg !79
  store i32 %inc32, i32* %i, align 4, !dbg !79
  br label %for.cond13, !dbg !80, !llvm.loop !81

for.end33:                                        ; preds = %for.cond13
  ret i32 0, !dbg !83
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!12, !13, !14}
!llvm.ident = !{!15}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 53, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/113")
!4 = !{}
!5 = !{!0, !6}
!6 = !DIGlobalVariableExpression(var: !7, expr: !DIExpression())
!7 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !3, line: 54, type: !8, isLocal: false, isDefinition: true)
!8 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 320000, elements: !10)
!9 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!10 = !{!11, !11}
!11 = !DISubrange(count: 100)
!12 = !{i32 7, !"Dwarf Version", i32 4}
!13 = !{i32 2, !"Debug Info Version", i32 3}
!14 = !{i32 1, !"wchar_size", i32 4}
!15 = !{!"Ubuntu clang version 11.1.0-6"}
!16 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 55, type: !17, scopeLine: 56, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!17 = !DISubroutineType(types: !18)
!18 = !{!9}
!19 = !DILocalVariable(name: "i", scope: !16, file: !3, line: 57, type: !9)
!20 = !DILocation(line: 57, column: 7, scope: !16)
!21 = !DILocalVariable(name: "j", scope: !16, file: !3, line: 57, type: !9)
!22 = !DILocation(line: 57, column: 9, scope: !16)
!23 = !DILocation(line: 59, column: 9, scope: !24)
!24 = distinct !DILexicalBlock(scope: !16, file: !3, line: 59, column: 3)
!25 = !DILocation(line: 59, column: 8, scope: !24)
!26 = !DILocation(line: 59, column: 12, scope: !27)
!27 = distinct !DILexicalBlock(scope: !24, file: !3, line: 59, column: 3)
!28 = !DILocation(line: 59, column: 13, scope: !27)
!29 = !DILocation(line: 59, column: 3, scope: !24)
!30 = !DILocation(line: 60, column: 11, scope: !31)
!31 = distinct !DILexicalBlock(scope: !27, file: !3, line: 60, column: 5)
!32 = !DILocation(line: 60, column: 10, scope: !31)
!33 = !DILocation(line: 60, column: 14, scope: !34)
!34 = distinct !DILexicalBlock(scope: !31, file: !3, line: 60, column: 5)
!35 = !DILocation(line: 60, column: 15, scope: !34)
!36 = !DILocation(line: 60, column: 5, scope: !31)
!37 = !DILocation(line: 61, column: 17, scope: !34)
!38 = !DILocation(line: 61, column: 15, scope: !34)
!39 = !DILocation(line: 61, column: 20, scope: !34)
!40 = !DILocation(line: 61, column: 22, scope: !34)
!41 = !DILocation(line: 61, column: 9, scope: !34)
!42 = !DILocation(line: 61, column: 7, scope: !34)
!43 = !DILocation(line: 61, column: 12, scope: !34)
!44 = !DILocation(line: 61, column: 14, scope: !34)
!45 = !DILocation(line: 60, column: 21, scope: !34)
!46 = !DILocation(line: 60, column: 5, scope: !34)
!47 = distinct !{!47, !36, !48}
!48 = !DILocation(line: 61, column: 23, scope: !31)
!49 = !DILocation(line: 59, column: 19, scope: !27)
!50 = !DILocation(line: 59, column: 3, scope: !27)
!51 = distinct !{!51, !29, !52}
!52 = !DILocation(line: 61, column: 23, scope: !24)
!53 = !DILocation(line: 64, column: 9, scope: !54)
!54 = distinct !DILexicalBlock(scope: !16, file: !3, line: 64, column: 3)
!55 = !DILocation(line: 64, column: 8, scope: !54)
!56 = !DILocation(line: 64, column: 12, scope: !57)
!57 = distinct !DILexicalBlock(scope: !54, file: !3, line: 64, column: 3)
!58 = !DILocation(line: 64, column: 13, scope: !57)
!59 = !DILocation(line: 64, column: 3, scope: !54)
!60 = !DILocation(line: 65, column: 11, scope: !61)
!61 = distinct !DILexicalBlock(scope: !57, file: !3, line: 65, column: 5)
!62 = !DILocation(line: 65, column: 10, scope: !61)
!63 = !DILocation(line: 65, column: 14, scope: !64)
!64 = distinct !DILexicalBlock(scope: !61, file: !3, line: 65, column: 5)
!65 = !DILocation(line: 65, column: 15, scope: !64)
!66 = !DILocation(line: 65, column: 5, scope: !61)
!67 = !DILocation(line: 66, column: 17, scope: !64)
!68 = !DILocation(line: 66, column: 15, scope: !64)
!69 = !DILocation(line: 66, column: 20, scope: !64)
!70 = !DILocation(line: 66, column: 22, scope: !64)
!71 = !DILocation(line: 66, column: 9, scope: !64)
!72 = !DILocation(line: 66, column: 7, scope: !64)
!73 = !DILocation(line: 66, column: 12, scope: !64)
!74 = !DILocation(line: 66, column: 14, scope: !64)
!75 = !DILocation(line: 65, column: 21, scope: !64)
!76 = !DILocation(line: 65, column: 5, scope: !64)
!77 = distinct !{!77, !66, !78}
!78 = !DILocation(line: 66, column: 23, scope: !61)
!79 = !DILocation(line: 64, column: 19, scope: !57)
!80 = !DILocation(line: 64, column: 3, scope: !57)
!81 = distinct !{!81, !59, !82}
!82 = !DILocation(line: 66, column: 23, scope: !54)
!83 = !DILocation(line: 68, column: 3, scope: !16)
