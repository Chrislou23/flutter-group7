import 'package:flutter/material.dart';

class LinkInstructionsFi extends StatelessWidget {
  const LinkInstructionsFi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kuinka pelata Link-peliä'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Kuinka pelata Link-peliä',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                '1. Tavoite:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   Link-pelin tavoite on yhdistää kaikki pisteet viivoilla ilman, että viivat risteävät.',
              ),
              SizedBox(height: 16),
              Text(
                '2. Kuinka pelata:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   - Klikkaa pistettä aloittaaksesi viivan.',
              ),
              Text(
                '   - Vedä toiseen pisteeseen luodaksesi viivan.',
              ),
              Text(
                '   - Varmista, että viivat eivät risteä.',
              ),
              SizedBox(height: 16),
              Text(
                '3. Vinkkejä:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   - Aloita pisteistä, joilla on vähiten yhteyksiä.',
              ),
              Text(
                '   - Käytä täytettyjä viivoja auttamaan vaikeampien yhteyksien ratkaisemisessa.',
              ),
              Text(
                '   - Tarkista yhteytesi varmistaaksesi, että ne eivät risteä muiden viivojen kanssa.',
              ),
              SizedBox(height: 16),
              Text(
                '4. Pelin voittaminen:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   - Peli voitetaan, kun kaikki pisteet on yhdistetty viivoilla eikä viivat risteä.',
              ),
              Text(
                '   - Voit tarkistaa yhteytesi milloin tahansa nähdäksesi, oletko suorittanut tehtävän oikein.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
