; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.omp_lock_t = type { i8* }

@.str = private unnamed_addr constant [5 x i8] c"i==3\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"simple.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !7 {
entry:
  %retval = alloca i32, align 4
  %lck = alloca %struct.omp_lock_t, align 8
  %i = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata %struct.omp_lock_t* %lck, metadata !11, metadata !DIExpression()), !dbg !18
  call void @llvm.dbg.declare(metadata i32* %i, metadata !19, metadata !DIExpression()), !dbg !20
  store i32 0, i32* %i, align 4, !dbg !20
  call void @omp_init_lock(%struct.omp_lock_t* %lck), !dbg !21
  call void @omp_set_lock(%struct.omp_lock_t* %lck), !dbg !22
  %0 = load i32, i32* %i, align 4, !dbg !25
  %add = add nsw i32 %0, 1, !dbg !25
  store i32 %add, i32* %i, align 4, !dbg !25
  call void @omp_unset_lock(%struct.omp_lock_t* %lck), !dbg !26
  call void @omp_set_lock(%struct.omp_lock_t* %lck), !dbg !27
  %1 = load i32, i32* %i, align 4, !dbg !29
  %add1 = add nsw i32 %1, 2, !dbg !29
  store i32 %add1, i32* %i, align 4, !dbg !29
  call void @omp_unset_lock(%struct.omp_lock_t* %lck), !dbg !30
  call void @omp_destroy_lock(%struct.omp_lock_t* %lck), !dbg !31
  %2 = load i32, i32* %i, align 4, !dbg !32
  %cmp = icmp eq i32 %2, 3, !dbg !32
  br i1 %cmp, label %if.then, label %if.else, !dbg !35

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !35

if.else:                                          ; preds = %entry
  call void @__assert_fail(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i64 0, i64 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i64 0, i64 0), i32 75, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !32
  unreachable, !dbg !32

if.end:                                           ; preds = %if.then
  ret i32 0, !dbg !36
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local void @omp_init_lock(%struct.omp_lock_t*) #2

declare dso_local void @omp_set_lock(%struct.omp_lock_t*) #2

declare dso_local void @omp_unset_lock(%struct.omp_lock_t*) #2

declare dso_local void @omp_destroy_lock(%struct.omp_lock_t*) #2

; Function Attrs: noreturn nounwind
declare dso_local void @__assert_fail(i8*, i8*, i32, i8*) #3

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noreturn nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/069")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"Ubuntu clang version 11.1.0-6"}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 53, type: !8, scopeLine: 54, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "lck", scope: !7, file: !1, line: 55, type: !12)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "omp_lock_t", file: !13, line: 84, baseType: !14)
!13 = !DIFile(filename: "/usr/lib/llvm-11/lib/clang/11.1.0/include/omp.h", directory: "")
!14 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "omp_lock_t", file: !13, line: 82, size: 64, elements: !15)
!15 = !{!16}
!16 = !DIDerivedType(tag: DW_TAG_member, name: "_lk", scope: !14, file: !13, line: 83, baseType: !17, size: 64)
!17 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!18 = !DILocation(line: 55, column: 14, scope: !7)
!19 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 56, type: !10)
!20 = !DILocation(line: 56, column: 7, scope: !7)
!21 = !DILocation(line: 57, column: 3, scope: !7)
!22 = !DILocation(line: 62, column: 7, scope: !23)
!23 = distinct !DILexicalBlock(scope: !24, file: !1, line: 61, column: 5)
!24 = distinct !DILexicalBlock(scope: !7, file: !1, line: 59, column: 3)
!25 = !DILocation(line: 63, column: 9, scope: !23)
!26 = !DILocation(line: 64, column: 7, scope: !23)
!27 = !DILocation(line: 68, column: 7, scope: !28)
!28 = distinct !DILexicalBlock(scope: !24, file: !1, line: 67, column: 5)
!29 = !DILocation(line: 69, column: 9, scope: !28)
!30 = !DILocation(line: 70, column: 7, scope: !28)
!31 = !DILocation(line: 74, column: 3, scope: !7)
!32 = !DILocation(line: 75, column: 3, scope: !33)
!33 = distinct !DILexicalBlock(scope: !34, file: !1, line: 75, column: 3)
!34 = distinct !DILexicalBlock(scope: !7, file: !1, line: 75, column: 3)
!35 = !DILocation(line: 75, column: 3, scope: !34)
!36 = !DILocation(line: 76, column: 3, scope: !7)
