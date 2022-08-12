var iterations = 10000; 
var aG, bG, cG = 0; 
var localRes = 0; 
var arrSum, arrMul = 0; 
var globalArr = getlArr(iterations); 

//TODO: finish dispatch reduction examples, find 3 more examples for each, run for time measurments and correctness

func getArr(iterations) {
    var arr = []; 
    for i in 0...iterations {
        arr.add(i); 
    }
    return arr; 
}


func expensiveOP(n) {
    // causes no iter loop dependencies showing up on PET
    // calculate nth fibonacci number 
    // for high n this will be much more xpensive thus potentially making better use of dynamic 
    // sheduling
    var fn = 0; 

    if ((n == 0) || (n == 1)){
        fn = n; 
    } else {
        fn = expensiveOP(n-1) + expensiveOP(n-2); 
    }

    return fn; 
}



//implement array functions

func reduction() {
    // basic local arithmetic reduction with all possible one dimensional operations 
    var a, b, c = 0; 
    var localArr = getArr(iterations); 


    var start = DispatchTime.now() 

    for i in 0...iterations {
        a = a + 1; 
        b = b * 5; 
        c = c - 2; 
    }


    var nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
    var timeInterval = Double(nanoTime) / 1_000_000_000
    print("sequential reduction example 1: ", timeInterval)




    // basic global arithmetic reduction with local vars, all possible operations, reduction over index, on global var
    // mixed example + different load/store lines
    start = DispatchTime.now() 
    for i in 0...iterations {
        aG = a + i; 
        bG = bG * 5; 
        c = cG - i; 
        localRes = local_array[i] * 3 + localRes; 

        var tmp = a;
        a = tmp + 1;

    }


    nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
    timeInterval = Double(nanoTime) / 1_000_000_000
    print("sequential reduction example 2: ", timeInterval)






    // global and local array read reduction operations

    var arrSUm, arrMul = 0; 

    start = DispatchTime.now() 

    for i in 0...iterations {
        arrSum = arrSum + localArr[i]; 
        arrMul = arrMul + globalArr[i]; 
        
    }

    nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
    timeInterval = Double(nanoTime) / 1_000_000_000
    print("sequential reduction example 3: ", timeInterval)

    




    // reduction operation with function call

    start = DispatchTime.now() 

    for i in 0...iterations {
        aG = aG - expensiveOP(i); 
        a = a * expensiveOP(i); 
        cG = cG + expensiveOP(i); 

    }

    nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
    timeInterval = Double(nanoTime) / 1_000_000_000
    print("sequential reduction example 4: ", timeInterval)


    //nested for loop
   
}






func do_all() {

    var localArr = getArr(); 
    //zero init array from before

    // example 1
    var start = DispatchTime.now() 

    for i in 0...globalArr.count {
       globalArr[i] = 0; 
    }

    var nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
    var timeInterval = Double(nanoTime) / 1_000_000_000
    print("sequential doall example 1: ", timeInterval)



    //example 2
    //element swap between two arrays of same length has no inter loop deps
    start = DispatchTime.now() 

    for i in 0...localArr.count {
       var tmp = localArr[i]; 
       localArr[i] = globalArr[i]; 
       globalArr[i] = tmp; 

    }    

    nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
    timeInterval = Double(nanoTime) / 1_000_000_000
    print("sequential doall example 2: ", timeInterval)

    // nested for loop

    //something with actual computational value

}


func reduction_concurrent() {
     
    var stride = N; 
    var tasks = globalArr.count/stride;
    // residue

    

    var a, b, c = 0; 

    let reductionQueue = DispatchQueue();

    // example 1
    var start = DispatchTime.now() 

    reductionQueue
    .concurrentPerform(tasks)({ (index) in
    
        // start index of current array is tasknumber* offset 
        // stride(length of each task)
        var j = index * STRIDE+1;
        var stride_end = j + STRIDE;

        var privA, privB, privC = 0; 

        repeat {
        a = a + 1; 
        b = b * 5; 
        c = c - 2; 

        j = j + 1; 
        } while (j< stride_end);

        reductionQueue.sync({
        a = privA; 
        b = privB; 
        c = privC; 
        }
    }); 
    }); 

    var nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
    var timeInterval = Double(nanoTime) / 1_000_000_000
    print("dispatch reduction example 1: ", timeInterval)




    //example 2


    start = DispatchTime.now() 

    reductionQueue
    .concurrentPerform(tasks)({ (index) in
    
        // start index of current array is tasknumber* offset 
        // stride(length of each task)
        var j = index * STRIDE+1;
        var stride_end = j + STRIDE;

        var privA, privaG, privcG = 0;  

        repeat {
        privaG = privaG - expensiveOP(); 
        privA = privA * expensiveOP(); 
        privcG = privcG + expensiveOP(); 

        j = j + 1; 
        } while (j< stride_end);

        reductionQueue.sync({

        aG = aG + privaG; 
        a = a + privA; 
        cG = cG + privcG; 

        }
    }); 
    }); 

    nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
    timeInterval = Double(nanoTime) / 1_000_000_000
    print("dispatch reduction example 2: ", timeInterval)

}





//time measurements
//dispatch implementation


func doall_concurrent() {


    var localArr = getArr(iterations); 

    var stride = N; 
    var number_of_tasks = globalArr.count/stride; 
    // residue for uneven arrays

    let doallQueue = DispatchQueue();

    


    // example 1
    var start = DispatchTime.now() 

    // should block main thread 
    doallQueue
    .concurrentPerform(iterations: numer_of_tasks) { (index) in

        // just stride
        var j = index * stride+1;
        var stride_end = j + stride;
      
        repeat {
        
        globalArr[j] = 0; 

        j = j + 1; 
        } while (j< stride_end);
        
    }

    var nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
    var timeInterval = Double(nanoTime) / 1_000_000_000
    print("dispatch doall example 1: ", timeInterval)
    





    // example 2
    start = DispatchTime.now() 

    doallQueue
    .concurrentPerform(iterations: numer_of_tasks) { (index) in

        // just stride
        var j = index * stride+1;
        var stride_end = j + stride;
      
        repeat {
        
        var tmp = globalArr[i]; 
        localArr[j] = globalArr[j]; 
        globalArr[j] = tmp; 

        j = j + 1; 
        } while (j< stride_end);
        
    }

    end = DispatchTime.now() 

    nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
    timeInterval = Double(nanoTime) / 1_000_000_000
    print("dispatch example 2: ", timeInterval)


    print("examples done")

}


func entry() {

    reduction(); 

    do_all(); 

    reduction_concurrent(); 

    doall_concurrent(); 

}


entry(); 