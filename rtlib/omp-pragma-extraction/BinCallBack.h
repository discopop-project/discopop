#ifndef OMPMATCHER_BINCALLBACK_H
#define OMPMATCHER_BINCALLBACK_H

#include <clang/ASTMatchers/ASTMatchFinder.h>
#include <clang/ASTMatchers/ASTMatchersInternal.h>

#include "clang/AST/StmtOpenMP.h"

using namespace clang::ast_matchers;
using namespace clang;

class BinCallBack: public MatchFinder::MatchCallback {
public:

    SourceLocation getScopeEndLineFromChildren(const Stmt* root, SourceLocation lastLoc, SourceManager& SM){
        // check if root updates lastLoc
        BeforeThanCompare<SourceLocation> isBefore(SM);
        if(isBefore(lastLoc, root->getSourceRange().getEnd())){
            // scope of root extends last known scope
            lastLoc = root->getSourceRange().getEnd();
        }
        // search in captured statement
        if(isa<CapturedStmt>(root)){
            const Stmt* captd = cast<CapturedStmt>(root)->getCapturedStmt();
            // enter recursion for captd
            lastLoc = getScopeEndLineFromChildren(captd, lastLoc, SM);
        }
        // search in children
        for(auto child : root->children()){
            if(! child){
                continue;
            }
            // enter recursion
            lastLoc = getScopeEndLineFromChildren(child, lastLoc, SM);
        }
        return lastLoc;
    }

    void run(const MatchFinder::MatchResult &r) override {
        const clang::Stmt* ompDirective = r.Nodes.getNodeAs<Stmt>("ompPragma");
        ASTContext* ctx = r.Context;

        llvm::outs() << ompDirective->getStmtClassName() << ";";

        // get child node of type CapturedStmt and extract scope information
        bool found_captured_stmt = false;
        for(auto child : ompDirective->children()){
            if(isa<CapturedStmt>(child)){
                // get begin location and write to file
                child->getSourceRange().getBegin().print(llvm::outs(), ctx->getSourceManager());
                llvm::outs() << ";";
                // get end location by recursively checking children and write to file
                SourceLocation endLoc;
                endLoc = getScopeEndLineFromChildren(child, child->getSourceRange().getBegin(), ctx->getSourceManager());
                endLoc.print(llvm::outs(), ctx->getSourceManager());
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
