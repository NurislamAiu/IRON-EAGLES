import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../auth/provider/auth_provider.dart';
import '../provider/course_provider.dart';
import '../provider/currency_provider.dart';
import '../domain/course_model.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CourseProvider>().fetchCourses());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final courses = provider.courses;
    final user = context.watch<AuthProviders>().user;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Образовательные Курсы', style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Убираем стрелочку "назад"
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Consumer<CurrencyProvider>(
            builder: (context, currencyProv, _) {
              return PopupMenuButton<String>(
                icon: const Icon(Icons.currency_exchange, color: Colors.orangeAccent),
                tooltip: "Выбрать валюту",
                color: const Color(0xff2c1e19),
                onSelected: (val) => currencyProv.setCurrency(val),
                itemBuilder: (context) {
                  return currencyProv.availableCurrencies.map((c) {
                    return PopupMenuItem(
                      value: c,
                      child: Text(
                        c,
                        style: TextStyle(
                          color: currencyProv.currency == c ? Colors.orangeAccent : Colors.white,
                          fontWeight: currencyProv.currency == c ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList();
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: user != null
          ? Padding(
              padding: const EdgeInsets.only(bottom: 75), // Поднято над Bottom NavBar
              child: FloatingActionButton(
                backgroundColor: Colors.orangeAccent,
                child: const Icon(Icons.add, color: Colors.white),
                onPressed: () => context.push('/create-course'),
              ),
            )
          : null,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff2c1e19), Color(0xff0f0c0a)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.orangeAccent))
                : courses.isEmpty
                    ? const Center(
                        child: Text(
                          "Пока нет доступных курсов",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100), // Оставляем место для Bottom NavBar
                        itemCount: courses.length,
                        itemBuilder: (context, i) {
                          return _buildCourseCard(courses[i]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(Course course) {
    final userEmail = context.read<AuthProviders>().user?.email ?? "";
    final bool isAuthor = course.authorEmail == userEmail;
    final bool isBought = course.price == 0 || course.purchasedBy.contains(userEmail) || isAuthor;

    return GestureDetector(
      onTap: () => context.push('/course-detail', extra: course),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          course.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: course.price == 0 ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: course.price == 0 ? Colors.green : Colors.orangeAccent),
                        ),
                        child: Text(
                          context.watch<CurrencyProvider>().formatPrice(course.price),
                          style: TextStyle(
                            color: course.price <= 0 ? Colors.greenAccent : Colors.orangeAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.white54),
                      const SizedBox(width: 4),
                      Text(course.authorEmail, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                      const Spacer(),
                      if (isBought && course.price > 0 && !isAuthor)
                        const Row(
                          children: [
                            Icon(Icons.check_circle, size: 16, color: Colors.greenAccent),
                            SizedBox(width: 4),
                            Text("Куплено", style: TextStyle(color: Colors.greenAccent, fontSize: 12)),
                          ],
                        )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}