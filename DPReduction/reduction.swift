var globl = 0; 
func reduction_op() {
    var a = 0; 
    var b = 0; 
    var c = 0; 
    var d = 0; 

for i in 0...10 {
    a = a + 1;
    globl = globl + 1; 
    b = b - 4; 
    c = 6 * c; 
    d = d + i; 
}

for i in 0...1 {
    a = a + 1; 
}
}

reduction_op();