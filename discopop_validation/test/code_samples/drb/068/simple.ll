; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, %struct._IO_codecvt*, %struct._IO_wide_data*, %struct._IO_FILE*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type opaque
%struct._IO_codecvt = type opaque
%struct._IO_wide_data = type opaque

@stderr = external dso_local global %struct._IO_FILE*, align 8
@.str = private unnamed_addr constant [44 x i8] c"skip the execution due to malloc failures.\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo(i32 %n, i32* noalias %a, i32* noalias %b, i32* noalias %c) #0 !dbg !10 {
entry:
  %n.addr = alloca i32, align 4
  %a.addr = alloca i32*, align 8
  %b.addr = alloca i32*, align 8
  %c.addr = alloca i32*, align 8
  %i = alloca i32, align 4
  store i32 %n, i32* %n.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %n.addr, metadata !14, metadata !DIExpression()), !dbg !15
  store i32* %a, i32** %a.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %a.addr, metadata !16, metadata !DIExpression()), !dbg !17
  store i32* %b, i32** %b.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %b.addr, metadata !18, metadata !DIExpression()), !dbg !19
  store i32* %c, i32** %c.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %c.addr, metadata !20, metadata !DIExpression()), !dbg !21
  call void @llvm.dbg.declare(metadata i32* %i, metadata !22, metadata !DIExpression()), !dbg !23
  store i32 0, i32* %i, align 4, !dbg !24
  br label %for.cond, !dbg !26

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !27
  %1 = load i32, i32* %n.addr, align 4, !dbg !29
  %cmp = icmp slt i32 %0, %1, !dbg !30
  br i1 %cmp, label %for.body, label %for.end, !dbg !31

for.body:                                         ; preds = %for.cond
  %2 = load i32*, i32** %b.addr, align 8, !dbg !32
  %3 = load i32, i32* %i, align 4, !dbg !33
  %idxprom = sext i32 %3 to i64, !dbg !32
  %arrayidx = getelementptr inbounds i32, i32* %2, i64 %idxprom, !dbg !32
  %4 = load i32, i32* %arrayidx, align 4, !dbg !32
  %5 = load i32*, i32** %c.addr, align 8, !dbg !34
  %6 = load i32, i32* %i, align 4, !dbg !35
  %idxprom1 = sext i32 %6 to i64, !dbg !34
  %arrayidx2 = getelementptr inbounds i32, i32* %5, i64 %idxprom1, !dbg !34
  %7 = load i32, i32* %arrayidx2, align 4, !dbg !34
  %add = add nsw i32 %4, %7, !dbg !36
  %8 = load i32*, i32** %a.addr, align 8, !dbg !37
  %9 = load i32, i32* %i, align 4, !dbg !38
  %idxprom3 = sext i32 %9 to i64, !dbg !37
  %arrayidx4 = getelementptr inbounds i32, i32* %8, i64 %idxprom3, !dbg !37
  store i32 %add, i32* %arrayidx4, align 4, !dbg !39
  br label %for.inc, !dbg !37

for.inc:                                          ; preds = %for.body
  %10 = load i32, i32* %i, align 4, !dbg !40
  %inc = add nsw i32 %10, 1, !dbg !40
  store i32 %inc, i32* %i, align 4, !dbg !40
  br label %for.cond, !dbg !41, !llvm.loop !42

for.end:                                          ; preds = %for.cond
  ret void, !dbg !44
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !45 {
entry:
  %retval = alloca i32, align 4
  %n = alloca i32, align 4
  %a = alloca i32*, align 8
  %b = alloca i32*, align 8
  %c = alloca i32*, align 8
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %n, metadata !48, metadata !DIExpression()), !dbg !49
  store i32 1000, i32* %n, align 4, !dbg !49
  call void @llvm.dbg.declare(metadata i32** %a, metadata !50, metadata !DIExpression()), !dbg !51
  call void @llvm.dbg.declare(metadata i32** %b, metadata !52, metadata !DIExpression()), !dbg !53
  call void @llvm.dbg.declare(metadata i32** %c, metadata !54, metadata !DIExpression()), !dbg !55
  %0 = load i32, i32* %n, align 4, !dbg !56
  %conv = sext i32 %0 to i64, !dbg !56
  %mul = mul i64 %conv, 4, !dbg !57
  %call = call noalias i8* @malloc(i64 %mul) #4, !dbg !58
  %1 = bitcast i8* %call to i32*, !dbg !59
  store i32* %1, i32** %a, align 8, !dbg !60
  %2 = load i32*, i32** %a, align 8, !dbg !61
  %cmp = icmp eq i32* %2, null, !dbg !63
  br i1 %cmp, label %if.then, label %if.end, !dbg !64

if.then:                                          ; preds = %entry
  %3 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !65
  %call2 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([44 x i8], [44 x i8]* @.str, i64 0, i64 0)), !dbg !67
  store i32 1, i32* %retval, align 4, !dbg !68
  br label %return, !dbg !68

if.end:                                           ; preds = %entry
  %4 = load i32, i32* %n, align 4, !dbg !69
  %conv3 = sext i32 %4 to i64, !dbg !69
  %mul4 = mul i64 %conv3, 4, !dbg !70
  %call5 = call noalias i8* @malloc(i64 %mul4) #4, !dbg !71
  %5 = bitcast i8* %call5 to i32*, !dbg !72
  store i32* %5, i32** %b, align 8, !dbg !73
  %6 = load i32*, i32** %b, align 8, !dbg !74
  %cmp6 = icmp eq i32* %6, null, !dbg !76
  br i1 %cmp6, label %if.then8, label %if.end10, !dbg !77

if.then8:                                         ; preds = %if.end
  %7 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !78
  %call9 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %7, i8* getelementptr inbounds ([44 x i8], [44 x i8]* @.str, i64 0, i64 0)), !dbg !80
  store i32 1, i32* %retval, align 4, !dbg !81
  br label %return, !dbg !81

if.end10:                                         ; preds = %if.end
  %8 = load i32, i32* %n, align 4, !dbg !82
  %conv11 = sext i32 %8 to i64, !dbg !82
  %mul12 = mul i64 %conv11, 4, !dbg !83
  %call13 = call noalias i8* @malloc(i64 %mul12) #4, !dbg !84
  %9 = bitcast i8* %call13 to i32*, !dbg !85
  store i32* %9, i32** %c, align 8, !dbg !86
  %10 = load i32*, i32** %c, align 8, !dbg !87
  %cmp14 = icmp eq i32* %10, null, !dbg !89
  br i1 %cmp14, label %if.then16, label %if.end18, !dbg !90

if.then16:                                        ; preds = %if.end10
  %11 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !91
  %call17 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %11, i8* getelementptr inbounds ([44 x i8], [44 x i8]* @.str, i64 0, i64 0)), !dbg !93
  store i32 1, i32* %retval, align 4, !dbg !94
  br label %return, !dbg !94

if.end18:                                         ; preds = %if.end10
  %12 = load i32, i32* %n, align 4, !dbg !95
  %13 = load i32*, i32** %a, align 8, !dbg !96
  %14 = load i32*, i32** %b, align 8, !dbg !97
  %15 = load i32*, i32** %c, align 8, !dbg !98
  call void @foo(i32 %12, i32* %13, i32* %14, i32* %15), !dbg !99
  %16 = load i32*, i32** %a, align 8, !dbg !100
  %17 = bitcast i32* %16 to i8*, !dbg !100
  call void @free(i8* %17) #4, !dbg !101
  %18 = load i32*, i32** %b, align 8, !dbg !102
  %19 = bitcast i32* %18 to i8*, !dbg !102
  call void @free(i8* %19) #4, !dbg !103
  %20 = load i32*, i32** %c, align 8, !dbg !104
  %21 = bitcast i32* %20 to i8*, !dbg !104
  call void @free(i8* %21) #4, !dbg !105
  store i32 0, i32* %retval, align 4, !dbg !106
  br label %return, !dbg !106

return:                                           ; preds = %if.end18, %if.then16, %if.then8, %if.then
  %22 = load i32, i32* %retval, align 4, !dbg !107
  ret i32 %22, !dbg !107
}

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64) #2

declare dso_local i32 @fprintf(%struct._IO_FILE*, i8*, ...) #3

; Function Attrs: nounwind
declare dso_local void @free(i8*) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!6, !7, !8}
!llvm.ident = !{!9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/068")
!2 = !{}
!3 = !{!4}
!4 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!5 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!6 = !{i32 7, !"Dwarf Version", i32 4}
!7 = !{i32 2, !"Debug Info Version", i32 3}
!8 = !{i32 1, !"wchar_size", i32 4}
!9 = !{!"Ubuntu clang version 11.1.0-6"}
!10 = distinct !DISubprogram(name: "foo", scope: !1, file: !1, line: 58, type: !11, scopeLine: 59, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!11 = !DISubroutineType(types: !12)
!12 = !{null, !5, !13, !13, !13}
!13 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !4)
!14 = !DILocalVariable(name: "n", arg: 1, scope: !10, file: !1, line: 58, type: !5)
!15 = !DILocation(line: 58, column: 14, scope: !10)
!16 = !DILocalVariable(name: "a", arg: 2, scope: !10, file: !1, line: 58, type: !13)
!17 = !DILocation(line: 58, column: 33, scope: !10)
!18 = !DILocalVariable(name: "b", arg: 3, scope: !10, file: !1, line: 58, type: !13)
!19 = !DILocation(line: 58, column: 51, scope: !10)
!20 = !DILocalVariable(name: "c", arg: 4, scope: !10, file: !1, line: 58, type: !13)
!21 = !DILocation(line: 58, column: 70, scope: !10)
!22 = !DILocalVariable(name: "i", scope: !10, file: !1, line: 60, type: !5)
!23 = !DILocation(line: 60, column: 7, scope: !10)
!24 = !DILocation(line: 62, column: 10, scope: !25)
!25 = distinct !DILexicalBlock(scope: !10, file: !1, line: 62, column: 3)
!26 = !DILocation(line: 62, column: 8, scope: !25)
!27 = !DILocation(line: 62, column: 15, scope: !28)
!28 = distinct !DILexicalBlock(scope: !25, file: !1, line: 62, column: 3)
!29 = !DILocation(line: 62, column: 19, scope: !28)
!30 = !DILocation(line: 62, column: 17, scope: !28)
!31 = !DILocation(line: 62, column: 3, scope: !25)
!32 = !DILocation(line: 63, column: 12, scope: !28)
!33 = !DILocation(line: 63, column: 14, scope: !28)
!34 = !DILocation(line: 63, column: 19, scope: !28)
!35 = !DILocation(line: 63, column: 21, scope: !28)
!36 = !DILocation(line: 63, column: 17, scope: !28)
!37 = !DILocation(line: 63, column: 5, scope: !28)
!38 = !DILocation(line: 63, column: 7, scope: !28)
!39 = !DILocation(line: 63, column: 10, scope: !28)
!40 = !DILocation(line: 62, column: 23, scope: !28)
!41 = !DILocation(line: 62, column: 3, scope: !28)
!42 = distinct !{!42, !31, !43}
!43 = !DILocation(line: 63, column: 22, scope: !25)
!44 = !DILocation(line: 64, column: 1, scope: !10)
!45 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 66, type: !46, scopeLine: 67, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!46 = !DISubroutineType(types: !47)
!47 = !{!5}
!48 = !DILocalVariable(name: "n", scope: !45, file: !1, line: 68, type: !5)
!49 = !DILocation(line: 68, column: 7, scope: !45)
!50 = !DILocalVariable(name: "a", scope: !45, file: !1, line: 69, type: !4)
!51 = !DILocation(line: 69, column: 9, scope: !45)
!52 = !DILocalVariable(name: "b", scope: !45, file: !1, line: 69, type: !4)
!53 = !DILocation(line: 69, column: 14, scope: !45)
!54 = !DILocalVariable(name: "c", scope: !45, file: !1, line: 69, type: !4)
!55 = !DILocation(line: 69, column: 18, scope: !45)
!56 = !DILocation(line: 71, column: 22, scope: !45)
!57 = !DILocation(line: 71, column: 23, scope: !45)
!58 = !DILocation(line: 71, column: 14, scope: !45)
!59 = !DILocation(line: 71, column: 7, scope: !45)
!60 = !DILocation(line: 71, column: 5, scope: !45)
!61 = !DILocation(line: 72, column: 7, scope: !62)
!62 = distinct !DILexicalBlock(scope: !45, file: !1, line: 72, column: 7)
!63 = !DILocation(line: 72, column: 9, scope: !62)
!64 = !DILocation(line: 72, column: 7, scope: !45)
!65 = !DILocation(line: 74, column: 14, scope: !66)
!66 = distinct !DILexicalBlock(scope: !62, file: !1, line: 73, column: 3)
!67 = !DILocation(line: 74, column: 5, scope: !66)
!68 = !DILocation(line: 75, column: 5, scope: !66)
!69 = !DILocation(line: 78, column: 22, scope: !45)
!70 = !DILocation(line: 78, column: 23, scope: !45)
!71 = !DILocation(line: 78, column: 14, scope: !45)
!72 = !DILocation(line: 78, column: 7, scope: !45)
!73 = !DILocation(line: 78, column: 5, scope: !45)
!74 = !DILocation(line: 79, column: 7, scope: !75)
!75 = distinct !DILexicalBlock(scope: !45, file: !1, line: 79, column: 7)
!76 = !DILocation(line: 79, column: 9, scope: !75)
!77 = !DILocation(line: 79, column: 7, scope: !45)
!78 = !DILocation(line: 81, column: 14, scope: !79)
!79 = distinct !DILexicalBlock(scope: !75, file: !1, line: 80, column: 3)
!80 = !DILocation(line: 81, column: 5, scope: !79)
!81 = !DILocation(line: 82, column: 5, scope: !79)
!82 = !DILocation(line: 85, column: 22, scope: !45)
!83 = !DILocation(line: 85, column: 23, scope: !45)
!84 = !DILocation(line: 85, column: 14, scope: !45)
!85 = !DILocation(line: 85, column: 7, scope: !45)
!86 = !DILocation(line: 85, column: 5, scope: !45)
!87 = !DILocation(line: 86, column: 7, scope: !88)
!88 = distinct !DILexicalBlock(scope: !45, file: !1, line: 86, column: 7)
!89 = !DILocation(line: 86, column: 9, scope: !88)
!90 = !DILocation(line: 86, column: 7, scope: !45)
!91 = !DILocation(line: 88, column: 14, scope: !92)
!92 = distinct !DILexicalBlock(scope: !88, file: !1, line: 87, column: 3)
!93 = !DILocation(line: 88, column: 5, scope: !92)
!94 = !DILocation(line: 89, column: 5, scope: !92)
!95 = !DILocation(line: 92, column: 8, scope: !45)
!96 = !DILocation(line: 92, column: 11, scope: !45)
!97 = !DILocation(line: 92, column: 14, scope: !45)
!98 = !DILocation(line: 92, column: 16, scope: !45)
!99 = !DILocation(line: 92, column: 3, scope: !45)
!100 = !DILocation(line: 94, column: 9, scope: !45)
!101 = !DILocation(line: 94, column: 3, scope: !45)
!102 = !DILocation(line: 95, column: 9, scope: !45)
!103 = !DILocation(line: 95, column: 3, scope: !45)
!104 = !DILocation(line: 96, column: 9, scope: !45)
!105 = !DILocation(line: 96, column: 3, scope: !45)
!106 = !DILocation(line: 97, column: 3, scope: !45)
!107 = !DILocation(line: 98, column: 1, scope: !45)
