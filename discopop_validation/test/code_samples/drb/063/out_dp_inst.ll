; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@n = dso_local global i32 100, align 4, !dbg !0
@m = dso_local global i32 100, align 4, !dbg !6
@b = dso_local global [100 x [100 x double]] zeroinitializer, align 16, !dbg !9
@.str = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"n\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"j\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"m\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.str.5 = private unnamed_addr constant [7 x i8] c"retval\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo() #0 !dbg !19 {
entry:
  call void @__dp_func_entry(i32 16438, i32 0)
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !22, metadata !DIExpression()), !dbg !23
  call void @llvm.dbg.declare(metadata i32* %j, metadata !24, metadata !DIExpression()), !dbg !25
  %0 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16442, i64 %0, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !26
  br label %for.cond, !dbg !28

for.cond:                                         ; preds = %for.inc10, %entry
  call void @__dp_loop_entry(i32 16442, i32 0)
  %1 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16442, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %2 = load i32, i32* %i, align 4, !dbg !29
  %3 = ptrtoint i32* @n to i64
  call void @__dp_read(i32 16442, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %4 = load i32, i32* @n, align 4, !dbg !31
  %cmp = icmp slt i32 %2, %4, !dbg !32
  br i1 %cmp, label %for.body, label %for.end12, !dbg !33

for.body:                                         ; preds = %for.cond
  %5 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16443, i64 %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %j, align 4, !dbg !34
  br label %for.cond1, !dbg !36

for.cond1:                                        ; preds = %for.inc, %for.body
  call void @__dp_loop_entry(i32 16443, i32 1)
  %6 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16443, i64 %6, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %7 = load i32, i32* %j, align 4, !dbg !37
  %8 = ptrtoint i32* @m to i64
  call void @__dp_read(i32 16443, i64 %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %9 = load i32, i32* @m, align 4, !dbg !39
  %sub = sub nsw i32 %9, 1, !dbg !40
  %cmp2 = icmp slt i32 %7, %sub, !dbg !41
  br i1 %cmp2, label %for.body3, label %for.end, !dbg !42

for.body3:                                        ; preds = %for.cond1
  %10 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16444, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %11 = load i32, i32* %i, align 4, !dbg !43
  %idxprom = sext i32 %11 to i64, !dbg !44
  %arrayidx = getelementptr inbounds [100 x [100 x double]], [100 x [100 x double]]* @b, i64 0, i64 %idxprom, !dbg !44
  %12 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16444, i64 %12, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %13 = load i32, i32* %j, align 4, !dbg !45
  %add = add nsw i32 %13, 1, !dbg !46
  %idxprom4 = sext i32 %add to i64, !dbg !44
  %arrayidx5 = getelementptr inbounds [100 x double], [100 x double]* %arrayidx, i64 0, i64 %idxprom4, !dbg !44
  %14 = ptrtoint double* %arrayidx5 to i64
  call void @__dp_read(i32 16444, i64 %14, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %15 = load double, double* %arrayidx5, align 8, !dbg !44
  %16 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16444, i64 %16, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %17 = load i32, i32* %i, align 4, !dbg !47
  %idxprom6 = sext i32 %17 to i64, !dbg !48
  %arrayidx7 = getelementptr inbounds [100 x [100 x double]], [100 x [100 x double]]* @b, i64 0, i64 %idxprom6, !dbg !48
  %18 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16444, i64 %18, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %19 = load i32, i32* %j, align 4, !dbg !49
  %idxprom8 = sext i32 %19 to i64, !dbg !48
  %arrayidx9 = getelementptr inbounds [100 x double], [100 x double]* %arrayidx7, i64 0, i64 %idxprom8, !dbg !48
  %20 = ptrtoint double* %arrayidx9 to i64
  call void @__dp_write(i32 16444, i64 %20, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store double %15, double* %arrayidx9, align 8, !dbg !50
  br label %for.inc, !dbg !48

for.inc:                                          ; preds = %for.body3
  %21 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16443, i64 %21, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %22 = load i32, i32* %j, align 4, !dbg !51
  %inc = add nsw i32 %22, 1, !dbg !51
  %23 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16443, i64 %23, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 %inc, i32* %j, align 4, !dbg !51
  br label %for.cond1, !dbg !52, !llvm.loop !53

for.end:                                          ; preds = %for.cond1
  call void @__dp_loop_exit(i32 16444, i32 1)
  br label %for.inc10, !dbg !54

for.inc10:                                        ; preds = %for.end
  %24 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16442, i64 %24, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %25 = load i32, i32* %i, align 4, !dbg !55
  %inc11 = add nsw i32 %25, 1, !dbg !55
  %26 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16442, i64 %26, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i32 %inc11, i32* %i, align 4, !dbg !55
  br label %for.cond, !dbg !56, !llvm.loop !57

for.end12:                                        ; preds = %for.cond
  call void @__dp_loop_exit(i32 16445, i32 0)
  call void @__dp_func_exit(i32 16445, i32 0), !dbg !59
  ret void, !dbg !59
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
define dso_local i32 @main() #0 !dbg !60 {
entry:
  call void @__dp_func_entry(i32 16447, i32 1)
  %retval = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16447, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.5, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @__dp_call(i32 16449), !dbg !63
  call void @foo(), !dbg !63
  call void @__dp_finalize(i32 16450), !dbg !64
  ret i32 0, !dbg !64
}

declare void @__dp_call(i32)

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!15}
!llvm.module.flags = !{!16, !17, !18}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "n", scope: !2, file: !3, line: 51, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/063")
!4 = !{}
!5 = !{!0, !6, !9}
!6 = !DIGlobalVariableExpression(var: !7, expr: !DIExpression())
!7 = distinct !DIGlobalVariable(name: "m", scope: !2, file: !3, line: 51, type: !8, isLocal: false, isDefinition: true)
!8 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!9 = !DIGlobalVariableExpression(var: !10, expr: !DIExpression())
!10 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !3, line: 52, type: !11, isLocal: false, isDefinition: true)
!11 = !DICompositeType(tag: DW_TAG_array_type, baseType: !12, size: 640000, elements: !13)
!12 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!13 = !{!14, !14}
!14 = !DISubrange(count: 100)
!15 = !{!"Ubuntu clang version 11.1.0-6"}
!16 = !{i32 7, !"Dwarf Version", i32 4}
!17 = !{i32 2, !"Debug Info Version", i32 3}
!18 = !{i32 1, !"wchar_size", i32 4}
!19 = distinct !DISubprogram(name: "foo", scope: !3, file: !3, line: 54, type: !20, scopeLine: 55, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!20 = !DISubroutineType(types: !21)
!21 = !{null}
!22 = !DILocalVariable(name: "i", scope: !19, file: !3, line: 56, type: !8)
!23 = !DILocation(line: 56, column: 7, scope: !19)
!24 = !DILocalVariable(name: "j", scope: !19, file: !3, line: 56, type: !8)
!25 = !DILocation(line: 56, column: 9, scope: !19)
!26 = !DILocation(line: 58, column: 9, scope: !27)
!27 = distinct !DILexicalBlock(scope: !19, file: !3, line: 58, column: 3)
!28 = !DILocation(line: 58, column: 8, scope: !27)
!29 = !DILocation(line: 58, column: 12, scope: !30)
!30 = distinct !DILexicalBlock(scope: !27, file: !3, line: 58, column: 3)
!31 = !DILocation(line: 58, column: 14, scope: !30)
!32 = !DILocation(line: 58, column: 13, scope: !30)
!33 = !DILocation(line: 58, column: 3, scope: !27)
!34 = !DILocation(line: 59, column: 11, scope: !35)
!35 = distinct !DILexicalBlock(scope: !30, file: !3, line: 59, column: 5)
!36 = !DILocation(line: 59, column: 10, scope: !35)
!37 = !DILocation(line: 59, column: 14, scope: !38)
!38 = distinct !DILexicalBlock(scope: !35, file: !3, line: 59, column: 5)
!39 = !DILocation(line: 59, column: 16, scope: !38)
!40 = !DILocation(line: 59, column: 17, scope: !38)
!41 = !DILocation(line: 59, column: 15, scope: !38)
!42 = !DILocation(line: 59, column: 5, scope: !35)
!43 = !DILocation(line: 60, column: 17, scope: !38)
!44 = !DILocation(line: 60, column: 15, scope: !38)
!45 = !DILocation(line: 60, column: 20, scope: !38)
!46 = !DILocation(line: 60, column: 21, scope: !38)
!47 = !DILocation(line: 60, column: 9, scope: !38)
!48 = !DILocation(line: 60, column: 7, scope: !38)
!49 = !DILocation(line: 60, column: 12, scope: !38)
!50 = !DILocation(line: 60, column: 14, scope: !38)
!51 = !DILocation(line: 59, column: 21, scope: !38)
!52 = !DILocation(line: 59, column: 5, scope: !38)
!53 = distinct !{!53, !42, !54}
!54 = !DILocation(line: 60, column: 23, scope: !35)
!55 = !DILocation(line: 58, column: 17, scope: !30)
!56 = !DILocation(line: 58, column: 3, scope: !30)
!57 = distinct !{!57, !33, !58}
!58 = !DILocation(line: 60, column: 23, scope: !27)
!59 = !DILocation(line: 61, column: 1, scope: !19)
!60 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 63, type: !61, scopeLine: 64, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!61 = !DISubroutineType(types: !62)
!62 = !{!8}
!63 = !DILocation(line: 65, column: 3, scope: !60)
!64 = !DILocation(line: 66, column: 3, scope: !60)
