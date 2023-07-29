import 'package:flutter/material.dart';

class TravelGuidelines extends StatelessWidget {
  const TravelGuidelines({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Travel Guidelines'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comprehensive Travel Guidelines for Trips',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 16),
            // Heading: Preparation
            Text(
              "1. Preparation",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),

            // Paragraph: Thorough Destination Research
            Text(
              "1.1 Thorough Destination Research\n\nBefore embarking on your journey, conduct thorough research about your destination. Learn about its culture, history, local customs, and traditions. Understanding the local culture will help you respect and appreciate the places you visit.",
            ),
            SizedBox(height: 16),

            // Paragraph: Passport and Visas
            Text(
              "1.2 Passport and Visas\n\nCheck the validity of your passport to ensure it's valid for at least six months beyond your return date. Obtain the necessary visas and permits well in advance and ensure you have multiple copies of essential documents.",
            ),
            SizedBox(height: 16),

            // Paragraph: Vaccinations and Health Precautions
            Text(
              "1.3 Vaccinations and Health Precautions\n\nVisit your healthcare provider to receive any required vaccinations or medications for your destination. Carry a basic first-aid kit with essentials like band-aids, antiseptic, pain relievers, and any prescription medications you might need.",
            ),
            SizedBox(height: 16),

            // Paragraph: Travel Insurance
            Text(
              "1.4 Travel Insurance\n\nConsider purchasing comprehensive travel insurance that covers medical emergencies, trip cancellations, lost baggage, and other unforeseen incidents. Review the policy details to ensure it meets your needs.",
            ),
            SizedBox(height: 16),

            // Paragraph: Finances and Budgeting
            Text(
              "1.5 Finances and Budgeting\n\nCreate a travel budget to manage your finances during the trip. Inform your bank about your travel dates to avoid any issues with your credit/debit cards while abroad.",
            ),
            SizedBox(height: 16),

            // Paragraph: Language Learning
            Text(
              "1.6 Language Learning\n\nFamiliarize yourself with some basic phrases in the local language. This can help you connect with locals and navigate more effectively.",
            ),
            SizedBox(height: 24),

            // Heading: Packing Essentials
            Text(
              "2. Packing Essentials",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),

            // Paragraph: Pack Light and Smart
            Text(
              "2.1 Pack Light and Smart\n\nChoose versatile clothing suitable for various weather conditions. Consider packing clothing that can be easily mixed and matched. Don't forget essential items like toiletries, chargers, a travel adapter, and a good book for downtime.",
            ),
            SizedBox(height: 16),

            // Paragraph: Secure Your Belongings
            Text(
              "2.2 Secure Your Belongings\n\nInvest in sturdy locks for your luggage to deter potential theft. Keep valuable items, travel documents, and money in a secure travel pouch or money belt.",
            ),
            SizedBox(height: 16),

            // Paragraph: Consider a Day Bag
            Text(
              "2.3 Consider a Day Bag\n\nCarry a small day bag or backpack for daily excursions. It should be comfortable to wear and spacious enough to accommodate essentials like a water bottle, snacks, camera, and extra layers.",
            ),
            SizedBox(height: 16),

            // Paragraph: Emergency Contacts
            Text(
              "2.4 Emergency Contacts\n\nCarry a list of emergency contacts, including contacts for your embassy or consulate in the destination country.",
            ),
            SizedBox(height: 24),

            // Heading: Accommodation
            Text(
              "3. Accommodation",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),

            // Paragraph: Book Accommodations in Advance
            Text(
              "3.1 Book Accommodations in Advance\n\nEspecially during peak travel seasons or in popular destinations, book your accommodations well in advance. Research reviews and compare options to find the best fit for your preferences and budget.",
            ),
            SizedBox(height: 16),

            // Paragraph: Safety Considerations
            Text(
              "3.2 Safety Considerations\n\nChoose reputable lodging options in safe neighborhoods or areas. Check online reviews and safety ratings before making a reservation. Upon arrival, familiarize yourself with emergency exits and safety protocols of the hotel or guesthouse.",
            ),
            SizedBox(height: 24),

            // Heading: Transportation
            Text(
              "4. Transportation",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),

            // Paragraph: Plan Transportation Ahead
            Text(
              "4.1 Plan Transportation Ahead\n\nResearch and plan your transportation options beforehand. Familiarize yourself with public transportation systems, schedules, and routes to make your travel smooth.",
            ),
            SizedBox(height: 16),

            // Paragraph: Driving Considerations
            Text(
              "4.2 Driving Considerations\n\nIf you plan to drive abroad, research local traffic rules and regulations. Obtain an International Driving Permit if required, and ensure you have the necessary documents for renting a vehicle.",
            ),
            SizedBox(height: 16),

            // Paragraph: Ride-Sharing and Taxi Services
            Text(
              "4.3 Ride-Sharing and Taxi Services\n\nIn places with limited public transportation, consider using ride-sharing or reputable taxi services for safe and convenient travel.",
            ),
            SizedBox(height: 24),

            // Heading: Health and Safety
            Text(
              "5. Health and Safety",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),

            // Paragraph: Stay Vigilant
            Text(
              "5.1 Stay Vigilant\n\nWhile traveling, remain vigilant in crowded places and tourist areas. Be aware of your surroundings and keep an eye on your belongings.",
            ),
            SizedBox(height: 16),

            // Paragraph: Follow Local Safety Guidelines
            Text(
              "5.2 Follow Local Safety Guidelines\n\nStay updated on local safety guidelines and adhere to any travel advisories issued by your home country.",
            ),
            SizedBox(height: 16),

            // Paragraph: Personal Health
            Text(
              "5.3 Personal Health\n\nPrioritize your health during your journey. Stay hydrated, eat well, and get enough rest to ensure you enjoy your trip to the fullest.",
            ),
            SizedBox(height: 24),

            // Heading: Responsible Travel
            Text(
              "6. Responsible Travel",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),

            // Paragraph: Minimize Environmental Impact
            Text(
              "6.1 Minimize Environmental Impact\n\nReduce your environmental footprint by being mindful of waste and conserving resources. Avoid using single-use plastic items and recycle when possible.",
            ),
            SizedBox(height: 16),

            // Paragraph: Respect Wildlife and Nature
            Text(
              "6.2 Respect Wildlife and Nature\n\nObserve wildlife from a distance and avoid participating in activities that may harm animals or their natural habitats.",
            ),
            SizedBox(height: 16),

            // Paragraph: Support Local Communities
            Text(
              "6.3 Support Local Communities\n\nEngage with local communities in a respectful and positive manner. Support local businesses, artisans, and initiatives to contribute to the local economy.",
            ),
            SizedBox(height: 24),

            // Heading: Cultural Immersion
            Text(
              "7. Cultural Immersion",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),

            // Paragraph: Embrace Cultural Differences
            Text(
              "7.1 Embrace Cultural Differences\n\nEmbrace the diversity of cultures and traditions you encounter during your travels. Be open-minded and respectful of local customs and practices.",
            ),
            SizedBox(height: 16),

            // Paragraph: Learn the Language
            Text(
              "7.2 Learn the Language\n\nLearning a few basic phrases in the local language can go a long way in fostering connections with locals and showing respect for their culture.",
            ),
            SizedBox(height: 16),

            // Paragraph: Visit Museums and Landmarks
            Text(
              "7.3 Visit Museums and Landmarks\n\nExplore museums, historical landmarks, and cultural sites to gain a deeper understanding of the destination's heritage and significance.",
            ),
            SizedBox(height: 24),

            // Heading: Communication and Connectivity
            Text(
              "8. Communication and Connectivity",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),

            // Paragraph: Stay Connected
            Text(
              "8.1 Stay Connected\n\nInvest in a local SIM card or international roaming plan for your phone to stay connected with friends and family during your journey.",
            ),
            SizedBox(height: 16),

            // Paragraph: Use Technology Wisely
            Text(
              "8.2 Use Technology Wisely\n\nUtilize travel apps and maps to navigate unfamiliar places and find local attractions or restaurants.",
            ),
            SizedBox(height: 24),

            // Heading: Flexibility and Adaptability
            Text(
              "9. Flexibility and Adaptability",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),

            // Paragraph: Be Flexible with Plans
            Text(
              "9.1 Be Flexible with Plans\n\nTravel plans may change unexpectedly, so be adaptable and embrace new opportunities that arise.",
            ),
            SizedBox(height: 16),

            // Paragraph: Patience is Key
            Text(
              "9.2 Patience is Key\n\nTraveling can be challenging at times, but maintaining a positive attitude and being patient will help you overcome any obstacles.",
            ),
            SizedBox(height: 24),

            // Heading: Enjoy the Journey
            Text(
              "10. Enjoy the Journey",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),

            // Paragraph: Disconnect and Unwind
            Text(
              "10.1 Disconnect and Unwind\n\nTake time to disconnect from technology and immerse yourself fully in your travel experiences.",
            ),
            SizedBox(height: 16),

            // Paragraph: Take Photos Mindfully
            Text(
              "10.2 Take Photos Mindfully\n\nCapture memories with your camera, but also remember to take moments to enjoy the present without being behind the lens.",
            ),
            SizedBox(height: 16),

            // Paragraph: Embrace Serendipity
            Text(
              "10.3 Embrace Serendipity\n\nSome of the best travel experiences come from unexpected encounters and spontaneous decisions. Embrace serendipity and be open to trying new things.",
            ),
            SizedBox(height: 24),

            // Conclusion
            Text(
              "Conclusion\n\nWith these comprehensive travel guidelines, you're well-equipped to embark on your adventures confidently and responsibly. Embrace the journey with an open mind and a sense of curiosity, and you'll create memories that last a lifetime. Remember to be respectful of the destinations you visit, make meaningful connections with locals, and leave a positive impact wherever you go. Happy travels!",
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
