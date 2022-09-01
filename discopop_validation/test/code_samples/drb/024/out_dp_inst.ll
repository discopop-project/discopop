; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.1 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"argc\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"argv\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"len\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.7 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.str = private unnamed_addr constant [15 x i8] c"i=%d a[%d]=%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16436, i32 1)
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %len = alloca i32, align 4
  %a = alloca [100 x i32], align 16
  %b = alloca [100 x i32], align 16
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16436, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  %1 = ptrtoint i32* %argc.addr to i64
  call void @__dp_write(i32 16436, i64 %1, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i32 0, i32 0))
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !14, metadata !DIExpression()), !dbg !15
  %2 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_write(i32 16436, i64 %2, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0))
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !16, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.declare(metadata i32* %i, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32* %len, metadata !20, metadata !DIExpression()), !dbg !21
  %3 = ptrtoint i32* %len to i64
  call void @__dp_write(i32 16439, i64 %3, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  store i32 100, i32* %len, align 4, !dbg !21
  call void @llvm.dbg.declare(metadata [100 x i32]* %a, metadata !22, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.declare(metadata [100 x i32]* %b, metadata !27, metadata !DIExpression()), !dbg !28
  %4 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16442, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !29
  br label %for.cond, !dbg !31

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16442, i32 0)
  %5 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16442, i64 %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %6 = load i32, i32* %i, align 4, !dbg !32
  %7 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16442, i64 %7, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  %8 = load i32, i32* %len, align 4, !dbg !34
  %cmp = icmp slt i32 %6, %8, !dbg !35
  br i1 %cmp, label %for.body, label %for.end, !dbg !36

for.body:                                         ; preds = %for.cond
  %9 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16444, i64 %9, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %10 = load i32, i32* %i, align 4, !dbg !37
  %11 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16444, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %12 = load i32, i32* %i, align 4, !dbg !39
  %idxprom = sext i32 %12 to i64, !dbg !40
  %arrayidx = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom, !dbg !40
  %13 = ptrtoint i32* %arrayidx to i64
  call void @__dp_write(i32 16444, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 %10, i32* %arrayidx, align 4, !dbg !41
  %14 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16445, i64 %14, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %15 = load i32, i32* %i, align 4, !dbg !42
  %add = add nsw i32 %15, 1, !dbg !43
  %16 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16445, i64 %16, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %17 = load i32, i32* %i, align 4, !dbg !44
  %idxprom1 = sext i32 %17 to i64, !dbg !45
  %arrayidx2 = getelementptr inbounds [100 x i32], [100 x i32]* %b, i64 0, i64 %idxprom1, !dbg !45
  %18 = ptrtoint i32* %arrayidx2 to i64
  call void @__dp_write(i32 16445, i64 %18, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 %add, i32* %arrayidx2, align 4, !dbg !46
  br label %for.inc, !dbg !47

for.inc:                                          ; preds = %for.body
  %19 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16442, i64 %19, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %20 = load i32, i32* %i, align 4, !dbg !48
  %inc = add nsw i32 %20, 1, !dbg !48
  %21 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16442, i64 %21, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !48
  br label %for.cond, !dbg !49, !llvm.loop !50

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16449, i32 0)
  %22 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16449, i64 %22, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !52
  br label %for.cond3, !dbg !54

for.cond3:                                        ; preds = %for.inc14, %for.end
  call void @__dp_loop_entry(i32 16449, i32 1)
  %23 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16449, i64 %23, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %24 = load i32, i32* %i, align 4, !dbg !55
  %25 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16449, i64 %25, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  %26 = load i32, i32* %len, align 4, !dbg !57
  %sub = sub nsw i32 %26, 1, !dbg !58
  %cmp4 = icmp slt i32 %24, %sub, !dbg !59
  br i1 %cmp4, label %for.body5, label %for.end16, !dbg !60

for.body5:                                        ; preds = %for.cond3
  %27 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16450, i64 %27, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %28 = load i32, i32* %i, align 4, !dbg !61
  %idxprom6 = sext i32 %28 to i64, !dbg !62
  %arrayidx7 = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom6, !dbg !62
  %29 = ptrtoint i32* %arrayidx7 to i64
  call void @__dp_read(i32 16450, i64 %29, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %30 = load i32, i32* %arrayidx7, align 4, !dbg !62
  %31 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16450, i64 %31, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %32 = load i32, i32* %i, align 4, !dbg !63
  %idxprom8 = sext i32 %32 to i64, !dbg !64
  %arrayidx9 = getelementptr inbounds [100 x i32], [100 x i32]* %b, i64 0, i64 %idxprom8, !dbg !64
  %33 = ptrtoint i32* %arrayidx9 to i64
  call void @__dp_read(i32 16450, i64 %33, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %34 = load i32, i32* %arrayidx9, align 4, !dbg !64
  %add10 = add nsw i32 %30, %34, !dbg !65
  %35 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16450, i64 %35, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %36 = load i32, i32* %i, align 4, !dbg !66
  %add11 = add nsw i32 %36, 1, !dbg !67
  %idxprom12 = sext i32 %add11 to i64, !dbg !68
  %arrayidx13 = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom12, !dbg !68
  %37 = ptrtoint i32* %arrayidx13 to i64
  call void @__dp_write(i32 16450, i64 %37, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 %add10, i32* %arrayidx13, align 4, !dbg !69
  br label %for.inc14, !dbg !68

for.inc14:                                        ; preds = %for.body5
  %38 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16449, i64 %38, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %39 = load i32, i32* %i, align 4, !dbg !70
  %inc15 = add nsw i32 %39, 1, !dbg !70
  %40 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16449, i64 %40, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 %inc15, i32* %i, align 4, !dbg !70
  br label %for.cond3, !dbg !71, !llvm.loop !72

for.end16:                                        ; preds = %for.cond3
  call void @__dp_loop_exit(i32 16452, i32 1)
  %41 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16452, i64 %41, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !74
  br label %for.cond17, !dbg !76

for.cond17:                                       ; preds = %for.inc22, %for.end16
  call void @__dp_loop_entry(i32 16452, i32 2)
  %42 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16452, i64 %42, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %43 = load i32, i32* %i, align 4, !dbg !77
  %44 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16452, i64 %44, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  %45 = load i32, i32* %len, align 4, !dbg !79
  %cmp18 = icmp slt i32 %43, %45, !dbg !80
  br i1 %cmp18, label %for.body19, label %for.end24, !dbg !81

for.body19:                                       ; preds = %for.cond17
  %46 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16453, i64 %46, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %47 = load i32, i32* %i, align 4, !dbg !82
  %48 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16453, i64 %48, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %49 = load i32, i32* %i, align 4, !dbg !83
  %50 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16453, i64 %50, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %51 = load i32, i32* %i, align 4, !dbg !84
  %idxprom20 = sext i32 %51 to i64, !dbg !85
  %arrayidx21 = getelementptr inbounds [100 x i32], [100 x i32]* %a, i64 0, i64 %idxprom20, !dbg !85
  %52 = ptrtoint i32* %arrayidx21 to i64
  call void @__dp_read(i32 16453, i64 %52, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %53 = load i32, i32* %arrayidx21, align 4, !dbg !85
  call void @__dp_call(i32 16453), !dbg !86
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str, i64 0, i64 0), i32 %47, i32 %49, i32 %53), !dbg !86
  br label %for.inc22, !dbg !86

for.inc22:                                        ; preds = %for.body19
  %54 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16452, i64 %54, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %55 = load i32, i32* %i, align 4, !dbg !87
  %inc23 = add nsw i32 %55, 1, !dbg !87
  %56 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16452, i64 %56, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 %inc23, i32* %i, align 4, !dbg !87
  br label %for.cond17, !dbg !88, !llvm.loop !89

for.end24:                                        ; preds = %for.cond17
  call void @__dp_loop_exit(i32 16454, i32 2)
  call void @__dp_finalize(i32 16454), !dbg !91
  ret i32 0, !dbg !91
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
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/024")
!2 = !{}
!3 = !{!"Ubuntu clang version 11.1.0-6"}
!4 = !{i32 7, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 52, type: !8, scopeLine: 53, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10, !10, !11}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!13 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!14 = !DILocalVariable(name: "argc", arg: 1, scope: !7, file: !1, line: 52, type: !10)
!15 = !DILocation(line: 52, column: 14, scope: !7)
!16 = !DILocalVariable(name: "argv", arg: 2, scope: !7, file: !1, line: 52, type: !11)
!17 = !DILocation(line: 52, column: 26, scope: !7)
!18 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 54, type: !10)
!19 = !DILocation(line: 54, column: 7, scope: !7)
!20 = !DILocalVariable(name: "len", scope: !7, file: !1, line: 55, type: !10)
!21 = !DILocation(line: 55, column: 7, scope: !7)
!22 = !DILocalVariable(name: "a", scope: !7, file: !1, line: 56, type: !23)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 3200, elements: !24)
!24 = !{!25}
!25 = !DISubrange(count: 100)
!26 = !DILocation(line: 56, column: 7, scope: !7)
!27 = !DILocalVariable(name: "b", scope: !7, file: !1, line: 56, type: !23)
!28 = !DILocation(line: 56, column: 15, scope: !7)
!29 = !DILocation(line: 58, column: 9, scope: !30)
!30 = distinct !DILexicalBlock(scope: !7, file: !1, line: 58, column: 3)
!31 = !DILocation(line: 58, column: 8, scope: !30)
!32 = !DILocation(line: 58, column: 12, scope: !33)
!33 = distinct !DILexicalBlock(scope: !30, file: !1, line: 58, column: 3)
!34 = !DILocation(line: 58, column: 14, scope: !33)
!35 = !DILocation(line: 58, column: 13, scope: !33)
!36 = !DILocation(line: 58, column: 3, scope: !30)
!37 = !DILocation(line: 60, column: 10, scope: !38)
!38 = distinct !DILexicalBlock(scope: !33, file: !1, line: 59, column: 3)
!39 = !DILocation(line: 60, column: 7, scope: !38)
!40 = !DILocation(line: 60, column: 5, scope: !38)
!41 = !DILocation(line: 60, column: 9, scope: !38)
!42 = !DILocation(line: 61, column: 10, scope: !38)
!43 = !DILocation(line: 61, column: 11, scope: !38)
!44 = !DILocation(line: 61, column: 7, scope: !38)
!45 = !DILocation(line: 61, column: 5, scope: !38)
!46 = !DILocation(line: 61, column: 9, scope: !38)
!47 = !DILocation(line: 62, column: 3, scope: !38)
!48 = !DILocation(line: 58, column: 19, scope: !33)
!49 = !DILocation(line: 58, column: 3, scope: !33)
!50 = distinct !{!50, !36, !51}
!51 = !DILocation(line: 62, column: 3, scope: !30)
!52 = !DILocation(line: 65, column: 9, scope: !53)
!53 = distinct !DILexicalBlock(scope: !7, file: !1, line: 65, column: 3)
!54 = !DILocation(line: 65, column: 8, scope: !53)
!55 = !DILocation(line: 65, column: 12, scope: !56)
!56 = distinct !DILexicalBlock(scope: !53, file: !1, line: 65, column: 3)
!57 = !DILocation(line: 65, column: 14, scope: !56)
!58 = !DILocation(line: 65, column: 17, scope: !56)
!59 = !DILocation(line: 65, column: 13, scope: !56)
!60 = !DILocation(line: 65, column: 3, scope: !53)
!61 = !DILocation(line: 66, column: 14, scope: !56)
!62 = !DILocation(line: 66, column: 12, scope: !56)
!63 = !DILocation(line: 66, column: 19, scope: !56)
!64 = !DILocation(line: 66, column: 17, scope: !56)
!65 = !DILocation(line: 66, column: 16, scope: !56)
!66 = !DILocation(line: 66, column: 7, scope: !56)
!67 = !DILocation(line: 66, column: 8, scope: !56)
!68 = !DILocation(line: 66, column: 5, scope: !56)
!69 = !DILocation(line: 66, column: 11, scope: !56)
!70 = !DILocation(line: 65, column: 21, scope: !56)
!71 = !DILocation(line: 65, column: 3, scope: !56)
!72 = distinct !{!72, !60, !73}
!73 = !DILocation(line: 66, column: 20, scope: !53)
!74 = !DILocation(line: 68, column: 9, scope: !75)
!75 = distinct !DILexicalBlock(scope: !7, file: !1, line: 68, column: 3)
!76 = !DILocation(line: 68, column: 8, scope: !75)
!77 = !DILocation(line: 68, column: 12, scope: !78)
!78 = distinct !DILexicalBlock(scope: !75, file: !1, line: 68, column: 3)
!79 = !DILocation(line: 68, column: 14, scope: !78)
!80 = !DILocation(line: 68, column: 13, scope: !78)
!81 = !DILocation(line: 68, column: 3, scope: !75)
!82 = !DILocation(line: 69, column: 30, scope: !78)
!83 = !DILocation(line: 69, column: 32, scope: !78)
!84 = !DILocation(line: 69, column: 36, scope: !78)
!85 = !DILocation(line: 69, column: 34, scope: !78)
!86 = !DILocation(line: 69, column: 5, scope: !78)
!87 = !DILocation(line: 68, column: 19, scope: !78)
!88 = !DILocation(line: 68, column: 3, scope: !78)
!89 = distinct !{!89, !81, !90}
!90 = !DILocation(line: 69, column: 38, scope: !75)
!91 = !DILocation(line: 70, column: 3, scope: !7)
