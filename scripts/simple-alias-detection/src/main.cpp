#include <clang/Tooling/CommonOptionsParser.h>
#include <clang/Tooling/Tooling.h>
#include <clang/Frontend/FrontendActions.h>
#include <clang/ASTMatchers/ASTMatchers.h>
#include <clang/ASTMatchers/ASTMatchFinder.h>
#include "clang/Frontend/TextDiagnostic.h"

#include "BinCallBack.h"


using namespace llvm;
using namespace clang;
using namespace clang::tooling;
using namespace clang;
using namespace clang::ast_matchers;

static llvm::cl::OptionCategory SimpleStatement("simpleStatement");

int main(int argc, const char **argv) {
  CommonOptionsParser op(argc, argv, SimpleStatement);
  ClangTool Tool(op.getCompilations(), op.getSourcePathList());
  StatementMatcher bin_stmt = clang::ast_matchers::binaryOperator(
            anything(), isExpansionInMainFile()
          ).bind("simpleStatement");
  StatementMatcher decl_stmt = clang::ast_matchers::declStmt(
          anything()
          , isExpansionInMainFile()
          ).bind("simpleStatement");
  MatchFinder finder;
  BinCallBack bin_cb;
  finder.addMatcher(bin_stmt, &bin_cb);
  finder.addMatcher(decl_stmt, &bin_cb);
  auto action = newFrontendActionFactory(&finder);
  //run actions on AST
  return Tool.run(action.get());
}
