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

static llvm::cl::OptionCategory OmpPragma("ompPragma");


int main(int argc, const char **argv) {
  /*
    * Create a list of all OpenMP pragmas and their scopes within the given source file.
  */
  CommonOptionsParser op(argc, argv, OmpPragma);
  ClangTool Tool(op.getCompilations(), op.getSourcePathList());

  auto omp_pragma = ompExecutableDirective().bind("ompPragma");

  MatchFinder finder;
  BinCallBack bin_cb;
  finder.addMatcher(omp_pragma, &bin_cb);
  auto action = newFrontendActionFactory(&finder);
  //run actions on AST
  return Tool.run(action.get());
}
