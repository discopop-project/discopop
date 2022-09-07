; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [14 x i8] c"output[0]=%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !7 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %inLen = alloca i32, align 4
  %outLen = alloca i32, align 4
  %saved_stack = alloca i8*, align 8
  %__vla_expr0 = alloca i64, align 8
  %__vla_expr1 = alloca i64, align 8
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !14, metadata !DIExpression()), !dbg !15
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !16, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.declare(metadata i32* %i, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32* %inLen, metadata !20, metadata !DIExpression()), !dbg !21
  store i32 1000, i32* %inLen, align 4, !dbg !21
  call void @llvm.dbg.declare(metadata i32* %outLen, metadata !22, metadata !DIExpression()), !dbg !23
  store i32 0, i32* %outLen, align 4, !dbg !23
  %0 = load i32, i32* %argc.addr, align 4, !dbg !24
  %cmp = icmp sgt i32 %0, 1, !dbg !26
  br i1 %cmp, label %if.then, label %if.end, !dbg !27

if.then:                                          ; preds = %entry
  %1 = load i8**, i8*** %argv.addr, align 8, !dbg !28
  %arrayidx = getelementptr inbounds i8*, i8** %1, i64 1, !dbg !28
  %2 = load i8*, i8** %arrayidx, align 8, !dbg !28
  %call = call i32 @atoi(i8* %2) #5, !dbg !29
  store i32 %call, i32* %inLen, align 4, !dbg !30
  br label %if.end, !dbg !31

if.end:                                           ; preds = %if.then, %entry
  %3 = load i32, i32* %inLen, align 4, !dbg !32
  %4 = zext i32 %3 to i64, !dbg !33
  %5 = call i8* @llvm.stacksave(), !dbg !33
  store i8* %5, i8** %saved_stack, align 8, !dbg !33
  %vla = alloca i32, i64 %4, align 16, !dbg !33
  store i64 %4, i64* %__vla_expr0, align 8, !dbg !33
  call void @llvm.dbg.declare(metadata i64* %__vla_expr0, metadata !34, metadata !DIExpression()), !dbg !36
  call void @llvm.dbg.declare(metadata i32* %vla, metadata !37, metadata !DIExpression()), !dbg !41
  %6 = load i32, i32* %inLen, align 4, !dbg !42
  %7 = zext i32 %6 to i64, !dbg !43
  %vla1 = alloca i32, i64 %7, align 16, !dbg !43
  store i64 %7, i64* %__vla_expr1, align 8, !dbg !43
  call void @llvm.dbg.declare(metadata i64* %__vla_expr1, metadata !44, metadata !DIExpression()), !dbg !36
  call void @llvm.dbg.declare(metadata i32* %vla1, metadata !45, metadata !DIExpression()), !dbg !49
  store i32 0, i32* %i, align 4, !dbg !50
  br label %for.cond, !dbg !52

for.cond:                                         ; preds = %for.inc, %if.end
  %8 = load i32, i32* %i, align 4, !dbg !53
  %9 = load i32, i32* %inLen, align 4, !dbg !55
  %cmp2 = icmp slt i32 %8, %9, !dbg !56
  br i1 %cmp2, label %for.body, label %for.end, !dbg !57

for.body:                                         ; preds = %for.cond
  %10 = load i32, i32* %i, align 4, !dbg !58
  %11 = load i32, i32* %i, align 4, !dbg !59
  %idxprom = sext i32 %11 to i64, !dbg !60
  %arrayidx3 = getelementptr inbounds i32, i32* %vla, i64 %idxprom, !dbg !60
  store i32 %10, i32* %arrayidx3, align 4, !dbg !61
  br label %for.inc, !dbg !60

for.inc:                                          ; preds = %for.body
  %12 = load i32, i32* %i, align 4, !dbg !62
  %inc = add nsw i32 %12, 1, !dbg !62
  store i32 %inc, i32* %i, align 4, !dbg !62
  br label %for.cond, !dbg !63, !llvm.loop !64

for.end:                                          ; preds = %for.cond
  store i32 0, i32* %i, align 4, !dbg !66
  br label %for.cond4, !dbg !68

for.cond4:                                        ; preds = %for.inc12, %for.end
  %13 = load i32, i32* %i, align 4, !dbg !69
  %14 = load i32, i32* %inLen, align 4, !dbg !71
  %cmp5 = icmp slt i32 %13, %14, !dbg !72
  br i1 %cmp5, label %for.body6, label %for.end14, !dbg !73

for.body6:                                        ; preds = %for.cond4
  %15 = load i32, i32* %i, align 4, !dbg !74
  %idxprom7 = sext i32 %15 to i64, !dbg !76
  %arrayidx8 = getelementptr inbounds i32, i32* %vla, i64 %idxprom7, !dbg !76
  %16 = load i32, i32* %arrayidx8, align 4, !dbg !76
  %17 = load i32, i32* %outLen, align 4, !dbg !77
  %inc9 = add nsw i32 %17, 1, !dbg !77
  store i32 %inc9, i32* %outLen, align 4, !dbg !77
  %idxprom10 = sext i32 %17 to i64, !dbg !78
  %arrayidx11 = getelementptr inbounds i32, i32* %vla1, i64 %idxprom10, !dbg !78
  store i32 %16, i32* %arrayidx11, align 4, !dbg !79
  br label %for.inc12, !dbg !80

for.inc12:                                        ; preds = %for.body6
  %18 = load i32, i32* %i, align 4, !dbg !81
  %inc13 = add nsw i32 %18, 1, !dbg !81
  store i32 %inc13, i32* %i, align 4, !dbg !81
  br label %for.cond4, !dbg !82, !llvm.loop !83

for.end14:                                        ; preds = %for.cond4
  %arrayidx15 = getelementptr inbounds i32, i32* %vla1, i64 0, !dbg !85
  %19 = load i32, i32* %arrayidx15, align 16, !dbg !85
  %call16 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str, i64 0, i64 0), i32 %19), !dbg !86
  store i32 0, i32* %retval, align 4, !dbg !87
  %20 = load i8*, i8** %saved_stack, align 8, !dbg !88
  call void @llvm.stackrestore(i8* %20), !dbg !88
  %21 = load i32, i32* %retval, align 4, !dbg !88
  ret i32 %21, !dbg !88
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind readonly
declare dso_local i32 @atoi(i8*) #2

; Function Attrs: nounwind
declare i8* @llvm.stacksave() #3

declare dso_local i32 @printf(i8*, ...) #4

; Function Attrs: nounwind
declare void @llvm.stackrestore(i8*) #3

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }
attributes #4 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind readonly }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/019")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"Ubuntu clang version 11.1.0-6"}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 56, type: !8, scopeLine: 57, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10, !10, !11}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!13 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!14 = !DILocalVariable(name: "argc", arg: 1, scope: !7, file: !1, line: 56, type: !10)
!15 = !DILocation(line: 56, column: 14, scope: !7)
!16 = !DILocalVariable(name: "argv", arg: 2, scope: !7, file: !1, line: 56, type: !11)
!17 = !DILocation(line: 56, column: 26, scope: !7)
!18 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 58, type: !10)
!19 = !DILocation(line: 58, column: 7, scope: !7)
!20 = !DILocalVariable(name: "inLen", scope: !7, file: !1, line: 59, type: !10)
!21 = !DILocation(line: 59, column: 7, scope: !7)
!22 = !DILocalVariable(name: "outLen", scope: !7, file: !1, line: 60, type: !10)
!23 = !DILocation(line: 60, column: 7, scope: !7)
!24 = !DILocation(line: 62, column: 7, scope: !25)
!25 = distinct !DILexicalBlock(scope: !7, file: !1, line: 62, column: 7)
!26 = !DILocation(line: 62, column: 11, scope: !25)
!27 = !DILocation(line: 62, column: 7, scope: !7)
!28 = !DILocation(line: 63, column: 17, scope: !25)
!29 = !DILocation(line: 63, column: 12, scope: !25)
!30 = !DILocation(line: 63, column: 10, scope: !25)
!31 = !DILocation(line: 63, column: 5, scope: !25)
!32 = !DILocation(line: 65, column: 13, scope: !7)
!33 = !DILocation(line: 65, column: 3, scope: !7)
!34 = !DILocalVariable(name: "__vla_expr0", scope: !7, type: !35, flags: DIFlagArtificial)
!35 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!36 = !DILocation(line: 0, scope: !7)
!37 = !DILocalVariable(name: "input", scope: !7, file: !1, line: 65, type: !38)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, elements: !39)
!39 = !{!40}
!40 = !DISubrange(count: !34)
!41 = !DILocation(line: 65, column: 7, scope: !7)
!42 = !DILocation(line: 66, column: 14, scope: !7)
!43 = !DILocation(line: 66, column: 3, scope: !7)
!44 = !DILocalVariable(name: "__vla_expr1", scope: !7, type: !35, flags: DIFlagArtificial)
!45 = !DILocalVariable(name: "output", scope: !7, file: !1, line: 66, type: !46)
!46 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, elements: !47)
!47 = !{!48}
!48 = !DISubrange(count: !44)
!49 = !DILocation(line: 66, column: 7, scope: !7)
!50 = !DILocation(line: 67, column: 9, scope: !51)
!51 = distinct !DILexicalBlock(scope: !7, file: !1, line: 67, column: 3)
!52 = !DILocation(line: 67, column: 8, scope: !51)
!53 = !DILocation(line: 67, column: 13, scope: !54)
!54 = distinct !DILexicalBlock(scope: !51, file: !1, line: 67, column: 3)
!55 = !DILocation(line: 67, column: 15, scope: !54)
!56 = !DILocation(line: 67, column: 14, scope: !54)
!57 = !DILocation(line: 67, column: 3, scope: !51)
!58 = !DILocation(line: 68, column: 14, scope: !54)
!59 = !DILocation(line: 68, column: 11, scope: !54)
!60 = !DILocation(line: 68, column: 5, scope: !54)
!61 = !DILocation(line: 68, column: 13, scope: !54)
!62 = !DILocation(line: 67, column: 22, scope: !54)
!63 = !DILocation(line: 67, column: 3, scope: !54)
!64 = distinct !{!64, !57, !65}
!65 = !DILocation(line: 68, column: 14, scope: !51)
!66 = !DILocation(line: 71, column: 9, scope: !67)
!67 = distinct !DILexicalBlock(scope: !7, file: !1, line: 71, column: 3)
!68 = !DILocation(line: 71, column: 8, scope: !67)
!69 = !DILocation(line: 71, column: 13, scope: !70)
!70 = distinct !DILexicalBlock(scope: !67, file: !1, line: 71, column: 3)
!71 = !DILocation(line: 71, column: 15, scope: !70)
!72 = !DILocation(line: 71, column: 14, scope: !70)
!73 = !DILocation(line: 71, column: 3, scope: !67)
!74 = !DILocation(line: 72, column: 30, scope: !75)
!75 = distinct !DILexicalBlock(scope: !70, file: !1, line: 71, column: 27)
!76 = !DILocation(line: 72, column: 24, scope: !75)
!77 = !DILocation(line: 72, column: 18, scope: !75)
!78 = !DILocation(line: 72, column: 5, scope: !75)
!79 = !DILocation(line: 72, column: 22, scope: !75)
!80 = !DILocation(line: 73, column: 3, scope: !75)
!81 = !DILocation(line: 71, column: 22, scope: !70)
!82 = !DILocation(line: 71, column: 3, scope: !70)
!83 = distinct !{!83, !73, !84}
!84 = !DILocation(line: 73, column: 3, scope: !67)
!85 = !DILocation(line: 75, column: 28, scope: !7)
!86 = !DILocation(line: 75, column: 3, scope: !7)
!87 = !DILocation(line: 76, column: 3, scope: !7)
!88 = !DILocation(line: 77, column: 1, scope: !7)
