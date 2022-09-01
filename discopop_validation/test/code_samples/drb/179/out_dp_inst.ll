; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"argc\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"argv\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"N\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"i\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !10 {
entry:
  call void @__dp_func_entry(i32 16405, i32 1)
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %A = alloca i32*, align 8
  %N = alloca i32, align 4
  %i = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16405, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  %1 = ptrtoint i32* %argc.addr to i64
  call void @__dp_write(i32 16405, i64 %1, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i32 0, i32 0))
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !16, metadata !DIExpression()), !dbg !17
  %2 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_write(i32 16405, i64 %2, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i32 0, i32 0))
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32** %A, metadata !20, metadata !DIExpression()), !dbg !21
  call void @llvm.dbg.declare(metadata i32* %N, metadata !22, metadata !DIExpression()), !dbg !23
  %3 = ptrtoint i32* %N to i64
  call void @__dp_write(i32 16408, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 100, i32* %N, align 4, !dbg !23
  %4 = ptrtoint i32* %N to i64
  call void @__dp_read(i32 16410, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %5 = load i32, i32* %N, align 4, !dbg !24
  %conv = sext i32 %5 to i64, !dbg !24
  %mul = mul i64 4, %conv, !dbg !25
  call void @__dp_call(i32 16410), !dbg !26
  %call = call noalias i8* @malloc(i64 %mul) #3, !dbg !26
  %6 = bitcast i8* %call to i32*, !dbg !27
  %7 = ptrtoint i32** %A to i64
  call void @__dp_write(i32 16410, i64 %7, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32* %6, i32** %A, align 8, !dbg !28
  call void @llvm.dbg.declare(metadata i32* %i, metadata !29, metadata !DIExpression()), !dbg !31
  %8 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16414, i64 %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !31
  br label %for.cond, !dbg !32

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16414, i32 0)
  %9 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16414, i64 %9, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %10 = load i32, i32* %i, align 4, !dbg !33
  %11 = ptrtoint i32* %N to i64
  call void @__dp_read(i32 16414, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %12 = load i32, i32* %N, align 4, !dbg !35
  %cmp = icmp slt i32 %10, %12, !dbg !36
  br i1 %cmp, label %for.body, label %for.end, !dbg !37

for.body:                                         ; preds = %for.cond
  %13 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16415, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %14 = load i32, i32* %i, align 4, !dbg !38
  %15 = ptrtoint i32** %A to i64
  call void @__dp_read(i32 16415, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %16 = load i32*, i32** %A, align 8, !dbg !40
  %17 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16415, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %18 = load i32, i32* %i, align 4, !dbg !41
  %idxprom = sext i32 %18 to i64, !dbg !40
  %arrayidx = getelementptr inbounds i32, i32* %16, i64 %idxprom, !dbg !40
  %19 = ptrtoint i32* %arrayidx to i64
  call void @__dp_write(i32 16415, i64 %19, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 %14, i32* %arrayidx, align 4, !dbg !42
  %20 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16416, i64 %20, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %21 = load i32, i32* %i, align 4, !dbg !43
  %cmp2 = icmp eq i32 %21, 1, !dbg !45
  br i1 %cmp2, label %if.then, label %if.end, !dbg !46

if.then:                                          ; preds = %for.body
  %22 = ptrtoint i32** %A to i64
  call void @__dp_read(i32 16418, i64 %22, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %23 = load i32*, i32** %A, align 8, !dbg !47
  %arrayidx4 = getelementptr inbounds i32, i32* %23, i64 0, !dbg !47
  %24 = ptrtoint i32* %arrayidx4 to i64
  call void @__dp_write(i32 16418, i64 %24, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 1, i32* %arrayidx4, align 4, !dbg !49
  br label %if.end, !dbg !50

if.end:                                           ; preds = %if.then, %for.body
  br label %for.inc, !dbg !51

for.inc:                                          ; preds = %if.end
  %25 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16414, i64 %25, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %26 = load i32, i32* %i, align 4, !dbg !52
  %inc = add nsw i32 %26, 1, !dbg !52
  %27 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16414, i64 %27, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !52
  br label %for.cond, !dbg !53, !llvm.loop !54

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16422, i32 0)
  %28 = ptrtoint i32** %A to i64
  call void @__dp_read(i32 16422, i64 %28, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %29 = load i32*, i32** %A, align 8, !dbg !56
  %30 = bitcast i32* %29 to i8*, !dbg !56
  call void @__dp_call(i32 16422), !dbg !57
  call void @free(i8* %30) #3, !dbg !57
  call void @__dp_finalize(i32 16423), !dbg !58
  ret i32 0, !dbg !58
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_call(i32)

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64) #2

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_loop_exit(i32, i32)

; Function Attrs: nounwind
declare dso_local void @free(i8*) #2

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!6}
!llvm.module.flags = !{!7, !8, !9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/179")
!2 = !{}
!3 = !{!4}
!4 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!5 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!6 = !{!"Ubuntu clang version 11.1.0-6"}
!7 = !{i32 7, !"Dwarf Version", i32 4}
!8 = !{i32 2, !"Debug Info Version", i32 3}
!9 = !{i32 1, !"wchar_size", i32 4}
!10 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 21, type: !11, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!11 = !DISubroutineType(types: !12)
!12 = !{!5, !5, !13}
!13 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!15 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!16 = !DILocalVariable(name: "argc", arg: 1, scope: !10, file: !1, line: 21, type: !5)
!17 = !DILocation(line: 21, column: 14, scope: !10)
!18 = !DILocalVariable(name: "argv", arg: 2, scope: !10, file: !1, line: 21, type: !13)
!19 = !DILocation(line: 21, column: 26, scope: !10)
!20 = !DILocalVariable(name: "A", scope: !10, file: !1, line: 23, type: !4)
!21 = !DILocation(line: 23, column: 8, scope: !10)
!22 = !DILocalVariable(name: "N", scope: !10, file: !1, line: 24, type: !5)
!23 = !DILocation(line: 24, column: 7, scope: !10)
!24 = !DILocation(line: 26, column: 35, scope: !10)
!25 = !DILocation(line: 26, column: 33, scope: !10)
!26 = !DILocation(line: 26, column: 14, scope: !10)
!27 = !DILocation(line: 26, column: 7, scope: !10)
!28 = !DILocation(line: 26, column: 5, scope: !10)
!29 = !DILocalVariable(name: "i", scope: !30, file: !1, line: 30, type: !5)
!30 = distinct !DILexicalBlock(scope: !10, file: !1, line: 30, column: 3)
!31 = !DILocation(line: 30, column: 11, scope: !30)
!32 = !DILocation(line: 30, column: 7, scope: !30)
!33 = !DILocation(line: 30, column: 18, scope: !34)
!34 = distinct !DILexicalBlock(scope: !30, file: !1, line: 30, column: 3)
!35 = !DILocation(line: 30, column: 22, scope: !34)
!36 = !DILocation(line: 30, column: 20, scope: !34)
!37 = !DILocation(line: 30, column: 3, scope: !30)
!38 = !DILocation(line: 31, column: 12, scope: !39)
!39 = distinct !DILexicalBlock(scope: !34, file: !1, line: 30, column: 30)
!40 = !DILocation(line: 31, column: 5, scope: !39)
!41 = !DILocation(line: 31, column: 7, scope: !39)
!42 = !DILocation(line: 31, column: 10, scope: !39)
!43 = !DILocation(line: 32, column: 9, scope: !44)
!44 = distinct !DILexicalBlock(scope: !39, file: !1, line: 32, column: 9)
!45 = !DILocation(line: 32, column: 11, scope: !44)
!46 = !DILocation(line: 32, column: 9, scope: !39)
!47 = !DILocation(line: 34, column: 7, scope: !48)
!48 = distinct !DILexicalBlock(scope: !44, file: !1, line: 33, column: 5)
!49 = !DILocation(line: 34, column: 12, scope: !48)
!50 = !DILocation(line: 35, column: 5, scope: !48)
!51 = !DILocation(line: 36, column: 3, scope: !39)
!52 = !DILocation(line: 30, column: 26, scope: !34)
!53 = !DILocation(line: 30, column: 3, scope: !34)
!54 = distinct !{!54, !37, !55}
!55 = !DILocation(line: 36, column: 3, scope: !30)
!56 = !DILocation(line: 38, column: 8, scope: !10)
!57 = !DILocation(line: 38, column: 3, scope: !10)
!58 = !DILocation(line: 39, column: 3, scope: !10)
