simonschmalfuss@gpu-server:~/discopop/swift/CU_comp/reduction/arr_test$ cat reduction.ll 
; ModuleID = 'reduction.ll'
source_filename = "reduction.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%TSa = type <{ %Ts22_ContiguousArrayBufferV }>
%Ts22_ContiguousArrayBufferV = type <{ %Ts28__ContiguousArrayStorageBaseC* }>
%Ts28__ContiguousArrayStorageBaseC = type opaque
%TSi = type <{ i64 }>
%swift.type = type { i64 }

@"$s9reduction3arrSaySiGvp" = hidden global %TSa zeroinitializer, align 8, !dbg !0
@"$s9reduction9testvalueSivp" = hidden global %TSi zeroinitializer, align 8, !dbg !7
@"$sSiN" = external global %swift.type, align 8
@__swift_reflection_version = linkonce_odr hidden constant i16 3
@_swift1_autolink_entries = private constant [37 x i8] c"-lswiftSwiftOnoneSupport\00-lswiftCore\00", section ".swift1_autolink_entries", align 8
@llvm.used = appending global [2 x i8*] [i8* bitcast (i16* @__swift_reflection_version to i8*), i8* getelementptr inbounds ([37 x i8], [37 x i8]* @_swift1_autolink_entries, i32 0, i32 0)], section "llvm.metadata", align 8

define protected i32 @main(i32, i8**) #0 !dbg !28 {
entry:
  %access-scratch = alloca [24 x i8], align 8
  %2 = alloca [32 x i8], align 8
  %access-scratch4 = alloca [24 x i8], align 8
  %access-scratch5 = alloca [24 x i8], align 8
  %3 = alloca [32 x i8], align 8
  %4 = bitcast i8** %1 to i8*
  %5 = call swiftcc { %Ts28__ContiguousArrayStorageBaseC*, i8* } @"$ss27_allocateUninitializedArrayySayxG_BptBwlF"(i64 3, %swift.type* @"$sSiN"), !dbg !33
  %6 = extractvalue { %Ts28__ContiguousArrayStorageBaseC*, i8* } %5, 0, !dbg !33
  %7 = extractvalue { %Ts28__ContiguousArrayStorageBaseC*, i8* } %5, 1, !dbg !33
  %8 = bitcast i8* %7 to %TSi*, !dbg !33
  %._value = getelementptr inbounds %TSi, %TSi* %8, i32 0, i32 0, !dbg !33
  store i64 1, i64* %._value, align 8, !dbg !33
  %9 = getelementptr inbounds %TSi, %TSi* %8, i64 1, !dbg !35
  %._value1 = getelementptr inbounds %TSi, %TSi* %9, i32 0, i32 0, !dbg !35
  store i64 2, i64* %._value1, align 8, !dbg !35
  %10 = getelementptr inbounds %TSi, %TSi* %8, i64 2, !dbg !36
  %._value2 = getelementptr inbounds %TSi, %TSi* %10, i32 0, i32 0, !dbg !36
  store i64 3, i64* %._value2, align 8, !dbg !36
  %11 = call swiftcc %Ts28__ContiguousArrayStorageBaseC* @"$sSa12arrayLiteralSayxGxd_tcfCSi_Tg5"(%Ts28__ContiguousArrayStorageBaseC* %6), !dbg !37
  store %Ts28__ContiguousArrayStorageBaseC* %11, %Ts28__ContiguousArrayStorageBaseC** getelementptr inbounds (%TSa, %TSa* @"$s9reduction3arrSaySiGvp", i32 0, i32 0, i32 0), align 8, !dbg !37
  %12 = bitcast [24 x i8]* %access-scratch to i8*, !dbg !38
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %12), !dbg !38
  call void @swift_beginAccess(i8* bitcast (%TSa* @"$s9reduction3arrSaySiGvp" to i8*), [24 x i8]* %access-scratch, i64 33, i8* null) #3, !dbg !38
  %13 = getelementptr inbounds [32 x i8], [32 x i8]* %2, i32 0, i32 0, !dbg !38 
  call void @llvm.lifetime.start.p0i8(i64 32, i8* %13), !dbg !38

  %14 = call swiftcc { i8*, %TSi* } @"$sSayxSiciMSi_Tg5"(i8* noalias dereferenceable(32) %13, i64 0, %TSa* nocapture swiftself dereferenceable(8) @"$s9reduction3arrSaySiGvp"), !dbg !38
  %15 = extractvalue { i8*, %TSi* } %14, 0, !dbg !38
  %16 = extractvalue { i8*, %TSi* } %14, 1, !dbg !38
  %._value3 = getelementptr inbounds %TSi, %TSi* %16, i32 0, i32 0, !dbg !38
  store i64 0, i64* %._value3, align 8, !dbg !38

  %17 = bitcast i8* %15 to void (i8*, i1)*, !dbg !38
  call swiftcc void %17(i8* noalias dereferenceable(32) %13, i1 false), !dbg !38
  call void @llvm.lifetime.end.p0i8(i64 32, i8* %13), !dbg !38
  call void @swift_endAccess([24 x i8]* %access-scratch) #3, !dbg !38
  %18 = bitcast [24 x i8]* %access-scratch to i8*, !dbg !38
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %18), !dbg !38
  %19 = bitcast [24 x i8]* %access-scratch4 to i8*, !dbg !40
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %19), !dbg !40
  call void @swift_beginAccess(i8* bitcast (%TSa* @"$s9reduction3arrSaySiGvp" to i8*), [24 x i8]* %access-scratch4, i64 32, i8* null) #3, !dbg !40

  ; reading from array here
  %20 = load %Ts28__ContiguousArrayStorageBaseC*, %Ts28__ContiguousArrayStorageBaseC** getelementptr inbounds (%TSa, %TSa* @"$s9reduction3arrSaySiGvp", i32 0, i32 0, i32 0), align 8, !dbg !40
  %21 = call swiftcc i64 @"$sSayxSicigSi_Tg5"(i64 0, %Ts28__ContiguousArrayStorageBaseC* %20), !dbg !40

  store i64 %21, i64* getelementptr inbounds (%TSi, %TSi* @"$s9reduction9testvalueSivp", i32 0, i32 0), align 8, !dbg !40
  call void @swift_endAccess([24 x i8]* %access-scratch4) #3, !dbg !40
  %22 = bitcast [24 x i8]* %access-scratch4 to i8*, !dbg !40
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %22), !dbg !40
  %23 = bitcast [24 x i8]* %access-scratch5 to i8*, !dbg !42
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %23), !dbg !42
  call void @swift_beginAccess(i8* bitcast (%TSa* @"$s9reduction3arrSaySiGvp" to i8*), [24 x i8]* %access-scratch5, i64 33, i8* null) #3, !dbg !42
  %24 = getelementptr inbounds [32 x i8], [32 x i8]* %3, i32 0, i32 0, !dbg !42
  call void @llvm.lifetime.start.p0i8(i64 32, i8* %24), !dbg !42
  %25 = call swiftcc { i8*, %TSi* } @"$sSayxSiciMSi_Tg5"(i8* noalias dereferenceable(32) %24, i64 1, %TSa* nocapture swiftself dereferenceable(8) @"$s9reduction3arrSaySiGvp"), !dbg !42
  %26 = extractvalue { i8*, %TSi* } %25, 0, !dbg !42
  %27 = extractvalue { i8*, %TSi* } %25, 1, !dbg !42
  %._value6 = getelementptr inbounds %TSi, %TSi* %27, i32 0, i32 0, !dbg !42
  store i64 2, i64* %._value6, align 8, !dbg !42
  %28 = bitcast i8* %26 to void (i8*, i1)*, !dbg !42
  call swiftcc void %28(i8* noalias dereferenceable(32) %24, i1 false), !dbg !42
  call void @llvm.lifetime.end.p0i8(i64 32, i8* %24), !dbg !42
  call void @swift_endAccess([24 x i8]* %access-scratch5) #3, !dbg !42
  %29 = bitcast [24 x i8]* %access-scratch5 to i8*, !dbg !42
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %29), !dbg !42
  ret i32 0, !dbg !42
}

declare swiftcc { %Ts28__ContiguousArrayStorageBaseC*, i8* } @"$ss27_allocateUninitializedArrayySayxG_BptBwlF"(i64, %swift.type*) #0

; Function Attrs: cold noreturn nounwind
declare void @llvm.trap() #1

declare swiftcc %Ts28__ContiguousArrayStorageBaseC* @"$sSa12arrayLiteralSayxGxd_tcfCSi_Tg5"(%Ts28__ContiguousArrayStorageBaseC*) #0

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #2

; Function Attrs: nounwind
declare void @swift_beginAccess(i8*, [24 x i8]*, i64, i8*) #3

declare swiftcc { i8*, %TSi* } @"$sSayxSiciMSi_Tg5"(i8* noalias dereferenceable(32), i64, %TSa* nocapture swiftself dereferenceable(8)) #0

; Function Attrs: nounwind readnone
declare i8* @llvm.coro.prepare.retcon(i8*) #4

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #2

; Function Attrs: nounwind
declare void @swift_endAccess([24 x i8]*) #3

declare swiftcc i64 @"$sSayxSicigSi_Tg5"(i64, %Ts28__ContiguousArrayStorageBaseC*) #0

attributes #0 = { "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" }
attributes #1 = { cold noreturn nounwind }
attributes #2 = { argmemonly nounwind }
attributes #3 = { nounwind }
attributes #4 = { nounwind readnone }

!llvm.dbg.cu = !{!11, !18}
!swift.module.flags = !{!20}
!llvm.linker.options = !{}
!llvm.module.flags = !{!21, !22, !23, !24, !25, !26}
!llvm.asan.globals = !{!27}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "arr", linkageName: "$s9reduction3arrSaySiGvp", scope: !2, file: !3, line: 1, type: !4, isLocal: false, isDefinition: true)
!2 = !DIModule(scope: null, name: "reduction")
!3 = !DIFile(filename: "reduction.swift", directory: "/home/simonschmalfuss/discopop/swift/CU_comp/reduction/arr_test")
!4 = !DICompositeType(tag: DW_TAG_structure_type, name: "Array", scope: !5, file: !3, size: 64, elements: !6, runtimeLang: DW_LANG_Swift, identifier: "$sSaySiGD")
!5 = !DIModule(scope: null, name: "Swift", includePath: "/home/simonschmalfuss/swift-5.1/swift-5.1.5-RELEASE-ubuntu18.04/usr/lib/swift/linux/x86_64/Swift.swiftmodule")
!6 = !{}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "testvalue", linkageName: "$s9reduction9testvalueSivp", scope: !2, file: !3, line: 4, type: !9, isLocal: false, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_structure_type, name: "Int", scope: !5, file: !10, size: 64, elements: !6, runtimeLang: DW_LANG_Swift, identifier: "$sSiD")
!10 = !DIFile(filename: "swift-5.1/swift-5.1.5-RELEASE-ubuntu18.04/usr/lib/swift/linux/x86_64/Swift.swiftmodule", directory: "/home/simonschmalfuss")
!11 = distinct !DICompileUnit(language: DW_LANG_Swift, file: !3, producer: "Swift version 5.1.5 (swift-5.1.5-RELEASE)", isOptimized: false, runtimeVersion: 5, emissionKind: FullDebug, enums: !6, globals: !12, imports: !13)
!12 = !{!0, !7}
!13 = !{!14, !15, !16}
!14 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !3, entity: !2, file: !3)
!15 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !3, entity: !5, file: !3)
!16 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !3, entity: !17, file: !3)
!17 = !DIModule(scope: null, name: "SwiftOnoneSupport", includePath: "/home/simonschmalfuss/swift-5.1/swift-5.1.5-RELEASE-ubuntu18.04/usr/lib/swift/linux/x86_64/SwiftOnoneSupport.swiftmodule")
!18 = distinct !DICompileUnit(language: DW_LANG_C99, file: !19, producer: "clang version 7.0.0 ", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !6, nameTableKind: None)
!19 = !DIFile(filename: "<swift-imported-modules>", directory: "/home/simonschmalfuss/discopop/swift/CU_comp/reduction/arr_test")
!20 = !{!"standard-library", i1 false}
!21 = !{i32 2, !"Dwarf Version", i32 4}
!22 = !{i32 2, !"Debug Info Version", i32 3}
!23 = !{i32 1, !"wchar_size", i32 4}
!24 = !{i32 7, !"PIC Level", i32 2}
!25 = !{i32 4, !"Objective-C Garbage Collection", i32 83953408}
!26 = !{i32 1, !"Swift Version", i32 7}
!27 = !{[2 x i8*]* @llvm.used, null, null, i1 false, i1 true}
!28 = distinct !DISubprogram(name: "main", linkageName: "main", scope: !2, file: !3, line: 1, type: !29, spFlags: DISPFlagDefinition, unit: !11, retainedNodes: !6)
!29 = !DISubroutineType(types: !30)
!30 = !{!31, !31, !32}
!31 = !DICompositeType(tag: DW_TAG_structure_type, name: "Int32", scope: !5, file: !10, size: 32, elements: !6, runtimeLang: DW_LANG_Swift, identifier: "$ss5Int32VD")
!32 = !DICompositeType(tag: DW_TAG_structure_type, name: "UnsafeMutablePointer", scope: !5, file: !3, size: 64, elements: !6, runtimeLang: DW_LANG_Swift, identifier: "$sSpySpys4Int8VGSgGD")
!33 = !DILocation(line: 1, column: 12, scope: !34)
!34 = distinct !DILexicalBlock(scope: !28, file: !3, line: 1, column: 1)
!35 = !DILocation(line: 1, column: 15, scope: !34)
!36 = !DILocation(line: 1, column: 18, scope: !34)
!37 = !DILocation(line: 1, column: 11, scope: !34)
!38 = !DILocation(line: 3, column: 8, scope: !39)
!39 = distinct !DILexicalBlock(scope: !28, file: !3, line: 3, column: 1)
!40 = !DILocation(line: 4, column: 20, scope: !41)
!41 = distinct !DILexicalBlock(scope: !28, file: !3, line: 4, column: 1)
!42 = !DILocation(line: 6, column: 8, scope: !43)
!43 = distinct !DILexicalBlock(scope: !28, file: !3, line: 6, column: 1)




simonschmalfuss@gpu-server:~/discopop/swift/CU_comp/reduction/arr_test$ cat instrumented.ll 
; ModuleID = 'instrumented_reduction.ll'
source_filename = "reduction.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%TSa = type <{ %Ts22_ContiguousArrayBufferV }>
%Ts22_ContiguousArrayBufferV = type <{ %Ts28__ContiguousArrayStorageBaseC* }>
%Ts28__ContiguousArrayStorageBaseC = type opaque
%TSi = type <{ i64 }>
%swift.type = type { i64 }

@"$s9reduction3arrSaySiGvp" = hidden global %TSa zeroinitializer, align 8, !dbg !0
@"$s9reduction9testvalueSivp" = hidden global %TSi zeroinitializer, align 8, !dbg !7
@"$sSiN" = external global %swift.type, align 8
@__swift_reflection_version = linkonce_odr hidden constant i16 3
@_swift1_autolink_entries = private constant [37 x i8] c"-lswiftSwiftOnoneSupport\00-lswiftCore\00", section ".swift1_autolink_entries", align 8
@llvm.used = appending global [2 x i8*] [i8* bitcast (i16* @__swift_reflection_version to i8*), i8* getelementptr inbounds ([37 x i8], [37 x i8]* @_swift1_autolink_entries, i32 0, i32 0)], section "llvm.metadata", align 8
@.str = private unnamed_addr constant [2 x i8] c"*\00", align 1
@.str.1 = private unnamed_addr constant [25 x i8] c"$s9reduction3arrSaySiGvp\00", align 1

declare void @__dp_func_entry(i32, i32)

define protected i32 @main(i32, i8**) #0 !dbg !28 {
entry:
  call void @__dp_func_entry(i32 16385, i32 1)
  %access-scratch = alloca [24 x i8], align 8
  %2 = alloca [32 x i8], align 8
  %access-scratch4 = alloca [24 x i8], align 8
  %access-scratch5 = alloca [24 x i8], align 8
  %3 = alloca [32 x i8], align 8
  %4 = bitcast i8** %1 to i8*
  call void @__dp_call(i32 16385), !dbg !33
  %5 = call swiftcc { %Ts28__ContiguousArrayStorageBaseC*, i8* } @"$ss27_allocateUninitializedArrayySayxG_BptBwlF"(i64 3, %swift.type* @"$sSiN"), !dbg !33
  %6 = extractvalue { %Ts28__ContiguousArrayStorageBaseC*, i8* } %5, 0, !dbg !33
  %7 = extractvalue { %Ts28__ContiguousArrayStorageBaseC*, i8* } %5, 1, !dbg !33
  %8 = bitcast i8* %7 to %TSi*, !dbg !33
  %._value = getelementptr inbounds %TSi, %TSi* %8, i32 0, i32 0, !dbg !33
  %9 = ptrtoint i64* %._value to i64
  call void @__dp_write(i32 16385, i64 %9, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i64 1, i64* %._value, align 8, !dbg !33
  %10 = getelementptr inbounds %TSi, %TSi* %8, i64 1, !dbg !35
  %._value1 = getelementptr inbounds %TSi, %TSi* %10, i32 0, i32 0, !dbg !35
  %11 = ptrtoint i64* %._value1 to i64
  call void @__dp_write(i32 16385, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i64 2, i64* %._value1, align 8, !dbg !35
  %12 = getelementptr inbounds %TSi, %TSi* %8, i64 2, !dbg !36
  %._value2 = getelementptr inbounds %TSi, %TSi* %12, i32 0, i32 0, !dbg !36
  %13 = ptrtoint i64* %._value2 to i64
  call void @__dp_write(i32 16385, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i64 3, i64* %._value2, align 8, !dbg !36
  call void @__dp_call(i32 16385), !dbg !37
  %14 = call swiftcc %Ts28__ContiguousArrayStorageBaseC* @"$sSa12arrayLiteralSayxGxd_tcfCSi_Tg5"(%Ts28__ContiguousArrayStorageBaseC* %6), !dbg !37
  %15 = ptrtoint %Ts28__ContiguousArrayStorageBaseC** getelementptr inbounds (%TSa, %TSa* @"$s9reduction3arrSaySiGvp", i32 0, i32 0, i32 0) to i64
  call void @__dp_write(i32 16385, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store %Ts28__ContiguousArrayStorageBaseC* %14, %Ts28__ContiguousArrayStorageBaseC** getelementptr inbounds (%TSa, %TSa* @"$s9reduction3arrSaySiGvp", i32 0, i32 0, i32 0), align 8, !dbg !37
  %16 = bitcast [24 x i8]* %access-scratch to i8*, !dbg !38
  call void @__dp_call(i32 16387), !dbg !38
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %16), !dbg !38
  call void @__dp_call(i32 16387), !dbg !38
  call void @swift_beginAccess(i8* bitcast (%TSa* @"$s9reduction3arrSaySiGvp" to i8*), [24 x i8]* %access-scratch, i64 33, i8* null) #3, !dbg !38
  %17 = getelementptr inbounds [32 x i8], [32 x i8]* %2, i32 0, i32 0, !dbg !38
  call void @__dp_call(i32 16387), !dbg !38
  call void @llvm.lifetime.start.p0i8(i64 32, i8* %17), !dbg !38
  call void @__dp_call(i32 16387), !dbg !38

  %18 = call swiftcc { i8*, %TSi* } @"$sSayxSiciMSi_Tg5"(i8* noalias dereferenceable(32) %17, i64 0, %TSa* nocapture swiftself dereferenceable(8) @"$s9reduction3arrSaySiGvp"), !dbg !38
  %19 = extractvalue { i8*, %TSi* } %18, 0, !dbg !38
  %20 = extractvalue { i8*, %TSi* } %18, 1, !dbg !38
  %._value3 = getelementptr inbounds %TSi, %TSi* %20, i32 0, i32 0, !dbg !38
  %21 = ptrtoint i64* %._value3 to i64
  call void @__dp_write(i32 16387, i64 %21, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str.1, i32 0, i32 0))

  store i64 0, i64* %._value3, align 8, !dbg !38
  %22 = bitcast i8* %19 to void (i8*, i1)*, !dbg !38
  call void @__dp_call(i32 16387), !dbg !38
  call swiftcc void %22(i8* noalias dereferenceable(32) %17, i1 false), !dbg !38
  call void @__dp_call(i32 16387), !dbg !38
  call void @llvm.lifetime.end.p0i8(i64 32, i8* %17), !dbg !38
  call void @__dp_call(i32 16387), !dbg !38
  call void @swift_endAccess([24 x i8]* %access-scratch) #3, !dbg !38
  %23 = bitcast [24 x i8]* %access-scratch to i8*, !dbg !38
  call void @__dp_call(i32 16387), !dbg !38
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %23), !dbg !38
  %24 = bitcast [24 x i8]* %access-scratch4 to i8*, !dbg !40
  call void @__dp_call(i32 16388), !dbg !40
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %24), !dbg !40
  call void @__dp_call(i32 16388), !dbg !40
  call void @swift_beginAccess(i8* bitcast (%TSa* @"$s9reduction3arrSaySiGvp" to i8*), [24 x i8]* %access-scratch4, i64 32, i8* null) #3, !dbg !40

  %25 = ptrtoint %Ts28__ContiguousArrayStorageBaseC** getelementptr inbounds (%TSa, %TSa* @"$s9reduction3arrSaySiGvp", i32 0, i32 0, i32 0) to i64

  call void @__dp_read(i32 16388, i64 %25, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %26 = load %Ts28__ContiguousArrayStorageBaseC*, %Ts28__ContiguousArrayStorageBaseC** getelementptr inbounds (%TSa, %TSa* @"$s9reduction3arrSaySiGvp", i32 0, i32 0, i32 0), align 8, !dbg !40
  %27 = ptrtoint %Ts28__ContiguousArrayStorageBaseC* %26 to i64
  %idxadd = add i64 0, %27
  call void @__dp_read(i32 16388, i64 %idxadd, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str.1, i32 0, i32 0))

  call void @__dp_call(i32 16388), !dbg !40
  %28 = call swiftcc i64 @"$sSayxSicigSi_Tg5"(i64 0, %Ts28__ContiguousArrayStorageBaseC* %26), !dbg !40


  %29 = ptrtoint i64* getelementptr inbounds (%TSi, %TSi* @"$s9reduction9testvalueSivp", i32 0, i32 0) to i64
  call void @__dp_write(i32 16388, i64 %29, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i64 %28, i64* getelementptr inbounds (%TSi, %TSi* @"$s9reduction9testvalueSivp", i32 0, i32 0), align 8, !dbg !40
  call void @__dp_call(i32 16388), !dbg !40
  call void @swift_endAccess([24 x i8]* %access-scratch4) #3, !dbg !40
  %30 = bitcast [24 x i8]* %access-scratch4 to i8*, !dbg !40
  call void @__dp_call(i32 16388), !dbg !40
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %30), !dbg !40
  %31 = bitcast [24 x i8]* %access-scratch5 to i8*, !dbg !42
  call void @__dp_call(i32 16390), !dbg !42
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %31), !dbg !42
  call void @__dp_call(i32 16390), !dbg !42
  call void @swift_beginAccess(i8* bitcast (%TSa* @"$s9reduction3arrSaySiGvp" to i8*), [24 x i8]* %access-scratch5, i64 33, i8* null) #3, !dbg !42
  %32 = getelementptr inbounds [32 x i8], [32 x i8]* %3, i32 0, i32 0, !dbg !42
  call void @__dp_call(i32 16390), !dbg !42
  call void @llvm.lifetime.start.p0i8(i64 32, i8* %32), !dbg !42
  call void @__dp_call(i32 16390), !dbg !42
  %33 = call swiftcc { i8*, %TSi* } @"$sSayxSiciMSi_Tg5"(i8* noalias dereferenceable(32) %32, i64 1, %TSa* nocapture swiftself dereferenceable(8) @"$s9reduction3arrSaySiGvp"), !dbg !42
  %34 = extractvalue { i8*, %TSi* } %33, 0, !dbg !42
  %35 = extractvalue { i8*, %TSi* } %33, 1, !dbg !42
  %._value6 = getelementptr inbounds %TSi, %TSi* %35, i32 0, i32 0, !dbg !42
  %36 = ptrtoint i64* %._value6 to i64
  call void @__dp_write(i32 16390, i64 %36, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str.1, i32 0, i32 0))
  store i64 2, i64* %._value6, align 8, !dbg !42
  %37 = bitcast i8* %34 to void (i8*, i1)*, !dbg !42
  call void @__dp_call(i32 16390), !dbg !42
  call swiftcc void %37(i8* noalias dereferenceable(32) %32, i1 false), !dbg !42
  call void @__dp_call(i32 16390), !dbg !42
  call void @llvm.lifetime.end.p0i8(i64 32, i8* %32), !dbg !42
  call void @__dp_call(i32 16390), !dbg !42
  call void @swift_endAccess([24 x i8]* %access-scratch5) #3, !dbg !42
  %38 = bitcast [24 x i8]* %access-scratch5 to i8*, !dbg !42
  call void @__dp_call(i32 16390), !dbg !42
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %38), !dbg !42
  call void @__dp_finalize(i32 16390), !dbg !42
  ret i32 0, !dbg !42
}

declare swiftcc { %Ts28__ContiguousArrayStorageBaseC*, i8* } @"$ss27_allocateUninitializedArrayySayxG_BptBwlF"(i64, %swift.type*) #0

; Function Attrs: cold noreturn nounwind
declare void @llvm.trap() #1

declare swiftcc %Ts28__ContiguousArrayStorageBaseC* @"$sSa12arrayLiteralSayxGxd_tcfCSi_Tg5"(%Ts28__ContiguousArrayStorageBaseC*) #0

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #2

; Function Attrs: nounwind
declare void @swift_beginAccess(i8*, [24 x i8]*, i64, i8*) #3

declare swiftcc { i8*, %TSi* } @"$sSayxSiciMSi_Tg5"(i8* noalias dereferenceable(32), i64, %TSa* nocapture swiftself dereferenceable(8)) #0

; Function Attrs: nounwind readnone
declare i8* @llvm.coro.prepare.retcon(i8*) #4

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #2

; Function Attrs: nounwind
declare void @swift_endAccess([24 x i8]*) #3

declare swiftcc i64 @"$sSayxSicigSi_Tg5"(i64, %Ts28__ContiguousArrayStorageBaseC*) #0

declare void @__dp_init(i32, i32, i32)

declare void @__dp_finalize(i32)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_write(i32, i64, i8*)

declare void @__dp_call(i32)



declare void @__dp_func_exit(i32, i32)

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_loop_exit(i32, i32)

attributes #0 = { "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" }
attributes #1 = { cold noreturn nounwind }
attributes #2 = { argmemonly nounwind }
attributes #3 = { nounwind }
attributes #4 = { nounwind readnone }

!llvm.dbg.cu = !{!11, !18}
!swift.module.flags = !{!20}
!llvm.linker.options = !{}
!llvm.module.flags = !{!21, !22, !23, !24, !25, !26}
!llvm.asan.globals = !{!27}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "arr", linkageName: "$s9reduction3arrSaySiGvp", scope: !2, file: !3, line: 1, type: !4, isLocal: false, isDefinition: true)
!2 = !DIModule(scope: null, name: "reduction")
!3 = !DIFile(filename: "reduction.swift", directory: "/home/simonschmalfuss/discopop/swift/CU_comp/reduction/arr_test")
!4 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Array", scope: !5, file: !3, size: 64, elements: !6, runtimeLang: DW_LANG_Swift, identifier: "$sSaySiGD")
!5 = !DIModule(scope: null, name: "Swift", includePath: "/home/simonschmalfuss/swift-5.1/swift-5.1.5-RELEASE-ubuntu18.04/usr/lib/swift/linux/x86_64/Swift.swiftmodule")
!6 = !{}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "testvalue", linkageName: "$s9reduction9testvalueSivp", scope: !2, file: !3, line: 4, type: !9, isLocal: false, isDefinition: true)
!9 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Int", scope: !5, file: !10, size: 64, elements: !6, runtimeLang: DW_LANG_Swift, identifier: "$sSiD")
!10 = !DIFile(filename: "swift-5.1/swift-5.1.5-RELEASE-ubuntu18.04/usr/lib/swift/linux/x86_64/Swift.swiftmodule", directory: "/home/simonschmalfuss")
!11 = distinct !DICompileUnit(language: DW_LANG_Swift, file: !3, producer: "Swift version 5.1.5 (swift-5.1.5-RELEASE)", isOptimized: false, runtimeVersion: 5, emissionKind: FullDebug, enums: !6, globals: !12, imports: !13)
!12 = !{!0, !7}
!13 = !{!14, !15, !16}
!14 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !3, entity: !2, file: !3)
!15 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !3, entity: !5, file: !3)
!16 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !3, entity: !17, file: !3)
!17 = !DIModule(scope: null, name: "SwiftOnoneSupport", includePath: "/home/simonschmalfuss/swift-5.1/swift-5.1.5-RELEASE-ubuntu18.04/usr/lib/swift/linux/x86_64/SwiftOnoneSupport.swiftmodule")
!18 = distinct !DICompileUnit(language: DW_LANG_C99, file: !19, producer: "clang version 7.0.0 ", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !6, nameTableKind: None)
!19 = !DIFile(filename: "<swift-imported-modules>", directory: "/home/simonschmalfuss/discopop/swift/CU_comp/reduction/arr_test")
!20 = !{!"standard-library", i1 false}
!21 = !{i32 2, !"Dwarf Version", i32 4}
!22 = !{i32 2, !"Debug Info Version", i32 3}
!23 = !{i32 1, !"wchar_size", i32 4}
!24 = !{i32 7, !"PIC Level", i32 2}
!25 = !{i32 4, !"Objective-C Garbage Collection", i32 83953408}
!26 = !{i32 1, !"Swift Version", i32 7}
!27 = !{[2 x i8*]* @llvm.used, null, null, i1 false, i1 true}
!28 = distinct !DISubprogram(name: "main", linkageName: "main", scope: !2, file: !3, line: 1, type: !29, spFlags: DISPFlagDefinition, unit: !11, retainedNodes: !6)
!29 = !DISubroutineType(types: !30)
!30 = !{!31, !31, !32}
!31 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Int32", scope: !5, file: !10, size: 32, elements: !6, runtimeLang: DW_LANG_Swift, identifier: "$ss5Int32VD")
!32 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "UnsafeMutablePointer", scope: !5, file: !3, size: 64, elements: !6, runtimeLang: DW_LANG_Swift, identifier: "$sSpySpys4Int8VGSgGD")
!33 = !DILocation(line: 1, column: 12, scope: !34)
!34 = distinct !DILexicalBlock(scope: !28, file: !3, line: 1, column: 1)
!35 = !DILocation(line: 1, column: 15, scope: !34)
!36 = !DILocation(line: 1, column: 18, scope: !34)
!37 = !DILocation(line: 1, column: 11, scope: !34)
!38 = !DILocation(line: 3, column: 8, scope: !39)
!39 = distinct !DILexicalBlock(scope: !28, file: !3, line: 3, column: 1)
!40 = !DILocation(line: 4, column: 20, scope: !41)
!41 = distinct !DILexicalBlock(scope: !28, file: !3, line: 4, column: 1)
!42 = !DILocation(line: 6, column: 8, scope: !43)
!43 = distinct !DILexicalBlock(scope: !28, file: !3, line: 6, column: 1)
simonschmalfuss@gpu-server:~/discopop/swift/CU_comp/reduction/arr_test$ 



; ModuleID = 'instrumented_reduction.ll'
source_filename = "reduction.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%TSa = type <{ %Ts22_ContiguousArrayBufferV }>
%Ts22_ContiguousArrayBufferV = type <{ %Ts28__ContiguousArrayStorageBaseC* }>
%Ts28__ContiguousArrayStorageBaseC = type opaque
%TSi = type <{ i64 }>
%swift.type = type { i64 }

 
@"$s9reduction3arrSaySiGvp" = hidden global %TSa zeroinitializer, align 8, !dbg !0
@"$s9reduction9testvalueSivp" = hidden global %TSi zeroinitializer, align 8, !dbg !7
@"$sSiN" = external global %swift.type, align 8
@__swift_reflection_version = linkonce_odr hidden constant i16 3
@_swift1_autolink_entries = private constant [37 x i8] c"-lswiftSwiftOnoneSupport\00-lswiftCore\00", section ".swift1_autolink_entries", align 8
@llvm.used = appending global [2 x i8*] [i8* bitcast (i16* @__swift_reflection_version to i8*), i8* getelementptr inbounds ([37 x i8], [37 x i8]* @_swift1_autolink_entries, i32 0, i32 0)], section "llvm.metadata", align 8
@.str = private unnamed_addr constant [2 x i8] c"*\00", align 1
@.str.1 = private unnamed_addr constant [25 x i8] c"$s9reduction3arrSaySiGvp\00", align 1
@.str.2 = private unnamed_addr constant [10 x i8] c"testvalue\00", align 1



define protected i32 @main(i32, i8**) #0 !dbg !28 {
entry:
  call void @__dp_func_entry(i32 16385, i32 1)
  %access-scratch = alloca [24 x i8], align 8
  %2 = alloca [32 x i8], align 8
  %access-scratch4 = alloca [24 x i8], align 8
  %access-scratch5 = alloca [24 x i8], align 8
  %3 = alloca [32 x i8], align 8
  %4 = bitcast i8** %1 to i8*
  call void @__dp_call(i32 16385), !dbg !33
  %5 = call swiftcc { %Ts28__ContiguousArrayStorageBaseC*, i8* } @"$ss27_allocateUninitializedArrayySayxG_BptBwlF"(i64 3, %swift.type* @"$sSiN"), !dbg !33
  %6 = extractvalue { %Ts28__ContiguousArrayStorageBaseC*, i8* } %5, 0, !dbg !33
  %7 = extractvalue { %Ts28__ContiguousArrayStorageBaseC*, i8* } %5, 1, !dbg !33
  %8 = bitcast i8* %7 to %TSi*, !dbg !33
  %._value = getelementptr inbounds %TSi, %TSi* %8, i32 0, i32 0, !dbg !33
  %9 = ptrtoint i64* %._value to i64
  call void @__dp_write(i32 16385, i64 %9, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str.1, i32 0, i32 0))
  store i64 1, i64* %._value, align 8, !dbg !33
  %10 = getelementptr inbounds %TSi, %TSi* %8, i64 1, !dbg !35
  %._value1 = getelementptr inbounds %TSi, %TSi* %10, i32 0, i32 0, !dbg !35
  %11 = ptrtoint i64* %._value1 to i64
  call void @__dp_write(i32 16385, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i64 2, i64* %._value1, align 8, !dbg !35
  %12 = getelementptr inbounds %TSi, %TSi* %8, i64 2, !dbg !36
  %._value2 = getelementptr inbounds %TSi, %TSi* %12, i32 0, i32 0, !dbg !36
  %13 = ptrtoint i64* %._value2 to i64
  call void @__dp_write(i32 16385, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i64 3, i64* %._value2, align 8, !dbg !36
  call void @__dp_call(i32 16385), !dbg !37
  %14 = call swiftcc %Ts28__ContiguousArrayStorageBaseC* @"$sSa12arrayLiteralSayxGxd_tcfCSi_Tg5"(%Ts28__ContiguousArrayStorageBaseC* %6), !dbg !37
  %15 = ptrtoint %Ts28__ContiguousArrayStorageBaseC** getelementptr inbounds (%TSa, %TSa* @"$s9reduction3arrSaySiGvp", i32 0, i32 0, i32 0) to i64
  call void @__dp_write(i32 16385, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store %Ts28__ContiguousArrayStorageBaseC* %14, %Ts28__ContiguousArrayStorageBaseC** getelementptr inbounds (%TSa, %TSa* @"$s9reduction3arrSaySiGvp", i32 0, i32 0, i32 0), align 8, !dbg !37
  %16 = bitcast [24 x i8]* %access-scratch to i8*, !dbg !38
  call void @__dp_call(i32 16387), !dbg !38
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %16), !dbg !38
  call void @__dp_call(i32 16387), !dbg !38
  call void @swift_beginAccess(i8* bitcast (%TSa* @"$s9reduction3arrSaySiGvp" to i8*), [24 x i8]* %access-scratch, i64 33, i8* null) #3, !dbg !38
  %17 = getelementptr inbounds [32 x i8], [32 x i8]* %2, i32 0, i32 0, !dbg !38
  call void @__dp_call(i32 16387), !dbg !38
  call void @llvm.lifetime.start.p0i8(i64 32, i8* %17), !dbg !38
  call void @__dp_call(i32 16387), !dbg !38
  %18 = call swiftcc { i8*, %TSi* } @"$sSayxSiciMSi_Tg5"(i8* noalias dereferenceable(32) %17, i64 0, %TSa* nocapture swiftself dereferenceable(8) @"$s9reduction3arrSaySiGvp"), !dbg !38
  %19 = extractvalue { i8*, %TSi* } %18, 0, !dbg !38
  %20 = extractvalue { i8*, %TSi* } %18, 1, !dbg !38
  %._value3 = getelementptr inbounds %TSi, %TSi* %20, i32 0, i32 0, !dbg !38
  %21 = ptrtoint i64* %._value3 to i64
  call void @__dp_write(i32 16387, i64 %21, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str.1, i32 0, i32 0))
  store i64 0, i64* %._value3, align 8, !dbg !38
  %22 = bitcast i8* %19 to void (i8*, i1)*, !dbg !38
  call void @__dp_call(i32 16387), !dbg !38
  call swiftcc void %22(i8* noalias dereferenceable(32) %17, i1 false), !dbg !38
  call void @__dp_call(i32 16387), !dbg !38
  call void @llvm.lifetime.end.p0i8(i64 32, i8* %17), !dbg !38
  call void @__dp_call(i32 16387), !dbg !38
  call void @swift_endAccess([24 x i8]* %access-scratch) #3, !dbg !38
  %23 = bitcast [24 x i8]* %access-scratch to i8*, !dbg !38
  call void @__dp_call(i32 16387), !dbg !38
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %23), !dbg !38
  %24 = bitcast [24 x i8]* %access-scratch4 to i8*, !dbg !40
  call void @__dp_call(i32 16388), !dbg !40
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %24), !dbg !40
  call void @__dp_call(i32 16388), !dbg !40
  call void @swift_beginAccess(i8* bitcast (%TSa* @"$s9reduction3arrSaySiGvp" to i8*), [24 x i8]* %access-scratch4, i64 32, i8* null) #3, !dbg !40


  ; reading from array
  %25 = ptrtoint %Ts28__ContiguousArrayStorageBaseC** getelementptr inbounds (%TSa, %TSa* @"$s9reduction3arrSaySiGvp", i32 0, i32 0, i32 0) to i64
  call void @__dp_read(i32 16388, i64 %25, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))

  ;reading from array
  %26 = load %Ts28__ContiguousArrayStorageBaseC*, %Ts28__ContiguousArrayStorageBaseC** getelementptr inbounds (%TSa, %TSa* @"$s9reduction3arrSaySiGvp", i32 0, i32 0, i32 0), align 8, !dbg !40
  

  %addb = call swiftcc { i8*, %TSi* } @"$sSayxSiciMSi_Tg5"(i8* noalias dereferenceable(32) %17, i64 0, %TSa* @"$s9reduction3arrSaySiGvp")
  ;  %addb = call swiftcc { i8*, %TSi* } @"$sSayxSiciMSi_Tg5"(i8* noalias dereferenceable(32) %17, i64 0, %TSa* nocapture swiftself dereferenceable(8) @"$s9reduction3arrSaySiGvp")

  %unpacked = extractvalue { i8*, %TSi* } %addb, 1
  %27 = ptrtoint %TSi* %unpacked to i64


  call void @__dp_read(i32 16388, i64 %27, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str.1, i32 0, i32 0))
  
  call void @__dp_call(i32 16388), !dbg !40
  %28 = call swiftcc i64 @"$sSayxSicigSi_Tg5"(i64 0, %Ts28__ContiguousArrayStorageBaseC* %26), !dbg !40


  %29 = ptrtoint i64* getelementptr inbounds (%TSi, %TSi* @"$s9reduction9testvalueSivp", i32 0, i32 0) to i64
  call void @__dp_write(i32 16388, i64 %29, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.2, i32 0, i32 0))
  store i64 %28, i64* getelementptr inbounds (%TSi, %TSi* @"$s9reduction9testvalueSivp", i32 0, i32 0), align 8, !dbg !40
  call void @__dp_call(i32 16388), !dbg !40
  call void @swift_endAccess([24 x i8]* %access-scratch4) #3, !dbg !40
  %30 = bitcast [24 x i8]* %access-scratch4 to i8*, !dbg !40
  call void @__dp_call(i32 16388), !dbg !40
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %30), !dbg !40
  %31 = bitcast [24 x i8]* %access-scratch5 to i8*, !dbg !42
  call void @__dp_call(i32 16390), !dbg !42
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %31), !dbg !42
  call void @__dp_call(i32 16390), !dbg !42
  call void @swift_beginAccess(i8* bitcast (%TSa* @"$s9reduction3arrSaySiGvp" to i8*), [24 x i8]* %access-scratch5, i64 33, i8* null) #3, !dbg !42
  %32 = getelementptr inbounds [32 x i8], [32 x i8]* %3, i32 0, i32 0, !dbg !42
  call void @__dp_call(i32 16390), !dbg !42
  call void @llvm.lifetime.start.p0i8(i64 32, i8* %32), !dbg !42
  call void @__dp_call(i32 16390), !dbg !42


  ; writing to array
  %33 = call swiftcc { i8*, %TSi* } @"$sSayxSiciMSi_Tg5"(i8* noalias dereferenceable(32) %32, i64 1, %TSa* nocapture swiftself dereferenceable(8) @"$s9reduction3arrSaySiGvp"), !dbg !42
  %34 = extractvalue { i8*, %TSi* } %33, 0, !dbg !42
  %35 = extractvalue { i8*, %TSi* } %33, 1, !dbg !42
  %._value6 = getelementptr inbounds %TSi, %TSi* %35, i32 0, i32 0, !dbg !42
  %36 = ptrtoint i64* %._value6 to i64
  call void @__dp_write(i32 16390, i64 %36, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str.1, i32 0, i32 0))

  store i64 2, i64* %._value6, align 8, !dbg !42

  %37 = bitcast i8* %34 to void (i8*, i1)*, !dbg !42
  call void @__dp_call(i32 16390), !dbg !42
  call swiftcc void %37(i8* noalias dereferenceable(32) %32, i1 false), !dbg !42
  call void @__dp_call(i32 16390), !dbg !42
  call void @llvm.lifetime.end.p0i8(i64 32, i8* %32), !dbg !42
  call void @__dp_call(i32 16390), !dbg !42
  call void @swift_endAccess([24 x i8]* %access-scratch5) #3, !dbg !42
  %38 = bitcast [24 x i8]* %access-scratch5 to i8*, !dbg !42
  call void @__dp_call(i32 16390), !dbg !42
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %38), !dbg !42
  call void @__dp_finalize(i32 16390), !dbg !42
  ret i32 0, !dbg !42
}

declare swiftcc { %Ts28__ContiguousArrayStorageBaseC*, i8* } @"$ss27_allocateUninitializedArrayySayxG_BptBwlF"(i64, %swift.type*) #0

; Function Attrs: cold noreturn nounwind
declare void @llvm.trap() #1

declare swiftcc %Ts28__ContiguousArrayStorageBaseC* @"$sSa12arrayLiteralSayxGxd_tcfCSi_Tg5"(%Ts28__ContiguousArrayStorageBaseC*) #0

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #2

; Function Attrs: nounwind
declare void @swift_beginAccess(i8*, [24 x i8]*, i64, i8*) #3

declare swiftcc { i8*, %TSi* } @"$sSayxSiciMSi_Tg5"(i8* noalias dereferenceable(32), i64, %TSa* nocapture swiftself dereferenceable(8)) #0

; Function Attrs: nounwind readnone
declare i8* @llvm.coro.prepare.retcon(i8*) #4

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #2

; Function Attrs: nounwind
declare void @swift_endAccess([24 x i8]*) #3

declare swiftcc i64 @"$sSayxSicigSi_Tg5"(i64, %Ts28__ContiguousArrayStorageBaseC*) #0

declare void @__dp_init(i32, i32, i32)

declare void @__dp_finalize(i32)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_write(i32, i64, i8*)

declare void @__dp_call(i32)

declare void @__dp_func_entry(i32, i32)

declare void @__dp_func_exit(i32, i32)

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_loop_exit(i32, i32)

attributes #0 = { "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" }
attributes #1 = { cold noreturn nounwind }
attributes #2 = { argmemonly nounwind }
attributes #3 = { nounwind }
attributes #4 = { nounwind readnone }

!llvm.dbg.cu = !{!11, !18}
!swift.module.flags = !{!20}
!llvm.linker.options = !{}
!llvm.module.flags = !{!21, !22, !23, !24, !25, !26}
!llvm.asan.globals = !{!27}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "arr", linkageName: "$s9reduction3arrSaySiGvp", scope: !2, file: !3, line: 1, type: !4, isLocal: false, isDefinition: true)
!2 = !DIModule(scope: null, name: "reduction")
!3 = !DIFile(filename: "reduction.swift", directory: "/home/simonschmalfuss/discopop/swift/CU_comp/reduction/arr_test")
!4 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Array", scope: !5, file: !3, size: 64, elements: !6, runtimeLang: DW_LANG_Swift, identifier: "$sSaySiGD")
!5 = !DIModule(scope: null, name: "Swift", includePath: "/home/simonschmalfuss/swift-5.1/swift-5.1.5-RELEASE-ubuntu18.04/usr/lib/swift/linux/x86_64/Swift.swiftmodule")
!6 = !{}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "testvalue", linkageName: "$s9reduction9testvalueSivp", scope: !2, file: !3, line: 4, type: !9, isLocal: false, isDefinition: true)
!9 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Int", scope: !5, file: !10, size: 64, elements: !6, runtimeLang: DW_LANG_Swift, identifier: "$sSiD")
!10 = !DIFile(filename: "swift-5.1/swift-5.1.5-RELEASE-ubuntu18.04/usr/lib/swift/linux/x86_64/Swift.swiftmodule", directory: "/home/simonschmalfuss")
!11 = distinct !DICompileUnit(language: DW_LANG_Swift, file: !3, producer: "Swift version 5.1.5 (swift-5.1.5-RELEASE)", isOptimized: false, runtimeVersion: 5, emissionKind: FullDebug, enums: !6, globals: !12, imports: !13)
!12 = !{!0, !7}
!13 = !{!14, !15, !16}
!14 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !3, entity: !2, file: !3)
!15 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !3, entity: !5, file: !3)
!16 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !3, entity: !17, file: !3)
!17 = !DIModule(scope: null, name: "SwiftOnoneSupport", includePath: "/home/simonschmalfuss/swift-5.1/swift-5.1.5-RELEASE-ubuntu18.04/usr/lib/swift/linux/x86_64/SwiftOnoneSupport.swiftmodule")
!18 = distinct !DICompileUnit(language: DW_LANG_C99, file: !19, producer: "clang version 7.0.0 ", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !6, nameTableKind: None)
!19 = !DIFile(filename: "<swift-imported-modules>", directory: "/home/simonschmalfuss/discopop/swift/CU_comp/reduction/arr_test")
!20 = !{!"standard-library", i1 false}
!21 = !{i32 2, !"Dwarf Version", i32 4}
!22 = !{i32 2, !"Debug Info Version", i32 3}
!23 = !{i32 1, !"wchar_size", i32 4}
!24 = !{i32 7, !"PIC Level", i32 2}
!25 = !{i32 4, !"Objective-C Garbage Collection", i32 83953408}
!26 = !{i32 1, !"Swift Version", i32 7}
!27 = !{[2 x i8*]* @llvm.used, null, null, i1 false, i1 true}
!28 = distinct !DISubprogram(name: "main", linkageName: "main", scope: !2, file: !3, line: 1, type: !29, spFlags: DISPFlagDefinition, unit: !11, retainedNodes: !6)
!29 = !DISubroutineType(types: !30)
!30 = !{!31, !31, !32}
!31 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Int32", scope: !5, file: !10, size: 32, elements: !6, runtimeLang: DW_LANG_Swift, identifier: "$ss5Int32VD")
!32 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "UnsafeMutablePointer", scope: !5, file: !3, size: 64, elements: !6, runtimeLang: DW_LANG_Swift, identifier: "$sSpySpys4Int8VGSgGD")
!33 = !DILocation(line: 1, column: 12, scope: !34)
!34 = distinct !DILexicalBlock(scope: !28, file: !3, line: 1, column: 1)
!35 = !DILocation(line: 1, column: 15, scope: !34)
!36 = !DILocation(line: 1, column: 18, scope: !34)
!37 = !DILocation(line: 1, column: 11, scope: !34)
!38 = !DILocation(line: 3, column: 8, scope: !39)
!39 = distinct !DILexicalBlock(scope: !28, file: !3, line: 3, column: 1)
!40 = !DILocation(line: 4, column: 20, scope: !41)
!41 = distinct !DILexicalBlock(scope: !28, file: !3, line: 4, column: 1)
!42 = !DILocation(line: 6, column: 8, scope: !43)
!43 = distinct !DILexicalBlock(scope: !28, file: !3, line: 6, column: 1)

; to be inserted above 

; something is wrong here: 
  ;instLoad at encoded LID 16388 and addr 952880 but write for arr[0] 
  ;was at instStore at encoded LID 16385 and addr 9528a0






target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%TSa = type <{ %Ts22_ContiguousArrayBufferV }>
%Ts22_ContiguousArrayBufferV = type <{ %Ts28__ContiguousArrayStorageBaseC* }>
%Ts28__ContiguousArrayStorageBaseC = type opaque
%TSi = type <{ i64 }>
%swift.type = type { i64 }

@"$s9reduction3arrSaySiGvp" = hidden global %TSa zeroinitializer, align 8, !dbg !0
@"$s9reduction9testvalueSivp" = hidden global %TSi zeroinitializer, align 8, !dbg !7
@"$sSiN" = external global %swift.type, align 8
@__swift_reflection_version = linkonce_odr hidden constant i16 3
@_swift1_autolink_entries = private constant [37 x i8] c"-lswiftSwiftOnoneSupport\00-lswiftCore\00", section ".swift1_autolink_entries", align 8
@llvm.used = appending global [2 x i8*] [i8* bitcast (i16* @__swift_reflection_version to i8*), i8* getelementptr inbounds ([37 x i8], [37 x i8]* @_swift1_autolink_entries, i32 0, i32 0)], section "llvm.metadata", align 8
@.str = private unnamed_addr constant [2 x i8] c"*\00", align 1
@.str.1 = private unnamed_addr constant [25 x i8] c"$s9reduction3arrSaySiGvp\00", align 1
@.str.2 = private unnamed_addr constant [12 x i8] c"debugstring\00", align 1


define protected i32 @main(i32, i8**) #0 !dbg !28 {
entry:
  call void @__dp_func_entry(i32 16385, i32 1)
  %access-scratch = alloca [24 x i8], align 8
  %2 = alloca [32 x i8], align 8
  %access-scratch4 = alloca [24 x i8], align 8
  %access-scratch5 = alloca [24 x i8], align 8
  %3 = alloca [32 x i8], align 8
  %4 = bitcast i8** %1 to i8*
  call void @__dp_call(i32 16385), !dbg !33
  %5 = call swiftcc { %Ts28__ContiguousArrayStorageBaseC*, i8* } @"$ss27_allocateUninitializedArrayySayxG_BptBwlF"(i64 3, %swift.type* @"$sSiN"), !dbg !33
  %6 = extractvalue { %Ts28__ContiguousArrayStorageBaseC*, i8* } %5, 0, !dbg !33
  %7 = extractvalue { %Ts28__ContiguousArrayStorageBaseC*, i8* } %5, 1, !dbg !33
  %8 = bitcast i8* %7 to %TSi*, !dbg !33
  %._value = getelementptr inbounds %TSi, %TSi* %8, i32 0, i32 0, !dbg !33
  %9 = ptrtoint i64* %._value to i64
  call void @__dp_write(i32 16385, i64 %9, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i64 1, i64* %._value, align 8, !dbg !33
  %10 = getelementptr inbounds %TSi, %TSi* %8, i64 1, !dbg !35
  %._value1 = getelementptr inbounds %TSi, %TSi* %10, i32 0, i32 0, !dbg !35
  %11 = ptrtoint i64* %._value1 to i64
  call void @__dp_write(i32 16385, i64 %11, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i64 2, i64* %._value1, align 8, !dbg !35
  %12 = getelementptr inbounds %TSi, %TSi* %8, i64 2, !dbg !36
  %._value2 = getelementptr inbounds %TSi, %TSi* %12, i32 0, i32 0, !dbg !36
  %13 = ptrtoint i64* %._value2 to i64
  call void @__dp_write(i32 16385, i64 %13, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i64 3, i64* %._value2, align 8, !dbg !36
  call void @__dp_call(i32 16385), !dbg !37
  %14 = call swiftcc %Ts28__ContiguousArrayStorageBaseC* @"$sSa12arrayLiteralSayxGxd_tcfCSi_Tg5"(%Ts28__ContiguousArrayStorageBaseC* %6), !dbg !37
  %15 = ptrtoint %Ts28__ContiguousArrayStorageBaseC** getelementptr inbounds (%TSa, %TSa* @"$s9reduction3arrSaySiGvp", i32 0, i32 0, i32 0) to i64
  call void @__dp_write(i32 16385, i64 %15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store %Ts28__ContiguousArrayStorageBaseC* %14, %Ts28__ContiguousArrayStorageBaseC** getelementptr inbounds (%TSa, %TSa* @"$s9reduction3arrSaySiGvp", i32 0, i32 0, i32 0), align 8, !dbg !37
  %16 = bitcast [24 x i8]* %access-scratch to i8*, !dbg !38
  call void @__dp_call(i32 16387), !dbg !38
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %16), !dbg !38
  call void @__dp_call(i32 16387), !dbg !38
  call void @swift_beginAccess(i8* bitcast (%TSa* @"$s9reduction3arrSaySiGvp" to i8*), [24 x i8]* %access-scratch, i64 33, i8* null) #3, !dbg !38
  %17 = getelementptr inbounds [32 x i8], [32 x i8]* %2, i32 0, i32 0, !dbg !38
  call void @__dp_call(i32 16387), !dbg !38
  call void @llvm.lifetime.start.p0i8(i64 32, i8* %17), !dbg !38
  call void @__dp_call(i32 16387), !dbg !38

  %18 = call swiftcc { i8*, %TSi* } @"$sSayxSiciMSi_Tg5"(i8* noalias dereferenceable(32) %17, i64 0, %TSa* nocapture swiftself dereferenceable(8) @"$s9reduction3arrSaySiGvp"), !dbg !38
  %19 = extractvalue { i8*, %TSi* } %18, 0, !dbg !38
  %20 = extractvalue { i8*, %TSi* } %18, 1, !dbg !38

  %._value3 = getelementptr inbounds %TSi, %TSi* %20, i32 0, i32 0, !dbg !38
  %21 = ptrtoint i64* %._value3 to i64

  %e = ptrtoint %TSa* @"$s9reduction3arrSaySiGvp" to i64

  call void @__dp_write(i32 16000, i64 %e, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str.1, i32 0, i32 0))

  call void @__dp_write(i32 16387, i64 %21, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str.1, i32 0, i32 0))
  store i64 0, i64* %._value3, align 8, !dbg !38

  %22 = bitcast i8* %19 to void (i8*, i1)*, !dbg !38
  call void @__dp_call(i32 16387), !dbg !38
  call swiftcc void %22(i8* noalias dereferenceable(32) %17, i1 false), !dbg !38
  call void @__dp_call(i32 16387), !dbg !38
  call void @llvm.lifetime.end.p0i8(i64 32, i8* %17), !dbg !38
  call void @__dp_call(i32 16387), !dbg !38
  call void @swift_endAccess([24 x i8]* %access-scratch) #3, !dbg !38
  %23 = bitcast [24 x i8]* %access-scratch to i8*, !dbg !38
  call void @__dp_call(i32 16387), !dbg !38
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %23), !dbg !38
  %24 = bitcast [24 x i8]* %access-scratch4 to i8*, !dbg !40
  call void @__dp_call(i32 16388), !dbg !40
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %24), !dbg !40
  call void @__dp_call(i32 16388), !dbg !40
  call void @swift_beginAccess(i8* bitcast (%TSa* @"$s9reduction3arrSaySiGvp" to i8*), [24 x i8]* %access-scratch4, i64 32, i8* null) #3, !dbg !40
  %25 = ptrtoint %Ts28__ContiguousArrayStorageBaseC** getelementptr inbounds (%TSa, %TSa* @"$s9reduction3arrSaySiGvp", i32 0, i32 0, i32 0) to i64
  call void @__dp_read(i32 16388, i64 %25, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %26 = load %Ts28__ContiguousArrayStorageBaseC*, %Ts28__ContiguousArrayStorageBaseC** getelementptr inbounds (%TSa, %TSa* @"$s9reduction3arrSaySiGvp", i32 0, i32 0, i32 0), align 8, !dbg !40
  %27 = ptrtoint %Ts28__ContiguousArrayStorageBaseC* %26 to i64
  %idxadd = add i64 0, %27
  call void @__dp_read(i32 16388, i64 %idxadd, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str.1, i32 0, i32 0))

  ;%addb = call swiftcc { i8*, %TSi* } @"$sSayxSiciMSi_Tg5"(i8* noalias dereferenceable(32) %17, i64 0, %TSa* nocapture swiftself dereferenceable(8) @"$s9reduction3arrSaySiGvp")
  %addb = call swiftcc { i8*, %TSi* } @"$sSayxSiciMSi_Tg5"(i8* noalias dereferenceable(32) %17, i64 0, %TSa* @"$s9reduction3arrSaySiGvp")

  %unpacked = extractvalue { i8*, %TSi* } %addb, 1
  %res = ptrtoint %TSi* %unpacked to i64

  call void @__dp_read(i32 16000, i64 %res, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.2, i32 0, i32 0))
  call void @__dp_read(i32 16001, i64 %27, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.2, i32 0, i32 0))


  call void @__dp_call(i32 16388), !dbg !40
  %28 = call swiftcc i64 @"$sSayxSicigSi_Tg5"(i64 0, %Ts28__ContiguousArrayStorageBaseC* %26), !dbg !40
  %29 = ptrtoint i64* getelementptr inbounds (%TSi, %TSi* @"$s9reduction9testvalueSivp", i32 0, i32 0) to i64
  call void @__dp_write(i32 16388, i64 %29, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i64 %28, i64* getelementptr inbounds (%TSi, %TSi* @"$s9reduction9testvalueSivp", i32 0, i32 0), align 8, !dbg !40
  call void @__dp_call(i32 16388), !dbg !40
  call void @swift_endAccess([24 x i8]* %access-scratch4) #3, !dbg !40
  %30 = bitcast [24 x i8]* %access-scratch4 to i8*, !dbg !40
  call void @__dp_call(i32 16388), !dbg !40
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %30), !dbg !40
  %31 = bitcast [24 x i8]* %access-scratch5 to i8*, !dbg !42
  call void @__dp_call(i32 16390), !dbg !42
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %31), !dbg !42
  call void @__dp_call(i32 16390), !dbg !42
  call void @swift_beginAccess(i8* bitcast (%TSa* @"$s9reduction3arrSaySiGvp" to i8*), [24 x i8]* %access-scratch5, i64 33, i8* null) #3, !dbg !42
  %32 = getelementptr inbounds [32 x i8], [32 x i8]* %3, i32 0, i32 0, !dbg !42
  call void @__dp_call(i32 16390), !dbg !42
  call void @llvm.lifetime.start.p0i8(i64 32, i8* %32), !dbg !42
  call void @__dp_call(i32 16390), !dbg !42
  %33 = call swiftcc { i8*, %TSi* } @"$sSayxSiciMSi_Tg5"(i8* noalias dereferenceable(32) %32, i64 1, %TSa* nocapture swiftself dereferenceable(8) @"$s9reduction3arrSaySiGvp"), !dbg !42
  %34 = extractvalue { i8*, %TSi* } %33, 0, !dbg !42
  %35 = extractvalue { i8*, %TSi* } %33, 1, !dbg !42
  %._value6 = getelementptr inbounds %TSi, %TSi* %35, i32 0, i32 0, !dbg !42
  %36 = ptrtoint i64* %._value6 to i64
  call void @__dp_write(i32 16390, i64 %36, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str.1, i32 0, i32 0))
  store i64 2, i64* %._value6, align 8, !dbg !42
  %37 = bitcast i8* %34 to void (i8*, i1)*, !dbg !42
  call void @__dp_call(i32 16390), !dbg !42
  call swiftcc void %37(i8* noalias dereferenceable(32) %32, i1 false), !dbg !42
  call void @__dp_call(i32 16390), !dbg !42
  call void @llvm.lifetime.end.p0i8(i64 32, i8* %32), !dbg !42
  call void @__dp_call(i32 16390), !dbg !42
  call void @swift_endAccess([24 x i8]* %access-scratch5) #3, !dbg !42
  %38 = bitcast [24 x i8]* %access-scratch5 to i8*, !dbg !42
  call void @__dp_call(i32 16390), !dbg !42
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %38), !dbg !42
  call void @__dp_finalize(i32 16390), !dbg !42
  ret i32 0, !dbg !42
}

declare swiftcc { %Ts28__ContiguousArrayStorageBaseC*, i8* } @"$ss27_allocateUninitializedArrayySayxG_BptBwlF"(i64, %swift.type*) #0

; Function Attrs: cold noreturn nounwind
declare void @llvm.trap() #1

declare swiftcc %Ts28__ContiguousArrayStorageBaseC* @"$sSa12arrayLiteralSayxGxd_tcfCSi_Tg5"(%Ts28__ContiguousArrayStorageBaseC*) #0

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #2

; Function Attrs: nounwind
declare void @swift_beginAccess(i8*, [24 x i8]*, i64, i8*) #3

declare swiftcc { i8*, %TSi* } @"$sSayxSiciMSi_Tg5"(i8* noalias dereferenceable(32), i64, %TSa* nocapture swiftself dereferenceable(8)) #0

; Function Attrs: nounwind readnone
declare i8* @llvm.coro.prepare.retcon(i8*) #4

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #2

; Function Attrs: nounwind
declare void @swift_endAccess([24 x i8]*) #3

declare swiftcc i64 @"$sSayxSicigSi_Tg5"(i64, %Ts28__ContiguousArrayStorageBaseC*) #0

declare void @__dp_init(i32, i32, i32)

declare void @__dp_finalize(i32)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_write(i32, i64, i8*)

declare void @__dp_call(i32)

declare void @__dp_func_entry(i32, i32)

declare void @__dp_func_exit(i32, i32)

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_loop_exit(i32, i32)

attributes #0 = { "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" }
attributes #1 = { cold noreturn nounwind }
attributes #2 = { argmemonly nounwind }
attributes #3 = { nounwind }
attributes #4 = { nounwind readnone }

!llvm.dbg.cu = !{!11, !18}
!swift.module.flags = !{!20}
!llvm.linker.options = !{}
!llvm.module.flags = !{!21, !22, !23, !24, !25, !26}
!llvm.asan.globals = !{!27}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "arr", linkageName: "$s9reduction3arrSaySiGvp", scope: !2, file: !3, line: 1, type: !4, isLocal: false, isDefinition: true)
!2 = !DIModule(scope: null, name: "reduction")
!3 = !DIFile(filename: "reduction.swift", directory: "/home/simonschmalfuss/discopop/swift/CU_comp/reduction/arr_test")
!4 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Array", scope: !5, file: !3, size: 64, elements: !6, runtimeLang: DW_LANG_Swift, identifier: "$sSaySiGD")
!5 = !DIModule(scope: null, name: "Swift", includePath: "/home/simonschmalfuss/swift-5.1/swift-5.1.5-RELEASE-ubuntu18.04/usr/lib/swift/linux/x86_64/Swift.swiftmodule")
!6 = !{}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "testvalue", linkageName: "$s9reduction9testvalueSivp", scope: !2, file: !3, line: 4, type: !9, isLocal: false, isDefinition: true)
!9 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Int", scope: !5, file: !10, size: 64, elements: !6, runtimeLang: DW_LANG_Swift, identifier: "$sSiD")
!10 = !DIFile(filename: "swift-5.1/swift-5.1.5-RELEASE-ubuntu18.04/usr/lib/swift/linux/x86_64/Swift.swiftmodule", directory: "/home/simonschmalfuss")
!11 = distinct !DICompileUnit(language: DW_LANG_Swift, file: !3, producer: "Swift version 5.1.5 (swift-5.1.5-RELEASE)", isOptimized: false, runtimeVersion: 5, emissionKind: FullDebug, enums: !6, globals: !12, imports: !13)
!12 = !{!0, !7}
!13 = !{!14, !15, !16}
!14 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !3, entity: !2, file: !3)
!15 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !3, entity: !5, file: !3)
!16 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !3, entity: !17, file: !3)
!17 = !DIModule(scope: null, name: "SwiftOnoneSupport", includePath: "/home/simonschmalfuss/swift-5.1/swift-5.1.5-RELEASE-ubuntu18.04/usr/lib/swift/linux/x86_64/SwiftOnoneSupport.swiftmodule")
!18 = distinct !DICompileUnit(language: DW_LANG_C99, file: !19, producer: "clang version 7.0.0 ", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !6, nameTableKind: None)
!19 = !DIFile(filename: "<swift-imported-modules>", directory: "/home/simonschmalfuss/discopop/swift/CU_comp/reduction/arr_test")
!20 = !{!"standard-library", i1 false}
!21 = !{i32 2, !"Dwarf Version", i32 4}
!22 = !{i32 2, !"Debug Info Version", i32 3}
!23 = !{i32 1, !"wchar_size", i32 4}
!24 = !{i32 7, !"PIC Level", i32 2}
!25 = !{i32 4, !"Objective-C Garbage Collection", i32 83953408}
!26 = !{i32 1, !"Swift Version", i32 7}
!27 = !{[2 x i8*]* @llvm.used, null, null, i1 false, i1 true}
!28 = distinct !DISubprogram(name: "main", linkageName: "main", scope: !2, file: !3, line: 1, type: !29, spFlags: DISPFlagDefinition, unit: !11, retainedNodes: !6)
!29 = !DISubroutineType(types: !30)
!30 = !{!31, !31, !32}
!31 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Int32", scope: !5, file: !10, size: 32, elements: !6, runtimeLang: DW_LANG_Swift, identifier: "$ss5Int32VD")
!32 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "UnsafeMutablePointer", scope: !5, file: !3, size: 64, elements: !6, runtimeLang: DW_LANG_Swift, identifier: "$sSpySpys4Int8VGSgGD")
!33 = !DILocation(line: 1, column: 12, scope: !34)
!34 = distinct !DILexicalBlock(scope: !28, file: !3, line: 1, column: 1)
!35 = !DILocation(line: 1, column: 15, scope: !34)
!36 = !DILocation(line: 1, column: 18, scope: !34)
!37 = !DILocation(line: 1, column: 11, scope: !34)
!38 = !DILocation(line: 3, column: 8, scope: !39)
!39 = distinct !DILexicalBlock(scope: !28, file: !3, line: 3, column: 1)
!40 = !DILocation(line: 4, column: 20, scope: !41)
!41 = distinct !DILexicalBlock(scope: !28, file: !3, line: 4, column: 1)
!42 = !DILocation(line: 6, column: 8, scope: !43)
!43 = distinct !DILexicalBlock(scope: !28, file: !3, line: 6, column: 1)

