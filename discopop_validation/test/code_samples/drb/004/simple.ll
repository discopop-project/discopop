; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !7 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
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
  call void @llvm.dbg.declare(metadata i32* %len, metadata !22, metadata !DIExpression()), !dbg !23
  store i32 20, i32* %len, align 4, !dbg !23
  %0 = load i32, i32* %argc.addr, align 4, !dbg !24
  %cmp = icmp sgt i32 %0, 1, !dbg !26
  br i1 %cmp, label %if.then, label %if.end, !dbg !27

if.then:                                          ; preds = %entry
  %1 = load i8**, i8*** %argv.addr, align 8, !dbg !28
  %arrayidx = getelementptr inbounds i8*, i8** %1, i64 1, !dbg !28
  %2 = load i8*, i8** %arrayidx, align 8, !dbg !28
  %call = call i32 @atoi(i8* %2) #4, !dbg !29
  store i32 %call, i32* %len, align 4, !dbg !30
  br label %if.end, !dbg !31

if.end:                                           ; preds = %if.then, %entry
  %3 = load i32, i32* %len, align 4, !dbg !32
  %4 = zext i32 %3 to i64, !dbg !33
  %5 = load i32, i32* %len, align 4, !dbg !34
  %6 = zext i32 %5 to i64, !dbg !33
  %7 = call i8* @llvm.stacksave(), !dbg !33
  store i8* %7, i8** %saved_stack, align 8, !dbg !33
  %8 = mul nuw i64 %4, %6, !dbg !33
  %vla = alloca double, i64 %8, align 16, !dbg !33
  store i64 %4, i64* %__vla_expr0, align 8, !dbg !33
  store i64 %6, i64* %__vla_expr1, align 8, !dbg !33
  call void @llvm.dbg.declare(metadata i64* %__vla_expr0, metadata !35, metadata !DIExpression()), !dbg !37
  call void @llvm.dbg.declare(metadata i64* %__vla_expr1, metadata !38, metadata !DIExpression()), !dbg !37
  call void @llvm.dbg.declare(metadata double* %vla, metadata !39, metadata !DIExpression()), !dbg !45
  store i32 0, i32* %i, align 4, !dbg !46
  br label %for.cond, !dbg !48

for.cond:                                         ; preds = %for.inc8, %if.end
  %9 = load i32, i32* %i, align 4, !dbg !49
  %10 = load i32, i32* %len, align 4, !dbg !51
  %cmp1 = icmp slt i32 %9, %10, !dbg !52
  br i1 %cmp1, label %for.body, label %for.end10, !dbg !53

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %j, align 4, !dbg !54
  br label %for.cond2, !dbg !56

for.cond2:                                        ; preds = %for.inc, %for.body
  %11 = load i32, i32* %j, align 4, !dbg !57
  %12 = load i32, i32* %len, align 4, !dbg !59
  %cmp3 = icmp slt i32 %11, %12, !dbg !60
  br i1 %cmp3, label %for.body4, label %for.end, !dbg !61

for.body4:                                        ; preds = %for.cond2
  %13 = load i32, i32* %i, align 4, !dbg !62
  %idxprom = sext i32 %13 to i64, !dbg !63
  %14 = mul nsw i64 %idxprom, %6, !dbg !63
  %arrayidx5 = getelementptr inbounds double, double* %vla, i64 %14, !dbg !63
  %15 = load i32, i32* %j, align 4, !dbg !64
  %idxprom6 = sext i32 %15 to i64, !dbg !63
  %arrayidx7 = getelementptr inbounds double, double* %arrayidx5, i64 %idxprom6, !dbg !63
  store double 5.000000e-01, double* %arrayidx7, align 8, !dbg !65
  br label %for.inc, !dbg !63

for.inc:                                          ; preds = %for.body4
  %16 = load i32, i32* %j, align 4, !dbg !66
  %inc = add nsw i32 %16, 1, !dbg !66
  store i32 %inc, i32* %j, align 4, !dbg !66
  br label %for.cond2, !dbg !67, !llvm.loop !68

for.end:                                          ; preds = %for.cond2
  br label %for.inc8, !dbg !69

for.inc8:                                         ; preds = %for.end
  %17 = load i32, i32* %i, align 4, !dbg !70
  %inc9 = add nsw i32 %17, 1, !dbg !70
  store i32 %inc9, i32* %i, align 4, !dbg !70
  br label %for.cond, !dbg !71, !llvm.loop !72

for.end10:                                        ; preds = %for.cond
  store i32 0, i32* %i, align 4, !dbg !74
  br label %for.cond11, !dbg !76

for.cond11:                                       ; preds = %for.inc29, %for.end10
  %18 = load i32, i32* %i, align 4, !dbg !77
  %19 = load i32, i32* %len, align 4, !dbg !79
  %sub = sub nsw i32 %19, 1, !dbg !80
  %cmp12 = icmp slt i32 %18, %sub, !dbg !81
  br i1 %cmp12, label %for.body13, label %for.end31, !dbg !82

for.body13:                                       ; preds = %for.cond11
  store i32 0, i32* %j, align 4, !dbg !83
  br label %for.cond14, !dbg !86

for.cond14:                                       ; preds = %for.inc26, %for.body13
  %20 = load i32, i32* %j, align 4, !dbg !87
  %21 = load i32, i32* %len, align 4, !dbg !89
  %cmp15 = icmp slt i32 %20, %21, !dbg !90
  br i1 %cmp15, label %for.body16, label %for.end28, !dbg !91

for.body16:                                       ; preds = %for.cond14
  %22 = load i32, i32* %i, align 4, !dbg !92
  %add = add nsw i32 %22, 1, !dbg !94
  %idxprom17 = sext i32 %add to i64, !dbg !95
  %23 = mul nsw i64 %idxprom17, %6, !dbg !95
  %arrayidx18 = getelementptr inbounds double, double* %vla, i64 %23, !dbg !95
  %24 = load i32, i32* %j, align 4, !dbg !96
  %idxprom19 = sext i32 %24 to i64, !dbg !95
  %arrayidx20 = getelementptr inbounds double, double* %arrayidx18, i64 %idxprom19, !dbg !95
  %25 = load double, double* %arrayidx20, align 8, !dbg !95
  %26 = load i32, i32* %i, align 4, !dbg !97
  %idxprom21 = sext i32 %26 to i64, !dbg !98
  %27 = mul nsw i64 %idxprom21, %6, !dbg !98
  %arrayidx22 = getelementptr inbounds double, double* %vla, i64 %27, !dbg !98
  %28 = load i32, i32* %j, align 4, !dbg !99
  %idxprom23 = sext i32 %28 to i64, !dbg !98
  %arrayidx24 = getelementptr inbounds double, double* %arrayidx22, i64 %idxprom23, !dbg !98
  %29 = load double, double* %arrayidx24, align 8, !dbg !100
  %add25 = fadd double %29, %25, !dbg !100
  store double %add25, double* %arrayidx24, align 8, !dbg !100
  br label %for.inc26, !dbg !101

for.inc26:                                        ; preds = %for.body16
  %30 = load i32, i32* %j, align 4, !dbg !102
  %add27 = add nsw i32 %30, 1, !dbg !102
  store i32 %add27, i32* %j, align 4, !dbg !102
  br label %for.cond14, !dbg !103, !llvm.loop !104

for.end28:                                        ; preds = %for.cond14
  br label %for.inc29, !dbg !106

for.inc29:                                        ; preds = %for.end28
  %31 = load i32, i32* %i, align 4, !dbg !107
  %add30 = add nsw i32 %31, 1, !dbg !107
  store i32 %add30, i32* %i, align 4, !dbg !107
  br label %for.cond11, !dbg !108, !llvm.loop !109

for.end31:                                        ; preds = %for.cond11
  store i32 0, i32* %retval, align 4, !dbg !111
  %32 = load i8*, i8** %saved_stack, align 8, !dbg !112
  call void @llvm.stackrestore(i8* %32), !dbg !112
  %33 = load i32, i32* %retval, align 4, !dbg !112
  ret i32 %33, !dbg !112
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind readonly
declare dso_local i32 @atoi(i8*) #2

; Function Attrs: nounwind
declare i8* @llvm.stacksave() #3

; Function Attrs: nounwind
declare void @llvm.stackrestore(i8*) #3

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }
attributes #4 = { nounwind readonly }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/004")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"Ubuntu clang version 11.1.0-6"}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 53, type: !8, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10, !10, !11}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!13 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!14 = !DILocalVariable(name: "argc", arg: 1, scope: !7, file: !1, line: 53, type: !10)
!15 = !DILocation(line: 53, column: 14, scope: !7)
!16 = !DILocalVariable(name: "argv", arg: 2, scope: !7, file: !1, line: 53, type: !11)
!17 = !DILocation(line: 53, column: 25, scope: !7)
!18 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 55, type: !10)
!19 = !DILocation(line: 55, column: 7, scope: !7)
!20 = !DILocalVariable(name: "j", scope: !7, file: !1, line: 55, type: !10)
!21 = !DILocation(line: 55, column: 10, scope: !7)
!22 = !DILocalVariable(name: "len", scope: !7, file: !1, line: 56, type: !10)
!23 = !DILocation(line: 56, column: 7, scope: !7)
!24 = !DILocation(line: 58, column: 7, scope: !25)
!25 = distinct !DILexicalBlock(scope: !7, file: !1, line: 58, column: 7)
!26 = !DILocation(line: 58, column: 11, scope: !25)
!27 = !DILocation(line: 58, column: 7, scope: !7)
!28 = !DILocation(line: 59, column: 16, scope: !25)
!29 = !DILocation(line: 59, column: 11, scope: !25)
!30 = !DILocation(line: 59, column: 9, scope: !25)
!31 = !DILocation(line: 59, column: 5, scope: !25)
!32 = !DILocation(line: 61, column: 12, scope: !7)
!33 = !DILocation(line: 61, column: 3, scope: !7)
!34 = !DILocation(line: 61, column: 17, scope: !7)
!35 = !DILocalVariable(name: "__vla_expr0", scope: !7, type: !36, flags: DIFlagArtificial)
!36 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!37 = !DILocation(line: 0, scope: !7)
!38 = !DILocalVariable(name: "__vla_expr1", scope: !7, type: !36, flags: DIFlagArtificial)
!39 = !DILocalVariable(name: "a", scope: !7, file: !1, line: 61, type: !40)
!40 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, elements: !42)
!41 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!42 = !{!43, !44}
!43 = !DISubrange(count: !35)
!44 = !DISubrange(count: !38)
!45 = !DILocation(line: 61, column: 10, scope: !7)
!46 = !DILocation(line: 63, column: 9, scope: !47)
!47 = distinct !DILexicalBlock(scope: !7, file: !1, line: 63, column: 3)
!48 = !DILocation(line: 63, column: 8, scope: !47)
!49 = !DILocation(line: 63, column: 13, scope: !50)
!50 = distinct !DILexicalBlock(scope: !47, file: !1, line: 63, column: 3)
!51 = !DILocation(line: 63, column: 16, scope: !50)
!52 = !DILocation(line: 63, column: 14, scope: !50)
!53 = !DILocation(line: 63, column: 3, scope: !47)
!54 = !DILocation(line: 64, column: 11, scope: !55)
!55 = distinct !DILexicalBlock(scope: !50, file: !1, line: 64, column: 5)
!56 = !DILocation(line: 64, column: 10, scope: !55)
!57 = !DILocation(line: 64, column: 15, scope: !58)
!58 = distinct !DILexicalBlock(scope: !55, file: !1, line: 64, column: 5)
!59 = !DILocation(line: 64, column: 17, scope: !58)
!60 = !DILocation(line: 64, column: 16, scope: !58)
!61 = !DILocation(line: 64, column: 5, scope: !55)
!62 = !DILocation(line: 65, column: 9, scope: !58)
!63 = !DILocation(line: 65, column: 7, scope: !58)
!64 = !DILocation(line: 65, column: 12, scope: !58)
!65 = !DILocation(line: 65, column: 15, scope: !58)
!66 = !DILocation(line: 64, column: 23, scope: !58)
!67 = !DILocation(line: 64, column: 5, scope: !58)
!68 = distinct !{!68, !61, !69}
!69 = !DILocation(line: 65, column: 17, scope: !55)
!70 = !DILocation(line: 63, column: 22, scope: !50)
!71 = !DILocation(line: 63, column: 3, scope: !50)
!72 = distinct !{!72, !53, !73}
!73 = !DILocation(line: 65, column: 17, scope: !47)
!74 = !DILocation(line: 68, column: 10, scope: !75)
!75 = distinct !DILexicalBlock(scope: !7, file: !1, line: 68, column: 3)
!76 = !DILocation(line: 68, column: 8, scope: !75)
!77 = !DILocation(line: 68, column: 15, scope: !78)
!78 = distinct !DILexicalBlock(scope: !75, file: !1, line: 68, column: 3)
!79 = !DILocation(line: 68, column: 19, scope: !78)
!80 = !DILocation(line: 68, column: 23, scope: !78)
!81 = !DILocation(line: 68, column: 17, scope: !78)
!82 = !DILocation(line: 68, column: 3, scope: !75)
!83 = !DILocation(line: 69, column: 12, scope: !84)
!84 = distinct !DILexicalBlock(scope: !85, file: !1, line: 69, column: 5)
!85 = distinct !DILexicalBlock(scope: !78, file: !1, line: 68, column: 36)
!86 = !DILocation(line: 69, column: 10, scope: !84)
!87 = !DILocation(line: 69, column: 17, scope: !88)
!88 = distinct !DILexicalBlock(scope: !84, file: !1, line: 69, column: 5)
!89 = !DILocation(line: 69, column: 21, scope: !88)
!90 = !DILocation(line: 69, column: 19, scope: !88)
!91 = !DILocation(line: 69, column: 5, scope: !84)
!92 = !DILocation(line: 70, column: 20, scope: !93)
!93 = distinct !DILexicalBlock(scope: !88, file: !1, line: 69, column: 35)
!94 = !DILocation(line: 70, column: 22, scope: !93)
!95 = !DILocation(line: 70, column: 18, scope: !93)
!96 = !DILocation(line: 70, column: 27, scope: !93)
!97 = !DILocation(line: 70, column: 9, scope: !93)
!98 = !DILocation(line: 70, column: 7, scope: !93)
!99 = !DILocation(line: 70, column: 12, scope: !93)
!100 = !DILocation(line: 70, column: 15, scope: !93)
!101 = !DILocation(line: 71, column: 5, scope: !93)
!102 = !DILocation(line: 69, column: 29, scope: !88)
!103 = !DILocation(line: 69, column: 5, scope: !88)
!104 = distinct !{!104, !91, !105}
!105 = !DILocation(line: 71, column: 5, scope: !84)
!106 = !DILocation(line: 72, column: 3, scope: !85)
!107 = !DILocation(line: 68, column: 30, scope: !78)
!108 = !DILocation(line: 68, column: 3, scope: !78)
!109 = distinct !{!109, !82, !110}
!110 = !DILocation(line: 72, column: 3, scope: !75)
!111 = !DILocation(line: 73, column: 3, scope: !7)
!112 = !DILocation(line: 74, column: 1, scope: !7)
