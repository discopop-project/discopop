; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@foo.q = internal global i32 0, align 4, !dbg !0
@.str = private unnamed_addr constant [6 x i8] c"foo.q\00", align 1
@.str.1 = private unnamed_addr constant [7 x i8] c"retval\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo() #0 !dbg !2 {
entry:
  call void @__dp_func_entry(i32 16441, i32 0), !dbg !14
  %0 = ptrtoint i32* @foo.q to i64
  call void @__dp_read(i32 16441, i64 %0, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str, i32 0, i32 0))
  %1 = load i32, i32* @foo.q, align 4, !dbg !14
  %add = add nsw i32 %1, 1, !dbg !14
  %2 = ptrtoint i32* @foo.q to i64
  call void @__dp_write(i32 16441, i64 %2, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str, i32 0, i32 0))
  store i32 %add, i32* @foo.q, align 4, !dbg !14
  call void @__dp_func_exit(i32 16442, i32 0), !dbg !15
  ret void, !dbg !15
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_write(i32, i64, i8*)

declare void @__dp_func_exit(i32, i32)

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !16 {
entry:
  call void @__dp_func_entry(i32 16444, i32 1)
  %retval = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16444, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @__dp_call(i32 16448), !dbg !19
  call void @foo(), !dbg !19
  call void @__dp_finalize(i32 16450), !dbg !21
  ret i32 0, !dbg !21
}

declare void @__dp_call(i32)

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!6}
!llvm.ident = !{!10}
!llvm.module.flags = !{!11, !12, !13}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "q", scope: !2, file: !3, line: 56, type: !9, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "foo", scope: !3, file: !3, line: 54, type: !4, scopeLine: 55, spFlags: DISPFlagDefinition, unit: !6, retainedNodes: !7)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/082")
!4 = !DISubroutineType(types: !5)
!5 = !{null}
!6 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !7, globals: !8, splitDebugInlining: false, nameTableKind: None)
!7 = !{}
!8 = !{!0}
!9 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!10 = !{!"Ubuntu clang version 11.1.0-6"}
!11 = !{i32 7, !"Dwarf Version", i32 4}
!12 = !{i32 2, !"Debug Info Version", i32 3}
!13 = !{i32 1, !"wchar_size", i32 4}
!14 = !DILocation(line: 57, column: 5, scope: !2)
!15 = !DILocation(line: 58, column: 1, scope: !2)
!16 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 60, type: !17, scopeLine: 61, spFlags: DISPFlagDefinition, unit: !6, retainedNodes: !7)
!17 = !DISubroutineType(types: !18)
!18 = !{!9}
!19 = !DILocation(line: 64, column: 6, scope: !20)
!20 = distinct !DILexicalBlock(scope: !16, file: !3, line: 63, column: 3)
!21 = !DILocation(line: 66, column: 3, scope: !16)
