; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x = dso_local global float 0.000000e+00, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !6
@.str.1 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"argc\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"argv\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@.str = private unnamed_addr constant [11 x i8] c"x=%f y=%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !14 {
entry:
  call void @__dp_func_entry(i32 16440, i32 1)
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16440, i64 %0, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  %1 = ptrtoint i32* %argc.addr to i64
  call void @__dp_write(i32 16440, i64 %1, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i32 0, i32 0))
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !20, metadata !DIExpression()), !dbg !21
  %2 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_write(i32 16440, i64 %2, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0))
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !22, metadata !DIExpression()), !dbg !23
  %3 = ptrtoint float* @x to i64
  call void @__dp_write(i32 16446, i64 %3, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  store float 1.000000e+00, float* @x, align 4, !dbg !24
  %4 = ptrtoint i32* @y to i64
  call void @__dp_write(i32 16447, i64 %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  store i32 1, i32* @y, align 4, !dbg !27
  %5 = ptrtoint float* @x to i64
  call void @__dp_read(i32 16450, i64 %5, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
  %6 = load float, float* @x, align 4, !dbg !28
  %conv = fpext float %6 to double, !dbg !28
  %7 = ptrtoint i32* @y to i64
  call void @__dp_read(i32 16450, i64 %7, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
  %8 = load i32, i32* @y, align 4, !dbg !29
  call void @__dp_call(i32 16450), !dbg !30
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), double %conv, i32 %8), !dbg !30
  call void @__dp_finalize(i32 16451), !dbg !31
  ret i32 0, !dbg !31
}

declare void @__dp_func_entry(i32, i32)

declare void @__dp_write(i32, i64, i8*)

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_call(i32)

declare dso_local i32 @printf(i8*, ...) #2

declare void @__dp_finalize(i32)

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!10}
!llvm.module.flags = !{!11, !12, !13}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 52, type: !9, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/102")
!4 = !{}
!5 = !{!0, !6}
!6 = !DIGlobalVariableExpression(var: !7, expr: !DIExpression())
!7 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 53, type: !8, isLocal: false, isDefinition: true)
!8 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!9 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!10 = !{!"Ubuntu clang version 11.1.0-6"}
!11 = !{i32 7, !"Dwarf Version", i32 4}
!12 = !{i32 2, !"Debug Info Version", i32 3}
!13 = !{i32 1, !"wchar_size", i32 4}
!14 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 56, type: !15, scopeLine: 57, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!15 = !DISubroutineType(types: !16)
!16 = !{!8, !8, !17}
!17 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !18, size: 64)
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!19 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!20 = !DILocalVariable(name: "argc", arg: 1, scope: !14, file: !3, line: 56, type: !8)
!21 = !DILocation(line: 56, column: 15, scope: !14)
!22 = !DILocalVariable(name: "argv", arg: 2, scope: !14, file: !3, line: 56, type: !17)
!23 = !DILocation(line: 56, column: 28, scope: !14)
!24 = !DILocation(line: 62, column: 8, scope: !25)
!25 = distinct !DILexicalBlock(scope: !26, file: !3, line: 61, column: 5)
!26 = distinct !DILexicalBlock(scope: !14, file: !3, line: 59, column: 3)
!27 = !DILocation(line: 63, column: 8, scope: !25)
!28 = !DILocation(line: 66, column: 26, scope: !14)
!29 = !DILocation(line: 66, column: 29, scope: !14)
!30 = !DILocation(line: 66, column: 3, scope: !14)
!31 = !DILocation(line: 67, column: 3, scope: !14)
