int f(int n){
	if(n <= 1){
		return 1;
	}
    return n * f(n-1);
}

int g(int a, int b){
    int x;
    x=f(a)+a+b;
    return x;
}

int main(){
    int a,b;
    a=4;
    b=3;
    a=g(a,b);
    println(a);
    return 0;
}
