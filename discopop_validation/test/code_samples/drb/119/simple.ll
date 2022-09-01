; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.pair = type { i32, i32, %struct.omp_nest_lock_t }
%struct.omp_nest_lock_t = type { i8* }

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @incr_a(%struct.pair* %p) #0 !dbg !7 {
entry:
  %p.addr = alloca %struct.pair*, align 8
  store %struct.pair* %p, %struct.pair** %p.addr, align 8
  call void @llvm.dbg.declare(metadata %struct.pair** %p.addr, metadata !24, metadata !DIExpression()), !dbg !25
  %0 = load %struct.pair*, %struct.pair** %p.addr, align 8, !dbg !26
  %a = getelementptr inbounds %struct.pair, %struct.pair* %0, i32 0, i32 0, !dbg !27
  %1 = load i32, i32* %a, align 8, !dbg !28
  %add = add nsw i32 %1, 1, !dbg !28
  store i32 %add, i32* %a, align 8, !dbg !28
  ret void, !dbg !29
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @incr_b(%struct.pair* %p) #0 !dbg !30 {
entry:
  %p.addr = alloca %struct.pair*, align 8
  store %struct.pair* %p, %struct.pair** %p.addr, align 8
  call void @llvm.dbg.declare(metadata %struct.pair** %p.addr, metadata !31, metadata !DIExpression()), !dbg !32
  %0 = load %struct.pair*, %struct.pair** %p.addr, align 8, !dbg !33
  %b = getelementptr inbounds %struct.pair, %struct.pair* %0, i32 0, i32 1, !dbg !34
  %1 = load i32, i32* %b, align 4, !dbg !35
  %add = add nsw i32 %1, 1, !dbg !35
  store i32 %add, i32* %b, align 4, !dbg !35
  ret void, !dbg !36
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !37 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %p = alloca [1 x %struct.pair], align 16
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !43, metadata !DIExpression()), !dbg !44
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !45, metadata !DIExpression()), !dbg !46
  call void @llvm.dbg.declare(metadata [1 x %struct.pair]* %p, metadata !47, metadata !DIExpression()), !dbg !51
  %arraydecay = getelementptr inbounds [1 x %struct.pair], [1 x %struct.pair]* %p, i64 0, i64 0, !dbg !52
  %a = getelementptr inbounds %struct.pair, %struct.pair* %arraydecay, i32 0, i32 0, !dbg !52
  store i32 0, i32* %a, align 16, !dbg !53
  %arraydecay1 = getelementptr inbounds [1 x %struct.pair], [1 x %struct.pair]* %p, i64 0, i64 0, !dbg !54
  %b = getelementptr inbounds %struct.pair, %struct.pair* %arraydecay1, i32 0, i32 1, !dbg !54
  store i32 0, i32* %b, align 4, !dbg !55
  %arraydecay2 = getelementptr inbounds [1 x %struct.pair], [1 x %struct.pair]* %p, i64 0, i64 0, !dbg !56
  %lck = getelementptr inbounds %struct.pair, %struct.pair* %arraydecay2, i32 0, i32 2, !dbg !56
  call void @omp_init_nest_lock(%struct.omp_nest_lock_t* %lck), !dbg !57
  %arraydecay3 = getelementptr inbounds [1 x %struct.pair], [1 x %struct.pair]* %p, i64 0, i64 0, !dbg !58
  %lck4 = getelementptr inbounds %struct.pair, %struct.pair* %arraydecay3, i32 0, i32 2, !dbg !58
  call void @omp_set_nest_lock(%struct.omp_nest_lock_t* %lck4), !dbg !61
  %arraydecay5 = getelementptr inbounds [1 x %struct.pair], [1 x %struct.pair]* %p, i64 0, i64 0, !dbg !62
  call void @incr_b(%struct.pair* %arraydecay5), !dbg !63
  %arraydecay6 = getelementptr inbounds [1 x %struct.pair], [1 x %struct.pair]* %p, i64 0, i64 0, !dbg !64
  call void @incr_a(%struct.pair* %arraydecay6), !dbg !65
  %arraydecay7 = getelementptr inbounds [1 x %struct.pair], [1 x %struct.pair]* %p, i64 0, i64 0, !dbg !66
  %lck8 = getelementptr inbounds %struct.pair, %struct.pair* %arraydecay7, i32 0, i32 2, !dbg !66
  call void @omp_unset_nest_lock(%struct.omp_nest_lock_t* %lck8), !dbg !67
  %arraydecay9 = getelementptr inbounds [1 x %struct.pair], [1 x %struct.pair]* %p, i64 0, i64 0, !dbg !68
  call void @incr_b(%struct.pair* %arraydecay9), !dbg !69
  %arraydecay10 = getelementptr inbounds [1 x %struct.pair], [1 x %struct.pair]* %p, i64 0, i64 0, !dbg !70
  %lck11 = getelementptr inbounds %struct.pair, %struct.pair* %arraydecay10, i32 0, i32 2, !dbg !70
  call void @omp_destroy_nest_lock(%struct.omp_nest_lock_t* %lck11), !dbg !71
  %arraydecay12 = getelementptr inbounds [1 x %struct.pair], [1 x %struct.pair]* %p, i64 0, i64 0, !dbg !72
  %b13 = getelementptr inbounds %struct.pair, %struct.pair* %arraydecay12, i32 0, i32 1, !dbg !72
  %0 = load i32, i32* %b13, align 4, !dbg !72
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 %0), !dbg !73
  ret i32 0, !dbg !74
}

declare dso_local void @omp_init_nest_lock(%struct.omp_nest_lock_t*) #2

declare dso_local void @omp_set_nest_lock(%struct.omp_nest_lock_t*) #2

declare dso_local void @omp_unset_nest_lock(%struct.omp_nest_lock_t*) #2

declare dso_local void @omp_destroy_nest_lock(%struct.omp_nest_lock_t*) #2

declare dso_local i32 @printf(i8*, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/119")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"Ubuntu clang version 11.1.0-6"}
!7 = distinct !DISubprogram(name: "incr_a", scope: !1, file: !1, line: 27, type: !8, scopeLine: 27, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{null, !10}
!10 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 64)
!11 = !DIDerivedType(tag: DW_TAG_typedef, name: "pair", file: !1, line: 25, baseType: !12)
!12 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !1, line: 22, size: 128, elements: !13)
!13 = !{!14, !16, !17}
!14 = !DIDerivedType(tag: DW_TAG_member, name: "a", scope: !12, file: !1, line: 23, baseType: !15, size: 32)
!15 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!16 = !DIDerivedType(tag: DW_TAG_member, name: "b", scope: !12, file: !1, line: 23, baseType: !15, size: 32, offset: 32)
!17 = !DIDerivedType(tag: DW_TAG_member, name: "lck", scope: !12, file: !1, line: 24, baseType: !18, size: 64, offset: 64)
!18 = !DIDerivedType(tag: DW_TAG_typedef, name: "omp_nest_lock_t", file: !19, line: 95, baseType: !20)
!19 = !DIFile(filename: "/usr/lib/llvm-11/lib/clang/11.1.0/include/omp.h", directory: "")
!20 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "omp_nest_lock_t", file: !19, line: 93, size: 64, elements: !21)
!21 = !{!22}
!22 = !DIDerivedType(tag: DW_TAG_member, name: "_lk", scope: !20, file: !19, line: 94, baseType: !23, size: 64)
!23 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!24 = !DILocalVariable(name: "p", arg: 1, scope: !7, file: !1, line: 27, type: !10)
!25 = !DILocation(line: 27, column: 19, scope: !7)
!26 = !DILocation(line: 28, column: 3, scope: !7)
!27 = !DILocation(line: 28, column: 6, scope: !7)
!28 = !DILocation(line: 28, column: 8, scope: !7)
!29 = !DILocation(line: 29, column: 1, scope: !7)
!30 = distinct !DISubprogram(name: "incr_b", scope: !1, file: !1, line: 31, type: !8, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!31 = !DILocalVariable(name: "p", arg: 1, scope: !30, file: !1, line: 31, type: !10)
!32 = !DILocation(line: 31, column: 19, scope: !30)
!33 = !DILocation(line: 32, column: 3, scope: !30)
!34 = !DILocation(line: 32, column: 6, scope: !30)
!35 = !DILocation(line: 32, column: 8, scope: !30)
!36 = !DILocation(line: 33, column: 1, scope: !30)
!37 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 36, type: !38, scopeLine: 37, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!38 = !DISubroutineType(types: !39)
!39 = !{!15, !15, !40}
!40 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !41, size: 64)
!41 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !42, size: 64)
!42 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!43 = !DILocalVariable(name: "argc", arg: 1, scope: !37, file: !1, line: 36, type: !15)
!44 = !DILocation(line: 36, column: 14, scope: !37)
!45 = !DILocalVariable(name: "argv", arg: 2, scope: !37, file: !1, line: 36, type: !40)
!46 = !DILocation(line: 36, column: 26, scope: !37)
!47 = !DILocalVariable(name: "p", scope: !37, file: !1, line: 38, type: !48)
!48 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 128, elements: !49)
!49 = !{!50}
!50 = !DISubrange(count: 1)
!51 = !DILocation(line: 38, column: 8, scope: !37)
!52 = !DILocation(line: 39, column: 6, scope: !37)
!53 = !DILocation(line: 39, column: 8, scope: !37)
!54 = !DILocation(line: 40, column: 6, scope: !37)
!55 = !DILocation(line: 40, column: 8, scope: !37)
!56 = !DILocation(line: 41, column: 26, scope: !37)
!57 = !DILocation(line: 41, column: 3, scope: !37)
!58 = !DILocation(line: 47, column: 29, scope: !59)
!59 = distinct !DILexicalBlock(scope: !60, file: !1, line: 46, column: 5)
!60 = distinct !DILexicalBlock(scope: !37, file: !1, line: 44, column: 3)
!61 = !DILocation(line: 47, column: 7, scope: !59)
!62 = !DILocation(line: 48, column: 14, scope: !59)
!63 = !DILocation(line: 48, column: 7, scope: !59)
!64 = !DILocation(line: 49, column: 14, scope: !59)
!65 = !DILocation(line: 49, column: 7, scope: !59)
!66 = !DILocation(line: 50, column: 31, scope: !59)
!67 = !DILocation(line: 50, column: 7, scope: !59)
!68 = !DILocation(line: 53, column: 14, scope: !60)
!69 = !DILocation(line: 53, column: 7, scope: !60)
!70 = !DILocation(line: 56, column: 29, scope: !37)
!71 = !DILocation(line: 56, column: 3, scope: !37)
!72 = !DILocation(line: 58, column: 20, scope: !37)
!73 = !DILocation(line: 58, column: 3, scope: !37)
!74 = !DILocation(line: 59, column: 3, scope: !37)
