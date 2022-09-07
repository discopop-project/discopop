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
  %j = alloca i32, align 4
  %len = alloca i32, align 4
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %saved_stack = alloca i8*, align 8
  %__vla_expr0 = alloca i64, align 8
  %__vla_expr1 = alloca i64, align 8
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !14, metadata !DIExpression()), !dbg !15
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !16, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.declare(metadata i32* %i, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32* %j, metadata !20, metadata !DIExpression()), !dbg !21
  call void @llvm.dbg.declare(metadata i32* %len, metadata !22, metadata !DIExpression()), !dbg !23
  store i32 1000, i32* %len, align 4, !dbg !23
  %0 = load i32, i32* %argc.addr, align 4, !dbg !24
  %cmp = icmp sgt i32 %0, 1, !dbg !26
  br i1 %cmp, label %if.then, label %if.end, !dbg !27

if.then:                                          ; preds = %entry
  %1 = load i8**, i8*** %argv.addr, align 8, !dbg !28
  %arrayidx = getelementptr inbounds i8*, i8** %1, i64 1, !dbg !28
  %2 = load i8*, i8** %arrayidx, align 8, !dbg !28
  %call = call i32 @atoi(i8* %2) #4, !dbg !29
  store i32 %call, i32* %len, align 4, !dbg !30
  br label %if.end, !dbg !31

if.end:                                           ; preds = %if.then, %entry
  call void @llvm.dbg.declare(metadata i32* %n, metadata !32, metadata !DIExpression()), !dbg !33
  %3 = load i32, i32* %len, align 4, !dbg !34
  store i32 %3, i32* %n, align 4, !dbg !33
  call void @llvm.dbg.declare(metadata i32* %m, metadata !35, metadata !DIExpression()), !dbg !36
  %4 = load i32, i32* %len, align 4, !dbg !37
  store i32 %4, i32* %m, align 4, !dbg !36
  %5 = load i32, i32* %n, align 4, !dbg !38
  %6 = zext i32 %5 to i64, !dbg !39
  %7 = load i32, i32* %m, align 4, !dbg !40
  %8 = zext i32 %7 to i64, !dbg !39
  %9 = call i8* @llvm.stacksave(), !dbg !39
  store i8* %9, i8** %saved_stack, align 8, !dbg !39
  %10 = mul nuw i64 %6, %8, !dbg !39
  %vla = alloca double, i64 %10, align 16, !dbg !39
  store i64 %6, i64* %__vla_expr0, align 8, !dbg !39
  store i64 %8, i64* %__vla_expr1, align 8, !dbg !39
  call void @llvm.dbg.declare(metadata i64* %__vla_expr0, metadata !41, metadata !DIExpression()), !dbg !43
  call void @llvm.dbg.declare(metadata i64* %__vla_expr1, metadata !44, metadata !DIExpression()), !dbg !43
  call void @llvm.dbg.declare(metadata double* %vla, metadata !45, metadata !DIExpression()), !dbg !51
  store i32 0, i32* %i, align 4, !dbg !52
  br label %for.cond, !dbg !54

for.cond:                                         ; preds = %for.inc12, %if.end
  %11 = load i32, i32* %i, align 4, !dbg !55
  %12 = load i32, i32* %n, align 4, !dbg !57
  %cmp1 = icmp slt i32 %11, %12, !dbg !58
  br i1 %cmp1, label %for.body, label %for.end14, !dbg !59

for.body:                                         ; preds = %for.cond
  store i32 1, i32* %j, align 4, !dbg !60
  br label %for.cond2, !dbg !62

for.cond2:                                        ; preds = %for.inc, %for.body
  %13 = load i32, i32* %j, align 4, !dbg !63
  %14 = load i32, i32* %m, align 4, !dbg !65
  %cmp3 = icmp slt i32 %13, %14, !dbg !66
  br i1 %cmp3, label %for.body4, label %for.end, !dbg !67

for.body4:                                        ; preds = %for.cond2
  %15 = load i32, i32* %i, align 4, !dbg !68
  %idxprom = sext i32 %15 to i64, !dbg !69
  %16 = mul nsw i64 %idxprom, %8, !dbg !69
  %arrayidx5 = getelementptr inbounds double, double* %vla, i64 %16, !dbg !69
  %17 = load i32, i32* %j, align 4, !dbg !70
  %sub = sub nsw i32 %17, 1, !dbg !71
  %idxprom6 = sext i32 %sub to i64, !dbg !69
  %arrayidx7 = getelementptr inbounds double, double* %arrayidx5, i64 %idxprom6, !dbg !69
  %18 = load double, double* %arrayidx7, align 8, !dbg !69
  %19 = load i32, i32* %i, align 4, !dbg !72
  %idxprom8 = sext i32 %19 to i64, !dbg !73
  %20 = mul nsw i64 %idxprom8, %8, !dbg !73
  %arrayidx9 = getelementptr inbounds double, double* %vla, i64 %20, !dbg !73
  %21 = load i32, i32* %j, align 4, !dbg !74
  %idxprom10 = sext i32 %21 to i64, !dbg !73
  %arrayidx11 = getelementptr inbounds double, double* %arrayidx9, i64 %idxprom10, !dbg !73
  store double %18, double* %arrayidx11, align 8, !dbg !75
  br label %for.inc, !dbg !73

for.inc:                                          ; preds = %for.body4
  %22 = load i32, i32* %j, align 4, !dbg !76
  %inc = add nsw i32 %22, 1, !dbg !76
  store i32 %inc, i32* %j, align 4, !dbg !76
  br label %for.cond2, !dbg !77, !llvm.loop !78

for.end:                                          ; preds = %for.cond2
  br label %for.inc12, !dbg !79

for.inc12:                                        ; preds = %for.end
  %23 = load i32, i32* %i, align 4, !dbg !80
  %inc13 = add nsw i32 %23, 1, !dbg !80
  store i32 %inc13, i32* %i, align 4, !dbg !80
  br label %for.cond, !dbg !81, !llvm.loop !82

for.end14:                                        ; preds = %for.cond
  store i32 0, i32* %retval, align 4, !dbg !84
  %24 = load i8*, i8** %saved_stack, align 8, !dbg !85
  call void @llvm.stackrestore(i8* %24), !dbg !85
  %25 = load i32, i32* %retval, align 4, !dbg !85
  ret i32 %25, !dbg !85
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
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/038")
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
!20 = !DILocalVariable(name: "j", scope: !7, file: !1, line: 54, type: !10)
!21 = !DILocation(line: 54, column: 9, scope: !7)
!22 = !DILocalVariable(name: "len", scope: !7, file: !1, line: 55, type: !10)
!23 = !DILocation(line: 55, column: 7, scope: !7)
!24 = !DILocation(line: 56, column: 7, scope: !25)
!25 = distinct !DILexicalBlock(scope: !7, file: !1, line: 56, column: 7)
!26 = !DILocation(line: 56, column: 11, scope: !25)
!27 = !DILocation(line: 56, column: 7, scope: !7)
!28 = !DILocation(line: 57, column: 16, scope: !25)
!29 = !DILocation(line: 57, column: 11, scope: !25)
!30 = !DILocation(line: 57, column: 9, scope: !25)
!31 = !DILocation(line: 57, column: 5, scope: !25)
!32 = !DILocalVariable(name: "n", scope: !7, file: !1, line: 59, type: !10)
!33 = !DILocation(line: 59, column: 7, scope: !7)
!34 = !DILocation(line: 59, column: 9, scope: !7)
!35 = !DILocalVariable(name: "m", scope: !7, file: !1, line: 59, type: !10)
!36 = !DILocation(line: 59, column: 14, scope: !7)
!37 = !DILocation(line: 59, column: 16, scope: !7)
!38 = !DILocation(line: 60, column: 12, scope: !7)
!39 = !DILocation(line: 60, column: 3, scope: !7)
!40 = !DILocation(line: 60, column: 15, scope: !7)
!41 = !DILocalVariable(name: "__vla_expr0", scope: !7, type: !42, flags: DIFlagArtificial)
!42 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!43 = !DILocation(line: 0, scope: !7)
!44 = !DILocalVariable(name: "__vla_expr1", scope: !7, type: !42, flags: DIFlagArtificial)
!45 = !DILocalVariable(name: "b", scope: !7, file: !1, line: 60, type: !46)
!46 = !DICompositeType(tag: DW_TAG_array_type, baseType: !47, elements: !48)
!47 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!48 = !{!49, !50}
!49 = !DISubrange(count: !41)
!50 = !DISubrange(count: !44)
!51 = !DILocation(line: 60, column: 10, scope: !7)
!52 = !DILocation(line: 62, column: 9, scope: !53)
!53 = distinct !DILexicalBlock(scope: !7, file: !1, line: 62, column: 3)
!54 = !DILocation(line: 62, column: 8, scope: !53)
!55 = !DILocation(line: 62, column: 12, scope: !56)
!56 = distinct !DILexicalBlock(scope: !53, file: !1, line: 62, column: 3)
!57 = !DILocation(line: 62, column: 14, scope: !56)
!58 = !DILocation(line: 62, column: 13, scope: !56)
!59 = !DILocation(line: 62, column: 3, scope: !53)
!60 = !DILocation(line: 64, column: 11, scope: !61)
!61 = distinct !DILexicalBlock(scope: !56, file: !1, line: 64, column: 5)
!62 = !DILocation(line: 64, column: 10, scope: !61)
!63 = !DILocation(line: 64, column: 14, scope: !64)
!64 = distinct !DILexicalBlock(scope: !61, file: !1, line: 64, column: 5)
!65 = !DILocation(line: 64, column: 16, scope: !64)
!66 = !DILocation(line: 64, column: 15, scope: !64)
!67 = !DILocation(line: 64, column: 5, scope: !61)
!68 = !DILocation(line: 65, column: 17, scope: !64)
!69 = !DILocation(line: 65, column: 15, scope: !64)
!70 = !DILocation(line: 65, column: 20, scope: !64)
!71 = !DILocation(line: 65, column: 21, scope: !64)
!72 = !DILocation(line: 65, column: 9, scope: !64)
!73 = !DILocation(line: 65, column: 7, scope: !64)
!74 = !DILocation(line: 65, column: 12, scope: !64)
!75 = !DILocation(line: 65, column: 14, scope: !64)
!76 = !DILocation(line: 64, column: 19, scope: !64)
!77 = !DILocation(line: 64, column: 5, scope: !64)
!78 = distinct !{!78, !67, !79}
!79 = !DILocation(line: 65, column: 23, scope: !61)
!80 = !DILocation(line: 62, column: 17, scope: !56)
!81 = !DILocation(line: 62, column: 3, scope: !56)
!82 = distinct !{!82, !59, !83}
!83 = !DILocation(line: 65, column: 23, scope: !53)
!84 = !DILocation(line: 67, column: 3, scope: !7)
!85 = !DILocation(line: 68, column: 1, scope: !7)
