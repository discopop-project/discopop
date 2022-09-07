; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.3 = private unnamed_addr constant [2 x i8] c"q\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.6 = private unnamed_addr constant [4 x i8] c"sum\00", align 1
@.str = private unnamed_addr constant [8 x i8] c"sum==10\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"simple.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1
@.str.2 = private unnamed_addr constant [8 x i8] c"sum=%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @f1(i32* %q) #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16441, i32 0)
  %q.addr = alloca i32*, align 8
  %0 = ptrtoint i32** %q.addr to i64
  call void @__dp_write(i32 16441, i64 %0, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32* %q, i32** %q.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %q.addr, metadata !12, metadata !DIExpression()), !dbg !13
  %1 = ptrtoint i32** %q.addr to i64
  call void @__dp_read(i32 16444, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %2 = load i32*, i32** %q.addr, align 8, !dbg !14
  %3 = ptrtoint i32* %2 to i64
  call void @__dp_write(i32 16444, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 1, i32* %2, align 4, !dbg !15
  call void @__dp_func_exit(i32 16446, i32 0), !dbg !16
  ret void, !dbg !16
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_func_exit(i32, i32)

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !17 {
entry:
  call void @__dp_func_entry(i32 16448, i32 1)
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %sum = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16448, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !20, metadata !DIExpression()), !dbg !21
  %1 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16450, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !21
  call void @llvm.dbg.declare(metadata i32* %sum, metadata !22, metadata !DIExpression()), !dbg !23
  %2 = ptrtoint i32* %sum to i64
  call void @__dp_write(i32 16450, i64 %2, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.6, i32 0, i32 0))
  store i32 0, i32* %sum, align 4, !dbg !23
  call void @__dp_call(i32 16454), !dbg !24
  call void @f1(i32* %i), !dbg !24
  %3 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16455, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %4 = load i32, i32* %i, align 4, !dbg !26
  %5 = ptrtoint i32* %sum to i64
  call void @__dp_read(i32 16455, i64 %5, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.6, i32 0, i32 0))
  %6 = load i32, i32* %sum, align 4, !dbg !27
  %add = add nsw i32 %6, %4, !dbg !27
  %7 = ptrtoint i32* %sum to i64
  call void @__dp_write(i32 16455, i64 %7, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.6, i32 0, i32 0))
  store i32 %add, i32* %sum, align 4, !dbg !27
  %8 = ptrtoint i32* %sum to i64
  call void @__dp_read(i32 16457, i64 %8, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.6, i32 0, i32 0))
  %9 = load i32, i32* %sum, align 4, !dbg !28
  %cmp = icmp eq i32 %9, 10, !dbg !28
  br i1 %cmp, label %if.then, label %if.else, !dbg !31

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !31

if.else:                                          ; preds = %entry
  call void @__dp_finalize(i32 16457), !dbg !28
  call void @__assert_fail(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i64 0, i64 0), i32 73, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !28
  unreachable, !dbg !28

if.end:                                           ; preds = %if.then
  %10 = ptrtoint i32* %sum to i64
  call void @__dp_read(i32 16458, i64 %10, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.6, i32 0, i32 0))
  %11 = load i32, i32* %sum, align 4, !dbg !32
  call void @__dp_call(i32 16458), !dbg !33
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.2, i64 0, i64 0), i32 %11), !dbg !33
  call void @__dp_finalize(i32 16459), !dbg !34
  ret i32 0, !dbg !34
}

declare void @__dp_call(i32)

declare void @__dp_finalize(i32)

; Function Attrs: noreturn nounwind
declare dso_local void @__assert_fail(i8*, i8*, i32, i8*) #2

declare dso_local i32 @printf(i8*, ...) #3

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noreturn nounwind }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!3}
!llvm.module.flags = !{!4, !5, !6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/074")
!2 = !{}
!3 = !{!"Ubuntu clang version 11.1.0-6"}
!4 = !{i32 7, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = distinct !DISubprogram(name: "f1", scope: !1, file: !1, line: 57, type: !8, scopeLine: 58, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{null, !10}
!10 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 64)
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !DILocalVariable(name: "q", arg: 1, scope: !7, file: !1, line: 57, type: !10)
!13 = !DILocation(line: 57, column: 14, scope: !7)
!14 = !DILocation(line: 60, column: 4, scope: !7)
!15 = !DILocation(line: 60, column: 6, scope: !7)
!16 = !DILocation(line: 62, column: 1, scope: !7)
!17 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 64, type: !18, scopeLine: 65, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!18 = !DISubroutineType(types: !19)
!19 = !{!11}
!20 = !DILocalVariable(name: "i", scope: !17, file: !1, line: 66, type: !11)
!21 = !DILocation(line: 66, column: 7, scope: !17)
!22 = !DILocalVariable(name: "sum", scope: !17, file: !1, line: 66, type: !11)
!23 = !DILocation(line: 66, column: 12, scope: !17)
!24 = !DILocation(line: 70, column: 6, scope: !25)
!25 = distinct !DILexicalBlock(scope: !17, file: !1, line: 69, column: 3)
!26 = !DILocation(line: 71, column: 11, scope: !25)
!27 = !DILocation(line: 71, column: 9, scope: !25)
!28 = !DILocation(line: 73, column: 3, scope: !29)
!29 = distinct !DILexicalBlock(scope: !30, file: !1, line: 73, column: 3)
!30 = distinct !DILexicalBlock(scope: !17, file: !1, line: 73, column: 3)
!31 = !DILocation(line: 73, column: 3, scope: !30)
!32 = !DILocation(line: 74, column: 22, scope: !17)
!33 = !DILocation(line: 74, column: 3, scope: !17)
!34 = !DILocation(line: 75, column: 3, scope: !17)
