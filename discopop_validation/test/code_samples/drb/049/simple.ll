; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, %struct._IO_codecvt*, %struct._IO_wide_data*, %struct._IO_FILE*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type opaque
%struct._IO_codecvt = type opaque
%struct._IO_wide_data = type opaque

@.str = private unnamed_addr constant [15 x i8] c"mytempfile.txt\00", align 1
@.str.1 = private unnamed_addr constant [3 x i8] c"a+\00", align 1
@stderr = external dso_local global %struct._IO_FILE*, align 8
@.str.2 = private unnamed_addr constant [18 x i8] c"Error in fopen()\0A\00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@.str.4 = private unnamed_addr constant [40 x i8] c"Error: unable to delete mytempfile.txt\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !9 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %ret = alloca i32, align 4
  %pfile = alloca %struct._IO_FILE*, align 8
  %len = alloca i32, align 4
  %A = alloca [1000 x i32], align 16
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !16, metadata !DIExpression()), !dbg !17
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !18, metadata !DIExpression()), !dbg !19
  call void @llvm.dbg.declare(metadata i32* %i, metadata !20, metadata !DIExpression()), !dbg !21
  call void @llvm.dbg.declare(metadata i32* %ret, metadata !22, metadata !DIExpression()), !dbg !23
  call void @llvm.dbg.declare(metadata %struct._IO_FILE** %pfile, metadata !24, metadata !DIExpression()), !dbg !84
  call void @llvm.dbg.declare(metadata i32* %len, metadata !85, metadata !DIExpression()), !dbg !86
  store i32 1000, i32* %len, align 4, !dbg !86
  call void @llvm.dbg.declare(metadata [1000 x i32]* %A, metadata !87, metadata !DIExpression()), !dbg !91
  store i32 0, i32* %i, align 4, !dbg !92
  br label %for.cond, !dbg !94

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !95
  %1 = load i32, i32* %len, align 4, !dbg !97
  %cmp = icmp slt i32 %0, %1, !dbg !98
  br i1 %cmp, label %for.body, label %for.end, !dbg !99

for.body:                                         ; preds = %for.cond
  %2 = load i32, i32* %i, align 4, !dbg !100
  %3 = load i32, i32* %i, align 4, !dbg !101
  %idxprom = sext i32 %3 to i64, !dbg !102
  %arrayidx = getelementptr inbounds [1000 x i32], [1000 x i32]* %A, i64 0, i64 %idxprom, !dbg !102
  store i32 %2, i32* %arrayidx, align 4, !dbg !103
  br label %for.inc, !dbg !102

for.inc:                                          ; preds = %for.body
  %4 = load i32, i32* %i, align 4, !dbg !104
  %inc = add nsw i32 %4, 1, !dbg !104
  store i32 %inc, i32* %i, align 4, !dbg !104
  br label %for.cond, !dbg !105, !llvm.loop !106

for.end:                                          ; preds = %for.cond
  %call = call noalias %struct._IO_FILE* @fopen(i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str, i64 0, i64 0), i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.1, i64 0, i64 0)), !dbg !108
  store %struct._IO_FILE* %call, %struct._IO_FILE** %pfile, align 8, !dbg !109
  %5 = load %struct._IO_FILE*, %struct._IO_FILE** %pfile, align 8, !dbg !110
  %cmp1 = icmp eq %struct._IO_FILE* %5, null, !dbg !112
  br i1 %cmp1, label %if.then, label %if.end, !dbg !113

if.then:                                          ; preds = %for.end
  %6 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !114
  %call2 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %6, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.2, i64 0, i64 0)), !dbg !116
  br label %if.end, !dbg !117

if.end:                                           ; preds = %if.then, %for.end
  store i32 0, i32* %i, align 4, !dbg !118
  br label %for.cond3, !dbg !120

for.cond3:                                        ; preds = %for.inc9, %if.end
  %7 = load i32, i32* %i, align 4, !dbg !121
  %8 = load i32, i32* %len, align 4, !dbg !123
  %cmp4 = icmp slt i32 %7, %8, !dbg !124
  br i1 %cmp4, label %for.body5, label %for.end11, !dbg !125

for.body5:                                        ; preds = %for.cond3
  %9 = load %struct._IO_FILE*, %struct._IO_FILE** %pfile, align 8, !dbg !126
  %10 = load i32, i32* %i, align 4, !dbg !128
  %idxprom6 = sext i32 %10 to i64, !dbg !129
  %arrayidx7 = getelementptr inbounds [1000 x i32], [1000 x i32]* %A, i64 0, i64 %idxprom6, !dbg !129
  %11 = load i32, i32* %arrayidx7, align 4, !dbg !129
  %call8 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %9, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i64 0, i64 0), i32 %11), !dbg !130
  br label %for.inc9, !dbg !131

for.inc9:                                         ; preds = %for.body5
  %12 = load i32, i32* %i, align 4, !dbg !132
  %inc10 = add nsw i32 %12, 1, !dbg !132
  store i32 %inc10, i32* %i, align 4, !dbg !132
  br label %for.cond3, !dbg !133, !llvm.loop !134

for.end11:                                        ; preds = %for.cond3
  %13 = load %struct._IO_FILE*, %struct._IO_FILE** %pfile, align 8, !dbg !136
  %call12 = call i32 @fclose(%struct._IO_FILE* %13), !dbg !137
  %call13 = call i32 @remove(i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str, i64 0, i64 0)) #4, !dbg !138
  store i32 %call13, i32* %ret, align 4, !dbg !139
  %14 = load i32, i32* %ret, align 4, !dbg !140
  %cmp14 = icmp ne i32 %14, 0, !dbg !142
  br i1 %cmp14, label %if.then15, label %if.end17, !dbg !143

if.then15:                                        ; preds = %for.end11
  %15 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !144
  %call16 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %15, i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.4, i64 0, i64 0)), !dbg !146
  br label %if.end17, !dbg !147

if.end17:                                         ; preds = %if.then15, %for.end11
  ret i32 0, !dbg !148
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local noalias %struct._IO_FILE* @fopen(i8*, i8*) #2

declare dso_local i32 @fprintf(%struct._IO_FILE*, i8*, ...) #2

declare dso_local i32 @fclose(%struct._IO_FILE*) #2

; Function Attrs: nounwind
declare dso_local i32 @remove(i8*) #3

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!5, !6, !7}
!llvm.ident = !{!8}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/049")
!2 = !{}
!3 = !{!4}
!4 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!5 = !{i32 7, !"Dwarf Version", i32 4}
!6 = !{i32 2, !"Debug Info Version", i32 3}
!7 = !{i32 1, !"wchar_size", i32 4}
!8 = !{!"Ubuntu clang version 11.1.0-6"}
!9 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 51, type: !10, scopeLine: 52, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!10 = !DISubroutineType(types: !11)
!11 = !{!12, !12, !13}
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!15 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!16 = !DILocalVariable(name: "argc", arg: 1, scope: !9, file: !1, line: 51, type: !12)
!17 = !DILocation(line: 51, column: 14, scope: !9)
!18 = !DILocalVariable(name: "argv", arg: 2, scope: !9, file: !1, line: 51, type: !13)
!19 = !DILocation(line: 51, column: 26, scope: !9)
!20 = !DILocalVariable(name: "i", scope: !9, file: !1, line: 53, type: !12)
!21 = !DILocation(line: 53, column: 7, scope: !9)
!22 = !DILocalVariable(name: "ret", scope: !9, file: !1, line: 54, type: !12)
!23 = !DILocation(line: 54, column: 7, scope: !9)
!24 = !DILocalVariable(name: "pfile", scope: !9, file: !1, line: 55, type: !25)
!25 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !26, size: 64)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "FILE", file: !27, line: 7, baseType: !28)
!27 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/FILE.h", directory: "")
!28 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_FILE", file: !29, line: 49, size: 1728, elements: !30)
!29 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/struct_FILE.h", directory: "")
!30 = !{!31, !32, !33, !34, !35, !36, !37, !38, !39, !40, !41, !42, !43, !46, !48, !49, !50, !54, !56, !58, !62, !65, !67, !70, !73, !74, !75, !79, !80}
!31 = !DIDerivedType(tag: DW_TAG_member, name: "_flags", scope: !28, file: !29, line: 51, baseType: !12, size: 32)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_ptr", scope: !28, file: !29, line: 54, baseType: !14, size: 64, offset: 64)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_end", scope: !28, file: !29, line: 55, baseType: !14, size: 64, offset: 128)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_base", scope: !28, file: !29, line: 56, baseType: !14, size: 64, offset: 192)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_base", scope: !28, file: !29, line: 57, baseType: !14, size: 64, offset: 256)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_ptr", scope: !28, file: !29, line: 58, baseType: !14, size: 64, offset: 320)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_end", scope: !28, file: !29, line: 59, baseType: !14, size: 64, offset: 384)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_buf_base", scope: !28, file: !29, line: 60, baseType: !14, size: 64, offset: 448)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_buf_end", scope: !28, file: !29, line: 61, baseType: !14, size: 64, offset: 512)
!40 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_save_base", scope: !28, file: !29, line: 64, baseType: !14, size: 64, offset: 576)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_backup_base", scope: !28, file: !29, line: 65, baseType: !14, size: 64, offset: 640)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_save_end", scope: !28, file: !29, line: 66, baseType: !14, size: 64, offset: 704)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "_markers", scope: !28, file: !29, line: 68, baseType: !44, size: 64, offset: 768)
!44 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !45, size: 64)
!45 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_marker", file: !29, line: 36, flags: DIFlagFwdDecl)
!46 = !DIDerivedType(tag: DW_TAG_member, name: "_chain", scope: !28, file: !29, line: 70, baseType: !47, size: 64, offset: 832)
!47 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !28, size: 64)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "_fileno", scope: !28, file: !29, line: 72, baseType: !12, size: 32, offset: 896)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "_flags2", scope: !28, file: !29, line: 73, baseType: !12, size: 32, offset: 928)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "_old_offset", scope: !28, file: !29, line: 74, baseType: !51, size: 64, offset: 960)
!51 = !DIDerivedType(tag: DW_TAG_typedef, name: "__off_t", file: !52, line: 152, baseType: !53)
!52 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!53 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "_cur_column", scope: !28, file: !29, line: 77, baseType: !55, size: 16, offset: 1024)
!55 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "_vtable_offset", scope: !28, file: !29, line: 78, baseType: !57, size: 8, offset: 1040)
!57 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "_shortbuf", scope: !28, file: !29, line: 79, baseType: !59, size: 8, offset: 1048)
!59 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 8, elements: !60)
!60 = !{!61}
!61 = !DISubrange(count: 1)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "_lock", scope: !28, file: !29, line: 81, baseType: !63, size: 64, offset: 1088)
!63 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !64, size: 64)
!64 = !DIDerivedType(tag: DW_TAG_typedef, name: "_IO_lock_t", file: !29, line: 43, baseType: null)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "_offset", scope: !28, file: !29, line: 89, baseType: !66, size: 64, offset: 1152)
!66 = !DIDerivedType(tag: DW_TAG_typedef, name: "__off64_t", file: !52, line: 153, baseType: !53)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "_codecvt", scope: !28, file: !29, line: 91, baseType: !68, size: 64, offset: 1216)
!68 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !69, size: 64)
!69 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_codecvt", file: !29, line: 37, flags: DIFlagFwdDecl)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "_wide_data", scope: !28, file: !29, line: 92, baseType: !71, size: 64, offset: 1280)
!71 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !72, size: 64)
!72 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_wide_data", file: !29, line: 38, flags: DIFlagFwdDecl)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "_freeres_list", scope: !28, file: !29, line: 93, baseType: !47, size: 64, offset: 1344)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "_freeres_buf", scope: !28, file: !29, line: 94, baseType: !4, size: 64, offset: 1408)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "__pad5", scope: !28, file: !29, line: 95, baseType: !76, size: 64, offset: 1472)
!76 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !77, line: 46, baseType: !78)
!77 = !DIFile(filename: "/usr/lib/llvm-11/lib/clang/11.1.0/include/stddef.h", directory: "")
!78 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "_mode", scope: !28, file: !29, line: 96, baseType: !12, size: 32, offset: 1536)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "_unused2", scope: !28, file: !29, line: 98, baseType: !81, size: 160, offset: 1568)
!81 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 160, elements: !82)
!82 = !{!83}
!83 = !DISubrange(count: 20)
!84 = !DILocation(line: 55, column: 9, scope: !9)
!85 = !DILocalVariable(name: "len", scope: !9, file: !1, line: 56, type: !12)
!86 = !DILocation(line: 56, column: 7, scope: !9)
!87 = !DILocalVariable(name: "A", scope: !9, file: !1, line: 58, type: !88)
!88 = !DICompositeType(tag: DW_TAG_array_type, baseType: !12, size: 32000, elements: !89)
!89 = !{!90}
!90 = !DISubrange(count: 1000)
!91 = !DILocation(line: 58, column: 7, scope: !9)
!92 = !DILocation(line: 60, column: 9, scope: !93)
!93 = distinct !DILexicalBlock(scope: !9, file: !1, line: 60, column: 3)
!94 = !DILocation(line: 60, column: 8, scope: !93)
!95 = !DILocation(line: 60, column: 13, scope: !96)
!96 = distinct !DILexicalBlock(scope: !93, file: !1, line: 60, column: 3)
!97 = !DILocation(line: 60, column: 15, scope: !96)
!98 = !DILocation(line: 60, column: 14, scope: !96)
!99 = !DILocation(line: 60, column: 3, scope: !93)
!100 = !DILocation(line: 61, column: 10, scope: !96)
!101 = !DILocation(line: 61, column: 7, scope: !96)
!102 = !DILocation(line: 61, column: 5, scope: !96)
!103 = !DILocation(line: 61, column: 9, scope: !96)
!104 = !DILocation(line: 60, column: 21, scope: !96)
!105 = !DILocation(line: 60, column: 3, scope: !96)
!106 = distinct !{!106, !99, !107}
!107 = !DILocation(line: 61, column: 10, scope: !93)
!108 = !DILocation(line: 63, column: 11, scope: !9)
!109 = !DILocation(line: 63, column: 9, scope: !9)
!110 = !DILocation(line: 64, column: 7, scope: !111)
!111 = distinct !DILexicalBlock(scope: !9, file: !1, line: 64, column: 7)
!112 = !DILocation(line: 64, column: 13, scope: !111)
!113 = !DILocation(line: 64, column: 7, scope: !9)
!114 = !DILocation(line: 66, column: 13, scope: !115)
!115 = distinct !DILexicalBlock(scope: !111, file: !1, line: 65, column: 3)
!116 = !DILocation(line: 66, column: 5, scope: !115)
!117 = !DILocation(line: 67, column: 3, scope: !115)
!118 = !DILocation(line: 70, column: 9, scope: !119)
!119 = distinct !DILexicalBlock(scope: !9, file: !1, line: 70, column: 3)
!120 = !DILocation(line: 70, column: 8, scope: !119)
!121 = !DILocation(line: 70, column: 13, scope: !122)
!122 = distinct !DILexicalBlock(scope: !119, file: !1, line: 70, column: 3)
!123 = !DILocation(line: 70, column: 15, scope: !122)
!124 = !DILocation(line: 70, column: 14, scope: !122)
!125 = !DILocation(line: 70, column: 3, scope: !119)
!126 = !DILocation(line: 72, column: 13, scope: !127)
!127 = distinct !DILexicalBlock(scope: !122, file: !1, line: 71, column: 3)
!128 = !DILocation(line: 72, column: 30, scope: !127)
!129 = !DILocation(line: 72, column: 28, scope: !127)
!130 = !DILocation(line: 72, column: 5, scope: !127)
!131 = !DILocation(line: 73, column: 3, scope: !127)
!132 = !DILocation(line: 70, column: 20, scope: !122)
!133 = !DILocation(line: 70, column: 3, scope: !122)
!134 = distinct !{!134, !125, !135}
!135 = !DILocation(line: 73, column: 3, scope: !119)
!136 = !DILocation(line: 75, column: 10, scope: !9)
!137 = !DILocation(line: 75, column: 3, scope: !9)
!138 = !DILocation(line: 76, column: 9, scope: !9)
!139 = !DILocation(line: 76, column: 7, scope: !9)
!140 = !DILocation(line: 77, column: 7, scope: !141)
!141 = distinct !DILexicalBlock(scope: !9, file: !1, line: 77, column: 7)
!142 = !DILocation(line: 77, column: 11, scope: !141)
!143 = !DILocation(line: 77, column: 7, scope: !9)
!144 = !DILocation(line: 79, column: 13, scope: !145)
!145 = distinct !DILexicalBlock(scope: !141, file: !1, line: 78, column: 3)
!146 = !DILocation(line: 79, column: 5, scope: !145)
!147 = !DILocation(line: 80, column: 3, scope: !145)
!148 = !DILocation(line: 81, column: 3, scope: !9)
