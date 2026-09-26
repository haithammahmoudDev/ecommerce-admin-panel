// sidebar_state.dart
import 'package:equatable/equatable.dart';

class SidebarState extends Equatable {
  final String activeItem;
  final String hoverItem;

  const SidebarState({
    required this.activeItem,
    this.hoverItem = '',
  });

  SidebarState copyWith({String? activeItem, String? hoverItem}) {
    return SidebarState(
      activeItem: activeItem ?? this.activeItem,
      hoverItem: hoverItem ?? this.hoverItem,
    );
  }

  bool isActive(String route) => activeItem == route;
  bool isHovering(String route) => hoverItem == route;

  @override
  List<Object?> get props => [activeItem, hoverItem];
}