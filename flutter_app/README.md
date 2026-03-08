# MoodMap - Flutter App

Track your daily mood and discover personalized activities to boost your well-being.

## Descripción

Ofrece una forma sencilla y visual de registrar el estado de ánimo diario, identificando tendencias y sugiriendo actividades personalizadas basadas en ese estado, sin la complejidad de aplicaciones de mindfulness o terapias online.

## Requisitos

- Flutter 3.x
- Dart 3.x
- Firebase project configurado

## Setup

1. Clona el repo
2. `flutter pub get`
3. Copia `.env.example` a `.env` y configura credenciales
4. `flutter run`

## Estructura

- `lib/` - Código fuente
  - `screens/` - Pantallas de la app
  - `services/` - Servicios (Firebase, API)
  - `models/` - Modelos de datos
  - `providers/` - Estado (Riverpod)
  - `config/` - Configuración
  - `utils/` - Utilidades

## Development

```bash
flutter run -d emulator  # Android
flutter run -d simulator # iOS
flutter run -d chrome    # Web
```

## Testing

```bash
flutter test
```

## Deployment

```bash
flutter build apk     # Android
flutter build ios     # iOS
flutter build web     # Web
```
