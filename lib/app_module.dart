import 'package:words/dictionary/presenter/words/cubit/all_words_cubit.dart';
import 'shared/navigation/routes.dart';
import 'shared/network/custom_dio.dart';
import 'shared/services/tts_service.dart';
import 'shared/services/prefs_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'dictionary/presenter/words/pages/dictionary_page.dart';
import 'dictionary/external/get_completely_word_external.dart';
import 'dictionary/domain/usecase/do_get_completely_word.dart';
import 'dictionary/data/repository/get_completely_word_impl.dart';
import 'package:words/user_session/presenter/pages/splash_page.dart';
import 'package:words/shared/services/real_time_data_base_service.dart';
import 'dictionary/presenter/completely_word/page/completely_word_page.dart';
import 'dictionary/presenter/completely_word/cubit/completely_word_cubit.dart';

class AppModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        //commons
        Bind((i) => CustomDio()),
        Bind((i) => AppTTS()),
        Bind((i) => Prefs()),
        Bind((i) => RealTimeDataBaseService()),

        //get Word Completely
        Bind.singleton((i) => DoGetCompletelyWordExternal(i())),
        Bind.singleton((i) =>
            DoGetCompletelyWordUseCase(iGetCompletelyWordRepository: i())),
        Bind.singleton((i) => GetCompletelyWordImpl(i())),
        $CompletelyWordCubit,
        $AllWordsCubit,
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Routes.defaultRoute,
          transition: TransitionType.rightToLeftWithFade,
          child: (_, args) => const SplashPage(),
        ),
        ChildRoute(
          Routes.dictionary,
          transition: TransitionType.rightToLeftWithFade,
          child: (_, args) => BlocProvider.value(
              value: Modular.get<AllWordsCubit>(),
              child: const DictionaryPage()),
        ),
        ChildRoute(
          Routes.wordCompletely,
          transition: TransitionType.rightToLeftWithFade,
          child: (_, args) => BlocProvider.value(
            value: Modular.get<CompletelyWordCubit>(),
            child: CompletelyWordPage(word: args.data,),
          ),
        )
      ];
}
