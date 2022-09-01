; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [7 x i8] c"newSxx\00", align 1
@.str.1 = private unnamed_addr constant [7 x i8] c"newSyy\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c"retval\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo(double* noalias %newSxx, double* noalias %newSyy, i32 %length) #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16441, i32 0)
  %newSxx.addr = alloca double*, align 8
  %newSyy.addr = alloca double*, align 8
  %length.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %0 = ptrtoint double** %newSxx.addr to i64
  call void @__dp_write(i32 16441, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  store double* %newSxx, double** %newSxx.addr, align 8
  call void @llvm.dbg.declare(metadata double** %newSxx.addr, metadata !15, metadata !DIExpression()), !dbg !16
  %1 = ptrtoint double** %newSyy.addr to i64
  call void @__dp_write(i32 16441, i64 %1, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store double* %newSyy, double** %newSyy.addr, align 8
  call void @llvm.dbg.declare(metadata double** %newSyy.addr, metadata !17, metadata !DIExpression()), !dbg !18
  %2 = ptrtoint i32* %length.addr to i64
  call void @__dp_write(i32 16441, i64 %2, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  store i32 %length, i32* %length.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %length.addr, metadata !19, metadata !DIExpression()), !dbg !20
  call void @llvm.dbg.declare(metadata i32* %i, metadata !21, metadata !DIExpression()), !dbg !22
  %3 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16446, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !23
  br label %for.cond, !dbg !25

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16446, i32 0)
  %4 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16446, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %5 = load i32, i32* %i, align 4, !dbg !26
  %6 = ptrtoint i32* %length.addr to i64
  call void @__dp_read(i32 16446, i64 %6, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  %7 = load i32, i32* %length.addr, align 4, !dbg !28
  %sub = sub nsw i32 %7, 1, !dbg !29
  %cmp = icmp sle i32 %5, %sub, !dbg !30
  br i1 %cmp, label %for.body, label %for.end, !dbg !31

for.body:                                         ; preds = %for.cond
  %8 = ptrtoint double** %newSxx.addr to i64
  call void @__dp_read(i32 16447, i64 %8, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  %9 = load double*, double** %newSxx.addr, align 8, !dbg !32
  %10 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16447, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %11 = load i32, i32* %i, align 4, !dbg !34
  %idxprom = sext i32 %11 to i64, !dbg !32
  %arrayidx = getelementptr inbounds double, double* %9, i64 %idxprom, !dbg !32
  %12 = ptrtoint double* %arrayidx to i64
  call void @__dp_write(i32 16447, i64 %12, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  store double 0.000000e+00, double* %arrayidx, align 8, !dbg !35
  %13 = ptrtoint double** %newSyy.addr to i64
  call void @__dp_read(i32 16448, i64 %13, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  %14 = load double*, double** %newSyy.addr, align 8, !dbg !36
  %15 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16448, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %16 = load i32, i32* %i, align 4, !dbg !37
  %idxprom1 = sext i32 %16 to i64, !dbg !36
  %arrayidx2 = getelementptr inbounds double, double* %14, i64 %idxprom1, !dbg !36
  %17 = ptrtoint double* %arrayidx2 to i64
  call void @__dp_write(i32 16448, i64 %17, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store double 0.000000e+00, double* %arrayidx2, align 8, !dbg !38
  br label %for.inc, !dbg !39

for.inc:                                          ; preds = %for.body
  %18 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16446, i64 %18, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %19 = load i32, i32* %i, align 4, !dbg !40
  %add = add nsw i32 %19, 1, !dbg !40
  %20 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16446, i64 %20, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 %add, i32* %i, align 4, !dbg !40
  br label %for.cond, !dbg !41, !llvm.loop !42

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16450, i32 0)
  call void @__dp_func_exit(i32 16450, i32 0), !dbg !44
  ret void, !dbg !44
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
define dso_local i32 @main() #0 !dbg !45 {
entry:
  call void @__dp_func_entry(i32 16452, i32 1)
  %retval = alloca i32, align 4
  %length = alloca i32, align 4
  %newSxx = alloca double*, align 8
  %newSyy = alloca double*, align 8
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16452, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %length, metadata !48, metadata !DIExpression()), !dbg !49
  %1 = ptrtoint i32* %length to i64
  call void @__dp_write(i32 16454, i64 %1, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  store i32 1000, i32* %length, align 4, !dbg !49
  call void @llvm.dbg.declare(metadata double** %newSxx, metadata !50, metadata !DIExpression()), !dbg !51
  %2 = ptrtoint i32* %length to i64
  call void @__dp_read(i32 16455, i64 %2, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  %3 = load i32, i32* %length, align 4, !dbg !52
  %conv = sext i32 %3 to i64, !dbg !52
  %mul = mul i64 %conv, 8, !dbg !53
  call void @__dp_call(i32 16455), !dbg !54
  %call = call noalias i8* @malloc(i64 %mul) #3, !dbg !54
  %4 = bitcast i8* %call to double*, !dbg !54
  %5 = ptrtoint double** %newSxx to i64
  call void @__dp_write(i32 16455, i64 %5, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  store double* %4, double** %newSxx, align 8, !dbg !51
  call void @llvm.dbg.declare(metadata double** %newSyy, metadata !55, metadata !DIExpression()), !dbg !56
  %6 = ptrtoint i32* %length to i64
  call void @__dp_read(i32 16456, i64 %6, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  %7 = load i32, i32* %length, align 4, !dbg !57
  %conv1 = sext i32 %7 to i64, !dbg !57
  %mul2 = mul i64 %conv1, 8, !dbg !58
  call void @__dp_call(i32 16456), !dbg !59
  %call3 = call noalias i8* @malloc(i64 %mul2) #3, !dbg !59
  %8 = bitcast i8* %call3 to double*, !dbg !59
  %9 = ptrtoint double** %newSyy to i64
  call void @__dp_write(i32 16456, i64 %9, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store double* %8, double** %newSyy, align 8, !dbg !56
  %10 = ptrtoint double** %newSxx to i64
  call void @__dp_read(i32 16458, i64 %10, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  %11 = load double*, double** %newSxx, align 8, !dbg !60
  %12 = ptrtoint double** %newSyy to i64
  call void @__dp_read(i32 16458, i64 %12, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  %13 = load double*, double** %newSyy, align 8, !dbg !61
  %14 = ptrtoint i32* %length to i64
  call void @__dp_read(i32 16458, i64 %14, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  %15 = load i32, i32* %length, align 4, !dbg !62
  call void @__dp_call(i32 16458), !dbg !63
  call void @foo(double* %11, double* %13, i32 %15), !dbg !63
  %16 = ptrtoint double** %newSxx to i64
  call void @__dp_read(i32 16460, i64 %16, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  %17 = load double*, double** %newSxx, align 8, !dbg !64
  %18 = bitcast double* %17 to i8*, !dbg !64
  call void @__dp_call(i32 16460), !dbg !65
  call void @free(i8* %18) #3, !dbg !65
  %19 = ptrtoint double** %newSyy to i64
  call void @__dp_read(i32 16461, i64 %19, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  %20 = load double*, double** %newSyy, align 8, !dbg !66
  %21 = bitcast double* %20 to i8*, !dbg !66
  call void @__dp_call(i32 16461), !dbg !67
  call void @free(i8* %21) #3, !dbg !67
  call void @__dp_finalize(i32 16462), !dbg !68
  ret i32 0, !dbg !68
}

declare void @__dp_call(i32)

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64) #2

; Function Attrs: nounwind
declare dso_local void @free(i8*) #2

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!3}
!llvm.module.flags = !{!4, !5, !6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/067")
!2 = !{}
!3 = !{!"Ubuntu clang version 11.1.0-6"}
!4 = !{i32 7, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = distinct !DISubprogram(name: "foo", scope: !1, file: !1, line: 57, type: !8, scopeLine: 58, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{null, !10, !10, !14}
!10 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !11)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "real8", file: !1, line: 55, baseType: !13)
!13 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!14 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!15 = !DILocalVariable(name: "newSxx", arg: 1, scope: !7, file: !1, line: 57, type: !10)
!16 = !DILocation(line: 57, column: 27, scope: !7)
!17 = !DILocalVariable(name: "newSyy", arg: 2, scope: !7, file: !1, line: 57, type: !10)
!18 = !DILocation(line: 57, column: 52, scope: !7)
!19 = !DILocalVariable(name: "length", arg: 3, scope: !7, file: !1, line: 57, type: !14)
!20 = !DILocation(line: 57, column: 64, scope: !7)
!21 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 59, type: !14)
!22 = !DILocation(line: 59, column: 7, scope: !7)
!23 = !DILocation(line: 62, column: 10, scope: !24)
!24 = distinct !DILexicalBlock(scope: !7, file: !1, line: 62, column: 3)
!25 = !DILocation(line: 62, column: 8, scope: !24)
!26 = !DILocation(line: 62, column: 15, scope: !27)
!27 = distinct !DILexicalBlock(scope: !24, file: !1, line: 62, column: 3)
!28 = !DILocation(line: 62, column: 20, scope: !27)
!29 = !DILocation(line: 62, column: 27, scope: !27)
!30 = !DILocation(line: 62, column: 17, scope: !27)
!31 = !DILocation(line: 62, column: 3, scope: !24)
!32 = !DILocation(line: 63, column: 5, scope: !33)
!33 = distinct !DILexicalBlock(scope: !27, file: !1, line: 62, column: 40)
!34 = !DILocation(line: 63, column: 12, scope: !33)
!35 = !DILocation(line: 63, column: 15, scope: !33)
!36 = !DILocation(line: 64, column: 5, scope: !33)
!37 = !DILocation(line: 64, column: 12, scope: !33)
!38 = !DILocation(line: 64, column: 15, scope: !33)
!39 = !DILocation(line: 65, column: 3, scope: !33)
!40 = !DILocation(line: 62, column: 34, scope: !27)
!41 = !DILocation(line: 62, column: 3, scope: !27)
!42 = distinct !{!42, !31, !43}
!43 = !DILocation(line: 65, column: 3, scope: !24)
!44 = !DILocation(line: 66, column: 1, scope: !7)
!45 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 68, type: !46, scopeLine: 69, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!46 = !DISubroutineType(types: !47)
!47 = !{!14}
!48 = !DILocalVariable(name: "length", scope: !45, file: !1, line: 70, type: !14)
!49 = !DILocation(line: 70, column: 7, scope: !45)
!50 = !DILocalVariable(name: "newSxx", scope: !45, file: !1, line: 71, type: !11)
!51 = !DILocation(line: 71, column: 10, scope: !45)
!52 = !DILocation(line: 71, column: 27, scope: !45)
!53 = !DILocation(line: 71, column: 33, scope: !45)
!54 = !DILocation(line: 71, column: 19, scope: !45)
!55 = !DILocalVariable(name: "newSyy", scope: !45, file: !1, line: 72, type: !11)
!56 = !DILocation(line: 72, column: 10, scope: !45)
!57 = !DILocation(line: 72, column: 27, scope: !45)
!58 = !DILocation(line: 72, column: 33, scope: !45)
!59 = !DILocation(line: 72, column: 19, scope: !45)
!60 = !DILocation(line: 74, column: 7, scope: !45)
!61 = !DILocation(line: 74, column: 15, scope: !45)
!62 = !DILocation(line: 74, column: 23, scope: !45)
!63 = !DILocation(line: 74, column: 3, scope: !45)
!64 = !DILocation(line: 76, column: 9, scope: !45)
!65 = !DILocation(line: 76, column: 3, scope: !45)
!66 = !DILocation(line: 77, column: 9, scope: !45)
!67 = !DILocation(line: 77, column: 3, scope: !45)
!68 = !DILocation(line: 78, column: 3, scope: !45)
