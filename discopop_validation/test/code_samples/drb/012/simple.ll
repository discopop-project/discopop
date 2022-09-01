; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !7 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %len = alloca i32, align 4
  %numNodes = alloca i32, align 4
  %numNodes2 = alloca i32, align 4
  %saved_stack = alloca i8*, align 8
  %__vla_expr0 = alloca i64, align 8
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !14, metadata !DIExpression()), !dbg !15
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !16, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.declare(metadata i32* %i, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32* %len, metadata !20, metadata !DIExpression()), !dbg !21
  store i32 100, i32* %len, align 4, !dbg !21
  %0 = load i32, i32* %argc.addr, align 4, !dbg !22
  %cmp = icmp sgt i32 %0, 1, !dbg !24
  br i1 %cmp, label %if.then, label %if.end, !dbg !25

if.then:                                          ; preds = %entry
  %1 = load i8**, i8*** %argv.addr, align 8, !dbg !26
  %arrayidx = getelementptr inbounds i8*, i8** %1, i64 1, !dbg !26
  %2 = load i8*, i8** %arrayidx, align 8, !dbg !26
  %call = call i32 @atoi(i8* %2) #4, !dbg !27
  store i32 %call, i32* %len, align 4, !dbg !28
  br label %if.end, !dbg !29

if.end:                                           ; preds = %if.then, %entry
  call void @llvm.dbg.declare(metadata i32* %numNodes, metadata !30, metadata !DIExpression()), !dbg !31
  %3 = load i32, i32* %len, align 4, !dbg !32
  store i32 %3, i32* %numNodes, align 4, !dbg !31
  call void @llvm.dbg.declare(metadata i32* %numNodes2, metadata !33, metadata !DIExpression()), !dbg !34
  store i32 0, i32* %numNodes2, align 4, !dbg !34
  %4 = load i32, i32* %len, align 4, !dbg !35
  %5 = zext i32 %4 to i64, !dbg !36
  %6 = call i8* @llvm.stacksave(), !dbg !36
  store i8* %6, i8** %saved_stack, align 8, !dbg !36
  %vla = alloca i32, i64 %5, align 16, !dbg !36
  store i64 %5, i64* %__vla_expr0, align 8, !dbg !36
  call void @llvm.dbg.declare(metadata i64* %__vla_expr0, metadata !37, metadata !DIExpression()), !dbg !39
  call void @llvm.dbg.declare(metadata i32* %vla, metadata !40, metadata !DIExpression()), !dbg !44
  store i32 0, i32* %i, align 4, !dbg !45
  br label %for.cond, !dbg !47

for.cond:                                         ; preds = %for.inc, %if.end
  %7 = load i32, i32* %i, align 4, !dbg !48
  %8 = load i32, i32* %len, align 4, !dbg !50
  %cmp1 = icmp slt i32 %7, %8, !dbg !51
  br i1 %cmp1, label %for.body, label %for.end, !dbg !52

for.body:                                         ; preds = %for.cond
  %9 = load i32, i32* %i, align 4, !dbg !53
  %rem = srem i32 %9, 2, !dbg !56
  %cmp2 = icmp eq i32 %rem, 0, !dbg !57
  br i1 %cmp2, label %if.then3, label %if.else, !dbg !58

if.then3:                                         ; preds = %for.body
  %10 = load i32, i32* %i, align 4, !dbg !59
  %idxprom = sext i32 %10 to i64, !dbg !60
  %arrayidx4 = getelementptr inbounds i32, i32* %vla, i64 %idxprom, !dbg !60
  store i32 5, i32* %arrayidx4, align 4, !dbg !61
  br label %if.end7, !dbg !60

if.else:                                          ; preds = %for.body
  %11 = load i32, i32* %i, align 4, !dbg !62
  %idxprom5 = sext i32 %11 to i64, !dbg !63
  %arrayidx6 = getelementptr inbounds i32, i32* %vla, i64 %idxprom5, !dbg !63
  store i32 -5, i32* %arrayidx6, align 4, !dbg !64
  br label %if.end7

if.end7:                                          ; preds = %if.else, %if.then3
  br label %for.inc, !dbg !65

for.inc:                                          ; preds = %if.end7
  %12 = load i32, i32* %i, align 4, !dbg !66
  %inc = add nsw i32 %12, 1, !dbg !66
  store i32 %inc, i32* %i, align 4, !dbg !66
  br label %for.cond, !dbg !67, !llvm.loop !68

for.end:                                          ; preds = %for.cond
  %13 = load i32, i32* %numNodes, align 4, !dbg !70
  %sub = sub nsw i32 %13, 1, !dbg !72
  store i32 %sub, i32* %i, align 4, !dbg !73
  br label %for.cond8, !dbg !74

for.cond8:                                        ; preds = %for.inc16, %for.end
  %14 = load i32, i32* %i, align 4, !dbg !75
  %cmp9 = icmp sgt i32 %14, -1, !dbg !77
  br i1 %cmp9, label %for.body10, label %for.end18, !dbg !78

for.body10:                                       ; preds = %for.cond8
  %15 = load i32, i32* %i, align 4, !dbg !79
  %idxprom11 = sext i32 %15 to i64, !dbg !82
  %arrayidx12 = getelementptr inbounds i32, i32* %vla, i64 %idxprom11, !dbg !82
  %16 = load i32, i32* %arrayidx12, align 4, !dbg !82
  %cmp13 = icmp sle i32 %16, 0, !dbg !83
  br i1 %cmp13, label %if.then14, label %if.end15, !dbg !84

if.then14:                                        ; preds = %for.body10
  %17 = load i32, i32* %numNodes2, align 4, !dbg !85
  %dec = add nsw i32 %17, -1, !dbg !85
  store i32 %dec, i32* %numNodes2, align 4, !dbg !85
  br label %if.end15, !dbg !87

if.end15:                                         ; preds = %if.then14, %for.body10
  br label %for.inc16, !dbg !88

for.inc16:                                        ; preds = %if.end15
  %18 = load i32, i32* %i, align 4, !dbg !89
  %dec17 = add nsw i32 %18, -1, !dbg !89
  store i32 %dec17, i32* %i, align 4, !dbg !89
  br label %for.cond8, !dbg !90, !llvm.loop !91

for.end18:                                        ; preds = %for.cond8
  store i32 0, i32* %retval, align 4, !dbg !93
  %19 = load i8*, i8** %saved_stack, align 8, !dbg !94
  call void @llvm.stackrestore(i8* %19), !dbg !94
  %20 = load i32, i32* %retval, align 4, !dbg !94
  ret i32 %20, !dbg !94
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind readonly
declare dso_local i32 @atoi(i8*) #2

; Function Attrs: nounwind
declare i8* @llvm.stacksave() #3

; Function Attrs: nounwind
declare void @llvm.stackrestore(i8*) #3

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }
attributes #4 = { nounwind readonly }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/012")
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
!22 = !DILocation(line: 57, column: 7, scope: !23)
!23 = distinct !DILexicalBlock(scope: !7, file: !1, line: 57, column: 7)
!24 = !DILocation(line: 57, column: 11, scope: !23)
!25 = !DILocation(line: 57, column: 7, scope: !7)
!26 = !DILocation(line: 58, column: 16, scope: !23)
!27 = !DILocation(line: 58, column: 11, scope: !23)
!28 = !DILocation(line: 58, column: 9, scope: !23)
!29 = !DILocation(line: 58, column: 5, scope: !23)
!30 = !DILocalVariable(name: "numNodes", scope: !7, file: !1, line: 60, type: !10)
!31 = !DILocation(line: 60, column: 7, scope: !7)
!32 = !DILocation(line: 60, column: 16, scope: !7)
!33 = !DILocalVariable(name: "numNodes2", scope: !7, file: !1, line: 60, type: !10)
!34 = !DILocation(line: 60, column: 21, scope: !7)
!35 = !DILocation(line: 61, column: 9, scope: !7)
!36 = !DILocation(line: 61, column: 3, scope: !7)
!37 = !DILocalVariable(name: "__vla_expr0", scope: !7, type: !38, flags: DIFlagArtificial)
!38 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!39 = !DILocation(line: 0, scope: !7)
!40 = !DILocalVariable(name: "x", scope: !7, file: !1, line: 61, type: !41)
!41 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, elements: !42)
!42 = !{!43}
!43 = !DISubrange(count: !37)
!44 = !DILocation(line: 61, column: 7, scope: !7)
!45 = !DILocation(line: 63, column: 9, scope: !46)
!46 = distinct !DILexicalBlock(scope: !7, file: !1, line: 63, column: 3)
!47 = !DILocation(line: 63, column: 8, scope: !46)
!48 = !DILocation(line: 63, column: 13, scope: !49)
!49 = distinct !DILexicalBlock(scope: !46, file: !1, line: 63, column: 3)
!50 = !DILocation(line: 63, column: 16, scope: !49)
!51 = !DILocation(line: 63, column: 14, scope: !49)
!52 = !DILocation(line: 63, column: 3, scope: !46)
!53 = !DILocation(line: 65, column: 9, scope: !54)
!54 = distinct !DILexicalBlock(scope: !55, file: !1, line: 65, column: 9)
!55 = distinct !DILexicalBlock(scope: !49, file: !1, line: 64, column: 3)
!56 = !DILocation(line: 65, column: 10, scope: !54)
!57 = !DILocation(line: 65, column: 12, scope: !54)
!58 = !DILocation(line: 65, column: 9, scope: !55)
!59 = !DILocation(line: 66, column: 9, scope: !54)
!60 = !DILocation(line: 66, column: 7, scope: !54)
!61 = !DILocation(line: 66, column: 11, scope: !54)
!62 = !DILocation(line: 68, column: 9, scope: !54)
!63 = !DILocation(line: 68, column: 7, scope: !54)
!64 = !DILocation(line: 68, column: 11, scope: !54)
!65 = !DILocation(line: 69, column: 3, scope: !55)
!66 = !DILocation(line: 63, column: 22, scope: !49)
!67 = !DILocation(line: 63, column: 3, scope: !49)
!68 = distinct !{!68, !52, !69}
!69 = !DILocation(line: 69, column: 3, scope: !46)
!70 = !DILocation(line: 72, column: 10, scope: !71)
!71 = distinct !DILexicalBlock(scope: !7, file: !1, line: 72, column: 3)
!72 = !DILocation(line: 72, column: 18, scope: !71)
!73 = !DILocation(line: 72, column: 9, scope: !71)
!74 = !DILocation(line: 72, column: 8, scope: !71)
!75 = !DILocation(line: 72, column: 23, scope: !76)
!76 = distinct !DILexicalBlock(scope: !71, file: !1, line: 72, column: 3)
!77 = !DILocation(line: 72, column: 24, scope: !76)
!78 = !DILocation(line: 72, column: 3, scope: !71)
!79 = !DILocation(line: 73, column: 11, scope: !80)
!80 = distinct !DILexicalBlock(scope: !81, file: !1, line: 73, column: 9)
!81 = distinct !DILexicalBlock(scope: !76, file: !1, line: 72, column: 35)
!82 = !DILocation(line: 73, column: 9, scope: !80)
!83 = !DILocation(line: 73, column: 13, scope: !80)
!84 = !DILocation(line: 73, column: 9, scope: !81)
!85 = !DILocation(line: 74, column: 16, scope: !86)
!86 = distinct !DILexicalBlock(scope: !80, file: !1, line: 73, column: 18)
!87 = !DILocation(line: 75, column: 5, scope: !86)
!88 = !DILocation(line: 76, column: 3, scope: !81)
!89 = !DILocation(line: 72, column: 30, scope: !76)
!90 = !DILocation(line: 72, column: 3, scope: !76)
!91 = distinct !{!91, !78, !92}
!92 = !DILocation(line: 76, column: 3, scope: !71)
!93 = !DILocation(line: 77, column: 3, scope: !7)
!94 = !DILocation(line: 78, column: 1, scope: !7)
