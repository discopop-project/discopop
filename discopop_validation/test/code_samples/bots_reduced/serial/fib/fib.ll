; ModuleID = 'fib.c'
source_filename = "fib.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, %struct._IO_codecvt*, %struct._IO_wide_data*, %struct._IO_FILE*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type opaque
%struct._IO_codecvt = type opaque
%struct._IO_wide_data = type opaque

@res = internal global i64 0, align 8, !dbg !0
@bots_verbose_mode = external dso_local global i32, align 4
@stdout = external dso_local global %struct._IO_FILE*, align 8
@.str = private unnamed_addr constant [33 x i8] c"Fibonacci result for %d is %lld\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i64 @fib(i32 %n) #0 !dbg !18 {
entry:
  %retval = alloca i64, align 8
  %n.addr = alloca i32, align 4
  %x = alloca i64, align 8
  %y = alloca i64, align 8
  store i32 %n, i32* %n.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %n.addr, metadata !23, metadata !DIExpression()), !dbg !24
  call void @llvm.dbg.declare(metadata i64* %x, metadata !25, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.declare(metadata i64* %y, metadata !27, metadata !DIExpression()), !dbg !28
  %0 = load i32, i32* %n.addr, align 4, !dbg !29
  %cmp = icmp slt i32 %0, 2, !dbg !31
  br i1 %cmp, label %if.then, label %if.end, !dbg !32

if.then:                                          ; preds = %entry
  %1 = load i32, i32* %n.addr, align 4, !dbg !33
  %conv = sext i32 %1 to i64, !dbg !33
  store i64 %conv, i64* %retval, align 8, !dbg !34
  br label %return, !dbg !34

if.end:                                           ; preds = %entry
  %2 = load i32, i32* %n.addr, align 4, !dbg !35
  %sub = sub nsw i32 %2, 1, !dbg !36
  %call = call i64 @fib(i32 %sub), !dbg !37
  store i64 %call, i64* %x, align 8, !dbg !38
  %3 = load i32, i32* %n.addr, align 4, !dbg !39
  %sub1 = sub nsw i32 %3, 2, !dbg !40
  %call2 = call i64 @fib(i32 %sub1), !dbg !41
  store i64 %call2, i64* %y, align 8, !dbg !42
  %4 = load i64, i64* %x, align 8, !dbg !43
  %5 = load i64, i64* %y, align 8, !dbg !44
  %add = add nsw i64 %4, %5, !dbg !45
  store i64 %add, i64* %retval, align 8, !dbg !46
  br label %return, !dbg !46

return:                                           ; preds = %if.end, %if.then
  %6 = load i64, i64* %retval, align 8, !dbg !47
  ret i64 %6, !dbg !47
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @fib0(i32 %n) #0 !dbg !48 {
entry:
  %n.addr = alloca i32, align 4
  store i32 %n, i32* %n.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %n.addr, metadata !51, metadata !DIExpression()), !dbg !52
  %0 = load i32, i32* %n.addr, align 4, !dbg !53
  %call = call i64 @fib(i32 %0), !dbg !54
  store i64 %call, i64* @res, align 8, !dbg !55
  %1 = load i32, i32* @bots_verbose_mode, align 4, !dbg !56
  %cmp = icmp uge i32 %1, 1, !dbg !56
  br i1 %cmp, label %if.then, label %if.end, !dbg !59

if.then:                                          ; preds = %entry
  %2 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !60
  %3 = load i32, i32* %n.addr, align 4, !dbg !60
  %4 = load i64, i64* @res, align 8, !dbg !60
  %call1 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %2, i8* getelementptr inbounds ([33 x i8], [33 x i8]* @.str, i32 0, i32 0), i32 %3, i64 %4), !dbg !60
  br label %if.end, !dbg !60

if.end:                                           ; preds = %if.then, %entry
  ret void, !dbg !62
}

declare dso_local i32 @fprintf(%struct._IO_FILE*, i8*, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!14, !15, !16}
!llvm.ident = !{!17}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "res", scope: !2, file: !3, line: 24, type: !13, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 8.0.1-9 (tags/RELEASE_801/final)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !12, nameTableKind: None)
!3 = !DIFile(filename: "fib.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/fib")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 76, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "./bots.h", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/fib")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11}
!9 = !DIEnumerator(name: "BOTS_VERBOSE_NONE", value: 0, isUnsigned: true)
!10 = !DIEnumerator(name: "BOTS_VERBOSE_DEFAULT", value: 1, isUnsigned: true)
!11 = !DIEnumerator(name: "BOTS_VERBOSE_DEBUG", value: 2, isUnsigned: true)
!12 = !{!0}
!13 = !DIBasicType(name: "long long int", size: 64, encoding: DW_ATE_signed)
!14 = !{i32 2, !"Dwarf Version", i32 4}
!15 = !{i32 2, !"Debug Info Version", i32 3}
!16 = !{i32 1, !"wchar_size", i32 4}
!17 = !{!"clang version 8.0.1-9 (tags/RELEASE_801/final)"}
!18 = distinct !DISubprogram(name: "fib", scope: !3, file: !3, line: 26, type: !19, scopeLine: 27, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !22)
!19 = !DISubroutineType(types: !20)
!20 = !{!13, !21}
!21 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!22 = !{}
!23 = !DILocalVariable(name: "n", arg: 1, scope: !18, file: !3, line: 26, type: !21)
!24 = !DILocation(line: 26, column: 20, scope: !18)
!25 = !DILocalVariable(name: "x", scope: !18, file: !3, line: 28, type: !13)
!26 = !DILocation(line: 28, column: 12, scope: !18)
!27 = !DILocalVariable(name: "y", scope: !18, file: !3, line: 28, type: !13)
!28 = !DILocation(line: 28, column: 15, scope: !18)
!29 = !DILocation(line: 29, column: 6, scope: !30)
!30 = distinct !DILexicalBlock(scope: !18, file: !3, line: 29, column: 6)
!31 = !DILocation(line: 29, column: 8, scope: !30)
!32 = !DILocation(line: 29, column: 6, scope: !18)
!33 = !DILocation(line: 29, column: 20, scope: !30)
!34 = !DILocation(line: 29, column: 13, scope: !30)
!35 = !DILocation(line: 31, column: 10, scope: !18)
!36 = !DILocation(line: 31, column: 12, scope: !18)
!37 = !DILocation(line: 31, column: 6, scope: !18)
!38 = !DILocation(line: 31, column: 4, scope: !18)
!39 = !DILocation(line: 32, column: 10, scope: !18)
!40 = !DILocation(line: 32, column: 12, scope: !18)
!41 = !DILocation(line: 32, column: 6, scope: !18)
!42 = !DILocation(line: 32, column: 4, scope: !18)
!43 = !DILocation(line: 34, column: 9, scope: !18)
!44 = !DILocation(line: 34, column: 13, scope: !18)
!45 = !DILocation(line: 34, column: 11, scope: !18)
!46 = !DILocation(line: 34, column: 2, scope: !18)
!47 = !DILocation(line: 35, column: 1, scope: !18)
!48 = distinct !DISubprogram(name: "fib0", scope: !3, file: !3, line: 37, type: !49, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !22)
!49 = !DISubroutineType(types: !50)
!50 = !{null, !21}
!51 = !DILocalVariable(name: "n", arg: 1, scope: !48, file: !3, line: 37, type: !21)
!52 = !DILocation(line: 37, column: 16, scope: !48)
!53 = !DILocation(line: 39, column: 12, scope: !48)
!54 = !DILocation(line: 39, column: 8, scope: !48)
!55 = !DILocation(line: 39, column: 6, scope: !48)
!56 = !DILocation(line: 40, column: 2, scope: !57)
!57 = distinct !DILexicalBlock(scope: !58, file: !3, line: 40, column: 2)
!58 = distinct !DILexicalBlock(scope: !48, file: !3, line: 40, column: 2)
!59 = !DILocation(line: 40, column: 2, scope: !58)
!60 = !DILocation(line: 40, column: 2, scope: !61)
!61 = distinct !DILexicalBlock(scope: !57, file: !3, line: 40, column: 2)
!62 = !DILocation(line: 41, column: 1, scope: !48)
