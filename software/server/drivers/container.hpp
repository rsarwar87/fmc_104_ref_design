#include <deque>
#include <queue>

template <typename T, int MaxLen, typename Container = std::deque<T>>
class FixedQueue : public std::queue<T, Container> {
 public:
  void push(const T& value) {
    if (this->size() == MaxLen) {
      this->c.pop_front();
    }
    std::queue<T, Container>::push(value);
  }
};


#include <array>

template <typename T, size_t N = 2>
class CyclicArray {
 public:
  typedef typename std::array<T, N>::value_type value_type;
  typedef typename std::array<T, N>::reference reference;
  typedef typename std::array<T, N>::const_reference const_reference;
  typedef typename std::array<T, N>::size_type size_type;

  void push_back(const T& v) {
    if (size_ + 1 == N) pop_front();
    else ++size_;

    array_[(front_ + size_) % N] = v;
  }

  reference pop_front() {
    if (size_ < 1) throw "Empty";
    reference ret = array_[front_];
    ++front_;
    --size_;
    if (front_ >= N) front_ = 0;
    return ret;
  }

  reference peek() { return array_[front_]; }

  size_type size() const { return size_; }

  void fill(T val)
  {
      front_ = 0;
      size_ = 0;
      for (size_t i = 0; i < N; i++) array_[i] = val;
  }
  std::array<T, N> array_;
 private:
  std::atomic<size_type> front_;
  std::atomic<size_type> size_;
};
/*
int main() {
    std::queue<int, CyclicArray<int, 2>> queue;
    queue.push(1)
    int f = queue.front();
    queue.pop();
    return 0;
}
*/
