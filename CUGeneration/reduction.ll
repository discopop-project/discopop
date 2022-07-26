; ModuleID = 'reduction.ll'
source_filename = "reduction.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%TSi = type <{ i64 }>
%Ts16IndexingIteratorVySNySiGG = type <{ %TSNySiG, %TSNsSxRzSZ6StrideRpzrlE5IndexOySi_G }>
%TSNySiG = type <{ %TSi, %TSi }>
%TSNsSxRzSZ6StrideRpzrlE5IndexOySi_G = type <{ [8 x i8], [1 x i8] }>
%TSiSg = type <{ [8 x i8], [1 x i8] }>

@__swift_reflection_version = linkonce_odr hidden constant i16 3
@_swift1_autolink_entries = private constant [37 x i8] c"-lswiftSwiftOnoneSupport\00-lswiftCore\00", section ".swift1_autolink_entries", align 8
@llvm.used = appending global [2 x i8*] [i8* bitcast (i16* @__swift_reflection_version to i8*), i8* getelementptr inbounds ([37 x i8], [37 x i8]* @_swift1_autolink_entries, i32 0, i32 0)], section "llvm.metadata", align 8

define protected i32 @main(i32, i8**) #0 !dbg !20 {
entry:
  %2 = bitcast i8** %1 to i8*
  call swiftcc void @"$s9reduction0A3_opyyF"(), !dbg !26
  call void @loop_counter_output(), !dbg !26
  ret i32 0, !dbg !26
}

define hidden swiftcc void @"$s9reduction0A3_opyyF"() #0 !dbg !28 {
entry:
  %a = alloca %TSi, align 8
  call void @llvm.dbg.declare(metadata %TSi* %a, metadata !32, metadata !DIExpression()), !dbg !35
  %0 = bitcast %TSi* %a to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %0, i8 0, i64 8, i1 false)
  %b = alloca %TSi, align 8
  call void @llvm.dbg.declare(metadata %TSi* %b, metadata !36, metadata !DIExpression()), !dbg !37
  %1 = bitcast %TSi* %b to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %1, i8 0, i64 8, i1 false)
  %c = alloca %TSi, align 8
  call void @llvm.dbg.declare(metadata %TSi* %c, metadata !38, metadata !DIExpression()), !dbg !39
  %2 = bitcast %TSi* %c to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %2, i8 0, i64 8, i1 false)
  %d = alloca %TSi, align 8
  call void @llvm.dbg.declare(metadata %TSi* %d, metadata !40, metadata !DIExpression()), !dbg !41
  %3 = bitcast %TSi* %d to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %3, i8 0, i64 8, i1 false)
  %"$i$generator" = alloca %Ts16IndexingIteratorVySNySiGG, align 8
  %4 = bitcast %Ts16IndexingIteratorVySNySiGG* %"$i$generator" to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %4, i8 0, i64 25, i1 false)
  %5 = alloca %TSNySiG, align 8
  %6 = alloca %TSi, align 8
  %7 = alloca %TSi, align 8
  %8 = alloca %TSNySiG, align 8
  %9 = alloca %TSiSg, align 8
  %i.debug = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %i.debug, metadata !42, metadata !DIExpression()), !dbg !44
  %10 = bitcast i64* %i.debug to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %10, i8 0, i64 8, i1 false)
  %11 = bitcast %TSi* %a to i8*, !dbg !45
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %11), !dbg !45
  %a._value = getelementptr inbounds %TSi, %TSi* %a, i32 0, i32 0, !dbg !48
  store i64 0, i64* %a._value, align 8, !dbg !48
  %12 = bitcast %TSi* %b to i8*, !dbg !45
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %12), !dbg !45
  %b._value = getelementptr inbounds %TSi, %TSi* %b, i32 0, i32 0, !dbg !49
  store i64 0, i64* %b._value, align 8, !dbg !49
  %13 = bitcast %TSi* %c to i8*, !dbg !45
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %13), !dbg !45
  %c._value = getelementptr inbounds %TSi, %TSi* %c, i32 0, i32 0, !dbg !50
  store i64 0, i64* %c._value, align 8, !dbg !50
  %14 = bitcast %TSi* %d to i8*, !dbg !45
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %14), !dbg !45
  %d._value = getelementptr inbounds %TSi, %TSi* %d, i32 0, i32 0, !dbg !51
  store i64 0, i64* %d._value, align 8, !dbg !51
  %15 = bitcast %Ts16IndexingIteratorVySNySiGG* %"$i$generator" to i8*, !dbg !52
  call void @llvm.lifetime.start.p0i8(i64 25, i8* %15), !dbg !52
  %16 = bitcast %TSNySiG* %5 to i8*, !dbg !52
  call void @llvm.lifetime.start.p0i8(i64 16, i8* %16), !dbg !52
  br label %17, !dbg !54

; <label>:17:                                     ; preds = %entry
  br label %18, !dbg !54

; <label>:18:                                     ; preds = %17
  %19 = bitcast %TSi* %6 to i8*, !dbg !52
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %19), !dbg !52
  %._value = getelementptr inbounds %TSi, %TSi* %6, i32 0, i32 0, !dbg !54
  store i64 0, i64* %._value, align 8, !dbg !54
  %20 = bitcast %TSi* %7 to i8*, !dbg !52
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %20), !dbg !52
  %._value1 = getelementptr inbounds %TSi, %TSi* %7, i32 0, i32 0, !dbg !54
  store i64 10, i64* %._value1, align 8, !dbg !54
  %._value2 = getelementptr inbounds %TSi, %TSi* %6, i32 0, i32 0, !dbg !54
  %21 = load i64, i64* %._value2, align 8, !dbg !54
  %._value3 = getelementptr inbounds %TSi, %TSi* %7, i32 0, i32 0, !dbg !54
  %22 = load i64, i64* %._value3, align 8, !dbg !54
  %23 = call swiftcc { i64, i64 } @"$sSN15uncheckedBoundsSNyxGx5lower_x5uppert_tcfCSi_Tg5"(i64 %21, i64 %22), !dbg !54
  %24 = extractvalue { i64, i64 } %23, 0, !dbg !54
  %25 = extractvalue { i64, i64 } %23, 1, !dbg !54
  %.lowerBound = getelementptr inbounds %TSNySiG, %TSNySiG* %5, i32 0, i32 0, !dbg !54
  %.lowerBound._value = getelementptr inbounds %TSi, %TSi* %.lowerBound, i32 0, i32 0, !dbg !54
  store i64 %24, i64* %.lowerBound._value, align 8, !dbg !54
  %.upperBound = getelementptr inbounds %TSNySiG, %TSNySiG* %5, i32 0, i32 1, !dbg !54
  %.upperBound._value = getelementptr inbounds %TSi, %TSi* %.upperBound, i32 0, i32 0, !dbg !54
  store i64 %25, i64* %.upperBound._value, align 8, !dbg !54
  %26 = bitcast %TSi* %7 to i8*, !dbg !54
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %26), !dbg !54
  %27 = bitcast %TSi* %6 to i8*, !dbg !54
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %27), !dbg !54
  %.lowerBound4 = getelementptr inbounds %TSNySiG, %TSNySiG* %5, i32 0, i32 0, !dbg !54
  %.lowerBound4._value = getelementptr inbounds %TSi, %TSi* %.lowerBound4, i32 0, i32 0, !dbg !54
  %28 = load i64, i64* %.lowerBound4._value, align 8, !dbg !54
  %.upperBound5 = getelementptr inbounds %TSNySiG, %TSNySiG* %5, i32 0, i32 1, !dbg !54
  %.upperBound5._value = getelementptr inbounds %TSi, %TSi* %.upperBound5, i32 0, i32 0, !dbg !54
  %29 = load i64, i64* %.upperBound5._value, align 8, !dbg !54
  %30 = bitcast %TSNySiG* %8 to i8*, !dbg !52
  call void @llvm.lifetime.start.p0i8(i64 16, i8* %30), !dbg !52
  %.lowerBound6 = getelementptr inbounds %TSNySiG, %TSNySiG* %8, i32 0, i32 0, !dbg !54
  %.lowerBound6._value = getelementptr inbounds %TSi, %TSi* %.lowerBound6, i32 0, i32 0, !dbg !54
  store i64 %28, i64* %.lowerBound6._value, align 8, !dbg !54
  %.upperBound7 = getelementptr inbounds %TSNySiG, %TSNySiG* %8, i32 0, i32 1, !dbg !54
  %.upperBound7._value = getelementptr inbounds %TSi, %TSi* %.upperBound7, i32 0, i32 0, !dbg !54
  store i64 %29, i64* %.upperBound7._value, align 8, !dbg !54
  %.lowerBound8 = getelementptr inbounds %TSNySiG, %TSNySiG* %8, i32 0, i32 0, !dbg !55
  %.lowerBound8._value = getelementptr inbounds %TSi, %TSi* %.lowerBound8, i32 0, i32 0, !dbg !55
  %31 = load i64, i64* %.lowerBound8._value, align 8, !dbg !55
  %.upperBound9 = getelementptr inbounds %TSNySiG, %TSNySiG* %8, i32 0, i32 1, !dbg !55
  %.upperBound9._value = getelementptr inbounds %TSi, %TSi* %.upperBound9, i32 0, i32 0, !dbg !55
  %32 = load i64, i64* %.upperBound9._value, align 8, !dbg !55
  %33 = call swiftcc { i64, i64, i64, i8 } @"$sSlss16IndexingIteratorVyxG0B0RtzrlE04makeB0ACyFSNySiG_Tg5"(i64 %31, i64 %32), !dbg !55
  %34 = extractvalue { i64, i64, i64, i8 } %33, 0, !dbg !55
  %35 = extractvalue { i64, i64, i64, i8 } %33, 1, !dbg !55
  %36 = extractvalue { i64, i64, i64, i8 } %33, 2, !dbg !55
  %37 = extractvalue { i64, i64, i64, i8 } %33, 3, !dbg !55
  %38 = trunc i8 %37 to i1, !dbg !55
  %"$i$generator._elements" = getelementptr inbounds %Ts16IndexingIteratorVySNySiGG, %Ts16IndexingIteratorVySNySiGG* %"$i$generator", i32 0, i32 0, !dbg !55
  %"$i$generator._elements.lowerBound" = getelementptr inbounds %TSNySiG, %TSNySiG* %"$i$generator._elements", i32 0, i32 0, !dbg !55
  %"$i$generator._elements.lowerBound._value" = getelementptr inbounds %TSi, %TSi* %"$i$generator._elements.lowerBound", i32 0, i32 0, !dbg !55
  store i64 %34, i64* %"$i$generator._elements.lowerBound._value", align 8, !dbg !55
  %"$i$generator._elements.upperBound" = getelementptr inbounds %TSNySiG, %TSNySiG* %"$i$generator._elements", i32 0, i32 1, !dbg !55
  %"$i$generator._elements.upperBound._value" = getelementptr inbounds %TSi, %TSi* %"$i$generator._elements.upperBound", i32 0, i32 0, !dbg !55
  store i64 %35, i64* %"$i$generator._elements.upperBound._value", align 8, !dbg !55
  %"$i$generator._position" = getelementptr inbounds %Ts16IndexingIteratorVySNySiGG, %Ts16IndexingIteratorVySNySiGG* %"$i$generator", i32 0, i32 1, !dbg !55
  %39 = bitcast %TSNsSxRzSZ6StrideRpzrlE5IndexOySi_G* %"$i$generator._position" to i64*, !dbg !55
  store i64 %36, i64* %39, align 8, !dbg !55
  %40 = getelementptr inbounds %TSNsSxRzSZ6StrideRpzrlE5IndexOySi_G, %TSNsSxRzSZ6StrideRpzrlE5IndexOySi_G* %"$i$generator._position", i32 0, i32 1, !dbg !55
  %41 = bitcast [1 x i8]* %40 to i1*, !dbg !55
  store i1 %38, i1* %41, align 8, !dbg !55
  %42 = bitcast %TSNySiG* %8 to i8*, !dbg !56
  call void @llvm.lifetime.end.p0i8(i64 16, i8* %42), !dbg !56
  %43 = bitcast %TSNySiG* %5 to i8*, !dbg !56
  call void @llvm.lifetime.end.p0i8(i64 16, i8* %43), !dbg !56
  br label %44, !dbg !56

; <label>:44:                                     ; preds = %88, %18
  %45 = bitcast %TSiSg* %9 to i8*, !dbg !52
  call void @llvm.lifetime.start.p0i8(i64 9, i8* %45), !dbg !52
  %46 = call swiftcc { i64, i8 } @"$ss16IndexingIteratorV4next7ElementQzSgyFSNySiG_Tg5"(%Ts16IndexingIteratorVySNySiGG* nocapture swiftself dereferenceable(25) %"$i$generator"), !dbg !57
  %47 = extractvalue { i64, i8 } %46, 0, !dbg !57
  %48 = extractvalue { i64, i8 } %46, 1, !dbg !57
  %49 = trunc i8 %48 to i1, !dbg !57
  %50 = bitcast %TSiSg* %9 to i64*, !dbg !57
  store i64 %47, i64* %50, align 8, !dbg !57
  %51 = getelementptr inbounds %TSiSg, %TSiSg* %9, i32 0, i32 1, !dbg !57
  %52 = bitcast [1 x i8]* %51 to i1*, !dbg !57
  store i1 %49, i1* %52, align 8, !dbg !57
  %53 = bitcast %TSiSg* %9 to i64*, !dbg !57
  %54 = load i64, i64* %53, align 8, !dbg !57
  %55 = getelementptr inbounds %TSiSg, %TSiSg* %9, i32 0, i32 1, !dbg !57
  %56 = bitcast [1 x i8]* %55 to i1*, !dbg !57
  %57 = load i1, i1* %56, align 8, !dbg !57
  %58 = bitcast %TSiSg* %9 to i8*, !dbg !56
  call void @llvm.lifetime.end.p0i8(i64 9, i8* %58), !dbg !56
  br i1 %57, label %90, label %59, !dbg !56

; <label>:59:                                     ; preds = %44
  call void @incr_loop_counter(i32 1)
  br label %60, !dbg !56

; <label>:60:                                     ; preds = %59
  %61 = phi i64 [ %54, %59 ], !dbg !52
  store i64 %61, i64* %i.debug, align 8, !dbg !58
  %a._value10 = getelementptr inbounds %TSi, %TSi* %a, i32 0, i32 0, !dbg !59
  %62 = ptrtoint i64* %a._value10 to i64
  call void @add_ptr_instr_rec(i32 0, i64 1, i32 0, i64 %62)
  %63 = load i64, i64* %a._value10, align 8, !dbg !59
  %64 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %63, i64 1), !dbg !61
  %65 = extractvalue { i64, i1 } %64, 0, !dbg !61
  %66 = extractvalue { i64, i1 } %64, 1, !dbg !61
  br i1 %66, label %96, label %67, !dbg !61

; <label>:67:                                     ; preds = %60
  %a._value11 = getelementptr inbounds %TSi, %TSi* %a, i32 0, i32 0, !dbg !62
  %68 = ptrtoint i64* %a._value11 to i64
  call void @add_ptr_instr_rec(i32 0, i64 1, i32 1, i64 %68)
  store i64 %65, i64* %a._value11, align 8, !dbg !62
  %b._value12 = getelementptr inbounds %TSi, %TSi* %b, i32 0, i32 0, !dbg !63
  %69 = ptrtoint i64* %b._value12 to i64
  call void @add_ptr_instr_rec(i32 0, i64 2, i32 0, i64 %69)
  %70 = load i64, i64* %b._value12, align 8, !dbg !63
  %71 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %70, i64 4), !dbg !64
  %72 = extractvalue { i64, i1 } %71, 0, !dbg !64
  %73 = extractvalue { i64, i1 } %71, 1, !dbg !64
  br i1 %73, label %97, label %74, !dbg !64

; <label>:74:                                     ; preds = %67
  %b._value13 = getelementptr inbounds %TSi, %TSi* %b, i32 0, i32 0, !dbg !65
  %75 = ptrtoint i64* %b._value13 to i64
  call void @add_ptr_instr_rec(i32 0, i64 2, i32 1, i64 %75)
  store i64 %72, i64* %b._value13, align 8, !dbg !65
  %c._value14 = getelementptr inbounds %TSi, %TSi* %c, i32 0, i32 0, !dbg !66
  %76 = ptrtoint i64* %c._value14 to i64
  call void @add_ptr_instr_rec(i32 0, i64 3, i32 0, i64 %76)
  %77 = load i64, i64* %c._value14, align 8, !dbg !66
  %78 = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 6, i64 %77), !dbg !67
  %79 = extractvalue { i64, i1 } %78, 0, !dbg !67
  %80 = extractvalue { i64, i1 } %78, 1, !dbg !67
  br i1 %80, label %98, label %81, !dbg !67

; <label>:81:                                     ; preds = %74
  %c._value15 = getelementptr inbounds %TSi, %TSi* %c, i32 0, i32 0, !dbg !68
  %82 = ptrtoint i64* %c._value15 to i64
  call void @add_ptr_instr_rec(i32 0, i64 3, i32 1, i64 %82)
  store i64 %79, i64* %c._value15, align 8, !dbg !68
  %d._value16 = getelementptr inbounds %TSi, %TSi* %d, i32 0, i32 0, !dbg !69
  %83 = ptrtoint i64* %d._value16 to i64
  call void @add_ptr_instr_rec(i32 0, i64 4, i32 0, i64 %83)
  %84 = load i64, i64* %d._value16, align 8, !dbg !69
  %85 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %84, i64 %61), !dbg !70
  %86 = extractvalue { i64, i1 } %85, 0, !dbg !70
  %87 = extractvalue { i64, i1 } %85, 1, !dbg !70
  br i1 %87, label %99, label %88, !dbg !70

; <label>:88:                                     ; preds = %81
  %d._value17 = getelementptr inbounds %TSi, %TSi* %d, i32 0, i32 0, !dbg !71
  %89 = ptrtoint i64* %d._value17 to i64
  call void @add_ptr_instr_rec(i32 0, i64 4, i32 1, i64 %89)
  store i64 %86, i64* %d._value17, align 8, !dbg !71
  br label %44, !dbg !72

; <label>:90:                                     ; preds = %44
  %91 = bitcast %Ts16IndexingIteratorVySNySiGG* %"$i$generator" to i8*, !dbg !73
  call void @llvm.lifetime.end.p0i8(i64 25, i8* %91), !dbg !73
  %92 = bitcast %TSi* %d to i8*, !dbg !73
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %92), !dbg !73
  %93 = bitcast %TSi* %c to i8*, !dbg !73
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %93), !dbg !73
  %94 = bitcast %TSi* %b to i8*, !dbg !73
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %94), !dbg !73
  %95 = bitcast %TSi* %a to i8*, !dbg !73
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %95), !dbg !73
  ret void, !dbg !73

; <label>:96:                                     ; preds = %60
  call void @llvm.trap(), !dbg !61
  unreachable, !dbg !61

; <label>:97:                                     ; preds = %67
  call void @llvm.trap(), !dbg !64
  unreachable, !dbg !64

; <label>:98:                                     ; preds = %74
  call void @llvm.trap(), !dbg !67
  unreachable, !dbg !67

; <label>:99:                                     ; preds = %81
  call void @llvm.trap(), !dbg !70
  unreachable, !dbg !70
}

; Function Attrs: cold noreturn nounwind
declare void @llvm.trap() #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1) #2

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #3

declare swiftcc { i64, i64 } @"$sSN15uncheckedBoundsSNyxGx5lower_x5uppert_tcfCSi_Tg5"(i64, i64) #0

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #2

declare swiftcc { i64, i64, i64, i8 } @"$sSlss16IndexingIteratorVyxG0B0RtzrlE04makeB0ACyFSNySiG_Tg5"(i64, i64) #0

declare swiftcc { i64, i8 } @"$ss16IndexingIteratorV4next7ElementQzSgyFSNySiG_Tg5"(%Ts16IndexingIteratorVySNySiGG* nocapture swiftself dereferenceable(25)) #0

; Function Attrs: nounwind readnone speculatable
declare { i64, i1 } @llvm.sadd.with.overflow.i64(i64, i64) #3

; Function Attrs: nounwind readnone speculatable
declare { i64, i1 } @llvm.ssub.with.overflow.i64(i64, i64) #3

; Function Attrs: nounwind readnone speculatable
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64) #3

declare void @add_instr_rec(i32, i64, i32)

declare void @add_ptr_instr_rec(i32, i64, i32, i64)

declare void @incr_loop_counter(i32)

declare void @loop_counter_output()

attributes #0 = { "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" }
attributes #1 = { cold noreturn nounwind }
attributes #2 = { argmemonly nounwind }
attributes #3 = { nounwind readnone speculatable }

!llvm.dbg.cu = !{!0, !10}
!swift.module.flags = !{!12}
!llvm.linker.options = !{}
!llvm.module.flags = !{!13, !14, !15, !16, !17, !18}
!llvm.asan.globals = !{!19}

!0 = distinct !DICompileUnit(language: DW_LANG_Swift, file: !1, producer: "Swift version 5.1.5 (swift-5.1.5-RELEASE)", isOptimized: false, runtimeVersion: 5, emissionKind: FullDebug, enums: !2, imports: !3)
!1 = !DIFile(filename: "reduction.swift", directory: "/home/simonschmalfuss/discopop/swift/CU_comp/reduction")
!2 = !{}
!3 = !{!4, !6, !8}
!4 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !1, entity: !5, file: !1)
!5 = !DIModule(scope: null, name: "reduction")
!6 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !1, entity: !7, file: !1)
!7 = !DIModule(scope: null, name: "Swift", includePath: "/home/simonschmalfuss/swift-5.1/swift-5.1.5-RELEASE-ubuntu18.04/usr/lib/swift/linux/x86_64/Swift.swiftmodule")
!8 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !1, entity: !9, file: !1)
!9 = !DIModule(scope: null, name: "SwiftOnoneSupport", includePath: "/home/simonschmalfuss/swift-5.1/swift-5.1.5-RELEASE-ubuntu18.04/usr/lib/swift/linux/x86_64/SwiftOnoneSupport.swiftmodule")
!10 = distinct !DICompileUnit(language: DW_LANG_C99, file: !11, producer: "clang version 7.0.0 ", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, nameTableKind: None)
!11 = !DIFile(filename: "<swift-imported-modules>", directory: "/home/simonschmalfuss/discopop/swift/CU_comp/reduction")
!12 = !{!"standard-library", i1 false}
!13 = !{i32 2, !"Dwarf Version", i32 4}
!14 = !{i32 2, !"Debug Info Version", i32 3}
!15 = !{i32 1, !"wchar_size", i32 4}
!16 = !{i32 7, !"PIC Level", i32 2}
!17 = !{i32 4, !"Objective-C Garbage Collection", i32 83953408}
!18 = !{i32 1, !"Swift Version", i32 7}
!19 = !{[2 x i8*]* @llvm.used, null, null, i1 false, i1 true}
!20 = distinct !DISubprogram(name: "main", linkageName: "main", scope: !5, file: !1, line: 1, type: !21, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!21 = !DISubroutineType(types: !22)
!22 = !{!23, !23, !25}
!23 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Int32", scope: !7, file: !24, size: 32, elements: !2, runtimeLang: DW_LANG_Swift, identifier: "$ss5Int32VD")
!24 = !DIFile(filename: "swift-5.1/swift-5.1.5-RELEASE-ubuntu18.04/usr/lib/swift/linux/x86_64/Swift.swiftmodule", directory: "/home/simonschmalfuss")
!25 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "UnsafeMutablePointer", scope: !7, file: !1, size: 64, elements: !2, runtimeLang: DW_LANG_Swift, identifier: "$sSpySpys4Int8VGSgGD")
!26 = !DILocation(line: 15, column: 1, scope: !27)
!27 = distinct !DILexicalBlock(scope: !20, file: !1, line: 15, column: 1)
!28 = distinct !DISubprogram(name: "reduction_op", linkageName: "$s9reduction0A3_opyyF", scope: !5, file: !1, line: 1, type: !29, scopeLine: 1, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!29 = !DISubroutineType(types: !30)
!30 = !{!31}
!31 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "$sytD", file: !1, elements: !2, runtimeLang: DW_LANG_Swift, identifier: "$sytD")
!32 = !DILocalVariable(name: "a", scope: !33, file: !1, line: 2, type: !34)
!33 = distinct !DILexicalBlock(scope: !28, file: !1, line: 1, column: 21)
!34 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Int", scope: !7, file: !24, size: 64, elements: !2, runtimeLang: DW_LANG_Swift, identifier: "$sSiD")
!35 = !DILocation(line: 2, column: 9, scope: !33)
!36 = !DILocalVariable(name: "b", scope: !33, file: !1, line: 3, type: !34)
!37 = !DILocation(line: 3, column: 9, scope: !33)
!38 = !DILocalVariable(name: "c", scope: !33, file: !1, line: 4, type: !34)
!39 = !DILocation(line: 4, column: 9, scope: !33)
!40 = !DILocalVariable(name: "d", scope: !33, file: !1, line: 5, type: !34)
!41 = !DILocation(line: 5, column: 9, scope: !33)
!42 = !DILocalVariable(name: "i", scope: !43, file: !1, line: 7, type: !34)
!43 = distinct !DILexicalBlock(scope: !33, file: !1, line: 7, column: 1)
!44 = !DILocation(line: 7, column: 5, scope: !43)
!45 = !DILocation(line: 0, scope: !46)
!46 = !DILexicalBlockFile(scope: !33, file: !47, discriminator: 0)
!47 = !DIFile(filename: "<compiler-generated>", directory: "")
!48 = !DILocation(line: 2, column: 13, scope: !33)
!49 = !DILocation(line: 3, column: 13, scope: !33)
!50 = !DILocation(line: 4, column: 13, scope: !33)
!51 = !DILocation(line: 5, column: 13, scope: !33)
!52 = !DILocation(line: 0, scope: !53)
!53 = !DILexicalBlockFile(scope: !43, file: !47, discriminator: 0)
!54 = !DILocation(line: 7, column: 11, scope: !43)
!55 = !DILocation(line: 7, column: 10, scope: !43)
!56 = !DILocation(line: 7, column: 1, scope: !43)
!57 = !DILocation(line: 7, column: 7, scope: !43)
!58 = !DILocation(line: 0, scope: !43)
!59 = !DILocation(line: 8, column: 9, scope: !60)
!60 = distinct !DILexicalBlock(scope: !43, file: !1, line: 7, column: 17)
!61 = !DILocation(line: 8, column: 11, scope: !60)
!62 = !DILocation(line: 8, column: 7, scope: !60)
!63 = !DILocation(line: 9, column: 9, scope: !60)
!64 = !DILocation(line: 9, column: 11, scope: !60)
!65 = !DILocation(line: 9, column: 7, scope: !60)
!66 = !DILocation(line: 10, column: 13, scope: !60)
!67 = !DILocation(line: 10, column: 11, scope: !60)
!68 = !DILocation(line: 10, column: 7, scope: !60)
!69 = !DILocation(line: 11, column: 9, scope: !60)
!70 = !DILocation(line: 11, column: 11, scope: !60)
!71 = !DILocation(line: 11, column: 7, scope: !60)
!72 = !DILocation(line: 12, column: 1, scope: !43)
!73 = !DILocation(line: 13, column: 1, scope: !33)
