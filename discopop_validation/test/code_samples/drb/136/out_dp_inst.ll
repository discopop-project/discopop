; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.1 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"c\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"d\00", align 1
@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16403, i32 1)
  %retval = alloca i32, align 4
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %c = alloca i32, align 4
  %d = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16403, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %a, metadata !11, metadata !DIExpression()), !dbg !12
  call void @llvm.dbg.declare(metadata i32* %b, metadata !13, metadata !DIExpression()), !dbg !14
  call void @llvm.dbg.declare(metadata i32* %c, metadata !15, metadata !DIExpression()), !dbg !16
  call void @llvm.dbg.declare(metadata i32* %d, metadata !17, metadata !DIExpression()), !dbg !18
  %1 = ptrtoint i32* %c to i64
  call void @__dp_write(i32 16410, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 1, i32* %c, align 4, !dbg !19
  %2 = ptrtoint i32* %a to i64
  call void @__dp_write(i32 16412, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 2, i32* %a, align 4, !dbg !21
  %3 = ptrtoint i32* %b to i64
  call void @__dp_write(i32 16414, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 3, i32* %b, align 4, !dbg !22
  %4 = ptrtoint i32* %a to i64
  call void @__dp_read(i32 16416, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %5 = load i32, i32* %a, align 4, !dbg !23
  %6 = ptrtoint i32* %c to i64
  call void @__dp_read(i32 16416, i64 %6, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %7 = load i32, i32* %c, align 4, !dbg !24
  %add = add nsw i32 %7, %5, !dbg !24
  %8 = ptrtoint i32* %c to i64
  call void @__dp_write(i32 16416, i64 %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 %add, i32* %c, align 4, !dbg !24
  %9 = ptrtoint i32* %b to i64
  call void @__dp_read(i32 16418, i64 %9, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %10 = load i32, i32* %b, align 4, !dbg !25
  %11 = ptrtoint i32* %c to i64
  call void @__dp_read(i32 16418, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %12 = load i32, i32* %c, align 4, !dbg !26
  %add1 = add nsw i32 %12, %10, !dbg !26
  %13 = ptrtoint i32* %c to i64
  call void @__dp_write(i32 16418, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 %add1, i32* %c, align 4, !dbg !26
  %14 = ptrtoint i32* %c to i64
  call void @__dp_read(i32 16420, i64 %14, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %15 = load i32, i32* %c, align 4, !dbg !27
  %16 = ptrtoint i32* %d to i64
  call void @__dp_write(i32 16420, i64 %16, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 %15, i32* %d, align 4, !dbg !28
  %17 = ptrtoint i32* %d to i64
  call void @__dp_read(i32 16423, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %18 = load i32, i32* %d, align 4, !dbg !29
  call void @__dp_call(i32 16423), !dbg !30
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 %18), !dbg !30
  call void @__dp_finalize(i32 16424), !dbg !31
  ret i32 0, !dbg !31
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_read(i32, i64, i8*)

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
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/136")
!2 = !{}
!3 = !{!"Ubuntu clang version 11.1.0-6"}
!4 = !{i32 7, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 19, type: !8, scopeLine: 19, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "a", scope: !7, file: !1, line: 20, type: !10)
!12 = !DILocation(line: 20, column: 7, scope: !7)
!13 = !DILocalVariable(name: "b", scope: !7, file: !1, line: 20, type: !10)
!14 = !DILocation(line: 20, column: 10, scope: !7)
!15 = !DILocalVariable(name: "c", scope: !7, file: !1, line: 20, type: !10)
!16 = !DILocation(line: 20, column: 13, scope: !7)
!17 = !DILocalVariable(name: "d", scope: !7, file: !1, line: 20, type: !10)
!18 = !DILocation(line: 20, column: 16, scope: !7)
!19 = !DILocation(line: 26, column: 9, scope: !20)
!20 = distinct !DILexicalBlock(scope: !7, file: !1, line: 24, column: 3)
!21 = !DILocation(line: 28, column: 9, scope: !20)
!22 = !DILocation(line: 30, column: 9, scope: !20)
!23 = !DILocation(line: 32, column: 12, scope: !20)
!24 = !DILocation(line: 32, column: 9, scope: !20)
!25 = !DILocation(line: 34, column: 12, scope: !20)
!26 = !DILocation(line: 34, column: 9, scope: !20)
!27 = !DILocation(line: 36, column: 11, scope: !20)
!28 = !DILocation(line: 36, column: 9, scope: !20)
!29 = !DILocation(line: 39, column: 17, scope: !7)
!30 = !DILocation(line: 39, column: 3, scope: !7)
!31 = !DILocation(line: 40, column: 3, scope: !7)
