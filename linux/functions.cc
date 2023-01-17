#include "functions.h"

#include <gio/gio.h>

FlMethodResponse* moveToTrash(const char* path) {
  g_autoptr(GFile) file = g_file_new_for_path(path);
  g_autoptr(GError) error = nullptr;
  auto result = g_file_trash(file, nullptr, &error);
  if (result) {
    g_autoptr(FlValue) res = fl_value_new_bool(result);
    return FL_METHOD_RESPONSE(fl_method_success_response_new(res));
  } else {
    return FL_METHOD_RESPONSE(fl_method_error_response_new("MoveToTrash", error->message, nullptr));
  }
}
