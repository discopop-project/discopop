; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [2 x i8] c"N\00", align 1
@.str.1 = private unnamed_addr constant [10 x i8] c"m_pdv_sum\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"m_nvol\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"i\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @setup(i32 %N) #0 !dbg !10 {
entry:
  call void @__dp_func_entry(i32 16435, i32 0)
  %N.addr = alloca i32, align 4
  %m_pdv_sum = alloca double*, align 8
  %m_nvol = alloca double*, align 8
  %i = alloca i32, align 4
  %0 = ptrtoint i32* %N.addr to i64
  call void @__dp_write(i32 16435, i64 %0, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i32 %N, i32* %N.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %N.addr, metadata !14, metadata !DIExpression()), !dbg !15
  call void @llvm.dbg.declare(metadata double** %m_pdv_sum, metadata !16, metadata !DIExpression()), !dbg !17
  %1 = ptrtoint i32* %N.addr to i64
  call void @__dp_read(i32 16437, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %2 = load i32, i32* %N.addr, align 4, !dbg !18
  %conv = sext i32 %2 to i64, !dbg !18
  %mul = mul i64 8, %conv, !dbg !19
  call void @__dp_call(i32 16437), !dbg !20
  %call = call noalias i8* @malloc(i64 %mul) #3, !dbg !20
  %3 = bitcast i8* %call to double*, !dbg !21
  %4 = ptrtoint double** %m_pdv_sum to i64
  call void @__dp_write(i32 16437, i64 %4, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.1, i32 0, i32 0))
  store double* %3, double** %m_pdv_sum, align 8, !dbg !17
  call void @llvm.dbg.declare(metadata double** %m_nvol, metadata !22, metadata !DIExpression()), !dbg !23
  %5 = ptrtoint i32* %N.addr to i64
  call void @__dp_read(i32 16438, i64 %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %6 = load i32, i32* %N.addr, align 4, !dbg !24
  %conv1 = sext i32 %6 to i64, !dbg !24
  %mul2 = mul i64 8, %conv1, !dbg !25
  call void @__dp_call(i32 16438), !dbg !26
  %call3 = call noalias i8* @malloc(i64 %mul2) #3, !dbg !26
  %7 = bitcast i8* %call3 to double*, !dbg !27
  %8 = ptrtoint double** %m_nvol to i64
  call void @__dp_write(i32 16438, i64 %8, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  store double* %7, double** %m_nvol, align 8, !dbg !23
  call void @llvm.dbg.declare(metadata i32* %i, metadata !28, metadata !DIExpression()), !dbg !30
  %9 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16441, i64 %9, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !30
  br label %for.cond, !dbg !31

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16441, i32 0)
  %10 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16441, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %11 = load i32, i32* %i, align 4, !dbg !32
  %12 = ptrtoint i32* %N.addr to i64
  call void @__dp_read(i32 16441, i64 %12, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %13 = load i32, i32* %N.addr, align 4, !dbg !34
  %cmp = icmp slt i32 %11, %13, !dbg !35
  br i1 %cmp, label %for.body, label %for.end, !dbg !36

for.body:                                         ; preds = %for.cond
  %14 = ptrtoint double** %m_pdv_sum to i64
  call void @__dp_read(i32 16443, i64 %14, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.1, i32 0, i32 0))
  %15 = load double*, double** %m_pdv_sum, align 8, !dbg !37
  %16 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16443, i64 %16, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %17 = load i32, i32* %i, align 4, !dbg !39
  %idxprom = sext i32 %17 to i64, !dbg !37
  %arrayidx = getelementptr inbounds double, double* %15, i64 %idxprom, !dbg !37
  %18 = ptrtoint double* %arrayidx to i64
  call void @__dp_write(i32 16443, i64 %18, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.1, i32 0, i32 0))
  store double 0.000000e+00, double* %arrayidx, align 8, !dbg !40
  %19 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16444, i64 %19, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %20 = load i32, i32* %i, align 4, !dbg !41
  %conv5 = sitofp i32 %20 to double, !dbg !41
  %mul6 = fmul double %conv5, 2.500000e+00, !dbg !42
  %21 = ptrtoint double** %m_nvol to i64
  call void @__dp_read(i32 16444, i64 %21, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  %22 = load double*, double** %m_nvol, align 8, !dbg !43
  %23 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16444, i64 %23, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %24 = load i32, i32* %i, align 4, !dbg !44
  %idxprom7 = sext i32 %24 to i64, !dbg !43
  %arrayidx8 = getelementptr inbounds double, double* %22, i64 %idxprom7, !dbg !43
  %25 = ptrtoint double* %arrayidx8 to i64
  call void @__dp_write(i32 16444, i64 %25, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  store double %mul6, double* %arrayidx8, align 8, !dbg !45
  br label %for.inc, !dbg !46

for.inc:                                          ; preds = %for.body
  %26 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16441, i64 %26, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %27 = load i32, i32* %i, align 4, !dbg !47
  %inc = add nsw i32 %27, 1, !dbg !47
  %28 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16441, i64 %28, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !47
  br label %for.cond, !dbg !48, !llvm.loop !49

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16447, i32 0)
  %29 = ptrtoint double** %m_pdv_sum to i64
  call void @__dp_read(i32 16447, i64 %29, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.1, i32 0, i32 0))
  %30 = load double*, double** %m_pdv_sum, align 8, !dbg !51
  %31 = bitcast double* %30 to i8*, !dbg !51
  call void @__dp_call(i32 16447), !dbg !52
  call void @free(i8* %31) #3, !dbg !52
  %32 = ptrtoint double** %m_nvol to i64
  call void @__dp_read(i32 16448, i64 %32, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  %33 = load double*, double** %m_nvol, align 8, !dbg !53
  %34 = bitcast double* %33 to i8*, !dbg !53
  call void @__dp_call(i32 16448), !dbg !54
  call void @free(i8* %34) #3, !dbg !54
  call void @__dp_func_exit(i32 16449, i32 0), !dbg !55
  ret void, !dbg !55
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_call(i32)

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64) #2

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_loop_exit(i32, i32)

; Function Attrs: nounwind
declare dso_local void @free(i8*) #2

declare void @__dp_func_exit(i32, i32)

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !56 {
entry:
  call void @__dp_func_entry(i32 16451, i32 1)
  %N = alloca i32, align 4
  call void @llvm.dbg.declare(metadata i32* %N, metadata !59, metadata !DIExpression()), !dbg !60
  %0 = ptrtoint i32* %N to i64
  call void @__dp_write(i32 16453, i64 %0, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i32 1000, i32* %N, align 4, !dbg !60
  %1 = ptrtoint i32* %N to i64
  call void @__dp_read(i32 16454, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %2 = load i32, i32* %N, align 4, !dbg !61
  call void @__dp_call(i32 16454), !dbg !62
  call void @setup(i32 %2), !dbg !62
  call void @__dp_finalize(i32 16455), !dbg !63
  ret i32 0, !dbg !63
}

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!6}
!llvm.module.flags = !{!7, !8, !9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/066")
!2 = !{}
!3 = !{!4}
!4 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!5 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!6 = !{!"Ubuntu clang version 11.1.0-6"}
!7 = !{i32 7, !"Dwarf Version", i32 4}
!8 = !{i32 2, !"Debug Info Version", i32 3}
!9 = !{i32 1, !"wchar_size", i32 4}
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
