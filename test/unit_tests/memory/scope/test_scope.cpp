#include <gtest/gtest.h>

#include "memory/Scope.hpp"

// Tests for old version (i.e., capturing functionality)

class ScopeTest : public ::testing::Test {};

class ScopeManagerTest : public ::testing::Test {};

TEST_F(ScopeTest, testConstructor) {
  const auto scope_1 = dp::Scope(4);
  ASSERT_EQ(scope_1.GetId(), 4);

  ASSERT_TRUE(scope_1.GetFirstRead().empty());
  ASSERT_TRUE(scope_1.GetFirstWrite().empty());

  const auto scope_2 = dp::Scope(9);
  ASSERT_EQ(scope_2.GetId(), 9);

  ASSERT_TRUE(scope_2.GetFirstRead().empty());
  ASSERT_TRUE(scope_2.GetFirstWrite().empty());
}

TEST_F(ScopeTest, testRegisterRead) {
  auto scope = dp::Scope(3);
  const auto &reads = scope.GetFirstRead();
  const auto &writes = scope.GetFirstWrite();

  scope.RegisterStackRead(24, 0, "");
  scope.RegisterStackRead(32, 1, "");

  ASSERT_TRUE(writes.empty());
  ASSERT_EQ(reads.size(), 2);

  ASSERT_NE(reads.find(24), reads.end());
  ASSERT_NE(reads.find(32), reads.end());

  scope.RegisterStackRead(72, 1, "");
  scope.RegisterStackRead(24, 6, "");
  scope.RegisterStackRead(32, 1, "");

  ASSERT_TRUE(writes.empty());
  ASSERT_EQ(reads.size(), 3);

  ASSERT_NE(reads.find(24), reads.end());
  ASSERT_NE(reads.find(32), reads.end());
  ASSERT_NE(reads.find(72), reads.end());
}

TEST_F(ScopeTest, testRegisterWrite) {
  auto scope = dp::Scope(3);
  const auto &reads = scope.GetFirstRead();
  const auto &writes = scope.GetFirstWrite();

  scope.RegisterStackWrite(1024, 0, "");
  scope.RegisterStackWrite(1032, 1, "");

  ASSERT_TRUE(reads.empty());
  ASSERT_EQ(writes.size(), 2);

  ASSERT_NE(writes.find(1024), writes.end());
  ASSERT_NE(writes.find(1032), writes.end());

  scope.RegisterStackWrite(1072, 1, "");
  scope.RegisterStackWrite(1024, 6, "");
  scope.RegisterStackWrite(1032, 1, "");

  ASSERT_TRUE(reads.empty());
  ASSERT_EQ(writes.size(), 3);

  ASSERT_NE(writes.find(1024), writes.end());
  ASSERT_NE(writes.find(1032), writes.end());
  ASSERT_NE(writes.find(1072), writes.end());
}

TEST_F(ScopeTest, testRegister) {
  auto scope = dp::Scope(3);
  const auto &reads = scope.GetFirstRead();
  const auto &writes = scope.GetFirstWrite();

  scope.RegisterStackRead(24, 0, "");
  scope.RegisterStackWrite(1024, 0, "");
  scope.RegisterStackWrite(1032, 1, "");

  ASSERT_EQ(reads.size(), 1);
  ASSERT_EQ(writes.size(), 2);

  ASSERT_NE(reads.find(24), reads.end());
  ASSERT_NE(writes.find(1024), writes.end());
  ASSERT_NE(writes.find(1032), writes.end());

  scope.RegisterStackRead(32, 1, "");
  scope.RegisterStackRead(1024, 5, "");
  scope.RegisterStackWrite(1876, 0, "");
  scope.RegisterStackWrite(24, 0, "");

  ASSERT_EQ(reads.size(), 2);
  ASSERT_EQ(writes.size(), 3);

  ASSERT_NE(reads.find(24), reads.end());
  ASSERT_NE(reads.find(32), reads.end());
  ASSERT_NE(writes.find(1024), writes.end());
  ASSERT_NE(writes.find(1024), writes.end());
  ASSERT_NE(writes.find(1876), writes.end());
}

TEST_F(ScopeTest, testCopy1) {
  const auto scope_1 = dp::Scope(4);
  const auto scope_2 = dp::Scope(scope_1);

  ASSERT_EQ(scope_1.GetId(), scope_2.GetId());
  ASSERT_TRUE(scope_1.GetFirstRead().empty());
  ASSERT_TRUE(scope_1.GetFirstWrite().empty());
  ASSERT_TRUE(scope_2.GetFirstRead().empty());
  ASSERT_TRUE(scope_2.GetFirstWrite().empty());
}

TEST_F(ScopeTest, testCopy2) {
  auto scope_1 = dp::Scope(4);
  scope_1.RegisterStackRead(24, 0, "");
  scope_1.RegisterStackRead(32, 1, "");
  scope_1.RegisterStackWrite(1024, 0, "");
  scope_1.RegisterStackWrite(1032, 1, "");

  const auto scope_2 = dp::Scope(scope_1);

  ASSERT_EQ(scope_1.GetId(), scope_2.GetId());
  ASSERT_EQ(scope_1.GetFirstRead(), scope_2.GetFirstRead());
  ASSERT_EQ(scope_1.GetFirstWrite(), scope_2.GetFirstWrite());
}

TEST_F(ScopeTest, testCopy3) {
  auto scope_1 = dp::Scope(4);
  scope_1.RegisterStackRead(24, 0, "");
  scope_1.RegisterStackRead(32, 1, "");
  scope_1.RegisterStackWrite(1024, 0, "");
  scope_1.RegisterStackWrite(1032, 1, "");

  auto scope_2 = dp::Scope(scope_1);
  auto scope_3 = dp::Scope(scope_1);

  scope_2.RegisterStackRead(72, 1, "");
  scope_2.RegisterStackRead(24, 6, "");
  scope_2.RegisterStackRead(32, 1, "");

  scope_2.RegisterStackWrite(1072, 1, "");
  scope_2.RegisterStackWrite(1024, 6, "");
  scope_2.RegisterStackWrite(1032, 1, "");

  ASSERT_EQ(scope_1.GetId(), scope_3.GetId());
  ASSERT_EQ(scope_1.GetFirstRead(), scope_3.GetFirstRead());
  ASSERT_EQ(scope_1.GetFirstWrite(), scope_3.GetFirstWrite());
}

TEST_F(ScopeTest, testCopy4) {
  auto scope_1 = dp::Scope(4);
  scope_1.RegisterStackRead(24, 0, "");
  scope_1.RegisterStackRead(32, 1, "");
  scope_1.RegisterStackWrite(1024, 0, "");
  scope_1.RegisterStackWrite(1032, 1, "");

  auto scope_2 = dp::Scope(scope_1);
  auto scope_3 = dp::Scope(scope_1);

  scope_2.RegisterStackRead(72, 1, "");
  scope_2.RegisterStackRead(24, 6, "");
  scope_2.RegisterStackRead(32, 1, "");

  scope_2.RegisterStackWrite(1072, 1, "");
  scope_2.RegisterStackWrite(1024, 6, "");
  scope_2.RegisterStackWrite(1032, 1, "");

  scope_2 = scope_3;

  ASSERT_EQ(scope_1.GetId(), scope_2.GetId());
  ASSERT_EQ(scope_1.GetFirstRead(), scope_2.GetFirstRead());
  ASSERT_EQ(scope_1.GetFirstWrite(), scope_2.GetFirstWrite());

  ASSERT_EQ(scope_1.GetId(), scope_3.GetId());
  ASSERT_EQ(scope_1.GetFirstRead(), scope_3.GetFirstRead());
  ASSERT_EQ(scope_1.GetFirstWrite(), scope_3.GetFirstWrite());
}

TEST_F(ScopeManagerTest, testScoping) {
  auto manager = dp::ScopeManager{};

  manager.EnterScope("First scope", 0);
  const auto first_scope = manager.GetCurrentScope();
  manager.LeaveScope("Already gone", 0);

  ASSERT_EQ(first_scope.GetId(), 1);
  ASSERT_TRUE(first_scope.GetFirstRead().empty());
  ASSERT_TRUE(first_scope.GetFirstWrite().empty());

  manager.EnterScope("Hello", 1);
  manager.EnterScope(" ", 20);
  manager.EnterScope("world", 10);
  manager.EnterScope("!\n", 1);

  for (auto i = 0; i < 4; i++) {
    const auto scope = manager.GetCurrentScope();
    ASSERT_EQ(scope.GetId(), 5 - i);
    ASSERT_TRUE(scope.GetFirstRead().empty());
    ASSERT_TRUE(scope.GetFirstWrite().empty());

    const auto scope_again = manager.GetCurrentScope();
    ASSERT_EQ(scope_again.GetId(), 5 - i);
    ASSERT_TRUE(scope_again.GetFirstRead().empty());
    ASSERT_TRUE(scope_again.GetFirstWrite().empty());

    manager.LeaveScope("leave!", 55);
  }

  manager.EnterScope("New version", 2);
  manager.EnterScope("...\n", 5);

  const auto scope = manager.GetCurrentScope();
  ASSERT_EQ(scope.GetId(), 7);
  ASSERT_TRUE(scope.GetFirstRead().empty());
  ASSERT_TRUE(scope.GetFirstWrite().empty());

  manager.LeaveScope("Leave.", 4);

  const auto last_scope = manager.GetCurrentScope();
  ASSERT_EQ(last_scope.GetId(), 6);
  ASSERT_TRUE(last_scope.GetFirstRead().empty());
  ASSERT_TRUE(last_scope.GetFirstWrite().empty());

  manager.LeaveScope("Leave the last time", 0);
}

TEST_F(ScopeManagerTest, testRegisterRead) {
  auto manager = dp::ScopeManager{};

  manager.EnterScope("First", 1);

  manager.EnterScope("Second", 2);
  manager.RegisterStackRead(24, 2, "");
  manager.RegisterStackRead(32, 1, "");

  manager.EnterScope("Third", 3);
  manager.RegisterStackRead(1024, 0, "");

  manager.EnterScope("Fourth", 4);

  const auto scope4 = manager.GetCurrentScope();

  ASSERT_TRUE(scope4.GetFirstRead().empty());
  ASSERT_TRUE(scope4.GetFirstWrite().empty());

  manager.LeaveScope("Fourth", 4);

  manager.RegisterStackRead(52, 0, "");

  const auto scope3 = manager.GetCurrentScope();
  const auto reads3 = scope3.GetFirstRead();

  ASSERT_TRUE(scope3.GetFirstWrite().empty());
  ASSERT_EQ(reads3.size(), 2);
  ASSERT_NE(reads3.find(52), reads3.end());
  ASSERT_NE(reads3.find(1024), reads3.end());

  manager.LeaveScope("Third", 3);

  manager.RegisterStackRead(24, 2, "");

  const auto scope2 = manager.GetCurrentScope();
  const auto reads2 = scope2.GetFirstRead();

  ASSERT_TRUE(scope2.GetFirstWrite().empty());
  ASSERT_EQ(reads2.size(), 2);
  ASSERT_NE(reads2.find(24), reads3.end());
  ASSERT_NE(reads2.find(32), reads3.end());

  manager.LeaveScope("Second", 2);

  const auto scope1 = manager.GetCurrentScope();

  ASSERT_TRUE(scope1.GetFirstRead().empty());
  ASSERT_TRUE(scope1.GetFirstWrite().empty());

  manager.LeaveScope("First", 1);
}

TEST_F(ScopeManagerTest, testRegisterWrite) {
  auto manager = dp::ScopeManager{};

  manager.EnterScope("First", 1);

  manager.EnterScope("Second", 2);
  manager.RegisterStackWrite(24, 2, "");
  manager.RegisterStackWrite(32, 1, "");

  manager.EnterScope("Third", 3);
  manager.RegisterStackWrite(1024, 0, "");

  manager.EnterScope("Fourth", 4);

  const auto scope4 = manager.GetCurrentScope();

  ASSERT_TRUE(scope4.GetFirstRead().empty());
  ASSERT_TRUE(scope4.GetFirstWrite().empty());

  manager.LeaveScope("Fourth", 4);

  manager.RegisterStackWrite(52, 0, "");

  const auto scope3 = manager.GetCurrentScope();
  const auto writes3 = scope3.GetFirstWrite();

  ASSERT_TRUE(scope3.GetFirstRead().empty());
  ASSERT_EQ(writes3.size(), 2);
  ASSERT_NE(writes3.find(52), writes3.end());
  ASSERT_NE(writes3.find(1024), writes3.end());

  manager.LeaveScope("Third", 3);

  manager.RegisterStackWrite(24, 2, "");

  const auto scope2 = manager.GetCurrentScope();
  const auto writes2 = scope2.GetFirstWrite();

  ASSERT_TRUE(scope2.GetFirstRead().empty());
  ASSERT_EQ(writes2.size(), 2);
  ASSERT_NE(writes2.find(24), writes2.end());
  ASSERT_NE(writes2.find(32), writes2.end());

  manager.LeaveScope("Second", 2);

  const auto scope1 = manager.GetCurrentScope();

  ASSERT_TRUE(scope1.GetFirstRead().empty());
  ASSERT_TRUE(scope1.GetFirstWrite().empty());

  manager.LeaveScope("First", 1);
}

TEST_F(ScopeManagerTest, testRegister) {
  auto manager = dp::ScopeManager{};

  manager.EnterScope("First", 1);

  manager.RegisterStackRead(32, 0, "");
  manager.RegisterStackRead(24, 1, "");

  manager.EnterScope("Second", 2);

  manager.RegisterStackRead(32, 3, "");
  manager.RegisterStackWrite(24, 4, "");

  manager.EnterScope("Third", 3);

  manager.RegisterStackRead(24, 5, "");
  manager.RegisterStackWrite(24, 6, "");

  const auto scope3 = manager.GetCurrentScope();
  const auto reads3 = scope3.GetFirstRead();
  const auto writes3 = scope3.GetFirstWrite();

  manager.LeaveScope("Third", 3);

  const auto scope2 = manager.GetCurrentScope();
  const auto reads2 = scope2.GetFirstRead();
  const auto writes2 = scope2.GetFirstWrite();

  manager.LeaveScope("Second", 2);

  const auto scope1 = manager.GetCurrentScope();
  const auto reads1 = scope1.GetFirstRead();
  const auto writes1 = scope1.GetFirstWrite();

  manager.LeaveScope("First", 1);

  ASSERT_TRUE(writes1.empty());
  ASSERT_EQ(reads1.size(), 2);
  ASSERT_NE(reads1.find(24), reads1.end());
  ASSERT_NE(reads1.find(32), reads1.end());

  ASSERT_EQ(reads2.size(), 1);
  ASSERT_EQ(writes2.size(), 1);
  ASSERT_NE(reads2.find(32), reads2.end());
  ASSERT_NE(writes2.find(24), writes2.end());

  ASSERT_TRUE(writes3.empty());
  ASSERT_EQ(reads3.size(), 1);
  ASSERT_NE(reads3.find(24), reads3.end());
}

TEST_F(ScopeManagerTest, testFirstWritten) {
  auto manager = dp::ScopeManager{};

  manager.EnterScope("First", 1);
  manager.RegisterStackRead(24, 0, "");
  manager.RegisterStackWrite(24, 1, "");
  manager.RegisterStackWrite(12, 2, "");
  manager.RegisterStackRead(12, 3, "");

  manager.EnterScope("Second", 2);
  manager.RegisterStackWrite(24, 2, "");
  manager.RegisterStackRead(24, 3, "");
  manager.RegisterStackRead(12, 0, "");
  manager.RegisterStackWrite(12, 1, "");

  manager.EnterScope("Third", 3);
  manager.RegisterStackRead(32, 4, "");
  manager.RegisterStackWrite(36, 5, "");
  manager.RegisterStackRead(40, 6, "");

  ASSERT_TRUE(manager.IsOwnedByScope(36, true));
  ASSERT_TRUE(manager.IsOwnedByScope(1012, true));
  ASSERT_TRUE(manager.IsOwnedByScope(1024, true));

  ASSERT_FALSE(manager.IsOwnedByScope(12, true));
  ASSERT_FALSE(manager.IsOwnedByScope(24, true));
  ASSERT_FALSE(manager.IsOwnedByScope(32, true));
  ASSERT_FALSE(manager.IsOwnedByScope(32, false));
  ASSERT_FALSE(manager.IsOwnedByScope(40, true));
  ASSERT_FALSE(manager.IsOwnedByScope(40, false));
  ASSERT_FALSE(manager.IsOwnedByScope(1012, false));
  ASSERT_FALSE(manager.IsOwnedByScope(1024, false));
}

TEST_F(ScopeManagerTest, testPositiveChange) {
  auto scope = dp::ScopeManager{};

  scope.EnterScope("First", 1);
  scope.RegisterStackRead(24, 0, "");
  scope.RegisterStackRead(64, 1, "");

  scope.EnterScope("Second", 2);
  scope.RegisterStackWrite(32, 2, "");

  scope.EnterScope("Third", 3);
  scope.RegisterStackWrite(64, 3, "");

  ASSERT_TRUE(scope.PositiveScopeChangeOccuredSinceLastAccess(12));
  ASSERT_TRUE(scope.PositiveScopeChangeOccuredSinceLastAccess(24));
  ASSERT_TRUE(scope.PositiveScopeChangeOccuredSinceLastAccess(32));
  ASSERT_FALSE(scope.PositiveScopeChangeOccuredSinceLastAccess(64));

  scope.LeaveScope("Third", 3);

  ASSERT_TRUE(scope.PositiveScopeChangeOccuredSinceLastAccess(12));
  ASSERT_TRUE(scope.PositiveScopeChangeOccuredSinceLastAccess(24));
  ASSERT_FALSE(scope.PositiveScopeChangeOccuredSinceLastAccess(32));
  ASSERT_FALSE(scope.PositiveScopeChangeOccuredSinceLastAccess(64));

  scope.LeaveScope("Second", 2);

  ASSERT_TRUE(scope.PositiveScopeChangeOccuredSinceLastAccess(12));
  ASSERT_FALSE(scope.PositiveScopeChangeOccuredSinceLastAccess(24));
  ASSERT_FALSE(scope.PositiveScopeChangeOccuredSinceLastAccess(32));
  ASSERT_FALSE(scope.PositiveScopeChangeOccuredSinceLastAccess(64));

  scope.LeaveScope("First", 1);

  // TODO(Lukas): Currently, there is no active scope.
  //      Think about your error handling.

  // ASSERT_TRUE(scope.positiveScopeChangeOccuredSinceLastAccess(12));
  // ASSERT_FALSE(scope.positiveScopeChangeOccuredSinceLastAccess(24));
  // ASSERT_FALSE(scope.positiveScopeChangeOccuredSinceLastAccess(32));
  // ASSERT_FALSE(scope.positiveScopeChangeOccuredSinceLastAccess(64));

  scope.EnterScope("Forth", 4);

  scope.RegisterStackRead(24, 4, "");

  ASSERT_TRUE(scope.PositiveScopeChangeOccuredSinceLastAccess(12));
  ASSERT_FALSE(scope.PositiveScopeChangeOccuredSinceLastAccess(24));
  ASSERT_TRUE(scope.PositiveScopeChangeOccuredSinceLastAccess(32));
  ASSERT_TRUE(scope.PositiveScopeChangeOccuredSinceLastAccess(64));

  scope.EnterScope("Fifth", 5);

  ASSERT_TRUE(scope.PositiveScopeChangeOccuredSinceLastAccess(12));
  ASSERT_TRUE(scope.PositiveScopeChangeOccuredSinceLastAccess(24));
  ASSERT_TRUE(scope.PositiveScopeChangeOccuredSinceLastAccess(32));
  ASSERT_TRUE(scope.PositiveScopeChangeOccuredSinceLastAccess(64));
}

// Tests for new version (i.e., reproducing functionality)

class Scope2Test : public ::testing::Test {};

class ScopeManager2Test : public ::testing::Test {};

TEST_F(Scope2Test, testConstructor) {
  const auto scope_1 = dp::Scope2(4);
  ASSERT_EQ(scope_1.GetId(), 4);

  ASSERT_TRUE(scope_1.GetFirstRead().empty());
  ASSERT_TRUE(scope_1.GetFirstWrite().empty());

  const auto scope_2 = dp::Scope2(9);
  ASSERT_EQ(scope_2.GetId(), 9);

  ASSERT_TRUE(scope_2.GetFirstRead().empty());
  ASSERT_TRUE(scope_2.GetFirstWrite().empty());
}

TEST_F(Scope2Test, testRegisterRead) {
  auto scope = dp::Scope2(3);
  const auto &reads = scope.GetFirstRead();
  const auto &writes = scope.GetFirstWrite();

  scope.RegisterStackRead(24, 0, "");
  scope.RegisterStackRead(32, 1, "");

  ASSERT_TRUE(writes.empty());
  ASSERT_EQ(reads.size(), 2);

  ASSERT_NE(reads.find(24), reads.end());
  ASSERT_NE(reads.find(32), reads.end());

  scope.RegisterStackRead(72, 1, "");
  scope.RegisterStackRead(24, 6, "");
  scope.RegisterStackRead(32, 1, "");

  ASSERT_TRUE(writes.empty());
  ASSERT_EQ(reads.size(), 3);

  ASSERT_NE(reads.find(24), reads.end());
  ASSERT_NE(reads.find(32), reads.end());
  ASSERT_NE(reads.find(72), reads.end());
}

TEST_F(Scope2Test, testRegisterWrite) {
  auto scope = dp::Scope2(3);
  const auto &reads = scope.GetFirstRead();
  const auto &writes = scope.GetFirstWrite();

  scope.RegisterStackWrite(1024, 0, "");
  scope.RegisterStackWrite(1032, 1, "");

  ASSERT_TRUE(reads.empty());
  ASSERT_EQ(writes.size(), 2);

  ASSERT_NE(writes.find(1024), writes.end());
  ASSERT_NE(writes.find(1032), writes.end());

  scope.RegisterStackWrite(1072, 1, "");
  scope.RegisterStackWrite(1024, 6, "");
  scope.RegisterStackWrite(1032, 1, "");

  ASSERT_TRUE(reads.empty());
  ASSERT_EQ(writes.size(), 3);

  ASSERT_NE(writes.find(1024), writes.end());
  ASSERT_NE(writes.find(1032), writes.end());
  ASSERT_NE(writes.find(1072), writes.end());
}

TEST_F(Scope2Test, testRegister) {
  auto scope = dp::Scope2(3);
  const auto &reads = scope.GetFirstRead();
  const auto &writes = scope.GetFirstWrite();

  scope.RegisterStackRead(24, 0, "");
  scope.RegisterStackWrite(1024, 0, "");
  scope.RegisterStackWrite(1032, 1, "");

  ASSERT_EQ(reads.size(), 1);
  ASSERT_EQ(writes.size(), 2);

  ASSERT_NE(reads.find(24), reads.end());
  ASSERT_NE(writes.find(1024), writes.end());
  ASSERT_NE(writes.find(1032), writes.end());

  scope.RegisterStackRead(32, 1, "");
  scope.RegisterStackRead(1024, 5, "");
  scope.RegisterStackWrite(1876, 0, "");
  scope.RegisterStackWrite(24, 0, "");

  ASSERT_EQ(reads.size(), 2);
  ASSERT_EQ(writes.size(), 3);

  ASSERT_NE(reads.find(24), reads.end());
  ASSERT_NE(reads.find(32), reads.end());
  ASSERT_NE(writes.find(1024), writes.end());
  ASSERT_NE(writes.find(1024), writes.end());
  ASSERT_NE(writes.find(1876), writes.end());
}

TEST_F(Scope2Test, testCopy1) {
  const auto scope_1 = dp::Scope2(4);
  const auto scope_2 = dp::Scope2(scope_1);

  ASSERT_EQ(scope_1.GetId(), scope_2.GetId());
  ASSERT_TRUE(scope_1.GetFirstRead().empty());
  ASSERT_TRUE(scope_1.GetFirstWrite().empty());
  ASSERT_TRUE(scope_2.GetFirstRead().empty());
  ASSERT_TRUE(scope_2.GetFirstWrite().empty());
}

TEST_F(Scope2Test, testCopy2) {
  auto scope_1 = dp::Scope2(4);
  scope_1.RegisterStackRead(24, 0, "");
  scope_1.RegisterStackRead(32, 1, "");
  scope_1.RegisterStackWrite(1024, 0, "");
  scope_1.RegisterStackWrite(1032, 1, "");

  const auto scope_2 = dp::Scope2(scope_1);

  ASSERT_EQ(scope_1.GetId(), scope_2.GetId());
  ASSERT_EQ(scope_1.GetFirstRead(), scope_2.GetFirstRead());
  ASSERT_EQ(scope_1.GetFirstWrite(), scope_2.GetFirstWrite());
}

TEST_F(Scope2Test, testCopy3) {
  auto scope_1 = dp::Scope2(4);
  scope_1.RegisterStackRead(24, 0, "");
  scope_1.RegisterStackRead(32, 1, "");
  scope_1.RegisterStackWrite(1024, 0, "");
  scope_1.RegisterStackWrite(1032, 1, "");

  auto scope_2 = dp::Scope2(scope_1);
  auto scope_3 = dp::Scope2(scope_1);

  scope_2.RegisterStackRead(72, 1, "");
  scope_2.RegisterStackRead(24, 6, "");
  scope_2.RegisterStackRead(32, 1, "");

  scope_2.RegisterStackWrite(1072, 1, "");
  scope_2.RegisterStackWrite(1024, 6, "");
  scope_2.RegisterStackWrite(1032, 1, "");

  ASSERT_EQ(scope_1.GetId(), scope_3.GetId());
  ASSERT_EQ(scope_1.GetFirstRead(), scope_3.GetFirstRead());
  ASSERT_EQ(scope_1.GetFirstWrite(), scope_3.GetFirstWrite());
}

TEST_F(Scope2Test, testCopy4) {
  auto scope_1 = dp::Scope2(4);
  scope_1.RegisterStackRead(24, 0, "");
  scope_1.RegisterStackRead(32, 1, "");
  scope_1.RegisterStackWrite(1024, 0, "");
  scope_1.RegisterStackWrite(1032, 1, "");

  auto scope_2 = dp::Scope2(scope_1);
  auto scope_3 = dp::Scope2(scope_1);

  scope_2.RegisterStackRead(72, 1, "");
  scope_2.RegisterStackRead(24, 6, "");
  scope_2.RegisterStackRead(32, 1, "");

  scope_2.RegisterStackWrite(1072, 1, "");
  scope_2.RegisterStackWrite(1024, 6, "");
  scope_2.RegisterStackWrite(1032, 1, "");

  scope_2 = scope_3;

  ASSERT_EQ(scope_1.GetId(), scope_2.GetId());
  ASSERT_EQ(scope_1.GetFirstRead(), scope_2.GetFirstRead());
  ASSERT_EQ(scope_1.GetFirstWrite(), scope_2.GetFirstWrite());

  ASSERT_EQ(scope_1.GetId(), scope_3.GetId());
  ASSERT_EQ(scope_1.GetFirstRead(), scope_3.GetFirstRead());
  ASSERT_EQ(scope_1.GetFirstWrite(), scope_3.GetFirstWrite());
}

TEST_F(ScopeManager2Test, testScoping) {
  auto manager = dp::ScopeManager2{};

  manager.EnterScope("First scope", 0);
  const auto first_scope = manager.GetCurrentScope();
  manager.LeaveScope("Already gone", 0);

  ASSERT_EQ(first_scope.GetId(), 1);
  ASSERT_TRUE(first_scope.GetFirstRead().empty());
  ASSERT_TRUE(first_scope.GetFirstWrite().empty());

  manager.EnterScope("Hello", 1);
  manager.EnterScope(" ", 20);
  manager.EnterScope("world", 10);
  manager.EnterScope("!\n", 1);

  for (auto i = 0; i < 4; i++) {
    const auto scope = manager.GetCurrentScope();
    ASSERT_EQ(scope.GetId(), 5 - i);
    ASSERT_TRUE(scope.GetFirstRead().empty());
    ASSERT_TRUE(scope.GetFirstWrite().empty());

    const auto scope_again = manager.GetCurrentScope();
    ASSERT_EQ(scope_again.GetId(), 5 - i);
    ASSERT_TRUE(scope_again.GetFirstRead().empty());
    ASSERT_TRUE(scope_again.GetFirstWrite().empty());

    manager.LeaveScope("leave!", 55);
  }

  manager.EnterScope("New version", 2);
  manager.EnterScope("...\n", 5);

  const auto scope = manager.GetCurrentScope();
  ASSERT_EQ(scope.GetId(), 7);
  ASSERT_TRUE(scope.GetFirstRead().empty());
  ASSERT_TRUE(scope.GetFirstWrite().empty());

  manager.LeaveScope("Leave.", 4);

  const auto last_scope = manager.GetCurrentScope();
  ASSERT_EQ(last_scope.GetId(), 6);
  ASSERT_TRUE(last_scope.GetFirstRead().empty());
  ASSERT_TRUE(last_scope.GetFirstWrite().empty());

  manager.LeaveScope("Leave the last time", 0);
}

TEST_F(ScopeManager2Test, testRegisterRead) {
  auto manager = dp::ScopeManager2{};

  manager.EnterScope("First", 1);

  manager.EnterScope("Second", 2);
  manager.RegisterStackRead(24, 2, "");
  manager.RegisterStackRead(32, 1, "");

  manager.EnterScope("Third", 3);
  manager.RegisterStackRead(1024, 0, "");

  manager.EnterScope("Fourth", 4);

  const auto scope4 = manager.GetCurrentScope();

  ASSERT_TRUE(scope4.GetFirstRead().empty());
  ASSERT_TRUE(scope4.GetFirstWrite().empty());

  manager.LeaveScope("Fourth", 4);

  manager.RegisterStackRead(52, 0, "");

  const auto scope3 = manager.GetCurrentScope();
  const auto reads3 = scope3.GetFirstRead();

  ASSERT_TRUE(scope3.GetFirstWrite().empty());
  ASSERT_EQ(reads3.size(), 2);
  ASSERT_NE(reads3.find(52), reads3.end());
  ASSERT_NE(reads3.find(1024), reads3.end());

  manager.LeaveScope("Third", 3);

  manager.RegisterStackRead(24, 2, "");

  const auto scope2 = manager.GetCurrentScope();
  const auto reads2 = scope2.GetFirstRead();

  ASSERT_TRUE(scope2.GetFirstWrite().empty());
  ASSERT_EQ(reads2.size(), 2);
  ASSERT_NE(reads2.find(24), reads3.end());
  ASSERT_NE(reads2.find(32), reads3.end());

  manager.LeaveScope("Second", 2);

  const auto scope1 = manager.GetCurrentScope();

  ASSERT_TRUE(scope1.GetFirstRead().empty());
  ASSERT_TRUE(scope1.GetFirstWrite().empty());

  manager.LeaveScope("First", 1);
}

TEST_F(ScopeManager2Test, testRegisterWrite) {
  auto manager = dp::ScopeManager2{};

  manager.EnterScope("First", 1);

  manager.EnterScope("Second", 2);
  manager.RegisterStackWrite(24, 2, "");
  manager.RegisterStackWrite(32, 1, "");

  manager.EnterScope("Third", 3);
  manager.RegisterStackWrite(1024, 0, "");

  manager.EnterScope("Fourth", 4);

  const auto scope4 = manager.GetCurrentScope();

  ASSERT_TRUE(scope4.GetFirstRead().empty());
  ASSERT_TRUE(scope4.GetFirstWrite().empty());

  manager.LeaveScope("Fourth", 4);

  manager.RegisterStackWrite(52, 0, "");

  const auto scope3 = manager.GetCurrentScope();
  const auto writes3 = scope3.GetFirstWrite();

  ASSERT_TRUE(scope3.GetFirstRead().empty());
  ASSERT_EQ(writes3.size(), 2);
  ASSERT_NE(writes3.find(52), writes3.end());
  ASSERT_NE(writes3.find(1024), writes3.end());

  manager.LeaveScope("Third", 3);

  manager.RegisterStackWrite(24, 2, "");

  const auto scope2 = manager.GetCurrentScope();
  const auto writes2 = scope2.GetFirstWrite();

  ASSERT_TRUE(scope2.GetFirstRead().empty());
  ASSERT_EQ(writes2.size(), 2);
  ASSERT_NE(writes2.find(24), writes2.end());
  ASSERT_NE(writes2.find(32), writes2.end());

  manager.LeaveScope("Second", 2);

  const auto scope1 = manager.GetCurrentScope();

  ASSERT_TRUE(scope1.GetFirstRead().empty());
  ASSERT_TRUE(scope1.GetFirstWrite().empty());

  manager.LeaveScope("First", 1);
}

TEST_F(ScopeManager2Test, testRegister) {
  auto manager = dp::ScopeManager2{};

  manager.EnterScope("First", 1);

  manager.RegisterStackRead(32, 0, "");
  manager.RegisterStackRead(24, 1, "");

  manager.EnterScope("Second", 2);

  manager.RegisterStackRead(32, 3, "");
  manager.RegisterStackWrite(24, 4, "");

  manager.EnterScope("Third", 3);

  manager.RegisterStackRead(24, 5, "");
  manager.RegisterStackWrite(24, 6, "");

  const auto scope3 = manager.GetCurrentScope();
  const auto reads3 = scope3.GetFirstRead();
  const auto writes3 = scope3.GetFirstWrite();

  manager.LeaveScope("Third", 3);

  const auto scope2 = manager.GetCurrentScope();
  const auto reads2 = scope2.GetFirstRead();
  const auto writes2 = scope2.GetFirstWrite();

  manager.LeaveScope("Second", 2);

  const auto scope1 = manager.GetCurrentScope();
  const auto reads1 = scope1.GetFirstRead();
  const auto writes1 = scope1.GetFirstWrite();

  manager.LeaveScope("First", 1);

  ASSERT_TRUE(writes1.empty());
  ASSERT_EQ(reads1.size(), 2);
  ASSERT_NE(reads1.find(24), reads1.end());
  ASSERT_NE(reads1.find(32), reads1.end());

  ASSERT_EQ(reads2.size(), 1);
  ASSERT_EQ(writes2.size(), 1);
  ASSERT_NE(reads2.find(32), reads2.end());
  ASSERT_NE(writes2.find(24), writes2.end());

  ASSERT_TRUE(writes3.empty());
  ASSERT_EQ(reads3.size(), 1);
  ASSERT_NE(reads3.find(24), reads3.end());
}

TEST_F(ScopeManager2Test, testFirstWritten) {
  auto manager = dp::ScopeManager2{};

  manager.EnterScope("First", 1);
  manager.RegisterStackRead(24, 0, "");
  manager.RegisterStackWrite(24, 1, "");
  manager.RegisterStackWrite(12, 2, "");
  manager.RegisterStackRead(12, 3, "");

  manager.EnterScope("Second", 2);
  manager.RegisterStackWrite(24, 2, "");
  manager.RegisterStackRead(24, 3, "");
  manager.RegisterStackRead(12, 0, "");
  manager.RegisterStackWrite(12, 1, "");

  manager.EnterScope("Third", 3);
  manager.RegisterStackRead(32, 4, "");
  manager.RegisterStackWrite(36, 5, "");
  manager.RegisterStackRead(40, 6, "");

  ASSERT_TRUE(manager.IsOwnedByScope(36, true));
  ASSERT_TRUE(manager.IsOwnedByScope(1012, true));
  ASSERT_TRUE(manager.IsOwnedByScope(1024, true));

  ASSERT_FALSE(manager.IsOwnedByScope(12, true));
  ASSERT_FALSE(manager.IsOwnedByScope(24, true));
  ASSERT_FALSE(manager.IsOwnedByScope(32, true));
  ASSERT_FALSE(manager.IsOwnedByScope(32, false));
  ASSERT_FALSE(manager.IsOwnedByScope(40, true));
  ASSERT_FALSE(manager.IsOwnedByScope(40, false));
  ASSERT_FALSE(manager.IsOwnedByScope(1012, false));
  ASSERT_FALSE(manager.IsOwnedByScope(1024, false));
}

TEST_F(ScopeManager2Test, testPositiveChange) {
  auto manager = dp::ScopeManager2{};

  manager.EnterScope("First", 1);
  manager.RegisterStackRead(24, 0, "");
  manager.RegisterStackRead(64, 1, "");

  manager.EnterScope("Second", 2);
  manager.RegisterStackWrite(32, 2, "");

  manager.EnterScope("Third", 3);
  manager.RegisterStackWrite(64, 3, "");

  ASSERT_TRUE(manager.PositiveScopeChangeOccuredSinceLastAccess(12));
  ASSERT_TRUE(manager.PositiveScopeChangeOccuredSinceLastAccess(24));
  ASSERT_TRUE(manager.PositiveScopeChangeOccuredSinceLastAccess(32));
  ASSERT_FALSE(manager.PositiveScopeChangeOccuredSinceLastAccess(64));

  manager.LeaveScope("Third", 3);

  ASSERT_TRUE(manager.PositiveScopeChangeOccuredSinceLastAccess(12));
  ASSERT_TRUE(manager.PositiveScopeChangeOccuredSinceLastAccess(24));
  ASSERT_FALSE(manager.PositiveScopeChangeOccuredSinceLastAccess(32));
  ASSERT_FALSE(manager.PositiveScopeChangeOccuredSinceLastAccess(64));

  manager.LeaveScope("Second", 2);

  ASSERT_TRUE(manager.PositiveScopeChangeOccuredSinceLastAccess(12));
  ASSERT_FALSE(manager.PositiveScopeChangeOccuredSinceLastAccess(24));
  ASSERT_FALSE(manager.PositiveScopeChangeOccuredSinceLastAccess(32));
  ASSERT_FALSE(manager.PositiveScopeChangeOccuredSinceLastAccess(64));

  manager.LeaveScope("First", 1);

  // These do not work anymore
  // ASSERT_TRUE(scope.positiveScopeChangeOccuredSinceLastAccess(12));
  // ASSERT_FALSE(scope.positiveScopeChangeOccuredSinceLastAccess(24));
  // ASSERT_FALSE(scope.positiveScopeChangeOccuredSinceLastAccess(32));
  // ASSERT_FALSE(scope.positiveScopeChangeOccuredSinceLastAccess(64));

  manager.EnterScope("Forth", 4);

  manager.RegisterStackRead(24, 4, "");

  ASSERT_TRUE(manager.PositiveScopeChangeOccuredSinceLastAccess(12));
  ASSERT_FALSE(manager.PositiveScopeChangeOccuredSinceLastAccess(24));
  ASSERT_TRUE(manager.PositiveScopeChangeOccuredSinceLastAccess(32));
  ASSERT_TRUE(manager.PositiveScopeChangeOccuredSinceLastAccess(64));

  manager.EnterScope("Fifth", 5);

  ASSERT_TRUE(manager.PositiveScopeChangeOccuredSinceLastAccess(12));
  ASSERT_TRUE(manager.PositiveScopeChangeOccuredSinceLastAccess(24));
  ASSERT_TRUE(manager.PositiveScopeChangeOccuredSinceLastAccess(32));
  ASSERT_TRUE(manager.PositiveScopeChangeOccuredSinceLastAccess(64));
}

TEST_F(ScopeManagerTest, testNumberOpenScopes) {
  auto manager = dp::ScopeManager{};

  ASSERT_EQ(manager.NumberOpenScopes(), 0);

  manager.EnterScope("function", 1);
  ASSERT_EQ(manager.NumberOpenScopes(), 1);

  manager.EnterScope("loop", 2);
  manager.EnterScope("loop_iteration", 3);
  ASSERT_EQ(manager.NumberOpenScopes(), 3);
  ASSERT_EQ(manager.GetCurrentScope().GetId(), 3);

  manager.LeaveScope("loop_iteration", 4);
  ASSERT_EQ(manager.NumberOpenScopes(), 2);
  ASSERT_EQ(manager.GetCurrentScope().GetId(), 2);

  manager.LeaveScope("loop", 5);
  manager.LeaveScope("function", 6);
  ASSERT_EQ(manager.NumberOpenScopes(), 0);

  // the type a scope is left with is never compared against the one it was entered with, so the
  // manager cannot tell a mismatched pair from a matching one
  manager.EnterScope("loop", 7);
  manager.LeaveScope("function", 8);
  ASSERT_EQ(manager.NumberOpenScopes(), 0);
}

TEST_F(ScopeManager2Test, testNumberOpenScopes) {
  auto manager = dp::ScopeManager2{};

  ASSERT_EQ(manager.NumberOpenScopes(), 0);

  manager.EnterScope("function", 1);
  ASSERT_EQ(manager.NumberOpenScopes(), 1);

  manager.EnterScope("loop", 2);
  manager.EnterScope("loop_iteration", 3);
  ASSERT_EQ(manager.NumberOpenScopes(), 3);
  ASSERT_EQ(manager.GetCurrentScope().GetId(), 3);

  manager.LeaveScope("loop_iteration", 4);
  ASSERT_EQ(manager.NumberOpenScopes(), 2);
  ASSERT_EQ(manager.GetCurrentScope().GetId(), 2);

  manager.LeaveScope("loop", 5);
  manager.LeaveScope("function", 6);
  ASSERT_EQ(manager.NumberOpenScopes(), 0);

  manager.EnterScope("loop", 7);
  manager.LeaveScope("function", 8);
  ASSERT_EQ(manager.NumberOpenScopes(), 0);
}

TEST_F(ScopeManagerTest, testLeavingAScopeThatWasNeverEntered) {
  auto manager = dp::ScopeManager{};

  manager.LeaveScope("function", 1);

  ASSERT_EQ(manager.NumberOpenScopes(), 0);

  // and the manager still works afterwards
  manager.EnterScope("function", 2);
  ASSERT_EQ(manager.NumberOpenScopes(), 1);
}

TEST_F(ScopeManagerTest, testTheScopeChangeIsMeasuredAgainstTheLastAccess) {
  auto manager = dp::ScopeManager{};
  manager.EnterScope("function", 1);

  // an address nothing has ever touched has no last access, so anything counts as a change
  ASSERT_TRUE(manager.PositiveScopeChangeOccuredSinceLastAccess(0x1000));

  // an address accessed in the current scope has not seen one
  manager.RegisterStackWrite(0x2000, 2, "x");
  ASSERT_FALSE(manager.PositiveScopeChangeOccuredSinceLastAccess(0x2000));

  manager.EnterScope("loop", 3);
  ASSERT_TRUE(manager.PositiveScopeChangeOccuredSinceLastAccess(0x2000));

  // the answer for an unknown address is the same whether the map holds a zero for it or nothing
  // at all, which is why only the growth of the map tells the two apart
  ASSERT_TRUE(manager.PositiveScopeChangeOccuredSinceLastAccess(0x1000));
}

TEST_F(ScopeManager2Test, testLeavingAScopeThatWasNeverEntered) {
  auto manager = dp::ScopeManager2{};

  manager.LeaveScope("function", 1);

  ASSERT_EQ(manager.NumberOpenScopes(), 0);

  manager.EnterScope("function", 2);
  ASSERT_EQ(manager.NumberOpenScopes(), 1);
}

TEST_F(ScopeManager2Test, testTheSecondManagerTakesTheSameArgumentsAsTheFirst) {
  auto manager = dp::ScopeManager2{};
  manager.EnterScope("function", 1);

  // the variable name is only there for debugging, and a literal is what the callbacks pass. The
  // second manager used to take it as char *, which no caller of the first one could satisfy.
  manager.RegisterStackWrite(0x1000, 2, "x");
  manager.RegisterStackRead(0x2000, 3, "y");

  ASSERT_TRUE(manager.IsOwnedByScope(0x1000, false));
  ASSERT_FALSE(manager.IsOwnedByScope(0x2000, false));
}
