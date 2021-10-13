; ModuleID = 'simple_doall.c'
source_filename = "simple_doall.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !7 {
entry:
  %retval = alloca i32, align 4
  %arr = alloca [10 x i32], align 16
  %i = alloca i32, align 4
  %x = alloca i32, align 4
  %i3 = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata [10 x i32]* %arr, metadata !11, metadata !DIExpression()), !dbg !15
  call void @llvm.dbg.declare(metadata i32* %i, metadata !16, metadata !DIExpression()), !dbg !18
  store i32 0, i32* %i, align 4, !dbg !18
  br label %for.cond, !dbg !19

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !20
  %cmp = icmp slt i32 %0, 10, !dbg !22
  br i1 %cmp, label %for.body, label %for.end, !dbg !23

for.body:                                         ; preds = %for.cond
  call void @incr_loop_counter(i32 2)
  %1 = load i32, i32* %i, align 4, !dbg !24
  %2 = load i32, i32* %i, align 4, !dbg !26
  %idxprom = sext i32 %2 to i64, !dbg !27
  %arrayidx = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idxprom, !dbg !27
  store i32 %1, i32* %arrayidx, align 4, !dbg !28
  %3 = load i32, i32* %i, align 4, !dbg !29
  %idxprom1 = sext i32 %3 to i64, !dbg !30
  %arrayidx2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idxprom1, !dbg !30
  %4 = load i32, i32* %arrayidx2, align 4, !dbg !31
  %add = add nsw i32 %4, 3, !dbg !31
  store i32 %add, i32* %arrayidx2, align 4, !dbg !31
  br label %for.inc, !dbg !32

for.inc:                                          ; preds = %for.body
  %5 = load i32, i32* %i, align 4, !dbg !33
  %inc = add nsw i32 %5, 1, !dbg !33
  store i32 %inc, i32* %i, align 4, !dbg !33
  br label %for.cond, !dbg !34, !llvm.loop !35

for.end:                                          ; preds = %for.cond
  call void @llvm.dbg.declare(metadata i32* %x, metadata !37, metadata !DIExpression()), !dbg !38
  store i32 3, i32* %x, align 4, !dbg !38
  call void @llvm.dbg.declare(metadata i32* %i3, metadata !39, metadata !DIExpression()), !dbg !41
  store i32 0, i32* %i3, align 4, !dbg !41
  br label %for.cond4, !dbg !42

for.cond4:                                        ; preds = %for.inc12, %for.end
  %6 = load i32, i32* %i3, align 4, !dbg !43
  %cmp5 = icmp slt i32 %6, 10, !dbg !45
  br i1 %cmp5, label %for.body6, label %for.end14, !dbg !46

for.body6:                                        ; preds = %for.cond4
  call void @incr_loop_counter(i32 1)
  %7 = load i32, i32* %i3, align 4, !dbg !47
  %8 = load i32, i32* %x, align 4, !dbg !49
  %idxprom7 = sext i32 %8 to i64, !dbg !50
  %arrayidx8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idxprom7, !dbg !50
  store i32 %7, i32* %arrayidx8, align 4, !dbg !51
  %9 = load i32, i32* %x, align 4, !dbg !52
  %idxprom9 = sext i32 %9 to i64, !dbg !53
  %arrayidx10 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idxprom9, !dbg !53
  %10 = load i32, i32* %arrayidx10, align 4, !dbg !54
  %add11 = add nsw i32 %10, 3, !dbg !54
  store i32 %add11, i32* %arrayidx10, align 4, !dbg !54
  br label %for.inc12, !dbg !55

for.inc12:                                        ; preds = %for.body6
  %11 = load i32, i32* %i3, align 4, !dbg !56
  %inc13 = add nsw i32 %11, 1, !dbg !56
  store i32 %inc13, i32* %i3, align 4, !dbg !56
  br label %for.cond4, !dbg !57, !llvm.loop !58

for.end14:                                        ; preds = %for.cond4
  %12 = load i32, i32* %retval, align 4, !dbg !60
  call void @loop_counter_output(), !dbg !60
  ret i32 %12, !dbg !60
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @add_instr_rec(i32, i64, i32)

declare void @add_ptr_instr_rec(i32, i64, i32, i64)

declare void @incr_loop_counter(i32)

declare void @loop_counter_output()

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 8.0.1-9 (tags/RELEASE_801/final)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, nameTableKind: None)
!1 = !DIFile(filename: "simple_doall.c", directory: "/home/lukas/git/discopop/discopop_validation/test/simple_doall")
!2 = !{}
!3 = !{i32 2, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"clang version 8.0.1-9 (tags/RELEASE_801/final)"}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 3, type: !8, scopeLine: 3, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "arr", scope: !7, file: !1, line: 4, type: !12)
!12 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 320, elements: !13)
!13 = !{!14}
!14 = !DISubrange(count: 10)
!15 = !DILocation(line: 4, column: 9, scope: !7)
!16 = !DILocalVariable(name: "i", scope: !17, file: !1, line: 6, type: !10)
!17 = distinct !DILexicalBlock(scope: !7, file: !1, line: 6, column: 5)
!18 = !DILocation(line: 6, column: 13, scope: !17)
!19 = !DILocation(line: 6, column: 9, scope: !17)
!20 = !DILocation(line: 6, column: 18, scope: !21)
!21 = distinct !DILexicalBlock(scope: !17, file: !1, line: 6, column: 5)
!22 = !DILocation(line: 6, column: 20, scope: !21)
!23 = !DILocation(line: 6, column: 5, scope: !17)
!24 = !DILocation(line: 7, column: 18, scope: !25)
!25 = distinct !DILexicalBlock(scope: !21, file: !1, line: 6, column: 30)
!26 = !DILocation(line: 7, column: 13, scope: !25)
!27 = !DILocation(line: 7, column: 9, scope: !25)
!28 = !DILocation(line: 7, column: 16, scope: !25)
!29 = !DILocation(line: 8, column: 13, scope: !25)
!30 = !DILocation(line: 8, column: 9, scope: !25)
!31 = !DILocation(line: 8, column: 16, scope: !25)
!32 = !DILocation(line: 9, column: 5, scope: !25)
!33 = !DILocation(line: 6, column: 27, scope: !21)
!34 = !DILocation(line: 6, column: 5, scope: !21)
!35 = distinct !{!35, !23, !36}
!36 = !DILocation(line: 9, column: 5, scope: !17)
!37 = !DILocalVariable(name: "x", scope: !7, file: !1, line: 11, type: !10)
!38 = !DILocation(line: 11, column: 9, scope: !7)
!39 = !DILocalVariable(name: "i", scope: !40, file: !1, line: 12, type: !10)
!40 = distinct !DILexicalBlock(scope: !7, file: !1, line: 12, column: 5)
!41 = !DILocation(line: 12, column: 13, scope: !40)
!42 = !DILocation(line: 12, column: 9, scope: !40)
!43 = !DILocation(line: 12, column: 18, scope: !44)
!44 = distinct !DILexicalBlock(scope: !40, file: !1, line: 12, column: 5)
!45 = !DILocation(line: 12, column: 20, scope: !44)
!46 = !DILocation(line: 12, column: 5, scope: !40)
!47 = !DILocation(line: 13, column: 18, scope: !48)
!48 = distinct !DILexicalBlock(scope: !44, file: !1, line: 12, column: 30)
!49 = !DILocation(line: 13, column: 13, scope: !48)
!50 = !DILocation(line: 13, column: 9, scope: !48)
!51 = !DILocation(line: 13, column: 16, scope: !48)
!52 = !DILocation(line: 14, column: 13, scope: !48)
!53 = !DILocation(line: 14, column: 9, scope: !48)
!54 = !DILocation(line: 14, column: 16, scope: !48)
!55 = !DILocation(line: 15, column: 5, scope: !48)
!56 = !DILocation(line: 12, column: 27, scope: !44)
!57 = !DILocation(line: 12, column: 5, scope: !44)
!58 = distinct !{!58, !46, !59}
!59 = !DILocation(line: 15, column: 5, scope: !40)
!60 = !DILocation(line: 17, column: 1, scope: !7)
