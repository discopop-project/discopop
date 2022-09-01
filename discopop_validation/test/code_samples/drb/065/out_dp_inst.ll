; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.1 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"argc\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"argv\00", align 1
@.str.4 = private unnamed_addr constant [3 x i8] c"pi\00", align 1
@.str.5 = private unnamed_addr constant [15 x i8] c"interval_width\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.7 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str = private unnamed_addr constant [7 x i8] c"PI=%f\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !9 {
entry:
  call void @__dp_func_entry(i32 16438, i32 1)
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %pi = alloca double, align 8
  %i = alloca i64, align 8
  %x = alloca double, align 8
  %interval_width = alloca double, align 8
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16438, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  %1 = ptrtoint i32* %argc.addr to i64
  call void @__dp_write(i32 16438, i64 %1, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i32 0, i32 0))
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !16, metadata !DIExpression()), !dbg !17
  %2 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_write(i32 16438, i64 %2, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0))
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata double* %pi, metadata !20, metadata !DIExpression()), !dbg !21
  %3 = ptrtoint double* %pi to i64
  call void @__dp_write(i32 16440, i64 %3, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0))
  store double 0.000000e+00, double* %pi, align 8, !dbg !21
  call void @llvm.dbg.declare(metadata i64* %i, metadata !22, metadata !DIExpression()), !dbg !24
  call void @llvm.dbg.declare(metadata double* %x, metadata !25, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.declare(metadata double* %interval_width, metadata !27, metadata !DIExpression()), !dbg !28
  %4 = ptrtoint double* %interval_width to i64
  call void @__dp_write(i32 16443, i64 %4, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.5, i32 0, i32 0))
  store double 5.000000e-10, double* %interval_width, align 8, !dbg !29
  %5 = ptrtoint i64* %i to i64
  call void @__dp_write(i32 16446, i64 %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i64 0, i64* %i, align 8, !dbg !30
  br label %for.cond, !dbg !32

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16446, i32 0)
  %6 = ptrtoint i64* %i to i64
  call void @__dp_read(i32 16446, i64 %6, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %7 = load i64, i64* %i, align 8, !dbg !33
  %cmp = icmp slt i64 %7, 2000000000, !dbg !35
  br i1 %cmp, label %for.body, label %for.end, !dbg !36

for.body:                                         ; preds = %for.cond
  %8 = ptrtoint i64* %i to i64
  call void @__dp_read(i32 16447, i64 %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %9 = load i64, i64* %i, align 8, !dbg !37
  %conv = sitofp i64 %9 to double, !dbg !37
  %add = fadd double %conv, 5.000000e-01, !dbg !39
  %10 = ptrtoint double* %interval_width to i64
  call void @__dp_read(i32 16447, i64 %10, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.5, i32 0, i32 0))
  %11 = load double, double* %interval_width, align 8, !dbg !40
  %mul = fmul double %add, %11, !dbg !41
  %12 = ptrtoint double* %x to i64
  call void @__dp_write(i32 16447, i64 %12, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store double %mul, double* %x, align 8, !dbg !42
  %13 = ptrtoint double* %x to i64
  call void @__dp_read(i32 16448, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %14 = load double, double* %x, align 8, !dbg !43
  %15 = ptrtoint double* %x to i64
  call void @__dp_read(i32 16448, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %16 = load double, double* %x, align 8, !dbg !44
  %mul1 = fmul double %14, %16, !dbg !45
  %add2 = fadd double %mul1, 1.000000e+00, !dbg !46
  %div = fdiv double 1.000000e+00, %add2, !dbg !47
  %17 = ptrtoint double* %pi to i64
  call void @__dp_read(i32 16448, i64 %17, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0))
  %18 = load double, double* %pi, align 8, !dbg !48
  %add3 = fadd double %18, %div, !dbg !48
  %19 = ptrtoint double* %pi to i64
  call void @__dp_write(i32 16448, i64 %19, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0))
  store double %add3, double* %pi, align 8, !dbg !48
  br label %for.inc, !dbg !49

for.inc:                                          ; preds = %for.body
  %20 = ptrtoint i64* %i to i64
  call void @__dp_read(i32 16446, i64 %20, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %21 = load i64, i64* %i, align 8, !dbg !50
  %inc = add nsw i64 %21, 1, !dbg !50
  %22 = ptrtoint i64* %i to i64
  call void @__dp_write(i32 16446, i64 %22, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i64 %inc, i64* %i, align 8, !dbg !50
  br label %for.cond, !dbg !51, !llvm.loop !52

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16451, i32 0)
  %23 = ptrtoint double* %pi to i64
  call void @__dp_read(i32 16451, i64 %23, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0))
  %24 = load double, double* %pi, align 8, !dbg !54
  %mul4 = fmul double %24, 4.000000e+00, !dbg !55
  %25 = ptrtoint double* %interval_width to i64
  call void @__dp_read(i32 16451, i64 %25, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.5, i32 0, i32 0))
  %26 = load double, double* %interval_width, align 8, !dbg !56
  %mul5 = fmul double %mul4, %26, !dbg !57
  %27 = ptrtoint double* %pi to i64
  call void @__dp_write(i32 16451, i64 %27, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0))
  store double %mul5, double* %pi, align 8, !dbg !58
  %28 = ptrtoint double* %pi to i64
  call void @__dp_read(i32 16452, i64 %28, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.4, i32 0, i32 0))
  %29 = load double, double* %pi, align 8, !dbg !59
  call void @__dp_call(i32 16452), !dbg !60
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i64 0, i64 0), double %29), !dbg !60
  call void @__dp_finalize(i32 16453), !dbg !61
  ret i32 0, !dbg !61
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_loop_exit(i32, i32)

declare void @__dp_call(i32)

declare dso_local i32 @printf(i8*, ...) #2

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!5}
!llvm.module.flags = !{!6, !7, !8}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/065")
!2 = !{}
!3 = !{!4}
!4 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!5 = !{!"Ubuntu clang version 11.1.0-6"}
!6 = !{i32 7, !"Dwarf Version", i32 4}
!7 = !{i32 2, !"Debug Info Version", i32 3}
!8 = !{i32 1, !"wchar_size", i32 4}
!9 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 54, type: !10, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!10 = !DISubroutineType(types: !11)
!11 = !{!12, !12, !13}
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!15 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!16 = !DILocalVariable(name: "argc", arg: 1, scope: !9, file: !1, line: 54, type: !12)
!17 = !DILocation(line: 54, column: 14, scope: !9)
!18 = !DILocalVariable(name: "argv", arg: 2, scope: !9, file: !1, line: 54, type: !13)
!19 = !DILocation(line: 54, column: 27, scope: !9)
!20 = !DILocalVariable(name: "pi", scope: !9, file: !1, line: 56, type: !4)
!21 = !DILocation(line: 56, column: 10, scope: !9)
!22 = !DILocalVariable(name: "i", scope: !9, file: !1, line: 57, type: !23)
!23 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!24 = !DILocation(line: 57, column: 12, scope: !9)
!25 = !DILocalVariable(name: "x", scope: !9, file: !1, line: 58, type: !4)
!26 = !DILocation(line: 58, column: 10, scope: !9)
!27 = !DILocalVariable(name: "interval_width", scope: !9, file: !1, line: 58, type: !4)
!28 = !DILocation(line: 58, column: 13, scope: !9)
!29 = !DILocation(line: 59, column: 18, scope: !9)
!30 = !DILocation(line: 62, column: 10, scope: !31)
!31 = distinct !DILexicalBlock(scope: !9, file: !1, line: 62, column: 3)
!32 = !DILocation(line: 62, column: 8, scope: !31)
!33 = !DILocation(line: 62, column: 15, scope: !34)
!34 = distinct !DILexicalBlock(scope: !31, file: !1, line: 62, column: 3)
!35 = !DILocation(line: 62, column: 17, scope: !34)
!36 = !DILocation(line: 62, column: 3, scope: !31)
!37 = !DILocation(line: 63, column: 10, scope: !38)
!38 = distinct !DILexicalBlock(scope: !34, file: !1, line: 62, column: 35)
!39 = !DILocation(line: 63, column: 11, scope: !38)
!40 = !DILocation(line: 63, column: 20, scope: !38)
!41 = !DILocation(line: 63, column: 18, scope: !38)
!42 = !DILocation(line: 63, column: 7, scope: !38)
!43 = !DILocation(line: 64, column: 18, scope: !38)
!44 = !DILocation(line: 64, column: 20, scope: !38)
!45 = !DILocation(line: 64, column: 19, scope: !38)
!46 = !DILocation(line: 64, column: 22, scope: !38)
!47 = !DILocation(line: 64, column: 15, scope: !38)
!48 = !DILocation(line: 64, column: 8, scope: !38)
!49 = !DILocation(line: 65, column: 3, scope: !38)
!50 = !DILocation(line: 62, column: 31, scope: !34)
!51 = !DILocation(line: 62, column: 3, scope: !34)
!52 = distinct !{!52, !36, !53}
!53 = !DILocation(line: 65, column: 3, scope: !31)
!54 = !DILocation(line: 67, column: 8, scope: !9)
!55 = !DILocation(line: 67, column: 11, scope: !9)
!56 = !DILocation(line: 67, column: 19, scope: !9)
!57 = !DILocation(line: 67, column: 17, scope: !9)
!58 = !DILocation(line: 67, column: 6, scope: !9)
!59 = !DILocation(line: 68, column: 22, scope: !9)
!60 = !DILocation(line: 68, column: 3, scope: !9)
!61 = !DILocation(line: 69, column: 3, scope: !9)
