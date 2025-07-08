int main(){
    int z = 4141;
    int& y = z;
    y = 42;
    int x = z + 2;
    return 0;
}
