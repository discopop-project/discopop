; ModuleID = '/home/raynard/discopop/work_tests/dac_test/test.c'
source_filename = "/home/raynard/discopop/work_tests/dac_test/test.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [12 x i8] c"a[%d] = %d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !7 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %len = alloca i32, align 4
  %a = alloca [100 x i32], align 16
  %b = alloca [100 x i32], align 16
  %sum = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !15, metadata !DIExpression()), !dbg !16
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !17, metadata !DIExpression()), !dbg !18
  call void @llvm.dbg.declare(metadata i32* %i, metadata !19, metadata !DIExpression()), !dbg !20
  call void @llvm.dbg.declare(metadata i32* %len, metadata !21, metadata !DIExpression()), !dbg !22
  store i32 100, i32* %len, align 4, !dbg !22
  call void @llvm.dbg.declare(metadata [100 x i32]* %a, metadata !23, metadata !DIExpression()), !dbg !27
  call void @llvm.dbg.declare(metadata [100 x i32]* %b, metadata !28, metadata !DIExpression()), !dbg !29
  call void @llvm.dbg.declare(metadata i32* %sum, metadata !30, metadata !DIExpression()), !dbg !31
  store i32 0, i32* %sum, align 4, !dbg !31
  store i32 0, i32* %i, align 4, !dbg !32
  br label %for.cond, !dbg !34

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !35
  %1 = load i32, i32* %len, align 4, !dbg !37
  %cmp = icmp slt i32 %0, %1, !dbg !38
  br i1 %cmp, label %for.body, label %for.end, !dbg !39

for.body:                                         ; preds = %for.cond
  %2 = load i32, i32* %i, align 4, !dbg !40
  %3 = load i32, i32* %i, align 4, !dbg !42
  %idxprom = sext i32 %3 to i64, !dbg !43
  %arrayidx = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom, !dbg !43
  store i32 %2, i32* %arrayidx, align 4, !dbg !44
  %4 = load i32, i32* %i, align 4, !dbg !45
  %add = add nsw i32 %4, 1, !dbg !46
  %5 = load i32, i32* %i, align 4, !dbg !47
  %idxprom1 = sext i32 %5 to i64, !dbg !48
  %arrayidx2 = getelementptr inbounds [100 x i32], [100 x i32]* %b, i64 0, i64 %idxprom1, !dbg !48
  store i32 %add, i32* %arrayidx2, align 4, !dbg !49
  br label %for.inc, !dbg !50

for.inc:                                          ; preds = %for.body
  %6 = load i32, i32* %i, align 4, !dbg !51
  %inc = add nsw i32 %6, 1, !dbg !51
  store i32 %inc, i32* %i, align 4, !dbg !51
  br label %for.cond, !dbg !52, !llvm.loop !53

for.end:                                          ; preds = %for.cond
  store i32 0, i32* %i, align 4, !dbg !55
  br label %for.cond3, !dbg !57

for.cond3:                                        ; preds = %for.inc21, %for.end
  %7 = load i32, i32* %i, align 4, !dbg !58
  %8 = load i32, i32* %len, align 4, !dbg !60
  %sub = sub nsw i32 %8, 1, !dbg !61
  %cmp4 = icmp slt i32 %7, %sub, !dbg !62
  br i1 %cmp4, label %for.body5, label %for.end23, !dbg !63

for.body5:                                        ; preds = %for.cond3
  %9 = load i32, i32* %i, align 4, !dbg !64
  %idxprom6 = sext i32 %9 to i64, !dbg !66
  %arrayidx7 = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom6, !dbg !66
  %10 = load i32, i32* %arrayidx7, align 4, !dbg !66
  %11 = load i32, i32* %i, align 4, !dbg !67
  %idxprom8 = sext i32 %11 to i64, !dbg !68
  %arrayidx9 = getelementptr inbounds [100 x i32], [100 x i32]* %b, i64 0, i64 %idxprom8, !dbg !68
  %12 = load i32, i32* %arrayidx9, align 4, !dbg !68
  %add10 = add nsw i32 %10, %12, !dbg !69
  %add11 = add nsw i32 %add10, 1, !dbg !70
  %13 = load i32, i32* %i, align 4, !dbg !71
  %add12 = add nsw i32 %13, 1, !dbg !72
  %idxprom13 = sext i32 %add12 to i64, !dbg !73
  %arrayidx14 = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom13, !dbg !73
  store i32 %add11, i32* %arrayidx14, align 4, !dbg !74
  %14 = load i32, i32* %i, align 4, !dbg !75
  %add15 = add nsw i32 %14, 1, !dbg !76
  %idxprom16 = sext i32 %add15 to i64, !dbg !77
  %arrayidx17 = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom16, !dbg !77
  %15 = load i32, i32* %arrayidx17, align 4, !dbg !77
  %add18 = add nsw i32 %15, 2, !dbg !78
  %16 = load i32, i32* %i, align 4, !dbg !79
  %idxprom19 = sext i32 %16 to i64, !dbg !80
  %arrayidx20 = getelementptr inbounds [100 x i32], [100 x i32]* %b, i64 0, i64 %idxprom19, !dbg !80
  store i32 %add18, i32* %arrayidx20, align 4, !dbg !81
  br label %for.inc21, !dbg !82

for.inc21:                                        ; preds = %for.body5
  %17 = load i32, i32* %i, align 4, !dbg !83
  %inc22 = add nsw i32 %17, 1, !dbg !83
  store i32 %inc22, i32* %i, align 4, !dbg !83
  br label %for.cond3, !dbg !84, !llvm.loop !85

for.end23:                                        ; preds = %for.cond3
  store i32 0, i32* %i, align 4, !dbg !87
  br label %for.cond24, !dbg !89

for.cond24:                                       ; preds = %for.inc33, %for.end23
  %18 = load i32, i32* %i, align 4, !dbg !90
  %cmp25 = icmp slt i32 %18, 50, !dbg !92
  br i1 %cmp25, label %for.body26, label %for.end35, !dbg !93

for.body26:                                       ; preds = %for.cond24
  %19 = load i32, i32* %i, align 4, !dbg !94
  %idxprom27 = sext i32 %19 to i64, !dbg !96
  %arrayidx28 = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom27, !dbg !96
  %20 = load i32, i32* %arrayidx28, align 4, !dbg !96
  %add29 = add nsw i32 %20, 1, !dbg !97
  %21 = load i32, i32* %i, align 4, !dbg !98
  %mul = mul nsw i32 2, %21, !dbg !99
  %add30 = add nsw i32 %mul, 1, !dbg !100
  %idxprom31 = sext i32 %add30 to i64, !dbg !101
  %arrayidx32 = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom31, !dbg !101
  store i32 %add29, i32* %arrayidx32, align 4, !dbg !102
  br label %for.inc33, !dbg !103

for.inc33:                                        ; preds = %for.body26
  %22 = load i32, i32* %i, align 4, !dbg !104
  %inc34 = add nsw i32 %22, 1, !dbg !104
  store i32 %inc34, i32* %i, align 4, !dbg !104
  br label %for.cond24, !dbg !105, !llvm.loop !106

for.end35:                                        ; preds = %for.cond24
  store i32 0, i32* %i, align 4, !dbg !108
  br label %for.cond36, !dbg !110

for.cond36:                                       ; preds = %for.inc42, %for.end35
  %23 = load i32, i32* %i, align 4, !dbg !111
  %24 = load i32, i32* %len, align 4, !dbg !113
  %cmp37 = icmp slt i32 %23, %24, !dbg !114
  br i1 %cmp37, label %for.body38, label %for.end44, !dbg !115

for.body38:                                       ; preds = %for.cond36
  %25 = load i32, i32* %sum, align 4, !dbg !116
  %26 = load i32, i32* %i, align 4, !dbg !118
  %idxprom39 = sext i32 %26 to i64, !dbg !119
  %arrayidx40 = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom39, !dbg !119
  %27 = load i32, i32* %arrayidx40, align 4, !dbg !119
  %add41 = add nsw i32 %25, %27, !dbg !120
  store i32 %add41, i32* %sum, align 4, !dbg !121
  br label %for.inc42, !dbg !122

for.inc42:                                        ; preds = %for.body38
  %28 = load i32, i32* %i, align 4, !dbg !123
  %inc43 = add nsw i32 %28, 1, !dbg !123
  store i32 %inc43, i32* %i, align 4, !dbg !123
  br label %for.cond36, !dbg !124, !llvm.loop !125

for.end44:                                        ; preds = %for.cond36
  store i32 0, i32* %i, align 4, !dbg !127
  br label %for.cond45, !dbg !129

for.cond45:                                       ; preds = %for.inc50, %for.end44
  %29 = load i32, i32* %i, align 4, !dbg !130
  %30 = load i32, i32* %len, align 4, !dbg !132
  %cmp46 = icmp slt i32 %29, %30, !dbg !133
  br i1 %cmp46, label %for.body47, label %for.end52, !dbg !134

for.body47:                                       ; preds = %for.cond45
  %31 = load i32, i32* %i, align 4, !dbg !135
  %32 = load i32, i32* %i, align 4, !dbg !137
  %idxprom48 = sext i32 %32 to i64, !dbg !138
  %arrayidx49 = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom48, !dbg !138
  %33 = load i32, i32* %arrayidx49, align 4, !dbg !138
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i32 0, i32 0), i32 %31, i32 %33), !dbg !139
  br label %for.inc50, !dbg !140

for.inc50:                                        ; preds = %for.body47
  %34 = load i32, i32* %i, align 4, !dbg !141
  %inc51 = add nsw i32 %34, 1, !dbg !141
  store i32 %inc51, i32* %i, align 4, !dbg !141
  br label %for.cond45, !dbg !142, !llvm.loop !143

for.end52:                                        ; preds = %for.cond45
  ret i32 0, !dbg !145
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @printf(i8*, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 8.0.1 (tags/RELEASE_801/final)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, nameTableKind: None)
!1 = !DIFile(filename: "/home/raynard/discopop/work_tests/dac_test/test.c", directory: "/home/raynard/discopop/work_tests/dac_test/discopop")
!2 = !{}
!3 = !{i32 2, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"clang version 8.0.1 (tags/RELEASE_801/final)"}
!7 = distinct !DISubprogram(name: "main", scope: !8, file: !8, line: 5, type: !9, scopeLine: 6, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DIFile(filename: "test.c", directory: "/home/raynard/discopop/work_tests/dac_test")
!9 = !DISubroutineType(types: !10)
!10 = !{!11, !11, !12}
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!13 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!14 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!15 = !DILocalVariable(name: "argc", arg: 1, scope: !7, file: !8, line: 5, type: !11)
!16 = !DILocation(line: 5, column: 14, scope: !7)
!17 = !DILocalVariable(name: "argv", arg: 2, scope: !7, file: !8, line: 5, type: !12)
!18 = !DILocation(line: 5, column: 26, scope: !7)
!19 = !DILocalVariable(name: "i", scope: !7, file: !8, line: 8, type: !11)
!20 = !DILocation(line: 8, column: 9, scope: !7)
!21 = !DILocalVariable(name: "len", scope: !7, file: !8, line: 9, type: !11)
!22 = !DILocation(line: 9, column: 9, scope: !7)
!23 = !DILocalVariable(name: "a", scope: !7, file: !8, line: 10, type: !24)
!24 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 3200, elements: !25)
!25 = !{!26}
!26 = !DISubrange(count: 100)
!27 = !DILocation(line: 10, column: 9, scope: !7)
!28 = !DILocalVariable(name: "b", scope: !7, file: !8, line: 11, type: !24)
!29 = !DILocation(line: 11, column: 9, scope: !7)
!30 = !DILocalVariable(name: "sum", scope: !7, file: !8, line: 12, type: !11)
!31 = !DILocation(line: 12, column: 9, scope: !7)
!32 = !DILocation(line: 14, column: 11, scope: !33)
!33 = distinct !DILexicalBlock(scope: !7, file: !8, line: 14, column: 5)
!34 = !DILocation(line: 14, column: 10, scope: !33)
!35 = !DILocation(line: 14, column: 14, scope: !36)
!36 = distinct !DILexicalBlock(scope: !33, file: !8, line: 14, column: 5)
!37 = !DILocation(line: 14, column: 16, scope: !36)
!38 = !DILocation(line: 14, column: 15, scope: !36)
!39 = !DILocation(line: 14, column: 5, scope: !33)
!40 = !DILocation(line: 15, column: 14, scope: !41)
!41 = distinct !DILexicalBlock(scope: !36, file: !8, line: 14, column: 24)
!42 = !DILocation(line: 15, column: 11, scope: !41)
!43 = !DILocation(line: 15, column: 9, scope: !41)
!44 = !DILocation(line: 15, column: 13, scope: !41)
!45 = !DILocation(line: 16, column: 14, scope: !41)
!46 = !DILocation(line: 16, column: 15, scope: !41)
!47 = !DILocation(line: 16, column: 11, scope: !41)
!48 = !DILocation(line: 16, column: 9, scope: !41)
!49 = !DILocation(line: 16, column: 13, scope: !41)
!50 = !DILocation(line: 17, column: 5, scope: !41)
!51 = !DILocation(line: 14, column: 21, scope: !36)
!52 = !DILocation(line: 14, column: 5, scope: !36)
!53 = distinct !{!53, !39, !54}
!54 = !DILocation(line: 17, column: 5, scope: !33)
!55 = !DILocation(line: 20, column: 11, scope: !56)
!56 = distinct !DILexicalBlock(scope: !7, file: !8, line: 20, column: 5)
!57 = !DILocation(line: 20, column: 10, scope: !56)
!58 = !DILocation(line: 20, column: 14, scope: !59)
!59 = distinct !DILexicalBlock(scope: !56, file: !8, line: 20, column: 5)
!60 = !DILocation(line: 20, column: 16, scope: !59)
!61 = !DILocation(line: 20, column: 19, scope: !59)
!62 = !DILocation(line: 20, column: 15, scope: !59)
!63 = !DILocation(line: 20, column: 5, scope: !56)
!64 = !DILocation(line: 23, column: 18, scope: !65)
!65 = distinct !DILexicalBlock(scope: !59, file: !8, line: 20, column: 26)
!66 = !DILocation(line: 23, column: 16, scope: !65)
!67 = !DILocation(line: 23, column: 25, scope: !65)
!68 = !DILocation(line: 23, column: 23, scope: !65)
!69 = !DILocation(line: 23, column: 21, scope: !65)
!70 = !DILocation(line: 23, column: 27, scope: !65)
!71 = !DILocation(line: 23, column: 11, scope: !65)
!72 = !DILocation(line: 23, column: 12, scope: !65)
!73 = !DILocation(line: 23, column: 9, scope: !65)
!74 = !DILocation(line: 23, column: 15, scope: !65)
!75 = !DILocation(line: 25, column: 18, scope: !65)
!76 = !DILocation(line: 25, column: 19, scope: !65)
!77 = !DILocation(line: 25, column: 16, scope: !65)
!78 = !DILocation(line: 25, column: 23, scope: !65)
!79 = !DILocation(line: 25, column: 11, scope: !65)
!80 = !DILocation(line: 25, column: 9, scope: !65)
!81 = !DILocation(line: 25, column: 14, scope: !65)
!82 = !DILocation(line: 26, column: 5, scope: !65)
!83 = !DILocation(line: 20, column: 23, scope: !59)
!84 = !DILocation(line: 20, column: 5, scope: !59)
!85 = distinct !{!85, !63, !86}
!86 = !DILocation(line: 26, column: 5, scope: !56)
!87 = !DILocation(line: 28, column: 11, scope: !88)
!88 = distinct !DILexicalBlock(scope: !7, file: !8, line: 28, column: 5)
!89 = !DILocation(line: 28, column: 10, scope: !88)
!90 = !DILocation(line: 28, column: 14, scope: !91)
!91 = distinct !DILexicalBlock(scope: !88, file: !8, line: 28, column: 5)
!92 = !DILocation(line: 28, column: 15, scope: !91)
!93 = !DILocation(line: 28, column: 5, scope: !88)
!94 = !DILocation(line: 29, column: 20, scope: !95)
!95 = distinct !DILexicalBlock(scope: !91, file: !8, line: 28, column: 23)
!96 = !DILocation(line: 29, column: 18, scope: !95)
!97 = !DILocation(line: 29, column: 22, scope: !95)
!98 = !DILocation(line: 29, column: 13, scope: !95)
!99 = !DILocation(line: 29, column: 12, scope: !95)
!100 = !DILocation(line: 29, column: 14, scope: !95)
!101 = !DILocation(line: 29, column: 9, scope: !95)
!102 = !DILocation(line: 29, column: 17, scope: !95)
!103 = !DILocation(line: 30, column: 5, scope: !95)
!104 = !DILocation(line: 28, column: 20, scope: !91)
!105 = !DILocation(line: 28, column: 5, scope: !91)
!106 = distinct !{!106, !93, !107}
!107 = !DILocation(line: 30, column: 5, scope: !88)
!108 = !DILocation(line: 32, column: 11, scope: !109)
!109 = distinct !DILexicalBlock(scope: !7, file: !8, line: 32, column: 5)
!110 = !DILocation(line: 32, column: 10, scope: !109)
!111 = !DILocation(line: 32, column: 15, scope: !112)
!112 = distinct !DILexicalBlock(scope: !109, file: !8, line: 32, column: 5)
!113 = !DILocation(line: 32, column: 17, scope: !112)
!114 = !DILocation(line: 32, column: 16, scope: !112)
!115 = !DILocation(line: 32, column: 5, scope: !109)
!116 = !DILocation(line: 33, column: 15, scope: !117)
!117 = distinct !DILexicalBlock(scope: !112, file: !8, line: 32, column: 26)
!118 = !DILocation(line: 33, column: 23, scope: !117)
!119 = !DILocation(line: 33, column: 21, scope: !117)
!120 = !DILocation(line: 33, column: 19, scope: !117)
!121 = !DILocation(line: 33, column: 13, scope: !117)
!122 = !DILocation(line: 34, column: 5, scope: !117)
!123 = !DILocation(line: 32, column: 23, scope: !112)
!124 = !DILocation(line: 32, column: 5, scope: !112)
!125 = distinct !{!125, !115, !126}
!126 = !DILocation(line: 34, column: 5, scope: !109)
!127 = !DILocation(line: 36, column: 11, scope: !128)
!128 = distinct !DILexicalBlock(scope: !7, file: !8, line: 36, column: 5)
!129 = !DILocation(line: 36, column: 10, scope: !128)
!130 = !DILocation(line: 36, column: 14, scope: !131)
!131 = distinct !DILexicalBlock(scope: !128, file: !8, line: 36, column: 5)
!132 = !DILocation(line: 36, column: 16, scope: !131)
!133 = !DILocation(line: 36, column: 15, scope: !131)
!134 = !DILocation(line: 36, column: 5, scope: !128)
!135 = !DILocation(line: 37, column: 32, scope: !136)
!136 = distinct !DILexicalBlock(scope: !131, file: !8, line: 36, column: 24)
!137 = !DILocation(line: 37, column: 37, scope: !136)
!138 = !DILocation(line: 37, column: 35, scope: !136)
!139 = !DILocation(line: 37, column: 9, scope: !136)
!140 = !DILocation(line: 38, column: 5, scope: !136)
!141 = !DILocation(line: 36, column: 21, scope: !131)
!142 = !DILocation(line: 36, column: 5, scope: !131)
!143 = distinct !{!143, !134, !144}
!144 = !DILocation(line: 38, column: 5, scope: !128)
!145 = !DILocation(line: 40, column: 5, scope: !7)
