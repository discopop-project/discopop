#ifndef BINMATCHER_BINCALLBACK_H
#define BINMATCHER_BINCALLBACK_H

#include <clang/ASTMatchers/ASTMatchFinder.h>
#include <clang/ASTMatchers/ASTMatchersInternal.h>

using namespace clang::ast_matchers;
using namespace clang;

class BinCallBack: public MatchFinder::MatchCallback {
public:
    void run(const MatchFinder::MatchResult &r) override {
        const clang::Stmt* simpleStatement = r.Nodes.getNodeAs<Stmt>("simpleStatement");
        ASTContext* ctx = r.Context;
        simpleStatement->getSourceRange().getBegin().print(llvm::outs(), ctx->getSourceManager());
        llvm::outs() << ": ";
        simpleStatement->printPretty(llvm::outs(), nullptr, ctx->getPrintingPolicy());
        llvm::outs() << "\n\n";
    }
};

#endif //BINMATCHER_BINCALLBACK_H
