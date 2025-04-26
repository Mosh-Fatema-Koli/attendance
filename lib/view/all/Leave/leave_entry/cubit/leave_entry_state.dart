part of 'leave_entry_cubit.dart';

class LeaveEntryState {
  final String? leaveType;
  final String cameraPath;
  final String message;
  final bool success;

  LeaveEntryState({
    this.leaveType,
    required this.cameraPath,
    required this.message,
    required this.success,
  });

  LeaveEntryState copyWith({
    String? leaveType,
    String? cameraPath,
    String? message,
    bool? success,
  }) {
    return LeaveEntryState(
      leaveType: leaveType ?? this.leaveType,
      cameraPath: cameraPath ?? this.cameraPath,
      message: message ?? this.message,
      success: success ?? this.success,
    );
  }
}
