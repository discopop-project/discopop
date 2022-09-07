; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.1 = private unnamed_addr constant [2 x i8] c"n\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"j\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"s\00", align 1
@.str.6 = private unnamed_addr constant [5 x i8] c"argc\00", align 1
@.str.7 = private unnamed_addr constant [5 x i8] c"argv\00", align 1
@.str = private unnamed_addr constant [14 x i8] c"fib(%i) = %i\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @fib(i32 %n) #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16402, i32 0)
  %retval = alloca i32, align 4
  %n.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %s = alloca i32, align 4
  %0 = ptrtoint i32* %n.addr to i64
  call void @__dp_write(i32 16402, i64 %0, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 %n, i32* %n.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %n.addr, metadata !11, metadata !DIExpression()), !dbg !12
  call void @llvm.dbg.declare(metadata i32* %i, metadata !13, metadata !DIExpression()), !dbg !14
  call void @llvm.dbg.declare(metadata i32* %j, metadata !15, metadata !DIExpression()), !dbg !16
  call void @llvm.dbg.declare(metadata i32* %s, metadata !17, metadata !DIExpression()), !dbg !18
  %1 = ptrtoint i32* %n.addr to i64
  call void @__dp_read(i32 16404, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %2 = load i32, i32* %n.addr, align 4, !dbg !19
  %cmp = icmp slt i32 %2, 2, !dbg !21
  br i1 %cmp, label %if.then, label %if.end, !dbg !22

if.then:                                          ; preds = %entry
  %3 = ptrtoint i32* %n.addr to i64
  call void @__dp_read(i32 16405, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %4 = load i32, i32* %n.addr, align 4, !dbg !23
  %5 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16405, i64 %5, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  store i32 %4, i32* %retval, align 4, !dbg !24
  br label %return, !dbg !24

if.end:                                           ; preds = %entry
  %6 = ptrtoint i32* %n.addr to i64
  call void @__dp_read(i32 16407, i64 %6, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %7 = load i32, i32* %n.addr, align 4, !dbg !25
  %sub = sub nsw i32 %7, 1, !dbg !26
  call void @__dp_call(i32 16407), !dbg !27
  %call = call i32 @fib(i32 %sub), !dbg !27
  %8 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16407, i64 %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 %call, i32* %i, align 4, !dbg !28
  %9 = ptrtoint i32* %n.addr to i64
  call void @__dp_read(i32 16409, i64 %9, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %10 = load i32, i32* %n.addr, align 4, !dbg !29
  %sub1 = sub nsw i32 %10, 2, !dbg !30
  call void @__dp_call(i32 16409), !dbg !31
  %call2 = call i32 @fib(i32 %sub1), !dbg !31
  %11 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16409, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 %call2, i32* %j, align 4, !dbg !32
  %12 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16411, i64 %12, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %13 = load i32, i32* %i, align 4, !dbg !33
  %14 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16411, i64 %14, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %15 = load i32, i32* %j, align 4, !dbg !34
  %add = add nsw i32 %13, %15, !dbg !35
  %16 = ptrtoint i32* %s to i64
  call void @__dp_write(i32 16411, i64 %16, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 %add, i32* %s, align 4, !dbg !36
  %17 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16413, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %18 = load i32, i32* %i, align 4, !dbg !37
  %19 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16413, i64 %19, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %20 = load i32, i32* %j, align 4, !dbg !38
  %add3 = add nsw i32 %18, %20, !dbg !39
  %21 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16413, i64 %21, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  store i32 %add3, i32* %retval, align 4, !dbg !40
  br label %return, !dbg !40

return:                                           ; preds = %if.end, %if.then
  %22 = ptrtoint i32* %retval to i64
  call void @__dp_read(i32 16414, i64 %22, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  %23 = load i32, i32* %retval, align 4, !dbg !41
  call void @__dp_func_exit(i32 16414, i32 0), !dbg !41
  ret i32 %23, !dbg !41
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_call(i32)

declare void @__dp_func_exit(i32, i32)

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !42 {
entry:
  call void @__dp_func_entry(i32 16416, i32 1)
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %n = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16416, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  %1 = ptrtoint i32* %argc.addr to i64
  call void @__dp_write(i32 16416, i64 %1, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.6, i32 0, i32 0))
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !48, metadata !DIExpression()), !dbg !49
  %2 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_write(i32 16416, i64 %2, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.7, i32 0, i32 0))
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !50, metadata !DIExpression()), !dbg !51
  call void @llvm.dbg.declare(metadata i32* %n, metadata !52, metadata !DIExpression()), !dbg !53
  %3 = ptrtoint i32* %n to i64
  call void @__dp_write(i32 16417, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 10, i32* %n, align 4, !dbg !53
  %4 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 16418, i64 %4, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.6, i32 0, i32 0))
  %5 = load i32, i32* %argc.addr, align 4, !dbg !54
  %cmp = icmp sgt i32 %5, 1, !dbg !56
  br i1 %cmp, label %if.then, label %if.end, !dbg !57

if.then:                                          ; preds = %entry
  %6 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 16419, i64 %6, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.7, i32 0, i32 0))
  %7 = load i8**, i8*** %argv.addr, align 8, !dbg !58
  %arrayidx = getelementptr inbounds i8*, i8** %7, i64 1, !dbg !58
  %8 = ptrtoint i8** %arrayidx to i64
  call void @__dp_read(i32 16419, i64 %8, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.7, i32 0, i32 0))
  %9 = load i8*, i8** %arrayidx, align 8, !dbg !58
  call void @__dp_call(i32 16419), !dbg !59
  %call = call i32 @atoi(i8* %9) #4, !dbg !59
  %10 = ptrtoint i32* %n to i64
  call void @__dp_write(i32 16419, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 %call, i32* %n, align 4, !dbg !60
  br label %if.end, !dbg !61

if.end:                                           ; preds = %if.then, %entry
  %11 = ptrtoint i32* %n to i64
  call void @__dp_read(i32 16421, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %12 = load i32, i32* %n, align 4, !dbg !62
  %13 = ptrtoint i32* %n to i64
  call void @__dp_read(i32 16421, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %14 = load i32, i32* %n, align 4, !dbg !64
  call void @__dp_call(i32 16421), !dbg !65
  %call1 = call i32 @fib(i32 %14), !dbg !65
  call void @__dp_call(i32 16421), !dbg !66
  %call2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str, i64 0, i64 0), i32 %12, i32 %call1), !dbg !66
  call void @__dp_finalize(i32 16422), !dbg !67
  ret i32 0, !dbg !67
}

; Function Attrs: nounwind readonly
declare dso_local i32 @atoi(i8*) #2

declare dso_local i32 @printf(i8*, ...) #3

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind readonly }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!3}
!llvm.module.flags = !{!4, !5, !6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/176")
!2 = !{}
!3 = !{!"Ubuntu clang version 11.1.0-6"}
!4 = !{i32 7, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = distinct !DISubprogram(name: "fib", scope: !1, file: !1, line: 18, type: !8, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10, !10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "n", arg: 1, scope: !7, file: !1, line: 18, type: !10)
!12 = !DILocation(line: 18, column: 13, scope: !7)
!13 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 19, type: !10)
!14 = !DILocation(line: 19, column: 7, scope: !7)
!15 = !DILocalVariable(name: "j", scope: !7, file: !1, line: 19, type: !10)
!16 = !DILocation(line: 19, column: 10, scope: !7)
!17 = !DILocalVariable(name: "s", scope: !7, file: !1, line: 19, type: !10)
!18 = !DILocation(line: 19, column: 13, scope: !7)
!19 = !DILocation(line: 20, column: 7, scope: !20)
!20 = distinct !DILexicalBlock(scope: !7, file: !1, line: 20, column: 7)
!21 = !DILocation(line: 20, column: 9, scope: !20)
!22 = !DILocation(line: 20, column: 7, scope: !7)
!23 = !DILocation(line: 21, column: 12, scope: !20)
!24 = !DILocation(line: 21, column: 5, scope: !20)
!25 = !DILocation(line: 23, column: 11, scope: !7)
!26 = !DILocation(line: 23, column: 13, scope: !7)
!27 = !DILocation(line: 23, column: 7, scope: !7)
!28 = !DILocation(line: 23, column: 5, scope: !7)
!29 = !DILocation(line: 25, column: 11, scope: !7)
!30 = !DILocation(line: 25, column: 13, scope: !7)
!31 = !DILocation(line: 25, column: 7, scope: !7)
!32 = !DILocation(line: 25, column: 5, scope: !7)
!33 = !DILocation(line: 27, column: 7, scope: !7)
!34 = !DILocation(line: 27, column: 11, scope: !7)
!35 = !DILocation(line: 27, column: 9, scope: !7)
!36 = !DILocation(line: 27, column: 5, scope: !7)
!37 = !DILocation(line: 29, column: 10, scope: !7)
!38 = !DILocation(line: 29, column: 14, scope: !7)
!39 = !DILocation(line: 29, column: 12, scope: !7)
!40 = !DILocation(line: 29, column: 3, scope: !7)
!41 = !DILocation(line: 30, column: 1, scope: !7)
!42 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 32, type: !43, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!43 = !DISubroutineType(types: !44)
!44 = !{!10, !10, !45}
!45 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !46, size: 64)
!46 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !47, size: 64)
!47 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!48 = !DILocalVariable(name: "argc", arg: 1, scope: !42, file: !1, line: 32, type: !10)
!49 = !DILocation(line: 32, column: 14, scope: !42)
!50 = !DILocalVariable(name: "argv", arg: 2, scope: !42, file: !1, line: 32, type: !45)
!51 = !DILocation(line: 32, column: 27, scope: !42)
!52 = !DILocalVariable(name: "n", scope: !42, file: !1, line: 33, type: !10)
!53 = !DILocation(line: 33, column: 7, scope: !42)
!54 = !DILocation(line: 34, column: 7, scope: !55)
!55 = distinct !DILexicalBlock(scope: !42, file: !1, line: 34, column: 7)
!56 = !DILocation(line: 34, column: 12, scope: !55)
!57 = !DILocation(line: 34, column: 7, scope: !42)
!58 = !DILocation(line: 35, column: 14, scope: !55)
!59 = !DILocation(line: 35, column: 9, scope: !55)
!60 = !DILocation(line: 35, column: 7, scope: !55)
!61 = !DILocation(line: 35, column: 5, scope: !55)
!62 = !DILocation(line: 37, column: 30, scope: !63)
!63 = distinct !DILexicalBlock(scope: !42, file: !1, line: 37, column: 3)
!64 = !DILocation(line: 37, column: 37, scope: !63)
!65 = !DILocation(line: 37, column: 33, scope: !63)
!66 = !DILocation(line: 37, column: 5, scope: !63)
!67 = !DILocation(line: 38, column: 3, scope: !42)
