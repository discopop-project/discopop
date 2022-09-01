; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @load_from_input(i32* %data, i32 %size) #0 !dbg !10 {
entry:
  %data.addr = alloca i32*, align 8
  %size.addr = alloca i32, align 4
  %i = alloca i32, align 4
  store i32* %data, i32** %data.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %data.addr, metadata !13, metadata !DIExpression()), !dbg !14
  store i32 %size, i32* %size.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %size.addr, metadata !15, metadata !DIExpression()), !dbg !16
  call void @llvm.dbg.declare(metadata i32* %i, metadata !17, metadata !DIExpression()), !dbg !19
  store i32 0, i32* %i, align 4, !dbg !19
  br label %for.cond, !dbg !20

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !21
  %1 = load i32, i32* %size.addr, align 4, !dbg !23
  %cmp = icmp slt i32 %0, %1, !dbg !24
  br i1 %cmp, label %for.body, label %for.end, !dbg !25

for.body:                                         ; preds = %for.cond
  %2 = load i32, i32* %size.addr, align 4, !dbg !26
  %3 = load i32, i32* %i, align 4, !dbg !28
  %sub = sub nsw i32 %2, %3, !dbg !29
  %4 = load i32*, i32** %data.addr, align 8, !dbg !30
  %5 = load i32, i32* %i, align 4, !dbg !31
  %idxprom = sext i32 %5 to i64, !dbg !30
  %arrayidx = getelementptr inbounds i32, i32* %4, i64 %idxprom, !dbg !30
  store i32 %sub, i32* %arrayidx, align 4, !dbg !32
  br label %for.inc, !dbg !33

for.inc:                                          ; preds = %for.body
  %6 = load i32, i32* %i, align 4, !dbg !34
  %inc = add nsw i32 %6, 1, !dbg !34
  store i32 %inc, i32* %i, align 4, !dbg !34
  br label %for.cond, !dbg !35, !llvm.loop !36

for.end:                                          ; preds = %for.cond
  ret void, !dbg !38
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !39 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %A = alloca i32*, align 8
  %N = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !45, metadata !DIExpression()), !dbg !46
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !47, metadata !DIExpression()), !dbg !48
  call void @llvm.dbg.declare(metadata i32** %A, metadata !49, metadata !DIExpression()), !dbg !50
  call void @llvm.dbg.declare(metadata i32* %N, metadata !51, metadata !DIExpression()), !dbg !52
  store i32 100, i32* %N, align 4, !dbg !52
  %0 = load i32, i32* %argc.addr, align 4, !dbg !53
  %cmp = icmp sgt i32 %0, 1, !dbg !55
  br i1 %cmp, label %if.then, label %if.end, !dbg !56

if.then:                                          ; preds = %entry
  %1 = load i8**, i8*** %argv.addr, align 8, !dbg !57
  %arrayidx = getelementptr inbounds i8*, i8** %1, i64 1, !dbg !57
  %2 = load i8*, i8** %arrayidx, align 8, !dbg !57
  %call = call i32 @atoi(i8* %2) #4, !dbg !58
  store i32 %call, i32* %N, align 4, !dbg !59
  br label %if.end, !dbg !60

if.end:                                           ; preds = %if.then, %entry
  %3 = load i32, i32* %N, align 4, !dbg !61
  %conv = sext i32 %3 to i64, !dbg !61
  %mul = mul i64 4, %conv, !dbg !62
  %call1 = call noalias i8* @malloc(i64 %mul) #5, !dbg !63
  %4 = bitcast i8* %call1 to i32*, !dbg !64
  store i32* %4, i32** %A, align 8, !dbg !65
  %5 = load i32*, i32** %A, align 8, !dbg !66
  %6 = load i32, i32* %N, align 4, !dbg !67
  call void @load_from_input(i32* %5, i32 %6), !dbg !68
  call void @llvm.dbg.declare(metadata i32* %i, metadata !69, metadata !DIExpression()), !dbg !71
  store i32 0, i32* %i, align 4, !dbg !71
  br label %for.cond, !dbg !72

for.cond:                                         ; preds = %for.inc, %if.end
  %7 = load i32, i32* %i, align 4, !dbg !73
  %8 = load i32, i32* %N, align 4, !dbg !75
  %cmp2 = icmp slt i32 %7, %8, !dbg !76
  br i1 %cmp2, label %for.body, label %for.end, !dbg !77

for.body:                                         ; preds = %for.cond
  %9 = load i32, i32* %i, align 4, !dbg !78
  %10 = load i32*, i32** %A, align 8, !dbg !80
  %11 = load i32, i32* %i, align 4, !dbg !81
  %idxprom = sext i32 %11 to i64, !dbg !80
  %arrayidx4 = getelementptr inbounds i32, i32* %10, i64 %idxprom, !dbg !80
  store i32 %9, i32* %arrayidx4, align 4, !dbg !82
  %12 = load i32, i32* %N, align 4, !dbg !83
  %cmp5 = icmp sgt i32 %12, 10000, !dbg !85
  br i1 %cmp5, label %if.then7, label %if.end9, !dbg !86

if.then7:                                         ; preds = %for.body
  %13 = load i32*, i32** %A, align 8, !dbg !87
  %arrayidx8 = getelementptr inbounds i32, i32* %13, i64 0, !dbg !87
  store i32 1, i32* %arrayidx8, align 4, !dbg !89
  br label %if.end9, !dbg !90

if.end9:                                          ; preds = %if.then7, %for.body
  br label %for.inc, !dbg !91

for.inc:                                          ; preds = %if.end9
  %14 = load i32, i32* %i, align 4, !dbg !92
  %inc = add nsw i32 %14, 1, !dbg !92
  store i32 %inc, i32* %i, align 4, !dbg !92
  br label %for.cond, !dbg !93, !llvm.loop !94

for.end:                                          ; preds = %for.cond
  %15 = load i32*, i32** %A, align 8, !dbg !96
  %16 = bitcast i32* %15 to i8*, !dbg !96
  call void @free(i8* %16) #5, !dbg !97
  ret i32 0, !dbg !98
}

; Function Attrs: nounwind readonly
declare dso_local i32 @atoi(i8*) #2

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64) #3

; Function Attrs: nounwind
declare dso_local void @free(i8*) #3

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind readonly }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!6, !7, !8}
!llvm.ident = !{!9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/178")
!2 = !{}
!3 = !{!4}
!4 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!5 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!6 = !{i32 7, !"Dwarf Version", i32 4}
!7 = !{i32 2, !"Debug Info Version", i32 3}
!8 = !{i32 1, !"wchar_size", i32 4}
!9 = !{!"Ubuntu clang version 11.1.0-6"}
!10 = distinct !DISubprogram(name: "load_from_input", scope: !1, file: !1, line: 20, type: !11, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!11 = !DISubroutineType(types: !12)
!12 = !{null, !4, !5}
!13 = !DILocalVariable(name: "data", arg: 1, scope: !10, file: !1, line: 20, type: !4)
!14 = !DILocation(line: 20, column: 27, scope: !10)
!15 = !DILocalVariable(name: "size", arg: 2, scope: !10, file: !1, line: 20, type: !5)
!16 = !DILocation(line: 20, column: 37, scope: !10)
!17 = !DILocalVariable(name: "i", scope: !18, file: !1, line: 22, type: !5)
!18 = distinct !DILexicalBlock(scope: !10, file: !1, line: 22, column: 3)
!19 = !DILocation(line: 22, column: 11, scope: !18)
!20 = !DILocation(line: 22, column: 7, scope: !18)
!21 = !DILocation(line: 22, column: 18, scope: !22)
!22 = distinct !DILexicalBlock(scope: !18, file: !1, line: 22, column: 3)
!23 = !DILocation(line: 22, column: 22, scope: !22)
!24 = !DILocation(line: 22, column: 20, scope: !22)
!25 = !DILocation(line: 22, column: 3, scope: !18)
!26 = !DILocation(line: 23, column: 15, scope: !27)
!27 = distinct !DILexicalBlock(scope: !22, file: !1, line: 22, column: 33)
!28 = !DILocation(line: 23, column: 20, scope: !27)
!29 = !DILocation(line: 23, column: 19, scope: !27)
!30 = !DILocation(line: 23, column: 5, scope: !27)
!31 = !DILocation(line: 23, column: 10, scope: !27)
!32 = !DILocation(line: 23, column: 13, scope: !27)
!33 = !DILocation(line: 24, column: 3, scope: !27)
!34 = !DILocation(line: 22, column: 29, scope: !22)
!35 = !DILocation(line: 22, column: 3, scope: !22)
!36 = distinct !{!36, !25, !37}
!37 = !DILocation(line: 24, column: 3, scope: !18)
!38 = !DILocation(line: 25, column: 1, scope: !10)
!39 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 28, type: !40, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!40 = !DISubroutineType(types: !41)
!41 = !{!5, !5, !42}
!42 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !43, size: 64)
!43 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 64)
!44 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!45 = !DILocalVariable(name: "argc", arg: 1, scope: !39, file: !1, line: 28, type: !5)
!46 = !DILocation(line: 28, column: 14, scope: !39)
!47 = !DILocalVariable(name: "argv", arg: 2, scope: !39, file: !1, line: 28, type: !42)
!48 = !DILocation(line: 28, column: 26, scope: !39)
!49 = !DILocalVariable(name: "A", scope: !39, file: !1, line: 30, type: !4)
!50 = !DILocation(line: 30, column: 8, scope: !39)
!51 = !DILocalVariable(name: "N", scope: !39, file: !1, line: 31, type: !5)
!52 = !DILocation(line: 31, column: 7, scope: !39)
!53 = !DILocation(line: 33, column: 7, scope: !54)
!54 = distinct !DILexicalBlock(scope: !39, file: !1, line: 33, column: 7)
!55 = !DILocation(line: 33, column: 11, scope: !54)
!56 = !DILocation(line: 33, column: 7, scope: !39)
!57 = !DILocation(line: 34, column: 14, scope: !54)
!58 = !DILocation(line: 34, column: 9, scope: !54)
!59 = !DILocation(line: 34, column: 7, scope: !54)
!60 = !DILocation(line: 34, column: 5, scope: !54)
!61 = !DILocation(line: 36, column: 35, scope: !39)
!62 = !DILocation(line: 36, column: 33, scope: !39)
!63 = !DILocation(line: 36, column: 14, scope: !39)
!64 = !DILocation(line: 36, column: 7, scope: !39)
!65 = !DILocation(line: 36, column: 5, scope: !39)
!66 = !DILocation(line: 38, column: 19, scope: !39)
!67 = !DILocation(line: 38, column: 22, scope: !39)
!68 = !DILocation(line: 38, column: 3, scope: !39)
!69 = !DILocalVariable(name: "i", scope: !70, file: !1, line: 41, type: !5)
!70 = distinct !DILexicalBlock(scope: !39, file: !1, line: 41, column: 3)
!71 = !DILocation(line: 41, column: 11, scope: !70)
!72 = !DILocation(line: 41, column: 7, scope: !70)
!73 = !DILocation(line: 41, column: 18, scope: !74)
!74 = distinct !DILexicalBlock(scope: !70, file: !1, line: 41, column: 3)
!75 = !DILocation(line: 41, column: 22, scope: !74)
!76 = !DILocation(line: 41, column: 20, scope: !74)
!77 = !DILocation(line: 41, column: 3, scope: !70)
!78 = !DILocation(line: 42, column: 12, scope: !79)
!79 = distinct !DILexicalBlock(scope: !74, file: !1, line: 41, column: 30)
!80 = !DILocation(line: 42, column: 5, scope: !79)
!81 = !DILocation(line: 42, column: 7, scope: !79)
!82 = !DILocation(line: 42, column: 10, scope: !79)
!83 = !DILocation(line: 43, column: 9, scope: !84)
!84 = distinct !DILexicalBlock(scope: !79, file: !1, line: 43, column: 9)
!85 = !DILocation(line: 43, column: 11, scope: !84)
!86 = !DILocation(line: 43, column: 9, scope: !79)
!87 = !DILocation(line: 45, column: 7, scope: !88)
!88 = distinct !DILexicalBlock(scope: !84, file: !1, line: 44, column: 5)
!89 = !DILocation(line: 45, column: 12, scope: !88)
!90 = !DILocation(line: 46, column: 5, scope: !88)
!91 = !DILocation(line: 47, column: 3, scope: !79)
!92 = !DILocation(line: 41, column: 26, scope: !74)
!93 = !DILocation(line: 41, column: 3, scope: !74)
!94 = distinct !{!94, !77, !95}
!95 = !DILocation(line: 47, column: 3, scope: !70)
!96 = !DILocation(line: 49, column: 8, scope: !39)
!97 = !DILocation(line: 49, column: 3, scope: !39)
!98 = !DILocation(line: 50, column: 3, scope: !39)
