; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@b = dso_local global [16 x i32] zeroinitializer, align 16, !dbg !0
@c = dso_local global [16 x i32] zeroinitializer, align 16, !dbg !9
@temp = dso_local global [16 x i32] zeroinitializer, align 16, !dbg !14
@a = dso_local global i32 0, align 4, !dbg !6
@.str = private unnamed_addr constant [19 x i8] c"index: %d val: %d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !20 {
entry:
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %i5 = alloca i32, align 4
  %i9 = alloca i32, align 4
  %i22 = alloca i32, align 4
  %val = alloca i32, align 4
  %i35 = alloca i32, align 4
  %i44 = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !23, metadata !DIExpression()), !dbg !25
  store i32 0, i32* %i, align 4, !dbg !25
  br label %for.cond, !dbg !26

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !27
  %cmp = icmp slt i32 %0, 16, !dbg !29
  br i1 %cmp, label %for.body, label %for.end, !dbg !30

for.body:                                         ; preds = %for.cond
  %1 = load i32, i32* %i, align 4, !dbg !31
  %idxprom = sext i32 %1 to i64, !dbg !33
  %arrayidx = getelementptr inbounds [16 x i32], [16 x i32]* @b, i64 0, i64 %idxprom, !dbg !33
  store i32 0, i32* %arrayidx, align 4, !dbg !34
  %2 = load i32, i32* %i, align 4, !dbg !35
  %idxprom1 = sext i32 %2 to i64, !dbg !36
  %arrayidx2 = getelementptr inbounds [16 x i32], [16 x i32]* @c, i64 0, i64 %idxprom1, !dbg !36
  store i32 2, i32* %arrayidx2, align 4, !dbg !37
  %3 = load i32, i32* %i, align 4, !dbg !38
  %idxprom3 = sext i32 %3 to i64, !dbg !39
  %arrayidx4 = getelementptr inbounds [16 x i32], [16 x i32]* @temp, i64 0, i64 %idxprom3, !dbg !39
  store i32 0, i32* %arrayidx4, align 4, !dbg !40
  br label %for.inc, !dbg !41

for.inc:                                          ; preds = %for.body
  %4 = load i32, i32* %i, align 4, !dbg !42
  %inc = add nsw i32 %4, 1, !dbg !42
  store i32 %inc, i32* %i, align 4, !dbg !42
  br label %for.cond, !dbg !43, !llvm.loop !44

for.end:                                          ; preds = %for.cond
  store i32 2, i32* @a, align 4, !dbg !46
  call void @llvm.dbg.declare(metadata i32* %i5, metadata !47, metadata !DIExpression()), !dbg !50
  store i32 0, i32* %i5, align 4, !dbg !50
  br label %for.cond6, !dbg !51

for.cond6:                                        ; preds = %for.inc32, %for.end
  %5 = load i32, i32* %i5, align 4, !dbg !52
  %cmp7 = icmp slt i32 %5, 100, !dbg !54
  br i1 %cmp7, label %for.body8, label %for.end34, !dbg !55

for.body8:                                        ; preds = %for.cond6
  call void @llvm.dbg.declare(metadata i32* %i9, metadata !56, metadata !DIExpression()), !dbg !59
  store i32 0, i32* %i9, align 4, !dbg !59
  br label %for.cond10, !dbg !60

for.cond10:                                       ; preds = %for.inc19, %for.body8
  %6 = load i32, i32* %i9, align 4, !dbg !61
  %cmp11 = icmp slt i32 %6, 16, !dbg !63
  br i1 %cmp11, label %for.body12, label %for.end21, !dbg !64

for.body12:                                       ; preds = %for.cond10
  %7 = load i32, i32* %i9, align 4, !dbg !65
  %idxprom13 = sext i32 %7 to i64, !dbg !67
  %arrayidx14 = getelementptr inbounds [16 x i32], [16 x i32]* @b, i64 0, i64 %idxprom13, !dbg !67
  %8 = load i32, i32* %arrayidx14, align 4, !dbg !67
  %9 = load i32, i32* %i9, align 4, !dbg !68
  %idxprom15 = sext i32 %9 to i64, !dbg !69
  %arrayidx16 = getelementptr inbounds [16 x i32], [16 x i32]* @c, i64 0, i64 %idxprom15, !dbg !69
  %10 = load i32, i32* %arrayidx16, align 4, !dbg !69
  %add = add nsw i32 %8, %10, !dbg !70
  %11 = load i32, i32* %i9, align 4, !dbg !71
  %idxprom17 = sext i32 %11 to i64, !dbg !72
  %arrayidx18 = getelementptr inbounds [16 x i32], [16 x i32]* @temp, i64 0, i64 %idxprom17, !dbg !72
  store i32 %add, i32* %arrayidx18, align 4, !dbg !73
  br label %for.inc19, !dbg !74

for.inc19:                                        ; preds = %for.body12
  %12 = load i32, i32* %i9, align 4, !dbg !75
  %inc20 = add nsw i32 %12, 1, !dbg !75
  store i32 %inc20, i32* %i9, align 4, !dbg !75
  br label %for.cond10, !dbg !76, !llvm.loop !77

for.end21:                                        ; preds = %for.cond10
  call void @llvm.dbg.declare(metadata i32* %i22, metadata !79, metadata !DIExpression()), !dbg !81
  store i32 15, i32* %i22, align 4, !dbg !81
  br label %for.cond23, !dbg !82

for.cond23:                                       ; preds = %for.inc30, %for.end21
  %13 = load i32, i32* %i22, align 4, !dbg !83
  %cmp24 = icmp sge i32 %13, 0, !dbg !85
  br i1 %cmp24, label %for.body25, label %for.end31, !dbg !86

for.body25:                                       ; preds = %for.cond23
  %14 = load i32, i32* %i22, align 4, !dbg !87
  %idxprom26 = sext i32 %14 to i64, !dbg !89
  %arrayidx27 = getelementptr inbounds [16 x i32], [16 x i32]* @temp, i64 0, i64 %idxprom26, !dbg !89
  %15 = load i32, i32* %arrayidx27, align 4, !dbg !89
  %16 = load i32, i32* @a, align 4, !dbg !90
  %mul = mul nsw i32 %15, %16, !dbg !91
  %17 = load i32, i32* %i22, align 4, !dbg !92
  %idxprom28 = sext i32 %17 to i64, !dbg !93
  %arrayidx29 = getelementptr inbounds [16 x i32], [16 x i32]* @b, i64 0, i64 %idxprom28, !dbg !93
  store i32 %mul, i32* %arrayidx29, align 4, !dbg !94
  br label %for.inc30, !dbg !95

for.inc30:                                        ; preds = %for.body25
  %18 = load i32, i32* %i22, align 4, !dbg !96
  %dec = add nsw i32 %18, -1, !dbg !96
  store i32 %dec, i32* %i22, align 4, !dbg !96
  br label %for.cond23, !dbg !97, !llvm.loop !98

for.end31:                                        ; preds = %for.cond23
  br label %for.inc32, !dbg !100

for.inc32:                                        ; preds = %for.end31
  %19 = load i32, i32* %i5, align 4, !dbg !101
  %inc33 = add nsw i32 %19, 1, !dbg !101
  store i32 %inc33, i32* %i5, align 4, !dbg !101
  br label %for.cond6, !dbg !102, !llvm.loop !103

for.end34:                                        ; preds = %for.cond6
  call void @llvm.dbg.declare(metadata i32* %val, metadata !105, metadata !DIExpression()), !dbg !106
  store i32 0, i32* %val, align 4, !dbg !106
  call void @llvm.dbg.declare(metadata i32* %i35, metadata !107, metadata !DIExpression()), !dbg !109
  store i32 0, i32* %i35, align 4, !dbg !109
  br label %for.cond36, !dbg !110

for.cond36:                                       ; preds = %for.inc41, %for.end34
  %20 = load i32, i32* %i35, align 4, !dbg !111
  %cmp37 = icmp slt i32 %20, 100, !dbg !113
  br i1 %cmp37, label %for.body38, label %for.end43, !dbg !114

for.body38:                                       ; preds = %for.cond36
  %21 = load i32, i32* %val, align 4, !dbg !115
  %add39 = add nsw i32 %21, 2, !dbg !117
  store i32 %add39, i32* %val, align 4, !dbg !118
  %22 = load i32, i32* %val, align 4, !dbg !119
  %mul40 = mul nsw i32 %22, 2, !dbg !120
  store i32 %mul40, i32* %val, align 4, !dbg !121
  br label %for.inc41, !dbg !122

for.inc41:                                        ; preds = %for.body38
  %23 = load i32, i32* %i35, align 4, !dbg !123
  %inc42 = add nsw i32 %23, 1, !dbg !123
  store i32 %inc42, i32* %i35, align 4, !dbg !123
  br label %for.cond36, !dbg !124, !llvm.loop !125

for.end43:                                        ; preds = %for.cond36
  call void @llvm.dbg.declare(metadata i32* %i44, metadata !127, metadata !DIExpression()), !dbg !129
  store i32 0, i32* %i44, align 4, !dbg !129
  br label %for.cond45, !dbg !130

for.cond45:                                       ; preds = %for.inc53, %for.end43
  %24 = load i32, i32* %i44, align 4, !dbg !131
  %cmp46 = icmp slt i32 %24, 16, !dbg !133
  br i1 %cmp46, label %for.body47, label %for.end55, !dbg !134

for.body47:                                       ; preds = %for.cond45
  %25 = load i32, i32* %i44, align 4, !dbg !135
  %idxprom48 = sext i32 %25 to i64, !dbg !138
  %arrayidx49 = getelementptr inbounds [16 x i32], [16 x i32]* @b, i64 0, i64 %idxprom48, !dbg !138
  %26 = load i32, i32* %arrayidx49, align 4, !dbg !138
  %27 = load i32, i32* %val, align 4, !dbg !139
  %cmp50 = icmp ne i32 %26, %27, !dbg !140
  br i1 %cmp50, label %if.then, label %if.end, !dbg !141

if.then:                                          ; preds = %for.body47
  %28 = load i32, i32* %i44, align 4, !dbg !142
  %29 = load i32, i32* %i44, align 4, !dbg !144
  %idxprom51 = sext i32 %29 to i64, !dbg !145
  %arrayidx52 = getelementptr inbounds [16 x i32], [16 x i32]* @b, i64 0, i64 %idxprom51, !dbg !145
  %30 = load i32, i32* %arrayidx52, align 4, !dbg !145
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str, i64 0, i64 0), i32 %28, i32 %30), !dbg !146
  br label %if.end, !dbg !147

if.end:                                           ; preds = %if.then, %for.body47
  br label %for.inc53, !dbg !148

for.inc53:                                        ; preds = %if.end
  %31 = load i32, i32* %i44, align 4, !dbg !149
  %inc54 = add nsw i32 %31, 1, !dbg !149
  store i32 %inc54, i32* %i44, align 4, !dbg !149
  br label %for.cond45, !dbg !150, !llvm.loop !151

for.end55:                                        ; preds = %for.cond45
  ret i32 0, !dbg !153
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @printf(i8*, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!16, !17, !18}
!llvm.ident = !{!19}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !3, line: 24, type: !11, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/160")
!4 = !{}
!5 = !{!6, !0, !9, !14}
!6 = !DIGlobalVariableExpression(var: !7, expr: !DIExpression())
!7 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 23, type: !8, isLocal: false, isDefinition: true)
!8 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!9 = !DIGlobalVariableExpression(var: !10, expr: !DIExpression())
!10 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !3, line: 25, type: !11, isLocal: false, isDefinition: true)
!11 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 512, elements: !12)
!12 = !{!13}
!13 = !DISubrange(count: 16)
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(name: "temp", scope: !2, file: !3, line: 26, type: !11, isLocal: false, isDefinition: true)
!16 = !{i32 7, !"Dwarf Version", i32 4}
!17 = !{i32 2, !"Debug Info Version", i32 3}
!18 = !{i32 1, !"wchar_size", i32 4}
!19 = !{!"Ubuntu clang version 11.1.0-6"}
!20 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 28, type: !21, scopeLine: 28, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!21 = !DISubroutineType(types: !22)
!22 = !{!8}
!23 = !DILocalVariable(name: "i", scope: !24, file: !3, line: 29, type: !8)
!24 = distinct !DILexicalBlock(scope: !20, file: !3, line: 29, column: 3)
!25 = !DILocation(line: 29, column: 11, scope: !24)
!26 = !DILocation(line: 29, column: 7, scope: !24)
!27 = !DILocation(line: 29, column: 16, scope: !28)
!28 = distinct !DILexicalBlock(scope: !24, file: !3, line: 29, column: 3)
!29 = !DILocation(line: 29, column: 17, scope: !28)
!30 = !DILocation(line: 29, column: 3, scope: !24)
!31 = !DILocation(line: 30, column: 7, scope: !32)
!32 = distinct !DILexicalBlock(scope: !28, file: !3, line: 29, column: 25)
!33 = !DILocation(line: 30, column: 5, scope: !32)
!34 = !DILocation(line: 30, column: 9, scope: !32)
!35 = !DILocation(line: 31, column: 7, scope: !32)
!36 = !DILocation(line: 31, column: 5, scope: !32)
!37 = !DILocation(line: 31, column: 9, scope: !32)
!38 = !DILocation(line: 32, column: 10, scope: !32)
!39 = !DILocation(line: 32, column: 5, scope: !32)
!40 = !DILocation(line: 32, column: 12, scope: !32)
!41 = !DILocation(line: 33, column: 3, scope: !32)
!42 = !DILocation(line: 29, column: 22, scope: !28)
!43 = !DILocation(line: 29, column: 3, scope: !28)
!44 = distinct !{!44, !30, !45}
!45 = !DILocation(line: 33, column: 3, scope: !24)
!46 = !DILocation(line: 34, column: 4, scope: !20)
!47 = !DILocalVariable(name: "i", scope: !48, file: !3, line: 39, type: !8)
!48 = distinct !DILexicalBlock(scope: !49, file: !3, line: 39, column: 5)
!49 = distinct !DILexicalBlock(scope: !20, file: !3, line: 37, column: 3)
!50 = !DILocation(line: 39, column: 13, scope: !48)
!51 = !DILocation(line: 39, column: 9, scope: !48)
!52 = !DILocation(line: 39, column: 18, scope: !53)
!53 = distinct !DILexicalBlock(scope: !48, file: !3, line: 39, column: 5)
!54 = !DILocation(line: 39, column: 19, scope: !53)
!55 = !DILocation(line: 39, column: 5, scope: !48)
!56 = !DILocalVariable(name: "i", scope: !57, file: !3, line: 41, type: !8)
!57 = distinct !DILexicalBlock(scope: !58, file: !3, line: 41, column: 7)
!58 = distinct !DILexicalBlock(scope: !53, file: !3, line: 39, column: 27)
!59 = !DILocation(line: 41, column: 15, scope: !57)
!60 = !DILocation(line: 41, column: 11, scope: !57)
!61 = !DILocation(line: 41, column: 20, scope: !62)
!62 = distinct !DILexicalBlock(scope: !57, file: !3, line: 41, column: 7)
!63 = !DILocation(line: 41, column: 21, scope: !62)
!64 = !DILocation(line: 41, column: 7, scope: !57)
!65 = !DILocation(line: 42, column: 21, scope: !66)
!66 = distinct !DILexicalBlock(scope: !62, file: !3, line: 41, column: 29)
!67 = !DILocation(line: 42, column: 19, scope: !66)
!68 = !DILocation(line: 42, column: 28, scope: !66)
!69 = !DILocation(line: 42, column: 26, scope: !66)
!70 = !DILocation(line: 42, column: 24, scope: !66)
!71 = !DILocation(line: 42, column: 14, scope: !66)
!72 = !DILocation(line: 42, column: 9, scope: !66)
!73 = !DILocation(line: 42, column: 17, scope: !66)
!74 = !DILocation(line: 43, column: 7, scope: !66)
!75 = !DILocation(line: 41, column: 26, scope: !62)
!76 = !DILocation(line: 41, column: 7, scope: !62)
!77 = distinct !{!77, !64, !78}
!78 = !DILocation(line: 43, column: 7, scope: !57)
!79 = !DILocalVariable(name: "i", scope: !80, file: !3, line: 46, type: !8)
!80 = distinct !DILexicalBlock(scope: !58, file: !3, line: 46, column: 7)
!81 = !DILocation(line: 46, column: 15, scope: !80)
!82 = !DILocation(line: 46, column: 11, scope: !80)
!83 = !DILocation(line: 46, column: 22, scope: !84)
!84 = distinct !DILexicalBlock(scope: !80, file: !3, line: 46, column: 7)
!85 = !DILocation(line: 46, column: 23, scope: !84)
!86 = !DILocation(line: 46, column: 7, scope: !80)
!87 = !DILocation(line: 47, column: 21, scope: !88)
!88 = distinct !DILexicalBlock(scope: !84, file: !3, line: 46, column: 32)
!89 = !DILocation(line: 47, column: 16, scope: !88)
!90 = !DILocation(line: 47, column: 26, scope: !88)
!91 = !DILocation(line: 47, column: 24, scope: !88)
!92 = !DILocation(line: 47, column: 11, scope: !88)
!93 = !DILocation(line: 47, column: 9, scope: !88)
!94 = !DILocation(line: 47, column: 14, scope: !88)
!95 = !DILocation(line: 48, column: 7, scope: !88)
!96 = !DILocation(line: 46, column: 29, scope: !84)
!97 = !DILocation(line: 46, column: 7, scope: !84)
!98 = distinct !{!98, !86, !99}
!99 = !DILocation(line: 48, column: 7, scope: !80)
!100 = !DILocation(line: 49, column: 5, scope: !58)
!101 = !DILocation(line: 39, column: 24, scope: !53)
!102 = !DILocation(line: 39, column: 5, scope: !53)
!103 = distinct !{!103, !55, !104}
!104 = !DILocation(line: 49, column: 5, scope: !48)
!105 = !DILocalVariable(name: "val", scope: !20, file: !3, line: 52, type: !8)
!106 = !DILocation(line: 52, column: 7, scope: !20)
!107 = !DILocalVariable(name: "i", scope: !108, file: !3, line: 54, type: !8)
!108 = distinct !DILexicalBlock(scope: !20, file: !3, line: 54, column: 3)
!109 = !DILocation(line: 54, column: 11, scope: !108)
!110 = !DILocation(line: 54, column: 7, scope: !108)
!111 = !DILocation(line: 54, column: 16, scope: !112)
!112 = distinct !DILexicalBlock(scope: !108, file: !3, line: 54, column: 3)
!113 = !DILocation(line: 54, column: 17, scope: !112)
!114 = !DILocation(line: 54, column: 3, scope: !108)
!115 = !DILocation(line: 55, column: 11, scope: !116)
!116 = distinct !DILexicalBlock(scope: !112, file: !3, line: 54, column: 25)
!117 = !DILocation(line: 55, column: 15, scope: !116)
!118 = !DILocation(line: 55, column: 9, scope: !116)
!119 = !DILocation(line: 56, column: 11, scope: !116)
!120 = !DILocation(line: 56, column: 15, scope: !116)
!121 = !DILocation(line: 56, column: 9, scope: !116)
!122 = !DILocation(line: 57, column: 3, scope: !116)
!123 = !DILocation(line: 54, column: 22, scope: !112)
!124 = !DILocation(line: 54, column: 3, scope: !112)
!125 = distinct !{!125, !114, !126}
!126 = !DILocation(line: 57, column: 3, scope: !108)
!127 = !DILocalVariable(name: "i", scope: !128, file: !3, line: 59, type: !8)
!128 = distinct !DILexicalBlock(scope: !20, file: !3, line: 59, column: 3)
!129 = !DILocation(line: 59, column: 11, scope: !128)
!130 = !DILocation(line: 59, column: 7, scope: !128)
!131 = !DILocation(line: 59, column: 16, scope: !132)
!132 = distinct !DILexicalBlock(scope: !128, file: !3, line: 59, column: 3)
!133 = !DILocation(line: 59, column: 17, scope: !132)
!134 = !DILocation(line: 59, column: 3, scope: !128)
!135 = !DILocation(line: 60, column: 10, scope: !136)
!136 = distinct !DILexicalBlock(scope: !137, file: !3, line: 60, column: 8)
!137 = distinct !DILexicalBlock(scope: !132, file: !3, line: 59, column: 25)
!138 = !DILocation(line: 60, column: 8, scope: !136)
!139 = !DILocation(line: 60, column: 14, scope: !136)
!140 = !DILocation(line: 60, column: 12, scope: !136)
!141 = !DILocation(line: 60, column: 8, scope: !137)
!142 = !DILocation(line: 61, column: 36, scope: !143)
!143 = distinct !DILexicalBlock(scope: !136, file: !3, line: 60, column: 18)
!144 = !DILocation(line: 61, column: 41, scope: !143)
!145 = !DILocation(line: 61, column: 39, scope: !143)
!146 = !DILocation(line: 61, column: 7, scope: !143)
!147 = !DILocation(line: 62, column: 5, scope: !143)
!148 = !DILocation(line: 63, column: 3, scope: !137)
!149 = !DILocation(line: 59, column: 22, scope: !132)
!150 = !DILocation(line: 59, column: 3, scope: !132)
!151 = distinct !{!151, !134, !152}
!152 = !DILocation(line: 63, column: 3, scope: !128)
!153 = !DILocation(line: 65, column: 3, scope: !20)
