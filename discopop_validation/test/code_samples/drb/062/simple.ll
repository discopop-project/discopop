; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@a = dso_local global [1000 x [1000 x double]] zeroinitializer, align 16, !dbg !0
@v = dso_local global [1000 x double] zeroinitializer, align 16, !dbg !6
@v_out = dso_local global [1000 x double] zeroinitializer, align 16, !dbg !12

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @mv() #0 !dbg !20 {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %sum = alloca float, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !23, metadata !DIExpression()), !dbg !25
  call void @llvm.dbg.declare(metadata i32* %j, metadata !26, metadata !DIExpression()), !dbg !27
  store i32 0, i32* %i, align 4, !dbg !28
  br label %for.cond, !dbg !30

for.cond:                                         ; preds = %for.inc12, %entry
  %0 = load i32, i32* %i, align 4, !dbg !31
  %cmp = icmp slt i32 %0, 1000, !dbg !33
  br i1 %cmp, label %for.body, label %for.end14, !dbg !34

for.body:                                         ; preds = %for.cond
  call void @llvm.dbg.declare(metadata float* %sum, metadata !35, metadata !DIExpression()), !dbg !38
  store float 0.000000e+00, float* %sum, align 4, !dbg !38
  store i32 0, i32* %j, align 4, !dbg !39
  br label %for.cond1, !dbg !41

for.cond1:                                        ; preds = %for.inc, %for.body
  %1 = load i32, i32* %j, align 4, !dbg !42
  %cmp2 = icmp slt i32 %1, 1000, !dbg !44
  br i1 %cmp2, label %for.body3, label %for.end, !dbg !45

for.body3:                                        ; preds = %for.cond1
  %2 = load i32, i32* %i, align 4, !dbg !46
  %idxprom = sext i32 %2 to i64, !dbg !48
  %arrayidx = getelementptr inbounds [1000 x [1000 x double]], [1000 x [1000 x double]]* @a, i64 0, i64 %idxprom, !dbg !48
  %3 = load i32, i32* %j, align 4, !dbg !49
  %idxprom4 = sext i32 %3 to i64, !dbg !48
  %arrayidx5 = getelementptr inbounds [1000 x double], [1000 x double]* %arrayidx, i64 0, i64 %idxprom4, !dbg !48
  %4 = load double, double* %arrayidx5, align 8, !dbg !48
  %5 = load i32, i32* %j, align 4, !dbg !50
  %idxprom6 = sext i32 %5 to i64, !dbg !51
  %arrayidx7 = getelementptr inbounds [1000 x double], [1000 x double]* @v, i64 0, i64 %idxprom6, !dbg !51
  %6 = load double, double* %arrayidx7, align 8, !dbg !51
  %mul = fmul double %4, %6, !dbg !52
  %7 = load float, float* %sum, align 4, !dbg !53
  %conv = fpext float %7 to double, !dbg !53
  %add = fadd double %conv, %mul, !dbg !53
  %conv8 = fptrunc double %add to float, !dbg !53
  store float %conv8, float* %sum, align 4, !dbg !53
  br label %for.inc, !dbg !54

for.inc:                                          ; preds = %for.body3
  %8 = load i32, i32* %j, align 4, !dbg !55
  %inc = add nsw i32 %8, 1, !dbg !55
  store i32 %inc, i32* %j, align 4, !dbg !55
  br label %for.cond1, !dbg !56, !llvm.loop !57

for.end:                                          ; preds = %for.cond1
  %9 = load float, float* %sum, align 4, !dbg !59
  %conv9 = fpext float %9 to double, !dbg !59
  %10 = load i32, i32* %i, align 4, !dbg !60
  %idxprom10 = sext i32 %10 to i64, !dbg !61
  %arrayidx11 = getelementptr inbounds [1000 x double], [1000 x double]* @v_out, i64 0, i64 %idxprom10, !dbg !61
  store double %conv9, double* %arrayidx11, align 8, !dbg !62
  br label %for.inc12, !dbg !63

for.inc12:                                        ; preds = %for.end
  %11 = load i32, i32* %i, align 4, !dbg !64
  %inc13 = add nsw i32 %11, 1, !dbg !64
  store i32 %inc13, i32* %i, align 4, !dbg !64
  br label %for.cond, !dbg !65, !llvm.loop !66

for.end14:                                        ; preds = %for.cond
  ret void, !dbg !68
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !69 {
entry:
  %retval = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @mv(), !dbg !72
  ret i32 0, !dbg !73
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!16, !17, !18}
!llvm.ident = !{!19}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 51, type: !14, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/062")
!4 = !{}
!5 = !{!0, !6, !12}
!6 = !DIGlobalVariableExpression(var: !7, expr: !DIExpression())
!7 = distinct !DIGlobalVariable(name: "v", scope: !2, file: !3, line: 51, type: !8, isLocal: false, isDefinition: true)
!8 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 64000, elements: !10)
!9 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!10 = !{!11}
!11 = !DISubrange(count: 1000)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(name: "v_out", scope: !2, file: !3, line: 51, type: !8, isLocal: false, isDefinition: true)
!14 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 64000000, elements: !15)
!15 = !{!11, !11}
!16 = !{i32 7, !"Dwarf Version", i32 4}
!17 = !{i32 2, !"Debug Info Version", i32 3}
!18 = !{i32 1, !"wchar_size", i32 4}
!19 = !{!"Ubuntu clang version 11.1.0-6"}
!20 = distinct !DISubprogram(name: "mv", scope: !3, file: !3, line: 53, type: !21, scopeLine: 54, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!21 = !DISubroutineType(types: !22)
!22 = !{null}
!23 = !DILocalVariable(name: "i", scope: !20, file: !3, line: 55, type: !24)
!24 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!25 = !DILocation(line: 55, column: 7, scope: !20)
!26 = !DILocalVariable(name: "j", scope: !20, file: !3, line: 55, type: !24)
!27 = !DILocation(line: 55, column: 9, scope: !20)
!28 = !DILocation(line: 56, column: 10, scope: !29)
!29 = distinct !DILexicalBlock(scope: !20, file: !3, line: 56, column: 3)
!30 = !DILocation(line: 56, column: 8, scope: !29)
!31 = !DILocation(line: 56, column: 15, scope: !32)
!32 = distinct !DILexicalBlock(scope: !29, file: !3, line: 56, column: 3)
!33 = !DILocation(line: 56, column: 17, scope: !32)
!34 = !DILocation(line: 56, column: 3, scope: !29)
!35 = !DILocalVariable(name: "sum", scope: !36, file: !3, line: 58, type: !37)
!36 = distinct !DILexicalBlock(scope: !32, file: !3, line: 57, column: 3)
!37 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!38 = !DILocation(line: 58, column: 11, scope: !36)
!39 = !DILocation(line: 60, column: 12, scope: !40)
!40 = distinct !DILexicalBlock(scope: !36, file: !3, line: 60, column: 5)
!41 = !DILocation(line: 60, column: 10, scope: !40)
!42 = !DILocation(line: 60, column: 17, scope: !43)
!43 = distinct !DILexicalBlock(scope: !40, file: !3, line: 60, column: 5)
!44 = !DILocation(line: 60, column: 19, scope: !43)
!45 = !DILocation(line: 60, column: 5, scope: !40)
!46 = !DILocation(line: 62, column: 16, scope: !47)
!47 = distinct !DILexicalBlock(scope: !43, file: !3, line: 61, column: 5)
!48 = !DILocation(line: 62, column: 14, scope: !47)
!49 = !DILocation(line: 62, column: 19, scope: !47)
!50 = !DILocation(line: 62, column: 24, scope: !47)
!51 = !DILocation(line: 62, column: 22, scope: !47)
!52 = !DILocation(line: 62, column: 21, scope: !47)
!53 = !DILocation(line: 62, column: 11, scope: !47)
!54 = !DILocation(line: 63, column: 5, scope: !47)
!55 = !DILocation(line: 60, column: 25, scope: !43)
!56 = !DILocation(line: 60, column: 5, scope: !43)
!57 = distinct !{!57, !45, !58}
!58 = !DILocation(line: 63, column: 5, scope: !40)
!59 = !DILocation(line: 64, column: 16, scope: !36)
!60 = !DILocation(line: 64, column: 11, scope: !36)
!61 = !DILocation(line: 64, column: 5, scope: !36)
!62 = !DILocation(line: 64, column: 14, scope: !36)
!63 = !DILocation(line: 65, column: 3, scope: !36)
!64 = !DILocation(line: 56, column: 23, scope: !32)
!65 = !DILocation(line: 56, column: 3, scope: !32)
!66 = distinct !{!66, !34, !67}
!67 = !DILocation(line: 65, column: 3, scope: !29)
!68 = !DILocation(line: 66, column: 1, scope: !20)
!69 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 68, type: !70, scopeLine: 69, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!70 = !DISubroutineType(types: !71)
!71 = !{!24}
!72 = !DILocation(line: 70, column: 3, scope: !69)
!73 = !DILocation(line: 71, column: 3, scope: !69)
