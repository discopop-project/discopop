; ModuleID = 'reduction.ll'
source_filename = "reduction.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%TSa = type <{ %Ts22_ContiguousArrayBufferV }>
%Ts22_ContiguousArrayBufferV = type <{ %Ts28__ContiguousArrayStorageBaseC* }>
%Ts28__ContiguousArrayStorageBaseC = type opaque
%TSi = type <{ i64 }>
%swift.type = type { i64 }
%swift.refcounted = type { %swift.type*, i64 }

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
  %3 = bitcast i8** %1 to i8*
  %4 = call swiftcc { %Ts28__ContiguousArrayStorageBaseC*, i8* } @"$ss27_allocateUninitializedArrayySayxG_BptBwlF"(i64 3, %swift.type* @"$sSiN"), !dbg !33
  %5 = extractvalue { %Ts28__ContiguousArrayStorageBaseC*, i8* } %4, 0, !dbg !33
  %6 = extractvalue { %Ts28__ContiguousArrayStorageBaseC*, i8* } %4, 1, !dbg !33
  %7 = bitcast i8* %6 to %TSi*, !dbg !33
  %._value = getelementptr inbounds %TSi, %TSi* %7, i32 0, i32 0, !dbg !33
  store i64 1, i64* %._value, align 8, !dbg !33
  %8 = getelementptr inbounds %TSi, %TSi* %7, i64 1, !dbg !35
  %._value1 = getelementptr inbounds %TSi, %TSi* %8, i32 0, i32 0, !dbg !35
  store i64 2, i64* %._value1, align 8, !dbg !35
  %9 = getelementptr inbounds %TSi, %TSi* %7, i64 2, !dbg !36
  %._value2 = getelementptr inbounds %TSi, %TSi* %9, i32 0, i32 0, !dbg !36
  store i64 3, i64* %._value2, align 8, !dbg !36
  %10 = call swiftcc %Ts28__ContiguousArrayStorageBaseC* @"$sSa12arrayLiteralSayxGxd_tcfCSi_Tg5"(%Ts28__ContiguousArrayStorageBaseC* %5), !dbg !37
  store %Ts28__ContiguousArrayStorageBaseC* %10, %Ts28__ContiguousArrayStorageBaseC** getelementptr inbounds (%TSa, %TSa* @"$s9reduction3arrSaySiGvp", i32 0, i32 0, i32 0), align 8, !dbg !37
  %11 = bitcast [24 x i8]* %access-scratch to i8*, !dbg !38
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %11), !dbg !38
  call void @swift_beginAccess(i8* bitcast (%TSa* @"$s9reduction3arrSaySiGvp" to i8*), [24 x i8]* %access-scratch, i64 33, i8* null) #3, !dbg !38
  %12 = getelementptr inbounds [32 x i8], [32 x i8]* %2, i32 0, i32 0, !dbg !38
  call void @llvm.lifetime.start.p0i8(i64 32, i8* %12), !dbg !38

  ; array storing here
  %13 = call swiftcc { i8*, %TSi* } @"$sSayxSiciMSi_Tg5"(i8* noalias dereferenceable(32) %12, i64 0, %TSa* nocapture swiftself dereferenceable(8) @"$s9reduction3arrSaySiGvp"), !dbg !38
  %14 = extractvalue { i8*, %TSi* } %13, 0, !dbg !38
  %15 = extractvalue { i8*, %TSi* } %13, 1, !dbg !38
  %._value3 = getelementptr inbounds %TSi, %TSi* %15, i32 0, i32 0, !dbg !38
  store i64 0, i64* %._value3, align 8, !dbg !38

  %16 = bitcast i8* %14 to void (i8*, i1)*, !dbg !38
  call swiftcc void %16(i8* noalias dereferenceable(32) %12, i1 false), !dbg !38
  call void @llvm.lifetime.end.p0i8(i64 32, i8* %12), !dbg !38
  call void @swift_endAccess([24 x i8]* %access-scratch) #3, !dbg !38
  %17 = bitcast [24 x i8]* %access-scratch to i8*, !dbg !38
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %17), !dbg !38
  %18 = bitcast [24 x i8]* %access-scratch4 to i8*, !dbg !40
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %18), !dbg !40
  call void @swift_beginAccess(i8* bitcast (%TSa* @"$s9reduction3arrSaySiGvp" to i8*), [24 x i8]* %access-scratch4, i64 32, i8* null) #3, !dbg !40

  ; read from array here: need to calculate address because there is no load instruction
  %19 = load %Ts28__ContiguousArrayStorageBaseC*, %Ts28__ContiguousArrayStorageBaseC** getelementptr inbounds (%TSa, %TSa* @"$s9reduction3arrSaySiGvp", i32 0, i32 0, i32 0), align 8, !dbg !40
  %20 = call swiftcc i64 @"$sSayxSicigSi_Tg5"(i64 0, %Ts28__ContiguousArrayStorageBaseC* %19), !dbg !40
  
  store i64 %20, i64* getelementptr inbounds (%TSi, %TSi* @"$s9reduction9testvalueSivp", i32 0, i32 0), align 8, !dbg !40
  call void @swift_endAccess([24 x i8]* %access-scratch4) #3, !dbg !40
  %21 = bitcast [24 x i8]* %access-scratch4 to i8*, !dbg !40
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %21), !dbg !40
  ret i32 0, !dbg !40
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

define hidden swiftcc void @"$s9reduction9localtestyyF"() #0 !dbg !42 {
entry:
  %array = alloca %TSa, align 8
  call void @llvm.dbg.declare(metadata %TSa* %array, metadata !46, metadata !DIExpression()), !dbg !48
  %0 = bitcast %TSa* %array to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %0, i8 0, i64 8, i1 false)
  %1 = alloca [32 x i8], align 8
  %localtest = alloca %TSi, align 8
  call void @llvm.dbg.declare(metadata %TSi* %localtest, metadata !49, metadata !DIExpression()), !dbg !50
  %2 = bitcast %TSi* %localtest to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %2, i8 0, i64 8, i1 false)
  %localinsideglobal = alloca %TSi, align 8
  call void @llvm.dbg.declare(metadata %TSi* %localinsideglobal, metadata !51, metadata !DIExpression()), !dbg !52
  %3 = bitcast %TSi* %localinsideglobal to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %3, i8 0, i64 8, i1 false)
  %access-scratch = alloca [24 x i8], align 8
  %4 = bitcast %TSa* %array to i8*, !dbg !53
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %4), !dbg !53

  ;; exception for storing: when initializing the array. cannot be instrumented because allocateuninitialized does not reference the name of the array
  %5 = call swiftcc { %Ts28__ContiguousArrayStorageBaseC*, i8* } @"$ss27_allocateUninitializedArrayySayxG_BptBwlF"(i64 4, %swift.type* @"$sSiN"), !dbg !56
  %6 = extractvalue { %Ts28__ContiguousArrayStorageBaseC*, i8* } %5, 0, !dbg !56
  %7 = extractvalue { %Ts28__ContiguousArrayStorageBaseC*, i8* } %5, 1, !dbg !56
  %8 = bitcast i8* %7 to %TSi*, !dbg !56
  %._value = getelementptr inbounds %TSi, %TSi* %8, i32 0, i32 0, !dbg !56
  store i64 1, i64* %._value, align 8, !dbg !56
  %9 = getelementptr inbounds %TSi, %TSi* %8, i64 1, !dbg !57
  %._value1 = getelementptr inbounds %TSi, %TSi* %9, i32 0, i32 0, !dbg !57
  store i64 2, i64* %._value1, align 8, !dbg !57
  %10 = getelementptr inbounds %TSi, %TSi* %8, i64 2, !dbg !58
  %._value2 = getelementptr inbounds %TSi, %TSi* %10, i32 0, i32 0, !dbg !58
  store i64 3, i64* %._value2, align 8, !dbg !58
  %11 = getelementptr inbounds %TSi, %TSi* %8, i64 3, !dbg !59
  %._value3 = getelementptr inbounds %TSi, %TSi* %11, i32 0, i32 0, !dbg !59
  store i64 4, i64* %._value3, align 8, !dbg !59
  %12 = call swiftcc %Ts28__ContiguousArrayStorageBaseC* @"$sSa12arrayLiteralSayxGxd_tcfCSi_Tg5"(%Ts28__ContiguousArrayStorageBaseC* %6), !dbg !60
  %array._buffer = getelementptr inbounds %TSa, %TSa* %array, i32 0, i32 0, !dbg !60
  %array._buffer._storage = getelementptr inbounds %Ts22_ContiguousArrayBufferV, %Ts22_ContiguousArrayBufferV* %array._buffer, i32 0, i32 0, !dbg !60
  store %Ts28__ContiguousArrayStorageBaseC* %12, %Ts28__ContiguousArrayStorageBaseC** %array._buffer._storage, align 8, !dbg !60
  %13 = getelementptr inbounds [32 x i8], [32 x i8]* %1, i32 0, i32 0, !dbg !61
  call void @llvm.lifetime.start.p0i8(i64 32, i8* %13), !dbg !61

  ;;write to array here
  %14 = call swiftcc { i8*, %TSi* } @"$sSayxSiciMSi_Tg5"(i8* noalias dereferenceable(32) %13, i64 0, %TSa* nocapture swiftself dereferenceable(8) %array), !dbg !61
  %15 = extractvalue { i8*, %TSi* } %14, 0, !dbg !61
  %16 = extractvalue { i8*, %TSi* } %14, 1, !dbg !61
  %._value4 = getelementptr inbounds %TSi, %TSi* %16, i32 0, i32 0, !dbg !61
  store i64 3, i64* %._value4, align 8, !dbg !61

  %17 = bitcast i8* %15 to void (i8*, i1)*, !dbg !61
  call swiftcc void %17(i8* noalias dereferenceable(32) %13, i1 false), !dbg !61
  call void @llvm.lifetime.end.p0i8(i64 32, i8* %13), !dbg !61
  %18 = bitcast %TSi* %localtest to i8*, !dbg !53
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %18), !dbg !53
    
  %array._buffer5 = getelementptr inbounds %TSa, %TSa* %array, i32 0, i32 0, !dbg !62
  %array._buffer5._storage = getelementptr inbounds %Ts22_ContiguousArrayBufferV, %Ts22_ContiguousArrayBufferV* %array._buffer5, i32 0, i32 0, !dbg !62
  %19 = load %Ts28__ContiguousArrayStorageBaseC*, %Ts28__ContiguousArrayStorageBaseC** %array._buffer5._storage, align 8, !dbg !62
  %20 = call swiftcc i64 @"$sSayxSicigSi_Tg5"(i64 1, %Ts28__ContiguousArrayStorageBaseC* %19), !dbg !62

  %localtest._value = getelementptr inbounds %TSi, %TSi* %localtest, i32 0, i32 0, !dbg !62
  store i64 %20, i64* %localtest._value, align 8, !dbg !62
  %21 = bitcast %TSi* %localinsideglobal to i8*, !dbg !53
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %21), !dbg !53
  %22 = bitcast [24 x i8]* %access-scratch to i8*, !dbg !63
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %22), !dbg !63
  call void @swift_beginAccess(i8* bitcast (%TSa* @"$s9reduction3arrSaySiGvp" to i8*), [24 x i8]* %access-scratch, i64 32, i8* null) #3, !dbg !63

  ; reading form global array here
  %23 = load %Ts28__ContiguousArrayStorageBaseC*, %Ts28__ContiguousArrayStorageBaseC** getelementptr inbounds (%TSa, %TSa* @"$s9reduction3arrSaySiGvp", i32 0, i32 0, i32 0), align 8, !dbg !63
  %24 = call swiftcc i64 @"$sSayxSicigSi_Tg5"(i64 1, %Ts28__ContiguousArrayStorageBaseC* %23), !dbg !63
  %localinsideglobal._value = getelementptr inbounds %TSi, %TSi* %localinsideglobal, i32 0, i32 0, !dbg !63
  store i64 %24, i64* %localinsideglobal._value, align 8, !dbg !63
  call void @swift_endAccess([24 x i8]* %access-scratch) #3, !dbg !63
  %25 = bitcast [24 x i8]* %access-scratch to i8*, !dbg !63
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %25), !dbg !63
  %26 = bitcast %TSi* %localinsideglobal to i8*, !dbg !64
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %26), !dbg !64
  %27 = bitcast %TSi* %localtest to i8*, !dbg !64
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %27), !dbg !64
  %28 = call %TSa* @"$sSaySiGWOh"(%TSa* %array), !dbg !64
  %29 = bitcast %TSa* %array to i8*, !dbg !64
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %29), !dbg !64
  ret void, !dbg !64
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1) #2

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #5

; Function Attrs: noinline nounwind
define linkonce_odr hidden %TSa* @"$sSaySiGWOh"(%TSa*) #6 !dbg !65 {
entry:
  %._buffer = getelementptr inbounds %TSa, %TSa* %0, i32 0, i32 0, !dbg !67
  %._buffer._storage = getelementptr inbounds %Ts22_ContiguousArrayBufferV, %Ts22_ContiguousArrayBufferV* %._buffer, i32 0, i32 0, !dbg !67
  %toDestroy = load %Ts28__ContiguousArrayStorageBaseC*, %Ts28__ContiguousArrayStorageBaseC** %._buffer._storage, align 8, !dbg !67
  call void bitcast (void (%swift.refcounted*)* @swift_release to void (%Ts28__ContiguousArrayStorageBaseC*)*)(%Ts28__ContiguousArrayStorageBaseC* %toDestroy) #3, !dbg !67
  ret %TSa* %0, !dbg !67
}

; Function Attrs: nounwind
declare void @swift_release(%swift.refcounted*) #3

attributes #0 = { "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" }
attributes #1 = { cold noreturn nounwind }
attributes #2 = { argmemonly nounwind }
attributes #3 = { nounwind }
attributes #4 = { nounwind readnone }
attributes #5 = { nounwind readnone speculatable }
attributes #6 = { noinline nounwind }

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
!42 = distinct !DISubprogram(name: "localtest", linkageName: "$s9reduction9localtestyyF", scope: !2, file: !3, line: 6, type: !43, scopeLine: 6, spFlags: DISPFlagDefinition, unit: !11, retainedNodes: !6)
!43 = !DISubroutineType(types: !44)
!44 = !{!45}
!45 = !DICompositeType(tag: DW_TAG_structure_type, name: "$sytD", file: !3, elements: !6, runtimeLang: DW_LANG_Swift, identifier: "$sytD")
!46 = !DILocalVariable(name: "array", scope: !47, file: !3, line: 7, type: !4)
!47 = distinct !DILexicalBlock(scope: !42, file: !3, line: 6, column: 18)
!48 = !DILocation(line: 7, column: 5, scope: !47)
!49 = !DILocalVariable(name: "localtest", scope: !47, file: !3, line: 9, type: !9)
!50 = !DILocation(line: 9, column: 5, scope: !47)
!51 = !DILocalVariable(name: "localinsideglobal", scope: !47, file: !3, line: 10, type: !9)
!52 = !DILocation(line: 10, column: 5, scope: !47)
!53 = !DILocation(line: 0, scope: !54)
!54 = !DILexicalBlockFile(scope: !47, file: !55, discriminator: 0)
!55 = !DIFile(filename: "<compiler-generated>", directory: "")
!56 = !DILocation(line: 7, column: 14, scope: !47)
!57 = !DILocation(line: 7, column: 17, scope: !47)
!58 = !DILocation(line: 7, column: 20, scope: !47)
!59 = !DILocation(line: 7, column: 23, scope: !47)
!60 = !DILocation(line: 7, column: 13, scope: !47)
!61 = !DILocation(line: 8, column: 10, scope: !47)
!62 = !DILocation(line: 9, column: 22, scope: !47)
!63 = !DILocation(line: 10, column: 28, scope: !47)
!64 = !DILocation(line: 11, column: 1, scope: !47)
!65 = distinct !DISubprogram(linkageName: "$sSaySiGWOh", scope: !2, file: !55, type: !66, flags: DIFlagArtificial, spFlags: DISPFlagDefinition, unit: !11, retainedNodes: !6)
!66 = !DISubroutineType(types: null)
!67 = !DILocation(line: 0, scope: !65)
