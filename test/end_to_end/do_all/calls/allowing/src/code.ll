; ModuleID = 'code.cpp'
source_filename = "code.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@_ZZ4mainE1n = internal global i32 1000, align 4, !dbg !0
@.str = private unnamed_addr constant [4 x i8] c"tmp\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"z\00", align 1
@.str.3 = private unnamed_addr constant [10 x i8] c"1:10;1:11\00", align 1
@.str.4 = private unnamed_addr constant [10 x i8] c"1:10;1:12\00", align 1
@.str.5 = private unnamed_addr constant [10 x i8] c"1:10;1:15\00", align 1
@.str.6 = private unnamed_addr constant [12 x i8] c"_ZZ4mainE1n\00", align 1
@.str.7 = private unnamed_addr constant [5 x i8] c".str\00", align 1
@.str.8 = private unnamed_addr constant [7 x i8] c".str.1\00", align 1
@.str.9 = private unnamed_addr constant [7 x i8] c".str.2\00", align 1
@.str.10 = private unnamed_addr constant [7 x i8] c".str.3\00", align 1
@.str.11 = private unnamed_addr constant [7 x i8] c".str.4\00", align 1
@.str.12 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.13 = private unnamed_addr constant [5 x i8] c"argc\00", align 1
@.str.14 = private unnamed_addr constant [5 x i8] c"argv\00", align 1
@.str.15 = private unnamed_addr constant [2 x i8] c"x\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define void @_Z14allowing_doallPdi(double* %tmp, i32 %i) #0 !dbg !263 {
entry:
  call void @__dp_func_entry(i32 16388, i32 0)
  %tmp.addr = alloca double*, align 8
  %0 = ptrtoint double** %tmp.addr to i64
  %i.addr = alloca i32, align 4
  %1 = ptrtoint i32* %i.addr to i64
  %z = alloca i32, align 4
  %2 = ptrtoint i32* %z to i64
  %3 = ptrtoint double** %tmp.addr to i64
  store double* %tmp, double** %tmp.addr, align 8
  call void @llvm.dbg.declare(metadata double** %tmp.addr, metadata !266, metadata !DIExpression()), !dbg !267
  %4 = ptrtoint i32* %i.addr to i64
  store i32 %i, i32* %i.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %i.addr, metadata !268, metadata !DIExpression()), !dbg !269
  call void @llvm.dbg.declare(metadata i32* %z, metadata !270, metadata !DIExpression()), !dbg !271
  %5 = ptrtoint i32* %i.addr to i64
  %6 = load i32, i32* %i.addr, align 4, !dbg !272
  %conv = sitofp i32 %6 to double, !dbg !272
  %7 = ptrtoint double** %tmp.addr to i64
  %8 = load double*, double** %tmp.addr, align 8, !dbg !273
  %9 = ptrtoint i32* %i.addr to i64
  %10 = load i32, i32* %i.addr, align 4, !dbg !274
  %idxprom = sext i32 %10 to i64, !dbg !273
  %arrayidx = getelementptr inbounds double, double* %8, i64 %idxprom, !dbg !273
  %11 = ptrtoint double* %arrayidx to i64
  call void @__dp_read(i32 16389, i64 %11, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0))
  %12 = load double, double* %arrayidx, align 8, !dbg !273
  %add = fadd double %conv, %12, !dbg !275
  %conv1 = fptosi double %add to i32, !dbg !272
  %13 = ptrtoint i32* %z to i64
  store i32 %conv1, i32* %z, align 4, !dbg !271
  %14 = ptrtoint i32* %z to i64
  %15 = load i32, i32* %z, align 4, !dbg !276
  %add2 = add nsw i32 %15, 2, !dbg !277
  %conv3 = sitofp i32 %add2 to double, !dbg !276
  %16 = ptrtoint double** %tmp.addr to i64
  %17 = load double*, double** %tmp.addr, align 8, !dbg !278
  %18 = ptrtoint i32* %i.addr to i64
  %19 = load i32, i32* %i.addr, align 4, !dbg !279
  %idxprom4 = sext i32 %19 to i64, !dbg !278
  %arrayidx5 = getelementptr inbounds double, double* %17, i64 %idxprom4, !dbg !278
  %20 = ptrtoint double* %arrayidx5 to i64
  call void @__dp_write(i32 16390, i64 %20, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0))
  store double %conv3, double* %arrayidx5, align 8, !dbg !280
  call void @__dp_report_bb(i32 0)
  call void @__dp_func_exit(i32 16391, i32 0), !dbg !281
  ret void, !dbg !281
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline norecurse nounwind optnone uwtable
define i32 @main(i32 %argc, i8** %argv) #2 !dbg !2 {
entry:
  call void @__dp_func_entry(i32 16393, i32 1)
  %__dp_bb = alloca i32, align 4
  store i32 0, i32* %__dp_bb, align 4
  %retval = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  %argc.addr = alloca i32, align 4
  %1 = ptrtoint i32* %argc.addr to i64
  %argv.addr = alloca i8**, align 8
  %2 = ptrtoint i8*** %argv.addr to i64
  %x = alloca double*, align 8
  %3 = ptrtoint double** %x to i64
  %i = alloca i32, align 4
  %4 = ptrtoint i32* %i to i64
  %5 = ptrtoint i32* %retval to i64
  store i32 0, i32* %retval, align 4
  %6 = ptrtoint i32* %argc.addr to i64
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !282, metadata !DIExpression()), !dbg !283
  %7 = ptrtoint i8*** %argv.addr to i64
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !284, metadata !DIExpression()), !dbg !285
  call void @llvm.dbg.declare(metadata double** %x, metadata !286, metadata !DIExpression()), !dbg !287
  %8 = ptrtoint i32* @_ZZ4mainE1n to i64
  call void @__dp_read(i32 16395, i64 %8, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.6, i32 0, i32 0))
  %9 = load i32, i32* @_ZZ4mainE1n, align 4, !dbg !288
  %conv = sext i32 %9 to i64, !dbg !288
  %mul = mul i64 %conv, 8, !dbg !289
  %call = call noalias i8* @malloc(i64 %mul) #4, !dbg !290
  %10 = ptrtoint i8* %call to i64
  call void @__dp_new(i32 16395, i64 %10, i64 %10, i64 %mul), !dbg !291
  %11 = bitcast i8* %call to double*, !dbg !291
  %12 = ptrtoint double** %x to i64
  store double* %11, double** %x, align 8, !dbg !287
  call void @llvm.dbg.declare(metadata i32* %i, metadata !292, metadata !DIExpression()), !dbg !294
  %13 = ptrtoint i32* %i to i64
  store i32 0, i32* %i, align 4, !dbg !294
  call void @__dp_report_bb(i32 1)
  br label %for.cond, !dbg !295

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16398, i32 0)
  %14 = ptrtoint i32* %i to i64
  %15 = load i32, i32* %i, align 4, !dbg !296
  %16 = ptrtoint i32* @_ZZ4mainE1n to i64
  call void @__dp_read(i32 16398, i64 %16, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.6, i32 0, i32 0))
  %17 = load i32, i32* @_ZZ4mainE1n, align 4, !dbg !298
  %cmp = icmp slt i32 %15, %17, !dbg !299
  call void @__dp_incr_taken_branch_counter(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.3, i32 0, i32 0), i1 %cmp, i32 1), !dbg !300
  call void @__dp_incr_taken_branch_counter(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.4, i32 0, i32 0), i1 %cmp, i32 1), !dbg !300
  call void @__dp_incr_taken_branch_counter(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.5, i32 0, i32 0), i1 %cmp, i32 0), !dbg !300
  call void @__dp_report_bb(i32 3)
  %18 = load i32, i32* %__dp_bb, align 4
  call void @__dp_report_bb_pair(i32 %18, i32 6)
  br i1 %cmp, label %for.body, label %for.end, !dbg !300

for.body:                                         ; preds = %for.cond
  call void @__dp_loop_incr(i32 1)
  %19 = ptrtoint double** %x to i64
  %20 = load double*, double** %x, align 8, !dbg !301
  %21 = ptrtoint i32* %i to i64
  %22 = load i32, i32* %i, align 4, !dbg !303
  %idxprom = sext i32 %22 to i64, !dbg !301
  %arrayidx = getelementptr inbounds double, double* %20, i64 %idxprom, !dbg !301
  %23 = ptrtoint double* %arrayidx to i64
  call void @__dp_write(i32 16399, i64 %23, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.15, i32 0, i32 0))
  store double 1.000000e+00, double* %arrayidx, align 8, !dbg !304
  %24 = ptrtoint double** %x to i64
  %25 = load double*, double** %x, align 8, !dbg !305
  %26 = ptrtoint i32* %i to i64
  %27 = load i32, i32* %i, align 4, !dbg !306
  call void @__dp_call(i32 16400), !dbg !307
  call void @_Z14allowing_doallPdi(double* %25, i32 %27), !dbg !307
  call void @__dp_report_bb(i32 5)
  %28 = load i32, i32* %__dp_bb, align 4
  call void @__dp_report_bb_pair(i32 %28, i32 8)
  br label %for.inc, !dbg !308

for.inc:                                          ; preds = %for.body
  %29 = ptrtoint i32* %i to i64
  %30 = load i32, i32* %i, align 4, !dbg !309
  %inc = add nsw i32 %30, 1, !dbg !309
  %31 = ptrtoint i32* %i to i64
  store i32 %inc, i32* %i, align 4, !dbg !309
  call void @__dp_report_bb(i32 4)
  %32 = load i32, i32* %__dp_bb, align 4
  call void @__dp_report_bb_pair(i32 %32, i32 7)
  store i32 1, i32* %__dp_bb, align 4
  br label %for.cond, !dbg !310, !llvm.loop !311

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16402, i32 0)
  %33 = ptrtoint double** %x to i64
  %34 = load double*, double** %x, align 8, !dbg !313
  %35 = bitcast double* %34 to i8*, !dbg !313
  call void @free(i8* %35) #4, !dbg !314
  %36 = ptrtoint i8* %35 to i64
  call void @__dp_delete(i32 16402, i64 %36), !dbg !315
  call void @__dp_report_bb(i32 2)
  call void @__dp_finalize(i32 16403), !dbg !315
  call void @__dp_loop_output(), !dbg !315
  call void @__dp_taken_branch_counter_output(), !dbg !315
  ret i32 0, !dbg !315
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64) #3

; Function Attrs: nounwind
declare void @free(i8*) #3

declare void @__dp_init(i32, i32, i32)

declare void @__dp_finalize(i32)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_write(i32, i64, i8*)

declare void @__dp_alloca(i32, i8*, i64, i64, i64, i64)

declare void @__dp_new(i32, i64, i64, i64)

declare void @__dp_delete(i32, i64)

declare void @__dp_call(i32)

declare void @__dp_func_entry(i32, i32)

declare void @__dp_func_exit(i32, i32)

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_loop_exit(i32, i32)

declare void @__dp_incr_taken_branch_counter(i8*, i32, i32)

declare void @__dp_report_bb(i32)

declare void @__dp_report_bb_pair(i32, i32)

declare void @__dp_loop_incr(i32)

declare void @__dp_loop_output()

declare void @__dp_taken_branch_counter_output()

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { noinline norecurse nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!11}
!llvm.module.flags = !{!258, !259, !260, !261}
!llvm.ident = !{!262}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "n", scope: !2, file: !3, line: 10, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 9, type: !4, scopeLine: 9, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !11, retainedNodes: !12)
!3 = !DIFile(filename: "code.cpp", directory: "/home/lukas/git/discopop/test/end_to_end/do_all/calls/allowing/src")
!4 = !DISubroutineType(types: !5)
!5 = !{!6, !6, !7}
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 64)
!9 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !10)
!10 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!11 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !3, producer: "clang version 11.1.0 (https://github.com/llvm/llvm-project.git 7e99bddfeaab2713a8bb6ca538da25b66e6efc59)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !12, retainedTypes: !13, globals: !16, imports: !17, splitDebugInlining: false, nameTableKind: None)
!12 = !{}
!13 = !{!14}
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!15 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!16 = !{!0}
!17 = !{!18, !25, !29, !36, !40, !45, !47, !51, !55, !59, !73, !77, !81, !85, !89, !94, !98, !102, !106, !110, !118, !122, !126, !128, !132, !136, !141, !147, !151, !155, !157, !165, !169, !177, !179, !183, !187, !191, !195, !200, !205, !210, !211, !212, !213, !215, !216, !217, !218, !219, !220, !221, !223, !224, !225, !226, !227, !228, !229, !234, !235, !236, !237, !238, !239, !240, !241, !242, !243, !244, !245, !246, !247, !248, !249, !250, !251, !252, !253, !254, !255, !256, !257}
!18 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !20, file: !24, line: 52)
!19 = !DINamespace(name: "std", scope: null)
!20 = !DISubprogram(name: "abs", scope: !21, file: !21, line: 848, type: !22, flags: DIFlagPrototyped, spFlags: 0)
!21 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!22 = !DISubroutineType(types: !23)
!23 = !{!6, !6}
!24 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/12/../../../../include/c++/12/bits/std_abs.h", directory: "")
!25 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !26, file: !28, line: 127)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !21, line: 63, baseType: !27)
!27 = !DICompositeType(tag: DW_TAG_structure_type, file: !21, line: 59, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!28 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/12/../../../../include/c++/12/cstdlib", directory: "")
!29 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !30, file: !28, line: 128)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !21, line: 71, baseType: !31)
!31 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !21, line: 67, size: 128, flags: DIFlagTypePassByValue, elements: !32, identifier: "_ZTS6ldiv_t")
!32 = !{!33, !35}
!33 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !31, file: !21, line: 69, baseType: !34, size: 64)
!34 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !31, file: !21, line: 70, baseType: !34, size: 64, offset: 64)
!36 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !37, file: !28, line: 130)
!37 = !DISubprogram(name: "abort", scope: !21, file: !21, line: 598, type: !38, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!38 = !DISubroutineType(types: !39)
!39 = !{null}
!40 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !41, file: !28, line: 134)
!41 = !DISubprogram(name: "atexit", scope: !21, file: !21, line: 602, type: !42, flags: DIFlagPrototyped, spFlags: 0)
!42 = !DISubroutineType(types: !43)
!43 = !{!6, !44}
!44 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !38, size: 64)
!45 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !46, file: !28, line: 137)
!46 = !DISubprogram(name: "at_quick_exit", scope: !21, file: !21, line: 607, type: !42, flags: DIFlagPrototyped, spFlags: 0)
!47 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !48, file: !28, line: 140)
!48 = !DISubprogram(name: "atof", scope: !21, file: !21, line: 102, type: !49, flags: DIFlagPrototyped, spFlags: 0)
!49 = !DISubroutineType(types: !50)
!50 = !{!15, !8}
!51 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !52, file: !28, line: 141)
!52 = !DISubprogram(name: "atoi", scope: !21, file: !21, line: 105, type: !53, flags: DIFlagPrototyped, spFlags: 0)
!53 = !DISubroutineType(types: !54)
!54 = !{!6, !8}
!55 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !56, file: !28, line: 142)
!56 = !DISubprogram(name: "atol", scope: !21, file: !21, line: 108, type: !57, flags: DIFlagPrototyped, spFlags: 0)
!57 = !DISubroutineType(types: !58)
!58 = !{!34, !8}
!59 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !60, file: !28, line: 143)
!60 = !DISubprogram(name: "bsearch", scope: !21, file: !21, line: 828, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!61 = !DISubroutineType(types: !62)
!62 = !{!63, !64, !64, !66, !66, !69}
!63 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !65, size: 64)
!65 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!66 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !67, line: 46, baseType: !68)
!67 = !DIFile(filename: "Software/llvm-11.1.0/lib/clang/11.1.0/include/stddef.h", directory: "/home/lukas")
!68 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!69 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !21, line: 816, baseType: !70)
!70 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !71, size: 64)
!71 = !DISubroutineType(types: !72)
!72 = !{!6, !64, !64}
!73 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !74, file: !28, line: 144)
!74 = !DISubprogram(name: "calloc", scope: !21, file: !21, line: 543, type: !75, flags: DIFlagPrototyped, spFlags: 0)
!75 = !DISubroutineType(types: !76)
!76 = !{!63, !66, !66}
!77 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !78, file: !28, line: 145)
!78 = !DISubprogram(name: "div", scope: !21, file: !21, line: 860, type: !79, flags: DIFlagPrototyped, spFlags: 0)
!79 = !DISubroutineType(types: !80)
!80 = !{!26, !6, !6}
!81 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !82, file: !28, line: 146)
!82 = !DISubprogram(name: "exit", scope: !21, file: !21, line: 624, type: !83, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!83 = !DISubroutineType(types: !84)
!84 = !{null, !6}
!85 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !86, file: !28, line: 147)
!86 = !DISubprogram(name: "free", scope: !21, file: !21, line: 555, type: !87, flags: DIFlagPrototyped, spFlags: 0)
!87 = !DISubroutineType(types: !88)
!88 = !{null, !63}
!89 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !90, file: !28, line: 148)
!90 = !DISubprogram(name: "getenv", scope: !21, file: !21, line: 641, type: !91, flags: DIFlagPrototyped, spFlags: 0)
!91 = !DISubroutineType(types: !92)
!92 = !{!93, !8}
!93 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!94 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !95, file: !28, line: 149)
!95 = !DISubprogram(name: "labs", scope: !21, file: !21, line: 849, type: !96, flags: DIFlagPrototyped, spFlags: 0)
!96 = !DISubroutineType(types: !97)
!97 = !{!34, !34}
!98 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !99, file: !28, line: 150)
!99 = !DISubprogram(name: "ldiv", scope: !21, file: !21, line: 862, type: !100, flags: DIFlagPrototyped, spFlags: 0)
!100 = !DISubroutineType(types: !101)
!101 = !{!30, !34, !34}
!102 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !103, file: !28, line: 151)
!103 = !DISubprogram(name: "malloc", scope: !21, file: !21, line: 540, type: !104, flags: DIFlagPrototyped, spFlags: 0)
!104 = !DISubroutineType(types: !105)
!105 = !{!63, !66}
!106 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !107, file: !28, line: 153)
!107 = !DISubprogram(name: "mblen", scope: !21, file: !21, line: 930, type: !108, flags: DIFlagPrototyped, spFlags: 0)
!108 = !DISubroutineType(types: !109)
!109 = !{!6, !8, !66}
!110 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !111, file: !28, line: 154)
!111 = !DISubprogram(name: "mbstowcs", scope: !21, file: !21, line: 941, type: !112, flags: DIFlagPrototyped, spFlags: 0)
!112 = !DISubroutineType(types: !113)
!113 = !{!66, !114, !117, !66}
!114 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !115)
!115 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !116, size: 64)
!116 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!117 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !8)
!118 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !119, file: !28, line: 155)
!119 = !DISubprogram(name: "mbtowc", scope: !21, file: !21, line: 933, type: !120, flags: DIFlagPrototyped, spFlags: 0)
!120 = !DISubroutineType(types: !121)
!121 = !{!6, !114, !117, !66}
!122 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !123, file: !28, line: 157)
!123 = !DISubprogram(name: "qsort", scope: !21, file: !21, line: 838, type: !124, flags: DIFlagPrototyped, spFlags: 0)
!124 = !DISubroutineType(types: !125)
!125 = !{null, !63, !66, !66, !69}
!126 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !127, file: !28, line: 160)
!127 = !DISubprogram(name: "quick_exit", scope: !21, file: !21, line: 630, type: !83, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!128 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !129, file: !28, line: 163)
!129 = !DISubprogram(name: "rand", scope: !21, file: !21, line: 454, type: !130, flags: DIFlagPrototyped, spFlags: 0)
!130 = !DISubroutineType(types: !131)
!131 = !{!6}
!132 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !133, file: !28, line: 164)
!133 = !DISubprogram(name: "realloc", scope: !21, file: !21, line: 551, type: !134, flags: DIFlagPrototyped, spFlags: 0)
!134 = !DISubroutineType(types: !135)
!135 = !{!63, !63, !66}
!136 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !137, file: !28, line: 165)
!137 = !DISubprogram(name: "srand", scope: !21, file: !21, line: 456, type: !138, flags: DIFlagPrototyped, spFlags: 0)
!138 = !DISubroutineType(types: !139)
!139 = !{null, !140}
!140 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!141 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !142, file: !28, line: 166)
!142 = !DISubprogram(name: "strtod", scope: !21, file: !21, line: 118, type: !143, flags: DIFlagPrototyped, spFlags: 0)
!143 = !DISubroutineType(types: !144)
!144 = !{!15, !117, !145}
!145 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !146)
!146 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !93, size: 64)
!147 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !148, file: !28, line: 167)
!148 = !DISubprogram(name: "strtol", scope: !21, file: !21, line: 177, type: !149, flags: DIFlagPrototyped, spFlags: 0)
!149 = !DISubroutineType(types: !150)
!150 = !{!34, !117, !145, !6}
!151 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !152, file: !28, line: 168)
!152 = !DISubprogram(name: "strtoul", scope: !21, file: !21, line: 181, type: !153, flags: DIFlagPrototyped, spFlags: 0)
!153 = !DISubroutineType(types: !154)
!154 = !{!68, !117, !145, !6}
!155 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !156, file: !28, line: 169)
!156 = !DISubprogram(name: "system", scope: !21, file: !21, line: 791, type: !53, flags: DIFlagPrototyped, spFlags: 0)
!157 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !158, file: !28, line: 171)
!158 = !DISubprogram(name: "wcstombs", scope: !21, file: !21, line: 945, type: !159, flags: DIFlagPrototyped, spFlags: 0)
!159 = !DISubroutineType(types: !160)
!160 = !{!66, !161, !162, !66}
!161 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !93)
!162 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !163)
!163 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !164, size: 64)
!164 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !116)
!165 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !166, file: !28, line: 172)
!166 = !DISubprogram(name: "wctomb", scope: !21, file: !21, line: 937, type: !167, flags: DIFlagPrototyped, spFlags: 0)
!167 = !DISubroutineType(types: !168)
!168 = !{!6, !93, !116}
!169 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !170, entity: !171, file: !28, line: 200)
!170 = !DINamespace(name: "__gnu_cxx", scope: null)
!171 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !21, line: 81, baseType: !172)
!172 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !21, line: 77, size: 128, flags: DIFlagTypePassByValue, elements: !173, identifier: "_ZTS7lldiv_t")
!173 = !{!174, !176}
!174 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !172, file: !21, line: 79, baseType: !175, size: 64)
!175 = !DIBasicType(name: "long long int", size: 64, encoding: DW_ATE_signed)
!176 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !172, file: !21, line: 80, baseType: !175, size: 64, offset: 64)
!177 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !170, entity: !178, file: !28, line: 206)
!178 = !DISubprogram(name: "_Exit", scope: !21, file: !21, line: 636, type: !83, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!179 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !170, entity: !180, file: !28, line: 210)
!180 = !DISubprogram(name: "llabs", scope: !21, file: !21, line: 852, type: !181, flags: DIFlagPrototyped, spFlags: 0)
!181 = !DISubroutineType(types: !182)
!182 = !{!175, !175}
!183 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !170, entity: !184, file: !28, line: 216)
!184 = !DISubprogram(name: "lldiv", scope: !21, file: !21, line: 866, type: !185, flags: DIFlagPrototyped, spFlags: 0)
!185 = !DISubroutineType(types: !186)
!186 = !{!171, !175, !175}
!187 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !170, entity: !188, file: !28, line: 227)
!188 = !DISubprogram(name: "atoll", scope: !21, file: !21, line: 113, type: !189, flags: DIFlagPrototyped, spFlags: 0)
!189 = !DISubroutineType(types: !190)
!190 = !{!175, !8}
!191 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !170, entity: !192, file: !28, line: 228)
!192 = !DISubprogram(name: "strtoll", scope: !21, file: !21, line: 201, type: !193, flags: DIFlagPrototyped, spFlags: 0)
!193 = !DISubroutineType(types: !194)
!194 = !{!175, !117, !145, !6}
!195 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !170, entity: !196, file: !28, line: 229)
!196 = !DISubprogram(name: "strtoull", scope: !21, file: !21, line: 206, type: !197, flags: DIFlagPrototyped, spFlags: 0)
!197 = !DISubroutineType(types: !198)
!198 = !{!199, !117, !145, !6}
!199 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!200 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !170, entity: !201, file: !28, line: 231)
!201 = !DISubprogram(name: "strtof", scope: !21, file: !21, line: 124, type: !202, flags: DIFlagPrototyped, spFlags: 0)
!202 = !DISubroutineType(types: !203)
!203 = !{!204, !117, !145}
!204 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!205 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !170, entity: !206, file: !28, line: 232)
!206 = !DISubprogram(name: "strtold", scope: !21, file: !21, line: 127, type: !207, flags: DIFlagPrototyped, spFlags: 0)
!207 = !DISubroutineType(types: !208)
!208 = !{!209, !117, !145}
!209 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!210 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !171, file: !28, line: 240)
!211 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !178, file: !28, line: 242)
!212 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !180, file: !28, line: 244)
!213 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !214, file: !28, line: 245)
!214 = !DISubprogram(name: "div", linkageName: "_ZN9__gnu_cxx3divExx", scope: !170, file: !28, line: 213, type: !185, flags: DIFlagPrototyped, spFlags: 0)
!215 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !184, file: !28, line: 246)
!216 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !188, file: !28, line: 248)
!217 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !201, file: !28, line: 249)
!218 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !192, file: !28, line: 250)
!219 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !196, file: !28, line: 251)
!220 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !206, file: !28, line: 252)
!221 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !37, file: !222, line: 38)
!222 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/12/../../../../include/c++/12/stdlib.h", directory: "")
!223 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !41, file: !222, line: 39)
!224 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !82, file: !222, line: 40)
!225 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !46, file: !222, line: 43)
!226 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !127, file: !222, line: 46)
!227 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !26, file: !222, line: 51)
!228 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !30, file: !222, line: 52)
!229 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !230, file: !222, line: 54)
!230 = !DISubprogram(name: "abs", linkageName: "_ZSt3absg", scope: !19, file: !24, line: 103, type: !231, flags: DIFlagPrototyped, spFlags: 0)
!231 = !DISubroutineType(types: !232)
!232 = !{!233, !233}
!233 = !DIBasicType(name: "__float128", size: 128, encoding: DW_ATE_float)
!234 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !48, file: !222, line: 55)
!235 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !52, file: !222, line: 56)
!236 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !56, file: !222, line: 57)
!237 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !60, file: !222, line: 58)
!238 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !74, file: !222, line: 59)
!239 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !214, file: !222, line: 60)
!240 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !86, file: !222, line: 61)
!241 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !90, file: !222, line: 62)
!242 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !95, file: !222, line: 63)
!243 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !99, file: !222, line: 64)
!244 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !103, file: !222, line: 65)
!245 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !107, file: !222, line: 67)
!246 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !111, file: !222, line: 68)
!247 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !119, file: !222, line: 69)
!248 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !123, file: !222, line: 71)
!249 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !129, file: !222, line: 72)
!250 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !133, file: !222, line: 73)
!251 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !137, file: !222, line: 74)
!252 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !142, file: !222, line: 75)
!253 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !148, file: !222, line: 76)
!254 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !152, file: !222, line: 77)
!255 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !156, file: !222, line: 78)
!256 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !158, file: !222, line: 80)
!257 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !166, file: !222, line: 81)
!258 = !{i32 7, !"Dwarf Version", i32 4}
!259 = !{i32 2, !"Debug Info Version", i32 3}
!260 = !{i32 1, !"wchar_size", i32 4}
!261 = !{i32 7, !"PIC Level", i32 2}
!262 = !{!"clang version 11.1.0 (https://github.com/llvm/llvm-project.git 7e99bddfeaab2713a8bb6ca538da25b66e6efc59)"}
!263 = distinct !DISubprogram(name: "allowing_doall", linkageName: "_Z14allowing_doallPdi", scope: !3, file: !3, line: 4, type: !264, scopeLine: 4, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !11, retainedNodes: !12)
!264 = !DISubroutineType(types: !265)
!265 = !{null, !14, !6}
!266 = !DILocalVariable(name: "tmp", arg: 1, scope: !263, file: !3, line: 4, type: !14)
!267 = !DILocation(line: 4, column: 29, scope: !263)
!268 = !DILocalVariable(name: "i", arg: 2, scope: !263, file: !3, line: 4, type: !6)
!269 = !DILocation(line: 4, column: 38, scope: !263)
!270 = !DILocalVariable(name: "z", scope: !263, file: !3, line: 5, type: !6)
!271 = !DILocation(line: 5, column: 7, scope: !263)
!272 = !DILocation(line: 5, column: 11, scope: !263)
!273 = !DILocation(line: 5, column: 15, scope: !263)
!274 = !DILocation(line: 5, column: 19, scope: !263)
!275 = !DILocation(line: 5, column: 13, scope: !263)
!276 = !DILocation(line: 6, column: 12, scope: !263)
!277 = !DILocation(line: 6, column: 14, scope: !263)
!278 = !DILocation(line: 6, column: 3, scope: !263)
!279 = !DILocation(line: 6, column: 7, scope: !263)
!280 = !DILocation(line: 6, column: 10, scope: !263)
!281 = !DILocation(line: 7, column: 1, scope: !263)
!282 = !DILocalVariable(name: "argc", arg: 1, scope: !2, file: !3, line: 9, type: !6)
!283 = !DILocation(line: 9, column: 14, scope: !2)
!284 = !DILocalVariable(name: "argv", arg: 2, scope: !2, file: !3, line: 9, type: !7)
!285 = !DILocation(line: 9, column: 32, scope: !2)
!286 = !DILocalVariable(name: "x", scope: !2, file: !3, line: 11, type: !14)
!287 = !DILocation(line: 11, column: 11, scope: !2)
!288 = !DILocation(line: 11, column: 32, scope: !2)
!289 = !DILocation(line: 11, column: 34, scope: !2)
!290 = !DILocation(line: 11, column: 25, scope: !2)
!291 = !DILocation(line: 11, column: 15, scope: !2)
!292 = !DILocalVariable(name: "i", scope: !293, file: !3, line: 14, type: !6)
!293 = distinct !DILexicalBlock(scope: !2, file: !3, line: 14, column: 3)
!294 = !DILocation(line: 14, column: 12, scope: !293)
!295 = !DILocation(line: 14, column: 8, scope: !293)
!296 = !DILocation(line: 14, column: 19, scope: !297)
!297 = distinct !DILexicalBlock(scope: !293, file: !3, line: 14, column: 3)
!298 = !DILocation(line: 14, column: 23, scope: !297)
!299 = !DILocation(line: 14, column: 21, scope: !297)
!300 = !DILocation(line: 14, column: 3, scope: !293)
!301 = !DILocation(line: 15, column: 5, scope: !302)
!302 = distinct !DILexicalBlock(scope: !297, file: !3, line: 14, column: 31)
!303 = !DILocation(line: 15, column: 7, scope: !302)
!304 = !DILocation(line: 15, column: 10, scope: !302)
!305 = !DILocation(line: 16, column: 20, scope: !302)
!306 = !DILocation(line: 16, column: 23, scope: !302)
!307 = !DILocation(line: 16, column: 5, scope: !302)
!308 = !DILocation(line: 17, column: 3, scope: !302)
!309 = !DILocation(line: 14, column: 26, scope: !297)
!310 = !DILocation(line: 14, column: 3, scope: !297)
!311 = distinct !{!311, !300, !312}
!312 = !DILocation(line: 17, column: 3, scope: !293)
!313 = !DILocation(line: 18, column: 8, scope: !2)
!314 = !DILocation(line: 18, column: 3, scope: !2)
!315 = !DILocation(line: 19, column: 3, scope: !2)
