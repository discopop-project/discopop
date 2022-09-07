; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.2 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@.str = private unnamed_addr constant [6 x i8] c"x=%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"y=%d\0A\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c"retval\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo() #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16405, i32 0)
  %x = alloca i32, align 4
  %y = alloca i32, align 4
  call void @llvm.dbg.declare(metadata i32* %x, metadata !10, metadata !DIExpression()), !dbg !12
  %0 = ptrtoint i32* %x to i64
  call void @__dp_write(i32 16406, i64 %0, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %x, align 4, !dbg !12
  call void @llvm.dbg.declare(metadata i32* %y, metadata !13, metadata !DIExpression()), !dbg !14
  %1 = ptrtoint i32* %y to i64
  call void @__dp_write(i32 16406, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 2, i32* %y, align 4, !dbg !14
  %2 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16409, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %3 = load i32, i32* %x, align 4, !dbg !15
  %inc = add nsw i32 %3, 1, !dbg !15
  %4 = ptrtoint i32* %x to i64
  call void @__dp_write(i32 16409, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 %inc, i32* %x, align 4, !dbg !15
  %5 = ptrtoint i32* %y to i64
  call void @__dp_read(i32 16412, i64 %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %6 = load i32, i32* %y, align 4, !dbg !16
  %7 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16412, i64 %7, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %8 = load i32, i32* %x, align 4, !dbg !17
  %sub = sub nsw i32 %6, %8, !dbg !18
  %9 = ptrtoint i32* %y to i64
  call void @__dp_write(i32 16412, i64 %9, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 %sub, i32* %y, align 4, !dbg !19
  %10 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16416, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %11 = load i32, i32* %x, align 4, !dbg !20
  call void @__dp_call(i32 16416), !dbg !21
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str, i64 0, i64 0), i32 %11), !dbg !21
  %12 = ptrtoint i32* %y to i64
  call void @__dp_read(i32 16420, i64 %12, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %13 = load i32, i32* %y, align 4, !dbg !22
  call void @__dp_call(i32 16420), !dbg !23
  %call1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i64 0, i64 0), i32 %13), !dbg !23
  call void @__dp_func_exit(i32 16421, i32 0), !dbg !24
  ret void, !dbg !24
}

declare void @__dp_func_entry(i32, i32)

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_write(i32, i64, i8*)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_call(i32)

declare dso_local i32 @printf(i8*, ...) #2

declare void @__dp_func_exit(i32, i32)

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !25 {
entry:
  call void @__dp_func_entry(i32 16423, i32 1)
  %retval = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16423, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @__dp_call(i32 16426), !dbg !28
  call void @foo(), !dbg !28
  call void @__dp_finalize(i32 16428), !dbg !29
  ret i32 0, !dbg !29
}

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!3}
!llvm.module.flags = !{!4, !5, !6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/167")
!2 = !{}
!3 = !{!"Ubuntu clang version 11.1.0-6"}
!4 = !{i32 7, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = distinct !DISubprogram(name: "foo", scope: !1, file: !1, line: 21, type: !8, scopeLine: 21, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{null}
!10 = !DILocalVariable(name: "x", scope: !7, file: !1, line: 22, type: !11)
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !DILocation(line: 22, column: 7, scope: !7)
!13 = !DILocalVariable(name: "y", scope: !7, file: !1, line: 22, type: !11)
!14 = !DILocation(line: 22, column: 14, scope: !7)
!15 = !DILocation(line: 25, column: 4, scope: !7)
!16 = !DILocation(line: 28, column: 7, scope: !7)
!17 = !DILocation(line: 28, column: 9, scope: !7)
!18 = !DILocation(line: 28, column: 8, scope: !7)
!19 = !DILocation(line: 28, column: 5, scope: !7)
!20 = !DILocation(line: 32, column: 19, scope: !7)
!21 = !DILocation(line: 32, column: 3, scope: !7)
!22 = !DILocation(line: 36, column: 19, scope: !7)
!23 = !DILocation(line: 36, column: 3, scope: !7)
!24 = !DILocation(line: 37, column: 1, scope: !7)
!25 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 39, type: !26, scopeLine: 39, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!26 = !DISubroutineType(types: !27)
!27 = !{!11}
!28 = !DILocation(line: 42, column: 3, scope: !25)
!29 = !DILocation(line: 44, column: 3, scope: !25)
