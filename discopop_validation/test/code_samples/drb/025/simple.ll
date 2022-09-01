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
  %saved_stack = alloca i8*, align 8
  %__vla_expr0 = alloca i64, align 8
  %__vla_expr1 = alloca i64, align 8
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
  %3 = load i32, i32* %len, align 4, !dbg !30
  %4 = zext i32 %3 to i64, !dbg !31
  %5 = call i8* @llvm.stacksave(), !dbg !31
  store i8* %5, i8** %saved_stack, align 8, !dbg !31
  %vla = alloca i32, i64 %4, align 16, !dbg !31
  store i64 %4, i64* %__vla_expr0, align 8, !dbg !31
  call void @llvm.dbg.declare(metadata i64* %__vla_expr0, metadata !32, metadata !DIExpression()), !dbg !34
  call void @llvm.dbg.declare(metadata i32* %vla, metadata !35, metadata !DIExpression()), !dbg !39
  %6 = load i32, i32* %len, align 4, !dbg !40
  %7 = zext i32 %6 to i64, !dbg !31
  %vla1 = alloca i32, i64 %7, align 16, !dbg !31
  store i64 %7, i64* %__vla_expr1, align 8, !dbg !31
  call void @llvm.dbg.declare(metadata i64* %__vla_expr1, metadata !41, metadata !DIExpression()), !dbg !34
  call void @llvm.dbg.declare(metadata i32* %vla1, metadata !42, metadata !DIExpression()), !dbg !46
  store i32 0, i32* %i, align 4, !dbg !47
  br label %for.cond, !dbg !49

for.cond:                                         ; preds = %for.inc, %if.end
  %8 = load i32, i32* %i, align 4, !dbg !50
  %9 = load i32, i32* %len, align 4, !dbg !52
  %cmp2 = icmp slt i32 %8, %9, !dbg !53
  br i1 %cmp2, label %for.body, label %for.end, !dbg !54

for.body:                                         ; preds = %for.cond
  %10 = load i32, i32* %i, align 4, !dbg !55
  %11 = load i32, i32* %i, align 4, !dbg !57
  %idxprom = sext i32 %11 to i64, !dbg !58
  %arrayidx3 = getelementptr inbounds i32, i32* %vla, i64 %idxprom, !dbg !58
  store i32 %10, i32* %arrayidx3, align 4, !dbg !59
  %12 = load i32, i32* %i, align 4, !dbg !60
  %add = add nsw i32 %12, 1, !dbg !61
  %13 = load i32, i32* %i, align 4, !dbg !62
  %idxprom4 = sext i32 %13 to i64, !dbg !63
  %arrayidx5 = getelementptr inbounds i32, i32* %vla1, i64 %idxprom4, !dbg !63
  store i32 %add, i32* %arrayidx5, align 4, !dbg !64
  br label %for.inc, !dbg !65

for.inc:                                          ; preds = %for.body
  %14 = load i32, i32* %i, align 4, !dbg !66
  %inc = add nsw i32 %14, 1, !dbg !66
  store i32 %inc, i32* %i, align 4, !dbg !66
  br label %for.cond, !dbg !67, !llvm.loop !68

for.end:                                          ; preds = %for.cond
  store i32 0, i32* %i, align 4, !dbg !70
  br label %for.cond6, !dbg !72

for.cond6:                                        ; preds = %for.inc16, %for.end
  %15 = load i32, i32* %i, align 4, !dbg !73
  %16 = load i32, i32* %len, align 4, !dbg !75
  %sub = sub nsw i32 %16, 1, !dbg !76
  %cmp7 = icmp slt i32 %15, %sub, !dbg !77
  br i1 %cmp7, label %for.body8, label %for.end18, !dbg !78

for.body8:                                        ; preds = %for.cond6
  %17 = load i32, i32* %i, align 4, !dbg !79
  %idxprom9 = sext i32 %17 to i64, !dbg !80
  %arrayidx10 = getelementptr inbounds i32, i32* %vla, i64 %idxprom9, !dbg !80
  %18 = load i32, i32* %arrayidx10, align 4, !dbg !80
  %19 = load i32, i32* %i, align 4, !dbg !81
  %idxprom11 = sext i32 %19 to i64, !dbg !82
  %arrayidx12 = getelementptr inbounds i32, i32* %vla1, i64 %idxprom11, !dbg !82
  %20 = load i32, i32* %arrayidx12, align 4, !dbg !82
  %mul = mul nsw i32 %18, %20, !dbg !83
  %21 = load i32, i32* %i, align 4, !dbg !84
  %add13 = add nsw i32 %21, 1, !dbg !85
  %idxprom14 = sext i32 %add13 to i64, !dbg !86
  %arrayidx15 = getelementptr inbounds i32, i32* %vla, i64 %idxprom14, !dbg !86
  store i32 %mul, i32* %arrayidx15, align 4, !dbg !87
  br label %for.inc16, !dbg !86

for.inc16:                                        ; preds = %for.body8
  %22 = load i32, i32* %i, align 4, !dbg !88
  %inc17 = add nsw i32 %22, 1, !dbg !88
  store i32 %inc17, i32* %i, align 4, !dbg !88
  br label %for.cond6, !dbg !89, !llvm.loop !90

for.end18:                                        ; preds = %for.cond6
  store i32 0, i32* %retval, align 4, !dbg !92
  %23 = load i8*, i8** %saved_stack, align 8, !dbg !93
  call void @llvm.stackrestore(i8* %23), !dbg !93
  %24 = load i32, i32* %retval, align 4, !dbg !93
  ret i32 %24, !dbg !93
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
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/025")
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
!30 = !DILocation(line: 60, column: 9, scope: !7)
!31 = !DILocation(line: 60, column: 3, scope: !7)
!32 = !DILocalVariable(name: "__vla_expr0", scope: !7, type: !33, flags: DIFlagArtificial)
!33 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!34 = !DILocation(line: 0, scope: !7)
!35 = !DILocalVariable(name: "a", scope: !7, file: !1, line: 60, type: !36)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, elements: !37)
!37 = !{!38}
!38 = !DISubrange(count: !32)
!39 = !DILocation(line: 60, column: 7, scope: !7)
!40 = !DILocation(line: 60, column: 17, scope: !7)
!41 = !DILocalVariable(name: "__vla_expr1", scope: !7, type: !33, flags: DIFlagArtificial)
!42 = !DILocalVariable(name: "b", scope: !7, file: !1, line: 60, type: !43)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, elements: !44)
!44 = !{!45}
!45 = !DISubrange(count: !41)
!46 = !DILocation(line: 60, column: 15, scope: !7)
!47 = !DILocation(line: 61, column: 9, scope: !48)
!48 = distinct !DILexicalBlock(scope: !7, file: !1, line: 61, column: 3)
!49 = !DILocation(line: 61, column: 8, scope: !48)
!50 = !DILocation(line: 61, column: 12, scope: !51)
!51 = distinct !DILexicalBlock(scope: !48, file: !1, line: 61, column: 3)
!52 = !DILocation(line: 61, column: 14, scope: !51)
!53 = !DILocation(line: 61, column: 13, scope: !51)
!54 = !DILocation(line: 61, column: 3, scope: !48)
!55 = !DILocation(line: 63, column: 10, scope: !56)
!56 = distinct !DILexicalBlock(scope: !51, file: !1, line: 62, column: 3)
!57 = !DILocation(line: 63, column: 7, scope: !56)
!58 = !DILocation(line: 63, column: 5, scope: !56)
!59 = !DILocation(line: 63, column: 9, scope: !56)
!60 = !DILocation(line: 64, column: 10, scope: !56)
!61 = !DILocation(line: 64, column: 11, scope: !56)
!62 = !DILocation(line: 64, column: 7, scope: !56)
!63 = !DILocation(line: 64, column: 5, scope: !56)
!64 = !DILocation(line: 64, column: 9, scope: !56)
!65 = !DILocation(line: 65, column: 3, scope: !56)
!66 = !DILocation(line: 61, column: 19, scope: !51)
!67 = !DILocation(line: 61, column: 3, scope: !51)
!68 = distinct !{!68, !54, !69}
!69 = !DILocation(line: 65, column: 3, scope: !48)
!70 = !DILocation(line: 67, column: 9, scope: !71)
!71 = distinct !DILexicalBlock(scope: !7, file: !1, line: 67, column: 3)
!72 = !DILocation(line: 67, column: 8, scope: !71)
!73 = !DILocation(line: 67, column: 12, scope: !74)
!74 = distinct !DILexicalBlock(scope: !71, file: !1, line: 67, column: 3)
!75 = !DILocation(line: 67, column: 14, scope: !74)
!76 = !DILocation(line: 67, column: 17, scope: !74)
!77 = !DILocation(line: 67, column: 13, scope: !74)
!78 = !DILocation(line: 67, column: 3, scope: !71)
!79 = !DILocation(line: 68, column: 14, scope: !74)
!80 = !DILocation(line: 68, column: 12, scope: !74)
!81 = !DILocation(line: 68, column: 19, scope: !74)
!82 = !DILocation(line: 68, column: 17, scope: !74)
!83 = !DILocation(line: 68, column: 16, scope: !74)
!84 = !DILocation(line: 68, column: 7, scope: !74)
!85 = !DILocation(line: 68, column: 8, scope: !74)
!86 = !DILocation(line: 68, column: 5, scope: !74)
!87 = !DILocation(line: 68, column: 11, scope: !74)
!88 = !DILocation(line: 67, column: 21, scope: !74)
!89 = !DILocation(line: 67, column: 3, scope: !74)
!90 = distinct !{!90, !78, !91}
!91 = !DILocation(line: 68, column: 20, scope: !71)
!92 = !DILocation(line: 69, column: 3, scope: !7)
!93 = !DILocation(line: 70, column: 1, scope: !7)
