; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.1 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"argc\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"argv\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str = private unnamed_addr constant [12 x i8] c"a[1001]=%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16437, i32 1)
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %a = alloca [2000 x i32], align 16
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16437, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  %1 = ptrtoint i32* %argc.addr to i64
  call void @__dp_write(i32 16437, i64 %1, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i32 0, i32 0))
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !14, metadata !DIExpression()), !dbg !15
  %2 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_write(i32 16437, i64 %2, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0))
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !16, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.declare(metadata i32* %i, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata [2000 x i32]* %a, metadata !20, metadata !DIExpression()), !dbg !24
  %3 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16443, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !25
  br label %for.cond, !dbg !27

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16443, i32 0)
  %4 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16443, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %5 = load i32, i32* %i, align 4, !dbg !28
  %cmp = icmp slt i32 %5, 2000, !dbg !30
  br i1 %cmp, label %for.body, label %for.end, !dbg !31

for.body:                                         ; preds = %for.cond
  %6 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16444, i64 %6, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %7 = load i32, i32* %i, align 4, !dbg !32
  %8 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16444, i64 %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %9 = load i32, i32* %i, align 4, !dbg !33
  %idxprom = sext i32 %9 to i64, !dbg !34
  %arrayidx = getelementptr inbounds [2000 x i32], [2000 x i32]* %a, i64 0, i64 %idxprom, !dbg !34
  %10 = ptrtoint i32* %arrayidx to i64
  call void @__dp_write(i32 16444, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 %7, i32* %arrayidx, align 4, !dbg !35
  br label %for.inc, !dbg !34

for.inc:                                          ; preds = %for.body
  %11 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16443, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %12 = load i32, i32* %i, align 4, !dbg !36
  %inc = add nsw i32 %12, 1, !dbg !36
  %13 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16443, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !36
  br label %for.cond, !dbg !37, !llvm.loop !38

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16447, i32 0)
  %14 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16447, i64 %14, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !40
  br label %for.cond1, !dbg !42

for.cond1:                                        ; preds = %for.inc9, %for.end
  call void @__dp_loop_entry(i32 16447, i32 1)
  %15 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16447, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %16 = load i32, i32* %i, align 4, !dbg !43
  %cmp2 = icmp slt i32 %16, 1000, !dbg !45
  br i1 %cmp2, label %for.body3, label %for.end11, !dbg !46

for.body3:                                        ; preds = %for.cond1
  %17 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16448, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %18 = load i32, i32* %i, align 4, !dbg !47
  %idxprom4 = sext i32 %18 to i64, !dbg !48
  %arrayidx5 = getelementptr inbounds [2000 x i32], [2000 x i32]* %a, i64 0, i64 %idxprom4, !dbg !48
  %19 = ptrtoint i32* %arrayidx5 to i64
  call void @__dp_read(i32 16448, i64 %19, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %20 = load i32, i32* %arrayidx5, align 4, !dbg !48
  %add = add nsw i32 %20, 1, !dbg !49
  %21 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16448, i64 %21, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %22 = load i32, i32* %i, align 4, !dbg !50
  %mul = mul nsw i32 2, %22, !dbg !51
  %add6 = add nsw i32 %mul, 1, !dbg !52
  %idxprom7 = sext i32 %add6 to i64, !dbg !53
  %arrayidx8 = getelementptr inbounds [2000 x i32], [2000 x i32]* %a, i64 0, i64 %idxprom7, !dbg !53
  %23 = ptrtoint i32* %arrayidx8 to i64
  call void @__dp_write(i32 16448, i64 %23, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 %add, i32* %arrayidx8, align 4, !dbg !54
  br label %for.inc9, !dbg !53

for.inc9:                                         ; preds = %for.body3
  %24 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16447, i64 %24, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %25 = load i32, i32* %i, align 4, !dbg !55
  %inc10 = add nsw i32 %25, 1, !dbg !55
  %26 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16447, i64 %26, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 %inc10, i32* %i, align 4, !dbg !55
  br label %for.cond1, !dbg !56, !llvm.loop !57

for.end11:                                        ; preds = %for.cond1
  call void @__dp_loop_exit(i32 16450, i32 1)
  %arrayidx12 = getelementptr inbounds [2000 x i32], [2000 x i32]* %a, i64 0, i64 1001, !dbg !59
  %27 = ptrtoint i32* %arrayidx12 to i64
  call void @__dp_read(i32 16450, i64 %27, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %28 = load i32, i32* %arrayidx12, align 4, !dbg !59
  call void @__dp_call(i32 16450), !dbg !60
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i64 0, i64 0), i32 %28), !dbg !60
  call void @__dp_finalize(i32 16451), !dbg !61
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
!llvm.ident = !{!3}
!llvm.module.flags = !{!4, !5, !6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/033")
!2 = !{}
!3 = !{!"Ubuntu clang version 11.1.0-6"}
!4 = !{i32 7, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 53, type: !8, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10, !10, !11}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!13 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!14 = !DILocalVariable(name: "argc", arg: 1, scope: !7, file: !1, line: 53, type: !10)
!15 = !DILocation(line: 53, column: 14, scope: !7)
!16 = !DILocalVariable(name: "argv", arg: 2, scope: !7, file: !1, line: 53, type: !11)
!17 = !DILocation(line: 53, column: 26, scope: !7)
!18 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 55, type: !10)
!19 = !DILocation(line: 55, column: 7, scope: !7)
!20 = !DILocalVariable(name: "a", scope: !7, file: !1, line: 57, type: !21)
!21 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 64000, elements: !22)
!22 = !{!23}
!23 = !DISubrange(count: 2000)
!24 = !DILocation(line: 57, column: 7, scope: !7)
!25 = !DILocation(line: 59, column: 9, scope: !26)
!26 = distinct !DILexicalBlock(scope: !7, file: !1, line: 59, column: 3)
!27 = !DILocation(line: 59, column: 8, scope: !26)
!28 = !DILocation(line: 59, column: 13, scope: !29)
!29 = distinct !DILexicalBlock(scope: !26, file: !1, line: 59, column: 3)
!30 = !DILocation(line: 59, column: 14, scope: !29)
!31 = !DILocation(line: 59, column: 3, scope: !26)
!32 = !DILocation(line: 60, column: 10, scope: !29)
!33 = !DILocation(line: 60, column: 7, scope: !29)
!34 = !DILocation(line: 60, column: 5, scope: !29)
!35 = !DILocation(line: 60, column: 9, scope: !29)
!36 = !DILocation(line: 59, column: 22, scope: !29)
!37 = !DILocation(line: 59, column: 3, scope: !29)
!38 = distinct !{!38, !31, !39}
!39 = !DILocation(line: 60, column: 10, scope: !26)
!40 = !DILocation(line: 63, column: 9, scope: !41)
!41 = distinct !DILexicalBlock(scope: !7, file: !1, line: 63, column: 3)
!42 = !DILocation(line: 63, column: 8, scope: !41)
!43 = !DILocation(line: 63, column: 12, scope: !44)
!44 = distinct !DILexicalBlock(scope: !41, file: !1, line: 63, column: 3)
!45 = !DILocation(line: 63, column: 13, scope: !44)
!46 = !DILocation(line: 63, column: 3, scope: !41)
!47 = !DILocation(line: 64, column: 16, scope: !44)
!48 = !DILocation(line: 64, column: 14, scope: !44)
!49 = !DILocation(line: 64, column: 18, scope: !44)
!50 = !DILocation(line: 64, column: 9, scope: !44)
!51 = !DILocation(line: 64, column: 8, scope: !44)
!52 = !DILocation(line: 64, column: 10, scope: !44)
!53 = !DILocation(line: 64, column: 5, scope: !44)
!54 = !DILocation(line: 64, column: 13, scope: !44)
!55 = !DILocation(line: 63, column: 20, scope: !44)
!56 = !DILocation(line: 63, column: 3, scope: !44)
!57 = distinct !{!57, !46, !58}
!58 = !DILocation(line: 64, column: 19, scope: !41)
!59 = !DILocation(line: 66, column: 26, scope: !7)
!60 = !DILocation(line: 66, column: 3, scope: !7)
!61 = !DILocation(line: 67, column: 3, scope: !7)
