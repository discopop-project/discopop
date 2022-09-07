; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.1 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"len\00", align 1
@.str.3 = private unnamed_addr constant [12 x i8] c"saved_stack\00", align 1
@.str.4 = private unnamed_addr constant [12 x i8] c"__vla_expr0\00", align 1
@.str.5 = private unnamed_addr constant [12 x i8] c"__vla_expr1\00", align 1
@.str.6 = private unnamed_addr constant [12 x i8] c"__vla_expr2\00", align 1
@.str.7 = private unnamed_addr constant [12 x i8] c"__vla_expr3\00", align 1
@.str.8 = private unnamed_addr constant [12 x i8] c"__vla_expr4\00", align 1
@.str.9 = private unnamed_addr constant [12 x i8] c"__vla_expr5\00", align 1
@.str.10 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.11 = private unnamed_addr constant [2 x i8] c"j\00", align 1
@.str.12 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.13 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.str.14 = private unnamed_addr constant [2 x i8] c"c\00", align 1
@.str = private unnamed_addr constant [14 x i8] c"c[50][50]=%f\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !9 {
entry:
  call void @__dp_func_entry(i32 16436, i32 1)
  %retval = alloca i32, align 4
  %len = alloca i32, align 4
  %saved_stack = alloca i8*, align 8
  %__vla_expr0 = alloca i64, align 8
  %__vla_expr1 = alloca i64, align 8
  %__vla_expr2 = alloca i64, align 8
  %__vla_expr3 = alloca i64, align 8
  %__vla_expr4 = alloca i64, align 8
  %__vla_expr5 = alloca i64, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16436, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %len, metadata !13, metadata !DIExpression()), !dbg !14
  %1 = ptrtoint i32* %len to i64
  call void @__dp_write(i32 16438, i64 %1, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  store i32 100, i32* %len, align 4, !dbg !14
  %2 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16439, i64 %2, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  %3 = load i32, i32* %len, align 4, !dbg !15
  %4 = zext i32 %3 to i64, !dbg !16
  %5 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16439, i64 %5, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  %6 = load i32, i32* %len, align 4, !dbg !17
  %7 = zext i32 %6 to i64, !dbg !16
  call void @__dp_call(i32 16439), !dbg !16
  %8 = call i8* @llvm.stacksave(), !dbg !16
  %9 = ptrtoint i8** %saved_stack to i64
  call void @__dp_write(i32 16439, i64 %9, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.3, i32 0, i32 0))
  store i8* %8, i8** %saved_stack, align 8, !dbg !16
  %10 = mul nuw i64 %4, %7, !dbg !16
  %vla = alloca double, i64 %10, align 16, !dbg !16
  %11 = ptrtoint i64* %__vla_expr0 to i64
  call void @__dp_write(i32 16439, i64 %11, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.4, i32 0, i32 0))
  store i64 %4, i64* %__vla_expr0, align 8, !dbg !16
  %12 = ptrtoint i64* %__vla_expr1 to i64
  call void @__dp_write(i32 16439, i64 %12, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.5, i32 0, i32 0))
  store i64 %7, i64* %__vla_expr1, align 8, !dbg !16
  call void @llvm.dbg.declare(metadata i64* %__vla_expr0, metadata !18, metadata !DIExpression()), !dbg !20
  call void @llvm.dbg.declare(metadata i64* %__vla_expr1, metadata !21, metadata !DIExpression()), !dbg !20
  call void @llvm.dbg.declare(metadata double* %vla, metadata !22, metadata !DIExpression()), !dbg !27
  %13 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16439, i64 %13, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  %14 = load i32, i32* %len, align 4, !dbg !28
  %15 = zext i32 %14 to i64, !dbg !16
  %16 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16439, i64 %16, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  %17 = load i32, i32* %len, align 4, !dbg !29
  %18 = zext i32 %17 to i64, !dbg !16
  %19 = mul nuw i64 %15, %18, !dbg !16
  %vla1 = alloca double, i64 %19, align 16, !dbg !16
  %20 = ptrtoint i64* %__vla_expr2 to i64
  call void @__dp_write(i32 16439, i64 %20, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.6, i32 0, i32 0))
  store i64 %15, i64* %__vla_expr2, align 8, !dbg !16
  %21 = ptrtoint i64* %__vla_expr3 to i64
  call void @__dp_write(i32 16439, i64 %21, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.7, i32 0, i32 0))
  store i64 %18, i64* %__vla_expr3, align 8, !dbg !16
  call void @llvm.dbg.declare(metadata i64* %__vla_expr2, metadata !30, metadata !DIExpression()), !dbg !20
  call void @llvm.dbg.declare(metadata i64* %__vla_expr3, metadata !31, metadata !DIExpression()), !dbg !20
  call void @llvm.dbg.declare(metadata double* %vla1, metadata !32, metadata !DIExpression()), !dbg !37
  %22 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16439, i64 %22, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  %23 = load i32, i32* %len, align 4, !dbg !38
  %24 = zext i32 %23 to i64, !dbg !16
  %25 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16439, i64 %25, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  %26 = load i32, i32* %len, align 4, !dbg !39
  %27 = zext i32 %26 to i64, !dbg !16
  %28 = mul nuw i64 %24, %27, !dbg !16
  %vla2 = alloca double, i64 %28, align 16, !dbg !16
  %29 = ptrtoint i64* %__vla_expr4 to i64
  call void @__dp_write(i32 16439, i64 %29, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.8, i32 0, i32 0))
  store i64 %24, i64* %__vla_expr4, align 8, !dbg !16
  %30 = ptrtoint i64* %__vla_expr5 to i64
  call void @__dp_write(i32 16439, i64 %30, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.9, i32 0, i32 0))
  store i64 %27, i64* %__vla_expr5, align 8, !dbg !16
  call void @llvm.dbg.declare(metadata i64* %__vla_expr4, metadata !40, metadata !DIExpression()), !dbg !20
  call void @llvm.dbg.declare(metadata i64* %__vla_expr5, metadata !41, metadata !DIExpression()), !dbg !20
  call void @llvm.dbg.declare(metadata double* %vla2, metadata !42, metadata !DIExpression()), !dbg !47
  call void @llvm.dbg.declare(metadata i32* %i, metadata !48, metadata !DIExpression()), !dbg !49
  call void @llvm.dbg.declare(metadata i32* %j, metadata !50, metadata !DIExpression()), !dbg !51
  %31 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16442, i64 %31, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !52
  br label %for.cond, !dbg !54

for.cond:                                         ; preds = %for.inc20, %entry
  call void @__dp_loop_entry(i32 16442, i32 0)
  %32 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16442, i64 %32, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  %33 = load i32, i32* %i, align 4, !dbg !55
  %34 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16442, i64 %34, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  %35 = load i32, i32* %len, align 4, !dbg !57
  %cmp = icmp slt i32 %33, %35, !dbg !58
  br i1 %cmp, label %for.body, label %for.end22, !dbg !59

for.body:                                         ; preds = %for.cond
  %36 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16443, i64 %36, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.11, i32 0, i32 0))
  store i32 0, i32* %j, align 4, !dbg !60
  br label %for.cond3, !dbg !62

for.cond3:                                        ; preds = %for.inc, %for.body
  call void @__dp_loop_entry(i32 16443, i32 1)
  %37 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16443, i64 %37, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.11, i32 0, i32 0))
  %38 = load i32, i32* %j, align 4, !dbg !63
  %39 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16443, i64 %39, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  %40 = load i32, i32* %len, align 4, !dbg !65
  %cmp4 = icmp slt i32 %38, %40, !dbg !66
  br i1 %cmp4, label %for.body5, label %for.end, !dbg !67

for.body5:                                        ; preds = %for.cond3
  %41 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16445, i64 %41, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  %42 = load i32, i32* %i, align 4, !dbg !68
  %conv = sitofp i32 %42 to double, !dbg !70
  %div = fdiv double %conv, 2.000000e+00, !dbg !71
  %43 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16445, i64 %43, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  %44 = load i32, i32* %i, align 4, !dbg !72
  %idxprom = sext i32 %44 to i64, !dbg !73
  %45 = mul nsw i64 %idxprom, %7, !dbg !73
  %arrayidx = getelementptr inbounds double, double* %vla, i64 %45, !dbg !73
  %46 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16445, i64 %46, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.11, i32 0, i32 0))
  %47 = load i32, i32* %j, align 4, !dbg !74
  %idxprom6 = sext i32 %47 to i64, !dbg !73
  %arrayidx7 = getelementptr inbounds double, double* %arrayidx, i64 %idxprom6, !dbg !73
  %48 = ptrtoint double* %arrayidx7 to i64
  call void @__dp_write(i32 16445, i64 %48, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.12, i32 0, i32 0))
  store double %div, double* %arrayidx7, align 8, !dbg !75
  %49 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16446, i64 %49, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  %50 = load i32, i32* %i, align 4, !dbg !76
  %conv8 = sitofp i32 %50 to double, !dbg !77
  %div9 = fdiv double %conv8, 3.000000e+00, !dbg !78
  %51 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16446, i64 %51, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  %52 = load i32, i32* %i, align 4, !dbg !79
  %idxprom10 = sext i32 %52 to i64, !dbg !80
  %53 = mul nsw i64 %idxprom10, %18, !dbg !80
  %arrayidx11 = getelementptr inbounds double, double* %vla1, i64 %53, !dbg !80
  %54 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16446, i64 %54, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.11, i32 0, i32 0))
  %55 = load i32, i32* %j, align 4, !dbg !81
  %idxprom12 = sext i32 %55 to i64, !dbg !80
  %arrayidx13 = getelementptr inbounds double, double* %arrayidx11, i64 %idxprom12, !dbg !80
  %56 = ptrtoint double* %arrayidx13 to i64
  call void @__dp_write(i32 16446, i64 %56, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.13, i32 0, i32 0))
  store double %div9, double* %arrayidx13, align 8, !dbg !82
  %57 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16447, i64 %57, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  %58 = load i32, i32* %i, align 4, !dbg !83
  %conv14 = sitofp i32 %58 to double, !dbg !84
  %div15 = fdiv double %conv14, 7.000000e+00, !dbg !85
  %59 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16447, i64 %59, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  %60 = load i32, i32* %i, align 4, !dbg !86
  %idxprom16 = sext i32 %60 to i64, !dbg !87
  %61 = mul nsw i64 %idxprom16, %27, !dbg !87
  %arrayidx17 = getelementptr inbounds double, double* %vla2, i64 %61, !dbg !87
  %62 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16447, i64 %62, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.11, i32 0, i32 0))
  %63 = load i32, i32* %j, align 4, !dbg !88
  %idxprom18 = sext i32 %63 to i64, !dbg !87
  %arrayidx19 = getelementptr inbounds double, double* %arrayidx17, i64 %idxprom18, !dbg !87
  %64 = ptrtoint double* %arrayidx19 to i64
  call void @__dp_write(i32 16447, i64 %64, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.14, i32 0, i32 0))
  store double %div15, double* %arrayidx19, align 8, !dbg !89
  br label %for.inc, !dbg !90

for.inc:                                          ; preds = %for.body5
  %65 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16443, i64 %65, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.11, i32 0, i32 0))
  %66 = load i32, i32* %j, align 4, !dbg !91
  %inc = add nsw i32 %66, 1, !dbg !91
  %67 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16443, i64 %67, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.11, i32 0, i32 0))
  store i32 %inc, i32* %j, align 4, !dbg !91
  br label %for.cond3, !dbg !92, !llvm.loop !93

for.end:                                          ; preds = %for.cond3
  call void @__dp_loop_exit(i32 16448, i32 1)
  br label %for.inc20, !dbg !94

for.inc20:                                        ; preds = %for.end
  %68 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16442, i64 %68, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  %69 = load i32, i32* %i, align 4, !dbg !95
  %inc21 = add nsw i32 %69, 1, !dbg !95
  %70 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16442, i64 %70, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  store i32 %inc21, i32* %i, align 4, !dbg !95
  br label %for.cond, !dbg !96, !llvm.loop !97

for.end22:                                        ; preds = %for.cond
  call void @__dp_loop_exit(i32 16451, i32 0)
  %71 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16451, i64 %71, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !99
  br label %for.cond23, !dbg !101

for.cond23:                                       ; preds = %for.inc46, %for.end22
  call void @__dp_loop_entry(i32 16451, i32 2)
  %72 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16451, i64 %72, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  %73 = load i32, i32* %i, align 4, !dbg !102
  %74 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16451, i64 %74, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  %75 = load i32, i32* %len, align 4, !dbg !104
  %cmp24 = icmp slt i32 %73, %75, !dbg !105
  br i1 %cmp24, label %for.body26, label %for.end48, !dbg !106

for.body26:                                       ; preds = %for.cond23
  %76 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16452, i64 %76, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.11, i32 0, i32 0))
  store i32 0, i32* %j, align 4, !dbg !107
  br label %for.cond27, !dbg !109

for.cond27:                                       ; preds = %for.inc43, %for.body26
  call void @__dp_loop_entry(i32 16452, i32 3)
  %77 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16452, i64 %77, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.11, i32 0, i32 0))
  %78 = load i32, i32* %j, align 4, !dbg !110
  %79 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16452, i64 %79, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  %80 = load i32, i32* %len, align 4, !dbg !112
  %cmp28 = icmp slt i32 %78, %80, !dbg !113
  br i1 %cmp28, label %for.body30, label %for.end45, !dbg !114

for.body30:                                       ; preds = %for.cond27
  %81 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16453, i64 %81, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  %82 = load i32, i32* %i, align 4, !dbg !115
  %idxprom31 = sext i32 %82 to i64, !dbg !116
  %83 = mul nsw i64 %idxprom31, %7, !dbg !116
  %arrayidx32 = getelementptr inbounds double, double* %vla, i64 %83, !dbg !116
  %84 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16453, i64 %84, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.11, i32 0, i32 0))
  %85 = load i32, i32* %j, align 4, !dbg !117
  %idxprom33 = sext i32 %85 to i64, !dbg !116
  %arrayidx34 = getelementptr inbounds double, double* %arrayidx32, i64 %idxprom33, !dbg !116
  %86 = ptrtoint double* %arrayidx34 to i64
  call void @__dp_read(i32 16453, i64 %86, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.12, i32 0, i32 0))
  %87 = load double, double* %arrayidx34, align 8, !dbg !116
  %88 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16453, i64 %88, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  %89 = load i32, i32* %i, align 4, !dbg !118
  %idxprom35 = sext i32 %89 to i64, !dbg !119
  %90 = mul nsw i64 %idxprom35, %18, !dbg !119
  %arrayidx36 = getelementptr inbounds double, double* %vla1, i64 %90, !dbg !119
  %91 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16453, i64 %91, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.11, i32 0, i32 0))
  %92 = load i32, i32* %j, align 4, !dbg !120
  %idxprom37 = sext i32 %92 to i64, !dbg !119
  %arrayidx38 = getelementptr inbounds double, double* %arrayidx36, i64 %idxprom37, !dbg !119
  %93 = ptrtoint double* %arrayidx38 to i64
  call void @__dp_read(i32 16453, i64 %93, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.13, i32 0, i32 0))
  %94 = load double, double* %arrayidx38, align 8, !dbg !119
  %mul = fmul double %87, %94, !dbg !121
  %95 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16453, i64 %95, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  %96 = load i32, i32* %i, align 4, !dbg !122
  %idxprom39 = sext i32 %96 to i64, !dbg !123
  %97 = mul nsw i64 %idxprom39, %27, !dbg !123
  %arrayidx40 = getelementptr inbounds double, double* %vla2, i64 %97, !dbg !123
  %98 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16453, i64 %98, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.11, i32 0, i32 0))
  %99 = load i32, i32* %j, align 4, !dbg !124
  %idxprom41 = sext i32 %99 to i64, !dbg !123
  %arrayidx42 = getelementptr inbounds double, double* %arrayidx40, i64 %idxprom41, !dbg !123
  %100 = ptrtoint double* %arrayidx42 to i64
  call void @__dp_write(i32 16453, i64 %100, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.14, i32 0, i32 0))
  store double %mul, double* %arrayidx42, align 8, !dbg !125
  br label %for.inc43, !dbg !123

for.inc43:                                        ; preds = %for.body30
  %101 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16452, i64 %101, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.11, i32 0, i32 0))
  %102 = load i32, i32* %j, align 4, !dbg !126
  %inc44 = add nsw i32 %102, 1, !dbg !126
  %103 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16452, i64 %103, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.11, i32 0, i32 0))
  store i32 %inc44, i32* %j, align 4, !dbg !126
  br label %for.cond27, !dbg !127, !llvm.loop !128

for.end45:                                        ; preds = %for.cond27
  call void @__dp_loop_exit(i32 16453, i32 3)
  br label %for.inc46, !dbg !129

for.inc46:                                        ; preds = %for.end45
  %104 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16451, i64 %104, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  %105 = load i32, i32* %i, align 4, !dbg !130
  %inc47 = add nsw i32 %105, 1, !dbg !130
  %106 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16451, i64 %106, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  store i32 %inc47, i32* %i, align 4, !dbg !130
  br label %for.cond23, !dbg !131, !llvm.loop !132

for.end48:                                        ; preds = %for.cond23
  call void @__dp_loop_exit(i32 16455, i32 2)
  %107 = mul nsw i64 50, %27, !dbg !134
  %arrayidx49 = getelementptr inbounds double, double* %vla2, i64 %107, !dbg !134
  %arrayidx50 = getelementptr inbounds double, double* %arrayidx49, i64 50, !dbg !134
  %108 = ptrtoint double* %arrayidx50 to i64
  call void @__dp_read(i32 16455, i64 %108, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.14, i32 0, i32 0))
  %109 = load double, double* %arrayidx50, align 8, !dbg !134
  call void @__dp_call(i32 16455), !dbg !135
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str, i64 0, i64 0), double %109), !dbg !135
  %110 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16456, i64 %110, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %retval, align 4, !dbg !136
  %111 = ptrtoint i8** %saved_stack to i64
  call void @__dp_read(i32 16457, i64 %111, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.3, i32 0, i32 0))
  %112 = load i8*, i8** %saved_stack, align 8, !dbg !137
  call void @__dp_call(i32 16457), !dbg !137
  call void @llvm.stackrestore(i8* %112), !dbg !137
  %113 = ptrtoint i32* %retval to i64
  call void @__dp_read(i32 16457, i64 %113, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  %114 = load i32, i32* %retval, align 4, !dbg !137
  call void @__dp_finalize(i32 16457), !dbg !137
  ret i32 %114, !dbg !137
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
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/098")
!2 = !{}
!3 = !{!4}
!4 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!5 = !{!"Ubuntu clang version 11.1.0-6"}
!6 = !{i32 7, !"Dwarf Version", i32 4}
!7 = !{i32 2, !"Debug Info Version", i32 3}
!8 = !{i32 1, !"wchar_size", i32 4}
!9 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 52, type: !10, scopeLine: 53, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!10 = !DISubroutineType(types: !11)
!11 = !{!12}
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !DILocalVariable(name: "len", scope: !9, file: !1, line: 54, type: !12)
!14 = !DILocation(line: 54, column: 7, scope: !9)
!15 = !DILocation(line: 55, column: 12, scope: !9)
!16 = !DILocation(line: 55, column: 3, scope: !9)
!17 = !DILocation(line: 55, column: 17, scope: !9)
!18 = !DILocalVariable(name: "__vla_expr0", scope: !9, type: !19, flags: DIFlagArtificial)
!19 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!20 = !DILocation(line: 0, scope: !9)
!21 = !DILocalVariable(name: "__vla_expr1", scope: !9, type: !19, flags: DIFlagArtificial)
!22 = !DILocalVariable(name: "a", scope: !9, file: !1, line: 55, type: !23)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, elements: !24)
!24 = !{!25, !26}
!25 = !DISubrange(count: !18)
!26 = !DISubrange(count: !21)
!27 = !DILocation(line: 55, column: 10, scope: !9)
!28 = !DILocation(line: 55, column: 25, scope: !9)
!29 = !DILocation(line: 55, column: 30, scope: !9)
!30 = !DILocalVariable(name: "__vla_expr2", scope: !9, type: !19, flags: DIFlagArtificial)
!31 = !DILocalVariable(name: "__vla_expr3", scope: !9, type: !19, flags: DIFlagArtificial)
!32 = !DILocalVariable(name: "b", scope: !9, file: !1, line: 55, type: !33)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, elements: !34)
!34 = !{!35, !36}
!35 = !DISubrange(count: !30)
!36 = !DISubrange(count: !31)
!37 = !DILocation(line: 55, column: 23, scope: !9)
!38 = !DILocation(line: 55, column: 38, scope: !9)
!39 = !DILocation(line: 55, column: 43, scope: !9)
!40 = !DILocalVariable(name: "__vla_expr4", scope: !9, type: !19, flags: DIFlagArtificial)
!41 = !DILocalVariable(name: "__vla_expr5", scope: !9, type: !19, flags: DIFlagArtificial)
!42 = !DILocalVariable(name: "c", scope: !9, file: !1, line: 55, type: !43)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, elements: !44)
!44 = !{!45, !46}
!45 = !DISubrange(count: !40)
!46 = !DISubrange(count: !41)
!47 = !DILocation(line: 55, column: 36, scope: !9)
!48 = !DILocalVariable(name: "i", scope: !9, file: !1, line: 56, type: !12)
!49 = !DILocation(line: 56, column: 7, scope: !9)
!50 = !DILocalVariable(name: "j", scope: !9, file: !1, line: 56, type: !12)
!51 = !DILocation(line: 56, column: 9, scope: !9)
!52 = !DILocation(line: 58, column: 9, scope: !53)
!53 = distinct !DILexicalBlock(scope: !9, file: !1, line: 58, column: 3)
!54 = !DILocation(line: 58, column: 8, scope: !53)
!55 = !DILocation(line: 58, column: 12, scope: !56)
!56 = distinct !DILexicalBlock(scope: !53, file: !1, line: 58, column: 3)
!57 = !DILocation(line: 58, column: 14, scope: !56)
!58 = !DILocation(line: 58, column: 13, scope: !56)
!59 = !DILocation(line: 58, column: 3, scope: !53)
!60 = !DILocation(line: 59, column: 11, scope: !61)
!61 = distinct !DILexicalBlock(scope: !56, file: !1, line: 59, column: 5)
!62 = !DILocation(line: 59, column: 10, scope: !61)
!63 = !DILocation(line: 59, column: 14, scope: !64)
!64 = distinct !DILexicalBlock(scope: !61, file: !1, line: 59, column: 5)
!65 = !DILocation(line: 59, column: 16, scope: !64)
!66 = !DILocation(line: 59, column: 15, scope: !64)
!67 = !DILocation(line: 59, column: 5, scope: !61)
!68 = !DILocation(line: 61, column: 24, scope: !69)
!69 = distinct !DILexicalBlock(scope: !64, file: !1, line: 60, column: 5)
!70 = !DILocation(line: 61, column: 16, scope: !69)
!71 = !DILocation(line: 61, column: 26, scope: !69)
!72 = !DILocation(line: 61, column: 9, scope: !69)
!73 = !DILocation(line: 61, column: 7, scope: !69)
!74 = !DILocation(line: 61, column: 12, scope: !69)
!75 = !DILocation(line: 61, column: 14, scope: !69)
!76 = !DILocation(line: 62, column: 24, scope: !69)
!77 = !DILocation(line: 62, column: 16, scope: !69)
!78 = !DILocation(line: 62, column: 26, scope: !69)
!79 = !DILocation(line: 62, column: 9, scope: !69)
!80 = !DILocation(line: 62, column: 7, scope: !69)
!81 = !DILocation(line: 62, column: 12, scope: !69)
!82 = !DILocation(line: 62, column: 14, scope: !69)
!83 = !DILocation(line: 63, column: 24, scope: !69)
!84 = !DILocation(line: 63, column: 16, scope: !69)
!85 = !DILocation(line: 63, column: 26, scope: !69)
!86 = !DILocation(line: 63, column: 9, scope: !69)
!87 = !DILocation(line: 63, column: 7, scope: !69)
!88 = !DILocation(line: 63, column: 12, scope: !69)
!89 = !DILocation(line: 63, column: 14, scope: !69)
!90 = !DILocation(line: 64, column: 5, scope: !69)
!91 = !DILocation(line: 59, column: 21, scope: !64)
!92 = !DILocation(line: 59, column: 5, scope: !64)
!93 = distinct !{!93, !67, !94}
!94 = !DILocation(line: 64, column: 5, scope: !61)
!95 = !DILocation(line: 58, column: 19, scope: !56)
!96 = !DILocation(line: 58, column: 3, scope: !56)
!97 = distinct !{!97, !59, !98}
!98 = !DILocation(line: 64, column: 5, scope: !53)
!99 = !DILocation(line: 67, column: 9, scope: !100)
!100 = distinct !DILexicalBlock(scope: !9, file: !1, line: 67, column: 3)
!101 = !DILocation(line: 67, column: 8, scope: !100)
!102 = !DILocation(line: 67, column: 12, scope: !103)
!103 = distinct !DILexicalBlock(scope: !100, file: !1, line: 67, column: 3)
!104 = !DILocation(line: 67, column: 14, scope: !103)
!105 = !DILocation(line: 67, column: 13, scope: !103)
!106 = !DILocation(line: 67, column: 3, scope: !100)
!107 = !DILocation(line: 68, column: 11, scope: !108)
!108 = distinct !DILexicalBlock(scope: !103, file: !1, line: 68, column: 5)
!109 = !DILocation(line: 68, column: 10, scope: !108)
!110 = !DILocation(line: 68, column: 14, scope: !111)
!111 = distinct !DILexicalBlock(scope: !108, file: !1, line: 68, column: 5)
!112 = !DILocation(line: 68, column: 16, scope: !111)
!113 = !DILocation(line: 68, column: 15, scope: !111)
!114 = !DILocation(line: 68, column: 5, scope: !108)
!115 = !DILocation(line: 69, column: 17, scope: !111)
!116 = !DILocation(line: 69, column: 15, scope: !111)
!117 = !DILocation(line: 69, column: 20, scope: !111)
!118 = !DILocation(line: 69, column: 25, scope: !111)
!119 = !DILocation(line: 69, column: 23, scope: !111)
!120 = !DILocation(line: 69, column: 28, scope: !111)
!121 = !DILocation(line: 69, column: 22, scope: !111)
!122 = !DILocation(line: 69, column: 9, scope: !111)
!123 = !DILocation(line: 69, column: 7, scope: !111)
!124 = !DILocation(line: 69, column: 12, scope: !111)
!125 = !DILocation(line: 69, column: 14, scope: !111)
!126 = !DILocation(line: 68, column: 21, scope: !111)
!127 = !DILocation(line: 68, column: 5, scope: !111)
!128 = distinct !{!128, !114, !129}
!129 = !DILocation(line: 69, column: 29, scope: !108)
!130 = !DILocation(line: 67, column: 19, scope: !103)
!131 = !DILocation(line: 67, column: 3, scope: !103)
!132 = distinct !{!132, !106, !133}
!133 = !DILocation(line: 69, column: 29, scope: !100)
!134 = !DILocation(line: 71, column: 28, scope: !9)
!135 = !DILocation(line: 71, column: 3, scope: !9)
!136 = !DILocation(line: 72, column: 3, scope: !9)
!137 = !DILocation(line: 73, column: 1, scope: !9)
