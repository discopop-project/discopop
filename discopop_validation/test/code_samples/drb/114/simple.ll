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
  %len = alloca i32, align 4
  %a = alloca [100 x i32], align 16
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !14, metadata !DIExpression()), !dbg !15
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !16, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.declare(metadata i32* %i, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32* %len, metadata !20, metadata !DIExpression()), !dbg !21
  store i32 100, i32* %len, align 4, !dbg !21
  call void @llvm.dbg.declare(metadata [100 x i32]* %a, metadata !22, metadata !DIExpression()), !dbg !26
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
  %arrayidx = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom, !dbg !37
  store i32 %2, i32* %arrayidx, align 4, !dbg !38
  br label %for.inc, !dbg !37

for.inc:                                          ; preds = %for.body
  %4 = load i32, i32* %i, align 4, !dbg !39
  %inc = add nsw i32 %4, 1, !dbg !39
  store i32 %inc, i32* %i, align 4, !dbg !39
  br label %for.cond, !dbg !40, !llvm.loop !41

for.end:                                          ; preds = %for.cond
  %call = call i64 @time(i64* null) #4, !dbg !43
  %conv = trunc i64 %call to i32, !dbg !43
  call void @srand(i32 %conv) #4, !dbg !44
  store i32 0, i32* %i, align 4, !dbg !45
  br label %for.cond1, !dbg !47

for.cond1:                                        ; preds = %for.inc10, %for.end
  %5 = load i32, i32* %i, align 4, !dbg !48
  %6 = load i32, i32* %len, align 4, !dbg !50
  %sub = sub nsw i32 %6, 1, !dbg !51
  %cmp2 = icmp slt i32 %5, %sub, !dbg !52
  br i1 %cmp2, label %for.body4, label %for.end12, !dbg !53

for.body4:                                        ; preds = %for.cond1
  %7 = load i32, i32* %i, align 4, !dbg !54
  %idxprom5 = sext i32 %7 to i64, !dbg !55
  %arrayidx6 = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom5, !dbg !55
  %8 = load i32, i32* %arrayidx6, align 4, !dbg !55
  %add = add nsw i32 %8, 1, !dbg !56
  %9 = load i32, i32* %i, align 4, !dbg !57
  %add7 = add nsw i32 %9, 1, !dbg !58
  %idxprom8 = sext i32 %add7 to i64, !dbg !59
  %arrayidx9 = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom8, !dbg !59
  store i32 %add, i32* %arrayidx9, align 4, !dbg !60
  br label %for.inc10, !dbg !59

for.inc10:                                        ; preds = %for.body4
  %10 = load i32, i32* %i, align 4, !dbg !61
  %inc11 = add nsw i32 %10, 1, !dbg !61
  store i32 %inc11, i32* %i, align 4, !dbg !61
  br label %for.cond1, !dbg !62, !llvm.loop !63

for.end12:                                        ; preds = %for.cond1
  %arrayidx13 = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 50, !dbg !65
  %11 = load i32, i32* %arrayidx13, align 8, !dbg !65
  %call14 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 %11), !dbg !66
  ret i32 0, !dbg !67
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare dso_local void @srand(i32) #2

; Function Attrs: nounwind
declare dso_local i64 @time(i64*) #2

declare dso_local i32 @printf(i8*, ...) #3

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/114")
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
!20 = !DILocalVariable(name: "len", scope: !7, file: !1, line: 57, type: !10)
!21 = !DILocation(line: 57, column: 7, scope: !7)
!22 = !DILocalVariable(name: "a", scope: !7, file: !1, line: 58, type: !23)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 3200, elements: !24)
!24 = !{!25}
!25 = !DISubrange(count: 100)
!26 = !DILocation(line: 58, column: 7, scope: !7)
!27 = !DILocation(line: 60, column: 9, scope: !28)
!28 = distinct !DILexicalBlock(scope: !7, file: !1, line: 60, column: 3)
!29 = !DILocation(line: 60, column: 8, scope: !28)
!30 = !DILocation(line: 60, column: 12, scope: !31)
!31 = distinct !DILexicalBlock(scope: !28, file: !1, line: 60, column: 3)
!32 = !DILocation(line: 60, column: 14, scope: !31)
!33 = !DILocation(line: 60, column: 13, scope: !31)
!34 = !DILocation(line: 60, column: 3, scope: !28)
!35 = !DILocation(line: 61, column: 10, scope: !31)
!36 = !DILocation(line: 61, column: 7, scope: !31)
!37 = !DILocation(line: 61, column: 5, scope: !31)
!38 = !DILocation(line: 61, column: 9, scope: !31)
!39 = !DILocation(line: 60, column: 19, scope: !31)
!40 = !DILocation(line: 60, column: 3, scope: !31)
!41 = distinct !{!41, !34, !42}
!42 = !DILocation(line: 61, column: 10, scope: !28)
!43 = !DILocation(line: 63, column: 9, scope: !7)
!44 = !DILocation(line: 63, column: 3, scope: !7)
!45 = !DILocation(line: 65, column: 9, scope: !46)
!46 = distinct !DILexicalBlock(scope: !7, file: !1, line: 65, column: 3)
!47 = !DILocation(line: 65, column: 8, scope: !46)
!48 = !DILocation(line: 65, column: 12, scope: !49)
!49 = distinct !DILexicalBlock(scope: !46, file: !1, line: 65, column: 3)
!50 = !DILocation(line: 65, column: 14, scope: !49)
!51 = !DILocation(line: 65, column: 17, scope: !49)
!52 = !DILocation(line: 65, column: 13, scope: !49)
!53 = !DILocation(line: 65, column: 3, scope: !46)
!54 = !DILocation(line: 66, column: 14, scope: !49)
!55 = !DILocation(line: 66, column: 12, scope: !49)
!56 = !DILocation(line: 66, column: 16, scope: !49)
!57 = !DILocation(line: 66, column: 7, scope: !49)
!58 = !DILocation(line: 66, column: 8, scope: !49)
!59 = !DILocation(line: 66, column: 5, scope: !49)
!60 = !DILocation(line: 66, column: 11, scope: !49)
!61 = !DILocation(line: 65, column: 21, scope: !49)
!62 = !DILocation(line: 65, column: 3, scope: !49)
!63 = distinct !{!63, !53, !64}
!64 = !DILocation(line: 66, column: 17, scope: !46)
!65 = !DILocation(line: 68, column: 24, scope: !7)
!66 = !DILocation(line: 68, column: 3, scope: !7)
!67 = !DILocation(line: 69, column: 3, scope: !7)
