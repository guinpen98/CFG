#include "cyk.h"
#include <sstream>
#include <string>
#include <vector>
#include <algorithm>

int main() {
    //std::string input = "These are apples";
    //std::string input = "This is an apple";
    //std::string input = "You read a book";
    std::string input = "It is the red pen";
    std::cout << input << std::endl;
    std::istringstream iss(input);
    std::string s;
    std::vector<std::string> tmp_s;
    int n = 0;

    while (iss >> s) {
        std::transform(s.begin(), s.end(), s.begin(), tolower);
        tmp_s.push_back(s);
        ++n;
    }

    std::vector<std::vector<std::vector<Node>>> table(n, std::vector<std::vector<Node>>(n, std::vector<Node>(0)));
    cyk(table, n, tmp_s);
    
    for (auto& result : table[0][n - 1]) {
        search(&result);
        std::cout << std::endl;
    }
}