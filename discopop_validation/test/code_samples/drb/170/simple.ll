; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !7 {
entry:
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %m = alloca i32, align 4
  %tmp1 = alloca double, align 8
  %a = alloca [12 x [12 x [12 x double]]], align 16
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !11, metadata !DIExpression()), !dbg !12
  call void @llvm.dbg.declare(metadata i32* %j, metadata !13, metadata !DIExpression()), !dbg !14
  call void @llvm.dbg.declare(metadata i32* %k, metadata !15, metadata !DIExpression()), !dbg !16
  call void @llvm.dbg.declare(metadata i32* %m, metadata !17, metadata !DIExpression()), !dbg !18
  call void @llvm.dbg.declare(metadata double* %tmp1, metadata !19, metadata !DIExpression()), !dbg !21
  call void @llvm.dbg.declare(metadata [12 x [12 x [12 x double]]]* %a, metadata !22, metadata !DIExpression()), !dbg !26
  store i32 3, i32* %m, align 4, !dbg !27
  store i32 0, i32* %i, align 4, !dbg !28
  br label %for.cond, !dbg !30

for.cond:                                         ; preds = %for.inc14, %entry
  %0 = load i32, i32* %i, align 4, !dbg !31
  %cmp = icmp slt i32 %0, 12, !dbg !33
  br i1 %cmp, label %for.body, label %for.end16, !dbg !34

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %j, align 4, !dbg !35
  br label %for.cond1, !dbg !38

for.cond1:                                        ; preds = %for.inc11, %for.body
  %1 = load i32, i32* %j, align 4, !dbg !39
  %cmp2 = icmp slt i32 %1, 12, !dbg !41
  br i1 %cmp2, label %for.body3, label %for.end13, !dbg !42

for.body3:                                        ; preds = %for.cond1
  store i32 0, i32* %k, align 4, !dbg !43
  br label %for.cond4, !dbg !46

for.cond4:                                        ; preds = %for.inc, %for.body3
  %2 = load i32, i32* %k, align 4, !dbg !47
  %cmp5 = icmp slt i32 %2, 12, !dbg !49
  br i1 %cmp5, label %for.body6, label %for.end, !dbg !50

for.body6:                                        ; preds = %for.cond4
  %3 = load i32, i32* %m, align 4, !dbg !51
  %conv = sitofp i32 %3 to double, !dbg !51
  %div = fdiv double 6.000000e+00, %conv, !dbg !53
  store double %div, double* %tmp1, align 8, !dbg !54
  %4 = load double, double* %tmp1, align 8, !dbg !55
  %add = fadd double %4, 4.000000e+00, !dbg !56
  %5 = load i32, i32* %i, align 4, !dbg !57
  %idxprom = sext i32 %5 to i64, !dbg !58
  %arrayidx = getelementptr inbounds [12 x [12 x [12 x double]]], [12 x [12 x [12 x double]]]* %a, i64 0, i64 %idxprom, !dbg !58
  %6 = load i32, i32* %j, align 4, !dbg !59
  %idxprom7 = sext i32 %6 to i64, !dbg !58
  %arrayidx8 = getelementptr inbounds [12 x [12 x double]], [12 x [12 x double]]* %arrayidx, i64 0, i64 %idxprom7, !dbg !58
  %7 = load i32, i32* %k, align 4, !dbg !60
  %idxprom9 = sext i32 %7 to i64, !dbg !58
  %arrayidx10 = getelementptr inbounds [12 x double], [12 x double]* %arrayidx8, i64 0, i64 %idxprom9, !dbg !58
  store double %add, double* %arrayidx10, align 8, !dbg !61
  br label %for.inc, !dbg !62

for.inc:                                          ; preds = %for.body6
  %8 = load i32, i32* %k, align 4, !dbg !63
  %inc = add nsw i32 %8, 1, !dbg !63
  store i32 %inc, i32* %k, align 4, !dbg !63
  br label %for.cond4, !dbg !64, !llvm.loop !65

for.end:                                          ; preds = %for.cond4
  br label %for.inc11, !dbg !67

for.inc11:                                        ; preds = %for.end
  %9 = load i32, i32* %j, align 4, !dbg !68
  %inc12 = add nsw i32 %9, 1, !dbg !68
  store i32 %inc12, i32* %j, align 4, !dbg !68
  br label %for.cond1, !dbg !69, !llvm.loop !70

for.end13:                                        ; preds = %for.cond1
  br label %for.inc14, !dbg !72

for.inc14:                                        ; preds = %for.end13
  %10 = load i32, i32* %i, align 4, !dbg !73
  %inc15 = add nsw i32 %10, 1, !dbg !73
  store i32 %inc15, i32* %i, align 4, !dbg !73
  br label %for.cond, !dbg !74, !llvm.loop !75

for.end16:                                        ; preds = %for.cond
  ret i32 0, !dbg !77
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/170")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"Ubuntu clang version 11.1.0-6"}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 18, type: !8, scopeLine: 18, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 19, type: !10)
!12 = !DILocation(line: 19, column: 7, scope: !7)
!13 = !DILocalVariable(name: "j", scope: !7, file: !1, line: 19, type: !10)
!14 = !DILocation(line: 19, column: 9, scope: !7)
!15 = !DILocalVariable(name: "k", scope: !7, file: !1, line: 19, type: !10)
!16 = !DILocation(line: 19, column: 11, scope: !7)
!17 = !DILocalVariable(name: "m", scope: !7, file: !1, line: 19, type: !10)
!18 = !DILocation(line: 19, column: 13, scope: !7)
!19 = !DILocalVariable(name: "tmp1", scope: !7, file: !1, line: 20, type: !20)
!20 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!21 = !DILocation(line: 20, column: 10, scope: !7)
!22 = !DILocalVariable(name: "a", scope: !7, file: !1, line: 22, type: !23)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !20, size: 110592, elements: !24)
!24 = !{!25, !25, !25}
!25 = !DISubrange(count: 12)
!26 = !DILocation(line: 22, column: 10, scope: !7)
!27 = !DILocation(line: 24, column: 5, scope: !7)
!28 = !DILocation(line: 27, column: 10, scope: !29)
!29 = distinct !DILexicalBlock(scope: !7, file: !1, line: 27, column: 3)
!30 = !DILocation(line: 27, column: 8, scope: !29)
!31 = !DILocation(line: 27, column: 15, scope: !32)
!32 = distinct !DILexicalBlock(scope: !29, file: !1, line: 27, column: 3)
!33 = !DILocation(line: 27, column: 17, scope: !32)
!34 = !DILocation(line: 27, column: 3, scope: !29)
!35 = !DILocation(line: 28, column: 12, scope: !36)
!36 = distinct !DILexicalBlock(scope: !37, file: !1, line: 28, column: 5)
!37 = distinct !DILexicalBlock(scope: !32, file: !1, line: 27, column: 28)
!38 = !DILocation(line: 28, column: 10, scope: !36)
!39 = !DILocation(line: 28, column: 17, scope: !40)
!40 = distinct !DILexicalBlock(scope: !36, file: !1, line: 28, column: 5)
!41 = !DILocation(line: 28, column: 19, scope: !40)
!42 = !DILocation(line: 28, column: 5, scope: !36)
!43 = !DILocation(line: 29, column: 14, scope: !44)
!44 = distinct !DILexicalBlock(scope: !45, file: !1, line: 29, column: 7)
!45 = distinct !DILexicalBlock(scope: !40, file: !1, line: 28, column: 30)
!46 = !DILocation(line: 29, column: 12, scope: !44)
!47 = !DILocation(line: 29, column: 19, scope: !48)
!48 = distinct !DILexicalBlock(scope: !44, file: !1, line: 29, column: 7)
!49 = !DILocation(line: 29, column: 21, scope: !48)
!50 = !DILocation(line: 29, column: 7, scope: !44)
!51 = !DILocation(line: 30, column: 20, scope: !52)
!52 = distinct !DILexicalBlock(scope: !48, file: !1, line: 29, column: 32)
!53 = !DILocation(line: 30, column: 19, scope: !52)
!54 = !DILocation(line: 30, column: 14, scope: !52)
!55 = !DILocation(line: 31, column: 22, scope: !52)
!56 = !DILocation(line: 31, column: 26, scope: !52)
!57 = !DILocation(line: 31, column: 11, scope: !52)
!58 = !DILocation(line: 31, column: 9, scope: !52)
!59 = !DILocation(line: 31, column: 14, scope: !52)
!60 = !DILocation(line: 31, column: 17, scope: !52)
!61 = !DILocation(line: 31, column: 20, scope: !52)
!62 = !DILocation(line: 32, column: 7, scope: !52)
!63 = !DILocation(line: 29, column: 28, scope: !48)
!64 = !DILocation(line: 29, column: 7, scope: !48)
!65 = distinct !{!65, !50, !66}
!66 = !DILocation(line: 32, column: 7, scope: !44)
!67 = !DILocation(line: 33, column: 5, scope: !45)
!68 = !DILocation(line: 28, column: 26, scope: !40)
!69 = !DILocation(line: 28, column: 5, scope: !40)
!70 = distinct !{!70, !42, !71}
!71 = !DILocation(line: 33, column: 5, scope: !36)
!72 = !DILocation(line: 34, column: 3, scope: !37)
!73 = !DILocation(line: 27, column: 24, scope: !32)
!74 = !DILocation(line: 27, column: 3, scope: !32)
!75 = distinct !{!75, !34, !76}
!76 = !DILocation(line: 34, column: 3, scope: !29)
!77 = !DILocation(line: 36, column: 3, scope: !7)
