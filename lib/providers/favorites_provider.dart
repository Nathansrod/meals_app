import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/providers/filters_provider.dart';
import 'package:meals_app/providers/meals_provider.dart';

class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
  FavoriteMealsNotifier() : super([]);

  bool toggleMealFavoriteStatus(Meal meal) {
    // state holds the managed value
    // state cannot be edited, must always be re-instantiated
    final mealIsFavorite = state.contains(meal);

    if (mealIsFavorite) {
      state = state
          .where(
            (listMeal) => listMeal.id != meal.id,
          )
          .toList();
      return false;
    } else {
      state = [
        ...state, // keep old meals, using spread operator (...)
        meal // add new one
      ];
      return true;
    }
  }
}

// Returns an instance of our notifier class
final favoriteMealsProvider =
    StateNotifierProvider<FavoriteMealsNotifier, List<Meal>>(
  (ref) => FavoriteMealsNotifier(),
);

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);

  return meals.where((meal) {
    if (activeFilters[Filter.glutenFree]! && meal.isGlutenFree == false) {
      return false;
    }
    if (activeFilters[Filter.lactoseFree]! && meal.isLactoseFree == false) {
      return false;
    }
    if (activeFilters[Filter.vegetarian]! && meal.isVegetarian == false) {
      return false;
    }
    if (activeFilters[Filter.vegan]! && meal.isVegan == false) {
      return false;
    }
    return true;
  }).toList();
});
