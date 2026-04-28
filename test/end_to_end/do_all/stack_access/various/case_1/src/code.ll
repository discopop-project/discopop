; ModuleID = 'code.cpp'
source_filename = "code.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@_ZZ4mainE1n = internal global i32 1000, align 4, !dbg !0
@.str = private unnamed_addr constant [2 x i8] c"t\00", align 1
@.str.1 = private unnamed_addr constant [12 x i8] c"_ZZ4mainE1n\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"argc\00", align 1
@.str.4 = private unnamed_addr constant [5 x i8] c"argv\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"k\00", align 1
@.str.7 = private unnamed_addr constant [2 x i8] c"s\00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.9 = private unnamed_addr constant [12 x i8] c"GEPRESULT_x\00", align 1
@.dp_bb_deps = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define noundef i32 @_Z1fi(i32 noundef %t) #0 !dbg !268 {
entry:
  call void @__dp_func_entry(i32 16388, i32 0), !dp.md.instr.id !269
  %t.addr = alloca i32, align 4, !dp.md.instr.id !270
  %0 = ptrtoint ptr %t.addr to i64, !dp.md.instr.id !271
  call void @__dp_alloca(i32 16388, ptr @.str, i64 %0, i64 %0, i64 4, i64 1), !dp.md.instr.id !272
  %1 = ptrtoint ptr %t.addr to i64
  call void @__dp_write(i32 6, i64 %1, ptr @.str)
  store i32 %t, ptr %t.addr, align 4, !dp.md.instr.id !273
    #dbg_declare(ptr %t.addr, !274, !DIExpression(), !275)
  %2 = ptrtoint ptr %t.addr to i64
  call void @__dp_read(i32 7, i64 %2, ptr @.str)
  %3 = load i32, ptr %t.addr, align 4, !dbg !276, !dp.md.instr.id !277
  %mul = mul nsw i32 %3, 42, !dbg !278, !dp.md.instr.id !279
  %4 = ptrtoint ptr %t.addr to i64
  call void @__dp_read(i32 9, i64 %4, ptr @.str)
  %5 = load i32, ptr %t.addr, align 4, !dbg !280, !dp.md.instr.id !281
  %add = add nsw i32 %mul, %5, !dbg !282, !dp.md.instr.id !283
  %sub = sub nsw i32 %add, 2, !dbg !284, !dp.md.instr.id !285
  %6 = ptrtoint ptr %t.addr to i64
  call void @__dp_write(i32 12, i64 %6, ptr @.str)
  store i32 %sub, ptr %t.addr, align 4, !dbg !286, !dp.md.instr.id !287
  %7 = ptrtoint ptr %t.addr to i64
  call void @__dp_read(i32 13, i64 %7, ptr @.str)
  %8 = load i32, ptr %t.addr, align 4, !dbg !288, !dp.md.instr.id !289
  call void @__dp_func_exit(i32 16390, i32 0), !dbg !290
  ret i32 %8, !dbg !290, !dp.md.instr.id !291
}

; Function Attrs: mustprogress noinline norecurse nounwind optnone uwtable
define noundef i32 @main(i32 noundef %argc, ptr noundef %argv) #1 !dbg !2 {
entry:
  call void @__dp_func_entry(i32 16393, i32 1), !dp.md.instr.id !292
  %retval = alloca i32, align 4, !dp.md.instr.id !293
  %0 = ptrtoint ptr %retval to i64, !dp.md.instr.id !294
  call void @__dp_alloca(i32 16393, ptr @.str.2, i64 %0, i64 %0, i64 4, i64 1), !dp.md.instr.id !295
  %argc.addr = alloca i32, align 4, !dp.md.instr.id !296
  %1 = ptrtoint ptr %argc.addr to i64, !dp.md.instr.id !297
  call void @__dp_alloca(i32 16393, ptr @.str.3, i64 %1, i64 %1, i64 4, i64 1), !dp.md.instr.id !298
  %argv.addr = alloca ptr, align 8, !dp.md.instr.id !299
  %2 = ptrtoint ptr %argv.addr to i64, !dp.md.instr.id !300
  call void @__dp_alloca(i32 16393, ptr @.str.4, i64 %2, i64 %2, i64 0, i64 1), !dp.md.instr.id !301
  %x = alloca ptr, align 8, !dp.md.instr.id !302
  %3 = ptrtoint ptr %x to i64, !dp.md.instr.id !303
  call void @__dp_alloca(i32 16393, ptr @.str.5, i64 %3, i64 %3, i64 0, i64 1), !dp.md.instr.id !304
  %k = alloca i32, align 4, !dp.md.instr.id !305
  %4 = ptrtoint ptr %k to i64, !dp.md.instr.id !306
  call void @__dp_alloca(i32 16393, ptr @.str.6, i64 %4, i64 %4, i64 4, i64 1), !dp.md.instr.id !307
  %s = alloca i32, align 4, !dp.md.instr.id !308
  %5 = ptrtoint ptr %s to i64, !dp.md.instr.id !309
  call void @__dp_alloca(i32 16393, ptr @.str.7, i64 %5, i64 %5, i64 4, i64 1), !dp.md.instr.id !310
  %i = alloca i32, align 4, !dp.md.instr.id !311
  %6 = ptrtoint ptr %i to i64, !dp.md.instr.id !312
  call void @__dp_alloca(i32 16393, ptr @.str.8, i64 %6, i64 %6, i64 4, i64 1), !dp.md.instr.id !313
  %7 = ptrtoint ptr %retval to i64
  call void @__dp_write(i32 37, i64 %7, ptr @.str.2)
  store i32 0, ptr %retval, align 4, !dp.md.instr.id !314
  %8 = ptrtoint ptr %argc.addr to i64
  call void @__dp_write(i32 38, i64 %8, ptr @.str.3)
  store i32 %argc, ptr %argc.addr, align 4, !dp.md.instr.id !315
    #dbg_declare(ptr %argc.addr, !316, !DIExpression(), !317)
  %9 = ptrtoint ptr %argv.addr to i64
  call void @__dp_write(i32 39, i64 %9, ptr @.str.4)
  store ptr %argv, ptr %argv.addr, align 8, !dp.md.instr.id !318
    #dbg_declare(ptr %argv.addr, !319, !DIExpression(), !320)
    #dbg_declare(ptr %x, !321, !DIExpression(), !322)
  %10 = ptrtoint ptr @_ZZ4mainE1n to i64
  call void @__dp_read(i32 40, i64 %10, ptr @.str.1)
  %11 = load i32, ptr @_ZZ4mainE1n, align 4, !dbg !323, !dp.md.instr.id !324
  %conv = sext i32 %11 to i64, !dbg !323, !dp.md.instr.id !325
  %mul = mul i64 %conv, 8, !dbg !326, !dp.md.instr.id !327
  %call = call noalias ptr @malloc(i64 noundef %mul) #4, !dbg !328, !dp.md.instr.id !329
  %12 = ptrtoint ptr %call to i64, !dp.md.instr.id !330
  call void @__dp_new(i32 16395, i64 %12, i64 %12, i64 %mul), !dbg !322, !dp.md.instr.id !331
  %13 = ptrtoint ptr %x to i64
  call void @__dp_write(i32 46, i64 %13, ptr @.str.5)
  store ptr %call, ptr %x, align 8, !dbg !322, !dp.md.instr.id !332
    #dbg_declare(ptr %k, !333, !DIExpression(), !334)
  %14 = ptrtoint ptr %k to i64
  call void @__dp_write(i32 47, i64 %14, ptr @.str.6)
  store i32 0, ptr %k, align 4, !dbg !334, !dp.md.instr.id !335
    #dbg_declare(ptr %s, !336, !DIExpression(), !337)
  %15 = ptrtoint ptr %s to i64
  call void @__dp_write(i32 48, i64 %15, ptr @.str.7)
  store i32 0, ptr %s, align 4, !dbg !337, !dp.md.instr.id !338
    #dbg_declare(ptr %i, !339, !DIExpression(), !341)
  %16 = ptrtoint ptr %i to i64
  call void @__dp_write(i32 49, i64 %16, ptr @.str.8)
  store i32 0, ptr %i, align 4, !dbg !341, !dp.md.instr.id !342
  br label %for.cond, !dbg !343, !dp.md.instr.id !344

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16399, i32 0, i32 51), !dp.md.instr.id !345
  %17 = ptrtoint ptr %i to i64
  call void @__dp_read(i32 52, i64 %17, ptr @.str.8)
  %18 = load i32, ptr %i, align 4, !dbg !346, !dp.md.instr.id !348
  %19 = ptrtoint ptr @_ZZ4mainE1n to i64
  call void @__dp_read(i32 53, i64 %19, ptr @.str.1)
  %20 = load i32, ptr @_ZZ4mainE1n, align 4, !dbg !349, !dp.md.instr.id !350
  %cmp = icmp slt i32 %18, %20, !dbg !351, !dp.md.instr.id !352
  br i1 %cmp, label %for.body, label %for.end, !dbg !353, !dp.md.instr.id !354

for.body:                                         ; preds = %for.cond
  call void @__dp_loop_incr(i32 0, i32 80), !dp.md.instr.id !355
  %21 = ptrtoint ptr %i to i64
  call void @__dp_read(i32 56, i64 %21, ptr @.str.8)
  %22 = load i32, ptr %i, align 4, !dbg !356, !dp.md.instr.id !358
  call void @__dp_call(i32 57, i8 0), !dbg !359
  %call1 = call noundef i32 @_Z1fi(i32 noundef %22), !dbg !359, !dp.md.instr.id !360
  %23 = ptrtoint ptr %s to i64
  call void @__dp_write(i32 58, i64 %23, ptr @.str.7)
  store i32 %call1, ptr %s, align 4, !dbg !361, !dp.md.instr.id !362
  %24 = ptrtoint ptr %s to i64
  call void @__dp_read(i32 59, i64 %24, ptr @.str.7)
  %25 = load i32, ptr %s, align 4, !dbg !363, !dp.md.instr.id !364
  %conv2 = sitofp i32 %25 to double, !dbg !363, !dp.md.instr.id !365
  %26 = ptrtoint ptr %x to i64
  call void @__dp_read(i32 61, i64 %26, ptr @.str.5)
  %27 = load ptr, ptr %x, align 8, !dbg !366, !dp.md.instr.id !367
  %28 = ptrtoint ptr %i to i64
  call void @__dp_read(i32 62, i64 %28, ptr @.str.8)
  %29 = load i32, ptr %i, align 4, !dbg !368, !dp.md.instr.id !369
  %idxprom = sext i32 %29 to i64, !dbg !366, !dp.md.instr.id !370
  %arrayidx = getelementptr inbounds double, ptr %27, i64 %idxprom, !dbg !366, !dp.md.instr.id !371
  %30 = ptrtoint ptr %arrayidx to i64
  call void @__dp_write(i32 65, i64 %30, ptr @.str.9)
  store double %conv2, ptr %arrayidx, align 8, !dbg !372, !dp.md.instr.id !373
  br label %for.inc, !dbg !374, !dp.md.instr.id !375

for.inc:                                          ; preds = %for.body
  %31 = ptrtoint ptr %i to i64
  call void @__dp_read(i32 67, i64 %31, ptr @.str.8)
  %32 = load i32, ptr %i, align 4, !dbg !376, !dp.md.instr.id !377
  %inc = add nsw i32 %32, 1, !dbg !376, !dp.md.instr.id !378
  %33 = ptrtoint ptr %i to i64
  call void @__dp_write(i32 69, i64 %33, ptr @.str.8)
  store i32 %inc, ptr %i, align 4, !dbg !376, !dp.md.instr.id !379
  br label %for.cond, !dbg !380, !llvm.loop !381, !dp.md.instr.id !384

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16403, i32 0, i32 71), !dp.md.instr.id !385
  %34 = ptrtoint ptr %s to i64
  call void @__dp_read(i32 72, i64 %34, ptr @.str.7)
  %35 = load i32, ptr %s, align 4, !dbg !386, !dp.md.instr.id !387
  call void @__dp_call(i32 73, i8 0), !dbg !388
  %call3 = call noundef i32 @_Z1fi(i32 noundef %35), !dbg !388, !dp.md.instr.id !389
  %36 = ptrtoint ptr %k to i64
  call void @__dp_write(i32 74, i64 %36, ptr @.str.6)
  store i32 %call3, ptr %k, align 4, !dbg !390, !dp.md.instr.id !391
  %37 = ptrtoint ptr %x to i64
  call void @__dp_read(i32 75, i64 %37, ptr @.str.5)
  %38 = load ptr, ptr %x, align 8, !dbg !392, !dp.md.instr.id !393
  call void @free(ptr noundef %38) #5, !dbg !394, !dp.md.instr.id !395
  %39 = ptrtoint ptr %38 to i64, !dp.md.instr.id !396
  call void @__dp_delete(i32 16405, i64 %39), !dbg !397, !dp.md.instr.id !398
  call void @__dp_add_bb_deps(ptr @.dp_bb_deps)
  call void @__dp_finalize(i32 16406), !dbg !397
  call void @__dp_loop_output(), !dbg !397
  ret i32 0, !dbg !397, !dp.md.instr.id !399
}

; Function Attrs: nounwind allocsize(0)
declare noalias ptr @malloc(i64 noundef) #2

; Function Attrs: nounwind
declare void @free(ptr noundef) #3

declare void @__dp_init(i32, i32, i32)

declare void @__dp_finalize(i32)

declare void @__dp_read(i32, i64, ptr)

declare void @__dp_write(i32, i64, ptr)

declare void @__dp_alloca(i32, ptr, i64, i64, i64, i64)

declare void @__dp_new(i32, i64, i64, i64)

declare void @__dp_delete(i32, i64)

declare void @__dp_call(i32, i8)

declare void @__dp_func_entry(i32, i32)

declare void @__dp_func_exit(i32, i32)

declare void @__dp_loop_entry(i32, i32, i32)

declare void @__dp_loop_exit(i32, i32, i32)

declare void @__dp_incr_taken_branch_counter(ptr, i32, i32)

declare void @__dp_report_bb(i32)

declare void @__dp_report_bb_pair(i32, i32)

declare void @__dp_loop_incr(i32, i32)

declare void @__dp_loop_output()

declare void @__dp_taken_branch_counter_output()

declare void @__dp_add_bb_deps(ptr)

attributes #0 = { mustprogress noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress noinline norecurse nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind allocsize(0) }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!11}
!llvm.module.flags = !{!261, !262, !263, !264, !265, !266}
!llvm.ident = !{!267}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "n", scope: !2, file: !3, line: 10, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 9, type: !4, scopeLine: 9, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !11, retainedNodes: !260)
!3 = !DIFile(filename: "code.cpp", directory: "/home/lukas/git/discopop/test/end_to_end/do_all/stack_access/various/case_1/src", checksumkind: CSK_MD5, checksum: "1cca23a10c37bde03f4d7e3e2e3e1bd2")
!4 = !DISubroutineType(types: !5)
!5 = !{!6, !6, !7}
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 64)
!9 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !10)
!10 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!11 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !3, producer: "Ubuntu clang version 19.1.1 (1ubuntu1~24.04.2)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !12, globals: !15, imports: !16, splitDebugInlining: false, nameTableKind: None)
!12 = !{!13}
!13 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!14 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!15 = !{!0}
!16 = !{!17, !24, !28, !35, !39, !47, !52, !54, !58, !62, !66, !76, !78, !82, !86, !90, !95, !99, !103, !107, !111, !119, !123, !127, !129, !133, !137, !142, !148, !152, !156, !158, !166, !170, !178, !180, !184, !188, !192, !196, !201, !206, !211, !212, !213, !214, !216, !217, !218, !219, !220, !221, !222, !224, !225, !226, !227, !228, !229, !230, !231, !236, !237, !238, !239, !240, !241, !242, !243, !244, !245, !246, !247, !248, !249, !250, !251, !252, !253, !254, !255, !256, !257, !258, !259}
!17 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !19, file: !23, line: 52)
!18 = !DINamespace(name: "std", scope: null)
!19 = !DISubprogram(name: "abs", scope: !20, file: !20, line: 980, type: !21, flags: DIFlagPrototyped, spFlags: 0)
!20 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!21 = !DISubroutineType(types: !22)
!22 = !{!6, !6}
!23 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/13/../../../../include/c++/13/bits/std_abs.h", directory: "")
!24 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !25, file: !27, line: 131)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !20, line: 63, baseType: !26)
!26 = !DICompositeType(tag: DW_TAG_structure_type, file: !20, line: 59, size: 64, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!27 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/13/../../../../include/c++/13/cstdlib", directory: "")
!28 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !29, file: !27, line: 132)
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !20, line: 71, baseType: !30)
!30 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !20, line: 67, size: 128, flags: DIFlagTypePassByValue, elements: !31, identifier: "_ZTS6ldiv_t")
!31 = !{!32, !34}
!32 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !30, file: !20, line: 69, baseType: !33, size: 64)
!33 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !30, file: !20, line: 70, baseType: !33, size: 64, offset: 64)
!35 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !36, file: !27, line: 134)
!36 = !DISubprogram(name: "abort", scope: !20, file: !20, line: 730, type: !37, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!37 = !DISubroutineType(types: !38)
!38 = !{null}
!39 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !40, file: !27, line: 136)
!40 = !DISubprogram(name: "aligned_alloc", scope: !20, file: !20, line: 724, type: !41, flags: DIFlagPrototyped, spFlags: 0)
!41 = !DISubroutineType(types: !42)
!42 = !{!43, !44, !44}
!43 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!44 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !45, line: 18, baseType: !46)
!45 = !DIFile(filename: "/usr/lib/llvm-19/lib/clang/19/include/__stddef_size_t.h", directory: "", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!46 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!47 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !48, file: !27, line: 138)
!48 = !DISubprogram(name: "atexit", scope: !20, file: !20, line: 734, type: !49, flags: DIFlagPrototyped, spFlags: 0)
!49 = !DISubroutineType(types: !50)
!50 = !{!6, !51}
!51 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64)
!52 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !53, file: !27, line: 141)
!53 = !DISubprogram(name: "at_quick_exit", scope: !20, file: !20, line: 739, type: !49, flags: DIFlagPrototyped, spFlags: 0)
!54 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !55, file: !27, line: 144)
!55 = !DISubprogram(name: "atof", scope: !20, file: !20, line: 102, type: !56, flags: DIFlagPrototyped, spFlags: 0)
!56 = !DISubroutineType(types: !57)
!57 = !{!14, !8}
!58 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !59, file: !27, line: 145)
!59 = !DISubprogram(name: "atoi", scope: !20, file: !20, line: 105, type: !60, flags: DIFlagPrototyped, spFlags: 0)
!60 = !DISubroutineType(types: !61)
!61 = !{!6, !8}
!62 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !63, file: !27, line: 146)
!63 = !DISubprogram(name: "atol", scope: !20, file: !20, line: 108, type: !64, flags: DIFlagPrototyped, spFlags: 0)
!64 = !DISubroutineType(types: !65)
!65 = !{!33, !8}
!66 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !67, file: !27, line: 147)
!67 = !DISubprogram(name: "bsearch", scope: !20, file: !20, line: 960, type: !68, flags: DIFlagPrototyped, spFlags: 0)
!68 = !DISubroutineType(types: !69)
!69 = !{!43, !70, !70, !44, !44, !72}
!70 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !71, size: 64)
!71 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!72 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !20, line: 948, baseType: !73)
!73 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !74, size: 64)
!74 = !DISubroutineType(types: !75)
!75 = !{!6, !70, !70}
!76 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !77, file: !27, line: 148)
!77 = !DISubprogram(name: "calloc", scope: !20, file: !20, line: 675, type: !41, flags: DIFlagPrototyped, spFlags: 0)
!78 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !79, file: !27, line: 149)
!79 = !DISubprogram(name: "div", scope: !20, file: !20, line: 992, type: !80, flags: DIFlagPrototyped, spFlags: 0)
!80 = !DISubroutineType(types: !81)
!81 = !{!25, !6, !6}
!82 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !83, file: !27, line: 150)
!83 = !DISubprogram(name: "exit", scope: !20, file: !20, line: 756, type: !84, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!84 = !DISubroutineType(types: !85)
!85 = !{null, !6}
!86 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !87, file: !27, line: 151)
!87 = !DISubprogram(name: "free", scope: !20, file: !20, line: 687, type: !88, flags: DIFlagPrototyped, spFlags: 0)
!88 = !DISubroutineType(types: !89)
!89 = !{null, !43}
!90 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !91, file: !27, line: 152)
!91 = !DISubprogram(name: "getenv", scope: !20, file: !20, line: 773, type: !92, flags: DIFlagPrototyped, spFlags: 0)
!92 = !DISubroutineType(types: !93)
!93 = !{!94, !8}
!94 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!95 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !96, file: !27, line: 153)
!96 = !DISubprogram(name: "labs", scope: !20, file: !20, line: 981, type: !97, flags: DIFlagPrototyped, spFlags: 0)
!97 = !DISubroutineType(types: !98)
!98 = !{!33, !33}
!99 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !100, file: !27, line: 154)
!100 = !DISubprogram(name: "ldiv", scope: !20, file: !20, line: 994, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!101 = !DISubroutineType(types: !102)
!102 = !{!29, !33, !33}
!103 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !104, file: !27, line: 155)
!104 = !DISubprogram(name: "malloc", scope: !20, file: !20, line: 672, type: !105, flags: DIFlagPrototyped, spFlags: 0)
!105 = !DISubroutineType(types: !106)
!106 = !{!43, !44}
!107 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !108, file: !27, line: 157)
!108 = !DISubprogram(name: "mblen", scope: !20, file: !20, line: 1062, type: !109, flags: DIFlagPrototyped, spFlags: 0)
!109 = !DISubroutineType(types: !110)
!110 = !{!6, !8, !44}
!111 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !112, file: !27, line: 158)
!112 = !DISubprogram(name: "mbstowcs", scope: !20, file: !20, line: 1073, type: !113, flags: DIFlagPrototyped, spFlags: 0)
!113 = !DISubroutineType(types: !114)
!114 = !{!44, !115, !118, !44}
!115 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !116)
!116 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !117, size: 64)
!117 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!118 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !8)
!119 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !120, file: !27, line: 159)
!120 = !DISubprogram(name: "mbtowc", scope: !20, file: !20, line: 1065, type: !121, flags: DIFlagPrototyped, spFlags: 0)
!121 = !DISubroutineType(types: !122)
!122 = !{!6, !115, !118, !44}
!123 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !124, file: !27, line: 161)
!124 = !DISubprogram(name: "qsort", scope: !20, file: !20, line: 970, type: !125, flags: DIFlagPrototyped, spFlags: 0)
!125 = !DISubroutineType(types: !126)
!126 = !{null, !43, !44, !44, !72}
!127 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !128, file: !27, line: 164)
!128 = !DISubprogram(name: "quick_exit", scope: !20, file: !20, line: 762, type: !84, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!129 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !130, file: !27, line: 167)
!130 = !DISubprogram(name: "rand", scope: !20, file: !20, line: 573, type: !131, flags: DIFlagPrototyped, spFlags: 0)
!131 = !DISubroutineType(types: !132)
!132 = !{!6}
!133 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !134, file: !27, line: 168)
!134 = !DISubprogram(name: "realloc", scope: !20, file: !20, line: 683, type: !135, flags: DIFlagPrototyped, spFlags: 0)
!135 = !DISubroutineType(types: !136)
!136 = !{!43, !43, !44}
!137 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !138, file: !27, line: 169)
!138 = !DISubprogram(name: "srand", scope: !20, file: !20, line: 575, type: !139, flags: DIFlagPrototyped, spFlags: 0)
!139 = !DISubroutineType(types: !140)
!140 = !{null, !141}
!141 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!142 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !143, file: !27, line: 170)
!143 = !DISubprogram(name: "strtod", scope: !20, file: !20, line: 118, type: !144, flags: DIFlagPrototyped, spFlags: 0)
!144 = !DISubroutineType(types: !145)
!145 = !{!14, !118, !146}
!146 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !147)
!147 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !94, size: 64)
!148 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !149, file: !27, line: 171)
!149 = !DISubprogram(name: "strtol", linkageName: "__isoc23_strtol", scope: !20, file: !20, line: 215, type: !150, flags: DIFlagPrototyped, spFlags: 0)
!150 = !DISubroutineType(types: !151)
!151 = !{!33, !118, !146, !6}
!152 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !153, file: !27, line: 172)
!153 = !DISubprogram(name: "strtoul", linkageName: "__isoc23_strtoul", scope: !20, file: !20, line: 219, type: !154, flags: DIFlagPrototyped, spFlags: 0)
!154 = !DISubroutineType(types: !155)
!155 = !{!46, !118, !146, !6}
!156 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !157, file: !27, line: 173)
!157 = !DISubprogram(name: "system", scope: !20, file: !20, line: 923, type: !60, flags: DIFlagPrototyped, spFlags: 0)
!158 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !159, file: !27, line: 175)
!159 = !DISubprogram(name: "wcstombs", scope: !20, file: !20, line: 1077, type: !160, flags: DIFlagPrototyped, spFlags: 0)
!160 = !DISubroutineType(types: !161)
!161 = !{!44, !162, !163, !44}
!162 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !94)
!163 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !164)
!164 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !165, size: 64)
!165 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !117)
!166 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !167, file: !27, line: 176)
!167 = !DISubprogram(name: "wctomb", scope: !20, file: !20, line: 1069, type: !168, flags: DIFlagPrototyped, spFlags: 0)
!168 = !DISubroutineType(types: !169)
!169 = !{!6, !94, !117}
!170 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !171, entity: !172, file: !27, line: 204)
!171 = !DINamespace(name: "__gnu_cxx", scope: null)
!172 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !20, line: 81, baseType: !173)
!173 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !20, line: 77, size: 128, flags: DIFlagTypePassByValue, elements: !174, identifier: "_ZTS7lldiv_t")
!174 = !{!175, !177}
!175 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !173, file: !20, line: 79, baseType: !176, size: 64)
!176 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!177 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !173, file: !20, line: 80, baseType: !176, size: 64, offset: 64)
!178 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !171, entity: !179, file: !27, line: 210)
!179 = !DISubprogram(name: "_Exit", scope: !20, file: !20, line: 768, type: !84, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!180 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !171, entity: !181, file: !27, line: 214)
!181 = !DISubprogram(name: "llabs", scope: !20, file: !20, line: 984, type: !182, flags: DIFlagPrototyped, spFlags: 0)
!182 = !DISubroutineType(types: !183)
!183 = !{!176, !176}
!184 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !171, entity: !185, file: !27, line: 220)
!185 = !DISubprogram(name: "lldiv", scope: !20, file: !20, line: 998, type: !186, flags: DIFlagPrototyped, spFlags: 0)
!186 = !DISubroutineType(types: !187)
!187 = !{!172, !176, !176}
!188 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !171, entity: !189, file: !27, line: 231)
!189 = !DISubprogram(name: "atoll", scope: !20, file: !20, line: 113, type: !190, flags: DIFlagPrototyped, spFlags: 0)
!190 = !DISubroutineType(types: !191)
!191 = !{!176, !8}
!192 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !171, entity: !193, file: !27, line: 232)
!193 = !DISubprogram(name: "strtoll", linkageName: "__isoc23_strtoll", scope: !20, file: !20, line: 238, type: !194, flags: DIFlagPrototyped, spFlags: 0)
!194 = !DISubroutineType(types: !195)
!195 = !{!176, !118, !146, !6}
!196 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !171, entity: !197, file: !27, line: 233)
!197 = !DISubprogram(name: "strtoull", linkageName: "__isoc23_strtoull", scope: !20, file: !20, line: 243, type: !198, flags: DIFlagPrototyped, spFlags: 0)
!198 = !DISubroutineType(types: !199)
!199 = !{!200, !118, !146, !6}
!200 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!201 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !171, entity: !202, file: !27, line: 235)
!202 = !DISubprogram(name: "strtof", scope: !20, file: !20, line: 124, type: !203, flags: DIFlagPrototyped, spFlags: 0)
!203 = !DISubroutineType(types: !204)
!204 = !{!205, !118, !146}
!205 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!206 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !171, entity: !207, file: !27, line: 236)
!207 = !DISubprogram(name: "strtold", scope: !20, file: !20, line: 127, type: !208, flags: DIFlagPrototyped, spFlags: 0)
!208 = !DISubroutineType(types: !209)
!209 = !{!210, !118, !146}
!210 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!211 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !172, file: !27, line: 244)
!212 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !179, file: !27, line: 246)
!213 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !181, file: !27, line: 248)
!214 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !215, file: !27, line: 249)
!215 = !DISubprogram(name: "div", linkageName: "_ZN9__gnu_cxx3divExx", scope: !171, file: !27, line: 217, type: !186, flags: DIFlagPrototyped, spFlags: 0)
!216 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !185, file: !27, line: 250)
!217 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !189, file: !27, line: 252)
!218 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !202, file: !27, line: 253)
!219 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !193, file: !27, line: 254)
!220 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !197, file: !27, line: 255)
!221 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !207, file: !27, line: 256)
!222 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !36, file: !223, line: 38)
!223 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/13/../../../../include/c++/13/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "3f24ff2a8eef595875da96e5466bd4aa")
!224 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !48, file: !223, line: 39)
!225 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !83, file: !223, line: 40)
!226 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !53, file: !223, line: 43)
!227 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !128, file: !223, line: 46)
!228 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !179, file: !223, line: 49)
!229 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !25, file: !223, line: 54)
!230 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !29, file: !223, line: 55)
!231 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !232, file: !223, line: 57)
!232 = !DISubprogram(name: "abs", linkageName: "_ZSt3absg", scope: !18, file: !23, line: 137, type: !233, flags: DIFlagPrototyped, spFlags: 0)
!233 = !DISubroutineType(types: !234)
!234 = !{!235, !235}
!235 = !DIBasicType(name: "__float128", size: 128, encoding: DW_ATE_float)
!236 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !55, file: !223, line: 58)
!237 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !59, file: !223, line: 59)
!238 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !63, file: !223, line: 60)
!239 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !67, file: !223, line: 61)
!240 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !77, file: !223, line: 62)
!241 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !215, file: !223, line: 63)
!242 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !87, file: !223, line: 64)
!243 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !91, file: !223, line: 65)
!244 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !96, file: !223, line: 66)
!245 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !100, file: !223, line: 67)
!246 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !104, file: !223, line: 68)
!247 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !108, file: !223, line: 70)
!248 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !112, file: !223, line: 71)
!249 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !120, file: !223, line: 72)
!250 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !124, file: !223, line: 74)
!251 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !130, file: !223, line: 75)
!252 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !134, file: !223, line: 76)
!253 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !138, file: !223, line: 77)
!254 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !143, file: !223, line: 78)
!255 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !149, file: !223, line: 79)
!256 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !153, file: !223, line: 80)
!257 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !157, file: !223, line: 81)
!258 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !159, file: !223, line: 83)
!259 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !167, file: !223, line: 84)
!260 = !{}
!261 = !{i32 7, !"Dwarf Version", i32 5}
!262 = !{i32 2, !"Debug Info Version", i32 3}
!263 = !{i32 1, !"wchar_size", i32 4}
!264 = !{i32 8, !"PIC Level", i32 2}
!265 = !{i32 7, !"uwtable", i32 2}
!266 = !{i32 7, !"frame-pointer", i32 2}
!267 = !{!"Ubuntu clang version 19.1.1 (1ubuntu1~24.04.2)"}
!268 = distinct !DISubprogram(name: "f", linkageName: "_Z1fi", scope: !3, file: !3, line: 4, type: !21, scopeLine: 4, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !11, retainedNodes: !260)
!269 = !{!"dp.md.instr.id:2"}
!270 = !{!"dp.md.instr.id:3"}
!271 = !{!"dp.md.instr.id:4"}
!272 = !{!"dp.md.instr.id:5"}
!273 = !{!"dp.md.instr.id:6"}
!274 = !DILocalVariable(name: "t", arg: 1, scope: !268, file: !3, line: 4, type: !6)
!275 = !DILocation(line: 4, column: 11, scope: !268)
!276 = !DILocation(line: 5, column: 7, scope: !268)
!277 = !{!"dp.md.instr.id:7"}
!278 = !DILocation(line: 5, column: 9, scope: !268)
!279 = !{!"dp.md.instr.id:8"}
!280 = !DILocation(line: 5, column: 16, scope: !268)
!281 = !{!"dp.md.instr.id:9"}
!282 = !DILocation(line: 5, column: 14, scope: !268)
!283 = !{!"dp.md.instr.id:10"}
!284 = !DILocation(line: 5, column: 18, scope: !268)
!285 = !{!"dp.md.instr.id:11"}
!286 = !DILocation(line: 5, column: 5, scope: !268)
!287 = !{!"dp.md.instr.id:12"}
!288 = !DILocation(line: 6, column: 10, scope: !268)
!289 = !{!"dp.md.instr.id:13"}
!290 = !DILocation(line: 6, column: 3, scope: !268)
!291 = !{!"dp.md.instr.id:14"}
!292 = !{!"dp.md.instr.id:15"}
!293 = !{!"dp.md.instr.id:16"}
!294 = !{!"dp.md.instr.id:17"}
!295 = !{!"dp.md.instr.id:18"}
!296 = !{!"dp.md.instr.id:19"}
!297 = !{!"dp.md.instr.id:20"}
!298 = !{!"dp.md.instr.id:21"}
!299 = !{!"dp.md.instr.id:22"}
!300 = !{!"dp.md.instr.id:23"}
!301 = !{!"dp.md.instr.id:24"}
!302 = !{!"dp.md.instr.id:25"}
!303 = !{!"dp.md.instr.id:26"}
!304 = !{!"dp.md.instr.id:27"}
!305 = !{!"dp.md.instr.id:28"}
!306 = !{!"dp.md.instr.id:29"}
!307 = !{!"dp.md.instr.id:30"}
!308 = !{!"dp.md.instr.id:31"}
!309 = !{!"dp.md.instr.id:32"}
!310 = !{!"dp.md.instr.id:33"}
!311 = !{!"dp.md.instr.id:34"}
!312 = !{!"dp.md.instr.id:35"}
!313 = !{!"dp.md.instr.id:36"}
!314 = !{!"dp.md.instr.id:37"}
!315 = !{!"dp.md.instr.id:38"}
!316 = !DILocalVariable(name: "argc", arg: 1, scope: !2, file: !3, line: 9, type: !6)
!317 = !DILocation(line: 9, column: 14, scope: !2)
!318 = !{!"dp.md.instr.id:39"}
!319 = !DILocalVariable(name: "argv", arg: 2, scope: !2, file: !3, line: 9, type: !7)
!320 = !DILocation(line: 9, column: 32, scope: !2)
!321 = !DILocalVariable(name: "x", scope: !2, file: !3, line: 11, type: !13)
!322 = !DILocation(line: 11, column: 11, scope: !2)
!323 = !DILocation(line: 11, column: 32, scope: !2)
!324 = !{!"dp.md.instr.id:40"}
!325 = !{!"dp.md.instr.id:41"}
!326 = !DILocation(line: 11, column: 34, scope: !2)
!327 = !{!"dp.md.instr.id:42"}
!328 = !DILocation(line: 11, column: 25, scope: !2)
!329 = !{!"dp.md.instr.id:43"}
!330 = !{!"dp.md.instr.id:44"}
!331 = !{!"dp.md.instr.id:45"}
!332 = !{!"dp.md.instr.id:46"}
!333 = !DILocalVariable(name: "k", scope: !2, file: !3, line: 13, type: !6)
!334 = !DILocation(line: 13, column: 7, scope: !2)
!335 = !{!"dp.md.instr.id:47"}
!336 = !DILocalVariable(name: "s", scope: !2, file: !3, line: 14, type: !6)
!337 = !DILocation(line: 14, column: 7, scope: !2)
!338 = !{!"dp.md.instr.id:48"}
!339 = !DILocalVariable(name: "i", scope: !340, file: !3, line: 15, type: !6)
!340 = distinct !DILexicalBlock(scope: !2, file: !3, line: 15, column: 3)
!341 = !DILocation(line: 15, column: 12, scope: !340)
!342 = !{!"dp.md.instr.id:49"}
!343 = !DILocation(line: 15, column: 8, scope: !340)
!344 = !{!"dp.md.instr.id:50"}
!345 = !{!"dp.md.instr.id:51"}
!346 = !DILocation(line: 15, column: 19, scope: !347)
!347 = distinct !DILexicalBlock(scope: !340, file: !3, line: 15, column: 3)
!348 = !{!"dp.md.instr.id:52"}
!349 = !DILocation(line: 15, column: 23, scope: !347)
!350 = !{!"dp.md.instr.id:53"}
!351 = !DILocation(line: 15, column: 21, scope: !347)
!352 = !{!"dp.md.instr.id:54"}
!353 = !DILocation(line: 15, column: 3, scope: !340)
!354 = !{!"dp.md.instr.id:55"}
!355 = !{!"dp.md.instr.id:80"}
!356 = !DILocation(line: 16, column: 11, scope: !357)
!357 = distinct !DILexicalBlock(scope: !347, file: !3, line: 15, column: 31)
!358 = !{!"dp.md.instr.id:56"}
!359 = !DILocation(line: 16, column: 9, scope: !357)
!360 = !{!"dp.md.instr.id:57"}
!361 = !DILocation(line: 16, column: 7, scope: !357)
!362 = !{!"dp.md.instr.id:58"}
!363 = !DILocation(line: 17, column: 12, scope: !357)
!364 = !{!"dp.md.instr.id:59"}
!365 = !{!"dp.md.instr.id:60"}
!366 = !DILocation(line: 17, column: 5, scope: !357)
!367 = !{!"dp.md.instr.id:61"}
!368 = !DILocation(line: 17, column: 7, scope: !357)
!369 = !{!"dp.md.instr.id:62"}
!370 = !{!"dp.md.instr.id:63"}
!371 = !{!"dp.md.instr.id:64"}
!372 = !DILocation(line: 17, column: 10, scope: !357)
!373 = !{!"dp.md.instr.id:65"}
!374 = !DILocation(line: 18, column: 3, scope: !357)
!375 = !{!"dp.md.instr.id:66"}
!376 = !DILocation(line: 15, column: 26, scope: !347)
!377 = !{!"dp.md.instr.id:67"}
!378 = !{!"dp.md.instr.id:68"}
!379 = !{!"dp.md.instr.id:69"}
!380 = !DILocation(line: 15, column: 3, scope: !347)
!381 = distinct !{!381, !353, !382, !383}
!382 = !DILocation(line: 18, column: 3, scope: !340)
!383 = !{!"llvm.loop.mustprogress"}
!384 = !{!"dp.md.instr.id:70"}
!385 = !{!"dp.md.instr.id:71"}
!386 = !DILocation(line: 19, column: 9, scope: !2)
!387 = !{!"dp.md.instr.id:72"}
!388 = !DILocation(line: 19, column: 7, scope: !2)
!389 = !{!"dp.md.instr.id:73"}
!390 = !DILocation(line: 19, column: 5, scope: !2)
!391 = !{!"dp.md.instr.id:74"}
!392 = !DILocation(line: 21, column: 8, scope: !2)
!393 = !{!"dp.md.instr.id:75"}
!394 = !DILocation(line: 21, column: 3, scope: !2)
!395 = !{!"dp.md.instr.id:76"}
!396 = !{!"dp.md.instr.id:77"}
!397 = !DILocation(line: 22, column: 3, scope: !2)
!398 = !{!"dp.md.instr.id:78"}
!399 = !{!"dp.md.instr.id:79"}
