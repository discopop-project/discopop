; ModuleID = '/home/lukas/Schreibtisch/dp_no_dr/simple_no_dr.c'
source_filename = "/home/lukas/Schreibtisch/dp_no_dr/simple_no_dr.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [18 x i8] c"p_read_value.addr\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"i_0.addr\00", align 1
@.str.2 = private unnamed_addr constant [11 x i8] c"p_arr.addr\00", align 1
@.str.3 = private unnamed_addr constant [7 x i8] c"t.addr\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.7 = private unnamed_addr constant [4 x i8] c"i_0\00", align 1
@.str.8 = private unnamed_addr constant [4 x i8] c"arr\00", align 1
@.str.9 = private unnamed_addr constant [2 x i8] c"z\00", align 1
@.str.10 = private unnamed_addr constant [7 x i8] c"retval\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @_Z12write_to_arrPiiS_(i32* %p_arr, i32 %i_0, i32* %p_read_value) #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16391, i32 0)
  %p_arr.addr = alloca i32*, align 8
  %i_0.addr = alloca i32, align 4
  %p_read_value.addr = alloca i32*, align 8
  store i32* %p_arr, i32** %p_arr.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %p_arr.addr, metadata !13, metadata !DIExpression()), !dbg !14
  store i32 %i_0, i32* %i_0.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %i_0.addr, metadata !15, metadata !DIExpression()), !dbg !16
  store i32* %p_read_value, i32** %p_read_value.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %p_read_value.addr, metadata !17, metadata !DIExpression()), !dbg !18
  %0 = ptrtoint i32** %p_read_value.addr to i64
  call void @__dp_read(i32 16392, i64 %0, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str, i32 0, i32 0))
  %1 = load i32*, i32** %p_read_value.addr, align 8, !dbg !19
  %2 = ptrtoint i32* %1 to i64
  call void @__dp_read(i32 16392, i64 %2, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str, i32 0, i32 0))
  %3 = load i32, i32* %1, align 4, !dbg !20
  %4 = ptrtoint i32* %i_0.addr to i64
  call void @__dp_read(i32 16392, i64 %4, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i32 0, i32 0))
  %5 = load i32, i32* %i_0.addr, align 4, !dbg !21
  %add = add nsw i32 %3, %5, !dbg !22
  %6 = ptrtoint i32** %p_arr.addr to i64
  call void @__dp_read(i32 16392, i64 %6, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.2, i32 0, i32 0))
  %7 = load i32*, i32** %p_arr.addr, align 8, !dbg !23
  %8 = ptrtoint i32* %i_0.addr to i64
  call void @__dp_read(i32 16392, i64 %8, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i32 0, i32 0))
  %9 = load i32, i32* %i_0.addr, align 4, !dbg !24
  %idx.ext = sext i32 %9 to i64, !dbg !25
  %add.ptr = getelementptr inbounds i32, i32* %7, i64 %idx.ext, !dbg !25
  %10 = ptrtoint i32* %add.ptr to i64
  call void @__dp_write(i32 16392, i64 %10, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.2, i32 0, i32 0))
  store i32 %add, i32* %add.ptr, align 4, !dbg !26
  call void @__dp_func_exit(i32 16394, i32 0), !dbg !27
  ret void, !dbg !27
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @_Z17call_write_to_arrPiiS_(i32* %p_arr, i32 %i_0, i32* %p_read_value) #0 !dbg !28 {
entry:
  call void @__dp_func_entry(i32 16396, i32 0)
  %p_arr.addr = alloca i32*, align 8
  %i_0.addr = alloca i32, align 4
  %p_read_value.addr = alloca i32*, align 8
  store i32* %p_arr, i32** %p_arr.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %p_arr.addr, metadata !29, metadata !DIExpression()), !dbg !30
  store i32 %i_0, i32* %i_0.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %i_0.addr, metadata !31, metadata !DIExpression()), !dbg !32
  store i32* %p_read_value, i32** %p_read_value.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %p_read_value.addr, metadata !33, metadata !DIExpression()), !dbg !34
  %0 = ptrtoint i32** %p_arr.addr to i64
  call void @__dp_read(i32 16397, i64 %0, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.2, i32 0, i32 0))
  %1 = load i32*, i32** %p_arr.addr, align 8, !dbg !35
  %2 = ptrtoint i32* %i_0.addr to i64
  call void @__dp_read(i32 16397, i64 %2, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i32 0, i32 0))
  %3 = load i32, i32* %i_0.addr, align 4, !dbg !36
  %4 = ptrtoint i32** %p_read_value.addr to i64
  call void @__dp_read(i32 16397, i64 %4, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str, i32 0, i32 0))
  %5 = load i32*, i32** %p_read_value.addr, align 8, !dbg !37
  call void @__dp_call(i32 16397), !dbg !38
  call void @_Z12write_to_arrPiiS_(i32* %1, i32 %3, i32* %5), !dbg !38
  call void @__dp_func_exit(i32 16398, i32 0), !dbg !39
  ret void, !dbg !39
}

; Function Attrs: noinline optnone uwtable
define dso_local i32 @_Z17useless_recursioni(i32 %t) #2 !dbg !40 {
entry:
  call void @__dp_func_entry(i32 16400, i32 0)
  %t.addr = alloca i32, align 4
  store i32 %t, i32* %t.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %t.addr, metadata !43, metadata !DIExpression()), !dbg !44
  %0 = ptrtoint i32* %t.addr to i64
  call void @__dp_read(i32 16401, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0))
  %1 = load i32, i32* %t.addr, align 4, !dbg !45
  %cmp = icmp sgt i32 %1, 0, !dbg !47
  br i1 %cmp, label %if.then, label %if.end, !dbg !48

if.then:                                          ; preds = %entry
  %2 = ptrtoint i32* %t.addr to i64
  call void @__dp_read(i32 16402, i64 %2, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0))
  %3 = load i32, i32* %t.addr, align 4, !dbg !49
  %sub = sub nsw i32 %3, 1, !dbg !51
  call void @__dp_call(i32 16402), !dbg !52
  %call = call i32 @_Z17useless_recursioni(i32 %sub), !dbg !52
  br label %if.end, !dbg !53

if.end:                                           ; preds = %if.then, %entry
  call void @__dp_func_exit(i32 16404, i32 0), !dbg !54
  ret i32 0, !dbg !54
}

; Function Attrs: noinline norecurse optnone uwtable
define dso_local i32 @main() #3 !dbg !55 {
entry:
  call void @__dp_func_entry(i32 16408, i32 1)
  %retval = alloca i32, align 4
  %arr = alloca [10 x i32], align 16
  %x = alloca i32, align 4
  %y = alloca i32, align 4
  %a = alloca i32, align 4
  %i_0 = alloca i32, align 4
  %z = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata [10 x i32]* %arr, metadata !58, metadata !DIExpression()), !dbg !62
  call void @llvm.dbg.declare(metadata i32* %x, metadata !63, metadata !DIExpression()), !dbg !64
  %0 = ptrtoint i32* %x to i64
  call void @__dp_write(i32 16409, i64 %0, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 0, i32* %x, align 4, !dbg !64
  call void @llvm.dbg.declare(metadata i32* %y, metadata !65, metadata !DIExpression()), !dbg !66
  %1 = ptrtoint i32* %y to i64
  call void @__dp_write(i32 16410, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 0, i32* %y, align 4, !dbg !66
  call void @__dp_call(i32 16411), !dbg !67
  %call = call i32 @_Z17useless_recursioni(i32 3), !dbg !67
  call void @llvm.dbg.declare(metadata i32* %a, metadata !68, metadata !DIExpression()), !dbg !70
  %2 = ptrtoint i32* %a to i64
  call void @__dp_write(i32 16412, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 0, i32* %a, align 4, !dbg !70
  br label %for.cond, !dbg !71

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16412, i32 0)
  %3 = ptrtoint i32* %a to i64
  call void @__dp_read(i32 16412, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %4 = load i32, i32* %a, align 4, !dbg !72
  %cmp = icmp slt i32 %4, 10, !dbg !74
  br i1 %cmp, label %for.body, label %for.end, !dbg !75

for.body:                                         ; preds = %for.cond
  call void @llvm.dbg.declare(metadata i32* %i_0, metadata !76, metadata !DIExpression()), !dbg !78
  %5 = ptrtoint i32* %a to i64
  call void @__dp_read(i32 16413, i64 %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %6 = load i32, i32* %a, align 4, !dbg !79
  %7 = ptrtoint i32* %i_0 to i64
  call void @__dp_write(i32 16413, i64 %7, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  store i32 %6, i32* %i_0, align 4, !dbg !78
  %8 = ptrtoint i32* %a to i64
  call void @__dp_read(i32 16414, i64 %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %9 = load i32, i32* %a, align 4, !dbg !80
  %10 = ptrtoint i32* %i_0 to i64
  call void @__dp_read(i32 16414, i64 %10, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  %11 = load i32, i32* %i_0, align 4, !dbg !81
  %add = add nsw i32 %9, %11, !dbg !82
  %12 = ptrtoint i32* %i_0 to i64
  call void @__dp_read(i32 16414, i64 %12, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  %13 = load i32, i32* %i_0, align 4, !dbg !83
  %idxprom = sext i32 %13 to i64, !dbg !84
  %arrayidx = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idxprom, !dbg !84
  %14 = ptrtoint i32* %arrayidx to i64
  call void @__dp_write(i32 16414, i64 %14, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i32 0, i32 0))
  store i32 %add, i32* %arrayidx, align 4, !dbg !85
  %arraydecay = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 0, !dbg !86
  %15 = ptrtoint i32* %i_0 to i64
  call void @__dp_read(i32 16415, i64 %15, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  %16 = load i32, i32* %i_0, align 4, !dbg !87
  call void @__dp_call(i32 16415), !dbg !88
  call void @_Z17call_write_to_arrPiiS_(i32* %arraydecay, i32 %16, i32* %a), !dbg !88
  call void @llvm.dbg.declare(metadata i32* %z, metadata !89, metadata !DIExpression()), !dbg !90
  %17 = ptrtoint i32* %z to i64
  call void @__dp_write(i32 16416, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  store i32 0, i32* %z, align 4, !dbg !90
  %18 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16417, i64 %18, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %19 = load i32, i32* %x, align 4, !dbg !91
  %cmp1 = icmp sgt i32 %19, 3, !dbg !93
  br i1 %cmp1, label %if.then, label %if.end, !dbg !94

if.then:                                          ; preds = %for.body
  %20 = ptrtoint i32* %i_0 to i64
  call void @__dp_read(i32 16418, i64 %20, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  %21 = load i32, i32* %i_0, align 4, !dbg !95
  %idxprom2 = sext i32 %21 to i64, !dbg !97
  %arrayidx3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idxprom2, !dbg !97
  %22 = ptrtoint i32* %arrayidx3 to i64
  call void @__dp_read(i32 16418, i64 %22, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i32 0, i32 0))
  %23 = load i32, i32* %arrayidx3, align 4, !dbg !97
  %add4 = add nsw i32 %23, 3, !dbg !98
  %24 = ptrtoint i32* %i_0 to i64
  call void @__dp_read(i32 16418, i64 %24, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  %25 = load i32, i32* %i_0, align 4, !dbg !99
  %idxprom5 = sext i32 %25 to i64, !dbg !100
  %arrayidx6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idxprom5, !dbg !100
  %26 = ptrtoint i32* %arrayidx6 to i64
  call void @__dp_write(i32 16418, i64 %26, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i32 0, i32 0))
  store i32 %add4, i32* %arrayidx6, align 4, !dbg !101
  br label %if.end, !dbg !102

if.end:                                           ; preds = %if.then, %for.body
  br label %for.inc, !dbg !103

for.inc:                                          ; preds = %if.end
  %27 = ptrtoint i32* %a to i64
  call void @__dp_read(i32 16412, i64 %27, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %28 = load i32, i32* %a, align 4, !dbg !104
  %inc = add nsw i32 %28, 1, !dbg !104
  %29 = ptrtoint i32* %a to i64
  call void @__dp_write(i32 16412, i64 %29, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 %inc, i32* %a, align 4, !dbg !104
  br label %for.cond, !dbg !105, !llvm.loop !106

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16422, i32 0)
  %30 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16422, i64 %30, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %31 = load i32, i32* %x, align 4, !dbg !108
  %cmp7 = icmp sgt i32 %31, 3, !dbg !110
  br i1 %cmp7, label %if.then8, label %if.else, !dbg !111

if.then8:                                         ; preds = %for.end
  %32 = ptrtoint i32* %y to i64
  call void @__dp_read(i32 16423, i64 %32, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %33 = load i32, i32* %y, align 4, !dbg !112
  %34 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16423, i64 %34, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %35 = load i32, i32* %x, align 4, !dbg !114
  %add9 = add nsw i32 %33, %35, !dbg !115
  %36 = ptrtoint i32* %y to i64
  call void @__dp_write(i32 16423, i64 %36, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 %add9, i32* %y, align 4, !dbg !116
  br label %if.end10, !dbg !117

if.else:                                          ; preds = %for.end
  %37 = ptrtoint i32* %y to i64
  call void @__dp_read(i32 16426, i64 %37, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %38 = load i32, i32* %y, align 4, !dbg !118
  %39 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16426, i64 %39, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %40 = load i32, i32* %x, align 4, !dbg !120
  %sub = sub nsw i32 %38, %40, !dbg !121
  %41 = ptrtoint i32* %y to i64
  call void @__dp_write(i32 16426, i64 %41, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 %sub, i32* %y, align 4, !dbg !122
  br label %if.end10

if.end10:                                         ; preds = %if.else, %if.then8
  %42 = ptrtoint i32* %retval to i64
  call void @__dp_read(i32 16429, i64 %42, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.10, i32 0, i32 0))
  %43 = load i32, i32* %retval, align 4, !dbg !123
  call void @__dp_finalize(i32 16429), !dbg !123
  ret i32 %43, !dbg !123
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

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { noinline optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
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
!7 = distinct !DISubprogram(name: "write_to_arr", linkageName: "_Z12write_to_arrPiiS_", scope: !8, file: !8, line: 7, type: !9, scopeLine: 7, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DIFile(filename: "simple_no_dr.c", directory: "/home/lukas/Schreibtisch/dp_no_dr")
!9 = !DISubroutineType(types: !10)
!10 = !{null, !11, !12, !11}
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !DILocalVariable(name: "p_arr", arg: 1, scope: !7, file: !8, line: 7, type: !11)
!14 = !DILocation(line: 7, column: 24, scope: !7)
!15 = !DILocalVariable(name: "i_0", arg: 2, scope: !7, file: !8, line: 7, type: !12)
!16 = !DILocation(line: 7, column: 35, scope: !7)
!17 = !DILocalVariable(name: "p_read_value", arg: 3, scope: !7, file: !8, line: 7, type: !11)
!18 = !DILocation(line: 7, column: 45, scope: !7)
!19 = !DILocation(line: 8, column: 23, scope: !7)
!20 = !DILocation(line: 8, column: 22, scope: !7)
!21 = !DILocation(line: 8, column: 38, scope: !7)
!22 = !DILocation(line: 8, column: 36, scope: !7)
!23 = !DILocation(line: 8, column: 7, scope: !7)
!24 = !DILocation(line: 8, column: 15, scope: !7)
!25 = !DILocation(line: 8, column: 13, scope: !7)
!26 = !DILocation(line: 8, column: 20, scope: !7)
!27 = !DILocation(line: 10, column: 1, scope: !7)
!28 = distinct !DISubprogram(name: "call_write_to_arr", linkageName: "_Z17call_write_to_arrPiiS_", scope: !8, file: !8, line: 12, type: !9, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!29 = !DILocalVariable(name: "p_arr", arg: 1, scope: !28, file: !8, line: 12, type: !11)
!30 = !DILocation(line: 12, column: 29, scope: !28)
!31 = !DILocalVariable(name: "i_0", arg: 2, scope: !28, file: !8, line: 12, type: !12)
!32 = !DILocation(line: 12, column: 40, scope: !28)
!33 = !DILocalVariable(name: "p_read_value", arg: 3, scope: !28, file: !8, line: 12, type: !11)
!34 = !DILocation(line: 12, column: 50, scope: !28)
!35 = !DILocation(line: 13, column: 18, scope: !28)
!36 = !DILocation(line: 13, column: 25, scope: !28)
!37 = !DILocation(line: 13, column: 30, scope: !28)
!38 = !DILocation(line: 13, column: 5, scope: !28)
!39 = !DILocation(line: 14, column: 1, scope: !28)
!40 = distinct !DISubprogram(name: "useless_recursion", linkageName: "_Z17useless_recursioni", scope: !8, file: !8, line: 16, type: !41, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!41 = !DISubroutineType(types: !42)
!42 = !{!12, !12}
!43 = !DILocalVariable(name: "t", arg: 1, scope: !40, file: !8, line: 16, type: !12)
!44 = !DILocation(line: 16, column: 27, scope: !40)
!45 = !DILocation(line: 17, column: 8, scope: !46)
!46 = distinct !DILexicalBlock(scope: !40, file: !8, line: 17, column: 8)
!47 = !DILocation(line: 17, column: 10, scope: !46)
!48 = !DILocation(line: 17, column: 8, scope: !40)
!49 = !DILocation(line: 18, column: 27, scope: !50)
!50 = distinct !DILexicalBlock(scope: !46, file: !8, line: 17, column: 14)
!51 = !DILocation(line: 18, column: 28, scope: !50)
!52 = !DILocation(line: 18, column: 9, scope: !50)
!53 = !DILocation(line: 19, column: 5, scope: !50)
!54 = !DILocation(line: 20, column: 5, scope: !40)
!55 = distinct !DISubprogram(name: "main", scope: !8, file: !8, line: 23, type: !56, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!56 = !DISubroutineType(types: !57)
!57 = !{!12}
!58 = !DILocalVariable(name: "arr", scope: !55, file: !8, line: 24, type: !59)
!59 = !DICompositeType(tag: DW_TAG_array_type, baseType: !12, size: 320, elements: !60)
!60 = !{!61}
!61 = !DISubrange(count: 10)
!62 = !DILocation(line: 24, column: 9, scope: !55)
!63 = !DILocalVariable(name: "x", scope: !55, file: !8, line: 25, type: !12)
!64 = !DILocation(line: 25, column: 9, scope: !55)
!65 = !DILocalVariable(name: "y", scope: !55, file: !8, line: 26, type: !12)
!66 = !DILocation(line: 26, column: 9, scope: !55)
!67 = !DILocation(line: 27, column: 5, scope: !55)
!68 = !DILocalVariable(name: "a", scope: !69, file: !8, line: 28, type: !12)
!69 = distinct !DILexicalBlock(scope: !55, file: !8, line: 28, column: 5)
!70 = !DILocation(line: 28, column: 13, scope: !69)
!71 = !DILocation(line: 28, column: 9, scope: !69)
!72 = !DILocation(line: 28, column: 18, scope: !73)
!73 = distinct !DILexicalBlock(scope: !69, file: !8, line: 28, column: 5)
!74 = !DILocation(line: 28, column: 20, scope: !73)
!75 = !DILocation(line: 28, column: 5, scope: !69)
!76 = !DILocalVariable(name: "i_0", scope: !77, file: !8, line: 29, type: !12)
!77 = distinct !DILexicalBlock(scope: !73, file: !8, line: 28, column: 30)
!78 = !DILocation(line: 29, column: 13, scope: !77)
!79 = !DILocation(line: 29, column: 17, scope: !77)
!80 = !DILocation(line: 30, column: 20, scope: !77)
!81 = !DILocation(line: 30, column: 24, scope: !77)
!82 = !DILocation(line: 30, column: 22, scope: !77)
!83 = !DILocation(line: 30, column: 13, scope: !77)
!84 = !DILocation(line: 30, column: 9, scope: !77)
!85 = !DILocation(line: 30, column: 18, scope: !77)
!86 = !DILocation(line: 31, column: 27, scope: !77)
!87 = !DILocation(line: 31, column: 32, scope: !77)
!88 = !DILocation(line: 31, column: 9, scope: !77)
!89 = !DILocalVariable(name: "z", scope: !77, file: !8, line: 32, type: !12)
!90 = !DILocation(line: 32, column: 13, scope: !77)
!91 = !DILocation(line: 33, column: 12, scope: !92)
!92 = distinct !DILexicalBlock(scope: !77, file: !8, line: 33, column: 12)
!93 = !DILocation(line: 33, column: 14, scope: !92)
!94 = !DILocation(line: 33, column: 12, scope: !77)
!95 = !DILocation(line: 34, column: 28, scope: !96)
!96 = distinct !DILexicalBlock(scope: !92, file: !8, line: 33, column: 18)
!97 = !DILocation(line: 34, column: 24, scope: !96)
!98 = !DILocation(line: 34, column: 33, scope: !96)
!99 = !DILocation(line: 34, column: 17, scope: !96)
!100 = !DILocation(line: 34, column: 13, scope: !96)
!101 = !DILocation(line: 34, column: 22, scope: !96)
!102 = !DILocation(line: 35, column: 9, scope: !96)
!103 = !DILocation(line: 36, column: 5, scope: !77)
!104 = !DILocation(line: 28, column: 27, scope: !73)
!105 = !DILocation(line: 28, column: 5, scope: !73)
!106 = distinct !{!106, !75, !107}
!107 = !DILocation(line: 36, column: 5, scope: !69)
!108 = !DILocation(line: 38, column: 8, scope: !109)
!109 = distinct !DILexicalBlock(scope: !55, file: !8, line: 38, column: 8)
!110 = !DILocation(line: 38, column: 10, scope: !109)
!111 = !DILocation(line: 38, column: 8, scope: !55)
!112 = !DILocation(line: 39, column: 13, scope: !113)
!113 = distinct !DILexicalBlock(scope: !109, file: !8, line: 38, column: 14)
!114 = !DILocation(line: 39, column: 17, scope: !113)
!115 = !DILocation(line: 39, column: 15, scope: !113)
!116 = !DILocation(line: 39, column: 11, scope: !113)
!117 = !DILocation(line: 40, column: 5, scope: !113)
!118 = !DILocation(line: 42, column: 13, scope: !119)
!119 = distinct !DILexicalBlock(scope: !109, file: !8, line: 41, column: 9)
!120 = !DILocation(line: 42, column: 17, scope: !119)
!121 = !DILocation(line: 42, column: 15, scope: !119)
!122 = !DILocation(line: 42, column: 11, scope: !119)
!123 = !DILocation(line: 45, column: 1, scope: !55)
