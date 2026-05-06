; ModuleID = 'test.cpp'
source_filename = "test.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"z\00", align 1
@.str.4 = private unnamed_addr constant [5 x i8] c".str\00", align 1
@.str.5 = private unnamed_addr constant [7 x i8] c".str.1\00", align 1
@.str.6 = private unnamed_addr constant [7 x i8] c".str.2\00", align 1
@.str.7 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.dp_bb_deps = private unnamed_addr constant [368 x i8] c"0=1:4 NOM INIT *|b(S-1605650176),1:5 NOM INIT *|y(S-1605650175),1:5 NOM RAW 1:4|b(S-1605650176)/1=1:10 NOM RAW 1:8|a(S-1605650173),1:8 NOM INIT *|a(S-1605650173),1:9 NOM INIT *|z(S-1605650174)/2=1:13 NOM INIT *|b(S-1605650172),1:14 NOM RAW 1:13|b(S-1605650172)/3=1:17 NOM INIT *|a(S-1605650171),1:18 NOM RAW 1:17|a(S-1605650171)/4=1:21 NOM INIT *|retval(S-1605650170)\00", align 1

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define void @_Z5bar_1Ri(ptr noundef nonnull align 4 dereferenceable(4) %b) #0 !dbg !220 {
entry:
  call void @__dp_func_entry(i32 16388, i32 0)
  %b.addr = alloca ptr, align 8
  %0 = ptrtoint ptr %b.addr to i64
  %y = alloca i32, align 4
  %1 = ptrtoint ptr %y to i64
  %2 = ptrtoint ptr %b.addr to i64
  store ptr %b, ptr %b.addr, align 8
    #dbg_declare(ptr %b.addr, !225, !DIExpression(), !226)
    #dbg_declare(ptr %y, !227, !DIExpression(), !228)
  %3 = ptrtoint ptr %b.addr to i64
  %4 = load ptr, ptr %b.addr, align 8, !dbg !229, !nonnull !224, !align !230
  %5 = ptrtoint ptr %4 to i64
  call void @__dp_read(i32 16389, i64 %5, ptr @.str)
  %6 = load i32, ptr %4, align 4, !dbg !229
  %add = add nsw i32 %6, 1, !dbg !231
  %7 = ptrtoint ptr %y to i64
  store i32 %add, ptr %y, align 4, !dbg !228
  call void @__dp_report_bb(i32 0)
  call void @__dp_func_exit(i32 16390, i32 0), !dbg !232
  ret void, !dbg !232
}

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define void @_Z5foo_1Ri(ptr noundef nonnull align 4 dereferenceable(4) %a) #0 !dbg !233 {
entry:
  call void @__dp_func_entry(i32 16392, i32 0)
  %a.addr = alloca ptr, align 8
  %0 = ptrtoint ptr %a.addr to i64
  %z = alloca i32, align 4
  %1 = ptrtoint ptr %z to i64
  %2 = ptrtoint ptr %a.addr to i64
  store ptr %a, ptr %a.addr, align 8
    #dbg_declare(ptr %a.addr, !234, !DIExpression(), !235)
    #dbg_declare(ptr %z, !236, !DIExpression(), !237)
  %3 = ptrtoint ptr %z to i64
  store i32 2, ptr %z, align 4, !dbg !237
  %4 = ptrtoint ptr %a.addr to i64
  %5 = load ptr, ptr %a.addr, align 8, !dbg !238, !nonnull !224, !align !230
  call void @__dp_call(i32 16394), !dbg !239
  call void @_Z5bar_1Ri(ptr noundef nonnull align 4 dereferenceable(4) %5), !dbg !239
  call void @__dp_report_bb(i32 1)
  call void @__dp_func_exit(i32 16395, i32 0), !dbg !240
  ret void, !dbg !240
}

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define void @_Z5bar_2Ri(ptr noundef nonnull align 4 dereferenceable(4) %b) #0 !dbg !241 {
entry:
  call void @__dp_func_entry(i32 16397, i32 0)
  %b.addr = alloca ptr, align 8
  %0 = ptrtoint ptr %b.addr to i64
  %1 = ptrtoint ptr %b.addr to i64
  store ptr %b, ptr %b.addr, align 8
    #dbg_declare(ptr %b.addr, !242, !DIExpression(), !243)
  %2 = ptrtoint ptr %b.addr to i64
  %3 = load ptr, ptr %b.addr, align 8, !dbg !244, !nonnull !224, !align !230
  %4 = ptrtoint ptr %3 to i64
  call void @__dp_write(i32 16398, i64 %4, ptr @.str)
  store i32 2412, ptr %3, align 4, !dbg !245
  call void @__dp_report_bb(i32 2)
  call void @__dp_func_exit(i32 16399, i32 0), !dbg !246
  ret void, !dbg !246
}

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define void @_Z5foo_2Ri(ptr noundef nonnull align 4 dereferenceable(4) %a) #0 !dbg !247 {
entry:
  call void @__dp_func_entry(i32 16401, i32 0)
  %a.addr = alloca ptr, align 8
  %0 = ptrtoint ptr %a.addr to i64
  %1 = ptrtoint ptr %a.addr to i64
  store ptr %a, ptr %a.addr, align 8
    #dbg_declare(ptr %a.addr, !248, !DIExpression(), !249)
  %2 = ptrtoint ptr %a.addr to i64
  %3 = load ptr, ptr %a.addr, align 8, !dbg !250, !nonnull !224, !align !230
  call void @__dp_call(i32 16402), !dbg !251
  call void @_Z5bar_2Ri(ptr noundef nonnull align 4 dereferenceable(4) %3), !dbg !251
  call void @__dp_report_bb(i32 3)
  call void @__dp_func_exit(i32 16403, i32 0), !dbg !252
  ret void, !dbg !252
}

; Function Attrs: mustprogress noinline norecurse nounwind optnone uwtable
define noundef i32 @main() #1 !dbg !253 {
entry:
  call void @__dp_func_entry(i32 16405, i32 1)
  %retval = alloca i32, align 4
  %0 = ptrtoint ptr %retval to i64
  %x = alloca i32, align 4
  %1 = ptrtoint ptr %x to i64
  call void @__dp_alloca(i32 16405, ptr @.str.8, i64 %1, i64 %1, i64 4, i64 1)
  %2 = ptrtoint ptr %retval to i64
  store i32 0, ptr %retval, align 4
    #dbg_declare(ptr %x, !254, !DIExpression(), !255)
  %3 = ptrtoint ptr %x to i64
  call void @__dp_write(i32 16406, i64 %3, ptr @.str.8)
  store i32 42, ptr %x, align 4, !dbg !255
  call void @__dp_call(i32 16407), !dbg !256
  call void @_Z5foo_1Ri(ptr noundef nonnull align 4 dereferenceable(4) %x), !dbg !256
  call void @__dp_call(i32 16408), !dbg !257
  call void @_Z5foo_2Ri(ptr noundef nonnull align 4 dereferenceable(4) %x), !dbg !257
  call void @__dp_report_bb(i32 4)
  call void @__dp_add_bb_deps(ptr @.dp_bb_deps)
  call void @__dp_finalize(i32 16410), !dbg !258
  call void @__dp_loop_output(), !dbg !258
  ret i32 0, !dbg !258
}

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

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!213, !214, !215, !216, !217, !218}
!llvm.ident = !{!219}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !1, producer: "Ubuntu clang version 21.1.8 (++20251221032922+2078da43e25a-1~exp1~20251221153059.70)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, imports: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "test.cpp", directory: "/home/lukas/git/discopop/test/profiler/WAR/war_46_2", checksumkind: CSK_MD5, checksum: "57518be42352dec856d17ee9a7ff30bd")
!2 = !{!3, !11, !15, !22, !26, !34, !39, !41, !49, !53, !57, !67, !69, !73, !77, !81, !86, !90, !94, !98, !102, !110, !114, !118, !120, !124, !128, !133, !139, !143, !147, !149, !157, !161, !169, !171, !175, !179, !183, !187, !192, !197, !202, !203, !204, !205, !207, !208, !209, !210, !211, !212}
!3 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !5, file: !10, line: 52)
!4 = !DINamespace(name: "std", scope: null)
!5 = !DISubprogram(name: "abs", scope: !6, file: !6, line: 980, type: !7, flags: DIFlagPrototyped, spFlags: 0)
!6 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!7 = !DISubroutineType(types: !8)
!8 = !{!9, !9}
!9 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!10 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/13/../../../../include/c++/13/bits/std_abs.h", directory: "")
!11 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !12, file: !14, line: 131)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !6, line: 63, baseType: !13)
!13 = !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 59, size: 64, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!14 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/13/../../../../include/c++/13/cstdlib", directory: "")
!15 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !16, file: !14, line: 132)
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !6, line: 71, baseType: !17)
!17 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 67, size: 128, flags: DIFlagTypePassByValue, elements: !18, identifier: "_ZTS6ldiv_t")
!18 = !{!19, !21}
!19 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !17, file: !6, line: 69, baseType: !20, size: 64)
!20 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !17, file: !6, line: 70, baseType: !20, size: 64, offset: 64)
!22 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !23, file: !14, line: 134)
!23 = !DISubprogram(name: "abort", scope: !6, file: !6, line: 730, type: !24, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!24 = !DISubroutineType(types: !25)
!25 = !{null}
!26 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !27, file: !14, line: 136)
!27 = !DISubprogram(name: "aligned_alloc", scope: !6, file: !6, line: 724, type: !28, flags: DIFlagPrototyped, spFlags: 0)
!28 = !DISubroutineType(types: !29)
!29 = !{!30, !31, !31}
!30 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !32, line: 18, baseType: !33)
!32 = !DIFile(filename: "/usr/lib/llvm-21/lib/clang/21/include/__stddef_size_t.h", directory: "", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!33 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!34 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !35, file: !14, line: 138)
!35 = !DISubprogram(name: "atexit", scope: !6, file: !6, line: 734, type: !36, flags: DIFlagPrototyped, spFlags: 0)
!36 = !DISubroutineType(types: !37)
!37 = !{!9, !38}
!38 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !24, size: 64)
!39 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !40, file: !14, line: 141)
!40 = !DISubprogram(name: "at_quick_exit", scope: !6, file: !6, line: 739, type: !36, flags: DIFlagPrototyped, spFlags: 0)
!41 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !42, file: !14, line: 144)
!42 = !DISubprogram(name: "atof", scope: !6, file: !6, line: 102, type: !43, flags: DIFlagPrototyped, spFlags: 0)
!43 = !DISubroutineType(types: !44)
!44 = !{!45, !46}
!45 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!46 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !47, size: 64)
!47 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !48)
!48 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!49 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !50, file: !14, line: 145)
!50 = !DISubprogram(name: "atoi", scope: !6, file: !6, line: 105, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!51 = !DISubroutineType(types: !52)
!52 = !{!9, !46}
!53 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !54, file: !14, line: 146)
!54 = !DISubprogram(name: "atol", scope: !6, file: !6, line: 108, type: !55, flags: DIFlagPrototyped, spFlags: 0)
!55 = !DISubroutineType(types: !56)
!56 = !{!20, !46}
!57 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !58, file: !14, line: 147)
!58 = !DISubprogram(name: "bsearch", scope: !6, file: !6, line: 960, type: !59, flags: DIFlagPrototyped, spFlags: 0)
!59 = !DISubroutineType(types: !60)
!60 = !{!30, !61, !61, !31, !31, !63}
!61 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !62, size: 64)
!62 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!63 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !6, line: 948, baseType: !64)
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !65, size: 64)
!65 = !DISubroutineType(types: !66)
!66 = !{!9, !61, !61}
!67 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !68, file: !14, line: 148)
!68 = !DISubprogram(name: "calloc", scope: !6, file: !6, line: 675, type: !28, flags: DIFlagPrototyped, spFlags: 0)
!69 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !70, file: !14, line: 149)
!70 = !DISubprogram(name: "div", scope: !6, file: !6, line: 992, type: !71, flags: DIFlagPrototyped, spFlags: 0)
!71 = !DISubroutineType(types: !72)
!72 = !{!12, !9, !9}
!73 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !74, file: !14, line: 150)
!74 = !DISubprogram(name: "exit", scope: !6, file: !6, line: 756, type: !75, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!75 = !DISubroutineType(types: !76)
!76 = !{null, !9}
!77 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !78, file: !14, line: 151)
!78 = !DISubprogram(name: "free", scope: !6, file: !6, line: 687, type: !79, flags: DIFlagPrototyped, spFlags: 0)
!79 = !DISubroutineType(types: !80)
!80 = !{null, !30}
!81 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !82, file: !14, line: 152)
!82 = !DISubprogram(name: "getenv", scope: !6, file: !6, line: 773, type: !83, flags: DIFlagPrototyped, spFlags: 0)
!83 = !DISubroutineType(types: !84)
!84 = !{!85, !46}
!85 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !48, size: 64)
!86 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !87, file: !14, line: 153)
!87 = !DISubprogram(name: "labs", scope: !6, file: !6, line: 981, type: !88, flags: DIFlagPrototyped, spFlags: 0)
!88 = !DISubroutineType(types: !89)
!89 = !{!20, !20}
!90 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !91, file: !14, line: 154)
!91 = !DISubprogram(name: "ldiv", scope: !6, file: !6, line: 994, type: !92, flags: DIFlagPrototyped, spFlags: 0)
!92 = !DISubroutineType(types: !93)
!93 = !{!16, !20, !20}
!94 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !95, file: !14, line: 155)
!95 = !DISubprogram(name: "malloc", scope: !6, file: !6, line: 672, type: !96, flags: DIFlagPrototyped, spFlags: 0)
!96 = !DISubroutineType(types: !97)
!97 = !{!30, !31}
!98 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !99, file: !14, line: 157)
!99 = !DISubprogram(name: "mblen", scope: !6, file: !6, line: 1062, type: !100, flags: DIFlagPrototyped, spFlags: 0)
!100 = !DISubroutineType(types: !101)
!101 = !{!9, !46, !31}
!102 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !103, file: !14, line: 158)
!103 = !DISubprogram(name: "mbstowcs", scope: !6, file: !6, line: 1073, type: !104, flags: DIFlagPrototyped, spFlags: 0)
!104 = !DISubroutineType(types: !105)
!105 = !{!31, !106, !109, !31}
!106 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !107)
!107 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !108, size: 64)
!108 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!109 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !46)
!110 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !111, file: !14, line: 159)
!111 = !DISubprogram(name: "mbtowc", scope: !6, file: !6, line: 1065, type: !112, flags: DIFlagPrototyped, spFlags: 0)
!112 = !DISubroutineType(types: !113)
!113 = !{!9, !106, !109, !31}
!114 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !115, file: !14, line: 161)
!115 = !DISubprogram(name: "qsort", scope: !6, file: !6, line: 970, type: !116, flags: DIFlagPrototyped, spFlags: 0)
!116 = !DISubroutineType(types: !117)
!117 = !{null, !30, !31, !31, !63}
!118 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !119, file: !14, line: 164)
!119 = !DISubprogram(name: "quick_exit", scope: !6, file: !6, line: 762, type: !75, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!120 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !121, file: !14, line: 167)
!121 = !DISubprogram(name: "rand", scope: !6, file: !6, line: 573, type: !122, flags: DIFlagPrototyped, spFlags: 0)
!122 = !DISubroutineType(types: !123)
!123 = !{!9}
!124 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !125, file: !14, line: 168)
!125 = !DISubprogram(name: "realloc", scope: !6, file: !6, line: 683, type: !126, flags: DIFlagPrototyped, spFlags: 0)
!126 = !DISubroutineType(types: !127)
!127 = !{!30, !30, !31}
!128 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !129, file: !14, line: 169)
!129 = !DISubprogram(name: "srand", scope: !6, file: !6, line: 575, type: !130, flags: DIFlagPrototyped, spFlags: 0)
!130 = !DISubroutineType(types: !131)
!131 = !{null, !132}
!132 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!133 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !134, file: !14, line: 170)
!134 = !DISubprogram(name: "strtod", scope: !6, file: !6, line: 118, type: !135, flags: DIFlagPrototyped, spFlags: 0)
!135 = !DISubroutineType(types: !136)
!136 = !{!45, !109, !137}
!137 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !138)
!138 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !85, size: 64)
!139 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !140, file: !14, line: 171)
!140 = !DISubprogram(name: "strtol", linkageName: "__isoc23_strtol", scope: !6, file: !6, line: 215, type: !141, flags: DIFlagPrototyped, spFlags: 0)
!141 = !DISubroutineType(types: !142)
!142 = !{!20, !109, !137, !9}
!143 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !144, file: !14, line: 172)
!144 = !DISubprogram(name: "strtoul", linkageName: "__isoc23_strtoul", scope: !6, file: !6, line: 219, type: !145, flags: DIFlagPrototyped, spFlags: 0)
!145 = !DISubroutineType(types: !146)
!146 = !{!33, !109, !137, !9}
!147 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !148, file: !14, line: 173)
!148 = !DISubprogram(name: "system", scope: !6, file: !6, line: 923, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!149 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !150, file: !14, line: 175)
!150 = !DISubprogram(name: "wcstombs", scope: !6, file: !6, line: 1077, type: !151, flags: DIFlagPrototyped, spFlags: 0)
!151 = !DISubroutineType(types: !152)
!152 = !{!31, !153, !154, !31}
!153 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !85)
!154 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !155)
!155 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !156, size: 64)
!156 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !108)
!157 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !158, file: !14, line: 176)
!158 = !DISubprogram(name: "wctomb", scope: !6, file: !6, line: 1069, type: !159, flags: DIFlagPrototyped, spFlags: 0)
!159 = !DISubroutineType(types: !160)
!160 = !{!9, !85, !108}
!161 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !162, entity: !163, file: !14, line: 204)
!162 = !DINamespace(name: "__gnu_cxx", scope: null)
!163 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !6, line: 81, baseType: !164)
!164 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 77, size: 128, flags: DIFlagTypePassByValue, elements: !165, identifier: "_ZTS7lldiv_t")
!165 = !{!166, !168}
!166 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !164, file: !6, line: 79, baseType: !167, size: 64)
!167 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!168 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !164, file: !6, line: 80, baseType: !167, size: 64, offset: 64)
!169 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !162, entity: !170, file: !14, line: 210)
!170 = !DISubprogram(name: "_Exit", scope: !6, file: !6, line: 768, type: !75, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!171 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !162, entity: !172, file: !14, line: 214)
!172 = !DISubprogram(name: "llabs", scope: !6, file: !6, line: 984, type: !173, flags: DIFlagPrototyped, spFlags: 0)
!173 = !DISubroutineType(types: !174)
!174 = !{!167, !167}
!175 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !162, entity: !176, file: !14, line: 220)
!176 = !DISubprogram(name: "lldiv", scope: !6, file: !6, line: 998, type: !177, flags: DIFlagPrototyped, spFlags: 0)
!177 = !DISubroutineType(types: !178)
!178 = !{!163, !167, !167}
!179 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !162, entity: !180, file: !14, line: 231)
!180 = !DISubprogram(name: "atoll", scope: !6, file: !6, line: 113, type: !181, flags: DIFlagPrototyped, spFlags: 0)
!181 = !DISubroutineType(types: !182)
!182 = !{!167, !46}
!183 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !162, entity: !184, file: !14, line: 232)
!184 = !DISubprogram(name: "strtoll", linkageName: "__isoc23_strtoll", scope: !6, file: !6, line: 238, type: !185, flags: DIFlagPrototyped, spFlags: 0)
!185 = !DISubroutineType(types: !186)
!186 = !{!167, !109, !137, !9}
!187 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !162, entity: !188, file: !14, line: 233)
!188 = !DISubprogram(name: "strtoull", linkageName: "__isoc23_strtoull", scope: !6, file: !6, line: 243, type: !189, flags: DIFlagPrototyped, spFlags: 0)
!189 = !DISubroutineType(types: !190)
!190 = !{!191, !109, !137, !9}
!191 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!192 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !162, entity: !193, file: !14, line: 235)
!193 = !DISubprogram(name: "strtof", scope: !6, file: !6, line: 124, type: !194, flags: DIFlagPrototyped, spFlags: 0)
!194 = !DISubroutineType(types: !195)
!195 = !{!196, !109, !137}
!196 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!197 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !162, entity: !198, file: !14, line: 236)
!198 = !DISubprogram(name: "strtold", scope: !6, file: !6, line: 127, type: !199, flags: DIFlagPrototyped, spFlags: 0)
!199 = !DISubroutineType(types: !200)
!200 = !{!201, !109, !137}
!201 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!202 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !163, file: !14, line: 244)
!203 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !170, file: !14, line: 246)
!204 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !172, file: !14, line: 248)
!205 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !206, file: !14, line: 249)
!206 = !DISubprogram(name: "div", linkageName: "_ZN9__gnu_cxx3divExx", scope: !162, file: !14, line: 217, type: !177, flags: DIFlagPrototyped, spFlags: 0)
!207 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !176, file: !14, line: 250)
!208 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !180, file: !14, line: 252)
!209 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !193, file: !14, line: 253)
!210 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !184, file: !14, line: 254)
!211 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !188, file: !14, line: 255)
!212 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !198, file: !14, line: 256)
!213 = !{i32 7, !"Dwarf Version", i32 5}
!214 = !{i32 2, !"Debug Info Version", i32 3}
!215 = !{i32 1, !"wchar_size", i32 4}
!216 = !{i32 8, !"PIC Level", i32 2}
!217 = !{i32 7, !"uwtable", i32 2}
!218 = !{i32 7, !"frame-pointer", i32 2}
!219 = !{!"Ubuntu clang version 21.1.8 (++20251221032922+2078da43e25a-1~exp1~20251221153059.70)"}
!220 = distinct !DISubprogram(name: "bar_1", linkageName: "_Z5bar_1Ri", scope: !1, file: !1, line: 4, type: !221, scopeLine: 4, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !224)
!221 = !DISubroutineType(types: !222)
!222 = !{null, !223}
!223 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !9, size: 64)
!224 = !{}
!225 = !DILocalVariable(name: "b", arg: 1, scope: !220, file: !1, line: 4, type: !223)
!226 = !DILocation(line: 4, column: 17, scope: !220)
!227 = !DILocalVariable(name: "y", scope: !220, file: !1, line: 5, type: !9)
!228 = !DILocation(line: 5, column: 9, scope: !220)
!229 = !DILocation(line: 5, column: 13, scope: !220)
!230 = !{i64 4}
!231 = !DILocation(line: 5, column: 15, scope: !220)
!232 = !DILocation(line: 6, column: 1, scope: !220)
!233 = distinct !DISubprogram(name: "foo_1", linkageName: "_Z5foo_1Ri", scope: !1, file: !1, line: 8, type: !221, scopeLine: 8, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !224)
!234 = !DILocalVariable(name: "a", arg: 1, scope: !233, file: !1, line: 8, type: !223)
!235 = !DILocation(line: 8, column: 17, scope: !233)
!236 = !DILocalVariable(name: "z", scope: !233, file: !1, line: 9, type: !9)
!237 = !DILocation(line: 9, column: 9, scope: !233)
!238 = !DILocation(line: 10, column: 11, scope: !233)
!239 = !DILocation(line: 10, column: 5, scope: !233)
!240 = !DILocation(line: 11, column: 1, scope: !233)
!241 = distinct !DISubprogram(name: "bar_2", linkageName: "_Z5bar_2Ri", scope: !1, file: !1, line: 13, type: !221, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !224)
!242 = !DILocalVariable(name: "b", arg: 1, scope: !241, file: !1, line: 13, type: !223)
!243 = !DILocation(line: 13, column: 17, scope: !241)
!244 = !DILocation(line: 14, column: 5, scope: !241)
!245 = !DILocation(line: 14, column: 7, scope: !241)
!246 = !DILocation(line: 15, column: 1, scope: !241)
!247 = distinct !DISubprogram(name: "foo_2", linkageName: "_Z5foo_2Ri", scope: !1, file: !1, line: 17, type: !221, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !224)
!248 = !DILocalVariable(name: "a", arg: 1, scope: !247, file: !1, line: 17, type: !223)
!249 = !DILocation(line: 17, column: 17, scope: !247)
!250 = !DILocation(line: 18, column: 11, scope: !247)
!251 = !DILocation(line: 18, column: 5, scope: !247)
!252 = !DILocation(line: 19, column: 1, scope: !247)
!253 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 21, type: !122, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !224)
!254 = !DILocalVariable(name: "x", scope: !253, file: !1, line: 22, type: !9)
!255 = !DILocation(line: 22, column: 9, scope: !253)
!256 = !DILocation(line: 23, column: 5, scope: !253)
!257 = !DILocation(line: 24, column: 5, scope: !253)
!258 = !DILocation(line: 26, column: 5, scope: !253)
