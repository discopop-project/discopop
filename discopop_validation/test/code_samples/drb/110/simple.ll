; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [7 x i8] c"x==100\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"simple.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"x=%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !7 {
entry:
  %retval = alloca i32, align 4
  %x = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %x, metadata !11, metadata !DIExpression()), !dbg !12
  store i32 0, i32* %x, align 4, !dbg !12
  call void @llvm.dbg.declare(metadata i32* %i, metadata !13, metadata !DIExpression()), !dbg !15
  store i32 0, i32* %i, align 4, !dbg !15
  br label %for.cond, !dbg !16

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !17
  %cmp = icmp slt i32 %0, 100, !dbg !19
  br i1 %cmp, label %for.body, label %for.end, !dbg !20

for.body:                                         ; preds = %for.cond
  %1 = load i32, i32* %x, align 4, !dbg !21
  %inc = add nsw i32 %1, 1, !dbg !21
  store i32 %inc, i32* %x, align 4, !dbg !21
  br label %for.inc, !dbg !24

for.inc:                                          ; preds = %for.body
  %2 = load i32, i32* %i, align 4, !dbg !25
  %inc1 = add nsw i32 %2, 1, !dbg !25
  store i32 %inc1, i32* %i, align 4, !dbg !25
  br label %for.cond, !dbg !26, !llvm.loop !27

for.end:                                          ; preds = %for.cond
  %3 = load i32, i32* %x, align 4, !dbg !29
  %cmp2 = icmp eq i32 %3, 100, !dbg !29
  br i1 %cmp2, label %if.then, label %if.else, !dbg !32

if.then:                                          ; preds = %for.end
  br label %if.end, !dbg !32

if.else:                                          ; preds = %for.end
  call void @__assert_fail(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i64 0, i64 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i64 0, i64 0), i32 61, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !29
  unreachable, !dbg !29

if.end:                                           ; preds = %if.then
  %4 = load i32, i32* %x, align 4, !dbg !33
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.2, i64 0, i64 0), i32 %4), !dbg !34
  ret i32 0, !dbg !35
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noreturn nounwind
declare dso_local void @__assert_fail(i8*, i8*, i32, i8*) #2

declare dso_local i32 @printf(i8*, ...) #3

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noreturn nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/110")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"Ubuntu clang version 11.1.0-6"}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 51, type: !8, scopeLine: 52, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "x", scope: !7, file: !1, line: 53, type: !10)
!12 = !DILocation(line: 53, column: 7, scope: !7)
!13 = !DILocalVariable(name: "i", scope: !14, file: !1, line: 55, type: !10)
!14 = distinct !DILexicalBlock(scope: !7, file: !1, line: 55, column: 3)
!15 = !DILocation(line: 55, column: 12, scope: !14)
!16 = !DILocation(line: 55, column: 8, scope: !14)
!17 = !DILocation(line: 55, column: 19, scope: !18)
!18 = distinct !DILexicalBlock(scope: !14, file: !1, line: 55, column: 3)
!19 = !DILocation(line: 55, column: 21, scope: !18)
!20 = !DILocation(line: 55, column: 3, scope: !14)
!21 = !DILocation(line: 58, column: 8, scope: !22)
!22 = distinct !DILexicalBlock(scope: !23, file: !1, line: 57, column: 5)
!23 = distinct !DILexicalBlock(scope: !18, file: !1, line: 55, column: 33)
!24 = !DILocation(line: 60, column: 3, scope: !23)
!25 = !DILocation(line: 55, column: 28, scope: !18)
!26 = !DILocation(line: 55, column: 3, scope: !18)
!27 = distinct !{!27, !20, !28}
!28 = !DILocation(line: 60, column: 3, scope: !14)
!29 = !DILocation(line: 61, column: 3, scope: !30)
!30 = distinct !DILexicalBlock(scope: !31, file: !1, line: 61, column: 3)
!31 = distinct !DILexicalBlock(scope: !7, file: !1, line: 61, column: 3)
!32 = !DILocation(line: 61, column: 3, scope: !31)
!33 = !DILocation(line: 62, column: 20, scope: !7)
!34 = !DILocation(line: 62, column: 3, scope: !7)
!35 = !DILocation(line: 63, column: 3, scope: !7)
