; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.1 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"var\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16403, i32 1)
  %retval = alloca i32, align 4
  %var = alloca i32, align 4
  %i = alloca i32, align 4
  %i1 = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16403, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %var, metadata !11, metadata !DIExpression()), !dbg !12
  %1 = ptrtoint i32* %var to i64
  call void @__dp_write(i32 16405, i64 %1, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %var, align 4, !dbg !12
  call void @llvm.dbg.declare(metadata i32* %i, metadata !13, metadata !DIExpression()), !dbg !14
  call void @llvm.dbg.declare(metadata i32* %i1, metadata !15, metadata !DIExpression()), !dbg !17
  %2 = ptrtoint i32* %i1 to i64
  call void @__dp_write(i32 16409, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 0, i32* %i1, align 4, !dbg !17
  br label %for.cond, !dbg !18

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16409, i32 0)
  %3 = ptrtoint i32* %i1 to i64
  call void @__dp_read(i32 16409, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %4 = load i32, i32* %i1, align 4, !dbg !19
  %cmp = icmp slt i32 %4, 100, !dbg !21
  br i1 %cmp, label %for.body, label %for.end, !dbg !22

for.body:                                         ; preds = %for.cond
  %5 = ptrtoint i32* %var to i64
  call void @__dp_read(i32 16410, i64 %5, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  %6 = load i32, i32* %var, align 4, !dbg !23
  %inc = add nsw i32 %6, 1, !dbg !23
  %7 = ptrtoint i32* %var to i64
  call void @__dp_write(i32 16410, i64 %7, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  store i32 %inc, i32* %var, align 4, !dbg !23
  br label %for.inc, !dbg !25

for.inc:                                          ; preds = %for.body
  %8 = ptrtoint i32* %i1 to i64
  call void @__dp_read(i32 16409, i64 %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %9 = load i32, i32* %i1, align 4, !dbg !26
  %inc2 = add nsw i32 %9, 1, !dbg !26
  %10 = ptrtoint i32* %i1 to i64
  call void @__dp_write(i32 16409, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 %inc2, i32* %i1, align 4, !dbg !26
  br label %for.cond, !dbg !27, !llvm.loop !28

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16413, i32 0)
  %11 = ptrtoint i32* %var to i64
  call void @__dp_read(i32 16413, i64 %11, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  %12 = load i32, i32* %var, align 4, !dbg !30
  call void @__dp_call(i32 16413), !dbg !31
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 %12), !dbg !31
  call void @__dp_finalize(i32 16414), !dbg !32
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

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!3}
!llvm.module.flags = !{!4, !5, !6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/151")
!2 = !{}
!3 = !{!"Ubuntu clang version 11.1.0-6"}
!4 = !{i32 7, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 19, type: !8, scopeLine: 19, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "var", scope: !7, file: !1, line: 21, type: !10)
!12 = !DILocation(line: 21, column: 7, scope: !7)
!13 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 21, type: !10)
!14 = !DILocation(line: 21, column: 13, scope: !7)
!15 = !DILocalVariable(name: "i", scope: !16, file: !1, line: 25, type: !10)
!16 = distinct !DILexicalBlock(scope: !7, file: !1, line: 25, column: 3)
!17 = !DILocation(line: 25, column: 12, scope: !16)
!18 = !DILocation(line: 25, column: 8, scope: !16)
!19 = !DILocation(line: 25, column: 17, scope: !20)
!20 = distinct !DILexicalBlock(scope: !16, file: !1, line: 25, column: 3)
!21 = !DILocation(line: 25, column: 18, scope: !20)
!22 = !DILocation(line: 25, column: 3, scope: !16)
!23 = !DILocation(line: 26, column: 8, scope: !24)
!24 = distinct !DILexicalBlock(scope: !20, file: !1, line: 25, column: 28)
!25 = !DILocation(line: 27, column: 3, scope: !24)
!26 = !DILocation(line: 25, column: 25, scope: !20)
!27 = !DILocation(line: 25, column: 3, scope: !20)
!28 = distinct !{!28, !22, !29}
!29 = !DILocation(line: 27, column: 3, scope: !16)
!30 = !DILocation(line: 29, column: 17, scope: !7)
!31 = !DILocation(line: 29, column: 3, scope: !7)
!32 = !DILocation(line: 30, column: 3, scope: !7)
