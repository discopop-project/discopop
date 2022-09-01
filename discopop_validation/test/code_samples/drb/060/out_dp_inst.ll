; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@c = dso_local global [100 x [100 x double]] zeroinitializer, align 16, !dbg !0
@a = dso_local global [100 x [100 x double]] zeroinitializer, align 16, !dbg !6
@b = dso_local global [100 x [100 x double]] zeroinitializer, align 16, !dbg !12
@.str = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"k\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"j\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"c\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.str.6 = private unnamed_addr constant [7 x i8] c"retval\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @mmm() #0 !dbg !18 {
entry:
  call void @__dp_func_entry(i32 16440, i32 0)
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !22, metadata !DIExpression()), !dbg !23
  call void @llvm.dbg.declare(metadata i32* %j, metadata !24, metadata !DIExpression()), !dbg !25
  call void @llvm.dbg.declare(metadata i32* %k, metadata !26, metadata !DIExpression()), !dbg !27
  %0 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16444, i64 %0, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !28
  br label %for.cond, !dbg !30

for.cond:                                         ; preds = %for.inc24, %entry
  call void @__dp_loop_entry(i32 16444, i32 0)
  %1 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16444, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %2 = load i32, i32* %i, align 4, !dbg !31
  %cmp = icmp slt i32 %2, 100, !dbg !33
  br i1 %cmp, label %for.body, label %for.end26, !dbg !34

for.body:                                         ; preds = %for.cond
  %3 = ptrtoint i32* %k to i64
  call void @__dp_write(i32 16445, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %k, align 4, !dbg !35
  br label %for.cond1, !dbg !37

for.cond1:                                        ; preds = %for.inc21, %for.body
  call void @__dp_loop_entry(i32 16445, i32 1)
  %4 = ptrtoint i32* %k to i64
  call void @__dp_read(i32 16445, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %5 = load i32, i32* %k, align 4, !dbg !38
  %cmp2 = icmp slt i32 %5, 100, !dbg !40
  br i1 %cmp2, label %for.body3, label %for.end23, !dbg !41

for.body3:                                        ; preds = %for.cond1
  %6 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16446, i64 %6, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %j, align 4, !dbg !42
  br label %for.cond4, !dbg !44

for.cond4:                                        ; preds = %for.inc, %for.body3
  call void @__dp_loop_entry(i32 16446, i32 2)
  %7 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16446, i64 %7, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %8 = load i32, i32* %j, align 4, !dbg !45
  %cmp5 = icmp slt i32 %8, 100, !dbg !47
  br i1 %cmp5, label %for.body6, label %for.end, !dbg !48

for.body6:                                        ; preds = %for.cond4
  %9 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16447, i64 %9, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %10 = load i32, i32* %i, align 4, !dbg !49
  %idxprom = sext i32 %10 to i64, !dbg !50
  %arrayidx = getelementptr inbounds [100 x [100 x double]], [100 x [100 x double]]* @c, i64 0, i64 %idxprom, !dbg !50
  %11 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16447, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %12 = load i32, i32* %j, align 4, !dbg !51
  %idxprom7 = sext i32 %12 to i64, !dbg !50
  %arrayidx8 = getelementptr inbounds [100 x double], [100 x double]* %arrayidx, i64 0, i64 %idxprom7, !dbg !50
  %13 = ptrtoint double* %arrayidx8 to i64
  call void @__dp_read(i32 16447, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %14 = load double, double* %arrayidx8, align 8, !dbg !50
  %15 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16447, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %16 = load i32, i32* %i, align 4, !dbg !52
  %idxprom9 = sext i32 %16 to i64, !dbg !53
  %arrayidx10 = getelementptr inbounds [100 x [100 x double]], [100 x [100 x double]]* @a, i64 0, i64 %idxprom9, !dbg !53
  %17 = ptrtoint i32* %k to i64
  call void @__dp_read(i32 16447, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %18 = load i32, i32* %k, align 4, !dbg !54
  %idxprom11 = sext i32 %18 to i64, !dbg !53
  %arrayidx12 = getelementptr inbounds [100 x double], [100 x double]* %arrayidx10, i64 0, i64 %idxprom11, !dbg !53
  %19 = ptrtoint double* %arrayidx12 to i64
  call void @__dp_read(i32 16447, i64 %19, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %20 = load double, double* %arrayidx12, align 8, !dbg !53
  %21 = ptrtoint i32* %k to i64
  call void @__dp_read(i32 16447, i64 %21, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %22 = load i32, i32* %k, align 4, !dbg !55
  %idxprom13 = sext i32 %22 to i64, !dbg !56
  %arrayidx14 = getelementptr inbounds [100 x [100 x double]], [100 x [100 x double]]* @b, i64 0, i64 %idxprom13, !dbg !56
  %23 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16447, i64 %23, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %24 = load i32, i32* %j, align 4, !dbg !57
  %idxprom15 = sext i32 %24 to i64, !dbg !56
  %arrayidx16 = getelementptr inbounds [100 x double], [100 x double]* %arrayidx14, i64 0, i64 %idxprom15, !dbg !56
  %25 = ptrtoint double* %arrayidx16 to i64
  call void @__dp_read(i32 16447, i64 %25, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %26 = load double, double* %arrayidx16, align 8, !dbg !56
  %mul = fmul double %20, %26, !dbg !58
  %add = fadd double %14, %mul, !dbg !59
  %27 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16447, i64 %27, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %28 = load i32, i32* %i, align 4, !dbg !60
  %idxprom17 = sext i32 %28 to i64, !dbg !61
  %arrayidx18 = getelementptr inbounds [100 x [100 x double]], [100 x [100 x double]]* @c, i64 0, i64 %idxprom17, !dbg !61
  %29 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16447, i64 %29, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %30 = load i32, i32* %j, align 4, !dbg !62
  %idxprom19 = sext i32 %30 to i64, !dbg !61
  %arrayidx20 = getelementptr inbounds [100 x double], [100 x double]* %arrayidx18, i64 0, i64 %idxprom19, !dbg !61
  %31 = ptrtoint double* %arrayidx20 to i64
  call void @__dp_write(i32 16447, i64 %31, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store double %add, double* %arrayidx20, align 8, !dbg !63
  br label %for.inc, !dbg !61

for.inc:                                          ; preds = %for.body6
  %32 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16446, i64 %32, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %33 = load i32, i32* %j, align 4, !dbg !64
  %inc = add nsw i32 %33, 1, !dbg !64
  %34 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16446, i64 %34, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 %inc, i32* %j, align 4, !dbg !64
  br label %for.cond4, !dbg !65, !llvm.loop !66

for.end:                                          ; preds = %for.cond4
  call void @__dp_loop_exit(i32 16447, i32 2)
  br label %for.inc21, !dbg !67

for.inc21:                                        ; preds = %for.end
  %35 = ptrtoint i32* %k to i64
  call void @__dp_read(i32 16445, i64 %35, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %36 = load i32, i32* %k, align 4, !dbg !68
  %inc22 = add nsw i32 %36, 1, !dbg !68
  %37 = ptrtoint i32* %k to i64
  call void @__dp_write(i32 16445, i64 %37, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 %inc22, i32* %k, align 4, !dbg !68
  br label %for.cond1, !dbg !69, !llvm.loop !70

for.end23:                                        ; preds = %for.cond1
  call void @__dp_loop_exit(i32 16447, i32 1)
  br label %for.inc24, !dbg !71

for.inc24:                                        ; preds = %for.end23
  %38 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16444, i64 %38, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %39 = load i32, i32* %i, align 4, !dbg !72
  %inc25 = add nsw i32 %39, 1, !dbg !72
  %40 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16444, i64 %40, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i32 %inc25, i32* %i, align 4, !dbg !72
  br label %for.cond, !dbg !73, !llvm.loop !74

for.end26:                                        ; preds = %for.cond
  call void @__dp_loop_exit(i32 16448, i32 0)
  call void @__dp_func_exit(i32 16448, i32 0), !dbg !76
  ret i32 0, !dbg !76
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
define dso_local i32 @main() #0 !dbg !77 {
entry:
  call void @__dp_func_entry(i32 16451, i32 1)
  %retval = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16451, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.6, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @__dp_call(i32 16453), !dbg !78
  %call = call i32 @mmm(), !dbg !78
  call void @__dp_finalize(i32 16454), !dbg !79
  ret i32 0, !dbg !79
}

declare void @__dp_call(i32)

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!14}
!llvm.module.flags = !{!15, !16, !17}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !3, line: 54, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/060")
!4 = !{}
!5 = !{!6, !12, !0}
!6 = !DIGlobalVariableExpression(var: !7, expr: !DIExpression())
!7 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 54, type: !8, isLocal: false, isDefinition: true)
!8 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 640000, elements: !10)
!9 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!10 = !{!11, !11}
!11 = !DISubrange(count: 100)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !3, line: 54, type: !8, isLocal: false, isDefinition: true)
!14 = !{!"Ubuntu clang version 11.1.0-6"}
!15 = !{i32 7, !"Dwarf Version", i32 4}
!16 = !{i32 2, !"Debug Info Version", i32 3}
!17 = !{i32 1, !"wchar_size", i32 4}
!18 = distinct !DISubprogram(name: "mmm", scope: !3, file: !3, line: 56, type: !19, scopeLine: 57, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!19 = !DISubroutineType(types: !20)
!20 = !{!21}
!21 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!22 = !DILocalVariable(name: "i", scope: !18, file: !3, line: 58, type: !21)
!23 = !DILocation(line: 58, column: 7, scope: !18)
!24 = !DILocalVariable(name: "j", scope: !18, file: !3, line: 58, type: !21)
!25 = !DILocation(line: 58, column: 9, scope: !18)
!26 = !DILocalVariable(name: "k", scope: !18, file: !3, line: 58, type: !21)
!27 = !DILocation(line: 58, column: 11, scope: !18)
!28 = !DILocation(line: 60, column: 10, scope: !29)
!29 = distinct !DILexicalBlock(scope: !18, file: !3, line: 60, column: 3)
!30 = !DILocation(line: 60, column: 8, scope: !29)
!31 = !DILocation(line: 60, column: 15, scope: !32)
!32 = distinct !DILexicalBlock(scope: !29, file: !3, line: 60, column: 3)
!33 = !DILocation(line: 60, column: 17, scope: !32)
!34 = !DILocation(line: 60, column: 3, scope: !29)
!35 = !DILocation(line: 61, column: 12, scope: !36)
!36 = distinct !DILexicalBlock(scope: !32, file: !3, line: 61, column: 5)
!37 = !DILocation(line: 61, column: 10, scope: !36)
!38 = !DILocation(line: 61, column: 17, scope: !39)
!39 = distinct !DILexicalBlock(scope: !36, file: !3, line: 61, column: 5)
!40 = !DILocation(line: 61, column: 19, scope: !39)
!41 = !DILocation(line: 61, column: 5, scope: !36)
!42 = !DILocation(line: 62, column: 14, scope: !43)
!43 = distinct !DILexicalBlock(scope: !39, file: !3, line: 62, column: 7)
!44 = !DILocation(line: 62, column: 12, scope: !43)
!45 = !DILocation(line: 62, column: 19, scope: !46)
!46 = distinct !DILexicalBlock(scope: !43, file: !3, line: 62, column: 7)
!47 = !DILocation(line: 62, column: 21, scope: !46)
!48 = !DILocation(line: 62, column: 7, scope: !43)
!49 = !DILocation(line: 63, column: 20, scope: !46)
!50 = !DILocation(line: 63, column: 18, scope: !46)
!51 = !DILocation(line: 63, column: 23, scope: !46)
!52 = !DILocation(line: 63, column: 28, scope: !46)
!53 = !DILocation(line: 63, column: 26, scope: !46)
!54 = !DILocation(line: 63, column: 31, scope: !46)
!55 = !DILocation(line: 63, column: 36, scope: !46)
!56 = !DILocation(line: 63, column: 34, scope: !46)
!57 = !DILocation(line: 63, column: 39, scope: !46)
!58 = !DILocation(line: 63, column: 33, scope: !46)
!59 = !DILocation(line: 63, column: 25, scope: !46)
!60 = !DILocation(line: 63, column: 11, scope: !46)
!61 = !DILocation(line: 63, column: 9, scope: !46)
!62 = !DILocation(line: 63, column: 14, scope: !46)
!63 = !DILocation(line: 63, column: 16, scope: !46)
!64 = !DILocation(line: 62, column: 27, scope: !46)
!65 = !DILocation(line: 62, column: 7, scope: !46)
!66 = distinct !{!66, !48, !67}
!67 = !DILocation(line: 63, column: 40, scope: !43)
!68 = !DILocation(line: 61, column: 25, scope: !39)
!69 = !DILocation(line: 61, column: 5, scope: !39)
!70 = distinct !{!70, !41, !71}
!71 = !DILocation(line: 63, column: 40, scope: !36)
!72 = !DILocation(line: 60, column: 23, scope: !32)
!73 = !DILocation(line: 60, column: 3, scope: !32)
!74 = distinct !{!74, !34, !75}
!75 = !DILocation(line: 63, column: 40, scope: !29)
!76 = !DILocation(line: 64, column: 3, scope: !18)
!77 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 67, type: !19, scopeLine: 68, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!78 = !DILocation(line: 69, column: 3, scope: !77)
!79 = !DILocation(line: 70, column: 3, scope: !77)
