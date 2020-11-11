
int main()
{
	extern signed int 	mul1;
	extern signed int  mul2;
	extern signed int _test_start;
	long long signed int num1=((long long)(*&mul1));
	long long signed int num2=((long long)(*&mul2));
	long long signed int ans;
	ans=num1*num2;
	*(long long signed int*)(&_test_start)= ans;
	return 0;
}
