; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [12 x i8] c"error = %d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !7 {
entry:
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %error = alloca i32, align 4
  %len = alloca i32, align 4
  %saved_stack = alloca i8*, align 8
  %__vla_expr0 = alloca i64, align 8
  %b = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !11, metadata !DIExpression()), !dbg !12
  call void @llvm.dbg.declare(metadata i32* %error, metadata !13, metadata !DIExpression()), !dbg !14
  call void @llvm.dbg.declare(metadata i32* %len, metadata !15, metadata !DIExpression()), !dbg !16
  store i32 1000, i32* %len, align 4, !dbg !16
  %0 = load i32, i32* %len, align 4, !dbg !17
  %1 = zext i32 %0 to i64, !dbg !18
  %2 = call i8* @llvm.stacksave(), !dbg !18
  store i8* %2, i8** %saved_stack, align 8, !dbg !18
  %vla = alloca i32, i64 %1, align 16, !dbg !18
  store i64 %1, i64* %__vla_expr0, align 8, !dbg !18
  call void @llvm.dbg.declare(metadata i64* %__vla_expr0, metadata !19, metadata !DIExpression()), !dbg !21
  call void @llvm.dbg.declare(metadata i32* %vla, metadata !22, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.declare(metadata i32* %b, metadata !27, metadata !DIExpression()), !dbg !28
  store i32 5, i32* %b, align 4, !dbg !28
  store i32 0, i32* %i, align 4, !dbg !29
  br label %for.cond, !dbg !31

for.cond:                                         ; preds = %for.inc, %entry
  %3 = load i32, i32* %i, align 4, !dbg !32
  %4 = load i32, i32* %len, align 4, !dbg !34
  %cmp = icmp slt i32 %3, %4, !dbg !35
  br i1 %cmp, label %for.body, label %for.end, !dbg !36

for.body:                                         ; preds = %for.cond
  %5 = load i32, i32* %i, align 4, !dbg !37
  %6 = load i32, i32* %i, align 4, !dbg !38
  %idxprom = sext i32 %6 to i64, !dbg !39
  %arrayidx = getelementptr inbounds i32, i32* %vla, i64 %idxprom, !dbg !39
  store i32 %5, i32* %arrayidx, align 4, !dbg !40
  br label %for.inc, !dbg !39

for.inc:                                          ; preds = %for.body
  %7 = load i32, i32* %i, align 4, !dbg !41
  %inc = add nsw i32 %7, 1, !dbg !41
  store i32 %inc, i32* %i, align 4, !dbg !41
  br label %for.cond, !dbg !42, !llvm.loop !43

for.end:                                          ; preds = %for.cond
  store i32 0, i32* %i, align 4, !dbg !45
  br label %for.cond1, !dbg !48

for.cond1:                                        ; preds = %for.inc8, %for.end
  %8 = load i32, i32* %i, align 4, !dbg !49
  %9 = load i32, i32* %len, align 4, !dbg !51
  %cmp2 = icmp slt i32 %8, %9, !dbg !52
  br i1 %cmp2, label %for.body3, label %for.end10, !dbg !53

for.body3:                                        ; preds = %for.cond1
  %10 = load i32, i32* %b, align 4, !dbg !54
  %11 = load i32, i32* %i, align 4, !dbg !55
  %idxprom4 = sext i32 %11 to i64, !dbg !56
  %arrayidx5 = getelementptr inbounds i32, i32* %vla, i64 %idxprom4, !dbg !56
  %12 = load i32, i32* %arrayidx5, align 4, !dbg !56
  %mul = mul nsw i32 %12, 5, !dbg !57
  %add = add nsw i32 %10, %mul, !dbg !58
  %13 = load i32, i32* %i, align 4, !dbg !59
  %idxprom6 = sext i32 %13 to i64, !dbg !60
  %arrayidx7 = getelementptr inbounds i32, i32* %vla, i64 %idxprom6, !dbg !60
  store i32 %add, i32* %arrayidx7, align 4, !dbg !61
  br label %for.inc8, !dbg !60

for.inc8:                                         ; preds = %for.body3
  %14 = load i32, i32* %i, align 4, !dbg !62
  %inc9 = add nsw i32 %14, 1, !dbg !62
  store i32 %inc9, i32* %i, align 4, !dbg !62
  br label %for.cond1, !dbg !63, !llvm.loop !64

for.end10:                                        ; preds = %for.cond1
  %arrayidx11 = getelementptr inbounds i32, i32* %vla, i64 9, !dbg !66
  %15 = load i32, i32* %arrayidx11, align 4, !dbg !66
  %add12 = add nsw i32 %15, 1, !dbg !67
  store i32 %add12, i32* %error, align 4, !dbg !68
  %16 = load i32, i32* %error, align 4, !dbg !69
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i64 0, i64 0), i32 %16), !dbg !70
  store i32 0, i32* %retval, align 4, !dbg !71
  %17 = load i8*, i8** %saved_stack, align 8, !dbg !72
  call void @llvm.stackrestore(i8* %17), !dbg !72
  %18 = load i32, i32* %retval, align 4, !dbg !72
  ret i32 %18, !dbg !72
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare i8* @llvm.stacksave() #2

declare dso_local i32 @printf(i8*, ...) #3

; Function Attrs: nounwind
declare void @llvm.stackrestore(i8*) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/013")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"Ubuntu clang version 11.1.0-6"}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 59, type: !8, scopeLine: 60, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 61, type: !10)
!12 = !DILocation(line: 61, column: 7, scope: !7)
!13 = !DILocalVariable(name: "error", scope: !7, file: !1, line: 61, type: !10)
!14 = !DILocation(line: 61, column: 9, scope: !7)
!15 = !DILocalVariable(name: "len", scope: !7, file: !1, line: 62, type: !10)
!16 = !DILocation(line: 62, column: 7, scope: !7)
!17 = !DILocation(line: 63, column: 9, scope: !7)
!18 = !DILocation(line: 63, column: 3, scope: !7)
!19 = !DILocalVariable(name: "__vla_expr0", scope: !7, type: !20, flags: DIFlagArtificial)
!20 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!21 = !DILocation(line: 0, scope: !7)
!22 = !DILocalVariable(name: "a", scope: !7, file: !1, line: 63, type: !23)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, elements: !24)
!24 = !{!25}
!25 = !DISubrange(count: !19)
!26 = !DILocation(line: 63, column: 7, scope: !7)
!27 = !DILocalVariable(name: "b", scope: !7, file: !1, line: 63, type: !10)
!28 = !DILocation(line: 63, column: 15, scope: !7)
!29 = !DILocation(line: 65, column: 9, scope: !30)
!30 = distinct !DILexicalBlock(scope: !7, file: !1, line: 65, column: 3)
!31 = !DILocation(line: 65, column: 8, scope: !30)
!32 = !DILocation(line: 65, column: 13, scope: !33)
!33 = distinct !DILexicalBlock(scope: !30, file: !1, line: 65, column: 3)
!34 = !DILocation(line: 65, column: 15, scope: !33)
!35 = !DILocation(line: 65, column: 14, scope: !33)
!36 = !DILocation(line: 65, column: 3, scope: !30)
!37 = !DILocation(line: 66, column: 11, scope: !33)
!38 = !DILocation(line: 66, column: 7, scope: !33)
!39 = !DILocation(line: 66, column: 5, scope: !33)
!40 = !DILocation(line: 66, column: 9, scope: !33)
!41 = !DILocation(line: 65, column: 21, scope: !33)
!42 = !DILocation(line: 65, column: 3, scope: !33)
!43 = distinct !{!43, !36, !44}
!44 = !DILocation(line: 66, column: 11, scope: !30)
!45 = !DILocation(line: 71, column: 11, scope: !46)
!46 = distinct !DILexicalBlock(scope: !47, file: !1, line: 71, column: 5)
!47 = distinct !DILexicalBlock(scope: !7, file: !1, line: 69, column: 3)
!48 = !DILocation(line: 71, column: 9, scope: !46)
!49 = !DILocation(line: 71, column: 16, scope: !50)
!50 = distinct !DILexicalBlock(scope: !46, file: !1, line: 71, column: 5)
!51 = !DILocation(line: 71, column: 20, scope: !50)
!52 = !DILocation(line: 71, column: 18, scope: !50)
!53 = !DILocation(line: 71, column: 5, scope: !46)
!54 = !DILocation(line: 72, column: 14, scope: !50)
!55 = !DILocation(line: 72, column: 20, scope: !50)
!56 = !DILocation(line: 72, column: 18, scope: !50)
!57 = !DILocation(line: 72, column: 22, scope: !50)
!58 = !DILocation(line: 72, column: 16, scope: !50)
!59 = !DILocation(line: 72, column: 9, scope: !50)
!60 = !DILocation(line: 72, column: 7, scope: !50)
!61 = !DILocation(line: 72, column: 12, scope: !50)
!62 = !DILocation(line: 71, column: 26, scope: !50)
!63 = !DILocation(line: 71, column: 5, scope: !50)
!64 = distinct !{!64, !53, !65}
!65 = !DILocation(line: 72, column: 23, scope: !46)
!66 = !DILocation(line: 75, column: 13, scope: !47)
!67 = !DILocation(line: 75, column: 18, scope: !47)
!68 = !DILocation(line: 75, column: 11, scope: !47)
!69 = !DILocation(line: 78, column: 27, scope: !7)
!70 = !DILocation(line: 78, column: 3, scope: !7)
!71 = !DILocation(line: 79, column: 3, scope: !7)
!72 = !DILocation(line: 80, column: 1, scope: !7)
