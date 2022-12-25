#ifndef CFG_CFG_H
#define CFG_CFG_H
#include <unordered_map>
#include <map>
#include<array>

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
    Node(){}
    Node(const char* _s) :s{ _s } {}
};
#endif //!CFG_CFG_H
