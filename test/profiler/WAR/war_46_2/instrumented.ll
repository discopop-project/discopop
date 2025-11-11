; ModuleID = 'test.cpp'
source_filename = "test.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"z\00", align 1
@.str.4 = private unnamed_addr constant [5 x i8] c".str\00", align 1
@.str.5 = private unnamed_addr constant [7 x i8] c".str.1\00", align 1
@.str.6 = private unnamed_addr constant [7 x i8] c".str.2\00", align 1
@.str.7 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c"x\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define void @_Z5bar_1Ri(i32* nonnull align 4 dereferenceable(4) %b) #0 !dbg !217 {
entry:
  call void @__dp_func_entry(i32 32772, i32 0)
  %b.addr = alloca i32*, align 8
  %0 = ptrtoint i32** %b.addr to i64
  call void @__dp_alloca(i32 32772, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0), i64 %0, i64 %0, i64 0, i64 1)
  %y = alloca i32, align 4
  %1 = ptrtoint i32* %y to i64
  call void @__dp_alloca(i32 32772, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0), i64 %1, i64 %1, i64 4, i64 1)
  %2 = ptrtoint i32** %b.addr to i64
  call void @__dp_write(i32 32772, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i32* %b, i32** %b.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %b.addr, metadata !221, metadata !DIExpression()), !dbg !222
  call void @llvm.dbg.declare(metadata i32* %y, metadata !223, metadata !DIExpression()), !dbg !224
  %3 = ptrtoint i32** %b.addr to i64
  call void @__dp_read(i32 32773, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %4 = load i32*, i32** %b.addr, align 8, !dbg !225
  %5 = ptrtoint i32* %4 to i64
  call void @__dp_read(i32 32773, i64 %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %6 = load i32, i32* %4, align 4, !dbg !225
  %add = add nsw i32 %6, 1, !dbg !226
  %7 = ptrtoint i32* %y to i64
  call void @__dp_write(i32 32773, i64 %7, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 %add, i32* %y, align 4, !dbg !224
  call void @__dp_func_exit(i32 32774, i32 0), !dbg !227
  ret void, !dbg !227
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define void @_Z5foo_1Ri(i32* nonnull align 4 dereferenceable(4) %a) #0 !dbg !228 {
entry:
  call void @__dp_func_entry(i32 32776, i32 0)
  %a.addr = alloca i32*, align 8
  %0 = ptrtoint i32** %a.addr to i64
  call void @__dp_alloca(i32 32776, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0), i64 %0, i64 %0, i64 0, i64 1)
  %z = alloca i32, align 4
  %1 = ptrtoint i32* %z to i64
  call void @__dp_alloca(i32 32776, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0), i64 %1, i64 %1, i64 4, i64 1)
  %2 = ptrtoint i32** %a.addr to i64
  call void @__dp_write(i32 32776, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32* %a, i32** %a.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %a.addr, metadata !229, metadata !DIExpression()), !dbg !230
  call void @llvm.dbg.declare(metadata i32* %z, metadata !231, metadata !DIExpression()), !dbg !232
  %3 = ptrtoint i32* %z to i64
  call void @__dp_write(i32 32777, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 2, i32* %z, align 4, !dbg !232
  %4 = ptrtoint i32** %a.addr to i64
  call void @__dp_read(i32 32778, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %5 = load i32*, i32** %a.addr, align 8, !dbg !233
  call void @__dp_call(i32 32778), !dbg !234
  call void @_Z5bar_1Ri(i32* nonnull align 4 dereferenceable(4) %5), !dbg !234
  call void @__dp_func_exit(i32 32779, i32 0), !dbg !235
  ret void, !dbg !235
}

; Function Attrs: noinline nounwind optnone uwtable
define void @_Z5bar_2Ri(i32* nonnull align 4 dereferenceable(4) %b) #0 !dbg !236 {
entry:
  call void @__dp_func_entry(i32 32781, i32 0)
  %b.addr = alloca i32*, align 8
  %0 = ptrtoint i32** %b.addr to i64
  call void @__dp_alloca(i32 32781, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0), i64 %0, i64 %0, i64 0, i64 1)
  %1 = ptrtoint i32** %b.addr to i64
  call void @__dp_write(i32 32781, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i32* %b, i32** %b.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %b.addr, metadata !237, metadata !DIExpression()), !dbg !238
  %2 = ptrtoint i32** %b.addr to i64
  call void @__dp_read(i32 32782, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %3 = load i32*, i32** %b.addr, align 8, !dbg !239
  %4 = ptrtoint i32* %3 to i64
  call void @__dp_write(i32 32782, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i32 2412, i32* %3, align 4, !dbg !240
  call void @__dp_func_exit(i32 32783, i32 0), !dbg !241
  ret void, !dbg !241
}

; Function Attrs: noinline nounwind optnone uwtable
define void @_Z5foo_2Ri(i32* nonnull align 4 dereferenceable(4) %a) #0 !dbg !242 {
entry:
  call void @__dp_func_entry(i32 32785, i32 0)
  %a.addr = alloca i32*, align 8
  %0 = ptrtoint i32** %a.addr to i64
  call void @__dp_alloca(i32 32785, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0), i64 %0, i64 %0, i64 0, i64 1)
  %1 = ptrtoint i32** %a.addr to i64
  call void @__dp_write(i32 32785, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32* %a, i32** %a.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %a.addr, metadata !243, metadata !DIExpression()), !dbg !244
  %2 = ptrtoint i32** %a.addr to i64
  call void @__dp_read(i32 32786, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %3 = load i32*, i32** %a.addr, align 8, !dbg !245
  call void @__dp_call(i32 32786), !dbg !246
  call void @_Z5bar_2Ri(i32* nonnull align 4 dereferenceable(4) %3), !dbg !246
  call void @__dp_func_exit(i32 32787, i32 0), !dbg !247
  ret void, !dbg !247
}

; Function Attrs: noinline norecurse nounwind optnone uwtable
define i32 @main() #2 !dbg !248 {
entry:
  call void @__dp_func_entry(i32 32789, i32 1)
  %retval = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_alloca(i32 32789, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.7, i32 0, i32 0), i64 %0, i64 %0, i64 4, i64 1)
  %x = alloca i32, align 4
  %1 = ptrtoint i32* %x to i64
  call void @__dp_alloca(i32 32789, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0), i64 %1, i64 %1, i64 4, i64 1)
  %2 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 32789, i64 %2, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.7, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %x, metadata !249, metadata !DIExpression()), !dbg !250
  %3 = ptrtoint i32* %x to i64
  call void @__dp_write(i32 32790, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  store i32 42, i32* %x, align 4, !dbg !250
  call void @__dp_call(i32 32791), !dbg !251
  call void @_Z5foo_1Ri(i32* nonnull align 4 dereferenceable(4) %x), !dbg !251
  call void @__dp_call(i32 32792), !dbg !252
  call void @_Z5foo_2Ri(i32* nonnull align 4 dereferenceable(4) %x), !dbg !252
  call void @__dp_finalize(i32 32794), !dbg !253
  call void @__dp_loop_output(), !dbg !253
  ret i32 0, !dbg !253
}

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

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!212, !213, !214, !215}
!llvm.ident = !{!216}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !1, producer: "clang version 11.1.0 (https://github.com/llvm/llvm-project.git 7e99bddfeaab2713a8bb6ca538da25b66e6efc59)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, imports: !3, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "test.cpp", directory: "/home/lukas/git/discopop/test/profiler/WAR/war_46_2")
!2 = !{}
!3 = !{!4, !12, !16, !23, !27, !32, !34, !42, !46, !50, !64, !68, !72, !76, !80, !85, !89, !93, !97, !101, !109, !113, !117, !119, !123, !127, !132, !138, !142, !146, !148, !156, !160, !168, !170, !174, !178, !182, !186, !191, !196, !201, !202, !203, !204, !206, !207, !208, !209, !210, !211}
!4 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !6, file: !11, line: 52)
!5 = !DINamespace(name: "std", scope: null)
!6 = !DISubprogram(name: "abs", scope: !7, file: !7, line: 980, type: !8, flags: DIFlagPrototyped, spFlags: 0)
!7 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!8 = !DISubroutineType(types: !9)
!9 = !{!10, !10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/13/../../../../include/c++/13/bits/std_abs.h", directory: "")
!12 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !13, file: !15, line: 131)
!13 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !7, line: 63, baseType: !14)
!14 = !DICompositeType(tag: DW_TAG_structure_type, file: !7, line: 59, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!15 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/13/../../../../include/c++/13/cstdlib", directory: "")
!16 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !17, file: !15, line: 132)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !7, line: 71, baseType: !18)
!18 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !7, line: 67, size: 128, flags: DIFlagTypePassByValue, elements: !19, identifier: "_ZTS6ldiv_t")
!19 = !{!20, !22}
!20 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !18, file: !7, line: 69, baseType: !21, size: 64)
!21 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !18, file: !7, line: 70, baseType: !21, size: 64, offset: 64)
!23 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !24, file: !15, line: 134)
!24 = !DISubprogram(name: "abort", scope: !7, file: !7, line: 730, type: !25, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!25 = !DISubroutineType(types: !26)
!26 = !{null}
!27 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !28, file: !15, line: 138)
!28 = !DISubprogram(name: "atexit", scope: !7, file: !7, line: 734, type: !29, flags: DIFlagPrototyped, spFlags: 0)
!29 = !DISubroutineType(types: !30)
!30 = !{!10, !31}
!31 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !25, size: 64)
!32 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !33, file: !15, line: 141)
!33 = !DISubprogram(name: "at_quick_exit", scope: !7, file: !7, line: 739, type: !29, flags: DIFlagPrototyped, spFlags: 0)
!34 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !35, file: !15, line: 144)
!35 = !DISubprogram(name: "atof", scope: !7, file: !7, line: 102, type: !36, flags: DIFlagPrototyped, spFlags: 0)
!36 = !DISubroutineType(types: !37)
!37 = !{!38, !39}
!38 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!39 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !40, size: 64)
!40 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !41)
!41 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!42 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !43, file: !15, line: 145)
!43 = !DISubprogram(name: "atoi", scope: !7, file: !7, line: 105, type: !44, flags: DIFlagPrototyped, spFlags: 0)
!44 = !DISubroutineType(types: !45)
!45 = !{!10, !39}
!46 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !47, file: !15, line: 146)
!47 = !DISubprogram(name: "atol", scope: !7, file: !7, line: 108, type: !48, flags: DIFlagPrototyped, spFlags: 0)
!48 = !DISubroutineType(types: !49)
!49 = !{!21, !39}
!50 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !51, file: !15, line: 147)
!51 = !DISubprogram(name: "bsearch", scope: !7, file: !7, line: 960, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!52 = !DISubroutineType(types: !53)
!53 = !{!54, !55, !55, !57, !57, !60}
!54 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!55 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !56, size: 64)
!56 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!57 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !58, line: 46, baseType: !59)
!58 = !DIFile(filename: "Software/llvm-11.1.0/lib/clang/11.1.0/include/stddef.h", directory: "/home/lukas")
!59 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!60 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !7, line: 948, baseType: !61)
!61 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !62, size: 64)
!62 = !DISubroutineType(types: !63)
!63 = !{!10, !55, !55}
!64 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !65, file: !15, line: 148)
!65 = !DISubprogram(name: "calloc", scope: !7, file: !7, line: 675, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!66 = !DISubroutineType(types: !67)
!67 = !{!54, !57, !57}
!68 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !69, file: !15, line: 149)
!69 = !DISubprogram(name: "div", scope: !7, file: !7, line: 992, type: !70, flags: DIFlagPrototyped, spFlags: 0)
!70 = !DISubroutineType(types: !71)
!71 = !{!13, !10, !10}
!72 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !73, file: !15, line: 150)
!73 = !DISubprogram(name: "exit", scope: !7, file: !7, line: 756, type: !74, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!74 = !DISubroutineType(types: !75)
!75 = !{null, !10}
!76 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !77, file: !15, line: 151)
!77 = !DISubprogram(name: "free", scope: !7, file: !7, line: 687, type: !78, flags: DIFlagPrototyped, spFlags: 0)
!78 = !DISubroutineType(types: !79)
!79 = !{null, !54}
!80 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !81, file: !15, line: 152)
!81 = !DISubprogram(name: "getenv", scope: !7, file: !7, line: 773, type: !82, flags: DIFlagPrototyped, spFlags: 0)
!82 = !DISubroutineType(types: !83)
!83 = !{!84, !39}
!84 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !41, size: 64)
!85 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !86, file: !15, line: 153)
!86 = !DISubprogram(name: "labs", scope: !7, file: !7, line: 981, type: !87, flags: DIFlagPrototyped, spFlags: 0)
!87 = !DISubroutineType(types: !88)
!88 = !{!21, !21}
!89 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !90, file: !15, line: 154)
!90 = !DISubprogram(name: "ldiv", scope: !7, file: !7, line: 994, type: !91, flags: DIFlagPrototyped, spFlags: 0)
!91 = !DISubroutineType(types: !92)
!92 = !{!17, !21, !21}
!93 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !94, file: !15, line: 155)
!94 = !DISubprogram(name: "malloc", scope: !7, file: !7, line: 672, type: !95, flags: DIFlagPrototyped, spFlags: 0)
!95 = !DISubroutineType(types: !96)
!96 = !{!54, !57}
!97 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !98, file: !15, line: 157)
!98 = !DISubprogram(name: "mblen", scope: !7, file: !7, line: 1062, type: !99, flags: DIFlagPrototyped, spFlags: 0)
!99 = !DISubroutineType(types: !100)
!100 = !{!10, !39, !57}
!101 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !102, file: !15, line: 158)
!102 = !DISubprogram(name: "mbstowcs", scope: !7, file: !7, line: 1073, type: !103, flags: DIFlagPrototyped, spFlags: 0)
!103 = !DISubroutineType(types: !104)
!104 = !{!57, !105, !108, !57}
!105 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !106)
!106 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !107, size: 64)
!107 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!108 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !39)
!109 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !110, file: !15, line: 159)
!110 = !DISubprogram(name: "mbtowc", scope: !7, file: !7, line: 1065, type: !111, flags: DIFlagPrototyped, spFlags: 0)
!111 = !DISubroutineType(types: !112)
!112 = !{!10, !105, !108, !57}
!113 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !114, file: !15, line: 161)
!114 = !DISubprogram(name: "qsort", scope: !7, file: !7, line: 970, type: !115, flags: DIFlagPrototyped, spFlags: 0)
!115 = !DISubroutineType(types: !116)
!116 = !{null, !54, !57, !57, !60}
!117 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !118, file: !15, line: 164)
!118 = !DISubprogram(name: "quick_exit", scope: !7, file: !7, line: 762, type: !74, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!119 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !120, file: !15, line: 167)
!120 = !DISubprogram(name: "rand", scope: !7, file: !7, line: 573, type: !121, flags: DIFlagPrototyped, spFlags: 0)
!121 = !DISubroutineType(types: !122)
!122 = !{!10}
!123 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !124, file: !15, line: 168)
!124 = !DISubprogram(name: "realloc", scope: !7, file: !7, line: 683, type: !125, flags: DIFlagPrototyped, spFlags: 0)
!125 = !DISubroutineType(types: !126)
!126 = !{!54, !54, !57}
!127 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !128, file: !15, line: 169)
!128 = !DISubprogram(name: "srand", scope: !7, file: !7, line: 575, type: !129, flags: DIFlagPrototyped, spFlags: 0)
!129 = !DISubroutineType(types: !130)
!130 = !{null, !131}
!131 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!132 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !133, file: !15, line: 170)
!133 = !DISubprogram(name: "strtod", scope: !7, file: !7, line: 118, type: !134, flags: DIFlagPrototyped, spFlags: 0)
!134 = !DISubroutineType(types: !135)
!135 = !{!38, !108, !136}
!136 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !137)
!137 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !84, size: 64)
!138 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !139, file: !15, line: 171)
!139 = !DISubprogram(name: "strtol", linkageName: "__isoc23_strtol", scope: !7, file: !7, line: 215, type: !140, flags: DIFlagPrototyped, spFlags: 0)
!140 = !DISubroutineType(types: !141)
!141 = !{!21, !108, !136, !10}
!142 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !143, file: !15, line: 172)
!143 = !DISubprogram(name: "strtoul", linkageName: "__isoc23_strtoul", scope: !7, file: !7, line: 219, type: !144, flags: DIFlagPrototyped, spFlags: 0)
!144 = !DISubroutineType(types: !145)
!145 = !{!59, !108, !136, !10}
!146 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !147, file: !15, line: 173)
!147 = !DISubprogram(name: "system", scope: !7, file: !7, line: 923, type: !44, flags: DIFlagPrototyped, spFlags: 0)
!148 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !149, file: !15, line: 175)
!149 = !DISubprogram(name: "wcstombs", scope: !7, file: !7, line: 1077, type: !150, flags: DIFlagPrototyped, spFlags: 0)
!150 = !DISubroutineType(types: !151)
!151 = !{!57, !152, !153, !57}
!152 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !84)
!153 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !154)
!154 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !155, size: 64)
!155 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !107)
!156 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !157, file: !15, line: 176)
!157 = !DISubprogram(name: "wctomb", scope: !7, file: !7, line: 1069, type: !158, flags: DIFlagPrototyped, spFlags: 0)
!158 = !DISubroutineType(types: !159)
!159 = !{!10, !84, !107}
!160 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !161, entity: !162, file: !15, line: 204)
!161 = !DINamespace(name: "__gnu_cxx", scope: null)
!162 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !7, line: 81, baseType: !163)
!163 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !7, line: 77, size: 128, flags: DIFlagTypePassByValue, elements: !164, identifier: "_ZTS7lldiv_t")
!164 = !{!165, !167}
!165 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !163, file: !7, line: 79, baseType: !166, size: 64)
!166 = !DIBasicType(name: "long long int", size: 64, encoding: DW_ATE_signed)
!167 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !163, file: !7, line: 80, baseType: !166, size: 64, offset: 64)
!168 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !161, entity: !169, file: !15, line: 210)
!169 = !DISubprogram(name: "_Exit", scope: !7, file: !7, line: 768, type: !74, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!170 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !161, entity: !171, file: !15, line: 214)
!171 = !DISubprogram(name: "llabs", scope: !7, file: !7, line: 984, type: !172, flags: DIFlagPrototyped, spFlags: 0)
!172 = !DISubroutineType(types: !173)
!173 = !{!166, !166}
!174 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !161, entity: !175, file: !15, line: 220)
!175 = !DISubprogram(name: "lldiv", scope: !7, file: !7, line: 998, type: !176, flags: DIFlagPrototyped, spFlags: 0)
!176 = !DISubroutineType(types: !177)
!177 = !{!162, !166, !166}
!178 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !161, entity: !179, file: !15, line: 231)
!179 = !DISubprogram(name: "atoll", scope: !7, file: !7, line: 113, type: !180, flags: DIFlagPrototyped, spFlags: 0)
!180 = !DISubroutineType(types: !181)
!181 = !{!166, !39}
!182 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !161, entity: !183, file: !15, line: 232)
!183 = !DISubprogram(name: "strtoll", linkageName: "__isoc23_strtoll", scope: !7, file: !7, line: 238, type: !184, flags: DIFlagPrototyped, spFlags: 0)
!184 = !DISubroutineType(types: !185)
!185 = !{!166, !108, !136, !10}
!186 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !161, entity: !187, file: !15, line: 233)
!187 = !DISubprogram(name: "strtoull", linkageName: "__isoc23_strtoull", scope: !7, file: !7, line: 243, type: !188, flags: DIFlagPrototyped, spFlags: 0)
!188 = !DISubroutineType(types: !189)
!189 = !{!190, !108, !136, !10}
!190 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!191 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !161, entity: !192, file: !15, line: 235)
!192 = !DISubprogram(name: "strtof", scope: !7, file: !7, line: 124, type: !193, flags: DIFlagPrototyped, spFlags: 0)
!193 = !DISubroutineType(types: !194)
!194 = !{!195, !108, !136}
!195 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!196 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !161, entity: !197, file: !15, line: 236)
!197 = !DISubprogram(name: "strtold", scope: !7, file: !7, line: 127, type: !198, flags: DIFlagPrototyped, spFlags: 0)
!198 = !DISubroutineType(types: !199)
!199 = !{!200, !108, !136}
!200 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!201 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !162, file: !15, line: 244)
!202 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !169, file: !15, line: 246)
!203 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !171, file: !15, line: 248)
!204 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !205, file: !15, line: 249)
!205 = !DISubprogram(name: "div", linkageName: "_ZN9__gnu_cxx3divExx", scope: !161, file: !15, line: 217, type: !176, flags: DIFlagPrototyped, spFlags: 0)
!206 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !175, file: !15, line: 250)
!207 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !179, file: !15, line: 252)
!208 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !192, file: !15, line: 253)
!209 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !183, file: !15, line: 254)
!210 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !187, file: !15, line: 255)
!211 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !5, entity: !197, file: !15, line: 256)
!212 = !{i32 7, !"Dwarf Version", i32 4}
!213 = !{i32 2, !"Debug Info Version", i32 3}
!214 = !{i32 1, !"wchar_size", i32 4}
!215 = !{i32 7, !"PIC Level", i32 2}
!216 = !{!"clang version 11.1.0 (https://github.com/llvm/llvm-project.git 7e99bddfeaab2713a8bb6ca538da25b66e6efc59)"}
!217 = distinct !DISubprogram(name: "bar_1", linkageName: "_Z5bar_1Ri", scope: !1, file: !1, line: 4, type: !218, scopeLine: 4, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!218 = !DISubroutineType(types: !219)
!219 = !{null, !220}
!220 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !10, size: 64)
!221 = !DILocalVariable(name: "b", arg: 1, scope: !217, file: !1, line: 4, type: !220)
!222 = !DILocation(line: 4, column: 17, scope: !217)
!223 = !DILocalVariable(name: "y", scope: !217, file: !1, line: 5, type: !10)
!224 = !DILocation(line: 5, column: 9, scope: !217)
!225 = !DILocation(line: 5, column: 13, scope: !217)
!226 = !DILocation(line: 5, column: 15, scope: !217)
!227 = !DILocation(line: 6, column: 1, scope: !217)
!228 = distinct !DISubprogram(name: "foo_1", linkageName: "_Z5foo_1Ri", scope: !1, file: !1, line: 8, type: !218, scopeLine: 8, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!229 = !DILocalVariable(name: "a", arg: 1, scope: !228, file: !1, line: 8, type: !220)
!230 = !DILocation(line: 8, column: 17, scope: !228)
!231 = !DILocalVariable(name: "z", scope: !228, file: !1, line: 9, type: !10)
!232 = !DILocation(line: 9, column: 9, scope: !228)
!233 = !DILocation(line: 10, column: 11, scope: !228)
!234 = !DILocation(line: 10, column: 5, scope: !228)
!235 = !DILocation(line: 11, column: 1, scope: !228)
!236 = distinct !DISubprogram(name: "bar_2", linkageName: "_Z5bar_2Ri", scope: !1, file: !1, line: 13, type: !218, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!237 = !DILocalVariable(name: "b", arg: 1, scope: !236, file: !1, line: 13, type: !220)
!238 = !DILocation(line: 13, column: 17, scope: !236)
!239 = !DILocation(line: 14, column: 5, scope: !236)
!240 = !DILocation(line: 14, column: 7, scope: !236)
!241 = !DILocation(line: 15, column: 1, scope: !236)
!242 = distinct !DISubprogram(name: "foo_2", linkageName: "_Z5foo_2Ri", scope: !1, file: !1, line: 17, type: !218, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!243 = !DILocalVariable(name: "a", arg: 1, scope: !242, file: !1, line: 17, type: !220)
!244 = !DILocation(line: 17, column: 17, scope: !242)
!245 = !DILocation(line: 18, column: 11, scope: !242)
!246 = !DILocation(line: 18, column: 5, scope: !242)
!247 = !DILocation(line: 19, column: 1, scope: !242)
!248 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 21, type: !121, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!249 = !DILocalVariable(name: "x", scope: !248, file: !1, line: 22, type: !10)
!250 = !DILocation(line: 22, column: 9, scope: !248)
!251 = !DILocation(line: 23, column: 5, scope: !248)
!252 = !DILocation(line: 24, column: 5, scope: !248)
!253 = !DILocation(line: 26, column: 5, scope: !248)
