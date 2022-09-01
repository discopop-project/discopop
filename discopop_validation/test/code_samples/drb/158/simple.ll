; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@a = dso_local global float 0.000000e+00, align 4, !dbg !0
@x = dso_local global [64 x float] zeroinitializer, align 16, !dbg !6
@y = dso_local global [64 x float] zeroinitializer, align 16, !dbg !12
@.str = private unnamed_addr constant [20 x i8] c"Data Race Detected\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !18 {
entry:
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %i3 = alloca i32, align 4
  %i20 = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !22, metadata !DIExpression()), !dbg !24
  store i32 0, i32* %i, align 4, !dbg !24
  br label %for.cond, !dbg !25

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !26
  %cmp = icmp slt i32 %0, 64, !dbg !28
  br i1 %cmp, label %for.body, label %for.end, !dbg !29

for.body:                                         ; preds = %for.cond
  store float 5.000000e+00, float* @a, align 4, !dbg !30
  %1 = load i32, i32* %i, align 4, !dbg !32
  %idxprom = sext i32 %1 to i64, !dbg !33
  %arrayidx = getelementptr inbounds [64 x float], [64 x float]* @x, i64 0, i64 %idxprom, !dbg !33
  store float 0.000000e+00, float* %arrayidx, align 4, !dbg !34
  %2 = load i32, i32* %i, align 4, !dbg !35
  %idxprom1 = sext i32 %2 to i64, !dbg !36
  %arrayidx2 = getelementptr inbounds [64 x float], [64 x float]* @y, i64 0, i64 %idxprom1, !dbg !36
  store float 3.000000e+00, float* %arrayidx2, align 4, !dbg !37
  br label %for.inc, !dbg !38

for.inc:                                          ; preds = %for.body
  %3 = load i32, i32* %i, align 4, !dbg !39
  %inc = add nsw i32 %3, 1, !dbg !39
  store i32 %inc, i32* %i, align 4, !dbg !39
  br label %for.cond, !dbg !40, !llvm.loop !41

for.end:                                          ; preds = %for.cond
  call void @llvm.dbg.declare(metadata i32* %i3, metadata !43, metadata !DIExpression()), !dbg !46
  store i32 0, i32* %i3, align 4, !dbg !46
  br label %for.cond4, !dbg !47

for.cond4:                                        ; preds = %for.inc17, %for.end
  %4 = load i32, i32* %i3, align 4, !dbg !48
  %cmp5 = icmp slt i32 %4, 64, !dbg !50
  br i1 %cmp5, label %for.body6, label %for.end19, !dbg !51

for.body6:                                        ; preds = %for.cond4
  %5 = load float, float* @a, align 4, !dbg !52
  %6 = load i32, i32* %i3, align 4, !dbg !55
  %idxprom7 = sext i32 %6 to i64, !dbg !56
  %arrayidx8 = getelementptr inbounds [64 x float], [64 x float]* @x, i64 0, i64 %idxprom7, !dbg !56
  %7 = load float, float* %arrayidx8, align 4, !dbg !56
  %mul = fmul float %5, %7, !dbg !57
  %8 = load i32, i32* %i3, align 4, !dbg !58
  %idxprom9 = sext i32 %8 to i64, !dbg !59
  %arrayidx10 = getelementptr inbounds [64 x float], [64 x float]* @x, i64 0, i64 %idxprom9, !dbg !59
  store float %mul, float* %arrayidx10, align 4, !dbg !60
  %9 = load i32, i32* %i3, align 4, !dbg !61
  %idxprom11 = sext i32 %9 to i64, !dbg !63
  %arrayidx12 = getelementptr inbounds [64 x float], [64 x float]* @x, i64 0, i64 %idxprom11, !dbg !63
  %10 = load float, float* %arrayidx12, align 4, !dbg !63
  %11 = load i32, i32* %i3, align 4, !dbg !64
  %idxprom13 = sext i32 %11 to i64, !dbg !65
  %arrayidx14 = getelementptr inbounds [64 x float], [64 x float]* @y, i64 0, i64 %idxprom13, !dbg !65
  %12 = load float, float* %arrayidx14, align 4, !dbg !65
  %add = fadd float %10, %12, !dbg !66
  %13 = load i32, i32* %i3, align 4, !dbg !67
  %idxprom15 = sext i32 %13 to i64, !dbg !68
  %arrayidx16 = getelementptr inbounds [64 x float], [64 x float]* @x, i64 0, i64 %idxprom15, !dbg !68
  store float %add, float* %arrayidx16, align 4, !dbg !69
  br label %for.inc17, !dbg !70

for.inc17:                                        ; preds = %for.body6
  %14 = load i32, i32* %i3, align 4, !dbg !71
  %inc18 = add nsw i32 %14, 1, !dbg !71
  store i32 %inc18, i32* %i3, align 4, !dbg !71
  br label %for.cond4, !dbg !72, !llvm.loop !73

for.end19:                                        ; preds = %for.cond4
  call void @llvm.dbg.declare(metadata i32* %i20, metadata !75, metadata !DIExpression()), !dbg !77
  store i32 0, i32* %i20, align 4, !dbg !77
  br label %for.cond21, !dbg !78

for.cond21:                                       ; preds = %for.inc27, %for.end19
  %15 = load i32, i32* %i20, align 4, !dbg !79
  %cmp22 = icmp slt i32 %15, 64, !dbg !81
  br i1 %cmp22, label %for.body23, label %for.end29, !dbg !82

for.body23:                                       ; preds = %for.cond21
  %16 = load i32, i32* %i20, align 4, !dbg !83
  %idxprom24 = sext i32 %16 to i64, !dbg !86
  %arrayidx25 = getelementptr inbounds [64 x float], [64 x float]* @x, i64 0, i64 %idxprom24, !dbg !86
  %17 = load float, float* %arrayidx25, align 4, !dbg !86
  %cmp26 = fcmp une float %17, 3.000000e+00, !dbg !87
  br i1 %cmp26, label %if.then, label %if.end, !dbg !88

if.then:                                          ; preds = %for.body23
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([20 x i8], [20 x i8]* @.str, i64 0, i64 0)), !dbg !89
  store i32 0, i32* %retval, align 4, !dbg !91
  br label %return, !dbg !91

if.end:                                           ; preds = %for.body23
  br label %for.inc27, !dbg !92

for.inc27:                                        ; preds = %if.end
  %18 = load i32, i32* %i20, align 4, !dbg !93
  %inc28 = add nsw i32 %18, 1, !dbg !93
  store i32 %inc28, i32* %i20, align 4, !dbg !93
  br label %for.cond21, !dbg !94, !llvm.loop !95

for.end29:                                        ; preds = %for.cond21
  store i32 0, i32* %retval, align 4, !dbg !97
  br label %return, !dbg !97

return:                                           ; preds = %for.end29, %if.then
  %19 = load i32, i32* %retval, align 4, !dbg !98
  ret i32 %19, !dbg !98
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @printf(i8*, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!14, !15, !16}
!llvm.ident = !{!17}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 19, type: !9, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/158")
!4 = !{}
!5 = !{!0, !6, !12}
!6 = !DIGlobalVariableExpression(var: !7, expr: !DIExpression())
!7 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 20, type: !8, isLocal: false, isDefinition: true)
!8 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 2048, elements: !10)
!9 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!10 = !{!11}
!11 = !DISubrange(count: 64)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 21, type: !8, isLocal: false, isDefinition: true)
!14 = !{i32 7, !"Dwarf Version", i32 4}
!15 = !{i32 2, !"Debug Info Version", i32 3}
!16 = !{i32 1, !"wchar_size", i32 4}
!17 = !{!"Ubuntu clang version 11.1.0-6"}
!18 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 23, type: !19, scopeLine: 23, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!19 = !DISubroutineType(types: !20)
!20 = !{!21}
!21 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!22 = !DILocalVariable(name: "i", scope: !23, file: !3, line: 24, type: !21)
!23 = distinct !DILexicalBlock(scope: !18, file: !3, line: 24, column: 3)
!24 = !DILocation(line: 24, column: 11, scope: !23)
!25 = !DILocation(line: 24, column: 7, scope: !23)
!26 = !DILocation(line: 24, column: 16, scope: !27)
!27 = distinct !DILexicalBlock(scope: !23, file: !3, line: 24, column: 3)
!28 = !DILocation(line: 24, column: 17, scope: !27)
!29 = !DILocation(line: 24, column: 3, scope: !23)
!30 = !DILocation(line: 25, column: 6, scope: !31)
!31 = distinct !DILexicalBlock(scope: !27, file: !3, line: 24, column: 25)
!32 = !DILocation(line: 26, column: 7, scope: !31)
!33 = !DILocation(line: 26, column: 5, scope: !31)
!34 = !DILocation(line: 26, column: 9, scope: !31)
!35 = !DILocation(line: 27, column: 7, scope: !31)
!36 = !DILocation(line: 27, column: 5, scope: !31)
!37 = !DILocation(line: 27, column: 9, scope: !31)
!38 = !DILocation(line: 28, column: 3, scope: !31)
!39 = !DILocation(line: 24, column: 22, scope: !27)
!40 = !DILocation(line: 24, column: 3, scope: !27)
!41 = distinct !{!41, !29, !42}
!42 = !DILocation(line: 28, column: 3, scope: !23)
!43 = !DILocalVariable(name: "i", scope: !44, file: !3, line: 32, type: !21)
!44 = distinct !DILexicalBlock(scope: !45, file: !3, line: 32, column: 5)
!45 = distinct !DILexicalBlock(scope: !18, file: !3, line: 31, column: 3)
!46 = !DILocation(line: 32, column: 13, scope: !44)
!47 = !DILocation(line: 32, column: 9, scope: !44)
!48 = !DILocation(line: 32, column: 18, scope: !49)
!49 = distinct !DILexicalBlock(scope: !44, file: !3, line: 32, column: 5)
!50 = !DILocation(line: 32, column: 19, scope: !49)
!51 = !DILocation(line: 32, column: 5, scope: !44)
!52 = !DILocation(line: 35, column: 16, scope: !53)
!53 = distinct !DILexicalBlock(scope: !54, file: !3, line: 34, column: 7)
!54 = distinct !DILexicalBlock(scope: !49, file: !3, line: 32, column: 27)
!55 = !DILocation(line: 35, column: 22, scope: !53)
!56 = !DILocation(line: 35, column: 20, scope: !53)
!57 = !DILocation(line: 35, column: 18, scope: !53)
!58 = !DILocation(line: 35, column: 11, scope: !53)
!59 = !DILocation(line: 35, column: 9, scope: !53)
!60 = !DILocation(line: 35, column: 14, scope: !53)
!61 = !DILocation(line: 39, column: 18, scope: !62)
!62 = distinct !DILexicalBlock(scope: !54, file: !3, line: 38, column: 7)
!63 = !DILocation(line: 39, column: 16, scope: !62)
!64 = !DILocation(line: 39, column: 25, scope: !62)
!65 = !DILocation(line: 39, column: 23, scope: !62)
!66 = !DILocation(line: 39, column: 21, scope: !62)
!67 = !DILocation(line: 39, column: 11, scope: !62)
!68 = !DILocation(line: 39, column: 9, scope: !62)
!69 = !DILocation(line: 39, column: 14, scope: !62)
!70 = !DILocation(line: 41, column: 5, scope: !54)
!71 = !DILocation(line: 32, column: 24, scope: !49)
!72 = !DILocation(line: 32, column: 5, scope: !49)
!73 = distinct !{!73, !51, !74}
!74 = !DILocation(line: 41, column: 5, scope: !44)
!75 = !DILocalVariable(name: "i", scope: !76, file: !3, line: 44, type: !21)
!76 = distinct !DILexicalBlock(scope: !18, file: !3, line: 44, column: 3)
!77 = !DILocation(line: 44, column: 11, scope: !76)
!78 = !DILocation(line: 44, column: 7, scope: !76)
!79 = !DILocation(line: 44, column: 16, scope: !80)
!80 = distinct !DILexicalBlock(scope: !76, file: !3, line: 44, column: 3)
!81 = !DILocation(line: 44, column: 17, scope: !80)
!82 = !DILocation(line: 44, column: 3, scope: !76)
!83 = !DILocation(line: 45, column: 10, scope: !84)
!84 = distinct !DILexicalBlock(scope: !85, file: !3, line: 45, column: 8)
!85 = distinct !DILexicalBlock(scope: !80, file: !3, line: 44, column: 25)
!86 = !DILocation(line: 45, column: 8, scope: !84)
!87 = !DILocation(line: 45, column: 12, scope: !84)
!88 = !DILocation(line: 45, column: 8, scope: !85)
!89 = !DILocation(line: 46, column: 7, scope: !90)
!90 = distinct !DILexicalBlock(scope: !84, file: !3, line: 45, column: 16)
!91 = !DILocation(line: 47, column: 7, scope: !90)
!92 = !DILocation(line: 49, column: 3, scope: !85)
!93 = !DILocation(line: 44, column: 22, scope: !80)
!94 = !DILocation(line: 44, column: 3, scope: !80)
!95 = distinct !{!95, !82, !96}
!96 = !DILocation(line: 49, column: 3, scope: !76)
!97 = !DILocation(line: 52, column: 3, scope: !18)
!98 = !DILocation(line: 53, column: 1, scope: !18)
