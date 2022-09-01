; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.1 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"argc\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"argv\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"tmp\00", align 1
@.str.5 = private unnamed_addr constant [4 x i8] c"len\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.7 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str = private unnamed_addr constant [10 x i8] c"a[50]=%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16438, i32 1)
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %tmp = alloca i32, align 4
  %len = alloca i32, align 4
  %a = alloca [100 x i32], align 16
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16438, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  %1 = ptrtoint i32* %argc.addr to i64
  call void @__dp_write(i32 16438, i64 %1, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i32 0, i32 0))
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !14, metadata !DIExpression()), !dbg !15
  %2 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_write(i32 16438, i64 %2, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0))
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !16, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.declare(metadata i32* %i, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32* %tmp, metadata !20, metadata !DIExpression()), !dbg !21
  %3 = ptrtoint i32* %tmp to i64
  call void @__dp_write(i32 16442, i64 %3, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  store i32 10, i32* %tmp, align 4, !dbg !22
  call void @llvm.dbg.declare(metadata i32* %len, metadata !23, metadata !DIExpression()), !dbg !24
  %4 = ptrtoint i32* %len to i64
  call void @__dp_write(i32 16443, i64 %4, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i32 0, i32 0))
  store i32 100, i32* %len, align 4, !dbg !24
  call void @llvm.dbg.declare(metadata [100 x i32]* %a, metadata !25, metadata !DIExpression()), !dbg !29
  %5 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16448, i64 %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !30
  br label %for.cond, !dbg !32

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16448, i32 0)
  %6 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16448, i64 %6, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %7 = load i32, i32* %i, align 4, !dbg !33
  %8 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16448, i64 %8, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i32 0, i32 0))
  %9 = load i32, i32* %len, align 4, !dbg !35
  %cmp = icmp slt i32 %7, %9, !dbg !36
  br i1 %cmp, label %for.body, label %for.end, !dbg !37

for.body:                                         ; preds = %for.cond
  %10 = ptrtoint i32* %tmp to i64
  call void @__dp_read(i32 16450, i64 %10, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  %11 = load i32, i32* %tmp, align 4, !dbg !38
  %12 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16450, i64 %12, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %13 = load i32, i32* %i, align 4, !dbg !40
  %idxprom = sext i32 %13 to i64, !dbg !41
  %arrayidx = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom, !dbg !41
  %14 = ptrtoint i32* %arrayidx to i64
  call void @__dp_write(i32 16450, i64 %14, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 %11, i32* %arrayidx, align 4, !dbg !42
  %15 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16451, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %16 = load i32, i32* %i, align 4, !dbg !43
  %idxprom1 = sext i32 %16 to i64, !dbg !44
  %arrayidx2 = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom1, !dbg !44
  %17 = ptrtoint i32* %arrayidx2 to i64
  call void @__dp_read(i32 16451, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %18 = load i32, i32* %arrayidx2, align 4, !dbg !44
  %19 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16451, i64 %19, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %20 = load i32, i32* %i, align 4, !dbg !45
  %add = add nsw i32 %18, %20, !dbg !46
  %21 = ptrtoint i32* %tmp to i64
  call void @__dp_write(i32 16451, i64 %21, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  store i32 %add, i32* %tmp, align 4, !dbg !47
  br label %for.inc, !dbg !48

for.inc:                                          ; preds = %for.body
  %22 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16448, i64 %22, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %23 = load i32, i32* %i, align 4, !dbg !49
  %inc = add nsw i32 %23, 1, !dbg !49
  %24 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16448, i64 %24, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !49
  br label %for.cond, !dbg !50, !llvm.loop !51

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16454, i32 0)
  %arrayidx3 = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 50, !dbg !53
  %25 = ptrtoint i32* %arrayidx3 to i64
  call void @__dp_read(i32 16454, i64 %25, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %26 = load i32, i32* %arrayidx3, align 8, !dbg !53
  call void @__dp_call(i32 16454), !dbg !54
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 %26), !dbg !54
  call void @__dp_finalize(i32 16455), !dbg !55
  ret i32 0, !dbg !55
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
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/035")
!2 = !{}
!3 = !{!"Ubuntu clang version 11.1.0-6"}
!4 = !{i32 7, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 54, type: !8, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10, !10, !11}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!13 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!14 = !DILocalVariable(name: "argc", arg: 1, scope: !7, file: !1, line: 54, type: !10)
!15 = !DILocation(line: 54, column: 14, scope: !7)
!16 = !DILocalVariable(name: "argv", arg: 2, scope: !7, file: !1, line: 54, type: !11)
!17 = !DILocation(line: 54, column: 26, scope: !7)
!18 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 56, type: !10)
!19 = !DILocation(line: 56, column: 7, scope: !7)
!20 = !DILocalVariable(name: "tmp", scope: !7, file: !1, line: 57, type: !10)
!21 = !DILocation(line: 57, column: 7, scope: !7)
!22 = !DILocation(line: 58, column: 7, scope: !7)
!23 = !DILocalVariable(name: "len", scope: !7, file: !1, line: 59, type: !10)
!24 = !DILocation(line: 59, column: 7, scope: !7)
!25 = !DILocalVariable(name: "a", scope: !7, file: !1, line: 61, type: !26)
!26 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 3200, elements: !27)
!27 = !{!28}
!28 = !DISubrange(count: 100)
!29 = !DILocation(line: 61, column: 7, scope: !7)
!30 = !DILocation(line: 64, column: 9, scope: !31)
!31 = distinct !DILexicalBlock(scope: !7, file: !1, line: 64, column: 3)
!32 = !DILocation(line: 64, column: 8, scope: !31)
!33 = !DILocation(line: 64, column: 12, scope: !34)
!34 = distinct !DILexicalBlock(scope: !31, file: !1, line: 64, column: 3)
!35 = !DILocation(line: 64, column: 14, scope: !34)
!36 = !DILocation(line: 64, column: 13, scope: !34)
!37 = !DILocation(line: 64, column: 3, scope: !31)
!38 = !DILocation(line: 66, column: 12, scope: !39)
!39 = distinct !DILexicalBlock(scope: !34, file: !1, line: 65, column: 3)
!40 = !DILocation(line: 66, column: 7, scope: !39)
!41 = !DILocation(line: 66, column: 5, scope: !39)
!42 = !DILocation(line: 66, column: 10, scope: !39)
!43 = !DILocation(line: 67, column: 12, scope: !39)
!44 = !DILocation(line: 67, column: 10, scope: !39)
!45 = !DILocation(line: 67, column: 15, scope: !39)
!46 = !DILocation(line: 67, column: 14, scope: !39)
!47 = !DILocation(line: 67, column: 9, scope: !39)
!48 = !DILocation(line: 68, column: 3, scope: !39)
!49 = !DILocation(line: 64, column: 19, scope: !34)
!50 = !DILocation(line: 64, column: 3, scope: !34)
!51 = distinct !{!51, !37, !52}
!52 = !DILocation(line: 68, column: 3, scope: !31)
!53 = !DILocation(line: 70, column: 24, scope: !7)
!54 = !DILocation(line: 70, column: 3, scope: !7)
!55 = !DILocation(line: 71, column: 3, scope: !7)
