import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../common/widgets/breadcrumbs/breadcrumb.dart';
import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../categories/presentation/screens/all_categories/widgets/table_header.dart';
import '../table/data_table.dart';
class CustomersTabletScreen extends StatelessWidget {
  const CustomersTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              const TBreadcrumbsWithHeading(heading: 'Customers', breadcrumbItems: ['Customers']),
              const SizedBox(height: TSizes.spaceBtwSections),

              RoundedContainer(
                child: Column(
                  children: [
                    // Table Header
                    TableHeader(showLeftWidget: false,),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    // Table
                    CustomerTable(),
                  ],
                ),
              ), // TRoundedContainer
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
