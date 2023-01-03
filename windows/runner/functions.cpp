#include "functions.h"

#include <ShlObj.h>
#include <locale>
#include <codecvt>
#include <string>
#include <atlcomcli.h>

namespace tiny_vcc {
  std::wstring utf8ToWString(const std::string& str);
}

HRESULT tiny_vcc::MoveToTrash(const std::string &path) {
  HRESULT hr;
  CComPtr<IFileOperation> pfo;

  const auto wPath = utf8ToWString(path);

  hr = CoCreateInstance(CLSID_FileOperation, NULL, CLSCTX_ALL, IID_PPV_ARGS(&pfo));
  if (FAILED(hr))
  {
    return hr;
  }

  hr = pfo->SetOperationFlags(FOF_ALLOWUNDO | FOF_NOCONFIRMATION | FOF_SILENT);
  if (FAILED(hr))
  {
    return hr;
  }

  CComPtr<IShellItem> psiItem;
  hr = SHCreateItemFromParsingName(wPath.c_str(), NULL, IID_PPV_ARGS(&psiItem));
  if (FAILED(hr))
  {
    return hr;
  }

  hr = pfo->DeleteItem(psiItem, NULL);
  if (FAILED(hr))
  {
    return hr;
  }

  hr = pfo->PerformOperations();
  if (FAILED(hr))
  {
    return hr;
  }

  return hr;
}

std::string tiny_vcc::GetErrorMessage(HRESULT hr)
{
  return std::system_category().message(hr);
}

std::wstring tiny_vcc::utf8ToWString(const std::string& str) {
  auto length = MultiByteToWideChar(CP_UTF8, 0, str.c_str(), -1, NULL, 0);
  std::wstring wstr = L"";
  wstr.reserve(length + 1);
  MultiByteToWideChar(CP_UTF8, 0, str.c_str(), -1, wstr.data(), length + 1);
  return wstr;
}
