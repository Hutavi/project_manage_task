abstract class UploadEvent {}
class PressUploadButton extends UploadEvent {}

class PressDeleteButton extends UploadEvent {
  final int index;
  PressDeleteButton({required this.index});
}
