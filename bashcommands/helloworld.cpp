#include <iostream>
#include <stdlib.h>
#include <unistd.h>

int main()
{
    while(1)
    {
        std::cout << "hello world" << std::endl;
        sleep(1);
    }

    return 0;
}
