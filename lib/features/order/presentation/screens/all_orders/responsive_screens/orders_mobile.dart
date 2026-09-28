import 'package:flutter/cupertino.dart';

import '../table/data_table.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb.dart';
import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../categories/presentation/screens/all_categories/widgets/table_header.dart';
import '../../../../domain/entities/order_entity.dart';

import 'package:flutter/material.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../table/data_table.dart';

class OrdersMobileScreen extends StatelessWidget {
  const OrdersMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              TBreadcrumbsWithHeading(
                heading: 'Orders',
                breadcrumbItems: ['Orders'],
              ),
              SizedBox(height: TSizes.spaceBtwSections),

              // Table Body
              RoundedContainer(
                child: Column(
                  children: [
                    // Table Header
                    TableHeader(showLeftWidget: false),
                    SizedBox(height: TSizes.spaceBtwItems),

                    // Table
                    OrderTable(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
