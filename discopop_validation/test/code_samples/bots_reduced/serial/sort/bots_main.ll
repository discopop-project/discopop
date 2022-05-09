; ModuleID = 'bots_main.c'
source_filename = "bots_main.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, %struct._IO_codecvt*, %struct._IO_wide_data*, %struct._IO_FILE*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type opaque
%struct._IO_codecvt = type opaque
%struct._IO_wide_data = type opaque

@bots_sequential_flag = dso_local global i32 0, align 4, !dbg !0
@bots_check_flag = dso_local global i32 0, align 4, !dbg !16
@bots_verbose_mode = dso_local global i32 1, align 4, !dbg !19
@bots_result = dso_local global i32 3, align 4, !dbg !21
@bots_output_format = dso_local global i32 1, align 4, !dbg !23
@bots_print_header = dso_local global i32 0, align 4, !dbg !25
@bots_time_program = dso_local global double 0.000000e+00, align 8, !dbg !27
@bots_time_sequential = dso_local global double 0.000000e+00, align 8, !dbg !29
@bots_number_of_tasks = dso_local global i64 0, align 8, !dbg !31
@bots_arg_size = dso_local global i32 33554432, align 4, !dbg !34
@bots_app_cutoff_value = dso_local global i32 2048, align 4, !dbg !36
@bots_app_cutoff_value_1 = dso_local global i32 2048, align 4, !dbg !38
@bots_app_cutoff_value_2 = dso_local global i32 20, align 4, !dbg !40
@stderr = external dso_local global %struct._IO_FILE*, align 8
@.str = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.1 = private unnamed_addr constant [22 x i8] c"Usage: %s -[options]\0A\00", align 1
@bots_execname = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !48
@.str.2 = private unnamed_addr constant [20 x i8] c"Where options are:\0A\00", align 1
@.str.3 = private unnamed_addr constant [27 x i8] c"  -n <size>  : Array size\0A\00", align 1
@.str.4 = private unnamed_addr constant [58 x i8] c"  -y <value> : Sequential Merge cutoff value(default=%d)\0A\00", align 1
@.str.5 = private unnamed_addr constant [62 x i8] c"  -a <value> : Sequential Quicksort cutoff value(default=%d)\0A\00", align 1
@.str.6 = private unnamed_addr constant [62 x i8] c"  -b <value> : Sequential Insertion cutoff value(default=%d)\0A\00", align 1
@.str.7 = private unnamed_addr constant [49 x i8] c"  -e <str>   : Include 'str' execution message.\0A\00", align 1
@.str.8 = private unnamed_addr constant [49 x i8] c"  -v <level> : Set verbose level (default = 1).\0A\00", align 1
@.str.9 = private unnamed_addr constant [26 x i8] c"               0 - none.\0A\00", align 1
@.str.10 = private unnamed_addr constant [29 x i8] c"               1 - default.\0A\00", align 1
@.str.11 = private unnamed_addr constant [27 x i8] c"               2 - debug.\0A\00", align 1
@.str.12 = private unnamed_addr constant [54 x i8] c"  -o <value> : Set output format mode (default = 1).\0A\00", align 1
@.str.13 = private unnamed_addr constant [41 x i8] c"               0 - no benchmark output.\0A\00", align 1
@.str.14 = private unnamed_addr constant [42 x i8] c"               1 - detailed list format.\0A\00", align 1
@.str.15 = private unnamed_addr constant [41 x i8] c"               2 - detailed row format.\0A\00", align 1
@.str.16 = private unnamed_addr constant [42 x i8] c"               3 - abridged list format.\0A\00", align 1
@.str.17 = private unnamed_addr constant [41 x i8] c"               4 - abridged row format.\0A\00", align 1
@.str.18 = private unnamed_addr constant [70 x i8] c"  -z         : Print row header (if output format is a row variant).\0A\00", align 1
@.str.19 = private unnamed_addr constant [31 x i8] c"  -c         : Check mode ON.\0A\00", align 1
@.str.20 = private unnamed_addr constant [51 x i8] c"  -h         : Print program's usage (this help).\0A\00", align 1
@bots_exec_date = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !56
@bots_exec_message = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !58
@.str.21 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.22 = private unnamed_addr constant [100 x i8] c"Error: Configure the suite using '--debug' option in order to use a verbose level greather than 1.\0A\00", align 1
@.str.23 = private unnamed_addr constant [32 x i8] c"Error: Unrecognized parameter.\0A\00", align 1
@bots_name = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !42
@.str.24 = private unnamed_addr constant [5 x i8] c"Sort\00", align 1
@bots_parameters = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !50
@.str.25 = private unnamed_addr constant [20 x i8] c"N=%d:Q=%d:I=%d:M=%d\00", align 1
@bots_model = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !52
@.str.26 = private unnamed_addr constant [7 x i8] c"Serial\00", align 1
@bots_resources = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !54
@.str.27 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@bots_comp_date = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !60
@bots_comp_message = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !62
@bots_cc = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !64
@bots_cflags = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !66
@bots_ld = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !68
@bots_ldflags = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !70
@bots_cutoff = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !72
@.str.28 = private unnamed_addr constant [5 x i8] c"none\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_print_usage() #0 !dbg !78 {
entry:
  %0 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !82
  %call = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %0, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0)), !dbg !83
  %1 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !84
  %call1 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %1, i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.1, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_execname, i32 0, i32 0)), !dbg !85
  %2 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !86
  %call2 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0)), !dbg !87
  %3 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !88
  %call3 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([20 x i8], [20 x i8]* @.str.2, i32 0, i32 0)), !dbg !89
  %4 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !90
  %call4 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %4, i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.3, i32 0, i32 0)), !dbg !91
  %5 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !92
  %call5 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %5, i8* getelementptr inbounds ([58 x i8], [58 x i8]* @.str.4, i32 0, i32 0), i32 2048), !dbg !93
  %6 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !94
  %call6 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %6, i8* getelementptr inbounds ([62 x i8], [62 x i8]* @.str.5, i32 0, i32 0), i32 2048), !dbg !95
  %7 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !96
  %call7 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %7, i8* getelementptr inbounds ([62 x i8], [62 x i8]* @.str.6, i32 0, i32 0), i32 20), !dbg !97
  %8 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !98
  %call8 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0)), !dbg !99
  %9 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !100
  %call9 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %9, i8* getelementptr inbounds ([49 x i8], [49 x i8]* @.str.7, i32 0, i32 0)), !dbg !101
  %10 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !102
  %call10 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %10, i8* getelementptr inbounds ([49 x i8], [49 x i8]* @.str.8, i32 0, i32 0)), !dbg !103
  %11 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !104
  %call11 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %11, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.9, i32 0, i32 0)), !dbg !105
  %12 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !106
  %call12 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %12, i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str.10, i32 0, i32 0)), !dbg !107
  %13 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !108
  %call13 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %13, i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.11, i32 0, i32 0)), !dbg !109
  %14 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !110
  %call14 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %14, i8* getelementptr inbounds ([54 x i8], [54 x i8]* @.str.12, i32 0, i32 0)), !dbg !111
  %15 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !112
  %call15 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %15, i8* getelementptr inbounds ([41 x i8], [41 x i8]* @.str.13, i32 0, i32 0)), !dbg !113
  %16 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !114
  %call16 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %16, i8* getelementptr inbounds ([42 x i8], [42 x i8]* @.str.14, i32 0, i32 0)), !dbg !115
  %17 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !116
  %call17 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %17, i8* getelementptr inbounds ([41 x i8], [41 x i8]* @.str.15, i32 0, i32 0)), !dbg !117
  %18 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !118
  %call18 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %18, i8* getelementptr inbounds ([42 x i8], [42 x i8]* @.str.16, i32 0, i32 0)), !dbg !119
  %19 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !120
  %call19 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %19, i8* getelementptr inbounds ([41 x i8], [41 x i8]* @.str.17, i32 0, i32 0)), !dbg !121
  %20 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !122
  %call20 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %20, i8* getelementptr inbounds ([70 x i8], [70 x i8]* @.str.18, i32 0, i32 0)), !dbg !123
  %21 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !124
  %call21 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %21, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0)), !dbg !125
  %22 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !126
  %call22 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %22, i8* getelementptr inbounds ([31 x i8], [31 x i8]* @.str.19, i32 0, i32 0)), !dbg !127
  %23 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !128
  %call23 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %23, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0)), !dbg !129
  %24 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !130
  %call24 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %24, i8* getelementptr inbounds ([51 x i8], [51 x i8]* @.str.20, i32 0, i32 0)), !dbg !131
  %25 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !132
  %call25 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %25, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0)), !dbg !133
  ret void, !dbg !134
}

declare dso_local i32 @fprintf(%struct._IO_FILE*, i8*, ...) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_get_params_common(i32 %argc, i8** %argv) #0 !dbg !135 {
entry:
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !140, metadata !DIExpression()), !dbg !141
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !142, metadata !DIExpression()), !dbg !143
  call void @llvm.dbg.declare(metadata i32* %i, metadata !144, metadata !DIExpression()), !dbg !145
  %0 = load i8**, i8*** %argv.addr, align 8, !dbg !146
  %arrayidx = getelementptr inbounds i8*, i8** %0, i64 0, !dbg !146
  %1 = load i8*, i8** %arrayidx, align 8, !dbg !146
  %call = call i8* @__xpg_basename(i8* %1) #6, !dbg !147
  %call1 = call i8* @strcpy(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_execname, i32 0, i32 0), i8* %call) #6, !dbg !148
  call void @bots_get_date(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_exec_date, i32 0, i32 0)), !dbg !149
  %call2 = call i8* @strcpy(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_exec_message, i32 0, i32 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.21, i32 0, i32 0)) #6, !dbg !150
  store i32 1, i32* %i, align 4, !dbg !151
  br label %for.cond, !dbg !153

for.cond:                                         ; preds = %for.inc, %entry
  %2 = load i32, i32* %i, align 4, !dbg !154
  %3 = load i32, i32* %argc.addr, align 4, !dbg !156
  %cmp = icmp slt i32 %2, %3, !dbg !157
  br i1 %cmp, label %for.body, label %for.end, !dbg !158

for.body:                                         ; preds = %for.cond
  %4 = load i8**, i8*** %argv.addr, align 8, !dbg !159
  %5 = load i32, i32* %i, align 4, !dbg !162
  %idxprom = sext i32 %5 to i64, !dbg !159
  %arrayidx3 = getelementptr inbounds i8*, i8** %4, i64 %idxprom, !dbg !159
  %6 = load i8*, i8** %arrayidx3, align 8, !dbg !159
  %arrayidx4 = getelementptr inbounds i8, i8* %6, i64 0, !dbg !159
  %7 = load i8, i8* %arrayidx4, align 1, !dbg !159
  %conv = sext i8 %7 to i32, !dbg !159
  %cmp5 = icmp eq i32 %conv, 45, !dbg !163
  br i1 %cmp5, label %if.then, label %if.else, !dbg !164

if.then:                                          ; preds = %for.body
  %8 = load i8**, i8*** %argv.addr, align 8, !dbg !165
  %9 = load i32, i32* %i, align 4, !dbg !167
  %idxprom7 = sext i32 %9 to i64, !dbg !165
  %arrayidx8 = getelementptr inbounds i8*, i8** %8, i64 %idxprom7, !dbg !165
  %10 = load i8*, i8** %arrayidx8, align 8, !dbg !165
  %arrayidx9 = getelementptr inbounds i8, i8* %10, i64 1, !dbg !165
  %11 = load i8, i8* %arrayidx9, align 1, !dbg !165
  %conv10 = sext i8 %11 to i32, !dbg !165
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
  ], !dbg !168

sw.bb:                                            ; preds = %if.then
  %12 = load i8**, i8*** %argv.addr, align 8, !dbg !169
  %13 = load i32, i32* %i, align 4, !dbg !171
  %idxprom11 = sext i32 %13 to i64, !dbg !169
  %arrayidx12 = getelementptr inbounds i8*, i8** %12, i64 %idxprom11, !dbg !169
  %14 = load i8*, i8** %arrayidx12, align 8, !dbg !169
  %arrayidx13 = getelementptr inbounds i8, i8* %14, i64 1, !dbg !169
  store i8 42, i8* %arrayidx13, align 1, !dbg !172
  %15 = load i32, i32* %i, align 4, !dbg !173
  %inc = add nsw i32 %15, 1, !dbg !173
  store i32 %inc, i32* %i, align 4, !dbg !173
  %16 = load i32, i32* %argc.addr, align 4, !dbg !174
  %17 = load i32, i32* %i, align 4, !dbg !176
  %cmp14 = icmp eq i32 %16, %17, !dbg !177
  br i1 %cmp14, label %if.then16, label %if.end, !dbg !178

if.then16:                                        ; preds = %sw.bb
  call void @bots_print_usage(), !dbg !179
  call void @exit(i32 100) #7, !dbg !181
  unreachable, !dbg !181

if.end:                                           ; preds = %sw.bb
  %18 = load i8**, i8*** %argv.addr, align 8, !dbg !182
  %19 = load i32, i32* %i, align 4, !dbg !183
  %idxprom17 = sext i32 %19 to i64, !dbg !182
  %arrayidx18 = getelementptr inbounds i8*, i8** %18, i64 %idxprom17, !dbg !182
  %20 = load i8*, i8** %arrayidx18, align 8, !dbg !182
  %call19 = call i32 @atoi(i8* %20) #8, !dbg !184
  store i32 %call19, i32* @bots_app_cutoff_value_1, align 4, !dbg !185
  br label %sw.epilog, !dbg !186

sw.bb20:                                          ; preds = %if.then
  %21 = load i8**, i8*** %argv.addr, align 8, !dbg !187
  %22 = load i32, i32* %i, align 4, !dbg !188
  %idxprom21 = sext i32 %22 to i64, !dbg !187
  %arrayidx22 = getelementptr inbounds i8*, i8** %21, i64 %idxprom21, !dbg !187
  %23 = load i8*, i8** %arrayidx22, align 8, !dbg !187
  %arrayidx23 = getelementptr inbounds i8, i8* %23, i64 1, !dbg !187
  store i8 42, i8* %arrayidx23, align 1, !dbg !189
  %24 = load i32, i32* %i, align 4, !dbg !190
  %inc24 = add nsw i32 %24, 1, !dbg !190
  store i32 %inc24, i32* %i, align 4, !dbg !190
  %25 = load i32, i32* %argc.addr, align 4, !dbg !191
  %26 = load i32, i32* %i, align 4, !dbg !193
  %cmp25 = icmp eq i32 %25, %26, !dbg !194
  br i1 %cmp25, label %if.then27, label %if.end28, !dbg !195

if.then27:                                        ; preds = %sw.bb20
  call void @bots_print_usage(), !dbg !196
  call void @exit(i32 100) #7, !dbg !198
  unreachable, !dbg !198

if.end28:                                         ; preds = %sw.bb20
  %27 = load i8**, i8*** %argv.addr, align 8, !dbg !199
  %28 = load i32, i32* %i, align 4, !dbg !200
  %idxprom29 = sext i32 %28 to i64, !dbg !199
  %arrayidx30 = getelementptr inbounds i8*, i8** %27, i64 %idxprom29, !dbg !199
  %29 = load i8*, i8** %arrayidx30, align 8, !dbg !199
  %call31 = call i32 @atoi(i8* %29) #8, !dbg !201
  store i32 %call31, i32* @bots_app_cutoff_value_2, align 4, !dbg !202
  br label %sw.epilog, !dbg !203

sw.bb32:                                          ; preds = %if.then
  %30 = load i8**, i8*** %argv.addr, align 8, !dbg !204
  %31 = load i32, i32* %i, align 4, !dbg !205
  %idxprom33 = sext i32 %31 to i64, !dbg !204
  %arrayidx34 = getelementptr inbounds i8*, i8** %30, i64 %idxprom33, !dbg !204
  %32 = load i8*, i8** %arrayidx34, align 8, !dbg !204
  %arrayidx35 = getelementptr inbounds i8, i8* %32, i64 1, !dbg !204
  store i8 42, i8* %arrayidx35, align 1, !dbg !206
  store i32 1, i32* @bots_check_flag, align 4, !dbg !207
  br label %sw.epilog, !dbg !208

sw.bb36:                                          ; preds = %if.then
  %33 = load i8**, i8*** %argv.addr, align 8, !dbg !209
  %34 = load i32, i32* %i, align 4, !dbg !210
  %idxprom37 = sext i32 %34 to i64, !dbg !209
  %arrayidx38 = getelementptr inbounds i8*, i8** %33, i64 %idxprom37, !dbg !209
  %35 = load i8*, i8** %arrayidx38, align 8, !dbg !209
  %arrayidx39 = getelementptr inbounds i8, i8* %35, i64 1, !dbg !209
  store i8 42, i8* %arrayidx39, align 1, !dbg !211
  %36 = load i32, i32* %i, align 4, !dbg !212
  %inc40 = add nsw i32 %36, 1, !dbg !212
  store i32 %inc40, i32* %i, align 4, !dbg !212
  %37 = load i32, i32* %argc.addr, align 4, !dbg !213
  %38 = load i32, i32* %i, align 4, !dbg !215
  %cmp41 = icmp eq i32 %37, %38, !dbg !216
  br i1 %cmp41, label %if.then43, label %if.end44, !dbg !217

if.then43:                                        ; preds = %sw.bb36
  call void @bots_print_usage(), !dbg !218
  call void @exit(i32 100) #7, !dbg !220
  unreachable, !dbg !220

if.end44:                                         ; preds = %sw.bb36
  %39 = load i8**, i8*** %argv.addr, align 8, !dbg !221
  %40 = load i32, i32* %i, align 4, !dbg !222
  %idxprom45 = sext i32 %40 to i64, !dbg !221
  %arrayidx46 = getelementptr inbounds i8*, i8** %39, i64 %idxprom45, !dbg !221
  %41 = load i8*, i8** %arrayidx46, align 8, !dbg !221
  %call47 = call i8* @strcpy(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_exec_message, i32 0, i32 0), i8* %41) #6, !dbg !223
  br label %sw.epilog, !dbg !224

sw.bb48:                                          ; preds = %if.then
  %42 = load i8**, i8*** %argv.addr, align 8, !dbg !225
  %43 = load i32, i32* %i, align 4, !dbg !226
  %idxprom49 = sext i32 %43 to i64, !dbg !225
  %arrayidx50 = getelementptr inbounds i8*, i8** %42, i64 %idxprom49, !dbg !225
  %44 = load i8*, i8** %arrayidx50, align 8, !dbg !225
  %arrayidx51 = getelementptr inbounds i8, i8* %44, i64 1, !dbg !225
  store i8 42, i8* %arrayidx51, align 1, !dbg !227
  call void @bots_print_usage(), !dbg !228
  call void @exit(i32 100) #7, !dbg !229
  unreachable, !dbg !229

sw.bb52:                                          ; preds = %if.then
  %45 = load i8**, i8*** %argv.addr, align 8, !dbg !230
  %46 = load i32, i32* %i, align 4, !dbg !231
  %idxprom53 = sext i32 %46 to i64, !dbg !230
  %arrayidx54 = getelementptr inbounds i8*, i8** %45, i64 %idxprom53, !dbg !230
  %47 = load i8*, i8** %arrayidx54, align 8, !dbg !230
  %arrayidx55 = getelementptr inbounds i8, i8* %47, i64 1, !dbg !230
  store i8 42, i8* %arrayidx55, align 1, !dbg !232
  %48 = load i32, i32* %i, align 4, !dbg !233
  %inc56 = add nsw i32 %48, 1, !dbg !233
  store i32 %inc56, i32* %i, align 4, !dbg !233
  %49 = load i32, i32* %argc.addr, align 4, !dbg !234
  %50 = load i32, i32* %i, align 4, !dbg !236
  %cmp57 = icmp eq i32 %49, %50, !dbg !237
  br i1 %cmp57, label %if.then59, label %if.end60, !dbg !238

if.then59:                                        ; preds = %sw.bb52
  call void @bots_print_usage(), !dbg !239
  call void @exit(i32 100) #7, !dbg !241
  unreachable, !dbg !241

if.end60:                                         ; preds = %sw.bb52
  %51 = load i8**, i8*** %argv.addr, align 8, !dbg !242
  %52 = load i32, i32* %i, align 4, !dbg !243
  %idxprom61 = sext i32 %52 to i64, !dbg !242
  %arrayidx62 = getelementptr inbounds i8*, i8** %51, i64 %idxprom61, !dbg !242
  %53 = load i8*, i8** %arrayidx62, align 8, !dbg !242
  %call63 = call i32 @atoi(i8* %53) #8, !dbg !244
  store i32 %call63, i32* @bots_arg_size, align 4, !dbg !245
  br label %sw.epilog, !dbg !246

sw.bb64:                                          ; preds = %if.then
  %54 = load i8**, i8*** %argv.addr, align 8, !dbg !247
  %55 = load i32, i32* %i, align 4, !dbg !248
  %idxprom65 = sext i32 %55 to i64, !dbg !247
  %arrayidx66 = getelementptr inbounds i8*, i8** %54, i64 %idxprom65, !dbg !247
  %56 = load i8*, i8** %arrayidx66, align 8, !dbg !247
  %arrayidx67 = getelementptr inbounds i8, i8* %56, i64 1, !dbg !247
  store i8 42, i8* %arrayidx67, align 1, !dbg !249
  %57 = load i32, i32* %i, align 4, !dbg !250
  %inc68 = add nsw i32 %57, 1, !dbg !250
  store i32 %inc68, i32* %i, align 4, !dbg !250
  %58 = load i32, i32* %argc.addr, align 4, !dbg !251
  %59 = load i32, i32* %i, align 4, !dbg !253
  %cmp69 = icmp eq i32 %58, %59, !dbg !254
  br i1 %cmp69, label %if.then71, label %if.end72, !dbg !255

if.then71:                                        ; preds = %sw.bb64
  call void @bots_print_usage(), !dbg !256
  call void @exit(i32 100) #7, !dbg !258
  unreachable, !dbg !258

if.end72:                                         ; preds = %sw.bb64
  %60 = load i8**, i8*** %argv.addr, align 8, !dbg !259
  %61 = load i32, i32* %i, align 4, !dbg !260
  %idxprom73 = sext i32 %61 to i64, !dbg !259
  %arrayidx74 = getelementptr inbounds i8*, i8** %60, i64 %idxprom73, !dbg !259
  %62 = load i8*, i8** %arrayidx74, align 8, !dbg !259
  %call75 = call i32 @atoi(i8* %62) #8, !dbg !261
  store i32 %call75, i32* @bots_output_format, align 4, !dbg !262
  br label %sw.epilog, !dbg !263

sw.bb76:                                          ; preds = %if.then
  %63 = load i8**, i8*** %argv.addr, align 8, !dbg !264
  %64 = load i32, i32* %i, align 4, !dbg !265
  %idxprom77 = sext i32 %64 to i64, !dbg !264
  %arrayidx78 = getelementptr inbounds i8*, i8** %63, i64 %idxprom77, !dbg !264
  %65 = load i8*, i8** %arrayidx78, align 8, !dbg !264
  %arrayidx79 = getelementptr inbounds i8, i8* %65, i64 1, !dbg !264
  store i8 42, i8* %arrayidx79, align 1, !dbg !266
  %66 = load i32, i32* %i, align 4, !dbg !267
  %inc80 = add nsw i32 %66, 1, !dbg !267
  store i32 %inc80, i32* %i, align 4, !dbg !267
  %67 = load i32, i32* %argc.addr, align 4, !dbg !268
  %68 = load i32, i32* %i, align 4, !dbg !270
  %cmp81 = icmp eq i32 %67, %68, !dbg !271
  br i1 %cmp81, label %if.then83, label %if.end84, !dbg !272

if.then83:                                        ; preds = %sw.bb76
  call void @bots_print_usage(), !dbg !273
  call void @exit(i32 100) #7, !dbg !275
  unreachable, !dbg !275

if.end84:                                         ; preds = %sw.bb76
  %69 = load i8**, i8*** %argv.addr, align 8, !dbg !276
  %70 = load i32, i32* %i, align 4, !dbg !277
  %idxprom85 = sext i32 %70 to i64, !dbg !276
  %arrayidx86 = getelementptr inbounds i8*, i8** %69, i64 %idxprom85, !dbg !276
  %71 = load i8*, i8** %arrayidx86, align 8, !dbg !276
  %call87 = call i32 @atoi(i8* %71) #8, !dbg !278
  store i32 %call87, i32* @bots_verbose_mode, align 4, !dbg !279
  %72 = load i32, i32* @bots_verbose_mode, align 4, !dbg !280
  %cmp88 = icmp ugt i32 %72, 1, !dbg !282
  br i1 %cmp88, label %if.then90, label %if.end92, !dbg !283

if.then90:                                        ; preds = %if.end84
  %73 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !284
  %call91 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %73, i8* getelementptr inbounds ([100 x i8], [100 x i8]* @.str.22, i32 0, i32 0)), !dbg !286
  call void @exit(i32 100) #7, !dbg !287
  unreachable, !dbg !287

if.end92:                                         ; preds = %if.end84
  br label %sw.epilog, !dbg !288

sw.bb93:                                          ; preds = %if.then
  %74 = load i8**, i8*** %argv.addr, align 8, !dbg !289
  %75 = load i32, i32* %i, align 4, !dbg !290
  %idxprom94 = sext i32 %75 to i64, !dbg !289
  %arrayidx95 = getelementptr inbounds i8*, i8** %74, i64 %idxprom94, !dbg !289
  %76 = load i8*, i8** %arrayidx95, align 8, !dbg !289
  %arrayidx96 = getelementptr inbounds i8, i8* %76, i64 1, !dbg !289
  store i8 42, i8* %arrayidx96, align 1, !dbg !291
  %77 = load i32, i32* %i, align 4, !dbg !292
  %inc97 = add nsw i32 %77, 1, !dbg !292
  store i32 %inc97, i32* %i, align 4, !dbg !292
  %78 = load i32, i32* %argc.addr, align 4, !dbg !293
  %79 = load i32, i32* %i, align 4, !dbg !295
  %cmp98 = icmp eq i32 %78, %79, !dbg !296
  br i1 %cmp98, label %if.then100, label %if.end101, !dbg !297

if.then100:                                       ; preds = %sw.bb93
  call void @bots_print_usage(), !dbg !298
  call void @exit(i32 100) #7, !dbg !300
  unreachable, !dbg !300

if.end101:                                        ; preds = %sw.bb93
  %80 = load i8**, i8*** %argv.addr, align 8, !dbg !301
  %81 = load i32, i32* %i, align 4, !dbg !302
  %idxprom102 = sext i32 %81 to i64, !dbg !301
  %arrayidx103 = getelementptr inbounds i8*, i8** %80, i64 %idxprom102, !dbg !301
  %82 = load i8*, i8** %arrayidx103, align 8, !dbg !301
  %call104 = call i32 @atoi(i8* %82) #8, !dbg !303
  store i32 %call104, i32* @bots_app_cutoff_value, align 4, !dbg !304
  br label %sw.epilog, !dbg !305

sw.bb105:                                         ; preds = %if.then
  %83 = load i8**, i8*** %argv.addr, align 8, !dbg !306
  %84 = load i32, i32* %i, align 4, !dbg !307
  %idxprom106 = sext i32 %84 to i64, !dbg !306
  %arrayidx107 = getelementptr inbounds i8*, i8** %83, i64 %idxprom106, !dbg !306
  %85 = load i8*, i8** %arrayidx107, align 8, !dbg !306
  %arrayidx108 = getelementptr inbounds i8, i8* %85, i64 1, !dbg !306
  store i8 42, i8* %arrayidx108, align 1, !dbg !308
  store i32 1, i32* @bots_print_header, align 4, !dbg !309
  br label %sw.epilog, !dbg !310

sw.default:                                       ; preds = %if.then
  %86 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !311
  %call109 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %86, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.23, i32 0, i32 0)), !dbg !312
  call void @bots_print_usage(), !dbg !313
  call void @exit(i32 100) #7, !dbg !314
  unreachable, !dbg !314

sw.epilog:                                        ; preds = %sw.bb105, %if.end101, %if.end92, %if.end72, %if.end60, %if.end44, %sw.bb32, %if.end28, %if.end
  br label %if.end111, !dbg !315

if.else:                                          ; preds = %for.body
  %87 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !316
  %call110 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %87, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.23, i32 0, i32 0)), !dbg !318
  call void @bots_print_usage(), !dbg !319
  call void @exit(i32 100) #7, !dbg !320
  unreachable, !dbg !320

if.end111:                                        ; preds = %sw.epilog
  br label %for.inc, !dbg !321

for.inc:                                          ; preds = %if.end111
  %88 = load i32, i32* %i, align 4, !dbg !322
  %inc112 = add nsw i32 %88, 1, !dbg !322
  store i32 %inc112, i32* %i, align 4, !dbg !322
  br label %for.cond, !dbg !323, !llvm.loop !324

for.end:                                          ; preds = %for.cond
  ret void, !dbg !326
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: nounwind
declare dso_local i8* @strcpy(i8*, i8*) #3

; Function Attrs: nounwind
declare dso_local i8* @__xpg_basename(i8*) #3

declare dso_local void @bots_get_date(i8*) #1

; Function Attrs: noreturn nounwind
declare dso_local void @exit(i32) #4

; Function Attrs: nounwind readonly
declare dso_local i32 @atoi(i8*) #5

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_get_params(i32 %argc, i8** %argv) #0 !dbg !327 {
entry:
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !328, metadata !DIExpression()), !dbg !329
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !330, metadata !DIExpression()), !dbg !331
  %0 = load i32, i32* %argc.addr, align 4, !dbg !332
  %1 = load i8**, i8*** %argv.addr, align 8, !dbg !333
  call void @bots_get_params_common(i32 %0, i8** %1), !dbg !334
  ret void, !dbg !335
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_set_info() #0 !dbg !336 {
entry:
  %call = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_name, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.24, i32 0, i32 0)) #6, !dbg !337
  %0 = load i32, i32* @bots_arg_size, align 4, !dbg !338
  %1 = load i32, i32* @bots_app_cutoff_value_1, align 4, !dbg !338
  %2 = load i32, i32* @bots_app_cutoff_value_2, align 4, !dbg !338
  %3 = load i32, i32* @bots_app_cutoff_value, align 4, !dbg !338
  %call1 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_parameters, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([20 x i8], [20 x i8]* @.str.25, i32 0, i32 0), i32 %0, i32 %1, i32 %2, i32 %3) #6, !dbg !339
  %call2 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_model, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.26, i32 0, i32 0)) #6, !dbg !340
  %call3 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_resources, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.27, i32 0, i32 0), i32 1) #6, !dbg !341
  %call4 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_comp_date, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.21, i32 0, i32 0)) #6, !dbg !342
  %call5 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_comp_message, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.21, i32 0, i32 0)) #6, !dbg !343
  %call6 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_cc, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.21, i32 0, i32 0)) #6, !dbg !344
  %call7 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_cflags, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.21, i32 0, i32 0)) #6, !dbg !345
  %call8 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_ld, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.21, i32 0, i32 0)) #6, !dbg !346
  %call9 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_ldflags, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.21, i32 0, i32 0)) #6, !dbg !347
  %call10 = call i8* @strcpy(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_cutoff, i32 0, i32 0), i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.28, i32 0, i32 0)) #6, !dbg !348
  ret void, !dbg !349
}

; Function Attrs: nounwind
declare dso_local i32 @snprintf(i8*, i64, i8*, ...) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !350 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %bots_t_start = alloca i64, align 8
  %bots_t_end = alloca i64, align 8
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !353, metadata !DIExpression()), !dbg !354
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !355, metadata !DIExpression()), !dbg !356
  call void @llvm.dbg.declare(metadata i64* %bots_t_start, metadata !357, metadata !DIExpression()), !dbg !359
  call void @llvm.dbg.declare(metadata i64* %bots_t_end, metadata !360, metadata !DIExpression()), !dbg !361
  %0 = load i32, i32* %argc.addr, align 4, !dbg !362
  %1 = load i8**, i8*** %argv.addr, align 8, !dbg !363
  call void @bots_get_params(i32 %0, i8** %1), !dbg !364
  call void @sort_init(), !dbg !365
  call void @bots_set_info(), !dbg !366
  %call = call i64 (...) @bots_usecs(), !dbg !367
  store i64 %call, i64* %bots_t_start, align 8, !dbg !368
  call void @sort(), !dbg !369
  %call1 = call i64 (...) @bots_usecs(), !dbg !370
  store i64 %call1, i64* %bots_t_end, align 8, !dbg !371
  %2 = load i64, i64* %bots_t_end, align 8, !dbg !372
  %3 = load i64, i64* %bots_t_start, align 8, !dbg !373
  %sub = sub nsw i64 %2, %3, !dbg !374
  %conv = sitofp i64 %sub to double, !dbg !375
  %div = fdiv double %conv, 1.000000e+06, !dbg !376
  store double %div, double* @bots_time_program, align 8, !dbg !377
  %4 = load i32, i32* @bots_check_flag, align 4, !dbg !378
  %tobool = icmp ne i32 %4, 0, !dbg !378
  br i1 %tobool, label %if.then, label %if.end, !dbg !380

if.then:                                          ; preds = %entry
  %call2 = call i32 @sort_verify(), !dbg !381
  store i32 %call2, i32* @bots_result, align 4, !dbg !383
  br label %if.end, !dbg !384

if.end:                                           ; preds = %if.then, %entry
  call void @bots_print_results(), !dbg !385
  ret i32 0, !dbg !386
}

declare dso_local void @sort_init() #1

declare dso_local i64 @bots_usecs(...) #1

declare dso_local void @sort() #1

declare dso_local i32 @sort_verify() #1

declare dso_local void @bots_print_results() #1

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind readnone speculatable }
attributes #3 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { nounwind }
attributes #7 = { noreturn nounwind }
attributes #8 = { nounwind readonly }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!74, !75, !76}
!llvm.ident = !{!77}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "bots_sequential_flag", scope: !2, file: !3, line: 41, type: !18, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 8.0.1-9 (tags/RELEASE_801/final)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !12, globals: !15, nameTableKind: None)
!3 = !DIFile(filename: "bots_main.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/sort")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 76, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "./bots.h", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/sort")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11}
!9 = !DIEnumerator(name: "BOTS_VERBOSE_NONE", value: 0, isUnsigned: true)
!10 = !DIEnumerator(name: "BOTS_VERBOSE_DEFAULT", value: 1, isUnsigned: true)
!11 = !DIEnumerator(name: "BOTS_VERBOSE_DEBUG", value: 2, isUnsigned: true)
!12 = !{!13, !14}
!13 = !DIDerivedType(tag: DW_TAG_typedef, name: "bots_verbose_mode_t", file: !6, line: 78, baseType: !5)
!14 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!15 = !{!0, !16, !19, !21, !23, !25, !27, !29, !31, !34, !36, !38, !40, !42, !48, !50, !52, !54, !56, !58, !60, !62, !64, !66, !68, !70, !72}
!16 = !DIGlobalVariableExpression(var: !17, expr: !DIExpression())
!17 = distinct !DIGlobalVariable(name: "bots_check_flag", scope: !2, file: !3, line: 42, type: !18, isLocal: false, isDefinition: true)
!18 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!19 = !DIGlobalVariableExpression(var: !20, expr: !DIExpression())
!20 = distinct !DIGlobalVariable(name: "bots_verbose_mode", scope: !2, file: !3, line: 43, type: !13, isLocal: false, isDefinition: true)
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(name: "bots_result", scope: !2, file: !3, line: 44, type: !18, isLocal: false, isDefinition: true)
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(name: "bots_output_format", scope: !2, file: !3, line: 45, type: !18, isLocal: false, isDefinition: true)
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(name: "bots_print_header", scope: !2, file: !3, line: 46, type: !18, isLocal: false, isDefinition: true)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(name: "bots_time_program", scope: !2, file: !3, line: 65, type: !14, isLocal: false, isDefinition: true)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(name: "bots_time_sequential", scope: !2, file: !3, line: 66, type: !14, isLocal: false, isDefinition: true)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(name: "bots_number_of_tasks", scope: !2, file: !3, line: 67, type: !33, isLocal: false, isDefinition: true)
!33 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(name: "bots_arg_size", scope: !2, file: !3, line: 124, type: !18, isLocal: false, isDefinition: true)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(name: "bots_app_cutoff_value", scope: !2, file: !3, line: 181, type: !18, isLocal: false, isDefinition: true)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(name: "bots_app_cutoff_value_1", scope: !2, file: !3, line: 191, type: !18, isLocal: false, isDefinition: true)
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(name: "bots_app_cutoff_value_2", scope: !2, file: !3, line: 201, type: !18, isLocal: false, isDefinition: true)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(name: "bots_name", scope: !2, file: !3, line: 48, type: !44, isLocal: false, isDefinition: true)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !45, size: 2048, elements: !46)
!45 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!46 = !{!47}
!47 = !DISubrange(count: 256)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "bots_execname", scope: !2, file: !3, line: 49, type: !44, isLocal: false, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "bots_parameters", scope: !2, file: !3, line: 50, type: !44, isLocal: false, isDefinition: true)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(name: "bots_model", scope: !2, file: !3, line: 51, type: !44, isLocal: false, isDefinition: true)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "bots_resources", scope: !2, file: !3, line: 52, type: !44, isLocal: false, isDefinition: true)
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(name: "bots_exec_date", scope: !2, file: !3, line: 54, type: !44, isLocal: false, isDefinition: true)
!58 = !DIGlobalVariableExpression(var: !59, expr: !DIExpression())
!59 = distinct !DIGlobalVariable(name: "bots_exec_message", scope: !2, file: !3, line: 55, type: !44, isLocal: false, isDefinition: true)
!60 = !DIGlobalVariableExpression(var: !61, expr: !DIExpression())
!61 = distinct !DIGlobalVariable(name: "bots_comp_date", scope: !2, file: !3, line: 56, type: !44, isLocal: false, isDefinition: true)
!62 = !DIGlobalVariableExpression(var: !63, expr: !DIExpression())
!63 = distinct !DIGlobalVariable(name: "bots_comp_message", scope: !2, file: !3, line: 57, type: !44, isLocal: false, isDefinition: true)
!64 = !DIGlobalVariableExpression(var: !65, expr: !DIExpression())
!65 = distinct !DIGlobalVariable(name: "bots_cc", scope: !2, file: !3, line: 58, type: !44, isLocal: false, isDefinition: true)
!66 = !DIGlobalVariableExpression(var: !67, expr: !DIExpression())
!67 = distinct !DIGlobalVariable(name: "bots_cflags", scope: !2, file: !3, line: 59, type: !44, isLocal: false, isDefinition: true)
!68 = !DIGlobalVariableExpression(var: !69, expr: !DIExpression())
!69 = distinct !DIGlobalVariable(name: "bots_ld", scope: !2, file: !3, line: 60, type: !44, isLocal: false, isDefinition: true)
!70 = !DIGlobalVariableExpression(var: !71, expr: !DIExpression())
!71 = distinct !DIGlobalVariable(name: "bots_ldflags", scope: !2, file: !3, line: 61, type: !44, isLocal: false, isDefinition: true)
!72 = !DIGlobalVariableExpression(var: !73, expr: !DIExpression())
!73 = distinct !DIGlobalVariable(name: "bots_cutoff", scope: !2, file: !3, line: 62, type: !44, isLocal: false, isDefinition: true)
!74 = !{i32 2, !"Dwarf Version", i32 4}
!75 = !{i32 2, !"Debug Info Version", i32 3}
!76 = !{i32 1, !"wchar_size", i32 4}
!77 = !{!"clang version 8.0.1-9 (tags/RELEASE_801/final)"}
!78 = distinct !DISubprogram(name: "bots_print_usage", scope: !3, file: !3, line: 211, type: !79, scopeLine: 212, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !81)
!79 = !DISubroutineType(types: !80)
!80 = !{null}
!81 = !{}
!82 = !DILocation(line: 213, column: 12, scope: !78)
!83 = !DILocation(line: 213, column: 4, scope: !78)
!84 = !DILocation(line: 214, column: 12, scope: !78)
!85 = !DILocation(line: 214, column: 4, scope: !78)
!86 = !DILocation(line: 215, column: 12, scope: !78)
!87 = !DILocation(line: 215, column: 4, scope: !78)
!88 = !DILocation(line: 216, column: 12, scope: !78)
!89 = !DILocation(line: 216, column: 4, scope: !78)
!90 = !DILocation(line: 221, column: 12, scope: !78)
!91 = !DILocation(line: 221, column: 4, scope: !78)
!92 = !DILocation(line: 236, column: 12, scope: !78)
!93 = !DILocation(line: 236, column: 4, scope: !78)
!94 = !DILocation(line: 239, column: 12, scope: !78)
!95 = !DILocation(line: 239, column: 4, scope: !78)
!96 = !DILocation(line: 242, column: 12, scope: !78)
!97 = !DILocation(line: 242, column: 4, scope: !78)
!98 = !DILocation(line: 245, column: 12, scope: !78)
!99 = !DILocation(line: 245, column: 4, scope: !78)
!100 = !DILocation(line: 246, column: 12, scope: !78)
!101 = !DILocation(line: 246, column: 4, scope: !78)
!102 = !DILocation(line: 247, column: 12, scope: !78)
!103 = !DILocation(line: 247, column: 4, scope: !78)
!104 = !DILocation(line: 248, column: 12, scope: !78)
!105 = !DILocation(line: 248, column: 4, scope: !78)
!106 = !DILocation(line: 249, column: 12, scope: !78)
!107 = !DILocation(line: 249, column: 4, scope: !78)
!108 = !DILocation(line: 250, column: 12, scope: !78)
!109 = !DILocation(line: 250, column: 4, scope: !78)
!110 = !DILocation(line: 251, column: 12, scope: !78)
!111 = !DILocation(line: 251, column: 4, scope: !78)
!112 = !DILocation(line: 252, column: 12, scope: !78)
!113 = !DILocation(line: 252, column: 4, scope: !78)
!114 = !DILocation(line: 253, column: 12, scope: !78)
!115 = !DILocation(line: 253, column: 4, scope: !78)
!116 = !DILocation(line: 254, column: 12, scope: !78)
!117 = !DILocation(line: 254, column: 4, scope: !78)
!118 = !DILocation(line: 255, column: 12, scope: !78)
!119 = !DILocation(line: 255, column: 4, scope: !78)
!120 = !DILocation(line: 256, column: 12, scope: !78)
!121 = !DILocation(line: 256, column: 4, scope: !78)
!122 = !DILocation(line: 257, column: 12, scope: !78)
!123 = !DILocation(line: 257, column: 4, scope: !78)
!124 = !DILocation(line: 258, column: 12, scope: !78)
!125 = !DILocation(line: 258, column: 4, scope: !78)
!126 = !DILocation(line: 265, column: 12, scope: !78)
!127 = !DILocation(line: 265, column: 4, scope: !78)
!128 = !DILocation(line: 267, column: 12, scope: !78)
!129 = !DILocation(line: 267, column: 4, scope: !78)
!130 = !DILocation(line: 268, column: 12, scope: !78)
!131 = !DILocation(line: 268, column: 4, scope: !78)
!132 = !DILocation(line: 269, column: 12, scope: !78)
!133 = !DILocation(line: 269, column: 4, scope: !78)
!134 = !DILocation(line: 270, column: 1, scope: !78)
!135 = distinct !DISubprogram(name: "bots_get_params_common", scope: !3, file: !3, line: 275, type: !136, scopeLine: 276, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !81)
!136 = !DISubroutineType(types: !137)
!137 = !{null, !18, !138}
!138 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !139, size: 64)
!139 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !45, size: 64)
!140 = !DILocalVariable(name: "argc", arg: 1, scope: !135, file: !3, line: 275, type: !18)
!141 = !DILocation(line: 275, column: 28, scope: !135)
!142 = !DILocalVariable(name: "argv", arg: 2, scope: !135, file: !3, line: 275, type: !138)
!143 = !DILocation(line: 275, column: 41, scope: !135)
!144 = !DILocalVariable(name: "i", scope: !135, file: !3, line: 277, type: !18)
!145 = !DILocation(line: 277, column: 8, scope: !135)
!146 = !DILocation(line: 278, column: 35, scope: !135)
!147 = !DILocation(line: 278, column: 26, scope: !135)
!148 = !DILocation(line: 278, column: 4, scope: !135)
!149 = !DILocation(line: 279, column: 4, scope: !135)
!150 = !DILocation(line: 280, column: 4, scope: !135)
!151 = !DILocation(line: 281, column: 10, scope: !152)
!152 = distinct !DILexicalBlock(scope: !135, file: !3, line: 281, column: 4)
!153 = !DILocation(line: 281, column: 9, scope: !152)
!154 = !DILocation(line: 281, column: 14, scope: !155)
!155 = distinct !DILexicalBlock(scope: !152, file: !3, line: 281, column: 4)
!156 = !DILocation(line: 281, column: 16, scope: !155)
!157 = !DILocation(line: 281, column: 15, scope: !155)
!158 = !DILocation(line: 281, column: 4, scope: !152)
!159 = !DILocation(line: 283, column: 11, scope: !160)
!160 = distinct !DILexicalBlock(scope: !161, file: !3, line: 283, column: 11)
!161 = distinct !DILexicalBlock(scope: !155, file: !3, line: 282, column: 4)
!162 = !DILocation(line: 283, column: 16, scope: !160)
!163 = !DILocation(line: 283, column: 22, scope: !160)
!164 = !DILocation(line: 283, column: 11, scope: !161)
!165 = !DILocation(line: 285, column: 18, scope: !166)
!166 = distinct !DILexicalBlock(scope: !160, file: !3, line: 284, column: 7)
!167 = !DILocation(line: 285, column: 23, scope: !166)
!168 = !DILocation(line: 285, column: 10, scope: !166)
!169 = !DILocation(line: 289, column: 9, scope: !170)
!170 = distinct !DILexicalBlock(scope: !166, file: !3, line: 286, column: 10)
!171 = !DILocation(line: 289, column: 14, scope: !170)
!172 = !DILocation(line: 289, column: 20, scope: !170)
!173 = !DILocation(line: 290, column: 17, scope: !170)
!174 = !DILocation(line: 291, column: 20, scope: !175)
!175 = distinct !DILexicalBlock(scope: !170, file: !3, line: 291, column: 20)
!176 = !DILocation(line: 291, column: 28, scope: !175)
!177 = !DILocation(line: 291, column: 25, scope: !175)
!178 = !DILocation(line: 291, column: 20, scope: !170)
!179 = !DILocation(line: 291, column: 33, scope: !180)
!180 = distinct !DILexicalBlock(scope: !175, file: !3, line: 291, column: 31)
!181 = !DILocation(line: 291, column: 53, scope: !180)
!182 = !DILocation(line: 292, column: 47, scope: !170)
!183 = !DILocation(line: 292, column: 52, scope: !170)
!184 = !DILocation(line: 292, column: 42, scope: !170)
!185 = !DILocation(line: 292, column: 40, scope: !170)
!186 = !DILocation(line: 293, column: 16, scope: !170)
!187 = !DILocation(line: 297, column: 9, scope: !170)
!188 = !DILocation(line: 297, column: 14, scope: !170)
!189 = !DILocation(line: 297, column: 20, scope: !170)
!190 = !DILocation(line: 298, column: 17, scope: !170)
!191 = !DILocation(line: 299, column: 20, scope: !192)
!192 = distinct !DILexicalBlock(scope: !170, file: !3, line: 299, column: 20)
!193 = !DILocation(line: 299, column: 28, scope: !192)
!194 = !DILocation(line: 299, column: 25, scope: !192)
!195 = !DILocation(line: 299, column: 20, scope: !170)
!196 = !DILocation(line: 299, column: 33, scope: !197)
!197 = distinct !DILexicalBlock(scope: !192, file: !3, line: 299, column: 31)
!198 = !DILocation(line: 299, column: 53, scope: !197)
!199 = !DILocation(line: 300, column: 47, scope: !170)
!200 = !DILocation(line: 300, column: 52, scope: !170)
!201 = !DILocation(line: 300, column: 42, scope: !170)
!202 = !DILocation(line: 300, column: 40, scope: !170)
!203 = !DILocation(line: 301, column: 16, scope: !170)
!204 = !DILocation(line: 304, column: 16, scope: !170)
!205 = !DILocation(line: 304, column: 21, scope: !170)
!206 = !DILocation(line: 304, column: 27, scope: !170)
!207 = !DILocation(line: 308, column: 32, scope: !170)
!208 = !DILocation(line: 309, column: 16, scope: !170)
!209 = !DILocation(line: 311, column: 16, scope: !170)
!210 = !DILocation(line: 311, column: 21, scope: !170)
!211 = !DILocation(line: 311, column: 27, scope: !170)
!212 = !DILocation(line: 312, column: 17, scope: !170)
!213 = !DILocation(line: 313, column: 20, scope: !214)
!214 = distinct !DILexicalBlock(scope: !170, file: !3, line: 313, column: 20)
!215 = !DILocation(line: 313, column: 28, scope: !214)
!216 = !DILocation(line: 313, column: 25, scope: !214)
!217 = !DILocation(line: 313, column: 20, scope: !170)
!218 = !DILocation(line: 313, column: 33, scope: !219)
!219 = distinct !DILexicalBlock(scope: !214, file: !3, line: 313, column: 31)
!220 = !DILocation(line: 313, column: 53, scope: !219)
!221 = !DILocation(line: 314, column: 42, scope: !170)
!222 = !DILocation(line: 314, column: 47, scope: !170)
!223 = !DILocation(line: 314, column: 16, scope: !170)
!224 = !DILocation(line: 315, column: 16, scope: !170)
!225 = !DILocation(line: 325, column: 16, scope: !170)
!226 = !DILocation(line: 325, column: 21, scope: !170)
!227 = !DILocation(line: 325, column: 27, scope: !170)
!228 = !DILocation(line: 326, column: 16, scope: !170)
!229 = !DILocation(line: 327, column: 16, scope: !170)
!230 = !DILocation(line: 346, column: 16, scope: !170)
!231 = !DILocation(line: 346, column: 21, scope: !170)
!232 = !DILocation(line: 346, column: 27, scope: !170)
!233 = !DILocation(line: 347, column: 17, scope: !170)
!234 = !DILocation(line: 348, column: 20, scope: !235)
!235 = distinct !DILexicalBlock(scope: !170, file: !3, line: 348, column: 20)
!236 = !DILocation(line: 348, column: 28, scope: !235)
!237 = !DILocation(line: 348, column: 25, scope: !235)
!238 = !DILocation(line: 348, column: 20, scope: !170)
!239 = !DILocation(line: 348, column: 33, scope: !240)
!240 = distinct !DILexicalBlock(scope: !235, file: !3, line: 348, column: 31)
!241 = !DILocation(line: 348, column: 53, scope: !240)
!242 = !DILocation(line: 349, column: 37, scope: !170)
!243 = !DILocation(line: 349, column: 42, scope: !170)
!244 = !DILocation(line: 349, column: 32, scope: !170)
!245 = !DILocation(line: 349, column: 30, scope: !170)
!246 = !DILocation(line: 350, column: 16, scope: !170)
!247 = !DILocation(line: 356, column: 16, scope: !170)
!248 = !DILocation(line: 356, column: 21, scope: !170)
!249 = !DILocation(line: 356, column: 27, scope: !170)
!250 = !DILocation(line: 357, column: 17, scope: !170)
!251 = !DILocation(line: 358, column: 20, scope: !252)
!252 = distinct !DILexicalBlock(scope: !170, file: !3, line: 358, column: 20)
!253 = !DILocation(line: 358, column: 28, scope: !252)
!254 = !DILocation(line: 358, column: 25, scope: !252)
!255 = !DILocation(line: 358, column: 20, scope: !170)
!256 = !DILocation(line: 358, column: 33, scope: !257)
!257 = distinct !DILexicalBlock(scope: !252, file: !3, line: 358, column: 31)
!258 = !DILocation(line: 358, column: 53, scope: !257)
!259 = !DILocation(line: 359, column: 42, scope: !170)
!260 = !DILocation(line: 359, column: 47, scope: !170)
!261 = !DILocation(line: 359, column: 37, scope: !170)
!262 = !DILocation(line: 359, column: 35, scope: !170)
!263 = !DILocation(line: 360, column: 16, scope: !170)
!264 = !DILocation(line: 379, column: 16, scope: !170)
!265 = !DILocation(line: 379, column: 21, scope: !170)
!266 = !DILocation(line: 379, column: 27, scope: !170)
!267 = !DILocation(line: 380, column: 17, scope: !170)
!268 = !DILocation(line: 381, column: 20, scope: !269)
!269 = distinct !DILexicalBlock(scope: !170, file: !3, line: 381, column: 20)
!270 = !DILocation(line: 381, column: 28, scope: !269)
!271 = !DILocation(line: 381, column: 25, scope: !269)
!272 = !DILocation(line: 381, column: 20, scope: !170)
!273 = !DILocation(line: 381, column: 33, scope: !274)
!274 = distinct !DILexicalBlock(scope: !269, file: !3, line: 381, column: 31)
!275 = !DILocation(line: 381, column: 53, scope: !274)
!276 = !DILocation(line: 382, column: 63, scope: !170)
!277 = !DILocation(line: 382, column: 68, scope: !170)
!278 = !DILocation(line: 382, column: 58, scope: !170)
!279 = !DILocation(line: 382, column: 34, scope: !170)
!280 = !DILocation(line: 384, column: 21, scope: !281)
!281 = distinct !DILexicalBlock(scope: !170, file: !3, line: 384, column: 21)
!282 = !DILocation(line: 384, column: 39, scope: !281)
!283 = !DILocation(line: 384, column: 21, scope: !170)
!284 = !DILocation(line: 385, column: 27, scope: !285)
!285 = distinct !DILexicalBlock(scope: !281, file: !3, line: 384, column: 45)
!286 = !DILocation(line: 385, column: 19, scope: !285)
!287 = !DILocation(line: 386, column: 19, scope: !285)
!288 = !DILocation(line: 389, column: 16, scope: !170)
!289 = !DILocation(line: 400, column: 9, scope: !170)
!290 = !DILocation(line: 400, column: 14, scope: !170)
!291 = !DILocation(line: 400, column: 20, scope: !170)
!292 = !DILocation(line: 401, column: 17, scope: !170)
!293 = !DILocation(line: 402, column: 20, scope: !294)
!294 = distinct !DILexicalBlock(scope: !170, file: !3, line: 402, column: 20)
!295 = !DILocation(line: 402, column: 28, scope: !294)
!296 = !DILocation(line: 402, column: 25, scope: !294)
!297 = !DILocation(line: 402, column: 20, scope: !170)
!298 = !DILocation(line: 402, column: 33, scope: !299)
!299 = distinct !DILexicalBlock(scope: !294, file: !3, line: 402, column: 31)
!300 = !DILocation(line: 402, column: 53, scope: !299)
!301 = !DILocation(line: 403, column: 45, scope: !170)
!302 = !DILocation(line: 403, column: 50, scope: !170)
!303 = !DILocation(line: 403, column: 40, scope: !170)
!304 = !DILocation(line: 403, column: 38, scope: !170)
!305 = !DILocation(line: 404, column: 16, scope: !170)
!306 = !DILocation(line: 407, column: 9, scope: !170)
!307 = !DILocation(line: 407, column: 14, scope: !170)
!308 = !DILocation(line: 407, column: 20, scope: !170)
!309 = !DILocation(line: 408, column: 34, scope: !170)
!310 = !DILocation(line: 409, column: 16, scope: !170)
!311 = !DILocation(line: 415, column: 24, scope: !170)
!312 = !DILocation(line: 415, column: 16, scope: !170)
!313 = !DILocation(line: 416, column: 16, scope: !170)
!314 = !DILocation(line: 417, column: 16, scope: !170)
!315 = !DILocation(line: 419, column: 7, scope: !166)
!316 = !DILocation(line: 426, column: 18, scope: !317)
!317 = distinct !DILexicalBlock(scope: !160, file: !3, line: 421, column: 7)
!318 = !DILocation(line: 426, column: 10, scope: !317)
!319 = !DILocation(line: 427, column: 10, scope: !317)
!320 = !DILocation(line: 428, column: 10, scope: !317)
!321 = !DILocation(line: 430, column: 4, scope: !161)
!322 = !DILocation(line: 281, column: 23, scope: !155)
!323 = !DILocation(line: 281, column: 4, scope: !155)
!324 = distinct !{!324, !158, !325}
!325 = !DILocation(line: 430, column: 4, scope: !152)
!326 = !DILocation(line: 431, column: 1, scope: !135)
!327 = distinct !DISubprogram(name: "bots_get_params", scope: !3, file: !3, line: 436, type: !136, scopeLine: 437, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !81)
!328 = !DILocalVariable(name: "argc", arg: 1, scope: !327, file: !3, line: 436, type: !18)
!329 = !DILocation(line: 436, column: 21, scope: !327)
!330 = !DILocalVariable(name: "argv", arg: 2, scope: !327, file: !3, line: 436, type: !138)
!331 = !DILocation(line: 436, column: 34, scope: !327)
!332 = !DILocation(line: 438, column: 27, scope: !327)
!333 = !DILocation(line: 438, column: 33, scope: !327)
!334 = !DILocation(line: 438, column: 4, scope: !327)
!335 = !DILocation(line: 440, column: 1, scope: !327)
!336 = distinct !DISubprogram(name: "bots_set_info", scope: !3, file: !3, line: 446, type: !79, scopeLine: 447, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !81)
!337 = !DILocation(line: 449, column: 4, scope: !336)
!338 = !DILocation(line: 450, column: 72, scope: !336)
!339 = !DILocation(line: 450, column: 4, scope: !336)
!340 = !DILocation(line: 451, column: 4, scope: !336)
!341 = !DILocation(line: 452, column: 4, scope: !336)
!342 = !DILocation(line: 455, column: 4, scope: !336)
!343 = !DILocation(line: 456, column: 4, scope: !336)
!344 = !DILocation(line: 457, column: 4, scope: !336)
!345 = !DILocation(line: 458, column: 4, scope: !336)
!346 = !DILocation(line: 459, column: 4, scope: !336)
!347 = !DILocation(line: 460, column: 4, scope: !336)
!348 = !DILocation(line: 469, column: 4, scope: !336)
!349 = !DILocation(line: 471, column: 1, scope: !336)
!350 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 477, type: !351, scopeLine: 478, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !81)
!351 = !DISubroutineType(types: !352)
!352 = !{!18, !18, !138}
!353 = !DILocalVariable(name: "argc", arg: 1, scope: !350, file: !3, line: 477, type: !18)
!354 = !DILocation(line: 477, column: 10, scope: !350)
!355 = !DILocalVariable(name: "argv", arg: 2, scope: !350, file: !3, line: 477, type: !138)
!356 = !DILocation(line: 477, column: 22, scope: !350)
!357 = !DILocalVariable(name: "bots_t_start", scope: !350, file: !3, line: 480, type: !358)
!358 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!359 = !DILocation(line: 480, column: 9, scope: !350)
!360 = !DILocalVariable(name: "bots_t_end", scope: !350, file: !3, line: 481, type: !358)
!361 = !DILocation(line: 481, column: 9, scope: !350)
!362 = !DILocation(line: 484, column: 20, scope: !350)
!363 = !DILocation(line: 484, column: 25, scope: !350)
!364 = !DILocation(line: 484, column: 4, scope: !350)
!365 = !DILocation(line: 485, column: 4, scope: !350)
!366 = !DILocation(line: 486, column: 4, scope: !350)
!367 = !DILocation(line: 513, column: 19, scope: !350)
!368 = !DILocation(line: 513, column: 17, scope: !350)
!369 = !DILocation(line: 514, column: 4, scope: !350)
!370 = !DILocation(line: 515, column: 17, scope: !350)
!371 = !DILocation(line: 515, column: 15, scope: !350)
!372 = !DILocation(line: 516, column: 34, scope: !350)
!373 = !DILocation(line: 516, column: 45, scope: !350)
!374 = !DILocation(line: 516, column: 44, scope: !350)
!375 = !DILocation(line: 516, column: 25, scope: !350)
!376 = !DILocation(line: 516, column: 59, scope: !350)
!377 = !DILocation(line: 516, column: 22, scope: !350)
!378 = !DILocation(line: 521, column: 8, scope: !379)
!379 = distinct !DILexicalBlock(scope: !350, file: !3, line: 521, column: 8)
!380 = !DILocation(line: 521, column: 8, scope: !350)
!381 = !DILocation(line: 522, column: 20, scope: !382)
!382 = distinct !DILexicalBlock(scope: !379, file: !3, line: 521, column: 25)
!383 = !DILocation(line: 522, column: 18, scope: !382)
!384 = !DILocation(line: 523, column: 4, scope: !382)
!385 = !DILocation(line: 528, column: 4, scope: !350)
!386 = !DILocation(line: 529, column: 4, scope: !350)
