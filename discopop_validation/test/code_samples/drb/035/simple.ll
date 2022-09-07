; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [10 x i8] c"a[50]=%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !7 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %tmp = alloca i32, align 4
  %len = alloca i32, align 4
  %a = alloca [100 x i32], align 16
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !14, metadata !DIExpression()), !dbg !15
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !16, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.declare(metadata i32* %i, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32* %tmp, metadata !20, metadata !DIExpression()), !dbg !21
  store i32 10, i32* %tmp, align 4, !dbg !22
  call void @llvm.dbg.declare(metadata i32* %len, metadata !23, metadata !DIExpression()), !dbg !24
  store i32 100, i32* %len, align 4, !dbg !24
  call void @llvm.dbg.declare(metadata [100 x i32]* %a, metadata !25, metadata !DIExpression()), !dbg !29
  store i32 0, i32* %i, align 4, !dbg !30
  br label %for.cond, !dbg !32

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !33
  %1 = load i32, i32* %len, align 4, !dbg !35
  %cmp = icmp slt i32 %0, %1, !dbg !36
  br i1 %cmp, label %for.body, label %for.end, !dbg !37

for.body:                                         ; preds = %for.cond
  %2 = load i32, i32* %tmp, align 4, !dbg !38
  %3 = load i32, i32* %i, align 4, !dbg !40
  %idxprom = sext i32 %3 to i64, !dbg !41
  %arrayidx = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom, !dbg !41
  store i32 %2, i32* %arrayidx, align 4, !dbg !42
  %4 = load i32, i32* %i, align 4, !dbg !43
  %idxprom1 = sext i32 %4 to i64, !dbg !44
  %arrayidx2 = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom1, !dbg !44
  %5 = load i32, i32* %arrayidx2, align 4, !dbg !44
  %6 = load i32, i32* %i, align 4, !dbg !45
  %add = add nsw i32 %5, %6, !dbg !46
  store i32 %add, i32* %tmp, align 4, !dbg !47
  br label %for.inc, !dbg !48

for.inc:                                          ; preds = %for.body
  %7 = load i32, i32* %i, align 4, !dbg !49
  %inc = add nsw i32 %7, 1, !dbg !49
  store i32 %inc, i32* %i, align 4, !dbg !49
  br label %for.cond, !dbg !50, !llvm.loop !51

for.end:                                          ; preds = %for.cond
  %arrayidx3 = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 50, !dbg !53
  %8 = load i32, i32* %arrayidx3, align 8, !dbg !53
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 %8), !dbg !54
  ret i32 0, !dbg !55
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @printf(i8*, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/035")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"Ubuntu clang version 11.1.0-6"}
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
