; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@input = dso_local global [1000 x i32] zeroinitializer, align 16, !dbg !0
@output = dso_local global [1000 x i32] zeroinitializer, align 16, !dbg !6
@.str.1 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"inLen\00", align 1
@.str.3 = private unnamed_addr constant [7 x i8] c"outLen\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.5 = private unnamed_addr constant [6 x i8] c"input\00", align 1
@.str.6 = private unnamed_addr constant [7 x i8] c"output\00", align 1
@.str.7 = private unnamed_addr constant [2 x i8] c"*\00", align 1
@.str = private unnamed_addr constant [16 x i8] c"output[500]=%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !16 {
entry:
  call void @__dp_func_entry(i32 16444, i32 1)
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %inLen = alloca i32, align 4
  %outLen = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16444, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !19, metadata !DIExpression()), !dbg !20
  call void @llvm.dbg.declare(metadata i32* %inLen, metadata !21, metadata !DIExpression()), !dbg !22
  %1 = ptrtoint i32* %inLen to i64
  call void @__dp_write(i32 16447, i64 %1, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.2, i32 0, i32 0))
  store i32 1000, i32* %inLen, align 4, !dbg !22
  call void @llvm.dbg.declare(metadata i32* %outLen, metadata !23, metadata !DIExpression()), !dbg !24
  %2 = ptrtoint i32* %outLen to i64
  call void @__dp_write(i32 16448, i64 %2, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0))
  store i32 0, i32* %outLen, align 4, !dbg !24
  %3 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16450, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !25
  br label %for.cond, !dbg !27

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16450, i32 0)
  %4 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16450, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %5 = load i32, i32* %i, align 4, !dbg !28
  %6 = ptrtoint i32* %inLen to i64
  call void @__dp_read(i32 16450, i64 %6, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.2, i32 0, i32 0))
  %7 = load i32, i32* %inLen, align 4, !dbg !30
  %cmp = icmp slt i32 %5, %7, !dbg !31
  br i1 %cmp, label %for.body, label %for.end, !dbg !32

for.body:                                         ; preds = %for.cond
  %8 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16451, i64 %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %9 = load i32, i32* %i, align 4, !dbg !33
  %10 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16451, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %11 = load i32, i32* %i, align 4, !dbg !34
  %idxprom = sext i32 %11 to i64, !dbg !35
  %arrayidx = getelementptr inbounds [1000 x i32], [1000 x i32]* @input, i64 0, i64 %idxprom, !dbg !35
  %12 = ptrtoint i32* %arrayidx to i64
  call void @__dp_write(i32 16451, i64 %12, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.5, i32 0, i32 0))
  store i32 %9, i32* %arrayidx, align 4, !dbg !36
  br label %for.inc, !dbg !35

for.inc:                                          ; preds = %for.body
  %13 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16450, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %14 = load i32, i32* %i, align 4, !dbg !37
  %inc = add nsw i32 %14, 1, !dbg !37
  %15 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16450, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !37
  br label %for.cond, !dbg !38, !llvm.loop !39

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16454, i32 0)
  %16 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16454, i64 %16, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !41
  br label %for.cond1, !dbg !43

for.cond1:                                        ; preds = %for.inc9, %for.end
  call void @__dp_loop_entry(i32 16454, i32 1)
  %17 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16454, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %18 = load i32, i32* %i, align 4, !dbg !44
  %19 = ptrtoint i32* %inLen to i64
  call void @__dp_read(i32 16454, i64 %19, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.2, i32 0, i32 0))
  %20 = load i32, i32* %inLen, align 4, !dbg !46
  %cmp2 = icmp slt i32 %18, %20, !dbg !47
  br i1 %cmp2, label %for.body3, label %for.end11, !dbg !48

for.body3:                                        ; preds = %for.cond1
  %21 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16456, i64 %21, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %22 = load i32, i32* %i, align 4, !dbg !49
  %idxprom4 = sext i32 %22 to i64, !dbg !51
  %arrayidx5 = getelementptr inbounds [1000 x i32], [1000 x i32]* @input, i64 0, i64 %idxprom4, !dbg !51
  %23 = ptrtoint i32* %arrayidx5 to i64
  call void @__dp_read(i32 16456, i64 %23, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.5, i32 0, i32 0))
  %24 = load i32, i32* %arrayidx5, align 4, !dbg !51
  %25 = ptrtoint i32* %outLen to i64
  call void @__dp_read(i32 16456, i64 %25, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0))
  %26 = load i32, i32* %outLen, align 4, !dbg !52
  %inc6 = add nsw i32 %26, 1, !dbg !52
  %27 = ptrtoint i32* %outLen to i64
  call void @__dp_write(i32 16456, i64 %27, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0))
  store i32 %inc6, i32* %outLen, align 4, !dbg !52
  %idxprom7 = sext i32 %26 to i64, !dbg !53
  %arrayidx8 = getelementptr inbounds [1000 x i32], [1000 x i32]* @output, i64 0, i64 %idxprom7, !dbg !53
  %28 = ptrtoint i32* %arrayidx8 to i64
  call void @__dp_write(i32 16456, i64 %28, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.6, i32 0, i32 0))
  store i32 %24, i32* %arrayidx8, align 4, !dbg !54
  br label %for.inc9, !dbg !55

for.inc9:                                         ; preds = %for.body3
  %29 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16454, i64 %29, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %30 = load i32, i32* %i, align 4, !dbg !56
  %inc10 = add nsw i32 %30, 1, !dbg !56
  %31 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16454, i64 %31, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 %inc10, i32* %i, align 4, !dbg !56
  br label %for.cond1, !dbg !57, !llvm.loop !58

for.end11:                                        ; preds = %for.cond1
  call void @__dp_loop_exit(i32 16459, i32 1)
  %32 = ptrtoint i32* getelementptr inbounds ([1000 x i32], [1000 x i32]* @output, i64 0, i64 500) to i64
  call void @__dp_read(i32 16459, i64 %32, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %33 = load i32, i32* getelementptr inbounds ([1000 x i32], [1000 x i32]* @output, i64 0, i64 500), align 16, !dbg !60
  call void @__dp_call(i32 16459), !dbg !61
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i64 0, i64 0), i32 %33), !dbg !61
  call void @__dp_finalize(i32 16461), !dbg !62
  ret i32 0, !dbg !62
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

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!12}
!llvm.module.flags = !{!13, !14, !15}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "input", scope: !2, file: !3, line: 57, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/018")
!4 = !{}
!5 = !{!0, !6}
!6 = !DIGlobalVariableExpression(var: !7, expr: !DIExpression())
!7 = distinct !DIGlobalVariable(name: "output", scope: !2, file: !3, line: 58, type: !8, isLocal: false, isDefinition: true)
!8 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 32000, elements: !10)
!9 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!10 = !{!11}
!11 = !DISubrange(count: 1000)
!12 = !{!"Ubuntu clang version 11.1.0-6"}
!13 = !{i32 7, !"Dwarf Version", i32 4}
!14 = !{i32 2, !"Debug Info Version", i32 3}
!15 = !{i32 1, !"wchar_size", i32 4}
!16 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 60, type: !17, scopeLine: 61, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!17 = !DISubroutineType(types: !18)
!18 = !{!9}
!19 = !DILocalVariable(name: "i", scope: !16, file: !3, line: 62, type: !9)
!20 = !DILocation(line: 62, column: 7, scope: !16)
!21 = !DILocalVariable(name: "inLen", scope: !16, file: !3, line: 63, type: !9)
!22 = !DILocation(line: 63, column: 7, scope: !16)
!23 = !DILocalVariable(name: "outLen", scope: !16, file: !3, line: 64, type: !9)
!24 = !DILocation(line: 64, column: 7, scope: !16)
!25 = !DILocation(line: 66, column: 9, scope: !26)
!26 = distinct !DILexicalBlock(scope: !16, file: !3, line: 66, column: 3)
!27 = !DILocation(line: 66, column: 8, scope: !26)
!28 = !DILocation(line: 66, column: 13, scope: !29)
!29 = distinct !DILexicalBlock(scope: !26, file: !3, line: 66, column: 3)
!30 = !DILocation(line: 66, column: 15, scope: !29)
!31 = !DILocation(line: 66, column: 14, scope: !29)
!32 = !DILocation(line: 66, column: 3, scope: !26)
!33 = !DILocation(line: 67, column: 15, scope: !29)
!34 = !DILocation(line: 67, column: 11, scope: !29)
!35 = !DILocation(line: 67, column: 5, scope: !29)
!36 = !DILocation(line: 67, column: 13, scope: !29)
!37 = !DILocation(line: 66, column: 22, scope: !29)
!38 = !DILocation(line: 66, column: 3, scope: !29)
!39 = distinct !{!39, !32, !40}
!40 = !DILocation(line: 67, column: 15, scope: !26)
!41 = !DILocation(line: 70, column: 9, scope: !42)
!42 = distinct !DILexicalBlock(scope: !16, file: !3, line: 70, column: 3)
!43 = !DILocation(line: 70, column: 8, scope: !42)
!44 = !DILocation(line: 70, column: 13, scope: !45)
!45 = distinct !DILexicalBlock(scope: !42, file: !3, line: 70, column: 3)
!46 = !DILocation(line: 70, column: 15, scope: !45)
!47 = !DILocation(line: 70, column: 14, scope: !45)
!48 = !DILocation(line: 70, column: 3, scope: !42)
!49 = !DILocation(line: 72, column: 30, scope: !50)
!50 = distinct !DILexicalBlock(scope: !45, file: !3, line: 71, column: 3)
!51 = !DILocation(line: 72, column: 24, scope: !50)
!52 = !DILocation(line: 72, column: 18, scope: !50)
!53 = !DILocation(line: 72, column: 5, scope: !50)
!54 = !DILocation(line: 72, column: 22, scope: !50)
!55 = !DILocation(line: 73, column: 3, scope: !50)
!56 = !DILocation(line: 70, column: 22, scope: !45)
!57 = !DILocation(line: 70, column: 3, scope: !45)
!58 = distinct !{!58, !48, !59}
!59 = !DILocation(line: 73, column: 3, scope: !42)
!60 = !DILocation(line: 75, column: 29, scope: !16)
!61 = !DILocation(line: 75, column: 3, scope: !16)
!62 = !DILocation(line: 77, column: 3, scope: !16)
