; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [10 x i8] c"c[50]=%f\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !9 {
entry:
  %retval = alloca i32, align 4
  %len = alloca i32, align 4
  %saved_stack = alloca i8*, align 8
  %__vla_expr0 = alloca i64, align 8
  %__vla_expr1 = alloca i64, align 8
  %__vla_expr2 = alloca i64, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %len, metadata !13, metadata !DIExpression()), !dbg !14
  store i32 100, i32* %len, align 4, !dbg !14
  %0 = load i32, i32* %len, align 4, !dbg !15
  %1 = zext i32 %0 to i64, !dbg !16
  %2 = call i8* @llvm.stacksave(), !dbg !16
  store i8* %2, i8** %saved_stack, align 8, !dbg !16
  %vla = alloca double, i64 %1, align 16, !dbg !16
  store i64 %1, i64* %__vla_expr0, align 8, !dbg !16
  call void @llvm.dbg.declare(metadata i64* %__vla_expr0, metadata !17, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata double* %vla, metadata !20, metadata !DIExpression()), !dbg !24
  %3 = load i32, i32* %len, align 4, !dbg !25
  %4 = zext i32 %3 to i64, !dbg !16
  %vla1 = alloca double, i64 %4, align 16, !dbg !16
  store i64 %4, i64* %__vla_expr1, align 8, !dbg !16
  call void @llvm.dbg.declare(metadata i64* %__vla_expr1, metadata !26, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata double* %vla1, metadata !27, metadata !DIExpression()), !dbg !31
  %5 = load i32, i32* %len, align 4, !dbg !32
  %6 = zext i32 %5 to i64, !dbg !16
  %vla2 = alloca double, i64 %6, align 16, !dbg !16
  store i64 %6, i64* %__vla_expr2, align 8, !dbg !16
  call void @llvm.dbg.declare(metadata i64* %__vla_expr2, metadata !33, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata double* %vla2, metadata !34, metadata !DIExpression()), !dbg !38
  call void @llvm.dbg.declare(metadata i32* %i, metadata !39, metadata !DIExpression()), !dbg !40
  call void @llvm.dbg.declare(metadata i32* %j, metadata !41, metadata !DIExpression()), !dbg !42
  store i32 0, i32* %j, align 4, !dbg !42
  store i32 0, i32* %i, align 4, !dbg !43
  br label %for.cond, !dbg !45

for.cond:                                         ; preds = %for.inc, %entry
  %7 = load i32, i32* %i, align 4, !dbg !46
  %8 = load i32, i32* %len, align 4, !dbg !48
  %cmp = icmp slt i32 %7, %8, !dbg !49
  br i1 %cmp, label %for.body, label %for.end, !dbg !50

for.body:                                         ; preds = %for.cond
  %9 = load i32, i32* %i, align 4, !dbg !51
  %conv = sitofp i32 %9 to double, !dbg !53
  %div = fdiv double %conv, 2.000000e+00, !dbg !54
  %10 = load i32, i32* %i, align 4, !dbg !55
  %idxprom = sext i32 %10 to i64, !dbg !56
  %arrayidx = getelementptr inbounds double, double* %vla, i64 %idxprom, !dbg !56
  store double %div, double* %arrayidx, align 8, !dbg !57
  %11 = load i32, i32* %i, align 4, !dbg !58
  %conv3 = sitofp i32 %11 to double, !dbg !59
  %div4 = fdiv double %conv3, 3.000000e+00, !dbg !60
  %12 = load i32, i32* %i, align 4, !dbg !61
  %idxprom5 = sext i32 %12 to i64, !dbg !62
  %arrayidx6 = getelementptr inbounds double, double* %vla1, i64 %idxprom5, !dbg !62
  store double %div4, double* %arrayidx6, align 8, !dbg !63
  %13 = load i32, i32* %i, align 4, !dbg !64
  %conv7 = sitofp i32 %13 to double, !dbg !65
  %div8 = fdiv double %conv7, 7.000000e+00, !dbg !66
  %14 = load i32, i32* %i, align 4, !dbg !67
  %idxprom9 = sext i32 %14 to i64, !dbg !68
  %arrayidx10 = getelementptr inbounds double, double* %vla2, i64 %idxprom9, !dbg !68
  store double %div8, double* %arrayidx10, align 8, !dbg !69
  br label %for.inc, !dbg !70

for.inc:                                          ; preds = %for.body
  %15 = load i32, i32* %i, align 4, !dbg !71
  %inc = add nsw i32 %15, 1, !dbg !71
  store i32 %inc, i32* %i, align 4, !dbg !71
  br label %for.cond, !dbg !72, !llvm.loop !73

for.end:                                          ; preds = %for.cond
  store i32 0, i32* %i, align 4, !dbg !75
  br label %for.cond11, !dbg !77

for.cond11:                                       ; preds = %for.inc22, %for.end
  %16 = load i32, i32* %i, align 4, !dbg !78
  %17 = load i32, i32* %len, align 4, !dbg !80
  %cmp12 = icmp slt i32 %16, %17, !dbg !81
  br i1 %cmp12, label %for.body14, label %for.end24, !dbg !82

for.body14:                                       ; preds = %for.cond11
  %18 = load i32, i32* %i, align 4, !dbg !83
  %idxprom15 = sext i32 %18 to i64, !dbg !85
  %arrayidx16 = getelementptr inbounds double, double* %vla, i64 %idxprom15, !dbg !85
  %19 = load double, double* %arrayidx16, align 8, !dbg !85
  %20 = load i32, i32* %i, align 4, !dbg !86
  %idxprom17 = sext i32 %20 to i64, !dbg !87
  %arrayidx18 = getelementptr inbounds double, double* %vla1, i64 %idxprom17, !dbg !87
  %21 = load double, double* %arrayidx18, align 8, !dbg !87
  %mul = fmul double %19, %21, !dbg !88
  %22 = load i32, i32* %j, align 4, !dbg !89
  %idxprom19 = sext i32 %22 to i64, !dbg !90
  %arrayidx20 = getelementptr inbounds double, double* %vla2, i64 %idxprom19, !dbg !90
  %23 = load double, double* %arrayidx20, align 8, !dbg !91
  %add = fadd double %23, %mul, !dbg !91
  store double %add, double* %arrayidx20, align 8, !dbg !91
  %24 = load i32, i32* %j, align 4, !dbg !92
  %inc21 = add nsw i32 %24, 1, !dbg !92
  store i32 %inc21, i32* %j, align 4, !dbg !92
  br label %for.inc22, !dbg !93

for.inc22:                                        ; preds = %for.body14
  %25 = load i32, i32* %i, align 4, !dbg !94
  %inc23 = add nsw i32 %25, 1, !dbg !94
  store i32 %inc23, i32* %i, align 4, !dbg !94
  br label %for.cond11, !dbg !95, !llvm.loop !96

for.end24:                                        ; preds = %for.cond11
  %arrayidx25 = getelementptr inbounds double, double* %vla2, i64 50, !dbg !98
  %26 = load double, double* %arrayidx25, align 16, !dbg !98
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), double %26), !dbg !99
  store i32 0, i32* %retval, align 4, !dbg !100
  %27 = load i8*, i8** %saved_stack, align 8, !dbg !101
  call void @llvm.stackrestore(i8* %27), !dbg !101
  %28 = load i32, i32* %retval, align 4, !dbg !101
  ret i32 %28, !dbg !101
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare i8* @llvm.stacksave() #2

declare dso_local i32 @printf(i8*, ...) #3

; Function Attrs: nounwind
declare void @llvm.stackrestore(i8*) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!5, !6, !7}
!llvm.ident = !{!8}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/111")
!2 = !{}
!3 = !{!4}
!4 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!5 = !{i32 7, !"Dwarf Version", i32 4}
!6 = !{i32 2, !"Debug Info Version", i32 3}
!7 = !{i32 1, !"wchar_size", i32 4}
!8 = !{!"Ubuntu clang version 11.1.0-6"}
!9 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 54, type: !10, scopeLine: 55, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!10 = !DISubroutineType(types: !11)
!11 = !{!12}
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !DILocalVariable(name: "len", scope: !9, file: !1, line: 56, type: !12)
!14 = !DILocation(line: 56, column: 7, scope: !9)
!15 = !DILocation(line: 57, column: 12, scope: !9)
!16 = !DILocation(line: 57, column: 3, scope: !9)
!17 = !DILocalVariable(name: "__vla_expr0", scope: !9, type: !18, flags: DIFlagArtificial)
!18 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!19 = !DILocation(line: 0, scope: !9)
!20 = !DILocalVariable(name: "a", scope: !9, file: !1, line: 57, type: !21)
!21 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, elements: !22)
!22 = !{!23}
!23 = !DISubrange(count: !17)
!24 = !DILocation(line: 57, column: 10, scope: !9)
!25 = !DILocation(line: 57, column: 20, scope: !9)
!26 = !DILocalVariable(name: "__vla_expr1", scope: !9, type: !18, flags: DIFlagArtificial)
!27 = !DILocalVariable(name: "b", scope: !9, file: !1, line: 57, type: !28)
!28 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, elements: !29)
!29 = !{!30}
!30 = !DISubrange(count: !26)
!31 = !DILocation(line: 57, column: 18, scope: !9)
!32 = !DILocation(line: 57, column: 28, scope: !9)
!33 = !DILocalVariable(name: "__vla_expr2", scope: !9, type: !18, flags: DIFlagArtificial)
!34 = !DILocalVariable(name: "c", scope: !9, file: !1, line: 57, type: !35)
!35 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, elements: !36)
!36 = !{!37}
!37 = !DISubrange(count: !33)
!38 = !DILocation(line: 57, column: 26, scope: !9)
!39 = !DILocalVariable(name: "i", scope: !9, file: !1, line: 58, type: !12)
!40 = !DILocation(line: 58, column: 7, scope: !9)
!41 = !DILocalVariable(name: "j", scope: !9, file: !1, line: 58, type: !12)
!42 = !DILocation(line: 58, column: 9, scope: !9)
!43 = !DILocation(line: 60, column: 9, scope: !44)
!44 = distinct !DILexicalBlock(scope: !9, file: !1, line: 60, column: 3)
!45 = !DILocation(line: 60, column: 8, scope: !44)
!46 = !DILocation(line: 60, column: 12, scope: !47)
!47 = distinct !DILexicalBlock(scope: !44, file: !1, line: 60, column: 3)
!48 = !DILocation(line: 60, column: 14, scope: !47)
!49 = !DILocation(line: 60, column: 13, scope: !47)
!50 = !DILocation(line: 60, column: 3, scope: !44)
!51 = !DILocation(line: 62, column: 19, scope: !52)
!52 = distinct !DILexicalBlock(scope: !47, file: !1, line: 61, column: 3)
!53 = !DILocation(line: 62, column: 11, scope: !52)
!54 = !DILocation(line: 62, column: 21, scope: !52)
!55 = !DILocation(line: 62, column: 7, scope: !52)
!56 = !DILocation(line: 62, column: 5, scope: !52)
!57 = !DILocation(line: 62, column: 9, scope: !52)
!58 = !DILocation(line: 63, column: 19, scope: !52)
!59 = !DILocation(line: 63, column: 11, scope: !52)
!60 = !DILocation(line: 63, column: 21, scope: !52)
!61 = !DILocation(line: 63, column: 7, scope: !52)
!62 = !DILocation(line: 63, column: 5, scope: !52)
!63 = !DILocation(line: 63, column: 9, scope: !52)
!64 = !DILocation(line: 64, column: 19, scope: !52)
!65 = !DILocation(line: 64, column: 11, scope: !52)
!66 = !DILocation(line: 64, column: 21, scope: !52)
!67 = !DILocation(line: 64, column: 7, scope: !52)
!68 = !DILocation(line: 64, column: 5, scope: !52)
!69 = !DILocation(line: 64, column: 9, scope: !52)
!70 = !DILocation(line: 65, column: 3, scope: !52)
!71 = !DILocation(line: 60, column: 19, scope: !47)
!72 = !DILocation(line: 60, column: 3, scope: !47)
!73 = distinct !{!73, !50, !74}
!74 = !DILocation(line: 65, column: 3, scope: !44)
!75 = !DILocation(line: 68, column: 9, scope: !76)
!76 = distinct !DILexicalBlock(scope: !9, file: !1, line: 68, column: 3)
!77 = !DILocation(line: 68, column: 8, scope: !76)
!78 = !DILocation(line: 68, column: 12, scope: !79)
!79 = distinct !DILexicalBlock(scope: !76, file: !1, line: 68, column: 3)
!80 = !DILocation(line: 68, column: 14, scope: !79)
!81 = !DILocation(line: 68, column: 13, scope: !79)
!82 = !DILocation(line: 68, column: 3, scope: !76)
!83 = !DILocation(line: 70, column: 13, scope: !84)
!84 = distinct !DILexicalBlock(scope: !79, file: !1, line: 69, column: 3)
!85 = !DILocation(line: 70, column: 11, scope: !84)
!86 = !DILocation(line: 70, column: 18, scope: !84)
!87 = !DILocation(line: 70, column: 16, scope: !84)
!88 = !DILocation(line: 70, column: 15, scope: !84)
!89 = !DILocation(line: 70, column: 7, scope: !84)
!90 = !DILocation(line: 70, column: 5, scope: !84)
!91 = !DILocation(line: 70, column: 9, scope: !84)
!92 = !DILocation(line: 71, column: 6, scope: !84)
!93 = !DILocation(line: 72, column: 3, scope: !84)
!94 = !DILocation(line: 68, column: 19, scope: !79)
!95 = !DILocation(line: 68, column: 3, scope: !79)
!96 = distinct !{!96, !82, !97}
!97 = !DILocation(line: 72, column: 3, scope: !76)
!98 = !DILocation(line: 74, column: 24, scope: !9)
!99 = !DILocation(line: 74, column: 3, scope: !9)
!100 = !DILocation(line: 75, column: 3, scope: !9)
!101 = !DILocation(line: 76, column: 1, scope: !9)
