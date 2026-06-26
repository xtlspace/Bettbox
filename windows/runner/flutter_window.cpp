#include "flutter_window.h"

#include <optional>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <shobjidl.h>  // For ITaskbarList3

#include "flutter/generated_plugin_registrant.h"
#include "resource.h"

#ifdef BETTBOX_DEV
#define BETTBOX_REG_KEY L"Software\\BettboxDev"
#else
#define BETTBOX_REG_KEY L"Software\\Bettbox"
#endif

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  
  // Register app method channel
  SetupAppMethodChannel();
  
  // Load and apply saved icon preference
  bool use_light_icon = LoadIconPreference();
  SetWindowIcon(use_light_icon);
  
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  flutter_controller_->engine()->SetNextFrameCallback([&]() {

  });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::OnDestroy() {
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}

void FlutterWindow::SetupAppMethodChannel() {
  auto channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
      flutter_controller_->engine()->messenger(), "app",
      &flutter::StandardMethodCodec::GetInstance());

  channel->SetMethodCallHandler(
      [this](const auto& call, auto result) {
        if (call.method_name() == "setLauncherIcon") {
          const auto* arguments = std::get_if<flutter::EncodableMap>(call.arguments());
          if (arguments) {
            auto use_light_icon_it = arguments->find(flutter::EncodableValue("useLightIcon"));
            if (use_light_icon_it != arguments->end()) {
              bool use_light_icon = std::get<bool>(use_light_icon_it->second);
              bool success = SetWindowIcon(use_light_icon);
              result->Success(flutter::EncodableValue(success));
              return;
            }
          }
          result->Error("INVALID_ARGUMENT", "Missing useLightIcon argument");
        } else {
          result->NotImplemented();
        }
      });
}

bool FlutterWindow::SetWindowIcon(bool use_light_icon) {
  HWND hwnd = GetHandle();
  if (!hwnd) {
    return false;
  }

  std::wstring icon_name = use_light_icon ? L"icon_light.ico" : L"icon.ico";
  wchar_t exe_path_buf[MAX_PATH] = {0};
  DWORD exe_path_len = GetModuleFileNameW(NULL, exe_path_buf, MAX_PATH);
  std::wstring exe_path = exe_path_len > 0 ? std::wstring(exe_path_buf) : L"";
  std::wstring base_dir = L".";
  size_t last_slash = exe_path.find_last_of(L"\\/");
  if (!exe_path.empty() && last_slash != std::wstring::npos) {
    base_dir = exe_path.substr(0, last_slash);
  }
  std::wstring icon_path =
      base_dir + L"\\data\\flutter_assets\\assets\\images\\" + icon_name;

  // Load icon file
  HICON hIcon = (HICON)LoadImageW(
      NULL,
      icon_path.c_str(),
      IMAGE_ICON,
      0,
      0,
      LR_LOADFROMFILE | LR_DEFAULTSIZE | LR_SHARED
  );

  if (!hIcon) {
    // Fallback to app resource if load fails
    hIcon = LoadIcon(GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_APP_ICON));
    if (!hIcon) {
      return false;
    }
  }

  // Set window icon (title bar)
  SendMessage(hwnd, WM_SETICON, ICON_SMALL, (LPARAM)hIcon);
  SendMessage(hwnd, WM_SETICON, ICON_BIG, (LPARAM)hIcon);
  SetClassLongPtr(hwnd, GCLP_HICON, (LONG_PTR)hIcon);
  SetClassLongPtr(hwnd, GCLP_HICONSM, (LONG_PTR)hIcon);

  // Update taskbar icon
  // Method: Refresh via ITaskbarList3 interface
  ITaskbarList3* pTaskbarList = nullptr;
  HRESULT hr = CoCreateInstance(
      CLSID_TaskbarList,
      NULL,
      CLSCTX_INPROC_SERVER,
      IID_ITaskbarList3,
      (void**)&pTaskbarList
  );

  if (SUCCEEDED(hr) && pTaskbarList) {
    pTaskbarList->HrInit();
    
    // Refresh taskbar button to update icon
    pTaskbarList->AddTab(hwnd);
    pTaskbarList->DeleteTab(hwnd);
    pTaskbarList->AddTab(hwnd);
    
    pTaskbarList->Release();
  }

  RedrawWindow(hwnd, NULL, NULL,
               RDW_INVALIDATE | RDW_FRAME | RDW_UPDATENOW | RDW_ALLCHILDREN);

  // Save preference to registry
  SaveIconPreference(use_light_icon);

  return true;
}

void FlutterWindow::SaveIconPreference(bool use_light_icon) {
  HKEY hKey;
  LONG result = RegCreateKeyExW(
      HKEY_CURRENT_USER,
      BETTBOX_REG_KEY,
      0,
      NULL,
      REG_OPTION_NON_VOLATILE,
      KEY_WRITE,
      NULL,
      &hKey,
      NULL
  );

  if (result == ERROR_SUCCESS) {
    DWORD value = use_light_icon ? 1 : 0;
    RegSetValueExW(hKey, L"UseLightIcon", 0, REG_DWORD, (BYTE*)&value, sizeof(DWORD));
    RegCloseKey(hKey);
  }
}

bool FlutterWindow::LoadIconPreference() {
  HKEY hKey;
  LONG result = RegOpenKeyExW(
      HKEY_CURRENT_USER,
      BETTBOX_REG_KEY,
      0,
      KEY_READ,
      &hKey
  );

  if (result == ERROR_SUCCESS) {
    DWORD value = 0;
    DWORD size = sizeof(DWORD);
    result = RegQueryValueExW(hKey, L"UseLightIcon", NULL, NULL, (BYTE*)&value, &size);
    RegCloseKey(hKey);
    
    if (result == ERROR_SUCCESS) {
      return value != 0;
    }
  }

  return false;
}
