int main(){
    int x = 42;
    int* x_ptr = &x;
    *x_ptr = 1337;
    int z = x;
    return 0;
}
