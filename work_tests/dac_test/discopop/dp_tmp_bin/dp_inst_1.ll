; ModuleID = 'dp_tmp_bin/dp_inst_1.ll'
source_filename = "/home/raynard/discopop/work_tests/dac_test/test.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [12 x i8] c"a[%d] = %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.2 = private unnamed_addr constant [10 x i8] c"argc.addr\00", align 1
@.str.3 = private unnamed_addr constant [10 x i8] c"argv.addr\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"len\00", align 1
@.str.5 = private unnamed_addr constant [4 x i8] c"sum\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.7 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.dp_bb_deps = private unnamed_addr constant [1003 x i8] c"0=1:15 RAW 1:14|i,1:16 RAW 1:14|i/1=1:12 INIT *|sum,1:14 INIT *|i,1:5 INIT *|argc,1:5 INIT *|argv,1:5 INIT *|retval,1:9 INIT *|len/2=1:14 RAW 1:14|i,1:14 RAW 1:9|len/3=1:23 RAW 1:20|i,1:25 RAW 1:20|i/4=1:28 WAR 1:20|i/5=1:20 WAR 1:14|i/6=1:14 RAW 1:14|i,1:14 WAR 1:14|i/7=1:20 RAW 1:20|i,1:20 RAW 1:9|len/8=1:20 RAW 1:20|i,1:20 WAR 1:20|i/9=1:28 RAW 1:28|i/10=1:29 RAW 1:28|i/11=1:32 WAR 1:28|i/12=1:28 RAW 1:28|i,1:28 WAR 1:28|i/13=1:32 RAW 1:32|i,1:32 RAW 1:9|len/14=1:33 RAW 1:12|sum,1:33 RAW 1:32|i,1:33 WAR 1:33|sum/15=1:36 WAR 1:32|i/16=1:32 RAW 1:32|i,1:32 WAR 1:32|i/17=1:36 RAW 1:36|i,1:36 RAW 1:9|len/18=1:37 RAW 1:36|i/19=1:36 RAW 1:36|i,1:36 WAR 1:36|i/20=1:15 RAW 1:14|i,1:16 RAW 1:14|i/21=1:14 RAW 1:14|i/22=1:14 RAW 1:14|i/23=1:23 RAW 1:20|i,1:25 RAW 1:20|i/24=1:20 RAW 1:20|i/25=1:20 RAW 1:20|i/26=1:28 RAW 1:28|i/27=1:29 RAW 1:28|i/28=1:28 RAW 1:28|i/29=1:33 RAW 1:33|sum/30=1:32 RAW 1:32|i/31=1:33 RAW 1:32|i/32=1:32 RAW 1:32|i/33=1:36 RAW 1:36|i/34=1:37 RAW 1:36|i/35=1:36 RAW 1:36|i\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16389, i32 1)
  %__dp_bb5 = alloca i32
  store i32 0, i32* %__dp_bb5
  %__dp_bb4 = alloca i32
  store i32 0, i32* %__dp_bb4
  %__dp_bb3 = alloca i32
  store i32 0, i32* %__dp_bb3
  %__dp_bb2 = alloca i32
  store i32 0, i32* %__dp_bb2
  %__dp_bb1 = alloca i32
  store i32 0, i32* %__dp_bb1
  %__dp_bb = alloca i32
  store i32 0, i32* %__dp_bb
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %len = alloca i32, align 4
  %a = alloca [100 x i32], align 16
  %b = alloca [100 x i32], align 16
  %sum = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  store i32 0, i32* %retval, align 4
  %1 = ptrtoint i32* %argc.addr to i64
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !15, metadata !DIExpression()), !dbg !16
  %2 = ptrtoint i8*** %argv.addr to i64
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !17, metadata !DIExpression()), !dbg !18
  call void @llvm.dbg.declare(metadata i32* %i, metadata !19, metadata !DIExpression()), !dbg !20
  call void @llvm.dbg.declare(metadata i32* %len, metadata !21, metadata !DIExpression()), !dbg !22
  %3 = ptrtoint i32* %len to i64
  store i32 100, i32* %len, align 4, !dbg !22
  call void @llvm.dbg.declare(metadata [100 x i32]* %a, metadata !23, metadata !DIExpression()), !dbg !27
  call void @llvm.dbg.declare(metadata [100 x i32]* %b, metadata !28, metadata !DIExpression()), !dbg !29
  call void @llvm.dbg.declare(metadata i32* %sum, metadata !30, metadata !DIExpression()), !dbg !31
  %4 = ptrtoint i32* %sum to i64
  store i32 0, i32* %sum, align 4, !dbg !31
  %5 = ptrtoint i32* %i to i64
  store i32 0, i32* %i, align 4, !dbg !32
  call void @__dp_report_bb(i32 1)
  br label %for.cond, !dbg !34

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16398, i32 0)
  %6 = ptrtoint i32* %i to i64
  %7 = load i32, i32* %i, align 4, !dbg !35
  %8 = ptrtoint i32* %len to i64
  %9 = load i32, i32* %len, align 4, !dbg !37
  %cmp = icmp slt i32 %7, %9, !dbg !38
  call void @__dp_report_bb(i32 2)
  %10 = load i32, i32* %__dp_bb
  call void @__dp_report_bb_pair(i32 %10, i32 21)
  br i1 %cmp, label %for.body, label %for.end, !dbg !39

for.body:                                         ; preds = %for.cond
  %11 = ptrtoint i32* %i to i64
  %12 = load i32, i32* %i, align 4, !dbg !40
  %13 = ptrtoint i32* %i to i64
  %14 = load i32, i32* %i, align 4, !dbg !42
  %idxprom = sext i32 %14 to i64, !dbg !43
  %arrayidx = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom, !dbg !43
  %15 = ptrtoint i32* %arrayidx to i64
  call void @__dp_write(i32 16399, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 %12, i32* %arrayidx, align 4, !dbg !44
  %16 = ptrtoint i32* %i to i64
  %17 = load i32, i32* %i, align 4, !dbg !45
  %add = add nsw i32 %17, 1, !dbg !46
  %18 = ptrtoint i32* %i to i64
  %19 = load i32, i32* %i, align 4, !dbg !47
  %idxprom1 = sext i32 %19 to i64, !dbg !48
  %arrayidx2 = getelementptr inbounds [100 x i32], [100 x i32]* %b, i64 0, i64 %idxprom1, !dbg !48
  %20 = ptrtoint i32* %arrayidx2 to i64
  call void @__dp_write(i32 16400, i64 %20, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  store i32 %add, i32* %arrayidx2, align 4, !dbg !49
  call void @__dp_report_bb(i32 0)
  %21 = load i32, i32* %__dp_bb
  call void @__dp_report_bb_pair(i32 %21, i32 20)
  br label %for.inc, !dbg !50

for.inc:                                          ; preds = %for.body
  %22 = ptrtoint i32* %i to i64
  %23 = load i32, i32* %i, align 4, !dbg !51
  %inc = add nsw i32 %23, 1, !dbg !51
  %24 = ptrtoint i32* %i to i64
  store i32 %inc, i32* %i, align 4, !dbg !51
  call void @__dp_report_bb(i32 6)
  %25 = load i32, i32* %__dp_bb
  call void @__dp_report_bb_pair(i32 %25, i32 22)
  store i32 1, i32* %__dp_bb
  br label %for.cond, !dbg !52, !llvm.loop !53

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16404, i32 0)
  %26 = ptrtoint i32* %i to i64
  store i32 0, i32* %i, align 4, !dbg !55
  call void @__dp_report_bb(i32 5)
  br label %for.cond3, !dbg !57

for.cond3:                                        ; preds = %for.inc21, %for.end
  call void @__dp_loop_entry(i32 16404, i32 1)
  %27 = ptrtoint i32* %i to i64
  %28 = load i32, i32* %i, align 4, !dbg !58
  %29 = ptrtoint i32* %len to i64
  %30 = load i32, i32* %len, align 4, !dbg !60
  %sub = sub nsw i32 %30, 1, !dbg !61
  %cmp4 = icmp slt i32 %28, %sub, !dbg !62
  call void @__dp_report_bb(i32 7)
  %31 = load i32, i32* %__dp_bb1
  call void @__dp_report_bb_pair(i32 %31, i32 24)
  br i1 %cmp4, label %for.body5, label %for.end23, !dbg !63

for.body5:                                        ; preds = %for.cond3
  %32 = ptrtoint i32* %i to i64
  %33 = load i32, i32* %i, align 4, !dbg !64
  %idxprom6 = sext i32 %33 to i64, !dbg !66
  %arrayidx7 = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom6, !dbg !66
  %34 = ptrtoint i32* %arrayidx7 to i64
  call void @__dp_read(i32 16407, i64 %34, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %35 = load i32, i32* %arrayidx7, align 4, !dbg !66
  %36 = ptrtoint i32* %i to i64
  %37 = load i32, i32* %i, align 4, !dbg !67
  %idxprom8 = sext i32 %37 to i64, !dbg !68
  %arrayidx9 = getelementptr inbounds [100 x i32], [100 x i32]* %b, i64 0, i64 %idxprom8, !dbg !68
  %38 = ptrtoint i32* %arrayidx9 to i64
  call void @__dp_read(i32 16407, i64 %38, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %39 = load i32, i32* %arrayidx9, align 4, !dbg !68
  %add10 = add nsw i32 %35, %39, !dbg !69
  %add11 = add nsw i32 %add10, 1, !dbg !70
  %40 = ptrtoint i32* %i to i64
  %41 = load i32, i32* %i, align 4, !dbg !71
  %add12 = add nsw i32 %41, 1, !dbg !72
  %idxprom13 = sext i32 %add12 to i64, !dbg !73
  %arrayidx14 = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom13, !dbg !73
  %42 = ptrtoint i32* %arrayidx14 to i64
  call void @__dp_write(i32 16407, i64 %42, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 %add11, i32* %arrayidx14, align 4, !dbg !74
  %43 = ptrtoint i32* %i to i64
  %44 = load i32, i32* %i, align 4, !dbg !75
  %add15 = add nsw i32 %44, 1, !dbg !76
  %idxprom16 = sext i32 %add15 to i64, !dbg !77
  %arrayidx17 = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom16, !dbg !77
  %45 = ptrtoint i32* %arrayidx17 to i64
  call void @__dp_read(i32 16409, i64 %45, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %46 = load i32, i32* %arrayidx17, align 4, !dbg !77
  %add18 = add nsw i32 %46, 2, !dbg !78
  %47 = ptrtoint i32* %i to i64
  %48 = load i32, i32* %i, align 4, !dbg !79
  %idxprom19 = sext i32 %48 to i64, !dbg !80
  %arrayidx20 = getelementptr inbounds [100 x i32], [100 x i32]* %b, i64 0, i64 %idxprom19, !dbg !80
  %49 = ptrtoint i32* %arrayidx20 to i64
  call void @__dp_write(i32 16409, i64 %49, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  store i32 %add18, i32* %arrayidx20, align 4, !dbg !81
  call void @__dp_report_bb(i32 3)
  %50 = load i32, i32* %__dp_bb1
  call void @__dp_report_bb_pair(i32 %50, i32 23)
  br label %for.inc21, !dbg !82

for.inc21:                                        ; preds = %for.body5
  %51 = ptrtoint i32* %i to i64
  %52 = load i32, i32* %i, align 4, !dbg !83
  %inc22 = add nsw i32 %52, 1, !dbg !83
  %53 = ptrtoint i32* %i to i64
  store i32 %inc22, i32* %i, align 4, !dbg !83
  call void @__dp_report_bb(i32 8)
  %54 = load i32, i32* %__dp_bb1
  call void @__dp_report_bb_pair(i32 %54, i32 25)
  store i32 1, i32* %__dp_bb1
  br label %for.cond3, !dbg !84, !llvm.loop !85

for.end23:                                        ; preds = %for.cond3
  call void @__dp_loop_exit(i32 16412, i32 1)
  %55 = ptrtoint i32* %i to i64
  store i32 0, i32* %i, align 4, !dbg !87
  call void @__dp_report_bb(i32 4)
  br label %for.cond24, !dbg !89

for.cond24:                                       ; preds = %for.inc33, %for.end23
  call void @__dp_loop_entry(i32 16412, i32 2)
  %56 = ptrtoint i32* %i to i64
  %57 = load i32, i32* %i, align 4, !dbg !90
  %cmp25 = icmp slt i32 %57, 50, !dbg !92
  call void @__dp_report_bb(i32 9)
  %58 = load i32, i32* %__dp_bb2
  call void @__dp_report_bb_pair(i32 %58, i32 26)
  br i1 %cmp25, label %for.body26, label %for.end35, !dbg !93

for.body26:                                       ; preds = %for.cond24
  %59 = ptrtoint i32* %i to i64
  %60 = load i32, i32* %i, align 4, !dbg !94
  %idxprom27 = sext i32 %60 to i64, !dbg !96
  %arrayidx28 = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom27, !dbg !96
  %61 = ptrtoint i32* %arrayidx28 to i64
  call void @__dp_read(i32 16413, i64 %61, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %62 = load i32, i32* %arrayidx28, align 4, !dbg !96
  %add29 = add nsw i32 %62, 1, !dbg !97
  %63 = ptrtoint i32* %i to i64
  %64 = load i32, i32* %i, align 4, !dbg !98
  %mul = mul nsw i32 2, %64, !dbg !99
  %add30 = add nsw i32 %mul, 1, !dbg !100
  %idxprom31 = sext i32 %add30 to i64, !dbg !101
  %arrayidx32 = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom31, !dbg !101
  %65 = ptrtoint i32* %arrayidx32 to i64
  call void @__dp_write(i32 16413, i64 %65, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 %add29, i32* %arrayidx32, align 4, !dbg !102
  call void @__dp_report_bb(i32 10)
  %66 = load i32, i32* %__dp_bb2
  call void @__dp_report_bb_pair(i32 %66, i32 27)
  br label %for.inc33, !dbg !103

for.inc33:                                        ; preds = %for.body26
  %67 = ptrtoint i32* %i to i64
  %68 = load i32, i32* %i, align 4, !dbg !104
  %inc34 = add nsw i32 %68, 1, !dbg !104
  %69 = ptrtoint i32* %i to i64
  store i32 %inc34, i32* %i, align 4, !dbg !104
  call void @__dp_report_bb(i32 12)
  %70 = load i32, i32* %__dp_bb2
  call void @__dp_report_bb_pair(i32 %70, i32 28)
  store i32 1, i32* %__dp_bb2
  br label %for.cond24, !dbg !105, !llvm.loop !106

for.end35:                                        ; preds = %for.cond24
  call void @__dp_loop_exit(i32 16416, i32 2)
  %71 = ptrtoint i32* %i to i64
  store i32 0, i32* %i, align 4, !dbg !108
  call void @__dp_report_bb(i32 11)
  br label %for.cond36, !dbg !110

for.cond36:                                       ; preds = %for.inc42, %for.end35
  call void @__dp_loop_entry(i32 16416, i32 3)
  %72 = ptrtoint i32* %i to i64
  %73 = load i32, i32* %i, align 4, !dbg !111
  %74 = ptrtoint i32* %len to i64
  %75 = load i32, i32* %len, align 4, !dbg !113
  %cmp37 = icmp slt i32 %73, %75, !dbg !114
  call void @__dp_report_bb(i32 13)
  %76 = load i32, i32* %__dp_bb4
  call void @__dp_report_bb_pair(i32 %76, i32 30)
  br i1 %cmp37, label %for.body38, label %for.end44, !dbg !115

for.body38:                                       ; preds = %for.cond36
  %77 = ptrtoint i32* %sum to i64
  %78 = load i32, i32* %sum, align 4, !dbg !116
  %79 = ptrtoint i32* %i to i64
  %80 = load i32, i32* %i, align 4, !dbg !118
  %idxprom39 = sext i32 %80 to i64, !dbg !119
  %arrayidx40 = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom39, !dbg !119
  %81 = ptrtoint i32* %arrayidx40 to i64
  call void @__dp_read(i32 16417, i64 %81, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %82 = load i32, i32* %arrayidx40, align 4, !dbg !119
  %add41 = add nsw i32 %78, %82, !dbg !120
  %83 = ptrtoint i32* %sum to i64
  store i32 %add41, i32* %sum, align 4, !dbg !121
  call void @__dp_report_bb(i32 14)
  %84 = load i32, i32* %__dp_bb3
  call void @__dp_report_bb_pair(i32 %84, i32 29)
  store i32 1, i32* %__dp_bb3
  %85 = load i32, i32* %__dp_bb4
  call void @__dp_report_bb_pair(i32 %85, i32 31)
  br label %for.inc42, !dbg !122

for.inc42:                                        ; preds = %for.body38
  %86 = ptrtoint i32* %i to i64
  %87 = load i32, i32* %i, align 4, !dbg !123
  %inc43 = add nsw i32 %87, 1, !dbg !123
  %88 = ptrtoint i32* %i to i64
  store i32 %inc43, i32* %i, align 4, !dbg !123
  call void @__dp_report_bb(i32 16)
  %89 = load i32, i32* %__dp_bb4
  call void @__dp_report_bb_pair(i32 %89, i32 32)
  store i32 1, i32* %__dp_bb4
  br label %for.cond36, !dbg !124, !llvm.loop !125

for.end44:                                        ; preds = %for.cond36
  call void @__dp_loop_exit(i32 16420, i32 3)
  %90 = ptrtoint i32* %i to i64
  store i32 0, i32* %i, align 4, !dbg !127
  call void @__dp_report_bb(i32 15)
  br label %for.cond45, !dbg !129

for.cond45:                                       ; preds = %for.inc50, %for.end44
  call void @__dp_loop_entry(i32 16420, i32 4)
  %91 = ptrtoint i32* %i to i64
  %92 = load i32, i32* %i, align 4, !dbg !130
  %93 = ptrtoint i32* %len to i64
  %94 = load i32, i32* %len, align 4, !dbg !132
  %cmp46 = icmp slt i32 %92, %94, !dbg !133
  call void @__dp_report_bb(i32 17)
  %95 = load i32, i32* %__dp_bb5
  call void @__dp_report_bb_pair(i32 %95, i32 33)
  br i1 %cmp46, label %for.body47, label %for.end52, !dbg !134

for.body47:                                       ; preds = %for.cond45
  %96 = ptrtoint i32* %i to i64
  %97 = load i32, i32* %i, align 4, !dbg !135
  %98 = ptrtoint i32* %i to i64
  %99 = load i32, i32* %i, align 4, !dbg !137
  %idxprom48 = sext i32 %99 to i64, !dbg !138
  %arrayidx49 = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom48, !dbg !138
  %100 = ptrtoint i32* %arrayidx49 to i64
  call void @__dp_read(i32 16421, i64 %100, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %101 = load i32, i32* %arrayidx49, align 4, !dbg !138
  call void @__dp_call(i32 16421), !dbg !139
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i32 0, i32 0), i32 %97, i32 %101), !dbg !139
  call void @__dp_report_bb(i32 18)
  %102 = load i32, i32* %__dp_bb5
  call void @__dp_report_bb_pair(i32 %102, i32 34)
  br label %for.inc50, !dbg !140

for.inc50:                                        ; preds = %for.body47
  %103 = ptrtoint i32* %i to i64
  %104 = load i32, i32* %i, align 4, !dbg !141
  %inc51 = add nsw i32 %104, 1, !dbg !141
  %105 = ptrtoint i32* %i to i64
  store i32 %inc51, i32* %i, align 4, !dbg !141
  call void @__dp_report_bb(i32 19)
  %106 = load i32, i32* %__dp_bb5
  call void @__dp_report_bb_pair(i32 %106, i32 35)
  store i32 1, i32* %__dp_bb5
  br label %for.cond45, !dbg !142, !llvm.loop !143

for.end52:                                        ; preds = %for.cond45
  call void @__dp_loop_exit(i32 16424, i32 4)
  call void @__dp_add_bb_deps(i8* getelementptr inbounds ([1003 x i8], [1003 x i8]* @.dp_bb_deps, i32 0, i32 0))
  call void @__dp_finalize(i32 16424), !dbg !145
  ret i32 0, !dbg !145
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @printf(i8*, ...) #2

declare void @__dp_init(i32, i32, i32)

declare void @__dp_finalize(i32)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_write(i32, i64, i8*)

declare void @__dp_call(i32)

declare void @__dp_func_entry(i32, i32)

declare void @__dp_func_exit(i32, i32)

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_loop_exit(i32, i32)

declare void @__dp_report_bb(i32)

declare void @__dp_report_bb_pair(i32, i32)

declare void @__dp_add_bb_deps(i8*)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 8.0.1 (tags/RELEASE_801/final)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, nameTableKind: None)
!1 = !DIFile(filename: "/home/raynard/discopop/work_tests/dac_test/test.c", directory: "/home/raynard/discopop/work_tests/dac_test/discopop")
!2 = !{}
!3 = !{i32 2, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"clang version 8.0.1 (tags/RELEASE_801/final)"}
!7 = distinct !DISubprogram(name: "main", scope: !8, file: !8, line: 5, type: !9, scopeLine: 6, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DIFile(filename: "test.c", directory: "/home/raynard/discopop/work_tests/dac_test")
!9 = !DISubroutineType(types: !10)
!10 = !{!11, !11, !12}
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!13 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!14 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!15 = !DILocalVariable(name: "argc", arg: 1, scope: !7, file: !8, line: 5, type: !11)
!16 = !DILocation(line: 5, column: 14, scope: !7)
!17 = !DILocalVariable(name: "argv", arg: 2, scope: !7, file: !8, line: 5, type: !12)
!18 = !DILocation(line: 5, column: 26, scope: !7)
!19 = !DILocalVariable(name: "i", scope: !7, file: !8, line: 8, type: !11)
!20 = !DILocation(line: 8, column: 9, scope: !7)
!21 = !DILocalVariable(name: "len", scope: !7, file: !8, line: 9, type: !11)
!22 = !DILocation(line: 9, column: 9, scope: !7)
!23 = !DILocalVariable(name: "a", scope: !7, file: !8, line: 10, type: !24)
!24 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 3200, elements: !25)
!25 = !{!26}
!26 = !DISubrange(count: 100)
!27 = !DILocation(line: 10, column: 9, scope: !7)
!28 = !DILocalVariable(name: "b", scope: !7, file: !8, line: 11, type: !24)
!29 = !DILocation(line: 11, column: 9, scope: !7)
!30 = !DILocalVariable(name: "sum", scope: !7, file: !8, line: 12, type: !11)
!31 = !DILocation(line: 12, column: 9, scope: !7)
!32 = !DILocation(line: 14, column: 11, scope: !33)
!33 = distinct !DILexicalBlock(scope: !7, file: !8, line: 14, column: 5)
!34 = !DILocation(line: 14, column: 10, scope: !33)
!35 = !DILocation(line: 14, column: 14, scope: !36)
!36 = distinct !DILexicalBlock(scope: !33, file: !8, line: 14, column: 5)
!37 = !DILocation(line: 14, column: 16, scope: !36)
!38 = !DILocation(line: 14, column: 15, scope: !36)
!39 = !DILocation(line: 14, column: 5, scope: !33)
!40 = !DILocation(line: 15, column: 14, scope: !41)
!41 = distinct !DILexicalBlock(scope: !36, file: !8, line: 14, column: 24)
!42 = !DILocation(line: 15, column: 11, scope: !41)
!43 = !DILocation(line: 15, column: 9, scope: !41)
!44 = !DILocation(line: 15, column: 13, scope: !41)
!45 = !DILocation(line: 16, column: 14, scope: !41)
!46 = !DILocation(line: 16, column: 15, scope: !41)
!47 = !DILocation(line: 16, column: 11, scope: !41)
!48 = !DILocation(line: 16, column: 9, scope: !41)
!49 = !DILocation(line: 16, column: 13, scope: !41)
!50 = !DILocation(line: 17, column: 5, scope: !41)
!51 = !DILocation(line: 14, column: 21, scope: !36)
!52 = !DILocation(line: 14, column: 5, scope: !36)
!53 = distinct !{!53, !39, !54}
!54 = !DILocation(line: 17, column: 5, scope: !33)
!55 = !DILocation(line: 20, column: 11, scope: !56)
!56 = distinct !DILexicalBlock(scope: !7, file: !8, line: 20, column: 5)
!57 = !DILocation(line: 20, column: 10, scope: !56)
!58 = !DILocation(line: 20, column: 14, scope: !59)
!59 = distinct !DILexicalBlock(scope: !56, file: !8, line: 20, column: 5)
!60 = !DILocation(line: 20, column: 16, scope: !59)
!61 = !DILocation(line: 20, column: 19, scope: !59)
!62 = !DILocation(line: 20, column: 15, scope: !59)
!63 = !DILocation(line: 20, column: 5, scope: !56)
!64 = !DILocation(line: 23, column: 18, scope: !65)
!65 = distinct !DILexicalBlock(scope: !59, file: !8, line: 20, column: 26)
!66 = !DILocation(line: 23, column: 16, scope: !65)
!67 = !DILocation(line: 23, column: 25, scope: !65)
!68 = !DILocation(line: 23, column: 23, scope: !65)
!69 = !DILocation(line: 23, column: 21, scope: !65)
!70 = !DILocation(line: 23, column: 27, scope: !65)
!71 = !DILocation(line: 23, column: 11, scope: !65)
!72 = !DILocation(line: 23, column: 12, scope: !65)
!73 = !DILocation(line: 23, column: 9, scope: !65)
!74 = !DILocation(line: 23, column: 15, scope: !65)
!75 = !DILocation(line: 25, column: 18, scope: !65)
!76 = !DILocation(line: 25, column: 19, scope: !65)
!77 = !DILocation(line: 25, column: 16, scope: !65)
!78 = !DILocation(line: 25, column: 23, scope: !65)
!79 = !DILocation(line: 25, column: 11, scope: !65)
!80 = !DILocation(line: 25, column: 9, scope: !65)
!81 = !DILocation(line: 25, column: 14, scope: !65)
!82 = !DILocation(line: 26, column: 5, scope: !65)
!83 = !DILocation(line: 20, column: 23, scope: !59)
!84 = !DILocation(line: 20, column: 5, scope: !59)
!85 = distinct !{!85, !63, !86}
!86 = !DILocation(line: 26, column: 5, scope: !56)
!87 = !DILocation(line: 28, column: 11, scope: !88)
!88 = distinct !DILexicalBlock(scope: !7, file: !8, line: 28, column: 5)
!89 = !DILocation(line: 28, column: 10, scope: !88)
!90 = !DILocation(line: 28, column: 14, scope: !91)
!91 = distinct !DILexicalBlock(scope: !88, file: !8, line: 28, column: 5)
!92 = !DILocation(line: 28, column: 15, scope: !91)
!93 = !DILocation(line: 28, column: 5, scope: !88)
!94 = !DILocation(line: 29, column: 20, scope: !95)
!95 = distinct !DILexicalBlock(scope: !91, file: !8, line: 28, column: 23)
!96 = !DILocation(line: 29, column: 18, scope: !95)
!97 = !DILocation(line: 29, column: 22, scope: !95)
!98 = !DILocation(line: 29, column: 13, scope: !95)
!99 = !DILocation(line: 29, column: 12, scope: !95)
!100 = !DILocation(line: 29, column: 14, scope: !95)
!101 = !DILocation(line: 29, column: 9, scope: !95)
!102 = !DILocation(line: 29, column: 17, scope: !95)
!103 = !DILocation(line: 30, column: 5, scope: !95)
!104 = !DILocation(line: 28, column: 20, scope: !91)
!105 = !DILocation(line: 28, column: 5, scope: !91)
!106 = distinct !{!106, !93, !107}
!107 = !DILocation(line: 30, column: 5, scope: !88)
!108 = !DILocation(line: 32, column: 11, scope: !109)
!109 = distinct !DILexicalBlock(scope: !7, file: !8, line: 32, column: 5)
!110 = !DILocation(line: 32, column: 10, scope: !109)
!111 = !DILocation(line: 32, column: 15, scope: !112)
!112 = distinct !DILexicalBlock(scope: !109, file: !8, line: 32, column: 5)
!113 = !DILocation(line: 32, column: 17, scope: !112)
!114 = !DILocation(line: 32, column: 16, scope: !112)
!115 = !DILocation(line: 32, column: 5, scope: !109)
!116 = !DILocation(line: 33, column: 15, scope: !117)
!117 = distinct !DILexicalBlock(scope: !112, file: !8, line: 32, column: 26)
!118 = !DILocation(line: 33, column: 23, scope: !117)
!119 = !DILocation(line: 33, column: 21, scope: !117)
!120 = !DILocation(line: 33, column: 19, scope: !117)
!121 = !DILocation(line: 33, column: 13, scope: !117)
!122 = !DILocation(line: 34, column: 5, scope: !117)
!123 = !DILocation(line: 32, column: 23, scope: !112)
!124 = !DILocation(line: 32, column: 5, scope: !112)
!125 = distinct !{!125, !115, !126}
!126 = !DILocation(line: 34, column: 5, scope: !109)
!127 = !DILocation(line: 36, column: 11, scope: !128)
!128 = distinct !DILexicalBlock(scope: !7, file: !8, line: 36, column: 5)
!129 = !DILocation(line: 36, column: 10, scope: !128)
!130 = !DILocation(line: 36, column: 14, scope: !131)
!131 = distinct !DILexicalBlock(scope: !128, file: !8, line: 36, column: 5)
!132 = !DILocation(line: 36, column: 16, scope: !131)
!133 = !DILocation(line: 36, column: 15, scope: !131)
!134 = !DILocation(line: 36, column: 5, scope: !128)
!135 = !DILocation(line: 37, column: 32, scope: !136)
!136 = distinct !DILexicalBlock(scope: !131, file: !8, line: 36, column: 24)
!137 = !DILocation(line: 37, column: 37, scope: !136)
!138 = !DILocation(line: 37, column: 35, scope: !136)
!139 = !DILocation(line: 37, column: 9, scope: !136)
!140 = !DILocation(line: 38, column: 5, scope: !136)
!141 = !DILocation(line: 36, column: 21, scope: !131)
!142 = !DILocation(line: 36, column: 5, scope: !131)
!143 = distinct !{!143, !134, !144}
!144 = !DILocation(line: 38, column: 5, scope: !128)
!145 = !DILocation(line: 40, column: 5, scope: !7)
