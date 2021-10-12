int a;
int function(int a){
  if(a==1 || a==0){
    return 1;
  }
  return function(a-2)  + function(a-1);
}

int main(){
  a = 1;
  int b;
  b = 6;

  a = a+function(b);
  printf(a);
}
