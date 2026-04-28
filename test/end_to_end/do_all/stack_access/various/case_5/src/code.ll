; ModuleID = 'code.cpp'
source_filename = "code.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@_ZZ4mainE1n = internal global i32 100, align 4, !dbg !0
@.str = private unnamed_addr constant [2 x i8] c"t\00", align 1
@.str.1 = private unnamed_addr constant [12 x i8] c"_ZZ4mainE1n\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"argc\00", align 1
@.str.4 = private unnamed_addr constant [5 x i8] c"argv\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@.str.7 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c"s\00", align 1
@.str.9 = private unnamed_addr constant [2 x i8] c"j\00", align 1
@.str.10 = private unnamed_addr constant [12 x i8] c"GEPRESULT_x\00", align 1
@.str.11 = private unnamed_addr constant [12 x i8] c"GEPRESULT_y\00", align 1
@.dp_bb_deps = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define noundef i32 @_Z1fi(i32 noundef %t) #0 !dbg !268 {
entry:
  call void @__dp_func_entry(i32 16388, i32 0), !dp.md.instr.id !269
  %t.addr = alloca i32, align 4, !dp.md.instr.id !270
  %0 = ptrtoint ptr %t.addr to i64, !dp.md.instr.id !271
  call void @__dp_alloca(i32 16388, ptr @.str, i64 %0, i64 %0, i64 4, i64 1), !dp.md.instr.id !272
  %1 = ptrtoint ptr %t.addr to i64
  call void @__dp_write(i32 6, i64 %1, ptr @.str)
  store i32 %t, ptr %t.addr, align 4, !dp.md.instr.id !273
    #dbg_declare(ptr %t.addr, !274, !DIExpression(), !275)
  %2 = ptrtoint ptr %t.addr to i64
  call void @__dp_read(i32 7, i64 %2, ptr @.str)
  %3 = load i32, ptr %t.addr, align 4, !dbg !276, !dp.md.instr.id !277
  %mul = mul nsw i32 %3, 42, !dbg !278, !dp.md.instr.id !279
  %4 = ptrtoint ptr %t.addr to i64
  call void @__dp_read(i32 9, i64 %4, ptr @.str)
  %5 = load i32, ptr %t.addr, align 4, !dbg !280, !dp.md.instr.id !281
  %add = add nsw i32 %mul, %5, !dbg !282, !dp.md.instr.id !283
  %sub = sub nsw i32 %add, 2, !dbg !284, !dp.md.instr.id !285
  %6 = ptrtoint ptr %t.addr to i64
  call void @__dp_write(i32 12, i64 %6, ptr @.str)
  store i32 %sub, ptr %t.addr, align 4, !dbg !286, !dp.md.instr.id !287
  %7 = ptrtoint ptr %t.addr to i64
  call void @__dp_read(i32 13, i64 %7, ptr @.str)
  %8 = load i32, ptr %t.addr, align 4, !dbg !288, !dp.md.instr.id !289
  call void @__dp_func_exit(i32 16390, i32 0), !dbg !290
  ret i32 %8, !dbg !290, !dp.md.instr.id !291
}

; Function Attrs: mustprogress noinline norecurse nounwind optnone uwtable
define noundef i32 @main(i32 noundef %argc, ptr noundef %argv) #1 !dbg !2 {
entry:
  call void @__dp_func_entry(i32 16393, i32 1), !dp.md.instr.id !292
  %retval = alloca i32, align 4, !dp.md.instr.id !293
  %0 = ptrtoint ptr %retval to i64, !dp.md.instr.id !294
  call void @__dp_alloca(i32 16393, ptr @.str.2, i64 %0, i64 %0, i64 4, i64 1), !dp.md.instr.id !295
  %argc.addr = alloca i32, align 4, !dp.md.instr.id !296
  %1 = ptrtoint ptr %argc.addr to i64, !dp.md.instr.id !297
  call void @__dp_alloca(i32 16393, ptr @.str.3, i64 %1, i64 %1, i64 4, i64 1), !dp.md.instr.id !298
  %argv.addr = alloca ptr, align 8, !dp.md.instr.id !299
  %2 = ptrtoint ptr %argv.addr to i64, !dp.md.instr.id !300
  call void @__dp_alloca(i32 16393, ptr @.str.4, i64 %2, i64 %2, i64 0, i64 1), !dp.md.instr.id !301
  %x = alloca ptr, align 8, !dp.md.instr.id !302
  %3 = ptrtoint ptr %x to i64, !dp.md.instr.id !303
  call void @__dp_alloca(i32 16393, ptr @.str.5, i64 %3, i64 %3, i64 0, i64 1), !dp.md.instr.id !304
  %y = alloca ptr, align 8, !dp.md.instr.id !305
  %4 = ptrtoint ptr %y to i64, !dp.md.instr.id !306
  call void @__dp_alloca(i32 16393, ptr @.str.6, i64 %4, i64 %4, i64 0, i64 1), !dp.md.instr.id !307
  %i = alloca i32, align 4, !dp.md.instr.id !308
  %5 = ptrtoint ptr %i to i64, !dp.md.instr.id !309
  call void @__dp_alloca(i32 16393, ptr @.str.7, i64 %5, i64 %5, i64 4, i64 1), !dp.md.instr.id !310
  %s = alloca i32, align 4, !dp.md.instr.id !311
  %6 = ptrtoint ptr %s to i64, !dp.md.instr.id !312
  call void @__dp_alloca(i32 16393, ptr @.str.8, i64 %6, i64 %6, i64 4, i64 1), !dp.md.instr.id !313
  %j = alloca i32, align 4, !dp.md.instr.id !314
  %7 = ptrtoint ptr %j to i64, !dp.md.instr.id !315
  call void @__dp_alloca(i32 16393, ptr @.str.9, i64 %7, i64 %7, i64 4, i64 1), !dp.md.instr.id !316
  %j9 = alloca i32, align 4, !dp.md.instr.id !317
  %8 = ptrtoint ptr %j9 to i64, !dp.md.instr.id !318
  call void @__dp_alloca(i32 16393, ptr @.str.9, i64 %8, i64 %8, i64 4, i64 1), !dp.md.instr.id !319
  %9 = ptrtoint ptr %retval to i64
  call void @__dp_write(i32 43, i64 %9, ptr @.str.2)
  store i32 0, ptr %retval, align 4, !dp.md.instr.id !320
  %10 = ptrtoint ptr %argc.addr to i64
  call void @__dp_write(i32 44, i64 %10, ptr @.str.3)
  store i32 %argc, ptr %argc.addr, align 4, !dp.md.instr.id !321
    #dbg_declare(ptr %argc.addr, !322, !DIExpression(), !323)
  %11 = ptrtoint ptr %argv.addr to i64
  call void @__dp_write(i32 45, i64 %11, ptr @.str.4)
  store ptr %argv, ptr %argv.addr, align 8, !dp.md.instr.id !324
    #dbg_declare(ptr %argv.addr, !325, !DIExpression(), !326)
    #dbg_declare(ptr %x, !327, !DIExpression(), !328)
  %12 = ptrtoint ptr @_ZZ4mainE1n to i64
  call void @__dp_read(i32 46, i64 %12, ptr @.str.1)
  %13 = load i32, ptr @_ZZ4mainE1n, align 4, !dbg !329, !dp.md.instr.id !330
  %conv = sext i32 %13 to i64, !dbg !329, !dp.md.instr.id !331
  %mul = mul i64 %conv, 8, !dbg !332, !dp.md.instr.id !333
  %call = call noalias ptr @malloc(i64 noundef %mul) #4, !dbg !334, !dp.md.instr.id !335
  %14 = ptrtoint ptr %call to i64, !dp.md.instr.id !336
  call void @__dp_new(i32 16395, i64 %14, i64 %14, i64 %mul), !dbg !328, !dp.md.instr.id !337
  %15 = ptrtoint ptr %x to i64
  call void @__dp_write(i32 52, i64 %15, ptr @.str.5)
  store ptr %call, ptr %x, align 8, !dbg !328, !dp.md.instr.id !338
    #dbg_declare(ptr %y, !339, !DIExpression(), !340)
  %16 = ptrtoint ptr @_ZZ4mainE1n to i64
  call void @__dp_read(i32 53, i64 %16, ptr @.str.1)
  %17 = load i32, ptr @_ZZ4mainE1n, align 4, !dbg !341, !dp.md.instr.id !342
  %conv1 = sext i32 %17 to i64, !dbg !341, !dp.md.instr.id !343
  %mul2 = mul i64 %conv1, 8, !dbg !344, !dp.md.instr.id !345
  %call3 = call noalias ptr @malloc(i64 noundef %mul2) #4, !dbg !346, !dp.md.instr.id !347
  %18 = ptrtoint ptr %call3 to i64, !dp.md.instr.id !348
  call void @__dp_new(i32 16396, i64 %18, i64 %18, i64 %mul2), !dbg !340, !dp.md.instr.id !349
  %19 = ptrtoint ptr %y to i64
  call void @__dp_write(i32 59, i64 %19, ptr @.str.6)
  store ptr %call3, ptr %y, align 8, !dbg !340, !dp.md.instr.id !350
    #dbg_declare(ptr %i, !351, !DIExpression(), !353)
  %20 = ptrtoint ptr %i to i64
  call void @__dp_write(i32 60, i64 %20, ptr @.str.7)
  store i32 0, ptr %i, align 4, !dbg !353, !dp.md.instr.id !354
  br label %for.cond, !dbg !355, !dp.md.instr.id !356

for.cond:                                         ; preds = %for.inc20, %entry
  call void @__dp_loop_entry(i32 16398, i32 0, i32 62), !dp.md.instr.id !357
  %21 = ptrtoint ptr %i to i64
  call void @__dp_read(i32 63, i64 %21, ptr @.str.7)
  %22 = load i32, ptr %i, align 4, !dbg !358, !dp.md.instr.id !360
  %23 = ptrtoint ptr @_ZZ4mainE1n to i64
  call void @__dp_read(i32 64, i64 %23, ptr @.str.1)
  %24 = load i32, ptr @_ZZ4mainE1n, align 4, !dbg !361, !dp.md.instr.id !362
  %cmp = icmp slt i32 %22, %24, !dbg !363, !dp.md.instr.id !364
  br i1 %cmp, label %for.body, label %for.end22, !dbg !365, !dp.md.instr.id !366

for.body:                                         ; preds = %for.cond
    #dbg_declare(ptr %s, !367, !DIExpression(), !369)
  call void @__dp_loop_incr(i32 0, i32 129), !dp.md.instr.id !370
  %25 = ptrtoint ptr %s to i64
  call void @__dp_write(i32 67, i64 %25, ptr @.str.8)
  store i32 0, ptr %s, align 4, !dbg !369, !dp.md.instr.id !371
    #dbg_declare(ptr %j, !372, !DIExpression(), !374)
  %26 = ptrtoint ptr %j to i64
  call void @__dp_write(i32 68, i64 %26, ptr @.str.9)
  store i32 0, ptr %j, align 4, !dbg !374, !dp.md.instr.id !375
  br label %for.cond4, !dbg !376, !dp.md.instr.id !377

for.cond4:                                        ; preds = %for.inc, %for.body
  call void @__dp_loop_entry(i32 16400, i32 1, i32 70), !dp.md.instr.id !378
  %27 = ptrtoint ptr %j to i64
  call void @__dp_read(i32 71, i64 %27, ptr @.str.9)
  %28 = load i32, ptr %j, align 4, !dbg !379, !dp.md.instr.id !381
  %29 = ptrtoint ptr @_ZZ4mainE1n to i64
  call void @__dp_read(i32 72, i64 %29, ptr @.str.1)
  %30 = load i32, ptr @_ZZ4mainE1n, align 4, !dbg !382, !dp.md.instr.id !383
  %cmp5 = icmp slt i32 %28, %30, !dbg !384, !dp.md.instr.id !385
  br i1 %cmp5, label %for.body6, label %for.end, !dbg !386, !dp.md.instr.id !387

for.body6:                                        ; preds = %for.cond4
  call void @__dp_loop_incr(i32 1, i32 130), !dp.md.instr.id !388
  %31 = ptrtoint ptr %j to i64
  call void @__dp_read(i32 75, i64 %31, ptr @.str.9)
  %32 = load i32, ptr %j, align 4, !dbg !389, !dp.md.instr.id !391
  call void @__dp_call(i32 76, i8 0), !dbg !392
  %call7 = call noundef i32 @_Z1fi(i32 noundef %32), !dbg !392, !dp.md.instr.id !393
  %33 = ptrtoint ptr %s to i64
  call void @__dp_write(i32 77, i64 %33, ptr @.str.8)
  store i32 %call7, ptr %s, align 4, !dbg !394, !dp.md.instr.id !395
  %34 = ptrtoint ptr %s to i64
  call void @__dp_read(i32 78, i64 %34, ptr @.str.8)
  %35 = load i32, ptr %s, align 4, !dbg !396, !dp.md.instr.id !397
  %conv8 = sitofp i32 %35 to double, !dbg !396, !dp.md.instr.id !398
  %36 = ptrtoint ptr %x to i64
  call void @__dp_read(i32 80, i64 %36, ptr @.str.5)
  %37 = load ptr, ptr %x, align 8, !dbg !399, !dp.md.instr.id !400
  %38 = ptrtoint ptr %j to i64
  call void @__dp_read(i32 81, i64 %38, ptr @.str.9)
  %39 = load i32, ptr %j, align 4, !dbg !401, !dp.md.instr.id !402
  %idxprom = sext i32 %39 to i64, !dbg !399, !dp.md.instr.id !403
  %arrayidx = getelementptr inbounds double, ptr %37, i64 %idxprom, !dbg !399, !dp.md.instr.id !404
  %40 = ptrtoint ptr %arrayidx to i64
  call void @__dp_write(i32 84, i64 %40, ptr @.str.10)
  store double %conv8, ptr %arrayidx, align 8, !dbg !405, !dp.md.instr.id !406
  br label %for.inc, !dbg !407, !dp.md.instr.id !408

for.inc:                                          ; preds = %for.body6
  %41 = ptrtoint ptr %j to i64
  call void @__dp_read(i32 86, i64 %41, ptr @.str.9)
  %42 = load i32, ptr %j, align 4, !dbg !409, !dp.md.instr.id !410
  %inc = add nsw i32 %42, 1, !dbg !409, !dp.md.instr.id !411
  %43 = ptrtoint ptr %j to i64
  call void @__dp_write(i32 88, i64 %43, ptr @.str.9)
  store i32 %inc, ptr %j, align 4, !dbg !409, !dp.md.instr.id !412
  br label %for.cond4, !dbg !413, !llvm.loop !414, !dp.md.instr.id !417

for.end:                                          ; preds = %for.cond4
    #dbg_declare(ptr %j9, !418, !DIExpression(), !420)
  call void @__dp_loop_exit(i32 16404, i32 1, i32 90), !dp.md.instr.id !421
  %44 = ptrtoint ptr %j9 to i64
  call void @__dp_write(i32 91, i64 %44, ptr @.str.9)
  store i32 0, ptr %j9, align 4, !dbg !420, !dp.md.instr.id !422
  br label %for.cond10, !dbg !423, !dp.md.instr.id !424

for.cond10:                                       ; preds = %for.inc17, %for.end
  call void @__dp_loop_entry(i32 16404, i32 2, i32 93), !dp.md.instr.id !425
  %45 = ptrtoint ptr %j9 to i64
  call void @__dp_read(i32 94, i64 %45, ptr @.str.9)
  %46 = load i32, ptr %j9, align 4, !dbg !426, !dp.md.instr.id !428
  %47 = ptrtoint ptr @_ZZ4mainE1n to i64
  call void @__dp_read(i32 95, i64 %47, ptr @.str.1)
  %48 = load i32, ptr @_ZZ4mainE1n, align 4, !dbg !429, !dp.md.instr.id !430
  %cmp11 = icmp slt i32 %46, %48, !dbg !431, !dp.md.instr.id !432
  br i1 %cmp11, label %for.body12, label %for.end19, !dbg !433, !dp.md.instr.id !434

for.body12:                                       ; preds = %for.cond10
  call void @__dp_loop_incr(i32 2, i32 131), !dp.md.instr.id !435
  %49 = ptrtoint ptr %j9 to i64
  call void @__dp_read(i32 98, i64 %49, ptr @.str.9)
  %50 = load i32, ptr %j9, align 4, !dbg !436, !dp.md.instr.id !438
  call void @__dp_call(i32 99, i8 0), !dbg !439
  %call13 = call noundef i32 @_Z1fi(i32 noundef %50), !dbg !439, !dp.md.instr.id !440
  %51 = ptrtoint ptr %s to i64
  call void @__dp_write(i32 100, i64 %51, ptr @.str.8)
  store i32 %call13, ptr %s, align 4, !dbg !441, !dp.md.instr.id !442
  %52 = ptrtoint ptr %s to i64
  call void @__dp_read(i32 101, i64 %52, ptr @.str.8)
  %53 = load i32, ptr %s, align 4, !dbg !443, !dp.md.instr.id !444
  %conv14 = sitofp i32 %53 to double, !dbg !443, !dp.md.instr.id !445
  %54 = ptrtoint ptr %y to i64
  call void @__dp_read(i32 103, i64 %54, ptr @.str.6)
  %55 = load ptr, ptr %y, align 8, !dbg !446, !dp.md.instr.id !447
  %56 = ptrtoint ptr %j9 to i64
  call void @__dp_read(i32 104, i64 %56, ptr @.str.9)
  %57 = load i32, ptr %j9, align 4, !dbg !448, !dp.md.instr.id !449
  %idxprom15 = sext i32 %57 to i64, !dbg !446, !dp.md.instr.id !450
  %arrayidx16 = getelementptr inbounds double, ptr %55, i64 %idxprom15, !dbg !446, !dp.md.instr.id !451
  %58 = ptrtoint ptr %arrayidx16 to i64
  call void @__dp_write(i32 107, i64 %58, ptr @.str.11)
  store double %conv14, ptr %arrayidx16, align 8, !dbg !452, !dp.md.instr.id !453
  br label %for.inc17, !dbg !454, !dp.md.instr.id !455

for.inc17:                                        ; preds = %for.body12
  %59 = ptrtoint ptr %j9 to i64
  call void @__dp_read(i32 109, i64 %59, ptr @.str.9)
  %60 = load i32, ptr %j9, align 4, !dbg !456, !dp.md.instr.id !457
  %inc18 = add nsw i32 %60, 1, !dbg !456, !dp.md.instr.id !458
  %61 = ptrtoint ptr %j9 to i64
  call void @__dp_write(i32 111, i64 %61, ptr @.str.9)
  store i32 %inc18, ptr %j9, align 4, !dbg !456, !dp.md.instr.id !459
  br label %for.cond10, !dbg !460, !llvm.loop !461, !dp.md.instr.id !463

for.end19:                                        ; preds = %for.cond10
  call void @__dp_loop_exit(i32 16408, i32 2, i32 113), !dp.md.instr.id !464
  br label %for.inc20, !dbg !465, !dp.md.instr.id !466

for.inc20:                                        ; preds = %for.end19
  %62 = ptrtoint ptr %i to i64
  call void @__dp_read(i32 115, i64 %62, ptr @.str.7)
  %63 = load i32, ptr %i, align 4, !dbg !467, !dp.md.instr.id !468
  %inc21 = add nsw i32 %63, 1, !dbg !467, !dp.md.instr.id !469
  %64 = ptrtoint ptr %i to i64
  call void @__dp_write(i32 117, i64 %64, ptr @.str.7)
  store i32 %inc21, ptr %i, align 4, !dbg !467, !dp.md.instr.id !470
  br label %for.cond, !dbg !471, !llvm.loop !472, !dp.md.instr.id !474

for.end22:                                        ; preds = %for.cond
  call void @__dp_loop_exit(i32 16410, i32 0, i32 119), !dp.md.instr.id !475
  %65 = ptrtoint ptr %x to i64
  call void @__dp_read(i32 120, i64 %65, ptr @.str.5)
  %66 = load ptr, ptr %x, align 8, !dbg !476, !dp.md.instr.id !477
  call void @free(ptr noundef %66) #5, !dbg !478, !dp.md.instr.id !479
  %67 = ptrtoint ptr %66 to i64, !dp.md.instr.id !480
  call void @__dp_delete(i32 16410, i64 %67), !dbg !481, !dp.md.instr.id !482
  %68 = ptrtoint ptr %y to i64
  call void @__dp_read(i32 124, i64 %68, ptr @.str.6)
  %69 = load ptr, ptr %y, align 8, !dbg !481, !dp.md.instr.id !483
  call void @free(ptr noundef %69) #5, !dbg !484, !dp.md.instr.id !485
  %70 = ptrtoint ptr %69 to i64, !dp.md.instr.id !486
  call void @__dp_delete(i32 16411, i64 %70), !dbg !487, !dp.md.instr.id !488
  call void @__dp_add_bb_deps(ptr @.dp_bb_deps)
  call void @__dp_finalize(i32 16412), !dbg !487
  call void @__dp_loop_output(), !dbg !487
  ret i32 0, !dbg !487, !dp.md.instr.id !489
}

; Function Attrs: nounwind allocsize(0)
declare noalias ptr @malloc(i64 noundef) #2

; Function Attrs: nounwind
declare void @free(ptr noundef) #3

declare void @__dp_init(i32, i32, i32)

declare void @__dp_finalize(i32)

declare void @__dp_read(i32, i64, ptr)

declare void @__dp_write(i32, i64, ptr)

declare void @__dp_alloca(i32, ptr, i64, i64, i64, i64)

declare void @__dp_new(i32, i64, i64, i64)

declare void @__dp_delete(i32, i64)

declare void @__dp_call(i32, i8)

declare void @__dp_func_entry(i32, i32)

declare void @__dp_func_exit(i32, i32)

declare void @__dp_loop_entry(i32, i32, i32)

declare void @__dp_loop_exit(i32, i32, i32)

declare void @__dp_incr_taken_branch_counter(ptr, i32, i32)

declare void @__dp_report_bb(i32)

declare void @__dp_report_bb_pair(i32, i32)

declare void @__dp_loop_incr(i32, i32)

declare void @__dp_loop_output()

declare void @__dp_taken_branch_counter_output()

declare void @__dp_add_bb_deps(ptr)

attributes #0 = { mustprogress noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress noinline norecurse nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind allocsize(0) }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!11}
!llvm.module.flags = !{!261, !262, !263, !264, !265, !266}
!llvm.ident = !{!267}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "n", scope: !2, file: !3, line: 10, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 9, type: !4, scopeLine: 9, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !11, retainedNodes: !260)
!3 = !DIFile(filename: "code.cpp", directory: "/home/lukas/git/discopop/test/end_to_end/do_all/stack_access/various/case_5/src", checksumkind: CSK_MD5, checksum: "7f2bd2669462f2bef34b8991c164a4eb")
!4 = !DISubroutineType(types: !5)
!5 = !{!6, !6, !7}
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 64)
!9 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !10)
!10 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!11 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !3, producer: "Ubuntu clang version 19.1.1 (1ubuntu1~24.04.2)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !12, globals: !15, imports: !16, splitDebugInlining: false, nameTableKind: None)
!12 = !{!13}
!13 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!14 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!15 = !{!0}
!16 = !{!17, !24, !28, !35, !39, !47, !52, !54, !58, !62, !66, !76, !78, !82, !86, !90, !95, !99, !103, !107, !111, !119, !123, !127, !129, !133, !137, !142, !148, !152, !156, !158, !166, !170, !178, !180, !184, !188, !192, !196, !201, !206, !211, !212, !213, !214, !216, !217, !218, !219, !220, !221, !222, !224, !225, !226, !227, !228, !229, !230, !231, !236, !237, !238, !239, !240, !241, !242, !243, !244, !245, !246, !247, !248, !249, !250, !251, !252, !253, !254, !255, !256, !257, !258, !259}
!17 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !19, file: !23, line: 52)
!18 = !DINamespace(name: "std", scope: null)
!19 = !DISubprogram(name: "abs", scope: !20, file: !20, line: 980, type: !21, flags: DIFlagPrototyped, spFlags: 0)
!20 = !DIFile(filename: "/usr/include/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "7fa2ecb2348a66f8b44ab9a15abd0b72")
!21 = !DISubroutineType(types: !22)
!22 = !{!6, !6}
!23 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/13/../../../../include/c++/13/bits/std_abs.h", directory: "")
!24 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !25, file: !27, line: 131)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !20, line: 63, baseType: !26)
!26 = !DICompositeType(tag: DW_TAG_structure_type, file: !20, line: 59, size: 64, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!27 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/13/../../../../include/c++/13/cstdlib", directory: "")
!28 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !29, file: !27, line: 132)
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !20, line: 71, baseType: !30)
!30 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !20, line: 67, size: 128, flags: DIFlagTypePassByValue, elements: !31, identifier: "_ZTS6ldiv_t")
!31 = !{!32, !34}
!32 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !30, file: !20, line: 69, baseType: !33, size: 64)
!33 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !30, file: !20, line: 70, baseType: !33, size: 64, offset: 64)
!35 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !36, file: !27, line: 134)
!36 = !DISubprogram(name: "abort", scope: !20, file: !20, line: 730, type: !37, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!37 = !DISubroutineType(types: !38)
!38 = !{null}
!39 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !40, file: !27, line: 136)
!40 = !DISubprogram(name: "aligned_alloc", scope: !20, file: !20, line: 724, type: !41, flags: DIFlagPrototyped, spFlags: 0)
!41 = !DISubroutineType(types: !42)
!42 = !{!43, !44, !44}
!43 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!44 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !45, line: 18, baseType: !46)
!45 = !DIFile(filename: "/usr/lib/llvm-19/lib/clang/19/include/__stddef_size_t.h", directory: "", checksumkind: CSK_MD5, checksum: "2c44e821a2b1951cde2eb0fb2e656867")
!46 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!47 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !48, file: !27, line: 138)
!48 = !DISubprogram(name: "atexit", scope: !20, file: !20, line: 734, type: !49, flags: DIFlagPrototyped, spFlags: 0)
!49 = !DISubroutineType(types: !50)
!50 = !{!6, !51}
!51 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64)
!52 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !53, file: !27, line: 141)
!53 = !DISubprogram(name: "at_quick_exit", scope: !20, file: !20, line: 739, type: !49, flags: DIFlagPrototyped, spFlags: 0)
!54 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !55, file: !27, line: 144)
!55 = !DISubprogram(name: "atof", scope: !20, file: !20, line: 102, type: !56, flags: DIFlagPrototyped, spFlags: 0)
!56 = !DISubroutineType(types: !57)
!57 = !{!14, !8}
!58 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !59, file: !27, line: 145)
!59 = !DISubprogram(name: "atoi", scope: !20, file: !20, line: 105, type: !60, flags: DIFlagPrototyped, spFlags: 0)
!60 = !DISubroutineType(types: !61)
!61 = !{!6, !8}
!62 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !63, file: !27, line: 146)
!63 = !DISubprogram(name: "atol", scope: !20, file: !20, line: 108, type: !64, flags: DIFlagPrototyped, spFlags: 0)
!64 = !DISubroutineType(types: !65)
!65 = !{!33, !8}
!66 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !67, file: !27, line: 147)
!67 = !DISubprogram(name: "bsearch", scope: !20, file: !20, line: 960, type: !68, flags: DIFlagPrototyped, spFlags: 0)
!68 = !DISubroutineType(types: !69)
!69 = !{!43, !70, !70, !44, !44, !72}
!70 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !71, size: 64)
!71 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!72 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !20, line: 948, baseType: !73)
!73 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !74, size: 64)
!74 = !DISubroutineType(types: !75)
!75 = !{!6, !70, !70}
!76 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !77, file: !27, line: 148)
!77 = !DISubprogram(name: "calloc", scope: !20, file: !20, line: 675, type: !41, flags: DIFlagPrototyped, spFlags: 0)
!78 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !79, file: !27, line: 149)
!79 = !DISubprogram(name: "div", scope: !20, file: !20, line: 992, type: !80, flags: DIFlagPrototyped, spFlags: 0)
!80 = !DISubroutineType(types: !81)
!81 = !{!25, !6, !6}
!82 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !83, file: !27, line: 150)
!83 = !DISubprogram(name: "exit", scope: !20, file: !20, line: 756, type: !84, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!84 = !DISubroutineType(types: !85)
!85 = !{null, !6}
!86 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !87, file: !27, line: 151)
!87 = !DISubprogram(name: "free", scope: !20, file: !20, line: 687, type: !88, flags: DIFlagPrototyped, spFlags: 0)
!88 = !DISubroutineType(types: !89)
!89 = !{null, !43}
!90 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !91, file: !27, line: 152)
!91 = !DISubprogram(name: "getenv", scope: !20, file: !20, line: 773, type: !92, flags: DIFlagPrototyped, spFlags: 0)
!92 = !DISubroutineType(types: !93)
!93 = !{!94, !8}
!94 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!95 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !96, file: !27, line: 153)
!96 = !DISubprogram(name: "labs", scope: !20, file: !20, line: 981, type: !97, flags: DIFlagPrototyped, spFlags: 0)
!97 = !DISubroutineType(types: !98)
!98 = !{!33, !33}
!99 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !100, file: !27, line: 154)
!100 = !DISubprogram(name: "ldiv", scope: !20, file: !20, line: 994, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!101 = !DISubroutineType(types: !102)
!102 = !{!29, !33, !33}
!103 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !104, file: !27, line: 155)
!104 = !DISubprogram(name: "malloc", scope: !20, file: !20, line: 672, type: !105, flags: DIFlagPrototyped, spFlags: 0)
!105 = !DISubroutineType(types: !106)
!106 = !{!43, !44}
!107 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !108, file: !27, line: 157)
!108 = !DISubprogram(name: "mblen", scope: !20, file: !20, line: 1062, type: !109, flags: DIFlagPrototyped, spFlags: 0)
!109 = !DISubroutineType(types: !110)
!110 = !{!6, !8, !44}
!111 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !112, file: !27, line: 158)
!112 = !DISubprogram(name: "mbstowcs", scope: !20, file: !20, line: 1073, type: !113, flags: DIFlagPrototyped, spFlags: 0)
!113 = !DISubroutineType(types: !114)
!114 = !{!44, !115, !118, !44}
!115 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !116)
!116 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !117, size: 64)
!117 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!118 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !8)
!119 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !120, file: !27, line: 159)
!120 = !DISubprogram(name: "mbtowc", scope: !20, file: !20, line: 1065, type: !121, flags: DIFlagPrototyped, spFlags: 0)
!121 = !DISubroutineType(types: !122)
!122 = !{!6, !115, !118, !44}
!123 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !124, file: !27, line: 161)
!124 = !DISubprogram(name: "qsort", scope: !20, file: !20, line: 970, type: !125, flags: DIFlagPrototyped, spFlags: 0)
!125 = !DISubroutineType(types: !126)
!126 = !{null, !43, !44, !44, !72}
!127 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !128, file: !27, line: 164)
!128 = !DISubprogram(name: "quick_exit", scope: !20, file: !20, line: 762, type: !84, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!129 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !130, file: !27, line: 167)
!130 = !DISubprogram(name: "rand", scope: !20, file: !20, line: 573, type: !131, flags: DIFlagPrototyped, spFlags: 0)
!131 = !DISubroutineType(types: !132)
!132 = !{!6}
!133 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !134, file: !27, line: 168)
!134 = !DISubprogram(name: "realloc", scope: !20, file: !20, line: 683, type: !135, flags: DIFlagPrototyped, spFlags: 0)
!135 = !DISubroutineType(types: !136)
!136 = !{!43, !43, !44}
!137 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !138, file: !27, line: 169)
!138 = !DISubprogram(name: "srand", scope: !20, file: !20, line: 575, type: !139, flags: DIFlagPrototyped, spFlags: 0)
!139 = !DISubroutineType(types: !140)
!140 = !{null, !141}
!141 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!142 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !143, file: !27, line: 170)
!143 = !DISubprogram(name: "strtod", scope: !20, file: !20, line: 118, type: !144, flags: DIFlagPrototyped, spFlags: 0)
!144 = !DISubroutineType(types: !145)
!145 = !{!14, !118, !146}
!146 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !147)
!147 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !94, size: 64)
!148 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !149, file: !27, line: 171)
!149 = !DISubprogram(name: "strtol", linkageName: "__isoc23_strtol", scope: !20, file: !20, line: 215, type: !150, flags: DIFlagPrototyped, spFlags: 0)
!150 = !DISubroutineType(types: !151)
!151 = !{!33, !118, !146, !6}
!152 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !153, file: !27, line: 172)
!153 = !DISubprogram(name: "strtoul", linkageName: "__isoc23_strtoul", scope: !20, file: !20, line: 219, type: !154, flags: DIFlagPrototyped, spFlags: 0)
!154 = !DISubroutineType(types: !155)
!155 = !{!46, !118, !146, !6}
!156 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !157, file: !27, line: 173)
!157 = !DISubprogram(name: "system", scope: !20, file: !20, line: 923, type: !60, flags: DIFlagPrototyped, spFlags: 0)
!158 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !159, file: !27, line: 175)
!159 = !DISubprogram(name: "wcstombs", scope: !20, file: !20, line: 1077, type: !160, flags: DIFlagPrototyped, spFlags: 0)
!160 = !DISubroutineType(types: !161)
!161 = !{!44, !162, !163, !44}
!162 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !94)
!163 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !164)
!164 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !165, size: 64)
!165 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !117)
!166 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !167, file: !27, line: 176)
!167 = !DISubprogram(name: "wctomb", scope: !20, file: !20, line: 1069, type: !168, flags: DIFlagPrototyped, spFlags: 0)
!168 = !DISubroutineType(types: !169)
!169 = !{!6, !94, !117}
!170 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !171, entity: !172, file: !27, line: 204)
!171 = !DINamespace(name: "__gnu_cxx", scope: null)
!172 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !20, line: 81, baseType: !173)
!173 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !20, line: 77, size: 128, flags: DIFlagTypePassByValue, elements: !174, identifier: "_ZTS7lldiv_t")
!174 = !{!175, !177}
!175 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !173, file: !20, line: 79, baseType: !176, size: 64)
!176 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!177 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !173, file: !20, line: 80, baseType: !176, size: 64, offset: 64)
!178 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !171, entity: !179, file: !27, line: 210)
!179 = !DISubprogram(name: "_Exit", scope: !20, file: !20, line: 768, type: !84, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!180 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !171, entity: !181, file: !27, line: 214)
!181 = !DISubprogram(name: "llabs", scope: !20, file: !20, line: 984, type: !182, flags: DIFlagPrototyped, spFlags: 0)
!182 = !DISubroutineType(types: !183)
!183 = !{!176, !176}
!184 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !171, entity: !185, file: !27, line: 220)
!185 = !DISubprogram(name: "lldiv", scope: !20, file: !20, line: 998, type: !186, flags: DIFlagPrototyped, spFlags: 0)
!186 = !DISubroutineType(types: !187)
!187 = !{!172, !176, !176}
!188 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !171, entity: !189, file: !27, line: 231)
!189 = !DISubprogram(name: "atoll", scope: !20, file: !20, line: 113, type: !190, flags: DIFlagPrototyped, spFlags: 0)
!190 = !DISubroutineType(types: !191)
!191 = !{!176, !8}
!192 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !171, entity: !193, file: !27, line: 232)
!193 = !DISubprogram(name: "strtoll", linkageName: "__isoc23_strtoll", scope: !20, file: !20, line: 238, type: !194, flags: DIFlagPrototyped, spFlags: 0)
!194 = !DISubroutineType(types: !195)
!195 = !{!176, !118, !146, !6}
!196 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !171, entity: !197, file: !27, line: 233)
!197 = !DISubprogram(name: "strtoull", linkageName: "__isoc23_strtoull", scope: !20, file: !20, line: 243, type: !198, flags: DIFlagPrototyped, spFlags: 0)
!198 = !DISubroutineType(types: !199)
!199 = !{!200, !118, !146, !6}
!200 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!201 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !171, entity: !202, file: !27, line: 235)
!202 = !DISubprogram(name: "strtof", scope: !20, file: !20, line: 124, type: !203, flags: DIFlagPrototyped, spFlags: 0)
!203 = !DISubroutineType(types: !204)
!204 = !{!205, !118, !146}
!205 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!206 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !171, entity: !207, file: !27, line: 236)
!207 = !DISubprogram(name: "strtold", scope: !20, file: !20, line: 127, type: !208, flags: DIFlagPrototyped, spFlags: 0)
!208 = !DISubroutineType(types: !209)
!209 = !{!210, !118, !146}
!210 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!211 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !172, file: !27, line: 244)
!212 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !179, file: !27, line: 246)
!213 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !181, file: !27, line: 248)
!214 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !215, file: !27, line: 249)
!215 = !DISubprogram(name: "div", linkageName: "_ZN9__gnu_cxx3divExx", scope: !171, file: !27, line: 217, type: !186, flags: DIFlagPrototyped, spFlags: 0)
!216 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !185, file: !27, line: 250)
!217 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !189, file: !27, line: 252)
!218 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !202, file: !27, line: 253)
!219 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !193, file: !27, line: 254)
!220 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !197, file: !27, line: 255)
!221 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !18, entity: !207, file: !27, line: 256)
!222 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !36, file: !223, line: 38)
!223 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/13/../../../../include/c++/13/stdlib.h", directory: "", checksumkind: CSK_MD5, checksum: "3f24ff2a8eef595875da96e5466bd4aa")
!224 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !48, file: !223, line: 39)
!225 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !83, file: !223, line: 40)
!226 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !53, file: !223, line: 43)
!227 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !128, file: !223, line: 46)
!228 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !179, file: !223, line: 49)
!229 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !25, file: !223, line: 54)
!230 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !29, file: !223, line: 55)
!231 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !232, file: !223, line: 57)
!232 = !DISubprogram(name: "abs", linkageName: "_ZSt3absg", scope: !18, file: !23, line: 137, type: !233, flags: DIFlagPrototyped, spFlags: 0)
!233 = !DISubroutineType(types: !234)
!234 = !{!235, !235}
!235 = !DIBasicType(name: "__float128", size: 128, encoding: DW_ATE_float)
!236 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !55, file: !223, line: 58)
!237 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !59, file: !223, line: 59)
!238 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !63, file: !223, line: 60)
!239 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !67, file: !223, line: 61)
!240 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !77, file: !223, line: 62)
!241 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !215, file: !223, line: 63)
!242 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !87, file: !223, line: 64)
!243 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !91, file: !223, line: 65)
!244 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !96, file: !223, line: 66)
!245 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !100, file: !223, line: 67)
!246 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !104, file: !223, line: 68)
!247 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !108, file: !223, line: 70)
!248 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !112, file: !223, line: 71)
!249 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !120, file: !223, line: 72)
!250 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !124, file: !223, line: 74)
!251 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !130, file: !223, line: 75)
!252 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !134, file: !223, line: 76)
!253 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !138, file: !223, line: 77)
!254 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !143, file: !223, line: 78)
!255 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !149, file: !223, line: 79)
!256 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !153, file: !223, line: 80)
!257 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !157, file: !223, line: 81)
!258 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !159, file: !223, line: 83)
!259 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !167, file: !223, line: 84)
!260 = !{}
!261 = !{i32 7, !"Dwarf Version", i32 5}
!262 = !{i32 2, !"Debug Info Version", i32 3}
!263 = !{i32 1, !"wchar_size", i32 4}
!264 = !{i32 8, !"PIC Level", i32 2}
!265 = !{i32 7, !"uwtable", i32 2}
!266 = !{i32 7, !"frame-pointer", i32 2}
!267 = !{!"Ubuntu clang version 19.1.1 (1ubuntu1~24.04.2)"}
!268 = distinct !DISubprogram(name: "f", linkageName: "_Z1fi", scope: !3, file: !3, line: 4, type: !21, scopeLine: 4, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !11, retainedNodes: !260)
!269 = !{!"dp.md.instr.id:2"}
!270 = !{!"dp.md.instr.id:3"}
!271 = !{!"dp.md.instr.id:4"}
!272 = !{!"dp.md.instr.id:5"}
!273 = !{!"dp.md.instr.id:6"}
!274 = !DILocalVariable(name: "t", arg: 1, scope: !268, file: !3, line: 4, type: !6)
!275 = !DILocation(line: 4, column: 11, scope: !268)
!276 = !DILocation(line: 5, column: 7, scope: !268)
!277 = !{!"dp.md.instr.id:7"}
!278 = !DILocation(line: 5, column: 9, scope: !268)
!279 = !{!"dp.md.instr.id:8"}
!280 = !DILocation(line: 5, column: 16, scope: !268)
!281 = !{!"dp.md.instr.id:9"}
!282 = !DILocation(line: 5, column: 14, scope: !268)
!283 = !{!"dp.md.instr.id:10"}
!284 = !DILocation(line: 5, column: 18, scope: !268)
!285 = !{!"dp.md.instr.id:11"}
!286 = !DILocation(line: 5, column: 5, scope: !268)
!287 = !{!"dp.md.instr.id:12"}
!288 = !DILocation(line: 6, column: 10, scope: !268)
!289 = !{!"dp.md.instr.id:13"}
!290 = !DILocation(line: 6, column: 3, scope: !268)
!291 = !{!"dp.md.instr.id:14"}
!292 = !{!"dp.md.instr.id:15"}
!293 = !{!"dp.md.instr.id:16"}
!294 = !{!"dp.md.instr.id:17"}
!295 = !{!"dp.md.instr.id:18"}
!296 = !{!"dp.md.instr.id:19"}
!297 = !{!"dp.md.instr.id:20"}
!298 = !{!"dp.md.instr.id:21"}
!299 = !{!"dp.md.instr.id:22"}
!300 = !{!"dp.md.instr.id:23"}
!301 = !{!"dp.md.instr.id:24"}
!302 = !{!"dp.md.instr.id:25"}
!303 = !{!"dp.md.instr.id:26"}
!304 = !{!"dp.md.instr.id:27"}
!305 = !{!"dp.md.instr.id:28"}
!306 = !{!"dp.md.instr.id:29"}
!307 = !{!"dp.md.instr.id:30"}
!308 = !{!"dp.md.instr.id:31"}
!309 = !{!"dp.md.instr.id:32"}
!310 = !{!"dp.md.instr.id:33"}
!311 = !{!"dp.md.instr.id:34"}
!312 = !{!"dp.md.instr.id:35"}
!313 = !{!"dp.md.instr.id:36"}
!314 = !{!"dp.md.instr.id:37"}
!315 = !{!"dp.md.instr.id:38"}
!316 = !{!"dp.md.instr.id:39"}
!317 = !{!"dp.md.instr.id:40"}
!318 = !{!"dp.md.instr.id:41"}
!319 = !{!"dp.md.instr.id:42"}
!320 = !{!"dp.md.instr.id:43"}
!321 = !{!"dp.md.instr.id:44"}
!322 = !DILocalVariable(name: "argc", arg: 1, scope: !2, file: !3, line: 9, type: !6)
!323 = !DILocation(line: 9, column: 14, scope: !2)
!324 = !{!"dp.md.instr.id:45"}
!325 = !DILocalVariable(name: "argv", arg: 2, scope: !2, file: !3, line: 9, type: !7)
!326 = !DILocation(line: 9, column: 32, scope: !2)
!327 = !DILocalVariable(name: "x", scope: !2, file: !3, line: 11, type: !13)
!328 = !DILocation(line: 11, column: 11, scope: !2)
!329 = !DILocation(line: 11, column: 32, scope: !2)
!330 = !{!"dp.md.instr.id:46"}
!331 = !{!"dp.md.instr.id:47"}
!332 = !DILocation(line: 11, column: 34, scope: !2)
!333 = !{!"dp.md.instr.id:48"}
!334 = !DILocation(line: 11, column: 25, scope: !2)
!335 = !{!"dp.md.instr.id:49"}
!336 = !{!"dp.md.instr.id:50"}
!337 = !{!"dp.md.instr.id:51"}
!338 = !{!"dp.md.instr.id:52"}
!339 = !DILocalVariable(name: "y", scope: !2, file: !3, line: 12, type: !13)
!340 = !DILocation(line: 12, column: 11, scope: !2)
!341 = !DILocation(line: 12, column: 32, scope: !2)
!342 = !{!"dp.md.instr.id:53"}
!343 = !{!"dp.md.instr.id:54"}
!344 = !DILocation(line: 12, column: 34, scope: !2)
!345 = !{!"dp.md.instr.id:55"}
!346 = !DILocation(line: 12, column: 25, scope: !2)
!347 = !{!"dp.md.instr.id:56"}
!348 = !{!"dp.md.instr.id:57"}
!349 = !{!"dp.md.instr.id:58"}
!350 = !{!"dp.md.instr.id:59"}
!351 = !DILocalVariable(name: "i", scope: !352, file: !3, line: 14, type: !6)
!352 = distinct !DILexicalBlock(scope: !2, file: !3, line: 14, column: 3)
!353 = !DILocation(line: 14, column: 12, scope: !352)
!354 = !{!"dp.md.instr.id:60"}
!355 = !DILocation(line: 14, column: 8, scope: !352)
!356 = !{!"dp.md.instr.id:61"}
!357 = !{!"dp.md.instr.id:62"}
!358 = !DILocation(line: 14, column: 19, scope: !359)
!359 = distinct !DILexicalBlock(scope: !352, file: !3, line: 14, column: 3)
!360 = !{!"dp.md.instr.id:63"}
!361 = !DILocation(line: 14, column: 23, scope: !359)
!362 = !{!"dp.md.instr.id:64"}
!363 = !DILocation(line: 14, column: 21, scope: !359)
!364 = !{!"dp.md.instr.id:65"}
!365 = !DILocation(line: 14, column: 3, scope: !352)
!366 = !{!"dp.md.instr.id:66"}
!367 = !DILocalVariable(name: "s", scope: !368, file: !3, line: 15, type: !6)
!368 = distinct !DILexicalBlock(scope: !359, file: !3, line: 14, column: 31)
!369 = !DILocation(line: 15, column: 9, scope: !368)
!370 = !{!"dp.md.instr.id:129"}
!371 = !{!"dp.md.instr.id:67"}
!372 = !DILocalVariable(name: "j", scope: !373, file: !3, line: 16, type: !6)
!373 = distinct !DILexicalBlock(scope: !368, file: !3, line: 16, column: 5)
!374 = !DILocation(line: 16, column: 14, scope: !373)
!375 = !{!"dp.md.instr.id:68"}
!376 = !DILocation(line: 16, column: 10, scope: !373)
!377 = !{!"dp.md.instr.id:69"}
!378 = !{!"dp.md.instr.id:70"}
!379 = !DILocation(line: 16, column: 21, scope: !380)
!380 = distinct !DILexicalBlock(scope: !373, file: !3, line: 16, column: 5)
!381 = !{!"dp.md.instr.id:71"}
!382 = !DILocation(line: 16, column: 25, scope: !380)
!383 = !{!"dp.md.instr.id:72"}
!384 = !DILocation(line: 16, column: 23, scope: !380)
!385 = !{!"dp.md.instr.id:73"}
!386 = !DILocation(line: 16, column: 5, scope: !373)
!387 = !{!"dp.md.instr.id:74"}
!388 = !{!"dp.md.instr.id:130"}
!389 = !DILocation(line: 17, column: 13, scope: !390)
!390 = distinct !DILexicalBlock(scope: !380, file: !3, line: 16, column: 33)
!391 = !{!"dp.md.instr.id:75"}
!392 = !DILocation(line: 17, column: 11, scope: !390)
!393 = !{!"dp.md.instr.id:76"}
!394 = !DILocation(line: 17, column: 9, scope: !390)
!395 = !{!"dp.md.instr.id:77"}
!396 = !DILocation(line: 18, column: 14, scope: !390)
!397 = !{!"dp.md.instr.id:78"}
!398 = !{!"dp.md.instr.id:79"}
!399 = !DILocation(line: 18, column: 7, scope: !390)
!400 = !{!"dp.md.instr.id:80"}
!401 = !DILocation(line: 18, column: 9, scope: !390)
!402 = !{!"dp.md.instr.id:81"}
!403 = !{!"dp.md.instr.id:82"}
!404 = !{!"dp.md.instr.id:83"}
!405 = !DILocation(line: 18, column: 12, scope: !390)
!406 = !{!"dp.md.instr.id:84"}
!407 = !DILocation(line: 19, column: 5, scope: !390)
!408 = !{!"dp.md.instr.id:85"}
!409 = !DILocation(line: 16, column: 29, scope: !380)
!410 = !{!"dp.md.instr.id:86"}
!411 = !{!"dp.md.instr.id:87"}
!412 = !{!"dp.md.instr.id:88"}
!413 = !DILocation(line: 16, column: 5, scope: !380)
!414 = distinct !{!414, !386, !415, !416}
!415 = !DILocation(line: 19, column: 5, scope: !373)
!416 = !{!"llvm.loop.mustprogress"}
!417 = !{!"dp.md.instr.id:89"}
!418 = !DILocalVariable(name: "j", scope: !419, file: !3, line: 20, type: !6)
!419 = distinct !DILexicalBlock(scope: !368, file: !3, line: 20, column: 5)
!420 = !DILocation(line: 20, column: 14, scope: !419)
!421 = !{!"dp.md.instr.id:90"}
!422 = !{!"dp.md.instr.id:91"}
!423 = !DILocation(line: 20, column: 10, scope: !419)
!424 = !{!"dp.md.instr.id:92"}
!425 = !{!"dp.md.instr.id:93"}
!426 = !DILocation(line: 20, column: 21, scope: !427)
!427 = distinct !DILexicalBlock(scope: !419, file: !3, line: 20, column: 5)
!428 = !{!"dp.md.instr.id:94"}
!429 = !DILocation(line: 20, column: 25, scope: !427)
!430 = !{!"dp.md.instr.id:95"}
!431 = !DILocation(line: 20, column: 23, scope: !427)
!432 = !{!"dp.md.instr.id:96"}
!433 = !DILocation(line: 20, column: 5, scope: !419)
!434 = !{!"dp.md.instr.id:97"}
!435 = !{!"dp.md.instr.id:131"}
!436 = !DILocation(line: 21, column: 13, scope: !437)
!437 = distinct !DILexicalBlock(scope: !427, file: !3, line: 20, column: 33)
!438 = !{!"dp.md.instr.id:98"}
!439 = !DILocation(line: 21, column: 11, scope: !437)
!440 = !{!"dp.md.instr.id:99"}
!441 = !DILocation(line: 21, column: 9, scope: !437)
!442 = !{!"dp.md.instr.id:100"}
!443 = !DILocation(line: 22, column: 14, scope: !437)
!444 = !{!"dp.md.instr.id:101"}
!445 = !{!"dp.md.instr.id:102"}
!446 = !DILocation(line: 22, column: 7, scope: !437)
!447 = !{!"dp.md.instr.id:103"}
!448 = !DILocation(line: 22, column: 9, scope: !437)
!449 = !{!"dp.md.instr.id:104"}
!450 = !{!"dp.md.instr.id:105"}
!451 = !{!"dp.md.instr.id:106"}
!452 = !DILocation(line: 22, column: 12, scope: !437)
!453 = !{!"dp.md.instr.id:107"}
!454 = !DILocation(line: 23, column: 5, scope: !437)
!455 = !{!"dp.md.instr.id:108"}
!456 = !DILocation(line: 20, column: 29, scope: !427)
!457 = !{!"dp.md.instr.id:109"}
!458 = !{!"dp.md.instr.id:110"}
!459 = !{!"dp.md.instr.id:111"}
!460 = !DILocation(line: 20, column: 5, scope: !427)
!461 = distinct !{!461, !433, !462, !416}
!462 = !DILocation(line: 23, column: 5, scope: !419)
!463 = !{!"dp.md.instr.id:112"}
!464 = !{!"dp.md.instr.id:113"}
!465 = !DILocation(line: 24, column: 3, scope: !368)
!466 = !{!"dp.md.instr.id:114"}
!467 = !DILocation(line: 14, column: 27, scope: !359)
!468 = !{!"dp.md.instr.id:115"}
!469 = !{!"dp.md.instr.id:116"}
!470 = !{!"dp.md.instr.id:117"}
!471 = !DILocation(line: 14, column: 3, scope: !359)
!472 = distinct !{!472, !365, !473, !416}
!473 = !DILocation(line: 24, column: 3, scope: !352)
!474 = !{!"dp.md.instr.id:118"}
!475 = !{!"dp.md.instr.id:119"}
!476 = !DILocation(line: 26, column: 8, scope: !2)
!477 = !{!"dp.md.instr.id:120"}
!478 = !DILocation(line: 26, column: 3, scope: !2)
!479 = !{!"dp.md.instr.id:121"}
!480 = !{!"dp.md.instr.id:122"}
!481 = !DILocation(line: 27, column: 8, scope: !2)
!482 = !{!"dp.md.instr.id:123"}
!483 = !{!"dp.md.instr.id:124"}
!484 = !DILocation(line: 27, column: 3, scope: !2)
!485 = !{!"dp.md.instr.id:125"}
!486 = !{!"dp.md.instr.id:126"}
!487 = !DILocation(line: 28, column: 3, scope: !2)
!488 = !{!"dp.md.instr.id:127"}
!489 = !{!"dp.md.instr.id:128"}
