; ModuleID = 'code.cpp'
source_filename = "code.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@_ZZ4mainE1n = internal global i32 4000, align 4, !dbg !0
@.str = private unnamed_addr constant [8 x i8] c"1:5;1:6\00", align 1
@.str.1 = private unnamed_addr constant [8 x i8] c"1:5;1:8\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"tmp\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"sum\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"n\00", align 1
@.str.6 = private unnamed_addr constant [10 x i8] c"1:14;1:15\00", align 1
@.str.7 = private unnamed_addr constant [10 x i8] c"1:14;1:17\00", align 1
@.str.8 = private unnamed_addr constant [10 x i8] c"1:19;1:20\00", align 1
@.str.9 = private unnamed_addr constant [10 x i8] c"1:19;1:33\00", align 1
@.str.10 = private unnamed_addr constant [10 x i8] c"1:22;1:23\00", align 1
@.str.11 = private unnamed_addr constant [10 x i8] c"1:22;1:31\00", align 1
@.str.12 = private unnamed_addr constant [10 x i8] c"1:25;1:26\00", align 1
@.str.13 = private unnamed_addr constant [10 x i8] c"1:25;1:29\00", align 1
@.str.14 = private unnamed_addr constant [12 x i8] c"_ZZ4mainE1n\00", align 1
@.str.15 = private unnamed_addr constant [5 x i8] c".str\00", align 1
@.str.16 = private unnamed_addr constant [7 x i8] c".str.1\00", align 1
@.str.17 = private unnamed_addr constant [7 x i8] c".str.2\00", align 1
@.str.18 = private unnamed_addr constant [7 x i8] c".str.3\00", align 1
@.str.19 = private unnamed_addr constant [7 x i8] c".str.4\00", align 1
@.str.20 = private unnamed_addr constant [7 x i8] c".str.5\00", align 1
@.str.21 = private unnamed_addr constant [7 x i8] c".str.6\00", align 1
@.str.22 = private unnamed_addr constant [7 x i8] c".str.7\00", align 1
@.str.23 = private unnamed_addr constant [7 x i8] c".str.8\00", align 1
@.str.24 = private unnamed_addr constant [7 x i8] c".str.9\00", align 1
@.str.25 = private unnamed_addr constant [8 x i8] c".str.10\00", align 1
@.str.26 = private unnamed_addr constant [8 x i8] c".str.11\00", align 1
@.str.27 = private unnamed_addr constant [8 x i8] c".str.12\00", align 1
@.str.28 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.29 = private unnamed_addr constant [5 x i8] c"argc\00", align 1
@.str.30 = private unnamed_addr constant [5 x i8] c"argv\00", align 1
@.str.31 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str.32 = private unnamed_addr constant [2 x i8] c"k\00", align 1
@.str.33 = private unnamed_addr constant [2 x i8] c"j\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define i32 @_Z14allowing_doallPdi(double* %tmp, i32 %i) #0 !dbg !263 {
entry:
  call void @__dp_func_entry(i32 16388, i32 0)
  %__dp_bb1 = alloca i32, align 4
  store i32 0, i32* %__dp_bb1, align 4
  %__dp_bb = alloca i32, align 4
  store i32 0, i32* %__dp_bb, align 4
  %tmp.addr = alloca double*, align 8
  %0 = ptrtoint double** %tmp.addr to i64
  %i.addr = alloca i32, align 4
  %1 = ptrtoint i32* %i.addr to i64
  %sum = alloca i32, align 4
  %2 = ptrtoint i32* %sum to i64
  %n = alloca i32, align 4
  %3 = ptrtoint i32* %n to i64
  %4 = ptrtoint double** %tmp.addr to i64
  store double* %tmp, double** %tmp.addr, align 8
  call void @llvm.dbg.declare(metadata double** %tmp.addr, metadata !266, metadata !DIExpression()), !dbg !267
  %5 = ptrtoint i32* %i.addr to i64
  store i32 %i, i32* %i.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %i.addr, metadata !268, metadata !DIExpression()), !dbg !269
  call void @llvm.dbg.declare(metadata i32* %sum, metadata !270, metadata !DIExpression()), !dbg !271
  %6 = ptrtoint i32* %sum to i64
  store i32 0, i32* %sum, align 4, !dbg !271
  call void @llvm.dbg.declare(metadata i32* %n, metadata !272, metadata !DIExpression()), !dbg !274
  %7 = ptrtoint i32* %n to i64
  store i32 0, i32* %n, align 4, !dbg !274
  call void @__dp_report_bb(i32 0)
  br label %for.cond, !dbg !275

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16390, i32 0)
  %8 = ptrtoint i32* %n to i64
  %9 = load i32, i32* %n, align 4, !dbg !276
  %10 = ptrtoint i32* %i.addr to i64
  %11 = load i32, i32* %i.addr, align 4, !dbg !278
  %cmp = icmp slt i32 %9, %11, !dbg !279
  call void @__dp_incr_taken_branch_counter(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i32 0, i32 0), i1 %cmp, i32 1), !dbg !280
  call void @__dp_incr_taken_branch_counter(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.1, i32 0, i32 0), i1 %cmp, i32 0), !dbg !280
  call void @__dp_report_bb(i32 2)
  %12 = load i32, i32* %__dp_bb, align 4
  call void @__dp_report_bb_pair(i32 %12, i32 5)
  br i1 %cmp, label %for.body, label %for.end, !dbg !280

for.body:                                         ; preds = %for.cond
  call void @__dp_loop_incr(i32 1)
  %13 = ptrtoint double** %tmp.addr to i64
  %14 = load double*, double** %tmp.addr, align 8, !dbg !281
  %15 = ptrtoint i32* %i.addr to i64
  %16 = load i32, i32* %i.addr, align 4, !dbg !283
  %idxprom = sext i32 %16 to i64, !dbg !281
  %arrayidx = getelementptr inbounds double, double* %14, i64 %idxprom, !dbg !281
  %17 = ptrtoint double* %arrayidx to i64
  call void @__dp_read(i32 16391, i64 %17, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  %18 = load double, double* %arrayidx, align 8, !dbg !281
  %conv = fptosi double %18 to i32, !dbg !281
  %19 = ptrtoint i32* %sum to i64
  store i32 %conv, i32* %sum, align 4, !dbg !284
  call void @__dp_report_bb(i32 4)
  %20 = load i32, i32* %__dp_bb1, align 4
  call void @__dp_report_bb_pair(i32 %20, i32 8)
  store i32 1, i32* %__dp_bb1, align 4
  br label %for.inc, !dbg !285

for.inc:                                          ; preds = %for.body
  %21 = ptrtoint i32* %n to i64
  %22 = load i32, i32* %n, align 4, !dbg !286
  %inc = add nsw i32 %22, 1, !dbg !286
  %23 = ptrtoint i32* %n to i64
  store i32 %inc, i32* %n, align 4, !dbg !286
  call void @__dp_report_bb(i32 3)
  %24 = load i32, i32* %__dp_bb, align 4
  call void @__dp_report_bb_pair(i32 %24, i32 6)
  store i32 1, i32* %__dp_bb, align 4
  br label %for.cond, !dbg !287, !llvm.loop !288

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16393, i32 0)
  %25 = ptrtoint i32* %sum to i64
  %26 = load i32, i32* %sum, align 4, !dbg !290
  call void @__dp_report_bb(i32 1)
  %27 = load i32, i32* %__dp_bb1, align 4
  call void @__dp_report_bb_pair(i32 %27, i32 7)
  call void @__dp_func_exit(i32 16393, i32 0), !dbg !291
  ret i32 %26, !dbg !291
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline norecurse nounwind optnone uwtable
define i32 @main(i32 %argc, i8** %argv) #2 !dbg !2 {
entry:
  call void @__dp_func_entry(i32 16396, i32 1)
  %__dp_bb35 = alloca i32, align 4
  store i32 0, i32* %__dp_bb35, align 4
  %__dp_bb34 = alloca i32, align 4
  store i32 0, i32* %__dp_bb34, align 4
  %__dp_bb33 = alloca i32, align 4
  store i32 0, i32* %__dp_bb33, align 4
  %__dp_bb32 = alloca i32, align 4
  store i32 0, i32* %__dp_bb32, align 4
  %__dp_bb31 = alloca i32, align 4
  store i32 0, i32* %__dp_bb31, align 4
  %__dp_bb30 = alloca i32, align 4
  store i32 0, i32* %__dp_bb30, align 4
  %__dp_bb = alloca i32, align 4
  store i32 0, i32* %__dp_bb, align 4
  %retval = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  %argc.addr = alloca i32, align 4
  %1 = ptrtoint i32* %argc.addr to i64
  %argv.addr = alloca i8**, align 8
  %2 = ptrtoint i8*** %argv.addr to i64
  %x = alloca double*, align 8
  %3 = ptrtoint double** %x to i64
  %i = alloca i32, align 4
  %4 = ptrtoint i32* %i to i64
  %k = alloca i32, align 4
  %5 = ptrtoint i32* %k to i64
  %j = alloca i32, align 4
  %6 = ptrtoint i32* %j to i64
  %i7 = alloca i32, align 4
  %7 = ptrtoint i32* %i7 to i64
  %sum = alloca i32, align 4
  %8 = ptrtoint i32* %sum to i64
  %9 = ptrtoint i32* %retval to i64
  store i32 0, i32* %retval, align 4
  %10 = ptrtoint i32* %argc.addr to i64
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !292, metadata !DIExpression()), !dbg !293
  %11 = ptrtoint i8*** %argv.addr to i64
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !294, metadata !DIExpression()), !dbg !295
  call void @llvm.dbg.declare(metadata double** %x, metadata !296, metadata !DIExpression()), !dbg !297
  %12 = ptrtoint i32* @_ZZ4mainE1n to i64
  call void @__dp_read(i32 16398, i64 %12, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.14, i32 0, i32 0))
  %13 = load i32, i32* @_ZZ4mainE1n, align 4, !dbg !298
  %conv = sext i32 %13 to i64, !dbg !298
  %mul = mul i64 %conv, 8, !dbg !299
  %call = call noalias i8* @malloc(i64 %mul) #4, !dbg !300
  %14 = ptrtoint i8* %call to i64
  call void @__dp_new(i32 16398, i64 %14, i64 %14, i64 %mul), !dbg !301
  %15 = bitcast i8* %call to double*, !dbg !301
  %16 = ptrtoint double** %x to i64
  store double* %15, double** %x, align 8, !dbg !297
  call void @llvm.dbg.declare(metadata i32* %i, metadata !302, metadata !DIExpression()), !dbg !304
  %17 = ptrtoint i32* %i to i64
  store i32 0, i32* %i, align 4, !dbg !304
  call void @__dp_report_bb(i32 9)
  br label %for.cond, !dbg !305

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16401, i32 1)
  %18 = ptrtoint i32* %i to i64
  %19 = load i32, i32* %i, align 4, !dbg !306
  %20 = ptrtoint i32* @_ZZ4mainE1n to i64
  call void @__dp_read(i32 16401, i64 %20, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.14, i32 0, i32 0))
  %21 = load i32, i32* @_ZZ4mainE1n, align 4, !dbg !308
  %cmp = icmp slt i32 %19, %21, !dbg !309
  call void @__dp_incr_taken_branch_counter(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.6, i32 0, i32 0), i1 %cmp, i32 1), !dbg !310
  call void @__dp_incr_taken_branch_counter(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.7, i32 0, i32 0), i1 %cmp, i32 0), !dbg !310
  call void @__dp_report_bb(i32 11)
  %22 = load i32, i32* %__dp_bb, align 4
  call void @__dp_report_bb_pair(i32 %22, i32 24)
  br i1 %cmp, label %for.body, label %for.end, !dbg !310

for.body:                                         ; preds = %for.cond
  call void @__dp_loop_incr(i32 5)
  %23 = ptrtoint double** %x to i64
  %24 = load double*, double** %x, align 8, !dbg !311
  %25 = ptrtoint i32* %i to i64
  %26 = load i32, i32* %i, align 4, !dbg !313
  %idxprom = sext i32 %26 to i64, !dbg !311
  %arrayidx = getelementptr inbounds double, double* %24, i64 %idxprom, !dbg !311
  %27 = ptrtoint double* %arrayidx to i64
  call void @__dp_write(i32 16402, i64 %27, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.31, i32 0, i32 0))
  store double 1.000000e+00, double* %arrayidx, align 8, !dbg !314
  call void @__dp_report_bb(i32 13)
  %28 = load i32, i32* %__dp_bb, align 4
  call void @__dp_report_bb_pair(i32 %28, i32 26)
  br label %for.inc, !dbg !315

for.inc:                                          ; preds = %for.body
  %29 = ptrtoint i32* %i to i64
  %30 = load i32, i32* %i, align 4, !dbg !316
  %inc = add nsw i32 %30, 1, !dbg !316
  %31 = ptrtoint i32* %i to i64
  store i32 %inc, i32* %i, align 4, !dbg !316
  call void @__dp_report_bb(i32 12)
  %32 = load i32, i32* %__dp_bb, align 4
  call void @__dp_report_bb_pair(i32 %32, i32 25)
  store i32 1, i32* %__dp_bb, align 4
  br label %for.cond, !dbg !317, !llvm.loop !318

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16404, i32 1)
  call void @llvm.dbg.declare(metadata i32* %k, metadata !320, metadata !DIExpression()), !dbg !322
  %33 = ptrtoint i32* %k to i64
  store i32 0, i32* %k, align 4, !dbg !322
  call void @__dp_report_bb(i32 10)
  br label %for.cond1, !dbg !323

for.cond1:                                        ; preds = %for.inc27, %for.end
  call void @__dp_loop_entry(i32 16404, i32 2)
  %34 = ptrtoint i32* %k to i64
  %35 = load i32, i32* %k, align 4, !dbg !324
  %cmp2 = icmp slt i32 %35, 20, !dbg !326
  call void @__dp_incr_taken_branch_counter(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.8, i32 0, i32 0), i1 %cmp2, i32 1), !dbg !327
  call void @__dp_incr_taken_branch_counter(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.9, i32 0, i32 0), i1 %cmp2, i32 0), !dbg !327
  call void @__dp_report_bb(i32 15)
  %36 = load i32, i32* %__dp_bb30, align 4
  call void @__dp_report_bb_pair(i32 %36, i32 27)
  br i1 %cmp2, label %for.body3, label %for.end29, !dbg !327

for.body3:                                        ; preds = %for.cond1
  call void @__dp_loop_incr(i32 2)
  call void @llvm.dbg.declare(metadata i32* %j, metadata !328, metadata !DIExpression()), !dbg !331
  %37 = ptrtoint i32* %j to i64
  store i32 0, i32* %j, align 4, !dbg !331
  call void @__dp_report_bb(i32 17)
  %38 = load i32, i32* %__dp_bb32, align 4
  call void @__dp_report_bb_pair(i32 %38, i32 31)
  br label %for.cond4, !dbg !332

for.cond4:                                        ; preds = %for.inc24, %for.body3
  call void @__dp_loop_entry(i32 16405, i32 3)
  %39 = ptrtoint i32* %j to i64
  %40 = load i32, i32* %j, align 4, !dbg !333
  %cmp5 = icmp slt i32 %40, 20, !dbg !335
  call void @__dp_incr_taken_branch_counter(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.10, i32 0, i32 0), i1 %cmp5, i32 1), !dbg !336
  call void @__dp_incr_taken_branch_counter(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.11, i32 0, i32 0), i1 %cmp5, i32 0), !dbg !336
  call void @__dp_report_bb(i32 19)
  store i32 1, i32* %__dp_bb32, align 4
  %41 = load i32, i32* %__dp_bb33, align 4
  call void @__dp_report_bb_pair(i32 %41, i32 33)
  br i1 %cmp5, label %for.body6, label %for.end26, !dbg !336

for.body6:                                        ; preds = %for.cond4
  call void @__dp_loop_incr(i32 3)
  call void @llvm.dbg.declare(metadata i32* %i7, metadata !337, metadata !DIExpression()), !dbg !340
  %42 = ptrtoint i32* %i7 to i64
  store i32 0, i32* %i7, align 4, !dbg !340
  call void @__dp_report_bb(i32 21)
  %43 = load i32, i32* %__dp_bb34, align 4
  call void @__dp_report_bb_pair(i32 %43, i32 35)
  br label %for.cond8, !dbg !341

for.cond8:                                        ; preds = %for.inc21, %for.body6
  call void @__dp_loop_entry(i32 16406, i32 4)
  %44 = ptrtoint i32* %i7 to i64
  %45 = load i32, i32* %i7, align 4, !dbg !342
  %46 = ptrtoint i32* @_ZZ4mainE1n to i64
  call void @__dp_read(i32 16406, i64 %46, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.14, i32 0, i32 0))
  %47 = load i32, i32* @_ZZ4mainE1n, align 4, !dbg !344
  %div = sdiv i32 %47, 400, !dbg !345
  %cmp9 = icmp slt i32 %45, %div, !dbg !346
  call void @__dp_incr_taken_branch_counter(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.12, i32 0, i32 0), i1 %cmp9, i32 1), !dbg !347
  call void @__dp_incr_taken_branch_counter(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.13, i32 0, i32 0), i1 %cmp9, i32 0), !dbg !347
  call void @__dp_report_bb(i32 22)
  store i32 1, i32* %__dp_bb34, align 4
  %48 = load i32, i32* %__dp_bb35, align 4
  call void @__dp_report_bb_pair(i32 %48, i32 37)
  br i1 %cmp9, label %for.body10, label %for.end23, !dbg !347

for.body10:                                       ; preds = %for.cond8
  call void @__dp_loop_incr(i32 4)
  call void @llvm.dbg.declare(metadata i32* %sum, metadata !348, metadata !DIExpression()), !dbg !350
  %49 = ptrtoint double** %x to i64
  %50 = load double*, double** %x, align 8, !dbg !351
  %51 = ptrtoint i32* %k to i64
  %52 = load i32, i32* %k, align 4, !dbg !352
  %53 = ptrtoint i32* @_ZZ4mainE1n to i64
  call void @__dp_read(i32 16407, i64 %53, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.14, i32 0, i32 0))
  %54 = load i32, i32* @_ZZ4mainE1n, align 4, !dbg !353
  %div11 = sdiv i32 %54, 20, !dbg !354
  %mul12 = mul nsw i32 %52, %div11, !dbg !355
  %idx.ext = sext i32 %mul12 to i64, !dbg !356
  %add.ptr = getelementptr inbounds double, double* %50, i64 %idx.ext, !dbg !356
  %55 = ptrtoint i32* %j to i64
  %56 = load i32, i32* %j, align 4, !dbg !357
  %57 = ptrtoint i32* @_ZZ4mainE1n to i64
  call void @__dp_read(i32 16407, i64 %57, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.14, i32 0, i32 0))
  %58 = load i32, i32* @_ZZ4mainE1n, align 4, !dbg !358
  %div13 = sdiv i32 %58, 400, !dbg !359
  %mul14 = mul nsw i32 %56, %div13, !dbg !360
  %idx.ext15 = sext i32 %mul14 to i64, !dbg !361
  %add.ptr16 = getelementptr inbounds double, double* %add.ptr, i64 %idx.ext15, !dbg !361
  %59 = ptrtoint i32* %i7 to i64
  %60 = load i32, i32* %i7, align 4, !dbg !362
  %idx.ext17 = sext i32 %60 to i64, !dbg !363
  %add.ptr18 = getelementptr inbounds double, double* %add.ptr16, i64 %idx.ext17, !dbg !363
  %61 = ptrtoint i32* @_ZZ4mainE1n to i64
  call void @__dp_read(i32 16407, i64 %61, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.14, i32 0, i32 0))
  %62 = load i32, i32* @_ZZ4mainE1n, align 4, !dbg !364
  %div19 = sdiv i32 %62, 400, !dbg !365
  %63 = ptrtoint i32* %i7 to i64
  %64 = load i32, i32* %i7, align 4, !dbg !366
  %sub = sub nsw i32 %div19, %64, !dbg !367
  call void @__dp_call(i32 16407), !dbg !368
  %call20 = call i32 @_Z14allowing_doallPdi(double* %add.ptr18, i32 %sub), !dbg !368
  %65 = ptrtoint i32* %sum to i64
  store i32 %call20, i32* %sum, align 4, !dbg !350
  call void @__dp_report_bb(i32 18)
  %66 = load i32, i32* %__dp_bb30, align 4
  call void @__dp_report_bb_pair(i32 %66, i32 29)
  %67 = load i32, i32* %__dp_bb31, align 4
  call void @__dp_report_bb_pair(i32 %67, i32 30)
  store i32 1, i32* %__dp_bb31, align 4
  %68 = load i32, i32* %__dp_bb33, align 4
  call void @__dp_report_bb_pair(i32 %68, i32 32)
  %69 = load i32, i32* %__dp_bb35, align 4
  call void @__dp_report_bb_pair(i32 %69, i32 36)
  br label %for.inc21, !dbg !369

for.inc21:                                        ; preds = %for.body10
  %70 = ptrtoint i32* %i7 to i64
  %71 = load i32, i32* %i7, align 4, !dbg !370
  %inc22 = add nsw i32 %71, 1, !dbg !370
  %72 = ptrtoint i32* %i7 to i64
  store i32 %inc22, i32* %i7, align 4, !dbg !370
  call void @__dp_report_bb(i32 23)
  %73 = load i32, i32* %__dp_bb35, align 4
  call void @__dp_report_bb_pair(i32 %73, i32 38)
  store i32 1, i32* %__dp_bb35, align 4
  br label %for.cond8, !dbg !371, !llvm.loop !372

for.end23:                                        ; preds = %for.cond8
  call void @__dp_loop_exit(i32 16409, i32 4)
  br label %for.inc24, !dbg !374

for.inc24:                                        ; preds = %for.end23
  %74 = ptrtoint i32* %j to i64
  %75 = load i32, i32* %j, align 4, !dbg !375
  %inc25 = add nsw i32 %75, 1, !dbg !375
  %76 = ptrtoint i32* %j to i64
  store i32 %inc25, i32* %j, align 4, !dbg !375
  call void @__dp_report_bb(i32 20)
  %77 = load i32, i32* %__dp_bb33, align 4
  call void @__dp_report_bb_pair(i32 %77, i32 34)
  store i32 1, i32* %__dp_bb33, align 4
  br label %for.cond4, !dbg !376, !llvm.loop !377

for.end26:                                        ; preds = %for.cond4
  call void @__dp_loop_exit(i32 16410, i32 3)
  br label %for.inc27, !dbg !379

for.inc27:                                        ; preds = %for.end26
  %78 = ptrtoint i32* %k to i64
  %79 = load i32, i32* %k, align 4, !dbg !380
  %inc28 = add nsw i32 %79, 1, !dbg !380
  %80 = ptrtoint i32* %k to i64
  store i32 %inc28, i32* %k, align 4, !dbg !380
  call void @__dp_report_bb(i32 16)
  %81 = load i32, i32* %__dp_bb30, align 4
  call void @__dp_report_bb_pair(i32 %81, i32 28)
  store i32 1, i32* %__dp_bb30, align 4
  br label %for.cond1, !dbg !381, !llvm.loop !382

for.end29:                                        ; preds = %for.cond1
  call void @__dp_loop_exit(i32 16412, i32 2)
  %82 = ptrtoint double** %x to i64
  %83 = load double*, double** %x, align 8, !dbg !384
  %84 = bitcast double* %83 to i8*, !dbg !384
  call void @free(i8* %84) #4, !dbg !385
  %85 = ptrtoint i8* %84 to i64
  call void @__dp_delete(i32 16412, i64 %85), !dbg !386
  call void @__dp_report_bb(i32 14)
  call void @__dp_finalize(i32 16413), !dbg !386
  call void @__dp_loop_output(), !dbg !386
  call void @__dp_taken_branch_counter_output(), !dbg !386
  ret i32 0, !dbg !386
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64) #3

; Function Attrs: nounwind
declare void @free(i8*) #3

declare void @__dp_init(i32, i32, i32)

declare void @__dp_finalize(i32)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_write(i32, i64, i8*)

declare void @__dp_alloca(i32, i8*, i64, i64, i64, i64)

declare void @__dp_new(i32, i64, i64, i64)

declare void @__dp_delete(i32, i64)

declare void @__dp_call(i32)

declare void @__dp_func_entry(i32, i32)

declare void @__dp_func_exit(i32, i32)

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_loop_exit(i32, i32)

declare void @__dp_incr_taken_branch_counter(i8*, i32, i32)

declare void @__dp_report_bb(i32)

declare void @__dp_report_bb_pair(i32, i32)

declare void @__dp_loop_incr(i32)

declare void @__dp_loop_output()

declare void @__dp_taken_branch_counter_output()

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { noinline norecurse nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!11}
!llvm.module.flags = !{!258, !259, !260, !261}
!llvm.ident = !{!262}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "n", scope: !2, file: !3, line: 13, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 12, type: !4, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !11, retainedNodes: !12)
!3 = !DIFile(filename: "code.cpp", directory: "/home/lukas/git/discopop/test/end_to_end/do_all/calls/above_nesting_level_3/src")
!4 = !DISubroutineType(types: !5)
!5 = !{!6, !6, !7}
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 64)
!9 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !10)
!10 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!11 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !3, producer: "clang version 11.1.0 (https://github.com/llvm/llvm-project.git 7e99bddfeaab2713a8bb6ca538da25b66e6efc59)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !12, retainedTypes: !13, globals: !16, imports: !17, splitDebugInlining: false, nameTableKind: None)
!12 = !{}
!13 = !{!14}
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!15 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!16 = !{!0}
!17 = !{!18, !25, !29, !36, !40, !45, !47, !51, !55, !59, !73, !77, !81, !85, !89, !94, !98, !102, !106, !110, !118, !122, !126, !128, !132, !136, !141, !147, !151, !155, !157, !165, !169, !177, !179, !183, !187, !191, !195, !200, !205, !210, !211, !212, !213, !215, !216, !217, !218, !219, !220, !221, !223, !224, !225, !226, !227, !228, !229, !234, !235, !236, !237, !238, !239, !240, !241, !242, !243, !244, !245, !246, !247, !248, !249, !250, !251, !252, !253, !254, !255, !256, !257}
!18 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !20, file: !24, line: 52)
!19 = !DINamespace(name: "std", scope: null)
!20 = !DISubprogram(name: "abs", scope: !21, file: !21, line: 848, type: !22, flags: DIFlagPrototyped, spFlags: 0)
!21 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!22 = !DISubroutineType(types: !23)
!23 = !{!6, !6}
!24 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/12/../../../../include/c++/12/bits/std_abs.h", directory: "")
!25 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !26, file: !28, line: 127)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !21, line: 63, baseType: !27)
!27 = !DICompositeType(tag: DW_TAG_structure_type, file: !21, line: 59, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!28 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/12/../../../../include/c++/12/cstdlib", directory: "")
!29 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !30, file: !28, line: 128)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !21, line: 71, baseType: !31)
!31 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !21, line: 67, size: 128, flags: DIFlagTypePassByValue, elements: !32, identifier: "_ZTS6ldiv_t")
!32 = !{!33, !35}
!33 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !31, file: !21, line: 69, baseType: !34, size: 64)
!34 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !31, file: !21, line: 70, baseType: !34, size: 64, offset: 64)
!36 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !37, file: !28, line: 130)
!37 = !DISubprogram(name: "abort", scope: !21, file: !21, line: 598, type: !38, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!38 = !DISubroutineType(types: !39)
!39 = !{null}
!40 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !41, file: !28, line: 134)
!41 = !DISubprogram(name: "atexit", scope: !21, file: !21, line: 602, type: !42, flags: DIFlagPrototyped, spFlags: 0)
!42 = !DISubroutineType(types: !43)
!43 = !{!6, !44}
!44 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !38, size: 64)
!45 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !46, file: !28, line: 137)
!46 = !DISubprogram(name: "at_quick_exit", scope: !21, file: !21, line: 607, type: !42, flags: DIFlagPrototyped, spFlags: 0)
!47 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !48, file: !28, line: 140)
!48 = !DISubprogram(name: "atof", scope: !21, file: !21, line: 102, type: !49, flags: DIFlagPrototyped, spFlags: 0)
!49 = !DISubroutineType(types: !50)
!50 = !{!15, !8}
!51 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !52, file: !28, line: 141)
!52 = !DISubprogram(name: "atoi", scope: !21, file: !21, line: 105, type: !53, flags: DIFlagPrototyped, spFlags: 0)
!53 = !DISubroutineType(types: !54)
!54 = !{!6, !8}
!55 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !56, file: !28, line: 142)
!56 = !DISubprogram(name: "atol", scope: !21, file: !21, line: 108, type: !57, flags: DIFlagPrototyped, spFlags: 0)
!57 = !DISubroutineType(types: !58)
!58 = !{!34, !8}
!59 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !60, file: !28, line: 143)
!60 = !DISubprogram(name: "bsearch", scope: !21, file: !21, line: 828, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!61 = !DISubroutineType(types: !62)
!62 = !{!63, !64, !64, !66, !66, !69}
!63 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !65, size: 64)
!65 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!66 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !67, line: 46, baseType: !68)
!67 = !DIFile(filename: "Software/llvm-11.1.0/lib/clang/11.1.0/include/stddef.h", directory: "/home/lukas")
!68 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!69 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !21, line: 816, baseType: !70)
!70 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !71, size: 64)
!71 = !DISubroutineType(types: !72)
!72 = !{!6, !64, !64}
!73 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !74, file: !28, line: 144)
!74 = !DISubprogram(name: "calloc", scope: !21, file: !21, line: 543, type: !75, flags: DIFlagPrototyped, spFlags: 0)
!75 = !DISubroutineType(types: !76)
!76 = !{!63, !66, !66}
!77 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !78, file: !28, line: 145)
!78 = !DISubprogram(name: "div", scope: !21, file: !21, line: 860, type: !79, flags: DIFlagPrototyped, spFlags: 0)
!79 = !DISubroutineType(types: !80)
!80 = !{!26, !6, !6}
!81 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !82, file: !28, line: 146)
!82 = !DISubprogram(name: "exit", scope: !21, file: !21, line: 624, type: !83, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!83 = !DISubroutineType(types: !84)
!84 = !{null, !6}
!85 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !86, file: !28, line: 147)
!86 = !DISubprogram(name: "free", scope: !21, file: !21, line: 555, type: !87, flags: DIFlagPrototyped, spFlags: 0)
!87 = !DISubroutineType(types: !88)
!88 = !{null, !63}
!89 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !90, file: !28, line: 148)
!90 = !DISubprogram(name: "getenv", scope: !21, file: !21, line: 641, type: !91, flags: DIFlagPrototyped, spFlags: 0)
!91 = !DISubroutineType(types: !92)
!92 = !{!93, !8}
!93 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!94 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !95, file: !28, line: 149)
!95 = !DISubprogram(name: "labs", scope: !21, file: !21, line: 849, type: !96, flags: DIFlagPrototyped, spFlags: 0)
!96 = !DISubroutineType(types: !97)
!97 = !{!34, !34}
!98 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !99, file: !28, line: 150)
!99 = !DISubprogram(name: "ldiv", scope: !21, file: !21, line: 862, type: !100, flags: DIFlagPrototyped, spFlags: 0)
!100 = !DISubroutineType(types: !101)
!101 = !{!30, !34, !34}
!102 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !103, file: !28, line: 151)
!103 = !DISubprogram(name: "malloc", scope: !21, file: !21, line: 540, type: !104, flags: DIFlagPrototyped, spFlags: 0)
!104 = !DISubroutineType(types: !105)
!105 = !{!63, !66}
!106 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !107, file: !28, line: 153)
!107 = !DISubprogram(name: "mblen", scope: !21, file: !21, line: 930, type: !108, flags: DIFlagPrototyped, spFlags: 0)
!108 = !DISubroutineType(types: !109)
!109 = !{!6, !8, !66}
!110 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !111, file: !28, line: 154)
!111 = !DISubprogram(name: "mbstowcs", scope: !21, file: !21, line: 941, type: !112, flags: DIFlagPrototyped, spFlags: 0)
!112 = !DISubroutineType(types: !113)
!113 = !{!66, !114, !117, !66}
!114 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !115)
!115 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !116, size: 64)
!116 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!117 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !8)
!118 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !119, file: !28, line: 155)
!119 = !DISubprogram(name: "mbtowc", scope: !21, file: !21, line: 933, type: !120, flags: DIFlagPrototyped, spFlags: 0)
!120 = !DISubroutineType(types: !121)
!121 = !{!6, !114, !117, !66}
!122 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !123, file: !28, line: 157)
!123 = !DISubprogram(name: "qsort", scope: !21, file: !21, line: 838, type: !124, flags: DIFlagPrototyped, spFlags: 0)
!124 = !DISubroutineType(types: !125)
!125 = !{null, !63, !66, !66, !69}
!126 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !127, file: !28, line: 160)
!127 = !DISubprogram(name: "quick_exit", scope: !21, file: !21, line: 630, type: !83, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!128 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !129, file: !28, line: 163)
!129 = !DISubprogram(name: "rand", scope: !21, file: !21, line: 454, type: !130, flags: DIFlagPrototyped, spFlags: 0)
!130 = !DISubroutineType(types: !131)
!131 = !{!6}
!132 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !133, file: !28, line: 164)
!133 = !DISubprogram(name: "realloc", scope: !21, file: !21, line: 551, type: !134, flags: DIFlagPrototyped, spFlags: 0)
!134 = !DISubroutineType(types: !135)
!135 = !{!63, !63, !66}
!136 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !137, file: !28, line: 165)
!137 = !DISubprogram(name: "srand", scope: !21, file: !21, line: 456, type: !138, flags: DIFlagPrototyped, spFlags: 0)
!138 = !DISubroutineType(types: !139)
!139 = !{null, !140}
!140 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!141 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !142, file: !28, line: 166)
!142 = !DISubprogram(name: "strtod", scope: !21, file: !21, line: 118, type: !143, flags: DIFlagPrototyped, spFlags: 0)
!143 = !DISubroutineType(types: !144)
!144 = !{!15, !117, !145}
!145 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !146)
!146 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !93, size: 64)
!147 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !148, file: !28, line: 167)
!148 = !DISubprogram(name: "strtol", scope: !21, file: !21, line: 177, type: !149, flags: DIFlagPrototyped, spFlags: 0)
!149 = !DISubroutineType(types: !150)
!150 = !{!34, !117, !145, !6}
!151 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !152, file: !28, line: 168)
!152 = !DISubprogram(name: "strtoul", scope: !21, file: !21, line: 181, type: !153, flags: DIFlagPrototyped, spFlags: 0)
!153 = !DISubroutineType(types: !154)
!154 = !{!68, !117, !145, !6}
!155 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !156, file: !28, line: 169)
!156 = !DISubprogram(name: "system", scope: !21, file: !21, line: 791, type: !53, flags: DIFlagPrototyped, spFlags: 0)
!157 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !158, file: !28, line: 171)
!158 = !DISubprogram(name: "wcstombs", scope: !21, file: !21, line: 945, type: !159, flags: DIFlagPrototyped, spFlags: 0)
!159 = !DISubroutineType(types: !160)
!160 = !{!66, !161, !162, !66}
!161 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !93)
!162 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !163)
!163 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !164, size: 64)
!164 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !116)
!165 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !166, file: !28, line: 172)
!166 = !DISubprogram(name: "wctomb", scope: !21, file: !21, line: 937, type: !167, flags: DIFlagPrototyped, spFlags: 0)
!167 = !DISubroutineType(types: !168)
!168 = !{!6, !93, !116}
!169 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !170, entity: !171, file: !28, line: 200)
!170 = !DINamespace(name: "__gnu_cxx", scope: null)
!171 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !21, line: 81, baseType: !172)
!172 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !21, line: 77, size: 128, flags: DIFlagTypePassByValue, elements: !173, identifier: "_ZTS7lldiv_t")
!173 = !{!174, !176}
!174 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !172, file: !21, line: 79, baseType: !175, size: 64)
!175 = !DIBasicType(name: "long long int", size: 64, encoding: DW_ATE_signed)
!176 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !172, file: !21, line: 80, baseType: !175, size: 64, offset: 64)
!177 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !170, entity: !178, file: !28, line: 206)
!178 = !DISubprogram(name: "_Exit", scope: !21, file: !21, line: 636, type: !83, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!179 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !170, entity: !180, file: !28, line: 210)
!180 = !DISubprogram(name: "llabs", scope: !21, file: !21, line: 852, type: !181, flags: DIFlagPrototyped, spFlags: 0)
!181 = !DISubroutineType(types: !182)
!182 = !{!175, !175}
!183 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !170, entity: !184, file: !28, line: 216)
!184 = !DISubprogram(name: "lldiv", scope: !21, file: !21, line: 866, type: !185, flags: DIFlagPrototyped, spFlags: 0)
!185 = !DISubroutineType(types: !186)
!186 = !{!171, !175, !175}
!187 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !170, entity: !188, file: !28, line: 227)
!188 = !DISubprogram(name: "atoll", scope: !21, file: !21, line: 113, type: !189, flags: DIFlagPrototyped, spFlags: 0)
!189 = !DISubroutineType(types: !190)
!190 = !{!175, !8}
!191 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !170, entity: !192, file: !28, line: 228)
!192 = !DISubprogram(name: "strtoll", scope: !21, file: !21, line: 201, type: !193, flags: DIFlagPrototyped, spFlags: 0)
!193 = !DISubroutineType(types: !194)
!194 = !{!175, !117, !145, !6}
!195 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !170, entity: !196, file: !28, line: 229)
!196 = !DISubprogram(name: "strtoull", scope: !21, file: !21, line: 206, type: !197, flags: DIFlagPrototyped, spFlags: 0)
!197 = !DISubroutineType(types: !198)
!198 = !{!199, !117, !145, !6}
!199 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!200 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !170, entity: !201, file: !28, line: 231)
!201 = !DISubprogram(name: "strtof", scope: !21, file: !21, line: 124, type: !202, flags: DIFlagPrototyped, spFlags: 0)
!202 = !DISubroutineType(types: !203)
!203 = !{!204, !117, !145}
!204 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!205 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !170, entity: !206, file: !28, line: 232)
!206 = !DISubprogram(name: "strtold", scope: !21, file: !21, line: 127, type: !207, flags: DIFlagPrototyped, spFlags: 0)
!207 = !DISubroutineType(types: !208)
!208 = !{!209, !117, !145}
!209 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!210 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !171, file: !28, line: 240)
!211 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !178, file: !28, line: 242)
!212 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !180, file: !28, line: 244)
!213 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !214, file: !28, line: 245)
!214 = !DISubprogram(name: "div", linkageName: "_ZN9__gnu_cxx3divExx", scope: !170, file: !28, line: 213, type: !185, flags: DIFlagPrototyped, spFlags: 0)
!215 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !184, file: !28, line: 246)
!216 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !188, file: !28, line: 248)
!217 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !201, file: !28, line: 249)
!218 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !192, file: !28, line: 250)
!219 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !196, file: !28, line: 251)
!220 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !206, file: !28, line: 252)
!221 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !37, file: !222, line: 38)
!222 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/12/../../../../include/c++/12/stdlib.h", directory: "")
!223 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !41, file: !222, line: 39)
!224 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !82, file: !222, line: 40)
!225 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !46, file: !222, line: 43)
!226 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !127, file: !222, line: 46)
!227 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !26, file: !222, line: 51)
!228 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !30, file: !222, line: 52)
!229 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !230, file: !222, line: 54)
!230 = !DISubprogram(name: "abs", linkageName: "_ZSt3absg", scope: !19, file: !24, line: 103, type: !231, flags: DIFlagPrototyped, spFlags: 0)
!231 = !DISubroutineType(types: !232)
!232 = !{!233, !233}
!233 = !DIBasicType(name: "__float128", size: 128, encoding: DW_ATE_float)
!234 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !48, file: !222, line: 55)
!235 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !52, file: !222, line: 56)
!236 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !56, file: !222, line: 57)
!237 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !60, file: !222, line: 58)
!238 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !74, file: !222, line: 59)
!239 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !214, file: !222, line: 60)
!240 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !86, file: !222, line: 61)
!241 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !90, file: !222, line: 62)
!242 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !95, file: !222, line: 63)
!243 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !99, file: !222, line: 64)
!244 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !103, file: !222, line: 65)
!245 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !107, file: !222, line: 67)
!246 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !111, file: !222, line: 68)
!247 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !119, file: !222, line: 69)
!248 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !123, file: !222, line: 71)
!249 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !129, file: !222, line: 72)
!250 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !133, file: !222, line: 73)
!251 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !137, file: !222, line: 74)
!252 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !142, file: !222, line: 75)
!253 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !148, file: !222, line: 76)
!254 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !152, file: !222, line: 77)
!255 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !156, file: !222, line: 78)
!256 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !158, file: !222, line: 80)
!257 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !166, file: !222, line: 81)
!258 = !{i32 7, !"Dwarf Version", i32 4}
!259 = !{i32 2, !"Debug Info Version", i32 3}
!260 = !{i32 1, !"wchar_size", i32 4}
!261 = !{i32 7, !"PIC Level", i32 2}
!262 = !{!"clang version 11.1.0 (https://github.com/llvm/llvm-project.git 7e99bddfeaab2713a8bb6ca538da25b66e6efc59)"}
!263 = distinct !DISubprogram(name: "allowing_doall", linkageName: "_Z14allowing_doallPdi", scope: !3, file: !3, line: 4, type: !264, scopeLine: 4, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !11, retainedNodes: !12)
!264 = !DISubroutineType(types: !265)
!265 = !{!6, !14, !6}
!266 = !DILocalVariable(name: "tmp", arg: 1, scope: !263, file: !3, line: 4, type: !14)
!267 = !DILocation(line: 4, column: 27, scope: !263)
!268 = !DILocalVariable(name: "i", arg: 2, scope: !263, file: !3, line: 4, type: !6)
!269 = !DILocation(line: 4, column: 38, scope: !263)
!270 = !DILocalVariable(name: "sum", scope: !263, file: !3, line: 5, type: !6)
!271 = !DILocation(line: 5, column: 7, scope: !263)
!272 = !DILocalVariable(name: "n", scope: !273, file: !3, line: 6, type: !6)
!273 = distinct !DILexicalBlock(scope: !263, file: !3, line: 6, column: 3)
!274 = !DILocation(line: 6, column: 12, scope: !273)
!275 = !DILocation(line: 6, column: 8, scope: !273)
!276 = !DILocation(line: 6, column: 19, scope: !277)
!277 = distinct !DILexicalBlock(scope: !273, file: !3, line: 6, column: 3)
!278 = !DILocation(line: 6, column: 23, scope: !277)
!279 = !DILocation(line: 6, column: 21, scope: !277)
!280 = !DILocation(line: 6, column: 3, scope: !273)
!281 = !DILocation(line: 7, column: 11, scope: !282)
!282 = distinct !DILexicalBlock(scope: !277, file: !3, line: 6, column: 31)
!283 = !DILocation(line: 7, column: 15, scope: !282)
!284 = !DILocation(line: 7, column: 9, scope: !282)
!285 = !DILocation(line: 8, column: 3, scope: !282)
!286 = !DILocation(line: 6, column: 27, scope: !277)
!287 = !DILocation(line: 6, column: 3, scope: !277)
!288 = distinct !{!288, !280, !289}
!289 = !DILocation(line: 8, column: 3, scope: !273)
!290 = !DILocation(line: 9, column: 10, scope: !263)
!291 = !DILocation(line: 9, column: 3, scope: !263)
!292 = !DILocalVariable(name: "argc", arg: 1, scope: !2, file: !3, line: 12, type: !6)
!293 = !DILocation(line: 12, column: 14, scope: !2)
!294 = !DILocalVariable(name: "argv", arg: 2, scope: !2, file: !3, line: 12, type: !7)
!295 = !DILocation(line: 12, column: 32, scope: !2)
!296 = !DILocalVariable(name: "x", scope: !2, file: !3, line: 14, type: !14)
!297 = !DILocation(line: 14, column: 11, scope: !2)
!298 = !DILocation(line: 14, column: 32, scope: !2)
!299 = !DILocation(line: 14, column: 34, scope: !2)
!300 = !DILocation(line: 14, column: 25, scope: !2)
!301 = !DILocation(line: 14, column: 15, scope: !2)
!302 = !DILocalVariable(name: "i", scope: !303, file: !3, line: 17, type: !6)
!303 = distinct !DILexicalBlock(scope: !2, file: !3, line: 17, column: 3)
!304 = !DILocation(line: 17, column: 12, scope: !303)
!305 = !DILocation(line: 17, column: 8, scope: !303)
!306 = !DILocation(line: 17, column: 19, scope: !307)
!307 = distinct !DILexicalBlock(scope: !303, file: !3, line: 17, column: 3)
!308 = !DILocation(line: 17, column: 23, scope: !307)
!309 = !DILocation(line: 17, column: 21, scope: !307)
!310 = !DILocation(line: 17, column: 3, scope: !303)
!311 = !DILocation(line: 18, column: 5, scope: !312)
!312 = distinct !DILexicalBlock(scope: !307, file: !3, line: 17, column: 31)
!313 = !DILocation(line: 18, column: 7, scope: !312)
!314 = !DILocation(line: 18, column: 10, scope: !312)
!315 = !DILocation(line: 19, column: 3, scope: !312)
!316 = !DILocation(line: 17, column: 27, scope: !307)
!317 = !DILocation(line: 17, column: 3, scope: !307)
!318 = distinct !{!318, !310, !319}
!319 = !DILocation(line: 19, column: 3, scope: !303)
!320 = !DILocalVariable(name: "k", scope: !321, file: !3, line: 20, type: !6)
!321 = distinct !DILexicalBlock(scope: !2, file: !3, line: 20, column: 3)
!322 = !DILocation(line: 20, column: 12, scope: !321)
!323 = !DILocation(line: 20, column: 8, scope: !321)
!324 = !DILocation(line: 20, column: 19, scope: !325)
!325 = distinct !DILexicalBlock(scope: !321, file: !3, line: 20, column: 3)
!326 = !DILocation(line: 20, column: 21, scope: !325)
!327 = !DILocation(line: 20, column: 3, scope: !321)
!328 = !DILocalVariable(name: "j", scope: !329, file: !3, line: 21, type: !6)
!329 = distinct !DILexicalBlock(scope: !330, file: !3, line: 21, column: 5)
!330 = distinct !DILexicalBlock(scope: !325, file: !3, line: 20, column: 32)
!331 = !DILocation(line: 21, column: 14, scope: !329)
!332 = !DILocation(line: 21, column: 10, scope: !329)
!333 = !DILocation(line: 21, column: 21, scope: !334)
!334 = distinct !DILexicalBlock(scope: !329, file: !3, line: 21, column: 5)
!335 = !DILocation(line: 21, column: 23, scope: !334)
!336 = !DILocation(line: 21, column: 5, scope: !329)
!337 = !DILocalVariable(name: "i", scope: !338, file: !3, line: 22, type: !6)
!338 = distinct !DILexicalBlock(scope: !339, file: !3, line: 22, column: 7)
!339 = distinct !DILexicalBlock(scope: !334, file: !3, line: 21, column: 34)
!340 = !DILocation(line: 22, column: 16, scope: !338)
!341 = !DILocation(line: 22, column: 12, scope: !338)
!342 = !DILocation(line: 22, column: 23, scope: !343)
!343 = distinct !DILexicalBlock(scope: !338, file: !3, line: 22, column: 7)
!344 = !DILocation(line: 22, column: 27, scope: !343)
!345 = !DILocation(line: 22, column: 29, scope: !343)
!346 = !DILocation(line: 22, column: 25, scope: !343)
!347 = !DILocation(line: 22, column: 7, scope: !338)
!348 = !DILocalVariable(name: "sum", scope: !349, file: !3, line: 23, type: !6)
!349 = distinct !DILexicalBlock(scope: !343, file: !3, line: 22, column: 47)
!350 = !DILocation(line: 23, column: 13, scope: !349)
!351 = !DILocation(line: 23, column: 34, scope: !349)
!352 = !DILocation(line: 23, column: 38, scope: !349)
!353 = !DILocation(line: 23, column: 43, scope: !349)
!354 = !DILocation(line: 23, column: 45, scope: !349)
!355 = !DILocation(line: 23, column: 40, scope: !349)
!356 = !DILocation(line: 23, column: 36, scope: !349)
!357 = !DILocation(line: 23, column: 53, scope: !349)
!358 = !DILocation(line: 23, column: 58, scope: !349)
!359 = !DILocation(line: 23, column: 60, scope: !349)
!360 = !DILocation(line: 23, column: 55, scope: !349)
!361 = !DILocation(line: 23, column: 51, scope: !349)
!362 = !DILocation(line: 23, column: 75, scope: !349)
!363 = !DILocation(line: 23, column: 73, scope: !349)
!364 = !DILocation(line: 23, column: 79, scope: !349)
!365 = !DILocation(line: 23, column: 81, scope: !349)
!366 = !DILocation(line: 23, column: 96, scope: !349)
!367 = !DILocation(line: 23, column: 94, scope: !349)
!368 = !DILocation(line: 23, column: 19, scope: !349)
!369 = !DILocation(line: 24, column: 7, scope: !349)
!370 = !DILocation(line: 22, column: 42, scope: !343)
!371 = !DILocation(line: 22, column: 7, scope: !343)
!372 = distinct !{!372, !347, !373}
!373 = !DILocation(line: 24, column: 7, scope: !338)
!374 = !DILocation(line: 25, column: 5, scope: !339)
!375 = !DILocation(line: 21, column: 30, scope: !334)
!376 = !DILocation(line: 21, column: 5, scope: !334)
!377 = distinct !{!377, !336, !378}
!378 = !DILocation(line: 25, column: 5, scope: !329)
!379 = !DILocation(line: 26, column: 3, scope: !330)
!380 = !DILocation(line: 20, column: 28, scope: !325)
!381 = !DILocation(line: 20, column: 3, scope: !325)
!382 = distinct !{!382, !327, !383}
!383 = !DILocation(line: 26, column: 3, scope: !321)
!384 = !DILocation(line: 28, column: 8, scope: !2)
!385 = !DILocation(line: 28, column: 3, scope: !2)
!386 = !DILocation(line: 29, column: 3, scope: !2)
