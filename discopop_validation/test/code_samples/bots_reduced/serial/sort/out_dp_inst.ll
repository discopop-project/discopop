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

@array = common dso_local global i64* null, align 8, !dbg !0
@tmp = common dso_local global i64* null, align 8, !dbg !18
@.str.10 = private unnamed_addr constant [9 x i8] c"low.addr\00", align 1
@.str.11 = private unnamed_addr constant [10 x i8] c"high.addr\00", align 1
@.str.12 = private unnamed_addr constant [24 x i8] c"bots_app_cutoff_value_2\00", align 1
@.str.13 = private unnamed_addr constant [2 x i8] c"p\00", align 1
@.str.20 = private unnamed_addr constant [2 x i8] c"q\00", align 1
@.str.21 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.22 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.str.14 = private unnamed_addr constant [9 x i8] c"curr_low\00", align 1
@.str.15 = private unnamed_addr constant [10 x i8] c"curr_high\00", align 1
@.str.16 = private unnamed_addr constant [6 x i8] c"pivot\00", align 1
@.str.17 = private unnamed_addr constant [2 x i8] c"h\00", align 1
@.str.18 = private unnamed_addr constant [2 x i8] c"l\00", align 1
@.str.19 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.59 = private unnamed_addr constant [7 x i8] c"a.addr\00", align 1
@.str.60 = private unnamed_addr constant [7 x i8] c"b.addr\00", align 1
@.str.61 = private unnamed_addr constant [7 x i8] c"c.addr\00", align 1
@.str.23 = private unnamed_addr constant [10 x i8] c"low1.addr\00", align 1
@.str.24 = private unnamed_addr constant [11 x i8] c"high1.addr\00", align 1
@.str.25 = private unnamed_addr constant [10 x i8] c"low2.addr\00", align 1
@.str.26 = private unnamed_addr constant [11 x i8] c"high2.addr\00", align 1
@.str.27 = private unnamed_addr constant [13 x i8] c"lowdest.addr\00", align 1
@.str.28 = private unnamed_addr constant [3 x i8] c"a1\00", align 1
@.str.29 = private unnamed_addr constant [3 x i8] c"a2\00", align 1
@.str.30 = private unnamed_addr constant [9 x i8] c"val.addr\00", align 1
@.str.31 = private unnamed_addr constant [4 x i8] c"mid\00", align 1
@.str.32 = private unnamed_addr constant [4 x i8] c"tmp\00", align 1
@.str.33 = private unnamed_addr constant [5 x i8] c"tmp5\00", align 1
@.str.34 = private unnamed_addr constant [22 x i8] c"bots_app_cutoff_value\00", align 1
@.str.35 = private unnamed_addr constant [7 x i8] c"split1\00", align 1
@.str.36 = private unnamed_addr constant [7 x i8] c"split2\00", align 1
@.str.37 = private unnamed_addr constant [8 x i8] c"lowsize\00", align 1
@.str.38 = private unnamed_addr constant [9 x i8] c"tmp.addr\00", align 1
@.str.39 = private unnamed_addr constant [10 x i8] c"size.addr\00", align 1
@.str.40 = private unnamed_addr constant [8 x i8] c"quarter\00", align 1
@.str.41 = private unnamed_addr constant [24 x i8] c"bots_app_cutoff_value_1\00", align 1
@.str.42 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@.str.43 = private unnamed_addr constant [5 x i8] c"tmpA\00", align 1
@.str.44 = private unnamed_addr constant [2 x i8] c"B\00", align 1
@.str.45 = private unnamed_addr constant [5 x i8] c"tmpB\00", align 1
@.str.46 = private unnamed_addr constant [2 x i8] c"C\00", align 1
@.str.47 = private unnamed_addr constant [5 x i8] c"tmpC\00", align 1
@.str.48 = private unnamed_addr constant [2 x i8] c"D\00", align 1
@.str.49 = private unnamed_addr constant [5 x i8] c"tmpD\00", align 1
@.str.50 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.51 = private unnamed_addr constant [14 x i8] c"bots_arg_size\00", align 1
@.str.52 = private unnamed_addr constant [2 x i8] c"j\00", align 1
@.str.53 = private unnamed_addr constant [6 x i8] c"array\00", align 1
@rand_nxt = internal global i64 0, align 8, !dbg !20
@.str.54 = private unnamed_addr constant [9 x i8] c"rand_nxt\00", align 1
@.str.55 = private unnamed_addr constant [10 x i8] c"seed.addr\00", align 1
@.str.56 = private unnamed_addr constant [18 x i8] c"bots_verbose_mode\00", align 1
@stdout = external dso_local global %struct._IO_FILE*, align 8
@.str.57 = private unnamed_addr constant [7 x i8] c"stdout\00", align 1
@.str = private unnamed_addr constant [52 x i8] c"%s can not be less than 4, using 4 as a parameter.\0A\00", align 1
@.str.1 = private unnamed_addr constant [11 x i8] c"Array size\00", align 1
@.str.2 = private unnamed_addr constant [52 x i8] c"%s can not be less than 2, using 2 as a parameter.\0A\00", align 1
@.str.3 = private unnamed_addr constant [30 x i8] c"Sequential Merge cutoff value\00", align 1
@.str.4 = private unnamed_addr constant [67 x i8] c"%s can not be greather than vector size, using %d as a parameter.\0A\00", align 1
@.str.5 = private unnamed_addr constant [34 x i8] c"Sequential Quicksort cutoff value\00", align 1
@.str.6 = private unnamed_addr constant [34 x i8] c"Sequential Insertion cutoff value\00", align 1
@.str.7 = private unnamed_addr constant [58 x i8] c"%s can not be greather than %s, using %d as a parameter.\0A\00", align 1
@.str.8 = private unnamed_addr constant [38 x i8] c"Computing multisort algorithm (n=%d) \00", align 1
@.str.9 = private unnamed_addr constant [13 x i8] c" completed!\0A\00", align 1
@.str.58 = private unnamed_addr constant [8 x i8] c"success\00", align 1
@.str.48.1 = private unnamed_addr constant [11 x i8] c"error.addr\00", align 1
@.str.49.2 = private unnamed_addr constant [13 x i8] c"message.addr\00", align 1
@stderr = external dso_local global %struct._IO_FILE*, align 8
@.str.50.3 = private unnamed_addr constant [7 x i8] c"stderr\00", align 1
@.str.62 = private unnamed_addr constant [16 x i8] c"Error (%d): %s\0A\00", align 1
@.str.1.63 = private unnamed_addr constant [19 x i8] c"Unspecified error.\00", align 1
@.str.2.64 = private unnamed_addr constant [19 x i8] c"Not enough memory.\00", align 1
@.str.3.65 = private unnamed_addr constant [24 x i8] c"Unrecognized parameter.\00", align 1
@.str.4.66 = private unnamed_addr constant [20 x i8] c"Invalid error code.\00", align 1
@.str.51.67 = private unnamed_addr constant [13 x i8] c"warning.addr\00", align 1
@.str.5.68 = private unnamed_addr constant [18 x i8] c"Warning (%d): %s\0A\00", align 1
@.str.6.69 = private unnamed_addr constant [21 x i8] c"Unspecified warning.\00", align 1
@.str.7.70 = private unnamed_addr constant [22 x i8] c"Invalid warning code.\00", align 1
@.str.52.71 = private unnamed_addr constant [2 x i8] c"t\00", align 1
@.str.53.72 = private unnamed_addr constant [9 x i8] c"str.addr\00", align 1
@.str.8.73 = private unnamed_addr constant [15 x i8] c"%Y/%m/%d;%H:%M\00", align 1
@.str.54.74 = private unnamed_addr constant [6 x i8] c"ncpus\00", align 1
@.str.9.75 = private unnamed_addr constant [9 x i8] c"%s-%s;%d\00", align 1
@.str.55.76 = private unnamed_addr constant [8 x i8] c"loadavg\00", align 1
@.str.10.77 = private unnamed_addr constant [15 x i8] c"%.2f;%.2f;%.2f\00", align 1
@.str.11.78 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.56.79 = private unnamed_addr constant [12 x i8] c"bots_result\00", align 1
@.str.12.80 = private unnamed_addr constant [4 x i8] c"n/a\00", align 1
@.str.13.81 = private unnamed_addr constant [11 x i8] c"successful\00", align 1
@.str.14.82 = private unnamed_addr constant [13 x i8] c"UNSUCCESSFUL\00", align 1
@.str.15.83 = private unnamed_addr constant [14 x i8] c"Not requested\00", align 1
@.str.16.84 = private unnamed_addr constant [6 x i8] c"error\00", align 1
@.str.57.85 = private unnamed_addr constant [18 x i8] c"bots_time_program\00", align 1
@.str.17.86 = private unnamed_addr constant [3 x i8] c"%f\00", align 1
@.str.58.87 = private unnamed_addr constant [21 x i8] c"bots_sequential_flag\00", align 1
@.str.59.88 = private unnamed_addr constant [21 x i8] c"bots_time_sequential\00", align 1
@.str.18.89 = private unnamed_addr constant [6 x i8] c"%3.2f\00", align 1
@.str.60.90 = private unnamed_addr constant [21 x i8] c"bots_number_of_tasks\00", align 1
@.str.61.91 = private unnamed_addr constant [18 x i8] c"bots_print_header\00", align 1
@.str.62.92 = private unnamed_addr constant [19 x i8] c"bots_output_format\00", align 1
@.str.63 = private unnamed_addr constant [7 x i8] c"stdout\00", align 1
@.str.19.93 = private unnamed_addr constant [238 x i8] c"Benchmark;Parameters;Model;Cutoff;Resources;Result;Time;Sequential;Speed-up;Nodes;Nodes/Sec;Exec Date;Exec Time;Exec Message;Architecture;Processors;Load Avg-1;Load Avg-5;Load Avg-15;Comp Date;Comp Time;Comp Message;CC;CFLAGS;LD;LDFLAGS\0A\00", align 1
@.str.20.94 = private unnamed_addr constant [94 x i8] c"Benchmark;Parameters;Model;Cutoff;Resources;Result;Time;Sequential;Speed-up;Nodes;Nodes/Sec;\0A\00", align 1
@.str.21.95 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.22.96 = private unnamed_addr constant [26 x i8] c"Program             = %s\0A\00", align 1
@.str.23.97 = private unnamed_addr constant [26 x i8] c"Parameters          = %s\0A\00", align 1
@.str.24.98 = private unnamed_addr constant [26 x i8] c"Model               = %s\0A\00", align 1
@.str.25.99 = private unnamed_addr constant [26 x i8] c"Embedded cut-off    = %s\0A\00", align 1
@.str.26.100 = private unnamed_addr constant [26 x i8] c"# of Threads        = %s\0A\00", align 1
@.str.27.101 = private unnamed_addr constant [26 x i8] c"Verification        = %s\0A\00", align 1
@.str.28.102 = private unnamed_addr constant [34 x i8] c"Time Program        = %s seconds\0A\00", align 1
@.str.29.103 = private unnamed_addr constant [34 x i8] c"Time Sequential     = %s seconds\0A\00", align 1
@.str.30.104 = private unnamed_addr constant [26 x i8] c"Speed-up            = %s\0A\00", align 1
@.str.31.105 = private unnamed_addr constant [26 x i8] c"Nodes               = %s\0A\00", align 1
@.str.32.106 = private unnamed_addr constant [26 x i8] c"Nodes/Sec           = %s\0A\00", align 1
@.str.33.107 = private unnamed_addr constant [26 x i8] c"Execution Date      = %s\0A\00", align 1
@.str.34.108 = private unnamed_addr constant [26 x i8] c"Execution Message   = %s\0A\00", align 1
@.str.35.109 = private unnamed_addr constant [26 x i8] c"Architecture        = %s\0A\00", align 1
@.str.36.110 = private unnamed_addr constant [26 x i8] c"Load Avg [1:5:15]   = %s\0A\00", align 1
@.str.37.111 = private unnamed_addr constant [26 x i8] c"Compilation Date    = %s\0A\00", align 1
@.str.38.112 = private unnamed_addr constant [26 x i8] c"Compilation Message = %s\0A\00", align 1
@.str.39.113 = private unnamed_addr constant [26 x i8] c"Compiler            = %s\0A\00", align 1
@.str.40.114 = private unnamed_addr constant [26 x i8] c"Compiler Flags      = %s\0A\00", align 1
@.str.41.115 = private unnamed_addr constant [26 x i8] c"Linker              = %s\0A\00", align 1
@.str.42.116 = private unnamed_addr constant [26 x i8] c"Linker Flags        = %s\0A\00", align 1
@.str.43.117 = private unnamed_addr constant [19 x i8] c"%s;%s;%s;%s;%s;%s;\00", align 1
@.str.44.118 = private unnamed_addr constant [10 x i8] c"%s;%s;%s;\00", align 1
@.str.45.119 = private unnamed_addr constant [7 x i8] c"%s;%s;\00", align 1
@.str.46.120 = private unnamed_addr constant [13 x i8] c"%s;%s;%s;%s;\00", align 1
@.str.47.121 = private unnamed_addr constant [24 x i8] c"No valid output format\0A\00", align 1
@bots_sequential_flag = dso_local global i32 0, align 4, !dbg !23
@bots_check_flag = dso_local global i32 0, align 4, !dbg !31
@bots_verbose_mode = dso_local global i32 1, align 4, !dbg !34
@bots_result = dso_local global i32 3, align 4, !dbg !36
@bots_output_format = dso_local global i32 1, align 4, !dbg !38
@bots_print_header = dso_local global i32 0, align 4, !dbg !40
@bots_time_program = dso_local global double 0.000000e+00, align 8, !dbg !42
@bots_time_sequential = dso_local global double 0.000000e+00, align 8, !dbg !44
@bots_number_of_tasks = dso_local global i64 0, align 8, !dbg !46
@bots_arg_size = dso_local global i32 33554432, align 4, !dbg !49
@bots_app_cutoff_value = dso_local global i32 2048, align 4, !dbg !51
@bots_app_cutoff_value_1 = dso_local global i32 2048, align 4, !dbg !53
@bots_app_cutoff_value_2 = dso_local global i32 20, align 4, !dbg !55
@bots_execname = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !63
@bots_exec_date = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !71
@bots_exec_message = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !73
@bots_name = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !57
@bots_parameters = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !65
@bots_model = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !67
@bots_resources = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !69
@bots_comp_date = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !75
@bots_comp_message = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !77
@bots_cc = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !79
@bots_cflags = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !81
@bots_ld = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !83
@bots_ldflags = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !85
@bots_cutoff = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !87
@.str.29.174 = private unnamed_addr constant [7 x i8] c"stderr\00", align 1
@.str.175 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.1.176 = private unnamed_addr constant [22 x i8] c"Usage: %s -[options]\0A\00", align 1
@.str.2.177 = private unnamed_addr constant [20 x i8] c"Where options are:\0A\00", align 1
@.str.3.178 = private unnamed_addr constant [27 x i8] c"  -n <size>  : Array size\0A\00", align 1
@.str.4.179 = private unnamed_addr constant [58 x i8] c"  -y <value> : Sequential Merge cutoff value(default=%d)\0A\00", align 1
@.str.5.180 = private unnamed_addr constant [62 x i8] c"  -a <value> : Sequential Quicksort cutoff value(default=%d)\0A\00", align 1
@.str.6.181 = private unnamed_addr constant [62 x i8] c"  -b <value> : Sequential Insertion cutoff value(default=%d)\0A\00", align 1
@.str.7.182 = private unnamed_addr constant [49 x i8] c"  -e <str>   : Include 'str' execution message.\0A\00", align 1
@.str.8.183 = private unnamed_addr constant [49 x i8] c"  -v <level> : Set verbose level (default = 1).\0A\00", align 1
@.str.9.184 = private unnamed_addr constant [26 x i8] c"               0 - none.\0A\00", align 1
@.str.10.185 = private unnamed_addr constant [29 x i8] c"               1 - default.\0A\00", align 1
@.str.11.186 = private unnamed_addr constant [27 x i8] c"               2 - debug.\0A\00", align 1
@.str.12.187 = private unnamed_addr constant [54 x i8] c"  -o <value> : Set output format mode (default = 1).\0A\00", align 1
@.str.13.188 = private unnamed_addr constant [41 x i8] c"               0 - no benchmark output.\0A\00", align 1
@.str.14.189 = private unnamed_addr constant [42 x i8] c"               1 - detailed list format.\0A\00", align 1
@.str.15.190 = private unnamed_addr constant [41 x i8] c"               2 - detailed row format.\0A\00", align 1
@.str.16.191 = private unnamed_addr constant [42 x i8] c"               3 - abridged list format.\0A\00", align 1
@.str.17.192 = private unnamed_addr constant [41 x i8] c"               4 - abridged row format.\0A\00", align 1
@.str.18.193 = private unnamed_addr constant [70 x i8] c"  -z         : Print row header (if output format is a row variant).\0A\00", align 1
@.str.19.194 = private unnamed_addr constant [31 x i8] c"  -c         : Check mode ON.\0A\00", align 1
@.str.20.195 = private unnamed_addr constant [51 x i8] c"  -h         : Print program's usage (this help).\0A\00", align 1
@.str.30.196 = private unnamed_addr constant [10 x i8] c"argc.addr\00", align 1
@.str.31.197 = private unnamed_addr constant [10 x i8] c"argv.addr\00", align 1
@.str.21.198 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.32.199 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.33.200 = private unnamed_addr constant [24 x i8] c"bots_app_cutoff_value_1\00", align 1
@.str.34.201 = private unnamed_addr constant [24 x i8] c"bots_app_cutoff_value_2\00", align 1
@.str.35.202 = private unnamed_addr constant [16 x i8] c"bots_check_flag\00", align 1
@.str.36.203 = private unnamed_addr constant [14 x i8] c"bots_arg_size\00", align 1
@.str.37.204 = private unnamed_addr constant [19 x i8] c"bots_output_format\00", align 1
@.str.38.205 = private unnamed_addr constant [18 x i8] c"bots_verbose_mode\00", align 1
@.str.22.206 = private unnamed_addr constant [100 x i8] c"Error: Configure the suite using '--debug' option in order to use a verbose level greather than 1.\0A\00", align 1
@.str.39.207 = private unnamed_addr constant [22 x i8] c"bots_app_cutoff_value\00", align 1
@.str.40.208 = private unnamed_addr constant [18 x i8] c"bots_print_header\00", align 1
@.str.23.209 = private unnamed_addr constant [32 x i8] c"Error: Unrecognized parameter.\0A\00", align 1
@.str.24.210 = private unnamed_addr constant [5 x i8] c"Sort\00", align 1
@.str.25.211 = private unnamed_addr constant [20 x i8] c"N=%d:Q=%d:I=%d:M=%d\00", align 1
@.str.26.212 = private unnamed_addr constant [7 x i8] c"Serial\00", align 1
@.str.27.213 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str.28.214 = private unnamed_addr constant [5 x i8] c"none\00", align 1
@.str.41.215 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.42.216 = private unnamed_addr constant [13 x i8] c"bots_t_start\00", align 1
@.str.43.217 = private unnamed_addr constant [11 x i8] c"bots_t_end\00", align 1
@.str.44.218 = private unnamed_addr constant [18 x i8] c"bots_time_program\00", align 1
@.str.45.219 = private unnamed_addr constant [12 x i8] c"bots_result\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @seqquick(i64* %low, i64* %high) #0 !dbg !317 {
entry:
  call void @__dp_func_entry(i32 164016, i32 0)
  %low.addr = alloca i64*, align 8
  %high.addr = alloca i64*, align 8
  %p = alloca i64*, align 8
  %0 = ptrtoint i64** %low.addr to i64
  call void @__dp_write(i32 164016, i64 %0, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  store i64* %low, i64** %low.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %low.addr, metadata !321, metadata !DIExpression()), !dbg !322
  %1 = ptrtoint i64** %high.addr to i64
  call void @__dp_write(i32 164016, i64 %1, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.11, i32 0, i32 0))
  store i64* %high, i64** %high.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %high.addr, metadata !323, metadata !DIExpression()), !dbg !324
  call void @llvm.dbg.declare(metadata i64** %p, metadata !325, metadata !DIExpression()), !dbg !326
  br label %while.cond, !dbg !327

while.cond:                                       ; preds = %while.body, %entry
  call void @__dp_loop_entry(i32 164020, i32 0)
  %2 = ptrtoint i64** %high.addr to i64
  call void @__dp_read(i32 164020, i64 %2, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.11, i32 0, i32 0))
  %3 = load i64*, i64** %high.addr, align 8, !dbg !328
  %4 = ptrtoint i64** %low.addr to i64
  call void @__dp_read(i32 164020, i64 %4, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  %5 = load i64*, i64** %low.addr, align 8, !dbg !329
  %sub.ptr.lhs.cast = ptrtoint i64* %3 to i64, !dbg !330
  %sub.ptr.rhs.cast = ptrtoint i64* %5 to i64, !dbg !330
  %sub.ptr.sub = sub i64 %sub.ptr.lhs.cast, %sub.ptr.rhs.cast, !dbg !330
  %sub.ptr.div = sdiv exact i64 %sub.ptr.sub, 8, !dbg !330
  %6 = ptrtoint i32* @bots_app_cutoff_value_2 to i64
  call void @__dp_read(i32 164020, i64 %6, i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.12, i32 0, i32 0))
  %7 = load i32, i32* @bots_app_cutoff_value_2, align 4, !dbg !331
  %conv = sext i32 %7 to i64, !dbg !331
  %cmp = icmp sge i64 %sub.ptr.div, %conv, !dbg !332
  br i1 %cmp, label %while.body, label %while.end, !dbg !327

while.body:                                       ; preds = %while.cond
  %8 = ptrtoint i64** %low.addr to i64
  call void @__dp_read(i32 164021, i64 %8, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  %9 = load i64*, i64** %low.addr, align 8, !dbg !333
  %10 = ptrtoint i64** %high.addr to i64
  call void @__dp_read(i32 164021, i64 %10, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.11, i32 0, i32 0))
  %11 = load i64*, i64** %high.addr, align 8, !dbg !335
  call void @__dp_call(i32 164021), !dbg !336
  %call = call i64* @seqpart(i64* %9, i64* %11), !dbg !336
  %12 = ptrtoint i64** %p to i64
  call void @__dp_write(i32 164021, i64 %12, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.13, i32 0, i32 0))
  store i64* %call, i64** %p, align 8, !dbg !337
  %13 = ptrtoint i64** %low.addr to i64
  call void @__dp_read(i32 164022, i64 %13, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  %14 = load i64*, i64** %low.addr, align 8, !dbg !338
  %15 = ptrtoint i64** %p to i64
  call void @__dp_read(i32 164022, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.13, i32 0, i32 0))
  %16 = load i64*, i64** %p, align 8, !dbg !339
  call void @__dp_call(i32 164022), !dbg !340
  call void @seqquick(i64* %14, i64* %16), !dbg !340
  %17 = ptrtoint i64** %p to i64
  call void @__dp_read(i32 164023, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.13, i32 0, i32 0))
  %18 = load i64*, i64** %p, align 8, !dbg !341
  %add.ptr = getelementptr inbounds i64, i64* %18, i64 1, !dbg !342
  %19 = ptrtoint i64** %low.addr to i64
  call void @__dp_write(i32 164023, i64 %19, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  store i64* %add.ptr, i64** %low.addr, align 8, !dbg !343
  br label %while.cond, !dbg !327, !llvm.loop !344

while.end:                                        ; preds = %while.cond
  call void @__dp_loop_exit(i32 164026, i32 0)
  %20 = ptrtoint i64** %low.addr to i64
  call void @__dp_read(i32 164026, i64 %20, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  %21 = load i64*, i64** %low.addr, align 8, !dbg !346
  %22 = ptrtoint i64** %high.addr to i64
  call void @__dp_read(i32 164026, i64 %22, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.11, i32 0, i32 0))
  %23 = load i64*, i64** %high.addr, align 8, !dbg !347
  call void @__dp_call(i32 164026), !dbg !348
  call void @insertion_sort(i64* %21, i64* %23), !dbg !348
  call void @__dp_func_exit(i32 164027, i32 0), !dbg !349
  ret void, !dbg !349
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_call(i32)

; Function Attrs: noinline nounwind optnone uwtable
define internal i64* @seqpart(i64* %low, i64* %high) #0 !dbg !350 {
entry:
  call void @__dp_func_entry(i32 163955, i32 0)
  %retval = alloca i64*, align 8
  %low.addr = alloca i64*, align 8
  %high.addr = alloca i64*, align 8
  %pivot = alloca i64, align 8
  %h = alloca i64, align 8
  %l = alloca i64, align 8
  %curr_low = alloca i64*, align 8
  %curr_high = alloca i64*, align 8
  %0 = ptrtoint i64** %low.addr to i64
  call void @__dp_write(i32 163955, i64 %0, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  store i64* %low, i64** %low.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %low.addr, metadata !353, metadata !DIExpression()), !dbg !354
  %1 = ptrtoint i64** %high.addr to i64
  call void @__dp_write(i32 163955, i64 %1, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.11, i32 0, i32 0))
  store i64* %high, i64** %high.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %high.addr, metadata !355, metadata !DIExpression()), !dbg !356
  call void @llvm.dbg.declare(metadata i64* %pivot, metadata !357, metadata !DIExpression()), !dbg !358
  call void @llvm.dbg.declare(metadata i64* %h, metadata !359, metadata !DIExpression()), !dbg !360
  call void @llvm.dbg.declare(metadata i64* %l, metadata !361, metadata !DIExpression()), !dbg !362
  call void @llvm.dbg.declare(metadata i64** %curr_low, metadata !363, metadata !DIExpression()), !dbg !364
  %2 = ptrtoint i64** %low.addr to i64
  call void @__dp_read(i32 163959, i64 %2, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  %3 = load i64*, i64** %low.addr, align 8, !dbg !365
  %4 = ptrtoint i64** %curr_low to i64
  call void @__dp_write(i32 163959, i64 %4, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.14, i32 0, i32 0))
  store i64* %3, i64** %curr_low, align 8, !dbg !364
  call void @llvm.dbg.declare(metadata i64** %curr_high, metadata !366, metadata !DIExpression()), !dbg !367
  %5 = ptrtoint i64** %high.addr to i64
  call void @__dp_read(i32 163960, i64 %5, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.11, i32 0, i32 0))
  %6 = load i64*, i64** %high.addr, align 8, !dbg !368
  %7 = ptrtoint i64** %curr_high to i64
  call void @__dp_write(i32 163960, i64 %7, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.15, i32 0, i32 0))
  store i64* %6, i64** %curr_high, align 8, !dbg !367
  %8 = ptrtoint i64** %low.addr to i64
  call void @__dp_read(i32 163962, i64 %8, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  %9 = load i64*, i64** %low.addr, align 8, !dbg !369
  %10 = ptrtoint i64** %high.addr to i64
  call void @__dp_read(i32 163962, i64 %10, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.11, i32 0, i32 0))
  %11 = load i64*, i64** %high.addr, align 8, !dbg !370
  call void @__dp_call(i32 163962), !dbg !371
  %call = call i64 @choose_pivot(i64* %9, i64* %11), !dbg !371
  %12 = ptrtoint i64* %pivot to i64
  call void @__dp_write(i32 163962, i64 %12, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.16, i32 0, i32 0))
  store i64 %call, i64* %pivot, align 8, !dbg !372
  br label %while.body, !dbg !373

while.body:                                       ; preds = %if.end, %entry
  call void @__dp_loop_entry(i32 163965, i32 1)
  br label %while.cond1, !dbg !374

while.cond1:                                      ; preds = %while.body2, %while.body
  call void @__dp_loop_entry(i32 163965, i32 2)
  %13 = ptrtoint i64** %curr_high to i64
  call void @__dp_read(i32 163965, i64 %13, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.15, i32 0, i32 0))
  %14 = load i64*, i64** %curr_high, align 8, !dbg !376
  %15 = ptrtoint i64* %14 to i64
  call void @__dp_read(i32 163965, i64 %15, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.15, i32 0, i32 0))
  %16 = load i64, i64* %14, align 8, !dbg !377
  %17 = ptrtoint i64* %h to i64
  call void @__dp_write(i32 163965, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.17, i32 0, i32 0))
  store i64 %16, i64* %h, align 8, !dbg !378
  %18 = ptrtoint i64* %pivot to i64
  call void @__dp_read(i32 163965, i64 %18, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.16, i32 0, i32 0))
  %19 = load i64, i64* %pivot, align 8, !dbg !379
  %cmp = icmp sgt i64 %16, %19, !dbg !380
  br i1 %cmp, label %while.body2, label %while.end, !dbg !374

while.body2:                                      ; preds = %while.cond1
  %20 = ptrtoint i64** %curr_high to i64
  call void @__dp_read(i32 163966, i64 %20, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.15, i32 0, i32 0))
  %21 = load i64*, i64** %curr_high, align 8, !dbg !381
  %incdec.ptr = getelementptr inbounds i64, i64* %21, i32 -1, !dbg !381
  %22 = ptrtoint i64** %curr_high to i64
  call void @__dp_write(i32 163966, i64 %22, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.15, i32 0, i32 0))
  store i64* %incdec.ptr, i64** %curr_high, align 8, !dbg !381
  br label %while.cond1, !dbg !374, !llvm.loop !382

while.end:                                        ; preds = %while.cond1
  call void @__dp_loop_exit(i32 163968, i32 2)
  br label %while.cond3, !dbg !383

while.cond3:                                      ; preds = %while.body5, %while.end
  call void @__dp_loop_entry(i32 163968, i32 3)
  %23 = ptrtoint i64** %curr_low to i64
  call void @__dp_read(i32 163968, i64 %23, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.14, i32 0, i32 0))
  %24 = load i64*, i64** %curr_low, align 8, !dbg !384
  %25 = ptrtoint i64* %24 to i64
  call void @__dp_read(i32 163968, i64 %25, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.14, i32 0, i32 0))
  %26 = load i64, i64* %24, align 8, !dbg !385
  %27 = ptrtoint i64* %l to i64
  call void @__dp_write(i32 163968, i64 %27, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.18, i32 0, i32 0))
  store i64 %26, i64* %l, align 8, !dbg !386
  %28 = ptrtoint i64* %pivot to i64
  call void @__dp_read(i32 163968, i64 %28, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.16, i32 0, i32 0))
  %29 = load i64, i64* %pivot, align 8, !dbg !387
  %cmp4 = icmp slt i64 %26, %29, !dbg !388
  br i1 %cmp4, label %while.body5, label %while.end7, !dbg !383

while.body5:                                      ; preds = %while.cond3
  %30 = ptrtoint i64** %curr_low to i64
  call void @__dp_read(i32 163969, i64 %30, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.14, i32 0, i32 0))
  %31 = load i64*, i64** %curr_low, align 8, !dbg !389
  %incdec.ptr6 = getelementptr inbounds i64, i64* %31, i32 1, !dbg !389
  %32 = ptrtoint i64** %curr_low to i64
  call void @__dp_write(i32 163969, i64 %32, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.14, i32 0, i32 0))
  store i64* %incdec.ptr6, i64** %curr_low, align 8, !dbg !389
  br label %while.cond3, !dbg !383, !llvm.loop !390

while.end7:                                       ; preds = %while.cond3
  call void @__dp_loop_exit(i32 163971, i32 3)
  %33 = ptrtoint i64** %curr_low to i64
  call void @__dp_read(i32 163971, i64 %33, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.14, i32 0, i32 0))
  %34 = load i64*, i64** %curr_low, align 8, !dbg !391
  %35 = ptrtoint i64** %curr_high to i64
  call void @__dp_read(i32 163971, i64 %35, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.15, i32 0, i32 0))
  %36 = load i64*, i64** %curr_high, align 8, !dbg !393
  %cmp8 = icmp uge i64* %34, %36, !dbg !394
  br i1 %cmp8, label %if.then, label %if.end, !dbg !395

if.then:                                          ; preds = %while.end7
  br label %while.end11, !dbg !396

if.end:                                           ; preds = %while.end7
  %37 = ptrtoint i64* %l to i64
  call void @__dp_read(i32 163974, i64 %37, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.18, i32 0, i32 0))
  %38 = load i64, i64* %l, align 8, !dbg !397
  %39 = ptrtoint i64** %curr_high to i64
  call void @__dp_read(i32 163974, i64 %39, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.15, i32 0, i32 0))
  %40 = load i64*, i64** %curr_high, align 8, !dbg !398
  %incdec.ptr9 = getelementptr inbounds i64, i64* %40, i32 -1, !dbg !398
  %41 = ptrtoint i64** %curr_high to i64
  call void @__dp_write(i32 163974, i64 %41, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.15, i32 0, i32 0))
  store i64* %incdec.ptr9, i64** %curr_high, align 8, !dbg !398
  %42 = ptrtoint i64* %40 to i64
  call void @__dp_write(i32 163974, i64 %42, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.15, i32 0, i32 0))
  store i64 %38, i64* %40, align 8, !dbg !399
  %43 = ptrtoint i64* %h to i64
  call void @__dp_read(i32 163975, i64 %43, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.17, i32 0, i32 0))
  %44 = load i64, i64* %h, align 8, !dbg !400
  %45 = ptrtoint i64** %curr_low to i64
  call void @__dp_read(i32 163975, i64 %45, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.14, i32 0, i32 0))
  %46 = load i64*, i64** %curr_low, align 8, !dbg !401
  %incdec.ptr10 = getelementptr inbounds i64, i64* %46, i32 1, !dbg !401
  %47 = ptrtoint i64** %curr_low to i64
  call void @__dp_write(i32 163975, i64 %47, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.14, i32 0, i32 0))
  store i64* %incdec.ptr10, i64** %curr_low, align 8, !dbg !401
  %48 = ptrtoint i64* %46 to i64
  call void @__dp_write(i32 163975, i64 %48, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.14, i32 0, i32 0))
  store i64 %44, i64* %46, align 8, !dbg !402
  br label %while.body, !dbg !373, !llvm.loop !403

while.end11:                                      ; preds = %if.then
  call void @__dp_loop_exit(i32 163986, i32 1)
  %49 = ptrtoint i64** %curr_high to i64
  call void @__dp_read(i32 163986, i64 %49, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.15, i32 0, i32 0))
  %50 = load i64*, i64** %curr_high, align 8, !dbg !405
  %51 = ptrtoint i64** %high.addr to i64
  call void @__dp_read(i32 163986, i64 %51, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.11, i32 0, i32 0))
  %52 = load i64*, i64** %high.addr, align 8, !dbg !407
  %cmp12 = icmp ult i64* %50, %52, !dbg !408
  br i1 %cmp12, label %if.then13, label %if.else, !dbg !409

if.then13:                                        ; preds = %while.end11
  %53 = ptrtoint i64** %curr_high to i64
  call void @__dp_read(i32 163987, i64 %53, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.15, i32 0, i32 0))
  %54 = load i64*, i64** %curr_high, align 8, !dbg !410
  %55 = ptrtoint i64** %retval to i64
  call void @__dp_write(i32 163987, i64 %55, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.19, i32 0, i32 0))
  store i64* %54, i64** %retval, align 8, !dbg !411
  br label %return, !dbg !411

if.else:                                          ; preds = %while.end11
  %56 = ptrtoint i64** %curr_high to i64
  call void @__dp_read(i32 163989, i64 %56, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.15, i32 0, i32 0))
  %57 = load i64*, i64** %curr_high, align 8, !dbg !412
  %add.ptr = getelementptr inbounds i64, i64* %57, i64 -1, !dbg !413
  %58 = ptrtoint i64** %retval to i64
  call void @__dp_write(i32 163989, i64 %58, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.19, i32 0, i32 0))
  store i64* %add.ptr, i64** %retval, align 8, !dbg !414
  br label %return, !dbg !414

return:                                           ; preds = %if.else, %if.then13
  %59 = ptrtoint i64** %retval to i64
  call void @__dp_read(i32 163990, i64 %59, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.19, i32 0, i32 0))
  %60 = load i64*, i64** %retval, align 8, !dbg !415
  call void @__dp_func_exit(i32 163990, i32 0), !dbg !415
  ret i64* %60, !dbg !415
}

declare void @__dp_loop_exit(i32, i32)

; Function Attrs: noinline nounwind optnone uwtable
define internal void @insertion_sort(i64* %low, i64* %high) #0 !dbg !416 {
entry:
  call void @__dp_func_entry(i32 164000, i32 0)
  %low.addr = alloca i64*, align 8
  %high.addr = alloca i64*, align 8
  %p = alloca i64*, align 8
  %q = alloca i64*, align 8
  %a = alloca i64, align 8
  %b = alloca i64, align 8
  %0 = ptrtoint i64** %low.addr to i64
  call void @__dp_write(i32 164000, i64 %0, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  store i64* %low, i64** %low.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %low.addr, metadata !417, metadata !DIExpression()), !dbg !418
  %1 = ptrtoint i64** %high.addr to i64
  call void @__dp_write(i32 164000, i64 %1, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.11, i32 0, i32 0))
  store i64* %high, i64** %high.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %high.addr, metadata !419, metadata !DIExpression()), !dbg !420
  call void @llvm.dbg.declare(metadata i64** %p, metadata !421, metadata !DIExpression()), !dbg !422
  call void @llvm.dbg.declare(metadata i64** %q, metadata !423, metadata !DIExpression()), !dbg !424
  call void @llvm.dbg.declare(metadata i64* %a, metadata !425, metadata !DIExpression()), !dbg !426
  call void @llvm.dbg.declare(metadata i64* %b, metadata !427, metadata !DIExpression()), !dbg !428
  %2 = ptrtoint i64** %low.addr to i64
  call void @__dp_read(i32 164005, i64 %2, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  %3 = load i64*, i64** %low.addr, align 8, !dbg !429
  %add.ptr = getelementptr inbounds i64, i64* %3, i64 1, !dbg !431
  %4 = ptrtoint i64** %q to i64
  call void @__dp_write(i32 164005, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.20, i32 0, i32 0))
  store i64* %add.ptr, i64** %q, align 8, !dbg !432
  br label %for.cond, !dbg !433

for.cond:                                         ; preds = %for.inc9, %entry
  call void @__dp_loop_entry(i32 164005, i32 4)
  %5 = ptrtoint i64** %q to i64
  call void @__dp_read(i32 164005, i64 %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.20, i32 0, i32 0))
  %6 = load i64*, i64** %q, align 8, !dbg !434
  %7 = ptrtoint i64** %high.addr to i64
  call void @__dp_read(i32 164005, i64 %7, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.11, i32 0, i32 0))
  %8 = load i64*, i64** %high.addr, align 8, !dbg !436
  %cmp = icmp ule i64* %6, %8, !dbg !437
  br i1 %cmp, label %for.body, label %for.end11, !dbg !438

for.body:                                         ; preds = %for.cond
  %9 = ptrtoint i64** %q to i64
  call void @__dp_read(i32 164006, i64 %9, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.20, i32 0, i32 0))
  %10 = load i64*, i64** %q, align 8, !dbg !439
  %arrayidx = getelementptr inbounds i64, i64* %10, i64 0, !dbg !439
  %11 = ptrtoint i64* %arrayidx to i64
  call void @__dp_read(i32 164006, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.20, i32 0, i32 0))
  %12 = load i64, i64* %arrayidx, align 8, !dbg !439
  %13 = ptrtoint i64* %a to i64
  call void @__dp_write(i32 164006, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.21, i32 0, i32 0))
  store i64 %12, i64* %a, align 8, !dbg !441
  %14 = ptrtoint i64** %q to i64
  call void @__dp_read(i32 164007, i64 %14, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.20, i32 0, i32 0))
  %15 = load i64*, i64** %q, align 8, !dbg !442
  %add.ptr1 = getelementptr inbounds i64, i64* %15, i64 -1, !dbg !444
  %16 = ptrtoint i64** %p to i64
  call void @__dp_write(i32 164007, i64 %16, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.13, i32 0, i32 0))
  store i64* %add.ptr1, i64** %p, align 8, !dbg !445
  br label %for.cond2, !dbg !446

for.cond2:                                        ; preds = %for.inc, %for.body
  call void @__dp_loop_entry(i32 164007, i32 5)
  %17 = ptrtoint i64** %p to i64
  call void @__dp_read(i32 164007, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.13, i32 0, i32 0))
  %18 = load i64*, i64** %p, align 8, !dbg !447
  %19 = ptrtoint i64** %low.addr to i64
  call void @__dp_read(i32 164007, i64 %19, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  %20 = load i64*, i64** %low.addr, align 8, !dbg !449
  %cmp3 = icmp uge i64* %18, %20, !dbg !450
  br i1 %cmp3, label %land.rhs, label %land.end, !dbg !451

land.rhs:                                         ; preds = %for.cond2
  %21 = ptrtoint i64** %p to i64
  call void @__dp_read(i32 164007, i64 %21, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.13, i32 0, i32 0))
  %22 = load i64*, i64** %p, align 8, !dbg !452
  %arrayidx4 = getelementptr inbounds i64, i64* %22, i64 0, !dbg !452
  %23 = ptrtoint i64* %arrayidx4 to i64
  call void @__dp_read(i32 164007, i64 %23, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.13, i32 0, i32 0))
  %24 = load i64, i64* %arrayidx4, align 8, !dbg !452
  %25 = ptrtoint i64* %b to i64
  call void @__dp_write(i32 164007, i64 %25, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.22, i32 0, i32 0))
  store i64 %24, i64* %b, align 8, !dbg !453
  %26 = ptrtoint i64* %a to i64
  call void @__dp_read(i32 164007, i64 %26, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.21, i32 0, i32 0))
  %27 = load i64, i64* %a, align 8, !dbg !454
  %cmp5 = icmp sgt i64 %24, %27, !dbg !455
  br label %land.end

land.end:                                         ; preds = %land.rhs, %for.cond2
  %28 = phi i1 [ false, %for.cond2 ], [ %cmp5, %land.rhs ], !dbg !456
  br i1 %28, label %for.body6, label %for.end, !dbg !457

for.body6:                                        ; preds = %land.end
  %29 = ptrtoint i64* %b to i64
  call void @__dp_read(i32 164008, i64 %29, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.22, i32 0, i32 0))
  %30 = load i64, i64* %b, align 8, !dbg !458
  %31 = ptrtoint i64** %p to i64
  call void @__dp_read(i32 164008, i64 %31, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.13, i32 0, i32 0))
  %32 = load i64*, i64** %p, align 8, !dbg !459
  %arrayidx7 = getelementptr inbounds i64, i64* %32, i64 1, !dbg !459
  %33 = ptrtoint i64* %arrayidx7 to i64
  call void @__dp_write(i32 164008, i64 %33, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.13, i32 0, i32 0))
  store i64 %30, i64* %arrayidx7, align 8, !dbg !460
  br label %for.inc, !dbg !459

for.inc:                                          ; preds = %for.body6
  %34 = ptrtoint i64** %p to i64
  call void @__dp_read(i32 164007, i64 %34, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.13, i32 0, i32 0))
  %35 = load i64*, i64** %p, align 8, !dbg !461
  %incdec.ptr = getelementptr inbounds i64, i64* %35, i32 -1, !dbg !461
  %36 = ptrtoint i64** %p to i64
  call void @__dp_write(i32 164007, i64 %36, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.13, i32 0, i32 0))
  store i64* %incdec.ptr, i64** %p, align 8, !dbg !461
  br label %for.cond2, !dbg !462, !llvm.loop !463

for.end:                                          ; preds = %land.end
  call void @__dp_loop_exit(i32 164009, i32 5)
  %37 = ptrtoint i64* %a to i64
  call void @__dp_read(i32 164009, i64 %37, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.21, i32 0, i32 0))
  %38 = load i64, i64* %a, align 8, !dbg !465
  %39 = ptrtoint i64** %p to i64
  call void @__dp_read(i32 164009, i64 %39, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.13, i32 0, i32 0))
  %40 = load i64*, i64** %p, align 8, !dbg !466
  %arrayidx8 = getelementptr inbounds i64, i64* %40, i64 1, !dbg !466
  %41 = ptrtoint i64* %arrayidx8 to i64
  call void @__dp_write(i32 164009, i64 %41, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.13, i32 0, i32 0))
  store i64 %38, i64* %arrayidx8, align 8, !dbg !467
  br label %for.inc9, !dbg !468

for.inc9:                                         ; preds = %for.end
  %42 = ptrtoint i64** %q to i64
  call void @__dp_read(i32 164005, i64 %42, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.20, i32 0, i32 0))
  %43 = load i64*, i64** %q, align 8, !dbg !469
  %incdec.ptr10 = getelementptr inbounds i64, i64* %43, i32 1, !dbg !469
  %44 = ptrtoint i64** %q to i64
  call void @__dp_write(i32 164005, i64 %44, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.20, i32 0, i32 0))
  store i64* %incdec.ptr10, i64** %q, align 8, !dbg !469
  br label %for.cond, !dbg !470, !llvm.loop !471

for.end11:                                        ; preds = %for.cond
  call void @__dp_loop_exit(i32 164011, i32 4)
  call void @__dp_func_exit(i32 164011, i32 0), !dbg !473
  ret void, !dbg !473
}

declare void @__dp_func_exit(i32, i32)

; Function Attrs: noinline nounwind optnone uwtable
define internal i64 @choose_pivot(i64* %low, i64* %high) #0 !dbg !474 {
entry:
  call void @__dp_func_entry(i32 163950, i32 0)
  %low.addr = alloca i64*, align 8
  %high.addr = alloca i64*, align 8
  %0 = ptrtoint i64** %low.addr to i64
  call void @__dp_write(i32 163950, i64 %0, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  store i64* %low, i64** %low.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %low.addr, metadata !477, metadata !DIExpression()), !dbg !478
  %1 = ptrtoint i64** %high.addr to i64
  call void @__dp_write(i32 163950, i64 %1, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.11, i32 0, i32 0))
  store i64* %high, i64** %high.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %high.addr, metadata !479, metadata !DIExpression()), !dbg !480
  %2 = ptrtoint i64** %low.addr to i64
  call void @__dp_read(i32 163952, i64 %2, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  %3 = load i64*, i64** %low.addr, align 8, !dbg !481
  %4 = ptrtoint i64* %3 to i64
  call void @__dp_read(i32 163952, i64 %4, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  %5 = load i64, i64* %3, align 8, !dbg !482
  %6 = ptrtoint i64** %high.addr to i64
  call void @__dp_read(i32 163952, i64 %6, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.11, i32 0, i32 0))
  %7 = load i64*, i64** %high.addr, align 8, !dbg !483
  %8 = ptrtoint i64* %7 to i64
  call void @__dp_read(i32 163952, i64 %8, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.11, i32 0, i32 0))
  %9 = load i64, i64* %7, align 8, !dbg !484
  %10 = ptrtoint i64** %low.addr to i64
  call void @__dp_read(i32 163952, i64 %10, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  %11 = load i64*, i64** %low.addr, align 8, !dbg !485
  %12 = ptrtoint i64** %high.addr to i64
  call void @__dp_read(i32 163952, i64 %12, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.11, i32 0, i32 0))
  %13 = load i64*, i64** %high.addr, align 8, !dbg !486
  %14 = ptrtoint i64** %low.addr to i64
  call void @__dp_read(i32 163952, i64 %14, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  %15 = load i64*, i64** %low.addr, align 8, !dbg !487
  %sub.ptr.lhs.cast = ptrtoint i64* %13 to i64, !dbg !488
  %sub.ptr.rhs.cast = ptrtoint i64* %15 to i64, !dbg !488
  %sub.ptr.sub = sub i64 %sub.ptr.lhs.cast, %sub.ptr.rhs.cast, !dbg !488
  %sub.ptr.div = sdiv exact i64 %sub.ptr.sub, 8, !dbg !488
  %div = sdiv i64 %sub.ptr.div, 2, !dbg !489
  %arrayidx = getelementptr inbounds i64, i64* %11, i64 %div, !dbg !485
  %16 = ptrtoint i64* %arrayidx to i64
  call void @__dp_read(i32 163952, i64 %16, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  %17 = load i64, i64* %arrayidx, align 8, !dbg !485
  call void @__dp_call(i32 163952), !dbg !490
  %call = call i64 @med3(i64 %5, i64 %9, i64 %17), !dbg !490
  call void @__dp_func_exit(i32 163952, i32 0), !dbg !491
  ret i64 %call, !dbg !491
}

; Function Attrs: noinline nounwind optnone uwtable
define internal i64 @med3(i64 %a, i64 %b, i64 %c) #0 !dbg !492 {
entry:
  call void @__dp_func_entry(i32 163923, i32 0)
  %retval = alloca i64, align 8
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  %c.addr = alloca i64, align 8
  %0 = ptrtoint i64* %a.addr to i64
  call void @__dp_write(i32 163923, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.59, i32 0, i32 0))
  store i64 %a, i64* %a.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %a.addr, metadata !495, metadata !DIExpression()), !dbg !496
  %1 = ptrtoint i64* %b.addr to i64
  call void @__dp_write(i32 163923, i64 %1, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.60, i32 0, i32 0))
  store i64 %b, i64* %b.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %b.addr, metadata !497, metadata !DIExpression()), !dbg !498
  %2 = ptrtoint i64* %c.addr to i64
  call void @__dp_write(i32 163923, i64 %2, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.61, i32 0, i32 0))
  store i64 %c, i64* %c.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %c.addr, metadata !499, metadata !DIExpression()), !dbg !500
  %3 = ptrtoint i64* %a.addr to i64
  call void @__dp_read(i32 163925, i64 %3, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.59, i32 0, i32 0))
  %4 = load i64, i64* %a.addr, align 8, !dbg !501
  %5 = ptrtoint i64* %b.addr to i64
  call void @__dp_read(i32 163925, i64 %5, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.60, i32 0, i32 0))
  %6 = load i64, i64* %b.addr, align 8, !dbg !503
  %cmp = icmp slt i64 %4, %6, !dbg !504
  br i1 %cmp, label %if.then, label %if.else6, !dbg !505

if.then:                                          ; preds = %entry
  %7 = ptrtoint i64* %b.addr to i64
  call void @__dp_read(i32 163926, i64 %7, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.60, i32 0, i32 0))
  %8 = load i64, i64* %b.addr, align 8, !dbg !506
  %9 = ptrtoint i64* %c.addr to i64
  call void @__dp_read(i32 163926, i64 %9, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.61, i32 0, i32 0))
  %10 = load i64, i64* %c.addr, align 8, !dbg !509
  %cmp1 = icmp slt i64 %8, %10, !dbg !510
  br i1 %cmp1, label %if.then2, label %if.else, !dbg !511

if.then2:                                         ; preds = %if.then
  %11 = ptrtoint i64* %b.addr to i64
  call void @__dp_read(i32 163927, i64 %11, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.60, i32 0, i32 0))
  %12 = load i64, i64* %b.addr, align 8, !dbg !512
  %13 = ptrtoint i64* %retval to i64
  call void @__dp_write(i32 163927, i64 %13, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.19, i32 0, i32 0))
  store i64 %12, i64* %retval, align 8, !dbg !514
  br label %return, !dbg !514

if.else:                                          ; preds = %if.then
  %14 = ptrtoint i64* %a.addr to i64
  call void @__dp_read(i32 163929, i64 %14, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.59, i32 0, i32 0))
  %15 = load i64, i64* %a.addr, align 8, !dbg !515
  %16 = ptrtoint i64* %c.addr to i64
  call void @__dp_read(i32 163929, i64 %16, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.61, i32 0, i32 0))
  %17 = load i64, i64* %c.addr, align 8, !dbg !518
  %cmp3 = icmp slt i64 %15, %17, !dbg !519
  br i1 %cmp3, label %if.then4, label %if.else5, !dbg !520

if.then4:                                         ; preds = %if.else
  %18 = ptrtoint i64* %c.addr to i64
  call void @__dp_read(i32 163930, i64 %18, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.61, i32 0, i32 0))
  %19 = load i64, i64* %c.addr, align 8, !dbg !521
  %20 = ptrtoint i64* %retval to i64
  call void @__dp_write(i32 163930, i64 %20, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.19, i32 0, i32 0))
  store i64 %19, i64* %retval, align 8, !dbg !522
  br label %return, !dbg !522

if.else5:                                         ; preds = %if.else
  %21 = ptrtoint i64* %a.addr to i64
  call void @__dp_read(i32 163932, i64 %21, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.59, i32 0, i32 0))
  %22 = load i64, i64* %a.addr, align 8, !dbg !523
  %23 = ptrtoint i64* %retval to i64
  call void @__dp_write(i32 163932, i64 %23, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.19, i32 0, i32 0))
  store i64 %22, i64* %retval, align 8, !dbg !524
  br label %return, !dbg !524

if.else6:                                         ; preds = %entry
  %24 = ptrtoint i64* %b.addr to i64
  call void @__dp_read(i32 163935, i64 %24, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.60, i32 0, i32 0))
  %25 = load i64, i64* %b.addr, align 8, !dbg !525
  %26 = ptrtoint i64* %c.addr to i64
  call void @__dp_read(i32 163935, i64 %26, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.61, i32 0, i32 0))
  %27 = load i64, i64* %c.addr, align 8, !dbg !528
  %cmp7 = icmp sgt i64 %25, %27, !dbg !529
  br i1 %cmp7, label %if.then8, label %if.else9, !dbg !530

if.then8:                                         ; preds = %if.else6
  %28 = ptrtoint i64* %b.addr to i64
  call void @__dp_read(i32 163936, i64 %28, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.60, i32 0, i32 0))
  %29 = load i64, i64* %b.addr, align 8, !dbg !531
  %30 = ptrtoint i64* %retval to i64
  call void @__dp_write(i32 163936, i64 %30, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.19, i32 0, i32 0))
  store i64 %29, i64* %retval, align 8, !dbg !533
  br label %return, !dbg !533

if.else9:                                         ; preds = %if.else6
  %31 = ptrtoint i64* %a.addr to i64
  call void @__dp_read(i32 163938, i64 %31, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.59, i32 0, i32 0))
  %32 = load i64, i64* %a.addr, align 8, !dbg !534
  %33 = ptrtoint i64* %c.addr to i64
  call void @__dp_read(i32 163938, i64 %33, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.61, i32 0, i32 0))
  %34 = load i64, i64* %c.addr, align 8, !dbg !537
  %cmp10 = icmp sgt i64 %32, %34, !dbg !538
  br i1 %cmp10, label %if.then11, label %if.else12, !dbg !539

if.then11:                                        ; preds = %if.else9
  %35 = ptrtoint i64* %c.addr to i64
  call void @__dp_read(i32 163939, i64 %35, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.61, i32 0, i32 0))
  %36 = load i64, i64* %c.addr, align 8, !dbg !540
  %37 = ptrtoint i64* %retval to i64
  call void @__dp_write(i32 163939, i64 %37, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.19, i32 0, i32 0))
  store i64 %36, i64* %retval, align 8, !dbg !541
  br label %return, !dbg !541

if.else12:                                        ; preds = %if.else9
  %38 = ptrtoint i64* %a.addr to i64
  call void @__dp_read(i32 163941, i64 %38, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.59, i32 0, i32 0))
  %39 = load i64, i64* %a.addr, align 8, !dbg !542
  %40 = ptrtoint i64* %retval to i64
  call void @__dp_write(i32 163941, i64 %40, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.19, i32 0, i32 0))
  store i64 %39, i64* %retval, align 8, !dbg !543
  br label %return, !dbg !543

return:                                           ; preds = %if.else12, %if.then11, %if.then8, %if.else5, %if.then4, %if.then2
  %41 = ptrtoint i64* %retval to i64
  call void @__dp_read(i32 163944, i64 %41, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.19, i32 0, i32 0))
  %42 = load i64, i64* %retval, align 8, !dbg !544
  call void @__dp_func_exit(i32 163944, i32 0), !dbg !544
  ret i64 %42, !dbg !544
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @seqmerge(i64* %low1, i64* %high1, i64* %low2, i64* %high2, i64* %lowdest) #0 !dbg !545 {
entry:
  call void @__dp_func_entry(i32 164029, i32 0)
  %low1.addr = alloca i64*, align 8
  %high1.addr = alloca i64*, align 8
  %low2.addr = alloca i64*, align 8
  %high2.addr = alloca i64*, align 8
  %lowdest.addr = alloca i64*, align 8
  %a1 = alloca i64, align 8
  %a2 = alloca i64, align 8
  %0 = ptrtoint i64** %low1.addr to i64
  call void @__dp_write(i32 164029, i64 %0, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  store i64* %low1, i64** %low1.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %low1.addr, metadata !548, metadata !DIExpression()), !dbg !549
  %1 = ptrtoint i64** %high1.addr to i64
  call void @__dp_write(i32 164029, i64 %1, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.24, i32 0, i32 0))
  store i64* %high1, i64** %high1.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %high1.addr, metadata !550, metadata !DIExpression()), !dbg !551
  %2 = ptrtoint i64** %low2.addr to i64
  call void @__dp_write(i32 164029, i64 %2, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0))
  store i64* %low2, i64** %low2.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %low2.addr, metadata !552, metadata !DIExpression()), !dbg !553
  %3 = ptrtoint i64** %high2.addr to i64
  call void @__dp_write(i32 164029, i64 %3, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.26, i32 0, i32 0))
  store i64* %high2, i64** %high2.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %high2.addr, metadata !554, metadata !DIExpression()), !dbg !555
  %4 = ptrtoint i64** %lowdest.addr to i64
  call void @__dp_write(i32 164029, i64 %4, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.27, i32 0, i32 0))
  store i64* %lowdest, i64** %lowdest.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %lowdest.addr, metadata !556, metadata !DIExpression()), !dbg !557
  call void @llvm.dbg.declare(metadata i64* %a1, metadata !558, metadata !DIExpression()), !dbg !559
  call void @llvm.dbg.declare(metadata i64* %a2, metadata !560, metadata !DIExpression()), !dbg !561
  %5 = ptrtoint i64** %low1.addr to i64
  call void @__dp_read(i32 164059, i64 %5, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  %6 = load i64*, i64** %low1.addr, align 8, !dbg !562
  %7 = ptrtoint i64** %high1.addr to i64
  call void @__dp_read(i32 164059, i64 %7, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.24, i32 0, i32 0))
  %8 = load i64*, i64** %high1.addr, align 8, !dbg !564
  %cmp = icmp ult i64* %6, %8, !dbg !565
  br i1 %cmp, label %land.lhs.true, label %if.end13, !dbg !566

land.lhs.true:                                    ; preds = %entry
  %9 = ptrtoint i64** %low2.addr to i64
  call void @__dp_read(i32 164059, i64 %9, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0))
  %10 = load i64*, i64** %low2.addr, align 8, !dbg !567
  %11 = ptrtoint i64** %high2.addr to i64
  call void @__dp_read(i32 164059, i64 %11, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.26, i32 0, i32 0))
  %12 = load i64*, i64** %high2.addr, align 8, !dbg !568
  %cmp1 = icmp ult i64* %10, %12, !dbg !569
  br i1 %cmp1, label %if.then, label %if.end13, !dbg !570

if.then:                                          ; preds = %land.lhs.true
  %13 = ptrtoint i64** %low1.addr to i64
  call void @__dp_read(i32 164060, i64 %13, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  %14 = load i64*, i64** %low1.addr, align 8, !dbg !571
  %15 = ptrtoint i64* %14 to i64
  call void @__dp_read(i32 164060, i64 %15, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  %16 = load i64, i64* %14, align 8, !dbg !573
  %17 = ptrtoint i64* %a1 to i64
  call void @__dp_write(i32 164060, i64 %17, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.28, i32 0, i32 0))
  store i64 %16, i64* %a1, align 8, !dbg !574
  %18 = ptrtoint i64** %low2.addr to i64
  call void @__dp_read(i32 164061, i64 %18, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0))
  %19 = load i64*, i64** %low2.addr, align 8, !dbg !575
  %20 = ptrtoint i64* %19 to i64
  call void @__dp_read(i32 164061, i64 %20, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0))
  %21 = load i64, i64* %19, align 8, !dbg !576
  %22 = ptrtoint i64* %a2 to i64
  call void @__dp_write(i32 164061, i64 %22, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.29, i32 0, i32 0))
  store i64 %21, i64* %a2, align 8, !dbg !577
  br label %for.cond, !dbg !578

for.cond:                                         ; preds = %if.end12, %if.then
  call void @__dp_loop_entry(i32 164063, i32 6)
  %23 = ptrtoint i64* %a1 to i64
  call void @__dp_read(i32 164063, i64 %23, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.28, i32 0, i32 0))
  %24 = load i64, i64* %a1, align 8, !dbg !579
  %25 = ptrtoint i64* %a2 to i64
  call void @__dp_read(i32 164063, i64 %25, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.29, i32 0, i32 0))
  %26 = load i64, i64* %a2, align 8, !dbg !584
  %cmp2 = icmp slt i64 %24, %26, !dbg !585
  br i1 %cmp2, label %if.then3, label %if.else, !dbg !586

if.then3:                                         ; preds = %for.cond
  %27 = ptrtoint i64* %a1 to i64
  call void @__dp_read(i32 164064, i64 %27, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.28, i32 0, i32 0))
  %28 = load i64, i64* %a1, align 8, !dbg !587
  %29 = ptrtoint i64** %lowdest.addr to i64
  call void @__dp_read(i32 164064, i64 %29, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.27, i32 0, i32 0))
  %30 = load i64*, i64** %lowdest.addr, align 8, !dbg !589
  %incdec.ptr = getelementptr inbounds i64, i64* %30, i32 1, !dbg !589
  %31 = ptrtoint i64** %lowdest.addr to i64
  call void @__dp_write(i32 164064, i64 %31, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.27, i32 0, i32 0))
  store i64* %incdec.ptr, i64** %lowdest.addr, align 8, !dbg !589
  %32 = ptrtoint i64* %30 to i64
  call void @__dp_write(i32 164064, i64 %32, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.27, i32 0, i32 0))
  store i64 %28, i64* %30, align 8, !dbg !590
  %33 = ptrtoint i64** %low1.addr to i64
  call void @__dp_read(i32 164065, i64 %33, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  %34 = load i64*, i64** %low1.addr, align 8, !dbg !591
  %incdec.ptr4 = getelementptr inbounds i64, i64* %34, i32 1, !dbg !591
  %35 = ptrtoint i64** %low1.addr to i64
  call void @__dp_write(i32 164065, i64 %35, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  store i64* %incdec.ptr4, i64** %low1.addr, align 8, !dbg !591
  %36 = ptrtoint i64* %incdec.ptr4 to i64
  call void @__dp_read(i32 164065, i64 %36, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  %37 = load i64, i64* %incdec.ptr4, align 8, !dbg !592
  %38 = ptrtoint i64* %a1 to i64
  call void @__dp_write(i32 164065, i64 %38, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.28, i32 0, i32 0))
  store i64 %37, i64* %a1, align 8, !dbg !593
  %39 = ptrtoint i64** %low1.addr to i64
  call void @__dp_read(i32 164066, i64 %39, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  %40 = load i64*, i64** %low1.addr, align 8, !dbg !594
  %41 = ptrtoint i64** %high1.addr to i64
  call void @__dp_read(i32 164066, i64 %41, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.24, i32 0, i32 0))
  %42 = load i64*, i64** %high1.addr, align 8, !dbg !596
  %cmp5 = icmp uge i64* %40, %42, !dbg !597
  br i1 %cmp5, label %if.then6, label %if.end, !dbg !598

if.then6:                                         ; preds = %if.then3
  br label %for.end, !dbg !599

if.end:                                           ; preds = %if.then3
  br label %if.end12, !dbg !600

if.else:                                          ; preds = %for.cond
  %43 = ptrtoint i64* %a2 to i64
  call void @__dp_read(i32 164069, i64 %43, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.29, i32 0, i32 0))
  %44 = load i64, i64* %a2, align 8, !dbg !601
  %45 = ptrtoint i64** %lowdest.addr to i64
  call void @__dp_read(i32 164069, i64 %45, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.27, i32 0, i32 0))
  %46 = load i64*, i64** %lowdest.addr, align 8, !dbg !603
  %incdec.ptr7 = getelementptr inbounds i64, i64* %46, i32 1, !dbg !603
  %47 = ptrtoint i64** %lowdest.addr to i64
  call void @__dp_write(i32 164069, i64 %47, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.27, i32 0, i32 0))
  store i64* %incdec.ptr7, i64** %lowdest.addr, align 8, !dbg !603
  %48 = ptrtoint i64* %46 to i64
  call void @__dp_write(i32 164069, i64 %48, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.27, i32 0, i32 0))
  store i64 %44, i64* %46, align 8, !dbg !604
  %49 = ptrtoint i64** %low2.addr to i64
  call void @__dp_read(i32 164070, i64 %49, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0))
  %50 = load i64*, i64** %low2.addr, align 8, !dbg !605
  %incdec.ptr8 = getelementptr inbounds i64, i64* %50, i32 1, !dbg !605
  %51 = ptrtoint i64** %low2.addr to i64
  call void @__dp_write(i32 164070, i64 %51, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0))
  store i64* %incdec.ptr8, i64** %low2.addr, align 8, !dbg !605
  %52 = ptrtoint i64* %incdec.ptr8 to i64
  call void @__dp_read(i32 164070, i64 %52, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0))
  %53 = load i64, i64* %incdec.ptr8, align 8, !dbg !606
  %54 = ptrtoint i64* %a2 to i64
  call void @__dp_write(i32 164070, i64 %54, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.29, i32 0, i32 0))
  store i64 %53, i64* %a2, align 8, !dbg !607
  %55 = ptrtoint i64** %low2.addr to i64
  call void @__dp_read(i32 164071, i64 %55, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0))
  %56 = load i64*, i64** %low2.addr, align 8, !dbg !608
  %57 = ptrtoint i64** %high2.addr to i64
  call void @__dp_read(i32 164071, i64 %57, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.26, i32 0, i32 0))
  %58 = load i64*, i64** %high2.addr, align 8, !dbg !610
  %cmp9 = icmp uge i64* %56, %58, !dbg !611
  br i1 %cmp9, label %if.then10, label %if.end11, !dbg !612

if.then10:                                        ; preds = %if.else
  br label %for.end, !dbg !613

if.end11:                                         ; preds = %if.else
  br label %if.end12

if.end12:                                         ; preds = %if.end11, %if.end
  br label %for.cond, !dbg !614, !llvm.loop !615

for.end:                                          ; preds = %if.then10, %if.then6
  call void @__dp_loop_exit(i32 164075, i32 6)
  br label %if.end13, !dbg !618

if.end13:                                         ; preds = %for.end, %land.lhs.true, %entry
  %59 = ptrtoint i64** %low1.addr to i64
  call void @__dp_read(i32 164076, i64 %59, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  %60 = load i64*, i64** %low1.addr, align 8, !dbg !619
  %61 = ptrtoint i64** %high1.addr to i64
  call void @__dp_read(i32 164076, i64 %61, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.24, i32 0, i32 0))
  %62 = load i64*, i64** %high1.addr, align 8, !dbg !621
  %cmp14 = icmp ule i64* %60, %62, !dbg !622
  br i1 %cmp14, label %land.lhs.true15, label %if.end34, !dbg !623

land.lhs.true15:                                  ; preds = %if.end13
  %63 = ptrtoint i64** %low2.addr to i64
  call void @__dp_read(i32 164076, i64 %63, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0))
  %64 = load i64*, i64** %low2.addr, align 8, !dbg !624
  %65 = ptrtoint i64** %high2.addr to i64
  call void @__dp_read(i32 164076, i64 %65, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.26, i32 0, i32 0))
  %66 = load i64*, i64** %high2.addr, align 8, !dbg !625
  %cmp16 = icmp ule i64* %64, %66, !dbg !626
  br i1 %cmp16, label %if.then17, label %if.end34, !dbg !627

if.then17:                                        ; preds = %land.lhs.true15
  %67 = ptrtoint i64** %low1.addr to i64
  call void @__dp_read(i32 164077, i64 %67, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  %68 = load i64*, i64** %low1.addr, align 8, !dbg !628
  %69 = ptrtoint i64* %68 to i64
  call void @__dp_read(i32 164077, i64 %69, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  %70 = load i64, i64* %68, align 8, !dbg !630
  %71 = ptrtoint i64* %a1 to i64
  call void @__dp_write(i32 164077, i64 %71, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.28, i32 0, i32 0))
  store i64 %70, i64* %a1, align 8, !dbg !631
  %72 = ptrtoint i64** %low2.addr to i64
  call void @__dp_read(i32 164078, i64 %72, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0))
  %73 = load i64*, i64** %low2.addr, align 8, !dbg !632
  %74 = ptrtoint i64* %73 to i64
  call void @__dp_read(i32 164078, i64 %74, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0))
  %75 = load i64, i64* %73, align 8, !dbg !633
  %76 = ptrtoint i64* %a2 to i64
  call void @__dp_write(i32 164078, i64 %76, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.29, i32 0, i32 0))
  store i64 %75, i64* %a2, align 8, !dbg !634
  br label %for.cond18, !dbg !635

for.cond18:                                       ; preds = %if.end32, %if.then17
  call void @__dp_loop_entry(i32 164080, i32 7)
  %77 = ptrtoint i64* %a1 to i64
  call void @__dp_read(i32 164080, i64 %77, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.28, i32 0, i32 0))
  %78 = load i64, i64* %a1, align 8, !dbg !636
  %79 = ptrtoint i64* %a2 to i64
  call void @__dp_read(i32 164080, i64 %79, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.29, i32 0, i32 0))
  %80 = load i64, i64* %a2, align 8, !dbg !641
  %cmp19 = icmp slt i64 %78, %80, !dbg !642
  br i1 %cmp19, label %if.then20, label %if.else26, !dbg !643

if.then20:                                        ; preds = %for.cond18
  %81 = ptrtoint i64* %a1 to i64
  call void @__dp_read(i32 164081, i64 %81, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.28, i32 0, i32 0))
  %82 = load i64, i64* %a1, align 8, !dbg !644
  %83 = ptrtoint i64** %lowdest.addr to i64
  call void @__dp_read(i32 164081, i64 %83, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.27, i32 0, i32 0))
  %84 = load i64*, i64** %lowdest.addr, align 8, !dbg !646
  %incdec.ptr21 = getelementptr inbounds i64, i64* %84, i32 1, !dbg !646
  %85 = ptrtoint i64** %lowdest.addr to i64
  call void @__dp_write(i32 164081, i64 %85, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.27, i32 0, i32 0))
  store i64* %incdec.ptr21, i64** %lowdest.addr, align 8, !dbg !646
  %86 = ptrtoint i64* %84 to i64
  call void @__dp_write(i32 164081, i64 %86, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.27, i32 0, i32 0))
  store i64 %82, i64* %84, align 8, !dbg !647
  %87 = ptrtoint i64** %low1.addr to i64
  call void @__dp_read(i32 164082, i64 %87, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  %88 = load i64*, i64** %low1.addr, align 8, !dbg !648
  %incdec.ptr22 = getelementptr inbounds i64, i64* %88, i32 1, !dbg !648
  %89 = ptrtoint i64** %low1.addr to i64
  call void @__dp_write(i32 164082, i64 %89, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  store i64* %incdec.ptr22, i64** %low1.addr, align 8, !dbg !648
  %90 = ptrtoint i64** %low1.addr to i64
  call void @__dp_read(i32 164083, i64 %90, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  %91 = load i64*, i64** %low1.addr, align 8, !dbg !649
  %92 = ptrtoint i64** %high1.addr to i64
  call void @__dp_read(i32 164083, i64 %92, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.24, i32 0, i32 0))
  %93 = load i64*, i64** %high1.addr, align 8, !dbg !651
  %cmp23 = icmp ugt i64* %91, %93, !dbg !652
  br i1 %cmp23, label %if.then24, label %if.end25, !dbg !653

if.then24:                                        ; preds = %if.then20
  br label %for.end33, !dbg !654

if.end25:                                         ; preds = %if.then20
  %94 = ptrtoint i64** %low1.addr to i64
  call void @__dp_read(i32 164085, i64 %94, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  %95 = load i64*, i64** %low1.addr, align 8, !dbg !655
  %96 = ptrtoint i64* %95 to i64
  call void @__dp_read(i32 164085, i64 %96, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  %97 = load i64, i64* %95, align 8, !dbg !656
  %98 = ptrtoint i64* %a1 to i64
  call void @__dp_write(i32 164085, i64 %98, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.28, i32 0, i32 0))
  store i64 %97, i64* %a1, align 8, !dbg !657
  br label %if.end32, !dbg !658

if.else26:                                        ; preds = %for.cond18
  %99 = ptrtoint i64* %a2 to i64
  call void @__dp_read(i32 164087, i64 %99, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.29, i32 0, i32 0))
  %100 = load i64, i64* %a2, align 8, !dbg !659
  %101 = ptrtoint i64** %lowdest.addr to i64
  call void @__dp_read(i32 164087, i64 %101, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.27, i32 0, i32 0))
  %102 = load i64*, i64** %lowdest.addr, align 8, !dbg !661
  %incdec.ptr27 = getelementptr inbounds i64, i64* %102, i32 1, !dbg !661
  %103 = ptrtoint i64** %lowdest.addr to i64
  call void @__dp_write(i32 164087, i64 %103, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.27, i32 0, i32 0))
  store i64* %incdec.ptr27, i64** %lowdest.addr, align 8, !dbg !661
  %104 = ptrtoint i64* %102 to i64
  call void @__dp_write(i32 164087, i64 %104, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.27, i32 0, i32 0))
  store i64 %100, i64* %102, align 8, !dbg !662
  %105 = ptrtoint i64** %low2.addr to i64
  call void @__dp_read(i32 164088, i64 %105, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0))
  %106 = load i64*, i64** %low2.addr, align 8, !dbg !663
  %incdec.ptr28 = getelementptr inbounds i64, i64* %106, i32 1, !dbg !663
  %107 = ptrtoint i64** %low2.addr to i64
  call void @__dp_write(i32 164088, i64 %107, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0))
  store i64* %incdec.ptr28, i64** %low2.addr, align 8, !dbg !663
  %108 = ptrtoint i64** %low2.addr to i64
  call void @__dp_read(i32 164089, i64 %108, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0))
  %109 = load i64*, i64** %low2.addr, align 8, !dbg !664
  %110 = ptrtoint i64** %high2.addr to i64
  call void @__dp_read(i32 164089, i64 %110, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.26, i32 0, i32 0))
  %111 = load i64*, i64** %high2.addr, align 8, !dbg !666
  %cmp29 = icmp ugt i64* %109, %111, !dbg !667
  br i1 %cmp29, label %if.then30, label %if.end31, !dbg !668

if.then30:                                        ; preds = %if.else26
  br label %for.end33, !dbg !669

if.end31:                                         ; preds = %if.else26
  %112 = ptrtoint i64** %low2.addr to i64
  call void @__dp_read(i32 164091, i64 %112, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0))
  %113 = load i64*, i64** %low2.addr, align 8, !dbg !670
  %114 = ptrtoint i64* %113 to i64
  call void @__dp_read(i32 164091, i64 %114, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0))
  %115 = load i64, i64* %113, align 8, !dbg !671
  %116 = ptrtoint i64* %a2 to i64
  call void @__dp_write(i32 164091, i64 %116, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.29, i32 0, i32 0))
  store i64 %115, i64* %a2, align 8, !dbg !672
  br label %if.end32

if.end32:                                         ; preds = %if.end31, %if.end25
  br label %for.cond18, !dbg !673, !llvm.loop !674

for.end33:                                        ; preds = %if.then30, %if.then24
  call void @__dp_loop_exit(i32 164094, i32 7)
  br label %if.end34, !dbg !677

if.end34:                                         ; preds = %for.end33, %land.lhs.true15, %if.end13
  %117 = ptrtoint i64** %low1.addr to i64
  call void @__dp_read(i32 164095, i64 %117, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  %118 = load i64*, i64** %low1.addr, align 8, !dbg !678
  %119 = ptrtoint i64** %high1.addr to i64
  call void @__dp_read(i32 164095, i64 %119, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.24, i32 0, i32 0))
  %120 = load i64*, i64** %high1.addr, align 8, !dbg !680
  %cmp35 = icmp ugt i64* %118, %120, !dbg !681
  br i1 %cmp35, label %if.then36, label %if.else37, !dbg !682

if.then36:                                        ; preds = %if.end34
  %121 = ptrtoint i64** %lowdest.addr to i64
  call void @__dp_read(i32 164096, i64 %121, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.27, i32 0, i32 0))
  %122 = load i64*, i64** %lowdest.addr, align 8, !dbg !683
  %123 = bitcast i64* %122 to i8*, !dbg !685
  %124 = ptrtoint i64** %low2.addr to i64
  call void @__dp_read(i32 164096, i64 %124, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0))
  %125 = load i64*, i64** %low2.addr, align 8, !dbg !686
  %126 = bitcast i64* %125 to i8*, !dbg !685
  %127 = ptrtoint i64** %high2.addr to i64
  call void @__dp_read(i32 164096, i64 %127, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.26, i32 0, i32 0))
  %128 = load i64*, i64** %high2.addr, align 8, !dbg !687
  %129 = ptrtoint i64** %low2.addr to i64
  call void @__dp_read(i32 164096, i64 %129, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0))
  %130 = load i64*, i64** %low2.addr, align 8, !dbg !688
  %sub.ptr.lhs.cast = ptrtoint i64* %128 to i64, !dbg !689
  %sub.ptr.rhs.cast = ptrtoint i64* %130 to i64, !dbg !689
  %sub.ptr.sub = sub i64 %sub.ptr.lhs.cast, %sub.ptr.rhs.cast, !dbg !689
  %sub.ptr.div = sdiv exact i64 %sub.ptr.sub, 8, !dbg !689
  %add = add nsw i64 %sub.ptr.div, 1, !dbg !690
  %mul = mul i64 8, %add, !dbg !691
  call void @__dp_call(i32 164096), !dbg !685
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %123, i8* align 8 %126, i64 %mul, i1 false), !dbg !685
  br label %if.end44, !dbg !692

if.else37:                                        ; preds = %if.end34
  %131 = ptrtoint i64** %lowdest.addr to i64
  call void @__dp_read(i32 164098, i64 %131, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.27, i32 0, i32 0))
  %132 = load i64*, i64** %lowdest.addr, align 8, !dbg !693
  %133 = bitcast i64* %132 to i8*, !dbg !695
  %134 = ptrtoint i64** %low1.addr to i64
  call void @__dp_read(i32 164098, i64 %134, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  %135 = load i64*, i64** %low1.addr, align 8, !dbg !696
  %136 = bitcast i64* %135 to i8*, !dbg !695
  %137 = ptrtoint i64** %high1.addr to i64
  call void @__dp_read(i32 164098, i64 %137, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.24, i32 0, i32 0))
  %138 = load i64*, i64** %high1.addr, align 8, !dbg !697
  %139 = ptrtoint i64** %low1.addr to i64
  call void @__dp_read(i32 164098, i64 %139, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  %140 = load i64*, i64** %low1.addr, align 8, !dbg !698
  %sub.ptr.lhs.cast38 = ptrtoint i64* %138 to i64, !dbg !699
  %sub.ptr.rhs.cast39 = ptrtoint i64* %140 to i64, !dbg !699
  %sub.ptr.sub40 = sub i64 %sub.ptr.lhs.cast38, %sub.ptr.rhs.cast39, !dbg !699
  %sub.ptr.div41 = sdiv exact i64 %sub.ptr.sub40, 8, !dbg !699
  %add42 = add nsw i64 %sub.ptr.div41, 1, !dbg !700
  %mul43 = mul i64 8, %add42, !dbg !701
  call void @__dp_call(i32 164098), !dbg !695
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %133, i8* align 8 %136, i64 %mul43, i1 false), !dbg !695
  br label %if.end44

if.end44:                                         ; preds = %if.else37, %if.then36
  call void @__dp_func_exit(i32 164100, i32 0), !dbg !702
  ret void, !dbg !702
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i64* @binsplit(i64 %val, i64* %low, i64* %high) #0 !dbg !703 {
entry:
  call void @__dp_func_entry(i32 164110, i32 0)
  %retval = alloca i64*, align 8
  %val.addr = alloca i64, align 8
  %low.addr = alloca i64*, align 8
  %high.addr = alloca i64*, align 8
  %mid = alloca i64*, align 8
  %0 = ptrtoint i64* %val.addr to i64
  call void @__dp_write(i32 164110, i64 %0, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.30, i32 0, i32 0))
  store i64 %val, i64* %val.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %val.addr, metadata !706, metadata !DIExpression()), !dbg !707
  %1 = ptrtoint i64** %low.addr to i64
  call void @__dp_write(i32 164110, i64 %1, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  store i64* %low, i64** %low.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %low.addr, metadata !708, metadata !DIExpression()), !dbg !709
  %2 = ptrtoint i64** %high.addr to i64
  call void @__dp_write(i32 164110, i64 %2, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.11, i32 0, i32 0))
  store i64* %high, i64** %high.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %high.addr, metadata !710, metadata !DIExpression()), !dbg !711
  call void @llvm.dbg.declare(metadata i64** %mid, metadata !712, metadata !DIExpression()), !dbg !713
  br label %while.cond, !dbg !714

while.cond:                                       ; preds = %if.end, %entry
  call void @__dp_loop_entry(i32 164118, i32 8)
  %3 = ptrtoint i64** %low.addr to i64
  call void @__dp_read(i32 164118, i64 %3, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  %4 = load i64*, i64** %low.addr, align 8, !dbg !715
  %5 = ptrtoint i64** %high.addr to i64
  call void @__dp_read(i32 164118, i64 %5, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.11, i32 0, i32 0))
  %6 = load i64*, i64** %high.addr, align 8, !dbg !716
  %cmp = icmp ne i64* %4, %6, !dbg !717
  br i1 %cmp, label %while.body, label %while.end, !dbg !714

while.body:                                       ; preds = %while.cond
  %7 = ptrtoint i64** %low.addr to i64
  call void @__dp_read(i32 164119, i64 %7, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  %8 = load i64*, i64** %low.addr, align 8, !dbg !718
  %9 = ptrtoint i64** %high.addr to i64
  call void @__dp_read(i32 164119, i64 %9, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.11, i32 0, i32 0))
  %10 = load i64*, i64** %high.addr, align 8, !dbg !720
  %11 = ptrtoint i64** %low.addr to i64
  call void @__dp_read(i32 164119, i64 %11, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  %12 = load i64*, i64** %low.addr, align 8, !dbg !721
  %sub.ptr.lhs.cast = ptrtoint i64* %10 to i64, !dbg !722
  %sub.ptr.rhs.cast = ptrtoint i64* %12 to i64, !dbg !722
  %sub.ptr.sub = sub i64 %sub.ptr.lhs.cast, %sub.ptr.rhs.cast, !dbg !722
  %sub.ptr.div = sdiv exact i64 %sub.ptr.sub, 8, !dbg !722
  %add = add nsw i64 %sub.ptr.div, 1, !dbg !723
  %shr = ashr i64 %add, 1, !dbg !724
  %add.ptr = getelementptr inbounds i64, i64* %8, i64 %shr, !dbg !725
  %13 = ptrtoint i64** %mid to i64
  call void @__dp_write(i32 164119, i64 %13, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.31, i32 0, i32 0))
  store i64* %add.ptr, i64** %mid, align 8, !dbg !726
  %14 = ptrtoint i64* %val.addr to i64
  call void @__dp_read(i32 164120, i64 %14, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.30, i32 0, i32 0))
  %15 = load i64, i64* %val.addr, align 8, !dbg !727
  %16 = ptrtoint i64** %mid to i64
  call void @__dp_read(i32 164120, i64 %16, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.31, i32 0, i32 0))
  %17 = load i64*, i64** %mid, align 8, !dbg !729
  %18 = ptrtoint i64* %17 to i64
  call void @__dp_read(i32 164120, i64 %18, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.31, i32 0, i32 0))
  %19 = load i64, i64* %17, align 8, !dbg !730
  %cmp1 = icmp sle i64 %15, %19, !dbg !731
  br i1 %cmp1, label %if.then, label %if.else, !dbg !732

if.then:                                          ; preds = %while.body
  %20 = ptrtoint i64** %mid to i64
  call void @__dp_read(i32 164121, i64 %20, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.31, i32 0, i32 0))
  %21 = load i64*, i64** %mid, align 8, !dbg !733
  %add.ptr2 = getelementptr inbounds i64, i64* %21, i64 -1, !dbg !734
  %22 = ptrtoint i64** %high.addr to i64
  call void @__dp_write(i32 164121, i64 %22, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.11, i32 0, i32 0))
  store i64* %add.ptr2, i64** %high.addr, align 8, !dbg !735
  br label %if.end, !dbg !736

if.else:                                          ; preds = %while.body
  %23 = ptrtoint i64** %mid to i64
  call void @__dp_read(i32 164123, i64 %23, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.31, i32 0, i32 0))
  %24 = load i64*, i64** %mid, align 8, !dbg !737
  %25 = ptrtoint i64** %low.addr to i64
  call void @__dp_write(i32 164123, i64 %25, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  store i64* %24, i64** %low.addr, align 8, !dbg !738
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  br label %while.cond, !dbg !714, !llvm.loop !739

while.end:                                        ; preds = %while.cond
  call void @__dp_loop_exit(i32 164126, i32 8)
  %26 = ptrtoint i64** %low.addr to i64
  call void @__dp_read(i32 164126, i64 %26, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  %27 = load i64*, i64** %low.addr, align 8, !dbg !741
  %28 = ptrtoint i64* %27 to i64
  call void @__dp_read(i32 164126, i64 %28, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  %29 = load i64, i64* %27, align 8, !dbg !743
  %30 = ptrtoint i64* %val.addr to i64
  call void @__dp_read(i32 164126, i64 %30, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.30, i32 0, i32 0))
  %31 = load i64, i64* %val.addr, align 8, !dbg !744
  %cmp3 = icmp sgt i64 %29, %31, !dbg !745
  br i1 %cmp3, label %if.then4, label %if.else6, !dbg !746

if.then4:                                         ; preds = %while.end
  %32 = ptrtoint i64** %low.addr to i64
  call void @__dp_read(i32 164127, i64 %32, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  %33 = load i64*, i64** %low.addr, align 8, !dbg !747
  %add.ptr5 = getelementptr inbounds i64, i64* %33, i64 -1, !dbg !748
  %34 = ptrtoint i64** %retval to i64
  call void @__dp_write(i32 164127, i64 %34, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.19, i32 0, i32 0))
  store i64* %add.ptr5, i64** %retval, align 8, !dbg !749
  br label %return, !dbg !749

if.else6:                                         ; preds = %while.end
  %35 = ptrtoint i64** %low.addr to i64
  call void @__dp_read(i32 164129, i64 %35, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  %36 = load i64*, i64** %low.addr, align 8, !dbg !750
  %37 = ptrtoint i64** %retval to i64
  call void @__dp_write(i32 164129, i64 %37, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.19, i32 0, i32 0))
  store i64* %36, i64** %retval, align 8, !dbg !751
  br label %return, !dbg !751

return:                                           ; preds = %if.else6, %if.then4
  %38 = ptrtoint i64** %retval to i64
  call void @__dp_read(i32 164130, i64 %38, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.19, i32 0, i32 0))
  %39 = load i64*, i64** %retval, align 8, !dbg !752
  call void @__dp_func_exit(i32 164130, i32 0), !dbg !752
  ret i64* %39, !dbg !752
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @cilkmerge(i64* %low1, i64* %high1, i64* %low2, i64* %high2, i64* %lowdest) #0 !dbg !753 {
entry:
  call void @__dp_func_entry(i32 164132, i32 0)
  %low1.addr = alloca i64*, align 8
  %high1.addr = alloca i64*, align 8
  %low2.addr = alloca i64*, align 8
  %high2.addr = alloca i64*, align 8
  %lowdest.addr = alloca i64*, align 8
  %split1 = alloca i64*, align 8
  %split2 = alloca i64*, align 8
  %lowsize = alloca i64, align 8
  %tmp = alloca i64*, align 8
  %tmp5 = alloca i64*, align 8
  %0 = ptrtoint i64** %low1.addr to i64
  call void @__dp_write(i32 164132, i64 %0, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  store i64* %low1, i64** %low1.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %low1.addr, metadata !754, metadata !DIExpression()), !dbg !755
  %1 = ptrtoint i64** %high1.addr to i64
  call void @__dp_write(i32 164132, i64 %1, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.24, i32 0, i32 0))
  store i64* %high1, i64** %high1.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %high1.addr, metadata !756, metadata !DIExpression()), !dbg !757
  %2 = ptrtoint i64** %low2.addr to i64
  call void @__dp_write(i32 164132, i64 %2, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0))
  store i64* %low2, i64** %low2.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %low2.addr, metadata !758, metadata !DIExpression()), !dbg !759
  %3 = ptrtoint i64** %high2.addr to i64
  call void @__dp_write(i32 164132, i64 %3, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.26, i32 0, i32 0))
  store i64* %high2, i64** %high2.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %high2.addr, metadata !760, metadata !DIExpression()), !dbg !761
  %4 = ptrtoint i64** %lowdest.addr to i64
  call void @__dp_write(i32 164132, i64 %4, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.27, i32 0, i32 0))
  store i64* %lowdest, i64** %lowdest.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %lowdest.addr, metadata !762, metadata !DIExpression()), !dbg !763
  call void @llvm.dbg.declare(metadata i64** %split1, metadata !764, metadata !DIExpression()), !dbg !765
  call void @llvm.dbg.declare(metadata i64** %split2, metadata !766, metadata !DIExpression()), !dbg !767
  call void @llvm.dbg.declare(metadata i64* %lowsize, metadata !768, metadata !DIExpression()), !dbg !769
  %5 = ptrtoint i64** %high2.addr to i64
  call void @__dp_read(i32 164155, i64 %5, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.26, i32 0, i32 0))
  %6 = load i64*, i64** %high2.addr, align 8, !dbg !770
  %7 = ptrtoint i64** %low2.addr to i64
  call void @__dp_read(i32 164155, i64 %7, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0))
  %8 = load i64*, i64** %low2.addr, align 8, !dbg !772
  %sub.ptr.lhs.cast = ptrtoint i64* %6 to i64, !dbg !773
  %sub.ptr.rhs.cast = ptrtoint i64* %8 to i64, !dbg !773
  %sub.ptr.sub = sub i64 %sub.ptr.lhs.cast, %sub.ptr.rhs.cast, !dbg !773
  %sub.ptr.div = sdiv exact i64 %sub.ptr.sub, 8, !dbg !773
  %9 = ptrtoint i64** %high1.addr to i64
  call void @__dp_read(i32 164155, i64 %9, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.24, i32 0, i32 0))
  %10 = load i64*, i64** %high1.addr, align 8, !dbg !774
  %11 = ptrtoint i64** %low1.addr to i64
  call void @__dp_read(i32 164155, i64 %11, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  %12 = load i64*, i64** %low1.addr, align 8, !dbg !775
  %sub.ptr.lhs.cast1 = ptrtoint i64* %10 to i64, !dbg !776
  %sub.ptr.rhs.cast2 = ptrtoint i64* %12 to i64, !dbg !776
  %sub.ptr.sub3 = sub i64 %sub.ptr.lhs.cast1, %sub.ptr.rhs.cast2, !dbg !776
  %sub.ptr.div4 = sdiv exact i64 %sub.ptr.sub3, 8, !dbg !776
  %cmp = icmp sgt i64 %sub.ptr.div, %sub.ptr.div4, !dbg !777
  br i1 %cmp, label %if.then, label %if.end, !dbg !778

if.then:                                          ; preds = %entry
  call void @llvm.dbg.declare(metadata i64** %tmp, metadata !779, metadata !DIExpression()), !dbg !782
  %13 = ptrtoint i64** %low1.addr to i64
  call void @__dp_read(i32 164156, i64 %13, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  %14 = load i64*, i64** %low1.addr, align 8, !dbg !782
  %15 = ptrtoint i64** %tmp to i64
  call void @__dp_write(i32 164156, i64 %15, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.32, i32 0, i32 0))
  store i64* %14, i64** %tmp, align 8, !dbg !782
  %16 = ptrtoint i64** %low2.addr to i64
  call void @__dp_read(i32 164156, i64 %16, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0))
  %17 = load i64*, i64** %low2.addr, align 8, !dbg !782
  %18 = ptrtoint i64** %low1.addr to i64
  call void @__dp_write(i32 164156, i64 %18, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  store i64* %17, i64** %low1.addr, align 8, !dbg !782
  %19 = ptrtoint i64** %tmp to i64
  call void @__dp_read(i32 164156, i64 %19, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.32, i32 0, i32 0))
  %20 = load i64*, i64** %tmp, align 8, !dbg !782
  %21 = ptrtoint i64** %low2.addr to i64
  call void @__dp_write(i32 164156, i64 %21, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0))
  store i64* %20, i64** %low2.addr, align 8, !dbg !782
  call void @llvm.dbg.declare(metadata i64** %tmp5, metadata !783, metadata !DIExpression()), !dbg !785
  %22 = ptrtoint i64** %high1.addr to i64
  call void @__dp_read(i32 164157, i64 %22, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.24, i32 0, i32 0))
  %23 = load i64*, i64** %high1.addr, align 8, !dbg !785
  %24 = ptrtoint i64** %tmp5 to i64
  call void @__dp_write(i32 164157, i64 %24, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.33, i32 0, i32 0))
  store i64* %23, i64** %tmp5, align 8, !dbg !785
  %25 = ptrtoint i64** %high2.addr to i64
  call void @__dp_read(i32 164157, i64 %25, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.26, i32 0, i32 0))
  %26 = load i64*, i64** %high2.addr, align 8, !dbg !785
  %27 = ptrtoint i64** %high1.addr to i64
  call void @__dp_write(i32 164157, i64 %27, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.24, i32 0, i32 0))
  store i64* %26, i64** %high1.addr, align 8, !dbg !785
  %28 = ptrtoint i64** %tmp5 to i64
  call void @__dp_read(i32 164157, i64 %28, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.33, i32 0, i32 0))
  %29 = load i64*, i64** %tmp5, align 8, !dbg !785
  %30 = ptrtoint i64** %high2.addr to i64
  call void @__dp_write(i32 164157, i64 %30, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.26, i32 0, i32 0))
  store i64* %29, i64** %high2.addr, align 8, !dbg !785
  br label %if.end, !dbg !786

if.end:                                           ; preds = %if.then, %entry
  %31 = ptrtoint i64** %high2.addr to i64
  call void @__dp_read(i32 164159, i64 %31, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.26, i32 0, i32 0))
  %32 = load i64*, i64** %high2.addr, align 8, !dbg !787
  %33 = ptrtoint i64** %low2.addr to i64
  call void @__dp_read(i32 164159, i64 %33, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0))
  %34 = load i64*, i64** %low2.addr, align 8, !dbg !789
  %cmp6 = icmp ult i64* %32, %34, !dbg !790
  br i1 %cmp6, label %if.then7, label %if.end12, !dbg !791

if.then7:                                         ; preds = %if.end
  %35 = ptrtoint i64** %lowdest.addr to i64
  call void @__dp_read(i32 164161, i64 %35, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.27, i32 0, i32 0))
  %36 = load i64*, i64** %lowdest.addr, align 8, !dbg !792
  %37 = bitcast i64* %36 to i8*, !dbg !794
  %38 = ptrtoint i64** %low1.addr to i64
  call void @__dp_read(i32 164161, i64 %38, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  %39 = load i64*, i64** %low1.addr, align 8, !dbg !795
  %40 = bitcast i64* %39 to i8*, !dbg !794
  %41 = ptrtoint i64** %high1.addr to i64
  call void @__dp_read(i32 164161, i64 %41, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.24, i32 0, i32 0))
  %42 = load i64*, i64** %high1.addr, align 8, !dbg !796
  %43 = ptrtoint i64** %low1.addr to i64
  call void @__dp_read(i32 164161, i64 %43, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  %44 = load i64*, i64** %low1.addr, align 8, !dbg !797
  %sub.ptr.lhs.cast8 = ptrtoint i64* %42 to i64, !dbg !798
  %sub.ptr.rhs.cast9 = ptrtoint i64* %44 to i64, !dbg !798
  %sub.ptr.sub10 = sub i64 %sub.ptr.lhs.cast8, %sub.ptr.rhs.cast9, !dbg !798
  %sub.ptr.div11 = sdiv exact i64 %sub.ptr.sub10, 8, !dbg !798
  %mul = mul i64 8, %sub.ptr.div11, !dbg !799
  call void @__dp_call(i32 164161), !dbg !794
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %37, i8* align 8 %40, i64 %mul, i1 false), !dbg !794
  br label %return, !dbg !800

if.end12:                                         ; preds = %if.end
  %45 = ptrtoint i64** %high2.addr to i64
  call void @__dp_read(i32 164164, i64 %45, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.26, i32 0, i32 0))
  %46 = load i64*, i64** %high2.addr, align 8, !dbg !801
  %47 = ptrtoint i64** %low2.addr to i64
  call void @__dp_read(i32 164164, i64 %47, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0))
  %48 = load i64*, i64** %low2.addr, align 8, !dbg !803
  %sub.ptr.lhs.cast13 = ptrtoint i64* %46 to i64, !dbg !804
  %sub.ptr.rhs.cast14 = ptrtoint i64* %48 to i64, !dbg !804
  %sub.ptr.sub15 = sub i64 %sub.ptr.lhs.cast13, %sub.ptr.rhs.cast14, !dbg !804
  %sub.ptr.div16 = sdiv exact i64 %sub.ptr.sub15, 8, !dbg !804
  %49 = ptrtoint i32* @bots_app_cutoff_value to i64
  call void @__dp_read(i32 164164, i64 %49, i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.34, i32 0, i32 0))
  %50 = load i32, i32* @bots_app_cutoff_value, align 4, !dbg !805
  %conv = sext i32 %50 to i64, !dbg !805
  %cmp17 = icmp slt i64 %sub.ptr.div16, %conv, !dbg !806
  br i1 %cmp17, label %if.then19, label %if.end20, !dbg !807

if.then19:                                        ; preds = %if.end12
  %51 = ptrtoint i64** %low1.addr to i64
  call void @__dp_read(i32 164165, i64 %51, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  %52 = load i64*, i64** %low1.addr, align 8, !dbg !808
  %53 = ptrtoint i64** %high1.addr to i64
  call void @__dp_read(i32 164165, i64 %53, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.24, i32 0, i32 0))
  %54 = load i64*, i64** %high1.addr, align 8, !dbg !810
  %55 = ptrtoint i64** %low2.addr to i64
  call void @__dp_read(i32 164165, i64 %55, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0))
  %56 = load i64*, i64** %low2.addr, align 8, !dbg !811
  %57 = ptrtoint i64** %high2.addr to i64
  call void @__dp_read(i32 164165, i64 %57, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.26, i32 0, i32 0))
  %58 = load i64*, i64** %high2.addr, align 8, !dbg !812
  %59 = ptrtoint i64** %lowdest.addr to i64
  call void @__dp_read(i32 164165, i64 %59, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.27, i32 0, i32 0))
  %60 = load i64*, i64** %lowdest.addr, align 8, !dbg !813
  call void @__dp_call(i32 164165), !dbg !814
  call void @seqmerge(i64* %52, i64* %54, i64* %56, i64* %58, i64* %60), !dbg !814
  br label %return, !dbg !815

if.end20:                                         ; preds = %if.end12
  %61 = ptrtoint i64** %high1.addr to i64
  call void @__dp_read(i32 164175, i64 %61, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.24, i32 0, i32 0))
  %62 = load i64*, i64** %high1.addr, align 8, !dbg !816
  %63 = ptrtoint i64** %low1.addr to i64
  call void @__dp_read(i32 164175, i64 %63, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  %64 = load i64*, i64** %low1.addr, align 8, !dbg !817
  %sub.ptr.lhs.cast21 = ptrtoint i64* %62 to i64, !dbg !818
  %sub.ptr.rhs.cast22 = ptrtoint i64* %64 to i64, !dbg !818
  %sub.ptr.sub23 = sub i64 %sub.ptr.lhs.cast21, %sub.ptr.rhs.cast22, !dbg !818
  %sub.ptr.div24 = sdiv exact i64 %sub.ptr.sub23, 8, !dbg !818
  %add = add nsw i64 %sub.ptr.div24, 1, !dbg !819
  %div = sdiv i64 %add, 2, !dbg !820
  %65 = ptrtoint i64** %low1.addr to i64
  call void @__dp_read(i32 164175, i64 %65, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  %66 = load i64*, i64** %low1.addr, align 8, !dbg !821
  %add.ptr = getelementptr inbounds i64, i64* %66, i64 %div, !dbg !822
  %67 = ptrtoint i64** %split1 to i64
  call void @__dp_write(i32 164175, i64 %67, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.35, i32 0, i32 0))
  store i64* %add.ptr, i64** %split1, align 8, !dbg !823
  %68 = ptrtoint i64** %split1 to i64
  call void @__dp_read(i32 164176, i64 %68, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.35, i32 0, i32 0))
  %69 = load i64*, i64** %split1, align 8, !dbg !824
  %70 = ptrtoint i64* %69 to i64
  call void @__dp_read(i32 164176, i64 %70, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.35, i32 0, i32 0))
  %71 = load i64, i64* %69, align 8, !dbg !825
  %72 = ptrtoint i64** %low2.addr to i64
  call void @__dp_read(i32 164176, i64 %72, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0))
  %73 = load i64*, i64** %low2.addr, align 8, !dbg !826
  %74 = ptrtoint i64** %high2.addr to i64
  call void @__dp_read(i32 164176, i64 %74, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.26, i32 0, i32 0))
  %75 = load i64*, i64** %high2.addr, align 8, !dbg !827
  call void @__dp_call(i32 164176), !dbg !828
  %call = call i64* @binsplit(i64 %71, i64* %73, i64* %75), !dbg !828
  %76 = ptrtoint i64** %split2 to i64
  call void @__dp_write(i32 164176, i64 %76, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.36, i32 0, i32 0))
  store i64* %call, i64** %split2, align 8, !dbg !829
  %77 = ptrtoint i64** %split1 to i64
  call void @__dp_read(i32 164177, i64 %77, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.35, i32 0, i32 0))
  %78 = load i64*, i64** %split1, align 8, !dbg !830
  %79 = ptrtoint i64** %low1.addr to i64
  call void @__dp_read(i32 164177, i64 %79, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  %80 = load i64*, i64** %low1.addr, align 8, !dbg !831
  %sub.ptr.lhs.cast25 = ptrtoint i64* %78 to i64, !dbg !832
  %sub.ptr.rhs.cast26 = ptrtoint i64* %80 to i64, !dbg !832
  %sub.ptr.sub27 = sub i64 %sub.ptr.lhs.cast25, %sub.ptr.rhs.cast26, !dbg !832
  %sub.ptr.div28 = sdiv exact i64 %sub.ptr.sub27, 8, !dbg !832
  %81 = ptrtoint i64** %split2 to i64
  call void @__dp_read(i32 164177, i64 %81, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.36, i32 0, i32 0))
  %82 = load i64*, i64** %split2, align 8, !dbg !833
  %add.ptr29 = getelementptr inbounds i64, i64* %82, i64 %sub.ptr.div28, !dbg !834
  %83 = ptrtoint i64** %low2.addr to i64
  call void @__dp_read(i32 164177, i64 %83, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0))
  %84 = load i64*, i64** %low2.addr, align 8, !dbg !835
  %sub.ptr.lhs.cast30 = ptrtoint i64* %add.ptr29 to i64, !dbg !836
  %sub.ptr.rhs.cast31 = ptrtoint i64* %84 to i64, !dbg !836
  %sub.ptr.sub32 = sub i64 %sub.ptr.lhs.cast30, %sub.ptr.rhs.cast31, !dbg !836
  %sub.ptr.div33 = sdiv exact i64 %sub.ptr.sub32, 8, !dbg !836
  %85 = ptrtoint i64* %lowsize to i64
  call void @__dp_write(i32 164177, i64 %85, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.37, i32 0, i32 0))
  store i64 %sub.ptr.div33, i64* %lowsize, align 8, !dbg !837
  %86 = ptrtoint i64** %split1 to i64
  call void @__dp_read(i32 164183, i64 %86, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.35, i32 0, i32 0))
  %87 = load i64*, i64** %split1, align 8, !dbg !838
  %88 = ptrtoint i64* %87 to i64
  call void @__dp_read(i32 164183, i64 %88, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.35, i32 0, i32 0))
  %89 = load i64, i64* %87, align 8, !dbg !839
  %90 = ptrtoint i64** %lowdest.addr to i64
  call void @__dp_read(i32 164183, i64 %90, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.27, i32 0, i32 0))
  %91 = load i64*, i64** %lowdest.addr, align 8, !dbg !840
  %92 = ptrtoint i64* %lowsize to i64
  call void @__dp_read(i32 164183, i64 %92, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.37, i32 0, i32 0))
  %93 = load i64, i64* %lowsize, align 8, !dbg !841
  %add.ptr34 = getelementptr inbounds i64, i64* %91, i64 %93, !dbg !842
  %add.ptr35 = getelementptr inbounds i64, i64* %add.ptr34, i64 1, !dbg !843
  %94 = ptrtoint i64* %add.ptr35 to i64
  call void @__dp_write(i32 164183, i64 %94, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.27, i32 0, i32 0))
  store i64 %89, i64* %add.ptr35, align 8, !dbg !844
  %95 = ptrtoint i64** %low1.addr to i64
  call void @__dp_read(i32 164184, i64 %95, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0))
  %96 = load i64*, i64** %low1.addr, align 8, !dbg !845
  %97 = ptrtoint i64** %split1 to i64
  call void @__dp_read(i32 164184, i64 %97, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.35, i32 0, i32 0))
  %98 = load i64*, i64** %split1, align 8, !dbg !846
  %add.ptr36 = getelementptr inbounds i64, i64* %98, i64 -1, !dbg !847
  %99 = ptrtoint i64** %low2.addr to i64
  call void @__dp_read(i32 164184, i64 %99, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0))
  %100 = load i64*, i64** %low2.addr, align 8, !dbg !848
  %101 = ptrtoint i64** %split2 to i64
  call void @__dp_read(i32 164184, i64 %101, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.36, i32 0, i32 0))
  %102 = load i64*, i64** %split2, align 8, !dbg !849
  %103 = ptrtoint i64** %lowdest.addr to i64
  call void @__dp_read(i32 164184, i64 %103, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.27, i32 0, i32 0))
  %104 = load i64*, i64** %lowdest.addr, align 8, !dbg !850
  call void @__dp_call(i32 164184), !dbg !851
  call void @cilkmerge(i64* %96, i64* %add.ptr36, i64* %100, i64* %102, i64* %104), !dbg !851
  %105 = ptrtoint i64** %split1 to i64
  call void @__dp_read(i32 164185, i64 %105, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.35, i32 0, i32 0))
  %106 = load i64*, i64** %split1, align 8, !dbg !852
  %add.ptr37 = getelementptr inbounds i64, i64* %106, i64 1, !dbg !853
  %107 = ptrtoint i64** %high1.addr to i64
  call void @__dp_read(i32 164185, i64 %107, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.24, i32 0, i32 0))
  %108 = load i64*, i64** %high1.addr, align 8, !dbg !854
  %109 = ptrtoint i64** %split2 to i64
  call void @__dp_read(i32 164185, i64 %109, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.36, i32 0, i32 0))
  %110 = load i64*, i64** %split2, align 8, !dbg !855
  %add.ptr38 = getelementptr inbounds i64, i64* %110, i64 1, !dbg !856
  %111 = ptrtoint i64** %high2.addr to i64
  call void @__dp_read(i32 164185, i64 %111, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.26, i32 0, i32 0))
  %112 = load i64*, i64** %high2.addr, align 8, !dbg !857
  %113 = ptrtoint i64** %lowdest.addr to i64
  call void @__dp_read(i32 164185, i64 %113, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.27, i32 0, i32 0))
  %114 = load i64*, i64** %lowdest.addr, align 8, !dbg !858
  %115 = ptrtoint i64* %lowsize to i64
  call void @__dp_read(i32 164185, i64 %115, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.37, i32 0, i32 0))
  %116 = load i64, i64* %lowsize, align 8, !dbg !859
  %add.ptr39 = getelementptr inbounds i64, i64* %114, i64 %116, !dbg !860
  %add.ptr40 = getelementptr inbounds i64, i64* %add.ptr39, i64 2, !dbg !861
  call void @__dp_call(i32 164185), !dbg !862
  call void @cilkmerge(i64* %add.ptr37, i64* %108, i64* %add.ptr38, i64* %112, i64* %add.ptr40), !dbg !862
  br label %return, !dbg !863

return:                                           ; preds = %if.end20, %if.then19, %if.then7
  call void @__dp_func_exit(i32 164188, i32 0), !dbg !864
  ret void, !dbg !864
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @cilksort(i64* %low, i64* %tmp, i64 %size) #0 !dbg !865 {
entry:
  call void @__dp_func_entry(i32 164190, i32 0)
  %low.addr = alloca i64*, align 8
  %tmp.addr = alloca i64*, align 8
  %size.addr = alloca i64, align 8
  %quarter = alloca i64, align 8
  %A = alloca i64*, align 8
  %B = alloca i64*, align 8
  %C = alloca i64*, align 8
  %D = alloca i64*, align 8
  %tmpA = alloca i64*, align 8
  %tmpB = alloca i64*, align 8
  %tmpC = alloca i64*, align 8
  %tmpD = alloca i64*, align 8
  %0 = ptrtoint i64** %low.addr to i64
  call void @__dp_write(i32 164190, i64 %0, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  store i64* %low, i64** %low.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %low.addr, metadata !868, metadata !DIExpression()), !dbg !869
  %1 = ptrtoint i64** %tmp.addr to i64
  call void @__dp_write(i32 164190, i64 %1, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.38, i32 0, i32 0))
  store i64* %tmp, i64** %tmp.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %tmp.addr, metadata !870, metadata !DIExpression()), !dbg !871
  %2 = ptrtoint i64* %size.addr to i64
  call void @__dp_write(i32 164190, i64 %2, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.39, i32 0, i32 0))
  store i64 %size, i64* %size.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %size.addr, metadata !872, metadata !DIExpression()), !dbg !873
  call void @llvm.dbg.declare(metadata i64* %quarter, metadata !874, metadata !DIExpression()), !dbg !875
  %3 = ptrtoint i64* %size.addr to i64
  call void @__dp_read(i32 164199, i64 %3, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.39, i32 0, i32 0))
  %4 = load i64, i64* %size.addr, align 8, !dbg !876
  %div = sdiv i64 %4, 4, !dbg !877
  %5 = ptrtoint i64* %quarter to i64
  call void @__dp_write(i32 164199, i64 %5, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.40, i32 0, i32 0))
  store i64 %div, i64* %quarter, align 8, !dbg !875
  call void @llvm.dbg.declare(metadata i64** %A, metadata !878, metadata !DIExpression()), !dbg !879
  call void @llvm.dbg.declare(metadata i64** %B, metadata !880, metadata !DIExpression()), !dbg !881
  call void @llvm.dbg.declare(metadata i64** %C, metadata !882, metadata !DIExpression()), !dbg !883
  call void @llvm.dbg.declare(metadata i64** %D, metadata !884, metadata !DIExpression()), !dbg !885
  call void @llvm.dbg.declare(metadata i64** %tmpA, metadata !886, metadata !DIExpression()), !dbg !887
  call void @llvm.dbg.declare(metadata i64** %tmpB, metadata !888, metadata !DIExpression()), !dbg !889
  call void @llvm.dbg.declare(metadata i64** %tmpC, metadata !890, metadata !DIExpression()), !dbg !891
  call void @llvm.dbg.declare(metadata i64** %tmpD, metadata !892, metadata !DIExpression()), !dbg !893
  %6 = ptrtoint i64* %size.addr to i64
  call void @__dp_read(i32 164202, i64 %6, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.39, i32 0, i32 0))
  %7 = load i64, i64* %size.addr, align 8, !dbg !894
  %8 = ptrtoint i32* @bots_app_cutoff_value_1 to i64
  call void @__dp_read(i32 164202, i64 %8, i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.41, i32 0, i32 0))
  %9 = load i32, i32* @bots_app_cutoff_value_1, align 4, !dbg !896
  %conv = sext i32 %9 to i64, !dbg !896
  %cmp = icmp slt i64 %7, %conv, !dbg !897
  br i1 %cmp, label %if.then, label %if.end, !dbg !898

if.then:                                          ; preds = %entry
  %10 = ptrtoint i64** %low.addr to i64
  call void @__dp_read(i32 164204, i64 %10, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  %11 = load i64*, i64** %low.addr, align 8, !dbg !899
  %12 = ptrtoint i64** %low.addr to i64
  call void @__dp_read(i32 164204, i64 %12, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  %13 = load i64*, i64** %low.addr, align 8, !dbg !901
  %14 = ptrtoint i64* %size.addr to i64
  call void @__dp_read(i32 164204, i64 %14, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.39, i32 0, i32 0))
  %15 = load i64, i64* %size.addr, align 8, !dbg !902
  %add.ptr = getelementptr inbounds i64, i64* %13, i64 %15, !dbg !903
  %add.ptr2 = getelementptr inbounds i64, i64* %add.ptr, i64 -1, !dbg !904
  call void @__dp_call(i32 164204), !dbg !905
  call void @seqquick(i64* %11, i64* %add.ptr2), !dbg !905
  br label %return, !dbg !906

if.end:                                           ; preds = %entry
  %16 = ptrtoint i64** %low.addr to i64
  call void @__dp_read(i32 164207, i64 %16, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  %17 = load i64*, i64** %low.addr, align 8, !dbg !907
  %18 = ptrtoint i64** %A to i64
  call void @__dp_write(i32 164207, i64 %18, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.42, i32 0, i32 0))
  store i64* %17, i64** %A, align 8, !dbg !908
  %19 = ptrtoint i64** %tmp.addr to i64
  call void @__dp_read(i32 164208, i64 %19, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.38, i32 0, i32 0))
  %20 = load i64*, i64** %tmp.addr, align 8, !dbg !909
  %21 = ptrtoint i64** %tmpA to i64
  call void @__dp_write(i32 164208, i64 %21, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.43, i32 0, i32 0))
  store i64* %20, i64** %tmpA, align 8, !dbg !910
  %22 = ptrtoint i64** %A to i64
  call void @__dp_read(i32 164209, i64 %22, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.42, i32 0, i32 0))
  %23 = load i64*, i64** %A, align 8, !dbg !911
  %24 = ptrtoint i64* %quarter to i64
  call void @__dp_read(i32 164209, i64 %24, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.40, i32 0, i32 0))
  %25 = load i64, i64* %quarter, align 8, !dbg !912
  %add.ptr3 = getelementptr inbounds i64, i64* %23, i64 %25, !dbg !913
  %26 = ptrtoint i64** %B to i64
  call void @__dp_write(i32 164209, i64 %26, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.44, i32 0, i32 0))
  store i64* %add.ptr3, i64** %B, align 8, !dbg !914
  %27 = ptrtoint i64** %tmpA to i64
  call void @__dp_read(i32 164210, i64 %27, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.43, i32 0, i32 0))
  %28 = load i64*, i64** %tmpA, align 8, !dbg !915
  %29 = ptrtoint i64* %quarter to i64
  call void @__dp_read(i32 164210, i64 %29, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.40, i32 0, i32 0))
  %30 = load i64, i64* %quarter, align 8, !dbg !916
  %add.ptr4 = getelementptr inbounds i64, i64* %28, i64 %30, !dbg !917
  %31 = ptrtoint i64** %tmpB to i64
  call void @__dp_write(i32 164210, i64 %31, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.45, i32 0, i32 0))
  store i64* %add.ptr4, i64** %tmpB, align 8, !dbg !918
  %32 = ptrtoint i64** %B to i64
  call void @__dp_read(i32 164211, i64 %32, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.44, i32 0, i32 0))
  %33 = load i64*, i64** %B, align 8, !dbg !919
  %34 = ptrtoint i64* %quarter to i64
  call void @__dp_read(i32 164211, i64 %34, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.40, i32 0, i32 0))
  %35 = load i64, i64* %quarter, align 8, !dbg !920
  %add.ptr5 = getelementptr inbounds i64, i64* %33, i64 %35, !dbg !921
  %36 = ptrtoint i64** %C to i64
  call void @__dp_write(i32 164211, i64 %36, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.46, i32 0, i32 0))
  store i64* %add.ptr5, i64** %C, align 8, !dbg !922
  %37 = ptrtoint i64** %tmpB to i64
  call void @__dp_read(i32 164212, i64 %37, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.45, i32 0, i32 0))
  %38 = load i64*, i64** %tmpB, align 8, !dbg !923
  %39 = ptrtoint i64* %quarter to i64
  call void @__dp_read(i32 164212, i64 %39, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.40, i32 0, i32 0))
  %40 = load i64, i64* %quarter, align 8, !dbg !924
  %add.ptr6 = getelementptr inbounds i64, i64* %38, i64 %40, !dbg !925
  %41 = ptrtoint i64** %tmpC to i64
  call void @__dp_write(i32 164212, i64 %41, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.47, i32 0, i32 0))
  store i64* %add.ptr6, i64** %tmpC, align 8, !dbg !926
  %42 = ptrtoint i64** %C to i64
  call void @__dp_read(i32 164213, i64 %42, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.46, i32 0, i32 0))
  %43 = load i64*, i64** %C, align 8, !dbg !927
  %44 = ptrtoint i64* %quarter to i64
  call void @__dp_read(i32 164213, i64 %44, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.40, i32 0, i32 0))
  %45 = load i64, i64* %quarter, align 8, !dbg !928
  %add.ptr7 = getelementptr inbounds i64, i64* %43, i64 %45, !dbg !929
  %46 = ptrtoint i64** %D to i64
  call void @__dp_write(i32 164213, i64 %46, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.48, i32 0, i32 0))
  store i64* %add.ptr7, i64** %D, align 8, !dbg !930
  %47 = ptrtoint i64** %tmpC to i64
  call void @__dp_read(i32 164214, i64 %47, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.47, i32 0, i32 0))
  %48 = load i64*, i64** %tmpC, align 8, !dbg !931
  %49 = ptrtoint i64* %quarter to i64
  call void @__dp_read(i32 164214, i64 %49, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.40, i32 0, i32 0))
  %50 = load i64, i64* %quarter, align 8, !dbg !932
  %add.ptr8 = getelementptr inbounds i64, i64* %48, i64 %50, !dbg !933
  %51 = ptrtoint i64** %tmpD to i64
  call void @__dp_write(i32 164214, i64 %51, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.49, i32 0, i32 0))
  store i64* %add.ptr8, i64** %tmpD, align 8, !dbg !934
  %52 = ptrtoint i64** %A to i64
  call void @__dp_read(i32 164216, i64 %52, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.42, i32 0, i32 0))
  %53 = load i64*, i64** %A, align 8, !dbg !935
  %54 = ptrtoint i64** %tmpA to i64
  call void @__dp_read(i32 164216, i64 %54, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.43, i32 0, i32 0))
  %55 = load i64*, i64** %tmpA, align 8, !dbg !936
  %56 = ptrtoint i64* %quarter to i64
  call void @__dp_read(i32 164216, i64 %56, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.40, i32 0, i32 0))
  %57 = load i64, i64* %quarter, align 8, !dbg !937
  call void @__dp_call(i32 164216), !dbg !938
  call void @cilksort(i64* %53, i64* %55, i64 %57), !dbg !938
  %58 = ptrtoint i64** %B to i64
  call void @__dp_read(i32 164217, i64 %58, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.44, i32 0, i32 0))
  %59 = load i64*, i64** %B, align 8, !dbg !939
  %60 = ptrtoint i64** %tmpB to i64
  call void @__dp_read(i32 164217, i64 %60, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.45, i32 0, i32 0))
  %61 = load i64*, i64** %tmpB, align 8, !dbg !940
  %62 = ptrtoint i64* %quarter to i64
  call void @__dp_read(i32 164217, i64 %62, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.40, i32 0, i32 0))
  %63 = load i64, i64* %quarter, align 8, !dbg !941
  call void @__dp_call(i32 164217), !dbg !942
  call void @cilksort(i64* %59, i64* %61, i64 %63), !dbg !942
  %64 = ptrtoint i64** %C to i64
  call void @__dp_read(i32 164218, i64 %64, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.46, i32 0, i32 0))
  %65 = load i64*, i64** %C, align 8, !dbg !943
  %66 = ptrtoint i64** %tmpC to i64
  call void @__dp_read(i32 164218, i64 %66, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.47, i32 0, i32 0))
  %67 = load i64*, i64** %tmpC, align 8, !dbg !944
  %68 = ptrtoint i64* %quarter to i64
  call void @__dp_read(i32 164218, i64 %68, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.40, i32 0, i32 0))
  %69 = load i64, i64* %quarter, align 8, !dbg !945
  call void @__dp_call(i32 164218), !dbg !946
  call void @cilksort(i64* %65, i64* %67, i64 %69), !dbg !946
  %70 = ptrtoint i64** %D to i64
  call void @__dp_read(i32 164219, i64 %70, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.48, i32 0, i32 0))
  %71 = load i64*, i64** %D, align 8, !dbg !947
  %72 = ptrtoint i64** %tmpD to i64
  call void @__dp_read(i32 164219, i64 %72, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.49, i32 0, i32 0))
  %73 = load i64*, i64** %tmpD, align 8, !dbg !948
  %74 = ptrtoint i64* %size.addr to i64
  call void @__dp_read(i32 164219, i64 %74, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.39, i32 0, i32 0))
  %75 = load i64, i64* %size.addr, align 8, !dbg !949
  %76 = ptrtoint i64* %quarter to i64
  call void @__dp_read(i32 164219, i64 %76, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.40, i32 0, i32 0))
  %77 = load i64, i64* %quarter, align 8, !dbg !950
  %mul = mul nsw i64 3, %77, !dbg !951
  %sub = sub nsw i64 %75, %mul, !dbg !952
  call void @__dp_call(i32 164219), !dbg !953
  call void @cilksort(i64* %71, i64* %73, i64 %sub), !dbg !953
  %78 = ptrtoint i64** %A to i64
  call void @__dp_read(i32 164221, i64 %78, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.42, i32 0, i32 0))
  %79 = load i64*, i64** %A, align 8, !dbg !954
  %80 = ptrtoint i64** %A to i64
  call void @__dp_read(i32 164221, i64 %80, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.42, i32 0, i32 0))
  %81 = load i64*, i64** %A, align 8, !dbg !955
  %82 = ptrtoint i64* %quarter to i64
  call void @__dp_read(i32 164221, i64 %82, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.40, i32 0, i32 0))
  %83 = load i64, i64* %quarter, align 8, !dbg !956
  %add.ptr9 = getelementptr inbounds i64, i64* %81, i64 %83, !dbg !957
  %add.ptr10 = getelementptr inbounds i64, i64* %add.ptr9, i64 -1, !dbg !958
  %84 = ptrtoint i64** %B to i64
  call void @__dp_read(i32 164221, i64 %84, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.44, i32 0, i32 0))
  %85 = load i64*, i64** %B, align 8, !dbg !959
  %86 = ptrtoint i64** %B to i64
  call void @__dp_read(i32 164221, i64 %86, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.44, i32 0, i32 0))
  %87 = load i64*, i64** %B, align 8, !dbg !960
  %88 = ptrtoint i64* %quarter to i64
  call void @__dp_read(i32 164221, i64 %88, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.40, i32 0, i32 0))
  %89 = load i64, i64* %quarter, align 8, !dbg !961
  %add.ptr11 = getelementptr inbounds i64, i64* %87, i64 %89, !dbg !962
  %add.ptr12 = getelementptr inbounds i64, i64* %add.ptr11, i64 -1, !dbg !963
  %90 = ptrtoint i64** %tmpA to i64
  call void @__dp_read(i32 164221, i64 %90, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.43, i32 0, i32 0))
  %91 = load i64*, i64** %tmpA, align 8, !dbg !964
  call void @__dp_call(i32 164221), !dbg !965
  call void @cilkmerge(i64* %79, i64* %add.ptr10, i64* %85, i64* %add.ptr12, i64* %91), !dbg !965
  %92 = ptrtoint i64** %C to i64
  call void @__dp_read(i32 164222, i64 %92, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.46, i32 0, i32 0))
  %93 = load i64*, i64** %C, align 8, !dbg !966
  %94 = ptrtoint i64** %C to i64
  call void @__dp_read(i32 164222, i64 %94, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.46, i32 0, i32 0))
  %95 = load i64*, i64** %C, align 8, !dbg !967
  %96 = ptrtoint i64* %quarter to i64
  call void @__dp_read(i32 164222, i64 %96, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.40, i32 0, i32 0))
  %97 = load i64, i64* %quarter, align 8, !dbg !968
  %add.ptr13 = getelementptr inbounds i64, i64* %95, i64 %97, !dbg !969
  %add.ptr14 = getelementptr inbounds i64, i64* %add.ptr13, i64 -1, !dbg !970
  %98 = ptrtoint i64** %D to i64
  call void @__dp_read(i32 164222, i64 %98, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.48, i32 0, i32 0))
  %99 = load i64*, i64** %D, align 8, !dbg !971
  %100 = ptrtoint i64** %low.addr to i64
  call void @__dp_read(i32 164222, i64 %100, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  %101 = load i64*, i64** %low.addr, align 8, !dbg !972
  %102 = ptrtoint i64* %size.addr to i64
  call void @__dp_read(i32 164222, i64 %102, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.39, i32 0, i32 0))
  %103 = load i64, i64* %size.addr, align 8, !dbg !973
  %add.ptr15 = getelementptr inbounds i64, i64* %101, i64 %103, !dbg !974
  %add.ptr16 = getelementptr inbounds i64, i64* %add.ptr15, i64 -1, !dbg !975
  %104 = ptrtoint i64** %tmpC to i64
  call void @__dp_read(i32 164222, i64 %104, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.47, i32 0, i32 0))
  %105 = load i64*, i64** %tmpC, align 8, !dbg !976
  call void @__dp_call(i32 164222), !dbg !977
  call void @cilkmerge(i64* %93, i64* %add.ptr14, i64* %99, i64* %add.ptr16, i64* %105), !dbg !977
  %106 = ptrtoint i64** %tmpA to i64
  call void @__dp_read(i32 164224, i64 %106, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.43, i32 0, i32 0))
  %107 = load i64*, i64** %tmpA, align 8, !dbg !978
  %108 = ptrtoint i64** %tmpC to i64
  call void @__dp_read(i32 164224, i64 %108, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.47, i32 0, i32 0))
  %109 = load i64*, i64** %tmpC, align 8, !dbg !979
  %add.ptr17 = getelementptr inbounds i64, i64* %109, i64 -1, !dbg !980
  %110 = ptrtoint i64** %tmpC to i64
  call void @__dp_read(i32 164224, i64 %110, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.47, i32 0, i32 0))
  %111 = load i64*, i64** %tmpC, align 8, !dbg !981
  %112 = ptrtoint i64** %tmpA to i64
  call void @__dp_read(i32 164224, i64 %112, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.43, i32 0, i32 0))
  %113 = load i64*, i64** %tmpA, align 8, !dbg !982
  %114 = ptrtoint i64* %size.addr to i64
  call void @__dp_read(i32 164224, i64 %114, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.39, i32 0, i32 0))
  %115 = load i64, i64* %size.addr, align 8, !dbg !983
  %add.ptr18 = getelementptr inbounds i64, i64* %113, i64 %115, !dbg !984
  %add.ptr19 = getelementptr inbounds i64, i64* %add.ptr18, i64 -1, !dbg !985
  %116 = ptrtoint i64** %A to i64
  call void @__dp_read(i32 164224, i64 %116, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.42, i32 0, i32 0))
  %117 = load i64*, i64** %A, align 8, !dbg !986
  call void @__dp_call(i32 164224), !dbg !987
  call void @cilkmerge(i64* %107, i64* %add.ptr17, i64* %111, i64* %add.ptr19, i64* %117), !dbg !987
  br label %return, !dbg !988

return:                                           ; preds = %if.end, %if.then
  call void @__dp_func_exit(i32 164225, i32 0), !dbg !988
  ret void, !dbg !988
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @scramble_array() #0 !dbg !989 {
entry:
  call void @__dp_func_entry(i32 164229, i32 0)
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %tmp = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %i, metadata !992, metadata !DIExpression()), !dbg !993
  call void @llvm.dbg.declare(metadata i64* %j, metadata !994, metadata !DIExpression()), !dbg !995
  %0 = ptrtoint i64* %i to i64
  call void @__dp_write(i32 164234, i64 %0, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.50, i32 0, i32 0))
  store i64 0, i64* %i, align 8, !dbg !996
  br label %for.cond, !dbg !998

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 164234, i32 9)
  %1 = ptrtoint i64* %i to i64
  call void @__dp_read(i32 164234, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.50, i32 0, i32 0))
  %2 = load i64, i64* %i, align 8, !dbg !999
  %3 = ptrtoint i32* @bots_arg_size to i64
  call void @__dp_read(i32 164234, i64 %3, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.51, i32 0, i32 0))
  %4 = load i32, i32* @bots_arg_size, align 4, !dbg !1001
  %conv = sext i32 %4 to i64, !dbg !1001
  %cmp = icmp ult i64 %2, %conv, !dbg !1002
  br i1 %cmp, label %for.body, label %for.end, !dbg !1003

for.body:                                         ; preds = %for.cond
  call void @__dp_call(i32 164235), !dbg !1004
  %call = call i64 @my_rand(), !dbg !1004
  %5 = ptrtoint i64* %j to i64
  call void @__dp_write(i32 164235, i64 %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.52, i32 0, i32 0))
  store i64 %call, i64* %j, align 8, !dbg !1006
  %6 = ptrtoint i64* %j to i64
  call void @__dp_read(i32 164236, i64 %6, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.52, i32 0, i32 0))
  %7 = load i64, i64* %j, align 8, !dbg !1007
  %8 = ptrtoint i32* @bots_arg_size to i64
  call void @__dp_read(i32 164236, i64 %8, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.51, i32 0, i32 0))
  %9 = load i32, i32* @bots_arg_size, align 4, !dbg !1008
  %conv2 = sext i32 %9 to i64, !dbg !1008
  %rem = urem i64 %7, %conv2, !dbg !1009
  %10 = ptrtoint i64* %j to i64
  call void @__dp_write(i32 164236, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.52, i32 0, i32 0))
  store i64 %rem, i64* %j, align 8, !dbg !1010
  call void @llvm.dbg.declare(metadata i64* %tmp, metadata !1011, metadata !DIExpression()), !dbg !1013
  %11 = ptrtoint i64** @array to i64
  call void @__dp_read(i32 164237, i64 %11, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.53, i32 0, i32 0))
  %12 = load i64*, i64** @array, align 8, !dbg !1013
  %13 = ptrtoint i64* %i to i64
  call void @__dp_read(i32 164237, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.50, i32 0, i32 0))
  %14 = load i64, i64* %i, align 8, !dbg !1013
  %arrayidx = getelementptr inbounds i64, i64* %12, i64 %14, !dbg !1013
  %15 = ptrtoint i64* %arrayidx to i64
  call void @__dp_read(i32 164237, i64 %15, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.53, i32 0, i32 0))
  %16 = load i64, i64* %arrayidx, align 8, !dbg !1013
  %17 = ptrtoint i64* %tmp to i64
  call void @__dp_write(i32 164237, i64 %17, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.32, i32 0, i32 0))
  store i64 %16, i64* %tmp, align 8, !dbg !1013
  %18 = ptrtoint i64** @array to i64
  call void @__dp_read(i32 164237, i64 %18, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.53, i32 0, i32 0))
  %19 = load i64*, i64** @array, align 8, !dbg !1013
  %20 = ptrtoint i64* %j to i64
  call void @__dp_read(i32 164237, i64 %20, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.52, i32 0, i32 0))
  %21 = load i64, i64* %j, align 8, !dbg !1013
  %arrayidx3 = getelementptr inbounds i64, i64* %19, i64 %21, !dbg !1013
  %22 = ptrtoint i64* %arrayidx3 to i64
  call void @__dp_read(i32 164237, i64 %22, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.53, i32 0, i32 0))
  %23 = load i64, i64* %arrayidx3, align 8, !dbg !1013
  %24 = ptrtoint i64** @array to i64
  call void @__dp_read(i32 164237, i64 %24, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.53, i32 0, i32 0))
  %25 = load i64*, i64** @array, align 8, !dbg !1013
  %26 = ptrtoint i64* %i to i64
  call void @__dp_read(i32 164237, i64 %26, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.50, i32 0, i32 0))
  %27 = load i64, i64* %i, align 8, !dbg !1013
  %arrayidx4 = getelementptr inbounds i64, i64* %25, i64 %27, !dbg !1013
  %28 = ptrtoint i64* %arrayidx4 to i64
  call void @__dp_write(i32 164237, i64 %28, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.53, i32 0, i32 0))
  store i64 %23, i64* %arrayidx4, align 8, !dbg !1013
  %29 = ptrtoint i64* %tmp to i64
  call void @__dp_read(i32 164237, i64 %29, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.32, i32 0, i32 0))
  %30 = load i64, i64* %tmp, align 8, !dbg !1013
  %31 = ptrtoint i64** @array to i64
  call void @__dp_read(i32 164237, i64 %31, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.53, i32 0, i32 0))
  %32 = load i64*, i64** @array, align 8, !dbg !1013
  %33 = ptrtoint i64* %j to i64
  call void @__dp_read(i32 164237, i64 %33, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.52, i32 0, i32 0))
  %34 = load i64, i64* %j, align 8, !dbg !1013
  %arrayidx5 = getelementptr inbounds i64, i64* %32, i64 %34, !dbg !1013
  %35 = ptrtoint i64* %arrayidx5 to i64
  call void @__dp_write(i32 164237, i64 %35, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.53, i32 0, i32 0))
  store i64 %30, i64* %arrayidx5, align 8, !dbg !1013
  br label %for.inc, !dbg !1014

for.inc:                                          ; preds = %for.body
  %36 = ptrtoint i64* %i to i64
  call void @__dp_read(i32 164234, i64 %36, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.50, i32 0, i32 0))
  %37 = load i64, i64* %i, align 8, !dbg !1015
  %inc = add i64 %37, 1, !dbg !1015
  %38 = ptrtoint i64* %i to i64
  call void @__dp_write(i32 164234, i64 %38, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.50, i32 0, i32 0))
  store i64 %inc, i64* %i, align 8, !dbg !1015
  br label %for.cond, !dbg !1016, !llvm.loop !1017

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 164239, i32 9)
  call void @__dp_func_exit(i32 164239, i32 0), !dbg !1019
  ret void, !dbg !1019
}

; Function Attrs: noinline nounwind optnone uwtable
define internal i64 @my_rand() #0 !dbg !1020 {
entry:
  call void @__dp_func_entry(i32 163914, i32 0), !dbg !1023
  %0 = ptrtoint i64* @rand_nxt to i64
  call void @__dp_read(i32 163914, i64 %0, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.54, i32 0, i32 0))
  %1 = load i64, i64* @rand_nxt, align 8, !dbg !1023
  %mul = mul i64 %1, 1103515245, !dbg !1024
  %add = add i64 %mul, 12345, !dbg !1025
  %2 = ptrtoint i64* @rand_nxt to i64
  call void @__dp_write(i32 163914, i64 %2, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.54, i32 0, i32 0))
  store i64 %add, i64* @rand_nxt, align 8, !dbg !1026
  %3 = ptrtoint i64* @rand_nxt to i64
  call void @__dp_read(i32 163915, i64 %3, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.54, i32 0, i32 0))
  %4 = load i64, i64* @rand_nxt, align 8, !dbg !1027
  call void @__dp_func_exit(i32 163915, i32 0), !dbg !1028
  ret i64 %4, !dbg !1028
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @fill_array() #0 !dbg !1029 {
entry:
  call void @__dp_func_entry(i32 164241, i32 0)
  %i = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %i, metadata !1030, metadata !DIExpression()), !dbg !1031
  call void @__dp_call(i32 164245), !dbg !1032
  call void @my_srand(i64 1), !dbg !1032
  %0 = ptrtoint i64* %i to i64
  call void @__dp_write(i32 164248, i64 %0, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.50, i32 0, i32 0))
  store i64 0, i64* %i, align 8, !dbg !1033
  br label %for.cond, !dbg !1035

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 164248, i32 10)
  %1 = ptrtoint i64* %i to i64
  call void @__dp_read(i32 164248, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.50, i32 0, i32 0))
  %2 = load i64, i64* %i, align 8, !dbg !1036
  %3 = ptrtoint i32* @bots_arg_size to i64
  call void @__dp_read(i32 164248, i64 %3, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.51, i32 0, i32 0))
  %4 = load i32, i32* @bots_arg_size, align 4, !dbg !1038
  %conv = sext i32 %4 to i64, !dbg !1038
  %cmp = icmp ult i64 %2, %conv, !dbg !1039
  br i1 %cmp, label %for.body, label %for.end, !dbg !1040

for.body:                                         ; preds = %for.cond
  %5 = ptrtoint i64* %i to i64
  call void @__dp_read(i32 164249, i64 %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.50, i32 0, i32 0))
  %6 = load i64, i64* %i, align 8, !dbg !1041
  %7 = ptrtoint i64** @array to i64
  call void @__dp_read(i32 164249, i64 %7, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.53, i32 0, i32 0))
  %8 = load i64*, i64** @array, align 8, !dbg !1043
  %9 = ptrtoint i64* %i to i64
  call void @__dp_read(i32 164249, i64 %9, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.50, i32 0, i32 0))
  %10 = load i64, i64* %i, align 8, !dbg !1044
  %arrayidx = getelementptr inbounds i64, i64* %8, i64 %10, !dbg !1043
  %11 = ptrtoint i64* %arrayidx to i64
  call void @__dp_write(i32 164249, i64 %11, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.53, i32 0, i32 0))
  store i64 %6, i64* %arrayidx, align 8, !dbg !1045
  br label %for.inc, !dbg !1046

for.inc:                                          ; preds = %for.body
  %12 = ptrtoint i64* %i to i64
  call void @__dp_read(i32 164248, i64 %12, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.50, i32 0, i32 0))
  %13 = load i64, i64* %i, align 8, !dbg !1047
  %inc = add i64 %13, 1, !dbg !1047
  %14 = ptrtoint i64* %i to i64
  call void @__dp_write(i32 164248, i64 %14, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.50, i32 0, i32 0))
  store i64 %inc, i64* %i, align 8, !dbg !1047
  br label %for.cond, !dbg !1048, !llvm.loop !1049

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 164251, i32 10)
  call void @__dp_func_exit(i32 164251, i32 0), !dbg !1051
  ret void, !dbg !1051
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @my_srand(i64 %seed) #0 !dbg !1052 {
entry:
  call void @__dp_func_entry(i32 163918, i32 0)
  %seed.addr = alloca i64, align 8
  %0 = ptrtoint i64* %seed.addr to i64
  call void @__dp_write(i32 163918, i64 %0, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.55, i32 0, i32 0))
  store i64 %seed, i64* %seed.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %seed.addr, metadata !1055, metadata !DIExpression()), !dbg !1056
  %1 = ptrtoint i64* %seed.addr to i64
  call void @__dp_read(i32 163920, i64 %1, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.55, i32 0, i32 0))
  %2 = load i64, i64* %seed.addr, align 8, !dbg !1057
  %3 = ptrtoint i64* @rand_nxt to i64
  call void @__dp_write(i32 163920, i64 %3, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.54, i32 0, i32 0))
  store i64 %2, i64* @rand_nxt, align 8, !dbg !1058
  call void @__dp_func_exit(i32 163921, i32 0), !dbg !1059
  ret void, !dbg !1059
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @sort_init() #0 !dbg !1060 {
entry:
  call void @__dp_func_entry(i32 164256, i32 0), !dbg !1061
  %0 = ptrtoint i32* @bots_arg_size to i64
  call void @__dp_read(i32 164256, i64 %0, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.51, i32 0, i32 0))
  %1 = load i32, i32* @bots_arg_size, align 4, !dbg !1061
  %cmp = icmp slt i32 %1, 4, !dbg !1063
  br i1 %cmp, label %if.then, label %if.end3, !dbg !1064

if.then:                                          ; preds = %entry
  %2 = ptrtoint i32* @bots_verbose_mode to i64
  call void @__dp_read(i32 164257, i64 %2, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.56, i32 0, i32 0))
  %3 = load i32, i32* @bots_verbose_mode, align 4, !dbg !1065
  %cmp1 = icmp uge i32 %3, 1, !dbg !1065
  br i1 %cmp1, label %if.then2, label %if.end, !dbg !1069

if.then2:                                         ; preds = %if.then
  %4 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 164257, i64 %4, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.57, i32 0, i32 0))
  %5 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1070
  call void @__dp_call(i32 164257), !dbg !1070
  %call = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %5, i8* getelementptr inbounds ([52 x i8], [52 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.1, i32 0, i32 0)), !dbg !1070
  br label %if.end, !dbg !1070

if.end:                                           ; preds = %if.then2, %if.then
  %6 = ptrtoint i32* @bots_arg_size to i64
  call void @__dp_write(i32 164258, i64 %6, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.51, i32 0, i32 0))
  store i32 4, i32* @bots_arg_size, align 4, !dbg !1072
  br label %if.end3, !dbg !1073

if.end3:                                          ; preds = %if.end, %entry
  %7 = ptrtoint i32* @bots_app_cutoff_value to i64
  call void @__dp_read(i32 164261, i64 %7, i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.34, i32 0, i32 0))
  %8 = load i32, i32* @bots_app_cutoff_value, align 4, !dbg !1074
  %cmp4 = icmp slt i32 %8, 2, !dbg !1076
  br i1 %cmp4, label %if.then5, label %if.else, !dbg !1077

if.then5:                                         ; preds = %if.end3
  %9 = ptrtoint i32* @bots_verbose_mode to i64
  call void @__dp_read(i32 164262, i64 %9, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.56, i32 0, i32 0))
  %10 = load i32, i32* @bots_verbose_mode, align 4, !dbg !1078
  %cmp6 = icmp uge i32 %10, 1, !dbg !1078
  br i1 %cmp6, label %if.then7, label %if.end9, !dbg !1082

if.then7:                                         ; preds = %if.then5
  %11 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 164262, i64 %11, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.57, i32 0, i32 0))
  %12 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1083
  call void @__dp_call(i32 164262), !dbg !1083
  %call8 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %12, i8* getelementptr inbounds ([52 x i8], [52 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([30 x i8], [30 x i8]* @.str.3, i32 0, i32 0)), !dbg !1083
  br label %if.end9, !dbg !1083

if.end9:                                          ; preds = %if.then7, %if.then5
  %13 = ptrtoint i32* @bots_app_cutoff_value to i64
  call void @__dp_write(i32 164263, i64 %13, i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.34, i32 0, i32 0))
  store i32 2, i32* @bots_app_cutoff_value, align 4, !dbg !1085
  br label %if.end17, !dbg !1086

if.else:                                          ; preds = %if.end3
  %14 = ptrtoint i32* @bots_app_cutoff_value to i64
  call void @__dp_read(i32 164265, i64 %14, i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.34, i32 0, i32 0))
  %15 = load i32, i32* @bots_app_cutoff_value, align 4, !dbg !1087
  %16 = ptrtoint i32* @bots_arg_size to i64
  call void @__dp_read(i32 164265, i64 %16, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.51, i32 0, i32 0))
  %17 = load i32, i32* @bots_arg_size, align 4, !dbg !1089
  %cmp10 = icmp sgt i32 %15, %17, !dbg !1090
  br i1 %cmp10, label %if.then11, label %if.end16, !dbg !1091

if.then11:                                        ; preds = %if.else
  %18 = ptrtoint i32* @bots_verbose_mode to i64
  call void @__dp_read(i32 164266, i64 %18, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.56, i32 0, i32 0))
  %19 = load i32, i32* @bots_verbose_mode, align 4, !dbg !1092
  %cmp12 = icmp uge i32 %19, 1, !dbg !1092
  br i1 %cmp12, label %if.then13, label %if.end15, !dbg !1096

if.then13:                                        ; preds = %if.then11
  %20 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 164266, i64 %20, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.57, i32 0, i32 0))
  %21 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1097
  %22 = ptrtoint i32* @bots_arg_size to i64
  call void @__dp_read(i32 164266, i64 %22, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.51, i32 0, i32 0))
  %23 = load i32, i32* @bots_arg_size, align 4, !dbg !1097
  call void @__dp_call(i32 164266), !dbg !1097
  %call14 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %21, i8* getelementptr inbounds ([67 x i8], [67 x i8]* @.str.4, i32 0, i32 0), i8* getelementptr inbounds ([30 x i8], [30 x i8]* @.str.3, i32 0, i32 0), i32 %23), !dbg !1097
  br label %if.end15, !dbg !1097

if.end15:                                         ; preds = %if.then13, %if.then11
  %24 = ptrtoint i32* @bots_arg_size to i64
  call void @__dp_read(i32 164267, i64 %24, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.51, i32 0, i32 0))
  %25 = load i32, i32* @bots_arg_size, align 4, !dbg !1099
  %26 = ptrtoint i32* @bots_app_cutoff_value to i64
  call void @__dp_write(i32 164267, i64 %26, i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.34, i32 0, i32 0))
  store i32 %25, i32* @bots_app_cutoff_value, align 4, !dbg !1100
  br label %if.end16, !dbg !1101

if.end16:                                         ; preds = %if.end15, %if.else
  br label %if.end17

if.end17:                                         ; preds = %if.end16, %if.end9
  %27 = ptrtoint i32* @bots_app_cutoff_value_1 to i64
  call void @__dp_read(i32 164270, i64 %27, i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.41, i32 0, i32 0))
  %28 = load i32, i32* @bots_app_cutoff_value_1, align 4, !dbg !1102
  %29 = ptrtoint i32* @bots_arg_size to i64
  call void @__dp_read(i32 164270, i64 %29, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.51, i32 0, i32 0))
  %30 = load i32, i32* @bots_arg_size, align 4, !dbg !1104
  %cmp18 = icmp sgt i32 %28, %30, !dbg !1105
  br i1 %cmp18, label %if.then19, label %if.end24, !dbg !1106

if.then19:                                        ; preds = %if.end17
  %31 = ptrtoint i32* @bots_verbose_mode to i64
  call void @__dp_read(i32 164271, i64 %31, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.56, i32 0, i32 0))
  %32 = load i32, i32* @bots_verbose_mode, align 4, !dbg !1107
  %cmp20 = icmp uge i32 %32, 1, !dbg !1107
  br i1 %cmp20, label %if.then21, label %if.end23, !dbg !1111

if.then21:                                        ; preds = %if.then19
  %33 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 164271, i64 %33, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.57, i32 0, i32 0))
  %34 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1112
  %35 = ptrtoint i32* @bots_arg_size to i64
  call void @__dp_read(i32 164271, i64 %35, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.51, i32 0, i32 0))
  %36 = load i32, i32* @bots_arg_size, align 4, !dbg !1112
  call void @__dp_call(i32 164271), !dbg !1112
  %call22 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %34, i8* getelementptr inbounds ([67 x i8], [67 x i8]* @.str.4, i32 0, i32 0), i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.5, i32 0, i32 0), i32 %36), !dbg !1112
  br label %if.end23, !dbg !1112

if.end23:                                         ; preds = %if.then21, %if.then19
  %37 = ptrtoint i32* @bots_arg_size to i64
  call void @__dp_read(i32 164272, i64 %37, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.51, i32 0, i32 0))
  %38 = load i32, i32* @bots_arg_size, align 4, !dbg !1114
  %39 = ptrtoint i32* @bots_app_cutoff_value_1 to i64
  call void @__dp_write(i32 164272, i64 %39, i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.41, i32 0, i32 0))
  store i32 %38, i32* @bots_app_cutoff_value_1, align 4, !dbg !1115
  br label %if.end24, !dbg !1116

if.end24:                                         ; preds = %if.end23, %if.end17
  %40 = ptrtoint i32* @bots_app_cutoff_value_2 to i64
  call void @__dp_read(i32 164274, i64 %40, i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.12, i32 0, i32 0))
  %41 = load i32, i32* @bots_app_cutoff_value_2, align 4, !dbg !1117
  %42 = ptrtoint i32* @bots_arg_size to i64
  call void @__dp_read(i32 164274, i64 %42, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.51, i32 0, i32 0))
  %43 = load i32, i32* @bots_arg_size, align 4, !dbg !1119
  %cmp25 = icmp sgt i32 %41, %43, !dbg !1120
  br i1 %cmp25, label %if.then26, label %if.end31, !dbg !1121

if.then26:                                        ; preds = %if.end24
  %44 = ptrtoint i32* @bots_verbose_mode to i64
  call void @__dp_read(i32 164275, i64 %44, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.56, i32 0, i32 0))
  %45 = load i32, i32* @bots_verbose_mode, align 4, !dbg !1122
  %cmp27 = icmp uge i32 %45, 1, !dbg !1122
  br i1 %cmp27, label %if.then28, label %if.end30, !dbg !1126

if.then28:                                        ; preds = %if.then26
  %46 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 164275, i64 %46, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.57, i32 0, i32 0))
  %47 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1127
  %48 = ptrtoint i32* @bots_arg_size to i64
  call void @__dp_read(i32 164275, i64 %48, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.51, i32 0, i32 0))
  %49 = load i32, i32* @bots_arg_size, align 4, !dbg !1127
  call void @__dp_call(i32 164275), !dbg !1127
  %call29 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %47, i8* getelementptr inbounds ([67 x i8], [67 x i8]* @.str.4, i32 0, i32 0), i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.6, i32 0, i32 0), i32 %49), !dbg !1127
  br label %if.end30, !dbg !1127

if.end30:                                         ; preds = %if.then28, %if.then26
  %50 = ptrtoint i32* @bots_arg_size to i64
  call void @__dp_read(i32 164276, i64 %50, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.51, i32 0, i32 0))
  %51 = load i32, i32* @bots_arg_size, align 4, !dbg !1129
  %52 = ptrtoint i32* @bots_app_cutoff_value_2 to i64
  call void @__dp_write(i32 164276, i64 %52, i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.12, i32 0, i32 0))
  store i32 %51, i32* @bots_app_cutoff_value_2, align 4, !dbg !1130
  br label %if.end31, !dbg !1131

if.end31:                                         ; preds = %if.end30, %if.end24
  %53 = ptrtoint i32* @bots_app_cutoff_value_2 to i64
  call void @__dp_read(i32 164279, i64 %53, i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.12, i32 0, i32 0))
  %54 = load i32, i32* @bots_app_cutoff_value_2, align 4, !dbg !1132
  %55 = ptrtoint i32* @bots_app_cutoff_value_1 to i64
  call void @__dp_read(i32 164279, i64 %55, i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.41, i32 0, i32 0))
  %56 = load i32, i32* @bots_app_cutoff_value_1, align 4, !dbg !1134
  %cmp32 = icmp sgt i32 %54, %56, !dbg !1135
  br i1 %cmp32, label %if.then33, label %if.end38, !dbg !1136

if.then33:                                        ; preds = %if.end31
  %57 = ptrtoint i32* @bots_verbose_mode to i64
  call void @__dp_read(i32 164280, i64 %57, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.56, i32 0, i32 0))
  %58 = load i32, i32* @bots_verbose_mode, align 4, !dbg !1137
  %cmp34 = icmp uge i32 %58, 1, !dbg !1137
  br i1 %cmp34, label %if.then35, label %if.end37, !dbg !1141

if.then35:                                        ; preds = %if.then33
  %59 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 164280, i64 %59, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.57, i32 0, i32 0))
  %60 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1142
  %61 = ptrtoint i32* @bots_app_cutoff_value_1 to i64
  call void @__dp_read(i32 164280, i64 %61, i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.41, i32 0, i32 0))
  %62 = load i32, i32* @bots_app_cutoff_value_1, align 4, !dbg !1142
  call void @__dp_call(i32 164280), !dbg !1142
  %call36 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %60, i8* getelementptr inbounds ([58 x i8], [58 x i8]* @.str.7, i32 0, i32 0), i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.6, i32 0, i32 0), i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.5, i32 0, i32 0), i32 %62), !dbg !1142
  br label %if.end37, !dbg !1142

if.end37:                                         ; preds = %if.then35, %if.then33
  %63 = ptrtoint i32* @bots_app_cutoff_value_1 to i64
  call void @__dp_read(i32 164285, i64 %63, i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.41, i32 0, i32 0))
  %64 = load i32, i32* @bots_app_cutoff_value_1, align 4, !dbg !1144
  %65 = ptrtoint i32* @bots_app_cutoff_value_2 to i64
  call void @__dp_write(i32 164285, i64 %65, i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.12, i32 0, i32 0))
  store i32 %64, i32* @bots_app_cutoff_value_2, align 4, !dbg !1145
  br label %if.end38, !dbg !1146

if.end38:                                         ; preds = %if.end37, %if.end31
  %66 = ptrtoint i32* @bots_arg_size to i64
  call void @__dp_read(i32 164288, i64 %66, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.51, i32 0, i32 0))
  %67 = load i32, i32* @bots_arg_size, align 4, !dbg !1147
  %conv = sext i32 %67 to i64, !dbg !1147
  %mul = mul i64 %conv, 8, !dbg !1148
  call void @__dp_call(i32 164288), !dbg !1149
  %call39 = call noalias i8* @malloc(i64 %mul) #7, !dbg !1149
  %68 = bitcast i8* %call39 to i64*, !dbg !1150
  %69 = ptrtoint i64** @array to i64
  call void @__dp_write(i32 164288, i64 %69, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.53, i32 0, i32 0))
  store i64* %68, i64** @array, align 8, !dbg !1151
  %70 = ptrtoint i32* @bots_arg_size to i64
  call void @__dp_read(i32 164289, i64 %70, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.51, i32 0, i32 0))
  %71 = load i32, i32* @bots_arg_size, align 4, !dbg !1152
  %conv40 = sext i32 %71 to i64, !dbg !1152
  %mul41 = mul i64 %conv40, 8, !dbg !1153
  call void @__dp_call(i32 164289), !dbg !1154
  %call42 = call noalias i8* @malloc(i64 %mul41) #7, !dbg !1154
  %72 = bitcast i8* %call42 to i64*, !dbg !1155
  %73 = ptrtoint i64** @tmp to i64
  call void @__dp_write(i32 164289, i64 %73, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.32, i32 0, i32 0))
  store i64* %72, i64** @tmp, align 8, !dbg !1156
  call void @__dp_call(i32 164291), !dbg !1157
  call void @fill_array(), !dbg !1157
  call void @__dp_call(i32 164292), !dbg !1158
  call void @scramble_array(), !dbg !1158
  call void @__dp_func_exit(i32 164293, i32 0), !dbg !1159
  ret void, !dbg !1159
}

declare dso_local i32 @fprintf(%struct._IO_FILE*, i8*, ...) #3

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64) #4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @sort() #0 !dbg !1160 {
entry:
  call void @__dp_func_entry(i32 164297, i32 0), !dbg !1161
  %0 = ptrtoint i32* @bots_verbose_mode to i64
  call void @__dp_read(i32 164297, i64 %0, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.56, i32 0, i32 0))
  %1 = load i32, i32* @bots_verbose_mode, align 4, !dbg !1161
  %cmp = icmp uge i32 %1, 1, !dbg !1161
  br i1 %cmp, label %if.then, label %if.end, !dbg !1164

if.then:                                          ; preds = %entry
  %2 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 164297, i64 %2, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.57, i32 0, i32 0))
  %3 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1165
  %4 = ptrtoint i32* @bots_arg_size to i64
  call void @__dp_read(i32 164297, i64 %4, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.51, i32 0, i32 0))
  %5 = load i32, i32* @bots_arg_size, align 4, !dbg !1165
  call void @__dp_call(i32 164297), !dbg !1165
  %call = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([38 x i8], [38 x i8]* @.str.8, i32 0, i32 0), i32 %5), !dbg !1165
  br label %if.end, !dbg !1165

if.end:                                           ; preds = %if.then, %entry
  %6 = ptrtoint i64** @array to i64
  call void @__dp_read(i32 164298, i64 %6, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.53, i32 0, i32 0))
  %7 = load i64*, i64** @array, align 8, !dbg !1167
  %8 = ptrtoint i64** @tmp to i64
  call void @__dp_read(i32 164298, i64 %8, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.32, i32 0, i32 0))
  %9 = load i64*, i64** @tmp, align 8, !dbg !1168
  %10 = ptrtoint i32* @bots_arg_size to i64
  call void @__dp_read(i32 164298, i64 %10, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.51, i32 0, i32 0))
  %11 = load i32, i32* @bots_arg_size, align 4, !dbg !1169
  %conv = sext i32 %11 to i64, !dbg !1169
  call void @__dp_call(i32 164298), !dbg !1170
  call void @cilksort(i64* %7, i64* %9, i64 %conv), !dbg !1170
  %12 = ptrtoint i32* @bots_verbose_mode to i64
  call void @__dp_read(i32 164299, i64 %12, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.56, i32 0, i32 0))
  %13 = load i32, i32* @bots_verbose_mode, align 4, !dbg !1171
  %cmp1 = icmp uge i32 %13, 1, !dbg !1171
  br i1 %cmp1, label %if.then3, label %if.end5, !dbg !1174

if.then3:                                         ; preds = %if.end
  %14 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 164299, i64 %14, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.57, i32 0, i32 0))
  %15 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1175
  call void @__dp_call(i32 164299), !dbg !1175
  %call4 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %15, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.9, i32 0, i32 0)), !dbg !1175
  br label %if.end5, !dbg !1175

if.end5:                                          ; preds = %if.then3, %if.end
  call void @__dp_func_exit(i32 164300, i32 0), !dbg !1177
  ret void, !dbg !1177
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @sort_verify() #0 !dbg !1178 {
entry:
  call void @__dp_func_entry(i32 164302, i32 0)
  %i = alloca i32, align 4
  %success = alloca i32, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !1181, metadata !DIExpression()), !dbg !1182
  call void @llvm.dbg.declare(metadata i32* %success, metadata !1183, metadata !DIExpression()), !dbg !1184
  %0 = ptrtoint i32* %success to i64
  call void @__dp_write(i32 164304, i64 %0, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.58, i32 0, i32 0))
  store i32 1, i32* %success, align 4, !dbg !1184
  %1 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 164305, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.50, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !1185
  br label %for.cond, !dbg !1187

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 164305, i32 11)
  %2 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 164305, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.50, i32 0, i32 0))
  %3 = load i32, i32* %i, align 4, !dbg !1188
  %4 = ptrtoint i32* @bots_arg_size to i64
  call void @__dp_read(i32 164305, i64 %4, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.51, i32 0, i32 0))
  %5 = load i32, i32* @bots_arg_size, align 4, !dbg !1190
  %cmp = icmp slt i32 %3, %5, !dbg !1191
  br i1 %cmp, label %for.body, label %for.end, !dbg !1192

for.body:                                         ; preds = %for.cond
  %6 = ptrtoint i64** @array to i64
  call void @__dp_read(i32 164306, i64 %6, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.53, i32 0, i32 0))
  %7 = load i64*, i64** @array, align 8, !dbg !1193
  %8 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 164306, i64 %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.50, i32 0, i32 0))
  %9 = load i32, i32* %i, align 4, !dbg !1195
  %idxprom = sext i32 %9 to i64, !dbg !1193
  %arrayidx = getelementptr inbounds i64, i64* %7, i64 %idxprom, !dbg !1193
  %10 = ptrtoint i64* %arrayidx to i64
  call void @__dp_read(i32 164306, i64 %10, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.53, i32 0, i32 0))
  %11 = load i64, i64* %arrayidx, align 8, !dbg !1193
  %12 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 164306, i64 %12, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.50, i32 0, i32 0))
  %13 = load i32, i32* %i, align 4, !dbg !1196
  %conv = sext i32 %13 to i64, !dbg !1196
  %cmp1 = icmp ne i64 %11, %conv, !dbg !1197
  br i1 %cmp1, label %if.then, label %if.end, !dbg !1198

if.then:                                          ; preds = %for.body
  %14 = ptrtoint i32* %success to i64
  call void @__dp_write(i32 164306, i64 %14, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.58, i32 0, i32 0))
  store i32 0, i32* %success, align 4, !dbg !1199
  br label %if.end, !dbg !1200

if.end:                                           ; preds = %if.then, %for.body
  br label %for.inc, !dbg !1196

for.inc:                                          ; preds = %if.end
  %15 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 164305, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.50, i32 0, i32 0))
  %16 = load i32, i32* %i, align 4, !dbg !1201
  %inc = add nsw i32 %16, 1, !dbg !1201
  %17 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 164305, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.50, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !1201
  br label %for.cond, !dbg !1202, !llvm.loop !1203

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 164308, i32 11)
  %18 = ptrtoint i32* %success to i64
  call void @__dp_read(i32 164308, i64 %18, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.58, i32 0, i32 0))
  %19 = load i32, i32* %success, align 4, !dbg !1205
  %tobool = icmp ne i32 %19, 0, !dbg !1205
  %20 = zext i1 %tobool to i64, !dbg !1205
  %cond = select i1 %tobool, i32 1, i32 2, !dbg !1205
  call void @__dp_func_exit(i32 164308, i32 0), !dbg !1206
  ret i32 %cond, !dbg !1206
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_error(i32 %error, i8* %message) #0 !dbg !1207 {
entry:
  call void @__dp_func_entry(i32 32803, i32 0)
  %error.addr = alloca i32, align 4
  %message.addr = alloca i8*, align 8
  %0 = ptrtoint i32* %error.addr to i64
  call void @__dp_write(i32 32803, i64 %0, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.48.1, i32 0, i32 0))
  store i32 %error, i32* %error.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %error.addr, metadata !1211, metadata !DIExpression()), !dbg !1212
  %1 = ptrtoint i8** %message.addr to i64
  call void @__dp_write(i32 32803, i64 %1, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.49.2, i32 0, i32 0))
  store i8* %message, i8** %message.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %message.addr, metadata !1213, metadata !DIExpression()), !dbg !1214
  %2 = ptrtoint i8** %message.addr to i64
  call void @__dp_read(i32 32805, i64 %2, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.49.2, i32 0, i32 0))
  %3 = load i8*, i8** %message.addr, align 8, !dbg !1215
  %cmp = icmp eq i8* %3, null, !dbg !1217
  br i1 %cmp, label %if.then, label %if.else, !dbg !1218

if.then:                                          ; preds = %entry
  %4 = ptrtoint i32* %error.addr to i64
  call void @__dp_read(i32 32807, i64 %4, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.48.1, i32 0, i32 0))
  %5 = load i32, i32* %error.addr, align 4, !dbg !1219
  switch i32 %5, label %sw.default [
    i32 0, label %sw.bb
    i32 1, label %sw.bb1
    i32 2, label %sw.bb3
  ], !dbg !1221

sw.bb:                                            ; preds = %if.then
  %6 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 32810, i64 %6, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.50.3, i32 0, i32 0))
  %7 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1222
  %8 = ptrtoint i32* %error.addr to i64
  call void @__dp_read(i32 32810, i64 %8, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.48.1, i32 0, i32 0))
  %9 = load i32, i32* %error.addr, align 4, !dbg !1224
  call void @__dp_call(i32 32810), !dbg !1225
  %call = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %7, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.62, i32 0, i32 0), i32 %9, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.1.63, i32 0, i32 0)), !dbg !1225
  br label %sw.epilog, !dbg !1226

sw.bb1:                                           ; preds = %if.then
  %10 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 32813, i64 %10, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.50.3, i32 0, i32 0))
  %11 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1227
  %12 = ptrtoint i32* %error.addr to i64
  call void @__dp_read(i32 32813, i64 %12, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.48.1, i32 0, i32 0))
  %13 = load i32, i32* %error.addr, align 4, !dbg !1228
  call void @__dp_call(i32 32813), !dbg !1229
  %call2 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %11, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.62, i32 0, i32 0), i32 %13, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.2.64, i32 0, i32 0)), !dbg !1229
  br label %sw.epilog, !dbg !1230

sw.bb3:                                           ; preds = %if.then
  %14 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 32816, i64 %14, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.50.3, i32 0, i32 0))
  %15 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1231
  %16 = ptrtoint i32* %error.addr to i64
  call void @__dp_read(i32 32816, i64 %16, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.48.1, i32 0, i32 0))
  %17 = load i32, i32* %error.addr, align 4, !dbg !1232
  call void @__dp_call(i32 32816), !dbg !1233
  %call4 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %15, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.62, i32 0, i32 0), i32 %17, i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.3.65, i32 0, i32 0)), !dbg !1233
  call void @__dp_call(i32 32817), !dbg !1234
  call void @bots_print_usage(), !dbg !1234
  br label %sw.epilog, !dbg !1235

sw.default:                                       ; preds = %if.then
  %18 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 32820, i64 %18, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.50.3, i32 0, i32 0))
  %19 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1236
  %20 = ptrtoint i32* %error.addr to i64
  call void @__dp_read(i32 32820, i64 %20, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.48.1, i32 0, i32 0))
  %21 = load i32, i32* %error.addr, align 4, !dbg !1237
  call void @__dp_call(i32 32820), !dbg !1238
  %call5 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %19, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.62, i32 0, i32 0), i32 %21, i8* getelementptr inbounds ([20 x i8], [20 x i8]* @.str.4.66, i32 0, i32 0)), !dbg !1238
  br label %sw.epilog, !dbg !1239

sw.epilog:                                        ; preds = %sw.default, %sw.bb3, %sw.bb1, %sw.bb
  br label %if.end, !dbg !1240

if.else:                                          ; preds = %entry
  %22 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 32824, i64 %22, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.50.3, i32 0, i32 0))
  %23 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1241
  %24 = ptrtoint i32* %error.addr to i64
  call void @__dp_read(i32 32824, i64 %24, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.48.1, i32 0, i32 0))
  %25 = load i32, i32* %error.addr, align 4, !dbg !1242
  %26 = ptrtoint i8** %message.addr to i64
  call void @__dp_read(i32 32824, i64 %26, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.49.2, i32 0, i32 0))
  %27 = load i8*, i8** %message.addr, align 8, !dbg !1243
  call void @__dp_call(i32 32824), !dbg !1244
  %call6 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %23, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.62, i32 0, i32 0), i32 %25, i8* %27), !dbg !1244
  br label %if.end

if.end:                                           ; preds = %if.else, %sw.epilog
  %28 = ptrtoint i32* %error.addr to i64
  call void @__dp_read(i32 32825, i64 %28, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.48.1, i32 0, i32 0))
  %29 = load i32, i32* %error.addr, align 4, !dbg !1245
  %add = add nsw i32 100, %29, !dbg !1246
  call void @__dp_finalize(i32 32825), !dbg !1247
  call void @exit(i32 %add) #8, !dbg !1247
  unreachable, !dbg !1247

return:                                           ; No predecessors!
  call void @__dp_func_exit(i32 32826, i32 0), !dbg !1248
  ret void, !dbg !1248
}

declare void @__dp_finalize(i32)

; Function Attrs: noreturn nounwind
declare dso_local void @exit(i32) #5

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_warning(i32 %warning, i8* %message) #0 !dbg !1249 {
entry:
  call void @__dp_func_entry(i32 32829, i32 0)
  %warning.addr = alloca i32, align 4
  %message.addr = alloca i8*, align 8
  %0 = ptrtoint i32* %warning.addr to i64
  call void @__dp_write(i32 32829, i64 %0, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.51.67, i32 0, i32 0))
  store i32 %warning, i32* %warning.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %warning.addr, metadata !1250, metadata !DIExpression()), !dbg !1251
  %1 = ptrtoint i8** %message.addr to i64
  call void @__dp_write(i32 32829, i64 %1, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.49.2, i32 0, i32 0))
  store i8* %message, i8** %message.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %message.addr, metadata !1252, metadata !DIExpression()), !dbg !1253
  %2 = ptrtoint i8** %message.addr to i64
  call void @__dp_read(i32 32831, i64 %2, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.49.2, i32 0, i32 0))
  %3 = load i8*, i8** %message.addr, align 8, !dbg !1254
  %cmp = icmp eq i8* %3, null, !dbg !1256
  br i1 %cmp, label %if.then, label %if.else, !dbg !1257

if.then:                                          ; preds = %entry
  %4 = ptrtoint i32* %warning.addr to i64
  call void @__dp_read(i32 32833, i64 %4, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.51.67, i32 0, i32 0))
  %5 = load i32, i32* %warning.addr, align 4, !dbg !1258
  switch i32 %5, label %sw.default [
    i32 0, label %sw.bb
  ], !dbg !1260

sw.bb:                                            ; preds = %if.then
  %6 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 32836, i64 %6, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.50.3, i32 0, i32 0))
  %7 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1261
  %8 = ptrtoint i32* %warning.addr to i64
  call void @__dp_read(i32 32836, i64 %8, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.51.67, i32 0, i32 0))
  %9 = load i32, i32* %warning.addr, align 4, !dbg !1263
  call void @__dp_call(i32 32836), !dbg !1264
  %call = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %7, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.5.68, i32 0, i32 0), i32 %9, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.6.69, i32 0, i32 0)), !dbg !1264
  br label %sw.epilog, !dbg !1265

sw.default:                                       ; preds = %if.then
  %10 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 32839, i64 %10, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.50.3, i32 0, i32 0))
  %11 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1266
  %12 = ptrtoint i32* %warning.addr to i64
  call void @__dp_read(i32 32839, i64 %12, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.51.67, i32 0, i32 0))
  %13 = load i32, i32* %warning.addr, align 4, !dbg !1267
  call void @__dp_call(i32 32839), !dbg !1268
  %call1 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %11, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.5.68, i32 0, i32 0), i32 %13, i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.7.70, i32 0, i32 0)), !dbg !1268
  br label %sw.epilog, !dbg !1269

sw.epilog:                                        ; preds = %sw.default, %sw.bb
  br label %if.end, !dbg !1270

if.else:                                          ; preds = %entry
  %14 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 32843, i64 %14, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.50.3, i32 0, i32 0))
  %15 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1271
  %16 = ptrtoint i32* %warning.addr to i64
  call void @__dp_read(i32 32843, i64 %16, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.51.67, i32 0, i32 0))
  %17 = load i32, i32* %warning.addr, align 4, !dbg !1272
  %18 = ptrtoint i8** %message.addr to i64
  call void @__dp_read(i32 32843, i64 %18, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.49.2, i32 0, i32 0))
  %19 = load i8*, i8** %message.addr, align 8, !dbg !1273
  call void @__dp_call(i32 32843), !dbg !1274
  %call2 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %15, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.5.68, i32 0, i32 0), i32 %17, i8* %19), !dbg !1274
  br label %if.end

if.end:                                           ; preds = %if.else, %sw.epilog
  call void @__dp_func_exit(i32 32844, i32 0), !dbg !1275
  ret void, !dbg !1275
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i64 @bots_usecs() #0 !dbg !1276 {
entry:
  call void @__dp_func_entry(i32 32846, i32 0)
  %t = alloca %struct.timeval, align 8
  call void @llvm.dbg.declare(metadata %struct.timeval* %t, metadata !1279, metadata !DIExpression()), !dbg !1288
  call void @__dp_call(i32 32849), !dbg !1289
  %call = call i32 @gettimeofday(%struct.timeval* %t, i8* null) #7, !dbg !1289
  %tv_sec = getelementptr inbounds %struct.timeval, %struct.timeval* %t, i32 0, i32 0, !dbg !1290
  %0 = ptrtoint i64* %tv_sec to i64
  call void @__dp_read(i32 32850, i64 %0, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.52.71, i32 0, i32 0))
  %1 = load i64, i64* %tv_sec, align 8, !dbg !1290
  %mul = mul nsw i64 %1, 1000000, !dbg !1291
  %tv_usec = getelementptr inbounds %struct.timeval, %struct.timeval* %t, i32 0, i32 1, !dbg !1292
  %2 = ptrtoint i64* %tv_usec to i64
  call void @__dp_read(i32 32850, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.52.71, i32 0, i32 0))
  %3 = load i64, i64* %tv_usec, align 8, !dbg !1292
  %add = add nsw i64 %mul, %3, !dbg !1293
  call void @__dp_func_exit(i32 32850, i32 0), !dbg !1294
  ret i64 %add, !dbg !1294
}

; Function Attrs: nounwind
declare dso_local i32 @gettimeofday(%struct.timeval*, i8*) #4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_get_date(i8* %str) #0 !dbg !1295 {
entry:
  call void @__dp_func_entry(i32 32854, i32 0)
  %str.addr = alloca i8*, align 8
  %now = alloca i64, align 8
  %0 = ptrtoint i8** %str.addr to i64
  call void @__dp_write(i32 32854, i64 %0, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.53.72, i32 0, i32 0))
  store i8* %str, i8** %str.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %str.addr, metadata !1298, metadata !DIExpression()), !dbg !1299
  call void @llvm.dbg.declare(metadata i64* %now, metadata !1300, metadata !DIExpression()), !dbg !1303
  call void @__dp_call(i32 32857), !dbg !1304
  %call = call i64 @time(i64* %now) #7, !dbg !1304
  %1 = ptrtoint i8** %str.addr to i64
  call void @__dp_read(i32 32858, i64 %1, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.53.72, i32 0, i32 0))
  %2 = load i8*, i8** %str.addr, align 8, !dbg !1305
  call void @__dp_call(i32 32858), !dbg !1306
  %call1 = call %struct.tm* @gmtime(i64* %now) #7, !dbg !1306
  call void @__dp_call(i32 32858), !dbg !1307
  %call2 = call i64 @strftime(i8* %2, i64 32, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.8.73, i32 0, i32 0), %struct.tm* %call1) #7, !dbg !1307
  call void @__dp_func_exit(i32 32859, i32 0), !dbg !1308
  ret void, !dbg !1308
}

; Function Attrs: nounwind
declare dso_local i64 @time(i64*) #4

; Function Attrs: nounwind
declare dso_local %struct.tm* @gmtime(i64*) #4

; Function Attrs: nounwind
declare dso_local i64 @strftime(i8*, i64, i8*, %struct.tm*) #4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_get_architecture(i8* %str) #0 !dbg !1309 {
entry:
  call void @__dp_func_entry(i32 32861, i32 0)
  %str.addr = alloca i8*, align 8
  %ncpus = alloca i32, align 4
  %architecture = alloca %struct.utsname, align 1
  %0 = ptrtoint i8** %str.addr to i64
  call void @__dp_write(i32 32861, i64 %0, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.53.72, i32 0, i32 0))
  store i8* %str, i8** %str.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %str.addr, metadata !1310, metadata !DIExpression()), !dbg !1311
  call void @llvm.dbg.declare(metadata i32* %ncpus, metadata !1312, metadata !DIExpression()), !dbg !1313
  call void @__dp_call(i32 32863), !dbg !1314
  %call = call i64 @sysconf(i32 83) #7, !dbg !1314
  %conv = trunc i64 %call to i32, !dbg !1314
  %1 = ptrtoint i32* %ncpus to i64
  call void @__dp_write(i32 32863, i64 %1, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.54.74, i32 0, i32 0))
  store i32 %conv, i32* %ncpus, align 4, !dbg !1313
  call void @llvm.dbg.declare(metadata %struct.utsname* %architecture, metadata !1315, metadata !DIExpression()), !dbg !1328
  call void @__dp_call(i32 32866), !dbg !1329
  %call1 = call i32 @uname(%struct.utsname* %architecture) #7, !dbg !1329
  %2 = ptrtoint i8** %str.addr to i64
  call void @__dp_read(i32 32867, i64 %2, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.53.72, i32 0, i32 0))
  %3 = load i8*, i8** %str.addr, align 8, !dbg !1330
  %sysname = getelementptr inbounds %struct.utsname, %struct.utsname* %architecture, i32 0, i32 0, !dbg !1331
  %arraydecay = getelementptr inbounds [65 x i8], [65 x i8]* %sysname, i32 0, i32 0, !dbg !1332
  %machine = getelementptr inbounds %struct.utsname, %struct.utsname* %architecture, i32 0, i32 4, !dbg !1333
  %arraydecay2 = getelementptr inbounds [65 x i8], [65 x i8]* %machine, i32 0, i32 0, !dbg !1334
  %4 = ptrtoint i32* %ncpus to i64
  call void @__dp_read(i32 32867, i64 %4, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.54.74, i32 0, i32 0))
  %5 = load i32, i32* %ncpus, align 4, !dbg !1335
  call void @__dp_call(i32 32867), !dbg !1336
  %call3 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* %3, i64 256, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.9.75, i32 0, i32 0), i8* %arraydecay, i8* %arraydecay2, i32 %5) #7, !dbg !1336
  call void @__dp_func_exit(i32 32868, i32 0), !dbg !1337
  ret void, !dbg !1337
}

; Function Attrs: nounwind
declare dso_local i64 @sysconf(i32) #4

; Function Attrs: nounwind
declare dso_local i32 @uname(%struct.utsname*) #4

; Function Attrs: nounwind
declare dso_local i32 @snprintf(i8*, i64, i8*, ...) #4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_get_load_average(i8* %str) #0 !dbg !1338 {
entry:
  call void @__dp_func_entry(i32 32872, i32 0)
  %str.addr = alloca i8*, align 8
  %loadavg = alloca [3 x double], align 16
  %0 = ptrtoint i8** %str.addr to i64
  call void @__dp_write(i32 32872, i64 %0, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.53.72, i32 0, i32 0))
  store i8* %str, i8** %str.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %str.addr, metadata !1339, metadata !DIExpression()), !dbg !1340
  call void @llvm.dbg.declare(metadata [3 x double]* %loadavg, metadata !1341, metadata !DIExpression()), !dbg !1345
  %arraydecay = getelementptr inbounds [3 x double], [3 x double]* %loadavg, i32 0, i32 0, !dbg !1346
  call void @__dp_call(i32 32875), !dbg !1347
  %call = call i32 @getloadavg(double* %arraydecay, i32 3) #7, !dbg !1347
  %1 = ptrtoint i8** %str.addr to i64
  call void @__dp_read(i32 32876, i64 %1, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.53.72, i32 0, i32 0))
  %2 = load i8*, i8** %str.addr, align 8, !dbg !1348
  %arrayidx = getelementptr inbounds [3 x double], [3 x double]* %loadavg, i64 0, i64 0, !dbg !1349
  %3 = ptrtoint double* %arrayidx to i64
  call void @__dp_read(i32 32876, i64 %3, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.55.76, i32 0, i32 0))
  %4 = load double, double* %arrayidx, align 16, !dbg !1349
  %arrayidx1 = getelementptr inbounds [3 x double], [3 x double]* %loadavg, i64 0, i64 1, !dbg !1350
  %5 = ptrtoint double* %arrayidx1 to i64
  call void @__dp_read(i32 32876, i64 %5, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.55.76, i32 0, i32 0))
  %6 = load double, double* %arrayidx1, align 8, !dbg !1350
  %arrayidx2 = getelementptr inbounds [3 x double], [3 x double]* %loadavg, i64 0, i64 2, !dbg !1351
  %7 = ptrtoint double* %arrayidx2 to i64
  call void @__dp_read(i32 32876, i64 %7, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.55.76, i32 0, i32 0))
  %8 = load double, double* %arrayidx2, align 16, !dbg !1351
  call void @__dp_call(i32 32876), !dbg !1352
  %call3 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* %2, i64 256, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.10.77, i32 0, i32 0), double %4, double %6, double %8) #7, !dbg !1352
  call void @__dp_func_exit(i32 32877, i32 0), !dbg !1353
  ret void, !dbg !1353
}

; Function Attrs: nounwind
declare dso_local i32 @getloadavg(double*, i32) #4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_print_results() #0 !dbg !1354 {
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
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_name, metadata !1355, metadata !DIExpression()), !dbg !1356
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_parameters, metadata !1357, metadata !DIExpression()), !dbg !1358
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_model, metadata !1359, metadata !DIExpression()), !dbg !1360
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_resources, metadata !1361, metadata !DIExpression()), !dbg !1362
  call void @llvm.dbg.declare(metadata [15 x i8]* %str_result, metadata !1363, metadata !DIExpression()), !dbg !1367
  call void @llvm.dbg.declare(metadata [15 x i8]* %str_time_program, metadata !1368, metadata !DIExpression()), !dbg !1369
  call void @llvm.dbg.declare(metadata [15 x i8]* %str_time_sequential, metadata !1370, metadata !DIExpression()), !dbg !1371
  call void @llvm.dbg.declare(metadata [15 x i8]* %str_speed_up, metadata !1372, metadata !DIExpression()), !dbg !1373
  call void @llvm.dbg.declare(metadata [15 x i8]* %str_number_of_tasks, metadata !1374, metadata !DIExpression()), !dbg !1375
  call void @llvm.dbg.declare(metadata [15 x i8]* %str_number_of_tasks_per_second, metadata !1376, metadata !DIExpression()), !dbg !1377
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_exec_date, metadata !1378, metadata !DIExpression()), !dbg !1379
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_exec_message, metadata !1380, metadata !DIExpression()), !dbg !1381
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_architecture, metadata !1382, metadata !DIExpression()), !dbg !1383
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_load_avg, metadata !1384, metadata !DIExpression()), !dbg !1385
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_comp_date, metadata !1386, metadata !DIExpression()), !dbg !1387
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_comp_message, metadata !1388, metadata !DIExpression()), !dbg !1389
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_cc, metadata !1390, metadata !DIExpression()), !dbg !1391
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_cflags, metadata !1392, metadata !DIExpression()), !dbg !1393
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_ld, metadata !1394, metadata !DIExpression()), !dbg !1395
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_ldflags, metadata !1396, metadata !DIExpression()), !dbg !1397
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_cutoff, metadata !1398, metadata !DIExpression()), !dbg !1399
  %arraydecay = getelementptr inbounds [256 x i8], [256 x i8]* %str_name, i32 0, i32 0, !dbg !1400
  call void @__dp_call(i32 32908), !dbg !1401
  %call = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11.78, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_name, i32 0, i32 0)) #7, !dbg !1401
  %arraydecay1 = getelementptr inbounds [256 x i8], [256 x i8]* %str_parameters, i32 0, i32 0, !dbg !1402
  call void @__dp_call(i32 32909), !dbg !1403
  %call2 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay1, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11.78, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_parameters, i32 0, i32 0)) #7, !dbg !1403
  %arraydecay3 = getelementptr inbounds [256 x i8], [256 x i8]* %str_model, i32 0, i32 0, !dbg !1404
  call void @__dp_call(i32 32910), !dbg !1405
  %call4 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay3, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11.78, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_model, i32 0, i32 0)) #7, !dbg !1405
  %arraydecay5 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cutoff, i32 0, i32 0, !dbg !1406
  call void @__dp_call(i32 32911), !dbg !1407
  %call6 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay5, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11.78, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_cutoff, i32 0, i32 0)) #7, !dbg !1407
  %arraydecay7 = getelementptr inbounds [256 x i8], [256 x i8]* %str_resources, i32 0, i32 0, !dbg !1408
  call void @__dp_call(i32 32912), !dbg !1409
  %call8 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay7, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11.78, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_resources, i32 0, i32 0)) #7, !dbg !1409
  %0 = ptrtoint i32* @bots_result to i64
  call void @__dp_read(i32 32913, i64 %0, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.56.79, i32 0, i32 0))
  %1 = load i32, i32* @bots_result, align 4, !dbg !1410
  switch i32 %1, label %sw.default [
    i32 0, label %sw.bb
    i32 1, label %sw.bb11
    i32 2, label %sw.bb14
    i32 3, label %sw.bb17
  ], !dbg !1411

sw.bb:                                            ; preds = %entry
  %arraydecay9 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !1412
  call void @__dp_call(i32 32916), !dbg !1414
  %call10 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay9, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.12.80, i32 0, i32 0)) #7, !dbg !1414
  br label %sw.epilog, !dbg !1415

sw.bb11:                                          ; preds = %entry
  %arraydecay12 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !1416
  call void @__dp_call(i32 32919), !dbg !1417
  %call13 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay12, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.13.81, i32 0, i32 0)) #7, !dbg !1417
  br label %sw.epilog, !dbg !1418

sw.bb14:                                          ; preds = %entry
  %arraydecay15 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !1419
  call void @__dp_call(i32 32922), !dbg !1420
  %call16 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay15, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.14.82, i32 0, i32 0)) #7, !dbg !1420
  br label %sw.epilog, !dbg !1421

sw.bb17:                                          ; preds = %entry
  %arraydecay18 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !1422
  call void @__dp_call(i32 32925), !dbg !1423
  %call19 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay18, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.15.83, i32 0, i32 0)) #7, !dbg !1423
  br label %sw.epilog, !dbg !1424

sw.default:                                       ; preds = %entry
  %arraydecay20 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !1425
  call void @__dp_call(i32 32928), !dbg !1426
  %call21 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay20, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.16.84, i32 0, i32 0)) #7, !dbg !1426
  br label %sw.epilog, !dbg !1427

sw.epilog:                                        ; preds = %sw.default, %sw.bb17, %sw.bb14, %sw.bb11, %sw.bb
  %arraydecay22 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_program, i32 0, i32 0, !dbg !1428
  %2 = ptrtoint double* @bots_time_program to i64
  call void @__dp_read(i32 32931, i64 %2, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.57.85, i32 0, i32 0))
  %3 = load double, double* @bots_time_program, align 8, !dbg !1429
  call void @__dp_call(i32 32931), !dbg !1430
  %call23 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay22, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.17.86, i32 0, i32 0), double %3) #7, !dbg !1430
  %4 = ptrtoint i32* @bots_sequential_flag to i64
  call void @__dp_read(i32 32932, i64 %4, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.58.87, i32 0, i32 0))
  %5 = load i32, i32* @bots_sequential_flag, align 4, !dbg !1431
  %tobool = icmp ne i32 %5, 0, !dbg !1431
  br i1 %tobool, label %if.then, label %if.else, !dbg !1433

if.then:                                          ; preds = %sw.epilog
  %arraydecay24 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_sequential, i32 0, i32 0, !dbg !1434
  %6 = ptrtoint double* @bots_time_sequential to i64
  call void @__dp_read(i32 32932, i64 %6, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.59.88, i32 0, i32 0))
  %7 = load double, double* @bots_time_sequential, align 8, !dbg !1435
  call void @__dp_call(i32 32932), !dbg !1436
  %call25 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay24, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.17.86, i32 0, i32 0), double %7) #7, !dbg !1436
  br label %if.end, !dbg !1436

if.else:                                          ; preds = %sw.epilog
  %arraydecay26 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_sequential, i32 0, i32 0, !dbg !1437
  call void @__dp_call(i32 32933), !dbg !1438
  %call27 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay26, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.12.80, i32 0, i32 0)) #7, !dbg !1438
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %8 = ptrtoint i32* @bots_sequential_flag to i64
  call void @__dp_read(i32 32934, i64 %8, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.58.87, i32 0, i32 0))
  %9 = load i32, i32* @bots_sequential_flag, align 4, !dbg !1439
  %tobool28 = icmp ne i32 %9, 0, !dbg !1439
  br i1 %tobool28, label %if.then29, label %if.else32, !dbg !1441

if.then29:                                        ; preds = %if.end
  %arraydecay30 = getelementptr inbounds [15 x i8], [15 x i8]* %str_speed_up, i32 0, i32 0, !dbg !1442
  %10 = ptrtoint double* @bots_time_sequential to i64
  call void @__dp_read(i32 32935, i64 %10, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.59.88, i32 0, i32 0))
  %11 = load double, double* @bots_time_sequential, align 8, !dbg !1443
  %12 = ptrtoint double* @bots_time_program to i64
  call void @__dp_read(i32 32935, i64 %12, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.57.85, i32 0, i32 0))
  %13 = load double, double* @bots_time_program, align 8, !dbg !1444
  %div = fdiv double %11, %13, !dbg !1445
  call void @__dp_call(i32 32935), !dbg !1446
  %call31 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay30, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.18.89, i32 0, i32 0), double %div) #7, !dbg !1446
  br label %if.end35, !dbg !1446

if.else32:                                        ; preds = %if.end
  %arraydecay33 = getelementptr inbounds [15 x i8], [15 x i8]* %str_speed_up, i32 0, i32 0, !dbg !1447
  call void @__dp_call(i32 32936), !dbg !1448
  %call34 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay33, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.12.80, i32 0, i32 0)) #7, !dbg !1448
  br label %if.end35

if.end35:                                         ; preds = %if.else32, %if.then29
  %arraydecay36 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks, i32 0, i32 0, !dbg !1449
  %14 = ptrtoint i64* @bots_number_of_tasks to i64
  call void @__dp_read(i32 32938, i64 %14, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.60.90, i32 0, i32 0))
  %15 = load i64, i64* @bots_number_of_tasks, align 8, !dbg !1450
  %conv = uitofp i64 %15 to float, !dbg !1451
  %conv37 = fpext float %conv to double, !dbg !1451
  call void @__dp_call(i32 32938), !dbg !1452
  %call38 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay36, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.18.89, i32 0, i32 0), double %conv37) #7, !dbg !1452
  %arraydecay39 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks_per_second, i32 0, i32 0, !dbg !1453
  %16 = ptrtoint i64* @bots_number_of_tasks to i64
  call void @__dp_read(i32 32939, i64 %16, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.60.90, i32 0, i32 0))
  %17 = load i64, i64* @bots_number_of_tasks, align 8, !dbg !1454
  %conv40 = uitofp i64 %17 to float, !dbg !1455
  %conv41 = fpext float %conv40 to double, !dbg !1455
  %18 = ptrtoint double* @bots_time_program to i64
  call void @__dp_read(i32 32939, i64 %18, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.57.85, i32 0, i32 0))
  %19 = load double, double* @bots_time_program, align 8, !dbg !1456
  %div42 = fdiv double %conv41, %19, !dbg !1457
  call void @__dp_call(i32 32939), !dbg !1458
  %call43 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay39, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.18.89, i32 0, i32 0), double %div42) #7, !dbg !1458
  %arraydecay44 = getelementptr inbounds [256 x i8], [256 x i8]* %str_exec_date, i32 0, i32 0, !dbg !1459
  call void @__dp_call(i32 32941), !dbg !1460
  %call45 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay44, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11.78, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_exec_date, i32 0, i32 0)) #7, !dbg !1460
  %arraydecay46 = getelementptr inbounds [256 x i8], [256 x i8]* %str_exec_message, i32 0, i32 0, !dbg !1461
  call void @__dp_call(i32 32942), !dbg !1462
  %call47 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay46, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11.78, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_exec_message, i32 0, i32 0)) #7, !dbg !1462
  %arraydecay48 = getelementptr inbounds [256 x i8], [256 x i8]* %str_architecture, i32 0, i32 0, !dbg !1463
  call void @__dp_call(i32 32943), !dbg !1464
  call void @bots_get_architecture(i8* %arraydecay48), !dbg !1464
  %arraydecay49 = getelementptr inbounds [256 x i8], [256 x i8]* %str_load_avg, i32 0, i32 0, !dbg !1465
  call void @__dp_call(i32 32944), !dbg !1466
  call void @bots_get_load_average(i8* %arraydecay49), !dbg !1466
  %arraydecay50 = getelementptr inbounds [256 x i8], [256 x i8]* %str_comp_date, i32 0, i32 0, !dbg !1467
  call void @__dp_call(i32 32945), !dbg !1468
  %call51 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay50, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11.78, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_comp_date, i32 0, i32 0)) #7, !dbg !1468
  %arraydecay52 = getelementptr inbounds [256 x i8], [256 x i8]* %str_comp_message, i32 0, i32 0, !dbg !1469
  call void @__dp_call(i32 32946), !dbg !1470
  %call53 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay52, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11.78, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_comp_message, i32 0, i32 0)) #7, !dbg !1470
  %arraydecay54 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cc, i32 0, i32 0, !dbg !1471
  call void @__dp_call(i32 32947), !dbg !1472
  %call55 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay54, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11.78, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_cc, i32 0, i32 0)) #7, !dbg !1472
  %arraydecay56 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cflags, i32 0, i32 0, !dbg !1473
  call void @__dp_call(i32 32948), !dbg !1474
  %call57 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay56, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11.78, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_cflags, i32 0, i32 0)) #7, !dbg !1474
  %arraydecay58 = getelementptr inbounds [256 x i8], [256 x i8]* %str_ld, i32 0, i32 0, !dbg !1475
  call void @__dp_call(i32 32949), !dbg !1476
  %call59 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay58, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11.78, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_ld, i32 0, i32 0)) #7, !dbg !1476
  %arraydecay60 = getelementptr inbounds [256 x i8], [256 x i8]* %str_ldflags, i32 0, i32 0, !dbg !1477
  call void @__dp_call(i32 32950), !dbg !1478
  %call61 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay60, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11.78, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_ldflags, i32 0, i32 0)) #7, !dbg !1478
  %20 = ptrtoint i32* @bots_print_header to i64
  call void @__dp_read(i32 32952, i64 %20, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.61.91, i32 0, i32 0))
  %21 = load i32, i32* @bots_print_header, align 4, !dbg !1479
  %tobool62 = icmp ne i32 %21, 0, !dbg !1479
  br i1 %tobool62, label %if.then63, label %if.end73, !dbg !1481

if.then63:                                        ; preds = %if.end35
  %22 = ptrtoint i32* @bots_output_format to i64
  call void @__dp_read(i32 32954, i64 %22, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.62.92, i32 0, i32 0))
  %23 = load i32, i32* @bots_output_format, align 4, !dbg !1482
  switch i32 %23, label %sw.default71 [
    i32 0, label %sw.bb64
    i32 1, label %sw.bb65
    i32 2, label %sw.bb66
    i32 3, label %sw.bb68
    i32 4, label %sw.bb69
  ], !dbg !1484

sw.bb64:                                          ; preds = %if.then63
  br label %sw.epilog72, !dbg !1485

sw.bb65:                                          ; preds = %if.then63
  br label %sw.epilog72, !dbg !1487

sw.bb66:                                          ; preds = %if.then63
  %24 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32961, i64 %24, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %25 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1488
  call void @__dp_call(i32 32961), !dbg !1489
  %call67 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %25, i8* getelementptr inbounds ([238 x i8], [238 x i8]* @.str.19.93, i32 0, i32 0)), !dbg !1489
  br label %sw.epilog72, !dbg !1490

sw.bb68:                                          ; preds = %if.then63
  br label %sw.epilog72, !dbg !1491

sw.bb69:                                          ; preds = %if.then63
  %26 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32972, i64 %26, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %27 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1492
  call void @__dp_call(i32 32972), !dbg !1493
  %call70 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %27, i8* getelementptr inbounds ([94 x i8], [94 x i8]* @.str.20.94, i32 0, i32 0)), !dbg !1493
  br label %sw.epilog72, !dbg !1494

sw.default71:                                     ; preds = %if.then63
  br label %sw.epilog72, !dbg !1495

sw.epilog72:                                      ; preds = %sw.default71, %sw.bb69, %sw.bb68, %sw.bb66, %sw.bb65, %sw.bb64
  br label %if.end73, !dbg !1496

if.end73:                                         ; preds = %sw.epilog72, %if.end35
  %28 = ptrtoint i32* @bots_output_format to i64
  call void @__dp_read(i32 32983, i64 %28, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.62.92, i32 0, i32 0))
  %29 = load i32, i32* @bots_output_format, align 4, !dbg !1497
  switch i32 %29, label %sw.default203 [
    i32 0, label %sw.bb74
    i32 1, label %sw.bb75
    i32 2, label %sw.bb126
    i32 3, label %sw.bb156
    i32 4, label %sw.bb187
  ], !dbg !1498

sw.bb74:                                          ; preds = %if.end73
  br label %sw.epilog204, !dbg !1499

sw.bb75:                                          ; preds = %if.end73
  %30 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32988, i64 %30, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %31 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1501
  call void @__dp_call(i32 32988), !dbg !1502
  %call76 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %31, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.21.95, i32 0, i32 0)), !dbg !1502
  %32 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32989, i64 %32, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %33 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1503
  %arraydecay77 = getelementptr inbounds [256 x i8], [256 x i8]* %str_name, i32 0, i32 0, !dbg !1504
  call void @__dp_call(i32 32989), !dbg !1505
  %call78 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %33, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.22.96, i32 0, i32 0), i8* %arraydecay77), !dbg !1505
  %34 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32990, i64 %34, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %35 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1506
  %arraydecay79 = getelementptr inbounds [256 x i8], [256 x i8]* %str_parameters, i32 0, i32 0, !dbg !1507
  call void @__dp_call(i32 32990), !dbg !1508
  %call80 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %35, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.23.97, i32 0, i32 0), i8* %arraydecay79), !dbg !1508
  %36 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32991, i64 %36, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %37 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1509
  %arraydecay81 = getelementptr inbounds [256 x i8], [256 x i8]* %str_model, i32 0, i32 0, !dbg !1510
  call void @__dp_call(i32 32991), !dbg !1511
  %call82 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %37, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.24.98, i32 0, i32 0), i8* %arraydecay81), !dbg !1511
  %38 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32992, i64 %38, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %39 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1512
  %arraydecay83 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cutoff, i32 0, i32 0, !dbg !1513
  call void @__dp_call(i32 32992), !dbg !1514
  %call84 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %39, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.25.99, i32 0, i32 0), i8* %arraydecay83), !dbg !1514
  %40 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32993, i64 %40, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %41 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1515
  %arraydecay85 = getelementptr inbounds [256 x i8], [256 x i8]* %str_resources, i32 0, i32 0, !dbg !1516
  call void @__dp_call(i32 32993), !dbg !1517
  %call86 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %41, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.26.100, i32 0, i32 0), i8* %arraydecay85), !dbg !1517
  %42 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32994, i64 %42, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %43 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1518
  %arraydecay87 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !1519
  call void @__dp_call(i32 32994), !dbg !1520
  %call88 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %43, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.27.101, i32 0, i32 0), i8* %arraydecay87), !dbg !1520
  %44 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32996, i64 %44, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %45 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1521
  %arraydecay89 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_program, i32 0, i32 0, !dbg !1522
  call void @__dp_call(i32 32996), !dbg !1523
  %call90 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %45, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.28.102, i32 0, i32 0), i8* %arraydecay89), !dbg !1523
  %46 = ptrtoint i32* @bots_sequential_flag to i64
  call void @__dp_read(i32 32997, i64 %46, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.58.87, i32 0, i32 0))
  %47 = load i32, i32* @bots_sequential_flag, align 4, !dbg !1524
  %tobool91 = icmp ne i32 %47, 0, !dbg !1524
  br i1 %tobool91, label %if.then92, label %if.end97, !dbg !1526

if.then92:                                        ; preds = %sw.bb75
  %48 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32998, i64 %48, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %49 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1527
  %arraydecay93 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_sequential, i32 0, i32 0, !dbg !1529
  call void @__dp_call(i32 32998), !dbg !1530
  %call94 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %49, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.29.103, i32 0, i32 0), i8* %arraydecay93), !dbg !1530
  %50 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 32999, i64 %50, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %51 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1531
  %arraydecay95 = getelementptr inbounds [15 x i8], [15 x i8]* %str_speed_up, i32 0, i32 0, !dbg !1532
  call void @__dp_call(i32 32999), !dbg !1533
  %call96 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %51, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.30.104, i32 0, i32 0), i8* %arraydecay95), !dbg !1533
  br label %if.end97, !dbg !1534

if.end97:                                         ; preds = %if.then92, %sw.bb75
  %52 = ptrtoint i64* @bots_number_of_tasks to i64
  call void @__dp_read(i32 33002, i64 %52, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.60.90, i32 0, i32 0))
  %53 = load i64, i64* @bots_number_of_tasks, align 8, !dbg !1535
  %cmp = icmp ugt i64 %53, 0, !dbg !1537
  br i1 %cmp, label %if.then99, label %if.end104, !dbg !1538

if.then99:                                        ; preds = %if.end97
  %54 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33003, i64 %54, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %55 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1539
  %arraydecay100 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks, i32 0, i32 0, !dbg !1541
  call void @__dp_call(i32 33003), !dbg !1542
  %call101 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %55, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.31.105, i32 0, i32 0), i8* %arraydecay100), !dbg !1542
  %56 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33004, i64 %56, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %57 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1543
  %arraydecay102 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks_per_second, i32 0, i32 0, !dbg !1544
  call void @__dp_call(i32 33004), !dbg !1545
  %call103 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %57, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.32.106, i32 0, i32 0), i8* %arraydecay102), !dbg !1545
  br label %if.end104, !dbg !1546

if.end104:                                        ; preds = %if.then99, %if.end97
  %58 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33007, i64 %58, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %59 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1547
  %arraydecay105 = getelementptr inbounds [256 x i8], [256 x i8]* %str_exec_date, i32 0, i32 0, !dbg !1548
  call void @__dp_call(i32 33007), !dbg !1549
  %call106 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %59, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.33.107, i32 0, i32 0), i8* %arraydecay105), !dbg !1549
  %60 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33008, i64 %60, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %61 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1550
  %arraydecay107 = getelementptr inbounds [256 x i8], [256 x i8]* %str_exec_message, i32 0, i32 0, !dbg !1551
  call void @__dp_call(i32 33008), !dbg !1552
  %call108 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %61, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.34.108, i32 0, i32 0), i8* %arraydecay107), !dbg !1552
  %62 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33010, i64 %62, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %63 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1553
  %arraydecay109 = getelementptr inbounds [256 x i8], [256 x i8]* %str_architecture, i32 0, i32 0, !dbg !1554
  call void @__dp_call(i32 33010), !dbg !1555
  %call110 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %63, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.35.109, i32 0, i32 0), i8* %arraydecay109), !dbg !1555
  %64 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33011, i64 %64, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %65 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1556
  %arraydecay111 = getelementptr inbounds [256 x i8], [256 x i8]* %str_load_avg, i32 0, i32 0, !dbg !1557
  call void @__dp_call(i32 33011), !dbg !1558
  %call112 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %65, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.36.110, i32 0, i32 0), i8* %arraydecay111), !dbg !1558
  %66 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33013, i64 %66, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %67 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1559
  %arraydecay113 = getelementptr inbounds [256 x i8], [256 x i8]* %str_comp_date, i32 0, i32 0, !dbg !1560
  call void @__dp_call(i32 33013), !dbg !1561
  %call114 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %67, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.37.111, i32 0, i32 0), i8* %arraydecay113), !dbg !1561
  %68 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33014, i64 %68, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %69 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1562
  %arraydecay115 = getelementptr inbounds [256 x i8], [256 x i8]* %str_comp_message, i32 0, i32 0, !dbg !1563
  call void @__dp_call(i32 33014), !dbg !1564
  %call116 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %69, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.38.112, i32 0, i32 0), i8* %arraydecay115), !dbg !1564
  %70 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33016, i64 %70, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %71 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1565
  %arraydecay117 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cc, i32 0, i32 0, !dbg !1566
  call void @__dp_call(i32 33016), !dbg !1567
  %call118 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %71, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.39.113, i32 0, i32 0), i8* %arraydecay117), !dbg !1567
  %72 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33017, i64 %72, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %73 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1568
  %arraydecay119 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cflags, i32 0, i32 0, !dbg !1569
  call void @__dp_call(i32 33017), !dbg !1570
  %call120 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %73, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.40.114, i32 0, i32 0), i8* %arraydecay119), !dbg !1570
  %74 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33018, i64 %74, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %75 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1571
  %arraydecay121 = getelementptr inbounds [256 x i8], [256 x i8]* %str_ld, i32 0, i32 0, !dbg !1572
  call void @__dp_call(i32 33018), !dbg !1573
  %call122 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %75, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.41.115, i32 0, i32 0), i8* %arraydecay121), !dbg !1573
  %76 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33019, i64 %76, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %77 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1574
  %arraydecay123 = getelementptr inbounds [256 x i8], [256 x i8]* %str_ldflags, i32 0, i32 0, !dbg !1575
  call void @__dp_call(i32 33019), !dbg !1576
  %call124 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %77, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.42.116, i32 0, i32 0), i8* %arraydecay123), !dbg !1576
  %78 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33020, i64 %78, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %79 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1577
  call void @__dp_call(i32 33020), !dbg !1578
  %call125 = call i32 @fflush(%struct._IO_FILE* %79), !dbg !1578
  br label %sw.epilog204, !dbg !1579

sw.bb126:                                         ; preds = %if.end73
  %80 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33023, i64 %80, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %81 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1580
  %arraydecay127 = getelementptr inbounds [256 x i8], [256 x i8]* %str_name, i32 0, i32 0, !dbg !1581
  %arraydecay128 = getelementptr inbounds [256 x i8], [256 x i8]* %str_parameters, i32 0, i32 0, !dbg !1582
  %arraydecay129 = getelementptr inbounds [256 x i8], [256 x i8]* %str_model, i32 0, i32 0, !dbg !1583
  %arraydecay130 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cutoff, i32 0, i32 0, !dbg !1584
  %arraydecay131 = getelementptr inbounds [256 x i8], [256 x i8]* %str_resources, i32 0, i32 0, !dbg !1585
  %arraydecay132 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !1586
  call void @__dp_call(i32 33023), !dbg !1587
  %call133 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %81, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.43.117, i32 0, i32 0), i8* %arraydecay127, i8* %arraydecay128, i8* %arraydecay129, i8* %arraydecay130, i8* %arraydecay131, i8* %arraydecay132), !dbg !1587
  %82 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33031, i64 %82, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %83 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1588
  %arraydecay134 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_program, i32 0, i32 0, !dbg !1589
  %arraydecay135 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_sequential, i32 0, i32 0, !dbg !1590
  %arraydecay136 = getelementptr inbounds [15 x i8], [15 x i8]* %str_speed_up, i32 0, i32 0, !dbg !1591
  call void @__dp_call(i32 33031), !dbg !1592
  %call137 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %83, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.44.118, i32 0, i32 0), i8* %arraydecay134, i8* %arraydecay135, i8* %arraydecay136), !dbg !1592
  %84 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33036, i64 %84, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %85 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1593
  %arraydecay138 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks, i32 0, i32 0, !dbg !1594
  %arraydecay139 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks_per_second, i32 0, i32 0, !dbg !1595
  call void @__dp_call(i32 33036), !dbg !1596
  %call140 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %85, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.45.119, i32 0, i32 0), i8* %arraydecay138, i8* %arraydecay139), !dbg !1596
  %86 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33040, i64 %86, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %87 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1597
  %arraydecay141 = getelementptr inbounds [256 x i8], [256 x i8]* %str_exec_date, i32 0, i32 0, !dbg !1598
  %arraydecay142 = getelementptr inbounds [256 x i8], [256 x i8]* %str_exec_message, i32 0, i32 0, !dbg !1599
  call void @__dp_call(i32 33040), !dbg !1600
  %call143 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %87, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.45.119, i32 0, i32 0), i8* %arraydecay141, i8* %arraydecay142), !dbg !1600
  %88 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33044, i64 %88, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %89 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1601
  %arraydecay144 = getelementptr inbounds [256 x i8], [256 x i8]* %str_architecture, i32 0, i32 0, !dbg !1602
  %arraydecay145 = getelementptr inbounds [256 x i8], [256 x i8]* %str_load_avg, i32 0, i32 0, !dbg !1603
  call void @__dp_call(i32 33044), !dbg !1604
  %call146 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %89, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.45.119, i32 0, i32 0), i8* %arraydecay144, i8* %arraydecay145), !dbg !1604
  %90 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33048, i64 %90, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %91 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1605
  %arraydecay147 = getelementptr inbounds [256 x i8], [256 x i8]* %str_comp_date, i32 0, i32 0, !dbg !1606
  %arraydecay148 = getelementptr inbounds [256 x i8], [256 x i8]* %str_comp_message, i32 0, i32 0, !dbg !1607
  call void @__dp_call(i32 33048), !dbg !1608
  %call149 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %91, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.45.119, i32 0, i32 0), i8* %arraydecay147, i8* %arraydecay148), !dbg !1608
  %92 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33052, i64 %92, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %93 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1609
  %arraydecay150 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cc, i32 0, i32 0, !dbg !1610
  %arraydecay151 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cflags, i32 0, i32 0, !dbg !1611
  %arraydecay152 = getelementptr inbounds [256 x i8], [256 x i8]* %str_ld, i32 0, i32 0, !dbg !1612
  %arraydecay153 = getelementptr inbounds [256 x i8], [256 x i8]* %str_ldflags, i32 0, i32 0, !dbg !1613
  call void @__dp_call(i32 33052), !dbg !1614
  %call154 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %93, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.46.120, i32 0, i32 0), i8* %arraydecay150, i8* %arraydecay151, i8* %arraydecay152, i8* %arraydecay153), !dbg !1614
  %94 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33058, i64 %94, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %95 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1615
  call void @__dp_call(i32 33058), !dbg !1616
  %call155 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %95, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.21.95, i32 0, i32 0)), !dbg !1616
  br label %sw.epilog204, !dbg !1617

sw.bb156:                                         ; preds = %if.end73
  %96 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33061, i64 %96, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %97 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1618
  call void @__dp_call(i32 33061), !dbg !1619
  %call157 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %97, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.21.95, i32 0, i32 0)), !dbg !1619
  %98 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33062, i64 %98, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %99 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1620
  %arraydecay158 = getelementptr inbounds [256 x i8], [256 x i8]* %str_name, i32 0, i32 0, !dbg !1621
  call void @__dp_call(i32 33062), !dbg !1622
  %call159 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %99, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.22.96, i32 0, i32 0), i8* %arraydecay158), !dbg !1622
  %100 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33063, i64 %100, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %101 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1623
  %arraydecay160 = getelementptr inbounds [256 x i8], [256 x i8]* %str_parameters, i32 0, i32 0, !dbg !1624
  call void @__dp_call(i32 33063), !dbg !1625
  %call161 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %101, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.23.97, i32 0, i32 0), i8* %arraydecay160), !dbg !1625
  %102 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33064, i64 %102, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %103 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1626
  %arraydecay162 = getelementptr inbounds [256 x i8], [256 x i8]* %str_model, i32 0, i32 0, !dbg !1627
  call void @__dp_call(i32 33064), !dbg !1628
  %call163 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %103, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.24.98, i32 0, i32 0), i8* %arraydecay162), !dbg !1628
  %104 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33065, i64 %104, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %105 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1629
  %arraydecay164 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cutoff, i32 0, i32 0, !dbg !1630
  call void @__dp_call(i32 33065), !dbg !1631
  %call165 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %105, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.25.99, i32 0, i32 0), i8* %arraydecay164), !dbg !1631
  %106 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33066, i64 %106, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %107 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1632
  %arraydecay166 = getelementptr inbounds [256 x i8], [256 x i8]* %str_resources, i32 0, i32 0, !dbg !1633
  call void @__dp_call(i32 33066), !dbg !1634
  %call167 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %107, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.26.100, i32 0, i32 0), i8* %arraydecay166), !dbg !1634
  %108 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33067, i64 %108, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %109 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1635
  %arraydecay168 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !1636
  call void @__dp_call(i32 33067), !dbg !1637
  %call169 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %109, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.27.101, i32 0, i32 0), i8* %arraydecay168), !dbg !1637
  %110 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33069, i64 %110, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %111 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1638
  %arraydecay170 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_program, i32 0, i32 0, !dbg !1639
  call void @__dp_call(i32 33069), !dbg !1640
  %call171 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %111, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.28.102, i32 0, i32 0), i8* %arraydecay170), !dbg !1640
  %112 = ptrtoint i32* @bots_sequential_flag to i64
  call void @__dp_read(i32 33070, i64 %112, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.58.87, i32 0, i32 0))
  %113 = load i32, i32* @bots_sequential_flag, align 4, !dbg !1641
  %tobool172 = icmp ne i32 %113, 0, !dbg !1641
  br i1 %tobool172, label %if.then173, label %if.end178, !dbg !1643

if.then173:                                       ; preds = %sw.bb156
  %114 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33071, i64 %114, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %115 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1644
  %arraydecay174 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_sequential, i32 0, i32 0, !dbg !1646
  call void @__dp_call(i32 33071), !dbg !1647
  %call175 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %115, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.29.103, i32 0, i32 0), i8* %arraydecay174), !dbg !1647
  %116 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33072, i64 %116, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %117 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1648
  %arraydecay176 = getelementptr inbounds [15 x i8], [15 x i8]* %str_speed_up, i32 0, i32 0, !dbg !1649
  call void @__dp_call(i32 33072), !dbg !1650
  %call177 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %117, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.30.104, i32 0, i32 0), i8* %arraydecay176), !dbg !1650
  br label %if.end178, !dbg !1651

if.end178:                                        ; preds = %if.then173, %sw.bb156
  %118 = ptrtoint i64* @bots_number_of_tasks to i64
  call void @__dp_read(i32 33075, i64 %118, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.60.90, i32 0, i32 0))
  %119 = load i64, i64* @bots_number_of_tasks, align 8, !dbg !1652
  %cmp179 = icmp ugt i64 %119, 0, !dbg !1654
  br i1 %cmp179, label %if.then181, label %if.end186, !dbg !1655

if.then181:                                       ; preds = %if.end178
  %120 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33076, i64 %120, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %121 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1656
  %arraydecay182 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks, i32 0, i32 0, !dbg !1658
  call void @__dp_call(i32 33076), !dbg !1659
  %call183 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %121, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.31.105, i32 0, i32 0), i8* %arraydecay182), !dbg !1659
  %122 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33077, i64 %122, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %123 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1660
  %arraydecay184 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks_per_second, i32 0, i32 0, !dbg !1661
  call void @__dp_call(i32 33077), !dbg !1662
  %call185 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %123, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.32.106, i32 0, i32 0), i8* %arraydecay184), !dbg !1662
  br label %if.end186, !dbg !1663

if.end186:                                        ; preds = %if.then181, %if.end178
  br label %sw.epilog204, !dbg !1664

sw.bb187:                                         ; preds = %if.end73
  %124 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33081, i64 %124, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %125 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1665
  %arraydecay188 = getelementptr inbounds [256 x i8], [256 x i8]* %str_name, i32 0, i32 0, !dbg !1666
  %arraydecay189 = getelementptr inbounds [256 x i8], [256 x i8]* %str_parameters, i32 0, i32 0, !dbg !1667
  %arraydecay190 = getelementptr inbounds [256 x i8], [256 x i8]* %str_model, i32 0, i32 0, !dbg !1668
  %arraydecay191 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cutoff, i32 0, i32 0, !dbg !1669
  %arraydecay192 = getelementptr inbounds [256 x i8], [256 x i8]* %str_resources, i32 0, i32 0, !dbg !1670
  %arraydecay193 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !1671
  call void @__dp_call(i32 33081), !dbg !1672
  %call194 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %125, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.43.117, i32 0, i32 0), i8* %arraydecay188, i8* %arraydecay189, i8* %arraydecay190, i8* %arraydecay191, i8* %arraydecay192, i8* %arraydecay193), !dbg !1672
  %126 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33089, i64 %126, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %127 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1673
  %arraydecay195 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_program, i32 0, i32 0, !dbg !1674
  %arraydecay196 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_sequential, i32 0, i32 0, !dbg !1675
  %arraydecay197 = getelementptr inbounds [15 x i8], [15 x i8]* %str_speed_up, i32 0, i32 0, !dbg !1676
  call void @__dp_call(i32 33089), !dbg !1677
  %call198 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %127, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.44.118, i32 0, i32 0), i8* %arraydecay195, i8* %arraydecay196, i8* %arraydecay197), !dbg !1677
  %128 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33094, i64 %128, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %129 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1678
  %arraydecay199 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks, i32 0, i32 0, !dbg !1679
  %arraydecay200 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks_per_second, i32 0, i32 0, !dbg !1680
  call void @__dp_call(i32 33094), !dbg !1681
  %call201 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %129, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.45.119, i32 0, i32 0), i8* %arraydecay199, i8* %arraydecay200), !dbg !1681
  %130 = ptrtoint %struct._IO_FILE** @stdout to i64
  call void @__dp_read(i32 33098, i64 %130, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.63, i32 0, i32 0))
  %131 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !1682
  call void @__dp_call(i32 33098), !dbg !1683
  %call202 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %131, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.21.95, i32 0, i32 0)), !dbg !1683
  br label %sw.epilog204, !dbg !1684

sw.default203:                                    ; preds = %if.end73
  call void @__dp_call(i32 33101), !dbg !1685
  call void @bots_error(i32 0, i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.47.121, i32 0, i32 0)), !dbg !1685
  br label %sw.epilog204, !dbg !1686

sw.epilog204:                                     ; preds = %sw.default203, %sw.bb187, %if.end186, %sw.bb126, %if.end104, %sw.bb74
  call void @__dp_func_exit(i32 33104, i32 0), !dbg !1687
  ret void, !dbg !1687
}

; Function Attrs: nounwind
declare dso_local i32 @sprintf(i8*, i8*, ...) #4

declare dso_local i32 @fflush(%struct._IO_FILE*) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_print_usage() #0 !dbg !1688 {
entry:
  call void @__dp_func_entry(i32 82133, i32 0), !dbg !1689
  %0 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82133, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %1 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1689
  call void @__dp_call(i32 82133), !dbg !1690
  %call = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.175, i32 0, i32 0)), !dbg !1690
  %2 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82134, i64 %2, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %3 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1691
  call void @__dp_call(i32 82134), !dbg !1692
  %call1 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.1.176, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_execname, i32 0, i32 0)), !dbg !1692
  %4 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82135, i64 %4, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %5 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1693
  call void @__dp_call(i32 82135), !dbg !1694
  %call2 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.175, i32 0, i32 0)), !dbg !1694
  %6 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82136, i64 %6, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %7 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1695
  call void @__dp_call(i32 82136), !dbg !1696
  %call3 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %7, i8* getelementptr inbounds ([20 x i8], [20 x i8]* @.str.2.177, i32 0, i32 0)), !dbg !1696
  %8 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82141, i64 %8, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %9 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1697
  call void @__dp_call(i32 82141), !dbg !1698
  %call4 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %9, i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.3.178, i32 0, i32 0)), !dbg !1698
  %10 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82156, i64 %10, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %11 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1699
  call void @__dp_call(i32 82156), !dbg !1700
  %call5 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %11, i8* getelementptr inbounds ([58 x i8], [58 x i8]* @.str.4.179, i32 0, i32 0), i32 2048), !dbg !1700
  %12 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82159, i64 %12, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %13 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1701
  call void @__dp_call(i32 82159), !dbg !1702
  %call6 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %13, i8* getelementptr inbounds ([62 x i8], [62 x i8]* @.str.5.180, i32 0, i32 0), i32 2048), !dbg !1702
  %14 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82162, i64 %14, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %15 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1703
  call void @__dp_call(i32 82162), !dbg !1704
  %call7 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %15, i8* getelementptr inbounds ([62 x i8], [62 x i8]* @.str.6.181, i32 0, i32 0), i32 20), !dbg !1704
  %16 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82165, i64 %16, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %17 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1705
  call void @__dp_call(i32 82165), !dbg !1706
  %call8 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.175, i32 0, i32 0)), !dbg !1706
  %18 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82166, i64 %18, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %19 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1707
  call void @__dp_call(i32 82166), !dbg !1708
  %call9 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %19, i8* getelementptr inbounds ([49 x i8], [49 x i8]* @.str.7.182, i32 0, i32 0)), !dbg !1708
  %20 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82167, i64 %20, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %21 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1709
  call void @__dp_call(i32 82167), !dbg !1710
  %call10 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %21, i8* getelementptr inbounds ([49 x i8], [49 x i8]* @.str.8.183, i32 0, i32 0)), !dbg !1710
  %22 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82168, i64 %22, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %23 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1711
  call void @__dp_call(i32 82168), !dbg !1712
  %call11 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %23, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.9.184, i32 0, i32 0)), !dbg !1712
  %24 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82169, i64 %24, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %25 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1713
  call void @__dp_call(i32 82169), !dbg !1714
  %call12 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %25, i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str.10.185, i32 0, i32 0)), !dbg !1714
  %26 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82170, i64 %26, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %27 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1715
  call void @__dp_call(i32 82170), !dbg !1716
  %call13 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %27, i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.11.186, i32 0, i32 0)), !dbg !1716
  %28 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82171, i64 %28, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %29 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1717
  call void @__dp_call(i32 82171), !dbg !1718
  %call14 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %29, i8* getelementptr inbounds ([54 x i8], [54 x i8]* @.str.12.187, i32 0, i32 0)), !dbg !1718
  %30 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82172, i64 %30, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %31 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1719
  call void @__dp_call(i32 82172), !dbg !1720
  %call15 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %31, i8* getelementptr inbounds ([41 x i8], [41 x i8]* @.str.13.188, i32 0, i32 0)), !dbg !1720
  %32 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82173, i64 %32, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %33 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1721
  call void @__dp_call(i32 82173), !dbg !1722
  %call16 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %33, i8* getelementptr inbounds ([42 x i8], [42 x i8]* @.str.14.189, i32 0, i32 0)), !dbg !1722
  %34 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82174, i64 %34, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %35 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1723
  call void @__dp_call(i32 82174), !dbg !1724
  %call17 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %35, i8* getelementptr inbounds ([41 x i8], [41 x i8]* @.str.15.190, i32 0, i32 0)), !dbg !1724
  %36 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82175, i64 %36, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %37 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1725
  call void @__dp_call(i32 82175), !dbg !1726
  %call18 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %37, i8* getelementptr inbounds ([42 x i8], [42 x i8]* @.str.16.191, i32 0, i32 0)), !dbg !1726
  %38 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82176, i64 %38, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %39 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1727
  call void @__dp_call(i32 82176), !dbg !1728
  %call19 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %39, i8* getelementptr inbounds ([41 x i8], [41 x i8]* @.str.17.192, i32 0, i32 0)), !dbg !1728
  %40 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82177, i64 %40, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %41 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1729
  call void @__dp_call(i32 82177), !dbg !1730
  %call20 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %41, i8* getelementptr inbounds ([70 x i8], [70 x i8]* @.str.18.193, i32 0, i32 0)), !dbg !1730
  %42 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82178, i64 %42, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %43 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1731
  call void @__dp_call(i32 82178), !dbg !1732
  %call21 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %43, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.175, i32 0, i32 0)), !dbg !1732
  %44 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82185, i64 %44, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %45 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1733
  call void @__dp_call(i32 82185), !dbg !1734
  %call22 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %45, i8* getelementptr inbounds ([31 x i8], [31 x i8]* @.str.19.194, i32 0, i32 0)), !dbg !1734
  %46 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82187, i64 %46, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %47 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1735
  call void @__dp_call(i32 82187), !dbg !1736
  %call23 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %47, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.175, i32 0, i32 0)), !dbg !1736
  %48 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82188, i64 %48, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %49 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1737
  call void @__dp_call(i32 82188), !dbg !1738
  %call24 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %49, i8* getelementptr inbounds ([51 x i8], [51 x i8]* @.str.20.195, i32 0, i32 0)), !dbg !1738
  %50 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82189, i64 %50, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %51 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1739
  call void @__dp_call(i32 82189), !dbg !1740
  %call25 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %51, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.175, i32 0, i32 0)), !dbg !1740
  call void @__dp_func_exit(i32 82190, i32 0), !dbg !1741
  ret void, !dbg !1741
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_get_params_common(i32 %argc, i8** %argv) #0 !dbg !1742 {
entry:
  call void @__dp_func_entry(i32 82195, i32 0)
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %0 = ptrtoint i32* %argc.addr to i64
  call void @__dp_write(i32 82195, i64 %0, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.30.196, i32 0, i32 0))
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !1746, metadata !DIExpression()), !dbg !1747
  %1 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_write(i32 82195, i64 %1, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !1748, metadata !DIExpression()), !dbg !1749
  call void @llvm.dbg.declare(metadata i32* %i, metadata !1750, metadata !DIExpression()), !dbg !1751
  %2 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82198, i64 %2, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %3 = load i8**, i8*** %argv.addr, align 8, !dbg !1752
  %arrayidx = getelementptr inbounds i8*, i8** %3, i64 0, !dbg !1752
  %4 = ptrtoint i8** %arrayidx to i64
  call void @__dp_read(i32 82198, i64 %4, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %5 = load i8*, i8** %arrayidx, align 8, !dbg !1752
  call void @__dp_call(i32 82198), !dbg !1753
  %call = call i8* @__xpg_basename(i8* %5) #7, !dbg !1753
  call void @__dp_call(i32 82198), !dbg !1754
  %call1 = call i8* @strcpy(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_execname, i32 0, i32 0), i8* %call) #7, !dbg !1754
  call void @__dp_call(i32 82199), !dbg !1755
  call void @bots_get_date(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_exec_date, i32 0, i32 0)), !dbg !1755
  call void @__dp_call(i32 82200), !dbg !1756
  %call2 = call i8* @strcpy(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_exec_message, i32 0, i32 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.21.198, i32 0, i32 0)) #7, !dbg !1756
  %6 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 82201, i64 %6, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  store i32 1, i32* %i, align 4, !dbg !1757
  br label %for.cond, !dbg !1759

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 82201, i32 0)
  %7 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82201, i64 %7, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %8 = load i32, i32* %i, align 4, !dbg !1760
  %9 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 82201, i64 %9, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.30.196, i32 0, i32 0))
  %10 = load i32, i32* %argc.addr, align 4, !dbg !1762
  %cmp = icmp slt i32 %8, %10, !dbg !1763
  br i1 %cmp, label %for.body, label %for.end, !dbg !1764

for.body:                                         ; preds = %for.cond
  %11 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82203, i64 %11, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %12 = load i8**, i8*** %argv.addr, align 8, !dbg !1765
  %13 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82203, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %14 = load i32, i32* %i, align 4, !dbg !1768
  %idxprom = sext i32 %14 to i64, !dbg !1765
  %arrayidx3 = getelementptr inbounds i8*, i8** %12, i64 %idxprom, !dbg !1765
  %15 = ptrtoint i8** %arrayidx3 to i64
  call void @__dp_read(i32 82203, i64 %15, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %16 = load i8*, i8** %arrayidx3, align 8, !dbg !1765
  %arrayidx4 = getelementptr inbounds i8, i8* %16, i64 0, !dbg !1765
  %17 = ptrtoint i8* %arrayidx4 to i64
  call void @__dp_read(i32 82203, i64 %17, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %18 = load i8, i8* %arrayidx4, align 1, !dbg !1765
  %conv = sext i8 %18 to i32, !dbg !1765
  %cmp5 = icmp eq i32 %conv, 45, !dbg !1769
  br i1 %cmp5, label %if.then, label %if.else, !dbg !1770

if.then:                                          ; preds = %for.body
  %19 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82205, i64 %19, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %20 = load i8**, i8*** %argv.addr, align 8, !dbg !1771
  %21 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82205, i64 %21, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %22 = load i32, i32* %i, align 4, !dbg !1773
  %idxprom7 = sext i32 %22 to i64, !dbg !1771
  %arrayidx8 = getelementptr inbounds i8*, i8** %20, i64 %idxprom7, !dbg !1771
  %23 = ptrtoint i8** %arrayidx8 to i64
  call void @__dp_read(i32 82205, i64 %23, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %24 = load i8*, i8** %arrayidx8, align 8, !dbg !1771
  %arrayidx9 = getelementptr inbounds i8, i8* %24, i64 1, !dbg !1771
  %25 = ptrtoint i8* %arrayidx9 to i64
  call void @__dp_read(i32 82205, i64 %25, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %26 = load i8, i8* %arrayidx9, align 1, !dbg !1771
  %conv10 = sext i8 %26 to i32, !dbg !1771
  switch i32 %conv10, label %sw.default [
    i32 97, label %sw.bb
    i32 98, label %sw.bb20
    i32 99, label %sw.bb32
    i32 101, label %sw.bb36
    i32 104, label %sw.bb48
    i32 110, label %sw.bb52
    i32 111, label %sw.bb64
    i32 118, label %sw.bb76
    i32 121, label %sw.bb93
    i32 122, label %sw.bb105
  ], !dbg !1774

sw.bb:                                            ; preds = %if.then
  %27 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82209, i64 %27, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %28 = load i8**, i8*** %argv.addr, align 8, !dbg !1775
  %29 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82209, i64 %29, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %30 = load i32, i32* %i, align 4, !dbg !1777
  %idxprom11 = sext i32 %30 to i64, !dbg !1775
  %arrayidx12 = getelementptr inbounds i8*, i8** %28, i64 %idxprom11, !dbg !1775
  %31 = ptrtoint i8** %arrayidx12 to i64
  call void @__dp_read(i32 82209, i64 %31, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %32 = load i8*, i8** %arrayidx12, align 8, !dbg !1775
  %arrayidx13 = getelementptr inbounds i8, i8* %32, i64 1, !dbg !1775
  %33 = ptrtoint i8* %arrayidx13 to i64
  call void @__dp_write(i32 82209, i64 %33, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  store i8 42, i8* %arrayidx13, align 1, !dbg !1778
  %34 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82210, i64 %34, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %35 = load i32, i32* %i, align 4, !dbg !1779
  %inc = add nsw i32 %35, 1, !dbg !1779
  %36 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 82210, i64 %36, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !1779
  %37 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 82211, i64 %37, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.30.196, i32 0, i32 0))
  %38 = load i32, i32* %argc.addr, align 4, !dbg !1780
  %39 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82211, i64 %39, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %40 = load i32, i32* %i, align 4, !dbg !1782
  %cmp14 = icmp eq i32 %38, %40, !dbg !1783
  br i1 %cmp14, label %if.then16, label %if.end, !dbg !1784

if.then16:                                        ; preds = %sw.bb
  call void @__dp_call(i32 82211), !dbg !1785
  call void @bots_print_usage(), !dbg !1785
  call void @__dp_finalize(i32 82211), !dbg !1787
  call void @exit(i32 100) #8, !dbg !1787
  unreachable, !dbg !1787

if.end:                                           ; preds = %sw.bb
  %41 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82212, i64 %41, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %42 = load i8**, i8*** %argv.addr, align 8, !dbg !1788
  %43 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82212, i64 %43, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %44 = load i32, i32* %i, align 4, !dbg !1789
  %idxprom17 = sext i32 %44 to i64, !dbg !1788
  %arrayidx18 = getelementptr inbounds i8*, i8** %42, i64 %idxprom17, !dbg !1788
  %45 = ptrtoint i8** %arrayidx18 to i64
  call void @__dp_read(i32 82212, i64 %45, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %46 = load i8*, i8** %arrayidx18, align 8, !dbg !1788
  call void @__dp_call(i32 82212), !dbg !1790
  %call19 = call i32 @atoi(i8* %46) #9, !dbg !1790
  %47 = ptrtoint i32* @bots_app_cutoff_value_1 to i64
  call void @__dp_write(i32 82212, i64 %47, i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.33.200, i32 0, i32 0))
  store i32 %call19, i32* @bots_app_cutoff_value_1, align 4, !dbg !1791
  br label %sw.epilog, !dbg !1792

sw.bb20:                                          ; preds = %if.then
  %48 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82217, i64 %48, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %49 = load i8**, i8*** %argv.addr, align 8, !dbg !1793
  %50 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82217, i64 %50, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %51 = load i32, i32* %i, align 4, !dbg !1794
  %idxprom21 = sext i32 %51 to i64, !dbg !1793
  %arrayidx22 = getelementptr inbounds i8*, i8** %49, i64 %idxprom21, !dbg !1793
  %52 = ptrtoint i8** %arrayidx22 to i64
  call void @__dp_read(i32 82217, i64 %52, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %53 = load i8*, i8** %arrayidx22, align 8, !dbg !1793
  %arrayidx23 = getelementptr inbounds i8, i8* %53, i64 1, !dbg !1793
  %54 = ptrtoint i8* %arrayidx23 to i64
  call void @__dp_write(i32 82217, i64 %54, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  store i8 42, i8* %arrayidx23, align 1, !dbg !1795
  %55 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82218, i64 %55, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %56 = load i32, i32* %i, align 4, !dbg !1796
  %inc24 = add nsw i32 %56, 1, !dbg !1796
  %57 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 82218, i64 %57, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  store i32 %inc24, i32* %i, align 4, !dbg !1796
  %58 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 82219, i64 %58, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.30.196, i32 0, i32 0))
  %59 = load i32, i32* %argc.addr, align 4, !dbg !1797
  %60 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82219, i64 %60, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %61 = load i32, i32* %i, align 4, !dbg !1799
  %cmp25 = icmp eq i32 %59, %61, !dbg !1800
  br i1 %cmp25, label %if.then27, label %if.end28, !dbg !1801

if.then27:                                        ; preds = %sw.bb20
  call void @__dp_call(i32 82219), !dbg !1802
  call void @bots_print_usage(), !dbg !1802
  call void @__dp_finalize(i32 82219), !dbg !1804
  call void @exit(i32 100) #8, !dbg !1804
  unreachable, !dbg !1804

if.end28:                                         ; preds = %sw.bb20
  %62 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82220, i64 %62, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %63 = load i8**, i8*** %argv.addr, align 8, !dbg !1805
  %64 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82220, i64 %64, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %65 = load i32, i32* %i, align 4, !dbg !1806
  %idxprom29 = sext i32 %65 to i64, !dbg !1805
  %arrayidx30 = getelementptr inbounds i8*, i8** %63, i64 %idxprom29, !dbg !1805
  %66 = ptrtoint i8** %arrayidx30 to i64
  call void @__dp_read(i32 82220, i64 %66, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %67 = load i8*, i8** %arrayidx30, align 8, !dbg !1805
  call void @__dp_call(i32 82220), !dbg !1807
  %call31 = call i32 @atoi(i8* %67) #9, !dbg !1807
  %68 = ptrtoint i32* @bots_app_cutoff_value_2 to i64
  call void @__dp_write(i32 82220, i64 %68, i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.34.201, i32 0, i32 0))
  store i32 %call31, i32* @bots_app_cutoff_value_2, align 4, !dbg !1808
  br label %sw.epilog, !dbg !1809

sw.bb32:                                          ; preds = %if.then
  %69 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82224, i64 %69, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %70 = load i8**, i8*** %argv.addr, align 8, !dbg !1810
  %71 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82224, i64 %71, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %72 = load i32, i32* %i, align 4, !dbg !1811
  %idxprom33 = sext i32 %72 to i64, !dbg !1810
  %arrayidx34 = getelementptr inbounds i8*, i8** %70, i64 %idxprom33, !dbg !1810
  %73 = ptrtoint i8** %arrayidx34 to i64
  call void @__dp_read(i32 82224, i64 %73, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %74 = load i8*, i8** %arrayidx34, align 8, !dbg !1810
  %arrayidx35 = getelementptr inbounds i8, i8* %74, i64 1, !dbg !1810
  %75 = ptrtoint i8* %arrayidx35 to i64
  call void @__dp_write(i32 82224, i64 %75, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  store i8 42, i8* %arrayidx35, align 1, !dbg !1812
  %76 = ptrtoint i32* @bots_check_flag to i64
  call void @__dp_write(i32 82228, i64 %76, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.35.202, i32 0, i32 0))
  store i32 1, i32* @bots_check_flag, align 4, !dbg !1813
  br label %sw.epilog, !dbg !1814

sw.bb36:                                          ; preds = %if.then
  %77 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82231, i64 %77, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %78 = load i8**, i8*** %argv.addr, align 8, !dbg !1815
  %79 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82231, i64 %79, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %80 = load i32, i32* %i, align 4, !dbg !1816
  %idxprom37 = sext i32 %80 to i64, !dbg !1815
  %arrayidx38 = getelementptr inbounds i8*, i8** %78, i64 %idxprom37, !dbg !1815
  %81 = ptrtoint i8** %arrayidx38 to i64
  call void @__dp_read(i32 82231, i64 %81, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %82 = load i8*, i8** %arrayidx38, align 8, !dbg !1815
  %arrayidx39 = getelementptr inbounds i8, i8* %82, i64 1, !dbg !1815
  %83 = ptrtoint i8* %arrayidx39 to i64
  call void @__dp_write(i32 82231, i64 %83, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  store i8 42, i8* %arrayidx39, align 1, !dbg !1817
  %84 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82232, i64 %84, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %85 = load i32, i32* %i, align 4, !dbg !1818
  %inc40 = add nsw i32 %85, 1, !dbg !1818
  %86 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 82232, i64 %86, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  store i32 %inc40, i32* %i, align 4, !dbg !1818
  %87 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 82233, i64 %87, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.30.196, i32 0, i32 0))
  %88 = load i32, i32* %argc.addr, align 4, !dbg !1819
  %89 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82233, i64 %89, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %90 = load i32, i32* %i, align 4, !dbg !1821
  %cmp41 = icmp eq i32 %88, %90, !dbg !1822
  br i1 %cmp41, label %if.then43, label %if.end44, !dbg !1823

if.then43:                                        ; preds = %sw.bb36
  call void @__dp_call(i32 82233), !dbg !1824
  call void @bots_print_usage(), !dbg !1824
  call void @__dp_finalize(i32 82233), !dbg !1826
  call void @exit(i32 100) #8, !dbg !1826
  unreachable, !dbg !1826

if.end44:                                         ; preds = %sw.bb36
  %91 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82234, i64 %91, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %92 = load i8**, i8*** %argv.addr, align 8, !dbg !1827
  %93 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82234, i64 %93, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %94 = load i32, i32* %i, align 4, !dbg !1828
  %idxprom45 = sext i32 %94 to i64, !dbg !1827
  %arrayidx46 = getelementptr inbounds i8*, i8** %92, i64 %idxprom45, !dbg !1827
  %95 = ptrtoint i8** %arrayidx46 to i64
  call void @__dp_read(i32 82234, i64 %95, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %96 = load i8*, i8** %arrayidx46, align 8, !dbg !1827
  call void @__dp_call(i32 82234), !dbg !1829
  %call47 = call i8* @strcpy(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_exec_message, i32 0, i32 0), i8* %96) #7, !dbg !1829
  br label %sw.epilog, !dbg !1830

sw.bb48:                                          ; preds = %if.then
  %97 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82245, i64 %97, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %98 = load i8**, i8*** %argv.addr, align 8, !dbg !1831
  %99 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82245, i64 %99, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %100 = load i32, i32* %i, align 4, !dbg !1832
  %idxprom49 = sext i32 %100 to i64, !dbg !1831
  %arrayidx50 = getelementptr inbounds i8*, i8** %98, i64 %idxprom49, !dbg !1831
  %101 = ptrtoint i8** %arrayidx50 to i64
  call void @__dp_read(i32 82245, i64 %101, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %102 = load i8*, i8** %arrayidx50, align 8, !dbg !1831
  %arrayidx51 = getelementptr inbounds i8, i8* %102, i64 1, !dbg !1831
  %103 = ptrtoint i8* %arrayidx51 to i64
  call void @__dp_write(i32 82245, i64 %103, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  store i8 42, i8* %arrayidx51, align 1, !dbg !1833
  call void @__dp_call(i32 82246), !dbg !1834
  call void @bots_print_usage(), !dbg !1834
  call void @__dp_finalize(i32 82247), !dbg !1835
  call void @exit(i32 100) #8, !dbg !1835
  unreachable, !dbg !1835

sw.bb52:                                          ; preds = %if.then
  %104 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82266, i64 %104, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %105 = load i8**, i8*** %argv.addr, align 8, !dbg !1836
  %106 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82266, i64 %106, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %107 = load i32, i32* %i, align 4, !dbg !1837
  %idxprom53 = sext i32 %107 to i64, !dbg !1836
  %arrayidx54 = getelementptr inbounds i8*, i8** %105, i64 %idxprom53, !dbg !1836
  %108 = ptrtoint i8** %arrayidx54 to i64
  call void @__dp_read(i32 82266, i64 %108, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %109 = load i8*, i8** %arrayidx54, align 8, !dbg !1836
  %arrayidx55 = getelementptr inbounds i8, i8* %109, i64 1, !dbg !1836
  %110 = ptrtoint i8* %arrayidx55 to i64
  call void @__dp_write(i32 82266, i64 %110, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  store i8 42, i8* %arrayidx55, align 1, !dbg !1838
  %111 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82267, i64 %111, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %112 = load i32, i32* %i, align 4, !dbg !1839
  %inc56 = add nsw i32 %112, 1, !dbg !1839
  %113 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 82267, i64 %113, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  store i32 %inc56, i32* %i, align 4, !dbg !1839
  %114 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 82268, i64 %114, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.30.196, i32 0, i32 0))
  %115 = load i32, i32* %argc.addr, align 4, !dbg !1840
  %116 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82268, i64 %116, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %117 = load i32, i32* %i, align 4, !dbg !1842
  %cmp57 = icmp eq i32 %115, %117, !dbg !1843
  br i1 %cmp57, label %if.then59, label %if.end60, !dbg !1844

if.then59:                                        ; preds = %sw.bb52
  call void @__dp_call(i32 82268), !dbg !1845
  call void @bots_print_usage(), !dbg !1845
  call void @__dp_finalize(i32 82268), !dbg !1847
  call void @exit(i32 100) #8, !dbg !1847
  unreachable, !dbg !1847

if.end60:                                         ; preds = %sw.bb52
  %118 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82269, i64 %118, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %119 = load i8**, i8*** %argv.addr, align 8, !dbg !1848
  %120 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82269, i64 %120, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %121 = load i32, i32* %i, align 4, !dbg !1849
  %idxprom61 = sext i32 %121 to i64, !dbg !1848
  %arrayidx62 = getelementptr inbounds i8*, i8** %119, i64 %idxprom61, !dbg !1848
  %122 = ptrtoint i8** %arrayidx62 to i64
  call void @__dp_read(i32 82269, i64 %122, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %123 = load i8*, i8** %arrayidx62, align 8, !dbg !1848
  call void @__dp_call(i32 82269), !dbg !1850
  %call63 = call i32 @atoi(i8* %123) #9, !dbg !1850
  %124 = ptrtoint i32* @bots_arg_size to i64
  call void @__dp_write(i32 82269, i64 %124, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.36.203, i32 0, i32 0))
  store i32 %call63, i32* @bots_arg_size, align 4, !dbg !1851
  br label %sw.epilog, !dbg !1852

sw.bb64:                                          ; preds = %if.then
  %125 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82276, i64 %125, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %126 = load i8**, i8*** %argv.addr, align 8, !dbg !1853
  %127 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82276, i64 %127, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %128 = load i32, i32* %i, align 4, !dbg !1854
  %idxprom65 = sext i32 %128 to i64, !dbg !1853
  %arrayidx66 = getelementptr inbounds i8*, i8** %126, i64 %idxprom65, !dbg !1853
  %129 = ptrtoint i8** %arrayidx66 to i64
  call void @__dp_read(i32 82276, i64 %129, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %130 = load i8*, i8** %arrayidx66, align 8, !dbg !1853
  %arrayidx67 = getelementptr inbounds i8, i8* %130, i64 1, !dbg !1853
  %131 = ptrtoint i8* %arrayidx67 to i64
  call void @__dp_write(i32 82276, i64 %131, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  store i8 42, i8* %arrayidx67, align 1, !dbg !1855
  %132 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82277, i64 %132, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %133 = load i32, i32* %i, align 4, !dbg !1856
  %inc68 = add nsw i32 %133, 1, !dbg !1856
  %134 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 82277, i64 %134, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  store i32 %inc68, i32* %i, align 4, !dbg !1856
  %135 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 82278, i64 %135, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.30.196, i32 0, i32 0))
  %136 = load i32, i32* %argc.addr, align 4, !dbg !1857
  %137 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82278, i64 %137, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %138 = load i32, i32* %i, align 4, !dbg !1859
  %cmp69 = icmp eq i32 %136, %138, !dbg !1860
  br i1 %cmp69, label %if.then71, label %if.end72, !dbg !1861

if.then71:                                        ; preds = %sw.bb64
  call void @__dp_call(i32 82278), !dbg !1862
  call void @bots_print_usage(), !dbg !1862
  call void @__dp_finalize(i32 82278), !dbg !1864
  call void @exit(i32 100) #8, !dbg !1864
  unreachable, !dbg !1864

if.end72:                                         ; preds = %sw.bb64
  %139 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82279, i64 %139, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %140 = load i8**, i8*** %argv.addr, align 8, !dbg !1865
  %141 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82279, i64 %141, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %142 = load i32, i32* %i, align 4, !dbg !1866
  %idxprom73 = sext i32 %142 to i64, !dbg !1865
  %arrayidx74 = getelementptr inbounds i8*, i8** %140, i64 %idxprom73, !dbg !1865
  %143 = ptrtoint i8** %arrayidx74 to i64
  call void @__dp_read(i32 82279, i64 %143, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %144 = load i8*, i8** %arrayidx74, align 8, !dbg !1865
  call void @__dp_call(i32 82279), !dbg !1867
  %call75 = call i32 @atoi(i8* %144) #9, !dbg !1867
  %145 = ptrtoint i32* @bots_output_format to i64
  call void @__dp_write(i32 82279, i64 %145, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.37.204, i32 0, i32 0))
  store i32 %call75, i32* @bots_output_format, align 4, !dbg !1868
  br label %sw.epilog, !dbg !1869

sw.bb76:                                          ; preds = %if.then
  %146 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82299, i64 %146, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %147 = load i8**, i8*** %argv.addr, align 8, !dbg !1870
  %148 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82299, i64 %148, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %149 = load i32, i32* %i, align 4, !dbg !1871
  %idxprom77 = sext i32 %149 to i64, !dbg !1870
  %arrayidx78 = getelementptr inbounds i8*, i8** %147, i64 %idxprom77, !dbg !1870
  %150 = ptrtoint i8** %arrayidx78 to i64
  call void @__dp_read(i32 82299, i64 %150, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %151 = load i8*, i8** %arrayidx78, align 8, !dbg !1870
  %arrayidx79 = getelementptr inbounds i8, i8* %151, i64 1, !dbg !1870
  %152 = ptrtoint i8* %arrayidx79 to i64
  call void @__dp_write(i32 82299, i64 %152, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  store i8 42, i8* %arrayidx79, align 1, !dbg !1872
  %153 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82300, i64 %153, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %154 = load i32, i32* %i, align 4, !dbg !1873
  %inc80 = add nsw i32 %154, 1, !dbg !1873
  %155 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 82300, i64 %155, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  store i32 %inc80, i32* %i, align 4, !dbg !1873
  %156 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 82301, i64 %156, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.30.196, i32 0, i32 0))
  %157 = load i32, i32* %argc.addr, align 4, !dbg !1874
  %158 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82301, i64 %158, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %159 = load i32, i32* %i, align 4, !dbg !1876
  %cmp81 = icmp eq i32 %157, %159, !dbg !1877
  br i1 %cmp81, label %if.then83, label %if.end84, !dbg !1878

if.then83:                                        ; preds = %sw.bb76
  call void @__dp_call(i32 82301), !dbg !1879
  call void @bots_print_usage(), !dbg !1879
  call void @__dp_finalize(i32 82301), !dbg !1881
  call void @exit(i32 100) #8, !dbg !1881
  unreachable, !dbg !1881

if.end84:                                         ; preds = %sw.bb76
  %160 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82302, i64 %160, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %161 = load i8**, i8*** %argv.addr, align 8, !dbg !1882
  %162 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82302, i64 %162, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %163 = load i32, i32* %i, align 4, !dbg !1883
  %idxprom85 = sext i32 %163 to i64, !dbg !1882
  %arrayidx86 = getelementptr inbounds i8*, i8** %161, i64 %idxprom85, !dbg !1882
  %164 = ptrtoint i8** %arrayidx86 to i64
  call void @__dp_read(i32 82302, i64 %164, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %165 = load i8*, i8** %arrayidx86, align 8, !dbg !1882
  call void @__dp_call(i32 82302), !dbg !1884
  %call87 = call i32 @atoi(i8* %165) #9, !dbg !1884
  %166 = ptrtoint i32* @bots_verbose_mode to i64
  call void @__dp_write(i32 82302, i64 %166, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.38.205, i32 0, i32 0))
  store i32 %call87, i32* @bots_verbose_mode, align 4, !dbg !1885
  %167 = ptrtoint i32* @bots_verbose_mode to i64
  call void @__dp_read(i32 82304, i64 %167, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.38.205, i32 0, i32 0))
  %168 = load i32, i32* @bots_verbose_mode, align 4, !dbg !1886
  %cmp88 = icmp ugt i32 %168, 1, !dbg !1888
  br i1 %cmp88, label %if.then90, label %if.end92, !dbg !1889

if.then90:                                        ; preds = %if.end84
  %169 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82305, i64 %169, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %170 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1890
  call void @__dp_call(i32 82305), !dbg !1892
  %call91 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %170, i8* getelementptr inbounds ([100 x i8], [100 x i8]* @.str.22.206, i32 0, i32 0)), !dbg !1892
  call void @__dp_finalize(i32 82306), !dbg !1893
  call void @exit(i32 100) #8, !dbg !1893
  unreachable, !dbg !1893

if.end92:                                         ; preds = %if.end84
  br label %sw.epilog, !dbg !1894

sw.bb93:                                          ; preds = %if.then
  %171 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82320, i64 %171, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %172 = load i8**, i8*** %argv.addr, align 8, !dbg !1895
  %173 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82320, i64 %173, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %174 = load i32, i32* %i, align 4, !dbg !1896
  %idxprom94 = sext i32 %174 to i64, !dbg !1895
  %arrayidx95 = getelementptr inbounds i8*, i8** %172, i64 %idxprom94, !dbg !1895
  %175 = ptrtoint i8** %arrayidx95 to i64
  call void @__dp_read(i32 82320, i64 %175, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %176 = load i8*, i8** %arrayidx95, align 8, !dbg !1895
  %arrayidx96 = getelementptr inbounds i8, i8* %176, i64 1, !dbg !1895
  %177 = ptrtoint i8* %arrayidx96 to i64
  call void @__dp_write(i32 82320, i64 %177, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  store i8 42, i8* %arrayidx96, align 1, !dbg !1897
  %178 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82321, i64 %178, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %179 = load i32, i32* %i, align 4, !dbg !1898
  %inc97 = add nsw i32 %179, 1, !dbg !1898
  %180 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 82321, i64 %180, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  store i32 %inc97, i32* %i, align 4, !dbg !1898
  %181 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 82322, i64 %181, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.30.196, i32 0, i32 0))
  %182 = load i32, i32* %argc.addr, align 4, !dbg !1899
  %183 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82322, i64 %183, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %184 = load i32, i32* %i, align 4, !dbg !1901
  %cmp98 = icmp eq i32 %182, %184, !dbg !1902
  br i1 %cmp98, label %if.then100, label %if.end101, !dbg !1903

if.then100:                                       ; preds = %sw.bb93
  call void @__dp_call(i32 82322), !dbg !1904
  call void @bots_print_usage(), !dbg !1904
  call void @__dp_finalize(i32 82322), !dbg !1906
  call void @exit(i32 100) #8, !dbg !1906
  unreachable, !dbg !1906

if.end101:                                        ; preds = %sw.bb93
  %185 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82323, i64 %185, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %186 = load i8**, i8*** %argv.addr, align 8, !dbg !1907
  %187 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82323, i64 %187, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %188 = load i32, i32* %i, align 4, !dbg !1908
  %idxprom102 = sext i32 %188 to i64, !dbg !1907
  %arrayidx103 = getelementptr inbounds i8*, i8** %186, i64 %idxprom102, !dbg !1907
  %189 = ptrtoint i8** %arrayidx103 to i64
  call void @__dp_read(i32 82323, i64 %189, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %190 = load i8*, i8** %arrayidx103, align 8, !dbg !1907
  call void @__dp_call(i32 82323), !dbg !1909
  %call104 = call i32 @atoi(i8* %190) #9, !dbg !1909
  %191 = ptrtoint i32* @bots_app_cutoff_value to i64
  call void @__dp_write(i32 82323, i64 %191, i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.39.207, i32 0, i32 0))
  store i32 %call104, i32* @bots_app_cutoff_value, align 4, !dbg !1910
  br label %sw.epilog, !dbg !1911

sw.bb105:                                         ; preds = %if.then
  %192 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82327, i64 %192, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %193 = load i8**, i8*** %argv.addr, align 8, !dbg !1912
  %194 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82327, i64 %194, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %195 = load i32, i32* %i, align 4, !dbg !1913
  %idxprom106 = sext i32 %195 to i64, !dbg !1912
  %arrayidx107 = getelementptr inbounds i8*, i8** %193, i64 %idxprom106, !dbg !1912
  %196 = ptrtoint i8** %arrayidx107 to i64
  call void @__dp_read(i32 82327, i64 %196, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %197 = load i8*, i8** %arrayidx107, align 8, !dbg !1912
  %arrayidx108 = getelementptr inbounds i8, i8* %197, i64 1, !dbg !1912
  %198 = ptrtoint i8* %arrayidx108 to i64
  call void @__dp_write(i32 82327, i64 %198, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  store i8 42, i8* %arrayidx108, align 1, !dbg !1914
  %199 = ptrtoint i32* @bots_print_header to i64
  call void @__dp_write(i32 82328, i64 %199, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.40.208, i32 0, i32 0))
  store i32 1, i32* @bots_print_header, align 4, !dbg !1915
  br label %sw.epilog, !dbg !1916

sw.default:                                       ; preds = %if.then
  %200 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82335, i64 %200, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %201 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1917
  call void @__dp_call(i32 82335), !dbg !1918
  %call109 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %201, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.23.209, i32 0, i32 0)), !dbg !1918
  call void @__dp_call(i32 82336), !dbg !1919
  call void @bots_print_usage(), !dbg !1919
  call void @__dp_finalize(i32 82337), !dbg !1920
  call void @exit(i32 100) #8, !dbg !1920
  unreachable, !dbg !1920

sw.epilog:                                        ; preds = %sw.bb105, %if.end101, %if.end92, %if.end72, %if.end60, %if.end44, %sw.bb32, %if.end28, %if.end
  br label %if.end111, !dbg !1921

if.else:                                          ; preds = %for.body
  %202 = ptrtoint %struct._IO_FILE** @stderr to i64
  call void @__dp_read(i32 82346, i64 %202, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.29.174, i32 0, i32 0))
  %203 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !1922
  call void @__dp_call(i32 82346), !dbg !1924
  %call110 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %203, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.23.209, i32 0, i32 0)), !dbg !1924
  call void @__dp_call(i32 82347), !dbg !1925
  call void @bots_print_usage(), !dbg !1925
  call void @__dp_finalize(i32 82348), !dbg !1926
  call void @exit(i32 100) #8, !dbg !1926
  unreachable, !dbg !1926

if.end111:                                        ; preds = %sw.epilog
  br label %for.inc, !dbg !1927

for.inc:                                          ; preds = %if.end111
  %204 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 82201, i64 %204, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  %205 = load i32, i32* %i, align 4, !dbg !1928
  %inc112 = add nsw i32 %205, 1, !dbg !1928
  %206 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 82201, i64 %206, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.32.199, i32 0, i32 0))
  store i32 %inc112, i32* %i, align 4, !dbg !1928
  br label %for.cond, !dbg !1929, !llvm.loop !1930

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 82351, i32 0)
  call void @__dp_func_exit(i32 82351, i32 0), !dbg !1932
  ret void, !dbg !1932
}

; Function Attrs: nounwind
declare dso_local i8* @__xpg_basename(i8*) #4

; Function Attrs: nounwind
declare dso_local i8* @strcpy(i8*, i8*) #4

; Function Attrs: nounwind readonly
declare dso_local i32 @atoi(i8*) #6

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_get_params(i32 %argc, i8** %argv) #0 !dbg !1933 {
entry:
  call void @__dp_func_entry(i32 82356, i32 0)
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %0 = ptrtoint i32* %argc.addr to i64
  call void @__dp_write(i32 82356, i64 %0, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.30.196, i32 0, i32 0))
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !1934, metadata !DIExpression()), !dbg !1935
  %1 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_write(i32 82356, i64 %1, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !1936, metadata !DIExpression()), !dbg !1937
  %2 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 82358, i64 %2, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.30.196, i32 0, i32 0))
  %3 = load i32, i32* %argc.addr, align 4, !dbg !1938
  %4 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82358, i64 %4, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %5 = load i8**, i8*** %argv.addr, align 8, !dbg !1939
  call void @__dp_call(i32 82358), !dbg !1940
  call void @bots_get_params_common(i32 %3, i8** %5), !dbg !1940
  call void @__dp_func_exit(i32 82360, i32 0), !dbg !1941
  ret void, !dbg !1941
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_set_info() #0 !dbg !1942 {
entry:
  call void @__dp_func_entry(i32 82369, i32 0), !dbg !1943
  call void @__dp_call(i32 82369), !dbg !1943
  %call = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_name, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.24.210, i32 0, i32 0)) #7, !dbg !1943
  %0 = ptrtoint i32* @bots_arg_size to i64
  call void @__dp_read(i32 82370, i64 %0, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.36.203, i32 0, i32 0))
  %1 = load i32, i32* @bots_arg_size, align 4, !dbg !1944
  %2 = ptrtoint i32* @bots_app_cutoff_value_1 to i64
  call void @__dp_read(i32 82370, i64 %2, i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.33.200, i32 0, i32 0))
  %3 = load i32, i32* @bots_app_cutoff_value_1, align 4, !dbg !1944
  %4 = ptrtoint i32* @bots_app_cutoff_value_2 to i64
  call void @__dp_read(i32 82370, i64 %4, i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.34.201, i32 0, i32 0))
  %5 = load i32, i32* @bots_app_cutoff_value_2, align 4, !dbg !1944
  %6 = ptrtoint i32* @bots_app_cutoff_value to i64
  call void @__dp_read(i32 82370, i64 %6, i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.39.207, i32 0, i32 0))
  %7 = load i32, i32* @bots_app_cutoff_value, align 4, !dbg !1944
  call void @__dp_call(i32 82370), !dbg !1945
  %call1 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_parameters, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([20 x i8], [20 x i8]* @.str.25.211, i32 0, i32 0), i32 %1, i32 %3, i32 %5, i32 %7) #7, !dbg !1945
  call void @__dp_call(i32 82371), !dbg !1946
  %call2 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_model, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26.212, i32 0, i32 0)) #7, !dbg !1946
  call void @__dp_call(i32 82372), !dbg !1947
  %call3 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_resources, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.27.213, i32 0, i32 0), i32 1) #7, !dbg !1947
  call void @__dp_call(i32 82375), !dbg !1948
  %call4 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_comp_date, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.21.198, i32 0, i32 0)) #7, !dbg !1948
  call void @__dp_call(i32 82376), !dbg !1949
  %call5 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_comp_message, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.21.198, i32 0, i32 0)) #7, !dbg !1949
  call void @__dp_call(i32 82377), !dbg !1950
  %call6 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_cc, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.21.198, i32 0, i32 0)) #7, !dbg !1950
  call void @__dp_call(i32 82378), !dbg !1951
  %call7 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_cflags, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.21.198, i32 0, i32 0)) #7, !dbg !1951
  call void @__dp_call(i32 82379), !dbg !1952
  %call8 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_ld, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.21.198, i32 0, i32 0)) #7, !dbg !1952
  call void @__dp_call(i32 82380), !dbg !1953
  %call9 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_ldflags, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.21.198, i32 0, i32 0)) #7, !dbg !1953
  call void @__dp_call(i32 82389), !dbg !1954
  %call10 = call i8* @strcpy(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_cutoff, i32 0, i32 0), i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.28.214, i32 0, i32 0)) #7, !dbg !1954
  call void @__dp_func_exit(i32 82391, i32 0), !dbg !1955
  ret void, !dbg !1955
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !1956 {
entry:
  call void @__dp_func_entry(i32 82397, i32 1)
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %bots_t_start = alloca i64, align 8
  %bots_t_end = alloca i64, align 8
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 82397, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.41.215, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  %1 = ptrtoint i32* %argc.addr to i64
  call void @__dp_write(i32 82397, i64 %1, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.30.196, i32 0, i32 0))
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !1959, metadata !DIExpression()), !dbg !1960
  %2 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_write(i32 82397, i64 %2, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !1961, metadata !DIExpression()), !dbg !1962
  call void @llvm.dbg.declare(metadata i64* %bots_t_start, metadata !1963, metadata !DIExpression()), !dbg !1964
  call void @llvm.dbg.declare(metadata i64* %bots_t_end, metadata !1965, metadata !DIExpression()), !dbg !1966
  %3 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 82404, i64 %3, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.30.196, i32 0, i32 0))
  %4 = load i32, i32* %argc.addr, align 4, !dbg !1967
  %5 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 82404, i64 %5, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.31.197, i32 0, i32 0))
  %6 = load i8**, i8*** %argv.addr, align 8, !dbg !1968
  call void @__dp_call(i32 82404), !dbg !1969
  call void @bots_get_params(i32 %4, i8** %6), !dbg !1969
  call void @__dp_call(i32 82405), !dbg !1970
  call void @sort_init(), !dbg !1970
  call void @__dp_call(i32 82406), !dbg !1971
  call void @bots_set_info(), !dbg !1971
  call void @__dp_call(i32 82433), !dbg !1972
  %call = call i64 (...) bitcast (i64 ()* @bots_usecs to i64 (...)*)(), !dbg !1972
  %7 = ptrtoint i64* %bots_t_start to i64
  call void @__dp_write(i32 82433, i64 %7, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.42.216, i32 0, i32 0))
  store i64 %call, i64* %bots_t_start, align 8, !dbg !1973
  call void @__dp_call(i32 82434), !dbg !1974
  call void @sort(), !dbg !1974
  call void @__dp_call(i32 82435), !dbg !1975
  %call1 = call i64 (...) bitcast (i64 ()* @bots_usecs to i64 (...)*)(), !dbg !1975
  %8 = ptrtoint i64* %bots_t_end to i64
  call void @__dp_write(i32 82435, i64 %8, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.43.217, i32 0, i32 0))
  store i64 %call1, i64* %bots_t_end, align 8, !dbg !1976
  %9 = ptrtoint i64* %bots_t_end to i64
  call void @__dp_read(i32 82436, i64 %9, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.43.217, i32 0, i32 0))
  %10 = load i64, i64* %bots_t_end, align 8, !dbg !1977
  %11 = ptrtoint i64* %bots_t_start to i64
  call void @__dp_read(i32 82436, i64 %11, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.42.216, i32 0, i32 0))
  %12 = load i64, i64* %bots_t_start, align 8, !dbg !1978
  %sub = sub nsw i64 %10, %12, !dbg !1979
  %conv = sitofp i64 %sub to double, !dbg !1980
  %div = fdiv double %conv, 1.000000e+06, !dbg !1981
  %13 = ptrtoint double* @bots_time_program to i64
  call void @__dp_write(i32 82436, i64 %13, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.44.218, i32 0, i32 0))
  store double %div, double* @bots_time_program, align 8, !dbg !1982
  %14 = ptrtoint i32* @bots_check_flag to i64
  call void @__dp_read(i32 82441, i64 %14, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.35.202, i32 0, i32 0))
  %15 = load i32, i32* @bots_check_flag, align 4, !dbg !1983
  %tobool = icmp ne i32 %15, 0, !dbg !1983
  br i1 %tobool, label %if.then, label %if.end, !dbg !1985

if.then:                                          ; preds = %entry
  call void @__dp_call(i32 82442), !dbg !1986
  %call2 = call i32 @sort_verify(), !dbg !1986
  %16 = ptrtoint i32* @bots_result to i64
  call void @__dp_write(i32 82442, i64 %16, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.45.219, i32 0, i32 0))
  store i32 %call2, i32* @bots_result, align 4, !dbg !1988
  br label %if.end, !dbg !1989

if.end:                                           ; preds = %if.then, %entry
  call void @__dp_call(i32 82448), !dbg !1990
  call void @bots_print_results(), !dbg !1990
  call void @__dp_finalize(i32 82449), !dbg !1991
  ret i32 0, !dbg !1991
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { argmemonly nounwind }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { nounwind }
attributes #8 = { noreturn nounwind }
attributes #9 = { nounwind readonly }

!llvm.dbg.cu = !{!2, !89, !25}
!llvm.ident = !{!313, !313, !313}
!llvm.module.flags = !{!314, !315, !316}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "array", scope: !2, file: !3, line: 387, type: !13, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 8.0.1-9 (tags/RELEASE_801/final)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !12, globals: !17, nameTableKind: None)
!3 = !DIFile(filename: "sort.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/sort")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 76, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "./bots.h", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/sort")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11}
!9 = !DIEnumerator(name: "BOTS_VERBOSE_NONE", value: 0, isUnsigned: true)
!10 = !DIEnumerator(name: "BOTS_VERBOSE_DEFAULT", value: 1, isUnsigned: true)
!11 = !DIEnumerator(name: "BOTS_VERBOSE_DEBUG", value: 2, isUnsigned: true)
!12 = !{!13}
!13 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!14 = !DIDerivedType(tag: DW_TAG_typedef, name: "ELM", file: !15, line: 43, baseType: !16)
!15 = !DIFile(filename: "./app-desc.h", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/sort")
!16 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!17 = !{!0, !18, !20}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "tmp", scope: !2, file: !3, line: 387, type: !13, isLocal: false, isDefinition: true)
!20 = !DIGlobalVariableExpression(var: !21, expr: !DIExpression())
!21 = distinct !DIGlobalVariable(name: "rand_nxt", scope: !2, file: !3, line: 70, type: !22, isLocal: true, isDefinition: true)
!22 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(name: "bots_sequential_flag", scope: !25, file: !26, line: 41, type: !33, isLocal: false, isDefinition: true)
!25 = distinct !DICompileUnit(language: DW_LANG_C99, file: !26, producer: "clang version 8.0.1-9 (tags/RELEASE_801/final)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !27, globals: !30, nameTableKind: None)
!26 = !DIFile(filename: "bots_main.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/sort")
!27 = !{!28, !29}
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "bots_verbose_mode_t", file: !6, line: 78, baseType: !5)
!29 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!30 = !{!23, !31, !34, !36, !38, !40, !42, !44, !46, !49, !51, !53, !55, !57, !63, !65, !67, !69, !71, !73, !75, !77, !79, !81, !83, !85, !87}
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(name: "bots_check_flag", scope: !25, file: !26, line: 42, type: !33, isLocal: false, isDefinition: true)
!33 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(name: "bots_verbose_mode", scope: !25, file: !26, line: 43, type: !28, isLocal: false, isDefinition: true)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(name: "bots_result", scope: !25, file: !26, line: 44, type: !33, isLocal: false, isDefinition: true)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(name: "bots_output_format", scope: !25, file: !26, line: 45, type: !33, isLocal: false, isDefinition: true)
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(name: "bots_print_header", scope: !25, file: !26, line: 46, type: !33, isLocal: false, isDefinition: true)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(name: "bots_time_program", scope: !25, file: !26, line: 65, type: !29, isLocal: false, isDefinition: true)
!44 = !DIGlobalVariableExpression(var: !45, expr: !DIExpression())
!45 = distinct !DIGlobalVariable(name: "bots_time_sequential", scope: !25, file: !26, line: 66, type: !29, isLocal: false, isDefinition: true)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(name: "bots_number_of_tasks", scope: !25, file: !26, line: 67, type: !48, isLocal: false, isDefinition: true)
!48 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!49 = !DIGlobalVariableExpression(var: !50, expr: !DIExpression())
!50 = distinct !DIGlobalVariable(name: "bots_arg_size", scope: !25, file: !26, line: 124, type: !33, isLocal: false, isDefinition: true)
!51 = !DIGlobalVariableExpression(var: !52, expr: !DIExpression())
!52 = distinct !DIGlobalVariable(name: "bots_app_cutoff_value", scope: !25, file: !26, line: 181, type: !33, isLocal: false, isDefinition: true)
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "bots_app_cutoff_value_1", scope: !25, file: !26, line: 191, type: !33, isLocal: false, isDefinition: true)
!55 = !DIGlobalVariableExpression(var: !56, expr: !DIExpression())
!56 = distinct !DIGlobalVariable(name: "bots_app_cutoff_value_2", scope: !25, file: !26, line: 201, type: !33, isLocal: false, isDefinition: true)
!57 = !DIGlobalVariableExpression(var: !58, expr: !DIExpression())
!58 = distinct !DIGlobalVariable(name: "bots_name", scope: !25, file: !26, line: 48, type: !59, isLocal: false, isDefinition: true)
!59 = !DICompositeType(tag: DW_TAG_array_type, baseType: !60, size: 2048, elements: !61)
!60 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!61 = !{!62}
!62 = !DISubrange(count: 256)
!63 = !DIGlobalVariableExpression(var: !64, expr: !DIExpression())
!64 = distinct !DIGlobalVariable(name: "bots_execname", scope: !25, file: !26, line: 49, type: !59, isLocal: false, isDefinition: true)
!65 = !DIGlobalVariableExpression(var: !66, expr: !DIExpression())
!66 = distinct !DIGlobalVariable(name: "bots_parameters", scope: !25, file: !26, line: 50, type: !59, isLocal: false, isDefinition: true)
!67 = !DIGlobalVariableExpression(var: !68, expr: !DIExpression())
!68 = distinct !DIGlobalVariable(name: "bots_model", scope: !25, file: !26, line: 51, type: !59, isLocal: false, isDefinition: true)
!69 = !DIGlobalVariableExpression(var: !70, expr: !DIExpression())
!70 = distinct !DIGlobalVariable(name: "bots_resources", scope: !25, file: !26, line: 52, type: !59, isLocal: false, isDefinition: true)
!71 = !DIGlobalVariableExpression(var: !72, expr: !DIExpression())
!72 = distinct !DIGlobalVariable(name: "bots_exec_date", scope: !25, file: !26, line: 54, type: !59, isLocal: false, isDefinition: true)
!73 = !DIGlobalVariableExpression(var: !74, expr: !DIExpression())
!74 = distinct !DIGlobalVariable(name: "bots_exec_message", scope: !25, file: !26, line: 55, type: !59, isLocal: false, isDefinition: true)
!75 = !DIGlobalVariableExpression(var: !76, expr: !DIExpression())
!76 = distinct !DIGlobalVariable(name: "bots_comp_date", scope: !25, file: !26, line: 56, type: !59, isLocal: false, isDefinition: true)
!77 = !DIGlobalVariableExpression(var: !78, expr: !DIExpression())
!78 = distinct !DIGlobalVariable(name: "bots_comp_message", scope: !25, file: !26, line: 57, type: !59, isLocal: false, isDefinition: true)
!79 = !DIGlobalVariableExpression(var: !80, expr: !DIExpression())
!80 = distinct !DIGlobalVariable(name: "bots_cc", scope: !25, file: !26, line: 58, type: !59, isLocal: false, isDefinition: true)
!81 = !DIGlobalVariableExpression(var: !82, expr: !DIExpression())
!82 = distinct !DIGlobalVariable(name: "bots_cflags", scope: !25, file: !26, line: 59, type: !59, isLocal: false, isDefinition: true)
!83 = !DIGlobalVariableExpression(var: !84, expr: !DIExpression())
!84 = distinct !DIGlobalVariable(name: "bots_ld", scope: !25, file: !26, line: 60, type: !59, isLocal: false, isDefinition: true)
!85 = !DIGlobalVariableExpression(var: !86, expr: !DIExpression())
!86 = distinct !DIGlobalVariable(name: "bots_ldflags", scope: !25, file: !26, line: 61, type: !59, isLocal: false, isDefinition: true)
!87 = !DIGlobalVariableExpression(var: !88, expr: !DIExpression())
!88 = distinct !DIGlobalVariable(name: "bots_cutoff", scope: !25, file: !26, line: 62, type: !59, isLocal: false, isDefinition: true)
!89 = distinct !DICompileUnit(language: DW_LANG_C99, file: !90, producer: "clang version 8.0.1-9 (tags/RELEASE_801/final)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !91, retainedTypes: !310, nameTableKind: None)
!90 = !DIFile(filename: "bots_common.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/sort")
!91 = !{!92}
!92 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !93, line: 71, baseType: !7, size: 32, elements: !94)
!93 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/confname.h", directory: "")
!94 = !{!95, !96, !97, !98, !99, !100, !101, !102, !103, !104, !105, !106, !107, !108, !109, !110, !111, !112, !113, !114, !115, !116, !117, !118, !119, !120, !121, !122, !123, !124, !125, !126, !127, !128, !129, !130, !131, !132, !133, !134, !135, !136, !137, !138, !139, !140, !141, !142, !143, !144, !145, !146, !147, !148, !149, !150, !151, !152, !153, !154, !155, !156, !157, !158, !159, !160, !161, !162, !163, !164, !165, !166, !167, !168, !169, !170, !171, !172, !173, !174, !175, !176, !177, !178, !179, !180, !181, !182, !183, !184, !185, !186, !187, !188, !189, !190, !191, !192, !193, !194, !195, !196, !197, !198, !199, !200, !201, !202, !203, !204, !205, !206, !207, !208, !209, !210, !211, !212, !213, !214, !215, !216, !217, !218, !219, !220, !221, !222, !223, !224, !225, !226, !227, !228, !229, !230, !231, !232, !233, !234, !235, !236, !237, !238, !239, !240, !241, !242, !243, !244, !245, !246, !247, !248, !249, !250, !251, !252, !253, !254, !255, !256, !257, !258, !259, !260, !261, !262, !263, !264, !265, !266, !267, !268, !269, !270, !271, !272, !273, !274, !275, !276, !277, !278, !279, !280, !281, !282, !283, !284, !285, !286, !287, !288, !289, !290, !291, !292, !293, !294, !295, !296, !297, !298, !299, !300, !301, !302, !303, !304, !305, !306, !307, !308, !309}
!95 = !DIEnumerator(name: "_SC_ARG_MAX", value: 0, isUnsigned: true)
!96 = !DIEnumerator(name: "_SC_CHILD_MAX", value: 1, isUnsigned: true)
!97 = !DIEnumerator(name: "_SC_CLK_TCK", value: 2, isUnsigned: true)
!98 = !DIEnumerator(name: "_SC_NGROUPS_MAX", value: 3, isUnsigned: true)
!99 = !DIEnumerator(name: "_SC_OPEN_MAX", value: 4, isUnsigned: true)
!100 = !DIEnumerator(name: "_SC_STREAM_MAX", value: 5, isUnsigned: true)
!101 = !DIEnumerator(name: "_SC_TZNAME_MAX", value: 6, isUnsigned: true)
!102 = !DIEnumerator(name: "_SC_JOB_CONTROL", value: 7, isUnsigned: true)
!103 = !DIEnumerator(name: "_SC_SAVED_IDS", value: 8, isUnsigned: true)
!104 = !DIEnumerator(name: "_SC_REALTIME_SIGNALS", value: 9, isUnsigned: true)
!105 = !DIEnumerator(name: "_SC_PRIORITY_SCHEDULING", value: 10, isUnsigned: true)
!106 = !DIEnumerator(name: "_SC_TIMERS", value: 11, isUnsigned: true)
!107 = !DIEnumerator(name: "_SC_ASYNCHRONOUS_IO", value: 12, isUnsigned: true)
!108 = !DIEnumerator(name: "_SC_PRIORITIZED_IO", value: 13, isUnsigned: true)
!109 = !DIEnumerator(name: "_SC_SYNCHRONIZED_IO", value: 14, isUnsigned: true)
!110 = !DIEnumerator(name: "_SC_FSYNC", value: 15, isUnsigned: true)
!111 = !DIEnumerator(name: "_SC_MAPPED_FILES", value: 16, isUnsigned: true)
!112 = !DIEnumerator(name: "_SC_MEMLOCK", value: 17, isUnsigned: true)
!113 = !DIEnumerator(name: "_SC_MEMLOCK_RANGE", value: 18, isUnsigned: true)
!114 = !DIEnumerator(name: "_SC_MEMORY_PROTECTION", value: 19, isUnsigned: true)
!115 = !DIEnumerator(name: "_SC_MESSAGE_PASSING", value: 20, isUnsigned: true)
!116 = !DIEnumerator(name: "_SC_SEMAPHORES", value: 21, isUnsigned: true)
!117 = !DIEnumerator(name: "_SC_SHARED_MEMORY_OBJECTS", value: 22, isUnsigned: true)
!118 = !DIEnumerator(name: "_SC_AIO_LISTIO_MAX", value: 23, isUnsigned: true)
!119 = !DIEnumerator(name: "_SC_AIO_MAX", value: 24, isUnsigned: true)
!120 = !DIEnumerator(name: "_SC_AIO_PRIO_DELTA_MAX", value: 25, isUnsigned: true)
!121 = !DIEnumerator(name: "_SC_DELAYTIMER_MAX", value: 26, isUnsigned: true)
!122 = !DIEnumerator(name: "_SC_MQ_OPEN_MAX", value: 27, isUnsigned: true)
!123 = !DIEnumerator(name: "_SC_MQ_PRIO_MAX", value: 28, isUnsigned: true)
!124 = !DIEnumerator(name: "_SC_VERSION", value: 29, isUnsigned: true)
!125 = !DIEnumerator(name: "_SC_PAGESIZE", value: 30, isUnsigned: true)
!126 = !DIEnumerator(name: "_SC_RTSIG_MAX", value: 31, isUnsigned: true)
!127 = !DIEnumerator(name: "_SC_SEM_NSEMS_MAX", value: 32, isUnsigned: true)
!128 = !DIEnumerator(name: "_SC_SEM_VALUE_MAX", value: 33, isUnsigned: true)
!129 = !DIEnumerator(name: "_SC_SIGQUEUE_MAX", value: 34, isUnsigned: true)
!130 = !DIEnumerator(name: "_SC_TIMER_MAX", value: 35, isUnsigned: true)
!131 = !DIEnumerator(name: "_SC_BC_BASE_MAX", value: 36, isUnsigned: true)
!132 = !DIEnumerator(name: "_SC_BC_DIM_MAX", value: 37, isUnsigned: true)
!133 = !DIEnumerator(name: "_SC_BC_SCALE_MAX", value: 38, isUnsigned: true)
!134 = !DIEnumerator(name: "_SC_BC_STRING_MAX", value: 39, isUnsigned: true)
!135 = !DIEnumerator(name: "_SC_COLL_WEIGHTS_MAX", value: 40, isUnsigned: true)
!136 = !DIEnumerator(name: "_SC_EQUIV_CLASS_MAX", value: 41, isUnsigned: true)
!137 = !DIEnumerator(name: "_SC_EXPR_NEST_MAX", value: 42, isUnsigned: true)
!138 = !DIEnumerator(name: "_SC_LINE_MAX", value: 43, isUnsigned: true)
!139 = !DIEnumerator(name: "_SC_RE_DUP_MAX", value: 44, isUnsigned: true)
!140 = !DIEnumerator(name: "_SC_CHARCLASS_NAME_MAX", value: 45, isUnsigned: true)
!141 = !DIEnumerator(name: "_SC_2_VERSION", value: 46, isUnsigned: true)
!142 = !DIEnumerator(name: "_SC_2_C_BIND", value: 47, isUnsigned: true)
!143 = !DIEnumerator(name: "_SC_2_C_DEV", value: 48, isUnsigned: true)
!144 = !DIEnumerator(name: "_SC_2_FORT_DEV", value: 49, isUnsigned: true)
!145 = !DIEnumerator(name: "_SC_2_FORT_RUN", value: 50, isUnsigned: true)
!146 = !DIEnumerator(name: "_SC_2_SW_DEV", value: 51, isUnsigned: true)
!147 = !DIEnumerator(name: "_SC_2_LOCALEDEF", value: 52, isUnsigned: true)
!148 = !DIEnumerator(name: "_SC_PII", value: 53, isUnsigned: true)
!149 = !DIEnumerator(name: "_SC_PII_XTI", value: 54, isUnsigned: true)
!150 = !DIEnumerator(name: "_SC_PII_SOCKET", value: 55, isUnsigned: true)
!151 = !DIEnumerator(name: "_SC_PII_INTERNET", value: 56, isUnsigned: true)
!152 = !DIEnumerator(name: "_SC_PII_OSI", value: 57, isUnsigned: true)
!153 = !DIEnumerator(name: "_SC_POLL", value: 58, isUnsigned: true)
!154 = !DIEnumerator(name: "_SC_SELECT", value: 59, isUnsigned: true)
!155 = !DIEnumerator(name: "_SC_UIO_MAXIOV", value: 60, isUnsigned: true)
!156 = !DIEnumerator(name: "_SC_IOV_MAX", value: 60, isUnsigned: true)
!157 = !DIEnumerator(name: "_SC_PII_INTERNET_STREAM", value: 61, isUnsigned: true)
!158 = !DIEnumerator(name: "_SC_PII_INTERNET_DGRAM", value: 62, isUnsigned: true)
!159 = !DIEnumerator(name: "_SC_PII_OSI_COTS", value: 63, isUnsigned: true)
!160 = !DIEnumerator(name: "_SC_PII_OSI_CLTS", value: 64, isUnsigned: true)
!161 = !DIEnumerator(name: "_SC_PII_OSI_M", value: 65, isUnsigned: true)
!162 = !DIEnumerator(name: "_SC_T_IOV_MAX", value: 66, isUnsigned: true)
!163 = !DIEnumerator(name: "_SC_THREADS", value: 67, isUnsigned: true)
!164 = !DIEnumerator(name: "_SC_THREAD_SAFE_FUNCTIONS", value: 68, isUnsigned: true)
!165 = !DIEnumerator(name: "_SC_GETGR_R_SIZE_MAX", value: 69, isUnsigned: true)
!166 = !DIEnumerator(name: "_SC_GETPW_R_SIZE_MAX", value: 70, isUnsigned: true)
!167 = !DIEnumerator(name: "_SC_LOGIN_NAME_MAX", value: 71, isUnsigned: true)
!168 = !DIEnumerator(name: "_SC_TTY_NAME_MAX", value: 72, isUnsigned: true)
!169 = !DIEnumerator(name: "_SC_THREAD_DESTRUCTOR_ITERATIONS", value: 73, isUnsigned: true)
!170 = !DIEnumerator(name: "_SC_THREAD_KEYS_MAX", value: 74, isUnsigned: true)
!171 = !DIEnumerator(name: "_SC_THREAD_STACK_MIN", value: 75, isUnsigned: true)
!172 = !DIEnumerator(name: "_SC_THREAD_THREADS_MAX", value: 76, isUnsigned: true)
!173 = !DIEnumerator(name: "_SC_THREAD_ATTR_STACKADDR", value: 77, isUnsigned: true)
!174 = !DIEnumerator(name: "_SC_THREAD_ATTR_STACKSIZE", value: 78, isUnsigned: true)
!175 = !DIEnumerator(name: "_SC_THREAD_PRIORITY_SCHEDULING", value: 79, isUnsigned: true)
!176 = !DIEnumerator(name: "_SC_THREAD_PRIO_INHERIT", value: 80, isUnsigned: true)
!177 = !DIEnumerator(name: "_SC_THREAD_PRIO_PROTECT", value: 81, isUnsigned: true)
!178 = !DIEnumerator(name: "_SC_THREAD_PROCESS_SHARED", value: 82, isUnsigned: true)
!179 = !DIEnumerator(name: "_SC_NPROCESSORS_CONF", value: 83, isUnsigned: true)
!180 = !DIEnumerator(name: "_SC_NPROCESSORS_ONLN", value: 84, isUnsigned: true)
!181 = !DIEnumerator(name: "_SC_PHYS_PAGES", value: 85, isUnsigned: true)
!182 = !DIEnumerator(name: "_SC_AVPHYS_PAGES", value: 86, isUnsigned: true)
!183 = !DIEnumerator(name: "_SC_ATEXIT_MAX", value: 87, isUnsigned: true)
!184 = !DIEnumerator(name: "_SC_PASS_MAX", value: 88, isUnsigned: true)
!185 = !DIEnumerator(name: "_SC_XOPEN_VERSION", value: 89, isUnsigned: true)
!186 = !DIEnumerator(name: "_SC_XOPEN_XCU_VERSION", value: 90, isUnsigned: true)
!187 = !DIEnumerator(name: "_SC_XOPEN_UNIX", value: 91, isUnsigned: true)
!188 = !DIEnumerator(name: "_SC_XOPEN_CRYPT", value: 92, isUnsigned: true)
!189 = !DIEnumerator(name: "_SC_XOPEN_ENH_I18N", value: 93, isUnsigned: true)
!190 = !DIEnumerator(name: "_SC_XOPEN_SHM", value: 94, isUnsigned: true)
!191 = !DIEnumerator(name: "_SC_2_CHAR_TERM", value: 95, isUnsigned: true)
!192 = !DIEnumerator(name: "_SC_2_C_VERSION", value: 96, isUnsigned: true)
!193 = !DIEnumerator(name: "_SC_2_UPE", value: 97, isUnsigned: true)
!194 = !DIEnumerator(name: "_SC_XOPEN_XPG2", value: 98, isUnsigned: true)
!195 = !DIEnumerator(name: "_SC_XOPEN_XPG3", value: 99, isUnsigned: true)
!196 = !DIEnumerator(name: "_SC_XOPEN_XPG4", value: 100, isUnsigned: true)
!197 = !DIEnumerator(name: "_SC_CHAR_BIT", value: 101, isUnsigned: true)
!198 = !DIEnumerator(name: "_SC_CHAR_MAX", value: 102, isUnsigned: true)
!199 = !DIEnumerator(name: "_SC_CHAR_MIN", value: 103, isUnsigned: true)
!200 = !DIEnumerator(name: "_SC_INT_MAX", value: 104, isUnsigned: true)
!201 = !DIEnumerator(name: "_SC_INT_MIN", value: 105, isUnsigned: true)
!202 = !DIEnumerator(name: "_SC_LONG_BIT", value: 106, isUnsigned: true)
!203 = !DIEnumerator(name: "_SC_WORD_BIT", value: 107, isUnsigned: true)
!204 = !DIEnumerator(name: "_SC_MB_LEN_MAX", value: 108, isUnsigned: true)
!205 = !DIEnumerator(name: "_SC_NZERO", value: 109, isUnsigned: true)
!206 = !DIEnumerator(name: "_SC_SSIZE_MAX", value: 110, isUnsigned: true)
!207 = !DIEnumerator(name: "_SC_SCHAR_MAX", value: 111, isUnsigned: true)
!208 = !DIEnumerator(name: "_SC_SCHAR_MIN", value: 112, isUnsigned: true)
!209 = !DIEnumerator(name: "_SC_SHRT_MAX", value: 113, isUnsigned: true)
!210 = !DIEnumerator(name: "_SC_SHRT_MIN", value: 114, isUnsigned: true)
!211 = !DIEnumerator(name: "_SC_UCHAR_MAX", value: 115, isUnsigned: true)
!212 = !DIEnumerator(name: "_SC_UINT_MAX", value: 116, isUnsigned: true)
!213 = !DIEnumerator(name: "_SC_ULONG_MAX", value: 117, isUnsigned: true)
!214 = !DIEnumerator(name: "_SC_USHRT_MAX", value: 118, isUnsigned: true)
!215 = !DIEnumerator(name: "_SC_NL_ARGMAX", value: 119, isUnsigned: true)
!216 = !DIEnumerator(name: "_SC_NL_LANGMAX", value: 120, isUnsigned: true)
!217 = !DIEnumerator(name: "_SC_NL_MSGMAX", value: 121, isUnsigned: true)
!218 = !DIEnumerator(name: "_SC_NL_NMAX", value: 122, isUnsigned: true)
!219 = !DIEnumerator(name: "_SC_NL_SETMAX", value: 123, isUnsigned: true)
!220 = !DIEnumerator(name: "_SC_NL_TEXTMAX", value: 124, isUnsigned: true)
!221 = !DIEnumerator(name: "_SC_XBS5_ILP32_OFF32", value: 125, isUnsigned: true)
!222 = !DIEnumerator(name: "_SC_XBS5_ILP32_OFFBIG", value: 126, isUnsigned: true)
!223 = !DIEnumerator(name: "_SC_XBS5_LP64_OFF64", value: 127, isUnsigned: true)
!224 = !DIEnumerator(name: "_SC_XBS5_LPBIG_OFFBIG", value: 128, isUnsigned: true)
!225 = !DIEnumerator(name: "_SC_XOPEN_LEGACY", value: 129, isUnsigned: true)
!226 = !DIEnumerator(name: "_SC_XOPEN_REALTIME", value: 130, isUnsigned: true)
!227 = !DIEnumerator(name: "_SC_XOPEN_REALTIME_THREADS", value: 131, isUnsigned: true)
!228 = !DIEnumerator(name: "_SC_ADVISORY_INFO", value: 132, isUnsigned: true)
!229 = !DIEnumerator(name: "_SC_BARRIERS", value: 133, isUnsigned: true)
!230 = !DIEnumerator(name: "_SC_BASE", value: 134, isUnsigned: true)
!231 = !DIEnumerator(name: "_SC_C_LANG_SUPPORT", value: 135, isUnsigned: true)
!232 = !DIEnumerator(name: "_SC_C_LANG_SUPPORT_R", value: 136, isUnsigned: true)
!233 = !DIEnumerator(name: "_SC_CLOCK_SELECTION", value: 137, isUnsigned: true)
!234 = !DIEnumerator(name: "_SC_CPUTIME", value: 138, isUnsigned: true)
!235 = !DIEnumerator(name: "_SC_THREAD_CPUTIME", value: 139, isUnsigned: true)
!236 = !DIEnumerator(name: "_SC_DEVICE_IO", value: 140, isUnsigned: true)
!237 = !DIEnumerator(name: "_SC_DEVICE_SPECIFIC", value: 141, isUnsigned: true)
!238 = !DIEnumerator(name: "_SC_DEVICE_SPECIFIC_R", value: 142, isUnsigned: true)
!239 = !DIEnumerator(name: "_SC_FD_MGMT", value: 143, isUnsigned: true)
!240 = !DIEnumerator(name: "_SC_FIFO", value: 144, isUnsigned: true)
!241 = !DIEnumerator(name: "_SC_PIPE", value: 145, isUnsigned: true)
!242 = !DIEnumerator(name: "_SC_FILE_ATTRIBUTES", value: 146, isUnsigned: true)
!243 = !DIEnumerator(name: "_SC_FILE_LOCKING", value: 147, isUnsigned: true)
!244 = !DIEnumerator(name: "_SC_FILE_SYSTEM", value: 148, isUnsigned: true)
!245 = !DIEnumerator(name: "_SC_MONOTONIC_CLOCK", value: 149, isUnsigned: true)
!246 = !DIEnumerator(name: "_SC_MULTI_PROCESS", value: 150, isUnsigned: true)
!247 = !DIEnumerator(name: "_SC_SINGLE_PROCESS", value: 151, isUnsigned: true)
!248 = !DIEnumerator(name: "_SC_NETWORKING", value: 152, isUnsigned: true)
!249 = !DIEnumerator(name: "_SC_READER_WRITER_LOCKS", value: 153, isUnsigned: true)
!250 = !DIEnumerator(name: "_SC_SPIN_LOCKS", value: 154, isUnsigned: true)
!251 = !DIEnumerator(name: "_SC_REGEXP", value: 155, isUnsigned: true)
!252 = !DIEnumerator(name: "_SC_REGEX_VERSION", value: 156, isUnsigned: true)
!253 = !DIEnumerator(name: "_SC_SHELL", value: 157, isUnsigned: true)
!254 = !DIEnumerator(name: "_SC_SIGNALS", value: 158, isUnsigned: true)
!255 = !DIEnumerator(name: "_SC_SPAWN", value: 159, isUnsigned: true)
!256 = !DIEnumerator(name: "_SC_SPORADIC_SERVER", value: 160, isUnsigned: true)
!257 = !DIEnumerator(name: "_SC_THREAD_SPORADIC_SERVER", value: 161, isUnsigned: true)
!258 = !DIEnumerator(name: "_SC_SYSTEM_DATABASE", value: 162, isUnsigned: true)
!259 = !DIEnumerator(name: "_SC_SYSTEM_DATABASE_R", value: 163, isUnsigned: true)
!260 = !DIEnumerator(name: "_SC_TIMEOUTS", value: 164, isUnsigned: true)
!261 = !DIEnumerator(name: "_SC_TYPED_MEMORY_OBJECTS", value: 165, isUnsigned: true)
!262 = !DIEnumerator(name: "_SC_USER_GROUPS", value: 166, isUnsigned: true)
!263 = !DIEnumerator(name: "_SC_USER_GROUPS_R", value: 167, isUnsigned: true)
!264 = !DIEnumerator(name: "_SC_2_PBS", value: 168, isUnsigned: true)
!265 = !DIEnumerator(name: "_SC_2_PBS_ACCOUNTING", value: 169, isUnsigned: true)
!266 = !DIEnumerator(name: "_SC_2_PBS_LOCATE", value: 170, isUnsigned: true)
!267 = !DIEnumerator(name: "_SC_2_PBS_MESSAGE", value: 171, isUnsigned: true)
!268 = !DIEnumerator(name: "_SC_2_PBS_TRACK", value: 172, isUnsigned: true)
!269 = !DIEnumerator(name: "_SC_SYMLOOP_MAX", value: 173, isUnsigned: true)
!270 = !DIEnumerator(name: "_SC_STREAMS", value: 174, isUnsigned: true)
!271 = !DIEnumerator(name: "_SC_2_PBS_CHECKPOINT", value: 175, isUnsigned: true)
!272 = !DIEnumerator(name: "_SC_V6_ILP32_OFF32", value: 176, isUnsigned: true)
!273 = !DIEnumerator(name: "_SC_V6_ILP32_OFFBIG", value: 177, isUnsigned: true)
!274 = !DIEnumerator(name: "_SC_V6_LP64_OFF64", value: 178, isUnsigned: true)
!275 = !DIEnumerator(name: "_SC_V6_LPBIG_OFFBIG", value: 179, isUnsigned: true)
!276 = !DIEnumerator(name: "_SC_HOST_NAME_MAX", value: 180, isUnsigned: true)
!277 = !DIEnumerator(name: "_SC_TRACE", value: 181, isUnsigned: true)
!278 = !DIEnumerator(name: "_SC_TRACE_EVENT_FILTER", value: 182, isUnsigned: true)
!279 = !DIEnumerator(name: "_SC_TRACE_INHERIT", value: 183, isUnsigned: true)
!280 = !DIEnumerator(name: "_SC_TRACE_LOG", value: 184, isUnsigned: true)
!281 = !DIEnumerator(name: "_SC_LEVEL1_ICACHE_SIZE", value: 185, isUnsigned: true)
!282 = !DIEnumerator(name: "_SC_LEVEL1_ICACHE_ASSOC", value: 186, isUnsigned: true)
!283 = !DIEnumerator(name: "_SC_LEVEL1_ICACHE_LINESIZE", value: 187, isUnsigned: true)
!284 = !DIEnumerator(name: "_SC_LEVEL1_DCACHE_SIZE", value: 188, isUnsigned: true)
!285 = !DIEnumerator(name: "_SC_LEVEL1_DCACHE_ASSOC", value: 189, isUnsigned: true)
!286 = !DIEnumerator(name: "_SC_LEVEL1_DCACHE_LINESIZE", value: 190, isUnsigned: true)
!287 = !DIEnumerator(name: "_SC_LEVEL2_CACHE_SIZE", value: 191, isUnsigned: true)
!288 = !DIEnumerator(name: "_SC_LEVEL2_CACHE_ASSOC", value: 192, isUnsigned: true)
!289 = !DIEnumerator(name: "_SC_LEVEL2_CACHE_LINESIZE", value: 193, isUnsigned: true)
!290 = !DIEnumerator(name: "_SC_LEVEL3_CACHE_SIZE", value: 194, isUnsigned: true)
!291 = !DIEnumerator(name: "_SC_LEVEL3_CACHE_ASSOC", value: 195, isUnsigned: true)
!292 = !DIEnumerator(name: "_SC_LEVEL3_CACHE_LINESIZE", value: 196, isUnsigned: true)
!293 = !DIEnumerator(name: "_SC_LEVEL4_CACHE_SIZE", value: 197, isUnsigned: true)
!294 = !DIEnumerator(name: "_SC_LEVEL4_CACHE_ASSOC", value: 198, isUnsigned: true)
!295 = !DIEnumerator(name: "_SC_LEVEL4_CACHE_LINESIZE", value: 199, isUnsigned: true)
!296 = !DIEnumerator(name: "_SC_IPV6", value: 235, isUnsigned: true)
!297 = !DIEnumerator(name: "_SC_RAW_SOCKETS", value: 236, isUnsigned: true)
!298 = !DIEnumerator(name: "_SC_V7_ILP32_OFF32", value: 237, isUnsigned: true)
!299 = !DIEnumerator(name: "_SC_V7_ILP32_OFFBIG", value: 238, isUnsigned: true)
!300 = !DIEnumerator(name: "_SC_V7_LP64_OFF64", value: 239, isUnsigned: true)
!301 = !DIEnumerator(name: "_SC_V7_LPBIG_OFFBIG", value: 240, isUnsigned: true)
!302 = !DIEnumerator(name: "_SC_SS_REPL_MAX", value: 241, isUnsigned: true)
!303 = !DIEnumerator(name: "_SC_TRACE_EVENT_NAME_MAX", value: 242, isUnsigned: true)
!304 = !DIEnumerator(name: "_SC_TRACE_NAME_MAX", value: 243, isUnsigned: true)
!305 = !DIEnumerator(name: "_SC_TRACE_SYS_MAX", value: 244, isUnsigned: true)
!306 = !DIEnumerator(name: "_SC_TRACE_USER_EVENT_MAX", value: 245, isUnsigned: true)
!307 = !DIEnumerator(name: "_SC_XOPEN_STREAMS", value: 246, isUnsigned: true)
!308 = !DIEnumerator(name: "_SC_THREAD_ROBUST_PRIO_INHERIT", value: 247, isUnsigned: true)
!309 = !DIEnumerator(name: "_SC_THREAD_ROBUST_PRIO_PROTECT", value: 248, isUnsigned: true)
!310 = !{!311, !312}
!311 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!312 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!313 = !{!"clang version 8.0.1-9 (tags/RELEASE_801/final)"}
!314 = !{i32 2, !"Dwarf Version", i32 4}
!315 = !{i32 2, !"Debug Info Version", i32 3}
!316 = !{i32 1, !"wchar_size", i32 4}
!317 = distinct !DISubprogram(name: "seqquick", scope: !3, file: !3, line: 176, type: !318, scopeLine: 177, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !320)
!318 = !DISubroutineType(types: !319)
!319 = !{null, !13, !13}
!320 = !{}
!321 = !DILocalVariable(name: "low", arg: 1, scope: !317, file: !3, line: 176, type: !13)
!322 = !DILocation(line: 176, column: 20, scope: !317)
!323 = !DILocalVariable(name: "high", arg: 2, scope: !317, file: !3, line: 176, type: !13)
!324 = !DILocation(line: 176, column: 30, scope: !317)
!325 = !DILocalVariable(name: "p", scope: !317, file: !3, line: 178, type: !13)
!326 = !DILocation(line: 178, column: 11, scope: !317)
!327 = !DILocation(line: 180, column: 6, scope: !317)
!328 = !DILocation(line: 180, column: 13, scope: !317)
!329 = !DILocation(line: 180, column: 20, scope: !317)
!330 = !DILocation(line: 180, column: 18, scope: !317)
!331 = !DILocation(line: 180, column: 27, scope: !317)
!332 = !DILocation(line: 180, column: 24, scope: !317)
!333 = !DILocation(line: 181, column: 16, scope: !334)
!334 = distinct !DILexicalBlock(scope: !317, file: !3, line: 180, column: 52)
!335 = !DILocation(line: 181, column: 21, scope: !334)
!336 = !DILocation(line: 181, column: 8, scope: !334)
!337 = !DILocation(line: 181, column: 6, scope: !334)
!338 = !DILocation(line: 182, column: 13, scope: !334)
!339 = !DILocation(line: 182, column: 18, scope: !334)
!340 = !DILocation(line: 182, column: 4, scope: !334)
!341 = !DILocation(line: 183, column: 10, scope: !334)
!342 = !DILocation(line: 183, column: 12, scope: !334)
!343 = !DILocation(line: 183, column: 8, scope: !334)
!344 = distinct !{!344, !327, !345}
!345 = !DILocation(line: 184, column: 6, scope: !317)
!346 = !DILocation(line: 186, column: 21, scope: !317)
!347 = !DILocation(line: 186, column: 26, scope: !317)
!348 = !DILocation(line: 186, column: 6, scope: !317)
!349 = !DILocation(line: 187, column: 1, scope: !317)
!350 = distinct !DISubprogram(name: "seqpart", scope: !3, file: !3, line: 115, type: !351, scopeLine: 116, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !320)
!351 = !DISubroutineType(types: !352)
!352 = !{!13, !13, !13}
!353 = !DILocalVariable(name: "low", arg: 1, scope: !350, file: !3, line: 115, type: !13)
!354 = !DILocation(line: 115, column: 26, scope: !350)
!355 = !DILocalVariable(name: "high", arg: 2, scope: !350, file: !3, line: 115, type: !13)
!356 = !DILocation(line: 115, column: 36, scope: !350)
!357 = !DILocalVariable(name: "pivot", scope: !350, file: !3, line: 117, type: !14)
!358 = !DILocation(line: 117, column: 10, scope: !350)
!359 = !DILocalVariable(name: "h", scope: !350, file: !3, line: 118, type: !14)
!360 = !DILocation(line: 118, column: 10, scope: !350)
!361 = !DILocalVariable(name: "l", scope: !350, file: !3, line: 118, type: !14)
!362 = !DILocation(line: 118, column: 13, scope: !350)
!363 = !DILocalVariable(name: "curr_low", scope: !350, file: !3, line: 119, type: !13)
!364 = !DILocation(line: 119, column: 11, scope: !350)
!365 = !DILocation(line: 119, column: 22, scope: !350)
!366 = !DILocalVariable(name: "curr_high", scope: !350, file: !3, line: 120, type: !13)
!367 = !DILocation(line: 120, column: 11, scope: !350)
!368 = !DILocation(line: 120, column: 23, scope: !350)
!369 = !DILocation(line: 122, column: 27, scope: !350)
!370 = !DILocation(line: 122, column: 32, scope: !350)
!371 = !DILocation(line: 122, column: 14, scope: !350)
!372 = !DILocation(line: 122, column: 12, scope: !350)
!373 = !DILocation(line: 124, column: 6, scope: !350)
!374 = !DILocation(line: 125, column: 4, scope: !375)
!375 = distinct !DILexicalBlock(scope: !350, file: !3, line: 124, column: 16)
!376 = !DILocation(line: 125, column: 17, scope: !375)
!377 = !DILocation(line: 125, column: 16, scope: !375)
!378 = !DILocation(line: 125, column: 14, scope: !375)
!379 = !DILocation(line: 125, column: 30, scope: !375)
!380 = !DILocation(line: 125, column: 28, scope: !375)
!381 = !DILocation(line: 126, column: 18, scope: !375)
!382 = distinct !{!382, !374, !381}
!383 = !DILocation(line: 128, column: 4, scope: !375)
!384 = !DILocation(line: 128, column: 17, scope: !375)
!385 = !DILocation(line: 128, column: 16, scope: !375)
!386 = !DILocation(line: 128, column: 14, scope: !375)
!387 = !DILocation(line: 128, column: 29, scope: !375)
!388 = !DILocation(line: 128, column: 27, scope: !375)
!389 = !DILocation(line: 129, column: 17, scope: !375)
!390 = distinct !{!390, !383, !389}
!391 = !DILocation(line: 131, column: 8, scope: !392)
!392 = distinct !DILexicalBlock(scope: !375, file: !3, line: 131, column: 8)
!393 = !DILocation(line: 131, column: 20, scope: !392)
!394 = !DILocation(line: 131, column: 17, scope: !392)
!395 = !DILocation(line: 131, column: 8, scope: !375)
!396 = !DILocation(line: 132, column: 9, scope: !392)
!397 = !DILocation(line: 134, column: 19, scope: !375)
!398 = !DILocation(line: 134, column: 14, scope: !375)
!399 = !DILocation(line: 134, column: 17, scope: !375)
!400 = !DILocation(line: 135, column: 18, scope: !375)
!401 = !DILocation(line: 135, column: 13, scope: !375)
!402 = !DILocation(line: 135, column: 16, scope: !375)
!403 = distinct !{!403, !373, !404}
!404 = !DILocation(line: 136, column: 6, scope: !350)
!405 = !DILocation(line: 146, column: 10, scope: !406)
!406 = distinct !DILexicalBlock(scope: !350, file: !3, line: 146, column: 10)
!407 = !DILocation(line: 146, column: 22, scope: !406)
!408 = !DILocation(line: 146, column: 20, scope: !406)
!409 = !DILocation(line: 146, column: 10, scope: !350)
!410 = !DILocation(line: 147, column: 11, scope: !406)
!411 = !DILocation(line: 147, column: 4, scope: !406)
!412 = !DILocation(line: 149, column: 11, scope: !406)
!413 = !DILocation(line: 149, column: 21, scope: !406)
!414 = !DILocation(line: 149, column: 4, scope: !406)
!415 = !DILocation(line: 150, column: 1, scope: !350)
!416 = distinct !DISubprogram(name: "insertion_sort", scope: !3, file: !3, line: 160, type: !318, scopeLine: 161, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !320)
!417 = !DILocalVariable(name: "low", arg: 1, scope: !416, file: !3, line: 160, type: !13)
!418 = !DILocation(line: 160, column: 33, scope: !416)
!419 = !DILocalVariable(name: "high", arg: 2, scope: !416, file: !3, line: 160, type: !13)
!420 = !DILocation(line: 160, column: 43, scope: !416)
!421 = !DILocalVariable(name: "p", scope: !416, file: !3, line: 162, type: !13)
!422 = !DILocation(line: 162, column: 11, scope: !416)
!423 = !DILocalVariable(name: "q", scope: !416, file: !3, line: 162, type: !13)
!424 = !DILocation(line: 162, column: 15, scope: !416)
!425 = !DILocalVariable(name: "a", scope: !416, file: !3, line: 163, type: !14)
!426 = !DILocation(line: 163, column: 10, scope: !416)
!427 = !DILocalVariable(name: "b", scope: !416, file: !3, line: 163, type: !14)
!428 = !DILocation(line: 163, column: 13, scope: !416)
!429 = !DILocation(line: 165, column: 15, scope: !430)
!430 = distinct !DILexicalBlock(scope: !416, file: !3, line: 165, column: 6)
!431 = !DILocation(line: 165, column: 19, scope: !430)
!432 = !DILocation(line: 165, column: 13, scope: !430)
!433 = !DILocation(line: 165, column: 11, scope: !430)
!434 = !DILocation(line: 165, column: 24, scope: !435)
!435 = distinct !DILexicalBlock(scope: !430, file: !3, line: 165, column: 6)
!436 = !DILocation(line: 165, column: 29, scope: !435)
!437 = !DILocation(line: 165, column: 26, scope: !435)
!438 = !DILocation(line: 165, column: 6, scope: !430)
!439 = !DILocation(line: 166, column: 8, scope: !440)
!440 = distinct !DILexicalBlock(scope: !435, file: !3, line: 165, column: 40)
!441 = !DILocation(line: 166, column: 6, scope: !440)
!442 = !DILocation(line: 167, column: 13, scope: !443)
!443 = distinct !DILexicalBlock(scope: !440, file: !3, line: 167, column: 4)
!444 = !DILocation(line: 167, column: 15, scope: !443)
!445 = !DILocation(line: 167, column: 11, scope: !443)
!446 = !DILocation(line: 167, column: 9, scope: !443)
!447 = !DILocation(line: 167, column: 20, scope: !448)
!448 = distinct !DILexicalBlock(scope: !443, file: !3, line: 167, column: 4)
!449 = !DILocation(line: 167, column: 25, scope: !448)
!450 = !DILocation(line: 167, column: 22, scope: !448)
!451 = !DILocation(line: 167, column: 29, scope: !448)
!452 = !DILocation(line: 167, column: 37, scope: !448)
!453 = !DILocation(line: 167, column: 35, scope: !448)
!454 = !DILocation(line: 167, column: 45, scope: !448)
!455 = !DILocation(line: 167, column: 43, scope: !448)
!456 = !DILocation(line: 0, scope: !448)
!457 = !DILocation(line: 167, column: 4, scope: !443)
!458 = !DILocation(line: 168, column: 16, scope: !448)
!459 = !DILocation(line: 168, column: 9, scope: !448)
!460 = !DILocation(line: 168, column: 14, scope: !448)
!461 = !DILocation(line: 167, column: 49, scope: !448)
!462 = !DILocation(line: 167, column: 4, scope: !448)
!463 = distinct !{!463, !457, !464}
!464 = !DILocation(line: 168, column: 16, scope: !443)
!465 = !DILocation(line: 169, column: 11, scope: !440)
!466 = !DILocation(line: 169, column: 4, scope: !440)
!467 = !DILocation(line: 169, column: 9, scope: !440)
!468 = !DILocation(line: 170, column: 6, scope: !440)
!469 = !DILocation(line: 165, column: 35, scope: !435)
!470 = !DILocation(line: 165, column: 6, scope: !435)
!471 = distinct !{!471, !438, !472}
!472 = !DILocation(line: 170, column: 6, scope: !430)
!473 = !DILocation(line: 171, column: 1, scope: !416)
!474 = distinct !DISubprogram(name: "choose_pivot", scope: !3, file: !3, line: 110, type: !475, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !320)
!475 = !DISubroutineType(types: !476)
!476 = !{!14, !13, !13}
!477 = !DILocalVariable(name: "low", arg: 1, scope: !474, file: !3, line: 110, type: !13)
!478 = !DILocation(line: 110, column: 37, scope: !474)
!479 = !DILocalVariable(name: "high", arg: 2, scope: !474, file: !3, line: 110, type: !13)
!480 = !DILocation(line: 110, column: 47, scope: !474)
!481 = !DILocation(line: 112, column: 19, scope: !474)
!482 = !DILocation(line: 112, column: 18, scope: !474)
!483 = !DILocation(line: 112, column: 25, scope: !474)
!484 = !DILocation(line: 112, column: 24, scope: !474)
!485 = !DILocation(line: 112, column: 31, scope: !474)
!486 = !DILocation(line: 112, column: 36, scope: !474)
!487 = !DILocation(line: 112, column: 43, scope: !474)
!488 = !DILocation(line: 112, column: 41, scope: !474)
!489 = !DILocation(line: 112, column: 48, scope: !474)
!490 = !DILocation(line: 112, column: 13, scope: !474)
!491 = !DILocation(line: 112, column: 6, scope: !474)
!492 = distinct !DISubprogram(name: "med3", scope: !3, file: !3, line: 83, type: !493, scopeLine: 84, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !320)
!493 = !DISubroutineType(types: !494)
!494 = !{!14, !14, !14, !14}
!495 = !DILocalVariable(name: "a", arg: 1, scope: !492, file: !3, line: 83, type: !14)
!496 = !DILocation(line: 83, column: 28, scope: !492)
!497 = !DILocalVariable(name: "b", arg: 2, scope: !492, file: !3, line: 83, type: !14)
!498 = !DILocation(line: 83, column: 35, scope: !492)
!499 = !DILocalVariable(name: "c", arg: 3, scope: !492, file: !3, line: 83, type: !14)
!500 = !DILocation(line: 83, column: 42, scope: !492)
!501 = !DILocation(line: 85, column: 10, scope: !502)
!502 = distinct !DILexicalBlock(scope: !492, file: !3, line: 85, column: 10)
!503 = !DILocation(line: 85, column: 14, scope: !502)
!504 = !DILocation(line: 85, column: 12, scope: !502)
!505 = !DILocation(line: 85, column: 10, scope: !492)
!506 = !DILocation(line: 86, column: 8, scope: !507)
!507 = distinct !DILexicalBlock(scope: !508, file: !3, line: 86, column: 8)
!508 = distinct !DILexicalBlock(scope: !502, file: !3, line: 85, column: 17)
!509 = !DILocation(line: 86, column: 12, scope: !507)
!510 = !DILocation(line: 86, column: 10, scope: !507)
!511 = !DILocation(line: 86, column: 8, scope: !508)
!512 = !DILocation(line: 87, column: 16, scope: !513)
!513 = distinct !DILexicalBlock(scope: !507, file: !3, line: 86, column: 15)
!514 = !DILocation(line: 87, column: 9, scope: !513)
!515 = !DILocation(line: 89, column: 13, scope: !516)
!516 = distinct !DILexicalBlock(scope: !517, file: !3, line: 89, column: 13)
!517 = distinct !DILexicalBlock(scope: !507, file: !3, line: 88, column: 11)
!518 = !DILocation(line: 89, column: 17, scope: !516)
!519 = !DILocation(line: 89, column: 15, scope: !516)
!520 = !DILocation(line: 89, column: 13, scope: !517)
!521 = !DILocation(line: 90, column: 14, scope: !516)
!522 = !DILocation(line: 90, column: 7, scope: !516)
!523 = !DILocation(line: 92, column: 14, scope: !516)
!524 = !DILocation(line: 92, column: 7, scope: !516)
!525 = !DILocation(line: 95, column: 8, scope: !526)
!526 = distinct !DILexicalBlock(scope: !527, file: !3, line: 95, column: 8)
!527 = distinct !DILexicalBlock(scope: !502, file: !3, line: 94, column: 13)
!528 = !DILocation(line: 95, column: 12, scope: !526)
!529 = !DILocation(line: 95, column: 10, scope: !526)
!530 = !DILocation(line: 95, column: 8, scope: !527)
!531 = !DILocation(line: 96, column: 16, scope: !532)
!532 = distinct !DILexicalBlock(scope: !526, file: !3, line: 95, column: 15)
!533 = !DILocation(line: 96, column: 9, scope: !532)
!534 = !DILocation(line: 98, column: 13, scope: !535)
!535 = distinct !DILexicalBlock(scope: !536, file: !3, line: 98, column: 13)
!536 = distinct !DILexicalBlock(scope: !526, file: !3, line: 97, column: 11)
!537 = !DILocation(line: 98, column: 17, scope: !535)
!538 = !DILocation(line: 98, column: 15, scope: !535)
!539 = !DILocation(line: 98, column: 13, scope: !536)
!540 = !DILocation(line: 99, column: 14, scope: !535)
!541 = !DILocation(line: 99, column: 7, scope: !535)
!542 = !DILocation(line: 101, column: 14, scope: !535)
!543 = !DILocation(line: 101, column: 7, scope: !535)
!544 = !DILocation(line: 104, column: 1, scope: !492)
!545 = distinct !DISubprogram(name: "seqmerge", scope: !3, file: !3, line: 189, type: !546, scopeLine: 190, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !320)
!546 = !DISubroutineType(types: !547)
!547 = !{null, !13, !13, !13, !13, !13}
!548 = !DILocalVariable(name: "low1", arg: 1, scope: !545, file: !3, line: 189, type: !13)
!549 = !DILocation(line: 189, column: 20, scope: !545)
!550 = !DILocalVariable(name: "high1", arg: 2, scope: !545, file: !3, line: 189, type: !13)
!551 = !DILocation(line: 189, column: 31, scope: !545)
!552 = !DILocalVariable(name: "low2", arg: 3, scope: !545, file: !3, line: 189, type: !13)
!553 = !DILocation(line: 189, column: 43, scope: !545)
!554 = !DILocalVariable(name: "high2", arg: 4, scope: !545, file: !3, line: 189, type: !13)
!555 = !DILocation(line: 189, column: 54, scope: !545)
!556 = !DILocalVariable(name: "lowdest", arg: 5, scope: !545, file: !3, line: 189, type: !13)
!557 = !DILocation(line: 189, column: 66, scope: !545)
!558 = !DILocalVariable(name: "a1", scope: !545, file: !3, line: 191, type: !14)
!559 = !DILocation(line: 191, column: 10, scope: !545)
!560 = !DILocalVariable(name: "a2", scope: !545, file: !3, line: 191, type: !14)
!561 = !DILocation(line: 191, column: 14, scope: !545)
!562 = !DILocation(line: 219, column: 10, scope: !563)
!563 = distinct !DILexicalBlock(scope: !545, file: !3, line: 219, column: 10)
!564 = !DILocation(line: 219, column: 17, scope: !563)
!565 = !DILocation(line: 219, column: 15, scope: !563)
!566 = !DILocation(line: 219, column: 23, scope: !563)
!567 = !DILocation(line: 219, column: 26, scope: !563)
!568 = !DILocation(line: 219, column: 33, scope: !563)
!569 = !DILocation(line: 219, column: 31, scope: !563)
!570 = !DILocation(line: 219, column: 10, scope: !545)
!571 = !DILocation(line: 220, column: 10, scope: !572)
!572 = distinct !DILexicalBlock(scope: !563, file: !3, line: 219, column: 40)
!573 = !DILocation(line: 220, column: 9, scope: !572)
!574 = !DILocation(line: 220, column: 7, scope: !572)
!575 = !DILocation(line: 221, column: 10, scope: !572)
!576 = !DILocation(line: 221, column: 9, scope: !572)
!577 = !DILocation(line: 221, column: 7, scope: !572)
!578 = !DILocation(line: 222, column: 4, scope: !572)
!579 = !DILocation(line: 223, column: 13, scope: !580)
!580 = distinct !DILexicalBlock(scope: !581, file: !3, line: 223, column: 13)
!581 = distinct !DILexicalBlock(scope: !582, file: !3, line: 222, column: 13)
!582 = distinct !DILexicalBlock(scope: !583, file: !3, line: 222, column: 4)
!583 = distinct !DILexicalBlock(scope: !572, file: !3, line: 222, column: 4)
!584 = !DILocation(line: 223, column: 18, scope: !580)
!585 = !DILocation(line: 223, column: 16, scope: !580)
!586 = !DILocation(line: 223, column: 13, scope: !581)
!587 = !DILocation(line: 224, column: 20, scope: !588)
!588 = distinct !DILexicalBlock(scope: !580, file: !3, line: 223, column: 22)
!589 = !DILocation(line: 224, column: 15, scope: !588)
!590 = !DILocation(line: 224, column: 18, scope: !588)
!591 = !DILocation(line: 225, column: 13, scope: !588)
!592 = !DILocation(line: 225, column: 12, scope: !588)
!593 = !DILocation(line: 225, column: 10, scope: !588)
!594 = !DILocation(line: 226, column: 11, scope: !595)
!595 = distinct !DILexicalBlock(scope: !588, file: !3, line: 226, column: 11)
!596 = !DILocation(line: 226, column: 19, scope: !595)
!597 = !DILocation(line: 226, column: 16, scope: !595)
!598 = !DILocation(line: 226, column: 11, scope: !588)
!599 = !DILocation(line: 227, column: 5, scope: !595)
!600 = !DILocation(line: 228, column: 9, scope: !588)
!601 = !DILocation(line: 229, column: 20, scope: !602)
!602 = distinct !DILexicalBlock(scope: !580, file: !3, line: 228, column: 16)
!603 = !DILocation(line: 229, column: 15, scope: !602)
!604 = !DILocation(line: 229, column: 18, scope: !602)
!605 = !DILocation(line: 230, column: 13, scope: !602)
!606 = !DILocation(line: 230, column: 12, scope: !602)
!607 = !DILocation(line: 230, column: 10, scope: !602)
!608 = !DILocation(line: 231, column: 11, scope: !609)
!609 = distinct !DILexicalBlock(scope: !602, file: !3, line: 231, column: 11)
!610 = !DILocation(line: 231, column: 19, scope: !609)
!611 = !DILocation(line: 231, column: 16, scope: !609)
!612 = !DILocation(line: 231, column: 11, scope: !602)
!613 = !DILocation(line: 232, column: 5, scope: !609)
!614 = !DILocation(line: 222, column: 4, scope: !582)
!615 = distinct !{!615, !616, !617}
!616 = !DILocation(line: 222, column: 4, scope: !583)
!617 = !DILocation(line: 234, column: 4, scope: !583)
!618 = !DILocation(line: 235, column: 6, scope: !572)
!619 = !DILocation(line: 236, column: 10, scope: !620)
!620 = distinct !DILexicalBlock(scope: !545, file: !3, line: 236, column: 10)
!621 = !DILocation(line: 236, column: 18, scope: !620)
!622 = !DILocation(line: 236, column: 15, scope: !620)
!623 = !DILocation(line: 236, column: 24, scope: !620)
!624 = !DILocation(line: 236, column: 27, scope: !620)
!625 = !DILocation(line: 236, column: 35, scope: !620)
!626 = !DILocation(line: 236, column: 32, scope: !620)
!627 = !DILocation(line: 236, column: 10, scope: !545)
!628 = !DILocation(line: 237, column: 10, scope: !629)
!629 = distinct !DILexicalBlock(scope: !620, file: !3, line: 236, column: 42)
!630 = !DILocation(line: 237, column: 9, scope: !629)
!631 = !DILocation(line: 237, column: 7, scope: !629)
!632 = !DILocation(line: 238, column: 10, scope: !629)
!633 = !DILocation(line: 238, column: 9, scope: !629)
!634 = !DILocation(line: 238, column: 7, scope: !629)
!635 = !DILocation(line: 239, column: 4, scope: !629)
!636 = !DILocation(line: 240, column: 13, scope: !637)
!637 = distinct !DILexicalBlock(scope: !638, file: !3, line: 240, column: 13)
!638 = distinct !DILexicalBlock(scope: !639, file: !3, line: 239, column: 13)
!639 = distinct !DILexicalBlock(scope: !640, file: !3, line: 239, column: 4)
!640 = distinct !DILexicalBlock(scope: !629, file: !3, line: 239, column: 4)
!641 = !DILocation(line: 240, column: 18, scope: !637)
!642 = !DILocation(line: 240, column: 16, scope: !637)
!643 = !DILocation(line: 240, column: 13, scope: !638)
!644 = !DILocation(line: 241, column: 20, scope: !645)
!645 = distinct !DILexicalBlock(scope: !637, file: !3, line: 240, column: 22)
!646 = !DILocation(line: 241, column: 15, scope: !645)
!647 = !DILocation(line: 241, column: 18, scope: !645)
!648 = !DILocation(line: 242, column: 7, scope: !645)
!649 = !DILocation(line: 243, column: 11, scope: !650)
!650 = distinct !DILexicalBlock(scope: !645, file: !3, line: 243, column: 11)
!651 = !DILocation(line: 243, column: 18, scope: !650)
!652 = !DILocation(line: 243, column: 16, scope: !650)
!653 = !DILocation(line: 243, column: 11, scope: !645)
!654 = !DILocation(line: 244, column: 5, scope: !650)
!655 = !DILocation(line: 245, column: 13, scope: !645)
!656 = !DILocation(line: 245, column: 12, scope: !645)
!657 = !DILocation(line: 245, column: 10, scope: !645)
!658 = !DILocation(line: 246, column: 9, scope: !645)
!659 = !DILocation(line: 247, column: 20, scope: !660)
!660 = distinct !DILexicalBlock(scope: !637, file: !3, line: 246, column: 16)
!661 = !DILocation(line: 247, column: 15, scope: !660)
!662 = !DILocation(line: 247, column: 18, scope: !660)
!663 = !DILocation(line: 248, column: 7, scope: !660)
!664 = !DILocation(line: 249, column: 11, scope: !665)
!665 = distinct !DILexicalBlock(scope: !660, file: !3, line: 249, column: 11)
!666 = !DILocation(line: 249, column: 18, scope: !665)
!667 = !DILocation(line: 249, column: 16, scope: !665)
!668 = !DILocation(line: 249, column: 11, scope: !660)
!669 = !DILocation(line: 250, column: 5, scope: !665)
!670 = !DILocation(line: 251, column: 13, scope: !660)
!671 = !DILocation(line: 251, column: 12, scope: !660)
!672 = !DILocation(line: 251, column: 10, scope: !660)
!673 = !DILocation(line: 239, column: 4, scope: !639)
!674 = distinct !{!674, !675, !676}
!675 = !DILocation(line: 239, column: 4, scope: !640)
!676 = !DILocation(line: 253, column: 4, scope: !640)
!677 = !DILocation(line: 254, column: 6, scope: !629)
!678 = !DILocation(line: 255, column: 10, scope: !679)
!679 = distinct !DILexicalBlock(scope: !545, file: !3, line: 255, column: 10)
!680 = !DILocation(line: 255, column: 17, scope: !679)
!681 = !DILocation(line: 255, column: 15, scope: !679)
!682 = !DILocation(line: 255, column: 10, scope: !545)
!683 = !DILocation(line: 256, column: 11, scope: !684)
!684 = distinct !DILexicalBlock(scope: !679, file: !3, line: 255, column: 24)
!685 = !DILocation(line: 256, column: 4, scope: !684)
!686 = !DILocation(line: 256, column: 20, scope: !684)
!687 = !DILocation(line: 256, column: 41, scope: !684)
!688 = !DILocation(line: 256, column: 49, scope: !684)
!689 = !DILocation(line: 256, column: 47, scope: !684)
!690 = !DILocation(line: 256, column: 54, scope: !684)
!691 = !DILocation(line: 256, column: 38, scope: !684)
!692 = !DILocation(line: 257, column: 6, scope: !684)
!693 = !DILocation(line: 258, column: 11, scope: !694)
!694 = distinct !DILexicalBlock(scope: !679, file: !3, line: 257, column: 13)
!695 = !DILocation(line: 258, column: 4, scope: !694)
!696 = !DILocation(line: 258, column: 20, scope: !694)
!697 = !DILocation(line: 258, column: 41, scope: !694)
!698 = !DILocation(line: 258, column: 49, scope: !694)
!699 = !DILocation(line: 258, column: 47, scope: !694)
!700 = !DILocation(line: 258, column: 54, scope: !694)
!701 = !DILocation(line: 258, column: 38, scope: !694)
!702 = !DILocation(line: 260, column: 1, scope: !545)
!703 = distinct !DISubprogram(name: "binsplit", scope: !3, file: !3, line: 270, type: !704, scopeLine: 271, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !320)
!704 = !DISubroutineType(types: !705)
!705 = !{!13, !14, !13, !13}
!706 = !DILocalVariable(name: "val", arg: 1, scope: !703, file: !3, line: 270, type: !14)
!707 = !DILocation(line: 270, column: 19, scope: !703)
!708 = !DILocalVariable(name: "low", arg: 2, scope: !703, file: !3, line: 270, type: !13)
!709 = !DILocation(line: 270, column: 29, scope: !703)
!710 = !DILocalVariable(name: "high", arg: 3, scope: !703, file: !3, line: 270, type: !13)
!711 = !DILocation(line: 270, column: 39, scope: !703)
!712 = !DILocalVariable(name: "mid", scope: !703, file: !3, line: 276, type: !13)
!713 = !DILocation(line: 276, column: 11, scope: !703)
!714 = !DILocation(line: 278, column: 6, scope: !703)
!715 = !DILocation(line: 278, column: 13, scope: !703)
!716 = !DILocation(line: 278, column: 20, scope: !703)
!717 = !DILocation(line: 278, column: 17, scope: !703)
!718 = !DILocation(line: 279, column: 10, scope: !719)
!719 = distinct !DILexicalBlock(scope: !703, file: !3, line: 278, column: 26)
!720 = !DILocation(line: 279, column: 18, scope: !719)
!721 = !DILocation(line: 279, column: 25, scope: !719)
!722 = !DILocation(line: 279, column: 23, scope: !719)
!723 = !DILocation(line: 279, column: 29, scope: !719)
!724 = !DILocation(line: 279, column: 34, scope: !719)
!725 = !DILocation(line: 279, column: 14, scope: !719)
!726 = !DILocation(line: 279, column: 8, scope: !719)
!727 = !DILocation(line: 280, column: 8, scope: !728)
!728 = distinct !DILexicalBlock(scope: !719, file: !3, line: 280, column: 8)
!729 = !DILocation(line: 280, column: 16, scope: !728)
!730 = !DILocation(line: 280, column: 15, scope: !728)
!731 = !DILocation(line: 280, column: 12, scope: !728)
!732 = !DILocation(line: 280, column: 8, scope: !719)
!733 = !DILocation(line: 281, column: 16, scope: !728)
!734 = !DILocation(line: 281, column: 20, scope: !728)
!735 = !DILocation(line: 281, column: 14, scope: !728)
!736 = !DILocation(line: 281, column: 9, scope: !728)
!737 = !DILocation(line: 283, column: 15, scope: !728)
!738 = !DILocation(line: 283, column: 13, scope: !728)
!739 = distinct !{!739, !714, !740}
!740 = !DILocation(line: 284, column: 6, scope: !703)
!741 = !DILocation(line: 286, column: 11, scope: !742)
!742 = distinct !DILexicalBlock(scope: !703, file: !3, line: 286, column: 10)
!743 = !DILocation(line: 286, column: 10, scope: !742)
!744 = !DILocation(line: 286, column: 17, scope: !742)
!745 = !DILocation(line: 286, column: 15, scope: !742)
!746 = !DILocation(line: 286, column: 10, scope: !703)
!747 = !DILocation(line: 287, column: 11, scope: !742)
!748 = !DILocation(line: 287, column: 15, scope: !742)
!749 = !DILocation(line: 287, column: 4, scope: !742)
!750 = !DILocation(line: 289, column: 11, scope: !742)
!751 = !DILocation(line: 289, column: 4, scope: !742)
!752 = !DILocation(line: 290, column: 1, scope: !703)
!753 = distinct !DISubprogram(name: "cilkmerge", scope: !3, file: !3, line: 292, type: !546, scopeLine: 293, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !320)
!754 = !DILocalVariable(name: "low1", arg: 1, scope: !753, file: !3, line: 292, type: !13)
!755 = !DILocation(line: 292, column: 21, scope: !753)
!756 = !DILocalVariable(name: "high1", arg: 2, scope: !753, file: !3, line: 292, type: !13)
!757 = !DILocation(line: 292, column: 32, scope: !753)
!758 = !DILocalVariable(name: "low2", arg: 3, scope: !753, file: !3, line: 292, type: !13)
!759 = !DILocation(line: 292, column: 44, scope: !753)
!760 = !DILocalVariable(name: "high2", arg: 4, scope: !753, file: !3, line: 292, type: !13)
!761 = !DILocation(line: 292, column: 55, scope: !753)
!762 = !DILocalVariable(name: "lowdest", arg: 5, scope: !753, file: !3, line: 292, type: !13)
!763 = !DILocation(line: 292, column: 67, scope: !753)
!764 = !DILocalVariable(name: "split1", scope: !753, file: !3, line: 299, type: !13)
!765 = !DILocation(line: 299, column: 11, scope: !753)
!766 = !DILocalVariable(name: "split2", scope: !753, file: !3, line: 299, type: !13)
!767 = !DILocation(line: 299, column: 20, scope: !753)
!768 = !DILocalVariable(name: "lowsize", scope: !753, file: !3, line: 303, type: !16)
!769 = !DILocation(line: 303, column: 15, scope: !753)
!770 = !DILocation(line: 315, column: 10, scope: !771)
!771 = distinct !DILexicalBlock(scope: !753, file: !3, line: 315, column: 10)
!772 = !DILocation(line: 315, column: 18, scope: !771)
!773 = !DILocation(line: 315, column: 16, scope: !771)
!774 = !DILocation(line: 315, column: 25, scope: !771)
!775 = !DILocation(line: 315, column: 33, scope: !771)
!776 = !DILocation(line: 315, column: 31, scope: !771)
!777 = !DILocation(line: 315, column: 23, scope: !771)
!778 = !DILocation(line: 315, column: 10, scope: !753)
!779 = !DILocalVariable(name: "tmp", scope: !780, file: !3, line: 316, type: !13)
!780 = distinct !DILexicalBlock(scope: !781, file: !3, line: 316, column: 4)
!781 = distinct !DILexicalBlock(scope: !771, file: !3, line: 315, column: 39)
!782 = !DILocation(line: 316, column: 4, scope: !780)
!783 = !DILocalVariable(name: "tmp", scope: !784, file: !3, line: 317, type: !13)
!784 = distinct !DILexicalBlock(scope: !781, file: !3, line: 317, column: 4)
!785 = !DILocation(line: 317, column: 4, scope: !784)
!786 = !DILocation(line: 318, column: 6, scope: !781)
!787 = !DILocation(line: 319, column: 10, scope: !788)
!788 = distinct !DILexicalBlock(scope: !753, file: !3, line: 319, column: 10)
!789 = !DILocation(line: 319, column: 18, scope: !788)
!790 = !DILocation(line: 319, column: 16, scope: !788)
!791 = !DILocation(line: 319, column: 10, scope: !753)
!792 = !DILocation(line: 321, column: 11, scope: !793)
!793 = distinct !DILexicalBlock(scope: !788, file: !3, line: 319, column: 24)
!794 = !DILocation(line: 321, column: 4, scope: !793)
!795 = !DILocation(line: 321, column: 20, scope: !793)
!796 = !DILocation(line: 321, column: 41, scope: !793)
!797 = !DILocation(line: 321, column: 49, scope: !793)
!798 = !DILocation(line: 321, column: 47, scope: !793)
!799 = !DILocation(line: 321, column: 38, scope: !793)
!800 = !DILocation(line: 322, column: 4, scope: !793)
!801 = !DILocation(line: 324, column: 10, scope: !802)
!802 = distinct !DILexicalBlock(scope: !753, file: !3, line: 324, column: 10)
!803 = !DILocation(line: 324, column: 18, scope: !802)
!804 = !DILocation(line: 324, column: 16, scope: !802)
!805 = !DILocation(line: 324, column: 25, scope: !802)
!806 = !DILocation(line: 324, column: 23, scope: !802)
!807 = !DILocation(line: 324, column: 10, scope: !753)
!808 = !DILocation(line: 325, column: 13, scope: !809)
!809 = distinct !DILexicalBlock(scope: !802, file: !3, line: 324, column: 49)
!810 = !DILocation(line: 325, column: 19, scope: !809)
!811 = !DILocation(line: 325, column: 26, scope: !809)
!812 = !DILocation(line: 325, column: 32, scope: !809)
!813 = !DILocation(line: 325, column: 39, scope: !809)
!814 = !DILocation(line: 325, column: 4, scope: !809)
!815 = !DILocation(line: 326, column: 4, scope: !809)
!816 = !DILocation(line: 335, column: 17, scope: !753)
!817 = !DILocation(line: 335, column: 25, scope: !753)
!818 = !DILocation(line: 335, column: 23, scope: !753)
!819 = !DILocation(line: 335, column: 30, scope: !753)
!820 = !DILocation(line: 335, column: 35, scope: !753)
!821 = !DILocation(line: 335, column: 42, scope: !753)
!822 = !DILocation(line: 335, column: 40, scope: !753)
!823 = !DILocation(line: 335, column: 13, scope: !753)
!824 = !DILocation(line: 336, column: 25, scope: !753)
!825 = !DILocation(line: 336, column: 24, scope: !753)
!826 = !DILocation(line: 336, column: 33, scope: !753)
!827 = !DILocation(line: 336, column: 39, scope: !753)
!828 = !DILocation(line: 336, column: 15, scope: !753)
!829 = !DILocation(line: 336, column: 13, scope: !753)
!830 = !DILocation(line: 337, column: 16, scope: !753)
!831 = !DILocation(line: 337, column: 25, scope: !753)
!832 = !DILocation(line: 337, column: 23, scope: !753)
!833 = !DILocation(line: 337, column: 32, scope: !753)
!834 = !DILocation(line: 337, column: 30, scope: !753)
!835 = !DILocation(line: 337, column: 41, scope: !753)
!836 = !DILocation(line: 337, column: 39, scope: !753)
!837 = !DILocation(line: 337, column: 14, scope: !753)
!838 = !DILocation(line: 343, column: 34, scope: !753)
!839 = !DILocation(line: 343, column: 33, scope: !753)
!840 = !DILocation(line: 343, column: 8, scope: !753)
!841 = !DILocation(line: 343, column: 18, scope: !753)
!842 = !DILocation(line: 343, column: 16, scope: !753)
!843 = !DILocation(line: 343, column: 26, scope: !753)
!844 = !DILocation(line: 343, column: 31, scope: !753)
!845 = !DILocation(line: 344, column: 16, scope: !753)
!846 = !DILocation(line: 344, column: 22, scope: !753)
!847 = !DILocation(line: 344, column: 29, scope: !753)
!848 = !DILocation(line: 344, column: 34, scope: !753)
!849 = !DILocation(line: 344, column: 40, scope: !753)
!850 = !DILocation(line: 344, column: 48, scope: !753)
!851 = !DILocation(line: 344, column: 6, scope: !753)
!852 = !DILocation(line: 345, column: 16, scope: !753)
!853 = !DILocation(line: 345, column: 23, scope: !753)
!854 = !DILocation(line: 345, column: 28, scope: !753)
!855 = !DILocation(line: 345, column: 35, scope: !753)
!856 = !DILocation(line: 345, column: 42, scope: !753)
!857 = !DILocation(line: 345, column: 47, scope: !753)
!858 = !DILocation(line: 345, column: 54, scope: !753)
!859 = !DILocation(line: 345, column: 62, scope: !753)
!860 = !DILocation(line: 345, column: 61, scope: !753)
!861 = !DILocation(line: 345, column: 69, scope: !753)
!862 = !DILocation(line: 345, column: 6, scope: !753)
!863 = !DILocation(line: 347, column: 6, scope: !753)
!864 = !DILocation(line: 348, column: 1, scope: !753)
!865 = distinct !DISubprogram(name: "cilksort", scope: !3, file: !3, line: 350, type: !866, scopeLine: 351, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !320)
!866 = !DISubroutineType(types: !867)
!867 = !{null, !13, !13, !16}
!868 = !DILocalVariable(name: "low", arg: 1, scope: !865, file: !3, line: 350, type: !13)
!869 = !DILocation(line: 350, column: 20, scope: !865)
!870 = !DILocalVariable(name: "tmp", arg: 2, scope: !865, file: !3, line: 350, type: !13)
!871 = !DILocation(line: 350, column: 30, scope: !865)
!872 = !DILocalVariable(name: "size", arg: 3, scope: !865, file: !3, line: 350, type: !16)
!873 = !DILocation(line: 350, column: 40, scope: !865)
!874 = !DILocalVariable(name: "quarter", scope: !865, file: !3, line: 359, type: !16)
!875 = !DILocation(line: 359, column: 11, scope: !865)
!876 = !DILocation(line: 359, column: 21, scope: !865)
!877 = !DILocation(line: 359, column: 26, scope: !865)
!878 = !DILocalVariable(name: "A", scope: !865, file: !3, line: 360, type: !13)
!879 = !DILocation(line: 360, column: 11, scope: !865)
!880 = !DILocalVariable(name: "B", scope: !865, file: !3, line: 360, type: !13)
!881 = !DILocation(line: 360, column: 15, scope: !865)
!882 = !DILocalVariable(name: "C", scope: !865, file: !3, line: 360, type: !13)
!883 = !DILocation(line: 360, column: 19, scope: !865)
!884 = !DILocalVariable(name: "D", scope: !865, file: !3, line: 360, type: !13)
!885 = !DILocation(line: 360, column: 23, scope: !865)
!886 = !DILocalVariable(name: "tmpA", scope: !865, file: !3, line: 360, type: !13)
!887 = !DILocation(line: 360, column: 27, scope: !865)
!888 = !DILocalVariable(name: "tmpB", scope: !865, file: !3, line: 360, type: !13)
!889 = !DILocation(line: 360, column: 34, scope: !865)
!890 = !DILocalVariable(name: "tmpC", scope: !865, file: !3, line: 360, type: !13)
!891 = !DILocation(line: 360, column: 41, scope: !865)
!892 = !DILocalVariable(name: "tmpD", scope: !865, file: !3, line: 360, type: !13)
!893 = !DILocation(line: 360, column: 48, scope: !865)
!894 = !DILocation(line: 362, column: 10, scope: !895)
!895 = distinct !DILexicalBlock(scope: !865, file: !3, line: 362, column: 10)
!896 = !DILocation(line: 362, column: 17, scope: !895)
!897 = !DILocation(line: 362, column: 15, scope: !895)
!898 = !DILocation(line: 362, column: 10, scope: !865)
!899 = !DILocation(line: 364, column: 13, scope: !900)
!900 = distinct !DILexicalBlock(scope: !895, file: !3, line: 362, column: 42)
!901 = !DILocation(line: 364, column: 18, scope: !900)
!902 = !DILocation(line: 364, column: 24, scope: !900)
!903 = !DILocation(line: 364, column: 22, scope: !900)
!904 = !DILocation(line: 364, column: 29, scope: !900)
!905 = !DILocation(line: 364, column: 4, scope: !900)
!906 = !DILocation(line: 365, column: 4, scope: !900)
!907 = !DILocation(line: 367, column: 10, scope: !865)
!908 = !DILocation(line: 367, column: 8, scope: !865)
!909 = !DILocation(line: 368, column: 13, scope: !865)
!910 = !DILocation(line: 368, column: 11, scope: !865)
!911 = !DILocation(line: 369, column: 10, scope: !865)
!912 = !DILocation(line: 369, column: 14, scope: !865)
!913 = !DILocation(line: 369, column: 12, scope: !865)
!914 = !DILocation(line: 369, column: 8, scope: !865)
!915 = !DILocation(line: 370, column: 13, scope: !865)
!916 = !DILocation(line: 370, column: 20, scope: !865)
!917 = !DILocation(line: 370, column: 18, scope: !865)
!918 = !DILocation(line: 370, column: 11, scope: !865)
!919 = !DILocation(line: 371, column: 10, scope: !865)
!920 = !DILocation(line: 371, column: 14, scope: !865)
!921 = !DILocation(line: 371, column: 12, scope: !865)
!922 = !DILocation(line: 371, column: 8, scope: !865)
!923 = !DILocation(line: 372, column: 13, scope: !865)
!924 = !DILocation(line: 372, column: 20, scope: !865)
!925 = !DILocation(line: 372, column: 18, scope: !865)
!926 = !DILocation(line: 372, column: 11, scope: !865)
!927 = !DILocation(line: 373, column: 10, scope: !865)
!928 = !DILocation(line: 373, column: 14, scope: !865)
!929 = !DILocation(line: 373, column: 12, scope: !865)
!930 = !DILocation(line: 373, column: 8, scope: !865)
!931 = !DILocation(line: 374, column: 13, scope: !865)
!932 = !DILocation(line: 374, column: 20, scope: !865)
!933 = !DILocation(line: 374, column: 18, scope: !865)
!934 = !DILocation(line: 374, column: 11, scope: !865)
!935 = !DILocation(line: 376, column: 15, scope: !865)
!936 = !DILocation(line: 376, column: 18, scope: !865)
!937 = !DILocation(line: 376, column: 24, scope: !865)
!938 = !DILocation(line: 376, column: 6, scope: !865)
!939 = !DILocation(line: 377, column: 15, scope: !865)
!940 = !DILocation(line: 377, column: 18, scope: !865)
!941 = !DILocation(line: 377, column: 24, scope: !865)
!942 = !DILocation(line: 377, column: 6, scope: !865)
!943 = !DILocation(line: 378, column: 15, scope: !865)
!944 = !DILocation(line: 378, column: 18, scope: !865)
!945 = !DILocation(line: 378, column: 24, scope: !865)
!946 = !DILocation(line: 378, column: 6, scope: !865)
!947 = !DILocation(line: 379, column: 15, scope: !865)
!948 = !DILocation(line: 379, column: 18, scope: !865)
!949 = !DILocation(line: 379, column: 24, scope: !865)
!950 = !DILocation(line: 379, column: 35, scope: !865)
!951 = !DILocation(line: 379, column: 33, scope: !865)
!952 = !DILocation(line: 379, column: 29, scope: !865)
!953 = !DILocation(line: 379, column: 6, scope: !865)
!954 = !DILocation(line: 381, column: 16, scope: !865)
!955 = !DILocation(line: 381, column: 19, scope: !865)
!956 = !DILocation(line: 381, column: 23, scope: !865)
!957 = !DILocation(line: 381, column: 21, scope: !865)
!958 = !DILocation(line: 381, column: 31, scope: !865)
!959 = !DILocation(line: 381, column: 36, scope: !865)
!960 = !DILocation(line: 381, column: 39, scope: !865)
!961 = !DILocation(line: 381, column: 43, scope: !865)
!962 = !DILocation(line: 381, column: 41, scope: !865)
!963 = !DILocation(line: 381, column: 51, scope: !865)
!964 = !DILocation(line: 381, column: 56, scope: !865)
!965 = !DILocation(line: 381, column: 6, scope: !865)
!966 = !DILocation(line: 382, column: 16, scope: !865)
!967 = !DILocation(line: 382, column: 19, scope: !865)
!968 = !DILocation(line: 382, column: 23, scope: !865)
!969 = !DILocation(line: 382, column: 21, scope: !865)
!970 = !DILocation(line: 382, column: 31, scope: !865)
!971 = !DILocation(line: 382, column: 36, scope: !865)
!972 = !DILocation(line: 382, column: 39, scope: !865)
!973 = !DILocation(line: 382, column: 45, scope: !865)
!974 = !DILocation(line: 382, column: 43, scope: !865)
!975 = !DILocation(line: 382, column: 50, scope: !865)
!976 = !DILocation(line: 382, column: 55, scope: !865)
!977 = !DILocation(line: 382, column: 6, scope: !865)
!978 = !DILocation(line: 384, column: 16, scope: !865)
!979 = !DILocation(line: 384, column: 22, scope: !865)
!980 = !DILocation(line: 384, column: 27, scope: !865)
!981 = !DILocation(line: 384, column: 32, scope: !865)
!982 = !DILocation(line: 384, column: 38, scope: !865)
!983 = !DILocation(line: 384, column: 45, scope: !865)
!984 = !DILocation(line: 384, column: 43, scope: !865)
!985 = !DILocation(line: 384, column: 50, scope: !865)
!986 = !DILocation(line: 384, column: 55, scope: !865)
!987 = !DILocation(line: 384, column: 6, scope: !865)
!988 = !DILocation(line: 385, column: 1, scope: !865)
!989 = distinct !DISubprogram(name: "scramble_array", scope: !3, file: !3, line: 389, type: !990, scopeLine: 390, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !320)
!990 = !DISubroutineType(types: !991)
!991 = !{null}
!992 = !DILocalVariable(name: "i", scope: !989, file: !3, line: 391, type: !22)
!993 = !DILocation(line: 391, column: 20, scope: !989)
!994 = !DILocalVariable(name: "j", scope: !989, file: !3, line: 392, type: !22)
!995 = !DILocation(line: 392, column: 20, scope: !989)
!996 = !DILocation(line: 394, column: 13, scope: !997)
!997 = distinct !DILexicalBlock(scope: !989, file: !3, line: 394, column: 6)
!998 = !DILocation(line: 394, column: 11, scope: !997)
!999 = !DILocation(line: 394, column: 18, scope: !1000)
!1000 = distinct !DILexicalBlock(scope: !997, file: !3, line: 394, column: 6)
!1001 = !DILocation(line: 394, column: 22, scope: !1000)
!1002 = !DILocation(line: 394, column: 20, scope: !1000)
!1003 = !DILocation(line: 394, column: 6, scope: !997)
!1004 = !DILocation(line: 395, column: 8, scope: !1005)
!1005 = distinct !DILexicalBlock(scope: !1000, file: !3, line: 394, column: 42)
!1006 = !DILocation(line: 395, column: 6, scope: !1005)
!1007 = !DILocation(line: 396, column: 8, scope: !1005)
!1008 = !DILocation(line: 396, column: 12, scope: !1005)
!1009 = !DILocation(line: 396, column: 10, scope: !1005)
!1010 = !DILocation(line: 396, column: 6, scope: !1005)
!1011 = !DILocalVariable(name: "tmp", scope: !1012, file: !3, line: 397, type: !14)
!1012 = distinct !DILexicalBlock(scope: !1005, file: !3, line: 397, column: 4)
!1013 = !DILocation(line: 397, column: 4, scope: !1012)
!1014 = !DILocation(line: 398, column: 6, scope: !1005)
!1015 = !DILocation(line: 394, column: 37, scope: !1000)
!1016 = !DILocation(line: 394, column: 6, scope: !1000)
!1017 = distinct !{!1017, !1003, !1018}
!1018 = !DILocation(line: 398, column: 6, scope: !997)
!1019 = !DILocation(line: 399, column: 1, scope: !989)
!1020 = distinct !DISubprogram(name: "my_rand", scope: !3, file: !3, line: 72, type: !1021, scopeLine: 73, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !320)
!1021 = !DISubroutineType(types: !1022)
!1022 = !{!22}
!1023 = !DILocation(line: 74, column: 17, scope: !1020)
!1024 = !DILocation(line: 74, column: 26, scope: !1020)
!1025 = !DILocation(line: 74, column: 39, scope: !1020)
!1026 = !DILocation(line: 74, column: 15, scope: !1020)
!1027 = !DILocation(line: 75, column: 13, scope: !1020)
!1028 = !DILocation(line: 75, column: 6, scope: !1020)
!1029 = distinct !DISubprogram(name: "fill_array", scope: !3, file: !3, line: 401, type: !990, scopeLine: 402, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !320)
!1030 = !DILocalVariable(name: "i", scope: !1029, file: !3, line: 403, type: !22)
!1031 = !DILocation(line: 403, column: 20, scope: !1029)
!1032 = !DILocation(line: 405, column: 6, scope: !1029)
!1033 = !DILocation(line: 408, column: 13, scope: !1034)
!1034 = distinct !DILexicalBlock(scope: !1029, file: !3, line: 408, column: 6)
!1035 = !DILocation(line: 408, column: 11, scope: !1034)
!1036 = !DILocation(line: 408, column: 18, scope: !1037)
!1037 = distinct !DILexicalBlock(scope: !1034, file: !3, line: 408, column: 6)
!1038 = !DILocation(line: 408, column: 22, scope: !1037)
!1039 = !DILocation(line: 408, column: 20, scope: !1037)
!1040 = !DILocation(line: 408, column: 6, scope: !1034)
!1041 = !DILocation(line: 409, column: 15, scope: !1042)
!1042 = distinct !DILexicalBlock(scope: !1037, file: !3, line: 408, column: 42)
!1043 = !DILocation(line: 409, column: 4, scope: !1042)
!1044 = !DILocation(line: 409, column: 10, scope: !1042)
!1045 = !DILocation(line: 409, column: 13, scope: !1042)
!1046 = !DILocation(line: 410, column: 6, scope: !1042)
!1047 = !DILocation(line: 408, column: 37, scope: !1037)
!1048 = !DILocation(line: 408, column: 6, scope: !1037)
!1049 = distinct !{!1049, !1040, !1050}
!1050 = !DILocation(line: 410, column: 6, scope: !1034)
!1051 = !DILocation(line: 411, column: 1, scope: !1029)
!1052 = distinct !DISubprogram(name: "my_srand", scope: !3, file: !3, line: 78, type: !1053, scopeLine: 79, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !320)
!1053 = !DISubroutineType(types: !1054)
!1054 = !{null, !22}
!1055 = !DILocalVariable(name: "seed", arg: 1, scope: !1052, file: !3, line: 78, type: !22)
!1056 = !DILocation(line: 78, column: 43, scope: !1052)
!1057 = !DILocation(line: 80, column: 17, scope: !1052)
!1058 = !DILocation(line: 80, column: 15, scope: !1052)
!1059 = !DILocation(line: 81, column: 1, scope: !1052)
!1060 = distinct !DISubprogram(name: "sort_init", scope: !3, file: !3, line: 413, type: !990, scopeLine: 414, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !320)
!1061 = !DILocation(line: 416, column: 10, scope: !1062)
!1062 = distinct !DILexicalBlock(scope: !1060, file: !3, line: 416, column: 10)
!1063 = !DILocation(line: 416, column: 24, scope: !1062)
!1064 = !DILocation(line: 416, column: 10, scope: !1060)
!1065 = !DILocation(line: 417, column: 9, scope: !1066)
!1066 = distinct !DILexicalBlock(scope: !1067, file: !3, line: 417, column: 9)
!1067 = distinct !DILexicalBlock(scope: !1068, file: !3, line: 417, column: 9)
!1068 = distinct !DILexicalBlock(scope: !1062, file: !3, line: 416, column: 29)
!1069 = !DILocation(line: 417, column: 9, scope: !1067)
!1070 = !DILocation(line: 417, column: 9, scope: !1071)
!1071 = distinct !DILexicalBlock(scope: !1066, file: !3, line: 417, column: 9)
!1072 = !DILocation(line: 418, column: 23, scope: !1068)
!1073 = !DILocation(line: 419, column: 6, scope: !1068)
!1074 = !DILocation(line: 421, column: 10, scope: !1075)
!1075 = distinct !DILexicalBlock(scope: !1060, file: !3, line: 421, column: 10)
!1076 = !DILocation(line: 421, column: 32, scope: !1075)
!1077 = !DILocation(line: 421, column: 10, scope: !1060)
!1078 = !DILocation(line: 422, column: 9, scope: !1079)
!1079 = distinct !DILexicalBlock(scope: !1080, file: !3, line: 422, column: 9)
!1080 = distinct !DILexicalBlock(scope: !1081, file: !3, line: 422, column: 9)
!1081 = distinct !DILexicalBlock(scope: !1075, file: !3, line: 421, column: 37)
!1082 = !DILocation(line: 422, column: 9, scope: !1080)
!1083 = !DILocation(line: 422, column: 9, scope: !1084)
!1084 = distinct !DILexicalBlock(scope: !1079, file: !3, line: 422, column: 9)
!1085 = !DILocation(line: 423, column: 31, scope: !1081)
!1086 = !DILocation(line: 424, column: 6, scope: !1081)
!1087 = !DILocation(line: 425, column: 15, scope: !1088)
!1088 = distinct !DILexicalBlock(scope: !1075, file: !3, line: 425, column: 15)
!1089 = !DILocation(line: 425, column: 39, scope: !1088)
!1090 = !DILocation(line: 425, column: 37, scope: !1088)
!1091 = !DILocation(line: 425, column: 15, scope: !1075)
!1092 = !DILocation(line: 426, column: 9, scope: !1093)
!1093 = distinct !DILexicalBlock(scope: !1094, file: !3, line: 426, column: 9)
!1094 = distinct !DILexicalBlock(scope: !1095, file: !3, line: 426, column: 9)
!1095 = distinct !DILexicalBlock(scope: !1088, file: !3, line: 425, column: 55)
!1096 = !DILocation(line: 426, column: 9, scope: !1094)
!1097 = !DILocation(line: 426, column: 9, scope: !1098)
!1098 = distinct !DILexicalBlock(scope: !1093, file: !3, line: 426, column: 9)
!1099 = !DILocation(line: 427, column: 33, scope: !1095)
!1100 = !DILocation(line: 427, column: 31, scope: !1095)
!1101 = !DILocation(line: 428, column: 6, scope: !1095)
!1102 = !DILocation(line: 430, column: 10, scope: !1103)
!1103 = distinct !DILexicalBlock(scope: !1060, file: !3, line: 430, column: 10)
!1104 = !DILocation(line: 430, column: 36, scope: !1103)
!1105 = !DILocation(line: 430, column: 34, scope: !1103)
!1106 = !DILocation(line: 430, column: 10, scope: !1060)
!1107 = !DILocation(line: 431, column: 9, scope: !1108)
!1108 = distinct !DILexicalBlock(scope: !1109, file: !3, line: 431, column: 9)
!1109 = distinct !DILexicalBlock(scope: !1110, file: !3, line: 431, column: 9)
!1110 = distinct !DILexicalBlock(scope: !1103, file: !3, line: 430, column: 52)
!1111 = !DILocation(line: 431, column: 9, scope: !1109)
!1112 = !DILocation(line: 431, column: 9, scope: !1113)
!1113 = distinct !DILexicalBlock(scope: !1108, file: !3, line: 431, column: 9)
!1114 = !DILocation(line: 432, column: 35, scope: !1110)
!1115 = !DILocation(line: 432, column: 33, scope: !1110)
!1116 = !DILocation(line: 433, column: 6, scope: !1110)
!1117 = !DILocation(line: 434, column: 10, scope: !1118)
!1118 = distinct !DILexicalBlock(scope: !1060, file: !3, line: 434, column: 10)
!1119 = !DILocation(line: 434, column: 36, scope: !1118)
!1120 = !DILocation(line: 434, column: 34, scope: !1118)
!1121 = !DILocation(line: 434, column: 10, scope: !1060)
!1122 = !DILocation(line: 435, column: 9, scope: !1123)
!1123 = distinct !DILexicalBlock(scope: !1124, file: !3, line: 435, column: 9)
!1124 = distinct !DILexicalBlock(scope: !1125, file: !3, line: 435, column: 9)
!1125 = distinct !DILexicalBlock(scope: !1118, file: !3, line: 434, column: 52)
!1126 = !DILocation(line: 435, column: 9, scope: !1124)
!1127 = !DILocation(line: 435, column: 9, scope: !1128)
!1128 = distinct !DILexicalBlock(scope: !1123, file: !3, line: 435, column: 9)
!1129 = !DILocation(line: 436, column: 35, scope: !1125)
!1130 = !DILocation(line: 436, column: 33, scope: !1125)
!1131 = !DILocation(line: 437, column: 6, scope: !1125)
!1132 = !DILocation(line: 439, column: 10, scope: !1133)
!1133 = distinct !DILexicalBlock(scope: !1060, file: !3, line: 439, column: 10)
!1134 = !DILocation(line: 439, column: 36, scope: !1133)
!1135 = !DILocation(line: 439, column: 34, scope: !1133)
!1136 = !DILocation(line: 439, column: 10, scope: !1060)
!1137 = !DILocation(line: 440, column: 9, scope: !1138)
!1138 = distinct !DILexicalBlock(scope: !1139, file: !3, line: 440, column: 9)
!1139 = distinct !DILexicalBlock(scope: !1140, file: !3, line: 440, column: 9)
!1140 = distinct !DILexicalBlock(scope: !1133, file: !3, line: 439, column: 61)
!1141 = !DILocation(line: 440, column: 9, scope: !1139)
!1142 = !DILocation(line: 440, column: 9, scope: !1143)
!1143 = distinct !DILexicalBlock(scope: !1138, file: !3, line: 440, column: 9)
!1144 = !DILocation(line: 445, column: 35, scope: !1140)
!1145 = !DILocation(line: 445, column: 33, scope: !1140)
!1146 = !DILocation(line: 446, column: 6, scope: !1140)
!1147 = !DILocation(line: 448, column: 29, scope: !1060)
!1148 = !DILocation(line: 448, column: 43, scope: !1060)
!1149 = !DILocation(line: 448, column: 22, scope: !1060)
!1150 = !DILocation(line: 448, column: 14, scope: !1060)
!1151 = !DILocation(line: 448, column: 12, scope: !1060)
!1152 = !DILocation(line: 449, column: 27, scope: !1060)
!1153 = !DILocation(line: 449, column: 41, scope: !1060)
!1154 = !DILocation(line: 449, column: 20, scope: !1060)
!1155 = !DILocation(line: 449, column: 12, scope: !1060)
!1156 = !DILocation(line: 449, column: 10, scope: !1060)
!1157 = !DILocation(line: 451, column: 6, scope: !1060)
!1158 = !DILocation(line: 452, column: 6, scope: !1060)
!1159 = !DILocation(line: 453, column: 1, scope: !1060)
!1160 = distinct !DISubprogram(name: "sort", scope: !3, file: !3, line: 455, type: !990, scopeLine: 456, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !320)
!1161 = !DILocation(line: 457, column: 9, scope: !1162)
!1162 = distinct !DILexicalBlock(scope: !1163, file: !3, line: 457, column: 9)
!1163 = distinct !DILexicalBlock(scope: !1160, file: !3, line: 457, column: 9)
!1164 = !DILocation(line: 457, column: 9, scope: !1163)
!1165 = !DILocation(line: 457, column: 9, scope: !1166)
!1166 = distinct !DILexicalBlock(scope: !1162, file: !3, line: 457, column: 9)
!1167 = !DILocation(line: 458, column: 11, scope: !1160)
!1168 = !DILocation(line: 458, column: 18, scope: !1160)
!1169 = !DILocation(line: 458, column: 23, scope: !1160)
!1170 = !DILocation(line: 458, column: 2, scope: !1160)
!1171 = !DILocation(line: 459, column: 2, scope: !1172)
!1172 = distinct !DILexicalBlock(scope: !1173, file: !3, line: 459, column: 2)
!1173 = distinct !DILexicalBlock(scope: !1160, file: !3, line: 459, column: 2)
!1174 = !DILocation(line: 459, column: 2, scope: !1173)
!1175 = !DILocation(line: 459, column: 2, scope: !1176)
!1176 = distinct !DILexicalBlock(scope: !1172, file: !3, line: 459, column: 2)
!1177 = !DILocation(line: 460, column: 1, scope: !1160)
!1178 = distinct !DISubprogram(name: "sort_verify", scope: !3, file: !3, line: 462, type: !1179, scopeLine: 463, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !320)
!1179 = !DISubroutineType(types: !1180)
!1180 = !{!33}
!1181 = !DILocalVariable(name: "i", scope: !1178, file: !3, line: 464, type: !33)
!1182 = !DILocation(line: 464, column: 10, scope: !1178)
!1183 = !DILocalVariable(name: "success", scope: !1178, file: !3, line: 464, type: !33)
!1184 = !DILocation(line: 464, column: 13, scope: !1178)
!1185 = !DILocation(line: 465, column: 13, scope: !1186)
!1186 = distinct !DILexicalBlock(scope: !1178, file: !3, line: 465, column: 6)
!1187 = !DILocation(line: 465, column: 11, scope: !1186)
!1188 = !DILocation(line: 465, column: 18, scope: !1189)
!1189 = distinct !DILexicalBlock(scope: !1186, file: !3, line: 465, column: 6)
!1190 = !DILocation(line: 465, column: 22, scope: !1189)
!1191 = !DILocation(line: 465, column: 20, scope: !1189)
!1192 = !DILocation(line: 465, column: 6, scope: !1186)
!1193 = !DILocation(line: 466, column: 8, scope: !1194)
!1194 = distinct !DILexicalBlock(scope: !1189, file: !3, line: 466, column: 8)
!1195 = !DILocation(line: 466, column: 14, scope: !1194)
!1196 = !DILocation(line: 466, column: 20, scope: !1194)
!1197 = !DILocation(line: 466, column: 17, scope: !1194)
!1198 = !DILocation(line: 466, column: 8, scope: !1189)
!1199 = !DILocation(line: 466, column: 31, scope: !1194)
!1200 = !DILocation(line: 466, column: 23, scope: !1194)
!1201 = !DILocation(line: 465, column: 37, scope: !1189)
!1202 = !DILocation(line: 465, column: 6, scope: !1189)
!1203 = distinct !{!1203, !1192, !1204}
!1204 = !DILocation(line: 466, column: 33, scope: !1186)
!1205 = !DILocation(line: 468, column: 13, scope: !1178)
!1206 = !DILocation(line: 468, column: 6, scope: !1178)
!1207 = distinct !DISubprogram(name: "bots_error", scope: !90, file: !90, line: 35, type: !1208, scopeLine: 36, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !89, retainedNodes: !320)
!1208 = !DISubroutineType(types: !1209)
!1209 = !{null, !33, !1210}
!1210 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !60, size: 64)
!1211 = !DILocalVariable(name: "error", arg: 1, scope: !1207, file: !90, line: 35, type: !33)
!1212 = !DILocation(line: 35, column: 16, scope: !1207)
!1213 = !DILocalVariable(name: "message", arg: 2, scope: !1207, file: !90, line: 35, type: !1210)
!1214 = !DILocation(line: 35, column: 29, scope: !1207)
!1215 = !DILocation(line: 37, column: 8, scope: !1216)
!1216 = distinct !DILexicalBlock(scope: !1207, file: !90, line: 37, column: 8)
!1217 = !DILocation(line: 37, column: 16, scope: !1216)
!1218 = !DILocation(line: 37, column: 8, scope: !1207)
!1219 = !DILocation(line: 39, column: 14, scope: !1220)
!1220 = distinct !DILexicalBlock(scope: !1216, file: !90, line: 38, column: 4)
!1221 = !DILocation(line: 39, column: 7, scope: !1220)
!1222 = !DILocation(line: 42, column: 21, scope: !1223)
!1223 = distinct !DILexicalBlock(scope: !1220, file: !90, line: 40, column: 7)
!1224 = !DILocation(line: 42, column: 48, scope: !1223)
!1225 = !DILocation(line: 42, column: 13, scope: !1223)
!1226 = !DILocation(line: 43, column: 13, scope: !1223)
!1227 = !DILocation(line: 45, column: 21, scope: !1223)
!1228 = !DILocation(line: 45, column: 48, scope: !1223)
!1229 = !DILocation(line: 45, column: 13, scope: !1223)
!1230 = !DILocation(line: 46, column: 13, scope: !1223)
!1231 = !DILocation(line: 48, column: 21, scope: !1223)
!1232 = !DILocation(line: 48, column: 48, scope: !1223)
!1233 = !DILocation(line: 48, column: 13, scope: !1223)
!1234 = !DILocation(line: 49, column: 13, scope: !1223)
!1235 = !DILocation(line: 50, column: 13, scope: !1223)
!1236 = !DILocation(line: 52, column: 21, scope: !1223)
!1237 = !DILocation(line: 52, column: 48, scope: !1223)
!1238 = !DILocation(line: 52, column: 13, scope: !1223)
!1239 = !DILocation(line: 53, column: 13, scope: !1223)
!1240 = !DILocation(line: 55, column: 4, scope: !1220)
!1241 = !DILocation(line: 56, column: 17, scope: !1216)
!1242 = !DILocation(line: 56, column: 44, scope: !1216)
!1243 = !DILocation(line: 56, column: 50, scope: !1216)
!1244 = !DILocation(line: 56, column: 9, scope: !1216)
!1245 = !DILocation(line: 57, column: 13, scope: !1207)
!1246 = !DILocation(line: 57, column: 12, scope: !1207)
!1247 = !DILocation(line: 57, column: 4, scope: !1207)
!1248 = !DILocation(line: 58, column: 1, scope: !1207)
!1249 = distinct !DISubprogram(name: "bots_warning", scope: !90, file: !90, line: 61, type: !1208, scopeLine: 62, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !89, retainedNodes: !320)
!1250 = !DILocalVariable(name: "warning", arg: 1, scope: !1249, file: !90, line: 61, type: !33)
!1251 = !DILocation(line: 61, column: 18, scope: !1249)
!1252 = !DILocalVariable(name: "message", arg: 2, scope: !1249, file: !90, line: 61, type: !1210)
!1253 = !DILocation(line: 61, column: 33, scope: !1249)
!1254 = !DILocation(line: 63, column: 8, scope: !1255)
!1255 = distinct !DILexicalBlock(scope: !1249, file: !90, line: 63, column: 8)
!1256 = !DILocation(line: 63, column: 16, scope: !1255)
!1257 = !DILocation(line: 63, column: 8, scope: !1249)
!1258 = !DILocation(line: 65, column: 14, scope: !1259)
!1259 = distinct !DILexicalBlock(scope: !1255, file: !90, line: 64, column: 4)
!1260 = !DILocation(line: 65, column: 7, scope: !1259)
!1261 = !DILocation(line: 68, column: 21, scope: !1262)
!1262 = distinct !DILexicalBlock(scope: !1259, file: !90, line: 66, column: 7)
!1263 = !DILocation(line: 68, column: 50, scope: !1262)
!1264 = !DILocation(line: 68, column: 13, scope: !1262)
!1265 = !DILocation(line: 69, column: 13, scope: !1262)
!1266 = !DILocation(line: 71, column: 21, scope: !1262)
!1267 = !DILocation(line: 71, column: 50, scope: !1262)
!1268 = !DILocation(line: 71, column: 13, scope: !1262)
!1269 = !DILocation(line: 72, column: 13, scope: !1262)
!1270 = !DILocation(line: 74, column: 4, scope: !1259)
!1271 = !DILocation(line: 75, column: 17, scope: !1255)
!1272 = !DILocation(line: 75, column: 46, scope: !1255)
!1273 = !DILocation(line: 75, column: 54, scope: !1255)
!1274 = !DILocation(line: 75, column: 9, scope: !1255)
!1275 = !DILocation(line: 76, column: 1, scope: !1249)
!1276 = distinct !DISubprogram(name: "bots_usecs", scope: !90, file: !90, line: 78, type: !1277, scopeLine: 79, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !89, retainedNodes: !320)
!1277 = !DISubroutineType(types: !1278)
!1278 = !{!16}
!1279 = !DILocalVariable(name: "t", scope: !1276, file: !90, line: 80, type: !1280)
!1280 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "timeval", file: !1281, line: 8, size: 128, elements: !1282)
!1281 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/struct_timeval.h", directory: "")
!1282 = !{!1283, !1286}
!1283 = !DIDerivedType(tag: DW_TAG_member, name: "tv_sec", scope: !1280, file: !1281, line: 10, baseType: !1284, size: 64)
!1284 = !DIDerivedType(tag: DW_TAG_typedef, name: "__time_t", file: !1285, line: 160, baseType: !16)
!1285 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!1286 = !DIDerivedType(tag: DW_TAG_member, name: "tv_usec", scope: !1280, file: !1281, line: 11, baseType: !1287, size: 64, offset: 64)
!1287 = !DIDerivedType(tag: DW_TAG_typedef, name: "__suseconds_t", file: !1285, line: 162, baseType: !16)
!1288 = !DILocation(line: 80, column: 19, scope: !1276)
!1289 = !DILocation(line: 81, column: 4, scope: !1276)
!1290 = !DILocation(line: 82, column: 13, scope: !1276)
!1291 = !DILocation(line: 82, column: 19, scope: !1276)
!1292 = !DILocation(line: 82, column: 30, scope: !1276)
!1293 = !DILocation(line: 82, column: 27, scope: !1276)
!1294 = !DILocation(line: 82, column: 4, scope: !1276)
!1295 = distinct !DISubprogram(name: "bots_get_date", scope: !90, file: !90, line: 86, type: !1296, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !89, retainedNodes: !320)
!1296 = !DISubroutineType(types: !1297)
!1297 = !{null, !1210}
!1298 = !DILocalVariable(name: "str", arg: 1, scope: !1295, file: !90, line: 86, type: !1210)
!1299 = !DILocation(line: 86, column: 21, scope: !1295)
!1300 = !DILocalVariable(name: "now", scope: !1295, file: !90, line: 88, type: !1301)
!1301 = !DIDerivedType(tag: DW_TAG_typedef, name: "time_t", file: !1302, line: 7, baseType: !1284)
!1302 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/time_t.h", directory: "")
!1303 = !DILocation(line: 88, column: 11, scope: !1295)
!1304 = !DILocation(line: 89, column: 4, scope: !1295)
!1305 = !DILocation(line: 90, column: 13, scope: !1295)
!1306 = !DILocation(line: 90, column: 40, scope: !1295)
!1307 = !DILocation(line: 90, column: 4, scope: !1295)
!1308 = !DILocation(line: 91, column: 1, scope: !1295)
!1309 = distinct !DISubprogram(name: "bots_get_architecture", scope: !90, file: !90, line: 93, type: !1296, scopeLine: 94, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !89, retainedNodes: !320)
!1310 = !DILocalVariable(name: "str", arg: 1, scope: !1309, file: !90, line: 93, type: !1210)
!1311 = !DILocation(line: 93, column: 34, scope: !1309)
!1312 = !DILocalVariable(name: "ncpus", scope: !1309, file: !90, line: 95, type: !33)
!1313 = !DILocation(line: 95, column: 8, scope: !1309)
!1314 = !DILocation(line: 95, column: 16, scope: !1309)
!1315 = !DILocalVariable(name: "architecture", scope: !1309, file: !90, line: 96, type: !1316)
!1316 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "utsname", file: !1317, line: 48, size: 3120, elements: !1318)
!1317 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/sys/utsname.h", directory: "")
!1318 = !{!1319, !1323, !1324, !1325, !1326, !1327}
!1319 = !DIDerivedType(tag: DW_TAG_member, name: "sysname", scope: !1316, file: !1317, line: 51, baseType: !1320, size: 520)
!1320 = !DICompositeType(tag: DW_TAG_array_type, baseType: !60, size: 520, elements: !1321)
!1321 = !{!1322}
!1322 = !DISubrange(count: 65)
!1323 = !DIDerivedType(tag: DW_TAG_member, name: "nodename", scope: !1316, file: !1317, line: 54, baseType: !1320, size: 520, offset: 520)
!1324 = !DIDerivedType(tag: DW_TAG_member, name: "release", scope: !1316, file: !1317, line: 57, baseType: !1320, size: 520, offset: 1040)
!1325 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !1316, file: !1317, line: 59, baseType: !1320, size: 520, offset: 1560)
!1326 = !DIDerivedType(tag: DW_TAG_member, name: "machine", scope: !1316, file: !1317, line: 62, baseType: !1320, size: 520, offset: 2080)
!1327 = !DIDerivedType(tag: DW_TAG_member, name: "__domainname", scope: !1316, file: !1317, line: 69, baseType: !1320, size: 520, offset: 2600)
!1328 = !DILocation(line: 96, column: 19, scope: !1309)
!1329 = !DILocation(line: 98, column: 4, scope: !1309)
!1330 = !DILocation(line: 99, column: 13, scope: !1309)
!1331 = !DILocation(line: 99, column: 60, scope: !1309)
!1332 = !DILocation(line: 99, column: 47, scope: !1309)
!1333 = !DILocation(line: 99, column: 82, scope: !1309)
!1334 = !DILocation(line: 99, column: 69, scope: !1309)
!1335 = !DILocation(line: 99, column: 91, scope: !1309)
!1336 = !DILocation(line: 99, column: 4, scope: !1309)
!1337 = !DILocation(line: 100, column: 1, scope: !1309)
!1338 = distinct !DISubprogram(name: "bots_get_load_average", scope: !90, file: !90, line: 104, type: !1296, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !89, retainedNodes: !320)
!1339 = !DILocalVariable(name: "str", arg: 1, scope: !1338, file: !90, line: 104, type: !1210)
!1340 = !DILocation(line: 104, column: 34, scope: !1338)
!1341 = !DILocalVariable(name: "loadavg", scope: !1338, file: !90, line: 106, type: !1342)
!1342 = !DICompositeType(tag: DW_TAG_array_type, baseType: !29, size: 192, elements: !1343)
!1343 = !{!1344}
!1344 = !DISubrange(count: 3)
!1345 = !DILocation(line: 106, column: 11, scope: !1338)
!1346 = !DILocation(line: 107, column: 16, scope: !1338)
!1347 = !DILocation(line: 107, column: 4, scope: !1338)
!1348 = !DILocation(line: 108, column: 13, scope: !1338)
!1349 = !DILocation(line: 108, column: 52, scope: !1338)
!1350 = !DILocation(line: 108, column: 63, scope: !1338)
!1351 = !DILocation(line: 108, column: 74, scope: !1338)
!1352 = !DILocation(line: 108, column: 4, scope: !1338)
!1353 = !DILocation(line: 109, column: 1, scope: !1338)
!1354 = distinct !DISubprogram(name: "bots_print_results", scope: !90, file: !90, line: 115, type: !990, scopeLine: 116, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !89, retainedNodes: !320)
!1355 = !DILocalVariable(name: "str_name", scope: !1354, file: !90, line: 117, type: !59)
!1356 = !DILocation(line: 117, column: 9, scope: !1354)
!1357 = !DILocalVariable(name: "str_parameters", scope: !1354, file: !90, line: 118, type: !59)
!1358 = !DILocation(line: 118, column: 9, scope: !1354)
!1359 = !DILocalVariable(name: "str_model", scope: !1354, file: !90, line: 119, type: !59)
!1360 = !DILocation(line: 119, column: 9, scope: !1354)
!1361 = !DILocalVariable(name: "str_resources", scope: !1354, file: !90, line: 120, type: !59)
!1362 = !DILocation(line: 120, column: 9, scope: !1354)
!1363 = !DILocalVariable(name: "str_result", scope: !1354, file: !90, line: 121, type: !1364)
!1364 = !DICompositeType(tag: DW_TAG_array_type, baseType: !60, size: 120, elements: !1365)
!1365 = !{!1366}
!1366 = !DISubrange(count: 15)
!1367 = !DILocation(line: 121, column: 9, scope: !1354)
!1368 = !DILocalVariable(name: "str_time_program", scope: !1354, file: !90, line: 122, type: !1364)
!1369 = !DILocation(line: 122, column: 9, scope: !1354)
!1370 = !DILocalVariable(name: "str_time_sequential", scope: !1354, file: !90, line: 123, type: !1364)
!1371 = !DILocation(line: 123, column: 9, scope: !1354)
!1372 = !DILocalVariable(name: "str_speed_up", scope: !1354, file: !90, line: 124, type: !1364)
!1373 = !DILocation(line: 124, column: 9, scope: !1354)
!1374 = !DILocalVariable(name: "str_number_of_tasks", scope: !1354, file: !90, line: 125, type: !1364)
!1375 = !DILocation(line: 125, column: 9, scope: !1354)
!1376 = !DILocalVariable(name: "str_number_of_tasks_per_second", scope: !1354, file: !90, line: 126, type: !1364)
!1377 = !DILocation(line: 126, column: 9, scope: !1354)
!1378 = !DILocalVariable(name: "str_exec_date", scope: !1354, file: !90, line: 127, type: !59)
!1379 = !DILocation(line: 127, column: 9, scope: !1354)
!1380 = !DILocalVariable(name: "str_exec_message", scope: !1354, file: !90, line: 128, type: !59)
!1381 = !DILocation(line: 128, column: 9, scope: !1354)
!1382 = !DILocalVariable(name: "str_architecture", scope: !1354, file: !90, line: 129, type: !59)
!1383 = !DILocation(line: 129, column: 9, scope: !1354)
!1384 = !DILocalVariable(name: "str_load_avg", scope: !1354, file: !90, line: 130, type: !59)
!1385 = !DILocation(line: 130, column: 9, scope: !1354)
!1386 = !DILocalVariable(name: "str_comp_date", scope: !1354, file: !90, line: 131, type: !59)
!1387 = !DILocation(line: 131, column: 9, scope: !1354)
!1388 = !DILocalVariable(name: "str_comp_message", scope: !1354, file: !90, line: 132, type: !59)
!1389 = !DILocation(line: 132, column: 9, scope: !1354)
!1390 = !DILocalVariable(name: "str_cc", scope: !1354, file: !90, line: 133, type: !59)
!1391 = !DILocation(line: 133, column: 9, scope: !1354)
!1392 = !DILocalVariable(name: "str_cflags", scope: !1354, file: !90, line: 134, type: !59)
!1393 = !DILocation(line: 134, column: 9, scope: !1354)
!1394 = !DILocalVariable(name: "str_ld", scope: !1354, file: !90, line: 135, type: !59)
!1395 = !DILocation(line: 135, column: 9, scope: !1354)
!1396 = !DILocalVariable(name: "str_ldflags", scope: !1354, file: !90, line: 136, type: !59)
!1397 = !DILocation(line: 136, column: 9, scope: !1354)
!1398 = !DILocalVariable(name: "str_cutoff", scope: !1354, file: !90, line: 137, type: !59)
!1399 = !DILocation(line: 137, column: 9, scope: !1354)
!1400 = !DILocation(line: 140, column: 12, scope: !1354)
!1401 = !DILocation(line: 140, column: 4, scope: !1354)
!1402 = !DILocation(line: 141, column: 12, scope: !1354)
!1403 = !DILocation(line: 141, column: 4, scope: !1354)
!1404 = !DILocation(line: 142, column: 12, scope: !1354)
!1405 = !DILocation(line: 142, column: 4, scope: !1354)
!1406 = !DILocation(line: 143, column: 12, scope: !1354)
!1407 = !DILocation(line: 143, column: 4, scope: !1354)
!1408 = !DILocation(line: 144, column: 12, scope: !1354)
!1409 = !DILocation(line: 144, column: 4, scope: !1354)
!1410 = !DILocation(line: 145, column: 11, scope: !1354)
!1411 = !DILocation(line: 145, column: 4, scope: !1354)
!1412 = !DILocation(line: 148, column: 18, scope: !1413)
!1413 = distinct !DILexicalBlock(scope: !1354, file: !90, line: 146, column: 4)
!1414 = !DILocation(line: 148, column: 10, scope: !1413)
!1415 = !DILocation(line: 149, column: 10, scope: !1413)
!1416 = !DILocation(line: 151, column: 18, scope: !1413)
!1417 = !DILocation(line: 151, column: 10, scope: !1413)
!1418 = !DILocation(line: 152, column: 10, scope: !1413)
!1419 = !DILocation(line: 154, column: 18, scope: !1413)
!1420 = !DILocation(line: 154, column: 10, scope: !1413)
!1421 = !DILocation(line: 155, column: 10, scope: !1413)
!1422 = !DILocation(line: 157, column: 18, scope: !1413)
!1423 = !DILocation(line: 157, column: 10, scope: !1413)
!1424 = !DILocation(line: 158, column: 10, scope: !1413)
!1425 = !DILocation(line: 160, column: 18, scope: !1413)
!1426 = !DILocation(line: 160, column: 10, scope: !1413)
!1427 = !DILocation(line: 161, column: 10, scope: !1413)
!1428 = !DILocation(line: 163, column: 12, scope: !1354)
!1429 = !DILocation(line: 163, column: 36, scope: !1354)
!1430 = !DILocation(line: 163, column: 4, scope: !1354)
!1431 = !DILocation(line: 164, column: 8, scope: !1432)
!1432 = distinct !DILexicalBlock(scope: !1354, file: !90, line: 164, column: 8)
!1433 = !DILocation(line: 164, column: 8, scope: !1354)
!1434 = !DILocation(line: 164, column: 38, scope: !1432)
!1435 = !DILocation(line: 164, column: 65, scope: !1432)
!1436 = !DILocation(line: 164, column: 30, scope: !1432)
!1437 = !DILocation(line: 165, column: 17, scope: !1432)
!1438 = !DILocation(line: 165, column: 9, scope: !1432)
!1439 = !DILocation(line: 166, column: 8, scope: !1440)
!1440 = distinct !DILexicalBlock(scope: !1354, file: !90, line: 166, column: 8)
!1441 = !DILocation(line: 166, column: 8, scope: !1354)
!1442 = !DILocation(line: 167, column: 12, scope: !1440)
!1443 = !DILocation(line: 167, column: 35, scope: !1440)
!1444 = !DILocation(line: 167, column: 56, scope: !1440)
!1445 = !DILocation(line: 167, column: 55, scope: !1440)
!1446 = !DILocation(line: 167, column: 4, scope: !1440)
!1447 = !DILocation(line: 168, column: 17, scope: !1440)
!1448 = !DILocation(line: 168, column: 9, scope: !1440)
!1449 = !DILocation(line: 170, column: 12, scope: !1354)
!1450 = !DILocation(line: 170, column: 50, scope: !1354)
!1451 = !DILocation(line: 170, column: 42, scope: !1354)
!1452 = !DILocation(line: 170, column: 4, scope: !1354)
!1453 = !DILocation(line: 171, column: 12, scope: !1354)
!1454 = !DILocation(line: 171, column: 61, scope: !1354)
!1455 = !DILocation(line: 171, column: 53, scope: !1354)
!1456 = !DILocation(line: 171, column: 82, scope: !1354)
!1457 = !DILocation(line: 171, column: 81, scope: !1354)
!1458 = !DILocation(line: 171, column: 4, scope: !1354)
!1459 = !DILocation(line: 173, column: 12, scope: !1354)
!1460 = !DILocation(line: 173, column: 4, scope: !1354)
!1461 = !DILocation(line: 174, column: 12, scope: !1354)
!1462 = !DILocation(line: 174, column: 4, scope: !1354)
!1463 = !DILocation(line: 175, column: 26, scope: !1354)
!1464 = !DILocation(line: 175, column: 4, scope: !1354)
!1465 = !DILocation(line: 176, column: 26, scope: !1354)
!1466 = !DILocation(line: 176, column: 4, scope: !1354)
!1467 = !DILocation(line: 177, column: 12, scope: !1354)
!1468 = !DILocation(line: 177, column: 4, scope: !1354)
!1469 = !DILocation(line: 178, column: 12, scope: !1354)
!1470 = !DILocation(line: 178, column: 4, scope: !1354)
!1471 = !DILocation(line: 179, column: 12, scope: !1354)
!1472 = !DILocation(line: 179, column: 4, scope: !1354)
!1473 = !DILocation(line: 180, column: 12, scope: !1354)
!1474 = !DILocation(line: 180, column: 4, scope: !1354)
!1475 = !DILocation(line: 181, column: 12, scope: !1354)
!1476 = !DILocation(line: 181, column: 4, scope: !1354)
!1477 = !DILocation(line: 182, column: 12, scope: !1354)
!1478 = !DILocation(line: 182, column: 4, scope: !1354)
!1479 = !DILocation(line: 184, column: 7, scope: !1480)
!1480 = distinct !DILexicalBlock(scope: !1354, file: !90, line: 184, column: 7)
!1481 = !DILocation(line: 184, column: 7, scope: !1354)
!1482 = !DILocation(line: 186, column: 14, scope: !1483)
!1483 = distinct !DILexicalBlock(scope: !1480, file: !90, line: 185, column: 4)
!1484 = !DILocation(line: 186, column: 7, scope: !1483)
!1485 = !DILocation(line: 189, column: 13, scope: !1486)
!1486 = distinct !DILexicalBlock(scope: !1483, file: !90, line: 187, column: 7)
!1487 = !DILocation(line: 191, column: 13, scope: !1486)
!1488 = !DILocation(line: 193, column: 9, scope: !1486)
!1489 = !DILocation(line: 193, column: 1, scope: !1486)
!1490 = !DILocation(line: 200, column: 13, scope: !1486)
!1491 = !DILocation(line: 202, column: 13, scope: !1486)
!1492 = !DILocation(line: 204, column: 9, scope: !1486)
!1493 = !DILocation(line: 204, column: 1, scope: !1486)
!1494 = !DILocation(line: 208, column: 13, scope: !1486)
!1495 = !DILocation(line: 210, column: 13, scope: !1486)
!1496 = !DILocation(line: 212, column: 4, scope: !1483)
!1497 = !DILocation(line: 215, column: 11, scope: !1354)
!1498 = !DILocation(line: 215, column: 4, scope: !1354)
!1499 = !DILocation(line: 218, column: 10, scope: !1500)
!1500 = distinct !DILexicalBlock(scope: !1354, file: !90, line: 216, column: 4)
!1501 = !DILocation(line: 220, column: 11, scope: !1500)
!1502 = !DILocation(line: 220, column: 3, scope: !1500)
!1503 = !DILocation(line: 221, column: 18, scope: !1500)
!1504 = !DILocation(line: 221, column: 56, scope: !1500)
!1505 = !DILocation(line: 221, column: 10, scope: !1500)
!1506 = !DILocation(line: 222, column: 18, scope: !1500)
!1507 = !DILocation(line: 222, column: 56, scope: !1500)
!1508 = !DILocation(line: 222, column: 10, scope: !1500)
!1509 = !DILocation(line: 223, column: 18, scope: !1500)
!1510 = !DILocation(line: 223, column: 56, scope: !1500)
!1511 = !DILocation(line: 223, column: 10, scope: !1500)
!1512 = !DILocation(line: 224, column: 18, scope: !1500)
!1513 = !DILocation(line: 224, column: 56, scope: !1500)
!1514 = !DILocation(line: 224, column: 10, scope: !1500)
!1515 = !DILocation(line: 225, column: 18, scope: !1500)
!1516 = !DILocation(line: 225, column: 56, scope: !1500)
!1517 = !DILocation(line: 225, column: 10, scope: !1500)
!1518 = !DILocation(line: 226, column: 18, scope: !1500)
!1519 = !DILocation(line: 226, column: 56, scope: !1500)
!1520 = !DILocation(line: 226, column: 10, scope: !1500)
!1521 = !DILocation(line: 228, column: 18, scope: !1500)
!1522 = !DILocation(line: 228, column: 64, scope: !1500)
!1523 = !DILocation(line: 228, column: 10, scope: !1500)
!1524 = !DILocation(line: 229, column: 7, scope: !1525)
!1525 = distinct !DILexicalBlock(scope: !1500, file: !90, line: 229, column: 7)
!1526 = !DILocation(line: 229, column: 7, scope: !1500)
!1527 = !DILocation(line: 230, column: 20, scope: !1528)
!1528 = distinct !DILexicalBlock(scope: !1525, file: !90, line: 229, column: 29)
!1529 = !DILocation(line: 230, column: 66, scope: !1528)
!1530 = !DILocation(line: 230, column: 12, scope: !1528)
!1531 = !DILocation(line: 231, column: 20, scope: !1528)
!1532 = !DILocation(line: 231, column: 58, scope: !1528)
!1533 = !DILocation(line: 231, column: 12, scope: !1528)
!1534 = !DILocation(line: 232, column: 3, scope: !1528)
!1535 = !DILocation(line: 234, column: 15, scope: !1536)
!1536 = distinct !DILexicalBlock(scope: !1500, file: !90, line: 234, column: 15)
!1537 = !DILocation(line: 234, column: 36, scope: !1536)
!1538 = !DILocation(line: 234, column: 15, scope: !1500)
!1539 = !DILocation(line: 235, column: 20, scope: !1540)
!1540 = distinct !DILexicalBlock(scope: !1536, file: !90, line: 234, column: 42)
!1541 = !DILocation(line: 235, column: 58, scope: !1540)
!1542 = !DILocation(line: 235, column: 12, scope: !1540)
!1543 = !DILocation(line: 236, column: 20, scope: !1540)
!1544 = !DILocation(line: 236, column: 58, scope: !1540)
!1545 = !DILocation(line: 236, column: 12, scope: !1540)
!1546 = !DILocation(line: 237, column: 3, scope: !1540)
!1547 = !DILocation(line: 239, column: 18, scope: !1500)
!1548 = !DILocation(line: 239, column: 56, scope: !1500)
!1549 = !DILocation(line: 239, column: 10, scope: !1500)
!1550 = !DILocation(line: 240, column: 18, scope: !1500)
!1551 = !DILocation(line: 240, column: 56, scope: !1500)
!1552 = !DILocation(line: 240, column: 10, scope: !1500)
!1553 = !DILocation(line: 242, column: 18, scope: !1500)
!1554 = !DILocation(line: 242, column: 56, scope: !1500)
!1555 = !DILocation(line: 242, column: 10, scope: !1500)
!1556 = !DILocation(line: 243, column: 18, scope: !1500)
!1557 = !DILocation(line: 243, column: 56, scope: !1500)
!1558 = !DILocation(line: 243, column: 10, scope: !1500)
!1559 = !DILocation(line: 245, column: 18, scope: !1500)
!1560 = !DILocation(line: 245, column: 56, scope: !1500)
!1561 = !DILocation(line: 245, column: 10, scope: !1500)
!1562 = !DILocation(line: 246, column: 18, scope: !1500)
!1563 = !DILocation(line: 246, column: 56, scope: !1500)
!1564 = !DILocation(line: 246, column: 10, scope: !1500)
!1565 = !DILocation(line: 248, column: 18, scope: !1500)
!1566 = !DILocation(line: 248, column: 56, scope: !1500)
!1567 = !DILocation(line: 248, column: 10, scope: !1500)
!1568 = !DILocation(line: 249, column: 18, scope: !1500)
!1569 = !DILocation(line: 249, column: 56, scope: !1500)
!1570 = !DILocation(line: 249, column: 10, scope: !1500)
!1571 = !DILocation(line: 250, column: 18, scope: !1500)
!1572 = !DILocation(line: 250, column: 56, scope: !1500)
!1573 = !DILocation(line: 250, column: 10, scope: !1500)
!1574 = !DILocation(line: 251, column: 18, scope: !1500)
!1575 = !DILocation(line: 251, column: 56, scope: !1500)
!1576 = !DILocation(line: 251, column: 10, scope: !1500)
!1577 = !DILocation(line: 252, column: 10, scope: !1500)
!1578 = !DILocation(line: 252, column: 3, scope: !1500)
!1579 = !DILocation(line: 253, column: 10, scope: !1500)
!1580 = !DILocation(line: 255, column: 18, scope: !1500)
!1581 = !DILocation(line: 256, column: 15, scope: !1500)
!1582 = !DILocation(line: 257, column: 15, scope: !1500)
!1583 = !DILocation(line: 258, column: 15, scope: !1500)
!1584 = !DILocation(line: 259, column: 15, scope: !1500)
!1585 = !DILocation(line: 260, column: 15, scope: !1500)
!1586 = !DILocation(line: 261, column: 15, scope: !1500)
!1587 = !DILocation(line: 255, column: 10, scope: !1500)
!1588 = !DILocation(line: 263, column: 18, scope: !1500)
!1589 = !DILocation(line: 264, column: 15, scope: !1500)
!1590 = !DILocation(line: 265, column: 15, scope: !1500)
!1591 = !DILocation(line: 266, column: 15, scope: !1500)
!1592 = !DILocation(line: 263, column: 10, scope: !1500)
!1593 = !DILocation(line: 268, column: 18, scope: !1500)
!1594 = !DILocation(line: 269, column: 15, scope: !1500)
!1595 = !DILocation(line: 270, column: 15, scope: !1500)
!1596 = !DILocation(line: 268, column: 10, scope: !1500)
!1597 = !DILocation(line: 272, column: 18, scope: !1500)
!1598 = !DILocation(line: 273, column: 15, scope: !1500)
!1599 = !DILocation(line: 274, column: 15, scope: !1500)
!1600 = !DILocation(line: 272, column: 10, scope: !1500)
!1601 = !DILocation(line: 276, column: 18, scope: !1500)
!1602 = !DILocation(line: 277, column: 15, scope: !1500)
!1603 = !DILocation(line: 278, column: 15, scope: !1500)
!1604 = !DILocation(line: 276, column: 10, scope: !1500)
!1605 = !DILocation(line: 280, column: 18, scope: !1500)
!1606 = !DILocation(line: 281, column: 15, scope: !1500)
!1607 = !DILocation(line: 282, column: 15, scope: !1500)
!1608 = !DILocation(line: 280, column: 10, scope: !1500)
!1609 = !DILocation(line: 284, column: 18, scope: !1500)
!1610 = !DILocation(line: 285, column: 15, scope: !1500)
!1611 = !DILocation(line: 286, column: 15, scope: !1500)
!1612 = !DILocation(line: 287, column: 15, scope: !1500)
!1613 = !DILocation(line: 288, column: 15, scope: !1500)
!1614 = !DILocation(line: 284, column: 10, scope: !1500)
!1615 = !DILocation(line: 290, column: 18, scope: !1500)
!1616 = !DILocation(line: 290, column: 10, scope: !1500)
!1617 = !DILocation(line: 291, column: 10, scope: !1500)
!1618 = !DILocation(line: 293, column: 11, scope: !1500)
!1619 = !DILocation(line: 293, column: 3, scope: !1500)
!1620 = !DILocation(line: 294, column: 18, scope: !1500)
!1621 = !DILocation(line: 294, column: 56, scope: !1500)
!1622 = !DILocation(line: 294, column: 10, scope: !1500)
!1623 = !DILocation(line: 295, column: 18, scope: !1500)
!1624 = !DILocation(line: 295, column: 56, scope: !1500)
!1625 = !DILocation(line: 295, column: 10, scope: !1500)
!1626 = !DILocation(line: 296, column: 18, scope: !1500)
!1627 = !DILocation(line: 296, column: 56, scope: !1500)
!1628 = !DILocation(line: 296, column: 10, scope: !1500)
!1629 = !DILocation(line: 297, column: 18, scope: !1500)
!1630 = !DILocation(line: 297, column: 56, scope: !1500)
!1631 = !DILocation(line: 297, column: 10, scope: !1500)
!1632 = !DILocation(line: 298, column: 18, scope: !1500)
!1633 = !DILocation(line: 298, column: 56, scope: !1500)
!1634 = !DILocation(line: 298, column: 10, scope: !1500)
!1635 = !DILocation(line: 299, column: 18, scope: !1500)
!1636 = !DILocation(line: 299, column: 56, scope: !1500)
!1637 = !DILocation(line: 299, column: 10, scope: !1500)
!1638 = !DILocation(line: 301, column: 18, scope: !1500)
!1639 = !DILocation(line: 301, column: 64, scope: !1500)
!1640 = !DILocation(line: 301, column: 10, scope: !1500)
!1641 = !DILocation(line: 302, column: 7, scope: !1642)
!1642 = distinct !DILexicalBlock(scope: !1500, file: !90, line: 302, column: 7)
!1643 = !DILocation(line: 302, column: 7, scope: !1500)
!1644 = !DILocation(line: 303, column: 20, scope: !1645)
!1645 = distinct !DILexicalBlock(scope: !1642, file: !90, line: 302, column: 29)
!1646 = !DILocation(line: 303, column: 66, scope: !1645)
!1647 = !DILocation(line: 303, column: 12, scope: !1645)
!1648 = !DILocation(line: 304, column: 20, scope: !1645)
!1649 = !DILocation(line: 304, column: 58, scope: !1645)
!1650 = !DILocation(line: 304, column: 12, scope: !1645)
!1651 = !DILocation(line: 305, column: 3, scope: !1645)
!1652 = !DILocation(line: 307, column: 15, scope: !1653)
!1653 = distinct !DILexicalBlock(scope: !1500, file: !90, line: 307, column: 15)
!1654 = !DILocation(line: 307, column: 36, scope: !1653)
!1655 = !DILocation(line: 307, column: 15, scope: !1500)
!1656 = !DILocation(line: 308, column: 20, scope: !1657)
!1657 = distinct !DILexicalBlock(scope: !1653, file: !90, line: 307, column: 42)
!1658 = !DILocation(line: 308, column: 58, scope: !1657)
!1659 = !DILocation(line: 308, column: 12, scope: !1657)
!1660 = !DILocation(line: 309, column: 20, scope: !1657)
!1661 = !DILocation(line: 309, column: 58, scope: !1657)
!1662 = !DILocation(line: 309, column: 12, scope: !1657)
!1663 = !DILocation(line: 310, column: 3, scope: !1657)
!1664 = !DILocation(line: 311, column: 10, scope: !1500)
!1665 = !DILocation(line: 313, column: 18, scope: !1500)
!1666 = !DILocation(line: 314, column: 15, scope: !1500)
!1667 = !DILocation(line: 315, column: 15, scope: !1500)
!1668 = !DILocation(line: 316, column: 15, scope: !1500)
!1669 = !DILocation(line: 317, column: 15, scope: !1500)
!1670 = !DILocation(line: 318, column: 15, scope: !1500)
!1671 = !DILocation(line: 319, column: 15, scope: !1500)
!1672 = !DILocation(line: 313, column: 10, scope: !1500)
!1673 = !DILocation(line: 321, column: 18, scope: !1500)
!1674 = !DILocation(line: 322, column: 15, scope: !1500)
!1675 = !DILocation(line: 323, column: 15, scope: !1500)
!1676 = !DILocation(line: 324, column: 15, scope: !1500)
!1677 = !DILocation(line: 321, column: 10, scope: !1500)
!1678 = !DILocation(line: 326, column: 18, scope: !1500)
!1679 = !DILocation(line: 327, column: 15, scope: !1500)
!1680 = !DILocation(line: 328, column: 15, scope: !1500)
!1681 = !DILocation(line: 326, column: 10, scope: !1500)
!1682 = !DILocation(line: 330, column: 18, scope: !1500)
!1683 = !DILocation(line: 330, column: 10, scope: !1500)
!1684 = !DILocation(line: 331, column: 10, scope: !1500)
!1685 = !DILocation(line: 333, column: 10, scope: !1500)
!1686 = !DILocation(line: 334, column: 10, scope: !1500)
!1687 = !DILocation(line: 336, column: 1, scope: !1354)
!1688 = distinct !DISubprogram(name: "bots_print_usage", scope: !26, file: !26, line: 211, type: !990, scopeLine: 212, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !25, retainedNodes: !320)
!1689 = !DILocation(line: 213, column: 12, scope: !1688)
!1690 = !DILocation(line: 213, column: 4, scope: !1688)
!1691 = !DILocation(line: 214, column: 12, scope: !1688)
!1692 = !DILocation(line: 214, column: 4, scope: !1688)
!1693 = !DILocation(line: 215, column: 12, scope: !1688)
!1694 = !DILocation(line: 215, column: 4, scope: !1688)
!1695 = !DILocation(line: 216, column: 12, scope: !1688)
!1696 = !DILocation(line: 216, column: 4, scope: !1688)
!1697 = !DILocation(line: 221, column: 12, scope: !1688)
!1698 = !DILocation(line: 221, column: 4, scope: !1688)
!1699 = !DILocation(line: 236, column: 12, scope: !1688)
!1700 = !DILocation(line: 236, column: 4, scope: !1688)
!1701 = !DILocation(line: 239, column: 12, scope: !1688)
!1702 = !DILocation(line: 239, column: 4, scope: !1688)
!1703 = !DILocation(line: 242, column: 12, scope: !1688)
!1704 = !DILocation(line: 242, column: 4, scope: !1688)
!1705 = !DILocation(line: 245, column: 12, scope: !1688)
!1706 = !DILocation(line: 245, column: 4, scope: !1688)
!1707 = !DILocation(line: 246, column: 12, scope: !1688)
!1708 = !DILocation(line: 246, column: 4, scope: !1688)
!1709 = !DILocation(line: 247, column: 12, scope: !1688)
!1710 = !DILocation(line: 247, column: 4, scope: !1688)
!1711 = !DILocation(line: 248, column: 12, scope: !1688)
!1712 = !DILocation(line: 248, column: 4, scope: !1688)
!1713 = !DILocation(line: 249, column: 12, scope: !1688)
!1714 = !DILocation(line: 249, column: 4, scope: !1688)
!1715 = !DILocation(line: 250, column: 12, scope: !1688)
!1716 = !DILocation(line: 250, column: 4, scope: !1688)
!1717 = !DILocation(line: 251, column: 12, scope: !1688)
!1718 = !DILocation(line: 251, column: 4, scope: !1688)
!1719 = !DILocation(line: 252, column: 12, scope: !1688)
!1720 = !DILocation(line: 252, column: 4, scope: !1688)
!1721 = !DILocation(line: 253, column: 12, scope: !1688)
!1722 = !DILocation(line: 253, column: 4, scope: !1688)
!1723 = !DILocation(line: 254, column: 12, scope: !1688)
!1724 = !DILocation(line: 254, column: 4, scope: !1688)
!1725 = !DILocation(line: 255, column: 12, scope: !1688)
!1726 = !DILocation(line: 255, column: 4, scope: !1688)
!1727 = !DILocation(line: 256, column: 12, scope: !1688)
!1728 = !DILocation(line: 256, column: 4, scope: !1688)
!1729 = !DILocation(line: 257, column: 12, scope: !1688)
!1730 = !DILocation(line: 257, column: 4, scope: !1688)
!1731 = !DILocation(line: 258, column: 12, scope: !1688)
!1732 = !DILocation(line: 258, column: 4, scope: !1688)
!1733 = !DILocation(line: 265, column: 12, scope: !1688)
!1734 = !DILocation(line: 265, column: 4, scope: !1688)
!1735 = !DILocation(line: 267, column: 12, scope: !1688)
!1736 = !DILocation(line: 267, column: 4, scope: !1688)
!1737 = !DILocation(line: 268, column: 12, scope: !1688)
!1738 = !DILocation(line: 268, column: 4, scope: !1688)
!1739 = !DILocation(line: 269, column: 12, scope: !1688)
!1740 = !DILocation(line: 269, column: 4, scope: !1688)
!1741 = !DILocation(line: 270, column: 1, scope: !1688)
!1742 = distinct !DISubprogram(name: "bots_get_params_common", scope: !26, file: !26, line: 275, type: !1743, scopeLine: 276, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !25, retainedNodes: !320)
!1743 = !DISubroutineType(types: !1744)
!1744 = !{null, !33, !1745}
!1745 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1210, size: 64)
!1746 = !DILocalVariable(name: "argc", arg: 1, scope: !1742, file: !26, line: 275, type: !33)
!1747 = !DILocation(line: 275, column: 28, scope: !1742)
!1748 = !DILocalVariable(name: "argv", arg: 2, scope: !1742, file: !26, line: 275, type: !1745)
!1749 = !DILocation(line: 275, column: 41, scope: !1742)
!1750 = !DILocalVariable(name: "i", scope: !1742, file: !26, line: 277, type: !33)
!1751 = !DILocation(line: 277, column: 8, scope: !1742)
!1752 = !DILocation(line: 278, column: 35, scope: !1742)
!1753 = !DILocation(line: 278, column: 26, scope: !1742)
!1754 = !DILocation(line: 278, column: 4, scope: !1742)
!1755 = !DILocation(line: 279, column: 4, scope: !1742)
!1756 = !DILocation(line: 280, column: 4, scope: !1742)
!1757 = !DILocation(line: 281, column: 10, scope: !1758)
!1758 = distinct !DILexicalBlock(scope: !1742, file: !26, line: 281, column: 4)
!1759 = !DILocation(line: 281, column: 9, scope: !1758)
!1760 = !DILocation(line: 281, column: 14, scope: !1761)
!1761 = distinct !DILexicalBlock(scope: !1758, file: !26, line: 281, column: 4)
!1762 = !DILocation(line: 281, column: 16, scope: !1761)
!1763 = !DILocation(line: 281, column: 15, scope: !1761)
!1764 = !DILocation(line: 281, column: 4, scope: !1758)
!1765 = !DILocation(line: 283, column: 11, scope: !1766)
!1766 = distinct !DILexicalBlock(scope: !1767, file: !26, line: 283, column: 11)
!1767 = distinct !DILexicalBlock(scope: !1761, file: !26, line: 282, column: 4)
!1768 = !DILocation(line: 283, column: 16, scope: !1766)
!1769 = !DILocation(line: 283, column: 22, scope: !1766)
!1770 = !DILocation(line: 283, column: 11, scope: !1767)
!1771 = !DILocation(line: 285, column: 18, scope: !1772)
!1772 = distinct !DILexicalBlock(scope: !1766, file: !26, line: 284, column: 7)
!1773 = !DILocation(line: 285, column: 23, scope: !1772)
!1774 = !DILocation(line: 285, column: 10, scope: !1772)
!1775 = !DILocation(line: 289, column: 9, scope: !1776)
!1776 = distinct !DILexicalBlock(scope: !1772, file: !26, line: 286, column: 10)
!1777 = !DILocation(line: 289, column: 14, scope: !1776)
!1778 = !DILocation(line: 289, column: 20, scope: !1776)
!1779 = !DILocation(line: 290, column: 17, scope: !1776)
!1780 = !DILocation(line: 291, column: 20, scope: !1781)
!1781 = distinct !DILexicalBlock(scope: !1776, file: !26, line: 291, column: 20)
!1782 = !DILocation(line: 291, column: 28, scope: !1781)
!1783 = !DILocation(line: 291, column: 25, scope: !1781)
!1784 = !DILocation(line: 291, column: 20, scope: !1776)
!1785 = !DILocation(line: 291, column: 33, scope: !1786)
!1786 = distinct !DILexicalBlock(scope: !1781, file: !26, line: 291, column: 31)
!1787 = !DILocation(line: 291, column: 53, scope: !1786)
!1788 = !DILocation(line: 292, column: 47, scope: !1776)
!1789 = !DILocation(line: 292, column: 52, scope: !1776)
!1790 = !DILocation(line: 292, column: 42, scope: !1776)
!1791 = !DILocation(line: 292, column: 40, scope: !1776)
!1792 = !DILocation(line: 293, column: 16, scope: !1776)
!1793 = !DILocation(line: 297, column: 9, scope: !1776)
!1794 = !DILocation(line: 297, column: 14, scope: !1776)
!1795 = !DILocation(line: 297, column: 20, scope: !1776)
!1796 = !DILocation(line: 298, column: 17, scope: !1776)
!1797 = !DILocation(line: 299, column: 20, scope: !1798)
!1798 = distinct !DILexicalBlock(scope: !1776, file: !26, line: 299, column: 20)
!1799 = !DILocation(line: 299, column: 28, scope: !1798)
!1800 = !DILocation(line: 299, column: 25, scope: !1798)
!1801 = !DILocation(line: 299, column: 20, scope: !1776)
!1802 = !DILocation(line: 299, column: 33, scope: !1803)
!1803 = distinct !DILexicalBlock(scope: !1798, file: !26, line: 299, column: 31)
!1804 = !DILocation(line: 299, column: 53, scope: !1803)
!1805 = !DILocation(line: 300, column: 47, scope: !1776)
!1806 = !DILocation(line: 300, column: 52, scope: !1776)
!1807 = !DILocation(line: 300, column: 42, scope: !1776)
!1808 = !DILocation(line: 300, column: 40, scope: !1776)
!1809 = !DILocation(line: 301, column: 16, scope: !1776)
!1810 = !DILocation(line: 304, column: 16, scope: !1776)
!1811 = !DILocation(line: 304, column: 21, scope: !1776)
!1812 = !DILocation(line: 304, column: 27, scope: !1776)
!1813 = !DILocation(line: 308, column: 32, scope: !1776)
!1814 = !DILocation(line: 309, column: 16, scope: !1776)
!1815 = !DILocation(line: 311, column: 16, scope: !1776)
!1816 = !DILocation(line: 311, column: 21, scope: !1776)
!1817 = !DILocation(line: 311, column: 27, scope: !1776)
!1818 = !DILocation(line: 312, column: 17, scope: !1776)
!1819 = !DILocation(line: 313, column: 20, scope: !1820)
!1820 = distinct !DILexicalBlock(scope: !1776, file: !26, line: 313, column: 20)
!1821 = !DILocation(line: 313, column: 28, scope: !1820)
!1822 = !DILocation(line: 313, column: 25, scope: !1820)
!1823 = !DILocation(line: 313, column: 20, scope: !1776)
!1824 = !DILocation(line: 313, column: 33, scope: !1825)
!1825 = distinct !DILexicalBlock(scope: !1820, file: !26, line: 313, column: 31)
!1826 = !DILocation(line: 313, column: 53, scope: !1825)
!1827 = !DILocation(line: 314, column: 42, scope: !1776)
!1828 = !DILocation(line: 314, column: 47, scope: !1776)
!1829 = !DILocation(line: 314, column: 16, scope: !1776)
!1830 = !DILocation(line: 315, column: 16, scope: !1776)
!1831 = !DILocation(line: 325, column: 16, scope: !1776)
!1832 = !DILocation(line: 325, column: 21, scope: !1776)
!1833 = !DILocation(line: 325, column: 27, scope: !1776)
!1834 = !DILocation(line: 326, column: 16, scope: !1776)
!1835 = !DILocation(line: 327, column: 16, scope: !1776)
!1836 = !DILocation(line: 346, column: 16, scope: !1776)
!1837 = !DILocation(line: 346, column: 21, scope: !1776)
!1838 = !DILocation(line: 346, column: 27, scope: !1776)
!1839 = !DILocation(line: 347, column: 17, scope: !1776)
!1840 = !DILocation(line: 348, column: 20, scope: !1841)
!1841 = distinct !DILexicalBlock(scope: !1776, file: !26, line: 348, column: 20)
!1842 = !DILocation(line: 348, column: 28, scope: !1841)
!1843 = !DILocation(line: 348, column: 25, scope: !1841)
!1844 = !DILocation(line: 348, column: 20, scope: !1776)
!1845 = !DILocation(line: 348, column: 33, scope: !1846)
!1846 = distinct !DILexicalBlock(scope: !1841, file: !26, line: 348, column: 31)
!1847 = !DILocation(line: 348, column: 53, scope: !1846)
!1848 = !DILocation(line: 349, column: 37, scope: !1776)
!1849 = !DILocation(line: 349, column: 42, scope: !1776)
!1850 = !DILocation(line: 349, column: 32, scope: !1776)
!1851 = !DILocation(line: 349, column: 30, scope: !1776)
!1852 = !DILocation(line: 350, column: 16, scope: !1776)
!1853 = !DILocation(line: 356, column: 16, scope: !1776)
!1854 = !DILocation(line: 356, column: 21, scope: !1776)
!1855 = !DILocation(line: 356, column: 27, scope: !1776)
!1856 = !DILocation(line: 357, column: 17, scope: !1776)
!1857 = !DILocation(line: 358, column: 20, scope: !1858)
!1858 = distinct !DILexicalBlock(scope: !1776, file: !26, line: 358, column: 20)
!1859 = !DILocation(line: 358, column: 28, scope: !1858)
!1860 = !DILocation(line: 358, column: 25, scope: !1858)
!1861 = !DILocation(line: 358, column: 20, scope: !1776)
!1862 = !DILocation(line: 358, column: 33, scope: !1863)
!1863 = distinct !DILexicalBlock(scope: !1858, file: !26, line: 358, column: 31)
!1864 = !DILocation(line: 358, column: 53, scope: !1863)
!1865 = !DILocation(line: 359, column: 42, scope: !1776)
!1866 = !DILocation(line: 359, column: 47, scope: !1776)
!1867 = !DILocation(line: 359, column: 37, scope: !1776)
!1868 = !DILocation(line: 359, column: 35, scope: !1776)
!1869 = !DILocation(line: 360, column: 16, scope: !1776)
!1870 = !DILocation(line: 379, column: 16, scope: !1776)
!1871 = !DILocation(line: 379, column: 21, scope: !1776)
!1872 = !DILocation(line: 379, column: 27, scope: !1776)
!1873 = !DILocation(line: 380, column: 17, scope: !1776)
!1874 = !DILocation(line: 381, column: 20, scope: !1875)
!1875 = distinct !DILexicalBlock(scope: !1776, file: !26, line: 381, column: 20)
!1876 = !DILocation(line: 381, column: 28, scope: !1875)
!1877 = !DILocation(line: 381, column: 25, scope: !1875)
!1878 = !DILocation(line: 381, column: 20, scope: !1776)
!1879 = !DILocation(line: 381, column: 33, scope: !1880)
!1880 = distinct !DILexicalBlock(scope: !1875, file: !26, line: 381, column: 31)
!1881 = !DILocation(line: 381, column: 53, scope: !1880)
!1882 = !DILocation(line: 382, column: 63, scope: !1776)
!1883 = !DILocation(line: 382, column: 68, scope: !1776)
!1884 = !DILocation(line: 382, column: 58, scope: !1776)
!1885 = !DILocation(line: 382, column: 34, scope: !1776)
!1886 = !DILocation(line: 384, column: 21, scope: !1887)
!1887 = distinct !DILexicalBlock(scope: !1776, file: !26, line: 384, column: 21)
!1888 = !DILocation(line: 384, column: 39, scope: !1887)
!1889 = !DILocation(line: 384, column: 21, scope: !1776)
!1890 = !DILocation(line: 385, column: 27, scope: !1891)
!1891 = distinct !DILexicalBlock(scope: !1887, file: !26, line: 384, column: 45)
!1892 = !DILocation(line: 385, column: 19, scope: !1891)
!1893 = !DILocation(line: 386, column: 19, scope: !1891)
!1894 = !DILocation(line: 389, column: 16, scope: !1776)
!1895 = !DILocation(line: 400, column: 9, scope: !1776)
!1896 = !DILocation(line: 400, column: 14, scope: !1776)
!1897 = !DILocation(line: 400, column: 20, scope: !1776)
!1898 = !DILocation(line: 401, column: 17, scope: !1776)
!1899 = !DILocation(line: 402, column: 20, scope: !1900)
!1900 = distinct !DILexicalBlock(scope: !1776, file: !26, line: 402, column: 20)
!1901 = !DILocation(line: 402, column: 28, scope: !1900)
!1902 = !DILocation(line: 402, column: 25, scope: !1900)
!1903 = !DILocation(line: 402, column: 20, scope: !1776)
!1904 = !DILocation(line: 402, column: 33, scope: !1905)
!1905 = distinct !DILexicalBlock(scope: !1900, file: !26, line: 402, column: 31)
!1906 = !DILocation(line: 402, column: 53, scope: !1905)
!1907 = !DILocation(line: 403, column: 45, scope: !1776)
!1908 = !DILocation(line: 403, column: 50, scope: !1776)
!1909 = !DILocation(line: 403, column: 40, scope: !1776)
!1910 = !DILocation(line: 403, column: 38, scope: !1776)
!1911 = !DILocation(line: 404, column: 16, scope: !1776)
!1912 = !DILocation(line: 407, column: 9, scope: !1776)
!1913 = !DILocation(line: 407, column: 14, scope: !1776)
!1914 = !DILocation(line: 407, column: 20, scope: !1776)
!1915 = !DILocation(line: 408, column: 34, scope: !1776)
!1916 = !DILocation(line: 409, column: 16, scope: !1776)
!1917 = !DILocation(line: 415, column: 24, scope: !1776)
!1918 = !DILocation(line: 415, column: 16, scope: !1776)
!1919 = !DILocation(line: 416, column: 16, scope: !1776)
!1920 = !DILocation(line: 417, column: 16, scope: !1776)
!1921 = !DILocation(line: 419, column: 7, scope: !1772)
!1922 = !DILocation(line: 426, column: 18, scope: !1923)
!1923 = distinct !DILexicalBlock(scope: !1766, file: !26, line: 421, column: 7)
!1924 = !DILocation(line: 426, column: 10, scope: !1923)
!1925 = !DILocation(line: 427, column: 10, scope: !1923)
!1926 = !DILocation(line: 428, column: 10, scope: !1923)
!1927 = !DILocation(line: 430, column: 4, scope: !1767)
!1928 = !DILocation(line: 281, column: 23, scope: !1761)
!1929 = !DILocation(line: 281, column: 4, scope: !1761)
!1930 = distinct !{!1930, !1764, !1931}
!1931 = !DILocation(line: 430, column: 4, scope: !1758)
!1932 = !DILocation(line: 431, column: 1, scope: !1742)
!1933 = distinct !DISubprogram(name: "bots_get_params", scope: !26, file: !26, line: 436, type: !1743, scopeLine: 437, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !25, retainedNodes: !320)
!1934 = !DILocalVariable(name: "argc", arg: 1, scope: !1933, file: !26, line: 436, type: !33)
!1935 = !DILocation(line: 436, column: 21, scope: !1933)
!1936 = !DILocalVariable(name: "argv", arg: 2, scope: !1933, file: !26, line: 436, type: !1745)
!1937 = !DILocation(line: 436, column: 34, scope: !1933)
!1938 = !DILocation(line: 438, column: 27, scope: !1933)
!1939 = !DILocation(line: 438, column: 33, scope: !1933)
!1940 = !DILocation(line: 438, column: 4, scope: !1933)
!1941 = !DILocation(line: 440, column: 1, scope: !1933)
!1942 = distinct !DISubprogram(name: "bots_set_info", scope: !26, file: !26, line: 446, type: !990, scopeLine: 447, spFlags: DISPFlagDefinition, unit: !25, retainedNodes: !320)
!1943 = !DILocation(line: 449, column: 4, scope: !1942)
!1944 = !DILocation(line: 450, column: 72, scope: !1942)
!1945 = !DILocation(line: 450, column: 4, scope: !1942)
!1946 = !DILocation(line: 451, column: 4, scope: !1942)
!1947 = !DILocation(line: 452, column: 4, scope: !1942)
!1948 = !DILocation(line: 455, column: 4, scope: !1942)
!1949 = !DILocation(line: 456, column: 4, scope: !1942)
!1950 = !DILocation(line: 457, column: 4, scope: !1942)
!1951 = !DILocation(line: 458, column: 4, scope: !1942)
!1952 = !DILocation(line: 459, column: 4, scope: !1942)
!1953 = !DILocation(line: 460, column: 4, scope: !1942)
!1954 = !DILocation(line: 469, column: 4, scope: !1942)
!1955 = !DILocation(line: 471, column: 1, scope: !1942)
!1956 = distinct !DISubprogram(name: "main", scope: !26, file: !26, line: 477, type: !1957, scopeLine: 478, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !25, retainedNodes: !320)
!1957 = !DISubroutineType(types: !1958)
!1958 = !{!33, !33, !1745}
!1959 = !DILocalVariable(name: "argc", arg: 1, scope: !1956, file: !26, line: 477, type: !33)
!1960 = !DILocation(line: 477, column: 10, scope: !1956)
!1961 = !DILocalVariable(name: "argv", arg: 2, scope: !1956, file: !26, line: 477, type: !1745)
!1962 = !DILocation(line: 477, column: 22, scope: !1956)
!1963 = !DILocalVariable(name: "bots_t_start", scope: !1956, file: !26, line: 480, type: !16)
!1964 = !DILocation(line: 480, column: 9, scope: !1956)
!1965 = !DILocalVariable(name: "bots_t_end", scope: !1956, file: !26, line: 481, type: !16)
!1966 = !DILocation(line: 481, column: 9, scope: !1956)
!1967 = !DILocation(line: 484, column: 20, scope: !1956)
!1968 = !DILocation(line: 484, column: 25, scope: !1956)
!1969 = !DILocation(line: 484, column: 4, scope: !1956)
!1970 = !DILocation(line: 485, column: 4, scope: !1956)
!1971 = !DILocation(line: 486, column: 4, scope: !1956)
!1972 = !DILocation(line: 513, column: 19, scope: !1956)
!1973 = !DILocation(line: 513, column: 17, scope: !1956)
!1974 = !DILocation(line: 514, column: 4, scope: !1956)
!1975 = !DILocation(line: 515, column: 17, scope: !1956)
!1976 = !DILocation(line: 515, column: 15, scope: !1956)
!1977 = !DILocation(line: 516, column: 34, scope: !1956)
!1978 = !DILocation(line: 516, column: 45, scope: !1956)
!1979 = !DILocation(line: 516, column: 44, scope: !1956)
!1980 = !DILocation(line: 516, column: 25, scope: !1956)
!1981 = !DILocation(line: 516, column: 59, scope: !1956)
!1982 = !DILocation(line: 516, column: 22, scope: !1956)
!1983 = !DILocation(line: 521, column: 8, scope: !1984)
!1984 = distinct !DILexicalBlock(scope: !1956, file: !26, line: 521, column: 8)
!1985 = !DILocation(line: 521, column: 8, scope: !1956)
!1986 = !DILocation(line: 522, column: 20, scope: !1987)
!1987 = distinct !DILexicalBlock(scope: !1984, file: !26, line: 521, column: 25)
!1988 = !DILocation(line: 522, column: 18, scope: !1987)
!1989 = !DILocation(line: 523, column: 4, scope: !1987)
!1990 = !DILocation(line: 528, column: 4, scope: !1956)
!1991 = !DILocation(line: 529, column: 4, scope: !1956)
