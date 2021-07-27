; ModuleID = '/home/lukas/Schreibtisch/dp_no_dr/simple_no_dr.c'
source_filename = "/home/lukas/Schreibtisch/dp_no_dr/simple_no_dr.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [13 x i8] c"cur_idx.addr\00", align 1
@.str.1 = private unnamed_addr constant [11 x i8] c"p_arr.addr\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.3 = private unnamed_addr constant [18 x i8] c"p_read_value.addr\00", align 1
@.str.4 = private unnamed_addr constant [9 x i8] c"i_0.addr\00", align 1
@.str.5 = private unnamed_addr constant [7 x i8] c"t.addr\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str.7 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.9 = private unnamed_addr constant [4 x i8] c"i_0\00", align 1
@.str.10 = private unnamed_addr constant [4 x i8] c"arr\00", align 1
@.str.11 = private unnamed_addr constant [2 x i8] c"z\00", align 1

; Function Attrs: noinline optnone uwtable
define dso_local i32 @_Z21recursive_count_arrayPii(i32* %p_arr, i32 %cur_idx) #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16389, i32 0)
  %retval = alloca i32, align 4
  %p_arr.addr = alloca i32*, align 8
  %cur_idx.addr = alloca i32, align 4
  store i32* %p_arr, i32** %p_arr.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %p_arr.addr, metadata !13, metadata !DIExpression()), !dbg !14
  store i32 %cur_idx, i32* %cur_idx.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %cur_idx.addr, metadata !15, metadata !DIExpression()), !dbg !16
  %0 = ptrtoint i32* %cur_idx.addr to i64
  call void @__dp_read(i32 16390, i64 %0, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i32 0, i32 0))
  %1 = load i32, i32* %cur_idx.addr, align 4, !dbg !17
  %cmp = icmp sge i32 %1, 1, !dbg !19
  br i1 %cmp, label %if.then, label %if.end, !dbg !20

if.then:                                          ; preds = %entry
  %2 = ptrtoint i32** %p_arr.addr to i64
  call void @__dp_read(i32 16391, i64 %2, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.1, i32 0, i32 0))
  %3 = load i32*, i32** %p_arr.addr, align 8, !dbg !21
  %add.ptr = getelementptr inbounds i32, i32* %3, i64 0, !dbg !23
  %4 = ptrtoint i32* %add.ptr to i64
  call void @__dp_read(i32 16391, i64 %4, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.1, i32 0, i32 0))
  %5 = load i32, i32* %add.ptr, align 4, !dbg !24
  %6 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16391, i64 %6, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  store i32 %5, i32* %retval, align 4, !dbg !25
  br label %return, !dbg !25

if.end:                                           ; preds = %entry
  %7 = ptrtoint i32** %p_arr.addr to i64
  call void @__dp_read(i32 16393, i64 %7, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.1, i32 0, i32 0))
  %8 = load i32*, i32** %p_arr.addr, align 8, !dbg !26
  %9 = ptrtoint i32* %cur_idx.addr to i64
  call void @__dp_read(i32 16393, i64 %9, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i32 0, i32 0))
  %10 = load i32, i32* %cur_idx.addr, align 4, !dbg !27
  %sub = sub nsw i32 %10, 1, !dbg !28
  call void @__dp_call(i32 16393), !dbg !29
  %call = call i32 @_Z21recursive_count_arrayPii(i32* %8, i32 %sub), !dbg !29
  %11 = ptrtoint i32** %p_arr.addr to i64
  call void @__dp_read(i32 16394, i64 %11, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.1, i32 0, i32 0))
  %12 = load i32*, i32** %p_arr.addr, align 8, !dbg !30
  %13 = ptrtoint i32* %cur_idx.addr to i64
  call void @__dp_read(i32 16394, i64 %13, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i32 0, i32 0))
  %14 = load i32, i32* %cur_idx.addr, align 4, !dbg !31
  %idx.ext = sext i32 %14 to i64, !dbg !32
  %add.ptr1 = getelementptr inbounds i32, i32* %12, i64 %idx.ext, !dbg !32
  %15 = ptrtoint i32* %add.ptr1 to i64
  call void @__dp_read(i32 16394, i64 %15, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.1, i32 0, i32 0))
  %16 = load i32, i32* %add.ptr1, align 4, !dbg !33
  %17 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16394, i64 %17, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  store i32 %16, i32* %retval, align 4, !dbg !34
  br label %return, !dbg !34

return:                                           ; preds = %if.end, %if.then
  %18 = ptrtoint i32* %retval to i64
  call void @__dp_read(i32 16395, i64 %18, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  %19 = load i32, i32* %retval, align 4, !dbg !35
  call void @__dp_func_exit(i32 16395, i32 0), !dbg !35
  ret i32 %19, !dbg !35
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @_Z12write_to_arrPiiS_(i32* %p_arr, i32 %i_0, i32* %p_read_value) #2 !dbg !36 {
entry:
  call void @__dp_func_entry(i32 16398, i32 0)
  %p_arr.addr = alloca i32*, align 8
  %i_0.addr = alloca i32, align 4
  %p_read_value.addr = alloca i32*, align 8
  store i32* %p_arr, i32** %p_arr.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %p_arr.addr, metadata !39, metadata !DIExpression()), !dbg !40
  store i32 %i_0, i32* %i_0.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %i_0.addr, metadata !41, metadata !DIExpression()), !dbg !42
  store i32* %p_read_value, i32** %p_read_value.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %p_read_value.addr, metadata !43, metadata !DIExpression()), !dbg !44
  %0 = ptrtoint i32** %p_read_value.addr to i64
  call void @__dp_read(i32 16399, i64 %0, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.3, i32 0, i32 0))
  %1 = load i32*, i32** %p_read_value.addr, align 8, !dbg !45
  %2 = ptrtoint i32* %1 to i64
  call void @__dp_read(i32 16399, i64 %2, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.3, i32 0, i32 0))
  %3 = load i32, i32* %1, align 4, !dbg !46
  %4 = ptrtoint i32* %i_0.addr to i64
  call void @__dp_read(i32 16399, i64 %4, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.4, i32 0, i32 0))
  %5 = load i32, i32* %i_0.addr, align 4, !dbg !47
  %add = add nsw i32 %3, %5, !dbg !48
  %6 = ptrtoint i32** %p_arr.addr to i64
  call void @__dp_read(i32 16399, i64 %6, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.1, i32 0, i32 0))
  %7 = load i32*, i32** %p_arr.addr, align 8, !dbg !49
  %8 = ptrtoint i32* %i_0.addr to i64
  call void @__dp_read(i32 16399, i64 %8, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.4, i32 0, i32 0))
  %9 = load i32, i32* %i_0.addr, align 4, !dbg !50
  %idx.ext = sext i32 %9 to i64, !dbg !51
  %add.ptr = getelementptr inbounds i32, i32* %7, i64 %idx.ext, !dbg !51
  %10 = ptrtoint i32* %add.ptr to i64
  call void @__dp_write(i32 16399, i64 %10, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.1, i32 0, i32 0))
  store i32 %add, i32* %add.ptr, align 4, !dbg !52
  call void @__dp_func_exit(i32 16401, i32 0), !dbg !53
  ret void, !dbg !53
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @_Z17call_write_to_arrPiiS_(i32* %p_arr, i32 %i_0, i32* %p_read_value) #2 !dbg !54 {
entry:
  call void @__dp_func_entry(i32 16403, i32 0)
  %p_arr.addr = alloca i32*, align 8
  %i_0.addr = alloca i32, align 4
  %p_read_value.addr = alloca i32*, align 8
  store i32* %p_arr, i32** %p_arr.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %p_arr.addr, metadata !55, metadata !DIExpression()), !dbg !56
  store i32 %i_0, i32* %i_0.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %i_0.addr, metadata !57, metadata !DIExpression()), !dbg !58
  store i32* %p_read_value, i32** %p_read_value.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %p_read_value.addr, metadata !59, metadata !DIExpression()), !dbg !60
  %0 = ptrtoint i32** %p_arr.addr to i64
  call void @__dp_read(i32 16404, i64 %0, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.1, i32 0, i32 0))
  %1 = load i32*, i32** %p_arr.addr, align 8, !dbg !61
  %2 = ptrtoint i32* %i_0.addr to i64
  call void @__dp_read(i32 16404, i64 %2, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.4, i32 0, i32 0))
  %3 = load i32, i32* %i_0.addr, align 4, !dbg !62
  %4 = ptrtoint i32** %p_read_value.addr to i64
  call void @__dp_read(i32 16404, i64 %4, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.3, i32 0, i32 0))
  %5 = load i32*, i32** %p_read_value.addr, align 8, !dbg !63
  call void @__dp_call(i32 16404), !dbg !64
  call void @_Z12write_to_arrPiiS_(i32* %1, i32 %3, i32* %5), !dbg !64
  call void @__dp_func_exit(i32 16405, i32 0), !dbg !65
  ret void, !dbg !65
}

; Function Attrs: noinline optnone uwtable
define dso_local i32 @_Z17useless_recursioni(i32 %t) #0 !dbg !66 {
entry:
  call void @__dp_func_entry(i32 16407, i32 0)
  %t.addr = alloca i32, align 4
  store i32 %t, i32* %t.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %t.addr, metadata !69, metadata !DIExpression()), !dbg !70
  %0 = ptrtoint i32* %t.addr to i64
  call void @__dp_read(i32 16408, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.5, i32 0, i32 0))
  %1 = load i32, i32* %t.addr, align 4, !dbg !71
  %cmp = icmp sgt i32 %1, 0, !dbg !73
  br i1 %cmp, label %if.then, label %if.end, !dbg !74

if.then:                                          ; preds = %entry
  %2 = ptrtoint i32* %t.addr to i64
  call void @__dp_read(i32 16409, i64 %2, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.5, i32 0, i32 0))
  %3 = load i32, i32* %t.addr, align 4, !dbg !75
  %sub = sub nsw i32 %3, 1, !dbg !77
  call void @__dp_call(i32 16409), !dbg !78
  %call = call i32 @_Z17useless_recursioni(i32 %sub), !dbg !78
  br label %if.end, !dbg !79

if.end:                                           ; preds = %if.then, %entry
  call void @__dp_func_exit(i32 16411, i32 0), !dbg !80
  ret i32 0, !dbg !80
}

; Function Attrs: noinline norecurse optnone uwtable
define dso_local i32 @main() #3 !dbg !81 {
entry:
  call void @__dp_func_entry(i32 16416, i32 1)
  %retval = alloca i32, align 4
  %arr = alloca [10 x i32], align 16
  %x = alloca i32, align 4
  %y = alloca i32, align 4
  %a = alloca i32, align 4
  %i_0 = alloca i32, align 4
  %z = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata [10 x i32]* %arr, metadata !84, metadata !DIExpression()), !dbg !88
  call void @llvm.dbg.declare(metadata i32* %x, metadata !89, metadata !DIExpression()), !dbg !90
  %0 = ptrtoint i32* %x to i64
  call void @__dp_write(i32 16417, i64 %0, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 0, i32* %x, align 4, !dbg !90
  call void @llvm.dbg.declare(metadata i32* %y, metadata !91, metadata !DIExpression()), !dbg !92
  %1 = ptrtoint i32* %y to i64
  call void @__dp_write(i32 16418, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 0, i32* %y, align 4, !dbg !92
  call void @__dp_call(i32 16419), !dbg !93
  %call = call i32 @_Z17useless_recursioni(i32 3), !dbg !93
  %arraydecay = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 0, !dbg !94
  call void @__dp_call(i32 16420), !dbg !95
  %call1 = call i32 @_Z21recursive_count_arrayPii(i32* %arraydecay, i32 2), !dbg !95
  call void @llvm.dbg.declare(metadata i32* %a, metadata !96, metadata !DIExpression()), !dbg !98
  %2 = ptrtoint i32* %a to i64
  call void @__dp_write(i32 16421, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  store i32 0, i32* %a, align 4, !dbg !98
  br label %for.cond, !dbg !99

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16421, i32 0)
  %3 = ptrtoint i32* %a to i64
  call void @__dp_read(i32 16421, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %4 = load i32, i32* %a, align 4, !dbg !100
  %cmp = icmp slt i32 %4, 10, !dbg !102
  br i1 %cmp, label %for.body, label %for.end, !dbg !103

for.body:                                         ; preds = %for.cond
  call void @llvm.dbg.declare(metadata i32* %i_0, metadata !104, metadata !DIExpression()), !dbg !106
  %5 = ptrtoint i32* %a to i64
  call void @__dp_read(i32 16422, i64 %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %6 = load i32, i32* %a, align 4, !dbg !107
  %7 = ptrtoint i32* %i_0 to i64
  call void @__dp_write(i32 16422, i64 %7, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.9, i32 0, i32 0))
  store i32 %6, i32* %i_0, align 4, !dbg !106
  %8 = ptrtoint i32* %a to i64
  call void @__dp_read(i32 16423, i64 %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %9 = load i32, i32* %a, align 4, !dbg !108
  %10 = ptrtoint i32* %i_0 to i64
  call void @__dp_read(i32 16423, i64 %10, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.9, i32 0, i32 0))
  %11 = load i32, i32* %i_0, align 4, !dbg !109
  %add = add nsw i32 %9, %11, !dbg !110
  %12 = ptrtoint i32* %i_0 to i64
  call void @__dp_read(i32 16423, i64 %12, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.9, i32 0, i32 0))
  %13 = load i32, i32* %i_0, align 4, !dbg !111
  %idxprom = sext i32 %13 to i64, !dbg !112
  %arrayidx = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idxprom, !dbg !112
  %14 = ptrtoint i32* %arrayidx to i64
  call void @__dp_write(i32 16423, i64 %14, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.10, i32 0, i32 0))
  store i32 %add, i32* %arrayidx, align 4, !dbg !113
  call void @__dp_call(i32 16424), !dbg !114
  %call2 = call i32 @_Z17useless_recursioni(i32 4), !dbg !114
  %arraydecay3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 0, !dbg !115
  %15 = ptrtoint i32* %i_0 to i64
  call void @__dp_read(i32 16425, i64 %15, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.9, i32 0, i32 0))
  %16 = load i32, i32* %i_0, align 4, !dbg !116
  call void @__dp_call(i32 16425), !dbg !117
  call void @_Z17call_write_to_arrPiiS_(i32* %arraydecay3, i32 %16, i32* %a), !dbg !117
  call void @llvm.dbg.declare(metadata i32* %z, metadata !118, metadata !DIExpression()), !dbg !119
  %17 = ptrtoint i32* %z to i64
  call void @__dp_write(i32 16426, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.11, i32 0, i32 0))
  store i32 0, i32* %z, align 4, !dbg !119
  %18 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16427, i64 %18, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %19 = load i32, i32* %x, align 4, !dbg !120
  %cmp4 = icmp sgt i32 %19, 3, !dbg !122
  br i1 %cmp4, label %if.then, label %if.end, !dbg !123

if.then:                                          ; preds = %for.body
  %20 = ptrtoint i32* %i_0 to i64
  call void @__dp_read(i32 16428, i64 %20, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.9, i32 0, i32 0))
  %21 = load i32, i32* %i_0, align 4, !dbg !124
  %idxprom5 = sext i32 %21 to i64, !dbg !126
  %arrayidx6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idxprom5, !dbg !126
  %22 = ptrtoint i32* %arrayidx6 to i64
  call void @__dp_read(i32 16428, i64 %22, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.10, i32 0, i32 0))
  %23 = load i32, i32* %arrayidx6, align 4, !dbg !126
  %add7 = add nsw i32 %23, 3, !dbg !127
  %24 = ptrtoint i32* %i_0 to i64
  call void @__dp_read(i32 16428, i64 %24, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.9, i32 0, i32 0))
  %25 = load i32, i32* %i_0, align 4, !dbg !128
  %idxprom8 = sext i32 %25 to i64, !dbg !129
  %arrayidx9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idxprom8, !dbg !129
  %26 = ptrtoint i32* %arrayidx9 to i64
  call void @__dp_write(i32 16428, i64 %26, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.10, i32 0, i32 0))
  store i32 %add7, i32* %arrayidx9, align 4, !dbg !130
  br label %if.end, !dbg !131

if.end:                                           ; preds = %if.then, %for.body
  br label %for.inc, !dbg !132

for.inc:                                          ; preds = %if.end
  %27 = ptrtoint i32* %a to i64
  call void @__dp_read(i32 16421, i64 %27, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %28 = load i32, i32* %a, align 4, !dbg !133
  %inc = add nsw i32 %28, 1, !dbg !133
  %29 = ptrtoint i32* %a to i64
  call void @__dp_write(i32 16421, i64 %29, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  store i32 %inc, i32* %a, align 4, !dbg !133
  br label %for.cond, !dbg !134, !llvm.loop !135

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16432, i32 0)
  %30 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16432, i64 %30, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %31 = load i32, i32* %x, align 4, !dbg !137
  %cmp10 = icmp sgt i32 %31, 3, !dbg !139
  br i1 %cmp10, label %if.then11, label %if.else, !dbg !140

if.then11:                                        ; preds = %for.end
  %32 = ptrtoint i32* %y to i64
  call void @__dp_read(i32 16433, i64 %32, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %33 = load i32, i32* %y, align 4, !dbg !141
  %34 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16433, i64 %34, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %35 = load i32, i32* %x, align 4, !dbg !143
  %add12 = add nsw i32 %33, %35, !dbg !144
  %36 = ptrtoint i32* %y to i64
  call void @__dp_write(i32 16433, i64 %36, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 %add12, i32* %y, align 4, !dbg !145
  br label %if.end13, !dbg !146

if.else:                                          ; preds = %for.end
  %37 = ptrtoint i32* %y to i64
  call void @__dp_read(i32 16436, i64 %37, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %38 = load i32, i32* %y, align 4, !dbg !147
  %39 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16436, i64 %39, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %40 = load i32, i32* %x, align 4, !dbg !149
  %sub = sub nsw i32 %38, %40, !dbg !150
  %41 = ptrtoint i32* %y to i64
  call void @__dp_write(i32 16436, i64 %41, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 %sub, i32* %y, align 4, !dbg !151
  br label %if.end13

if.end13:                                         ; preds = %if.else, %if.then11
  %42 = ptrtoint i32* %retval to i64
  call void @__dp_read(i32 16439, i64 %42, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  %43 = load i32, i32* %retval, align 4, !dbg !152
  call void @__dp_finalize(i32 16439), !dbg !152
  ret i32 %43, !dbg !152
}

declare void @__dp_init(i32, i32, i32)

declare void @__dp_finalize(i32)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_write(i32, i64, i8*)

declare void @__dp_call(i32)

declare void @__dp_func_entry(i32, i32)

declare void @__dp_func_exit(i32, i32)

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_loop_exit(i32, i32)

attributes #0 = { noinline optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noinline norecurse optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "clang version 8.0.1 (tags/RELEASE_801/final)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, nameTableKind: None)
!1 = !DIFile(filename: "/home/lukas/Schreibtisch/dp_no_dr/simple_no_dr.c", directory: "/home/lukas/Schreibtisch/dp_no_dr/discopop-tmp")
!2 = !{}
!3 = !{i32 2, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"clang version 8.0.1 (tags/RELEASE_801/final)"}
!7 = distinct !DISubprogram(name: "recursive_count_array", linkageName: "_Z21recursive_count_arrayPii", scope: !8, file: !8, line: 5, type: !9, scopeLine: 5, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DIFile(filename: "simple_no_dr.c", directory: "/home/lukas/Schreibtisch/dp_no_dr")
!9 = !DISubroutineType(types: !10)
!10 = !{!11, !12, !11}
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 64)
!13 = !DILocalVariable(name: "p_arr", arg: 1, scope: !7, file: !8, line: 5, type: !12)
!14 = !DILocation(line: 5, column: 32, scope: !7)
!15 = !DILocalVariable(name: "cur_idx", arg: 2, scope: !7, file: !8, line: 5, type: !11)
!16 = !DILocation(line: 5, column: 43, scope: !7)
!17 = !DILocation(line: 6, column: 9, scope: !18)
!18 = distinct !DILexicalBlock(scope: !7, file: !8, line: 6, column: 9)
!19 = !DILocation(line: 6, column: 17, scope: !18)
!20 = !DILocation(line: 6, column: 9, scope: !7)
!21 = !DILocation(line: 7, column: 18, scope: !22)
!22 = distinct !DILexicalBlock(scope: !18, file: !8, line: 6, column: 22)
!23 = !DILocation(line: 7, column: 24, scope: !22)
!24 = !DILocation(line: 7, column: 16, scope: !22)
!25 = !DILocation(line: 7, column: 9, scope: !22)
!26 = !DILocation(line: 9, column: 27, scope: !7)
!27 = !DILocation(line: 9, column: 34, scope: !7)
!28 = !DILocation(line: 9, column: 42, scope: !7)
!29 = !DILocation(line: 9, column: 5, scope: !7)
!30 = !DILocation(line: 10, column: 14, scope: !7)
!31 = !DILocation(line: 10, column: 22, scope: !7)
!32 = !DILocation(line: 10, column: 20, scope: !7)
!33 = !DILocation(line: 10, column: 12, scope: !7)
!34 = !DILocation(line: 10, column: 5, scope: !7)
!35 = !DILocation(line: 11, column: 1, scope: !7)
!36 = distinct !DISubprogram(name: "write_to_arr", linkageName: "_Z12write_to_arrPiiS_", scope: !8, file: !8, line: 14, type: !37, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!37 = !DISubroutineType(types: !38)
!38 = !{null, !12, !11, !12}
!39 = !DILocalVariable(name: "p_arr", arg: 1, scope: !36, file: !8, line: 14, type: !12)
!40 = !DILocation(line: 14, column: 24, scope: !36)
!41 = !DILocalVariable(name: "i_0", arg: 2, scope: !36, file: !8, line: 14, type: !11)
!42 = !DILocation(line: 14, column: 35, scope: !36)
!43 = !DILocalVariable(name: "p_read_value", arg: 3, scope: !36, file: !8, line: 14, type: !12)
!44 = !DILocation(line: 14, column: 45, scope: !36)
!45 = !DILocation(line: 15, column: 23, scope: !36)
!46 = !DILocation(line: 15, column: 22, scope: !36)
!47 = !DILocation(line: 15, column: 38, scope: !36)
!48 = !DILocation(line: 15, column: 36, scope: !36)
!49 = !DILocation(line: 15, column: 7, scope: !36)
!50 = !DILocation(line: 15, column: 15, scope: !36)
!51 = !DILocation(line: 15, column: 13, scope: !36)
!52 = !DILocation(line: 15, column: 20, scope: !36)
!53 = !DILocation(line: 17, column: 1, scope: !36)
!54 = distinct !DISubprogram(name: "call_write_to_arr", linkageName: "_Z17call_write_to_arrPiiS_", scope: !8, file: !8, line: 19, type: !37, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!55 = !DILocalVariable(name: "p_arr", arg: 1, scope: !54, file: !8, line: 19, type: !12)
!56 = !DILocation(line: 19, column: 29, scope: !54)
!57 = !DILocalVariable(name: "i_0", arg: 2, scope: !54, file: !8, line: 19, type: !11)
!58 = !DILocation(line: 19, column: 40, scope: !54)
!59 = !DILocalVariable(name: "p_read_value", arg: 3, scope: !54, file: !8, line: 19, type: !12)
!60 = !DILocation(line: 19, column: 50, scope: !54)
!61 = !DILocation(line: 20, column: 18, scope: !54)
!62 = !DILocation(line: 20, column: 25, scope: !54)
!63 = !DILocation(line: 20, column: 30, scope: !54)
!64 = !DILocation(line: 20, column: 5, scope: !54)
!65 = !DILocation(line: 21, column: 1, scope: !54)
!66 = distinct !DISubprogram(name: "useless_recursion", linkageName: "_Z17useless_recursioni", scope: !8, file: !8, line: 23, type: !67, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!67 = !DISubroutineType(types: !68)
!68 = !{!11, !11}
!69 = !DILocalVariable(name: "t", arg: 1, scope: !66, file: !8, line: 23, type: !11)
!70 = !DILocation(line: 23, column: 27, scope: !66)
!71 = !DILocation(line: 24, column: 8, scope: !72)
!72 = distinct !DILexicalBlock(scope: !66, file: !8, line: 24, column: 8)
!73 = !DILocation(line: 24, column: 10, scope: !72)
!74 = !DILocation(line: 24, column: 8, scope: !66)
!75 = !DILocation(line: 25, column: 27, scope: !76)
!76 = distinct !DILexicalBlock(scope: !72, file: !8, line: 24, column: 14)
!77 = !DILocation(line: 25, column: 28, scope: !76)
!78 = !DILocation(line: 25, column: 9, scope: !76)
!79 = !DILocation(line: 26, column: 5, scope: !76)
!80 = !DILocation(line: 27, column: 5, scope: !66)
!81 = distinct !DISubprogram(name: "main", scope: !8, file: !8, line: 31, type: !82, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!82 = !DISubroutineType(types: !83)
!83 = !{!11}
!84 = !DILocalVariable(name: "arr", scope: !81, file: !8, line: 32, type: !85)
!85 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 320, elements: !86)
!86 = !{!87}
!87 = !DISubrange(count: 10)
!88 = !DILocation(line: 32, column: 9, scope: !81)
!89 = !DILocalVariable(name: "x", scope: !81, file: !8, line: 33, type: !11)
!90 = !DILocation(line: 33, column: 9, scope: !81)
!91 = !DILocalVariable(name: "y", scope: !81, file: !8, line: 34, type: !11)
!92 = !DILocation(line: 34, column: 9, scope: !81)
!93 = !DILocation(line: 35, column: 5, scope: !81)
!94 = !DILocation(line: 36, column: 27, scope: !81)
!95 = !DILocation(line: 36, column: 5, scope: !81)
!96 = !DILocalVariable(name: "a", scope: !97, file: !8, line: 37, type: !11)
!97 = distinct !DILexicalBlock(scope: !81, file: !8, line: 37, column: 5)
!98 = !DILocation(line: 37, column: 13, scope: !97)
!99 = !DILocation(line: 37, column: 9, scope: !97)
!100 = !DILocation(line: 37, column: 18, scope: !101)
!101 = distinct !DILexicalBlock(scope: !97, file: !8, line: 37, column: 5)
!102 = !DILocation(line: 37, column: 20, scope: !101)
!103 = !DILocation(line: 37, column: 5, scope: !97)
!104 = !DILocalVariable(name: "i_0", scope: !105, file: !8, line: 38, type: !11)
!105 = distinct !DILexicalBlock(scope: !101, file: !8, line: 37, column: 30)
!106 = !DILocation(line: 38, column: 13, scope: !105)
!107 = !DILocation(line: 38, column: 17, scope: !105)
!108 = !DILocation(line: 39, column: 20, scope: !105)
!109 = !DILocation(line: 39, column: 24, scope: !105)
!110 = !DILocation(line: 39, column: 22, scope: !105)
!111 = !DILocation(line: 39, column: 13, scope: !105)
!112 = !DILocation(line: 39, column: 9, scope: !105)
!113 = !DILocation(line: 39, column: 18, scope: !105)
!114 = !DILocation(line: 40, column: 9, scope: !105)
!115 = !DILocation(line: 41, column: 27, scope: !105)
!116 = !DILocation(line: 41, column: 32, scope: !105)
!117 = !DILocation(line: 41, column: 9, scope: !105)
!118 = !DILocalVariable(name: "z", scope: !105, file: !8, line: 42, type: !11)
!119 = !DILocation(line: 42, column: 13, scope: !105)
!120 = !DILocation(line: 43, column: 12, scope: !121)
!121 = distinct !DILexicalBlock(scope: !105, file: !8, line: 43, column: 12)
!122 = !DILocation(line: 43, column: 14, scope: !121)
!123 = !DILocation(line: 43, column: 12, scope: !105)
!124 = !DILocation(line: 44, column: 28, scope: !125)
!125 = distinct !DILexicalBlock(scope: !121, file: !8, line: 43, column: 18)
!126 = !DILocation(line: 44, column: 24, scope: !125)
!127 = !DILocation(line: 44, column: 33, scope: !125)
!128 = !DILocation(line: 44, column: 17, scope: !125)
!129 = !DILocation(line: 44, column: 13, scope: !125)
!130 = !DILocation(line: 44, column: 22, scope: !125)
!131 = !DILocation(line: 45, column: 9, scope: !125)
!132 = !DILocation(line: 46, column: 5, scope: !105)
!133 = !DILocation(line: 37, column: 27, scope: !101)
!134 = !DILocation(line: 37, column: 5, scope: !101)
!135 = distinct !{!135, !103, !136}
!136 = !DILocation(line: 46, column: 5, scope: !97)
!137 = !DILocation(line: 48, column: 8, scope: !138)
!138 = distinct !DILexicalBlock(scope: !81, file: !8, line: 48, column: 8)
!139 = !DILocation(line: 48, column: 10, scope: !138)
!140 = !DILocation(line: 48, column: 8, scope: !81)
!141 = !DILocation(line: 49, column: 13, scope: !142)
!142 = distinct !DILexicalBlock(scope: !138, file: !8, line: 48, column: 14)
!143 = !DILocation(line: 49, column: 17, scope: !142)
!144 = !DILocation(line: 49, column: 15, scope: !142)
!145 = !DILocation(line: 49, column: 11, scope: !142)
!146 = !DILocation(line: 50, column: 5, scope: !142)
!147 = !DILocation(line: 52, column: 13, scope: !148)
!148 = distinct !DILexicalBlock(scope: !138, file: !8, line: 51, column: 9)
!149 = !DILocation(line: 52, column: 17, scope: !148)
!150 = !DILocation(line: 52, column: 15, scope: !148)
!151 = !DILocation(line: 52, column: 11, scope: !148)
!152 = !DILocation(line: 55, column: 1, scope: !81)
