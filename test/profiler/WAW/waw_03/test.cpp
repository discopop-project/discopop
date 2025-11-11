int main(){
    int x = 2;
    int* y = &x;
    x = 42;
    *y = 12;
    return 0;
}
