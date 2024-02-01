/*
code example 
written by Daniel Cazacu
this code comes with no warranty, use at your own risk
asd
looooplooooper@gmail.com
*/



#include "device_launch_parameters.h"
#include "cuda_runtime.h"

#include <ctime>
#include <cstdio>
#include <cmath>


__global__ void primes_in_range(int *result)
{

	double number = (blockIdx.x * blockDim.x) + threadIdx.x;
	if (number >= 10000000)
	{
		return;
	}

	if (fmod(number,2.0) == 0) return;
	double c=sqrt(number);
	for (double divisor = 3; divisor < c; divisor += 2)
	{
		if (fmod(number,divisor) == 0)
		{
			return;
		}
	}
	
	printf("%f \n", number);
	
	atomicAdd(result, 1);
}

int main()
{
	auto begin = std::clock();

	int *result;
	cudaMallocManaged(&result, 4);
	*result = 0;

	primes_in_range<<<10000, 1024>>>(result);
	cudaDeviceSynchronize();

	auto end = std::clock();
	auto duration = double(end - begin) / CLOCKS_PER_SEC * 1000;
	
	printf("%d prime numbers found in %d milliseconds", 
		*result, 
		static_cast<int>(duration)
	);
	
	getchar();
	return 0;
}
