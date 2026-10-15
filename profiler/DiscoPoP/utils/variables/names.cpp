/*
 * This file is part of the DiscoPoP software
 * (http://www.discopop.tu-darmstadt.de)
 *
 * Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
 *
 * This software may be modified and distributed under the terms of
 * the 3-Clause BSD License. See the LICENSE file in the package base
 * directory for details.
 *
 */

#include "DiscoPoP.hpp"

using llvm::AllocaInst;
using llvm::ConstantInt;
using llvm::DIGlobalVariable;
using llvm::DbgVariableRecord;
using llvm::GetElementPtrInst;
using llvm::GlobalVariable;
using llvm::IRBuilder;
using llvm::Instruction;
using llvm::LoadInst;
using llvm::MDNode;
using llvm::PointerType;
using llvm::Region;
using llvm::StoreInst;
using llvm::StringRef;
using llvm::StructType;
using llvm::Type;
using llvm::Value;
using llvm::cast;
using llvm::filterDbgVars;
using llvm::isa;

std::string DiscoPoP::getOrInsertVarName_static(std::string varName, IRBuilder<> &builder) {
  Value *valName = nullptr;
  // remove .addr if added. Replaced by the GEPRESULT_ tag
  if (varName.find(".addr") != std::string::npos){
    varName.erase(varName.find(".addr"), 5);
  }

  std::string vName = varName;
  std::map<std::string, Value *>::iterator pair = VarNames.find(varName);
  if (pair == VarNames.end()) {
    valName = builder.CreateGlobalStringPtr(StringRef(varName.c_str()), ".str");

    VarNames[varName] = valName;
  } else {
    vName = pair->first;
  }

  return vName;
}

Value *DiscoPoP::getOrInsertVarName_dynamic(std::string varName, IRBuilder<> &builder) {
  // remove .addr if added. Replaced by the GEPRESULT_ tag
  if (varName.find(".addr") != std::string::npos){
    varName.erase(varName.find(".addr"), 5);
  }

  // 26.08.2022 Lukas
  // update varName with original varName from Metadata
  if (trueVarNamesFromMetadataMap.find(varName) == trueVarNamesFromMetadataMap.end()) {
    // not found, do nothing
  } else {
    // found, update varName
    varName = trueVarNamesFromMetadataMap[varName];
  }

  Value *vName = nullptr;
  std::map<std::string, Value *>::iterator pair = VarNames.find(varName);
  if (pair == VarNames.end()) {
    vName = builder.CreateGlobalStringPtr(StringRef(varName.c_str()), ".str");
    VarNames[varName] = vName;
  } else {
    vName = pair->second;
  }
  return vName;
}

std::string DiscoPoP::determineVariableName_static(Instruction *I, bool &isGlobalVariable /*=defaultIsGlobalVariableValue*/,
                                              bool disable_MetadataMap, std::string prefix) {

  assert(I && "Instruction cannot be NULL \n");
  int index = isa<StoreInst>(I) ? 1 : 0;
  Value *operand = I->getOperand(index);

  IRBuilder<> builder(I);

  if (operand == nullptr) {
    std::string retVal = getOrInsertVarName_static("", builder);
    if (trueVarNamesFromMetadataMap.find(retVal) == trueVarNamesFromMetadataMap.end() || disable_MetadataMap) {
      return retVal; // not found
    }       return trueVarNamesFromMetadataMap[retVal]; // found

  }

  if (operand->hasName()) {
    //// we've found a global variable
    if (isa<GlobalVariable>(*operand)) {
      // MOHAMMAD ADDED THIS FOR CHECKING
      isGlobalVariable = true;
      std::string retVal = std::string(operand->getName());
      if (trueVarNamesFromMetadataMap.find(retVal) == trueVarNamesFromMetadataMap.end() || disable_MetadataMap) {
        return retVal; // not found
      }         return trueVarNamesFromMetadataMap[retVal]; // found

    }
    if (isa<GetElementPtrInst>(*operand)) {
      GetElementPtrInst *gep = cast<GetElementPtrInst>(operand);
      Value *ptrOperand = gep->getPointerOperand();
      PointerType *PTy = cast<PointerType>(ptrOperand->getType());

      // we've found a struct/class
      Type *structType = pointsToStruct(PTy);
      if (structType && gep->getNumOperands() > 2) {
        Value *constValue = gep->getOperand(2);
        if (constValue && isa<ConstantInt>(*constValue)) {
          ConstantInt *idxPtr = cast<ConstantInt>(gep->getOperand(2));
          std::uint64_t memberIdx = *(idxPtr->getValue().getRawData());
          if (!(cast<StructType>(structType))->isLiteral()) {
            std::string strName(structType->getStructName().data());
            std::map<std::string, MDNode *>::iterator it = Structs.find(strName);
            if (it != Structs.end()) {
              std::string ret = findStructMemberName_static(it->second, memberIdx, builder);
              if (ret.size() > 0) {
                std::string retVal = ret;
                if (trueVarNamesFromMetadataMap.find(retVal) == trueVarNamesFromMetadataMap.end() ||
                    disable_MetadataMap) {
                  return retVal; // not found
                }                   return trueVarNamesFromMetadataMap[retVal]; // found

              } else {
                std::string retVal = getOrInsertVarName_static("", builder);
                if (trueVarNamesFromMetadataMap.find(retVal) == trueVarNamesFromMetadataMap.end() ||
                    disable_MetadataMap) {
                  return retVal; // not found
                }                   return trueVarNamesFromMetadataMap[retVal]; // found

                // return ret;
              }
            }
          }
        }
      }

      // we've found an array
      // NOTE (25-10-30) simplified for LLVM 19 compatibility
      // OLD: if (PTy->getPointerElementType()->getTypeID() == Type::ArrayTyID && isa<GetElementPtrInst>(*ptrOperand)) {
      if (isa<GetElementPtrInst>(*ptrOperand)) {
        return determineVariableName_static(cast<Instruction>(ptrOperand), isGlobalVariable, false, prefix);
      }
      return determineVariableName_static(static_cast<Instruction *>(gep), isGlobalVariable, false, "GEPRESULT_" + prefix);
    }
    std::string retVal = std::string(operand->getName().data());
    if (trueVarNamesFromMetadataMap.find(retVal) == trueVarNamesFromMetadataMap.end() || disable_MetadataMap) {
      return retVal; // not found
    }       return trueVarNamesFromMetadataMap[retVal]; // found

    // return getOrInsertVarName(string(operand->getName().data()), builder);
  }

  if (isa<LoadInst>(*operand) || isa<StoreInst>(*operand)) {
    return determineVariableName_static(cast<Instruction>(operand), isGlobalVariable, false, prefix);
  }
  // if we cannot determine the name, then return *
  return ""; // getOrInsertVarName("*", builder);
}

Value *DiscoPoP::determineVariableName_dynamic(Instruction *const I, std::string prefix) {
  assert(I && "Instruction cannot be NULL \n");
  int index = isa<StoreInst>(I) ? 1 : 0;
  Value *operand = I->getOperand(index);

  IRBuilder<> builder(I);

  if (operand == nullptr) {
    return getOrInsertVarName_dynamic("*", builder);
  }

  if (operand->hasName()) {
    // we've found a global variable
    if (isa<GlobalVariable>(*operand)) {
      DIGlobalVariable *gv = findDbgGlobalDeclare(cast<GlobalVariable>(operand));
      if (gv != nullptr) {
        return getOrInsertVarName_dynamic(prefix +  std::string(gv->getDisplayName().data()), builder);
      }
    }
    if (isa<GetElementPtrInst>(*operand)) {
      GetElementPtrInst *gep = cast<GetElementPtrInst>(operand);
      Value *ptrOperand = gep->getPointerOperand();
      PointerType *PTy = cast<PointerType>(ptrOperand->getType());

      // we've found a struct/class
      Type *structType = pointsToStruct(PTy);
      if (structType && gep->getNumOperands() > 2) {
        Value *constValue = gep->getOperand(2);
        if (constValue && isa<ConstantInt>(*constValue)) {
          ConstantInt *idxPtr = cast<ConstantInt>(gep->getOperand(2));
          std::uint64_t memberIdx = *(idxPtr->getValue().getRawData());

          StructType *STy = cast<StructType>(structType);
          if (!STy->isLiteral()) {
            std::string strName(structType->getStructName().data());
            std::map<std::string, MDNode *>::iterator it = Structs.find(strName);
            if (it != Structs.end()) {
              Value *ret = findStructMemberName(it->second, memberIdx, builder);
              if (ret) {
                return ret;
}
            }
          }
        }
      }

      // we've found an array
      // (2025-10-30) Simplified check for array type for llvm 19 compatibility
      //if (PTy->getPointerElementType()->getTypeID() == Type::ArrayTyID && isa<GetElementPtrInst>(*ptrOperand)) {
      if (isa<GetElementPtrInst>(*ptrOperand)) {
        return determineVariableName_dynamic(cast<Instruction>(ptrOperand), prefix);
      }
      return determineVariableName_dynamic(static_cast<Instruction *>(gep), "GEPRESULT_"+prefix);
    }
    return getOrInsertVarName_dynamic(prefix + std::string(operand->getName().data()), builder);
  }

  if (isa<LoadInst>(*operand) || isa<StoreInst>(*operand)) {
    return determineVariableName_dynamic(cast<Instruction>(operand), prefix);
  }
  if (isa<AllocaInst>(I)) {
    return getOrInsertVarName_dynamic(prefix + I->getName().str(), builder);
  }
  // if we cannot determine the name, then return *
  return getOrInsertVarName_dynamic(prefix +  "*", builder);
}

void DiscoPoP::getTrueVarNamesFromMetadata(Region *TopRegion, Node * /*root*/,
                                           std::map<std::string, std::string> *trueVarNamesFromMetadataMap) {
  // check for deb_declare in Region
  // get IRVarName from first operand
  // get SRCVarName from second operand
  // update trueVarNamesFromMetadataMap
  for(auto BB : TopRegion->blocks()){
    for(auto &inst : BB->instructionsWithoutDebug()){
      auto dbg_record_range = inst.getDbgRecordRange();
      auto dbg_variable_range = filterDbgVars(dbg_record_range);
      for (DbgVariableRecord &DVR : dbg_variable_range) {
        std::string IRVarName = DVR.getValue()->getName().str();
        std::string SRCVarName = DVR.getVariable()->getName().str();
        // add to trueVarNamesFromMetadataMap
        // overwrite entry if already existing
        if (trueVarNamesFromMetadataMap->find(IRVarName) == trueVarNamesFromMetadataMap->end()) {
          // not found
          trueVarNamesFromMetadataMap->insert(std::pair<std::string, std::string>(IRVarName, SRCVarName));
        } else {
          // found
          (*trueVarNamesFromMetadataMap)[IRVarName] = SRCVarName;
        }
      }
    }
  }
}
