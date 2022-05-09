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
@bots_arg_size = dso_local global i32 10, align 4, !dbg !34
@stderr = external dso_local global %struct._IO_FILE*, align 8
@.str = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.1 = private unnamed_addr constant [22 x i8] c"Usage: %s -[options]\0A\00", align 1
@bots_execname = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !42
@.str.2 = private unnamed_addr constant [20 x i8] c"Where options are:\0A\00", align 1
@.str.3 = private unnamed_addr constant [34 x i8] c"  -n <size>  : Number to compute\0A\00", align 1
@.str.4 = private unnamed_addr constant [49 x i8] c"  -e <str>   : Include 'str' execution message.\0A\00", align 1
@.str.5 = private unnamed_addr constant [49 x i8] c"  -v <level> : Set verbose level (default = 1).\0A\00", align 1
@.str.6 = private unnamed_addr constant [26 x i8] c"               0 - none.\0A\00", align 1
@.str.7 = private unnamed_addr constant [29 x i8] c"               1 - default.\0A\00", align 1
@.str.8 = private unnamed_addr constant [27 x i8] c"               2 - debug.\0A\00", align 1
@.str.9 = private unnamed_addr constant [54 x i8] c"  -o <value> : Set output format mode (default = 1).\0A\00", align 1
@.str.10 = private unnamed_addr constant [41 x i8] c"               0 - no benchmark output.\0A\00", align 1
@.str.11 = private unnamed_addr constant [42 x i8] c"               1 - detailed list format.\0A\00", align 1
@.str.12 = private unnamed_addr constant [41 x i8] c"               2 - detailed row format.\0A\00", align 1
@.str.13 = private unnamed_addr constant [42 x i8] c"               3 - abridged list format.\0A\00", align 1
@.str.14 = private unnamed_addr constant [41 x i8] c"               4 - abridged row format.\0A\00", align 1
@.str.15 = private unnamed_addr constant [70 x i8] c"  -z         : Print row header (if output format is a row variant).\0A\00", align 1
@.str.16 = private unnamed_addr constant [31 x i8] c"  -c         : Check mode ON.\0A\00", align 1
@.str.17 = private unnamed_addr constant [51 x i8] c"  -h         : Print program's usage (this help).\0A\00", align 1
@bots_exec_date = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !50
@bots_exec_message = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !52
@.str.18 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.19 = private unnamed_addr constant [100 x i8] c"Error: Configure the suite using '--debug' option in order to use a verbose level greather than 1.\0A\00", align 1
@.str.20 = private unnamed_addr constant [32 x i8] c"Error: Unrecognized parameter.\0A\00", align 1
@bots_name = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !36
@.str.21 = private unnamed_addr constant [10 x i8] c"Fibonacci\00", align 1
@bots_parameters = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !44
@.str.22 = private unnamed_addr constant [5 x i8] c"N=%d\00", align 1
@bots_model = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !46
@.str.23 = private unnamed_addr constant [7 x i8] c"Serial\00", align 1
@bots_resources = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !48
@.str.24 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@bots_comp_date = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !54
@bots_comp_message = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !56
@bots_cc = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !58
@bots_cflags = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !60
@bots_ld = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !62
@bots_ldflags = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !64
@bots_cutoff = common dso_local global [256 x i8] zeroinitializer, align 16, !dbg !66
@.str.25 = private unnamed_addr constant [5 x i8] c"none\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_print_usage() #0 !dbg !72 {
entry:
  %0 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !76
  %call = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %0, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0)), !dbg !77
  %1 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !78
  %call1 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %1, i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.1, i32 0, i32 0), i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_execname, i32 0, i32 0)), !dbg !79
  %2 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !80
  %call2 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0)), !dbg !81
  %3 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !82
  %call3 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([20 x i8], [20 x i8]* @.str.2, i32 0, i32 0)), !dbg !83
  %4 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !84
  %call4 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %4, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.3, i32 0, i32 0)), !dbg !85
  %5 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !86
  %call5 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0)), !dbg !87
  %6 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !88
  %call6 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %6, i8* getelementptr inbounds ([49 x i8], [49 x i8]* @.str.4, i32 0, i32 0)), !dbg !89
  %7 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !90
  %call7 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %7, i8* getelementptr inbounds ([49 x i8], [49 x i8]* @.str.5, i32 0, i32 0)), !dbg !91
  %8 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !92
  %call8 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %8, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.6, i32 0, i32 0)), !dbg !93
  %9 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !94
  %call9 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %9, i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str.7, i32 0, i32 0)), !dbg !95
  %10 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !96
  %call10 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %10, i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.8, i32 0, i32 0)), !dbg !97
  %11 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !98
  %call11 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %11, i8* getelementptr inbounds ([54 x i8], [54 x i8]* @.str.9, i32 0, i32 0)), !dbg !99
  %12 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !100
  %call12 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %12, i8* getelementptr inbounds ([41 x i8], [41 x i8]* @.str.10, i32 0, i32 0)), !dbg !101
  %13 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !102
  %call13 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %13, i8* getelementptr inbounds ([42 x i8], [42 x i8]* @.str.11, i32 0, i32 0)), !dbg !103
  %14 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !104
  %call14 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %14, i8* getelementptr inbounds ([41 x i8], [41 x i8]* @.str.12, i32 0, i32 0)), !dbg !105
  %15 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !106
  %call15 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %15, i8* getelementptr inbounds ([42 x i8], [42 x i8]* @.str.13, i32 0, i32 0)), !dbg !107
  %16 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !108
  %call16 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %16, i8* getelementptr inbounds ([41 x i8], [41 x i8]* @.str.14, i32 0, i32 0)), !dbg !109
  %17 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !110
  %call17 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %17, i8* getelementptr inbounds ([70 x i8], [70 x i8]* @.str.15, i32 0, i32 0)), !dbg !111
  %18 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !112
  %call18 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %18, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0)), !dbg !113
  %19 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !114
  %call19 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %19, i8* getelementptr inbounds ([31 x i8], [31 x i8]* @.str.16, i32 0, i32 0)), !dbg !115
  %20 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !116
  %call20 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %20, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0)), !dbg !117
  %21 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !118
  %call21 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %21, i8* getelementptr inbounds ([51 x i8], [51 x i8]* @.str.17, i32 0, i32 0)), !dbg !119
  %22 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !120
  %call22 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %22, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0)), !dbg !121
  ret void, !dbg !122
}

declare dso_local i32 @fprintf(%struct._IO_FILE*, i8*, ...) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_get_params_common(i32 %argc, i8** %argv) #0 !dbg !123 {
entry:
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !128, metadata !DIExpression()), !dbg !129
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !130, metadata !DIExpression()), !dbg !131
  call void @llvm.dbg.declare(metadata i32* %i, metadata !132, metadata !DIExpression()), !dbg !133
  %0 = load i8**, i8*** %argv.addr, align 8, !dbg !134
  %arrayidx = getelementptr inbounds i8*, i8** %0, i64 0, !dbg !134
  %1 = load i8*, i8** %arrayidx, align 8, !dbg !134
  %call = call i8* @__xpg_basename(i8* %1) #6, !dbg !135
  %call1 = call i8* @strcpy(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_execname, i32 0, i32 0), i8* %call) #6, !dbg !136
  call void @bots_get_date(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_exec_date, i32 0, i32 0)), !dbg !137
  %call2 = call i8* @strcpy(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_exec_message, i32 0, i32 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.18, i32 0, i32 0)) #6, !dbg !138
  store i32 1, i32* %i, align 4, !dbg !139
  br label %for.cond, !dbg !141

for.cond:                                         ; preds = %for.inc, %entry
  %2 = load i32, i32* %i, align 4, !dbg !142
  %3 = load i32, i32* %argc.addr, align 4, !dbg !144
  %cmp = icmp slt i32 %2, %3, !dbg !145
  br i1 %cmp, label %for.body, label %for.end, !dbg !146

for.body:                                         ; preds = %for.cond
  %4 = load i8**, i8*** %argv.addr, align 8, !dbg !147
  %5 = load i32, i32* %i, align 4, !dbg !150
  %idxprom = sext i32 %5 to i64, !dbg !147
  %arrayidx3 = getelementptr inbounds i8*, i8** %4, i64 %idxprom, !dbg !147
  %6 = load i8*, i8** %arrayidx3, align 8, !dbg !147
  %arrayidx4 = getelementptr inbounds i8, i8* %6, i64 0, !dbg !147
  %7 = load i8, i8* %arrayidx4, align 1, !dbg !147
  %conv = sext i8 %7 to i32, !dbg !147
  %cmp5 = icmp eq i32 %conv, 45, !dbg !151
  br i1 %cmp5, label %if.then, label %if.else, !dbg !152

if.then:                                          ; preds = %for.body
  %8 = load i8**, i8*** %argv.addr, align 8, !dbg !153
  %9 = load i32, i32* %i, align 4, !dbg !155
  %idxprom7 = sext i32 %9 to i64, !dbg !153
  %arrayidx8 = getelementptr inbounds i8*, i8** %8, i64 %idxprom7, !dbg !153
  %10 = load i8*, i8** %arrayidx8, align 8, !dbg !153
  %arrayidx9 = getelementptr inbounds i8, i8* %10, i64 1, !dbg !153
  %11 = load i8, i8* %arrayidx9, align 1, !dbg !153
  %conv10 = sext i8 %11 to i32, !dbg !153
  switch i32 %conv10, label %sw.default [
    i32 99, label %sw.bb
    i32 101, label %sw.bb14
    i32 104, label %sw.bb24
    i32 110, label %sw.bb28
    i32 111, label %sw.bb40
    i32 118, label %sw.bb52
    i32 122, label %sw.bb69
  ], !dbg !156

sw.bb:                                            ; preds = %if.then
  %12 = load i8**, i8*** %argv.addr, align 8, !dbg !157
  %13 = load i32, i32* %i, align 4, !dbg !159
  %idxprom11 = sext i32 %13 to i64, !dbg !157
  %arrayidx12 = getelementptr inbounds i8*, i8** %12, i64 %idxprom11, !dbg !157
  %14 = load i8*, i8** %arrayidx12, align 8, !dbg !157
  %arrayidx13 = getelementptr inbounds i8, i8* %14, i64 1, !dbg !157
  store i8 42, i8* %arrayidx13, align 1, !dbg !160
  store i32 1, i32* @bots_check_flag, align 4, !dbg !161
  br label %sw.epilog, !dbg !162

sw.bb14:                                          ; preds = %if.then
  %15 = load i8**, i8*** %argv.addr, align 8, !dbg !163
  %16 = load i32, i32* %i, align 4, !dbg !164
  %idxprom15 = sext i32 %16 to i64, !dbg !163
  %arrayidx16 = getelementptr inbounds i8*, i8** %15, i64 %idxprom15, !dbg !163
  %17 = load i8*, i8** %arrayidx16, align 8, !dbg !163
  %arrayidx17 = getelementptr inbounds i8, i8* %17, i64 1, !dbg !163
  store i8 42, i8* %arrayidx17, align 1, !dbg !165
  %18 = load i32, i32* %i, align 4, !dbg !166
  %inc = add nsw i32 %18, 1, !dbg !166
  store i32 %inc, i32* %i, align 4, !dbg !166
  %19 = load i32, i32* %argc.addr, align 4, !dbg !167
  %20 = load i32, i32* %i, align 4, !dbg !169
  %cmp18 = icmp eq i32 %19, %20, !dbg !170
  br i1 %cmp18, label %if.then20, label %if.end, !dbg !171

if.then20:                                        ; preds = %sw.bb14
  call void @bots_print_usage(), !dbg !172
  call void @exit(i32 100) #7, !dbg !174
  unreachable, !dbg !174

if.end:                                           ; preds = %sw.bb14
  %21 = load i8**, i8*** %argv.addr, align 8, !dbg !175
  %22 = load i32, i32* %i, align 4, !dbg !176
  %idxprom21 = sext i32 %22 to i64, !dbg !175
  %arrayidx22 = getelementptr inbounds i8*, i8** %21, i64 %idxprom21, !dbg !175
  %23 = load i8*, i8** %arrayidx22, align 8, !dbg !175
  %call23 = call i8* @strcpy(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_exec_message, i32 0, i32 0), i8* %23) #6, !dbg !177
  br label %sw.epilog, !dbg !178

sw.bb24:                                          ; preds = %if.then
  %24 = load i8**, i8*** %argv.addr, align 8, !dbg !179
  %25 = load i32, i32* %i, align 4, !dbg !180
  %idxprom25 = sext i32 %25 to i64, !dbg !179
  %arrayidx26 = getelementptr inbounds i8*, i8** %24, i64 %idxprom25, !dbg !179
  %26 = load i8*, i8** %arrayidx26, align 8, !dbg !179
  %arrayidx27 = getelementptr inbounds i8, i8* %26, i64 1, !dbg !179
  store i8 42, i8* %arrayidx27, align 1, !dbg !181
  call void @bots_print_usage(), !dbg !182
  call void @exit(i32 100) #7, !dbg !183
  unreachable, !dbg !183

sw.bb28:                                          ; preds = %if.then
  %27 = load i8**, i8*** %argv.addr, align 8, !dbg !184
  %28 = load i32, i32* %i, align 4, !dbg !185
  %idxprom29 = sext i32 %28 to i64, !dbg !184
  %arrayidx30 = getelementptr inbounds i8*, i8** %27, i64 %idxprom29, !dbg !184
  %29 = load i8*, i8** %arrayidx30, align 8, !dbg !184
  %arrayidx31 = getelementptr inbounds i8, i8* %29, i64 1, !dbg !184
  store i8 42, i8* %arrayidx31, align 1, !dbg !186
  %30 = load i32, i32* %i, align 4, !dbg !187
  %inc32 = add nsw i32 %30, 1, !dbg !187
  store i32 %inc32, i32* %i, align 4, !dbg !187
  %31 = load i32, i32* %argc.addr, align 4, !dbg !188
  %32 = load i32, i32* %i, align 4, !dbg !190
  %cmp33 = icmp eq i32 %31, %32, !dbg !191
  br i1 %cmp33, label %if.then35, label %if.end36, !dbg !192

if.then35:                                        ; preds = %sw.bb28
  call void @bots_print_usage(), !dbg !193
  call void @exit(i32 100) #7, !dbg !195
  unreachable, !dbg !195

if.end36:                                         ; preds = %sw.bb28
  %33 = load i8**, i8*** %argv.addr, align 8, !dbg !196
  %34 = load i32, i32* %i, align 4, !dbg !197
  %idxprom37 = sext i32 %34 to i64, !dbg !196
  %arrayidx38 = getelementptr inbounds i8*, i8** %33, i64 %idxprom37, !dbg !196
  %35 = load i8*, i8** %arrayidx38, align 8, !dbg !196
  %call39 = call i32 @atoi(i8* %35) #8, !dbg !198
  store i32 %call39, i32* @bots_arg_size, align 4, !dbg !199
  br label %sw.epilog, !dbg !200

sw.bb40:                                          ; preds = %if.then
  %36 = load i8**, i8*** %argv.addr, align 8, !dbg !201
  %37 = load i32, i32* %i, align 4, !dbg !202
  %idxprom41 = sext i32 %37 to i64, !dbg !201
  %arrayidx42 = getelementptr inbounds i8*, i8** %36, i64 %idxprom41, !dbg !201
  %38 = load i8*, i8** %arrayidx42, align 8, !dbg !201
  %arrayidx43 = getelementptr inbounds i8, i8* %38, i64 1, !dbg !201
  store i8 42, i8* %arrayidx43, align 1, !dbg !203
  %39 = load i32, i32* %i, align 4, !dbg !204
  %inc44 = add nsw i32 %39, 1, !dbg !204
  store i32 %inc44, i32* %i, align 4, !dbg !204
  %40 = load i32, i32* %argc.addr, align 4, !dbg !205
  %41 = load i32, i32* %i, align 4, !dbg !207
  %cmp45 = icmp eq i32 %40, %41, !dbg !208
  br i1 %cmp45, label %if.then47, label %if.end48, !dbg !209

if.then47:                                        ; preds = %sw.bb40
  call void @bots_print_usage(), !dbg !210
  call void @exit(i32 100) #7, !dbg !212
  unreachable, !dbg !212

if.end48:                                         ; preds = %sw.bb40
  %42 = load i8**, i8*** %argv.addr, align 8, !dbg !213
  %43 = load i32, i32* %i, align 4, !dbg !214
  %idxprom49 = sext i32 %43 to i64, !dbg !213
  %arrayidx50 = getelementptr inbounds i8*, i8** %42, i64 %idxprom49, !dbg !213
  %44 = load i8*, i8** %arrayidx50, align 8, !dbg !213
  %call51 = call i32 @atoi(i8* %44) #8, !dbg !215
  store i32 %call51, i32* @bots_output_format, align 4, !dbg !216
  br label %sw.epilog, !dbg !217

sw.bb52:                                          ; preds = %if.then
  %45 = load i8**, i8*** %argv.addr, align 8, !dbg !218
  %46 = load i32, i32* %i, align 4, !dbg !219
  %idxprom53 = sext i32 %46 to i64, !dbg !218
  %arrayidx54 = getelementptr inbounds i8*, i8** %45, i64 %idxprom53, !dbg !218
  %47 = load i8*, i8** %arrayidx54, align 8, !dbg !218
  %arrayidx55 = getelementptr inbounds i8, i8* %47, i64 1, !dbg !218
  store i8 42, i8* %arrayidx55, align 1, !dbg !220
  %48 = load i32, i32* %i, align 4, !dbg !221
  %inc56 = add nsw i32 %48, 1, !dbg !221
  store i32 %inc56, i32* %i, align 4, !dbg !221
  %49 = load i32, i32* %argc.addr, align 4, !dbg !222
  %50 = load i32, i32* %i, align 4, !dbg !224
  %cmp57 = icmp eq i32 %49, %50, !dbg !225
  br i1 %cmp57, label %if.then59, label %if.end60, !dbg !226

if.then59:                                        ; preds = %sw.bb52
  call void @bots_print_usage(), !dbg !227
  call void @exit(i32 100) #7, !dbg !229
  unreachable, !dbg !229

if.end60:                                         ; preds = %sw.bb52
  %51 = load i8**, i8*** %argv.addr, align 8, !dbg !230
  %52 = load i32, i32* %i, align 4, !dbg !231
  %idxprom61 = sext i32 %52 to i64, !dbg !230
  %arrayidx62 = getelementptr inbounds i8*, i8** %51, i64 %idxprom61, !dbg !230
  %53 = load i8*, i8** %arrayidx62, align 8, !dbg !230
  %call63 = call i32 @atoi(i8* %53) #8, !dbg !232
  store i32 %call63, i32* @bots_verbose_mode, align 4, !dbg !233
  %54 = load i32, i32* @bots_verbose_mode, align 4, !dbg !234
  %cmp64 = icmp ugt i32 %54, 1, !dbg !236
  br i1 %cmp64, label %if.then66, label %if.end68, !dbg !237

if.then66:                                        ; preds = %if.end60
  %55 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !238
  %call67 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %55, i8* getelementptr inbounds ([100 x i8], [100 x i8]* @.str.19, i32 0, i32 0)), !dbg !240
  call void @exit(i32 100) #7, !dbg !241
  unreachable, !dbg !241

if.end68:                                         ; preds = %if.end60
  br label %sw.epilog, !dbg !242

sw.bb69:                                          ; preds = %if.then
  %56 = load i8**, i8*** %argv.addr, align 8, !dbg !243
  %57 = load i32, i32* %i, align 4, !dbg !244
  %idxprom70 = sext i32 %57 to i64, !dbg !243
  %arrayidx71 = getelementptr inbounds i8*, i8** %56, i64 %idxprom70, !dbg !243
  %58 = load i8*, i8** %arrayidx71, align 8, !dbg !243
  %arrayidx72 = getelementptr inbounds i8, i8* %58, i64 1, !dbg !243
  store i8 42, i8* %arrayidx72, align 1, !dbg !245
  store i32 1, i32* @bots_print_header, align 4, !dbg !246
  br label %sw.epilog, !dbg !247

sw.default:                                       ; preds = %if.then
  %59 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !248
  %call73 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %59, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.20, i32 0, i32 0)), !dbg !249
  call void @bots_print_usage(), !dbg !250
  call void @exit(i32 100) #7, !dbg !251
  unreachable, !dbg !251

sw.epilog:                                        ; preds = %sw.bb69, %if.end68, %if.end48, %if.end36, %if.end, %sw.bb
  br label %if.end75, !dbg !252

if.else:                                          ; preds = %for.body
  %60 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !253
  %call74 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %60, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.20, i32 0, i32 0)), !dbg !255
  call void @bots_print_usage(), !dbg !256
  call void @exit(i32 100) #7, !dbg !257
  unreachable, !dbg !257

if.end75:                                         ; preds = %sw.epilog
  br label %for.inc, !dbg !258

for.inc:                                          ; preds = %if.end75
  %61 = load i32, i32* %i, align 4, !dbg !259
  %inc76 = add nsw i32 %61, 1, !dbg !259
  store i32 %inc76, i32* %i, align 4, !dbg !259
  br label %for.cond, !dbg !260, !llvm.loop !261

for.end:                                          ; preds = %for.cond
  ret void, !dbg !263
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
define dso_local void @bots_get_params(i32 %argc, i8** %argv) #0 !dbg !264 {
entry:
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !265, metadata !DIExpression()), !dbg !266
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !267, metadata !DIExpression()), !dbg !268
  %0 = load i32, i32* %argc.addr, align 4, !dbg !269
  %1 = load i8**, i8*** %argv.addr, align 8, !dbg !270
  call void @bots_get_params_common(i32 %0, i8** %1), !dbg !271
  ret void, !dbg !272
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_set_info() #0 !dbg !273 {
entry:
  %call = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_name, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.21, i32 0, i32 0)) #6, !dbg !274
  %0 = load i32, i32* @bots_arg_size, align 4, !dbg !275
  %call1 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_parameters, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.22, i32 0, i32 0), i32 %0) #6, !dbg !276
  %call2 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_model, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.23, i32 0, i32 0)) #6, !dbg !277
  %call3 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_resources, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.24, i32 0, i32 0), i32 1) #6, !dbg !278
  %call4 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_comp_date, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.18, i32 0, i32 0)) #6, !dbg !279
  %call5 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_comp_message, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.18, i32 0, i32 0)) #6, !dbg !280
  %call6 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_cc, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.18, i32 0, i32 0)) #6, !dbg !281
  %call7 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_cflags, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.18, i32 0, i32 0)) #6, !dbg !282
  %call8 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_ld, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.18, i32 0, i32 0)) #6, !dbg !283
  %call9 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_ldflags, i32 0, i32 0), i64 256, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.18, i32 0, i32 0)) #6, !dbg !284
  %call10 = call i8* @strcpy(i8* getelementptr inbounds ([256 x i8], [256 x i8]* @bots_cutoff, i32 0, i32 0), i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.25, i32 0, i32 0)) #6, !dbg !285
  ret void, !dbg !286
}

; Function Attrs: nounwind
declare dso_local i32 @snprintf(i8*, i64, i8*, ...) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !287 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %bots_t_start = alloca i64, align 8
  %bots_t_end = alloca i64, align 8
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !290, metadata !DIExpression()), !dbg !291
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !292, metadata !DIExpression()), !dbg !293
  call void @llvm.dbg.declare(metadata i64* %bots_t_start, metadata !294, metadata !DIExpression()), !dbg !296
  call void @llvm.dbg.declare(metadata i64* %bots_t_end, metadata !297, metadata !DIExpression()), !dbg !298
  %0 = load i32, i32* %argc.addr, align 4, !dbg !299
  %1 = load i8**, i8*** %argv.addr, align 8, !dbg !300
  call void @bots_get_params(i32 %0, i8** %1), !dbg !301
  call void @bots_set_info(), !dbg !302
  %call = call i64 (...) @bots_usecs(), !dbg !303
  store i64 %call, i64* %bots_t_start, align 8, !dbg !304
  %2 = load i32, i32* @bots_arg_size, align 4, !dbg !305
  call void @fib0(i32 %2), !dbg !305
  %call1 = call i64 (...) @bots_usecs(), !dbg !306
  store i64 %call1, i64* %bots_t_end, align 8, !dbg !307
  %3 = load i64, i64* %bots_t_end, align 8, !dbg !308
  %4 = load i64, i64* %bots_t_start, align 8, !dbg !309
  %sub = sub nsw i64 %3, %4, !dbg !310
  %conv = sitofp i64 %sub to double, !dbg !311
  %div = fdiv double %conv, 1.000000e+06, !dbg !312
  store double %div, double* @bots_time_program, align 8, !dbg !313
  %5 = load i32, i32* @bots_check_flag, align 4, !dbg !314
  %tobool = icmp ne i32 %5, 0, !dbg !314
  br i1 %tobool, label %if.then, label %if.end, !dbg !316

if.then:                                          ; preds = %entry
  store i32 0, i32* @bots_result, align 4, !dbg !317
  br label %if.end, !dbg !319

if.end:                                           ; preds = %if.then, %entry
  call void @bots_print_results(), !dbg !320
  ret i32 0, !dbg !321
}

declare dso_local i64 @bots_usecs(...) #1

declare dso_local void @fib0(i32) #1

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
!llvm.module.flags = !{!68, !69, !70}
!llvm.ident = !{!71}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "bots_sequential_flag", scope: !2, file: !3, line: 41, type: !18, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 8.0.1-9 (tags/RELEASE_801/final)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !12, globals: !15, nameTableKind: None)
!3 = !DIFile(filename: "bots_main.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/fib")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 76, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "./bots.h", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/fib")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11}
!9 = !DIEnumerator(name: "BOTS_VERBOSE_NONE", value: 0, isUnsigned: true)
!10 = !DIEnumerator(name: "BOTS_VERBOSE_DEFAULT", value: 1, isUnsigned: true)
!11 = !DIEnumerator(name: "BOTS_VERBOSE_DEBUG", value: 2, isUnsigned: true)
!12 = !{!13, !14}
!13 = !DIDerivedType(tag: DW_TAG_typedef, name: "bots_verbose_mode_t", file: !6, line: 78, baseType: !5)
!14 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!15 = !{!0, !16, !19, !21, !23, !25, !27, !29, !31, !34, !36, !42, !44, !46, !48, !50, !52, !54, !56, !58, !60, !62, !64, !66}
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
!37 = distinct !DIGlobalVariable(name: "bots_name", scope: !2, file: !3, line: 48, type: !38, isLocal: false, isDefinition: true)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !39, size: 2048, elements: !40)
!39 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!40 = !{!41}
!41 = !DISubrange(count: 256)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(name: "bots_execname", scope: !2, file: !3, line: 49, type: !38, isLocal: false, isDefinition: true)
!44 = !DIGlobalVariableExpression(var: !45, expr: !DIExpression())
!45 = distinct !DIGlobalVariable(name: "bots_parameters", scope: !2, file: !3, line: 50, type: !38, isLocal: false, isDefinition: true)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(name: "bots_model", scope: !2, file: !3, line: 51, type: !38, isLocal: false, isDefinition: true)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "bots_resources", scope: !2, file: !3, line: 52, type: !38, isLocal: false, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "bots_exec_date", scope: !2, file: !3, line: 54, type: !38, isLocal: false, isDefinition: true)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(name: "bots_exec_message", scope: !2, file: !3, line: 55, type: !38, isLocal: false, isDefinition: true)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "bots_comp_date", scope: !2, file: !3, line: 56, type: !38, isLocal: false, isDefinition: true)
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(name: "bots_comp_message", scope: !2, file: !3, line: 57, type: !38, isLocal: false, isDefinition: true)
!58 = !DIGlobalVariableExpression(var: !59, expr: !DIExpression())
!59 = distinct !DIGlobalVariable(name: "bots_cc", scope: !2, file: !3, line: 58, type: !38, isLocal: false, isDefinition: true)
!60 = !DIGlobalVariableExpression(var: !61, expr: !DIExpression())
!61 = distinct !DIGlobalVariable(name: "bots_cflags", scope: !2, file: !3, line: 59, type: !38, isLocal: false, isDefinition: true)
!62 = !DIGlobalVariableExpression(var: !63, expr: !DIExpression())
!63 = distinct !DIGlobalVariable(name: "bots_ld", scope: !2, file: !3, line: 60, type: !38, isLocal: false, isDefinition: true)
!64 = !DIGlobalVariableExpression(var: !65, expr: !DIExpression())
!65 = distinct !DIGlobalVariable(name: "bots_ldflags", scope: !2, file: !3, line: 61, type: !38, isLocal: false, isDefinition: true)
!66 = !DIGlobalVariableExpression(var: !67, expr: !DIExpression())
!67 = distinct !DIGlobalVariable(name: "bots_cutoff", scope: !2, file: !3, line: 62, type: !38, isLocal: false, isDefinition: true)
!68 = !{i32 2, !"Dwarf Version", i32 4}
!69 = !{i32 2, !"Debug Info Version", i32 3}
!70 = !{i32 1, !"wchar_size", i32 4}
!71 = !{!"clang version 8.0.1-9 (tags/RELEASE_801/final)"}
!72 = distinct !DISubprogram(name: "bots_print_usage", scope: !3, file: !3, line: 211, type: !73, scopeLine: 212, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !75)
!73 = !DISubroutineType(types: !74)
!74 = !{null}
!75 = !{}
!76 = !DILocation(line: 213, column: 12, scope: !72)
!77 = !DILocation(line: 213, column: 4, scope: !72)
!78 = !DILocation(line: 214, column: 12, scope: !72)
!79 = !DILocation(line: 214, column: 4, scope: !72)
!80 = !DILocation(line: 215, column: 12, scope: !72)
!81 = !DILocation(line: 215, column: 4, scope: !72)
!82 = !DILocation(line: 216, column: 12, scope: !72)
!83 = !DILocation(line: 216, column: 4, scope: !72)
!84 = !DILocation(line: 221, column: 12, scope: !72)
!85 = !DILocation(line: 221, column: 4, scope: !72)
!86 = !DILocation(line: 245, column: 12, scope: !72)
!87 = !DILocation(line: 245, column: 4, scope: !72)
!88 = !DILocation(line: 246, column: 12, scope: !72)
!89 = !DILocation(line: 246, column: 4, scope: !72)
!90 = !DILocation(line: 247, column: 12, scope: !72)
!91 = !DILocation(line: 247, column: 4, scope: !72)
!92 = !DILocation(line: 248, column: 12, scope: !72)
!93 = !DILocation(line: 248, column: 4, scope: !72)
!94 = !DILocation(line: 249, column: 12, scope: !72)
!95 = !DILocation(line: 249, column: 4, scope: !72)
!96 = !DILocation(line: 250, column: 12, scope: !72)
!97 = !DILocation(line: 250, column: 4, scope: !72)
!98 = !DILocation(line: 251, column: 12, scope: !72)
!99 = !DILocation(line: 251, column: 4, scope: !72)
!100 = !DILocation(line: 252, column: 12, scope: !72)
!101 = !DILocation(line: 252, column: 4, scope: !72)
!102 = !DILocation(line: 253, column: 12, scope: !72)
!103 = !DILocation(line: 253, column: 4, scope: !72)
!104 = !DILocation(line: 254, column: 12, scope: !72)
!105 = !DILocation(line: 254, column: 4, scope: !72)
!106 = !DILocation(line: 255, column: 12, scope: !72)
!107 = !DILocation(line: 255, column: 4, scope: !72)
!108 = !DILocation(line: 256, column: 12, scope: !72)
!109 = !DILocation(line: 256, column: 4, scope: !72)
!110 = !DILocation(line: 257, column: 12, scope: !72)
!111 = !DILocation(line: 257, column: 4, scope: !72)
!112 = !DILocation(line: 258, column: 12, scope: !72)
!113 = !DILocation(line: 258, column: 4, scope: !72)
!114 = !DILocation(line: 265, column: 12, scope: !72)
!115 = !DILocation(line: 265, column: 4, scope: !72)
!116 = !DILocation(line: 267, column: 12, scope: !72)
!117 = !DILocation(line: 267, column: 4, scope: !72)
!118 = !DILocation(line: 268, column: 12, scope: !72)
!119 = !DILocation(line: 268, column: 4, scope: !72)
!120 = !DILocation(line: 269, column: 12, scope: !72)
!121 = !DILocation(line: 269, column: 4, scope: !72)
!122 = !DILocation(line: 270, column: 1, scope: !72)
!123 = distinct !DISubprogram(name: "bots_get_params_common", scope: !3, file: !3, line: 275, type: !124, scopeLine: 276, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !75)
!124 = !DISubroutineType(types: !125)
!125 = !{null, !18, !126}
!126 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !127, size: 64)
!127 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !39, size: 64)
!128 = !DILocalVariable(name: "argc", arg: 1, scope: !123, file: !3, line: 275, type: !18)
!129 = !DILocation(line: 275, column: 28, scope: !123)
!130 = !DILocalVariable(name: "argv", arg: 2, scope: !123, file: !3, line: 275, type: !126)
!131 = !DILocation(line: 275, column: 41, scope: !123)
!132 = !DILocalVariable(name: "i", scope: !123, file: !3, line: 277, type: !18)
!133 = !DILocation(line: 277, column: 8, scope: !123)
!134 = !DILocation(line: 278, column: 35, scope: !123)
!135 = !DILocation(line: 278, column: 26, scope: !123)
!136 = !DILocation(line: 278, column: 4, scope: !123)
!137 = !DILocation(line: 279, column: 4, scope: !123)
!138 = !DILocation(line: 280, column: 4, scope: !123)
!139 = !DILocation(line: 281, column: 10, scope: !140)
!140 = distinct !DILexicalBlock(scope: !123, file: !3, line: 281, column: 4)
!141 = !DILocation(line: 281, column: 9, scope: !140)
!142 = !DILocation(line: 281, column: 14, scope: !143)
!143 = distinct !DILexicalBlock(scope: !140, file: !3, line: 281, column: 4)
!144 = !DILocation(line: 281, column: 16, scope: !143)
!145 = !DILocation(line: 281, column: 15, scope: !143)
!146 = !DILocation(line: 281, column: 4, scope: !140)
!147 = !DILocation(line: 283, column: 11, scope: !148)
!148 = distinct !DILexicalBlock(scope: !149, file: !3, line: 283, column: 11)
!149 = distinct !DILexicalBlock(scope: !143, file: !3, line: 282, column: 4)
!150 = !DILocation(line: 283, column: 16, scope: !148)
!151 = !DILocation(line: 283, column: 22, scope: !148)
!152 = !DILocation(line: 283, column: 11, scope: !149)
!153 = !DILocation(line: 285, column: 18, scope: !154)
!154 = distinct !DILexicalBlock(scope: !148, file: !3, line: 284, column: 7)
!155 = !DILocation(line: 285, column: 23, scope: !154)
!156 = !DILocation(line: 285, column: 10, scope: !154)
!157 = !DILocation(line: 304, column: 16, scope: !158)
!158 = distinct !DILexicalBlock(scope: !154, file: !3, line: 286, column: 10)
!159 = !DILocation(line: 304, column: 21, scope: !158)
!160 = !DILocation(line: 304, column: 27, scope: !158)
!161 = !DILocation(line: 308, column: 32, scope: !158)
!162 = !DILocation(line: 309, column: 16, scope: !158)
!163 = !DILocation(line: 311, column: 16, scope: !158)
!164 = !DILocation(line: 311, column: 21, scope: !158)
!165 = !DILocation(line: 311, column: 27, scope: !158)
!166 = !DILocation(line: 312, column: 17, scope: !158)
!167 = !DILocation(line: 313, column: 20, scope: !168)
!168 = distinct !DILexicalBlock(scope: !158, file: !3, line: 313, column: 20)
!169 = !DILocation(line: 313, column: 28, scope: !168)
!170 = !DILocation(line: 313, column: 25, scope: !168)
!171 = !DILocation(line: 313, column: 20, scope: !158)
!172 = !DILocation(line: 313, column: 33, scope: !173)
!173 = distinct !DILexicalBlock(scope: !168, file: !3, line: 313, column: 31)
!174 = !DILocation(line: 313, column: 53, scope: !173)
!175 = !DILocation(line: 314, column: 42, scope: !158)
!176 = !DILocation(line: 314, column: 47, scope: !158)
!177 = !DILocation(line: 314, column: 16, scope: !158)
!178 = !DILocation(line: 315, column: 16, scope: !158)
!179 = !DILocation(line: 325, column: 16, scope: !158)
!180 = !DILocation(line: 325, column: 21, scope: !158)
!181 = !DILocation(line: 325, column: 27, scope: !158)
!182 = !DILocation(line: 326, column: 16, scope: !158)
!183 = !DILocation(line: 327, column: 16, scope: !158)
!184 = !DILocation(line: 346, column: 16, scope: !158)
!185 = !DILocation(line: 346, column: 21, scope: !158)
!186 = !DILocation(line: 346, column: 27, scope: !158)
!187 = !DILocation(line: 347, column: 17, scope: !158)
!188 = !DILocation(line: 348, column: 20, scope: !189)
!189 = distinct !DILexicalBlock(scope: !158, file: !3, line: 348, column: 20)
!190 = !DILocation(line: 348, column: 28, scope: !189)
!191 = !DILocation(line: 348, column: 25, scope: !189)
!192 = !DILocation(line: 348, column: 20, scope: !158)
!193 = !DILocation(line: 348, column: 33, scope: !194)
!194 = distinct !DILexicalBlock(scope: !189, file: !3, line: 348, column: 31)
!195 = !DILocation(line: 348, column: 53, scope: !194)
!196 = !DILocation(line: 349, column: 37, scope: !158)
!197 = !DILocation(line: 349, column: 42, scope: !158)
!198 = !DILocation(line: 349, column: 32, scope: !158)
!199 = !DILocation(line: 349, column: 30, scope: !158)
!200 = !DILocation(line: 350, column: 16, scope: !158)
!201 = !DILocation(line: 356, column: 16, scope: !158)
!202 = !DILocation(line: 356, column: 21, scope: !158)
!203 = !DILocation(line: 356, column: 27, scope: !158)
!204 = !DILocation(line: 357, column: 17, scope: !158)
!205 = !DILocation(line: 358, column: 20, scope: !206)
!206 = distinct !DILexicalBlock(scope: !158, file: !3, line: 358, column: 20)
!207 = !DILocation(line: 358, column: 28, scope: !206)
!208 = !DILocation(line: 358, column: 25, scope: !206)
!209 = !DILocation(line: 358, column: 20, scope: !158)
!210 = !DILocation(line: 358, column: 33, scope: !211)
!211 = distinct !DILexicalBlock(scope: !206, file: !3, line: 358, column: 31)
!212 = !DILocation(line: 358, column: 53, scope: !211)
!213 = !DILocation(line: 359, column: 42, scope: !158)
!214 = !DILocation(line: 359, column: 47, scope: !158)
!215 = !DILocation(line: 359, column: 37, scope: !158)
!216 = !DILocation(line: 359, column: 35, scope: !158)
!217 = !DILocation(line: 360, column: 16, scope: !158)
!218 = !DILocation(line: 379, column: 16, scope: !158)
!219 = !DILocation(line: 379, column: 21, scope: !158)
!220 = !DILocation(line: 379, column: 27, scope: !158)
!221 = !DILocation(line: 380, column: 17, scope: !158)
!222 = !DILocation(line: 381, column: 20, scope: !223)
!223 = distinct !DILexicalBlock(scope: !158, file: !3, line: 381, column: 20)
!224 = !DILocation(line: 381, column: 28, scope: !223)
!225 = !DILocation(line: 381, column: 25, scope: !223)
!226 = !DILocation(line: 381, column: 20, scope: !158)
!227 = !DILocation(line: 381, column: 33, scope: !228)
!228 = distinct !DILexicalBlock(scope: !223, file: !3, line: 381, column: 31)
!229 = !DILocation(line: 381, column: 53, scope: !228)
!230 = !DILocation(line: 382, column: 63, scope: !158)
!231 = !DILocation(line: 382, column: 68, scope: !158)
!232 = !DILocation(line: 382, column: 58, scope: !158)
!233 = !DILocation(line: 382, column: 34, scope: !158)
!234 = !DILocation(line: 384, column: 21, scope: !235)
!235 = distinct !DILexicalBlock(scope: !158, file: !3, line: 384, column: 21)
!236 = !DILocation(line: 384, column: 39, scope: !235)
!237 = !DILocation(line: 384, column: 21, scope: !158)
!238 = !DILocation(line: 385, column: 27, scope: !239)
!239 = distinct !DILexicalBlock(scope: !235, file: !3, line: 384, column: 45)
!240 = !DILocation(line: 385, column: 19, scope: !239)
!241 = !DILocation(line: 386, column: 19, scope: !239)
!242 = !DILocation(line: 389, column: 16, scope: !158)
!243 = !DILocation(line: 407, column: 9, scope: !158)
!244 = !DILocation(line: 407, column: 14, scope: !158)
!245 = !DILocation(line: 407, column: 20, scope: !158)
!246 = !DILocation(line: 408, column: 34, scope: !158)
!247 = !DILocation(line: 409, column: 16, scope: !158)
!248 = !DILocation(line: 415, column: 24, scope: !158)
!249 = !DILocation(line: 415, column: 16, scope: !158)
!250 = !DILocation(line: 416, column: 16, scope: !158)
!251 = !DILocation(line: 417, column: 16, scope: !158)
!252 = !DILocation(line: 419, column: 7, scope: !154)
!253 = !DILocation(line: 426, column: 18, scope: !254)
!254 = distinct !DILexicalBlock(scope: !148, file: !3, line: 421, column: 7)
!255 = !DILocation(line: 426, column: 10, scope: !254)
!256 = !DILocation(line: 427, column: 10, scope: !254)
!257 = !DILocation(line: 428, column: 10, scope: !254)
!258 = !DILocation(line: 430, column: 4, scope: !149)
!259 = !DILocation(line: 281, column: 23, scope: !143)
!260 = !DILocation(line: 281, column: 4, scope: !143)
!261 = distinct !{!261, !146, !262}
!262 = !DILocation(line: 430, column: 4, scope: !140)
!263 = !DILocation(line: 431, column: 1, scope: !123)
!264 = distinct !DISubprogram(name: "bots_get_params", scope: !3, file: !3, line: 436, type: !124, scopeLine: 437, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !75)
!265 = !DILocalVariable(name: "argc", arg: 1, scope: !264, file: !3, line: 436, type: !18)
!266 = !DILocation(line: 436, column: 21, scope: !264)
!267 = !DILocalVariable(name: "argv", arg: 2, scope: !264, file: !3, line: 436, type: !126)
!268 = !DILocation(line: 436, column: 34, scope: !264)
!269 = !DILocation(line: 438, column: 27, scope: !264)
!270 = !DILocation(line: 438, column: 33, scope: !264)
!271 = !DILocation(line: 438, column: 4, scope: !264)
!272 = !DILocation(line: 440, column: 1, scope: !264)
!273 = distinct !DISubprogram(name: "bots_set_info", scope: !3, file: !3, line: 446, type: !73, scopeLine: 447, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !75)
!274 = !DILocation(line: 449, column: 4, scope: !273)
!275 = !DILocation(line: 450, column: 72, scope: !273)
!276 = !DILocation(line: 450, column: 4, scope: !273)
!277 = !DILocation(line: 451, column: 4, scope: !273)
!278 = !DILocation(line: 452, column: 4, scope: !273)
!279 = !DILocation(line: 455, column: 4, scope: !273)
!280 = !DILocation(line: 456, column: 4, scope: !273)
!281 = !DILocation(line: 457, column: 4, scope: !273)
!282 = !DILocation(line: 458, column: 4, scope: !273)
!283 = !DILocation(line: 459, column: 4, scope: !273)
!284 = !DILocation(line: 460, column: 4, scope: !273)
!285 = !DILocation(line: 469, column: 4, scope: !273)
!286 = !DILocation(line: 471, column: 1, scope: !273)
!287 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 477, type: !288, scopeLine: 478, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !75)
!288 = !DISubroutineType(types: !289)
!289 = !{!18, !18, !126}
!290 = !DILocalVariable(name: "argc", arg: 1, scope: !287, file: !3, line: 477, type: !18)
!291 = !DILocation(line: 477, column: 10, scope: !287)
!292 = !DILocalVariable(name: "argv", arg: 2, scope: !287, file: !3, line: 477, type: !126)
!293 = !DILocation(line: 477, column: 22, scope: !287)
!294 = !DILocalVariable(name: "bots_t_start", scope: !287, file: !3, line: 480, type: !295)
!295 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!296 = !DILocation(line: 480, column: 9, scope: !287)
!297 = !DILocalVariable(name: "bots_t_end", scope: !287, file: !3, line: 481, type: !295)
!298 = !DILocation(line: 481, column: 9, scope: !287)
!299 = !DILocation(line: 484, column: 20, scope: !287)
!300 = !DILocation(line: 484, column: 25, scope: !287)
!301 = !DILocation(line: 484, column: 4, scope: !287)
!302 = !DILocation(line: 486, column: 4, scope: !287)
!303 = !DILocation(line: 513, column: 19, scope: !287)
!304 = !DILocation(line: 513, column: 17, scope: !287)
!305 = !DILocation(line: 514, column: 4, scope: !287)
!306 = !DILocation(line: 515, column: 17, scope: !287)
!307 = !DILocation(line: 515, column: 15, scope: !287)
!308 = !DILocation(line: 516, column: 34, scope: !287)
!309 = !DILocation(line: 516, column: 45, scope: !287)
!310 = !DILocation(line: 516, column: 44, scope: !287)
!311 = !DILocation(line: 516, column: 25, scope: !287)
!312 = !DILocation(line: 516, column: 59, scope: !287)
!313 = !DILocation(line: 516, column: 22, scope: !287)
!314 = !DILocation(line: 521, column: 8, scope: !315)
!315 = distinct !DILexicalBlock(scope: !287, file: !3, line: 521, column: 8)
!316 = !DILocation(line: 521, column: 8, scope: !287)
!317 = !DILocation(line: 522, column: 18, scope: !318)
!318 = distinct !DILexicalBlock(scope: !315, file: !3, line: 521, column: 25)
!319 = !DILocation(line: 523, column: 4, scope: !318)
!320 = !DILocation(line: 528, column: 4, scope: !287)
!321 = !DILocation(line: 529, column: 4, scope: !287)
