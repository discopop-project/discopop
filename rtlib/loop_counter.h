#include <string>
#include <vector>

struct var_info_t {
  int file_id_;
  int instr_id_;
  std::string var_name_;
  int loop_line_nr_;
  int instr_line_;
  char operation_;
};

struct loop_info_t {
  int line_nr_;
  int loop_id_;
  int file_id_;
};

struct VarCounter {
  VarCounter() : counters_{0, 0}, mem_addr_(0), valid_(true) {}
  unsigned counters_[2];
  long long mem_addr_;
  bool valid_;
};

class LoopCounter {
public:
  void incr_loop_counter(int loop_id);
  void incr_counter(int var_id, int instr_type);
  void update_ptr(int var_id, int instr_type, long long addr);

  std::vector<VarCounter> var_counters_;
  std::vector<unsigned> loop_counters_;
};
