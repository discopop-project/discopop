; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"arr\00", align 1
@.str.3 = private unnamed_addr constant [7 x i8] c"retval\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16388, i32 1)
  %retval = alloca i32, align 4
  %arr = alloca [10 x i32], align 16
  %x = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata [10 x i32]* %arr, metadata !11, metadata !DIExpression()), !dbg !15
  call void @llvm.dbg.declare(metadata i32* %x, metadata !16, metadata !DIExpression()), !dbg !17
  %0 = ptrtoint i32* %x to i64
  call void @__dp_write(i32 16389, i64 %0, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i32 3, i32* %x, align 4, !dbg !17
  call void @llvm.dbg.declare(metadata i32* %i, metadata !18, metadata !DIExpression()), !dbg !20
  %1 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16390, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !20
  br label %for.cond, !dbg !21

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16390, i32 0)
  %2 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16390, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %3 = load i32, i32* %i, align 4, !dbg !22
  %cmp = icmp slt i32 %3, 100000, !dbg !24
  br i1 %cmp, label %for.body, label %for.end, !dbg !25

for.body:                                         ; preds = %for.cond
  %4 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16391, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %5 = load i32, i32* %i, align 4, !dbg !26
  %6 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16391, i64 %6, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %7 = load i32, i32* %x, align 4, !dbg !28
  %idxprom = sext i32 %7 to i64, !dbg !29
  %arrayidx = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idxprom, !dbg !29
  %8 = ptrtoint i32* %arrayidx to i64
  call void @__dp_write(i32 16391, i64 %8, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  store i32 %5, i32* %arrayidx, align 4, !dbg !30
  %9 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16392, i64 %9, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %10 = load i32, i32* %x, align 4, !dbg !31
  %idxprom1 = sext i32 %10 to i64, !dbg !32
  %arrayidx2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idxprom1, !dbg !32
  %11 = ptrtoint i32* %arrayidx2 to i64
  call void @__dp_read(i32 16392, i64 %11, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  %12 = load i32, i32* %arrayidx2, align 4, !dbg !33
  %add = add nsw i32 %12, 3, !dbg !33
  %13 = ptrtoint i32* %arrayidx2 to i64
  call void @__dp_write(i32 16392, i64 %13, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  store i32 %add, i32* %arrayidx2, align 4, !dbg !33
  %14 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16393, i64 %14, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %15 = load i32, i32* %x, align 4, !dbg !34
  %idxprom3 = sext i32 %15 to i64, !dbg !35
  %arrayidx4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idxprom3, !dbg !35
  %16 = ptrtoint i32* %arrayidx4 to i64
  call void @__dp_read(i32 16393, i64 %16, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  %17 = load i32, i32* %arrayidx4, align 4, !dbg !35
  %18 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16393, i64 %18, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %19 = load i32, i32* %x, align 4, !dbg !36
  %idxprom5 = sext i32 %19 to i64, !dbg !37
  %arrayidx6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idxprom5, !dbg !37
  %20 = ptrtoint i32* %arrayidx6 to i64
  call void @__dp_read(i32 16393, i64 %20, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  %21 = load i32, i32* %arrayidx6, align 4, !dbg !37
  %rem = srem i32 %21, 2, !dbg !38
  %sub = sub nsw i32 %17, %rem, !dbg !39
  %22 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16393, i64 %22, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %23 = load i32, i32* %x, align 4, !dbg !40
  %idxprom7 = sext i32 %23 to i64, !dbg !41
  %arrayidx8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idxprom7, !dbg !41
  %24 = ptrtoint i32* %arrayidx8 to i64
  call void @__dp_write(i32 16393, i64 %24, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  store i32 %sub, i32* %arrayidx8, align 4, !dbg !42
  %25 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16394, i64 %25, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %26 = load i32, i32* %x, align 4, !dbg !43
  %idxprom9 = sext i32 %26 to i64, !dbg !44
  %arrayidx10 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idxprom9, !dbg !44
  %27 = ptrtoint i32* %arrayidx10 to i64
  call void @__dp_read(i32 16394, i64 %27, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  %28 = load i32, i32* %arrayidx10, align 4, !dbg !44
  %add11 = add nsw i32 %28, 4, !dbg !45
  %29 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16394, i64 %29, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %30 = load i32, i32* %x, align 4, !dbg !46
  %idxprom12 = sext i32 %30 to i64, !dbg !47
  %arrayidx13 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idxprom12, !dbg !47
  %31 = ptrtoint i32* %arrayidx13 to i64
  call void @__dp_write(i32 16394, i64 %31, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  store i32 %add11, i32* %arrayidx13, align 4, !dbg !48
  br label %for.inc, !dbg !49

for.inc:                                          ; preds = %for.body
  %32 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16390, i64 %32, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %33 = load i32, i32* %i, align 4, !dbg !50
  %inc = add nsw i32 %33, 1, !dbg !50
  %34 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16390, i64 %34, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !50
  br label %for.cond, !dbg !51, !llvm.loop !52

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16397, i32 0)
  %35 = ptrtoint i32* %retval to i64
  call void @__dp_read(i32 16397, i64 %35, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0))
  %36 = load i32, i32* %retval, align 4, !dbg !54
  call void @__dp_finalize(i32 16397), !dbg !54
  ret i32 %36, !dbg !54
}

declare void @__dp_func_entry(i32, i32)

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_write(i32, i64, i8*)

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_loop_exit(i32, i32)

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!3}
!llvm.module.flags = !{!4, !5, !6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 8.0.1-9 (tags/RELEASE_801/final)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, nameTableKind: None)
!1 = !DIFile(filename: "simple_doall.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/simple_doall/path_1_op_8")
!2 = !{}
!3 = !{!"clang version 8.0.1-9 (tags/RELEASE_801/final)"}
!4 = !{i32 2, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 3, type: !8, scopeLine: 3, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "arr", scope: !7, file: !1, line: 4, type: !12)
!12 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 320, elements: !13)
!13 = !{!14}
!14 = !DISubrange(count: 10)
!15 = !DILocation(line: 4, column: 9, scope: !7)
!16 = !DILocalVariable(name: "x", scope: !7, file: !1, line: 5, type: !10)
!17 = !DILocation(line: 5, column: 9, scope: !7)
!18 = !DILocalVariable(name: "i", scope: !19, file: !1, line: 6, type: !10)
!19 = distinct !DILexicalBlock(scope: !7, file: !1, line: 6, column: 5)
!20 = !DILocation(line: 6, column: 13, scope: !19)
!21 = !DILocation(line: 6, column: 9, scope: !19)
!22 = !DILocation(line: 6, column: 18, scope: !23)
!23 = distinct !DILexicalBlock(scope: !19, file: !1, line: 6, column: 5)
!24 = !DILocation(line: 6, column: 20, scope: !23)
!25 = !DILocation(line: 6, column: 5, scope: !19)
!26 = !DILocation(line: 7, column: 18, scope: !27)
!27 = distinct !DILexicalBlock(scope: !23, file: !1, line: 6, column: 34)
!28 = !DILocation(line: 7, column: 13, scope: !27)
!29 = !DILocation(line: 7, column: 9, scope: !27)
!30 = !DILocation(line: 7, column: 16, scope: !27)
!31 = !DILocation(line: 8, column: 13, scope: !27)
!32 = !DILocation(line: 8, column: 9, scope: !27)
!33 = !DILocation(line: 8, column: 16, scope: !27)
!34 = !DILocation(line: 9, column: 22, scope: !27)
!35 = !DILocation(line: 9, column: 18, scope: !27)
!36 = !DILocation(line: 9, column: 32, scope: !27)
!37 = !DILocation(line: 9, column: 28, scope: !27)
!38 = !DILocation(line: 9, column: 35, scope: !27)
!39 = !DILocation(line: 9, column: 25, scope: !27)
!40 = !DILocation(line: 9, column: 13, scope: !27)
!41 = !DILocation(line: 9, column: 9, scope: !27)
!42 = !DILocation(line: 9, column: 16, scope: !27)
!43 = !DILocation(line: 10, column: 22, scope: !27)
!44 = !DILocation(line: 10, column: 18, scope: !27)
!45 = !DILocation(line: 10, column: 25, scope: !27)
!46 = !DILocation(line: 10, column: 13, scope: !27)
!47 = !DILocation(line: 10, column: 9, scope: !27)
!48 = !DILocation(line: 10, column: 16, scope: !27)
!49 = !DILocation(line: 11, column: 5, scope: !27)
!50 = !DILocation(line: 6, column: 31, scope: !23)
!51 = !DILocation(line: 6, column: 5, scope: !23)
!52 = distinct !{!52, !25, !53}
!53 = !DILocation(line: 11, column: 5, scope: !19)
!54 = !DILocation(line: 13, column: 1, scope: !7)
