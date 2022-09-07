; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !10 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %A = alloca i32*, align 8
  %N = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !16, metadata !DIExpression()), !dbg !17
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32** %A, metadata !20, metadata !DIExpression()), !dbg !21
  call void @llvm.dbg.declare(metadata i32* %N, metadata !22, metadata !DIExpression()), !dbg !23
  store i32 100, i32* %N, align 4, !dbg !23
  %0 = load i32, i32* %N, align 4, !dbg !24
  %conv = sext i32 %0 to i64, !dbg !24
  %mul = mul i64 4, %conv, !dbg !25
  %call = call noalias i8* @malloc(i64 %mul) #3, !dbg !26
  %1 = bitcast i8* %call to i32*, !dbg !27
  store i32* %1, i32** %A, align 8, !dbg !28
  call void @llvm.dbg.declare(metadata i32* %i, metadata !29, metadata !DIExpression()), !dbg !31
  store i32 0, i32* %i, align 4, !dbg !31
  br label %for.cond, !dbg !32

for.cond:                                         ; preds = %for.inc, %entry
  %2 = load i32, i32* %i, align 4, !dbg !33
  %3 = load i32, i32* %N, align 4, !dbg !35
  %cmp = icmp slt i32 %2, %3, !dbg !36
  br i1 %cmp, label %for.body, label %for.end, !dbg !37

for.body:                                         ; preds = %for.cond
  %4 = load i32, i32* %i, align 4, !dbg !38
  %5 = load i32*, i32** %A, align 8, !dbg !40
  %6 = load i32, i32* %i, align 4, !dbg !41
  %idxprom = sext i32 %6 to i64, !dbg !40
  %arrayidx = getelementptr inbounds i32, i32* %5, i64 %idxprom, !dbg !40
  store i32 %4, i32* %arrayidx, align 4, !dbg !42
  %7 = load i32, i32* %i, align 4, !dbg !43
  %cmp2 = icmp eq i32 %7, 1, !dbg !45
  br i1 %cmp2, label %if.then, label %if.end, !dbg !46

if.then:                                          ; preds = %for.body
  %8 = load i32*, i32** %A, align 8, !dbg !47
  %arrayidx4 = getelementptr inbounds i32, i32* %8, i64 0, !dbg !47
  store i32 1, i32* %arrayidx4, align 4, !dbg !49
  br label %if.end, !dbg !50

if.end:                                           ; preds = %if.then, %for.body
  br label %for.inc, !dbg !51

for.inc:                                          ; preds = %if.end
  %9 = load i32, i32* %i, align 4, !dbg !52
  %inc = add nsw i32 %9, 1, !dbg !52
  store i32 %inc, i32* %i, align 4, !dbg !52
  br label %for.cond, !dbg !53, !llvm.loop !54

for.end:                                          ; preds = %for.cond
  %10 = load i32*, i32** %A, align 8, !dbg !56
  %11 = bitcast i32* %10 to i8*, !dbg !56
  call void @free(i8* %11) #3, !dbg !57
  ret i32 0, !dbg !58
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64) #2

; Function Attrs: nounwind
declare dso_local void @free(i8*) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!6, !7, !8}
!llvm.ident = !{!9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/179")
!2 = !{}
!3 = !{!4}
!4 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!5 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!6 = !{i32 7, !"Dwarf Version", i32 4}
!7 = !{i32 2, !"Debug Info Version", i32 3}
!8 = !{i32 1, !"wchar_size", i32 4}
!9 = !{!"Ubuntu clang version 11.1.0-6"}
!10 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 21, type: !11, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!11 = !DISubroutineType(types: !12)
!12 = !{!5, !5, !13}
!13 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!15 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!16 = !DILocalVariable(name: "argc", arg: 1, scope: !10, file: !1, line: 21, type: !5)
!17 = !DILocation(line: 21, column: 14, scope: !10)
!18 = !DILocalVariable(name: "argv", arg: 2, scope: !10, file: !1, line: 21, type: !13)
!19 = !DILocation(line: 21, column: 26, scope: !10)
!20 = !DILocalVariable(name: "A", scope: !10, file: !1, line: 23, type: !4)
!21 = !DILocation(line: 23, column: 8, scope: !10)
!22 = !DILocalVariable(name: "N", scope: !10, file: !1, line: 24, type: !5)
!23 = !DILocation(line: 24, column: 7, scope: !10)
!24 = !DILocation(line: 26, column: 35, scope: !10)
!25 = !DILocation(line: 26, column: 33, scope: !10)
!26 = !DILocation(line: 26, column: 14, scope: !10)
!27 = !DILocation(line: 26, column: 7, scope: !10)
!28 = !DILocation(line: 26, column: 5, scope: !10)
!29 = !DILocalVariable(name: "i", scope: !30, file: !1, line: 30, type: !5)
!30 = distinct !DILexicalBlock(scope: !10, file: !1, line: 30, column: 3)
!31 = !DILocation(line: 30, column: 11, scope: !30)
!32 = !DILocation(line: 30, column: 7, scope: !30)
!33 = !DILocation(line: 30, column: 18, scope: !34)
!34 = distinct !DILexicalBlock(scope: !30, file: !1, line: 30, column: 3)
!35 = !DILocation(line: 30, column: 22, scope: !34)
!36 = !DILocation(line: 30, column: 20, scope: !34)
!37 = !DILocation(line: 30, column: 3, scope: !30)
!38 = !DILocation(line: 31, column: 12, scope: !39)
!39 = distinct !DILexicalBlock(scope: !34, file: !1, line: 30, column: 30)
!40 = !DILocation(line: 31, column: 5, scope: !39)
!41 = !DILocation(line: 31, column: 7, scope: !39)
!42 = !DILocation(line: 31, column: 10, scope: !39)
!43 = !DILocation(line: 32, column: 9, scope: !44)
!44 = distinct !DILexicalBlock(scope: !39, file: !1, line: 32, column: 9)
!45 = !DILocation(line: 32, column: 11, scope: !44)
!46 = !DILocation(line: 32, column: 9, scope: !39)
!47 = !DILocation(line: 34, column: 7, scope: !48)
!48 = distinct !DILexicalBlock(scope: !44, file: !1, line: 33, column: 5)
!49 = !DILocation(line: 34, column: 12, scope: !48)
!50 = !DILocation(line: 35, column: 5, scope: !48)
!51 = !DILocation(line: 36, column: 3, scope: !39)
!52 = !DILocation(line: 30, column: 26, scope: !34)
!53 = !DILocation(line: 30, column: 3, scope: !34)
!54 = distinct !{!54, !37, !55}
!55 = !DILocation(line: 36, column: 3, scope: !30)
!56 = !DILocation(line: 38, column: 8, scope: !10)
!57 = !DILocation(line: 38, column: 3, scope: !10)
!58 = !DILocation(line: 39, column: 3, scope: !10)
