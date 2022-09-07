; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@b = dso_local global [1000 x [1000 x double]] zeroinitializer, align 16, !dbg !0
@.str.1 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"argc\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"argv\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"n\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"m\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.7 = private unnamed_addr constant [2 x i8] c"j\00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.str.9 = private unnamed_addr constant [2 x i8] c"*\00", align 1
@.str = private unnamed_addr constant [16 x i8] c"b[500][500]=%f\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !14 {
entry:
  call void @__dp_func_entry(i32 16440, i32 1)
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16440, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  %1 = ptrtoint i32* %argc.addr to i64
  call void @__dp_write(i32 16440, i64 %1, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i32 0, i32 0))
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !21, metadata !DIExpression()), !dbg !22
  %2 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_write(i32 16440, i64 %2, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0))
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !23, metadata !DIExpression()), !dbg !24
  call void @llvm.dbg.declare(metadata i32* %i, metadata !25, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.declare(metadata i32* %j, metadata !27, metadata !DIExpression()), !dbg !28
  call void @llvm.dbg.declare(metadata i32* %n, metadata !29, metadata !DIExpression()), !dbg !30
  %3 = ptrtoint i32* %n to i64
  call void @__dp_write(i32 16443, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 1000, i32* %n, align 4, !dbg !30
  call void @llvm.dbg.declare(metadata i32* %m, metadata !31, metadata !DIExpression()), !dbg !32
  %4 = ptrtoint i32* %m to i64
  call void @__dp_write(i32 16443, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 1000, i32* %m, align 4, !dbg !32
  %5 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16444, i64 %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !33
  br label %for.cond, !dbg !35

for.cond:                                         ; preds = %for.inc10, %entry
  call void @__dp_loop_entry(i32 16444, i32 0)
  %6 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16444, i64 %6, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %7 = load i32, i32* %i, align 4, !dbg !36
  %8 = ptrtoint i32* %n to i64
  call void @__dp_read(i32 16444, i64 %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %9 = load i32, i32* %n, align 4, !dbg !38
  %cmp = icmp slt i32 %7, %9, !dbg !39
  br i1 %cmp, label %for.body, label %for.end12, !dbg !40

for.body:                                         ; preds = %for.cond
  %10 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16446, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 1, i32* %j, align 4, !dbg !41
  br label %for.cond1, !dbg !43

for.cond1:                                        ; preds = %for.inc, %for.body
  call void @__dp_loop_entry(i32 16446, i32 1)
  %11 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16446, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %12 = load i32, i32* %j, align 4, !dbg !44
  %13 = ptrtoint i32* %m to i64
  call void @__dp_read(i32 16446, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %14 = load i32, i32* %m, align 4, !dbg !46
  %cmp2 = icmp slt i32 %12, %14, !dbg !47
  br i1 %cmp2, label %for.body3, label %for.end, !dbg !48

for.body3:                                        ; preds = %for.cond1
  %15 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16447, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %16 = load i32, i32* %i, align 4, !dbg !49
  %idxprom = sext i32 %16 to i64, !dbg !50
  %arrayidx = getelementptr inbounds [1000 x [1000 x double]], [1000 x [1000 x double]]* @b, i64 0, i64 %idxprom, !dbg !50
  %17 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16447, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %18 = load i32, i32* %j, align 4, !dbg !51
  %sub = sub nsw i32 %18, 1, !dbg !52
  %idxprom4 = sext i32 %sub to i64, !dbg !50
  %arrayidx5 = getelementptr inbounds [1000 x double], [1000 x double]* %arrayidx, i64 0, i64 %idxprom4, !dbg !50
  %19 = ptrtoint double* %arrayidx5 to i64
  call void @__dp_read(i32 16447, i64 %19, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %20 = load double, double* %arrayidx5, align 8, !dbg !50
  %21 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16447, i64 %21, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %22 = load i32, i32* %i, align 4, !dbg !53
  %idxprom6 = sext i32 %22 to i64, !dbg !54
  %arrayidx7 = getelementptr inbounds [1000 x [1000 x double]], [1000 x [1000 x double]]* @b, i64 0, i64 %idxprom6, !dbg !54
  %23 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16447, i64 %23, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %24 = load i32, i32* %j, align 4, !dbg !55
  %idxprom8 = sext i32 %24 to i64, !dbg !54
  %arrayidx9 = getelementptr inbounds [1000 x double], [1000 x double]* %arrayidx7, i64 0, i64 %idxprom8, !dbg !54
  %25 = ptrtoint double* %arrayidx9 to i64
  call void @__dp_write(i32 16447, i64 %25, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  store double %20, double* %arrayidx9, align 8, !dbg !56
  br label %for.inc, !dbg !54

for.inc:                                          ; preds = %for.body3
  %26 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16446, i64 %26, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %27 = load i32, i32* %j, align 4, !dbg !57
  %inc = add nsw i32 %27, 1, !dbg !57
  %28 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16446, i64 %28, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 %inc, i32* %j, align 4, !dbg !57
  br label %for.cond1, !dbg !58, !llvm.loop !59

for.end:                                          ; preds = %for.cond1
  call void @__dp_loop_exit(i32 16447, i32 1)
  br label %for.inc10, !dbg !60

for.inc10:                                        ; preds = %for.end
  %29 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16444, i64 %29, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %30 = load i32, i32* %i, align 4, !dbg !61
  %inc11 = add nsw i32 %30, 1, !dbg !61
  %31 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16444, i64 %31, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 %inc11, i32* %i, align 4, !dbg !61
  br label %for.cond, !dbg !62, !llvm.loop !63

for.end12:                                        ; preds = %for.cond
  call void @__dp_loop_exit(i32 16449, i32 0)
  %32 = ptrtoint double* getelementptr inbounds ([1000 x [1000 x double]], [1000 x [1000 x double]]* @b, i64 0, i64 500, i64 500) to i64
  call void @__dp_read(i32 16449, i64 %32, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  %33 = load double, double* getelementptr inbounds ([1000 x [1000 x double]], [1000 x [1000 x double]]* @b, i64 0, i64 500, i64 500), align 16, !dbg !65
  call void @__dp_call(i32 16449), !dbg !66
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i64 0, i64 0), double %33), !dbg !66
  call void @__dp_finalize(i32 16450), !dbg !67
  ret i32 0, !dbg !67
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_loop_exit(i32, i32)

declare void @__dp_call(i32)

declare dso_local i32 @printf(i8*, ...) #2

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!10}
!llvm.module.flags = !{!11, !12, !13}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !3, line: 54, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/037")
!4 = !{}
!5 = !{!0}
!6 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 64000000, elements: !8)
!7 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!8 = !{!9, !9}
!9 = !DISubrange(count: 1000)
!10 = !{!"Ubuntu clang version 11.1.0-6"}
!11 = !{i32 7, !"Dwarf Version", i32 4}
!12 = !{i32 2, !"Debug Info Version", i32 3}
!13 = !{i32 1, !"wchar_size", i32 4}
!14 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 56, type: !15, scopeLine: 57, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!15 = !DISubroutineType(types: !16)
!16 = !{!17, !17, !18}
!17 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!19 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64)
!20 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!21 = !DILocalVariable(name: "argc", arg: 1, scope: !14, file: !3, line: 56, type: !17)
!22 = !DILocation(line: 56, column: 14, scope: !14)
!23 = !DILocalVariable(name: "argv", arg: 2, scope: !14, file: !3, line: 56, type: !18)
!24 = !DILocation(line: 56, column: 26, scope: !14)
!25 = !DILocalVariable(name: "i", scope: !14, file: !3, line: 58, type: !17)
!26 = !DILocation(line: 58, column: 7, scope: !14)
!27 = !DILocalVariable(name: "j", scope: !14, file: !3, line: 58, type: !17)
!28 = !DILocation(line: 58, column: 9, scope: !14)
!29 = !DILocalVariable(name: "n", scope: !14, file: !3, line: 59, type: !17)
!30 = !DILocation(line: 59, column: 7, scope: !14)
!31 = !DILocalVariable(name: "m", scope: !14, file: !3, line: 59, type: !17)
!32 = !DILocation(line: 59, column: 15, scope: !14)
!33 = !DILocation(line: 60, column: 9, scope: !34)
!34 = distinct !DILexicalBlock(scope: !14, file: !3, line: 60, column: 3)
!35 = !DILocation(line: 60, column: 8, scope: !34)
!36 = !DILocation(line: 60, column: 12, scope: !37)
!37 = distinct !DILexicalBlock(scope: !34, file: !3, line: 60, column: 3)
!38 = !DILocation(line: 60, column: 14, scope: !37)
!39 = !DILocation(line: 60, column: 13, scope: !37)
!40 = !DILocation(line: 60, column: 3, scope: !34)
!41 = !DILocation(line: 62, column: 11, scope: !42)
!42 = distinct !DILexicalBlock(scope: !37, file: !3, line: 62, column: 5)
!43 = !DILocation(line: 62, column: 10, scope: !42)
!44 = !DILocation(line: 62, column: 14, scope: !45)
!45 = distinct !DILexicalBlock(scope: !42, file: !3, line: 62, column: 5)
!46 = !DILocation(line: 62, column: 16, scope: !45)
!47 = !DILocation(line: 62, column: 15, scope: !45)
!48 = !DILocation(line: 62, column: 5, scope: !42)
!49 = !DILocation(line: 63, column: 17, scope: !45)
!50 = !DILocation(line: 63, column: 15, scope: !45)
!51 = !DILocation(line: 63, column: 20, scope: !45)
!52 = !DILocation(line: 63, column: 21, scope: !45)
!53 = !DILocation(line: 63, column: 9, scope: !45)
!54 = !DILocation(line: 63, column: 7, scope: !45)
!55 = !DILocation(line: 63, column: 12, scope: !45)
!56 = !DILocation(line: 63, column: 14, scope: !45)
!57 = !DILocation(line: 62, column: 19, scope: !45)
!58 = !DILocation(line: 62, column: 5, scope: !45)
!59 = distinct !{!59, !48, !60}
!60 = !DILocation(line: 63, column: 23, scope: !42)
!61 = !DILocation(line: 60, column: 17, scope: !37)
!62 = !DILocation(line: 60, column: 3, scope: !37)
!63 = distinct !{!63, !40, !64}
!64 = !DILocation(line: 63, column: 23, scope: !34)
!65 = !DILocation(line: 65, column: 30, scope: !14)
!66 = !DILocation(line: 65, column: 3, scope: !14)
!67 = !DILocation(line: 66, column: 3, scope: !14)
