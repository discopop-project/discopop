; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [7 x i8] c"%d %d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !7 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %var = alloca i32, align 4
  %i = alloca i32, align 4
  %res = alloca i32, align 4
  %sum1 = alloca i32, align 4
  %sum2 = alloca i32, align 4
  %error = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !14, metadata !DIExpression()), !dbg !15
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !16, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.declare(metadata i32* %var, metadata !18, metadata !DIExpression()), !dbg !19
  store i32 0, i32* %var, align 4, !dbg !19
  call void @llvm.dbg.declare(metadata i32* %i, metadata !20, metadata !DIExpression()), !dbg !21
  call void @llvm.dbg.declare(metadata i32* %res, metadata !22, metadata !DIExpression()), !dbg !23
  call void @llvm.dbg.declare(metadata i32* %sum1, metadata !24, metadata !DIExpression()), !dbg !25
  store i32 0, i32* %sum1, align 4, !dbg !25
  call void @llvm.dbg.declare(metadata i32* %sum2, metadata !26, metadata !DIExpression()), !dbg !27
  store i32 0, i32* %sum2, align 4, !dbg !27
  %call = call i32 @omp_get_max_threads(), !dbg !28
  store i32 %call, i32* %res, align 4, !dbg !29
  store i32 0, i32* %i, align 4, !dbg !30
  br label %for.cond, !dbg !33

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !34
  %cmp = icmp slt i32 %0, 5, !dbg !36
  br i1 %cmp, label %for.body, label %for.end, !dbg !37

for.body:                                         ; preds = %for.cond
  %1 = load i32, i32* %i, align 4, !dbg !38
  %2 = load i32, i32* %sum1, align 4, !dbg !39
  %add = add nsw i32 %2, %1, !dbg !39
  store i32 %add, i32* %sum1, align 4, !dbg !39
  br label %for.inc, !dbg !40

for.inc:                                          ; preds = %for.body
  %3 = load i32, i32* %i, align 4, !dbg !41
  %inc = add nsw i32 %3, 1, !dbg !41
  store i32 %inc, i32* %i, align 4, !dbg !41
  br label %for.cond, !dbg !42, !llvm.loop !43

for.end:                                          ; preds = %for.cond
  store i32 0, i32* %i, align 4, !dbg !45
  br label %for.cond1, !dbg !47

for.cond1:                                        ; preds = %for.inc5, %for.end
  %4 = load i32, i32* %i, align 4, !dbg !48
  %cmp2 = icmp slt i32 %4, 5, !dbg !50
  br i1 %cmp2, label %for.body3, label %for.end7, !dbg !51

for.body3:                                        ; preds = %for.cond1
  %5 = load i32, i32* %i, align 4, !dbg !52
  %6 = load i32, i32* %sum2, align 4, !dbg !53
  %add4 = add nsw i32 %6, %5, !dbg !53
  store i32 %add4, i32* %sum2, align 4, !dbg !53
  br label %for.inc5, !dbg !54

for.inc5:                                         ; preds = %for.body3
  %7 = load i32, i32* %i, align 4, !dbg !55
  %inc6 = add nsw i32 %7, 1, !dbg !55
  store i32 %inc6, i32* %i, align 4, !dbg !55
  br label %for.cond1, !dbg !56, !llvm.loop !57

for.end7:                                         ; preds = %for.cond1
  %8 = load i32, i32* %sum1, align 4, !dbg !59
  %9 = load i32, i32* %sum2, align 4, !dbg !60
  %add8 = add nsw i32 %8, %9, !dbg !61
  store i32 %add8, i32* %var, align 4, !dbg !62
  call void @llvm.dbg.declare(metadata i32* %error, metadata !63, metadata !DIExpression()), !dbg !64
  %10 = load i32, i32* %var, align 4, !dbg !65
  %11 = load i32, i32* %res, align 4, !dbg !66
  %mul = mul nsw i32 20, %11, !dbg !67
  %cmp9 = icmp ne i32 %10, %mul, !dbg !68
  %conv = zext i1 %cmp9 to i32, !dbg !68
  store i32 %conv, i32* %error, align 4, !dbg !64
  %12 = load i32, i32* %error, align 4, !dbg !69
  %tobool = icmp ne i32 %12, 0, !dbg !69
  br i1 %tobool, label %if.then, label %if.end, !dbg !71

if.then:                                          ; preds = %for.end7
  %13 = load i32, i32* %var, align 4, !dbg !72
  %14 = load i32, i32* %res, align 4, !dbg !73
  %mul10 = mul nsw i32 20, %14, !dbg !74
  %call11 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i64 0, i64 0), i32 %13, i32 %mul10), !dbg !75
  br label %if.end, !dbg !75

if.end:                                           ; preds = %if.then, %for.end7
  %15 = load i32, i32* %error, align 4, !dbg !76
  ret i32 %15, !dbg !77
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @omp_get_max_threads() #2

declare dso_local i32 @printf(i8*, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/121")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"Ubuntu clang version 11.1.0-6"}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 20, type: !8, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10, !10, !11}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!13 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!14 = !DILocalVariable(name: "argc", arg: 1, scope: !7, file: !1, line: 20, type: !10)
!15 = !DILocation(line: 20, column: 14, scope: !7)
!16 = !DILocalVariable(name: "argv", arg: 2, scope: !7, file: !1, line: 20, type: !11)
!17 = !DILocation(line: 20, column: 26, scope: !7)
!18 = !DILocalVariable(name: "var", scope: !7, file: !1, line: 22, type: !10)
!19 = !DILocation(line: 22, column: 7, scope: !7)
!20 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 22, type: !10)
!21 = !DILocation(line: 22, column: 16, scope: !7)
!22 = !DILocalVariable(name: "res", scope: !7, file: !1, line: 22, type: !10)
!23 = !DILocation(line: 22, column: 19, scope: !7)
!24 = !DILocalVariable(name: "sum1", scope: !7, file: !1, line: 23, type: !10)
!25 = !DILocation(line: 23, column: 7, scope: !7)
!26 = !DILocalVariable(name: "sum2", scope: !7, file: !1, line: 24, type: !10)
!27 = !DILocation(line: 24, column: 7, scope: !7)
!28 = !DILocation(line: 26, column: 9, scope: !7)
!29 = !DILocation(line: 26, column: 7, scope: !7)
!30 = !DILocation(line: 31, column: 11, scope: !31)
!31 = distinct !DILexicalBlock(scope: !32, file: !1, line: 31, column: 5)
!32 = distinct !DILexicalBlock(scope: !7, file: !1, line: 29, column: 3)
!33 = !DILocation(line: 31, column: 10, scope: !31)
!34 = !DILocation(line: 31, column: 15, scope: !35)
!35 = distinct !DILexicalBlock(scope: !31, file: !1, line: 31, column: 5)
!36 = !DILocation(line: 31, column: 16, scope: !35)
!37 = !DILocation(line: 31, column: 5, scope: !31)
!38 = !DILocation(line: 32, column: 11, scope: !35)
!39 = !DILocation(line: 32, column: 9, scope: !35)
!40 = !DILocation(line: 32, column: 5, scope: !35)
!41 = !DILocation(line: 31, column: 21, scope: !35)
!42 = !DILocation(line: 31, column: 5, scope: !35)
!43 = distinct !{!43, !37, !44}
!44 = !DILocation(line: 32, column: 11, scope: !31)
!45 = !DILocation(line: 34, column: 11, scope: !46)
!46 = distinct !DILexicalBlock(scope: !32, file: !1, line: 34, column: 5)
!47 = !DILocation(line: 34, column: 10, scope: !46)
!48 = !DILocation(line: 34, column: 15, scope: !49)
!49 = distinct !DILexicalBlock(scope: !46, file: !1, line: 34, column: 5)
!50 = !DILocation(line: 34, column: 16, scope: !49)
!51 = !DILocation(line: 34, column: 5, scope: !46)
!52 = !DILocation(line: 35, column: 11, scope: !49)
!53 = !DILocation(line: 35, column: 9, scope: !49)
!54 = !DILocation(line: 35, column: 5, scope: !49)
!55 = !DILocation(line: 34, column: 21, scope: !49)
!56 = !DILocation(line: 34, column: 5, scope: !49)
!57 = distinct !{!57, !51, !58}
!58 = !DILocation(line: 35, column: 11, scope: !46)
!59 = !DILocation(line: 37, column: 11, scope: !32)
!60 = !DILocation(line: 37, column: 18, scope: !32)
!61 = !DILocation(line: 37, column: 16, scope: !32)
!62 = !DILocation(line: 37, column: 9, scope: !32)
!63 = !DILocalVariable(name: "error", scope: !7, file: !1, line: 40, type: !10)
!64 = !DILocation(line: 40, column: 7, scope: !7)
!65 = !DILocation(line: 40, column: 16, scope: !7)
!66 = !DILocation(line: 40, column: 26, scope: !7)
!67 = !DILocation(line: 40, column: 25, scope: !7)
!68 = !DILocation(line: 40, column: 20, scope: !7)
!69 = !DILocation(line: 41, column: 7, scope: !70)
!70 = distinct !DILexicalBlock(scope: !7, file: !1, line: 41, column: 7)
!71 = !DILocation(line: 41, column: 7, scope: !7)
!72 = !DILocation(line: 41, column: 31, scope: !70)
!73 = !DILocation(line: 41, column: 38, scope: !70)
!74 = !DILocation(line: 41, column: 37, scope: !70)
!75 = !DILocation(line: 41, column: 14, scope: !70)
!76 = !DILocation(line: 42, column: 10, scope: !7)
!77 = !DILocation(line: 42, column: 3, scope: !7)
