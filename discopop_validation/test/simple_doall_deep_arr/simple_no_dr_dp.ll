; ModuleID = '/home/lukas/Schreibtisch/dp_no_dr/simple_no_dr.c'
source_filename = "/home/lukas/Schreibtisch/dp_no_dr/simple_no_dr.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c"i_0\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"i_1\00", align 1
@.str.5 = private unnamed_addr constant [4 x i8] c"i_2\00", align 1
@.str.6 = private unnamed_addr constant [4 x i8] c"i_3\00", align 1
@.str.7 = private unnamed_addr constant [4 x i8] c"arr\00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c"z\00", align 1
@.str.9 = private unnamed_addr constant [7 x i8] c"retval\00", align 1

; Function Attrs: noinline norecurse nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16388, i32 1)
  %retval = alloca i32, align 4
  %arr = alloca [10 x [10 x [10 x [10 x i32]]]], align 16
  %x = alloca i32, align 4
  %y = alloca i32, align 4
  %a = alloca i32, align 4
  %i_0 = alloca i32, align 4
  %i_1 = alloca i32, align 4
  %i_2 = alloca i32, align 4
  %i_3 = alloca i32, align 4
  %z = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata [10 x [10 x [10 x [10 x i32]]]]* %arr, metadata !12, metadata !DIExpression()), !dbg !16
  call void @llvm.dbg.declare(metadata i32* %x, metadata !17, metadata !DIExpression()), !dbg !18
  %0 = ptrtoint i32* %x to i64
  call void @__dp_write(i32 16389, i64 %0, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i32 0, i32* %x, align 4, !dbg !18
  call void @llvm.dbg.declare(metadata i32* %y, metadata !19, metadata !DIExpression()), !dbg !20
  %1 = ptrtoint i32* %y to i64
  call void @__dp_write(i32 16390, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %y, align 4, !dbg !20
  call void @llvm.dbg.declare(metadata i32* %a, metadata !21, metadata !DIExpression()), !dbg !23
  %2 = ptrtoint i32* %a to i64
  call void @__dp_write(i32 16391, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %a, align 4, !dbg !23
  br label %for.cond, !dbg !24

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16391, i32 0)
  %3 = ptrtoint i32* %a to i64
  call void @__dp_read(i32 16391, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %4 = load i32, i32* %a, align 4, !dbg !25
  %cmp = icmp slt i32 %4, 10, !dbg !27
  br i1 %cmp, label %for.body, label %for.end, !dbg !28

for.body:                                         ; preds = %for.cond
  call void @llvm.dbg.declare(metadata i32* %i_0, metadata !29, metadata !DIExpression()), !dbg !31
  %5 = ptrtoint i32* %a to i64
  call void @__dp_read(i32 16392, i64 %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %6 = load i32, i32* %a, align 4, !dbg !32
  %7 = ptrtoint i32* %i_0 to i64
  call void @__dp_write(i32 16392, i64 %7, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  store i32 %6, i32* %i_0, align 4, !dbg !31
  call void @llvm.dbg.declare(metadata i32* %i_1, metadata !33, metadata !DIExpression()), !dbg !34
  %8 = ptrtoint i32* %a to i64
  call void @__dp_read(i32 16392, i64 %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %9 = load i32, i32* %a, align 4, !dbg !35
  %mul = mul nsw i32 %9, 2, !dbg !36
  %rem = srem i32 %mul, 10, !dbg !37
  %10 = ptrtoint i32* %i_1 to i64
  call void @__dp_write(i32 16392, i64 %10, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  store i32 %rem, i32* %i_1, align 4, !dbg !34
  call void @llvm.dbg.declare(metadata i32* %i_2, metadata !38, metadata !DIExpression()), !dbg !39
  %11 = ptrtoint i32* %a to i64
  call void @__dp_read(i32 16392, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %12 = load i32, i32* %a, align 4, !dbg !40
  %mul1 = mul nsw i32 %12, 3, !dbg !41
  %rem2 = srem i32 %mul1, 10, !dbg !42
  %13 = ptrtoint i32* %i_2 to i64
  call void @__dp_write(i32 16392, i64 %13, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i32 0, i32 0))
  store i32 %rem2, i32* %i_2, align 4, !dbg !39
  call void @llvm.dbg.declare(metadata i32* %i_3, metadata !43, metadata !DIExpression()), !dbg !44
  %14 = ptrtoint i32* %a to i64
  call void @__dp_read(i32 16392, i64 %14, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %15 = load i32, i32* %a, align 4, !dbg !45
  %mul3 = mul nsw i32 %15, 4, !dbg !46
  %rem4 = srem i32 %mul3, 10, !dbg !47
  %16 = ptrtoint i32* %i_3 to i64
  call void @__dp_write(i32 16392, i64 %16, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.6, i32 0, i32 0))
  store i32 %rem4, i32* %i_3, align 4, !dbg !44
  %17 = ptrtoint i32* %a to i64
  call void @__dp_read(i32 16393, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %18 = load i32, i32* %a, align 4, !dbg !48
  %19 = ptrtoint i32* %i_2 to i64
  call void @__dp_read(i32 16393, i64 %19, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i32 0, i32 0))
  %20 = load i32, i32* %i_2, align 4, !dbg !49
  %add = add nsw i32 %18, %20, !dbg !50
  %21 = ptrtoint i32* %i_0 to i64
  call void @__dp_read(i32 16393, i64 %21, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  %22 = load i32, i32* %i_0, align 4, !dbg !51
  %idxprom = sext i32 %22 to i64, !dbg !52
  %arrayidx = getelementptr inbounds [10 x [10 x [10 x [10 x i32]]]], [10 x [10 x [10 x [10 x i32]]]]* %arr, i64 0, i64 %idxprom, !dbg !52
  %23 = ptrtoint i32* %i_1 to i64
  call void @__dp_read(i32 16393, i64 %23, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  %24 = load i32, i32* %i_1, align 4, !dbg !53
  %idxprom5 = sext i32 %24 to i64, !dbg !52
  %arrayidx6 = getelementptr inbounds [10 x [10 x [10 x i32]]], [10 x [10 x [10 x i32]]]* %arrayidx, i64 0, i64 %idxprom5, !dbg !52
  %25 = ptrtoint i32* %i_2 to i64
  call void @__dp_read(i32 16393, i64 %25, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i32 0, i32 0))
  %26 = load i32, i32* %i_2, align 4, !dbg !54
  %idxprom7 = sext i32 %26 to i64, !dbg !52
  %arrayidx8 = getelementptr inbounds [10 x [10 x i32]], [10 x [10 x i32]]* %arrayidx6, i64 0, i64 %idxprom7, !dbg !52
  %27 = ptrtoint i32* %i_3 to i64
  call void @__dp_read(i32 16393, i64 %27, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.6, i32 0, i32 0))
  %28 = load i32, i32* %i_3, align 4, !dbg !55
  %idxprom9 = sext i32 %28 to i64, !dbg !52
  %arrayidx10 = getelementptr inbounds [10 x i32], [10 x i32]* %arrayidx8, i64 0, i64 %idxprom9, !dbg !52
  %29 = ptrtoint i32* %arrayidx10 to i64
  call void @__dp_write(i32 16393, i64 %29, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  store i32 %add, i32* %arrayidx10, align 4, !dbg !56
  call void @llvm.dbg.declare(metadata i32* %z, metadata !57, metadata !DIExpression()), !dbg !58
  %30 = ptrtoint i32* %z to i64
  call void @__dp_write(i32 16394, i64 %30, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  store i32 0, i32* %z, align 4, !dbg !58
  %31 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16395, i64 %31, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %32 = load i32, i32* %x, align 4, !dbg !59
  %cmp11 = icmp sgt i32 %32, 3, !dbg !61
  br i1 %cmp11, label %if.then, label %if.end, !dbg !62

if.then:                                          ; preds = %for.body
  %33 = ptrtoint i32* %i_0 to i64
  call void @__dp_read(i32 16396, i64 %33, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  %34 = load i32, i32* %i_0, align 4, !dbg !63
  %idxprom12 = sext i32 %34 to i64, !dbg !65
  %arrayidx13 = getelementptr inbounds [10 x [10 x [10 x [10 x i32]]]], [10 x [10 x [10 x [10 x i32]]]]* %arr, i64 0, i64 %idxprom12, !dbg !65
  %35 = ptrtoint i32* %i_1 to i64
  call void @__dp_read(i32 16396, i64 %35, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  %36 = load i32, i32* %i_1, align 4, !dbg !66
  %idxprom14 = sext i32 %36 to i64, !dbg !65
  %arrayidx15 = getelementptr inbounds [10 x [10 x [10 x i32]]], [10 x [10 x [10 x i32]]]* %arrayidx13, i64 0, i64 %idxprom14, !dbg !65
  %37 = ptrtoint i32* %i_2 to i64
  call void @__dp_read(i32 16396, i64 %37, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i32 0, i32 0))
  %38 = load i32, i32* %i_2, align 4, !dbg !67
  %idxprom16 = sext i32 %38 to i64, !dbg !65
  %arrayidx17 = getelementptr inbounds [10 x [10 x i32]], [10 x [10 x i32]]* %arrayidx15, i64 0, i64 %idxprom16, !dbg !65
  %39 = ptrtoint i32* %i_3 to i64
  call void @__dp_read(i32 16396, i64 %39, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.6, i32 0, i32 0))
  %40 = load i32, i32* %i_3, align 4, !dbg !68
  %idxprom18 = sext i32 %40 to i64, !dbg !65
  %arrayidx19 = getelementptr inbounds [10 x i32], [10 x i32]* %arrayidx17, i64 0, i64 %idxprom18, !dbg !65
  %41 = ptrtoint i32* %arrayidx19 to i64
  call void @__dp_read(i32 16396, i64 %41, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  %42 = load i32, i32* %arrayidx19, align 4, !dbg !65
  %add20 = add nsw i32 %42, 3, !dbg !69
  %43 = ptrtoint i32* %i_0 to i64
  call void @__dp_read(i32 16396, i64 %43, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  %44 = load i32, i32* %i_0, align 4, !dbg !70
  %idxprom21 = sext i32 %44 to i64, !dbg !71
  %arrayidx22 = getelementptr inbounds [10 x [10 x [10 x [10 x i32]]]], [10 x [10 x [10 x [10 x i32]]]]* %arr, i64 0, i64 %idxprom21, !dbg !71
  %45 = ptrtoint i32* %i_1 to i64
  call void @__dp_read(i32 16396, i64 %45, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  %46 = load i32, i32* %i_1, align 4, !dbg !72
  %idxprom23 = sext i32 %46 to i64, !dbg !71
  %arrayidx24 = getelementptr inbounds [10 x [10 x [10 x i32]]], [10 x [10 x [10 x i32]]]* %arrayidx22, i64 0, i64 %idxprom23, !dbg !71
  %47 = ptrtoint i32* %i_2 to i64
  call void @__dp_read(i32 16396, i64 %47, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i32 0, i32 0))
  %48 = load i32, i32* %i_2, align 4, !dbg !73
  %idxprom25 = sext i32 %48 to i64, !dbg !71
  %arrayidx26 = getelementptr inbounds [10 x [10 x i32]], [10 x [10 x i32]]* %arrayidx24, i64 0, i64 %idxprom25, !dbg !71
  %49 = ptrtoint i32* %i_3 to i64
  call void @__dp_read(i32 16396, i64 %49, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.6, i32 0, i32 0))
  %50 = load i32, i32* %i_3, align 4, !dbg !74
  %idxprom27 = sext i32 %50 to i64, !dbg !71
  %arrayidx28 = getelementptr inbounds [10 x i32], [10 x i32]* %arrayidx26, i64 0, i64 %idxprom27, !dbg !71
  %51 = ptrtoint i32* %arrayidx28 to i64
  call void @__dp_write(i32 16396, i64 %51, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  store i32 %add20, i32* %arrayidx28, align 4, !dbg !75
  br label %if.end, !dbg !76

if.end:                                           ; preds = %if.then, %for.body
  br label %for.inc, !dbg !77

for.inc:                                          ; preds = %if.end
  %52 = ptrtoint i32* %a to i64
  call void @__dp_read(i32 16391, i64 %52, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %53 = load i32, i32* %a, align 4, !dbg !78
  %inc = add nsw i32 %53, 1, !dbg !78
  %54 = ptrtoint i32* %a to i64
  call void @__dp_write(i32 16391, i64 %54, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 %inc, i32* %a, align 4, !dbg !78
  br label %for.cond, !dbg !79, !llvm.loop !80

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16400, i32 0)
  %55 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16400, i64 %55, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %56 = load i32, i32* %x, align 4, !dbg !82
  %cmp29 = icmp sgt i32 %56, 3, !dbg !84
  br i1 %cmp29, label %if.then30, label %if.else, !dbg !85

if.then30:                                        ; preds = %for.end
  %57 = ptrtoint i32* %y to i64
  call void @__dp_read(i32 16401, i64 %57, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %58 = load i32, i32* %y, align 4, !dbg !86
  %59 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16401, i64 %59, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %60 = load i32, i32* %x, align 4, !dbg !88
  %add31 = add nsw i32 %58, %60, !dbg !89
  %61 = ptrtoint i32* %y to i64
  call void @__dp_write(i32 16401, i64 %61, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 %add31, i32* %y, align 4, !dbg !90
  br label %if.end32, !dbg !91

if.else:                                          ; preds = %for.end
  %62 = ptrtoint i32* %y to i64
  call void @__dp_read(i32 16404, i64 %62, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %63 = load i32, i32* %y, align 4, !dbg !92
  %64 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16404, i64 %64, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %65 = load i32, i32* %x, align 4, !dbg !94
  %sub = sub nsw i32 %63, %65, !dbg !95
  %66 = ptrtoint i32* %y to i64
  call void @__dp_write(i32 16404, i64 %66, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 %sub, i32* %y, align 4, !dbg !96
  br label %if.end32

if.end32:                                         ; preds = %if.else, %if.then30
  %67 = ptrtoint i32* %retval to i64
  call void @__dp_read(i32 16407, i64 %67, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.9, i32 0, i32 0))
  %68 = load i32, i32* %retval, align 4, !dbg !97
  call void @__dp_finalize(i32 16407), !dbg !97
  ret i32 %68, !dbg !97
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_init(i32, i32, i32)

declare void @__dp_finalize(i32)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_write(i32, i64, i8*)

declare void @__dp_call(i32)

declare void @__dp_func_entry(i32, i32)

declare void @__dp_func_exit(i32, i32)

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_loop_exit(i32, i32)

attributes #0 = { noinline norecurse nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }

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
!7 = distinct !DISubprogram(name: "main", scope: !8, file: !8, line: 3, type: !9, scopeLine: 3, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DIFile(filename: "simple_no_dr.c", directory: "/home/lukas/Schreibtisch/dp_no_dr")
!9 = !DISubroutineType(types: !10)
!10 = !{!11}
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !DILocalVariable(name: "arr", scope: !7, file: !8, line: 4, type: !13)
!13 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 320000, elements: !14)
!14 = !{!15, !15, !15, !15}
!15 = !DISubrange(count: 10)
!16 = !DILocation(line: 4, column: 9, scope: !7)
!17 = !DILocalVariable(name: "x", scope: !7, file: !8, line: 5, type: !11)
!18 = !DILocation(line: 5, column: 9, scope: !7)
!19 = !DILocalVariable(name: "y", scope: !7, file: !8, line: 6, type: !11)
!20 = !DILocation(line: 6, column: 9, scope: !7)
!21 = !DILocalVariable(name: "a", scope: !22, file: !8, line: 7, type: !11)
!22 = distinct !DILexicalBlock(scope: !7, file: !8, line: 7, column: 5)
!23 = !DILocation(line: 7, column: 13, scope: !22)
!24 = !DILocation(line: 7, column: 9, scope: !22)
!25 = !DILocation(line: 7, column: 18, scope: !26)
!26 = distinct !DILexicalBlock(scope: !22, file: !8, line: 7, column: 5)
!27 = !DILocation(line: 7, column: 20, scope: !26)
!28 = !DILocation(line: 7, column: 5, scope: !22)
!29 = !DILocalVariable(name: "i_0", scope: !30, file: !8, line: 8, type: !11)
!30 = distinct !DILexicalBlock(scope: !26, file: !8, line: 7, column: 30)
!31 = !DILocation(line: 8, column: 13, scope: !30)
!32 = !DILocation(line: 8, column: 17, scope: !30)
!33 = !DILocalVariable(name: "i_1", scope: !30, file: !8, line: 8, type: !11)
!34 = !DILocation(line: 8, column: 20, scope: !30)
!35 = !DILocation(line: 8, column: 25, scope: !30)
!36 = !DILocation(line: 8, column: 26, scope: !30)
!37 = !DILocation(line: 8, column: 29, scope: !30)
!38 = !DILocalVariable(name: "i_2", scope: !30, file: !8, line: 8, type: !11)
!39 = !DILocation(line: 8, column: 34, scope: !30)
!40 = !DILocation(line: 8, column: 39, scope: !30)
!41 = !DILocation(line: 8, column: 40, scope: !30)
!42 = !DILocation(line: 8, column: 43, scope: !30)
!43 = !DILocalVariable(name: "i_3", scope: !30, file: !8, line: 8, type: !11)
!44 = !DILocation(line: 8, column: 48, scope: !30)
!45 = !DILocation(line: 8, column: 53, scope: !30)
!46 = !DILocation(line: 8, column: 54, scope: !30)
!47 = !DILocation(line: 8, column: 57, scope: !30)
!48 = !DILocation(line: 9, column: 35, scope: !30)
!49 = !DILocation(line: 9, column: 37, scope: !30)
!50 = !DILocation(line: 9, column: 36, scope: !30)
!51 = !DILocation(line: 9, column: 13, scope: !30)
!52 = !DILocation(line: 9, column: 9, scope: !30)
!53 = !DILocation(line: 9, column: 18, scope: !30)
!54 = !DILocation(line: 9, column: 23, scope: !30)
!55 = !DILocation(line: 9, column: 28, scope: !30)
!56 = !DILocation(line: 9, column: 33, scope: !30)
!57 = !DILocalVariable(name: "z", scope: !30, file: !8, line: 10, type: !11)
!58 = !DILocation(line: 10, column: 13, scope: !30)
!59 = !DILocation(line: 11, column: 12, scope: !60)
!60 = distinct !DILexicalBlock(scope: !30, file: !8, line: 11, column: 12)
!61 = !DILocation(line: 11, column: 14, scope: !60)
!62 = !DILocation(line: 11, column: 12, scope: !30)
!63 = !DILocation(line: 12, column: 43, scope: !64)
!64 = distinct !DILexicalBlock(scope: !60, file: !8, line: 11, column: 18)
!65 = !DILocation(line: 12, column: 39, scope: !64)
!66 = !DILocation(line: 12, column: 48, scope: !64)
!67 = !DILocation(line: 12, column: 53, scope: !64)
!68 = !DILocation(line: 12, column: 58, scope: !64)
!69 = !DILocation(line: 12, column: 63, scope: !64)
!70 = !DILocation(line: 12, column: 17, scope: !64)
!71 = !DILocation(line: 12, column: 13, scope: !64)
!72 = !DILocation(line: 12, column: 22, scope: !64)
!73 = !DILocation(line: 12, column: 27, scope: !64)
!74 = !DILocation(line: 12, column: 32, scope: !64)
!75 = !DILocation(line: 12, column: 37, scope: !64)
!76 = !DILocation(line: 13, column: 9, scope: !64)
!77 = !DILocation(line: 14, column: 5, scope: !30)
!78 = !DILocation(line: 7, column: 27, scope: !26)
!79 = !DILocation(line: 7, column: 5, scope: !26)
!80 = distinct !{!80, !28, !81}
!81 = !DILocation(line: 14, column: 5, scope: !22)
!82 = !DILocation(line: 16, column: 8, scope: !83)
!83 = distinct !DILexicalBlock(scope: !7, file: !8, line: 16, column: 8)
!84 = !DILocation(line: 16, column: 10, scope: !83)
!85 = !DILocation(line: 16, column: 8, scope: !7)
!86 = !DILocation(line: 17, column: 13, scope: !87)
!87 = distinct !DILexicalBlock(scope: !83, file: !8, line: 16, column: 14)
!88 = !DILocation(line: 17, column: 17, scope: !87)
!89 = !DILocation(line: 17, column: 15, scope: !87)
!90 = !DILocation(line: 17, column: 11, scope: !87)
!91 = !DILocation(line: 18, column: 5, scope: !87)
!92 = !DILocation(line: 20, column: 13, scope: !93)
!93 = distinct !DILexicalBlock(scope: !83, file: !8, line: 19, column: 9)
!94 = !DILocation(line: 20, column: 17, scope: !93)
!95 = !DILocation(line: 20, column: 15, scope: !93)
!96 = !DILocation(line: 20, column: 11, scope: !93)
!97 = !DILocation(line: 23, column: 1, scope: !7)
