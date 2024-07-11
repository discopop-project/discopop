; ModuleID = 'code.cpp'
source_filename = "code.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@_ZZ4mainE1n = internal global i32 5000, align 4, !dbg !0
@_ZZ4mainE1a = internal global double 2.000000e+00, align 8, !dbg !17
@.str = private unnamed_addr constant [5 x i8] c"base\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"offset_1\00", align 1
@.str.2 = private unnamed_addr constant [9 x i8] c"offset_2\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"n\00", align 1
@.str.5 = private unnamed_addr constant [10 x i8] c"1:19;1:20\00", align 1
@.str.6 = private unnamed_addr constant [10 x i8] c"1:19;1:22\00", align 1
@.str.7 = private unnamed_addr constant [10 x i8] c"1:24;1:25\00", align 1
@.str.8 = private unnamed_addr constant [10 x i8] c"1:24;1:28\00", align 1
@.str.9 = private unnamed_addr constant [10 x i8] c"1:30;1:31\00", align 1
@.str.10 = private unnamed_addr constant [10 x i8] c"1:30;1:34\00", align 1
@.str.11 = private unnamed_addr constant [12 x i8] c"_ZZ4mainE1n\00", align 1
@.str.12 = private unnamed_addr constant [12 x i8] c"_ZZ4mainE1a\00", align 1
@.str.13 = private unnamed_addr constant [5 x i8] c".str\00", align 1
@.str.14 = private unnamed_addr constant [7 x i8] c".str.1\00", align 1
@.str.15 = private unnamed_addr constant [7 x i8] c".str.2\00", align 1
@.str.16 = private unnamed_addr constant [7 x i8] c".str.3\00", align 1
@.str.17 = private unnamed_addr constant [7 x i8] c".str.4\00", align 1
@.str.18 = private unnamed_addr constant [7 x i8] c".str.5\00", align 1
@.str.19 = private unnamed_addr constant [7 x i8] c".str.6\00", align 1
@.str.20 = private unnamed_addr constant [7 x i8] c".str.7\00", align 1
@.str.21 = private unnamed_addr constant [7 x i8] c".str.8\00", align 1
@.str.22 = private unnamed_addr constant [7 x i8] c".str.9\00", align 1
@.str.23 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.24 = private unnamed_addr constant [5 x i8] c"argc\00", align 1
@.str.25 = private unnamed_addr constant [5 x i8] c"argv\00", align 1
@.str.26 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str.27 = private unnamed_addr constant [2 x i8] c"i\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define void @_Z19perform_calculationPdii(double* %base, i32 %offset_1, i32 %offset_2) #0 !dbg !265 {
entry:
  call void @__dp_func_entry(i32 16388, i32 0)
  %base.addr = alloca double*, align 8
  %0 = ptrtoint double** %base.addr to i64
  %offset_1.addr = alloca i32, align 4
  %1 = ptrtoint i32* %offset_1.addr to i64
  %offset_2.addr = alloca i32, align 4
  %2 = ptrtoint i32* %offset_2.addr to i64
  %3 = ptrtoint double** %base.addr to i64
  store double* %base, double** %base.addr, align 8
  call void @llvm.dbg.declare(metadata double** %base.addr, metadata !268, metadata !DIExpression()), !dbg !269
  %4 = ptrtoint i32* %offset_1.addr to i64
  store i32 %offset_1, i32* %offset_1.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %offset_1.addr, metadata !270, metadata !DIExpression()), !dbg !271
  %5 = ptrtoint i32* %offset_2.addr to i64
  store i32 %offset_2, i32* %offset_2.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %offset_2.addr, metadata !272, metadata !DIExpression()), !dbg !273
  %6 = ptrtoint double** %base.addr to i64
  %7 = load double*, double** %base.addr, align 8, !dbg !274
  %8 = ptrtoint i32* %offset_2.addr to i64
  %9 = load i32, i32* %offset_2.addr, align 4, !dbg !275
  %idxprom = sext i32 %9 to i64, !dbg !274
  %arrayidx = getelementptr inbounds double, double* %7, i64 %idxprom, !dbg !274
  %10 = ptrtoint double* %arrayidx to i64
  call void @__dp_read(i32 16388, i64 %10, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i32 0, i32 0))
  %11 = load double, double* %arrayidx, align 8, !dbg !274
  %add = fadd double 4.200000e+01, %11, !dbg !276
  %12 = ptrtoint double** %base.addr to i64
  %13 = load double*, double** %base.addr, align 8, !dbg !277
  %14 = ptrtoint i32* %offset_1.addr to i64
  %15 = load i32, i32* %offset_1.addr, align 4, !dbg !278
  %idxprom1 = sext i32 %15 to i64, !dbg !277
  %arrayidx2 = getelementptr inbounds double, double* %13, i64 %idxprom1, !dbg !277
  %16 = ptrtoint double* %arrayidx2 to i64
  call void @__dp_write(i32 16388, i64 %16, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i32 0, i32 0))
  store double %add, double* %arrayidx2, align 8, !dbg !279
  call void @__dp_report_bb(i32 0)
  call void @__dp_func_exit(i32 16388, i32 0), !dbg !280
  ret void, !dbg !280
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define void @_Z14doall_possiblePdi(double* %base, i32 %index) #0 !dbg !281 {
entry:
  call void @__dp_func_entry(i32 16390, i32 0)
  %base.addr = alloca double*, align 8
  %0 = ptrtoint double** %base.addr to i64
  %index.addr = alloca i32, align 4
  %1 = ptrtoint i32* %index.addr to i64
  %2 = ptrtoint double** %base.addr to i64
  store double* %base, double** %base.addr, align 8
  call void @llvm.dbg.declare(metadata double** %base.addr, metadata !284, metadata !DIExpression()), !dbg !285
  %3 = ptrtoint i32* %index.addr to i64
  store i32 %index, i32* %index.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %index.addr, metadata !286, metadata !DIExpression()), !dbg !287
  %4 = ptrtoint double** %base.addr to i64
  %5 = load double*, double** %base.addr, align 8, !dbg !288
  %6 = ptrtoint i32* %index.addr to i64
  %7 = load i32, i32* %index.addr, align 4, !dbg !289
  %8 = ptrtoint i32* %index.addr to i64
  %9 = load i32, i32* %index.addr, align 4, !dbg !290
  call void @__dp_call(i32 16390), !dbg !291
  call void @_Z19perform_calculationPdii(double* %5, i32 %7, i32 %9), !dbg !291
  call void @__dp_report_bb(i32 1)
  call void @__dp_func_exit(i32 16390, i32 0), !dbg !292
  ret void, !dbg !292
}

; Function Attrs: noinline nounwind optnone uwtable
define void @_Z18doall_not_possiblePdii(double* %base, i32 %index, i32 %n) #0 !dbg !293 {
entry:
  call void @__dp_func_entry(i32 16392, i32 0)
  %base.addr = alloca double*, align 8
  %0 = ptrtoint double** %base.addr to i64
  %index.addr = alloca i32, align 4
  %1 = ptrtoint i32* %index.addr to i64
  %n.addr = alloca i32, align 4
  %2 = ptrtoint i32* %n.addr to i64
  %3 = ptrtoint double** %base.addr to i64
  store double* %base, double** %base.addr, align 8
  call void @llvm.dbg.declare(metadata double** %base.addr, metadata !294, metadata !DIExpression()), !dbg !295
  %4 = ptrtoint i32* %index.addr to i64
  store i32 %index, i32* %index.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %index.addr, metadata !296, metadata !DIExpression()), !dbg !297
  %5 = ptrtoint i32* %n.addr to i64
  store i32 %n, i32* %n.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %n.addr, metadata !298, metadata !DIExpression()), !dbg !299
  %6 = ptrtoint double** %base.addr to i64
  %7 = load double*, double** %base.addr, align 8, !dbg !300
  %8 = ptrtoint i32* %index.addr to i64
  %9 = load i32, i32* %index.addr, align 4, !dbg !301
  %10 = ptrtoint i32* %index.addr to i64
  %11 = load i32, i32* %index.addr, align 4, !dbg !302
  %12 = ptrtoint i32* %n.addr to i64
  %13 = load i32, i32* %n.addr, align 4, !dbg !303
  %rem = srem i32 422, %13, !dbg !304
  %add = add nsw i32 %11, %rem, !dbg !305
  call void @__dp_call(i32 16392), !dbg !306
  call void @_Z19perform_calculationPdii(double* %7, i32 %9, i32 %add), !dbg !306
  call void @__dp_report_bb(i32 2)
  call void @__dp_func_exit(i32 16392, i32 0), !dbg !307
  ret void, !dbg !307
}

; Function Attrs: noinline norecurse nounwind optnone uwtable
define i32 @main(i32 %argc, i8** %argv) #2 !dbg !2 {
entry:
  call void @__dp_func_entry(i32 16394, i32 1)
  %__dp_bb16 = alloca i32, align 4
  store i32 0, i32* %__dp_bb16, align 4
  %__dp_bb15 = alloca i32, align 4
  store i32 0, i32* %__dp_bb15, align 4
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
  %i1 = alloca i32, align 4
  %5 = ptrtoint i32* %i1 to i64
  %i8 = alloca i32, align 4
  %6 = ptrtoint i32* %i8 to i64
  %7 = ptrtoint i32* %retval to i64
  store i32 0, i32* %retval, align 4
  %8 = ptrtoint i32* %argc.addr to i64
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !308, metadata !DIExpression()), !dbg !309
  %9 = ptrtoint i8*** %argv.addr to i64
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !310, metadata !DIExpression()), !dbg !311
  call void @llvm.dbg.declare(metadata double** %x, metadata !312, metadata !DIExpression()), !dbg !313
  %10 = ptrtoint i32* @_ZZ4mainE1n to i64
  call void @__dp_read(i32 16397, i64 %10, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.11, i32 0, i32 0))
  %11 = load i32, i32* @_ZZ4mainE1n, align 4, !dbg !314
  %conv = sext i32 %11 to i64, !dbg !314
  %mul = mul i64 %conv, 8, !dbg !315
  %call = call noalias i8* @malloc(i64 %mul) #4, !dbg !316
  %12 = ptrtoint i8* %call to i64
  call void @__dp_new(i32 16397, i64 %12, i64 %12, i64 %mul), !dbg !317
  %13 = bitcast i8* %call to double*, !dbg !317
  %14 = ptrtoint double** %x to i64
  store double* %13, double** %x, align 8, !dbg !313
  call void @llvm.dbg.declare(metadata i32* %i, metadata !318, metadata !DIExpression()), !dbg !320
  %15 = ptrtoint i32* %i to i64
  store i32 0, i32* %i, align 4, !dbg !320
  call void @__dp_report_bb(i32 3)
  br label %for.cond, !dbg !321

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16401, i32 0)
  %16 = ptrtoint i32* %i to i64
  %17 = load i32, i32* %i, align 4, !dbg !322
  %18 = ptrtoint i32* @_ZZ4mainE1n to i64
  call void @__dp_read(i32 16401, i64 %18, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.11, i32 0, i32 0))
  %19 = load i32, i32* @_ZZ4mainE1n, align 4, !dbg !324
  %cmp = icmp slt i32 %17, %19, !dbg !325
  call void @__dp_incr_taken_branch_counter(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.5, i32 0, i32 0), i1 %cmp, i32 1), !dbg !326
  call void @__dp_incr_taken_branch_counter(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.6, i32 0, i32 0), i1 %cmp, i32 0), !dbg !326
  call void @__dp_report_bb(i32 4)
  %20 = load i32, i32* %__dp_bb, align 4
  call void @__dp_report_bb_pair(i32 %20, i32 16)
  br i1 %cmp, label %for.body, label %for.end, !dbg !326

for.body:                                         ; preds = %for.cond
  call void @__dp_loop_incr(i32 3)
  %21 = ptrtoint double** %x to i64
  %22 = load double*, double** %x, align 8, !dbg !327
  %23 = ptrtoint i32* %i to i64
  %24 = load i32, i32* %i, align 4, !dbg !329
  %idxprom = sext i32 %24 to i64, !dbg !327
  %arrayidx = getelementptr inbounds double, double* %22, i64 %idxprom, !dbg !327
  %25 = ptrtoint double* %arrayidx to i64
  call void @__dp_write(i32 16402, i64 %25, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.26, i32 0, i32 0))
  store double 1.000000e+00, double* %arrayidx, align 8, !dbg !330
  call void @__dp_report_bb(i32 7)
  %26 = load i32, i32* %__dp_bb, align 4
  call void @__dp_report_bb_pair(i32 %26, i32 18)
  br label %for.inc, !dbg !331

for.inc:                                          ; preds = %for.body
  %27 = ptrtoint i32* %i to i64
  %28 = load i32, i32* %i, align 4, !dbg !332
  %inc = add nsw i32 %28, 1, !dbg !332
  %29 = ptrtoint i32* %i to i64
  store i32 %inc, i32* %i, align 4, !dbg !332
  call void @__dp_report_bb(i32 6)
  %30 = load i32, i32* %__dp_bb, align 4
  call void @__dp_report_bb_pair(i32 %30, i32 17)
  store i32 1, i32* %__dp_bb, align 4
  br label %for.cond, !dbg !333, !llvm.loop !334

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16406, i32 0)
  call void @llvm.dbg.declare(metadata i32* %i1, metadata !336, metadata !DIExpression()), !dbg !338
  %31 = ptrtoint i32* %i1 to i64
  store i32 0, i32* %i1, align 4, !dbg !338
  call void @__dp_report_bb(i32 5)
  br label %for.cond2, !dbg !339

for.cond2:                                        ; preds = %for.inc5, %for.end
  call void @__dp_loop_entry(i32 16406, i32 1)
  %32 = ptrtoint i32* %i1 to i64
  %33 = load i32, i32* %i1, align 4, !dbg !340
  %34 = ptrtoint i32* @_ZZ4mainE1n to i64
  call void @__dp_read(i32 16406, i64 %34, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.11, i32 0, i32 0))
  %35 = load i32, i32* @_ZZ4mainE1n, align 4, !dbg !342
  %cmp3 = icmp slt i32 %33, %35, !dbg !343
  call void @__dp_incr_taken_branch_counter(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.7, i32 0, i32 0), i1 %cmp3, i32 1), !dbg !344
  call void @__dp_incr_taken_branch_counter(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.8, i32 0, i32 0), i1 %cmp3, i32 0), !dbg !344
  call void @__dp_report_bb(i32 9)
  %36 = load i32, i32* %__dp_bb15, align 4
  call void @__dp_report_bb_pair(i32 %36, i32 19)
  br i1 %cmp3, label %for.body4, label %for.end7, !dbg !344

for.body4:                                        ; preds = %for.cond2
  call void @__dp_loop_incr(i32 2)
  %37 = ptrtoint double** %x to i64
  %38 = load double*, double** %x, align 8, !dbg !345
  %39 = ptrtoint i32* %i1 to i64
  %40 = load i32, i32* %i1, align 4, !dbg !347
  call void @__dp_call(i32 16407), !dbg !348
  call void @_Z14doall_possiblePdi(double* %38, i32 %40), !dbg !348
  call void @__dp_report_bb(i32 11)
  %41 = load i32, i32* %__dp_bb15, align 4
  call void @__dp_report_bb_pair(i32 %41, i32 21)
  br label %for.inc5, !dbg !349

for.inc5:                                         ; preds = %for.body4
  %42 = ptrtoint i32* %i1 to i64
  %43 = load i32, i32* %i1, align 4, !dbg !350
  %inc6 = add nsw i32 %43, 1, !dbg !350
  %44 = ptrtoint i32* %i1 to i64
  store i32 %inc6, i32* %i1, align 4, !dbg !350
  call void @__dp_report_bb(i32 10)
  %45 = load i32, i32* %__dp_bb15, align 4
  call void @__dp_report_bb_pair(i32 %45, i32 20)
  store i32 1, i32* %__dp_bb15, align 4
  br label %for.cond2, !dbg !351, !llvm.loop !352

for.end7:                                         ; preds = %for.cond2
  call void @__dp_loop_exit(i32 16411, i32 1)
  call void @llvm.dbg.declare(metadata i32* %i8, metadata !354, metadata !DIExpression()), !dbg !356
  %46 = ptrtoint i32* %i8 to i64
  store i32 0, i32* %i8, align 4, !dbg !356
  call void @__dp_report_bb(i32 8)
  br label %for.cond9, !dbg !357

for.cond9:                                        ; preds = %for.inc12, %for.end7
  call void @__dp_loop_entry(i32 16411, i32 2)
  %47 = ptrtoint i32* %i8 to i64
  %48 = load i32, i32* %i8, align 4, !dbg !358
  %49 = ptrtoint i32* @_ZZ4mainE1n to i64
  call void @__dp_read(i32 16411, i64 %49, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.11, i32 0, i32 0))
  %50 = load i32, i32* @_ZZ4mainE1n, align 4, !dbg !360
  %cmp10 = icmp slt i32 %48, %50, !dbg !361
  call void @__dp_incr_taken_branch_counter(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.9, i32 0, i32 0), i1 %cmp10, i32 1), !dbg !362
  call void @__dp_incr_taken_branch_counter(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.10, i32 0, i32 0), i1 %cmp10, i32 0), !dbg !362
  call void @__dp_report_bb(i32 13)
  %51 = load i32, i32* %__dp_bb16, align 4
  call void @__dp_report_bb_pair(i32 %51, i32 22)
  br i1 %cmp10, label %for.body11, label %for.end14, !dbg !362

for.body11:                                       ; preds = %for.cond9
  call void @__dp_loop_incr(i32 1)
  %52 = ptrtoint double** %x to i64
  %53 = load double*, double** %x, align 8, !dbg !363
  %54 = ptrtoint i32* %i8 to i64
  %55 = load i32, i32* %i8, align 4, !dbg !365
  %56 = ptrtoint i32* @_ZZ4mainE1n to i64
  call void @__dp_read(i32 16412, i64 %56, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.11, i32 0, i32 0))
  %57 = load i32, i32* @_ZZ4mainE1n, align 4, !dbg !366
  call void @__dp_call(i32 16412), !dbg !367
  call void @_Z18doall_not_possiblePdii(double* %53, i32 %55, i32 %57), !dbg !367
  call void @__dp_report_bb(i32 15)
  %58 = load i32, i32* %__dp_bb16, align 4
  call void @__dp_report_bb_pair(i32 %58, i32 24)
  br label %for.inc12, !dbg !368

for.inc12:                                        ; preds = %for.body11
  %59 = ptrtoint i32* %i8 to i64
  %60 = load i32, i32* %i8, align 4, !dbg !369
  %inc13 = add nsw i32 %60, 1, !dbg !369
  %61 = ptrtoint i32* %i8 to i64
  store i32 %inc13, i32* %i8, align 4, !dbg !369
  call void @__dp_report_bb(i32 14)
  %62 = load i32, i32* %__dp_bb16, align 4
  call void @__dp_report_bb_pair(i32 %62, i32 23)
  store i32 1, i32* %__dp_bb16, align 4
  br label %for.cond9, !dbg !370, !llvm.loop !371

for.end14:                                        ; preds = %for.cond9
  call void @__dp_loop_exit(i32 16415, i32 2)
  %63 = ptrtoint double** %x to i64
  %64 = load double*, double** %x, align 8, !dbg !373
  %65 = bitcast double* %64 to i8*, !dbg !373
  call void @free(i8* %65) #4, !dbg !374
  %66 = ptrtoint i8* %65 to i64
  call void @__dp_delete(i32 16415, i64 %66), !dbg !375
  call void @__dp_report_bb(i32 12)
  call void @__dp_finalize(i32 16417), !dbg !375
  call void @__dp_loop_output(), !dbg !375
  call void @__dp_taken_branch_counter_output(), !dbg !375
  ret i32 0, !dbg !375
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
!llvm.module.flags = !{!260, !261, !262, !263}
!llvm.ident = !{!264}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "n", scope: !2, file: !3, line: 11, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 10, type: !4, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !11, retainedNodes: !12)
!3 = !DIFile(filename: "code.cpp", directory: "/home/lukas/git/discopop/test/end_to_end/do_all/calls/complex/src")
!4 = !DISubroutineType(types: !5)
!5 = !{!6, !6, !7}
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 64)
!9 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !10)
!10 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!11 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !3, producer: "clang version 11.1.0 (https://github.com/llvm/llvm-project.git 7e99bddfeaab2713a8bb6ca538da25b66e6efc59)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !12, retainedTypes: !13, globals: !16, imports: !19, splitDebugInlining: false, nameTableKind: None)
!12 = !{}
!13 = !{!14}
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!15 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!16 = !{!0, !17}
!17 = !DIGlobalVariableExpression(var: !18, expr: !DIExpression())
!18 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 12, type: !15, isLocal: true, isDefinition: true)
!19 = !{!20, !27, !31, !38, !42, !47, !49, !53, !57, !61, !75, !79, !83, !87, !91, !96, !100, !104, !108, !112, !120, !124, !128, !130, !134, !138, !143, !149, !153, !157, !159, !167, !171, !179, !181, !185, !189, !193, !197, !202, !207, !212, !213, !214, !215, !217, !218, !219, !220, !221, !222, !223, !225, !226, !227, !228, !229, !230, !231, !236, !237, !238, !239, !240, !241, !242, !243, !244, !245, !246, !247, !248, !249, !250, !251, !252, !253, !254, !255, !256, !257, !258, !259}
!20 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !22, file: !26, line: 52)
!21 = !DINamespace(name: "std", scope: null)
!22 = !DISubprogram(name: "abs", scope: !23, file: !23, line: 848, type: !24, flags: DIFlagPrototyped, spFlags: 0)
!23 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!24 = !DISubroutineType(types: !25)
!25 = !{!6, !6}
!26 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/12/../../../../include/c++/12/bits/std_abs.h", directory: "")
!27 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !28, file: !30, line: 127)
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !23, line: 63, baseType: !29)
!29 = !DICompositeType(tag: DW_TAG_structure_type, file: !23, line: 59, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!30 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/12/../../../../include/c++/12/cstdlib", directory: "")
!31 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !32, file: !30, line: 128)
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !23, line: 71, baseType: !33)
!33 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !23, line: 67, size: 128, flags: DIFlagTypePassByValue, elements: !34, identifier: "_ZTS6ldiv_t")
!34 = !{!35, !37}
!35 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !33, file: !23, line: 69, baseType: !36, size: 64)
!36 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !33, file: !23, line: 70, baseType: !36, size: 64, offset: 64)
!38 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !39, file: !30, line: 130)
!39 = !DISubprogram(name: "abort", scope: !23, file: !23, line: 598, type: !40, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!40 = !DISubroutineType(types: !41)
!41 = !{null}
!42 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !43, file: !30, line: 134)
!43 = !DISubprogram(name: "atexit", scope: !23, file: !23, line: 602, type: !44, flags: DIFlagPrototyped, spFlags: 0)
!44 = !DISubroutineType(types: !45)
!45 = !{!6, !46}
!46 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !40, size: 64)
!47 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !48, file: !30, line: 137)
!48 = !DISubprogram(name: "at_quick_exit", scope: !23, file: !23, line: 607, type: !44, flags: DIFlagPrototyped, spFlags: 0)
!49 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !50, file: !30, line: 140)
!50 = !DISubprogram(name: "atof", scope: !23, file: !23, line: 102, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!51 = !DISubroutineType(types: !52)
!52 = !{!15, !8}
!53 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !54, file: !30, line: 141)
!54 = !DISubprogram(name: "atoi", scope: !23, file: !23, line: 105, type: !55, flags: DIFlagPrototyped, spFlags: 0)
!55 = !DISubroutineType(types: !56)
!56 = !{!6, !8}
!57 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !58, file: !30, line: 142)
!58 = !DISubprogram(name: "atol", scope: !23, file: !23, line: 108, type: !59, flags: DIFlagPrototyped, spFlags: 0)
!59 = !DISubroutineType(types: !60)
!60 = !{!36, !8}
!61 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !62, file: !30, line: 143)
!62 = !DISubprogram(name: "bsearch", scope: !23, file: !23, line: 828, type: !63, flags: DIFlagPrototyped, spFlags: 0)
!63 = !DISubroutineType(types: !64)
!64 = !{!65, !66, !66, !68, !68, !71}
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!66 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !67, size: 64)
!67 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!68 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !69, line: 46, baseType: !70)
!69 = !DIFile(filename: "Software/llvm-11.1.0/lib/clang/11.1.0/include/stddef.h", directory: "/home/lukas")
!70 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!71 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !23, line: 816, baseType: !72)
!72 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !73, size: 64)
!73 = !DISubroutineType(types: !74)
!74 = !{!6, !66, !66}
!75 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !76, file: !30, line: 144)
!76 = !DISubprogram(name: "calloc", scope: !23, file: !23, line: 543, type: !77, flags: DIFlagPrototyped, spFlags: 0)
!77 = !DISubroutineType(types: !78)
!78 = !{!65, !68, !68}
!79 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !80, file: !30, line: 145)
!80 = !DISubprogram(name: "div", scope: !23, file: !23, line: 860, type: !81, flags: DIFlagPrototyped, spFlags: 0)
!81 = !DISubroutineType(types: !82)
!82 = !{!28, !6, !6}
!83 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !84, file: !30, line: 146)
!84 = !DISubprogram(name: "exit", scope: !23, file: !23, line: 624, type: !85, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!85 = !DISubroutineType(types: !86)
!86 = !{null, !6}
!87 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !88, file: !30, line: 147)
!88 = !DISubprogram(name: "free", scope: !23, file: !23, line: 555, type: !89, flags: DIFlagPrototyped, spFlags: 0)
!89 = !DISubroutineType(types: !90)
!90 = !{null, !65}
!91 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !92, file: !30, line: 148)
!92 = !DISubprogram(name: "getenv", scope: !23, file: !23, line: 641, type: !93, flags: DIFlagPrototyped, spFlags: 0)
!93 = !DISubroutineType(types: !94)
!94 = !{!95, !8}
!95 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!96 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !97, file: !30, line: 149)
!97 = !DISubprogram(name: "labs", scope: !23, file: !23, line: 849, type: !98, flags: DIFlagPrototyped, spFlags: 0)
!98 = !DISubroutineType(types: !99)
!99 = !{!36, !36}
!100 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !101, file: !30, line: 150)
!101 = !DISubprogram(name: "ldiv", scope: !23, file: !23, line: 862, type: !102, flags: DIFlagPrototyped, spFlags: 0)
!102 = !DISubroutineType(types: !103)
!103 = !{!32, !36, !36}
!104 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !105, file: !30, line: 151)
!105 = !DISubprogram(name: "malloc", scope: !23, file: !23, line: 540, type: !106, flags: DIFlagPrototyped, spFlags: 0)
!106 = !DISubroutineType(types: !107)
!107 = !{!65, !68}
!108 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !109, file: !30, line: 153)
!109 = !DISubprogram(name: "mblen", scope: !23, file: !23, line: 930, type: !110, flags: DIFlagPrototyped, spFlags: 0)
!110 = !DISubroutineType(types: !111)
!111 = !{!6, !8, !68}
!112 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !113, file: !30, line: 154)
!113 = !DISubprogram(name: "mbstowcs", scope: !23, file: !23, line: 941, type: !114, flags: DIFlagPrototyped, spFlags: 0)
!114 = !DISubroutineType(types: !115)
!115 = !{!68, !116, !119, !68}
!116 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !117)
!117 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !118, size: 64)
!118 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!119 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !8)
!120 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !121, file: !30, line: 155)
!121 = !DISubprogram(name: "mbtowc", scope: !23, file: !23, line: 933, type: !122, flags: DIFlagPrototyped, spFlags: 0)
!122 = !DISubroutineType(types: !123)
!123 = !{!6, !116, !119, !68}
!124 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !125, file: !30, line: 157)
!125 = !DISubprogram(name: "qsort", scope: !23, file: !23, line: 838, type: !126, flags: DIFlagPrototyped, spFlags: 0)
!126 = !DISubroutineType(types: !127)
!127 = !{null, !65, !68, !68, !71}
!128 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !129, file: !30, line: 160)
!129 = !DISubprogram(name: "quick_exit", scope: !23, file: !23, line: 630, type: !85, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!130 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !131, file: !30, line: 163)
!131 = !DISubprogram(name: "rand", scope: !23, file: !23, line: 454, type: !132, flags: DIFlagPrototyped, spFlags: 0)
!132 = !DISubroutineType(types: !133)
!133 = !{!6}
!134 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !135, file: !30, line: 164)
!135 = !DISubprogram(name: "realloc", scope: !23, file: !23, line: 551, type: !136, flags: DIFlagPrototyped, spFlags: 0)
!136 = !DISubroutineType(types: !137)
!137 = !{!65, !65, !68}
!138 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !139, file: !30, line: 165)
!139 = !DISubprogram(name: "srand", scope: !23, file: !23, line: 456, type: !140, flags: DIFlagPrototyped, spFlags: 0)
!140 = !DISubroutineType(types: !141)
!141 = !{null, !142}
!142 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!143 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !144, file: !30, line: 166)
!144 = !DISubprogram(name: "strtod", scope: !23, file: !23, line: 118, type: !145, flags: DIFlagPrototyped, spFlags: 0)
!145 = !DISubroutineType(types: !146)
!146 = !{!15, !119, !147}
!147 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !148)
!148 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !95, size: 64)
!149 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !150, file: !30, line: 167)
!150 = !DISubprogram(name: "strtol", scope: !23, file: !23, line: 177, type: !151, flags: DIFlagPrototyped, spFlags: 0)
!151 = !DISubroutineType(types: !152)
!152 = !{!36, !119, !147, !6}
!153 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !154, file: !30, line: 168)
!154 = !DISubprogram(name: "strtoul", scope: !23, file: !23, line: 181, type: !155, flags: DIFlagPrototyped, spFlags: 0)
!155 = !DISubroutineType(types: !156)
!156 = !{!70, !119, !147, !6}
!157 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !158, file: !30, line: 169)
!158 = !DISubprogram(name: "system", scope: !23, file: !23, line: 791, type: !55, flags: DIFlagPrototyped, spFlags: 0)
!159 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !160, file: !30, line: 171)
!160 = !DISubprogram(name: "wcstombs", scope: !23, file: !23, line: 945, type: !161, flags: DIFlagPrototyped, spFlags: 0)
!161 = !DISubroutineType(types: !162)
!162 = !{!68, !163, !164, !68}
!163 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !95)
!164 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !165)
!165 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !166, size: 64)
!166 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !118)
!167 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !168, file: !30, line: 172)
!168 = !DISubprogram(name: "wctomb", scope: !23, file: !23, line: 937, type: !169, flags: DIFlagPrototyped, spFlags: 0)
!169 = !DISubroutineType(types: !170)
!170 = !{!6, !95, !118}
!171 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !172, entity: !173, file: !30, line: 200)
!172 = !DINamespace(name: "__gnu_cxx", scope: null)
!173 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !23, line: 81, baseType: !174)
!174 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !23, line: 77, size: 128, flags: DIFlagTypePassByValue, elements: !175, identifier: "_ZTS7lldiv_t")
!175 = !{!176, !178}
!176 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !174, file: !23, line: 79, baseType: !177, size: 64)
!177 = !DIBasicType(name: "long long int", size: 64, encoding: DW_ATE_signed)
!178 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !174, file: !23, line: 80, baseType: !177, size: 64, offset: 64)
!179 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !172, entity: !180, file: !30, line: 206)
!180 = !DISubprogram(name: "_Exit", scope: !23, file: !23, line: 636, type: !85, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!181 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !172, entity: !182, file: !30, line: 210)
!182 = !DISubprogram(name: "llabs", scope: !23, file: !23, line: 852, type: !183, flags: DIFlagPrototyped, spFlags: 0)
!183 = !DISubroutineType(types: !184)
!184 = !{!177, !177}
!185 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !172, entity: !186, file: !30, line: 216)
!186 = !DISubprogram(name: "lldiv", scope: !23, file: !23, line: 866, type: !187, flags: DIFlagPrototyped, spFlags: 0)
!187 = !DISubroutineType(types: !188)
!188 = !{!173, !177, !177}
!189 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !172, entity: !190, file: !30, line: 227)
!190 = !DISubprogram(name: "atoll", scope: !23, file: !23, line: 113, type: !191, flags: DIFlagPrototyped, spFlags: 0)
!191 = !DISubroutineType(types: !192)
!192 = !{!177, !8}
!193 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !172, entity: !194, file: !30, line: 228)
!194 = !DISubprogram(name: "strtoll", scope: !23, file: !23, line: 201, type: !195, flags: DIFlagPrototyped, spFlags: 0)
!195 = !DISubroutineType(types: !196)
!196 = !{!177, !119, !147, !6}
!197 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !172, entity: !198, file: !30, line: 229)
!198 = !DISubprogram(name: "strtoull", scope: !23, file: !23, line: 206, type: !199, flags: DIFlagPrototyped, spFlags: 0)
!199 = !DISubroutineType(types: !200)
!200 = !{!201, !119, !147, !6}
!201 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!202 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !172, entity: !203, file: !30, line: 231)
!203 = !DISubprogram(name: "strtof", scope: !23, file: !23, line: 124, type: !204, flags: DIFlagPrototyped, spFlags: 0)
!204 = !DISubroutineType(types: !205)
!205 = !{!206, !119, !147}
!206 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!207 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !172, entity: !208, file: !30, line: 232)
!208 = !DISubprogram(name: "strtold", scope: !23, file: !23, line: 127, type: !209, flags: DIFlagPrototyped, spFlags: 0)
!209 = !DISubroutineType(types: !210)
!210 = !{!211, !119, !147}
!211 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!212 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !173, file: !30, line: 240)
!213 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !180, file: !30, line: 242)
!214 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !182, file: !30, line: 244)
!215 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !216, file: !30, line: 245)
!216 = !DISubprogram(name: "div", linkageName: "_ZN9__gnu_cxx3divExx", scope: !172, file: !30, line: 213, type: !187, flags: DIFlagPrototyped, spFlags: 0)
!217 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !186, file: !30, line: 246)
!218 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !190, file: !30, line: 248)
!219 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !203, file: !30, line: 249)
!220 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !194, file: !30, line: 250)
!221 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !198, file: !30, line: 251)
!222 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !21, entity: !208, file: !30, line: 252)
!223 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !39, file: !224, line: 38)
!224 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/12/../../../../include/c++/12/stdlib.h", directory: "")
!225 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !43, file: !224, line: 39)
!226 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !84, file: !224, line: 40)
!227 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !48, file: !224, line: 43)
!228 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !129, file: !224, line: 46)
!229 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !28, file: !224, line: 51)
!230 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !32, file: !224, line: 52)
!231 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !232, file: !224, line: 54)
!232 = !DISubprogram(name: "abs", linkageName: "_ZSt3absg", scope: !21, file: !26, line: 103, type: !233, flags: DIFlagPrototyped, spFlags: 0)
!233 = !DISubroutineType(types: !234)
!234 = !{!235, !235}
!235 = !DIBasicType(name: "__float128", size: 128, encoding: DW_ATE_float)
!236 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !50, file: !224, line: 55)
!237 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !54, file: !224, line: 56)
!238 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !58, file: !224, line: 57)
!239 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !62, file: !224, line: 58)
!240 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !76, file: !224, line: 59)
!241 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !216, file: !224, line: 60)
!242 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !88, file: !224, line: 61)
!243 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !92, file: !224, line: 62)
!244 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !97, file: !224, line: 63)
!245 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !101, file: !224, line: 64)
!246 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !105, file: !224, line: 65)
!247 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !109, file: !224, line: 67)
!248 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !113, file: !224, line: 68)
!249 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !121, file: !224, line: 69)
!250 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !125, file: !224, line: 71)
!251 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !131, file: !224, line: 72)
!252 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !135, file: !224, line: 73)
!253 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !139, file: !224, line: 74)
!254 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !144, file: !224, line: 75)
!255 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !150, file: !224, line: 76)
!256 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !154, file: !224, line: 77)
!257 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !158, file: !224, line: 78)
!258 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !160, file: !224, line: 80)
!259 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !168, file: !224, line: 81)
!260 = !{i32 7, !"Dwarf Version", i32 4}
!261 = !{i32 2, !"Debug Info Version", i32 3}
!262 = !{i32 1, !"wchar_size", i32 4}
!263 = !{i32 7, !"PIC Level", i32 2}
!264 = !{!"clang version 11.1.0 (https://github.com/llvm/llvm-project.git 7e99bddfeaab2713a8bb6ca538da25b66e6efc59)"}
!265 = distinct !DISubprogram(name: "perform_calculation", linkageName: "_Z19perform_calculationPdii", scope: !3, file: !3, line: 4, type: !266, scopeLine: 4, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !11, retainedNodes: !12)
!266 = !DISubroutineType(types: !267)
!267 = !{null, !14, !6, !6}
!268 = !DILocalVariable(name: "base", arg: 1, scope: !265, file: !3, line: 4, type: !14)
!269 = !DILocation(line: 4, column: 34, scope: !265)
!270 = !DILocalVariable(name: "offset_1", arg: 2, scope: !265, file: !3, line: 4, type: !6)
!271 = !DILocation(line: 4, column: 44, scope: !265)
!272 = !DILocalVariable(name: "offset_2", arg: 3, scope: !265, file: !3, line: 4, type: !6)
!273 = !DILocation(line: 4, column: 58, scope: !265)
!274 = !DILocation(line: 4, column: 92, scope: !265)
!275 = !DILocation(line: 4, column: 97, scope: !265)
!276 = !DILocation(line: 4, column: 90, scope: !265)
!277 = !DILocation(line: 4, column: 70, scope: !265)
!278 = !DILocation(line: 4, column: 75, scope: !265)
!279 = !DILocation(line: 4, column: 85, scope: !265)
!280 = !DILocation(line: 4, column: 108, scope: !265)
!281 = distinct !DISubprogram(name: "doall_possible", linkageName: "_Z14doall_possiblePdi", scope: !3, file: !3, line: 6, type: !282, scopeLine: 6, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !11, retainedNodes: !12)
!282 = !DISubroutineType(types: !283)
!283 = !{null, !14, !6}
!284 = !DILocalVariable(name: "base", arg: 1, scope: !281, file: !3, line: 6, type: !14)
!285 = !DILocation(line: 6, column: 29, scope: !281)
!286 = !DILocalVariable(name: "index", arg: 2, scope: !281, file: !3, line: 6, type: !6)
!287 = !DILocation(line: 6, column: 39, scope: !281)
!288 = !DILocation(line: 6, column: 68, scope: !281)
!289 = !DILocation(line: 6, column: 74, scope: !281)
!290 = !DILocation(line: 6, column: 81, scope: !281)
!291 = !DILocation(line: 6, column: 48, scope: !281)
!292 = !DILocation(line: 6, column: 89, scope: !281)
!293 = distinct !DISubprogram(name: "doall_not_possible", linkageName: "_Z18doall_not_possiblePdii", scope: !3, file: !3, line: 8, type: !266, scopeLine: 8, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !11, retainedNodes: !12)
!294 = !DILocalVariable(name: "base", arg: 1, scope: !293, file: !3, line: 8, type: !14)
!295 = !DILocation(line: 8, column: 33, scope: !293)
!296 = !DILocalVariable(name: "index", arg: 2, scope: !293, file: !3, line: 8, type: !6)
!297 = !DILocation(line: 8, column: 43, scope: !293)
!298 = !DILocalVariable(name: "n", arg: 3, scope: !293, file: !3, line: 8, type: !6)
!299 = !DILocation(line: 8, column: 54, scope: !293)
!300 = !DILocation(line: 8, column: 79, scope: !293)
!301 = !DILocation(line: 8, column: 85, scope: !293)
!302 = !DILocation(line: 8, column: 93, scope: !293)
!303 = !DILocation(line: 8, column: 107, scope: !293)
!304 = !DILocation(line: 8, column: 105, scope: !293)
!305 = !DILocation(line: 8, column: 99, scope: !293)
!306 = !DILocation(line: 8, column: 59, scope: !293)
!307 = !DILocation(line: 8, column: 112, scope: !293)
!308 = !DILocalVariable(name: "argc", arg: 1, scope: !2, file: !3, line: 10, type: !6)
!309 = !DILocation(line: 10, column: 14, scope: !2)
!310 = !DILocalVariable(name: "argv", arg: 2, scope: !2, file: !3, line: 10, type: !7)
!311 = !DILocation(line: 10, column: 32, scope: !2)
!312 = !DILocalVariable(name: "x", scope: !2, file: !3, line: 13, type: !14)
!313 = !DILocation(line: 13, column: 11, scope: !2)
!314 = !DILocation(line: 13, column: 32, scope: !2)
!315 = !DILocation(line: 13, column: 34, scope: !2)
!316 = !DILocation(line: 13, column: 25, scope: !2)
!317 = !DILocation(line: 13, column: 15, scope: !2)
!318 = !DILocalVariable(name: "i", scope: !319, file: !3, line: 17, type: !6)
!319 = distinct !DILexicalBlock(scope: !2, file: !3, line: 17, column: 3)
!320 = !DILocation(line: 17, column: 12, scope: !319)
!321 = !DILocation(line: 17, column: 8, scope: !319)
!322 = !DILocation(line: 17, column: 19, scope: !323)
!323 = distinct !DILexicalBlock(scope: !319, file: !3, line: 17, column: 3)
!324 = !DILocation(line: 17, column: 23, scope: !323)
!325 = !DILocation(line: 17, column: 21, scope: !323)
!326 = !DILocation(line: 17, column: 3, scope: !319)
!327 = !DILocation(line: 18, column: 5, scope: !328)
!328 = distinct !DILexicalBlock(scope: !323, file: !3, line: 17, column: 31)
!329 = !DILocation(line: 18, column: 7, scope: !328)
!330 = !DILocation(line: 18, column: 10, scope: !328)
!331 = !DILocation(line: 19, column: 3, scope: !328)
!332 = !DILocation(line: 17, column: 26, scope: !323)
!333 = !DILocation(line: 17, column: 3, scope: !323)
!334 = distinct !{!334, !326, !335}
!335 = !DILocation(line: 19, column: 3, scope: !319)
!336 = !DILocalVariable(name: "i", scope: !337, file: !3, line: 22, type: !6)
!337 = distinct !DILexicalBlock(scope: !2, file: !3, line: 22, column: 3)
!338 = !DILocation(line: 22, column: 12, scope: !337)
!339 = !DILocation(line: 22, column: 8, scope: !337)
!340 = !DILocation(line: 22, column: 19, scope: !341)
!341 = distinct !DILexicalBlock(scope: !337, file: !3, line: 22, column: 3)
!342 = !DILocation(line: 22, column: 23, scope: !341)
!343 = !DILocation(line: 22, column: 21, scope: !341)
!344 = !DILocation(line: 22, column: 3, scope: !337)
!345 = !DILocation(line: 23, column: 20, scope: !346)
!346 = distinct !DILexicalBlock(scope: !341, file: !3, line: 22, column: 31)
!347 = !DILocation(line: 23, column: 23, scope: !346)
!348 = !DILocation(line: 23, column: 5, scope: !346)
!349 = !DILocation(line: 24, column: 3, scope: !346)
!350 = !DILocation(line: 22, column: 27, scope: !341)
!351 = !DILocation(line: 22, column: 3, scope: !341)
!352 = distinct !{!352, !344, !353}
!353 = !DILocation(line: 24, column: 3, scope: !337)
!354 = !DILocalVariable(name: "i", scope: !355, file: !3, line: 27, type: !6)
!355 = distinct !DILexicalBlock(scope: !2, file: !3, line: 27, column: 3)
!356 = !DILocation(line: 27, column: 12, scope: !355)
!357 = !DILocation(line: 27, column: 8, scope: !355)
!358 = !DILocation(line: 27, column: 19, scope: !359)
!359 = distinct !DILexicalBlock(scope: !355, file: !3, line: 27, column: 3)
!360 = !DILocation(line: 27, column: 23, scope: !359)
!361 = !DILocation(line: 27, column: 21, scope: !359)
!362 = !DILocation(line: 27, column: 3, scope: !355)
!363 = !DILocation(line: 28, column: 24, scope: !364)
!364 = distinct !DILexicalBlock(scope: !359, file: !3, line: 27, column: 31)
!365 = !DILocation(line: 28, column: 27, scope: !364)
!366 = !DILocation(line: 28, column: 30, scope: !364)
!367 = !DILocation(line: 28, column: 5, scope: !364)
!368 = !DILocation(line: 29, column: 3, scope: !364)
!369 = !DILocation(line: 27, column: 27, scope: !359)
!370 = !DILocation(line: 27, column: 3, scope: !359)
!371 = distinct !{!371, !362, !372}
!372 = !DILocation(line: 29, column: 3, scope: !355)
!373 = !DILocation(line: 31, column: 8, scope: !2)
!374 = !DILocation(line: 31, column: 3, scope: !2)
!375 = !DILocation(line: 33, column: 3, scope: !2)
