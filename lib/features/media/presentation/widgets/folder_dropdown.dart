import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../utils/constants/enums.dart';
import '../controller/media_cubit/media_cubit.dart';
import '../controller/media_cubit/media_state.dart';

class MediaFolderDropdown extends StatelessWidget {
  const MediaFolderDropdown({super.key, this.onChanged});

  final void Function(MediaCategory?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaCubit, MediaState>(
      buildWhen: (previous, current) => previous.selectedPath != current.selectedPath,
      builder: (context, state) {
        return SizedBox(
          width: 160, // زيادة العرض قليلاً لضمان عدم قطع أسماء الفولدرات الطويلة
          child: DropdownButtonFormField<MediaCategory>(
            isExpanded: true,
            value: state.selectedPath,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(),
            ),
            items: MediaCategory.values
                .map((category) => DropdownMenuItem<MediaCategory>(
              value: category,
              child: Text(
                category.name.toUpperCase(),
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ))
                .toList(),
            onChanged: onChanged,
          ),
        );
      },
    );
  }
}