; ModuleID = 'code.cpp'
source_filename = "code.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [8 x i8] c"1:1;1:3\00", align 1
@.str.1 = private unnamed_addr constant [8 x i8] c"1:1;1:5\00", align 1
@.str.2 = private unnamed_addr constant [8 x i8] c"1:2;1:3\00", align 1
@.str.3 = private unnamed_addr constant [8 x i8] c"1:2;1:5\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.6 = private unnamed_addr constant [10 x i8] c"1:15;1:16\00", align 1
@.str.7 = private unnamed_addr constant [10 x i8] c"1:15;1:18\00", align 1
@.str.8 = private unnamed_addr constant [10 x i8] c"1:15;1:19\00", align 1
@.str.9 = private unnamed_addr constant [10 x i8] c"1:21;1:22\00", align 1
@.str.10 = private unnamed_addr constant [10 x i8] c"1:21;1:26\00", align 1
@.str.11 = private unnamed_addr constant [5 x i8] c".str\00", align 1
@.str.12 = private unnamed_addr constant [7 x i8] c".str.1\00", align 1
@.str.13 = private unnamed_addr constant [7 x i8] c".str.2\00", align 1
@.str.14 = private unnamed_addr constant [7 x i8] c".str.3\00", align 1
@.str.15 = private unnamed_addr constant [7 x i8] c".str.4\00", align 1
@.str.16 = private unnamed_addr constant [7 x i8] c".str.5\00", align 1
@.str.17 = private unnamed_addr constant [7 x i8] c".str.6\00", align 1
@.str.18 = private unnamed_addr constant [7 x i8] c".str.7\00", align 1
@.str.19 = private unnamed_addr constant [7 x i8] c".str.8\00", align 1
@.str.20 = private unnamed_addr constant [7 x i8] c".str.9\00", align 1
@.str.21 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.22 = private unnamed_addr constant [2 x i8] c"N\00", align 1
@.str.23 = private unnamed_addr constant [12 x i8] c"saved_stack\00", align 1
@.str.24 = private unnamed_addr constant [12 x i8] c"__vla_expr0\00", align 1
@.str.25 = private unnamed_addr constant [2 x i8] c"w\00", align 1
@.str.26 = private unnamed_addr constant [4 x i8] c"Arr\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define i32 @_Z1fi(i32 %i) #0 !dbg !8 {
entry:
  call void @__dp_func_entry(i32 16387, i32 0)
  %__dp_bb1 = alloca i32, align 4
  store i32 0, i32* %__dp_bb1, align 4
  %__dp_bb = alloca i32, align 4
  store i32 0, i32* %__dp_bb, align 4
  %retval = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  %i.addr = alloca i32, align 4
  %1 = ptrtoint i32* %i.addr to i64
  %2 = ptrtoint i32* %i.addr to i64
  store i32 %i, i32* %i.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %i.addr, metadata !12, metadata !DIExpression()), !dbg !13
  %3 = ptrtoint i32* %i.addr to i64
  %4 = load i32, i32* %i.addr, align 4, !dbg !14
  %cmp = icmp slt i32 %4, 50000, !dbg !16
  call void @__dp_incr_taken_branch_counter(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i32 0, i32 0), i1 %cmp, i32 1), !dbg !17
  call void @__dp_incr_taken_branch_counter(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.1, i32 0, i32 0), i1 %cmp, i32 0), !dbg !17
  call void @__dp_incr_taken_branch_counter(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.2, i32 0, i32 0), i1 %cmp, i32 1), !dbg !17
  call void @__dp_incr_taken_branch_counter(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.3, i32 0, i32 0), i1 %cmp, i32 0), !dbg !17
  call void @__dp_report_bb(i32 0)
  br i1 %cmp, label %if.then, label %if.else, !dbg !17

if.then:                                          ; preds = %entry
  %5 = ptrtoint i32* %i.addr to i64
  %6 = load i32, i32* %i.addr, align 4, !dbg !18
  %add = add nsw i32 %6, 50000, !dbg !20
  %7 = ptrtoint i32* %retval to i64
  store i32 %add, i32* %retval, align 4, !dbg !21
  call void @__dp_report_bb(i32 1)
  store i32 1, i32* %__dp_bb, align 4
  br label %return, !dbg !21

if.else:                                          ; preds = %entry
  %8 = ptrtoint i32* %i.addr to i64
  %9 = load i32, i32* %i.addr, align 4, !dbg !22
  %10 = ptrtoint i32* %retval to i64
  store i32 %9, i32* %retval, align 4, !dbg !24
  call void @__dp_report_bb(i32 2)
  store i32 1, i32* %__dp_bb1, align 4
  br label %return, !dbg !24

return:                                           ; preds = %if.else, %if.then
  %11 = ptrtoint i32* %retval to i64
  %12 = load i32, i32* %retval, align 4, !dbg !25
  %13 = load i32, i32* %__dp_bb, align 4
  call void @__dp_report_bb_pair(i32 %13, i32 3)
  %14 = load i32, i32* %__dp_bb1, align 4
  call void @__dp_report_bb_pair(i32 %14, i32 4)
  call void @__dp_func_exit(i32 16393, i32 0), !dbg !25
  ret i32 %12, !dbg !25
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define i32 @_Z1gi(i32 %i) #0 !dbg !26 {
entry:
  call void @__dp_func_entry(i32 16395, i32 0)
  %i.addr = alloca i32, align 4
  %0 = ptrtoint i32* %i.addr to i64
  %1 = ptrtoint i32* %i.addr to i64
  store i32 %i, i32* %i.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %i.addr, metadata !27, metadata !DIExpression()), !dbg !28
  %2 = ptrtoint i32* %i.addr to i64
  %3 = load i32, i32* %i.addr, align 4, !dbg !29
  call void @__dp_report_bb(i32 5)
  call void @__dp_func_exit(i32 16395, i32 0), !dbg !30
  ret i32 %3, !dbg !30
}

; Function Attrs: noinline norecurse nounwind optnone uwtable
define i32 @main() #2 !dbg !31 {
entry:
  call void @__dp_func_entry(i32 16397, i32 1)
  %__dp_bb14 = alloca i32, align 4
  store i32 0, i32* %__dp_bb14, align 4
  %__dp_bb13 = alloca i32, align 4
  store i32 0, i32* %__dp_bb13, align 4
  %__dp_bb = alloca i32, align 4
  store i32 0, i32* %__dp_bb, align 4
  %retval = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  %N = alloca i32, align 4
  %1 = ptrtoint i32* %N to i64
  %saved_stack = alloca i8*, align 8
  %2 = ptrtoint i8** %saved_stack to i64
  %__vla_expr0 = alloca i64, align 8
  %3 = ptrtoint i64* %__vla_expr0 to i64
  %i = alloca i32, align 4
  %4 = ptrtoint i32* %i to i64
  %w = alloca i64, align 8
  %5 = ptrtoint i64* %w to i64
  %i1 = alloca i32, align 4
  %6 = ptrtoint i32* %i1 to i64
  %7 = ptrtoint i32* %retval to i64
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %N, metadata !34, metadata !DIExpression()), !dbg !35
  %8 = ptrtoint i32* %N to i64
  store i32 100000, i32* %N, align 4, !dbg !35
  %9 = ptrtoint i32* %N to i64
  %10 = load i32, i32* %N, align 4, !dbg !36
  %11 = zext i32 %10 to i64, !dbg !37
  call void @__dp_call(i32 16399), !dbg !37
  %12 = call i8* @llvm.stacksave(), !dbg !37
  %13 = ptrtoint i8** %saved_stack to i64
  store i8* %12, i8** %saved_stack, align 8, !dbg !37
  %vla = alloca i32, i64 %11, align 16, !dbg !37
  %14 = ptrtoint i32* %vla to i64, !dbg !37
  %15 = add i64 %14, %11, !dbg !37
  %16 = mul i64 %11, 4, !dbg !37
  call void @__dp_alloca(i32 16399, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.26, i32 0, i32 0), i64 %14, i64 %15, i64 %16, i64 %11), !dbg !37
  %17 = ptrtoint i64* %__vla_expr0 to i64
  store i64 %11, i64* %__vla_expr0, align 8, !dbg !37
  call void @llvm.dbg.declare(metadata i64* %__vla_expr0, metadata !38, metadata !DIExpression()), !dbg !40
  call void @llvm.dbg.declare(metadata i32* %vla, metadata !41, metadata !DIExpression()), !dbg !45
  call void @llvm.dbg.declare(metadata i32* %i, metadata !46, metadata !DIExpression()), !dbg !48
  %18 = ptrtoint i32* %i to i64
  store i32 0, i32* %i, align 4, !dbg !48
  call void @__dp_report_bb(i32 6)
  br label %for.cond, !dbg !49

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16402, i32 0)
  %19 = ptrtoint i32* %i to i64
  %20 = load i32, i32* %i, align 4, !dbg !50
  %21 = ptrtoint i32* %N to i64
  %22 = load i32, i32* %N, align 4, !dbg !52
  %cmp = icmp slt i32 %20, %22, !dbg !53
  call void @__dp_incr_taken_branch_counter(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.6, i32 0, i32 0), i1 %cmp, i32 1), !dbg !54
  call void @__dp_incr_taken_branch_counter(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.7, i32 0, i32 0), i1 %cmp, i32 0), !dbg !54
  call void @__dp_incr_taken_branch_counter(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.8, i32 0, i32 0), i1 %cmp, i32 0), !dbg !54
  call void @__dp_report_bb(i32 9)
  %23 = load i32, i32* %__dp_bb, align 4
  call void @__dp_report_bb_pair(i32 %23, i32 16)
  br i1 %cmp, label %for.body, label %for.end, !dbg !54

for.body:                                         ; preds = %for.cond
  call void @__dp_loop_incr(i32 2)
  %24 = ptrtoint i32* %i to i64
  %25 = load i32, i32* %i, align 4, !dbg !55
  %idxprom = sext i32 %25 to i64, !dbg !57
  %arrayidx = getelementptr inbounds i32, i32* %vla, i64 %idxprom, !dbg !57
  %26 = ptrtoint i32* %arrayidx to i64
  call void @__dp_write(i32 16403, i64 %26, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.26, i32 0, i32 0))
  store i32 0, i32* %arrayidx, align 4, !dbg !58
  call void @__dp_report_bb(i32 7)
  %27 = load i32, i32* %__dp_bb, align 4
  call void @__dp_report_bb_pair(i32 %27, i32 15)
  br label %for.inc, !dbg !59

for.inc:                                          ; preds = %for.body
  %28 = ptrtoint i32* %i to i64
  %29 = load i32, i32* %i, align 4, !dbg !60
  %inc = add nsw i32 %29, 1, !dbg !60
  %30 = ptrtoint i32* %i to i64
  store i32 %inc, i32* %i, align 4, !dbg !60
  call void @__dp_report_bb(i32 10)
  %31 = load i32, i32* %__dp_bb, align 4
  call void @__dp_report_bb_pair(i32 %31, i32 17)
  store i32 1, i32* %__dp_bb, align 4
  br label %for.cond, !dbg !61, !llvm.loop !62

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16406, i32 0)
  call void @llvm.dbg.declare(metadata i64* %w, metadata !64, metadata !DIExpression()), !dbg !66
  %32 = ptrtoint i64* %w to i64
  store i64 0, i64* %w, align 8, !dbg !66
  call void @llvm.dbg.declare(metadata i32* %i1, metadata !67, metadata !DIExpression()), !dbg !69
  %33 = ptrtoint i32* %i1 to i64
  store i32 0, i32* %i1, align 4, !dbg !69
  call void @__dp_report_bb(i32 8)
  br label %for.cond2, !dbg !70

for.cond2:                                        ; preds = %for.inc10, %for.end
  call void @__dp_loop_entry(i32 16409, i32 1)
  %34 = ptrtoint i32* %i1 to i64
  %35 = load i32, i32* %i1, align 4, !dbg !71
  %36 = ptrtoint i32* %N to i64
  %37 = load i32, i32* %N, align 4, !dbg !73
  %cmp3 = icmp slt i32 %35, %37, !dbg !74
  call void @__dp_incr_taken_branch_counter(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.9, i32 0, i32 0), i1 %cmp3, i32 1), !dbg !75
  call void @__dp_incr_taken_branch_counter(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.10, i32 0, i32 0), i1 %cmp3, i32 0), !dbg !75
  call void @__dp_report_bb(i32 12)
  %38 = load i32, i32* %__dp_bb13, align 4
  call void @__dp_report_bb_pair(i32 %38, i32 18)
  br i1 %cmp3, label %for.body4, label %for.end12, !dbg !75

for.body4:                                        ; preds = %for.cond2
  call void @__dp_loop_incr(i32 1)
  %39 = ptrtoint i32* %i1 to i64
  %40 = load i32, i32* %i1, align 4, !dbg !76
  call void @__dp_call(i32 16410), !dbg !78
  %call = call i32 @_Z1gi(i32 %40), !dbg !78
  %idxprom5 = sext i32 %call to i64, !dbg !79
  %arrayidx6 = getelementptr inbounds i32, i32* %vla, i64 %idxprom5, !dbg !79
  %41 = ptrtoint i32* %arrayidx6 to i64
  call void @__dp_read(i32 16410, i64 %41, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.26, i32 0, i32 0))
  %42 = load i32, i32* %arrayidx6, align 4, !dbg !79
  %conv = sext i32 %42 to i64, !dbg !79
  %43 = ptrtoint i64* %w to i64
  %44 = load i64, i64* %w, align 8, !dbg !80
  %add = add nsw i64 %44, %conv, !dbg !80
  %45 = ptrtoint i64* %w to i64
  store i64 %add, i64* %w, align 8, !dbg !80
  %46 = ptrtoint i32* %i1 to i64
  %47 = load i32, i32* %i1, align 4, !dbg !81
  call void @__dp_call(i32 16411), !dbg !82
  %call7 = call i32 @_Z1fi(i32 %47), !dbg !82
  %idxprom8 = sext i32 %call7 to i64, !dbg !83
  %arrayidx9 = getelementptr inbounds i32, i32* %vla, i64 %idxprom8, !dbg !83
  %48 = ptrtoint i32* %arrayidx9 to i64
  call void @__dp_write(i32 16411, i64 %48, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.26, i32 0, i32 0))
  store i32 1, i32* %arrayidx9, align 4, !dbg !84
  call void @__dp_report_bb(i32 14)
  %49 = load i32, i32* %__dp_bb13, align 4
  call void @__dp_report_bb_pair(i32 %49, i32 20)
  %50 = load i32, i32* %__dp_bb14, align 4
  call void @__dp_report_bb_pair(i32 %50, i32 21)
  store i32 1, i32* %__dp_bb14, align 4
  br label %for.inc10, !dbg !85

for.inc10:                                        ; preds = %for.body4
  %51 = ptrtoint i32* %i1 to i64
  %52 = load i32, i32* %i1, align 4, !dbg !86
  %inc11 = add nsw i32 %52, 1, !dbg !86
  %53 = ptrtoint i32* %i1 to i64
  store i32 %inc11, i32* %i1, align 4, !dbg !86
  call void @__dp_report_bb(i32 13)
  %54 = load i32, i32* %__dp_bb13, align 4
  call void @__dp_report_bb_pair(i32 %54, i32 19)
  store i32 1, i32* %__dp_bb13, align 4
  br label %for.cond2, !dbg !87, !llvm.loop !88

for.end12:                                        ; preds = %for.cond2
  call void @__dp_loop_exit(i32 16413, i32 1)
  %55 = ptrtoint i8** %saved_stack to i64
  %56 = load i8*, i8** %saved_stack, align 8, !dbg !90
  call void @__dp_call(i32 16413), !dbg !90
  call void @llvm.stackrestore(i8* %56), !dbg !90
  %57 = ptrtoint i32* %retval to i64
  %58 = load i32, i32* %retval, align 4, !dbg !90
  call void @__dp_report_bb(i32 11)
  call void @__dp_finalize(i32 16413), !dbg !90
  call void @__dp_loop_output(), !dbg !90
  call void @__dp_taken_branch_counter_output(), !dbg !90
  ret i32 %58, !dbg !90
}

; Function Attrs: nounwind
declare i8* @llvm.stacksave() #3

; Function Attrs: nounwind
declare void @llvm.stackrestore(i8*) #3

declare void @__dp_init(i32, i32, i32)

declare void @__dp_finalize(i32)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_write(i32, i64, i8*)

declare void @__dp_alloca(i32, i8*, i64, i64, i64, i64)

declare void @__dp_new(i32, i64, i64, i64)

declare void @__dp_delete(i32, i64)

declare void @__dp_call(i32)

declare void @__dp_func_entry(i32, i32)

declare void @__dp_func_exit(i32, i32)

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_loop_exit(i32, i32)

declare void @__dp_incr_taken_branch_counter(i8*, i32, i32)

declare void @__dp_report_bb(i32)

declare void @__dp_report_bb_pair(i32, i32)

declare void @__dp_loop_incr(i32)

declare void @__dp_loop_output()

declare void @__dp_taken_branch_counter_output()

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { noinline norecurse nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5, !6}
!llvm.ident = !{!7}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !1, producer: "clang version 11.1.0 (https://github.com/llvm/llvm-project.git 7e99bddfeaab2713a8bb6ca538da25b66e6efc59)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "code.cpp", directory: "/home/lukas/git/discopop/test/end_to_end/reduction_pattern/negative/case_1/src")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{i32 7, !"PIC Level", i32 2}
!7 = !{!"clang version 11.1.0 (https://github.com/llvm/llvm-project.git 7e99bddfeaab2713a8bb6ca538da25b66e6efc59)"}
!8 = distinct !DISubprogram(name: "f", linkageName: "_Z1fi", scope: !1, file: !1, line: 3, type: !9, scopeLine: 3, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!9 = !DISubroutineType(types: !10)
!10 = !{!11, !11}
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !DILocalVariable(name: "i", arg: 1, scope: !8, file: !1, line: 3, type: !11)
!13 = !DILocation(line: 3, column: 11, scope: !8)
!14 = !DILocation(line: 4, column: 7, scope: !15)
!15 = distinct !DILexicalBlock(scope: !8, file: !1, line: 4, column: 7)
!16 = !DILocation(line: 4, column: 9, scope: !15)
!17 = !DILocation(line: 4, column: 7, scope: !8)
!18 = !DILocation(line: 5, column: 12, scope: !19)
!19 = distinct !DILexicalBlock(scope: !15, file: !1, line: 4, column: 23)
!20 = !DILocation(line: 5, column: 14, scope: !19)
!21 = !DILocation(line: 5, column: 5, scope: !19)
!22 = !DILocation(line: 7, column: 12, scope: !23)
!23 = distinct !DILexicalBlock(scope: !15, file: !1, line: 6, column: 10)
!24 = !DILocation(line: 7, column: 5, scope: !23)
!25 = !DILocation(line: 9, column: 1, scope: !8)
!26 = distinct !DISubprogram(name: "g", linkageName: "_Z1gi", scope: !1, file: !1, line: 11, type: !9, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!27 = !DILocalVariable(name: "i", arg: 1, scope: !26, file: !1, line: 11, type: !11)
!28 = !DILocation(line: 11, column: 11, scope: !26)
!29 = !DILocation(line: 11, column: 23, scope: !26)
!30 = !DILocation(line: 11, column: 16, scope: !26)
!31 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 13, type: !32, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!32 = !DISubroutineType(types: !33)
!33 = !{!11}
!34 = !DILocalVariable(name: "N", scope: !31, file: !1, line: 14, type: !11)
!35 = !DILocation(line: 14, column: 7, scope: !31)
!36 = !DILocation(line: 15, column: 11, scope: !31)
!37 = !DILocation(line: 15, column: 3, scope: !31)
!38 = !DILocalVariable(name: "__vla_expr0", scope: !31, type: !39, flags: DIFlagArtificial)
!39 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!40 = !DILocation(line: 0, scope: !31)
!41 = !DILocalVariable(name: "Arr", scope: !31, file: !1, line: 15, type: !42)
!42 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, elements: !43)
!43 = !{!44}
!44 = !DISubrange(count: !38)
!45 = !DILocation(line: 15, column: 7, scope: !31)
!46 = !DILocalVariable(name: "i", scope: !47, file: !1, line: 18, type: !11)
!47 = distinct !DILexicalBlock(scope: !31, file: !1, line: 18, column: 3)
!48 = !DILocation(line: 18, column: 12, scope: !47)
!49 = !DILocation(line: 18, column: 8, scope: !47)
!50 = !DILocation(line: 18, column: 19, scope: !51)
!51 = distinct !DILexicalBlock(scope: !47, file: !1, line: 18, column: 3)
!52 = !DILocation(line: 18, column: 23, scope: !51)
!53 = !DILocation(line: 18, column: 21, scope: !51)
!54 = !DILocation(line: 18, column: 3, scope: !47)
!55 = !DILocation(line: 19, column: 9, scope: !56)
!56 = distinct !DILexicalBlock(scope: !51, file: !1, line: 18, column: 31)
!57 = !DILocation(line: 19, column: 5, scope: !56)
!58 = !DILocation(line: 19, column: 12, scope: !56)
!59 = !DILocation(line: 20, column: 3, scope: !56)
!60 = !DILocation(line: 18, column: 27, scope: !51)
!61 = !DILocation(line: 18, column: 3, scope: !51)
!62 = distinct !{!62, !54, !63}
!63 = !DILocation(line: 20, column: 3, scope: !47)
!64 = !DILocalVariable(name: "w", scope: !31, file: !1, line: 22, type: !65)
!65 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!66 = !DILocation(line: 22, column: 8, scope: !31)
!67 = !DILocalVariable(name: "i", scope: !68, file: !1, line: 25, type: !11)
!68 = distinct !DILexicalBlock(scope: !31, file: !1, line: 25, column: 3)
!69 = !DILocation(line: 25, column: 12, scope: !68)
!70 = !DILocation(line: 25, column: 8, scope: !68)
!71 = !DILocation(line: 25, column: 19, scope: !72)
!72 = distinct !DILexicalBlock(scope: !68, file: !1, line: 25, column: 3)
!73 = !DILocation(line: 25, column: 23, scope: !72)
!74 = !DILocation(line: 25, column: 21, scope: !72)
!75 = !DILocation(line: 25, column: 3, scope: !68)
!76 = !DILocation(line: 26, column: 16, scope: !77)
!77 = distinct !DILexicalBlock(scope: !72, file: !1, line: 25, column: 31)
!78 = !DILocation(line: 26, column: 14, scope: !77)
!79 = !DILocation(line: 26, column: 10, scope: !77)
!80 = !DILocation(line: 26, column: 7, scope: !77)
!81 = !DILocation(line: 27, column: 11, scope: !77)
!82 = !DILocation(line: 27, column: 9, scope: !77)
!83 = !DILocation(line: 27, column: 5, scope: !77)
!84 = !DILocation(line: 27, column: 15, scope: !77)
!85 = !DILocation(line: 28, column: 3, scope: !77)
!86 = !DILocation(line: 25, column: 27, scope: !72)
!87 = !DILocation(line: 25, column: 3, scope: !72)
!88 = distinct !{!88, !75, !89}
!89 = !DILocation(line: 28, column: 3, scope: !68)
!90 = !DILocation(line: 29, column: 1, scope: !31)
