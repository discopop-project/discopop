; ModuleID = 'example.cpp'
source_filename = "example.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [10 x i8] c"Sum: %ld\0A\00", align 1

; Function Attrs: noinline norecurse optnone uwtable
define dso_local i32 @main() #0 !dbg !7 {
entry:
  %retval = alloca i32, align 4
  %N = alloca i32, align 4
  %sum = alloca i64, align 8
  %saved_stack = alloca i8*, align 8
  %__vla_expr0 = alloca i64, align 8
  %i = alloca i32, align 4
  %i1 = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %N, metadata !11, metadata !DIExpression()), !dbg !12
  store i32 100000, i32* %N, align 4, !dbg !12
  call void @llvm.dbg.declare(metadata i64* %sum, metadata !13, metadata !DIExpression()), !dbg !15
  %0 = load i32, i32* %N, align 4, !dbg !16
  %1 = zext i32 %0 to i64, !dbg !17
  %2 = call i8* @llvm.stacksave(), !dbg !17
  store i8* %2, i8** %saved_stack, align 8, !dbg !17
  %vla = alloca i32, i64 %1, align 16, !dbg !17
  store i64 %1, i64* %__vla_expr0, align 8, !dbg !17
  call void @llvm.dbg.declare(metadata i64* %__vla_expr0, metadata !18, metadata !DIExpression()), !dbg !20
  call void @llvm.dbg.declare(metadata i32* %vla, metadata !21, metadata !DIExpression()), !dbg !25
  call void @llvm.dbg.declare(metadata i32* %i, metadata !26, metadata !DIExpression()), !dbg !28
  store i32 0, i32* %i, align 4, !dbg !28
  br label %for.cond, !dbg !29

for.cond:                                         ; preds = %for.inc, %entry
  %3 = load i32, i32* %i, align 4, !dbg !30
  %4 = load i32, i32* %N, align 4, !dbg !32
  %cmp = icmp slt i32 %3, %4, !dbg !33
  br i1 %cmp, label %for.body, label %for.end, !dbg !34

for.body:                                         ; preds = %for.cond
  %5 = load i32, i32* %i, align 4, !dbg !35
  %rem = srem i32 %5, 13, !dbg !37
  %6 = load i32, i32* %i, align 4, !dbg !38
  %idxprom = sext i32 %6 to i64, !dbg !39
  %arrayidx = getelementptr inbounds i32, i32* %vla, i64 %idxprom, !dbg !39
  store i32 %rem, i32* %arrayidx, align 4, !dbg !40
  br label %for.inc, !dbg !41

for.inc:                                          ; preds = %for.body
  %7 = load i32, i32* %i, align 4, !dbg !42
  %inc = add nsw i32 %7, 1, !dbg !42
  store i32 %inc, i32* %i, align 4, !dbg !42
  br label %for.cond, !dbg !43, !llvm.loop !44

for.end:                                          ; preds = %for.cond
  call void @llvm.dbg.declare(metadata i32* %i1, metadata !46, metadata !DIExpression()), !dbg !48
  store i32 0, i32* %i1, align 4, !dbg !48
  br label %for.cond2, !dbg !49

for.cond2:                                        ; preds = %for.inc7, %for.end
  %8 = load i32, i32* %i1, align 4, !dbg !50
  %9 = load i32, i32* %N, align 4, !dbg !52
  %cmp3 = icmp slt i32 %8, %9, !dbg !53
  br i1 %cmp3, label %for.body4, label %for.end9, !dbg !54

for.body4:                                        ; preds = %for.cond2
  %10 = load i64, i64* %sum, align 8, !dbg !55
  %11 = load i32, i32* %i1, align 4, !dbg !57
  %idxprom5 = sext i32 %11 to i64, !dbg !58
  %arrayidx6 = getelementptr inbounds i32, i32* %vla, i64 %idxprom5, !dbg !58
  %12 = load i32, i32* %arrayidx6, align 4, !dbg !58
  %conv = sext i32 %12 to i64, !dbg !58
  %add = add nsw i64 %10, %conv, !dbg !59
  store i64 %add, i64* %sum, align 8, !dbg !60
  br label %for.inc7, !dbg !61

for.inc7:                                         ; preds = %for.body4
  %13 = load i32, i32* %i1, align 4, !dbg !62
  %inc8 = add nsw i32 %13, 1, !dbg !62
  store i32 %inc8, i32* %i1, align 4, !dbg !62
  br label %for.cond2, !dbg !63, !llvm.loop !64

for.end9:                                         ; preds = %for.cond2
  %14 = load i64, i64* %sum, align 8, !dbg !66
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i64 %14), !dbg !67
  %15 = load i8*, i8** %saved_stack, align 8, !dbg !68
  call void @llvm.stackrestore(i8* %15), !dbg !68
  %16 = load i32, i32* %retval, align 4, !dbg !68
  ret i32 %16, !dbg !68
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare i8* @llvm.stacksave() #2

declare dso_local i32 @printf(i8*, ...) #3

; Function Attrs: nounwind
declare void @llvm.stackrestore(i8*) #2

attributes #0 = { noinline norecurse optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "example.cpp", directory: "/home/lukas/git/discopop/example")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"Ubuntu clang version 11.1.0-6"}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 3, type: !8, scopeLine: 3, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "N", scope: !7, file: !1, line: 4, type: !10)
!12 = !DILocation(line: 4, column: 9, scope: !7)
!13 = !DILocalVariable(name: "sum", scope: !7, file: !1, line: 5, type: !14)
!14 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!15 = !DILocation(line: 5, column: 10, scope: !7)
!16 = !DILocation(line: 6, column: 13, scope: !7)
!17 = !DILocation(line: 6, column: 5, scope: !7)
!18 = !DILocalVariable(name: "__vla_expr0", scope: !7, type: !19, flags: DIFlagArtificial)
!19 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!20 = !DILocation(line: 0, scope: !7)
!21 = !DILocalVariable(name: "Arr", scope: !7, file: !1, line: 6, type: !22)
!22 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, elements: !23)
!23 = !{!24}
!24 = !DISubrange(count: !18)
!25 = !DILocation(line: 6, column: 9, scope: !7)
!26 = !DILocalVariable(name: "i", scope: !27, file: !1, line: 8, type: !10)
!27 = distinct !DILexicalBlock(scope: !7, file: !1, line: 8, column: 5)
!28 = !DILocation(line: 8, column: 13, scope: !27)
!29 = !DILocation(line: 8, column: 9, scope: !27)
!30 = !DILocation(line: 8, column: 20, scope: !31)
!31 = distinct !DILexicalBlock(scope: !27, file: !1, line: 8, column: 5)
!32 = !DILocation(line: 8, column: 24, scope: !31)
!33 = !DILocation(line: 8, column: 22, scope: !31)
!34 = !DILocation(line: 8, column: 5, scope: !27)
!35 = !DILocation(line: 9, column: 18, scope: !36)
!36 = distinct !DILexicalBlock(scope: !31, file: !1, line: 8, column: 31)
!37 = !DILocation(line: 9, column: 20, scope: !36)
!38 = !DILocation(line: 9, column: 13, scope: !36)
!39 = !DILocation(line: 9, column: 9, scope: !36)
!40 = !DILocation(line: 9, column: 16, scope: !36)
!41 = !DILocation(line: 10, column: 5, scope: !36)
!42 = !DILocation(line: 8, column: 28, scope: !31)
!43 = !DILocation(line: 8, column: 5, scope: !31)
!44 = distinct !{!44, !34, !45}
!45 = !DILocation(line: 10, column: 5, scope: !27)
!46 = !DILocalVariable(name: "i", scope: !47, file: !1, line: 12, type: !10)
!47 = distinct !DILexicalBlock(scope: !7, file: !1, line: 12, column: 5)
!48 = !DILocation(line: 12, column: 13, scope: !47)
!49 = !DILocation(line: 12, column: 9, scope: !47)
!50 = !DILocation(line: 12, column: 20, scope: !51)
!51 = distinct !DILexicalBlock(scope: !47, file: !1, line: 12, column: 5)
!52 = !DILocation(line: 12, column: 24, scope: !51)
!53 = !DILocation(line: 12, column: 22, scope: !51)
!54 = !DILocation(line: 12, column: 5, scope: !47)
!55 = !DILocation(line: 13, column: 15, scope: !56)
!56 = distinct !DILexicalBlock(scope: !51, file: !1, line: 12, column: 31)
!57 = !DILocation(line: 13, column: 25, scope: !56)
!58 = !DILocation(line: 13, column: 21, scope: !56)
!59 = !DILocation(line: 13, column: 19, scope: !56)
!60 = !DILocation(line: 13, column: 13, scope: !56)
!61 = !DILocation(line: 14, column: 5, scope: !56)
!62 = !DILocation(line: 12, column: 28, scope: !51)
!63 = !DILocation(line: 12, column: 5, scope: !51)
!64 = distinct !{!64, !54, !65}
!65 = !DILocation(line: 14, column: 5, scope: !47)
!66 = !DILocation(line: 16, column: 26, scope: !7)
!67 = !DILocation(line: 16, column: 5, scope: !7)
!68 = !DILocation(line: 17, column: 1, scope: !7)
