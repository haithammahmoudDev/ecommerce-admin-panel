part of 'dashboard_cubit.dart';

class DashboardState extends BaseDataTableState<OrderEntity> {
  final List<double> weeklySales;
  final Map<OrderStatus, int> orderStatusData;
  final Map<OrderStatus, double> totalAmounts;
  final double totalSales;
  final double salesStats;
  final double averageOrderValue;
  final double avgOrderStats;
  final int totalOrders;
  final double ordersStats;
  final int totalCustomers;
  final double customersStats;

  const DashboardState({
    super.allItems = const [],
    super.filterdItems = const [],
    super.status = DataTableStatus.initial,
    super.errorMessage = '',
    super.selectedRows = const [],
    super.sortColumnIndex = 0,
    super.sortAscending = true,
    this.weeklySales = const [0, 0, 0, 0, 0, 0, 0],
    this.orderStatusData = const {},
    this.totalAmounts = const {},
    this.totalSales = 0.0,
    this.salesStats = 0.0,
    this.averageOrderValue = 0.0,
    this.avgOrderStats = 0.0,
    this.totalOrders = 0,
    this.ordersStats = 0.0,
    this.totalCustomers = 0,
    this.customersStats = 0.0,
  });

  @override
  DashboardState copyWith({
    List<OrderEntity>? allItems,
    List<OrderEntity>? filterdItems,
    DataTableStatus? status,
    String? errorMessage,
    List<bool>? selectedRows,
    int? sortColumnIndex,
    bool? sortAscending,
    List<double>? weeklySales,
    Map<OrderStatus, int>? orderStatusData,
    Map<OrderStatus, double>? totalAmounts,
    double? totalSales,
    double? salesStats,
    double? averageOrderValue,
    double? avgOrderStats,
    int? totalOrders,
    double? ordersStats,
    int? totalCustomers,
    double? customersStats,
  }) {
    return DashboardState(
      allItems: allItems ?? this.allItems,
      filterdItems: filterdItems ?? this.filterdItems,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedRows: selectedRows ?? this.selectedRows,
      sortColumnIndex: sortColumnIndex ?? this.sortColumnIndex,
      sortAscending: sortAscending ?? this.sortAscending,
      weeklySales: weeklySales ?? this.weeklySales,
      orderStatusData: orderStatusData ?? this.orderStatusData,
      totalAmounts: totalAmounts ?? this.totalAmounts,
      totalSales: totalSales ?? this.totalSales,
      salesStats: salesStats ?? this.salesStats,
      averageOrderValue: averageOrderValue ?? this.averageOrderValue,
      avgOrderStats: avgOrderStats ?? this.avgOrderStats,
      totalOrders: totalOrders ?? this.totalOrders,
      ordersStats: ordersStats ?? this.ordersStats,
      totalCustomers: totalCustomers ?? this.totalCustomers,
      customersStats: customersStats ?? this.customersStats,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    weeklySales,
    orderStatusData,
    totalAmounts,
    totalSales,
    salesStats,
    averageOrderValue,
    avgOrderStats,
    totalOrders,
    ordersStats,
    totalCustomers,
    customersStats,
  ];
}