; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x = internal global [20 x double] zeroinitializer, align 16, !dbg !0
@.str = private unnamed_addr constant [7 x i8] c"%f %f\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !14 {
entry:
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca double, align 8
  %k = alloca double, align 8
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata double* %j, metadata !20, metadata !DIExpression()), !dbg !21
  call void @llvm.dbg.declare(metadata double* %k, metadata !22, metadata !DIExpression()), !dbg !23
  store i32 0, i32* %i, align 4, !dbg !24
  br label %for.cond, !dbg !26

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !27
  %cmp = icmp slt i32 %0, 20, !dbg !29
  br i1 %cmp, label %for.body, label %for.end, !dbg !30

for.body:                                         ; preds = %for.cond
  %1 = load i32, i32* %i, align 4, !dbg !31
  %idxprom = sext i32 %1 to i64, !dbg !33
  %arrayidx = getelementptr inbounds [20 x double], [20 x double]* @x, i64 0, i64 %idxprom, !dbg !33
  store double -1.000000e+00, double* %arrayidx, align 8, !dbg !34
  %call = call i32 @omp_get_thread_num(), !dbg !35
  %cmp1 = icmp eq i32 %call, 0, !dbg !37
  br i1 %cmp1, label %if.then, label %if.end, !dbg !38

if.then:                                          ; preds = %for.body
  %2 = load double, double* getelementptr inbounds ([20 x double], [20 x double]* @x, i64 0, i64 0), align 16, !dbg !39
  store double %2, double* %j, align 8, !dbg !41
  br label %if.end, !dbg !42

if.end:                                           ; preds = %if.then, %for.body
  %call2 = call i32 @omp_get_thread_num(), !dbg !43
  %cmp3 = icmp eq i32 %call2, 0, !dbg !45
  br i1 %cmp3, label %if.then4, label %if.end5, !dbg !46

if.then4:                                         ; preds = %if.end
  %3 = load i32, i32* %i, align 4, !dbg !47
  %conv = sitofp i32 %3 to double, !dbg !47
  %add = fadd double %conv, 5.000000e-02, !dbg !49
  store double %add, double* %k, align 8, !dbg !50
  br label %if.end5, !dbg !51

if.end5:                                          ; preds = %if.then4, %if.end
  br label %for.inc, !dbg !52

for.inc:                                          ; preds = %if.end5
  %4 = load i32, i32* %i, align 4, !dbg !53
  %inc = add nsw i32 %4, 1, !dbg !53
  store i32 %inc, i32* %i, align 4, !dbg !53
  br label %for.cond, !dbg !54, !llvm.loop !55

for.end:                                          ; preds = %for.cond
  %5 = load double, double* %j, align 8, !dbg !57
  %6 = load double, double* %k, align 8, !dbg !58
  %call6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i64 0, i64 0), double %5, double %6), !dbg !59
  ret i32 0, !dbg !60
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @omp_get_thread_num() #2

declare dso_local i32 @printf(i8*, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!10, !11, !12}
!llvm.ident = !{!13}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 17, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/171")
!4 = !{}
!5 = !{!0}
!6 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 1280, elements: !8)
!7 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!8 = !{!9}
!9 = !DISubrange(count: 20)
!10 = !{i32 7, !"Dwarf Version", i32 4}
!11 = !{i32 2, !"Debug Info Version", i32 3}
!12 = !{i32 1, !"wchar_size", i32 4}
!13 = !{!"Ubuntu clang version 11.1.0-6"}
!14 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 20, type: !15, scopeLine: 20, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!15 = !DISubroutineType(types: !16)
!16 = !{!17}
!17 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!18 = !DILocalVariable(name: "i", scope: !14, file: !3, line: 21, type: !17)
!19 = !DILocation(line: 21, column: 7, scope: !14)
!20 = !DILocalVariable(name: "j", scope: !14, file: !3, line: 22, type: !7)
!21 = !DILocation(line: 22, column: 10, scope: !14)
!22 = !DILocalVariable(name: "k", scope: !14, file: !3, line: 22, type: !7)
!23 = !DILocation(line: 22, column: 12, scope: !14)
!24 = !DILocation(line: 25, column: 10, scope: !25)
!25 = distinct !DILexicalBlock(scope: !14, file: !3, line: 25, column: 3)
!26 = !DILocation(line: 25, column: 8, scope: !25)
!27 = !DILocation(line: 25, column: 15, scope: !28)
!28 = distinct !DILexicalBlock(scope: !25, file: !3, line: 25, column: 3)
!29 = !DILocation(line: 25, column: 17, scope: !28)
!30 = !DILocation(line: 25, column: 3, scope: !25)
!31 = !DILocation(line: 26, column: 7, scope: !32)
!32 = distinct !DILexicalBlock(scope: !28, file: !3, line: 25, column: 27)
!33 = !DILocation(line: 26, column: 5, scope: !32)
!34 = !DILocation(line: 26, column: 10, scope: !32)
!35 = !DILocation(line: 27, column: 8, scope: !36)
!36 = distinct !DILexicalBlock(scope: !32, file: !3, line: 27, column: 8)
!37 = !DILocation(line: 27, column: 28, scope: !36)
!38 = !DILocation(line: 27, column: 8, scope: !32)
!39 = !DILocation(line: 28, column: 11, scope: !40)
!40 = distinct !DILexicalBlock(scope: !36, file: !3, line: 27, column: 32)
!41 = !DILocation(line: 28, column: 9, scope: !40)
!42 = !DILocation(line: 29, column: 5, scope: !40)
!43 = !DILocation(line: 30, column: 8, scope: !44)
!44 = distinct !DILexicalBlock(scope: !32, file: !3, line: 30, column: 8)
!45 = !DILocation(line: 30, column: 28, scope: !44)
!46 = !DILocation(line: 30, column: 8, scope: !32)
!47 = !DILocation(line: 31, column: 11, scope: !48)
!48 = distinct !DILexicalBlock(scope: !44, file: !3, line: 30, column: 32)
!49 = !DILocation(line: 31, column: 12, scope: !48)
!50 = !DILocation(line: 31, column: 9, scope: !48)
!51 = !DILocation(line: 32, column: 5, scope: !48)
!52 = !DILocation(line: 33, column: 3, scope: !32)
!53 = !DILocation(line: 25, column: 24, scope: !28)
!54 = !DILocation(line: 25, column: 3, scope: !28)
!55 = distinct !{!55, !30, !56}
!56 = !DILocation(line: 33, column: 3, scope: !25)
!57 = !DILocation(line: 35, column: 22, scope: !14)
!58 = !DILocation(line: 35, column: 25, scope: !14)
!59 = !DILocation(line: 35, column: 3, scope: !14)
!60 = !DILocation(line: 37, column: 3, scope: !14)
