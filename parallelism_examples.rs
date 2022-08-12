use rayon::prelude::*; 

fn expensiveOP(n: i32) -> i32 {
    let mut fib: i32 = 0; 

    if (n == 0 || n == 1) {
        fib = n; 
    } else {
        fib = expensiveOP(n-1) + expensiveOP(n-2);
    }
    return fib; 
}


fn reduction() {

    let iterations:i32 = 10000; 

    let mut a:i32, b:i32, c:i32 = 0; 
    let mut arr: [i32; 500] = [0; 500];

    //time measurements
    for i in 0..iterations {
        a = a + 1; 
        b = b * 5; 
        c = c - 2; 
    }


    for i in 0..iterations {
        a = a - expensiveOP(i); 
        b = a * expensiveOP(i); 
        c = c + expensiveOP(i); 
    }

    let mut arrSum:i32, arrMul:i32 = 0; 

    for i in 0..iterations {
        arrSum = arrSum + arr[i]; 
        arrMul = arrMul * arr[i]; 
    }



}


fn do_all() {

}


fn concurrent_reduction() {

}

fn concurrent_doall() {

}


//rayon examples

fn main() {
    // 
    println!("starting examples"); 


  }