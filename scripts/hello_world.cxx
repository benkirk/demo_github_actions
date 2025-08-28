#include <iostream>
#include <iomanip>
#include <omp.h>
#include <unistd.h>



int main (int argc, char **argv)
{
  int nthreads=1;
  char hn[256];

  gethostname(hn, sizeof(hn) / sizeof(char));

#ifdef _OPENNMP
#pragma omp parallel
  { if (0 == omp_get_thread_num()) nthreads = omp_get_num_threads(); }
#endif

  std::cout << "Hello World!: " << std::string (hn)
	    << ", running " << argv[0];
  if (nthreads > 1)
    std::cout << " with " << nthreads << " threads";
  std::cout << std::endl;

  return 0;
}
