import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/abstraction/base_data_table/base_data_table_state.dart';
import '../../../../../common/errors/failure.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../order/domain/entities/order_entity.dart';
import '../../../../order/domain/entities/user_entity.dart';
import '../../../../order/domain/repos/order_repo.dart';
import '../../../../order/domain/repos/user_repo.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final OrderRepo _orderRepo;
  final UserRepo _userRepo;

  DashboardCubit({
    required OrderRepo orderRepo,
    required UserRepo userRepo,
  })  : _orderRepo = orderRepo,
        _userRepo = userRepo,
        super(const DashboardState()) {
    fetchData();
  }

  /// Alias method for consistency with dependency injection calls
  Future<void> getDashboardData() => fetchData();

  // ==========================================
  // Data Fetching Logic
  // ==========================================

  Future<void> fetchData() async {
    emit(state.copyWith(status: DataTableStatus.loading));

    final results = await Future.wait([
      _orderRepo.getAllOrders(),
      _userRepo.getAllUsers(),
    ]);

    final ordersResult = results[0] as Either<Failure, List<OrderEntity>>;
    final usersResult = results[1] as Either<Failure, List<UserEntity>>;

    ordersResult.fold(
          (error) {
        emit(state.copyWith(
          status: DataTableStatus.error,
          errorMessage: error.message,
        ));
      },
          (orders) {
        final totalCustomers = usersResult.fold(
              (_) => 0,
              (users) => users.length,
        );

        emit(_buildUpdatedMetricsState(
          orders,
          totalCustomers: totalCustomers,
        ));
      },
    );
  }

  // ==========================================
  // Data Table Functionalities
  // ==========================================

  String getItemId(OrderEntity item) => item.id;

  bool filterCondition(OrderEntity item, String query) {
    final q = query.toLowerCase();
    return item.id.toLowerCase().contains(q) ||
        item.status.name.toLowerCase().contains(q) ||
        item.totalAmount.toString().contains(q);
  }

  void searchQuery(String query) {
    final filtered = state.allItems
        .where((item) => filterCondition(item, query))
        .toList();

    emit(state.copyWith(
      filterdItems: filtered,
      selectedRows: List<bool>.filled(filtered.length, false),
    ));
  }

  void sortByProperty(
      int columnIndex,
      bool ascending,
      Comparable Function(OrderEntity item) property,
      ) {
    final sorted = List<OrderEntity>.from(state.filterdItems);

    sorted.sort((a, b) {
      final aValue = property(a);
      final bValue = property(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    emit(state.copyWith(
      filterdItems: sorted,
      sortColumnIndex: columnIndex,
      sortAscending: ascending,
    ));
  }

  void toggleRowSelection(int index, bool? selected) {
    if (index < 0 || index >= state.selectedRows.length) return;

    final updated = List<bool>.from(state.selectedRows);
    updated[index] = selected ?? false;

    emit(state.copyWith(selectedRows: updated));
  }

  void toggleSelectAll(bool? selected) {
    final updated = List<bool>.filled(
      state.filterdItems.length,
      selected ?? false,
    );

    emit(state.copyWith(selectedRows: updated));
  }

  List<OrderEntity> get selectedOrders {
    final items = <OrderEntity>[];
    for (var i = 0; i < state.filterdItems.length; i++) {
      if (i < state.selectedRows.length && state.selectedRows[i]) {
        items.add(state.filterdItems[i]);
      }
    }
    return items;
  }

  void removeItemFromLists(OrderEntity item) {
    final itemId = getItemId(item);
    final index = state.filterdItems.indexWhere((c) => getItemId(c) == itemId);

    final updatedAll =
    state.allItems.where((c) => getItemId(c) != itemId).toList();
    final updatedFiltered =
    state.filterdItems.where((c) => getItemId(c) != itemId).toList();

    final updatedSelected = List<bool>.from(state.selectedRows);
    if (index != -1 && index < updatedSelected.length) {
      updatedSelected.removeAt(index);
    }

    emit(_buildUpdatedMetricsState(
      updatedAll,
      filteredItems: updatedFiltered,
      selectedRows: updatedSelected,
    ));
  }

  void addItemToLists(OrderEntity item) {
    final updatedAll = List<OrderEntity>.from(state.allItems)..add(item);
    final updatedFiltered = List<OrderEntity>.from(state.filterdItems)
      ..add(item);
    final updatedSelected = [...state.selectedRows, false];

    emit(_buildUpdatedMetricsState(
      updatedAll,
      filteredItems: updatedFiltered,
      selectedRows: updatedSelected,
    ));
  }

  void updateItemInLists(OrderEntity updatedItem) {
    final updatedId = getItemId(updatedItem);

    final updatedAll = state.allItems.map((item) {
      return getItemId(item) == updatedId ? updatedItem : item;
    }).toList();

    final updatedFiltered = state.filterdItems.map((item) {
      return getItemId(item) == updatedId ? updatedItem : item;
    }).toList();

    emit(_buildUpdatedMetricsState(
      updatedAll,
      filteredItems: updatedFiltered,
      selectedRows: state.selectedRows,
    ));
  }

  // ==========================================
  // Helper Calculations & Centralized State Builder
  // ==========================================

  DashboardState _buildUpdatedMetricsState(
      List<OrderEntity> allItems, {
        List<OrderEntity>? filteredItems,
        List<bool>? selectedRows,
        int? totalCustomers,
      }) {
    final filtered = filteredItems ?? allItems;
    final weeklySales = _calculateWeeklySales(allItems);
    final statusData = _calculateOrderStatusData(allItems);

    final totalSales =
    allItems.fold<double>(0.0, (sum, item) => sum + item.totalAmount);
    final avgOrderValue =
    allItems.isNotEmpty ? totalSales / allItems.length : 0.0;

    // Calculate dynamic stats comparing current week to previous week
    final stats = _calculateGrowthStats(allItems);

    return state.copyWith(
      status: DataTableStatus.success,
      allItems: allItems,
      filterdItems: filtered,
      selectedRows: selectedRows ?? List<bool>.filled(filtered.length, false),
      weeklySales: weeklySales,
      orderStatusData: statusData.counts,
      totalAmounts: statusData.amounts,
      totalSales: totalSales,
      salesStats: stats.salesStats,
      averageOrderValue: avgOrderValue,
      avgOrderStats: stats.avgOrderStats,
      totalOrders: allItems.length,
      ordersStats: stats.ordersStats,
      totalCustomers: totalCustomers ?? state.totalCustomers,
      customersStats: stats.customersStats,
    );
  }

  List<double> _calculateWeeklySales(List<OrderEntity> orders) {
    final List<double> weeklySales = List<double>.filled(7, 0.0);
    final DateTime currentWeekStart =
    THelperFunctions.getStartOfWeek(DateTime.now());

    for (var order in orders) {
      final DateTime orderWeekStart =
      THelperFunctions.getStartOfWeek(order.orderDate);
      if (orderWeekStart.isAtSameMomentAs(currentWeekStart)) {
        int index = (order.orderDate.weekday - 6) % 7;
        if (index < 0) index += 7;
        weeklySales[index] += order.totalAmount;
      }
    }
    return weeklySales;
  }

  ({
  Map<OrderStatus, int> counts,
  Map<OrderStatus, double> amounts,
  }) _calculateOrderStatusData(List<OrderEntity> orders) {
    final Map<OrderStatus, int> statusCountMap = {
      for (var status in OrderStatus.values) status: 0,
    };
    final Map<OrderStatus, double> statusAmountMap = {
      for (var status in OrderStatus.values) status: 0.0,
    };

    for (var order in orders) {
      statusCountMap[order.status] = (statusCountMap[order.status] ?? 0) + 1;
      statusAmountMap[order.status] =
          (statusAmountMap[order.status] ?? 0.0) + order.totalAmount;
    }

    return (counts: statusCountMap, amounts: statusAmountMap);
  }

  ({
  double salesStats,
  double avgOrderStats,
  double ordersStats,
  double customersStats,
  }) _calculateGrowthStats(List<OrderEntity> orders) {
    final now = DateTime.now();
    final currentWeekStart = THelperFunctions.getStartOfWeek(now);
    final previousWeekStart =
    currentWeekStart.subtract(const Duration(days: 7));

    double thisWeekSales = 0.0;
    double lastWeekSales = 0.0;
    int thisWeekOrders = 0;
    int lastWeekOrders = 0;

    for (var order in orders) {
      final orderWeekStart = THelperFunctions.getStartOfWeek(order.orderDate);
      if (orderWeekStart.isAtSameMomentAs(currentWeekStart)) {
        thisWeekSales += order.totalAmount;
        thisWeekOrders++;
      } else if (orderWeekStart.isAtSameMomentAs(previousWeekStart)) {
        lastWeekSales += order.totalAmount;
        lastWeekOrders++;
      }
    }

    double calcPercent(num current, num previous) {
      if (previous == 0) return current > 0 ? 100.0 : 0.0;
      return ((current - previous) / previous) * 100.0;
    }

    final thisWeekAvg =
    thisWeekOrders > 0 ? thisWeekSales / thisWeekOrders : 0.0;
    final lastWeekAvg =
    lastWeekOrders > 0 ? lastWeekSales / lastWeekOrders : 0.0;

    return (
    salesStats: calcPercent(thisWeekSales, lastWeekSales),
    avgOrderStats: calcPercent(thisWeekAvg, lastWeekAvg),
    ordersStats: calcPercent(thisWeekOrders, lastWeekOrders),
    customersStats: 0.0,
    );
  }
}