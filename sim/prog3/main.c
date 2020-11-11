int gcd(unsigned int a, unsigned int b)
{
    // Everything divides 0 
    if (a == 0)
       return b;
    if (b == 0)
       return a;
  
    // base case
    if (a == b)
        return a;
  
    // a is greater
    if (a > b)
        return gcd(a-b, b);
    return gcd(a, b-a);
}
int main()
{
	
	extern unsigned int div1;
    extern unsigned int div2;

	extern unsigned int _test_start;
	

	
	_test_start=gcd(div1,div2);
	return 0;
}