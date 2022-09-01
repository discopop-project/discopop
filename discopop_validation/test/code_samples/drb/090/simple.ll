; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@main.tmp = internal global i32 0, align 4, !dbg !0
@.str = private unnamed_addr constant [19 x i8] c"a[50]=%d b[50]=%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !2 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %len = alloca i32, align 4
  %saved_stack = alloca i8*, align 8
  %__vla_expr0 = alloca i64, align 8
  %__vla_expr1 = alloca i64, align 8
  %tmp = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !17, metadata !DIExpression()), !dbg !18
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !19, metadata !DIExpression()), !dbg !20
  call void @llvm.dbg.declare(metadata i32* %i, metadata !21, metadata !DIExpression()), !dbg !22
  call void @llvm.dbg.declare(metadata i32* %len, metadata !23, metadata !DIExpression()), !dbg !24
  store i32 100, i32* %len, align 4, !dbg !24
  %0 = load i32, i32* %len, align 4, !dbg !25
  %1 = zext i32 %0 to i64, !dbg !26
  %2 = call i8* @llvm.stacksave(), !dbg !26
  store i8* %2, i8** %saved_stack, align 8, !dbg !26
  %vla = alloca i32, i64 %1, align 16, !dbg !26
  store i64 %1, i64* %__vla_expr0, align 8, !dbg !26
  call void @llvm.dbg.declare(metadata i64* %__vla_expr0, metadata !27, metadata !DIExpression()), !dbg !29
  call void @llvm.dbg.declare(metadata i32* %vla, metadata !30, metadata !DIExpression()), !dbg !34
  %3 = load i32, i32* %len, align 4, !dbg !35
  %4 = zext i32 %3 to i64, !dbg !26
  %vla1 = alloca i32, i64 %4, align 16, !dbg !26
  store i64 %4, i64* %__vla_expr1, align 8, !dbg !26
  call void @llvm.dbg.declare(metadata i64* %__vla_expr1, metadata !36, metadata !DIExpression()), !dbg !29
  call void @llvm.dbg.declare(metadata i32* %vla1, metadata !37, metadata !DIExpression()), !dbg !41
  store i32 0, i32* %i, align 4, !dbg !42
  br label %for.cond, !dbg !44

for.cond:                                         ; preds = %for.inc, %entry
  %5 = load i32, i32* %i, align 4, !dbg !45
  %6 = load i32, i32* %len, align 4, !dbg !47
  %cmp = icmp slt i32 %5, %6, !dbg !48
  br i1 %cmp, label %for.body, label %for.end, !dbg !49

for.body:                                         ; preds = %for.cond
  %7 = load i32, i32* %i, align 4, !dbg !50
  %8 = load i32, i32* %i, align 4, !dbg !52
  %idxprom = sext i32 %8 to i64, !dbg !53
  %arrayidx = getelementptr inbounds i32, i32* %vla, i64 %idxprom, !dbg !53
  store i32 %7, i32* %arrayidx, align 4, !dbg !54
  %9 = load i32, i32* %i, align 4, !dbg !55
  %10 = load i32, i32* %i, align 4, !dbg !56
  %idxprom2 = sext i32 %10 to i64, !dbg !57
  %arrayidx3 = getelementptr inbounds i32, i32* %vla1, i64 %idxprom2, !dbg !57
  store i32 %9, i32* %arrayidx3, align 4, !dbg !58
  br label %for.inc, !dbg !59

for.inc:                                          ; preds = %for.body
  %11 = load i32, i32* %i, align 4, !dbg !60
  %inc = add nsw i32 %11, 1, !dbg !60
  store i32 %inc, i32* %i, align 4, !dbg !60
  br label %for.cond, !dbg !61, !llvm.loop !62

for.end:                                          ; preds = %for.cond
  store i32 0, i32* %i, align 4, !dbg !64
  br label %for.cond4, !dbg !67

for.cond4:                                        ; preds = %for.inc11, %for.end
  %12 = load i32, i32* %i, align 4, !dbg !68
  %13 = load i32, i32* %len, align 4, !dbg !70
  %cmp5 = icmp slt i32 %12, %13, !dbg !71
  br i1 %cmp5, label %for.body6, label %for.end13, !dbg !72

for.body6:                                        ; preds = %for.cond4
  %14 = load i32, i32* %i, align 4, !dbg !73
  %idxprom7 = sext i32 %14 to i64, !dbg !75
  %arrayidx8 = getelementptr inbounds i32, i32* %vla, i64 %idxprom7, !dbg !75
  %15 = load i32, i32* %arrayidx8, align 4, !dbg !75
  %16 = load i32, i32* %i, align 4, !dbg !76
  %add = add nsw i32 %15, %16, !dbg !77
  store i32 %add, i32* @main.tmp, align 4, !dbg !78
  %17 = load i32, i32* @main.tmp, align 4, !dbg !79
  %18 = load i32, i32* %i, align 4, !dbg !80
  %idxprom9 = sext i32 %18 to i64, !dbg !81
  %arrayidx10 = getelementptr inbounds i32, i32* %vla, i64 %idxprom9, !dbg !81
  store i32 %17, i32* %arrayidx10, align 4, !dbg !82
  br label %for.inc11, !dbg !83

for.inc11:                                        ; preds = %for.body6
  %19 = load i32, i32* %i, align 4, !dbg !84
  %inc12 = add nsw i32 %19, 1, !dbg !84
  store i32 %inc12, i32* %i, align 4, !dbg !84
  br label %for.cond4, !dbg !85, !llvm.loop !86

for.end13:                                        ; preds = %for.cond4
  call void @llvm.dbg.declare(metadata i32* %tmp, metadata !88, metadata !DIExpression()), !dbg !90
  store i32 0, i32* %i, align 4, !dbg !91
  br label %for.cond14, !dbg !93

for.cond14:                                       ; preds = %for.inc22, %for.end13
  %20 = load i32, i32* %i, align 4, !dbg !94
  %21 = load i32, i32* %len, align 4, !dbg !96
  %cmp15 = icmp slt i32 %20, %21, !dbg !97
  br i1 %cmp15, label %for.body16, label %for.end24, !dbg !98

for.body16:                                       ; preds = %for.cond14
  %22 = load i32, i32* %i, align 4, !dbg !99
  %idxprom17 = sext i32 %22 to i64, !dbg !101
  %arrayidx18 = getelementptr inbounds i32, i32* %vla1, i64 %idxprom17, !dbg !101
  %23 = load i32, i32* %arrayidx18, align 4, !dbg !101
  %24 = load i32, i32* %i, align 4, !dbg !102
  %add19 = add nsw i32 %23, %24, !dbg !103
  store i32 %add19, i32* %tmp, align 4, !dbg !104
  %25 = load i32, i32* %tmp, align 4, !dbg !105
  %26 = load i32, i32* %i, align 4, !dbg !106
  %idxprom20 = sext i32 %26 to i64, !dbg !107
  %arrayidx21 = getelementptr inbounds i32, i32* %vla1, i64 %idxprom20, !dbg !107
  store i32 %25, i32* %arrayidx21, align 4, !dbg !108
  br label %for.inc22, !dbg !109

for.inc22:                                        ; preds = %for.body16
  %27 = load i32, i32* %i, align 4, !dbg !110
  %inc23 = add nsw i32 %27, 1, !dbg !110
  store i32 %inc23, i32* %i, align 4, !dbg !110
  br label %for.cond14, !dbg !111, !llvm.loop !112

for.end24:                                        ; preds = %for.cond14
  %arrayidx25 = getelementptr inbounds i32, i32* %vla, i64 50, !dbg !114
  %28 = load i32, i32* %arrayidx25, align 8, !dbg !114
  %arrayidx26 = getelementptr inbounds i32, i32* %vla1, i64 50, !dbg !115
  %29 = load i32, i32* %arrayidx26, align 8, !dbg !115
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str, i64 0, i64 0), i32 %28, i32 %29), !dbg !116
  store i32 0, i32* %retval, align 4, !dbg !117
  %30 = load i8*, i8** %saved_stack, align 8, !dbg !118
  call void @llvm.stackrestore(i8* %30), !dbg !118
  %31 = load i32, i32* %retval, align 4, !dbg !118
  ret i32 %31, !dbg !118
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

!llvm.dbg.cu = !{!10}
!llvm.module.flags = !{!13, !14, !15}
!llvm.ident = !{!16}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "tmp", scope: !2, file: !3, line: 69, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 58, type: !4, scopeLine: 59, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !10, retainedNodes: !11)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/090")
!4 = !DISubroutineType(types: !5)
!5 = !{!6, !6, !7}
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 64)
!9 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!10 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !11, globals: !12, splitDebugInlining: false, nameTableKind: None)
!11 = !{}
!12 = !{!0}
!13 = !{i32 7, !"Dwarf Version", i32 4}
!14 = !{i32 2, !"Debug Info Version", i32 3}
!15 = !{i32 1, !"wchar_size", i32 4}
!16 = !{!"Ubuntu clang version 11.1.0-6"}
!17 = !DILocalVariable(name: "argc", arg: 1, scope: !2, file: !3, line: 58, type: !6)
!18 = !DILocation(line: 58, column: 14, scope: !2)
!19 = !DILocalVariable(name: "argv", arg: 2, scope: !2, file: !3, line: 58, type: !7)
!20 = !DILocation(line: 58, column: 26, scope: !2)
!21 = !DILocalVariable(name: "i", scope: !2, file: !3, line: 60, type: !6)
!22 = !DILocation(line: 60, column: 7, scope: !2)
!23 = !DILocalVariable(name: "len", scope: !2, file: !3, line: 61, type: !6)
!24 = !DILocation(line: 61, column: 7, scope: !2)
!25 = !DILocation(line: 62, column: 9, scope: !2)
!26 = !DILocation(line: 62, column: 3, scope: !2)
!27 = !DILocalVariable(name: "__vla_expr0", scope: !2, type: !28, flags: DIFlagArtificial)
!28 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!29 = !DILocation(line: 0, scope: !2)
!30 = !DILocalVariable(name: "a", scope: !2, file: !3, line: 62, type: !31)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, elements: !32)
!32 = !{!33}
!33 = !DISubrange(count: !27)
!34 = !DILocation(line: 62, column: 7, scope: !2)
!35 = !DILocation(line: 62, column: 17, scope: !2)
!36 = !DILocalVariable(name: "__vla_expr1", scope: !2, type: !28, flags: DIFlagArtificial)
!37 = !DILocalVariable(name: "b", scope: !2, file: !3, line: 62, type: !38)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, elements: !39)
!39 = !{!40}
!40 = !DISubrange(count: !36)
!41 = !DILocation(line: 62, column: 15, scope: !2)
!42 = !DILocation(line: 64, column: 9, scope: !43)
!43 = distinct !DILexicalBlock(scope: !2, file: !3, line: 64, column: 3)
!44 = !DILocation(line: 64, column: 8, scope: !43)
!45 = !DILocation(line: 64, column: 12, scope: !46)
!46 = distinct !DILexicalBlock(scope: !43, file: !3, line: 64, column: 3)
!47 = !DILocation(line: 64, column: 14, scope: !46)
!48 = !DILocation(line: 64, column: 13, scope: !46)
!49 = !DILocation(line: 64, column: 3, scope: !43)
!50 = !DILocation(line: 65, column: 11, scope: !51)
!51 = distinct !DILexicalBlock(scope: !46, file: !3, line: 65, column: 3)
!52 = !DILocation(line: 65, column: 8, scope: !51)
!53 = !DILocation(line: 65, column: 6, scope: !51)
!54 = !DILocation(line: 65, column: 10, scope: !51)
!55 = !DILocation(line: 65, column: 19, scope: !51)
!56 = !DILocation(line: 65, column: 16, scope: !51)
!57 = !DILocation(line: 65, column: 14, scope: !51)
!58 = !DILocation(line: 65, column: 18, scope: !51)
!59 = !DILocation(line: 65, column: 21, scope: !51)
!60 = !DILocation(line: 64, column: 19, scope: !46)
!61 = !DILocation(line: 64, column: 3, scope: !46)
!62 = distinct !{!62, !49, !63}
!63 = !DILocation(line: 65, column: 21, scope: !43)
!64 = !DILocation(line: 71, column: 11, scope: !65)
!65 = distinct !DILexicalBlock(scope: !66, file: !3, line: 71, column: 5)
!66 = distinct !DILexicalBlock(scope: !2, file: !3, line: 68, column: 3)
!67 = !DILocation(line: 71, column: 10, scope: !65)
!68 = !DILocation(line: 71, column: 14, scope: !69)
!69 = distinct !DILexicalBlock(scope: !65, file: !3, line: 71, column: 5)
!70 = !DILocation(line: 71, column: 16, scope: !69)
!71 = !DILocation(line: 71, column: 15, scope: !69)
!72 = !DILocation(line: 71, column: 5, scope: !65)
!73 = !DILocation(line: 73, column: 15, scope: !74)
!74 = distinct !DILexicalBlock(scope: !69, file: !3, line: 72, column: 5)
!75 = !DILocation(line: 73, column: 13, scope: !74)
!76 = !DILocation(line: 73, column: 18, scope: !74)
!77 = !DILocation(line: 73, column: 17, scope: !74)
!78 = !DILocation(line: 73, column: 11, scope: !74)
!79 = !DILocation(line: 74, column: 14, scope: !74)
!80 = !DILocation(line: 74, column: 9, scope: !74)
!81 = !DILocation(line: 74, column: 7, scope: !74)
!82 = !DILocation(line: 74, column: 12, scope: !74)
!83 = !DILocation(line: 75, column: 5, scope: !74)
!84 = !DILocation(line: 71, column: 21, scope: !69)
!85 = !DILocation(line: 71, column: 5, scope: !69)
!86 = distinct !{!86, !72, !87}
!87 = !DILocation(line: 75, column: 5, scope: !65)
!88 = !DILocalVariable(name: "tmp", scope: !89, file: !3, line: 81, type: !6)
!89 = distinct !DILexicalBlock(scope: !2, file: !3, line: 80, column: 3)
!90 = !DILocation(line: 81, column: 9, scope: !89)
!91 = !DILocation(line: 83, column: 11, scope: !92)
!92 = distinct !DILexicalBlock(scope: !89, file: !3, line: 83, column: 5)
!93 = !DILocation(line: 83, column: 10, scope: !92)
!94 = !DILocation(line: 83, column: 14, scope: !95)
!95 = distinct !DILexicalBlock(scope: !92, file: !3, line: 83, column: 5)
!96 = !DILocation(line: 83, column: 16, scope: !95)
!97 = !DILocation(line: 83, column: 15, scope: !95)
!98 = !DILocation(line: 83, column: 5, scope: !92)
!99 = !DILocation(line: 85, column: 15, scope: !100)
!100 = distinct !DILexicalBlock(scope: !95, file: !3, line: 84, column: 5)
!101 = !DILocation(line: 85, column: 13, scope: !100)
!102 = !DILocation(line: 85, column: 18, scope: !100)
!103 = !DILocation(line: 85, column: 17, scope: !100)
!104 = !DILocation(line: 85, column: 11, scope: !100)
!105 = !DILocation(line: 86, column: 14, scope: !100)
!106 = !DILocation(line: 86, column: 9, scope: !100)
!107 = !DILocation(line: 86, column: 7, scope: !100)
!108 = !DILocation(line: 86, column: 12, scope: !100)
!109 = !DILocation(line: 87, column: 5, scope: !100)
!110 = !DILocation(line: 83, column: 21, scope: !95)
!111 = !DILocation(line: 83, column: 5, scope: !95)
!112 = distinct !{!112, !98, !113}
!113 = !DILocation(line: 87, column: 5, scope: !92)
!114 = !DILocation(line: 90, column: 33, scope: !2)
!115 = !DILocation(line: 90, column: 40, scope: !2)
!116 = !DILocation(line: 90, column: 3, scope: !2)
!117 = !DILocation(line: 92, column: 3, scope: !2)
!118 = !DILocation(line: 93, column: 1, scope: !2)
