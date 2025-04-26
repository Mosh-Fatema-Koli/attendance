part of 'wfhentry_cubit.dart';

class WfhentryState {
  final String cameraPath;
  final String message;
  final bool success;

  WfhentryState({
    required this.cameraPath,
    required this.message,
    required this.success,
  });

  WfhentryState copyWith({
    String? leaveType,
    String? cameraPath,
    String? message,
    bool? success,
  }) {
    return WfhentryState(
      cameraPath: cameraPath ?? this.cameraPath,
      message: message ?? this.message,
      success: success ?? this.success,
    );
  }
}
