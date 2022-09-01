; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [7 x i8] c"%f %f\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !9 {
entry:
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %q = alloca [10 x double], align 16
  %qq = alloca [10 x double], align 16
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !13, metadata !DIExpression()), !dbg !14
  call void @llvm.dbg.declare(metadata [10 x double]* %q, metadata !15, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata [10 x double]* %qq, metadata !20, metadata !DIExpression()), !dbg !21
  store i32 0, i32* %i, align 4, !dbg !22
  br label %for.cond, !dbg !24

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !25
  %cmp = icmp slt i32 %0, 10, !dbg !27
  br i1 %cmp, label %for.body, label %for.end, !dbg !28

for.body:                                         ; preds = %for.cond
  %1 = load i32, i32* %i, align 4, !dbg !29
  %conv = sitofp i32 %1 to double, !dbg !30
  %2 = load i32, i32* %i, align 4, !dbg !31
  %idxprom = sext i32 %2 to i64, !dbg !32
  %arrayidx = getelementptr inbounds [10 x double], [10 x double]* %qq, i64 0, i64 %idxprom, !dbg !32
  store double %conv, double* %arrayidx, align 8, !dbg !33
  br label %for.inc, !dbg !32

for.inc:                                          ; preds = %for.body
  %3 = load i32, i32* %i, align 4, !dbg !34
  %inc = add nsw i32 %3, 1, !dbg !34
  store i32 %inc, i32* %i, align 4, !dbg !34
  br label %for.cond, !dbg !35, !llvm.loop !36

for.end:                                          ; preds = %for.cond
  store i32 0, i32* %i, align 4, !dbg !38
  br label %for.cond1, !dbg !40

for.cond1:                                        ; preds = %for.inc8, %for.end
  %4 = load i32, i32* %i, align 4, !dbg !41
  %cmp2 = icmp slt i32 %4, 10, !dbg !43
  br i1 %cmp2, label %for.body4, label %for.end10, !dbg !44

for.body4:                                        ; preds = %for.cond1
  %5 = load i32, i32* %i, align 4, !dbg !45
  %conv5 = sitofp i32 %5 to double, !dbg !46
  %6 = load i32, i32* %i, align 4, !dbg !47
  %idxprom6 = sext i32 %6 to i64, !dbg !48
  %arrayidx7 = getelementptr inbounds [10 x double], [10 x double]* %q, i64 0, i64 %idxprom6, !dbg !48
  store double %conv5, double* %arrayidx7, align 8, !dbg !49
  br label %for.inc8, !dbg !48

for.inc8:                                         ; preds = %for.body4
  %7 = load i32, i32* %i, align 4, !dbg !50
  %inc9 = add nsw i32 %7, 1, !dbg !50
  store i32 %inc9, i32* %i, align 4, !dbg !50
  br label %for.cond1, !dbg !51, !llvm.loop !52

for.end10:                                        ; preds = %for.cond1
  store i32 0, i32* %i, align 4, !dbg !54
  br label %for.cond11, !dbg !57

for.cond11:                                       ; preds = %for.inc19, %for.end10
  %8 = load i32, i32* %i, align 4, !dbg !58
  %cmp12 = icmp slt i32 %8, 10, !dbg !60
  br i1 %cmp12, label %for.body14, label %for.end21, !dbg !61

for.body14:                                       ; preds = %for.cond11
  %9 = load i32, i32* %i, align 4, !dbg !62
  %idxprom15 = sext i32 %9 to i64, !dbg !63
  %arrayidx16 = getelementptr inbounds [10 x double], [10 x double]* %qq, i64 0, i64 %idxprom15, !dbg !63
  %10 = load double, double* %arrayidx16, align 8, !dbg !63
  %11 = load i32, i32* %i, align 4, !dbg !64
  %idxprom17 = sext i32 %11 to i64, !dbg !65
  %arrayidx18 = getelementptr inbounds [10 x double], [10 x double]* %q, i64 0, i64 %idxprom17, !dbg !65
  %12 = load double, double* %arrayidx18, align 8, !dbg !66
  %add = fadd double %12, %10, !dbg !66
  store double %add, double* %arrayidx18, align 8, !dbg !66
  br label %for.inc19, !dbg !65

for.inc19:                                        ; preds = %for.body14
  %13 = load i32, i32* %i, align 4, !dbg !67
  %inc20 = add nsw i32 %13, 1, !dbg !67
  store i32 %inc20, i32* %i, align 4, !dbg !67
  br label %for.cond11, !dbg !68, !llvm.loop !69

for.end21:                                        ; preds = %for.cond11
  %arrayidx22 = getelementptr inbounds [10 x double], [10 x double]* %q, i64 0, i64 9, !dbg !71
  %14 = load double, double* %arrayidx22, align 8, !dbg !73
  %add23 = fadd double %14, 1.000000e+00, !dbg !73
  store double %add23, double* %arrayidx22, align 8, !dbg !73
  %arrayidx24 = getelementptr inbounds [10 x double], [10 x double]* %q, i64 0, i64 9, !dbg !74
  %15 = load double, double* %arrayidx24, align 8, !dbg !74
  %sub = fsub double %15, 1.000000e+00, !dbg !76
  %arrayidx25 = getelementptr inbounds [10 x double], [10 x double]* %q, i64 0, i64 9, !dbg !77
  store double %sub, double* %arrayidx25, align 8, !dbg !78
  store i32 0, i32* %i, align 4, !dbg !79
  br label %for.cond26, !dbg !81

for.cond26:                                       ; preds = %for.inc34, %for.end21
  %16 = load i32, i32* %i, align 4, !dbg !82
  %cmp27 = icmp slt i32 %16, 10, !dbg !84
  br i1 %cmp27, label %for.body29, label %for.end36, !dbg !85

for.body29:                                       ; preds = %for.cond26
  %17 = load i32, i32* %i, align 4, !dbg !86
  %idxprom30 = sext i32 %17 to i64, !dbg !87
  %arrayidx31 = getelementptr inbounds [10 x double], [10 x double]* %qq, i64 0, i64 %idxprom30, !dbg !87
  %18 = load double, double* %arrayidx31, align 8, !dbg !87
  %19 = load i32, i32* %i, align 4, !dbg !88
  %idxprom32 = sext i32 %19 to i64, !dbg !89
  %arrayidx33 = getelementptr inbounds [10 x double], [10 x double]* %q, i64 0, i64 %idxprom32, !dbg !89
  %20 = load double, double* %arrayidx33, align 8, !dbg !89
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i64 0, i64 0), double %18, double %20), !dbg !90
  br label %for.inc34, !dbg !90

for.inc34:                                        ; preds = %for.body29
  %21 = load i32, i32* %i, align 4, !dbg !91
  %inc35 = add nsw i32 %21, 1, !dbg !91
  store i32 %inc35, i32* %i, align 4, !dbg !91
  br label %for.cond26, !dbg !92, !llvm.loop !93

for.end36:                                        ; preds = %for.cond26
  ret i32 0, !dbg !95
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @printf(i8*, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!5, !6, !7}
!llvm.ident = !{!8}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/172")
!2 = !{}
!3 = !{!4}
!4 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!5 = !{i32 7, !"Dwarf Version", i32 4}
!6 = !{i32 2, !"Debug Info Version", i32 3}
!7 = !{i32 1, !"wchar_size", i32 4}
!8 = !{!"Ubuntu clang version 11.1.0-6"}
!9 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 18, type: !10, scopeLine: 18, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!10 = !DISubroutineType(types: !11)
!11 = !{!12}
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !DILocalVariable(name: "i", scope: !9, file: !1, line: 19, type: !12)
!14 = !DILocation(line: 19, column: 7, scope: !9)
!15 = !DILocalVariable(name: "q", scope: !9, file: !1, line: 20, type: !16)
!16 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 640, elements: !17)
!17 = !{!18}
!18 = !DISubrange(count: 10)
!19 = !DILocation(line: 20, column: 10, scope: !9)
!20 = !DILocalVariable(name: "qq", scope: !9, file: !1, line: 20, type: !16)
!21 = !DILocation(line: 20, column: 17, scope: !9)
!22 = !DILocation(line: 22, column: 10, scope: !23)
!23 = distinct !DILexicalBlock(scope: !9, file: !1, line: 22, column: 3)
!24 = !DILocation(line: 22, column: 8, scope: !23)
!25 = !DILocation(line: 22, column: 15, scope: !26)
!26 = distinct !DILexicalBlock(scope: !23, file: !1, line: 22, column: 3)
!27 = !DILocation(line: 22, column: 17, scope: !26)
!28 = !DILocation(line: 22, column: 3, scope: !23)
!29 = !DILocation(line: 22, column: 44, scope: !26)
!30 = !DILocation(line: 22, column: 36, scope: !26)
!31 = !DILocation(line: 22, column: 31, scope: !26)
!32 = !DILocation(line: 22, column: 28, scope: !26)
!33 = !DILocation(line: 22, column: 34, scope: !26)
!34 = !DILocation(line: 22, column: 24, scope: !26)
!35 = !DILocation(line: 22, column: 3, scope: !26)
!36 = distinct !{!36, !28, !37}
!37 = !DILocation(line: 22, column: 44, scope: !23)
!38 = !DILocation(line: 23, column: 10, scope: !39)
!39 = distinct !DILexicalBlock(scope: !9, file: !1, line: 23, column: 3)
!40 = !DILocation(line: 23, column: 8, scope: !39)
!41 = !DILocation(line: 23, column: 15, scope: !42)
!42 = distinct !DILexicalBlock(scope: !39, file: !1, line: 23, column: 3)
!43 = !DILocation(line: 23, column: 17, scope: !42)
!44 = !DILocation(line: 23, column: 3, scope: !39)
!45 = !DILocation(line: 23, column: 43, scope: !42)
!46 = !DILocation(line: 23, column: 35, scope: !42)
!47 = !DILocation(line: 23, column: 30, scope: !42)
!48 = !DILocation(line: 23, column: 28, scope: !42)
!49 = !DILocation(line: 23, column: 33, scope: !42)
!50 = !DILocation(line: 23, column: 24, scope: !42)
!51 = !DILocation(line: 23, column: 3, scope: !42)
!52 = distinct !{!52, !44, !53}
!53 = !DILocation(line: 23, column: 43, scope: !39)
!54 = !DILocation(line: 28, column: 12, scope: !55)
!55 = distinct !DILexicalBlock(scope: !56, file: !1, line: 28, column: 5)
!56 = distinct !DILexicalBlock(scope: !9, file: !1, line: 26, column: 3)
!57 = !DILocation(line: 28, column: 10, scope: !55)
!58 = !DILocation(line: 28, column: 17, scope: !59)
!59 = distinct !DILexicalBlock(scope: !55, file: !1, line: 28, column: 5)
!60 = !DILocation(line: 28, column: 19, scope: !59)
!61 = !DILocation(line: 28, column: 5, scope: !55)
!62 = !DILocation(line: 29, column: 18, scope: !59)
!63 = !DILocation(line: 29, column: 15, scope: !59)
!64 = !DILocation(line: 29, column: 9, scope: !59)
!65 = !DILocation(line: 29, column: 7, scope: !59)
!66 = !DILocation(line: 29, column: 12, scope: !59)
!67 = !DILocation(line: 28, column: 26, scope: !59)
!68 = !DILocation(line: 28, column: 5, scope: !59)
!69 = distinct !{!69, !61, !70}
!70 = !DILocation(line: 29, column: 19, scope: !55)
!71 = !DILocation(line: 33, column: 7, scope: !72)
!72 = distinct !DILexicalBlock(scope: !56, file: !1, line: 32, column: 5)
!73 = !DILocation(line: 33, column: 12, scope: !72)
!74 = !DILocation(line: 38, column: 14, scope: !75)
!75 = distinct !DILexicalBlock(scope: !56, file: !1, line: 37, column: 5)
!76 = !DILocation(line: 38, column: 19, scope: !75)
!77 = !DILocation(line: 38, column: 7, scope: !75)
!78 = !DILocation(line: 38, column: 12, scope: !75)
!79 = !DILocation(line: 43, column: 10, scope: !80)
!80 = distinct !DILexicalBlock(scope: !9, file: !1, line: 43, column: 3)
!81 = !DILocation(line: 43, column: 8, scope: !80)
!82 = !DILocation(line: 43, column: 15, scope: !83)
!83 = distinct !DILexicalBlock(scope: !80, file: !1, line: 43, column: 3)
!84 = !DILocation(line: 43, column: 17, scope: !83)
!85 = !DILocation(line: 43, column: 3, scope: !80)
!86 = !DILocation(line: 43, column: 47, scope: !83)
!87 = !DILocation(line: 43, column: 44, scope: !83)
!88 = !DILocation(line: 43, column: 52, scope: !83)
!89 = !DILocation(line: 43, column: 50, scope: !83)
!90 = !DILocation(line: 43, column: 27, scope: !83)
!91 = !DILocation(line: 43, column: 24, scope: !83)
!92 = !DILocation(line: 43, column: 3, scope: !83)
!93 = distinct !{!93, !85, !94}
!94 = !DILocation(line: 43, column: 54, scope: !80)
!95 = !DILocation(line: 45, column: 3, scope: !9)
