; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"argc\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"argv\00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c"len\00", align 1
@.str.4 = private unnamed_addr constant [12 x i8] c"saved_stack\00", align 1
@.str.5 = private unnamed_addr constant [12 x i8] c"__vla_expr0\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.7 = private unnamed_addr constant [2 x i8] c"a\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16434, i32 1)
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %len = alloca i32, align 4
  %saved_stack = alloca i8*, align 8
  %__vla_expr0 = alloca i64, align 8
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16434, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  %1 = ptrtoint i32* %argc.addr to i64
  call void @__dp_write(i32 16434, i64 %1, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i32 0, i32 0))
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !14, metadata !DIExpression()), !dbg !15
  %2 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_write(i32 16434, i64 %2, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i32 0, i32 0))
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !16, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.declare(metadata i32* %i, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32* %len, metadata !20, metadata !DIExpression()), !dbg !21
  %3 = ptrtoint i32* %len to i64
  call void @__dp_write(i32 16437, i64 %3, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  store i32 1000, i32* %len, align 4, !dbg !21
  %4 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16438, i64 %4, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  %5 = load i32, i32* %len, align 4, !dbg !22
  %6 = zext i32 %5 to i64, !dbg !23
  call void @__dp_call(i32 16438), !dbg !23
  %7 = call i8* @llvm.stacksave(), !dbg !23
  %8 = ptrtoint i8** %saved_stack to i64
  call void @__dp_write(i32 16438, i64 %8, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.4, i32 0, i32 0))
  store i8* %7, i8** %saved_stack, align 8, !dbg !23
  %vla = alloca i32, i64 %6, align 16, !dbg !23
  %9 = ptrtoint i64* %__vla_expr0 to i64
  call void @__dp_write(i32 16438, i64 %9, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.5, i32 0, i32 0))
  store i64 %6, i64* %__vla_expr0, align 8, !dbg !23
  call void @llvm.dbg.declare(metadata i64* %__vla_expr0, metadata !24, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.declare(metadata i32* %vla, metadata !27, metadata !DIExpression()), !dbg !31
  %10 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16440, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !32
  br label %for.cond, !dbg !34

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16440, i32 0)
  %11 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16440, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %12 = load i32, i32* %i, align 4, !dbg !35
  %13 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16440, i64 %13, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  %14 = load i32, i32* %len, align 4, !dbg !37
  %cmp = icmp slt i32 %12, %14, !dbg !38
  br i1 %cmp, label %for.body, label %for.end, !dbg !39

for.body:                                         ; preds = %for.cond
  %15 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16441, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %16 = load i32, i32* %i, align 4, !dbg !40
  %17 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16441, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %18 = load i32, i32* %i, align 4, !dbg !41
  %idxprom = sext i32 %18 to i64, !dbg !42
  %arrayidx = getelementptr inbounds i32, i32* %vla, i64 %idxprom, !dbg !42
  %19 = ptrtoint i32* %arrayidx to i64
  call void @__dp_write(i32 16441, i64 %19, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 %16, i32* %arrayidx, align 4, !dbg !43
  br label %for.inc, !dbg !42

for.inc:                                          ; preds = %for.body
  %20 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16440, i64 %20, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %21 = load i32, i32* %i, align 4, !dbg !44
  %inc = add nsw i32 %21, 1, !dbg !44
  %22 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16440, i64 %22, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !44
  br label %for.cond, !dbg !45, !llvm.loop !46

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16445, i32 0)
  %23 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16445, i64 %23, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !48
  br label %for.cond1, !dbg !50

for.cond1:                                        ; preds = %for.inc8, %for.end
  call void @__dp_loop_entry(i32 16445, i32 1)
  %24 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16445, i64 %24, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %25 = load i32, i32* %i, align 4, !dbg !51
  %26 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16445, i64 %26, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  %27 = load i32, i32* %len, align 4, !dbg !53
  %cmp2 = icmp slt i32 %25, %27, !dbg !54
  br i1 %cmp2, label %for.body3, label %for.end10, !dbg !55

for.body3:                                        ; preds = %for.cond1
  %28 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16446, i64 %28, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %29 = load i32, i32* %i, align 4, !dbg !56
  %idxprom4 = sext i32 %29 to i64, !dbg !57
  %arrayidx5 = getelementptr inbounds i32, i32* %vla, i64 %idxprom4, !dbg !57
  %30 = ptrtoint i32* %arrayidx5 to i64
  call void @__dp_read(i32 16446, i64 %30, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %31 = load i32, i32* %arrayidx5, align 4, !dbg !57
  %add = add nsw i32 %31, 1, !dbg !58
  %32 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16446, i64 %32, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %33 = load i32, i32* %i, align 4, !dbg !59
  %idxprom6 = sext i32 %33 to i64, !dbg !60
  %arrayidx7 = getelementptr inbounds i32, i32* %vla, i64 %idxprom6, !dbg !60
  %34 = ptrtoint i32* %arrayidx7 to i64
  call void @__dp_write(i32 16446, i64 %34, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 %add, i32* %arrayidx7, align 4, !dbg !61
  br label %for.inc8, !dbg !60

for.inc8:                                         ; preds = %for.body3
  %35 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16445, i64 %35, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %36 = load i32, i32* %i, align 4, !dbg !62
  %inc9 = add nsw i32 %36, 1, !dbg !62
  %37 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16445, i64 %37, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 %inc9, i32* %i, align 4, !dbg !62
  br label %for.cond1, !dbg !63, !llvm.loop !64

for.end10:                                        ; preds = %for.cond1
  call void @__dp_loop_exit(i32 16448, i32 1)
  %38 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16448, i64 %38, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  store i32 0, i32* %retval, align 4, !dbg !66
  %39 = ptrtoint i8** %saved_stack to i64
  call void @__dp_read(i32 16449, i64 %39, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.4, i32 0, i32 0))
  %40 = load i8*, i8** %saved_stack, align 8, !dbg !67
  call void @__dp_call(i32 16449), !dbg !67
  call void @llvm.stackrestore(i8* %40), !dbg !67
  %41 = ptrtoint i32* %retval to i64
  call void @__dp_read(i32 16449, i64 %41, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  %42 = load i32, i32* %retval, align 4, !dbg !67
  call void @__dp_finalize(i32 16449), !dbg !67
  ret i32 %42, !dbg !67
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_call(i32)

; Function Attrs: nounwind
declare i8* @llvm.stacksave() #2

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_loop_exit(i32, i32)

; Function Attrs: nounwind
declare void @llvm.stackrestore(i8*) #2

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!3}
!llvm.module.flags = !{!4, !5, !6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/071")
!2 = !{}
!3 = !{!"Ubuntu clang version 11.1.0-6"}
!4 = !{i32 7, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 50, type: !8, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10, !10, !11}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!13 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!14 = !DILocalVariable(name: "argc", arg: 1, scope: !7, file: !1, line: 50, type: !10)
!15 = !DILocation(line: 50, column: 14, scope: !7)
!16 = !DILocalVariable(name: "argv", arg: 2, scope: !7, file: !1, line: 50, type: !11)
!17 = !DILocation(line: 50, column: 26, scope: !7)
!18 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 52, type: !10)
!19 = !DILocation(line: 52, column: 7, scope: !7)
!20 = !DILocalVariable(name: "len", scope: !7, file: !1, line: 53, type: !10)
!21 = !DILocation(line: 53, column: 7, scope: !7)
!22 = !DILocation(line: 54, column: 9, scope: !7)
!23 = !DILocation(line: 54, column: 3, scope: !7)
!24 = !DILocalVariable(name: "__vla_expr0", scope: !7, type: !25, flags: DIFlagArtificial)
!25 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!26 = !DILocation(line: 0, scope: !7)
!27 = !DILocalVariable(name: "a", scope: !7, file: !1, line: 54, type: !28)
!28 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, elements: !29)
!29 = !{!30}
!30 = !DISubrange(count: !24)
!31 = !DILocation(line: 54, column: 7, scope: !7)
!32 = !DILocation(line: 56, column: 9, scope: !33)
!33 = distinct !DILexicalBlock(scope: !7, file: !1, line: 56, column: 3)
!34 = !DILocation(line: 56, column: 8, scope: !33)
!35 = !DILocation(line: 56, column: 13, scope: !36)
!36 = distinct !DILexicalBlock(scope: !33, file: !1, line: 56, column: 3)
!37 = !DILocation(line: 56, column: 15, scope: !36)
!38 = !DILocation(line: 56, column: 14, scope: !36)
!39 = !DILocation(line: 56, column: 3, scope: !33)
!40 = !DILocation(line: 57, column: 11, scope: !36)
!41 = !DILocation(line: 57, column: 7, scope: !36)
!42 = !DILocation(line: 57, column: 5, scope: !36)
!43 = !DILocation(line: 57, column: 9, scope: !36)
!44 = !DILocation(line: 56, column: 21, scope: !36)
!45 = !DILocation(line: 56, column: 3, scope: !36)
!46 = distinct !{!46, !39, !47}
!47 = !DILocation(line: 57, column: 11, scope: !33)
!48 = !DILocation(line: 61, column: 9, scope: !49)
!49 = distinct !DILexicalBlock(scope: !7, file: !1, line: 61, column: 3)
!50 = !DILocation(line: 61, column: 8, scope: !49)
!51 = !DILocation(line: 61, column: 12, scope: !52)
!52 = distinct !DILexicalBlock(scope: !49, file: !1, line: 61, column: 3)
!53 = !DILocation(line: 61, column: 15, scope: !52)
!54 = !DILocation(line: 61, column: 13, scope: !52)
!55 = !DILocation(line: 61, column: 3, scope: !49)
!56 = !DILocation(line: 62, column: 12, scope: !52)
!57 = !DILocation(line: 62, column: 10, scope: !52)
!58 = !DILocation(line: 62, column: 14, scope: !52)
!59 = !DILocation(line: 62, column: 7, scope: !52)
!60 = !DILocation(line: 62, column: 5, scope: !52)
!61 = !DILocation(line: 62, column: 9, scope: !52)
!62 = !DILocation(line: 61, column: 20, scope: !52)
!63 = !DILocation(line: 61, column: 3, scope: !52)
!64 = distinct !{!64, !55, !65}
!65 = !DILocation(line: 62, column: 15, scope: !49)
!66 = !DILocation(line: 64, column: 3, scope: !7)
!67 = !DILocation(line: 65, column: 1, scope: !7)
