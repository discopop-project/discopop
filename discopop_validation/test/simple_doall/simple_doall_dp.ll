; ModuleID = '/home/lukas/Schreibtisch/dpvsc_test/simple_doall.c'
source_filename = "/home/lukas/Schreibtisch/dpvsc_test/simple_doall.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c"arr\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"z\00", align 1
@.str.5 = private unnamed_addr constant [7 x i8] c"retval\00", align 1

; Function Attrs: noinline norecurse nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16388, i32 1)
  %retval = alloca i32, align 4
  %arr = alloca [10 x i32], align 16
  %x = alloca i32, align 4
  %y = alloca i32, align 4
  %i = alloca i32, align 4
  %z = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata [10 x i32]* %arr, metadata !12, metadata !DIExpression()), !dbg !16
  call void @llvm.dbg.declare(metadata i32* %x, metadata !17, metadata !DIExpression()), !dbg !18
  %0 = ptrtoint i32* %x to i64
  call void @__dp_write(i32 16389, i64 %0, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i32 0, i32* %x, align 4, !dbg !18
  call void @llvm.dbg.declare(metadata i32* %y, metadata !19, metadata !DIExpression()), !dbg !20
  %1 = ptrtoint i32* %y to i64
  call void @__dp_write(i32 16390, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %y, align 4, !dbg !20
  call void @llvm.dbg.declare(metadata i32* %i, metadata !21, metadata !DIExpression()), !dbg !23
  %2 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16391, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !23
  br label %for.cond, !dbg !24

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16391, i32 0)
  %3 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16391, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %4 = load i32, i32* %i, align 4, !dbg !25
  %cmp = icmp slt i32 %4, 10, !dbg !27
  br i1 %cmp, label %for.body, label %for.end, !dbg !28

for.body:                                         ; preds = %for.cond
  %5 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16392, i64 %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %6 = load i32, i32* %i, align 4, !dbg !29
  %7 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16392, i64 %7, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %8 = load i32, i32* %i, align 4, !dbg !31
  %idxprom = sext i32 %8 to i64, !dbg !32
  %arrayidx = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idxprom, !dbg !32
  %9 = ptrtoint i32* %arrayidx to i64
  call void @__dp_write(i32 16392, i64 %9, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  store i32 %6, i32* %arrayidx, align 4, !dbg !33
  call void @llvm.dbg.declare(metadata i32* %z, metadata !34, metadata !DIExpression()), !dbg !35
  %10 = ptrtoint i32* %z to i64
  call void @__dp_write(i32 16393, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 0, i32* %z, align 4, !dbg !35
  %11 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16394, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %12 = load i32, i32* %x, align 4, !dbg !36
  %cmp1 = icmp sgt i32 %12, 3, !dbg !38
  br i1 %cmp1, label %if.then, label %if.end, !dbg !39

if.then:                                          ; preds = %for.body
  %13 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16395, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %14 = load i32, i32* %x, align 4, !dbg !40
  %add = add nsw i32 %14, 3, !dbg !42
  %15 = ptrtoint i32* %z to i64
  call void @__dp_write(i32 16395, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 %add, i32* %z, align 4, !dbg !43
  br label %if.end, !dbg !44

if.end:                                           ; preds = %if.then, %for.body
  br label %for.inc, !dbg !45

for.inc:                                          ; preds = %if.end
  %16 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16391, i64 %16, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %17 = load i32, i32* %i, align 4, !dbg !46
  %inc = add nsw i32 %17, 1, !dbg !46
  %18 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16391, i64 %18, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !46
  br label %for.cond, !dbg !47, !llvm.loop !48

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16399, i32 0)
  %19 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16399, i64 %19, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %20 = load i32, i32* %x, align 4, !dbg !50
  %cmp2 = icmp sgt i32 %20, 3, !dbg !52
  br i1 %cmp2, label %if.then3, label %if.else, !dbg !53

if.then3:                                         ; preds = %for.end
  %21 = ptrtoint i32* %y to i64
  call void @__dp_read(i32 16400, i64 %21, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %22 = load i32, i32* %y, align 4, !dbg !54
  %23 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16400, i64 %23, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %24 = load i32, i32* %x, align 4, !dbg !56
  %add4 = add nsw i32 %22, %24, !dbg !57
  %25 = ptrtoint i32* %y to i64
  call void @__dp_write(i32 16400, i64 %25, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 %add4, i32* %y, align 4, !dbg !58
  br label %if.end5, !dbg !59

if.else:                                          ; preds = %for.end
  %26 = ptrtoint i32* %y to i64
  call void @__dp_read(i32 16403, i64 %26, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %27 = load i32, i32* %y, align 4, !dbg !60
  %28 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16403, i64 %28, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %29 = load i32, i32* %x, align 4, !dbg !62
  %sub = sub nsw i32 %27, %29, !dbg !63
  %30 = ptrtoint i32* %y to i64
  call void @__dp_write(i32 16403, i64 %30, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 %sub, i32* %y, align 4, !dbg !64
  br label %if.end5

if.end5:                                          ; preds = %if.else, %if.then3
  %31 = ptrtoint i32* %retval to i64
  call void @__dp_read(i32 16406, i64 %31, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.5, i32 0, i32 0))
  %32 = load i32, i32* %retval, align 4, !dbg !65
  call void @__dp_finalize(i32 16406), !dbg !65
  ret i32 %32, !dbg !65
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_init(i32, i32, i32)

declare void @__dp_finalize(i32)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_write(i32, i64, i8*)

declare void @__dp_call(i32)

declare void @__dp_func_entry(i32, i32)

declare void @__dp_func_exit(i32, i32)

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_loop_exit(i32, i32)

attributes #0 = { noinline norecurse nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "clang version 8.0.1 (tags/RELEASE_801/final)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, nameTableKind: None)
!1 = !DIFile(filename: "/home/lukas/Schreibtisch/dpvsc_test/simple_doall.c", directory: "/home/lukas/Schreibtisch/dpvsc_test")
!2 = !{}
!3 = !{i32 2, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"clang version 8.0.1 (tags/RELEASE_801/final)"}
!7 = distinct !DISubprogram(name: "main", scope: !8, file: !8, line: 3, type: !9, scopeLine: 3, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DIFile(filename: "simple_doall.c", directory: "/home/lukas/Schreibtisch/dpvsc_test")
!9 = !DISubroutineType(types: !10)
!10 = !{!11}
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !DILocalVariable(name: "arr", scope: !7, file: !8, line: 4, type: !13)
!13 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 320, elements: !14)
!14 = !{!15}
!15 = !DISubrange(count: 10)
!16 = !DILocation(line: 4, column: 9, scope: !7)
!17 = !DILocalVariable(name: "x", scope: !7, file: !8, line: 5, type: !11)
!18 = !DILocation(line: 5, column: 9, scope: !7)
!19 = !DILocalVariable(name: "y", scope: !7, file: !8, line: 6, type: !11)
!20 = !DILocation(line: 6, column: 9, scope: !7)
!21 = !DILocalVariable(name: "i", scope: !22, file: !8, line: 7, type: !11)
!22 = distinct !DILexicalBlock(scope: !7, file: !8, line: 7, column: 5)
!23 = !DILocation(line: 7, column: 13, scope: !22)
!24 = !DILocation(line: 7, column: 9, scope: !22)
!25 = !DILocation(line: 7, column: 18, scope: !26)
!26 = distinct !DILexicalBlock(scope: !22, file: !8, line: 7, column: 5)
!27 = !DILocation(line: 7, column: 20, scope: !26)
!28 = !DILocation(line: 7, column: 5, scope: !22)
!29 = !DILocation(line: 8, column: 18, scope: !30)
!30 = distinct !DILexicalBlock(scope: !26, file: !8, line: 7, column: 30)
!31 = !DILocation(line: 8, column: 13, scope: !30)
!32 = !DILocation(line: 8, column: 9, scope: !30)
!33 = !DILocation(line: 8, column: 16, scope: !30)
!34 = !DILocalVariable(name: "z", scope: !30, file: !8, line: 9, type: !11)
!35 = !DILocation(line: 9, column: 13, scope: !30)
!36 = !DILocation(line: 10, column: 12, scope: !37)
!37 = distinct !DILexicalBlock(scope: !30, file: !8, line: 10, column: 12)
!38 = !DILocation(line: 10, column: 14, scope: !37)
!39 = !DILocation(line: 10, column: 12, scope: !30)
!40 = !DILocation(line: 11, column: 17, scope: !41)
!41 = distinct !DILexicalBlock(scope: !37, file: !8, line: 10, column: 18)
!42 = !DILocation(line: 11, column: 19, scope: !41)
!43 = !DILocation(line: 11, column: 15, scope: !41)
!44 = !DILocation(line: 12, column: 9, scope: !41)
!45 = !DILocation(line: 13, column: 5, scope: !30)
!46 = !DILocation(line: 7, column: 27, scope: !26)
!47 = !DILocation(line: 7, column: 5, scope: !26)
!48 = distinct !{!48, !28, !49}
!49 = !DILocation(line: 13, column: 5, scope: !22)
!50 = !DILocation(line: 15, column: 8, scope: !51)
!51 = distinct !DILexicalBlock(scope: !7, file: !8, line: 15, column: 8)
!52 = !DILocation(line: 15, column: 10, scope: !51)
!53 = !DILocation(line: 15, column: 8, scope: !7)
!54 = !DILocation(line: 16, column: 13, scope: !55)
!55 = distinct !DILexicalBlock(scope: !51, file: !8, line: 15, column: 14)
!56 = !DILocation(line: 16, column: 17, scope: !55)
!57 = !DILocation(line: 16, column: 15, scope: !55)
!58 = !DILocation(line: 16, column: 11, scope: !55)
!59 = !DILocation(line: 17, column: 5, scope: !55)
!60 = !DILocation(line: 19, column: 13, scope: !61)
!61 = distinct !DILexicalBlock(scope: !51, file: !8, line: 18, column: 9)
!62 = !DILocation(line: 19, column: 17, scope: !61)
!63 = !DILocation(line: 19, column: 15, scope: !61)
!64 = !DILocation(line: 19, column: 11, scope: !61)
!65 = !DILocation(line: 22, column: 1, scope: !7)
