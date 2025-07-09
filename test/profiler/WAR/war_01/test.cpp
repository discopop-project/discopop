int main(){
    int z = 4141;
    int&y = z;
    int x = z + 2;
    y = 42 + x;
    return 0;
}
