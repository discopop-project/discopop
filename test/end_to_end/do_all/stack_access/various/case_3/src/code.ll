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
@.str.6 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@.str.7 = private unnamed_addr constant [2 x i8] c"s\00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.9 = private unnamed_addr constant [12 x i8] c"GEPRESULT_x\00", align 1
@.str.10 = private unnamed_addr constant [12 x i8] c"GEPRESULT_y\00", align 1
@.dp_bb_deps = private unnamed_addr constant [1308 x i8] c"0=1:4 NOM INIT *|t(S238807376),1:5 NOM RAW 1:4|t(S238807376),1:5 NOM WAR 1:5|t(S238807376),1:6 NOM RAW 1:5|t(S238807376)/1=1:11 NOM INIT *|x(S238807380),1:12 NOM INIT *|y(S238807381),1:15 NOM INIT *|i(S238807383),1:9 NOM INIT *|argc(S238807378),1:9 NOM INIT *|argv(S238807379),1:9 NOM INIT *|retval(S238807377)/2=1:19 NOM INIT *|i(S238807384)/3=1:15 NOM RAW 1:15|i(S238807383)/4=1:15 NOM RAW 1:15|i(S238807383),1:15 NOM WAR 1:15|i(S238807383)/5=1:16 NOM INIT *|s(S238807382),1:16 NOM RAW 1:15|i(S238807383),1:17 NOM RAW 1:11|x(S238807380),1:17 NOM RAW 1:15|i(S238807383),1:17 NOM RAW 1:16|s(S238807382)/6=1:23 NOM RAW 1:11|x(S238807380),1:24 NOM RAW 1:12|y(S238807381)/7=1:19 NOM RAW 1:19|i(S238807384)/8=1:19 NOM RAW 1:19|i(S238807384),1:19 NOM WAR 1:19|i(S238807384)/9=1:20 NOM INIT *|s(S238807382),1:20 NOM RAW 1:19|i(S238807384),1:21 NOM RAW 1:12|y(S238807381),1:21 NOM RAW 1:19|i(S238807384),1:21 NOM RAW 1:20|s(S238807382)/10=1:15 NOM RAW 1:15|i(S238807383)/11=1:15 NOM RAW 1:15|i(S238807383)/12=1:16 NOM RAW 1:15|i(S238807383),1:17 NOM RAW 1:15|i(S238807383)/13=1:16 NOM WAR 1:17|s(S238807382)/14=1:20 NOM WAR 1:17|s(S238807382)/15=1:19 NOM RAW 1:19|i(S238807384)/16=1:19 NOM RAW 1:19|i(S238807384)/17=1:20 NOM RAW 1:19|i(S238807384),1:21 NOM RAW 1:19|i(S238807384)/18=1:20 NOM WAR 1:21|s(S238807382)\00", align 1

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define noundef i32 @_Z1fi(i32 noundef %t) #0 !dbg !268 {
entry:
  call void @__dp_func_entry(i32 16388, i32 0)
  %t.addr = alloca i32, align 4
  %0 = ptrtoint ptr %t.addr to i64
  %1 = ptrtoint ptr %t.addr to i64
  store i32 %t, ptr %t.addr, align 4
    #dbg_declare(ptr %t.addr, !269, !DIExpression(), !270)
  %2 = ptrtoint ptr %t.addr to i64
  %3 = load i32, ptr %t.addr, align 4, !dbg !271
  %mul = mul nsw i32 %3, 42, !dbg !272
  %4 = ptrtoint ptr %t.addr to i64
  %5 = load i32, ptr %t.addr, align 4, !dbg !273
  %add = add nsw i32 %mul, %5, !dbg !274
  %sub = sub nsw i32 %add, 2, !dbg !275
  %6 = ptrtoint ptr %t.addr to i64
  store i32 %sub, ptr %t.addr, align 4, !dbg !276
  %7 = ptrtoint ptr %t.addr to i64
  %8 = load i32, ptr %t.addr, align 4, !dbg !277
  call void @__dp_report_bb(i32 0)
  call void @__dp_func_exit(i32 16390, i32 0), !dbg !278
  ret i32 %8, !dbg !278
}

; Function Attrs: mustprogress noinline norecurse nounwind optnone uwtable
define noundef i32 @main(i32 noundef %argc, ptr noundef %argv) #1 !dbg !2 {
entry:
  call void @__dp_func_entry(i32 16393, i32 1)
  %__dp_bb19 = alloca i32, align 4
  store i32 0, ptr %__dp_bb19, align 4
  %__dp_bb18 = alloca i32, align 4
  store i32 0, ptr %__dp_bb18, align 4
  %__dp_bb17 = alloca i32, align 4
  store i32 0, ptr %__dp_bb17, align 4
  %__dp_bb = alloca i32, align 4
  store i32 0, ptr %__dp_bb, align 4
  %retval = alloca i32, align 4
  %0 = ptrtoint ptr %retval to i64
  %argc.addr = alloca i32, align 4
  %1 = ptrtoint ptr %argc.addr to i64
  %argv.addr = alloca ptr, align 8
  %2 = ptrtoint ptr %argv.addr to i64
  %x = alloca ptr, align 8
  %3 = ptrtoint ptr %x to i64
  %y = alloca ptr, align 8
  %4 = ptrtoint ptr %y to i64
  %s = alloca i32, align 4
  %5 = ptrtoint ptr %s to i64
  %i = alloca i32, align 4
  %6 = ptrtoint ptr %i to i64
  %i6 = alloca i32, align 4
  %7 = ptrtoint ptr %i6 to i64
  %8 = ptrtoint ptr %retval to i64
  store i32 0, ptr %retval, align 4
  %9 = ptrtoint ptr %argc.addr to i64
  store i32 %argc, ptr %argc.addr, align 4
    #dbg_declare(ptr %argc.addr, !279, !DIExpression(), !280)
  %10 = ptrtoint ptr %argv.addr to i64
  store ptr %argv, ptr %argv.addr, align 8
    #dbg_declare(ptr %argv.addr, !281, !DIExpression(), !282)
    #dbg_declare(ptr %x, !283, !DIExpression(), !284)
  %11 = ptrtoint ptr @_ZZ4mainE1n to i64
  call void @__dp_read(i32 16395, i64 %11, ptr @.str.1)
  %12 = load i32, ptr @_ZZ4mainE1n, align 4, !dbg !285
  %conv = sext i32 %12 to i64, !dbg !285
  %mul = mul i64 %conv, 8, !dbg !286
  %call = call noalias ptr @malloc(i64 noundef %mul) #4, !dbg !287
  %13 = ptrtoint ptr %call to i64
  call void @__dp_new(i32 16395, i64 %13, i64 %13, i64 %mul), !dbg !284
  %14 = ptrtoint ptr %x to i64
  store ptr %call, ptr %x, align 8, !dbg !284
    #dbg_declare(ptr %y, !288, !DIExpression(), !289)
  %15 = ptrtoint ptr @_ZZ4mainE1n to i64
  call void @__dp_read(i32 16396, i64 %15, ptr @.str.1)
  %16 = load i32, ptr @_ZZ4mainE1n, align 4, !dbg !290
  %conv1 = sext i32 %16 to i64, !dbg !290
  %mul2 = mul i64 %conv1, 8, !dbg !291
  %call3 = call noalias ptr @malloc(i64 noundef %mul2) #4, !dbg !292
  %17 = ptrtoint ptr %call3 to i64
  call void @__dp_new(i32 16396, i64 %17, i64 %17, i64 %mul2), !dbg !289
  %18 = ptrtoint ptr %y to i64
  store ptr %call3, ptr %y, align 8, !dbg !289
    #dbg_declare(ptr %s, !293, !DIExpression(), !294)
    #dbg_declare(ptr %i, !295, !DIExpression(), !297)
  %19 = ptrtoint ptr %i to i64
  store i32 0, ptr %i, align 4, !dbg !297
  call void @__dp_report_bb(i32 1)
  br label %for.cond, !dbg !298

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16399, i32 0)
  %20 = ptrtoint ptr %i to i64
  %21 = load i32, ptr %i, align 4, !dbg !299
  %22 = ptrtoint ptr @_ZZ4mainE1n to i64
  call void @__dp_read(i32 16399, i64 %22, ptr @.str.1)
  %23 = load i32, ptr @_ZZ4mainE1n, align 4, !dbg !301
  %cmp = icmp slt i32 %21, %23, !dbg !302
  call void @__dp_report_bb(i32 3)
  %24 = load i32, ptr %__dp_bb, align 4
  call void @__dp_report_bb_pair(i32 %24, i32 10)
  br i1 %cmp, label %for.body, label %for.end, !dbg !303

for.body:                                         ; preds = %for.cond
  call void @__dp_loop_incr(i32 2)
  %25 = ptrtoint ptr %i to i64
  %26 = load i32, ptr %i, align 4, !dbg !304
  call void @__dp_call(i32 16400), !dbg !306
  %call4 = call noundef i32 @_Z1fi(i32 noundef %26), !dbg !306
  %27 = ptrtoint ptr %s to i64
  store i32 %call4, ptr %s, align 4, !dbg !307
  %28 = ptrtoint ptr %s to i64
  %29 = load i32, ptr %s, align 4, !dbg !308
  %conv5 = sitofp i32 %29 to double, !dbg !308
  %30 = ptrtoint ptr %x to i64
  %31 = load ptr, ptr %x, align 8, !dbg !309
  %32 = ptrtoint ptr %i to i64
  %33 = load i32, ptr %i, align 4, !dbg !310
  %idxprom = sext i32 %33 to i64, !dbg !309
  %arrayidx = getelementptr inbounds double, ptr %31, i64 %idxprom, !dbg !309
  %34 = ptrtoint ptr %arrayidx to i64
  call void @__dp_write(i32 16401, i64 %34, ptr @.str.9)
  store double %conv5, ptr %arrayidx, align 8, !dbg !311
  call void @__dp_report_bb(i32 5)
  %35 = load i32, ptr %__dp_bb, align 4
  call void @__dp_report_bb_pair(i32 %35, i32 12)
  %36 = load i32, ptr %__dp_bb17, align 4
  call void @__dp_report_bb_pair(i32 %36, i32 13)
  store i32 1, ptr %__dp_bb17, align 4
  br label %for.inc, !dbg !312

for.inc:                                          ; preds = %for.body
  %37 = ptrtoint ptr %i to i64
  %38 = load i32, ptr %i, align 4, !dbg !313
  %inc = add nsw i32 %38, 1, !dbg !313
  %39 = ptrtoint ptr %i to i64
  store i32 %inc, ptr %i, align 4, !dbg !313
  call void @__dp_report_bb(i32 4)
  %40 = load i32, ptr %__dp_bb, align 4
  call void @__dp_report_bb_pair(i32 %40, i32 11)
  store i32 1, ptr %__dp_bb, align 4
  br label %for.cond, !dbg !314, !llvm.loop !315

for.end:                                          ; preds = %for.cond
    #dbg_declare(ptr %i6, !318, !DIExpression(), !320)
  call void @__dp_loop_exit(i32 16403, i32 0)
  %41 = ptrtoint ptr %i6 to i64
  store i32 0, ptr %i6, align 4, !dbg !320
  call void @__dp_report_bb(i32 2)
  br label %for.cond7, !dbg !321

for.cond7:                                        ; preds = %for.inc14, %for.end
  call void @__dp_loop_entry(i32 16403, i32 1)
  %42 = ptrtoint ptr %i6 to i64
  %43 = load i32, ptr %i6, align 4, !dbg !322
  %44 = ptrtoint ptr @_ZZ4mainE1n to i64
  call void @__dp_read(i32 16403, i64 %44, ptr @.str.1)
  %45 = load i32, ptr @_ZZ4mainE1n, align 4, !dbg !324
  %cmp8 = icmp slt i32 %43, %45, !dbg !325
  call void @__dp_report_bb(i32 7)
  %46 = load i32, ptr %__dp_bb18, align 4
  call void @__dp_report_bb_pair(i32 %46, i32 15)
  br i1 %cmp8, label %for.body9, label %for.end16, !dbg !326

for.body9:                                        ; preds = %for.cond7
  call void @__dp_loop_incr(i32 1)
  %47 = ptrtoint ptr %i6 to i64
  %48 = load i32, ptr %i6, align 4, !dbg !327
  call void @__dp_call(i32 16404), !dbg !329
  %call10 = call noundef i32 @_Z1fi(i32 noundef %48), !dbg !329
  %49 = ptrtoint ptr %s to i64
  store i32 %call10, ptr %s, align 4, !dbg !330
  %50 = ptrtoint ptr %s to i64
  %51 = load i32, ptr %s, align 4, !dbg !331
  %conv11 = sitofp i32 %51 to double, !dbg !331
  %52 = ptrtoint ptr %y to i64
  %53 = load ptr, ptr %y, align 8, !dbg !332
  %54 = ptrtoint ptr %i6 to i64
  %55 = load i32, ptr %i6, align 4, !dbg !333
  %idxprom12 = sext i32 %55 to i64, !dbg !332
  %arrayidx13 = getelementptr inbounds double, ptr %53, i64 %idxprom12, !dbg !332
  %56 = ptrtoint ptr %arrayidx13 to i64
  call void @__dp_write(i32 16405, i64 %56, ptr @.str.10)
  store double %conv11, ptr %arrayidx13, align 8, !dbg !334
  call void @__dp_report_bb(i32 9)
  %57 = load i32, ptr %__dp_bb17, align 4
  call void @__dp_report_bb_pair(i32 %57, i32 14)
  %58 = load i32, ptr %__dp_bb18, align 4
  call void @__dp_report_bb_pair(i32 %58, i32 17)
  %59 = load i32, ptr %__dp_bb19, align 4
  call void @__dp_report_bb_pair(i32 %59, i32 18)
  store i32 1, ptr %__dp_bb19, align 4
  br label %for.inc14, !dbg !335

for.inc14:                                        ; preds = %for.body9
  %60 = ptrtoint ptr %i6 to i64
  %61 = load i32, ptr %i6, align 4, !dbg !336
  %inc15 = add nsw i32 %61, 1, !dbg !336
  %62 = ptrtoint ptr %i6 to i64
  store i32 %inc15, ptr %i6, align 4, !dbg !336
  call void @__dp_report_bb(i32 8)
  %63 = load i32, ptr %__dp_bb18, align 4
  call void @__dp_report_bb_pair(i32 %63, i32 16)
  store i32 1, ptr %__dp_bb18, align 4
  br label %for.cond7, !dbg !337, !llvm.loop !338

for.end16:                                        ; preds = %for.cond7
  call void @__dp_loop_exit(i32 16407, i32 1)
  %64 = ptrtoint ptr %x to i64
  %65 = load ptr, ptr %x, align 8, !dbg !340
  call void @free(ptr noundef %65) #5, !dbg !341
  %66 = ptrtoint ptr %65 to i64
  call void @__dp_delete(i32 16407, i64 %66), !dbg !342
  %67 = ptrtoint ptr %y to i64
  %68 = load ptr, ptr %y, align 8, !dbg !342
  call void @free(ptr noundef %68) #5, !dbg !343
  %69 = ptrtoint ptr %68 to i64
  call void @__dp_delete(i32 16408, i64 %69), !dbg !344
  call void @__dp_report_bb(i32 6)
  call void @__dp_add_bb_deps(ptr @.dp_bb_deps)
  call void @__dp_finalize(i32 16409), !dbg !344
  call void @__dp_loop_output(), !dbg !344
  ret i32 0, !dbg !344
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

declare void @__dp_call(i32)

declare void @__dp_func_entry(i32, i32)

declare void @__dp_func_exit(i32, i32)

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_loop_exit(i32, i32)

declare void @__dp_incr_taken_branch_counter(ptr, i32, i32)

declare void @__dp_report_bb(i32)

declare void @__dp_report_bb_pair(i32, i32)

declare void @__dp_loop_incr(i32)

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
!3 = !DIFile(filename: "code.cpp", directory: "/home/lukas/git/discopop/test/end_to_end/do_all/stack_access/various/case_3/src", checksumkind: CSK_MD5, checksum: "10d48a016950dc02c850c9fcf88cb80c")
!4 = !DISubroutineType(types: !5)
!5 = !{!6, !6, !7}
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 64)
!9 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !10)
!10 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!11 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !3, producer: "Ubuntu clang version 21.1.8 (++20251221032922+2078da43e25a-1~exp1~20251221153059.70)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !12, globals: !15, imports: !16, splitDebugInlining: false, nameTableKind: None)
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
!45 = !DIFile(filename: "/usr/lib/llvm-21/lib/clang/21/include/__stddef_size_t.h", directory: "", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
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
!267 = !{!"Ubuntu clang version 21.1.8 (++20251221032922+2078da43e25a-1~exp1~20251221153059.70)"}
!268 = distinct !DISubprogram(name: "f", linkageName: "_Z1fi", scope: !3, file: !3, line: 4, type: !21, scopeLine: 4, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !11, retainedNodes: !260)
!269 = !DILocalVariable(name: "t", arg: 1, scope: !268, file: !3, line: 4, type: !6)
!270 = !DILocation(line: 4, column: 11, scope: !268)
!271 = !DILocation(line: 5, column: 7, scope: !268)
!272 = !DILocation(line: 5, column: 9, scope: !268)
!273 = !DILocation(line: 5, column: 16, scope: !268)
!274 = !DILocation(line: 5, column: 14, scope: !268)
!275 = !DILocation(line: 5, column: 18, scope: !268)
!276 = !DILocation(line: 5, column: 5, scope: !268)
!277 = !DILocation(line: 6, column: 10, scope: !268)
!278 = !DILocation(line: 6, column: 3, scope: !268)
!279 = !DILocalVariable(name: "argc", arg: 1, scope: !2, file: !3, line: 9, type: !6)
!280 = !DILocation(line: 9, column: 14, scope: !2)
!281 = !DILocalVariable(name: "argv", arg: 2, scope: !2, file: !3, line: 9, type: !7)
!282 = !DILocation(line: 9, column: 32, scope: !2)
!283 = !DILocalVariable(name: "x", scope: !2, file: !3, line: 11, type: !13)
!284 = !DILocation(line: 11, column: 11, scope: !2)
!285 = !DILocation(line: 11, column: 32, scope: !2)
!286 = !DILocation(line: 11, column: 34, scope: !2)
!287 = !DILocation(line: 11, column: 25, scope: !2)
!288 = !DILocalVariable(name: "y", scope: !2, file: !3, line: 12, type: !13)
!289 = !DILocation(line: 12, column: 11, scope: !2)
!290 = !DILocation(line: 12, column: 32, scope: !2)
!291 = !DILocation(line: 12, column: 34, scope: !2)
!292 = !DILocation(line: 12, column: 25, scope: !2)
!293 = !DILocalVariable(name: "s", scope: !2, file: !3, line: 14, type: !6)
!294 = !DILocation(line: 14, column: 7, scope: !2)
!295 = !DILocalVariable(name: "i", scope: !296, file: !3, line: 15, type: !6)
!296 = distinct !DILexicalBlock(scope: !2, file: !3, line: 15, column: 3)
!297 = !DILocation(line: 15, column: 12, scope: !296)
!298 = !DILocation(line: 15, column: 8, scope: !296)
!299 = !DILocation(line: 15, column: 19, scope: !300)
!300 = distinct !DILexicalBlock(scope: !296, file: !3, line: 15, column: 3)
!301 = !DILocation(line: 15, column: 23, scope: !300)
!302 = !DILocation(line: 15, column: 21, scope: !300)
!303 = !DILocation(line: 15, column: 3, scope: !296)
!304 = !DILocation(line: 16, column: 11, scope: !305)
!305 = distinct !DILexicalBlock(scope: !300, file: !3, line: 15, column: 31)
!306 = !DILocation(line: 16, column: 9, scope: !305)
!307 = !DILocation(line: 16, column: 7, scope: !305)
!308 = !DILocation(line: 17, column: 12, scope: !305)
!309 = !DILocation(line: 17, column: 5, scope: !305)
!310 = !DILocation(line: 17, column: 7, scope: !305)
!311 = !DILocation(line: 17, column: 10, scope: !305)
!312 = !DILocation(line: 18, column: 3, scope: !305)
!313 = !DILocation(line: 15, column: 26, scope: !300)
!314 = !DILocation(line: 15, column: 3, scope: !300)
!315 = distinct !{!315, !303, !316, !317}
!316 = !DILocation(line: 18, column: 3, scope: !296)
!317 = !{!"llvm.loop.mustprogress"}
!318 = !DILocalVariable(name: "i", scope: !319, file: !3, line: 19, type: !6)
!319 = distinct !DILexicalBlock(scope: !2, file: !3, line: 19, column: 3)
!320 = !DILocation(line: 19, column: 12, scope: !319)
!321 = !DILocation(line: 19, column: 8, scope: !319)
!322 = !DILocation(line: 19, column: 19, scope: !323)
!323 = distinct !DILexicalBlock(scope: !319, file: !3, line: 19, column: 3)
!324 = !DILocation(line: 19, column: 23, scope: !323)
!325 = !DILocation(line: 19, column: 21, scope: !323)
!326 = !DILocation(line: 19, column: 3, scope: !319)
!327 = !DILocation(line: 20, column: 11, scope: !328)
!328 = distinct !DILexicalBlock(scope: !323, file: !3, line: 19, column: 31)
!329 = !DILocation(line: 20, column: 9, scope: !328)
!330 = !DILocation(line: 20, column: 7, scope: !328)
!331 = !DILocation(line: 21, column: 12, scope: !328)
!332 = !DILocation(line: 21, column: 5, scope: !328)
!333 = !DILocation(line: 21, column: 7, scope: !328)
!334 = !DILocation(line: 21, column: 10, scope: !328)
!335 = !DILocation(line: 22, column: 3, scope: !328)
!336 = !DILocation(line: 19, column: 26, scope: !323)
!337 = !DILocation(line: 19, column: 3, scope: !323)
!338 = distinct !{!338, !326, !339, !317}
!339 = !DILocation(line: 22, column: 3, scope: !319)
!340 = !DILocation(line: 23, column: 8, scope: !2)
!341 = !DILocation(line: 23, column: 3, scope: !2)
!342 = !DILocation(line: 24, column: 8, scope: !2)
!343 = !DILocation(line: 24, column: 3, scope: !2)
!344 = !DILocation(line: 25, column: 3, scope: !2)
