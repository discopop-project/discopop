; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"argc\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"argv\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"j\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"a\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16436, i32 1)
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %a = alloca [20 x [20 x double]], align 16
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16436, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  %1 = ptrtoint i32* %argc.addr to i64
  call void @__dp_write(i32 16436, i64 %1, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i32 0, i32 0))
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !14, metadata !DIExpression()), !dbg !15
  %2 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_write(i32 16436, i64 %2, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i32 0, i32 0))
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !16, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.declare(metadata i32* %i, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32* %j, metadata !20, metadata !DIExpression()), !dbg !21
  call void @llvm.dbg.declare(metadata [20 x [20 x double]]* %a, metadata !22, metadata !DIExpression()), !dbg !27
  %arraydecay = getelementptr inbounds [20 x [20 x double]], [20 x [20 x double]]* %a, i64 0, i64 0, !dbg !28
  %3 = bitcast [20 x double]* %arraydecay to i8*, !dbg !28
  call void @__dp_call(i32 16441), !dbg !28
  call void @llvm.memset.p0i8.i64(i8* align 16 %3, i8 0, i64 3200, i1 false), !dbg !28
  %4 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16443, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !29
  br label %for.cond, !dbg !31

for.cond:                                         ; preds = %for.inc12, %entry
  call void @__dp_loop_entry(i32 16443, i32 0)
  %5 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16443, i64 %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %6 = load i32, i32* %i, align 4, !dbg !32
  %cmp = icmp slt i32 %6, 19, !dbg !34
  br i1 %cmp, label %for.body, label %for.end14, !dbg !35

for.body:                                         ; preds = %for.cond
  %7 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16445, i64 %7, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 0, i32* %j, align 4, !dbg !36
  br label %for.cond1, !dbg !39

for.cond1:                                        ; preds = %for.inc, %for.body
  call void @__dp_loop_entry(i32 16445, i32 1)
  %8 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16445, i64 %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %9 = load i32, i32* %j, align 4, !dbg !40
  %cmp2 = icmp slt i32 %9, 20, !dbg !42
  br i1 %cmp2, label %for.body3, label %for.end, !dbg !43

for.body3:                                        ; preds = %for.cond1
  %10 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16446, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %11 = load i32, i32* %i, align 4, !dbg !44
  %add = add nsw i32 %11, 1, !dbg !46
  %idxprom = sext i32 %add to i64, !dbg !47
  %arrayidx = getelementptr inbounds [20 x [20 x double]], [20 x [20 x double]]* %a, i64 0, i64 %idxprom, !dbg !47
  %12 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16446, i64 %12, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %13 = load i32, i32* %j, align 4, !dbg !48
  %idxprom4 = sext i32 %13 to i64, !dbg !47
  %arrayidx5 = getelementptr inbounds [20 x double], [20 x double]* %arrayidx, i64 0, i64 %idxprom4, !dbg !47
  %14 = ptrtoint double* %arrayidx5 to i64
  call void @__dp_read(i32 16446, i64 %14, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %15 = load double, double* %arrayidx5, align 8, !dbg !47
  %16 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16446, i64 %16, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %17 = load i32, i32* %i, align 4, !dbg !49
  %idxprom6 = sext i32 %17 to i64, !dbg !50
  %arrayidx7 = getelementptr inbounds [20 x [20 x double]], [20 x [20 x double]]* %a, i64 0, i64 %idxprom6, !dbg !50
  %18 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16446, i64 %18, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %19 = load i32, i32* %j, align 4, !dbg !51
  %idxprom8 = sext i32 %19 to i64, !dbg !50
  %arrayidx9 = getelementptr inbounds [20 x double], [20 x double]* %arrayidx7, i64 0, i64 %idxprom8, !dbg !50
  %20 = ptrtoint double* %arrayidx9 to i64
  call void @__dp_read(i32 16446, i64 %20, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %21 = load double, double* %arrayidx9, align 8, !dbg !52
  %add10 = fadd double %21, %15, !dbg !52
  %22 = ptrtoint double* %arrayidx9 to i64
  call void @__dp_write(i32 16446, i64 %22, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store double %add10, double* %arrayidx9, align 8, !dbg !52
  br label %for.inc, !dbg !53

for.inc:                                          ; preds = %for.body3
  %23 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16445, i64 %23, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %24 = load i32, i32* %j, align 4, !dbg !54
  %add11 = add nsw i32 %24, 1, !dbg !54
  %25 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16445, i64 %25, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 %add11, i32* %j, align 4, !dbg !54
  br label %for.cond1, !dbg !55, !llvm.loop !56

for.end:                                          ; preds = %for.cond1
  call void @__dp_loop_exit(i32 16448, i32 1)
  br label %for.inc12, !dbg !58

for.inc12:                                        ; preds = %for.end
  %26 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16443, i64 %26, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %27 = load i32, i32* %i, align 4, !dbg !59
  %add13 = add nsw i32 %27, 1, !dbg !59
  %28 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16443, i64 %28, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 %add13, i32* %i, align 4, !dbg !59
  br label %for.cond, !dbg !60, !llvm.loop !61

for.end14:                                        ; preds = %for.cond
  call void @__dp_loop_exit(i32 16449, i32 0)
  call void @__dp_finalize(i32 16449), !dbg !63
  ret i32 0, !dbg !63
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_call(i32)

; Function Attrs: argmemonly nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #2

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_loop_exit(i32, i32)

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly nounwind willreturn writeonly }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!3}
!llvm.module.flags = !{!4, !5, !6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/053")
!2 = !{}
!3 = !{!"Ubuntu clang version 11.1.0-6"}
!4 = !{i32 7, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 52, type: !8, scopeLine: 53, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10, !10, !11}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!13 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!14 = !DILocalVariable(name: "argc", arg: 1, scope: !7, file: !1, line: 52, type: !10)
!15 = !DILocation(line: 52, column: 14, scope: !7)
!16 = !DILocalVariable(name: "argv", arg: 2, scope: !7, file: !1, line: 52, type: !11)
!17 = !DILocation(line: 52, column: 25, scope: !7)
!18 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 54, type: !10)
!19 = !DILocation(line: 54, column: 7, scope: !7)
!20 = !DILocalVariable(name: "j", scope: !7, file: !1, line: 55, type: !10)
!21 = !DILocation(line: 55, column: 7, scope: !7)
!22 = !DILocalVariable(name: "a", scope: !7, file: !1, line: 56, type: !23)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 25600, elements: !25)
!24 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!25 = !{!26, !26}
!26 = !DISubrange(count: 20)
!27 = !DILocation(line: 56, column: 10, scope: !7)
!28 = !DILocation(line: 57, column: 3, scope: !7)
!29 = !DILocation(line: 59, column: 10, scope: !30)
!30 = distinct !DILexicalBlock(scope: !7, file: !1, line: 59, column: 3)
!31 = !DILocation(line: 59, column: 8, scope: !30)
!32 = !DILocation(line: 59, column: 15, scope: !33)
!33 = distinct !DILexicalBlock(scope: !30, file: !1, line: 59, column: 3)
!34 = !DILocation(line: 59, column: 17, scope: !33)
!35 = !DILocation(line: 59, column: 3, scope: !30)
!36 = !DILocation(line: 61, column: 12, scope: !37)
!37 = distinct !DILexicalBlock(scope: !38, file: !1, line: 61, column: 5)
!38 = distinct !DILexicalBlock(scope: !33, file: !1, line: 59, column: 34)
!39 = !DILocation(line: 61, column: 10, scope: !37)
!40 = !DILocation(line: 61, column: 17, scope: !41)
!41 = distinct !DILexicalBlock(scope: !37, file: !1, line: 61, column: 5)
!42 = !DILocation(line: 61, column: 19, scope: !41)
!43 = !DILocation(line: 61, column: 5, scope: !37)
!44 = !DILocation(line: 62, column: 20, scope: !45)
!45 = distinct !DILexicalBlock(scope: !41, file: !1, line: 61, column: 33)
!46 = !DILocation(line: 62, column: 22, scope: !45)
!47 = !DILocation(line: 62, column: 18, scope: !45)
!48 = !DILocation(line: 62, column: 27, scope: !45)
!49 = !DILocation(line: 62, column: 9, scope: !45)
!50 = !DILocation(line: 62, column: 7, scope: !45)
!51 = !DILocation(line: 62, column: 12, scope: !45)
!52 = !DILocation(line: 62, column: 15, scope: !45)
!53 = !DILocation(line: 63, column: 5, scope: !45)
!54 = !DILocation(line: 61, column: 27, scope: !41)
!55 = !DILocation(line: 61, column: 5, scope: !41)
!56 = distinct !{!56, !43, !57}
!57 = !DILocation(line: 63, column: 5, scope: !37)
!58 = !DILocation(line: 64, column: 3, scope: !38)
!59 = !DILocation(line: 59, column: 28, scope: !33)
!60 = !DILocation(line: 59, column: 3, scope: !33)
!61 = distinct !{!61, !35, !62}
!62 = !DILocation(line: 64, column: 3, scope: !30)
!63 = !DILocation(line: 65, column: 3, scope: !7)
