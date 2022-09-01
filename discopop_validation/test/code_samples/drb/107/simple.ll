; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [11 x i8] c"result=%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [10 x i8] c"result==2\00", align 1
@.str.2 = private unnamed_addr constant [9 x i8] c"simple.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !7 {
entry:
  %retval = alloca i32, align 4
  %result = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %result, metadata !11, metadata !DIExpression()), !dbg !12
  store i32 0, i32* %result, align 4, !dbg !12
  %call = call i32 @sleep(i32 3), !dbg !13
  store i32 1, i32* %result, align 4, !dbg !18
  store i32 2, i32* %result, align 4, !dbg !19
  %0 = load i32, i32* %result, align 4, !dbg !21
  %call1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i32 %0), !dbg !22
  %1 = load i32, i32* %result, align 4, !dbg !23
  %cmp = icmp eq i32 %1, 2, !dbg !23
  br i1 %cmp, label %if.then, label %if.else, !dbg !26

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !26

if.else:                                          ; preds = %entry
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.1, i64 0, i64 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.2, i64 0, i64 0), i32 76, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !23
  unreachable, !dbg !23

if.end:                                           ; preds = %if.then
  ret i32 0, !dbg !27
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @sleep(i32) #2

declare dso_local i32 @printf(i8*, ...) #2

; Function Attrs: noreturn nounwind
declare dso_local void @__assert_fail(i8*, i8*, i32, i8*) #3

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noreturn nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/107")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"Ubuntu clang version 11.1.0-6"}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 54, type: !8, scopeLine: 55, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "result", scope: !7, file: !1, line: 56, type: !10)
!12 = !DILocation(line: 56, column: 7, scope: !7)
!13 = !DILocation(line: 65, column: 11, scope: !14)
!14 = distinct !DILexicalBlock(scope: !15, file: !1, line: 64, column: 9)
!15 = distinct !DILexicalBlock(scope: !16, file: !1, line: 62, column: 7)
!16 = distinct !DILexicalBlock(scope: !17, file: !1, line: 60, column: 5)
!17 = distinct !DILexicalBlock(scope: !7, file: !1, line: 58, column: 3)
!18 = !DILocation(line: 66, column: 18, scope: !14)
!19 = !DILocation(line: 71, column: 16, scope: !20)
!20 = distinct !DILexicalBlock(scope: !16, file: !1, line: 70, column: 7)
!21 = !DILocation(line: 75, column: 26, scope: !7)
!22 = !DILocation(line: 75, column: 3, scope: !7)
!23 = !DILocation(line: 76, column: 3, scope: !24)
!24 = distinct !DILexicalBlock(scope: !25, file: !1, line: 76, column: 3)
!25 = distinct !DILexicalBlock(scope: !7, file: !1, line: 76, column: 3)
!26 = !DILocation(line: 76, column: 3, scope: !25)
!27 = !DILocation(line: 77, column: 3, scope: !7)
