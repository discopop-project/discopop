; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, %struct._IO_codecvt*, %struct._IO_wide_data*, %struct._IO_FILE*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type opaque
%struct._IO_codecvt = type opaque
%struct._IO_wide_data = type opaque
%struct.timeval = type { i64, i64 }
%struct.tm = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i64, i8* }
%struct.utsname = type { [65 x i8], [65 x i8], [65 x i8], [65 x i8], [65 x i8], [65 x i8] }

@total_count = common dso_local global i32 0, align 4, !dbg !0
@.str.2 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.3 = private unnamed_addr constant [7 x i8] c"n.addr\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c"a.addr\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"p\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"j\00", align 1
@.str.7 = private unnamed_addr constant [2 x i8] c"q\00", align 1
@.str.8 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.9 = private unnamed_addr constant [7 x i8] c"j.addr\00", align 1
@.str.10 = private unnamed_addr constant [15 x i8] c"solutions.addr\00", align 1
@.str.11 = private unnamed_addr constant [4 x i8] c"res\00", align 1
@.str.12 = private unnamed_addr constant [12 x i8] c"total_count\00", align 1
@.str.13 = private unnamed_addr constant [10 x i8] c"size.addr\00", align 1
@.str.14 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.15 = private unnamed_addr constant [18 x i8] c"bots_verbose_mode\00", align 1
@stdout = external dso_local global %struct._IO_FILE*, align 8
@.str.16 = private unnamed_addr constant [7 x i8] c"stdout\00", align 1
@.str = private unnamed_addr constant [37 x i8] c"Computing N-Queens algorithm (n=%d) \00", align 1
@.str.1 = private unnamed_addr constant [13 x i8] c" completed!\0A\00", align 1
@solutions = internal global [14 x i32] [i32 1, i32 0, i32 0, i32 2, i32 10, i32 4, i32 40, i32 92, i32 352, i32 724, i32 2680, i32 14200, i32 73712, i32 365596], align 16, !dbg !16
@.str.17 = private unnamed_addr constant [10 x i8] c"solutions\00", align 1
@.str.48 = private unnamed_addr constant [13 x i8] c"message.addr\00", align 1
@.str.49 = private unnamed_addr constant [11 x i8] c"error.addr\00", align 1
@stderr = external dso_local global %struct._IO_FILE*, align 8
@.str.50 = private unnamed_addr constant [7 x i8] c"stderr\00", align 1
@.str.18 = private unnamed_addr constant [16 x i8] c"Error (%d): %s\0A\00", align 1
@.str.1.19 = private unnamed_addr constant [19 x i8] c"Unspecified error.\00", align 1
@.str.2.20 = private unnamed_addr constant [19 x i8] c"Not enough memory.\00", align 1
@.str.3.21 = private unnamed_addr constant [24 x i8] c"Unrecognized parameter.\00", align 1
@.str.4.22 = private unnamed_addr constant [20 x i8] c"Invalid error code.\00", align 1
@.str.51 = private unnamed_addr constant [13 x i8] c"warning.addr\00", align 1
@.str.5.23 = private unnamed_addr constant [18 x i8] c"Warning (%d): %s\0A\00", align 1
@.str.6.24 = private unnamed_addr constant [21 x i8] c"Unspecified warning.\00", align 1
@.str.7.25 = private unnamed_addr constant [22 x i8] c"Invalid warning code.\00", align 1
@.str.52 = private unnamed_addr constant [2 x i8] c"t\00", align 1
@.str.53 = private unnamed_addr constant [9 x i8] c"str.addr\00", align 1
@.str.8.26 = private unnamed_addr constant [15 x i8] c"%Y/%m/%d;%H:%M\00", align 1
@.str.54 = private unnamed_addr constant [6 x i8] c"ncpus\00", align 1
@.str.9.27 = private unnamed_addr constant [9 x i8] c"%s-%s;%d\00", align 1
@.str.55 = private unnamed_addr constant [8 x i8] c"loadavg\00", align 1
@.str.10.28 = private unnamed_addr constant [15 x i8] c"%.2f;%.2f;%.2f\00", align 1
@.str.11.29 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.56 = private unnamed_addr constant [12 x i8] c"bots_result\00", align 1
@.str.12.30 = private unnamed_addr constant [4 x i8] c"n/a\00", align 1
@.str.13.31 = private unnamed_addr constant [11 x i8] c"successful\00", align 1
@.str.14.32 = private unnamed_addr constant [13 x i8] c"UNSUCCESSFUL\00", align 1
@.str.15.33 = private unnamed_addr constant [14 x i8] c"Not requested\00", align 1
@.str.16.34 = private unnamed_addr constant [6 x i8] c"error\00", align 1
@.str.57 = private unnamed_addr constant [18 x i8] c"bots_time_program\00", align 1
@.str.17.35 = private unnamed_addr constant [3 x i8] c"%f\00", align 1
@.str.58 = private unnamed_addr constant [21 x i8] c"bots_sequential_flag\00", align 1
@.str.59 = private unnamed_addr constant [21 x i8] c"bots_time_sequential\00", align 1
@.str.18.36 = private unnamed_addr constant [6 x i8] c"%3.2f\00", align 1
@.str.60 = private unnamed_addr constant [21 x i8] c"bots_number_of_tasks\00", align 1
@.str.61 = private unnamed_addr constant [18 x i8] c"bots_print_header\00", align 1
@.str.62 = private unnamed_addr constant [19 x i8] c"bots_output_format\00", align 1
@.str.63 = private unnamed_addr constant [7 x i8] c"stdout\00", align 1
@.str.19 = private unnamed_addr constant [238 x i8] c"Benchmark;Parameters;Model;Cutoff;Resources;Result;Time;Sequential;Speed-up;Nodes;Nodes/Sec;Exec Date;Exec Time;Exec Message;Architecture;Processors;Load Avg-1;Load Avg-5;Load Avg-15;Comp Date;Comp Time;Comp Message;CC;CFLAGS;LD;LDFLAGS\0A\00", align 1
@.str.20 = private unnamed_addr constant [94 x i8] c"Benchmark;Parameters;Model;Cutoff;Resources;Result;Time;Sequential;Speed-up;Nodes;Nodes/Sec;\0A\00", align 1
@.str.21 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.22 = private unnamed_addr constant [26 x i8] c"Program             = %s\0A\00", align 1
@.str.23 = private unnamed_addr constant [26 x i8] c"Parameters          = %s\0A\00", align 1
@.str.24 = private unnamed_addr constant [26 x i8] c"Model               = %s\0A\00", align 1
@.str.25 = private unnamed_addr constant [26 x i8] c"Embedded cut-off    = %s\0A\00", align 1
@.str.26 = private unnamed_addr constant [26 x i8] c"# of Threads        = %s\0A\00", align 1
@.str.27 = private unnamed_addr constant [26 x i8] c"Verification        = %s\0A\00", align 1
@.str.28 = private unnamed_addr constant [34 x i8] c"Time Program        = %s seconds\0A\00", align 1
@.str.29 = private unnamed_addr constant [34 x i8] c"Time Sequential     = %s seconds\0A\00", align 1
@.str.30 = private unnamed_addr constant [26 x i8] c"Speed-up            = %s\0A\00", align 1
@.str.31 = private unnamed_addr constant [26 x i8] c"Nodes               = %s\0A\00", align 1
@.str.32 = private unnamed_addr constant [26 x i8] c"Nodes/Sec           = %s\0A\00", align 1
@.str.33 = private unnamed_addr constant [26 x i8] c"Execution Date      = %s\0A\00", align 1
@.str.34 = private unnamed_addr constant [26 x i8] c"Execution Message   = %s\0A\00", align 1
@.str.35 = private unnamed_addr constant [26 x i8] c"Architecture        = %s\0A\00", align 1
@.str.36 = private unnamed_addr constant [26 x i8] c"Load Avg [1:5:15]   = %s\0A\00", align 1
@.str.37 = private unnamed_addr constant [26 x i8] c"Compilation Date    = %s\0A\00", align 1
@.str.38 = private unnamed_addr constant [26 x i8] c"Compilation Message = %s\0A\00", align 1
@.str.39 = private unnamed_addr constant [26 x i8] c"Compiler            = %s\0A\00", align 1
@.str.40 = private unnamed_addr constant [26 x i8] c"Compiler Flags      = %s\0A\00", align 1
@.str.41 = private unnamed_addr constant [26 x i8] c"Linker              = %s\0A\00", align 1
@.str.42 = private unnamed_addr constant [26 x i8] c"Linker Flags        = %s\0A\00", align 1
@.str.43 = private unnamed_addr constant [19 x i8] c"%s;%s;%s;%s;%s;%s;\00", align 1
@.str.44 = private unnamed_addr constant [10 x i8] c"%s;%s;%s;\00", align 1
@.str.45 = private unnamed_addr constant [7 x i8] c"%s;%s;\00", align 1
@.str.46 = private unnamed_addr constant [13 x i8] c"%s;%s;%s;%s;\00", align 1
@.str.47 = private unnamed_addr constant [24 x i8] c"No valid output format\0A\00", align 1
@bots_sequential_flag = dso_local global i32 0, align 4, !dbg !22
@bots_check_flag = dso_local global i32 0, align 4, !dbg !30
@bots_verbose_mode = dso_local global i32 1, align 4, !dbg !32
@bots_result = dso_local global i32 3, align 4, !dbg !34
@bots_output_format = dso_local global i32 1, align 4, !dbg !36
@bots_print_header = dso_local global i32 0, align 4, !dbg !38
@bots_time_program = dso_local global double 0.000000e+00, align 8, !dbg !40
@bots_time_sequential = dso_local global double 0.000000e+00, align 8, !dbg !42
@bots_number_of_tasks = dso_local global i64 0, align 8, !dbg !44
@bots_arg_size = dso_local global i32 14, align 4, !dbg !47
@bots_execname = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !54
@bots_exec_date = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !62
@bots_exec_message = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !64
@bots_name = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !49
@bots_parameters = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !56
@bots_model = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !58
@bots_resources = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !60
@bots_comp_date = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !66
@bots_comp_message = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !68
@bots_cc = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !70
@bots_cflags = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !72
@bots_ld = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !74
@bots_ldflags = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !76
@bots_cutoff = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !78
@.str.26.81 = private unnamed_addr constant [7 x i8] c"stderr\00", align 1
@.str.82 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.1.83 = private unnamed_addr constant [22 x i8] c"Usage: %s -[options]\0A\00", align 1
@.str.2.84 = private unnamed_addr constant [20 x i8] c"Where options are:\0A\00", align 1
@.str.3.85 = private unnamed_addr constant [27 x i8] c"  -n <size>  : Board size\0A\00", align 1
@.str.4.86 = private unnamed_addr constant [49 x i8] c"  -e <str>   : Include 'str' execution message.\0A\00", align 1
@.str.5.87 = private unnamed_addr constant [49 x i8] c"  -v <level> : Set verbose level (default = 1).\0A\00", align 1
@.str.6.88 = private unnamed_addr constant [26 x i8] c"               0 - none.\0A\00", align 1
@.str.7.89 = private unnamed_addr constant [29 x i8] c"               1 - default.\0A\00", align 1
@.str.8.90 = private unnamed_addr constant [27 x i8] c"               2 - debug.\0A\00", align 1
@.str.9.91 = private unnamed_addr constant [54 x i8] c"  -o <value> : Set output format mode (default = 1).\0A\00", align 1
@.str.10.92 = private unnamed_addr constant [41 x i8] c"               0 - no benchmark output.\0A\00", align 1
@.str.11.93 = private unnamed_addr constant [42 x i8] c"               1 - detailed list format.\0A\00", align 1
@.str.12.94 = private unnamed_addr constant [41 x i8] c"               2 - detailed row format.\0A\00", align 1
@.str.13.95 = private unnamed_addr constant [42 x i8] c"               3 - abridged list format.\0A\00", align 1
@.str.14.96 = private unnamed_addr constant [41 x i8] c"               4 - abridged row format.\0A\00", align 1
@.str.15.97 = private unnamed_addr constant [70 x i8] c"  -z         : Print row header (if output format is a row variant).\0A\00", align 1
@.str.16.98 = private unnamed_addr constant [31 x i8] c"  -c         : Check mode ON.\0A\00", align 1
@.str.17.99 = private unnamed_addr constant [51 x i8] c"  -h         : Print program's usage (this help).\0A\00", align 1
@.str.27.100 = private unnamed_addr constant [10 x i8] c"argv.addr\00", align 1
@.str.18.101 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.28.102 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.29.103 = private unnamed_addr constant [10 x i8] c"argc.addr\00", align 1
@.str.30.104 = private unnamed_addr constant [16 x i8] c"bots_check_flag\00", align 1
@.str.31.105 = private unnamed_addr constant [14 x i8] c"bots_arg_size\00", align 1
@.str.32.106 = private unnamed_addr constant [19 x i8] c"bots_output_format\00", align 1
@.str.33.107 = private unnamed_addr constant [18 x i8] c"bots_verbose_mode\00", align 1
@.str.19.108 = private unnamed_addr constant [100 x i8] c"Error: Configure the suite using '--debug' option in order to use a verbose level greather than 1.\0A\00", align 1
@.str.34.109 = private unnamed_addr constant [18 x i8] c"bots_print_header\00", align 1
@.str.20.110 = private unnamed_addr constant [32 x i8] c"Error: Unrecognized parameter.\0A\00", align 1
@.str.21.111 = private unnamed_addr constant [9 x i8] c"N Queens\00", align 1
@.str.22.112 = private unnamed_addr constant [5 x i8] c"N=%d\00", align 1
@.str.23.113 = private unnamed_addr constant [7 x i8] c"Serial\00", align 1
@.str.24.114 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str.25.115 = private unnamed_addr constant [5 x i8] c"none\00", align 1
@.str.35.116 = private unnamed_addr constant [13 x i8] c"bots_t_start\00", align 1
@.str.36.117 = private unnamed_addr constant [11 x i8] c"bots_t_end\00", align 1
@.str.37.118 = private unnamed_addr constant [18 x i8] c"bots_time_program\00", align 1
@.str.38.119 = private unnamed_addr constant [12 x i8] c"bots_result\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @ok(i32 %n, i8* %a) #0 !dbg !308 {
entry:
  call void @__dp_func_entry(i32 114750, i32 0)
  %retval = alloca i32, align 4
  %n.addr = alloca i32, align 4
  %a.addr = alloca i8*, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %p = alloca i8, align 1
  %q = alloca i8, align 1
  store i32 %n, i32* %n.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %n.addr, metadata !312, metadata !DIExpression()), !dbg !313
  store i8* %a, i8** %a.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %a.addr, metadata !314, metadata !DIExpression()), !dbg !315
  call void @llvm.dbg.declare(metadata i32* %i, metadata !316, metadata !DIExpression()), !dbg !317
  call void @llvm.dbg.declare(metadata i32* %j, metadata !318, metadata !DIExpression()), !dbg !319
  call void @llvm.dbg.declare(metadata i8* %p, metadata !320, metadata !DIExpression()), !dbg !321
  call void @llvm.dbg.declare(metadata i8* %q, metadata !322, metadata !DIExpression()), !dbg !323
  %0 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 114755, i64 %0, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !324
  br label %for.cond, !dbg !326

for.cond:                                         ; preds = %for.inc21, %entry
  call void @__dp_loop_entry(i32 114755, i32 0)
  %1 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 114755, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %2 = load i32, i32* %i, align 4, !dbg !327
  %3 = ptrtoint i32* %n.addr to i64
  call void @__dp_read(i32 114755, i64 %3, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0))
  %4 = load i32, i32* %n.addr, align 4, !dbg !329
  %cmp = icmp slt i32 %2, %4, !dbg !330
  br i1 %cmp, label %for.body, label %for.end23, !dbg !331

for.body:                                         ; preds = %for.cond
  %5 = ptrtoint i8** %a.addr to i64
  call void @__dp_read(i32 114756, i64 %5, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0))
  %6 = load i8*, i8** %a.addr, align 8, !dbg !332
  %7 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 114756, i64 %7, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %8 = load i32, i32* %i, align 4, !dbg !334
  %idxprom = sext i32 %8 to i64, !dbg !332
  %arrayidx = getelementptr inbounds i8, i8* %6, i64 %idxprom, !dbg !332
  %9 = ptrtoint i8* %arrayidx to i64
  call void @__dp_read(i32 114756, i64 %9, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0))
  %10 = load i8, i8* %arrayidx, align 1, !dbg !332
  %11 = ptrtoint i8* %p to i64
  call void @__dp_write(i32 114756, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i8 %10, i8* %p, align 1, !dbg !335
  %12 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 114758, i64 %12, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %13 = load i32, i32* %i, align 4, !dbg !336
  %add = add nsw i32 %13, 1, !dbg !338
  %14 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 114758, i64 %14, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 %add, i32* %j, align 4, !dbg !339
  br label %for.cond1, !dbg !340

for.cond1:                                        ; preds = %for.inc, %for.body
  call void @__dp_loop_entry(i32 114758, i32 1)
  %15 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 114758, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %16 = load i32, i32* %j, align 4, !dbg !341
  %17 = ptrtoint i32* %n.addr to i64
  call void @__dp_read(i32 114758, i64 %17, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0))
  %18 = load i32, i32* %n.addr, align 4, !dbg !343
  %cmp2 = icmp slt i32 %16, %18, !dbg !344
  br i1 %cmp2, label %for.body3, label %for.end, !dbg !345

for.body3:                                        ; preds = %for.cond1
  %19 = ptrtoint i8** %a.addr to i64
  call void @__dp_read(i32 114759, i64 %19, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0))
  %20 = load i8*, i8** %a.addr, align 8, !dbg !346
  %21 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 114759, i64 %21, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %22 = load i32, i32* %j, align 4, !dbg !348
  %idxprom4 = sext i32 %22 to i64, !dbg !346
  %arrayidx5 = getelementptr inbounds i8, i8* %20, i64 %idxprom4, !dbg !346
  %23 = ptrtoint i8* %arrayidx5 to i64
  call void @__dp_read(i32 114759, i64 %23, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0))
  %24 = load i8, i8* %arrayidx5, align 1, !dbg !346
  %25 = ptrtoint i8* %q to i64
  call void @__dp_write(i32 114759, i64 %25, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i8 %24, i8* %q, align 1, !dbg !349
  %26 = ptrtoint i8* %q to i64
  call void @__dp_read(i32 114760, i64 %26, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %27 = load i8, i8* %q, align 1, !dbg !350
  %conv = sext i8 %27 to i32, !dbg !350
  %28 = ptrtoint i8* %p to i64
  call void @__dp_read(i32 114760, i64 %28, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %29 = load i8, i8* %p, align 1, !dbg !352
  %conv6 = sext i8 %29 to i32, !dbg !352
  %cmp7 = icmp eq i32 %conv, %conv6, !dbg !353
  br i1 %cmp7, label %if.then, label %lor.lhs.false, !dbg !354

lor.lhs.false:                                    ; preds = %for.body3
  %30 = ptrtoint i8* %q to i64
  call void @__dp_read(i32 114760, i64 %30, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %31 = load i8, i8* %q, align 1, !dbg !355
  %conv9 = sext i8 %31 to i32, !dbg !355
  %32 = ptrtoint i8* %p to i64
  call void @__dp_read(i32 114760, i64 %32, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %33 = load i8, i8* %p, align 1, !dbg !356
  %conv10 = sext i8 %33 to i32, !dbg !356
  %34 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 114760, i64 %34, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %35 = load i32, i32* %j, align 4, !dbg !357
  %36 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 114760, i64 %36, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %37 = load i32, i32* %i, align 4, !dbg !358
  %sub = sub nsw i32 %35, %37, !dbg !359
  %sub11 = sub nsw i32 %conv10, %sub, !dbg !360
  %cmp12 = icmp eq i32 %conv9, %sub11, !dbg !361
  br i1 %cmp12, label %if.then, label %lor.lhs.false14, !dbg !362

lor.lhs.false14:                                  ; preds = %lor.lhs.false
  %38 = ptrtoint i8* %q to i64
  call void @__dp_read(i32 114760, i64 %38, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %39 = load i8, i8* %q, align 1, !dbg !363
  %conv15 = sext i8 %39 to i32, !dbg !363
  %40 = ptrtoint i8* %p to i64
  call void @__dp_read(i32 114760, i64 %40, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %41 = load i8, i8* %p, align 1, !dbg !364
  %conv16 = sext i8 %41 to i32, !dbg !364
  %42 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 114760, i64 %42, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %43 = load i32, i32* %j, align 4, !dbg !365
  %44 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 114760, i64 %44, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %45 = load i32, i32* %i, align 4, !dbg !366
  %sub17 = sub nsw i32 %43, %45, !dbg !367
  %add18 = add nsw i32 %conv16, %sub17, !dbg !368
  %cmp19 = icmp eq i32 %conv15, %add18, !dbg !369
  br i1 %cmp19, label %if.then, label %if.end, !dbg !370

if.then:                                          ; preds = %lor.lhs.false14, %lor.lhs.false, %for.body3
  %46 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 114761, i64 %46, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.8, i32 0, i32 0))
  store i32 0, i32* %retval, align 4, !dbg !371
  br label %return, !dbg !371

if.end:                                           ; preds = %lor.lhs.false14
  br label %for.inc, !dbg !372

for.inc:                                          ; preds = %if.end
  %47 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 114758, i64 %47, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %48 = load i32, i32* %j, align 4, !dbg !373
  %inc = add nsw i32 %48, 1, !dbg !373
  %49 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 114758, i64 %49, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 %inc, i32* %j, align 4, !dbg !373
  br label %for.cond1, !dbg !374, !llvm.loop !375

for.end:                                          ; preds = %for.cond1
  call void @__dp_loop_exit(i32 114763, i32 1)
  br label %for.inc21, !dbg !377

for.inc21:                                        ; preds = %for.end
  %50 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 114755, i64 %50, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %51 = load i32, i32* %i, align 4, !dbg !378
  %inc22 = add nsw i32 %51, 1, !dbg !378
  %52 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 114755, i64 %52, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 %inc22, i32* %i, align 4, !dbg !378
  br label %for.cond, !dbg !379, !llvm.loop !380

for.end23:                                        ; preds = %for.cond
  call void @__dp_loop_exit(i32 114764, i32 0)
  %53 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 114764, i64 %53, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.8, i32 0, i32 0))
  store i32 1, i32* %retval, align 4, !dbg !382
  br label %return, !dbg !382

return:                                           ; preds = %for.end23, %if.then
  %54 = ptrtoint i32* %retval to i64
  call void @__dp_read(i32 114765, i64 %54, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.8, i32 0, i32 0))
  %55 = load i32, i32* %retval, align 4, !dbg !383
  call void @__dp_func_exit(i32 114765, i32 0), !dbg !383
  ret i32 %55, !dbg !383
}

declare void @__dp_func_entry(i32, i32)

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_write(i32, i64, i8*)

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_loop_exit(i32, i32)

declare void @__dp_func_exit(i32, i32)

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @nqueens(i32 %n, i32 %j, i8* %a, i32* %solutions) #0 !dbg !384 {
entry:
  call void @__dp_func_entry(i32 114767, i32 0)
  %n.addr = alloca i32, align 4
  %j.addr = alloca i32, align 4
  %a.addr = alloca i8*, align 8
  %solutions.addr = alloca i32*, align 8
  %i = alloca i32, align 4
  %res = alloca i32, align 4
  store i32 %n, i32* %n.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %n.addr, metadata !388, metadata !DIExpression()), !dbg !389
  store i32 %j, i32* %j.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %j.addr, metadata !390, metadata !DIExpression()), !dbg !391
  store i8* %a, i8** %a.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %a.addr, metadata !392, metadata !DIExpression()), !dbg !393
  store i32* %solutions, i32** %solutions.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %solutions.addr, metadata !394, metadata !DIExpression()), !dbg !395
  call void @llvm.dbg.declare(metadata i32* %i, metadata !396, metadata !DIExpression()), !dbg !397
  call void @llvm.dbg.declare(metadata i32* %res, metadata !398, metadata !DIExpression()), !dbg !399
  %0 = ptrtoint i32* %n.addr to i64
  call void @__dp_read(i32 114771, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0))
  %1 = load i32, i32* %n.addr, align 4, !dbg !400
  %2 = ptrtoint i32* %j.addr to i64
  call void @__dp_read(i32 114771, i64 %2, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.9, i32 0, i32 0))
  %3 = load i32, i32* %j.addr, align 4, !dbg !402
  %cmp = icmp eq i32 %1, %3, !dbg !403
  br i1 %cmp, label %if.then, label %if.end, !dbg !404

if.then:                                          ; preds = %entry
  %4 = ptrtoint i32** %solutions.addr to i64
  call void @__dp_read(i32 114773, i64 %4, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.10, i32 0, i32 0))
  %5 = load i32*, i32** %solutions.addr, align 8, !dbg !405
  %6 = ptrtoint i32* %5 to i64
  call void @__dp_write(i32 114773, i64 %6, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.10, i32 0, i32 0))
  store i32 1, i32* %5, align 4, !dbg !407
  br label %for.end, !dbg !408

if.end:                                           ; preds = %entry
  %7 = ptrtoint i32** %solutions.addr to i64
  call void @__dp_read(i32 114777, i64 %7, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.10, i32 0, i32 0))
  %8 = load i32*, i32** %solutions.addr, align 8, !dbg !409
  %9 = ptrtoint i32* %8 to i64
  call void @__dp_write(i32 114777, i64 %9, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.10, i32 0, i32 0))
  store i32 0, i32* %8, align 4, !dbg !410
  %10 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 114780, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !411
  br label %for.cond, !dbg !413

for.cond:                                         ; preds = %for.inc, %if.end
  call void @__dp_loop_entry(i32 114780, i32 2)
  %11 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 114780, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %12 = load i32, i32* %i, align 4, !dbg !414
  %13 = ptrtoint i32* %n.addr to i64
  call void @__dp_read(i32 114780, i64 %13, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0))
  %14 = load i32, i32* %n.addr, align 4, !dbg !416
  %cmp1 = icmp slt i32 %12, %14, !dbg !417
  br i1 %cmp1, label %for.body, label %for.end, !dbg !418

for.body:                                         ; preds = %for.cond
  %15 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 114781, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %16 = load i32, i32* %i, align 4, !dbg !419
  %conv = trunc i32 %16 to i8, !dbg !421
  %17 = ptrtoint i8** %a.addr to i64
  call void @__dp_read(i32 114781, i64 %17, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0))
  %18 = load i8*, i8** %a.addr, align 8, !dbg !422
  %19 = ptrtoint i32* %j.addr to i64
  call void @__dp_read(i32 114781, i64 %19, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.9, i32 0, i32 0))
  %20 = load i32, i32* %j.addr, align 4, !dbg !423
  %idxprom = sext i32 %20 to i64, !dbg !422
  %arrayidx = getelementptr inbounds i8, i8* %18, i64 %idxprom, !dbg !422
  %21 = ptrtoint i8* %arrayidx to i64
  call void @__dp_write(i32 114781, i64 %21, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0))
  store i8 %conv, i8* %arrayidx, align 1, !dbg !424
  %22 = ptrtoint i32* %j.addr to i64
  call void @__dp_read(i32 114782, i64 %22, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.9, i32 0, i32 0))
  %23 = load i32, i32* %j.addr, align 4, !dbg !425
  %add = add nsw i32 %23, 1, !dbg !427
  %24 = ptrtoint i8** %a.addr to i64
  call void @__dp_read(i32 114782, i64 %24, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0))
  %25 = load i8*, i8** %a.addr, align 8, !dbg !428
  call void @__dp_call(i32 114782), !dbg !429
  %call = call i32 @ok(i32 %add, i8* %25), !dbg !429
  %tobool = icmp ne i32 %call, 0, !dbg !429
  br i1 %tobool, label %if.then2, label %if.end5, !dbg !430

if.then2:                                         ; preds = %for.body
  %26 = ptrtoint i32* %n.addr to i64
  call void @__dp_read(i32 114783, i64 %26, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0))
  %27 = load i32, i32* %n.addr, align 4, !dbg !431
  %28 = ptrtoint i32* %j.addr to i64
  call void @__dp_read(i32 114783, i64 %28, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.9, i32 0, i32 0))
  %29 = load i32, i32* %j.addr, align 4, !dbg !433
  %add3 = add nsw i32 %29, 1, !dbg !434
  %30 = ptrtoint i8** %a.addr to i64
  call void @__dp_read(i32 114783, i64 %30, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0))
  %31 = load i8*, i8** %a.addr, align 8, !dbg !435
  call void @__dp_call(i32 114783), !dbg !436
  call void @nqueens(i32 %27, i32 %add3, i8* %31, i32* %res), !dbg !436
  %32 = ptrtoint i32* %res to i64
  call void @__dp_read(i32 114784, i64 %32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.11, i32 0, i32 0))
  %33 = load i32, i32* %res, align 4, !dbg !437
  %34 = ptrtoint i32** %solutions.addr to i64
  call void @__dp_read(i32 114784, i64 %34, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.10, i32 0, i32 0))
  %35 = load i32*, i32** %solutions.addr, align 8, !dbg !438
  %36 = ptrtoint i32* %35 to i64
  call void @__dp_read(i32 114784, i64 %36, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.10, i32 0, i32 0))
  %37 = load i32, i32* %35, align 4, !dbg !439
  %add4 = add nsw i32 %37, %33, !dbg !439
  %38 = ptrtoint i32* %35 to i64
  call void @__dp_write(i32 114784, i64 %38, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.10, i32 0, i32 0))
  store i32 %add4, i32* %35, align 4, !dbg !439
  br label %if.end5, !dbg !440

if.end5:                                          ; preds = %if.then2, %for.body
  br label %for.inc, !dbg !441

for.inc:                                          ; preds = %if.end5
  %39 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 114780, i64 %39, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %40 = load i32, i32* %i, align 4, !dbg !442
  %inc = add nsw i32 %40, 1, !dbg !442
  %41 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 114780, i64 %41, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !442
  br label %for.cond, !dbg !443, !llvm.loop !444

for.end:                                          ; preds = %for.cond, %if.then
  call void @__dp_loop_exit(i32 114787, i32 2)
  call void @__dp_func_exit(i32 114787, i32 0), !dbg !446
  ret void, !dbg !446
}

declare void @__dp_call(i32)

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @find_queens(i32 %size) #0 !dbg !447 {
entry:
  call void @__dp_func_entry(i32 114789, i32 0)
  %size.addr = alloca i32, align 4
  %a = alloca i8*, align 8
  store i32 %size, i32* %size.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %size.addr, metadata !450, metadata !DIExpression()), !dbg !451
  call void @llvm.dbg.declare(metadata i8** %a, metadata !452, metadata !DIExpression()), !dbg !453
  %0 = ptrtoint i32* @total_count to i64
  call void @__dp_write(i32 114793, i64 %0, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.12, i32 0, i32 0))
  store i32 0, i32* @total_count, align 4, !dbg !454
  %1 = ptrtoint i32* %size.addr to i64
  call void @__dp_read(i32 114794, i64 %1, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.13, i32 0, i32 0))
  %2 = load i32, i32* %size.addr, align 4, !dbg !455
  %conv = sext i32 %2 to i64, !dbg !455
  %mul = mul i64 %conv, 1, !dbg !455
  %3 = alloca i8, i64 %mul, align 16, !dbg !455
  %4 = ptrtoint i8** %a to i64
  call void @__dp_write(i32 114794, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.14, i32 0, i32 0))
  store i8* %3, i8** %a, align 8, !dbg !456
  %5 = ptrtoint i32* @bots_verbose_mode to i64
  call void @__dp_read(i32 114795, i64 %5, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.15, i32 0, i32 0))
  %6 = load i32, i32* @bots_verbose_mode, align 4, !dbg !457
  %cmp = icmp uge i32 %6, 1, !dbg !457
  br i1 %cmp, label %if.then, label %if.end, !dbg !460

if.then:                                          ; preds = %entry
  %7 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 114795, i64 %7, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.16, i32 0, i32 0))
  %8 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !461
  %9 = ptrtoint i32* %size.addr to i64
  call void @__dp_read(i32 114795, i64 %9, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.13, i32 0, i32 0))
  %10 = load i32, i32* %size.addr, align 4, !dbg !461
  call void @__dp_call(i32 114795), !dbg !461
  %call = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %8, i8* getelementptr inbounds ([37 x i8], [37 x i8]* @.str, i32 0, i32 0), i32 %10), !dbg !461
  br label %if.end, !dbg !461

if.end:                                           ; preds = %if.then, %entry
  %11 = ptrtoint i32* %size.addr to i64
  call void @__dp_read(i32 114796, i64 %11, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.13, i32 0, i32 0))
  %12 = load i32, i32* %size.addr, align 4, !dbg !463
  %13 = ptrtoint i8** %a to i64
  call void @__dp_read(i32 114796, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.14, i32 0, i32 0))
  %14 = load i8*, i8** %a, align 8, !dbg !464
  call void @__dp_call(i32 114796), !dbg !465
  call void @nqueens(i32 %12, i32 0, i8* %14, i32* @total_count), !dbg !465
  %15 = ptrtoint i32* @bots_verbose_mode to i64
  call void @__dp_read(i32 114797, i64 %15, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.15, i32 0, i32 0))
  %16 = load i32, i32* @bots_verbose_mode, align 4, !dbg !466
  %cmp2 = icmp uge i32 %16, 1, !dbg !466
  br i1 %cmp2, label %if.then4, label %if.end6, !dbg !469

if.then4:                                         ; preds = %if.end
  %17 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 114797, i64 %17, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.16, i32 0, i32 0))
  %18 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !470
  call void @__dp_call(i32 114797), !dbg !470
  %call5 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %18, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.1, i32 0, i32 0)), !dbg !470
  br label %if.end6, !dbg !470

if.end6:                                          ; preds = %if.then4, %if.end
  call void @__dp_func_exit(i32 114798, i32 0), !dbg !472
  ret void, !dbg !472
}

declare dso_local i32 @fprintf(%struct._IO_FILE*, i8*, ...) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @verify_queens(i32 %size) #0 !dbg !473 {
entry:
  call void @__dp_func_entry(i32 114800, i32 0)
  %retval = alloca i32, align 4
  %size.addr = alloca i32, align 4
  store i32 %size, i32* %size.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %size.addr, metadata !476, metadata !DIExpression()), !dbg !477
  %0 = ptrtoint i32* %size.addr to i64
  call void @__dp_read(i32 114802, i64 %0, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.13, i32 0, i32 0))
  %1 = load i32, i32* %size.addr, align 4, !dbg !478
  %conv = sext i32 %1 to i64, !dbg !478
  %cmp = icmp ugt i64 %conv, 14, !dbg !480
  br i1 %cmp, label %if.then, label %if.end, !dbg !481

if.then:                                          ; preds = %entry
  %2 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 114802, i64 %2, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.8, i32 0, i32 0))
  store i32 0, i32* %retval, align 4, !dbg !482
  br label %return, !dbg !482

if.end:                                           ; preds = %entry
  %3 = ptrtoint i32* @total_count to i64
  call void @__dp_read(i32 114803, i64 %3, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.12, i32 0, i32 0))
  %4 = load i32, i32* @total_count, align 4, !dbg !483
  %5 = ptrtoint i32* %size.addr to i64
  call void @__dp_read(i32 114803, i64 %5, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.13, i32 0, i32 0))
  %6 = load i32, i32* %size.addr, align 4, !dbg !485
  %sub = sub nsw i32 %6, 1, !dbg !486
  %idxprom = sext i32 %sub to i64, !dbg !487
  %arrayidx = getelementptr inbounds [14 x i32], [14 x i32]* @solutions, i64 0, i64 %idxprom, !dbg !487
  %7 = ptrtoint i32* %arrayidx to i64
  call void @__dp_read(i32 114803, i64 %7, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.17, i32 0, i32 0))
  %8 = load i32, i32* %arrayidx, align 4, !dbg !487
  %cmp2 = icmp eq i32 %4, %8, !dbg !488
  br i1 %cmp2, label %if.then4, label %if.end5, !dbg !489

if.then4:                                         ; preds = %if.end
  %9 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 114803, i64 %9, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.8, i32 0, i32 0))
  store i32 1, i32* %retval, align 4, !dbg !490
  br label %return, !dbg !490

if.end5:                                          ; preds = %if.end
  %10 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 114804, i64 %10, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.8, i32 0, i32 0))
  store i32 2, i32* %retval, align 4, !dbg !491
  br label %return, !dbg !491

return:                                           ; preds = %if.end5, %if.then4, %if.then
  %11 = ptrtoint i32* %retval to i64
  call void @__dp_read(i32 114805, i64 %11, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.8, i32 0, i32 0))
  %12 = load i32, i32* %retval, align 4, !dbg !492
  call void @__dp_func_exit(i32 114805, i32 0), !dbg !492
  ret i32 %12, !dbg !492
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_error(i32 %error, i8* %message) #0 !dbg !493 {
entry:
  call void @__dp_func_entry(i32 32803, i32 0)
  %error.addr = alloca i32, align 4
  %message.addr = alloca i8*, align 8
  store i32 %error, i32* %error.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %error.addr, metadata !496, metadata !DIExpression()), !dbg !497
  store i8* %message, i8** %message.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %message.addr, metadata !498, metadata !DIExpression()), !dbg !499
  %0 = ptrtoint i8** %message.addr to i64
  call void @__dp_read(i32 32805, i64 %0, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.48, i32 0, i32 0))
  %1 = load i8*, i8** %message.addr, align 8, !dbg !500
  %cmp = icmp eq i8* %1, null, !dbg !502
  br i1 %cmp, label %if.then, label %if.else, !dbg !503

if.then:                                          ; preds = %entry
  %2 = ptrtoint i32* %error.addr to i64
  call void @__dp_read(i32 32807, i64 %2, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.49, i32 0, i32 0))
  %3 = load i32, i32* %error.addr, align 4, !dbg !504
  switch i32 %3, label %sw.default [
    i32 0, label %sw.bb
    i32 1, label %sw.bb1
    i32 2, label %sw.bb3
  ], !dbg !506

sw.bb:                                            ; preds = %if.then
  %4 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 32810, i64 %4, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.50, i32 0, i32 0))
  %5 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !507
  %6 = ptrtoint i32* %error.addr to i64
  call void @__dp_read(i32 32810, i64 %6, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.49, i32 0, i32 0))
  %7 = load i32, i32* %error.addr, align 4, !dbg !509
  call void @__dp_call(i32 32810), !dbg !510
  %call = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %5, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.18, i32 0, i32 0), i32 %7, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.1.19, i32 0, i32 0)), !dbg !510
  br label %sw.epilog, !dbg !511

sw.bb1:                                           ; preds = %if.then
  %8 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 32813, i64 %8, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.50, i32 0, i32 0))
  %9 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !512
  %10 = ptrtoint i32* %error.addr to i64
  call void @__dp_read(i32 32813, i64 %10, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.49, i32 0, i32 0))
  %11 = load i32, i32* %error.addr, align 4, !dbg !513
  call void @__dp_call(i32 32813), !dbg !514
  %call2 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %9, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.18, i32 0, i32 0), i32 %11, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.2.20, i32 0, i32 0)), !dbg !514
  br label %sw.epilog, !dbg !515

sw.bb3:                                           ; preds = %if.then
  %12 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 32816, i64 %12, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.50, i32 0, i32 0))
  %13 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !516
  %14 = ptrtoint i32* %error.addr to i64
  call void @__dp_read(i32 32816, i64 %14, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.49, i32 0, i32 0))
  %15 = load i32, i32* %error.addr, align 4, !dbg !517
  call void @__dp_call(i32 32816), !dbg !518
  %call4 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %13, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.18, i32 0, i32 0), i32 %15, i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.3.21, i32 0, i32 0)), !dbg !518
  call void @__dp_call(i32 32817), !dbg !519
  call void @bots_print_usage(), !dbg !519
  br label %sw.epilog, !dbg !520

sw.default:                                       ; preds = %if.then
  %16 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 32820, i64 %16, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.50, i32 0, i32 0))
  %17 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !521
  %18 = ptrtoint i32* %error.addr to i64
  call void @__dp_read(i32 32820, i64 %18, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.49, i32 0, i32 0))
  %19 = load i32, i32* %error.addr, align 4, !dbg !522
  call void @__dp_call(i32 32820), !dbg !523
  %call5 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %17, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.18, i32 0, i32 0), i32 %19, i8* getelementptr inbounds ([20 x i8], [20 x i8]* @.str.4.22, i32 0, i32 0)), !dbg !523
  br label %sw.epilog, !dbg !524

sw.epilog:                                        ; preds = %sw.default, %sw.bb3, %sw.bb1, %sw.bb
  br label %if.end, !dbg !525

if.else:                                          ; preds = %entry
  %20 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 32824, i64 %20, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.50, i32 0, i32 0))
  %21 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !526
  %22 = ptrtoint i32* %error.addr to i64
  call void @__dp_read(i32 32824, i64 %22, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.49, i32 0, i32 0))
  %23 = load i32, i32* %error.addr, align 4, !dbg !527
  %24 = ptrtoint i8** %message.addr to i64
  call void @__dp_read(i32 32824, i64 %24, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.48, i32 0, i32 0))
  %25 = load i8*, i8** %message.addr, align 8, !dbg !528
  call void @__dp_call(i32 32824), !dbg !529
  %call6 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %21, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.18, i32 0, i32 0), i32 %23, i8* %25), !dbg !529
  br label %if.end

if.end:                                           ; preds = %if.else, %sw.epilog
  %26 = ptrtoint i32* %error.addr to i64
  call void @__dp_read(i32 32825, i64 %26, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.49, i32 0, i32 0))
  %27 = load i32, i32* %error.addr, align 4, !dbg !530
  %add = add nsw i32 100, %27, !dbg !531
  call void @__dp_finalize(i32 32825), !dbg !532
  call void @exit(i32 %add) #6, !dbg !532
  unreachable, !dbg !532

return:                                           ; No predecessors!
  call void @__dp_func_exit(i32 32826, i32 0), !dbg !533
  ret void, !dbg !533
}

declare void @__dp_finalize(i32)

; Function Attrs: noreturn nounwind
declare dso_local void @exit(i32) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_warning(i32 %warning, i8* %message) #0 !dbg !534 {
entry:
  call void @__dp_func_entry(i32 32829, i32 0)
  %warning.addr = alloca i32, align 4
  %message.addr = alloca i8*, align 8
  store i32 %warning, i32* %warning.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %warning.addr, metadata !535, metadata !DIExpression()), !dbg !536
  store i8* %message, i8** %message.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %message.addr, metadata !537, metadata !DIExpression()), !dbg !538
  %0 = ptrtoint i8** %message.addr to i64
  call void @__dp_read(i32 32831, i64 %0, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.48, i32 0, i32 0))
  %1 = load i8*, i8** %message.addr, align 8, !dbg !539
  %cmp = icmp eq i8* %1, null, !dbg !541
  br i1 %cmp, label %if.then, label %if.else, !dbg !542

if.then:                                          ; preds = %entry
  %2 = ptrtoint i32* %warning.addr to i64
  call void @__dp_read(i32 32833, i64 %2, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.51, i32 0, i32 0))
  %3 = load i32, i32* %warning.addr, align 4, !dbg !543
  switch i32 %3, label %sw.default [
    i32 0, label %sw.bb
  ], !dbg !545

sw.bb:                                            ; preds = %if.then
  %4 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 32836, i64 %4, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.50, i32 0, i32 0))
  %5 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !546
  %6 = ptrtoint i32* %warning.addr to i64
  call void @__dp_read(i32 32836, i64 %6, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.51, i32 0, i32 0))
  %7 = load i32, i32* %warning.addr, align 4, !dbg !548
  call void @__dp_call(i32 32836), !dbg !549
  %call = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %5, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.5.23, i32 0, i32 0), i32 %7, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.6.24, i32 0, i32 0)), !dbg !549
  br label %sw.epilog, !dbg !550

sw.default:                                       ; preds = %if.then
  %8 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 32839, i64 %8, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.50, i32 0, i32 0))
  %9 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !551
  %10 = ptrtoint i32* %warning.addr to i64
  call void @__dp_read(i32 32839, i64 %10, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.51, i32 0, i32 0))
  %11 = load i32, i32* %warning.addr, align 4, !dbg !552
  call void @__dp_call(i32 32839), !dbg !553
  %call1 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %9, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.5.23, i32 0, i32 0), i32 %11, i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.7.25, i32 0, i32 0)), !dbg !553
  br label %sw.epilog, !dbg !554

sw.epilog:                                        ; preds = %sw.default, %sw.bb
  br label %if.end, !dbg !555

if.else:                                          ; preds = %entry
  %12 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 32843, i64 %12, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.50, i32 0, i32 0))
  %13 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !556
  %14 = ptrtoint i32* %warning.addr to i64
  call void @__dp_read(i32 32843, i64 %14, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.51, i32 0, i32 0))
  %15 = load i32, i32* %warning.addr, align 4, !dbg !557
  %16 = ptrtoint i8** %message.addr to i64
  call void @__dp_read(i32 32843, i64 %16, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.48, i32 0, i32 0))
  %17 = load i8*, i8** %message.addr, align 8, !dbg !558
  call void @__dp_call(i32 32843), !dbg !559
  %call2 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %13, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.5.23, i32 0, i32 0), i32 %15, i8* %17), !dbg !559
  br label %if.end

if.end:                                           ; preds = %if.else, %sw.epilog
  call void @__dp_func_exit(i32 32844, i32 0), !dbg !560
  ret void, !dbg !560
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i64 @bots_usecs() #0 !dbg !561 {
entry:
  call void @__dp_func_entry(i32 32848, i32 0)
  %t = alloca %struct.timeval, align 8
  call void @llvm.dbg.declare(metadata %struct.timeval* %t, metadata !565, metadata !DIExpression()), !dbg !574
  call void @__dp_call(i32 32849), !dbg !575
  %call = call i32 @gettimeofday(%struct.timeval* %t, i8* null) #7, !dbg !575
  %tv_sec = getelementptr inbounds %struct.timeval, %struct.timeval* %t, i32 0, i32 0, !dbg !576
  %0 = ptrtoint i64* %tv_sec to i64
  call void @__dp_read(i32 32850, i64 %0, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.52, i32 0, i32 0))
  %1 = load i64, i64* %tv_sec, align 8, !dbg !576
  %mul = mul nsw i64 %1, 1000000, !dbg !577
  %tv_usec = getelementptr inbounds %struct.timeval, %struct.timeval* %t, i32 0, i32 1, !dbg !578
  %2 = ptrtoint i64* %tv_usec to i64
  call void @__dp_read(i32 32850, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.52, i32 0, i32 0))
  %3 = load i64, i64* %tv_usec, align 8, !dbg !578
  %add = add nsw i64 %mul, %3, !dbg !579
  call void @__dp_func_exit(i32 32850, i32 0), !dbg !580
  ret i64 %add, !dbg !580
}

; Function Attrs: nounwind
declare dso_local i32 @gettimeofday(%struct.timeval*, i8*) #4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_get_date(i8* %str) #0 !dbg !581 {
entry:
  call void @__dp_func_entry(i32 32854, i32 0)
  %str.addr = alloca i8*, align 8
  %now = alloca i64, align 8
  store i8* %str, i8** %str.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %str.addr, metadata !584, metadata !DIExpression()), !dbg !585
  call void @llvm.dbg.declare(metadata i64* %now, metadata !586, metadata !DIExpression()), !dbg !589
  call void @__dp_call(i32 32857), !dbg !590
  %call = call i64 @time(i64* %now) #7, !dbg !590
  %0 = ptrtoint i8** %str.addr to i64
  call void @__dp_read(i32 32858, i64 %0, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.53, i32 0, i32 0))
  %1 = load i8*, i8** %str.addr, align 8, !dbg !591
  call void @__dp_call(i32 32858), !dbg !592
  %call1 = call %struct.tm* @gmtime(i64* %now) #7, !dbg !592
  call void @__dp_call(i32 32858), !dbg !593
  %call2 = call i64 @strftime(i8* %1, i64 32, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.8.26, i32 0, i32 0), %struct.tm* %call1) #7, !dbg !593
  call void @__dp_func_exit(i32 32859, i32 0), !dbg !594
  ret void, !dbg !594
}

; Function Attrs: nounwind
declare dso_local i64 @time(i64*) #4

; Function Attrs: nounwind
declare dso_local %struct.tm* @gmtime(i64*) #4

; Function Attrs: nounwind
declare dso_local i64 @strftime(i8*, i64, i8*, %struct.tm*) #4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_get_architecture(i8* %str) #0 !dbg !595 {
entry:
  call void @__dp_func_entry(i32 32861, i32 0)
  %str.addr = alloca i8*, align 8
  %ncpus = alloca i32, align 4
  %architecture = alloca %struct.utsname, align 1
  store i8* %str, i8** %str.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %str.addr, metadata !596, metadata !DIExpression()), !dbg !597
  call void @llvm.dbg.declare(metadata i32* %ncpus, metadata !598, metadata !DIExpression()), !dbg !599
  call void @__dp_call(i32 32863), !dbg !600
  %call = call i64 @sysconf(i32 83) #7, !dbg !600
  %conv = trunc i64 %call to i32, !dbg !600
  %0 = ptrtoint i32* %ncpus to i64
  call void @__dp_write(i32 32863, i64 %0, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.54, i32 0, i32 0))
  store i32 %conv, i32* %ncpus, align 4, !dbg !599
  call void @llvm.dbg.declare(metadata %struct.utsname* %architecture, metadata !601, metadata !DIExpression()), !dbg !614
  call void @__dp_call(i32 32866), !dbg !615
  %call1 = call i32 @uname(%struct.utsname* %architecture) #7, !dbg !615
  %1 = ptrtoint i8** %str.addr to i64
  call void @__dp_read(i32 32867, i64 %1, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.53, i32 0, i32 0))
  %2 = load i8*, i8** %str.addr, align 8, !dbg !616
  %sysname = getelementptr inbounds %struct.utsname, %struct.utsname* %architecture, i32 0, i32 0, !dbg !617
  %arraydecay = getelementptr inbounds [65 x i8], [65 x i8]* %sysname, i32 0, i32 0, !dbg !618
  %machine = getelementptr inbounds %struct.utsname, %struct.utsname* %architecture, i32 0, i32 4, !dbg !619
  %arraydecay2 = getelementptr inbounds [65 x i8], [65 x i8]* %machine, i32 0, i32 0, !dbg !620
  %3 = ptrtoint i32* %ncpus to i64
  call void @__dp_read(i32 32867, i64 %3, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.54, i32 0, i32 0))
  %4 = load i32, i32* %ncpus, align 4, !dbg !621
  call void @__dp_call(i32 32867), !dbg !622
  %call3 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* %2, i64 256, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.9.27, i32 0, i32 0), i8* %arraydecay, i8* %arraydecay2, i32 %4) #7, !dbg !622
  call void @__dp_func_exit(i32 32868, i32 0), !dbg !623
  ret void, !dbg !623
}

; Function Attrs: nounwind
declare dso_local i64 @sysconf(i32) #4

; Function Attrs: nounwind
declare dso_local i32 @uname(%struct.utsname*) #4

; Function Attrs: nounwind
declare dso_local i32 @snprintf(i8*, i64, i8*, ...) #4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_get_load_average(i8* %str) #0 !dbg !624 {
entry:
  call void @__dp_func_entry(i32 32872, i32 0)
  %str.addr = alloca i8*, align 8
  %loadavg = alloca [3 x double], align 16
  store i8* %str, i8** %str.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %str.addr, metadata !625, metadata !DIExpression()), !dbg !626
  call void @llvm.dbg.declare(metadata [3 x double]* %loadavg, metadata !627, metadata !DIExpression()), !dbg !631
  %arraydecay = getelementptr inbounds [3 x double], [3 x double]* %loadavg, i32 0, i32 0, !dbg !632
  call void @__dp_call(i32 32875), !dbg !633
  %call = call i32 @getloadavg(double* %arraydecay, i32 3) #7, !dbg !633
  %0 = ptrtoint i8** %str.addr to i64
  call void @__dp_read(i32 32876, i64 %0, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.53, i32 0, i32 0))
  %1 = load i8*, i8** %str.addr, align 8, !dbg !634
  %arrayidx = getelementptr inbounds [3 x double], [3 x double]* %loadavg, i64 0, i64 0, !dbg !635
  %2 = ptrtoint double* %arrayidx to i64
  call void @__dp_read(i32 32876, i64 %2, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.55, i32 0, i32 0))
  %3 = load double, double* %arrayidx, align 16, !dbg !635
  %arrayidx1 = getelementptr inbounds [3 x double], [3 x double]* %loadavg, i64 0, i64 1, !dbg !636
  %4 = ptrtoint double* %arrayidx1 to i64
  call void @__dp_read(i32 32876, i64 %4, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.55, i32 0, i32 0))
  %5 = load double, double* %arrayidx1, align 8, !dbg !636
  %arrayidx2 = getelementptr inbounds [3 x double], [3 x double]* %loadavg, i64 0, i64 2, !dbg !637
  %6 = ptrtoint double* %arrayidx2 to i64
  call void @__dp_read(i32 32876, i64 %6, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.55, i32 0, i32 0))
  %7 = load double, double* %arrayidx2, align 16, !dbg !637
  call void @__dp_call(i32 32876), !dbg !638
  %call3 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* %1, i64 256, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.10.28, i32 0, i32 0), double %3, double %5, double %7) #7, !dbg !638
  call void @__dp_func_exit(i32 32877, i32 0), !dbg !639
  ret void, !dbg !639
}

; Function Attrs: nounwind
declare dso_local i32 @getloadavg(double*, i32) #4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_print_results() #0 !dbg !640 {
entry:
  call void @__dp_func_entry(i32 32885, i32 0)
  %str_name = alloca [256 x i8], align 16
  %str_parameters = alloca [256 x i8], align 16
  %str_model = alloca [256 x i8], align 16
  %str_resources = alloca [256 x i8], align 16
  %str_result = alloca [15 x i8], align 1
  %str_time_program = alloca [15 x i8], align 1
  %str_time_sequential = alloca [15 x i8], align 1
  %str_speed_up = alloca [15 x i8], align 1
  %str_number_of_tasks = alloca [15 x i8], align 1
  %str_number_of_tasks_per_second = alloca [15 x i8], align 1
  %str_exec_date = alloca [256 x i8], align 16
  %str_exec_message = alloca [256 x i8], align 16
  %str_architecture = alloca [256 x i8], align 16
  %str_load_avg = alloca [256 x i8], align 16
  %str_comp_date = alloca [256 x i8], align 16
  %str_comp_message = alloca [256 x i8], align 16
  %str_cc = alloca [256 x i8], align 16
  %str_cflags = alloca [256 x i8], align 16
  %str_ld = alloca [256 x i8], align 16
  %str_ldflags = alloca [256 x i8], align 16
  %str_cutoff = alloca [256 x i8], align 16
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_name, metadata !643, metadata !DIExpression()), !dbg !644
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_parameters, metadata !645, metadata !DIExpression()), !dbg !646
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_model, metadata !647, metadata !DIExpression()), !dbg !648
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_resources, metadata !649, metadata !DIExpression()), !dbg !650
  call void @llvm.dbg.declare(metadata [15 x i8]* %str_result, metadata !651, metadata !DIExpression()), !dbg !655
  call void @llvm.dbg.declare(metadata [15 x i8]* %str_time_program, metadata !656, metadata !DIExpression()), !dbg !657
  call void @llvm.dbg.declare(metadata [15 x i8]* %str_time_sequential, metadata !658, metadata !DIExpression()), !dbg !659
  call void @llvm.dbg.declare(metadata [15 x i8]* %str_speed_up, metadata !660, metadata !DIExpression()), !dbg !661
  call void @llvm.dbg.declare(metadata [15 x i8]* %str_number_of_tasks, metadata !662, metadata !DIExpression()), !dbg !663
  call void @llvm.dbg.declare(metadata [15 x i8]* %str_number_of_tasks_per_second, metadata !664, metadata !DIExpression()), !dbg !665
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_exec_date, metadata !666, metadata !DIExpression()), !dbg !667
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_exec_message, metadata !668, metadata !DIExpression()), !dbg !669
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_architecture, metadata !670, metadata !DIExpression()), !dbg !671
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_load_avg, metadata !672, metadata !DIExpression()), !dbg !673
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_comp_date, metadata !674, metadata !DIExpression()), !dbg !675
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_comp_message, metadata !676, metadata !DIExpression()), !dbg !677
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_cc, metadata !678, metadata !DIExpression()), !dbg !679
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_cflags, metadata !680, metadata !DIExpression()), !dbg !681
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_ld, metadata !682, metadata !DIExpression()), !dbg !683
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_ldflags, metadata !684, metadata !DIExpression()), !dbg !685
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_cutoff, metadata !686, metadata !DIExpression()), !dbg !687
  %arraydecay = getelementptr inbounds [256 x i8], [256 x i8]* %str_name, i32 0, i32 0, !dbg !688
  call void @__dp_call(i32 32908), !dbg !689
  %call = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11.29, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_name, i32 0, i32 0)) #7, !dbg !689
  %arraydecay1 = getelementptr inbounds [256 x i8], [256 x i8]* %str_parameters, i32 0, i32 0, !dbg !690
  call void @__dp_call(i32 32909), !dbg !691
  %call2 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay1, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11.29, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_parameters, i32 0, i32 0)) #7, !dbg !691
  %arraydecay3 = getelementptr inbounds [256 x i8], [256 x i8]* %str_model, i32 0, i32 0, !dbg !692
  call void @__dp_call(i32 32910), !dbg !693
  %call4 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay3, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11.29, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_model, i32 0, i32 0)) #7, !dbg !693
  %arraydecay5 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cutoff, i32 0, i32 0, !dbg !694
  call void @__dp_call(i32 32911), !dbg !695
  %call6 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay5, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11.29, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_cutoff, i32 0, i32 0)) #7, !dbg !695
  %arraydecay7 = getelementptr inbounds [256 x i8], [256 x i8]* %str_resources, i32 0, i32 0, !dbg !696
  call void @__dp_call(i32 32912), !dbg !697
  %call8 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay7, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11.29, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_resources, i32 0, i32 0)) #7, !dbg !697
  %0 = ptrtoint i32* @bots_result to i64
  call void @__dp_read(i32 32913, i64 %0, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.56, i32 0, i32 0))
  %1 = load i32, i32* @bots_result, align 4, !dbg !698
  switch i32 %1, label %sw.default [
    i32 0, label %sw.bb
    i32 1, label %sw.bb11
    i32 2, label %sw.bb14
    i32 3, label %sw.bb17
  ], !dbg !699

sw.bb:                                            ; preds = %entry
  %arraydecay9 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !700
  call void @__dp_call(i32 32916), !dbg !702
  %call10 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay9, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.12.30, i32 0, i32 0)) #7, !dbg !702
  br label %sw.epilog, !dbg !703

sw.bb11:                                          ; preds = %entry
  %arraydecay12 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !704
  call void @__dp_call(i32 32919), !dbg !705
  %call13 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay12, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.13.31, i32 0, i32 0)) #7, !dbg !705
  br label %sw.epilog, !dbg !706

sw.bb14:                                          ; preds = %entry
  %arraydecay15 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !707
  call void @__dp_call(i32 32922), !dbg !708
  %call16 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay15, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.14.32, i32 0, i32 0)) #7, !dbg !708
  br label %sw.epilog, !dbg !709

sw.bb17:                                          ; preds = %entry
  %arraydecay18 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !710
  call void @__dp_call(i32 32925), !dbg !711
  %call19 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay18, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.15.33, i32 0, i32 0)) #7, !dbg !711
  br label %sw.epilog, !dbg !712

sw.default:                                       ; preds = %entry
  %arraydecay20 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !713
  call void @__dp_call(i32 32928), !dbg !714
  %call21 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay20, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.16.34, i32 0, i32 0)) #7, !dbg !714
  br label %sw.epilog, !dbg !715

sw.epilog:                                        ; preds = %sw.default, %sw.bb17, %sw.bb14, %sw.bb11, %sw.bb
  %arraydecay22 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_program, i32 0, i32 0, !dbg !716
  %2 = ptrtoint double* @bots_time_program to i64
  call void @__dp_read(i32 32931, i64 %2, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.57, i32 0, i32 0))
  %3 = load double, double* @bots_time_program, align 8, !dbg !717
  call void @__dp_call(i32 32931), !dbg !718
  %call23 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay22, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.17.35, i32 0, i32 0), double %3) #7, !dbg !718
  %4 = ptrtoint i32* @bots_sequential_flag to i64
  call void @__dp_read(i32 32932, i64 %4, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.58, i32 0, i32 0))
  %5 = load i32, i32* @bots_sequential_flag, align 4, !dbg !719
  %tobool = icmp ne i32 %5, 0, !dbg !719
  br i1 %tobool, label %if.then, label %if.else, !dbg !721

if.then:                                          ; preds = %sw.epilog
  %arraydecay24 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_sequential, i32 0, i32 0, !dbg !722
  %6 = ptrtoint double* @bots_time_sequential to i64
  call void @__dp_read(i32 32932, i64 %6, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.59, i32 0, i32 0))
  %7 = load double, double* @bots_time_sequential, align 8, !dbg !723
  call void @__dp_call(i32 32932), !dbg !724
  %call25 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay24, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.17.35, i32 0, i32 0), double %7) #7, !dbg !724
  br label %if.end, !dbg !724

if.else:                                          ; preds = %sw.epilog
  %arraydecay26 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_sequential, i32 0, i32 0, !dbg !725
  call void @__dp_call(i32 32933), !dbg !726
  %call27 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay26, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.12.30, i32 0, i32 0)) #7, !dbg !726
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %8 = ptrtoint i32* @bots_sequential_flag to i64
  call void @__dp_read(i32 32934, i64 %8, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.58, i32 0, i32 0))
  %9 = load i32, i32* @bots_sequential_flag, align 4, !dbg !727
  %tobool28 = icmp ne i32 %9, 0, !dbg !727
  br i1 %tobool28, label %if.then29, label %if.else32, !dbg !729

if.then29:                                        ; preds = %if.end
  %arraydecay30 = getelementptr inbounds [15 x i8], [15 x i8]* %str_speed_up, i32 0, i32 0, !dbg !730
  %10 = ptrtoint double* @bots_time_sequential to i64
  call void @__dp_read(i32 32935, i64 %10, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.59, i32 0, i32 0))
  %11 = load double, double* @bots_time_sequential, align 8, !dbg !731
  %12 = ptrtoint double* @bots_time_program to i64
  call void @__dp_read(i32 32935, i64 %12, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.57, i32 0, i32 0))
  %13 = load double, double* @bots_time_program, align 8, !dbg !732
  %div = fdiv double %11, %13, !dbg !733
  call void @__dp_call(i32 32935), !dbg !734
  %call31 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay30, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.18.36, i32 0, i32 0), double %div) #7, !dbg !734
  br label %if.end35, !dbg !734

if.else32:                                        ; preds = %if.end
  %arraydecay33 = getelementptr inbounds [15 x i8], [15 x i8]* %str_speed_up, i32 0, i32 0, !dbg !735
  call void @__dp_call(i32 32936), !dbg !736
  %call34 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay33, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.12.30, i32 0, i32 0)) #7, !dbg !736
  br label %if.end35

if.end35:                                         ; preds = %if.else32, %if.then29
  %arraydecay36 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks, i32 0, i32 0, !dbg !737
  %14 = ptrtoint i64* @bots_number_of_tasks to i64
  call void @__dp_read(i32 32938, i64 %14, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.60, i32 0, i32 0))
  %15 = load i64, i64* @bots_number_of_tasks, align 8, !dbg !738
  %conv = uitofp i64 %15 to float, !dbg !739
  %conv37 = fpext float %conv to double, !dbg !739
  call void @__dp_call(i32 32938), !dbg !740
  %call38 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay36, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.18.36, i32 0, i32 0), double %conv37) #7, !dbg !740
  %arraydecay39 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks_per_second, i32 0, i32 0, !dbg !741
  %16 = ptrtoint i64* @bots_number_of_tasks to i64
  call void @__dp_read(i32 32939, i64 %16, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.60, i32 0, i32 0))
  %17 = load i64, i64* @bots_number_of_tasks, align 8, !dbg !742
  %conv40 = uitofp i64 %17 to float, !dbg !743
  %conv41 = fpext float %conv40 to double, !dbg !743
  %18 = ptrtoint double* @bots_time_program to i64
  call void @__dp_read(i32 32939, i64 %18, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.57, i32 0, i32 0))
  %19 = load double, double* @bots_time_program, align 8, !dbg !744
  %div42 = fdiv double %conv41, %19, !dbg !745
  call void @__dp_call(i32 32939), !dbg !746
  %call43 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay39, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.18.36, i32 0, i32 0), double %div42) #7, !dbg !746
  %arraydecay44 = getelementptr inbounds [256 x i8], [256 x i8]* %str_exec_date, i32 0, i32 0, !dbg !747
  call void @__dp_call(i32 32941), !dbg !748
  %call45 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay44, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11.29, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_exec_date, i32 0, i32 0)) #7, !dbg !748
  %arraydecay46 = getelementptr inbounds [256 x i8], [256 x i8]* %str_exec_message, i32 0, i32 0, !dbg !749
  call void @__dp_call(i32 32942), !dbg !750
  %call47 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay46, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11.29, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_exec_message, i32 0, i32 0)) #7, !dbg !750
  %arraydecay48 = getelementptr inbounds [256 x i8], [256 x i8]* %str_architecture, i32 0, i32 0, !dbg !751
  call void @__dp_call(i32 32943), !dbg !752
  call void @bots_get_architecture(i8* %arraydecay48), !dbg !752
  %arraydecay49 = getelementptr inbounds [256 x i8], [256 x i8]* %str_load_avg, i32 0, i32 0, !dbg !753
  call void @__dp_call(i32 32944), !dbg !754
  call void @bots_get_load_average(i8* %arraydecay49), !dbg !754
  %arraydecay50 = getelementptr inbounds [256 x i8], [256 x i8]* %str_comp_date, i32 0, i32 0, !dbg !755
  call void @__dp_call(i32 32945), !dbg !756
  %call51 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay50, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11.29, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_comp_date, i32 0, i32 0)) #7, !dbg !756
  %arraydecay52 = getelementptr inbounds [256 x i8], [256 x i8]* %str_comp_message, i32 0, i32 0, !dbg !757
  call void @__dp_call(i32 32946), !dbg !758
  %call53 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay52, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11.29, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_comp_message, i32 0, i32 0)) #7, !dbg !758
  %arraydecay54 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cc, i32 0, i32 0, !dbg !759
  call void @__dp_call(i32 32947), !dbg !760
  %call55 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay54, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11.29, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_cc, i32 0, i32 0)) #7, !dbg !760
  %arraydecay56 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cflags, i32 0, i32 0, !dbg !761
  call void @__dp_call(i32 32948), !dbg !762
  %call57 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay56, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11.29, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_cflags, i32 0, i32 0)) #7, !dbg !762
  %arraydecay58 = getelementptr inbounds [256 x i8], [256 x i8]* %str_ld, i32 0, i32 0, !dbg !763
  call void @__dp_call(i32 32949), !dbg !764
  %call59 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay58, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11.29, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_ld, i32 0, i32 0)) #7, !dbg !764
  %arraydecay60 = getelementptr inbounds [256 x i8], [256 x i8]* %str_ldflags, i32 0, i32 0, !dbg !765
  call void @__dp_call(i32 32950), !dbg !766
  %call61 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay60, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11.29, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_ldflags, i32 0, i32 0)) #7, !dbg !766
  %20 = ptrtoint i32* @bots_print_header to i64
  call void @__dp_read(i32 32952, i64 %20, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.61, i32 0, i32 0))
  %21 = load i32, i32* @bots_print_header, align 4, !dbg !767
  %tobool62 = icmp ne i32 %21, 0, !dbg !767
  br i1 %tobool62, label %if.then63, label %if.end73, !dbg !769

if.then63:                                        ; preds = %if.end35
  %22 = ptrtoint i32* @bots_output_format to i64
  call void @__dp_read(i32 32954, i64 %22, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.62, i32 0, i32 0))
  %23 = load i32, i32* @bots_output_format, align 4, !dbg !770
  switch i32 %23, label %sw.default71 [
    i32 0, label %sw.bb64
    i32 1, label %sw.bb65
    i32 2, label %sw.bb66
    i32 3, label %sw.bb68
    i32 4, label %sw.bb69
  ], !dbg !772

sw.bb64:                                          ; preds = %if.then63
  br label %sw.epilog72, !dbg !773

sw.bb65:                                          ; preds = %if.then63
  br label %sw.epilog72, !dbg !775

sw.bb66:                                          ; preds = %if.then63
  %24 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32961, i64 %24, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %25 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !776
  call void @__dp_call(i32 32961), !dbg !777
  %call67 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %25, i8* getelementptr inbounds ([238 x i8], [238 x i8]* @.str.19, i32 0, i32 0)), !dbg !777
  br label %sw.epilog72, !dbg !778

sw.bb68:                                          ; preds = %if.then63
  br label %sw.epilog72, !dbg !779

sw.bb69:                                          ; preds = %if.then63
  %26 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32972, i64 %26, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %27 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !780
  call void @__dp_call(i32 32972), !dbg !781
  %call70 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %27, i8* getelementptr inbounds ([94 x i8], [94 x i8]* @.str.20, i32 0, i32 0)), !dbg !781
  br label %sw.epilog72, !dbg !782

sw.default71:                                     ; preds = %if.then63
  br label %sw.epilog72, !dbg !783

sw.epilog72:                                      ; preds = %sw.default71, %sw.bb69, %sw.bb68, %sw.bb66, %sw.bb65, %sw.bb64
  br label %if.end73, !dbg !784

if.end73:                                         ; preds = %sw.epilog72, %if.end35
  %28 = ptrtoint i32* @bots_output_format to i64
  call void @__dp_read(i32 32983, i64 %28, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.62, i32 0, i32 0))
  %29 = load i32, i32* @bots_output_format, align 4, !dbg !785
  switch i32 %29, label %sw.default203 [
    i32 0, label %sw.bb74
    i32 1, label %sw.bb75
    i32 2, label %sw.bb126
    i32 3, label %sw.bb156
    i32 4, label %sw.bb187
  ], !dbg !786

sw.bb74:                                          ; preds = %if.end73
  br label %sw.epilog204, !dbg !787

sw.bb75:                                          ; preds = %if.end73
  %30 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32988, i64 %30, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %31 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !789
  call void @__dp_call(i32 32988), !dbg !790
  %call76 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %31, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.21, i32 0, i32 0)), !dbg !790
  %32 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32989, i64 %32, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %33 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !791
  %arraydecay77 = getelementptr inbounds [256 x i8], [256 x i8]* %str_name, i32 0, i32 0, !dbg !792
  call void @__dp_call(i32 32989), !dbg !793
  %call78 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %33, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.22, i32 0, i32 0), i8* %arraydecay77), !dbg !793
  %34 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32990, i64 %34, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %35 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !794
  %arraydecay79 = getelementptr inbounds [256 x i8], [256 x i8]* %str_parameters, i32 0, i32 0, !dbg !795
  call void @__dp_call(i32 32990), !dbg !796
  %call80 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %35, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.23, i32 0, i32 0), i8* %arraydecay79), !dbg !796
  %36 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32991, i64 %36, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %37 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !797
  %arraydecay81 = getelementptr inbounds [256 x i8], [256 x i8]* %str_model, i32 0, i32 0, !dbg !798
  call void @__dp_call(i32 32991), !dbg !799
  %call82 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %37, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.24, i32 0, i32 0), i8* %arraydecay81), !dbg !799
  %38 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32992, i64 %38, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %39 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !800
  %arraydecay83 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cutoff, i32 0, i32 0, !dbg !801
  call void @__dp_call(i32 32992), !dbg !802
  %call84 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %39, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.25, i32 0, i32 0), i8* %arraydecay83), !dbg !802
  %40 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32993, i64 %40, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %41 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !803
  %arraydecay85 = getelementptr inbounds [256 x i8], [256 x i8]* %str_resources, i32 0, i32 0, !dbg !804
  call void @__dp_call(i32 32993), !dbg !805
  %call86 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %41, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.26, i32 0, i32 0), i8* %arraydecay85), !dbg !805
  %42 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32994, i64 %42, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %43 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !806
  %arraydecay87 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !807
  call void @__dp_call(i32 32994), !dbg !808
  %call88 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %43, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.27, i32 0, i32 0), i8* %arraydecay87), !dbg !808
  %44 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32996, i64 %44, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %45 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !809
  %arraydecay89 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_program, i32 0, i32 0, !dbg !810
  call void @__dp_call(i32 32996), !dbg !811
  %call90 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %45, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.28, i32 0, i32 0), i8* %arraydecay89), !dbg !811
  %46 = ptrtoint i32* @bots_sequential_flag to i64
  call void @__dp_read(i32 32997, i64 %46, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.58, i32 0, i32 0))
  %47 = load i32, i32* @bots_sequential_flag, align 4, !dbg !812
  %tobool91 = icmp ne i32 %47, 0, !dbg !812
  br i1 %tobool91, label %if.then92, label %if.end97, !dbg !814

if.then92:                                        ; preds = %sw.bb75
  %48 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32998, i64 %48, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %49 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !815
  %arraydecay93 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_sequential, i32 0, i32 0, !dbg !817
  call void @__dp_call(i32 32998), !dbg !818
  %call94 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %49, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.29, i32 0, i32 0), i8* %arraydecay93), !dbg !818
  %50 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32999, i64 %50, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %51 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !819
  %arraydecay95 = getelementptr inbounds [15 x i8], [15 x i8]* %str_speed_up, i32 0, i32 0, !dbg !820
  call void @__dp_call(i32 32999), !dbg !821
  %call96 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %51, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.30, i32 0, i32 0), i8* %arraydecay95), !dbg !821
  br label %if.end97, !dbg !822

if.end97:                                         ; preds = %if.then92, %sw.bb75
  %52 = ptrtoint i64* @bots_number_of_tasks to i64
  call void @__dp_read(i32 33002, i64 %52, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.60, i32 0, i32 0))
  %53 = load i64, i64* @bots_number_of_tasks, align 8, !dbg !823
  %cmp = icmp ugt i64 %53, 0, !dbg !825
  br i1 %cmp, label %if.then99, label %if.end104, !dbg !826

if.then99:                                        ; preds = %if.end97
  %54 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33003, i64 %54, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %55 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !827
  %arraydecay100 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks, i32 0, i32 0, !dbg !829
  call void @__dp_call(i32 33003), !dbg !830
  %call101 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %55, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.31, i32 0, i32 0), i8* %arraydecay100), !dbg !830
  %56 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33004, i64 %56, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %57 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !831
  %arraydecay102 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks_per_second, i32 0, i32 0, !dbg !832
  call void @__dp_call(i32 33004), !dbg !833
  %call103 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %57, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.32, i32 0, i32 0), i8* %arraydecay102), !dbg !833
  br label %if.end104, !dbg !834

if.end104:                                        ; preds = %if.then99, %if.end97
  %58 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33007, i64 %58, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %59 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !835
  %arraydecay105 = getelementptr inbounds [256 x i8], [256 x i8]* %str_exec_date, i32 0, i32 0, !dbg !836
  call void @__dp_call(i32 33007), !dbg !837
  %call106 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %59, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.33, i32 0, i32 0), i8* %arraydecay105), !dbg !837
  %60 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33008, i64 %60, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %61 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !838
  %arraydecay107 = getelementptr inbounds [256 x i8], [256 x i8]* %str_exec_message, i32 0, i32 0, !dbg !839
  call void @__dp_call(i32 33008), !dbg !840
  %call108 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %61, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.34, i32 0, i32 0), i8* %arraydecay107), !dbg !840
  %62 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33010, i64 %62, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %63 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !841
  %arraydecay109 = getelementptr inbounds [256 x i8], [256 x i8]* %str_architecture, i32 0, i32 0, !dbg !842
  call void @__dp_call(i32 33010), !dbg !843
  %call110 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %63, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.35, i32 0, i32 0), i8* %arraydecay109), !dbg !843
  %64 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33011, i64 %64, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %65 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !844
  %arraydecay111 = getelementptr inbounds [256 x i8], [256 x i8]* %str_load_avg, i32 0, i32 0, !dbg !845
  call void @__dp_call(i32 33011), !dbg !846
  %call112 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %65, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.36, i32 0, i32 0), i8* %arraydecay111), !dbg !846
  %66 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33013, i64 %66, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %67 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !847
  %arraydecay113 = getelementptr inbounds [256 x i8], [256 x i8]* %str_comp_date, i32 0, i32 0, !dbg !848
  call void @__dp_call(i32 33013), !dbg !849
  %call114 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %67, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.37, i32 0, i32 0), i8* %arraydecay113), !dbg !849
  %68 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33014, i64 %68, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %69 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !850
  %arraydecay115 = getelementptr inbounds [256 x i8], [256 x i8]* %str_comp_message, i32 0, i32 0, !dbg !851
  call void @__dp_call(i32 33014), !dbg !852
  %call116 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %69, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.38, i32 0, i32 0), i8* %arraydecay115), !dbg !852
  %70 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33016, i64 %70, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %71 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !853
  %arraydecay117 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cc, i32 0, i32 0, !dbg !854
  call void @__dp_call(i32 33016), !dbg !855
  %call118 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %71, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.39, i32 0, i32 0), i8* %arraydecay117), !dbg !855
  %72 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33017, i64 %72, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %73 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !856
  %arraydecay119 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cflags, i32 0, i32 0, !dbg !857
  call void @__dp_call(i32 33017), !dbg !858
  %call120 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %73, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.40, i32 0, i32 0), i8* %arraydecay119), !dbg !858
  %74 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33018, i64 %74, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %75 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !859
  %arraydecay121 = getelementptr inbounds [256 x i8], [256 x i8]* %str_ld, i32 0, i32 0, !dbg !860
  call void @__dp_call(i32 33018), !dbg !861
  %call122 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %75, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.41, i32 0, i32 0), i8* %arraydecay121), !dbg !861
  %76 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33019, i64 %76, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %77 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !862
  %arraydecay123 = getelementptr inbounds [256 x i8], [256 x i8]* %str_ldflags, i32 0, i32 0, !dbg !863
  call void @__dp_call(i32 33019), !dbg !864
  %call124 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %77, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.42, i32 0, i32 0), i8* %arraydecay123), !dbg !864
  %78 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33020, i64 %78, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %79 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !865
  call void @__dp_call(i32 33020), !dbg !866
  %call125 = call i32 @fflush(%struct._IO_FILE* %79), !dbg !866
  br label %sw.epilog204, !dbg !867

sw.bb126:                                         ; preds = %if.end73
  %80 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33023, i64 %80, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %81 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !868
  %arraydecay127 = getelementptr inbounds [256 x i8], [256 x i8]* %str_name, i32 0, i32 0, !dbg !869
  %arraydecay128 = getelementptr inbounds [256 x i8], [256 x i8]* %str_parameters, i32 0, i32 0, !dbg !870
  %arraydecay129 = getelementptr inbounds [256 x i8], [256 x i8]* %str_model, i32 0, i32 0, !dbg !871
  %arraydecay130 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cutoff, i32 0, i32 0, !dbg !872
  %arraydecay131 = getelementptr inbounds [256 x i8], [256 x i8]* %str_resources, i32 0, i32 0, !dbg !873
  %arraydecay132 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !874
  call void @__dp_call(i32 33023), !dbg !875
  %call133 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %81, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.43, i32 0, i32 0), i8* %arraydecay127, i8* %arraydecay128, i8* %arraydecay129, i8* %arraydecay130, i8* %arraydecay131, i8* %arraydecay132), !dbg !875
  %82 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33031, i64 %82, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %83 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !876
  %arraydecay134 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_program, i32 0, i32 0, !dbg !877
  %arraydecay135 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_sequential, i32 0, i32 0, !dbg !878
  %arraydecay136 = getelementptr inbounds [15 x i8], [15 x i8]* %str_speed_up, i32 0, i32 0, !dbg !879
  call void @__dp_call(i32 33031), !dbg !880
  %call137 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %83, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.44, i32 0, i32 0), i8* %arraydecay134, i8* %arraydecay135, i8* %arraydecay136), !dbg !880
  %84 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33036, i64 %84, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %85 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !881
  %arraydecay138 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks, i32 0, i32 0, !dbg !882
  %arraydecay139 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks_per_second, i32 0, i32 0, !dbg !883
  call void @__dp_call(i32 33036), !dbg !884
  %call140 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %85, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.45, i32 0, i32 0), i8* %arraydecay138, i8* %arraydecay139), !dbg !884
  %86 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33040, i64 %86, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %87 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !885
  %arraydecay141 = getelementptr inbounds [256 x i8], [256 x i8]* %str_exec_date, i32 0, i32 0, !dbg !886
  %arraydecay142 = getelementptr inbounds [256 x i8], [256 x i8]* %str_exec_message, i32 0, i32 0, !dbg !887
  call void @__dp_call(i32 33040), !dbg !888
  %call143 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %87, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.45, i32 0, i32 0), i8* %arraydecay141, i8* %arraydecay142), !dbg !888
  %88 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33044, i64 %88, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %89 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !889
  %arraydecay144 = getelementptr inbounds [256 x i8], [256 x i8]* %str_architecture, i32 0, i32 0, !dbg !890
  %arraydecay145 = getelementptr inbounds [256 x i8], [256 x i8]* %str_load_avg, i32 0, i32 0, !dbg !891
  call void @__dp_call(i32 33044), !dbg !892
  %call146 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %89, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.45, i32 0, i32 0), i8* %arraydecay144, i8* %arraydecay145), !dbg !892
  %90 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33048, i64 %90, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %91 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !893
  %arraydecay147 = getelementptr inbounds [256 x i8], [256 x i8]* %str_comp_date, i32 0, i32 0, !dbg !894
  %arraydecay148 = getelementptr inbounds [256 x i8], [256 x i8]* %str_comp_message, i32 0, i32 0, !dbg !895
  call void @__dp_call(i32 33048), !dbg !896
  %call149 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %91, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.45, i32 0, i32 0), i8* %arraydecay147, i8* %arraydecay148), !dbg !896
  %92 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33052, i64 %92, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %93 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !897
  %arraydecay150 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cc, i32 0, i32 0, !dbg !898
  %arraydecay151 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cflags, i32 0, i32 0, !dbg !899
  %arraydecay152 = getelementptr inbounds [256 x i8], [256 x i8]* %str_ld, i32 0, i32 0, !dbg !900
  %arraydecay153 = getelementptr inbounds [256 x i8], [256 x i8]* %str_ldflags, i32 0, i32 0, !dbg !901
  call void @__dp_call(i32 33052), !dbg !902
  %call154 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %93, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.46, i32 0, i32 0), i8* %arraydecay150, i8* %arraydecay151, i8* %arraydecay152, i8* %arraydecay153), !dbg !902
  %94 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33058, i64 %94, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %95 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !903
  call void @__dp_call(i32 33058), !dbg !904
  %call155 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %95, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.21, i32 0, i32 0)), !dbg !904
  br label %sw.epilog204, !dbg !905

sw.bb156:                                         ; preds = %if.end73
  %96 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33061, i64 %96, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %97 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !906
  call void @__dp_call(i32 33061), !dbg !907
  %call157 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %97, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.21, i32 0, i32 0)), !dbg !907
  %98 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33062, i64 %98, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %99 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !908
  %arraydecay158 = getelementptr inbounds [256 x i8], [256 x i8]* %str_name, i32 0, i32 0, !dbg !909
  call void @__dp_call(i32 33062), !dbg !910
  %call159 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %99, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.22, i32 0, i32 0), i8* %arraydecay158), !dbg !910
  %100 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33063, i64 %100, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %101 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !911
  %arraydecay160 = getelementptr inbounds [256 x i8], [256 x i8]* %str_parameters, i32 0, i32 0, !dbg !912
  call void @__dp_call(i32 33063), !dbg !913
  %call161 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %101, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.23, i32 0, i32 0), i8* %arraydecay160), !dbg !913
  %102 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33064, i64 %102, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %103 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !914
  %arraydecay162 = getelementptr inbounds [256 x i8], [256 x i8]* %str_model, i32 0, i32 0, !dbg !915
  call void @__dp_call(i32 33064), !dbg !916
  %call163 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %103, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.24, i32 0, i32 0), i8* %arraydecay162), !dbg !916
  %104 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33065, i64 %104, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %105 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !917
  %arraydecay164 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cutoff, i32 0, i32 0, !dbg !918
  call void @__dp_call(i32 33065), !dbg !919
  %call165 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %105, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.25, i32 0, i32 0), i8* %arraydecay164), !dbg !919
  %106 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33066, i64 %106, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %107 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !920
  %arraydecay166 = getelementptr inbounds [256 x i8], [256 x i8]* %str_resources, i32 0, i32 0, !dbg !921
  call void @__dp_call(i32 33066), !dbg !922
  %call167 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %107, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.26, i32 0, i32 0), i8* %arraydecay166), !dbg !922
  %108 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33067, i64 %108, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %109 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !923
  %arraydecay168 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !924
  call void @__dp_call(i32 33067), !dbg !925
  %call169 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %109, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.27, i32 0, i32 0), i8* %arraydecay168), !dbg !925
  %110 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33069, i64 %110, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %111 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !926
  %arraydecay170 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_program, i32 0, i32 0, !dbg !927
  call void @__dp_call(i32 33069), !dbg !928
  %call171 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %111, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.28, i32 0, i32 0), i8* %arraydecay170), !dbg !928
  %112 = ptrtoint i32* @bots_sequential_flag to i64
  call void @__dp_read(i32 33070, i64 %112, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.58, i32 0, i32 0))
  %113 = load i32, i32* @bots_sequential_flag, align 4, !dbg !929
  %tobool172 = icmp ne i32 %113, 0, !dbg !929
  br i1 %tobool172, label %if.then173, label %if.end178, !dbg !931

if.then173:                                       ; preds = %sw.bb156
  %114 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33071, i64 %114, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %115 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !932
  %arraydecay174 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_sequential, i32 0, i32 0, !dbg !934
  call void @__dp_call(i32 33071), !dbg !935
  %call175 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %115, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.29, i32 0, i32 0), i8* %arraydecay174), !dbg !935
  %116 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33072, i64 %116, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %117 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !936
  %arraydecay176 = getelementptr inbounds [15 x i8], [15 x i8]* %str_speed_up, i32 0, i32 0, !dbg !937
  call void @__dp_call(i32 33072), !dbg !938
  %call177 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %117, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.30, i32 0, i32 0), i8* %arraydecay176), !dbg !938
  br label %if.end178, !dbg !939

if.end178:                                        ; preds = %if.then173, %sw.bb156
  %118 = ptrtoint i64* @bots_number_of_tasks to i64
  call void @__dp_read(i32 33075, i64 %118, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.60, i32 0, i32 0))
  %119 = load i64, i64* @bots_number_of_tasks, align 8, !dbg !940
  %cmp179 = icmp ugt i64 %119, 0, !dbg !942
  br i1 %cmp179, label %if.then181, label %if.end186, !dbg !943

if.then181:                                       ; preds = %if.end178
  %120 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33076, i64 %120, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %121 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !944
  %arraydecay182 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks, i32 0, i32 0, !dbg !946
  call void @__dp_call(i32 33076), !dbg !947
  %call183 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %121, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.31, i32 0, i32 0), i8* %arraydecay182), !dbg !947
  %122 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33077, i64 %122, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %123 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !948
  %arraydecay184 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks_per_second, i32 0, i32 0, !dbg !949
  call void @__dp_call(i32 33077), !dbg !950
  %call185 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %123, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.32, i32 0, i32 0), i8* %arraydecay184), !dbg !950
  br label %if.end186, !dbg !951

if.end186:                                        ; preds = %if.then181, %if.end178
  br label %sw.epilog204, !dbg !952

sw.bb187:                                         ; preds = %if.end73
  %124 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33081, i64 %124, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %125 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !953
  %arraydecay188 = getelementptr inbounds [256 x i8], [256 x i8]* %str_name, i32 0, i32 0, !dbg !954
  %arraydecay189 = getelementptr inbounds [256 x i8], [256 x i8]* %str_parameters, i32 0, i32 0, !dbg !955
  %arraydecay190 = getelementptr inbounds [256 x i8], [256 x i8]* %str_model, i32 0, i32 0, !dbg !956
  %arraydecay191 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cutoff, i32 0, i32 0, !dbg !957
  %arraydecay192 = getelementptr inbounds [256 x i8], [256 x i8]* %str_resources, i32 0, i32 0, !dbg !958
  %arraydecay193 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !959
  call void @__dp_call(i32 33081), !dbg !960
  %call194 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %125, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.43, i32 0, i32 0), i8* %arraydecay188, i8* %arraydecay189, i8* %arraydecay190, i8* %arraydecay191, i8* %arraydecay192, i8* %arraydecay193), !dbg !960
  %126 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33089, i64 %126, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %127 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !961
  %arraydecay195 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_program, i32 0, i32 0, !dbg !962
  %arraydecay196 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_sequential, i32 0, i32 0, !dbg !963
  %arraydecay197 = getelementptr inbounds [15 x i8], [15 x i8]* %str_speed_up, i32 0, i32 0, !dbg !964
  call void @__dp_call(i32 33089), !dbg !965
  %call198 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %127, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.44, i32 0, i32 0), i8* %arraydecay195, i8* %arraydecay196, i8* %arraydecay197), !dbg !965
  %128 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33094, i64 %128, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %129 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !966
  %arraydecay199 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks, i32 0, i32 0, !dbg !967
  %arraydecay200 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks_per_second, i32 0, i32 0, !dbg !968
  call void @__dp_call(i32 33094), !dbg !969
  %call201 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %129, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.45, i32 0, i32 0), i8* %arraydecay199, i8* %arraydecay200), !dbg !969
  %130 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33098, i64 %130, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %131 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !970
  call void @__dp_call(i32 33098), !dbg !971
  %call202 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %131, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.21, i32 0, i32 0)), !dbg !971
  br label %sw.epilog204, !dbg !972

sw.default203:                                    ; preds = %if.end73
  call void @__dp_call(i32 33101), !dbg !973
  call void @bots_error(i32 0, i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.47, i32 0, i32 0)), !dbg !973
  br label %sw.epilog204, !dbg !974

sw.epilog204:                                     ; preds = %sw.default203, %sw.bb187, %if.end186, %sw.bb126, %if.end104, %sw.bb74
  call void @__dp_func_exit(i32 33104, i32 0), !dbg !975
  ret void, !dbg !975
}

; Function Attrs: nounwind
declare dso_local i32 @sprintf(i8*, i8*, ...) #4

declare dso_local i32 @fflush(%struct._IO_FILE*) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_print_usage() #0 !dbg !976 {
entry:
  call void @__dp_func_entry(i32 82133, i32 0), !dbg !977
  %0 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82133, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.81, i32 0, i32 0))
  %1 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !977
  call void @__dp_call(i32 82133), !dbg !978
  %call = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.82, i32 0, i32 0)), !dbg !978
  %2 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82134, i64 %2, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.81, i32 0, i32 0))
  %3 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !979
  call void @__dp_call(i32 82134), !dbg !980
  %call1 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.1.83, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_execname, i32 0, i32 0)), !dbg !980
  %4 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82135, i64 %4, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.81, i32 0, i32 0))
  %5 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !981
  call void @__dp_call(i32 82135), !dbg !982
  %call2 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.82, i32 0, i32 0)), !dbg !982
  %6 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82136, i64 %6, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.81, i32 0, i32 0))
  %7 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !983
  call void @__dp_call(i32 82136), !dbg !984
  %call3 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %7, i8* getelementptr inbounds ([20 x i8], [20 x i8]* @.str.2.84, i32 0, i32 0)), !dbg !984
  %8 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82141, i64 %8, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.81, i32 0, i32 0))
  %9 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !985
  call void @__dp_call(i32 82141), !dbg !986
  %call4 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %9, i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.3.85, i32 0, i32 0)), !dbg !986
  %10 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82165, i64 %10, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.81, i32 0, i32 0))
  %11 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !987
  call void @__dp_call(i32 82165), !dbg !988
  %call5 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.82, i32 0, i32 0)), !dbg !988
  %12 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82166, i64 %12, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.81, i32 0, i32 0))
  %13 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !989
  call void @__dp_call(i32 82166), !dbg !990
  %call6 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %13, i8* getelementptr inbounds ([49 x i8], [49 x i8]* @.str.4.86, i32 0, i32 0)), !dbg !990
  %14 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82167, i64 %14, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.81, i32 0, i32 0))
  %15 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !991
  call void @__dp_call(i32 82167), !dbg !992
  %call7 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %15, i8* getelementptr inbounds ([49 x i8], [49 x i8]* @.str.5.87, i32 0, i32 0)), !dbg !992
  %16 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82168, i64 %16, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.81, i32 0, i32 0))
  %17 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !993
  call void @__dp_call(i32 82168), !dbg !994
  %call8 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %17, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.6.88, i32 0, i32 0)), !dbg !994
  %18 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82169, i64 %18, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.81, i32 0, i32 0))
  %19 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !995
  call void @__dp_call(i32 82169), !dbg !996
  %call9 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %19, i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str.7.89, i32 0, i32 0)), !dbg !996
  %20 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82170, i64 %20, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.81, i32 0, i32 0))
  %21 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !997
  call void @__dp_call(i32 82170), !dbg !998
  %call10 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %21, i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.8.90, i32 0, i32 0)), !dbg !998
  %22 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82171, i64 %22, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.81, i32 0, i32 0))
  %23 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !999
  call void @__dp_call(i32 82171), !dbg !1000
  %call11 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %23, i8* getelementptr inbounds ([54 x i8], [54 x i8]* @.str.9.91, i32 0, i32 0)), !dbg !1000
  %24 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82172, i64 %24, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.81, i32 0, i32 0))
  %25 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1001
  call void @__dp_call(i32 82172), !dbg !1002
  %call12 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %25, i8* getelementptr inbounds ([41 x i8], [41 x i8]* @.str.10.92, i32 0, i32 0)), !dbg !1002
  %26 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82173, i64 %26, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.81, i32 0, i32 0))
  %27 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1003
  call void @__dp_call(i32 82173), !dbg !1004
  %call13 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %27, i8* getelementptr inbounds ([42 x i8], [42 x i8]* @.str.11.93, i32 0, i32 0)), !dbg !1004
  %28 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82174, i64 %28, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.81, i32 0, i32 0))
  %29 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1005
  call void @__dp_call(i32 82174), !dbg !1006
  %call14 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %29, i8* getelementptr inbounds ([41 x i8], [41 x i8]* @.str.12.94, i32 0, i32 0)), !dbg !1006
  %30 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82175, i64 %30, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.81, i32 0, i32 0))
  %31 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1007
  call void @__dp_call(i32 82175), !dbg !1008
  %call15 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %31, i8* getelementptr inbounds ([42 x i8], [42 x i8]* @.str.13.95, i32 0, i32 0)), !dbg !1008
  %32 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82176, i64 %32, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.81, i32 0, i32 0))
  %33 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1009
  call void @__dp_call(i32 82176), !dbg !1010
  %call16 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %33, i8* getelementptr inbounds ([41 x i8], [41 x i8]* @.str.14.96, i32 0, i32 0)), !dbg !1010
  %34 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82177, i64 %34, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.81, i32 0, i32 0))
  %35 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1011
  call void @__dp_call(i32 82177), !dbg !1012
  %call17 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %35, i8* getelementptr inbounds ([70 x i8], [70 x i8]* @.str.15.97, i32 0, i32 0)), !dbg !1012
  %36 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82178, i64 %36, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.81, i32 0, i32 0))
  %37 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1013
  call void @__dp_call(i32 82178), !dbg !1014
  %call18 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %37, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.82, i32 0, i32 0)), !dbg !1014
  %38 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82185, i64 %38, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.81, i32 0, i32 0))
  %39 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1015
  call void @__dp_call(i32 82185), !dbg !1016
  %call19 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %39, i8* getelementptr inbounds ([31 x i8], [31 x i8]* @.str.16.98, i32 0, i32 0)), !dbg !1016
  %40 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82187, i64 %40, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.81, i32 0, i32 0))
  %41 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1017
  call void @__dp_call(i32 82187), !dbg !1018
  %call20 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %41, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.82, i32 0, i32 0)), !dbg !1018
  %42 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82188, i64 %42, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.81, i32 0, i32 0))
  %43 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1019
  call void @__dp_call(i32 82188), !dbg !1020
  %call21 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %43, i8* getelementptr inbounds ([51 x i8], [51 x i8]* @.str.17.99, i32 0, i32 0)), !dbg !1020
  %44 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82189, i64 %44, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.81, i32 0, i32 0))
  %45 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1021
  call void @__dp_call(i32 82189), !dbg !1022
  %call22 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %45, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.82, i32 0, i32 0)), !dbg !1022
  call void @__dp_func_exit(i32 82190, i32 0), !dbg !1023
  ret void, !dbg !1023
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_get_params_common(i32 %argc, i8** %argv) #0 !dbg !1024 {
entry:
  call void @__dp_func_entry(i32 82195, i32 0)
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !1028, metadata !DIExpression()), !dbg !1029
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !1030, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.declare(metadata i32* %i, metadata !1032, metadata !DIExpression()), !dbg !1033
  %0 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82198, i64 %0, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %1 = load i8**, i8*** %argv.addr, align 8, !dbg !1034
  %arrayidx = getelementptr inbounds i8*, i8** %1, i64 0, !dbg !1034
  %2 = ptrtoint i8** %arrayidx to i64
  call void @__dp_read(i32 82198, i64 %2, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %3 = load i8*, i8** %arrayidx, align 8, !dbg !1034
  call void @__dp_call(i32 82198), !dbg !1035
  %call = call i8* @__xpg_basename(i8* %3) #7, !dbg !1035
  call void @__dp_call(i32 82198), !dbg !1036
  %call1 = call i8* @strcpy(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_execname, i32 0, i32 0), i8* %call) #7, !dbg !1036
  call void @__dp_call(i32 82199), !dbg !1037
  call void @bots_get_date(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_exec_date, i32 0, i32 0)), !dbg !1037
  call void @__dp_call(i32 82200), !dbg !1038
  %call2 = call i8* @strcpy(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_exec_message, i32 0, i32 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.18.101, i32 0, i32 0)) #7, !dbg !1038
  %4 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 82201, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  store i32 1, i32* %i, align 4, !dbg !1039
  br label %for.cond, !dbg !1041

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 82201, i32 0)
  %5 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82201, i64 %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  %6 = load i32, i32* %i, align 4, !dbg !1042
  %7 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 82201, i64 %7, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.29.103, i32 0, i32 0))
  %8 = load i32, i32* %argc.addr, align 4, !dbg !1044
  %cmp = icmp slt i32 %6, %8, !dbg !1045
  br i1 %cmp, label %for.body, label %for.end, !dbg !1046

for.body:                                         ; preds = %for.cond
  %9 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82203, i64 %9, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %10 = load i8**, i8*** %argv.addr, align 8, !dbg !1047
  %11 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82203, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  %12 = load i32, i32* %i, align 4, !dbg !1050
  %idxprom = sext i32 %12 to i64, !dbg !1047
  %arrayidx3 = getelementptr inbounds i8*, i8** %10, i64 %idxprom, !dbg !1047
  %13 = ptrtoint i8** %arrayidx3 to i64
  call void @__dp_read(i32 82203, i64 %13, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %14 = load i8*, i8** %arrayidx3, align 8, !dbg !1047
  %arrayidx4 = getelementptr inbounds i8, i8* %14, i64 0, !dbg !1047
  %15 = ptrtoint i8* %arrayidx4 to i64
  call void @__dp_read(i32 82203, i64 %15, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %16 = load i8, i8* %arrayidx4, align 1, !dbg !1047
  %conv = sext i8 %16 to i32, !dbg !1047
  %cmp5 = icmp eq i32 %conv, 45, !dbg !1051
  br i1 %cmp5, label %if.then, label %if.else, !dbg !1052

if.then:                                          ; preds = %for.body
  %17 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82205, i64 %17, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %18 = load i8**, i8*** %argv.addr, align 8, !dbg !1053
  %19 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82205, i64 %19, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  %20 = load i32, i32* %i, align 4, !dbg !1055
  %idxprom7 = sext i32 %20 to i64, !dbg !1053
  %arrayidx8 = getelementptr inbounds i8*, i8** %18, i64 %idxprom7, !dbg !1053
  %21 = ptrtoint i8** %arrayidx8 to i64
  call void @__dp_read(i32 82205, i64 %21, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %22 = load i8*, i8** %arrayidx8, align 8, !dbg !1053
  %arrayidx9 = getelementptr inbounds i8, i8* %22, i64 1, !dbg !1053
  %23 = ptrtoint i8* %arrayidx9 to i64
  call void @__dp_read(i32 82205, i64 %23, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %24 = load i8, i8* %arrayidx9, align 1, !dbg !1053
  %conv10 = sext i8 %24 to i32, !dbg !1053
  switch i32 %conv10, label %sw.default [
    i32 99, label %sw.bb
    i32 101, label %sw.bb14
    i32 104, label %sw.bb24
    i32 110, label %sw.bb28
    i32 111, label %sw.bb40
    i32 118, label %sw.bb52
    i32 122, label %sw.bb69
  ], !dbg !1056

sw.bb:                                            ; preds = %if.then
  %25 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82224, i64 %25, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %26 = load i8**, i8*** %argv.addr, align 8, !dbg !1057
  %27 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82224, i64 %27, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  %28 = load i32, i32* %i, align 4, !dbg !1059
  %idxprom11 = sext i32 %28 to i64, !dbg !1057
  %arrayidx12 = getelementptr inbounds i8*, i8** %26, i64 %idxprom11, !dbg !1057
  %29 = ptrtoint i8** %arrayidx12 to i64
  call void @__dp_read(i32 82224, i64 %29, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %30 = load i8*, i8** %arrayidx12, align 8, !dbg !1057
  %arrayidx13 = getelementptr inbounds i8, i8* %30, i64 1, !dbg !1057
  %31 = ptrtoint i8* %arrayidx13 to i64
  call void @__dp_write(i32 82224, i64 %31, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  store i8 42, i8* %arrayidx13, align 1, !dbg !1060
  %32 = ptrtoint i32* @bots_check_flag to i64
  call void @__dp_write(i32 82228, i64 %32, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.30.104, i32 0, i32 0))
  store i32 1, i32* @bots_check_flag, align 4, !dbg !1061
  br label %sw.epilog, !dbg !1062

sw.bb14:                                          ; preds = %if.then
  %33 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82231, i64 %33, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %34 = load i8**, i8*** %argv.addr, align 8, !dbg !1063
  %35 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82231, i64 %35, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  %36 = load i32, i32* %i, align 4, !dbg !1064
  %idxprom15 = sext i32 %36 to i64, !dbg !1063
  %arrayidx16 = getelementptr inbounds i8*, i8** %34, i64 %idxprom15, !dbg !1063
  %37 = ptrtoint i8** %arrayidx16 to i64
  call void @__dp_read(i32 82231, i64 %37, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %38 = load i8*, i8** %arrayidx16, align 8, !dbg !1063
  %arrayidx17 = getelementptr inbounds i8, i8* %38, i64 1, !dbg !1063
  %39 = ptrtoint i8* %arrayidx17 to i64
  call void @__dp_write(i32 82231, i64 %39, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  store i8 42, i8* %arrayidx17, align 1, !dbg !1065
  %40 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82232, i64 %40, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  %41 = load i32, i32* %i, align 4, !dbg !1066
  %inc = add nsw i32 %41, 1, !dbg !1066
  %42 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 82232, i64 %42, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !1066
  %43 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 82233, i64 %43, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.29.103, i32 0, i32 0))
  %44 = load i32, i32* %argc.addr, align 4, !dbg !1067
  %45 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82233, i64 %45, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  %46 = load i32, i32* %i, align 4, !dbg !1069
  %cmp18 = icmp eq i32 %44, %46, !dbg !1070
  br i1 %cmp18, label %if.then20, label %if.end, !dbg !1071

if.then20:                                        ; preds = %sw.bb14
  call void @__dp_call(i32 82233), !dbg !1072
  call void @bots_print_usage(), !dbg !1072
  call void @__dp_finalize(i32 82233), !dbg !1074
  call void @exit(i32 100) #6, !dbg !1074
  unreachable, !dbg !1074

if.end:                                           ; preds = %sw.bb14
  %47 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82234, i64 %47, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %48 = load i8**, i8*** %argv.addr, align 8, !dbg !1075
  %49 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82234, i64 %49, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  %50 = load i32, i32* %i, align 4, !dbg !1076
  %idxprom21 = sext i32 %50 to i64, !dbg !1075
  %arrayidx22 = getelementptr inbounds i8*, i8** %48, i64 %idxprom21, !dbg !1075
  %51 = ptrtoint i8** %arrayidx22 to i64
  call void @__dp_read(i32 82234, i64 %51, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %52 = load i8*, i8** %arrayidx22, align 8, !dbg !1075
  call void @__dp_call(i32 82234), !dbg !1077
  %call23 = call i8* @strcpy(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_exec_message, i32 0, i32 0), i8* %52) #7, !dbg !1077
  br label %sw.epilog, !dbg !1078

sw.bb24:                                          ; preds = %if.then
  %53 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82245, i64 %53, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %54 = load i8**, i8*** %argv.addr, align 8, !dbg !1079
  %55 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82245, i64 %55, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  %56 = load i32, i32* %i, align 4, !dbg !1080
  %idxprom25 = sext i32 %56 to i64, !dbg !1079
  %arrayidx26 = getelementptr inbounds i8*, i8** %54, i64 %idxprom25, !dbg !1079
  %57 = ptrtoint i8** %arrayidx26 to i64
  call void @__dp_read(i32 82245, i64 %57, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %58 = load i8*, i8** %arrayidx26, align 8, !dbg !1079
  %arrayidx27 = getelementptr inbounds i8, i8* %58, i64 1, !dbg !1079
  %59 = ptrtoint i8* %arrayidx27 to i64
  call void @__dp_write(i32 82245, i64 %59, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  store i8 42, i8* %arrayidx27, align 1, !dbg !1081
  call void @__dp_call(i32 82246), !dbg !1082
  call void @bots_print_usage(), !dbg !1082
  call void @__dp_finalize(i32 82247), !dbg !1083
  call void @exit(i32 100) #6, !dbg !1083
  unreachable, !dbg !1083

sw.bb28:                                          ; preds = %if.then
  %60 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82266, i64 %60, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %61 = load i8**, i8*** %argv.addr, align 8, !dbg !1084
  %62 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82266, i64 %62, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  %63 = load i32, i32* %i, align 4, !dbg !1085
  %idxprom29 = sext i32 %63 to i64, !dbg !1084
  %arrayidx30 = getelementptr inbounds i8*, i8** %61, i64 %idxprom29, !dbg !1084
  %64 = ptrtoint i8** %arrayidx30 to i64
  call void @__dp_read(i32 82266, i64 %64, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %65 = load i8*, i8** %arrayidx30, align 8, !dbg !1084
  %arrayidx31 = getelementptr inbounds i8, i8* %65, i64 1, !dbg !1084
  %66 = ptrtoint i8* %arrayidx31 to i64
  call void @__dp_write(i32 82266, i64 %66, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  store i8 42, i8* %arrayidx31, align 1, !dbg !1086
  %67 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82267, i64 %67, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  %68 = load i32, i32* %i, align 4, !dbg !1087
  %inc32 = add nsw i32 %68, 1, !dbg !1087
  %69 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 82267, i64 %69, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  store i32 %inc32, i32* %i, align 4, !dbg !1087
  %70 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 82268, i64 %70, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.29.103, i32 0, i32 0))
  %71 = load i32, i32* %argc.addr, align 4, !dbg !1088
  %72 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82268, i64 %72, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  %73 = load i32, i32* %i, align 4, !dbg !1090
  %cmp33 = icmp eq i32 %71, %73, !dbg !1091
  br i1 %cmp33, label %if.then35, label %if.end36, !dbg !1092

if.then35:                                        ; preds = %sw.bb28
  call void @__dp_call(i32 82268), !dbg !1093
  call void @bots_print_usage(), !dbg !1093
  call void @__dp_finalize(i32 82268), !dbg !1095
  call void @exit(i32 100) #6, !dbg !1095
  unreachable, !dbg !1095

if.end36:                                         ; preds = %sw.bb28
  %74 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82269, i64 %74, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %75 = load i8**, i8*** %argv.addr, align 8, !dbg !1096
  %76 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82269, i64 %76, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  %77 = load i32, i32* %i, align 4, !dbg !1097
  %idxprom37 = sext i32 %77 to i64, !dbg !1096
  %arrayidx38 = getelementptr inbounds i8*, i8** %75, i64 %idxprom37, !dbg !1096
  %78 = ptrtoint i8** %arrayidx38 to i64
  call void @__dp_read(i32 82269, i64 %78, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %79 = load i8*, i8** %arrayidx38, align 8, !dbg !1096
  call void @__dp_call(i32 82269), !dbg !1098
  %call39 = call i32 @atoi(i8* %79) #8, !dbg !1098
  %80 = ptrtoint i32* @bots_arg_size to i64
  call void @__dp_write(i32 82269, i64 %80, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.31.105, i32 0, i32 0))
  store i32 %call39, i32* @bots_arg_size, align 4, !dbg !1099
  br label %sw.epilog, !dbg !1100

sw.bb40:                                          ; preds = %if.then
  %81 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82276, i64 %81, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %82 = load i8**, i8*** %argv.addr, align 8, !dbg !1101
  %83 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82276, i64 %83, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  %84 = load i32, i32* %i, align 4, !dbg !1102
  %idxprom41 = sext i32 %84 to i64, !dbg !1101
  %arrayidx42 = getelementptr inbounds i8*, i8** %82, i64 %idxprom41, !dbg !1101
  %85 = ptrtoint i8** %arrayidx42 to i64
  call void @__dp_read(i32 82276, i64 %85, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %86 = load i8*, i8** %arrayidx42, align 8, !dbg !1101
  %arrayidx43 = getelementptr inbounds i8, i8* %86, i64 1, !dbg !1101
  %87 = ptrtoint i8* %arrayidx43 to i64
  call void @__dp_write(i32 82276, i64 %87, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  store i8 42, i8* %arrayidx43, align 1, !dbg !1103
  %88 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82277, i64 %88, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  %89 = load i32, i32* %i, align 4, !dbg !1104
  %inc44 = add nsw i32 %89, 1, !dbg !1104
  %90 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 82277, i64 %90, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  store i32 %inc44, i32* %i, align 4, !dbg !1104
  %91 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 82278, i64 %91, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.29.103, i32 0, i32 0))
  %92 = load i32, i32* %argc.addr, align 4, !dbg !1105
  %93 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82278, i64 %93, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  %94 = load i32, i32* %i, align 4, !dbg !1107
  %cmp45 = icmp eq i32 %92, %94, !dbg !1108
  br i1 %cmp45, label %if.then47, label %if.end48, !dbg !1109

if.then47:                                        ; preds = %sw.bb40
  call void @__dp_call(i32 82278), !dbg !1110
  call void @bots_print_usage(), !dbg !1110
  call void @__dp_finalize(i32 82278), !dbg !1112
  call void @exit(i32 100) #6, !dbg !1112
  unreachable, !dbg !1112

if.end48:                                         ; preds = %sw.bb40
  %95 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82279, i64 %95, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %96 = load i8**, i8*** %argv.addr, align 8, !dbg !1113
  %97 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82279, i64 %97, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  %98 = load i32, i32* %i, align 4, !dbg !1114
  %idxprom49 = sext i32 %98 to i64, !dbg !1113
  %arrayidx50 = getelementptr inbounds i8*, i8** %96, i64 %idxprom49, !dbg !1113
  %99 = ptrtoint i8** %arrayidx50 to i64
  call void @__dp_read(i32 82279, i64 %99, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %100 = load i8*, i8** %arrayidx50, align 8, !dbg !1113
  call void @__dp_call(i32 82279), !dbg !1115
  %call51 = call i32 @atoi(i8* %100) #8, !dbg !1115
  %101 = ptrtoint i32* @bots_output_format to i64
  call void @__dp_write(i32 82279, i64 %101, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.32.106, i32 0, i32 0))
  store i32 %call51, i32* @bots_output_format, align 4, !dbg !1116
  br label %sw.epilog, !dbg !1117

sw.bb52:                                          ; preds = %if.then
  %102 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82299, i64 %102, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %103 = load i8**, i8*** %argv.addr, align 8, !dbg !1118
  %104 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82299, i64 %104, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  %105 = load i32, i32* %i, align 4, !dbg !1119
  %idxprom53 = sext i32 %105 to i64, !dbg !1118
  %arrayidx54 = getelementptr inbounds i8*, i8** %103, i64 %idxprom53, !dbg !1118
  %106 = ptrtoint i8** %arrayidx54 to i64
  call void @__dp_read(i32 82299, i64 %106, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %107 = load i8*, i8** %arrayidx54, align 8, !dbg !1118
  %arrayidx55 = getelementptr inbounds i8, i8* %107, i64 1, !dbg !1118
  %108 = ptrtoint i8* %arrayidx55 to i64
  call void @__dp_write(i32 82299, i64 %108, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  store i8 42, i8* %arrayidx55, align 1, !dbg !1120
  %109 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82300, i64 %109, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  %110 = load i32, i32* %i, align 4, !dbg !1121
  %inc56 = add nsw i32 %110, 1, !dbg !1121
  %111 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 82300, i64 %111, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  store i32 %inc56, i32* %i, align 4, !dbg !1121
  %112 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 82301, i64 %112, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.29.103, i32 0, i32 0))
  %113 = load i32, i32* %argc.addr, align 4, !dbg !1122
  %114 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82301, i64 %114, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  %115 = load i32, i32* %i, align 4, !dbg !1124
  %cmp57 = icmp eq i32 %113, %115, !dbg !1125
  br i1 %cmp57, label %if.then59, label %if.end60, !dbg !1126

if.then59:                                        ; preds = %sw.bb52
  call void @__dp_call(i32 82301), !dbg !1127
  call void @bots_print_usage(), !dbg !1127
  call void @__dp_finalize(i32 82301), !dbg !1129
  call void @exit(i32 100) #6, !dbg !1129
  unreachable, !dbg !1129

if.end60:                                         ; preds = %sw.bb52
  %116 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82302, i64 %116, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %117 = load i8**, i8*** %argv.addr, align 8, !dbg !1130
  %118 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82302, i64 %118, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  %119 = load i32, i32* %i, align 4, !dbg !1131
  %idxprom61 = sext i32 %119 to i64, !dbg !1130
  %arrayidx62 = getelementptr inbounds i8*, i8** %117, i64 %idxprom61, !dbg !1130
  %120 = ptrtoint i8** %arrayidx62 to i64
  call void @__dp_read(i32 82302, i64 %120, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %121 = load i8*, i8** %arrayidx62, align 8, !dbg !1130
  call void @__dp_call(i32 82302), !dbg !1132
  %call63 = call i32 @atoi(i8* %121) #8, !dbg !1132
  %122 = ptrtoint i32* @bots_verbose_mode to i64
  call void @__dp_write(i32 82302, i64 %122, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.33.107, i32 0, i32 0))
  store i32 %call63, i32* @bots_verbose_mode, align 4, !dbg !1133
  %123 = ptrtoint i32* @bots_verbose_mode to i64
  call void @__dp_read(i32 82304, i64 %123, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.33.107, i32 0, i32 0))
  %124 = load i32, i32* @bots_verbose_mode, align 4, !dbg !1134
  %cmp64 = icmp ugt i32 %124, 1, !dbg !1136
  br i1 %cmp64, label %if.then66, label %if.end68, !dbg !1137

if.then66:                                        ; preds = %if.end60
  %125 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82305, i64 %125, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.81, i32 0, i32 0))
  %126 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1138
  call void @__dp_call(i32 82305), !dbg !1140
  %call67 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %126, i8* getelementptr inbounds ([100 x i8], [100 x i8]* @.str.19.108, i32 0, i32 0)), !dbg !1140
  call void @__dp_finalize(i32 82306), !dbg !1141
  call void @exit(i32 100) #6, !dbg !1141
  unreachable, !dbg !1141

if.end68:                                         ; preds = %if.end60
  br label %sw.epilog, !dbg !1142

sw.bb69:                                          ; preds = %if.then
  %127 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82327, i64 %127, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %128 = load i8**, i8*** %argv.addr, align 8, !dbg !1143
  %129 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82327, i64 %129, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  %130 = load i32, i32* %i, align 4, !dbg !1144
  %idxprom70 = sext i32 %130 to i64, !dbg !1143
  %arrayidx71 = getelementptr inbounds i8*, i8** %128, i64 %idxprom70, !dbg !1143
  %131 = ptrtoint i8** %arrayidx71 to i64
  call void @__dp_read(i32 82327, i64 %131, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %132 = load i8*, i8** %arrayidx71, align 8, !dbg !1143
  %arrayidx72 = getelementptr inbounds i8, i8* %132, i64 1, !dbg !1143
  %133 = ptrtoint i8* %arrayidx72 to i64
  call void @__dp_write(i32 82327, i64 %133, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  store i8 42, i8* %arrayidx72, align 1, !dbg !1145
  %134 = ptrtoint i32* @bots_print_header to i64
  call void @__dp_write(i32 82328, i64 %134, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.34.109, i32 0, i32 0))
  store i32 1, i32* @bots_print_header, align 4, !dbg !1146
  br label %sw.epilog, !dbg !1147

sw.default:                                       ; preds = %if.then
  %135 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82335, i64 %135, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.81, i32 0, i32 0))
  %136 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1148
  call void @__dp_call(i32 82335), !dbg !1149
  %call73 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %136, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.20.110, i32 0, i32 0)), !dbg !1149
  call void @__dp_call(i32 82336), !dbg !1150
  call void @bots_print_usage(), !dbg !1150
  call void @__dp_finalize(i32 82337), !dbg !1151
  call void @exit(i32 100) #6, !dbg !1151
  unreachable, !dbg !1151

sw.epilog:                                        ; preds = %sw.bb69, %if.end68, %if.end48, %if.end36, %if.end, %sw.bb
  br label %if.end75, !dbg !1152

if.else:                                          ; preds = %for.body
  %137 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82346, i64 %137, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.81, i32 0, i32 0))
  %138 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1153
  call void @__dp_call(i32 82346), !dbg !1155
  %call74 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %138, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.20.110, i32 0, i32 0)), !dbg !1155
  call void @__dp_call(i32 82347), !dbg !1156
  call void @bots_print_usage(), !dbg !1156
  call void @__dp_finalize(i32 82348), !dbg !1157
  call void @exit(i32 100) #6, !dbg !1157
  unreachable, !dbg !1157

if.end75:                                         ; preds = %sw.epilog
  br label %for.inc, !dbg !1158

for.inc:                                          ; preds = %if.end75
  %139 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82201, i64 %139, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  %140 = load i32, i32* %i, align 4, !dbg !1159
  %inc76 = add nsw i32 %140, 1, !dbg !1159
  %141 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 82201, i64 %141, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28.102, i32 0, i32 0))
  store i32 %inc76, i32* %i, align 4, !dbg !1159
  br label %for.cond, !dbg !1160, !llvm.loop !1161

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 82351, i32 0)
  call void @__dp_func_exit(i32 82351, i32 0), !dbg !1163
  ret void, !dbg !1163
}

; Function Attrs: nounwind
declare dso_local i8* @__xpg_basename(i8*) #4

; Function Attrs: nounwind
declare dso_local i8* @strcpy(i8*, i8*) #4

; Function Attrs: nounwind readonly
declare dso_local i32 @atoi(i8*) #5

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_get_params(i32 %argc, i8** %argv) #0 !dbg !1164 {
entry:
  call void @__dp_func_entry(i32 82356, i32 0)
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !1165, metadata !DIExpression()), !dbg !1166
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !1167, metadata !DIExpression()), !dbg !1168
  %0 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 82358, i64 %0, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.29.103, i32 0, i32 0))
  %1 = load i32, i32* %argc.addr, align 4, !dbg !1169
  %2 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82358, i64 %2, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %3 = load i8**, i8*** %argv.addr, align 8, !dbg !1170
  call void @__dp_call(i32 82358), !dbg !1171
  call void @bots_get_params_common(i32 %1, i8** %3), !dbg !1171
  call void @__dp_func_exit(i32 82360, i32 0), !dbg !1172
  ret void, !dbg !1172
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_set_info() #0 !dbg !1173 {
entry:
  call void @__dp_func_entry(i32 82369, i32 0), !dbg !1174
  call void @__dp_call(i32 82369), !dbg !1174
  %call = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_name, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.21.111, i32 0, i32 0)) #7, !dbg !1174
  %0 = ptrtoint i32* @bots_arg_size to i64
  call void @__dp_read(i32 82370, i64 %0, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.31.105, i32 0, i32 0))
  %1 = load i32, i32* @bots_arg_size, align 4, !dbg !1175
  call void @__dp_call(i32 82370), !dbg !1176
  %call1 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_parameters, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.22.112, i32 0, i32 0), i32 %1) #7, !dbg !1176
  call void @__dp_call(i32 82371), !dbg !1177
  %call2 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_model, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.23.113, i32 0, i32 0)) #7, !dbg !1177
  call void @__dp_call(i32 82372), !dbg !1178
  %call3 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_resources, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.24.114, i32 0, i32 0), i32 1) #7, !dbg !1178
  call void @__dp_call(i32 82375), !dbg !1179
  %call4 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_comp_date, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.18.101, i32 0, i32 0)) #7, !dbg !1179
  call void @__dp_call(i32 82376), !dbg !1180
  %call5 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_comp_message, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.18.101, i32 0, i32 0)) #7, !dbg !1180
  call void @__dp_call(i32 82377), !dbg !1181
  %call6 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_cc, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.18.101, i32 0, i32 0)) #7, !dbg !1181
  call void @__dp_call(i32 82378), !dbg !1182
  %call7 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_cflags, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.18.101, i32 0, i32 0)) #7, !dbg !1182
  call void @__dp_call(i32 82379), !dbg !1183
  %call8 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_ld, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.18.101, i32 0, i32 0)) #7, !dbg !1183
  call void @__dp_call(i32 82380), !dbg !1184
  %call9 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_ldflags, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.18.101, i32 0, i32 0)) #7, !dbg !1184
  call void @__dp_call(i32 82389), !dbg !1185
  %call10 = call i8* @strcpy(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_cutoff, i32 0, i32 0), i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.25.115, i32 0, i32 0)) #7, !dbg !1185
  call void @__dp_func_exit(i32 82391, i32 0), !dbg !1186
  ret void, !dbg !1186
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !1187 {
entry:
  call void @__dp_func_entry(i32 82397, i32 1)
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %bots_t_start = alloca i64, align 8
  %bots_t_end = alloca i64, align 8
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !1190, metadata !DIExpression()), !dbg !1191
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !1192, metadata !DIExpression()), !dbg !1193
  call void @llvm.dbg.declare(metadata i64* %bots_t_start, metadata !1194, metadata !DIExpression()), !dbg !1195
  call void @llvm.dbg.declare(metadata i64* %bots_t_end, metadata !1196, metadata !DIExpression()), !dbg !1197
  %0 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 82404, i64 %0, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.29.103, i32 0, i32 0))
  %1 = load i32, i32* %argc.addr, align 4, !dbg !1198
  %2 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82404, i64 %2, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.100, i32 0, i32 0))
  %3 = load i8**, i8*** %argv.addr, align 8, !dbg !1199
  call void @__dp_call(i32 82404), !dbg !1200
  call void @bots_get_params(i32 %1, i8** %3), !dbg !1200
  call void @__dp_call(i32 82406), !dbg !1201
  call void @bots_set_info(), !dbg !1201
  call void @__dp_call(i32 82433), !dbg !1202
  %call = call i64 (...) bitcast (i64 ()* @bots_usecs to i64 (...)*)(), !dbg !1202
  %4 = ptrtoint i64* %bots_t_start to i64
  call void @__dp_write(i32 82433, i64 %4, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.35.116, i32 0, i32 0))
  store i64 %call, i64* %bots_t_start, align 8, !dbg !1203
  %5 = ptrtoint i32* @bots_arg_size to i64
  call void @__dp_read(i32 82434, i64 %5, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.31.105, i32 0, i32 0))
  %6 = load i32, i32* @bots_arg_size, align 4, !dbg !1204
  call void @__dp_call(i32 82434), !dbg !1204
  call void @find_queens(i32 %6), !dbg !1204
  call void @__dp_call(i32 82435), !dbg !1205
  %call1 = call i64 (...) bitcast (i64 ()* @bots_usecs to i64 (...)*)(), !dbg !1205
  %7 = ptrtoint i64* %bots_t_end to i64
  call void @__dp_write(i32 82435, i64 %7, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.36.117, i32 0, i32 0))
  store i64 %call1, i64* %bots_t_end, align 8, !dbg !1206
  %8 = ptrtoint i64* %bots_t_end to i64
  call void @__dp_read(i32 82436, i64 %8, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.36.117, i32 0, i32 0))
  %9 = load i64, i64* %bots_t_end, align 8, !dbg !1207
  %10 = ptrtoint i64* %bots_t_start to i64
  call void @__dp_read(i32 82436, i64 %10, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.35.116, i32 0, i32 0))
  %11 = load i64, i64* %bots_t_start, align 8, !dbg !1208
  %sub = sub nsw i64 %9, %11, !dbg !1209
  %conv = sitofp i64 %sub to double, !dbg !1210
  %div = fdiv double %conv, 1.000000e+06, !dbg !1211
  %12 = ptrtoint double* @bots_time_program to i64
  call void @__dp_write(i32 82436, i64 %12, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.37.118, i32 0, i32 0))
  store double %div, double* @bots_time_program, align 8, !dbg !1212
  %13 = ptrtoint i32* @bots_check_flag to i64
  call void @__dp_read(i32 82441, i64 %13, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.30.104, i32 0, i32 0))
  %14 = load i32, i32* @bots_check_flag, align 4, !dbg !1213
  %tobool = icmp ne i32 %14, 0, !dbg !1213
  br i1 %tobool, label %if.then, label %if.end, !dbg !1215

if.then:                                          ; preds = %entry
  %15 = ptrtoint i32* @bots_arg_size to i64
  call void @__dp_read(i32 82442, i64 %15, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.31.105, i32 0, i32 0))
  %16 = load i32, i32* @bots_arg_size, align 4, !dbg !1216
  call void @__dp_call(i32 82442), !dbg !1216
  %call2 = call i32 @verify_queens(i32 %16), !dbg !1216
  %17 = ptrtoint i32* @bots_result to i64
  call void @__dp_write(i32 82442, i64 %17, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.38.119, i32 0, i32 0))
  store i32 %call2, i32* @bots_result, align 4, !dbg !1218
  br label %if.end, !dbg !1219

if.end:                                           ; preds = %if.then, %entry
  call void @__dp_call(i32 82448), !dbg !1220
  call void @bots_print_results(), !dbg !1220
  call void @__dp_finalize(i32 82449), !dbg !1221
  ret i32 0, !dbg !1221
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { noreturn nounwind }
attributes #7 = { nounwind }
attributes #8 = { nounwind readonly }

!llvm.dbg.cu = !{!2, !80, !24}
!llvm.ident = !{!304, !304, !304}
!llvm.module.flags = !{!305, !306, !307}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "total_count", scope: !2, file: !3, line: 56, type: !19, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 8.0.1-9 (tags/RELEASE_801/final)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !12, globals: !15, nameTableKind: None)
!3 = !DIFile(filename: "nqueens.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/nqueens")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 76, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "./bots.h", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/nqueens")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11}
!9 = !DIEnumerator(name: "BOTS_VERBOSE_NONE", value: 0, isUnsigned: true)
!10 = !DIEnumerator(name: "BOTS_VERBOSE_DEFAULT", value: 1, isUnsigned: true)
!11 = !DIEnumerator(name: "BOTS_VERBOSE_DEBUG", value: 2, isUnsigned: true)
!12 = !{!13, !14}
!13 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!15 = !{!0, !16}
!16 = !DIGlobalVariableExpression(var: !17, expr: !DIExpression())
!17 = distinct !DIGlobalVariable(name: "solutions", scope: !2, file: !3, line: 38, type: !18, isLocal: true, isDefinition: true)
!18 = !DICompositeType(tag: DW_TAG_array_type, baseType: !19, size: 448, elements: !20)
!19 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!20 = !{!21}
!21 = !DISubrange(count: 14)
!22 = !DIGlobalVariableExpression(var: !23, expr: !DIExpression())
!23 = distinct !DIGlobalVariable(name: "bots_sequential_flag", scope: !24, file: !25, line: 41, type: !19, isLocal: false, isDefinition: true)
!24 = distinct !DICompileUnit(language: DW_LANG_C99, file: !25, producer: "clang version 8.0.1-9 (tags/RELEASE_801/final)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !26, globals: !29, nameTableKind: None)
!25 = !DIFile(filename: "bots_main.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/nqueens")
!26 = !{!27, !28}
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "bots_verbose_mode_t", file: !6, line: 78, baseType: !5)
!28 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!29 = !{!22, !30, !32, !34, !36, !38, !40, !42, !44, !47, !49, !54, !56, !58, !60, !62, !64, !66, !68, !70, !72, !74, !76, !78}
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "bots_check_flag", scope: !24, file: !25, line: 42, type: !19, isLocal: false, isDefinition: true)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "bots_verbose_mode", scope: !24, file: !25, line: 43, type: !27, isLocal: false, isDefinition: true)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(name: "bots_result", scope: !24, file: !25, line: 44, type: !19, isLocal: false, isDefinition: true)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(name: "bots_output_format", scope: !24, file: !25, line: 45, type: !19, isLocal: false, isDefinition: true)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(name: "bots_print_header", scope: !24, file: !25, line: 46, type: !19, isLocal: false, isDefinition: true)
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(name: "bots_time_program", scope: !24, file: !25, line: 65, type: !28, isLocal: false, isDefinition: true)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(name: "bots_time_sequential", scope: !24, file: !25, line: 66, type: !28, isLocal: false, isDefinition: true)
!44 = !DIGlobalVariableExpression(var: !45, expr: !DIExpression())
!45 = distinct !DIGlobalVariable(name: "bots_number_of_tasks", scope: !24, file: !25, line: 67, type: !46, isLocal: false, isDefinition: true)
!46 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(name: "bots_arg_size", scope: !24, file: !25, line: 124, type: !19, isLocal: false, isDefinition: true)
!49 = !DIGlobalVariableExpression(var: !50, expr: !DIExpression())
!50 = distinct !DIGlobalVariable(name: "bots_name", scope: !24, file: !25, line: 48, type: !51, isLocal: false, isDefinition: true)
!51 = !DICompositeType(tag: DW_TAG_array_type, baseType: !13, size: 2048, elements: !52)
!52 = !{!53}
!53 = !DISubrange(count: 256)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "bots_execname", scope: !24, file: !25, line: 49, type: !51, isLocal: false, isDefinition: true)
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(name: "bots_parameters", scope: !24, file: !25, line: 50, type: !51, isLocal: false, isDefinition: true)
!58 = !DIGlobalVariableExpression(var: !59, expr: !DIExpression())
!59 = distinct !DIGlobalVariable(name: "bots_model", scope: !24, file: !25, line: 51, type: !51, isLocal: false, isDefinition: true)
!60 = !DIGlobalVariableExpression(var: !61, expr: !DIExpression())
!61 = distinct !DIGlobalVariable(name: "bots_resources", scope: !24, file: !25, line: 52, type: !51, isLocal: false, isDefinition: true)
!62 = !DIGlobalVariableExpression(var: !63, expr: !DIExpression())
!63 = distinct !DIGlobalVariable(name: "bots_exec_date", scope: !24, file: !25, line: 54, type: !51, isLocal: false, isDefinition: true)
!64 = !DIGlobalVariableExpression(var: !65, expr: !DIExpression())
!65 = distinct !DIGlobalVariable(name: "bots_exec_message", scope: !24, file: !25, line: 55, type: !51, isLocal: false, isDefinition: true)
!66 = !DIGlobalVariableExpression(var: !67, expr: !DIExpression())
!67 = distinct !DIGlobalVariable(name: "bots_comp_date", scope: !24, file: !25, line: 56, type: !51, isLocal: false, isDefinition: true)
!68 = !DIGlobalVariableExpression(var: !69, expr: !DIExpression())
!69 = distinct !DIGlobalVariable(name: "bots_comp_message", scope: !24, file: !25, line: 57, type: !51, isLocal: false, isDefinition: true)
!70 = !DIGlobalVariableExpression(var: !71, expr: !DIExpression())
!71 = distinct !DIGlobalVariable(name: "bots_cc", scope: !24, file: !25, line: 58, type: !51, isLocal: false, isDefinition: true)
!72 = !DIGlobalVariableExpression(var: !73, expr: !DIExpression())
!73 = distinct !DIGlobalVariable(name: "bots_cflags", scope: !24, file: !25, line: 59, type: !51, isLocal: false, isDefinition: true)
!74 = !DIGlobalVariableExpression(var: !75, expr: !DIExpression())
!75 = distinct !DIGlobalVariable(name: "bots_ld", scope: !24, file: !25, line: 60, type: !51, isLocal: false, isDefinition: true)
!76 = !DIGlobalVariableExpression(var: !77, expr: !DIExpression())
!77 = distinct !DIGlobalVariable(name: "bots_ldflags", scope: !24, file: !25, line: 61, type: !51, isLocal: false, isDefinition: true)
!78 = !DIGlobalVariableExpression(var: !79, expr: !DIExpression())
!79 = distinct !DIGlobalVariable(name: "bots_cutoff", scope: !24, file: !25, line: 62, type: !51, isLocal: false, isDefinition: true)
!80 = distinct !DICompileUnit(language: DW_LANG_C99, file: !81, producer: "clang version 8.0.1-9 (tags/RELEASE_801/final)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !82, retainedTypes: !301, nameTableKind: None)
!81 = !DIFile(filename: "bots_common.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/nqueens")
!82 = !{!83}
!83 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !84, line: 71, baseType: !7, size: 32, elements: !85)
!84 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/confname.h", directory: "")
!85 = !{!86, !87, !88, !89, !90, !91, !92, !93, !94, !95, !96, !97, !98, !99, !100, !101, !102, !103, !104, !105, !106, !107, !108, !109, !110, !111, !112, !113, !114, !115, !116, !117, !118, !119, !120, !121, !122, !123, !124, !125, !126, !127, !128, !129, !130, !131, !132, !133, !134, !135, !136, !137, !138, !139, !140, !141, !142, !143, !144, !145, !146, !147, !148, !149, !150, !151, !152, !153, !154, !155, !156, !157, !158, !159, !160, !161, !162, !163, !164, !165, !166, !167, !168, !169, !170, !171, !172, !173, !174, !175, !176, !177, !178, !179, !180, !181, !182, !183, !184, !185, !186, !187, !188, !189, !190, !191, !192, !193, !194, !195, !196, !197, !198, !199, !200, !201, !202, !203, !204, !205, !206, !207, !208, !209, !210, !211, !212, !213, !214, !215, !216, !217, !218, !219, !220, !221, !222, !223, !224, !225, !226, !227, !228, !229, !230, !231, !232, !233, !234, !235, !236, !237, !238, !239, !240, !241, !242, !243, !244, !245, !246, !247, !248, !249, !250, !251, !252, !253, !254, !255, !256, !257, !258, !259, !260, !261, !262, !263, !264, !265, !266, !267, !268, !269, !270, !271, !272, !273, !274, !275, !276, !277, !278, !279, !280, !281, !282, !283, !284, !285, !286, !287, !288, !289, !290, !291, !292, !293, !294, !295, !296, !297, !298, !299, !300}
!86 = !DIEnumerator(name: "_SC_ARG_MAX", value: 0, isUnsigned: true)
!87 = !DIEnumerator(name: "_SC_CHILD_MAX", value: 1, isUnsigned: true)
!88 = !DIEnumerator(name: "_SC_CLK_TCK", value: 2, isUnsigned: true)
!89 = !DIEnumerator(name: "_SC_NGROUPS_MAX", value: 3, isUnsigned: true)
!90 = !DIEnumerator(name: "_SC_OPEN_MAX", value: 4, isUnsigned: true)
!91 = !DIEnumerator(name: "_SC_STREAM_MAX", value: 5, isUnsigned: true)
!92 = !DIEnumerator(name: "_SC_TZNAME_MAX", value: 6, isUnsigned: true)
!93 = !DIEnumerator(name: "_SC_JOB_CONTROL", value: 7, isUnsigned: true)
!94 = !DIEnumerator(name: "_SC_SAVED_IDS", value: 8, isUnsigned: true)
!95 = !DIEnumerator(name: "_SC_REALTIME_SIGNALS", value: 9, isUnsigned: true)
!96 = !DIEnumerator(name: "_SC_PRIORITY_SCHEDULING", value: 10, isUnsigned: true)
!97 = !DIEnumerator(name: "_SC_TIMERS", value: 11, isUnsigned: true)
!98 = !DIEnumerator(name: "_SC_ASYNCHRONOUS_IO", value: 12, isUnsigned: true)
!99 = !DIEnumerator(name: "_SC_PRIORITIZED_IO", value: 13, isUnsigned: true)
!100 = !DIEnumerator(name: "_SC_SYNCHRONIZED_IO", value: 14, isUnsigned: true)
!101 = !DIEnumerator(name: "_SC_FSYNC", value: 15, isUnsigned: true)
!102 = !DIEnumerator(name: "_SC_MAPPED_FILES", value: 16, isUnsigned: true)
!103 = !DIEnumerator(name: "_SC_MEMLOCK", value: 17, isUnsigned: true)
!104 = !DIEnumerator(name: "_SC_MEMLOCK_RANGE", value: 18, isUnsigned: true)
!105 = !DIEnumerator(name: "_SC_MEMORY_PROTECTION", value: 19, isUnsigned: true)
!106 = !DIEnumerator(name: "_SC_MESSAGE_PASSING", value: 20, isUnsigned: true)
!107 = !DIEnumerator(name: "_SC_SEMAPHORES", value: 21, isUnsigned: true)
!108 = !DIEnumerator(name: "_SC_SHARED_MEMORY_OBJECTS", value: 22, isUnsigned: true)
!109 = !DIEnumerator(name: "_SC_AIO_LISTIO_MAX", value: 23, isUnsigned: true)
!110 = !DIEnumerator(name: "_SC_AIO_MAX", value: 24, isUnsigned: true)
!111 = !DIEnumerator(name: "_SC_AIO_PRIO_DELTA_MAX", value: 25, isUnsigned: true)
!112 = !DIEnumerator(name: "_SC_DELAYTIMER_MAX", value: 26, isUnsigned: true)
!113 = !DIEnumerator(name: "_SC_MQ_OPEN_MAX", value: 27, isUnsigned: true)
!114 = !DIEnumerator(name: "_SC_MQ_PRIO_MAX", value: 28, isUnsigned: true)
!115 = !DIEnumerator(name: "_SC_VERSION", value: 29, isUnsigned: true)
!116 = !DIEnumerator(name: "_SC_PAGESIZE", value: 30, isUnsigned: true)
!117 = !DIEnumerator(name: "_SC_RTSIG_MAX", value: 31, isUnsigned: true)
!118 = !DIEnumerator(name: "_SC_SEM_NSEMS_MAX", value: 32, isUnsigned: true)
!119 = !DIEnumerator(name: "_SC_SEM_VALUE_MAX", value: 33, isUnsigned: true)
!120 = !DIEnumerator(name: "_SC_SIGQUEUE_MAX", value: 34, isUnsigned: true)
!121 = !DIEnumerator(name: "_SC_TIMER_MAX", value: 35, isUnsigned: true)
!122 = !DIEnumerator(name: "_SC_BC_BASE_MAX", value: 36, isUnsigned: true)
!123 = !DIEnumerator(name: "_SC_BC_DIM_MAX", value: 37, isUnsigned: true)
!124 = !DIEnumerator(name: "_SC_BC_SCALE_MAX", value: 38, isUnsigned: true)
!125 = !DIEnumerator(name: "_SC_BC_STRING_MAX", value: 39, isUnsigned: true)
!126 = !DIEnumerator(name: "_SC_COLL_WEIGHTS_MAX", value: 40, isUnsigned: true)
!127 = !DIEnumerator(name: "_SC_EQUIV_CLASS_MAX", value: 41, isUnsigned: true)
!128 = !DIEnumerator(name: "_SC_EXPR_NEST_MAX", value: 42, isUnsigned: true)
!129 = !DIEnumerator(name: "_SC_LINE_MAX", value: 43, isUnsigned: true)
!130 = !DIEnumerator(name: "_SC_RE_DUP_MAX", value: 44, isUnsigned: true)
!131 = !DIEnumerator(name: "_SC_CHARCLASS_NAME_MAX", value: 45, isUnsigned: true)
!132 = !DIEnumerator(name: "_SC_2_VERSION", value: 46, isUnsigned: true)
!133 = !DIEnumerator(name: "_SC_2_C_BIND", value: 47, isUnsigned: true)
!134 = !DIEnumerator(name: "_SC_2_C_DEV", value: 48, isUnsigned: true)
!135 = !DIEnumerator(name: "_SC_2_FORT_DEV", value: 49, isUnsigned: true)
!136 = !DIEnumerator(name: "_SC_2_FORT_RUN", value: 50, isUnsigned: true)
!137 = !DIEnumerator(name: "_SC_2_SW_DEV", value: 51, isUnsigned: true)
!138 = !DIEnumerator(name: "_SC_2_LOCALEDEF", value: 52, isUnsigned: true)
!139 = !DIEnumerator(name: "_SC_PII", value: 53, isUnsigned: true)
!140 = !DIEnumerator(name: "_SC_PII_XTI", value: 54, isUnsigned: true)
!141 = !DIEnumerator(name: "_SC_PII_SOCKET", value: 55, isUnsigned: true)
!142 = !DIEnumerator(name: "_SC_PII_INTERNET", value: 56, isUnsigned: true)
!143 = !DIEnumerator(name: "_SC_PII_OSI", value: 57, isUnsigned: true)
!144 = !DIEnumerator(name: "_SC_POLL", value: 58, isUnsigned: true)
!145 = !DIEnumerator(name: "_SC_SELECT", value: 59, isUnsigned: true)
!146 = !DIEnumerator(name: "_SC_UIO_MAXIOV", value: 60, isUnsigned: true)
!147 = !DIEnumerator(name: "_SC_IOV_MAX", value: 60, isUnsigned: true)
!148 = !DIEnumerator(name: "_SC_PII_INTERNET_STREAM", value: 61, isUnsigned: true)
!149 = !DIEnumerator(name: "_SC_PII_INTERNET_DGRAM", value: 62, isUnsigned: true)
!150 = !DIEnumerator(name: "_SC_PII_OSI_COTS", value: 63, isUnsigned: true)
!151 = !DIEnumerator(name: "_SC_PII_OSI_CLTS", value: 64, isUnsigned: true)
!152 = !DIEnumerator(name: "_SC_PII_OSI_M", value: 65, isUnsigned: true)
!153 = !DIEnumerator(name: "_SC_T_IOV_MAX", value: 66, isUnsigned: true)
!154 = !DIEnumerator(name: "_SC_THREADS", value: 67, isUnsigned: true)
!155 = !DIEnumerator(name: "_SC_THREAD_SAFE_FUNCTIONS", value: 68, isUnsigned: true)
!156 = !DIEnumerator(name: "_SC_GETGR_R_SIZE_MAX", value: 69, isUnsigned: true)
!157 = !DIEnumerator(name: "_SC_GETPW_R_SIZE_MAX", value: 70, isUnsigned: true)
!158 = !DIEnumerator(name: "_SC_LOGIN_NAME_MAX", value: 71, isUnsigned: true)
!159 = !DIEnumerator(name: "_SC_TTY_NAME_MAX", value: 72, isUnsigned: true)
!160 = !DIEnumerator(name: "_SC_THREAD_DESTRUCTOR_ITERATIONS", value: 73, isUnsigned: true)
!161 = !DIEnumerator(name: "_SC_THREAD_KEYS_MAX", value: 74, isUnsigned: true)
!162 = !DIEnumerator(name: "_SC_THREAD_STACK_MIN", value: 75, isUnsigned: true)
!163 = !DIEnumerator(name: "_SC_THREAD_THREADS_MAX", value: 76, isUnsigned: true)
!164 = !DIEnumerator(name: "_SC_THREAD_ATTR_STACKADDR", value: 77, isUnsigned: true)
!165 = !DIEnumerator(name: "_SC_THREAD_ATTR_STACKSIZE", value: 78, isUnsigned: true)
!166 = !DIEnumerator(name: "_SC_THREAD_PRIORITY_SCHEDULING", value: 79, isUnsigned: true)
!167 = !DIEnumerator(name: "_SC_THREAD_PRIO_INHERIT", value: 80, isUnsigned: true)
!168 = !DIEnumerator(name: "_SC_THREAD_PRIO_PROTECT", value: 81, isUnsigned: true)
!169 = !DIEnumerator(name: "_SC_THREAD_PROCESS_SHARED", value: 82, isUnsigned: true)
!170 = !DIEnumerator(name: "_SC_NPROCESSORS_CONF", value: 83, isUnsigned: true)
!171 = !DIEnumerator(name: "_SC_NPROCESSORS_ONLN", value: 84, isUnsigned: true)
!172 = !DIEnumerator(name: "_SC_PHYS_PAGES", value: 85, isUnsigned: true)
!173 = !DIEnumerator(name: "_SC_AVPHYS_PAGES", value: 86, isUnsigned: true)
!174 = !DIEnumerator(name: "_SC_ATEXIT_MAX", value: 87, isUnsigned: true)
!175 = !DIEnumerator(name: "_SC_PASS_MAX", value: 88, isUnsigned: true)
!176 = !DIEnumerator(name: "_SC_XOPEN_VERSION", value: 89, isUnsigned: true)
!177 = !DIEnumerator(name: "_SC_XOPEN_XCU_VERSION", value: 90, isUnsigned: true)
!178 = !DIEnumerator(name: "_SC_XOPEN_UNIX", value: 91, isUnsigned: true)
!179 = !DIEnumerator(name: "_SC_XOPEN_CRYPT", value: 92, isUnsigned: true)
!180 = !DIEnumerator(name: "_SC_XOPEN_ENH_I18N", value: 93, isUnsigned: true)
!181 = !DIEnumerator(name: "_SC_XOPEN_SHM", value: 94, isUnsigned: true)
!182 = !DIEnumerator(name: "_SC_2_CHAR_TERM", value: 95, isUnsigned: true)
!183 = !DIEnumerator(name: "_SC_2_C_VERSION", value: 96, isUnsigned: true)
!184 = !DIEnumerator(name: "_SC_2_UPE", value: 97, isUnsigned: true)
!185 = !DIEnumerator(name: "_SC_XOPEN_XPG2", value: 98, isUnsigned: true)
!186 = !DIEnumerator(name: "_SC_XOPEN_XPG3", value: 99, isUnsigned: true)
!187 = !DIEnumerator(name: "_SC_XOPEN_XPG4", value: 100, isUnsigned: true)
!188 = !DIEnumerator(name: "_SC_CHAR_BIT", value: 101, isUnsigned: true)
!189 = !DIEnumerator(name: "_SC_CHAR_MAX", value: 102, isUnsigned: true)
!190 = !DIEnumerator(name: "_SC_CHAR_MIN", value: 103, isUnsigned: true)
!191 = !DIEnumerator(name: "_SC_INT_MAX", value: 104, isUnsigned: true)
!192 = !DIEnumerator(name: "_SC_INT_MIN", value: 105, isUnsigned: true)
!193 = !DIEnumerator(name: "_SC_LONG_BIT", value: 106, isUnsigned: true)
!194 = !DIEnumerator(name: "_SC_WORD_BIT", value: 107, isUnsigned: true)
!195 = !DIEnumerator(name: "_SC_MB_LEN_MAX", value: 108, isUnsigned: true)
!196 = !DIEnumerator(name: "_SC_NZERO", value: 109, isUnsigned: true)
!197 = !DIEnumerator(name: "_SC_SSIZE_MAX", value: 110, isUnsigned: true)
!198 = !DIEnumerator(name: "_SC_SCHAR_MAX", value: 111, isUnsigned: true)
!199 = !DIEnumerator(name: "_SC_SCHAR_MIN", value: 112, isUnsigned: true)
!200 = !DIEnumerator(name: "_SC_SHRT_MAX", value: 113, isUnsigned: true)
!201 = !DIEnumerator(name: "_SC_SHRT_MIN", value: 114, isUnsigned: true)
!202 = !DIEnumerator(name: "_SC_UCHAR_MAX", value: 115, isUnsigned: true)
!203 = !DIEnumerator(name: "_SC_UINT_MAX", value: 116, isUnsigned: true)
!204 = !DIEnumerator(name: "_SC_ULONG_MAX", value: 117, isUnsigned: true)
!205 = !DIEnumerator(name: "_SC_USHRT_MAX", value: 118, isUnsigned: true)
!206 = !DIEnumerator(name: "_SC_NL_ARGMAX", value: 119, isUnsigned: true)
!207 = !DIEnumerator(name: "_SC_NL_LANGMAX", value: 120, isUnsigned: true)
!208 = !DIEnumerator(name: "_SC_NL_MSGMAX", value: 121, isUnsigned: true)
!209 = !DIEnumerator(name: "_SC_NL_NMAX", value: 122, isUnsigned: true)
!210 = !DIEnumerator(name: "_SC_NL_SETMAX", value: 123, isUnsigned: true)
!211 = !DIEnumerator(name: "_SC_NL_TEXTMAX", value: 124, isUnsigned: true)
!212 = !DIEnumerator(name: "_SC_XBS5_ILP32_OFF32", value: 125, isUnsigned: true)
!213 = !DIEnumerator(name: "_SC_XBS5_ILP32_OFFBIG", value: 126, isUnsigned: true)
!214 = !DIEnumerator(name: "_SC_XBS5_LP64_OFF64", value: 127, isUnsigned: true)
!215 = !DIEnumerator(name: "_SC_XBS5_LPBIG_OFFBIG", value: 128, isUnsigned: true)
!216 = !DIEnumerator(name: "_SC_XOPEN_LEGACY", value: 129, isUnsigned: true)
!217 = !DIEnumerator(name: "_SC_XOPEN_REALTIME", value: 130, isUnsigned: true)
!218 = !DIEnumerator(name: "_SC_XOPEN_REALTIME_THREADS", value: 131, isUnsigned: true)
!219 = !DIEnumerator(name: "_SC_ADVISORY_INFO", value: 132, isUnsigned: true)
!220 = !DIEnumerator(name: "_SC_BARRIERS", value: 133, isUnsigned: true)
!221 = !DIEnumerator(name: "_SC_BASE", value: 134, isUnsigned: true)
!222 = !DIEnumerator(name: "_SC_C_LANG_SUPPORT", value: 135, isUnsigned: true)
!223 = !DIEnumerator(name: "_SC_C_LANG_SUPPORT_R", value: 136, isUnsigned: true)
!224 = !DIEnumerator(name: "_SC_CLOCK_SELECTION", value: 137, isUnsigned: true)
!225 = !DIEnumerator(name: "_SC_CPUTIME", value: 138, isUnsigned: true)
!226 = !DIEnumerator(name: "_SC_THREAD_CPUTIME", value: 139, isUnsigned: true)
!227 = !DIEnumerator(name: "_SC_DEVICE_IO", value: 140, isUnsigned: true)
!228 = !DIEnumerator(name: "_SC_DEVICE_SPECIFIC", value: 141, isUnsigned: true)
!229 = !DIEnumerator(name: "_SC_DEVICE_SPECIFIC_R", value: 142, isUnsigned: true)
!230 = !DIEnumerator(name: "_SC_FD_MGMT", value: 143, isUnsigned: true)
!231 = !DIEnumerator(name: "_SC_FIFO", value: 144, isUnsigned: true)
!232 = !DIEnumerator(name: "_SC_PIPE", value: 145, isUnsigned: true)
!233 = !DIEnumerator(name: "_SC_FILE_ATTRIBUTES", value: 146, isUnsigned: true)
!234 = !DIEnumerator(name: "_SC_FILE_LOCKING", value: 147, isUnsigned: true)
!235 = !DIEnumerator(name: "_SC_FILE_SYSTEM", value: 148, isUnsigned: true)
!236 = !DIEnumerator(name: "_SC_MONOTONIC_CLOCK", value: 149, isUnsigned: true)
!237 = !DIEnumerator(name: "_SC_MULTI_PROCESS", value: 150, isUnsigned: true)
!238 = !DIEnumerator(name: "_SC_SINGLE_PROCESS", value: 151, isUnsigned: true)
!239 = !DIEnumerator(name: "_SC_NETWORKING", value: 152, isUnsigned: true)
!240 = !DIEnumerator(name: "_SC_READER_WRITER_LOCKS", value: 153, isUnsigned: true)
!241 = !DIEnumerator(name: "_SC_SPIN_LOCKS", value: 154, isUnsigned: true)
!242 = !DIEnumerator(name: "_SC_REGEXP", value: 155, isUnsigned: true)
!243 = !DIEnumerator(name: "_SC_REGEX_VERSION", value: 156, isUnsigned: true)
!244 = !DIEnumerator(name: "_SC_SHELL", value: 157, isUnsigned: true)
!245 = !DIEnumerator(name: "_SC_SIGNALS", value: 158, isUnsigned: true)
!246 = !DIEnumerator(name: "_SC_SPAWN", value: 159, isUnsigned: true)
!247 = !DIEnumerator(name: "_SC_SPORADIC_SERVER", value: 160, isUnsigned: true)
!248 = !DIEnumerator(name: "_SC_THREAD_SPORADIC_SERVER", value: 161, isUnsigned: true)
!249 = !DIEnumerator(name: "_SC_SYSTEM_DATABASE", value: 162, isUnsigned: true)
!250 = !DIEnumerator(name: "_SC_SYSTEM_DATABASE_R", value: 163, isUnsigned: true)
!251 = !DIEnumerator(name: "_SC_TIMEOUTS", value: 164, isUnsigned: true)
!252 = !DIEnumerator(name: "_SC_TYPED_MEMORY_OBJECTS", value: 165, isUnsigned: true)
!253 = !DIEnumerator(name: "_SC_USER_GROUPS", value: 166, isUnsigned: true)
!254 = !DIEnumerator(name: "_SC_USER_GROUPS_R", value: 167, isUnsigned: true)
!255 = !DIEnumerator(name: "_SC_2_PBS", value: 168, isUnsigned: true)
!256 = !DIEnumerator(name: "_SC_2_PBS_ACCOUNTING", value: 169, isUnsigned: true)
!257 = !DIEnumerator(name: "_SC_2_PBS_LOCATE", value: 170, isUnsigned: true)
!258 = !DIEnumerator(name: "_SC_2_PBS_MESSAGE", value: 171, isUnsigned: true)
!259 = !DIEnumerator(name: "_SC_2_PBS_TRACK", value: 172, isUnsigned: true)
!260 = !DIEnumerator(name: "_SC_SYMLOOP_MAX", value: 173, isUnsigned: true)
!261 = !DIEnumerator(name: "_SC_STREAMS", value: 174, isUnsigned: true)
!262 = !DIEnumerator(name: "_SC_2_PBS_CHECKPOINT", value: 175, isUnsigned: true)
!263 = !DIEnumerator(name: "_SC_V6_ILP32_OFF32", value: 176, isUnsigned: true)
!264 = !DIEnumerator(name: "_SC_V6_ILP32_OFFBIG", value: 177, isUnsigned: true)
!265 = !DIEnumerator(name: "_SC_V6_LP64_OFF64", value: 178, isUnsigned: true)
!266 = !DIEnumerator(name: "_SC_V6_LPBIG_OFFBIG", value: 179, isUnsigned: true)
!267 = !DIEnumerator(name: "_SC_HOST_NAME_MAX", value: 180, isUnsigned: true)
!268 = !DIEnumerator(name: "_SC_TRACE", value: 181, isUnsigned: true)
!269 = !DIEnumerator(name: "_SC_TRACE_EVENT_FILTER", value: 182, isUnsigned: true)
!270 = !DIEnumerator(name: "_SC_TRACE_INHERIT", value: 183, isUnsigned: true)
!271 = !DIEnumerator(name: "_SC_TRACE_LOG", value: 184, isUnsigned: true)
!272 = !DIEnumerator(name: "_SC_LEVEL1_ICACHE_SIZE", value: 185, isUnsigned: true)
!273 = !DIEnumerator(name: "_SC_LEVEL1_ICACHE_ASSOC", value: 186, isUnsigned: true)
!274 = !DIEnumerator(name: "_SC_LEVEL1_ICACHE_LINESIZE", value: 187, isUnsigned: true)
!275 = !DIEnumerator(name: "_SC_LEVEL1_DCACHE_SIZE", value: 188, isUnsigned: true)
!276 = !DIEnumerator(name: "_SC_LEVEL1_DCACHE_ASSOC", value: 189, isUnsigned: true)
!277 = !DIEnumerator(name: "_SC_LEVEL1_DCACHE_LINESIZE", value: 190, isUnsigned: true)
!278 = !DIEnumerator(name: "_SC_LEVEL2_CACHE_SIZE", value: 191, isUnsigned: true)
!279 = !DIEnumerator(name: "_SC_LEVEL2_CACHE_ASSOC", value: 192, isUnsigned: true)
!280 = !DIEnumerator(name: "_SC_LEVEL2_CACHE_LINESIZE", value: 193, isUnsigned: true)
!281 = !DIEnumerator(name: "_SC_LEVEL3_CACHE_SIZE", value: 194, isUnsigned: true)
!282 = !DIEnumerator(name: "_SC_LEVEL3_CACHE_ASSOC", value: 195, isUnsigned: true)
!283 = !DIEnumerator(name: "_SC_LEVEL3_CACHE_LINESIZE", value: 196, isUnsigned: true)
!284 = !DIEnumerator(name: "_SC_LEVEL4_CACHE_SIZE", value: 197, isUnsigned: true)
!285 = !DIEnumerator(name: "_SC_LEVEL4_CACHE_ASSOC", value: 198, isUnsigned: true)
!286 = !DIEnumerator(name: "_SC_LEVEL4_CACHE_LINESIZE", value: 199, isUnsigned: true)
!287 = !DIEnumerator(name: "_SC_IPV6", value: 235, isUnsigned: true)
!288 = !DIEnumerator(name: "_SC_RAW_SOCKETS", value: 236, isUnsigned: true)
!289 = !DIEnumerator(name: "_SC_V7_ILP32_OFF32", value: 237, isUnsigned: true)
!290 = !DIEnumerator(name: "_SC_V7_ILP32_OFFBIG", value: 238, isUnsigned: true)
!291 = !DIEnumerator(name: "_SC_V7_LP64_OFF64", value: 239, isUnsigned: true)
!292 = !DIEnumerator(name: "_SC_V7_LPBIG_OFFBIG", value: 240, isUnsigned: true)
!293 = !DIEnumerator(name: "_SC_SS_REPL_MAX", value: 241, isUnsigned: true)
!294 = !DIEnumerator(name: "_SC_TRACE_EVENT_NAME_MAX", value: 242, isUnsigned: true)
!295 = !DIEnumerator(name: "_SC_TRACE_NAME_MAX", value: 243, isUnsigned: true)
!296 = !DIEnumerator(name: "_SC_TRACE_SYS_MAX", value: 244, isUnsigned: true)
!297 = !DIEnumerator(name: "_SC_TRACE_USER_EVENT_MAX", value: 245, isUnsigned: true)
!298 = !DIEnumerator(name: "_SC_XOPEN_STREAMS", value: 246, isUnsigned: true)
!299 = !DIEnumerator(name: "_SC_THREAD_ROBUST_PRIO_INHERIT", value: 247, isUnsigned: true)
!300 = !DIEnumerator(name: "_SC_THREAD_ROBUST_PRIO_PROTECT", value: 248, isUnsigned: true)
!301 = !{!302, !303}
!302 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!303 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!304 = !{!"clang version 8.0.1-9 (tags/RELEASE_801/final)"}
!305 = !{i32 2, !"Dwarf Version", i32 4}
!306 = !{i32 2, !"Debug Info Version", i32 3}
!307 = !{i32 1, !"wchar_size", i32 4}
!308 = distinct !DISubprogram(name: "ok", scope: !3, file: !3, line: 62, type: !309, scopeLine: 63, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !311)
!309 = !DISubroutineType(types: !310)
!310 = !{!19, !19, !14}
!311 = !{}
!312 = !DILocalVariable(name: "n", arg: 1, scope: !308, file: !3, line: 62, type: !19)
!313 = !DILocation(line: 62, column: 12, scope: !308)
!314 = !DILocalVariable(name: "a", arg: 2, scope: !308, file: !3, line: 62, type: !14)
!315 = !DILocation(line: 62, column: 21, scope: !308)
!316 = !DILocalVariable(name: "i", scope: !308, file: !3, line: 64, type: !19)
!317 = !DILocation(line: 64, column: 10, scope: !308)
!318 = !DILocalVariable(name: "j", scope: !308, file: !3, line: 64, type: !19)
!319 = !DILocation(line: 64, column: 13, scope: !308)
!320 = !DILocalVariable(name: "p", scope: !308, file: !3, line: 65, type: !13)
!321 = !DILocation(line: 65, column: 11, scope: !308)
!322 = !DILocalVariable(name: "q", scope: !308, file: !3, line: 65, type: !13)
!323 = !DILocation(line: 65, column: 14, scope: !308)
!324 = !DILocation(line: 67, column: 13, scope: !325)
!325 = distinct !DILexicalBlock(scope: !308, file: !3, line: 67, column: 6)
!326 = !DILocation(line: 67, column: 11, scope: !325)
!327 = !DILocation(line: 67, column: 18, scope: !328)
!328 = distinct !DILexicalBlock(scope: !325, file: !3, line: 67, column: 6)
!329 = !DILocation(line: 67, column: 22, scope: !328)
!330 = !DILocation(line: 67, column: 20, scope: !328)
!331 = !DILocation(line: 67, column: 6, scope: !325)
!332 = !DILocation(line: 68, column: 8, scope: !333)
!333 = distinct !DILexicalBlock(scope: !328, file: !3, line: 67, column: 30)
!334 = !DILocation(line: 68, column: 10, scope: !333)
!335 = !DILocation(line: 68, column: 6, scope: !333)
!336 = !DILocation(line: 70, column: 13, scope: !337)
!337 = distinct !DILexicalBlock(scope: !333, file: !3, line: 70, column: 4)
!338 = !DILocation(line: 70, column: 15, scope: !337)
!339 = !DILocation(line: 70, column: 11, scope: !337)
!340 = !DILocation(line: 70, column: 9, scope: !337)
!341 = !DILocation(line: 70, column: 20, scope: !342)
!342 = distinct !DILexicalBlock(scope: !337, file: !3, line: 70, column: 4)
!343 = !DILocation(line: 70, column: 24, scope: !342)
!344 = !DILocation(line: 70, column: 22, scope: !342)
!345 = !DILocation(line: 70, column: 4, scope: !337)
!346 = !DILocation(line: 71, column: 13, scope: !347)
!347 = distinct !DILexicalBlock(scope: !342, file: !3, line: 70, column: 32)
!348 = !DILocation(line: 71, column: 15, scope: !347)
!349 = !DILocation(line: 71, column: 11, scope: !347)
!350 = !DILocation(line: 72, column: 13, scope: !351)
!351 = distinct !DILexicalBlock(scope: !347, file: !3, line: 72, column: 13)
!352 = !DILocation(line: 72, column: 18, scope: !351)
!353 = !DILocation(line: 72, column: 15, scope: !351)
!354 = !DILocation(line: 72, column: 20, scope: !351)
!355 = !DILocation(line: 72, column: 23, scope: !351)
!356 = !DILocation(line: 72, column: 28, scope: !351)
!357 = !DILocation(line: 72, column: 33, scope: !351)
!358 = !DILocation(line: 72, column: 37, scope: !351)
!359 = !DILocation(line: 72, column: 35, scope: !351)
!360 = !DILocation(line: 72, column: 30, scope: !351)
!361 = !DILocation(line: 72, column: 25, scope: !351)
!362 = !DILocation(line: 72, column: 40, scope: !351)
!363 = !DILocation(line: 72, column: 43, scope: !351)
!364 = !DILocation(line: 72, column: 48, scope: !351)
!365 = !DILocation(line: 72, column: 53, scope: !351)
!366 = !DILocation(line: 72, column: 57, scope: !351)
!367 = !DILocation(line: 72, column: 55, scope: !351)
!368 = !DILocation(line: 72, column: 50, scope: !351)
!369 = !DILocation(line: 72, column: 45, scope: !351)
!370 = !DILocation(line: 72, column: 13, scope: !347)
!371 = !DILocation(line: 73, column: 7, scope: !351)
!372 = !DILocation(line: 74, column: 4, scope: !347)
!373 = !DILocation(line: 70, column: 28, scope: !342)
!374 = !DILocation(line: 70, column: 4, scope: !342)
!375 = distinct !{!375, !345, !376}
!376 = !DILocation(line: 74, column: 4, scope: !337)
!377 = !DILocation(line: 75, column: 6, scope: !333)
!378 = !DILocation(line: 67, column: 26, scope: !328)
!379 = !DILocation(line: 67, column: 6, scope: !328)
!380 = distinct !{!380, !331, !381}
!381 = !DILocation(line: 75, column: 6, scope: !325)
!382 = !DILocation(line: 76, column: 6, scope: !308)
!383 = !DILocation(line: 77, column: 1, scope: !308)
!384 = distinct !DISubprogram(name: "nqueens", scope: !3, file: !3, line: 79, type: !385, scopeLine: 80, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !311)
!385 = !DISubroutineType(types: !386)
!386 = !{null, !19, !19, !14, !387}
!387 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!388 = !DILocalVariable(name: "n", arg: 1, scope: !384, file: !3, line: 79, type: !19)
!389 = !DILocation(line: 79, column: 19, scope: !384)
!390 = !DILocalVariable(name: "j", arg: 2, scope: !384, file: !3, line: 79, type: !19)
!391 = !DILocation(line: 79, column: 26, scope: !384)
!392 = !DILocalVariable(name: "a", arg: 3, scope: !384, file: !3, line: 79, type: !14)
!393 = !DILocation(line: 79, column: 35, scope: !384)
!394 = !DILocalVariable(name: "solutions", arg: 4, scope: !384, file: !3, line: 79, type: !387)
!395 = !DILocation(line: 79, column: 43, scope: !384)
!396 = !DILocalVariable(name: "i", scope: !384, file: !3, line: 81, type: !19)
!397 = !DILocation(line: 81, column: 6, scope: !384)
!398 = !DILocalVariable(name: "res", scope: !384, file: !3, line: 81, type: !19)
!399 = !DILocation(line: 81, column: 8, scope: !384)
!400 = !DILocation(line: 83, column: 6, scope: !401)
!401 = distinct !DILexicalBlock(scope: !384, file: !3, line: 83, column: 6)
!402 = !DILocation(line: 83, column: 11, scope: !401)
!403 = !DILocation(line: 83, column: 8, scope: !401)
!404 = !DILocation(line: 83, column: 6, scope: !384)
!405 = !DILocation(line: 85, column: 4, scope: !406)
!406 = distinct !DILexicalBlock(scope: !401, file: !3, line: 83, column: 14)
!407 = !DILocation(line: 85, column: 14, scope: !406)
!408 = !DILocation(line: 86, column: 3, scope: !406)
!409 = !DILocation(line: 89, column: 3, scope: !384)
!410 = !DILocation(line: 89, column: 13, scope: !384)
!411 = !DILocation(line: 92, column: 9, scope: !412)
!412 = distinct !DILexicalBlock(scope: !384, file: !3, line: 92, column: 2)
!413 = !DILocation(line: 92, column: 7, scope: !412)
!414 = !DILocation(line: 92, column: 14, scope: !415)
!415 = distinct !DILexicalBlock(scope: !412, file: !3, line: 92, column: 2)
!416 = !DILocation(line: 92, column: 18, scope: !415)
!417 = !DILocation(line: 92, column: 16, scope: !415)
!418 = !DILocation(line: 92, column: 2, scope: !412)
!419 = !DILocation(line: 93, column: 17, scope: !420)
!420 = distinct !DILexicalBlock(scope: !415, file: !3, line: 92, column: 26)
!421 = !DILocation(line: 93, column: 10, scope: !420)
!422 = !DILocation(line: 93, column: 3, scope: !420)
!423 = !DILocation(line: 93, column: 5, scope: !420)
!424 = !DILocation(line: 93, column: 8, scope: !420)
!425 = !DILocation(line: 94, column: 10, scope: !426)
!426 = distinct !DILexicalBlock(scope: !420, file: !3, line: 94, column: 7)
!427 = !DILocation(line: 94, column: 12, scope: !426)
!428 = !DILocation(line: 94, column: 17, scope: !426)
!429 = !DILocation(line: 94, column: 7, scope: !426)
!430 = !DILocation(line: 94, column: 7, scope: !420)
!431 = !DILocation(line: 95, column: 19, scope: !432)
!432 = distinct !DILexicalBlock(scope: !426, file: !3, line: 94, column: 21)
!433 = !DILocation(line: 95, column: 22, scope: !432)
!434 = !DILocation(line: 95, column: 24, scope: !432)
!435 = !DILocation(line: 95, column: 29, scope: !432)
!436 = !DILocation(line: 95, column: 11, scope: !432)
!437 = !DILocation(line: 96, column: 18, scope: !432)
!438 = !DILocation(line: 96, column: 5, scope: !432)
!439 = !DILocation(line: 96, column: 15, scope: !432)
!440 = !DILocation(line: 97, column: 3, scope: !432)
!441 = !DILocation(line: 98, column: 2, scope: !420)
!442 = !DILocation(line: 92, column: 22, scope: !415)
!443 = !DILocation(line: 92, column: 2, scope: !415)
!444 = distinct !{!444, !418, !445}
!445 = !DILocation(line: 98, column: 2, scope: !412)
!446 = !DILocation(line: 99, column: 1, scope: !384)
!447 = distinct !DISubprogram(name: "find_queens", scope: !3, file: !3, line: 101, type: !448, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !311)
!448 = !DISubroutineType(types: !449)
!449 = !{null, !19}
!450 = !DILocalVariable(name: "size", arg: 1, scope: !447, file: !3, line: 101, type: !19)
!451 = !DILocation(line: 101, column: 23, scope: !447)
!452 = !DILocalVariable(name: "a", scope: !447, file: !3, line: 103, type: !14)
!453 = !DILocation(line: 103, column: 8, scope: !447)
!454 = !DILocation(line: 105, column: 13, scope: !447)
!455 = !DILocation(line: 106, column: 14, scope: !447)
!456 = !DILocation(line: 106, column: 4, scope: !447)
!457 = !DILocation(line: 107, column: 2, scope: !458)
!458 = distinct !DILexicalBlock(scope: !459, file: !3, line: 107, column: 2)
!459 = distinct !DILexicalBlock(scope: !447, file: !3, line: 107, column: 2)
!460 = !DILocation(line: 107, column: 2, scope: !459)
!461 = !DILocation(line: 107, column: 2, scope: !462)
!462 = distinct !DILexicalBlock(scope: !458, file: !3, line: 107, column: 2)
!463 = !DILocation(line: 108, column: 10, scope: !447)
!464 = !DILocation(line: 108, column: 19, scope: !447)
!465 = !DILocation(line: 108, column: 2, scope: !447)
!466 = !DILocation(line: 109, column: 9, scope: !467)
!467 = distinct !DILexicalBlock(scope: !468, file: !3, line: 109, column: 9)
!468 = distinct !DILexicalBlock(scope: !447, file: !3, line: 109, column: 9)
!469 = !DILocation(line: 109, column: 9, scope: !468)
!470 = !DILocation(line: 109, column: 9, scope: !471)
!471 = distinct !DILexicalBlock(scope: !467, file: !3, line: 109, column: 9)
!472 = !DILocation(line: 110, column: 1, scope: !447)
!473 = distinct !DISubprogram(name: "verify_queens", scope: !3, file: !3, line: 112, type: !474, scopeLine: 113, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !311)
!474 = !DISubroutineType(types: !475)
!475 = !{!19, !19}
!476 = !DILocalVariable(name: "size", arg: 1, scope: !473, file: !3, line: 112, type: !19)
!477 = !DILocation(line: 112, column: 24, scope: !473)
!478 = !DILocation(line: 114, column: 7, scope: !479)
!479 = distinct !DILexicalBlock(scope: !473, file: !3, line: 114, column: 7)
!480 = !DILocation(line: 114, column: 12, scope: !479)
!481 = !DILocation(line: 114, column: 7, scope: !473)
!482 = !DILocation(line: 114, column: 30, scope: !479)
!483 = !DILocation(line: 115, column: 7, scope: !484)
!484 = distinct !DILexicalBlock(scope: !473, file: !3, line: 115, column: 7)
!485 = !DILocation(line: 115, column: 32, scope: !484)
!486 = !DILocation(line: 115, column: 36, scope: !484)
!487 = !DILocation(line: 115, column: 22, scope: !484)
!488 = !DILocation(line: 115, column: 19, scope: !484)
!489 = !DILocation(line: 115, column: 7, scope: !473)
!490 = !DILocation(line: 115, column: 41, scope: !484)
!491 = !DILocation(line: 116, column: 2, scope: !473)
!492 = !DILocation(line: 117, column: 1, scope: !473)
!493 = distinct !DISubprogram(name: "bots_error", scope: !81, file: !81, line: 35, type: !494, scopeLine: 36, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !80, retainedNodes: !311)
!494 = !DISubroutineType(types: !495)
!495 = !{null, !19, !14}
!496 = !DILocalVariable(name: "error", arg: 1, scope: !493, file: !81, line: 35, type: !19)
!497 = !DILocation(line: 35, column: 16, scope: !493)
!498 = !DILocalVariable(name: "message", arg: 2, scope: !493, file: !81, line: 35, type: !14)
!499 = !DILocation(line: 35, column: 29, scope: !493)
!500 = !DILocation(line: 37, column: 8, scope: !501)
!501 = distinct !DILexicalBlock(scope: !493, file: !81, line: 37, column: 8)
!502 = !DILocation(line: 37, column: 16, scope: !501)
!503 = !DILocation(line: 37, column: 8, scope: !493)
!504 = !DILocation(line: 39, column: 14, scope: !505)
!505 = distinct !DILexicalBlock(scope: !501, file: !81, line: 38, column: 4)
!506 = !DILocation(line: 39, column: 7, scope: !505)
!507 = !DILocation(line: 42, column: 21, scope: !508)
!508 = distinct !DILexicalBlock(scope: !505, file: !81, line: 40, column: 7)
!509 = !DILocation(line: 42, column: 48, scope: !508)
!510 = !DILocation(line: 42, column: 13, scope: !508)
!511 = !DILocation(line: 43, column: 13, scope: !508)
!512 = !DILocation(line: 45, column: 21, scope: !508)
!513 = !DILocation(line: 45, column: 48, scope: !508)
!514 = !DILocation(line: 45, column: 13, scope: !508)
!515 = !DILocation(line: 46, column: 13, scope: !508)
!516 = !DILocation(line: 48, column: 21, scope: !508)
!517 = !DILocation(line: 48, column: 48, scope: !508)
!518 = !DILocation(line: 48, column: 13, scope: !508)
!519 = !DILocation(line: 49, column: 13, scope: !508)
!520 = !DILocation(line: 50, column: 13, scope: !508)
!521 = !DILocation(line: 52, column: 21, scope: !508)
!522 = !DILocation(line: 52, column: 48, scope: !508)
!523 = !DILocation(line: 52, column: 13, scope: !508)
!524 = !DILocation(line: 53, column: 13, scope: !508)
!525 = !DILocation(line: 55, column: 4, scope: !505)
!526 = !DILocation(line: 56, column: 17, scope: !501)
!527 = !DILocation(line: 56, column: 44, scope: !501)
!528 = !DILocation(line: 56, column: 50, scope: !501)
!529 = !DILocation(line: 56, column: 9, scope: !501)
!530 = !DILocation(line: 57, column: 13, scope: !493)
!531 = !DILocation(line: 57, column: 12, scope: !493)
!532 = !DILocation(line: 57, column: 4, scope: !493)
!533 = !DILocation(line: 58, column: 1, scope: !493)
!534 = distinct !DISubprogram(name: "bots_warning", scope: !81, file: !81, line: 61, type: !494, scopeLine: 62, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !80, retainedNodes: !311)
!535 = !DILocalVariable(name: "warning", arg: 1, scope: !534, file: !81, line: 61, type: !19)
!536 = !DILocation(line: 61, column: 18, scope: !534)
!537 = !DILocalVariable(name: "message", arg: 2, scope: !534, file: !81, line: 61, type: !14)
!538 = !DILocation(line: 61, column: 33, scope: !534)
!539 = !DILocation(line: 63, column: 8, scope: !540)
!540 = distinct !DILexicalBlock(scope: !534, file: !81, line: 63, column: 8)
!541 = !DILocation(line: 63, column: 16, scope: !540)
!542 = !DILocation(line: 63, column: 8, scope: !534)
!543 = !DILocation(line: 65, column: 14, scope: !544)
!544 = distinct !DILexicalBlock(scope: !540, file: !81, line: 64, column: 4)
!545 = !DILocation(line: 65, column: 7, scope: !544)
!546 = !DILocation(line: 68, column: 21, scope: !547)
!547 = distinct !DILexicalBlock(scope: !544, file: !81, line: 66, column: 7)
!548 = !DILocation(line: 68, column: 50, scope: !547)
!549 = !DILocation(line: 68, column: 13, scope: !547)
!550 = !DILocation(line: 69, column: 13, scope: !547)
!551 = !DILocation(line: 71, column: 21, scope: !547)
!552 = !DILocation(line: 71, column: 50, scope: !547)
!553 = !DILocation(line: 71, column: 13, scope: !547)
!554 = !DILocation(line: 72, column: 13, scope: !547)
!555 = !DILocation(line: 74, column: 4, scope: !544)
!556 = !DILocation(line: 75, column: 17, scope: !540)
!557 = !DILocation(line: 75, column: 46, scope: !540)
!558 = !DILocation(line: 75, column: 54, scope: !540)
!559 = !DILocation(line: 75, column: 9, scope: !540)
!560 = !DILocation(line: 76, column: 1, scope: !534)
!561 = distinct !DISubprogram(name: "bots_usecs", scope: !81, file: !81, line: 78, type: !562, scopeLine: 79, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !80, retainedNodes: !311)
!562 = !DISubroutineType(types: !563)
!563 = !{!564}
!564 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!565 = !DILocalVariable(name: "t", scope: !561, file: !81, line: 80, type: !566)
!566 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "timeval", file: !567, line: 8, size: 128, elements: !568)
!567 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/struct_timeval.h", directory: "")
!568 = !{!569, !572}
!569 = !DIDerivedType(tag: DW_TAG_member, name: "tv_sec", scope: !566, file: !567, line: 10, baseType: !570, size: 64)
!570 = !DIDerivedType(tag: DW_TAG_typedef, name: "__time_t", file: !571, line: 160, baseType: !564)
!571 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!572 = !DIDerivedType(tag: DW_TAG_member, name: "tv_usec", scope: !566, file: !567, line: 11, baseType: !573, size: 64, offset: 64)
!573 = !DIDerivedType(tag: DW_TAG_typedef, name: "__suseconds_t", file: !571, line: 162, baseType: !564)
!574 = !DILocation(line: 80, column: 19, scope: !561)
!575 = !DILocation(line: 81, column: 4, scope: !561)
!576 = !DILocation(line: 82, column: 13, scope: !561)
!577 = !DILocation(line: 82, column: 19, scope: !561)
!578 = !DILocation(line: 82, column: 30, scope: !561)
!579 = !DILocation(line: 82, column: 27, scope: !561)
!580 = !DILocation(line: 82, column: 4, scope: !561)
!581 = distinct !DISubprogram(name: "bots_get_date", scope: !81, file: !81, line: 86, type: !582, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !80, retainedNodes: !311)
!582 = !DISubroutineType(types: !583)
!583 = !{null, !14}
!584 = !DILocalVariable(name: "str", arg: 1, scope: !581, file: !81, line: 86, type: !14)
!585 = !DILocation(line: 86, column: 21, scope: !581)
!586 = !DILocalVariable(name: "now", scope: !581, file: !81, line: 88, type: !587)
!587 = !DIDerivedType(tag: DW_TAG_typedef, name: "time_t", file: !588, line: 7, baseType: !570)
!588 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/time_t.h", directory: "")
!589 = !DILocation(line: 88, column: 11, scope: !581)
!590 = !DILocation(line: 89, column: 4, scope: !581)
!591 = !DILocation(line: 90, column: 13, scope: !581)
!592 = !DILocation(line: 90, column: 40, scope: !581)
!593 = !DILocation(line: 90, column: 4, scope: !581)
!594 = !DILocation(line: 91, column: 1, scope: !581)
!595 = distinct !DISubprogram(name: "bots_get_architecture", scope: !81, file: !81, line: 93, type: !582, scopeLine: 94, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !80, retainedNodes: !311)
!596 = !DILocalVariable(name: "str", arg: 1, scope: !595, file: !81, line: 93, type: !14)
!597 = !DILocation(line: 93, column: 34, scope: !595)
!598 = !DILocalVariable(name: "ncpus", scope: !595, file: !81, line: 95, type: !19)
!599 = !DILocation(line: 95, column: 8, scope: !595)
!600 = !DILocation(line: 95, column: 16, scope: !595)
!601 = !DILocalVariable(name: "architecture", scope: !595, file: !81, line: 96, type: !602)
!602 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "utsname", file: !603, line: 48, size: 3120, elements: !604)
!603 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/sys/utsname.h", directory: "")
!604 = !{!605, !609, !610, !611, !612, !613}
!605 = !DIDerivedType(tag: DW_TAG_member, name: "sysname", scope: !602, file: !603, line: 51, baseType: !606, size: 520)
!606 = !DICompositeType(tag: DW_TAG_array_type, baseType: !13, size: 520, elements: !607)
!607 = !{!608}
!608 = !DISubrange(count: 65)
!609 = !DIDerivedType(tag: DW_TAG_member, name: "nodename", scope: !602, file: !603, line: 54, baseType: !606, size: 520, offset: 520)
!610 = !DIDerivedType(tag: DW_TAG_member, name: "release", scope: !602, file: !603, line: 57, baseType: !606, size: 520, offset: 1040)
!611 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !602, file: !603, line: 59, baseType: !606, size: 520, offset: 1560)
!612 = !DIDerivedType(tag: DW_TAG_member, name: "machine", scope: !602, file: !603, line: 62, baseType: !606, size: 520, offset: 2080)
!613 = !DIDerivedType(tag: DW_TAG_member, name: "__domainname", scope: !602, file: !603, line: 69, baseType: !606, size: 520, offset: 2600)
!614 = !DILocation(line: 96, column: 19, scope: !595)
!615 = !DILocation(line: 98, column: 4, scope: !595)
!616 = !DILocation(line: 99, column: 13, scope: !595)
!617 = !DILocation(line: 99, column: 60, scope: !595)
!618 = !DILocation(line: 99, column: 47, scope: !595)
!619 = !DILocation(line: 99, column: 82, scope: !595)
!620 = !DILocation(line: 99, column: 69, scope: !595)
!621 = !DILocation(line: 99, column: 91, scope: !595)
!622 = !DILocation(line: 99, column: 4, scope: !595)
!623 = !DILocation(line: 100, column: 1, scope: !595)
!624 = distinct !DISubprogram(name: "bots_get_load_average", scope: !81, file: !81, line: 104, type: !582, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !80, retainedNodes: !311)
!625 = !DILocalVariable(name: "str", arg: 1, scope: !624, file: !81, line: 104, type: !14)
!626 = !DILocation(line: 104, column: 34, scope: !624)
!627 = !DILocalVariable(name: "loadavg", scope: !624, file: !81, line: 106, type: !628)
!628 = !DICompositeType(tag: DW_TAG_array_type, baseType: !28, size: 192, elements: !629)
!629 = !{!630}
!630 = !DISubrange(count: 3)
!631 = !DILocation(line: 106, column: 11, scope: !624)
!632 = !DILocation(line: 107, column: 16, scope: !624)
!633 = !DILocation(line: 107, column: 4, scope: !624)
!634 = !DILocation(line: 108, column: 13, scope: !624)
!635 = !DILocation(line: 108, column: 52, scope: !624)
!636 = !DILocation(line: 108, column: 63, scope: !624)
!637 = !DILocation(line: 108, column: 74, scope: !624)
!638 = !DILocation(line: 108, column: 4, scope: !624)
!639 = !DILocation(line: 109, column: 1, scope: !624)
!640 = distinct !DISubprogram(name: "bots_print_results", scope: !81, file: !81, line: 115, type: !641, scopeLine: 116, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !80, retainedNodes: !311)
!641 = !DISubroutineType(types: !642)
!642 = !{null}
!643 = !DILocalVariable(name: "str_name", scope: !640, file: !81, line: 117, type: !51)
!644 = !DILocation(line: 117, column: 9, scope: !640)
!645 = !DILocalVariable(name: "str_parameters", scope: !640, file: !81, line: 118, type: !51)
!646 = !DILocation(line: 118, column: 9, scope: !640)
!647 = !DILocalVariable(name: "str_model", scope: !640, file: !81, line: 119, type: !51)
!648 = !DILocation(line: 119, column: 9, scope: !640)
!649 = !DILocalVariable(name: "str_resources", scope: !640, file: !81, line: 120, type: !51)
!650 = !DILocation(line: 120, column: 9, scope: !640)
!651 = !DILocalVariable(name: "str_result", scope: !640, file: !81, line: 121, type: !652)
!652 = !DICompositeType(tag: DW_TAG_array_type, baseType: !13, size: 120, elements: !653)
!653 = !{!654}
!654 = !DISubrange(count: 15)
!655 = !DILocation(line: 121, column: 9, scope: !640)
!656 = !DILocalVariable(name: "str_time_program", scope: !640, file: !81, line: 122, type: !652)
!657 = !DILocation(line: 122, column: 9, scope: !640)
!658 = !DILocalVariable(name: "str_time_sequential", scope: !640, file: !81, line: 123, type: !652)
!659 = !DILocation(line: 123, column: 9, scope: !640)
!660 = !DILocalVariable(name: "str_speed_up", scope: !640, file: !81, line: 124, type: !652)
!661 = !DILocation(line: 124, column: 9, scope: !640)
!662 = !DILocalVariable(name: "str_number_of_tasks", scope: !640, file: !81, line: 125, type: !652)
!663 = !DILocation(line: 125, column: 9, scope: !640)
!664 = !DILocalVariable(name: "str_number_of_tasks_per_second", scope: !640, file: !81, line: 126, type: !652)
!665 = !DILocation(line: 126, column: 9, scope: !640)
!666 = !DILocalVariable(name: "str_exec_date", scope: !640, file: !81, line: 127, type: !51)
!667 = !DILocation(line: 127, column: 9, scope: !640)
!668 = !DILocalVariable(name: "str_exec_message", scope: !640, file: !81, line: 128, type: !51)
!669 = !DILocation(line: 128, column: 9, scope: !640)
!670 = !DILocalVariable(name: "str_architecture", scope: !640, file: !81, line: 129, type: !51)
!671 = !DILocation(line: 129, column: 9, scope: !640)
!672 = !DILocalVariable(name: "str_load_avg", scope: !640, file: !81, line: 130, type: !51)
!673 = !DILocation(line: 130, column: 9, scope: !640)
!674 = !DILocalVariable(name: "str_comp_date", scope: !640, file: !81, line: 131, type: !51)
!675 = !DILocation(line: 131, column: 9, scope: !640)
!676 = !DILocalVariable(name: "str_comp_message", scope: !640, file: !81, line: 132, type: !51)
!677 = !DILocation(line: 132, column: 9, scope: !640)
!678 = !DILocalVariable(name: "str_cc", scope: !640, file: !81, line: 133, type: !51)
!679 = !DILocation(line: 133, column: 9, scope: !640)
!680 = !DILocalVariable(name: "str_cflags", scope: !640, file: !81, line: 134, type: !51)
!681 = !DILocation(line: 134, column: 9, scope: !640)
!682 = !DILocalVariable(name: "str_ld", scope: !640, file: !81, line: 135, type: !51)
!683 = !DILocation(line: 135, column: 9, scope: !640)
!684 = !DILocalVariable(name: "str_ldflags", scope: !640, file: !81, line: 136, type: !51)
!685 = !DILocation(line: 136, column: 9, scope: !640)
!686 = !DILocalVariable(name: "str_cutoff", scope: !640, file: !81, line: 137, type: !51)
!687 = !DILocation(line: 137, column: 9, scope: !640)
!688 = !DILocation(line: 140, column: 12, scope: !640)
!689 = !DILocation(line: 140, column: 4, scope: !640)
!690 = !DILocation(line: 141, column: 12, scope: !640)
!691 = !DILocation(line: 141, column: 4, scope: !640)
!692 = !DILocation(line: 142, column: 12, scope: !640)
!693 = !DILocation(line: 142, column: 4, scope: !640)
!694 = !DILocation(line: 143, column: 12, scope: !640)
!695 = !DILocation(line: 143, column: 4, scope: !640)
!696 = !DILocation(line: 144, column: 12, scope: !640)
!697 = !DILocation(line: 144, column: 4, scope: !640)
!698 = !DILocation(line: 145, column: 11, scope: !640)
!699 = !DILocation(line: 145, column: 4, scope: !640)
!700 = !DILocation(line: 148, column: 18, scope: !701)
!701 = distinct !DILexicalBlock(scope: !640, file: !81, line: 146, column: 4)
!702 = !DILocation(line: 148, column: 10, scope: !701)
!703 = !DILocation(line: 149, column: 10, scope: !701)
!704 = !DILocation(line: 151, column: 18, scope: !701)
!705 = !DILocation(line: 151, column: 10, scope: !701)
!706 = !DILocation(line: 152, column: 10, scope: !701)
!707 = !DILocation(line: 154, column: 18, scope: !701)
!708 = !DILocation(line: 154, column: 10, scope: !701)
!709 = !DILocation(line: 155, column: 10, scope: !701)
!710 = !DILocation(line: 157, column: 18, scope: !701)
!711 = !DILocation(line: 157, column: 10, scope: !701)
!712 = !DILocation(line: 158, column: 10, scope: !701)
!713 = !DILocation(line: 160, column: 18, scope: !701)
!714 = !DILocation(line: 160, column: 10, scope: !701)
!715 = !DILocation(line: 161, column: 10, scope: !701)
!716 = !DILocation(line: 163, column: 12, scope: !640)
!717 = !DILocation(line: 163, column: 36, scope: !640)
!718 = !DILocation(line: 163, column: 4, scope: !640)
!719 = !DILocation(line: 164, column: 8, scope: !720)
!720 = distinct !DILexicalBlock(scope: !640, file: !81, line: 164, column: 8)
!721 = !DILocation(line: 164, column: 8, scope: !640)
!722 = !DILocation(line: 164, column: 38, scope: !720)
!723 = !DILocation(line: 164, column: 65, scope: !720)
!724 = !DILocation(line: 164, column: 30, scope: !720)
!725 = !DILocation(line: 165, column: 17, scope: !720)
!726 = !DILocation(line: 165, column: 9, scope: !720)
!727 = !DILocation(line: 166, column: 8, scope: !728)
!728 = distinct !DILexicalBlock(scope: !640, file: !81, line: 166, column: 8)
!729 = !DILocation(line: 166, column: 8, scope: !640)
!730 = !DILocation(line: 167, column: 12, scope: !728)
!731 = !DILocation(line: 167, column: 35, scope: !728)
!732 = !DILocation(line: 167, column: 56, scope: !728)
!733 = !DILocation(line: 167, column: 55, scope: !728)
!734 = !DILocation(line: 167, column: 4, scope: !728)
!735 = !DILocation(line: 168, column: 17, scope: !728)
!736 = !DILocation(line: 168, column: 9, scope: !728)
!737 = !DILocation(line: 170, column: 12, scope: !640)
!738 = !DILocation(line: 170, column: 50, scope: !640)
!739 = !DILocation(line: 170, column: 42, scope: !640)
!740 = !DILocation(line: 170, column: 4, scope: !640)
!741 = !DILocation(line: 171, column: 12, scope: !640)
!742 = !DILocation(line: 171, column: 61, scope: !640)
!743 = !DILocation(line: 171, column: 53, scope: !640)
!744 = !DILocation(line: 171, column: 82, scope: !640)
!745 = !DILocation(line: 171, column: 81, scope: !640)
!746 = !DILocation(line: 171, column: 4, scope: !640)
!747 = !DILocation(line: 173, column: 12, scope: !640)
!748 = !DILocation(line: 173, column: 4, scope: !640)
!749 = !DILocation(line: 174, column: 12, scope: !640)
!750 = !DILocation(line: 174, column: 4, scope: !640)
!751 = !DILocation(line: 175, column: 26, scope: !640)
!752 = !DILocation(line: 175, column: 4, scope: !640)
!753 = !DILocation(line: 176, column: 26, scope: !640)
!754 = !DILocation(line: 176, column: 4, scope: !640)
!755 = !DILocation(line: 177, column: 12, scope: !640)
!756 = !DILocation(line: 177, column: 4, scope: !640)
!757 = !DILocation(line: 178, column: 12, scope: !640)
!758 = !DILocation(line: 178, column: 4, scope: !640)
!759 = !DILocation(line: 179, column: 12, scope: !640)
!760 = !DILocation(line: 179, column: 4, scope: !640)
!761 = !DILocation(line: 180, column: 12, scope: !640)
!762 = !DILocation(line: 180, column: 4, scope: !640)
!763 = !DILocation(line: 181, column: 12, scope: !640)
!764 = !DILocation(line: 181, column: 4, scope: !640)
!765 = !DILocation(line: 182, column: 12, scope: !640)
!766 = !DILocation(line: 182, column: 4, scope: !640)
!767 = !DILocation(line: 184, column: 7, scope: !768)
!768 = distinct !DILexicalBlock(scope: !640, file: !81, line: 184, column: 7)
!769 = !DILocation(line: 184, column: 7, scope: !640)
!770 = !DILocation(line: 186, column: 14, scope: !771)
!771 = distinct !DILexicalBlock(scope: !768, file: !81, line: 185, column: 4)
!772 = !DILocation(line: 186, column: 7, scope: !771)
!773 = !DILocation(line: 189, column: 13, scope: !774)
!774 = distinct !DILexicalBlock(scope: !771, file: !81, line: 187, column: 7)
!775 = !DILocation(line: 191, column: 13, scope: !774)
!776 = !DILocation(line: 193, column: 9, scope: !774)
!777 = !DILocation(line: 193, column: 1, scope: !774)
!778 = !DILocation(line: 200, column: 13, scope: !774)
!779 = !DILocation(line: 202, column: 13, scope: !774)
!780 = !DILocation(line: 204, column: 9, scope: !774)
!781 = !DILocation(line: 204, column: 1, scope: !774)
!782 = !DILocation(line: 208, column: 13, scope: !774)
!783 = !DILocation(line: 210, column: 13, scope: !774)
!784 = !DILocation(line: 212, column: 4, scope: !771)
!785 = !DILocation(line: 215, column: 11, scope: !640)
!786 = !DILocation(line: 215, column: 4, scope: !640)
!787 = !DILocation(line: 218, column: 10, scope: !788)
!788 = distinct !DILexicalBlock(scope: !640, file: !81, line: 216, column: 4)
!789 = !DILocation(line: 220, column: 11, scope: !788)
!790 = !DILocation(line: 220, column: 3, scope: !788)
!791 = !DILocation(line: 221, column: 18, scope: !788)
!792 = !DILocation(line: 221, column: 56, scope: !788)
!793 = !DILocation(line: 221, column: 10, scope: !788)
!794 = !DILocation(line: 222, column: 18, scope: !788)
!795 = !DILocation(line: 222, column: 56, scope: !788)
!796 = !DILocation(line: 222, column: 10, scope: !788)
!797 = !DILocation(line: 223, column: 18, scope: !788)
!798 = !DILocation(line: 223, column: 56, scope: !788)
!799 = !DILocation(line: 223, column: 10, scope: !788)
!800 = !DILocation(line: 224, column: 18, scope: !788)
!801 = !DILocation(line: 224, column: 56, scope: !788)
!802 = !DILocation(line: 224, column: 10, scope: !788)
!803 = !DILocation(line: 225, column: 18, scope: !788)
!804 = !DILocation(line: 225, column: 56, scope: !788)
!805 = !DILocation(line: 225, column: 10, scope: !788)
!806 = !DILocation(line: 226, column: 18, scope: !788)
!807 = !DILocation(line: 226, column: 56, scope: !788)
!808 = !DILocation(line: 226, column: 10, scope: !788)
!809 = !DILocation(line: 228, column: 18, scope: !788)
!810 = !DILocation(line: 228, column: 64, scope: !788)
!811 = !DILocation(line: 228, column: 10, scope: !788)
!812 = !DILocation(line: 229, column: 7, scope: !813)
!813 = distinct !DILexicalBlock(scope: !788, file: !81, line: 229, column: 7)
!814 = !DILocation(line: 229, column: 7, scope: !788)
!815 = !DILocation(line: 230, column: 20, scope: !816)
!816 = distinct !DILexicalBlock(scope: !813, file: !81, line: 229, column: 29)
!817 = !DILocation(line: 230, column: 66, scope: !816)
!818 = !DILocation(line: 230, column: 12, scope: !816)
!819 = !DILocation(line: 231, column: 20, scope: !816)
!820 = !DILocation(line: 231, column: 58, scope: !816)
!821 = !DILocation(line: 231, column: 12, scope: !816)
!822 = !DILocation(line: 232, column: 3, scope: !816)
!823 = !DILocation(line: 234, column: 15, scope: !824)
!824 = distinct !DILexicalBlock(scope: !788, file: !81, line: 234, column: 15)
!825 = !DILocation(line: 234, column: 36, scope: !824)
!826 = !DILocation(line: 234, column: 15, scope: !788)
!827 = !DILocation(line: 235, column: 20, scope: !828)
!828 = distinct !DILexicalBlock(scope: !824, file: !81, line: 234, column: 42)
!829 = !DILocation(line: 235, column: 58, scope: !828)
!830 = !DILocation(line: 235, column: 12, scope: !828)
!831 = !DILocation(line: 236, column: 20, scope: !828)
!832 = !DILocation(line: 236, column: 58, scope: !828)
!833 = !DILocation(line: 236, column: 12, scope: !828)
!834 = !DILocation(line: 237, column: 3, scope: !828)
!835 = !DILocation(line: 239, column: 18, scope: !788)
!836 = !DILocation(line: 239, column: 56, scope: !788)
!837 = !DILocation(line: 239, column: 10, scope: !788)
!838 = !DILocation(line: 240, column: 18, scope: !788)
!839 = !DILocation(line: 240, column: 56, scope: !788)
!840 = !DILocation(line: 240, column: 10, scope: !788)
!841 = !DILocation(line: 242, column: 18, scope: !788)
!842 = !DILocation(line: 242, column: 56, scope: !788)
!843 = !DILocation(line: 242, column: 10, scope: !788)
!844 = !DILocation(line: 243, column: 18, scope: !788)
!845 = !DILocation(line: 243, column: 56, scope: !788)
!846 = !DILocation(line: 243, column: 10, scope: !788)
!847 = !DILocation(line: 245, column: 18, scope: !788)
!848 = !DILocation(line: 245, column: 56, scope: !788)
!849 = !DILocation(line: 245, column: 10, scope: !788)
!850 = !DILocation(line: 246, column: 18, scope: !788)
!851 = !DILocation(line: 246, column: 56, scope: !788)
!852 = !DILocation(line: 246, column: 10, scope: !788)
!853 = !DILocation(line: 248, column: 18, scope: !788)
!854 = !DILocation(line: 248, column: 56, scope: !788)
!855 = !DILocation(line: 248, column: 10, scope: !788)
!856 = !DILocation(line: 249, column: 18, scope: !788)
!857 = !DILocation(line: 249, column: 56, scope: !788)
!858 = !DILocation(line: 249, column: 10, scope: !788)
!859 = !DILocation(line: 250, column: 18, scope: !788)
!860 = !DILocation(line: 250, column: 56, scope: !788)
!861 = !DILocation(line: 250, column: 10, scope: !788)
!862 = !DILocation(line: 251, column: 18, scope: !788)
!863 = !DILocation(line: 251, column: 56, scope: !788)
!864 = !DILocation(line: 251, column: 10, scope: !788)
!865 = !DILocation(line: 252, column: 10, scope: !788)
!866 = !DILocation(line: 252, column: 3, scope: !788)
!867 = !DILocation(line: 253, column: 10, scope: !788)
!868 = !DILocation(line: 255, column: 18, scope: !788)
!869 = !DILocation(line: 256, column: 15, scope: !788)
!870 = !DILocation(line: 257, column: 15, scope: !788)
!871 = !DILocation(line: 258, column: 15, scope: !788)
!872 = !DILocation(line: 259, column: 15, scope: !788)
!873 = !DILocation(line: 260, column: 15, scope: !788)
!874 = !DILocation(line: 261, column: 15, scope: !788)
!875 = !DILocation(line: 255, column: 10, scope: !788)
!876 = !DILocation(line: 263, column: 18, scope: !788)
!877 = !DILocation(line: 264, column: 15, scope: !788)
!878 = !DILocation(line: 265, column: 15, scope: !788)
!879 = !DILocation(line: 266, column: 15, scope: !788)
!880 = !DILocation(line: 263, column: 10, scope: !788)
!881 = !DILocation(line: 268, column: 18, scope: !788)
!882 = !DILocation(line: 269, column: 15, scope: !788)
!883 = !DILocation(line: 270, column: 15, scope: !788)
!884 = !DILocation(line: 268, column: 10, scope: !788)
!885 = !DILocation(line: 272, column: 18, scope: !788)
!886 = !DILocation(line: 273, column: 15, scope: !788)
!887 = !DILocation(line: 274, column: 15, scope: !788)
!888 = !DILocation(line: 272, column: 10, scope: !788)
!889 = !DILocation(line: 276, column: 18, scope: !788)
!890 = !DILocation(line: 277, column: 15, scope: !788)
!891 = !DILocation(line: 278, column: 15, scope: !788)
!892 = !DILocation(line: 276, column: 10, scope: !788)
!893 = !DILocation(line: 280, column: 18, scope: !788)
!894 = !DILocation(line: 281, column: 15, scope: !788)
!895 = !DILocation(line: 282, column: 15, scope: !788)
!896 = !DILocation(line: 280, column: 10, scope: !788)
!897 = !DILocation(line: 284, column: 18, scope: !788)
!898 = !DILocation(line: 285, column: 15, scope: !788)
!899 = !DILocation(line: 286, column: 15, scope: !788)
!900 = !DILocation(line: 287, column: 15, scope: !788)
!901 = !DILocation(line: 288, column: 15, scope: !788)
!902 = !DILocation(line: 284, column: 10, scope: !788)
!903 = !DILocation(line: 290, column: 18, scope: !788)
!904 = !DILocation(line: 290, column: 10, scope: !788)
!905 = !DILocation(line: 291, column: 10, scope: !788)
!906 = !DILocation(line: 293, column: 11, scope: !788)
!907 = !DILocation(line: 293, column: 3, scope: !788)
!908 = !DILocation(line: 294, column: 18, scope: !788)
!909 = !DILocation(line: 294, column: 56, scope: !788)
!910 = !DILocation(line: 294, column: 10, scope: !788)
!911 = !DILocation(line: 295, column: 18, scope: !788)
!912 = !DILocation(line: 295, column: 56, scope: !788)
!913 = !DILocation(line: 295, column: 10, scope: !788)
!914 = !DILocation(line: 296, column: 18, scope: !788)
!915 = !DILocation(line: 296, column: 56, scope: !788)
!916 = !DILocation(line: 296, column: 10, scope: !788)
!917 = !DILocation(line: 297, column: 18, scope: !788)
!918 = !DILocation(line: 297, column: 56, scope: !788)
!919 = !DILocation(line: 297, column: 10, scope: !788)
!920 = !DILocation(line: 298, column: 18, scope: !788)
!921 = !DILocation(line: 298, column: 56, scope: !788)
!922 = !DILocation(line: 298, column: 10, scope: !788)
!923 = !DILocation(line: 299, column: 18, scope: !788)
!924 = !DILocation(line: 299, column: 56, scope: !788)
!925 = !DILocation(line: 299, column: 10, scope: !788)
!926 = !DILocation(line: 301, column: 18, scope: !788)
!927 = !DILocation(line: 301, column: 64, scope: !788)
!928 = !DILocation(line: 301, column: 10, scope: !788)
!929 = !DILocation(line: 302, column: 7, scope: !930)
!930 = distinct !DILexicalBlock(scope: !788, file: !81, line: 302, column: 7)
!931 = !DILocation(line: 302, column: 7, scope: !788)
!932 = !DILocation(line: 303, column: 20, scope: !933)
!933 = distinct !DILexicalBlock(scope: !930, file: !81, line: 302, column: 29)
!934 = !DILocation(line: 303, column: 66, scope: !933)
!935 = !DILocation(line: 303, column: 12, scope: !933)
!936 = !DILocation(line: 304, column: 20, scope: !933)
!937 = !DILocation(line: 304, column: 58, scope: !933)
!938 = !DILocation(line: 304, column: 12, scope: !933)
!939 = !DILocation(line: 305, column: 3, scope: !933)
!940 = !DILocation(line: 307, column: 15, scope: !941)
!941 = distinct !DILexicalBlock(scope: !788, file: !81, line: 307, column: 15)
!942 = !DILocation(line: 307, column: 36, scope: !941)
!943 = !DILocation(line: 307, column: 15, scope: !788)
!944 = !DILocation(line: 308, column: 20, scope: !945)
!945 = distinct !DILexicalBlock(scope: !941, file: !81, line: 307, column: 42)
!946 = !DILocation(line: 308, column: 58, scope: !945)
!947 = !DILocation(line: 308, column: 12, scope: !945)
!948 = !DILocation(line: 309, column: 20, scope: !945)
!949 = !DILocation(line: 309, column: 58, scope: !945)
!950 = !DILocation(line: 309, column: 12, scope: !945)
!951 = !DILocation(line: 310, column: 3, scope: !945)
!952 = !DILocation(line: 311, column: 10, scope: !788)
!953 = !DILocation(line: 313, column: 18, scope: !788)
!954 = !DILocation(line: 314, column: 15, scope: !788)
!955 = !DILocation(line: 315, column: 15, scope: !788)
!956 = !DILocation(line: 316, column: 15, scope: !788)
!957 = !DILocation(line: 317, column: 15, scope: !788)
!958 = !DILocation(line: 318, column: 15, scope: !788)
!959 = !DILocation(line: 319, column: 15, scope: !788)
!960 = !DILocation(line: 313, column: 10, scope: !788)
!961 = !DILocation(line: 321, column: 18, scope: !788)
!962 = !DILocation(line: 322, column: 15, scope: !788)
!963 = !DILocation(line: 323, column: 15, scope: !788)
!964 = !DILocation(line: 324, column: 15, scope: !788)
!965 = !DILocation(line: 321, column: 10, scope: !788)
!966 = !DILocation(line: 326, column: 18, scope: !788)
!967 = !DILocation(line: 327, column: 15, scope: !788)
!968 = !DILocation(line: 328, column: 15, scope: !788)
!969 = !DILocation(line: 326, column: 10, scope: !788)
!970 = !DILocation(line: 330, column: 18, scope: !788)
!971 = !DILocation(line: 330, column: 10, scope: !788)
!972 = !DILocation(line: 331, column: 10, scope: !788)
!973 = !DILocation(line: 333, column: 10, scope: !788)
!974 = !DILocation(line: 334, column: 10, scope: !788)
!975 = !DILocation(line: 336, column: 1, scope: !640)
!976 = distinct !DISubprogram(name: "bots_print_usage", scope: !25, file: !25, line: 211, type: !641, scopeLine: 212, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !24, retainedNodes: !311)
!977 = !DILocation(line: 213, column: 12, scope: !976)
!978 = !DILocation(line: 213, column: 4, scope: !976)
!979 = !DILocation(line: 214, column: 12, scope: !976)
!980 = !DILocation(line: 214, column: 4, scope: !976)
!981 = !DILocation(line: 215, column: 12, scope: !976)
!982 = !DILocation(line: 215, column: 4, scope: !976)
!983 = !DILocation(line: 216, column: 12, scope: !976)
!984 = !DILocation(line: 216, column: 4, scope: !976)
!985 = !DILocation(line: 221, column: 12, scope: !976)
!986 = !DILocation(line: 221, column: 4, scope: !976)
!987 = !DILocation(line: 245, column: 12, scope: !976)
!988 = !DILocation(line: 245, column: 4, scope: !976)
!989 = !DILocation(line: 246, column: 12, scope: !976)
!990 = !DILocation(line: 246, column: 4, scope: !976)
!991 = !DILocation(line: 247, column: 12, scope: !976)
!992 = !DILocation(line: 247, column: 4, scope: !976)
!993 = !DILocation(line: 248, column: 12, scope: !976)
!994 = !DILocation(line: 248, column: 4, scope: !976)
!995 = !DILocation(line: 249, column: 12, scope: !976)
!996 = !DILocation(line: 249, column: 4, scope: !976)
!997 = !DILocation(line: 250, column: 12, scope: !976)
!998 = !DILocation(line: 250, column: 4, scope: !976)
!999 = !DILocation(line: 251, column: 12, scope: !976)
!1000 = !DILocation(line: 251, column: 4, scope: !976)
!1001 = !DILocation(line: 252, column: 12, scope: !976)
!1002 = !DILocation(line: 252, column: 4, scope: !976)
!1003 = !DILocation(line: 253, column: 12, scope: !976)
!1004 = !DILocation(line: 253, column: 4, scope: !976)
!1005 = !DILocation(line: 254, column: 12, scope: !976)
!1006 = !DILocation(line: 254, column: 4, scope: !976)
!1007 = !DILocation(line: 255, column: 12, scope: !976)
!1008 = !DILocation(line: 255, column: 4, scope: !976)
!1009 = !DILocation(line: 256, column: 12, scope: !976)
!1010 = !DILocation(line: 256, column: 4, scope: !976)
!1011 = !DILocation(line: 257, column: 12, scope: !976)
!1012 = !DILocation(line: 257, column: 4, scope: !976)
!1013 = !DILocation(line: 258, column: 12, scope: !976)
!1014 = !DILocation(line: 258, column: 4, scope: !976)
!1015 = !DILocation(line: 265, column: 12, scope: !976)
!1016 = !DILocation(line: 265, column: 4, scope: !976)
!1017 = !DILocation(line: 267, column: 12, scope: !976)
!1018 = !DILocation(line: 267, column: 4, scope: !976)
!1019 = !DILocation(line: 268, column: 12, scope: !976)
!1020 = !DILocation(line: 268, column: 4, scope: !976)
!1021 = !DILocation(line: 269, column: 12, scope: !976)
!1022 = !DILocation(line: 269, column: 4, scope: !976)
!1023 = !DILocation(line: 270, column: 1, scope: !976)
!1024 = distinct !DISubprogram(name: "bots_get_params_common", scope: !25, file: !25, line: 275, type: !1025, scopeLine: 276, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !24, retainedNodes: !311)
!1025 = !DISubroutineType(types: !1026)
!1026 = !{null, !19, !1027}
!1027 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!1028 = !DILocalVariable(name: "argc", arg: 1, scope: !1024, file: !25, line: 275, type: !19)
!1029 = !DILocation(line: 275, column: 28, scope: !1024)
!1030 = !DILocalVariable(name: "argv", arg: 2, scope: !1024, file: !25, line: 275, type: !1027)
!1031 = !DILocation(line: 275, column: 41, scope: !1024)
!1032 = !DILocalVariable(name: "i", scope: !1024, file: !25, line: 277, type: !19)
!1033 = !DILocation(line: 277, column: 8, scope: !1024)
!1034 = !DILocation(line: 278, column: 35, scope: !1024)
!1035 = !DILocation(line: 278, column: 26, scope: !1024)
!1036 = !DILocation(line: 278, column: 4, scope: !1024)
!1037 = !DILocation(line: 279, column: 4, scope: !1024)
!1038 = !DILocation(line: 280, column: 4, scope: !1024)
!1039 = !DILocation(line: 281, column: 10, scope: !1040)
!1040 = distinct !DILexicalBlock(scope: !1024, file: !25, line: 281, column: 4)
!1041 = !DILocation(line: 281, column: 9, scope: !1040)
!1042 = !DILocation(line: 281, column: 14, scope: !1043)
!1043 = distinct !DILexicalBlock(scope: !1040, file: !25, line: 281, column: 4)
!1044 = !DILocation(line: 281, column: 16, scope: !1043)
!1045 = !DILocation(line: 281, column: 15, scope: !1043)
!1046 = !DILocation(line: 281, column: 4, scope: !1040)
!1047 = !DILocation(line: 283, column: 11, scope: !1048)
!1048 = distinct !DILexicalBlock(scope: !1049, file: !25, line: 283, column: 11)
!1049 = distinct !DILexicalBlock(scope: !1043, file: !25, line: 282, column: 4)
!1050 = !DILocation(line: 283, column: 16, scope: !1048)
!1051 = !DILocation(line: 283, column: 22, scope: !1048)
!1052 = !DILocation(line: 283, column: 11, scope: !1049)
!1053 = !DILocation(line: 285, column: 18, scope: !1054)
!1054 = distinct !DILexicalBlock(scope: !1048, file: !25, line: 284, column: 7)
!1055 = !DILocation(line: 285, column: 23, scope: !1054)
!1056 = !DILocation(line: 285, column: 10, scope: !1054)
!1057 = !DILocation(line: 304, column: 16, scope: !1058)
!1058 = distinct !DILexicalBlock(scope: !1054, file: !25, line: 286, column: 10)
!1059 = !DILocation(line: 304, column: 21, scope: !1058)
!1060 = !DILocation(line: 304, column: 27, scope: !1058)
!1061 = !DILocation(line: 308, column: 32, scope: !1058)
!1062 = !DILocation(line: 309, column: 16, scope: !1058)
!1063 = !DILocation(line: 311, column: 16, scope: !1058)
!1064 = !DILocation(line: 311, column: 21, scope: !1058)
!1065 = !DILocation(line: 311, column: 27, scope: !1058)
!1066 = !DILocation(line: 312, column: 17, scope: !1058)
!1067 = !DILocation(line: 313, column: 20, scope: !1068)
!1068 = distinct !DILexicalBlock(scope: !1058, file: !25, line: 313, column: 20)
!1069 = !DILocation(line: 313, column: 28, scope: !1068)
!1070 = !DILocation(line: 313, column: 25, scope: !1068)
!1071 = !DILocation(line: 313, column: 20, scope: !1058)
!1072 = !DILocation(line: 313, column: 33, scope: !1073)
!1073 = distinct !DILexicalBlock(scope: !1068, file: !25, line: 313, column: 31)
!1074 = !DILocation(line: 313, column: 53, scope: !1073)
!1075 = !DILocation(line: 314, column: 42, scope: !1058)
!1076 = !DILocation(line: 314, column: 47, scope: !1058)
!1077 = !DILocation(line: 314, column: 16, scope: !1058)
!1078 = !DILocation(line: 315, column: 16, scope: !1058)
!1079 = !DILocation(line: 325, column: 16, scope: !1058)
!1080 = !DILocation(line: 325, column: 21, scope: !1058)
!1081 = !DILocation(line: 325, column: 27, scope: !1058)
!1082 = !DILocation(line: 326, column: 16, scope: !1058)
!1083 = !DILocation(line: 327, column: 16, scope: !1058)
!1084 = !DILocation(line: 346, column: 16, scope: !1058)
!1085 = !DILocation(line: 346, column: 21, scope: !1058)
!1086 = !DILocation(line: 346, column: 27, scope: !1058)
!1087 = !DILocation(line: 347, column: 17, scope: !1058)
!1088 = !DILocation(line: 348, column: 20, scope: !1089)
!1089 = distinct !DILexicalBlock(scope: !1058, file: !25, line: 348, column: 20)
!1090 = !DILocation(line: 348, column: 28, scope: !1089)
!1091 = !DILocation(line: 348, column: 25, scope: !1089)
!1092 = !DILocation(line: 348, column: 20, scope: !1058)
!1093 = !DILocation(line: 348, column: 33, scope: !1094)
!1094 = distinct !DILexicalBlock(scope: !1089, file: !25, line: 348, column: 31)
!1095 = !DILocation(line: 348, column: 53, scope: !1094)
!1096 = !DILocation(line: 349, column: 37, scope: !1058)
!1097 = !DILocation(line: 349, column: 42, scope: !1058)
!1098 = !DILocation(line: 349, column: 32, scope: !1058)
!1099 = !DILocation(line: 349, column: 30, scope: !1058)
!1100 = !DILocation(line: 350, column: 16, scope: !1058)
!1101 = !DILocation(line: 356, column: 16, scope: !1058)
!1102 = !DILocation(line: 356, column: 21, scope: !1058)
!1103 = !DILocation(line: 356, column: 27, scope: !1058)
!1104 = !DILocation(line: 357, column: 17, scope: !1058)
!1105 = !DILocation(line: 358, column: 20, scope: !1106)
!1106 = distinct !DILexicalBlock(scope: !1058, file: !25, line: 358, column: 20)
!1107 = !DILocation(line: 358, column: 28, scope: !1106)
!1108 = !DILocation(line: 358, column: 25, scope: !1106)
!1109 = !DILocation(line: 358, column: 20, scope: !1058)
!1110 = !DILocation(line: 358, column: 33, scope: !1111)
!1111 = distinct !DILexicalBlock(scope: !1106, file: !25, line: 358, column: 31)
!1112 = !DILocation(line: 358, column: 53, scope: !1111)
!1113 = !DILocation(line: 359, column: 42, scope: !1058)
!1114 = !DILocation(line: 359, column: 47, scope: !1058)
!1115 = !DILocation(line: 359, column: 37, scope: !1058)
!1116 = !DILocation(line: 359, column: 35, scope: !1058)
!1117 = !DILocation(line: 360, column: 16, scope: !1058)
!1118 = !DILocation(line: 379, column: 16, scope: !1058)
!1119 = !DILocation(line: 379, column: 21, scope: !1058)
!1120 = !DILocation(line: 379, column: 27, scope: !1058)
!1121 = !DILocation(line: 380, column: 17, scope: !1058)
!1122 = !DILocation(line: 381, column: 20, scope: !1123)
!1123 = distinct !DILexicalBlock(scope: !1058, file: !25, line: 381, column: 20)
!1124 = !DILocation(line: 381, column: 28, scope: !1123)
!1125 = !DILocation(line: 381, column: 25, scope: !1123)
!1126 = !DILocation(line: 381, column: 20, scope: !1058)
!1127 = !DILocation(line: 381, column: 33, scope: !1128)
!1128 = distinct !DILexicalBlock(scope: !1123, file: !25, line: 381, column: 31)
!1129 = !DILocation(line: 381, column: 53, scope: !1128)
!1130 = !DILocation(line: 382, column: 63, scope: !1058)
!1131 = !DILocation(line: 382, column: 68, scope: !1058)
!1132 = !DILocation(line: 382, column: 58, scope: !1058)
!1133 = !DILocation(line: 382, column: 34, scope: !1058)
!1134 = !DILocation(line: 384, column: 21, scope: !1135)
!1135 = distinct !DILexicalBlock(scope: !1058, file: !25, line: 384, column: 21)
!1136 = !DILocation(line: 384, column: 39, scope: !1135)
!1137 = !DILocation(line: 384, column: 21, scope: !1058)
!1138 = !DILocation(line: 385, column: 27, scope: !1139)
!1139 = distinct !DILexicalBlock(scope: !1135, file: !25, line: 384, column: 45)
!1140 = !DILocation(line: 385, column: 19, scope: !1139)
!1141 = !DILocation(line: 386, column: 19, scope: !1139)
!1142 = !DILocation(line: 389, column: 16, scope: !1058)
!1143 = !DILocation(line: 407, column: 9, scope: !1058)
!1144 = !DILocation(line: 407, column: 14, scope: !1058)
!1145 = !DILocation(line: 407, column: 20, scope: !1058)
!1146 = !DILocation(line: 408, column: 34, scope: !1058)
!1147 = !DILocation(line: 409, column: 16, scope: !1058)
!1148 = !DILocation(line: 415, column: 24, scope: !1058)
!1149 = !DILocation(line: 415, column: 16, scope: !1058)
!1150 = !DILocation(line: 416, column: 16, scope: !1058)
!1151 = !DILocation(line: 417, column: 16, scope: !1058)
!1152 = !DILocation(line: 419, column: 7, scope: !1054)
!1153 = !DILocation(line: 426, column: 18, scope: !1154)
!1154 = distinct !DILexicalBlock(scope: !1048, file: !25, line: 421, column: 7)
!1155 = !DILocation(line: 426, column: 10, scope: !1154)
!1156 = !DILocation(line: 427, column: 10, scope: !1154)
!1157 = !DILocation(line: 428, column: 10, scope: !1154)
!1158 = !DILocation(line: 430, column: 4, scope: !1049)
!1159 = !DILocation(line: 281, column: 23, scope: !1043)
!1160 = !DILocation(line: 281, column: 4, scope: !1043)
!1161 = distinct !{!1161, !1046, !1162}
!1162 = !DILocation(line: 430, column: 4, scope: !1040)
!1163 = !DILocation(line: 431, column: 1, scope: !1024)
!1164 = distinct !DISubprogram(name: "bots_get_params", scope: !25, file: !25, line: 436, type: !1025, scopeLine: 437, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !24, retainedNodes: !311)
!1165 = !DILocalVariable(name: "argc", arg: 1, scope: !1164, file: !25, line: 436, type: !19)
!1166 = !DILocation(line: 436, column: 21, scope: !1164)
!1167 = !DILocalVariable(name: "argv", arg: 2, scope: !1164, file: !25, line: 436, type: !1027)
!1168 = !DILocation(line: 436, column: 34, scope: !1164)
!1169 = !DILocation(line: 438, column: 27, scope: !1164)
!1170 = !DILocation(line: 438, column: 33, scope: !1164)
!1171 = !DILocation(line: 438, column: 4, scope: !1164)
!1172 = !DILocation(line: 440, column: 1, scope: !1164)
!1173 = distinct !DISubprogram(name: "bots_set_info", scope: !25, file: !25, line: 446, type: !641, scopeLine: 447, spFlags: DISPFlagDefinition, unit: !24, retainedNodes: !311)
!1174 = !DILocation(line: 449, column: 4, scope: !1173)
!1175 = !DILocation(line: 450, column: 72, scope: !1173)
!1176 = !DILocation(line: 450, column: 4, scope: !1173)
!1177 = !DILocation(line: 451, column: 4, scope: !1173)
!1178 = !DILocation(line: 452, column: 4, scope: !1173)
!1179 = !DILocation(line: 455, column: 4, scope: !1173)
!1180 = !DILocation(line: 456, column: 4, scope: !1173)
!1181 = !DILocation(line: 457, column: 4, scope: !1173)
!1182 = !DILocation(line: 458, column: 4, scope: !1173)
!1183 = !DILocation(line: 459, column: 4, scope: !1173)
!1184 = !DILocation(line: 460, column: 4, scope: !1173)
!1185 = !DILocation(line: 469, column: 4, scope: !1173)
!1186 = !DILocation(line: 471, column: 1, scope: !1173)
!1187 = distinct !DISubprogram(name: "main", scope: !25, file: !25, line: 477, type: !1188, scopeLine: 478, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !24, retainedNodes: !311)
!1188 = !DISubroutineType(types: !1189)
!1189 = !{!19, !19, !1027}
!1190 = !DILocalVariable(name: "argc", arg: 1, scope: !1187, file: !25, line: 477, type: !19)
!1191 = !DILocation(line: 477, column: 10, scope: !1187)
!1192 = !DILocalVariable(name: "argv", arg: 2, scope: !1187, file: !25, line: 477, type: !1027)
!1193 = !DILocation(line: 477, column: 22, scope: !1187)
!1194 = !DILocalVariable(name: "bots_t_start", scope: !1187, file: !25, line: 480, type: !564)
!1195 = !DILocation(line: 480, column: 9, scope: !1187)
!1196 = !DILocalVariable(name: "bots_t_end", scope: !1187, file: !25, line: 481, type: !564)
!1197 = !DILocation(line: 481, column: 9, scope: !1187)
!1198 = !DILocation(line: 484, column: 20, scope: !1187)
!1199 = !DILocation(line: 484, column: 25, scope: !1187)
!1200 = !DILocation(line: 484, column: 4, scope: !1187)
!1201 = !DILocation(line: 486, column: 4, scope: !1187)
!1202 = !DILocation(line: 513, column: 19, scope: !1187)
!1203 = !DILocation(line: 513, column: 17, scope: !1187)
!1204 = !DILocation(line: 514, column: 4, scope: !1187)
!1205 = !DILocation(line: 515, column: 17, scope: !1187)
!1206 = !DILocation(line: 515, column: 15, scope: !1187)
!1207 = !DILocation(line: 516, column: 34, scope: !1187)
!1208 = !DILocation(line: 516, column: 45, scope: !1187)
!1209 = !DILocation(line: 516, column: 44, scope: !1187)
!1210 = !DILocation(line: 516, column: 25, scope: !1187)
!1211 = !DILocation(line: 516, column: 59, scope: !1187)
!1212 = !DILocation(line: 516, column: 22, scope: !1187)
!1213 = !DILocation(line: 521, column: 8, scope: !1214)
!1214 = distinct !DILexicalBlock(scope: !1187, file: !25, line: 521, column: 8)
!1215 = !DILocation(line: 521, column: 8, scope: !1187)
!1216 = !DILocation(line: 522, column: 20, scope: !1217)
!1217 = distinct !DILexicalBlock(scope: !1214, file: !25, line: 521, column: 25)
!1218 = !DILocation(line: 522, column: 18, scope: !1217)
!1219 = !DILocation(line: 523, column: 4, scope: !1217)
!1220 = !DILocation(line: 528, column: 4, scope: !1187)
!1221 = !DILocation(line: 529, column: 4, scope: !1187)
