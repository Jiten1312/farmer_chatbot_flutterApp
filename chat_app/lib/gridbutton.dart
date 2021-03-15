import 'package:flutter/material.dart';

class GridButton extends StatelessWidget {
  final String text;
  GridButton({this.text});
  Map<String, String> iconMap = {
    "અનાજ": '',
    "અન્ય": '',
    "કપાસ": 'cotton.png',
    "કરી લીફ": 'curryleaf.png',
    "કાસ્ટોર": 'Castor.png',
    "કુંવરપાઠુ": 'alovera.png',
    "કેરી": 'mango.png',
    "કેસર": 'Saffron.png',
    "કોકોનટ": 'Coconut.png',
    "ખેત": '',
    "ગ્યુંઅવા": 'Guava.png',
    "ઘઉં": '',
    "ચણા": 'Chickpeas.png',
    "ચીકુ": 'chikoo.png',
    "ચીલીઝ": 'Chillies.png',
    "જવ": 'Barley.png',
    "જીરું": 'Cumin.png',
    "જુવાર": 'Sorghum.png',
    "ટામેટા": 'Tomatoes.png',
    "ડુંગળી": 'Onion.png',
    "તમાકુ": 'Tobacco.png',
    "તરબૂચ": 'Watermelon.png',
    "તલ": 'Sesame.png',
    "તુલસી": 'Tulsi.png',
    "દાડમ": 'Pomegranate.png',
    "દૂધી": 'gourd.png',
    "ધાણા": 'Coriander.png',
    "નારંગી": 'Orange.png',
    "પપૈયા": 'Papaya.png',
    "પોટેટો": 'Potatoes.png',
    "બોવાઇન": 'Bovine.png',
    "ભીંડા": 'Ladies_finger.png',
    "મકાઇ": 'corn.png',
    "મગફળી": 'Peanuts.png',
    "મેથી": 'Fenugreek.png',
    "મેરીગોલ્ડ": 'Marigold.png',
    "મેરીગોલ્ડમાં": 'Marigold.png',
    "રાઈ": 'mustard.png',
    "રીંગણ": 'Eggplant.png',
    "લવિંગ": 'Cloves.png',
    "લસણ": 'Garlic.png',
    "લીંબુ": 'Lemon.png',
    "લીલા ચણા": 'Chickpeas.png',
    "વરીયાળી": 'Aniseed.png',
    "શકરટેટી": 'sweetmelon.png',
    "સરસોં": 'mustard.png',
    "સીતાફળ": 'Custardapple.png',
    "સુવાદાણા બીજ": 'Dillseeds.png'
  };
  @override
  Widget build(BuildContext context) {
    if (iconMap.containsKey(text)) {
      String iconFile = (iconMap[text] == '') ? 'grain.png' : iconMap[text];

      return Row(
        children: [
          Container(
            color: Colors.amber,
            height: 25,
            width: 25,
            child: Image(
              image: AssetImage('assets/icons/' + iconFile),
            ),
          ),
          SizedBox(width: 7),
          Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 15),
          ),
        ],
      );
    }
    return Text(
      text,
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.normal, fontSize: 15),
    );
  }
}
