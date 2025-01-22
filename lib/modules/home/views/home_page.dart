import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:theme_provider/theme_provider.dart';

import '../bloc/home_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(const InitializeHomeEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Base Template Home'),
          actions: [
            IconButton(
              icon: Icon(
                ThemeProvider.themeOf(context).id == 'lightthemeid'
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
              ),
              onPressed: () {
                // Toggle between light and dark themes
                final currentThemeId = ThemeProvider.themeOf(context).id;
                final newThemeId = currentThemeId == 'lightthemeid'
                    ? 'darkthemeid'
                    : 'lightthemeid';

                ThemeProvider.controllerOf(context).setTheme(newThemeId);
              },
            ),
          ],
        ),
        body: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HomeLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<HomeBloc>().add(const RefreshHomeDataEvent());
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      state.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    _buildPlaceholderDataSection(context, state),
                    const SizedBox(height: 32),
                    Text(
                      'Last Refreshed: ${state.lastRefreshed ?? "Never"}',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome to Flutter Base Template!'),
                  SizedBox(height: 20),
                  Text('Toggle theme using the icon in the app bar'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholderDataSection(BuildContext context, HomeLoaded state) {
    // Placeholder data section with mock data
    final placeholderData = state.data ??
        {
          'users': [
            {'name': 'John Doe', 'email': 'john.doe@example.com'},
            {'name': 'Jane Smith', 'email': 'jane.smith@example.com'},
          ],
          'projects': [
            {'name': 'Flutter Base Template', 'status': 'Active'},
            {'name': 'Mobile App', 'status': 'In Progress'},
          ],
        };

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Placeholder Data',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildDataSection(
              context,
              'Users',
              (placeholderData['users'] as List).map(
                (user) => Text('${user['name']} (${user['email']})'),
              ),
            ),
            const SizedBox(height: 16),
            _buildDataSection(
              context,
              'Projects',
              (placeholderData['projects'] as List).map(
                (project) => Text('${project['name']} - ${project['status']}'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSection(
      BuildContext context, String title, Iterable<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: item,
            )),
      ],
    );
  }
}
