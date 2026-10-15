#include <gtest/gtest.h>

#include "memory/Signature.hpp"

// slotSize=16 (2 bytes/slot), 4 slots -> hash(elem) = ((elem >> 8) + elem) % 4.
// elem 0 and elem 4 both hash to slot 0, elem 1 hashes to slot 1: used below to
// exercise the shared-slot ("conflict") semantics documented on Signature::insert.
class SignatureTest : public ::testing::Test {};

TEST_F(SignatureTest, testInsertOnEmptySlotReturnsZeroAndIsRetrievable) {
  dp::Signature sig(16, 4);

  const auto old_value = sig.Insert(0, 1234);

  EXPECT_EQ(old_value, 0);
  EXPECT_EQ(sig.MembershipCheck(0), 1234);
}

TEST_F(SignatureTest, testInsertIntoSharedSlotReturnsPreviousValue) {
  dp::Signature sig(16, 4);

  sig.Insert(0, 1000);
  const auto old_value = sig.Insert(4, 2000); // elem 4 shares elem 0's slot

  EXPECT_EQ(old_value, 1000);
  EXPECT_EQ(sig.MembershipCheck(0), 2000);
  EXPECT_EQ(sig.MembershipCheck(4), 2000);
}

TEST_F(SignatureTest, testDistinctSlotsDoNotInterfere) {
  dp::Signature sig(16, 4);

  sig.Insert(0, 1234);
  sig.Insert(1, 555);

  EXPECT_EQ(sig.MembershipCheck(0), 1234);
  EXPECT_EQ(sig.MembershipCheck(1), 555);
}

TEST_F(SignatureTest, testUpdateOverwritesValueWithoutConflictReporting) {
  dp::Signature sig(16, 4);

  sig.Insert(0, 1000);
  sig.Update(0, 3000);

  EXPECT_EQ(sig.MembershipCheck(0), 3000);
}

TEST_F(SignatureTest, testRemoveClearsSlot) {
  dp::Signature sig(16, 4);

  sig.Insert(0, 1234);
  sig.Remove(0);

  EXPECT_EQ(sig.MembershipCheck(0), 0);
}

TEST_F(SignatureTest, testRemoveClearsSharedSlotForAllElementsMappingToIt) {
  dp::Signature sig(16, 4);

  sig.Insert(0, 1000);
  sig.Insert(4, 2000); // overwrites the slot shared with elem 0

  sig.Remove(0); // removal is slot-based, so this also clears elem 4's value

  EXPECT_EQ(sig.MembershipCheck(0), 0);
  EXPECT_EQ(sig.MembershipCheck(4), 0);
}

TEST_F(SignatureTest, testMembershipCheckOnUnusedSlotReturnsZero) {
  dp::Signature sig(16, 4);

  EXPECT_EQ(sig.MembershipCheck(2), 0);
}

TEST_F(SignatureTest, testUpdateWorksOnASlotThatWasNeverInsertedInto) {
  dp::Signature sig(16, 4);

  sig.Update(2, 777);

  EXPECT_EQ(sig.MembershipCheck(2), 777);
}

TEST_F(SignatureTest, testByteWideSlotsTruncateToTheLowestByte) {
  dp::Signature sig(8, 4);

  sig.Insert(0, 0x1234);

  EXPECT_EQ(sig.MembershipCheck(0), 0x34);
}

TEST_F(SignatureTest, testFourByteSlotsKeepAFullWord) {
  dp::Signature sig(32, 4);

  sig.Insert(0, 0x12345678);
  EXPECT_EQ(sig.MembershipCheck(0), 0x12345678);

  // and still drop everything above the slot size
  sig.Insert(1, 0x1122334455);
  EXPECT_EQ(sig.MembershipCheck(1), 0x22334455);
}

TEST_F(SignatureTest, testTheHashFoldsTheUpperBytesIn) {
  dp::Signature sig(16, 4);

  // the hash is ((elem >> 8) + elem) % numSlot, not elem % numSlot, so 0x100 shares a slot with 1
  // although the two differ in every low bit
  sig.Insert(1, 1000);
  EXPECT_EQ(sig.MembershipCheck(0x100), 1000);

  sig.Insert(0x100, 2000);
  EXPECT_EQ(sig.MembershipCheck(1), 2000);
}

TEST_F(SignatureTest, testTheNumberOfHashesIsIgnored) {
  // numOfHash is stored but never read, so a signature asking for several hashes behaves exactly
  // like the single hash one
  dp::Signature one_hash(16, 4, 1);
  dp::Signature many_hashes(16, 4, 5);

  one_hash.Insert(0, 1234);
  many_hashes.Insert(0, 1234);

  EXPECT_EQ(one_hash.MembershipCheck(0), many_hashes.MembershipCheck(0));
  EXPECT_EQ(one_hash.MembershipCheck(4), many_hashes.MembershipCheck(4));
}

TEST_F(SignatureTest, testIntersectAlwaysReportsNoIntersection) {
  dp::Signature sig(16, 4);
  dp::Signature other(16, 4);

  sig.Insert(0, 1234);
  other.Insert(0, 1234);

  // the implementation is a stub: even two signatures holding the same value do not intersect
  EXPECT_FALSE(sig.Intersect(other));
}

TEST_F(SignatureTest, testTheExpectedFalsePositiveRateIsAlwaysZero) {
  dp::Signature sig(16, 4);

  sig.Insert(0, 1000);
  sig.Insert(4, 2000); // a conflict on the slot of elem 0

  // also a stub, so the rate stays at zero no matter how full the signature is
  EXPECT_DOUBLE_EQ(sig.ExpectedFalsePositiveRate(), 0.0);
}

TEST_F(SignatureTest, testSevenByteSlotsAreAsWideAsASlotGets) {
  // this is the width the runtime uses: SIG_ELEM_BIT is 56
  auto signature = dp::Signature{56, 4, 1};

  ASSERT_EQ(signature.Insert(1, 0x12345678ABCDEFLL), 0);
  ASSERT_EQ(signature.MembershipCheck(1), 0x12345678ABCDEFLL);

  // an eighth byte does not fit and is dropped, exactly as the narrower slots drop theirs
  signature.Update(2, static_cast<SigElement>(0xFF12345678ABCDEFULL));
  ASSERT_EQ(signature.MembershipCheck(2), 0x12345678ABCDEFLL);
}
