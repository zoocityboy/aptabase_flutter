/// The Flutter SDK for Aptabase, a privacy-first and simple analytics platform for apps.

library aptabase_flutter;

export 'src/aptabase.dart' show Aptabase;
export 'src/core/core.dart' show AptabaseLogRecord, AptabaseLogger;
export 'src/data/services/aptabase_inmemory_storage.dart' show AptabaseInMemoryStorage;
export 'src/domain/domain.dart'
    show
        AptabaseInvalidAppKeyException,
        AptabaseClient,
        AptabaseConfig,
        AptabaseException,
        AptabaseFailure,
        AptabaseNotInitializedException,
        AptabaseNotSupportedPlatformException,
        AptabaseTrackEvent;
