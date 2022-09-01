; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.1 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"argc\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"argv\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"len\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.7 = private unnamed_addr constant [4 x i8] c"tmp\00", align 1
@.str = private unnamed_addr constant [10 x i8] c"a[50]=%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16437, i32 1)
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %tmp = alloca i32, align 4
  %len = alloca i32, align 4
  %a = alloca [100 x i32], align 16
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16437, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  %1 = ptrtoint i32* %argc.addr to i64
  call void @__dp_write(i32 16437, i64 %1, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i32 0, i32 0))
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !14, metadata !DIExpression()), !dbg !15
  %2 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_write(i32 16437, i64 %2, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0))
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !16, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.declare(metadata i32* %i, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32* %tmp, metadata !20, metadata !DIExpression()), !dbg !21
  call void @llvm.dbg.declare(metadata i32* %len, metadata !22, metadata !DIExpression()), !dbg !23
  %3 = ptrtoint i32* %len to i64
  call void @__dp_write(i32 16441, i64 %3, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  store i32 100, i32* %len, align 4, !dbg !23
  call void @llvm.dbg.declare(metadata [100 x i32]* %a, metadata !24, metadata !DIExpression()), !dbg !28
  %4 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16443, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !29
  br label %for.cond, !dbg !31

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16443, i32 0)
  %5 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16443, i64 %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %6 = load i32, i32* %i, align 4, !dbg !32
  %7 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16443, i64 %7, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  %8 = load i32, i32* %len, align 4, !dbg !34
  %cmp = icmp slt i32 %6, %8, !dbg !35
  br i1 %cmp, label %for.body, label %for.end, !dbg !36

for.body:                                         ; preds = %for.cond
  %9 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16444, i64 %9, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %10 = load i32, i32* %i, align 4, !dbg !37
  %11 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16444, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %12 = load i32, i32* %i, align 4, !dbg !38
  %idxprom = sext i32 %12 to i64, !dbg !39
  %arrayidx = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom, !dbg !39
  %13 = ptrtoint i32* %arrayidx to i64
  call void @__dp_write(i32 16444, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 %10, i32* %arrayidx, align 4, !dbg !40
  br label %for.inc, !dbg !39

for.inc:                                          ; preds = %for.body
  %14 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16443, i64 %14, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %15 = load i32, i32* %i, align 4, !dbg !41
  %inc = add nsw i32 %15, 1, !dbg !41
  %16 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16443, i64 %16, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !41
  br label %for.cond, !dbg !42, !llvm.loop !43

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16447, i32 0)
  %17 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16447, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !45
  br label %for.cond1, !dbg !47

for.cond1:                                        ; preds = %for.inc8, %for.end
  call void @__dp_loop_entry(i32 16447, i32 1)
  %18 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16447, i64 %18, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %19 = load i32, i32* %i, align 4, !dbg !48
  %20 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16447, i64 %20, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  %21 = load i32, i32* %len, align 4, !dbg !50
  %cmp2 = icmp slt i32 %19, %21, !dbg !51
  br i1 %cmp2, label %for.body3, label %for.end10, !dbg !52

for.body3:                                        ; preds = %for.cond1
  %22 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16449, i64 %22, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %23 = load i32, i32* %i, align 4, !dbg !53
  %idxprom4 = sext i32 %23 to i64, !dbg !55
  %arrayidx5 = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom4, !dbg !55
  %24 = ptrtoint i32* %arrayidx5 to i64
  call void @__dp_read(i32 16449, i64 %24, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %25 = load i32, i32* %arrayidx5, align 4, !dbg !55
  %26 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16449, i64 %26, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %27 = load i32, i32* %i, align 4, !dbg !56
  %add = add nsw i32 %25, %27, !dbg !57
  %28 = ptrtoint i32* %tmp to i64
  call void @__dp_write(i32 16449, i64 %28, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  store i32 %add, i32* %tmp, align 4, !dbg !58
  %29 = ptrtoint i32* %tmp to i64
  call void @__dp_read(i32 16450, i64 %29, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  %30 = load i32, i32* %tmp, align 4, !dbg !59
  %31 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16450, i64 %31, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %32 = load i32, i32* %i, align 4, !dbg !60
  %idxprom6 = sext i32 %32 to i64, !dbg !61
  %arrayidx7 = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom6, !dbg !61
  %33 = ptrtoint i32* %arrayidx7 to i64
  call void @__dp_write(i32 16450, i64 %33, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 %30, i32* %arrayidx7, align 4, !dbg !62
  br label %for.inc8, !dbg !63

for.inc8:                                         ; preds = %for.body3
  %34 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16447, i64 %34, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %35 = load i32, i32* %i, align 4, !dbg !64
  %inc9 = add nsw i32 %35, 1, !dbg !64
  %36 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16447, i64 %36, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 %inc9, i32* %i, align 4, !dbg !64
  br label %for.cond1, !dbg !65, !llvm.loop !66

for.end10:                                        ; preds = %for.cond1
  call void @__dp_loop_exit(i32 16453, i32 1)
  %arrayidx11 = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 50, !dbg !68
  %37 = ptrtoint i32* %arrayidx11 to i64
  call void @__dp_read(i32 16453, i64 %37, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %38 = load i32, i32* %arrayidx11, align 8, !dbg !68
  call void @__dp_call(i32 16453), !dbg !69
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 %38), !dbg !69
  call void @__dp_finalize(i32 16454), !dbg !70
  ret i32 0, !dbg !70
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
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/028")
!2 = !{}
!3 = !{!"Ubuntu clang version 11.1.0-6"}
!4 = !{i32 7, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 53, type: !8, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10, !10, !11}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!13 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!14 = !DILocalVariable(name: "argc", arg: 1, scope: !7, file: !1, line: 53, type: !10)
!15 = !DILocation(line: 53, column: 14, scope: !7)
!16 = !DILocalVariable(name: "argv", arg: 2, scope: !7, file: !1, line: 53, type: !11)
!17 = !DILocation(line: 53, column: 26, scope: !7)
!18 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 55, type: !10)
!19 = !DILocation(line: 55, column: 7, scope: !7)
!20 = !DILocalVariable(name: "tmp", scope: !7, file: !1, line: 56, type: !10)
!21 = !DILocation(line: 56, column: 7, scope: !7)
!22 = !DILocalVariable(name: "len", scope: !7, file: !1, line: 57, type: !10)
!23 = !DILocation(line: 57, column: 7, scope: !7)
!24 = !DILocalVariable(name: "a", scope: !7, file: !1, line: 58, type: !25)
!25 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 3200, elements: !26)
!26 = !{!27}
!27 = !DISubrange(count: 100)
!28 = !DILocation(line: 58, column: 7, scope: !7)
!29 = !DILocation(line: 59, column: 9, scope: !30)
!30 = distinct !DILexicalBlock(scope: !7, file: !1, line: 59, column: 3)
!31 = !DILocation(line: 59, column: 8, scope: !30)
!32 = !DILocation(line: 59, column: 12, scope: !33)
!33 = distinct !DILexicalBlock(scope: !30, file: !1, line: 59, column: 3)
!34 = !DILocation(line: 59, column: 14, scope: !33)
!35 = !DILocation(line: 59, column: 13, scope: !33)
!36 = !DILocation(line: 59, column: 3, scope: !30)
!37 = !DILocation(line: 60, column: 10, scope: !33)
!38 = !DILocation(line: 60, column: 7, scope: !33)
!39 = !DILocation(line: 60, column: 5, scope: !33)
!40 = !DILocation(line: 60, column: 9, scope: !33)
!41 = !DILocation(line: 59, column: 19, scope: !33)
!42 = !DILocation(line: 59, column: 3, scope: !33)
!43 = distinct !{!43, !36, !44}
!44 = !DILocation(line: 60, column: 10, scope: !30)
!45 = !DILocation(line: 63, column: 9, scope: !46)
!46 = distinct !DILexicalBlock(scope: !7, file: !1, line: 63, column: 3)
!47 = !DILocation(line: 63, column: 8, scope: !46)
!48 = !DILocation(line: 63, column: 12, scope: !49)
!49 = distinct !DILexicalBlock(scope: !46, file: !1, line: 63, column: 3)
!50 = !DILocation(line: 63, column: 14, scope: !49)
!51 = !DILocation(line: 63, column: 13, scope: !49)
!52 = !DILocation(line: 63, column: 3, scope: !46)
!53 = !DILocation(line: 65, column: 12, scope: !54)
!54 = distinct !DILexicalBlock(scope: !49, file: !1, line: 64, column: 3)
!55 = !DILocation(line: 65, column: 10, scope: !54)
!56 = !DILocation(line: 65, column: 15, scope: !54)
!57 = !DILocation(line: 65, column: 14, scope: !54)
!58 = !DILocation(line: 65, column: 9, scope: !54)
!59 = !DILocation(line: 66, column: 12, scope: !54)
!60 = !DILocation(line: 66, column: 7, scope: !54)
!61 = !DILocation(line: 66, column: 5, scope: !54)
!62 = !DILocation(line: 66, column: 10, scope: !54)
!63 = !DILocation(line: 67, column: 3, scope: !54)
!64 = !DILocation(line: 63, column: 19, scope: !49)
!65 = !DILocation(line: 63, column: 3, scope: !49)
!66 = distinct !{!66, !52, !67}
!67 = !DILocation(line: 67, column: 3, scope: !46)
!68 = !DILocation(line: 69, column: 24, scope: !7)
!69 = !DILocation(line: 69, column: 3, scope: !7)
!70 = !DILocation(line: 70, column: 3, scope: !7)
