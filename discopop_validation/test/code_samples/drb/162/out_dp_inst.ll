; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.1 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c"var\00", align 1
@.str = private unnamed_addr constant [5 x i8] c"%d\0A \00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16402, i32 1)
  %retval = alloca i32, align 4
  %var = alloca [8 x i32], align 16
  %i = alloca i32, align 4
  %i1 = alloca i32, align 4
  %i5 = alloca i32, align 4
  %i18 = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16402, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata [8 x i32]* %var, metadata !11, metadata !DIExpression()), !dbg !15
  call void @llvm.dbg.declare(metadata i32* %i, metadata !16, metadata !DIExpression()), !dbg !18
  %1 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16405, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !18
  br label %for.cond, !dbg !19

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16405, i32 0)
  %2 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16405, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %3 = load i32, i32* %i, align 4, !dbg !20
  %cmp = icmp slt i32 %3, 8, !dbg !22
  br i1 %cmp, label %for.body, label %for.end, !dbg !23

for.body:                                         ; preds = %for.cond
  %4 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16406, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %5 = load i32, i32* %i, align 4, !dbg !24
  %idxprom = sext i32 %5 to i64, !dbg !26
  %arrayidx = getelementptr inbounds [8 x i32], [8 x i32]* %var, i64 0, i64 %idxprom, !dbg !26
  %6 = ptrtoint i32* %arrayidx to i64
  call void @__dp_write(i32 16406, i64 %6, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  store i32 0, i32* %arrayidx, align 4, !dbg !27
  br label %for.inc, !dbg !28

for.inc:                                          ; preds = %for.body
  %7 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16405, i64 %7, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %8 = load i32, i32* %i, align 4, !dbg !29
  %inc = add nsw i32 %8, 1, !dbg !29
  %9 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16405, i64 %9, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !29
  br label %for.cond, !dbg !30, !llvm.loop !31

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16412, i32 0)
  call void @llvm.dbg.declare(metadata i32* %i1, metadata !33, metadata !DIExpression()), !dbg !35
  %10 = ptrtoint i32* %i1 to i64
  call void @__dp_write(i32 16412, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %i1, align 4, !dbg !35
  br label %for.cond2, !dbg !36

for.cond2:                                        ; preds = %for.inc15, %for.end
  call void @__dp_loop_entry(i32 16412, i32 1)
  %11 = ptrtoint i32* %i1 to i64
  call void @__dp_read(i32 16412, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %12 = load i32, i32* %i1, align 4, !dbg !37
  %cmp3 = icmp slt i32 %12, 20, !dbg !39
  br i1 %cmp3, label %for.body4, label %for.end17, !dbg !40

for.body4:                                        ; preds = %for.cond2
  call void @llvm.dbg.declare(metadata i32* %i5, metadata !41, metadata !DIExpression()), !dbg !44
  %13 = ptrtoint i32* %i5 to i64
  call void @__dp_write(i32 16414, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %i5, align 4, !dbg !44
  br label %for.cond6, !dbg !45

for.cond6:                                        ; preds = %for.inc12, %for.body4
  call void @__dp_loop_entry(i32 16414, i32 2)
  %14 = ptrtoint i32* %i5 to i64
  call void @__dp_read(i32 16414, i64 %14, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %15 = load i32, i32* %i5, align 4, !dbg !46
  %cmp7 = icmp slt i32 %15, 8, !dbg !48
  br i1 %cmp7, label %for.body8, label %for.end14, !dbg !49

for.body8:                                        ; preds = %for.cond6
  %16 = ptrtoint i32* %i5 to i64
  call void @__dp_read(i32 16415, i64 %16, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %17 = load i32, i32* %i5, align 4, !dbg !50
  %idxprom9 = sext i32 %17 to i64, !dbg !52
  %arrayidx10 = getelementptr inbounds [8 x i32], [8 x i32]* %var, i64 0, i64 %idxprom9, !dbg !52
  %18 = ptrtoint i32* %arrayidx10 to i64
  call void @__dp_read(i32 16415, i64 %18, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  %19 = load i32, i32* %arrayidx10, align 4, !dbg !53
  %inc11 = add nsw i32 %19, 1, !dbg !53
  %20 = ptrtoint i32* %arrayidx10 to i64
  call void @__dp_write(i32 16415, i64 %20, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  store i32 %inc11, i32* %arrayidx10, align 4, !dbg !53
  br label %for.inc12, !dbg !54

for.inc12:                                        ; preds = %for.body8
  %21 = ptrtoint i32* %i5 to i64
  call void @__dp_read(i32 16414, i64 %21, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %22 = load i32, i32* %i5, align 4, !dbg !55
  %inc13 = add nsw i32 %22, 1, !dbg !55
  %23 = ptrtoint i32* %i5 to i64
  call void @__dp_write(i32 16414, i64 %23, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 %inc13, i32* %i5, align 4, !dbg !55
  br label %for.cond6, !dbg !56, !llvm.loop !57

for.end14:                                        ; preds = %for.cond6
  call void @__dp_loop_exit(i32 16417, i32 2)
  br label %for.inc15, !dbg !59

for.inc15:                                        ; preds = %for.end14
  %24 = ptrtoint i32* %i1 to i64
  call void @__dp_read(i32 16412, i64 %24, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %25 = load i32, i32* %i1, align 4, !dbg !60
  %inc16 = add nsw i32 %25, 1, !dbg !60
  %26 = ptrtoint i32* %i1 to i64
  call void @__dp_write(i32 16412, i64 %26, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 %inc16, i32* %i1, align 4, !dbg !60
  br label %for.cond2, !dbg !61, !llvm.loop !62

for.end17:                                        ; preds = %for.cond2
  call void @__dp_loop_exit(i32 16419, i32 1)
  call void @llvm.dbg.declare(metadata i32* %i18, metadata !64, metadata !DIExpression()), !dbg !66
  %27 = ptrtoint i32* %i18 to i64
  call void @__dp_write(i32 16419, i64 %27, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %i18, align 4, !dbg !66
  br label %for.cond19, !dbg !67

for.cond19:                                       ; preds = %for.inc27, %for.end17
  call void @__dp_loop_entry(i32 16419, i32 3)
  %28 = ptrtoint i32* %i18 to i64
  call void @__dp_read(i32 16419, i64 %28, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %29 = load i32, i32* %i18, align 4, !dbg !68
  %cmp20 = icmp slt i32 %29, 8, !dbg !70
  br i1 %cmp20, label %for.body21, label %for.end29, !dbg !71

for.body21:                                       ; preds = %for.cond19
  %30 = ptrtoint i32* %i18 to i64
  call void @__dp_read(i32 16420, i64 %30, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %31 = load i32, i32* %i18, align 4, !dbg !72
  %idxprom22 = sext i32 %31 to i64, !dbg !75
  %arrayidx23 = getelementptr inbounds [8 x i32], [8 x i32]* %var, i64 0, i64 %idxprom22, !dbg !75
  %32 = ptrtoint i32* %arrayidx23 to i64
  call void @__dp_read(i32 16420, i64 %32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  %33 = load i32, i32* %arrayidx23, align 4, !dbg !75
  %cmp24 = icmp ne i32 %33, 20, !dbg !76
  br i1 %cmp24, label %if.then, label %if.end, !dbg !77

if.then:                                          ; preds = %for.body21
  %34 = ptrtoint i32* %i18 to i64
  call void @__dp_read(i32 16420, i64 %34, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %35 = load i32, i32* %i18, align 4, !dbg !78
  %idxprom25 = sext i32 %35 to i64, !dbg !79
  %arrayidx26 = getelementptr inbounds [8 x i32], [8 x i32]* %var, i64 0, i64 %idxprom25, !dbg !79
  %36 = ptrtoint i32* %arrayidx26 to i64
  call void @__dp_read(i32 16420, i64 %36, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  %37 = load i32, i32* %arrayidx26, align 4, !dbg !79
  call void @__dp_call(i32 16420), !dbg !80
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i64 0, i64 0), i32 %37), !dbg !80
  br label %if.end, !dbg !80

if.end:                                           ; preds = %if.then, %for.body21
  br label %for.inc27, !dbg !81

for.inc27:                                        ; preds = %if.end
  %38 = ptrtoint i32* %i18 to i64
  call void @__dp_read(i32 16419, i64 %38, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %39 = load i32, i32* %i18, align 4, !dbg !82
  %inc28 = add nsw i32 %39, 1, !dbg !82
  %40 = ptrtoint i32* %i18 to i64
  call void @__dp_write(i32 16419, i64 %40, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 %inc28, i32* %i18, align 4, !dbg !82
  br label %for.cond19, !dbg !83, !llvm.loop !84

for.end29:                                        ; preds = %for.cond19
  call void @__dp_loop_exit(i32 16423, i32 3)
  call void @__dp_finalize(i32 16423), !dbg !86
  ret i32 0, !dbg !86
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
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/162")
!2 = !{}
!3 = !{!"Ubuntu clang version 11.1.0-6"}
!4 = !{i32 7, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 18, type: !8, scopeLine: 18, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "var", scope: !7, file: !1, line: 19, type: !12)
!12 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 256, elements: !13)
!13 = !{!14}
!14 = !DISubrange(count: 8)
!15 = !DILocation(line: 19, column: 7, scope: !7)
!16 = !DILocalVariable(name: "i", scope: !17, file: !1, line: 21, type: !10)
!17 = distinct !DILexicalBlock(scope: !7, file: !1, line: 21, column: 3)
!18 = !DILocation(line: 21, column: 11, scope: !17)
!19 = !DILocation(line: 21, column: 7, scope: !17)
!20 = !DILocation(line: 21, column: 16, scope: !21)
!21 = distinct !DILexicalBlock(scope: !17, file: !1, line: 21, column: 3)
!22 = !DILocation(line: 21, column: 17, scope: !21)
!23 = !DILocation(line: 21, column: 3, scope: !17)
!24 = !DILocation(line: 22, column: 9, scope: !25)
!25 = distinct !DILexicalBlock(scope: !21, file: !1, line: 21, column: 25)
!26 = !DILocation(line: 22, column: 5, scope: !25)
!27 = !DILocation(line: 22, column: 12, scope: !25)
!28 = !DILocation(line: 23, column: 3, scope: !25)
!29 = !DILocation(line: 21, column: 22, scope: !21)
!30 = !DILocation(line: 21, column: 3, scope: !21)
!31 = distinct !{!31, !23, !32}
!32 = !DILocation(line: 23, column: 3, scope: !17)
!33 = !DILocalVariable(name: "i", scope: !34, file: !1, line: 28, type: !10)
!34 = distinct !DILexicalBlock(scope: !7, file: !1, line: 28, column: 3)
!35 = !DILocation(line: 28, column: 12, scope: !34)
!36 = !DILocation(line: 28, column: 8, scope: !34)
!37 = !DILocation(line: 28, column: 17, scope: !38)
!38 = distinct !DILexicalBlock(scope: !34, file: !1, line: 28, column: 3)
!39 = !DILocation(line: 28, column: 18, scope: !38)
!40 = !DILocation(line: 28, column: 3, scope: !34)
!41 = !DILocalVariable(name: "i", scope: !42, file: !1, line: 30, type: !10)
!42 = distinct !DILexicalBlock(scope: !43, file: !1, line: 30, column: 5)
!43 = distinct !DILexicalBlock(scope: !38, file: !1, line: 28, column: 26)
!44 = !DILocation(line: 30, column: 13, scope: !42)
!45 = !DILocation(line: 30, column: 9, scope: !42)
!46 = !DILocation(line: 30, column: 18, scope: !47)
!47 = distinct !DILexicalBlock(scope: !42, file: !1, line: 30, column: 5)
!48 = !DILocation(line: 30, column: 19, scope: !47)
!49 = !DILocation(line: 30, column: 5, scope: !42)
!50 = !DILocation(line: 31, column: 11, scope: !51)
!51 = distinct !DILexicalBlock(scope: !47, file: !1, line: 30, column: 27)
!52 = !DILocation(line: 31, column: 7, scope: !51)
!53 = !DILocation(line: 31, column: 13, scope: !51)
!54 = !DILocation(line: 32, column: 5, scope: !51)
!55 = !DILocation(line: 30, column: 24, scope: !47)
!56 = !DILocation(line: 30, column: 5, scope: !47)
!57 = distinct !{!57, !49, !58}
!58 = !DILocation(line: 32, column: 5, scope: !42)
!59 = !DILocation(line: 33, column: 3, scope: !43)
!60 = !DILocation(line: 28, column: 23, scope: !38)
!61 = !DILocation(line: 28, column: 3, scope: !38)
!62 = distinct !{!62, !40, !63}
!63 = !DILocation(line: 33, column: 3, scope: !34)
!64 = !DILocalVariable(name: "i", scope: !65, file: !1, line: 35, type: !10)
!65 = distinct !DILexicalBlock(scope: !7, file: !1, line: 35, column: 3)
!66 = !DILocation(line: 35, column: 11, scope: !65)
!67 = !DILocation(line: 35, column: 7, scope: !65)
!68 = !DILocation(line: 35, column: 16, scope: !69)
!69 = distinct !DILexicalBlock(scope: !65, file: !1, line: 35, column: 3)
!70 = !DILocation(line: 35, column: 17, scope: !69)
!71 = !DILocation(line: 35, column: 3, scope: !65)
!72 = !DILocation(line: 36, column: 12, scope: !73)
!73 = distinct !DILexicalBlock(scope: !74, file: !1, line: 36, column: 8)
!74 = distinct !DILexicalBlock(scope: !69, file: !1, line: 35, column: 25)
!75 = !DILocation(line: 36, column: 8, scope: !73)
!76 = !DILocation(line: 36, column: 14, scope: !73)
!77 = !DILocation(line: 36, column: 8, scope: !74)
!78 = !DILocation(line: 36, column: 38, scope: !73)
!79 = !DILocation(line: 36, column: 34, scope: !73)
!80 = !DILocation(line: 36, column: 19, scope: !73)
!81 = !DILocation(line: 37, column: 3, scope: !74)
!82 = !DILocation(line: 35, column: 22, scope: !69)
!83 = !DILocation(line: 35, column: 3, scope: !69)
!84 = distinct !{!84, !71, !85}
!85 = !DILocation(line: 37, column: 3, scope: !65)
!86 = !DILocation(line: 39, column: 3, scope: !7)
