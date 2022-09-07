; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@a = dso_local global [100 x i32] zeroinitializer, align 16, !dbg !0
@.str.1 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.3 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str = private unnamed_addr constant [38 x i8] c"warning: a[%d] = %d, not expected %d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @gen_task(i32 %i) #0 !dbg !14 {
entry:
  call void @__dp_func_entry(i32 16440, i32 0)
  %i.addr = alloca i32, align 4
  %0 = ptrtoint i32* %i.addr to i64
  call void @__dp_write(i32 16440, i64 %0, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 %i, i32* %i.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %i.addr, metadata !17, metadata !DIExpression()), !dbg !18
  %1 = ptrtoint i32* %i.addr to i64
  call void @__dp_read(i32 16444, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %2 = load i32, i32* %i.addr, align 4, !dbg !19
  %add = add nsw i32 %2, 1, !dbg !21
  %3 = ptrtoint i32* %i.addr to i64
  call void @__dp_read(i32 16444, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %4 = load i32, i32* %i.addr, align 4, !dbg !22
  %idxprom = sext i32 %4 to i64, !dbg !23
  %arrayidx = getelementptr inbounds [100 x i32], [100 x i32]* @a, i64 0, i64 %idxprom, !dbg !23
  %5 = ptrtoint i32* %arrayidx to i64
  call void @__dp_write(i32 16444, i64 %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 %add, i32* %arrayidx, align 4, !dbg !24
  call void @__dp_func_exit(i32 16446, i32 0), !dbg !25
  ret void, !dbg !25
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_func_exit(i32, i32)

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !26 {
entry:
  call void @__dp_func_entry(i32 16448, i32 1)
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16448, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !29, metadata !DIExpression()), !dbg !30
  %1 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16450, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !30
  %2 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16455, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !31
  br label %for.cond, !dbg !35

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16455, i32 0)
  %3 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16455, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %4 = load i32, i32* %i, align 4, !dbg !36
  %cmp = icmp slt i32 %4, 100, !dbg !38
  br i1 %cmp, label %for.body, label %for.end, !dbg !39

for.body:                                         ; preds = %for.cond
  %5 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16457, i64 %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %6 = load i32, i32* %i, align 4, !dbg !40
  call void @__dp_call(i32 16457), !dbg !42
  call void @gen_task(i32 %6), !dbg !42
  br label %for.inc, !dbg !43

for.inc:                                          ; preds = %for.body
  %7 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16455, i64 %7, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %8 = load i32, i32* %i, align 4, !dbg !44
  %inc = add nsw i32 %8, 1, !dbg !44
  %9 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16455, i64 %9, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !44
  br label %for.cond, !dbg !45, !llvm.loop !46

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16463, i32 0)
  %10 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16463, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !48
  br label %for.cond1, !dbg !50

for.cond1:                                        ; preds = %for.inc8, %for.end
  call void @__dp_loop_entry(i32 16463, i32 1)
  %11 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16463, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %12 = load i32, i32* %i, align 4, !dbg !51
  %cmp2 = icmp slt i32 %12, 100, !dbg !53
  br i1 %cmp2, label %for.body3, label %for.end10, !dbg !54

for.body3:                                        ; preds = %for.cond1
  %13 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16466, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %14 = load i32, i32* %i, align 4, !dbg !55
  %idxprom = sext i32 %14 to i64, !dbg !58
  %arrayidx = getelementptr inbounds [100 x i32], [100 x i32]* @a, i64 0, i64 %idxprom, !dbg !58
  %15 = ptrtoint i32* %arrayidx to i64
  call void @__dp_read(i32 16466, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %16 = load i32, i32* %arrayidx, align 4, !dbg !58
  %17 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16466, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %18 = load i32, i32* %i, align 4, !dbg !59
  %add = add nsw i32 %18, 1, !dbg !60
  %cmp4 = icmp ne i32 %16, %add, !dbg !61
  br i1 %cmp4, label %if.then, label %if.end, !dbg !62

if.then:                                          ; preds = %for.body3
  %19 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16468, i64 %19, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %20 = load i32, i32* %i, align 4, !dbg !63
  %21 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16468, i64 %21, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %22 = load i32, i32* %i, align 4, !dbg !65
  %idxprom5 = sext i32 %22 to i64, !dbg !66
  %arrayidx6 = getelementptr inbounds [100 x i32], [100 x i32]* @a, i64 0, i64 %idxprom5, !dbg !66
  %23 = ptrtoint i32* %arrayidx6 to i64
  call void @__dp_read(i32 16468, i64 %23, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %24 = load i32, i32* %arrayidx6, align 4, !dbg !66
  %25 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16468, i64 %25, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %26 = load i32, i32* %i, align 4, !dbg !67
  %add7 = add nsw i32 %26, 1, !dbg !68
  call void @__dp_call(i32 16468), !dbg !69
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([38 x i8], [38 x i8]* @.str, i64 0, i64 0), i32 %20, i32 %24, i32 %add7), !dbg !69
  br label %if.end, !dbg !70

if.end:                                           ; preds = %if.then, %for.body3
  br label %for.inc8, !dbg !71

for.inc8:                                         ; preds = %if.end
  %27 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16463, i64 %27, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %28 = load i32, i32* %i, align 4, !dbg !72
  %inc9 = add nsw i32 %28, 1, !dbg !72
  %29 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16463, i64 %29, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 %inc9, i32* %i, align 4, !dbg !72
  br label %for.cond1, !dbg !73, !llvm.loop !74

for.end10:                                        ; preds = %for.cond1
  call void @__dp_loop_exit(i32 16471, i32 1)
  call void @__dp_finalize(i32 16471), !dbg !76
  ret i32 0, !dbg !76
}

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_call(i32)

declare void @__dp_loop_exit(i32, i32)

declare dso_local i32 @printf(i8*, ...) #2

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!10}
!llvm.module.flags = !{!11, !12, !13}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 54, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/101")
!4 = !{}
!5 = !{!0}
!6 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 3200, elements: !8)
!7 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!8 = !{!9}
!9 = !DISubrange(count: 100)
!10 = !{!"Ubuntu clang version 11.1.0-6"}
!11 = !{i32 7, !"Dwarf Version", i32 4}
!12 = !{i32 2, !"Debug Info Version", i32 3}
!13 = !{i32 1, !"wchar_size", i32 4}
!14 = distinct !DISubprogram(name: "gen_task", scope: !3, file: !3, line: 56, type: !15, scopeLine: 57, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!15 = !DISubroutineType(types: !16)
!16 = !{null, !7}
!17 = !DILocalVariable(name: "i", arg: 1, scope: !14, file: !3, line: 56, type: !7)
!18 = !DILocation(line: 56, column: 19, scope: !14)
!19 = !DILocation(line: 60, column: 11, scope: !20)
!20 = distinct !DILexicalBlock(scope: !14, file: !3, line: 59, column: 3)
!21 = !DILocation(line: 60, column: 12, scope: !20)
!22 = !DILocation(line: 60, column: 7, scope: !20)
!23 = !DILocation(line: 60, column: 5, scope: !20)
!24 = !DILocation(line: 60, column: 9, scope: !20)
!25 = !DILocation(line: 62, column: 1, scope: !14)
!26 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 64, type: !27, scopeLine: 65, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!27 = !DISubroutineType(types: !28)
!28 = !{!7}
!29 = !DILocalVariable(name: "i", scope: !26, file: !3, line: 66, type: !7)
!30 = !DILocation(line: 66, column: 7, scope: !26)
!31 = !DILocation(line: 71, column: 13, scope: !32)
!32 = distinct !DILexicalBlock(scope: !33, file: !3, line: 71, column: 7)
!33 = distinct !DILexicalBlock(scope: !34, file: !3, line: 70, column: 5)
!34 = distinct !DILexicalBlock(scope: !26, file: !3, line: 68, column: 3)
!35 = !DILocation(line: 71, column: 12, scope: !32)
!36 = !DILocation(line: 71, column: 17, scope: !37)
!37 = distinct !DILexicalBlock(scope: !32, file: !3, line: 71, column: 7)
!38 = !DILocation(line: 71, column: 18, scope: !37)
!39 = !DILocation(line: 71, column: 7, scope: !32)
!40 = !DILocation(line: 73, column: 18, scope: !41)
!41 = distinct !DILexicalBlock(scope: !37, file: !3, line: 72, column: 7)
!42 = !DILocation(line: 73, column: 9, scope: !41)
!43 = !DILocation(line: 74, column: 7, scope: !41)
!44 = !DILocation(line: 71, column: 27, scope: !37)
!45 = !DILocation(line: 71, column: 7, scope: !37)
!46 = distinct !{!46, !39, !47}
!47 = !DILocation(line: 74, column: 7, scope: !32)
!48 = !DILocation(line: 79, column: 9, scope: !49)
!49 = distinct !DILexicalBlock(scope: !26, file: !3, line: 79, column: 3)
!50 = !DILocation(line: 79, column: 8, scope: !49)
!51 = !DILocation(line: 79, column: 13, scope: !52)
!52 = distinct !DILexicalBlock(scope: !49, file: !3, line: 79, column: 3)
!53 = !DILocation(line: 79, column: 14, scope: !52)
!54 = !DILocation(line: 79, column: 3, scope: !49)
!55 = !DILocation(line: 82, column: 11, scope: !56)
!56 = distinct !DILexicalBlock(scope: !57, file: !3, line: 82, column: 9)
!57 = distinct !DILexicalBlock(scope: !52, file: !3, line: 80, column: 3)
!58 = !DILocation(line: 82, column: 9, scope: !56)
!59 = !DILocation(line: 82, column: 16, scope: !56)
!60 = !DILocation(line: 82, column: 17, scope: !56)
!61 = !DILocation(line: 82, column: 13, scope: !56)
!62 = !DILocation(line: 82, column: 9, scope: !57)
!63 = !DILocation(line: 84, column: 56, scope: !64)
!64 = distinct !DILexicalBlock(scope: !56, file: !3, line: 83, column: 5)
!65 = !DILocation(line: 84, column: 61, scope: !64)
!66 = !DILocation(line: 84, column: 59, scope: !64)
!67 = !DILocation(line: 84, column: 65, scope: !64)
!68 = !DILocation(line: 84, column: 66, scope: !64)
!69 = !DILocation(line: 84, column: 7, scope: !64)
!70 = !DILocation(line: 85, column: 5, scope: !64)
!71 = !DILocation(line: 86, column: 3, scope: !57)
!72 = !DILocation(line: 79, column: 23, scope: !52)
!73 = !DILocation(line: 79, column: 3, scope: !52)
!74 = distinct !{!74, !54, !75}
!75 = !DILocation(line: 86, column: 3, scope: !49)
!76 = !DILocation(line: 87, column: 3, scope: !26)
