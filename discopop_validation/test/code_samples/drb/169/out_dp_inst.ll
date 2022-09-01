; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.2 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"j\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"k\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"r\00", align 1
@.str.7 = private unnamed_addr constant [3 x i8] c"r1\00", align 1
@.str = private unnamed_addr constant [4 x i8] c"%f \00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16404, i32 1)
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %r1 = alloca [8 x double], align 16
  %r = alloca [8 x [8 x [8 x double]]], align 16
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16404, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !11, metadata !DIExpression()), !dbg !12
  call void @llvm.dbg.declare(metadata i32* %j, metadata !13, metadata !DIExpression()), !dbg !14
  call void @llvm.dbg.declare(metadata i32* %k, metadata !15, metadata !DIExpression()), !dbg !16
  call void @llvm.dbg.declare(metadata [8 x double]* %r1, metadata !17, metadata !DIExpression()), !dbg !22
  call void @llvm.dbg.declare(metadata [8 x [8 x [8 x double]]]* %r, metadata !23, metadata !DIExpression()), !dbg !26
  %1 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16409, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !27
  br label %for.cond, !dbg !29

for.cond:                                         ; preds = %for.inc14, %entry
  call void @__dp_loop_entry(i32 16409, i32 0)
  %2 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16409, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %3 = load i32, i32* %i, align 4, !dbg !30
  %cmp = icmp slt i32 %3, 8, !dbg !32
  br i1 %cmp, label %for.body, label %for.end16, !dbg !33

for.body:                                         ; preds = %for.cond
  %4 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16410, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 0, i32* %j, align 4, !dbg !34
  br label %for.cond1, !dbg !37

for.cond1:                                        ; preds = %for.inc11, %for.body
  call void @__dp_loop_entry(i32 16410, i32 1)
  %5 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16410, i64 %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %6 = load i32, i32* %j, align 4, !dbg !38
  %cmp2 = icmp slt i32 %6, 8, !dbg !40
  br i1 %cmp2, label %for.body3, label %for.end13, !dbg !41

for.body3:                                        ; preds = %for.cond1
  %7 = ptrtoint i32* %k to i64
  call void @__dp_write(i32 16411, i64 %7, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 0, i32* %k, align 4, !dbg !42
  br label %for.cond4, !dbg !45

for.cond4:                                        ; preds = %for.inc, %for.body3
  call void @__dp_loop_entry(i32 16411, i32 2)
  %8 = ptrtoint i32* %k to i64
  call void @__dp_read(i32 16411, i64 %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %9 = load i32, i32* %k, align 4, !dbg !46
  %cmp5 = icmp slt i32 %9, 8, !dbg !48
  br i1 %cmp5, label %for.body6, label %for.end, !dbg !49

for.body6:                                        ; preds = %for.cond4
  %10 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16412, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %11 = load i32, i32* %i, align 4, !dbg !50
  %conv = sitofp i32 %11 to double, !dbg !50
  %12 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16412, i64 %12, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %13 = load i32, i32* %i, align 4, !dbg !52
  %idxprom = sext i32 %13 to i64, !dbg !53
  %arrayidx = getelementptr inbounds [8 x [8 x [8 x double]]], [8 x [8 x [8 x double]]]* %r, i64 0, i64 %idxprom, !dbg !53
  %14 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16412, i64 %14, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %15 = load i32, i32* %j, align 4, !dbg !54
  %idxprom7 = sext i32 %15 to i64, !dbg !53
  %arrayidx8 = getelementptr inbounds [8 x [8 x double]], [8 x [8 x double]]* %arrayidx, i64 0, i64 %idxprom7, !dbg !53
  %16 = ptrtoint i32* %k to i64
  call void @__dp_read(i32 16412, i64 %16, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %17 = load i32, i32* %k, align 4, !dbg !55
  %idxprom9 = sext i32 %17 to i64, !dbg !53
  %arrayidx10 = getelementptr inbounds [8 x double], [8 x double]* %arrayidx8, i64 0, i64 %idxprom9, !dbg !53
  %18 = ptrtoint double* %arrayidx10 to i64
  call void @__dp_write(i32 16412, i64 %18, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store double %conv, double* %arrayidx10, align 8, !dbg !56
  br label %for.inc, !dbg !57

for.inc:                                          ; preds = %for.body6
  %19 = ptrtoint i32* %k to i64
  call void @__dp_read(i32 16411, i64 %19, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %20 = load i32, i32* %k, align 4, !dbg !58
  %inc = add nsw i32 %20, 1, !dbg !58
  %21 = ptrtoint i32* %k to i64
  call void @__dp_write(i32 16411, i64 %21, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 %inc, i32* %k, align 4, !dbg !58
  br label %for.cond4, !dbg !59, !llvm.loop !60

for.end:                                          ; preds = %for.cond4
  call void @__dp_loop_exit(i32 16414, i32 2)
  br label %for.inc11, !dbg !62

for.inc11:                                        ; preds = %for.end
  %22 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16410, i64 %22, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %23 = load i32, i32* %j, align 4, !dbg !63
  %inc12 = add nsw i32 %23, 1, !dbg !63
  %24 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16410, i64 %24, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 %inc12, i32* %j, align 4, !dbg !63
  br label %for.cond1, !dbg !64, !llvm.loop !65

for.end13:                                        ; preds = %for.cond1
  call void @__dp_loop_exit(i32 16415, i32 1)
  br label %for.inc14, !dbg !67

for.inc14:                                        ; preds = %for.end13
  %25 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16409, i64 %25, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %26 = load i32, i32* %i, align 4, !dbg !68
  %inc15 = add nsw i32 %26, 1, !dbg !68
  %27 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16409, i64 %27, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 %inc15, i32* %i, align 4, !dbg !68
  br label %for.cond, !dbg !69, !llvm.loop !70

for.end16:                                        ; preds = %for.cond
  call void @__dp_loop_exit(i32 16419, i32 0)
  %28 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16419, i64 %28, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 1, i32* %i, align 4, !dbg !72
  br label %for.cond17, !dbg !74

for.cond17:                                       ; preds = %for.inc66, %for.end16
  call void @__dp_loop_entry(i32 16419, i32 3)
  %29 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16419, i64 %29, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %30 = load i32, i32* %i, align 4, !dbg !75
  %cmp18 = icmp slt i32 %30, 7, !dbg !77
  br i1 %cmp18, label %for.body20, label %for.end68, !dbg !78

for.body20:                                       ; preds = %for.cond17
  %31 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16420, i64 %31, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 1, i32* %j, align 4, !dbg !79
  br label %for.cond21, !dbg !82

for.cond21:                                       ; preds = %for.inc63, %for.body20
  call void @__dp_loop_entry(i32 16420, i32 4)
  %32 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16420, i64 %32, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %33 = load i32, i32* %j, align 4, !dbg !83
  %cmp22 = icmp slt i32 %33, 7, !dbg !85
  br i1 %cmp22, label %for.body24, label %for.end65, !dbg !86

for.body24:                                       ; preds = %for.cond21
  %34 = ptrtoint i32* %k to i64
  call void @__dp_write(i32 16421, i64 %34, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 0, i32* %k, align 4, !dbg !87
  br label %for.cond25, !dbg !90

for.cond25:                                       ; preds = %for.inc60, %for.body24
  call void @__dp_loop_entry(i32 16421, i32 5)
  %35 = ptrtoint i32* %k to i64
  call void @__dp_read(i32 16421, i64 %35, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %36 = load i32, i32* %k, align 4, !dbg !91
  %cmp26 = icmp slt i32 %36, 8, !dbg !93
  br i1 %cmp26, label %for.body28, label %for.end62, !dbg !94

for.body28:                                       ; preds = %for.cond25
  %37 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16422, i64 %37, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %38 = load i32, i32* %i, align 4, !dbg !95
  %idxprom29 = sext i32 %38 to i64, !dbg !97
  %arrayidx30 = getelementptr inbounds [8 x [8 x [8 x double]]], [8 x [8 x [8 x double]]]* %r, i64 0, i64 %idxprom29, !dbg !97
  %39 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16422, i64 %39, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %40 = load i32, i32* %j, align 4, !dbg !98
  %sub = sub nsw i32 %40, 1, !dbg !99
  %idxprom31 = sext i32 %sub to i64, !dbg !97
  %arrayidx32 = getelementptr inbounds [8 x [8 x double]], [8 x [8 x double]]* %arrayidx30, i64 0, i64 %idxprom31, !dbg !97
  %41 = ptrtoint i32* %k to i64
  call void @__dp_read(i32 16422, i64 %41, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %42 = load i32, i32* %k, align 4, !dbg !100
  %idxprom33 = sext i32 %42 to i64, !dbg !97
  %arrayidx34 = getelementptr inbounds [8 x double], [8 x double]* %arrayidx32, i64 0, i64 %idxprom33, !dbg !97
  %43 = ptrtoint double* %arrayidx34 to i64
  call void @__dp_read(i32 16422, i64 %43, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %44 = load double, double* %arrayidx34, align 8, !dbg !97
  %45 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16422, i64 %45, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %46 = load i32, i32* %i, align 4, !dbg !101
  %idxprom35 = sext i32 %46 to i64, !dbg !102
  %arrayidx36 = getelementptr inbounds [8 x [8 x [8 x double]]], [8 x [8 x [8 x double]]]* %r, i64 0, i64 %idxprom35, !dbg !102
  %47 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16422, i64 %47, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %48 = load i32, i32* %j, align 4, !dbg !103
  %add = add nsw i32 %48, 1, !dbg !104
  %idxprom37 = sext i32 %add to i64, !dbg !102
  %arrayidx38 = getelementptr inbounds [8 x [8 x double]], [8 x [8 x double]]* %arrayidx36, i64 0, i64 %idxprom37, !dbg !102
  %49 = ptrtoint i32* %k to i64
  call void @__dp_read(i32 16422, i64 %49, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %50 = load i32, i32* %k, align 4, !dbg !105
  %idxprom39 = sext i32 %50 to i64, !dbg !102
  %arrayidx40 = getelementptr inbounds [8 x double], [8 x double]* %arrayidx38, i64 0, i64 %idxprom39, !dbg !102
  %51 = ptrtoint double* %arrayidx40 to i64
  call void @__dp_read(i32 16422, i64 %51, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %52 = load double, double* %arrayidx40, align 8, !dbg !102
  %add41 = fadd double %44, %52, !dbg !106
  %53 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16422, i64 %53, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %54 = load i32, i32* %i, align 4, !dbg !107
  %sub42 = sub nsw i32 %54, 1, !dbg !108
  %idxprom43 = sext i32 %sub42 to i64, !dbg !109
  %arrayidx44 = getelementptr inbounds [8 x [8 x [8 x double]]], [8 x [8 x [8 x double]]]* %r, i64 0, i64 %idxprom43, !dbg !109
  %55 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16422, i64 %55, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %56 = load i32, i32* %j, align 4, !dbg !110
  %idxprom45 = sext i32 %56 to i64, !dbg !109
  %arrayidx46 = getelementptr inbounds [8 x [8 x double]], [8 x [8 x double]]* %arrayidx44, i64 0, i64 %idxprom45, !dbg !109
  %57 = ptrtoint i32* %k to i64
  call void @__dp_read(i32 16422, i64 %57, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %58 = load i32, i32* %k, align 4, !dbg !111
  %idxprom47 = sext i32 %58 to i64, !dbg !109
  %arrayidx48 = getelementptr inbounds [8 x double], [8 x double]* %arrayidx46, i64 0, i64 %idxprom47, !dbg !109
  %59 = ptrtoint double* %arrayidx48 to i64
  call void @__dp_read(i32 16422, i64 %59, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %60 = load double, double* %arrayidx48, align 8, !dbg !109
  %add49 = fadd double %add41, %60, !dbg !112
  %61 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16422, i64 %61, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %62 = load i32, i32* %i, align 4, !dbg !113
  %add50 = add nsw i32 %62, 1, !dbg !114
  %idxprom51 = sext i32 %add50 to i64, !dbg !115
  %arrayidx52 = getelementptr inbounds [8 x [8 x [8 x double]]], [8 x [8 x [8 x double]]]* %r, i64 0, i64 %idxprom51, !dbg !115
  %63 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16422, i64 %63, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %64 = load i32, i32* %j, align 4, !dbg !116
  %idxprom53 = sext i32 %64 to i64, !dbg !115
  %arrayidx54 = getelementptr inbounds [8 x [8 x double]], [8 x [8 x double]]* %arrayidx52, i64 0, i64 %idxprom53, !dbg !115
  %65 = ptrtoint i32* %k to i64
  call void @__dp_read(i32 16422, i64 %65, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %66 = load i32, i32* %k, align 4, !dbg !117
  %idxprom55 = sext i32 %66 to i64, !dbg !115
  %arrayidx56 = getelementptr inbounds [8 x double], [8 x double]* %arrayidx54, i64 0, i64 %idxprom55, !dbg !115
  %67 = ptrtoint double* %arrayidx56 to i64
  call void @__dp_read(i32 16422, i64 %67, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %68 = load double, double* %arrayidx56, align 8, !dbg !115
  %add57 = fadd double %add49, %68, !dbg !118
  %69 = ptrtoint i32* %k to i64
  call void @__dp_read(i32 16422, i64 %69, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %70 = load i32, i32* %k, align 4, !dbg !119
  %idxprom58 = sext i32 %70 to i64, !dbg !120
  %arrayidx59 = getelementptr inbounds [8 x double], [8 x double]* %r1, i64 0, i64 %idxprom58, !dbg !120
  %71 = ptrtoint double* %arrayidx59 to i64
  call void @__dp_write(i32 16422, i64 %71, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.7, i32 0, i32 0))
  store double %add57, double* %arrayidx59, align 8, !dbg !121
  br label %for.inc60, !dbg !122

for.inc60:                                        ; preds = %for.body28
  %72 = ptrtoint i32* %k to i64
  call void @__dp_read(i32 16421, i64 %72, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %73 = load i32, i32* %k, align 4, !dbg !123
  %inc61 = add nsw i32 %73, 1, !dbg !123
  %74 = ptrtoint i32* %k to i64
  call void @__dp_write(i32 16421, i64 %74, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 %inc61, i32* %k, align 4, !dbg !123
  br label %for.cond25, !dbg !124, !llvm.loop !125

for.end62:                                        ; preds = %for.cond25
  call void @__dp_loop_exit(i32 16424, i32 5)
  br label %for.inc63, !dbg !127

for.inc63:                                        ; preds = %for.end62
  %75 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16420, i64 %75, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %76 = load i32, i32* %j, align 4, !dbg !128
  %inc64 = add nsw i32 %76, 1, !dbg !128
  %77 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16420, i64 %77, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 %inc64, i32* %j, align 4, !dbg !128
  br label %for.cond21, !dbg !129, !llvm.loop !130

for.end65:                                        ; preds = %for.cond21
  call void @__dp_loop_exit(i32 16425, i32 4)
  br label %for.inc66, !dbg !132

for.inc66:                                        ; preds = %for.end65
  %78 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16419, i64 %78, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %79 = load i32, i32* %i, align 4, !dbg !133
  %inc67 = add nsw i32 %79, 1, !dbg !133
  %80 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16419, i64 %80, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 %inc67, i32* %i, align 4, !dbg !133
  br label %for.cond17, !dbg !134, !llvm.loop !135

for.end68:                                        ; preds = %for.cond17
  call void @__dp_loop_exit(i32 16427, i32 3)
  %81 = ptrtoint i32* %k to i64
  call void @__dp_write(i32 16427, i64 %81, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 0, i32* %k, align 4, !dbg !137
  br label %for.cond69, !dbg !139

for.cond69:                                       ; preds = %for.inc75, %for.end68
  call void @__dp_loop_entry(i32 16427, i32 6)
  %82 = ptrtoint i32* %k to i64
  call void @__dp_read(i32 16427, i64 %82, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %83 = load i32, i32* %k, align 4, !dbg !140
  %cmp70 = icmp slt i32 %83, 8, !dbg !142
  br i1 %cmp70, label %for.body72, label %for.end77, !dbg !143

for.body72:                                       ; preds = %for.cond69
  %84 = ptrtoint i32* %k to i64
  call void @__dp_read(i32 16427, i64 %84, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %85 = load i32, i32* %k, align 4, !dbg !144
  %idxprom73 = sext i32 %85 to i64, !dbg !145
  %arrayidx74 = getelementptr inbounds [8 x double], [8 x double]* %r1, i64 0, i64 %idxprom73, !dbg !145
  %86 = ptrtoint double* %arrayidx74 to i64
  call void @__dp_read(i32 16427, i64 %86, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.7, i32 0, i32 0))
  %87 = load double, double* %arrayidx74, align 8, !dbg !145
  call void @__dp_call(i32 16427), !dbg !146
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), double %87), !dbg !146
  br label %for.inc75, !dbg !146

for.inc75:                                        ; preds = %for.body72
  %88 = ptrtoint i32* %k to i64
  call void @__dp_read(i32 16427, i64 %88, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %89 = load i32, i32* %k, align 4, !dbg !147
  %inc76 = add nsw i32 %89, 1, !dbg !147
  %90 = ptrtoint i32* %k to i64
  call void @__dp_write(i32 16427, i64 %90, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 %inc76, i32* %k, align 4, !dbg !147
  br label %for.cond69, !dbg !148, !llvm.loop !149

for.end77:                                        ; preds = %for.cond69
  call void @__dp_loop_exit(i32 16429, i32 6)
  call void @__dp_call(i32 16429), !dbg !151
  %call78 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i64 0, i64 0)), !dbg !151
  call void @__dp_finalize(i32 16431), !dbg !152
  ret i32 0, !dbg !152
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

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!3}
!llvm.module.flags = !{!4, !5, !6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/169")
!2 = !{}
!3 = !{!"Ubuntu clang version 11.1.0-6"}
!4 = !{i32 7, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 20, type: !8, scopeLine: 21, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 22, type: !10)
!12 = !DILocation(line: 22, column: 7, scope: !7)
!13 = !DILocalVariable(name: "j", scope: !7, file: !1, line: 22, type: !10)
!14 = !DILocation(line: 22, column: 9, scope: !7)
!15 = !DILocalVariable(name: "k", scope: !7, file: !1, line: 22, type: !10)
!16 = !DILocation(line: 22, column: 11, scope: !7)
!17 = !DILocalVariable(name: "r1", scope: !7, file: !1, line: 23, type: !18)
!18 = !DICompositeType(tag: DW_TAG_array_type, baseType: !19, size: 512, elements: !20)
!19 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!20 = !{!21}
!21 = !DISubrange(count: 8)
!22 = !DILocation(line: 23, column: 10, scope: !7)
!23 = !DILocalVariable(name: "r", scope: !7, file: !1, line: 23, type: !24)
!24 = !DICompositeType(tag: DW_TAG_array_type, baseType: !19, size: 32768, elements: !25)
!25 = !{!21, !21, !21}
!26 = !DILocation(line: 23, column: 17, scope: !7)
!27 = !DILocation(line: 25, column: 10, scope: !28)
!28 = distinct !DILexicalBlock(scope: !7, file: !1, line: 25, column: 3)
!29 = !DILocation(line: 25, column: 8, scope: !28)
!30 = !DILocation(line: 25, column: 15, scope: !31)
!31 = distinct !DILexicalBlock(scope: !28, file: !1, line: 25, column: 3)
!32 = !DILocation(line: 25, column: 17, scope: !31)
!33 = !DILocation(line: 25, column: 3, scope: !28)
!34 = !DILocation(line: 26, column: 12, scope: !35)
!35 = distinct !DILexicalBlock(scope: !36, file: !1, line: 26, column: 5)
!36 = distinct !DILexicalBlock(scope: !31, file: !1, line: 25, column: 27)
!37 = !DILocation(line: 26, column: 10, scope: !35)
!38 = !DILocation(line: 26, column: 17, scope: !39)
!39 = distinct !DILexicalBlock(scope: !35, file: !1, line: 26, column: 5)
!40 = !DILocation(line: 26, column: 19, scope: !39)
!41 = !DILocation(line: 26, column: 5, scope: !35)
!42 = !DILocation(line: 27, column: 14, scope: !43)
!43 = distinct !DILexicalBlock(scope: !44, file: !1, line: 27, column: 7)
!44 = distinct !DILexicalBlock(scope: !39, file: !1, line: 26, column: 29)
!45 = !DILocation(line: 27, column: 12, scope: !43)
!46 = !DILocation(line: 27, column: 19, scope: !47)
!47 = distinct !DILexicalBlock(scope: !43, file: !1, line: 27, column: 7)
!48 = !DILocation(line: 27, column: 21, scope: !47)
!49 = !DILocation(line: 27, column: 7, scope: !43)
!50 = !DILocation(line: 28, column: 22, scope: !51)
!51 = distinct !DILexicalBlock(scope: !47, file: !1, line: 27, column: 31)
!52 = !DILocation(line: 28, column: 11, scope: !51)
!53 = !DILocation(line: 28, column: 9, scope: !51)
!54 = !DILocation(line: 28, column: 14, scope: !51)
!55 = !DILocation(line: 28, column: 17, scope: !51)
!56 = !DILocation(line: 28, column: 20, scope: !51)
!57 = !DILocation(line: 29, column: 7, scope: !51)
!58 = !DILocation(line: 27, column: 27, scope: !47)
!59 = !DILocation(line: 27, column: 7, scope: !47)
!60 = distinct !{!60, !49, !61}
!61 = !DILocation(line: 29, column: 7, scope: !43)
!62 = !DILocation(line: 30, column: 5, scope: !44)
!63 = !DILocation(line: 26, column: 25, scope: !39)
!64 = !DILocation(line: 26, column: 5, scope: !39)
!65 = distinct !{!65, !41, !66}
!66 = !DILocation(line: 30, column: 5, scope: !35)
!67 = !DILocation(line: 31, column: 3, scope: !36)
!68 = !DILocation(line: 25, column: 23, scope: !31)
!69 = !DILocation(line: 25, column: 3, scope: !31)
!70 = distinct !{!70, !33, !71}
!71 = !DILocation(line: 31, column: 3, scope: !28)
!72 = !DILocation(line: 35, column: 10, scope: !73)
!73 = distinct !DILexicalBlock(scope: !7, file: !1, line: 35, column: 3)
!74 = !DILocation(line: 35, column: 8, scope: !73)
!75 = !DILocation(line: 35, column: 15, scope: !76)
!76 = distinct !DILexicalBlock(scope: !73, file: !1, line: 35, column: 3)
!77 = !DILocation(line: 35, column: 17, scope: !76)
!78 = !DILocation(line: 35, column: 3, scope: !73)
!79 = !DILocation(line: 36, column: 12, scope: !80)
!80 = distinct !DILexicalBlock(scope: !81, file: !1, line: 36, column: 5)
!81 = distinct !DILexicalBlock(scope: !76, file: !1, line: 35, column: 29)
!82 = !DILocation(line: 36, column: 10, scope: !80)
!83 = !DILocation(line: 36, column: 17, scope: !84)
!84 = distinct !DILexicalBlock(scope: !80, file: !1, line: 36, column: 5)
!85 = !DILocation(line: 36, column: 19, scope: !84)
!86 = !DILocation(line: 36, column: 5, scope: !80)
!87 = !DILocation(line: 37, column: 14, scope: !88)
!88 = distinct !DILexicalBlock(scope: !89, file: !1, line: 37, column: 7)
!89 = distinct !DILexicalBlock(scope: !84, file: !1, line: 36, column: 31)
!90 = !DILocation(line: 37, column: 12, scope: !88)
!91 = !DILocation(line: 37, column: 19, scope: !92)
!92 = distinct !DILexicalBlock(scope: !88, file: !1, line: 37, column: 7)
!93 = !DILocation(line: 37, column: 21, scope: !92)
!94 = !DILocation(line: 37, column: 7, scope: !88)
!95 = !DILocation(line: 38, column: 19, scope: !96)
!96 = distinct !DILexicalBlock(scope: !92, file: !1, line: 37, column: 31)
!97 = !DILocation(line: 38, column: 17, scope: !96)
!98 = !DILocation(line: 38, column: 22, scope: !96)
!99 = !DILocation(line: 38, column: 23, scope: !96)
!100 = !DILocation(line: 38, column: 27, scope: !96)
!101 = !DILocation(line: 38, column: 34, scope: !96)
!102 = !DILocation(line: 38, column: 32, scope: !96)
!103 = !DILocation(line: 38, column: 37, scope: !96)
!104 = !DILocation(line: 38, column: 38, scope: !96)
!105 = !DILocation(line: 38, column: 42, scope: !96)
!106 = !DILocation(line: 38, column: 30, scope: !96)
!107 = !DILocation(line: 38, column: 49, scope: !96)
!108 = !DILocation(line: 38, column: 50, scope: !96)
!109 = !DILocation(line: 38, column: 47, scope: !96)
!110 = !DILocation(line: 38, column: 54, scope: !96)
!111 = !DILocation(line: 38, column: 57, scope: !96)
!112 = !DILocation(line: 38, column: 45, scope: !96)
!113 = !DILocation(line: 38, column: 64, scope: !96)
!114 = !DILocation(line: 38, column: 65, scope: !96)
!115 = !DILocation(line: 38, column: 62, scope: !96)
!116 = !DILocation(line: 38, column: 69, scope: !96)
!117 = !DILocation(line: 38, column: 72, scope: !96)
!118 = !DILocation(line: 38, column: 60, scope: !96)
!119 = !DILocation(line: 38, column: 12, scope: !96)
!120 = !DILocation(line: 38, column: 9, scope: !96)
!121 = !DILocation(line: 38, column: 15, scope: !96)
!122 = !DILocation(line: 39, column: 7, scope: !96)
!123 = !DILocation(line: 37, column: 27, scope: !92)
!124 = !DILocation(line: 37, column: 7, scope: !92)
!125 = distinct !{!125, !94, !126}
!126 = !DILocation(line: 39, column: 7, scope: !88)
!127 = !DILocation(line: 40, column: 5, scope: !89)
!128 = !DILocation(line: 36, column: 27, scope: !84)
!129 = !DILocation(line: 36, column: 5, scope: !84)
!130 = distinct !{!130, !86, !131}
!131 = !DILocation(line: 40, column: 5, scope: !80)
!132 = !DILocation(line: 41, column: 3, scope: !81)
!133 = !DILocation(line: 35, column: 25, scope: !76)
!134 = !DILocation(line: 35, column: 3, scope: !76)
!135 = distinct !{!135, !78, !136}
!136 = !DILocation(line: 41, column: 3, scope: !73)
!137 = !DILocation(line: 43, column: 10, scope: !138)
!138 = distinct !DILexicalBlock(scope: !7, file: !1, line: 43, column: 3)
!139 = !DILocation(line: 43, column: 8, scope: !138)
!140 = !DILocation(line: 43, column: 15, scope: !141)
!141 = distinct !DILexicalBlock(scope: !138, file: !1, line: 43, column: 3)
!142 = !DILocation(line: 43, column: 17, scope: !141)
!143 = !DILocation(line: 43, column: 3, scope: !138)
!144 = !DILocation(line: 43, column: 43, scope: !141)
!145 = !DILocation(line: 43, column: 40, scope: !141)
!146 = !DILocation(line: 43, column: 27, scope: !141)
!147 = !DILocation(line: 43, column: 23, scope: !141)
!148 = !DILocation(line: 43, column: 3, scope: !141)
!149 = distinct !{!149, !143, !150}
!150 = !DILocation(line: 43, column: 45, scope: !138)
!151 = !DILocation(line: 45, column: 3, scope: !7)
!152 = !DILocation(line: 47, column: 3, scope: !7)
