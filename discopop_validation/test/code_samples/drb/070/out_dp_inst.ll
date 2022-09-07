; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@b = dso_local global [100 x i32] zeroinitializer, align 16, !dbg !0
@c = dso_local global [100 x i32] zeroinitializer, align 16, !dbg !12
@a = dso_local global [100 x i32] zeroinitializer, align 16, !dbg !6
@.str = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"c\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"a\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !18 {
entry:
  call void @__dp_func_entry(i32 16435, i32 1)
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16435, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !21, metadata !DIExpression()), !dbg !22
  %1 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16439, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !23
  br label %for.cond, !dbg !25

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16439, i32 0)
  %2 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16439, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %3 = load i32, i32* %i, align 4, !dbg !26
  %cmp = icmp slt i32 %3, 100, !dbg !28
  br i1 %cmp, label %for.body, label %for.end, !dbg !29

for.body:                                         ; preds = %for.cond
  %4 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16440, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %5 = load i32, i32* %i, align 4, !dbg !30
  %idxprom = sext i32 %5 to i64, !dbg !31
  %arrayidx = getelementptr inbounds [100 x i32], [100 x i32]* @b, i64 0, i64 %idxprom, !dbg !31
  %6 = ptrtoint i32* %arrayidx to i64
  call void @__dp_read(i32 16440, i64 %6, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %7 = load i32, i32* %arrayidx, align 4, !dbg !31
  %8 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16440, i64 %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %9 = load i32, i32* %i, align 4, !dbg !32
  %idxprom1 = sext i32 %9 to i64, !dbg !33
  %arrayidx2 = getelementptr inbounds [100 x i32], [100 x i32]* @c, i64 0, i64 %idxprom1, !dbg !33
  %10 = ptrtoint i32* %arrayidx2 to i64
  call void @__dp_read(i32 16440, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %11 = load i32, i32* %arrayidx2, align 4, !dbg !33
  %mul = mul nsw i32 %7, %11, !dbg !34
  %12 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16440, i64 %12, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %13 = load i32, i32* %i, align 4, !dbg !35
  %idxprom3 = sext i32 %13 to i64, !dbg !36
  %arrayidx4 = getelementptr inbounds [100 x i32], [100 x i32]* @a, i64 0, i64 %idxprom3, !dbg !36
  %14 = ptrtoint i32* %arrayidx4 to i64
  call void @__dp_write(i32 16440, i64 %14, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 %mul, i32* %arrayidx4, align 4, !dbg !37
  br label %for.inc, !dbg !36

for.inc:                                          ; preds = %for.body
  %15 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16439, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %16 = load i32, i32* %i, align 4, !dbg !38
  %inc = add nsw i32 %16, 1, !dbg !38
  %17 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16439, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !38
  br label %for.cond, !dbg !39, !llvm.loop !40

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16441, i32 0)
  call void @__dp_finalize(i32 16441), !dbg !42
  ret i32 0, !dbg !42
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_loop_exit(i32, i32)

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!14}
!llvm.module.flags = !{!15, !16, !17}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !3, line: 50, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/070")
!4 = !{}
!5 = !{!6, !0, !12}
!6 = !DIGlobalVariableExpression(var: !7, expr: !DIExpression())
!7 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 50, type: !8, isLocal: false, isDefinition: true)
!8 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 3200, elements: !10)
!9 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!10 = !{!11}
!11 = !DISubrange(count: 100)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !3, line: 50, type: !8, isLocal: false, isDefinition: true)
!14 = !{!"Ubuntu clang version 11.1.0-6"}
!15 = !{i32 7, !"Dwarf Version", i32 4}
!16 = !{i32 2, !"Debug Info Version", i32 3}
!17 = !{i32 1, !"wchar_size", i32 4}
!18 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 51, type: !19, scopeLine: 52, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!19 = !DISubroutineType(types: !20)
!20 = !{!9}
!21 = !DILocalVariable(name: "i", scope: !18, file: !3, line: 53, type: !9)
!22 = !DILocation(line: 53, column: 7, scope: !18)
!23 = !DILocation(line: 55, column: 9, scope: !24)
!24 = distinct !DILexicalBlock(scope: !18, file: !3, line: 55, column: 3)
!25 = !DILocation(line: 55, column: 8, scope: !24)
!26 = !DILocation(line: 55, column: 12, scope: !27)
!27 = distinct !DILexicalBlock(scope: !24, file: !3, line: 55, column: 3)
!28 = !DILocation(line: 55, column: 13, scope: !27)
!29 = !DILocation(line: 55, column: 3, scope: !24)
!30 = !DILocation(line: 56, column: 12, scope: !27)
!31 = !DILocation(line: 56, column: 10, scope: !27)
!32 = !DILocation(line: 56, column: 17, scope: !27)
!33 = !DILocation(line: 56, column: 15, scope: !27)
!34 = !DILocation(line: 56, column: 14, scope: !27)
!35 = !DILocation(line: 56, column: 7, scope: !27)
!36 = !DILocation(line: 56, column: 5, scope: !27)
!37 = !DILocation(line: 56, column: 9, scope: !27)
!38 = !DILocation(line: 55, column: 19, scope: !27)
!39 = !DILocation(line: 55, column: 3, scope: !27)
!40 = distinct !{!40, !29, !41}
!41 = !DILocation(line: 56, column: 18, scope: !24)
!42 = !DILocation(line: 57, column: 3, scope: !18)
