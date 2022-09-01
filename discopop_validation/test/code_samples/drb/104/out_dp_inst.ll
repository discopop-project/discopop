; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.3 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"len\00", align 1
@.str.5 = private unnamed_addr constant [12 x i8] c"saved_stack\00", align 1
@.str.6 = private unnamed_addr constant [12 x i8] c"__vla_expr0\00", align 1
@.str.7 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.9 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.10 = private unnamed_addr constant [6 x i8] c"error\00", align 1
@.str = private unnamed_addr constant [12 x i8] c"error == 51\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"simple.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1
@.str.2 = private unnamed_addr constant [12 x i8] c"error = %d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !7 {
entry:
  call void @__dp_func_entry(i32 16439, i32 1)
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %error = alloca i32, align 4
  %len = alloca i32, align 4
  %saved_stack = alloca i8*, align 8
  %__vla_expr0 = alloca i64, align 8
  %b = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16439, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !11, metadata !DIExpression()), !dbg !12
  call void @llvm.dbg.declare(metadata i32* %error, metadata !13, metadata !DIExpression()), !dbg !14
  call void @llvm.dbg.declare(metadata i32* %len, metadata !15, metadata !DIExpression()), !dbg !16
  %1 = ptrtoint i32* %len to i64
  call void @__dp_write(i32 16442, i64 %1, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  store i32 1000, i32* %len, align 4, !dbg !16
  %2 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16443, i64 %2, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  %3 = load i32, i32* %len, align 4, !dbg !17
  %4 = zext i32 %3 to i64, !dbg !18
  call void @__dp_call(i32 16443), !dbg !18
  %5 = call i8* @llvm.stacksave(), !dbg !18
  %6 = ptrtoint i8** %saved_stack to i64
  call void @__dp_write(i32 16443, i64 %6, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.5, i32 0, i32 0))
  store i8* %5, i8** %saved_stack, align 8, !dbg !18
  %vla = alloca i32, i64 %4, align 16, !dbg !18
  %7 = ptrtoint i64* %__vla_expr0 to i64
  call void @__dp_write(i32 16443, i64 %7, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.6, i32 0, i32 0))
  store i64 %4, i64* %__vla_expr0, align 8, !dbg !18
  call void @llvm.dbg.declare(metadata i64* %__vla_expr0, metadata !19, metadata !DIExpression()), !dbg !21
  call void @llvm.dbg.declare(metadata i32* %vla, metadata !22, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.declare(metadata i32* %b, metadata !27, metadata !DIExpression()), !dbg !28
  %8 = ptrtoint i32* %b to i64
  call void @__dp_write(i32 16443, i64 %8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  store i32 5, i32* %b, align 4, !dbg !28
  %9 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16445, i64 %9, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !29
  br label %for.cond, !dbg !31

for.cond:                                         ; preds = %for.inc, %entry
  call void @__dp_loop_entry(i32 16445, i32 0)
  %10 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16445, i64 %10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %11 = load i32, i32* %i, align 4, !dbg !32
  %12 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16445, i64 %12, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  %13 = load i32, i32* %len, align 4, !dbg !34
  %cmp = icmp slt i32 %11, %13, !dbg !35
  br i1 %cmp, label %for.body, label %for.end, !dbg !36

for.body:                                         ; preds = %for.cond
  %14 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16446, i64 %14, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %15 = load i32, i32* %i, align 4, !dbg !37
  %16 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16446, i64 %16, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %17 = load i32, i32* %i, align 4, !dbg !38
  %idxprom = sext i32 %17 to i64, !dbg !39
  %arrayidx = getelementptr inbounds i32, i32* %vla, i64 %idxprom, !dbg !39
  %18 = ptrtoint i32* %arrayidx to i64
  call void @__dp_write(i32 16446, i64 %18, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  store i32 %15, i32* %arrayidx, align 4, !dbg !40
  br label %for.inc, !dbg !39

for.inc:                                          ; preds = %for.body
  %19 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16445, i64 %19, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %20 = load i32, i32* %i, align 4, !dbg !41
  %inc = add nsw i32 %20, 1, !dbg !41
  %21 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16445, i64 %21, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !41
  br label %for.cond, !dbg !42, !llvm.loop !43

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16451, i32 0)
  %22 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16451, i64 %22, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !45
  br label %for.cond1, !dbg !48

for.cond1:                                        ; preds = %for.inc8, %for.end
  call void @__dp_loop_entry(i32 16451, i32 1)
  %23 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16451, i64 %23, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %24 = load i32, i32* %i, align 4, !dbg !49
  %25 = ptrtoint i32* %len to i64
  call void @__dp_read(i32 16451, i64 %25, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0))
  %26 = load i32, i32* %len, align 4, !dbg !51
  %cmp2 = icmp slt i32 %24, %26, !dbg !52
  br i1 %cmp2, label %for.body3, label %for.end10, !dbg !53

for.body3:                                        ; preds = %for.cond1
  %27 = ptrtoint i32* %b to i64
  call void @__dp_read(i32 16452, i64 %27, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
  %28 = load i32, i32* %b, align 4, !dbg !54
  %29 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16452, i64 %29, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %30 = load i32, i32* %i, align 4, !dbg !55
  %idxprom4 = sext i32 %30 to i64, !dbg !56
  %arrayidx5 = getelementptr inbounds i32, i32* %vla, i64 %idxprom4, !dbg !56
  %31 = ptrtoint i32* %arrayidx5 to i64
  call void @__dp_read(i32 16452, i64 %31, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  %32 = load i32, i32* %arrayidx5, align 4, !dbg !56
  %mul = mul nsw i32 %32, 5, !dbg !57
  %add = add nsw i32 %28, %mul, !dbg !58
  %33 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16452, i64 %33, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %34 = load i32, i32* %i, align 4, !dbg !59
  %idxprom6 = sext i32 %34 to i64, !dbg !60
  %arrayidx7 = getelementptr inbounds i32, i32* %vla, i64 %idxprom6, !dbg !60
  %35 = ptrtoint i32* %arrayidx7 to i64
  call void @__dp_write(i32 16452, i64 %35, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  store i32 %add, i32* %arrayidx7, align 4, !dbg !61
  br label %for.inc8, !dbg !60

for.inc8:                                         ; preds = %for.body3
  %36 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16451, i64 %36, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %37 = load i32, i32* %i, align 4, !dbg !62
  %inc9 = add nsw i32 %37, 1, !dbg !62
  %38 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16451, i64 %38, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  store i32 %inc9, i32* %i, align 4, !dbg !62
  br label %for.cond1, !dbg !63, !llvm.loop !64

for.end10:                                        ; preds = %for.cond1
  call void @__dp_loop_exit(i32 16457, i32 1)
  %arrayidx11 = getelementptr inbounds i32, i32* %vla, i64 9, !dbg !66
  %39 = ptrtoint i32* %arrayidx11 to i64
  call void @__dp_read(i32 16457, i64 %39, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.9, i32 0, i32 0))
  %40 = load i32, i32* %arrayidx11, align 4, !dbg !66
  %add12 = add nsw i32 %40, 1, !dbg !67
  %41 = ptrtoint i32* %error to i64
  call void @__dp_write(i32 16457, i64 %41, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.10, i32 0, i32 0))
  store i32 %add12, i32* %error, align 4, !dbg !68
  %42 = ptrtoint i32* %error to i64
  call void @__dp_read(i32 16459, i64 %42, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.10, i32 0, i32 0))
  %43 = load i32, i32* %error, align 4, !dbg !69
  %cmp13 = icmp eq i32 %43, 51, !dbg !69
  br i1 %cmp13, label %if.then, label %if.else, !dbg !72

if.then:                                          ; preds = %for.end10
  br label %if.end, !dbg !72

if.else:                                          ; preds = %for.end10
  call void @__dp_finalize(i32 16459), !dbg !69
  call void @__assert_fail(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i64 0, i64 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i64 0, i64 0), i32 75, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !69
  unreachable, !dbg !69

if.end:                                           ; preds = %if.then
  %44 = ptrtoint i32* %error to i64
  call void @__dp_read(i32 16460, i64 %44, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.10, i32 0, i32 0))
  %45 = load i32, i32* %error, align 4, !dbg !73
  call void @__dp_call(i32 16460), !dbg !74
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.2, i64 0, i64 0), i32 %45), !dbg !74
  %46 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16461, i64 %46, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0))
  store i32 0, i32* %retval, align 4, !dbg !75
  %47 = ptrtoint i8** %saved_stack to i64
  call void @__dp_read(i32 16462, i64 %47, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.5, i32 0, i32 0))
  %48 = load i8*, i8** %saved_stack, align 8, !dbg !76
  call void @__dp_call(i32 16462), !dbg !76
  call void @llvm.stackrestore(i8* %48), !dbg !76
  %49 = ptrtoint i32* %retval to i64
  call void @__dp_read(i32 16462, i64 %49, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0))
  %50 = load i32, i32* %retval, align 4, !dbg !76
  call void @__dp_finalize(i32 16462), !dbg !76
  ret i32 %50, !dbg !76
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

declare void @__dp_finalize(i32)

; Function Attrs: noreturn nounwind
declare dso_local void @__assert_fail(i8*, i8*, i32, i8*) #3

declare dso_local i32 @printf(i8*, ...) #4

; Function Attrs: nounwind
declare void @llvm.stackrestore(i8*) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind }
attributes #3 = { noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { noreturn nounwind }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!3}
!llvm.module.flags = !{!4, !5, !6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/104")
!2 = !{}
!3 = !{!"Ubuntu clang version 11.1.0-6"}
!4 = !{i32 7, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 55, type: !8, scopeLine: 56, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "i", scope: !7, file: !1, line: 57, type: !10)
!12 = !DILocation(line: 57, column: 7, scope: !7)
!13 = !DILocalVariable(name: "error", scope: !7, file: !1, line: 57, type: !10)
!14 = !DILocation(line: 57, column: 9, scope: !7)
!15 = !DILocalVariable(name: "len", scope: !7, file: !1, line: 58, type: !10)
!16 = !DILocation(line: 58, column: 7, scope: !7)
!17 = !DILocation(line: 59, column: 9, scope: !7)
!18 = !DILocation(line: 59, column: 3, scope: !7)
!19 = !DILocalVariable(name: "__vla_expr0", scope: !7, type: !20, flags: DIFlagArtificial)
!20 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!21 = !DILocation(line: 0, scope: !7)
!22 = !DILocalVariable(name: "a", scope: !7, file: !1, line: 59, type: !23)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, elements: !24)
!24 = !{!25}
!25 = !DISubrange(count: !19)
!26 = !DILocation(line: 59, column: 7, scope: !7)
!27 = !DILocalVariable(name: "b", scope: !7, file: !1, line: 59, type: !10)
!28 = !DILocation(line: 59, column: 15, scope: !7)
!29 = !DILocation(line: 61, column: 9, scope: !30)
!30 = distinct !DILexicalBlock(scope: !7, file: !1, line: 61, column: 3)
!31 = !DILocation(line: 61, column: 8, scope: !30)
!32 = !DILocation(line: 61, column: 13, scope: !33)
!33 = distinct !DILexicalBlock(scope: !30, file: !1, line: 61, column: 3)
!34 = !DILocation(line: 61, column: 15, scope: !33)
!35 = !DILocation(line: 61, column: 14, scope: !33)
!36 = !DILocation(line: 61, column: 3, scope: !30)
!37 = !DILocation(line: 62, column: 11, scope: !33)
!38 = !DILocation(line: 62, column: 7, scope: !33)
!39 = !DILocation(line: 62, column: 5, scope: !33)
!40 = !DILocation(line: 62, column: 9, scope: !33)
!41 = !DILocation(line: 61, column: 21, scope: !33)
!42 = !DILocation(line: 61, column: 3, scope: !33)
!43 = distinct !{!43, !36, !44}
!44 = !DILocation(line: 62, column: 11, scope: !30)
!45 = !DILocation(line: 67, column: 11, scope: !46)
!46 = distinct !DILexicalBlock(scope: !47, file: !1, line: 67, column: 5)
!47 = distinct !DILexicalBlock(scope: !7, file: !1, line: 65, column: 3)
!48 = !DILocation(line: 67, column: 9, scope: !46)
!49 = !DILocation(line: 67, column: 16, scope: !50)
!50 = distinct !DILexicalBlock(scope: !46, file: !1, line: 67, column: 5)
!51 = !DILocation(line: 67, column: 20, scope: !50)
!52 = !DILocation(line: 67, column: 18, scope: !50)
!53 = !DILocation(line: 67, column: 5, scope: !46)
!54 = !DILocation(line: 68, column: 14, scope: !50)
!55 = !DILocation(line: 68, column: 20, scope: !50)
!56 = !DILocation(line: 68, column: 18, scope: !50)
!57 = !DILocation(line: 68, column: 22, scope: !50)
!58 = !DILocation(line: 68, column: 16, scope: !50)
!59 = !DILocation(line: 68, column: 9, scope: !50)
!60 = !DILocation(line: 68, column: 7, scope: !50)
!61 = !DILocation(line: 68, column: 12, scope: !50)
!62 = !DILocation(line: 67, column: 26, scope: !50)
!63 = !DILocation(line: 67, column: 5, scope: !50)
!64 = distinct !{!64, !53, !65}
!65 = !DILocation(line: 68, column: 23, scope: !46)
!66 = !DILocation(line: 73, column: 13, scope: !47)
!67 = !DILocation(line: 73, column: 18, scope: !47)
!68 = !DILocation(line: 73, column: 11, scope: !47)
!69 = !DILocation(line: 75, column: 3, scope: !70)
!70 = distinct !DILexicalBlock(scope: !71, file: !1, line: 75, column: 3)
!71 = distinct !DILexicalBlock(scope: !7, file: !1, line: 75, column: 3)
!72 = !DILocation(line: 75, column: 3, scope: !71)
!73 = !DILocation(line: 76, column: 27, scope: !7)
!74 = !DILocation(line: 76, column: 3, scope: !7)
!75 = !DILocation(line: 77, column: 3, scope: !7)
!76 = !DILocation(line: 78, column: 1, scope: !7)
