int f(int n){
	if(n == 1){
		return 0;
	}
	if(n == 2){
		return 1;
	}
	if(n == 3){
		return 2;
	}
    return f(n-1) + f(n-2) + f(n-3);
}

int g(int a, int b){
    int x;
    x=f(a)+a+b;
    return x;
}

int main(){
    int a,b;
    a=4;
    b=2;
    a=g(a,b);
    println(a);
    return 0;
}
