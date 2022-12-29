#ifndef PARSER_CYK_H
#define PARSER_CYK_H
#include <unordered_map>
#include <map>
#include<array>
#include <iostream>

enum class PharaseStructure {
    DEFAULT //default
    , S //sentence
    , NP // noun phrase
    , VP // verbal phrase
    , DET // determiner
    , PRON // pronoun
    , N // noun
    , VI // intransitive verb
    , VT // transitive verb 
};

const std::array<std::string, 9> pharase_structure_to_string = {
    "def", "S", "NP", "VP", "DET", "PRON", "N", "VI", "VT"
};

std::unordered_multimap<std::string, PharaseStructure> lexical_rule =
{
    {"a", PharaseStructure::DET},
    {"an", PharaseStructure::DET},
    {"the", PharaseStructure::DET},
    {"red", PharaseStructure::DET},
    {"this", PharaseStructure::PRON},
    {"it", PharaseStructure::PRON},
    {"these", PharaseStructure::PRON},
    {"you", PharaseStructure::PRON},
    {"apple", PharaseStructure::N},
    {"apples", PharaseStructure::N},
    {"book", PharaseStructure::N},
    {"pen", PharaseStructure::N},
    {"is", PharaseStructure::VI},
    {"are", PharaseStructure::VI},
    {"read", PharaseStructure::VI},
};

std::map<std::pair<PharaseStructure, PharaseStructure>, PharaseStructure> phrase_structure_rule =
{
    {{PharaseStructure::NP, PharaseStructure::VP}, PharaseStructure::S},
    {{PharaseStructure::DET, PharaseStructure::NP}, PharaseStructure::NP},
    {{PharaseStructure::DET, PharaseStructure::N}, PharaseStructure::NP},
    {{PharaseStructure::VI, PharaseStructure::NP}, PharaseStructure::VP},
    {{PharaseStructure::VT, PharaseStructure::NP}, PharaseStructure::VP},
};

struct Node
{
    Node* left = nullptr;
    Node* right = nullptr;
    PharaseStructure pharase_structure = PharaseStructure::DEFAULT;
    const char* s;
    Node() {}
    Node(const char* _s) :s{ _s } {}
};

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

void init(std::vector<std::vector<std::vector<Node>>>& table, const int n, const std::vector<std::string>& tmp_s) {
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
}

void cyk(std::vector<std::vector<std::vector<Node>>>& table, const int n, const std::vector<std::string>& tmp_s) {
    init(table, n, tmp_s);
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
}

#endif //!PARSER_CYK_H
