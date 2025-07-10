int main(){
    int x = 2;
    int* y = &x;
    *y = 12;
    x = 131;
    return 0;
}
