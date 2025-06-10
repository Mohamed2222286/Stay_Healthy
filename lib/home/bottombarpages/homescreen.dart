import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:untitled3/models/doctor_model.dart';
import 'package:untitled3/booking/sevice_model.dart';
import 'package:untitled3/home/pages/emergence.dart';
import 'package:untitled3/home/pages/favoritedoc.dart';
import 'package:untitled3/home/pages/mapscreen.dart';
import 'package:untitled3/home/pages/notification.dart';
import '../../apis/doctor_api_service.dart';
import '../../booking/doctorcard.dart';
import '../../booking/doctors_screen.dart';
import '../../booking/servicecard.dart';
import '../../booking/servicegridscreen.dart';
import '../../widgets/newscard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Doctor>> _doctorsFutures;

  @override
  final String apiKey =
      'e79e7a8f2015454c8baea8dcaa530f87'; // News Api
  List<Article> articles = [];
  @override
  void initState() {
    super.initState();
    _doctorsFutures = ApiServiceDoctor().getDoctorsBySpecialty('Cardiology')
        as Future<List<Doctor>>;
    fetchNews();
  }

  Future<void> fetchNews() async {
    final response = await http.get(Uri.parse(
      'https://newsapi.org/v2/top-headlines?country=us&category=health&apiKey=$apiKey',
    ));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        articles = (data['articles'] as List)
            .map((article) => Article.fromJson(article))
            .toList();
      });
    } else {
      throw Exception('Failed to load news: ${response.statusCode}');
    }
  }

  final ApiServiceDoctor _apiService = ApiServiceDoctor();

  final List<Servicemodel> services = [
    Servicemodel("General", 'assets/images/051_Doctor 1.png'),
    Servicemodel("Heart Disease", 'assets/images/037_Heart.png'),
    Servicemodel("Dentistry", 'assets/images/007_Tooth.png'),
    Servicemodel("Stomach", 'assets/images/036_Stomach.png'),
    Servicemodel("Liver", 'assets/images/049_Liver.png'),
    Servicemodel("Kidney", 'assets/images/047_Kidney.png'),
    Servicemodel("Bones", 'assets/images/022_Broken_Bone.png'),
  ];

  String _mapServiceToApiKey(String serviceTitle) {
    switch (serviceTitle) {
      case 'General':
        return 'General Surgery';
      case 'Heart Disease':
        return 'Cardiology';
      case 'Dentistry':
        return 'Dentistry';
      case 'Stomach':
        return 'Gastroenterology';
      case 'Liver':
        return 'Liver';
      case 'Kidney':
        return 'Kidney';
      case 'Bones':
        return 'Orthopedics';
      default:
        throw Exception('Unknown service: $serviceTitle');
    }
  }

  List<Doctor> _favoriteDoctors = [];

  void _handleFavoriteToggled(Doctor updatedDoctor) {
    setState(() {
      if (updatedDoctor.isFavorite!) {
        _favoriteDoctors.add(updatedDoctor);
      } else {
        _favoriteDoctors.removeWhere((doc) => doc.id == updatedDoctor.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Stack(
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100),
                    ),
                    gradient: LinearGradient(
                      colors: [Color(0xff9DCEFF), Color(0xff92a3fd)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  width: 450,
                  height: 430,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        child: Row(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage(
                                      'assets/images/2025-04-17 03.17.17.jpg'),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Good Morning , Mohamed!",
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "How Are You to day?",
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                height: 55,
                                width: 55,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NotificationScreen(),
                                      ),
                                    );
                                  },
                                  icon: SvgPicture.asset(
                                    'assets/icons/Button.svg',
                                    height: 35,
                                    width: 35,
                                  ),
                                ),
                              ),
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                width: 377,
                height: 290,
                left: 25,
                top: 140,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                  ),
                  height: 210,
                  width: 377,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 17,
                          bottom: 10,
                          left: 24,
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FavoritesScreen(
                                    favoriteDoctors: _favoriteDoctors,
                                    onFavoriteToggled: _handleFavoriteToggled),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 42,
                                width: 42,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFF9dceff),
                                ),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: SvgPicture.asset(
                                    'assets/icons/First Aid Kit.svg',
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 14,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Book With Favorite Doctor',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Fast and easy booking with minimal Steps',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SvgPicture.asset(
                                'assets/icons/Carret_Right.svg',
                                height: 40,
                                width: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        '─────────────────── ',
                        style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 17,
                          bottom: 12,
                          left: 24,
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapScreen(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFF9dceff),
                                ),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: SvgPicture.asset(
                                    'assets/icons/Location.svg',
                                    height: 40,
                                    width: 14,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 14,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Locate Medical Hospital',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Locate a nearby hospital',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                              SizedBox(
                                width: 70,
                              ),
                              SvgPicture.asset(
                                'assets/icons/Carret_Right.svg',
                                height: 40,
                                width: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        '─────────────────── ',
                        style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 17,
                          bottom: 12,
                          left: 24,
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Emergence(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFF9dceff),
                                ),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: SvgPicture.asset(
                                    'assets/icons/Ambulance.svg',
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 14,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Request an emergency',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Request an emergency services',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                              SizedBox(
                                width: 70,
                              ),
                              SvgPicture.asset(
                                'assets/icons/Carret_Right.svg',
                                height: 40,
                                width: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildServicesSection(),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    "Recommendation Doctor",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 440,
                  width: 470,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: FutureBuilder<List<Doctor>>(
                      future: _doctorsFutures,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Transform.scale(
                              scale: 0.2,
                              child: Container(
                                color: Colors.transparent,
                                child: LoadingIndicator(
                                  indicatorType: Indicator.ballBeat,
                                  colors: const [
                                    Color(0xff92A3FD),
                                    Color(0xff9DCEFF),
                                    Colors.blue,
                                  ],
                                  strokeWidth: 30,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error ${snapshot.error}'));
                        }

                        final doctors = snapshot.data ?? [];

                        if (doctors.isEmpty) {
                          return Center(child: Text('Data not found'));
                        }

                        return ListView.builder(
                          itemCount: doctors.length,
                          itemBuilder: (context, index) {
                            final doctor = doctors[index];
                            return DoctorCard(
                              doctor: doctor,
                              onFavoriteToggled: _handleFavoriteToggled,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    "Latest News",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 280,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        return NewsCard(article: article);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      extendBody: true,
    );
  }

  Widget _buildServicesSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Services",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            InkWell(
              onTap: () => _navigateToServiceGrid(),
              child: Text(
                "See all",
                style: GoogleFonts.poppins(
                  color: const Color(0xff407CE2),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: services.length,
            itemBuilder: (context, index) {
              return ServiceCard(
                service: services[index],
                onTap: () => _handleServiceTap(services[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  void _navigateToServiceGrid() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceGridScreen(),
      ),
    );
  }

  Future<void> _handleServiceTap(Servicemodel service) async {
    try {
      final doctors = await _apiService
          .getDoctorsBySpecialty(_mapServiceToApiKey(service.title));

      if (!mounted) return;

      if (doctors.isEmpty) {
        _showSnackBar('No doctors found for ${service.title}');
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DoctorScreen(
            specialty: _mapServiceToApiKey(service.title),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      _showSnackBar('Failed to load doctors. Please try again.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
