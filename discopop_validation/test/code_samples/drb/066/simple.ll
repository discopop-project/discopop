; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @setup(i32 %N) #0 !dbg !10 {
entry:
  %N.addr = alloca i32, align 4
  %m_pdv_sum = alloca double*, align 8
  %m_nvol = alloca double*, align 8
  %i = alloca i32, align 4
  store i32 %N, i32* %N.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %N.addr, metadata !14, metadata !DIExpression()), !dbg !15
  call void @llvm.dbg.declare(metadata double** %m_pdv_sum, metadata !16, metadata !DIExpression()), !dbg !17
  %0 = load i32, i32* %N.addr, align 4, !dbg !18
  %conv = sext i32 %0 to i64, !dbg !18
  %mul = mul i64 8, %conv, !dbg !19
  %call = call noalias i8* @malloc(i64 %mul) #3, !dbg !20
  %1 = bitcast i8* %call to double*, !dbg !21
  store double* %1, double** %m_pdv_sum, align 8, !dbg !17
  call void @llvm.dbg.declare(metadata double** %m_nvol, metadata !22, metadata !DIExpression()), !dbg !23
  %2 = load i32, i32* %N.addr, align 4, !dbg !24
  %conv1 = sext i32 %2 to i64, !dbg !24
  %mul2 = mul i64 8, %conv1, !dbg !25
  %call3 = call noalias i8* @malloc(i64 %mul2) #3, !dbg !26
  %3 = bitcast i8* %call3 to double*, !dbg !27
  store double* %3, double** %m_nvol, align 8, !dbg !23
  call void @llvm.dbg.declare(metadata i32* %i, metadata !28, metadata !DIExpression()), !dbg !30
  store i32 0, i32* %i, align 4, !dbg !30
  br label %for.cond, !dbg !31

for.cond:                                         ; preds = %for.inc, %entry
  %4 = load i32, i32* %i, align 4, !dbg !32
  %5 = load i32, i32* %N.addr, align 4, !dbg !34
  %cmp = icmp slt i32 %4, %5, !dbg !35
  br i1 %cmp, label %for.body, label %for.end, !dbg !36

for.body:                                         ; preds = %for.cond
  %6 = load double*, double** %m_pdv_sum, align 8, !dbg !37
  %7 = load i32, i32* %i, align 4, !dbg !39
  %idxprom = sext i32 %7 to i64, !dbg !37
  %arrayidx = getelementptr inbounds double, double* %6, i64 %idxprom, !dbg !37
  store double 0.000000e+00, double* %arrayidx, align 8, !dbg !40
  %8 = load i32, i32* %i, align 4, !dbg !41
  %conv5 = sitofp i32 %8 to double, !dbg !41
  %mul6 = fmul double %conv5, 2.500000e+00, !dbg !42
  %9 = load double*, double** %m_nvol, align 8, !dbg !43
  %10 = load i32, i32* %i, align 4, !dbg !44
  %idxprom7 = sext i32 %10 to i64, !dbg !43
  %arrayidx8 = getelementptr inbounds double, double* %9, i64 %idxprom7, !dbg !43
  store double %mul6, double* %arrayidx8, align 8, !dbg !45
  br label %for.inc, !dbg !46

for.inc:                                          ; preds = %for.body
  %11 = load i32, i32* %i, align 4, !dbg !47
  %inc = add nsw i32 %11, 1, !dbg !47
  store i32 %inc, i32* %i, align 4, !dbg !47
  br label %for.cond, !dbg !48, !llvm.loop !49

for.end:                                          ; preds = %for.cond
  %12 = load double*, double** %m_pdv_sum, align 8, !dbg !51
  %13 = bitcast double* %12 to i8*, !dbg !51
  call void @free(i8* %13) #3, !dbg !52
  %14 = load double*, double** %m_nvol, align 8, !dbg !53
  %15 = bitcast double* %14 to i8*, !dbg !53
  call void @free(i8* %15) #3, !dbg !54
  ret void, !dbg !55
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64) #2

; Function Attrs: nounwind
declare dso_local void @free(i8*) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !56 {
entry:
  %N = alloca i32, align 4
  call void @llvm.dbg.declare(metadata i32* %N, metadata !59, metadata !DIExpression()), !dbg !60
  store i32 1000, i32* %N, align 4, !dbg !60
  %0 = load i32, i32* %N, align 4, !dbg !61
  call void @setup(i32 %0), !dbg !62
  ret i32 0, !dbg !63
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!6, !7, !8}
!llvm.ident = !{!9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/066")
!2 = !{}
!3 = !{!4}
!4 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!5 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!6 = !{i32 7, !"Dwarf Version", i32 4}
!7 = !{i32 2, !"Debug Info Version", i32 3}
!8 = !{i32 1, !"wchar_size", i32 4}
!9 = !{!"Ubuntu clang version 11.1.0-6"}
!10 = distinct !DISubprogram(name: "setup", scope: !1, file: !1, line: 51, type: !11, scopeLine: 52, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!11 = !DISubroutineType(types: !12)
!12 = !{null, !13}
!13 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!14 = !DILocalVariable(name: "N", arg: 1, scope: !10, file: !1, line: 51, type: !13)
!15 = !DILocation(line: 51, column: 16, scope: !10)
!16 = !DILocalVariable(name: "m_pdv_sum", scope: !10, file: !1, line: 53, type: !4)
!17 = !DILocation(line: 53, column: 12, scope: !10)
!18 = !DILocation(line: 53, column: 61, scope: !10)
!19 = !DILocation(line: 53, column: 59, scope: !10)
!20 = !DILocation(line: 53, column: 35, scope: !10)
!21 = !DILocation(line: 53, column: 24, scope: !10)
!22 = !DILocalVariable(name: "m_nvol", scope: !10, file: !1, line: 54, type: !4)
!23 = !DILocation(line: 54, column: 12, scope: !10)
!24 = !DILocation(line: 54, column: 58, scope: !10)
!25 = !DILocation(line: 54, column: 56, scope: !10)
!26 = !DILocation(line: 54, column: 32, scope: !10)
!27 = !DILocation(line: 54, column: 21, scope: !10)
!28 = !DILocalVariable(name: "i", scope: !29, file: !1, line: 57, type: !13)
!29 = distinct !DILexicalBlock(scope: !10, file: !1, line: 57, column: 3)
!30 = !DILocation(line: 57, column: 12, scope: !29)
!31 = !DILocation(line: 57, column: 8, scope: !29)
!32 = !DILocation(line: 57, column: 17, scope: !33)
!33 = distinct !DILexicalBlock(scope: !29, file: !1, line: 57, column: 3)
!34 = !DILocation(line: 57, column: 21, scope: !33)
!35 = !DILocation(line: 57, column: 19, scope: !33)
!36 = !DILocation(line: 57, column: 3, scope: !29)
!37 = !DILocation(line: 59, column: 5, scope: !38)
!38 = distinct !DILexicalBlock(scope: !33, file: !1, line: 58, column: 3)
!39 = !DILocation(line: 59, column: 16, scope: !38)
!40 = !DILocation(line: 59, column: 20, scope: !38)
!41 = !DILocation(line: 60, column: 21, scope: !38)
!42 = !DILocation(line: 60, column: 22, scope: !38)
!43 = !DILocation(line: 60, column: 5, scope: !38)
!44 = !DILocation(line: 60, column: 13, scope: !38)
!45 = !DILocation(line: 60, column: 19, scope: !38)
!46 = !DILocation(line: 61, column: 3, scope: !38)
!47 = !DILocation(line: 57, column: 24, scope: !33)
!48 = !DILocation(line: 57, column: 3, scope: !33)
!49 = distinct !{!49, !36, !50}
!50 = !DILocation(line: 61, column: 3, scope: !29)
!51 = !DILocation(line: 63, column: 8, scope: !10)
!52 = !DILocation(line: 63, column: 3, scope: !10)
!53 = !DILocation(line: 64, column: 8, scope: !10)
!54 = !DILocation(line: 64, column: 3, scope: !10)
!55 = !DILocation(line: 65, column: 1, scope: !10)
!56 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 67, type: !57, scopeLine: 68, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!57 = !DISubroutineType(types: !58)
!58 = !{!13}
!59 = !DILocalVariable(name: "N", scope: !56, file: !1, line: 69, type: !13)
!60 = !DILocation(line: 69, column: 7, scope: !56)
!61 = !DILocation(line: 70, column: 9, scope: !56)
!62 = !DILocation(line: 70, column: 3, scope: !56)
!63 = !DILocation(line: 71, column: 1, scope: !56)
