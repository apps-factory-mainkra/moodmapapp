# DOCUMENTO TÉCNICO: MoodMap

## 1. Resumen Técnico Ejecutivo

**Producto:** MoodMap  
**Stack:** Flutter + Dart (Mobile) | Node.js/Firebase Functions (Backend) | Firestore (Base de datos)  
**Dificultad MVP:** low  
**Complejidad técnica:** Baja

El objetivo técnico es construir una solución pragmática, maintainable y suficientemente escalable para validar MoodMap sin introducir complejidad innecesaria.

---

## 2. Principios Técnicos

- Priorizar simplicidad sobre sofisticación temprana
- Modularidad: separar concerns claramente
- Observabilidad: logs y métricas desde el inicio
- Seguridad: validación en backend, autenticación clara
- Escalabilidad: evitar puntos de estrangulamiento obvios

---

## 3. Arquitectura

### Capas

1. **Presentación:** Flutter app con widgets reutilizables
2. **Lógica:** Providers/BLoC para state management
3. **Datos:** Repositorios con abstracciones
4. **Backend:** Cloud Functions o API simple
5. **Persistencia:** Firestore como la fuente de verdad

### Flujo de datos

```
Flutter UI → Providers/State →  Repositories → 
  Firebase SDK (Auth/Firestore) + API HTTP (si aplica)
```

---

## 4. Stack Tecnológico Elegido

### Flutter (Mobile)
- **Framework:** Flutter 3.x + Dart 3.x
- **State Management:** Riverpod (ligero y poderoso)
- **Networking:** `http` package + custom wrappers
- **Local Storage:** `shared_preferences` para datos simples, Firestore para datos sincronizados
- **Authentication:** `firebase_auth` package

### Backend
- **Opción A:** Cloud Functions for Firebase (Node.js)
- **Opción B:** Simple Node.js + Express si necesitas máximo control
- **Autenticación:** Firebase Auth con reglas de Firestore
- **Base de datos:** Cloud Firestore con reglas de security bien definidas

### DevOps
- **Versionado:** Git + GitHub
- **CI/CD:** GitHub Actions o Firebase Hosting
- **Secrets:** Variables de entorno por archivo `.env`
- **Monitoring:** Firebase Console + Sentry para errores

---

## 5. Modelo de Datos (Firestore)

### Colecciones principales

- **User**: Usuario del sistema, con registro de estado de ánimo y preferencias.
- **MoodEntry**: Registro individual del estado de ánimo del usuario en un momento específico.

### Estructura ejemplo (User)

```
users/{uid}/
  - email: string
  - name: string
  - createdAt: timestamp
  - lastActiveAt: timestamp
```

### Estructura ejemplo para entidad principal

Dependerá de tu caso, pero típicamente:

```
items/{itemId}/
  - userId: string (referencia a usuario)
  - title: string
  - description: string
  - status: enum (pending, completed, archived)
  - createdAt: timestamp
  - updatedAt: timestamp
  - metadata: map (datos adicionales)
```

---

## 6. APIs y Endpoints

### POST /auth/register
Parámetros: `email`, `password`  
Retorna: `{success: bool, userId: string, token: string}`

### POST /auth/login
Parámetros: `email`, `password`  
Retorna: `{success: bool, token: string}`

### GET /items
Auth: Requerida  
Parámetros: `limit`, `offset`  
Retorna: `{items: [{id, title, ...}], total: number}`

### POST /items
Auth: Requerida  
Body: `{title, description, ...}`  
Retorna: `{id, ...item}`

### PUT /items/{itemId}
Auth: Requerida  
Body: `{title?, description?, status?, ...}`  
Retorna: `{success: bool, item}`

### DELETE /items/{itemId}
Auth: Requerida  
Retorna: `{success: bool}`

---

## 7. Autenticación y Autorización

### Flujo de autenticación

1. Usuario ingresa email/contraseña en la app Flutter
2. Firebase Auth valida las credenciales
3. Se emite un ID token
4. La app incluye el token en headers (`Authorization: Bearer <token>`)
5. El backend (o Cloud Functions) valida el token antes de cualquier operación

### Reglas de autorización

- Usuario solo puede ver/editar sus propios items
- El servidor valida la propiedad en cada operación
- El cliente NO confía en lo que es de su propiedad

---

## 8. Requisitos No Funcionales

### Rendimiento
- Carga inicial: < 2 segundos
- Operación principal: < 500ms
- Paginación: para listas > 20 items

### Escalabilidad
- Firestore escala automáticamente
- Cloud Functions escalan bajo demanda
- Caché local en Flutter para offline support básico

### Seguridad
- Todas las requests validadas en backend
- Secretos en .env, no en código fuente
- HTTPS obligatorio
- Rate limiting en endpoints sensibles

### Disponibilidad
- Firebase ofrece 99.95% de SLA
- Backups automáticos en Firestore
- Logs centralizados en Firebase Console

---

## 9. Estrategia de Testing

### Unit Tests
- Validadores de input
- Parsers de datos
- Lógica de dominio

### Widget Tests (Flutter)
- Componentes reutilizables
- Flujos críticos de UI

### Integration Tests
- Autenticación end-to-end
- Crear item → guardar → listar
- Persistencia en Firestore

### Testing Manual
- Offline/online transitions
- Errores de red
- Sesiones expiradas
- Múltiples dispositivos

---

## 10. Despliegue

### Backend (Cloud Functions)
```bash
firebase deploy --only functions
```

### Mobile (TestFlight/Google Play)
```bash
flutter build ios/ipa
flutter build appbundle
# Upload a TestFlight/Play Console
```

### Variables por entorno

`.env.development`:
```
FIREBASE_PROJECT_ID=project-dev
API_BASE_URL=http://localhost:5001
```

`.env.production`:
```
FIREBASE_PROJECT_ID=project-prod
API_BASE_URL=https://api.example.com
```

---

## 11. Riesgos Técnicos y Mitigaciones

### Riesgo 1: Modelo de datos mal diseñado
**Mitigación:** Validar schema antes de implementar a fondo. Firestore permite migración pero es costosa.

### Riesgo 2: Seguridad débil
**Mitigación:** Validar TODAS las requests en backend. Usar tipos conocidos (TypeScript).

### Riesgo 3: Offline sync complejo
**Mitigación:** MVP con offline read-only. Sync bidireccional va en fase 2.

---

## 12. Checklist Pre-Producción

- [ ] Autenticación funcional
- [ ] Reglas de Firestore correctas y testeadas
- [ ] Logging centralizado
- [ ] Error handling en todos los endpoints
- [ ] Rate limiting
- [ ] Validación de entrada
- [ ] Tests de integración pasando
- [ ] Documentación de secrets .env
- [ ] Backup strategy definida
- [ ] Runbook de incident

---

## 13. Deuda Técnica Aceptable

Es OK posponer:
- Optimizaciones de extrema escala
- Panel administrativo completo
- Sync offline bidireccional
- Machine learning / algoritmos avanzados
- Caching sophisticado

No es OK posponer:
- Autenticación y autorización
- Validación de datos
- Manejo de errores
- Logging básico

---

## 14. Conclusión

La arquitectura propuesta balancear velocidad y solidez. El objetivo es un MVP pragmático, medible y escalable sin sobrecarga técnica. Firebase + Flutter + Node.js  es una combinación probada que permite iterar rápido y escalar sin rehacer todo.

