; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"n\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"m\00", align 1
@.str.3 = private unnamed_addr constant [12 x i8] c"saved_stack\00", align 1
@.str.4 = private unnamed_addr constant [12 x i8] c"__vla_expr0\00", align 1
@.str.5 = private unnamed_addr constant [12 x i8] c"__vla_expr1\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.str.7 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c"j\00", align 1
@.str.9 = private unnamed_addr constant [6 x i8] c"dummy\00", align 1
@.str.10 = private unnamed_addr constant [12 x i8] c"__vla_expr2\00", align 1
@.str.11 = private unnamed_addr constant [12 x i8] c"__vla_expr3\00", align 1
@.str.12 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.13 = private unnamed_addr constant [7 x i8] c"buffer\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !9 {
entry:
  call void @__dp_func_entry(i32 16385, i32 1)
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %saved_stack = alloca i8*, align 8
  %__vla_expr0 = alloca i64, align 8
  %__vla_expr1 = alloca i64, align 8
  %dummy = alloca i32, align 4
  %__vla_expr2 = alloca i64, align 8
  %__vla_expr3 = alloca i64, align 8
  %buffer = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16385, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !13, metadata !DIExpression()), !dbg !14
  call void @llvm.dbg.declare(metadata i32* %j, metadata !15, metadata !DIExpression()), !dbg !16
  call void @llvm.dbg.declare(metadata i32* %n, metadata !17, metadata !DIExpression()), !dbg !18
  %1 = ptrtoint i32* %n to i64
  call void @__dp_write(i32 16388, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 10, i32* %n, align 4, !dbg !18
  call void @llvm.dbg.declare(metadata i32* %m, metadata !19, metadata !DIExpression()), !dbg !20
  %2 = ptrtoint i32* %m to i64
  call void @__dp_write(i32 16388, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 10, i32* %m, align 4, !dbg !20
  %3 = ptrtoint i32* %n to i64
  call void @__dp_read(i32 16389, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %4 = load i32, i32* %n, align 4, !dbg !21
  %5 = zext i32 %4 to i64, !dbg !22
  %6 = ptrtoint i32* %m to i64
  call void @__dp_read(i32 16389, i64 %6, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %7 = load i32, i32* %m, align 4, !dbg !23
  %8 = zext i32 %7 to i64, !dbg !22
  call void @__dp_call(i32 16389), !dbg !22
  %9 = call i8* @llvm.stacksave(), !dbg !22
  %10 = ptrtoint i8** %saved_stack to i64
  call void @__dp_write(i32 16389, i64 %10, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.3, i32 0, i32 0))
  store i8* %9, i8** %saved_stack, align 8, !dbg !22
  %11 = mul nuw i64 %5, %8, !dbg !22
  %vla = alloca double, i64 %11, align 16, !dbg !22
  %12 = ptrtoint i64* %__vla_expr0 to i64
  call void @__dp_write(i32 16389, i64 %12, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.4, i32 0, i32 0))
  store i64 %5, i64* %__vla_expr0, align 8, !dbg !22
  %13 = ptrtoint i64* %__vla_expr1 to i64
  call void @__dp_write(i32 16389, i64 %13, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.5, i32 0, i32 0))
  store i64 %8, i64* %__vla_expr1, align 8, !dbg !22
  call void @llvm.dbg.declare(metadata i64* %__vla_expr0, metadata !24, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.declare(metadata i64* %__vla_expr1, metadata !27, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.declare(metadata double* %vla, metadata !28, metadata !DIExpression()), !dbg !33
  %14 = mul nsw i64 1, %8, !dbg !34
  %arrayidx = getelementptr inbounds double, double* %vla, i64 %14, !dbg !34
  %arrayidx1 = getelementptr inbounds double, double* %arrayidx, i64 1, !dbg !34
  %15 = ptrtoint double* %arrayidx1 to i64
  call void @__dp_write(i32 16390, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store double 4.200000e+01, double* %arrayidx1, align 8, !dbg !35
  %16 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16394, i64 %16, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !36
  br label %for.cond, !dbg !38

for.cond:                                         ; preds = %for.inc8, %entry
  call void @__dp_loop_entry(i32 16394, i32 0)
  %17 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16394, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %18 = load i32, i32* %i, align 4, !dbg !39
  %19 = ptrtoint i32* %n to i64
  call void @__dp_read(i32 16394, i64 %19, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %20 = load i32, i32* %n, align 4, !dbg !41
  %cmp = icmp slt i32 %18, %20, !dbg !42
  br i1 %cmp, label %for.body, label %for.end10, !dbg !43

for.body:                                         ; preds = %for.cond
  %21 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16395, i64 %21, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  store i32 0, i32* %j, align 4, !dbg !44
  br label %for.cond2, !dbg !46

for.cond2:                                        ; preds = %for.inc, %for.body
  call void @__dp_loop_entry(i32 16395, i32 1)
  %22 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16395, i64 %22, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %23 = load i32, i32* %j, align 4, !dbg !47
  %24 = ptrtoint i32* %n to i64
  call void @__dp_read(i32 16395, i64 %24, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %25 = load i32, i32* %n, align 4, !dbg !49
  %cmp3 = icmp slt i32 %23, %25, !dbg !50
  br i1 %cmp3, label %for.body4, label %for.end, !dbg !51

for.body4:                                        ; preds = %for.cond2
  %26 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16396, i64 %26, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %27 = load i32, i32* %i, align 4, !dbg !52
  %28 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16396, i64 %28, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %29 = load i32, i32* %j, align 4, !dbg !53
  %mul = mul nsw i32 %27, %29, !dbg !54
  %conv = sitofp i32 %mul to double, !dbg !55
  %30 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16396, i64 %30, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %31 = load i32, i32* %i, align 4, !dbg !56
  %idxprom = sext i32 %31 to i64, !dbg !57
  %32 = mul nsw i64 %idxprom, %8, !dbg !57
  %arrayidx5 = getelementptr inbounds double, double* %vla, i64 %32, !dbg !57
  %33 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16396, i64 %33, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %34 = load i32, i32* %j, align 4, !dbg !58
  %idxprom6 = sext i32 %34 to i64, !dbg !57
  %arrayidx7 = getelementptr inbounds double, double* %arrayidx5, i64 %idxprom6, !dbg !57
  %35 = ptrtoint double* %arrayidx7 to i64
  call void @__dp_write(i32 16396, i64 %35, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store double %conv, double* %arrayidx7, align 8, !dbg !59
  br label %for.inc, !dbg !57

for.inc:                                          ; preds = %for.body4
  %36 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16395, i64 %36, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %37 = load i32, i32* %j, align 4, !dbg !60
  %inc = add nsw i32 %37, 1, !dbg !60
  %38 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16395, i64 %38, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  store i32 %inc, i32* %j, align 4, !dbg !60
  br label %for.cond2, !dbg !61, !llvm.loop !62

for.end:                                          ; preds = %for.cond2
  call void @__dp_loop_exit(i32 16396, i32 1)
  br label %for.inc8, !dbg !63

for.inc8:                                         ; preds = %for.end
  %39 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16394, i64 %39, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %40 = load i32, i32* %i, align 4, !dbg !64
  %inc9 = add nsw i32 %40, 1, !dbg !64
  %41 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16394, i64 %41, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 %inc9, i32* %i, align 4, !dbg !64
  br label %for.cond, !dbg !65, !llvm.loop !66

for.end10:                                        ; preds = %for.cond
  call void @__dp_loop_exit(i32 16400, i32 0)
  %42 = mul nsw i64 42, %8, !dbg !68
  %arrayidx11 = getelementptr inbounds double, double* %vla, i64 %42, !dbg !68
  %arrayidx12 = getelementptr inbounds double, double* %arrayidx11, i64 21, !dbg !68
  %43 = ptrtoint double* %arrayidx12 to i64
  call void @__dp_read(i32 16400, i64 %43, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %44 = load double, double* %arrayidx12, align 8, !dbg !68
  %45 = mul nsw i64 1, %8, !dbg !69
  %arrayidx13 = getelementptr inbounds double, double* %vla, i64 %45, !dbg !69
  %arrayidx14 = getelementptr inbounds double, double* %arrayidx13, i64 2, !dbg !69
  %46 = ptrtoint double* %arrayidx14 to i64
  call void @__dp_write(i32 16400, i64 %46, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store double %44, double* %arrayidx14, align 8, !dbg !70
  call void @llvm.dbg.declare(metadata i32* %dummy, metadata !71, metadata !DIExpression()), !dbg !72
  %47 = ptrtoint i32* %dummy to i64
  call void @__dp_write(i32 16402, i64 %47, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.9, i32 0, i32 0))
  store i32 42, i32* %dummy, align 4, !dbg !72
  %48 = ptrtoint i32* %n to i64
  call void @__dp_read(i32 16404, i64 %48, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %49 = load i32, i32* %n, align 4, !dbg !73
  %50 = zext i32 %49 to i64, !dbg !74
  %51 = ptrtoint i32* %n to i64
  call void @__dp_read(i32 16404, i64 %51, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %52 = load i32, i32* %n, align 4, !dbg !75
  %53 = zext i32 %52 to i64, !dbg !74
  %54 = mul nuw i64 %50, %53, !dbg !74
  %vla15 = alloca double, i64 %54, align 16, !dbg !74
  %55 = ptrtoint i64* %__vla_expr2 to i64
  call void @__dp_write(i32 16404, i64 %55, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.10, i32 0, i32 0))
  store i64 %50, i64* %__vla_expr2, align 8, !dbg !74
  %56 = ptrtoint i64* %__vla_expr3 to i64
  call void @__dp_write(i32 16404, i64 %56, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.11, i32 0, i32 0))
  store i64 %53, i64* %__vla_expr3, align 8, !dbg !74
  call void @llvm.dbg.declare(metadata i64* %__vla_expr2, metadata !76, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.declare(metadata i64* %__vla_expr3, metadata !77, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.declare(metadata double* %vla15, metadata !78, metadata !DIExpression()), !dbg !83
  %57 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16409, i64 %57, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !84
  br label %for.cond16, !dbg !86

for.cond16:                                       ; preds = %for.inc37, %for.end10
  call void @__dp_loop_entry(i32 16409, i32 2)
  %58 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16409, i64 %58, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %59 = load i32, i32* %i, align 4, !dbg !87
  %60 = ptrtoint i32* %n to i64
  call void @__dp_read(i32 16409, i64 %60, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %61 = load i32, i32* %n, align 4, !dbg !89
  %cmp17 = icmp slt i32 %59, %61, !dbg !90
  br i1 %cmp17, label %for.body19, label %for.end39, !dbg !91

for.body19:                                       ; preds = %for.cond16
  %62 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16410, i64 %62, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  store i32 0, i32* %j, align 4, !dbg !92
  br label %for.cond20, !dbg !95

for.cond20:                                       ; preds = %for.inc34, %for.body19
  call void @__dp_loop_entry(i32 16410, i32 3)
  %63 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16410, i64 %63, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %64 = load i32, i32* %j, align 4, !dbg !96
  %65 = ptrtoint i32* %n to i64
  call void @__dp_read(i32 16410, i64 %65, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %66 = load i32, i32* %n, align 4, !dbg !98
  %div = sdiv i32 %66, 2, !dbg !99
  %cmp21 = icmp slt i32 %64, %div, !dbg !100
  br i1 %cmp21, label %for.body23, label %for.end36, !dbg !101

for.body23:                                       ; preds = %for.cond20
  %67 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16411, i64 %67, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %68 = load i32, i32* %i, align 4, !dbg !102
  %69 = ptrtoint i32* %n to i64
  call void @__dp_read(i32 16411, i64 %69, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %70 = load i32, i32* %n, align 4, !dbg !105
  %div24 = sdiv i32 %70, 2, !dbg !106
  %cmp25 = icmp slt i32 %68, %div24, !dbg !107
  br i1 %cmp25, label %if.then, label %if.end, !dbg !108

if.then:                                          ; preds = %for.body23
  %71 = ptrtoint i32* %dummy to i64
  call void @__dp_write(i32 16412, i64 %71, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.9, i32 0, i32 0))
  store i32 1, i32* %dummy, align 4, !dbg !109
  br label %if.end, !dbg !111

if.end:                                           ; preds = %if.then, %for.body23
  %72 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16414, i64 %72, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %73 = load i32, i32* %i, align 4, !dbg !112
  %74 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16414, i64 %74, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %75 = load i32, i32* %j, align 4, !dbg !113
  %mul27 = mul nsw i32 %73, %75, !dbg !114
  %76 = ptrtoint i32* %dummy to i64
  call void @__dp_read(i32 16414, i64 %76, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.9, i32 0, i32 0))
  %77 = load i32, i32* %dummy, align 4, !dbg !115
  %add = add nsw i32 %mul27, %77, !dbg !116
  %conv28 = sitofp i32 %add to double, !dbg !117
  %78 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16414, i64 %78, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %79 = load i32, i32* %i, align 4, !dbg !118
  %idxprom29 = sext i32 %79 to i64, !dbg !119
  %80 = mul nsw i64 %idxprom29, %53, !dbg !119
  %arrayidx30 = getelementptr inbounds double, double* %vla15, i64 %80, !dbg !119
  %81 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16414, i64 %81, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %82 = load i32, i32* %j, align 4, !dbg !120
  %idxprom31 = sext i32 %82 to i64, !dbg !119
  %arrayidx32 = getelementptr inbounds double, double* %arrayidx30, i64 %idxprom31, !dbg !119
  %83 = ptrtoint double* %arrayidx32 to i64
  call void @__dp_write(i32 16414, i64 %83, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.12, i32 0, i32 0))
  store double %conv28, double* %arrayidx32, align 8, !dbg !121
  %84 = ptrtoint i32* %dummy to i64
  call void @__dp_read(i32 16415, i64 %84, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.9, i32 0, i32 0))
  %85 = load i32, i32* %dummy, align 4, !dbg !122
  %add33 = add nsw i32 %85, 1, !dbg !122
  %86 = ptrtoint i32* %dummy to i64
  call void @__dp_write(i32 16415, i64 %86, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.9, i32 0, i32 0))
  store i32 %add33, i32* %dummy, align 4, !dbg !122
  br label %for.inc34, !dbg !123

for.inc34:                                        ; preds = %if.end
  %87 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16410, i64 %87, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %88 = load i32, i32* %j, align 4, !dbg !124
  %inc35 = add nsw i32 %88, 1, !dbg !124
  %89 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16410, i64 %89, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  store i32 %inc35, i32* %j, align 4, !dbg !124
  br label %for.cond20, !dbg !125, !llvm.loop !126

for.end36:                                        ; preds = %for.cond20
  call void @__dp_loop_exit(i32 16417, i32 3)
  br label %for.inc37, !dbg !128

for.inc37:                                        ; preds = %for.end36
  %90 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16409, i64 %90, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %91 = load i32, i32* %i, align 4, !dbg !129
  %inc38 = add nsw i32 %91, 1, !dbg !129
  %92 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16409, i64 %92, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 %inc38, i32* %i, align 4, !dbg !129
  br label %for.cond16, !dbg !130, !llvm.loop !131

for.end39:                                        ; preds = %for.cond16
  call void @__dp_loop_exit(i32 16420, i32 2)
  call void @llvm.dbg.declare(metadata i32* %buffer, metadata !133, metadata !DIExpression()), !dbg !134
  %93 = mul nsw i64 7, %53, !dbg !135
  %arrayidx40 = getelementptr inbounds double, double* %vla15, i64 %93, !dbg !135
  %arrayidx41 = getelementptr inbounds double, double* %arrayidx40, i64 4, !dbg !135
  %94 = ptrtoint double* %arrayidx41 to i64
  call void @__dp_read(i32 16420, i64 %94, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.12, i32 0, i32 0))
  %95 = load double, double* %arrayidx41, align 8, !dbg !135
  %96 = mul nsw i64 2, %8, !dbg !136
  %arrayidx42 = getelementptr inbounds double, double* %vla, i64 %96, !dbg !136
  %arrayidx43 = getelementptr inbounds double, double* %arrayidx42, i64 5, !dbg !136
  %97 = ptrtoint double* %arrayidx43 to i64
  call void @__dp_read(i32 16420, i64 %97, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %98 = load double, double* %arrayidx43, align 8, !dbg !136
  %mul44 = fmul double %95, %98, !dbg !137
  %99 = ptrtoint i32* %dummy to i64
  call void @__dp_read(i32 16420, i64 %99, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.9, i32 0, i32 0))
  %100 = load i32, i32* %dummy, align 4, !dbg !138
  %conv45 = sitofp i32 %100 to double, !dbg !138
  %add46 = fadd double %mul44, %conv45, !dbg !139
  %conv47 = fptosi double %add46 to i32, !dbg !135
  %101 = ptrtoint i32* %buffer to i64
  call void @__dp_write(i32 16420, i64 %101, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.13, i32 0, i32 0))
  store i32 %conv47, i32* %buffer, align 4, !dbg !134
  %102 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16422, i64 %102, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  store i32 0, i32* %retval, align 4, !dbg !140
  %103 = ptrtoint i8** %saved_stack to i64
  call void @__dp_read(i32 16423, i64 %103, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.3, i32 0, i32 0))
  %104 = load i8*, i8** %saved_stack, align 8, !dbg !141
  call void @__dp_call(i32 16423), !dbg !141
  call void @llvm.stackrestore(i8* %104), !dbg !141
  %105 = ptrtoint i32* %retval to i64
  call void @__dp_read(i32 16423, i64 %105, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  %106 = load i32, i32* %retval, align 4, !dbg !141
  call void @__dp_finalize(i32 16423), !dbg !141
  ret i32 %106, !dbg !141
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_call(i32)

; Function Attrs: nounwind
declare i8* @llvm.stacksave() #2

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_loop_exit(i32, i32)

; Function Attrs: nounwind
declare void @llvm.stackrestore(i8*) #2

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!5}
!llvm.module.flags = !{!6, !7, !8}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/1337")
!2 = !{}
!3 = !{!4}
!4 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!5 = !{!"Ubuntu clang version 11.1.0-6"}
!6 = !{i32 7, !"Dwarf Version", i32 4}
!7 = !{i32 2, !"Debug Info Version", i32 3}
!8 = !{i32 1, !"wchar_size", i32 4}
!9 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 1, type: !10, scopeLine: 2, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!10 = !DISubroutineType(types: !11)
!11 = !{!12}
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !DILocalVariable(name: "i", scope: !9, file: !1, line: 3, type: !12)
!14 = !DILocation(line: 3, column: 7, scope: !9)
!15 = !DILocalVariable(name: "j", scope: !9, file: !1, line: 3, type: !12)
!16 = !DILocation(line: 3, column: 9, scope: !9)
!17 = !DILocalVariable(name: "n", scope: !9, file: !1, line: 4, type: !12)
!18 = !DILocation(line: 4, column: 7, scope: !9)
!19 = !DILocalVariable(name: "m", scope: !9, file: !1, line: 4, type: !12)
!20 = !DILocation(line: 4, column: 13, scope: !9)
!21 = !DILocation(line: 5, column: 12, scope: !9)
!22 = !DILocation(line: 5, column: 3, scope: !9)
!23 = !DILocation(line: 5, column: 15, scope: !9)
!24 = !DILocalVariable(name: "__vla_expr0", scope: !9, type: !25, flags: DIFlagArtificial)
!25 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!26 = !DILocation(line: 0, scope: !9)
!27 = !DILocalVariable(name: "__vla_expr1", scope: !9, type: !25, flags: DIFlagArtificial)
!28 = !DILocalVariable(name: "b", scope: !9, file: !1, line: 5, type: !29)
!29 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, elements: !30)
!30 = !{!31, !32}
!31 = !DISubrange(count: !24)
!32 = !DISubrange(count: !27)
!33 = !DILocation(line: 5, column: 10, scope: !9)
!34 = !DILocation(line: 6, column: 3, scope: !9)
!35 = !DILocation(line: 6, column: 11, scope: !9)
!36 = !DILocation(line: 10, column: 8, scope: !37)
!37 = distinct !DILexicalBlock(scope: !9, file: !1, line: 10, column: 3)
!38 = !DILocation(line: 10, column: 7, scope: !37)
!39 = !DILocation(line: 10, column: 11, scope: !40)
!40 = distinct !DILexicalBlock(scope: !37, file: !1, line: 10, column: 3)
!41 = !DILocation(line: 10, column: 13, scope: !40)
!42 = !DILocation(line: 10, column: 12, scope: !40)
!43 = !DILocation(line: 10, column: 3, scope: !37)
!44 = !DILocation(line: 11, column: 10, scope: !45)
!45 = distinct !DILexicalBlock(scope: !40, file: !1, line: 11, column: 5)
!46 = !DILocation(line: 11, column: 9, scope: !45)
!47 = !DILocation(line: 11, column: 13, scope: !48)
!48 = distinct !DILexicalBlock(scope: !45, file: !1, line: 11, column: 5)
!49 = !DILocation(line: 11, column: 15, scope: !48)
!50 = !DILocation(line: 11, column: 14, scope: !48)
!51 = !DILocation(line: 11, column: 5, scope: !45)
!52 = !DILocation(line: 12, column: 24, scope: !48)
!53 = !DILocation(line: 12, column: 26, scope: !48)
!54 = !DILocation(line: 12, column: 25, scope: !48)
!55 = !DILocation(line: 12, column: 15, scope: !48)
!56 = !DILocation(line: 12, column: 9, scope: !48)
!57 = !DILocation(line: 12, column: 7, scope: !48)
!58 = !DILocation(line: 12, column: 12, scope: !48)
!59 = !DILocation(line: 12, column: 14, scope: !48)
!60 = !DILocation(line: 11, column: 19, scope: !48)
!61 = !DILocation(line: 11, column: 5, scope: !48)
!62 = distinct !{!62, !51, !63}
!63 = !DILocation(line: 12, column: 27, scope: !45)
!64 = !DILocation(line: 10, column: 17, scope: !40)
!65 = !DILocation(line: 10, column: 3, scope: !40)
!66 = distinct !{!66, !43, !67}
!67 = !DILocation(line: 12, column: 27, scope: !37)
!68 = !DILocation(line: 16, column: 13, scope: !9)
!69 = !DILocation(line: 16, column: 3, scope: !9)
!70 = !DILocation(line: 16, column: 11, scope: !9)
!71 = !DILocalVariable(name: "dummy", scope: !9, file: !1, line: 18, type: !12)
!72 = !DILocation(line: 18, column: 7, scope: !9)
!73 = !DILocation(line: 20, column: 12, scope: !9)
!74 = !DILocation(line: 20, column: 3, scope: !9)
!75 = !DILocation(line: 20, column: 15, scope: !9)
!76 = !DILocalVariable(name: "__vla_expr2", scope: !9, type: !25, flags: DIFlagArtificial)
!77 = !DILocalVariable(name: "__vla_expr3", scope: !9, type: !25, flags: DIFlagArtificial)
!78 = !DILocalVariable(name: "a", scope: !9, file: !1, line: 20, type: !79)
!79 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, elements: !80)
!80 = !{!81, !82}
!81 = !DISubrange(count: !76)
!82 = !DISubrange(count: !77)
!83 = !DILocation(line: 20, column: 10, scope: !9)
!84 = !DILocation(line: 25, column: 8, scope: !85)
!85 = distinct !DILexicalBlock(scope: !9, file: !1, line: 25, column: 3)
!86 = !DILocation(line: 25, column: 7, scope: !85)
!87 = !DILocation(line: 25, column: 11, scope: !88)
!88 = distinct !DILexicalBlock(scope: !85, file: !1, line: 25, column: 3)
!89 = !DILocation(line: 25, column: 13, scope: !88)
!90 = !DILocation(line: 25, column: 12, scope: !88)
!91 = !DILocation(line: 25, column: 3, scope: !85)
!92 = !DILocation(line: 26, column: 10, scope: !93)
!93 = distinct !DILexicalBlock(scope: !94, file: !1, line: 26, column: 5)
!94 = distinct !DILexicalBlock(scope: !88, file: !1, line: 25, column: 20)
!95 = !DILocation(line: 26, column: 9, scope: !93)
!96 = !DILocation(line: 26, column: 13, scope: !97)
!97 = distinct !DILexicalBlock(scope: !93, file: !1, line: 26, column: 5)
!98 = !DILocation(line: 26, column: 15, scope: !97)
!99 = !DILocation(line: 26, column: 16, scope: !97)
!100 = !DILocation(line: 26, column: 14, scope: !97)
!101 = !DILocation(line: 26, column: 5, scope: !93)
!102 = !DILocation(line: 27, column: 10, scope: !103)
!103 = distinct !DILexicalBlock(scope: !104, file: !1, line: 27, column: 10)
!104 = distinct !DILexicalBlock(scope: !97, file: !1, line: 26, column: 24)
!105 = !DILocation(line: 27, column: 14, scope: !103)
!106 = !DILocation(line: 27, column: 15, scope: !103)
!107 = !DILocation(line: 27, column: 12, scope: !103)
!108 = !DILocation(line: 27, column: 10, scope: !104)
!109 = !DILocation(line: 28, column: 15, scope: !110)
!110 = distinct !DILexicalBlock(scope: !103, file: !1, line: 27, column: 18)
!111 = !DILocation(line: 29, column: 7, scope: !110)
!112 = !DILocation(line: 30, column: 27, scope: !104)
!113 = !DILocation(line: 30, column: 29, scope: !104)
!114 = !DILocation(line: 30, column: 28, scope: !104)
!115 = !DILocation(line: 30, column: 33, scope: !104)
!116 = !DILocation(line: 30, column: 31, scope: !104)
!117 = !DILocation(line: 30, column: 17, scope: !104)
!118 = !DILocation(line: 30, column: 9, scope: !104)
!119 = !DILocation(line: 30, column: 7, scope: !104)
!120 = !DILocation(line: 30, column: 12, scope: !104)
!121 = !DILocation(line: 30, column: 15, scope: !104)
!122 = !DILocation(line: 31, column: 13, scope: !104)
!123 = !DILocation(line: 32, column: 5, scope: !104)
!124 = !DILocation(line: 26, column: 21, scope: !97)
!125 = !DILocation(line: 26, column: 5, scope: !97)
!126 = distinct !{!126, !101, !127}
!127 = !DILocation(line: 32, column: 5, scope: !93)
!128 = !DILocation(line: 33, column: 3, scope: !94)
!129 = !DILocation(line: 25, column: 17, scope: !88)
!130 = !DILocation(line: 25, column: 3, scope: !88)
!131 = distinct !{!131, !91, !132}
!132 = !DILocation(line: 33, column: 3, scope: !85)
!133 = !DILocalVariable(name: "buffer", scope: !9, file: !1, line: 36, type: !12)
!134 = !DILocation(line: 36, column: 7, scope: !9)
!135 = !DILocation(line: 36, column: 16, scope: !9)
!136 = !DILocation(line: 36, column: 26, scope: !9)
!137 = !DILocation(line: 36, column: 24, scope: !9)
!138 = !DILocation(line: 36, column: 36, scope: !9)
!139 = !DILocation(line: 36, column: 34, scope: !9)
!140 = !DILocation(line: 38, column: 3, scope: !9)
!141 = !DILocation(line: 39, column: 1, scope: !9)
