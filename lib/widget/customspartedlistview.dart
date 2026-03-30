import 'package:flutter/material.dart';
import 'package:route_tracker_pro/modle/place_datils_modle/place_datils_modle.dart';
import 'package:route_tracker_pro/modle/placesmodle/places_modle/places_modle.dart';
import 'package:route_tracker_pro/utils/map_services.dart';

class Customspartedlistview extends StatelessWidget {
  const Customspartedlistview({
    super.key,
    required this.places,
    required this.onslected,
  });
  final List<PlacesModle> places;
  final Function(PlaceDatilsModle) onslected;

  @override
  Widget build(BuildContext context) {
    MapServices mapServices = MapServices();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(places[index].description!),
            leading: Icon(Icons.location_city),
            trailing: IconButton(
              onPressed: () async {
                var placesdatils = await mapServices.getplaceDatils(
                  places[index].placeId!,
                );
                onslected(placesdatils);
              },
              icon: Icon(Icons.arrow_forward_ios),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(height: 0);
        },
        itemCount: places.length,
      ),
    );
  }
}
