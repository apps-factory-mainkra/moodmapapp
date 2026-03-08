# DOCUMENTO FUNCIONAL: MoodMap

## 1. Resumen Ejecutivo

**Producto:** MoodMap  
**Público objetivo:** Jóvenes adultos (18-35 años) con interés en el bienestar mental, que buscan herramientas sencillas para gestionar su estado de ánimo y encontrar actividades relajantes o motivadoras. Frecuencia: Diaria o varias veces por semana.  
**Problema principal:** Dificultad para identificar patrones en el estado de ánimo y encontrar actividades que realmente mejoren el bienestar, debido a la sobrecarga de información y opciones disponibles.  
**Propuesta de valor:** Ofrece una forma sencilla y visual de registrar el estado de ánimo diario, identificando tendencias y sugiriendo actividades personalizadas basadas en ese estado, sin la complejidad de aplicaciones de mindfulness o terapias online.  
**Modelo de monetización:** Freemium

MoodMap es una aplicación móvil diseñada para resolver un problema específico y recurrente en la vida del usuario objetivo. La propuesta se basa en una experiencia simple, enfocada y diferenciada que proporciona valor en la primera sesión. El objetivo del MVP es validar la hipótesis de mercado, medir retención y determinar si el producto merece inversión adicional.

---

## 2. Contexto del Problema y Oportunidad

### El problema

Dificultad para identificar patrones en el estado de ánimo y encontrar actividades que realmente mejoren el bienestar, debido a la sobrecarga de información y opciones disponibles.

Esta es una necesidad cotidiana, frecuente y claramente reconocible. Los usuarios actuales resuelven esto de forma manual, desorganizada o con herramientas no optimizadas, lo que genera fricción, errores y mala experiencia.

### La oportunidad

La oportunidad existe porque:
- **Audiencia clara:** Jóvenes adultos (18-35 años) con interés en el bienestar mental, que buscan herramientas sencillas para gestionar su estado de ánimo y encontrar actividades relajantes o motivadoras. Frecuencia: Diaria o varias veces por semana.
- **Nicho específico:** Bienestar Mental / Autoayuda
- **Diferenciación:** A diferencia de las apps de meditación que requieren un compromiso a largo plazo, MoodMap se centra en la auto-observación diaria y ofrece sugerencias rápidas y adaptadas al estado de ánimo actual del usuario. No hay contenido extenso ni guías predefinidas; solo recomendaciones basadas en el registro.

Con la tecnología actual (Firebase, Flutter, etc.), es posible construir una solución MVP de forma rápida, elegante y escalable.

---

## 3. Público Objetivo

### Perfil principal

Jóvenes adultos (18-35 años) con interés en el bienestar mental, que buscan herramientas sencillas para gestionar su estado de ánimo y encontrar actividades relajantes o motivadoras. Frecuencia: Diaria o varias veces por semana.

### Comportamiento esperado

El usuario objetivo tiene las siguientes características:
- Necesita resolver el problema de forma recurrente
- Valora rapidez y simplicidad sobre complejidad funcional
- Prefiere experiencias móviles claras
- Tiene baja tolerancia a procesos tediosos

---

## 4. Propuesta de valor

**Ofrece una forma sencilla y visual de registrar el estado de ánimo diario, identificando tendencias y sugiriendo actividades personalizadas basadas en ese estado, sin la complejidad de aplicaciones de mindfulness o terapias online.**

La diferenciación principal es: **A diferencia de las apps de meditación que requieren un compromiso a largo plazo, MoodMap se centra en la auto-observación diaria y ofrece sugerencias rápidas y adaptadas al estado de ánimo actual del usuario. No hay contenido extenso ni guías predefinidas; solo recomendaciones basadas en el registro.**

Esta propuesta posiciona a MoodMap como una solución específica, no genérica. No es una plataforma con múltiples usos ambiguos, sino una herramienta enfocada en un problema concreto.

---

## 5. Objetivos del MVP

### Objetivos de negocio
- Validar que el problema es lo bastante frecuente y relevante
- Conseguir primeras señales de retención y uso recurrente
- Medir disposición a pagar o usar publicidad
- Obtener feedback cualitativo de usuarios reales

### Objetivos del producto
- Resolver el problema principal con el menor esfuerzo del usuario
- Generar valor percibido en la primera sesión
- Facilitar el uso recurrente mediante persistencia y claridad
- Permitir crecimiento futuro sin rehacer la base técnica

---

## 6. Alcance del MVP

### Incluido

Funcionalidades cores:

- Registro Diario de Estado de Ánimo (Escala Visual)
- Sugerencias Personalizadas de Actividades (Lista Corta)
- Visualización de Tendencias del Estado de Ánimo (Gráfico Simple)
- Creación de Listas de Favoritos de Actividades
- Recordatorios para el Registro Diario

### Pantallas iniciales

- **Acceso** (AuthScreen): 
- **Panel Principal** (HomeScreen): 
- **Registro de Estado de Ánimo** (MoodEntryScreen): 
- **Sugerencias de Actividades** (ActivitySuggestionsScreen): 

### Entidades principales

- **User**: Usuario del sistema, con registro de estado de ánimo y preferencias.
- **MoodEntry**: Registro individual del estado de ánimo del usuario en un momento específico.

### Excluido en esta fase

- Personalizaciones avanzadas
- Automatizaciones complejas
- Paneles administrativos
- Integraciones profundas
- Reporting avanzado
- Internacionalización amplia

---

## 7. Flujo Principal del Usuario

### Primera visita

1. **Acceso:** Usuario entiende rápidamente qué hace la app
2. **Registro/Login:** Proceso simple (email/contraseña o TOTP)
3. **Onboarding:** El usuario se registra (Firebase Auth), visualiza una breve introducción a la app y es dirigido al Panel Principal.
4. **Primera acción:** Ejecuta inmediatamente una acción de valor

### Uso recurrente

1. **Acceso:** Abre la app
2. **Visualización:** Ve el estado actual o lista de pendientes
3. **Acción:** Realiza la acción principal
4. **Confirmación:** Obtiene feedback visual de éxito
5. **Salida:** Cierra la app con sensación de progreso

---

## 8. Requisitos Funcionales Prioritarios

1. El usuario puede registrarse o acceder en menos de 1 minuto
2. La acción principal se puede completar en menos de 3 pasos
3. Los datos persisten correctamente entre sesiones
4. Existe feedback visual para toda acción importante
5. El usuario puede salir y volver sin perder contexto

---

## 9. Reglas de Negocio

- **Acceso al valor:** La funcionalidad principal debe ser accesible desde la versión gratuita
- **Monetización clara:** Las limitaciones o features premium deben ser obvias, no sorpresivas
- **Sin fricción artificial:** No bloquear funcionalidades básicas para forzar conversión
- **Notificaciones útiles:** Si existen, deben ser contextuales, no spam

---

## 10. Analítica y Métricas Clave

### Eventos críticos a medir

- `user_registered`
- `first_action_completed`
- `action_repeated`
- `user_day_7_returned`
- `user_day_30_returned`
- `premium_feature_viewed`
- `premium_feature_purchased`

### KPIs objetivo

- **Activación:** 60%+ de usuarios registrados completa la primera acción
- **Retención D1:** 40%+
- **Retención D7:** 25%+
- **Retención D30:** 15%+
- **Conversión premium:** Si aplica, 5%+ de usuarios activos

---

## 11. Monetización

**Modelo:** Freemium

La estrategia es demostrar valor en la capa gratuita y ofrecer features premium que amplíen capacidades sin romper la experiencia base.

---

## 12. Riesgos de Producto y Mitigaciones

### Riesgo 1: Problema insuficientemente doloroso
**Mitigación:** Validar con entrevistas reales antes de escalar inversión

### Riesgo 2: Baja retención
**Mitigación:** Revisar velocidad hasta valor y claridad de propuesta en primeros 60 segundos

### Riesgo 3: Monotización fallida
**Mitigación:** Medir antes de apretar: no bloquear valor principal

---

## 13. Criterios de Aceptación del MVP

- El usuario comprende la propuesta en menos de 10 segundos de apertura
- Puede completar la acción principal sin ambigüedad
- Los datos se persisten correctamente
- El flujo es repetible sin esfuerzo adicional
- Existen eventos analíticos para medir activación y retención

---

## 14. Roadmap Indicativo

### Fase 1: MVP Base (Sprint 1-2)
- Autenticación
- Flujo principal funcional
- Persistencia

### Fase 2: Lanzamiento (Sprint 3)
- Pulido de UX
- Testing en dispositivos reales
- Lanzamiento a App Store / Play Store

### Fase 3: Optimización (Post-lanzamiento)
- Mejora retención y onboarding
- Primeras pruebas de monetización
- Feedback loop con usuarios

---

## 15. Conclusión

MoodMap es viable como MVP porque conecta una audiencia clara con un problema puntual y una solución diferenciada. La recomendación es construir una versión pequeña pero sólida, centrada en el flujo principal, y medir rigurosamente el comportamiento real de usuarios. Si las métricas tempranas acompañan, el producto ofrece una base sólida para evolucionar.

