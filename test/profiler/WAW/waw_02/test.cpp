int main(){
    int x = 2;
    int& y = x;
    y = 42;
    x = 12;
    return 0;
}
