int main(){
    int z = 4141;
    int& y = z;
    int* w = &z;
    int x = y + (*w) + 2;
    return 0;
}
