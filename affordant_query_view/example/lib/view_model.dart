import 'dart:async';

import 'package:affordant_core/affordant_core.dart';
import 'package:affordant_query_view/affordant_query_view.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

part 'view_model.freezed.dart';

// 1 - wait X before executing delegate
// 2 - if debounce called again, replace delagte
// 3 - when calling dounce, reset timer delay

final pokemons = [
  "bulbasaur",
  "ivysaur",
  "venusaur",
  "charmander",
  "charmeleon",
  "charizard",
  "squirtle",
  "wartortle",
  "blastoise",
  "caterpie",
  "metapod",
  "butterfree",
  "weedle",
  "kakuna",
  "beedrill",
  "pidgey",
  "pidgeotto",
  "pidgeot",
  "rattata",
  "raticate",
  "spearow",
  "fearow",
  "ekans",
  "arbok",
  "pikachu",
  "raichu",
  "sandshrew",
  "sandslash",
  "nidoran♀",
  "nidorina",
  "nidoqueen",
  "nidoran♂",
  "nidorino",
  "nidoking",
  "clefairy",
  "clefable",
  "vulpix",
  "ninetales",
  "jigglypuff",
  "wigglytuff",
  "zubat",
  "golbat",
  "oddish",
  "gloom",
  "vileplume",
  "paras",
  "parasect",
  "venonat",
  "venomoth",
  "diglett",
  "dugtrio",
  "meowth",
  "persian",
  "psyduck",
  "golduck",
  "mankey",
  "primeape",
  "growlithe",
  "arcanine",
  "poliwag",
  "poliwhirl",
  "poliwrath",
  "abra",
  "kadabra",
  "alakazam",
  "machop",
  "machoke",
  "machamp",
  "bellsprout",
  "weepinbell",
  "victreebel",
  "tentacool",
  "tentacruel",
  "geodude",
  "graveler",
  "golem",
  "ponyta",
  "rapidash",
  "slowpoke",
  "slowbro",
  "magnemite",
  "magneton",
  "farfetch'd",
  "doduo",
  "dodrio",
  "seel",
  "dewgong",
  "grimer",
  "muk",
  "shellder",
  "cloyster",
  "gastly",
  "haunter",
  "gengar",
  "onix",
  "drowzee",
  "hypno",
  "krabby",
  "kingler",
  "voltorb",
  "electrode",
  "exeggcute",
  "exeggutor",
  "cubone",
  "marowak",
  "hitmonlee",
  "hitmonchan",
  "lickitung",
  "koffing",
  "weezing",
  "rhyhorn",
  "rhydon",
  "chansey",
  "tangela",
  "kangaskhan",
  "horsea",
  "seadra",
  "goldeen",
  "seaking",
  "staryu",
  "starmie",
  "mr. mime",
  "scyther",
  "jynx",
  "electabuzz",
  "magmar",
  "pinsir",
  "tauros",
  "magikarp",
  "gyarados",
  "lapras",
  "ditto",
  "eevee",
  "vaporeon",
  "jolteon",
  "flareon",
  "porygon",
  "omanyte",
  "omastar",
  "kabuto",
  "kabutops",
  "aerodactyl",
  "snorlax",
  "articuno",
  "zapdos",
  "moltres",
  "dratini",
  "dragonair",
  "dragonite",
  "mewtwo",
  "mew"
];

sealed class SearchEvent {
  const SearchEvent(this.time, this.label);
  final DateTime time;
  final String label;
}

class DebounceQuery extends SearchEvent {
  const DebounceQuery(super.time, super.label);
}

class PerformQuery extends SearchEvent {
  const PerformQuery(super.time, super.label);
}

class LogDebouncer extends TimerDebouncer {
  LogDebouncer(super.duration);

  late SearchViewModel vm;
  String text = "";

  @override
  void debounce(Function() delegate) {
    final effectiveText = text.isNotEmpty ? text : "null";
    vm.log(DebounceQuery(DateTime.now(), effectiveText));
    super.debounce(() {
      vm.log(PerformQuery(DateTime.now(), effectiveText));
      delegate();
    });
  }
}

@freezed
class SearchResult with _$SearchResult {
  const SearchResult._();

  const factory SearchResult({
    required DateTime start,
    required List<SearchEvent> events,
    required int queryNumber,
    required List<String> results,
  }) = _SearchResult;
}

final class SearchViewModel
    extends QueryViewModel<String, void, List<String>, SearchResult> {
  SearchViewModel()
      : super(
          runQuery: false,
          initialQueryParams: "",
          initialDisplayParams: "",
          initialData: SearchResult(
            start: DateTime.now(),
            events: [],
            queryNumber: 0,
            results: [],
          ),
          debouncer: LogDebouncer(const Duration(milliseconds: 330)),
        ) {
    (debouncer as LogDebouncer).vm = this;
  }

  void log(SearchEvent event) {
    emit(
      state.copyWith(
        data: state.data.copyWith(
          events: [
            ...state.data.events,
            event,
          ],
        ),
      ),
    );
  }

  @override
  void setQueryParams(params) {
    (debouncer as LogDebouncer).text = params;
    super.setQueryParams(params);
  }

  @override
  FutureOr<SearchResult> queryResultToDisplayData(
          List<String> queryResult, void params) =>
      state.data.copyWith(results: queryResult);

  @override
  FutureOr<List<String>> query(String params) async {
    if (params.isEmpty) return pokemons;
    await Future.delayed(const Duration(seconds: 1));
    return extractTop(
      query: params,
      choices: pokemons,
      limit: 200,
      cutoff: 50,
    ).map((e) => e.choice).toList();
  }
}
