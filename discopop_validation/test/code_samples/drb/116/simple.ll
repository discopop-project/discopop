; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [10 x i8] c"a[50]=%f\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !9 {
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
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !16, metadata !DIExpression()), !dbg !17
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32* %i, metadata !20, metadata !DIExpression()), !dbg !21
  call void @llvm.dbg.declare(metadata i32* %len, metadata !22, metadata !DIExpression()), !dbg !23
  store i32 100, i32* %len, align 4, !dbg !23
  %0 = load i32, i32* %len, align 4, !dbg !24
  %1 = zext i32 %0 to i64, !dbg !25
  %2 = call i8* @llvm.stacksave(), !dbg !25
  store i8* %2, i8** %saved_stack, align 8, !dbg !25
  %vla = alloca double, i64 %1, align 16, !dbg !25
  store i64 %1, i64* %__vla_expr0, align 8, !dbg !25
  call void @llvm.dbg.declare(metadata i64* %__vla_expr0, metadata !26, metadata !DIExpression()), !dbg !28
  call void @llvm.dbg.declare(metadata double* %vla, metadata !29, metadata !DIExpression()), !dbg !33
  store i32 0, i32* %i, align 4, !dbg !34
  br label %for.cond, !dbg !36

for.cond:                                         ; preds = %for.inc, %entry
  %3 = load i32, i32* %i, align 4, !dbg !37
  %4 = load i32, i32* %len, align 4, !dbg !39
  %cmp = icmp slt i32 %3, %4, !dbg !40
  br i1 %cmp, label %for.body, label %for.end, !dbg !41

for.body:                                         ; preds = %for.cond
  %5 = load i32, i32* %i, align 4, !dbg !42
  %conv = sitofp i32 %5 to double, !dbg !43
  %div = fdiv double %conv, 2.000000e+00, !dbg !44
  %6 = load i32, i32* %i, align 4, !dbg !45
  %idxprom = sext i32 %6 to i64, !dbg !46
  %arrayidx = getelementptr inbounds double, double* %vla, i64 %idxprom, !dbg !46
  store double %div, double* %arrayidx, align 8, !dbg !47
  br label %for.inc, !dbg !46

for.inc:                                          ; preds = %for.body
  %7 = load i32, i32* %i, align 4, !dbg !48
  %inc = add nsw i32 %7, 1, !dbg !48
  store i32 %inc, i32* %i, align 4, !dbg !48
  br label %for.cond, !dbg !49, !llvm.loop !50

for.end:                                          ; preds = %for.cond
  %arrayidx1 = getelementptr inbounds double, double* %vla, i64 50, !dbg !52
  %8 = load double, double* %arrayidx1, align 16, !dbg !54
  %mul = fmul double %8, 2.000000e+00, !dbg !54
  store double %mul, double* %arrayidx1, align 16, !dbg !54
  %arrayidx2 = getelementptr inbounds double, double* %vla, i64 50, !dbg !55
  %9 = load double, double* %arrayidx2, align 16, !dbg !55
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), double %9), !dbg !56
  store i32 0, i32* %retval, align 4, !dbg !57
  %10 = load i8*, i8** %saved_stack, align 8, !dbg !58
  call void @llvm.stackrestore(i8* %10), !dbg !58
  %11 = load i32, i32* %retval, align 4, !dbg !58
  ret i32 %11, !dbg !58
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare i8* @llvm.stacksave() #2

declare dso_local i32 @printf(i8*, ...) #3

; Function Attrs: nounwind
declare void @llvm.stackrestore(i8*) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!5, !6, !7}
!llvm.ident = !{!8}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/116")
!2 = !{}
!3 = !{!4}
!4 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!5 = !{i32 7, !"Dwarf Version", i32 4}
!6 = !{i32 2, !"Debug Info Version", i32 3}
!7 = !{i32 1, !"wchar_size", i32 4}
!8 = !{!"Ubuntu clang version 11.1.0-6"}
!9 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 53, type: !10, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!10 = !DISubroutineType(types: !11)
!11 = !{!12, !12, !13}
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!15 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!16 = !DILocalVariable(name: "argc", arg: 1, scope: !9, file: !1, line: 53, type: !12)
!17 = !DILocation(line: 53, column: 14, scope: !9)
!18 = !DILocalVariable(name: "argv", arg: 2, scope: !9, file: !1, line: 53, type: !13)
!19 = !DILocation(line: 53, column: 26, scope: !9)
!20 = !DILocalVariable(name: "i", scope: !9, file: !1, line: 55, type: !12)
!21 = !DILocation(line: 55, column: 7, scope: !9)
!22 = !DILocalVariable(name: "len", scope: !9, file: !1, line: 56, type: !12)
!23 = !DILocation(line: 56, column: 7, scope: !9)
!24 = !DILocation(line: 57, column: 12, scope: !9)
!25 = !DILocation(line: 57, column: 3, scope: !9)
!26 = !DILocalVariable(name: "__vla_expr0", scope: !9, type: !27, flags: DIFlagArtificial)
!27 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!28 = !DILocation(line: 0, scope: !9)
!29 = !DILocalVariable(name: "a", scope: !9, file: !1, line: 57, type: !30)
!30 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, elements: !31)
!31 = !{!32}
!32 = !DISubrange(count: !26)
!33 = !DILocation(line: 57, column: 10, scope: !9)
!34 = !DILocation(line: 60, column: 9, scope: !35)
!35 = distinct !DILexicalBlock(scope: !9, file: !1, line: 60, column: 3)
!36 = !DILocation(line: 60, column: 8, scope: !35)
!37 = !DILocation(line: 60, column: 13, scope: !38)
!38 = distinct !DILexicalBlock(scope: !35, file: !1, line: 60, column: 3)
!39 = !DILocation(line: 60, column: 15, scope: !38)
!40 = !DILocation(line: 60, column: 14, scope: !38)
!41 = !DILocation(line: 60, column: 3, scope: !35)
!42 = !DILocation(line: 61, column: 20, scope: !38)
!43 = !DILocation(line: 61, column: 12, scope: !38)
!44 = !DILocation(line: 61, column: 22, scope: !38)
!45 = !DILocation(line: 61, column: 7, scope: !38)
!46 = !DILocation(line: 61, column: 5, scope: !38)
!47 = !DILocation(line: 61, column: 9, scope: !38)
!48 = !DILocation(line: 60, column: 21, scope: !38)
!49 = !DILocation(line: 60, column: 3, scope: !38)
!50 = distinct !{!50, !41, !51}
!51 = !DILocation(line: 61, column: 23, scope: !35)
!52 = !DILocation(line: 66, column: 5, scope: !53)
!53 = distinct !DILexicalBlock(scope: !9, file: !1, line: 65, column: 3)
!54 = !DILocation(line: 66, column: 10, scope: !53)
!55 = !DILocation(line: 69, column: 25, scope: !9)
!56 = !DILocation(line: 69, column: 3, scope: !9)
!57 = !DILocation(line: 70, column: 3, scope: !9)
!58 = !DILocation(line: 71, column: 1, scope: !9)
