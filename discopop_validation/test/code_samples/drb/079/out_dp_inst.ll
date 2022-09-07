; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.3 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"j\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"k\00", align 1
@.str = private unnamed_addr constant [11 x i8] c"j=%d k=%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [13 x i8] c"j==1 && k==1\00", align 1
@.str.2 = private unnamed_addr constant [9 x i8] c"simple.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16437, i32 1)
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16437, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !11, metadata !DIExpression()), !dbg !12
  %1 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16439, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !12
  call void @llvm.dbg.declare(metadata i32* %j, metadata !13, metadata !DIExpression()), !dbg !14
  call void @llvm.dbg.declare(metadata i32* %k, metadata !15, metadata !DIExpression()), !dbg !16
  call void @__dp_call(i32 16445), !dbg !17
  %call = call i32 @sleep(i32 3), !dbg !17
  %2 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16446, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store i32 1, i32* %i, align 4, !dbg !20
  %3 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16449, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %4 = load i32, i32* %i, align 4, !dbg !21
  %5 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16449, i64 %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 %4, i32* %j, align 4, !dbg !22
  %6 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16451, i64 %6, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %7 = load i32, i32* %i, align 4, !dbg !23
  %8 = ptrtoint i32* %k to i64
  call void @__dp_write(i32 16451, i64 %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 %7, i32* %k, align 4, !dbg !24
  %9 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16453, i64 %9, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %10 = load i32, i32* %j, align 4, !dbg !25
  %11 = ptrtoint i32* %k to i64
  call void @__dp_read(i32 16453, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %12 = load i32, i32* %k, align 4, !dbg !26
  call void @__dp_call(i32 16453), !dbg !27
  %call1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i32 %10, i32 %12), !dbg !27
  %13 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16454, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %14 = load i32, i32* %j, align 4, !dbg !28
  %cmp = icmp eq i32 %14, 1, !dbg !28
  br i1 %cmp, label %land.lhs.true, label %if.else, !dbg !28

land.lhs.true:                                    ; preds = %entry
  %15 = ptrtoint i32* %k to i64
  call void @__dp_read(i32 16454, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %16 = load i32, i32* %k, align 4, !dbg !28
  %cmp2 = icmp eq i32 %16, 1, !dbg !28
  br i1 %cmp2, label %if.then, label %if.else, !dbg !31

if.then:                                          ; preds = %land.lhs.true
  br label %if.end, !dbg !31

if.else:                                          ; preds = %land.lhs.true, %entry
  call void @__dp_finalize(i32 16454), !dbg !28
  call void @__assert_fail(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.1, i64 0, i64 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.2, i64 0, i64 0), i32 70, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !28
  unreachable, !dbg !28

if.end:                                           ; preds = %if.then
  call void @__dp_finalize(i32 16455), !dbg !32
  ret i32 0, !dbg !32
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_call(i32)

declare dso_local i32 @sleep(i32) #2

declare void @__dp_read(i32, i64, i8*)

declare dso_local i32 @printf(i8*, ...) #2

declare void @__dp_finalize(i32)

; Function Attrs: noreturn nounwind
declare dso_local void @__assert_fail(i8*, i8*, i32, i8*) #3

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noreturn nounwind }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!3}
!llvm.module.flags = !{!4, !5, !6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/079")
!2 = !{}
!3 = !{!"Ubuntu clang version 11.1.0-6"}
!4 = !{i32 7, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 53, type: !8, scopeLine: 54, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 55, type: !10)
!12 = !DILocation(line: 55, column: 7, scope: !7)
!13 = !DILocalVariable(name: "j", scope: !7, file: !1, line: 55, type: !10)
!14 = !DILocation(line: 55, column: 12, scope: !7)
!15 = !DILocalVariable(name: "k", scope: !7, file: !1, line: 55, type: !10)
!16 = !DILocation(line: 55, column: 15, scope: !7)
!17 = !DILocation(line: 61, column: 7, scope: !18)
!18 = distinct !DILexicalBlock(scope: !19, file: !1, line: 60, column: 5)
!19 = distinct !DILexicalBlock(scope: !7, file: !1, line: 58, column: 3)
!20 = !DILocation(line: 62, column: 9, scope: !18)
!21 = !DILocation(line: 65, column: 8, scope: !19)
!22 = !DILocation(line: 65, column: 7, scope: !19)
!23 = !DILocation(line: 67, column: 8, scope: !19)
!24 = !DILocation(line: 67, column: 7, scope: !19)
!25 = !DILocation(line: 69, column: 26, scope: !7)
!26 = !DILocation(line: 69, column: 29, scope: !7)
!27 = !DILocation(line: 69, column: 3, scope: !7)
!28 = !DILocation(line: 70, column: 3, scope: !29)
!29 = distinct !DILexicalBlock(scope: !30, file: !1, line: 70, column: 3)
!30 = distinct !DILexicalBlock(scope: !7, file: !1, line: 70, column: 3)
!31 = !DILocation(line: 70, column: 3, scope: !30)
!32 = !DILocation(line: 71, column: 3, scope: !7)
