#ifndef UASM_AST_H
#define UASM_AST_H

#include <vector>
#include <string>
#include <iostream>

typedef int uc_address_t;

enum ASTSignalIdentifierType
{
    SINGLE_LINE,
    BUS,
};

enum ASTStatementType
{
    LABEL,
    VALUE,
};


class ASTNode
{

};


class ASTSignalIdentifier: public ASTNode
{
public:
    std::string label;
    ASTSignalIdentifierType signalIdentifierType;

    ASTSignalIdentifier(const std::string &labelIdentifier, const ASTSignalIdentifierType signalIdentifierType):
        label(labelIdentifier),
        signalIdentifierType(signalIdentifierType)
    {}
};


class ASTStatement: public ASTNode
{
public:
    ASTStatementType statementType;
    std::string label;
};


class ASTLabelStatement: public ASTStatement
{
public:
    ASTLabelStatement(const std::string &labelIdentifier)
    {
        this->statementType = LABEL;
        this->label = labelIdentifier;
    }
};


class ASTValueStatement: public ASTStatement
{
public:
    std::vector<ASTSignalIdentifier *> signalIdentifiers;
    bool isAnonymous;

    ASTValueStatement(const std::string &labelIdentifier, const std::vector<ASTSignalIdentifier *> &signalIdentifiers)
    {
        this->statementType = VALUE;
        this->label = labelIdentifier;
        this->signalIdentifiers = signalIdentifiers;
        this->isAnonymous = labelIdentifier.empty();
    }
};


class ASTLiteralAddressStatement: public ASTStatement
{
public:
    ASTLiteralAddressStatement()
    {
        uc_address_t address;
    }
};


class ASTRoot: public ASTNode
{
public:
    ASTRoot()
    {
        std::cout << "making new ASTRoot\n";
    }
    std::vector<ASTStatement *> statements;
};


#endif
