; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [14 x i8] c"c[50][50]=%f\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !9 {
entry:
  %retval = alloca i32, align 4
  %len = alloca i32, align 4
  %saved_stack = alloca i8*, align 8
  %__vla_expr0 = alloca i64, align 8
  %__vla_expr1 = alloca i64, align 8
  %__vla_expr2 = alloca i64, align 8
  %__vla_expr3 = alloca i64, align 8
  %__vla_expr4 = alloca i64, align 8
  %__vla_expr5 = alloca i64, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %len, metadata !13, metadata !DIExpression()), !dbg !14
  store i32 100, i32* %len, align 4, !dbg !14
  %0 = load i32, i32* %len, align 4, !dbg !15
  %1 = zext i32 %0 to i64, !dbg !16
  %2 = load i32, i32* %len, align 4, !dbg !17
  %3 = zext i32 %2 to i64, !dbg !16
  %4 = call i8* @llvm.stacksave(), !dbg !16
  store i8* %4, i8** %saved_stack, align 8, !dbg !16
  %5 = mul nuw i64 %1, %3, !dbg !16
  %vla = alloca double, i64 %5, align 16, !dbg !16
  store i64 %1, i64* %__vla_expr0, align 8, !dbg !16
  store i64 %3, i64* %__vla_expr1, align 8, !dbg !16
  call void @llvm.dbg.declare(metadata i64* %__vla_expr0, metadata !18, metadata !DIExpression()), !dbg !20
  call void @llvm.dbg.declare(metadata i64* %__vla_expr1, metadata !21, metadata !DIExpression()), !dbg !20
  call void @llvm.dbg.declare(metadata double* %vla, metadata !22, metadata !DIExpression()), !dbg !27
  %6 = load i32, i32* %len, align 4, !dbg !28
  %7 = zext i32 %6 to i64, !dbg !16
  %8 = load i32, i32* %len, align 4, !dbg !29
  %9 = zext i32 %8 to i64, !dbg !16
  %10 = mul nuw i64 %7, %9, !dbg !16
  %vla1 = alloca double, i64 %10, align 16, !dbg !16
  store i64 %7, i64* %__vla_expr2, align 8, !dbg !16
  store i64 %9, i64* %__vla_expr3, align 8, !dbg !16
  call void @llvm.dbg.declare(metadata i64* %__vla_expr2, metadata !30, metadata !DIExpression()), !dbg !20
  call void @llvm.dbg.declare(metadata i64* %__vla_expr3, metadata !31, metadata !DIExpression()), !dbg !20
  call void @llvm.dbg.declare(metadata double* %vla1, metadata !32, metadata !DIExpression()), !dbg !37
  %11 = load i32, i32* %len, align 4, !dbg !38
  %12 = zext i32 %11 to i64, !dbg !16
  %13 = load i32, i32* %len, align 4, !dbg !39
  %14 = zext i32 %13 to i64, !dbg !16
  %15 = mul nuw i64 %12, %14, !dbg !16
  %vla2 = alloca double, i64 %15, align 16, !dbg !16
  store i64 %12, i64* %__vla_expr4, align 8, !dbg !16
  store i64 %14, i64* %__vla_expr5, align 8, !dbg !16
  call void @llvm.dbg.declare(metadata i64* %__vla_expr4, metadata !40, metadata !DIExpression()), !dbg !20
  call void @llvm.dbg.declare(metadata i64* %__vla_expr5, metadata !41, metadata !DIExpression()), !dbg !20
  call void @llvm.dbg.declare(metadata double* %vla2, metadata !42, metadata !DIExpression()), !dbg !47
  call void @llvm.dbg.declare(metadata i32* %i, metadata !48, metadata !DIExpression()), !dbg !49
  call void @llvm.dbg.declare(metadata i32* %j, metadata !50, metadata !DIExpression()), !dbg !51
  store i32 0, i32* %i, align 4, !dbg !52
  br label %for.cond, !dbg !54

for.cond:                                         ; preds = %for.inc20, %entry
  %16 = load i32, i32* %i, align 4, !dbg !55
  %17 = load i32, i32* %len, align 4, !dbg !57
  %cmp = icmp slt i32 %16, %17, !dbg !58
  br i1 %cmp, label %for.body, label %for.end22, !dbg !59

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %j, align 4, !dbg !60
  br label %for.cond3, !dbg !62

for.cond3:                                        ; preds = %for.inc, %for.body
  %18 = load i32, i32* %j, align 4, !dbg !63
  %19 = load i32, i32* %len, align 4, !dbg !65
  %cmp4 = icmp slt i32 %18, %19, !dbg !66
  br i1 %cmp4, label %for.body5, label %for.end, !dbg !67

for.body5:                                        ; preds = %for.cond3
  %20 = load i32, i32* %i, align 4, !dbg !68
  %conv = sitofp i32 %20 to double, !dbg !70
  %div = fdiv double %conv, 2.000000e+00, !dbg !71
  %21 = load i32, i32* %i, align 4, !dbg !72
  %idxprom = sext i32 %21 to i64, !dbg !73
  %22 = mul nsw i64 %idxprom, %3, !dbg !73
  %arrayidx = getelementptr inbounds double, double* %vla, i64 %22, !dbg !73
  %23 = load i32, i32* %j, align 4, !dbg !74
  %idxprom6 = sext i32 %23 to i64, !dbg !73
  %arrayidx7 = getelementptr inbounds double, double* %arrayidx, i64 %idxprom6, !dbg !73
  store double %div, double* %arrayidx7, align 8, !dbg !75
  %24 = load i32, i32* %i, align 4, !dbg !76
  %conv8 = sitofp i32 %24 to double, !dbg !77
  %div9 = fdiv double %conv8, 3.000000e+00, !dbg !78
  %25 = load i32, i32* %i, align 4, !dbg !79
  %idxprom10 = sext i32 %25 to i64, !dbg !80
  %26 = mul nsw i64 %idxprom10, %9, !dbg !80
  %arrayidx11 = getelementptr inbounds double, double* %vla1, i64 %26, !dbg !80
  %27 = load i32, i32* %j, align 4, !dbg !81
  %idxprom12 = sext i32 %27 to i64, !dbg !80
  %arrayidx13 = getelementptr inbounds double, double* %arrayidx11, i64 %idxprom12, !dbg !80
  store double %div9, double* %arrayidx13, align 8, !dbg !82
  %28 = load i32, i32* %i, align 4, !dbg !83
  %conv14 = sitofp i32 %28 to double, !dbg !84
  %div15 = fdiv double %conv14, 7.000000e+00, !dbg !85
  %29 = load i32, i32* %i, align 4, !dbg !86
  %idxprom16 = sext i32 %29 to i64, !dbg !87
  %30 = mul nsw i64 %idxprom16, %14, !dbg !87
  %arrayidx17 = getelementptr inbounds double, double* %vla2, i64 %30, !dbg !87
  %31 = load i32, i32* %j, align 4, !dbg !88
  %idxprom18 = sext i32 %31 to i64, !dbg !87
  %arrayidx19 = getelementptr inbounds double, double* %arrayidx17, i64 %idxprom18, !dbg !87
  store double %div15, double* %arrayidx19, align 8, !dbg !89
  br label %for.inc, !dbg !90

for.inc:                                          ; preds = %for.body5
  %32 = load i32, i32* %j, align 4, !dbg !91
  %inc = add nsw i32 %32, 1, !dbg !91
  store i32 %inc, i32* %j, align 4, !dbg !91
  br label %for.cond3, !dbg !92, !llvm.loop !93

for.end:                                          ; preds = %for.cond3
  br label %for.inc20, !dbg !94

for.inc20:                                        ; preds = %for.end
  %33 = load i32, i32* %i, align 4, !dbg !95
  %inc21 = add nsw i32 %33, 1, !dbg !95
  store i32 %inc21, i32* %i, align 4, !dbg !95
  br label %for.cond, !dbg !96, !llvm.loop !97

for.end22:                                        ; preds = %for.cond
  store i32 0, i32* %i, align 4, !dbg !99
  br label %for.cond23, !dbg !101

for.cond23:                                       ; preds = %for.inc46, %for.end22
  %34 = load i32, i32* %i, align 4, !dbg !102
  %35 = load i32, i32* %len, align 4, !dbg !104
  %cmp24 = icmp slt i32 %34, %35, !dbg !105
  br i1 %cmp24, label %for.body26, label %for.end48, !dbg !106

for.body26:                                       ; preds = %for.cond23
  store i32 0, i32* %j, align 4, !dbg !107
  br label %for.cond27, !dbg !109

for.cond27:                                       ; preds = %for.inc43, %for.body26
  %36 = load i32, i32* %j, align 4, !dbg !110
  %37 = load i32, i32* %len, align 4, !dbg !112
  %cmp28 = icmp slt i32 %36, %37, !dbg !113
  br i1 %cmp28, label %for.body30, label %for.end45, !dbg !114

for.body30:                                       ; preds = %for.cond27
  %38 = load i32, i32* %i, align 4, !dbg !115
  %idxprom31 = sext i32 %38 to i64, !dbg !116
  %39 = mul nsw i64 %idxprom31, %3, !dbg !116
  %arrayidx32 = getelementptr inbounds double, double* %vla, i64 %39, !dbg !116
  %40 = load i32, i32* %j, align 4, !dbg !117
  %idxprom33 = sext i32 %40 to i64, !dbg !116
  %arrayidx34 = getelementptr inbounds double, double* %arrayidx32, i64 %idxprom33, !dbg !116
  %41 = load double, double* %arrayidx34, align 8, !dbg !116
  %42 = load i32, i32* %i, align 4, !dbg !118
  %idxprom35 = sext i32 %42 to i64, !dbg !119
  %43 = mul nsw i64 %idxprom35, %9, !dbg !119
  %arrayidx36 = getelementptr inbounds double, double* %vla1, i64 %43, !dbg !119
  %44 = load i32, i32* %j, align 4, !dbg !120
  %idxprom37 = sext i32 %44 to i64, !dbg !119
  %arrayidx38 = getelementptr inbounds double, double* %arrayidx36, i64 %idxprom37, !dbg !119
  %45 = load double, double* %arrayidx38, align 8, !dbg !119
  %mul = fmul double %41, %45, !dbg !121
  %46 = load i32, i32* %i, align 4, !dbg !122
  %idxprom39 = sext i32 %46 to i64, !dbg !123
  %47 = mul nsw i64 %idxprom39, %14, !dbg !123
  %arrayidx40 = getelementptr inbounds double, double* %vla2, i64 %47, !dbg !123
  %48 = load i32, i32* %j, align 4, !dbg !124
  %idxprom41 = sext i32 %48 to i64, !dbg !123
  %arrayidx42 = getelementptr inbounds double, double* %arrayidx40, i64 %idxprom41, !dbg !123
  store double %mul, double* %arrayidx42, align 8, !dbg !125
  br label %for.inc43, !dbg !123

for.inc43:                                        ; preds = %for.body30
  %49 = load i32, i32* %j, align 4, !dbg !126
  %inc44 = add nsw i32 %49, 1, !dbg !126
  store i32 %inc44, i32* %j, align 4, !dbg !126
  br label %for.cond27, !dbg !127, !llvm.loop !128

for.end45:                                        ; preds = %for.cond27
  br label %for.inc46, !dbg !129

for.inc46:                                        ; preds = %for.end45
  %50 = load i32, i32* %i, align 4, !dbg !130
  %inc47 = add nsw i32 %50, 1, !dbg !130
  store i32 %inc47, i32* %i, align 4, !dbg !130
  br label %for.cond23, !dbg !131, !llvm.loop !132

for.end48:                                        ; preds = %for.cond23
  %51 = mul nsw i64 50, %14, !dbg !134
  %arrayidx49 = getelementptr inbounds double, double* %vla2, i64 %51, !dbg !134
  %arrayidx50 = getelementptr inbounds double, double* %arrayidx49, i64 50, !dbg !134
  %52 = load double, double* %arrayidx50, align 8, !dbg !134
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str, i64 0, i64 0), double %52), !dbg !135
  store i32 0, i32* %retval, align 4, !dbg !136
  %53 = load i8*, i8** %saved_stack, align 8, !dbg !137
  call void @llvm.stackrestore(i8* %53), !dbg !137
  %54 = load i32, i32* %retval, align 4, !dbg !137
  ret i32 %54, !dbg !137
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
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/098")
!2 = !{}
!3 = !{!4}
!4 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!5 = !{i32 7, !"Dwarf Version", i32 4}
!6 = !{i32 2, !"Debug Info Version", i32 3}
!7 = !{i32 1, !"wchar_size", i32 4}
!8 = !{!"Ubuntu clang version 11.1.0-6"}
!9 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 52, type: !10, scopeLine: 53, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!10 = !DISubroutineType(types: !11)
!11 = !{!12}
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !DILocalVariable(name: "len", scope: !9, file: !1, line: 54, type: !12)
!14 = !DILocation(line: 54, column: 7, scope: !9)
!15 = !DILocation(line: 55, column: 12, scope: !9)
!16 = !DILocation(line: 55, column: 3, scope: !9)
!17 = !DILocation(line: 55, column: 17, scope: !9)
!18 = !DILocalVariable(name: "__vla_expr0", scope: !9, type: !19, flags: DIFlagArtificial)
!19 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!20 = !DILocation(line: 0, scope: !9)
!21 = !DILocalVariable(name: "__vla_expr1", scope: !9, type: !19, flags: DIFlagArtificial)
!22 = !DILocalVariable(name: "a", scope: !9, file: !1, line: 55, type: !23)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, elements: !24)
!24 = !{!25, !26}
!25 = !DISubrange(count: !18)
!26 = !DISubrange(count: !21)
!27 = !DILocation(line: 55, column: 10, scope: !9)
!28 = !DILocation(line: 55, column: 25, scope: !9)
!29 = !DILocation(line: 55, column: 30, scope: !9)
!30 = !DILocalVariable(name: "__vla_expr2", scope: !9, type: !19, flags: DIFlagArtificial)
!31 = !DILocalVariable(name: "__vla_expr3", scope: !9, type: !19, flags: DIFlagArtificial)
!32 = !DILocalVariable(name: "b", scope: !9, file: !1, line: 55, type: !33)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, elements: !34)
!34 = !{!35, !36}
!35 = !DISubrange(count: !30)
!36 = !DISubrange(count: !31)
!37 = !DILocation(line: 55, column: 23, scope: !9)
!38 = !DILocation(line: 55, column: 38, scope: !9)
!39 = !DILocation(line: 55, column: 43, scope: !9)
!40 = !DILocalVariable(name: "__vla_expr4", scope: !9, type: !19, flags: DIFlagArtificial)
!41 = !DILocalVariable(name: "__vla_expr5", scope: !9, type: !19, flags: DIFlagArtificial)
!42 = !DILocalVariable(name: "c", scope: !9, file: !1, line: 55, type: !43)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, elements: !44)
!44 = !{!45, !46}
!45 = !DISubrange(count: !40)
!46 = !DISubrange(count: !41)
!47 = !DILocation(line: 55, column: 36, scope: !9)
!48 = !DILocalVariable(name: "i", scope: !9, file: !1, line: 56, type: !12)
!49 = !DILocation(line: 56, column: 7, scope: !9)
!50 = !DILocalVariable(name: "j", scope: !9, file: !1, line: 56, type: !12)
!51 = !DILocation(line: 56, column: 9, scope: !9)
!52 = !DILocation(line: 58, column: 9, scope: !53)
!53 = distinct !DILexicalBlock(scope: !9, file: !1, line: 58, column: 3)
!54 = !DILocation(line: 58, column: 8, scope: !53)
!55 = !DILocation(line: 58, column: 12, scope: !56)
!56 = distinct !DILexicalBlock(scope: !53, file: !1, line: 58, column: 3)
!57 = !DILocation(line: 58, column: 14, scope: !56)
!58 = !DILocation(line: 58, column: 13, scope: !56)
!59 = !DILocation(line: 58, column: 3, scope: !53)
!60 = !DILocation(line: 59, column: 11, scope: !61)
!61 = distinct !DILexicalBlock(scope: !56, file: !1, line: 59, column: 5)
!62 = !DILocation(line: 59, column: 10, scope: !61)
!63 = !DILocation(line: 59, column: 14, scope: !64)
!64 = distinct !DILexicalBlock(scope: !61, file: !1, line: 59, column: 5)
!65 = !DILocation(line: 59, column: 16, scope: !64)
!66 = !DILocation(line: 59, column: 15, scope: !64)
!67 = !DILocation(line: 59, column: 5, scope: !61)
!68 = !DILocation(line: 61, column: 24, scope: !69)
!69 = distinct !DILexicalBlock(scope: !64, file: !1, line: 60, column: 5)
!70 = !DILocation(line: 61, column: 16, scope: !69)
!71 = !DILocation(line: 61, column: 26, scope: !69)
!72 = !DILocation(line: 61, column: 9, scope: !69)
!73 = !DILocation(line: 61, column: 7, scope: !69)
!74 = !DILocation(line: 61, column: 12, scope: !69)
!75 = !DILocation(line: 61, column: 14, scope: !69)
!76 = !DILocation(line: 62, column: 24, scope: !69)
!77 = !DILocation(line: 62, column: 16, scope: !69)
!78 = !DILocation(line: 62, column: 26, scope: !69)
!79 = !DILocation(line: 62, column: 9, scope: !69)
!80 = !DILocation(line: 62, column: 7, scope: !69)
!81 = !DILocation(line: 62, column: 12, scope: !69)
!82 = !DILocation(line: 62, column: 14, scope: !69)
!83 = !DILocation(line: 63, column: 24, scope: !69)
!84 = !DILocation(line: 63, column: 16, scope: !69)
!85 = !DILocation(line: 63, column: 26, scope: !69)
!86 = !DILocation(line: 63, column: 9, scope: !69)
!87 = !DILocation(line: 63, column: 7, scope: !69)
!88 = !DILocation(line: 63, column: 12, scope: !69)
!89 = !DILocation(line: 63, column: 14, scope: !69)
!90 = !DILocation(line: 64, column: 5, scope: !69)
!91 = !DILocation(line: 59, column: 21, scope: !64)
!92 = !DILocation(line: 59, column: 5, scope: !64)
!93 = distinct !{!93, !67, !94}
!94 = !DILocation(line: 64, column: 5, scope: !61)
!95 = !DILocation(line: 58, column: 19, scope: !56)
!96 = !DILocation(line: 58, column: 3, scope: !56)
!97 = distinct !{!97, !59, !98}
!98 = !DILocation(line: 64, column: 5, scope: !53)
!99 = !DILocation(line: 67, column: 9, scope: !100)
!100 = distinct !DILexicalBlock(scope: !9, file: !1, line: 67, column: 3)
!101 = !DILocation(line: 67, column: 8, scope: !100)
!102 = !DILocation(line: 67, column: 12, scope: !103)
!103 = distinct !DILexicalBlock(scope: !100, file: !1, line: 67, column: 3)
!104 = !DILocation(line: 67, column: 14, scope: !103)
!105 = !DILocation(line: 67, column: 13, scope: !103)
!106 = !DILocation(line: 67, column: 3, scope: !100)
!107 = !DILocation(line: 68, column: 11, scope: !108)
!108 = distinct !DILexicalBlock(scope: !103, file: !1, line: 68, column: 5)
!109 = !DILocation(line: 68, column: 10, scope: !108)
!110 = !DILocation(line: 68, column: 14, scope: !111)
!111 = distinct !DILexicalBlock(scope: !108, file: !1, line: 68, column: 5)
!112 = !DILocation(line: 68, column: 16, scope: !111)
!113 = !DILocation(line: 68, column: 15, scope: !111)
!114 = !DILocation(line: 68, column: 5, scope: !108)
!115 = !DILocation(line: 69, column: 17, scope: !111)
!116 = !DILocation(line: 69, column: 15, scope: !111)
!117 = !DILocation(line: 69, column: 20, scope: !111)
!118 = !DILocation(line: 69, column: 25, scope: !111)
!119 = !DILocation(line: 69, column: 23, scope: !111)
!120 = !DILocation(line: 69, column: 28, scope: !111)
!121 = !DILocation(line: 69, column: 22, scope: !111)
!122 = !DILocation(line: 69, column: 9, scope: !111)
!123 = !DILocation(line: 69, column: 7, scope: !111)
!124 = !DILocation(line: 69, column: 12, scope: !111)
!125 = !DILocation(line: 69, column: 14, scope: !111)
!126 = !DILocation(line: 68, column: 21, scope: !111)
!127 = !DILocation(line: 68, column: 5, scope: !111)
!128 = distinct !{!128, !114, !129}
!129 = !DILocation(line: 69, column: 29, scope: !108)
!130 = !DILocation(line: 67, column: 19, scope: !103)
!131 = !DILocation(line: 67, column: 3, scope: !103)
!132 = distinct !{!132, !106, !133}
!133 = !DILocation(line: 69, column: 29, scope: !100)
!134 = !DILocation(line: 71, column: 28, scope: !9)
!135 = !DILocation(line: 71, column: 3, scope: !9)
!136 = !DILocation(line: 72, column: 3, scope: !9)
!137 = !DILocation(line: 73, column: 1, scope: !9)
