; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"n\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"m\00", align 1
@.str.3 = private unnamed_addr constant [12 x i8] c"saved_stack\00", align 1
@.str.4 = private unnamed_addr constant [12 x i8] c"__vla_expr0\00", align 1
@.str.5 = private unnamed_addr constant [12 x i8] c"__vla_expr1\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.7 = private unnamed_addr constant [2 x i8] c"j\00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c"b\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !9 {
entry:
  call void @__dp_func_entry(i32 16385, i32 1)
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %saved_stack = alloca i8*, align 8
  %__vla_expr0 = alloca i64, align 8
  %__vla_expr1 = alloca i64, align 8
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16385, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !13, metadata !DIExpression()), !dbg !14
  call void @llvm.dbg.declare(metadata i32* %j, metadata !15, metadata !DIExpression()), !dbg !16
  call void @llvm.dbg.declare(metadata i32* %n, metadata !17, metadata !DIExpression()), !dbg !18
  %1 = ptrtoint i32* %n to i64
  call void @__dp_write(i32 16388, i64 %1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  store i32 10, i32* %n, align 4, !dbg !18
  call void @llvm.dbg.declare(metadata i32* %m, metadata !19, metadata !DIExpression()), !dbg !20
  %2 = ptrtoint i32* %m to i64
  call void @__dp_write(i32 16388, i64 %2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  store i32 10, i32* %m, align 4, !dbg !20
  %3 = ptrtoint i32* %n to i64
  call void @__dp_read(i32 16389, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %4 = load i32, i32* %n, align 4, !dbg !21
  %5 = zext i32 %4 to i64, !dbg !22
  %6 = ptrtoint i32* %m to i64
  call void @__dp_read(i32 16389, i64 %6, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
  %7 = load i32, i32* %m, align 4, !dbg !23
  %8 = zext i32 %7 to i64, !dbg !22
  call void @__dp_call(i32 16389), !dbg !22
  %9 = call i8* @llvm.stacksave(), !dbg !22
  %10 = ptrtoint i8** %saved_stack to i64
  call void @__dp_write(i32 16389, i64 %10, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.3, i32 0, i32 0))
  store i8* %9, i8** %saved_stack, align 8, !dbg !22
  %11 = mul nuw i64 %5, %8, !dbg !22
  %vla = alloca double, i64 %11, align 16, !dbg !22
  %12 = ptrtoint i64* %__vla_expr0 to i64
  call void @__dp_write(i32 16389, i64 %12, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.4, i32 0, i32 0))
  store i64 %5, i64* %__vla_expr0, align 8, !dbg !22
  %13 = ptrtoint i64* %__vla_expr1 to i64
  call void @__dp_write(i32 16389, i64 %13, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.5, i32 0, i32 0))
  store i64 %8, i64* %__vla_expr1, align 8, !dbg !22
  call void @llvm.dbg.declare(metadata i64* %__vla_expr0, metadata !24, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.declare(metadata i64* %__vla_expr1, metadata !27, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.declare(metadata double* %vla, metadata !28, metadata !DIExpression()), !dbg !33
  %14 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16391, i64 %14, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !34
  br label %for.cond, !dbg !36

for.cond:                                         ; preds = %for.inc6, %entry
  call void @__dp_loop_entry(i32 16391, i32 0)
  %15 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16391, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %16 = load i32, i32* %i, align 4, !dbg !37
  %17 = ptrtoint i32* %n to i64
  call void @__dp_read(i32 16391, i64 %17, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %18 = load i32, i32* %n, align 4, !dbg !39
  %cmp = icmp slt i32 %16, %18, !dbg !40
  br i1 %cmp, label %for.body, label %for.end8, !dbg !41

for.body:                                         ; preds = %for.cond
  %19 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16392, i64 %19, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 0, i32* %j, align 4, !dbg !42
  br label %for.cond1, !dbg !44

for.cond1:                                        ; preds = %for.inc, %for.body
  call void @__dp_loop_entry(i32 16392, i32 1)
  %20 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16392, i64 %20, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %21 = load i32, i32* %j, align 4, !dbg !45
  %22 = ptrtoint i32* %n to i64
  call void @__dp_read(i32 16392, i64 %22, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
  %23 = load i32, i32* %n, align 4, !dbg !47
  %cmp2 = icmp slt i32 %21, %23, !dbg !48
  br i1 %cmp2, label %for.body3, label %for.end, !dbg !49

for.body3:                                        ; preds = %for.cond1
  %24 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16393, i64 %24, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %25 = load i32, i32* %i, align 4, !dbg !50
  %26 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16393, i64 %26, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %27 = load i32, i32* %j, align 4, !dbg !51
  %mul = mul nsw i32 %25, %27, !dbg !52
  %conv = sitofp i32 %mul to double, !dbg !53
  %28 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16393, i64 %28, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %29 = load i32, i32* %i, align 4, !dbg !54
  %idxprom = sext i32 %29 to i64, !dbg !55
  %30 = mul nsw i64 %idxprom, %8, !dbg !55
  %arrayidx = getelementptr inbounds double, double* %vla, i64 %30, !dbg !55
  %31 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16393, i64 %31, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %32 = load i32, i32* %j, align 4, !dbg !56
  %idxprom4 = sext i32 %32 to i64, !dbg !55
  %arrayidx5 = getelementptr inbounds double, double* %arrayidx, i64 %idxprom4, !dbg !55
  %33 = ptrtoint double* %arrayidx5 to i64
  call void @__dp_write(i32 16393, i64 %33, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  store double %conv, double* %arrayidx5, align 8, !dbg !57
  br label %for.inc, !dbg !55

for.inc:                                          ; preds = %for.body3
  %34 = ptrtoint i32* %j to i64
  call void @__dp_read(i32 16392, i64 %34, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %35 = load i32, i32* %j, align 4, !dbg !58
  %inc = add nsw i32 %35, 1, !dbg !58
  %36 = ptrtoint i32* %j to i64
  call void @__dp_write(i32 16392, i64 %36, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 %inc, i32* %j, align 4, !dbg !58
  br label %for.cond1, !dbg !59, !llvm.loop !60

for.end:                                          ; preds = %for.cond1
  call void @__dp_loop_exit(i32 16393, i32 1)
  br label %for.inc6, !dbg !61

for.inc6:                                         ; preds = %for.end
  %37 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16391, i64 %37, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  %38 = load i32, i32* %i, align 4, !dbg !62
  %inc7 = add nsw i32 %38, 1, !dbg !62
  %39 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16391, i64 %39, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0))
  store i32 %inc7, i32* %i, align 4, !dbg !62
  br label %for.cond, !dbg !63, !llvm.loop !64

for.end8:                                         ; preds = %for.cond
  call void @__dp_loop_exit(i32 16405, i32 0)
  %40 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16405, i64 %40, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  store i32 0, i32* %retval, align 4, !dbg !66
  %41 = ptrtoint i8** %saved_stack to i64
  call void @__dp_read(i32 16406, i64 %41, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.3, i32 0, i32 0))
  %42 = load i8*, i8** %saved_stack, align 8, !dbg !67
  call void @__dp_call(i32 16406), !dbg !67
  call void @llvm.stackrestore(i8* %42), !dbg !67
  %43 = ptrtoint i32* %retval to i64
  call void @__dp_read(i32 16406, i64 %43, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  %44 = load i32, i32* %retval, align 4, !dbg !67
  call void @__dp_finalize(i32 16406), !dbg !67
  ret i32 %44, !dbg !67
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_call(i32)

; Function Attrs: nounwind
declare i8* @llvm.stacksave() #2

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_loop_exit(i32, i32)

; Function Attrs: nounwind
declare void @llvm.stackrestore(i8*) #2

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!5}
!llvm.module.flags = !{!6, !7, !8}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/1337")
!2 = !{}
!3 = !{!4}
!4 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!5 = !{!"Ubuntu clang version 11.1.0-6"}
!6 = !{i32 7, !"Dwarf Version", i32 4}
!7 = !{i32 2, !"Debug Info Version", i32 3}
!8 = !{i32 1, !"wchar_size", i32 4}
!9 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 1, type: !10, scopeLine: 2, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!10 = !DISubroutineType(types: !11)
!11 = !{!12}
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !DILocalVariable(name: "i", scope: !9, file: !1, line: 3, type: !12)
!14 = !DILocation(line: 3, column: 7, scope: !9)
!15 = !DILocalVariable(name: "j", scope: !9, file: !1, line: 3, type: !12)
!16 = !DILocation(line: 3, column: 9, scope: !9)
!17 = !DILocalVariable(name: "n", scope: !9, file: !1, line: 4, type: !12)
!18 = !DILocation(line: 4, column: 7, scope: !9)
!19 = !DILocalVariable(name: "m", scope: !9, file: !1, line: 4, type: !12)
!20 = !DILocation(line: 4, column: 13, scope: !9)
!21 = !DILocation(line: 5, column: 12, scope: !9)
!22 = !DILocation(line: 5, column: 3, scope: !9)
!23 = !DILocation(line: 5, column: 15, scope: !9)
!24 = !DILocalVariable(name: "__vla_expr0", scope: !9, type: !25, flags: DIFlagArtificial)
!25 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!26 = !DILocation(line: 0, scope: !9)
!27 = !DILocalVariable(name: "__vla_expr1", scope: !9, type: !25, flags: DIFlagArtificial)
!28 = !DILocalVariable(name: "b", scope: !9, file: !1, line: 5, type: !29)
!29 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, elements: !30)
!30 = !{!31, !32}
!31 = !DISubrange(count: !24)
!32 = !DISubrange(count: !27)
!33 = !DILocation(line: 5, column: 10, scope: !9)
!34 = !DILocation(line: 7, column: 8, scope: !35)
!35 = distinct !DILexicalBlock(scope: !9, file: !1, line: 7, column: 3)
!36 = !DILocation(line: 7, column: 7, scope: !35)
!37 = !DILocation(line: 7, column: 11, scope: !38)
!38 = distinct !DILexicalBlock(scope: !35, file: !1, line: 7, column: 3)
!39 = !DILocation(line: 7, column: 13, scope: !38)
!40 = !DILocation(line: 7, column: 12, scope: !38)
!41 = !DILocation(line: 7, column: 3, scope: !35)
!42 = !DILocation(line: 8, column: 10, scope: !43)
!43 = distinct !DILexicalBlock(scope: !38, file: !1, line: 8, column: 5)
!44 = !DILocation(line: 8, column: 9, scope: !43)
!45 = !DILocation(line: 8, column: 13, scope: !46)
!46 = distinct !DILexicalBlock(scope: !43, file: !1, line: 8, column: 5)
!47 = !DILocation(line: 8, column: 15, scope: !46)
!48 = !DILocation(line: 8, column: 14, scope: !46)
!49 = !DILocation(line: 8, column: 5, scope: !43)
!50 = !DILocation(line: 9, column: 24, scope: !46)
!51 = !DILocation(line: 9, column: 26, scope: !46)
!52 = !DILocation(line: 9, column: 25, scope: !46)
!53 = !DILocation(line: 9, column: 15, scope: !46)
!54 = !DILocation(line: 9, column: 9, scope: !46)
!55 = !DILocation(line: 9, column: 7, scope: !46)
!56 = !DILocation(line: 9, column: 12, scope: !46)
!57 = !DILocation(line: 9, column: 14, scope: !46)
!58 = !DILocation(line: 8, column: 19, scope: !46)
!59 = !DILocation(line: 8, column: 5, scope: !46)
!60 = distinct !{!60, !49, !61}
!61 = !DILocation(line: 9, column: 27, scope: !43)
!62 = !DILocation(line: 7, column: 17, scope: !38)
!63 = !DILocation(line: 7, column: 3, scope: !38)
!64 = distinct !{!64, !41, !65}
!65 = !DILocation(line: 9, column: 27, scope: !35)
!66 = !DILocation(line: 21, column: 3, scope: !9)
!67 = !DILocation(line: 22, column: 1, scope: !9)
