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
@.str.6 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.7 = private unnamed_addr constant [2 x i8] c"i\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16435, i32 1)
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %len = alloca i32, align 4
  %i = alloca i32, align 4
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
  call void @llvm.dbg.declare(metadata i32* %len, metadata !18, metadata !DIExpression()), !dbg !19
  %3 = ptrtoint i32* %len to i64
  call void @__dp_write(i32 16437, i64 %3, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  store i32 1000, i32* %len, align 4, !dbg !19
  call void @llvm.dbg.declare(metadata i32* %i, metadata !20, metadata !DIExpression()), !dbg !21
  %4 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 16440, i64 %4, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i32 0, i32 0))
  %5 = load i32, i32* %argc.addr, align 4, !dbg !22
  %cmp = icmp sgt i32 %5, 1, !dbg !24
  br i1 %cmp, label %if.then, label %if.end, !dbg !25

if.then:                                          ; preds = %entry
  %6 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 16441, i64 %6, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i32 0, i32 0))
  %7 = load i8**, i8*** %argv.addr, align 8, !dbg !26
  %arrayidx = getelementptr inbounds i8*, i8** %7, i64 1, !dbg !26
  %8 = ptrtoint i8** %arrayidx to i64
  call void @__dp_read(i32 16441, i64 %8, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i32 0, i32 0))
  %9 = load i8*, i8** %arrayidx, align 8, !dbg !26
  call void @__dp_call(i32 16441), !dbg !27
  %call = call i32 @atoi(i8* %9) #4, !dbg !27
  %10 = ptrtoint i32* %len to i64
  call void @__dp_write(i32 16441, i64 %10, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  store i32 %call, i32* %len, align 4, !dbg !28
  br label %if.end, !dbg !29

if.end:                                           ; preds = %if.then, %entry
  %11 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16442, i64 %11, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  %12 = load i32, i32* %len, align 4, !dbg !30
  %13 = zext i32 %12 to i64, !dbg !31
  call void @__dp_call(i32 16442), !dbg !31
  %14 = call i8* @llvm.stacksave(), !dbg !31
  %15 = ptrtoint i8** %saved_stack to i64
  call void @__dp_write(i32 16442, i64 %15, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.4, i32 0, i32 0))
  store i8* %14, i8** %saved_stack, align 8, !dbg !31
  %vla = alloca i32, i64 %13, align 16, !dbg !31
  %16 = ptrtoint i64* %__vla_expr0 to i64
  call void @__dp_write(i32 16442, i64 %16, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.5, i32 0, i32 0))
  store i64 %13, i64* %__vla_expr0, align 8, !dbg !31
  call void @llvm.dbg.declare(metadata i64* %__vla_expr0, metadata !32, metadata !DIExpression()), !dbg !34
  call void @llvm.dbg.declare(metadata i32* %vla, metadata !35, metadata !DIExpression()), !dbg !39
  %arrayidx1 = getelementptr inbounds i32, i32* %vla, i64 0, !dbg !40
  %17 = ptrtoint i32* %arrayidx1 to i64
  call void @__dp_write(i32 16443, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 2, i32* %arrayidx1, align 16, !dbg !41
  %18 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16446, i64 %18, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !42
  br label %for.cond, !dbg !44

for.cond:                                         ; preds = %for.inc, %if.end
  call void @__dp_loop_entry(i32 16446, i32 0)
  %19 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16446, i64 %19, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %20 = load i32, i32* %i, align 4, !dbg !45
  %21 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16446, i64 %21, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  %22 = load i32, i32* %len, align 4, !dbg !47
  %cmp2 = icmp slt i32 %20, %22, !dbg !48
  br i1 %cmp2, label %for.body, label %for.end, !dbg !49

for.body:                                         ; preds = %for.cond
  %23 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16447, i64 %23, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %24 = load i32, i32* %i, align 4, !dbg !50
  %idxprom = sext i32 %24 to i64, !dbg !51
  %arrayidx3 = getelementptr inbounds i32, i32* %vla, i64 %idxprom, !dbg !51
  %25 = ptrtoint i32* %arrayidx3 to i64
  call void @__dp_read(i32 16447, i64 %25, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %26 = load i32, i32* %arrayidx3, align 4, !dbg !51
  %arrayidx4 = getelementptr inbounds i32, i32* %vla, i64 0, !dbg !52
  %27 = ptrtoint i32* %arrayidx4 to i64
  call void @__dp_read(i32 16447, i64 %27, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %28 = load i32, i32* %arrayidx4, align 16, !dbg !52
  %add = add nsw i32 %26, %28, !dbg !53
  %29 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16447, i64 %29, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %30 = load i32, i32* %i, align 4, !dbg !54
  %idxprom5 = sext i32 %30 to i64, !dbg !55
  %arrayidx6 = getelementptr inbounds i32, i32* %vla, i64 %idxprom5, !dbg !55
  %31 = ptrtoint i32* %arrayidx6 to i64
  call void @__dp_write(i32 16447, i64 %31, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 %add, i32* %arrayidx6, align 4, !dbg !56
  br label %for.inc, !dbg !55

for.inc:                                          ; preds = %for.body
  %32 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16446, i64 %32, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %33 = load i32, i32* %i, align 4, !dbg !57
  %inc = add nsw i32 %33, 1, !dbg !57
  %34 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16446, i64 %34, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !57
  br label %for.cond, !dbg !58, !llvm.loop !59

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16449, i32 0)
  %35 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16449, i64 %35, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  store i32 0, i32* %retval, align 4, !dbg !61
  %36 = ptrtoint i8** %saved_stack to i64
  call void @__dp_read(i32 16450, i64 %36, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.4, i32 0, i32 0))
  %37 = load i8*, i8** %saved_stack, align 8, !dbg !62
  call void @__dp_call(i32 16450), !dbg !62
  call void @llvm.stackrestore(i8* %37), !dbg !62
  %38 = ptrtoint i32* %retval to i64
  call void @__dp_read(i32 16450, i64 %38, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  %39 = load i32, i32* %retval, align 4, !dbg !62
  call void @__dp_finalize(i32 16450), !dbg !62
  ret i32 %39, !dbg !62
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
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/040")
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
!15 = !DILocation(line: 51, column: 15, scope: !7)
!16 = !DILocalVariable(name: "argv", arg: 2, scope: !7, file: !1, line: 51, type: !11)
!17 = !DILocation(line: 51, column: 27, scope: !7)
!18 = !DILocalVariable(name: "len", scope: !7, file: !1, line: 53, type: !10)
!19 = !DILocation(line: 53, column: 7, scope: !7)
!20 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 54, type: !10)
!21 = !DILocation(line: 54, column: 7, scope: !7)
!22 = !DILocation(line: 56, column: 7, scope: !23)
!23 = distinct !DILexicalBlock(scope: !7, file: !1, line: 56, column: 7)
!24 = !DILocation(line: 56, column: 11, scope: !23)
!25 = !DILocation(line: 56, column: 7, scope: !7)
!26 = !DILocation(line: 57, column: 16, scope: !23)
!27 = !DILocation(line: 57, column: 11, scope: !23)
!28 = !DILocation(line: 57, column: 9, scope: !23)
!29 = !DILocation(line: 57, column: 5, scope: !23)
!30 = !DILocation(line: 58, column: 9, scope: !7)
!31 = !DILocation(line: 58, column: 3, scope: !7)
!32 = !DILocalVariable(name: "__vla_expr0", scope: !7, type: !33, flags: DIFlagArtificial)
!33 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!34 = !DILocation(line: 0, scope: !7)
!35 = !DILocalVariable(name: "a", scope: !7, file: !1, line: 58, type: !36)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, elements: !37)
!37 = !{!38}
!38 = !DISubrange(count: !32)
!39 = !DILocation(line: 58, column: 7, scope: !7)
!40 = !DILocation(line: 59, column: 3, scope: !7)
!41 = !DILocation(line: 59, column: 8, scope: !7)
!42 = !DILocation(line: 62, column: 9, scope: !43)
!43 = distinct !DILexicalBlock(scope: !7, file: !1, line: 62, column: 3)
!44 = !DILocation(line: 62, column: 8, scope: !43)
!45 = !DILocation(line: 62, column: 12, scope: !46)
!46 = distinct !DILexicalBlock(scope: !43, file: !1, line: 62, column: 3)
!47 = !DILocation(line: 62, column: 14, scope: !46)
!48 = !DILocation(line: 62, column: 13, scope: !46)
!49 = !DILocation(line: 62, column: 3, scope: !43)
!50 = !DILocation(line: 63, column: 12, scope: !46)
!51 = !DILocation(line: 63, column: 10, scope: !46)
!52 = !DILocation(line: 63, column: 15, scope: !46)
!53 = !DILocation(line: 63, column: 14, scope: !46)
!54 = !DILocation(line: 63, column: 7, scope: !46)
!55 = !DILocation(line: 63, column: 5, scope: !46)
!56 = !DILocation(line: 63, column: 9, scope: !46)
!57 = !DILocation(line: 62, column: 19, scope: !46)
!58 = !DILocation(line: 62, column: 3, scope: !46)
!59 = distinct !{!59, !49, !60}
!60 = !DILocation(line: 63, column: 18, scope: !43)
!61 = !DILocation(line: 65, column: 3, scope: !7)
!62 = !DILocation(line: 66, column: 1, scope: !7)
