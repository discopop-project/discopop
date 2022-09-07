; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@o1 = dso_local global [100 x double] zeroinitializer, align 16, !dbg !0
@c = dso_local global [100 x double] zeroinitializer, align 16, !dbg !6
@.str = private unnamed_addr constant [3 x i8] c"o1\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"c\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"len\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.4 = private unnamed_addr constant [10 x i8] c"volnew_o8\00", align 1
@.str.5 = private unnamed_addr constant [7 x i8] c"retval\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo1(double* %o1, double* %c, i32 %len) #0 !dbg !16 {
entry:
  call void @__dp_func_entry(i32 16434, i32 0)
  %o1.addr = alloca double*, align 8
  %c.addr = alloca double*, align 8
  %len.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %volnew_o8 = alloca double, align 8
  %0 = ptrtoint double** %o1.addr to i64
  call void @__dp_write(i32 16434, i64 %0, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str, i32 0, i32 0))
  store double* %o1, double** %o1.addr, align 8
  call void @llvm.dbg.declare(metadata double** %o1.addr, metadata !21, metadata !DIExpression()), !dbg !22
  %1 = ptrtoint double** %c.addr to i64
  call void @__dp_write(i32 16434, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store double* %c, double** %c.addr, align 8
  call void @llvm.dbg.declare(metadata double** %c.addr, metadata !23, metadata !DIExpression()), !dbg !24
  %2 = ptrtoint i32* %len.addr to i64
  call void @__dp_write(i32 16434, i64 %2, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  store i32 %len, i32* %len.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %len.addr, metadata !25, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.declare(metadata i32* %i, metadata !27, metadata !DIExpression()), !dbg !28
  %3 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16438, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !29
  br label %for.cond, !dbg !31

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16438, i32 0)
  %4 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16438, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %5 = load i32, i32* %i, align 4, !dbg !32
  %6 = ptrtoint i32* %len.addr to i64
  call void @__dp_read(i32 16438, i64 %6, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
  %7 = load i32, i32* %len.addr, align 4, !dbg !34
  %cmp = icmp slt i32 %5, %7, !dbg !35
  br i1 %cmp, label %for.body, label %for.end, !dbg !36

for.body:                                         ; preds = %for.cond
  call void @llvm.dbg.declare(metadata double* %volnew_o8, metadata !37, metadata !DIExpression()), !dbg !39
  %8 = ptrtoint double** %c.addr to i64
  call void @__dp_read(i32 16439, i64 %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %9 = load double*, double** %c.addr, align 8, !dbg !40
  %10 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16439, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %11 = load i32, i32* %i, align 4, !dbg !41
  %idxprom = sext i32 %11 to i64, !dbg !40
  %arrayidx = getelementptr inbounds double, double* %9, i64 %idxprom, !dbg !40
  %12 = ptrtoint double* %arrayidx to i64
  call void @__dp_read(i32 16439, i64 %12, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %13 = load double, double* %arrayidx, align 8, !dbg !40
  %mul = fmul double 5.000000e-01, %13, !dbg !42
  %14 = ptrtoint double* %volnew_o8 to i64
  call void @__dp_write(i32 16439, i64 %14, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.4, i32 0, i32 0))
  store double %mul, double* %volnew_o8, align 8, !dbg !39
  %15 = ptrtoint double* %volnew_o8 to i64
  call void @__dp_read(i32 16440, i64 %15, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.4, i32 0, i32 0))
  %16 = load double, double* %volnew_o8, align 8, !dbg !43
  %17 = ptrtoint double** %o1.addr to i64
  call void @__dp_read(i32 16440, i64 %17, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str, i32 0, i32 0))
  %18 = load double*, double** %o1.addr, align 8, !dbg !44
  %19 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16440, i64 %19, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %20 = load i32, i32* %i, align 4, !dbg !45
  %idxprom1 = sext i32 %20 to i64, !dbg !44
  %arrayidx2 = getelementptr inbounds double, double* %18, i64 %idxprom1, !dbg !44
  %21 = ptrtoint double* %arrayidx2 to i64
  call void @__dp_write(i32 16440, i64 %21, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str, i32 0, i32 0))
  store double %16, double* %arrayidx2, align 8, !dbg !46
  br label %for.inc, !dbg !47

for.inc:                                          ; preds = %for.body
  %22 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16438, i64 %22, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %23 = load i32, i32* %i, align 4, !dbg !48
  %inc = add nsw i32 %23, 1, !dbg !48
  %24 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16438, i64 %24, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !48
  br label %for.cond, !dbg !49, !llvm.loop !50

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16442, i32 0)
  call void @__dp_func_exit(i32 16442, i32 0), !dbg !52
  ret void, !dbg !52
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_loop_exit(i32, i32)

declare void @__dp_func_exit(i32, i32)

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !53 {
entry:
  call void @__dp_func_entry(i32 16446, i32 1)
  %retval = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16446, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.5, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @__dp_call(i32 16448), !dbg !56
  call void @foo1(double* getelementptr inbounds ([100 x double], [100 x double]* @o1, i64 0, i64 0), double* getelementptr inbounds ([100 x double], [100 x double]* @c, i64 0, i64 0), i32 100), !dbg !56
  call void @__dp_finalize(i32 16449), !dbg !57
  ret i32 0, !dbg !57
}

declare void @__dp_call(i32)

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!12}
!llvm.module.flags = !{!13, !14, !15}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "o1", scope: !2, file: !3, line: 60, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/050")
!4 = !{}
!5 = !{!0, !6}
!6 = !DIGlobalVariableExpression(var: !7, expr: !DIExpression())
!7 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !3, line: 61, type: !8, isLocal: false, isDefinition: true)
!8 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 6400, elements: !10)
!9 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!10 = !{!11}
!11 = !DISubrange(count: 100)
!12 = !{!"Ubuntu clang version 11.1.0-6"}
!13 = !{i32 7, !"Dwarf Version", i32 4}
!14 = !{i32 2, !"Debug Info Version", i32 3}
!15 = !{i32 1, !"wchar_size", i32 4}
!16 = distinct !DISubprogram(name: "foo1", scope: !3, file: !3, line: 50, type: !17, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!17 = !DISubroutineType(types: !18)
!18 = !{null, !19, !19, !20}
!19 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 64)
!20 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!21 = !DILocalVariable(name: "o1", arg: 1, scope: !16, file: !3, line: 50, type: !19)
!22 = !DILocation(line: 50, column: 18, scope: !16)
!23 = !DILocalVariable(name: "c", arg: 2, scope: !16, file: !3, line: 50, type: !19)
!24 = !DILocation(line: 50, column: 31, scope: !16)
!25 = !DILocalVariable(name: "len", arg: 3, scope: !16, file: !3, line: 50, type: !20)
!26 = !DILocation(line: 50, column: 40, scope: !16)
!27 = !DILocalVariable(name: "i", scope: !16, file: !3, line: 52, type: !20)
!28 = !DILocation(line: 52, column: 7, scope: !16)
!29 = !DILocation(line: 54, column: 10, scope: !30)
!30 = distinct !DILexicalBlock(scope: !16, file: !3, line: 54, column: 3)
!31 = !DILocation(line: 54, column: 8, scope: !30)
!32 = !DILocation(line: 54, column: 15, scope: !33)
!33 = distinct !DILexicalBlock(scope: !30, file: !3, line: 54, column: 3)
!34 = !DILocation(line: 54, column: 19, scope: !33)
!35 = !DILocation(line: 54, column: 17, scope: !33)
!36 = !DILocation(line: 54, column: 3, scope: !30)
!37 = !DILocalVariable(name: "volnew_o8", scope: !38, file: !3, line: 55, type: !9)
!38 = distinct !DILexicalBlock(scope: !33, file: !3, line: 54, column: 29)
!39 = !DILocation(line: 55, column: 12, scope: !38)
!40 = !DILocation(line: 55, column: 30, scope: !38)
!41 = !DILocation(line: 55, column: 32, scope: !38)
!42 = !DILocation(line: 55, column: 28, scope: !38)
!43 = !DILocation(line: 56, column: 13, scope: !38)
!44 = !DILocation(line: 56, column: 5, scope: !38)
!45 = !DILocation(line: 56, column: 8, scope: !38)
!46 = !DILocation(line: 56, column: 11, scope: !38)
!47 = !DILocation(line: 57, column: 3, scope: !38)
!48 = !DILocation(line: 54, column: 24, scope: !33)
!49 = !DILocation(line: 54, column: 3, scope: !33)
!50 = distinct !{!50, !36, !51}
!51 = !DILocation(line: 57, column: 3, scope: !30)
!52 = !DILocation(line: 58, column: 1, scope: !16)
!53 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 62, type: !54, scopeLine: 63, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!54 = !DISubroutineType(types: !55)
!55 = !{!20}
!56 = !DILocation(line: 64, column: 3, scope: !53)
!57 = !DILocation(line: 65, column: 3, scope: !53)
