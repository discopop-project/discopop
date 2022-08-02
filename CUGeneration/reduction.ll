simonschmalfuss@gpu-server:~/discopop/swift/CU_comp/reduction$ cat instrumented_reduction.ll 
; ModuleID = 'reduction.ll'
source_filename = "reduction.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%TSi = type <{ i64 }>
%Ts16IndexingIteratorVySNySiGG = type <{ %TSNySiG, %TSNsSxRzSZ6StrideRpzrlE5IndexOySi_G }>
%TSNySiG = type <{ %TSi, %TSi }>
%TSNsSxRzSZ6StrideRpzrlE5IndexOySi_G = type <{ [8 x i8], [1 x i8] }>
%TSiSg = type <{ [8 x i8], [1 x i8] }>

@"$s9reduction5globlSivp" = hidden global %TSi zeroinitializer, align 8, !dbg !0
@__swift_reflection_version = linkonce_odr hidden constant i16 3
@_swift1_autolink_entries = private constant [37 x i8] c"-lswiftSwiftOnoneSupport\00-lswiftCore\00", section ".swift1_autolink_entries", align 8
@llvm.used = appending global [2 x i8*] [i8* bitcast (i16* @__swift_reflection_version to i8*), i8* getelementptr inbounds ([37 x i8], [37 x i8]* @_swift1_autolink_entries, i32 0, i32 0)], section "llvm.metadata", align 8

define protected i32 @main(i32, i8**) #0 !dbg !25 {
entry:
  %2 = bitcast i8** %1 to i8*
  store i64 0, i64* getelementptr inbounds (%TSi, %TSi* @"$s9reduction5globlSivp", i32 0, i32 0), align 8, !dbg !30
  call swiftcc void @"$s9reduction0A3_opyyF"(), !dbg !32
  call void @loop_counter_output(), !dbg !32
  ret i32 0, !dbg !32
}

define hidden swiftcc void @"$s9reduction0A3_opyyF"() #0 !dbg !34 {
entry:
  %a = alloca %TSi, align 8
  call void @llvm.dbg.declare(metadata %TSi* %a, metadata !38, metadata !DIExpression()), !dbg !40
  %0 = bitcast %TSi* %a to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %0, i8 0, i64 8, i1 false)
  %b = alloca %TSi, align 8
  call void @llvm.dbg.declare(metadata %TSi* %b, metadata !41, metadata !DIExpression()), !dbg !42
  %1 = bitcast %TSi* %b to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %1, i8 0, i64 8, i1 false)
  %c = alloca %TSi, align 8
  call void @llvm.dbg.declare(metadata %TSi* %c, metadata !43, metadata !DIExpression()), !dbg !44
  %2 = bitcast %TSi* %c to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %2, i8 0, i64 8, i1 false)
  %d = alloca %TSi, align 8
  call void @llvm.dbg.declare(metadata %TSi* %d, metadata !45, metadata !DIExpression()), !dbg !46
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
  %"$i$generator10" = alloca %Ts16IndexingIteratorVySNySiGG, align 8
  %10 = bitcast %Ts16IndexingIteratorVySNySiGG* %"$i$generator10" to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %10, i8 0, i64 25, i1 false)
  %11 = alloca %TSNySiG, align 8
  %12 = alloca %TSi, align 8
  %13 = alloca %TSi, align 8
  %14 = alloca %TSNySiG, align 8
  %15 = alloca %TSiSg, align 8
  %i.debug = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %i.debug, metadata !47, metadata !DIExpression()), !dbg !49
  %16 = bitcast i64* %i.debug to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %16, i8 0, i64 8, i1 false)
  %i.debug25 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %i.debug25, metadata !50, metadata !DIExpression()), !dbg !52
  %17 = bitcast i64* %i.debug25 to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %17, i8 0, i64 8, i1 false)
  %access-scratch = alloca [24 x i8], align 8
  %access-scratch28 = alloca [24 x i8], align 8
  %18 = bitcast %TSi* %a to i8*, !dbg !53
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %18), !dbg !53
  %a._value = getelementptr inbounds %TSi, %TSi* %a, i32 0, i32 0, !dbg !56
  store i64 0, i64* %a._value, align 8, !dbg !56
  %19 = bitcast %TSi* %b to i8*, !dbg !53
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %19), !dbg !53
  %b._value = getelementptr inbounds %TSi, %TSi* %b, i32 0, i32 0, !dbg !57
  store i64 0, i64* %b._value, align 8, !dbg !57
  %20 = bitcast %TSi* %c to i8*, !dbg !53
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %20), !dbg !53
  %c._value = getelementptr inbounds %TSi, %TSi* %c, i32 0, i32 0, !dbg !58
  store i64 0, i64* %c._value, align 8, !dbg !58
  %21 = bitcast %TSi* %d to i8*, !dbg !53
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %21), !dbg !53
  %d._value = getelementptr inbounds %TSi, %TSi* %d, i32 0, i32 0, !dbg !59
  store i64 0, i64* %d._value, align 8, !dbg !59
  %22 = bitcast %Ts16IndexingIteratorVySNySiGG* %"$i$generator" to i8*, !dbg !60
  call void @llvm.lifetime.start.p0i8(i64 25, i8* %22), !dbg !60
  %23 = bitcast %TSNySiG* %5 to i8*, !dbg !60
  call void @llvm.lifetime.start.p0i8(i64 16, i8* %23), !dbg !60
  br label %24, !dbg !62

; <label>:24:                                     ; preds = %entry
  br label %25, !dbg !62

; <label>:25:                                     ; preds = %24
  %26 = bitcast %TSi* %6 to i8*, !dbg !60
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %26), !dbg !60
  %._value = getelementptr inbounds %TSi, %TSi* %6, i32 0, i32 0, !dbg !62
  store i64 0, i64* %._value, align 8, !dbg !62
  %27 = bitcast %TSi* %7 to i8*, !dbg !60
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %27), !dbg !60
  %._value1 = getelementptr inbounds %TSi, %TSi* %7, i32 0, i32 0, !dbg !62
  store i64 10, i64* %._value1, align 8, !dbg !62
  %._value2 = getelementptr inbounds %TSi, %TSi* %6, i32 0, i32 0, !dbg !62
  %28 = load i64, i64* %._value2, align 8, !dbg !62
  %._value3 = getelementptr inbounds %TSi, %TSi* %7, i32 0, i32 0, !dbg !62
  %29 = load i64, i64* %._value3, align 8, !dbg !62
  %30 = call swiftcc { i64, i64 } @"$sSN15uncheckedBoundsSNyxGx5lower_x5uppert_tcfCSi_Tg5"(i64 %28, i64 %29), !dbg !62
  %31 = extractvalue { i64, i64 } %30, 0, !dbg !62
  %32 = extractvalue { i64, i64 } %30, 1, !dbg !62
  %.lowerBound = getelementptr inbounds %TSNySiG, %TSNySiG* %5, i32 0, i32 0, !dbg !62
  %.lowerBound._value = getelementptr inbounds %TSi, %TSi* %.lowerBound, i32 0, i32 0, !dbg !62
  store i64 %31, i64* %.lowerBound._value, align 8, !dbg !62
  %.upperBound = getelementptr inbounds %TSNySiG, %TSNySiG* %5, i32 0, i32 1, !dbg !62
  %.upperBound._value = getelementptr inbounds %TSi, %TSi* %.upperBound, i32 0, i32 0, !dbg !62
  store i64 %32, i64* %.upperBound._value, align 8, !dbg !62
  %33 = bitcast %TSi* %7 to i8*, !dbg !62
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %33), !dbg !62
  %34 = bitcast %TSi* %6 to i8*, !dbg !62
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %34), !dbg !62
  %.lowerBound4 = getelementptr inbounds %TSNySiG, %TSNySiG* %5, i32 0, i32 0, !dbg !62
  %.lowerBound4._value = getelementptr inbounds %TSi, %TSi* %.lowerBound4, i32 0, i32 0, !dbg !62
  %35 = load i64, i64* %.lowerBound4._value, align 8, !dbg !62
  %.upperBound5 = getelementptr inbounds %TSNySiG, %TSNySiG* %5, i32 0, i32 1, !dbg !62
  %.upperBound5._value = getelementptr inbounds %TSi, %TSi* %.upperBound5, i32 0, i32 0, !dbg !62
  %36 = load i64, i64* %.upperBound5._value, align 8, !dbg !62
  %37 = bitcast %TSNySiG* %8 to i8*, !dbg !60
  call void @llvm.lifetime.start.p0i8(i64 16, i8* %37), !dbg !60
  %.lowerBound6 = getelementptr inbounds %TSNySiG, %TSNySiG* %8, i32 0, i32 0, !dbg !62
  %.lowerBound6._value = getelementptr inbounds %TSi, %TSi* %.lowerBound6, i32 0, i32 0, !dbg !62
  store i64 %35, i64* %.lowerBound6._value, align 8, !dbg !62
  %.upperBound7 = getelementptr inbounds %TSNySiG, %TSNySiG* %8, i32 0, i32 1, !dbg !62
  %.upperBound7._value = getelementptr inbounds %TSi, %TSi* %.upperBound7, i32 0, i32 0, !dbg !62
  store i64 %36, i64* %.upperBound7._value, align 8, !dbg !62
  %.lowerBound8 = getelementptr inbounds %TSNySiG, %TSNySiG* %8, i32 0, i32 0, !dbg !63
  %.lowerBound8._value = getelementptr inbounds %TSi, %TSi* %.lowerBound8, i32 0, i32 0, !dbg !63
  %38 = load i64, i64* %.lowerBound8._value, align 8, !dbg !63
  %.upperBound9 = getelementptr inbounds %TSNySiG, %TSNySiG* %8, i32 0, i32 1, !dbg !63
  %.upperBound9._value = getelementptr inbounds %TSi, %TSi* %.upperBound9, i32 0, i32 0, !dbg !63
  %39 = load i64, i64* %.upperBound9._value, align 8, !dbg !63
  %40 = call swiftcc { i64, i64, i64, i8 } @"$sSlss16IndexingIteratorVyxG0B0RtzrlE04makeB0ACyFSNySiG_Tg5"(i64 %38, i64 %39), !dbg !63
  %41 = extractvalue { i64, i64, i64, i8 } %40, 0, !dbg !63
  %42 = extractvalue { i64, i64, i64, i8 } %40, 1, !dbg !63
  %43 = extractvalue { i64, i64, i64, i8 } %40, 2, !dbg !63
  %44 = extractvalue { i64, i64, i64, i8 } %40, 3, !dbg !63
  %45 = trunc i8 %44 to i1, !dbg !63
  %"$i$generator._elements" = getelementptr inbounds %Ts16IndexingIteratorVySNySiGG, %Ts16IndexingIteratorVySNySiGG* %"$i$generator", i32 0, i32 0, !dbg !63
  %"$i$generator._elements.lowerBound" = getelementptr inbounds %TSNySiG, %TSNySiG* %"$i$generator._elements", i32 0, i32 0, !dbg !63
  %"$i$generator._elements.lowerBound._value" = getelementptr inbounds %TSi, %TSi* %"$i$generator._elements.lowerBound", i32 0, i32 0, !dbg !63
  store i64 %41, i64* %"$i$generator._elements.lowerBound._value", align 8, !dbg !63
  %"$i$generator._elements.upperBound" = getelementptr inbounds %TSNySiG, %TSNySiG* %"$i$generator._elements", i32 0, i32 1, !dbg !63
  %"$i$generator._elements.upperBound._value" = getelementptr inbounds %TSi, %TSi* %"$i$generator._elements.upperBound", i32 0, i32 0, !dbg !63
  store i64 %42, i64* %"$i$generator._elements.upperBound._value", align 8, !dbg !63
  %"$i$generator._position" = getelementptr inbounds %Ts16IndexingIteratorVySNySiGG, %Ts16IndexingIteratorVySNySiGG* %"$i$generator", i32 0, i32 1, !dbg !63
  %46 = bitcast %TSNsSxRzSZ6StrideRpzrlE5IndexOySi_G* %"$i$generator._position" to i64*, !dbg !63
  store i64 %43, i64* %46, align 8, !dbg !63
  %47 = getelementptr inbounds %TSNsSxRzSZ6StrideRpzrlE5IndexOySi_G, %TSNsSxRzSZ6StrideRpzrlE5IndexOySi_G* %"$i$generator._position", i32 0, i32 1, !dbg !63
  %48 = bitcast [1 x i8]* %47 to i1*, !dbg !63
  store i1 %45, i1* %48, align 8, !dbg !63
  %49 = bitcast %TSNySiG* %8 to i8*, !dbg !64
  call void @llvm.lifetime.end.p0i8(i64 16, i8* %49), !dbg !64
  %50 = bitcast %TSNySiG* %5 to i8*, !dbg !64
  call void @llvm.lifetime.end.p0i8(i64 16, i8* %50), !dbg !64
  br label %51, !dbg !64

; <label>:51:                                     ; preds = %104, %25
  %52 = bitcast %TSiSg* %9 to i8*, !dbg !60
  call void @llvm.lifetime.start.p0i8(i64 9, i8* %52), !dbg !60
  %53 = call swiftcc { i64, i8 } @"$ss16IndexingIteratorV4next7ElementQzSgyFSNySiG_Tg5"(%Ts16IndexingIteratorVySNySiGG* nocapture swiftself dereferenceable(25) %"$i$generator"), !dbg !65
  %54 = extractvalue { i64, i8 } %53, 0, !dbg !65
  %55 = extractvalue { i64, i8 } %53, 1, !dbg !65
  %56 = trunc i8 %55 to i1, !dbg !65
  %57 = bitcast %TSiSg* %9 to i64*, !dbg !65
  store i64 %54, i64* %57, align 8, !dbg !65
  %58 = getelementptr inbounds %TSiSg, %TSiSg* %9, i32 0, i32 1, !dbg !65
  %59 = bitcast [1 x i8]* %58 to i1*, !dbg !65
  store i1 %56, i1* %59, align 8, !dbg !65
  %60 = bitcast %TSiSg* %9 to i64*, !dbg !65
  %61 = load i64, i64* %60, align 8, !dbg !65
  %62 = getelementptr inbounds %TSiSg, %TSiSg* %9, i32 0, i32 1, !dbg !65
  %63 = bitcast [1 x i8]* %62 to i1*, !dbg !65
  %64 = load i1, i1* %63, align 8, !dbg !65
  %65 = bitcast %TSiSg* %9 to i8*, !dbg !64
  call void @llvm.lifetime.end.p0i8(i64 9, i8* %65), !dbg !64
  br i1 %64, label %106, label %66, !dbg !64

; <label>:66:                                     ; preds = %51
  call void @incr_loop_counter(i32 2)
  br label %67, !dbg !64

; <label>:67:                                     ; preds = %66
  %68 = phi i64 [ %61, %66 ], !dbg !60
  store i64 %68, i64* %i.debug25, align 8, !dbg !66
  %a._value26 = getelementptr inbounds %TSi, %TSi* %a, i32 0, i32 0, !dbg !67
  %69 = ptrtoint i64* %a._value26 to i64
  call void @add_ptr_instr_rec(i32 8, i64 2, i32 0, i64 %69)
  %70 = load i64, i64* %a._value26, align 8, !dbg !67
  %71 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %70, i64 1), !dbg !69
  %72 = extractvalue { i64, i1 } %71, 0, !dbg !69
  %73 = extractvalue { i64, i1 } %71, 1, !dbg !69
  br i1 %73, label %169, label %74, !dbg !69

; <label>:74:                                     ; preds = %67
  %a._value27 = getelementptr inbounds %TSi, %TSi* %a, i32 0, i32 0, !dbg !70
  %75 = ptrtoint i64* %a._value27 to i64
  call void @add_ptr_instr_rec(i32 8, i64 2, i32 1, i64 %75)
  store i64 %72, i64* %a._value27, align 8, !dbg !70
  %76 = bitcast [24 x i8]* %access-scratch to i8*, !dbg !71
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %76), !dbg !71
  call void @swift_beginAccess(i8* bitcast (%TSi* @"$s9reduction5globlSivp" to i8*), [24 x i8]* %access-scratch, i64 32, i8* null) #4, !dbg !71
  %77 = load i64, i64* getelementptr inbounds (%TSi, %TSi* @"$s9reduction5globlSivp", i32 0, i32 0), align 8, !dbg !71
  call void @swift_endAccess([24 x i8]* %access-scratch) #4, !dbg !71
  %78 = bitcast [24 x i8]* %access-scratch to i8*, !dbg !71
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %78), !dbg !71
  %79 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %77, i64 1), !dbg !72
  %80 = extractvalue { i64, i1 } %79, 0, !dbg !72
  %81 = extractvalue { i64, i1 } %79, 1, !dbg !72
  br i1 %81, label %170, label %82, !dbg !72

; <label>:82:                                     ; preds = %74
  %83 = bitcast [24 x i8]* %access-scratch28 to i8*, !dbg !73
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %83), !dbg !73
  call void @swift_beginAccess(i8* bitcast (%TSi* @"$s9reduction5globlSivp" to i8*), [24 x i8]* %access-scratch28, i64 33, i8* null) #4, !dbg !73
  store i64 %80, i64* getelementptr inbounds (%TSi, %TSi* @"$s9reduction5globlSivp", i32 0, i32 0), align 8, !dbg !73
  call void @swift_endAccess([24 x i8]* %access-scratch28) #4, !dbg !73
  %84 = bitcast [24 x i8]* %access-scratch28 to i8*, !dbg !73
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %84), !dbg !73
  %b._value29 = getelementptr inbounds %TSi, %TSi* %b, i32 0, i32 0, !dbg !74
  %85 = ptrtoint i64* %b._value29 to i64
  call void @add_ptr_instr_rec(i32 8, i64 3, i32 0, i64 %85)
  %86 = load i64, i64* %b._value29, align 8, !dbg !74
  %87 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %86, i64 4), !dbg !75
  %88 = extractvalue { i64, i1 } %87, 0, !dbg !75
  %89 = extractvalue { i64, i1 } %87, 1, !dbg !75
  br i1 %89, label %171, label %90, !dbg !75

; <label>:90:                                     ; preds = %82
  %b._value30 = getelementptr inbounds %TSi, %TSi* %b, i32 0, i32 0, !dbg !76
  %91 = ptrtoint i64* %b._value30 to i64
  call void @add_ptr_instr_rec(i32 8, i64 3, i32 1, i64 %91)
  store i64 %88, i64* %b._value30, align 8, !dbg !76
  %c._value31 = getelementptr inbounds %TSi, %TSi* %c, i32 0, i32 0, !dbg !77
  %92 = ptrtoint i64* %c._value31 to i64
  call void @add_ptr_instr_rec(i32 8, i64 4, i32 0, i64 %92)
  %93 = load i64, i64* %c._value31, align 8, !dbg !77
  %94 = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 6, i64 %93), !dbg !78
  %95 = extractvalue { i64, i1 } %94, 0, !dbg !78
  %96 = extractvalue { i64, i1 } %94, 1, !dbg !78
  br i1 %96, label %172, label %97, !dbg !78

; <label>:97:                                     ; preds = %90
  %c._value32 = getelementptr inbounds %TSi, %TSi* %c, i32 0, i32 0, !dbg !79
  %98 = ptrtoint i64* %c._value32 to i64
  call void @add_ptr_instr_rec(i32 8, i64 4, i32 1, i64 %98)
  store i64 %95, i64* %c._value32, align 8, !dbg !79
  %d._value33 = getelementptr inbounds %TSi, %TSi* %d, i32 0, i32 0, !dbg !80
  %99 = ptrtoint i64* %d._value33 to i64
  call void @add_ptr_instr_rec(i32 8, i64 5, i32 0, i64 %99)
  %100 = load i64, i64* %d._value33, align 8, !dbg !80
  %101 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %100, i64 %68), !dbg !81
  %102 = extractvalue { i64, i1 } %101, 0, !dbg !81
  %103 = extractvalue { i64, i1 } %101, 1, !dbg !81
  br i1 %103, label %173, label %104, !dbg !81

; <label>:104:                                    ; preds = %97
  %d._value34 = getelementptr inbounds %TSi, %TSi* %d, i32 0, i32 0, !dbg !82
  %105 = ptrtoint i64* %d._value34 to i64
  call void @add_ptr_instr_rec(i32 8, i64 5, i32 1, i64 %105)
  store i64 %102, i64* %d._value34, align 8, !dbg !82
  br label %51, !dbg !83

; <label>:106:                                    ; preds = %51
  %107 = bitcast %Ts16IndexingIteratorVySNySiGG* %"$i$generator" to i8*, !dbg !53
  call void @llvm.lifetime.end.p0i8(i64 25, i8* %107), !dbg !53
  %108 = bitcast %Ts16IndexingIteratorVySNySiGG* %"$i$generator10" to i8*, !dbg !84
  call void @llvm.lifetime.start.p0i8(i64 25, i8* %108), !dbg !84
  %109 = bitcast %TSNySiG* %11 to i8*, !dbg !84
  call void @llvm.lifetime.start.p0i8(i64 16, i8* %109), !dbg !84
  br label %110, !dbg !86

; <label>:110:                                    ; preds = %106
  br label %111, !dbg !86

; <label>:111:                                    ; preds = %110
  %112 = bitcast %TSi* %12 to i8*, !dbg !84
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %112), !dbg !84
  %._value11 = getelementptr inbounds %TSi, %TSi* %12, i32 0, i32 0, !dbg !86
  store i64 0, i64* %._value11, align 8, !dbg !86
  %113 = bitcast %TSi* %13 to i8*, !dbg !84
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %113), !dbg !84
  %._value12 = getelementptr inbounds %TSi, %TSi* %13, i32 0, i32 0, !dbg !86
  store i64 1, i64* %._value12, align 8, !dbg !86
  %._value13 = getelementptr inbounds %TSi, %TSi* %12, i32 0, i32 0, !dbg !86
  %114 = load i64, i64* %._value13, align 8, !dbg !86
  %._value14 = getelementptr inbounds %TSi, %TSi* %13, i32 0, i32 0, !dbg !86
  %115 = load i64, i64* %._value14, align 8, !dbg !86
  %116 = call swiftcc { i64, i64 } @"$sSN15uncheckedBoundsSNyxGx5lower_x5uppert_tcfCSi_Tg5"(i64 %114, i64 %115), !dbg !86
  %117 = extractvalue { i64, i64 } %116, 0, !dbg !86
  %118 = extractvalue { i64, i64 } %116, 1, !dbg !86
  %.lowerBound15 = getelementptr inbounds %TSNySiG, %TSNySiG* %11, i32 0, i32 0, !dbg !86
  %.lowerBound15._value = getelementptr inbounds %TSi, %TSi* %.lowerBound15, i32 0, i32 0, !dbg !86
  store i64 %117, i64* %.lowerBound15._value, align 8, !dbg !86
  %.upperBound16 = getelementptr inbounds %TSNySiG, %TSNySiG* %11, i32 0, i32 1, !dbg !86
  %.upperBound16._value = getelementptr inbounds %TSi, %TSi* %.upperBound16, i32 0, i32 0, !dbg !86
  store i64 %118, i64* %.upperBound16._value, align 8, !dbg !86
  %119 = bitcast %TSi* %13 to i8*, !dbg !86
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %119), !dbg !86
  %120 = bitcast %TSi* %12 to i8*, !dbg !86
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %120), !dbg !86
  %.lowerBound17 = getelementptr inbounds %TSNySiG, %TSNySiG* %11, i32 0, i32 0, !dbg !86
  %.lowerBound17._value = getelementptr inbounds %TSi, %TSi* %.lowerBound17, i32 0, i32 0, !dbg !86
  %121 = load i64, i64* %.lowerBound17._value, align 8, !dbg !86
  %.upperBound18 = getelementptr inbounds %TSNySiG, %TSNySiG* %11, i32 0, i32 1, !dbg !86
  %.upperBound18._value = getelementptr inbounds %TSi, %TSi* %.upperBound18, i32 0, i32 0, !dbg !86
  %122 = load i64, i64* %.upperBound18._value, align 8, !dbg !86
  %123 = bitcast %TSNySiG* %14 to i8*, !dbg !84
  call void @llvm.lifetime.start.p0i8(i64 16, i8* %123), !dbg !84
  %.lowerBound19 = getelementptr inbounds %TSNySiG, %TSNySiG* %14, i32 0, i32 0, !dbg !86
  %.lowerBound19._value = getelementptr inbounds %TSi, %TSi* %.lowerBound19, i32 0, i32 0, !dbg !86
  store i64 %121, i64* %.lowerBound19._value, align 8, !dbg !86
  %.upperBound20 = getelementptr inbounds %TSNySiG, %TSNySiG* %14, i32 0, i32 1, !dbg !86
  %.upperBound20._value = getelementptr inbounds %TSi, %TSi* %.upperBound20, i32 0, i32 0, !dbg !86
  store i64 %122, i64* %.upperBound20._value, align 8, !dbg !86
  %.lowerBound21 = getelementptr inbounds %TSNySiG, %TSNySiG* %14, i32 0, i32 0, !dbg !87
  %.lowerBound21._value = getelementptr inbounds %TSi, %TSi* %.lowerBound21, i32 0, i32 0, !dbg !87
  %124 = load i64, i64* %.lowerBound21._value, align 8, !dbg !87
  %.upperBound22 = getelementptr inbounds %TSNySiG, %TSNySiG* %14, i32 0, i32 1, !dbg !87
  %.upperBound22._value = getelementptr inbounds %TSi, %TSi* %.upperBound22, i32 0, i32 0, !dbg !87
  %125 = load i64, i64* %.upperBound22._value, align 8, !dbg !87
  %126 = call swiftcc { i64, i64, i64, i8 } @"$sSlss16IndexingIteratorVyxG0B0RtzrlE04makeB0ACyFSNySiG_Tg5"(i64 %124, i64 %125), !dbg !87
  %127 = extractvalue { i64, i64, i64, i8 } %126, 0, !dbg !87
  %128 = extractvalue { i64, i64, i64, i8 } %126, 1, !dbg !87
  %129 = extractvalue { i64, i64, i64, i8 } %126, 2, !dbg !87
  %130 = extractvalue { i64, i64, i64, i8 } %126, 3, !dbg !87
  %131 = trunc i8 %130 to i1, !dbg !87
  %"$i$generator10._elements" = getelementptr inbounds %Ts16IndexingIteratorVySNySiGG, %Ts16IndexingIteratorVySNySiGG* %"$i$generator10", i32 0, i32 0, !dbg !87
  %"$i$generator10._elements.lowerBound" = getelementptr inbounds %TSNySiG, %TSNySiG* %"$i$generator10._elements", i32 0, i32 0, !dbg !87
  %"$i$generator10._elements.lowerBound._value" = getelementptr inbounds %TSi, %TSi* %"$i$generator10._elements.lowerBound", i32 0, i32 0, !dbg !87
  store i64 %127, i64* %"$i$generator10._elements.lowerBound._value", align 8, !dbg !87
  %"$i$generator10._elements.upperBound" = getelementptr inbounds %TSNySiG, %TSNySiG* %"$i$generator10._elements", i32 0, i32 1, !dbg !87
  %"$i$generator10._elements.upperBound._value" = getelementptr inbounds %TSi, %TSi* %"$i$generator10._elements.upperBound", i32 0, i32 0, !dbg !87
  store i64 %128, i64* %"$i$generator10._elements.upperBound._value", align 8, !dbg !87
  %"$i$generator10._position" = getelementptr inbounds %Ts16IndexingIteratorVySNySiGG, %Ts16IndexingIteratorVySNySiGG* %"$i$generator10", i32 0, i32 1, !dbg !87
  %132 = bitcast %TSNsSxRzSZ6StrideRpzrlE5IndexOySi_G* %"$i$generator10._position" to i64*, !dbg !87
  store i64 %129, i64* %132, align 8, !dbg !87
  %133 = getelementptr inbounds %TSNsSxRzSZ6StrideRpzrlE5IndexOySi_G, %TSNsSxRzSZ6StrideRpzrlE5IndexOySi_G* %"$i$generator10._position", i32 0, i32 1, !dbg !87
  %134 = bitcast [1 x i8]* %133 to i1*, !dbg !87
  store i1 %131, i1* %134, align 8, !dbg !87
  %135 = bitcast %TSNySiG* %14 to i8*, !dbg !88
  call void @llvm.lifetime.end.p0i8(i64 16, i8* %135), !dbg !88
  %136 = bitcast %TSNySiG* %11 to i8*, !dbg !88
  call void @llvm.lifetime.end.p0i8(i64 16, i8* %136), !dbg !88
  br label %137, !dbg !88

; <label>:137:                                    ; preds = %160, %111
  %138 = bitcast %TSiSg* %15 to i8*, !dbg !84
  call void @llvm.lifetime.start.p0i8(i64 9, i8* %138), !dbg !84
  %139 = call swiftcc { i64, i8 } @"$ss16IndexingIteratorV4next7ElementQzSgyFSNySiG_Tg5"(%Ts16IndexingIteratorVySNySiGG* nocapture swiftself dereferenceable(25) %"$i$generator10"), !dbg !89
  %140 = extractvalue { i64, i8 } %139, 0, !dbg !89
  %141 = extractvalue { i64, i8 } %139, 1, !dbg !89
  %142 = trunc i8 %141 to i1, !dbg !89
  %143 = bitcast %TSiSg* %15 to i64*, !dbg !89
  store i64 %140, i64* %143, align 8, !dbg !89
  %144 = getelementptr inbounds %TSiSg, %TSiSg* %15, i32 0, i32 1, !dbg !89
  %145 = bitcast [1 x i8]* %144 to i1*, !dbg !89
  store i1 %142, i1* %145, align 8, !dbg !89
  %146 = bitcast %TSiSg* %15 to i64*, !dbg !89
  %147 = load i64, i64* %146, align 8, !dbg !89
  %148 = getelementptr inbounds %TSiSg, %TSiSg* %15, i32 0, i32 1, !dbg !89
  %149 = bitcast [1 x i8]* %148 to i1*, !dbg !89
  %150 = load i1, i1* %149, align 8, !dbg !89
  %151 = bitcast %TSiSg* %15 to i8*, !dbg !88
  call void @llvm.lifetime.end.p0i8(i64 9, i8* %151), !dbg !88
  br i1 %150, label %162, label %152, !dbg !88

; <label>:152:                                    ; preds = %137
  call void @incr_loop_counter(i32 1)
  br label %153, !dbg !88

; <label>:153:                                    ; preds = %152
  %154 = phi i64 [ %147, %152 ], !dbg !84
  store i64 %154, i64* %i.debug, align 8, !dbg !90
  %a._value23 = getelementptr inbounds %TSi, %TSi* %a, i32 0, i32 0, !dbg !91
  %155 = ptrtoint i64* %a._value23 to i64
  call void @add_ptr_instr_rec(i32 16, i64 1, i32 0, i64 %155)
  %156 = load i64, i64* %a._value23, align 8, !dbg !91
  %157 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %156, i64 1), !dbg !93
  %158 = extractvalue { i64, i1 } %157, 0, !dbg !93
  %159 = extractvalue { i64, i1 } %157, 1, !dbg !93
  br i1 %159, label %168, label %160, !dbg !93

; <label>:160:                                    ; preds = %153
  %a._value24 = getelementptr inbounds %TSi, %TSi* %a, i32 0, i32 0, !dbg !94
  %161 = ptrtoint i64* %a._value24 to i64
  call void @add_ptr_instr_rec(i32 16, i64 1, i32 1, i64 %161)
  store i64 %158, i64* %a._value24, align 8, !dbg !94
  br label %137, !dbg !95

; <label>:162:                                    ; preds = %137
  %163 = bitcast %Ts16IndexingIteratorVySNySiGG* %"$i$generator10" to i8*, !dbg !96
  call void @llvm.lifetime.end.p0i8(i64 25, i8* %163), !dbg !96
  %164 = bitcast %TSi* %d to i8*, !dbg !96
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %164), !dbg !96
  %165 = bitcast %TSi* %c to i8*, !dbg !96
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %165), !dbg !96
  %166 = bitcast %TSi* %b to i8*, !dbg !96
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %166), !dbg !96
  %167 = bitcast %TSi* %a to i8*, !dbg !96
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %167), !dbg !96
  ret void, !dbg !96

; <label>:168:                                    ; preds = %153
  call void @llvm.trap(), !dbg !93
  unreachable, !dbg !93

; <label>:169:                                    ; preds = %67
  call void @llvm.trap(), !dbg !69
  unreachable, !dbg !69

; <label>:170:                                    ; preds = %74
  call void @llvm.trap(), !dbg !72
  unreachable, !dbg !72

; <label>:171:                                    ; preds = %82
  call void @llvm.trap(), !dbg !75
  unreachable, !dbg !75

; <label>:172:                                    ; preds = %90
  call void @llvm.trap(), !dbg !78
  unreachable, !dbg !78

; <label>:173:                                    ; preds = %97
  call void @llvm.trap(), !dbg !81
  unreachable, !dbg !81
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

; Function Attrs: nounwind
declare void @swift_beginAccess(i8*, [24 x i8]*, i64, i8*) #4

; Function Attrs: nounwind
declare void @swift_endAccess([24 x i8]*) #4

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
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!8, !15}
!swift.module.flags = !{!17}
!llvm.linker.options = !{}
!llvm.module.flags = !{!18, !19, !20, !21, !22, !23}
!llvm.asan.globals = !{!24}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "globl", linkageName: "$s9reduction5globlSivp", scope: !2, file: !3, line: 1, type: !4, isLocal: false, isDefinition: true)
!2 = !DIModule(scope: null, name: "reduction")
!3 = !DIFile(filename: "test.swift", directory: "/home/simonschmalfuss/discopop/swift/CU_comp/reduction")
!4 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Int", scope: !6, file: !5, size: 64, elements: !7, runtimeLang: DW_LANG_Swift, identifier: "$sSiD")
!5 = !DIFile(filename: "swift-5.1/swift-5.1.5-RELEASE-ubuntu18.04/usr/lib/swift/linux/x86_64/Swift.swiftmodule", directory: "/home/simonschmalfuss")
!6 = !DIModule(scope: null, name: "Swift", includePath: "/home/simonschmalfuss/swift-5.1/swift-5.1.5-RELEASE-ubuntu18.04/usr/lib/swift/linux/x86_64/Swift.swiftmodule")
!7 = !{}
!8 = distinct !DICompileUnit(language: DW_LANG_Swift, file: !3, producer: "Swift version 5.1.5 (swift-5.1.5-RELEASE)", isOptimized: false, runtimeVersion: 5, emissionKind: FullDebug, enums: !7, globals: !9, imports: !10)
!9 = !{!0}
!10 = !{!11, !12, !13}
!11 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !3, entity: !2, file: !3)
!12 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !3, entity: !6, file: !3)
!13 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !3, entity: !14, file: !3)
!14 = !DIModule(scope: null, name: "SwiftOnoneSupport", includePath: "/home/simonschmalfuss/swift-5.1/swift-5.1.5-RELEASE-ubuntu18.04/usr/lib/swift/linux/x86_64/SwiftOnoneSupport.swiftmodule")
!15 = distinct !DICompileUnit(language: DW_LANG_C99, file: !16, producer: "clang version 7.0.0 ", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !7, nameTableKind: None)
!16 = !DIFile(filename: "<swift-imported-modules>", directory: "/home/simonschmalfuss/discopop/swift/CU_comp/reduction")
!17 = !{!"standard-library", i1 false}
!18 = !{i32 2, !"Dwarf Version", i32 4}
!19 = !{i32 2, !"Debug Info Version", i32 3}
!20 = !{i32 1, !"wchar_size", i32 4}
!21 = !{i32 7, !"PIC Level", i32 2}
!22 = !{i32 4, !"Objective-C Garbage Collection", i32 83953408}
!23 = !{i32 1, !"Swift Version", i32 7}
!24 = !{[2 x i8*]* @llvm.used, null, null, i1 false, i1 true}
!25 = distinct !DISubprogram(name: "main", linkageName: "main", scope: !2, file: !3, line: 1, type: !26, spFlags: DISPFlagDefinition, unit: !8, retainedNodes: !7)
!26 = !DISubroutineType(types: !27)
!27 = !{!28, !28, !29}
!28 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Int32", scope: !6, file: !5, size: 32, elements: !7, runtimeLang: DW_LANG_Swift, identifier: "$ss5Int32VD")
!29 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "UnsafeMutablePointer", scope: !6, file: !3, size: 64, elements: !7, runtimeLang: DW_LANG_Swift, identifier: "$sSpySpys4Int8VGSgGD")
!30 = !DILocation(line: 1, column: 13, scope: !31)
!31 = distinct !DILexicalBlock(scope: !25, file: !3, line: 1, column: 1)
!32 = !DILocation(line: 21, column: 1, scope: !33)
!33 = distinct !DILexicalBlock(scope: !25, file: !3, line: 21, column: 1)
!34 = distinct !DISubprogram(name: "reduction_op", linkageName: "$s9reduction0A3_opyyF", scope: !2, file: !3, line: 2, type: !35, scopeLine: 2, spFlags: DISPFlagDefinition, unit: !8, retainedNodes: !7)
!35 = !DISubroutineType(types: !36)
!36 = !{!37}
!37 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "$sytD", file: !3, elements: !7, runtimeLang: DW_LANG_Swift, identifier: "$sytD")
!38 = !DILocalVariable(name: "a", scope: !39, file: !3, line: 3, type: !4)
!39 = distinct !DILexicalBlock(scope: !34, file: !3, line: 2, column: 21)
!40 = !DILocation(line: 3, column: 9, scope: !39)
!41 = !DILocalVariable(name: "b", scope: !39, file: !3, line: 4, type: !4)
!42 = !DILocation(line: 4, column: 9, scope: !39)
!43 = !DILocalVariable(name: "c", scope: !39, file: !3, line: 5, type: !4)
!44 = !DILocation(line: 5, column: 9, scope: !39)
!45 = !DILocalVariable(name: "d", scope: !39, file: !3, line: 6, type: !4)
!46 = !DILocation(line: 6, column: 9, scope: !39)
!47 = !DILocalVariable(name: "i", scope: !48, file: !3, line: 16, type: !4)
!48 = distinct !DILexicalBlock(scope: !39, file: !3, line: 16, column: 1)
!49 = !DILocation(line: 16, column: 5, scope: !48)
!50 = !DILocalVariable(name: "i", scope: !51, file: !3, line: 8, type: !4)
!51 = distinct !DILexicalBlock(scope: !39, file: !3, line: 8, column: 1)
!52 = !DILocation(line: 8, column: 5, scope: !51)
!53 = !DILocation(line: 0, scope: !54)
!54 = !DILexicalBlockFile(scope: !39, file: !55, discriminator: 0)
!55 = !DIFile(filename: "<compiler-generated>", directory: "")
!56 = !DILocation(line: 3, column: 13, scope: !39)
!57 = !DILocation(line: 4, column: 13, scope: !39)
!58 = !DILocation(line: 5, column: 13, scope: !39)
!59 = !DILocation(line: 6, column: 13, scope: !39)
!60 = !DILocation(line: 0, scope: !61)
!61 = !DILexicalBlockFile(scope: !51, file: !55, discriminator: 0)
!62 = !DILocation(line: 8, column: 11, scope: !51)
!63 = !DILocation(line: 8, column: 10, scope: !51)
!64 = !DILocation(line: 8, column: 1, scope: !51)
!65 = !DILocation(line: 8, column: 7, scope: !51)
!66 = !DILocation(line: 0, scope: !51)
!67 = !DILocation(line: 9, column: 9, scope: !68)
!68 = distinct !DILexicalBlock(scope: !51, file: !3, line: 8, column: 17)
!69 = !DILocation(line: 9, column: 11, scope: !68)
!70 = !DILocation(line: 9, column: 7, scope: !68)
!71 = !DILocation(line: 10, column: 13, scope: !68)
!72 = !DILocation(line: 10, column: 19, scope: !68)
!73 = !DILocation(line: 10, column: 11, scope: !68)
!74 = !DILocation(line: 11, column: 9, scope: !68)
!75 = !DILocation(line: 11, column: 11, scope: !68)
!76 = !DILocation(line: 11, column: 7, scope: !68)
!77 = !DILocation(line: 12, column: 13, scope: !68)
!78 = !DILocation(line: 12, column: 11, scope: !68)
!79 = !DILocation(line: 12, column: 7, scope: !68)
!80 = !DILocation(line: 13, column: 9, scope: !68)
!81 = !DILocation(line: 13, column: 11, scope: !68)
!82 = !DILocation(line: 13, column: 7, scope: !68)
!83 = !DILocation(line: 14, column: 1, scope: !51)
!84 = !DILocation(line: 0, scope: !85)
!85 = !DILexicalBlockFile(scope: !48, file: !55, discriminator: 0)
!86 = !DILocation(line: 16, column: 11, scope: !48)
!87 = !DILocation(line: 16, column: 10, scope: !48)
!88 = !DILocation(line: 16, column: 1, scope: !48)
!89 = !DILocation(line: 16, column: 7, scope: !48)
!90 = !DILocation(line: 0, scope: !48)
!91 = !DILocation(line: 17, column: 9, scope: !92)
!92 = distinct !DILexicalBlock(scope: !48, file: !3, line: 16, column: 16)
!93 = !DILocation(line: 17, column: 11, scope: !92)
!94 = !DILocation(line: 17, column: 7, scope: !92)
!95 = !DILocation(line: 18, column: 1, scope: !48)
!96 = !DILocation(line: 19, column: 1, scope: !39)
simonschmalfuss@gpu-server:~/discopop/swift/CU_comp/reduction$ 