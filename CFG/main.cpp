#include "cfg.h"
#include <sstream>
#include <string>
#include <vector>
#include <iostream>
#include <string>
#include <algorithm>

void search(const Node* node) {
    if (node->left == nullptr && node->right == nullptr) {
        std::cout << "(" << pharase_structure_to_string[(int)node->pharase_structure] << " " << node->s << ")";
        return;
    }

    std::cout << "(" << pharase_structure_to_string[(int)node->pharase_structure];

    if (node->left != nullptr) {
        search(node->left);
        std::cout << " ";
        search(node->right);

    }
    else {
        search(node->right);
    }
    std::cout << ")";
}

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
    for (int i = 0; i < n; ++i) {
        std::pair<std::unordered_multimap<std::string, PharaseStructure>::iterator, std::unordered_multimap<std::string, PharaseStructure>::iterator> range = lexical_rule.equal_range(tmp_s[i]);
        for (std::unordered_multimap<std::string, PharaseStructure>::iterator iterator = range.first; iterator != range.second; iterator++) {
            std::pair<std::string, PharaseStructure> target = *iterator;
            Node new_node(tmp_s[i].c_str());
            new_node.s;
            new_node.pharase_structure = target.second;
            table[i][i].push_back(new_node);
            if (target.second == PharaseStructure::N || target.second == PharaseStructure::PRON) {
                Node tmp_node;
                tmp_node.pharase_structure = PharaseStructure::NP;
                table[i][i].insert(table[i][i].begin(), tmp_node);
                table[i][i][0].right = &table[i][i].back();
            }
        }
    }

    for (int d = 1; d < n; ++d) {
        for (int i = 1; i < n - d + 1; ++i) {
            int j = i + d;
            for (int k = i; k < j; ++k) {
                for (auto& ik : table[i - 1][k - 1]) {
                    for (auto& k1j : table[k][j - 1]) {
                        PharaseStructure tmp = phrase_structure_rule[{ik.pharase_structure, k1j.pharase_structure}];
                        if (tmp == PharaseStructure::DEFAULT) continue;
                        Node new_node;
                        new_node.pharase_structure = tmp;
                        new_node.left = &ik;
                        new_node.right = &k1j;
                        table[i - 1][j - 1].push_back(new_node);
                    }
                }
            }
        }
    }
    for (auto& result : table[0][n - 1]) {
        search(&result);
    std::cout << std::endl;
    }
}