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
  call void @__dp_func_entry(i32 16438, i32 1)
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %len = alloca i32, align 4
  %saved_stack = alloca i8*, align 8
  %__vla_expr0 = alloca i64, align 8
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16438, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  %1 = ptrtoint i32* %argc.addr to i64
  call void @__dp_write(i32 16438, i64 %1, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i32 0, i32 0))
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !14, metadata !DIExpression()), !dbg !15
  %2 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_write(i32 16438, i64 %2, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i32 0, i32 0))
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !16, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.declare(metadata i32* %i, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32* %len, metadata !20, metadata !DIExpression()), !dbg !21
  %3 = ptrtoint i32* %len to i64
  call void @__dp_write(i32 16441, i64 %3, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  store i32 100, i32* %len, align 4, !dbg !21
  %4 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 16443, i64 %4, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i32 0, i32 0))
  %5 = load i32, i32* %argc.addr, align 4, !dbg !22
  %cmp = icmp sgt i32 %5, 1, !dbg !24
  br i1 %cmp, label %if.then, label %if.end, !dbg !25

if.then:                                          ; preds = %entry
  %6 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 16444, i64 %6, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i32 0, i32 0))
  %7 = load i8**, i8*** %argv.addr, align 8, !dbg !26
  %arrayidx = getelementptr inbounds i8*, i8** %7, i64 1, !dbg !26
  %8 = ptrtoint i8** %arrayidx to i64
  call void @__dp_read(i32 16444, i64 %8, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i32 0, i32 0))
  %9 = load i8*, i8** %arrayidx, align 8, !dbg !26
  call void @__dp_call(i32 16444), !dbg !27
  %call = call i32 @atoi(i8* %9) #4, !dbg !27
  %10 = ptrtoint i32* %len to i64
  call void @__dp_write(i32 16444, i64 %10, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  store i32 %call, i32* %len, align 4, !dbg !28
  br label %if.end, !dbg !29

if.end:                                           ; preds = %if.then, %entry
  %11 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16446, i64 %11, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  %12 = load i32, i32* %len, align 4, !dbg !30
  %13 = zext i32 %12 to i64, !dbg !31
  call void @__dp_call(i32 16446), !dbg !31
  %14 = call i8* @llvm.stacksave(), !dbg !31
  %15 = ptrtoint i8** %saved_stack to i64
  call void @__dp_write(i32 16446, i64 %15, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.4, i32 0, i32 0))
  store i8* %14, i8** %saved_stack, align 8, !dbg !31
  %vla = alloca i32, i64 %13, align 16, !dbg !31
  %16 = ptrtoint i64* %__vla_expr0 to i64
  call void @__dp_write(i32 16446, i64 %16, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.5, i32 0, i32 0))
  store i64 %13, i64* %__vla_expr0, align 8, !dbg !31
  call void @llvm.dbg.declare(metadata i64* %__vla_expr0, metadata !32, metadata !DIExpression()), !dbg !34
  call void @llvm.dbg.declare(metadata i32* %vla, metadata !35, metadata !DIExpression()), !dbg !39
  %17 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16447, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !40
  br label %for.cond, !dbg !42

for.cond:                                         ; preds = %for.inc, %if.end
  call void @__dp_loop_entry(i32 16447, i32 0)
  %18 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16447, i64 %18, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %19 = load i32, i32* %i, align 4, !dbg !43
  %20 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16447, i64 %20, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  %21 = load i32, i32* %len, align 4, !dbg !45
  %cmp1 = icmp slt i32 %19, %21, !dbg !46
  br i1 %cmp1, label %for.body, label %for.end, !dbg !47

for.body:                                         ; preds = %for.cond
  %22 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16448, i64 %22, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %23 = load i32, i32* %i, align 4, !dbg !48
  %24 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16448, i64 %24, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %25 = load i32, i32* %i, align 4, !dbg !49
  %idxprom = sext i32 %25 to i64, !dbg !50
  %arrayidx2 = getelementptr inbounds i32, i32* %vla, i64 %idxprom, !dbg !50
  %26 = ptrtoint i32* %arrayidx2 to i64
  call void @__dp_write(i32 16448, i64 %26, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 %23, i32* %arrayidx2, align 4, !dbg !51
  br label %for.inc, !dbg !50

for.inc:                                          ; preds = %for.body
  %27 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16447, i64 %27, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %28 = load i32, i32* %i, align 4, !dbg !52
  %inc = add nsw i32 %28, 1, !dbg !52
  %29 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16447, i64 %29, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !52
  br label %for.cond, !dbg !53, !llvm.loop !54

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16451, i32 0)
  %30 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16451, i64 %30, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !56
  br label %for.cond3, !dbg !58

for.cond3:                                        ; preds = %for.inc11, %for.end
  call void @__dp_loop_entry(i32 16451, i32 1)
  %31 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16451, i64 %31, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %32 = load i32, i32* %i, align 4, !dbg !59
  %33 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16451, i64 %33, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  %34 = load i32, i32* %len, align 4, !dbg !61
  %sub = sub nsw i32 %34, 1, !dbg !62
  %cmp4 = icmp slt i32 %32, %sub, !dbg !63
  br i1 %cmp4, label %for.body5, label %for.end13, !dbg !64

for.body5:                                        ; preds = %for.cond3
  %35 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16452, i64 %35, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %36 = load i32, i32* %i, align 4, !dbg !65
  %idxprom6 = sext i32 %36 to i64, !dbg !66
  %arrayidx7 = getelementptr inbounds i32, i32* %vla, i64 %idxprom6, !dbg !66
  %37 = ptrtoint i32* %arrayidx7 to i64
  call void @__dp_read(i32 16452, i64 %37, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %38 = load i32, i32* %arrayidx7, align 4, !dbg !66
  %add = add nsw i32 %38, 1, !dbg !67
  %39 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16452, i64 %39, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %40 = load i32, i32* %i, align 4, !dbg !68
  %add8 = add nsw i32 %40, 1, !dbg !69
  %idxprom9 = sext i32 %add8 to i64, !dbg !70
  %arrayidx10 = getelementptr inbounds i32, i32* %vla, i64 %idxprom9, !dbg !70
  %41 = ptrtoint i32* %arrayidx10 to i64
  call void @__dp_write(i32 16452, i64 %41, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 %add, i32* %arrayidx10, align 4, !dbg !71
  br label %for.inc11, !dbg !70

for.inc11:                                        ; preds = %for.body5
  %42 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16451, i64 %42, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %43 = load i32, i32* %i, align 4, !dbg !72
  %inc12 = add nsw i32 %43, 1, !dbg !72
  %44 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16451, i64 %44, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 %inc12, i32* %i, align 4, !dbg !72
  br label %for.cond3, !dbg !73, !llvm.loop !74

for.end13:                                        ; preds = %for.cond3
  call void @__dp_loop_exit(i32 16454, i32 1)
  %45 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16454, i64 %45, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  store i32 0, i32* %retval, align 4, !dbg !76
  %46 = ptrtoint i8** %saved_stack to i64
  call void @__dp_read(i32 16455, i64 %46, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.4, i32 0, i32 0))
  %47 = load i8*, i8** %saved_stack, align 8, !dbg !77
  call void @__dp_call(i32 16455), !dbg !77
  call void @llvm.stackrestore(i8* %47), !dbg !77
  %48 = ptrtoint i32* %retval to i64
  call void @__dp_read(i32 16455, i64 %48, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  %49 = load i32, i32* %retval, align 4, !dbg !77
  call void @__dp_finalize(i32 16455), !dbg !77
  ret i32 %49, !dbg !77
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_call(i32)

; Function Attrs: nounwind readonly
declare dso_local i32 @atoi(i8*) #2

; Function Attrs: nounwind
declare i8* @llvm.stacksave() #3

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_loop_exit(i32, i32)

; Function Attrs: nounwind
declare void @llvm.stackrestore(i8*) #3

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }
attributes #4 = { nounwind readonly }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!3}
!llvm.module.flags = !{!4, !5, !6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/030")
!2 = !{}
!3 = !{!"Ubuntu clang version 11.1.0-6"}
!4 = !{i32 7, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 54, type: !8, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10, !10, !11}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!13 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!14 = !DILocalVariable(name: "argc", arg: 1, scope: !7, file: !1, line: 54, type: !10)
!15 = !DILocation(line: 54, column: 14, scope: !7)
!16 = !DILocalVariable(name: "argv", arg: 2, scope: !7, file: !1, line: 54, type: !11)
!17 = !DILocation(line: 54, column: 26, scope: !7)
!18 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 56, type: !10)
!19 = !DILocation(line: 56, column: 7, scope: !7)
!20 = !DILocalVariable(name: "len", scope: !7, file: !1, line: 57, type: !10)
!21 = !DILocation(line: 57, column: 7, scope: !7)
!22 = !DILocation(line: 59, column: 7, scope: !23)
!23 = distinct !DILexicalBlock(scope: !7, file: !1, line: 59, column: 7)
!24 = !DILocation(line: 59, column: 11, scope: !23)
!25 = !DILocation(line: 59, column: 7, scope: !7)
!26 = !DILocation(line: 60, column: 16, scope: !23)
!27 = !DILocation(line: 60, column: 11, scope: !23)
!28 = !DILocation(line: 60, column: 9, scope: !23)
!29 = !DILocation(line: 60, column: 5, scope: !23)
!30 = !DILocation(line: 62, column: 9, scope: !7)
!31 = !DILocation(line: 62, column: 3, scope: !7)
!32 = !DILocalVariable(name: "__vla_expr0", scope: !7, type: !33, flags: DIFlagArtificial)
!33 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!34 = !DILocation(line: 0, scope: !7)
!35 = !DILocalVariable(name: "a", scope: !7, file: !1, line: 62, type: !36)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, elements: !37)
!37 = !{!38}
!38 = !DISubrange(count: !32)
!39 = !DILocation(line: 62, column: 7, scope: !7)
!40 = !DILocation(line: 63, column: 9, scope: !41)
!41 = distinct !DILexicalBlock(scope: !7, file: !1, line: 63, column: 3)
!42 = !DILocation(line: 63, column: 8, scope: !41)
!43 = !DILocation(line: 63, column: 12, scope: !44)
!44 = distinct !DILexicalBlock(scope: !41, file: !1, line: 63, column: 3)
!45 = !DILocation(line: 63, column: 14, scope: !44)
!46 = !DILocation(line: 63, column: 13, scope: !44)
!47 = !DILocation(line: 63, column: 3, scope: !41)
!48 = !DILocation(line: 64, column: 10, scope: !44)
!49 = !DILocation(line: 64, column: 7, scope: !44)
!50 = !DILocation(line: 64, column: 5, scope: !44)
!51 = !DILocation(line: 64, column: 9, scope: !44)
!52 = !DILocation(line: 63, column: 19, scope: !44)
!53 = !DILocation(line: 63, column: 3, scope: !44)
!54 = distinct !{!54, !47, !55}
!55 = !DILocation(line: 64, column: 10, scope: !41)
!56 = !DILocation(line: 67, column: 9, scope: !57)
!57 = distinct !DILexicalBlock(scope: !7, file: !1, line: 67, column: 3)
!58 = !DILocation(line: 67, column: 8, scope: !57)
!59 = !DILocation(line: 67, column: 12, scope: !60)
!60 = distinct !DILexicalBlock(scope: !57, file: !1, line: 67, column: 3)
!61 = !DILocation(line: 67, column: 14, scope: !60)
!62 = !DILocation(line: 67, column: 17, scope: !60)
!63 = !DILocation(line: 67, column: 13, scope: !60)
!64 = !DILocation(line: 67, column: 3, scope: !57)
!65 = !DILocation(line: 68, column: 14, scope: !60)
!66 = !DILocation(line: 68, column: 12, scope: !60)
!67 = !DILocation(line: 68, column: 16, scope: !60)
!68 = !DILocation(line: 68, column: 7, scope: !60)
!69 = !DILocation(line: 68, column: 8, scope: !60)
!70 = !DILocation(line: 68, column: 5, scope: !60)
!71 = !DILocation(line: 68, column: 11, scope: !60)
!72 = !DILocation(line: 67, column: 21, scope: !60)
!73 = !DILocation(line: 67, column: 3, scope: !60)
!74 = distinct !{!74, !64, !75}
!75 = !DILocation(line: 68, column: 17, scope: !57)
!76 = !DILocation(line: 70, column: 3, scope: !7)
!77 = !DILocation(line: 71, column: 1, scope: !7)
