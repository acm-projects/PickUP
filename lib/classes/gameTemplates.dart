import 'package:pickup/classes/game.dart';
import 'package:timezone/timezone.dart' as tz;

var basketballGame = Game(
  'Friendly Basketball Match',
  'Community Sports Club',
  'Basketball',
  'Join us for a casual basketball game at the local court.',
  10, // Maximum players allowed
  tz.TZDateTime.now(tz.getLocation('America/Chicago')),
);

var soccerMatch = Game(
  'Saturday Soccer League',
  'City Sports Association',
  'Soccer',
  'Compete in a 5-a-side soccer match with fellow enthusiasts.',
  12, // Maximum players allowed
  tz.TZDateTime.now(tz.getLocation('America/Chicago')),
);

var tennisDoubles = Game(
  'Mixed Doubles Tennis Tournament',
  'Tennis Club',
  'Tennis',
  'Play exciting doubles matches on the tennis courts.',
  8, // Maximum players allowed
  tz.TZDateTime.now(tz.getLocation('America/Chicago')),
);

var volleyballBeachGame = Game(
  'Beach Volleyball Fun',
  'Beach Sports Group',
  'Volleyball',
  'Dig, spike, and serve on the sandy beach courts.',
  6, // Maximum players allowed
  tz.TZDateTime.now(tz.getLocation('America/Chicago')),
);

var baseballPickupGame = Game(
  'Pickup Baseball Match',
  'Neighborhood Team',
  'Baseball',
  'Bring your gloves and bats for a friendly baseball game.',
  18, // Maximum players allowed
  tz.TZDateTime.now(tz.getLocation('America/Chicago')),
);

Map<String, Game> sportsGames = {
  'Basketball': basketballGame,
  'Soccer': soccerMatch,
  'Tennis': tennisDoubles,
  'Volleyball': volleyballBeachGame,
  'Baseball': baseballPickupGame,
};







