#include <iostream>
#include <map>
#include "uasm.tab.h"
#include "ast.h"



int main(int argc, char **argv)
{
    extern ASTRoot astRoot;
    yyparse();

    std::map<std::string, std::vector<ASTSignalIdentifier *> > valueSymbolTable;
    std::map<std::string, uc_address_t > labelSymbolTable;

    uc_address_t uc_address = 0;

    for (ASTStatement *statement: astRoot.statements)
    {
        std::cout << "* * * statement -> " << statement->label << std::endl;

        switch (statement->statementType)
        {
            case LABEL:
                labelSymbolTable[statement->label] = uc_address;
                uc_address ++;
                break;

            case VALUE:
                auto *valueStatement = (ASTValueStatement *)statement;

                for (ASTSignalIdentifier *signalIdentifier: valueStatement->signalIdentifiers)
                {
                    if (!signalIdentifier->label.empty())
                    {
                        valueSymbolTable[statement->label] = valueStatement->signalIdentifiers;
                    }
                }
                break;
        }
    }


    for (ASTSignalIdentifier *signalIdentifier: valueSymbolTable["%weiner"])
    {
        std::cout << "that has a " << signalIdentifier->label << "\n";
    }

    std::cout << "results:\n\tvalueSymbolTable: " << valueSymbolTable.size() <<"\n\tlabelSymbolTable: " << labelSymbolTable.size() << "\n";
}
