; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.1 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"m\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"n\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.str = private unnamed_addr constant [24 x i8] c"Expected: -1; Real: %d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16403, i32 1)
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %m = alloca i32, align 4
  %n = alloca i32, align 4
  %b = alloca [4 x i32], align 16
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16403, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !11, metadata !DIExpression()), !dbg !12
  call void @llvm.dbg.declare(metadata i32* %m, metadata !13, metadata !DIExpression()), !dbg !14
  %1 = ptrtoint i32* %m to i64
  call void @__dp_write(i32 16405, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 2, i32* %m, align 4, !dbg !14
  call void @llvm.dbg.declare(metadata i32* %n, metadata !15, metadata !DIExpression()), !dbg !16
  %2 = ptrtoint i32* %n to i64
  call void @__dp_write(i32 16405, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 4, i32* %n, align 4, !dbg !16
  call void @llvm.dbg.declare(metadata [4 x i32]* %b, metadata !17, metadata !DIExpression()), !dbg !21
  %3 = bitcast [4 x i32]* %b to i8*, !dbg !21
  call void @__dp_call(i32 16406), !dbg !21
  call void @llvm.memset.p0i8.i64(i8* align 16 %3, i8 0, i64 16, i1 false), !dbg !21
  %4 = ptrtoint i32* %m to i64
  call void @__dp_read(i32 16409, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %5 = load i32, i32* %m, align 4, !dbg !22
  %6 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16409, i64 %6, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 %5, i32* %i, align 4, !dbg !24
  br label %for.cond, !dbg !25

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16409, i32 0)
  %7 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16409, i64 %7, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %8 = load i32, i32* %i, align 4, !dbg !26
  %9 = ptrtoint i32* %n to i64
  call void @__dp_read(i32 16409, i64 %9, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %10 = load i32, i32* %n, align 4, !dbg !28
  %cmp = icmp slt i32 %8, %10, !dbg !29
  br i1 %cmp, label %for.body, label %for.end, !dbg !30

for.body:                                         ; preds = %for.cond
  %11 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16410, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %12 = load i32, i32* %i, align 4, !dbg !31
  %13 = ptrtoint i32* %m to i64
  call void @__dp_read(i32 16410, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %14 = load i32, i32* %m, align 4, !dbg !32
  %sub = sub nsw i32 %12, %14, !dbg !33
  %idxprom = sext i32 %sub to i64, !dbg !34
  %arrayidx = getelementptr inbounds [4 x i32], [4 x i32]* %b, i64 0, i64 %idxprom, !dbg !34
  %15 = ptrtoint i32* %arrayidx to i64
  call void @__dp_read(i32 16410, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %16 = load i32, i32* %arrayidx, align 4, !dbg !34
  %conv = sitofp i32 %16 to float, !dbg !34
  %sub1 = fsub float %conv, 1.000000e+00, !dbg !35
  %conv2 = fptosi float %sub1 to i32, !dbg !34
  %17 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16410, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %18 = load i32, i32* %i, align 4, !dbg !36
  %idxprom3 = sext i32 %18 to i64, !dbg !37
  %arrayidx4 = getelementptr inbounds [4 x i32], [4 x i32]* %b, i64 0, i64 %idxprom3, !dbg !37
  %19 = ptrtoint i32* %arrayidx4 to i64
  call void @__dp_write(i32 16410, i64 %19, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 %conv2, i32* %arrayidx4, align 4, !dbg !38
  br label %for.inc, !dbg !37

for.inc:                                          ; preds = %for.body
  %20 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16409, i64 %20, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %21 = load i32, i32* %i, align 4, !dbg !39
  %inc = add nsw i32 %21, 1, !dbg !39
  %22 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16409, i64 %22, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !39
  br label %for.cond, !dbg !40, !llvm.loop !41

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16412, i32 0)
  %arrayidx5 = getelementptr inbounds [4 x i32], [4 x i32]* %b, i64 0, i64 3, !dbg !43
  %23 = ptrtoint i32* %arrayidx5 to i64
  call void @__dp_read(i32 16412, i64 %23, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %24 = load i32, i32* %arrayidx5, align 4, !dbg !43
  call void @__dp_call(i32 16412), !dbg !44
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str, i64 0, i64 0), i32 %24), !dbg !44
  call void @__dp_finalize(i32 16413), !dbg !45
  ret i32 0, !dbg !45
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_call(i32)

; Function Attrs: argmemonly nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #2

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_loop_exit(i32, i32)

declare dso_local i32 @printf(i8*, ...) #3

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly nounwind willreturn writeonly }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!3}
!llvm.module.flags = !{!4, !5, !6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/137")
!2 = !{}
!3 = !{!"Ubuntu clang version 11.1.0-6"}
!4 = !{i32 7, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 19, type: !8, scopeLine: 19, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 21, type: !10)
!12 = !DILocation(line: 21, column: 7, scope: !7)
!13 = !DILocalVariable(name: "m", scope: !7, file: !1, line: 21, type: !10)
!14 = !DILocation(line: 21, column: 10, scope: !7)
!15 = !DILocalVariable(name: "n", scope: !7, file: !1, line: 21, type: !10)
!16 = !DILocation(line: 21, column: 15, scope: !7)
!17 = !DILocalVariable(name: "b", scope: !7, file: !1, line: 22, type: !18)
!18 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 128, elements: !19)
!19 = !{!20}
!20 = !DISubrange(count: 4)
!21 = !DILocation(line: 22, column: 7, scope: !7)
!22 = !DILocation(line: 25, column: 12, scope: !23)
!23 = distinct !DILexicalBlock(scope: !7, file: !1, line: 25, column: 3)
!24 = !DILocation(line: 25, column: 10, scope: !23)
!25 = !DILocation(line: 25, column: 8, scope: !23)
!26 = !DILocation(line: 25, column: 15, scope: !27)
!27 = distinct !DILexicalBlock(scope: !23, file: !1, line: 25, column: 3)
!28 = !DILocation(line: 25, column: 17, scope: !27)
!29 = !DILocation(line: 25, column: 16, scope: !27)
!30 = !DILocation(line: 25, column: 3, scope: !23)
!31 = !DILocation(line: 26, column: 14, scope: !27)
!32 = !DILocation(line: 26, column: 16, scope: !27)
!33 = !DILocation(line: 26, column: 15, scope: !27)
!34 = !DILocation(line: 26, column: 12, scope: !27)
!35 = !DILocation(line: 26, column: 19, scope: !27)
!36 = !DILocation(line: 26, column: 7, scope: !27)
!37 = !DILocation(line: 26, column: 5, scope: !27)
!38 = !DILocation(line: 26, column: 10, scope: !27)
!39 = !DILocation(line: 25, column: 21, scope: !27)
!40 = !DILocation(line: 25, column: 3, scope: !27)
!41 = distinct !{!41, !30, !42}
!42 = !DILocation(line: 26, column: 21, scope: !23)
!43 = !DILocation(line: 28, column: 37, scope: !7)
!44 = !DILocation(line: 28, column: 3, scope: !7)
!45 = !DILocation(line: 29, column: 3, scope: !7)
