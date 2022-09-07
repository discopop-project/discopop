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
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !14, metadata !DIExpression()), !dbg !15
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !16, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.declare(metadata i32* %i, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32* %len, metadata !20, metadata !DIExpression()), !dbg !21
  store i32 2000, i32* %len, align 4, !dbg !21
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
  store i32 0, i32* %i, align 4, !dbg !40
  br label %for.cond, !dbg !42

for.cond:                                         ; preds = %for.inc, %if.end
  %6 = load i32, i32* %i, align 4, !dbg !43
  %7 = load i32, i32* %len, align 4, !dbg !45
  %cmp1 = icmp slt i32 %6, %7, !dbg !46
  br i1 %cmp1, label %for.body, label %for.end, !dbg !47

for.body:                                         ; preds = %for.cond
  %8 = load i32, i32* %i, align 4, !dbg !48
  %9 = load i32, i32* %i, align 4, !dbg !49
  %idxprom = sext i32 %9 to i64, !dbg !50
  %arrayidx2 = getelementptr inbounds i32, i32* %vla, i64 %idxprom, !dbg !50
  store i32 %8, i32* %arrayidx2, align 4, !dbg !51
  br label %for.inc, !dbg !50

for.inc:                                          ; preds = %for.body
  %10 = load i32, i32* %i, align 4, !dbg !52
  %inc = add nsw i32 %10, 1, !dbg !52
  store i32 %inc, i32* %i, align 4, !dbg !52
  br label %for.cond, !dbg !53, !llvm.loop !54

for.end:                                          ; preds = %for.cond
  store i32 0, i32* %i, align 4, !dbg !56
  br label %for.cond3, !dbg !58

for.cond3:                                        ; preds = %for.inc11, %for.end
  %11 = load i32, i32* %i, align 4, !dbg !59
  %12 = load i32, i32* %len, align 4, !dbg !61
  %div = sdiv i32 %12, 2, !dbg !62
  %cmp4 = icmp slt i32 %11, %div, !dbg !63
  br i1 %cmp4, label %for.body5, label %for.end13, !dbg !64

for.body5:                                        ; preds = %for.cond3
  %13 = load i32, i32* %i, align 4, !dbg !65
  %idxprom6 = sext i32 %13 to i64, !dbg !66
  %arrayidx7 = getelementptr inbounds i32, i32* %vla, i64 %idxprom6, !dbg !66
  %14 = load i32, i32* %arrayidx7, align 4, !dbg !66
  %add = add nsw i32 %14, 1, !dbg !67
  %15 = load i32, i32* %i, align 4, !dbg !68
  %mul = mul nsw i32 2, %15, !dbg !69
  %add8 = add nsw i32 %mul, 1, !dbg !70
  %idxprom9 = sext i32 %add8 to i64, !dbg !71
  %arrayidx10 = getelementptr inbounds i32, i32* %vla, i64 %idxprom9, !dbg !71
  store i32 %add, i32* %arrayidx10, align 4, !dbg !72
  br label %for.inc11, !dbg !71

for.inc11:                                        ; preds = %for.body5
  %16 = load i32, i32* %i, align 4, !dbg !73
  %inc12 = add nsw i32 %16, 1, !dbg !73
  store i32 %inc12, i32* %i, align 4, !dbg !73
  br label %for.cond3, !dbg !74, !llvm.loop !75

for.end13:                                        ; preds = %for.cond3
  store i32 0, i32* %retval, align 4, !dbg !77
  %17 = load i8*, i8** %saved_stack, align 8, !dbg !78
  call void @llvm.stackrestore(i8* %17), !dbg !78
  %18 = load i32, i32* %retval, align 4, !dbg !78
  ret i32 %18, !dbg !78
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
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/034")
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
!30 = !DILocation(line: 59, column: 9, scope: !7)
!31 = !DILocation(line: 59, column: 3, scope: !7)
!32 = !DILocalVariable(name: "__vla_expr0", scope: !7, type: !33, flags: DIFlagArtificial)
!33 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!34 = !DILocation(line: 0, scope: !7)
!35 = !DILocalVariable(name: "a", scope: !7, file: !1, line: 59, type: !36)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, elements: !37)
!37 = !{!38}
!38 = !DISubrange(count: !32)
!39 = !DILocation(line: 59, column: 7, scope: !7)
!40 = !DILocation(line: 61, column: 9, scope: !41)
!41 = distinct !DILexicalBlock(scope: !7, file: !1, line: 61, column: 3)
!42 = !DILocation(line: 61, column: 8, scope: !41)
!43 = !DILocation(line: 61, column: 13, scope: !44)
!44 = distinct !DILexicalBlock(scope: !41, file: !1, line: 61, column: 3)
!45 = !DILocation(line: 61, column: 15, scope: !44)
!46 = !DILocation(line: 61, column: 14, scope: !44)
!47 = !DILocation(line: 61, column: 3, scope: !41)
!48 = !DILocation(line: 62, column: 10, scope: !44)
!49 = !DILocation(line: 62, column: 7, scope: !44)
!50 = !DILocation(line: 62, column: 5, scope: !44)
!51 = !DILocation(line: 62, column: 9, scope: !44)
!52 = !DILocation(line: 61, column: 21, scope: !44)
!53 = !DILocation(line: 61, column: 3, scope: !44)
!54 = distinct !{!54, !47, !55}
!55 = !DILocation(line: 62, column: 10, scope: !41)
!56 = !DILocation(line: 65, column: 9, scope: !57)
!57 = distinct !DILexicalBlock(scope: !7, file: !1, line: 65, column: 3)
!58 = !DILocation(line: 65, column: 8, scope: !57)
!59 = !DILocation(line: 65, column: 12, scope: !60)
!60 = distinct !DILexicalBlock(scope: !57, file: !1, line: 65, column: 3)
!61 = !DILocation(line: 65, column: 14, scope: !60)
!62 = !DILocation(line: 65, column: 17, scope: !60)
!63 = !DILocation(line: 65, column: 13, scope: !60)
!64 = !DILocation(line: 65, column: 3, scope: !57)
!65 = !DILocation(line: 66, column: 16, scope: !60)
!66 = !DILocation(line: 66, column: 14, scope: !60)
!67 = !DILocation(line: 66, column: 18, scope: !60)
!68 = !DILocation(line: 66, column: 9, scope: !60)
!69 = !DILocation(line: 66, column: 8, scope: !60)
!70 = !DILocation(line: 66, column: 10, scope: !60)
!71 = !DILocation(line: 66, column: 5, scope: !60)
!72 = !DILocation(line: 66, column: 13, scope: !60)
!73 = !DILocation(line: 65, column: 21, scope: !60)
!74 = !DILocation(line: 65, column: 3, scope: !60)
!75 = distinct !{!75, !64, !76}
!76 = !DILocation(line: 66, column: 19, scope: !57)
!77 = !DILocation(line: 68, column: 3, scope: !7)
!78 = !DILocation(line: 69, column: 1, scope: !7)
