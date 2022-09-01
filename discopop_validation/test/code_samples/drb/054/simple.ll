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
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !13, metadata !DIExpression()), !dbg !14
  call void @llvm.dbg.declare(metadata i32* %j, metadata !15, metadata !DIExpression()), !dbg !16
  call void @llvm.dbg.declare(metadata i32* %n, metadata !17, metadata !DIExpression()), !dbg !18
  store i32 100, i32* %n, align 4, !dbg !18
  call void @llvm.dbg.declare(metadata i32* %m, metadata !19, metadata !DIExpression()), !dbg !20
  store i32 100, i32* %m, align 4, !dbg !20
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
  store i32 0, i32* %i, align 4, !dbg !34
  br label %for.cond, !dbg !36

for.cond:                                         ; preds = %for.inc6, %entry
  %6 = load i32, i32* %i, align 4, !dbg !37
  %7 = load i32, i32* %n, align 4, !dbg !39
  %cmp = icmp slt i32 %6, %7, !dbg !40
  br i1 %cmp, label %for.body, label %for.end8, !dbg !41

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %j, align 4, !dbg !42
  br label %for.cond1, !dbg !44

for.cond1:                                        ; preds = %for.inc, %for.body
  %8 = load i32, i32* %j, align 4, !dbg !45
  %9 = load i32, i32* %n, align 4, !dbg !47
  %cmp2 = icmp slt i32 %8, %9, !dbg !48
  br i1 %cmp2, label %for.body3, label %for.end, !dbg !49

for.body3:                                        ; preds = %for.cond1
  %10 = load i32, i32* %i, align 4, !dbg !50
  %11 = load i32, i32* %j, align 4, !dbg !51
  %mul = mul nsw i32 %10, %11, !dbg !52
  %conv = sitofp i32 %mul to double, !dbg !53
  %12 = load i32, i32* %i, align 4, !dbg !54
  %idxprom = sext i32 %12 to i64, !dbg !55
  %13 = mul nsw i64 %idxprom, %3, !dbg !55
  %arrayidx = getelementptr inbounds double, double* %vla, i64 %13, !dbg !55
  %14 = load i32, i32* %j, align 4, !dbg !56
  %idxprom4 = sext i32 %14 to i64, !dbg !55
  %arrayidx5 = getelementptr inbounds double, double* %arrayidx, i64 %idxprom4, !dbg !55
  store double %conv, double* %arrayidx5, align 8, !dbg !57
  br label %for.inc, !dbg !55

for.inc:                                          ; preds = %for.body3
  %15 = load i32, i32* %j, align 4, !dbg !58
  %inc = add nsw i32 %15, 1, !dbg !58
  store i32 %inc, i32* %j, align 4, !dbg !58
  br label %for.cond1, !dbg !59, !llvm.loop !60

for.end:                                          ; preds = %for.cond1
  br label %for.inc6, !dbg !61

for.inc6:                                         ; preds = %for.end
  %16 = load i32, i32* %i, align 4, !dbg !62
  %inc7 = add nsw i32 %16, 1, !dbg !62
  store i32 %inc7, i32* %i, align 4, !dbg !62
  br label %for.cond, !dbg !63, !llvm.loop !64

for.end8:                                         ; preds = %for.cond
  store i32 1, i32* %i, align 4, !dbg !66
  br label %for.cond9, !dbg !68

for.cond9:                                        ; preds = %for.inc29, %for.end8
  %17 = load i32, i32* %i, align 4, !dbg !69
  %18 = load i32, i32* %n, align 4, !dbg !71
  %cmp10 = icmp slt i32 %17, %18, !dbg !72
  br i1 %cmp10, label %for.body12, label %for.end31, !dbg !73

for.body12:                                       ; preds = %for.cond9
  store i32 1, i32* %j, align 4, !dbg !74
  br label %for.cond13, !dbg !76

for.cond13:                                       ; preds = %for.inc26, %for.body12
  %19 = load i32, i32* %j, align 4, !dbg !77
  %20 = load i32, i32* %m, align 4, !dbg !79
  %cmp14 = icmp slt i32 %19, %20, !dbg !80
  br i1 %cmp14, label %for.body16, label %for.end28, !dbg !81

for.body16:                                       ; preds = %for.cond13
  %21 = load i32, i32* %i, align 4, !dbg !82
  %sub = sub nsw i32 %21, 1, !dbg !83
  %idxprom17 = sext i32 %sub to i64, !dbg !84
  %22 = mul nsw i64 %idxprom17, %3, !dbg !84
  %arrayidx18 = getelementptr inbounds double, double* %vla, i64 %22, !dbg !84
  %23 = load i32, i32* %j, align 4, !dbg !85
  %sub19 = sub nsw i32 %23, 1, !dbg !86
  %idxprom20 = sext i32 %sub19 to i64, !dbg !84
  %arrayidx21 = getelementptr inbounds double, double* %arrayidx18, i64 %idxprom20, !dbg !84
  %24 = load double, double* %arrayidx21, align 8, !dbg !84
  %25 = load i32, i32* %i, align 4, !dbg !87
  %idxprom22 = sext i32 %25 to i64, !dbg !88
  %26 = mul nsw i64 %idxprom22, %3, !dbg !88
  %arrayidx23 = getelementptr inbounds double, double* %vla, i64 %26, !dbg !88
  %27 = load i32, i32* %j, align 4, !dbg !89
  %idxprom24 = sext i32 %27 to i64, !dbg !88
  %arrayidx25 = getelementptr inbounds double, double* %arrayidx23, i64 %idxprom24, !dbg !88
  store double %24, double* %arrayidx25, align 8, !dbg !90
  br label %for.inc26, !dbg !88

for.inc26:                                        ; preds = %for.body16
  %28 = load i32, i32* %j, align 4, !dbg !91
  %inc27 = add nsw i32 %28, 1, !dbg !91
  store i32 %inc27, i32* %j, align 4, !dbg !91
  br label %for.cond13, !dbg !92, !llvm.loop !93

for.end28:                                        ; preds = %for.cond13
  br label %for.inc29, !dbg !94

for.inc29:                                        ; preds = %for.end28
  %29 = load i32, i32* %i, align 4, !dbg !95
  %inc30 = add nsw i32 %29, 1, !dbg !95
  store i32 %inc30, i32* %i, align 4, !dbg !95
  br label %for.cond9, !dbg !96, !llvm.loop !97

for.end31:                                        ; preds = %for.cond9
  store i32 0, i32* %retval, align 4, !dbg !99
  %30 = load i8*, i8** %saved_stack, align 8, !dbg !100
  call void @llvm.stackrestore(i8* %30), !dbg !100
  %31 = load i32, i32* %retval, align 4, !dbg !100
  ret i32 %31, !dbg !100
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
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/054")
!2 = !{}
!3 = !{!4}
!4 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!5 = !{i32 7, !"Dwarf Version", i32 4}
!6 = !{i32 2, !"Debug Info Version", i32 3}
!7 = !{i32 1, !"wchar_size", i32 4}
!8 = !{!"Ubuntu clang version 11.1.0-6"}
!9 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 51, type: !10, scopeLine: 52, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!10 = !DISubroutineType(types: !11)
!11 = !{!12}
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !DILocalVariable(name: "i", scope: !9, file: !1, line: 53, type: !12)
!14 = !DILocation(line: 53, column: 7, scope: !9)
!15 = !DILocalVariable(name: "j", scope: !9, file: !1, line: 53, type: !12)
!16 = !DILocation(line: 53, column: 9, scope: !9)
!17 = !DILocalVariable(name: "n", scope: !9, file: !1, line: 54, type: !12)
!18 = !DILocation(line: 54, column: 7, scope: !9)
!19 = !DILocalVariable(name: "m", scope: !9, file: !1, line: 54, type: !12)
!20 = !DILocation(line: 54, column: 14, scope: !9)
!21 = !DILocation(line: 55, column: 12, scope: !9)
!22 = !DILocation(line: 55, column: 3, scope: !9)
!23 = !DILocation(line: 55, column: 15, scope: !9)
!24 = !DILocalVariable(name: "__vla_expr0", scope: !9, type: !25, flags: DIFlagArtificial)
!25 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!26 = !DILocation(line: 0, scope: !9)
!27 = !DILocalVariable(name: "__vla_expr1", scope: !9, type: !25, flags: DIFlagArtificial)
!28 = !DILocalVariable(name: "b", scope: !9, file: !1, line: 55, type: !29)
!29 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, elements: !30)
!30 = !{!31, !32}
!31 = !DISubrange(count: !24)
!32 = !DISubrange(count: !27)
!33 = !DILocation(line: 55, column: 10, scope: !9)
!34 = !DILocation(line: 57, column: 8, scope: !35)
!35 = distinct !DILexicalBlock(scope: !9, file: !1, line: 57, column: 3)
!36 = !DILocation(line: 57, column: 7, scope: !35)
!37 = !DILocation(line: 57, column: 11, scope: !38)
!38 = distinct !DILexicalBlock(scope: !35, file: !1, line: 57, column: 3)
!39 = !DILocation(line: 57, column: 13, scope: !38)
!40 = !DILocation(line: 57, column: 12, scope: !38)
!41 = !DILocation(line: 57, column: 3, scope: !35)
!42 = !DILocation(line: 58, column: 10, scope: !43)
!43 = distinct !DILexicalBlock(scope: !38, file: !1, line: 58, column: 5)
!44 = !DILocation(line: 58, column: 9, scope: !43)
!45 = !DILocation(line: 58, column: 13, scope: !46)
!46 = distinct !DILexicalBlock(scope: !43, file: !1, line: 58, column: 5)
!47 = !DILocation(line: 58, column: 15, scope: !46)
!48 = !DILocation(line: 58, column: 14, scope: !46)
!49 = !DILocation(line: 58, column: 5, scope: !43)
!50 = !DILocation(line: 59, column: 24, scope: !46)
!51 = !DILocation(line: 59, column: 26, scope: !46)
!52 = !DILocation(line: 59, column: 25, scope: !46)
!53 = !DILocation(line: 59, column: 15, scope: !46)
!54 = !DILocation(line: 59, column: 9, scope: !46)
!55 = !DILocation(line: 59, column: 7, scope: !46)
!56 = !DILocation(line: 59, column: 12, scope: !46)
!57 = !DILocation(line: 59, column: 14, scope: !46)
!58 = !DILocation(line: 58, column: 19, scope: !46)
!59 = !DILocation(line: 58, column: 5, scope: !46)
!60 = distinct !{!60, !49, !61}
!61 = !DILocation(line: 59, column: 27, scope: !43)
!62 = !DILocation(line: 57, column: 17, scope: !38)
!63 = !DILocation(line: 57, column: 3, scope: !38)
!64 = distinct !{!64, !41, !65}
!65 = !DILocation(line: 59, column: 27, scope: !35)
!66 = !DILocation(line: 61, column: 9, scope: !67)
!67 = distinct !DILexicalBlock(scope: !9, file: !1, line: 61, column: 3)
!68 = !DILocation(line: 61, column: 8, scope: !67)
!69 = !DILocation(line: 61, column: 12, scope: !70)
!70 = distinct !DILexicalBlock(scope: !67, file: !1, line: 61, column: 3)
!71 = !DILocation(line: 61, column: 14, scope: !70)
!72 = !DILocation(line: 61, column: 13, scope: !70)
!73 = !DILocation(line: 61, column: 3, scope: !67)
!74 = !DILocation(line: 63, column: 11, scope: !75)
!75 = distinct !DILexicalBlock(scope: !70, file: !1, line: 63, column: 5)
!76 = !DILocation(line: 63, column: 10, scope: !75)
!77 = !DILocation(line: 63, column: 14, scope: !78)
!78 = distinct !DILexicalBlock(scope: !75, file: !1, line: 63, column: 5)
!79 = !DILocation(line: 63, column: 16, scope: !78)
!80 = !DILocation(line: 63, column: 15, scope: !78)
!81 = !DILocation(line: 63, column: 5, scope: !75)
!82 = !DILocation(line: 64, column: 17, scope: !78)
!83 = !DILocation(line: 64, column: 18, scope: !78)
!84 = !DILocation(line: 64, column: 15, scope: !78)
!85 = !DILocation(line: 64, column: 22, scope: !78)
!86 = !DILocation(line: 64, column: 23, scope: !78)
!87 = !DILocation(line: 64, column: 9, scope: !78)
!88 = !DILocation(line: 64, column: 7, scope: !78)
!89 = !DILocation(line: 64, column: 12, scope: !78)
!90 = !DILocation(line: 64, column: 14, scope: !78)
!91 = !DILocation(line: 63, column: 19, scope: !78)
!92 = !DILocation(line: 63, column: 5, scope: !78)
!93 = distinct !{!93, !81, !94}
!94 = !DILocation(line: 64, column: 25, scope: !75)
!95 = !DILocation(line: 61, column: 17, scope: !70)
!96 = !DILocation(line: 61, column: 3, scope: !70)
!97 = distinct !{!97, !73, !98}
!98 = !DILocation(line: 64, column: 25, scope: !67)
!99 = !DILocation(line: 65, column: 3, scope: !9)
!100 = !DILocation(line: 66, column: 1, scope: !9)
