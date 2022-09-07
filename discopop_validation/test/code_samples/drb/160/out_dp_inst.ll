; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@b = dso_local global [16 x i32] zeroinitializer, align 16, !dbg !0
@c = dso_local global [16 x i32] zeroinitializer, align 16, !dbg !9
@temp = dso_local global [16 x i32] zeroinitializer, align 16, !dbg !14
@a = dso_local global i32 0, align 4, !dbg !6
@.str.1 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"c\00", align 1
@.str.5 = private unnamed_addr constant [5 x i8] c"temp\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.7 = private unnamed_addr constant [4 x i8] c"val\00", align 1
@.str = private unnamed_addr constant [19 x i8] c"index: %d val: %d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !20 {
entry:
  call void @__dp_func_entry(i32 16412, i32 1)
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %i5 = alloca i32, align 4
  %i9 = alloca i32, align 4
  %i22 = alloca i32, align 4
  %val = alloca i32, align 4
  %i35 = alloca i32, align 4
  %i44 = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16412, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !23, metadata !DIExpression()), !dbg !25
  %1 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16413, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !25
  br label %for.cond, !dbg !26

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16413, i32 0)
  %2 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16413, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %3 = load i32, i32* %i, align 4, !dbg !27
  %cmp = icmp slt i32 %3, 16, !dbg !29
  br i1 %cmp, label %for.body, label %for.end, !dbg !30

for.body:                                         ; preds = %for.cond
  %4 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16414, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %5 = load i32, i32* %i, align 4, !dbg !31
  %idxprom = sext i32 %5 to i64, !dbg !33
  %arrayidx = getelementptr inbounds [16 x i32], [16 x i32]* @b, i64 0, i64 %idxprom, !dbg !33
  %6 = ptrtoint i32* %arrayidx to i64
  call void @__dp_write(i32 16414, i64 %6, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 0, i32* %arrayidx, align 4, !dbg !34
  %7 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16415, i64 %7, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %8 = load i32, i32* %i, align 4, !dbg !35
  %idxprom1 = sext i32 %8 to i64, !dbg !36
  %arrayidx2 = getelementptr inbounds [16 x i32], [16 x i32]* @c, i64 0, i64 %idxprom1, !dbg !36
  %9 = ptrtoint i32* %arrayidx2 to i64
  call void @__dp_write(i32 16415, i64 %9, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 2, i32* %arrayidx2, align 4, !dbg !37
  %10 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16416, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %11 = load i32, i32* %i, align 4, !dbg !38
  %idxprom3 = sext i32 %11 to i64, !dbg !39
  %arrayidx4 = getelementptr inbounds [16 x i32], [16 x i32]* @temp, i64 0, i64 %idxprom3, !dbg !39
  %12 = ptrtoint i32* %arrayidx4 to i64
  call void @__dp_write(i32 16416, i64 %12, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.5, i32 0, i32 0))
  store i32 0, i32* %arrayidx4, align 4, !dbg !40
  br label %for.inc, !dbg !41

for.inc:                                          ; preds = %for.body
  %13 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16413, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %14 = load i32, i32* %i, align 4, !dbg !42
  %inc = add nsw i32 %14, 1, !dbg !42
  %15 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16413, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !42
  br label %for.cond, !dbg !43, !llvm.loop !44

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16418, i32 0)
  %16 = ptrtoint i32* @a to i64
  call void @__dp_write(i32 16418, i64 %16, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 2, i32* @a, align 4, !dbg !46
  call void @llvm.dbg.declare(metadata i32* %i5, metadata !47, metadata !DIExpression()), !dbg !50
  %17 = ptrtoint i32* %i5 to i64
  call void @__dp_write(i32 16423, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %i5, align 4, !dbg !50
  br label %for.cond6, !dbg !51

for.cond6:                                        ; preds = %for.inc32, %for.end
  call void @__dp_loop_entry(i32 16423, i32 1)
  %18 = ptrtoint i32* %i5 to i64
  call void @__dp_read(i32 16423, i64 %18, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %19 = load i32, i32* %i5, align 4, !dbg !52
  %cmp7 = icmp slt i32 %19, 100, !dbg !54
  br i1 %cmp7, label %for.body8, label %for.end34, !dbg !55

for.body8:                                        ; preds = %for.cond6
  call void @llvm.dbg.declare(metadata i32* %i9, metadata !56, metadata !DIExpression()), !dbg !59
  %20 = ptrtoint i32* %i9 to i64
  call void @__dp_write(i32 16425, i64 %20, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %i9, align 4, !dbg !59
  br label %for.cond10, !dbg !60

for.cond10:                                       ; preds = %for.inc19, %for.body8
  call void @__dp_loop_entry(i32 16425, i32 2)
  %21 = ptrtoint i32* %i9 to i64
  call void @__dp_read(i32 16425, i64 %21, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %22 = load i32, i32* %i9, align 4, !dbg !61
  %cmp11 = icmp slt i32 %22, 16, !dbg !63
  br i1 %cmp11, label %for.body12, label %for.end21, !dbg !64

for.body12:                                       ; preds = %for.cond10
  %23 = ptrtoint i32* %i9 to i64
  call void @__dp_read(i32 16426, i64 %23, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %24 = load i32, i32* %i9, align 4, !dbg !65
  %idxprom13 = sext i32 %24 to i64, !dbg !67
  %arrayidx14 = getelementptr inbounds [16 x i32], [16 x i32]* @b, i64 0, i64 %idxprom13, !dbg !67
  %25 = ptrtoint i32* %arrayidx14 to i64
  call void @__dp_read(i32 16426, i64 %25, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %26 = load i32, i32* %arrayidx14, align 4, !dbg !67
  %27 = ptrtoint i32* %i9 to i64
  call void @__dp_read(i32 16426, i64 %27, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %28 = load i32, i32* %i9, align 4, !dbg !68
  %idxprom15 = sext i32 %28 to i64, !dbg !69
  %arrayidx16 = getelementptr inbounds [16 x i32], [16 x i32]* @c, i64 0, i64 %idxprom15, !dbg !69
  %29 = ptrtoint i32* %arrayidx16 to i64
  call void @__dp_read(i32 16426, i64 %29, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %30 = load i32, i32* %arrayidx16, align 4, !dbg !69
  %add = add nsw i32 %26, %30, !dbg !70
  %31 = ptrtoint i32* %i9 to i64
  call void @__dp_read(i32 16426, i64 %31, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %32 = load i32, i32* %i9, align 4, !dbg !71
  %idxprom17 = sext i32 %32 to i64, !dbg !72
  %arrayidx18 = getelementptr inbounds [16 x i32], [16 x i32]* @temp, i64 0, i64 %idxprom17, !dbg !72
  %33 = ptrtoint i32* %arrayidx18 to i64
  call void @__dp_write(i32 16426, i64 %33, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.5, i32 0, i32 0))
  store i32 %add, i32* %arrayidx18, align 4, !dbg !73
  br label %for.inc19, !dbg !74

for.inc19:                                        ; preds = %for.body12
  %34 = ptrtoint i32* %i9 to i64
  call void @__dp_read(i32 16425, i64 %34, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %35 = load i32, i32* %i9, align 4, !dbg !75
  %inc20 = add nsw i32 %35, 1, !dbg !75
  %36 = ptrtoint i32* %i9 to i64
  call void @__dp_write(i32 16425, i64 %36, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 %inc20, i32* %i9, align 4, !dbg !75
  br label %for.cond10, !dbg !76, !llvm.loop !77

for.end21:                                        ; preds = %for.cond10
  call void @__dp_loop_exit(i32 16430, i32 2)
  call void @llvm.dbg.declare(metadata i32* %i22, metadata !79, metadata !DIExpression()), !dbg !81
  %37 = ptrtoint i32* %i22 to i64
  call void @__dp_write(i32 16430, i64 %37, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 15, i32* %i22, align 4, !dbg !81
  br label %for.cond23, !dbg !82

for.cond23:                                       ; preds = %for.inc30, %for.end21
  call void @__dp_loop_entry(i32 16430, i32 3)
  %38 = ptrtoint i32* %i22 to i64
  call void @__dp_read(i32 16430, i64 %38, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %39 = load i32, i32* %i22, align 4, !dbg !83
  %cmp24 = icmp sge i32 %39, 0, !dbg !85
  br i1 %cmp24, label %for.body25, label %for.end31, !dbg !86

for.body25:                                       ; preds = %for.cond23
  %40 = ptrtoint i32* %i22 to i64
  call void @__dp_read(i32 16431, i64 %40, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %41 = load i32, i32* %i22, align 4, !dbg !87
  %idxprom26 = sext i32 %41 to i64, !dbg !89
  %arrayidx27 = getelementptr inbounds [16 x i32], [16 x i32]* @temp, i64 0, i64 %idxprom26, !dbg !89
  %42 = ptrtoint i32* %arrayidx27 to i64
  call void @__dp_read(i32 16431, i64 %42, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.5, i32 0, i32 0))
  %43 = load i32, i32* %arrayidx27, align 4, !dbg !89
  %44 = ptrtoint i32* @a to i64
  call void @__dp_read(i32 16431, i64 %44, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %45 = load i32, i32* @a, align 4, !dbg !90
  %mul = mul nsw i32 %43, %45, !dbg !91
  %46 = ptrtoint i32* %i22 to i64
  call void @__dp_read(i32 16431, i64 %46, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %47 = load i32, i32* %i22, align 4, !dbg !92
  %idxprom28 = sext i32 %47 to i64, !dbg !93
  %arrayidx29 = getelementptr inbounds [16 x i32], [16 x i32]* @b, i64 0, i64 %idxprom28, !dbg !93
  %48 = ptrtoint i32* %arrayidx29 to i64
  call void @__dp_write(i32 16431, i64 %48, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 %mul, i32* %arrayidx29, align 4, !dbg !94
  br label %for.inc30, !dbg !95

for.inc30:                                        ; preds = %for.body25
  %49 = ptrtoint i32* %i22 to i64
  call void @__dp_read(i32 16430, i64 %49, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %50 = load i32, i32* %i22, align 4, !dbg !96
  %dec = add nsw i32 %50, -1, !dbg !96
  %51 = ptrtoint i32* %i22 to i64
  call void @__dp_write(i32 16430, i64 %51, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 %dec, i32* %i22, align 4, !dbg !96
  br label %for.cond23, !dbg !97, !llvm.loop !98

for.end31:                                        ; preds = %for.cond23
  call void @__dp_loop_exit(i32 16433, i32 3)
  br label %for.inc32, !dbg !100

for.inc32:                                        ; preds = %for.end31
  %52 = ptrtoint i32* %i5 to i64
  call void @__dp_read(i32 16423, i64 %52, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %53 = load i32, i32* %i5, align 4, !dbg !101
  %inc33 = add nsw i32 %53, 1, !dbg !101
  %54 = ptrtoint i32* %i5 to i64
  call void @__dp_write(i32 16423, i64 %54, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 %inc33, i32* %i5, align 4, !dbg !101
  br label %for.cond6, !dbg !102, !llvm.loop !103

for.end34:                                        ; preds = %for.cond6
  call void @__dp_loop_exit(i32 16436, i32 1)
  call void @llvm.dbg.declare(metadata i32* %val, metadata !105, metadata !DIExpression()), !dbg !106
  %55 = ptrtoint i32* %val to i64
  call void @__dp_write(i32 16436, i64 %55, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  store i32 0, i32* %val, align 4, !dbg !106
  call void @llvm.dbg.declare(metadata i32* %i35, metadata !107, metadata !DIExpression()), !dbg !109
  %56 = ptrtoint i32* %i35 to i64
  call void @__dp_write(i32 16438, i64 %56, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %i35, align 4, !dbg !109
  br label %for.cond36, !dbg !110

for.cond36:                                       ; preds = %for.inc41, %for.end34
  call void @__dp_loop_entry(i32 16438, i32 4)
  %57 = ptrtoint i32* %i35 to i64
  call void @__dp_read(i32 16438, i64 %57, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %58 = load i32, i32* %i35, align 4, !dbg !111
  %cmp37 = icmp slt i32 %58, 100, !dbg !113
  br i1 %cmp37, label %for.body38, label %for.end43, !dbg !114

for.body38:                                       ; preds = %for.cond36
  %59 = ptrtoint i32* %val to i64
  call void @__dp_read(i32 16439, i64 %59, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  %60 = load i32, i32* %val, align 4, !dbg !115
  %add39 = add nsw i32 %60, 2, !dbg !117
  %61 = ptrtoint i32* %val to i64
  call void @__dp_write(i32 16439, i64 %61, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  store i32 %add39, i32* %val, align 4, !dbg !118
  %62 = ptrtoint i32* %val to i64
  call void @__dp_read(i32 16440, i64 %62, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  %63 = load i32, i32* %val, align 4, !dbg !119
  %mul40 = mul nsw i32 %63, 2, !dbg !120
  %64 = ptrtoint i32* %val to i64
  call void @__dp_write(i32 16440, i64 %64, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  store i32 %mul40, i32* %val, align 4, !dbg !121
  br label %for.inc41, !dbg !122

for.inc41:                                        ; preds = %for.body38
  %65 = ptrtoint i32* %i35 to i64
  call void @__dp_read(i32 16438, i64 %65, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %66 = load i32, i32* %i35, align 4, !dbg !123
  %inc42 = add nsw i32 %66, 1, !dbg !123
  %67 = ptrtoint i32* %i35 to i64
  call void @__dp_write(i32 16438, i64 %67, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 %inc42, i32* %i35, align 4, !dbg !123
  br label %for.cond36, !dbg !124, !llvm.loop !125

for.end43:                                        ; preds = %for.cond36
  call void @__dp_loop_exit(i32 16443, i32 4)
  call void @llvm.dbg.declare(metadata i32* %i44, metadata !127, metadata !DIExpression()), !dbg !129
  %68 = ptrtoint i32* %i44 to i64
  call void @__dp_write(i32 16443, i64 %68, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %i44, align 4, !dbg !129
  br label %for.cond45, !dbg !130

for.cond45:                                       ; preds = %for.inc53, %for.end43
  call void @__dp_loop_entry(i32 16443, i32 5)
  %69 = ptrtoint i32* %i44 to i64
  call void @__dp_read(i32 16443, i64 %69, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %70 = load i32, i32* %i44, align 4, !dbg !131
  %cmp46 = icmp slt i32 %70, 16, !dbg !133
  br i1 %cmp46, label %for.body47, label %for.end55, !dbg !134

for.body47:                                       ; preds = %for.cond45
  %71 = ptrtoint i32* %i44 to i64
  call void @__dp_read(i32 16444, i64 %71, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %72 = load i32, i32* %i44, align 4, !dbg !135
  %idxprom48 = sext i32 %72 to i64, !dbg !138
  %arrayidx49 = getelementptr inbounds [16 x i32], [16 x i32]* @b, i64 0, i64 %idxprom48, !dbg !138
  %73 = ptrtoint i32* %arrayidx49 to i64
  call void @__dp_read(i32 16444, i64 %73, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %74 = load i32, i32* %arrayidx49, align 4, !dbg !138
  %75 = ptrtoint i32* %val to i64
  call void @__dp_read(i32 16444, i64 %75, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  %76 = load i32, i32* %val, align 4, !dbg !139
  %cmp50 = icmp ne i32 %74, %76, !dbg !140
  br i1 %cmp50, label %if.then, label %if.end, !dbg !141

if.then:                                          ; preds = %for.body47
  %77 = ptrtoint i32* %i44 to i64
  call void @__dp_read(i32 16445, i64 %77, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %78 = load i32, i32* %i44, align 4, !dbg !142
  %79 = ptrtoint i32* %i44 to i64
  call void @__dp_read(i32 16445, i64 %79, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %80 = load i32, i32* %i44, align 4, !dbg !144
  %idxprom51 = sext i32 %80 to i64, !dbg !145
  %arrayidx52 = getelementptr inbounds [16 x i32], [16 x i32]* @b, i64 0, i64 %idxprom51, !dbg !145
  %81 = ptrtoint i32* %arrayidx52 to i64
  call void @__dp_read(i32 16445, i64 %81, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %82 = load i32, i32* %arrayidx52, align 4, !dbg !145
  call void @__dp_call(i32 16445), !dbg !146
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str, i64 0, i64 0), i32 %78, i32 %82), !dbg !146
  br label %if.end, !dbg !147

if.end:                                           ; preds = %if.then, %for.body47
  br label %for.inc53, !dbg !148

for.inc53:                                        ; preds = %if.end
  %83 = ptrtoint i32* %i44 to i64
  call void @__dp_read(i32 16443, i64 %83, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %84 = load i32, i32* %i44, align 4, !dbg !149
  %inc54 = add nsw i32 %84, 1, !dbg !149
  %85 = ptrtoint i32* %i44 to i64
  call void @__dp_write(i32 16443, i64 %85, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 %inc54, i32* %i44, align 4, !dbg !149
  br label %for.cond45, !dbg !150, !llvm.loop !151

for.end55:                                        ; preds = %for.cond45
  call void @__dp_loop_exit(i32 16449, i32 5)
  call void @__dp_finalize(i32 16449), !dbg !153
  ret i32 0, !dbg !153
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
!llvm.ident = !{!16}
!llvm.module.flags = !{!17, !18, !19}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !3, line: 24, type: !11, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/160")
!4 = !{}
!5 = !{!6, !0, !9, !14}
!6 = !DIGlobalVariableExpression(var: !7, expr: !DIExpression())
!7 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 23, type: !8, isLocal: false, isDefinition: true)
!8 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!9 = !DIGlobalVariableExpression(var: !10, expr: !DIExpression())
!10 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !3, line: 25, type: !11, isLocal: false, isDefinition: true)
!11 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 512, elements: !12)
!12 = !{!13}
!13 = !DISubrange(count: 16)
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(name: "temp", scope: !2, file: !3, line: 26, type: !11, isLocal: false, isDefinition: true)
!16 = !{!"Ubuntu clang version 11.1.0-6"}
!17 = !{i32 7, !"Dwarf Version", i32 4}
!18 = !{i32 2, !"Debug Info Version", i32 3}
!19 = !{i32 1, !"wchar_size", i32 4}
!20 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 28, type: !21, scopeLine: 28, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!21 = !DISubroutineType(types: !22)
!22 = !{!8}
!23 = !DILocalVariable(name: "i", scope: !24, file: !3, line: 29, type: !8)
!24 = distinct !DILexicalBlock(scope: !20, file: !3, line: 29, column: 3)
!25 = !DILocation(line: 29, column: 11, scope: !24)
!26 = !DILocation(line: 29, column: 7, scope: !24)
!27 = !DILocation(line: 29, column: 16, scope: !28)
!28 = distinct !DILexicalBlock(scope: !24, file: !3, line: 29, column: 3)
!29 = !DILocation(line: 29, column: 17, scope: !28)
!30 = !DILocation(line: 29, column: 3, scope: !24)
!31 = !DILocation(line: 30, column: 7, scope: !32)
!32 = distinct !DILexicalBlock(scope: !28, file: !3, line: 29, column: 25)
!33 = !DILocation(line: 30, column: 5, scope: !32)
!34 = !DILocation(line: 30, column: 9, scope: !32)
!35 = !DILocation(line: 31, column: 7, scope: !32)
!36 = !DILocation(line: 31, column: 5, scope: !32)
!37 = !DILocation(line: 31, column: 9, scope: !32)
!38 = !DILocation(line: 32, column: 10, scope: !32)
!39 = !DILocation(line: 32, column: 5, scope: !32)
!40 = !DILocation(line: 32, column: 12, scope: !32)
!41 = !DILocation(line: 33, column: 3, scope: !32)
!42 = !DILocation(line: 29, column: 22, scope: !28)
!43 = !DILocation(line: 29, column: 3, scope: !28)
!44 = distinct !{!44, !30, !45}
!45 = !DILocation(line: 33, column: 3, scope: !24)
!46 = !DILocation(line: 34, column: 4, scope: !20)
!47 = !DILocalVariable(name: "i", scope: !48, file: !3, line: 39, type: !8)
!48 = distinct !DILexicalBlock(scope: !49, file: !3, line: 39, column: 5)
!49 = distinct !DILexicalBlock(scope: !20, file: !3, line: 37, column: 3)
!50 = !DILocation(line: 39, column: 13, scope: !48)
!51 = !DILocation(line: 39, column: 9, scope: !48)
!52 = !DILocation(line: 39, column: 18, scope: !53)
!53 = distinct !DILexicalBlock(scope: !48, file: !3, line: 39, column: 5)
!54 = !DILocation(line: 39, column: 19, scope: !53)
!55 = !DILocation(line: 39, column: 5, scope: !48)
!56 = !DILocalVariable(name: "i", scope: !57, file: !3, line: 41, type: !8)
!57 = distinct !DILexicalBlock(scope: !58, file: !3, line: 41, column: 7)
!58 = distinct !DILexicalBlock(scope: !53, file: !3, line: 39, column: 27)
!59 = !DILocation(line: 41, column: 15, scope: !57)
!60 = !DILocation(line: 41, column: 11, scope: !57)
!61 = !DILocation(line: 41, column: 20, scope: !62)
!62 = distinct !DILexicalBlock(scope: !57, file: !3, line: 41, column: 7)
!63 = !DILocation(line: 41, column: 21, scope: !62)
!64 = !DILocation(line: 41, column: 7, scope: !57)
!65 = !DILocation(line: 42, column: 21, scope: !66)
!66 = distinct !DILexicalBlock(scope: !62, file: !3, line: 41, column: 29)
!67 = !DILocation(line: 42, column: 19, scope: !66)
!68 = !DILocation(line: 42, column: 28, scope: !66)
!69 = !DILocation(line: 42, column: 26, scope: !66)
!70 = !DILocation(line: 42, column: 24, scope: !66)
!71 = !DILocation(line: 42, column: 14, scope: !66)
!72 = !DILocation(line: 42, column: 9, scope: !66)
!73 = !DILocation(line: 42, column: 17, scope: !66)
!74 = !DILocation(line: 43, column: 7, scope: !66)
!75 = !DILocation(line: 41, column: 26, scope: !62)
!76 = !DILocation(line: 41, column: 7, scope: !62)
!77 = distinct !{!77, !64, !78}
!78 = !DILocation(line: 43, column: 7, scope: !57)
!79 = !DILocalVariable(name: "i", scope: !80, file: !3, line: 46, type: !8)
!80 = distinct !DILexicalBlock(scope: !58, file: !3, line: 46, column: 7)
!81 = !DILocation(line: 46, column: 15, scope: !80)
!82 = !DILocation(line: 46, column: 11, scope: !80)
!83 = !DILocation(line: 46, column: 22, scope: !84)
!84 = distinct !DILexicalBlock(scope: !80, file: !3, line: 46, column: 7)
!85 = !DILocation(line: 46, column: 23, scope: !84)
!86 = !DILocation(line: 46, column: 7, scope: !80)
!87 = !DILocation(line: 47, column: 21, scope: !88)
!88 = distinct !DILexicalBlock(scope: !84, file: !3, line: 46, column: 32)
!89 = !DILocation(line: 47, column: 16, scope: !88)
!90 = !DILocation(line: 47, column: 26, scope: !88)
!91 = !DILocation(line: 47, column: 24, scope: !88)
!92 = !DILocation(line: 47, column: 11, scope: !88)
!93 = !DILocation(line: 47, column: 9, scope: !88)
!94 = !DILocation(line: 47, column: 14, scope: !88)
!95 = !DILocation(line: 48, column: 7, scope: !88)
!96 = !DILocation(line: 46, column: 29, scope: !84)
!97 = !DILocation(line: 46, column: 7, scope: !84)
!98 = distinct !{!98, !86, !99}
!99 = !DILocation(line: 48, column: 7, scope: !80)
!100 = !DILocation(line: 49, column: 5, scope: !58)
!101 = !DILocation(line: 39, column: 24, scope: !53)
!102 = !DILocation(line: 39, column: 5, scope: !53)
!103 = distinct !{!103, !55, !104}
!104 = !DILocation(line: 49, column: 5, scope: !48)
!105 = !DILocalVariable(name: "val", scope: !20, file: !3, line: 52, type: !8)
!106 = !DILocation(line: 52, column: 7, scope: !20)
!107 = !DILocalVariable(name: "i", scope: !108, file: !3, line: 54, type: !8)
!108 = distinct !DILexicalBlock(scope: !20, file: !3, line: 54, column: 3)
!109 = !DILocation(line: 54, column: 11, scope: !108)
!110 = !DILocation(line: 54, column: 7, scope: !108)
!111 = !DILocation(line: 54, column: 16, scope: !112)
!112 = distinct !DILexicalBlock(scope: !108, file: !3, line: 54, column: 3)
!113 = !DILocation(line: 54, column: 17, scope: !112)
!114 = !DILocation(line: 54, column: 3, scope: !108)
!115 = !DILocation(line: 55, column: 11, scope: !116)
!116 = distinct !DILexicalBlock(scope: !112, file: !3, line: 54, column: 25)
!117 = !DILocation(line: 55, column: 15, scope: !116)
!118 = !DILocation(line: 55, column: 9, scope: !116)
!119 = !DILocation(line: 56, column: 11, scope: !116)
!120 = !DILocation(line: 56, column: 15, scope: !116)
!121 = !DILocation(line: 56, column: 9, scope: !116)
!122 = !DILocation(line: 57, column: 3, scope: !116)
!123 = !DILocation(line: 54, column: 22, scope: !112)
!124 = !DILocation(line: 54, column: 3, scope: !112)
!125 = distinct !{!125, !114, !126}
!126 = !DILocation(line: 57, column: 3, scope: !108)
!127 = !DILocalVariable(name: "i", scope: !128, file: !3, line: 59, type: !8)
!128 = distinct !DILexicalBlock(scope: !20, file: !3, line: 59, column: 3)
!129 = !DILocation(line: 59, column: 11, scope: !128)
!130 = !DILocation(line: 59, column: 7, scope: !128)
!131 = !DILocation(line: 59, column: 16, scope: !132)
!132 = distinct !DILexicalBlock(scope: !128, file: !3, line: 59, column: 3)
!133 = !DILocation(line: 59, column: 17, scope: !132)
!134 = !DILocation(line: 59, column: 3, scope: !128)
!135 = !DILocation(line: 60, column: 10, scope: !136)
!136 = distinct !DILexicalBlock(scope: !137, file: !3, line: 60, column: 8)
!137 = distinct !DILexicalBlock(scope: !132, file: !3, line: 59, column: 25)
!138 = !DILocation(line: 60, column: 8, scope: !136)
!139 = !DILocation(line: 60, column: 14, scope: !136)
!140 = !DILocation(line: 60, column: 12, scope: !136)
!141 = !DILocation(line: 60, column: 8, scope: !137)
!142 = !DILocation(line: 61, column: 36, scope: !143)
!143 = distinct !DILexicalBlock(scope: !136, file: !3, line: 60, column: 18)
!144 = !DILocation(line: 61, column: 41, scope: !143)
!145 = !DILocation(line: 61, column: 39, scope: !143)
!146 = !DILocation(line: 61, column: 7, scope: !143)
!147 = !DILocation(line: 62, column: 5, scope: !143)
!148 = !DILocation(line: 63, column: 3, scope: !137)
!149 = !DILocation(line: 59, column: 22, scope: !132)
!150 = !DILocation(line: 59, column: 3, scope: !132)
!151 = distinct !{!151, !134, !152}
!152 = !DILocation(line: 63, column: 3, scope: !128)
!153 = !DILocation(line: 65, column: 3, scope: !20)
