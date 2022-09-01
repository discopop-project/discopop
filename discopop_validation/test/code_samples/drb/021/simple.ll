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
  %u = alloca [100 x [100 x float]], align 16
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
  call void @llvm.dbg.declare(metadata [100 x [100 x float]]* %u, metadata !29, metadata !DIExpression()), !dbg !33
  store i32 0, i32* %i, align 4, !dbg !34
  br label %for.cond, !dbg !36

for.cond:                                         ; preds = %for.inc6, %entry
  %0 = load i32, i32* %i, align 4, !dbg !37
  %1 = load i32, i32* %len, align 4, !dbg !39
  %cmp = icmp slt i32 %0, %1, !dbg !40
  br i1 %cmp, label %for.body, label %for.end8, !dbg !41

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %j, align 4, !dbg !42
  br label %for.cond1, !dbg !44

for.cond1:                                        ; preds = %for.inc, %for.body
  %2 = load i32, i32* %j, align 4, !dbg !45
  %3 = load i32, i32* %len, align 4, !dbg !47
  %cmp2 = icmp slt i32 %2, %3, !dbg !48
  br i1 %cmp2, label %for.body3, label %for.end, !dbg !49

for.body3:                                        ; preds = %for.cond1
  %4 = load i32, i32* %i, align 4, !dbg !50
  %idxprom = sext i32 %4 to i64, !dbg !51
  %arrayidx = getelementptr inbounds [100 x [100 x float]], [100 x [100 x float]]* %u, i64 0, i64 %idxprom, !dbg !51
  %5 = load i32, i32* %j, align 4, !dbg !52
  %idxprom4 = sext i32 %5 to i64, !dbg !51
  %arrayidx5 = getelementptr inbounds [100 x float], [100 x float]* %arrayidx, i64 0, i64 %idxprom4, !dbg !51
  store float 5.000000e-01, float* %arrayidx5, align 4, !dbg !53
  br label %for.inc, !dbg !51

for.inc:                                          ; preds = %for.body3
  %6 = load i32, i32* %j, align 4, !dbg !54
  %inc = add nsw i32 %6, 1, !dbg !54
  store i32 %inc, i32* %j, align 4, !dbg !54
  br label %for.cond1, !dbg !55, !llvm.loop !56

for.end:                                          ; preds = %for.cond1
  br label %for.inc6, !dbg !57

for.inc6:                                         ; preds = %for.end
  %7 = load i32, i32* %i, align 4, !dbg !58
  %inc7 = add nsw i32 %7, 1, !dbg !58
  store i32 %inc7, i32* %i, align 4, !dbg !58
  br label %for.cond, !dbg !59, !llvm.loop !60

for.end8:                                         ; preds = %for.cond
  store i32 0, i32* %i, align 4, !dbg !62
  br label %for.cond9, !dbg !64

for.cond9:                                        ; preds = %for.inc22, %for.end8
  %8 = load i32, i32* %i, align 4, !dbg !65
  %9 = load i32, i32* %len, align 4, !dbg !67
  %cmp10 = icmp slt i32 %8, %9, !dbg !68
  br i1 %cmp10, label %for.body11, label %for.end24, !dbg !69

for.body11:                                       ; preds = %for.cond9
  store i32 0, i32* %j, align 4, !dbg !70
  br label %for.cond12, !dbg !72

for.cond12:                                       ; preds = %for.inc19, %for.body11
  %10 = load i32, i32* %j, align 4, !dbg !73
  %11 = load i32, i32* %len, align 4, !dbg !75
  %cmp13 = icmp slt i32 %10, %11, !dbg !76
  br i1 %cmp13, label %for.body14, label %for.end21, !dbg !77

for.body14:                                       ; preds = %for.cond12
  %12 = load i32, i32* %i, align 4, !dbg !78
  %idxprom15 = sext i32 %12 to i64, !dbg !80
  %arrayidx16 = getelementptr inbounds [100 x [100 x float]], [100 x [100 x float]]* %u, i64 0, i64 %idxprom15, !dbg !80
  %13 = load i32, i32* %j, align 4, !dbg !81
  %idxprom17 = sext i32 %13 to i64, !dbg !80
  %arrayidx18 = getelementptr inbounds [100 x float], [100 x float]* %arrayidx16, i64 0, i64 %idxprom17, !dbg !80
  %14 = load float, float* %arrayidx18, align 4, !dbg !80
  store float %14, float* %temp, align 4, !dbg !82
  %15 = load float, float* %sum, align 4, !dbg !83
  %16 = load float, float* %temp, align 4, !dbg !84
  %17 = load float, float* %temp, align 4, !dbg !85
  %mul = fmul float %16, %17, !dbg !86
  %add = fadd float %15, %mul, !dbg !87
  store float %add, float* %sum, align 4, !dbg !88
  br label %for.inc19, !dbg !89

for.inc19:                                        ; preds = %for.body14
  %18 = load i32, i32* %j, align 4, !dbg !90
  %inc20 = add nsw i32 %18, 1, !dbg !90
  store i32 %inc20, i32* %j, align 4, !dbg !90
  br label %for.cond12, !dbg !91, !llvm.loop !92

for.end21:                                        ; preds = %for.cond12
  br label %for.inc22, !dbg !93

for.inc22:                                        ; preds = %for.end21
  %19 = load i32, i32* %i, align 4, !dbg !94
  %inc23 = add nsw i32 %19, 1, !dbg !94
  store i32 %inc23, i32* %i, align 4, !dbg !94
  br label %for.cond9, !dbg !95, !llvm.loop !96

for.end24:                                        ; preds = %for.cond9
  %20 = load float, float* %sum, align 4, !dbg !98
  %conv = fpext float %20 to double, !dbg !98
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), double %conv), !dbg !99
  ret i32 0, !dbg !100
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
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/021")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"Ubuntu clang version 11.1.0-6"}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 54, type: !8, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10, !10, !11}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!13 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!14 = !DILocalVariable(name: "argc", arg: 1, scope: !7, file: !1, line: 54, type: !10)
!15 = !DILocation(line: 54, column: 14, scope: !7)
!16 = !DILocalVariable(name: "argv", arg: 2, scope: !7, file: !1, line: 54, type: !11)
!17 = !DILocation(line: 54, column: 26, scope: !7)
!18 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 56, type: !10)
!19 = !DILocation(line: 56, column: 7, scope: !7)
!20 = !DILocalVariable(name: "j", scope: !7, file: !1, line: 56, type: !10)
!21 = !DILocation(line: 56, column: 9, scope: !7)
!22 = !DILocalVariable(name: "temp", scope: !7, file: !1, line: 57, type: !23)
!23 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!24 = !DILocation(line: 57, column: 9, scope: !7)
!25 = !DILocalVariable(name: "sum", scope: !7, file: !1, line: 57, type: !23)
!26 = !DILocation(line: 57, column: 15, scope: !7)
!27 = !DILocalVariable(name: "len", scope: !7, file: !1, line: 58, type: !10)
!28 = !DILocation(line: 58, column: 7, scope: !7)
!29 = !DILocalVariable(name: "u", scope: !7, file: !1, line: 60, type: !30)
!30 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 320000, elements: !31)
!31 = !{!32, !32}
!32 = !DISubrange(count: 100)
!33 = !DILocation(line: 60, column: 9, scope: !7)
!34 = !DILocation(line: 61, column: 10, scope: !35)
!35 = distinct !DILexicalBlock(scope: !7, file: !1, line: 61, column: 3)
!36 = !DILocation(line: 61, column: 8, scope: !35)
!37 = !DILocation(line: 61, column: 15, scope: !38)
!38 = distinct !DILexicalBlock(scope: !35, file: !1, line: 61, column: 3)
!39 = !DILocation(line: 61, column: 19, scope: !38)
!40 = !DILocation(line: 61, column: 17, scope: !38)
!41 = !DILocation(line: 61, column: 3, scope: !35)
!42 = !DILocation(line: 62, column: 12, scope: !43)
!43 = distinct !DILexicalBlock(scope: !38, file: !1, line: 62, column: 5)
!44 = !DILocation(line: 62, column: 10, scope: !43)
!45 = !DILocation(line: 62, column: 17, scope: !46)
!46 = distinct !DILexicalBlock(scope: !43, file: !1, line: 62, column: 5)
!47 = !DILocation(line: 62, column: 21, scope: !46)
!48 = !DILocation(line: 62, column: 19, scope: !46)
!49 = !DILocation(line: 62, column: 5, scope: !43)
!50 = !DILocation(line: 63, column: 11, scope: !46)
!51 = !DILocation(line: 63, column: 9, scope: !46)
!52 = !DILocation(line: 63, column: 14, scope: !46)
!53 = !DILocation(line: 63, column: 17, scope: !46)
!54 = !DILocation(line: 62, column: 27, scope: !46)
!55 = !DILocation(line: 62, column: 5, scope: !46)
!56 = distinct !{!56, !49, !57}
!57 = !DILocation(line: 63, column: 19, scope: !43)
!58 = !DILocation(line: 61, column: 25, scope: !38)
!59 = !DILocation(line: 61, column: 3, scope: !38)
!60 = distinct !{!60, !41, !61}
!61 = !DILocation(line: 63, column: 19, scope: !35)
!62 = !DILocation(line: 66, column: 10, scope: !63)
!63 = distinct !DILexicalBlock(scope: !7, file: !1, line: 66, column: 3)
!64 = !DILocation(line: 66, column: 8, scope: !63)
!65 = !DILocation(line: 66, column: 15, scope: !66)
!66 = distinct !DILexicalBlock(scope: !63, file: !1, line: 66, column: 3)
!67 = !DILocation(line: 66, column: 19, scope: !66)
!68 = !DILocation(line: 66, column: 17, scope: !66)
!69 = !DILocation(line: 66, column: 3, scope: !63)
!70 = !DILocation(line: 67, column: 12, scope: !71)
!71 = distinct !DILexicalBlock(scope: !66, file: !1, line: 67, column: 5)
!72 = !DILocation(line: 67, column: 10, scope: !71)
!73 = !DILocation(line: 67, column: 17, scope: !74)
!74 = distinct !DILexicalBlock(scope: !71, file: !1, line: 67, column: 5)
!75 = !DILocation(line: 67, column: 21, scope: !74)
!76 = !DILocation(line: 67, column: 19, scope: !74)
!77 = !DILocation(line: 67, column: 5, scope: !71)
!78 = !DILocation(line: 69, column: 16, scope: !79)
!79 = distinct !DILexicalBlock(scope: !74, file: !1, line: 68, column: 5)
!80 = !DILocation(line: 69, column: 14, scope: !79)
!81 = !DILocation(line: 69, column: 19, scope: !79)
!82 = !DILocation(line: 69, column: 12, scope: !79)
!83 = !DILocation(line: 70, column: 13, scope: !79)
!84 = !DILocation(line: 70, column: 19, scope: !79)
!85 = !DILocation(line: 70, column: 26, scope: !79)
!86 = !DILocation(line: 70, column: 24, scope: !79)
!87 = !DILocation(line: 70, column: 17, scope: !79)
!88 = !DILocation(line: 70, column: 11, scope: !79)
!89 = !DILocation(line: 71, column: 5, scope: !79)
!90 = !DILocation(line: 67, column: 27, scope: !74)
!91 = !DILocation(line: 67, column: 5, scope: !74)
!92 = distinct !{!92, !77, !93}
!93 = !DILocation(line: 71, column: 5, scope: !71)
!94 = !DILocation(line: 66, column: 25, scope: !66)
!95 = !DILocation(line: 66, column: 3, scope: !66)
!96 = distinct !{!96, !69, !97}
!97 = !DILocation(line: 71, column: 5, scope: !63)
!98 = !DILocation(line: 73, column: 25, scope: !7)
!99 = !DILocation(line: 73, column: 3, scope: !7)
!100 = !DILocation(line: 74, column: 3, scope: !7)
