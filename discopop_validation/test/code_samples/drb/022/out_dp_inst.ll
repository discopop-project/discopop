; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.1 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"argc\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"argv\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"sum\00", align 1
@.str.5 = private unnamed_addr constant [4 x i8] c"len\00", align 1
@.str.6 = private unnamed_addr constant [12 x i8] c"saved_stack\00", align 1
@.str.7 = private unnamed_addr constant [12 x i8] c"__vla_expr0\00", align 1
@.str.8 = private unnamed_addr constant [12 x i8] c"__vla_expr1\00", align 1
@.str.9 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.10 = private unnamed_addr constant [2 x i8] c"j\00", align 1
@.str.11 = private unnamed_addr constant [2 x i8] c"u\00", align 1
@.str.12 = private unnamed_addr constant [5 x i8] c"temp\00", align 1
@.str = private unnamed_addr constant [10 x i8] c"sum = %f\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16439, i32 1)
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %temp = alloca float, align 4
  %sum = alloca float, align 4
  %len = alloca i32, align 4
  %saved_stack = alloca i8*, align 8
  %__vla_expr0 = alloca i64, align 8
  %__vla_expr1 = alloca i64, align 8
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16439, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  %1 = ptrtoint i32* %argc.addr to i64
  call void @__dp_write(i32 16439, i64 %1, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i32 0, i32 0))
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !14, metadata !DIExpression()), !dbg !15
  %2 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_write(i32 16439, i64 %2, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0))
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !16, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.declare(metadata i32* %i, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32* %j, metadata !20, metadata !DIExpression()), !dbg !21
  call void @llvm.dbg.declare(metadata float* %temp, metadata !22, metadata !DIExpression()), !dbg !24
  call void @llvm.dbg.declare(metadata float* %sum, metadata !25, metadata !DIExpression()), !dbg !26
  %3 = ptrtoint float* %sum to i64
  call void @__dp_write(i32 16442, i64 %3, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  store float 0.000000e+00, float* %sum, align 4, !dbg !26
  call void @llvm.dbg.declare(metadata i32* %len, metadata !27, metadata !DIExpression()), !dbg !28
  %4 = ptrtoint i32* %len to i64
  call void @__dp_write(i32 16443, i64 %4, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i32 0, i32 0))
  store i32 100, i32* %len, align 4, !dbg !28
  %5 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 16444, i64 %5, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i32 0, i32 0))
  %6 = load i32, i32* %argc.addr, align 4, !dbg !29
  %cmp = icmp sgt i32 %6, 1, !dbg !31
  br i1 %cmp, label %if.then, label %if.end, !dbg !32

if.then:                                          ; preds = %entry
  %7 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 16445, i64 %7, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0))
  %8 = load i8**, i8*** %argv.addr, align 8, !dbg !33
  %arrayidx = getelementptr inbounds i8*, i8** %8, i64 1, !dbg !33
  %9 = ptrtoint i8** %arrayidx to i64
  call void @__dp_read(i32 16445, i64 %9, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0))
  %10 = load i8*, i8** %arrayidx, align 8, !dbg !33
  call void @__dp_call(i32 16445), !dbg !34
  %call = call i32 @atoi(i8* %10) #5, !dbg !34
  %11 = ptrtoint i32* %len to i64
  call void @__dp_write(i32 16445, i64 %11, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i32 0, i32 0))
  store i32 %call, i32* %len, align 4, !dbg !35
  br label %if.end, !dbg !36

if.end:                                           ; preds = %if.then, %entry
  %12 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16446, i64 %12, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i32 0, i32 0))
  %13 = load i32, i32* %len, align 4, !dbg !37
  %14 = zext i32 %13 to i64, !dbg !38
  %15 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16446, i64 %15, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i32 0, i32 0))
  %16 = load i32, i32* %len, align 4, !dbg !39
  %17 = zext i32 %16 to i64, !dbg !38
  call void @__dp_call(i32 16446), !dbg !38
  %18 = call i8* @llvm.stacksave(), !dbg !38
  %19 = ptrtoint i8** %saved_stack to i64
  call void @__dp_write(i32 16446, i64 %19, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.6, i32 0, i32 0))
  store i8* %18, i8** %saved_stack, align 8, !dbg !38
  %20 = mul nuw i64 %14, %17, !dbg !38
  %vla = alloca float, i64 %20, align 16, !dbg !38
  %21 = ptrtoint i64* %__vla_expr0 to i64
  call void @__dp_write(i32 16446, i64 %21, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.7, i32 0, i32 0))
  store i64 %14, i64* %__vla_expr0, align 8, !dbg !38
  %22 = ptrtoint i64* %__vla_expr1 to i64
  call void @__dp_write(i32 16446, i64 %22, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.8, i32 0, i32 0))
  store i64 %17, i64* %__vla_expr1, align 8, !dbg !38
  call void @llvm.dbg.declare(metadata i64* %__vla_expr0, metadata !40, metadata !DIExpression()), !dbg !42
  call void @llvm.dbg.declare(metadata i64* %__vla_expr1, metadata !43, metadata !DIExpression()), !dbg !42
  call void @llvm.dbg.declare(metadata float* %vla, metadata !44, metadata !DIExpression()), !dbg !49
  %23 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16447, i64 %23, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !50
  br label %for.cond, !dbg !52

for.cond:                                         ; preds = %for.inc8, %if.end
  call void @__dp_loop_entry(i32 16447, i32 0)
  %24 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16447, i64 %24, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  %25 = load i32, i32* %i, align 4, !dbg !53
  %26 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16447, i64 %26, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i32 0, i32 0))
  %27 = load i32, i32* %len, align 4, !dbg !55
  %cmp1 = icmp slt i32 %25, %27, !dbg !56
  br i1 %cmp1, label %for.body, label %for.end10, !dbg !57

for.body:                                         ; preds = %for.cond
  %28 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16448, i64 %28, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  store i32 0, i32* %j, align 4, !dbg !58
  br label %for.cond2, !dbg !60

for.cond2:                                        ; preds = %for.inc, %for.body
  call void @__dp_loop_entry(i32 16448, i32 1)
  %29 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16448, i64 %29, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  %30 = load i32, i32* %j, align 4, !dbg !61
  %31 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16448, i64 %31, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i32 0, i32 0))
  %32 = load i32, i32* %len, align 4, !dbg !63
  %cmp3 = icmp slt i32 %30, %32, !dbg !64
  br i1 %cmp3, label %for.body4, label %for.end, !dbg !65

for.body4:                                        ; preds = %for.cond2
  %33 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16449, i64 %33, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  %34 = load i32, i32* %i, align 4, !dbg !66
  %idxprom = sext i32 %34 to i64, !dbg !67
  %35 = mul nsw i64 %idxprom, %17, !dbg !67
  %arrayidx5 = getelementptr inbounds float, float* %vla, i64 %35, !dbg !67
  %36 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16449, i64 %36, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  %37 = load i32, i32* %j, align 4, !dbg !68
  %idxprom6 = sext i32 %37 to i64, !dbg !67
  %arrayidx7 = getelementptr inbounds float, float* %arrayidx5, i64 %idxprom6, !dbg !67
  %38 = ptrtoint float* %arrayidx7 to i64
  call void @__dp_write(i32 16449, i64 %38, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.11, i32 0, i32 0))
  store float 5.000000e-01, float* %arrayidx7, align 4, !dbg !69
  br label %for.inc, !dbg !67

for.inc:                                          ; preds = %for.body4
  %39 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16448, i64 %39, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  %40 = load i32, i32* %j, align 4, !dbg !70
  %inc = add nsw i32 %40, 1, !dbg !70
  %41 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16448, i64 %41, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  store i32 %inc, i32* %j, align 4, !dbg !70
  br label %for.cond2, !dbg !71, !llvm.loop !72

for.end:                                          ; preds = %for.cond2
  call void @__dp_loop_exit(i32 16449, i32 1)
  br label %for.inc8, !dbg !73

for.inc8:                                         ; preds = %for.end
  %42 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16447, i64 %42, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  %43 = load i32, i32* %i, align 4, !dbg !74
  %inc9 = add nsw i32 %43, 1, !dbg !74
  %44 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16447, i64 %44, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  store i32 %inc9, i32* %i, align 4, !dbg !74
  br label %for.cond, !dbg !75, !llvm.loop !76

for.end10:                                        ; preds = %for.cond
  call void @__dp_loop_exit(i32 16452, i32 0)
  %45 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16452, i64 %45, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !78
  br label %for.cond11, !dbg !80

for.cond11:                                       ; preds = %for.inc24, %for.end10
  call void @__dp_loop_entry(i32 16452, i32 2)
  %46 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16452, i64 %46, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  %47 = load i32, i32* %i, align 4, !dbg !81
  %48 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16452, i64 %48, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i32 0, i32 0))
  %49 = load i32, i32* %len, align 4, !dbg !83
  %cmp12 = icmp slt i32 %47, %49, !dbg !84
  br i1 %cmp12, label %for.body13, label %for.end26, !dbg !85

for.body13:                                       ; preds = %for.cond11
  %50 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16453, i64 %50, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  store i32 0, i32* %j, align 4, !dbg !86
  br label %for.cond14, !dbg !88

for.cond14:                                       ; preds = %for.inc21, %for.body13
  call void @__dp_loop_entry(i32 16453, i32 3)
  %51 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16453, i64 %51, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  %52 = load i32, i32* %j, align 4, !dbg !89
  %53 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16453, i64 %53, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i32 0, i32 0))
  %54 = load i32, i32* %len, align 4, !dbg !91
  %cmp15 = icmp slt i32 %52, %54, !dbg !92
  br i1 %cmp15, label %for.body16, label %for.end23, !dbg !93

for.body16:                                       ; preds = %for.cond14
  %55 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16455, i64 %55, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  %56 = load i32, i32* %i, align 4, !dbg !94
  %idxprom17 = sext i32 %56 to i64, !dbg !96
  %57 = mul nsw i64 %idxprom17, %17, !dbg !96
  %arrayidx18 = getelementptr inbounds float, float* %vla, i64 %57, !dbg !96
  %58 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16455, i64 %58, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  %59 = load i32, i32* %j, align 4, !dbg !97
  %idxprom19 = sext i32 %59 to i64, !dbg !96
  %arrayidx20 = getelementptr inbounds float, float* %arrayidx18, i64 %idxprom19, !dbg !96
  %60 = ptrtoint float* %arrayidx20 to i64
  call void @__dp_read(i32 16455, i64 %60, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.11, i32 0, i32 0))
  %61 = load float, float* %arrayidx20, align 4, !dbg !96
  %62 = ptrtoint float* %temp to i64
  call void @__dp_write(i32 16455, i64 %62, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.12, i32 0, i32 0))
  store float %61, float* %temp, align 4, !dbg !98
  %63 = ptrtoint float* %sum to i64
  call void @__dp_read(i32 16456, i64 %63, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  %64 = load float, float* %sum, align 4, !dbg !99
  %65 = ptrtoint float* %temp to i64
  call void @__dp_read(i32 16456, i64 %65, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.12, i32 0, i32 0))
  %66 = load float, float* %temp, align 4, !dbg !100
  %67 = ptrtoint float* %temp to i64
  call void @__dp_read(i32 16456, i64 %67, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.12, i32 0, i32 0))
  %68 = load float, float* %temp, align 4, !dbg !101
  %mul = fmul float %66, %68, !dbg !102
  %add = fadd float %64, %mul, !dbg !103
  %69 = ptrtoint float* %sum to i64
  call void @__dp_write(i32 16456, i64 %69, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  store float %add, float* %sum, align 4, !dbg !104
  br label %for.inc21, !dbg !105

for.inc21:                                        ; preds = %for.body16
  %70 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16453, i64 %70, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  %71 = load i32, i32* %j, align 4, !dbg !106
  %inc22 = add nsw i32 %71, 1, !dbg !106
  %72 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16453, i64 %72, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  store i32 %inc22, i32* %j, align 4, !dbg !106
  br label %for.cond14, !dbg !107, !llvm.loop !108

for.end23:                                        ; preds = %for.cond14
  call void @__dp_loop_exit(i32 16457, i32 3)
  br label %for.inc24, !dbg !109

for.inc24:                                        ; preds = %for.end23
  %73 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16452, i64 %73, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  %74 = load i32, i32* %i, align 4, !dbg !110
  %inc25 = add nsw i32 %74, 1, !dbg !110
  %75 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16452, i64 %75, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  store i32 %inc25, i32* %i, align 4, !dbg !110
  br label %for.cond11, !dbg !111, !llvm.loop !112

for.end26:                                        ; preds = %for.cond11
  call void @__dp_loop_exit(i32 16458, i32 2)
  %76 = ptrtoint float* %sum to i64
  call void @__dp_read(i32 16458, i64 %76, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  %77 = load float, float* %sum, align 4, !dbg !114
  %conv = fpext float %77 to double, !dbg !114
  call void @__dp_call(i32 16458), !dbg !115
  %call27 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), double %conv), !dbg !115
  %78 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16459, i64 %78, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %retval, align 4, !dbg !116
  %79 = ptrtoint i8** %saved_stack to i64
  call void @__dp_read(i32 16460, i64 %79, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.6, i32 0, i32 0))
  %80 = load i8*, i8** %saved_stack, align 8, !dbg !117
  call void @__dp_call(i32 16460), !dbg !117
  call void @llvm.stackrestore(i8* %80), !dbg !117
  %81 = ptrtoint i32* %retval to i64
  call void @__dp_read(i32 16460, i64 %81, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  %82 = load i32, i32* %retval, align 4, !dbg !117
  call void @__dp_finalize(i32 16460), !dbg !117
  ret i32 %82, !dbg !117
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_call(i32)

; Function Attrs: nounwind readonly
declare dso_local i32 @atoi(i8*) #2

; Function Attrs: nounwind
declare i8* @llvm.stacksave() #3

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_loop_exit(i32, i32)

declare dso_local i32 @printf(i8*, ...) #4

; Function Attrs: nounwind
declare void @llvm.stackrestore(i8*) #3

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }
attributes #4 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind readonly }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!3}
!llvm.module.flags = !{!4, !5, !6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/022")
!2 = !{}
!3 = !{!"Ubuntu clang version 11.1.0-6"}
!4 = !{i32 7, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 55, type: !8, scopeLine: 56, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10, !10, !11}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!13 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!14 = !DILocalVariable(name: "argc", arg: 1, scope: !7, file: !1, line: 55, type: !10)
!15 = !DILocation(line: 55, column: 14, scope: !7)
!16 = !DILocalVariable(name: "argv", arg: 2, scope: !7, file: !1, line: 55, type: !11)
!17 = !DILocation(line: 55, column: 26, scope: !7)
!18 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 57, type: !10)
!19 = !DILocation(line: 57, column: 7, scope: !7)
!20 = !DILocalVariable(name: "j", scope: !7, file: !1, line: 57, type: !10)
!21 = !DILocation(line: 57, column: 9, scope: !7)
!22 = !DILocalVariable(name: "temp", scope: !7, file: !1, line: 58, type: !23)
!23 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!24 = !DILocation(line: 58, column: 9, scope: !7)
!25 = !DILocalVariable(name: "sum", scope: !7, file: !1, line: 58, type: !23)
!26 = !DILocation(line: 58, column: 15, scope: !7)
!27 = !DILocalVariable(name: "len", scope: !7, file: !1, line: 59, type: !10)
!28 = !DILocation(line: 59, column: 7, scope: !7)
!29 = !DILocation(line: 60, column: 7, scope: !30)
!30 = distinct !DILexicalBlock(scope: !7, file: !1, line: 60, column: 7)
!31 = !DILocation(line: 60, column: 11, scope: !30)
!32 = !DILocation(line: 60, column: 7, scope: !7)
!33 = !DILocation(line: 61, column: 16, scope: !30)
!34 = !DILocation(line: 61, column: 11, scope: !30)
!35 = !DILocation(line: 61, column: 9, scope: !30)
!36 = !DILocation(line: 61, column: 5, scope: !30)
!37 = !DILocation(line: 62, column: 11, scope: !7)
!38 = !DILocation(line: 62, column: 3, scope: !7)
!39 = !DILocation(line: 62, column: 16, scope: !7)
!40 = !DILocalVariable(name: "__vla_expr0", scope: !7, type: !41, flags: DIFlagArtificial)
!41 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!42 = !DILocation(line: 0, scope: !7)
!43 = !DILocalVariable(name: "__vla_expr1", scope: !7, type: !41, flags: DIFlagArtificial)
!44 = !DILocalVariable(name: "u", scope: !7, file: !1, line: 62, type: !45)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, elements: !46)
!46 = !{!47, !48}
!47 = !DISubrange(count: !40)
!48 = !DISubrange(count: !43)
!49 = !DILocation(line: 62, column: 9, scope: !7)
!50 = !DILocation(line: 63, column: 10, scope: !51)
!51 = distinct !DILexicalBlock(scope: !7, file: !1, line: 63, column: 3)
!52 = !DILocation(line: 63, column: 8, scope: !51)
!53 = !DILocation(line: 63, column: 15, scope: !54)
!54 = distinct !DILexicalBlock(scope: !51, file: !1, line: 63, column: 3)
!55 = !DILocation(line: 63, column: 19, scope: !54)
!56 = !DILocation(line: 63, column: 17, scope: !54)
!57 = !DILocation(line: 63, column: 3, scope: !51)
!58 = !DILocation(line: 64, column: 12, scope: !59)
!59 = distinct !DILexicalBlock(scope: !54, file: !1, line: 64, column: 5)
!60 = !DILocation(line: 64, column: 10, scope: !59)
!61 = !DILocation(line: 64, column: 17, scope: !62)
!62 = distinct !DILexicalBlock(scope: !59, file: !1, line: 64, column: 5)
!63 = !DILocation(line: 64, column: 21, scope: !62)
!64 = !DILocation(line: 64, column: 19, scope: !62)
!65 = !DILocation(line: 64, column: 5, scope: !59)
!66 = !DILocation(line: 65, column: 11, scope: !62)
!67 = !DILocation(line: 65, column: 9, scope: !62)
!68 = !DILocation(line: 65, column: 14, scope: !62)
!69 = !DILocation(line: 65, column: 17, scope: !62)
!70 = !DILocation(line: 64, column: 27, scope: !62)
!71 = !DILocation(line: 64, column: 5, scope: !62)
!72 = distinct !{!72, !65, !73}
!73 = !DILocation(line: 65, column: 19, scope: !59)
!74 = !DILocation(line: 63, column: 25, scope: !54)
!75 = !DILocation(line: 63, column: 3, scope: !54)
!76 = distinct !{!76, !57, !77}
!77 = !DILocation(line: 65, column: 19, scope: !51)
!78 = !DILocation(line: 68, column: 10, scope: !79)
!79 = distinct !DILexicalBlock(scope: !7, file: !1, line: 68, column: 3)
!80 = !DILocation(line: 68, column: 8, scope: !79)
!81 = !DILocation(line: 68, column: 15, scope: !82)
!82 = distinct !DILexicalBlock(scope: !79, file: !1, line: 68, column: 3)
!83 = !DILocation(line: 68, column: 19, scope: !82)
!84 = !DILocation(line: 68, column: 17, scope: !82)
!85 = !DILocation(line: 68, column: 3, scope: !79)
!86 = !DILocation(line: 69, column: 12, scope: !87)
!87 = distinct !DILexicalBlock(scope: !82, file: !1, line: 69, column: 5)
!88 = !DILocation(line: 69, column: 10, scope: !87)
!89 = !DILocation(line: 69, column: 17, scope: !90)
!90 = distinct !DILexicalBlock(scope: !87, file: !1, line: 69, column: 5)
!91 = !DILocation(line: 69, column: 21, scope: !90)
!92 = !DILocation(line: 69, column: 19, scope: !90)
!93 = !DILocation(line: 69, column: 5, scope: !87)
!94 = !DILocation(line: 71, column: 16, scope: !95)
!95 = distinct !DILexicalBlock(scope: !90, file: !1, line: 70, column: 5)
!96 = !DILocation(line: 71, column: 14, scope: !95)
!97 = !DILocation(line: 71, column: 19, scope: !95)
!98 = !DILocation(line: 71, column: 12, scope: !95)
!99 = !DILocation(line: 72, column: 13, scope: !95)
!100 = !DILocation(line: 72, column: 19, scope: !95)
!101 = !DILocation(line: 72, column: 26, scope: !95)
!102 = !DILocation(line: 72, column: 24, scope: !95)
!103 = !DILocation(line: 72, column: 17, scope: !95)
!104 = !DILocation(line: 72, column: 11, scope: !95)
!105 = !DILocation(line: 73, column: 5, scope: !95)
!106 = !DILocation(line: 69, column: 27, scope: !90)
!107 = !DILocation(line: 69, column: 5, scope: !90)
!108 = distinct !{!108, !93, !109}
!109 = !DILocation(line: 73, column: 5, scope: !87)
!110 = !DILocation(line: 68, column: 25, scope: !82)
!111 = !DILocation(line: 68, column: 3, scope: !82)
!112 = distinct !{!112, !85, !113}
!113 = !DILocation(line: 73, column: 5, scope: !79)
!114 = !DILocation(line: 74, column: 25, scope: !7)
!115 = !DILocation(line: 74, column: 3, scope: !7)
!116 = !DILocation(line: 75, column: 3, scope: !7)
!117 = !DILocation(line: 76, column: 1, scope: !7)
