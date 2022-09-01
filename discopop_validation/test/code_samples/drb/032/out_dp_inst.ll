; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"argc\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"argv\00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c"len\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"n\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"m\00", align 1
@.str.6 = private unnamed_addr constant [12 x i8] c"saved_stack\00", align 1
@.str.7 = private unnamed_addr constant [12 x i8] c"__vla_expr0\00", align 1
@.str.8 = private unnamed_addr constant [12 x i8] c"__vla_expr1\00", align 1
@.str.9 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.10 = private unnamed_addr constant [2 x i8] c"j\00", align 1
@.str.11 = private unnamed_addr constant [2 x i8] c"b\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16436, i32 1)
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %len = alloca i32, align 4
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %saved_stack = alloca i8*, align 8
  %__vla_expr0 = alloca i64, align 8
  %__vla_expr1 = alloca i64, align 8
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
  call void @llvm.dbg.declare(metadata i32* %len, metadata !22, metadata !DIExpression()), !dbg !23
  %3 = ptrtoint i32* %len to i64
  call void @__dp_write(i32 16439, i64 %3, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  store i32 1000, i32* %len, align 4, !dbg !23
  %4 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 16440, i64 %4, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i32 0, i32 0))
  %5 = load i32, i32* %argc.addr, align 4, !dbg !24
  %cmp = icmp sgt i32 %5, 1, !dbg !26
  br i1 %cmp, label %if.then, label %if.end, !dbg !27

if.then:                                          ; preds = %entry
  %6 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 16441, i64 %6, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i32 0, i32 0))
  %7 = load i8**, i8*** %argv.addr, align 8, !dbg !28
  %arrayidx = getelementptr inbounds i8*, i8** %7, i64 1, !dbg !28
  %8 = ptrtoint i8** %arrayidx to i64
  call void @__dp_read(i32 16441, i64 %8, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i32 0, i32 0))
  %9 = load i8*, i8** %arrayidx, align 8, !dbg !28
  call void @__dp_call(i32 16441), !dbg !29
  %call = call i32 @atoi(i8* %9) #4, !dbg !29
  %10 = ptrtoint i32* %len to i64
  call void @__dp_write(i32 16441, i64 %10, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  store i32 %call, i32* %len, align 4, !dbg !30
  br label %if.end, !dbg !31

if.end:                                           ; preds = %if.then, %entry
  call void @llvm.dbg.declare(metadata i32* %n, metadata !32, metadata !DIExpression()), !dbg !33
  %11 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16443, i64 %11, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  %12 = load i32, i32* %len, align 4, !dbg !34
  %13 = ptrtoint i32* %n to i64
  call void @__dp_write(i32 16443, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 %12, i32* %n, align 4, !dbg !33
  call void @llvm.dbg.declare(metadata i32* %m, metadata !35, metadata !DIExpression()), !dbg !36
  %14 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16443, i64 %14, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  %15 = load i32, i32* %len, align 4, !dbg !37
  %16 = ptrtoint i32* %m to i64
  call void @__dp_write(i32 16443, i64 %16, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 %15, i32* %m, align 4, !dbg !36
  %17 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16444, i64 %17, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  %18 = load i32, i32* %len, align 4, !dbg !38
  %19 = zext i32 %18 to i64, !dbg !39
  %20 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16444, i64 %20, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  %21 = load i32, i32* %len, align 4, !dbg !40
  %22 = zext i32 %21 to i64, !dbg !39
  call void @__dp_call(i32 16444), !dbg !39
  %23 = call i8* @llvm.stacksave(), !dbg !39
  %24 = ptrtoint i8** %saved_stack to i64
  call void @__dp_write(i32 16444, i64 %24, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.6, i32 0, i32 0))
  store i8* %23, i8** %saved_stack, align 8, !dbg !39
  %25 = mul nuw i64 %19, %22, !dbg !39
  %vla = alloca double, i64 %25, align 16, !dbg !39
  %26 = ptrtoint i64* %__vla_expr0 to i64
  call void @__dp_write(i32 16444, i64 %26, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.7, i32 0, i32 0))
  store i64 %19, i64* %__vla_expr0, align 8, !dbg !39
  %27 = ptrtoint i64* %__vla_expr1 to i64
  call void @__dp_write(i32 16444, i64 %27, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.8, i32 0, i32 0))
  store i64 %22, i64* %__vla_expr1, align 8, !dbg !39
  call void @llvm.dbg.declare(metadata i64* %__vla_expr0, metadata !41, metadata !DIExpression()), !dbg !43
  call void @llvm.dbg.declare(metadata i64* %__vla_expr1, metadata !44, metadata !DIExpression()), !dbg !43
  call void @llvm.dbg.declare(metadata double* %vla, metadata !45, metadata !DIExpression()), !dbg !51
  %28 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16446, i64 %28, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !52
  br label %for.cond, !dbg !54

for.cond:                                         ; preds = %for.inc8, %if.end
  call void @__dp_loop_entry(i32 16446, i32 0)
  %29 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16446, i64 %29, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  %30 = load i32, i32* %i, align 4, !dbg !55
  %31 = ptrtoint i32* %n to i64
  call void @__dp_read(i32 16446, i64 %31, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %32 = load i32, i32* %n, align 4, !dbg !57
  %cmp1 = icmp slt i32 %30, %32, !dbg !58
  br i1 %cmp1, label %for.body, label %for.end10, !dbg !59

for.body:                                         ; preds = %for.cond
  %33 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16447, i64 %33, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  store i32 0, i32* %j, align 4, !dbg !60
  br label %for.cond2, !dbg !62

for.cond2:                                        ; preds = %for.inc, %for.body
  call void @__dp_loop_entry(i32 16447, i32 1)
  %34 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16447, i64 %34, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  %35 = load i32, i32* %j, align 4, !dbg !63
  %36 = ptrtoint i32* %m to i64
  call void @__dp_read(i32 16447, i64 %36, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %37 = load i32, i32* %m, align 4, !dbg !65
  %cmp3 = icmp slt i32 %35, %37, !dbg !66
  br i1 %cmp3, label %for.body4, label %for.end, !dbg !67

for.body4:                                        ; preds = %for.cond2
  %38 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16448, i64 %38, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  %39 = load i32, i32* %i, align 4, !dbg !68
  %idxprom = sext i32 %39 to i64, !dbg !69
  %40 = mul nsw i64 %idxprom, %22, !dbg !69
  %arrayidx5 = getelementptr inbounds double, double* %vla, i64 %40, !dbg !69
  %41 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16448, i64 %41, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  %42 = load i32, i32* %j, align 4, !dbg !70
  %idxprom6 = sext i32 %42 to i64, !dbg !69
  %arrayidx7 = getelementptr inbounds double, double* %arrayidx5, i64 %idxprom6, !dbg !69
  %43 = ptrtoint double* %arrayidx7 to i64
  call void @__dp_write(i32 16448, i64 %43, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.11, i32 0, i32 0))
  store double 5.000000e-01, double* %arrayidx7, align 8, !dbg !71
  br label %for.inc, !dbg !69

for.inc:                                          ; preds = %for.body4
  %44 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16447, i64 %44, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  %45 = load i32, i32* %j, align 4, !dbg !72
  %inc = add nsw i32 %45, 1, !dbg !72
  %46 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16447, i64 %46, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  store i32 %inc, i32* %j, align 4, !dbg !72
  br label %for.cond2, !dbg !73, !llvm.loop !74

for.end:                                          ; preds = %for.cond2
  call void @__dp_loop_exit(i32 16448, i32 1)
  br label %for.inc8, !dbg !75

for.inc8:                                         ; preds = %for.end
  %47 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16446, i64 %47, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  %48 = load i32, i32* %i, align 4, !dbg !76
  %inc9 = add nsw i32 %48, 1, !dbg !76
  %49 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16446, i64 %49, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  store i32 %inc9, i32* %i, align 4, !dbg !76
  br label %for.cond, !dbg !77, !llvm.loop !78

for.end10:                                        ; preds = %for.cond
  call void @__dp_loop_exit(i32 16451, i32 0)
  %50 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16451, i64 %50, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  store i32 1, i32* %i, align 4, !dbg !80
  br label %for.cond11, !dbg !82

for.cond11:                                       ; preds = %for.inc29, %for.end10
  call void @__dp_loop_entry(i32 16451, i32 2)
  %51 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16451, i64 %51, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  %52 = load i32, i32* %i, align 4, !dbg !83
  %53 = ptrtoint i32* %n to i64
  call void @__dp_read(i32 16451, i64 %53, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %54 = load i32, i32* %n, align 4, !dbg !85
  %cmp12 = icmp slt i32 %52, %54, !dbg !86
  br i1 %cmp12, label %for.body13, label %for.end31, !dbg !87

for.body13:                                       ; preds = %for.cond11
  %55 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16452, i64 %55, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  store i32 1, i32* %j, align 4, !dbg !88
  br label %for.cond14, !dbg !90

for.cond14:                                       ; preds = %for.inc26, %for.body13
  call void @__dp_loop_entry(i32 16452, i32 3)
  %56 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16452, i64 %56, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  %57 = load i32, i32* %j, align 4, !dbg !91
  %58 = ptrtoint i32* %m to i64
  call void @__dp_read(i32 16452, i64 %58, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %59 = load i32, i32* %m, align 4, !dbg !93
  %cmp15 = icmp slt i32 %57, %59, !dbg !94
  br i1 %cmp15, label %for.body16, label %for.end28, !dbg !95

for.body16:                                       ; preds = %for.cond14
  %60 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16453, i64 %60, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  %61 = load i32, i32* %i, align 4, !dbg !96
  %sub = sub nsw i32 %61, 1, !dbg !97
  %idxprom17 = sext i32 %sub to i64, !dbg !98
  %62 = mul nsw i64 %idxprom17, %22, !dbg !98
  %arrayidx18 = getelementptr inbounds double, double* %vla, i64 %62, !dbg !98
  %63 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16453, i64 %63, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  %64 = load i32, i32* %j, align 4, !dbg !99
  %sub19 = sub nsw i32 %64, 1, !dbg !100
  %idxprom20 = sext i32 %sub19 to i64, !dbg !98
  %arrayidx21 = getelementptr inbounds double, double* %arrayidx18, i64 %idxprom20, !dbg !98
  %65 = ptrtoint double* %arrayidx21 to i64
  call void @__dp_read(i32 16453, i64 %65, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.11, i32 0, i32 0))
  %66 = load double, double* %arrayidx21, align 8, !dbg !98
  %67 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16453, i64 %67, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  %68 = load i32, i32* %i, align 4, !dbg !101
  %idxprom22 = sext i32 %68 to i64, !dbg !102
  %69 = mul nsw i64 %idxprom22, %22, !dbg !102
  %arrayidx23 = getelementptr inbounds double, double* %vla, i64 %69, !dbg !102
  %70 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16453, i64 %70, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  %71 = load i32, i32* %j, align 4, !dbg !103
  %idxprom24 = sext i32 %71 to i64, !dbg !102
  %arrayidx25 = getelementptr inbounds double, double* %arrayidx23, i64 %idxprom24, !dbg !102
  %72 = ptrtoint double* %arrayidx25 to i64
  call void @__dp_write(i32 16453, i64 %72, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.11, i32 0, i32 0))
  store double %66, double* %arrayidx25, align 8, !dbg !104
  br label %for.inc26, !dbg !102

for.inc26:                                        ; preds = %for.body16
  %73 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16452, i64 %73, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  %74 = load i32, i32* %j, align 4, !dbg !105
  %inc27 = add nsw i32 %74, 1, !dbg !105
  %75 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16452, i64 %75, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  store i32 %inc27, i32* %j, align 4, !dbg !105
  br label %for.cond14, !dbg !106, !llvm.loop !107

for.end28:                                        ; preds = %for.cond14
  call void @__dp_loop_exit(i32 16453, i32 3)
  br label %for.inc29, !dbg !108

for.inc29:                                        ; preds = %for.end28
  %76 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16451, i64 %76, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  %77 = load i32, i32* %i, align 4, !dbg !109
  %inc30 = add nsw i32 %77, 1, !dbg !109
  %78 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16451, i64 %78, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  store i32 %inc30, i32* %i, align 4, !dbg !109
  br label %for.cond11, !dbg !110, !llvm.loop !111

for.end31:                                        ; preds = %for.cond11
  call void @__dp_loop_exit(i32 16455, i32 2)
  %79 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16455, i64 %79, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  store i32 0, i32* %retval, align 4, !dbg !113
  %80 = ptrtoint i8** %saved_stack to i64
  call void @__dp_read(i32 16456, i64 %80, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.6, i32 0, i32 0))
  %81 = load i8*, i8** %saved_stack, align 8, !dbg !114
  call void @__dp_call(i32 16456), !dbg !114
  call void @llvm.stackrestore(i8* %81), !dbg !114
  %82 = ptrtoint i32* %retval to i64
  call void @__dp_read(i32 16456, i64 %82, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  %83 = load i32, i32* %retval, align 4, !dbg !114
  call void @__dp_finalize(i32 16456), !dbg !114
  ret i32 %83, !dbg !114
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

; Function Attrs: nounwind
declare void @llvm.stackrestore(i8*) #3

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }
attributes #4 = { nounwind readonly }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!3}
!llvm.module.flags = !{!4, !5, !6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/032")
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
!17 = !DILocation(line: 52, column: 26, scope: !7)
!18 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 54, type: !10)
!19 = !DILocation(line: 54, column: 7, scope: !7)
!20 = !DILocalVariable(name: "j", scope: !7, file: !1, line: 54, type: !10)
!21 = !DILocation(line: 54, column: 9, scope: !7)
!22 = !DILocalVariable(name: "len", scope: !7, file: !1, line: 55, type: !10)
!23 = !DILocation(line: 55, column: 7, scope: !7)
!24 = !DILocation(line: 56, column: 7, scope: !25)
!25 = distinct !DILexicalBlock(scope: !7, file: !1, line: 56, column: 7)
!26 = !DILocation(line: 56, column: 11, scope: !25)
!27 = !DILocation(line: 56, column: 7, scope: !7)
!28 = !DILocation(line: 57, column: 16, scope: !25)
!29 = !DILocation(line: 57, column: 11, scope: !25)
!30 = !DILocation(line: 57, column: 9, scope: !25)
!31 = !DILocation(line: 57, column: 5, scope: !25)
!32 = !DILocalVariable(name: "n", scope: !7, file: !1, line: 59, type: !10)
!33 = !DILocation(line: 59, column: 7, scope: !7)
!34 = !DILocation(line: 59, column: 9, scope: !7)
!35 = !DILocalVariable(name: "m", scope: !7, file: !1, line: 59, type: !10)
!36 = !DILocation(line: 59, column: 14, scope: !7)
!37 = !DILocation(line: 59, column: 16, scope: !7)
!38 = !DILocation(line: 60, column: 12, scope: !7)
!39 = !DILocation(line: 60, column: 3, scope: !7)
!40 = !DILocation(line: 60, column: 17, scope: !7)
!41 = !DILocalVariable(name: "__vla_expr0", scope: !7, type: !42, flags: DIFlagArtificial)
!42 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!43 = !DILocation(line: 0, scope: !7)
!44 = !DILocalVariable(name: "__vla_expr1", scope: !7, type: !42, flags: DIFlagArtificial)
!45 = !DILocalVariable(name: "b", scope: !7, file: !1, line: 60, type: !46)
!46 = !DICompositeType(tag: DW_TAG_array_type, baseType: !47, elements: !48)
!47 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!48 = !{!49, !50}
!49 = !DISubrange(count: !41)
!50 = !DISubrange(count: !44)
!51 = !DILocation(line: 60, column: 10, scope: !7)
!52 = !DILocation(line: 62, column: 9, scope: !53)
!53 = distinct !DILexicalBlock(scope: !7, file: !1, line: 62, column: 3)
!54 = !DILocation(line: 62, column: 8, scope: !53)
!55 = !DILocation(line: 62, column: 13, scope: !56)
!56 = distinct !DILexicalBlock(scope: !53, file: !1, line: 62, column: 3)
!57 = !DILocation(line: 62, column: 15, scope: !56)
!58 = !DILocation(line: 62, column: 14, scope: !56)
!59 = !DILocation(line: 62, column: 3, scope: !53)
!60 = !DILocation(line: 63, column: 11, scope: !61)
!61 = distinct !DILexicalBlock(scope: !56, file: !1, line: 63, column: 5)
!62 = !DILocation(line: 63, column: 10, scope: !61)
!63 = !DILocation(line: 63, column: 15, scope: !64)
!64 = distinct !DILexicalBlock(scope: !61, file: !1, line: 63, column: 5)
!65 = !DILocation(line: 63, column: 17, scope: !64)
!66 = !DILocation(line: 63, column: 16, scope: !64)
!67 = !DILocation(line: 63, column: 5, scope: !61)
!68 = !DILocation(line: 64, column: 9, scope: !64)
!69 = !DILocation(line: 64, column: 7, scope: !64)
!70 = !DILocation(line: 64, column: 12, scope: !64)
!71 = !DILocation(line: 64, column: 15, scope: !64)
!72 = !DILocation(line: 63, column: 21, scope: !64)
!73 = !DILocation(line: 63, column: 5, scope: !64)
!74 = distinct !{!74, !67, !75}
!75 = !DILocation(line: 64, column: 17, scope: !61)
!76 = !DILocation(line: 62, column: 19, scope: !56)
!77 = !DILocation(line: 62, column: 3, scope: !56)
!78 = distinct !{!78, !59, !79}
!79 = !DILocation(line: 64, column: 17, scope: !53)
!80 = !DILocation(line: 67, column: 9, scope: !81)
!81 = distinct !DILexicalBlock(scope: !7, file: !1, line: 67, column: 3)
!82 = !DILocation(line: 67, column: 8, scope: !81)
!83 = !DILocation(line: 67, column: 12, scope: !84)
!84 = distinct !DILexicalBlock(scope: !81, file: !1, line: 67, column: 3)
!85 = !DILocation(line: 67, column: 14, scope: !84)
!86 = !DILocation(line: 67, column: 13, scope: !84)
!87 = !DILocation(line: 67, column: 3, scope: !81)
!88 = !DILocation(line: 68, column: 11, scope: !89)
!89 = distinct !DILexicalBlock(scope: !84, file: !1, line: 68, column: 5)
!90 = !DILocation(line: 68, column: 10, scope: !89)
!91 = !DILocation(line: 68, column: 14, scope: !92)
!92 = distinct !DILexicalBlock(scope: !89, file: !1, line: 68, column: 5)
!93 = !DILocation(line: 68, column: 16, scope: !92)
!94 = !DILocation(line: 68, column: 15, scope: !92)
!95 = !DILocation(line: 68, column: 5, scope: !89)
!96 = !DILocation(line: 69, column: 17, scope: !92)
!97 = !DILocation(line: 69, column: 18, scope: !92)
!98 = !DILocation(line: 69, column: 15, scope: !92)
!99 = !DILocation(line: 69, column: 22, scope: !92)
!100 = !DILocation(line: 69, column: 23, scope: !92)
!101 = !DILocation(line: 69, column: 9, scope: !92)
!102 = !DILocation(line: 69, column: 7, scope: !92)
!103 = !DILocation(line: 69, column: 12, scope: !92)
!104 = !DILocation(line: 69, column: 14, scope: !92)
!105 = !DILocation(line: 68, column: 19, scope: !92)
!106 = !DILocation(line: 68, column: 5, scope: !92)
!107 = distinct !{!107, !95, !108}
!108 = !DILocation(line: 69, column: 25, scope: !89)
!109 = !DILocation(line: 67, column: 17, scope: !84)
!110 = !DILocation(line: 67, column: 3, scope: !84)
!111 = distinct !{!111, !87, !112}
!112 = !DILocation(line: 69, column: 25, scope: !81)
!113 = !DILocation(line: 71, column: 3, scope: !7)
!114 = !DILocation(line: 72, column: 1, scope: !7)
