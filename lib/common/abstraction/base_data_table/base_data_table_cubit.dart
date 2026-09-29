import 'package:dartz/dartz.dart';
import 'package:ecommerce_admin_pannal/common/errors/failure.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'base_data_table_state.dart';

abstract class BaseDataTableCubit<T> extends Cubit<BaseDataTableState<T>> {
  BaseDataTableCubit() : super(BaseDataTableState<T>()) {
    fetchData();
  }

  Future<Either<Failure, List<T>>> fetchItems();

  Future<void> fetchData() async {
    emit(state.copyWith(status: DataTableStatus.loading));
    final result = await fetchItems();
    result.fold(
      (error) {
        emit(
          state.copyWith(
            status: DataTableStatus.error,
            errorMessage: error.toString(),
          ),
        );
      },
      (success) {
        emit(
          state.copyWith(
            allItems: success,
            filterdItems: success,
            status: DataTableStatus.success,
            selectedRows: List.generate(success.length, (_) => false),
          ),
        );
      },
    );
  }

  String getItemId(T item);
  bool filterCondition(T item, String query);

  void searchQuery(String query) {
    final filtered = state.allItems
        .where((item) => filterCondition(item, query))
        .toList();

    emit(
      state.copyWith(
        filterdItems: filtered,
        selectedRows: List.generate(filtered.length, (_) => false),
      ),
    );
  }

  void sortByProperty(
    int columnIndex,
    bool ascending,
    Comparable Function(T item) property,
  ) {
    final sorted = List<T>.from(state.filterdItems);

    sorted.sort((a, b) {
      final aValue = property(a);
      final bValue = property(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    emit(
      state.copyWith(
        filterdItems: sorted,
        sortColumnIndex: columnIndex,
        sortAscending: ascending,
      ),
    );
  }

  void toggleRowSelection(int index, bool? selected) {
    if (index < 0 || index >= state.selectedRows.length) return;

    final updated = List<bool>.from(state.selectedRows);
    updated[index] = selected ?? false;

    emit(state.copyWith(selectedRows: updated));
  }

  void toggleSelectAll(bool? selected) {
    final updated = List.generate(
      state.filterdItems.length,
      (_) => selected ?? false,
    );

    emit(state.copyWith(selectedRows: updated));
  }

  List<T> get selectedCategories {
    final items = <T>[];
    for (var i = 0; i < state.filterdItems.length; i++) {
      if (i < state.selectedRows.length && state.selectedRows[i]) {
        items.add(state.filterdItems[i]);
      }
    }
    return items;
  }

  void removeItemFromLists(T item) {
    final itemId = getItemId(item);
    final index = state.filterdItems.indexWhere((c) => getItemId(c) == itemId);

    final updatedAll = state.allItems
        .where((c) => getItemId(c) != itemId)
        .toList();
    final updatedFiltered = state.filterdItems
        .where((c) => getItemId(c) != itemId)
        .toList();

    final updatedSelected = List<bool>.from(state.selectedRows);
    if (index != -1 && index < updatedSelected.length) {
      updatedSelected.removeAt(index);
    }

    emit(
      state.copyWith(
        allItems: updatedAll,
        filterdItems: updatedFiltered,
        selectedRows: updatedSelected,
        status: DataTableStatus.success,
      ),
    );
  }

  void addItemToLists(T item) {
    final updatedAll = List<T>.from(state.allItems)..add(item);
    final updatedFiltered = List<T>.from(state.filterdItems)..add(item);

    emit(
      state.copyWith(
        allItems: updatedAll,
        filterdItems: updatedFiltered,
        selectedRows: List.generate(updatedFiltered.length, (_) => false),
      ),
    );
  }

  void updateItemInLists(T updatedItem) {
    final updatedId = getItemId(updatedItem);

    final updatedAll = state.allItems.map((item) {
      return getItemId(item) == updatedId ? updatedItem : item;
    }).toList();

    final updatedFiltered = state.filterdItems.map((item) {
      return getItemId(item) == updatedId ? updatedItem : item;
    }).toList();

    emit(
      state.copyWith(
        allItems: updatedAll,
        filterdItems: updatedFiltered,
        status: DataTableStatus.success,
      ),
    );
  }
}
