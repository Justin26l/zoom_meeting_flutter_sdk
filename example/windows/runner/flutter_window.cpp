#include <flutter/event_channel.h>
#include <flutter/event_sink.h>
#include <flutter/event_stream_handler_functions.h>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>

#include "flutter_window.h"
#include "h/zoom_sdk.h"

#include <optional>

#include "flutter/generated_plugin_registrant.h"

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
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    this->Show();
  });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();


  // here : register method channels 
  RegisterPlugins(flutter_controller_->engine());

  flutter::MethodChannel<> channel(
    flutter_controller_->engine()->messenger(), 
    "zoom_meeting_flutter_sdk",
    &flutter::StandardMethodCodec::GetInstance()
  );
  channel.SetMethodCallHandler(
    [](
      const flutter::MethodCall<>& call,
      std::unique_ptr<flutter::MethodResult<>> result
    ) {
      std::cout << "Window: "+call.method_name() << std::endl;

      if (call.method_name().compare("initZoom") == 0) {
        // capture args from flutter
        // const auto* arguments = std::get_if<flutter::EncodableMap>(call.arguments());

        // call zoom sdk init function
        ZOOMSDK::InitParam initParam;
        initParam.strWebDomain = reinterpret_cast<const zchar_t*>(L"zoom.us");
        initParam.strBrandingName = reinterpret_cast<const zchar_t*>(L"Zoom SDK");
        initParam.strSupportUrl = reinterpret_cast<const zchar_t*>(L"https://zoom.us");

        // switch InitSDK return to result
        ZOOMSDK::SDKError err = ZOOMSDK::InitSDK(initParam);
        if (err == ZOOMSDK::SDKError::SDKERR_SUCCESS) {
          result->Success();
        } else {
          result->Error("windows: InitSDK Error", "Failed to initialize Zoom SDK", flutter::EncodableValue(static_cast<int>(err)));
        }
      } 
      else if (call.method_name().compare("joinMeeting") == 0) {
        // Call Zoom SDK join meeting function here
        // Example: ZoomSDK::JoinMeeting(meetingNumber, meetingPassword, displayName);
        result->Success();
      } 
      else {
        result->NotImplemented();
      }
    }
  );

  SetChildContent(flutter_controller_->view()->GetNativeWindow());
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
