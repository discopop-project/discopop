; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.1 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"argc\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"argv\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"len\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str = private unnamed_addr constant [5 x i8] c"x=%d\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16438, i32 1)
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %x = alloca i32, align 4
  %len = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16438, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  %1 = ptrtoint i32* %argc.addr to i64
  call void @__dp_write(i32 16438, i64 %1, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i32 0, i32 0))
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !14, metadata !DIExpression()), !dbg !15
  %2 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_write(i32 16438, i64 %2, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0))
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !16, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.declare(metadata i32* %i, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32* %x, metadata !20, metadata !DIExpression()), !dbg !21
  call void @llvm.dbg.declare(metadata i32* %len, metadata !22, metadata !DIExpression()), !dbg !23
  %3 = ptrtoint i32* %len to i64
  call void @__dp_write(i32 16441, i64 %3, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  store i32 10000, i32* %len, align 4, !dbg !23
  %4 = ptrtoint i32* %argc.addr to i64
  call void @__dp_read(i32 16442, i64 %4, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i32 0, i32 0))
  %5 = load i32, i32* %argc.addr, align 4, !dbg !24
  %cmp = icmp sgt i32 %5, 1, !dbg !26
  br i1 %cmp, label %if.then, label %if.end, !dbg !27

if.then:                                          ; preds = %entry
  %6 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_read(i32 16443, i64 %6, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0))
  %7 = load i8**, i8*** %argv.addr, align 8, !dbg !28
  %arrayidx = getelementptr inbounds i8*, i8** %7, i64 1, !dbg !28
  %8 = ptrtoint i8** %arrayidx to i64
  call void @__dp_read(i32 16443, i64 %8, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0))
  %9 = load i8*, i8** %arrayidx, align 8, !dbg !28
  call void @__dp_call(i32 16443), !dbg !29
  %call = call i32 @atoi(i8* %9) #4, !dbg !29
  %10 = ptrtoint i32* %len to i64
  call void @__dp_write(i32 16443, i64 %10, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  store i32 %call, i32* %len, align 4, !dbg !30
  br label %if.end, !dbg !31

if.end:                                           ; preds = %if.then, %entry
  %11 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16446, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !32
  br label %for.cond, !dbg !34

for.cond:                                         ; preds = %for.inc, %if.end
  call void @__dp_loop_entry(i32 16446, i32 0)
  %12 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16446, i64 %12, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %13 = load i32, i32* %i, align 4, !dbg !35
  %14 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16446, i64 %14, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  %15 = load i32, i32* %len, align 4, !dbg !37
  %cmp1 = icmp slt i32 %13, %15, !dbg !38
  br i1 %cmp1, label %for.body, label %for.end, !dbg !39

for.body:                                         ; preds = %for.cond
  %16 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16447, i64 %16, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %17 = load i32, i32* %i, align 4, !dbg !40
  %18 = ptrtoint i32* %x to i64
  call void @__dp_write(i32 16447, i64 %18, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 %17, i32* %x, align 4, !dbg !41
  br label %for.inc, !dbg !42

for.inc:                                          ; preds = %for.body
  %19 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16446, i64 %19, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %20 = load i32, i32* %i, align 4, !dbg !43
  %inc = add nsw i32 %20, 1, !dbg !43
  %21 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16446, i64 %21, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !43
  br label %for.cond, !dbg !44, !llvm.loop !45

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16448, i32 0)
  %22 = ptrtoint i32* %x to i64
  call void @__dp_read(i32 16448, i64 %22, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %23 = load i32, i32* %x, align 4, !dbg !47
  call void @__dp_call(i32 16448), !dbg !48
  %call2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i64 0, i64 0), i32 %23), !dbg !48
  call void @__dp_finalize(i32 16449), !dbg !49
  ret i32 0, !dbg !49
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_call(i32)

; Function Attrs: nounwind readonly
declare dso_local i32 @atoi(i8*) #2

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_loop_exit(i32, i32)

declare dso_local i32 @printf(i8*, ...) #3

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind readonly }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!3}
!llvm.module.flags = !{!4, !5, !6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/010")
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
!20 = !DILocalVariable(name: "x", scope: !7, file: !1, line: 56, type: !10)
!21 = !DILocation(line: 56, column: 9, scope: !7)
!22 = !DILocalVariable(name: "len", scope: !7, file: !1, line: 57, type: !10)
!23 = !DILocation(line: 57, column: 7, scope: !7)
!24 = !DILocation(line: 58, column: 7, scope: !25)
!25 = distinct !DILexicalBlock(scope: !7, file: !1, line: 58, column: 7)
!26 = !DILocation(line: 58, column: 11, scope: !25)
!27 = !DILocation(line: 58, column: 7, scope: !7)
!28 = !DILocation(line: 59, column: 16, scope: !25)
!29 = !DILocation(line: 59, column: 11, scope: !25)
!30 = !DILocation(line: 59, column: 9, scope: !25)
!31 = !DILocation(line: 59, column: 5, scope: !25)
!32 = !DILocation(line: 62, column: 9, scope: !33)
!33 = distinct !DILexicalBlock(scope: !7, file: !1, line: 62, column: 3)
!34 = !DILocation(line: 62, column: 8, scope: !33)
!35 = !DILocation(line: 62, column: 12, scope: !36)
!36 = distinct !DILexicalBlock(scope: !33, file: !1, line: 62, column: 3)
!37 = !DILocation(line: 62, column: 14, scope: !36)
!38 = !DILocation(line: 62, column: 13, scope: !36)
!39 = !DILocation(line: 62, column: 3, scope: !33)
!40 = !DILocation(line: 63, column: 7, scope: !36)
!41 = !DILocation(line: 63, column: 6, scope: !36)
!42 = !DILocation(line: 63, column: 5, scope: !36)
!43 = !DILocation(line: 62, column: 19, scope: !36)
!44 = !DILocation(line: 62, column: 3, scope: !36)
!45 = distinct !{!45, !39, !46}
!46 = !DILocation(line: 63, column: 7, scope: !33)
!47 = !DILocation(line: 64, column: 17, scope: !7)
!48 = !DILocation(line: 64, column: 3, scope: !7)
!49 = !DILocation(line: 65, column: 3, scope: !7)
