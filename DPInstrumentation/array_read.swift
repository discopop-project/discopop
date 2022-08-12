
var globalArray = [1, 2, 3, 4]; 
var lid = 0; 
var reduction = 0; 

for i in 0...globalArray.count-1 {

    globalArray[i] = 0; 
    //expect RAW source 6, drain 8
    var testvalue = globalArray[i]; 

    //expect WAR source 9 sink 12
    globalArray[i] = 0; 

    //expect WAW line 9
    globalArray[1] = 1; 

    //expect RAW source 13 drain 19 + RAW for reduction variable source and drain 19 and WAR source 4 drain 19
    reduction = reduction + globalArray[i];

    if i < globalArray.count-1 {
        globalArray[i] = globalArray[i] + globalArray[i+1];
    }
}

lid = 0; 