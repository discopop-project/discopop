; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@a = dso_local global [100 x [100 x i32]] zeroinitializer, align 16, !dbg !0
@.str = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"j\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"a\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !14 {
entry:
  call void @__dp_func_entry(i32 16437, i32 1)
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16437, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !17, metadata !DIExpression()), !dbg !18
  call void @llvm.dbg.declare(metadata i32* %j, metadata !19, metadata !DIExpression()), !dbg !20
  %1 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16441, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !21
  br label %for.cond, !dbg !23

for.cond:                                         ; preds = %for.inc10, %entry
  call void @__dp_loop_entry(i32 16441, i32 0)
  %2 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16441, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %3 = load i32, i32* %i, align 4, !dbg !24
  %cmp = icmp slt i32 %3, 100, !dbg !26
  br i1 %cmp, label %for.body, label %for.end12, !dbg !27

for.body:                                         ; preds = %for.cond
  %4 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16442, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %j, align 4, !dbg !28
  br label %for.cond1, !dbg !30

for.cond1:                                        ; preds = %for.inc, %for.body
  call void @__dp_loop_entry(i32 16442, i32 1)
  %5 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16442, i64 %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %6 = load i32, i32* %j, align 4, !dbg !31
  %cmp2 = icmp slt i32 %6, 100, !dbg !33
  br i1 %cmp2, label %for.body3, label %for.end, !dbg !34

for.body3:                                        ; preds = %for.cond1
  %7 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16443, i64 %7, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %8 = load i32, i32* %i, align 4, !dbg !35
  %idxprom = sext i32 %8 to i64, !dbg !36
  %arrayidx = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* @a, i64 0, i64 %idxprom, !dbg !36
  %9 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16443, i64 %9, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %10 = load i32, i32* %j, align 4, !dbg !37
  %idxprom4 = sext i32 %10 to i64, !dbg !36
  %arrayidx5 = getelementptr inbounds [100 x i32], [100 x i32]* %arrayidx, i64 0, i64 %idxprom4, !dbg !36
  %11 = ptrtoint i32* %arrayidx5 to i64
  call void @__dp_read(i32 16443, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %12 = load i32, i32* %arrayidx5, align 4, !dbg !36
  %add = add nsw i32 %12, 1, !dbg !38
  %13 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16443, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %14 = load i32, i32* %i, align 4, !dbg !39
  %idxprom6 = sext i32 %14 to i64, !dbg !40
  %arrayidx7 = getelementptr inbounds [100 x [100 x i32]], [100 x [100 x i32]]* @a, i64 0, i64 %idxprom6, !dbg !40
  %15 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16443, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %16 = load i32, i32* %j, align 4, !dbg !41
  %idxprom8 = sext i32 %16 to i64, !dbg !40
  %arrayidx9 = getelementptr inbounds [100 x i32], [100 x i32]* %arrayidx7, i64 0, i64 %idxprom8, !dbg !40
  %17 = ptrtoint i32* %arrayidx9 to i64
  call void @__dp_write(i32 16443, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 %add, i32* %arrayidx9, align 4, !dbg !42
  br label %for.inc, !dbg !40

for.inc:                                          ; preds = %for.body3
  %18 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16442, i64 %18, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %19 = load i32, i32* %j, align 4, !dbg !43
  %inc = add nsw i32 %19, 1, !dbg !43
  %20 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16442, i64 %20, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 %inc, i32* %j, align 4, !dbg !43
  br label %for.cond1, !dbg !44, !llvm.loop !45

for.end:                                          ; preds = %for.cond1
  call void @__dp_loop_exit(i32 16443, i32 1)
  br label %for.inc10, !dbg !46

for.inc10:                                        ; preds = %for.end
  %21 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16441, i64 %21, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %22 = load i32, i32* %i, align 4, !dbg !47
  %inc11 = add nsw i32 %22, 1, !dbg !47
  %23 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16441, i64 %23, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 %inc11, i32* %i, align 4, !dbg !47
  br label %for.cond, !dbg !48, !llvm.loop !49

for.end12:                                        ; preds = %for.cond
  call void @__dp_loop_exit(i32 16444, i32 0)
  call void @__dp_finalize(i32 16444), !dbg !51
  ret i32 0, !dbg !51
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
!llvm.ident = !{!10}
!llvm.module.flags = !{!11, !12, !13}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 52, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/093")
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
!14 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 53, type: !15, scopeLine: 54, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!15 = !DISubroutineType(types: !16)
!16 = !{!7}
!17 = !DILocalVariable(name: "i", scope: !14, file: !3, line: 55, type: !7)
!18 = !DILocation(line: 55, column: 7, scope: !14)
!19 = !DILocalVariable(name: "j", scope: !14, file: !3, line: 55, type: !7)
!20 = !DILocation(line: 55, column: 9, scope: !14)
!21 = !DILocation(line: 57, column: 9, scope: !22)
!22 = distinct !DILexicalBlock(scope: !14, file: !3, line: 57, column: 3)
!23 = !DILocation(line: 57, column: 8, scope: !22)
!24 = !DILocation(line: 57, column: 12, scope: !25)
!25 = distinct !DILexicalBlock(scope: !22, file: !3, line: 57, column: 3)
!26 = !DILocation(line: 57, column: 13, scope: !25)
!27 = !DILocation(line: 57, column: 3, scope: !22)
!28 = !DILocation(line: 58, column: 11, scope: !29)
!29 = distinct !DILexicalBlock(scope: !25, file: !3, line: 58, column: 5)
!30 = !DILocation(line: 58, column: 10, scope: !29)
!31 = !DILocation(line: 58, column: 14, scope: !32)
!32 = distinct !DILexicalBlock(scope: !29, file: !3, line: 58, column: 5)
!33 = !DILocation(line: 58, column: 15, scope: !32)
!34 = !DILocation(line: 58, column: 5, scope: !29)
!35 = !DILocation(line: 59, column: 17, scope: !32)
!36 = !DILocation(line: 59, column: 15, scope: !32)
!37 = !DILocation(line: 59, column: 20, scope: !32)
!38 = !DILocation(line: 59, column: 22, scope: !32)
!39 = !DILocation(line: 59, column: 9, scope: !32)
!40 = !DILocation(line: 59, column: 7, scope: !32)
!41 = !DILocation(line: 59, column: 12, scope: !32)
!42 = !DILocation(line: 59, column: 14, scope: !32)
!43 = !DILocation(line: 58, column: 21, scope: !32)
!44 = !DILocation(line: 58, column: 5, scope: !32)
!45 = distinct !{!45, !34, !46}
!46 = !DILocation(line: 59, column: 23, scope: !29)
!47 = !DILocation(line: 57, column: 19, scope: !25)
!48 = !DILocation(line: 57, column: 3, scope: !25)
!49 = distinct !{!49, !27, !50}
!50 = !DILocation(line: 59, column: 23, scope: !22)
!51 = !DILocation(line: 60, column: 3, scope: !14)
