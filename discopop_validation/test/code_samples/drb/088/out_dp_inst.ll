; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, %struct._IO_codecvt*, %struct._IO_wide_data*, %struct._IO_FILE*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type opaque
%struct._IO_codecvt = type opaque
%struct._IO_wide_data = type opaque

@counter = dso_local global i32* null, align 8, !dbg !0
@.str.2 = private unnamed_addr constant [8 x i8] c"counter\00", align 1
@.str.3 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@stderr = external dso_local global %struct._IO_FILE*, align 8
@.str.4 = private unnamed_addr constant [7 x i8] c"stderr\00", align 1
@.str = private unnamed_addr constant [17 x i8] c"malloc() failes\0A\00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"%d \0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo() #0 !dbg !14 {
entry:
  call void @__dp_func_entry(i32 16447, i32 0), !dbg !17
  %0 = ptrtoint i32** @counter to i64
  call void @__dp_read(i32 16447, i64 %0, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.2, i32 0, i32 0))
  %1 = load i32*, i32** @counter, align 8, !dbg !17
  %2 = ptrtoint i32* %1 to i64
  call void @__dp_read(i32 16447, i64 %2, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.2, i32 0, i32 0))
  %3 = load i32, i32* %1, align 4, !dbg !18
  %inc = add nsw i32 %3, 1, !dbg !18
  %4 = ptrtoint i32* %1 to i64
  call void @__dp_write(i32 16447, i64 %4, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.2, i32 0, i32 0))
  store i32 %inc, i32* %1, align 4, !dbg !18
  call void @__dp_func_exit(i32 16448, i32 0), !dbg !19
  ret void, !dbg !19
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_write(i32, i64, i8*)

declare void @__dp_func_exit(i32, i32)

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !20 {
entry:
  call void @__dp_func_entry(i32 16450, i32 1)
  %retval = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16450, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @__dp_call(i32 16452), !dbg !23
  %call = call noalias i8* @malloc(i64 4) #4, !dbg !23
  %1 = bitcast i8* %call to i32*, !dbg !24
  %2 = ptrtoint i32** @counter to i64
  call void @__dp_write(i32 16452, i64 %2, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.2, i32 0, i32 0))
  store i32* %1, i32** @counter, align 8, !dbg !25
  %3 = ptrtoint i32** @counter to i64
  call void @__dp_read(i32 16453, i64 %3, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.2, i32 0, i32 0))
  %4 = load i32*, i32** @counter, align 8, !dbg !26
  %cmp = icmp eq i32* %4, null, !dbg !28
  br i1 %cmp, label %if.then, label %if.end, !dbg !29

if.then:                                          ; preds = %entry
  %5 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 16455, i64 %5, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0))
  %6 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !30
  call void @__dp_call(i32 16455), !dbg !32
  %call1 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %6, i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i64 0, i64 0)), !dbg !32
  call void @__dp_finalize(i32 16456), !dbg !33
  call void @exit(i32 1) #5, !dbg !33
  unreachable, !dbg !33

if.end:                                           ; preds = %entry
  %7 = ptrtoint i32** @counter to i64
  call void @__dp_read(i32 16458, i64 %7, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.2, i32 0, i32 0))
  %8 = load i32*, i32** @counter, align 8, !dbg !34
  %9 = ptrtoint i32* %8 to i64
  call void @__dp_write(i32 16458, i64 %9, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %8, align 4, !dbg !35
  call void @__dp_call(i32 16461), !dbg !36
  call void @foo(), !dbg !36
  %10 = ptrtoint i32** @counter to i64
  call void @__dp_read(i32 16463, i64 %10, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.2, i32 0, i32 0))
  %11 = load i32*, i32** @counter, align 8, !dbg !38
  %12 = ptrtoint i32* %11 to i64
  call void @__dp_read(i32 16463, i64 %12, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.2, i32 0, i32 0))
  %13 = load i32, i32* %11, align 4, !dbg !39
  call void @__dp_call(i32 16463), !dbg !40
  %call2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 %13), !dbg !40
  %14 = ptrtoint i32** @counter to i64
  call void @__dp_read(i32 16464, i64 %14, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.2, i32 0, i32 0))
  %15 = load i32*, i32** @counter, align 8, !dbg !41
  %16 = bitcast i32* %15 to i8*, !dbg !41
  call void @__dp_call(i32 16464), !dbg !42
  call void @free(i8* %16) #4, !dbg !42
  call void @__dp_finalize(i32 16465), !dbg !43
  ret i32 0, !dbg !43
}

declare void @__dp_call(i32)

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64) #1

declare dso_local i32 @fprintf(%struct._IO_FILE*, i8*, ...) #2

declare void @__dp_finalize(i32)

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
!llvm.ident = !{!10}
!llvm.module.flags = !{!11, !12, !13}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "counter", scope: !2, file: !3, line: 59, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !9, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/088")
!4 = !{}
!5 = !{!6, !8}
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!9 = !{!0}
!10 = !{!"Ubuntu clang version 11.1.0-6"}
!11 = !{i32 7, !"Dwarf Version", i32 4}
!12 = !{i32 2, !"Debug Info Version", i32 3}
!13 = !{i32 1, !"wchar_size", i32 4}
!14 = distinct !DISubprogram(name: "foo", scope: !3, file: !3, line: 61, type: !15, scopeLine: 62, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!15 = !DISubroutineType(types: !16)
!16 = !{null}
!17 = !DILocation(line: 63, column: 6, scope: !14)
!18 = !DILocation(line: 63, column: 14, scope: !14)
!19 = !DILocation(line: 64, column: 1, scope: !14)
!20 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 66, type: !21, scopeLine: 67, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!21 = !DISubroutineType(types: !22)
!22 = !{!7}
!23 = !DILocation(line: 68, column: 20, scope: !20)
!24 = !DILocation(line: 68, column: 13, scope: !20)
!25 = !DILocation(line: 68, column: 11, scope: !20)
!26 = !DILocation(line: 69, column: 7, scope: !27)
!27 = distinct !DILexicalBlock(scope: !20, file: !3, line: 69, column: 7)
!28 = !DILocation(line: 69, column: 14, scope: !27)
!29 = !DILocation(line: 69, column: 7, scope: !20)
!30 = !DILocation(line: 71, column: 13, scope: !31)
!31 = distinct !DILexicalBlock(scope: !27, file: !3, line: 70, column: 3)
!32 = !DILocation(line: 71, column: 5, scope: !31)
!33 = !DILocation(line: 72, column: 5, scope: !31)
!34 = !DILocation(line: 74, column: 4, scope: !20)
!35 = !DILocation(line: 74, column: 12, scope: !20)
!36 = !DILocation(line: 77, column: 6, scope: !37)
!37 = distinct !DILexicalBlock(scope: !20, file: !3, line: 76, column: 3)
!38 = !DILocation(line: 79, column: 20, scope: !20)
!39 = !DILocation(line: 79, column: 19, scope: !20)
!40 = !DILocation(line: 79, column: 3, scope: !20)
!41 = !DILocation(line: 80, column: 9, scope: !20)
!42 = !DILocation(line: 80, column: 3, scope: !20)
!43 = !DILocation(line: 81, column: 3, scope: !20)
