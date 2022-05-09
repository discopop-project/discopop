; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.1 = private unnamed_addr constant [7 x i8] c"n.addr\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"n\00", align 1
@res = internal global i64 0, align 8, !dbg !0
@.str.6 = private unnamed_addr constant [4 x i8] c"res\00", align 1
@.str = private unnamed_addr constant [33 x i8] c"Fibonacci result for %d is %lld\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i64 @fib(i32 %n) #0 !dbg !11 {
entry:
  call void @__dp_func_entry(i32 16389, i32 0)
  %retval = alloca i64, align 8
  %n.addr = alloca i32, align 4
  %x = alloca i64, align 8
  %y = alloca i64, align 8
  %0 = ptrtoint i32* %n.addr to i64
  call void @__dp_write(i32 16389, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 %n, i32* %n.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %n.addr, metadata !15, metadata !DIExpression()), !dbg !16
  call void @llvm.dbg.declare(metadata i64* %x, metadata !17, metadata !DIExpression()), !dbg !18
  call void @llvm.dbg.declare(metadata i64* %y, metadata !19, metadata !DIExpression()), !dbg !20
  %1 = ptrtoint i32* %n.addr to i64
  call void @__dp_read(i32 16392, i64 %1, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  %2 = load i32, i32* %n.addr, align 4, !dbg !21
  %cmp = icmp slt i32 %2, 2, !dbg !23
  br i1 %cmp, label %if.then, label %if.end, !dbg !24

if.then:                                          ; preds = %entry
  %3 = ptrtoint i32* %n.addr to i64
  call void @__dp_read(i32 16392, i64 %3, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  %4 = load i32, i32* %n.addr, align 4, !dbg !25
  %conv = sext i32 %4 to i64, !dbg !25
  %5 = ptrtoint i64* %retval to i64
  call void @__dp_write(i32 16392, i64 %5, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  store i64 %conv, i64* %retval, align 8, !dbg !26
  br label %return, !dbg !26

if.end:                                           ; preds = %entry
  %6 = ptrtoint i32* %n.addr to i64
  call void @__dp_read(i32 16394, i64 %6, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  %7 = load i32, i32* %n.addr, align 4, !dbg !27
  %sub = sub nsw i32 %7, 1, !dbg !28
  call void @__dp_call(i32 16394), !dbg !29
  %call = call i64 @fib(i32 %sub), !dbg !29
  %8 = ptrtoint i64* %x to i64
  call void @__dp_write(i32 16394, i64 %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i64 %call, i64* %x, align 8, !dbg !30
  %9 = ptrtoint i32* %n.addr to i64
  call void @__dp_read(i32 16395, i64 %9, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  %10 = load i32, i32* %n.addr, align 4, !dbg !31
  %sub1 = sub nsw i32 %10, 2, !dbg !32
  call void @__dp_call(i32 16395), !dbg !33
  %call2 = call i64 @fib(i32 %sub1), !dbg !33
  %11 = ptrtoint i64* %y to i64
  call void @__dp_write(i32 16395, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i64 %call2, i64* %y, align 8, !dbg !34
  %12 = ptrtoint i64* %x to i64
  call void @__dp_read(i32 16397, i64 %12, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %13 = load i64, i64* %x, align 8, !dbg !35
  %14 = ptrtoint i64* %y to i64
  call void @__dp_read(i32 16397, i64 %14, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %15 = load i64, i64* %y, align 8, !dbg !36
  %add = add nsw i64 %13, %15, !dbg !37
  %16 = ptrtoint i64* %retval to i64
  call void @__dp_write(i32 16397, i64 %16, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  store i64 %add, i64* %retval, align 8, !dbg !38
  br label %return, !dbg !38

return:                                           ; preds = %if.end, %if.then
  %17 = ptrtoint i64* %retval to i64
  call void @__dp_read(i32 16398, i64 %17, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  %18 = load i64, i64* %retval, align 8, !dbg !39
  call void @__dp_func_exit(i32 16398, i32 0), !dbg !39
  ret i64 %18, !dbg !39
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_call(i32)

declare void @__dp_func_exit(i32, i32)

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !40 {
entry:
  call void @__dp_func_entry(i32 16400, i32 1)
  %n = alloca i32, align 4
  call void @llvm.dbg.declare(metadata i32* %n, metadata !43, metadata !DIExpression()), !dbg !44
  %0 = ptrtoint i32* %n to i64
  call void @__dp_write(i32 16402, i64 %0, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 10, i32* %n, align 4, !dbg !44
  %1 = ptrtoint i32* %n to i64
  call void @__dp_read(i32 16403, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %2 = load i32, i32* %n, align 4, !dbg !45
  call void @__dp_call(i32 16403), !dbg !46
  %call = call i64 @fib(i32 %2), !dbg !46
  %3 = ptrtoint i64* @res to i64
  call void @__dp_write(i32 16403, i64 %3, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.6, i32 0, i32 0))
  store i64 %call, i64* @res, align 8, !dbg !47
  %4 = ptrtoint i32* %n to i64
  call void @__dp_read(i32 16404, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %5 = load i32, i32* %n, align 4, !dbg !48
  %6 = ptrtoint i64* @res to i64
  call void @__dp_read(i32 16404, i64 %6, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.6, i32 0, i32 0))
  %7 = load i64, i64* @res, align 8, !dbg !49
  call void @__dp_call(i32 16404), !dbg !50
  %call1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([33 x i8], [33 x i8]* @.str, i32 0, i32 0), i32 %5, i64 %7), !dbg !50
  call void @__dp_finalize(i32 16405), !dbg !51
  ret i32 0, !dbg !51
}

declare dso_local i32 @printf(i8*, ...) #2

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!7}
!llvm.module.flags = !{!8, !9, !10}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "res", scope: !2, file: !3, line: 3, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 8.0.1-9 (tags/RELEASE_801/final)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/discopop/fib")
!4 = !{}
!5 = !{!0}
!6 = !DIBasicType(name: "long long int", size: 64, encoding: DW_ATE_signed)
!7 = !{!"clang version 8.0.1-9 (tags/RELEASE_801/final)"}
!8 = !{i32 2, !"Dwarf Version", i32 4}
!9 = !{i32 2, !"Debug Info Version", i32 3}
!10 = !{i32 1, !"wchar_size", i32 4}
!11 = distinct !DISubprogram(name: "fib", scope: !3, file: !3, line: 5, type: !12, scopeLine: 6, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!12 = !DISubroutineType(types: !13)
!13 = !{!6, !14}
!14 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!15 = !DILocalVariable(name: "n", arg: 1, scope: !11, file: !3, line: 5, type: !14)
!16 = !DILocation(line: 5, column: 20, scope: !11)
!17 = !DILocalVariable(name: "x", scope: !11, file: !3, line: 7, type: !6)
!18 = !DILocation(line: 7, column: 12, scope: !11)
!19 = !DILocalVariable(name: "y", scope: !11, file: !3, line: 7, type: !6)
!20 = !DILocation(line: 7, column: 15, scope: !11)
!21 = !DILocation(line: 8, column: 6, scope: !22)
!22 = distinct !DILexicalBlock(scope: !11, file: !3, line: 8, column: 6)
!23 = !DILocation(line: 8, column: 8, scope: !22)
!24 = !DILocation(line: 8, column: 6, scope: !11)
!25 = !DILocation(line: 8, column: 20, scope: !22)
!26 = !DILocation(line: 8, column: 13, scope: !22)
!27 = !DILocation(line: 10, column: 10, scope: !11)
!28 = !DILocation(line: 10, column: 12, scope: !11)
!29 = !DILocation(line: 10, column: 6, scope: !11)
!30 = !DILocation(line: 10, column: 4, scope: !11)
!31 = !DILocation(line: 11, column: 10, scope: !11)
!32 = !DILocation(line: 11, column: 12, scope: !11)
!33 = !DILocation(line: 11, column: 6, scope: !11)
!34 = !DILocation(line: 11, column: 4, scope: !11)
!35 = !DILocation(line: 13, column: 9, scope: !11)
!36 = !DILocation(line: 13, column: 13, scope: !11)
!37 = !DILocation(line: 13, column: 11, scope: !11)
!38 = !DILocation(line: 13, column: 2, scope: !11)
!39 = !DILocation(line: 14, column: 1, scope: !11)
!40 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 16, type: !41, scopeLine: 17, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!41 = !DISubroutineType(types: !42)
!42 = !{!14}
!43 = !DILocalVariable(name: "n", scope: !40, file: !3, line: 18, type: !14)
!44 = !DILocation(line: 18, column: 9, scope: !40)
!45 = !DILocation(line: 19, column: 12, scope: !40)
!46 = !DILocation(line: 19, column: 8, scope: !40)
!47 = !DILocation(line: 19, column: 6, scope: !40)
!48 = !DILocation(line: 20, column: 45, scope: !40)
!49 = !DILocation(line: 20, column: 47, scope: !40)
!50 = !DILocation(line: 20, column: 2, scope: !40)
!51 = !DILocation(line: 21, column: 1, scope: !40)
