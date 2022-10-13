; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !9 {
entry:
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %saved_stack = alloca i8*, align 8
  %__vla_expr0 = alloca i64, align 8
  %__vla_expr1 = alloca i64, align 8
  %dummy = alloca i32, align 4
  %__vla_expr2 = alloca i64, align 8
  %__vla_expr3 = alloca i64, align 8
  %buffer = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !13, metadata !DIExpression()), !dbg !14
  call void @llvm.dbg.declare(metadata i32* %j, metadata !15, metadata !DIExpression()), !dbg !16
  call void @llvm.dbg.declare(metadata i32* %n, metadata !17, metadata !DIExpression()), !dbg !18
  store i32 10, i32* %n, align 4, !dbg !18
  call void @llvm.dbg.declare(metadata i32* %m, metadata !19, metadata !DIExpression()), !dbg !20
  store i32 10, i32* %m, align 4, !dbg !20
  %0 = load i32, i32* %n, align 4, !dbg !21
  %1 = zext i32 %0 to i64, !dbg !22
  %2 = load i32, i32* %m, align 4, !dbg !23
  %3 = zext i32 %2 to i64, !dbg !22
  %4 = call i8* @llvm.stacksave(), !dbg !22
  store i8* %4, i8** %saved_stack, align 8, !dbg !22
  %5 = mul nuw i64 %1, %3, !dbg !22
  %vla = alloca double, i64 %5, align 16, !dbg !22
  store i64 %1, i64* %__vla_expr0, align 8, !dbg !22
  store i64 %3, i64* %__vla_expr1, align 8, !dbg !22
  call void @llvm.dbg.declare(metadata i64* %__vla_expr0, metadata !24, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.declare(metadata i64* %__vla_expr1, metadata !27, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.declare(metadata double* %vla, metadata !28, metadata !DIExpression()), !dbg !33
  %6 = mul nsw i64 1, %3, !dbg !34
  %arrayidx = getelementptr inbounds double, double* %vla, i64 %6, !dbg !34
  %arrayidx1 = getelementptr inbounds double, double* %arrayidx, i64 1, !dbg !34
  store double 4.200000e+01, double* %arrayidx1, align 8, !dbg !35
  store i32 0, i32* %i, align 4, !dbg !36
  br label %for.cond, !dbg !38

for.cond:                                         ; preds = %for.inc8, %entry
  %7 = load i32, i32* %i, align 4, !dbg !39
  %8 = load i32, i32* %n, align 4, !dbg !41
  %cmp = icmp slt i32 %7, %8, !dbg !42
  br i1 %cmp, label %for.body, label %for.end10, !dbg !43

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %j, align 4, !dbg !44
  br label %for.cond2, !dbg !46

for.cond2:                                        ; preds = %for.inc, %for.body
  %9 = load i32, i32* %j, align 4, !dbg !47
  %10 = load i32, i32* %n, align 4, !dbg !49
  %cmp3 = icmp slt i32 %9, %10, !dbg !50
  br i1 %cmp3, label %for.body4, label %for.end, !dbg !51

for.body4:                                        ; preds = %for.cond2
  %11 = load i32, i32* %i, align 4, !dbg !52
  %12 = load i32, i32* %j, align 4, !dbg !53
  %mul = mul nsw i32 %11, %12, !dbg !54
  %conv = sitofp i32 %mul to double, !dbg !55
  %13 = load i32, i32* %i, align 4, !dbg !56
  %idxprom = sext i32 %13 to i64, !dbg !57
  %14 = mul nsw i64 %idxprom, %3, !dbg !57
  %arrayidx5 = getelementptr inbounds double, double* %vla, i64 %14, !dbg !57
  %15 = load i32, i32* %j, align 4, !dbg !58
  %idxprom6 = sext i32 %15 to i64, !dbg !57
  %arrayidx7 = getelementptr inbounds double, double* %arrayidx5, i64 %idxprom6, !dbg !57
  store double %conv, double* %arrayidx7, align 8, !dbg !59
  br label %for.inc, !dbg !57

for.inc:                                          ; preds = %for.body4
  %16 = load i32, i32* %j, align 4, !dbg !60
  %inc = add nsw i32 %16, 1, !dbg !60
  store i32 %inc, i32* %j, align 4, !dbg !60
  br label %for.cond2, !dbg !61, !llvm.loop !62

for.end:                                          ; preds = %for.cond2
  br label %for.inc8, !dbg !63

for.inc8:                                         ; preds = %for.end
  %17 = load i32, i32* %i, align 4, !dbg !64
  %inc9 = add nsw i32 %17, 1, !dbg !64
  store i32 %inc9, i32* %i, align 4, !dbg !64
  br label %for.cond, !dbg !65, !llvm.loop !66

for.end10:                                        ; preds = %for.cond
  %18 = mul nsw i64 42, %3, !dbg !68
  %arrayidx11 = getelementptr inbounds double, double* %vla, i64 %18, !dbg !68
  %arrayidx12 = getelementptr inbounds double, double* %arrayidx11, i64 21, !dbg !68
  %19 = load double, double* %arrayidx12, align 8, !dbg !68
  %20 = mul nsw i64 1, %3, !dbg !69
  %arrayidx13 = getelementptr inbounds double, double* %vla, i64 %20, !dbg !69
  %arrayidx14 = getelementptr inbounds double, double* %arrayidx13, i64 2, !dbg !69
  store double %19, double* %arrayidx14, align 8, !dbg !70
  call void @llvm.dbg.declare(metadata i32* %dummy, metadata !71, metadata !DIExpression()), !dbg !72
  store i32 42, i32* %dummy, align 4, !dbg !72
  %21 = load i32, i32* %n, align 4, !dbg !73
  %22 = zext i32 %21 to i64, !dbg !74
  %23 = load i32, i32* %n, align 4, !dbg !75
  %24 = zext i32 %23 to i64, !dbg !74
  %25 = mul nuw i64 %22, %24, !dbg !74
  %vla15 = alloca double, i64 %25, align 16, !dbg !74
  store i64 %22, i64* %__vla_expr2, align 8, !dbg !74
  store i64 %24, i64* %__vla_expr3, align 8, !dbg !74
  call void @llvm.dbg.declare(metadata i64* %__vla_expr2, metadata !76, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.declare(metadata i64* %__vla_expr3, metadata !77, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.declare(metadata double* %vla15, metadata !78, metadata !DIExpression()), !dbg !83
  store i32 0, i32* %i, align 4, !dbg !84
  br label %for.cond16, !dbg !86

for.cond16:                                       ; preds = %for.inc37, %for.end10
  %26 = load i32, i32* %i, align 4, !dbg !87
  %27 = load i32, i32* %n, align 4, !dbg !89
  %cmp17 = icmp slt i32 %26, %27, !dbg !90
  br i1 %cmp17, label %for.body19, label %for.end39, !dbg !91

for.body19:                                       ; preds = %for.cond16
  store i32 0, i32* %j, align 4, !dbg !92
  br label %for.cond20, !dbg !95

for.cond20:                                       ; preds = %for.inc34, %for.body19
  %28 = load i32, i32* %j, align 4, !dbg !96
  %29 = load i32, i32* %n, align 4, !dbg !98
  %div = sdiv i32 %29, 2, !dbg !99
  %cmp21 = icmp slt i32 %28, %div, !dbg !100
  br i1 %cmp21, label %for.body23, label %for.end36, !dbg !101

for.body23:                                       ; preds = %for.cond20
  %30 = load i32, i32* %i, align 4, !dbg !102
  %31 = load i32, i32* %n, align 4, !dbg !105
  %div24 = sdiv i32 %31, 2, !dbg !106
  %cmp25 = icmp slt i32 %30, %div24, !dbg !107
  br i1 %cmp25, label %if.then, label %if.end, !dbg !108

if.then:                                          ; preds = %for.body23
  store i32 1, i32* %dummy, align 4, !dbg !109
  br label %if.end, !dbg !111

if.end:                                           ; preds = %if.then, %for.body23
  %32 = load i32, i32* %i, align 4, !dbg !112
  %33 = load i32, i32* %j, align 4, !dbg !113
  %mul27 = mul nsw i32 %32, %33, !dbg !114
  %34 = load i32, i32* %dummy, align 4, !dbg !115
  %add = add nsw i32 %mul27, %34, !dbg !116
  %conv28 = sitofp i32 %add to double, !dbg !117
  %35 = load i32, i32* %i, align 4, !dbg !118
  %idxprom29 = sext i32 %35 to i64, !dbg !119
  %36 = mul nsw i64 %idxprom29, %24, !dbg !119
  %arrayidx30 = getelementptr inbounds double, double* %vla15, i64 %36, !dbg !119
  %37 = load i32, i32* %j, align 4, !dbg !120
  %idxprom31 = sext i32 %37 to i64, !dbg !119
  %arrayidx32 = getelementptr inbounds double, double* %arrayidx30, i64 %idxprom31, !dbg !119
  store double %conv28, double* %arrayidx32, align 8, !dbg !121
  %38 = load i32, i32* %dummy, align 4, !dbg !122
  %add33 = add nsw i32 %38, 1, !dbg !122
  store i32 %add33, i32* %dummy, align 4, !dbg !122
  br label %for.inc34, !dbg !123

for.inc34:                                        ; preds = %if.end
  %39 = load i32, i32* %j, align 4, !dbg !124
  %inc35 = add nsw i32 %39, 1, !dbg !124
  store i32 %inc35, i32* %j, align 4, !dbg !124
  br label %for.cond20, !dbg !125, !llvm.loop !126

for.end36:                                        ; preds = %for.cond20
  br label %for.inc37, !dbg !128

for.inc37:                                        ; preds = %for.end36
  %40 = load i32, i32* %i, align 4, !dbg !129
  %inc38 = add nsw i32 %40, 1, !dbg !129
  store i32 %inc38, i32* %i, align 4, !dbg !129
  br label %for.cond16, !dbg !130, !llvm.loop !131

for.end39:                                        ; preds = %for.cond16
  call void @llvm.dbg.declare(metadata i32* %buffer, metadata !133, metadata !DIExpression()), !dbg !134
  %41 = mul nsw i64 7, %24, !dbg !135
  %arrayidx40 = getelementptr inbounds double, double* %vla15, i64 %41, !dbg !135
  %arrayidx41 = getelementptr inbounds double, double* %arrayidx40, i64 4, !dbg !135
  %42 = load double, double* %arrayidx41, align 8, !dbg !135
  %43 = mul nsw i64 2, %3, !dbg !136
  %arrayidx42 = getelementptr inbounds double, double* %vla, i64 %43, !dbg !136
  %arrayidx43 = getelementptr inbounds double, double* %arrayidx42, i64 5, !dbg !136
  %44 = load double, double* %arrayidx43, align 8, !dbg !136
  %mul44 = fmul double %42, %44, !dbg !137
  %45 = load i32, i32* %dummy, align 4, !dbg !138
  %conv45 = sitofp i32 %45 to double, !dbg !138
  %add46 = fadd double %mul44, %conv45, !dbg !139
  %conv47 = fptosi double %add46 to i32, !dbg !135
  store i32 %conv47, i32* %buffer, align 4, !dbg !134
  store i32 0, i32* %retval, align 4, !dbg !140
  %46 = load i8*, i8** %saved_stack, align 8, !dbg !141
  call void @llvm.stackrestore(i8* %46), !dbg !141
  %47 = load i32, i32* %retval, align 4, !dbg !141
  ret i32 %47, !dbg !141
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare i8* @llvm.stacksave() #2

; Function Attrs: nounwind
declare void @llvm.stackrestore(i8*) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!5, !6, !7}
!llvm.ident = !{!8}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/1337")
!2 = !{}
!3 = !{!4}
!4 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!5 = !{i32 7, !"Dwarf Version", i32 4}
!6 = !{i32 2, !"Debug Info Version", i32 3}
!7 = !{i32 1, !"wchar_size", i32 4}
!8 = !{!"Ubuntu clang version 11.1.0-6"}
!9 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 1, type: !10, scopeLine: 2, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!10 = !DISubroutineType(types: !11)
!11 = !{!12}
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !DILocalVariable(name: "i", scope: !9, file: !1, line: 3, type: !12)
!14 = !DILocation(line: 3, column: 7, scope: !9)
!15 = !DILocalVariable(name: "j", scope: !9, file: !1, line: 3, type: !12)
!16 = !DILocation(line: 3, column: 9, scope: !9)
!17 = !DILocalVariable(name: "n", scope: !9, file: !1, line: 4, type: !12)
!18 = !DILocation(line: 4, column: 7, scope: !9)
!19 = !DILocalVariable(name: "m", scope: !9, file: !1, line: 4, type: !12)
!20 = !DILocation(line: 4, column: 13, scope: !9)
!21 = !DILocation(line: 5, column: 12, scope: !9)
!22 = !DILocation(line: 5, column: 3, scope: !9)
!23 = !DILocation(line: 5, column: 15, scope: !9)
!24 = !DILocalVariable(name: "__vla_expr0", scope: !9, type: !25, flags: DIFlagArtificial)
!25 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!26 = !DILocation(line: 0, scope: !9)
!27 = !DILocalVariable(name: "__vla_expr1", scope: !9, type: !25, flags: DIFlagArtificial)
!28 = !DILocalVariable(name: "b", scope: !9, file: !1, line: 5, type: !29)
!29 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, elements: !30)
!30 = !{!31, !32}
!31 = !DISubrange(count: !24)
!32 = !DISubrange(count: !27)
!33 = !DILocation(line: 5, column: 10, scope: !9)
!34 = !DILocation(line: 6, column: 3, scope: !9)
!35 = !DILocation(line: 6, column: 11, scope: !9)
!36 = !DILocation(line: 10, column: 8, scope: !37)
!37 = distinct !DILexicalBlock(scope: !9, file: !1, line: 10, column: 3)
!38 = !DILocation(line: 10, column: 7, scope: !37)
!39 = !DILocation(line: 10, column: 11, scope: !40)
!40 = distinct !DILexicalBlock(scope: !37, file: !1, line: 10, column: 3)
!41 = !DILocation(line: 10, column: 13, scope: !40)
!42 = !DILocation(line: 10, column: 12, scope: !40)
!43 = !DILocation(line: 10, column: 3, scope: !37)
!44 = !DILocation(line: 11, column: 10, scope: !45)
!45 = distinct !DILexicalBlock(scope: !40, file: !1, line: 11, column: 5)
!46 = !DILocation(line: 11, column: 9, scope: !45)
!47 = !DILocation(line: 11, column: 13, scope: !48)
!48 = distinct !DILexicalBlock(scope: !45, file: !1, line: 11, column: 5)
!49 = !DILocation(line: 11, column: 15, scope: !48)
!50 = !DILocation(line: 11, column: 14, scope: !48)
!51 = !DILocation(line: 11, column: 5, scope: !45)
!52 = !DILocation(line: 12, column: 24, scope: !48)
!53 = !DILocation(line: 12, column: 26, scope: !48)
!54 = !DILocation(line: 12, column: 25, scope: !48)
!55 = !DILocation(line: 12, column: 15, scope: !48)
!56 = !DILocation(line: 12, column: 9, scope: !48)
!57 = !DILocation(line: 12, column: 7, scope: !48)
!58 = !DILocation(line: 12, column: 12, scope: !48)
!59 = !DILocation(line: 12, column: 14, scope: !48)
!60 = !DILocation(line: 11, column: 19, scope: !48)
!61 = !DILocation(line: 11, column: 5, scope: !48)
!62 = distinct !{!62, !51, !63}
!63 = !DILocation(line: 12, column: 27, scope: !45)
!64 = !DILocation(line: 10, column: 17, scope: !40)
!65 = !DILocation(line: 10, column: 3, scope: !40)
!66 = distinct !{!66, !43, !67}
!67 = !DILocation(line: 12, column: 27, scope: !37)
!68 = !DILocation(line: 16, column: 13, scope: !9)
!69 = !DILocation(line: 16, column: 3, scope: !9)
!70 = !DILocation(line: 16, column: 11, scope: !9)
!71 = !DILocalVariable(name: "dummy", scope: !9, file: !1, line: 18, type: !12)
!72 = !DILocation(line: 18, column: 7, scope: !9)
!73 = !DILocation(line: 20, column: 12, scope: !9)
!74 = !DILocation(line: 20, column: 3, scope: !9)
!75 = !DILocation(line: 20, column: 15, scope: !9)
!76 = !DILocalVariable(name: "__vla_expr2", scope: !9, type: !25, flags: DIFlagArtificial)
!77 = !DILocalVariable(name: "__vla_expr3", scope: !9, type: !25, flags: DIFlagArtificial)
!78 = !DILocalVariable(name: "a", scope: !9, file: !1, line: 20, type: !79)
!79 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, elements: !80)
!80 = !{!81, !82}
!81 = !DISubrange(count: !76)
!82 = !DISubrange(count: !77)
!83 = !DILocation(line: 20, column: 10, scope: !9)
!84 = !DILocation(line: 25, column: 8, scope: !85)
!85 = distinct !DILexicalBlock(scope: !9, file: !1, line: 25, column: 3)
!86 = !DILocation(line: 25, column: 7, scope: !85)
!87 = !DILocation(line: 25, column: 11, scope: !88)
!88 = distinct !DILexicalBlock(scope: !85, file: !1, line: 25, column: 3)
!89 = !DILocation(line: 25, column: 13, scope: !88)
!90 = !DILocation(line: 25, column: 12, scope: !88)
!91 = !DILocation(line: 25, column: 3, scope: !85)
!92 = !DILocation(line: 26, column: 10, scope: !93)
!93 = distinct !DILexicalBlock(scope: !94, file: !1, line: 26, column: 5)
!94 = distinct !DILexicalBlock(scope: !88, file: !1, line: 25, column: 20)
!95 = !DILocation(line: 26, column: 9, scope: !93)
!96 = !DILocation(line: 26, column: 13, scope: !97)
!97 = distinct !DILexicalBlock(scope: !93, file: !1, line: 26, column: 5)
!98 = !DILocation(line: 26, column: 15, scope: !97)
!99 = !DILocation(line: 26, column: 16, scope: !97)
!100 = !DILocation(line: 26, column: 14, scope: !97)
!101 = !DILocation(line: 26, column: 5, scope: !93)
!102 = !DILocation(line: 27, column: 10, scope: !103)
!103 = distinct !DILexicalBlock(scope: !104, file: !1, line: 27, column: 10)
!104 = distinct !DILexicalBlock(scope: !97, file: !1, line: 26, column: 24)
!105 = !DILocation(line: 27, column: 14, scope: !103)
!106 = !DILocation(line: 27, column: 15, scope: !103)
!107 = !DILocation(line: 27, column: 12, scope: !103)
!108 = !DILocation(line: 27, column: 10, scope: !104)
!109 = !DILocation(line: 28, column: 15, scope: !110)
!110 = distinct !DILexicalBlock(scope: !103, file: !1, line: 27, column: 18)
!111 = !DILocation(line: 29, column: 7, scope: !110)
!112 = !DILocation(line: 30, column: 27, scope: !104)
!113 = !DILocation(line: 30, column: 29, scope: !104)
!114 = !DILocation(line: 30, column: 28, scope: !104)
!115 = !DILocation(line: 30, column: 33, scope: !104)
!116 = !DILocation(line: 30, column: 31, scope: !104)
!117 = !DILocation(line: 30, column: 17, scope: !104)
!118 = !DILocation(line: 30, column: 9, scope: !104)
!119 = !DILocation(line: 30, column: 7, scope: !104)
!120 = !DILocation(line: 30, column: 12, scope: !104)
!121 = !DILocation(line: 30, column: 15, scope: !104)
!122 = !DILocation(line: 31, column: 13, scope: !104)
!123 = !DILocation(line: 32, column: 5, scope: !104)
!124 = !DILocation(line: 26, column: 21, scope: !97)
!125 = !DILocation(line: 26, column: 5, scope: !97)
!126 = distinct !{!126, !101, !127}
!127 = !DILocation(line: 32, column: 5, scope: !93)
!128 = !DILocation(line: 33, column: 3, scope: !94)
!129 = !DILocation(line: 25, column: 17, scope: !88)
!130 = !DILocation(line: 25, column: 3, scope: !88)
!131 = distinct !{!131, !91, !132}
!132 = !DILocation(line: 33, column: 3, scope: !85)
!133 = !DILocalVariable(name: "buffer", scope: !9, file: !1, line: 36, type: !12)
!134 = !DILocation(line: 36, column: 7, scope: !9)
!135 = !DILocation(line: 36, column: 16, scope: !9)
!136 = !DILocation(line: 36, column: 26, scope: !9)
!137 = !DILocation(line: 36, column: 24, scope: !9)
!138 = !DILocation(line: 36, column: 36, scope: !9)
!139 = !DILocation(line: 36, column: 34, scope: !9)
!140 = !DILocation(line: 38, column: 3, scope: !9)
!141 = !DILocation(line: 39, column: 1, scope: !9)
