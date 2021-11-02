; ModuleID = 'nqueens.c'
source_filename = "nqueens.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, %struct._IO_codecvt*, %struct._IO_wide_data*, %struct._IO_FILE*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type opaque
%struct._IO_codecvt = type opaque
%struct._IO_wide_data = type opaque

@total_count = common dso_local global i32 0, align 4, !dbg !0
@bots_verbose_mode = external dso_local global i32, align 4
@stdout = external dso_local global %struct._IO_FILE*, align 8
@.str = private unnamed_addr constant [37 x i8] c"Computing N-Queens algorithm (n=%d) \00", align 1
@.str.1 = private unnamed_addr constant [13 x i8] c" completed!\0A\00", align 1
@solutions = internal global [14 x i32] [i32 1, i32 0, i32 0, i32 2, i32 10, i32 4, i32 40, i32 92, i32 352, i32 724, i32 2680, i32 14200, i32 73712, i32 365596], align 16, !dbg !16

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @ok(i32 %n, i8* %a) #0 !dbg !26 {
entry:
  %retval = alloca i32, align 4
  %n.addr = alloca i32, align 4
  %a.addr = alloca i8*, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %p = alloca i8, align 1
  %q = alloca i8, align 1
  store i32 %n, i32* %n.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %n.addr, metadata !30, metadata !DIExpression()), !dbg !31
  store i8* %a, i8** %a.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %a.addr, metadata !32, metadata !DIExpression()), !dbg !33
  call void @llvm.dbg.declare(metadata i32* %i, metadata !34, metadata !DIExpression()), !dbg !35
  call void @llvm.dbg.declare(metadata i32* %j, metadata !36, metadata !DIExpression()), !dbg !37
  call void @llvm.dbg.declare(metadata i8* %p, metadata !38, metadata !DIExpression()), !dbg !39
  call void @llvm.dbg.declare(metadata i8* %q, metadata !40, metadata !DIExpression()), !dbg !41
  store i32 0, i32* %i, align 4, !dbg !42
  br label %for.cond, !dbg !44

for.cond:                                         ; preds = %for.inc21, %entry
  %0 = load i32, i32* %i, align 4, !dbg !45
  %1 = load i32, i32* %n.addr, align 4, !dbg !47
  %cmp = icmp slt i32 %0, %1, !dbg !48
  br i1 %cmp, label %for.body, label %for.end23, !dbg !49

for.body:                                         ; preds = %for.cond
  call void @incr_loop_counter(i32 1)
  %2 = load i8*, i8** %a.addr, align 8, !dbg !50
  %3 = load i32, i32* %i, align 4, !dbg !52
  %idxprom = sext i32 %3 to i64, !dbg !50
  %arrayidx = getelementptr inbounds i8, i8* %2, i64 %idxprom, !dbg !50
  %4 = load i8, i8* %arrayidx, align 1, !dbg !50
  store i8 %4, i8* %p, align 1, !dbg !53
  %5 = load i32, i32* %i, align 4, !dbg !54
  %add = add nsw i32 %5, 1, !dbg !56
  store i32 %add, i32* %j, align 4, !dbg !57
  br label %for.cond1, !dbg !58

for.cond1:                                        ; preds = %for.inc, %for.body
  %6 = load i32, i32* %j, align 4, !dbg !59
  %7 = load i32, i32* %n.addr, align 4, !dbg !61
  %cmp2 = icmp slt i32 %6, %7, !dbg !62
  br i1 %cmp2, label %for.body3, label %for.end, !dbg !63

for.body3:                                        ; preds = %for.cond1
  call void @incr_loop_counter(i32 2)
  %8 = load i8*, i8** %a.addr, align 8, !dbg !64
  %9 = load i32, i32* %j, align 4, !dbg !66
  %idxprom4 = sext i32 %9 to i64, !dbg !64
  %arrayidx5 = getelementptr inbounds i8, i8* %8, i64 %idxprom4, !dbg !64
  %10 = load i8, i8* %arrayidx5, align 1, !dbg !64
  store i8 %10, i8* %q, align 1, !dbg !67
  %11 = load i8, i8* %q, align 1, !dbg !68
  %conv = sext i8 %11 to i32, !dbg !68
  %12 = load i8, i8* %p, align 1, !dbg !70
  %conv6 = sext i8 %12 to i32, !dbg !70
  %cmp7 = icmp eq i32 %conv, %conv6, !dbg !71
  br i1 %cmp7, label %if.then, label %lor.lhs.false, !dbg !72

lor.lhs.false:                                    ; preds = %for.body3
  %13 = load i8, i8* %q, align 1, !dbg !73
  %conv9 = sext i8 %13 to i32, !dbg !73
  %14 = load i8, i8* %p, align 1, !dbg !74
  %conv10 = sext i8 %14 to i32, !dbg !74
  %15 = load i32, i32* %j, align 4, !dbg !75
  %16 = load i32, i32* %i, align 4, !dbg !76
  %sub = sub nsw i32 %15, %16, !dbg !77
  %sub11 = sub nsw i32 %conv10, %sub, !dbg !78
  %cmp12 = icmp eq i32 %conv9, %sub11, !dbg !79
  br i1 %cmp12, label %if.then, label %lor.lhs.false14, !dbg !80

lor.lhs.false14:                                  ; preds = %lor.lhs.false
  %17 = load i8, i8* %q, align 1, !dbg !81
  %conv15 = sext i8 %17 to i32, !dbg !81
  %18 = load i8, i8* %p, align 1, !dbg !82
  %conv16 = sext i8 %18 to i32, !dbg !82
  %19 = load i32, i32* %j, align 4, !dbg !83
  %20 = load i32, i32* %i, align 4, !dbg !84
  %sub17 = sub nsw i32 %19, %20, !dbg !85
  %add18 = add nsw i32 %conv16, %sub17, !dbg !86
  %cmp19 = icmp eq i32 %conv15, %add18, !dbg !87
  br i1 %cmp19, label %if.then, label %if.end, !dbg !88

if.then:                                          ; preds = %lor.lhs.false14, %lor.lhs.false, %for.body3
  store i32 0, i32* %retval, align 4, !dbg !89
  br label %return, !dbg !89

if.end:                                           ; preds = %lor.lhs.false14
  br label %for.inc, !dbg !90

for.inc:                                          ; preds = %if.end
  %21 = load i32, i32* %j, align 4, !dbg !91
  %inc = add nsw i32 %21, 1, !dbg !91
  store i32 %inc, i32* %j, align 4, !dbg !91
  br label %for.cond1, !dbg !92, !llvm.loop !93

for.end:                                          ; preds = %for.cond1
  br label %for.inc21, !dbg !95

for.inc21:                                        ; preds = %for.end
  %22 = load i32, i32* %i, align 4, !dbg !96
  %inc22 = add nsw i32 %22, 1, !dbg !96
  store i32 %inc22, i32* %i, align 4, !dbg !96
  br label %for.cond, !dbg !97, !llvm.loop !98

for.end23:                                        ; preds = %for.cond
  store i32 1, i32* %retval, align 4, !dbg !100
  br label %return, !dbg !100

return:                                           ; preds = %for.end23, %if.then
  %23 = load i32, i32* %retval, align 4, !dbg !101
  ret i32 %23, !dbg !101
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @nqueens(i32 %n, i32 %j, i8* %a, i32* %solutions) #0 !dbg !102 {
entry:
  %n.addr = alloca i32, align 4
  %j.addr = alloca i32, align 4
  %a.addr = alloca i8*, align 8
  %solutions.addr = alloca i32*, align 8
  %i = alloca i32, align 4
  %res = alloca i32, align 4
  store i32 %n, i32* %n.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %n.addr, metadata !106, metadata !DIExpression()), !dbg !107
  store i32 %j, i32* %j.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %j.addr, metadata !108, metadata !DIExpression()), !dbg !109
  store i8* %a, i8** %a.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %a.addr, metadata !110, metadata !DIExpression()), !dbg !111
  store i32* %solutions, i32** %solutions.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %solutions.addr, metadata !112, metadata !DIExpression()), !dbg !113
  call void @llvm.dbg.declare(metadata i32* %i, metadata !114, metadata !DIExpression()), !dbg !115
  call void @llvm.dbg.declare(metadata i32* %res, metadata !116, metadata !DIExpression()), !dbg !117
  %0 = load i32, i32* %n.addr, align 4, !dbg !118
  %1 = load i32, i32* %j.addr, align 4, !dbg !120
  %cmp = icmp eq i32 %0, %1, !dbg !121
  br i1 %cmp, label %if.then, label %if.end, !dbg !122

if.then:                                          ; preds = %entry
  %2 = load i32*, i32** %solutions.addr, align 8, !dbg !123
  store i32 1, i32* %2, align 4, !dbg !125
  br label %for.end, !dbg !126

if.end:                                           ; preds = %entry
  %3 = load i32*, i32** %solutions.addr, align 8, !dbg !127
  store i32 0, i32* %3, align 4, !dbg !128
  store i32 0, i32* %i, align 4, !dbg !129
  br label %for.cond, !dbg !131

for.cond:                                         ; preds = %for.inc, %if.end
  %4 = load i32, i32* %i, align 4, !dbg !132
  %5 = load i32, i32* %n.addr, align 4, !dbg !134
  %cmp1 = icmp slt i32 %4, %5, !dbg !135
  br i1 %cmp1, label %for.body, label %for.end, !dbg !136

for.body:                                         ; preds = %for.cond
  call void @incr_loop_counter(i32 3)
  %6 = load i32, i32* %i, align 4, !dbg !137
  %conv = trunc i32 %6 to i8, !dbg !139
  %7 = load i8*, i8** %a.addr, align 8, !dbg !140
  %8 = load i32, i32* %j.addr, align 4, !dbg !141
  %idxprom = sext i32 %8 to i64, !dbg !140
  %arrayidx = getelementptr inbounds i8, i8* %7, i64 %idxprom, !dbg !140
  store i8 %conv, i8* %arrayidx, align 1, !dbg !142
  %9 = load i32, i32* %j.addr, align 4, !dbg !143
  %add = add nsw i32 %9, 1, !dbg !145
  %10 = load i8*, i8** %a.addr, align 8, !dbg !146
  %call = call i32 @ok(i32 %add, i8* %10), !dbg !147
  %tobool = icmp ne i32 %call, 0, !dbg !147
  br i1 %tobool, label %if.then2, label %if.end5, !dbg !148

if.then2:                                         ; preds = %for.body
  %11 = load i32, i32* %n.addr, align 4, !dbg !149
  %12 = load i32, i32* %j.addr, align 4, !dbg !151
  %add3 = add nsw i32 %12, 1, !dbg !152
  %13 = load i8*, i8** %a.addr, align 8, !dbg !153
  call void @nqueens(i32 %11, i32 %add3, i8* %13, i32* %res), !dbg !154
  %14 = load i32, i32* %res, align 4, !dbg !155
  %15 = load i32*, i32** %solutions.addr, align 8, !dbg !156
  call void @add_instr_rec(i32 92, i64 1, i32 0)
  %16 = load i32, i32* %15, align 4, !dbg !157
  %add4 = add nsw i32 %16, %14, !dbg !157
  call void @add_instr_rec(i32 92, i64 1, i32 1)
  store i32 %add4, i32* %15, align 4, !dbg !157
  br label %if.end5, !dbg !158

if.end5:                                          ; preds = %if.then2, %for.body
  br label %for.inc, !dbg !159

for.inc:                                          ; preds = %if.end5
  %17 = load i32, i32* %i, align 4, !dbg !160
  %inc = add nsw i32 %17, 1, !dbg !160
  store i32 %inc, i32* %i, align 4, !dbg !160
  br label %for.cond, !dbg !161, !llvm.loop !162

for.end:                                          ; preds = %if.then, %for.cond
  ret void, !dbg !164
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @find_queens(i32 %size) #0 !dbg !165 {
entry:
  %size.addr = alloca i32, align 4
  %a = alloca i8*, align 8
  store i32 %size, i32* %size.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %size.addr, metadata !168, metadata !DIExpression()), !dbg !169
  call void @llvm.dbg.declare(metadata i8** %a, metadata !170, metadata !DIExpression()), !dbg !171
  store i32 0, i32* @total_count, align 4, !dbg !172
  %0 = load i32, i32* %size.addr, align 4, !dbg !173
  %conv = sext i32 %0 to i64, !dbg !173
  %mul = mul i64 %conv, 1, !dbg !173
  %1 = alloca i8, i64 %mul, align 16, !dbg !173
  store i8* %1, i8** %a, align 8, !dbg !174
  %2 = load i32, i32* @bots_verbose_mode, align 4, !dbg !175
  %cmp = icmp uge i32 %2, 1, !dbg !175
  br i1 %cmp, label %if.then, label %if.end, !dbg !178

if.then:                                          ; preds = %entry
  %3 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !179
  %4 = load i32, i32* %size.addr, align 4, !dbg !179
  %call = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([37 x i8], [37 x i8]* @.str, i32 0, i32 0), i32 %4), !dbg !179
  br label %if.end, !dbg !179

if.end:                                           ; preds = %if.then, %entry
  %5 = load i32, i32* %size.addr, align 4, !dbg !181
  %6 = load i8*, i8** %a, align 8, !dbg !182
  call void @nqueens(i32 %5, i32 0, i8* %6, i32* @total_count), !dbg !183
  %7 = load i32, i32* @bots_verbose_mode, align 4, !dbg !184
  %cmp2 = icmp uge i32 %7, 1, !dbg !184
  br i1 %cmp2, label %if.then4, label %if.end6, !dbg !187

if.then4:                                         ; preds = %if.end
  %8 = load %struct._IO_FILE*, %struct._IO_FILE** @stdout, align 8, !dbg !188
  %call5 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %8, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.1, i32 0, i32 0)), !dbg !188
  br label %if.end6, !dbg !188

if.end6:                                          ; preds = %if.then4, %if.end
  ret void, !dbg !190
}

declare dso_local i32 @fprintf(%struct._IO_FILE*, i8*, ...) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @verify_queens(i32 %size) #0 !dbg !191 {
entry:
  %retval = alloca i32, align 4
  %size.addr = alloca i32, align 4
  store i32 %size, i32* %size.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %size.addr, metadata !194, metadata !DIExpression()), !dbg !195
  %0 = load i32, i32* %size.addr, align 4, !dbg !196
  %conv = sext i32 %0 to i64, !dbg !196
  %cmp = icmp ugt i64 %conv, 14, !dbg !198
  br i1 %cmp, label %if.then, label %if.end, !dbg !199

if.then:                                          ; preds = %entry
  store i32 0, i32* %retval, align 4, !dbg !200
  br label %return, !dbg !200

if.end:                                           ; preds = %entry
  %1 = load i32, i32* @total_count, align 4, !dbg !201
  %2 = load i32, i32* %size.addr, align 4, !dbg !203
  %sub = sub nsw i32 %2, 1, !dbg !204
  %idxprom = sext i32 %sub to i64, !dbg !205
  %arrayidx = getelementptr inbounds [14 x i32], [14 x i32]* @solutions, i64 0, i64 %idxprom, !dbg !205
  %3 = load i32, i32* %arrayidx, align 4, !dbg !205
  %cmp2 = icmp eq i32 %1, %3, !dbg !206
  br i1 %cmp2, label %if.then4, label %if.end5, !dbg !207

if.then4:                                         ; preds = %if.end
  store i32 1, i32* %retval, align 4, !dbg !208
  br label %return, !dbg !208

if.end5:                                          ; preds = %if.end
  store i32 2, i32* %retval, align 4, !dbg !209
  br label %return, !dbg !209

return:                                           ; preds = %if.end5, %if.then4, %if.then
  %4 = load i32, i32* %retval, align 4, !dbg !210
  ret i32 %4, !dbg !210
}

declare void @add_instr_rec(i32, i64, i32)

declare void @add_ptr_instr_rec(i32, i64, i32, i64)

declare void @incr_loop_counter(i32)

declare void @loop_counter_output()

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!22, !23, !24}
!llvm.ident = !{!25}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "total_count", scope: !2, file: !3, line: 56, type: !19, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 8.0.1-9 (tags/RELEASE_801/final)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !12, globals: !15, nameTableKind: None)
!3 = !DIFile(filename: "nqueens.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/nqueens")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 76, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "./bots.h", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/bots_reduced/serial/nqueens")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11}
!9 = !DIEnumerator(name: "BOTS_VERBOSE_NONE", value: 0, isUnsigned: true)
!10 = !DIEnumerator(name: "BOTS_VERBOSE_DEFAULT", value: 1, isUnsigned: true)
!11 = !DIEnumerator(name: "BOTS_VERBOSE_DEBUG", value: 2, isUnsigned: true)
!12 = !{!13, !14}
!13 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!15 = !{!0, !16}
!16 = !DIGlobalVariableExpression(var: !17, expr: !DIExpression())
!17 = distinct !DIGlobalVariable(name: "solutions", scope: !2, file: !3, line: 38, type: !18, isLocal: true, isDefinition: true)
!18 = !DICompositeType(tag: DW_TAG_array_type, baseType: !19, size: 448, elements: !20)
!19 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!20 = !{!21}
!21 = !DISubrange(count: 14)
!22 = !{i32 2, !"Dwarf Version", i32 4}
!23 = !{i32 2, !"Debug Info Version", i32 3}
!24 = !{i32 1, !"wchar_size", i32 4}
!25 = !{!"clang version 8.0.1-9 (tags/RELEASE_801/final)"}
!26 = distinct !DISubprogram(name: "ok", scope: !3, file: !3, line: 62, type: !27, scopeLine: 63, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !29)
!27 = !DISubroutineType(types: !28)
!28 = !{!19, !19, !14}
!29 = !{}
!30 = !DILocalVariable(name: "n", arg: 1, scope: !26, file: !3, line: 62, type: !19)
!31 = !DILocation(line: 62, column: 12, scope: !26)
!32 = !DILocalVariable(name: "a", arg: 2, scope: !26, file: !3, line: 62, type: !14)
!33 = !DILocation(line: 62, column: 21, scope: !26)
!34 = !DILocalVariable(name: "i", scope: !26, file: !3, line: 64, type: !19)
!35 = !DILocation(line: 64, column: 10, scope: !26)
!36 = !DILocalVariable(name: "j", scope: !26, file: !3, line: 64, type: !19)
!37 = !DILocation(line: 64, column: 13, scope: !26)
!38 = !DILocalVariable(name: "p", scope: !26, file: !3, line: 65, type: !13)
!39 = !DILocation(line: 65, column: 11, scope: !26)
!40 = !DILocalVariable(name: "q", scope: !26, file: !3, line: 65, type: !13)
!41 = !DILocation(line: 65, column: 14, scope: !26)
!42 = !DILocation(line: 67, column: 13, scope: !43)
!43 = distinct !DILexicalBlock(scope: !26, file: !3, line: 67, column: 6)
!44 = !DILocation(line: 67, column: 11, scope: !43)
!45 = !DILocation(line: 67, column: 18, scope: !46)
!46 = distinct !DILexicalBlock(scope: !43, file: !3, line: 67, column: 6)
!47 = !DILocation(line: 67, column: 22, scope: !46)
!48 = !DILocation(line: 67, column: 20, scope: !46)
!49 = !DILocation(line: 67, column: 6, scope: !43)
!50 = !DILocation(line: 68, column: 8, scope: !51)
!51 = distinct !DILexicalBlock(scope: !46, file: !3, line: 67, column: 30)
!52 = !DILocation(line: 68, column: 10, scope: !51)
!53 = !DILocation(line: 68, column: 6, scope: !51)
!54 = !DILocation(line: 70, column: 13, scope: !55)
!55 = distinct !DILexicalBlock(scope: !51, file: !3, line: 70, column: 4)
!56 = !DILocation(line: 70, column: 15, scope: !55)
!57 = !DILocation(line: 70, column: 11, scope: !55)
!58 = !DILocation(line: 70, column: 9, scope: !55)
!59 = !DILocation(line: 70, column: 20, scope: !60)
!60 = distinct !DILexicalBlock(scope: !55, file: !3, line: 70, column: 4)
!61 = !DILocation(line: 70, column: 24, scope: !60)
!62 = !DILocation(line: 70, column: 22, scope: !60)
!63 = !DILocation(line: 70, column: 4, scope: !55)
!64 = !DILocation(line: 71, column: 13, scope: !65)
!65 = distinct !DILexicalBlock(scope: !60, file: !3, line: 70, column: 32)
!66 = !DILocation(line: 71, column: 15, scope: !65)
!67 = !DILocation(line: 71, column: 11, scope: !65)
!68 = !DILocation(line: 72, column: 13, scope: !69)
!69 = distinct !DILexicalBlock(scope: !65, file: !3, line: 72, column: 13)
!70 = !DILocation(line: 72, column: 18, scope: !69)
!71 = !DILocation(line: 72, column: 15, scope: !69)
!72 = !DILocation(line: 72, column: 20, scope: !69)
!73 = !DILocation(line: 72, column: 23, scope: !69)
!74 = !DILocation(line: 72, column: 28, scope: !69)
!75 = !DILocation(line: 72, column: 33, scope: !69)
!76 = !DILocation(line: 72, column: 37, scope: !69)
!77 = !DILocation(line: 72, column: 35, scope: !69)
!78 = !DILocation(line: 72, column: 30, scope: !69)
!79 = !DILocation(line: 72, column: 25, scope: !69)
!80 = !DILocation(line: 72, column: 40, scope: !69)
!81 = !DILocation(line: 72, column: 43, scope: !69)
!82 = !DILocation(line: 72, column: 48, scope: !69)
!83 = !DILocation(line: 72, column: 53, scope: !69)
!84 = !DILocation(line: 72, column: 57, scope: !69)
!85 = !DILocation(line: 72, column: 55, scope: !69)
!86 = !DILocation(line: 72, column: 50, scope: !69)
!87 = !DILocation(line: 72, column: 45, scope: !69)
!88 = !DILocation(line: 72, column: 13, scope: !65)
!89 = !DILocation(line: 73, column: 7, scope: !69)
!90 = !DILocation(line: 74, column: 4, scope: !65)
!91 = !DILocation(line: 70, column: 28, scope: !60)
!92 = !DILocation(line: 70, column: 4, scope: !60)
!93 = distinct !{!93, !63, !94}
!94 = !DILocation(line: 74, column: 4, scope: !55)
!95 = !DILocation(line: 75, column: 6, scope: !51)
!96 = !DILocation(line: 67, column: 26, scope: !46)
!97 = !DILocation(line: 67, column: 6, scope: !46)
!98 = distinct !{!98, !49, !99}
!99 = !DILocation(line: 75, column: 6, scope: !43)
!100 = !DILocation(line: 76, column: 6, scope: !26)
!101 = !DILocation(line: 77, column: 1, scope: !26)
!102 = distinct !DISubprogram(name: "nqueens", scope: !3, file: !3, line: 79, type: !103, scopeLine: 80, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !29)
!103 = !DISubroutineType(types: !104)
!104 = !{null, !19, !19, !14, !105}
!105 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!106 = !DILocalVariable(name: "n", arg: 1, scope: !102, file: !3, line: 79, type: !19)
!107 = !DILocation(line: 79, column: 19, scope: !102)
!108 = !DILocalVariable(name: "j", arg: 2, scope: !102, file: !3, line: 79, type: !19)
!109 = !DILocation(line: 79, column: 26, scope: !102)
!110 = !DILocalVariable(name: "a", arg: 3, scope: !102, file: !3, line: 79, type: !14)
!111 = !DILocation(line: 79, column: 35, scope: !102)
!112 = !DILocalVariable(name: "solutions", arg: 4, scope: !102, file: !3, line: 79, type: !105)
!113 = !DILocation(line: 79, column: 43, scope: !102)
!114 = !DILocalVariable(name: "i", scope: !102, file: !3, line: 81, type: !19)
!115 = !DILocation(line: 81, column: 6, scope: !102)
!116 = !DILocalVariable(name: "res", scope: !102, file: !3, line: 81, type: !19)
!117 = !DILocation(line: 81, column: 8, scope: !102)
!118 = !DILocation(line: 83, column: 6, scope: !119)
!119 = distinct !DILexicalBlock(scope: !102, file: !3, line: 83, column: 6)
!120 = !DILocation(line: 83, column: 11, scope: !119)
!121 = !DILocation(line: 83, column: 8, scope: !119)
!122 = !DILocation(line: 83, column: 6, scope: !102)
!123 = !DILocation(line: 85, column: 4, scope: !124)
!124 = distinct !DILexicalBlock(scope: !119, file: !3, line: 83, column: 14)
!125 = !DILocation(line: 85, column: 14, scope: !124)
!126 = !DILocation(line: 86, column: 3, scope: !124)
!127 = !DILocation(line: 89, column: 3, scope: !102)
!128 = !DILocation(line: 89, column: 13, scope: !102)
!129 = !DILocation(line: 92, column: 9, scope: !130)
!130 = distinct !DILexicalBlock(scope: !102, file: !3, line: 92, column: 2)
!131 = !DILocation(line: 92, column: 7, scope: !130)
!132 = !DILocation(line: 92, column: 14, scope: !133)
!133 = distinct !DILexicalBlock(scope: !130, file: !3, line: 92, column: 2)
!134 = !DILocation(line: 92, column: 18, scope: !133)
!135 = !DILocation(line: 92, column: 16, scope: !133)
!136 = !DILocation(line: 92, column: 2, scope: !130)
!137 = !DILocation(line: 93, column: 17, scope: !138)
!138 = distinct !DILexicalBlock(scope: !133, file: !3, line: 92, column: 26)
!139 = !DILocation(line: 93, column: 10, scope: !138)
!140 = !DILocation(line: 93, column: 3, scope: !138)
!141 = !DILocation(line: 93, column: 5, scope: !138)
!142 = !DILocation(line: 93, column: 8, scope: !138)
!143 = !DILocation(line: 94, column: 10, scope: !144)
!144 = distinct !DILexicalBlock(scope: !138, file: !3, line: 94, column: 7)
!145 = !DILocation(line: 94, column: 12, scope: !144)
!146 = !DILocation(line: 94, column: 17, scope: !144)
!147 = !DILocation(line: 94, column: 7, scope: !144)
!148 = !DILocation(line: 94, column: 7, scope: !138)
!149 = !DILocation(line: 95, column: 19, scope: !150)
!150 = distinct !DILexicalBlock(scope: !144, file: !3, line: 94, column: 21)
!151 = !DILocation(line: 95, column: 22, scope: !150)
!152 = !DILocation(line: 95, column: 24, scope: !150)
!153 = !DILocation(line: 95, column: 29, scope: !150)
!154 = !DILocation(line: 95, column: 11, scope: !150)
!155 = !DILocation(line: 96, column: 18, scope: !150)
!156 = !DILocation(line: 96, column: 5, scope: !150)
!157 = !DILocation(line: 96, column: 15, scope: !150)
!158 = !DILocation(line: 97, column: 3, scope: !150)
!159 = !DILocation(line: 98, column: 2, scope: !138)
!160 = !DILocation(line: 92, column: 22, scope: !133)
!161 = !DILocation(line: 92, column: 2, scope: !133)
!162 = distinct !{!162, !136, !163}
!163 = !DILocation(line: 98, column: 2, scope: !130)
!164 = !DILocation(line: 99, column: 1, scope: !102)
!165 = distinct !DISubprogram(name: "find_queens", scope: !3, file: !3, line: 101, type: !166, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !29)
!166 = !DISubroutineType(types: !167)
!167 = !{null, !19}
!168 = !DILocalVariable(name: "size", arg: 1, scope: !165, file: !3, line: 101, type: !19)
!169 = !DILocation(line: 101, column: 23, scope: !165)
!170 = !DILocalVariable(name: "a", scope: !165, file: !3, line: 103, type: !14)
!171 = !DILocation(line: 103, column: 8, scope: !165)
!172 = !DILocation(line: 105, column: 13, scope: !165)
!173 = !DILocation(line: 106, column: 14, scope: !165)
!174 = !DILocation(line: 106, column: 4, scope: !165)
!175 = !DILocation(line: 107, column: 2, scope: !176)
!176 = distinct !DILexicalBlock(scope: !177, file: !3, line: 107, column: 2)
!177 = distinct !DILexicalBlock(scope: !165, file: !3, line: 107, column: 2)
!178 = !DILocation(line: 107, column: 2, scope: !177)
!179 = !DILocation(line: 107, column: 2, scope: !180)
!180 = distinct !DILexicalBlock(scope: !176, file: !3, line: 107, column: 2)
!181 = !DILocation(line: 108, column: 10, scope: !165)
!182 = !DILocation(line: 108, column: 19, scope: !165)
!183 = !DILocation(line: 108, column: 2, scope: !165)
!184 = !DILocation(line: 109, column: 9, scope: !185)
!185 = distinct !DILexicalBlock(scope: !186, file: !3, line: 109, column: 9)
!186 = distinct !DILexicalBlock(scope: !165, file: !3, line: 109, column: 9)
!187 = !DILocation(line: 109, column: 9, scope: !186)
!188 = !DILocation(line: 109, column: 9, scope: !189)
!189 = distinct !DILexicalBlock(scope: !185, file: !3, line: 109, column: 9)
!190 = !DILocation(line: 110, column: 1, scope: !165)
!191 = distinct !DISubprogram(name: "verify_queens", scope: !3, file: !3, line: 112, type: !192, scopeLine: 113, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !29)
!192 = !DISubroutineType(types: !193)
!193 = !{!19, !19}
!194 = !DILocalVariable(name: "size", arg: 1, scope: !191, file: !3, line: 112, type: !19)
!195 = !DILocation(line: 112, column: 24, scope: !191)
!196 = !DILocation(line: 114, column: 7, scope: !197)
!197 = distinct !DILexicalBlock(scope: !191, file: !3, line: 114, column: 7)
!198 = !DILocation(line: 114, column: 12, scope: !197)
!199 = !DILocation(line: 114, column: 7, scope: !191)
!200 = !DILocation(line: 114, column: 30, scope: !197)
!201 = !DILocation(line: 115, column: 7, scope: !202)
!202 = distinct !DILexicalBlock(scope: !191, file: !3, line: 115, column: 7)
!203 = !DILocation(line: 115, column: 32, scope: !202)
!204 = !DILocation(line: 115, column: 36, scope: !202)
!205 = !DILocation(line: 115, column: 22, scope: !202)
!206 = !DILocation(line: 115, column: 19, scope: !202)
!207 = !DILocation(line: 115, column: 7, scope: !191)
!208 = !DILocation(line: 115, column: 41, scope: !202)
!209 = !DILocation(line: 116, column: 2, scope: !191)
!210 = !DILocation(line: 117, column: 1, scope: !191)
