; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [16 x i8] c"b[500][500]=%f\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !7 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %b = alloca [1000 x [1000 x double]], align 16
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !14, metadata !DIExpression()), !dbg !15
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !16, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.declare(metadata i32* %i, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32* %j, metadata !20, metadata !DIExpression()), !dbg !21
  call void @llvm.dbg.declare(metadata i32* %n, metadata !22, metadata !DIExpression()), !dbg !23
  store i32 1000, i32* %n, align 4, !dbg !23
  call void @llvm.dbg.declare(metadata i32* %m, metadata !24, metadata !DIExpression()), !dbg !25
  store i32 1000, i32* %m, align 4, !dbg !25
  call void @llvm.dbg.declare(metadata [1000 x [1000 x double]]* %b, metadata !26, metadata !DIExpression()), !dbg !31
  store i32 0, i32* %i, align 4, !dbg !32
  br label %for.cond, !dbg !34

for.cond:                                         ; preds = %for.inc6, %entry
  %0 = load i32, i32* %i, align 4, !dbg !35
  %1 = load i32, i32* %n, align 4, !dbg !37
  %cmp = icmp slt i32 %0, %1, !dbg !38
  br i1 %cmp, label %for.body, label %for.end8, !dbg !39

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %j, align 4, !dbg !40
  br label %for.cond1, !dbg !42

for.cond1:                                        ; preds = %for.inc, %for.body
  %2 = load i32, i32* %j, align 4, !dbg !43
  %3 = load i32, i32* %m, align 4, !dbg !45
  %cmp2 = icmp slt i32 %2, %3, !dbg !46
  br i1 %cmp2, label %for.body3, label %for.end, !dbg !47

for.body3:                                        ; preds = %for.cond1
  %4 = load i32, i32* %i, align 4, !dbg !48
  %idxprom = sext i32 %4 to i64, !dbg !49
  %arrayidx = getelementptr inbounds [1000 x [1000 x double]], [1000 x [1000 x double]]* %b, i64 0, i64 %idxprom, !dbg !49
  %5 = load i32, i32* %j, align 4, !dbg !50
  %idxprom4 = sext i32 %5 to i64, !dbg !49
  %arrayidx5 = getelementptr inbounds [1000 x double], [1000 x double]* %arrayidx, i64 0, i64 %idxprom4, !dbg !49
  store double 5.000000e-01, double* %arrayidx5, align 8, !dbg !51
  br label %for.inc, !dbg !49

for.inc:                                          ; preds = %for.body3
  %6 = load i32, i32* %j, align 4, !dbg !52
  %inc = add nsw i32 %6, 1, !dbg !52
  store i32 %inc, i32* %j, align 4, !dbg !52
  br label %for.cond1, !dbg !53, !llvm.loop !54

for.end:                                          ; preds = %for.cond1
  br label %for.inc6, !dbg !55

for.inc6:                                         ; preds = %for.end
  %7 = load i32, i32* %i, align 4, !dbg !56
  %inc7 = add nsw i32 %7, 1, !dbg !56
  store i32 %inc7, i32* %i, align 4, !dbg !56
  br label %for.cond, !dbg !57, !llvm.loop !58

for.end8:                                         ; preds = %for.cond
  store i32 1, i32* %i, align 4, !dbg !60
  br label %for.cond9, !dbg !62

for.cond9:                                        ; preds = %for.inc27, %for.end8
  %8 = load i32, i32* %i, align 4, !dbg !63
  %9 = load i32, i32* %n, align 4, !dbg !65
  %cmp10 = icmp slt i32 %8, %9, !dbg !66
  br i1 %cmp10, label %for.body11, label %for.end29, !dbg !67

for.body11:                                       ; preds = %for.cond9
  store i32 1, i32* %j, align 4, !dbg !68
  br label %for.cond12, !dbg !70

for.cond12:                                       ; preds = %for.inc24, %for.body11
  %10 = load i32, i32* %j, align 4, !dbg !71
  %11 = load i32, i32* %m, align 4, !dbg !73
  %cmp13 = icmp slt i32 %10, %11, !dbg !74
  br i1 %cmp13, label %for.body14, label %for.end26, !dbg !75

for.body14:                                       ; preds = %for.cond12
  %12 = load i32, i32* %i, align 4, !dbg !76
  %sub = sub nsw i32 %12, 1, !dbg !77
  %idxprom15 = sext i32 %sub to i64, !dbg !78
  %arrayidx16 = getelementptr inbounds [1000 x [1000 x double]], [1000 x [1000 x double]]* %b, i64 0, i64 %idxprom15, !dbg !78
  %13 = load i32, i32* %j, align 4, !dbg !79
  %sub17 = sub nsw i32 %13, 1, !dbg !80
  %idxprom18 = sext i32 %sub17 to i64, !dbg !78
  %arrayidx19 = getelementptr inbounds [1000 x double], [1000 x double]* %arrayidx16, i64 0, i64 %idxprom18, !dbg !78
  %14 = load double, double* %arrayidx19, align 8, !dbg !78
  %15 = load i32, i32* %i, align 4, !dbg !81
  %idxprom20 = sext i32 %15 to i64, !dbg !82
  %arrayidx21 = getelementptr inbounds [1000 x [1000 x double]], [1000 x [1000 x double]]* %b, i64 0, i64 %idxprom20, !dbg !82
  %16 = load i32, i32* %j, align 4, !dbg !83
  %idxprom22 = sext i32 %16 to i64, !dbg !82
  %arrayidx23 = getelementptr inbounds [1000 x double], [1000 x double]* %arrayidx21, i64 0, i64 %idxprom22, !dbg !82
  store double %14, double* %arrayidx23, align 8, !dbg !84
  br label %for.inc24, !dbg !82

for.inc24:                                        ; preds = %for.body14
  %17 = load i32, i32* %j, align 4, !dbg !85
  %inc25 = add nsw i32 %17, 1, !dbg !85
  store i32 %inc25, i32* %j, align 4, !dbg !85
  br label %for.cond12, !dbg !86, !llvm.loop !87

for.end26:                                        ; preds = %for.cond12
  br label %for.inc27, !dbg !88

for.inc27:                                        ; preds = %for.end26
  %18 = load i32, i32* %i, align 4, !dbg !89
  %inc28 = add nsw i32 %18, 1, !dbg !89
  store i32 %inc28, i32* %i, align 4, !dbg !89
  br label %for.cond9, !dbg !90, !llvm.loop !91

for.end29:                                        ; preds = %for.cond9
  %arrayidx30 = getelementptr inbounds [1000 x [1000 x double]], [1000 x [1000 x double]]* %b, i64 0, i64 500, !dbg !93
  %arrayidx31 = getelementptr inbounds [1000 x double], [1000 x double]* %arrayidx30, i64 0, i64 500, !dbg !93
  %19 = load double, double* %arrayidx31, align 16, !dbg !93
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i64 0, i64 0), double %19), !dbg !94
  ret i32 0, !dbg !95
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @printf(i8*, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/031")
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
!17 = !DILocation(line: 53, column: 26, scope: !7)
!18 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 55, type: !10)
!19 = !DILocation(line: 55, column: 7, scope: !7)
!20 = !DILocalVariable(name: "j", scope: !7, file: !1, line: 55, type: !10)
!21 = !DILocation(line: 55, column: 9, scope: !7)
!22 = !DILocalVariable(name: "n", scope: !7, file: !1, line: 56, type: !10)
!23 = !DILocation(line: 56, column: 7, scope: !7)
!24 = !DILocalVariable(name: "m", scope: !7, file: !1, line: 56, type: !10)
!25 = !DILocation(line: 56, column: 15, scope: !7)
!26 = !DILocalVariable(name: "b", scope: !7, file: !1, line: 57, type: !27)
!27 = !DICompositeType(tag: DW_TAG_array_type, baseType: !28, size: 64000000, elements: !29)
!28 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!29 = !{!30, !30}
!30 = !DISubrange(count: 1000)
!31 = !DILocation(line: 57, column: 10, scope: !7)
!32 = !DILocation(line: 59, column: 9, scope: !33)
!33 = distinct !DILexicalBlock(scope: !7, file: !1, line: 59, column: 3)
!34 = !DILocation(line: 59, column: 8, scope: !33)
!35 = !DILocation(line: 59, column: 13, scope: !36)
!36 = distinct !DILexicalBlock(scope: !33, file: !1, line: 59, column: 3)
!37 = !DILocation(line: 59, column: 15, scope: !36)
!38 = !DILocation(line: 59, column: 14, scope: !36)
!39 = !DILocation(line: 59, column: 3, scope: !33)
!40 = !DILocation(line: 60, column: 11, scope: !41)
!41 = distinct !DILexicalBlock(scope: !36, file: !1, line: 60, column: 5)
!42 = !DILocation(line: 60, column: 10, scope: !41)
!43 = !DILocation(line: 60, column: 15, scope: !44)
!44 = distinct !DILexicalBlock(scope: !41, file: !1, line: 60, column: 5)
!45 = !DILocation(line: 60, column: 17, scope: !44)
!46 = !DILocation(line: 60, column: 16, scope: !44)
!47 = !DILocation(line: 60, column: 5, scope: !41)
!48 = !DILocation(line: 61, column: 9, scope: !44)
!49 = !DILocation(line: 61, column: 7, scope: !44)
!50 = !DILocation(line: 61, column: 12, scope: !44)
!51 = !DILocation(line: 61, column: 15, scope: !44)
!52 = !DILocation(line: 60, column: 21, scope: !44)
!53 = !DILocation(line: 60, column: 5, scope: !44)
!54 = distinct !{!54, !47, !55}
!55 = !DILocation(line: 61, column: 17, scope: !41)
!56 = !DILocation(line: 59, column: 19, scope: !36)
!57 = !DILocation(line: 59, column: 3, scope: !36)
!58 = distinct !{!58, !39, !59}
!59 = !DILocation(line: 61, column: 17, scope: !33)
!60 = !DILocation(line: 64, column: 9, scope: !61)
!61 = distinct !DILexicalBlock(scope: !7, file: !1, line: 64, column: 3)
!62 = !DILocation(line: 64, column: 8, scope: !61)
!63 = !DILocation(line: 64, column: 12, scope: !64)
!64 = distinct !DILexicalBlock(scope: !61, file: !1, line: 64, column: 3)
!65 = !DILocation(line: 64, column: 14, scope: !64)
!66 = !DILocation(line: 64, column: 13, scope: !64)
!67 = !DILocation(line: 64, column: 3, scope: !61)
!68 = !DILocation(line: 65, column: 11, scope: !69)
!69 = distinct !DILexicalBlock(scope: !64, file: !1, line: 65, column: 5)
!70 = !DILocation(line: 65, column: 10, scope: !69)
!71 = !DILocation(line: 65, column: 14, scope: !72)
!72 = distinct !DILexicalBlock(scope: !69, file: !1, line: 65, column: 5)
!73 = !DILocation(line: 65, column: 16, scope: !72)
!74 = !DILocation(line: 65, column: 15, scope: !72)
!75 = !DILocation(line: 65, column: 5, scope: !69)
!76 = !DILocation(line: 66, column: 17, scope: !72)
!77 = !DILocation(line: 66, column: 18, scope: !72)
!78 = !DILocation(line: 66, column: 15, scope: !72)
!79 = !DILocation(line: 66, column: 22, scope: !72)
!80 = !DILocation(line: 66, column: 23, scope: !72)
!81 = !DILocation(line: 66, column: 9, scope: !72)
!82 = !DILocation(line: 66, column: 7, scope: !72)
!83 = !DILocation(line: 66, column: 12, scope: !72)
!84 = !DILocation(line: 66, column: 14, scope: !72)
!85 = !DILocation(line: 65, column: 19, scope: !72)
!86 = !DILocation(line: 65, column: 5, scope: !72)
!87 = distinct !{!87, !75, !88}
!88 = !DILocation(line: 66, column: 25, scope: !69)
!89 = !DILocation(line: 64, column: 17, scope: !64)
!90 = !DILocation(line: 64, column: 3, scope: !64)
!91 = distinct !{!91, !67, !92}
!92 = !DILocation(line: 66, column: 25, scope: !61)
!93 = !DILocation(line: 68, column: 30, scope: !7)
!94 = !DILocation(line: 68, column: 3, scope: !7)
!95 = !DILocation(line: 69, column: 3, scope: !7)
