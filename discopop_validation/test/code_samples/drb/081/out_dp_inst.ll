; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.3 = private unnamed_addr constant [2 x i8] c"q\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str = private unnamed_addr constant [5 x i8] c"i==0\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"simple.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"i=%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @f1(i32 %q) #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16439, i32 0)
  %q.addr = alloca i32, align 4
  %0 = ptrtoint i32* %q.addr to i64
  call void @__dp_write(i32 16439, i64 %0, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 %q, i32* %q.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %q.addr, metadata !11, metadata !DIExpression()), !dbg !12
  %1 = ptrtoint i32* %q.addr to i64
  call void @__dp_read(i32 16441, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  %2 = load i32, i32* %q.addr, align 4, !dbg !13
  %add = add nsw i32 %2, 1, !dbg !13
  %3 = ptrtoint i32* %q.addr to i64
  call void @__dp_write(i32 16441, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
  store i32 %add, i32* %q.addr, align 4, !dbg !13
  call void @__dp_func_exit(i32 16442, i32 0), !dbg !14
  ret void, !dbg !14
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_func_exit(i32, i32)

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !15 {
entry:
  call void @__dp_func_entry(i32 16444, i32 1)
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16444, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !18, metadata !DIExpression()), !dbg !19
  %1 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16446, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !19
  %2 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16449, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %3 = load i32, i32* %i, align 4, !dbg !20
  call void @__dp_call(i32 16449), !dbg !22
  call void @f1(i32 %3), !dbg !22
  %4 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16451, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %5 = load i32, i32* %i, align 4, !dbg !23
  %cmp = icmp eq i32 %5, 0, !dbg !23
  br i1 %cmp, label %if.then, label %if.else, !dbg !26

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !26

if.else:                                          ; preds = %entry
  call void @__dp_finalize(i32 16451), !dbg !23
  call void @__assert_fail(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i64 0, i64 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i64 0, i64 0), i32 67, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !23
  unreachable, !dbg !23

if.end:                                           ; preds = %if.then
  %6 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16452, i64 %6, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %7 = load i32, i32* %i, align 4, !dbg !27
  call void @__dp_call(i32 16452), !dbg !28
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.2, i64 0, i64 0), i32 %7), !dbg !28
  call void @__dp_finalize(i32 16453), !dbg !29
  ret i32 0, !dbg !29
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
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/081")
!2 = !{}
!3 = !{!"Ubuntu clang version 11.1.0-6"}
!4 = !{i32 7, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = distinct !DISubprogram(name: "f1", scope: !1, file: !1, line: 55, type: !8, scopeLine: 56, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{null, !10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "q", arg: 1, scope: !7, file: !1, line: 55, type: !10)
!12 = !DILocation(line: 55, column: 13, scope: !7)
!13 = !DILocation(line: 57, column: 5, scope: !7)
!14 = !DILocation(line: 58, column: 1, scope: !7)
!15 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 60, type: !16, scopeLine: 61, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!16 = !DISubroutineType(types: !17)
!17 = !{!10}
!18 = !DILocalVariable(name: "i", scope: !15, file: !1, line: 62, type: !10)
!19 = !DILocation(line: 62, column: 7, scope: !15)
!20 = !DILocation(line: 65, column: 9, scope: !21)
!21 = distinct !DILexicalBlock(scope: !15, file: !1, line: 64, column: 3)
!22 = !DILocation(line: 65, column: 6, scope: !21)
!23 = !DILocation(line: 67, column: 3, scope: !24)
!24 = distinct !DILexicalBlock(scope: !25, file: !1, line: 67, column: 3)
!25 = distinct !DILexicalBlock(scope: !15, file: !1, line: 67, column: 3)
!26 = !DILocation(line: 67, column: 3, scope: !25)
!27 = !DILocation(line: 68, column: 20, scope: !15)
!28 = !DILocation(line: 68, column: 3, scope: !15)
!29 = !DILocation(line: 69, column: 3, scope: !15)
