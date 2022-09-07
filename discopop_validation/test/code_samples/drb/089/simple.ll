; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, %struct._IO_codecvt*, %struct._IO_wide_data*, %struct._IO_FILE*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type opaque
%struct._IO_codecvt = type opaque
%struct._IO_wide_data = type opaque

@counter = dso_local global i32* null, align 8, !dbg !0
@stderr = external dso_local global %struct._IO_FILE*, align 8
@.str = private unnamed_addr constant [17 x i8] c"malloc() failes\0A\00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"%d \0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !14 {
entry:
  %retval = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  %call = call noalias i8* @malloc(i64 4) #4, !dbg !17
  %0 = bitcast i8* %call to i32*, !dbg !18
  store i32* %0, i32** @counter, align 8, !dbg !19
  %1 = load i32*, i32** @counter, align 8, !dbg !20
  %cmp = icmp eq i32* %1, null, !dbg !22
  br i1 %cmp, label %if.then, label %if.end, !dbg !23

if.then:                                          ; preds = %entry
  %2 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !24
  %call1 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %2, i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i64 0, i64 0)), !dbg !26
  call void @exit(i32 1) #5, !dbg !27
  unreachable, !dbg !27

if.end:                                           ; preds = %entry
  %3 = load i32*, i32** @counter, align 8, !dbg !28
  store i32 0, i32* %3, align 4, !dbg !29
  %4 = load i32*, i32** @counter, align 8, !dbg !30
  %5 = load i32, i32* %4, align 4, !dbg !32
  %inc = add nsw i32 %5, 1, !dbg !32
  store i32 %inc, i32* %4, align 4, !dbg !32
  %6 = load i32*, i32** @counter, align 8, !dbg !33
  %7 = load i32, i32* %6, align 4, !dbg !34
  %call2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 %7), !dbg !35
  %8 = load i32*, i32** @counter, align 8, !dbg !36
  %9 = bitcast i32* %8 to i8*, !dbg !36
  call void @free(i8* %9) #4, !dbg !37
  ret i32 0, !dbg !38
}

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64) #1

declare dso_local i32 @fprintf(%struct._IO_FILE*, i8*, ...) #2

; Function Attrs: noreturn nounwind
declare dso_local void @exit(i32) #3

declare dso_local i32 @printf(i8*, ...) #2

; Function Attrs: nounwind
declare dso_local void @free(i8*) #1

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }
attributes #5 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!10, !11, !12}
!llvm.ident = !{!13}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "counter", scope: !2, file: !3, line: 59, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !9, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/089")
!4 = !{}
!5 = !{!6, !8}
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!9 = !{!0}
!10 = !{i32 7, !"Dwarf Version", i32 4}
!11 = !{i32 2, !"Debug Info Version", i32 3}
!12 = !{i32 1, !"wchar_size", i32 4}
!13 = !{!"Ubuntu clang version 11.1.0-6"}
!14 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 62, type: !15, scopeLine: 63, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!15 = !DISubroutineType(types: !16)
!16 = !{!7}
!17 = !DILocation(line: 64, column: 20, scope: !14)
!18 = !DILocation(line: 64, column: 13, scope: !14)
!19 = !DILocation(line: 64, column: 11, scope: !14)
!20 = !DILocation(line: 65, column: 7, scope: !21)
!21 = distinct !DILexicalBlock(scope: !14, file: !3, line: 65, column: 7)
!22 = !DILocation(line: 65, column: 14, scope: !21)
!23 = !DILocation(line: 65, column: 7, scope: !14)
!24 = !DILocation(line: 67, column: 13, scope: !25)
!25 = distinct !DILexicalBlock(scope: !21, file: !3, line: 66, column: 3)
!26 = !DILocation(line: 67, column: 5, scope: !25)
!27 = !DILocation(line: 68, column: 5, scope: !25)
!28 = !DILocation(line: 70, column: 4, scope: !14)
!29 = !DILocation(line: 70, column: 12, scope: !14)
!30 = !DILocation(line: 73, column: 7, scope: !31)
!31 = distinct !DILexicalBlock(scope: !14, file: !3, line: 72, column: 3)
!32 = !DILocation(line: 73, column: 15, scope: !31)
!33 = !DILocation(line: 75, column: 20, scope: !14)
!34 = !DILocation(line: 75, column: 19, scope: !14)
!35 = !DILocation(line: 75, column: 3, scope: !14)
!36 = !DILocation(line: 76, column: 9, scope: !14)
!37 = !DILocation(line: 76, column: 3, scope: !14)
!38 = !DILocation(line: 77, column: 3, scope: !14)
