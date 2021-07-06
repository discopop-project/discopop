; ModuleID = '/home/raynard/discopop/work_tests/micro/test.c'
source_filename = "/home/raynard/discopop/work_tests/micro/test.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

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
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !15, metadata !DIExpression()), !dbg !16
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !17, metadata !DIExpression()), !dbg !18
  call void @llvm.dbg.declare(metadata i32* %i, metadata !19, metadata !DIExpression()), !dbg !20
  call void @llvm.dbg.declare(metadata i32* %j, metadata !21, metadata !DIExpression()), !dbg !22
  call void @llvm.dbg.declare(metadata i32* %n, metadata !23, metadata !DIExpression()), !dbg !24
  store i32 1000, i32* %n, align 4, !dbg !24
  call void @llvm.dbg.declare(metadata i32* %m, metadata !25, metadata !DIExpression()), !dbg !26
  store i32 1000, i32* %m, align 4, !dbg !26
  call void @llvm.dbg.declare(metadata [1000 x [1000 x double]]* %b, metadata !27, metadata !DIExpression()), !dbg !32
  store i32 0, i32* %i, align 4, !dbg !33
  br label %for.cond, !dbg !35

for.cond:                                         ; preds = %for.inc6, %entry
  %0 = load i32, i32* %i, align 4, !dbg !36
  %1 = load i32, i32* %n, align 4, !dbg !38
  %cmp = icmp slt i32 %0, %1, !dbg !39
  br i1 %cmp, label %for.body, label %for.end8, !dbg !40

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %j, align 4, !dbg !41
  br label %for.cond1, !dbg !43

for.cond1:                                        ; preds = %for.inc, %for.body
  %2 = load i32, i32* %j, align 4, !dbg !44
  %3 = load i32, i32* %m, align 4, !dbg !46
  %cmp2 = icmp slt i32 %2, %3, !dbg !47
  br i1 %cmp2, label %for.body3, label %for.end, !dbg !48

for.body3:                                        ; preds = %for.cond1
  %4 = load i32, i32* %i, align 4, !dbg !49
  %idxprom = sext i32 %4 to i64, !dbg !50
  %arrayidx = getelementptr inbounds [1000 x [1000 x double]], [1000 x [1000 x double]]* %b, i64 0, i64 %idxprom, !dbg !50
  %5 = load i32, i32* %j, align 4, !dbg !51
  %idxprom4 = sext i32 %5 to i64, !dbg !50
  %arrayidx5 = getelementptr inbounds [1000 x double], [1000 x double]* %arrayidx, i64 0, i64 %idxprom4, !dbg !50
  store double 5.000000e-01, double* %arrayidx5, align 8, !dbg !52
  br label %for.inc, !dbg !50

for.inc:                                          ; preds = %for.body3
  %6 = load i32, i32* %j, align 4, !dbg !53
  %inc = add nsw i32 %6, 1, !dbg !53
  store i32 %inc, i32* %j, align 4, !dbg !53
  br label %for.cond1, !dbg !54, !llvm.loop !55

for.end:                                          ; preds = %for.cond1
  br label %for.inc6, !dbg !56

for.inc6:                                         ; preds = %for.end
  %7 = load i32, i32* %i, align 4, !dbg !57
  %inc7 = add nsw i32 %7, 1, !dbg !57
  store i32 %inc7, i32* %i, align 4, !dbg !57
  br label %for.cond, !dbg !58, !llvm.loop !59

for.end8:                                         ; preds = %for.cond
  store i32 1, i32* %i, align 4, !dbg !61
  br label %for.cond9, !dbg !63

for.cond9:                                        ; preds = %for.inc27, %for.end8
  %8 = load i32, i32* %i, align 4, !dbg !64
  %9 = load i32, i32* %n, align 4, !dbg !66
  %cmp10 = icmp slt i32 %8, %9, !dbg !67
  br i1 %cmp10, label %for.body11, label %for.end29, !dbg !68

for.body11:                                       ; preds = %for.cond9
  store i32 1, i32* %j, align 4, !dbg !69
  br label %for.cond12, !dbg !71

for.cond12:                                       ; preds = %for.inc24, %for.body11
  %10 = load i32, i32* %j, align 4, !dbg !72
  %11 = load i32, i32* %m, align 4, !dbg !74
  %cmp13 = icmp slt i32 %10, %11, !dbg !75
  br i1 %cmp13, label %for.body14, label %for.end26, !dbg !76

for.body14:                                       ; preds = %for.cond12
  %12 = load i32, i32* %i, align 4, !dbg !77
  %sub = sub nsw i32 %12, 1, !dbg !78
  %idxprom15 = sext i32 %sub to i64, !dbg !79
  %arrayidx16 = getelementptr inbounds [1000 x [1000 x double]], [1000 x [1000 x double]]* %b, i64 0, i64 %idxprom15, !dbg !79
  %13 = load i32, i32* %j, align 4, !dbg !80
  %sub17 = sub nsw i32 %13, 1, !dbg !81
  %idxprom18 = sext i32 %sub17 to i64, !dbg !79
  %arrayidx19 = getelementptr inbounds [1000 x double], [1000 x double]* %arrayidx16, i64 0, i64 %idxprom18, !dbg !79
  %14 = load double, double* %arrayidx19, align 8, !dbg !79
  %15 = load i32, i32* %i, align 4, !dbg !82
  %idxprom20 = sext i32 %15 to i64, !dbg !83
  %arrayidx21 = getelementptr inbounds [1000 x [1000 x double]], [1000 x [1000 x double]]* %b, i64 0, i64 %idxprom20, !dbg !83
  %16 = load i32, i32* %j, align 4, !dbg !84
  %idxprom22 = sext i32 %16 to i64, !dbg !83
  %arrayidx23 = getelementptr inbounds [1000 x double], [1000 x double]* %arrayidx21, i64 0, i64 %idxprom22, !dbg !83
  store double %14, double* %arrayidx23, align 8, !dbg !85
  br label %for.inc24, !dbg !83

for.inc24:                                        ; preds = %for.body14
  %17 = load i32, i32* %j, align 4, !dbg !86
  %inc25 = add nsw i32 %17, 1, !dbg !86
  store i32 %inc25, i32* %j, align 4, !dbg !86
  br label %for.cond12, !dbg !87, !llvm.loop !88

for.end26:                                        ; preds = %for.cond12
  br label %for.inc27, !dbg !89

for.inc27:                                        ; preds = %for.end26
  %18 = load i32, i32* %i, align 4, !dbg !90
  %inc28 = add nsw i32 %18, 1, !dbg !90
  store i32 %inc28, i32* %i, align 4, !dbg !90
  br label %for.cond9, !dbg !91, !llvm.loop !92

for.end29:                                        ; preds = %for.cond9
  %arrayidx30 = getelementptr inbounds [1000 x [1000 x double]], [1000 x [1000 x double]]* %b, i64 0, i64 500, !dbg !94
  %arrayidx31 = getelementptr inbounds [1000 x double], [1000 x double]* %arrayidx30, i64 0, i64 500, !dbg !94
  %19 = load double, double* %arrayidx31, align 16, !dbg !94
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i32 0, i32 0), double %19), !dbg !95
  ret i32 0, !dbg !96
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
!1 = !DIFile(filename: "/home/raynard/discopop/work_tests/micro/test.c", directory: "/home/raynard/discopop/work_tests/micro/discopop")
!2 = !{}
!3 = !{i32 2, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"clang version 8.0.1 (tags/RELEASE_801/final)"}
!7 = distinct !DISubprogram(name: "main", scope: !8, file: !8, line: 53, type: !9, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DIFile(filename: "test.c", directory: "/home/raynard/discopop/work_tests/micro")
!9 = !DISubroutineType(types: !10)
!10 = !{!11, !11, !12}
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!13 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!14 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!15 = !DILocalVariable(name: "argc", arg: 1, scope: !7, file: !8, line: 53, type: !11)
!16 = !DILocation(line: 53, column: 14, scope: !7)
!17 = !DILocalVariable(name: "argv", arg: 2, scope: !7, file: !8, line: 53, type: !12)
!18 = !DILocation(line: 53, column: 26, scope: !7)
!19 = !DILocalVariable(name: "i", scope: !7, file: !8, line: 55, type: !11)
!20 = !DILocation(line: 55, column: 7, scope: !7)
!21 = !DILocalVariable(name: "j", scope: !7, file: !8, line: 55, type: !11)
!22 = !DILocation(line: 55, column: 9, scope: !7)
!23 = !DILocalVariable(name: "n", scope: !7, file: !8, line: 56, type: !11)
!24 = !DILocation(line: 56, column: 7, scope: !7)
!25 = !DILocalVariable(name: "m", scope: !7, file: !8, line: 56, type: !11)
!26 = !DILocation(line: 56, column: 15, scope: !7)
!27 = !DILocalVariable(name: "b", scope: !7, file: !8, line: 57, type: !28)
!28 = !DICompositeType(tag: DW_TAG_array_type, baseType: !29, size: 64000000, elements: !30)
!29 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!30 = !{!31, !31}
!31 = !DISubrange(count: 1000)
!32 = !DILocation(line: 57, column: 10, scope: !7)
!33 = !DILocation(line: 59, column: 9, scope: !34)
!34 = distinct !DILexicalBlock(scope: !7, file: !8, line: 59, column: 3)
!35 = !DILocation(line: 59, column: 8, scope: !34)
!36 = !DILocation(line: 59, column: 13, scope: !37)
!37 = distinct !DILexicalBlock(scope: !34, file: !8, line: 59, column: 3)
!38 = !DILocation(line: 59, column: 15, scope: !37)
!39 = !DILocation(line: 59, column: 14, scope: !37)
!40 = !DILocation(line: 59, column: 3, scope: !34)
!41 = !DILocation(line: 60, column: 11, scope: !42)
!42 = distinct !DILexicalBlock(scope: !37, file: !8, line: 60, column: 5)
!43 = !DILocation(line: 60, column: 10, scope: !42)
!44 = !DILocation(line: 60, column: 15, scope: !45)
!45 = distinct !DILexicalBlock(scope: !42, file: !8, line: 60, column: 5)
!46 = !DILocation(line: 60, column: 17, scope: !45)
!47 = !DILocation(line: 60, column: 16, scope: !45)
!48 = !DILocation(line: 60, column: 5, scope: !42)
!49 = !DILocation(line: 61, column: 9, scope: !45)
!50 = !DILocation(line: 61, column: 7, scope: !45)
!51 = !DILocation(line: 61, column: 12, scope: !45)
!52 = !DILocation(line: 61, column: 15, scope: !45)
!53 = !DILocation(line: 60, column: 21, scope: !45)
!54 = !DILocation(line: 60, column: 5, scope: !45)
!55 = distinct !{!55, !48, !56}
!56 = !DILocation(line: 61, column: 17, scope: !42)
!57 = !DILocation(line: 59, column: 19, scope: !37)
!58 = !DILocation(line: 59, column: 3, scope: !37)
!59 = distinct !{!59, !40, !60}
!60 = !DILocation(line: 61, column: 17, scope: !34)
!61 = !DILocation(line: 64, column: 9, scope: !62)
!62 = distinct !DILexicalBlock(scope: !7, file: !8, line: 64, column: 3)
!63 = !DILocation(line: 64, column: 8, scope: !62)
!64 = !DILocation(line: 64, column: 12, scope: !65)
!65 = distinct !DILexicalBlock(scope: !62, file: !8, line: 64, column: 3)
!66 = !DILocation(line: 64, column: 14, scope: !65)
!67 = !DILocation(line: 64, column: 13, scope: !65)
!68 = !DILocation(line: 64, column: 3, scope: !62)
!69 = !DILocation(line: 65, column: 11, scope: !70)
!70 = distinct !DILexicalBlock(scope: !65, file: !8, line: 65, column: 5)
!71 = !DILocation(line: 65, column: 10, scope: !70)
!72 = !DILocation(line: 65, column: 14, scope: !73)
!73 = distinct !DILexicalBlock(scope: !70, file: !8, line: 65, column: 5)
!74 = !DILocation(line: 65, column: 16, scope: !73)
!75 = !DILocation(line: 65, column: 15, scope: !73)
!76 = !DILocation(line: 65, column: 5, scope: !70)
!77 = !DILocation(line: 66, column: 17, scope: !73)
!78 = !DILocation(line: 66, column: 18, scope: !73)
!79 = !DILocation(line: 66, column: 15, scope: !73)
!80 = !DILocation(line: 66, column: 22, scope: !73)
!81 = !DILocation(line: 66, column: 23, scope: !73)
!82 = !DILocation(line: 66, column: 9, scope: !73)
!83 = !DILocation(line: 66, column: 7, scope: !73)
!84 = !DILocation(line: 66, column: 12, scope: !73)
!85 = !DILocation(line: 66, column: 14, scope: !73)
!86 = !DILocation(line: 65, column: 19, scope: !73)
!87 = !DILocation(line: 65, column: 5, scope: !73)
!88 = distinct !{!88, !76, !89}
!89 = !DILocation(line: 66, column: 25, scope: !70)
!90 = !DILocation(line: 64, column: 17, scope: !65)
!91 = !DILocation(line: 64, column: 3, scope: !65)
!92 = distinct !{!92, !68, !93}
!93 = !DILocation(line: 66, column: 25, scope: !62)
!94 = !DILocation(line: 68, column: 30, scope: !7)
!95 = !DILocation(line: 68, column: 3, scope: !7)
!96 = !DILocation(line: 69, column: 3, scope: !7)
