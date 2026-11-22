import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/network/dio_client.dart';
import 'package:assab/core/widgets/app_scaffold.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashiers_management/cashiers_bottom_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/cubits/search/search_cubit.dart';
import '../../../domain/entity/cashier_entity.dart';
import '../../logic/cashier/cashier_management_cubit.dart';
import '../widgets/shift_management_app_bar.dart';

class CashiersManagementScreen extends StatefulWidget {
  const CashiersManagementScreen({super.key});

  @override
  State<CashiersManagementScreen> createState() =>
      _CashiersManagementScreenState();
}

class _CashiersManagementScreenState extends State<CashiersManagementScreen> {
  late final ScrollController _scrollController;
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_onScroll);
    searchController = TextEditingController();

    context.read<CashierManagementCubit>().getCashiers();
  }

  void _onScroll() {
    final cubit = context.read<CashierManagementCubit>();

    if (!_scrollController.position.outOfRange &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 400.h) {
      if (cubit.hasMore) {
        context.read<CashierManagementCubit>().getCashiers(loadMore: true);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        children: [
          ShiftManagementAppBar(
            searchController: searchController,
            onSearch: (value) {
              context.read<SearchCubit<CashierEntity>>().search(
                value,
                (cashier, q) =>
                    cashier.name.toLowerCase().contains(q.toLowerCase()),
              );
            },
          ),

          const _ExpenseDelegationsPanel(),

          Expanded(
            child: CashiersBottomSectionWidget(
              scrollController: _scrollController,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseDelegationsPanel extends StatefulWidget {
  const _ExpenseDelegationsPanel();

  @override
  State<_ExpenseDelegationsPanel> createState() =>
      _ExpenseDelegationsPanelState();
}

class _ExpenseDelegationsPanelState extends State<_ExpenseDelegationsPanel> {
  static const _endpoint = '/branch-manager/expenses/delegations/cashiers';
  final _dio = DioClient.create();
  List<Map<String, dynamic>> _cashiers = [];
  bool _loading = true;
  String? _error;
  String? _savingId;

  bool get _arabic => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final response = await _dio.get<dynamic>(_endpoint);
      final body = response.data;
      final rows = body is Map ? body['data'] : null;
      if (rows is! List) throw const FormatException('Invalid response');
      if (!mounted) return;
      setState(() {
        _cashiers = rows
            .whereType<Map>()
            .map((row) => Map<String, dynamic>.from(row))
            .toList();
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = _arabic
            ? 'تعذر تحميل الصلاحيات'
            : 'Could not load permissions';
      });
    }
  }

  Future<void> _setDelegation(
    Map<String, dynamic> cashier,
    bool enabled,
  ) async {
    final id = cashier['id']?.toString();
    if (id == null) return;
    setState(() => _savingId = id);
    try {
      if (enabled) {
        await _dio.put<dynamic>('$_endpoint/$id');
      } else {
        await _dio.delete<dynamic>('$_endpoint/$id');
      }
      await _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _arabic ? 'تعذر تحديث التفويض' : 'Could not update delegation',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _savingId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _arabic ? 'صلاحية إدخال المصاريف' : 'Expense entry access';
    final isTablet = MediaQuery.sizeOf(context).width >= 600;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isTablet ? 760 : double.infinity),
        child: SizedBox(
          width: double.infinity,
          height: isTablet ? 230 : 188,
          child: Card(
            margin: EdgeInsetsDirectional.fromSTEB(12.w, 4.h, 12.w, 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.w, 10.h, 8.w, 4.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      IconButton(
                        tooltip: _arabic ? 'تحديث' : 'Refresh',
                        onPressed: _loading ? null : _load,
                        icon: const Icon(Icons.refresh),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                      ? Center(
                          child: TextButton(
                            onPressed: _load,
                            child: Text(
                              '$_error • ${_arabic ? 'إعادة المحاولة' : 'Retry'}',
                            ),
                          ),
                        )
                      : _cashiers.isEmpty
                      ? Center(
                          child: Text(
                            _arabic
                                ? 'لا يوجد كاشير في هذا الفرع'
                                : 'No cashiers in this branch',
                          ),
                        )
                      : ListView.builder(
                          itemCount: _cashiers.length,
                          itemBuilder: (context, index) {
                            final cashier = _cashiers[index];
                            final active = cashier['status'] == 'active';
                            final delegated =
                                cashier['can_write_expenses'] == true;
                            final id = cashier['id']?.toString();
                            return SwitchListTile.adaptive(
                              dense: true,
                              title: Text(cashier['name']?.toString() ?? ''),
                              subtitle: Text(
                                active
                                    ? (delegated
                                          ? (_arabic ? 'مفوّض' : 'Delegated')
                                          : (_arabic
                                                ? 'غير مفوّض'
                                                : 'Not delegated'))
                                    : (_arabic
                                          ? 'الحساب غير نشط'
                                          : 'Account inactive'),
                              ),
                              value: delegated,
                              onChanged: active && _savingId != id
                                  ? (value) => _setDelegation(cashier, value)
                                  : null,
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
