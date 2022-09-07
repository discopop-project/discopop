; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@var = dso_local global i32 0, align 4, !dbg !0
@.str.1 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c"var\00", align 1
@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !11 {
entry:
  call void @__dp_func_entry(i32 16409, i32 1)
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16409, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !14, metadata !DIExpression()), !dbg !16
  %1 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16413, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !16
  br label %for.cond, !dbg !17

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16413, i32 0)
  %2 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16413, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %3 = load i32, i32* %i, align 4, !dbg !18
  %cmp = icmp slt i32 %3, 100, !dbg !20
  br i1 %cmp, label %for.body, label %for.end, !dbg !21

for.body:                                         ; preds = %for.cond
  %4 = ptrtoint i32* @var to i64
  call void @__dp_read(i32 16415, i64 %4, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  %5 = load i32, i32* @var, align 4, !dbg !22
  %inc = add nsw i32 %5, 1, !dbg !22
  %6 = ptrtoint i32* @var to i64
  call void @__dp_write(i32 16415, i64 %6, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  store i32 %inc, i32* @var, align 4, !dbg !22
  %7 = ptrtoint i32* @var to i64
  call void @__dp_read(i32 16418, i64 %7, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  %8 = load i32, i32* @var, align 4, !dbg !24
  %sub = sub nsw i32 %8, 2, !dbg !24
  %9 = ptrtoint i32* @var to i64
  call void @__dp_write(i32 16418, i64 %9, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  store i32 %sub, i32* @var, align 4, !dbg !24
  br label %for.inc, !dbg !25

for.inc:                                          ; preds = %for.body
  %10 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16413, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %11 = load i32, i32* %i, align 4, !dbg !26
  %inc1 = add nsw i32 %11, 1, !dbg !26
  %12 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16413, i64 %12, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 %inc1, i32* %i, align 4, !dbg !26
  br label %for.cond, !dbg !27, !llvm.loop !28

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16421, i32 0)
  %13 = ptrtoint i32* @var to i64
  call void @__dp_read(i32 16421, i64 %13, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  %14 = load i32, i32* @var, align 4, !dbg !30
  call void @__dp_call(i32 16421), !dbg !31
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 %14), !dbg !31
  call void @__dp_finalize(i32 16423), !dbg !32
  ret i32 0, !dbg !32
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
!llvm.ident = !{!7}
!llvm.module.flags = !{!8, !9, !10}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "var", scope: !2, file: !3, line: 23, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/148")
!4 = !{}
!5 = !{!0}
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !{!"Ubuntu clang version 11.1.0-6"}
!8 = !{i32 7, !"Dwarf Version", i32 4}
!9 = !{i32 2, !"Debug Info Version", i32 3}
!10 = !{i32 1, !"wchar_size", i32 4}
!11 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 25, type: !12, scopeLine: 25, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!12 = !DISubroutineType(types: !13)
!13 = !{!6}
!14 = !DILocalVariable(name: "i", scope: !15, file: !3, line: 29, type: !6)
!15 = distinct !DILexicalBlock(scope: !11, file: !3, line: 29, column: 3)
!16 = !DILocation(line: 29, column: 11, scope: !15)
!17 = !DILocation(line: 29, column: 7, scope: !15)
!18 = !DILocation(line: 29, column: 16, scope: !19)
!19 = distinct !DILexicalBlock(scope: !15, file: !3, line: 29, column: 3)
!20 = !DILocation(line: 29, column: 17, scope: !19)
!21 = !DILocation(line: 29, column: 3, scope: !15)
!22 = !DILocation(line: 31, column: 8, scope: !23)
!23 = distinct !DILexicalBlock(scope: !19, file: !3, line: 29, column: 25)
!24 = !DILocation(line: 34, column: 9, scope: !23)
!25 = !DILocation(line: 35, column: 3, scope: !23)
!26 = !DILocation(line: 29, column: 22, scope: !19)
!27 = !DILocation(line: 29, column: 3, scope: !19)
!28 = distinct !{!28, !21, !29}
!29 = !DILocation(line: 35, column: 3, scope: !15)
!30 = !DILocation(line: 37, column: 17, scope: !11)
!31 = !DILocation(line: 37, column: 3, scope: !11)
!32 = !DILocation(line: 39, column: 3, scope: !11)
