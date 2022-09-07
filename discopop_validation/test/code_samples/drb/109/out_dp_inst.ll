; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.1 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str = private unnamed_addr constant [6 x i8] c"x=%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16435, i32 1)
  %retval = alloca i32, align 4
  %x = alloca i32, align 4
  %i = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16435, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %x, metadata !11, metadata !DIExpression()), !dbg !12
  %1 = ptrtoint i32* %x to i64
  call void @__dp_write(i32 16437, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %x, align 4, !dbg !12
  call void @llvm.dbg.declare(metadata i32* %i, metadata !13, metadata !DIExpression()), !dbg !15
  %2 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16439, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !15
  br label %for.cond, !dbg !16

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16439, i32 0)
  %3 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16439, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %4 = load i32, i32* %i, align 4, !dbg !17
  %cmp = icmp slt i32 %4, 100, !dbg !19
  br i1 %cmp, label %for.body, label %for.end, !dbg !20

for.body:                                         ; preds = %for.cond
  %5 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16440, i64 %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %6 = load i32, i32* %x, align 4, !dbg !21
  %inc = add nsw i32 %6, 1, !dbg !21
  %7 = ptrtoint i32* %x to i64
  call void @__dp_write(i32 16440, i64 %7, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 %inc, i32* %x, align 4, !dbg !21
  br label %for.inc, !dbg !23

for.inc:                                          ; preds = %for.body
  %8 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16439, i64 %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %9 = load i32, i32* %i, align 4, !dbg !24
  %inc1 = add nsw i32 %9, 1, !dbg !24
  %10 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16439, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 %inc1, i32* %i, align 4, !dbg !24
  br label %for.cond, !dbg !25, !llvm.loop !26

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16442, i32 0)
  %11 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16442, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %12 = load i32, i32* %x, align 4, !dbg !28
  call void @__dp_call(i32 16442), !dbg !29
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str, i64 0, i64 0), i32 %12), !dbg !29
  call void @__dp_finalize(i32 16443), !dbg !30
  ret i32 0, !dbg !30
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

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!3}
!llvm.module.flags = !{!4, !5, !6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/109")
!2 = !{}
!3 = !{!"Ubuntu clang version 11.1.0-6"}
!4 = !{i32 7, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 51, type: !8, scopeLine: 52, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "x", scope: !7, file: !1, line: 53, type: !10)
!12 = !DILocation(line: 53, column: 7, scope: !7)
!13 = !DILocalVariable(name: "i", scope: !14, file: !1, line: 55, type: !10)
!14 = distinct !DILexicalBlock(scope: !7, file: !1, line: 55, column: 3)
!15 = !DILocation(line: 55, column: 12, scope: !14)
!16 = !DILocation(line: 55, column: 8, scope: !14)
!17 = !DILocation(line: 55, column: 19, scope: !18)
!18 = distinct !DILexicalBlock(scope: !14, file: !1, line: 55, column: 3)
!19 = !DILocation(line: 55, column: 21, scope: !18)
!20 = !DILocation(line: 55, column: 3, scope: !14)
!21 = !DILocation(line: 56, column: 6, scope: !22)
!22 = distinct !DILexicalBlock(scope: !18, file: !1, line: 55, column: 33)
!23 = !DILocation(line: 57, column: 3, scope: !22)
!24 = !DILocation(line: 55, column: 28, scope: !18)
!25 = !DILocation(line: 55, column: 3, scope: !18)
!26 = distinct !{!26, !20, !27}
!27 = !DILocation(line: 57, column: 3, scope: !14)
!28 = !DILocation(line: 58, column: 20, scope: !7)
!29 = !DILocation(line: 58, column: 3, scope: !7)
!30 = !DILocation(line: 59, column: 3, scope: !7)
