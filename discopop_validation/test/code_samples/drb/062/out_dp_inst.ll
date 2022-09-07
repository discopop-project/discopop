; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@a = dso_local global [1000 x [1000 x double]] zeroinitializer, align 16, !dbg !0
@v = dso_local global [1000 x double] zeroinitializer, align 16, !dbg !6
@v_out = dso_local global [1000 x double] zeroinitializer, align 16, !dbg !12
@.str = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"sum\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"j\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"v\00", align 1
@.str.5 = private unnamed_addr constant [6 x i8] c"v_out\00", align 1
@.str.6 = private unnamed_addr constant [7 x i8] c"retval\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @mv() #0 !dbg !20 {
entry:
  call void @__dp_func_entry(i32 16437, i32 0)
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %sum = alloca float, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !23, metadata !DIExpression()), !dbg !25
  call void @llvm.dbg.declare(metadata i32* %j, metadata !26, metadata !DIExpression()), !dbg !27
  %0 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16440, i64 %0, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !28
  br label %for.cond, !dbg !30

for.cond:                                         ; preds = %for.inc12, %entry
  call void @__dp_loop_entry(i32 16440, i32 0)
  %1 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16440, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %2 = load i32, i32* %i, align 4, !dbg !31
  %cmp = icmp slt i32 %2, 1000, !dbg !33
  br i1 %cmp, label %for.body, label %for.end14, !dbg !34

for.body:                                         ; preds = %for.cond
  call void @llvm.dbg.declare(metadata float* %sum, metadata !35, metadata !DIExpression()), !dbg !38
  %3 = ptrtoint float* %sum to i64
  call void @__dp_write(i32 16442, i64 %3, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0))
  store float 0.000000e+00, float* %sum, align 4, !dbg !38
  %4 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16444, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %j, align 4, !dbg !39
  br label %for.cond1, !dbg !41

for.cond1:                                        ; preds = %for.inc, %for.body
  call void @__dp_loop_entry(i32 16444, i32 1)
  %5 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16444, i64 %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %6 = load i32, i32* %j, align 4, !dbg !42
  %cmp2 = icmp slt i32 %6, 1000, !dbg !44
  br i1 %cmp2, label %for.body3, label %for.end, !dbg !45

for.body3:                                        ; preds = %for.cond1
  %7 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16446, i64 %7, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %8 = load i32, i32* %i, align 4, !dbg !46
  %idxprom = sext i32 %8 to i64, !dbg !48
  %arrayidx = getelementptr inbounds [1000 x [1000 x double]], [1000 x [1000 x double]]* @a, i64 0, i64 %idxprom, !dbg !48
  %9 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16446, i64 %9, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %10 = load i32, i32* %j, align 4, !dbg !49
  %idxprom4 = sext i32 %10 to i64, !dbg !48
  %arrayidx5 = getelementptr inbounds [1000 x double], [1000 x double]* %arrayidx, i64 0, i64 %idxprom4, !dbg !48
  %11 = ptrtoint double* %arrayidx5 to i64
  call void @__dp_read(i32 16446, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %12 = load double, double* %arrayidx5, align 8, !dbg !48
  %13 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16446, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %14 = load i32, i32* %j, align 4, !dbg !50
  %idxprom6 = sext i32 %14 to i64, !dbg !51
  %arrayidx7 = getelementptr inbounds [1000 x double], [1000 x double]* @v, i64 0, i64 %idxprom6, !dbg !51
  %15 = ptrtoint double* %arrayidx7 to i64
  call void @__dp_read(i32 16446, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %16 = load double, double* %arrayidx7, align 8, !dbg !51
  %mul = fmul double %12, %16, !dbg !52
  %17 = ptrtoint float* %sum to i64
  call void @__dp_read(i32 16446, i64 %17, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0))
  %18 = load float, float* %sum, align 4, !dbg !53
  %conv = fpext float %18 to double, !dbg !53
  %add = fadd double %conv, %mul, !dbg !53
  %conv8 = fptrunc double %add to float, !dbg !53
  %19 = ptrtoint float* %sum to i64
  call void @__dp_write(i32 16446, i64 %19, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0))
  store float %conv8, float* %sum, align 4, !dbg !53
  br label %for.inc, !dbg !54

for.inc:                                          ; preds = %for.body3
  %20 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16444, i64 %20, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %21 = load i32, i32* %j, align 4, !dbg !55
  %inc = add nsw i32 %21, 1, !dbg !55
  %22 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16444, i64 %22, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 %inc, i32* %j, align 4, !dbg !55
  br label %for.cond1, !dbg !56, !llvm.loop !57

for.end:                                          ; preds = %for.cond1
  call void @__dp_loop_exit(i32 16448, i32 1)
  %23 = ptrtoint float* %sum to i64
  call void @__dp_read(i32 16448, i64 %23, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0))
  %24 = load float, float* %sum, align 4, !dbg !59
  %conv9 = fpext float %24 to double, !dbg !59
  %25 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16448, i64 %25, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %26 = load i32, i32* %i, align 4, !dbg !60
  %idxprom10 = sext i32 %26 to i64, !dbg !61
  %arrayidx11 = getelementptr inbounds [1000 x double], [1000 x double]* @v_out, i64 0, i64 %idxprom10, !dbg !61
  %27 = ptrtoint double* %arrayidx11 to i64
  call void @__dp_write(i32 16448, i64 %27, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.5, i32 0, i32 0))
  store double %conv9, double* %arrayidx11, align 8, !dbg !62
  br label %for.inc12, !dbg !63

for.inc12:                                        ; preds = %for.end
  %28 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16440, i64 %28, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %29 = load i32, i32* %i, align 4, !dbg !64
  %inc13 = add nsw i32 %29, 1, !dbg !64
  %30 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16440, i64 %30, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i32 %inc13, i32* %i, align 4, !dbg !64
  br label %for.cond, !dbg !65, !llvm.loop !66

for.end14:                                        ; preds = %for.cond
  call void @__dp_loop_exit(i32 16450, i32 0)
  call void @__dp_func_exit(i32 16450, i32 0), !dbg !68
  ret void, !dbg !68
}

declare void @__dp_func_entry(i32, i32)

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_write(i32, i64, i8*)

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_loop_exit(i32, i32)

declare void @__dp_func_exit(i32, i32)

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !69 {
entry:
  call void @__dp_func_entry(i32 16452, i32 1)
  %retval = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16452, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.6, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @__dp_call(i32 16454), !dbg !72
  call void @mv(), !dbg !72
  call void @__dp_finalize(i32 16455), !dbg !73
  ret i32 0, !dbg !73
}

declare void @__dp_call(i32)

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!16}
!llvm.module.flags = !{!17, !18, !19}

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
!16 = !{!"Ubuntu clang version 11.1.0-6"}
!17 = !{i32 7, !"Dwarf Version", i32 4}
!18 = !{i32 2, !"Debug Info Version", i32 3}
!19 = !{i32 1, !"wchar_size", i32 4}
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
