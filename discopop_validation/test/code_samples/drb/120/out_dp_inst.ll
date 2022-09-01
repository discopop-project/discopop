; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.1 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"argc\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"argv\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"var\00", align 1
@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@.str.5 = private unnamed_addr constant [6 x i8] c"error\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16402, i32 1)
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %var = alloca i32, align 4
  %error = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16402, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  %1 = ptrtoint i32* %argc.addr to i64
  call void @__dp_write(i32 16402, i64 %1, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i32 0, i32 0))
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !14, metadata !DIExpression()), !dbg !15
  %2 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_write(i32 16402, i64 %2, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0))
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !16, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.declare(metadata i32* %var, metadata !18, metadata !DIExpression()), !dbg !19
  %3 = ptrtoint i32* %var to i64
  call void @__dp_write(i32 16404, i64 %3, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  store i32 0, i32* %var, align 4, !dbg !19
  %4 = ptrtoint i32* %var to i64
  call void @__dp_read(i32 16409, i64 %4, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  %5 = load i32, i32* %var, align 4, !dbg !20
  %inc = add nsw i32 %5, 1, !dbg !20
  %6 = ptrtoint i32* %var to i64
  call void @__dp_write(i32 16409, i64 %6, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  store i32 %inc, i32* %var, align 4, !dbg !20
  %7 = ptrtoint i32* %var to i64
  call void @__dp_read(i32 16414, i64 %7, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  %8 = load i32, i32* %var, align 4, !dbg !22
  %inc1 = add nsw i32 %8, 1, !dbg !22
  %9 = ptrtoint i32* %var to i64
  call void @__dp_write(i32 16414, i64 %9, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  store i32 %inc1, i32* %var, align 4, !dbg !22
  %10 = ptrtoint i32* %var to i64
  call void @__dp_read(i32 16417, i64 %10, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  %11 = load i32, i32* %var, align 4, !dbg !23
  %cmp = icmp ne i32 %11, 2, !dbg !25
  br i1 %cmp, label %if.then, label %if.end, !dbg !26

if.then:                                          ; preds = %entry
  %12 = ptrtoint i32* %var to i64
  call void @__dp_read(i32 16417, i64 %12, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  %13 = load i32, i32* %var, align 4, !dbg !27
  call void @__dp_call(i32 16417), !dbg !28
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 %13), !dbg !28
  br label %if.end, !dbg !28

if.end:                                           ; preds = %if.then, %entry
  call void @llvm.dbg.declare(metadata i32* %error, metadata !29, metadata !DIExpression()), !dbg !30
  %14 = ptrtoint i32* %var to i64
  call void @__dp_read(i32 16418, i64 %14, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  %15 = load i32, i32* %var, align 4, !dbg !31
  %cmp2 = icmp ne i32 %15, 2, !dbg !32
  %conv = zext i1 %cmp2 to i32, !dbg !32
  %16 = ptrtoint i32* %error to i64
  call void @__dp_write(i32 16418, i64 %16, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.5, i32 0, i32 0))
  store i32 %conv, i32* %error, align 4, !dbg !30
  %17 = ptrtoint i32* %error to i64
  call void @__dp_read(i32 16419, i64 %17, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.5, i32 0, i32 0))
  %18 = load i32, i32* %error, align 4, !dbg !33
  call void @__dp_finalize(i32 16419), !dbg !34
  ret i32 %18, !dbg !34
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
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/120")
!2 = !{}
!3 = !{!"Ubuntu clang version 11.1.0-6"}
!4 = !{i32 7, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 18, type: !8, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10, !10, !11}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!13 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!14 = !DILocalVariable(name: "argc", arg: 1, scope: !7, file: !1, line: 18, type: !10)
!15 = !DILocation(line: 18, column: 14, scope: !7)
!16 = !DILocalVariable(name: "argv", arg: 2, scope: !7, file: !1, line: 18, type: !11)
!17 = !DILocation(line: 18, column: 26, scope: !7)
!18 = !DILocalVariable(name: "var", scope: !7, file: !1, line: 20, type: !10)
!19 = !DILocation(line: 20, column: 7, scope: !7)
!20 = !DILocation(line: 25, column: 8, scope: !21)
!21 = distinct !DILexicalBlock(scope: !7, file: !1, line: 23, column: 3)
!22 = !DILocation(line: 30, column: 8, scope: !21)
!23 = !DILocation(line: 33, column: 6, scope: !24)
!24 = distinct !DILexicalBlock(scope: !7, file: !1, line: 33, column: 6)
!25 = !DILocation(line: 33, column: 10, scope: !24)
!26 = !DILocation(line: 33, column: 6, scope: !7)
!27 = !DILocation(line: 33, column: 30, scope: !24)
!28 = !DILocation(line: 33, column: 16, scope: !24)
!29 = !DILocalVariable(name: "error", scope: !7, file: !1, line: 34, type: !10)
!30 = !DILocation(line: 34, column: 7, scope: !7)
!31 = !DILocation(line: 34, column: 16, scope: !7)
!32 = !DILocation(line: 34, column: 20, scope: !7)
!33 = !DILocation(line: 35, column: 10, scope: !7)
!34 = !DILocation(line: 35, column: 3, scope: !7)
