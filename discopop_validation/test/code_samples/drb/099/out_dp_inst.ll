; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.1 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"N\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.5 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.6 = private unnamed_addr constant [5 x i8] c"argc\00", align 1
@.str.7 = private unnamed_addr constant [5 x i8] c"argv\00", align 1
@.str.8 = private unnamed_addr constant [4 x i8] c"len\00", align 1
@.str.9 = private unnamed_addr constant [12 x i8] c"saved_stack\00", align 1
@.str.10 = private unnamed_addr constant [12 x i8] c"__vla_expr0\00", align 1
@.str.11 = private unnamed_addr constant [12 x i8] c"__vla_expr1\00", align 1
@.str = private unnamed_addr constant [10 x i8] c"b[50]=%f\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo(double* %a, double* %b, i32 %N) #0 !dbg !9 {
entry:
  call void @__dp_func_entry(i32 16434, i32 0)
  %a.addr = alloca double*, align 8
  %b.addr = alloca double*, align 8
  %N.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %0 = ptrtoint double** %a.addr to i64
  call void @__dp_write(i32 16434, i64 %0, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store double* %a, double** %a.addr, align 8
  call void @llvm.dbg.declare(metadata double** %a.addr, metadata !14, metadata !DIExpression()), !dbg !15
  %1 = ptrtoint double** %b.addr to i64
  call void @__dp_write(i32 16434, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store double* %b, double** %b.addr, align 8
  call void @llvm.dbg.declare(metadata double** %b.addr, metadata !16, metadata !DIExpression()), !dbg !17
  %2 = ptrtoint i32* %N.addr to i64
  call void @__dp_write(i32 16434, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 %N, i32* %N.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %N.addr, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32* %i, metadata !20, metadata !DIExpression()), !dbg !21
  %3 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16439, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !22
  br label %for.cond, !dbg !24

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16439, i32 0)
  %4 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16439, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %5 = load i32, i32* %i, align 4, !dbg !25
  %6 = ptrtoint i32* %N.addr to i64
  call void @__dp_read(i32 16439, i64 %6, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %7 = load i32, i32* %N.addr, align 4, !dbg !27
  %cmp = icmp slt i32 %5, %7, !dbg !28
  br i1 %cmp, label %for.body, label %for.end, !dbg !29

for.body:                                         ; preds = %for.cond
  %8 = ptrtoint double** %a.addr to i64
  call void @__dp_read(i32 16440, i64 %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %9 = load double*, double** %a.addr, align 8, !dbg !30
  %10 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16440, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %11 = load i32, i32* %i, align 4, !dbg !31
  %idxprom = sext i32 %11 to i64, !dbg !30
  %arrayidx = getelementptr inbounds double, double* %9, i64 %idxprom, !dbg !30
  %12 = ptrtoint double* %arrayidx to i64
  call void @__dp_read(i32 16440, i64 %12, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %13 = load double, double* %arrayidx, align 8, !dbg !30
  %14 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16440, i64 %14, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %15 = load i32, i32* %i, align 4, !dbg !32
  %conv = sitofp i32 %15 to double, !dbg !33
  %mul = fmul double %13, %conv, !dbg !34
  %16 = ptrtoint double** %b.addr to i64
  call void @__dp_read(i32 16440, i64 %16, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %17 = load double*, double** %b.addr, align 8, !dbg !35
  %18 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16440, i64 %18, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %19 = load i32, i32* %i, align 4, !dbg !36
  %idxprom1 = sext i32 %19 to i64, !dbg !35
  %arrayidx2 = getelementptr inbounds double, double* %17, i64 %idxprom1, !dbg !35
  %20 = ptrtoint double* %arrayidx2 to i64
  call void @__dp_write(i32 16440, i64 %20, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store double %mul, double* %arrayidx2, align 8, !dbg !37
  br label %for.inc, !dbg !35

for.inc:                                          ; preds = %for.body
  %21 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16439, i64 %21, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %22 = load i32, i32* %i, align 4, !dbg !38
  %inc = add nsw i32 %22, 1, !dbg !38
  %23 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16439, i64 %23, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !38
  br label %for.cond, !dbg !39, !llvm.loop !40

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16441, i32 0)
  call void @__dp_func_exit(i32 16441, i32 0), !dbg !42
  ret void, !dbg !42
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_loop_exit(i32, i32)

declare void @__dp_func_exit(i32, i32)

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !43 {
entry:
  call void @__dp_func_entry(i32 16443, i32 1)
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %len = alloca i32, align 4
  %saved_stack = alloca i8*, align 8
  %__vla_expr0 = alloca i64, align 8
  %__vla_expr1 = alloca i64, align 8
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16443, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.5, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  %1 = ptrtoint i32* %argc.addr to i64
  call void @__dp_write(i32 16443, i64 %1, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.6, i32 0, i32 0))
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !49, metadata !DIExpression()), !dbg !50
  %2 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_write(i32 16443, i64 %2, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.7, i32 0, i32 0))
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !51, metadata !DIExpression()), !dbg !52
  call void @llvm.dbg.declare(metadata i32* %i, metadata !53, metadata !DIExpression()), !dbg !54
  call void @llvm.dbg.declare(metadata i32* %len, metadata !55, metadata !DIExpression()), !dbg !56
  %3 = ptrtoint i32* %len to i64
  call void @__dp_write(i32 16446, i64 %3, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i32 0, i32 0))
  store i32 1000, i32* %len, align 4, !dbg !56
  %4 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16447, i64 %4, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i32 0, i32 0))
  %5 = load i32, i32* %len, align 4, !dbg !57
  %6 = zext i32 %5 to i64, !dbg !58
  call void @__dp_call(i32 16447), !dbg !58
  %7 = call i8* @llvm.stacksave(), !dbg !58
  %8 = ptrtoint i8** %saved_stack to i64
  call void @__dp_write(i32 16447, i64 %8, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.9, i32 0, i32 0))
  store i8* %7, i8** %saved_stack, align 8, !dbg !58
  %vla = alloca double, i64 %6, align 16, !dbg !58
  %9 = ptrtoint i64* %__vla_expr0 to i64
  call void @__dp_write(i32 16447, i64 %9, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.10, i32 0, i32 0))
  store i64 %6, i64* %__vla_expr0, align 8, !dbg !58
  call void @llvm.dbg.declare(metadata i64* %__vla_expr0, metadata !59, metadata !DIExpression()), !dbg !61
  call void @llvm.dbg.declare(metadata double* %vla, metadata !62, metadata !DIExpression()), !dbg !66
  %10 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16447, i64 %10, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i32 0, i32 0))
  %11 = load i32, i32* %len, align 4, !dbg !67
  %12 = zext i32 %11 to i64, !dbg !58
  %vla1 = alloca double, i64 %12, align 16, !dbg !58
  %13 = ptrtoint i64* %__vla_expr1 to i64
  call void @__dp_write(i32 16447, i64 %13, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.11, i32 0, i32 0))
  store i64 %12, i64* %__vla_expr1, align 8, !dbg !58
  call void @llvm.dbg.declare(metadata i64* %__vla_expr1, metadata !68, metadata !DIExpression()), !dbg !61
  call void @llvm.dbg.declare(metadata double* %vla1, metadata !69, metadata !DIExpression()), !dbg !73
  %14 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16448, i64 %14, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !74
  br label %for.cond, !dbg !76

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16448, i32 1)
  %15 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16448, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %16 = load i32, i32* %i, align 4, !dbg !77
  %17 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16448, i64 %17, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i32 0, i32 0))
  %18 = load i32, i32* %len, align 4, !dbg !79
  %cmp = icmp slt i32 %16, %18, !dbg !80
  br i1 %cmp, label %for.body, label %for.end, !dbg !81

for.body:                                         ; preds = %for.cond
  %19 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16450, i64 %19, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %20 = load i32, i32* %i, align 4, !dbg !82
  %conv = sitofp i32 %20 to double, !dbg !84
  %div = fdiv double %conv, 2.000000e+00, !dbg !85
  %21 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16450, i64 %21, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %22 = load i32, i32* %i, align 4, !dbg !86
  %idxprom = sext i32 %22 to i64, !dbg !87
  %arrayidx = getelementptr inbounds double, double* %vla, i64 %idxprom, !dbg !87
  %23 = ptrtoint double* %arrayidx to i64
  call void @__dp_write(i32 16450, i64 %23, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store double %div, double* %arrayidx, align 8, !dbg !88
  %24 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16451, i64 %24, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %25 = load i32, i32* %i, align 4, !dbg !89
  %idxprom2 = sext i32 %25 to i64, !dbg !90
  %arrayidx3 = getelementptr inbounds double, double* %vla1, i64 %idxprom2, !dbg !90
  %26 = ptrtoint double* %arrayidx3 to i64
  call void @__dp_write(i32 16451, i64 %26, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store double 0.000000e+00, double* %arrayidx3, align 8, !dbg !91
  br label %for.inc, !dbg !92

for.inc:                                          ; preds = %for.body
  %27 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16448, i64 %27, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %28 = load i32, i32* %i, align 4, !dbg !93
  %inc = add nsw i32 %28, 1, !dbg !93
  %29 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16448, i64 %29, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !93
  br label %for.cond, !dbg !94, !llvm.loop !95

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16454, i32 1)
  %30 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16454, i64 %30, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i32 0, i32 0))
  %31 = load i32, i32* %len, align 4, !dbg !97
  call void @__dp_call(i32 16454), !dbg !98
  call void @foo(double* %vla, double* %vla1, i32 %31), !dbg !98
  %arrayidx4 = getelementptr inbounds double, double* %vla1, i64 50, !dbg !99
  %32 = ptrtoint double* %arrayidx4 to i64
  call void @__dp_read(i32 16456, i64 %32, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %33 = load double, double* %arrayidx4, align 16, !dbg !99
  call void @__dp_call(i32 16456), !dbg !100
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), double %33), !dbg !100
  %34 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16457, i64 %34, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.5, i32 0, i32 0))
  store i32 0, i32* %retval, align 4, !dbg !101
  %35 = ptrtoint i8** %saved_stack to i64
  call void @__dp_read(i32 16458, i64 %35, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.9, i32 0, i32 0))
  %36 = load i8*, i8** %saved_stack, align 8, !dbg !102
  call void @__dp_call(i32 16458), !dbg !102
  call void @llvm.stackrestore(i8* %36), !dbg !102
  %37 = ptrtoint i32* %retval to i64
  call void @__dp_read(i32 16458, i64 %37, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.5, i32 0, i32 0))
  %38 = load i32, i32* %retval, align 4, !dbg !102
  call void @__dp_finalize(i32 16458), !dbg !102
  ret i32 %38, !dbg !102
}

declare void @__dp_call(i32)

; Function Attrs: nounwind
declare i8* @llvm.stacksave() #2

declare dso_local i32 @printf(i8*, ...) #3

; Function Attrs: nounwind
declare void @llvm.stackrestore(i8*) #2

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!5}
!llvm.module.flags = !{!6, !7, !8}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/099")
!2 = !{}
!3 = !{!4}
!4 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!5 = !{!"Ubuntu clang version 11.1.0-6"}
!6 = !{i32 7, !"Dwarf Version", i32 4}
!7 = !{i32 2, !"Debug Info Version", i32 3}
!8 = !{i32 1, !"wchar_size", i32 4}
!9 = distinct !DISubprogram(name: "foo", scope: !1, file: !1, line: 50, type: !10, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!10 = !DISubroutineType(types: !11)
!11 = !{null, !12, !12, !13}
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!13 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!14 = !DILocalVariable(name: "a", arg: 1, scope: !9, file: !1, line: 50, type: !12)
!15 = !DILocation(line: 50, column: 19, scope: !9)
!16 = !DILocalVariable(name: "b", arg: 2, scope: !9, file: !1, line: 50, type: !12)
!17 = !DILocation(line: 50, column: 30, scope: !9)
!18 = !DILocalVariable(name: "N", arg: 3, scope: !9, file: !1, line: 50, type: !13)
!19 = !DILocation(line: 50, column: 37, scope: !9)
!20 = !DILocalVariable(name: "i", scope: !9, file: !1, line: 52, type: !13)
!21 = !DILocation(line: 52, column: 7, scope: !9)
!22 = !DILocation(line: 55, column: 9, scope: !23)
!23 = distinct !DILexicalBlock(scope: !9, file: !1, line: 55, column: 3)
!24 = !DILocation(line: 55, column: 8, scope: !23)
!25 = !DILocation(line: 55, column: 12, scope: !26)
!26 = distinct !DILexicalBlock(scope: !23, file: !1, line: 55, column: 3)
!27 = !DILocation(line: 55, column: 15, scope: !26)
!28 = !DILocation(line: 55, column: 13, scope: !26)
!29 = !DILocation(line: 55, column: 3, scope: !23)
!30 = !DILocation(line: 56, column: 10, scope: !26)
!31 = !DILocation(line: 56, column: 12, scope: !26)
!32 = !DILocation(line: 56, column: 23, scope: !26)
!33 = !DILocation(line: 56, column: 15, scope: !26)
!34 = !DILocation(line: 56, column: 14, scope: !26)
!35 = !DILocation(line: 56, column: 5, scope: !26)
!36 = !DILocation(line: 56, column: 7, scope: !26)
!37 = !DILocation(line: 56, column: 9, scope: !26)
!38 = !DILocation(line: 55, column: 19, scope: !26)
!39 = !DILocation(line: 55, column: 3, scope: !26)
!40 = distinct !{!40, !29, !41}
!41 = !DILocation(line: 56, column: 23, scope: !23)
!42 = !DILocation(line: 57, column: 1, scope: !9)
!43 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 59, type: !44, scopeLine: 60, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!44 = !DISubroutineType(types: !45)
!45 = !{!13, !13, !46}
!46 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !47, size: 64)
!47 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !48, size: 64)
!48 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!49 = !DILocalVariable(name: "argc", arg: 1, scope: !43, file: !1, line: 59, type: !13)
!50 = !DILocation(line: 59, column: 14, scope: !43)
!51 = !DILocalVariable(name: "argv", arg: 2, scope: !43, file: !1, line: 59, type: !46)
!52 = !DILocation(line: 59, column: 26, scope: !43)
!53 = !DILocalVariable(name: "i", scope: !43, file: !1, line: 61, type: !13)
!54 = !DILocation(line: 61, column: 7, scope: !43)
!55 = !DILocalVariable(name: "len", scope: !43, file: !1, line: 62, type: !13)
!56 = !DILocation(line: 62, column: 7, scope: !43)
!57 = !DILocation(line: 63, column: 12, scope: !43)
!58 = !DILocation(line: 63, column: 3, scope: !43)
!59 = !DILocalVariable(name: "__vla_expr0", scope: !43, type: !60, flags: DIFlagArtificial)
!60 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!61 = !DILocation(line: 0, scope: !43)
!62 = !DILocalVariable(name: "a", scope: !43, file: !1, line: 63, type: !63)
!63 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, elements: !64)
!64 = !{!65}
!65 = !DISubrange(count: !59)
!66 = !DILocation(line: 63, column: 10, scope: !43)
!67 = !DILocation(line: 63, column: 20, scope: !43)
!68 = !DILocalVariable(name: "__vla_expr1", scope: !43, type: !60, flags: DIFlagArtificial)
!69 = !DILocalVariable(name: "b", scope: !43, file: !1, line: 63, type: !70)
!70 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, elements: !71)
!71 = !{!72}
!72 = !DISubrange(count: !68)
!73 = !DILocation(line: 63, column: 18, scope: !43)
!74 = !DILocation(line: 64, column: 9, scope: !75)
!75 = distinct !DILexicalBlock(scope: !43, file: !1, line: 64, column: 3)
!76 = !DILocation(line: 64, column: 8, scope: !75)
!77 = !DILocation(line: 64, column: 13, scope: !78)
!78 = distinct !DILexicalBlock(scope: !75, file: !1, line: 64, column: 3)
!79 = !DILocation(line: 64, column: 15, scope: !78)
!80 = !DILocation(line: 64, column: 14, scope: !78)
!81 = !DILocation(line: 64, column: 3, scope: !75)
!82 = !DILocation(line: 66, column: 20, scope: !83)
!83 = distinct !DILexicalBlock(scope: !78, file: !1, line: 65, column: 3)
!84 = !DILocation(line: 66, column: 12, scope: !83)
!85 = !DILocation(line: 66, column: 22, scope: !83)
!86 = !DILocation(line: 66, column: 7, scope: !83)
!87 = !DILocation(line: 66, column: 5, scope: !83)
!88 = !DILocation(line: 66, column: 9, scope: !83)
!89 = !DILocation(line: 67, column: 7, scope: !83)
!90 = !DILocation(line: 67, column: 5, scope: !83)
!91 = !DILocation(line: 67, column: 9, scope: !83)
!92 = !DILocation(line: 68, column: 3, scope: !83)
!93 = !DILocation(line: 64, column: 21, scope: !78)
!94 = !DILocation(line: 64, column: 3, scope: !78)
!95 = distinct !{!95, !81, !96}
!96 = !DILocation(line: 68, column: 3, scope: !75)
!97 = !DILocation(line: 70, column: 13, scope: !43)
!98 = !DILocation(line: 70, column: 3, scope: !43)
!99 = !DILocation(line: 72, column: 23, scope: !43)
!100 = !DILocation(line: 72, column: 3, scope: !43)
!101 = !DILocation(line: 73, column: 3, scope: !43)
!102 = !DILocation(line: 74, column: 1, scope: !43)
