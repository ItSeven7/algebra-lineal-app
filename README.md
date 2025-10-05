# AlGeneal

Una aplicación Móvil/Web educativa desarrollada en Flutter. Permite a los estudiantes consultar temas y recursos de la materia de álgebra lineal, con autenticación de usuarios en Firebase, seguimiento del progreso y sincronización de datos en tiempo real con Firestore.

---

## Tecnologías

#Flutter #Dart #Firebase


## Características

1. **Creación de cuenta:**
    - Autenticación de usuario con email y contraseña.
    - Perfil del usuario (Nombre y Apellidos).
2. **Navegación del contenido del curso:**
    - Consultar la información en cualquier momento.
    - Buscar por curso, unidad, temas y subtemas.
    - Uso offline. Puedes seguir navegando en el contenido aún sin conexión a internet (la sincronización de datos se hará hasta que te vuelvas a conectar).
3. **Seguimiento del progreso:**
    - Marcar subtemas como completados/vistos.
    - Visualización gráfica del progreso del usuario, desglosado por unidades y temas completados.
    - Guardo automático en la nube.
    - Sincronización de datos en tiempo real.
4. **Personalización:**
    - Elige entre 10 temas para la aplicación.
5. **Diseño simple e intuitivo:**
    - Barra de navegación entre pantallas.
    - Tarjetas con títulos claros y descripciones cortas.
    - Indicadores de progreso en cada tarjeta y subtemas.
    - Animaciones y retroalimentaciones gráficas.
    - Diseño responsivo para móvil (Versión Web).
6. **Multiplataforma:**
    - Móvil: para usuarios de Android.
    - Web: para computadoras de escritorio y laptops. Alternativa para usuarios de iOS.
---

## Organización

La información se organiza en contenidos de cada curso mediante tarjetas, como se muestra a continuación:

- **Curso** (En este caso Álgebra Lineal)
    - **Unidades** (5 unidades)
        - **Temas** (Depende de los temas que contenga cada unidad)
            - **Subtema**
                - **Contenido** (En formato Markdown)
---

## Versión actual

[1.1.4] - 2025-09-26