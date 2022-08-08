#ifndef OMPMATCHER_BINCALLBACK_H
#define OMPMATCHER_BINCALLBACK_H

#include <clang/ASTMatchers/ASTMatchFinder.h>
#include <clang/ASTMatchers/ASTMatchersInternal.h>

#include "clang/AST/StmtOpenMP.h"

using namespace clang::ast_matchers;
using namespace clang;

class BinCallBack: public MatchFinder::MatchCallback {
public:
    void run(const MatchFinder::MatchResult &r) override {
        const clang::Stmt* ompDirective = r.Nodes.getNodeAs<Stmt>("ompPragma");
        ASTContext* ctx = r.Context;

        llvm::outs() << ompDirective->getStmtClassName() << ";";

        // get child node of type CapturedStmt and extract scope information
        bool found_captured_stmt = false;
        for(auto child : ompDirective->children()){
            if(isa<CapturedStmt>(child)){
                child->getSourceRange().getBegin().print(llvm::outs(), ctx->getSourceManager());
                llvm::outs() << ";";
                child->getSourceRange().getEnd().print(llvm::outs(), ctx->getSourceManager());
                llvm::outs() << "\n";
                found_captured_stmt = true;
                break;
            }
        }
        if(! found_captured_stmt){
            // use scope information from directive
            ompDirective->getSourceRange().getBegin().print(llvm::outs(), ctx->getSourceManager());
            llvm::outs() << ";";
            ompDirective->getSourceRange().getEnd().print(llvm::outs(), ctx->getSourceManager());
            llvm::outs() << "\n";
        }
    }
};

#endif //OMPMATCHER_BINCALLBACK_H
