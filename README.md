# Catbreeds

App en Flutter que lista razas de gatos consumiendo [TheCatAPI](https://developers.thecatapi.com/). Permite buscar razas en inglés y ver el detalle de cada una.

## Pantallas

- **Splash:** título "CatBreeds" con la imagen de un gato.
- **Landing:** listado de razas en cards con paginación al hacer scroll y un buscador que consulta mientras se escribe.
- **Detalle:** nombre de la raza en la AppBar y la imagen fija arriba. Debajo, la información de la raza con scroll: país de origen, tiempo de vida, peso, altura, temperamento, descripción e historia.

## Requisitos

- Flutter 3.38 o superior (Dart `^3.10.0`)
- Un emulador o dispositivo Android / iOS

## Cómo ejecutarla

```bash
git clone https://github.com/NataliaDS24/cat_breeds_app.git
cd cat_breeds_app
flutter pub get
flutter run -t lib/main_development.dart
```

El punto de entrada es `lib/main_development.dart`, no `lib/main.dart`. En VS Code también se puede usar la configuración **catbreeds** de `.vscode/launch.json`.

### Variables de entorno

La app lee la URL base y la API key desde `.env_development`, que ya viene incluido en el repositorio con la key entregada en la prueba. Para usar otra key, edita ese archivo siguiendo `.env_example`:

```env
BASE_URL=https://api.thecatapi.com/v1/
API_KEY=your_api_key
```

La key se envía en el header `x-api-key` de cada petición.

## Arquitectura

El proyecto sigue Clean Architecture, con `provider` para el manejo de estado:

```
lib/
├── config/          # Colores, textos, estilos, tema, rutas y variables de entorno
├── core/
│   ├── network/     # Cliente Dio, endpoints y logger
│   └── utils/       # Extensiones (bandera del país, temperamento, etc.)
├── data/
│   ├── datasources/ # Llamadas a TheCatAPI
│   ├── models/      # Conversión del JSON a entidades
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/ # Contratos
│   └── usecases/     # GetBreedsUseCase, SearchBreedsUseCase
├── presentation/
│   ├── screens/     # Splash, home y detalle, cada una con su provider
│   └── widgets/
└── injection_container.dart
```

## Decisiones técnicas

- **Paginación:** las razas se piden de 10 en 10 (`/breeds?page=&limit=`) y la siguiente página se carga al acercarse al final de la lista.
- **Imágenes:** la URL de la imagen se toma del campo `image.url` que ya viene en `/breeds`, sin una petición extra por raza. Las imágenes se guardan en caché en memoria y en disco con `cached_network_image`. Si una raza no tiene imagen o la imagen falla, se muestra una imagen por defecto.
- **Búsqueda:** usa `/breeds/search?q=`, así que busca entre todas las razas y no solo entre las ya cargadas. Espera 400 ms desde la última tecla antes de consultar y descarta las respuestas de búsquedas anteriores que lleguen tarde.

## Pruebas

```bash
flutter test
```

Hay pruebas unitarias del repositorio (`test/data/`) y del `HomeProvider` (`test/presentation/`). Cubren la paginación, la búsqueda con debounce, el descarte de respuestas viejas y el manejo de errores. Usan `mocktail` para simular las dependencias y `fake_async` para controlar el tiempo.
