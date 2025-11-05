int main(){
    int z = 4141;
    int&y = z;
    int x = y + 2;
    z = 42 + x;
    return 0;
}
