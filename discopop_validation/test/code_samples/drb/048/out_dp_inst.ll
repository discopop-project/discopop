; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@a = dso_local global [100 x i32] zeroinitializer, align 16, !dbg !0
@.str = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"n\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"g\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c"retval\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo(i32* %a, i32 %n, i32 %g) #0 !dbg !14 {
entry:
  call void @__dp_func_entry(i32 16435, i32 0)
  %a.addr = alloca i32*, align 8
  %n.addr = alloca i32, align 4
  %g.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %0 = ptrtoint i32** %a.addr to i64
  call void @__dp_write(i32 16435, i64 %0, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i32* %a, i32** %a.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %a.addr, metadata !18, metadata !DIExpression()), !dbg !19
  %1 = ptrtoint i32* %n.addr to i64
  call void @__dp_write(i32 16435, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 %n, i32* %n.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %n.addr, metadata !20, metadata !DIExpression()), !dbg !21
  %2 = ptrtoint i32* %g.addr to i64
  call void @__dp_write(i32 16435, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 %g, i32* %g.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %g.addr, metadata !22, metadata !DIExpression()), !dbg !23
  call void @llvm.dbg.declare(metadata i32* %i, metadata !24, metadata !DIExpression()), !dbg !25
  %3 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16439, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !26
  br label %for.cond, !dbg !28

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16439, i32 0)
  %4 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16439, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %5 = load i32, i32* %i, align 4, !dbg !29
  %6 = ptrtoint i32* %n.addr to i64
  call void @__dp_read(i32 16439, i64 %6, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %7 = load i32, i32* %n.addr, align 4, !dbg !31
  %cmp = icmp slt i32 %5, %7, !dbg !32
  br i1 %cmp, label %for.body, label %for.end, !dbg !33

for.body:                                         ; preds = %for.cond
  %8 = ptrtoint i32** %a.addr to i64
  call void @__dp_read(i32 16441, i64 %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %9 = load i32*, i32** %a.addr, align 8, !dbg !34
  %10 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16441, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %11 = load i32, i32* %i, align 4, !dbg !36
  %idxprom = sext i32 %11 to i64, !dbg !34
  %arrayidx = getelementptr inbounds i32, i32* %9, i64 %idxprom, !dbg !34
  %12 = ptrtoint i32* %arrayidx to i64
  call void @__dp_read(i32 16441, i64 %12, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %13 = load i32, i32* %arrayidx, align 4, !dbg !34
  %14 = ptrtoint i32* %g.addr to i64
  call void @__dp_read(i32 16441, i64 %14, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %15 = load i32, i32* %g.addr, align 4, !dbg !37
  %add = add nsw i32 %13, %15, !dbg !38
  %16 = ptrtoint i32** %a.addr to i64
  call void @__dp_read(i32 16441, i64 %16, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %17 = load i32*, i32** %a.addr, align 8, !dbg !39
  %18 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16441, i64 %18, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %19 = load i32, i32* %i, align 4, !dbg !40
  %idxprom1 = sext i32 %19 to i64, !dbg !39
  %arrayidx2 = getelementptr inbounds i32, i32* %17, i64 %idxprom1, !dbg !39
  %20 = ptrtoint i32* %arrayidx2 to i64
  call void @__dp_write(i32 16441, i64 %20, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i32 %add, i32* %arrayidx2, align 4, !dbg !41
  br label %for.inc, !dbg !42

for.inc:                                          ; preds = %for.body
  %21 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16439, i64 %21, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %22 = load i32, i32* %i, align 4, !dbg !43
  %inc = add nsw i32 %22, 1, !dbg !43
  %23 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16439, i64 %23, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !43
  br label %for.cond, !dbg !44, !llvm.loop !45

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16443, i32 0)
  call void @__dp_func_exit(i32 16443, i32 0), !dbg !47
  ret void, !dbg !47
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
define dso_local i32 @main() #0 !dbg !48 {
entry:
  call void @__dp_func_entry(i32 16446, i32 1)
  %retval = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16446, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @__dp_call(i32 16448), !dbg !51
  call void @foo(i32* getelementptr inbounds ([100 x i32], [100 x i32]* @a, i64 0, i64 0), i32 100, i32 7), !dbg !51
  call void @__dp_finalize(i32 16449), !dbg !52
  ret i32 0, !dbg !52
}

declare void @__dp_call(i32)

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!10}
!llvm.module.flags = !{!11, !12, !13}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 61, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/048")
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
!14 = distinct !DISubprogram(name: "foo", scope: !3, file: !3, line: 51, type: !15, scopeLine: 52, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!15 = !DISubroutineType(types: !16)
!16 = !{null, !17, !7, !7}
!17 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!18 = !DILocalVariable(name: "a", arg: 1, scope: !14, file: !3, line: 51, type: !17)
!19 = !DILocation(line: 51, column: 16, scope: !14)
!20 = !DILocalVariable(name: "n", arg: 2, scope: !14, file: !3, line: 51, type: !7)
!21 = !DILocation(line: 51, column: 23, scope: !14)
!22 = !DILocalVariable(name: "g", arg: 3, scope: !14, file: !3, line: 51, type: !7)
!23 = !DILocation(line: 51, column: 30, scope: !14)
!24 = !DILocalVariable(name: "i", scope: !14, file: !3, line: 53, type: !7)
!25 = !DILocation(line: 53, column: 7, scope: !14)
!26 = !DILocation(line: 55, column: 9, scope: !27)
!27 = distinct !DILexicalBlock(scope: !14, file: !3, line: 55, column: 3)
!28 = !DILocation(line: 55, column: 8, scope: !27)
!29 = !DILocation(line: 55, column: 12, scope: !30)
!30 = distinct !DILexicalBlock(scope: !27, file: !3, line: 55, column: 3)
!31 = !DILocation(line: 55, column: 14, scope: !30)
!32 = !DILocation(line: 55, column: 13, scope: !30)
!33 = !DILocation(line: 55, column: 3, scope: !27)
!34 = !DILocation(line: 57, column: 12, scope: !35)
!35 = distinct !DILexicalBlock(scope: !30, file: !3, line: 56, column: 3)
!36 = !DILocation(line: 57, column: 14, scope: !35)
!37 = !DILocation(line: 57, column: 17, scope: !35)
!38 = !DILocation(line: 57, column: 16, scope: !35)
!39 = !DILocation(line: 57, column: 5, scope: !35)
!40 = !DILocation(line: 57, column: 7, scope: !35)
!41 = !DILocation(line: 57, column: 10, scope: !35)
!42 = !DILocation(line: 58, column: 3, scope: !35)
!43 = !DILocation(line: 55, column: 17, scope: !30)
!44 = !DILocation(line: 55, column: 3, scope: !30)
!45 = distinct !{!45, !33, !46}
!46 = !DILocation(line: 58, column: 3, scope: !27)
!47 = !DILocation(line: 59, column: 1, scope: !14)
!48 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 62, type: !49, scopeLine: 63, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!49 = !DISubroutineType(types: !50)
!50 = !{!7}
!51 = !DILocation(line: 64, column: 3, scope: !48)
!52 = !DILocation(line: 65, column: 3, scope: !48)
