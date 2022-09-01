; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@indexSet = dso_local global [180 x i32] [i32 521, i32 523, i32 525, i32 527, i32 529, i32 531, i32 547, i32 549, i32 551, i32 553, i32 555, i32 557, i32 573, i32 575, i32 577, i32 579, i32 581, i32 583, i32 599, i32 601, i32 603, i32 605, i32 607, i32 609, i32 625, i32 627, i32 629, i32 631, i32 633, i32 635, i32 651, i32 653, i32 655, i32 657, i32 659, i32 661, i32 859, i32 861, i32 863, i32 865, i32 867, i32 869, i32 885, i32 887, i32 889, i32 891, i32 893, i32 895, i32 911, i32 913, i32 915, i32 917, i32 919, i32 921, i32 937, i32 939, i32 941, i32 943, i32 945, i32 947, i32 963, i32 965, i32 967, i32 969, i32 971, i32 973, i32 989, i32 991, i32 993, i32 995, i32 997, i32 999, i32 1197, i32 1199, i32 1201, i32 1203, i32 1205, i32 1207, i32 1223, i32 1225, i32 1227, i32 1229, i32 1231, i32 1233, i32 1249, i32 1251, i32 1253, i32 1255, i32 1257, i32 1259, i32 1275, i32 1277, i32 1279, i32 1281, i32 1283, i32 1285, i32 1301, i32 1303, i32 1305, i32 1307, i32 1309, i32 1311, i32 1327, i32 1329, i32 1331, i32 1333, i32 1335, i32 1337, i32 1535, i32 1537, i32 1539, i32 1541, i32 1543, i32 1545, i32 1561, i32 1563, i32 1565, i32 1567, i32 1569, i32 1571, i32 1587, i32 1589, i32 1591, i32 1593, i32 1595, i32 1597, i32 1613, i32 1615, i32 1617, i32 1619, i32 1621, i32 1623, i32 1639, i32 1641, i32 1643, i32 1645, i32 1647, i32 1649, i32 1665, i32 1667, i32 1669, i32 1671, i32 1673, i32 1675, i32 1873, i32 1875, i32 1877, i32 1879, i32 1881, i32 1883, i32 1899, i32 1901, i32 1903, i32 1905, i32 1907, i32 1909, i32 1925, i32 1927, i32 1929, i32 1931, i32 1933, i32 1935, i32 1951, i32 1953, i32 1955, i32 1957, i32 1959, i32 1961, i32 1977, i32 1979, i32 1981, i32 1983, i32 1985, i32 1987, i32 2003, i32 2005, i32 2007, i32 2009, i32 2011, i32 2013], align 16, !dbg !0
@.str.3 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.4 = private unnamed_addr constant [5 x i8] c"argc\00", align 1
@.str.5 = private unnamed_addr constant [5 x i8] c"argv\00", align 1
@.str.6 = private unnamed_addr constant [5 x i8] c"base\00", align 1
@.str = private unnamed_addr constant [47 x i8] c"Error, malloc() returns NULL. End execution. \0A\00", align 1
@.str.7 = private unnamed_addr constant [4 x i8] c"xa1\00", align 1
@.str.8 = private unnamed_addr constant [4 x i8] c"xa2\00", align 1
@.str.9 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.10 = private unnamed_addr constant [9 x i8] c"indexSet\00", align 1
@.str.11 = private unnamed_addr constant [4 x i8] c"idx\00", align 1
@.str.1 = private unnamed_addr constant [13 x i8] c"base[i]!=4.0\00", align 1
@.str.2 = private unnamed_addr constant [9 x i8] c"simple.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [23 x i8] c"int main(int, char **)\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !17 {
entry:
  call void @__dp_func_entry(i32 16481, i32 1)
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %base = alloca double*, align 8
  %xa1 = alloca double*, align 8
  %xa2 = alloca double*, align 8
  %i = alloca i32, align 4
  %idx = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16481, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  %1 = ptrtoint i32* %argc.addr to i64
  call void @__dp_write(i32 16481, i64 %1, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.4, i32 0, i32 0))
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !23, metadata !DIExpression()), !dbg !24
  %2 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_write(i32 16481, i64 %2, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.5, i32 0, i32 0))
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !25, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.declare(metadata double** %base, metadata !27, metadata !DIExpression()), !dbg !28
  call void @__dp_call(i32 16483), !dbg !29
  %call = call noalias i8* @malloc(i64 16208) #5, !dbg !29
  %3 = bitcast i8* %call to double*, !dbg !30
  %4 = ptrtoint double** %base to i64
  call void @__dp_write(i32 16483, i64 %4, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.6, i32 0, i32 0))
  store double* %3, double** %base, align 8, !dbg !28
  %5 = ptrtoint double** %base to i64
  call void @__dp_read(i32 16484, i64 %5, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.6, i32 0, i32 0))
  %6 = load double*, double** %base, align 8, !dbg !31
  %cmp = icmp eq double* %6, null, !dbg !33
  br i1 %cmp, label %if.then, label %if.end, !dbg !34

if.then:                                          ; preds = %entry
  call void @__dp_call(i32 16486), !dbg !35
  %call1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([47 x i8], [47 x i8]* @.str, i64 0, i64 0)), !dbg !35
  %7 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16487, i64 %7, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0))
  store i32 1, i32* %retval, align 4, !dbg !37
  br label %return, !dbg !37

if.end:                                           ; preds = %entry
  call void @llvm.dbg.declare(metadata double** %xa1, metadata !38, metadata !DIExpression()), !dbg !39
  %8 = ptrtoint double** %base to i64
  call void @__dp_read(i32 16490, i64 %8, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.6, i32 0, i32 0))
  %9 = load double*, double** %base, align 8, !dbg !40
  %10 = ptrtoint double** %xa1 to i64
  call void @__dp_write(i32 16490, i64 %10, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  store double* %9, double** %xa1, align 8, !dbg !39
  call void @llvm.dbg.declare(metadata double** %xa2, metadata !41, metadata !DIExpression()), !dbg !42
  %11 = ptrtoint double** %base to i64
  call void @__dp_read(i32 16491, i64 %11, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.6, i32 0, i32 0))
  %12 = load double*, double** %base, align 8, !dbg !43
  %add.ptr = getelementptr inbounds double, double* %12, i64 12, !dbg !44
  %13 = ptrtoint double** %xa2 to i64
  call void @__dp_write(i32 16491, i64 %13, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i32 0, i32 0))
  store double* %add.ptr, double** %xa2, align 8, !dbg !42
  call void @llvm.dbg.declare(metadata i32* %i, metadata !45, metadata !DIExpression()), !dbg !46
  %14 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16494, i64 %14, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  store i32 521, i32* %i, align 4, !dbg !47
  br label %for.cond, !dbg !49

for.cond:                                         ; preds = %for.inc, %if.end
  call void @__dp_loop_entry(i32 16494, i32 0)
  %15 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16494, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  %16 = load i32, i32* %i, align 4, !dbg !50
  %cmp2 = icmp sle i32 %16, 2025, !dbg !52
  br i1 %cmp2, label %for.body, label %for.end, !dbg !53

for.body:                                         ; preds = %for.cond
  %17 = ptrtoint double** %base to i64
  call void @__dp_read(i32 16496, i64 %17, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.6, i32 0, i32 0))
  %18 = load double*, double** %base, align 8, !dbg !54
  %19 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16496, i64 %19, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  %20 = load i32, i32* %i, align 4, !dbg !56
  %idxprom = sext i32 %20 to i64, !dbg !54
  %arrayidx = getelementptr inbounds double, double* %18, i64 %idxprom, !dbg !54
  %21 = ptrtoint double* %arrayidx to i64
  call void @__dp_write(i32 16496, i64 %21, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.6, i32 0, i32 0))
  store double 0.000000e+00, double* %arrayidx, align 8, !dbg !57
  br label %for.inc, !dbg !58

for.inc:                                          ; preds = %for.body
  %22 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16494, i64 %22, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  %23 = load i32, i32* %i, align 4, !dbg !59
  %inc = add nsw i32 %23, 1, !dbg !59
  %24 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16494, i64 %24, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !59
  br label %for.cond, !dbg !60, !llvm.loop !61

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16500, i32 0)
  %25 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16500, i64 %25, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !63
  br label %for.cond3, !dbg !65

for.cond3:                                        ; preds = %for.inc13, %for.end
  call void @__dp_loop_entry(i32 16500, i32 1)
  %26 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16500, i64 %26, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  %27 = load i32, i32* %i, align 4, !dbg !66
  %cmp4 = icmp slt i32 %27, 180, !dbg !68
  br i1 %cmp4, label %for.body5, label %for.end15, !dbg !69

for.body5:                                        ; preds = %for.cond3
  call void @llvm.dbg.declare(metadata i32* %idx, metadata !70, metadata !DIExpression()), !dbg !72
  %28 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16502, i64 %28, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  %29 = load i32, i32* %i, align 4, !dbg !73
  %idxprom6 = sext i32 %29 to i64, !dbg !74
  %arrayidx7 = getelementptr inbounds [180 x i32], [180 x i32]* @indexSet, i64 0, i64 %idxprom6, !dbg !74
  %30 = ptrtoint i32* %arrayidx7 to i64
  call void @__dp_read(i32 16502, i64 %30, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  %31 = load i32, i32* %arrayidx7, align 4, !dbg !74
  %32 = ptrtoint i32* %idx to i64
  call void @__dp_write(i32 16502, i64 %32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.11, i32 0, i32 0))
  store i32 %31, i32* %idx, align 4, !dbg !72
  %33 = ptrtoint double** %xa1 to i64
  call void @__dp_read(i32 16503, i64 %33, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  %34 = load double*, double** %xa1, align 8, !dbg !75
  %35 = ptrtoint i32* %idx to i64
  call void @__dp_read(i32 16503, i64 %35, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.11, i32 0, i32 0))
  %36 = load i32, i32* %idx, align 4, !dbg !76
  %idxprom8 = sext i32 %36 to i64, !dbg !75
  %arrayidx9 = getelementptr inbounds double, double* %34, i64 %idxprom8, !dbg !75
  %37 = ptrtoint double* %arrayidx9 to i64
  call void @__dp_read(i32 16503, i64 %37, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  %38 = load double, double* %arrayidx9, align 8, !dbg !77
  %add = fadd double %38, 1.000000e+00, !dbg !77
  %39 = ptrtoint double* %arrayidx9 to i64
  call void @__dp_write(i32 16503, i64 %39, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  store double %add, double* %arrayidx9, align 8, !dbg !77
  %40 = ptrtoint double** %xa2 to i64
  call void @__dp_read(i32 16504, i64 %40, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i32 0, i32 0))
  %41 = load double*, double** %xa2, align 8, !dbg !78
  %42 = ptrtoint i32* %idx to i64
  call void @__dp_read(i32 16504, i64 %42, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.11, i32 0, i32 0))
  %43 = load i32, i32* %idx, align 4, !dbg !79
  %idxprom10 = sext i32 %43 to i64, !dbg !78
  %arrayidx11 = getelementptr inbounds double, double* %41, i64 %idxprom10, !dbg !78
  %44 = ptrtoint double* %arrayidx11 to i64
  call void @__dp_read(i32 16504, i64 %44, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i32 0, i32 0))
  %45 = load double, double* %arrayidx11, align 8, !dbg !80
  %add12 = fadd double %45, 3.000000e+00, !dbg !80
  %46 = ptrtoint double* %arrayidx11 to i64
  call void @__dp_write(i32 16504, i64 %46, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i32 0, i32 0))
  store double %add12, double* %arrayidx11, align 8, !dbg !80
  br label %for.inc13, !dbg !81

for.inc13:                                        ; preds = %for.body5
  %47 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16500, i64 %47, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  %48 = load i32, i32* %i, align 4, !dbg !82
  %inc14 = add nsw i32 %48, 1, !dbg !82
  %49 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16500, i64 %49, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  store i32 %inc14, i32* %i, align 4, !dbg !82
  br label %for.cond3, !dbg !83, !llvm.loop !84

for.end15:                                        ; preds = %for.cond3
  call void @__dp_loop_exit(i32 16508, i32 1)
  %50 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16508, i64 %50, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  store i32 521, i32* %i, align 4, !dbg !86
  br label %for.cond16, !dbg !88

for.cond16:                                       ; preds = %for.inc24, %for.end15
  call void @__dp_loop_entry(i32 16508, i32 2)
  %51 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16508, i64 %51, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  %52 = load i32, i32* %i, align 4, !dbg !89
  %cmp17 = icmp sle i32 %52, 2025, !dbg !91
  br i1 %cmp17, label %for.body18, label %for.end26, !dbg !92

for.body18:                                       ; preds = %for.cond16
  %53 = ptrtoint double** %base to i64
  call void @__dp_read(i32 16511, i64 %53, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.6, i32 0, i32 0))
  %54 = load double*, double** %base, align 8, !dbg !93
  %55 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16511, i64 %55, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  %56 = load i32, i32* %i, align 4, !dbg !93
  %idxprom19 = sext i32 %56 to i64, !dbg !93
  %arrayidx20 = getelementptr inbounds double, double* %54, i64 %idxprom19, !dbg !93
  %57 = ptrtoint double* %arrayidx20 to i64
  call void @__dp_read(i32 16511, i64 %57, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.6, i32 0, i32 0))
  %58 = load double, double* %arrayidx20, align 8, !dbg !93
  %cmp21 = fcmp une double %58, 4.000000e+00, !dbg !93
  br i1 %cmp21, label %if.then22, label %if.else, !dbg !97

if.then22:                                        ; preds = %for.body18
  br label %if.end23, !dbg !97

if.else:                                          ; preds = %for.body18
  call void @__dp_finalize(i32 16511), !dbg !93
  call void @__assert_fail(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.1, i64 0, i64 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.2, i64 0, i64 0), i32 127, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !93
  unreachable, !dbg !93

if.end23:                                         ; preds = %if.then22
  br label %for.inc24, !dbg !98

for.inc24:                                        ; preds = %if.end23
  %59 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16508, i64 %59, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  %60 = load i32, i32* %i, align 4, !dbg !99
  %inc25 = add nsw i32 %60, 1, !dbg !99
  %61 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16508, i64 %61, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  store i32 %inc25, i32* %i, align 4, !dbg !99
  br label %for.cond16, !dbg !100, !llvm.loop !101

for.end26:                                        ; preds = %for.cond16
  call void @__dp_loop_exit(i32 16514, i32 2)
  %62 = ptrtoint double** %base to i64
  call void @__dp_read(i32 16514, i64 %62, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.6, i32 0, i32 0))
  %63 = load double*, double** %base, align 8, !dbg !103
  %64 = bitcast double* %63 to i8*, !dbg !103
  call void @__dp_call(i32 16514), !dbg !104
  call void @free(i8* %64) #5, !dbg !104
  %65 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16515, i64 %65, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0))
  store i32 0, i32* %retval, align 4, !dbg !105
  br label %return, !dbg !105

return:                                           ; preds = %for.end26, %if.then
  %66 = ptrtoint i32* %retval to i64
  call void @__dp_read(i32 16516, i64 %66, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0))
  %67 = load i32, i32* %retval, align 4, !dbg !106
  call void @__dp_finalize(i32 16516), !dbg !106
  ret i32 %67, !dbg !106
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_call(i32)

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64) #2

declare void @__dp_read(i32, i64, i8*)

declare dso_local i32 @printf(i8*, ...) #3

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_loop_exit(i32, i32)

declare void @__dp_finalize(i32)

; Function Attrs: noreturn nounwind
declare dso_local void @__assert_fail(i8*, i8*, i32, i8*) #4

; Function Attrs: nounwind
declare dso_local void @free(i8*) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!13}
!llvm.module.flags = !{!14, !15, !16}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "indexSet", scope: !2, file: !3, line: 60, type: !9, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !8, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/052")
!4 = !{}
!5 = !{!6}
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!8 = !{!0}
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 5760, elements: !11)
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !{!12}
!12 = !DISubrange(count: 180)
!13 = !{!"Ubuntu clang version 11.1.0-6"}
!14 = !{i32 7, !"Dwarf Version", i32 4}
!15 = !{i32 2, !"Debug Info Version", i32 3}
!16 = !{i32 1, !"wchar_size", i32 4}
!17 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 97, type: !18, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!18 = !DISubroutineType(types: !19)
!19 = !{!10, !10, !20}
!20 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64)
!21 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !22, size: 64)
!22 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!23 = !DILocalVariable(name: "argc", arg: 1, scope: !17, file: !3, line: 97, type: !10)
!24 = !DILocation(line: 97, column: 15, scope: !17)
!25 = !DILocalVariable(name: "argv", arg: 2, scope: !17, file: !3, line: 97, type: !20)
!26 = !DILocation(line: 97, column: 27, scope: !17)
!27 = !DILocalVariable(name: "base", scope: !17, file: !3, line: 99, type: !6)
!28 = !DILocation(line: 99, column: 12, scope: !17)
!29 = !DILocation(line: 99, column: 29, scope: !17)
!30 = !DILocation(line: 99, column: 19, scope: !17)
!31 = !DILocation(line: 100, column: 7, scope: !32)
!32 = distinct !DILexicalBlock(scope: !17, file: !3, line: 100, column: 7)
!33 = !DILocation(line: 100, column: 12, scope: !32)
!34 = !DILocation(line: 100, column: 7, scope: !17)
!35 = !DILocation(line: 102, column: 5, scope: !36)
!36 = distinct !DILexicalBlock(scope: !32, file: !3, line: 101, column: 3)
!37 = !DILocation(line: 103, column: 5, scope: !36)
!38 = !DILocalVariable(name: "xa1", scope: !17, file: !3, line: 106, type: !6)
!39 = !DILocation(line: 106, column: 12, scope: !17)
!40 = !DILocation(line: 106, column: 18, scope: !17)
!41 = !DILocalVariable(name: "xa2", scope: !17, file: !3, line: 107, type: !6)
!42 = !DILocation(line: 107, column: 12, scope: !17)
!43 = !DILocation(line: 107, column: 18, scope: !17)
!44 = !DILocation(line: 107, column: 23, scope: !17)
!45 = !DILocalVariable(name: "i", scope: !17, file: !3, line: 108, type: !10)
!46 = !DILocation(line: 108, column: 7, scope: !17)
!47 = !DILocation(line: 110, column: 10, scope: !48)
!48 = distinct !DILexicalBlock(scope: !17, file: !3, line: 110, column: 3)
!49 = !DILocation(line: 110, column: 8, scope: !48)
!50 = !DILocation(line: 110, column: 16, scope: !51)
!51 = distinct !DILexicalBlock(scope: !48, file: !3, line: 110, column: 3)
!52 = !DILocation(line: 110, column: 17, scope: !51)
!53 = !DILocation(line: 110, column: 3, scope: !48)
!54 = !DILocation(line: 112, column: 5, scope: !55)
!55 = distinct !DILexicalBlock(scope: !51, file: !3, line: 111, column: 3)
!56 = !DILocation(line: 112, column: 10, scope: !55)
!57 = !DILocation(line: 112, column: 12, scope: !55)
!58 = !DILocation(line: 113, column: 3, scope: !55)
!59 = !DILocation(line: 110, column: 26, scope: !51)
!60 = !DILocation(line: 110, column: 3, scope: !51)
!61 = distinct !{!61, !53, !62}
!62 = !DILocation(line: 113, column: 3, scope: !48)
!63 = !DILocation(line: 116, column: 10, scope: !64)
!64 = distinct !DILexicalBlock(scope: !17, file: !3, line: 116, column: 3)
!65 = !DILocation(line: 116, column: 8, scope: !64)
!66 = !DILocation(line: 116, column: 14, scope: !67)
!67 = distinct !DILexicalBlock(scope: !64, file: !3, line: 116, column: 3)
!68 = !DILocation(line: 116, column: 15, scope: !67)
!69 = !DILocation(line: 116, column: 3, scope: !64)
!70 = !DILocalVariable(name: "idx", scope: !71, file: !3, line: 118, type: !10)
!71 = distinct !DILexicalBlock(scope: !67, file: !3, line: 117, column: 3)
!72 = !DILocation(line: 118, column: 9, scope: !71)
!73 = !DILocation(line: 118, column: 24, scope: !71)
!74 = !DILocation(line: 118, column: 15, scope: !71)
!75 = !DILocation(line: 119, column: 5, scope: !71)
!76 = !DILocation(line: 119, column: 9, scope: !71)
!77 = !DILocation(line: 119, column: 13, scope: !71)
!78 = !DILocation(line: 120, column: 5, scope: !71)
!79 = !DILocation(line: 120, column: 9, scope: !71)
!80 = !DILocation(line: 120, column: 13, scope: !71)
!81 = !DILocation(line: 121, column: 3, scope: !71)
!82 = !DILocation(line: 116, column: 20, scope: !67)
!83 = !DILocation(line: 116, column: 3, scope: !67)
!84 = distinct !{!84, !69, !85}
!85 = !DILocation(line: 121, column: 3, scope: !64)
!86 = !DILocation(line: 124, column: 10, scope: !87)
!87 = distinct !DILexicalBlock(scope: !17, file: !3, line: 124, column: 3)
!88 = !DILocation(line: 124, column: 8, scope: !87)
!89 = !DILocation(line: 124, column: 16, scope: !90)
!90 = distinct !DILexicalBlock(scope: !87, file: !3, line: 124, column: 3)
!91 = !DILocation(line: 124, column: 17, scope: !90)
!92 = !DILocation(line: 124, column: 3, scope: !87)
!93 = !DILocation(line: 127, column: 5, scope: !94)
!94 = distinct !DILexicalBlock(scope: !95, file: !3, line: 127, column: 5)
!95 = distinct !DILexicalBlock(scope: !96, file: !3, line: 127, column: 5)
!96 = distinct !DILexicalBlock(scope: !90, file: !3, line: 125, column: 3)
!97 = !DILocation(line: 127, column: 5, scope: !95)
!98 = !DILocation(line: 128, column: 3, scope: !96)
!99 = !DILocation(line: 124, column: 26, scope: !90)
!100 = !DILocation(line: 124, column: 3, scope: !90)
!101 = distinct !{!101, !92, !102}
!102 = !DILocation(line: 128, column: 3, scope: !87)
!103 = !DILocation(line: 130, column: 9, scope: !17)
!104 = !DILocation(line: 130, column: 3, scope: !17)
!105 = !DILocation(line: 131, column: 3, scope: !17)
!106 = !DILocation(line: 132, column: 1, scope: !17)
