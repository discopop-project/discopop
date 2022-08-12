var arr = [1, 2, 3]; init arr

arr[0] = 0; waw 3 1
var testvalue = arr[0]; init testvalue 4 raw 4 1

arr[1] = 2; waw 6 1


func accessLocally() {
 var loc = arr[2]; init loc raw 10 1
 var locArr = [1, 2, 3]; init locArr
 arr[1] = 0; waw 12 6
 locArr[0] = 1;  waw 13 11
 loc = locArr[1]; waw 14 10  raw 14 11
 locArr[1] = 0; war 15 11
 locArr[2] = 0; waw 16 11

} 


accessLocally(); 

START 1:1
1:21 BGN func 1:10
1:18 END func
1:6 NOM  WAW 1:1|$s9reduction3arrSaySiGvp
1:12 NOM  WAW 1:6|$s9reduction3arrSaySiGvp
1:13 NOM  WAW 1:11|locArr
1:1 NOM  INIT *|* INIT *|$s9reduction3arrSaySiGvp
1:14 NOM  RAW 1:11|locArr RAW 1:14|* WAW 1:10|loc INIT *|*
1:16 NOM  WAW 1:11|locArr
1:3 NOM  WAW 1:1|$s9reduction3arrSaySiGvp
1:4 NOM  RAW 1:1|$s9reduction3arrSaySiGvp RAW 1:3|$s9reduction3arrSaySiGvp INIT *|$s9reduction9testvalueSivp
1:10 NOM  RAW 1:1|$s9reduction3arrSaySiGvp INIT *|loc
1:11 NOM  INIT *|* INIT *|locArr
1:15 NOM  WAR 1:14|locArr
1:21 END program


START 1:1
1:21 BGN func 1:10
1:18 END func
1:15 NOM  WAR 1:14|locArr
1:6 NOM  WAW 1:1|arr
1:12 NOM  WAW 1:6|arr
1:13 NOM  WAW 1:11|locArr
1:1 NOM  INIT *|* INIT *|arr
1:14 NOM  RAW 1:11|locArr RAW 1:14|* WAW 1:10|loc INIT *|*
1:3 NOM  WAW 1:1|arr
1:16 NOM  WAW 1:11|locArr
1:4 NOM  RAW 1:1|arr RAW 1:3|arr INIT *|testvalue
1:10 NOM  RAW 1:1|arr INIT *|loc
1:11 NOM  INIT *|* INIT *|locArr
1:21 END program





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
@.str = private unnamed_addr constant [2 x i8] c"*\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"arr\00", align 1
@.str.2 = private unnamed_addr constant [10 x i8] c"testvalue\00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c"loc\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c"locArr\00", align 1

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
  call void @__dp_write(i32 16385, i64 %15, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0))
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
  call void @__dp_write(i32 16387, i64 %21, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0))
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
  call void @__dp_read(i32 16388, i64 %25, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0))
  %26 = load %Ts28__ContiguousArrayStorageBaseC*, %Ts28__ContiguousArrayStorageBaseC** getelementptr inbounds (%TSa, %TSa* @"$s9reduction3arrSaySiGvp", i32 0, i32 0, i32 0), align 8, !dbg !40
  %loadIdx = call { i8*, %TSi* } @"$sSayxSiciMSi_Tg5"(i8* null, i64 0, %TSa* @"$s9reduction3arrSaySiGvp")
  %unpackedIdx = extractvalue { i8*, %TSi* } %loadIdx, 1
  %27 = ptrtoint %TSi* %unpackedIdx to i64
  call void @__dp_read(i32 16388, i64 %27, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0))
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
  %33 = call swiftcc { i8*, %TSi* } @"$sSayxSiciMSi_Tg5"(i8* noalias dereferenceable(32) %32, i64 1, %TSa* nocapture swiftself dereferenceable(8) @"$s9reduction3arrSaySiGvp"), !dbg !42
  %34 = extractvalue { i8*, %TSi* } %33, 0, !dbg !42
  %35 = extractvalue { i8*, %TSi* } %33, 1, !dbg !42
  %._value6 = getelementptr inbounds %TSi, %TSi* %35, i32 0, i32 0, !dbg !42
  %36 = ptrtoint i64* %._value6 to i64
  call void @__dp_write(i32 16390, i64 %36, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0))
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
  call void @__dp_call(i32 16405), !dbg !44
  call swiftcc void @"$s9reduction13accessLocallyyyF"(), !dbg !44
  call void @__dp_finalize(i32 16405), !dbg !44
  ret i32 0, !dbg !44
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

define hidden swiftcc void @"$s9reduction13accessLocallyyyF"() #0 !dbg !46 {
entry:
  call void @__dp_func_entry(i32 16394, i32 0)
  %loc = alloca %TSi, align 8
  call void @llvm.dbg.declare(metadata %TSi* %loc, metadata !50, metadata !DIExpression()), !dbg !52
  %0 = bitcast %TSi* %loc to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %0, i8 0, i64 8, i1 false)
  %access-scratch = alloca [24 x i8], align 8
  %locArr = alloca %TSa, align 8
  call void @llvm.dbg.declare(metadata %TSa* %locArr, metadata !53, metadata !DIExpression()), !dbg !54
  %1 = bitcast %TSa* %locArr to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %1, i8 0, i64 8, i1 false)
  %access-scratch3 = alloca [24 x i8], align 8
  %2 = alloca [32 x i8], align 8
  %3 = alloca [32 x i8], align 8
  %4 = alloca %TSi, align 8
  %5 = alloca [32 x i8], align 8
  %6 = alloca [32 x i8], align 8
  %7 = bitcast %TSi* %loc to i8*, !dbg !55
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %7), !dbg !55
  %8 = bitcast [24 x i8]* %access-scratch to i8*, !dbg !58
  call void @__dp_call(i32 16394), !dbg !58
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %8), !dbg !58
  call void @__dp_call(i32 16394), !dbg !58
  call void @swift_beginAccess(i8* bitcast (%TSa* @"$s9reduction3arrSaySiGvp" to i8*), [24 x i8]* %access-scratch, i64 32, i8* null) #3, !dbg !58
  %9 = ptrtoint %Ts28__ContiguousArrayStorageBaseC** getelementptr inbounds (%TSa, %TSa* @"$s9reduction3arrSaySiGvp", i32 0, i32 0, i32 0) to i64
  call void @__dp_read(i32 16394, i64 %9, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0))
  %10 = load %Ts28__ContiguousArrayStorageBaseC*, %Ts28__ContiguousArrayStorageBaseC** getelementptr inbounds (%TSa, %TSa* @"$s9reduction3arrSaySiGvp", i32 0, i32 0, i32 0), align 8, !dbg !58
  %loadIdx = call { i8*, %TSi* } @"$sSayxSiciMSi_Tg5"(i8* null, i64 2, %TSa* @"$s9reduction3arrSaySiGvp")
  %unpackedIdx = extractvalue { i8*, %TSi* } %loadIdx, 1
  %11 = ptrtoint %TSi* %unpackedIdx to i64
  call void @__dp_read(i32 16394, i64 %11, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0))
  call void @__dp_call(i32 16394), !dbg !58
  %12 = call swiftcc i64 @"$sSayxSicigSi_Tg5"(i64 2, %Ts28__ContiguousArrayStorageBaseC* %10), !dbg !58
  %loc._value = getelementptr inbounds %TSi, %TSi* %loc, i32 0, i32 0, !dbg !58
  %13 = ptrtoint i64* %loc._value to i64
  call void @__dp_write(i32 16394, i64 %13, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  store i64 %12, i64* %loc._value, align 8, !dbg !58
  call void @__dp_call(i32 16394), !dbg !58
  call void @swift_endAccess([24 x i8]* %access-scratch) #3, !dbg !58
  %14 = bitcast [24 x i8]* %access-scratch to i8*, !dbg !58
  call void @__dp_call(i32 16394), !dbg !58
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %14), !dbg !58
  %15 = bitcast %TSa* %locArr to i8*, !dbg !55
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %15), !dbg !55
  call void @__dp_call(i32 16395), !dbg !59
  %16 = call swiftcc { %Ts28__ContiguousArrayStorageBaseC*, i8* } @"$ss27_allocateUninitializedArrayySayxG_BptBwlF"(i64 3, %swift.type* @"$sSiN"), !dbg !59
  %17 = extractvalue { %Ts28__ContiguousArrayStorageBaseC*, i8* } %16, 0, !dbg !59
  %18 = extractvalue { %Ts28__ContiguousArrayStorageBaseC*, i8* } %16, 1, !dbg !59
  %19 = bitcast i8* %18 to %TSi*, !dbg !59
  %._value = getelementptr inbounds %TSi, %TSi* %19, i32 0, i32 0, !dbg !59
  %20 = ptrtoint i64* %._value to i64
  call void @__dp_write(i32 16395, i64 %20, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i64 1, i64* %._value, align 8, !dbg !59
  %21 = getelementptr inbounds %TSi, %TSi* %19, i64 1, !dbg !60
  %._value1 = getelementptr inbounds %TSi, %TSi* %21, i32 0, i32 0, !dbg !60
  %22 = ptrtoint i64* %._value1 to i64
  call void @__dp_write(i32 16395, i64 %22, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i64 2, i64* %._value1, align 8, !dbg !60
  %23 = getelementptr inbounds %TSi, %TSi* %19, i64 2, !dbg !61
  %._value2 = getelementptr inbounds %TSi, %TSi* %23, i32 0, i32 0, !dbg !61
  %24 = ptrtoint i64* %._value2 to i64
  call void @__dp_write(i32 16395, i64 %24, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i64 3, i64* %._value2, align 8, !dbg !61
  call void @__dp_call(i32 16395), !dbg !62
  %25 = call swiftcc %Ts28__ContiguousArrayStorageBaseC* @"$sSa12arrayLiteralSayxGxd_tcfCSi_Tg5"(%Ts28__ContiguousArrayStorageBaseC* %17), !dbg !62
  %locArr._buffer = getelementptr inbounds %TSa, %TSa* %locArr, i32 0, i32 0, !dbg !62
  %locArr._buffer._storage = getelementptr inbounds %Ts22_ContiguousArrayBufferV, %Ts22_ContiguousArrayBufferV* %locArr._buffer, i32 0, i32 0, !dbg !62
  %26 = ptrtoint %Ts28__ContiguousArrayStorageBaseC** %locArr._buffer._storage to i64
  call void @__dp_write(i32 16395, i64 %26, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0))
  store %Ts28__ContiguousArrayStorageBaseC* %25, %Ts28__ContiguousArrayStorageBaseC** %locArr._buffer._storage, align 8, !dbg !62
  %27 = bitcast [24 x i8]* %access-scratch3 to i8*, !dbg !63
  call void @__dp_call(i32 16396), !dbg !63
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %27), !dbg !63
  call void @__dp_call(i32 16396), !dbg !63
  call void @swift_beginAccess(i8* bitcast (%TSa* @"$s9reduction3arrSaySiGvp" to i8*), [24 x i8]* %access-scratch3, i64 33, i8* null) #3, !dbg !63
  %28 = getelementptr inbounds [32 x i8], [32 x i8]* %2, i32 0, i32 0, !dbg !63
  call void @__dp_call(i32 16396), !dbg !63
  call void @llvm.lifetime.start.p0i8(i64 32, i8* %28), !dbg !63
  call void @__dp_call(i32 16396), !dbg !63
  %29 = call swiftcc { i8*, %TSi* } @"$sSayxSiciMSi_Tg5"(i8* noalias dereferenceable(32) %28, i64 1, %TSa* nocapture swiftself dereferenceable(8) @"$s9reduction3arrSaySiGvp"), !dbg !63
  %30 = extractvalue { i8*, %TSi* } %29, 0, !dbg !63
  %31 = extractvalue { i8*, %TSi* } %29, 1, !dbg !63
  %._value4 = getelementptr inbounds %TSi, %TSi* %31, i32 0, i32 0, !dbg !63
  %32 = ptrtoint i64* %._value4 to i64
  call void @__dp_write(i32 16396, i64 %32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0))
  store i64 0, i64* %._value4, align 8, !dbg !63
  %33 = bitcast i8* %30 to void (i8*, i1)*, !dbg !63
  call void @__dp_call(i32 16396), !dbg !63
  call swiftcc void %33(i8* noalias dereferenceable(32) %28, i1 false), !dbg !63
  call void @__dp_call(i32 16396), !dbg !63
  call void @llvm.lifetime.end.p0i8(i64 32, i8* %28), !dbg !63
  call void @__dp_call(i32 16396), !dbg !63
  call void @swift_endAccess([24 x i8]* %access-scratch3) #3, !dbg !63
  %34 = bitcast [24 x i8]* %access-scratch3 to i8*, !dbg !63
  call void @__dp_call(i32 16396), !dbg !63
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %34), !dbg !63
  %35 = getelementptr inbounds [32 x i8], [32 x i8]* %3, i32 0, i32 0, !dbg !64
  call void @__dp_call(i32 16397), !dbg !64
  call void @llvm.lifetime.start.p0i8(i64 32, i8* %35), !dbg !64
  call void @__dp_call(i32 16397), !dbg !64
  %36 = call swiftcc { i8*, %TSi* } @"$sSayxSiciMSi_Tg5"(i8* noalias dereferenceable(32) %35, i64 0, %TSa* nocapture swiftself dereferenceable(8) %locArr), !dbg !64
  %37 = extractvalue { i8*, %TSi* } %36, 0, !dbg !64
  %38 = extractvalue { i8*, %TSi* } %36, 1, !dbg !64
  %._value5 = getelementptr inbounds %TSi, %TSi* %38, i32 0, i32 0, !dbg !64
  %39 = ptrtoint i64* %._value5 to i64
  call void @__dp_write(i32 16397, i64 %39, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0))
  store i64 1, i64* %._value5, align 8, !dbg !64
  %40 = bitcast i8* %37 to void (i8*, i1)*, !dbg !64
  call void @__dp_call(i32 16397), !dbg !64
  call swiftcc void %40(i8* noalias dereferenceable(32) %35, i1 false), !dbg !64
  call void @__dp_call(i32 16397), !dbg !64
  call void @llvm.lifetime.end.p0i8(i64 32, i8* %35), !dbg !64
  %locArr._buffer6 = getelementptr inbounds %TSa, %TSa* %locArr, i32 0, i32 0, !dbg !65
  %locArr._buffer6._storage = getelementptr inbounds %Ts22_ContiguousArrayBufferV, %Ts22_ContiguousArrayBufferV* %locArr._buffer6, i32 0, i32 0, !dbg !65
  %41 = ptrtoint %Ts28__ContiguousArrayStorageBaseC** %locArr._buffer6._storage to i64
  call void @__dp_read(i32 16398, i64 %41, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0))
  %42 = load %Ts28__ContiguousArrayStorageBaseC*, %Ts28__ContiguousArrayStorageBaseC** %locArr._buffer6._storage, align 8, !dbg !65
  %43 = bitcast %TSi* %4 to i8*, !dbg !55
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %43), !dbg !55
  %loadIdx1 = call { i8*, %TSi* } @"$sSayxSiciMSi_Tg5"(i8* null, i64 1, %TSa* %locArr)
  %unpackedIdx2 = extractvalue { i8*, %TSi* } %loadIdx1, 1
  %44 = ptrtoint %TSi* %unpackedIdx2 to i64
  call void @__dp_read(i32 16398, i64 %44, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0))
  call void @__dp_call(i32 16398), !dbg !65
  %45 = call swiftcc i64 @"$sSayxSicigSi_Tg5"(i64 1, %Ts28__ContiguousArrayStorageBaseC* %42), !dbg !65
  %._value7 = getelementptr inbounds %TSi, %TSi* %4, i32 0, i32 0, !dbg !65
  %46 = ptrtoint i64* %._value7 to i64
  call void @__dp_write(i32 16398, i64 %46, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  store i64 %45, i64* %._value7, align 8, !dbg !65
  %._value8 = getelementptr inbounds %TSi, %TSi* %4, i32 0, i32 0, !dbg !65
  %47 = ptrtoint i64* %._value8 to i64
  call void @__dp_read(i32 16398, i64 %47, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))
  %48 = load i64, i64* %._value8, align 8, !dbg !65
  %loc._value9 = getelementptr inbounds %TSi, %TSi* %loc, i32 0, i32 0, !dbg !65
  %49 = ptrtoint i64* %loc._value9 to i64
  call void @__dp_write(i32 16398, i64 %49, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0))
  store i64 %48, i64* %loc._value9, align 8, !dbg !65
  %50 = bitcast %TSi* %4 to i8*, !dbg !65
  call void @__dp_call(i32 16398), !dbg !65
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %50), !dbg !65
  %51 = getelementptr inbounds [32 x i8], [32 x i8]* %5, i32 0, i32 0, !dbg !66
  call void @__dp_call(i32 16399), !dbg !66
  call void @llvm.lifetime.start.p0i8(i64 32, i8* %51), !dbg !66
  call void @__dp_call(i32 16399), !dbg !66
  %52 = call swiftcc { i8*, %TSi* } @"$sSayxSiciMSi_Tg5"(i8* noalias dereferenceable(32) %51, i64 1, %TSa* nocapture swiftself dereferenceable(8) %locArr), !dbg !66
  %53 = extractvalue { i8*, %TSi* } %52, 0, !dbg !66
  %54 = extractvalue { i8*, %TSi* } %52, 1, !dbg !66
  %._value10 = getelementptr inbounds %TSi, %TSi* %54, i32 0, i32 0, !dbg !66
  %55 = ptrtoint i64* %._value10 to i64
  call void @__dp_write(i32 16399, i64 %55, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0))
  store i64 0, i64* %._value10, align 8, !dbg !66
  %56 = bitcast i8* %53 to void (i8*, i1)*, !dbg !66
  call void @__dp_call(i32 16399), !dbg !66
  call swiftcc void %56(i8* noalias dereferenceable(32) %51, i1 false), !dbg !66
  call void @__dp_call(i32 16399), !dbg !66
  call void @llvm.lifetime.end.p0i8(i64 32, i8* %51), !dbg !66
  %57 = getelementptr inbounds [32 x i8], [32 x i8]* %6, i32 0, i32 0, !dbg !67
  call void @__dp_call(i32 16400), !dbg !67
  call void @llvm.lifetime.start.p0i8(i64 32, i8* %57), !dbg !67
  call void @__dp_call(i32 16400), !dbg !67
  %58 = call swiftcc { i8*, %TSi* } @"$sSayxSiciMSi_Tg5"(i8* noalias dereferenceable(32) %57, i64 2, %TSa* nocapture swiftself dereferenceable(8) %locArr), !dbg !67
  %59 = extractvalue { i8*, %TSi* } %58, 0, !dbg !67
  %60 = extractvalue { i8*, %TSi* } %58, 1, !dbg !67
  %._value11 = getelementptr inbounds %TSi, %TSi* %60, i32 0, i32 0, !dbg !67
  %61 = ptrtoint i64* %._value11 to i64
  call void @__dp_write(i32 16400, i64 %61, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0))
  store i64 0, i64* %._value11, align 8, !dbg !67
  %62 = bitcast i8* %59 to void (i8*, i1)*, !dbg !67
  call void @__dp_call(i32 16400), !dbg !67
  call swiftcc void %62(i8* noalias dereferenceable(32) %57, i1 false), !dbg !67
  call void @__dp_call(i32 16400), !dbg !67
  call void @llvm.lifetime.end.p0i8(i64 32, i8* %57), !dbg !67
  call void @__dp_call(i32 16402), !dbg !68
  %63 = call %TSa* @"$sSaySiGWOh"(%TSa* %locArr), !dbg !68
  %64 = bitcast %TSa* %locArr to i8*, !dbg !68
  call void @__dp_call(i32 16402), !dbg !68
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %64), !dbg !68
  %65 = bitcast %TSi* %loc to i8*, !dbg !68
  call void @__dp_call(i32 16402), !dbg !68
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %65), !dbg !68
  call void @__dp_func_exit(i32 16402, i32 0), !dbg !68
  ret void, !dbg !68
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1) #2

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #5

; Function Attrs: noinline nounwind
define linkonce_odr hidden %TSa* @"$sSaySiGWOh"(%TSa*) #6 !dbg !69 {
entry:
  %._buffer = getelementptr inbounds %TSa, %TSa* %0, i32 0, i32 0, !dbg !71
  %._buffer._storage = getelementptr inbounds %Ts22_ContiguousArrayBufferV, %Ts22_ContiguousArrayBufferV* %._buffer, i32 0, i32 0, !dbg !71
  %toDestroy = load %Ts28__ContiguousArrayStorageBaseC*, %Ts28__ContiguousArrayStorageBaseC** %._buffer._storage, align 8, !dbg !71
  call void bitcast (void (%swift.refcounted*)* @swift_release to void (%Ts28__ContiguousArrayStorageBaseC*)*)(%Ts28__ContiguousArrayStorageBaseC* %toDestroy) #3, !dbg !71
  ret %TSa* %0, !dbg !71
}

; Function Attrs: nounwind
declare void @swift_release(%swift.refcounted*) #3

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
!44 = !DILocation(line: 21, column: 1, scope: !45)
!45 = distinct !DILexicalBlock(scope: !28, file: !3, line: 21, column: 1)
!46 = distinct !DISubprogram(name: "accessLocally", linkageName: "$s9reduction13accessLocallyyyF", scope: !2, file: !3, line: 9, type: !47, scopeLine: 9, spFlags: DISPFlagDefinition, unit: !11, retainedNodes: !6)
!47 = !DISubroutineType(types: !48)
!48 = !{!49}
!49 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "$sytD", file: !3, elements: !6, runtimeLang: DW_LANG_Swift, identifier: "$sytD")
!50 = !DILocalVariable(name: "loc", scope: !51, file: !3, line: 10, type: !9)
!51 = distinct !DILexicalBlock(scope: !46, file: !3, line: 9, column: 22)
!52 = !DILocation(line: 10, column: 6, scope: !51)
!53 = !DILocalVariable(name: "locArr", scope: !51, file: !3, line: 11, type: !4)
!54 = !DILocation(line: 11, column: 6, scope: !51)
!55 = !DILocation(line: 0, scope: !56)
!56 = !DILexicalBlockFile(scope: !51, file: !57, discriminator: 0)
!57 = !DIFile(filename: "<compiler-generated>", directory: "")
!58 = !DILocation(line: 10, column: 15, scope: !51)
!59 = !DILocation(line: 11, column: 16, scope: !51)
!60 = !DILocation(line: 11, column: 19, scope: !51)
!61 = !DILocation(line: 11, column: 22, scope: !51)
!62 = !DILocation(line: 11, column: 15, scope: !51)
!63 = !DILocation(line: 12, column: 9, scope: !51)
!64 = !DILocation(line: 13, column: 12, scope: !51)
!65 = !DILocation(line: 14, column: 6, scope: !51)
!66 = !DILocation(line: 15, column: 12, scope: !51)
!67 = !DILocation(line: 16, column: 12, scope: !51)
!68 = !DILocation(line: 18, column: 1, scope: !51)
!69 = distinct !DISubprogram(linkageName: "$sSaySiGWOh", scope: !2, file: !57, type: !70, flags: DIFlagArtificial, spFlags: DISPFlagDefinition, unit: !11, retainedNodes: !6)
!70 = !DISubroutineType(types: null)
!71 = !DILocation(line: 0, scope: !69)