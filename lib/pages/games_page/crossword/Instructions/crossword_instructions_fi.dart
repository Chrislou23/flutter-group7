import 'package:flutter/material.dart';

class CrosswordInstructionsFi extends StatelessWidget {
  const CrosswordInstructionsFi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kuinka pelata Ristisanatehtävää'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Kuinka pelata Ristisanatehtävää',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                '1. Tavoite:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   Ristisanatehtävän tavoite on täyttää valkoiset ruudut kirjaimilla, muodostaen sanoja tai lauseita, ratkaisemalla vihjeitä, jotka johtavat vastauksiin.',
              ),
              SizedBox(height: 16),
              Text(
                '2. Kuinka pelata:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   - Klikkaa vihjettä korostaaksesi vastaavan sanan ruudukossa.',
              ),
              Text(
                '   - Kirjoita vastauksesi näppäimistöllä. Kirjaimet ilmestyvät korostettuihin ruutuihin.',
              ),
              Text(
                '   - Jos teet virheen, voit poistaa kirjaimen klikkaamalla sitä ja painamalla backspace-näppäintä.',
              ),
              SizedBox(height: 16),
              Text(
                '3. Vinkkejä:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   - Aloita vihjeistä, jotka tiedät ja täytä helpommat vastaukset ensin.',
              ),
              Text(
                '   - Käytä täytettyjä kirjaimia auttamaan vaikeampien vihjeiden ratkaisemisessa.',
              ),
              Text(
                '   - Tarkista vastauksesi edetessäsi varmistaaksesi, että ne sopivat muiden ruudukon sanojen kanssa.',
              ),
              SizedBox(height: 16),
              Text(
                '4. Pelin voittaminen:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   - Peli voitetaan, kun kaikki valkoiset ruudut on täytetty oikeilla kirjaimilla.',
              ),
              Text(
                '   - Voit tarkistaa vastauksesi milloin tahansa nähdäksesi, oletko suorittanut tehtävän oikein.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
