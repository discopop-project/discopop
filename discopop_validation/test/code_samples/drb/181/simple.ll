; ModuleID = 'simple.c'
source_filename = "simple.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@matchScore = dso_local global i32 5, align 4, !dbg !0
@missmatchScore = dso_local global i32 -3, align 4, !dbg !6
@gapScore = dso_local global i32 -4, align 4, !dbg !9
@m = dso_local global i64 0, align 8, !dbg !11
@a = dso_local global i8* null, align 8, !dbg !16
@n = dso_local global i64 0, align 8, !dbg !14
@b = dso_local global i8* null, align 8, !dbg !20

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @generate() #0 !dbg !26 {
entry:
  %i = alloca i64, align 8
  %aux = alloca i32, align 4
  %aux22 = alloca i32, align 4
  %call = call i64 @time(i64* null) #5, !dbg !29
  %conv = trunc i64 %call to i32, !dbg !29
  call void @srand(i32 %conv) #5, !dbg !30
  call void @llvm.dbg.declare(metadata i64* %i, metadata !31, metadata !DIExpression()), !dbg !32
  store i64 0, i64* %i, align 8, !dbg !33
  br label %for.cond, !dbg !35

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i64, i64* %i, align 8, !dbg !36
  %1 = load i64, i64* @m, align 8, !dbg !38
  %cmp = icmp slt i64 %0, %1, !dbg !39
  br i1 %cmp, label %for.body, label %for.end, !dbg !40

for.body:                                         ; preds = %for.cond
  call void @llvm.dbg.declare(metadata i32* %aux, metadata !41, metadata !DIExpression()), !dbg !43
  %call2 = call i32 @rand() #5, !dbg !44
  %rem = srem i32 %call2, 4, !dbg !45
  store i32 %rem, i32* %aux, align 4, !dbg !43
  %2 = load i32, i32* %aux, align 4, !dbg !46
  %cmp3 = icmp eq i32 %2, 0, !dbg !48
  br i1 %cmp3, label %if.then, label %if.else, !dbg !49

if.then:                                          ; preds = %for.body
  %3 = load i8*, i8** @a, align 8, !dbg !50
  %4 = load i64, i64* %i, align 8, !dbg !51
  %arrayidx = getelementptr inbounds i8, i8* %3, i64 %4, !dbg !50
  store i8 65, i8* %arrayidx, align 1, !dbg !52
  br label %if.end17, !dbg !50

if.else:                                          ; preds = %for.body
  %5 = load i32, i32* %aux, align 4, !dbg !53
  %cmp5 = icmp eq i32 %5, 2, !dbg !55
  br i1 %cmp5, label %if.then7, label %if.else9, !dbg !56

if.then7:                                         ; preds = %if.else
  %6 = load i8*, i8** @a, align 8, !dbg !57
  %7 = load i64, i64* %i, align 8, !dbg !58
  %arrayidx8 = getelementptr inbounds i8, i8* %6, i64 %7, !dbg !57
  store i8 67, i8* %arrayidx8, align 1, !dbg !59
  br label %if.end16, !dbg !57

if.else9:                                         ; preds = %if.else
  %8 = load i32, i32* %aux, align 4, !dbg !60
  %cmp10 = icmp eq i32 %8, 3, !dbg !62
  br i1 %cmp10, label %if.then12, label %if.else14, !dbg !63

if.then12:                                        ; preds = %if.else9
  %9 = load i8*, i8** @a, align 8, !dbg !64
  %10 = load i64, i64* %i, align 8, !dbg !65
  %arrayidx13 = getelementptr inbounds i8, i8* %9, i64 %10, !dbg !64
  store i8 71, i8* %arrayidx13, align 1, !dbg !66
  br label %if.end, !dbg !64

if.else14:                                        ; preds = %if.else9
  %11 = load i8*, i8** @a, align 8, !dbg !67
  %12 = load i64, i64* %i, align 8, !dbg !68
  %arrayidx15 = getelementptr inbounds i8, i8* %11, i64 %12, !dbg !67
  store i8 84, i8* %arrayidx15, align 1, !dbg !69
  br label %if.end

if.end:                                           ; preds = %if.else14, %if.then12
  br label %if.end16

if.end16:                                         ; preds = %if.end, %if.then7
  br label %if.end17

if.end17:                                         ; preds = %if.end16, %if.then
  br label %for.inc, !dbg !70

for.inc:                                          ; preds = %if.end17
  %13 = load i64, i64* %i, align 8, !dbg !71
  %inc = add nsw i64 %13, 1, !dbg !71
  store i64 %inc, i64* %i, align 8, !dbg !71
  br label %for.cond, !dbg !72, !llvm.loop !73

for.end:                                          ; preds = %for.cond
  store i64 0, i64* %i, align 8, !dbg !75
  br label %for.cond18, !dbg !77

for.cond18:                                       ; preds = %for.inc44, %for.end
  %14 = load i64, i64* %i, align 8, !dbg !78
  %15 = load i64, i64* @n, align 8, !dbg !80
  %cmp19 = icmp slt i64 %14, %15, !dbg !81
  br i1 %cmp19, label %for.body21, label %for.end46, !dbg !82

for.body21:                                       ; preds = %for.cond18
  call void @llvm.dbg.declare(metadata i32* %aux22, metadata !83, metadata !DIExpression()), !dbg !85
  %call23 = call i32 @rand() #5, !dbg !86
  %rem24 = srem i32 %call23, 4, !dbg !87
  store i32 %rem24, i32* %aux22, align 4, !dbg !85
  %16 = load i32, i32* %aux22, align 4, !dbg !88
  %cmp25 = icmp eq i32 %16, 0, !dbg !90
  br i1 %cmp25, label %if.then27, label %if.else29, !dbg !91

if.then27:                                        ; preds = %for.body21
  %17 = load i8*, i8** @b, align 8, !dbg !92
  %18 = load i64, i64* %i, align 8, !dbg !93
  %arrayidx28 = getelementptr inbounds i8, i8* %17, i64 %18, !dbg !92
  store i8 65, i8* %arrayidx28, align 1, !dbg !94
  br label %if.end43, !dbg !92

if.else29:                                        ; preds = %for.body21
  %19 = load i32, i32* %aux22, align 4, !dbg !95
  %cmp30 = icmp eq i32 %19, 2, !dbg !97
  br i1 %cmp30, label %if.then32, label %if.else34, !dbg !98

if.then32:                                        ; preds = %if.else29
  %20 = load i8*, i8** @b, align 8, !dbg !99
  %21 = load i64, i64* %i, align 8, !dbg !100
  %arrayidx33 = getelementptr inbounds i8, i8* %20, i64 %21, !dbg !99
  store i8 67, i8* %arrayidx33, align 1, !dbg !101
  br label %if.end42, !dbg !99

if.else34:                                        ; preds = %if.else29
  %22 = load i32, i32* %aux22, align 4, !dbg !102
  %cmp35 = icmp eq i32 %22, 3, !dbg !104
  br i1 %cmp35, label %if.then37, label %if.else39, !dbg !105

if.then37:                                        ; preds = %if.else34
  %23 = load i8*, i8** @b, align 8, !dbg !106
  %24 = load i64, i64* %i, align 8, !dbg !107
  %arrayidx38 = getelementptr inbounds i8, i8* %23, i64 %24, !dbg !106
  store i8 71, i8* %arrayidx38, align 1, !dbg !108
  br label %if.end41, !dbg !106

if.else39:                                        ; preds = %if.else34
  %25 = load i8*, i8** @b, align 8, !dbg !109
  %26 = load i64, i64* %i, align 8, !dbg !110
  %arrayidx40 = getelementptr inbounds i8, i8* %25, i64 %26, !dbg !109
  store i8 84, i8* %arrayidx40, align 1, !dbg !111
  br label %if.end41

if.end41:                                         ; preds = %if.else39, %if.then37
  br label %if.end42

if.end42:                                         ; preds = %if.end41, %if.then32
  br label %if.end43

if.end43:                                         ; preds = %if.end42, %if.then27
  br label %for.inc44, !dbg !112

for.inc44:                                        ; preds = %if.end43
  %27 = load i64, i64* %i, align 8, !dbg !113
  %inc45 = add nsw i64 %27, 1, !dbg !113
  store i64 %inc45, i64* %i, align 8, !dbg !113
  br label %for.cond18, !dbg !114, !llvm.loop !115

for.end46:                                        ; preds = %for.cond18
  ret void, !dbg !117
}

; Function Attrs: nounwind
declare dso_local void @srand(i32) #1

; Function Attrs: nounwind
declare dso_local i64 @time(i64*) #1

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: nounwind
declare dso_local i32 @rand() #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i64 @nElement(i64 %i) #0 !dbg !118 {
entry:
  %retval = alloca i64, align 8
  %i.addr = alloca i64, align 8
  %min = alloca i64, align 8
  %min11 = alloca i64, align 8
  store i64 %i, i64* %i.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %i.addr, metadata !121, metadata !DIExpression()), !dbg !122
  %0 = load i64, i64* %i.addr, align 8, !dbg !123
  %1 = load i64, i64* @m, align 8, !dbg !125
  %cmp = icmp slt i64 %0, %1, !dbg !126
  br i1 %cmp, label %land.lhs.true, label %if.else, !dbg !127

land.lhs.true:                                    ; preds = %entry
  %2 = load i64, i64* %i.addr, align 8, !dbg !128
  %3 = load i64, i64* @n, align 8, !dbg !129
  %cmp1 = icmp slt i64 %2, %3, !dbg !130
  br i1 %cmp1, label %if.then, label %if.else, !dbg !131

if.then:                                          ; preds = %land.lhs.true
  %4 = load i64, i64* %i.addr, align 8, !dbg !132
  store i64 %4, i64* %retval, align 8, !dbg !134
  br label %return, !dbg !134

if.else:                                          ; preds = %land.lhs.true, %entry
  %5 = load i64, i64* %i.addr, align 8, !dbg !135
  %6 = load i64, i64* @m, align 8, !dbg !137
  %7 = load i64, i64* @n, align 8, !dbg !137
  %cmp2 = icmp sgt i64 %6, %7, !dbg !137
  br i1 %cmp2, label %cond.true, label %cond.false, !dbg !137

cond.true:                                        ; preds = %if.else
  %8 = load i64, i64* @m, align 8, !dbg !137
  br label %cond.end, !dbg !137

cond.false:                                       ; preds = %if.else
  %9 = load i64, i64* @n, align 8, !dbg !137
  br label %cond.end, !dbg !137

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i64 [ %8, %cond.true ], [ %9, %cond.false ], !dbg !137
  %cmp3 = icmp slt i64 %5, %cond, !dbg !138
  br i1 %cmp3, label %if.then4, label %if.else10, !dbg !139

if.then4:                                         ; preds = %cond.end
  call void @llvm.dbg.declare(metadata i64* %min, metadata !140, metadata !DIExpression()), !dbg !142
  %10 = load i64, i64* @m, align 8, !dbg !143
  %11 = load i64, i64* @n, align 8, !dbg !143
  %cmp5 = icmp slt i64 %10, %11, !dbg !143
  br i1 %cmp5, label %cond.true6, label %cond.false7, !dbg !143

cond.true6:                                       ; preds = %if.then4
  %12 = load i64, i64* @m, align 8, !dbg !143
  br label %cond.end8, !dbg !143

cond.false7:                                      ; preds = %if.then4
  %13 = load i64, i64* @n, align 8, !dbg !143
  br label %cond.end8, !dbg !143

cond.end8:                                        ; preds = %cond.false7, %cond.true6
  %cond9 = phi i64 [ %12, %cond.true6 ], [ %13, %cond.false7 ], !dbg !143
  store i64 %cond9, i64* %min, align 8, !dbg !142
  %14 = load i64, i64* %min, align 8, !dbg !144
  %sub = sub nsw i64 %14, 1, !dbg !145
  store i64 %sub, i64* %retval, align 8, !dbg !146
  br label %return, !dbg !146

if.else10:                                        ; preds = %cond.end
  call void @llvm.dbg.declare(metadata i64* %min11, metadata !147, metadata !DIExpression()), !dbg !149
  %15 = load i64, i64* @m, align 8, !dbg !150
  %16 = load i64, i64* @n, align 8, !dbg !150
  %cmp12 = icmp slt i64 %15, %16, !dbg !150
  br i1 %cmp12, label %cond.true13, label %cond.false14, !dbg !150

cond.true13:                                      ; preds = %if.else10
  %17 = load i64, i64* @m, align 8, !dbg !150
  br label %cond.end15, !dbg !150

cond.false14:                                     ; preds = %if.else10
  %18 = load i64, i64* @n, align 8, !dbg !150
  br label %cond.end15, !dbg !150

cond.end15:                                       ; preds = %cond.false14, %cond.true13
  %cond16 = phi i64 [ %17, %cond.true13 ], [ %18, %cond.false14 ], !dbg !150
  store i64 %cond16, i64* %min11, align 8, !dbg !149
  %19 = load i64, i64* %min11, align 8, !dbg !151
  %mul = mul nsw i64 2, %19, !dbg !152
  %20 = load i64, i64* %i.addr, align 8, !dbg !153
  %sub17 = sub nsw i64 %mul, %20, !dbg !154
  %21 = load i64, i64* @m, align 8, !dbg !155
  %22 = load i64, i64* @n, align 8, !dbg !156
  %sub18 = sub nsw i64 %21, %22, !dbg !157
  %call = call i64 @labs(i64 %sub18) #6, !dbg !158
  %add = add nsw i64 %sub17, %call, !dbg !159
  %sub19 = sub nsw i64 %add, 2, !dbg !160
  store i64 %sub19, i64* %retval, align 8, !dbg !161
  br label %return, !dbg !161

return:                                           ; preds = %cond.end15, %cond.end8, %if.then
  %23 = load i64, i64* %retval, align 8, !dbg !162
  ret i64 %23, !dbg !162
}

; Function Attrs: nounwind readnone
declare dso_local i64 @labs(i64) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @matchMissmatchScore(i64 %i, i64 %j) #0 !dbg !163 {
entry:
  %retval = alloca i32, align 4
  %i.addr = alloca i64, align 8
  %j.addr = alloca i64, align 8
  store i64 %i, i64* %i.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %i.addr, metadata !166, metadata !DIExpression()), !dbg !167
  store i64 %j, i64* %j.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %j.addr, metadata !168, metadata !DIExpression()), !dbg !169
  %0 = load i8*, i8** @a, align 8, !dbg !170
  %1 = load i64, i64* %j.addr, align 8, !dbg !172
  %sub = sub nsw i64 %1, 1, !dbg !173
  %arrayidx = getelementptr inbounds i8, i8* %0, i64 %sub, !dbg !170
  %2 = load i8, i8* %arrayidx, align 1, !dbg !170
  %conv = sext i8 %2 to i32, !dbg !170
  %3 = load i8*, i8** @b, align 8, !dbg !174
  %4 = load i64, i64* %i.addr, align 8, !dbg !175
  %sub1 = sub nsw i64 %4, 1, !dbg !176
  %arrayidx2 = getelementptr inbounds i8, i8* %3, i64 %sub1, !dbg !174
  %5 = load i8, i8* %arrayidx2, align 1, !dbg !174
  %conv3 = sext i8 %5 to i32, !dbg !174
  %cmp = icmp eq i32 %conv, %conv3, !dbg !177
  br i1 %cmp, label %if.then, label %if.else, !dbg !178

if.then:                                          ; preds = %entry
  %6 = load i32, i32* @matchScore, align 4, !dbg !179
  store i32 %6, i32* %retval, align 4, !dbg !180
  br label %return, !dbg !180

if.else:                                          ; preds = %entry
  %7 = load i32, i32* @missmatchScore, align 4, !dbg !181
  store i32 %7, i32* %retval, align 4, !dbg !182
  br label %return, !dbg !182

return:                                           ; preds = %if.else, %if.then
  %8 = load i32, i32* %retval, align 4, !dbg !183
  ret i32 %8, !dbg !183
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @similarityScore(i64 %i, i64 %j, i32* %H, i32* %P, i64* %maxPos) #0 !dbg !184 {
entry:
  %i.addr = alloca i64, align 8
  %j.addr = alloca i64, align 8
  %H.addr = alloca i32*, align 8
  %P.addr = alloca i32*, align 8
  %maxPos.addr = alloca i64*, align 8
  %up = alloca i32, align 4
  %left = alloca i32, align 4
  %diag = alloca i32, align 4
  %index = alloca i64, align 8
  %max = alloca i32, align 4
  %pred = alloca i32, align 4
  store i64 %i, i64* %i.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %i.addr, metadata !189, metadata !DIExpression()), !dbg !190
  store i64 %j, i64* %j.addr, align 8
  call void @llvm.dbg.declare(metadata i64* %j.addr, metadata !191, metadata !DIExpression()), !dbg !192
  store i32* %H, i32** %H.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %H.addr, metadata !193, metadata !DIExpression()), !dbg !194
  store i32* %P, i32** %P.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %P.addr, metadata !195, metadata !DIExpression()), !dbg !196
  store i64* %maxPos, i64** %maxPos.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %maxPos.addr, metadata !197, metadata !DIExpression()), !dbg !198
  call void @llvm.dbg.declare(metadata i32* %up, metadata !199, metadata !DIExpression()), !dbg !200
  call void @llvm.dbg.declare(metadata i32* %left, metadata !201, metadata !DIExpression()), !dbg !202
  call void @llvm.dbg.declare(metadata i32* %diag, metadata !203, metadata !DIExpression()), !dbg !204
  call void @llvm.dbg.declare(metadata i64* %index, metadata !205, metadata !DIExpression()), !dbg !206
  %0 = load i64, i64* @m, align 8, !dbg !207
  %1 = load i64, i64* %i.addr, align 8, !dbg !208
  %mul = mul nsw i64 %0, %1, !dbg !209
  %2 = load i64, i64* %j.addr, align 8, !dbg !210
  %add = add nsw i64 %mul, %2, !dbg !211
  store i64 %add, i64* %index, align 8, !dbg !206
  %3 = load i32*, i32** %H.addr, align 8, !dbg !212
  %4 = load i64, i64* %index, align 8, !dbg !213
  %5 = load i64, i64* @m, align 8, !dbg !214
  %sub = sub nsw i64 %4, %5, !dbg !215
  %arrayidx = getelementptr inbounds i32, i32* %3, i64 %sub, !dbg !212
  %6 = load i32, i32* %arrayidx, align 4, !dbg !212
  %7 = load i32, i32* @gapScore, align 4, !dbg !216
  %add1 = add nsw i32 %6, %7, !dbg !217
  store i32 %add1, i32* %up, align 4, !dbg !218
  %8 = load i32*, i32** %H.addr, align 8, !dbg !219
  %9 = load i64, i64* %index, align 8, !dbg !220
  %sub2 = sub nsw i64 %9, 1, !dbg !221
  %arrayidx3 = getelementptr inbounds i32, i32* %8, i64 %sub2, !dbg !219
  %10 = load i32, i32* %arrayidx3, align 4, !dbg !219
  %11 = load i32, i32* @gapScore, align 4, !dbg !222
  %add4 = add nsw i32 %10, %11, !dbg !223
  store i32 %add4, i32* %left, align 4, !dbg !224
  %12 = load i32*, i32** %H.addr, align 8, !dbg !225
  %13 = load i64, i64* %index, align 8, !dbg !226
  %14 = load i64, i64* @m, align 8, !dbg !227
  %sub5 = sub nsw i64 %13, %14, !dbg !228
  %sub6 = sub nsw i64 %sub5, 1, !dbg !229
  %arrayidx7 = getelementptr inbounds i32, i32* %12, i64 %sub6, !dbg !225
  %15 = load i32, i32* %arrayidx7, align 4, !dbg !225
  %16 = load i64, i64* %i.addr, align 8, !dbg !230
  %17 = load i64, i64* %j.addr, align 8, !dbg !231
  %call = call i32 @matchMissmatchScore(i64 %16, i64 %17), !dbg !232
  %add8 = add nsw i32 %15, %call, !dbg !233
  store i32 %add8, i32* %diag, align 4, !dbg !234
  call void @llvm.dbg.declare(metadata i32* %max, metadata !235, metadata !DIExpression()), !dbg !236
  store i32 0, i32* %max, align 4, !dbg !236
  call void @llvm.dbg.declare(metadata i32* %pred, metadata !237, metadata !DIExpression()), !dbg !238
  store i32 0, i32* %pred, align 4, !dbg !238
  %18 = load i32, i32* %diag, align 4, !dbg !239
  %19 = load i32, i32* %max, align 4, !dbg !241
  %cmp = icmp sgt i32 %18, %19, !dbg !242
  br i1 %cmp, label %if.then, label %if.end, !dbg !243

if.then:                                          ; preds = %entry
  %20 = load i32, i32* %diag, align 4, !dbg !244
  store i32 %20, i32* %max, align 4, !dbg !246
  store i32 3, i32* %pred, align 4, !dbg !247
  br label %if.end, !dbg !248

if.end:                                           ; preds = %if.then, %entry
  %21 = load i32, i32* %up, align 4, !dbg !249
  %22 = load i32, i32* %max, align 4, !dbg !251
  %cmp9 = icmp sgt i32 %21, %22, !dbg !252
  br i1 %cmp9, label %if.then10, label %if.end11, !dbg !253

if.then10:                                        ; preds = %if.end
  %23 = load i32, i32* %up, align 4, !dbg !254
  store i32 %23, i32* %max, align 4, !dbg !256
  store i32 1, i32* %pred, align 4, !dbg !257
  br label %if.end11, !dbg !258

if.end11:                                         ; preds = %if.then10, %if.end
  %24 = load i32, i32* %left, align 4, !dbg !259
  %25 = load i32, i32* %max, align 4, !dbg !261
  %cmp12 = icmp sgt i32 %24, %25, !dbg !262
  br i1 %cmp12, label %if.then13, label %if.end14, !dbg !263

if.then13:                                        ; preds = %if.end11
  %26 = load i32, i32* %left, align 4, !dbg !264
  store i32 %26, i32* %max, align 4, !dbg !266
  store i32 2, i32* %pred, align 4, !dbg !267
  br label %if.end14, !dbg !268

if.end14:                                         ; preds = %if.then13, %if.end11
  %27 = load i32, i32* %max, align 4, !dbg !269
  %28 = load i32*, i32** %H.addr, align 8, !dbg !270
  %29 = load i64, i64* %index, align 8, !dbg !271
  %arrayidx15 = getelementptr inbounds i32, i32* %28, i64 %29, !dbg !270
  store i32 %27, i32* %arrayidx15, align 4, !dbg !272
  %30 = load i32, i32* %pred, align 4, !dbg !273
  %31 = load i32*, i32** %P.addr, align 8, !dbg !274
  %32 = load i64, i64* %index, align 8, !dbg !275
  %arrayidx16 = getelementptr inbounds i32, i32* %31, i64 %32, !dbg !274
  store i32 %30, i32* %arrayidx16, align 4, !dbg !276
  %33 = load i32, i32* %max, align 4, !dbg !277
  %34 = load i32*, i32** %H.addr, align 8, !dbg !279
  %35 = load i64*, i64** %maxPos.addr, align 8, !dbg !280
  %36 = load i64, i64* %35, align 8, !dbg !281
  %arrayidx17 = getelementptr inbounds i32, i32* %34, i64 %36, !dbg !279
  %37 = load i32, i32* %arrayidx17, align 4, !dbg !279
  %cmp18 = icmp sgt i32 %33, %37, !dbg !282
  br i1 %cmp18, label %if.then19, label %if.end20, !dbg !283

if.then19:                                        ; preds = %if.end14
  %38 = load i64, i64* %index, align 8, !dbg !284
  %39 = load i64*, i64** %maxPos.addr, align 8, !dbg !286
  store i64 %38, i64* %39, align 8, !dbg !287
  br label %if.end20, !dbg !288

if.end20:                                         ; preds = %if.then19, %if.end14
  ret void, !dbg !289
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @calcFirstDiagElement(i64* %i, i64* %si, i64* %sj) #0 !dbg !290 {
entry:
  %i.addr = alloca i64*, align 8
  %si.addr = alloca i64*, align 8
  %sj.addr = alloca i64*, align 8
  store i64* %i, i64** %i.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %i.addr, metadata !293, metadata !DIExpression()), !dbg !294
  store i64* %si, i64** %si.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %si.addr, metadata !295, metadata !DIExpression()), !dbg !296
  store i64* %sj, i64** %sj.addr, align 8
  call void @llvm.dbg.declare(metadata i64** %sj.addr, metadata !297, metadata !DIExpression()), !dbg !298
  %0 = load i64*, i64** %i.addr, align 8, !dbg !299
  %1 = load i64, i64* %0, align 8, !dbg !301
  %2 = load i64, i64* @n, align 8, !dbg !302
  %cmp = icmp slt i64 %1, %2, !dbg !303
  br i1 %cmp, label %if.then, label %if.else, !dbg !304

if.then:                                          ; preds = %entry
  %3 = load i64*, i64** %i.addr, align 8, !dbg !305
  %4 = load i64, i64* %3, align 8, !dbg !307
  %5 = load i64*, i64** %si.addr, align 8, !dbg !308
  store i64 %4, i64* %5, align 8, !dbg !309
  %6 = load i64*, i64** %sj.addr, align 8, !dbg !310
  store i64 1, i64* %6, align 8, !dbg !311
  br label %if.end, !dbg !312

if.else:                                          ; preds = %entry
  %7 = load i64, i64* @n, align 8, !dbg !313
  %sub = sub nsw i64 %7, 1, !dbg !315
  %8 = load i64*, i64** %si.addr, align 8, !dbg !316
  store i64 %sub, i64* %8, align 8, !dbg !317
  %9 = load i64*, i64** %i.addr, align 8, !dbg !318
  %10 = load i64, i64* %9, align 8, !dbg !319
  %11 = load i64, i64* @n, align 8, !dbg !320
  %sub1 = sub nsw i64 %10, %11, !dbg !321
  %add = add nsw i64 %sub1, 2, !dbg !322
  %12 = load i64*, i64** %sj.addr, align 8, !dbg !323
  store i64 %add, i64* %12, align 8, !dbg !324
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  ret void, !dbg !325
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !326 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %H = alloca i32*, align 8
  %P = alloca i32*, align 8
  %maxPos = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %initialTime = alloca double, align 8
  %si = alloca i64, align 8
  %sj = alloca i64, align 8
  %ai = alloca i64, align 8
  %aj = alloca i64, align 8
  %nDiag = alloca i64, align 8
  %nEle = alloca i64, align 8
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !330, metadata !DIExpression()), !dbg !331
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !332, metadata !DIExpression()), !dbg !333
  store i64 2048, i64* @m, align 8, !dbg !334
  store i64 2048, i64* @n, align 8, !dbg !335
  %0 = load i64, i64* @m, align 8, !dbg !336
  %mul = mul i64 %0, 1, !dbg !337
  %call = call noalias i8* @malloc(i64 %mul) #5, !dbg !338
  store i8* %call, i8** @a, align 8, !dbg !339
  %1 = load i64, i64* @n, align 8, !dbg !340
  %mul1 = mul i64 %1, 1, !dbg !341
  %call2 = call noalias i8* @malloc(i64 %mul1) #5, !dbg !342
  store i8* %call2, i8** @b, align 8, !dbg !343
  %2 = load i64, i64* @m, align 8, !dbg !344
  %inc = add nsw i64 %2, 1, !dbg !344
  store i64 %inc, i64* @m, align 8, !dbg !344
  %3 = load i64, i64* @n, align 8, !dbg !345
  %inc3 = add nsw i64 %3, 1, !dbg !345
  store i64 %inc3, i64* @n, align 8, !dbg !345
  call void @llvm.dbg.declare(metadata i32** %H, metadata !346, metadata !DIExpression()), !dbg !347
  %4 = load i64, i64* @m, align 8, !dbg !348
  %5 = load i64, i64* @n, align 8, !dbg !349
  %mul4 = mul nsw i64 %4, %5, !dbg !350
  %call5 = call noalias i8* @calloc(i64 %mul4, i64 4) #5, !dbg !351
  %6 = bitcast i8* %call5 to i32*, !dbg !351
  store i32* %6, i32** %H, align 8, !dbg !352
  call void @llvm.dbg.declare(metadata i32** %P, metadata !353, metadata !DIExpression()), !dbg !354
  %7 = load i64, i64* @m, align 8, !dbg !355
  %8 = load i64, i64* @n, align 8, !dbg !356
  %mul6 = mul nsw i64 %7, %8, !dbg !357
  %call7 = call noalias i8* @calloc(i64 %mul6, i64 4) #5, !dbg !358
  %9 = bitcast i8* %call7 to i32*, !dbg !358
  store i32* %9, i32** %P, align 8, !dbg !359
  call void @generate(), !dbg !360
  call void @llvm.dbg.declare(metadata i64* %maxPos, metadata !361, metadata !DIExpression()), !dbg !362
  store i64 0, i64* %maxPos, align 8, !dbg !362
  call void @llvm.dbg.declare(metadata i64* %i, metadata !363, metadata !DIExpression()), !dbg !364
  call void @llvm.dbg.declare(metadata i64* %j, metadata !365, metadata !DIExpression()), !dbg !366
  call void @llvm.dbg.declare(metadata double* %initialTime, metadata !367, metadata !DIExpression()), !dbg !369
  %call8 = call double @omp_get_wtime(), !dbg !370
  store double %call8, double* %initialTime, align 8, !dbg !369
  call void @llvm.dbg.declare(metadata i64* %si, metadata !371, metadata !DIExpression()), !dbg !372
  call void @llvm.dbg.declare(metadata i64* %sj, metadata !373, metadata !DIExpression()), !dbg !374
  call void @llvm.dbg.declare(metadata i64* %ai, metadata !375, metadata !DIExpression()), !dbg !376
  call void @llvm.dbg.declare(metadata i64* %aj, metadata !377, metadata !DIExpression()), !dbg !378
  call void @llvm.dbg.declare(metadata i64* %nDiag, metadata !379, metadata !DIExpression()), !dbg !380
  %10 = load i64, i64* @m, align 8, !dbg !381
  %11 = load i64, i64* @n, align 8, !dbg !382
  %add = add nsw i64 %10, %11, !dbg !383
  %sub = sub nsw i64 %add, 3, !dbg !384
  store i64 %sub, i64* %nDiag, align 8, !dbg !380
  call void @llvm.dbg.declare(metadata i64* %nEle, metadata !385, metadata !DIExpression()), !dbg !386
  store i64 1, i64* %i, align 8, !dbg !387
  br label %for.cond, !dbg !390

for.cond:                                         ; preds = %for.inc18, %entry
  %12 = load i64, i64* %i, align 8, !dbg !391
  %13 = load i64, i64* %nDiag, align 8, !dbg !393
  %cmp = icmp sle i64 %12, %13, !dbg !394
  br i1 %cmp, label %for.body, label %for.end20, !dbg !395

for.body:                                         ; preds = %for.cond
  %14 = load i64, i64* %i, align 8, !dbg !396
  %call9 = call i64 @nElement(i64 %14), !dbg !398
  store i64 %call9, i64* %nEle, align 8, !dbg !399
  call void @calcFirstDiagElement(i64* %i, i64* %si, i64* %sj), !dbg !400
  store i64 1, i64* %j, align 8, !dbg !401
  br label %for.cond10, !dbg !403

for.cond10:                                       ; preds = %for.inc, %for.body
  %15 = load i64, i64* %j, align 8, !dbg !404
  %16 = load i64, i64* %nEle, align 8, !dbg !406
  %cmp11 = icmp sle i64 %15, %16, !dbg !407
  br i1 %cmp11, label %for.body12, label %for.end, !dbg !408

for.body12:                                       ; preds = %for.cond10
  %17 = load i64, i64* %si, align 8, !dbg !409
  %18 = load i64, i64* %j, align 8, !dbg !411
  %sub13 = sub nsw i64 %17, %18, !dbg !412
  %add14 = add nsw i64 %sub13, 1, !dbg !413
  store i64 %add14, i64* %ai, align 8, !dbg !414
  %19 = load i64, i64* %sj, align 8, !dbg !415
  %20 = load i64, i64* %j, align 8, !dbg !416
  %add15 = add nsw i64 %19, %20, !dbg !417
  %sub16 = sub nsw i64 %add15, 1, !dbg !418
  store i64 %sub16, i64* %aj, align 8, !dbg !419
  %21 = load i64, i64* %ai, align 8, !dbg !420
  %22 = load i64, i64* %aj, align 8, !dbg !421
  %23 = load i32*, i32** %H, align 8, !dbg !422
  %24 = load i32*, i32** %P, align 8, !dbg !423
  call void @similarityScore(i64 %21, i64 %22, i32* %23, i32* %24, i64* %maxPos), !dbg !424
  br label %for.inc, !dbg !425

for.inc:                                          ; preds = %for.body12
  %25 = load i64, i64* %j, align 8, !dbg !426
  %inc17 = add nsw i64 %25, 1, !dbg !426
  store i64 %inc17, i64* %j, align 8, !dbg !426
  br label %for.cond10, !dbg !427, !llvm.loop !428

for.end:                                          ; preds = %for.cond10
  br label %for.inc18, !dbg !430

for.inc18:                                        ; preds = %for.end
  %26 = load i64, i64* %i, align 8, !dbg !431
  %inc19 = add nsw i64 %26, 1, !dbg !431
  store i64 %inc19, i64* %i, align 8, !dbg !431
  br label %for.cond, !dbg !432, !llvm.loop !433

for.end20:                                        ; preds = %for.cond
  %27 = load i32, i32* %retval, align 4, !dbg !435
  ret i32 %27, !dbg !435
}

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64) #1

; Function Attrs: nounwind
declare dso_local noalias i8* @calloc(i64, i64) #1

declare dso_local double @omp_get_wtime() #4

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind readnone speculatable willreturn }
attributes #3 = { nounwind readnone "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind }
attributes #6 = { nounwind readnone }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!22, !23, !24}
!llvm.ident = !{!25}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "matchScore", scope: !2, file: !3, line: 50, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "simple.c", directory: "/home/lukas/git/discopop/discopop_validation/test/code_samples/drb/181")
!4 = !{}
!5 = !{!0, !6, !9, !11, !14, !16, !20}
!6 = !DIGlobalVariableExpression(var: !7, expr: !DIExpression())
!7 = distinct !DIGlobalVariable(name: "missmatchScore", scope: !2, file: !3, line: 51, type: !8, isLocal: false, isDefinition: true)
!8 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!9 = !DIGlobalVariableExpression(var: !10, expr: !DIExpression())
!10 = distinct !DIGlobalVariable(name: "gapScore", scope: !2, file: !3, line: 52, type: !8, isLocal: false, isDefinition: true)
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(name: "m", scope: !2, file: !3, line: 46, type: !13, isLocal: false, isDefinition: true)
!13 = !DIBasicType(name: "long long int", size: 64, encoding: DW_ATE_signed)
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(name: "n", scope: !2, file: !3, line: 47, type: !13, isLocal: false, isDefinition: true)
!16 = !DIGlobalVariableExpression(var: !17, expr: !DIExpression())
!17 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 55, type: !18, isLocal: false, isDefinition: true)
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!19 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!20 = !DIGlobalVariableExpression(var: !21, expr: !DIExpression())
!21 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !3, line: 55, type: !18, isLocal: false, isDefinition: true)
!22 = !{i32 7, !"Dwarf Version", i32 4}
!23 = !{i32 2, !"Debug Info Version", i32 3}
!24 = !{i32 1, !"wchar_size", i32 4}
!25 = !{!"Ubuntu clang version 11.1.0-6"}
!26 = distinct !DISubprogram(name: "generate", scope: !3, file: !3, line: 58, type: !27, scopeLine: 58, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!27 = !DISubroutineType(types: !28)
!28 = !{null}
!29 = !DILocation(line: 60, column: 11, scope: !26)
!30 = !DILocation(line: 60, column: 5, scope: !26)
!31 = !DILocalVariable(name: "i", scope: !26, file: !3, line: 63, type: !13)
!32 = !DILocation(line: 63, column: 19, scope: !26)
!33 = !DILocation(line: 64, column: 12, scope: !34)
!34 = distinct !DILexicalBlock(scope: !26, file: !3, line: 64, column: 5)
!35 = !DILocation(line: 64, column: 10, scope: !34)
!36 = !DILocation(line: 64, column: 17, scope: !37)
!37 = distinct !DILexicalBlock(scope: !34, file: !3, line: 64, column: 5)
!38 = !DILocation(line: 64, column: 21, scope: !37)
!39 = !DILocation(line: 64, column: 19, scope: !37)
!40 = !DILocation(line: 64, column: 5, scope: !34)
!41 = !DILocalVariable(name: "aux", scope: !42, file: !3, line: 65, type: !8)
!42 = distinct !DILexicalBlock(scope: !37, file: !3, line: 64, column: 29)
!43 = !DILocation(line: 65, column: 13, scope: !42)
!44 = !DILocation(line: 65, column: 19, scope: !42)
!45 = !DILocation(line: 65, column: 26, scope: !42)
!46 = !DILocation(line: 66, column: 13, scope: !47)
!47 = distinct !DILexicalBlock(scope: !42, file: !3, line: 66, column: 13)
!48 = !DILocation(line: 66, column: 17, scope: !47)
!49 = !DILocation(line: 66, column: 13, scope: !42)
!50 = !DILocation(line: 67, column: 13, scope: !47)
!51 = !DILocation(line: 67, column: 15, scope: !47)
!52 = !DILocation(line: 67, column: 18, scope: !47)
!53 = !DILocation(line: 68, column: 18, scope: !54)
!54 = distinct !DILexicalBlock(scope: !47, file: !3, line: 68, column: 18)
!55 = !DILocation(line: 68, column: 22, scope: !54)
!56 = !DILocation(line: 68, column: 18, scope: !47)
!57 = !DILocation(line: 69, column: 13, scope: !54)
!58 = !DILocation(line: 69, column: 15, scope: !54)
!59 = !DILocation(line: 69, column: 18, scope: !54)
!60 = !DILocation(line: 70, column: 18, scope: !61)
!61 = distinct !DILexicalBlock(scope: !54, file: !3, line: 70, column: 18)
!62 = !DILocation(line: 70, column: 22, scope: !61)
!63 = !DILocation(line: 70, column: 18, scope: !54)
!64 = !DILocation(line: 71, column: 13, scope: !61)
!65 = !DILocation(line: 71, column: 15, scope: !61)
!66 = !DILocation(line: 71, column: 18, scope: !61)
!67 = !DILocation(line: 73, column: 13, scope: !61)
!68 = !DILocation(line: 73, column: 15, scope: !61)
!69 = !DILocation(line: 73, column: 18, scope: !61)
!70 = !DILocation(line: 74, column: 5, scope: !42)
!71 = !DILocation(line: 64, column: 25, scope: !37)
!72 = !DILocation(line: 64, column: 5, scope: !37)
!73 = distinct !{!73, !40, !74}
!74 = !DILocation(line: 74, column: 5, scope: !34)
!75 = !DILocation(line: 77, column: 12, scope: !76)
!76 = distinct !DILexicalBlock(scope: !26, file: !3, line: 77, column: 5)
!77 = !DILocation(line: 77, column: 10, scope: !76)
!78 = !DILocation(line: 77, column: 17, scope: !79)
!79 = distinct !DILexicalBlock(scope: !76, file: !3, line: 77, column: 5)
!80 = !DILocation(line: 77, column: 21, scope: !79)
!81 = !DILocation(line: 77, column: 19, scope: !79)
!82 = !DILocation(line: 77, column: 5, scope: !76)
!83 = !DILocalVariable(name: "aux", scope: !84, file: !3, line: 78, type: !8)
!84 = distinct !DILexicalBlock(scope: !79, file: !3, line: 77, column: 29)
!85 = !DILocation(line: 78, column: 13, scope: !84)
!86 = !DILocation(line: 78, column: 19, scope: !84)
!87 = !DILocation(line: 78, column: 26, scope: !84)
!88 = !DILocation(line: 79, column: 13, scope: !89)
!89 = distinct !DILexicalBlock(scope: !84, file: !3, line: 79, column: 13)
!90 = !DILocation(line: 79, column: 17, scope: !89)
!91 = !DILocation(line: 79, column: 13, scope: !84)
!92 = !DILocation(line: 80, column: 13, scope: !89)
!93 = !DILocation(line: 80, column: 15, scope: !89)
!94 = !DILocation(line: 80, column: 18, scope: !89)
!95 = !DILocation(line: 81, column: 18, scope: !96)
!96 = distinct !DILexicalBlock(scope: !89, file: !3, line: 81, column: 18)
!97 = !DILocation(line: 81, column: 22, scope: !96)
!98 = !DILocation(line: 81, column: 18, scope: !89)
!99 = !DILocation(line: 82, column: 13, scope: !96)
!100 = !DILocation(line: 82, column: 15, scope: !96)
!101 = !DILocation(line: 82, column: 18, scope: !96)
!102 = !DILocation(line: 83, column: 18, scope: !103)
!103 = distinct !DILexicalBlock(scope: !96, file: !3, line: 83, column: 18)
!104 = !DILocation(line: 83, column: 22, scope: !103)
!105 = !DILocation(line: 83, column: 18, scope: !96)
!106 = !DILocation(line: 84, column: 13, scope: !103)
!107 = !DILocation(line: 84, column: 15, scope: !103)
!108 = !DILocation(line: 84, column: 18, scope: !103)
!109 = !DILocation(line: 86, column: 13, scope: !103)
!110 = !DILocation(line: 86, column: 15, scope: !103)
!111 = !DILocation(line: 86, column: 18, scope: !103)
!112 = !DILocation(line: 87, column: 5, scope: !84)
!113 = !DILocation(line: 77, column: 25, scope: !79)
!114 = !DILocation(line: 77, column: 5, scope: !79)
!115 = distinct !{!115, !82, !116}
!116 = !DILocation(line: 87, column: 5, scope: !76)
!117 = !DILocation(line: 88, column: 1, scope: !26)
!118 = distinct !DISubprogram(name: "nElement", scope: !3, file: !3, line: 95, type: !119, scopeLine: 95, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!119 = !DISubroutineType(types: !120)
!120 = !{!13, !13}
!121 = !DILocalVariable(name: "i", arg: 1, scope: !118, file: !3, line: 95, type: !13)
!122 = !DILocation(line: 95, column: 38, scope: !118)
!123 = !DILocation(line: 96, column: 9, scope: !124)
!124 = distinct !DILexicalBlock(scope: !118, file: !3, line: 96, column: 9)
!125 = !DILocation(line: 96, column: 13, scope: !124)
!126 = !DILocation(line: 96, column: 11, scope: !124)
!127 = !DILocation(line: 96, column: 15, scope: !124)
!128 = !DILocation(line: 96, column: 18, scope: !124)
!129 = !DILocation(line: 96, column: 22, scope: !124)
!130 = !DILocation(line: 96, column: 20, scope: !124)
!131 = !DILocation(line: 96, column: 9, scope: !118)
!132 = !DILocation(line: 98, column: 16, scope: !133)
!133 = distinct !DILexicalBlock(scope: !124, file: !3, line: 96, column: 25)
!134 = !DILocation(line: 98, column: 9, scope: !133)
!135 = !DILocation(line: 100, column: 14, scope: !136)
!136 = distinct !DILexicalBlock(scope: !124, file: !3, line: 100, column: 14)
!137 = !DILocation(line: 100, column: 18, scope: !136)
!138 = !DILocation(line: 100, column: 16, scope: !136)
!139 = !DILocation(line: 100, column: 14, scope: !124)
!140 = !DILocalVariable(name: "min", scope: !141, file: !3, line: 102, type: !13)
!141 = distinct !DILexicalBlock(scope: !136, file: !3, line: 100, column: 29)
!142 = !DILocation(line: 102, column: 23, scope: !141)
!143 = !DILocation(line: 102, column: 29, scope: !141)
!144 = !DILocation(line: 103, column: 16, scope: !141)
!145 = !DILocation(line: 103, column: 20, scope: !141)
!146 = !DILocation(line: 103, column: 9, scope: !141)
!147 = !DILocalVariable(name: "min", scope: !148, file: !3, line: 107, type: !13)
!148 = distinct !DILexicalBlock(scope: !136, file: !3, line: 105, column: 10)
!149 = !DILocation(line: 107, column: 23, scope: !148)
!150 = !DILocation(line: 107, column: 29, scope: !148)
!151 = !DILocation(line: 108, column: 20, scope: !148)
!152 = !DILocation(line: 108, column: 18, scope: !148)
!153 = !DILocation(line: 108, column: 26, scope: !148)
!154 = !DILocation(line: 108, column: 24, scope: !148)
!155 = !DILocation(line: 108, column: 35, scope: !148)
!156 = !DILocation(line: 108, column: 39, scope: !148)
!157 = !DILocation(line: 108, column: 37, scope: !148)
!158 = !DILocation(line: 108, column: 30, scope: !148)
!159 = !DILocation(line: 108, column: 28, scope: !148)
!160 = !DILocation(line: 108, column: 42, scope: !148)
!161 = !DILocation(line: 108, column: 9, scope: !148)
!162 = !DILocation(line: 110, column: 1, scope: !118)
!163 = distinct !DISubprogram(name: "matchMissmatchScore", scope: !3, file: !3, line: 116, type: !164, scopeLine: 116, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!164 = !DISubroutineType(types: !165)
!165 = !{!8, !13, !13}
!166 = !DILocalVariable(name: "i", arg: 1, scope: !163, file: !3, line: 116, type: !13)
!167 = !DILocation(line: 116, column: 39, scope: !163)
!168 = !DILocalVariable(name: "j", arg: 2, scope: !163, file: !3, line: 116, type: !13)
!169 = !DILocation(line: 116, column: 56, scope: !163)
!170 = !DILocation(line: 117, column: 9, scope: !171)
!171 = distinct !DILexicalBlock(scope: !163, file: !3, line: 117, column: 9)
!172 = !DILocation(line: 117, column: 11, scope: !171)
!173 = !DILocation(line: 117, column: 13, scope: !171)
!174 = !DILocation(line: 117, column: 21, scope: !171)
!175 = !DILocation(line: 117, column: 23, scope: !171)
!176 = !DILocation(line: 117, column: 25, scope: !171)
!177 = !DILocation(line: 117, column: 18, scope: !171)
!178 = !DILocation(line: 117, column: 9, scope: !163)
!179 = !DILocation(line: 118, column: 16, scope: !171)
!180 = !DILocation(line: 118, column: 9, scope: !171)
!181 = !DILocation(line: 120, column: 16, scope: !171)
!182 = !DILocation(line: 120, column: 9, scope: !171)
!183 = !DILocation(line: 121, column: 1, scope: !163)
!184 = distinct !DISubprogram(name: "similarityScore", scope: !3, file: !3, line: 124, type: !185, scopeLine: 124, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!185 = !DISubroutineType(types: !186)
!186 = !{null, !13, !13, !187, !187, !188}
!187 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64)
!188 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!189 = !DILocalVariable(name: "i", arg: 1, scope: !184, file: !3, line: 124, type: !13)
!190 = !DILocation(line: 124, column: 36, scope: !184)
!191 = !DILocalVariable(name: "j", arg: 2, scope: !184, file: !3, line: 124, type: !13)
!192 = !DILocation(line: 124, column: 53, scope: !184)
!193 = !DILocalVariable(name: "H", arg: 3, scope: !184, file: !3, line: 124, type: !187)
!194 = !DILocation(line: 124, column: 61, scope: !184)
!195 = !DILocalVariable(name: "P", arg: 4, scope: !184, file: !3, line: 124, type: !187)
!196 = !DILocation(line: 124, column: 69, scope: !184)
!197 = !DILocalVariable(name: "maxPos", arg: 5, scope: !184, file: !3, line: 124, type: !188)
!198 = !DILocation(line: 124, column: 87, scope: !184)
!199 = !DILocalVariable(name: "up", scope: !184, file: !3, line: 126, type: !8)
!200 = !DILocation(line: 126, column: 9, scope: !184)
!201 = !DILocalVariable(name: "left", scope: !184, file: !3, line: 126, type: !8)
!202 = !DILocation(line: 126, column: 13, scope: !184)
!203 = !DILocalVariable(name: "diag", scope: !184, file: !3, line: 126, type: !8)
!204 = !DILocation(line: 126, column: 19, scope: !184)
!205 = !DILocalVariable(name: "index", scope: !184, file: !3, line: 129, type: !13)
!206 = !DILocation(line: 129, column: 19, scope: !184)
!207 = !DILocation(line: 129, column: 27, scope: !184)
!208 = !DILocation(line: 129, column: 31, scope: !184)
!209 = !DILocation(line: 129, column: 29, scope: !184)
!210 = !DILocation(line: 129, column: 35, scope: !184)
!211 = !DILocation(line: 129, column: 33, scope: !184)
!212 = !DILocation(line: 132, column: 10, scope: !184)
!213 = !DILocation(line: 132, column: 12, scope: !184)
!214 = !DILocation(line: 132, column: 20, scope: !184)
!215 = !DILocation(line: 132, column: 18, scope: !184)
!216 = !DILocation(line: 132, column: 25, scope: !184)
!217 = !DILocation(line: 132, column: 23, scope: !184)
!218 = !DILocation(line: 132, column: 8, scope: !184)
!219 = !DILocation(line: 135, column: 12, scope: !184)
!220 = !DILocation(line: 135, column: 14, scope: !184)
!221 = !DILocation(line: 135, column: 20, scope: !184)
!222 = !DILocation(line: 135, column: 27, scope: !184)
!223 = !DILocation(line: 135, column: 25, scope: !184)
!224 = !DILocation(line: 135, column: 10, scope: !184)
!225 = !DILocation(line: 138, column: 12, scope: !184)
!226 = !DILocation(line: 138, column: 14, scope: !184)
!227 = !DILocation(line: 138, column: 22, scope: !184)
!228 = !DILocation(line: 138, column: 20, scope: !184)
!229 = !DILocation(line: 138, column: 24, scope: !184)
!230 = !DILocation(line: 138, column: 51, scope: !184)
!231 = !DILocation(line: 138, column: 54, scope: !184)
!232 = !DILocation(line: 138, column: 31, scope: !184)
!233 = !DILocation(line: 138, column: 29, scope: !184)
!234 = !DILocation(line: 138, column: 10, scope: !184)
!235 = !DILocalVariable(name: "max", scope: !184, file: !3, line: 141, type: !8)
!236 = !DILocation(line: 141, column: 9, scope: !184)
!237 = !DILocalVariable(name: "pred", scope: !184, file: !3, line: 142, type: !8)
!238 = !DILocation(line: 142, column: 9, scope: !184)
!239 = !DILocation(line: 158, column: 9, scope: !240)
!240 = distinct !DILexicalBlock(scope: !184, file: !3, line: 158, column: 9)
!241 = !DILocation(line: 158, column: 16, scope: !240)
!242 = !DILocation(line: 158, column: 14, scope: !240)
!243 = !DILocation(line: 158, column: 9, scope: !184)
!244 = !DILocation(line: 159, column: 15, scope: !245)
!245 = distinct !DILexicalBlock(scope: !240, file: !3, line: 158, column: 21)
!246 = !DILocation(line: 159, column: 13, scope: !245)
!247 = !DILocation(line: 160, column: 14, scope: !245)
!248 = !DILocation(line: 161, column: 5, scope: !245)
!249 = !DILocation(line: 163, column: 9, scope: !250)
!250 = distinct !DILexicalBlock(scope: !184, file: !3, line: 163, column: 9)
!251 = !DILocation(line: 163, column: 14, scope: !250)
!252 = !DILocation(line: 163, column: 12, scope: !250)
!253 = !DILocation(line: 163, column: 9, scope: !184)
!254 = !DILocation(line: 164, column: 15, scope: !255)
!255 = distinct !DILexicalBlock(scope: !250, file: !3, line: 163, column: 19)
!256 = !DILocation(line: 164, column: 13, scope: !255)
!257 = !DILocation(line: 165, column: 14, scope: !255)
!258 = !DILocation(line: 166, column: 5, scope: !255)
!259 = !DILocation(line: 168, column: 9, scope: !260)
!260 = distinct !DILexicalBlock(scope: !184, file: !3, line: 168, column: 9)
!261 = !DILocation(line: 168, column: 16, scope: !260)
!262 = !DILocation(line: 168, column: 14, scope: !260)
!263 = !DILocation(line: 168, column: 9, scope: !184)
!264 = !DILocation(line: 169, column: 15, scope: !265)
!265 = distinct !DILexicalBlock(scope: !260, file: !3, line: 168, column: 21)
!266 = !DILocation(line: 169, column: 13, scope: !265)
!267 = !DILocation(line: 170, column: 14, scope: !265)
!268 = !DILocation(line: 171, column: 5, scope: !265)
!269 = !DILocation(line: 173, column: 16, scope: !184)
!270 = !DILocation(line: 173, column: 5, scope: !184)
!271 = !DILocation(line: 173, column: 7, scope: !184)
!272 = !DILocation(line: 173, column: 14, scope: !184)
!273 = !DILocation(line: 174, column: 16, scope: !184)
!274 = !DILocation(line: 174, column: 5, scope: !184)
!275 = !DILocation(line: 174, column: 7, scope: !184)
!276 = !DILocation(line: 174, column: 14, scope: !184)
!277 = !DILocation(line: 177, column: 9, scope: !278)
!278 = distinct !DILexicalBlock(scope: !184, file: !3, line: 177, column: 9)
!279 = !DILocation(line: 177, column: 15, scope: !278)
!280 = !DILocation(line: 177, column: 18, scope: !278)
!281 = !DILocation(line: 177, column: 17, scope: !278)
!282 = !DILocation(line: 177, column: 13, scope: !278)
!283 = !DILocation(line: 177, column: 9, scope: !184)
!284 = !DILocation(line: 179, column: 19, scope: !285)
!285 = distinct !DILexicalBlock(scope: !278, file: !3, line: 177, column: 27)
!286 = !DILocation(line: 179, column: 10, scope: !285)
!287 = !DILocation(line: 179, column: 17, scope: !285)
!288 = !DILocation(line: 180, column: 5, scope: !285)
!289 = !DILocation(line: 182, column: 1, scope: !184)
!290 = distinct !DISubprogram(name: "calcFirstDiagElement", scope: !3, file: !3, line: 188, type: !291, scopeLine: 188, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!291 = !DISubroutineType(types: !292)
!292 = !{null, !188, !188, !188}
!293 = !DILocalVariable(name: "i", arg: 1, scope: !290, file: !3, line: 188, type: !188)
!294 = !DILocation(line: 188, column: 42, scope: !290)
!295 = !DILocalVariable(name: "si", arg: 2, scope: !290, file: !3, line: 188, type: !188)
!296 = !DILocation(line: 188, column: 60, scope: !290)
!297 = !DILocalVariable(name: "sj", arg: 3, scope: !290, file: !3, line: 188, type: !188)
!298 = !DILocation(line: 188, column: 79, scope: !290)
!299 = !DILocation(line: 190, column: 10, scope: !300)
!300 = distinct !DILexicalBlock(scope: !290, file: !3, line: 190, column: 9)
!301 = !DILocation(line: 190, column: 9, scope: !300)
!302 = !DILocation(line: 190, column: 14, scope: !300)
!303 = !DILocation(line: 190, column: 12, scope: !300)
!304 = !DILocation(line: 190, column: 9, scope: !290)
!305 = !DILocation(line: 191, column: 16, scope: !306)
!306 = distinct !DILexicalBlock(scope: !300, file: !3, line: 190, column: 17)
!307 = !DILocation(line: 191, column: 15, scope: !306)
!308 = !DILocation(line: 191, column: 10, scope: !306)
!309 = !DILocation(line: 191, column: 13, scope: !306)
!310 = !DILocation(line: 192, column: 10, scope: !306)
!311 = !DILocation(line: 192, column: 13, scope: !306)
!312 = !DILocation(line: 193, column: 5, scope: !306)
!313 = !DILocation(line: 194, column: 15, scope: !314)
!314 = distinct !DILexicalBlock(scope: !300, file: !3, line: 193, column: 12)
!315 = !DILocation(line: 194, column: 17, scope: !314)
!316 = !DILocation(line: 194, column: 10, scope: !314)
!317 = !DILocation(line: 194, column: 13, scope: !314)
!318 = !DILocation(line: 195, column: 16, scope: !314)
!319 = !DILocation(line: 195, column: 15, scope: !314)
!320 = !DILocation(line: 195, column: 20, scope: !314)
!321 = !DILocation(line: 195, column: 18, scope: !314)
!322 = !DILocation(line: 195, column: 22, scope: !314)
!323 = !DILocation(line: 195, column: 10, scope: !314)
!324 = !DILocation(line: 195, column: 13, scope: !314)
!325 = !DILocation(line: 197, column: 1, scope: !290)
!326 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 200, type: !327, scopeLine: 200, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!327 = !DISubroutineType(types: !328)
!328 = !{!8, !8, !329}
!329 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !18, size: 64)
!330 = !DILocalVariable(name: "argc", arg: 1, scope: !326, file: !3, line: 200, type: !8)
!331 = !DILocation(line: 200, column: 14, scope: !326)
!332 = !DILocalVariable(name: "argv", arg: 2, scope: !326, file: !3, line: 200, type: !329)
!333 = !DILocation(line: 200, column: 26, scope: !326)
!334 = !DILocation(line: 201, column: 7, scope: !326)
!335 = !DILocation(line: 202, column: 7, scope: !326)
!336 = !DILocation(line: 209, column: 16, scope: !326)
!337 = !DILocation(line: 209, column: 18, scope: !326)
!338 = !DILocation(line: 209, column: 9, scope: !326)
!339 = !DILocation(line: 209, column: 7, scope: !326)
!340 = !DILocation(line: 210, column: 16, scope: !326)
!341 = !DILocation(line: 210, column: 18, scope: !326)
!342 = !DILocation(line: 210, column: 9, scope: !326)
!343 = !DILocation(line: 210, column: 7, scope: !326)
!344 = !DILocation(line: 213, column: 6, scope: !326)
!345 = !DILocation(line: 214, column: 6, scope: !326)
!346 = !DILocalVariable(name: "H", scope: !326, file: !3, line: 217, type: !187)
!347 = !DILocation(line: 217, column: 10, scope: !326)
!348 = !DILocation(line: 218, column: 16, scope: !326)
!349 = !DILocation(line: 218, column: 20, scope: !326)
!350 = !DILocation(line: 218, column: 18, scope: !326)
!351 = !DILocation(line: 218, column: 9, scope: !326)
!352 = !DILocation(line: 218, column: 7, scope: !326)
!353 = !DILocalVariable(name: "P", scope: !326, file: !3, line: 221, type: !187)
!354 = !DILocation(line: 221, column: 10, scope: !326)
!355 = !DILocation(line: 222, column: 16, scope: !326)
!356 = !DILocation(line: 222, column: 20, scope: !326)
!357 = !DILocation(line: 222, column: 18, scope: !326)
!358 = !DILocation(line: 222, column: 9, scope: !326)
!359 = !DILocation(line: 222, column: 7, scope: !326)
!360 = !DILocation(line: 226, column: 5, scope: !326)
!361 = !DILocalVariable(name: "maxPos", scope: !326, file: !3, line: 230, type: !13)
!362 = !DILocation(line: 230, column: 19, scope: !326)
!363 = !DILocalVariable(name: "i", scope: !326, file: !3, line: 232, type: !13)
!364 = !DILocation(line: 232, column: 19, scope: !326)
!365 = !DILocalVariable(name: "j", scope: !326, file: !3, line: 232, type: !13)
!366 = !DILocation(line: 232, column: 22, scope: !326)
!367 = !DILocalVariable(name: "initialTime", scope: !326, file: !3, line: 235, type: !368)
!368 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!369 = !DILocation(line: 235, column: 12, scope: !326)
!370 = !DILocation(line: 235, column: 26, scope: !326)
!371 = !DILocalVariable(name: "si", scope: !326, file: !3, line: 237, type: !13)
!372 = !DILocation(line: 237, column: 19, scope: !326)
!373 = !DILocalVariable(name: "sj", scope: !326, file: !3, line: 237, type: !13)
!374 = !DILocation(line: 237, column: 23, scope: !326)
!375 = !DILocalVariable(name: "ai", scope: !326, file: !3, line: 237, type: !13)
!376 = !DILocation(line: 237, column: 27, scope: !326)
!377 = !DILocalVariable(name: "aj", scope: !326, file: !3, line: 237, type: !13)
!378 = !DILocation(line: 237, column: 31, scope: !326)
!379 = !DILocalVariable(name: "nDiag", scope: !326, file: !3, line: 240, type: !13)
!380 = !DILocation(line: 240, column: 19, scope: !326)
!381 = !DILocation(line: 240, column: 27, scope: !326)
!382 = !DILocation(line: 240, column: 31, scope: !326)
!383 = !DILocation(line: 240, column: 29, scope: !326)
!384 = !DILocation(line: 240, column: 33, scope: !326)
!385 = !DILocalVariable(name: "nEle", scope: !326, file: !3, line: 241, type: !13)
!386 = !DILocation(line: 241, column: 19, scope: !326)
!387 = !DILocation(line: 246, column: 16, scope: !388)
!388 = distinct !DILexicalBlock(scope: !389, file: !3, line: 246, column: 9)
!389 = distinct !DILexicalBlock(scope: !326, file: !3, line: 245, column: 5)
!390 = !DILocation(line: 246, column: 14, scope: !388)
!391 = !DILocation(line: 246, column: 21, scope: !392)
!392 = distinct !DILexicalBlock(scope: !388, file: !3, line: 246, column: 9)
!393 = !DILocation(line: 246, column: 26, scope: !392)
!394 = !DILocation(line: 246, column: 23, scope: !392)
!395 = !DILocation(line: 246, column: 9, scope: !388)
!396 = !DILocation(line: 248, column: 29, scope: !397)
!397 = distinct !DILexicalBlock(scope: !392, file: !3, line: 247, column: 9)
!398 = !DILocation(line: 248, column: 20, scope: !397)
!399 = !DILocation(line: 248, column: 18, scope: !397)
!400 = !DILocation(line: 249, column: 13, scope: !397)
!401 = !DILocation(line: 251, column: 20, scope: !402)
!402 = distinct !DILexicalBlock(scope: !397, file: !3, line: 251, column: 13)
!403 = !DILocation(line: 251, column: 18, scope: !402)
!404 = !DILocation(line: 251, column: 25, scope: !405)
!405 = distinct !DILexicalBlock(scope: !402, file: !3, line: 251, column: 13)
!406 = !DILocation(line: 251, column: 30, scope: !405)
!407 = !DILocation(line: 251, column: 27, scope: !405)
!408 = !DILocation(line: 251, column: 13, scope: !402)
!409 = !DILocation(line: 253, column: 22, scope: !410)
!410 = distinct !DILexicalBlock(scope: !405, file: !3, line: 252, column: 13)
!411 = !DILocation(line: 253, column: 27, scope: !410)
!412 = !DILocation(line: 253, column: 25, scope: !410)
!413 = !DILocation(line: 253, column: 29, scope: !410)
!414 = !DILocation(line: 253, column: 20, scope: !410)
!415 = !DILocation(line: 254, column: 22, scope: !410)
!416 = !DILocation(line: 254, column: 27, scope: !410)
!417 = !DILocation(line: 254, column: 25, scope: !410)
!418 = !DILocation(line: 254, column: 29, scope: !410)
!419 = !DILocation(line: 254, column: 20, scope: !410)
!420 = !DILocation(line: 255, column: 33, scope: !410)
!421 = !DILocation(line: 255, column: 37, scope: !410)
!422 = !DILocation(line: 255, column: 41, scope: !410)
!423 = !DILocation(line: 255, column: 44, scope: !410)
!424 = !DILocation(line: 255, column: 17, scope: !410)
!425 = !DILocation(line: 256, column: 13, scope: !410)
!426 = !DILocation(line: 251, column: 36, scope: !405)
!427 = !DILocation(line: 251, column: 13, scope: !405)
!428 = distinct !{!428, !408, !429}
!429 = !DILocation(line: 256, column: 13, scope: !402)
!430 = !DILocation(line: 257, column: 9, scope: !397)
!431 = !DILocation(line: 246, column: 33, scope: !392)
!432 = !DILocation(line: 246, column: 9, scope: !392)
!433 = distinct !{!433, !395, !434}
!434 = !DILocation(line: 257, column: 9, scope: !388)
!435 = !DILocation(line: 259, column: 1, scope: !326)
