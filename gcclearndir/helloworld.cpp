#include <iostream>
#include <vector>
using namespace std;
int main()
{
    cout << "HelloWorld" << endl;
    vector<int> vec = {1,2,4,5};

    for(auto &i:vec)
    {
        cout << i << ",";
    }
    for(int i=0;i!=vec.size();++i)
    {
        cout << vec.at(i) << " ";
    }
    cout << endl;
    system("pause");
    return 0;
}
