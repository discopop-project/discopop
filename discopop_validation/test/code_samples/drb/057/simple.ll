; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@n = dso_local global i32 200, align 4, !dbg !0
@m = dso_local global i32 200, align 4, !dbg !8
@alpha = dso_local global double 5.430000e-02, align 8, !dbg !10
@dx = dso_local global double 0.000000e+00, align 8, !dbg !22
@dy = dso_local global double 0.000000e+00, align 8, !dbg !24
@u = dso_local global [200 x [200 x double]] zeroinitializer, align 16, !dbg !13
@f = dso_local global [200 x [200 x double]] zeroinitializer, align 16, !dbg !18
@uold = dso_local global [200 x [200 x double]] zeroinitializer, align 16, !dbg !20

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @initialize() #0 !dbg !30 {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %xx = alloca i32, align 4
  %yy = alloca i32, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !33, metadata !DIExpression()), !dbg !34
  call void @llvm.dbg.declare(metadata i32* %j, metadata !35, metadata !DIExpression()), !dbg !36
  call void @llvm.dbg.declare(metadata i32* %xx, metadata !37, metadata !DIExpression()), !dbg !38
  call void @llvm.dbg.declare(metadata i32* %yy, metadata !39, metadata !DIExpression()), !dbg !40
  %0 = load i32, i32* @n, align 4, !dbg !41
  %sub = sub nsw i32 %0, 1, !dbg !42
  %conv = sitofp i32 %sub to double, !dbg !43
  %div = fdiv double 2.000000e+00, %conv, !dbg !44
  store double %div, double* @dx, align 8, !dbg !45
  %1 = load i32, i32* @m, align 4, !dbg !46
  %sub1 = sub nsw i32 %1, 1, !dbg !47
  %conv2 = sitofp i32 %sub1 to double, !dbg !48
  %div3 = fdiv double 2.000000e+00, %conv2, !dbg !49
  store double %div3, double* @dy, align 8, !dbg !50
  store i32 0, i32* %i, align 4, !dbg !51
  br label %for.cond, !dbg !53

for.cond:                                         ; preds = %for.inc42, %entry
  %2 = load i32, i32* %i, align 4, !dbg !54
  %3 = load i32, i32* @n, align 4, !dbg !56
  %cmp = icmp slt i32 %2, %3, !dbg !57
  br i1 %cmp, label %for.body, label %for.end44, !dbg !58

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %j, align 4, !dbg !59
  br label %for.cond5, !dbg !61

for.cond5:                                        ; preds = %for.inc, %for.body
  %4 = load i32, i32* %j, align 4, !dbg !62
  %5 = load i32, i32* @m, align 4, !dbg !64
  %cmp6 = icmp slt i32 %4, %5, !dbg !65
  br i1 %cmp6, label %for.body8, label %for.end, !dbg !66

for.body8:                                        ; preds = %for.cond5
  %6 = load double, double* @dx, align 8, !dbg !67
  %7 = load i32, i32* %i, align 4, !dbg !69
  %sub9 = sub nsw i32 %7, 1, !dbg !70
  %conv10 = sitofp i32 %sub9 to double, !dbg !71
  %mul = fmul double %6, %conv10, !dbg !72
  %add = fadd double -1.000000e+00, %mul, !dbg !73
  %conv11 = fptosi double %add to i32, !dbg !74
  store i32 %conv11, i32* %xx, align 4, !dbg !75
  %8 = load double, double* @dy, align 8, !dbg !76
  %9 = load i32, i32* %j, align 4, !dbg !77
  %sub12 = sub nsw i32 %9, 1, !dbg !78
  %conv13 = sitofp i32 %sub12 to double, !dbg !79
  %mul14 = fmul double %8, %conv13, !dbg !80
  %add15 = fadd double -1.000000e+00, %mul14, !dbg !81
  %conv16 = fptosi double %add15 to i32, !dbg !82
  store i32 %conv16, i32* %yy, align 4, !dbg !83
  %10 = load i32, i32* %i, align 4, !dbg !84
  %idxprom = sext i32 %10 to i64, !dbg !85
  %arrayidx = getelementptr inbounds [200 x [200 x double]], [200 x [200 x double]]* @u, i64 0, i64 %idxprom, !dbg !85
  %11 = load i32, i32* %j, align 4, !dbg !86
  %idxprom17 = sext i32 %11 to i64, !dbg !85
  %arrayidx18 = getelementptr inbounds [200 x double], [200 x double]* %arrayidx, i64 0, i64 %idxprom17, !dbg !85
  store double 0.000000e+00, double* %arrayidx18, align 8, !dbg !87
  %12 = load double, double* @alpha, align 8, !dbg !88
  %mul19 = fmul double -1.000000e+00, %12, !dbg !89
  %13 = load i32, i32* %xx, align 4, !dbg !90
  %14 = load i32, i32* %xx, align 4, !dbg !91
  %mul20 = mul nsw i32 %13, %14, !dbg !92
  %conv21 = sitofp i32 %mul20 to double, !dbg !90
  %sub22 = fsub double 1.000000e+00, %conv21, !dbg !93
  %mul23 = fmul double %mul19, %sub22, !dbg !94
  %15 = load i32, i32* %yy, align 4, !dbg !95
  %16 = load i32, i32* %yy, align 4, !dbg !96
  %mul24 = mul nsw i32 %15, %16, !dbg !97
  %conv25 = sitofp i32 %mul24 to double, !dbg !95
  %sub26 = fsub double 1.000000e+00, %conv25, !dbg !98
  %mul27 = fmul double %mul23, %sub26, !dbg !99
  %17 = load i32, i32* %xx, align 4, !dbg !100
  %18 = load i32, i32* %xx, align 4, !dbg !101
  %mul28 = mul nsw i32 %17, %18, !dbg !102
  %conv29 = sitofp i32 %mul28 to double, !dbg !100
  %sub30 = fsub double 1.000000e+00, %conv29, !dbg !103
  %mul31 = fmul double 2.000000e+00, %sub30, !dbg !104
  %sub32 = fsub double %mul27, %mul31, !dbg !105
  %19 = load i32, i32* %yy, align 4, !dbg !106
  %20 = load i32, i32* %yy, align 4, !dbg !107
  %mul33 = mul nsw i32 %19, %20, !dbg !108
  %conv34 = sitofp i32 %mul33 to double, !dbg !106
  %sub35 = fsub double 1.000000e+00, %conv34, !dbg !109
  %mul36 = fmul double 2.000000e+00, %sub35, !dbg !110
  %sub37 = fsub double %sub32, %mul36, !dbg !111
  %21 = load i32, i32* %i, align 4, !dbg !112
  %idxprom38 = sext i32 %21 to i64, !dbg !113
  %arrayidx39 = getelementptr inbounds [200 x [200 x double]], [200 x [200 x double]]* @f, i64 0, i64 %idxprom38, !dbg !113
  %22 = load i32, i32* %j, align 4, !dbg !114
  %idxprom40 = sext i32 %22 to i64, !dbg !113
  %arrayidx41 = getelementptr inbounds [200 x double], [200 x double]* %arrayidx39, i64 0, i64 %idxprom40, !dbg !113
  store double %sub37, double* %arrayidx41, align 8, !dbg !115
  br label %for.inc, !dbg !116

for.inc:                                          ; preds = %for.body8
  %23 = load i32, i32* %j, align 4, !dbg !117
  %inc = add nsw i32 %23, 1, !dbg !117
  store i32 %inc, i32* %j, align 4, !dbg !117
  br label %for.cond5, !dbg !118, !llvm.loop !119

for.end:                                          ; preds = %for.cond5
  br label %for.inc42, !dbg !120

for.inc42:                                        ; preds = %for.end
  %24 = load i32, i32* %i, align 4, !dbg !121
  %inc43 = add nsw i32 %24, 1, !dbg !121
  store i32 %inc43, i32* %i, align 4, !dbg !121
  br label %for.cond, !dbg !122, !llvm.loop !123

for.end44:                                        ; preds = %for.cond
  ret void, !dbg !125
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !126 {
entry:
  %retval = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @initialize(), !dbg !128
  ret i32 0, !dbg !129
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!26, !27, !28}
!llvm.ident = !{!29}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "n", scope: !2, file: !3, line: 54, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !7, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/057")
!4 = !{}
!5 = !{!6}
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !{!0, !8, !10, !13, !18, !20, !22, !24}
!8 = !DIGlobalVariableExpression(var: !9, expr: !DIExpression())
!9 = distinct !DIGlobalVariable(name: "m", scope: !2, file: !3, line: 54, type: !6, isLocal: false, isDefinition: true)
!10 = !DIGlobalVariableExpression(var: !11, expr: !DIExpression())
!11 = distinct !DIGlobalVariable(name: "alpha", scope: !2, file: !3, line: 55, type: !12, isLocal: false, isDefinition: true)
!12 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(name: "u", scope: !2, file: !3, line: 56, type: !15, isLocal: false, isDefinition: true)
!15 = !DICompositeType(tag: DW_TAG_array_type, baseType: !12, size: 2560000, elements: !16)
!16 = !{!17, !17}
!17 = !DISubrange(count: 200)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "f", scope: !2, file: !3, line: 56, type: !15, isLocal: false, isDefinition: true)
!20 = !DIGlobalVariableExpression(var: !21, expr: !DIExpression())
!21 = distinct !DIGlobalVariable(name: "uold", scope: !2, file: !3, line: 56, type: !15, isLocal: false, isDefinition: true)
!22 = !DIGlobalVariableExpression(var: !23, expr: !DIExpression())
!23 = distinct !DIGlobalVariable(name: "dx", scope: !2, file: !3, line: 57, type: !12, isLocal: false, isDefinition: true)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "dy", scope: !2, file: !3, line: 57, type: !12, isLocal: false, isDefinition: true)
!26 = !{i32 7, !"Dwarf Version", i32 4}
!27 = !{i32 2, !"Debug Info Version", i32 3}
!28 = !{i32 1, !"wchar_size", i32 4}
!29 = !{!"Ubuntu clang version 11.1.0-6"}
!30 = distinct !DISubprogram(name: "initialize", scope: !3, file: !3, line: 60, type: !31, scopeLine: 61, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!31 = !DISubroutineType(types: !32)
!32 = !{null}
!33 = !DILocalVariable(name: "i", scope: !30, file: !3, line: 62, type: !6)
!34 = !DILocation(line: 62, column: 7, scope: !30)
!35 = !DILocalVariable(name: "j", scope: !30, file: !3, line: 62, type: !6)
!36 = !DILocation(line: 62, column: 10, scope: !30)
!37 = !DILocalVariable(name: "xx", scope: !30, file: !3, line: 62, type: !6)
!38 = !DILocation(line: 62, column: 13, scope: !30)
!39 = !DILocalVariable(name: "yy", scope: !30, file: !3, line: 62, type: !6)
!40 = !DILocation(line: 62, column: 17, scope: !30)
!41 = !DILocation(line: 64, column: 15, scope: !30)
!42 = !DILocation(line: 64, column: 17, scope: !30)
!43 = !DILocation(line: 64, column: 14, scope: !30)
!44 = !DILocation(line: 64, column: 12, scope: !30)
!45 = !DILocation(line: 64, column: 6, scope: !30)
!46 = !DILocation(line: 65, column: 15, scope: !30)
!47 = !DILocation(line: 65, column: 17, scope: !30)
!48 = !DILocation(line: 65, column: 14, scope: !30)
!49 = !DILocation(line: 65, column: 12, scope: !30)
!50 = !DILocation(line: 65, column: 6, scope: !30)
!51 = !DILocation(line: 69, column: 10, scope: !52)
!52 = distinct !DILexicalBlock(scope: !30, file: !3, line: 69, column: 3)
!53 = !DILocation(line: 69, column: 8, scope: !52)
!54 = !DILocation(line: 69, column: 15, scope: !55)
!55 = distinct !DILexicalBlock(scope: !52, file: !3, line: 69, column: 3)
!56 = !DILocation(line: 69, column: 19, scope: !55)
!57 = !DILocation(line: 69, column: 17, scope: !55)
!58 = !DILocation(line: 69, column: 3, scope: !52)
!59 = !DILocation(line: 70, column: 12, scope: !60)
!60 = distinct !DILexicalBlock(scope: !55, file: !3, line: 70, column: 5)
!61 = !DILocation(line: 70, column: 10, scope: !60)
!62 = !DILocation(line: 70, column: 17, scope: !63)
!63 = distinct !DILexicalBlock(scope: !60, file: !3, line: 70, column: 5)
!64 = !DILocation(line: 70, column: 21, scope: !63)
!65 = !DILocation(line: 70, column: 19, scope: !63)
!66 = !DILocation(line: 70, column: 5, scope: !60)
!67 = !DILocation(line: 72, column: 26, scope: !68)
!68 = distinct !DILexicalBlock(scope: !63, file: !3, line: 71, column: 5)
!69 = !DILocation(line: 72, column: 32, scope: !68)
!70 = !DILocation(line: 72, column: 34, scope: !68)
!71 = !DILocation(line: 72, column: 31, scope: !68)
!72 = !DILocation(line: 72, column: 29, scope: !68)
!73 = !DILocation(line: 72, column: 24, scope: !68)
!74 = !DILocation(line: 72, column: 12, scope: !68)
!75 = !DILocation(line: 72, column: 10, scope: !68)
!76 = !DILocation(line: 73, column: 26, scope: !68)
!77 = !DILocation(line: 73, column: 32, scope: !68)
!78 = !DILocation(line: 73, column: 34, scope: !68)
!79 = !DILocation(line: 73, column: 31, scope: !68)
!80 = !DILocation(line: 73, column: 29, scope: !68)
!81 = !DILocation(line: 73, column: 24, scope: !68)
!82 = !DILocation(line: 73, column: 12, scope: !68)
!83 = !DILocation(line: 73, column: 10, scope: !68)
!84 = !DILocation(line: 74, column: 9, scope: !68)
!85 = !DILocation(line: 74, column: 7, scope: !68)
!86 = !DILocation(line: 74, column: 12, scope: !68)
!87 = !DILocation(line: 74, column: 15, scope: !68)
!88 = !DILocation(line: 75, column: 24, scope: !68)
!89 = !DILocation(line: 75, column: 22, scope: !68)
!90 = !DILocation(line: 75, column: 39, scope: !68)
!91 = !DILocation(line: 75, column: 44, scope: !68)
!92 = !DILocation(line: 75, column: 42, scope: !68)
!93 = !DILocation(line: 75, column: 37, scope: !68)
!94 = !DILocation(line: 75, column: 30, scope: !68)
!95 = !DILocation(line: 75, column: 57, scope: !68)
!96 = !DILocation(line: 75, column: 62, scope: !68)
!97 = !DILocation(line: 75, column: 60, scope: !68)
!98 = !DILocation(line: 75, column: 55, scope: !68)
!99 = !DILocation(line: 75, column: 48, scope: !68)
!100 = !DILocation(line: 76, column: 24, scope: !68)
!101 = !DILocation(line: 76, column: 29, scope: !68)
!102 = !DILocation(line: 76, column: 27, scope: !68)
!103 = !DILocation(line: 76, column: 22, scope: !68)
!104 = !DILocation(line: 76, column: 15, scope: !68)
!105 = !DILocation(line: 76, column: 9, scope: !68)
!106 = !DILocation(line: 76, column: 48, scope: !68)
!107 = !DILocation(line: 76, column: 53, scope: !68)
!108 = !DILocation(line: 76, column: 51, scope: !68)
!109 = !DILocation(line: 76, column: 46, scope: !68)
!110 = !DILocation(line: 76, column: 39, scope: !68)
!111 = !DILocation(line: 76, column: 33, scope: !68)
!112 = !DILocation(line: 75, column: 9, scope: !68)
!113 = !DILocation(line: 75, column: 7, scope: !68)
!114 = !DILocation(line: 75, column: 12, scope: !68)
!115 = !DILocation(line: 75, column: 15, scope: !68)
!116 = !DILocation(line: 78, column: 5, scope: !68)
!117 = !DILocation(line: 70, column: 25, scope: !63)
!118 = !DILocation(line: 70, column: 5, scope: !63)
!119 = distinct !{!119, !66, !120}
!120 = !DILocation(line: 78, column: 5, scope: !60)
!121 = !DILocation(line: 69, column: 23, scope: !55)
!122 = !DILocation(line: 69, column: 3, scope: !55)
!123 = distinct !{!123, !58, !124}
!124 = !DILocation(line: 78, column: 5, scope: !52)
!125 = !DILocation(line: 79, column: 1, scope: !30)
!126 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 81, type: !127, scopeLine: 82, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!127 = !DISubroutineType(types: !5)
!128 = !DILocation(line: 83, column: 3, scope: !126)
!129 = !DILocation(line: 84, column: 3, scope: !126)
