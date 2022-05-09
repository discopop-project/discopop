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

@.str.1 = private unnamed_addr constant [7 x i8] c"n.addr\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@res = internal global i64 0, align 8, !dbg !0
@.str.5 = private unnamed_addr constant [4 x i8] c"res\00", align 1
@.str.6 = private unnamed_addr constant [18 x i8] c"bots_verbose_mode\00", align 1
@stdout = external dso_local global %struct._IO_FILE*, align 8
@.str.7 = private unnamed_addr constant [7 x i8] c"stdout\00", align 1
@.str = private unnamed_addr constant [33 x i8] c"Fibonacci result for %d is %lld\0A\00", align 1
@.str.48 = private unnamed_addr constant [11 x i8] c"error.addr\00", align 1
@.str.49 = private unnamed_addr constant [13 x i8] c"message.addr\00", align 1
@stderr = external dso_local global %struct._IO_FILE*, align 8
@.str.50 = private unnamed_addr constant [7 x i8] c"stderr\00", align 1
@.str.8 = private unnamed_addr constant [16 x i8] c"Error (%d): %s\0A\00", align 1
@.str.1.9 = private unnamed_addr constant [19 x i8] c"Unspecified error.\00", align 1
@.str.2.10 = private unnamed_addr constant [19 x i8] c"Not enough memory.\00", align 1
@.str.3.11 = private unnamed_addr constant [24 x i8] c"Unrecognized parameter.\00", align 1
@.str.4.12 = private unnamed_addr constant [20 x i8] c"Invalid error code.\00", align 1
@.str.51 = private unnamed_addr constant [13 x i8] c"warning.addr\00", align 1
@.str.5.13 = private unnamed_addr constant [18 x i8] c"Warning (%d): %s\0A\00", align 1
@.str.6.14 = private unnamed_addr constant [21 x i8] c"Unspecified warning.\00", align 1
@.str.7.15 = private unnamed_addr constant [22 x i8] c"Invalid warning code.\00", align 1
@.str.52 = private unnamed_addr constant [2 x i8] c"t\00", align 1
@.str.53 = private unnamed_addr constant [9 x i8] c"str.addr\00", align 1
@.str.8.16 = private unnamed_addr constant [15 x i8] c"%Y/%m/%d;%H:%M\00", align 1
@.str.54 = private unnamed_addr constant [6 x i8] c"ncpus\00", align 1
@.str.9 = private unnamed_addr constant [9 x i8] c"%s-%s;%d\00", align 1
@.str.55 = private unnamed_addr constant [8 x i8] c"loadavg\00", align 1
@.str.10 = private unnamed_addr constant [15 x i8] c"%.2f;%.2f;%.2f\00", align 1
@.str.11 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.56 = private unnamed_addr constant [12 x i8] c"bots_result\00", align 1
@.str.12 = private unnamed_addr constant [4 x i8] c"n/a\00", align 1
@.str.13 = private unnamed_addr constant [11 x i8] c"successful\00", align 1
@.str.14 = private unnamed_addr constant [13 x i8] c"UNSUCCESSFUL\00", align 1
@.str.15 = private unnamed_addr constant [14 x i8] c"Not requested\00", align 1
@.str.16 = private unnamed_addr constant [6 x i8] c"error\00", align 1
@.str.57 = private unnamed_addr constant [18 x i8] c"bots_time_program\00", align 1
@.str.17 = private unnamed_addr constant [3 x i8] c"%f\00", align 1
@.str.58 = private unnamed_addr constant [21 x i8] c"bots_sequential_flag\00", align 1
@.str.59 = private unnamed_addr constant [21 x i8] c"bots_time_sequential\00", align 1
@.str.18 = private unnamed_addr constant [6 x i8] c"%3.2f\00", align 1
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
@bots_sequential_flag = dso_local global i32 0, align 4, !dbg !14
@bots_check_flag = dso_local global i32 0, align 4, !dbg !22
@bots_verbose_mode = dso_local global i32 1, align 4, !dbg !25
@bots_result = dso_local global i32 3, align 4, !dbg !27
@bots_output_format = dso_local global i32 1, align 4, !dbg !29
@bots_print_header = dso_local global i32 0, align 4, !dbg !31
@bots_time_program = dso_local global double 0.000000e+00, align 8, !dbg !33
@bots_time_sequential = dso_local global double 0.000000e+00, align 8, !dbg !35
@bots_number_of_tasks = dso_local global i64 0, align 8, !dbg !37
@bots_arg_size = dso_local global i32 10, align 4, !dbg !40
@bots_execname = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !48
@bots_exec_date = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !56
@bots_exec_message = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !58
@bots_name = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !42
@bots_parameters = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !50
@bots_model = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !52
@bots_resources = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !54
@bots_comp_date = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !60
@bots_comp_message = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !62
@bots_cc = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !64
@bots_cflags = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !66
@bots_ld = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !68
@bots_ldflags = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !70
@bots_cutoff = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !72
@.str.26.61 = private unnamed_addr constant [7 x i8] c"stderr\00", align 1
@.str.64 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.1.65 = private unnamed_addr constant [22 x i8] c"Usage: %s -[options]\0A\00", align 1
@.str.2.66 = private unnamed_addr constant [20 x i8] c"Where options are:\0A\00", align 1
@.str.3.67 = private unnamed_addr constant [34 x i8] c"  -n <size>  : Number to compute\0A\00", align 1
@.str.4.68 = private unnamed_addr constant [49 x i8] c"  -e <str>   : Include 'str' execution message.\0A\00", align 1
@.str.5.69 = private unnamed_addr constant [49 x i8] c"  -v <level> : Set verbose level (default = 1).\0A\00", align 1
@.str.6.70 = private unnamed_addr constant [26 x i8] c"               0 - none.\0A\00", align 1
@.str.7.71 = private unnamed_addr constant [29 x i8] c"               1 - default.\0A\00", align 1
@.str.8.72 = private unnamed_addr constant [27 x i8] c"               2 - debug.\0A\00", align 1
@.str.9.73 = private unnamed_addr constant [54 x i8] c"  -o <value> : Set output format mode (default = 1).\0A\00", align 1
@.str.10.74 = private unnamed_addr constant [41 x i8] c"               0 - no benchmark output.\0A\00", align 1
@.str.11.75 = private unnamed_addr constant [42 x i8] c"               1 - detailed list format.\0A\00", align 1
@.str.12.76 = private unnamed_addr constant [41 x i8] c"               2 - detailed row format.\0A\00", align 1
@.str.13.77 = private unnamed_addr constant [42 x i8] c"               3 - abridged list format.\0A\00", align 1
@.str.14.78 = private unnamed_addr constant [41 x i8] c"               4 - abridged row format.\0A\00", align 1
@.str.15.79 = private unnamed_addr constant [70 x i8] c"  -z         : Print row header (if output format is a row variant).\0A\00", align 1
@.str.16.80 = private unnamed_addr constant [31 x i8] c"  -c         : Check mode ON.\0A\00", align 1
@.str.17.81 = private unnamed_addr constant [51 x i8] c"  -h         : Print program's usage (this help).\0A\00", align 1
@.str.27.82 = private unnamed_addr constant [10 x i8] c"argc.addr\00", align 1
@.str.28.83 = private unnamed_addr constant [10 x i8] c"argv.addr\00", align 1
@.str.18.84 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.29.85 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.30.86 = private unnamed_addr constant [16 x i8] c"bots_check_flag\00", align 1
@.str.31.87 = private unnamed_addr constant [14 x i8] c"bots_arg_size\00", align 1
@.str.32.88 = private unnamed_addr constant [19 x i8] c"bots_output_format\00", align 1
@.str.33.89 = private unnamed_addr constant [18 x i8] c"bots_verbose_mode\00", align 1
@.str.19.90 = private unnamed_addr constant [100 x i8] c"Error: Configure the suite using '--debug' option in order to use a verbose level greather than 1.\0A\00", align 1
@.str.34.91 = private unnamed_addr constant [18 x i8] c"bots_print_header\00", align 1
@.str.20.92 = private unnamed_addr constant [32 x i8] c"Error: Unrecognized parameter.\0A\00", align 1
@.str.21.93 = private unnamed_addr constant [10 x i8] c"Fibonacci\00", align 1
@.str.22.94 = private unnamed_addr constant [5 x i8] c"N=%d\00", align 1
@.str.23.95 = private unnamed_addr constant [7 x i8] c"Serial\00", align 1
@.str.24.96 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str.25.97 = private unnamed_addr constant [5 x i8] c"none\00", align 1
@.str.35.98 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.36.99 = private unnamed_addr constant [13 x i8] c"bots_t_start\00", align 1
@.str.37.100 = private unnamed_addr constant [11 x i8] c"bots_t_end\00", align 1
@.str.38.101 = private unnamed_addr constant [18 x i8] c"bots_time_program\00", align 1
@.str.39.102 = private unnamed_addr constant [12 x i8] c"bots_result\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i64 @fib(i32 %n) #0 !dbg !302 {
entry:
  call void @__dp_func_entry(i32 114714, i32 0)
  %retval = alloca i64, align 8
  %n.addr = alloca i32, align 4
  %x = alloca i64, align 8
  %y = alloca i64, align 8
  %0 = ptrtoint i32* %n.addr to i64
  call void @__dp_write(i32 114714, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 %n, i32* %n.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %n.addr, metadata !306, metadata !DIExpression()), !dbg !307
  call void @llvm.dbg.declare(metadata i64* %x, metadata !308, metadata !DIExpression()), !dbg !309
  call void @llvm.dbg.declare(metadata i64* %y, metadata !310, metadata !DIExpression()), !dbg !311
  %1 = ptrtoint i32* %n.addr to i64
  call void @__dp_read(i32 114717, i64 %1, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  %2 = load i32, i32* %n.addr, align 4, !dbg !312
  %cmp = icmp slt i32 %2, 2, !dbg !314
  br i1 %cmp, label %if.then, label %if.end, !dbg !315

if.then:                                          ; preds = %entry
  %3 = ptrtoint i32* %n.addr to i64
  call void @__dp_read(i32 114717, i64 %3, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  %4 = load i32, i32* %n.addr, align 4, !dbg !316
  %conv = sext i32 %4 to i64, !dbg !316
  %5 = ptrtoint i64* %retval to i64
  call void @__dp_write(i32 114717, i64 %5, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  store i64 %conv, i64* %retval, align 8, !dbg !317
  br label %return, !dbg !317

if.end:                                           ; preds = %entry
  %6 = ptrtoint i32* %n.addr to i64
  call void @__dp_read(i32 114719, i64 %6, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  %7 = load i32, i32* %n.addr, align 4, !dbg !318
  %sub = sub nsw i32 %7, 1, !dbg !319
  call void @__dp_call(i32 114719), !dbg !320
  %call = call i64 @fib(i32 %sub), !dbg !320
  %8 = ptrtoint i64* %x to i64
  call void @__dp_write(i32 114719, i64 %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i64 %call, i64* %x, align 8, !dbg !321
  %9 = ptrtoint i32* %n.addr to i64
  call void @__dp_read(i32 114720, i64 %9, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  %10 = load i32, i32* %n.addr, align 4, !dbg !322
  %sub1 = sub nsw i32 %10, 2, !dbg !323
  call void @__dp_call(i32 114720), !dbg !324
  %call2 = call i64 @fib(i32 %sub1), !dbg !324
  %11 = ptrtoint i64* %y to i64
  call void @__dp_write(i32 114720, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i64 %call2, i64* %y, align 8, !dbg !325
  %12 = ptrtoint i64* %x to i64
  call void @__dp_read(i32 114722, i64 %12, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %13 = load i64, i64* %x, align 8, !dbg !326
  %14 = ptrtoint i64* %y to i64
  call void @__dp_read(i32 114722, i64 %14, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %15 = load i64, i64* %y, align 8, !dbg !327
  %add = add nsw i64 %13, %15, !dbg !328
  %16 = ptrtoint i64* %retval to i64
  call void @__dp_write(i32 114722, i64 %16, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  store i64 %add, i64* %retval, align 8, !dbg !329
  br label %return, !dbg !329

return:                                           ; preds = %if.end, %if.then
  %17 = ptrtoint i64* %retval to i64
  call void @__dp_read(i32 114723, i64 %17, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  %18 = load i64, i64* %retval, align 8, !dbg !330
  call void @__dp_func_exit(i32 114723, i32 0), !dbg !330
  ret i64 %18, !dbg !330
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_call(i32)

declare void @__dp_func_exit(i32, i32)

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @fib0(i32 %n) #0 !dbg !331 {
entry:
  call void @__dp_func_entry(i32 114725, i32 0)
  %n.addr = alloca i32, align 4
  %0 = ptrtoint i32* %n.addr to i64
  call void @__dp_write(i32 114725, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 %n, i32* %n.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %n.addr, metadata !334, metadata !DIExpression()), !dbg !335
  %1 = ptrtoint i32* %n.addr to i64
  call void @__dp_read(i32 114727, i64 %1, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  %2 = load i32, i32* %n.addr, align 4, !dbg !336
  call void @__dp_call(i32 114727), !dbg !337
  %call = call i64 @fib(i32 %2), !dbg !337
  %3 = ptrtoint i64* @res to i64
  call void @__dp_write(i32 114727, i64 %3, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i32 0, i32 0))
  store i64 %call, i64* @res, align 8, !dbg !338
  %4 = ptrtoint i32* @bots_verbose_mode to i64
  call void @__dp_read(i32 114728, i64 %4, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.6, i32 0, i32 0))
  %5 = load i32, i32* @bots_verbose_mode, align 4, !dbg !339
  %cmp = icmp uge i32 %5, 1, !dbg !339
  br i1 %cmp, label %if.then, label %if.end, !dbg !342

if.then:                                          ; preds = %entry
  %6 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 114728, i64 %6, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.7, i32 0, i32 0))
  %7 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !343
  %8 = ptrtoint i32* %n.addr to i64
  call void @__dp_read(i32 114728, i64 %8, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  %9 = load i32, i32* %n.addr, align 4, !dbg !343
  %10 = ptrtoint i64* @res to i64
  call void @__dp_read(i32 114728, i64 %10, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i32 0, i32 0))
  %11 = load i64, i64* @res, align 8, !dbg !343
  call void @__dp_call(i32 114728), !dbg !343
  %call1 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %7, i8* getelementptr inbounds ([33 x i8], [33 x i8]* @.str, i32 0, i32 0), i32 %9, i64 %11), !dbg !343
  br label %if.end, !dbg !343

if.end:                                           ; preds = %if.then, %entry
  call void @__dp_func_exit(i32 114729, i32 0), !dbg !345
  ret void, !dbg !345
}

declare dso_local i32 @fprintf(%struct._IO_FILE*, i8*, ...) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_error(i32 %error, i8* %message) #0 !dbg !346 {
entry:
  call void @__dp_func_entry(i32 32803, i32 0)
  %error.addr = alloca i32, align 4
  %message.addr = alloca i8*, align 8
  %0 = ptrtoint i32* %error.addr to i64
  call void @__dp_write(i32 32803, i64 %0, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.48, i32 0, i32 0))
  store i32 %error, i32* %error.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %error.addr, metadata !350, metadata !DIExpression()), !dbg !351
  %1 = ptrtoint i8** %message.addr to i64
  call void @__dp_write(i32 32803, i64 %1, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.49, i32 0, i32 0))
  store i8* %message, i8** %message.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %message.addr, metadata !352, metadata !DIExpression()), !dbg !353
  %2 = ptrtoint i8** %message.addr to i64
  call void @__dp_read(i32 32805, i64 %2, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.49, i32 0, i32 0))
  %3 = load i8*, i8** %message.addr, align 8, !dbg !354
  %cmp = icmp eq i8* %3, null, !dbg !356
  br i1 %cmp, label %if.then, label %if.else, !dbg !357

if.then:                                          ; preds = %entry
  %4 = ptrtoint i32* %error.addr to i64
  call void @__dp_read(i32 32807, i64 %4, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.48, i32 0, i32 0))
  %5 = load i32, i32* %error.addr, align 4, !dbg !358
  switch i32 %5, label %sw.default [
    i32 0, label %sw.bb
    i32 1, label %sw.bb1
    i32 2, label %sw.bb3
  ], !dbg !360

sw.bb:                                            ; preds = %if.then
  %6 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 32810, i64 %6, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.50, i32 0, i32 0))
  %7 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !361
  %8 = ptrtoint i32* %error.addr to i64
  call void @__dp_read(i32 32810, i64 %8, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.48, i32 0, i32 0))
  %9 = load i32, i32* %error.addr, align 4, !dbg !363
  call void @__dp_call(i32 32810), !dbg !364
  %call = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %7, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.8, i32 0, i32 0), i32 %9, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.1.9, i32 0, i32 0)), !dbg !364
  br label %sw.epilog, !dbg !365

sw.bb1:                                           ; preds = %if.then
  %10 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 32813, i64 %10, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.50, i32 0, i32 0))
  %11 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !366
  %12 = ptrtoint i32* %error.addr to i64
  call void @__dp_read(i32 32813, i64 %12, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.48, i32 0, i32 0))
  %13 = load i32, i32* %error.addr, align 4, !dbg !367
  call void @__dp_call(i32 32813), !dbg !368
  %call2 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %11, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.8, i32 0, i32 0), i32 %13, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.2.10, i32 0, i32 0)), !dbg !368
  br label %sw.epilog, !dbg !369

sw.bb3:                                           ; preds = %if.then
  %14 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 32816, i64 %14, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.50, i32 0, i32 0))
  %15 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !370
  %16 = ptrtoint i32* %error.addr to i64
  call void @__dp_read(i32 32816, i64 %16, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.48, i32 0, i32 0))
  %17 = load i32, i32* %error.addr, align 4, !dbg !371
  call void @__dp_call(i32 32816), !dbg !372
  %call4 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %15, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.8, i32 0, i32 0), i32 %17, i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.3.11, i32 0, i32 0)), !dbg !372
  call void @__dp_call(i32 32817), !dbg !373
  call void @bots_print_usage(), !dbg !373
  br label %sw.epilog, !dbg !374

sw.default:                                       ; preds = %if.then
  %18 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 32820, i64 %18, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.50, i32 0, i32 0))
  %19 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !375
  %20 = ptrtoint i32* %error.addr to i64
  call void @__dp_read(i32 32820, i64 %20, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.48, i32 0, i32 0))
  %21 = load i32, i32* %error.addr, align 4, !dbg !376
  call void @__dp_call(i32 32820), !dbg !377
  %call5 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %19, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.8, i32 0, i32 0), i32 %21, i8* getelementptr inbounds ([20 x i8], [20 x i8]* @.str.4.12, i32 0, i32 0)), !dbg !377
  br label %sw.epilog, !dbg !378

sw.epilog:                                        ; preds = %sw.default, %sw.bb3, %sw.bb1, %sw.bb
  br label %if.end, !dbg !379

if.else:                                          ; preds = %entry
  %22 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 32824, i64 %22, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.50, i32 0, i32 0))
  %23 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !380
  %24 = ptrtoint i32* %error.addr to i64
  call void @__dp_read(i32 32824, i64 %24, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.48, i32 0, i32 0))
  %25 = load i32, i32* %error.addr, align 4, !dbg !381
  %26 = ptrtoint i8** %message.addr to i64
  call void @__dp_read(i32 32824, i64 %26, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.49, i32 0, i32 0))
  %27 = load i8*, i8** %message.addr, align 8, !dbg !382
  call void @__dp_call(i32 32824), !dbg !383
  %call6 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %23, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.8, i32 0, i32 0), i32 %25, i8* %27), !dbg !383
  br label %if.end

if.end:                                           ; preds = %if.else, %sw.epilog
  %28 = ptrtoint i32* %error.addr to i64
  call void @__dp_read(i32 32825, i64 %28, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.48, i32 0, i32 0))
  %29 = load i32, i32* %error.addr, align 4, !dbg !384
  %add = add nsw i32 100, %29, !dbg !385
  call void @__dp_finalize(i32 32825), !dbg !386
  call void @exit(i32 %add) #6, !dbg !386
  unreachable, !dbg !386

return:                                           ; No predecessors!
  call void @__dp_func_exit(i32 32826, i32 0), !dbg !387
  ret void, !dbg !387
}

declare void @__dp_finalize(i32)

; Function Attrs: noreturn nounwind
declare dso_local void @exit(i32) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_warning(i32 %warning, i8* %message) #0 !dbg !388 {
entry:
  call void @__dp_func_entry(i32 32829, i32 0)
  %warning.addr = alloca i32, align 4
  %message.addr = alloca i8*, align 8
  %0 = ptrtoint i32* %warning.addr to i64
  call void @__dp_write(i32 32829, i64 %0, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.51, i32 0, i32 0))
  store i32 %warning, i32* %warning.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %warning.addr, metadata !389, metadata !DIExpression()), !dbg !390
  %1 = ptrtoint i8** %message.addr to i64
  call void @__dp_write(i32 32829, i64 %1, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.49, i32 0, i32 0))
  store i8* %message, i8** %message.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %message.addr, metadata !391, metadata !DIExpression()), !dbg !392
  %2 = ptrtoint i8** %message.addr to i64
  call void @__dp_read(i32 32831, i64 %2, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.49, i32 0, i32 0))
  %3 = load i8*, i8** %message.addr, align 8, !dbg !393
  %cmp = icmp eq i8* %3, null, !dbg !395
  br i1 %cmp, label %if.then, label %if.else, !dbg !396

if.then:                                          ; preds = %entry
  %4 = ptrtoint i32* %warning.addr to i64
  call void @__dp_read(i32 32833, i64 %4, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.51, i32 0, i32 0))
  %5 = load i32, i32* %warning.addr, align 4, !dbg !397
  switch i32 %5, label %sw.default [
    i32 0, label %sw.bb
  ], !dbg !399

sw.bb:                                            ; preds = %if.then
  %6 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 32836, i64 %6, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.50, i32 0, i32 0))
  %7 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !400
  %8 = ptrtoint i32* %warning.addr to i64
  call void @__dp_read(i32 32836, i64 %8, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.51, i32 0, i32 0))
  %9 = load i32, i32* %warning.addr, align 4, !dbg !402
  call void @__dp_call(i32 32836), !dbg !403
  %call = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %7, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.5.13, i32 0, i32 0), i32 %9, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.6.14, i32 0, i32 0)), !dbg !403
  br label %sw.epilog, !dbg !404

sw.default:                                       ; preds = %if.then
  %10 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 32839, i64 %10, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.50, i32 0, i32 0))
  %11 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !405
  %12 = ptrtoint i32* %warning.addr to i64
  call void @__dp_read(i32 32839, i64 %12, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.51, i32 0, i32 0))
  %13 = load i32, i32* %warning.addr, align 4, !dbg !406
  call void @__dp_call(i32 32839), !dbg !407
  %call1 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %11, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.5.13, i32 0, i32 0), i32 %13, i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.7.15, i32 0, i32 0)), !dbg !407
  br label %sw.epilog, !dbg !408

sw.epilog:                                        ; preds = %sw.default, %sw.bb
  br label %if.end, !dbg !409

if.else:                                          ; preds = %entry
  %14 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 32843, i64 %14, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.50, i32 0, i32 0))
  %15 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !410
  %16 = ptrtoint i32* %warning.addr to i64
  call void @__dp_read(i32 32843, i64 %16, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.51, i32 0, i32 0))
  %17 = load i32, i32* %warning.addr, align 4, !dbg !411
  %18 = ptrtoint i8** %message.addr to i64
  call void @__dp_read(i32 32843, i64 %18, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.49, i32 0, i32 0))
  %19 = load i8*, i8** %message.addr, align 8, !dbg !412
  call void @__dp_call(i32 32843), !dbg !413
  %call2 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %15, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.5.13, i32 0, i32 0), i32 %17, i8* %19), !dbg !413
  br label %if.end

if.end:                                           ; preds = %if.else, %sw.epilog
  call void @__dp_func_exit(i32 32844, i32 0), !dbg !414
  ret void, !dbg !414
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i64 @bots_usecs() #0 !dbg !415 {
entry:
  call void @__dp_func_entry(i32 32846, i32 0)
  %t = alloca %struct.timeval, align 8
  call void @llvm.dbg.declare(metadata %struct.timeval* %t, metadata !419, metadata !DIExpression()), !dbg !428
  call void @__dp_call(i32 32849), !dbg !429
  %call = call i32 @gettimeofday(%struct.timeval* %t, i8* null) #7, !dbg !429
  %tv_sec = getelementptr inbounds %struct.timeval, %struct.timeval* %t, i32 0, i32 0, !dbg !430
  %0 = ptrtoint i64* %tv_sec to i64
  call void @__dp_read(i32 32850, i64 %0, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.52, i32 0, i32 0))
  %1 = load i64, i64* %tv_sec, align 8, !dbg !430
  %mul = mul nsw i64 %1, 1000000, !dbg !431
  %tv_usec = getelementptr inbounds %struct.timeval, %struct.timeval* %t, i32 0, i32 1, !dbg !432
  %2 = ptrtoint i64* %tv_usec to i64
  call void @__dp_read(i32 32850, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.52, i32 0, i32 0))
  %3 = load i64, i64* %tv_usec, align 8, !dbg !432
  %add = add nsw i64 %mul, %3, !dbg !433
  call void @__dp_func_exit(i32 32850, i32 0), !dbg !434
  ret i64 %add, !dbg !434
}

; Function Attrs: nounwind
declare dso_local i32 @gettimeofday(%struct.timeval*, i8*) #4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_get_date(i8* %str) #0 !dbg !435 {
entry:
  call void @__dp_func_entry(i32 32854, i32 0)
  %str.addr = alloca i8*, align 8
  %now = alloca i64, align 8
  %0 = ptrtoint i8** %str.addr to i64
  call void @__dp_write(i32 32854, i64 %0, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.53, i32 0, i32 0))
  store i8* %str, i8** %str.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %str.addr, metadata !438, metadata !DIExpression()), !dbg !439
  call void @llvm.dbg.declare(metadata i64* %now, metadata !440, metadata !DIExpression()), !dbg !443
  call void @__dp_call(i32 32857), !dbg !444
  %call = call i64 @time(i64* %now) #7, !dbg !444
  %1 = ptrtoint i8** %str.addr to i64
  call void @__dp_read(i32 32858, i64 %1, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.53, i32 0, i32 0))
  %2 = load i8*, i8** %str.addr, align 8, !dbg !445
  call void @__dp_call(i32 32858), !dbg !446
  %call1 = call %struct.tm* @gmtime(i64* %now) #7, !dbg !446
  call void @__dp_call(i32 32858), !dbg !447
  %call2 = call i64 @strftime(i8* %2, i64 32, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.8.16, i32 0, i32 0), %struct.tm* %call1) #7, !dbg !447
  call void @__dp_func_exit(i32 32859, i32 0), !dbg !448
  ret void, !dbg !448
}

; Function Attrs: nounwind
declare dso_local i64 @time(i64*) #4

; Function Attrs: nounwind
declare dso_local %struct.tm* @gmtime(i64*) #4

; Function Attrs: nounwind
declare dso_local i64 @strftime(i8*, i64, i8*, %struct.tm*) #4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_get_architecture(i8* %str) #0 !dbg !449 {
entry:
  call void @__dp_func_entry(i32 32861, i32 0)
  %str.addr = alloca i8*, align 8
  %ncpus = alloca i32, align 4
  %architecture = alloca %struct.utsname, align 1
  %0 = ptrtoint i8** %str.addr to i64
  call void @__dp_write(i32 32861, i64 %0, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.53, i32 0, i32 0))
  store i8* %str, i8** %str.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %str.addr, metadata !450, metadata !DIExpression()), !dbg !451
  call void @llvm.dbg.declare(metadata i32* %ncpus, metadata !452, metadata !DIExpression()), !dbg !453
  call void @__dp_call(i32 32863), !dbg !454
  %call = call i64 @sysconf(i32 83) #7, !dbg !454
  %conv = trunc i64 %call to i32, !dbg !454
  %1 = ptrtoint i32* %ncpus to i64
  call void @__dp_write(i32 32863, i64 %1, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.54, i32 0, i32 0))
  store i32 %conv, i32* %ncpus, align 4, !dbg !453
  call void @llvm.dbg.declare(metadata %struct.utsname* %architecture, metadata !455, metadata !DIExpression()), !dbg !468
  call void @__dp_call(i32 32866), !dbg !469
  %call1 = call i32 @uname(%struct.utsname* %architecture) #7, !dbg !469
  %2 = ptrtoint i8** %str.addr to i64
  call void @__dp_read(i32 32867, i64 %2, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.53, i32 0, i32 0))
  %3 = load i8*, i8** %str.addr, align 8, !dbg !470
  %sysname = getelementptr inbounds %struct.utsname, %struct.utsname* %architecture, i32 0, i32 0, !dbg !471
  %arraydecay = getelementptr inbounds [65 x i8], [65 x i8]* %sysname, i32 0, i32 0, !dbg !472
  %machine = getelementptr inbounds %struct.utsname, %struct.utsname* %architecture, i32 0, i32 4, !dbg !473
  %arraydecay2 = getelementptr inbounds [65 x i8], [65 x i8]* %machine, i32 0, i32 0, !dbg !474
  %4 = ptrtoint i32* %ncpus to i64
  call void @__dp_read(i32 32867, i64 %4, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.54, i32 0, i32 0))
  %5 = load i32, i32* %ncpus, align 4, !dbg !475
  call void @__dp_call(i32 32867), !dbg !476
  %call3 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* %3, i64 256, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.9, i32 0, i32 0), i8* %arraydecay, i8* %arraydecay2, i32 %5) #7, !dbg !476
  call void @__dp_func_exit(i32 32868, i32 0), !dbg !477
  ret void, !dbg !477
}

; Function Attrs: nounwind
declare dso_local i64 @sysconf(i32) #4

; Function Attrs: nounwind
declare dso_local i32 @uname(%struct.utsname*) #4

; Function Attrs: nounwind
declare dso_local i32 @snprintf(i8*, i64, i8*, ...) #4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_get_load_average(i8* %str) #0 !dbg !478 {
entry:
  call void @__dp_func_entry(i32 32872, i32 0)
  %str.addr = alloca i8*, align 8
  %loadavg = alloca [3 x double], align 16
  %0 = ptrtoint i8** %str.addr to i64
  call void @__dp_write(i32 32872, i64 %0, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.53, i32 0, i32 0))
  store i8* %str, i8** %str.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %str.addr, metadata !479, metadata !DIExpression()), !dbg !480
  call void @llvm.dbg.declare(metadata [3 x double]* %loadavg, metadata !481, metadata !DIExpression()), !dbg !485
  %arraydecay = getelementptr inbounds [3 x double], [3 x double]* %loadavg, i32 0, i32 0, !dbg !486
  call void @__dp_call(i32 32875), !dbg !487
  %call = call i32 @getloadavg(double* %arraydecay, i32 3) #7, !dbg !487
  %1 = ptrtoint i8** %str.addr to i64
  call void @__dp_read(i32 32876, i64 %1, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.53, i32 0, i32 0))
  %2 = load i8*, i8** %str.addr, align 8, !dbg !488
  %arrayidx = getelementptr inbounds [3 x double], [3 x double]* %loadavg, i64 0, i64 0, !dbg !489
  %3 = ptrtoint double* %arrayidx to i64
  call void @__dp_read(i32 32876, i64 %3, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.55, i32 0, i32 0))
  %4 = load double, double* %arrayidx, align 16, !dbg !489
  %arrayidx1 = getelementptr inbounds [3 x double], [3 x double]* %loadavg, i64 0, i64 1, !dbg !490
  %5 = ptrtoint double* %arrayidx1 to i64
  call void @__dp_read(i32 32876, i64 %5, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.55, i32 0, i32 0))
  %6 = load double, double* %arrayidx1, align 8, !dbg !490
  %arrayidx2 = getelementptr inbounds [3 x double], [3 x double]* %loadavg, i64 0, i64 2, !dbg !491
  %7 = ptrtoint double* %arrayidx2 to i64
  call void @__dp_read(i32 32876, i64 %7, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.55, i32 0, i32 0))
  %8 = load double, double* %arrayidx2, align 16, !dbg !491
  call void @__dp_call(i32 32876), !dbg !492
  %call3 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* %2, i64 256, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.10, i32 0, i32 0), double %4, double %6, double %8) #7, !dbg !492
  call void @__dp_func_exit(i32 32877, i32 0), !dbg !493
  ret void, !dbg !493
}

; Function Attrs: nounwind
declare dso_local i32 @getloadavg(double*, i32) #4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_print_results() #0 !dbg !494 {
entry:
  call void @__dp_func_entry(i32 32883, i32 0)
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
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_name, metadata !497, metadata !DIExpression()), !dbg !498
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_parameters, metadata !499, metadata !DIExpression()), !dbg !500
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_model, metadata !501, metadata !DIExpression()), !dbg !502
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_resources, metadata !503, metadata !DIExpression()), !dbg !504
  call void @llvm.dbg.declare(metadata [15 x i8]* %str_result, metadata !505, metadata !DIExpression()), !dbg !509
  call void @llvm.dbg.declare(metadata [15 x i8]* %str_time_program, metadata !510, metadata !DIExpression()), !dbg !511
  call void @llvm.dbg.declare(metadata [15 x i8]* %str_time_sequential, metadata !512, metadata !DIExpression()), !dbg !513
  call void @llvm.dbg.declare(metadata [15 x i8]* %str_speed_up, metadata !514, metadata !DIExpression()), !dbg !515
  call void @llvm.dbg.declare(metadata [15 x i8]* %str_number_of_tasks, metadata !516, metadata !DIExpression()), !dbg !517
  call void @llvm.dbg.declare(metadata [15 x i8]* %str_number_of_tasks_per_second, metadata !518, metadata !DIExpression()), !dbg !519
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_exec_date, metadata !520, metadata !DIExpression()), !dbg !521
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_exec_message, metadata !522, metadata !DIExpression()), !dbg !523
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_architecture, metadata !524, metadata !DIExpression()), !dbg !525
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_load_avg, metadata !526, metadata !DIExpression()), !dbg !527
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_comp_date, metadata !528, metadata !DIExpression()), !dbg !529
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_comp_message, metadata !530, metadata !DIExpression()), !dbg !531
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_cc, metadata !532, metadata !DIExpression()), !dbg !533
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_cflags, metadata !534, metadata !DIExpression()), !dbg !535
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_ld, metadata !536, metadata !DIExpression()), !dbg !537
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_ldflags, metadata !538, metadata !DIExpression()), !dbg !539
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_cutoff, metadata !540, metadata !DIExpression()), !dbg !541
  %arraydecay = getelementptr inbounds [256 x i8], [256 x i8]* %str_name, i32 0, i32 0, !dbg !542
  call void @__dp_call(i32 32908), !dbg !543
  %call = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_name, i32 0, i32 0)) #7, !dbg !543
  %arraydecay1 = getelementptr inbounds [256 x i8], [256 x i8]* %str_parameters, i32 0, i32 0, !dbg !544
  call void @__dp_call(i32 32909), !dbg !545
  %call2 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay1, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_parameters, i32 0, i32 0)) #7, !dbg !545
  %arraydecay3 = getelementptr inbounds [256 x i8], [256 x i8]* %str_model, i32 0, i32 0, !dbg !546
  call void @__dp_call(i32 32910), !dbg !547
  %call4 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay3, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_model, i32 0, i32 0)) #7, !dbg !547
  %arraydecay5 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cutoff, i32 0, i32 0, !dbg !548
  call void @__dp_call(i32 32911), !dbg !549
  %call6 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay5, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_cutoff, i32 0, i32 0)) #7, !dbg !549
  %arraydecay7 = getelementptr inbounds [256 x i8], [256 x i8]* %str_resources, i32 0, i32 0, !dbg !550
  call void @__dp_call(i32 32912), !dbg !551
  %call8 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay7, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_resources, i32 0, i32 0)) #7, !dbg !551
  %0 = ptrtoint i32* @bots_result to i64
  call void @__dp_read(i32 32913, i64 %0, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.56, i32 0, i32 0))
  %1 = load i32, i32* @bots_result, align 4, !dbg !552
  switch i32 %1, label %sw.default [
    i32 0, label %sw.bb
    i32 1, label %sw.bb11
    i32 2, label %sw.bb14
    i32 3, label %sw.bb17
  ], !dbg !553

sw.bb:                                            ; preds = %entry
  %arraydecay9 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !554
  call void @__dp_call(i32 32916), !dbg !556
  %call10 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay9, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.12, i32 0, i32 0)) #7, !dbg !556
  br label %sw.epilog, !dbg !557

sw.bb11:                                          ; preds = %entry
  %arraydecay12 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !558
  call void @__dp_call(i32 32919), !dbg !559
  %call13 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay12, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.13, i32 0, i32 0)) #7, !dbg !559
  br label %sw.epilog, !dbg !560

sw.bb14:                                          ; preds = %entry
  %arraydecay15 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !561
  call void @__dp_call(i32 32922), !dbg !562
  %call16 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay15, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.14, i32 0, i32 0)) #7, !dbg !562
  br label %sw.epilog, !dbg !563

sw.bb17:                                          ; preds = %entry
  %arraydecay18 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !564
  call void @__dp_call(i32 32925), !dbg !565
  %call19 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay18, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.15, i32 0, i32 0)) #7, !dbg !565
  br label %sw.epilog, !dbg !566

sw.default:                                       ; preds = %entry
  %arraydecay20 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !567
  call void @__dp_call(i32 32928), !dbg !568
  %call21 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay20, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.16, i32 0, i32 0)) #7, !dbg !568
  br label %sw.epilog, !dbg !569

sw.epilog:                                        ; preds = %sw.default, %sw.bb17, %sw.bb14, %sw.bb11, %sw.bb
  %arraydecay22 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_program, i32 0, i32 0, !dbg !570
  %2 = ptrtoint double* @bots_time_program to i64
  call void @__dp_read(i32 32931, i64 %2, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.57, i32 0, i32 0))
  %3 = load double, double* @bots_time_program, align 8, !dbg !571
  call void @__dp_call(i32 32931), !dbg !572
  %call23 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay22, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.17, i32 0, i32 0), double %3) #7, !dbg !572
  %4 = ptrtoint i32* @bots_sequential_flag to i64
  call void @__dp_read(i32 32932, i64 %4, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.58, i32 0, i32 0))
  %5 = load i32, i32* @bots_sequential_flag, align 4, !dbg !573
  %tobool = icmp ne i32 %5, 0, !dbg !573
  br i1 %tobool, label %if.then, label %if.else, !dbg !575

if.then:                                          ; preds = %sw.epilog
  %arraydecay24 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_sequential, i32 0, i32 0, !dbg !576
  %6 = ptrtoint double* @bots_time_sequential to i64
  call void @__dp_read(i32 32932, i64 %6, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.59, i32 0, i32 0))
  %7 = load double, double* @bots_time_sequential, align 8, !dbg !577
  call void @__dp_call(i32 32932), !dbg !578
  %call25 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay24, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.17, i32 0, i32 0), double %7) #7, !dbg !578
  br label %if.end, !dbg !578

if.else:                                          ; preds = %sw.epilog
  %arraydecay26 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_sequential, i32 0, i32 0, !dbg !579
  call void @__dp_call(i32 32933), !dbg !580
  %call27 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay26, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.12, i32 0, i32 0)) #7, !dbg !580
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %8 = ptrtoint i32* @bots_sequential_flag to i64
  call void @__dp_read(i32 32934, i64 %8, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.58, i32 0, i32 0))
  %9 = load i32, i32* @bots_sequential_flag, align 4, !dbg !581
  %tobool28 = icmp ne i32 %9, 0, !dbg !581
  br i1 %tobool28, label %if.then29, label %if.else32, !dbg !583

if.then29:                                        ; preds = %if.end
  %arraydecay30 = getelementptr inbounds [15 x i8], [15 x i8]* %str_speed_up, i32 0, i32 0, !dbg !584
  %10 = ptrtoint double* @bots_time_sequential to i64
  call void @__dp_read(i32 32935, i64 %10, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.59, i32 0, i32 0))
  %11 = load double, double* @bots_time_sequential, align 8, !dbg !585
  %12 = ptrtoint double* @bots_time_program to i64
  call void @__dp_read(i32 32935, i64 %12, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.57, i32 0, i32 0))
  %13 = load double, double* @bots_time_program, align 8, !dbg !586
  %div = fdiv double %11, %13, !dbg !587
  call void @__dp_call(i32 32935), !dbg !588
  %call31 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay30, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.18, i32 0, i32 0), double %div) #7, !dbg !588
  br label %if.end35, !dbg !588

if.else32:                                        ; preds = %if.end
  %arraydecay33 = getelementptr inbounds [15 x i8], [15 x i8]* %str_speed_up, i32 0, i32 0, !dbg !589
  call void @__dp_call(i32 32936), !dbg !590
  %call34 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay33, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.12, i32 0, i32 0)) #7, !dbg !590
  br label %if.end35

if.end35:                                         ; preds = %if.else32, %if.then29
  %arraydecay36 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks, i32 0, i32 0, !dbg !591
  %14 = ptrtoint i64* @bots_number_of_tasks to i64
  call void @__dp_read(i32 32938, i64 %14, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.60, i32 0, i32 0))
  %15 = load i64, i64* @bots_number_of_tasks, align 8, !dbg !592
  %conv = uitofp i64 %15 to float, !dbg !593
  %conv37 = fpext float %conv to double, !dbg !593
  call void @__dp_call(i32 32938), !dbg !594
  %call38 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay36, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.18, i32 0, i32 0), double %conv37) #7, !dbg !594
  %arraydecay39 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks_per_second, i32 0, i32 0, !dbg !595
  %16 = ptrtoint i64* @bots_number_of_tasks to i64
  call void @__dp_read(i32 32939, i64 %16, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.60, i32 0, i32 0))
  %17 = load i64, i64* @bots_number_of_tasks, align 8, !dbg !596
  %conv40 = uitofp i64 %17 to float, !dbg !597
  %conv41 = fpext float %conv40 to double, !dbg !597
  %18 = ptrtoint double* @bots_time_program to i64
  call void @__dp_read(i32 32939, i64 %18, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.57, i32 0, i32 0))
  %19 = load double, double* @bots_time_program, align 8, !dbg !598
  %div42 = fdiv double %conv41, %19, !dbg !599
  call void @__dp_call(i32 32939), !dbg !600
  %call43 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay39, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.18, i32 0, i32 0), double %div42) #7, !dbg !600
  %arraydecay44 = getelementptr inbounds [256 x i8], [256 x i8]* %str_exec_date, i32 0, i32 0, !dbg !601
  call void @__dp_call(i32 32941), !dbg !602
  %call45 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay44, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_exec_date, i32 0, i32 0)) #7, !dbg !602
  %arraydecay46 = getelementptr inbounds [256 x i8], [256 x i8]* %str_exec_message, i32 0, i32 0, !dbg !603
  call void @__dp_call(i32 32942), !dbg !604
  %call47 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay46, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_exec_message, i32 0, i32 0)) #7, !dbg !604
  %arraydecay48 = getelementptr inbounds [256 x i8], [256 x i8]* %str_architecture, i32 0, i32 0, !dbg !605
  call void @__dp_call(i32 32943), !dbg !606
  call void @bots_get_architecture(i8* %arraydecay48), !dbg !606
  %arraydecay49 = getelementptr inbounds [256 x i8], [256 x i8]* %str_load_avg, i32 0, i32 0, !dbg !607
  call void @__dp_call(i32 32944), !dbg !608
  call void @bots_get_load_average(i8* %arraydecay49), !dbg !608
  %arraydecay50 = getelementptr inbounds [256 x i8], [256 x i8]* %str_comp_date, i32 0, i32 0, !dbg !609
  call void @__dp_call(i32 32945), !dbg !610
  %call51 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay50, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_comp_date, i32 0, i32 0)) #7, !dbg !610
  %arraydecay52 = getelementptr inbounds [256 x i8], [256 x i8]* %str_comp_message, i32 0, i32 0, !dbg !611
  call void @__dp_call(i32 32946), !dbg !612
  %call53 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay52, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_comp_message, i32 0, i32 0)) #7, !dbg !612
  %arraydecay54 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cc, i32 0, i32 0, !dbg !613
  call void @__dp_call(i32 32947), !dbg !614
  %call55 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay54, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_cc, i32 0, i32 0)) #7, !dbg !614
  %arraydecay56 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cflags, i32 0, i32 0, !dbg !615
  call void @__dp_call(i32 32948), !dbg !616
  %call57 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay56, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_cflags, i32 0, i32 0)) #7, !dbg !616
  %arraydecay58 = getelementptr inbounds [256 x i8], [256 x i8]* %str_ld, i32 0, i32 0, !dbg !617
  call void @__dp_call(i32 32949), !dbg !618
  %call59 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay58, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_ld, i32 0, i32 0)) #7, !dbg !618
  %arraydecay60 = getelementptr inbounds [256 x i8], [256 x i8]* %str_ldflags, i32 0, i32 0, !dbg !619
  call void @__dp_call(i32 32950), !dbg !620
  %call61 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay60, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_ldflags, i32 0, i32 0)) #7, !dbg !620
  %20 = ptrtoint i32* @bots_print_header to i64
  call void @__dp_read(i32 32952, i64 %20, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.61, i32 0, i32 0))
  %21 = load i32, i32* @bots_print_header, align 4, !dbg !621
  %tobool62 = icmp ne i32 %21, 0, !dbg !621
  br i1 %tobool62, label %if.then63, label %if.end73, !dbg !623

if.then63:                                        ; preds = %if.end35
  %22 = ptrtoint i32* @bots_output_format to i64
  call void @__dp_read(i32 32954, i64 %22, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.62, i32 0, i32 0))
  %23 = load i32, i32* @bots_output_format, align 4, !dbg !624
  switch i32 %23, label %sw.default71 [
    i32 0, label %sw.bb64
    i32 1, label %sw.bb65
    i32 2, label %sw.bb66
    i32 3, label %sw.bb68
    i32 4, label %sw.bb69
  ], !dbg !626

sw.bb64:                                          ; preds = %if.then63
  br label %sw.epilog72, !dbg !627

sw.bb65:                                          ; preds = %if.then63
  br label %sw.epilog72, !dbg !629

sw.bb66:                                          ; preds = %if.then63
  %24 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32961, i64 %24, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %25 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !630
  call void @__dp_call(i32 32961), !dbg !631
  %call67 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %25, i8* getelementptr inbounds ([238 x i8], [238 x i8]* @.str.19, i32 0, i32 0)), !dbg !631
  br label %sw.epilog72, !dbg !632

sw.bb68:                                          ; preds = %if.then63
  br label %sw.epilog72, !dbg !633

sw.bb69:                                          ; preds = %if.then63
  %26 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32972, i64 %26, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %27 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !634
  call void @__dp_call(i32 32972), !dbg !635
  %call70 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %27, i8* getelementptr inbounds ([94 x i8], [94 x i8]* @.str.20, i32 0, i32 0)), !dbg !635
  br label %sw.epilog72, !dbg !636

sw.default71:                                     ; preds = %if.then63
  br label %sw.epilog72, !dbg !637

sw.epilog72:                                      ; preds = %sw.default71, %sw.bb69, %sw.bb68, %sw.bb66, %sw.bb65, %sw.bb64
  br label %if.end73, !dbg !638

if.end73:                                         ; preds = %sw.epilog72, %if.end35
  %28 = ptrtoint i32* @bots_output_format to i64
  call void @__dp_read(i32 32983, i64 %28, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.62, i32 0, i32 0))
  %29 = load i32, i32* @bots_output_format, align 4, !dbg !639
  switch i32 %29, label %sw.default203 [
    i32 0, label %sw.bb74
    i32 1, label %sw.bb75
    i32 2, label %sw.bb126
    i32 3, label %sw.bb156
    i32 4, label %sw.bb187
  ], !dbg !640

sw.bb74:                                          ; preds = %if.end73
  br label %sw.epilog204, !dbg !641

sw.bb75:                                          ; preds = %if.end73
  %30 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32988, i64 %30, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %31 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !643
  call void @__dp_call(i32 32988), !dbg !644
  %call76 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %31, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.21, i32 0, i32 0)), !dbg !644
  %32 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32989, i64 %32, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %33 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !645
  %arraydecay77 = getelementptr inbounds [256 x i8], [256 x i8]* %str_name, i32 0, i32 0, !dbg !646
  call void @__dp_call(i32 32989), !dbg !647
  %call78 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %33, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.22, i32 0, i32 0), i8* %arraydecay77), !dbg !647
  %34 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32990, i64 %34, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %35 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !648
  %arraydecay79 = getelementptr inbounds [256 x i8], [256 x i8]* %str_parameters, i32 0, i32 0, !dbg !649
  call void @__dp_call(i32 32990), !dbg !650
  %call80 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %35, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.23, i32 0, i32 0), i8* %arraydecay79), !dbg !650
  %36 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32991, i64 %36, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %37 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !651
  %arraydecay81 = getelementptr inbounds [256 x i8], [256 x i8]* %str_model, i32 0, i32 0, !dbg !652
  call void @__dp_call(i32 32991), !dbg !653
  %call82 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %37, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.24, i32 0, i32 0), i8* %arraydecay81), !dbg !653
  %38 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32992, i64 %38, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %39 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !654
  %arraydecay83 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cutoff, i32 0, i32 0, !dbg !655
  call void @__dp_call(i32 32992), !dbg !656
  %call84 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %39, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.25, i32 0, i32 0), i8* %arraydecay83), !dbg !656
  %40 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32993, i64 %40, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %41 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !657
  %arraydecay85 = getelementptr inbounds [256 x i8], [256 x i8]* %str_resources, i32 0, i32 0, !dbg !658
  call void @__dp_call(i32 32993), !dbg !659
  %call86 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %41, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.26, i32 0, i32 0), i8* %arraydecay85), !dbg !659
  %42 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32994, i64 %42, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %43 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !660
  %arraydecay87 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !661
  call void @__dp_call(i32 32994), !dbg !662
  %call88 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %43, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.27, i32 0, i32 0), i8* %arraydecay87), !dbg !662
  %44 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32996, i64 %44, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %45 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !663
  %arraydecay89 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_program, i32 0, i32 0, !dbg !664
  call void @__dp_call(i32 32996), !dbg !665
  %call90 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %45, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.28, i32 0, i32 0), i8* %arraydecay89), !dbg !665
  %46 = ptrtoint i32* @bots_sequential_flag to i64
  call void @__dp_read(i32 32997, i64 %46, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.58, i32 0, i32 0))
  %47 = load i32, i32* @bots_sequential_flag, align 4, !dbg !666
  %tobool91 = icmp ne i32 %47, 0, !dbg !666
  br i1 %tobool91, label %if.then92, label %if.end97, !dbg !668

if.then92:                                        ; preds = %sw.bb75
  %48 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32998, i64 %48, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %49 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !669
  %arraydecay93 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_sequential, i32 0, i32 0, !dbg !671
  call void @__dp_call(i32 32998), !dbg !672
  %call94 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %49, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.29, i32 0, i32 0), i8* %arraydecay93), !dbg !672
  %50 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32999, i64 %50, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %51 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !673
  %arraydecay95 = getelementptr inbounds [15 x i8], [15 x i8]* %str_speed_up, i32 0, i32 0, !dbg !674
  call void @__dp_call(i32 32999), !dbg !675
  %call96 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %51, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.30, i32 0, i32 0), i8* %arraydecay95), !dbg !675
  br label %if.end97, !dbg !676

if.end97:                                         ; preds = %if.then92, %sw.bb75
  %52 = ptrtoint i64* @bots_number_of_tasks to i64
  call void @__dp_read(i32 33002, i64 %52, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.60, i32 0, i32 0))
  %53 = load i64, i64* @bots_number_of_tasks, align 8, !dbg !677
  %cmp = icmp ugt i64 %53, 0, !dbg !679
  br i1 %cmp, label %if.then99, label %if.end104, !dbg !680

if.then99:                                        ; preds = %if.end97
  %54 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33003, i64 %54, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %55 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !681
  %arraydecay100 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks, i32 0, i32 0, !dbg !683
  call void @__dp_call(i32 33003), !dbg !684
  %call101 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %55, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.31, i32 0, i32 0), i8* %arraydecay100), !dbg !684
  %56 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33004, i64 %56, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %57 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !685
  %arraydecay102 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks_per_second, i32 0, i32 0, !dbg !686
  call void @__dp_call(i32 33004), !dbg !687
  %call103 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %57, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.32, i32 0, i32 0), i8* %arraydecay102), !dbg !687
  br label %if.end104, !dbg !688

if.end104:                                        ; preds = %if.then99, %if.end97
  %58 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33007, i64 %58, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %59 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !689
  %arraydecay105 = getelementptr inbounds [256 x i8], [256 x i8]* %str_exec_date, i32 0, i32 0, !dbg !690
  call void @__dp_call(i32 33007), !dbg !691
  %call106 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %59, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.33, i32 0, i32 0), i8* %arraydecay105), !dbg !691
  %60 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33008, i64 %60, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %61 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !692
  %arraydecay107 = getelementptr inbounds [256 x i8], [256 x i8]* %str_exec_message, i32 0, i32 0, !dbg !693
  call void @__dp_call(i32 33008), !dbg !694
  %call108 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %61, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.34, i32 0, i32 0), i8* %arraydecay107), !dbg !694
  %62 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33010, i64 %62, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %63 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !695
  %arraydecay109 = getelementptr inbounds [256 x i8], [256 x i8]* %str_architecture, i32 0, i32 0, !dbg !696
  call void @__dp_call(i32 33010), !dbg !697
  %call110 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %63, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.35, i32 0, i32 0), i8* %arraydecay109), !dbg !697
  %64 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33011, i64 %64, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %65 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !698
  %arraydecay111 = getelementptr inbounds [256 x i8], [256 x i8]* %str_load_avg, i32 0, i32 0, !dbg !699
  call void @__dp_call(i32 33011), !dbg !700
  %call112 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %65, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.36, i32 0, i32 0), i8* %arraydecay111), !dbg !700
  %66 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33013, i64 %66, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %67 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !701
  %arraydecay113 = getelementptr inbounds [256 x i8], [256 x i8]* %str_comp_date, i32 0, i32 0, !dbg !702
  call void @__dp_call(i32 33013), !dbg !703
  %call114 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %67, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.37, i32 0, i32 0), i8* %arraydecay113), !dbg !703
  %68 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33014, i64 %68, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %69 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !704
  %arraydecay115 = getelementptr inbounds [256 x i8], [256 x i8]* %str_comp_message, i32 0, i32 0, !dbg !705
  call void @__dp_call(i32 33014), !dbg !706
  %call116 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %69, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.38, i32 0, i32 0), i8* %arraydecay115), !dbg !706
  %70 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33016, i64 %70, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %71 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !707
  %arraydecay117 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cc, i32 0, i32 0, !dbg !708
  call void @__dp_call(i32 33016), !dbg !709
  %call118 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %71, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.39, i32 0, i32 0), i8* %arraydecay117), !dbg !709
  %72 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33017, i64 %72, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %73 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !710
  %arraydecay119 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cflags, i32 0, i32 0, !dbg !711
  call void @__dp_call(i32 33017), !dbg !712
  %call120 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %73, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.40, i32 0, i32 0), i8* %arraydecay119), !dbg !712
  %74 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33018, i64 %74, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %75 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !713
  %arraydecay121 = getelementptr inbounds [256 x i8], [256 x i8]* %str_ld, i32 0, i32 0, !dbg !714
  call void @__dp_call(i32 33018), !dbg !715
  %call122 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %75, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.41, i32 0, i32 0), i8* %arraydecay121), !dbg !715
  %76 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33019, i64 %76, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %77 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !716
  %arraydecay123 = getelementptr inbounds [256 x i8], [256 x i8]* %str_ldflags, i32 0, i32 0, !dbg !717
  call void @__dp_call(i32 33019), !dbg !718
  %call124 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %77, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.42, i32 0, i32 0), i8* %arraydecay123), !dbg !718
  %78 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33020, i64 %78, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %79 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !719
  call void @__dp_call(i32 33020), !dbg !720
  %call125 = call i32 @fflush(%struct._IO_FILE* %79), !dbg !720
  br label %sw.epilog204, !dbg !721

sw.bb126:                                         ; preds = %if.end73
  %80 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33023, i64 %80, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %81 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !722
  %arraydecay127 = getelementptr inbounds [256 x i8], [256 x i8]* %str_name, i32 0, i32 0, !dbg !723
  %arraydecay128 = getelementptr inbounds [256 x i8], [256 x i8]* %str_parameters, i32 0, i32 0, !dbg !724
  %arraydecay129 = getelementptr inbounds [256 x i8], [256 x i8]* %str_model, i32 0, i32 0, !dbg !725
  %arraydecay130 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cutoff, i32 0, i32 0, !dbg !726
  %arraydecay131 = getelementptr inbounds [256 x i8], [256 x i8]* %str_resources, i32 0, i32 0, !dbg !727
  %arraydecay132 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !728
  call void @__dp_call(i32 33023), !dbg !729
  %call133 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %81, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.43, i32 0, i32 0), i8* %arraydecay127, i8* %arraydecay128, i8* %arraydecay129, i8* %arraydecay130, i8* %arraydecay131, i8* %arraydecay132), !dbg !729
  %82 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33031, i64 %82, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %83 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !730
  %arraydecay134 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_program, i32 0, i32 0, !dbg !731
  %arraydecay135 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_sequential, i32 0, i32 0, !dbg !732
  %arraydecay136 = getelementptr inbounds [15 x i8], [15 x i8]* %str_speed_up, i32 0, i32 0, !dbg !733
  call void @__dp_call(i32 33031), !dbg !734
  %call137 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %83, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.44, i32 0, i32 0), i8* %arraydecay134, i8* %arraydecay135, i8* %arraydecay136), !dbg !734
  %84 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33036, i64 %84, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %85 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !735
  %arraydecay138 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks, i32 0, i32 0, !dbg !736
  %arraydecay139 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks_per_second, i32 0, i32 0, !dbg !737
  call void @__dp_call(i32 33036), !dbg !738
  %call140 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %85, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.45, i32 0, i32 0), i8* %arraydecay138, i8* %arraydecay139), !dbg !738
  %86 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33040, i64 %86, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %87 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !739
  %arraydecay141 = getelementptr inbounds [256 x i8], [256 x i8]* %str_exec_date, i32 0, i32 0, !dbg !740
  %arraydecay142 = getelementptr inbounds [256 x i8], [256 x i8]* %str_exec_message, i32 0, i32 0, !dbg !741
  call void @__dp_call(i32 33040), !dbg !742
  %call143 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %87, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.45, i32 0, i32 0), i8* %arraydecay141, i8* %arraydecay142), !dbg !742
  %88 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33044, i64 %88, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %89 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !743
  %arraydecay144 = getelementptr inbounds [256 x i8], [256 x i8]* %str_architecture, i32 0, i32 0, !dbg !744
  %arraydecay145 = getelementptr inbounds [256 x i8], [256 x i8]* %str_load_avg, i32 0, i32 0, !dbg !745
  call void @__dp_call(i32 33044), !dbg !746
  %call146 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %89, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.45, i32 0, i32 0), i8* %arraydecay144, i8* %arraydecay145), !dbg !746
  %90 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33048, i64 %90, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %91 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !747
  %arraydecay147 = getelementptr inbounds [256 x i8], [256 x i8]* %str_comp_date, i32 0, i32 0, !dbg !748
  %arraydecay148 = getelementptr inbounds [256 x i8], [256 x i8]* %str_comp_message, i32 0, i32 0, !dbg !749
  call void @__dp_call(i32 33048), !dbg !750
  %call149 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %91, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.45, i32 0, i32 0), i8* %arraydecay147, i8* %arraydecay148), !dbg !750
  %92 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33052, i64 %92, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %93 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !751
  %arraydecay150 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cc, i32 0, i32 0, !dbg !752
  %arraydecay151 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cflags, i32 0, i32 0, !dbg !753
  %arraydecay152 = getelementptr inbounds [256 x i8], [256 x i8]* %str_ld, i32 0, i32 0, !dbg !754
  %arraydecay153 = getelementptr inbounds [256 x i8], [256 x i8]* %str_ldflags, i32 0, i32 0, !dbg !755
  call void @__dp_call(i32 33052), !dbg !756
  %call154 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %93, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.46, i32 0, i32 0), i8* %arraydecay150, i8* %arraydecay151, i8* %arraydecay152, i8* %arraydecay153), !dbg !756
  %94 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33058, i64 %94, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %95 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !757
  call void @__dp_call(i32 33058), !dbg !758
  %call155 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %95, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.21, i32 0, i32 0)), !dbg !758
  br label %sw.epilog204, !dbg !759

sw.bb156:                                         ; preds = %if.end73
  %96 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33061, i64 %96, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %97 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !760
  call void @__dp_call(i32 33061), !dbg !761
  %call157 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %97, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.21, i32 0, i32 0)), !dbg !761
  %98 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33062, i64 %98, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %99 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !762
  %arraydecay158 = getelementptr inbounds [256 x i8], [256 x i8]* %str_name, i32 0, i32 0, !dbg !763
  call void @__dp_call(i32 33062), !dbg !764
  %call159 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %99, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.22, i32 0, i32 0), i8* %arraydecay158), !dbg !764
  %100 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33063, i64 %100, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %101 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !765
  %arraydecay160 = getelementptr inbounds [256 x i8], [256 x i8]* %str_parameters, i32 0, i32 0, !dbg !766
  call void @__dp_call(i32 33063), !dbg !767
  %call161 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %101, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.23, i32 0, i32 0), i8* %arraydecay160), !dbg !767
  %102 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33064, i64 %102, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %103 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !768
  %arraydecay162 = getelementptr inbounds [256 x i8], [256 x i8]* %str_model, i32 0, i32 0, !dbg !769
  call void @__dp_call(i32 33064), !dbg !770
  %call163 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %103, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.24, i32 0, i32 0), i8* %arraydecay162), !dbg !770
  %104 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33065, i64 %104, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %105 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !771
  %arraydecay164 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cutoff, i32 0, i32 0, !dbg !772
  call void @__dp_call(i32 33065), !dbg !773
  %call165 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %105, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.25, i32 0, i32 0), i8* %arraydecay164), !dbg !773
  %106 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33066, i64 %106, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %107 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !774
  %arraydecay166 = getelementptr inbounds [256 x i8], [256 x i8]* %str_resources, i32 0, i32 0, !dbg !775
  call void @__dp_call(i32 33066), !dbg !776
  %call167 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %107, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.26, i32 0, i32 0), i8* %arraydecay166), !dbg !776
  %108 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33067, i64 %108, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %109 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !777
  %arraydecay168 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !778
  call void @__dp_call(i32 33067), !dbg !779
  %call169 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %109, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.27, i32 0, i32 0), i8* %arraydecay168), !dbg !779
  %110 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33069, i64 %110, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %111 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !780
  %arraydecay170 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_program, i32 0, i32 0, !dbg !781
  call void @__dp_call(i32 33069), !dbg !782
  %call171 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %111, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.28, i32 0, i32 0), i8* %arraydecay170), !dbg !782
  %112 = ptrtoint i32* @bots_sequential_flag to i64
  call void @__dp_read(i32 33070, i64 %112, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.58, i32 0, i32 0))
  %113 = load i32, i32* @bots_sequential_flag, align 4, !dbg !783
  %tobool172 = icmp ne i32 %113, 0, !dbg !783
  br i1 %tobool172, label %if.then173, label %if.end178, !dbg !785

if.then173:                                       ; preds = %sw.bb156
  %114 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33071, i64 %114, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %115 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !786
  %arraydecay174 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_sequential, i32 0, i32 0, !dbg !788
  call void @__dp_call(i32 33071), !dbg !789
  %call175 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %115, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.29, i32 0, i32 0), i8* %arraydecay174), !dbg !789
  %116 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33072, i64 %116, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %117 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !790
  %arraydecay176 = getelementptr inbounds [15 x i8], [15 x i8]* %str_speed_up, i32 0, i32 0, !dbg !791
  call void @__dp_call(i32 33072), !dbg !792
  %call177 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %117, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.30, i32 0, i32 0), i8* %arraydecay176), !dbg !792
  br label %if.end178, !dbg !793

if.end178:                                        ; preds = %if.then173, %sw.bb156
  %118 = ptrtoint i64* @bots_number_of_tasks to i64
  call void @__dp_read(i32 33075, i64 %118, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.60, i32 0, i32 0))
  %119 = load i64, i64* @bots_number_of_tasks, align 8, !dbg !794
  %cmp179 = icmp ugt i64 %119, 0, !dbg !796
  br i1 %cmp179, label %if.then181, label %if.end186, !dbg !797

if.then181:                                       ; preds = %if.end178
  %120 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33076, i64 %120, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %121 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !798
  %arraydecay182 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks, i32 0, i32 0, !dbg !800
  call void @__dp_call(i32 33076), !dbg !801
  %call183 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %121, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.31, i32 0, i32 0), i8* %arraydecay182), !dbg !801
  %122 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33077, i64 %122, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %123 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !802
  %arraydecay184 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks_per_second, i32 0, i32 0, !dbg !803
  call void @__dp_call(i32 33077), !dbg !804
  %call185 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %123, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.32, i32 0, i32 0), i8* %arraydecay184), !dbg !804
  br label %if.end186, !dbg !805

if.end186:                                        ; preds = %if.then181, %if.end178
  br label %sw.epilog204, !dbg !806

sw.bb187:                                         ; preds = %if.end73
  %124 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33081, i64 %124, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %125 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !807
  %arraydecay188 = getelementptr inbounds [256 x i8], [256 x i8]* %str_name, i32 0, i32 0, !dbg !808
  %arraydecay189 = getelementptr inbounds [256 x i8], [256 x i8]* %str_parameters, i32 0, i32 0, !dbg !809
  %arraydecay190 = getelementptr inbounds [256 x i8], [256 x i8]* %str_model, i32 0, i32 0, !dbg !810
  %arraydecay191 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cutoff, i32 0, i32 0, !dbg !811
  %arraydecay192 = getelementptr inbounds [256 x i8], [256 x i8]* %str_resources, i32 0, i32 0, !dbg !812
  %arraydecay193 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !813
  call void @__dp_call(i32 33081), !dbg !814
  %call194 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %125, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.43, i32 0, i32 0), i8* %arraydecay188, i8* %arraydecay189, i8* %arraydecay190, i8* %arraydecay191, i8* %arraydecay192, i8* %arraydecay193), !dbg !814
  %126 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33089, i64 %126, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %127 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !815
  %arraydecay195 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_program, i32 0, i32 0, !dbg !816
  %arraydecay196 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_sequential, i32 0, i32 0, !dbg !817
  %arraydecay197 = getelementptr inbounds [15 x i8], [15 x i8]* %str_speed_up, i32 0, i32 0, !dbg !818
  call void @__dp_call(i32 33089), !dbg !819
  %call198 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %127, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.44, i32 0, i32 0), i8* %arraydecay195, i8* %arraydecay196, i8* %arraydecay197), !dbg !819
  %128 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33094, i64 %128, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %129 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !820
  %arraydecay199 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks, i32 0, i32 0, !dbg !821
  %arraydecay200 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks_per_second, i32 0, i32 0, !dbg !822
  call void @__dp_call(i32 33094), !dbg !823
  %call201 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %129, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.45, i32 0, i32 0), i8* %arraydecay199, i8* %arraydecay200), !dbg !823
  %130 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33098, i64 %130, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %131 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !824
  call void @__dp_call(i32 33098), !dbg !825
  %call202 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %131, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.21, i32 0, i32 0)), !dbg !825
  br label %sw.epilog204, !dbg !826

sw.default203:                                    ; preds = %if.end73
  call void @__dp_call(i32 33101), !dbg !827
  call void @bots_error(i32 0, i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.47, i32 0, i32 0)), !dbg !827
  br label %sw.epilog204, !dbg !828

sw.epilog204:                                     ; preds = %sw.default203, %sw.bb187, %if.end186, %sw.bb126, %if.end104, %sw.bb74
  call void @__dp_func_exit(i32 33104, i32 0), !dbg !829
  ret void, !dbg !829
}

; Function Attrs: nounwind
declare dso_local i32 @sprintf(i8*, i8*, ...) #4

declare dso_local i32 @fflush(%struct._IO_FILE*) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_print_usage() #0 !dbg !830 {
entry:
  call void @__dp_func_entry(i32 82133, i32 0), !dbg !831
  %0 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82133, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.61, i32 0, i32 0))
  %1 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !831
  call void @__dp_call(i32 82133), !dbg !832
  %call = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.64, i32 0, i32 0)), !dbg !832
  %2 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82134, i64 %2, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.61, i32 0, i32 0))
  %3 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !833
  call void @__dp_call(i32 82134), !dbg !834
  %call1 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.1.65, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_execname, i32 0, i32 0)), !dbg !834
  %4 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82135, i64 %4, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.61, i32 0, i32 0))
  %5 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !835
  call void @__dp_call(i32 82135), !dbg !836
  %call2 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.64, i32 0, i32 0)), !dbg !836
  %6 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82136, i64 %6, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.61, i32 0, i32 0))
  %7 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !837
  call void @__dp_call(i32 82136), !dbg !838
  %call3 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %7, i8* getelementptr inbounds ([20 x i8], [20 x i8]* @.str.2.66, i32 0, i32 0)), !dbg !838
  %8 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82141, i64 %8, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.61, i32 0, i32 0))
  %9 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !839
  call void @__dp_call(i32 82141), !dbg !840
  %call4 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %9, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.3.67, i32 0, i32 0)), !dbg !840
  %10 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82165, i64 %10, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.61, i32 0, i32 0))
  %11 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !841
  call void @__dp_call(i32 82165), !dbg !842
  %call5 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.64, i32 0, i32 0)), !dbg !842
  %12 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82166, i64 %12, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.61, i32 0, i32 0))
  %13 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !843
  call void @__dp_call(i32 82166), !dbg !844
  %call6 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %13, i8* getelementptr inbounds ([49 x i8], [49 x i8]* @.str.4.68, i32 0, i32 0)), !dbg !844
  %14 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82167, i64 %14, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.61, i32 0, i32 0))
  %15 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !845
  call void @__dp_call(i32 82167), !dbg !846
  %call7 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %15, i8* getelementptr inbounds ([49 x i8], [49 x i8]* @.str.5.69, i32 0, i32 0)), !dbg !846
  %16 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82168, i64 %16, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.61, i32 0, i32 0))
  %17 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !847
  call void @__dp_call(i32 82168), !dbg !848
  %call8 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %17, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.6.70, i32 0, i32 0)), !dbg !848
  %18 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82169, i64 %18, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.61, i32 0, i32 0))
  %19 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !849
  call void @__dp_call(i32 82169), !dbg !850
  %call9 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %19, i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str.7.71, i32 0, i32 0)), !dbg !850
  %20 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82170, i64 %20, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.61, i32 0, i32 0))
  %21 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !851
  call void @__dp_call(i32 82170), !dbg !852
  %call10 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %21, i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.8.72, i32 0, i32 0)), !dbg !852
  %22 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82171, i64 %22, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.61, i32 0, i32 0))
  %23 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !853
  call void @__dp_call(i32 82171), !dbg !854
  %call11 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %23, i8* getelementptr inbounds ([54 x i8], [54 x i8]* @.str.9.73, i32 0, i32 0)), !dbg !854
  %24 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82172, i64 %24, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.61, i32 0, i32 0))
  %25 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !855
  call void @__dp_call(i32 82172), !dbg !856
  %call12 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %25, i8* getelementptr inbounds ([41 x i8], [41 x i8]* @.str.10.74, i32 0, i32 0)), !dbg !856
  %26 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82173, i64 %26, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.61, i32 0, i32 0))
  %27 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !857
  call void @__dp_call(i32 82173), !dbg !858
  %call13 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %27, i8* getelementptr inbounds ([42 x i8], [42 x i8]* @.str.11.75, i32 0, i32 0)), !dbg !858
  %28 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82174, i64 %28, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.61, i32 0, i32 0))
  %29 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !859
  call void @__dp_call(i32 82174), !dbg !860
  %call14 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %29, i8* getelementptr inbounds ([41 x i8], [41 x i8]* @.str.12.76, i32 0, i32 0)), !dbg !860
  %30 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82175, i64 %30, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.61, i32 0, i32 0))
  %31 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !861
  call void @__dp_call(i32 82175), !dbg !862
  %call15 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %31, i8* getelementptr inbounds ([42 x i8], [42 x i8]* @.str.13.77, i32 0, i32 0)), !dbg !862
  %32 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82176, i64 %32, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.61, i32 0, i32 0))
  %33 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !863
  call void @__dp_call(i32 82176), !dbg !864
  %call16 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %33, i8* getelementptr inbounds ([41 x i8], [41 x i8]* @.str.14.78, i32 0, i32 0)), !dbg !864
  %34 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82177, i64 %34, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.61, i32 0, i32 0))
  %35 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !865
  call void @__dp_call(i32 82177), !dbg !866
  %call17 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %35, i8* getelementptr inbounds ([70 x i8], [70 x i8]* @.str.15.79, i32 0, i32 0)), !dbg !866
  %36 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82178, i64 %36, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.61, i32 0, i32 0))
  %37 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !867
  call void @__dp_call(i32 82178), !dbg !868
  %call18 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %37, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.64, i32 0, i32 0)), !dbg !868
  %38 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82185, i64 %38, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.61, i32 0, i32 0))
  %39 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !869
  call void @__dp_call(i32 82185), !dbg !870
  %call19 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %39, i8* getelementptr inbounds ([31 x i8], [31 x i8]* @.str.16.80, i32 0, i32 0)), !dbg !870
  %40 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82187, i64 %40, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.61, i32 0, i32 0))
  %41 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !871
  call void @__dp_call(i32 82187), !dbg !872
  %call20 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %41, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.64, i32 0, i32 0)), !dbg !872
  %42 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82188, i64 %42, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.61, i32 0, i32 0))
  %43 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !873
  call void @__dp_call(i32 82188), !dbg !874
  %call21 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %43, i8* getelementptr inbounds ([51 x i8], [51 x i8]* @.str.17.81, i32 0, i32 0)), !dbg !874
  %44 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82189, i64 %44, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.61, i32 0, i32 0))
  %45 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !875
  call void @__dp_call(i32 82189), !dbg !876
  %call22 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %45, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.64, i32 0, i32 0)), !dbg !876
  call void @__dp_func_exit(i32 82190, i32 0), !dbg !877
  ret void, !dbg !877
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_get_params_common(i32 %argc, i8** %argv) #0 !dbg !878 {
entry:
  call void @__dp_func_entry(i32 82195, i32 0)
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %0 = ptrtoint i32* %argc.addr to i64
  call void @__dp_write(i32 82195, i64 %0, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.82, i32 0, i32 0))
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !882, metadata !DIExpression()), !dbg !883
  %1 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_write(i32 82195, i64 %1, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !884, metadata !DIExpression()), !dbg !885
  call void @llvm.dbg.declare(metadata i32* %i, metadata !886, metadata !DIExpression()), !dbg !887
  %2 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82198, i64 %2, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %3 = load i8**, i8*** %argv.addr, align 8, !dbg !888
  %arrayidx = getelementptr inbounds i8*, i8** %3, i64 0, !dbg !888
  %4 = ptrtoint i8** %arrayidx to i64
  call void @__dp_read(i32 82198, i64 %4, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %5 = load i8*, i8** %arrayidx, align 8, !dbg !888
  call void @__dp_call(i32 82198), !dbg !889
  %call = call i8* @__xpg_basename(i8* %5) #7, !dbg !889
  call void @__dp_call(i32 82198), !dbg !890
  %call1 = call i8* @strcpy(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_execname, i32 0, i32 0), i8* %call) #7, !dbg !890
  call void @__dp_call(i32 82199), !dbg !891
  call void @bots_get_date(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_exec_date, i32 0, i32 0)), !dbg !891
  call void @__dp_call(i32 82200), !dbg !892
  %call2 = call i8* @strcpy(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_exec_message, i32 0, i32 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.18.84, i32 0, i32 0)) #7, !dbg !892
  %6 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 82201, i64 %6, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  store i32 1, i32* %i, align 4, !dbg !893
  br label %for.cond, !dbg !895

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 82201, i32 0)
  %7 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82201, i64 %7, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  %8 = load i32, i32* %i, align 4, !dbg !896
  %9 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 82201, i64 %9, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.82, i32 0, i32 0))
  %10 = load i32, i32* %argc.addr, align 4, !dbg !898
  %cmp = icmp slt i32 %8, %10, !dbg !899
  br i1 %cmp, label %for.body, label %for.end, !dbg !900

for.body:                                         ; preds = %for.cond
  %11 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82203, i64 %11, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %12 = load i8**, i8*** %argv.addr, align 8, !dbg !901
  %13 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82203, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  %14 = load i32, i32* %i, align 4, !dbg !904
  %idxprom = sext i32 %14 to i64, !dbg !901
  %arrayidx3 = getelementptr inbounds i8*, i8** %12, i64 %idxprom, !dbg !901
  %15 = ptrtoint i8** %arrayidx3 to i64
  call void @__dp_read(i32 82203, i64 %15, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %16 = load i8*, i8** %arrayidx3, align 8, !dbg !901
  %arrayidx4 = getelementptr inbounds i8, i8* %16, i64 0, !dbg !901
  %17 = ptrtoint i8* %arrayidx4 to i64
  call void @__dp_read(i32 82203, i64 %17, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %18 = load i8, i8* %arrayidx4, align 1, !dbg !901
  %conv = sext i8 %18 to i32, !dbg !901
  %cmp5 = icmp eq i32 %conv, 45, !dbg !905
  br i1 %cmp5, label %if.then, label %if.else, !dbg !906

if.then:                                          ; preds = %for.body
  %19 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82205, i64 %19, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %20 = load i8**, i8*** %argv.addr, align 8, !dbg !907
  %21 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82205, i64 %21, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  %22 = load i32, i32* %i, align 4, !dbg !909
  %idxprom7 = sext i32 %22 to i64, !dbg !907
  %arrayidx8 = getelementptr inbounds i8*, i8** %20, i64 %idxprom7, !dbg !907
  %23 = ptrtoint i8** %arrayidx8 to i64
  call void @__dp_read(i32 82205, i64 %23, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %24 = load i8*, i8** %arrayidx8, align 8, !dbg !907
  %arrayidx9 = getelementptr inbounds i8, i8* %24, i64 1, !dbg !907
  %25 = ptrtoint i8* %arrayidx9 to i64
  call void @__dp_read(i32 82205, i64 %25, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %26 = load i8, i8* %arrayidx9, align 1, !dbg !907
  %conv10 = sext i8 %26 to i32, !dbg !907
  switch i32 %conv10, label %sw.default [
    i32 99, label %sw.bb
    i32 101, label %sw.bb14
    i32 104, label %sw.bb24
    i32 110, label %sw.bb28
    i32 111, label %sw.bb40
    i32 118, label %sw.bb52
    i32 122, label %sw.bb69
  ], !dbg !910

sw.bb:                                            ; preds = %if.then
  %27 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82224, i64 %27, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %28 = load i8**, i8*** %argv.addr, align 8, !dbg !911
  %29 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82224, i64 %29, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  %30 = load i32, i32* %i, align 4, !dbg !913
  %idxprom11 = sext i32 %30 to i64, !dbg !911
  %arrayidx12 = getelementptr inbounds i8*, i8** %28, i64 %idxprom11, !dbg !911
  %31 = ptrtoint i8** %arrayidx12 to i64
  call void @__dp_read(i32 82224, i64 %31, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %32 = load i8*, i8** %arrayidx12, align 8, !dbg !911
  %arrayidx13 = getelementptr inbounds i8, i8* %32, i64 1, !dbg !911
  %33 = ptrtoint i8* %arrayidx13 to i64
  call void @__dp_write(i32 82224, i64 %33, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  store i8 42, i8* %arrayidx13, align 1, !dbg !914
  %34 = ptrtoint i32* @bots_check_flag to i64
  call void @__dp_write(i32 82228, i64 %34, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.30.86, i32 0, i32 0))
  store i32 1, i32* @bots_check_flag, align 4, !dbg !915
  br label %sw.epilog, !dbg !916

sw.bb14:                                          ; preds = %if.then
  %35 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82231, i64 %35, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %36 = load i8**, i8*** %argv.addr, align 8, !dbg !917
  %37 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82231, i64 %37, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  %38 = load i32, i32* %i, align 4, !dbg !918
  %idxprom15 = sext i32 %38 to i64, !dbg !917
  %arrayidx16 = getelementptr inbounds i8*, i8** %36, i64 %idxprom15, !dbg !917
  %39 = ptrtoint i8** %arrayidx16 to i64
  call void @__dp_read(i32 82231, i64 %39, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %40 = load i8*, i8** %arrayidx16, align 8, !dbg !917
  %arrayidx17 = getelementptr inbounds i8, i8* %40, i64 1, !dbg !917
  %41 = ptrtoint i8* %arrayidx17 to i64
  call void @__dp_write(i32 82231, i64 %41, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  store i8 42, i8* %arrayidx17, align 1, !dbg !919
  %42 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82232, i64 %42, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  %43 = load i32, i32* %i, align 4, !dbg !920
  %inc = add nsw i32 %43, 1, !dbg !920
  %44 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 82232, i64 %44, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !920
  %45 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 82233, i64 %45, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.82, i32 0, i32 0))
  %46 = load i32, i32* %argc.addr, align 4, !dbg !921
  %47 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82233, i64 %47, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  %48 = load i32, i32* %i, align 4, !dbg !923
  %cmp18 = icmp eq i32 %46, %48, !dbg !924
  br i1 %cmp18, label %if.then20, label %if.end, !dbg !925

if.then20:                                        ; preds = %sw.bb14
  call void @__dp_call(i32 82233), !dbg !926
  call void @bots_print_usage(), !dbg !926
  call void @__dp_finalize(i32 82233), !dbg !928
  call void @exit(i32 100) #6, !dbg !928
  unreachable, !dbg !928

if.end:                                           ; preds = %sw.bb14
  %49 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82234, i64 %49, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %50 = load i8**, i8*** %argv.addr, align 8, !dbg !929
  %51 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82234, i64 %51, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  %52 = load i32, i32* %i, align 4, !dbg !930
  %idxprom21 = sext i32 %52 to i64, !dbg !929
  %arrayidx22 = getelementptr inbounds i8*, i8** %50, i64 %idxprom21, !dbg !929
  %53 = ptrtoint i8** %arrayidx22 to i64
  call void @__dp_read(i32 82234, i64 %53, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %54 = load i8*, i8** %arrayidx22, align 8, !dbg !929
  call void @__dp_call(i32 82234), !dbg !931
  %call23 = call i8* @strcpy(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_exec_message, i32 0, i32 0), i8* %54) #7, !dbg !931
  br label %sw.epilog, !dbg !932

sw.bb24:                                          ; preds = %if.then
  %55 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82245, i64 %55, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %56 = load i8**, i8*** %argv.addr, align 8, !dbg !933
  %57 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82245, i64 %57, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  %58 = load i32, i32* %i, align 4, !dbg !934
  %idxprom25 = sext i32 %58 to i64, !dbg !933
  %arrayidx26 = getelementptr inbounds i8*, i8** %56, i64 %idxprom25, !dbg !933
  %59 = ptrtoint i8** %arrayidx26 to i64
  call void @__dp_read(i32 82245, i64 %59, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %60 = load i8*, i8** %arrayidx26, align 8, !dbg !933
  %arrayidx27 = getelementptr inbounds i8, i8* %60, i64 1, !dbg !933
  %61 = ptrtoint i8* %arrayidx27 to i64
  call void @__dp_write(i32 82245, i64 %61, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  store i8 42, i8* %arrayidx27, align 1, !dbg !935
  call void @__dp_call(i32 82246), !dbg !936
  call void @bots_print_usage(), !dbg !936
  call void @__dp_finalize(i32 82247), !dbg !937
  call void @exit(i32 100) #6, !dbg !937
  unreachable, !dbg !937

sw.bb28:                                          ; preds = %if.then
  %62 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82266, i64 %62, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %63 = load i8**, i8*** %argv.addr, align 8, !dbg !938
  %64 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82266, i64 %64, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  %65 = load i32, i32* %i, align 4, !dbg !939
  %idxprom29 = sext i32 %65 to i64, !dbg !938
  %arrayidx30 = getelementptr inbounds i8*, i8** %63, i64 %idxprom29, !dbg !938
  %66 = ptrtoint i8** %arrayidx30 to i64
  call void @__dp_read(i32 82266, i64 %66, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %67 = load i8*, i8** %arrayidx30, align 8, !dbg !938
  %arrayidx31 = getelementptr inbounds i8, i8* %67, i64 1, !dbg !938
  %68 = ptrtoint i8* %arrayidx31 to i64
  call void @__dp_write(i32 82266, i64 %68, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  store i8 42, i8* %arrayidx31, align 1, !dbg !940
  %69 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82267, i64 %69, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  %70 = load i32, i32* %i, align 4, !dbg !941
  %inc32 = add nsw i32 %70, 1, !dbg !941
  %71 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 82267, i64 %71, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  store i32 %inc32, i32* %i, align 4, !dbg !941
  %72 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 82268, i64 %72, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.82, i32 0, i32 0))
  %73 = load i32, i32* %argc.addr, align 4, !dbg !942
  %74 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82268, i64 %74, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  %75 = load i32, i32* %i, align 4, !dbg !944
  %cmp33 = icmp eq i32 %73, %75, !dbg !945
  br i1 %cmp33, label %if.then35, label %if.end36, !dbg !946

if.then35:                                        ; preds = %sw.bb28
  call void @__dp_call(i32 82268), !dbg !947
  call void @bots_print_usage(), !dbg !947
  call void @__dp_finalize(i32 82268), !dbg !949
  call void @exit(i32 100) #6, !dbg !949
  unreachable, !dbg !949

if.end36:                                         ; preds = %sw.bb28
  %76 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82269, i64 %76, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %77 = load i8**, i8*** %argv.addr, align 8, !dbg !950
  %78 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82269, i64 %78, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  %79 = load i32, i32* %i, align 4, !dbg !951
  %idxprom37 = sext i32 %79 to i64, !dbg !950
  %arrayidx38 = getelementptr inbounds i8*, i8** %77, i64 %idxprom37, !dbg !950
  %80 = ptrtoint i8** %arrayidx38 to i64
  call void @__dp_read(i32 82269, i64 %80, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %81 = load i8*, i8** %arrayidx38, align 8, !dbg !950
  call void @__dp_call(i32 82269), !dbg !952
  %call39 = call i32 @atoi(i8* %81) #8, !dbg !952
  %82 = ptrtoint i32* @bots_arg_size to i64
  call void @__dp_write(i32 82269, i64 %82, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.31.87, i32 0, i32 0))
  store i32 %call39, i32* @bots_arg_size, align 4, !dbg !953
  br label %sw.epilog, !dbg !954

sw.bb40:                                          ; preds = %if.then
  %83 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82276, i64 %83, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %84 = load i8**, i8*** %argv.addr, align 8, !dbg !955
  %85 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82276, i64 %85, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  %86 = load i32, i32* %i, align 4, !dbg !956
  %idxprom41 = sext i32 %86 to i64, !dbg !955
  %arrayidx42 = getelementptr inbounds i8*, i8** %84, i64 %idxprom41, !dbg !955
  %87 = ptrtoint i8** %arrayidx42 to i64
  call void @__dp_read(i32 82276, i64 %87, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %88 = load i8*, i8** %arrayidx42, align 8, !dbg !955
  %arrayidx43 = getelementptr inbounds i8, i8* %88, i64 1, !dbg !955
  %89 = ptrtoint i8* %arrayidx43 to i64
  call void @__dp_write(i32 82276, i64 %89, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  store i8 42, i8* %arrayidx43, align 1, !dbg !957
  %90 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82277, i64 %90, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  %91 = load i32, i32* %i, align 4, !dbg !958
  %inc44 = add nsw i32 %91, 1, !dbg !958
  %92 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 82277, i64 %92, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  store i32 %inc44, i32* %i, align 4, !dbg !958
  %93 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 82278, i64 %93, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.82, i32 0, i32 0))
  %94 = load i32, i32* %argc.addr, align 4, !dbg !959
  %95 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82278, i64 %95, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  %96 = load i32, i32* %i, align 4, !dbg !961
  %cmp45 = icmp eq i32 %94, %96, !dbg !962
  br i1 %cmp45, label %if.then47, label %if.end48, !dbg !963

if.then47:                                        ; preds = %sw.bb40
  call void @__dp_call(i32 82278), !dbg !964
  call void @bots_print_usage(), !dbg !964
  call void @__dp_finalize(i32 82278), !dbg !966
  call void @exit(i32 100) #6, !dbg !966
  unreachable, !dbg !966

if.end48:                                         ; preds = %sw.bb40
  %97 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82279, i64 %97, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %98 = load i8**, i8*** %argv.addr, align 8, !dbg !967
  %99 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82279, i64 %99, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  %100 = load i32, i32* %i, align 4, !dbg !968
  %idxprom49 = sext i32 %100 to i64, !dbg !967
  %arrayidx50 = getelementptr inbounds i8*, i8** %98, i64 %idxprom49, !dbg !967
  %101 = ptrtoint i8** %arrayidx50 to i64
  call void @__dp_read(i32 82279, i64 %101, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %102 = load i8*, i8** %arrayidx50, align 8, !dbg !967
  call void @__dp_call(i32 82279), !dbg !969
  %call51 = call i32 @atoi(i8* %102) #8, !dbg !969
  %103 = ptrtoint i32* @bots_output_format to i64
  call void @__dp_write(i32 82279, i64 %103, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.32.88, i32 0, i32 0))
  store i32 %call51, i32* @bots_output_format, align 4, !dbg !970
  br label %sw.epilog, !dbg !971

sw.bb52:                                          ; preds = %if.then
  %104 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82299, i64 %104, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %105 = load i8**, i8*** %argv.addr, align 8, !dbg !972
  %106 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82299, i64 %106, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  %107 = load i32, i32* %i, align 4, !dbg !973
  %idxprom53 = sext i32 %107 to i64, !dbg !972
  %arrayidx54 = getelementptr inbounds i8*, i8** %105, i64 %idxprom53, !dbg !972
  %108 = ptrtoint i8** %arrayidx54 to i64
  call void @__dp_read(i32 82299, i64 %108, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %109 = load i8*, i8** %arrayidx54, align 8, !dbg !972
  %arrayidx55 = getelementptr inbounds i8, i8* %109, i64 1, !dbg !972
  %110 = ptrtoint i8* %arrayidx55 to i64
  call void @__dp_write(i32 82299, i64 %110, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  store i8 42, i8* %arrayidx55, align 1, !dbg !974
  %111 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82300, i64 %111, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  %112 = load i32, i32* %i, align 4, !dbg !975
  %inc56 = add nsw i32 %112, 1, !dbg !975
  %113 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 82300, i64 %113, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  store i32 %inc56, i32* %i, align 4, !dbg !975
  %114 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 82301, i64 %114, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.82, i32 0, i32 0))
  %115 = load i32, i32* %argc.addr, align 4, !dbg !976
  %116 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82301, i64 %116, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  %117 = load i32, i32* %i, align 4, !dbg !978
  %cmp57 = icmp eq i32 %115, %117, !dbg !979
  br i1 %cmp57, label %if.then59, label %if.end60, !dbg !980

if.then59:                                        ; preds = %sw.bb52
  call void @__dp_call(i32 82301), !dbg !981
  call void @bots_print_usage(), !dbg !981
  call void @__dp_finalize(i32 82301), !dbg !983
  call void @exit(i32 100) #6, !dbg !983
  unreachable, !dbg !983

if.end60:                                         ; preds = %sw.bb52
  %118 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82302, i64 %118, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %119 = load i8**, i8*** %argv.addr, align 8, !dbg !984
  %120 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82302, i64 %120, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  %121 = load i32, i32* %i, align 4, !dbg !985
  %idxprom61 = sext i32 %121 to i64, !dbg !984
  %arrayidx62 = getelementptr inbounds i8*, i8** %119, i64 %idxprom61, !dbg !984
  %122 = ptrtoint i8** %arrayidx62 to i64
  call void @__dp_read(i32 82302, i64 %122, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %123 = load i8*, i8** %arrayidx62, align 8, !dbg !984
  call void @__dp_call(i32 82302), !dbg !986
  %call63 = call i32 @atoi(i8* %123) #8, !dbg !986
  %124 = ptrtoint i32* @bots_verbose_mode to i64
  call void @__dp_write(i32 82302, i64 %124, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.33.89, i32 0, i32 0))
  store i32 %call63, i32* @bots_verbose_mode, align 4, !dbg !987
  %125 = ptrtoint i32* @bots_verbose_mode to i64
  call void @__dp_read(i32 82304, i64 %125, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.33.89, i32 0, i32 0))
  %126 = load i32, i32* @bots_verbose_mode, align 4, !dbg !988
  %cmp64 = icmp ugt i32 %126, 1, !dbg !990
  br i1 %cmp64, label %if.then66, label %if.end68, !dbg !991

if.then66:                                        ; preds = %if.end60
  %127 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82305, i64 %127, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.61, i32 0, i32 0))
  %128 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !992
  call void @__dp_call(i32 82305), !dbg !994
  %call67 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %128, i8* getelementptr inbounds ([100 x i8], [100 x i8]* @.str.19.90, i32 0, i32 0)), !dbg !994
  call void @__dp_finalize(i32 82306), !dbg !995
  call void @exit(i32 100) #6, !dbg !995
  unreachable, !dbg !995

if.end68:                                         ; preds = %if.end60
  br label %sw.epilog, !dbg !996

sw.bb69:                                          ; preds = %if.then
  %129 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82327, i64 %129, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %130 = load i8**, i8*** %argv.addr, align 8, !dbg !997
  %131 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82327, i64 %131, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  %132 = load i32, i32* %i, align 4, !dbg !998
  %idxprom70 = sext i32 %132 to i64, !dbg !997
  %arrayidx71 = getelementptr inbounds i8*, i8** %130, i64 %idxprom70, !dbg !997
  %133 = ptrtoint i8** %arrayidx71 to i64
  call void @__dp_read(i32 82327, i64 %133, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %134 = load i8*, i8** %arrayidx71, align 8, !dbg !997
  %arrayidx72 = getelementptr inbounds i8, i8* %134, i64 1, !dbg !997
  %135 = ptrtoint i8* %arrayidx72 to i64
  call void @__dp_write(i32 82327, i64 %135, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  store i8 42, i8* %arrayidx72, align 1, !dbg !999
  %136 = ptrtoint i32* @bots_print_header to i64
  call void @__dp_write(i32 82328, i64 %136, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.34.91, i32 0, i32 0))
  store i32 1, i32* @bots_print_header, align 4, !dbg !1000
  br label %sw.epilog, !dbg !1001

sw.default:                                       ; preds = %if.then
  %137 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82335, i64 %137, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.61, i32 0, i32 0))
  %138 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1002
  call void @__dp_call(i32 82335), !dbg !1003
  %call73 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %138, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.20.92, i32 0, i32 0)), !dbg !1003
  call void @__dp_call(i32 82336), !dbg !1004
  call void @bots_print_usage(), !dbg !1004
  call void @__dp_finalize(i32 82337), !dbg !1005
  call void @exit(i32 100) #6, !dbg !1005
  unreachable, !dbg !1005

sw.epilog:                                        ; preds = %sw.bb69, %if.end68, %if.end48, %if.end36, %if.end, %sw.bb
  br label %if.end75, !dbg !1006

if.else:                                          ; preds = %for.body
  %139 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82346, i64 %139, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.61, i32 0, i32 0))
  %140 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1007
  call void @__dp_call(i32 82346), !dbg !1009
  %call74 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %140, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.20.92, i32 0, i32 0)), !dbg !1009
  call void @__dp_call(i32 82347), !dbg !1010
  call void @bots_print_usage(), !dbg !1010
  call void @__dp_finalize(i32 82348), !dbg !1011
  call void @exit(i32 100) #6, !dbg !1011
  unreachable, !dbg !1011

if.end75:                                         ; preds = %sw.epilog
  br label %for.inc, !dbg !1012

for.inc:                                          ; preds = %if.end75
  %141 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82201, i64 %141, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  %142 = load i32, i32* %i, align 4, !dbg !1013
  %inc76 = add nsw i32 %142, 1, !dbg !1013
  %143 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 82201, i64 %143, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.29.85, i32 0, i32 0))
  store i32 %inc76, i32* %i, align 4, !dbg !1013
  br label %for.cond, !dbg !1014, !llvm.loop !1015

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 82351, i32 0)
  call void @__dp_func_exit(i32 82351, i32 0), !dbg !1017
  ret void, !dbg !1017
}

; Function Attrs: nounwind
declare dso_local i8* @__xpg_basename(i8*) #4

; Function Attrs: nounwind
declare dso_local i8* @strcpy(i8*, i8*) #4

declare void @__dp_loop_entry(i32, i32)

; Function Attrs: nounwind readonly
declare dso_local i32 @atoi(i8*) #5

declare void @__dp_loop_exit(i32, i32)

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_get_params(i32 %argc, i8** %argv) #0 !dbg !1018 {
entry:
  call void @__dp_func_entry(i32 82356, i32 0)
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %0 = ptrtoint i32* %argc.addr to i64
  call void @__dp_write(i32 82356, i64 %0, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.82, i32 0, i32 0))
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !1019, metadata !DIExpression()), !dbg !1020
  %1 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_write(i32 82356, i64 %1, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !1021, metadata !DIExpression()), !dbg !1022
  %2 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 82358, i64 %2, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.82, i32 0, i32 0))
  %3 = load i32, i32* %argc.addr, align 4, !dbg !1023
  %4 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82358, i64 %4, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %5 = load i8**, i8*** %argv.addr, align 8, !dbg !1024
  call void @__dp_call(i32 82358), !dbg !1025
  call void @bots_get_params_common(i32 %3, i8** %5), !dbg !1025
  call void @__dp_func_exit(i32 82360, i32 0), !dbg !1026
  ret void, !dbg !1026
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_set_info() #0 !dbg !1027 {
entry:
  call void @__dp_func_entry(i32 82369, i32 0), !dbg !1028
  call void @__dp_call(i32 82369), !dbg !1028
  %call = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_name, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.21.93, i32 0, i32 0)) #7, !dbg !1028
  %0 = ptrtoint i32* @bots_arg_size to i64
  call void @__dp_read(i32 82370, i64 %0, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.31.87, i32 0, i32 0))
  %1 = load i32, i32* @bots_arg_size, align 4, !dbg !1029
  call void @__dp_call(i32 82370), !dbg !1030
  %call1 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_parameters, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.22.94, i32 0, i32 0), i32 %1) #7, !dbg !1030
  call void @__dp_call(i32 82371), !dbg !1031
  %call2 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_model, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.23.95, i32 0, i32 0)) #7, !dbg !1031
  call void @__dp_call(i32 82372), !dbg !1032
  %call3 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_resources, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.24.96, i32 0, i32 0), i32 1) #7, !dbg !1032
  call void @__dp_call(i32 82375), !dbg !1033
  %call4 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_comp_date, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.18.84, i32 0, i32 0)) #7, !dbg !1033
  call void @__dp_call(i32 82376), !dbg !1034
  %call5 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_comp_message, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.18.84, i32 0, i32 0)) #7, !dbg !1034
  call void @__dp_call(i32 82377), !dbg !1035
  %call6 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_cc, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.18.84, i32 0, i32 0)) #7, !dbg !1035
  call void @__dp_call(i32 82378), !dbg !1036
  %call7 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_cflags, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.18.84, i32 0, i32 0)) #7, !dbg !1036
  call void @__dp_call(i32 82379), !dbg !1037
  %call8 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_ld, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.18.84, i32 0, i32 0)) #7, !dbg !1037
  call void @__dp_call(i32 82380), !dbg !1038
  %call9 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_ldflags, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.18.84, i32 0, i32 0)) #7, !dbg !1038
  call void @__dp_call(i32 82389), !dbg !1039
  %call10 = call i8* @strcpy(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_cutoff, i32 0, i32 0), i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.25.97, i32 0, i32 0)) #7, !dbg !1039
  call void @__dp_func_exit(i32 82391, i32 0), !dbg !1040
  ret void, !dbg !1040
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !1041 {
entry:
  call void @__dp_func_entry(i32 82397, i32 1)
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %bots_t_start = alloca i64, align 8
  %bots_t_end = alloca i64, align 8
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 82397, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.35.98, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  %1 = ptrtoint i32* %argc.addr to i64
  call void @__dp_write(i32 82397, i64 %1, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.82, i32 0, i32 0))
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !1044, metadata !DIExpression()), !dbg !1045
  %2 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_write(i32 82397, i64 %2, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !1046, metadata !DIExpression()), !dbg !1047
  call void @llvm.dbg.declare(metadata i64* %bots_t_start, metadata !1048, metadata !DIExpression()), !dbg !1049
  call void @llvm.dbg.declare(metadata i64* %bots_t_end, metadata !1050, metadata !DIExpression()), !dbg !1051
  %3 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 82404, i64 %3, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.27.82, i32 0, i32 0))
  %4 = load i32, i32* %argc.addr, align 4, !dbg !1052
  %5 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82404, i64 %5, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.28.83, i32 0, i32 0))
  %6 = load i8**, i8*** %argv.addr, align 8, !dbg !1053
  call void @__dp_call(i32 82404), !dbg !1054
  call void @bots_get_params(i32 %4, i8** %6), !dbg !1054
  call void @__dp_call(i32 82406), !dbg !1055
  call void @bots_set_info(), !dbg !1055
  call void @__dp_call(i32 82433), !dbg !1056
  %call = call i64 (...) bitcast (i64 ()* @bots_usecs to i64 (...)*)(), !dbg !1056
  %7 = ptrtoint i64* %bots_t_start to i64
  call void @__dp_write(i32 82433, i64 %7, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.36.99, i32 0, i32 0))
  store i64 %call, i64* %bots_t_start, align 8, !dbg !1057
  %8 = ptrtoint i32* @bots_arg_size to i64
  call void @__dp_read(i32 82434, i64 %8, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.31.87, i32 0, i32 0))
  %9 = load i32, i32* @bots_arg_size, align 4, !dbg !1058
  call void @__dp_call(i32 82434), !dbg !1058
  call void @fib0(i32 %9), !dbg !1058
  call void @__dp_call(i32 82435), !dbg !1059
  %call1 = call i64 (...) bitcast (i64 ()* @bots_usecs to i64 (...)*)(), !dbg !1059
  %10 = ptrtoint i64* %bots_t_end to i64
  call void @__dp_write(i32 82435, i64 %10, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.37.100, i32 0, i32 0))
  store i64 %call1, i64* %bots_t_end, align 8, !dbg !1060
  %11 = ptrtoint i64* %bots_t_end to i64
  call void @__dp_read(i32 82436, i64 %11, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.37.100, i32 0, i32 0))
  %12 = load i64, i64* %bots_t_end, align 8, !dbg !1061
  %13 = ptrtoint i64* %bots_t_start to i64
  call void @__dp_read(i32 82436, i64 %13, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.36.99, i32 0, i32 0))
  %14 = load i64, i64* %bots_t_start, align 8, !dbg !1062
  %sub = sub nsw i64 %12, %14, !dbg !1063
  %conv = sitofp i64 %sub to double, !dbg !1064
  %div = fdiv double %conv, 1.000000e+06, !dbg !1065
  %15 = ptrtoint double* @bots_time_program to i64
  call void @__dp_write(i32 82436, i64 %15, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.38.101, i32 0, i32 0))
  store double %div, double* @bots_time_program, align 8, !dbg !1066
  %16 = ptrtoint i32* @bots_check_flag to i64
  call void @__dp_read(i32 82441, i64 %16, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.30.86, i32 0, i32 0))
  %17 = load i32, i32* @bots_check_flag, align 4, !dbg !1067
  %tobool = icmp ne i32 %17, 0, !dbg !1067
  br i1 %tobool, label %if.then, label %if.end, !dbg !1069

if.then:                                          ; preds = %entry
  %18 = ptrtoint i32* @bots_result to i64
  call void @__dp_write(i32 82442, i64 %18, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.39.102, i32 0, i32 0))
  store i32 0, i32* @bots_result, align 4, !dbg !1070
  br label %if.end, !dbg !1072

if.end:                                           ; preds = %if.then, %entry
  call void @__dp_call(i32 82448), !dbg !1073
  call void @bots_print_results(), !dbg !1073
  call void @__dp_finalize(i32 82449), !dbg !1074
  ret i32 0, !dbg !1074
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

!llvm.dbg.cu = !{!2, !74, !16}
!llvm.ident = !{!298, !298, !298}
!llvm.module.flags = !{!299, !300, !301}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "res", scope: !2, file: !3, line: 24, type: !13, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 8.0.1-9 (tags/RELEASE_801/final)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !12, nameTableKind: None)
!3 = !DIFile(filename: "fib.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/fib")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 76, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "./bots.h", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/fib")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11}
!9 = !DIEnumerator(name: "BOTS_VERBOSE_NONE", value: 0, isUnsigned: true)
!10 = !DIEnumerator(name: "BOTS_VERBOSE_DEFAULT", value: 1, isUnsigned: true)
!11 = !DIEnumerator(name: "BOTS_VERBOSE_DEBUG", value: 2, isUnsigned: true)
!12 = !{!0}
!13 = !DIBasicType(name: "long long int", size: 64, encoding: DW_ATE_signed)
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(name: "bots_sequential_flag", scope: !16, file: !17, line: 41, type: !24, isLocal: false, isDefinition: true)
!16 = distinct !DICompileUnit(language: DW_LANG_C99, file: !17, producer: "clang version 8.0.1-9 (tags/RELEASE_801/final)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !18, globals: !21, nameTableKind: None)
!17 = !DIFile(filename: "bots_main.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/fib")
!18 = !{!19, !20}
!19 = !DIDerivedType(tag: DW_TAG_typedef, name: "bots_verbose_mode_t", file: !6, line: 78, baseType: !5)
!20 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!21 = !{!14, !22, !25, !27, !29, !31, !33, !35, !37, !40, !42, !48, !50, !52, !54, !56, !58, !60, !62, !64, !66, !68, !70, !72}
!22 = !DIGlobalVariableExpression(var: !23, expr: !DIExpression())
!23 = distinct !DIGlobalVariable(name: "bots_check_flag", scope: !16, file: !17, line: 42, type: !24, isLocal: false, isDefinition: true)
!24 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(name: "bots_verbose_mode", scope: !16, file: !17, line: 43, type: !19, isLocal: false, isDefinition: true)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(name: "bots_result", scope: !16, file: !17, line: 44, type: !24, isLocal: false, isDefinition: true)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(name: "bots_output_format", scope: !16, file: !17, line: 45, type: !24, isLocal: false, isDefinition: true)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(name: "bots_print_header", scope: !16, file: !17, line: 46, type: !24, isLocal: false, isDefinition: true)
!33 = !DIGlobalVariableExpression(var: !34, expr: !DIExpression())
!34 = distinct !DIGlobalVariable(name: "bots_time_program", scope: !16, file: !17, line: 65, type: !20, isLocal: false, isDefinition: true)
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(name: "bots_time_sequential", scope: !16, file: !17, line: 66, type: !20, isLocal: false, isDefinition: true)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(name: "bots_number_of_tasks", scope: !16, file: !17, line: 67, type: !39, isLocal: false, isDefinition: true)
!39 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(name: "bots_arg_size", scope: !16, file: !17, line: 124, type: !24, isLocal: false, isDefinition: true)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(name: "bots_name", scope: !16, file: !17, line: 48, type: !44, isLocal: false, isDefinition: true)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !45, size: 2048, elements: !46)
!45 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!46 = !{!47}
!47 = !DISubrange(count: 256)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "bots_execname", scope: !16, file: !17, line: 49, type: !44, isLocal: false, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "bots_parameters", scope: !16, file: !17, line: 50, type: !44, isLocal: false, isDefinition: true)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(name: "bots_model", scope: !16, file: !17, line: 51, type: !44, isLocal: false, isDefinition: true)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "bots_resources", scope: !16, file: !17, line: 52, type: !44, isLocal: false, isDefinition: true)
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(name: "bots_exec_date", scope: !16, file: !17, line: 54, type: !44, isLocal: false, isDefinition: true)
!58 = !DIGlobalVariableExpression(var: !59, expr: !DIExpression())
!59 = distinct !DIGlobalVariable(name: "bots_exec_message", scope: !16, file: !17, line: 55, type: !44, isLocal: false, isDefinition: true)
!60 = !DIGlobalVariableExpression(var: !61, expr: !DIExpression())
!61 = distinct !DIGlobalVariable(name: "bots_comp_date", scope: !16, file: !17, line: 56, type: !44, isLocal: false, isDefinition: true)
!62 = !DIGlobalVariableExpression(var: !63, expr: !DIExpression())
!63 = distinct !DIGlobalVariable(name: "bots_comp_message", scope: !16, file: !17, line: 57, type: !44, isLocal: false, isDefinition: true)
!64 = !DIGlobalVariableExpression(var: !65, expr: !DIExpression())
!65 = distinct !DIGlobalVariable(name: "bots_cc", scope: !16, file: !17, line: 58, type: !44, isLocal: false, isDefinition: true)
!66 = !DIGlobalVariableExpression(var: !67, expr: !DIExpression())
!67 = distinct !DIGlobalVariable(name: "bots_cflags", scope: !16, file: !17, line: 59, type: !44, isLocal: false, isDefinition: true)
!68 = !DIGlobalVariableExpression(var: !69, expr: !DIExpression())
!69 = distinct !DIGlobalVariable(name: "bots_ld", scope: !16, file: !17, line: 60, type: !44, isLocal: false, isDefinition: true)
!70 = !DIGlobalVariableExpression(var: !71, expr: !DIExpression())
!71 = distinct !DIGlobalVariable(name: "bots_ldflags", scope: !16, file: !17, line: 61, type: !44, isLocal: false, isDefinition: true)
!72 = !DIGlobalVariableExpression(var: !73, expr: !DIExpression())
!73 = distinct !DIGlobalVariable(name: "bots_cutoff", scope: !16, file: !17, line: 62, type: !44, isLocal: false, isDefinition: true)
!74 = distinct !DICompileUnit(language: DW_LANG_C99, file: !75, producer: "clang version 8.0.1-9 (tags/RELEASE_801/final)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !76, retainedTypes: !295, nameTableKind: None)
!75 = !DIFile(filename: "bots_common.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/fib")
!76 = !{!77}
!77 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !78, line: 71, baseType: !7, size: 32, elements: !79)
!78 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/confname.h", directory: "")
!79 = !{!80, !81, !82, !83, !84, !85, !86, !87, !88, !89, !90, !91, !92, !93, !94, !95, !96, !97, !98, !99, !100, !101, !102, !103, !104, !105, !106, !107, !108, !109, !110, !111, !112, !113, !114, !115, !116, !117, !118, !119, !120, !121, !122, !123, !124, !125, !126, !127, !128, !129, !130, !131, !132, !133, !134, !135, !136, !137, !138, !139, !140, !141, !142, !143, !144, !145, !146, !147, !148, !149, !150, !151, !152, !153, !154, !155, !156, !157, !158, !159, !160, !161, !162, !163, !164, !165, !166, !167, !168, !169, !170, !171, !172, !173, !174, !175, !176, !177, !178, !179, !180, !181, !182, !183, !184, !185, !186, !187, !188, !189, !190, !191, !192, !193, !194, !195, !196, !197, !198, !199, !200, !201, !202, !203, !204, !205, !206, !207, !208, !209, !210, !211, !212, !213, !214, !215, !216, !217, !218, !219, !220, !221, !222, !223, !224, !225, !226, !227, !228, !229, !230, !231, !232, !233, !234, !235, !236, !237, !238, !239, !240, !241, !242, !243, !244, !245, !246, !247, !248, !249, !250, !251, !252, !253, !254, !255, !256, !257, !258, !259, !260, !261, !262, !263, !264, !265, !266, !267, !268, !269, !270, !271, !272, !273, !274, !275, !276, !277, !278, !279, !280, !281, !282, !283, !284, !285, !286, !287, !288, !289, !290, !291, !292, !293, !294}
!80 = !DIEnumerator(name: "_SC_ARG_MAX", value: 0, isUnsigned: true)
!81 = !DIEnumerator(name: "_SC_CHILD_MAX", value: 1, isUnsigned: true)
!82 = !DIEnumerator(name: "_SC_CLK_TCK", value: 2, isUnsigned: true)
!83 = !DIEnumerator(name: "_SC_NGROUPS_MAX", value: 3, isUnsigned: true)
!84 = !DIEnumerator(name: "_SC_OPEN_MAX", value: 4, isUnsigned: true)
!85 = !DIEnumerator(name: "_SC_STREAM_MAX", value: 5, isUnsigned: true)
!86 = !DIEnumerator(name: "_SC_TZNAME_MAX", value: 6, isUnsigned: true)
!87 = !DIEnumerator(name: "_SC_JOB_CONTROL", value: 7, isUnsigned: true)
!88 = !DIEnumerator(name: "_SC_SAVED_IDS", value: 8, isUnsigned: true)
!89 = !DIEnumerator(name: "_SC_REALTIME_SIGNALS", value: 9, isUnsigned: true)
!90 = !DIEnumerator(name: "_SC_PRIORITY_SCHEDULING", value: 10, isUnsigned: true)
!91 = !DIEnumerator(name: "_SC_TIMERS", value: 11, isUnsigned: true)
!92 = !DIEnumerator(name: "_SC_ASYNCHRONOUS_IO", value: 12, isUnsigned: true)
!93 = !DIEnumerator(name: "_SC_PRIORITIZED_IO", value: 13, isUnsigned: true)
!94 = !DIEnumerator(name: "_SC_SYNCHRONIZED_IO", value: 14, isUnsigned: true)
!95 = !DIEnumerator(name: "_SC_FSYNC", value: 15, isUnsigned: true)
!96 = !DIEnumerator(name: "_SC_MAPPED_FILES", value: 16, isUnsigned: true)
!97 = !DIEnumerator(name: "_SC_MEMLOCK", value: 17, isUnsigned: true)
!98 = !DIEnumerator(name: "_SC_MEMLOCK_RANGE", value: 18, isUnsigned: true)
!99 = !DIEnumerator(name: "_SC_MEMORY_PROTECTION", value: 19, isUnsigned: true)
!100 = !DIEnumerator(name: "_SC_MESSAGE_PASSING", value: 20, isUnsigned: true)
!101 = !DIEnumerator(name: "_SC_SEMAPHORES", value: 21, isUnsigned: true)
!102 = !DIEnumerator(name: "_SC_SHARED_MEMORY_OBJECTS", value: 22, isUnsigned: true)
!103 = !DIEnumerator(name: "_SC_AIO_LISTIO_MAX", value: 23, isUnsigned: true)
!104 = !DIEnumerator(name: "_SC_AIO_MAX", value: 24, isUnsigned: true)
!105 = !DIEnumerator(name: "_SC_AIO_PRIO_DELTA_MAX", value: 25, isUnsigned: true)
!106 = !DIEnumerator(name: "_SC_DELAYTIMER_MAX", value: 26, isUnsigned: true)
!107 = !DIEnumerator(name: "_SC_MQ_OPEN_MAX", value: 27, isUnsigned: true)
!108 = !DIEnumerator(name: "_SC_MQ_PRIO_MAX", value: 28, isUnsigned: true)
!109 = !DIEnumerator(name: "_SC_VERSION", value: 29, isUnsigned: true)
!110 = !DIEnumerator(name: "_SC_PAGESIZE", value: 30, isUnsigned: true)
!111 = !DIEnumerator(name: "_SC_RTSIG_MAX", value: 31, isUnsigned: true)
!112 = !DIEnumerator(name: "_SC_SEM_NSEMS_MAX", value: 32, isUnsigned: true)
!113 = !DIEnumerator(name: "_SC_SEM_VALUE_MAX", value: 33, isUnsigned: true)
!114 = !DIEnumerator(name: "_SC_SIGQUEUE_MAX", value: 34, isUnsigned: true)
!115 = !DIEnumerator(name: "_SC_TIMER_MAX", value: 35, isUnsigned: true)
!116 = !DIEnumerator(name: "_SC_BC_BASE_MAX", value: 36, isUnsigned: true)
!117 = !DIEnumerator(name: "_SC_BC_DIM_MAX", value: 37, isUnsigned: true)
!118 = !DIEnumerator(name: "_SC_BC_SCALE_MAX", value: 38, isUnsigned: true)
!119 = !DIEnumerator(name: "_SC_BC_STRING_MAX", value: 39, isUnsigned: true)
!120 = !DIEnumerator(name: "_SC_COLL_WEIGHTS_MAX", value: 40, isUnsigned: true)
!121 = !DIEnumerator(name: "_SC_EQUIV_CLASS_MAX", value: 41, isUnsigned: true)
!122 = !DIEnumerator(name: "_SC_EXPR_NEST_MAX", value: 42, isUnsigned: true)
!123 = !DIEnumerator(name: "_SC_LINE_MAX", value: 43, isUnsigned: true)
!124 = !DIEnumerator(name: "_SC_RE_DUP_MAX", value: 44, isUnsigned: true)
!125 = !DIEnumerator(name: "_SC_CHARCLASS_NAME_MAX", value: 45, isUnsigned: true)
!126 = !DIEnumerator(name: "_SC_2_VERSION", value: 46, isUnsigned: true)
!127 = !DIEnumerator(name: "_SC_2_C_BIND", value: 47, isUnsigned: true)
!128 = !DIEnumerator(name: "_SC_2_C_DEV", value: 48, isUnsigned: true)
!129 = !DIEnumerator(name: "_SC_2_FORT_DEV", value: 49, isUnsigned: true)
!130 = !DIEnumerator(name: "_SC_2_FORT_RUN", value: 50, isUnsigned: true)
!131 = !DIEnumerator(name: "_SC_2_SW_DEV", value: 51, isUnsigned: true)
!132 = !DIEnumerator(name: "_SC_2_LOCALEDEF", value: 52, isUnsigned: true)
!133 = !DIEnumerator(name: "_SC_PII", value: 53, isUnsigned: true)
!134 = !DIEnumerator(name: "_SC_PII_XTI", value: 54, isUnsigned: true)
!135 = !DIEnumerator(name: "_SC_PII_SOCKET", value: 55, isUnsigned: true)
!136 = !DIEnumerator(name: "_SC_PII_INTERNET", value: 56, isUnsigned: true)
!137 = !DIEnumerator(name: "_SC_PII_OSI", value: 57, isUnsigned: true)
!138 = !DIEnumerator(name: "_SC_POLL", value: 58, isUnsigned: true)
!139 = !DIEnumerator(name: "_SC_SELECT", value: 59, isUnsigned: true)
!140 = !DIEnumerator(name: "_SC_UIO_MAXIOV", value: 60, isUnsigned: true)
!141 = !DIEnumerator(name: "_SC_IOV_MAX", value: 60, isUnsigned: true)
!142 = !DIEnumerator(name: "_SC_PII_INTERNET_STREAM", value: 61, isUnsigned: true)
!143 = !DIEnumerator(name: "_SC_PII_INTERNET_DGRAM", value: 62, isUnsigned: true)
!144 = !DIEnumerator(name: "_SC_PII_OSI_COTS", value: 63, isUnsigned: true)
!145 = !DIEnumerator(name: "_SC_PII_OSI_CLTS", value: 64, isUnsigned: true)
!146 = !DIEnumerator(name: "_SC_PII_OSI_M", value: 65, isUnsigned: true)
!147 = !DIEnumerator(name: "_SC_T_IOV_MAX", value: 66, isUnsigned: true)
!148 = !DIEnumerator(name: "_SC_THREADS", value: 67, isUnsigned: true)
!149 = !DIEnumerator(name: "_SC_THREAD_SAFE_FUNCTIONS", value: 68, isUnsigned: true)
!150 = !DIEnumerator(name: "_SC_GETGR_R_SIZE_MAX", value: 69, isUnsigned: true)
!151 = !DIEnumerator(name: "_SC_GETPW_R_SIZE_MAX", value: 70, isUnsigned: true)
!152 = !DIEnumerator(name: "_SC_LOGIN_NAME_MAX", value: 71, isUnsigned: true)
!153 = !DIEnumerator(name: "_SC_TTY_NAME_MAX", value: 72, isUnsigned: true)
!154 = !DIEnumerator(name: "_SC_THREAD_DESTRUCTOR_ITERATIONS", value: 73, isUnsigned: true)
!155 = !DIEnumerator(name: "_SC_THREAD_KEYS_MAX", value: 74, isUnsigned: true)
!156 = !DIEnumerator(name: "_SC_THREAD_STACK_MIN", value: 75, isUnsigned: true)
!157 = !DIEnumerator(name: "_SC_THREAD_THREADS_MAX", value: 76, isUnsigned: true)
!158 = !DIEnumerator(name: "_SC_THREAD_ATTR_STACKADDR", value: 77, isUnsigned: true)
!159 = !DIEnumerator(name: "_SC_THREAD_ATTR_STACKSIZE", value: 78, isUnsigned: true)
!160 = !DIEnumerator(name: "_SC_THREAD_PRIORITY_SCHEDULING", value: 79, isUnsigned: true)
!161 = !DIEnumerator(name: "_SC_THREAD_PRIO_INHERIT", value: 80, isUnsigned: true)
!162 = !DIEnumerator(name: "_SC_THREAD_PRIO_PROTECT", value: 81, isUnsigned: true)
!163 = !DIEnumerator(name: "_SC_THREAD_PROCESS_SHARED", value: 82, isUnsigned: true)
!164 = !DIEnumerator(name: "_SC_NPROCESSORS_CONF", value: 83, isUnsigned: true)
!165 = !DIEnumerator(name: "_SC_NPROCESSORS_ONLN", value: 84, isUnsigned: true)
!166 = !DIEnumerator(name: "_SC_PHYS_PAGES", value: 85, isUnsigned: true)
!167 = !DIEnumerator(name: "_SC_AVPHYS_PAGES", value: 86, isUnsigned: true)
!168 = !DIEnumerator(name: "_SC_ATEXIT_MAX", value: 87, isUnsigned: true)
!169 = !DIEnumerator(name: "_SC_PASS_MAX", value: 88, isUnsigned: true)
!170 = !DIEnumerator(name: "_SC_XOPEN_VERSION", value: 89, isUnsigned: true)
!171 = !DIEnumerator(name: "_SC_XOPEN_XCU_VERSION", value: 90, isUnsigned: true)
!172 = !DIEnumerator(name: "_SC_XOPEN_UNIX", value: 91, isUnsigned: true)
!173 = !DIEnumerator(name: "_SC_XOPEN_CRYPT", value: 92, isUnsigned: true)
!174 = !DIEnumerator(name: "_SC_XOPEN_ENH_I18N", value: 93, isUnsigned: true)
!175 = !DIEnumerator(name: "_SC_XOPEN_SHM", value: 94, isUnsigned: true)
!176 = !DIEnumerator(name: "_SC_2_CHAR_TERM", value: 95, isUnsigned: true)
!177 = !DIEnumerator(name: "_SC_2_C_VERSION", value: 96, isUnsigned: true)
!178 = !DIEnumerator(name: "_SC_2_UPE", value: 97, isUnsigned: true)
!179 = !DIEnumerator(name: "_SC_XOPEN_XPG2", value: 98, isUnsigned: true)
!180 = !DIEnumerator(name: "_SC_XOPEN_XPG3", value: 99, isUnsigned: true)
!181 = !DIEnumerator(name: "_SC_XOPEN_XPG4", value: 100, isUnsigned: true)
!182 = !DIEnumerator(name: "_SC_CHAR_BIT", value: 101, isUnsigned: true)
!183 = !DIEnumerator(name: "_SC_CHAR_MAX", value: 102, isUnsigned: true)
!184 = !DIEnumerator(name: "_SC_CHAR_MIN", value: 103, isUnsigned: true)
!185 = !DIEnumerator(name: "_SC_INT_MAX", value: 104, isUnsigned: true)
!186 = !DIEnumerator(name: "_SC_INT_MIN", value: 105, isUnsigned: true)
!187 = !DIEnumerator(name: "_SC_LONG_BIT", value: 106, isUnsigned: true)
!188 = !DIEnumerator(name: "_SC_WORD_BIT", value: 107, isUnsigned: true)
!189 = !DIEnumerator(name: "_SC_MB_LEN_MAX", value: 108, isUnsigned: true)
!190 = !DIEnumerator(name: "_SC_NZERO", value: 109, isUnsigned: true)
!191 = !DIEnumerator(name: "_SC_SSIZE_MAX", value: 110, isUnsigned: true)
!192 = !DIEnumerator(name: "_SC_SCHAR_MAX", value: 111, isUnsigned: true)
!193 = !DIEnumerator(name: "_SC_SCHAR_MIN", value: 112, isUnsigned: true)
!194 = !DIEnumerator(name: "_SC_SHRT_MAX", value: 113, isUnsigned: true)
!195 = !DIEnumerator(name: "_SC_SHRT_MIN", value: 114, isUnsigned: true)
!196 = !DIEnumerator(name: "_SC_UCHAR_MAX", value: 115, isUnsigned: true)
!197 = !DIEnumerator(name: "_SC_UINT_MAX", value: 116, isUnsigned: true)
!198 = !DIEnumerator(name: "_SC_ULONG_MAX", value: 117, isUnsigned: true)
!199 = !DIEnumerator(name: "_SC_USHRT_MAX", value: 118, isUnsigned: true)
!200 = !DIEnumerator(name: "_SC_NL_ARGMAX", value: 119, isUnsigned: true)
!201 = !DIEnumerator(name: "_SC_NL_LANGMAX", value: 120, isUnsigned: true)
!202 = !DIEnumerator(name: "_SC_NL_MSGMAX", value: 121, isUnsigned: true)
!203 = !DIEnumerator(name: "_SC_NL_NMAX", value: 122, isUnsigned: true)
!204 = !DIEnumerator(name: "_SC_NL_SETMAX", value: 123, isUnsigned: true)
!205 = !DIEnumerator(name: "_SC_NL_TEXTMAX", value: 124, isUnsigned: true)
!206 = !DIEnumerator(name: "_SC_XBS5_ILP32_OFF32", value: 125, isUnsigned: true)
!207 = !DIEnumerator(name: "_SC_XBS5_ILP32_OFFBIG", value: 126, isUnsigned: true)
!208 = !DIEnumerator(name: "_SC_XBS5_LP64_OFF64", value: 127, isUnsigned: true)
!209 = !DIEnumerator(name: "_SC_XBS5_LPBIG_OFFBIG", value: 128, isUnsigned: true)
!210 = !DIEnumerator(name: "_SC_XOPEN_LEGACY", value: 129, isUnsigned: true)
!211 = !DIEnumerator(name: "_SC_XOPEN_REALTIME", value: 130, isUnsigned: true)
!212 = !DIEnumerator(name: "_SC_XOPEN_REALTIME_THREADS", value: 131, isUnsigned: true)
!213 = !DIEnumerator(name: "_SC_ADVISORY_INFO", value: 132, isUnsigned: true)
!214 = !DIEnumerator(name: "_SC_BARRIERS", value: 133, isUnsigned: true)
!215 = !DIEnumerator(name: "_SC_BASE", value: 134, isUnsigned: true)
!216 = !DIEnumerator(name: "_SC_C_LANG_SUPPORT", value: 135, isUnsigned: true)
!217 = !DIEnumerator(name: "_SC_C_LANG_SUPPORT_R", value: 136, isUnsigned: true)
!218 = !DIEnumerator(name: "_SC_CLOCK_SELECTION", value: 137, isUnsigned: true)
!219 = !DIEnumerator(name: "_SC_CPUTIME", value: 138, isUnsigned: true)
!220 = !DIEnumerator(name: "_SC_THREAD_CPUTIME", value: 139, isUnsigned: true)
!221 = !DIEnumerator(name: "_SC_DEVICE_IO", value: 140, isUnsigned: true)
!222 = !DIEnumerator(name: "_SC_DEVICE_SPECIFIC", value: 141, isUnsigned: true)
!223 = !DIEnumerator(name: "_SC_DEVICE_SPECIFIC_R", value: 142, isUnsigned: true)
!224 = !DIEnumerator(name: "_SC_FD_MGMT", value: 143, isUnsigned: true)
!225 = !DIEnumerator(name: "_SC_FIFO", value: 144, isUnsigned: true)
!226 = !DIEnumerator(name: "_SC_PIPE", value: 145, isUnsigned: true)
!227 = !DIEnumerator(name: "_SC_FILE_ATTRIBUTES", value: 146, isUnsigned: true)
!228 = !DIEnumerator(name: "_SC_FILE_LOCKING", value: 147, isUnsigned: true)
!229 = !DIEnumerator(name: "_SC_FILE_SYSTEM", value: 148, isUnsigned: true)
!230 = !DIEnumerator(name: "_SC_MONOTONIC_CLOCK", value: 149, isUnsigned: true)
!231 = !DIEnumerator(name: "_SC_MULTI_PROCESS", value: 150, isUnsigned: true)
!232 = !DIEnumerator(name: "_SC_SINGLE_PROCESS", value: 151, isUnsigned: true)
!233 = !DIEnumerator(name: "_SC_NETWORKING", value: 152, isUnsigned: true)
!234 = !DIEnumerator(name: "_SC_READER_WRITER_LOCKS", value: 153, isUnsigned: true)
!235 = !DIEnumerator(name: "_SC_SPIN_LOCKS", value: 154, isUnsigned: true)
!236 = !DIEnumerator(name: "_SC_REGEXP", value: 155, isUnsigned: true)
!237 = !DIEnumerator(name: "_SC_REGEX_VERSION", value: 156, isUnsigned: true)
!238 = !DIEnumerator(name: "_SC_SHELL", value: 157, isUnsigned: true)
!239 = !DIEnumerator(name: "_SC_SIGNALS", value: 158, isUnsigned: true)
!240 = !DIEnumerator(name: "_SC_SPAWN", value: 159, isUnsigned: true)
!241 = !DIEnumerator(name: "_SC_SPORADIC_SERVER", value: 160, isUnsigned: true)
!242 = !DIEnumerator(name: "_SC_THREAD_SPORADIC_SERVER", value: 161, isUnsigned: true)
!243 = !DIEnumerator(name: "_SC_SYSTEM_DATABASE", value: 162, isUnsigned: true)
!244 = !DIEnumerator(name: "_SC_SYSTEM_DATABASE_R", value: 163, isUnsigned: true)
!245 = !DIEnumerator(name: "_SC_TIMEOUTS", value: 164, isUnsigned: true)
!246 = !DIEnumerator(name: "_SC_TYPED_MEMORY_OBJECTS", value: 165, isUnsigned: true)
!247 = !DIEnumerator(name: "_SC_USER_GROUPS", value: 166, isUnsigned: true)
!248 = !DIEnumerator(name: "_SC_USER_GROUPS_R", value: 167, isUnsigned: true)
!249 = !DIEnumerator(name: "_SC_2_PBS", value: 168, isUnsigned: true)
!250 = !DIEnumerator(name: "_SC_2_PBS_ACCOUNTING", value: 169, isUnsigned: true)
!251 = !DIEnumerator(name: "_SC_2_PBS_LOCATE", value: 170, isUnsigned: true)
!252 = !DIEnumerator(name: "_SC_2_PBS_MESSAGE", value: 171, isUnsigned: true)
!253 = !DIEnumerator(name: "_SC_2_PBS_TRACK", value: 172, isUnsigned: true)
!254 = !DIEnumerator(name: "_SC_SYMLOOP_MAX", value: 173, isUnsigned: true)
!255 = !DIEnumerator(name: "_SC_STREAMS", value: 174, isUnsigned: true)
!256 = !DIEnumerator(name: "_SC_2_PBS_CHECKPOINT", value: 175, isUnsigned: true)
!257 = !DIEnumerator(name: "_SC_V6_ILP32_OFF32", value: 176, isUnsigned: true)
!258 = !DIEnumerator(name: "_SC_V6_ILP32_OFFBIG", value: 177, isUnsigned: true)
!259 = !DIEnumerator(name: "_SC_V6_LP64_OFF64", value: 178, isUnsigned: true)
!260 = !DIEnumerator(name: "_SC_V6_LPBIG_OFFBIG", value: 179, isUnsigned: true)
!261 = !DIEnumerator(name: "_SC_HOST_NAME_MAX", value: 180, isUnsigned: true)
!262 = !DIEnumerator(name: "_SC_TRACE", value: 181, isUnsigned: true)
!263 = !DIEnumerator(name: "_SC_TRACE_EVENT_FILTER", value: 182, isUnsigned: true)
!264 = !DIEnumerator(name: "_SC_TRACE_INHERIT", value: 183, isUnsigned: true)
!265 = !DIEnumerator(name: "_SC_TRACE_LOG", value: 184, isUnsigned: true)
!266 = !DIEnumerator(name: "_SC_LEVEL1_ICACHE_SIZE", value: 185, isUnsigned: true)
!267 = !DIEnumerator(name: "_SC_LEVEL1_ICACHE_ASSOC", value: 186, isUnsigned: true)
!268 = !DIEnumerator(name: "_SC_LEVEL1_ICACHE_LINESIZE", value: 187, isUnsigned: true)
!269 = !DIEnumerator(name: "_SC_LEVEL1_DCACHE_SIZE", value: 188, isUnsigned: true)
!270 = !DIEnumerator(name: "_SC_LEVEL1_DCACHE_ASSOC", value: 189, isUnsigned: true)
!271 = !DIEnumerator(name: "_SC_LEVEL1_DCACHE_LINESIZE", value: 190, isUnsigned: true)
!272 = !DIEnumerator(name: "_SC_LEVEL2_CACHE_SIZE", value: 191, isUnsigned: true)
!273 = !DIEnumerator(name: "_SC_LEVEL2_CACHE_ASSOC", value: 192, isUnsigned: true)
!274 = !DIEnumerator(name: "_SC_LEVEL2_CACHE_LINESIZE", value: 193, isUnsigned: true)
!275 = !DIEnumerator(name: "_SC_LEVEL3_CACHE_SIZE", value: 194, isUnsigned: true)
!276 = !DIEnumerator(name: "_SC_LEVEL3_CACHE_ASSOC", value: 195, isUnsigned: true)
!277 = !DIEnumerator(name: "_SC_LEVEL3_CACHE_LINESIZE", value: 196, isUnsigned: true)
!278 = !DIEnumerator(name: "_SC_LEVEL4_CACHE_SIZE", value: 197, isUnsigned: true)
!279 = !DIEnumerator(name: "_SC_LEVEL4_CACHE_ASSOC", value: 198, isUnsigned: true)
!280 = !DIEnumerator(name: "_SC_LEVEL4_CACHE_LINESIZE", value: 199, isUnsigned: true)
!281 = !DIEnumerator(name: "_SC_IPV6", value: 235, isUnsigned: true)
!282 = !DIEnumerator(name: "_SC_RAW_SOCKETS", value: 236, isUnsigned: true)
!283 = !DIEnumerator(name: "_SC_V7_ILP32_OFF32", value: 237, isUnsigned: true)
!284 = !DIEnumerator(name: "_SC_V7_ILP32_OFFBIG", value: 238, isUnsigned: true)
!285 = !DIEnumerator(name: "_SC_V7_LP64_OFF64", value: 239, isUnsigned: true)
!286 = !DIEnumerator(name: "_SC_V7_LPBIG_OFFBIG", value: 240, isUnsigned: true)
!287 = !DIEnumerator(name: "_SC_SS_REPL_MAX", value: 241, isUnsigned: true)
!288 = !DIEnumerator(name: "_SC_TRACE_EVENT_NAME_MAX", value: 242, isUnsigned: true)
!289 = !DIEnumerator(name: "_SC_TRACE_NAME_MAX", value: 243, isUnsigned: true)
!290 = !DIEnumerator(name: "_SC_TRACE_SYS_MAX", value: 244, isUnsigned: true)
!291 = !DIEnumerator(name: "_SC_TRACE_USER_EVENT_MAX", value: 245, isUnsigned: true)
!292 = !DIEnumerator(name: "_SC_XOPEN_STREAMS", value: 246, isUnsigned: true)
!293 = !DIEnumerator(name: "_SC_THREAD_ROBUST_PRIO_INHERIT", value: 247, isUnsigned: true)
!294 = !DIEnumerator(name: "_SC_THREAD_ROBUST_PRIO_PROTECT", value: 248, isUnsigned: true)
!295 = !{!296, !297}
!296 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!297 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!298 = !{!"clang version 8.0.1-9 (tags/RELEASE_801/final)"}
!299 = !{i32 2, !"Dwarf Version", i32 4}
!300 = !{i32 2, !"Debug Info Version", i32 3}
!301 = !{i32 1, !"wchar_size", i32 4}
!302 = distinct !DISubprogram(name: "fib", scope: !3, file: !3, line: 26, type: !303, scopeLine: 27, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !305)
!303 = !DISubroutineType(types: !304)
!304 = !{!13, !24}
!305 = !{}
!306 = !DILocalVariable(name: "n", arg: 1, scope: !302, file: !3, line: 26, type: !24)
!307 = !DILocation(line: 26, column: 20, scope: !302)
!308 = !DILocalVariable(name: "x", scope: !302, file: !3, line: 28, type: !13)
!309 = !DILocation(line: 28, column: 12, scope: !302)
!310 = !DILocalVariable(name: "y", scope: !302, file: !3, line: 28, type: !13)
!311 = !DILocation(line: 28, column: 15, scope: !302)
!312 = !DILocation(line: 29, column: 6, scope: !313)
!313 = distinct !DILexicalBlock(scope: !302, file: !3, line: 29, column: 6)
!314 = !DILocation(line: 29, column: 8, scope: !313)
!315 = !DILocation(line: 29, column: 6, scope: !302)
!316 = !DILocation(line: 29, column: 20, scope: !313)
!317 = !DILocation(line: 29, column: 13, scope: !313)
!318 = !DILocation(line: 31, column: 10, scope: !302)
!319 = !DILocation(line: 31, column: 12, scope: !302)
!320 = !DILocation(line: 31, column: 6, scope: !302)
!321 = !DILocation(line: 31, column: 4, scope: !302)
!322 = !DILocation(line: 32, column: 10, scope: !302)
!323 = !DILocation(line: 32, column: 12, scope: !302)
!324 = !DILocation(line: 32, column: 6, scope: !302)
!325 = !DILocation(line: 32, column: 4, scope: !302)
!326 = !DILocation(line: 34, column: 9, scope: !302)
!327 = !DILocation(line: 34, column: 13, scope: !302)
!328 = !DILocation(line: 34, column: 11, scope: !302)
!329 = !DILocation(line: 34, column: 2, scope: !302)
!330 = !DILocation(line: 35, column: 1, scope: !302)
!331 = distinct !DISubprogram(name: "fib0", scope: !3, file: !3, line: 37, type: !332, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !305)
!332 = !DISubroutineType(types: !333)
!333 = !{null, !24}
!334 = !DILocalVariable(name: "n", arg: 1, scope: !331, file: !3, line: 37, type: !24)
!335 = !DILocation(line: 37, column: 16, scope: !331)
!336 = !DILocation(line: 39, column: 12, scope: !331)
!337 = !DILocation(line: 39, column: 8, scope: !331)
!338 = !DILocation(line: 39, column: 6, scope: !331)
!339 = !DILocation(line: 40, column: 2, scope: !340)
!340 = distinct !DILexicalBlock(scope: !341, file: !3, line: 40, column: 2)
!341 = distinct !DILexicalBlock(scope: !331, file: !3, line: 40, column: 2)
!342 = !DILocation(line: 40, column: 2, scope: !341)
!343 = !DILocation(line: 40, column: 2, scope: !344)
!344 = distinct !DILexicalBlock(scope: !340, file: !3, line: 40, column: 2)
!345 = !DILocation(line: 41, column: 1, scope: !331)
!346 = distinct !DISubprogram(name: "bots_error", scope: !75, file: !75, line: 35, type: !347, scopeLine: 36, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !74, retainedNodes: !305)
!347 = !DISubroutineType(types: !348)
!348 = !{null, !24, !349}
!349 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !45, size: 64)
!350 = !DILocalVariable(name: "error", arg: 1, scope: !346, file: !75, line: 35, type: !24)
!351 = !DILocation(line: 35, column: 16, scope: !346)
!352 = !DILocalVariable(name: "message", arg: 2, scope: !346, file: !75, line: 35, type: !349)
!353 = !DILocation(line: 35, column: 29, scope: !346)
!354 = !DILocation(line: 37, column: 8, scope: !355)
!355 = distinct !DILexicalBlock(scope: !346, file: !75, line: 37, column: 8)
!356 = !DILocation(line: 37, column: 16, scope: !355)
!357 = !DILocation(line: 37, column: 8, scope: !346)
!358 = !DILocation(line: 39, column: 14, scope: !359)
!359 = distinct !DILexicalBlock(scope: !355, file: !75, line: 38, column: 4)
!360 = !DILocation(line: 39, column: 7, scope: !359)
!361 = !DILocation(line: 42, column: 21, scope: !362)
!362 = distinct !DILexicalBlock(scope: !359, file: !75, line: 40, column: 7)
!363 = !DILocation(line: 42, column: 48, scope: !362)
!364 = !DILocation(line: 42, column: 13, scope: !362)
!365 = !DILocation(line: 43, column: 13, scope: !362)
!366 = !DILocation(line: 45, column: 21, scope: !362)
!367 = !DILocation(line: 45, column: 48, scope: !362)
!368 = !DILocation(line: 45, column: 13, scope: !362)
!369 = !DILocation(line: 46, column: 13, scope: !362)
!370 = !DILocation(line: 48, column: 21, scope: !362)
!371 = !DILocation(line: 48, column: 48, scope: !362)
!372 = !DILocation(line: 48, column: 13, scope: !362)
!373 = !DILocation(line: 49, column: 13, scope: !362)
!374 = !DILocation(line: 50, column: 13, scope: !362)
!375 = !DILocation(line: 52, column: 21, scope: !362)
!376 = !DILocation(line: 52, column: 48, scope: !362)
!377 = !DILocation(line: 52, column: 13, scope: !362)
!378 = !DILocation(line: 53, column: 13, scope: !362)
!379 = !DILocation(line: 55, column: 4, scope: !359)
!380 = !DILocation(line: 56, column: 17, scope: !355)
!381 = !DILocation(line: 56, column: 44, scope: !355)
!382 = !DILocation(line: 56, column: 50, scope: !355)
!383 = !DILocation(line: 56, column: 9, scope: !355)
!384 = !DILocation(line: 57, column: 13, scope: !346)
!385 = !DILocation(line: 57, column: 12, scope: !346)
!386 = !DILocation(line: 57, column: 4, scope: !346)
!387 = !DILocation(line: 58, column: 1, scope: !346)
!388 = distinct !DISubprogram(name: "bots_warning", scope: !75, file: !75, line: 61, type: !347, scopeLine: 62, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !74, retainedNodes: !305)
!389 = !DILocalVariable(name: "warning", arg: 1, scope: !388, file: !75, line: 61, type: !24)
!390 = !DILocation(line: 61, column: 18, scope: !388)
!391 = !DILocalVariable(name: "message", arg: 2, scope: !388, file: !75, line: 61, type: !349)
!392 = !DILocation(line: 61, column: 33, scope: !388)
!393 = !DILocation(line: 63, column: 8, scope: !394)
!394 = distinct !DILexicalBlock(scope: !388, file: !75, line: 63, column: 8)
!395 = !DILocation(line: 63, column: 16, scope: !394)
!396 = !DILocation(line: 63, column: 8, scope: !388)
!397 = !DILocation(line: 65, column: 14, scope: !398)
!398 = distinct !DILexicalBlock(scope: !394, file: !75, line: 64, column: 4)
!399 = !DILocation(line: 65, column: 7, scope: !398)
!400 = !DILocation(line: 68, column: 21, scope: !401)
!401 = distinct !DILexicalBlock(scope: !398, file: !75, line: 66, column: 7)
!402 = !DILocation(line: 68, column: 50, scope: !401)
!403 = !DILocation(line: 68, column: 13, scope: !401)
!404 = !DILocation(line: 69, column: 13, scope: !401)
!405 = !DILocation(line: 71, column: 21, scope: !401)
!406 = !DILocation(line: 71, column: 50, scope: !401)
!407 = !DILocation(line: 71, column: 13, scope: !401)
!408 = !DILocation(line: 72, column: 13, scope: !401)
!409 = !DILocation(line: 74, column: 4, scope: !398)
!410 = !DILocation(line: 75, column: 17, scope: !394)
!411 = !DILocation(line: 75, column: 46, scope: !394)
!412 = !DILocation(line: 75, column: 54, scope: !394)
!413 = !DILocation(line: 75, column: 9, scope: !394)
!414 = !DILocation(line: 76, column: 1, scope: !388)
!415 = distinct !DISubprogram(name: "bots_usecs", scope: !75, file: !75, line: 78, type: !416, scopeLine: 79, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !74, retainedNodes: !305)
!416 = !DISubroutineType(types: !417)
!417 = !{!418}
!418 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!419 = !DILocalVariable(name: "t", scope: !415, file: !75, line: 80, type: !420)
!420 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "timeval", file: !421, line: 8, size: 128, elements: !422)
!421 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/struct_timeval.h", directory: "")
!422 = !{!423, !426}
!423 = !DIDerivedType(tag: DW_TAG_member, name: "tv_sec", scope: !420, file: !421, line: 10, baseType: !424, size: 64)
!424 = !DIDerivedType(tag: DW_TAG_typedef, name: "__time_t", file: !425, line: 160, baseType: !418)
!425 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!426 = !DIDerivedType(tag: DW_TAG_member, name: "tv_usec", scope: !420, file: !421, line: 11, baseType: !427, size: 64, offset: 64)
!427 = !DIDerivedType(tag: DW_TAG_typedef, name: "__suseconds_t", file: !425, line: 162, baseType: !418)
!428 = !DILocation(line: 80, column: 19, scope: !415)
!429 = !DILocation(line: 81, column: 4, scope: !415)
!430 = !DILocation(line: 82, column: 13, scope: !415)
!431 = !DILocation(line: 82, column: 19, scope: !415)
!432 = !DILocation(line: 82, column: 30, scope: !415)
!433 = !DILocation(line: 82, column: 27, scope: !415)
!434 = !DILocation(line: 82, column: 4, scope: !415)
!435 = distinct !DISubprogram(name: "bots_get_date", scope: !75, file: !75, line: 86, type: !436, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !74, retainedNodes: !305)
!436 = !DISubroutineType(types: !437)
!437 = !{null, !349}
!438 = !DILocalVariable(name: "str", arg: 1, scope: !435, file: !75, line: 86, type: !349)
!439 = !DILocation(line: 86, column: 21, scope: !435)
!440 = !DILocalVariable(name: "now", scope: !435, file: !75, line: 88, type: !441)
!441 = !DIDerivedType(tag: DW_TAG_typedef, name: "time_t", file: !442, line: 7, baseType: !424)
!442 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/time_t.h", directory: "")
!443 = !DILocation(line: 88, column: 11, scope: !435)
!444 = !DILocation(line: 89, column: 4, scope: !435)
!445 = !DILocation(line: 90, column: 13, scope: !435)
!446 = !DILocation(line: 90, column: 40, scope: !435)
!447 = !DILocation(line: 90, column: 4, scope: !435)
!448 = !DILocation(line: 91, column: 1, scope: !435)
!449 = distinct !DISubprogram(name: "bots_get_architecture", scope: !75, file: !75, line: 93, type: !436, scopeLine: 94, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !74, retainedNodes: !305)
!450 = !DILocalVariable(name: "str", arg: 1, scope: !449, file: !75, line: 93, type: !349)
!451 = !DILocation(line: 93, column: 34, scope: !449)
!452 = !DILocalVariable(name: "ncpus", scope: !449, file: !75, line: 95, type: !24)
!453 = !DILocation(line: 95, column: 8, scope: !449)
!454 = !DILocation(line: 95, column: 16, scope: !449)
!455 = !DILocalVariable(name: "architecture", scope: !449, file: !75, line: 96, type: !456)
!456 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "utsname", file: !457, line: 48, size: 3120, elements: !458)
!457 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/sys/utsname.h", directory: "")
!458 = !{!459, !463, !464, !465, !466, !467}
!459 = !DIDerivedType(tag: DW_TAG_member, name: "sysname", scope: !456, file: !457, line: 51, baseType: !460, size: 520)
!460 = !DICompositeType(tag: DW_TAG_array_type, baseType: !45, size: 520, elements: !461)
!461 = !{!462}
!462 = !DISubrange(count: 65)
!463 = !DIDerivedType(tag: DW_TAG_member, name: "nodename", scope: !456, file: !457, line: 54, baseType: !460, size: 520, offset: 520)
!464 = !DIDerivedType(tag: DW_TAG_member, name: "release", scope: !456, file: !457, line: 57, baseType: !460, size: 520, offset: 1040)
!465 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !456, file: !457, line: 59, baseType: !460, size: 520, offset: 1560)
!466 = !DIDerivedType(tag: DW_TAG_member, name: "machine", scope: !456, file: !457, line: 62, baseType: !460, size: 520, offset: 2080)
!467 = !DIDerivedType(tag: DW_TAG_member, name: "__domainname", scope: !456, file: !457, line: 69, baseType: !460, size: 520, offset: 2600)
!468 = !DILocation(line: 96, column: 19, scope: !449)
!469 = !DILocation(line: 98, column: 4, scope: !449)
!470 = !DILocation(line: 99, column: 13, scope: !449)
!471 = !DILocation(line: 99, column: 60, scope: !449)
!472 = !DILocation(line: 99, column: 47, scope: !449)
!473 = !DILocation(line: 99, column: 82, scope: !449)
!474 = !DILocation(line: 99, column: 69, scope: !449)
!475 = !DILocation(line: 99, column: 91, scope: !449)
!476 = !DILocation(line: 99, column: 4, scope: !449)
!477 = !DILocation(line: 100, column: 1, scope: !449)
!478 = distinct !DISubprogram(name: "bots_get_load_average", scope: !75, file: !75, line: 104, type: !436, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !74, retainedNodes: !305)
!479 = !DILocalVariable(name: "str", arg: 1, scope: !478, file: !75, line: 104, type: !349)
!480 = !DILocation(line: 104, column: 34, scope: !478)
!481 = !DILocalVariable(name: "loadavg", scope: !478, file: !75, line: 106, type: !482)
!482 = !DICompositeType(tag: DW_TAG_array_type, baseType: !20, size: 192, elements: !483)
!483 = !{!484}
!484 = !DISubrange(count: 3)
!485 = !DILocation(line: 106, column: 11, scope: !478)
!486 = !DILocation(line: 107, column: 16, scope: !478)
!487 = !DILocation(line: 107, column: 4, scope: !478)
!488 = !DILocation(line: 108, column: 13, scope: !478)
!489 = !DILocation(line: 108, column: 52, scope: !478)
!490 = !DILocation(line: 108, column: 63, scope: !478)
!491 = !DILocation(line: 108, column: 74, scope: !478)
!492 = !DILocation(line: 108, column: 4, scope: !478)
!493 = !DILocation(line: 109, column: 1, scope: !478)
!494 = distinct !DISubprogram(name: "bots_print_results", scope: !75, file: !75, line: 115, type: !495, scopeLine: 116, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !74, retainedNodes: !305)
!495 = !DISubroutineType(types: !496)
!496 = !{null}
!497 = !DILocalVariable(name: "str_name", scope: !494, file: !75, line: 117, type: !44)
!498 = !DILocation(line: 117, column: 9, scope: !494)
!499 = !DILocalVariable(name: "str_parameters", scope: !494, file: !75, line: 118, type: !44)
!500 = !DILocation(line: 118, column: 9, scope: !494)
!501 = !DILocalVariable(name: "str_model", scope: !494, file: !75, line: 119, type: !44)
!502 = !DILocation(line: 119, column: 9, scope: !494)
!503 = !DILocalVariable(name: "str_resources", scope: !494, file: !75, line: 120, type: !44)
!504 = !DILocation(line: 120, column: 9, scope: !494)
!505 = !DILocalVariable(name: "str_result", scope: !494, file: !75, line: 121, type: !506)
!506 = !DICompositeType(tag: DW_TAG_array_type, baseType: !45, size: 120, elements: !507)
!507 = !{!508}
!508 = !DISubrange(count: 15)
!509 = !DILocation(line: 121, column: 9, scope: !494)
!510 = !DILocalVariable(name: "str_time_program", scope: !494, file: !75, line: 122, type: !506)
!511 = !DILocation(line: 122, column: 9, scope: !494)
!512 = !DILocalVariable(name: "str_time_sequential", scope: !494, file: !75, line: 123, type: !506)
!513 = !DILocation(line: 123, column: 9, scope: !494)
!514 = !DILocalVariable(name: "str_speed_up", scope: !494, file: !75, line: 124, type: !506)
!515 = !DILocation(line: 124, column: 9, scope: !494)
!516 = !DILocalVariable(name: "str_number_of_tasks", scope: !494, file: !75, line: 125, type: !506)
!517 = !DILocation(line: 125, column: 9, scope: !494)
!518 = !DILocalVariable(name: "str_number_of_tasks_per_second", scope: !494, file: !75, line: 126, type: !506)
!519 = !DILocation(line: 126, column: 9, scope: !494)
!520 = !DILocalVariable(name: "str_exec_date", scope: !494, file: !75, line: 127, type: !44)
!521 = !DILocation(line: 127, column: 9, scope: !494)
!522 = !DILocalVariable(name: "str_exec_message", scope: !494, file: !75, line: 128, type: !44)
!523 = !DILocation(line: 128, column: 9, scope: !494)
!524 = !DILocalVariable(name: "str_architecture", scope: !494, file: !75, line: 129, type: !44)
!525 = !DILocation(line: 129, column: 9, scope: !494)
!526 = !DILocalVariable(name: "str_load_avg", scope: !494, file: !75, line: 130, type: !44)
!527 = !DILocation(line: 130, column: 9, scope: !494)
!528 = !DILocalVariable(name: "str_comp_date", scope: !494, file: !75, line: 131, type: !44)
!529 = !DILocation(line: 131, column: 9, scope: !494)
!530 = !DILocalVariable(name: "str_comp_message", scope: !494, file: !75, line: 132, type: !44)
!531 = !DILocation(line: 132, column: 9, scope: !494)
!532 = !DILocalVariable(name: "str_cc", scope: !494, file: !75, line: 133, type: !44)
!533 = !DILocation(line: 133, column: 9, scope: !494)
!534 = !DILocalVariable(name: "str_cflags", scope: !494, file: !75, line: 134, type: !44)
!535 = !DILocation(line: 134, column: 9, scope: !494)
!536 = !DILocalVariable(name: "str_ld", scope: !494, file: !75, line: 135, type: !44)
!537 = !DILocation(line: 135, column: 9, scope: !494)
!538 = !DILocalVariable(name: "str_ldflags", scope: !494, file: !75, line: 136, type: !44)
!539 = !DILocation(line: 136, column: 9, scope: !494)
!540 = !DILocalVariable(name: "str_cutoff", scope: !494, file: !75, line: 137, type: !44)
!541 = !DILocation(line: 137, column: 9, scope: !494)
!542 = !DILocation(line: 140, column: 12, scope: !494)
!543 = !DILocation(line: 140, column: 4, scope: !494)
!544 = !DILocation(line: 141, column: 12, scope: !494)
!545 = !DILocation(line: 141, column: 4, scope: !494)
!546 = !DILocation(line: 142, column: 12, scope: !494)
!547 = !DILocation(line: 142, column: 4, scope: !494)
!548 = !DILocation(line: 143, column: 12, scope: !494)
!549 = !DILocation(line: 143, column: 4, scope: !494)
!550 = !DILocation(line: 144, column: 12, scope: !494)
!551 = !DILocation(line: 144, column: 4, scope: !494)
!552 = !DILocation(line: 145, column: 11, scope: !494)
!553 = !DILocation(line: 145, column: 4, scope: !494)
!554 = !DILocation(line: 148, column: 18, scope: !555)
!555 = distinct !DILexicalBlock(scope: !494, file: !75, line: 146, column: 4)
!556 = !DILocation(line: 148, column: 10, scope: !555)
!557 = !DILocation(line: 149, column: 10, scope: !555)
!558 = !DILocation(line: 151, column: 18, scope: !555)
!559 = !DILocation(line: 151, column: 10, scope: !555)
!560 = !DILocation(line: 152, column: 10, scope: !555)
!561 = !DILocation(line: 154, column: 18, scope: !555)
!562 = !DILocation(line: 154, column: 10, scope: !555)
!563 = !DILocation(line: 155, column: 10, scope: !555)
!564 = !DILocation(line: 157, column: 18, scope: !555)
!565 = !DILocation(line: 157, column: 10, scope: !555)
!566 = !DILocation(line: 158, column: 10, scope: !555)
!567 = !DILocation(line: 160, column: 18, scope: !555)
!568 = !DILocation(line: 160, column: 10, scope: !555)
!569 = !DILocation(line: 161, column: 10, scope: !555)
!570 = !DILocation(line: 163, column: 12, scope: !494)
!571 = !DILocation(line: 163, column: 36, scope: !494)
!572 = !DILocation(line: 163, column: 4, scope: !494)
!573 = !DILocation(line: 164, column: 8, scope: !574)
!574 = distinct !DILexicalBlock(scope: !494, file: !75, line: 164, column: 8)
!575 = !DILocation(line: 164, column: 8, scope: !494)
!576 = !DILocation(line: 164, column: 38, scope: !574)
!577 = !DILocation(line: 164, column: 65, scope: !574)
!578 = !DILocation(line: 164, column: 30, scope: !574)
!579 = !DILocation(line: 165, column: 17, scope: !574)
!580 = !DILocation(line: 165, column: 9, scope: !574)
!581 = !DILocation(line: 166, column: 8, scope: !582)
!582 = distinct !DILexicalBlock(scope: !494, file: !75, line: 166, column: 8)
!583 = !DILocation(line: 166, column: 8, scope: !494)
!584 = !DILocation(line: 167, column: 12, scope: !582)
!585 = !DILocation(line: 167, column: 35, scope: !582)
!586 = !DILocation(line: 167, column: 56, scope: !582)
!587 = !DILocation(line: 167, column: 55, scope: !582)
!588 = !DILocation(line: 167, column: 4, scope: !582)
!589 = !DILocation(line: 168, column: 17, scope: !582)
!590 = !DILocation(line: 168, column: 9, scope: !582)
!591 = !DILocation(line: 170, column: 12, scope: !494)
!592 = !DILocation(line: 170, column: 50, scope: !494)
!593 = !DILocation(line: 170, column: 42, scope: !494)
!594 = !DILocation(line: 170, column: 4, scope: !494)
!595 = !DILocation(line: 171, column: 12, scope: !494)
!596 = !DILocation(line: 171, column: 61, scope: !494)
!597 = !DILocation(line: 171, column: 53, scope: !494)
!598 = !DILocation(line: 171, column: 82, scope: !494)
!599 = !DILocation(line: 171, column: 81, scope: !494)
!600 = !DILocation(line: 171, column: 4, scope: !494)
!601 = !DILocation(line: 173, column: 12, scope: !494)
!602 = !DILocation(line: 173, column: 4, scope: !494)
!603 = !DILocation(line: 174, column: 12, scope: !494)
!604 = !DILocation(line: 174, column: 4, scope: !494)
!605 = !DILocation(line: 175, column: 26, scope: !494)
!606 = !DILocation(line: 175, column: 4, scope: !494)
!607 = !DILocation(line: 176, column: 26, scope: !494)
!608 = !DILocation(line: 176, column: 4, scope: !494)
!609 = !DILocation(line: 177, column: 12, scope: !494)
!610 = !DILocation(line: 177, column: 4, scope: !494)
!611 = !DILocation(line: 178, column: 12, scope: !494)
!612 = !DILocation(line: 178, column: 4, scope: !494)
!613 = !DILocation(line: 179, column: 12, scope: !494)
!614 = !DILocation(line: 179, column: 4, scope: !494)
!615 = !DILocation(line: 180, column: 12, scope: !494)
!616 = !DILocation(line: 180, column: 4, scope: !494)
!617 = !DILocation(line: 181, column: 12, scope: !494)
!618 = !DILocation(line: 181, column: 4, scope: !494)
!619 = !DILocation(line: 182, column: 12, scope: !494)
!620 = !DILocation(line: 182, column: 4, scope: !494)
!621 = !DILocation(line: 184, column: 7, scope: !622)
!622 = distinct !DILexicalBlock(scope: !494, file: !75, line: 184, column: 7)
!623 = !DILocation(line: 184, column: 7, scope: !494)
!624 = !DILocation(line: 186, column: 14, scope: !625)
!625 = distinct !DILexicalBlock(scope: !622, file: !75, line: 185, column: 4)
!626 = !DILocation(line: 186, column: 7, scope: !625)
!627 = !DILocation(line: 189, column: 13, scope: !628)
!628 = distinct !DILexicalBlock(scope: !625, file: !75, line: 187, column: 7)
!629 = !DILocation(line: 191, column: 13, scope: !628)
!630 = !DILocation(line: 193, column: 9, scope: !628)
!631 = !DILocation(line: 193, column: 1, scope: !628)
!632 = !DILocation(line: 200, column: 13, scope: !628)
!633 = !DILocation(line: 202, column: 13, scope: !628)
!634 = !DILocation(line: 204, column: 9, scope: !628)
!635 = !DILocation(line: 204, column: 1, scope: !628)
!636 = !DILocation(line: 208, column: 13, scope: !628)
!637 = !DILocation(line: 210, column: 13, scope: !628)
!638 = !DILocation(line: 212, column: 4, scope: !625)
!639 = !DILocation(line: 215, column: 11, scope: !494)
!640 = !DILocation(line: 215, column: 4, scope: !494)
!641 = !DILocation(line: 218, column: 10, scope: !642)
!642 = distinct !DILexicalBlock(scope: !494, file: !75, line: 216, column: 4)
!643 = !DILocation(line: 220, column: 11, scope: !642)
!644 = !DILocation(line: 220, column: 3, scope: !642)
!645 = !DILocation(line: 221, column: 18, scope: !642)
!646 = !DILocation(line: 221, column: 56, scope: !642)
!647 = !DILocation(line: 221, column: 10, scope: !642)
!648 = !DILocation(line: 222, column: 18, scope: !642)
!649 = !DILocation(line: 222, column: 56, scope: !642)
!650 = !DILocation(line: 222, column: 10, scope: !642)
!651 = !DILocation(line: 223, column: 18, scope: !642)
!652 = !DILocation(line: 223, column: 56, scope: !642)
!653 = !DILocation(line: 223, column: 10, scope: !642)
!654 = !DILocation(line: 224, column: 18, scope: !642)
!655 = !DILocation(line: 224, column: 56, scope: !642)
!656 = !DILocation(line: 224, column: 10, scope: !642)
!657 = !DILocation(line: 225, column: 18, scope: !642)
!658 = !DILocation(line: 225, column: 56, scope: !642)
!659 = !DILocation(line: 225, column: 10, scope: !642)
!660 = !DILocation(line: 226, column: 18, scope: !642)
!661 = !DILocation(line: 226, column: 56, scope: !642)
!662 = !DILocation(line: 226, column: 10, scope: !642)
!663 = !DILocation(line: 228, column: 18, scope: !642)
!664 = !DILocation(line: 228, column: 64, scope: !642)
!665 = !DILocation(line: 228, column: 10, scope: !642)
!666 = !DILocation(line: 229, column: 7, scope: !667)
!667 = distinct !DILexicalBlock(scope: !642, file: !75, line: 229, column: 7)
!668 = !DILocation(line: 229, column: 7, scope: !642)
!669 = !DILocation(line: 230, column: 20, scope: !670)
!670 = distinct !DILexicalBlock(scope: !667, file: !75, line: 229, column: 29)
!671 = !DILocation(line: 230, column: 66, scope: !670)
!672 = !DILocation(line: 230, column: 12, scope: !670)
!673 = !DILocation(line: 231, column: 20, scope: !670)
!674 = !DILocation(line: 231, column: 58, scope: !670)
!675 = !DILocation(line: 231, column: 12, scope: !670)
!676 = !DILocation(line: 232, column: 3, scope: !670)
!677 = !DILocation(line: 234, column: 15, scope: !678)
!678 = distinct !DILexicalBlock(scope: !642, file: !75, line: 234, column: 15)
!679 = !DILocation(line: 234, column: 36, scope: !678)
!680 = !DILocation(line: 234, column: 15, scope: !642)
!681 = !DILocation(line: 235, column: 20, scope: !682)
!682 = distinct !DILexicalBlock(scope: !678, file: !75, line: 234, column: 42)
!683 = !DILocation(line: 235, column: 58, scope: !682)
!684 = !DILocation(line: 235, column: 12, scope: !682)
!685 = !DILocation(line: 236, column: 20, scope: !682)
!686 = !DILocation(line: 236, column: 58, scope: !682)
!687 = !DILocation(line: 236, column: 12, scope: !682)
!688 = !DILocation(line: 237, column: 3, scope: !682)
!689 = !DILocation(line: 239, column: 18, scope: !642)
!690 = !DILocation(line: 239, column: 56, scope: !642)
!691 = !DILocation(line: 239, column: 10, scope: !642)
!692 = !DILocation(line: 240, column: 18, scope: !642)
!693 = !DILocation(line: 240, column: 56, scope: !642)
!694 = !DILocation(line: 240, column: 10, scope: !642)
!695 = !DILocation(line: 242, column: 18, scope: !642)
!696 = !DILocation(line: 242, column: 56, scope: !642)
!697 = !DILocation(line: 242, column: 10, scope: !642)
!698 = !DILocation(line: 243, column: 18, scope: !642)
!699 = !DILocation(line: 243, column: 56, scope: !642)
!700 = !DILocation(line: 243, column: 10, scope: !642)
!701 = !DILocation(line: 245, column: 18, scope: !642)
!702 = !DILocation(line: 245, column: 56, scope: !642)
!703 = !DILocation(line: 245, column: 10, scope: !642)
!704 = !DILocation(line: 246, column: 18, scope: !642)
!705 = !DILocation(line: 246, column: 56, scope: !642)
!706 = !DILocation(line: 246, column: 10, scope: !642)
!707 = !DILocation(line: 248, column: 18, scope: !642)
!708 = !DILocation(line: 248, column: 56, scope: !642)
!709 = !DILocation(line: 248, column: 10, scope: !642)
!710 = !DILocation(line: 249, column: 18, scope: !642)
!711 = !DILocation(line: 249, column: 56, scope: !642)
!712 = !DILocation(line: 249, column: 10, scope: !642)
!713 = !DILocation(line: 250, column: 18, scope: !642)
!714 = !DILocation(line: 250, column: 56, scope: !642)
!715 = !DILocation(line: 250, column: 10, scope: !642)
!716 = !DILocation(line: 251, column: 18, scope: !642)
!717 = !DILocation(line: 251, column: 56, scope: !642)
!718 = !DILocation(line: 251, column: 10, scope: !642)
!719 = !DILocation(line: 252, column: 10, scope: !642)
!720 = !DILocation(line: 252, column: 3, scope: !642)
!721 = !DILocation(line: 253, column: 10, scope: !642)
!722 = !DILocation(line: 255, column: 18, scope: !642)
!723 = !DILocation(line: 256, column: 15, scope: !642)
!724 = !DILocation(line: 257, column: 15, scope: !642)
!725 = !DILocation(line: 258, column: 15, scope: !642)
!726 = !DILocation(line: 259, column: 15, scope: !642)
!727 = !DILocation(line: 260, column: 15, scope: !642)
!728 = !DILocation(line: 261, column: 15, scope: !642)
!729 = !DILocation(line: 255, column: 10, scope: !642)
!730 = !DILocation(line: 263, column: 18, scope: !642)
!731 = !DILocation(line: 264, column: 15, scope: !642)
!732 = !DILocation(line: 265, column: 15, scope: !642)
!733 = !DILocation(line: 266, column: 15, scope: !642)
!734 = !DILocation(line: 263, column: 10, scope: !642)
!735 = !DILocation(line: 268, column: 18, scope: !642)
!736 = !DILocation(line: 269, column: 15, scope: !642)
!737 = !DILocation(line: 270, column: 15, scope: !642)
!738 = !DILocation(line: 268, column: 10, scope: !642)
!739 = !DILocation(line: 272, column: 18, scope: !642)
!740 = !DILocation(line: 273, column: 15, scope: !642)
!741 = !DILocation(line: 274, column: 15, scope: !642)
!742 = !DILocation(line: 272, column: 10, scope: !642)
!743 = !DILocation(line: 276, column: 18, scope: !642)
!744 = !DILocation(line: 277, column: 15, scope: !642)
!745 = !DILocation(line: 278, column: 15, scope: !642)
!746 = !DILocation(line: 276, column: 10, scope: !642)
!747 = !DILocation(line: 280, column: 18, scope: !642)
!748 = !DILocation(line: 281, column: 15, scope: !642)
!749 = !DILocation(line: 282, column: 15, scope: !642)
!750 = !DILocation(line: 280, column: 10, scope: !642)
!751 = !DILocation(line: 284, column: 18, scope: !642)
!752 = !DILocation(line: 285, column: 15, scope: !642)
!753 = !DILocation(line: 286, column: 15, scope: !642)
!754 = !DILocation(line: 287, column: 15, scope: !642)
!755 = !DILocation(line: 288, column: 15, scope: !642)
!756 = !DILocation(line: 284, column: 10, scope: !642)
!757 = !DILocation(line: 290, column: 18, scope: !642)
!758 = !DILocation(line: 290, column: 10, scope: !642)
!759 = !DILocation(line: 291, column: 10, scope: !642)
!760 = !DILocation(line: 293, column: 11, scope: !642)
!761 = !DILocation(line: 293, column: 3, scope: !642)
!762 = !DILocation(line: 294, column: 18, scope: !642)
!763 = !DILocation(line: 294, column: 56, scope: !642)
!764 = !DILocation(line: 294, column: 10, scope: !642)
!765 = !DILocation(line: 295, column: 18, scope: !642)
!766 = !DILocation(line: 295, column: 56, scope: !642)
!767 = !DILocation(line: 295, column: 10, scope: !642)
!768 = !DILocation(line: 296, column: 18, scope: !642)
!769 = !DILocation(line: 296, column: 56, scope: !642)
!770 = !DILocation(line: 296, column: 10, scope: !642)
!771 = !DILocation(line: 297, column: 18, scope: !642)
!772 = !DILocation(line: 297, column: 56, scope: !642)
!773 = !DILocation(line: 297, column: 10, scope: !642)
!774 = !DILocation(line: 298, column: 18, scope: !642)
!775 = !DILocation(line: 298, column: 56, scope: !642)
!776 = !DILocation(line: 298, column: 10, scope: !642)
!777 = !DILocation(line: 299, column: 18, scope: !642)
!778 = !DILocation(line: 299, column: 56, scope: !642)
!779 = !DILocation(line: 299, column: 10, scope: !642)
!780 = !DILocation(line: 301, column: 18, scope: !642)
!781 = !DILocation(line: 301, column: 64, scope: !642)
!782 = !DILocation(line: 301, column: 10, scope: !642)
!783 = !DILocation(line: 302, column: 7, scope: !784)
!784 = distinct !DILexicalBlock(scope: !642, file: !75, line: 302, column: 7)
!785 = !DILocation(line: 302, column: 7, scope: !642)
!786 = !DILocation(line: 303, column: 20, scope: !787)
!787 = distinct !DILexicalBlock(scope: !784, file: !75, line: 302, column: 29)
!788 = !DILocation(line: 303, column: 66, scope: !787)
!789 = !DILocation(line: 303, column: 12, scope: !787)
!790 = !DILocation(line: 304, column: 20, scope: !787)
!791 = !DILocation(line: 304, column: 58, scope: !787)
!792 = !DILocation(line: 304, column: 12, scope: !787)
!793 = !DILocation(line: 305, column: 3, scope: !787)
!794 = !DILocation(line: 307, column: 15, scope: !795)
!795 = distinct !DILexicalBlock(scope: !642, file: !75, line: 307, column: 15)
!796 = !DILocation(line: 307, column: 36, scope: !795)
!797 = !DILocation(line: 307, column: 15, scope: !642)
!798 = !DILocation(line: 308, column: 20, scope: !799)
!799 = distinct !DILexicalBlock(scope: !795, file: !75, line: 307, column: 42)
!800 = !DILocation(line: 308, column: 58, scope: !799)
!801 = !DILocation(line: 308, column: 12, scope: !799)
!802 = !DILocation(line: 309, column: 20, scope: !799)
!803 = !DILocation(line: 309, column: 58, scope: !799)
!804 = !DILocation(line: 309, column: 12, scope: !799)
!805 = !DILocation(line: 310, column: 3, scope: !799)
!806 = !DILocation(line: 311, column: 10, scope: !642)
!807 = !DILocation(line: 313, column: 18, scope: !642)
!808 = !DILocation(line: 314, column: 15, scope: !642)
!809 = !DILocation(line: 315, column: 15, scope: !642)
!810 = !DILocation(line: 316, column: 15, scope: !642)
!811 = !DILocation(line: 317, column: 15, scope: !642)
!812 = !DILocation(line: 318, column: 15, scope: !642)
!813 = !DILocation(line: 319, column: 15, scope: !642)
!814 = !DILocation(line: 313, column: 10, scope: !642)
!815 = !DILocation(line: 321, column: 18, scope: !642)
!816 = !DILocation(line: 322, column: 15, scope: !642)
!817 = !DILocation(line: 323, column: 15, scope: !642)
!818 = !DILocation(line: 324, column: 15, scope: !642)
!819 = !DILocation(line: 321, column: 10, scope: !642)
!820 = !DILocation(line: 326, column: 18, scope: !642)
!821 = !DILocation(line: 327, column: 15, scope: !642)
!822 = !DILocation(line: 328, column: 15, scope: !642)
!823 = !DILocation(line: 326, column: 10, scope: !642)
!824 = !DILocation(line: 330, column: 18, scope: !642)
!825 = !DILocation(line: 330, column: 10, scope: !642)
!826 = !DILocation(line: 331, column: 10, scope: !642)
!827 = !DILocation(line: 333, column: 10, scope: !642)
!828 = !DILocation(line: 334, column: 10, scope: !642)
!829 = !DILocation(line: 336, column: 1, scope: !494)
!830 = distinct !DISubprogram(name: "bots_print_usage", scope: !17, file: !17, line: 211, type: !495, scopeLine: 212, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !16, retainedNodes: !305)
!831 = !DILocation(line: 213, column: 12, scope: !830)
!832 = !DILocation(line: 213, column: 4, scope: !830)
!833 = !DILocation(line: 214, column: 12, scope: !830)
!834 = !DILocation(line: 214, column: 4, scope: !830)
!835 = !DILocation(line: 215, column: 12, scope: !830)
!836 = !DILocation(line: 215, column: 4, scope: !830)
!837 = !DILocation(line: 216, column: 12, scope: !830)
!838 = !DILocation(line: 216, column: 4, scope: !830)
!839 = !DILocation(line: 221, column: 12, scope: !830)
!840 = !DILocation(line: 221, column: 4, scope: !830)
!841 = !DILocation(line: 245, column: 12, scope: !830)
!842 = !DILocation(line: 245, column: 4, scope: !830)
!843 = !DILocation(line: 246, column: 12, scope: !830)
!844 = !DILocation(line: 246, column: 4, scope: !830)
!845 = !DILocation(line: 247, column: 12, scope: !830)
!846 = !DILocation(line: 247, column: 4, scope: !830)
!847 = !DILocation(line: 248, column: 12, scope: !830)
!848 = !DILocation(line: 248, column: 4, scope: !830)
!849 = !DILocation(line: 249, column: 12, scope: !830)
!850 = !DILocation(line: 249, column: 4, scope: !830)
!851 = !DILocation(line: 250, column: 12, scope: !830)
!852 = !DILocation(line: 250, column: 4, scope: !830)
!853 = !DILocation(line: 251, column: 12, scope: !830)
!854 = !DILocation(line: 251, column: 4, scope: !830)
!855 = !DILocation(line: 252, column: 12, scope: !830)
!856 = !DILocation(line: 252, column: 4, scope: !830)
!857 = !DILocation(line: 253, column: 12, scope: !830)
!858 = !DILocation(line: 253, column: 4, scope: !830)
!859 = !DILocation(line: 254, column: 12, scope: !830)
!860 = !DILocation(line: 254, column: 4, scope: !830)
!861 = !DILocation(line: 255, column: 12, scope: !830)
!862 = !DILocation(line: 255, column: 4, scope: !830)
!863 = !DILocation(line: 256, column: 12, scope: !830)
!864 = !DILocation(line: 256, column: 4, scope: !830)
!865 = !DILocation(line: 257, column: 12, scope: !830)
!866 = !DILocation(line: 257, column: 4, scope: !830)
!867 = !DILocation(line: 258, column: 12, scope: !830)
!868 = !DILocation(line: 258, column: 4, scope: !830)
!869 = !DILocation(line: 265, column: 12, scope: !830)
!870 = !DILocation(line: 265, column: 4, scope: !830)
!871 = !DILocation(line: 267, column: 12, scope: !830)
!872 = !DILocation(line: 267, column: 4, scope: !830)
!873 = !DILocation(line: 268, column: 12, scope: !830)
!874 = !DILocation(line: 268, column: 4, scope: !830)
!875 = !DILocation(line: 269, column: 12, scope: !830)
!876 = !DILocation(line: 269, column: 4, scope: !830)
!877 = !DILocation(line: 270, column: 1, scope: !830)
!878 = distinct !DISubprogram(name: "bots_get_params_common", scope: !17, file: !17, line: 275, type: !879, scopeLine: 276, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !16, retainedNodes: !305)
!879 = !DISubroutineType(types: !880)
!880 = !{null, !24, !881}
!881 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !349, size: 64)
!882 = !DILocalVariable(name: "argc", arg: 1, scope: !878, file: !17, line: 275, type: !24)
!883 = !DILocation(line: 275, column: 28, scope: !878)
!884 = !DILocalVariable(name: "argv", arg: 2, scope: !878, file: !17, line: 275, type: !881)
!885 = !DILocation(line: 275, column: 41, scope: !878)
!886 = !DILocalVariable(name: "i", scope: !878, file: !17, line: 277, type: !24)
!887 = !DILocation(line: 277, column: 8, scope: !878)
!888 = !DILocation(line: 278, column: 35, scope: !878)
!889 = !DILocation(line: 278, column: 26, scope: !878)
!890 = !DILocation(line: 278, column: 4, scope: !878)
!891 = !DILocation(line: 279, column: 4, scope: !878)
!892 = !DILocation(line: 280, column: 4, scope: !878)
!893 = !DILocation(line: 281, column: 10, scope: !894)
!894 = distinct !DILexicalBlock(scope: !878, file: !17, line: 281, column: 4)
!895 = !DILocation(line: 281, column: 9, scope: !894)
!896 = !DILocation(line: 281, column: 14, scope: !897)
!897 = distinct !DILexicalBlock(scope: !894, file: !17, line: 281, column: 4)
!898 = !DILocation(line: 281, column: 16, scope: !897)
!899 = !DILocation(line: 281, column: 15, scope: !897)
!900 = !DILocation(line: 281, column: 4, scope: !894)
!901 = !DILocation(line: 283, column: 11, scope: !902)
!902 = distinct !DILexicalBlock(scope: !903, file: !17, line: 283, column: 11)
!903 = distinct !DILexicalBlock(scope: !897, file: !17, line: 282, column: 4)
!904 = !DILocation(line: 283, column: 16, scope: !902)
!905 = !DILocation(line: 283, column: 22, scope: !902)
!906 = !DILocation(line: 283, column: 11, scope: !903)
!907 = !DILocation(line: 285, column: 18, scope: !908)
!908 = distinct !DILexicalBlock(scope: !902, file: !17, line: 284, column: 7)
!909 = !DILocation(line: 285, column: 23, scope: !908)
!910 = !DILocation(line: 285, column: 10, scope: !908)
!911 = !DILocation(line: 304, column: 16, scope: !912)
!912 = distinct !DILexicalBlock(scope: !908, file: !17, line: 286, column: 10)
!913 = !DILocation(line: 304, column: 21, scope: !912)
!914 = !DILocation(line: 304, column: 27, scope: !912)
!915 = !DILocation(line: 308, column: 32, scope: !912)
!916 = !DILocation(line: 309, column: 16, scope: !912)
!917 = !DILocation(line: 311, column: 16, scope: !912)
!918 = !DILocation(line: 311, column: 21, scope: !912)
!919 = !DILocation(line: 311, column: 27, scope: !912)
!920 = !DILocation(line: 312, column: 17, scope: !912)
!921 = !DILocation(line: 313, column: 20, scope: !922)
!922 = distinct !DILexicalBlock(scope: !912, file: !17, line: 313, column: 20)
!923 = !DILocation(line: 313, column: 28, scope: !922)
!924 = !DILocation(line: 313, column: 25, scope: !922)
!925 = !DILocation(line: 313, column: 20, scope: !912)
!926 = !DILocation(line: 313, column: 33, scope: !927)
!927 = distinct !DILexicalBlock(scope: !922, file: !17, line: 313, column: 31)
!928 = !DILocation(line: 313, column: 53, scope: !927)
!929 = !DILocation(line: 314, column: 42, scope: !912)
!930 = !DILocation(line: 314, column: 47, scope: !912)
!931 = !DILocation(line: 314, column: 16, scope: !912)
!932 = !DILocation(line: 315, column: 16, scope: !912)
!933 = !DILocation(line: 325, column: 16, scope: !912)
!934 = !DILocation(line: 325, column: 21, scope: !912)
!935 = !DILocation(line: 325, column: 27, scope: !912)
!936 = !DILocation(line: 326, column: 16, scope: !912)
!937 = !DILocation(line: 327, column: 16, scope: !912)
!938 = !DILocation(line: 346, column: 16, scope: !912)
!939 = !DILocation(line: 346, column: 21, scope: !912)
!940 = !DILocation(line: 346, column: 27, scope: !912)
!941 = !DILocation(line: 347, column: 17, scope: !912)
!942 = !DILocation(line: 348, column: 20, scope: !943)
!943 = distinct !DILexicalBlock(scope: !912, file: !17, line: 348, column: 20)
!944 = !DILocation(line: 348, column: 28, scope: !943)
!945 = !DILocation(line: 348, column: 25, scope: !943)
!946 = !DILocation(line: 348, column: 20, scope: !912)
!947 = !DILocation(line: 348, column: 33, scope: !948)
!948 = distinct !DILexicalBlock(scope: !943, file: !17, line: 348, column: 31)
!949 = !DILocation(line: 348, column: 53, scope: !948)
!950 = !DILocation(line: 349, column: 37, scope: !912)
!951 = !DILocation(line: 349, column: 42, scope: !912)
!952 = !DILocation(line: 349, column: 32, scope: !912)
!953 = !DILocation(line: 349, column: 30, scope: !912)
!954 = !DILocation(line: 350, column: 16, scope: !912)
!955 = !DILocation(line: 356, column: 16, scope: !912)
!956 = !DILocation(line: 356, column: 21, scope: !912)
!957 = !DILocation(line: 356, column: 27, scope: !912)
!958 = !DILocation(line: 357, column: 17, scope: !912)
!959 = !DILocation(line: 358, column: 20, scope: !960)
!960 = distinct !DILexicalBlock(scope: !912, file: !17, line: 358, column: 20)
!961 = !DILocation(line: 358, column: 28, scope: !960)
!962 = !DILocation(line: 358, column: 25, scope: !960)
!963 = !DILocation(line: 358, column: 20, scope: !912)
!964 = !DILocation(line: 358, column: 33, scope: !965)
!965 = distinct !DILexicalBlock(scope: !960, file: !17, line: 358, column: 31)
!966 = !DILocation(line: 358, column: 53, scope: !965)
!967 = !DILocation(line: 359, column: 42, scope: !912)
!968 = !DILocation(line: 359, column: 47, scope: !912)
!969 = !DILocation(line: 359, column: 37, scope: !912)
!970 = !DILocation(line: 359, column: 35, scope: !912)
!971 = !DILocation(line: 360, column: 16, scope: !912)
!972 = !DILocation(line: 379, column: 16, scope: !912)
!973 = !DILocation(line: 379, column: 21, scope: !912)
!974 = !DILocation(line: 379, column: 27, scope: !912)
!975 = !DILocation(line: 380, column: 17, scope: !912)
!976 = !DILocation(line: 381, column: 20, scope: !977)
!977 = distinct !DILexicalBlock(scope: !912, file: !17, line: 381, column: 20)
!978 = !DILocation(line: 381, column: 28, scope: !977)
!979 = !DILocation(line: 381, column: 25, scope: !977)
!980 = !DILocation(line: 381, column: 20, scope: !912)
!981 = !DILocation(line: 381, column: 33, scope: !982)
!982 = distinct !DILexicalBlock(scope: !977, file: !17, line: 381, column: 31)
!983 = !DILocation(line: 381, column: 53, scope: !982)
!984 = !DILocation(line: 382, column: 63, scope: !912)
!985 = !DILocation(line: 382, column: 68, scope: !912)
!986 = !DILocation(line: 382, column: 58, scope: !912)
!987 = !DILocation(line: 382, column: 34, scope: !912)
!988 = !DILocation(line: 384, column: 21, scope: !989)
!989 = distinct !DILexicalBlock(scope: !912, file: !17, line: 384, column: 21)
!990 = !DILocation(line: 384, column: 39, scope: !989)
!991 = !DILocation(line: 384, column: 21, scope: !912)
!992 = !DILocation(line: 385, column: 27, scope: !993)
!993 = distinct !DILexicalBlock(scope: !989, file: !17, line: 384, column: 45)
!994 = !DILocation(line: 385, column: 19, scope: !993)
!995 = !DILocation(line: 386, column: 19, scope: !993)
!996 = !DILocation(line: 389, column: 16, scope: !912)
!997 = !DILocation(line: 407, column: 9, scope: !912)
!998 = !DILocation(line: 407, column: 14, scope: !912)
!999 = !DILocation(line: 407, column: 20, scope: !912)
!1000 = !DILocation(line: 408, column: 34, scope: !912)
!1001 = !DILocation(line: 409, column: 16, scope: !912)
!1002 = !DILocation(line: 415, column: 24, scope: !912)
!1003 = !DILocation(line: 415, column: 16, scope: !912)
!1004 = !DILocation(line: 416, column: 16, scope: !912)
!1005 = !DILocation(line: 417, column: 16, scope: !912)
!1006 = !DILocation(line: 419, column: 7, scope: !908)
!1007 = !DILocation(line: 426, column: 18, scope: !1008)
!1008 = distinct !DILexicalBlock(scope: !902, file: !17, line: 421, column: 7)
!1009 = !DILocation(line: 426, column: 10, scope: !1008)
!1010 = !DILocation(line: 427, column: 10, scope: !1008)
!1011 = !DILocation(line: 428, column: 10, scope: !1008)
!1012 = !DILocation(line: 430, column: 4, scope: !903)
!1013 = !DILocation(line: 281, column: 23, scope: !897)
!1014 = !DILocation(line: 281, column: 4, scope: !897)
!1015 = distinct !{!1015, !900, !1016}
!1016 = !DILocation(line: 430, column: 4, scope: !894)
!1017 = !DILocation(line: 431, column: 1, scope: !878)
!1018 = distinct !DISubprogram(name: "bots_get_params", scope: !17, file: !17, line: 436, type: !879, scopeLine: 437, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !16, retainedNodes: !305)
!1019 = !DILocalVariable(name: "argc", arg: 1, scope: !1018, file: !17, line: 436, type: !24)
!1020 = !DILocation(line: 436, column: 21, scope: !1018)
!1021 = !DILocalVariable(name: "argv", arg: 2, scope: !1018, file: !17, line: 436, type: !881)
!1022 = !DILocation(line: 436, column: 34, scope: !1018)
!1023 = !DILocation(line: 438, column: 27, scope: !1018)
!1024 = !DILocation(line: 438, column: 33, scope: !1018)
!1025 = !DILocation(line: 438, column: 4, scope: !1018)
!1026 = !DILocation(line: 440, column: 1, scope: !1018)
!1027 = distinct !DISubprogram(name: "bots_set_info", scope: !17, file: !17, line: 446, type: !495, scopeLine: 447, spFlags: DISPFlagDefinition, unit: !16, retainedNodes: !305)
!1028 = !DILocation(line: 449, column: 4, scope: !1027)
!1029 = !DILocation(line: 450, column: 72, scope: !1027)
!1030 = !DILocation(line: 450, column: 4, scope: !1027)
!1031 = !DILocation(line: 451, column: 4, scope: !1027)
!1032 = !DILocation(line: 452, column: 4, scope: !1027)
!1033 = !DILocation(line: 455, column: 4, scope: !1027)
!1034 = !DILocation(line: 456, column: 4, scope: !1027)
!1035 = !DILocation(line: 457, column: 4, scope: !1027)
!1036 = !DILocation(line: 458, column: 4, scope: !1027)
!1037 = !DILocation(line: 459, column: 4, scope: !1027)
!1038 = !DILocation(line: 460, column: 4, scope: !1027)
!1039 = !DILocation(line: 469, column: 4, scope: !1027)
!1040 = !DILocation(line: 471, column: 1, scope: !1027)
!1041 = distinct !DISubprogram(name: "main", scope: !17, file: !17, line: 477, type: !1042, scopeLine: 478, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !16, retainedNodes: !305)
!1042 = !DISubroutineType(types: !1043)
!1043 = !{!24, !24, !881}
!1044 = !DILocalVariable(name: "argc", arg: 1, scope: !1041, file: !17, line: 477, type: !24)
!1045 = !DILocation(line: 477, column: 10, scope: !1041)
!1046 = !DILocalVariable(name: "argv", arg: 2, scope: !1041, file: !17, line: 477, type: !881)
!1047 = !DILocation(line: 477, column: 22, scope: !1041)
!1048 = !DILocalVariable(name: "bots_t_start", scope: !1041, file: !17, line: 480, type: !418)
!1049 = !DILocation(line: 480, column: 9, scope: !1041)
!1050 = !DILocalVariable(name: "bots_t_end", scope: !1041, file: !17, line: 481, type: !418)
!1051 = !DILocation(line: 481, column: 9, scope: !1041)
!1052 = !DILocation(line: 484, column: 20, scope: !1041)
!1053 = !DILocation(line: 484, column: 25, scope: !1041)
!1054 = !DILocation(line: 484, column: 4, scope: !1041)
!1055 = !DILocation(line: 486, column: 4, scope: !1041)
!1056 = !DILocation(line: 513, column: 19, scope: !1041)
!1057 = !DILocation(line: 513, column: 17, scope: !1041)
!1058 = !DILocation(line: 514, column: 4, scope: !1041)
!1059 = !DILocation(line: 515, column: 17, scope: !1041)
!1060 = !DILocation(line: 515, column: 15, scope: !1041)
!1061 = !DILocation(line: 516, column: 34, scope: !1041)
!1062 = !DILocation(line: 516, column: 45, scope: !1041)
!1063 = !DILocation(line: 516, column: 44, scope: !1041)
!1064 = !DILocation(line: 516, column: 25, scope: !1041)
!1065 = !DILocation(line: 516, column: 59, scope: !1041)
!1066 = !DILocation(line: 516, column: 22, scope: !1041)
!1067 = !DILocation(line: 521, column: 8, scope: !1068)
!1068 = distinct !DILexicalBlock(scope: !1041, file: !17, line: 521, column: 8)
!1069 = !DILocation(line: 521, column: 8, scope: !1041)
!1070 = !DILocation(line: 522, column: 18, scope: !1071)
!1071 = distinct !DILexicalBlock(scope: !1068, file: !17, line: 521, column: 25)
!1072 = !DILocation(line: 523, column: 4, scope: !1071)
!1073 = !DILocation(line: 528, column: 4, scope: !1041)
!1074 = !DILocation(line: 529, column: 4, scope: !1041)
