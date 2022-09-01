; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [7 x i8] c"PI=%f\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !9 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %pi = alloca double, align 8
  %i = alloca i64, align 8
  %x = alloca double, align 8
  %interval_width = alloca double, align 8
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !16, metadata !DIExpression()), !dbg !17
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata double* %pi, metadata !20, metadata !DIExpression()), !dbg !21
  store double 0.000000e+00, double* %pi, align 8, !dbg !21
  call void @llvm.dbg.declare(metadata i64* %i, metadata !22, metadata !DIExpression()), !dbg !24
  call void @llvm.dbg.declare(metadata double* %x, metadata !25, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.declare(metadata double* %interval_width, metadata !27, metadata !DIExpression()), !dbg !28
  store double 5.000000e-10, double* %interval_width, align 8, !dbg !29
  store i64 0, i64* %i, align 8, !dbg !30
  br label %for.cond, !dbg !32

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i64, i64* %i, align 8, !dbg !33
  %cmp = icmp slt i64 %0, 2000000000, !dbg !35
  br i1 %cmp, label %for.body, label %for.end, !dbg !36

for.body:                                         ; preds = %for.cond
  %1 = load i64, i64* %i, align 8, !dbg !37
  %conv = sitofp i64 %1 to double, !dbg !37
  %add = fadd double %conv, 5.000000e-01, !dbg !39
  %2 = load double, double* %interval_width, align 8, !dbg !40
  %mul = fmul double %add, %2, !dbg !41
  store double %mul, double* %x, align 8, !dbg !42
  %3 = load double, double* %x, align 8, !dbg !43
  %4 = load double, double* %x, align 8, !dbg !44
  %mul1 = fmul double %3, %4, !dbg !45
  %add2 = fadd double %mul1, 1.000000e+00, !dbg !46
  %div = fdiv double 1.000000e+00, %add2, !dbg !47
  %5 = load double, double* %pi, align 8, !dbg !48
  %add3 = fadd double %5, %div, !dbg !48
  store double %add3, double* %pi, align 8, !dbg !48
  br label %for.inc, !dbg !49

for.inc:                                          ; preds = %for.body
  %6 = load i64, i64* %i, align 8, !dbg !50
  %inc = add nsw i64 %6, 1, !dbg !50
  store i64 %inc, i64* %i, align 8, !dbg !50
  br label %for.cond, !dbg !51, !llvm.loop !52

for.end:                                          ; preds = %for.cond
  %7 = load double, double* %pi, align 8, !dbg !54
  %mul4 = fmul double %7, 4.000000e+00, !dbg !55
  %8 = load double, double* %interval_width, align 8, !dbg !56
  %mul5 = fmul double %mul4, %8, !dbg !57
  store double %mul5, double* %pi, align 8, !dbg !58
  %9 = load double, double* %pi, align 8, !dbg !59
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i64 0, i64 0), double %9), !dbg !60
  ret i32 0, !dbg !61
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @printf(i8*, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!5, !6, !7}
!llvm.ident = !{!8}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/065")
!2 = !{}
!3 = !{!4}
!4 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!5 = !{i32 7, !"Dwarf Version", i32 4}
!6 = !{i32 2, !"Debug Info Version", i32 3}
!7 = !{i32 1, !"wchar_size", i32 4}
!8 = !{!"Ubuntu clang version 11.1.0-6"}
!9 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 54, type: !10, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!10 = !DISubroutineType(types: !11)
!11 = !{!12, !12, !13}
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!15 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!16 = !DILocalVariable(name: "argc", arg: 1, scope: !9, file: !1, line: 54, type: !12)
!17 = !DILocation(line: 54, column: 14, scope: !9)
!18 = !DILocalVariable(name: "argv", arg: 2, scope: !9, file: !1, line: 54, type: !13)
!19 = !DILocation(line: 54, column: 27, scope: !9)
!20 = !DILocalVariable(name: "pi", scope: !9, file: !1, line: 56, type: !4)
!21 = !DILocation(line: 56, column: 10, scope: !9)
!22 = !DILocalVariable(name: "i", scope: !9, file: !1, line: 57, type: !23)
!23 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!24 = !DILocation(line: 57, column: 12, scope: !9)
!25 = !DILocalVariable(name: "x", scope: !9, file: !1, line: 58, type: !4)
!26 = !DILocation(line: 58, column: 10, scope: !9)
!27 = !DILocalVariable(name: "interval_width", scope: !9, file: !1, line: 58, type: !4)
!28 = !DILocation(line: 58, column: 13, scope: !9)
!29 = !DILocation(line: 59, column: 18, scope: !9)
!30 = !DILocation(line: 62, column: 10, scope: !31)
!31 = distinct !DILexicalBlock(scope: !9, file: !1, line: 62, column: 3)
!32 = !DILocation(line: 62, column: 8, scope: !31)
!33 = !DILocation(line: 62, column: 15, scope: !34)
!34 = distinct !DILexicalBlock(scope: !31, file: !1, line: 62, column: 3)
!35 = !DILocation(line: 62, column: 17, scope: !34)
!36 = !DILocation(line: 62, column: 3, scope: !31)
!37 = !DILocation(line: 63, column: 10, scope: !38)
!38 = distinct !DILexicalBlock(scope: !34, file: !1, line: 62, column: 35)
!39 = !DILocation(line: 63, column: 11, scope: !38)
!40 = !DILocation(line: 63, column: 20, scope: !38)
!41 = !DILocation(line: 63, column: 18, scope: !38)
!42 = !DILocation(line: 63, column: 7, scope: !38)
!43 = !DILocation(line: 64, column: 18, scope: !38)
!44 = !DILocation(line: 64, column: 20, scope: !38)
!45 = !DILocation(line: 64, column: 19, scope: !38)
!46 = !DILocation(line: 64, column: 22, scope: !38)
!47 = !DILocation(line: 64, column: 15, scope: !38)
!48 = !DILocation(line: 64, column: 8, scope: !38)
!49 = !DILocation(line: 65, column: 3, scope: !38)
!50 = !DILocation(line: 62, column: 31, scope: !34)
!51 = !DILocation(line: 62, column: 3, scope: !34)
!52 = distinct !{!52, !36, !53}
!53 = !DILocation(line: 65, column: 3, scope: !31)
!54 = !DILocation(line: 67, column: 8, scope: !9)
!55 = !DILocation(line: 67, column: 11, scope: !9)
!56 = !DILocation(line: 67, column: 19, scope: !9)
!57 = !DILocation(line: 67, column: 17, scope: !9)
!58 = !DILocation(line: 67, column: 6, scope: !9)
!59 = !DILocation(line: 68, column: 22, scope: !9)
!60 = !DILocation(line: 68, column: 3, scope: !9)
!61 = !DILocation(line: 69, column: 3, scope: !9)
