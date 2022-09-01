; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.1 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"argc\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"argv\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"len\00", align 1
@.str.5 = private unnamed_addr constant [9 x i8] c"numNodes\00", align 1
@.str.6 = private unnamed_addr constant [10 x i8] c"numNodes2\00", align 1
@.str.7 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str = private unnamed_addr constant [16 x i8] c"numNodes2 = %d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16438, i32 1)
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %len = alloca i32, align 4
  %numNodes = alloca i32, align 4
  %numNodes2 = alloca i32, align 4
  %x = alloca [100 x i32], align 16
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
  call void @llvm.dbg.declare(metadata i32* %len, metadata !20, metadata !DIExpression()), !dbg !21
  %3 = ptrtoint i32* %len to i64
  call void @__dp_write(i32 16441, i64 %3, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  store i32 100, i32* %len, align 4, !dbg !21
  call void @llvm.dbg.declare(metadata i32* %numNodes, metadata !22, metadata !DIExpression()), !dbg !23
  %4 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16443, i64 %4, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  %5 = load i32, i32* %len, align 4, !dbg !24
  %6 = ptrtoint i32* %numNodes to i64
  call void @__dp_write(i32 16443, i64 %6, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.5, i32 0, i32 0))
  store i32 %5, i32* %numNodes, align 4, !dbg !23
  call void @llvm.dbg.declare(metadata i32* %numNodes2, metadata !25, metadata !DIExpression()), !dbg !26
  %7 = ptrtoint i32* %numNodes2 to i64
  call void @__dp_write(i32 16443, i64 %7, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.6, i32 0, i32 0))
  store i32 0, i32* %numNodes2, align 4, !dbg !26
  call void @llvm.dbg.declare(metadata [100 x i32]* %x, metadata !27, metadata !DIExpression()), !dbg !31
  %8 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16447, i64 %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !32
  br label %for.cond, !dbg !34

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16447, i32 0)
  %9 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16447, i64 %9, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %10 = load i32, i32* %i, align 4, !dbg !35
  %11 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16447, i64 %11, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  %12 = load i32, i32* %len, align 4, !dbg !37
  %cmp = icmp slt i32 %10, %12, !dbg !38
  br i1 %cmp, label %for.body, label %for.end, !dbg !39

for.body:                                         ; preds = %for.cond
  %13 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16449, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %14 = load i32, i32* %i, align 4, !dbg !40
  %rem = srem i32 %14, 2, !dbg !43
  %cmp1 = icmp eq i32 %rem, 0, !dbg !44
  br i1 %cmp1, label %if.then, label %if.else, !dbg !45

if.then:                                          ; preds = %for.body
  %15 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16450, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %16 = load i32, i32* %i, align 4, !dbg !46
  %idxprom = sext i32 %16 to i64, !dbg !47
  %arrayidx = getelementptr inbounds [100 x i32], [100 x i32]* %x, i64 0, i64 %idxprom, !dbg !47
  %17 = ptrtoint i32* %arrayidx to i64
  call void @__dp_write(i32 16450, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  store i32 5, i32* %arrayidx, align 4, !dbg !48
  br label %if.end, !dbg !47

if.else:                                          ; preds = %for.body
  %18 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16452, i64 %18, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %19 = load i32, i32* %i, align 4, !dbg !49
  %idxprom2 = sext i32 %19 to i64, !dbg !50
  %arrayidx3 = getelementptr inbounds [100 x i32], [100 x i32]* %x, i64 0, i64 %idxprom2, !dbg !50
  %20 = ptrtoint i32* %arrayidx3 to i64
  call void @__dp_write(i32 16452, i64 %20, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  store i32 -5, i32* %arrayidx3, align 4, !dbg !51
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  br label %for.inc, !dbg !52

for.inc:                                          ; preds = %if.end
  %21 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16447, i64 %21, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %22 = load i32, i32* %i, align 4, !dbg !53
  %inc = add nsw i32 %22, 1, !dbg !53
  %23 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16447, i64 %23, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !53
  br label %for.cond, !dbg !54, !llvm.loop !55

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16456, i32 0)
  %24 = ptrtoint i32* %numNodes to i64
  call void @__dp_read(i32 16456, i64 %24, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.5, i32 0, i32 0))
  %25 = load i32, i32* %numNodes, align 4, !dbg !57
  %sub = sub nsw i32 %25, 1, !dbg !59
  %26 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16456, i64 %26, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 %sub, i32* %i, align 4, !dbg !60
  br label %for.cond4, !dbg !61

for.cond4:                                        ; preds = %for.inc12, %for.end
  call void @__dp_loop_entry(i32 16456, i32 1)
  %27 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16456, i64 %27, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %28 = load i32, i32* %i, align 4, !dbg !62
  %cmp5 = icmp sgt i32 %28, -1, !dbg !64
  br i1 %cmp5, label %for.body6, label %for.end14, !dbg !65

for.body6:                                        ; preds = %for.cond4
  %29 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16457, i64 %29, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %30 = load i32, i32* %i, align 4, !dbg !66
  %idxprom7 = sext i32 %30 to i64, !dbg !69
  %arrayidx8 = getelementptr inbounds [100 x i32], [100 x i32]* %x, i64 0, i64 %idxprom7, !dbg !69
  %31 = ptrtoint i32* %arrayidx8 to i64
  call void @__dp_read(i32 16457, i64 %31, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %32 = load i32, i32* %arrayidx8, align 4, !dbg !69
  %cmp9 = icmp sle i32 %32, 0, !dbg !70
  br i1 %cmp9, label %if.then10, label %if.end11, !dbg !71

if.then10:                                        ; preds = %for.body6
  %33 = ptrtoint i32* %numNodes2 to i64
  call void @__dp_read(i32 16458, i64 %33, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.6, i32 0, i32 0))
  %34 = load i32, i32* %numNodes2, align 4, !dbg !72
  %dec = add nsw i32 %34, -1, !dbg !72
  %35 = ptrtoint i32* %numNodes2 to i64
  call void @__dp_write(i32 16458, i64 %35, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.6, i32 0, i32 0))
  store i32 %dec, i32* %numNodes2, align 4, !dbg !72
  br label %if.end11, !dbg !74

if.end11:                                         ; preds = %if.then10, %for.body6
  br label %for.inc12, !dbg !75

for.inc12:                                        ; preds = %if.end11
  %36 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16456, i64 %36, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %37 = load i32, i32* %i, align 4, !dbg !76
  %dec13 = add nsw i32 %37, -1, !dbg !76
  %38 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16456, i64 %38, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 %dec13, i32* %i, align 4, !dbg !76
  br label %for.cond4, !dbg !77, !llvm.loop !78

for.end14:                                        ; preds = %for.cond4
  call void @__dp_loop_exit(i32 16461, i32 1)
  %39 = ptrtoint i32* %numNodes2 to i64
  call void @__dp_read(i32 16461, i64 %39, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.6, i32 0, i32 0))
  %40 = load i32, i32* %numNodes2, align 4, !dbg !80
  call void @__dp_call(i32 16461), !dbg !81
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i64 0, i64 0), i32 %40), !dbg !81
  call void @__dp_finalize(i32 16462), !dbg !82
  ret i32 0, !dbg !82
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_loop_entry(i32, i32)

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
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/011")
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
!20 = !DILocalVariable(name: "len", scope: !7, file: !1, line: 57, type: !10)
!21 = !DILocation(line: 57, column: 7, scope: !7)
!22 = !DILocalVariable(name: "numNodes", scope: !7, file: !1, line: 59, type: !10)
!23 = !DILocation(line: 59, column: 7, scope: !7)
!24 = !DILocation(line: 59, column: 16, scope: !7)
!25 = !DILocalVariable(name: "numNodes2", scope: !7, file: !1, line: 59, type: !10)
!26 = !DILocation(line: 59, column: 21, scope: !7)
!27 = !DILocalVariable(name: "x", scope: !7, file: !1, line: 60, type: !28)
!28 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 3200, elements: !29)
!29 = !{!30}
!30 = !DISubrange(count: 100)
!31 = !DILocation(line: 60, column: 7, scope: !7)
!32 = !DILocation(line: 63, column: 9, scope: !33)
!33 = distinct !DILexicalBlock(scope: !7, file: !1, line: 63, column: 3)
!34 = !DILocation(line: 63, column: 8, scope: !33)
!35 = !DILocation(line: 63, column: 13, scope: !36)
!36 = distinct !DILexicalBlock(scope: !33, file: !1, line: 63, column: 3)
!37 = !DILocation(line: 63, column: 16, scope: !36)
!38 = !DILocation(line: 63, column: 14, scope: !36)
!39 = !DILocation(line: 63, column: 3, scope: !33)
!40 = !DILocation(line: 65, column: 9, scope: !41)
!41 = distinct !DILexicalBlock(scope: !42, file: !1, line: 65, column: 9)
!42 = distinct !DILexicalBlock(scope: !36, file: !1, line: 64, column: 3)
!43 = !DILocation(line: 65, column: 10, scope: !41)
!44 = !DILocation(line: 65, column: 12, scope: !41)
!45 = !DILocation(line: 65, column: 9, scope: !42)
!46 = !DILocation(line: 66, column: 9, scope: !41)
!47 = !DILocation(line: 66, column: 7, scope: !41)
!48 = !DILocation(line: 66, column: 11, scope: !41)
!49 = !DILocation(line: 68, column: 9, scope: !41)
!50 = !DILocation(line: 68, column: 7, scope: !41)
!51 = !DILocation(line: 68, column: 11, scope: !41)
!52 = !DILocation(line: 69, column: 3, scope: !42)
!53 = !DILocation(line: 63, column: 22, scope: !36)
!54 = !DILocation(line: 63, column: 3, scope: !36)
!55 = distinct !{!55, !39, !56}
!56 = !DILocation(line: 69, column: 3, scope: !33)
!57 = !DILocation(line: 72, column: 10, scope: !58)
!58 = distinct !DILexicalBlock(scope: !7, file: !1, line: 72, column: 3)
!59 = !DILocation(line: 72, column: 18, scope: !58)
!60 = !DILocation(line: 72, column: 9, scope: !58)
!61 = !DILocation(line: 72, column: 8, scope: !58)
!62 = !DILocation(line: 72, column: 23, scope: !63)
!63 = distinct !DILexicalBlock(scope: !58, file: !1, line: 72, column: 3)
!64 = !DILocation(line: 72, column: 24, scope: !63)
!65 = !DILocation(line: 72, column: 3, scope: !58)
!66 = !DILocation(line: 73, column: 11, scope: !67)
!67 = distinct !DILexicalBlock(scope: !68, file: !1, line: 73, column: 9)
!68 = distinct !DILexicalBlock(scope: !63, file: !1, line: 72, column: 35)
!69 = !DILocation(line: 73, column: 9, scope: !67)
!70 = !DILocation(line: 73, column: 13, scope: !67)
!71 = !DILocation(line: 73, column: 9, scope: !68)
!72 = !DILocation(line: 74, column: 16, scope: !73)
!73 = distinct !DILexicalBlock(scope: !67, file: !1, line: 73, column: 18)
!74 = !DILocation(line: 75, column: 5, scope: !73)
!75 = !DILocation(line: 76, column: 3, scope: !68)
!76 = !DILocation(line: 72, column: 30, scope: !63)
!77 = !DILocation(line: 72, column: 3, scope: !63)
!78 = distinct !{!78, !65, !79}
!79 = !DILocation(line: 76, column: 3, scope: !58)
!80 = !DILocation(line: 77, column: 31, scope: !7)
!81 = !DILocation(line: 77, column: 3, scope: !7)
!82 = !DILocation(line: 78, column: 3, scope: !7)
