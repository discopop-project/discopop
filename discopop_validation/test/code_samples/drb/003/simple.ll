; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [14 x i8] c"a[10][10]=%f\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !7 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %len = alloca i32, align 4
  %a = alloca [20 x [20 x double]], align 16
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !14, metadata !DIExpression()), !dbg !15
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !16, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.declare(metadata i32* %i, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32* %j, metadata !20, metadata !DIExpression()), !dbg !21
  call void @llvm.dbg.declare(metadata i32* %len, metadata !22, metadata !DIExpression()), !dbg !23
  store i32 20, i32* %len, align 4, !dbg !23
  call void @llvm.dbg.declare(metadata [20 x [20 x double]]* %a, metadata !24, metadata !DIExpression()), !dbg !29
  store i32 0, i32* %i, align 4, !dbg !30
  br label %for.cond, !dbg !32

for.cond:                                         ; preds = %for.inc6, %entry
  %0 = load i32, i32* %i, align 4, !dbg !33
  %1 = load i32, i32* %len, align 4, !dbg !35
  %cmp = icmp slt i32 %0, %1, !dbg !36
  br i1 %cmp, label %for.body, label %for.end8, !dbg !37

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %j, align 4, !dbg !38
  br label %for.cond1, !dbg !40

for.cond1:                                        ; preds = %for.inc, %for.body
  %2 = load i32, i32* %j, align 4, !dbg !41
  %3 = load i32, i32* %len, align 4, !dbg !43
  %cmp2 = icmp slt i32 %2, %3, !dbg !44
  br i1 %cmp2, label %for.body3, label %for.end, !dbg !45

for.body3:                                        ; preds = %for.cond1
  %4 = load i32, i32* %i, align 4, !dbg !46
  %idxprom = sext i32 %4 to i64, !dbg !47
  %arrayidx = getelementptr inbounds [20 x [20 x double]], [20 x [20 x double]]* %a, i64 0, i64 %idxprom, !dbg !47
  %5 = load i32, i32* %j, align 4, !dbg !48
  %idxprom4 = sext i32 %5 to i64, !dbg !47
  %arrayidx5 = getelementptr inbounds [20 x double], [20 x double]* %arrayidx, i64 0, i64 %idxprom4, !dbg !47
  store double 5.000000e-01, double* %arrayidx5, align 8, !dbg !49
  br label %for.inc, !dbg !47

for.inc:                                          ; preds = %for.body3
  %6 = load i32, i32* %j, align 4, !dbg !50
  %inc = add nsw i32 %6, 1, !dbg !50
  store i32 %inc, i32* %j, align 4, !dbg !50
  br label %for.cond1, !dbg !51, !llvm.loop !52

for.end:                                          ; preds = %for.cond1
  br label %for.inc6, !dbg !53

for.inc6:                                         ; preds = %for.end
  %7 = load i32, i32* %i, align 4, !dbg !54
  %inc7 = add nsw i32 %7, 1, !dbg !54
  store i32 %inc7, i32* %i, align 4, !dbg !54
  br label %for.cond, !dbg !55, !llvm.loop !56

for.end8:                                         ; preds = %for.cond
  store i32 0, i32* %i, align 4, !dbg !58
  br label %for.cond9, !dbg !60

for.cond9:                                        ; preds = %for.inc27, %for.end8
  %8 = load i32, i32* %i, align 4, !dbg !61
  %9 = load i32, i32* %len, align 4, !dbg !63
  %sub = sub nsw i32 %9, 1, !dbg !64
  %cmp10 = icmp slt i32 %8, %sub, !dbg !65
  br i1 %cmp10, label %for.body11, label %for.end29, !dbg !66

for.body11:                                       ; preds = %for.cond9
  store i32 0, i32* %j, align 4, !dbg !67
  br label %for.cond12, !dbg !70

for.cond12:                                       ; preds = %for.inc24, %for.body11
  %10 = load i32, i32* %j, align 4, !dbg !71
  %11 = load i32, i32* %len, align 4, !dbg !73
  %cmp13 = icmp slt i32 %10, %11, !dbg !74
  br i1 %cmp13, label %for.body14, label %for.end26, !dbg !75

for.body14:                                       ; preds = %for.cond12
  %12 = load i32, i32* %i, align 4, !dbg !76
  %add = add nsw i32 %12, 1, !dbg !78
  %idxprom15 = sext i32 %add to i64, !dbg !79
  %arrayidx16 = getelementptr inbounds [20 x [20 x double]], [20 x [20 x double]]* %a, i64 0, i64 %idxprom15, !dbg !79
  %13 = load i32, i32* %j, align 4, !dbg !80
  %idxprom17 = sext i32 %13 to i64, !dbg !79
  %arrayidx18 = getelementptr inbounds [20 x double], [20 x double]* %arrayidx16, i64 0, i64 %idxprom17, !dbg !79
  %14 = load double, double* %arrayidx18, align 8, !dbg !79
  %15 = load i32, i32* %i, align 4, !dbg !81
  %idxprom19 = sext i32 %15 to i64, !dbg !82
  %arrayidx20 = getelementptr inbounds [20 x [20 x double]], [20 x [20 x double]]* %a, i64 0, i64 %idxprom19, !dbg !82
  %16 = load i32, i32* %j, align 4, !dbg !83
  %idxprom21 = sext i32 %16 to i64, !dbg !82
  %arrayidx22 = getelementptr inbounds [20 x double], [20 x double]* %arrayidx20, i64 0, i64 %idxprom21, !dbg !82
  %17 = load double, double* %arrayidx22, align 8, !dbg !84
  %add23 = fadd double %17, %14, !dbg !84
  store double %add23, double* %arrayidx22, align 8, !dbg !84
  br label %for.inc24, !dbg !85

for.inc24:                                        ; preds = %for.body14
  %18 = load i32, i32* %j, align 4, !dbg !86
  %add25 = add nsw i32 %18, 1, !dbg !86
  store i32 %add25, i32* %j, align 4, !dbg !86
  br label %for.cond12, !dbg !87, !llvm.loop !88

for.end26:                                        ; preds = %for.cond12
  br label %for.inc27, !dbg !90

for.inc27:                                        ; preds = %for.end26
  %19 = load i32, i32* %i, align 4, !dbg !91
  %add28 = add nsw i32 %19, 1, !dbg !91
  store i32 %add28, i32* %i, align 4, !dbg !91
  br label %for.cond9, !dbg !92, !llvm.loop !93

for.end29:                                        ; preds = %for.cond9
  %arrayidx30 = getelementptr inbounds [20 x [20 x double]], [20 x [20 x double]]* %a, i64 0, i64 10, !dbg !95
  %arrayidx31 = getelementptr inbounds [20 x double], [20 x double]* %arrayidx30, i64 0, i64 10, !dbg !95
  %20 = load double, double* %arrayidx31, align 16, !dbg !95
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str, i64 0, i64 0), double %20), !dbg !96
  ret i32 0, !dbg !97
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
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/003")
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
!24 = !DILocalVariable(name: "a", scope: !7, file: !1, line: 58, type: !25)
!25 = !DICompositeType(tag: DW_TAG_array_type, baseType: !26, size: 25600, elements: !27)
!26 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!27 = !{!28, !28}
!28 = !DISubrange(count: 20)
!29 = !DILocation(line: 58, column: 10, scope: !7)
!30 = !DILocation(line: 60, column: 9, scope: !31)
!31 = distinct !DILexicalBlock(scope: !7, file: !1, line: 60, column: 3)
!32 = !DILocation(line: 60, column: 8, scope: !31)
!33 = !DILocation(line: 60, column: 13, scope: !34)
!34 = distinct !DILexicalBlock(scope: !31, file: !1, line: 60, column: 3)
!35 = !DILocation(line: 60, column: 16, scope: !34)
!36 = !DILocation(line: 60, column: 14, scope: !34)
!37 = !DILocation(line: 60, column: 3, scope: !31)
!38 = !DILocation(line: 61, column: 11, scope: !39)
!39 = distinct !DILexicalBlock(scope: !34, file: !1, line: 61, column: 5)
!40 = !DILocation(line: 61, column: 10, scope: !39)
!41 = !DILocation(line: 61, column: 15, scope: !42)
!42 = distinct !DILexicalBlock(scope: !39, file: !1, line: 61, column: 5)
!43 = !DILocation(line: 61, column: 17, scope: !42)
!44 = !DILocation(line: 61, column: 16, scope: !42)
!45 = !DILocation(line: 61, column: 5, scope: !39)
!46 = !DILocation(line: 62, column: 9, scope: !42)
!47 = !DILocation(line: 62, column: 7, scope: !42)
!48 = !DILocation(line: 62, column: 12, scope: !42)
!49 = !DILocation(line: 62, column: 15, scope: !42)
!50 = !DILocation(line: 61, column: 23, scope: !42)
!51 = !DILocation(line: 61, column: 5, scope: !42)
!52 = distinct !{!52, !45, !53}
!53 = !DILocation(line: 62, column: 17, scope: !39)
!54 = !DILocation(line: 60, column: 22, scope: !34)
!55 = !DILocation(line: 60, column: 3, scope: !34)
!56 = distinct !{!56, !37, !57}
!57 = !DILocation(line: 62, column: 17, scope: !31)
!58 = !DILocation(line: 65, column: 10, scope: !59)
!59 = distinct !DILexicalBlock(scope: !7, file: !1, line: 65, column: 3)
!60 = !DILocation(line: 65, column: 8, scope: !59)
!61 = !DILocation(line: 65, column: 15, scope: !62)
!62 = distinct !DILexicalBlock(scope: !59, file: !1, line: 65, column: 3)
!63 = !DILocation(line: 65, column: 19, scope: !62)
!64 = !DILocation(line: 65, column: 23, scope: !62)
!65 = !DILocation(line: 65, column: 17, scope: !62)
!66 = !DILocation(line: 65, column: 3, scope: !59)
!67 = !DILocation(line: 66, column: 12, scope: !68)
!68 = distinct !DILexicalBlock(scope: !69, file: !1, line: 66, column: 5)
!69 = distinct !DILexicalBlock(scope: !62, file: !1, line: 65, column: 36)
!70 = !DILocation(line: 66, column: 10, scope: !68)
!71 = !DILocation(line: 66, column: 17, scope: !72)
!72 = distinct !DILexicalBlock(scope: !68, file: !1, line: 66, column: 5)
!73 = !DILocation(line: 66, column: 21, scope: !72)
!74 = !DILocation(line: 66, column: 19, scope: !72)
!75 = !DILocation(line: 66, column: 5, scope: !68)
!76 = !DILocation(line: 67, column: 20, scope: !77)
!77 = distinct !DILexicalBlock(scope: !72, file: !1, line: 66, column: 35)
!78 = !DILocation(line: 67, column: 22, scope: !77)
!79 = !DILocation(line: 67, column: 18, scope: !77)
!80 = !DILocation(line: 67, column: 27, scope: !77)
!81 = !DILocation(line: 67, column: 9, scope: !77)
!82 = !DILocation(line: 67, column: 7, scope: !77)
!83 = !DILocation(line: 67, column: 12, scope: !77)
!84 = !DILocation(line: 67, column: 15, scope: !77)
!85 = !DILocation(line: 68, column: 5, scope: !77)
!86 = !DILocation(line: 66, column: 29, scope: !72)
!87 = !DILocation(line: 66, column: 5, scope: !72)
!88 = distinct !{!88, !75, !89}
!89 = !DILocation(line: 68, column: 5, scope: !68)
!90 = !DILocation(line: 69, column: 3, scope: !69)
!91 = !DILocation(line: 65, column: 30, scope: !62)
!92 = !DILocation(line: 65, column: 3, scope: !62)
!93 = distinct !{!93, !66, !94}
!94 = !DILocation(line: 69, column: 3, scope: !59)
!95 = !DILocation(line: 71, column: 29, scope: !7)
!96 = !DILocation(line: 71, column: 3, scope: !7)
!97 = !DILocation(line: 72, column: 3, scope: !7)
