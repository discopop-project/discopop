; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@a = dso_local global i32* null, align 8, !dbg !0
@b = dso_local global i32* null, align 8, !dbg !6
@c = dso_local global i32* null, align 8, !dbg !10
@.str.1 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"c\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"j\00", align 1
@.str = private unnamed_addr constant [11 x i8] c"Data Race\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !16 {
entry:
  call void @__dp_func_entry(i32 16407, i32 1)
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %i13 = alloca i32, align 4
  %j17 = alloca i32, align 4
  %i37 = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16407, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @__dp_call(i32 16408), !dbg !19
  %call = call noalias i8* @malloc(i64 400) #4, !dbg !19
  %1 = bitcast i8* %call to i32*, !dbg !19
  %2 = ptrtoint i32** @a to i64
  call void @__dp_write(i32 16408, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32* %1, i32** @a, align 8, !dbg !20
  call void @__dp_call(i32 16409), !dbg !21
  %call1 = call noalias i8* @malloc(i64 40000) #4, !dbg !21
  %3 = bitcast i8* %call1 to i32*, !dbg !21
  %4 = ptrtoint i32** @b to i64
  call void @__dp_write(i32 16409, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32* %3, i32** @b, align 8, !dbg !22
  call void @__dp_call(i32 16410), !dbg !23
  %call2 = call noalias i8* @malloc(i64 400) #4, !dbg !23
  %5 = bitcast i8* %call2 to i32*, !dbg !23
  %6 = ptrtoint i32** @c to i64
  call void @__dp_write(i32 16410, i64 %6, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32* %5, i32** @c, align 8, !dbg !24
  call void @llvm.dbg.declare(metadata i32* %i, metadata !25, metadata !DIExpression()), !dbg !27
  %7 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16412, i64 %7, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !27
  br label %for.cond, !dbg !28

for.cond:                                         ; preds = %for.inc10, %entry
  call void @__dp_loop_entry(i32 16412, i32 0)
  %8 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16412, i64 %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %9 = load i32, i32* %i, align 4, !dbg !29
  %cmp = icmp slt i32 %9, 100, !dbg !31
  br i1 %cmp, label %for.body, label %for.end12, !dbg !32

for.body:                                         ; preds = %for.cond
  call void @llvm.dbg.declare(metadata i32* %j, metadata !33, metadata !DIExpression()), !dbg !36
  %10 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16413, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 0, i32* %j, align 4, !dbg !36
  br label %for.cond3, !dbg !37

for.cond3:                                        ; preds = %for.inc, %for.body
  call void @__dp_loop_entry(i32 16413, i32 1)
  %11 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16413, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %12 = load i32, i32* %j, align 4, !dbg !38
  %cmp4 = icmp slt i32 %12, 100, !dbg !40
  br i1 %cmp4, label %for.body5, label %for.end, !dbg !41

for.body5:                                        ; preds = %for.cond3
  %13 = ptrtoint i32** @b to i64
  call void @__dp_read(i32 16414, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %14 = load i32*, i32** @b, align 8, !dbg !42
  %15 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16414, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %16 = load i32, i32* %j, align 4, !dbg !44
  %17 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16414, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %18 = load i32, i32* %i, align 4, !dbg !45
  %mul = mul nsw i32 %18, 100, !dbg !46
  %add = add nsw i32 %16, %mul, !dbg !47
  %idxprom = sext i32 %add to i64, !dbg !42
  %arrayidx = getelementptr inbounds i32, i32* %14, i64 %idxprom, !dbg !42
  %19 = ptrtoint i32* %arrayidx to i64
  call void @__dp_write(i32 16414, i64 %19, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 1, i32* %arrayidx, align 4, !dbg !48
  br label %for.inc, !dbg !49

for.inc:                                          ; preds = %for.body5
  %20 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16413, i64 %20, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %21 = load i32, i32* %j, align 4, !dbg !50
  %inc = add nsw i32 %21, 1, !dbg !50
  %22 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16413, i64 %22, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 %inc, i32* %j, align 4, !dbg !50
  br label %for.cond3, !dbg !51, !llvm.loop !52

for.end:                                          ; preds = %for.cond3
  call void @__dp_loop_exit(i32 16416, i32 1)
  %23 = ptrtoint i32** @a to i64
  call void @__dp_read(i32 16416, i64 %23, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %24 = load i32*, i32** @a, align 8, !dbg !54
  %25 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16416, i64 %25, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %26 = load i32, i32* %i, align 4, !dbg !55
  %idxprom6 = sext i32 %26 to i64, !dbg !54
  %arrayidx7 = getelementptr inbounds i32, i32* %24, i64 %idxprom6, !dbg !54
  %27 = ptrtoint i32* %arrayidx7 to i64
  call void @__dp_write(i32 16416, i64 %27, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 1, i32* %arrayidx7, align 4, !dbg !56
  %28 = ptrtoint i32** @c to i64
  call void @__dp_read(i32 16417, i64 %28, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %29 = load i32*, i32** @c, align 8, !dbg !57
  %30 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16417, i64 %30, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %31 = load i32, i32* %i, align 4, !dbg !58
  %idxprom8 = sext i32 %31 to i64, !dbg !57
  %arrayidx9 = getelementptr inbounds i32, i32* %29, i64 %idxprom8, !dbg !57
  %32 = ptrtoint i32* %arrayidx9 to i64
  call void @__dp_write(i32 16417, i64 %32, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 0, i32* %arrayidx9, align 4, !dbg !59
  br label %for.inc10, !dbg !60

for.inc10:                                        ; preds = %for.end
  %33 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16412, i64 %33, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %34 = load i32, i32* %i, align 4, !dbg !61
  %inc11 = add nsw i32 %34, 1, !dbg !61
  %35 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16412, i64 %35, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 %inc11, i32* %i, align 4, !dbg !61
  br label %for.cond, !dbg !62, !llvm.loop !63

for.end12:                                        ; preds = %for.cond
  call void @__dp_loop_exit(i32 16423, i32 0)
  call void @llvm.dbg.declare(metadata i32* %i13, metadata !65, metadata !DIExpression()), !dbg !68
  %36 = ptrtoint i32* %i13 to i64
  call void @__dp_write(i32 16423, i64 %36, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 0, i32* %i13, align 4, !dbg !68
  br label %for.cond14, !dbg !69

for.cond14:                                       ; preds = %for.inc34, %for.end12
  call void @__dp_loop_entry(i32 16423, i32 2)
  %37 = ptrtoint i32* %i13 to i64
  call void @__dp_read(i32 16423, i64 %37, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %38 = load i32, i32* %i13, align 4, !dbg !70
  %cmp15 = icmp slt i32 %38, 100, !dbg !72
  br i1 %cmp15, label %for.body16, label %for.end36, !dbg !73

for.body16:                                       ; preds = %for.cond14
  call void @llvm.dbg.declare(metadata i32* %j17, metadata !74, metadata !DIExpression()), !dbg !77
  %39 = ptrtoint i32* %j17 to i64
  call void @__dp_write(i32 16424, i64 %39, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 0, i32* %j17, align 4, !dbg !77
  br label %for.cond18, !dbg !78

for.cond18:                                       ; preds = %for.inc31, %for.body16
  call void @__dp_loop_entry(i32 16424, i32 3)
  %40 = ptrtoint i32* %j17 to i64
  call void @__dp_read(i32 16424, i64 %40, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %41 = load i32, i32* %j17, align 4, !dbg !79
  %cmp19 = icmp slt i32 %41, 100, !dbg !81
  br i1 %cmp19, label %for.body20, label %for.end33, !dbg !82

for.body20:                                       ; preds = %for.cond18
  %42 = ptrtoint i32** @b to i64
  call void @__dp_read(i32 16425, i64 %42, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %43 = load i32*, i32** @b, align 8, !dbg !83
  %44 = ptrtoint i32* %j17 to i64
  call void @__dp_read(i32 16425, i64 %44, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %45 = load i32, i32* %j17, align 4, !dbg !85
  %46 = ptrtoint i32* %i13 to i64
  call void @__dp_read(i32 16425, i64 %46, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %47 = load i32, i32* %i13, align 4, !dbg !86
  %mul21 = mul nsw i32 %47, 100, !dbg !87
  %add22 = add nsw i32 %45, %mul21, !dbg !88
  %idxprom23 = sext i32 %add22 to i64, !dbg !83
  %arrayidx24 = getelementptr inbounds i32, i32* %43, i64 %idxprom23, !dbg !83
  %48 = ptrtoint i32* %arrayidx24 to i64
  call void @__dp_read(i32 16425, i64 %48, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %49 = load i32, i32* %arrayidx24, align 4, !dbg !83
  %50 = ptrtoint i32** @a to i64
  call void @__dp_read(i32 16425, i64 %50, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %51 = load i32*, i32** @a, align 8, !dbg !89
  %52 = ptrtoint i32* %j17 to i64
  call void @__dp_read(i32 16425, i64 %52, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %53 = load i32, i32* %j17, align 4, !dbg !90
  %idxprom25 = sext i32 %53 to i64, !dbg !89
  %arrayidx26 = getelementptr inbounds i32, i32* %51, i64 %idxprom25, !dbg !89
  %54 = ptrtoint i32* %arrayidx26 to i64
  call void @__dp_read(i32 16425, i64 %54, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %55 = load i32, i32* %arrayidx26, align 4, !dbg !89
  %mul27 = mul nsw i32 %49, %55, !dbg !91
  %56 = ptrtoint i32** @c to i64
  call void @__dp_read(i32 16425, i64 %56, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %57 = load i32*, i32** @c, align 8, !dbg !92
  %58 = ptrtoint i32* %i13 to i64
  call void @__dp_read(i32 16425, i64 %58, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %59 = load i32, i32* %i13, align 4, !dbg !93
  %idxprom28 = sext i32 %59 to i64, !dbg !92
  %arrayidx29 = getelementptr inbounds i32, i32* %57, i64 %idxprom28, !dbg !92
  %60 = ptrtoint i32* %arrayidx29 to i64
  call void @__dp_read(i32 16425, i64 %60, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %61 = load i32, i32* %arrayidx29, align 4, !dbg !94
  %add30 = add nsw i32 %61, %mul27, !dbg !94
  %62 = ptrtoint i32* %arrayidx29 to i64
  call void @__dp_write(i32 16425, i64 %62, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 %add30, i32* %arrayidx29, align 4, !dbg !94
  br label %for.inc31, !dbg !95

for.inc31:                                        ; preds = %for.body20
  %63 = ptrtoint i32* %j17 to i64
  call void @__dp_read(i32 16424, i64 %63, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %64 = load i32, i32* %j17, align 4, !dbg !96
  %inc32 = add nsw i32 %64, 1, !dbg !96
  %65 = ptrtoint i32* %j17 to i64
  call void @__dp_write(i32 16424, i64 %65, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 %inc32, i32* %j17, align 4, !dbg !96
  br label %for.cond18, !dbg !97, !llvm.loop !98

for.end33:                                        ; preds = %for.cond18
  call void @__dp_loop_exit(i32 16427, i32 3)
  br label %for.inc34, !dbg !100

for.inc34:                                        ; preds = %for.end33
  %66 = ptrtoint i32* %i13 to i64
  call void @__dp_read(i32 16423, i64 %66, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %67 = load i32, i32* %i13, align 4, !dbg !101
  %inc35 = add nsw i32 %67, 1, !dbg !101
  %68 = ptrtoint i32* %i13 to i64
  call void @__dp_write(i32 16423, i64 %68, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 %inc35, i32* %i13, align 4, !dbg !101
  br label %for.cond14, !dbg !102, !llvm.loop !103

for.end36:                                        ; preds = %for.cond14
  call void @__dp_loop_exit(i32 16430, i32 2)
  call void @llvm.dbg.declare(metadata i32* %i37, metadata !105, metadata !DIExpression()), !dbg !107
  %69 = ptrtoint i32* %i37 to i64
  call void @__dp_write(i32 16430, i64 %69, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 0, i32* %i37, align 4, !dbg !107
  br label %for.cond38, !dbg !108

for.cond38:                                       ; preds = %for.inc45, %for.end36
  call void @__dp_loop_entry(i32 16430, i32 4)
  %70 = ptrtoint i32* %i37 to i64
  call void @__dp_read(i32 16430, i64 %70, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %71 = load i32, i32* %i37, align 4, !dbg !109
  %cmp39 = icmp slt i32 %71, 100, !dbg !111
  br i1 %cmp39, label %for.body40, label %for.end47, !dbg !112

for.body40:                                       ; preds = %for.cond38
  %72 = ptrtoint i32** @c to i64
  call void @__dp_read(i32 16431, i64 %72, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %73 = load i32*, i32** @c, align 8, !dbg !113
  %74 = ptrtoint i32* %i37 to i64
  call void @__dp_read(i32 16431, i64 %74, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %75 = load i32, i32* %i37, align 4, !dbg !116
  %idxprom41 = sext i32 %75 to i64, !dbg !113
  %arrayidx42 = getelementptr inbounds i32, i32* %73, i64 %idxprom41, !dbg !113
  %76 = ptrtoint i32* %arrayidx42 to i64
  call void @__dp_read(i32 16431, i64 %76, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %77 = load i32, i32* %arrayidx42, align 4, !dbg !113
  %cmp43 = icmp ne i32 %77, 100, !dbg !117
  br i1 %cmp43, label %if.then, label %if.end, !dbg !118

if.then:                                          ; preds = %for.body40
  call void @__dp_call(i32 16432), !dbg !119
  %call44 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0)), !dbg !119
  %78 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16433, i64 %78, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 1, i32* %retval, align 4, !dbg !121
  br label %return, !dbg !121

if.end:                                           ; preds = %for.body40
  br label %for.inc45, !dbg !122

for.inc45:                                        ; preds = %if.end
  %79 = ptrtoint i32* %i37 to i64
  call void @__dp_read(i32 16430, i64 %79, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %80 = load i32, i32* %i37, align 4, !dbg !123
  %inc46 = add nsw i32 %80, 1, !dbg !123
  %81 = ptrtoint i32* %i37 to i64
  call void @__dp_write(i32 16430, i64 %81, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 %inc46, i32* %i37, align 4, !dbg !123
  br label %for.cond38, !dbg !124, !llvm.loop !125

for.end47:                                        ; preds = %for.cond38
  call void @__dp_loop_exit(i32 16437, i32 4)
  %82 = ptrtoint i32** @a to i64
  call void @__dp_read(i32 16437, i64 %82, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %83 = load i32*, i32** @a, align 8, !dbg !127
  %84 = bitcast i32* %83 to i8*, !dbg !127
  call void @__dp_call(i32 16437), !dbg !128
  call void @free(i8* %84) #4, !dbg !128
  %85 = ptrtoint i32** @b to i64
  call void @__dp_read(i32 16438, i64 %85, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %86 = load i32*, i32** @b, align 8, !dbg !129
  %87 = bitcast i32* %86 to i8*, !dbg !129
  call void @__dp_call(i32 16438), !dbg !130
  call void @free(i8* %87) #4, !dbg !130
  %88 = ptrtoint i32** @c to i64
  call void @__dp_read(i32 16439, i64 %88, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %89 = load i32*, i32** @c, align 8, !dbg !131
  %90 = bitcast i32* %89 to i8*, !dbg !131
  call void @__dp_call(i32 16439), !dbg !132
  call void @free(i8* %90) #4, !dbg !132
  %91 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16441, i64 %91, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %retval, align 4, !dbg !133
  br label %return, !dbg !133

return:                                           ; preds = %for.end47, %if.then
  %92 = ptrtoint i32* %retval to i64
  call void @__dp_read(i32 16442, i64 %92, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  %93 = load i32, i32* %retval, align 4, !dbg !134
  call void @__dp_finalize(i32 16442), !dbg !134
  ret i32 %93, !dbg !134
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

declare void @__dp_call(i32)

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64) #1

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_loop_exit(i32, i32)

declare dso_local i32 @printf(i8*, ...) #3

; Function Attrs: nounwind
declare dso_local void @free(i8*) #1

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind readnone speculatable willreturn }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!12}
!llvm.module.flags = !{!13, !14, !15}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 19, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/149")
!4 = !{}
!5 = !{!0, !6, !10}
!6 = !DIGlobalVariableExpression(var: !7, expr: !DIExpression())
!7 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !3, line: 20, type: !8, isLocal: false, isDefinition: true)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 64)
!9 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!10 = !DIGlobalVariableExpression(var: !11, expr: !DIExpression())
!11 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !3, line: 21, type: !8, isLocal: false, isDefinition: true)
!12 = !{!"Ubuntu clang version 11.1.0-6"}
!13 = !{i32 7, !"Dwarf Version", i32 4}
!14 = !{i32 2, !"Debug Info Version", i32 3}
!15 = !{i32 1, !"wchar_size", i32 4}
!16 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 23, type: !17, scopeLine: 23, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!17 = !DISubroutineType(types: !18)
!18 = !{!9}
!19 = !DILocation(line: 24, column: 7, scope: !16)
!20 = !DILocation(line: 24, column: 5, scope: !16)
!21 = !DILocation(line: 25, column: 7, scope: !16)
!22 = !DILocation(line: 25, column: 5, scope: !16)
!23 = !DILocation(line: 26, column: 7, scope: !16)
!24 = !DILocation(line: 26, column: 5, scope: !16)
!25 = !DILocalVariable(name: "i", scope: !26, file: !3, line: 28, type: !9)
!26 = distinct !DILexicalBlock(scope: !16, file: !3, line: 28, column: 3)
!27 = !DILocation(line: 28, column: 11, scope: !26)
!28 = !DILocation(line: 28, column: 7, scope: !26)
!29 = !DILocation(line: 28, column: 16, scope: !30)
!30 = distinct !DILexicalBlock(scope: !26, file: !3, line: 28, column: 3)
!31 = !DILocation(line: 28, column: 17, scope: !30)
!32 = !DILocation(line: 28, column: 3, scope: !26)
!33 = !DILocalVariable(name: "j", scope: !34, file: !3, line: 29, type: !9)
!34 = distinct !DILexicalBlock(scope: !35, file: !3, line: 29, column: 5)
!35 = distinct !DILexicalBlock(scope: !30, file: !3, line: 28, column: 25)
!36 = !DILocation(line: 29, column: 13, scope: !34)
!37 = !DILocation(line: 29, column: 9, scope: !34)
!38 = !DILocation(line: 29, column: 18, scope: !39)
!39 = distinct !DILexicalBlock(scope: !34, file: !3, line: 29, column: 5)
!40 = !DILocation(line: 29, column: 19, scope: !39)
!41 = !DILocation(line: 29, column: 5, scope: !34)
!42 = !DILocation(line: 30, column: 7, scope: !43)
!43 = distinct !DILexicalBlock(scope: !39, file: !3, line: 29, column: 27)
!44 = !DILocation(line: 30, column: 9, scope: !43)
!45 = !DILocation(line: 30, column: 11, scope: !43)
!46 = !DILocation(line: 30, column: 12, scope: !43)
!47 = !DILocation(line: 30, column: 10, scope: !43)
!48 = !DILocation(line: 30, column: 15, scope: !43)
!49 = !DILocation(line: 31, column: 5, scope: !43)
!50 = !DILocation(line: 29, column: 24, scope: !39)
!51 = !DILocation(line: 29, column: 5, scope: !39)
!52 = distinct !{!52, !41, !53}
!53 = !DILocation(line: 31, column: 5, scope: !34)
!54 = !DILocation(line: 32, column: 5, scope: !35)
!55 = !DILocation(line: 32, column: 7, scope: !35)
!56 = !DILocation(line: 32, column: 9, scope: !35)
!57 = !DILocation(line: 33, column: 5, scope: !35)
!58 = !DILocation(line: 33, column: 7, scope: !35)
!59 = !DILocation(line: 33, column: 9, scope: !35)
!60 = !DILocation(line: 34, column: 3, scope: !35)
!61 = !DILocation(line: 28, column: 22, scope: !30)
!62 = !DILocation(line: 28, column: 3, scope: !30)
!63 = distinct !{!63, !32, !64}
!64 = !DILocation(line: 34, column: 3, scope: !26)
!65 = !DILocalVariable(name: "i", scope: !66, file: !3, line: 39, type: !9)
!66 = distinct !DILexicalBlock(scope: !67, file: !3, line: 39, column: 5)
!67 = distinct !DILexicalBlock(scope: !16, file: !3, line: 37, column: 3)
!68 = !DILocation(line: 39, column: 13, scope: !66)
!69 = !DILocation(line: 39, column: 9, scope: !66)
!70 = !DILocation(line: 39, column: 18, scope: !71)
!71 = distinct !DILexicalBlock(scope: !66, file: !3, line: 39, column: 5)
!72 = !DILocation(line: 39, column: 19, scope: !71)
!73 = !DILocation(line: 39, column: 5, scope: !66)
!74 = !DILocalVariable(name: "j", scope: !75, file: !3, line: 40, type: !9)
!75 = distinct !DILexicalBlock(scope: !76, file: !3, line: 40, column: 7)
!76 = distinct !DILexicalBlock(scope: !71, file: !3, line: 39, column: 27)
!77 = !DILocation(line: 40, column: 15, scope: !75)
!78 = !DILocation(line: 40, column: 11, scope: !75)
!79 = !DILocation(line: 40, column: 20, scope: !80)
!80 = distinct !DILexicalBlock(scope: !75, file: !3, line: 40, column: 7)
!81 = !DILocation(line: 40, column: 21, scope: !80)
!82 = !DILocation(line: 40, column: 7, scope: !75)
!83 = !DILocation(line: 41, column: 15, scope: !84)
!84 = distinct !DILexicalBlock(scope: !80, file: !3, line: 40, column: 29)
!85 = !DILocation(line: 41, column: 17, scope: !84)
!86 = !DILocation(line: 41, column: 19, scope: !84)
!87 = !DILocation(line: 41, column: 20, scope: !84)
!88 = !DILocation(line: 41, column: 18, scope: !84)
!89 = !DILocation(line: 41, column: 24, scope: !84)
!90 = !DILocation(line: 41, column: 26, scope: !84)
!91 = !DILocation(line: 41, column: 23, scope: !84)
!92 = !DILocation(line: 41, column: 9, scope: !84)
!93 = !DILocation(line: 41, column: 11, scope: !84)
!94 = !DILocation(line: 41, column: 13, scope: !84)
!95 = !DILocation(line: 42, column: 7, scope: !84)
!96 = !DILocation(line: 40, column: 26, scope: !80)
!97 = !DILocation(line: 40, column: 7, scope: !80)
!98 = distinct !{!98, !82, !99}
!99 = !DILocation(line: 42, column: 7, scope: !75)
!100 = !DILocation(line: 43, column: 5, scope: !76)
!101 = !DILocation(line: 39, column: 24, scope: !71)
!102 = !DILocation(line: 39, column: 5, scope: !71)
!103 = distinct !{!103, !73, !104}
!104 = !DILocation(line: 43, column: 5, scope: !66)
!105 = !DILocalVariable(name: "i", scope: !106, file: !3, line: 46, type: !9)
!106 = distinct !DILexicalBlock(scope: !16, file: !3, line: 46, column: 3)
!107 = !DILocation(line: 46, column: 11, scope: !106)
!108 = !DILocation(line: 46, column: 7, scope: !106)
!109 = !DILocation(line: 46, column: 16, scope: !110)
!110 = distinct !DILexicalBlock(scope: !106, file: !3, line: 46, column: 3)
!111 = !DILocation(line: 46, column: 17, scope: !110)
!112 = !DILocation(line: 46, column: 3, scope: !106)
!113 = !DILocation(line: 47, column: 8, scope: !114)
!114 = distinct !DILexicalBlock(scope: !115, file: !3, line: 47, column: 8)
!115 = distinct !DILexicalBlock(scope: !110, file: !3, line: 46, column: 25)
!116 = !DILocation(line: 47, column: 10, scope: !114)
!117 = !DILocation(line: 47, column: 12, scope: !114)
!118 = !DILocation(line: 47, column: 8, scope: !115)
!119 = !DILocation(line: 48, column: 7, scope: !120)
!120 = distinct !DILexicalBlock(scope: !114, file: !3, line: 47, column: 16)
!121 = !DILocation(line: 49, column: 7, scope: !120)
!122 = !DILocation(line: 51, column: 3, scope: !115)
!123 = !DILocation(line: 46, column: 22, scope: !110)
!124 = !DILocation(line: 46, column: 3, scope: !110)
!125 = distinct !{!125, !112, !126}
!126 = !DILocation(line: 51, column: 3, scope: !106)
!127 = !DILocation(line: 53, column: 8, scope: !16)
!128 = !DILocation(line: 53, column: 3, scope: !16)
!129 = !DILocation(line: 54, column: 8, scope: !16)
!130 = !DILocation(line: 54, column: 3, scope: !16)
!131 = !DILocation(line: 55, column: 8, scope: !16)
!132 = !DILocation(line: 55, column: 3, scope: !16)
!133 = !DILocation(line: 57, column: 3, scope: !16)
!134 = !DILocation(line: 58, column: 1, scope: !16)
