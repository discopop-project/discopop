; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@a = dso_local global [100 x [100 x i32]] zeroinitializer, align 16, !dbg !0
@.str.1 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"j\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"*\00", align 1
@.str = private unnamed_addr constant [14 x i8] c"a[50][50]=%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !14 {
entry:
  call void @__dp_func_entry(i32 16444, i32 1)
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16444, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !17, metadata !DIExpression()), !dbg !18
  call void @llvm.dbg.declare(metadata i32* %j, metadata !19, metadata !DIExpression()), !dbg !20
  %1 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16452, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !21
  br label %for.cond, !dbg !25

for.cond:                                         ; preds = %for.inc6, %entry
  call void @__dp_loop_entry(i32 16452, i32 0)
  %2 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16452, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %3 = load i32, i32* %i, align 4, !dbg !26
  %cmp = icmp slt i32 %3, 100, !dbg !28
  br i1 %cmp, label %for.body, label %for.end8, !dbg !29

for.body:                                         ; preds = %for.cond
  %4 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16453, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 0, i32* %j, align 4, !dbg !30
  br label %for.cond1, !dbg !32

for.cond1:                                        ; preds = %for.inc, %for.body
  call void @__dp_loop_entry(i32 16453, i32 1)
  %5 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16453, i64 %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %6 = load i32, i32* %j, align 4, !dbg !33
  %cmp2 = icmp slt i32 %6, 100, !dbg !35
  br i1 %cmp2, label %for.body3, label %for.end, !dbg !36

for.body3:                                        ; preds = %for.cond1
  %7 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16454, i64 %7, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %8 = load i32, i32* %i, align 4, !dbg !37
  %idxprom = sext i32 %8 to i64, !dbg !38
  %arrayidx = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* @a, i64 0, i64 %idxprom, !dbg !38
  %9 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16454, i64 %9, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %10 = load i32, i32* %j, align 4, !dbg !39
  %idxprom4 = sext i32 %10 to i64, !dbg !38
  %arrayidx5 = getelementptr inbounds [100 x i32], [100 x i32]* %arrayidx, i64 0, i64 %idxprom4, !dbg !38
  %11 = ptrtoint i32* %arrayidx5 to i64
  call void @__dp_read(i32 16454, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %12 = load i32, i32* %arrayidx5, align 4, !dbg !40
  %add = add nsw i32 %12, 1, !dbg !40
  %13 = ptrtoint i32* %arrayidx5 to i64
  call void @__dp_write(i32 16454, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 %add, i32* %arrayidx5, align 4, !dbg !40
  br label %for.inc, !dbg !38

for.inc:                                          ; preds = %for.body3
  %14 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16453, i64 %14, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %15 = load i32, i32* %j, align 4, !dbg !41
  %inc = add nsw i32 %15, 1, !dbg !41
  %16 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16453, i64 %16, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 %inc, i32* %j, align 4, !dbg !41
  br label %for.cond1, !dbg !42, !llvm.loop !43

for.end:                                          ; preds = %for.cond1
  call void @__dp_loop_exit(i32 16454, i32 1)
  br label %for.inc6, !dbg !44

for.inc6:                                         ; preds = %for.end
  %17 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16452, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %18 = load i32, i32* %i, align 4, !dbg !45
  %inc7 = add nsw i32 %18, 1, !dbg !45
  %19 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16452, i64 %19, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 %inc7, i32* %i, align 4, !dbg !45
  br label %for.cond, !dbg !46, !llvm.loop !47

for.end8:                                         ; preds = %for.cond
  call void @__dp_loop_exit(i32 16457, i32 0)
  %20 = ptrtoint i32* getelementptr inbounds ([100 x [100 x i32]], [100 x [100 x i32]]* @a, i64 0, i64 50, i64 50) to i64
  call void @__dp_read(i32 16457, i64 %20, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %21 = load i32, i32* getelementptr inbounds ([100 x [100 x i32]], [100 x [100 x i32]]* @a, i64 0, i64 50, i64 50), align 8, !dbg !49
  call void @__dp_call(i32 16457), !dbg !50
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str, i64 0, i64 0), i32 %21), !dbg !50
  call void @__dp_finalize(i32 16458), !dbg !51
  ret i32 0, !dbg !51
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_loop_exit(i32, i32)

declare void @__dp_call(i32)

declare dso_local i32 @printf(i8*, ...) #2

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!10}
!llvm.module.flags = !{!11, !12, !13}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 59, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/095")
!4 = !{}
!5 = !{!0}
!6 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 320000, elements: !8)
!7 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!8 = !{!9, !9}
!9 = !DISubrange(count: 100)
!10 = !{!"Ubuntu clang version 11.1.0-6"}
!11 = !{i32 7, !"Dwarf Version", i32 4}
!12 = !{i32 2, !"Debug Info Version", i32 3}
!13 = !{i32 1, !"wchar_size", i32 4}
!14 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 60, type: !15, scopeLine: 61, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!15 = !DISubroutineType(types: !16)
!16 = !{!7}
!17 = !DILocalVariable(name: "i", scope: !14, file: !3, line: 62, type: !7)
!18 = !DILocation(line: 62, column: 7, scope: !14)
!19 = !DILocalVariable(name: "j", scope: !14, file: !3, line: 62, type: !7)
!20 = !DILocation(line: 62, column: 10, scope: !14)
!21 = !DILocation(line: 68, column: 14, scope: !22)
!22 = distinct !DILexicalBlock(scope: !23, file: !3, line: 68, column: 7)
!23 = distinct !DILexicalBlock(scope: !24, file: !3, line: 66, column: 5)
!24 = distinct !DILexicalBlock(scope: !14, file: !3, line: 64, column: 3)
!25 = !DILocation(line: 68, column: 12, scope: !22)
!26 = !DILocation(line: 68, column: 19, scope: !27)
!27 = distinct !DILexicalBlock(scope: !22, file: !3, line: 68, column: 7)
!28 = !DILocation(line: 68, column: 21, scope: !27)
!29 = !DILocation(line: 68, column: 7, scope: !22)
!30 = !DILocation(line: 69, column: 16, scope: !31)
!31 = distinct !DILexicalBlock(scope: !27, file: !3, line: 69, column: 9)
!32 = !DILocation(line: 69, column: 14, scope: !31)
!33 = !DILocation(line: 69, column: 21, scope: !34)
!34 = distinct !DILexicalBlock(scope: !31, file: !3, line: 69, column: 9)
!35 = !DILocation(line: 69, column: 23, scope: !34)
!36 = !DILocation(line: 69, column: 9, scope: !31)
!37 = !DILocation(line: 70, column: 13, scope: !34)
!38 = !DILocation(line: 70, column: 11, scope: !34)
!39 = !DILocation(line: 70, column: 16, scope: !34)
!40 = !DILocation(line: 70, column: 18, scope: !34)
!41 = !DILocation(line: 69, column: 31, scope: !34)
!42 = !DILocation(line: 69, column: 9, scope: !34)
!43 = distinct !{!43, !36, !44}
!44 = !DILocation(line: 70, column: 20, scope: !31)
!45 = !DILocation(line: 68, column: 29, scope: !27)
!46 = !DILocation(line: 68, column: 7, scope: !27)
!47 = distinct !{!47, !29, !48}
!48 = !DILocation(line: 70, column: 20, scope: !22)
!49 = !DILocation(line: 73, column: 29, scope: !14)
!50 = !DILocation(line: 73, column: 3, scope: !14)
!51 = !DILocation(line: 74, column: 3, scope: !14)
