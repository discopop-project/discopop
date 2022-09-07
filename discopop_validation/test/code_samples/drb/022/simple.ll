; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [10 x i8] c"sum = %f\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !7 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %temp = alloca float, align 4
  %sum = alloca float, align 4
  %len = alloca i32, align 4
  %saved_stack = alloca i8*, align 8
  %__vla_expr0 = alloca i64, align 8
  %__vla_expr1 = alloca i64, align 8
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !14, metadata !DIExpression()), !dbg !15
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !16, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.declare(metadata i32* %i, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32* %j, metadata !20, metadata !DIExpression()), !dbg !21
  call void @llvm.dbg.declare(metadata float* %temp, metadata !22, metadata !DIExpression()), !dbg !24
  call void @llvm.dbg.declare(metadata float* %sum, metadata !25, metadata !DIExpression()), !dbg !26
  store float 0.000000e+00, float* %sum, align 4, !dbg !26
  call void @llvm.dbg.declare(metadata i32* %len, metadata !27, metadata !DIExpression()), !dbg !28
  store i32 100, i32* %len, align 4, !dbg !28
  %0 = load i32, i32* %argc.addr, align 4, !dbg !29
  %cmp = icmp sgt i32 %0, 1, !dbg !31
  br i1 %cmp, label %if.then, label %if.end, !dbg !32

if.then:                                          ; preds = %entry
  %1 = load i8**, i8*** %argv.addr, align 8, !dbg !33
  %arrayidx = getelementptr inbounds i8*, i8** %1, i64 1, !dbg !33
  %2 = load i8*, i8** %arrayidx, align 8, !dbg !33
  %call = call i32 @atoi(i8* %2) #5, !dbg !34
  store i32 %call, i32* %len, align 4, !dbg !35
  br label %if.end, !dbg !36

if.end:                                           ; preds = %if.then, %entry
  %3 = load i32, i32* %len, align 4, !dbg !37
  %4 = zext i32 %3 to i64, !dbg !38
  %5 = load i32, i32* %len, align 4, !dbg !39
  %6 = zext i32 %5 to i64, !dbg !38
  %7 = call i8* @llvm.stacksave(), !dbg !38
  store i8* %7, i8** %saved_stack, align 8, !dbg !38
  %8 = mul nuw i64 %4, %6, !dbg !38
  %vla = alloca float, i64 %8, align 16, !dbg !38
  store i64 %4, i64* %__vla_expr0, align 8, !dbg !38
  store i64 %6, i64* %__vla_expr1, align 8, !dbg !38
  call void @llvm.dbg.declare(metadata i64* %__vla_expr0, metadata !40, metadata !DIExpression()), !dbg !42
  call void @llvm.dbg.declare(metadata i64* %__vla_expr1, metadata !43, metadata !DIExpression()), !dbg !42
  call void @llvm.dbg.declare(metadata float* %vla, metadata !44, metadata !DIExpression()), !dbg !49
  store i32 0, i32* %i, align 4, !dbg !50
  br label %for.cond, !dbg !52

for.cond:                                         ; preds = %for.inc8, %if.end
  %9 = load i32, i32* %i, align 4, !dbg !53
  %10 = load i32, i32* %len, align 4, !dbg !55
  %cmp1 = icmp slt i32 %9, %10, !dbg !56
  br i1 %cmp1, label %for.body, label %for.end10, !dbg !57

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %j, align 4, !dbg !58
  br label %for.cond2, !dbg !60

for.cond2:                                        ; preds = %for.inc, %for.body
  %11 = load i32, i32* %j, align 4, !dbg !61
  %12 = load i32, i32* %len, align 4, !dbg !63
  %cmp3 = icmp slt i32 %11, %12, !dbg !64
  br i1 %cmp3, label %for.body4, label %for.end, !dbg !65

for.body4:                                        ; preds = %for.cond2
  %13 = load i32, i32* %i, align 4, !dbg !66
  %idxprom = sext i32 %13 to i64, !dbg !67
  %14 = mul nsw i64 %idxprom, %6, !dbg !67
  %arrayidx5 = getelementptr inbounds float, float* %vla, i64 %14, !dbg !67
  %15 = load i32, i32* %j, align 4, !dbg !68
  %idxprom6 = sext i32 %15 to i64, !dbg !67
  %arrayidx7 = getelementptr inbounds float, float* %arrayidx5, i64 %idxprom6, !dbg !67
  store float 5.000000e-01, float* %arrayidx7, align 4, !dbg !69
  br label %for.inc, !dbg !67

for.inc:                                          ; preds = %for.body4
  %16 = load i32, i32* %j, align 4, !dbg !70
  %inc = add nsw i32 %16, 1, !dbg !70
  store i32 %inc, i32* %j, align 4, !dbg !70
  br label %for.cond2, !dbg !71, !llvm.loop !72

for.end:                                          ; preds = %for.cond2
  br label %for.inc8, !dbg !73

for.inc8:                                         ; preds = %for.end
  %17 = load i32, i32* %i, align 4, !dbg !74
  %inc9 = add nsw i32 %17, 1, !dbg !74
  store i32 %inc9, i32* %i, align 4, !dbg !74
  br label %for.cond, !dbg !75, !llvm.loop !76

for.end10:                                        ; preds = %for.cond
  store i32 0, i32* %i, align 4, !dbg !78
  br label %for.cond11, !dbg !80

for.cond11:                                       ; preds = %for.inc24, %for.end10
  %18 = load i32, i32* %i, align 4, !dbg !81
  %19 = load i32, i32* %len, align 4, !dbg !83
  %cmp12 = icmp slt i32 %18, %19, !dbg !84
  br i1 %cmp12, label %for.body13, label %for.end26, !dbg !85

for.body13:                                       ; preds = %for.cond11
  store i32 0, i32* %j, align 4, !dbg !86
  br label %for.cond14, !dbg !88

for.cond14:                                       ; preds = %for.inc21, %for.body13
  %20 = load i32, i32* %j, align 4, !dbg !89
  %21 = load i32, i32* %len, align 4, !dbg !91
  %cmp15 = icmp slt i32 %20, %21, !dbg !92
  br i1 %cmp15, label %for.body16, label %for.end23, !dbg !93

for.body16:                                       ; preds = %for.cond14
  %22 = load i32, i32* %i, align 4, !dbg !94
  %idxprom17 = sext i32 %22 to i64, !dbg !96
  %23 = mul nsw i64 %idxprom17, %6, !dbg !96
  %arrayidx18 = getelementptr inbounds float, float* %vla, i64 %23, !dbg !96
  %24 = load i32, i32* %j, align 4, !dbg !97
  %idxprom19 = sext i32 %24 to i64, !dbg !96
  %arrayidx20 = getelementptr inbounds float, float* %arrayidx18, i64 %idxprom19, !dbg !96
  %25 = load float, float* %arrayidx20, align 4, !dbg !96
  store float %25, float* %temp, align 4, !dbg !98
  %26 = load float, float* %sum, align 4, !dbg !99
  %27 = load float, float* %temp, align 4, !dbg !100
  %28 = load float, float* %temp, align 4, !dbg !101
  %mul = fmul float %27, %28, !dbg !102
  %add = fadd float %26, %mul, !dbg !103
  store float %add, float* %sum, align 4, !dbg !104
  br label %for.inc21, !dbg !105

for.inc21:                                        ; preds = %for.body16
  %29 = load i32, i32* %j, align 4, !dbg !106
  %inc22 = add nsw i32 %29, 1, !dbg !106
  store i32 %inc22, i32* %j, align 4, !dbg !106
  br label %for.cond14, !dbg !107, !llvm.loop !108

for.end23:                                        ; preds = %for.cond14
  br label %for.inc24, !dbg !109

for.inc24:                                        ; preds = %for.end23
  %30 = load i32, i32* %i, align 4, !dbg !110
  %inc25 = add nsw i32 %30, 1, !dbg !110
  store i32 %inc25, i32* %i, align 4, !dbg !110
  br label %for.cond11, !dbg !111, !llvm.loop !112

for.end26:                                        ; preds = %for.cond11
  %31 = load float, float* %sum, align 4, !dbg !114
  %conv = fpext float %31 to double, !dbg !114
  %call27 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), double %conv), !dbg !115
  store i32 0, i32* %retval, align 4, !dbg !116
  %32 = load i8*, i8** %saved_stack, align 8, !dbg !117
  call void @llvm.stackrestore(i8* %32), !dbg !117
  %33 = load i32, i32* %retval, align 4, !dbg !117
  ret i32 %33, !dbg !117
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind readonly
declare dso_local i32 @atoi(i8*) #2

; Function Attrs: nounwind
declare i8* @llvm.stacksave() #3

declare dso_local i32 @printf(i8*, ...) #4

; Function Attrs: nounwind
declare void @llvm.stackrestore(i8*) #3

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }
attributes #4 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind readonly }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/022")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"Ubuntu clang version 11.1.0-6"}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 55, type: !8, scopeLine: 56, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10, !10, !11}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!13 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!14 = !DILocalVariable(name: "argc", arg: 1, scope: !7, file: !1, line: 55, type: !10)
!15 = !DILocation(line: 55, column: 14, scope: !7)
!16 = !DILocalVariable(name: "argv", arg: 2, scope: !7, file: !1, line: 55, type: !11)
!17 = !DILocation(line: 55, column: 26, scope: !7)
!18 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 57, type: !10)
!19 = !DILocation(line: 57, column: 7, scope: !7)
!20 = !DILocalVariable(name: "j", scope: !7, file: !1, line: 57, type: !10)
!21 = !DILocation(line: 57, column: 9, scope: !7)
!22 = !DILocalVariable(name: "temp", scope: !7, file: !1, line: 58, type: !23)
!23 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!24 = !DILocation(line: 58, column: 9, scope: !7)
!25 = !DILocalVariable(name: "sum", scope: !7, file: !1, line: 58, type: !23)
!26 = !DILocation(line: 58, column: 15, scope: !7)
!27 = !DILocalVariable(name: "len", scope: !7, file: !1, line: 59, type: !10)
!28 = !DILocation(line: 59, column: 7, scope: !7)
!29 = !DILocation(line: 60, column: 7, scope: !30)
!30 = distinct !DILexicalBlock(scope: !7, file: !1, line: 60, column: 7)
!31 = !DILocation(line: 60, column: 11, scope: !30)
!32 = !DILocation(line: 60, column: 7, scope: !7)
!33 = !DILocation(line: 61, column: 16, scope: !30)
!34 = !DILocation(line: 61, column: 11, scope: !30)
!35 = !DILocation(line: 61, column: 9, scope: !30)
!36 = !DILocation(line: 61, column: 5, scope: !30)
!37 = !DILocation(line: 62, column: 11, scope: !7)
!38 = !DILocation(line: 62, column: 3, scope: !7)
!39 = !DILocation(line: 62, column: 16, scope: !7)
!40 = !DILocalVariable(name: "__vla_expr0", scope: !7, type: !41, flags: DIFlagArtificial)
!41 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!42 = !DILocation(line: 0, scope: !7)
!43 = !DILocalVariable(name: "__vla_expr1", scope: !7, type: !41, flags: DIFlagArtificial)
!44 = !DILocalVariable(name: "u", scope: !7, file: !1, line: 62, type: !45)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, elements: !46)
!46 = !{!47, !48}
!47 = !DISubrange(count: !40)
!48 = !DISubrange(count: !43)
!49 = !DILocation(line: 62, column: 9, scope: !7)
!50 = !DILocation(line: 63, column: 10, scope: !51)
!51 = distinct !DILexicalBlock(scope: !7, file: !1, line: 63, column: 3)
!52 = !DILocation(line: 63, column: 8, scope: !51)
!53 = !DILocation(line: 63, column: 15, scope: !54)
!54 = distinct !DILexicalBlock(scope: !51, file: !1, line: 63, column: 3)
!55 = !DILocation(line: 63, column: 19, scope: !54)
!56 = !DILocation(line: 63, column: 17, scope: !54)
!57 = !DILocation(line: 63, column: 3, scope: !51)
!58 = !DILocation(line: 64, column: 12, scope: !59)
!59 = distinct !DILexicalBlock(scope: !54, file: !1, line: 64, column: 5)
!60 = !DILocation(line: 64, column: 10, scope: !59)
!61 = !DILocation(line: 64, column: 17, scope: !62)
!62 = distinct !DILexicalBlock(scope: !59, file: !1, line: 64, column: 5)
!63 = !DILocation(line: 64, column: 21, scope: !62)
!64 = !DILocation(line: 64, column: 19, scope: !62)
!65 = !DILocation(line: 64, column: 5, scope: !59)
!66 = !DILocation(line: 65, column: 11, scope: !62)
!67 = !DILocation(line: 65, column: 9, scope: !62)
!68 = !DILocation(line: 65, column: 14, scope: !62)
!69 = !DILocation(line: 65, column: 17, scope: !62)
!70 = !DILocation(line: 64, column: 27, scope: !62)
!71 = !DILocation(line: 64, column: 5, scope: !62)
!72 = distinct !{!72, !65, !73}
!73 = !DILocation(line: 65, column: 19, scope: !59)
!74 = !DILocation(line: 63, column: 25, scope: !54)
!75 = !DILocation(line: 63, column: 3, scope: !54)
!76 = distinct !{!76, !57, !77}
!77 = !DILocation(line: 65, column: 19, scope: !51)
!78 = !DILocation(line: 68, column: 10, scope: !79)
!79 = distinct !DILexicalBlock(scope: !7, file: !1, line: 68, column: 3)
!80 = !DILocation(line: 68, column: 8, scope: !79)
!81 = !DILocation(line: 68, column: 15, scope: !82)
!82 = distinct !DILexicalBlock(scope: !79, file: !1, line: 68, column: 3)
!83 = !DILocation(line: 68, column: 19, scope: !82)
!84 = !DILocation(line: 68, column: 17, scope: !82)
!85 = !DILocation(line: 68, column: 3, scope: !79)
!86 = !DILocation(line: 69, column: 12, scope: !87)
!87 = distinct !DILexicalBlock(scope: !82, file: !1, line: 69, column: 5)
!88 = !DILocation(line: 69, column: 10, scope: !87)
!89 = !DILocation(line: 69, column: 17, scope: !90)
!90 = distinct !DILexicalBlock(scope: !87, file: !1, line: 69, column: 5)
!91 = !DILocation(line: 69, column: 21, scope: !90)
!92 = !DILocation(line: 69, column: 19, scope: !90)
!93 = !DILocation(line: 69, column: 5, scope: !87)
!94 = !DILocation(line: 71, column: 16, scope: !95)
!95 = distinct !DILexicalBlock(scope: !90, file: !1, line: 70, column: 5)
!96 = !DILocation(line: 71, column: 14, scope: !95)
!97 = !DILocation(line: 71, column: 19, scope: !95)
!98 = !DILocation(line: 71, column: 12, scope: !95)
!99 = !DILocation(line: 72, column: 13, scope: !95)
!100 = !DILocation(line: 72, column: 19, scope: !95)
!101 = !DILocation(line: 72, column: 26, scope: !95)
!102 = !DILocation(line: 72, column: 24, scope: !95)
!103 = !DILocation(line: 72, column: 17, scope: !95)
!104 = !DILocation(line: 72, column: 11, scope: !95)
!105 = !DILocation(line: 73, column: 5, scope: !95)
!106 = !DILocation(line: 69, column: 27, scope: !90)
!107 = !DILocation(line: 69, column: 5, scope: !90)
!108 = distinct !{!108, !93, !109}
!109 = !DILocation(line: 73, column: 5, scope: !87)
!110 = !DILocation(line: 68, column: 25, scope: !82)
!111 = !DILocation(line: 68, column: 3, scope: !82)
!112 = distinct !{!112, !85, !113}
!113 = !DILocation(line: 73, column: 5, scope: !79)
!114 = !DILocation(line: 74, column: 25, scope: !7)
!115 = !DILocation(line: 74, column: 3, scope: !7)
!116 = !DILocation(line: 75, column: 3, scope: !7)
!117 = !DILocation(line: 76, column: 1, scope: !7)
