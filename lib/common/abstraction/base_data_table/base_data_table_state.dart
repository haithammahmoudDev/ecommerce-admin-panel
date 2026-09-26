import 'package:equatable/equatable.dart';

enum DataTableStatus { initial, loading, error, success }

class BaseDataTableState<T> extends Equatable {
  final List<T> allItems;
  final List<T> filterdItems;
  final DataTableStatus status;
  final String? errorMessage;
  final int sortColumnIndex;
  final bool sortAscending;
  final List<bool> selectedRows;

  const BaseDataTableState({
    this.allItems = const [],
    this.filterdItems = const [],
    this.status = DataTableStatus.initial,
    this.errorMessage,
    this.sortColumnIndex = 0,
    this.sortAscending = true,
    this.selectedRows = const [],
  });

  BaseDataTableState<T> copyWith({
    List<T>? allItems,
    List<T>? filterdItems,
    DataTableStatus? status,
    String? errorMessage,
    int? sortColumnIndex,
    bool? sortAscending,
    List<bool>? selectedRows,
  }) {
    return BaseDataTableState<T>(
      allItems: allItems ?? this.allItems,
      filterdItems: filterdItems ?? this.filterdItems,
      status: status ?? this.status,
      // Note: pass errorMessage explicitly (even null) if you want to clear it;
      // the `??` pattern below keeps the old message unless a new one is given.
      errorMessage: errorMessage ?? this.errorMessage,
      sortColumnIndex: sortColumnIndex ?? this.sortColumnIndex,
      sortAscending: sortAscending ?? this.sortAscending,
      selectedRows: selectedRows ?? this.selectedRows,
    );
  }

  int get selectedCount => selectedRows.where((selected) => selected).length;

  @override
  List<Object?> get props => [
    allItems,
    filterdItems,
    status,
    errorMessage,
    sortColumnIndex,
    sortAscending,
    selectedRows,
  ];
}