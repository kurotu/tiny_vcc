#ifndef FUNCTIONS_H_
#define FUNCTIONS_H_

#include <windows.h>
#include <string>

namespace tiny_vcc {
  HRESULT MoveToTrash(const std::string& path);
  std::string GetErrorMessage(HRESULT hr);
}

#endif // FUNCTIONS_H_
