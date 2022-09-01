; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !7 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %var = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !14, metadata !DIExpression()), !dbg !15
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !16, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.declare(metadata i32* %var, metadata !18, metadata !DIExpression()), !dbg !19
  store i32 0, i32* %var, align 4, !dbg !19
  call void @llvm.dbg.declare(metadata i32* %i, metadata !20, metadata !DIExpression()), !dbg !21
  store i32 0, i32* %i, align 4, !dbg !22
  br label %for.cond, !dbg !25

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !26
  %cmp = icmp slt i32 %0, 10, !dbg !28
  br i1 %cmp, label %for.body, label %for.end, !dbg !29

for.body:                                         ; preds = %for.cond
  %1 = load i32, i32* %var, align 4, !dbg !30
  %inc = add nsw i32 %1, 1, !dbg !30
  store i32 %inc, i32* %var, align 4, !dbg !30
  br label %for.inc, !dbg !33

for.inc:                                          ; preds = %for.body
  %2 = load i32, i32* %i, align 4, !dbg !34
  %inc1 = add nsw i32 %2, 1, !dbg !34
  store i32 %inc1, i32* %i, align 4, !dbg !34
  br label %for.cond, !dbg !35, !llvm.loop !36

for.end:                                          ; preds = %for.cond
  %3 = load i32, i32* %var, align 4, !dbg !38
  %cmp2 = icmp ne i32 %3, 10, !dbg !40
  br i1 %cmp2, label %if.then, label %if.end, !dbg !41

if.then:                                          ; preds = %for.end
  %4 = load i32, i32* %var, align 4, !dbg !42
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 %4), !dbg !43
  br label %if.end, !dbg !43

if.end:                                           ; preds = %if.then, %for.end
  ret i32 0, !dbg !44
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @printf(i8*, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/123")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"Ubuntu clang version 11.1.0-6"}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 20, type: !8, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10, !10, !11}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!13 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!14 = !DILocalVariable(name: "argc", arg: 1, scope: !7, file: !1, line: 20, type: !10)
!15 = !DILocation(line: 20, column: 14, scope: !7)
!16 = !DILocalVariable(name: "argv", arg: 2, scope: !7, file: !1, line: 20, type: !11)
!17 = !DILocation(line: 20, column: 26, scope: !7)
!18 = !DILocalVariable(name: "var", scope: !7, file: !1, line: 22, type: !10)
!19 = !DILocation(line: 22, column: 7, scope: !7)
!20 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 23, type: !10)
!21 = !DILocation(line: 23, column: 7, scope: !7)
!22 = !DILocation(line: 27, column: 12, scope: !23)
!23 = distinct !DILexicalBlock(scope: !24, file: !1, line: 27, column: 5)
!24 = distinct !DILexicalBlock(scope: !7, file: !1, line: 26, column: 3)
!25 = !DILocation(line: 27, column: 10, scope: !23)
!26 = !DILocation(line: 27, column: 17, scope: !27)
!27 = distinct !DILexicalBlock(scope: !23, file: !1, line: 27, column: 5)
!28 = !DILocation(line: 27, column: 19, scope: !27)
!29 = !DILocation(line: 27, column: 5, scope: !23)
!30 = !DILocation(line: 30, column: 12, scope: !31)
!31 = distinct !DILexicalBlock(scope: !32, file: !1, line: 29, column: 7)
!32 = distinct !DILexicalBlock(scope: !27, file: !1, line: 27, column: 30)
!33 = !DILocation(line: 32, column: 5, scope: !32)
!34 = !DILocation(line: 27, column: 26, scope: !27)
!35 = !DILocation(line: 27, column: 5, scope: !27)
!36 = distinct !{!36, !29, !37}
!37 = !DILocation(line: 32, column: 5, scope: !23)
!38 = !DILocation(line: 35, column: 7, scope: !39)
!39 = distinct !DILexicalBlock(scope: !7, file: !1, line: 35, column: 7)
!40 = !DILocation(line: 35, column: 10, scope: !39)
!41 = !DILocation(line: 35, column: 7, scope: !7)
!42 = !DILocation(line: 35, column: 30, scope: !39)
!43 = !DILocation(line: 35, column: 16, scope: !39)
!44 = !DILocation(line: 36, column: 3, scope: !7)
