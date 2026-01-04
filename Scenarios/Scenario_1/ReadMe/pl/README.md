# Witamy

W tworzeniu oprogramowania zazwyczaj nie miesza się kodu źródłowego z logiką biznesową.
Powinno to dotyczyć również scenariuszy SimRail.
Dlatego opracowałem niewielki framework, który umożliwia
tworzenie scenariuszy niezależnie od kodu Lua.
Scenariusze są definiowane w pliku konfiguracyjnym, a jeśli wbudowane funkcje wyzwalające nie wystarczają, za pomocą oddzielnych, zdefiniowanych przez użytkownika funkcji wyzwalających.

W tym pliku ReadMe znajdziesz krótki opis przykładowego scenariusza, a także opis, jak korzystać z frameworka podczas tworzenia własnych scenariuszy.

## Misja

To krótki przykładowy scenariusz, w którym będziesz manewrować w nietypowych miejscach, a pociągi będą przyjeżdżać i odjeżdżać w być może nierealistyczny sposób.
Celem tego scenariusza nie jest bycie realistycznym. Jest to raczej przykład tego, jak można wykorzystać Framework do stworzenia uproszczonego scenariusza.

Ten scenariusz rozpoczyna się w miejscowości Łazy, gdzie będziesz manewrować do swoich wagonów.
Pierwszym krokiem jest kontakt z dyspozytorem, który utworzy dla Ciebie trasę do wagonów. Skontaktuj się z dyspozytorem ponownie, gdy połączysz lokomotywę z wagonami i będziesz gotowy do odjazdu.

Z Łaz pojedziesz do Dąbrowy Górniczej Ząbkowice, gdzie dodasz jeszcze kilka wagonów do tych, które już masz. Skontaktuj się z dyspozytorem ponownie, gdy dojedziesz do czerwonego światła w Dąbrowie Górniczej Ząbkowice.
Będąc na stacji, upewnij się, że zatrzymujesz się w odpowiedniej odległości od semaforów, aby nowe wagony i lokomotywa mogły się zmieścić i nie wystawały poza semafor.
Nowe wagony widać po prawej stronie i zazwyczaj są to trzy lub cztery wagony. Zadzwoń do dyspozytora, gdy odłączysz się od starych wagonów, a następnie ponownie, gdy połączysz nowe wagony ze starymi i będziesz gotowy do odjazdu.

W Będzinie zaparkujesz swoje wagony na bocznym torze. Odłącz wagony od lokomotywy i zadzwoń do dyspozytora, informując go/ją, że jesteś gotowy/a do jazdy do celu, Sosnowca Głównego, gdzie zaparkujesz lokomotywę.

Aby zakończyć scenariusz, musisz zaparkować lokomotywę w odległości 50 metrów lub mniejszej od semafora. Wyłącz lokomotywę i wyjdź przez drzwi.

W kilku miejscach możesz nie usłyszeć sygnału „start” i nie otrzymać odpowiedzi od dyspozytora. Jeśli tak się stanie, spróbuj jechać powoli bliżej sygnalizatora. Powinien dać ci sygnał do jazdy.

# Tworzenie własnych scenariuszy

## Struktura plików

Aby utworzyć własny scenariusz, skopiuj mapę pliku Framework, plik mission.lua oraz plik ScenarioConfig.lua.
Wprowadź zmiany w pliku ScenarioConfig.lua i utwórz własne pliki regionalne i dźwiękowe.

## Pliki scenariuszy

### mission.lua

Nie musisz niczego zmieniać w pliku mission.lua. Wystarczy skopiować go z tego przykładowego scenariusza do własnego.

### ScenarioConfig.lua

W tym pliku konfigurujesz cały scenariusz. Istnieje kilka zmiennych globalnych używanych do definiowania scenariusza. Określają one miejsce i sposób jego rozpoczęcia oraz to, co wydarzy się po drodze do celu.
Poniżej znajduje się opis wszystkich zmiennych, które należy zmienić, aby utworzyć własny scenariusz:

#### Environment

Za pomocą tej zmiennej możesz określić, jak ustawić miesiąc, porę dnia i pogodę. Jeśli określono `Month`, `Hour` i/lub `Weather`, używane są te konkretne wartości. W przeciwnym razie, po ustawieniu `SelectMonth`, `SelectTime` i/lub `SelectWeather` na `true`, gracz zostanie poproszony o wyświetlenie menu rozwijanego, w którym będzie mógł wybrać odpowiednią opcję. Jeśli ustawiono na false, zostanie wybrana losowa wartość.

W tym przykładzie scenariusz rozpocznie się o godzinie 8:00 (wartość stała). Miesiąc zostanie wybrany losowo, a pogoda zostanie ustalona przez użytkownika.

    Environment = { 
        SelectMonth = false, -- Month = 3,
        SelectTime = false, Hour = 8,
        SelectWeather = true, -- Weather = "Snow"
    }

#### PlayerLocomotives

Ta sekcja definiuje lokomotywy, którymi można kierować w scenariuszu. Jeśli zdefiniujesz więcej niż jedną, pojawi się menu rozwijane, w którym możesz wybrać pociąg, którym chcesz jeździć.
Do wyboru są następujące lokomotywy:

- Traxx
- ET22
- EU07
- ED250
- EP08
- EP07
- ET25
- EN57
- EN71
- EN76
- EN96

    PlayerLocomotives = { "Traxx", "ET22", "EU07", "EP07", "ET25" }

#### Scenario

Ta zmienna definiuje możliwe pozycje początkowe w scenariuszu. Na przykład, jeśli scenariusz rozpoczyna się od manewrów, które będą kontynuowane prowadzeniem pociągu, można pominąć część manewrową i wybrać rozpoczęcie od prowadzenia pociągu.
Dla każdego rozpoczęcia scenariusza należy zdefiniować strukturę podobną do poniższej:

    Scenario = {
        { scenarioId = 1, langText = "Scenario1" }
    }

`scenarioId` to po prostu liczba używana w zmiennej `StartAlternatives` poniżej. Może być dowolną wartością, ale nie musi znajdować się w `StartAlternatives`.
`langText` to klucz tekstowy zdefiniowany w pliku `locales/*.lang`, opisujący scenariusz. Ten tekst będzie wyświetlany w menu rozwijanym, jeśli istnieje więcej niż jedna alternatywa do wyboru.

#### BotTrains

Ta zmienna definiuje wszystkie pociągi botów, które będą uczestniczyć w scenariuszu.
Każdy pociąg jest zdefiniowany za pomocą klucza, np. „BotAtLA” poniżej, i ma strukturę z następującymi parametrami:

- `locoName` - Jaka lokomotywa ma zostać wygenerowana. Zobacz `PlayerLocomotives`, aby wyświetlić listę lokomotyw do wyboru.
- `minLength` - Minimalna długość pociągu, wliczając wagony.
- `maxLength` - Maksymalna długość pociągu, wliczając wagony. Rzeczywista długość pociągu będzie liczbą losową z przedziału od długości minimalnej do maksymalnej. Maksymalna masa całkowita również wpłynie na długość.
- `atSignalName` - Nazwa semafora, przy którym zostanie wygenerowany ten pociąg.
- `distance` - Odległość od semafora, przy którym zostanie wygenerowany pociąg.
- `trainState` - Stan używanego składu pociągu (tsTrain lub tsShunting)
- `trainType` - Może być `Cargo` lub `Passenger`.

    BotTrains = {
        ["BotAtLA"] = { locoName = "ET22", minLength = 100, maxLength = 230, atSignalName = "LB_R1", distance = 130, trainState = TrainsetState.tsTrain, trainType = TrainTypes.Cargo },
        ["BotAtLAshunt"] = { locoName = "EU07", minLength = 20, maxLength = 60, atSignalName = "LB_Tm308", distance = 225, trainState = TrainsetState.tsShunting, trainType = TrainTypes.Cargo },
        ["BotArrivingAtLA"] = { locoName = "ED250", minLength = 187, maxLength = 187, atSignalName = "LB_P2", distance = 183, trainState = TrainsetState.tsTrain, trainType = TrainTypes.Passenger },
        ["BotDepartureFromLA"] = { locoName = "EN57", minLength = 187, maxLength = 187, atSignalName = "LB_H2", distance = 170, trainState = TrainsetState.tsTrain, trainType = TrainTypes.Passenger },
        ["BotPassengerAtDZ"] = { locoName = "EN76", minLength = 187, maxLength = 187, atSignalName = "DZ_X", distance = 190, trainState = TrainsetState.tsTrain, trainType = TrainTypes.Passenger },
        ["BotCargoAtLCZ"] = { locoName = "ET25", minLength = 187, maxLength = 450, atSignalName = "LC_Z", distance = 750, trainState = TrainsetState.tsTrain, trainType = TrainTypes.Cargo },
        ["BotAtB"] = { locoName = "EU07", minLength = 200, maxLength = 300, atSignalName = "B_S", distance = 100, trainState = TrainsetState.tsTrain, trainType = TrainTypes.Passenger }
    }

Ta lista pociągów to jedynie szablon możliwych pociągów do utworzenia.
Nie zostaną utworzone tylko dlatego, że zostały tutaj zdefiniowane.
Opis sposobu użycia tych definicji znajduje się w sekcji „Scenariusze botów” poniżej.

#### StartAlternative

W tym miejscu zostanie skonfigurowany stan początkowy scenariusza. Miejsce i stan odrodzenia pociągu gracza. Jaki harmonogram użyć.
Czy pociąg gracza powinien mieć wagony, jak je skonfigurować i jakie pociągi botów mają się pojawić na początku.

Klucz konfiguracji (np. „LATrainReady”) to nazwa stanu scenariusza.

- `scenarioId` - To identyfikator używany w `Scenarios` (patrz sekcja powyżej). Wiele alternatywnych startów może mieć ten sam identyfikator scenariusza. W takim przypadku jeden z nich zostanie wybrany losowo.
- `signal` - Sygnał, przy którym lokomotywa gracza zostanie odtworzona.
- `distance` - Lokomotywa gracza zostanie odtworzona w tej odległości od sygnału.
- `scenarioState` - To nazwa stanu scenariusza. (Patrz `StateMachine` poniżej)
- `radioChannel` - Kanał radiowy, który będzie używany na początku.
- `trainState` - Stan składu pociągu gracza (`tsShunting` lub `tsTrain`)
- `dynamicState` - Dynamiczny stan składu pociągu gracza (np. `dsStop`)
- `trainType` - Określa typ wagonów do utworzenia (`Cargo` lub `Passenger`)
- `welcomeText` - Klucz tekstowy i dźwiękowy dla powitalnego tekstu narratora.
- `playerPosition` - Patrz „znane błędy” poniżej
- `playerInsideTrain` - Czy gracz powinien pojawić się w pociągu (prawda) czy nie (fałsz). Patrz również „znane błędy” poniżej
- `timeTable` - Nazwa pliku rozkładu jazdy, który ma zostać użyty.
- `carriages` - Określa, czy lokomotywa gracza powinna mieć wagony. Pomiń tę część, jeśli wagony nie powinny być używane.
- `carriages.minLength` - Minimalna długość składu pociągu.
- `carriages.maxLength` - Maksymalna długość składu pociągu. Rzeczywista długość składu pociągu będzie kombinacją losowo wybranej długości z przedziału od min do max oraz maksymalnej masy, jaką może pociągnąć wybrana lokomotywa.
- `carriages.maxWeight` - Jeśli pominięto, zostanie użyta masa składu lokomotywy. Jeśli > 0, zostanie użyta wartość rzeczywista. Jeśli < 0, zostanie użyta masa składu lokomotywy - maxWeight.
- `botSetup` - Pociągi botów, które zostaną utworzone podczas uruchamiania. Opis parametrów znajduje się poniżej w sekcji `BotScenarios`. Pomiń tę część, jeśli na początku scenariusza nie mają być tworzone żadne pociągi botów.

    StartAlternatives = {
    ["LATrainReady"] = {
        scenarioId = 2,
        signal = "LB_Tm305",
        distance = 30,
        scenarioState = "LATrainReady",
        radioChannel = 2,
        trainState = TrainsetState.tsShunting,
        dynamicState = DynamicState.dsStop,
        trainType = TrainTypes.Cargo,
        welcomeText = "welcomeText",
        playerPosition = { 15578.27, 337.76, 20606.96 }, 
        playerInsideTrain = true,
        timeTable = "PlayerLBshunt.xml", -- add time table for all and handle in setup
        carriages = {
            minLength = 250,
            maxLength = 300,
            maxWeight = -160
        },
        botSetup = { { BotId = "BotAtLA", create = true, orderType = OrderType.Train, routes = {"LB_R1", "LB_G2kps" }, commands = { BotCommandType.bcDrive } },
                    { BotId = "BotAtLAshunt", create = true, orderType = OrderType.Shunting, routes = {"LB_Tm308", "LB_M4kps" }, commands = { BotCommandType.bcDrive } },
                    }
    }
    }

#### StateMachine

Każdy stan jest definiowany za pomocą klucza, zwanego bieżącą nazwą stanu. Każdy stan scenariusza może mieć wiele wyzwalaczy, ale tylko jeden może zostać wykonany, w zależności od typu wyzwalacza i warunku.
Wykorzystane zostanie pierwsze dopasowanie.
Podczas zmiany stanu na stan docelowy można wykonać listę funkcji. Każdy wyzwalacz ma parametry zdefiniowane poniżej:

- `type` - to rodzaj wyzwalacza, który może zainicjować zmianę stanu. Można użyć sześciu typów wyzwalaczy (Radio, Sygnał, Sprzęganie, Rozsprzęganie lub Ścieżka)
- `condition` - definiuje funkcję, która musi zwrócić wartość true, aby zmiana została wprowadzona
- `transition` - definiuje listę funkcji do wykonania podczas przejścia do nowego stanu
- `targetState` - definiuje stan, który będzie stanem bieżącym po zakończeniu zmiany. Jeśli `targetState` jest listą nazw, jedna z nich zostanie wybrana losowo.
- `alwaysBotCmd` - Jeżeli wartość jest równa prawda, polecenia bota będą zawsze wykonywane, jeżeli takowe istnieją, niezależnie od tego, czy warunek jest prawdziwy, czy nie.

    StateMachine = {
        ["LALocoReady"] =         { { type = TriggerType.Radio,    condition = nil, transition = { SetRoute },                     targetState = "LALocoStartShunting" } },
        ["LALocoStartShunting"] = { { type = TriggerType.Signal,   condition = nil, transition = { SetRoute },                     targetState = "LALocoShunting" } },
        ["LALocoAtWagons"] =      { { type = TriggerType.Coupling, alwaysBotCmd = true, condition = { LeakCheck, BrakeCheck }, transition = nil, targetState = "LATrainReady" } },
        ["LATrainReady"] =        { { type = TriggerType.Radio,    condition = nil, transition = { SetRoute, ChangeWeather },      targetState = "LATrainShunting" } },
        ["LATrainShunting"] =     { { type = TriggerType.Track,    condition = nil, transition = { ChangeTrainStatusToDriving },   targetState = { "AtLC_S6a", "AtLC_S6b" } } },  
        ["AtDZ_Tm12_deco"] =      { { type = TriggerType.Decoupling, condition = nil, transition = nil,                            targetState = "AtDZ_Tm12" } }
    }

#### Routes

Trasy są używane przez funkcję przejścia stanu „SetRoute”.
Każdy scenariusz StateState, który używa funkcji przejścia „SetRoute”, musi mieć wpis w Routes. Patrz StateMachine powyżej.

Używana wartość klucza musi być taka sama, jak ta używana w StateMachine, gdzie używana jest funkcja „SetRoute”.

- `orderType` - Definiuje typ kolejności używany podczas wywoływania VDSetOrder (manewrowanie lub pociąg)
- `route` - Jest listą nazw semaforów, między którymi ma zostać ustawiona trasa.

    Routes = {
        ["LALocoReady"] =         { orderType = OrderType.Shunting, route = { "LB_Tm415", "LB_Tm355", "LB_Tm346", "LB_H308", "LB_Tm205" } },
        ["AtDZ_E2"] =             { orderType = OrderType.Train,    route = { "DZ_E2", "DZ_G9" } }
    }

#### SignalTriggers

Ta struktura definiuje, jakie wyzwalacze sygnału powinny zostać utworzone.
Dla każdego zdefiniowanego typu wyzwalacza „Sygnał” w StateMachine powinien być zdefiniowany jeden wyzwalacz.

- `signal`, `distance` - miejsce umieszczenia wyzwalacza
- `withStartState` - Wyzwalacz zostanie utworzony tylko z tymi stanami początkowymi scenariusza. Jeśli withStartState ma wartość nil, wyzwalacz będzie zawsze używany.
- `waitFunction` - funkcje do wykonania przed zakończeniem wyzwalacza

    SignalTriggers = {
        { signal = "LB_Tm210", distance = 60, withStartState = { "LALocoReady", "LALocoReady2", "LALocoReady3", "LALocoReady4"} },
        { signal = "SG_N7", distance = 50, waitFunction = { TrainTurnedOff, PlayerWalkingOutside } } 
    }

#### TrackTriggers

Ta struktura definiuje, jakie wyzwalacze śledzenia powinny zostać utworzone.
Dla każdego zdefiniowanego typu wyzwalacza „Ścieżka” w StateMachine powinien być zdefiniowany jeden wyzwalacz.

- `track`, `distance`, `direction` - miejsce umieszczenia wyzwalacza
- `waitFunction` - funkcje do wykonania przed zakończeniem wyzwalacza
- `type` - rodzaj wyzwalacza śledzenia. Może to być Back (Tył) lub Front (Przód). (Patrz TrackTriggerType)
- `isPermanent` - jeśli parametr nie jest prawdziwy, wyzwalacz zostanie usunięty po uruchomieniu.
- `lifetime` - używane z wyzwalaczem trwałym. Wyzwalacz zostanie usunięty po określonej liczbie uruchomień.
- `withStartState` - wyzwalacz zostanie utworzony tylko z tymi stanami scenariusza początkowego. Jeśli withStartState ma wartość null, wyzwalacz będzie zawsze używany.

    TrackTriggers = {
        { track = "t13543", distance = 22, direction = 0 }, 
        { track = "t12890", distance = 68, direction = -1, waitFunction = { ChangeDirectionAndShuntToCarriages}, withStartState = { "LALocoReady", "LALocoReady2" , "LALocoReady4", "LALocoReady5"} }, 
        { track = "t26820", distance = 34, direction = -1, waitFunction = { ChangeDirectionAndShuntToCarriages}, type = TrackTriggerType.Back, isPermanent = true, lifetime = 2  } 
    }

#### RadioTriggers

Zdefiniuj wyzwalacz połączenia radiowego.

Na podstawie stanu scenariusza zdefiniuj, co się stanie po naciśnięciu przycisku radiowego.
Każdy stan scenariusza (scenaryState) w StateMachine, gdzie TriggerType to Radio, musi mieć definicję w tabeli RadioTriggers.

- `radioButtons` - Lista przycisków radiowych, których można użyć.
- `chats.source` - Kto mówi (kierowca czy dyspozytor)
- `chats.text` - Klawisz tekstu i dźwięku, który ma zostać użyty.

    RadioTriggers = {
        { "LALocoReady",
            { radioButtons = { 1, 3 },
            chats = { { source = RadioCallers.Driver, text = "DrvTrainReady" },
                        { source = RadioCallers.Dispatcher, text = "DspShuntToCarriages"},
                        { source = RadioCallers.Driver, text = "DrvShuntToCarriages"}
                    }
            }
        }
    }

#### StartCarriages

Wagony, które zostaną utworzone na początku scenariusza. Mogą to być wagony „botów”, nieużywane przez gracza, lub wagony używane przez gracza w trakcie scenariusza.

- `trainType` - Typ wagonów do utworzenia (towarowy lub pasażerski)
- `minLength`, `maxLenght` - Minimalna i maksymalna długość wagonów ustawionych do utworzenia. Rzeczywista długość będzie kombinacją tych wartości i maksymalnej wagi.
- `maxWeight` - Jeśli pominięto, zostanie użyta tylko długość. Jeśli > 0, zostanie użyta wartość rzeczywista. Jeśli < 0, zostanie użyta masa lokomotywy gracza - maxWeight.
- `atSignalName`, `distance` - Miejsce umieszczenia wagonów.
- `trainPhysics` - Może być botem lub graczem i decyduje, jaka fizyka symulacji zostanie użyta.
- `withStartState` - Jeśli określono, te wagony zostaną utworzone tylko dla tych stanów początkowych scenariusza. Jeśli pominięto, będą one generowane dla wszystkich scenariuszy.
- `belongsToPlayerTrain` - Na początku scenariusza pojawi się wyskakujące okienko z informacją o długości i masie pociągu gracza. Ten parametr określa, czy długość i masa wagonów powinny być uwzględniane w pociągu gracza. Można go użyć w scenariuszach, w których gracz rozpoczyna grę od manewrowania do wagonów.

    StartCarriages = {
    { trainType = TrainTypes.Cargo, minLength = 70, maxLength = 100, atSignalName = "LB_Tm304", distance = 60, trainPhysics = TrainPhysics.Bot,
                withStartState = { "LALocoReady", "LALocoReady2", "LALocoReady3", "LALocoReady4", "LALocoReady5", "LATrainReady" } },
        { trainType = TrainTypes.Cargo, maxWeight = -160, minLength = 300, maxLength = 450, atSignalName = "LB_Tm305", distance = 90, trainPhysics = TrainPhysics.Player, belongsToPlayerTrain = true, 
                withStartState = { "LALocoReady", "LALocoReady2", "LALocoReady3", "LALocoReady4", "LALocoReady5"} },
        { trainType = TrainTypes.Cargo, maxWeight = 160, minLength = 50, maxLength = 100, atSignalName = "DZ_G13", distance = 74, trainPhysics = TrainPhysics.Player,
                withStartState = { "LALocoReady", "LALocoReady2", "LALocoReady3", "LALocoReady4", "LALocoReady5", "LATrainReady", "AtDZ_Tm12_deco" } }
    }

#### BotScenarios

Ta zmienna definiuje, co zrobić z pociągami botów podczas scenariusza. Zawiera listę kluczy nazw scenariuszy. Te same nazwy są używane w powyższym StateMachine.
Każdy klucz zawiera listę „akcji bota” zdefiniowanych przez następujące parametry:

- `BotId` - Definiuje, dla którego pociągu bota są przeznaczone te akcje. Patrz `BotTrains` powyżej.
- `orderType` - Typ kolejności VDSetRoute do użycia (pociąg lub manewry)
- `routes` - Lista nazw sygnałów, między którymi powinna zostać ustawiona trasa za pomocą VDSetRoute.
- `commands` - Lista poleceń bota do użycia, np. bcDrive.
- `create` - Ustawiane na true, jeśli pociąg bota powinien zostać uruchomiony.
- `delete` - Ustawiane na true, jeśli pociągi bota powinny zostać usunięte.

    BotScenarios = {
        ["LALocoReady"] = {
            { BotId = "BotAtLA", orderType = OrderType.Train, routes = {"LB_R1", "LB_G2kps" }, commands = { BotCommandType.bcDrive } }
        },
        ["LALocoAtWagons"] = {
            { BotId = "BotAtLAshunt", create = true, commands = { BotCommandType.bcDrive } },
            { BotId = "BotAtLA", delete = true }
        },
        ["LATrainShunting"] = {
            { BotId = "BotArrivingAtLA", create = true, orderType = OrderType.Train, routes = {"LB_P2", "LB_R3" }, commands = { BotCommandType.bcDrive } },
            { BotId = "BotDepartureFromLA", create = true, orderType = OrderType.Train, routes = {"LB_H2", "LB_P2kps" }, commands = { BotCommandType.bcDrive } }
        },
        ["AtDZ_E2"] = {
            { BotId = "BotArrivingAtLA", delete = true },
            { BotId = "BotCargoAtLCZ", delete = true }
        }
    }

### ScenarioTriggers.lua

W pliku `ScenarioConfig.lua` funkcje wyzwalające można wywoływać w różnych sytuacjach. Można je wywoływać ze struktur `StateMachine`, `SignalTriggers` lub `TrackTriggers`.

Istnieje kilka predefiniowanych funkcji wyzwalających, których można użyć, i można je znaleźć poniżej.
Jeśli potrzebujesz zdefiniować własne funkcje wyzwalające, powinny one zostać zdefiniowane w tym pliku. Funkcje są wywoływane z parametrem `trainsetInfo`.

Predefiniowane funkcje to:

- `SetRoute` - Ustawia nową trasę znalezioną w `ScenatioConfig.lua`, zmienna `Routes`.
- `WaitForTrainToStop` - Czeka na zatrzymanie się pociągu.
- `ChangeDirectionAndShunt` - Czeka na zatrzymanie się pociągu, po czym narrator nakazuje graczowi zmianę kierunku i kontynuowanie manewru.
- `ChangeDirectionAndShuntToCarriages` - Czeka, aż pociąg się zatrzyma, po czym narrator każe graczowi zmienić kierunek i kontynuować manewrowanie w kierunku wagonów.
- `TrainTurnedOff` - Czeka, aż lokomotywa zostanie zaparkowana i wyłączona.
- `PlayerWalkingOutside` - Czeka, aż gracz znajdzie się na zewnątrz lokomotywy.
- `EndOfGame` - Zakończono scenariusz.
- `ChangeTrainStatusToDriving` - Zmień status pociągu na jazdę
- `ChangeTrainStatusToShunting` - Zmień status pociągu na manewrowanie
- `ChangeWeather` - Zmień aktualny typ pogody
- `LeakCheck` - Przeprowadź kontrolę szczelności układu hamulcowego
- `BrakeCheck` - Przeprowadź kontrolę układu hamulcowego

### Znane błędy

Gracz nie może pojawić się poza lokomotywą w określonym miejscu. Parametr `playerPosition` w `StartAlternatives` nie ma żadnego efektu lub może spowodować zawieszenie się gry.
