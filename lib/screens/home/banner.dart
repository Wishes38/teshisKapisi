import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BannerIG extends StatefulWidget {
  const BannerIG({super.key});

  @override
  State<BannerIG> createState() => _BannerState();
}

class _BannerState extends State<BannerIG> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //1st banner
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                //For Dark Color
                color:
                    Colors.blueGrey //isDark ? tSecondaryColor : tCardBgColor,
                ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Icon(Icons.bookmark)),
                    SvgPicture.asset(
                      'assets/icons/medical3.svg',
                      width: 88, // Adjust the width to your desired size
                      height: 88, // Adjust the height to your desired size
                    ),
                    //Flexible(child: Image(image: AssetImage('assets/icons/medical.png'))),
                  ],
                ),
                const SizedBox(height: 25),
                Text('Sağlık Tahlili Nasıl Alınır?', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold),),
                Text('kullanım için yapılması gerekenler neler?', maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),
        const SizedBox(width: 40),
        //2nd Banner
        Expanded(
          child: Column(
            children: [
              //Card
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    //For Dark Color
                    color: Colors.red //isDark ? tSecondaryColor : tCardBgColor,
                    ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(child: Icon(Icons.bookmark)),
                        SvgPicture.asset(
                          'assets/icons/medical2.svg',
                          width: 68, // Adjust the width to your desired size
                          height: 68, // Adjust the height to your desired size
                        ),

                      ],
                    ),
                    Text('Sağlık Değerleri Sisteme Nasıl Yüklenir?', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold),),
                    Text('uygulamanın kullanımına dair kısa bir tur',
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: OutlinedButton(
                      onPressed: () {}, child: const Text('Görüntüle')),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
