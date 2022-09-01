; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [16 x i8] c"sum=%f sum2=%f\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !9 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %i2 = alloca i32, align 4
  %len = alloca i32, align 4
  %sum = alloca double, align 8
  %sum2 = alloca double, align 8
  %saved_stack = alloca i8*, align 8
  %__vla_expr0 = alloca i64, align 8
  %__vla_expr1 = alloca i64, align 8
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !16, metadata !DIExpression()), !dbg !17
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32* %i, metadata !20, metadata !DIExpression()), !dbg !21
  call void @llvm.dbg.declare(metadata i32* %i2, metadata !22, metadata !DIExpression()), !dbg !23
  call void @llvm.dbg.declare(metadata i32* %len, metadata !24, metadata !DIExpression()), !dbg !25
  store i32 2560, i32* %len, align 4, !dbg !25
  call void @llvm.dbg.declare(metadata double* %sum, metadata !26, metadata !DIExpression()), !dbg !27
  store double 0.000000e+00, double* %sum, align 8, !dbg !27
  call void @llvm.dbg.declare(metadata double* %sum2, metadata !28, metadata !DIExpression()), !dbg !29
  store double 0.000000e+00, double* %sum2, align 8, !dbg !29
  %0 = load i32, i32* %len, align 4, !dbg !30
  %1 = zext i32 %0 to i64, !dbg !31
  %2 = call i8* @llvm.stacksave(), !dbg !31
  store i8* %2, i8** %saved_stack, align 8, !dbg !31
  %vla = alloca double, i64 %1, align 16, !dbg !31
  store i64 %1, i64* %__vla_expr0, align 8, !dbg !31
  call void @llvm.dbg.declare(metadata i64* %__vla_expr0, metadata !32, metadata !DIExpression()), !dbg !34
  call void @llvm.dbg.declare(metadata double* %vla, metadata !35, metadata !DIExpression()), !dbg !39
  %3 = load i32, i32* %len, align 4, !dbg !40
  %4 = zext i32 %3 to i64, !dbg !31
  %vla1 = alloca double, i64 %4, align 16, !dbg !31
  store i64 %4, i64* %__vla_expr1, align 8, !dbg !31
  call void @llvm.dbg.declare(metadata i64* %__vla_expr1, metadata !41, metadata !DIExpression()), !dbg !34
  call void @llvm.dbg.declare(metadata double* %vla1, metadata !42, metadata !DIExpression()), !dbg !46
  store i32 0, i32* %i, align 4, !dbg !47
  br label %for.cond, !dbg !49

for.cond:                                         ; preds = %for.inc, %entry
  %5 = load i32, i32* %i, align 4, !dbg !50
  %6 = load i32, i32* %len, align 4, !dbg !52
  %cmp = icmp slt i32 %5, %6, !dbg !53
  br i1 %cmp, label %for.body, label %for.end, !dbg !54

for.body:                                         ; preds = %for.cond
  %7 = load i32, i32* %i, align 4, !dbg !55
  %conv = sitofp i32 %7 to double, !dbg !57
  %div = fdiv double %conv, 2.000000e+00, !dbg !58
  %8 = load i32, i32* %i, align 4, !dbg !59
  %idxprom = sext i32 %8 to i64, !dbg !60
  %arrayidx = getelementptr inbounds double, double* %vla, i64 %idxprom, !dbg !60
  store double %div, double* %arrayidx, align 8, !dbg !61
  %9 = load i32, i32* %i, align 4, !dbg !62
  %conv2 = sitofp i32 %9 to double, !dbg !63
  %div3 = fdiv double %conv2, 3.000000e+00, !dbg !64
  %10 = load i32, i32* %i, align 4, !dbg !65
  %idxprom4 = sext i32 %10 to i64, !dbg !66
  %arrayidx5 = getelementptr inbounds double, double* %vla1, i64 %idxprom4, !dbg !66
  store double %div3, double* %arrayidx5, align 8, !dbg !67
  br label %for.inc, !dbg !68

for.inc:                                          ; preds = %for.body
  %11 = load i32, i32* %i, align 4, !dbg !69
  %inc = add nsw i32 %11, 1, !dbg !69
  store i32 %inc, i32* %i, align 4, !dbg !69
  br label %for.cond, !dbg !70, !llvm.loop !71

for.end:                                          ; preds = %for.cond
  store i32 0, i32* %i2, align 4, !dbg !73
  br label %for.cond6, !dbg !75

for.cond6:                                        ; preds = %for.inc25, %for.end
  %12 = load i32, i32* %i2, align 4, !dbg !76
  %13 = load i32, i32* %len, align 4, !dbg !78
  %cmp7 = icmp slt i32 %12, %13, !dbg !79
  br i1 %cmp7, label %for.body9, label %for.end27, !dbg !80

for.body9:                                        ; preds = %for.cond6
  %14 = load i32, i32* %i2, align 4, !dbg !81
  store i32 %14, i32* %i, align 4, !dbg !83
  br label %for.cond10, !dbg !84

for.cond10:                                       ; preds = %for.inc22, %for.body9
  %15 = load i32, i32* %i, align 4, !dbg !85
  %16 = load i32, i32* %i2, align 4, !dbg !87
  %add = add nsw i32 %16, 256, !dbg !87
  %17 = load i32, i32* %len, align 4, !dbg !87
  %cmp11 = icmp slt i32 %add, %17, !dbg !87
  br i1 %cmp11, label %cond.true, label %cond.false, !dbg !87

cond.true:                                        ; preds = %for.cond10
  %18 = load i32, i32* %i2, align 4, !dbg !87
  %add13 = add nsw i32 %18, 256, !dbg !87
  br label %cond.end, !dbg !87

cond.false:                                       ; preds = %for.cond10
  %19 = load i32, i32* %len, align 4, !dbg !87
  br label %cond.end, !dbg !87

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i32 [ %add13, %cond.true ], [ %19, %cond.false ], !dbg !87
  %cmp14 = icmp slt i32 %15, %cond, !dbg !88
  br i1 %cmp14, label %for.body16, label %for.end24, !dbg !89

for.body16:                                       ; preds = %cond.end
  %20 = load i32, i32* %i, align 4, !dbg !90
  %idxprom17 = sext i32 %20 to i64, !dbg !91
  %arrayidx18 = getelementptr inbounds double, double* %vla, i64 %idxprom17, !dbg !91
  %21 = load double, double* %arrayidx18, align 8, !dbg !91
  %22 = load i32, i32* %i, align 4, !dbg !92
  %idxprom19 = sext i32 %22 to i64, !dbg !93
  %arrayidx20 = getelementptr inbounds double, double* %vla1, i64 %idxprom19, !dbg !93
  %23 = load double, double* %arrayidx20, align 8, !dbg !93
  %mul = fmul double %21, %23, !dbg !94
  %24 = load double, double* %sum, align 8, !dbg !95
  %add21 = fadd double %24, %mul, !dbg !95
  store double %add21, double* %sum, align 8, !dbg !95
  br label %for.inc22, !dbg !96

for.inc22:                                        ; preds = %for.body16
  %25 = load i32, i32* %i, align 4, !dbg !97
  %inc23 = add nsw i32 %25, 1, !dbg !97
  store i32 %inc23, i32* %i, align 4, !dbg !97
  br label %for.cond10, !dbg !98, !llvm.loop !99

for.end24:                                        ; preds = %cond.end
  br label %for.inc25, !dbg !100

for.inc25:                                        ; preds = %for.end24
  %26 = load i32, i32* %i2, align 4, !dbg !101
  %add26 = add nsw i32 %26, 256, !dbg !101
  store i32 %add26, i32* %i2, align 4, !dbg !101
  br label %for.cond6, !dbg !102, !llvm.loop !103

for.end27:                                        ; preds = %for.cond6
  store i32 0, i32* %i, align 4, !dbg !105
  br label %for.cond28, !dbg !107

for.cond28:                                       ; preds = %for.inc38, %for.end27
  %27 = load i32, i32* %i, align 4, !dbg !108
  %28 = load i32, i32* %len, align 4, !dbg !110
  %cmp29 = icmp slt i32 %27, %28, !dbg !111
  br i1 %cmp29, label %for.body31, label %for.end40, !dbg !112

for.body31:                                       ; preds = %for.cond28
  %29 = load i32, i32* %i, align 4, !dbg !113
  %idxprom32 = sext i32 %29 to i64, !dbg !114
  %arrayidx33 = getelementptr inbounds double, double* %vla, i64 %idxprom32, !dbg !114
  %30 = load double, double* %arrayidx33, align 8, !dbg !114
  %31 = load i32, i32* %i, align 4, !dbg !115
  %idxprom34 = sext i32 %31 to i64, !dbg !116
  %arrayidx35 = getelementptr inbounds double, double* %vla1, i64 %idxprom34, !dbg !116
  %32 = load double, double* %arrayidx35, align 8, !dbg !116
  %mul36 = fmul double %30, %32, !dbg !117
  %33 = load double, double* %sum2, align 8, !dbg !118
  %add37 = fadd double %33, %mul36, !dbg !118
  store double %add37, double* %sum2, align 8, !dbg !118
  br label %for.inc38, !dbg !119

for.inc38:                                        ; preds = %for.body31
  %34 = load i32, i32* %i, align 4, !dbg !120
  %inc39 = add nsw i32 %34, 1, !dbg !120
  store i32 %inc39, i32* %i, align 4, !dbg !120
  br label %for.cond28, !dbg !121, !llvm.loop !122

for.end40:                                        ; preds = %for.cond28
  %35 = load double, double* %sum, align 8, !dbg !124
  %36 = load double, double* %sum2, align 8, !dbg !125
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i64 0, i64 0), double %35, double %36), !dbg !126
  store i32 0, i32* %retval, align 4, !dbg !127
  %37 = load i8*, i8** %saved_stack, align 8, !dbg !128
  call void @llvm.stackrestore(i8* %37), !dbg !128
  %38 = load i32, i32* %retval, align 4, !dbg !128
  ret i32 %38, !dbg !128
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
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/097")
!2 = !{}
!3 = !{!4}
!4 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!5 = !{i32 7, !"Dwarf Version", i32 4}
!6 = !{i32 2, !"Debug Info Version", i32 3}
!7 = !{i32 1, !"wchar_size", i32 4}
!8 = !{!"Ubuntu clang version 11.1.0-6"}
!9 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 52, type: !10, scopeLine: 53, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!10 = !DISubroutineType(types: !11)
!11 = !{!12, !12, !13}
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!15 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!16 = !DILocalVariable(name: "argc", arg: 1, scope: !9, file: !1, line: 52, type: !12)
!17 = !DILocation(line: 52, column: 14, scope: !9)
!18 = !DILocalVariable(name: "argv", arg: 2, scope: !9, file: !1, line: 52, type: !13)
!19 = !DILocation(line: 52, column: 26, scope: !9)
!20 = !DILocalVariable(name: "i", scope: !9, file: !1, line: 54, type: !12)
!21 = !DILocation(line: 54, column: 7, scope: !9)
!22 = !DILocalVariable(name: "i2", scope: !9, file: !1, line: 54, type: !12)
!23 = !DILocation(line: 54, column: 10, scope: !9)
!24 = !DILocalVariable(name: "len", scope: !9, file: !1, line: 55, type: !12)
!25 = !DILocation(line: 55, column: 7, scope: !9)
!26 = !DILocalVariable(name: "sum", scope: !9, file: !1, line: 56, type: !4)
!27 = !DILocation(line: 56, column: 10, scope: !9)
!28 = !DILocalVariable(name: "sum2", scope: !9, file: !1, line: 56, type: !4)
!29 = !DILocation(line: 56, column: 20, scope: !9)
!30 = !DILocation(line: 57, column: 12, scope: !9)
!31 = !DILocation(line: 57, column: 3, scope: !9)
!32 = !DILocalVariable(name: "__vla_expr0", scope: !9, type: !33, flags: DIFlagArtificial)
!33 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!34 = !DILocation(line: 0, scope: !9)
!35 = !DILocalVariable(name: "a", scope: !9, file: !1, line: 57, type: !36)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, elements: !37)
!37 = !{!38}
!38 = !DISubrange(count: !32)
!39 = !DILocation(line: 57, column: 10, scope: !9)
!40 = !DILocation(line: 57, column: 20, scope: !9)
!41 = !DILocalVariable(name: "__vla_expr1", scope: !9, type: !33, flags: DIFlagArtificial)
!42 = !DILocalVariable(name: "b", scope: !9, file: !1, line: 57, type: !43)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, elements: !44)
!44 = !{!45}
!45 = !DISubrange(count: !41)
!46 = !DILocation(line: 57, column: 18, scope: !9)
!47 = !DILocation(line: 59, column: 9, scope: !48)
!48 = distinct !DILexicalBlock(scope: !9, file: !1, line: 59, column: 3)
!49 = !DILocation(line: 59, column: 8, scope: !48)
!50 = !DILocation(line: 59, column: 13, scope: !51)
!51 = distinct !DILexicalBlock(scope: !48, file: !1, line: 59, column: 3)
!52 = !DILocation(line: 59, column: 15, scope: !51)
!53 = !DILocation(line: 59, column: 14, scope: !51)
!54 = !DILocation(line: 59, column: 3, scope: !48)
!55 = !DILocation(line: 61, column: 20, scope: !56)
!56 = distinct !DILexicalBlock(scope: !51, file: !1, line: 60, column: 3)
!57 = !DILocation(line: 61, column: 12, scope: !56)
!58 = !DILocation(line: 61, column: 22, scope: !56)
!59 = !DILocation(line: 61, column: 7, scope: !56)
!60 = !DILocation(line: 61, column: 5, scope: !56)
!61 = !DILocation(line: 61, column: 9, scope: !56)
!62 = !DILocation(line: 62, column: 20, scope: !56)
!63 = !DILocation(line: 62, column: 12, scope: !56)
!64 = !DILocation(line: 62, column: 22, scope: !56)
!65 = !DILocation(line: 62, column: 7, scope: !56)
!66 = !DILocation(line: 62, column: 5, scope: !56)
!67 = !DILocation(line: 62, column: 9, scope: !56)
!68 = !DILocation(line: 63, column: 3, scope: !56)
!69 = !DILocation(line: 59, column: 21, scope: !51)
!70 = !DILocation(line: 59, column: 3, scope: !51)
!71 = distinct !{!71, !54, !72}
!72 = !DILocation(line: 63, column: 3, scope: !48)
!73 = !DILocation(line: 68, column: 10, scope: !74)
!74 = distinct !DILexicalBlock(scope: !9, file: !1, line: 68, column: 3)
!75 = !DILocation(line: 68, column: 8, scope: !74)
!76 = !DILocation(line: 68, column: 14, scope: !77)
!77 = distinct !DILexicalBlock(scope: !74, file: !1, line: 68, column: 3)
!78 = !DILocation(line: 68, column: 18, scope: !77)
!79 = !DILocation(line: 68, column: 16, scope: !77)
!80 = !DILocation(line: 68, column: 3, scope: !74)
!81 = !DILocation(line: 70, column: 12, scope: !82)
!82 = distinct !DILexicalBlock(scope: !77, file: !1, line: 70, column: 5)
!83 = !DILocation(line: 70, column: 11, scope: !82)
!84 = !DILocation(line: 70, column: 10, scope: !82)
!85 = !DILocation(line: 70, column: 15, scope: !86)
!86 = distinct !DILexicalBlock(scope: !82, file: !1, line: 70, column: 5)
!87 = !DILocation(line: 70, column: 18, scope: !86)
!88 = !DILocation(line: 70, column: 16, scope: !86)
!89 = !DILocation(line: 70, column: 5, scope: !82)
!90 = !DILocation(line: 71, column: 16, scope: !86)
!91 = !DILocation(line: 71, column: 14, scope: !86)
!92 = !DILocation(line: 71, column: 21, scope: !86)
!93 = !DILocation(line: 71, column: 19, scope: !86)
!94 = !DILocation(line: 71, column: 18, scope: !86)
!95 = !DILocation(line: 71, column: 11, scope: !86)
!96 = !DILocation(line: 71, column: 7, scope: !86)
!97 = !DILocation(line: 70, column: 37, scope: !86)
!98 = !DILocation(line: 70, column: 5, scope: !86)
!99 = distinct !{!99, !89, !100}
!100 = !DILocation(line: 71, column: 22, scope: !82)
!101 = !DILocation(line: 68, column: 25, scope: !77)
!102 = !DILocation(line: 68, column: 3, scope: !77)
!103 = distinct !{!103, !80, !104}
!104 = !DILocation(line: 71, column: 22, scope: !74)
!105 = !DILocation(line: 75, column: 11, scope: !106)
!106 = distinct !DILexicalBlock(scope: !9, file: !1, line: 75, column: 5)
!107 = !DILocation(line: 75, column: 10, scope: !106)
!108 = !DILocation(line: 75, column: 14, scope: !109)
!109 = distinct !DILexicalBlock(scope: !106, file: !1, line: 75, column: 5)
!110 = !DILocation(line: 75, column: 17, scope: !109)
!111 = !DILocation(line: 75, column: 15, scope: !109)
!112 = !DILocation(line: 75, column: 5, scope: !106)
!113 = !DILocation(line: 76, column: 17, scope: !109)
!114 = !DILocation(line: 76, column: 15, scope: !109)
!115 = !DILocation(line: 76, column: 22, scope: !109)
!116 = !DILocation(line: 76, column: 20, scope: !109)
!117 = !DILocation(line: 76, column: 19, scope: !109)
!118 = !DILocation(line: 76, column: 12, scope: !109)
!119 = !DILocation(line: 76, column: 7, scope: !109)
!120 = !DILocation(line: 75, column: 23, scope: !109)
!121 = !DILocation(line: 75, column: 5, scope: !109)
!122 = distinct !{!122, !112, !123}
!123 = !DILocation(line: 76, column: 23, scope: !106)
!124 = !DILocation(line: 77, column: 31, scope: !9)
!125 = !DILocation(line: 77, column: 36, scope: !9)
!126 = !DILocation(line: 77, column: 3, scope: !9)
!127 = !DILocation(line: 78, column: 3, scope: !9)
!128 = !DILocation(line: 79, column: 1, scope: !9)
