; ModuleID = 'bots_common.c'
source_filename = "bots_common.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, %struct._IO_codecvt*, %struct._IO_wide_data*, %struct._IO_FILE*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type opaque
%struct._IO_codecvt = type opaque
%struct._IO_wide_data = type opaque
%struct.timeval = type { i64, i64 }
%struct.tm = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i64, i8* }
%struct.utsname = type { [65 x i8], [65 x i8], [65 x i8], [65 x i8], [65 x i8], [65 x i8] }

@stderr = external dso_local global %struct._IO_FILE*, align 8
@.str = private unnamed_addr constant [16 x i8] c"Error (%d): %s\0A\00", align 1
@.str.1 = private unnamed_addr constant [19 x i8] c"Unspecified error.\00", align 1
@.str.2 = private unnamed_addr constant [19 x i8] c"Not enough memory.\00", align 1
@.str.3 = private unnamed_addr constant [24 x i8] c"Unrecognized parameter.\00", align 1
@.str.4 = private unnamed_addr constant [20 x i8] c"Invalid error code.\00", align 1
@.str.5 = private unnamed_addr constant [18 x i8] c"Warning (%d): %s\0A\00", align 1
@.str.6 = private unnamed_addr constant [21 x i8] c"Unspecified warning.\00", align 1
@.str.7 = private unnamed_addr constant [22 x i8] c"Invalid warning code.\00", align 1
@.str.8 = private unnamed_addr constant [15 x i8] c"%Y/%m/%d;%H:%M\00", align 1
@.str.9 = private unnamed_addr constant [9 x i8] c"%s-%s;%d\00", align 1
@.str.10 = private unnamed_addr constant [15 x i8] c"%.2f;%.2f;%.2f\00", align 1
@.str.11 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@bots_name = external dso_local global [0 x i8], align 1
@bots_parameters = external dso_local global [0 x i8], align 1
@bots_model = external dso_local global [0 x i8], align 1
@bots_cutoff = external dso_local global [0 x i8], align 1
@bots_resources = external dso_local global [0 x i8], align 1
@bots_result = external dso_local global i32, align 4
@.str.12 = private unnamed_addr constant [4 x i8] c"n/a\00", align 1
@.str.13 = private unnamed_addr constant [11 x i8] c"successful\00", align 1
@.str.14 = private unnamed_addr constant [13 x i8] c"UNSUCCESSFUL\00", align 1
@.str.15 = private unnamed_addr constant [14 x i8] c"Not requested\00", align 1
@.str.16 = private unnamed_addr constant [6 x i8] c"error\00", align 1
@.str.17 = private unnamed_addr constant [3 x i8] c"%f\00", align 1
@bots_time_program = external dso_local global double, align 8
@bots_sequential_flag = external dso_local global i32, align 4
@bots_time_sequential = external dso_local global double, align 8
@.str.18 = private unnamed_addr constant [6 x i8] c"%3.2f\00", align 1
@bots_number_of_tasks = external dso_local global i64, align 8
@bots_exec_date = external dso_local global [0 x i8], align 1
@bots_exec_message = external dso_local global [0 x i8], align 1
@bots_comp_date = external dso_local global [0 x i8], align 1
@bots_comp_message = external dso_local global [0 x i8], align 1
@bots_cc = external dso_local global [0 x i8], align 1
@bots_cflags = external dso_local global [0 x i8], align 1
@bots_ld = external dso_local global [0 x i8], align 1
@bots_ldflags = external dso_local global [0 x i8], align 1
@bots_print_header = external dso_local global i32, align 4
@bots_output_format = external dso_local global i32, align 4
@stdout = external dso_local global %struct._IO_FILE*, align 8
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

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_error(i32 %error, i8* %message) #0 !dbg !229 {
entry:
  %error.addr = alloca i32, align 4
  %message.addr = alloca i8*, align 8
  store i32 %error, i32* %error.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %error.addr, metadata !236, metadata !DIExpression()), !dbg !237
  store i8* %message, i8** %message.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %message.addr, metadata !238, metadata !DIExpression()), !dbg !239
  %0 = load i8*, i8** %message.addr, align 8, !dbg !240
  %cmp = icmp eq i8* %0, null, !dbg !242
  br i1 %cmp, label %if.then, label %if.else, !dbg !243

if.then:                                          ; preds = %entry
  %1 = load i32, i32* %error.addr, align 4, !dbg !244
  switch i32 %1, label %sw.default [
    i32 0, label %sw.bb
    i32 1, label %sw.bb1
    i32 2, label %sw.bb3
  ], !dbg !246

sw.bb:                                            ; preds = %if.then
  %2 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !247
  %3 = load i32, i32* %error.addr, align 4, !dbg !249
  %call = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %2, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i32 0, i32 0), i32 %3, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.1, i32 0, i32 0)), !dbg !250
  br label %sw.epilog, !dbg !251

sw.bb1:                                           ; preds = %if.then
  %4 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !252
  %5 = load i32, i32* %error.addr, align 4, !dbg !253
  %call2 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %4, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i32 0, i32 0), i32 %5, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.2, i32 0, i32 0)), !dbg !254
  br label %sw.epilog, !dbg !255

sw.bb3:                                           ; preds = %if.then
  %6 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !256
  %7 = load i32, i32* %error.addr, align 4, !dbg !257
  %call4 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %6, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i32 0, i32 0), i32 %7, i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.3, i32 0, i32 0)), !dbg !258
  call void @bots_print_usage(), !dbg !259
  br label %sw.epilog, !dbg !260

sw.default:                                       ; preds = %if.then
  %8 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !261
  %9 = load i32, i32* %error.addr, align 4, !dbg !262
  %call5 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %8, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i32 0, i32 0), i32 %9, i8* getelementptr inbounds ([20 x i8], [20 x i8]* @.str.4, i32 0, i32 0)), !dbg !263
  br label %sw.epilog, !dbg !264

sw.epilog:                                        ; preds = %sw.default, %sw.bb3, %sw.bb1, %sw.bb
  br label %if.end, !dbg !265

if.else:                                          ; preds = %entry
  %10 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !266
  %11 = load i32, i32* %error.addr, align 4, !dbg !267
  %12 = load i8*, i8** %message.addr, align 8, !dbg !268
  %call6 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %10, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i32 0, i32 0), i32 %11, i8* %12), !dbg !269
  br label %if.end

if.end:                                           ; preds = %if.else, %sw.epilog
  %13 = load i32, i32* %error.addr, align 4, !dbg !270
  %add = add nsw i32 100, %13, !dbg !271
  call void @exit(i32 %add) #5, !dbg !272
  unreachable, !dbg !272

return:                                           ; No predecessors!
  ret void, !dbg !273
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @fprintf(%struct._IO_FILE*, i8*, ...) #2

declare dso_local void @bots_print_usage() #2

; Function Attrs: noreturn nounwind
declare dso_local void @exit(i32) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_warning(i32 %warning, i8* %message) #0 !dbg !274 {
entry:
  %warning.addr = alloca i32, align 4
  %message.addr = alloca i8*, align 8
  store i32 %warning, i32* %warning.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %warning.addr, metadata !275, metadata !DIExpression()), !dbg !276
  store i8* %message, i8** %message.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %message.addr, metadata !277, metadata !DIExpression()), !dbg !278
  %0 = load i8*, i8** %message.addr, align 8, !dbg !279
  %cmp = icmp eq i8* %0, null, !dbg !281
  br i1 %cmp, label %if.then, label %if.else, !dbg !282

if.then:                                          ; preds = %entry
  %1 = load i32, i32* %warning.addr, align 4, !dbg !283
  switch i32 %1, label %sw.default [
    i32 0, label %sw.bb
  ], !dbg !285

sw.bb:                                            ; preds = %if.then
  %2 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !286
  %3 = load i32, i32* %warning.addr, align 4, !dbg !288
  %call = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %2, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.5, i32 0, i32 0), i32 %3, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.6, i32 0, i32 0)), !dbg !289
  br label %sw.epilog, !dbg !290

sw.default:                                       ; preds = %if.then
  %4 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !291
  %5 = load i32, i32* %warning.addr, align 4, !dbg !292
  %call1 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %4, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.5, i32 0, i32 0), i32 %5, i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.7, i32 0, i32 0)), !dbg !293
  br label %sw.epilog, !dbg !294

sw.epilog:                                        ; preds = %sw.default, %sw.bb
  br label %if.end, !dbg !295

if.else:                                          ; preds = %entry
  %6 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !296
  %7 = load i32, i32* %warning.addr, align 4, !dbg !297
  %8 = load i8*, i8** %message.addr, align 8, !dbg !298
  %call2 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %6, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.5, i32 0, i32 0), i32 %7, i8* %8), !dbg !299
  br label %if.end

if.end:                                           ; preds = %if.else, %sw.epilog
  ret void, !dbg !300
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i64 @bots_usecs() #0 !dbg !301 {
entry:
  %t = alloca %struct.timeval, align 8
  call void @llvm.dbg.declare(metadata %struct.timeval* %t, metadata !305, metadata !DIExpression()), !dbg !314
  %call = call i32 @gettimeofday(%struct.timeval* %t, i8* null) #6, !dbg !315
  %tv_sec = getelementptr inbounds %struct.timeval, %struct.timeval* %t, i32 0, i32 0, !dbg !316
  %0 = load i64, i64* %tv_sec, align 8, !dbg !316
  %mul = mul nsw i64 %0, 1000000, !dbg !317
  %tv_usec = getelementptr inbounds %struct.timeval, %struct.timeval* %t, i32 0, i32 1, !dbg !318
  %1 = load i64, i64* %tv_usec, align 8, !dbg !318
  %add = add nsw i64 %mul, %1, !dbg !319
  ret i64 %add, !dbg !320
}

; Function Attrs: nounwind
declare dso_local i32 @gettimeofday(%struct.timeval*, i8*) #4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_get_date(i8* %str) #0 !dbg !321 {
entry:
  %str.addr = alloca i8*, align 8
  %now = alloca i64, align 8
  store i8* %str, i8** %str.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %str.addr, metadata !324, metadata !DIExpression()), !dbg !325
  call void @llvm.dbg.declare(metadata i64* %now, metadata !326, metadata !DIExpression()), !dbg !329
  %call = call i64 @time(i64* %now) #6, !dbg !330
  %0 = load i8*, i8** %str.addr, align 8, !dbg !331
  %call1 = call %struct.tm* @gmtime(i64* %now) #6, !dbg !332
  %call2 = call i64 @strftime(i8* %0, i64 32, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.8, i32 0, i32 0), %struct.tm* %call1) #6, !dbg !333
  ret void, !dbg !334
}

; Function Attrs: nounwind
declare dso_local i64 @time(i64*) #4

; Function Attrs: nounwind
declare dso_local i64 @strftime(i8*, i64, i8*, %struct.tm*) #4

; Function Attrs: nounwind
declare dso_local %struct.tm* @gmtime(i64*) #4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_get_architecture(i8* %str) #0 !dbg !335 {
entry:
  %str.addr = alloca i8*, align 8
  %ncpus = alloca i32, align 4
  %architecture = alloca %struct.utsname, align 1
  store i8* %str, i8** %str.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %str.addr, metadata !336, metadata !DIExpression()), !dbg !337
  call void @llvm.dbg.declare(metadata i32* %ncpus, metadata !338, metadata !DIExpression()), !dbg !339
  %call = call i64 @sysconf(i32 83) #6, !dbg !340
  %conv = trunc i64 %call to i32, !dbg !340
  store i32 %conv, i32* %ncpus, align 4, !dbg !339
  call void @llvm.dbg.declare(metadata %struct.utsname* %architecture, metadata !341, metadata !DIExpression()), !dbg !354
  %call1 = call i32 @uname(%struct.utsname* %architecture) #6, !dbg !355
  %0 = load i8*, i8** %str.addr, align 8, !dbg !356
  %sysname = getelementptr inbounds %struct.utsname, %struct.utsname* %architecture, i32 0, i32 0, !dbg !357
  %arraydecay = getelementptr inbounds [65 x i8], [65 x i8]* %sysname, i32 0, i32 0, !dbg !358
  %machine = getelementptr inbounds %struct.utsname, %struct.utsname* %architecture, i32 0, i32 4, !dbg !359
  %arraydecay2 = getelementptr inbounds [65 x i8], [65 x i8]* %machine, i32 0, i32 0, !dbg !360
  %1 = load i32, i32* %ncpus, align 4, !dbg !361
  %call3 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* %0, i64 256, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.9, i32 0, i32 0), i8* %arraydecay, i8* %arraydecay2, i32 %1) #6, !dbg !362
  ret void, !dbg !363
}

; Function Attrs: nounwind
declare dso_local i64 @sysconf(i32) #4

; Function Attrs: nounwind
declare dso_local i32 @uname(%struct.utsname*) #4

; Function Attrs: nounwind
declare dso_local i32 @snprintf(i8*, i64, i8*, ...) #4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_get_load_average(i8* %str) #0 !dbg !364 {
entry:
  %str.addr = alloca i8*, align 8
  %loadavg = alloca [3 x double], align 16
  store i8* %str, i8** %str.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %str.addr, metadata !365, metadata !DIExpression()), !dbg !366
  call void @llvm.dbg.declare(metadata [3 x double]* %loadavg, metadata !367, metadata !DIExpression()), !dbg !372
  %arraydecay = getelementptr inbounds [3 x double], [3 x double]* %loadavg, i32 0, i32 0, !dbg !373
  %call = call i32 @getloadavg(double* %arraydecay, i32 3) #6, !dbg !374
  %0 = load i8*, i8** %str.addr, align 8, !dbg !375
  %arrayidx = getelementptr inbounds [3 x double], [3 x double]* %loadavg, i64 0, i64 0, !dbg !376
  %1 = load double, double* %arrayidx, align 16, !dbg !376
  %arrayidx1 = getelementptr inbounds [3 x double], [3 x double]* %loadavg, i64 0, i64 1, !dbg !377
  %2 = load double, double* %arrayidx1, align 8, !dbg !377
  %arrayidx2 = getelementptr inbounds [3 x double], [3 x double]* %loadavg, i64 0, i64 2, !dbg !378
  %3 = load double, double* %arrayidx2, align 16, !dbg !378
  %call3 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* %0, i64 256, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.10, i32 0, i32 0), double %1, double %2, double %3) #6, !dbg !379
  ret void, !dbg !380
}

; Function Attrs: nounwind
declare dso_local i32 @getloadavg(double*, i32) #4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bots_print_results() #0 !dbg !381 {
entry:
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
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_name, metadata !384, metadata !DIExpression()), !dbg !388
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_parameters, metadata !389, metadata !DIExpression()), !dbg !390
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_model, metadata !391, metadata !DIExpression()), !dbg !392
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_resources, metadata !393, metadata !DIExpression()), !dbg !394
  call void @llvm.dbg.declare(metadata [15 x i8]* %str_result, metadata !395, metadata !DIExpression()), !dbg !399
  call void @llvm.dbg.declare(metadata [15 x i8]* %str_time_program, metadata !400, metadata !DIExpression()), !dbg !401
  call void @llvm.dbg.declare(metadata [15 x i8]* %str_time_sequential, metadata !402, metadata !DIExpression()), !dbg !403
  call void @llvm.dbg.declare(metadata [15 x i8]* %str_speed_up, metadata !404, metadata !DIExpression()), !dbg !405
  call void @llvm.dbg.declare(metadata [15 x i8]* %str_number_of_tasks, metadata !406, metadata !DIExpression()), !dbg !407
  call void @llvm.dbg.declare(metadata [15 x i8]* %str_number_of_tasks_per_second, metadata !408, metadata !DIExpression()), !dbg !409
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_exec_date, metadata !410, metadata !DIExpression()), !dbg !411
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_exec_message, metadata !412, metadata !DIExpression()), !dbg !413
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_architecture, metadata !414, metadata !DIExpression()), !dbg !415
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_load_avg, metadata !416, metadata !DIExpression()), !dbg !417
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_comp_date, metadata !418, metadata !DIExpression()), !dbg !419
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_comp_message, metadata !420, metadata !DIExpression()), !dbg !421
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_cc, metadata !422, metadata !DIExpression()), !dbg !423
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_cflags, metadata !424, metadata !DIExpression()), !dbg !425
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_ld, metadata !426, metadata !DIExpression()), !dbg !427
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_ldflags, metadata !428, metadata !DIExpression()), !dbg !429
  call void @llvm.dbg.declare(metadata [256 x i8]* %str_cutoff, metadata !430, metadata !DIExpression()), !dbg !431
  %arraydecay = getelementptr inbounds [256 x i8], [256 x i8]* %str_name, i32 0, i32 0, !dbg !432
  %call = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([0 x i8], [0 x i8]* @bots_name, i32 0, i32 0)) #6, !dbg !433
  %arraydecay1 = getelementptr inbounds [256 x i8], [256 x i8]* %str_parameters, i32 0, i32 0, !dbg !434
  %call2 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay1, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([0 x i8], [0 x i8]* @bots_parameters, i32 0, i32 0)) #6, !dbg !435
  %arraydecay3 = getelementptr inbounds [256 x i8], [256 x i8]* %str_model, i32 0, i32 0, !dbg !436
  %call4 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay3, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([0 x i8], [0 x i8]* @bots_model, i32 0, i32 0)) #6, !dbg !437
  %arraydecay5 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cutoff, i32 0, i32 0, !dbg !438
  %call6 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay5, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([0 x i8], [0 x i8]* @bots_cutoff, i32 0, i32 0)) #6, !dbg !439
  %arraydecay7 = getelementptr inbounds [256 x i8], [256 x i8]* %str_resources, i32 0, i32 0, !dbg !440
  %call8 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay7, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([0 x i8], [0 x i8]* @bots_resources, i32 0, i32 0)) #6, !dbg !441
  %0 = load i32, i32* @bots_result, align 4, !dbg !442
  switch i32 %0, label %sw.default [
    i32 0, label %sw.bb
    i32 1, label %sw.bb11
    i32 2, label %sw.bb14
    i32 3, label %sw.bb17
  ], !dbg !443

sw.bb:                                            ; preds = %entry
  %arraydecay9 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !444
  %call10 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay9, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.12, i32 0, i32 0)) #6, !dbg !446
  br label %sw.epilog, !dbg !447

sw.bb11:                                          ; preds = %entry
  %arraydecay12 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !448
  %call13 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay12, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.13, i32 0, i32 0)) #6, !dbg !449
  br label %sw.epilog, !dbg !450

sw.bb14:                                          ; preds = %entry
  %arraydecay15 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !451
  %call16 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay15, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.14, i32 0, i32 0)) #6, !dbg !452
  br label %sw.epilog, !dbg !453

sw.bb17:                                          ; preds = %entry
  %arraydecay18 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !454
  %call19 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay18, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.15, i32 0, i32 0)) #6, !dbg !455
  br label %sw.epilog, !dbg !456

sw.default:                                       ; preds = %entry
  %arraydecay20 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !457
  %call21 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay20, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.16, i32 0, i32 0)) #6, !dbg !458
  br label %sw.epilog, !dbg !459

sw.epilog:                                        ; preds = %sw.default, %sw.bb17, %sw.bb14, %sw.bb11, %sw.bb
  %arraydecay22 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_program, i32 0, i32 0, !dbg !460
  %1 = load double, double* @bots_time_program, align 8, !dbg !461
  %call23 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay22, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.17, i32 0, i32 0), double %1) #6, !dbg !462
  %2 = load i32, i32* @bots_sequential_flag, align 4, !dbg !463
  %tobool = icmp ne i32 %2, 0, !dbg !463
  br i1 %tobool, label %if.then, label %if.else, !dbg !465

if.then:                                          ; preds = %sw.epilog
  %arraydecay24 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_sequential, i32 0, i32 0, !dbg !466
  %3 = load double, double* @bots_time_sequential, align 8, !dbg !467
  %call25 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay24, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.17, i32 0, i32 0), double %3) #6, !dbg !468
  br label %if.end, !dbg !468

if.else:                                          ; preds = %sw.epilog
  %arraydecay26 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_sequential, i32 0, i32 0, !dbg !469
  %call27 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay26, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.12, i32 0, i32 0)) #6, !dbg !470
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %4 = load i32, i32* @bots_sequential_flag, align 4, !dbg !471
  %tobool28 = icmp ne i32 %4, 0, !dbg !471
  br i1 %tobool28, label %if.then29, label %if.else32, !dbg !473

if.then29:                                        ; preds = %if.end
  %arraydecay30 = getelementptr inbounds [15 x i8], [15 x i8]* %str_speed_up, i32 0, i32 0, !dbg !474
  %5 = load double, double* @bots_time_sequential, align 8, !dbg !475
  %6 = load double, double* @bots_time_program, align 8, !dbg !476
  %div = fdiv double %5, %6, !dbg !477
  %call31 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay30, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.18, i32 0, i32 0), double %div) #6, !dbg !478
  br label %if.end35, !dbg !478

if.else32:                                        ; preds = %if.end
  %arraydecay33 = getelementptr inbounds [15 x i8], [15 x i8]* %str_speed_up, i32 0, i32 0, !dbg !479
  %call34 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay33, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.12, i32 0, i32 0)) #6, !dbg !480
  br label %if.end35

if.end35:                                         ; preds = %if.else32, %if.then29
  %arraydecay36 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks, i32 0, i32 0, !dbg !481
  %7 = load i64, i64* @bots_number_of_tasks, align 8, !dbg !482
  %conv = uitofp i64 %7 to float, !dbg !483
  %conv37 = fpext float %conv to double, !dbg !483
  %call38 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay36, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.18, i32 0, i32 0), double %conv37) #6, !dbg !484
  %arraydecay39 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks_per_second, i32 0, i32 0, !dbg !485
  %8 = load i64, i64* @bots_number_of_tasks, align 8, !dbg !486
  %conv40 = uitofp i64 %8 to float, !dbg !487
  %conv41 = fpext float %conv40 to double, !dbg !487
  %9 = load double, double* @bots_time_program, align 8, !dbg !488
  %div42 = fdiv double %conv41, %9, !dbg !489
  %call43 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay39, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.18, i32 0, i32 0), double %div42) #6, !dbg !490
  %arraydecay44 = getelementptr inbounds [256 x i8], [256 x i8]* %str_exec_date, i32 0, i32 0, !dbg !491
  %call45 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay44, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([0 x i8], [0 x i8]* @bots_exec_date, i32 0, i32 0)) #6, !dbg !492
  %arraydecay46 = getelementptr inbounds [256 x i8], [256 x i8]* %str_exec_message, i32 0, i32 0, !dbg !493
  %call47 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay46, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([0 x i8], [0 x i8]* @bots_exec_message, i32 0, i32 0)) #6, !dbg !494
  %arraydecay48 = getelementptr inbounds [256 x i8], [256 x i8]* %str_architecture, i32 0, i32 0, !dbg !495
  call void @bots_get_architecture(i8* %arraydecay48), !dbg !496
  %arraydecay49 = getelementptr inbounds [256 x i8], [256 x i8]* %str_load_avg, i32 0, i32 0, !dbg !497
  call void @bots_get_load_average(i8* %arraydecay49), !dbg !498
  %arraydecay50 = getelementptr inbounds [256 x i8], [256 x i8]* %str_comp_date, i32 0, i32 0, !dbg !499
  %call51 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay50, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([0 x i8], [0 x i8]* @bots_comp_date, i32 0, i32 0)) #6, !dbg !500
  %arraydecay52 = getelementptr inbounds [256 x i8], [256 x i8]* %str_comp_message, i32 0, i32 0, !dbg !501
  %call53 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay52, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([0 x i8], [0 x i8]* @bots_comp_message, i32 0, i32 0)) #6, !dbg !502
  %arraydecay54 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cc, i32 0, i32 0, !dbg !503
  %call55 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay54, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([0 x i8], [0 x i8]* @bots_cc, i32 0, i32 0)) #6, !dbg !504
  %arraydecay56 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cflags, i32 0, i32 0, !dbg !505
  %call57 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay56, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([0 x i8], [0 x i8]* @bots_cflags, i32 0, i32 0)) #6, !dbg !506
  %arraydecay58 = getelementptr inbounds [256 x i8], [256 x i8]* %str_ld, i32 0, i32 0, !dbg !507
  %call59 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay58, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([0 x i8], [0 x i8]* @bots_ld, i32 0, i32 0)) #6, !dbg !508
  %arraydecay60 = getelementptr inbounds [256 x i8], [256 x i8]* %str_ldflags, i32 0, i32 0, !dbg !509
  %call61 = call i32 (i8*, i8*, ...) @sprintf(i8* %arraydecay60, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([0 x i8], [0 x i8]* @bots_ldflags, i32 0, i32 0)) #6, !dbg !510
  %10 = load i32, i32* @bots_print_header, align 4, !dbg !511
  %tobool62 = icmp ne i32 %10, 0, !dbg !511
  br i1 %tobool62, label %if.then63, label %if.end73, !dbg !513

if.then63:                                        ; preds = %if.end35
  %11 = load i32, i32* @bots_output_format, align 4, !dbg !514
  switch i32 %11, label %sw.default71 [
    i32 0, label %sw.bb64
    i32 1, label %sw.bb65
    i32 2, label %sw.bb66
    i32 3, label %sw.bb68
    i32 4, label %sw.bb69
  ], !dbg !516

sw.bb64:                                          ; preds = %if.then63
  br label %sw.epilog72, !dbg !517

sw.bb65:                                          ; preds = %if.then63
  br label %sw.epilog72, !dbg !519

sw.bb66:                                          ; preds = %if.then63
  %12 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !520
  %call67 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %12, i8* getelementptr inbounds ([238 x i8], [238 x i8]* @.str.19, i32 0, i32 0)), !dbg !521
  br label %sw.epilog72, !dbg !522

sw.bb68:                                          ; preds = %if.then63
  br label %sw.epilog72, !dbg !523

sw.bb69:                                          ; preds = %if.then63
  %13 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !524
  %call70 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %13, i8* getelementptr inbounds ([94 x i8], [94 x i8]* @.str.20, i32 0, i32 0)), !dbg !525
  br label %sw.epilog72, !dbg !526

sw.default71:                                     ; preds = %if.then63
  br label %sw.epilog72, !dbg !527

sw.epilog72:                                      ; preds = %sw.default71, %sw.bb69, %sw.bb68, %sw.bb66, %sw.bb65, %sw.bb64
  br label %if.end73, !dbg !528

if.end73:                                         ; preds = %sw.epilog72, %if.end35
  %14 = load i32, i32* @bots_output_format, align 4, !dbg !529
  switch i32 %14, label %sw.default203 [
    i32 0, label %sw.bb74
    i32 1, label %sw.bb75
    i32 2, label %sw.bb126
    i32 3, label %sw.bb156
    i32 4, label %sw.bb187
  ], !dbg !530

sw.bb74:                                          ; preds = %if.end73
  br label %sw.epilog204, !dbg !531

sw.bb75:                                          ; preds = %if.end73
  %15 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !533
  %call76 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.21, i32 0, i32 0)), !dbg !534
  %16 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !535
  %arraydecay77 = getelementptr inbounds [256 x i8], [256 x i8]* %str_name, i32 0, i32 0, !dbg !536
  %call78 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %16, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.22, i32 0, i32 0), i8* %arraydecay77), !dbg !537
  %17 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !538
  %arraydecay79 = getelementptr inbounds [256 x i8], [256 x i8]* %str_parameters, i32 0, i32 0, !dbg !539
  %call80 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %17, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.23, i32 0, i32 0), i8* %arraydecay79), !dbg !540
  %18 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !541
  %arraydecay81 = getelementptr inbounds [256 x i8], [256 x i8]* %str_model, i32 0, i32 0, !dbg !542
  %call82 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %18, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.24, i32 0, i32 0), i8* %arraydecay81), !dbg !543
  %19 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !544
  %arraydecay83 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cutoff, i32 0, i32 0, !dbg !545
  %call84 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %19, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.25, i32 0, i32 0), i8* %arraydecay83), !dbg !546
  %20 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !547
  %arraydecay85 = getelementptr inbounds [256 x i8], [256 x i8]* %str_resources, i32 0, i32 0, !dbg !548
  %call86 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %20, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.26, i32 0, i32 0), i8* %arraydecay85), !dbg !549
  %21 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !550
  %arraydecay87 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !551
  %call88 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %21, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.27, i32 0, i32 0), i8* %arraydecay87), !dbg !552
  %22 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !553
  %arraydecay89 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_program, i32 0, i32 0, !dbg !554
  %call90 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %22, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.28, i32 0, i32 0), i8* %arraydecay89), !dbg !555
  %23 = load i32, i32* @bots_sequential_flag, align 4, !dbg !556
  %tobool91 = icmp ne i32 %23, 0, !dbg !556
  br i1 %tobool91, label %if.then92, label %if.end97, !dbg !558

if.then92:                                        ; preds = %sw.bb75
  %24 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !559
  %arraydecay93 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_sequential, i32 0, i32 0, !dbg !561
  %call94 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %24, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.29, i32 0, i32 0), i8* %arraydecay93), !dbg !562
  %25 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !563
  %arraydecay95 = getelementptr inbounds [15 x i8], [15 x i8]* %str_speed_up, i32 0, i32 0, !dbg !564
  %call96 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %25, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.30, i32 0, i32 0), i8* %arraydecay95), !dbg !565
  br label %if.end97, !dbg !566

if.end97:                                         ; preds = %if.then92, %sw.bb75
  %26 = load i64, i64* @bots_number_of_tasks, align 8, !dbg !567
  %cmp = icmp ugt i64 %26, 0, !dbg !569
  br i1 %cmp, label %if.then99, label %if.end104, !dbg !570

if.then99:                                        ; preds = %if.end97
  %27 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !571
  %arraydecay100 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks, i32 0, i32 0, !dbg !573
  %call101 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %27, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.31, i32 0, i32 0), i8* %arraydecay100), !dbg !574
  %28 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !575
  %arraydecay102 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks_per_second, i32 0, i32 0, !dbg !576
  %call103 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %28, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.32, i32 0, i32 0), i8* %arraydecay102), !dbg !577
  br label %if.end104, !dbg !578

if.end104:                                        ; preds = %if.then99, %if.end97
  %29 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !579
  %arraydecay105 = getelementptr inbounds [256 x i8], [256 x i8]* %str_exec_date, i32 0, i32 0, !dbg !580
  %call106 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %29, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.33, i32 0, i32 0), i8* %arraydecay105), !dbg !581
  %30 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !582
  %arraydecay107 = getelementptr inbounds [256 x i8], [256 x i8]* %str_exec_message, i32 0, i32 0, !dbg !583
  %call108 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %30, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.34, i32 0, i32 0), i8* %arraydecay107), !dbg !584
  %31 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !585
  %arraydecay109 = getelementptr inbounds [256 x i8], [256 x i8]* %str_architecture, i32 0, i32 0, !dbg !586
  %call110 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %31, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.35, i32 0, i32 0), i8* %arraydecay109), !dbg !587
  %32 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !588
  %arraydecay111 = getelementptr inbounds [256 x i8], [256 x i8]* %str_load_avg, i32 0, i32 0, !dbg !589
  %call112 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %32, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.36, i32 0, i32 0), i8* %arraydecay111), !dbg !590
  %33 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !591
  %arraydecay113 = getelementptr inbounds [256 x i8], [256 x i8]* %str_comp_date, i32 0, i32 0, !dbg !592
  %call114 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %33, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.37, i32 0, i32 0), i8* %arraydecay113), !dbg !593
  %34 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !594
  %arraydecay115 = getelementptr inbounds [256 x i8], [256 x i8]* %str_comp_message, i32 0, i32 0, !dbg !595
  %call116 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %34, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.38, i32 0, i32 0), i8* %arraydecay115), !dbg !596
  %35 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !597
  %arraydecay117 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cc, i32 0, i32 0, !dbg !598
  %call118 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %35, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.39, i32 0, i32 0), i8* %arraydecay117), !dbg !599
  %36 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !600
  %arraydecay119 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cflags, i32 0, i32 0, !dbg !601
  %call120 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %36, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.40, i32 0, i32 0), i8* %arraydecay119), !dbg !602
  %37 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !603
  %arraydecay121 = getelementptr inbounds [256 x i8], [256 x i8]* %str_ld, i32 0, i32 0, !dbg !604
  %call122 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %37, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.41, i32 0, i32 0), i8* %arraydecay121), !dbg !605
  %38 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !606
  %arraydecay123 = getelementptr inbounds [256 x i8], [256 x i8]* %str_ldflags, i32 0, i32 0, !dbg !607
  %call124 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %38, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.42, i32 0, i32 0), i8* %arraydecay123), !dbg !608
  %39 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !609
  %call125 = call i32 @fflush(%struct._IO_FILE* %39), !dbg !610
  br label %sw.epilog204, !dbg !611

sw.bb126:                                         ; preds = %if.end73
  %40 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !612
  %arraydecay127 = getelementptr inbounds [256 x i8], [256 x i8]* %str_name, i32 0, i32 0, !dbg !613
  %arraydecay128 = getelementptr inbounds [256 x i8], [256 x i8]* %str_parameters, i32 0, i32 0, !dbg !614
  %arraydecay129 = getelementptr inbounds [256 x i8], [256 x i8]* %str_model, i32 0, i32 0, !dbg !615
  %arraydecay130 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cutoff, i32 0, i32 0, !dbg !616
  %arraydecay131 = getelementptr inbounds [256 x i8], [256 x i8]* %str_resources, i32 0, i32 0, !dbg !617
  %arraydecay132 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !618
  %call133 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %40, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.43, i32 0, i32 0), i8* %arraydecay127, i8* %arraydecay128, i8* %arraydecay129, i8* %arraydecay130, i8* %arraydecay131, i8* %arraydecay132), !dbg !619
  %41 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !620
  %arraydecay134 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_program, i32 0, i32 0, !dbg !621
  %arraydecay135 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_sequential, i32 0, i32 0, !dbg !622
  %arraydecay136 = getelementptr inbounds [15 x i8], [15 x i8]* %str_speed_up, i32 0, i32 0, !dbg !623
  %call137 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %41, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.44, i32 0, i32 0), i8* %arraydecay134, i8* %arraydecay135, i8* %arraydecay136), !dbg !624
  %42 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !625
  %arraydecay138 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks, i32 0, i32 0, !dbg !626
  %arraydecay139 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks_per_second, i32 0, i32 0, !dbg !627
  %call140 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %42, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.45, i32 0, i32 0), i8* %arraydecay138, i8* %arraydecay139), !dbg !628
  %43 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !629
  %arraydecay141 = getelementptr inbounds [256 x i8], [256 x i8]* %str_exec_date, i32 0, i32 0, !dbg !630
  %arraydecay142 = getelementptr inbounds [256 x i8], [256 x i8]* %str_exec_message, i32 0, i32 0, !dbg !631
  %call143 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %43, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.45, i32 0, i32 0), i8* %arraydecay141, i8* %arraydecay142), !dbg !632
  %44 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !633
  %arraydecay144 = getelementptr inbounds [256 x i8], [256 x i8]* %str_architecture, i32 0, i32 0, !dbg !634
  %arraydecay145 = getelementptr inbounds [256 x i8], [256 x i8]* %str_load_avg, i32 0, i32 0, !dbg !635
  %call146 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %44, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.45, i32 0, i32 0), i8* %arraydecay144, i8* %arraydecay145), !dbg !636
  %45 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !637
  %arraydecay147 = getelementptr inbounds [256 x i8], [256 x i8]* %str_comp_date, i32 0, i32 0, !dbg !638
  %arraydecay148 = getelementptr inbounds [256 x i8], [256 x i8]* %str_comp_message, i32 0, i32 0, !dbg !639
  %call149 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %45, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.45, i32 0, i32 0), i8* %arraydecay147, i8* %arraydecay148), !dbg !640
  %46 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !641
  %arraydecay150 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cc, i32 0, i32 0, !dbg !642
  %arraydecay151 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cflags, i32 0, i32 0, !dbg !643
  %arraydecay152 = getelementptr inbounds [256 x i8], [256 x i8]* %str_ld, i32 0, i32 0, !dbg !644
  %arraydecay153 = getelementptr inbounds [256 x i8], [256 x i8]* %str_ldflags, i32 0, i32 0, !dbg !645
  %call154 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %46, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.46, i32 0, i32 0), i8* %arraydecay150, i8* %arraydecay151, i8* %arraydecay152, i8* %arraydecay153), !dbg !646
  %47 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !647
  %call155 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %47, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.21, i32 0, i32 0)), !dbg !648
  br label %sw.epilog204, !dbg !649

sw.bb156:                                         ; preds = %if.end73
  %48 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !650
  %call157 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %48, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.21, i32 0, i32 0)), !dbg !651
  %49 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !652
  %arraydecay158 = getelementptr inbounds [256 x i8], [256 x i8]* %str_name, i32 0, i32 0, !dbg !653
  %call159 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %49, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.22, i32 0, i32 0), i8* %arraydecay158), !dbg !654
  %50 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !655
  %arraydecay160 = getelementptr inbounds [256 x i8], [256 x i8]* %str_parameters, i32 0, i32 0, !dbg !656
  %call161 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %50, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.23, i32 0, i32 0), i8* %arraydecay160), !dbg !657
  %51 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !658
  %arraydecay162 = getelementptr inbounds [256 x i8], [256 x i8]* %str_model, i32 0, i32 0, !dbg !659
  %call163 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %51, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.24, i32 0, i32 0), i8* %arraydecay162), !dbg !660
  %52 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !661
  %arraydecay164 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cutoff, i32 0, i32 0, !dbg !662
  %call165 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %52, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.25, i32 0, i32 0), i8* %arraydecay164), !dbg !663
  %53 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !664
  %arraydecay166 = getelementptr inbounds [256 x i8], [256 x i8]* %str_resources, i32 0, i32 0, !dbg !665
  %call167 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %53, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.26, i32 0, i32 0), i8* %arraydecay166), !dbg !666
  %54 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !667
  %arraydecay168 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !668
  %call169 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %54, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.27, i32 0, i32 0), i8* %arraydecay168), !dbg !669
  %55 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !670
  %arraydecay170 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_program, i32 0, i32 0, !dbg !671
  %call171 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %55, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.28, i32 0, i32 0), i8* %arraydecay170), !dbg !672
  %56 = load i32, i32* @bots_sequential_flag, align 4, !dbg !673
  %tobool172 = icmp ne i32 %56, 0, !dbg !673
  br i1 %tobool172, label %if.then173, label %if.end178, !dbg !675

if.then173:                                       ; preds = %sw.bb156
  %57 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !676
  %arraydecay174 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_sequential, i32 0, i32 0, !dbg !678
  %call175 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %57, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.29, i32 0, i32 0), i8* %arraydecay174), !dbg !679
  %58 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !680
  %arraydecay176 = getelementptr inbounds [15 x i8], [15 x i8]* %str_speed_up, i32 0, i32 0, !dbg !681
  %call177 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %58, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.30, i32 0, i32 0), i8* %arraydecay176), !dbg !682
  br label %if.end178, !dbg !683

if.end178:                                        ; preds = %if.then173, %sw.bb156
  %59 = load i64, i64* @bots_number_of_tasks, align 8, !dbg !684
  %cmp179 = icmp ugt i64 %59, 0, !dbg !686
  br i1 %cmp179, label %if.then181, label %if.end186, !dbg !687

if.then181:                                       ; preds = %if.end178
  %60 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !688
  %arraydecay182 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks, i32 0, i32 0, !dbg !690
  %call183 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %60, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.31, i32 0, i32 0), i8* %arraydecay182), !dbg !691
  %61 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !692
  %arraydecay184 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks_per_second, i32 0, i32 0, !dbg !693
  %call185 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %61, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.32, i32 0, i32 0), i8* %arraydecay184), !dbg !694
  br label %if.end186, !dbg !695

if.end186:                                        ; preds = %if.then181, %if.end178
  br label %sw.epilog204, !dbg !696

sw.bb187:                                         ; preds = %if.end73
  %62 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !697
  %arraydecay188 = getelementptr inbounds [256 x i8], [256 x i8]* %str_name, i32 0, i32 0, !dbg !698
  %arraydecay189 = getelementptr inbounds [256 x i8], [256 x i8]* %str_parameters, i32 0, i32 0, !dbg !699
  %arraydecay190 = getelementptr inbounds [256 x i8], [256 x i8]* %str_model, i32 0, i32 0, !dbg !700
  %arraydecay191 = getelementptr inbounds [256 x i8], [256 x i8]* %str_cutoff, i32 0, i32 0, !dbg !701
  %arraydecay192 = getelementptr inbounds [256 x i8], [256 x i8]* %str_resources, i32 0, i32 0, !dbg !702
  %arraydecay193 = getelementptr inbounds [15 x i8], [15 x i8]* %str_result, i32 0, i32 0, !dbg !703
  %call194 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %62, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.43, i32 0, i32 0), i8* %arraydecay188, i8* %arraydecay189, i8* %arraydecay190, i8* %arraydecay191, i8* %arraydecay192, i8* %arraydecay193), !dbg !704
  %63 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !705
  %arraydecay195 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_program, i32 0, i32 0, !dbg !706
  %arraydecay196 = getelementptr inbounds [15 x i8], [15 x i8]* %str_time_sequential, i32 0, i32 0, !dbg !707
  %arraydecay197 = getelementptr inbounds [15 x i8], [15 x i8]* %str_speed_up, i32 0, i32 0, !dbg !708
  %call198 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %63, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.44, i32 0, i32 0), i8* %arraydecay195, i8* %arraydecay196, i8* %arraydecay197), !dbg !709
  %64 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !710
  %arraydecay199 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks, i32 0, i32 0, !dbg !711
  %arraydecay200 = getelementptr inbounds [15 x i8], [15 x i8]* %str_number_of_tasks_per_second, i32 0, i32 0, !dbg !712
  %call201 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %64, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.45, i32 0, i32 0), i8* %arraydecay199, i8* %arraydecay200), !dbg !713
  %65 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !714
  %call202 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %65, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.21, i32 0, i32 0)), !dbg !715
  br label %sw.epilog204, !dbg !716

sw.default203:                                    ; preds = %if.end73
  call void @bots_error(i32 0, i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.47, i32 0, i32 0)), !dbg !717
  br label %sw.epilog204, !dbg !718

sw.epilog204:                                     ; preds = %sw.default203, %sw.bb187, %if.end186, %sw.bb126, %if.end104, %sw.bb74
  ret void, !dbg !719
}

; Function Attrs: nounwind
declare dso_local i32 @sprintf(i8*, i8*, ...) #4

declare dso_local i32 @fflush(%struct._IO_FILE*) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!225, !226, !227}
!llvm.ident = !{!228}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 8.0.1-9 (tags/RELEASE_801/final)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !222, nameTableKind: None)
!1 = !DIFile(filename: "bots_common.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/fib")
!2 = !{!3}
!3 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !4, line: 71, baseType: !5, size: 32, elements: !6)
!4 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/confname.h", directory: "")
!5 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!6 = !{!7, !8, !9, !10, !11, !12, !13, !14, !15, !16, !17, !18, !19, !20, !21, !22, !23, !24, !25, !26, !27, !28, !29, !30, !31, !32, !33, !34, !35, !36, !37, !38, !39, !40, !41, !42, !43, !44, !45, !46, !47, !48, !49, !50, !51, !52, !53, !54, !55, !56, !57, !58, !59, !60, !61, !62, !63, !64, !65, !66, !67, !68, !69, !70, !71, !72, !73, !74, !75, !76, !77, !78, !79, !80, !81, !82, !83, !84, !85, !86, !87, !88, !89, !90, !91, !92, !93, !94, !95, !96, !97, !98, !99, !100, !101, !102, !103, !104, !105, !106, !107, !108, !109, !110, !111, !112, !113, !114, !115, !116, !117, !118, !119, !120, !121, !122, !123, !124, !125, !126, !127, !128, !129, !130, !131, !132, !133, !134, !135, !136, !137, !138, !139, !140, !141, !142, !143, !144, !145, !146, !147, !148, !149, !150, !151, !152, !153, !154, !155, !156, !157, !158, !159, !160, !161, !162, !163, !164, !165, !166, !167, !168, !169, !170, !171, !172, !173, !174, !175, !176, !177, !178, !179, !180, !181, !182, !183, !184, !185, !186, !187, !188, !189, !190, !191, !192, !193, !194, !195, !196, !197, !198, !199, !200, !201, !202, !203, !204, !205, !206, !207, !208, !209, !210, !211, !212, !213, !214, !215, !216, !217, !218, !219, !220, !221}
!7 = !DIEnumerator(name: "_SC_ARG_MAX", value: 0, isUnsigned: true)
!8 = !DIEnumerator(name: "_SC_CHILD_MAX", value: 1, isUnsigned: true)
!9 = !DIEnumerator(name: "_SC_CLK_TCK", value: 2, isUnsigned: true)
!10 = !DIEnumerator(name: "_SC_NGROUPS_MAX", value: 3, isUnsigned: true)
!11 = !DIEnumerator(name: "_SC_OPEN_MAX", value: 4, isUnsigned: true)
!12 = !DIEnumerator(name: "_SC_STREAM_MAX", value: 5, isUnsigned: true)
!13 = !DIEnumerator(name: "_SC_TZNAME_MAX", value: 6, isUnsigned: true)
!14 = !DIEnumerator(name: "_SC_JOB_CONTROL", value: 7, isUnsigned: true)
!15 = !DIEnumerator(name: "_SC_SAVED_IDS", value: 8, isUnsigned: true)
!16 = !DIEnumerator(name: "_SC_REALTIME_SIGNALS", value: 9, isUnsigned: true)
!17 = !DIEnumerator(name: "_SC_PRIORITY_SCHEDULING", value: 10, isUnsigned: true)
!18 = !DIEnumerator(name: "_SC_TIMERS", value: 11, isUnsigned: true)
!19 = !DIEnumerator(name: "_SC_ASYNCHRONOUS_IO", value: 12, isUnsigned: true)
!20 = !DIEnumerator(name: "_SC_PRIORITIZED_IO", value: 13, isUnsigned: true)
!21 = !DIEnumerator(name: "_SC_SYNCHRONIZED_IO", value: 14, isUnsigned: true)
!22 = !DIEnumerator(name: "_SC_FSYNC", value: 15, isUnsigned: true)
!23 = !DIEnumerator(name: "_SC_MAPPED_FILES", value: 16, isUnsigned: true)
!24 = !DIEnumerator(name: "_SC_MEMLOCK", value: 17, isUnsigned: true)
!25 = !DIEnumerator(name: "_SC_MEMLOCK_RANGE", value: 18, isUnsigned: true)
!26 = !DIEnumerator(name: "_SC_MEMORY_PROTECTION", value: 19, isUnsigned: true)
!27 = !DIEnumerator(name: "_SC_MESSAGE_PASSING", value: 20, isUnsigned: true)
!28 = !DIEnumerator(name: "_SC_SEMAPHORES", value: 21, isUnsigned: true)
!29 = !DIEnumerator(name: "_SC_SHARED_MEMORY_OBJECTS", value: 22, isUnsigned: true)
!30 = !DIEnumerator(name: "_SC_AIO_LISTIO_MAX", value: 23, isUnsigned: true)
!31 = !DIEnumerator(name: "_SC_AIO_MAX", value: 24, isUnsigned: true)
!32 = !DIEnumerator(name: "_SC_AIO_PRIO_DELTA_MAX", value: 25, isUnsigned: true)
!33 = !DIEnumerator(name: "_SC_DELAYTIMER_MAX", value: 26, isUnsigned: true)
!34 = !DIEnumerator(name: "_SC_MQ_OPEN_MAX", value: 27, isUnsigned: true)
!35 = !DIEnumerator(name: "_SC_MQ_PRIO_MAX", value: 28, isUnsigned: true)
!36 = !DIEnumerator(name: "_SC_VERSION", value: 29, isUnsigned: true)
!37 = !DIEnumerator(name: "_SC_PAGESIZE", value: 30, isUnsigned: true)
!38 = !DIEnumerator(name: "_SC_RTSIG_MAX", value: 31, isUnsigned: true)
!39 = !DIEnumerator(name: "_SC_SEM_NSEMS_MAX", value: 32, isUnsigned: true)
!40 = !DIEnumerator(name: "_SC_SEM_VALUE_MAX", value: 33, isUnsigned: true)
!41 = !DIEnumerator(name: "_SC_SIGQUEUE_MAX", value: 34, isUnsigned: true)
!42 = !DIEnumerator(name: "_SC_TIMER_MAX", value: 35, isUnsigned: true)
!43 = !DIEnumerator(name: "_SC_BC_BASE_MAX", value: 36, isUnsigned: true)
!44 = !DIEnumerator(name: "_SC_BC_DIM_MAX", value: 37, isUnsigned: true)
!45 = !DIEnumerator(name: "_SC_BC_SCALE_MAX", value: 38, isUnsigned: true)
!46 = !DIEnumerator(name: "_SC_BC_STRING_MAX", value: 39, isUnsigned: true)
!47 = !DIEnumerator(name: "_SC_COLL_WEIGHTS_MAX", value: 40, isUnsigned: true)
!48 = !DIEnumerator(name: "_SC_EQUIV_CLASS_MAX", value: 41, isUnsigned: true)
!49 = !DIEnumerator(name: "_SC_EXPR_NEST_MAX", value: 42, isUnsigned: true)
!50 = !DIEnumerator(name: "_SC_LINE_MAX", value: 43, isUnsigned: true)
!51 = !DIEnumerator(name: "_SC_RE_DUP_MAX", value: 44, isUnsigned: true)
!52 = !DIEnumerator(name: "_SC_CHARCLASS_NAME_MAX", value: 45, isUnsigned: true)
!53 = !DIEnumerator(name: "_SC_2_VERSION", value: 46, isUnsigned: true)
!54 = !DIEnumerator(name: "_SC_2_C_BIND", value: 47, isUnsigned: true)
!55 = !DIEnumerator(name: "_SC_2_C_DEV", value: 48, isUnsigned: true)
!56 = !DIEnumerator(name: "_SC_2_FORT_DEV", value: 49, isUnsigned: true)
!57 = !DIEnumerator(name: "_SC_2_FORT_RUN", value: 50, isUnsigned: true)
!58 = !DIEnumerator(name: "_SC_2_SW_DEV", value: 51, isUnsigned: true)
!59 = !DIEnumerator(name: "_SC_2_LOCALEDEF", value: 52, isUnsigned: true)
!60 = !DIEnumerator(name: "_SC_PII", value: 53, isUnsigned: true)
!61 = !DIEnumerator(name: "_SC_PII_XTI", value: 54, isUnsigned: true)
!62 = !DIEnumerator(name: "_SC_PII_SOCKET", value: 55, isUnsigned: true)
!63 = !DIEnumerator(name: "_SC_PII_INTERNET", value: 56, isUnsigned: true)
!64 = !DIEnumerator(name: "_SC_PII_OSI", value: 57, isUnsigned: true)
!65 = !DIEnumerator(name: "_SC_POLL", value: 58, isUnsigned: true)
!66 = !DIEnumerator(name: "_SC_SELECT", value: 59, isUnsigned: true)
!67 = !DIEnumerator(name: "_SC_UIO_MAXIOV", value: 60, isUnsigned: true)
!68 = !DIEnumerator(name: "_SC_IOV_MAX", value: 60, isUnsigned: true)
!69 = !DIEnumerator(name: "_SC_PII_INTERNET_STREAM", value: 61, isUnsigned: true)
!70 = !DIEnumerator(name: "_SC_PII_INTERNET_DGRAM", value: 62, isUnsigned: true)
!71 = !DIEnumerator(name: "_SC_PII_OSI_COTS", value: 63, isUnsigned: true)
!72 = !DIEnumerator(name: "_SC_PII_OSI_CLTS", value: 64, isUnsigned: true)
!73 = !DIEnumerator(name: "_SC_PII_OSI_M", value: 65, isUnsigned: true)
!74 = !DIEnumerator(name: "_SC_T_IOV_MAX", value: 66, isUnsigned: true)
!75 = !DIEnumerator(name: "_SC_THREADS", value: 67, isUnsigned: true)
!76 = !DIEnumerator(name: "_SC_THREAD_SAFE_FUNCTIONS", value: 68, isUnsigned: true)
!77 = !DIEnumerator(name: "_SC_GETGR_R_SIZE_MAX", value: 69, isUnsigned: true)
!78 = !DIEnumerator(name: "_SC_GETPW_R_SIZE_MAX", value: 70, isUnsigned: true)
!79 = !DIEnumerator(name: "_SC_LOGIN_NAME_MAX", value: 71, isUnsigned: true)
!80 = !DIEnumerator(name: "_SC_TTY_NAME_MAX", value: 72, isUnsigned: true)
!81 = !DIEnumerator(name: "_SC_THREAD_DESTRUCTOR_ITERATIONS", value: 73, isUnsigned: true)
!82 = !DIEnumerator(name: "_SC_THREAD_KEYS_MAX", value: 74, isUnsigned: true)
!83 = !DIEnumerator(name: "_SC_THREAD_STACK_MIN", value: 75, isUnsigned: true)
!84 = !DIEnumerator(name: "_SC_THREAD_THREADS_MAX", value: 76, isUnsigned: true)
!85 = !DIEnumerator(name: "_SC_THREAD_ATTR_STACKADDR", value: 77, isUnsigned: true)
!86 = !DIEnumerator(name: "_SC_THREAD_ATTR_STACKSIZE", value: 78, isUnsigned: true)
!87 = !DIEnumerator(name: "_SC_THREAD_PRIORITY_SCHEDULING", value: 79, isUnsigned: true)
!88 = !DIEnumerator(name: "_SC_THREAD_PRIO_INHERIT", value: 80, isUnsigned: true)
!89 = !DIEnumerator(name: "_SC_THREAD_PRIO_PROTECT", value: 81, isUnsigned: true)
!90 = !DIEnumerator(name: "_SC_THREAD_PROCESS_SHARED", value: 82, isUnsigned: true)
!91 = !DIEnumerator(name: "_SC_NPROCESSORS_CONF", value: 83, isUnsigned: true)
!92 = !DIEnumerator(name: "_SC_NPROCESSORS_ONLN", value: 84, isUnsigned: true)
!93 = !DIEnumerator(name: "_SC_PHYS_PAGES", value: 85, isUnsigned: true)
!94 = !DIEnumerator(name: "_SC_AVPHYS_PAGES", value: 86, isUnsigned: true)
!95 = !DIEnumerator(name: "_SC_ATEXIT_MAX", value: 87, isUnsigned: true)
!96 = !DIEnumerator(name: "_SC_PASS_MAX", value: 88, isUnsigned: true)
!97 = !DIEnumerator(name: "_SC_XOPEN_VERSION", value: 89, isUnsigned: true)
!98 = !DIEnumerator(name: "_SC_XOPEN_XCU_VERSION", value: 90, isUnsigned: true)
!99 = !DIEnumerator(name: "_SC_XOPEN_UNIX", value: 91, isUnsigned: true)
!100 = !DIEnumerator(name: "_SC_XOPEN_CRYPT", value: 92, isUnsigned: true)
!101 = !DIEnumerator(name: "_SC_XOPEN_ENH_I18N", value: 93, isUnsigned: true)
!102 = !DIEnumerator(name: "_SC_XOPEN_SHM", value: 94, isUnsigned: true)
!103 = !DIEnumerator(name: "_SC_2_CHAR_TERM", value: 95, isUnsigned: true)
!104 = !DIEnumerator(name: "_SC_2_C_VERSION", value: 96, isUnsigned: true)
!105 = !DIEnumerator(name: "_SC_2_UPE", value: 97, isUnsigned: true)
!106 = !DIEnumerator(name: "_SC_XOPEN_XPG2", value: 98, isUnsigned: true)
!107 = !DIEnumerator(name: "_SC_XOPEN_XPG3", value: 99, isUnsigned: true)
!108 = !DIEnumerator(name: "_SC_XOPEN_XPG4", value: 100, isUnsigned: true)
!109 = !DIEnumerator(name: "_SC_CHAR_BIT", value: 101, isUnsigned: true)
!110 = !DIEnumerator(name: "_SC_CHAR_MAX", value: 102, isUnsigned: true)
!111 = !DIEnumerator(name: "_SC_CHAR_MIN", value: 103, isUnsigned: true)
!112 = !DIEnumerator(name: "_SC_INT_MAX", value: 104, isUnsigned: true)
!113 = !DIEnumerator(name: "_SC_INT_MIN", value: 105, isUnsigned: true)
!114 = !DIEnumerator(name: "_SC_LONG_BIT", value: 106, isUnsigned: true)
!115 = !DIEnumerator(name: "_SC_WORD_BIT", value: 107, isUnsigned: true)
!116 = !DIEnumerator(name: "_SC_MB_LEN_MAX", value: 108, isUnsigned: true)
!117 = !DIEnumerator(name: "_SC_NZERO", value: 109, isUnsigned: true)
!118 = !DIEnumerator(name: "_SC_SSIZE_MAX", value: 110, isUnsigned: true)
!119 = !DIEnumerator(name: "_SC_SCHAR_MAX", value: 111, isUnsigned: true)
!120 = !DIEnumerator(name: "_SC_SCHAR_MIN", value: 112, isUnsigned: true)
!121 = !DIEnumerator(name: "_SC_SHRT_MAX", value: 113, isUnsigned: true)
!122 = !DIEnumerator(name: "_SC_SHRT_MIN", value: 114, isUnsigned: true)
!123 = !DIEnumerator(name: "_SC_UCHAR_MAX", value: 115, isUnsigned: true)
!124 = !DIEnumerator(name: "_SC_UINT_MAX", value: 116, isUnsigned: true)
!125 = !DIEnumerator(name: "_SC_ULONG_MAX", value: 117, isUnsigned: true)
!126 = !DIEnumerator(name: "_SC_USHRT_MAX", value: 118, isUnsigned: true)
!127 = !DIEnumerator(name: "_SC_NL_ARGMAX", value: 119, isUnsigned: true)
!128 = !DIEnumerator(name: "_SC_NL_LANGMAX", value: 120, isUnsigned: true)
!129 = !DIEnumerator(name: "_SC_NL_MSGMAX", value: 121, isUnsigned: true)
!130 = !DIEnumerator(name: "_SC_NL_NMAX", value: 122, isUnsigned: true)
!131 = !DIEnumerator(name: "_SC_NL_SETMAX", value: 123, isUnsigned: true)
!132 = !DIEnumerator(name: "_SC_NL_TEXTMAX", value: 124, isUnsigned: true)
!133 = !DIEnumerator(name: "_SC_XBS5_ILP32_OFF32", value: 125, isUnsigned: true)
!134 = !DIEnumerator(name: "_SC_XBS5_ILP32_OFFBIG", value: 126, isUnsigned: true)
!135 = !DIEnumerator(name: "_SC_XBS5_LP64_OFF64", value: 127, isUnsigned: true)
!136 = !DIEnumerator(name: "_SC_XBS5_LPBIG_OFFBIG", value: 128, isUnsigned: true)
!137 = !DIEnumerator(name: "_SC_XOPEN_LEGACY", value: 129, isUnsigned: true)
!138 = !DIEnumerator(name: "_SC_XOPEN_REALTIME", value: 130, isUnsigned: true)
!139 = !DIEnumerator(name: "_SC_XOPEN_REALTIME_THREADS", value: 131, isUnsigned: true)
!140 = !DIEnumerator(name: "_SC_ADVISORY_INFO", value: 132, isUnsigned: true)
!141 = !DIEnumerator(name: "_SC_BARRIERS", value: 133, isUnsigned: true)
!142 = !DIEnumerator(name: "_SC_BASE", value: 134, isUnsigned: true)
!143 = !DIEnumerator(name: "_SC_C_LANG_SUPPORT", value: 135, isUnsigned: true)
!144 = !DIEnumerator(name: "_SC_C_LANG_SUPPORT_R", value: 136, isUnsigned: true)
!145 = !DIEnumerator(name: "_SC_CLOCK_SELECTION", value: 137, isUnsigned: true)
!146 = !DIEnumerator(name: "_SC_CPUTIME", value: 138, isUnsigned: true)
!147 = !DIEnumerator(name: "_SC_THREAD_CPUTIME", value: 139, isUnsigned: true)
!148 = !DIEnumerator(name: "_SC_DEVICE_IO", value: 140, isUnsigned: true)
!149 = !DIEnumerator(name: "_SC_DEVICE_SPECIFIC", value: 141, isUnsigned: true)
!150 = !DIEnumerator(name: "_SC_DEVICE_SPECIFIC_R", value: 142, isUnsigned: true)
!151 = !DIEnumerator(name: "_SC_FD_MGMT", value: 143, isUnsigned: true)
!152 = !DIEnumerator(name: "_SC_FIFO", value: 144, isUnsigned: true)
!153 = !DIEnumerator(name: "_SC_PIPE", value: 145, isUnsigned: true)
!154 = !DIEnumerator(name: "_SC_FILE_ATTRIBUTES", value: 146, isUnsigned: true)
!155 = !DIEnumerator(name: "_SC_FILE_LOCKING", value: 147, isUnsigned: true)
!156 = !DIEnumerator(name: "_SC_FILE_SYSTEM", value: 148, isUnsigned: true)
!157 = !DIEnumerator(name: "_SC_MONOTONIC_CLOCK", value: 149, isUnsigned: true)
!158 = !DIEnumerator(name: "_SC_MULTI_PROCESS", value: 150, isUnsigned: true)
!159 = !DIEnumerator(name: "_SC_SINGLE_PROCESS", value: 151, isUnsigned: true)
!160 = !DIEnumerator(name: "_SC_NETWORKING", value: 152, isUnsigned: true)
!161 = !DIEnumerator(name: "_SC_READER_WRITER_LOCKS", value: 153, isUnsigned: true)
!162 = !DIEnumerator(name: "_SC_SPIN_LOCKS", value: 154, isUnsigned: true)
!163 = !DIEnumerator(name: "_SC_REGEXP", value: 155, isUnsigned: true)
!164 = !DIEnumerator(name: "_SC_REGEX_VERSION", value: 156, isUnsigned: true)
!165 = !DIEnumerator(name: "_SC_SHELL", value: 157, isUnsigned: true)
!166 = !DIEnumerator(name: "_SC_SIGNALS", value: 158, isUnsigned: true)
!167 = !DIEnumerator(name: "_SC_SPAWN", value: 159, isUnsigned: true)
!168 = !DIEnumerator(name: "_SC_SPORADIC_SERVER", value: 160, isUnsigned: true)
!169 = !DIEnumerator(name: "_SC_THREAD_SPORADIC_SERVER", value: 161, isUnsigned: true)
!170 = !DIEnumerator(name: "_SC_SYSTEM_DATABASE", value: 162, isUnsigned: true)
!171 = !DIEnumerator(name: "_SC_SYSTEM_DATABASE_R", value: 163, isUnsigned: true)
!172 = !DIEnumerator(name: "_SC_TIMEOUTS", value: 164, isUnsigned: true)
!173 = !DIEnumerator(name: "_SC_TYPED_MEMORY_OBJECTS", value: 165, isUnsigned: true)
!174 = !DIEnumerator(name: "_SC_USER_GROUPS", value: 166, isUnsigned: true)
!175 = !DIEnumerator(name: "_SC_USER_GROUPS_R", value: 167, isUnsigned: true)
!176 = !DIEnumerator(name: "_SC_2_PBS", value: 168, isUnsigned: true)
!177 = !DIEnumerator(name: "_SC_2_PBS_ACCOUNTING", value: 169, isUnsigned: true)
!178 = !DIEnumerator(name: "_SC_2_PBS_LOCATE", value: 170, isUnsigned: true)
!179 = !DIEnumerator(name: "_SC_2_PBS_MESSAGE", value: 171, isUnsigned: true)
!180 = !DIEnumerator(name: "_SC_2_PBS_TRACK", value: 172, isUnsigned: true)
!181 = !DIEnumerator(name: "_SC_SYMLOOP_MAX", value: 173, isUnsigned: true)
!182 = !DIEnumerator(name: "_SC_STREAMS", value: 174, isUnsigned: true)
!183 = !DIEnumerator(name: "_SC_2_PBS_CHECKPOINT", value: 175, isUnsigned: true)
!184 = !DIEnumerator(name: "_SC_V6_ILP32_OFF32", value: 176, isUnsigned: true)
!185 = !DIEnumerator(name: "_SC_V6_ILP32_OFFBIG", value: 177, isUnsigned: true)
!186 = !DIEnumerator(name: "_SC_V6_LP64_OFF64", value: 178, isUnsigned: true)
!187 = !DIEnumerator(name: "_SC_V6_LPBIG_OFFBIG", value: 179, isUnsigned: true)
!188 = !DIEnumerator(name: "_SC_HOST_NAME_MAX", value: 180, isUnsigned: true)
!189 = !DIEnumerator(name: "_SC_TRACE", value: 181, isUnsigned: true)
!190 = !DIEnumerator(name: "_SC_TRACE_EVENT_FILTER", value: 182, isUnsigned: true)
!191 = !DIEnumerator(name: "_SC_TRACE_INHERIT", value: 183, isUnsigned: true)
!192 = !DIEnumerator(name: "_SC_TRACE_LOG", value: 184, isUnsigned: true)
!193 = !DIEnumerator(name: "_SC_LEVEL1_ICACHE_SIZE", value: 185, isUnsigned: true)
!194 = !DIEnumerator(name: "_SC_LEVEL1_ICACHE_ASSOC", value: 186, isUnsigned: true)
!195 = !DIEnumerator(name: "_SC_LEVEL1_ICACHE_LINESIZE", value: 187, isUnsigned: true)
!196 = !DIEnumerator(name: "_SC_LEVEL1_DCACHE_SIZE", value: 188, isUnsigned: true)
!197 = !DIEnumerator(name: "_SC_LEVEL1_DCACHE_ASSOC", value: 189, isUnsigned: true)
!198 = !DIEnumerator(name: "_SC_LEVEL1_DCACHE_LINESIZE", value: 190, isUnsigned: true)
!199 = !DIEnumerator(name: "_SC_LEVEL2_CACHE_SIZE", value: 191, isUnsigned: true)
!200 = !DIEnumerator(name: "_SC_LEVEL2_CACHE_ASSOC", value: 192, isUnsigned: true)
!201 = !DIEnumerator(name: "_SC_LEVEL2_CACHE_LINESIZE", value: 193, isUnsigned: true)
!202 = !DIEnumerator(name: "_SC_LEVEL3_CACHE_SIZE", value: 194, isUnsigned: true)
!203 = !DIEnumerator(name: "_SC_LEVEL3_CACHE_ASSOC", value: 195, isUnsigned: true)
!204 = !DIEnumerator(name: "_SC_LEVEL3_CACHE_LINESIZE", value: 196, isUnsigned: true)
!205 = !DIEnumerator(name: "_SC_LEVEL4_CACHE_SIZE", value: 197, isUnsigned: true)
!206 = !DIEnumerator(name: "_SC_LEVEL4_CACHE_ASSOC", value: 198, isUnsigned: true)
!207 = !DIEnumerator(name: "_SC_LEVEL4_CACHE_LINESIZE", value: 199, isUnsigned: true)
!208 = !DIEnumerator(name: "_SC_IPV6", value: 235, isUnsigned: true)
!209 = !DIEnumerator(name: "_SC_RAW_SOCKETS", value: 236, isUnsigned: true)
!210 = !DIEnumerator(name: "_SC_V7_ILP32_OFF32", value: 237, isUnsigned: true)
!211 = !DIEnumerator(name: "_SC_V7_ILP32_OFFBIG", value: 238, isUnsigned: true)
!212 = !DIEnumerator(name: "_SC_V7_LP64_OFF64", value: 239, isUnsigned: true)
!213 = !DIEnumerator(name: "_SC_V7_LPBIG_OFFBIG", value: 240, isUnsigned: true)
!214 = !DIEnumerator(name: "_SC_SS_REPL_MAX", value: 241, isUnsigned: true)
!215 = !DIEnumerator(name: "_SC_TRACE_EVENT_NAME_MAX", value: 242, isUnsigned: true)
!216 = !DIEnumerator(name: "_SC_TRACE_NAME_MAX", value: 243, isUnsigned: true)
!217 = !DIEnumerator(name: "_SC_TRACE_SYS_MAX", value: 244, isUnsigned: true)
!218 = !DIEnumerator(name: "_SC_TRACE_USER_EVENT_MAX", value: 245, isUnsigned: true)
!219 = !DIEnumerator(name: "_SC_XOPEN_STREAMS", value: 246, isUnsigned: true)
!220 = !DIEnumerator(name: "_SC_THREAD_ROBUST_PRIO_INHERIT", value: 247, isUnsigned: true)
!221 = !DIEnumerator(name: "_SC_THREAD_ROBUST_PRIO_PROTECT", value: 248, isUnsigned: true)
!222 = !{!223, !224}
!223 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!224 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!225 = !{i32 2, !"Dwarf Version", i32 4}
!226 = !{i32 2, !"Debug Info Version", i32 3}
!227 = !{i32 1, !"wchar_size", i32 4}
!228 = !{!"clang version 8.0.1-9 (tags/RELEASE_801/final)"}
!229 = distinct !DISubprogram(name: "bots_error", scope: !1, file: !1, line: 35, type: !230, scopeLine: 36, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !235)
!230 = !DISubroutineType(types: !231)
!231 = !{null, !232, !233}
!232 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!233 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !234, size: 64)
!234 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!235 = !{}
!236 = !DILocalVariable(name: "error", arg: 1, scope: !229, file: !1, line: 35, type: !232)
!237 = !DILocation(line: 35, column: 16, scope: !229)
!238 = !DILocalVariable(name: "message", arg: 2, scope: !229, file: !1, line: 35, type: !233)
!239 = !DILocation(line: 35, column: 29, scope: !229)
!240 = !DILocation(line: 37, column: 8, scope: !241)
!241 = distinct !DILexicalBlock(scope: !229, file: !1, line: 37, column: 8)
!242 = !DILocation(line: 37, column: 16, scope: !241)
!243 = !DILocation(line: 37, column: 8, scope: !229)
!244 = !DILocation(line: 39, column: 14, scope: !245)
!245 = distinct !DILexicalBlock(scope: !241, file: !1, line: 38, column: 4)
!246 = !DILocation(line: 39, column: 7, scope: !245)
!247 = !DILocation(line: 42, column: 21, scope: !248)
!248 = distinct !DILexicalBlock(scope: !245, file: !1, line: 40, column: 7)
!249 = !DILocation(line: 42, column: 48, scope: !248)
!250 = !DILocation(line: 42, column: 13, scope: !248)
!251 = !DILocation(line: 43, column: 13, scope: !248)
!252 = !DILocation(line: 45, column: 21, scope: !248)
!253 = !DILocation(line: 45, column: 48, scope: !248)
!254 = !DILocation(line: 45, column: 13, scope: !248)
!255 = !DILocation(line: 46, column: 13, scope: !248)
!256 = !DILocation(line: 48, column: 21, scope: !248)
!257 = !DILocation(line: 48, column: 48, scope: !248)
!258 = !DILocation(line: 48, column: 13, scope: !248)
!259 = !DILocation(line: 49, column: 13, scope: !248)
!260 = !DILocation(line: 50, column: 13, scope: !248)
!261 = !DILocation(line: 52, column: 21, scope: !248)
!262 = !DILocation(line: 52, column: 48, scope: !248)
!263 = !DILocation(line: 52, column: 13, scope: !248)
!264 = !DILocation(line: 53, column: 13, scope: !248)
!265 = !DILocation(line: 55, column: 4, scope: !245)
!266 = !DILocation(line: 56, column: 17, scope: !241)
!267 = !DILocation(line: 56, column: 44, scope: !241)
!268 = !DILocation(line: 56, column: 50, scope: !241)
!269 = !DILocation(line: 56, column: 9, scope: !241)
!270 = !DILocation(line: 57, column: 13, scope: !229)
!271 = !DILocation(line: 57, column: 12, scope: !229)
!272 = !DILocation(line: 57, column: 4, scope: !229)
!273 = !DILocation(line: 58, column: 1, scope: !229)
!274 = distinct !DISubprogram(name: "bots_warning", scope: !1, file: !1, line: 61, type: !230, scopeLine: 62, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !235)
!275 = !DILocalVariable(name: "warning", arg: 1, scope: !274, file: !1, line: 61, type: !232)
!276 = !DILocation(line: 61, column: 18, scope: !274)
!277 = !DILocalVariable(name: "message", arg: 2, scope: !274, file: !1, line: 61, type: !233)
!278 = !DILocation(line: 61, column: 33, scope: !274)
!279 = !DILocation(line: 63, column: 8, scope: !280)
!280 = distinct !DILexicalBlock(scope: !274, file: !1, line: 63, column: 8)
!281 = !DILocation(line: 63, column: 16, scope: !280)
!282 = !DILocation(line: 63, column: 8, scope: !274)
!283 = !DILocation(line: 65, column: 14, scope: !284)
!284 = distinct !DILexicalBlock(scope: !280, file: !1, line: 64, column: 4)
!285 = !DILocation(line: 65, column: 7, scope: !284)
!286 = !DILocation(line: 68, column: 21, scope: !287)
!287 = distinct !DILexicalBlock(scope: !284, file: !1, line: 66, column: 7)
!288 = !DILocation(line: 68, column: 50, scope: !287)
!289 = !DILocation(line: 68, column: 13, scope: !287)
!290 = !DILocation(line: 69, column: 13, scope: !287)
!291 = !DILocation(line: 71, column: 21, scope: !287)
!292 = !DILocation(line: 71, column: 50, scope: !287)
!293 = !DILocation(line: 71, column: 13, scope: !287)
!294 = !DILocation(line: 72, column: 13, scope: !287)
!295 = !DILocation(line: 74, column: 4, scope: !284)
!296 = !DILocation(line: 75, column: 17, scope: !280)
!297 = !DILocation(line: 75, column: 46, scope: !280)
!298 = !DILocation(line: 75, column: 54, scope: !280)
!299 = !DILocation(line: 75, column: 9, scope: !280)
!300 = !DILocation(line: 76, column: 1, scope: !274)
!301 = distinct !DISubprogram(name: "bots_usecs", scope: !1, file: !1, line: 78, type: !302, scopeLine: 79, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !235)
!302 = !DISubroutineType(types: !303)
!303 = !{!304}
!304 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!305 = !DILocalVariable(name: "t", scope: !301, file: !1, line: 80, type: !306)
!306 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "timeval", file: !307, line: 8, size: 128, elements: !308)
!307 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/struct_timeval.h", directory: "")
!308 = !{!309, !312}
!309 = !DIDerivedType(tag: DW_TAG_member, name: "tv_sec", scope: !306, file: !307, line: 10, baseType: !310, size: 64)
!310 = !DIDerivedType(tag: DW_TAG_typedef, name: "__time_t", file: !311, line: 160, baseType: !304)
!311 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!312 = !DIDerivedType(tag: DW_TAG_member, name: "tv_usec", scope: !306, file: !307, line: 11, baseType: !313, size: 64, offset: 64)
!313 = !DIDerivedType(tag: DW_TAG_typedef, name: "__suseconds_t", file: !311, line: 162, baseType: !304)
!314 = !DILocation(line: 80, column: 19, scope: !301)
!315 = !DILocation(line: 81, column: 4, scope: !301)
!316 = !DILocation(line: 82, column: 13, scope: !301)
!317 = !DILocation(line: 82, column: 19, scope: !301)
!318 = !DILocation(line: 82, column: 30, scope: !301)
!319 = !DILocation(line: 82, column: 27, scope: !301)
!320 = !DILocation(line: 82, column: 4, scope: !301)
!321 = distinct !DISubprogram(name: "bots_get_date", scope: !1, file: !1, line: 86, type: !322, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !235)
!322 = !DISubroutineType(types: !323)
!323 = !{null, !233}
!324 = !DILocalVariable(name: "str", arg: 1, scope: !321, file: !1, line: 86, type: !233)
!325 = !DILocation(line: 86, column: 21, scope: !321)
!326 = !DILocalVariable(name: "now", scope: !321, file: !1, line: 88, type: !327)
!327 = !DIDerivedType(tag: DW_TAG_typedef, name: "time_t", file: !328, line: 7, baseType: !310)
!328 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/time_t.h", directory: "")
!329 = !DILocation(line: 88, column: 11, scope: !321)
!330 = !DILocation(line: 89, column: 4, scope: !321)
!331 = !DILocation(line: 90, column: 13, scope: !321)
!332 = !DILocation(line: 90, column: 40, scope: !321)
!333 = !DILocation(line: 90, column: 4, scope: !321)
!334 = !DILocation(line: 91, column: 1, scope: !321)
!335 = distinct !DISubprogram(name: "bots_get_architecture", scope: !1, file: !1, line: 93, type: !322, scopeLine: 94, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !235)
!336 = !DILocalVariable(name: "str", arg: 1, scope: !335, file: !1, line: 93, type: !233)
!337 = !DILocation(line: 93, column: 34, scope: !335)
!338 = !DILocalVariable(name: "ncpus", scope: !335, file: !1, line: 95, type: !232)
!339 = !DILocation(line: 95, column: 8, scope: !335)
!340 = !DILocation(line: 95, column: 16, scope: !335)
!341 = !DILocalVariable(name: "architecture", scope: !335, file: !1, line: 96, type: !342)
!342 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "utsname", file: !343, line: 48, size: 3120, elements: !344)
!343 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/sys/utsname.h", directory: "")
!344 = !{!345, !349, !350, !351, !352, !353}
!345 = !DIDerivedType(tag: DW_TAG_member, name: "sysname", scope: !342, file: !343, line: 51, baseType: !346, size: 520)
!346 = !DICompositeType(tag: DW_TAG_array_type, baseType: !234, size: 520, elements: !347)
!347 = !{!348}
!348 = !DISubrange(count: 65)
!349 = !DIDerivedType(tag: DW_TAG_member, name: "nodename", scope: !342, file: !343, line: 54, baseType: !346, size: 520, offset: 520)
!350 = !DIDerivedType(tag: DW_TAG_member, name: "release", scope: !342, file: !343, line: 57, baseType: !346, size: 520, offset: 1040)
!351 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !342, file: !343, line: 59, baseType: !346, size: 520, offset: 1560)
!352 = !DIDerivedType(tag: DW_TAG_member, name: "machine", scope: !342, file: !343, line: 62, baseType: !346, size: 520, offset: 2080)
!353 = !DIDerivedType(tag: DW_TAG_member, name: "__domainname", scope: !342, file: !343, line: 69, baseType: !346, size: 520, offset: 2600)
!354 = !DILocation(line: 96, column: 19, scope: !335)
!355 = !DILocation(line: 98, column: 4, scope: !335)
!356 = !DILocation(line: 99, column: 13, scope: !335)
!357 = !DILocation(line: 99, column: 60, scope: !335)
!358 = !DILocation(line: 99, column: 47, scope: !335)
!359 = !DILocation(line: 99, column: 82, scope: !335)
!360 = !DILocation(line: 99, column: 69, scope: !335)
!361 = !DILocation(line: 99, column: 91, scope: !335)
!362 = !DILocation(line: 99, column: 4, scope: !335)
!363 = !DILocation(line: 100, column: 1, scope: !335)
!364 = distinct !DISubprogram(name: "bots_get_load_average", scope: !1, file: !1, line: 104, type: !322, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !235)
!365 = !DILocalVariable(name: "str", arg: 1, scope: !364, file: !1, line: 104, type: !233)
!366 = !DILocation(line: 104, column: 34, scope: !364)
!367 = !DILocalVariable(name: "loadavg", scope: !364, file: !1, line: 106, type: !368)
!368 = !DICompositeType(tag: DW_TAG_array_type, baseType: !369, size: 192, elements: !370)
!369 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!370 = !{!371}
!371 = !DISubrange(count: 3)
!372 = !DILocation(line: 106, column: 11, scope: !364)
!373 = !DILocation(line: 107, column: 16, scope: !364)
!374 = !DILocation(line: 107, column: 4, scope: !364)
!375 = !DILocation(line: 108, column: 13, scope: !364)
!376 = !DILocation(line: 108, column: 52, scope: !364)
!377 = !DILocation(line: 108, column: 63, scope: !364)
!378 = !DILocation(line: 108, column: 74, scope: !364)
!379 = !DILocation(line: 108, column: 4, scope: !364)
!380 = !DILocation(line: 109, column: 1, scope: !364)
!381 = distinct !DISubprogram(name: "bots_print_results", scope: !1, file: !1, line: 115, type: !382, scopeLine: 116, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !235)
!382 = !DISubroutineType(types: !383)
!383 = !{null}
!384 = !DILocalVariable(name: "str_name", scope: !381, file: !1, line: 117, type: !385)
!385 = !DICompositeType(tag: DW_TAG_array_type, baseType: !234, size: 2048, elements: !386)
!386 = !{!387}
!387 = !DISubrange(count: 256)
!388 = !DILocation(line: 117, column: 9, scope: !381)
!389 = !DILocalVariable(name: "str_parameters", scope: !381, file: !1, line: 118, type: !385)
!390 = !DILocation(line: 118, column: 9, scope: !381)
!391 = !DILocalVariable(name: "str_model", scope: !381, file: !1, line: 119, type: !385)
!392 = !DILocation(line: 119, column: 9, scope: !381)
!393 = !DILocalVariable(name: "str_resources", scope: !381, file: !1, line: 120, type: !385)
!394 = !DILocation(line: 120, column: 9, scope: !381)
!395 = !DILocalVariable(name: "str_result", scope: !381, file: !1, line: 121, type: !396)
!396 = !DICompositeType(tag: DW_TAG_array_type, baseType: !234, size: 120, elements: !397)
!397 = !{!398}
!398 = !DISubrange(count: 15)
!399 = !DILocation(line: 121, column: 9, scope: !381)
!400 = !DILocalVariable(name: "str_time_program", scope: !381, file: !1, line: 122, type: !396)
!401 = !DILocation(line: 122, column: 9, scope: !381)
!402 = !DILocalVariable(name: "str_time_sequential", scope: !381, file: !1, line: 123, type: !396)
!403 = !DILocation(line: 123, column: 9, scope: !381)
!404 = !DILocalVariable(name: "str_speed_up", scope: !381, file: !1, line: 124, type: !396)
!405 = !DILocation(line: 124, column: 9, scope: !381)
!406 = !DILocalVariable(name: "str_number_of_tasks", scope: !381, file: !1, line: 125, type: !396)
!407 = !DILocation(line: 125, column: 9, scope: !381)
!408 = !DILocalVariable(name: "str_number_of_tasks_per_second", scope: !381, file: !1, line: 126, type: !396)
!409 = !DILocation(line: 126, column: 9, scope: !381)
!410 = !DILocalVariable(name: "str_exec_date", scope: !381, file: !1, line: 127, type: !385)
!411 = !DILocation(line: 127, column: 9, scope: !381)
!412 = !DILocalVariable(name: "str_exec_message", scope: !381, file: !1, line: 128, type: !385)
!413 = !DILocation(line: 128, column: 9, scope: !381)
!414 = !DILocalVariable(name: "str_architecture", scope: !381, file: !1, line: 129, type: !385)
!415 = !DILocation(line: 129, column: 9, scope: !381)
!416 = !DILocalVariable(name: "str_load_avg", scope: !381, file: !1, line: 130, type: !385)
!417 = !DILocation(line: 130, column: 9, scope: !381)
!418 = !DILocalVariable(name: "str_comp_date", scope: !381, file: !1, line: 131, type: !385)
!419 = !DILocation(line: 131, column: 9, scope: !381)
!420 = !DILocalVariable(name: "str_comp_message", scope: !381, file: !1, line: 132, type: !385)
!421 = !DILocation(line: 132, column: 9, scope: !381)
!422 = !DILocalVariable(name: "str_cc", scope: !381, file: !1, line: 133, type: !385)
!423 = !DILocation(line: 133, column: 9, scope: !381)
!424 = !DILocalVariable(name: "str_cflags", scope: !381, file: !1, line: 134, type: !385)
!425 = !DILocation(line: 134, column: 9, scope: !381)
!426 = !DILocalVariable(name: "str_ld", scope: !381, file: !1, line: 135, type: !385)
!427 = !DILocation(line: 135, column: 9, scope: !381)
!428 = !DILocalVariable(name: "str_ldflags", scope: !381, file: !1, line: 136, type: !385)
!429 = !DILocation(line: 136, column: 9, scope: !381)
!430 = !DILocalVariable(name: "str_cutoff", scope: !381, file: !1, line: 137, type: !385)
!431 = !DILocation(line: 137, column: 9, scope: !381)
!432 = !DILocation(line: 140, column: 12, scope: !381)
!433 = !DILocation(line: 140, column: 4, scope: !381)
!434 = !DILocation(line: 141, column: 12, scope: !381)
!435 = !DILocation(line: 141, column: 4, scope: !381)
!436 = !DILocation(line: 142, column: 12, scope: !381)
!437 = !DILocation(line: 142, column: 4, scope: !381)
!438 = !DILocation(line: 143, column: 12, scope: !381)
!439 = !DILocation(line: 143, column: 4, scope: !381)
!440 = !DILocation(line: 144, column: 12, scope: !381)
!441 = !DILocation(line: 144, column: 4, scope: !381)
!442 = !DILocation(line: 145, column: 11, scope: !381)
!443 = !DILocation(line: 145, column: 4, scope: !381)
!444 = !DILocation(line: 148, column: 18, scope: !445)
!445 = distinct !DILexicalBlock(scope: !381, file: !1, line: 146, column: 4)
!446 = !DILocation(line: 148, column: 10, scope: !445)
!447 = !DILocation(line: 149, column: 10, scope: !445)
!448 = !DILocation(line: 151, column: 18, scope: !445)
!449 = !DILocation(line: 151, column: 10, scope: !445)
!450 = !DILocation(line: 152, column: 10, scope: !445)
!451 = !DILocation(line: 154, column: 18, scope: !445)
!452 = !DILocation(line: 154, column: 10, scope: !445)
!453 = !DILocation(line: 155, column: 10, scope: !445)
!454 = !DILocation(line: 157, column: 18, scope: !445)
!455 = !DILocation(line: 157, column: 10, scope: !445)
!456 = !DILocation(line: 158, column: 10, scope: !445)
!457 = !DILocation(line: 160, column: 18, scope: !445)
!458 = !DILocation(line: 160, column: 10, scope: !445)
!459 = !DILocation(line: 161, column: 10, scope: !445)
!460 = !DILocation(line: 163, column: 12, scope: !381)
!461 = !DILocation(line: 163, column: 36, scope: !381)
!462 = !DILocation(line: 163, column: 4, scope: !381)
!463 = !DILocation(line: 164, column: 8, scope: !464)
!464 = distinct !DILexicalBlock(scope: !381, file: !1, line: 164, column: 8)
!465 = !DILocation(line: 164, column: 8, scope: !381)
!466 = !DILocation(line: 164, column: 38, scope: !464)
!467 = !DILocation(line: 164, column: 65, scope: !464)
!468 = !DILocation(line: 164, column: 30, scope: !464)
!469 = !DILocation(line: 165, column: 17, scope: !464)
!470 = !DILocation(line: 165, column: 9, scope: !464)
!471 = !DILocation(line: 166, column: 8, scope: !472)
!472 = distinct !DILexicalBlock(scope: !381, file: !1, line: 166, column: 8)
!473 = !DILocation(line: 166, column: 8, scope: !381)
!474 = !DILocation(line: 167, column: 12, scope: !472)
!475 = !DILocation(line: 167, column: 35, scope: !472)
!476 = !DILocation(line: 167, column: 56, scope: !472)
!477 = !DILocation(line: 167, column: 55, scope: !472)
!478 = !DILocation(line: 167, column: 4, scope: !472)
!479 = !DILocation(line: 168, column: 17, scope: !472)
!480 = !DILocation(line: 168, column: 9, scope: !472)
!481 = !DILocation(line: 170, column: 12, scope: !381)
!482 = !DILocation(line: 170, column: 50, scope: !381)
!483 = !DILocation(line: 170, column: 42, scope: !381)
!484 = !DILocation(line: 170, column: 4, scope: !381)
!485 = !DILocation(line: 171, column: 12, scope: !381)
!486 = !DILocation(line: 171, column: 61, scope: !381)
!487 = !DILocation(line: 171, column: 53, scope: !381)
!488 = !DILocation(line: 171, column: 82, scope: !381)
!489 = !DILocation(line: 171, column: 81, scope: !381)
!490 = !DILocation(line: 171, column: 4, scope: !381)
!491 = !DILocation(line: 173, column: 12, scope: !381)
!492 = !DILocation(line: 173, column: 4, scope: !381)
!493 = !DILocation(line: 174, column: 12, scope: !381)
!494 = !DILocation(line: 174, column: 4, scope: !381)
!495 = !DILocation(line: 175, column: 26, scope: !381)
!496 = !DILocation(line: 175, column: 4, scope: !381)
!497 = !DILocation(line: 176, column: 26, scope: !381)
!498 = !DILocation(line: 176, column: 4, scope: !381)
!499 = !DILocation(line: 177, column: 12, scope: !381)
!500 = !DILocation(line: 177, column: 4, scope: !381)
!501 = !DILocation(line: 178, column: 12, scope: !381)
!502 = !DILocation(line: 178, column: 4, scope: !381)
!503 = !DILocation(line: 179, column: 12, scope: !381)
!504 = !DILocation(line: 179, column: 4, scope: !381)
!505 = !DILocation(line: 180, column: 12, scope: !381)
!506 = !DILocation(line: 180, column: 4, scope: !381)
!507 = !DILocation(line: 181, column: 12, scope: !381)
!508 = !DILocation(line: 181, column: 4, scope: !381)
!509 = !DILocation(line: 182, column: 12, scope: !381)
!510 = !DILocation(line: 182, column: 4, scope: !381)
!511 = !DILocation(line: 184, column: 7, scope: !512)
!512 = distinct !DILexicalBlock(scope: !381, file: !1, line: 184, column: 7)
!513 = !DILocation(line: 184, column: 7, scope: !381)
!514 = !DILocation(line: 186, column: 14, scope: !515)
!515 = distinct !DILexicalBlock(scope: !512, file: !1, line: 185, column: 4)
!516 = !DILocation(line: 186, column: 7, scope: !515)
!517 = !DILocation(line: 189, column: 13, scope: !518)
!518 = distinct !DILexicalBlock(scope: !515, file: !1, line: 187, column: 7)
!519 = !DILocation(line: 191, column: 13, scope: !518)
!520 = !DILocation(line: 193, column: 9, scope: !518)
!521 = !DILocation(line: 193, column: 1, scope: !518)
!522 = !DILocation(line: 200, column: 13, scope: !518)
!523 = !DILocation(line: 202, column: 13, scope: !518)
!524 = !DILocation(line: 204, column: 9, scope: !518)
!525 = !DILocation(line: 204, column: 1, scope: !518)
!526 = !DILocation(line: 208, column: 13, scope: !518)
!527 = !DILocation(line: 210, column: 13, scope: !518)
!528 = !DILocation(line: 212, column: 4, scope: !515)
!529 = !DILocation(line: 215, column: 11, scope: !381)
!530 = !DILocation(line: 215, column: 4, scope: !381)
!531 = !DILocation(line: 218, column: 10, scope: !532)
!532 = distinct !DILexicalBlock(scope: !381, file: !1, line: 216, column: 4)
!533 = !DILocation(line: 220, column: 11, scope: !532)
!534 = !DILocation(line: 220, column: 3, scope: !532)
!535 = !DILocation(line: 221, column: 18, scope: !532)
!536 = !DILocation(line: 221, column: 56, scope: !532)
!537 = !DILocation(line: 221, column: 10, scope: !532)
!538 = !DILocation(line: 222, column: 18, scope: !532)
!539 = !DILocation(line: 222, column: 56, scope: !532)
!540 = !DILocation(line: 222, column: 10, scope: !532)
!541 = !DILocation(line: 223, column: 18, scope: !532)
!542 = !DILocation(line: 223, column: 56, scope: !532)
!543 = !DILocation(line: 223, column: 10, scope: !532)
!544 = !DILocation(line: 224, column: 18, scope: !532)
!545 = !DILocation(line: 224, column: 56, scope: !532)
!546 = !DILocation(line: 224, column: 10, scope: !532)
!547 = !DILocation(line: 225, column: 18, scope: !532)
!548 = !DILocation(line: 225, column: 56, scope: !532)
!549 = !DILocation(line: 225, column: 10, scope: !532)
!550 = !DILocation(line: 226, column: 18, scope: !532)
!551 = !DILocation(line: 226, column: 56, scope: !532)
!552 = !DILocation(line: 226, column: 10, scope: !532)
!553 = !DILocation(line: 228, column: 18, scope: !532)
!554 = !DILocation(line: 228, column: 64, scope: !532)
!555 = !DILocation(line: 228, column: 10, scope: !532)
!556 = !DILocation(line: 229, column: 7, scope: !557)
!557 = distinct !DILexicalBlock(scope: !532, file: !1, line: 229, column: 7)
!558 = !DILocation(line: 229, column: 7, scope: !532)
!559 = !DILocation(line: 230, column: 20, scope: !560)
!560 = distinct !DILexicalBlock(scope: !557, file: !1, line: 229, column: 29)
!561 = !DILocation(line: 230, column: 66, scope: !560)
!562 = !DILocation(line: 230, column: 12, scope: !560)
!563 = !DILocation(line: 231, column: 20, scope: !560)
!564 = !DILocation(line: 231, column: 58, scope: !560)
!565 = !DILocation(line: 231, column: 12, scope: !560)
!566 = !DILocation(line: 232, column: 3, scope: !560)
!567 = !DILocation(line: 234, column: 15, scope: !568)
!568 = distinct !DILexicalBlock(scope: !532, file: !1, line: 234, column: 15)
!569 = !DILocation(line: 234, column: 36, scope: !568)
!570 = !DILocation(line: 234, column: 15, scope: !532)
!571 = !DILocation(line: 235, column: 20, scope: !572)
!572 = distinct !DILexicalBlock(scope: !568, file: !1, line: 234, column: 42)
!573 = !DILocation(line: 235, column: 58, scope: !572)
!574 = !DILocation(line: 235, column: 12, scope: !572)
!575 = !DILocation(line: 236, column: 20, scope: !572)
!576 = !DILocation(line: 236, column: 58, scope: !572)
!577 = !DILocation(line: 236, column: 12, scope: !572)
!578 = !DILocation(line: 237, column: 3, scope: !572)
!579 = !DILocation(line: 239, column: 18, scope: !532)
!580 = !DILocation(line: 239, column: 56, scope: !532)
!581 = !DILocation(line: 239, column: 10, scope: !532)
!582 = !DILocation(line: 240, column: 18, scope: !532)
!583 = !DILocation(line: 240, column: 56, scope: !532)
!584 = !DILocation(line: 240, column: 10, scope: !532)
!585 = !DILocation(line: 242, column: 18, scope: !532)
!586 = !DILocation(line: 242, column: 56, scope: !532)
!587 = !DILocation(line: 242, column: 10, scope: !532)
!588 = !DILocation(line: 243, column: 18, scope: !532)
!589 = !DILocation(line: 243, column: 56, scope: !532)
!590 = !DILocation(line: 243, column: 10, scope: !532)
!591 = !DILocation(line: 245, column: 18, scope: !532)
!592 = !DILocation(line: 245, column: 56, scope: !532)
!593 = !DILocation(line: 245, column: 10, scope: !532)
!594 = !DILocation(line: 246, column: 18, scope: !532)
!595 = !DILocation(line: 246, column: 56, scope: !532)
!596 = !DILocation(line: 246, column: 10, scope: !532)
!597 = !DILocation(line: 248, column: 18, scope: !532)
!598 = !DILocation(line: 248, column: 56, scope: !532)
!599 = !DILocation(line: 248, column: 10, scope: !532)
!600 = !DILocation(line: 249, column: 18, scope: !532)
!601 = !DILocation(line: 249, column: 56, scope: !532)
!602 = !DILocation(line: 249, column: 10, scope: !532)
!603 = !DILocation(line: 250, column: 18, scope: !532)
!604 = !DILocation(line: 250, column: 56, scope: !532)
!605 = !DILocation(line: 250, column: 10, scope: !532)
!606 = !DILocation(line: 251, column: 18, scope: !532)
!607 = !DILocation(line: 251, column: 56, scope: !532)
!608 = !DILocation(line: 251, column: 10, scope: !532)
!609 = !DILocation(line: 252, column: 10, scope: !532)
!610 = !DILocation(line: 252, column: 3, scope: !532)
!611 = !DILocation(line: 253, column: 10, scope: !532)
!612 = !DILocation(line: 255, column: 18, scope: !532)
!613 = !DILocation(line: 256, column: 15, scope: !532)
!614 = !DILocation(line: 257, column: 15, scope: !532)
!615 = !DILocation(line: 258, column: 15, scope: !532)
!616 = !DILocation(line: 259, column: 15, scope: !532)
!617 = !DILocation(line: 260, column: 15, scope: !532)
!618 = !DILocation(line: 261, column: 15, scope: !532)
!619 = !DILocation(line: 255, column: 10, scope: !532)
!620 = !DILocation(line: 263, column: 18, scope: !532)
!621 = !DILocation(line: 264, column: 15, scope: !532)
!622 = !DILocation(line: 265, column: 15, scope: !532)
!623 = !DILocation(line: 266, column: 15, scope: !532)
!624 = !DILocation(line: 263, column: 10, scope: !532)
!625 = !DILocation(line: 268, column: 18, scope: !532)
!626 = !DILocation(line: 269, column: 15, scope: !532)
!627 = !DILocation(line: 270, column: 15, scope: !532)
!628 = !DILocation(line: 268, column: 10, scope: !532)
!629 = !DILocation(line: 272, column: 18, scope: !532)
!630 = !DILocation(line: 273, column: 15, scope: !532)
!631 = !DILocation(line: 274, column: 15, scope: !532)
!632 = !DILocation(line: 272, column: 10, scope: !532)
!633 = !DILocation(line: 276, column: 18, scope: !532)
!634 = !DILocation(line: 277, column: 15, scope: !532)
!635 = !DILocation(line: 278, column: 15, scope: !532)
!636 = !DILocation(line: 276, column: 10, scope: !532)
!637 = !DILocation(line: 280, column: 18, scope: !532)
!638 = !DILocation(line: 281, column: 15, scope: !532)
!639 = !DILocation(line: 282, column: 15, scope: !532)
!640 = !DILocation(line: 280, column: 10, scope: !532)
!641 = !DILocation(line: 284, column: 18, scope: !532)
!642 = !DILocation(line: 285, column: 15, scope: !532)
!643 = !DILocation(line: 286, column: 15, scope: !532)
!644 = !DILocation(line: 287, column: 15, scope: !532)
!645 = !DILocation(line: 288, column: 15, scope: !532)
!646 = !DILocation(line: 284, column: 10, scope: !532)
!647 = !DILocation(line: 290, column: 18, scope: !532)
!648 = !DILocation(line: 290, column: 10, scope: !532)
!649 = !DILocation(line: 291, column: 10, scope: !532)
!650 = !DILocation(line: 293, column: 11, scope: !532)
!651 = !DILocation(line: 293, column: 3, scope: !532)
!652 = !DILocation(line: 294, column: 18, scope: !532)
!653 = !DILocation(line: 294, column: 56, scope: !532)
!654 = !DILocation(line: 294, column: 10, scope: !532)
!655 = !DILocation(line: 295, column: 18, scope: !532)
!656 = !DILocation(line: 295, column: 56, scope: !532)
!657 = !DILocation(line: 295, column: 10, scope: !532)
!658 = !DILocation(line: 296, column: 18, scope: !532)
!659 = !DILocation(line: 296, column: 56, scope: !532)
!660 = !DILocation(line: 296, column: 10, scope: !532)
!661 = !DILocation(line: 297, column: 18, scope: !532)
!662 = !DILocation(line: 297, column: 56, scope: !532)
!663 = !DILocation(line: 297, column: 10, scope: !532)
!664 = !DILocation(line: 298, column: 18, scope: !532)
!665 = !DILocation(line: 298, column: 56, scope: !532)
!666 = !DILocation(line: 298, column: 10, scope: !532)
!667 = !DILocation(line: 299, column: 18, scope: !532)
!668 = !DILocation(line: 299, column: 56, scope: !532)
!669 = !DILocation(line: 299, column: 10, scope: !532)
!670 = !DILocation(line: 301, column: 18, scope: !532)
!671 = !DILocation(line: 301, column: 64, scope: !532)
!672 = !DILocation(line: 301, column: 10, scope: !532)
!673 = !DILocation(line: 302, column: 7, scope: !674)
!674 = distinct !DILexicalBlock(scope: !532, file: !1, line: 302, column: 7)
!675 = !DILocation(line: 302, column: 7, scope: !532)
!676 = !DILocation(line: 303, column: 20, scope: !677)
!677 = distinct !DILexicalBlock(scope: !674, file: !1, line: 302, column: 29)
!678 = !DILocation(line: 303, column: 66, scope: !677)
!679 = !DILocation(line: 303, column: 12, scope: !677)
!680 = !DILocation(line: 304, column: 20, scope: !677)
!681 = !DILocation(line: 304, column: 58, scope: !677)
!682 = !DILocation(line: 304, column: 12, scope: !677)
!683 = !DILocation(line: 305, column: 3, scope: !677)
!684 = !DILocation(line: 307, column: 15, scope: !685)
!685 = distinct !DILexicalBlock(scope: !532, file: !1, line: 307, column: 15)
!686 = !DILocation(line: 307, column: 36, scope: !685)
!687 = !DILocation(line: 307, column: 15, scope: !532)
!688 = !DILocation(line: 308, column: 20, scope: !689)
!689 = distinct !DILexicalBlock(scope: !685, file: !1, line: 307, column: 42)
!690 = !DILocation(line: 308, column: 58, scope: !689)
!691 = !DILocation(line: 308, column: 12, scope: !689)
!692 = !DILocation(line: 309, column: 20, scope: !689)
!693 = !DILocation(line: 309, column: 58, scope: !689)
!694 = !DILocation(line: 309, column: 12, scope: !689)
!695 = !DILocation(line: 310, column: 3, scope: !689)
!696 = !DILocation(line: 311, column: 10, scope: !532)
!697 = !DILocation(line: 313, column: 18, scope: !532)
!698 = !DILocation(line: 314, column: 15, scope: !532)
!699 = !DILocation(line: 315, column: 15, scope: !532)
!700 = !DILocation(line: 316, column: 15, scope: !532)
!701 = !DILocation(line: 317, column: 15, scope: !532)
!702 = !DILocation(line: 318, column: 15, scope: !532)
!703 = !DILocation(line: 319, column: 15, scope: !532)
!704 = !DILocation(line: 313, column: 10, scope: !532)
!705 = !DILocation(line: 321, column: 18, scope: !532)
!706 = !DILocation(line: 322, column: 15, scope: !532)
!707 = !DILocation(line: 323, column: 15, scope: !532)
!708 = !DILocation(line: 324, column: 15, scope: !532)
!709 = !DILocation(line: 321, column: 10, scope: !532)
!710 = !DILocation(line: 326, column: 18, scope: !532)
!711 = !DILocation(line: 327, column: 15, scope: !532)
!712 = !DILocation(line: 328, column: 15, scope: !532)
!713 = !DILocation(line: 326, column: 10, scope: !532)
!714 = !DILocation(line: 330, column: 18, scope: !532)
!715 = !DILocation(line: 330, column: 10, scope: !532)
!716 = !DILocation(line: 331, column: 10, scope: !532)
!717 = !DILocation(line: 333, column: 10, scope: !532)
!718 = !DILocation(line: 334, column: 10, scope: !532)
!719 = !DILocation(line: 336, column: 1, scope: !381)
