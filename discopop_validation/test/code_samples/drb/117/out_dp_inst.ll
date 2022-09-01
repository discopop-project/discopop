; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.1 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"s\00", align 1
@.str.5 = private unnamed_addr constant [6 x i8] c"psum1\00", align 1
@.str.6 = private unnamed_addr constant [6 x i8] c"psum0\00", align 1
@.str.7 = private unnamed_addr constant [4 x i8] c"sum\00", align 1
@.str = private unnamed_addr constant [10 x i8] c"sum = %d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16404, i32 1)
  %retval = alloca i32, align 4
  %a = alloca [4 x i32], align 16
  %psum0 = alloca i32, align 4
  %psum1 = alloca i32, align 4
  %sum = alloca i32, align 4
  %i = alloca i32, align 4
  %s = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16404, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata [4 x i32]* %a, metadata !11, metadata !DIExpression()), !dbg !15
  call void @llvm.dbg.declare(metadata i32* %psum0, metadata !16, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.declare(metadata i32* %psum1, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32* %sum, metadata !20, metadata !DIExpression()), !dbg !21
  call void @llvm.dbg.declare(metadata i32* %i, metadata !22, metadata !DIExpression()), !dbg !25
  %1 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16413, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !25
  br label %for.cond, !dbg !26

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16413, i32 0)
  %2 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16413, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %3 = load i32, i32* %i, align 4, !dbg !27
  %cmp = icmp slt i32 %3, 4, !dbg !29
  br i1 %cmp, label %for.body, label %for.end, !dbg !30

for.body:                                         ; preds = %for.cond
  %4 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16414, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %5 = load i32, i32* %i, align 4, !dbg !31
  %6 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16414, i64 %6, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %7 = load i32, i32* %i, align 4, !dbg !33
  %idxprom = sext i32 %7 to i64, !dbg !34
  %arrayidx = getelementptr inbounds [4 x i32], [4 x i32]* %a, i64 0, i64 %idxprom, !dbg !34
  %8 = ptrtoint i32* %arrayidx to i64
  call void @__dp_write(i32 16414, i64 %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 %5, i32* %arrayidx, align 4, !dbg !35
  call void @llvm.dbg.declare(metadata i32* %s, metadata !36, metadata !DIExpression()), !dbg !37
  %9 = ptrtoint i32* %s to i64
  call void @__dp_write(i32 16416, i64 %9, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 2, i32* %s, align 4, !dbg !38
  br label %for.inc, !dbg !39

for.inc:                                          ; preds = %for.body
  %10 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16413, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %11 = load i32, i32* %i, align 4, !dbg !40
  %inc = add nsw i32 %11, 1, !dbg !40
  %12 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16413, i64 %12, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !40
  br label %for.cond, !dbg !41, !llvm.loop !42

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16425, i32 0)
  %arrayidx1 = getelementptr inbounds [4 x i32], [4 x i32]* %a, i64 0, i64 2, !dbg !44
  %13 = ptrtoint i32* %arrayidx1 to i64
  call void @__dp_read(i32 16425, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %14 = load i32, i32* %arrayidx1, align 8, !dbg !44
  %arrayidx2 = getelementptr inbounds [4 x i32], [4 x i32]* %a, i64 0, i64 3, !dbg !48
  %15 = ptrtoint i32* %arrayidx2 to i64
  call void @__dp_read(i32 16425, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %16 = load i32, i32* %arrayidx2, align 4, !dbg !48
  %add = add nsw i32 %14, %16, !dbg !49
  %17 = ptrtoint i32* %psum1 to i64
  call void @__dp_write(i32 16425, i64 %17, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.5, i32 0, i32 0))
  store i32 %add, i32* %psum1, align 4, !dbg !50
  %arrayidx3 = getelementptr inbounds [4 x i32], [4 x i32]* %a, i64 0, i64 0, !dbg !51
  %18 = ptrtoint i32* %arrayidx3 to i64
  call void @__dp_read(i32 16427, i64 %18, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %19 = load i32, i32* %arrayidx3, align 16, !dbg !51
  %arrayidx4 = getelementptr inbounds [4 x i32], [4 x i32]* %a, i64 0, i64 1, !dbg !52
  %20 = ptrtoint i32* %arrayidx4 to i64
  call void @__dp_read(i32 16427, i64 %20, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %21 = load i32, i32* %arrayidx4, align 4, !dbg !52
  %add5 = add nsw i32 %19, %21, !dbg !53
  %22 = ptrtoint i32* %psum0 to i64
  call void @__dp_write(i32 16427, i64 %22, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.6, i32 0, i32 0))
  store i32 %add5, i32* %psum0, align 4, !dbg !54
  %23 = ptrtoint i32* %psum1 to i64
  call void @__dp_read(i32 16431, i64 %23, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.5, i32 0, i32 0))
  %24 = load i32, i32* %psum1, align 4, !dbg !55
  %25 = ptrtoint i32* %psum0 to i64
  call void @__dp_read(i32 16431, i64 %25, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.6, i32 0, i32 0))
  %26 = load i32, i32* %psum0, align 4, !dbg !56
  %add6 = add nsw i32 %24, %26, !dbg !57
  %27 = ptrtoint i32* %sum to i64
  call void @__dp_write(i32 16431, i64 %27, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  store i32 %add6, i32* %sum, align 4, !dbg !58
  %28 = ptrtoint i32* %sum to i64
  call void @__dp_read(i32 16435, i64 %28, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  %29 = load i32, i32* %sum, align 4, !dbg !59
  call void @__dp_call(i32 16435), !dbg !60
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i64 0, i64 0), i32 %29), !dbg !60
  call void @__dp_finalize(i32 16436), !dbg !61
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
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/117")
!2 = !{}
!3 = !{!"Ubuntu clang version 11.1.0-6"}
!4 = !{i32 7, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 20, type: !8, scopeLine: 20, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "a", scope: !7, file: !1, line: 22, type: !12)
!12 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 128, elements: !13)
!13 = !{!14}
!14 = !DISubrange(count: 4)
!15 = !DILocation(line: 22, column: 7, scope: !7)
!16 = !DILocalVariable(name: "psum0", scope: !7, file: !1, line: 23, type: !10)
!17 = !DILocation(line: 23, column: 7, scope: !7)
!18 = !DILocalVariable(name: "psum1", scope: !7, file: !1, line: 23, type: !10)
!19 = !DILocation(line: 23, column: 14, scope: !7)
!20 = !DILocalVariable(name: "sum", scope: !7, file: !1, line: 24, type: !10)
!21 = !DILocation(line: 24, column: 7, scope: !7)
!22 = !DILocalVariable(name: "i", scope: !23, file: !1, line: 29, type: !10)
!23 = distinct !DILexicalBlock(scope: !24, file: !1, line: 29, column: 5)
!24 = distinct !DILexicalBlock(scope: !7, file: !1, line: 27, column: 3)
!25 = !DILocation(line: 29, column: 14, scope: !23)
!26 = !DILocation(line: 29, column: 10, scope: !23)
!27 = !DILocation(line: 29, column: 19, scope: !28)
!28 = distinct !DILexicalBlock(scope: !23, file: !1, line: 29, column: 5)
!29 = !DILocation(line: 29, column: 21, scope: !28)
!30 = !DILocation(line: 29, column: 5, scope: !23)
!31 = !DILocation(line: 30, column: 14, scope: !32)
!32 = distinct !DILexicalBlock(scope: !28, file: !1, line: 29, column: 30)
!33 = !DILocation(line: 30, column: 9, scope: !32)
!34 = !DILocation(line: 30, column: 7, scope: !32)
!35 = !DILocation(line: 30, column: 12, scope: !32)
!36 = !DILocalVariable(name: "s", scope: !32, file: !1, line: 31, type: !10)
!37 = !DILocation(line: 31, column: 11, scope: !32)
!38 = !DILocation(line: 32, column: 9, scope: !32)
!39 = !DILocation(line: 33, column: 5, scope: !32)
!40 = !DILocation(line: 29, column: 26, scope: !28)
!41 = !DILocation(line: 29, column: 5, scope: !28)
!42 = distinct !{!42, !30, !43}
!43 = !DILocation(line: 33, column: 5, scope: !23)
!44 = !DILocation(line: 41, column: 18, scope: !45)
!45 = distinct !DILexicalBlock(scope: !46, file: !1, line: 40, column: 8)
!46 = distinct !DILexicalBlock(scope: !47, file: !1, line: 38, column: 7)
!47 = distinct !DILexicalBlock(scope: !24, file: !1, line: 36, column: 5)
!48 = !DILocation(line: 41, column: 25, scope: !45)
!49 = !DILocation(line: 41, column: 23, scope: !45)
!50 = !DILocation(line: 41, column: 16, scope: !45)
!51 = !DILocation(line: 43, column: 17, scope: !46)
!52 = !DILocation(line: 43, column: 24, scope: !46)
!53 = !DILocation(line: 43, column: 22, scope: !46)
!54 = !DILocation(line: 43, column: 15, scope: !46)
!55 = !DILocation(line: 47, column: 13, scope: !47)
!56 = !DILocation(line: 47, column: 21, scope: !47)
!57 = !DILocation(line: 47, column: 19, scope: !47)
!58 = !DILocation(line: 47, column: 11, scope: !47)
!59 = !DILocation(line: 51, column: 24, scope: !7)
!60 = !DILocation(line: 51, column: 3, scope: !7)
!61 = !DILocation(line: 52, column: 3, scope: !7)
