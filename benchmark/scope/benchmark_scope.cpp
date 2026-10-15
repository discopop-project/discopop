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

#include <benchmark/benchmark.h>

#include <cstdint>
#include <vector>

#include "memory/Scope.hpp"

// General functions

static std::int64_t convert_to_address(const std::int64_t iteration) {
  return ((iteration * 17) + ((iteration + 4) % 5)) % 1024;
}

static bool read_address(const std::int64_t address) { return (address * 17) & 11; }

static bool write_address(const std::int64_t address) { return address & 2; }

static bool first_written_address(const std::int64_t address, const std::int64_t iteration) {
  return (((iteration * 19) + (address & 23)) % 24) > 7;
}

// Benchmarks for old version (i.e., establishing a base line)

static void benchmark_scope_read(benchmark::State &state) {
  const auto number_addresses = state.range(0);

  auto addresses = std::vector<std::int64_t>{};
  addresses.resize(number_addresses);

  for (auto i = std::int64_t(0); i < number_addresses; i++) {
    addresses[i] = convert_to_address(i);
  }

  // This exists so that the destructor call does not interfere with the timing
  auto dumping_ground = std::vector<dp::Scope>{};

  for (auto _ : state) {
    state.PauseTiming();
    auto scope = dp::Scope{1};
    state.ResumeTiming();

    for (auto addr : addresses) {
      scope.RegisterStackRead(addr, 0, "");
    }

    state.PauseTiming();
    dumping_ground.emplace_back(std::move(scope));
    state.ResumeTiming();
  }
}

static void benchmark_scope_write(benchmark::State &state) {
  const auto number_addresses = state.range(0);

  auto addresses = std::vector<std::int64_t>{};
  addresses.resize(number_addresses);

  for (auto i = std::int64_t(0); i < number_addresses; i++) {
    addresses[i] = convert_to_address(i);
  }

  // This exists so that the destructor call does not interfere with the timing
  auto dumping_ground = std::vector<dp::Scope>{};

  for (auto _ : state) {
    state.PauseTiming();
    auto scope = dp::Scope{1};
    state.ResumeTiming();

    for (auto addr : addresses) {
      scope.RegisterStackWrite(addr, 0, "");
    }

    state.PauseTiming();
    dumping_ground.emplace_back(std::move(scope));
    state.ResumeTiming();
  }
}

static void benchmark_scope(benchmark::State &state) {
  const auto number_addresses = state.range(0);

  auto addresses = std::vector<std::int64_t>{};
  addresses.resize(number_addresses);

  for (auto i = std::int64_t(0); i < number_addresses; i++) {
    addresses[i] = convert_to_address(i);
  }

  // This exists so that the destructor call does not interfere with the timing
  auto dumping_ground = std::vector<dp::Scope>{};

  for (auto _ : state) {
    state.PauseTiming();
    auto scope = dp::Scope{1};
    state.ResumeTiming();

    for (auto addr : addresses) {
      if (read_address(addr)) {
        scope.RegisterStackRead(addr, 1, "");
      }

      if (write_address(addr)) {
        scope.RegisterStackWrite(addr, 0, "");
      }
    }

    state.PauseTiming();
    dumping_ground.emplace_back(std::move(scope));
    state.ResumeTiming();
  }
}

static void benchmark_scope_manager_few_accesses(benchmark::State &state) {
  const auto number_scopes = state.range(0);

  auto dumping_ground = std::vector<dp::ScopeManager>{};

  for (auto _ : state) {
    state.PauseTiming();
    auto manager = dp::ScopeManager{};
    state.ResumeTiming();

    auto current_number_scopes = 0;

    for (auto i = 0; i < number_scopes; i++) {
      manager.EnterScope("Enter scope", i);

      manager.RegisterStackRead(24, 0, "");
      manager.RegisterStackWrite(i, 0, "");
      manager.RegisterStackRead(32, 0, "");
      manager.RegisterStackRead(64, 1, "");
      manager.RegisterStackWrite(i + 2, 0, "");

      current_number_scopes++;
      if (current_number_scopes > 10) {
        manager.LeaveScope("Leave scope", i);
        manager.LeaveScope("Leave scope", i);
        manager.LeaveScope("Leave scope", i);
        manager.LeaveScope("Leave scope", i);
        manager.LeaveScope("Leave scope", i);

        current_number_scopes -= 5;
      }
    }

    for (auto i = 0; i < current_number_scopes; i++) {
      manager.LeaveScope("Leave scope", i);
    }

    state.PauseTiming();
    dumping_ground.emplace_back(std::move(manager));
    state.ResumeTiming();
  }
}

static void benchmark_scope_manager_many_accesses(benchmark::State &state) {
  const auto number_scopes = state.range(0);

  auto dumping_ground = std::vector<dp::ScopeManager>{};

  for (auto _ : state) {
    state.PauseTiming();
    auto manager = dp::ScopeManager{};
    state.ResumeTiming();

    auto current_number_scopes = 0;

    for (auto i = 0; i < number_scopes; i++) {
      manager.EnterScope("Enter scope", i);

      for (auto j = 0; j < 1024; j++) {
        const auto addr = convert_to_address(j + i);
        if (read_address(addr)) {
          manager.RegisterStackRead(addr, 0, "");
        }
        if (write_address(addr)) {
          manager.RegisterStackWrite(addr, 0, "");
        }
      }

      current_number_scopes++;
      if (current_number_scopes > 10) {
        manager.LeaveScope("Leave scope", i);
        manager.LeaveScope("Leave scope", i);
        manager.LeaveScope("Leave scope", i);
        manager.LeaveScope("Leave scope", i);
        manager.LeaveScope("Leave scope", i);

        current_number_scopes -= 5;
      }
    }

    for (auto i = 0; i < current_number_scopes; i++) {
      manager.LeaveScope("Leave scope", i);
    }

    state.PauseTiming();
    dumping_ground.emplace_back(std::move(manager));
    state.ResumeTiming();
  }
}

static void benchmark_scope_manager_first_written(benchmark::State &state) {
  const auto number_addresses = state.range(0);

  auto addresses = std::vector<std::int64_t>{};
  addresses.resize(number_addresses);

  for (auto i = std::int64_t(0); i < number_addresses; i++) {
    addresses[i] = convert_to_address(i);
  }

  auto dumping_ground = std::vector<dp::ScopeManager>{};

  for (auto _ : state) {
    state.PauseTiming();
    auto manager = dp::ScopeManager{};
    state.ResumeTiming();

    manager.EnterScope("First", 1);

    for (const auto addr : addresses) {
      if (read_address(addr)) {
        manager.RegisterStackRead(addr, 0, "");
      }

      if (write_address(addr)) {
        manager.RegisterStackWrite(addr, 0, "");
      }

      if (first_written_address(addr, 1)) {
        const auto b = manager.IsOwnedByScope(addr, true);
      }
    }

    manager.EnterScope("Second", 2);

    for (const auto addr : addresses) {
      if (read_address(addr)) {
        manager.RegisterStackRead(addr, 0, "");
      }

      if (write_address(addr)) {
        manager.RegisterStackWrite(addr, 0, "");
      }

      if (first_written_address(addr, 2)) {
        const auto b = manager.IsOwnedByScope(addr, true);
      }
    }

    manager.EnterScope("Third", 3);

    for (const auto addr : addresses) {
      if (read_address(addr)) {
        manager.RegisterStackRead(addr, 0, "");
      }

      if (write_address(addr)) {
        manager.RegisterStackWrite(addr, 0, "");
      }

      if (first_written_address(addr, 3)) {
        const auto b = manager.IsOwnedByScope(addr, true);
      }
    }

    manager.LeaveScope("Third", 3);
    manager.LeaveScope("Second", 2);

    manager.EnterScope("Forth", 4);

    for (const auto addr : addresses) {
      if (read_address(addr)) {
        manager.RegisterStackRead(addr, 0, "");
      }

      if (write_address(addr)) {
        manager.RegisterStackWrite(addr, 0, "");
      }

      if (first_written_address(addr, 4)) {
        const auto b = manager.IsOwnedByScope(addr, true);
      }
    }

    state.PauseTiming();
    dumping_ground.emplace_back(std::move(manager));
    state.ResumeTiming();
  }
}

static void benchmark_scope_manager_positive_change(benchmark::State &state) {
  const auto number_addresses = state.range(0);

  auto addresses = std::vector<std::int64_t>{};
  addresses.resize(number_addresses);

  for (auto i = std::int64_t(0); i < number_addresses; i++) {
    addresses[i] = convert_to_address(i);
  }

  auto dumping_ground = std::vector<dp::ScopeManager>{};

  for (auto _ : state) {
    state.PauseTiming();
    auto manager = dp::ScopeManager{};
    state.ResumeTiming();

    manager.EnterScope("First", 1);

    for (const auto addr : addresses) {
      if (read_address(addr)) {
        manager.RegisterStackRead(addr, 0, "");
      }

      if (write_address(addr)) {
        manager.RegisterStackWrite(addr, 0, "");
      }

      const auto b = manager.PositiveScopeChangeOccuredSinceLastAccess(addr);
    }

    manager.EnterScope("Second", 2);

    for (const auto addr : addresses) {
      if (read_address(addr)) {
        manager.RegisterStackRead(addr, 0, "");
      }

      if (write_address(addr)) {
        manager.RegisterStackWrite(addr, 0, "");
      }

      const auto b = manager.PositiveScopeChangeOccuredSinceLastAccess(addr);
    }

    manager.EnterScope("Third", 3);

    for (const auto addr : addresses) {
      if (read_address(addr)) {
        manager.RegisterStackRead(addr, 0, "");
      }

      if (write_address(addr)) {
        manager.RegisterStackWrite(addr, 0, "");
      }

      const auto b = manager.PositiveScopeChangeOccuredSinceLastAccess(addr);
    }

    manager.LeaveScope("Third", 3);
    manager.LeaveScope("Second", 2);

    manager.EnterScope("Forth", 4);

    for (const auto addr : addresses) {
      if (read_address(addr)) {
        manager.RegisterStackRead(addr, 0, "");
      }

      if (write_address(addr)) {
        manager.RegisterStackWrite(addr, 0, "");
      }

      const auto b = manager.PositiveScopeChangeOccuredSinceLastAccess(addr);
    }

    state.PauseTiming();
    dumping_ground.emplace_back(std::move(manager));
    state.ResumeTiming();
  }
}

// Benchmarks for new version (i.e., hopefully beating the base line)

static void benchmark_scope_2_read(benchmark::State &state) {
  const auto number_addresses = state.range(0);

  auto addresses = std::vector<std::int64_t>{};
  addresses.resize(number_addresses);

  for (auto i = std::int64_t(0); i < number_addresses; i++) {
    addresses[i] = convert_to_address(i);
  }

  // This exists so that the destructor call does not interfere with the timing
  auto dumping_ground = std::vector<dp::Scope2>{};

  for (auto _ : state) {
    state.PauseTiming();
    auto scope = dp::Scope2{1};
    state.ResumeTiming();

    for (auto addr : addresses) {
      scope.RegisterStackRead(addr, 0, "");
    }

    state.PauseTiming();
    dumping_ground.emplace_back(std::move(scope));
    state.ResumeTiming();
  }
}

static void benchmark_scope_2_write(benchmark::State &state) {
  const auto number_addresses = state.range(0);

  auto addresses = std::vector<std::int64_t>{};
  addresses.resize(number_addresses);

  for (auto i = std::int64_t(0); i < number_addresses; i++) {
    addresses[i] = convert_to_address(i);
  }

  // This exists so that the destructor call does not interfere with the timing
  auto dumping_ground = std::vector<dp::Scope2>{};

  for (auto _ : state) {
    state.PauseTiming();
    auto scope = dp::Scope2{1};
    state.ResumeTiming();

    for (auto addr : addresses) {
      scope.RegisterStackWrite(addr, 0, "");
    }

    state.PauseTiming();
    dumping_ground.emplace_back(std::move(scope));
    state.ResumeTiming();
  }
}

static void benchmark_scope_2(benchmark::State &state) {
  const auto number_addresses = state.range(0);

  auto addresses = std::vector<std::int64_t>{};
  addresses.resize(number_addresses);

  for (auto i = std::int64_t(0); i < number_addresses; i++) {
    addresses[i] = convert_to_address(i);
  }

  // This exists so that the destructor call does not interfere with the timing
  auto dumping_ground = std::vector<dp::Scope2>{};

  for (auto _ : state) {
    state.PauseTiming();
    auto scope = dp::Scope2{1};
    state.ResumeTiming();

    for (auto addr : addresses) {
      if (read_address(addr)) {
        scope.RegisterStackRead(addr, 1, "");
      }

      if (write_address(addr)) {
        scope.RegisterStackWrite(addr, 0, "");
      }
    }

    state.PauseTiming();
    dumping_ground.emplace_back(std::move(scope));
    state.ResumeTiming();
  }
}

static void benchmark_scope_manager_2_few_accesses(benchmark::State &state) {
  const auto number_scopes = state.range(0);

  auto dumping_ground = std::vector<dp::ScopeManager2>{};

  for (auto _ : state) {
    state.PauseTiming();
    auto manager = dp::ScopeManager2{};
    state.ResumeTiming();

    auto current_number_scopes = 0;

    for (auto i = 0; i < number_scopes; i++) {
      manager.EnterScope("Enter scope", i);

      manager.RegisterStackRead(24, 0, "");
      manager.RegisterStackWrite(i, 0, "");
      manager.RegisterStackRead(32, 0, "");
      manager.RegisterStackRead(64, 1, "");
      manager.RegisterStackWrite(i + 2, 0, "");

      current_number_scopes++;
      if (current_number_scopes > 10) {
        manager.LeaveScope("Leave scope", i);
        manager.LeaveScope("Leave scope", i);
        manager.LeaveScope("Leave scope", i);
        manager.LeaveScope("Leave scope", i);
        manager.LeaveScope("Leave scope", i);

        current_number_scopes -= 5;
      }
    }

    for (auto i = 0; i < current_number_scopes; i++) {
      manager.LeaveScope("Leave scope", i);
    }

    state.PauseTiming();
    dumping_ground.emplace_back(std::move(manager));
    state.ResumeTiming();
  }
}

static void benchmark_scope_manager_2_many_accesses(benchmark::State &state) {
  const auto number_scopes = state.range(0);

  auto dumping_ground = std::vector<dp::ScopeManager2>{};

  for (auto _ : state) {
    state.PauseTiming();
    auto manager = dp::ScopeManager2{};
    state.ResumeTiming();

    auto current_number_scopes = 0;

    for (auto i = 0; i < number_scopes; i++) {
      manager.EnterScope("Enter scope", i);

      for (auto j = 0; j < 1024; j++) {
        const auto addr = convert_to_address(j + i);
        if (read_address(addr)) {
          manager.RegisterStackRead(addr, 0, "");
        }
        if (write_address(addr)) {
          manager.RegisterStackWrite(addr, 0, "");
        }
      }

      current_number_scopes++;
      if (current_number_scopes > 10) {
        manager.LeaveScope("Leave scope", i);
        manager.LeaveScope("Leave scope", i);
        manager.LeaveScope("Leave scope", i);
        manager.LeaveScope("Leave scope", i);
        manager.LeaveScope("Leave scope", i);

        current_number_scopes -= 5;
      }
    }

    for (auto i = 0; i < current_number_scopes; i++) {
      manager.LeaveScope("Leave scope", i);
    }

    state.PauseTiming();
    dumping_ground.emplace_back(std::move(manager));
    state.ResumeTiming();
  }
}

static void benchmark_scope_manager_2_first_written(benchmark::State &state) {
  const auto number_addresses = state.range(0);

  auto addresses = std::vector<std::int64_t>{};
  addresses.resize(number_addresses);

  for (auto i = std::int64_t(0); i < number_addresses; i++) {
    addresses[i] = convert_to_address(i);
  }

  auto dumping_ground = std::vector<dp::ScopeManager2>{};

  for (auto _ : state) {
    state.PauseTiming();
    auto manager = dp::ScopeManager2{};
    state.ResumeTiming();

    manager.EnterScope("First", 1);

    for (const auto addr : addresses) {
      if (read_address(addr)) {
        manager.RegisterStackRead(addr, 0, "");
      }

      if (write_address(addr)) {
        manager.RegisterStackWrite(addr, 0, "");
      }

      if (first_written_address(addr, 1)) {
        const auto b = manager.IsOwnedByScope(addr, true);
      }
    }

    manager.EnterScope("Second", 2);

    for (const auto addr : addresses) {
      if (read_address(addr)) {
        manager.RegisterStackRead(addr, 0, "");
      }

      if (write_address(addr)) {
        manager.RegisterStackWrite(addr, 0, "");
      }

      if (first_written_address(addr, 2)) {
        const auto b = manager.IsOwnedByScope(addr, true);
      }
    }

    manager.EnterScope("Third", 3);

    for (const auto addr : addresses) {
      if (read_address(addr)) {
        manager.RegisterStackRead(addr, 0, "");
      }

      if (write_address(addr)) {
        manager.RegisterStackWrite(addr, 0, "");
      }

      if (first_written_address(addr, 3)) {
        const auto b = manager.IsOwnedByScope(addr, true);
      }
    }

    manager.LeaveScope("Third", 3);
    manager.LeaveScope("Second", 2);

    manager.EnterScope("Forth", 4);

    for (const auto addr : addresses) {
      if (read_address(addr)) {
        manager.RegisterStackRead(addr, 0, "");
      }

      if (write_address(addr)) {
        manager.RegisterStackWrite(addr, 0, "");
      }

      if (first_written_address(addr, 4)) {
        const auto b = manager.IsOwnedByScope(addr, true);
      }
    }

    state.PauseTiming();
    dumping_ground.emplace_back(std::move(manager));
    state.ResumeTiming();
  }
}

static void benchmark_scope_manager_2_positive_change(benchmark::State &state) {
  const auto number_addresses = state.range(0);

  auto addresses = std::vector<std::int64_t>{};
  addresses.resize(number_addresses);

  for (auto i = std::int64_t(0); i < number_addresses; i++) {
    addresses[i] = convert_to_address(i);
  }

  auto dumping_ground = std::vector<dp::ScopeManager2>{};

  for (auto _ : state) {
    state.PauseTiming();
    auto manager = dp::ScopeManager2{};
    state.ResumeTiming();

    manager.EnterScope("First", 1);

    for (const auto addr : addresses) {
      if (read_address(addr)) {
        manager.RegisterStackRead(addr, 0, "");
      }

      if (write_address(addr)) {
        manager.RegisterStackWrite(addr, 0, "");
      }

      const auto b = manager.PositiveScopeChangeOccuredSinceLastAccess(addr);
    }

    manager.EnterScope("Second", 2);

    for (const auto addr : addresses) {
      if (read_address(addr)) {
        manager.RegisterStackRead(addr, 0, "");
      }

      if (write_address(addr)) {
        manager.RegisterStackWrite(addr, 0, "");
      }

      const auto b = manager.PositiveScopeChangeOccuredSinceLastAccess(addr);
    }

    manager.EnterScope("Third", 3);

    for (const auto addr : addresses) {
      if (read_address(addr)) {
        manager.RegisterStackRead(addr, 0, "");
      }

      if (write_address(addr)) {
        manager.RegisterStackWrite(addr, 0, "");
      }

      const auto b = manager.PositiveScopeChangeOccuredSinceLastAccess(addr);
    }

    manager.LeaveScope("Third", 3);
    manager.LeaveScope("Second", 2);

    manager.EnterScope("Forth", 4);

    for (const auto addr : addresses) {
      if (read_address(addr)) {
        manager.RegisterStackRead(addr, 0, "");
      }

      if (write_address(addr)) {
        manager.RegisterStackWrite(addr, 0, "");
      }

      const auto b = manager.PositiveScopeChangeOccuredSinceLastAccess(addr);
    }

    state.PauseTiming();
    dumping_ground.emplace_back(std::move(manager));
    state.ResumeTiming();
  }
}

// The sorting determines the output order --> put pairs together so a
// comparison is easier

BENCHMARK(benchmark_scope_read)->Unit(benchmark::kMillisecond)->Arg(32)->Iterations(100);
BENCHMARK(benchmark_scope_2_read)->Unit(benchmark::kMillisecond)->Arg(32)->Iterations(100);
BENCHMARK(benchmark_scope_read)->Unit(benchmark::kMillisecond)->Arg(1024)->Iterations(100);
BENCHMARK(benchmark_scope_2_read)->Unit(benchmark::kMillisecond)->Arg(1024)->Iterations(100);

BENCHMARK(benchmark_scope_write)->Unit(benchmark::kMillisecond)->Arg(32)->Iterations(100);
BENCHMARK(benchmark_scope_2_write)->Unit(benchmark::kMillisecond)->Arg(32)->Iterations(100);
BENCHMARK(benchmark_scope_write)->Unit(benchmark::kMillisecond)->Arg(1024)->Iterations(100);
BENCHMARK(benchmark_scope_2_write)->Unit(benchmark::kMillisecond)->Arg(1024)->Iterations(100);

BENCHMARK(benchmark_scope)->Unit(benchmark::kMillisecond)->Arg(32)->Iterations(100);
BENCHMARK(benchmark_scope_2)->Unit(benchmark::kMillisecond)->Arg(32)->Iterations(100);
BENCHMARK(benchmark_scope)->Unit(benchmark::kMillisecond)->Arg(1024)->Iterations(100);
BENCHMARK(benchmark_scope_2)->Unit(benchmark::kMillisecond)->Arg(1024)->Iterations(100);

BENCHMARK(benchmark_scope_manager_few_accesses)->Unit(benchmark::kMillisecond)->Arg(32)->Iterations(100);
BENCHMARK(benchmark_scope_manager_2_few_accesses)->Unit(benchmark::kMillisecond)->Arg(32)->Iterations(100);
BENCHMARK(benchmark_scope_manager_few_accesses)->Unit(benchmark::kMillisecond)->Arg(1024)->Iterations(100);
BENCHMARK(benchmark_scope_manager_2_few_accesses)->Unit(benchmark::kMillisecond)->Arg(1024)->Iterations(100);

BENCHMARK(benchmark_scope_manager_many_accesses)->Unit(benchmark::kMillisecond)->Arg(8)->Iterations(100);
BENCHMARK(benchmark_scope_manager_2_many_accesses)->Unit(benchmark::kMillisecond)->Arg(8)->Iterations(100);
BENCHMARK(benchmark_scope_manager_many_accesses)->Unit(benchmark::kMillisecond)->Arg(64)->Iterations(100);
BENCHMARK(benchmark_scope_manager_2_many_accesses)->Unit(benchmark::kMillisecond)->Arg(64)->Iterations(100);

BENCHMARK(benchmark_scope_manager_first_written)->Unit(benchmark::kMillisecond)->Arg(32)->Iterations(100);
BENCHMARK(benchmark_scope_manager_2_first_written)->Unit(benchmark::kMillisecond)->Arg(32)->Iterations(100);
BENCHMARK(benchmark_scope_manager_first_written)->Unit(benchmark::kMillisecond)->Arg(1024)->Iterations(100);
BENCHMARK(benchmark_scope_manager_2_first_written)->Unit(benchmark::kMillisecond)->Arg(1024)->Iterations(100);

BENCHMARK(benchmark_scope_manager_positive_change)->Unit(benchmark::kMillisecond)->Arg(32)->Iterations(100);
BENCHMARK(benchmark_scope_manager_2_positive_change)->Unit(benchmark::kMillisecond)->Arg(32)->Iterations(100);
BENCHMARK(benchmark_scope_manager_positive_change)->Unit(benchmark::kMillisecond)->Arg(1024)->Iterations(100);
BENCHMARK(benchmark_scope_manager_2_positive_change)->Unit(benchmark::kMillisecond)->Arg(1024)->Iterations(100);
