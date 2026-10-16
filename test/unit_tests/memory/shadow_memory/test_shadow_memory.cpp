#include <gtest/gtest.h>

#include "memory/AbstractShadow.hpp"
#include "memory/ShadowMemory.hpp"

#include <cstdint>
#include <memory>
#include <stdexcept>
#include <string>

// ShadowMemory is the AbstractShadow implementation backed by two Signatures, one for reads and one
// for writes. It is what initSingleThreadedExecution() builds when USE_PERFECT is off.
//
// Every test below uses slotSize=16 (two bytes per slot) and 8 slots. Signature hashes an address
// as ((addr >> 8) + addr) % numSlot, which collapses to addr % 8 for the small addresses used here.
class ShadowMemoryTest : public ::testing::Test {};

TEST_F(ShadowMemoryTest, testAnUntouchedShadowReportsZero) {
  auto shadow = dp::ShadowMemory{16, 8, 1};

  for (auto address = 0; address < 8; ++address) {
    ASSERT_EQ(shadow.TestInRead(address), 0);
    ASSERT_EQ(shadow.TestInWrite(address), 0);
  }
}

TEST_F(ShadowMemoryTest, testInsertReturnsThePreviousValueOfTheSlot) {
  auto shadow = dp::ShadowMemory{16, 8, 1};

  ASSERT_EQ(shadow.InsertToRead(1, 1234), 0);
  ASSERT_EQ(shadow.TestInRead(1), 1234);

  ASSERT_EQ(shadow.InsertToRead(1, 4321), 1234);
  ASSERT_EQ(shadow.TestInRead(1), 4321);

  ASSERT_EQ(shadow.InsertToWrite(1, 555), 0);
  ASSERT_EQ(shadow.TestInWrite(1), 555);

  ASSERT_EQ(shadow.InsertToWrite(1, 666), 555);
  ASSERT_EQ(shadow.TestInWrite(1), 666);
}

TEST_F(ShadowMemoryTest, testReadsAndWritesAreKeptApart) {
  auto shadow = dp::ShadowMemory{16, 8, 1};

  shadow.InsertToRead(3, 111);

  ASSERT_EQ(shadow.TestInRead(3), 111);
  ASSERT_EQ(shadow.TestInWrite(3), 0);

  shadow.InsertToWrite(3, 222);

  ASSERT_EQ(shadow.TestInRead(3), 111);
  ASSERT_EQ(shadow.TestInWrite(3), 222);

  shadow.RemoveFromWrite(3);

  ASSERT_EQ(shadow.TestInRead(3), 111);
  ASSERT_EQ(shadow.TestInWrite(3), 0);
}

TEST_F(ShadowMemoryTest, testUpdateOverwritesTheSlot) {
  auto shadow = dp::ShadowMemory{16, 8, 1};

  shadow.InsertToRead(2, 100);
  shadow.UpdateInRead(2, 200);
  ASSERT_EQ(shadow.TestInRead(2), 200);

  shadow.InsertToWrite(2, 300);
  shadow.UpdateInWrite(2, 400);
  ASSERT_EQ(shadow.TestInWrite(2), 400);

  // update also works on a slot that was never inserted into
  shadow.UpdateInRead(5, 500);
  ASSERT_EQ(shadow.TestInRead(5), 500);
}

TEST_F(ShadowMemoryTest, testRemoveClearsTheSlot) {
  auto shadow = dp::ShadowMemory{16, 8, 1};

  shadow.InsertToRead(4, 111);
  shadow.InsertToWrite(4, 222);

  shadow.RemoveFromRead(4);
  ASSERT_EQ(shadow.TestInRead(4), 0);
  ASSERT_EQ(shadow.TestInWrite(4), 222);

  shadow.RemoveFromWrite(4);
  ASSERT_EQ(shadow.TestInWrite(4), 0);

  // removing an untouched slot is a no-op
  shadow.RemoveFromRead(7);
  ASSERT_EQ(shadow.TestInRead(7), 0);
}

TEST_F(ShadowMemoryTest, testAddressesSharingASlotAliasOntoEachOther) {
  auto shadow = dp::ShadowMemory{16, 8, 1};

  // 8 addresses per signature, so 1 and 9 land in the same slot. This is the whole point of a
  // signature: it trades exactness for a fixed amount of memory, and a shadow lookup can report a
  // value that was written for a different address.
  shadow.InsertToWrite(1, 111);
  ASSERT_EQ(shadow.TestInWrite(9), 111);

  shadow.InsertToWrite(9, 999);
  ASSERT_EQ(shadow.TestInWrite(1), 999);

  shadow.RemoveFromWrite(9);
  ASSERT_EQ(shadow.TestInWrite(1), 0);
}

TEST_F(ShadowMemoryTest, testValuesAreTruncatedToTheSlotSize) {
  auto shadow = dp::ShadowMemory{16, 8, 1};

  // two bytes per slot, so everything above the lower 16 bits is dropped
  shadow.InsertToWrite(0, 0x12345);
  ASSERT_EQ(shadow.TestInWrite(0), 0x2345);

  auto wide_shadow = dp::ShadowMemory{32, 8, 1};

  wide_shadow.InsertToWrite(0, 0x12345);
  ASSERT_EQ(wide_shadow.TestInWrite(0), 0x12345);
}

TEST_F(ShadowMemoryTest, testGetAddrsInRangeIsEmptyByDesign) {
  auto shadow = dp::ShadowMemory{16, 8, 1};

  shadow.InsertToRead(1, 111);
  shadow.InsertToWrite(2, 222);

  // a signature does not keep its addresses, so it cannot answer this question at all
  ASSERT_TRUE(shadow.GetAddrsInRange(0, 1000).empty());
}

TEST_F(ShadowMemoryTest, testTheKeyValueAccessorsAreNotImplemented) {
  auto shadow = dp::ShadowMemory{16, 8, 1};

  shadow.InsertToRead(1, 111);
  shadow.InsertToWrite(2, 222);

  try {
    shadow.GetReadKvPairs();
    FAIL() << "getReadKVPairs() is expected to throw";
  } catch (const std::logic_error &error) {
    EXPECT_STREQ(error.what(), "NOT IMPLEMENTED!");
  }

  try {
    shadow.GetWriteKvPairs();
    FAIL() << "getWriteKVPairs() is expected to throw";
  } catch (const std::logic_error &error) {
    EXPECT_STREQ(error.what(), "NOT IMPLEMENTED!");
  }
}

TEST_F(ShadowMemoryTest, testUseThroughTheAbstractInterface) {
  // this is how the runtime holds it: a base class pointer that has to delete the derived signatures
  std::unique_ptr<dp::AbstractShadow> shadow = std::make_unique<dp::ShadowMemory>(16, 8, 1);

  ASSERT_EQ(shadow->InsertToWrite(6, 42), 0);
  ASSERT_EQ(shadow->TestInWrite(6), 42);

  ASSERT_EQ(shadow->InsertToRead(6, 43), 0);
  ASSERT_EQ(shadow->TestInRead(6), 43);

  shadow->Print();
}
