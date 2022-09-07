; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [14 x i8] c"b[50][50]=%f\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !7 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
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
  call void @llvm.dbg.declare(metadata i32* %n, metadata !22, metadata !DIExpression()), !dbg !23
  store i32 100, i32* %n, align 4, !dbg !23
  call void @llvm.dbg.declare(metadata i32* %m, metadata !24, metadata !DIExpression()), !dbg !25
  store i32 100, i32* %m, align 4, !dbg !25
  %0 = load i32, i32* %n, align 4, !dbg !26
  %1 = zext i32 %0 to i64, !dbg !27
  %2 = load i32, i32* %m, align 4, !dbg !28
  %3 = zext i32 %2 to i64, !dbg !27
  %4 = call i8* @llvm.stacksave(), !dbg !27
  store i8* %4, i8** %saved_stack, align 8, !dbg !27
  %5 = mul nuw i64 %1, %3, !dbg !27
  %vla = alloca double, i64 %5, align 16, !dbg !27
  store i64 %1, i64* %__vla_expr0, align 8, !dbg !27
  store i64 %3, i64* %__vla_expr1, align 8, !dbg !27
  call void @llvm.dbg.declare(metadata i64* %__vla_expr0, metadata !29, metadata !DIExpression()), !dbg !31
  call void @llvm.dbg.declare(metadata i64* %__vla_expr1, metadata !32, metadata !DIExpression()), !dbg !31
  call void @llvm.dbg.declare(metadata double* %vla, metadata !33, metadata !DIExpression()), !dbg !39
  store i32 1, i32* %i, align 4, !dbg !40
  br label %for.cond, !dbg !42

for.cond:                                         ; preds = %for.inc10, %entry
  %6 = load i32, i32* %i, align 4, !dbg !43
  %7 = load i32, i32* %n, align 4, !dbg !45
  %cmp = icmp slt i32 %6, %7, !dbg !46
  br i1 %cmp, label %for.body, label %for.end12, !dbg !47

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %j, align 4, !dbg !48
  br label %for.cond1, !dbg !50

for.cond1:                                        ; preds = %for.inc, %for.body
  %8 = load i32, i32* %j, align 4, !dbg !51
  %9 = load i32, i32* %m, align 4, !dbg !53
  %cmp2 = icmp slt i32 %8, %9, !dbg !54
  br i1 %cmp2, label %for.body3, label %for.end, !dbg !55

for.body3:                                        ; preds = %for.cond1
  %10 = load i32, i32* %i, align 4, !dbg !56
  %idxprom = sext i32 %10 to i64, !dbg !57
  %11 = mul nsw i64 %idxprom, %3, !dbg !57
  %arrayidx = getelementptr inbounds double, double* %vla, i64 %11, !dbg !57
  %12 = load i32, i32* %j, align 4, !dbg !58
  %sub = sub nsw i32 %12, 1, !dbg !59
  %idxprom4 = sext i32 %sub to i64, !dbg !57
  %arrayidx5 = getelementptr inbounds double, double* %arrayidx, i64 %idxprom4, !dbg !57
  %13 = load double, double* %arrayidx5, align 8, !dbg !57
  %14 = load i32, i32* %i, align 4, !dbg !60
  %idxprom6 = sext i32 %14 to i64, !dbg !61
  %15 = mul nsw i64 %idxprom6, %3, !dbg !61
  %arrayidx7 = getelementptr inbounds double, double* %vla, i64 %15, !dbg !61
  %16 = load i32, i32* %j, align 4, !dbg !62
  %idxprom8 = sext i32 %16 to i64, !dbg !61
  %arrayidx9 = getelementptr inbounds double, double* %arrayidx7, i64 %idxprom8, !dbg !61
  store double %13, double* %arrayidx9, align 8, !dbg !63
  br label %for.inc, !dbg !61

for.inc:                                          ; preds = %for.body3
  %17 = load i32, i32* %j, align 4, !dbg !64
  %inc = add nsw i32 %17, 1, !dbg !64
  store i32 %inc, i32* %j, align 4, !dbg !64
  br label %for.cond1, !dbg !65, !llvm.loop !66

for.end:                                          ; preds = %for.cond1
  br label %for.inc10, !dbg !67

for.inc10:                                        ; preds = %for.end
  %18 = load i32, i32* %i, align 4, !dbg !68
  %inc11 = add nsw i32 %18, 1, !dbg !68
  store i32 %inc11, i32* %i, align 4, !dbg !68
  br label %for.cond, !dbg !69, !llvm.loop !70

for.end12:                                        ; preds = %for.cond
  %19 = mul nsw i64 50, %3, !dbg !72
  %arrayidx13 = getelementptr inbounds double, double* %vla, i64 %19, !dbg !72
  %arrayidx14 = getelementptr inbounds double, double* %arrayidx13, i64 50, !dbg !72
  %20 = load double, double* %arrayidx14, align 8, !dbg !72
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str, i64 0, i64 0), double %20), !dbg !73
  store i32 0, i32* %retval, align 4, !dbg !74
  %21 = load i8*, i8** %saved_stack, align 8, !dbg !75
  call void @llvm.stackrestore(i8* %21), !dbg !75
  %22 = load i32, i32* %retval, align 4, !dbg !75
  ret i32 %22, !dbg !75
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
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/014")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"Ubuntu clang version 11.1.0-6"}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 67, type: !8, scopeLine: 68, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10, !10, !11}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!13 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!14 = !DILocalVariable(name: "argc", arg: 1, scope: !7, file: !1, line: 67, type: !10)
!15 = !DILocation(line: 67, column: 14, scope: !7)
!16 = !DILocalVariable(name: "argv", arg: 2, scope: !7, file: !1, line: 67, type: !11)
!17 = !DILocation(line: 67, column: 26, scope: !7)
!18 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 69, type: !10)
!19 = !DILocation(line: 69, column: 7, scope: !7)
!20 = !DILocalVariable(name: "j", scope: !7, file: !1, line: 69, type: !10)
!21 = !DILocation(line: 69, column: 9, scope: !7)
!22 = !DILocalVariable(name: "n", scope: !7, file: !1, line: 70, type: !10)
!23 = !DILocation(line: 70, column: 7, scope: !7)
!24 = !DILocalVariable(name: "m", scope: !7, file: !1, line: 70, type: !10)
!25 = !DILocation(line: 70, column: 14, scope: !7)
!26 = !DILocation(line: 71, column: 12, scope: !7)
!27 = !DILocation(line: 71, column: 3, scope: !7)
!28 = !DILocation(line: 71, column: 15, scope: !7)
!29 = !DILocalVariable(name: "__vla_expr0", scope: !7, type: !30, flags: DIFlagArtificial)
!30 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!31 = !DILocation(line: 0, scope: !7)
!32 = !DILocalVariable(name: "__vla_expr1", scope: !7, type: !30, flags: DIFlagArtificial)
!33 = !DILocalVariable(name: "b", scope: !7, file: !1, line: 71, type: !34)
!34 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, elements: !36)
!35 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!36 = !{!37, !38}
!37 = !DISubrange(count: !29)
!38 = !DISubrange(count: !32)
!39 = !DILocation(line: 71, column: 10, scope: !7)
!40 = !DILocation(line: 73, column: 9, scope: !41)
!41 = distinct !DILexicalBlock(scope: !7, file: !1, line: 73, column: 3)
!42 = !DILocation(line: 73, column: 8, scope: !41)
!43 = !DILocation(line: 73, column: 12, scope: !44)
!44 = distinct !DILexicalBlock(scope: !41, file: !1, line: 73, column: 3)
!45 = !DILocation(line: 73, column: 14, scope: !44)
!46 = !DILocation(line: 73, column: 13, scope: !44)
!47 = !DILocation(line: 73, column: 3, scope: !41)
!48 = !DILocation(line: 74, column: 11, scope: !49)
!49 = distinct !DILexicalBlock(scope: !44, file: !1, line: 74, column: 5)
!50 = !DILocation(line: 74, column: 10, scope: !49)
!51 = !DILocation(line: 74, column: 14, scope: !52)
!52 = distinct !DILexicalBlock(scope: !49, file: !1, line: 74, column: 5)
!53 = !DILocation(line: 74, column: 16, scope: !52)
!54 = !DILocation(line: 74, column: 15, scope: !52)
!55 = !DILocation(line: 74, column: 5, scope: !49)
!56 = !DILocation(line: 75, column: 17, scope: !52)
!57 = !DILocation(line: 75, column: 15, scope: !52)
!58 = !DILocation(line: 75, column: 20, scope: !52)
!59 = !DILocation(line: 75, column: 21, scope: !52)
!60 = !DILocation(line: 75, column: 9, scope: !52)
!61 = !DILocation(line: 75, column: 7, scope: !52)
!62 = !DILocation(line: 75, column: 12, scope: !52)
!63 = !DILocation(line: 75, column: 14, scope: !52)
!64 = !DILocation(line: 74, column: 19, scope: !52)
!65 = !DILocation(line: 74, column: 5, scope: !52)
!66 = distinct !{!66, !55, !67}
!67 = !DILocation(line: 75, column: 23, scope: !49)
!68 = !DILocation(line: 73, column: 17, scope: !44)
!69 = !DILocation(line: 73, column: 3, scope: !44)
!70 = distinct !{!70, !47, !71}
!71 = !DILocation(line: 75, column: 23, scope: !41)
!72 = !DILocation(line: 77, column: 28, scope: !7)
!73 = !DILocation(line: 77, column: 3, scope: !7)
!74 = !DILocation(line: 79, column: 3, scope: !7)
!75 = !DILocation(line: 80, column: 1, scope: !7)
