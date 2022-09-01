; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [11 x i8] c"a[500]=%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !7 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %len = alloca i32, align 4
  %a = alloca [1000 x i32], align 16
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !14, metadata !DIExpression()), !dbg !15
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !16, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.declare(metadata i32* %i, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32* %len, metadata !20, metadata !DIExpression()), !dbg !21
  store i32 1000, i32* %len, align 4, !dbg !21
  call void @llvm.dbg.declare(metadata [1000 x i32]* %a, metadata !22, metadata !DIExpression()), !dbg !26
  store i32 0, i32* %i, align 4, !dbg !27
  br label %for.cond, !dbg !29

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !30
  %1 = load i32, i32* %len, align 4, !dbg !32
  %cmp = icmp slt i32 %0, %1, !dbg !33
  br i1 %cmp, label %for.body, label %for.end, !dbg !34

for.body:                                         ; preds = %for.cond
  %2 = load i32, i32* %i, align 4, !dbg !35
  %3 = load i32, i32* %i, align 4, !dbg !36
  %idxprom = sext i32 %3 to i64, !dbg !37
  %arrayidx = getelementptr inbounds [1000 x i32], [1000 x i32]* %a, i64 0, i64 %idxprom, !dbg !37
  store i32 %2, i32* %arrayidx, align 4, !dbg !38
  br label %for.inc, !dbg !37

for.inc:                                          ; preds = %for.body
  %4 = load i32, i32* %i, align 4, !dbg !39
  %inc = add nsw i32 %4, 1, !dbg !39
  store i32 %inc, i32* %i, align 4, !dbg !39
  br label %for.cond, !dbg !40, !llvm.loop !41

for.end:                                          ; preds = %for.cond
  store i32 0, i32* %i, align 4, !dbg !43
  br label %for.cond1, !dbg !45

for.cond1:                                        ; preds = %for.inc9, %for.end
  %5 = load i32, i32* %i, align 4, !dbg !46
  %6 = load i32, i32* %len, align 4, !dbg !48
  %sub = sub nsw i32 %6, 1, !dbg !49
  %cmp2 = icmp slt i32 %5, %sub, !dbg !50
  br i1 %cmp2, label %for.body3, label %for.end11, !dbg !51

for.body3:                                        ; preds = %for.cond1
  %7 = load i32, i32* %i, align 4, !dbg !52
  %add = add nsw i32 %7, 1, !dbg !53
  %idxprom4 = sext i32 %add to i64, !dbg !54
  %arrayidx5 = getelementptr inbounds [1000 x i32], [1000 x i32]* %a, i64 0, i64 %idxprom4, !dbg !54
  %8 = load i32, i32* %arrayidx5, align 4, !dbg !54
  %add6 = add nsw i32 %8, 1, !dbg !55
  %9 = load i32, i32* %i, align 4, !dbg !56
  %idxprom7 = sext i32 %9 to i64, !dbg !57
  %arrayidx8 = getelementptr inbounds [1000 x i32], [1000 x i32]* %a, i64 0, i64 %idxprom7, !dbg !57
  store i32 %add6, i32* %arrayidx8, align 4, !dbg !58
  br label %for.inc9, !dbg !57

for.inc9:                                         ; preds = %for.body3
  %10 = load i32, i32* %i, align 4, !dbg !59
  %inc10 = add nsw i32 %10, 1, !dbg !59
  store i32 %inc10, i32* %i, align 4, !dbg !59
  br label %for.cond1, !dbg !60, !llvm.loop !61

for.end11:                                        ; preds = %for.cond1
  %arrayidx12 = getelementptr inbounds [1000 x i32], [1000 x i32]* %a, i64 0, i64 500, !dbg !63
  %11 = load i32, i32* %arrayidx12, align 16, !dbg !63
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i32 %11), !dbg !64
  ret i32 0, !dbg !65
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
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/001")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"Ubuntu clang version 11.1.0-6"}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 52, type: !8, scopeLine: 53, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10, !10, !11}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!13 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!14 = !DILocalVariable(name: "argc", arg: 1, scope: !7, file: !1, line: 52, type: !10)
!15 = !DILocation(line: 52, column: 14, scope: !7)
!16 = !DILocalVariable(name: "argv", arg: 2, scope: !7, file: !1, line: 52, type: !11)
!17 = !DILocation(line: 52, column: 26, scope: !7)
!18 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 54, type: !10)
!19 = !DILocation(line: 54, column: 7, scope: !7)
!20 = !DILocalVariable(name: "len", scope: !7, file: !1, line: 55, type: !10)
!21 = !DILocation(line: 55, column: 7, scope: !7)
!22 = !DILocalVariable(name: "a", scope: !7, file: !1, line: 57, type: !23)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 32000, elements: !24)
!24 = !{!25}
!25 = !DISubrange(count: 1000)
!26 = !DILocation(line: 57, column: 7, scope: !7)
!27 = !DILocation(line: 59, column: 9, scope: !28)
!28 = distinct !DILexicalBlock(scope: !7, file: !1, line: 59, column: 3)
!29 = !DILocation(line: 59, column: 8, scope: !28)
!30 = !DILocation(line: 59, column: 13, scope: !31)
!31 = distinct !DILexicalBlock(scope: !28, file: !1, line: 59, column: 3)
!32 = !DILocation(line: 59, column: 15, scope: !31)
!33 = !DILocation(line: 59, column: 14, scope: !31)
!34 = !DILocation(line: 59, column: 3, scope: !28)
!35 = !DILocation(line: 60, column: 11, scope: !31)
!36 = !DILocation(line: 60, column: 7, scope: !31)
!37 = !DILocation(line: 60, column: 5, scope: !31)
!38 = !DILocation(line: 60, column: 9, scope: !31)
!39 = !DILocation(line: 59, column: 21, scope: !31)
!40 = !DILocation(line: 59, column: 3, scope: !31)
!41 = distinct !{!41, !34, !42}
!42 = !DILocation(line: 60, column: 11, scope: !28)
!43 = !DILocation(line: 63, column: 9, scope: !44)
!44 = distinct !DILexicalBlock(scope: !7, file: !1, line: 63, column: 3)
!45 = !DILocation(line: 63, column: 8, scope: !44)
!46 = !DILocation(line: 63, column: 12, scope: !47)
!47 = distinct !DILexicalBlock(scope: !44, file: !1, line: 63, column: 3)
!48 = !DILocation(line: 63, column: 15, scope: !47)
!49 = !DILocation(line: 63, column: 19, scope: !47)
!50 = !DILocation(line: 63, column: 13, scope: !47)
!51 = !DILocation(line: 63, column: 3, scope: !44)
!52 = !DILocation(line: 64, column: 12, scope: !47)
!53 = !DILocation(line: 64, column: 13, scope: !47)
!54 = !DILocation(line: 64, column: 10, scope: !47)
!55 = !DILocation(line: 64, column: 16, scope: !47)
!56 = !DILocation(line: 64, column: 7, scope: !47)
!57 = !DILocation(line: 64, column: 5, scope: !47)
!58 = !DILocation(line: 64, column: 9, scope: !47)
!59 = !DILocation(line: 63, column: 24, scope: !47)
!60 = !DILocation(line: 63, column: 3, scope: !47)
!61 = distinct !{!61, !51, !62}
!62 = !DILocation(line: 64, column: 17, scope: !44)
!63 = !DILocation(line: 66, column: 26, scope: !7)
!64 = !DILocation(line: 66, column: 3, scope: !7)
!65 = !DILocation(line: 67, column: 3, scope: !7)
