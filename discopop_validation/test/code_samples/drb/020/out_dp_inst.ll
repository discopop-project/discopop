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
@.str.8 = private unnamed_addr constant [4 x i8] c"tmp\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16435, i32 1)
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %tmp = alloca i32, align 4
  %len = alloca i32, align 4
  %saved_stack = alloca i8*, align 8
  %__vla_expr0 = alloca i64, align 8
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16435, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  %1 = ptrtoint i32* %argc.addr to i64
  call void @__dp_write(i32 16435, i64 %1, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i32 0, i32 0))
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !14, metadata !DIExpression()), !dbg !15
  %2 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_write(i32 16435, i64 %2, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i32 0, i32 0))
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !16, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.declare(metadata i32* %i, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32* %tmp, metadata !20, metadata !DIExpression()), !dbg !21
  call void @llvm.dbg.declare(metadata i32* %len, metadata !22, metadata !DIExpression()), !dbg !23
  %3 = ptrtoint i32* %len to i64
  call void @__dp_write(i32 16439, i64 %3, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  store i32 100, i32* %len, align 4, !dbg !23
  %4 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 16440, i64 %4, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i32 0, i32 0))
  %5 = load i32, i32* %argc.addr, align 4, !dbg !24
  %cmp = icmp sgt i32 %5, 1, !dbg !26
  br i1 %cmp, label %if.then, label %if.end, !dbg !27

if.then:                                          ; preds = %entry
  %6 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 16441, i64 %6, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i32 0, i32 0))
  %7 = load i8**, i8*** %argv.addr, align 8, !dbg !28
  %arrayidx = getelementptr inbounds i8*, i8** %7, i64 1, !dbg !28
  %8 = ptrtoint i8** %arrayidx to i64
  call void @__dp_read(i32 16441, i64 %8, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i32 0, i32 0))
  %9 = load i8*, i8** %arrayidx, align 8, !dbg !28
  call void @__dp_call(i32 16441), !dbg !29
  %call = call i32 @atoi(i8* %9) #4, !dbg !29
  %10 = ptrtoint i32* %len to i64
  call void @__dp_write(i32 16441, i64 %10, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  store i32 %call, i32* %len, align 4, !dbg !30
  br label %if.end, !dbg !31

if.end:                                           ; preds = %if.then, %entry
  %11 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16442, i64 %11, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  %12 = load i32, i32* %len, align 4, !dbg !32
  %13 = zext i32 %12 to i64, !dbg !33
  call void @__dp_call(i32 16442), !dbg !33
  %14 = call i8* @llvm.stacksave(), !dbg !33
  %15 = ptrtoint i8** %saved_stack to i64
  call void @__dp_write(i32 16442, i64 %15, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.4, i32 0, i32 0))
  store i8* %14, i8** %saved_stack, align 8, !dbg !33
  %vla = alloca i32, i64 %13, align 16, !dbg !33
  %16 = ptrtoint i64* %__vla_expr0 to i64
  call void @__dp_write(i32 16442, i64 %16, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.5, i32 0, i32 0))
  store i64 %13, i64* %__vla_expr0, align 8, !dbg !33
  call void @llvm.dbg.declare(metadata i64* %__vla_expr0, metadata !34, metadata !DIExpression()), !dbg !36
  call void @llvm.dbg.declare(metadata i32* %vla, metadata !37, metadata !DIExpression()), !dbg !41
  %17 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16443, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !42
  br label %for.cond, !dbg !44

for.cond:                                         ; preds = %for.inc, %if.end
  call void @__dp_loop_entry(i32 16443, i32 0)
  %18 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16443, i64 %18, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %19 = load i32, i32* %i, align 4, !dbg !45
  %20 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16443, i64 %20, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  %21 = load i32, i32* %len, align 4, !dbg !47
  %cmp1 = icmp slt i32 %19, %21, !dbg !48
  br i1 %cmp1, label %for.body, label %for.end, !dbg !49

for.body:                                         ; preds = %for.cond
  %22 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16444, i64 %22, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %23 = load i32, i32* %i, align 4, !dbg !50
  %24 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16444, i64 %24, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %25 = load i32, i32* %i, align 4, !dbg !51
  %idxprom = sext i32 %25 to i64, !dbg !52
  %arrayidx2 = getelementptr inbounds i32, i32* %vla, i64 %idxprom, !dbg !52
  %26 = ptrtoint i32* %arrayidx2 to i64
  call void @__dp_write(i32 16444, i64 %26, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 %23, i32* %arrayidx2, align 4, !dbg !53
  br label %for.inc, !dbg !52

for.inc:                                          ; preds = %for.body
  %27 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16443, i64 %27, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %28 = load i32, i32* %i, align 4, !dbg !54
  %inc = add nsw i32 %28, 1, !dbg !54
  %29 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16443, i64 %29, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !54
  br label %for.cond, !dbg !55, !llvm.loop !56

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16447, i32 0)
  %30 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16447, i64 %30, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !58
  br label %for.cond3, !dbg !60

for.cond3:                                        ; preds = %for.inc10, %for.end
  call void @__dp_loop_entry(i32 16447, i32 1)
  %31 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16447, i64 %31, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %32 = load i32, i32* %i, align 4, !dbg !61
  %33 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16447, i64 %33, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  %34 = load i32, i32* %len, align 4, !dbg !63
  %cmp4 = icmp slt i32 %32, %34, !dbg !64
  br i1 %cmp4, label %for.body5, label %for.end12, !dbg !65

for.body5:                                        ; preds = %for.cond3
  %35 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16449, i64 %35, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %36 = load i32, i32* %i, align 4, !dbg !66
  %idxprom6 = sext i32 %36 to i64, !dbg !68
  %arrayidx7 = getelementptr inbounds i32, i32* %vla, i64 %idxprom6, !dbg !68
  %37 = ptrtoint i32* %arrayidx7 to i64
  call void @__dp_read(i32 16449, i64 %37, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %38 = load i32, i32* %arrayidx7, align 4, !dbg !68
  %39 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16449, i64 %39, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %40 = load i32, i32* %i, align 4, !dbg !69
  %add = add nsw i32 %38, %40, !dbg !70
  %41 = ptrtoint i32* %tmp to i64
  call void @__dp_write(i32 16449, i64 %41, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i32 0, i32 0))
  store i32 %add, i32* %tmp, align 4, !dbg !71
  %42 = ptrtoint i32* %tmp to i64
  call void @__dp_read(i32 16450, i64 %42, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.8, i32 0, i32 0))
  %43 = load i32, i32* %tmp, align 4, !dbg !72
  %44 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16450, i64 %44, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %45 = load i32, i32* %i, align 4, !dbg !73
  %idxprom8 = sext i32 %45 to i64, !dbg !74
  %arrayidx9 = getelementptr inbounds i32, i32* %vla, i64 %idxprom8, !dbg !74
  %46 = ptrtoint i32* %arrayidx9 to i64
  call void @__dp_write(i32 16450, i64 %46, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 %43, i32* %arrayidx9, align 4, !dbg !75
  br label %for.inc10, !dbg !76

for.inc10:                                        ; preds = %for.body5
  %47 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16447, i64 %47, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %48 = load i32, i32* %i, align 4, !dbg !77
  %inc11 = add nsw i32 %48, 1, !dbg !77
  %49 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16447, i64 %49, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 %inc11, i32* %i, align 4, !dbg !77
  br label %for.cond3, !dbg !78, !llvm.loop !79

for.end12:                                        ; preds = %for.cond3
  call void @__dp_loop_exit(i32 16452, i32 1)
  %50 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16452, i64 %50, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  store i32 0, i32* %retval, align 4, !dbg !81
  %51 = ptrtoint i8** %saved_stack to i64
  call void @__dp_read(i32 16453, i64 %51, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.4, i32 0, i32 0))
  %52 = load i8*, i8** %saved_stack, align 8, !dbg !82
  call void @__dp_call(i32 16453), !dbg !82
  call void @llvm.stackrestore(i8* %52), !dbg !82
  %53 = ptrtoint i32* %retval to i64
  call void @__dp_read(i32 16453, i64 %53, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  %54 = load i32, i32* %retval, align 4, !dbg !82
  call void @__dp_finalize(i32 16453), !dbg !82
  ret i32 %54, !dbg !82
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
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/020")
!2 = !{}
!3 = !{!"Ubuntu clang version 11.1.0-6"}
!4 = !{i32 7, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 51, type: !8, scopeLine: 52, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10, !10, !11}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!13 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!14 = !DILocalVariable(name: "argc", arg: 1, scope: !7, file: !1, line: 51, type: !10)
!15 = !DILocation(line: 51, column: 14, scope: !7)
!16 = !DILocalVariable(name: "argv", arg: 2, scope: !7, file: !1, line: 51, type: !11)
!17 = !DILocation(line: 51, column: 26, scope: !7)
!18 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 53, type: !10)
!19 = !DILocation(line: 53, column: 7, scope: !7)
!20 = !DILocalVariable(name: "tmp", scope: !7, file: !1, line: 54, type: !10)
!21 = !DILocation(line: 54, column: 7, scope: !7)
!22 = !DILocalVariable(name: "len", scope: !7, file: !1, line: 55, type: !10)
!23 = !DILocation(line: 55, column: 7, scope: !7)
!24 = !DILocation(line: 56, column: 7, scope: !25)
!25 = distinct !DILexicalBlock(scope: !7, file: !1, line: 56, column: 7)
!26 = !DILocation(line: 56, column: 11, scope: !25)
!27 = !DILocation(line: 56, column: 7, scope: !7)
!28 = !DILocation(line: 57, column: 16, scope: !25)
!29 = !DILocation(line: 57, column: 11, scope: !25)
!30 = !DILocation(line: 57, column: 9, scope: !25)
!31 = !DILocation(line: 57, column: 5, scope: !25)
!32 = !DILocation(line: 58, column: 9, scope: !7)
!33 = !DILocation(line: 58, column: 3, scope: !7)
!34 = !DILocalVariable(name: "__vla_expr0", scope: !7, type: !35, flags: DIFlagArtificial)
!35 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!36 = !DILocation(line: 0, scope: !7)
!37 = !DILocalVariable(name: "a", scope: !7, file: !1, line: 58, type: !38)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, elements: !39)
!39 = !{!40}
!40 = !DISubrange(count: !34)
!41 = !DILocation(line: 58, column: 7, scope: !7)
!42 = !DILocation(line: 59, column: 9, scope: !43)
!43 = distinct !DILexicalBlock(scope: !7, file: !1, line: 59, column: 3)
!44 = !DILocation(line: 59, column: 8, scope: !43)
!45 = !DILocation(line: 59, column: 12, scope: !46)
!46 = distinct !DILexicalBlock(scope: !43, file: !1, line: 59, column: 3)
!47 = !DILocation(line: 59, column: 14, scope: !46)
!48 = !DILocation(line: 59, column: 13, scope: !46)
!49 = !DILocation(line: 59, column: 3, scope: !43)
!50 = !DILocation(line: 60, column: 10, scope: !46)
!51 = !DILocation(line: 60, column: 7, scope: !46)
!52 = !DILocation(line: 60, column: 5, scope: !46)
!53 = !DILocation(line: 60, column: 9, scope: !46)
!54 = !DILocation(line: 59, column: 19, scope: !46)
!55 = !DILocation(line: 59, column: 3, scope: !46)
!56 = distinct !{!56, !49, !57}
!57 = !DILocation(line: 60, column: 10, scope: !43)
!58 = !DILocation(line: 63, column: 9, scope: !59)
!59 = distinct !DILexicalBlock(scope: !7, file: !1, line: 63, column: 3)
!60 = !DILocation(line: 63, column: 8, scope: !59)
!61 = !DILocation(line: 63, column: 12, scope: !62)
!62 = distinct !DILexicalBlock(scope: !59, file: !1, line: 63, column: 3)
!63 = !DILocation(line: 63, column: 14, scope: !62)
!64 = !DILocation(line: 63, column: 13, scope: !62)
!65 = !DILocation(line: 63, column: 3, scope: !59)
!66 = !DILocation(line: 65, column: 12, scope: !67)
!67 = distinct !DILexicalBlock(scope: !62, file: !1, line: 64, column: 3)
!68 = !DILocation(line: 65, column: 10, scope: !67)
!69 = !DILocation(line: 65, column: 15, scope: !67)
!70 = !DILocation(line: 65, column: 14, scope: !67)
!71 = !DILocation(line: 65, column: 9, scope: !67)
!72 = !DILocation(line: 66, column: 12, scope: !67)
!73 = !DILocation(line: 66, column: 7, scope: !67)
!74 = !DILocation(line: 66, column: 5, scope: !67)
!75 = !DILocation(line: 66, column: 10, scope: !67)
!76 = !DILocation(line: 67, column: 3, scope: !67)
!77 = !DILocation(line: 63, column: 19, scope: !62)
!78 = !DILocation(line: 63, column: 3, scope: !62)
!79 = distinct !{!79, !65, !80}
!80 = !DILocation(line: 67, column: 3, scope: !59)
!81 = !DILocation(line: 68, column: 3, scope: !7)
!82 = !DILocation(line: 69, column: 1, scope: !7)
