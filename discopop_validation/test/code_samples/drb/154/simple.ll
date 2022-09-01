; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.omp_lock_t = type { i8* }

@.str = private unnamed_addr constant [5 x i8] c"%d\0A \00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !7 {
entry:
  %retval = alloca i32, align 4
  %lck = alloca %struct.omp_lock_t, align 8
  %var = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata %struct.omp_lock_t* %lck, metadata !11, metadata !DIExpression()), !dbg !18
  call void @llvm.dbg.declare(metadata i32* %var, metadata !19, metadata !DIExpression()), !dbg !20
  store i32 0, i32* %var, align 4, !dbg !20
  call void @omp_init_lock(%struct.omp_lock_t* %lck), !dbg !21
  call void @llvm.dbg.declare(metadata i32* %i, metadata !22, metadata !DIExpression()), !dbg !24
  store i32 0, i32* %i, align 4, !dbg !24
  br label %for.cond, !dbg !25

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !26
  %cmp = icmp slt i32 %0, 100, !dbg !28
  br i1 %cmp, label %for.body, label %for.end, !dbg !29

for.body:                                         ; preds = %for.cond
  call void @omp_set_lock(%struct.omp_lock_t* %lck), !dbg !30
  %1 = load i32, i32* %var, align 4, !dbg !32
  %inc = add nsw i32 %1, 1, !dbg !32
  store i32 %inc, i32* %var, align 4, !dbg !32
  call void @omp_unset_lock(%struct.omp_lock_t* %lck), !dbg !33
  br label %for.inc, !dbg !34

for.inc:                                          ; preds = %for.body
  %2 = load i32, i32* %i, align 4, !dbg !35
  %inc1 = add nsw i32 %2, 1, !dbg !35
  store i32 %inc1, i32* %i, align 4, !dbg !35
  br label %for.cond, !dbg !36, !llvm.loop !37

for.end:                                          ; preds = %for.cond
  call void @omp_destroy_lock(%struct.omp_lock_t* %lck), !dbg !39
  %3 = load i32, i32* %var, align 4, !dbg !40
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i64 0, i64 0), i32 %3), !dbg !41
  ret i32 0, !dbg !42
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local void @omp_init_lock(%struct.omp_lock_t*) #2

declare dso_local void @omp_set_lock(%struct.omp_lock_t*) #2

declare dso_local void @omp_unset_lock(%struct.omp_lock_t*) #2

declare dso_local void @omp_destroy_lock(%struct.omp_lock_t*) #2

declare dso_local i32 @printf(i8*, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/154")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"Ubuntu clang version 11.1.0-6"}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 18, type: !8, scopeLine: 18, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "lck", scope: !7, file: !1, line: 19, type: !12)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "omp_lock_t", file: !13, line: 84, baseType: !14)
!13 = !DIFile(filename: "/usr/lib/llvm-11/lib/clang/11.1.0/include/omp.h", directory: "")
!14 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "omp_lock_t", file: !13, line: 82, size: 64, elements: !15)
!15 = !{!16}
!16 = !DIDerivedType(tag: DW_TAG_member, name: "_lk", scope: !14, file: !13, line: 83, baseType: !17, size: 64)
!17 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!18 = !DILocation(line: 19, column: 14, scope: !7)
!19 = !DILocalVariable(name: "var", scope: !7, file: !1, line: 20, type: !10)
!20 = !DILocation(line: 20, column: 7, scope: !7)
!21 = !DILocation(line: 21, column: 3, scope: !7)
!22 = !DILocalVariable(name: "i", scope: !23, file: !1, line: 25, type: !10)
!23 = distinct !DILexicalBlock(scope: !7, file: !1, line: 25, column: 3)
!24 = !DILocation(line: 25, column: 12, scope: !23)
!25 = !DILocation(line: 25, column: 8, scope: !23)
!26 = !DILocation(line: 25, column: 17, scope: !27)
!27 = distinct !DILexicalBlock(scope: !23, file: !1, line: 25, column: 3)
!28 = !DILocation(line: 25, column: 18, scope: !27)
!29 = !DILocation(line: 25, column: 3, scope: !23)
!30 = !DILocation(line: 26, column: 5, scope: !31)
!31 = distinct !DILexicalBlock(scope: !27, file: !1, line: 25, column: 28)
!32 = !DILocation(line: 27, column: 8, scope: !31)
!33 = !DILocation(line: 28, column: 5, scope: !31)
!34 = !DILocation(line: 29, column: 3, scope: !31)
!35 = !DILocation(line: 25, column: 25, scope: !27)
!36 = !DILocation(line: 25, column: 3, scope: !27)
!37 = distinct !{!37, !29, !38}
!38 = !DILocation(line: 29, column: 3, scope: !23)
!39 = !DILocation(line: 31, column: 3, scope: !7)
!40 = !DILocation(line: 32, column: 18, scope: !7)
!41 = !DILocation(line: 32, column: 3, scope: !7)
!42 = !DILocation(line: 33, column: 3, scope: !7)
