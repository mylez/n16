#include <iostream>
#include <map>
#include "uasm.tab.h"
#include "ast.h"



int main(int argc, char **argv)
{
    extern ASTRoot astRoot;
    yyparse();

    std::map<uc_address_t, std::vector<ASTSignalIdentifier *> > ucValues;
    std::map<std::string, std::vector<ASTSignalIdentifier *> > valueSymbolTable;
    std::map<std::string, uc_address_t > labelSymbolTable;

    uc_address_t uc_address = 0x00;

    for (ASTStatement *statement: astRoot.statements)
    {
        switch (statement->statementType)
        {
            case LABEL:
            {
                labelSymbolTable[statement->label] = uc_address;
                break;
            }

            case VALUE:
            {
                auto *valueStatement = (ASTValueStatement *) statement;
                if (valueStatement->label.empty())
                {
                    ucValues[uc_address++] = valueStatement->signalIdentifiers;
                }
                else
                {
                    valueSymbolTable[statement->label] = valueStatement->signalIdentifiers;
                }
                break;
            }

            case ADDRESS_LITERAL:
            {
                auto *addressLiteralStatement = (ASTAddressLiteralStatement *) statement;
                uc_address = addressLiteralStatement->address;
                break;
            }
        }
    }
}
