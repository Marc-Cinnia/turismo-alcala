import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valdeiglesias/constants/app_constants.dart';
import 'package:valdeiglesias/dtos/event.dart';
import 'package:valdeiglesias/models/language_model.dart';
import 'package:valdeiglesias/models/schedule_model.dart';
import 'package:valdeiglesias/screens/schedule_detail.dart';
import 'package:valdeiglesias/utils/content_builder.dart';
import 'package:valdeiglesias/utils/loader_builder.dart';
import 'package:valdeiglesias/widgets/dynamic_title.dart';
import 'package:valdeiglesias/widgets/wishlist_button.dart'; // COMENTADO: Funcionalidad de estrella deshabilitada

class Schedule extends StatefulWidget {
  const Schedule({
    super.key,
    required this.accessible,
  });

  final bool accessible;

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  late LanguageModel _language;
  late ScheduleModel _scheduleModel;

  @override
  void initState() {
    // _model.getSchedule().then(_updateUI);
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    _language = context.watch<LanguageModel>();
    _scheduleModel = context.watch<ScheduleModel>();

    final appBarTitle = (_language.english)
        ? AppConstants.eventsTitleLabelEn
        : AppConstants.eventsTitleLabel;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppConstants.backArrowColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: DynamicTitle(value: appBarTitle, accessible: widget.accessible),
        actions: ContentBuilder.getActions(),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppConstants.shortSpacing,
            right: AppConstants.shortSpacing,
            bottom: AppConstants.contentBottomSpacing,
          ),
          child: Column(
            children: [
              const SizedBox(height: AppConstants.spacing),
              Builder(
                builder: (context) {
                  final eventsToBuild = (_language.english)
                      ? _scheduleModel.scheduleEn
                      : _scheduleModel.schedule;
                  
                  if (eventsToBuild.isNotEmpty) {
                    return Column(
                      children: _buildListItems(context, eventsToBuild),
                    );
                  }

                  // Si ya terminó de cargar y no hay eventos, mostrar mensaje
                  if (_scheduleModel.hasFinishedLoading) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppConstants.spacing * 2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_busy,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _language.english
                                  ? 'No upcoming events'
                                  : 'No hay eventos próximos',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _language.english
                                  ? 'There are no events scheduled for the upcoming dates'
                                  : 'No hay eventos programados para las próximas fechas',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Si aún está cargando, mostrar loader
                  return Center(child: LoaderBuilder.getLoader());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildListItems(
    BuildContext context,
    Map<String, List<Event>> items,
  ) {
    List<String> months = items.keys.toList();

    return List.generate(
      months.length,
      (parentIndex) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  months[parentIndex],
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppConstants.primary,
                      ),
                ),
                const Icon(
                  Icons.calendar_today,
                  color: AppConstants.primary,
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacing),
            Column(
              children: List.generate(
                items[months[parentIndex]]!.length,
                (index) {
                  // Current event:
                  Event event = items[months[parentIndex]]![index];
                  return _eventCard(context, event);
                },
              ),
            ),
            const SizedBox(height: AppConstants.spacing),
          ],
        );
      },
    );
  }

  Widget _eventCard(BuildContext context, Event event) {
    return Card(
      color: AppConstants.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.cardSpacing),
          child: Builder(builder: (context) {
            final addressSection = (widget.accessible)
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(AppConstants.shortSpacing),
                    child: Text(
                      event.eventAddress,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppConstants.lessContrast),
                    ),
                  );

            final descSection = (widget.accessible)
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(AppConstants.shortSpacing),
                    child: Text(
                      event.shortDescription!,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );

            final actionsSection = (widget.accessible)
                ? Align(
                    alignment: Alignment.topRight,
                    child: SizedBox(
                      width: 30.0,
                      child: GestureDetector(
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: AppConstants.primary,
                        ),
                        onTap: () {},
                      ),
                    ),
                  )
                : WishlistButton(place: event, isTextButton: false); // Funcionalidad de estrella deshabilitada

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _showDetail(context, event),
                  child: Text(
                    event.startDay,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: AppConstants.contrast),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: AppConstants.cardSpacing,
                        right: AppConstants.cardSpacing,
                      ),
                      child: Builder(builder: (context) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.placeName,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppConstants.primary,
                                  ),
                            ),
                            addressSection,
                            descSection,
                          ],
                        );
                      }),
                    ),
                    onTap: () => _showDetail(context, event),
                  ),
                ),
                actionsSection,
              ],
            );
          }),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, Event event) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScheduleDetail(
          event: event,
          accessible: widget.accessible,
        ),
      ),
    );
  }
}
